module Sll_tb;
  logic [31:0] a, b, result;

  Sll dut (.a(a), .b(b), .result(result));

  initial begin
    $display("Testando SLL");
    a = 32'b0001; b = 32'd1;
    #1 $display("1 << 1 = %b (esperado 10)", result);

    a = 32'd3; b = 32'd4;
    #1 $display("3 << 4 = %d (esperado 48)", result);

    a = 32'h0000_0001; b = 32'd31;
    #1 $display("1 << 31 = %h (esperado 80000000)", result);

    $finish;
  end
endmodule
