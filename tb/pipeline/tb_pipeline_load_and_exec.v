`timescale 1ns / 1ps

module tb_processor_load_and_fetch();

    // System signals
    reg clk;
    reg reset;

    // Pipeline control signals
    reg stall;
    reg flush;
    reg pc_src;
    reg [31:0] new_pc;
    
    // Instruction memory interface
    wire [31:0] imem_addr;
    wire imem_read;
    wire [31:0] imem_data;
    
    // Pipeline registers
    wire [31:0] if_id_pc;
    wire [31:0] if_id_instruction;
    wire if_id_valid;
    
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
    
    wire [31:0] ex_mem_pc;
    wire [31:0] ex_mem_alu_result;
    wire [31:0] ex_mem_rs2_data;
    wire [4:0] ex_mem_rd_addr;
    wire [`CONTROL_SIGNALS_WIDTH-1:0] ex_mem_control_signals;
    wire ex_mem_valid;
    wire [31:0] ex_mem_alu_result_fwd;
    wire branch_taken;
    wire [31:0] branch_target;

    // Forwarding signals
    reg [1:0] forward_a;
    reg [1:0] forward_b;
    reg [31:0] mem_wb_alu_result;
    reg [31:0] mem_wb_mem_data;
    
    // Debug interface
    reg debug_en;
    reg [31:0] debug_addr;
    reg [31:0] debug_data_in;
    reg debug_write_en;
    wire [31:0] debug_data_out;

    // Register file interface
    wire [4:0] rs1_addr;
    wire [4:0] rs2_addr;
    wire [31:0] rs1_data;
    wire [31:0] rs2_data;
    wire [4:0] rd_addr;
    wire [31:0] rd_data;
    wire reg_write;
    
    // Debug registers output
    wire [31:0] debug_registers [0:31];

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

    // Instantiate instruction memory
    instruction_memory imem (
        .clk(clk),
        .reset(reset),
        .addr(imem_addr),
        .data_out(imem_data),
        .read_en(imem_read),
        .debug_en(debug_en),
        .debug_addr(debug_addr),
        .debug_data_in(debug_data_in),
        .debug_write_en(debug_write_en),
        .debug_data_out(debug_data_out)
    );

    // Instantiate register file
    register_file reg_file (
        .clk(clk),
        .reset(reset),
        .rs1_addr(rs1_addr),
        .rs2_addr(rs2_addr),
        .rs1_data(rs1_data),
        .rs2_data(rs2_data),
        .rd_addr(rd_addr),
        .rd_data(rd_data),
        .reg_write(reg_write),
        .debug_registers(debug_registers)
    );

    // Instantiate ID stage
    id_stage instruction_decode (
        .clk(clk),
        .reset(reset),
        .stall(stall),
        .flush(flush),
        .if_id_pc(if_id_pc),
        .if_id_instruction(if_id_instruction),
        .if_id_valid(if_id_valid),
        .mem_wb_rd_addr(rd_addr),
        .mem_wb_rd_data(rd_data),
        .mem_wb_reg_write(reg_write),
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
        .rs1_addr(rs1_addr),
        .rs2_addr(rs2_addr),
        .rs1_data(rs1_data),
        .rs2_data(rs2_data)
    );
    
    // Instantiate EX stage
    ex_stage execute (
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
        .ex_mem_pc(ex_mem_pc),
        .ex_mem_alu_result(ex_mem_alu_result),
        .ex_mem_rs2_data(ex_mem_rs2_data),
        .ex_mem_rd_addr(ex_mem_rd_addr),
        .ex_mem_control_signals(ex_mem_control_signals),
        .ex_mem_valid(ex_mem_valid),
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

    // Test procedure
    initial begin
        // Initialize signals
        reset = 1;
        stall = 0;
        flush = 0;
        pc_src = 0;
        new_pc = 0;
        debug_en = 0;
        debug_addr = 0;
        debug_data_in = 0;
        debug_write_en = 0;
        forward_a = 0;
        forward_b = 0;
        mem_wb_alu_result = 0;
        mem_wb_mem_data = 0;
        
        // Apply reset
        #20;
        reset = 0;
        
        // Now execute through pipeline stages
        $display("\n[TEST] Executing pipeline stages:");
        
        // Execute 16 cycles
        for (integer i = 0; i < 16; i = i + 1) begin
            @(posedge clk);
            #1; // Small delay for signal stabilization
            
            $display("\n[Cycle %0d] Pipeline State:", i);
            
            // IF Stage
            $display("  IF Stage:");
            $display("    PC:        %h", imem_addr);
            $display("    Instr:     %h", imem_data);
            $display("    IF/ID PC:  %h", if_id_pc);
            
            // ID Stage
            if (if_id_valid) begin
                $display("  ID Stage:");
                $display("    Instr:     %h", if_id_instruction);
                $display("    RS1:       x%0d = %h", rs1_addr, rs1_data);
                $display("    RS2:       x%0d = %h", rs2_addr, rs2_data);
                $display("    Control:   %b", id_ex_control_signals);
            end
            
            // EX Stage
            if (id_ex_valid) begin
                $display("  EX Stage:");
                $display("    Instr:     %h", id_ex_instruction);
                $display("    ALU Result:%h", ex_mem_alu_result_fwd);
                $display("    Branch:    %b (Target: %h)", branch_taken, branch_target);
                $display("    RD:        x%0d", ex_mem_rd_addr);
            end
            
            #9; // Complete the cycle
        end
        
        // Display all register values
        $display("\n[TEST] Register contents after execution:");
        for (integer i = 0; i < 32; i = i + 1) begin
            $display("  x%0d: %h", i, debug_registers[i]);
        end
        
        // Simulation complete
        #100;
        $display("\n[TEST] Simulation complete");
        $finish;
    end

    // Monitor changes
    initial begin
        $display("\nTime\tPC\t\tInstruction");
        $monitor("%0t\t%h\t%h", $time, imem_addr, imem_data);
    end

endmodule