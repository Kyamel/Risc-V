`timescale 1ns / 1ps

module tb_id_stage;

    // Entradas
    reg clk = 0, rst = 0;
    reg [31:0] instruction;
    reg [31:0] pc;
    reg [31:0] rs1_data, rs2_data;
    reg [3:0] wb_rd_addr;
    reg [31:0] wb_data;
    reg wb_reg_write;

    // Saídas
    wire [3:0] rs1_addr, rs2_addr;
    wire [15:0] control_signals;
    wire [31:0] immediate;
    wire [3:0] rd_addr;
    wire [31:0] rs1_data_out, rs2_data_out;

    // DUT
    id_stage dut (
        .clk(clk), .rst(rst),
        .instruction(instruction), .pc(pc),
        .rs1_addr(rs1_addr), .rs2_addr(rs2_addr),
        .rs1_data(rs1_data), .rs2_data(rs2_data),
        .wb_rd_addr(wb_rd_addr), .wb_data(wb_data), .wb_reg_write(wb_reg_write),
        .control_signals(control_signals),
        .immediate(immediate), .rd_addr(rd_addr),
        .rs1_data_out(rs1_data_out), .rs2_data_out(rs2_data_out)
    );

    // Clock
    always #5 clk = ~clk;
    integer err = 0;

    // Task para testar instruções de branch
    task test_branch;
        input [2:0] funct3;        // Tipo de branch
        input [31:0] rs1_val;      // Valor para rs1
        input [31:0] rs2_val;      // Valor para rs2
        input [31:0] imm_val;      // Valor do imediato
        input expected_branch;     // Sinal de branch esperado
        begin
            // Monta a instrução (opcode BRANCH = 7'b1100011)
            instruction = {imm_val[11], imm_val[4:1], imm_val[10:5], 
                          rs2_addr, rs1_addr, funct3, imm_val[0], 7'b1100011};
            
            rs1_data = rs1_val;
            rs2_data = rs2_val;
            
            #10;
            
            // Verifica se o sinal de branch está correto
            if (control_signals[7] !== expected_branch) begin
                $display("\033[31mFAIL\033[0m: funct3=%b rs1=%0d rs2=%0d imm=%0d => branch=%b (esperado %b)",
                        funct3, rs1_val, rs2_val, imm_val, 
                        control_signals[7], expected_branch);
                err = err + 1;

            end else begin
                $display("\033[32mPASS\033[0m: funct3=%b rs1=%0d rs2=%0d imm=%0d => branch=%b",
                        funct3, rs1_val, rs2_val, imm_val, control_signals[7]);
            end
            
            // Verifica se o imediato foi calculado corretamente
            if (immediate !== { {20{imm_val[11]}}, imm_val[11:0] }) begin
                $display("\033[33mWARNING\033[0m: Immediate calculado incorretamente para branch");
            end
        end
    endtask

    initial begin
        $display("==== ID_STAGE TEST BEGIN ====");
        rst = 1;
        instruction = 32'b0;
        pc = 32'h0;
        rs1_data = 32'hAAAA0000;
        rs2_data = 32'hBBBB1111;
        wb_data = 32'hCCCC2222;
        wb_rd_addr = 4'h2;
        wb_reg_write = 0;
        #10;

        rst = 0;

        // Teste 1: instrução do tipo I (ADDI x3, x2, 0x10)
        instruction = {12'h010, 5'd2, 3'b000, 5'd3, 7'b0010011}; // ADDI x3, x2, 0x10
        rs1_data = 32'h12345678;
        rs2_data = 32'hDEADBEEF;
        wb_rd_addr = 4'hF;
        wb_reg_write = 0;
        #10;
        $display("\nADDI Test:");
        $display(" rs1_addr = %0d (expect 2)", rs1_addr);
        $display(" rd_addr  = %0d (expect 3)", rd_addr);
        $display(" imm      = 0x%h (expect 10h)", immediate);

        // Teste 2: forwarding ativo
        instruction = {12'h000, 5'd2, 3'b000, 5'd2, 7'b0010011}; // ADDI x2, x2, 0
        rs1_data = 32'h00000000;
        rs2_data = 32'h11111111;
        wb_rd_addr = 4'd2;
        wb_data = 32'hCAFEBABE;
        wb_reg_write = 1;
        #10;
        $display("\nForwarding Test:");
        $display(" rs1_data_out = 0x%h (expect CAFEBABE)", rs1_data_out);

        // Teste 3: instruções de branch
        $display("\n=== Branch Instruction Tests ===");
        
        // BEQ (funct3=000)
        test_branch(3'b000, 10, 10, 12'h4, 1'b1);  // rs1 == rs2 => branch
        test_branch(3'b000, 10, 11, 12'h4, 1'b1);  // rs1 != rs2 => no branch
        
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
         if (err > 0) begin
            $display("❌ %0d teste(s) falharam", err);
            $fatal(1, "Erros nos testes");
        end else begin
            $display("✅ Todos os testes passaram!");
            $finish;
        end
    end

endmodule