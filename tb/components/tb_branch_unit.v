`timescale 1ns/1ps
`include "constants.v"

// Definindo cores ANSI no escopo global
`define RED     "\033[1;31m"
`define GREEN   "\033[1;32m"
`define RESET   "\033[0m"

module tb_branch;

    // Sinais do pipeline
    reg [31:0] id_ex_pc;
    reg [31:0] id_ex_instruction;
    reg [31:0] id_ex_rs1_data;
    reg [31:0] id_ex_rs2_data;
    reg [31:0] id_ex_immediate;
    reg [`CONTROL_SIGNALS_WIDTH-1:0] id_ex_control_signals;
    
    // Saídas
    wire pc_src;
    wire [31:0] new_pc;
    wire flush;

    // Instância do módulo a ser testado
    branch_unit uut (
        .id_ex_pc(id_ex_pc),
        .id_ex_instruction(id_ex_instruction),
        .id_ex_rs1_data(id_ex_rs1_data),
        .id_ex_rs2_data(id_ex_rs2_data),
        .id_ex_immediate(id_ex_immediate),
        .id_ex_control_signals(id_ex_control_signals),
        .pc_src(pc_src),
        .new_pc(new_pc),
        .flush(flush)
    );

    integer passed = 0;
    integer total = 0;

    task test_branch;
        input [31:0] pc;
        input [31:0] rs1, rs2;
        input [2:0] funct3;
        input [31:0] imm;
        input expected;
        input [127:0] desc;
        begin
            id_ex_pc = pc;
            id_ex_rs1_data = rs1;
            id_ex_rs2_data = rs2;
            id_ex_immediate = imm;
            id_ex_instruction = {7'b0, 5'b0, 5'b0, 3'b0, 5'b0, funct3, 5'b0, 7'b1100011}; // Formato B
            id_ex_control_signals = 0;
            id_ex_control_signals[`IS_BRANCH] = 1'b1;
            #10;

            total = total + 1;
            if (pc_src === expected) begin
                $write(`GREEN, "[PASS]", `RESET);
                $display(" %s (PC: 0x%h, New PC: 0x%h)", desc, pc, new_pc);
                passed = passed + 1;
            end else begin
                $write(`RED, "[FAIL]", `RESET);
                $display(" %s (got %b, expected %b, PC: 0x%h)", desc, pc_src, expected, pc);
            end
        end
    endtask

    initial begin
        $display("=== Testando Unidade de Branch ===");
        $display("");

        // Testes BEQ (funct3 = 000)
        test_branch(32'h00001000, 32'd10, 32'd10, 3'b000, 32'h40, 1, "BEQ: 10 == 10");
        test_branch(32'h00001004, 32'd10, 32'd5, 3'b000, 32'h40, 0, "BEQ: 10 != 5");

        // Testes BNE (funct3 = 001)
        test_branch(32'h00001008, 32'd10, 32'd5, 3'b001, 32'h40, 1, "BNE: 10 != 5");
        test_branch(32'h0000100C, 32'd10, 32'd10, 3'b001, 32'h40, 0, "BNE: 10 == 10");

        // Testes BLT (funct3 = 100)
        test_branch(32'h00001010, -32'd2, 32'd3, 3'b100, 32'h40, 1, "BLT: -2 < 3 (signed)");
        test_branch(32'h00001014, 32'd5, -32'd1, 3'b100, 32'h40, 0, "BLT: 5 !< -1 (signed)");

        // Testes BGE (funct3 = 101)
        test_branch(32'h00001018, 32'd7, 32'd7, 3'b101, 32'h40, 1, "BGE: 7 >= 7");
        test_branch(32'h0000101C, -32'd1, -32'd2, 3'b101, 32'h40, 1, "BGE: -1 >= -2");

        // Testes BLTU (funct3 = 110)
        test_branch(32'h00001020, 32'd10, 32'd20, 3'b110, 32'h40, 1, "BLTU: 10 < 20 (unsigned)");
        test_branch(32'h00001024, 32'd20, 32'd10, 3'b110, 32'h40, 0, "BLTU: 20 !< 10 (unsigned)");

        // Testes BGEU (funct3 = 111)
        test_branch(32'h00001028, 32'd15, 32'd15, 3'b111, 32'h40, 1, "BGEU: 15 >= 15 (unsigned)");
        test_branch(32'h0000102C, 32'd50, 32'd20, 3'b111, 32'h40, 1, "BGEU: 50 >= 20 (unsigned)");

        $display("");
        $display("=== Resultados ===");
        if (passed == total) begin
            $write(`GREEN);
            $display("[PASS]: Todos os %0d testes passaram!", total);
            $write(`RESET);
        end else begin
            $write(`RED);
            $display("[FAILED]: %0d de %0d testes passaram.", passed, total);
            $write(`RESET);
        end

        $display("");
        $finish;
    end
endmodule