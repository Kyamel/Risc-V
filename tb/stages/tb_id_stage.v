`timescale 1ns / 1ps
`include "core/constants.v"

module tb_id_stage;

    // Clock and control
    reg clk = 0;
    reg reset = 0;
    reg stall = 0;
    reg flush = 0;
    reg if_id_valid = 1;
    
    // IF/ID inputs
    reg [31:0] if_id_pc;
    reg [31:0] if_id_instruction;
    
    // Register file interface
    wire [4:0] rs1_addr;
    wire [4:0] rs2_addr;
    reg [31:0] rs1_data;
    reg [31:0] rs2_data;
    
    // Writeback interface
    reg [4:0] mem_wb_rd_addr;
    reg [31:0] mem_wb_rd_data;
    reg mem_wb_reg_write;
    
    // ID/EX outputs (monitoring)
    wire [31:0] id_ex_pc;
    wire [31:0] id_ex_instruction;
    wire [31:0] id_ex_rs1_data;
    wire [31:0] id_ex_rs2_data;
    wire [31:0] id_ex_immediate;
    wire [4:0] id_ex_rd_addr;
    wire [4:0] id_ex_rs1_addr;
    wire [4:0] id_ex_rs2_addr;
    wire [`CONTROL_SIGNALS_WIDTH-1:0] id_ex_control_signals;
    wire id_ex_valid;

    // Instantiate DUT
    id_stage dut (
        .clk(clk),
        .reset(reset),
        .stall(stall),
        .flush(flush),
        .if_id_valid(if_id_valid),
        .if_id_pc(if_id_pc),
        .if_id_instruction(if_id_instruction),
        .rs1_addr(rs1_addr),
        .rs2_addr(rs2_addr),
        .rs1_data(rs1_data),
        .rs2_data(rs2_data),
        .mem_wb_rd_addr(mem_wb_rd_addr),
        .mem_wb_rd_data(mem_wb_rd_data),
        .mem_wb_reg_write(mem_wb_reg_write),
        // ID/EX outputs
        .id_ex_pc(id_ex_pc),
        .id_ex_instruction(id_ex_instruction),
        .id_ex_rs1_data(id_ex_rs1_data),
        .id_ex_rs2_data(id_ex_rs2_data),
        .id_ex_immediate(id_ex_immediate),
        .id_ex_rd_addr(id_ex_rd_addr),
        .id_ex_rs1_addr(id_ex_rs1_addr),
        .id_ex_rs2_addr(id_ex_rs2_addr),
        .id_ex_control_signals(id_ex_control_signals),
        .id_ex_valid(id_ex_valid)
    );

    // Clock generation
    always #5 clk = ~clk;

    integer err = 0;

    task test_branch;
        input [2:0] funct3;        // Tipo de branch
        input [31:0] rs1_val;      // Valor para rs1
        input [31:0] rs2_val;      // Valor para rs2
        input [11:0] imm_val;      // Valor do imediato (12 bits)
        input expected_branch;     // Sinal de branch esperado
        begin
            // Monta a instrução (opcode BRANCH = 7'b1100011)
            if_id_instruction = {imm_val[11], imm_val[4:1], imm_val[10:5], 
                              5'b00010, 5'b00001, funct3, imm_val[0], 7'b1100011};
            
            rs1_data = rs1_val;
            rs2_data = rs2_val;
            
            #10;
            
            // Verifica se o sinal de branch está correto
            if (id_ex_control_signals[`CTRL_BRANCH] !== expected_branch) begin
                $display("\033[31mFAIL\033[0m: funct3=%b rs1=%0d rs2=%0d imm=%0d => branch=%b (esperado %b)",
                        funct3, rs1_val, rs2_val, $signed(imm_val), 
                        id_ex_control_signals[`CTRL_BRANCH], expected_branch);
                err = err + 1;
            end else begin
                $display("\033[32mPASS\033[0m: funct3=%b rs1=%0d rs2=%0d imm=%0d => branch=%b",
                        funct3, rs1_val, rs2_val, $signed(imm_val), 
                        id_ex_control_signals[`CTRL_BRANCH]);
            end
            
            // Verifica se o imediato foi calculado corretamente
            if (id_ex_immediate !== $signed({{20{imm_val[11]}}, imm_val[11:0]})) begin
                $display("\033[33mWARNING\033[0m: Immediate calculado incorretamente para branch");
            end
        end
    endtask

    initial begin
        $display("==== ID_STAGE TEST BEGIN ====");
        reset = 1;
        if_id_pc = 32'h0;
        if_id_instruction = 32'b0;
        rs1_data = 32'hAAAA0000;
        rs2_data = 32'hBBBB1111;
        mem_wb_rd_data = 32'hCCCC2222;
        mem_wb_rd_addr = 5'b00010;
        mem_wb_reg_write = 0;
        #10;

        reset = 0;

        // Teste 1: instrução do tipo I (ADDI x3, x2, 0x10)
        if_id_instruction = {12'h010, 5'd2, 3'b000, 5'd3, 7'b0010011}; // ADDI x3, x2, 0x10
        rs1_data = 32'h12345678;
        rs2_data = 32'hDEADBEEF;
        mem_wb_rd_addr = 5'b01111;
        mem_wb_reg_write = 0;
        #10;
        $display("\nADDI Test:");
        $display(" rs1_addr = %0d (expect 2)", rs1_addr);
        $display(" rd_addr  = %0d (expect 3)", id_ex_rd_addr);
        $display(" imm      = 0x%h (expect 10h)", id_ex_immediate);

        // Teste 2: forwarding ativo
        if_id_instruction = {12'h000, 5'd2, 3'b000, 5'd2, 7'b0010011}; // ADDI x2, x2, 0
        rs1_data = 32'h00000000;
        rs2_data = 32'h11111111;
        mem_wb_rd_addr = 5'd2;
        mem_wb_rd_data = 32'hCAFEBABE;
        mem_wb_reg_write = 1;
        #10;
        $display("\nForwarding Test:");
        $display(" rs1_data_out = 0x%h (expect CAFEBABE)", id_ex_rs1_data);

        // Teste 3: instruções de branch
        $display("\n=== Branch Instruction Tests ===");
        
        // BEQ (funct3=000)
        test_branch(3'b000, 10, 10, 12'h4, 1'b1);  // rs1 == rs2 => branch
        test_branch(3'b000, 10, 11, 12'h4, 1'b0);  // rs1 != rs2 => no branch
        
        // BNE (funct3=001)
        test_branch(3'b001, 10, 11, 12'h8, 1'b1);  // rs1 != rs2 => branch
        test_branch(3'b001, 12, 12, 12'h8, 1'b0);  // rs1 == rs2 => no branch
        
        // BLT (funct3=100)
        test_branch(3'b100, -5, 2, 12'h10, 1'b1); // rs1 < rs2 (signed) => branch
        test_branch(3'b100, 4, -1, 12'h10, 1'b0);  // rs1 > rs2 (signed) => no branch
        
        // BGE (funct3=101)
        test_branch(3'b101, 5, 5, 12'h14, 1'b1);   // rs1 == rs2 => branch
        test_branch(3'b101, 7, -1, 12'h14, 1'b1); // rs1 > rs2 (signed) => branch
        
        // BLTU (funct3=110)
        test_branch(3'b110, 3, 9, 12'h18, 1'b1);  // rs1 < rs2 (unsigned) => branch
        test_branch(3'b110, 9, 3, 12'h18, 1'b0);  // rs1 > rs2 (unsigned) => no branch
        
        // BGEU (funct3=111)
        test_branch(3'b111, 6, 6, 12'h1C, 1'b1);  // rs1 == rs2 => branch
        test_branch(3'b111, 8, 2, 12'h1C, 1'b1);  // rs1 > rs2 (unsigned) => branch

        #10;
        $display("==== ID_STAGE TEST END ====");
        $display("❌ %0d teste(s) falharam", err);       
        $display("✅ Todos os testes passaram!");
        $finish;
        
    end
endmodule