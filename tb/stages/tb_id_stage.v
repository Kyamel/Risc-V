`timescale 1ns / 1ps
`include "constants.v"

module tb_id_stage();

    // Inputs
    reg clk;
    reg reset;
    reg stall;
    reg flush;
    reg if_id_valid;
    reg [31:0] if_id_pc;
    reg [31:0] if_id_instruction;
    reg [31:0] rs1_data;
    reg [31:0] rs2_data;
    reg [4:0] mem_wb_rd_addr;
    reg [31:0] mem_wb_rd_data;
    reg mem_wb_reg_write;

    // Outputs
    wire [4:0] rs1_addr;
    wire [4:0] rs2_addr;
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

    // Instantiate the Unit Under Test (UUT)
    id_stage uut (
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
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // ANSI color codes
    localparam COLOR_RED = "\033[1;31m";
    localparam COLOR_GREEN = "\033[1;32m";
    localparam COLOR_YELLOW = "\033[1;33m";
    localparam COLOR_RESET = "\033[0m";

    reg [`CONTROL_SIGNALS_WIDTH-1:0] expected_ctrl;

    // Enhanced check task
    task check;
        input string test_name;
        input [4:0] exp_rd_addr;
        input [4:0] exp_rs1_addr;
        input [4:0] exp_rs2_addr;
        input [31:0] exp_rs1_data;
        input [31:0] exp_rs2_data;
        input [31:0] exp_immediate;
        input [`CONTROL_SIGNALS_WIDTH-1:0] exp_control_signals;
        input exp_valid;
    begin
        if (id_ex_rd_addr !== exp_rd_addr || 
            id_ex_rs1_addr !== exp_rs1_addr ||
            id_ex_rs2_addr !== exp_rs2_addr ||
            id_ex_rs1_data !== exp_rs1_data ||
            id_ex_rs2_data !== exp_rs2_data ||
            id_ex_immediate !== exp_immediate ||
            id_ex_control_signals !== exp_control_signals ||
            id_ex_valid !== exp_valid) begin
            
            $display("%s[FAIL]%s %s:", COLOR_RED, COLOR_RESET, test_name);
            $display("  Expected: RD=%0d, RS1=%0d, RS2=%0d", exp_rd_addr, exp_rs1_addr, exp_rs2_addr);
            $display("            RS1_data=0x%h, RS2_data=0x%h", exp_rs1_data, exp_rs2_data);
            $display("            Imm=0x%h, Ctrl=0x%h, Valid=%b", 
                    exp_immediate, exp_control_signals, exp_valid);
            $display("  Got:      RD=%0d, RS1=%0d, RS2=%0d", 
                    id_ex_rd_addr, id_ex_rs1_addr, id_ex_rs2_addr);
            $display("            RS1_data=0x%h, RS2_data=0x%h", 
                    id_ex_rs1_data, id_ex_rs2_data);
            $display("            Imm=0x%h, Ctrl=0x%h, Valid=%b", 
                    id_ex_immediate, id_ex_control_signals, id_ex_valid);
        end else begin
            $display("%s[PASS]%s %s", COLOR_GREEN, COLOR_RESET, test_name);
        end
    end
    endtask

    // Test procedure
    initial begin
        // Initialize Inputs
        reset = 1;
        stall = 0;
        flush = 0;
        if_id_valid = 0;
        if_id_pc = 0;
        if_id_instruction = 0;
        rs1_data = 0;
        rs2_data = 0;
        mem_wb_rd_addr = 0;
        mem_wb_rd_data = 0;
        mem_wb_reg_write = 0;

        // Wait for global reset
        #20;
        reset = 0;
        if_id_valid = 1;

        // Test 1: ADDI instruction (I-type)
        $display("\n%sTest 1: ADDI x1, x0, 10%s", COLOR_YELLOW, COLOR_RESET);
        if_id_instruction = 32'h00A00093; // ADDI x1, x0, 10
        if_id_pc = 32'h00000004;
        rs1_data = 32'h00000000; // x0 value
        #10;
        
        // Create expected control signals for ADDI
        
        expected_ctrl = 0;
        expected_ctrl[`CTRL_REG_WRITE] = 1'b1;
        expected_ctrl[`CTRL_ALU_SRC] = 1'b1;
        expected_ctrl[`CTRL_ALU_OP] = `ALU_ADD;
        
        check("ADDI x1, x0, 10",
              5'b00001,    // rd_addr
              5'b00000,   // rs1_addr
              5'b00000,   // rs2_addr (unused)
              32'h00000000, // rs1_data (x0)
              32'h00000000, // rs2_data (unused)
              32'h0000000A, // immediate
              expected_ctrl, // control signals
              1'b1        // valid
        );

        // Test 2: ADD instruction (R-type)
        $display("\n%sTest 2: ADD x2, x1, x3%s", COLOR_YELLOW, COLOR_RESET);
        if_id_instruction = 32'h003100B3; // ADD x2, x1, x3
        if_id_pc = 32'h00000008;
        rs1_data = 32'h0000000A; // x1 value
        rs2_data = 32'h00000014; // x3 value
        #10;
        
        // Create expected control signals for ADD
        expected_ctrl = 0;
        expected_ctrl[`CTRL_REG_WRITE] = 1'b1;
        expected_ctrl[`CTRL_ALU_OP] = `ALU_ADD;
        
        check("ADD x2, x1, x3",
              5'b00010,    // rd_addr
              5'b00001,    // rs1_addr
              5'b00011,    // rs2_addr
              32'h0000000A, // rs1_data (x1)
              32'h00000014, // rs2_data (x3)
              32'h00000000, // immediate (unused)
              expected_ctrl, // control signals
              1'b1        // valid
        );

        // Test 3: Bypass test (writeback to rs1)
        $display("\n%sTest 3: Register Bypass (WB to RS1)%s", COLOR_YELLOW, COLOR_RESET);
        if_id_instruction = 32'h00110133; // ADD x2, x2, x1
        if_id_pc = 32'h0000000C;
        mem_wb_rd_addr = 5'b00001;    // x1 being written
        mem_wb_rd_data = 32'h0000001E; // new x1 value
        mem_wb_reg_write = 1'b1;
        rs1_data = 32'h0000000A;     // old x1 value (should be bypassed)
        rs2_data = 32'h00000014;     // x3 value
        #10;
        
        // Create expected control signals for ADD
        expected_ctrl = 0;
        expected_ctrl[`CTRL_REG_WRITE] = 1'b1;
        expected_ctrl[`CTRL_ALU_OP] = `ALU_ADD;
        
        check("Bypass Test (WB to RS1)",
              5'b00010,    // rd_addr
              5'b00001,    // rs1_addr
              5'b00010,    // rs2_addr
              32'h0000001E, // rs1_data (bypassed value)
              32'h00000014, // rs2_data
              32'h00000000, // immediate (unused)
              expected_ctrl, // control signals
              1'b1        // valid
        );

        // Test 4: Stall test
        $display("\n%sTest 4: Pipeline Stall%s", COLOR_YELLOW, COLOR_RESET);
        stall = 1'b1;
        if_id_instruction = 32'h00410113; // ADDI x2, x2, 4
        if_id_pc = 32'h00000010;
        #10;
        
        // Should maintain previous values during stall
        check("Pipeline Stall",
              5'b00010,    // rd_addr (previous)
              5'b00001,    // rs1_addr (previous)
              5'b00010,    // rs2_addr (previous)
              32'h0000001E, // rs1_data (previous)
              32'h00000014, // rs2_data (previous)
              32'h00000000, // immediate (previous)
              expected_ctrl, // control signals (previous)
              1'b1        // valid (previous)
        );

        // Test 5: Flush test
        $display("\n%sTest 5: Pipeline Flush%s", COLOR_YELLOW, COLOR_RESET);
        stall = 1'b0;
        flush = 1'b1;
        if_id_instruction = 32'h00410113; // ADDI x2, x2, 4
        if_id_pc = 32'h00000010;
        #10;
        
        // Should insert NOP (all zeros except valid)
        check("Pipeline Flush",
              5'b00000,    // rd_addr (NOP)
              5'b00000,    // rs1_addr (NOP)
              5'b00000,    // rs2_addr (NOP)
              32'h00000000, // rs1_data (NOP)
              32'h00000000, // rs2_data (NOP)
              32'h00000000, // immediate (NOP)
              `CONTROL_SIGNALS_WIDTH'b0, // control signals (NOP)
              1'b0        // valid (NOP)
        );

        // Finish simulation
        #10;
        $display("\n%sID Stage Tests Complete%s", COLOR_YELLOW, COLOR_RESET);
        $finish;
    end

    // Monitor changes
    initial begin
        $display("Time\tPC\t\tInstruction\t\tRD\tRS1\tRS2\tImmediate");
        $monitor("%0t\t%h\t%h\t%0d\t%0d\t%0d\t%h", 
                $time, if_id_pc, if_id_instruction,
                id_ex_rd_addr, id_ex_rs1_addr, id_ex_rs2_addr, id_ex_immediate);
    end

endmodule