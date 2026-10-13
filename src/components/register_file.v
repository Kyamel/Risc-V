`timescale 1ns / 1ps

module register_file #(
    parameter WIDTH = 32,
    parameter DEPTH = 32
)(
    input wire                  clk,
    input wire                  rst,  // Asynchronous reset (active high)

    input wire [4:0]            rs1,
    input wire [4:0]            rs2,
    input wire [4:0]            rd,
    input wire [WIDTH-1:0]      wd,
    input wire                  rw,

    output wire [WIDTH-1:0]     read_data_1,
    output wire [WIDTH-1:0]     read_data_2,

    input wire [$clog2(DEPTH)-1:0] debug_read_index,
    output wire [WIDTH-1:0]     debug_data_out
);

    // Register indices are always 5 bits (instruction fields); with DEPTH = 16
    // (RV32E) only x0-x15 exist. Out-of-range registers read as 0 and ignore
    // writes (the CPU never issues those, it turns such instructions into bubbles).
    localparam IDX = $clog2(DEPTH);

    reg [WIDTH-1:0] regs [0:DEPTH-1];
    integer i;

    function automatic exists(input [4:0] r);
        exists = ({27'b0, r} < DEPTH);
    endfunction

    // Asynchronous reset + synchronous write
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Clear every register (x0 is never written, so it stays 0)
            for (i = 0; i < DEPTH; i = i + 1) begin
                regs[i] <= 0;
            end
        end
        else if (rw && rd != 5'd0 && exists(rd)) begin
            regs[rd[IDX-1:0]] <= wd;
        end
    end

    // Asynchronous reads. If the register being read is also being written this
    // cycle (instruction in WB), return the new value, so the instruction in ID
    // does not have to wait another cycle (write-first / internal bypass).
    assign read_data_1 = (rs1 == 5'd0 || !exists(rs1)) ? 0  :  // x0 is always 0
                         (rw && rd == rs1)             ? wd :
                                                         regs[rs1[IDX-1:0]];
    assign read_data_2 = (rs2 == 5'd0 || !exists(rs2)) ? 0  :
                         (rw && rd == rs2)             ? wd :
                                                         regs[rs2[IDX-1:0]];
    assign debug_data_out = (debug_read_index == 0) ? 0 : regs[debug_read_index];

endmodule
