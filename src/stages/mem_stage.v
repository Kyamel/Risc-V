`timescale 1ns / 1ps
`include "constants.v"

module mem_stage (
    input wire clk,
    input wire reset,
    
    // Entradas do estágio EX/MEM
    input wire [31:0] ex_mem_pc,
    input wire [31:0] ex_mem_alu_result,
    input wire [31:0] ex_mem_rs2_data,
    input wire [4:0] ex_mem_rd_addr,
    input wire [`CONTROL_SIGNALS_WIDTH-1:0] ex_mem_control_signals,
    input wire ex_mem_valid,
    
    // Interface com a memória de dados
    output reg [31:0] dmem_addr,
    input wire [31:0] dmem_data_in,
    output reg [31:0] dmem_data_out,
    output reg dmem_read,
    output reg dmem_write,
    output reg [3:0] dmem_byte_enable,
    
    // Saídas para o estágio MEM/WB
    output reg [31:0] mem_wb_pc,
    output reg [31:0] mem_wb_alu_result,
    output reg [31:0] mem_wb_mem_data,
    output reg [4:0] mem_wb_rd_addr,
    output reg [`CONTROL_SIGNALS_WIDTH-1:0] mem_wb_control_signals,
    output reg mem_wb_valid
);

    // Extrair sinais de controle relevantes (usando macros com CTRL_)
    wire mem_read_en = ex_mem_control_signals[`CTRL_MEM_READ];
    wire mem_write_en = ex_mem_control_signals[`CTRL_MEM_WRITE];
    wire [2:0] mem_width = ex_mem_control_signals[`CTRL_MEM_WIDTH];
    wire mem_unsigned = ex_mem_control_signals[`CTRL_MEM_UNSIGNED];
    
    // Processamento de endereço e dados
    always @(*) begin
        // Default values
        dmem_addr = ex_mem_alu_result;
        dmem_data_out = ex_mem_rs2_data;
        dmem_read = mem_read_en;
        dmem_write = mem_write_en;
        dmem_byte_enable = 4'b1111; // Default: word access
        
        // Determinar byte enable com base no tamanho do acesso
        case (mem_width)
            `MEM_BYTE: begin
                case (ex_mem_alu_result[1:0])
                    2'b00: dmem_byte_enable = 4'b0001;
                    2'b01: dmem_byte_enable = 4'b0010;
                    2'b10: dmem_byte_enable = 4'b0100;
                    2'b11: dmem_byte_enable = 4'b1000;
                endcase
            end
            `MEM_HALF: begin
                case (ex_mem_alu_result[1])
                    1'b0: dmem_byte_enable = 4'b0011;
                    1'b1: dmem_byte_enable = 4'b1100;
                endcase
            end
            default: begin
                dmem_byte_enable = 4'b1111; // MEM_WORD
            end
        endcase
    end

    // Processar dados lidos da memória (sign/zero extension)
    reg [31:0] read_data;
    always @(*) begin
        if (mem_read_en) begin
            case (mem_width)
                `MEM_BYTE: begin
                    case (dmem_addr[1:0])  // Mudança: usar dmem_addr em vez de ex_mem_alu_result
                        2'b00: read_data = mem_unsigned ? {24'b0, dmem_data_in[7:0]} : {{24{dmem_data_in[7]}}, dmem_data_in[7:0]};
                        2'b01: read_data = mem_unsigned ? {24'b0, dmem_data_in[15:8]} : {{24{dmem_data_in[15]}}, dmem_data_in[15:8]};
                        2'b10: read_data = mem_unsigned ? {24'b0, dmem_data_in[23:16]} : {{24{dmem_data_in[23]}}, dmem_data_in[23:16]};
                        2'b11: read_data = mem_unsigned ? {24'b0, dmem_data_in[31:24]} : {{24{dmem_data_in[31]}}, dmem_data_in[31:24]};
                    endcase
                end
                `MEM_HALF: begin
                    case (dmem_addr[1])  // Mudança: usar dmem_addr em vez de ex_mem_alu_result
                        1'b0: read_data = mem_unsigned ? {16'b0, dmem_data_in[15:0]} : {{16{dmem_data_in[15]}}, dmem_data_in[15:0]};
                        1'b1: read_data = mem_unsigned ? {16'b0, dmem_data_in[31:16]} : {{16{dmem_data_in[31]}}, dmem_data_in[31:16]};
                    endcase
                end
                default: begin // MEM_WORD
                    read_data = dmem_data_in;
                end
            endcase
        end else begin
            read_data = 32'b0;
        end
    end

    // Registro MEM/WB
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // ... (reset permanece igual)
        end else begin
            mem_wb_pc <= ex_mem_pc;
            mem_wb_alu_result <= ex_mem_alu_result;
            mem_wb_mem_data <= read_data;  // Mudança: usar read_data diretamente
            mem_wb_rd_addr <= ex_mem_rd_addr;
            mem_wb_control_signals <= ex_mem_control_signals;
            mem_wb_valid <= ex_mem_valid;
        end
    end
endmodule
