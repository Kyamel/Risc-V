`timescale 1ns/1ps
`include "constants.v"

module tb_instruction_memory;

    reg clk = 0;
    reg reset;
    reg [31:0] addr;
    wire [31:0] data_out;
    reg read_en;

    // Interface de debug
    reg debug_en;
    reg [31:0] debug_addr;
    reg [31:0] debug_data_in;
    reg debug_write_en;
    wire [31:0] debug_data_out;

    // Variável de iteração
    reg [31:0] i;

    // Clock
    always #5 clk = ~clk;

    // DUT
    instruction_memory dut (
        .clk(clk),
        .reset(reset),
        .addr(addr),
        .data_out(data_out),
        .read_en(read_en),
        .debug_en(debug_en),
        .debug_addr(debug_addr),
        .debug_data_in(debug_data_in),
        .debug_write_en(debug_write_en),
        .debug_data_out(debug_data_out)
    );

    // Checagem
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
        // Dump para GTKWave
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_instruction_memory);
        
        // Inicializa memória com NOPs explicitamente para teste
        for (i = 0; i < 1024; i = i + 1) begin
            dut.mem[i] = 32'h00000013;
        end
        
        // Dump manual de parte da memória
        $display("\n---- DUMP INICIAL DAS PRIMEIRAS INSTRUÇÕES ----");
        for (i = 0; i < 8; i = i + 1) begin
            $display("mem[%0d] = %h", i, dut.mem[i]);
        end
        
        $display("-----------------------------------------------\n");

        $display("\n---- TESTE INSTRUCTION_MEMORY ----\n");

        // Reset inicial
        reset = 1;
        read_en = 0;
        debug_en = 0;
        debug_write_en = 0;
        addr = 0;
        debug_addr = 0;
        debug_data_in = 0;

        #10;
        reset = 0;

        // -------------------------------
        // 1. Verifica se no reset sai NOP
        // -------------------------------
        addr = 32'h00000000;
        read_en = 1;
        #10;
        check("Reset retorna NOP", data_out, 32'h00000013);

        // -------------------------------
        // 2. Escreve via interface de debug
        // -------------------------------
        debug_en = 1;
        debug_write_en = 1;
        debug_addr = 32'h00000008; // palavra 2
        debug_data_in = 32'hCAFEBABE;
        #10;

        // -------------------------------
        // 3. Lê instrução via porta normal
        // -------------------------------
        read_en = 1;
        addr = 32'h00000008; // mesma posição
        debug_write_en = 0;
        #10;
        check("Leitura normal após escrita debug", data_out, 32'hCAFEBABE);

        // -------------------------------
        // 4. Lê via debug_data_out
        // -------------------------------
        check("Leitura via debug_data_out", debug_data_out, 32'hCAFEBABE);

        // -------------------------------
        // 5. Escrita sem debug_en = deve ser ignorada
        // -------------------------------
        debug_en = 0;
        debug_write_en = 1;
        debug_addr = 32'h0000000C;
        debug_data_in = 32'hDEADBEEF;
        #10;

        addr = 32'h0000000C;
        read_en = 1;
        #10;
        check("Escrita ignorada sem debug_en", data_out, 32'h00000013); // deve continuar sendo NOP

        $display("\n---- FIM DOS TESTES ----\n");
        $finish;
        
    end
    

endmodule
