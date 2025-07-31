`timescale 1ns/1ps
`include "core/constants.v"

module memory_interface (
    input wire clk,
    input wire reset,

    // Entrada do estágio MEM
    input wire [31:0] addr,
    input wire [31:0] write_data,
    input wire [2:0] mem_size,            // 000: byte, 001: half, 010: word
    input wire mem_read,
    input wire mem_write,

    // Interface com memória externa
    output reg [31:0] mem_addr,
    output reg [31:0] mem_data_out,
    input wire [31:0] mem_data_in,
    output reg mem_read_en,
    output reg mem_write_en,
    output reg [3:0] byte_enable,
    
    // Saída do estágio MEM
    output reg [31:0] read_data
);

    always @(*) begin
        mem_addr = addr;
        mem_data_out = write_data;
        mem_read_en = mem_read;
        mem_write_en = mem_write;

        // Geração do byte_enable com base no alinhamento e tamanho
        case (mem_size)
            3'b000: begin // byte
                case (addr[1:0])
                    2'b00: byte_enable = 4'b0001;
                    2'b01: byte_enable = 4'b0010;
                    2'b10: byte_enable = 4'b0100;
                    2'b11: byte_enable = 4'b1000;
                endcase
            end
            3'b001: begin // half-word
                case (addr[1])
                    1'b0: byte_enable = 4'b0011;
                    1'b1: byte_enable = 4'b1100;
                endcase
            end
            default: byte_enable = 4'b1111; // word (32-bit), default
        endcase
    end

    // Leitura com extensão de sinal ou zero
    always @(*) begin
        if (mem_read) begin
            case (mem_size)
                3'b000: begin // byte
                    case (addr[1:0])
                        2'b00: read_data = {{24{mem_data_in[7]}}, mem_data_in[7:0]};
                        2'b01: read_data = {{24{mem_data_in[15]}}, mem_data_in[15:8]};
                        2'b10: read_data = {{24{mem_data_in[23]}}, mem_data_in[23:16]};
                        2'b11: read_data = {{24{mem_data_in[31]}}, mem_data_in[31:24]};
                    endcase
                end
                3'b001: begin // half-word
                    case (addr[1])
                        1'b0: read_data = {{16{mem_data_in[15]}}, mem_data_in[15:0]};
                        1'b1: read_data = {{16{mem_data_in[31]}}, mem_data_in[31:16]};
                    endcase
                end
                default: read_data = mem_data_in; // word
            endcase
        end else begin
            read_data = 32'b0;
        end
    end

endmodule
