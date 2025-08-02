`timescale 1ns / 1ps

module tb_processor_load_and_fetch();

    // System signals
    reg clk;
    reg reset;

    // IF stage signals
    reg stall;
    reg flush;
    reg pc_src;
    reg [31:0] new_pc;
    
    // Instruction memory interface
    wire [31:0] imem_addr;
    wire imem_read;
    wire [31:0] imem_data;
    
    // IF/ID pipeline register outputs
    wire [31:0] if_id_pc;
    wire [31:0] if_id_instruction;
    wire if_id_valid;
    
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

    // Instruction Memory
    instruction_memory #(
        .DEPTH(1024),
        .INIT_FILE("compiler/program.hex")
    ) imem (
        .clk(clk),
        .reset(reset),
        .addr(imem_addr),
        .data_out(imem_data),
        .read_en(imem_read),
        .debug_addr(debug_pc),
        .debug_data_out(debug_imem_out)
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
        
        // Apply reset
        #20;
        reset = 0;
        
        // Now fetch each instruction through the IF stage
        $display("\n[TEST] Fetching instructions through IF stage:");
        
        // Fetch 16 instructions (4 bytes each)
        for (integer i = 0; i < 16; i = i + 1) begin
            // Wait for positive edge to capture fetch
            @(posedge clk);
            #1; // Small delay to allow signals to stabilize
            
            $display("  Fetch Cycle %0d:", i);
            $display("    PC out: %h", imem_addr);
            $display("    Instruction read: %h", imem_data);
            $display("    IF/ID Pipeline Register:");
            $display("      PC: %h", if_id_pc);
            $display("      Instruction: %h", if_id_instruction);
            $display("      Valid: %b", if_id_valid);
            
            // Wait for next cycle
            #9;
        end
        
        // Display all register values
        $display("\n[TEST] Register contents after fetching:");
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
        $display("\nTime\tPC\t\tInstruction\tIF/ID PC\tIF/ID Instr");
        $monitor("%0t\t%h\t%h\t%h\t%h", 
                $time, imem_addr, imem_data, if_id_pc, if_id_instruction);
    end

endmodule