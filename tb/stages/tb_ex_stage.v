`timescale 1ns / 1ps
`include "core/constants.v"

module tb_ex_branch;

    // Clock and reset
    reg clk;
    reg reset;
    
    // Entradas do registro ID/EX
    reg [31:0] id_ex_pc;
    reg [31:0] id_ex_instruction;
    reg [31:0] id_ex_rs1_data;
    reg [31:0] id_ex_rs2_data;
    reg [31:0] id_ex_immediate;
    reg [4:0] id_ex_rd_addr;
    reg [4:0] id_ex_rs1_addr;
    reg [4:0] id_ex_rs2_addr;
    reg [`CONTROL_SIGNALS_WIDTH-1:0] id_ex_control_signals;
    reg id_ex_valid;
    
    // Sinais de forwarding
    reg [1:0] forward_a;
    reg [1:0] forward_b;
    reg [31:0] mem_wb_alu_result;
    reg [31:0] mem_wb_mem_data;
    
    // Saídas
    wire [31:0] ex_mem_alu_result_fwd;
    wire branch_taken;
    wire [31:0] branch_target;

    // Instantiate the EX stage
    ex_stage uut (
        .clk(clk),
        .reset(reset),
        .id_ex_pc(id_ex_pc),
        .id_ex_instruction(id_ex_instruction),
        .id_ex_rs1_data(id_ex_rs1_data),
        .id_ex_rs2_data(id_ex_rs2_data),
        .id_ex_immediate(id_ex_immediate),
        .id_ex_rd_addr(id_ex_rd_addr),
        .id_ex_rs1_addr(id_ex_rs1_addr),
        .id_ex_rs2_addr(id_ex_rs2_addr),
        .id_ex_control_signals(id_ex_control_signals),
        .id_ex_valid(id_ex_valid),
        .forward_a(forward_a),
        .forward_b(forward_b),
        .mem_wb_alu_result(mem_wb_alu_result),
        .mem_wb_mem_data(mem_wb_mem_data),
        .ex_mem_alu_result_fwd(ex_mem_alu_result_fwd),
        .branch_taken(branch_taken),
        .branch_target(branch_target)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    task test_branch;
        input [2:0] funct3;        // Tipo de branch
        input [31:0] rs1, rs2;     // Dados dos registradores
        input expected_taken;
        begin
            // Setup
            reset = 1;
            id_ex_pc = 32'h1000;
            id_ex_instruction = {12'b0, 5'b0, funct3, 5'b0, 7'b1100011}; // BRANCH opcode
            id_ex_rs1_data = rs1;
            id_ex_rs2_data = rs2;
            id_ex_immediate = 32'd4;
            id_ex_control_signals = 0;
            id_ex_control_signals[`CTRL_BRANCH] = 1;
            forward_a = 2'b00;
            forward_b = 2'b00;
            mem_wb_alu_result = 0;
            mem_wb_mem_data = 0;
            id_ex_valid = 1;
            
            #10 reset = 0;
            #10;
            
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

        // Wait for reset
        #20;
        
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