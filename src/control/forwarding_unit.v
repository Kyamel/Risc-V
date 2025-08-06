`timescale 1ns / 1ps

module forwarding_unit (
    input  wire [4:0] EX_rs1,
    input  wire [4:0] EX_rs2,
    input  wire [4:0] MEM_rd,
    input  wire [4:0] WB_rd,
    input  wire       MEM_RegWrite,
    input  wire       WB_RegWrite,
    output reg  [1:0] ForwardA,
    output reg  [1:0] ForwardB
);

    always @(*) begin
        // Forward A (rs1)
        if (MEM_RegWrite && (MEM_rd != 5'd0) && (MEM_rd == EX_rs1)) begin
            ForwardA = 2'b10;  // Forward from MEM
        end else if (WB_RegWrite && (WB_rd != 5'd0) && (WB_rd == EX_rs1)) begin
            ForwardA = 2'b01;  // Forward from WB
        end else begin
            ForwardA = 2'b00;  // No forwarding
        end

        // Forward B (rs2)
        if (MEM_RegWrite && (MEM_rd != 5'd0) && (MEM_rd == EX_rs2)) begin
            ForwardB = 2'b10;  // Forward from MEM
        end else if (WB_RegWrite && (WB_rd != 5'd0) && (WB_rd == EX_rs2)) begin
            ForwardB = 2'b01;  // Forward from WB
        end else begin
            ForwardB = 2'b00;  // No forwarding
        end
    end

endmodule
