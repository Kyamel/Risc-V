module Sub_tb;
  logic [31:0] a, b, result;

  Sub dut (.a(a), .b(b), .result(result));

  initial begin
    $display("Testando Sub");
    a = 32'd20; b = 32'd5;
    #1 $display("20 - 5 = %0d (esperado 15)", result);

    a = 32'd0; b = 32'd1;
    #1 $display("0 - 1 = %0d (esperado -1)", result);

    a = -32'd100; b = -32'd100;
    #1 $display("-100 - (-100) = %0d (esperado 0)", result);

    $finish;
  end
endmodule
