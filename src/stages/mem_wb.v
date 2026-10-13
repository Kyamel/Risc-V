`timescale 1ns / 1ps

module mem_wb (
    input wire         clk,
    input wire         rst,
    input wire         stall,             // Hold the current values
    input wire         flush,             // Insert a bubble

    // From MEM
    input wire [31:0]  mem_read_data,     // Data read from data memory
    input wire [31:0]  mem_result,        // Result from EX/MEM
    input wire [4:0]   mem_rd,            // Destination register
    input wire         mem_RegWrite,      // Register file write
    input wire         mem_MemtoReg,      // Write-back source: 0 = result, 1 = memory

    // To WB
    output reg [31:0]  wb_read_data,
    output reg [31:0]  wb_result,
    output reg [4:0]   wb_rd,
    output reg         wb_RegWrite,
    output reg         wb_MemtoReg
);

    always @(posedge clk or posedge rst) begin
        if (rst || flush) begin
            wb_read_data <= 32'b0;
            wb_result    <= 32'b0;
            wb_rd        <= 5'b0;
            wb_RegWrite  <= 1'b0;
            wb_MemtoReg  <= 1'b0;
        end
        else if (!stall) begin
            wb_read_data <= mem_read_data;
            wb_result    <= mem_result;
            wb_rd        <= mem_rd;
            wb_RegWrite  <= mem_RegWrite;
            wb_MemtoReg  <= mem_MemtoReg;
        end
        // On stall, keep the current values
    end

endmodule
