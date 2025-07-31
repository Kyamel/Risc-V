`timescale 1ns/1ps
`include "core/constants.v"

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
            // Formato B: imm[12|10:5] rs2 rs1 funct3 imm[4:1|11] opcode
            id_ex_instruction = {imm[12], imm[10:5], 5'b00001, 5'b00010, funct3, imm[4:1], imm[11], 7'b1100011};
            id_ex_control_signals = 0;
            id_ex_control_signals[`CTRL_BRANCH] = 1'b1;
            #10;

            total = total + 1;
            if (pc_src === expected) begin
                $display("\033[32m[PASS]\033[0m %s (PC: 0x%h, New PC: 0x%h)", desc, pc, new_pc);
                passed = passed + 1;
            end else begin
                $display("\033[31m[FAIL]\033[0m %s (got %b, expected %b, PC: 0x%h)", desc, pc_src, expected, pc);
            end
        end
    endtask

    task test_jump;
        input [31:0] pc;
        input [31:0] imm;
        input [127:0] desc;
        begin
            id_ex_pc = pc;
            id_ex_immediate = imm;
            // Formato J: imm[20|10:1|11|19:12] rd opcode
            id_ex_instruction = {imm[20], imm[10:1], imm[11], imm[19:12], 5'b00001, 7'b1101111};
            id_ex_control_signals = 0;
            id_ex_control_signals[`CTRL_JUMP] = 1'b1;
            #10;

            total = total + 1;
            if (pc_src === 1'b1 && new_pc === (pc + imm)) begin
                $display("\033[32m[PASS]\033[0m %s (PC: 0x%h, New PC: 0x%h)", desc, pc, new_pc);
                passed = passed + 1;
            end else begin
                $display("\033[31m[FAIL]\033[0m %s (PC: 0x%h)", desc, pc);
            end
        end
    endtask

    initial begin
        $display("=== Testando Unidade de Branch ===");
        $display("");

        // Testes BEQ (funct3 = 000)
        test_branch(32'h00001000, 32'd10, 32'd10, `BRANCH_EQ, 32'h40, 1, "BEQ: 10 == 10");
        test_branch(32'h00001004, 32'd10, 32'd5, `BRANCH_EQ, 32'h40, 0, "BEQ: 10 != 5");

        // Testes BNE (funct3 = 001)
        test_branch(32'h00001008, 32'd10, 32'd5, `BRANCH_NE, 32'h40, 1, "BNE: 10 != 5");
        test_branch(32'h0000100C, 32'd10, 32'd10, `BRANCH_NE, 32'h40, 0, "BNE: 10 == 10");

        // Testes BLT (funct3 = 100)
        test_branch(32'h00001010, -32'd2, 32'd3, `BRANCH_LT, 32'h40, 1, "BLT: -2 < 3 (signed)");
        test_branch(32'h00001014, 32'd5, -32'd1, `BRANCH_LT, 32'h40, 0, "BLT: 5 !< -1 (signed)");

        // Testes BGE (funct3 = 101)
        test_branch(32'h00001018, 32'd7, 32'd7, `BRANCH_GE, 32'h40, 1, "BGE: 7 >= 7");
        test_branch(32'h0000101C, -32'd1, -32'd2, `BRANCH_GE, 32'h40, 1, "BGE: -1 >= -2");

        // Testes BLTU (funct3 = 110)
        test_branch(32'h00001020, 32'd10, 32'd20, `BRANCH_LTU, 32'h40, 1, "BLTU: 10 < 20 (unsigned)");
        test_branch(32'h00001024, 32'd20, 32'd10, `BRANCH_LTU, 32'h40, 0, "BLTU: 20 !< 10 (unsigned)");

        // Testes BGEU (funct3 = 111)
        test_branch(32'h00001028, 32'd15, 32'd15, `BRANCH_GEU, 32'h40, 1, "BGEU: 15 >= 15 (unsigned)");
        test_branch(32'h0000102C, 32'd50, 32'd20, `BRANCH_GEU, 32'h40, 1, "BGEU: 50 >= 20 (unsigned)");

        // Testes JAL
        test_jump(32'h00001030, 32'h100, "JAL: PC + 0x100");
        test_jump(32'h00001034, -32'h80, "JAL: PC - 0x80");

        $display("");
        $display("=== Resultados ===");
        if (passed == total) begin
            $display("\033[32m[PASS]: Todos os %0d testes passaram!\033[0m", total);
        end else begin
            $display("\033[31m[FAILED]: %0d de %0d testes passaram.\033[0m", passed, total);
        end

        $display("");
        $finish;
    end
endmodule