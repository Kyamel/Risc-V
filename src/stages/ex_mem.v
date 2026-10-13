`timescale 1ns / 1ps

module ex_mem (
    input wire         clk,
    input wire         rst,
    input wire         stall,              // Hold the current values
    input wire         flush,              // Insert a bubble

    // Control signals from EX
    input wire         ex_Branch,
    input wire         ex_Jump,
    input wire         ex_MemRead,
    input wire         ex_MemWrite,
    input wire         ex_RegWrite,
    input wire         ex_MemtoReg,

    // Data from EX
    input wire [31:0]  ex_adder_out,       // Branch/jump target
    input wire [31:0]  ex_result,          // Result (ALU, or PC + 4 for JAL/JALR)
    input wire         ex_alu_zero,        // ALU result is zero
    input wire [4:0]   ex_rd,              // Destination register
    input wire [31:0]  ex_read_data_2_mux, // Store data (rs2 after forwarding)

    // To MEM
    output reg [31:0]  mem_addr,           // Result; also the data memory address
    output reg         mem_alu_zero,
    output reg [31:0]  mem_write_data,     // Store data
    output reg [4:0]   mem_rd,             // Destination register (for WB and forwarding)
    output reg [31:0]  mem_adder_out,      // Branch/jump target

    // Control signals for MEM
    output reg        mem_Branch,
    output reg        mem_Jump,
    output reg        mem_MemRead,
    output reg        mem_MemWrite,

    // Control signals for WB (passed through MEM)
    output reg        mem_RegWrite,
    output reg        mem_MemtoReg
);

    always @(posedge clk or posedge rst) begin
        if (rst || flush) begin
            mem_addr       <= 32'b0;
            mem_write_data <= 32'b0;
            mem_rd         <= 5'b0;
            mem_adder_out  <= 32'b0;

            mem_Branch     <= 1'b0;
            mem_Jump       <= 1'b0;
            mem_MemRead    <= 1'b0;
            mem_MemWrite   <= 1'b0;
            mem_RegWrite   <= 1'b0;
            mem_MemtoReg   <= 1'b0;
        end
        else if (!stall) begin
            mem_addr       <= ex_result;
            mem_write_data <= ex_read_data_2_mux;
            mem_rd         <= ex_rd;
            mem_adder_out  <= ex_adder_out;
            mem_alu_zero   <= ex_alu_zero;

            mem_Branch     <= ex_Branch;
            mem_Jump       <= ex_Jump;
            mem_MemRead    <= ex_MemRead;
            mem_MemWrite   <= ex_MemWrite;
            mem_RegWrite   <= ex_RegWrite;
            mem_MemtoReg   <= ex_MemtoReg;
        end
        // On stall, keep the current values
    end

endmodule
