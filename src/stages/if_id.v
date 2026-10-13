`timescale 1ns / 1ps

module if_id (
    input wire         clk,
    input wire         rst,

    // Control
    input wire         stall,      // Hold the current values
    input wire         flush,      // Replace the instruction with a bubble

    // From IF
    input wire [31:0]  pc_in,      // PC of the fetched instruction
    input wire [31:0]  instr_in,   // Instruction from instruction memory

    // To ID
    output reg [31:0]  pc_out,
    output reg [31:0]  instr_out
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            pc_out    <= 32'b0;
            instr_out <= 32'b0;
        end else if (flush) begin
            pc_out    <= 32'b0;
            instr_out <= 32'b0;
        end else if (!stall) begin
            pc_out    <= pc_in;
            instr_out <= instr_in;
        end
        // On stall, keep the previous values
    end

endmodule
