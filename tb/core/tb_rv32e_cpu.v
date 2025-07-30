module tb_rv32e_cpu;

    reg clk = 0;
    always #5 clk = ~clk;

    reg reset = 1;
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb);
        #20 reset = 0;
    end

    wire [31:0] pc;
    rv32e_cpu cpu (
        .clk(clk),
        .reset(reset),
        .pc_out(pc) // se tiver sinal de PC
    );

    initial begin
        repeat (1000) @(posedge clk);
        $display("Finalizando por timeout");
        $finish;
    end

endmodule
