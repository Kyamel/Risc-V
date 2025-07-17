module Xor_tb;
  logic [31:0] a, b, result;

  Xor dut (.a(a), .b(b), .result(result));

  initial begin
    $display("Testando XOR");
    a = 32'b1010; b = 32'b1100;
    #1 $display("1010 ^ 1100 = %b (esperado 0110)", result);

    a = 32'hFFFF_FFFF; b = 32'h0000_0000;
    #1 $display("FFFF ^ 0000 = %h (esperado FFFF)", result);

    a = 32'hAAAA_AAAA; b = 32'h5555_5555;
    #1 $display("AAAA ^ 5555 = %h (esperado FFFF_FFFF)", result);

    $finish;
  end
endmodule
