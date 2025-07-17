// Srl_tb.v
`timescale 1ns / 1ps

module Srl_tb;

    reg  [31:0] rs1;
    reg  [4:0]  rs2;
    wire [31:0] result;

    // Instância do módulo SRL
    Srl uut (
        .rs1(rs1),
        .rs2(rs2),
        .result(result)
    );

    initial begin
        $monitor("Time=%0t | rs1=%h rs2=%d result=%h", $time, rs1, rs2, result);

        rs1 = 32'h8000_0000; rs2 = 0;  #10;
        rs1 = 32'h8000_0000; rs2 = 1;  #10;
        rs1 = 32'h8000_0000; rs2 = 4;  #10;
        rs1 = 32'hF000_F000; rs2 = 8;  #10;
        rs1 = 32'h0000_0001; rs2 = 31; #10;

        $finish;
    end

endmodule
