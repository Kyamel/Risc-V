// Jal_tb.v
`timescale 1ns / 1ps

module Jal_tb;

    reg  [31:0] pc;
    reg  [31:0] imm;
    wire [31:0] jump_addr;
    wire [31:0] link;

    Jal uut (
        .pc(pc),
        .imm(imm),
        .jump_addr(jump_addr),
        .link(link)
    );

    initial begin
        $monitor("Time=%0t | PC=%h imm=%h jump_addr=%h link=%h", $time, pc, imm, jump_addr, link);

        pc = 32'h0000_1000; imm = 32'h0000_0100; #10;  // Salto para 0x1100, link = 0x1004
        pc = 32'h0000_1000; imm = -32'sd4;       #10;  // Salto para 0x0FFC, link = 0x1004
        pc = 32'hFFFF_FFF0; imm = 32'h0000_0010; #10;  // Overflow teste
        pc = 32'h0000_0000; imm = 32'h0000_0000; #10;  // Salto para PC (zero)
        
        $finish;
    end

endmodule
