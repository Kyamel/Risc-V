`timescale 1ns / 1ps

module tb_ex_branch;

    // Entradas
    reg  [31:0] pc_in;
    reg  [31:0] rs1_data_in;
    reg  [31:0] rs2_data_in;
    reg  [31:0] immediate_in;
    reg  [3:0]  rs1_addr;
    reg  [3:0]  rs2_addr;
    reg  [3:0]  rd_addr_in;
    reg  [15:0] control_signals;
    reg  [1:0]  forward_a;
    reg  [1:0]  forward_b;
    reg  [31:0] mem_forward_data;
    reg  [31:0] wb_forward_data;

    // Saídas
    wire [31:0] alu_result;
    wire [31:0] branch_target;
    wire branch_taken;
    wire [31:0] rs2_data_out;
    wire [3:0]  rd_addr_out;
    wire [31:0] pc_plus4_out;
    wire [7:0]  control_signals_out;

    ex_stage uut (
        .pc_in(pc_in),
        .rs1_data_in(rs1_data_in),
        .rs2_data_in(rs2_data_in),
        .immediate_in(immediate_in),
        .rs1_addr(rs1_addr),
        .rs2_addr(rs2_addr),
        .rd_addr_in(rd_addr_in),
        .control_signals(control_signals),
        .forward_a(forward_a),
        .forward_b(forward_b),
        .mem_forward_data(mem_forward_data),
        .wb_forward_data(wb_forward_data),
        .alu_result(alu_result),
        .branch_target(branch_target),
        .branch_taken(branch_taken),
        .rs2_data_out(rs2_data_out),
        .rd_addr_out(rd_addr_out),
        .pc_plus4_out(pc_plus4_out),
        .control_signals_out(control_signals_out)
    );

    task test_branch;
        input [2:0] funct3;        // Tipo de branch
        input [31:0] rs1, rs2;     // Dados dos registradores
        input        expected_taken;
        begin
            // Setup
            pc_in = 32'h1000;
            immediate_in = {17'd0, funct3, 12'd4};  // só importa funct3 para debug visual
            rs1_data_in = rs1;
            rs2_data_in = rs2;
            control_signals = 16'b0000000000010000; // branch = 1
            forward_a = 2'b00;
            forward_b = 2'b00;

            #1;
            if (branch_taken !== expected_taken) begin
                $display("\033[31mFAIL\033[0m: funct3=%b rs1=%0d rs2=%0d => branch_taken=%b (esperado %b)",
                        funct3, rs1, rs2, branch_taken, expected_taken);
                $fatal(1, "Teste falhou");
            end else begin
                $display("\033[32mPASS\033[0m: funct3=%b rs1=%0d rs2=%0d => branch_taken=%b",
                        funct3, rs1, rs2, branch_taken);
            end
        end
    endtask

    initial begin
        $display("\n== Teste de Branch na EX Stage ==\n");

        test_branch(3'b000, 10, 10, 1);   // BEQ
        test_branch(3'b000, 10, 11, 0);   // BEQ
        test_branch(3'b001, 10, 11, 1);   // BNE
        test_branch(3'b001, 12, 12, 0);   // BNE
        test_branch(3'b100, -5, 2, 1);    // BLT
        test_branch(3'b100, 4, -1, 0);    // BLT
        test_branch(3'b101, 5, 5, 1);     // BGE
        test_branch(3'b101, 7, -1, 1);    // BGE
        test_branch(3'b110, 3, 9, 1);     // BLTU
        test_branch(3'b110, 9, 3, 0);     // BLTU
        test_branch(3'b111, 6, 6, 1);     // BGEU
        test_branch(3'b111, 8, 2, 1);     // BGEU

        $display("\n== Fim dos testes ==\n");
        $finish;
    end
endmodule
