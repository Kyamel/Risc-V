`timescale 1ns / 1ps

module pc_generator (
    input wire        clk,
    input wire        rst,
    input wire [31:0] pc_in,    // Vem do MUX (PC + 4, branch, jump...)

    output reg [31:0] pc_out    // Vai para instruction_memory e adder
);

    always @(posedge clk or posedge rst) begin
        if (rst)
            pc_out <= 32'b0;
        else
            pc_out <= pc_in;
    end

endmodule
