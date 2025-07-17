module Bne_tb;
  logic [31:0] a, b;
  logic taken;

  Bne dut (.a(a), .b(b), .taken(taken));

  initial begin
    $display("Testando BNE");

    a = 32'd10; b = 32'd10;
    #1 $display("10 != 10 = %b (esperado 0)", taken);

    a = 32'd5; b = 32'd6;
    #1 $display("5 != 6 = %b (esperado 1)", taken);

    a = -32'd1; b = 32'd0;
    #1 $display("-1 != 0 = %b (esperado 1)", taken);

    $finish;
  end
endmodule
