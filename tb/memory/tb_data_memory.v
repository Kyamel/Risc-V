`timescale 1ns/1ps
`include "constants.v"

module tb_data_memory;

    // Entradas
    reg clk = 0;
    reg reset;
    reg [31:0] addr;
    reg [31:0] data_in;
    wire [31:0] data_out;
    reg read_en;
    reg write_en;
    reg [3:0] byte_enable;

    // Interface debug
    reg debug_en;
    reg [31:0] debug_addr;
    reg [31:0] debug_data_in;
    reg debug_write_en;
    wire [31:0] debug_data_out;

    // Clock
    always #5 clk = ~clk;

    // DUT
    data_memory dut (
        .clk(clk),
        .reset(reset),
        .addr(addr),
        .data_in(data_in),
        .data_out(data_out),
        .read_en(read_en),
        .write_en(write_en),
        .byte_enable(byte_enable),
        .debug_en(debug_en),
        .debug_addr(debug_addr),
        .debug_data_in(debug_data_in),
        .debug_write_en(debug_write_en),
        .debug_data_out(debug_data_out)
    );

    // Verificação
    task check(string name, input [31:0] got, input [31:0] expected);
        begin
            if (got !== expected) begin
                $display("\033[1;31m[FAIL]\033[0m %s: Esperado 0x%h, Obteve 0x%h", name, expected, got);
            end else begin
                $display("\033[1;32m[PASS]\033[0m %s: Valor 0x%h", name, got);
            end
        end
    endtask

    initial begin
        $display("\n---- TESTE DATA_MEMORY ----\n");

        // Inicialização
        reset = 1;
        addr = 0;
        data_in = 0;
        read_en = 0;
        write_en = 0;
        byte_enable = 4'b0000;
        debug_en = 0;
        debug_write_en = 0;
        debug_data_in = 0;
        debug_addr = 0;

        #10;
        reset = 0;

        // ----------------------------
        // Escrita via byte (SB)
        // ----------------------------
        addr = 32'h00000000;
        data_in = 32'h000000AB;
        write_en = 1;
        byte_enable = 4'b0001;
        #10;
        write_en = 0;

        read_en = 1;
        #10;
        check("SB (byte)", data_out, 32'hFFFFFFAB);

        // ----------------------------
        // Escrita via half (SH)
        // ----------------------------
        addr = 32'h00000004;
        data_in = 32'h0000C0DE;
        write_en = 1;
        byte_enable = 4'b0011;
        #10;
        write_en = 0;

        read_en = 1;
        #10;
        check("SH (halfword)", data_out, 32'hFFFFC0DE);

        // ----------------------------
        // Escrita via word (SW)
        // ----------------------------
        addr = 32'h00000008;
        data_in = 32'hDEADBEEF;
        write_en = 1;
        byte_enable = 4'b1111;
        #10;
        write_en = 0;

        read_en = 1;
        #10;
        check("SW (word)", data_out, 32'hDEADBEEF);

        // ----------------------------
        // Escrita via debug interface
        // ----------------------------
        debug_en = 1;
        debug_write_en = 1;
        debug_addr = 32'h0000000C;
        debug_data_in = 32'hCAFEBABE;
        #10;
        debug_write_en = 0;

        addr = 32'h0000000C;
        read_en = 1;
        #10;
        check("Debug write", data_out, 32'hCAFEBABE);

        // ----------------------------
        // Leitura via debug_data_out
        // ----------------------------
        check("Debug read", debug_data_out, 32'hCAFEBABE);

        $display("\n---- FIM DOS TESTES ----\n");
        $finish;
    end

endmodule
