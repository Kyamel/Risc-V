// Sw_tb.v
`timescale 1ns / 1ps

module Sw_tb;

    reg  [31:0] rs1;
    reg  [31:0] imm;
    wire [31:0] address;

    Sw uut (
        .rs1(rs1),
        .imm(imm),
        .address(address)
    );

    initial begin
        $monitor("Time=%0t | rs1=%h imm=%h address=%h", $time, rs1, imm, address);

        rs1 = 32'h1000_0000; imm = 32'h0000_0100; #10;
        rs1 = 32'h2000_0000; imm = 32'hFFFF_FF00; #10; // negativo em complemento de 2
        rs1 = 32'h0000_0000; imm = 32'h0000_0000; #10;

        $finish;
    end

endmodule
