`include "constants.v"

module data_memory (
    input wire clk,
    input wire reset,
    
    // Interface com o estágio MEM
    input wire [31:0] addr,
    input wire [31:0] data_in,
    output reg [31:0] data_out,
    input wire read_en,
    input wire write_en,
    input wire [3:0] byte_enable,
    
    // Interface de depuração
    input wire debug_en,
    input wire [31:0] debug_addr,
    input wire [31:0] debug_data_in,
    input wire debug_write_en,
    output wire [31:0] debug_data_out
);

    // Memória organizada como 1024 palavras de 32 bits (4KB)
    reg [31:0] mem [0:1023];
    reg [31:0] read_data_reg;
    
    // Inicialização da memória com zeros
    integer i;
    initial begin
        for (i = 0; i < 1024; i = i + 1) begin
            mem[i] = 32'h00000000;
        end
    end

    // Operação de escrita (síncrona)
    always @(posedge clk) begin
        if (write_en) begin
            // Escrita com byte enable
            case (byte_enable)
                4'b0001: mem[addr[31:2]][7:0]   <= data_in[7:0];
                4'b0010: mem[addr[31:2]][15:8]  <= data_in[7:0];
                4'b0100: mem[addr[31:2]][23:16] <= data_in[7:0];
                4'b1000: mem[addr[31:2]][31:24] <= data_in[7:0];
                
                4'b0011: mem[addr[31:2]][15:0]  <= data_in[15:0];
                4'b1100: mem[addr[31:2]][31:16] <= data_in[15:0];
                
                4'b1111: mem[addr[31:2]]        <= data_in;
                
                default: ; // Nenhuma escrita
            endcase
        end
    end

    // Operação de leitura (combinatória para endereço, registrada na saída)
    always @(*) begin
        read_data_reg = mem[addr[31:2]];
    end

    // Registro da saída
    always @(posedge clk) begin
        if (reset) begin
            data_out <= 32'h00000000;
        end else if (read_en) begin
            // Tratamento de leitura com diferentes tamanhos
            case (byte_enable)
                4'b0001: data_out <= {{24{read_data_reg[7]}}, read_data_reg[7:0]}; // LB
                4'b0010: data_out <= {{24{read_data_reg[15]}}, read_data_reg[15:8]}; // LB
                4'b0100: data_out <= {{24{read_data_reg[23]}}, read_data_reg[23:16]}; // LB
                4'b1000: data_out <= {{24{read_data_reg[31]}}, read_data_reg[31:24]}; // LB
                
                4'b0011: data_out <= {{16{read_data_reg[15]}}, read_data_reg[15:0]}; // LH
                4'b1100: data_out <= {{16{read_data_reg[31]}}, read_data_reg[31:16]}; // LH
                
                4'b1111: data_out <= read_data_reg; // LW
                
                default: data_out <= 32'h00000000;
            endcase
        end
    end

    // Interface de depuração
    assign debug_data_out = mem[debug_addr[31:2]];
    
    always @(posedge clk) begin
        if (debug_en && debug_write_en) begin
            mem[debug_addr[31:2]] <= debug_data_in;
        end
    end

    // Carregamento inicial de dados a partir de arquivo (para simulação)
`ifdef SIMULATION
    initial begin
        $readmemh("data.hex", mem);
    end
`endif

endmodule