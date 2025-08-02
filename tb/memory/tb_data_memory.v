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
    reg [31:0] debug_addr;
    wire [31:0] debug_data_out;

    // Clock
    always #5 clk = ~clk;

    // DUT
    data_memory #(
        .DEPTH(1024),
        .INIT_FILE("compiler/data.hex")
    ) dut (
        .clk(clk),
        .reset(reset),
        .addr(addr),
        .data_in(data_in),
        .data_out(data_out),
        .read_en(read_en),
        .write_en(write_en),
        .byte_enable(byte_enable),
        .debug_addr(debug_addr),
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

    // Exibe conteúdo da memória
    task dump_memory(input [31:0] start_addr, input [31:0] end_addr);
        integer i;
        begin
            $display("\nConteúdo da memória [%h-%h]:", start_addr, end_addr);
            for (i = start_addr; i <= end_addr; i = i + 4) begin
                debug_addr = i;
                #1; // Pequeno atraso para estabilização
                $display("mem[%h] = %h", i, debug_data_out);
            end
        end
    endtask

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_data_memory);
        
        $display("\n---- TESTE DATA_MEMORY ----\n");

        // Inicialização
        reset = 1;
        addr = 0;
        data_in = 0;
        read_en = 0;
        write_en = 0;
        byte_enable = 4'b0000;
        debug_addr = 0;

        #10;
        reset = 0;

        // -----------------------------------------------------------
        // Teste 1: Operações básicas de store
        // -----------------------------------------------------------
        $display("\n[TESTE 1] Operações básicas de store\n");
        
        // Store Byte (0xAB no endereço 0x00)
        addr = 32'h00000000;
        data_in = 32'h000000AB;
        write_en = 1;
        byte_enable = 4'b0001;
        #10;
        write_en = 0;
        
        // Store Halfword (0xC0DE no endereço 0x04)
        addr = 32'h00000004;
        data_in = 32'h0000C0DE;
        write_en = 1;
        byte_enable = 4'b0011;
        #10;
        write_en = 0;
        
        // Store Word (0xDEADBEEF no endereço 0x08)
        addr = 32'h00000008;
        data_in = 32'hDEADBEEF;
        write_en = 1;
        byte_enable = 4'b1111;
        #10;
        write_en = 0;

        // -----------------------------------------------------------
        // Teste 2: Operações de load com extensão de sinal
        // -----------------------------------------------------------
        $display("\n[TESTE 2] Operações de load com extensão de sinal\n");
        
        // Load Byte (endereço 0x00)
        addr = 32'h00000000;
        read_en = 1;
        byte_enable = 4'b0001;
        #10;
        check("LB (0x00)", data_out, 32'hFFFFFFAB);
        
        // Load Byte (endereço 0x01 do word 0x08 - deve pegar 0xBE)
        addr = 32'h00000009;
        byte_enable = 4'b0001;
        #10;
        check("LB (0x09)", data_out, 32'hFFFFFFBE);
        
        // Load Halfword (endereço 0x04)
        addr = 32'h00000004;
        byte_enable = 4'b0011;
        #10;
        check("LH (0x04)", data_out, 32'hFFFFC0DE);
        
        // Load Halfword (endereço 0x06 do word 0x08 - deve pegar 0xBEEF)
        addr = 32'h00000006;
        byte_enable = 4'b0011;
        #10;
        check("LH (0x06)", data_out, 32'hFFFFBEEF);
        
        // Load Word (endereço 0x08)
        addr = 32'h00000008;
        byte_enable = 4'b1111;
        #10;
        check("LW (0x08)", data_out, 32'hDEADBEEF);

        // -----------------------------------------------------------
        // Teste 3: Operações de load sem extensão de sinal (via debug)
        // -----------------------------------------------------------
        $display("\n[TESTE 3] Verificação via interface de debug (sem extensão)\n");
        
        debug_addr = 32'h00000000;
        #1;
        check("Debug read (0x00)", debug_data_out, 32'h000000AB);
        
        debug_addr = 32'h00000004;
        #1;
        check("Debug read (0x04)", debug_data_out, 32'h0000C0DE);
        
        debug_addr = 32'h00000008;
        #1;
        check("Debug read (0x08)", debug_data_out, 32'hDEADBEEF);

        // -----------------------------------------------------------
        // Teste 4: Escrita em bytes não contíguos
        // -----------------------------------------------------------
        $display("\n[TESTE 4] Escrita em bytes não contíguos\n");
        
        // Escreve 0x12 no byte 1 do word 0x10
        addr = 32'h00000010;
        data_in = 32'h00001200;
        write_en = 1;
        byte_enable = 4'b0010;
        #10;
        write_en = 0;
        
        // Escreve 0x34 no byte 2 do word 0x10
        addr = 32'h00000010;
        data_in = 32'h00340000;
        write_en = 1;
        byte_enable = 4'b0100;
        #10;
        write_en = 0;
        
        // Verifica resultado
        read_en = 1;
        byte_enable = 4'b1111;
        #10;
        check("Word após escritas não contíguas", data_out, 32'h00341200);
        
        debug_addr = 32'h00000010;
        #1;
        check("Debug read (0x10)", debug_data_out, 32'h00341200);

        // -----------------------------------------------------------
        // Teste 5: Load de bytes em diferentes posições
        // -----------------------------------------------------------
        $display("\n[TESTE 5] Load de bytes em diferentes posições\n");
        
        // Load Byte 0 do word 0x08 (0xEF)
        addr = 32'h00000008;
        byte_enable = 4'b0001;
        #10;
        check("LB byte 0 (0x08)", data_out, 32'hFFFFFFEF);
        
        // Load Byte 1 do word 0x08 (0xBE)
        addr = 32'h00000009;
        byte_enable = 4'b0001;
        #10;
        check("LB byte 1 (0x09)", data_out, 32'hFFFFFFBE);
        
        // Load Byte 2 do word 0x08 (0xAD)
        addr = 32'h0000000A;
        byte_enable = 4'b0001;
        #10;
        check("LB byte 2 (0x0A)", data_out, 32'hFFFFFFAD);
        
        // Load Byte 3 do word 0x08 (0xDE)
        addr = 32'h0000000B;
        byte_enable = 4'b0001;
        #10;
        check("LB byte 3 (0x0B)", data_out, 32'hFFFFFFDE);

        // -----------------------------------------------------------
        // Exibição do estado final da memória
        // -----------------------------------------------------------
        dump_memory(32'h00000000, 32'h00000020);

        $display("\n---- FIM DOS TESTES ----\n");
        $finish;
    end

endmodule