`timescale 1ns / 1ps

module register_file #(
    parameter WIDTH = 32,
    parameter DEPTH = 32
)(
    input wire                  clk,
    input wire                  rst,  // Reset assíncrono (1 = reset)

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

    reg [WIDTH-1:0] regs [0:DEPTH-1];
    integer i;

    // Reset assíncrono + escrita síncrona
    always @(negedge clk or negedge rst) begin
        if (rst) begin
            // Zera todos os registradores exceto x0 (que é hardwired para 0)
            for (i = 1; i < DEPTH; i = i + 1) begin
                regs[i] <= 0;
            end
        end
        else if (rw && rd != 5'd0) begin
            regs[rd] <= wd;
        end
    end

    // Leituras assíncronas
    assign read_data_1 = (rs1 == 5'd0) ? 0 : regs[rs1];  // x0 é sempre 0
    assign read_data_2 = (rs2 == 5'd0) ? 0 : regs[rs2];  // x0 é sempre 0
    assign debug_data_out = (debug_read_index == 5'd0) ? 0 : regs[debug_read_index];

endmodule