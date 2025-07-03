`timescale 1ns/1ps
module testbench();
    reg clk = 0;
    reg rst = 1;

    always #5 clk = ~clk;

    cpu CPU (.clk(clk), .rst(rst));

    initial begin
        $dumpfile("cpu.vcd");
        $dumpvars(0, testbench);
        #10 rst = 0;
        #100 $finish;
    end
endmodule