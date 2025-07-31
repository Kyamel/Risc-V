`timescale 1ns / 1ps
`include "constants.v"

module tb_pipeline_stages();

    // Clock and reset
    reg clk;
    reg reset;
    
    // Control signals
    reg stall;
    reg flush;
    reg pc_src;
    reg [31:0] new_pc;
    
    // Memory interface (simulated)
    wire [31:0] imem_addr;
    reg [31:0] imem_data;
    wire imem_read;
    
    // Register file interface
    wire [4:0] rs1_addr;
    wire [4:0] rs2_addr;
    reg [31:0] rs1_data;
    reg [31:0] rs2_data;
    
    // Writeback simulation
    reg [4:0] mem_wb_rd_addr;
    reg [31:0] mem_wb_rd_data;
    reg mem_wb_reg_write;
    
    // Forwarding signals (disabled for basic test)
    reg [1:0] forward_a;
    reg [1:0] forward_b;
    reg [31:0] mem_wb_alu_result;
    reg [31:0] mem_wb_mem_data;
    
    // IF/ID pipeline registers
    wire [31:0] if_id_pc;
    wire [31:0] if_id_instruction;
    wire if_id_valid;
    
    // ID/EX pipeline registers
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
    
    // EX/MEM pipeline registers
    wire [31:0] ex_mem_pc;
    wire [31:0] ex_mem_alu_result;
    wire [31:0] ex_mem_rs2_data;
    wire [4:0] ex_mem_rd_addr;
    wire [`CONTROL_SIGNALS_WIDTH-1:0] ex_mem_control_signals;
    wire ex_mem_valid;
    
    // EX stage outputs
    wire [31:0] ex_mem_alu_result_fwd;
    wire branch_taken;
    wire [31:0] branch_target;
    
    // Instantiate IF stage
    if_stage if_stage_inst (
        .clk(clk),
        .reset(reset),
        .stall(stall),
        .flush(flush),
        .pc_src(pc_src),
        .new_pc(new_pc),
        .imem_addr(imem_addr),
        .imem_read(imem_read),
        .imem_data(imem_data),
        .if_id_pc(if_id_pc),
        .if_id_instruction(if_id_instruction),
        .if_id_valid(if_id_valid)
    );
    
    // Instantiate ID stage
    id_stage id_stage_inst (
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
    
    // Instantiate EX stage
    ex_stage ex_stage_inst (
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
        .ex_mem_pc(ex_mem_pc),
        .ex_mem_alu_result(ex_mem_alu_result),
        .ex_mem_rs2_data(ex_mem_rs2_data),
        .ex_mem_rd_addr(ex_mem_rd_addr),
        .ex_mem_control_signals(ex_mem_control_signals),
        .ex_mem_valid(ex_mem_valid),
        .ex_mem_alu_result_fwd(ex_mem_alu_result_fwd),
        .branch_taken(branch_taken),
        .branch_target(branch_target)
    );
    
    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns period
    end
    
    // Test variables
    integer cycle_count;
    reg [31:0] expected_result;
    
    // Main test sequence
    initial begin
        $dumpfile("pipeline_stages.vcd");
        $dumpvars(0, tb_pipeline_stages);
        
        // Initialize signals
        reset = 1;
        stall = 0;
        flush = 0;
        pc_src = 0;
        new_pc = 32'h00000000;
        imem_data = 32'h00000013; // NOP initially
        
        // Initialize register file data
        rs1_data = 32'h00000000;
        rs2_data = 32'h00000000;
        
        // Initialize writeback (no writeback initially)
        mem_wb_rd_addr = 5'b00000;
        mem_wb_rd_data = 32'h00000000;
        mem_wb_reg_write = 1'b0;
        
        // Initialize forwarding (no forwarding initially)
        forward_a = 2'b00;
        forward_b = 2'b00;
        mem_wb_alu_result = 32'h00000000;
        mem_wb_mem_data = 32'h00000000;
        
        cycle_count = 0;
        
        // Reset sequence
        #10;
        reset = 0;
        #10;
        
        $display("=== Pipeline Stages Test Started ===");
        $display("Testing IF -> ID -> EX stages with specific instructions");
        $display();
        
        // Test 1: ADD instruction (R-type)
        // add x3, x1, x2 = 0x002081B3
        // rs1=x1(1), rs2=x2(2), rd=x3(3), funct3=000, funct7=0000000
        test_add_instruction();
        
        // Test 2: ADDI instruction (I-type)  
        // addi x4, x1, 100 = 0x06408213
        // rs1=x1(1), rd=x4(4), imm=100, funct3=000
        test_addi_instruction();
        
        // Test 3: Load instruction (I-type)
        // lw x5, 8(x1) = 0x0080A283
        // rs1=x1(1), rd=x5(5), offset=8, funct3=010
        test_load_instruction();
        
        $display();
        $display("=== All Tests Completed ===");
        
        #50;
        $finish;
    end
    
    // Task to test ADD instruction
    task test_add_instruction();
        begin
            $display("--- Test 1: ADD Instruction ---");
            
            // Set up register values for x1 and x2
            rs1_data = 32'h00000015; // x1 = 21
            rs2_data = 32'h0000000A; // x2 = 10
            expected_result = 32'h0000001F; // Expected: 21 + 10 = 31
            
            // ADD x3, x1, x2 (0x002081B3)
            imem_data = 32'h002081B3;
            
            // Simulate register file lookups
            #10; // Wait for IF stage
            
            // Check IF stage
            wait_cycles(1);
            check_if_stage(32'h00000000, 32'h002081B3);
            
            // Check ID stage 
            wait_cycles(1);
            check_id_stage_add();
            
            // Check EX stage
            wait_cycles(1);
            check_ex_stage_add();
            
            $display("ADD test completed\n");
        end
    endtask
    
    // Task to test ADDI instruction
    task test_addi_instruction();
        begin
            $display("--- Test 2: ADDI Instruction ---");
            
            // Set up register value for x1
            rs1_data = 32'h00000014; // x1 = 20
            expected_result = 32'h00000078; // Expected: 20 + 100 = 120
            
            // ADDI x4, x1, 100 (0x06408213)
            imem_data = 32'h06408213;
            
            #10; // Wait for IF stage
            
            // Check IF stage
            wait_cycles(1);
            check_if_stage(32'h00000004, 32'h06408213);
            
            // Check ID stage
            wait_cycles(1);
            check_id_stage_addi();
            
            // Check EX stage
            wait_cycles(1);
            check_ex_stage_addi();
            
            $display("ADDI test completed\n");
        end
    endtask
    
    // Task to test Load instruction
    task test_load_instruction();
        begin
            $display("--- Test 3: Load Instruction ---");
            
            // Set up register value for x1 (base address)
            rs1_data = 32'h00001000; // x1 = 0x1000
            expected_result = 32'h00001008; // Expected address: 0x1000 + 8 = 0x1008
            
            // LW x5, 8(x1) (0x0080A283)
            imem_data = 32'h0080A283;
            
            #10; // Wait for IF stage
            
            // Check IF stage
            wait_cycles(1);
            check_if_stage(32'h00000008, 32'h0080A283);
            
            // Check ID stage
            wait_cycles(1);
            check_id_stage_load();
            
            // Check EX stage
            wait_cycles(1);
            check_ex_stage_load();
            
            $display("Load test completed\n");
        end
    endtask
    
    // Helper tasks
    task wait_cycles(input integer cycles);
        integer i;
        begin
            for (i = 0; i < cycles; i = i + 1) begin
                @(posedge clk);
                cycle_count = cycle_count + 1;
            end
        end
    endtask
    
    task check_if_stage(input [31:0] expected_pc, input [31:0] expected_instr);
        begin
            $display("Cycle %0d - IF Stage:", cycle_count);
            $display("  PC: 0x%08h (expected: 0x%08h) %s", 
                if_id_pc, expected_pc, (if_id_pc == expected_pc) ? "✓" : "✗");
            $display("  Instruction: 0x%08h (expected: 0x%08h) %s", 
                if_id_instruction, expected_instr, (if_id_instruction == expected_instr) ? "✓" : "✗");
            $display("  Valid: %b", if_id_valid);
        end
    endtask
    
    task check_id_stage_add();
        begin
            $display("Cycle %0d - ID Stage (ADD):", cycle_count);
            $display("  PC: 0x%08h", id_ex_pc);
            $display("  RS1 addr: %0d, RS2 addr: %0d, RD addr: %0d", 
                id_ex_rs1_addr, id_ex_rs2_addr, id_ex_rd_addr);
            $display("  RS1 data: 0x%08h, RS2 data: 0x%08h", 
                id_ex_rs1_data, id_ex_rs2_data);
            $display("  Control signals: 0x%05h", id_ex_control_signals);
            $display("  RegWrite: %b, ALU_OP: 0x%h, ALU_Src: %b", 
                id_ex_control_signals[`CTRL_REG_WRITE],
                id_ex_control_signals[`CTRL_ALU_OP],
                id_ex_control_signals[`CTRL_ALU_SRC]);
        end
    endtask
    
    task check_id_stage_addi();
        begin
            $display("Cycle %0d - ID Stage (ADDI):", cycle_count);
            $display("  PC: 0x%08h", id_ex_pc);
            $display("  RS1 addr: %0d, RD addr: %0d", id_ex_rs1_addr, id_ex_rd_addr);
            $display("  RS1 data: 0x%08h, Immediate: 0x%08h", 
                id_ex_rs1_data, id_ex_immediate);
            $display("  Control signals: 0x%05h", id_ex_control_signals);
            $display("  RegWrite: %b, ALU_OP: 0x%h, ALU_Src: %b", 
                id_ex_control_signals[`CTRL_REG_WRITE],
                id_ex_control_signals[`CTRL_ALU_OP],
                id_ex_control_signals[`CTRL_ALU_SRC]);
        end
    endtask
    
    task check_id_stage_load();
        begin
            $display("Cycle %0d - ID Stage (Load):", cycle_count);
            $display("  PC: 0x%08h", id_ex_pc);
            $display("  RS1 addr: %0d, RD addr: %0d", id_ex_rs1_addr, id_ex_rd_addr);
            $display("  RS1 data: 0x%08h, Immediate: 0x%08h", 
                id_ex_rs1_data, id_ex_immediate);
            $display("  Control signals: 0x%05h", id_ex_control_signals);
            $display("  MemRead: %b, RegWrite: %b, ALU_Src: %b", 
                id_ex_control_signals[`CTRL_MEM_READ],
                id_ex_control_signals[`CTRL_REG_WRITE],
                id_ex_control_signals[`CTRL_ALU_SRC]);
        end
    endtask
    
    task check_ex_stage_add();
        begin
            $display("Cycle %0d - EX Stage (ADD):", cycle_count);
            $display("  ALU Result: 0x%08h (expected: 0x%08h) %s", 
                ex_mem_alu_result_fwd, expected_result, 
                (ex_mem_alu_result_fwd == expected_result) ? "✓" : "✗");
            $display("  RD addr: %0d", ex_mem_rd_addr);
            $display("  Branch taken: %b", branch_taken);
        end
    endtask
    
    task check_ex_stage_addi();
        begin
            $display("Cycle %0d - EX Stage (ADDI):", cycle_count);
            $display("  ALU Result: 0x%08h (expected: 0x%08h) %s", 
                ex_mem_alu_result_fwd, expected_result, 
                (ex_mem_alu_result_fwd == expected_result) ? "✓" : "✗");
            $display("  RD addr: %0d", ex_mem_rd_addr);
        end
    endtask
    
    task check_ex_stage_load();
        begin
            $display("Cycle %0d - EX Stage (Load):", cycle_count);
            $display("  Address Calculation: 0x%08h (expected: 0x%08h) %s", 
                ex_mem_alu_result_fwd, expected_result, 
                (ex_mem_alu_result_fwd == expected_result) ? "✓" : "✗");
            $display("  RD addr: %0d", ex_mem_rd_addr);
        end
    endtask
    
    // Monitor key signals during simulation
    always @(posedge clk) begin
        if (!reset) begin
            $display("Cycle %0d:", cycle_count);
            $display("  IF: PC=0x%08h, Instr=0x%08h, Valid=%b", 
                if_id_pc, if_id_instruction, if_id_valid);
            if (id_ex_valid) begin
                $display("  ID: PC=0x%08h, RS1=%0d(0x%08h), RS2=%0d(0x%08h), RD=%0d", 
                    id_ex_pc, id_ex_rs1_addr, id_ex_rs1_data, 
                    id_ex_rs2_addr, id_ex_rs2_data, id_ex_rd_addr);
            end
            if (ex_mem_valid) begin
                $display("  EX: ALU=0x%08h, RD=%0d", 
                    ex_mem_alu_result_fwd, ex_mem_rd_addr);
            end
            $display("");
        end
    end

endmodule