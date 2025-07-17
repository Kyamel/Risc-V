module Add_tb;
  logic [31:0] a, b, result;

  Add dut (.a(a), .b(b), .result(result));

  initial begin
    $display("Testando Add");
    a = 32'd10; b = 32'd5;
    #1 $display("10 + 5 = %0d (esperado 15)", result);

    a = 32'hFFFF_FFFF; b = 32'd1;
    #1 $display("0xFFFFFFFF + 1 = %0h (esperado 0)", result);

    a = 32'd1000; b = -32'd100;
    #1 $display("1000 + (-100) = %0d (esperado 900)", result);

    $finish;
  end
endmodule
