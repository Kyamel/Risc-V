`timescale 1ns / 1ps

module data_memory #(
    parameter DEPTH = 1024,         // Tamanho padrão: 1024 palavras (4 KB)
    parameter INIT_FILE = "compiler/data.hex"        // Arquivo de inicialização (opcional)
) (
    input wire clk,
    input wire reset,

    // Interface do Estágio MEM
    input wire [31:0] addr,
    input wire [31:0] data_in,
    output reg [31:0] data_out,
    input wire read_en,
    input wire write_en,
    input wire [3:0] byte_enable,   // Suporte a LB/LH/LW/SB/SH/SW

    // Debug
    input wire [31:0] debug_addr,
    output wire [31:0] debug_data_out
);

    reg [31:0] mem [0:DEPTH-1];

    // Escrita síncrona (com byte_enable)
    always @(posedge clk) begin
        if (write_en && addr[31:2] < DEPTH) begin
            if (byte_enable[0]) mem[addr[31:2]][7:0]   <= data_in[7:0];
            if (byte_enable[1]) mem[addr[31:2]][15:8]  <= data_in[15:8];
            if (byte_enable[2]) mem[addr[31:2]][23:16] <= data_in[23:16];
            if (byte_enable[3]) mem[addr[31:2]][31:24] <= data_in[31:24];
        end
    end

    // Leitura combinatória (assíncrona)
    reg [31:0] read_data;
    always @(*) begin
        if (addr[31:2] < DEPTH)
            read_data = mem[addr[31:2]];
        else
            read_data = 32'h00000000;  // Endereço inválido
    end

    // Extensão de sinal para LB/LH
    always @(*) begin
        if (reset)
            data_out = 32'h0;
        else if (read_en) begin
            case (byte_enable)
                4'b0001: data_out = {{24{read_data[7]}},  read_data[7:0]};      // LB
                4'b0010: data_out = {{24{read_data[15]}}, read_data[15:8]};     // LB
                4'b0100: data_out = {{24{read_data[23]}}, read_data[23:16]};    // LB
                4'b1000: data_out = {{24{read_data[31]}}, read_data[31:24]};    // LB
                4'b0011: data_out = {{16{read_data[15]}}, read_data[15:0]};     // LH
                4'b1100: data_out = {{16{read_data[31]}}, read_data[31:16]};    // LH
                default: data_out = read_data;                                  // LW
            endcase
        end else
            data_out = 32'h0;
    end

    // Debug (leitura assíncrona)
    assign debug_data_out = (debug_addr[31:2] < DEPTH) ? mem[debug_addr[31:2]] : 32'h0;

    // Inicialização da memória
    initial begin
        // Preenche com zeros
        for (integer i = 0; i < DEPTH; i = i + 1)
            mem[i] = 32'h00000000;

        // Carrega conteúdo do arquivo (se especificado)
        if (INIT_FILE != "")
            $readmemh(INIT_FILE, mem);
    end

endmodule
