// Beq_tb.v
`timescale 1ns / 1ps

module Beq_tb;

    reg  [31:0] rs1;
    reg  [31:0] rs2;
    wire        branch_taken;

    Beq uut (
        .rs1(rs1),
        .rs2(rs2),
        .branch_taken(branch_taken)
    );

    initial begin
        $monitor("Time=%0t | rs1=%h rs2=%h branch_taken=%b", $time, rs1, rs2, branch_taken);

        rs1 = 32'h1234_5678; rs2 = 32'h1234_5678; #10; // iguais → branch_taken = 1
        rs1 = 32'hFFFF_FFFF; rs2 = 32'h0000_0000; #10; // diferentes → branch_taken = 0
        rs1 = 32'h0000_0001; rs2 = 32'h0000_0001; #10; // iguais → branch_taken = 1
        rs1 = 32'hAAAA_AAAA; rs2 = 32'h5555_5555; #10; // diferentes → branch_taken = 0

        $finish;
    end

endmodule
