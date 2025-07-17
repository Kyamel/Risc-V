// Jalr_tb.v
`timescale 1ns / 1ps

module Jalr_tb;

    reg  [31:0] pc;
    reg  [31:0] rs1;
    reg  [31:0] imm;
    wire [31:0] jump_addr;
    wire [31:0] link;

    Jalr uut (
        .pc(pc),
        .rs1(rs1),
        .imm(imm),
        .jump_addr(jump_addr),
        .link(link)
    );

    initial begin
        $monitor("Time=%0t | PC=%h rs1=%h imm=%h jump_addr=%h link=%h",
                 $time, pc, rs1, imm, jump_addr, link);

        pc = 32'h0000_1000; rs1 = 32'h0000_2000; imm = 32'h0000_0100; #10;
        // Esperado jump_addr = 0x2100 (0x2000+0x100), link = 0x1004

        pc = 32'h0000_1000; rs1 = 32'h0000_2003; imm = 32'h0000_0005; #10;
        // jump_addr = (0x2003+0x5) = 0x2008, bit0 = 0 -> 0x2008 alinhado

        pc = 32'h0000_1000; rs1 = 32'h0000_2002; imm = -32'sd2;       #10;
        // jump_addr = (0x2002 - 2) = 0x2000, alinhado

        pc = 32'h0000_0000; rs1 = 32'h0000_0001; imm = 32'h0000_0001; #10;
        // jump_addr = 0x2, bit0 zerado = 0x2

        $finish;
    end

endmodule
