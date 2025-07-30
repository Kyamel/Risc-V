`include "constants.v"

module mem_stage (
    input wire clk,
    input wire reset,
    
    // Entradas do estágio EX
    input wire [31:0] ex_pc,
    input wire [31:0] ex_alu_result,
    input wire [31:0] ex_rs2_data,
    input wire [4:0] ex_rd_addr,
    input wire [`CONTROL_SIGNALS_WIDTH-1:0] ex_control_signals,
    input wire ex_valid,
    
    // Interface com a memória de dados
    output reg [31:0] dmem_addr,
    input wire [31:0] dmem_data_in,
    output reg [31:0] dmem_data_out,
    output reg dmem_read,
    output reg dmem_write,
    output reg [3:0] dmem_byte_enable,
    
    // Saídas para o estágio WB
    output reg [31:0] wb_pc,
    output reg [31:0] wb_alu_result,
    output reg [31:0] wb_mem_data,
    output reg [4:0] wb_rd_addr,
    output reg [`CONTROL_SIGNALS_WIDTH-1:0] wb_control_signals,
    output reg wb_valid
);

    // Extrair sinais de controle relevantes
    wire mem_read = ex_control_signals[`MEM_READ];
    wire mem_write = ex_control_signals[`MEM_WRITE];
    wire [2:0] mem_width = ex_control_signals[`MEM_WIDTH];
    wire mem_unsigned = ex_control_signals[`MEM_UNSIGNED];
    
    // Sinais intermediários
    reg [31:0] mem_data_reg;
    reg [31:0] alu_result_reg;

    always @(*) begin
        // Default values
        dmem_addr = ex_alu_result;
        dmem_data_out = ex_rs2_data;
        dmem_read = mem_read;
        dmem_write = mem_write;
        dmem_byte_enable = 4'b1111; // Default: word access
        
        // Determinar byte enable com base no tamanho do acesso
        case (mem_width)
            `MEM_BYTE: begin
                case (ex_alu_result[1:0])
                    2'b00: dmem_byte_enable = 4'b0001;
                    2'b01: dmem_byte_enable = 4'b0010;
                    2'b10: dmem_byte_enable = 4'b0100;
                    2'b11: dmem_byte_enable = 4'b1000;
                endcase
            end
            `MEM_HALF: begin
                case (ex_alu_result[1])
                    1'b0: dmem_byte_enable = 4'b0011;
                    1'b1: dmem_byte_enable = 4'b1100;
                endcase
            end
            `MEM_WORD: begin
                dmem_byte_enable = 4'b1111;
            end
            default: begin
                dmem_byte_enable = 4'b0000;
            end
        endcase
    end

    // Processar dados lidos da memória (sign/zero extension)
    always @(*) begin
        if (mem_read) begin
            case (mem_width)
                `MEM_BYTE: begin
                    case (ex_alu_result[1:0])
                        2'b00: mem_data_reg = mem_unsigned ? {24'b0, dmem_data_in[7:0]} : {{24{dmem_data_in[7]}}, dmem_data_in[7:0]};
                        2'b01: mem_data_reg = mem_unsigned ? {24'b0, dmem_data_in[15:8]} : {{24{dmem_data_in[15]}}, dmem_data_in[15:8]};
                        2'b10: mem_data_reg = mem_unsigned ? {24'b0, dmem_data_in[23:16]} : {{24{dmem_data_in[23]}}, dmem_data_in[23:16]};
                        2'b11: mem_data_reg = mem_unsigned ? {24'b0, dmem_data_in[31:24]} : {{24{dmem_data_in[31]}}, dmem_data_in[31:24]};
                    endcase
                end
                `MEM_HALF: begin
                    case (ex_alu_result[1])
                        1'b0: mem_data_reg = mem_unsigned ? {16'b0, dmem_data_in[15:0]} : {{16{dmem_data_in[15]}}, dmem_data_in[15:0]};
                        1'b1: mem_data_reg = mem_unsigned ? {16'b0, dmem_data_in[31:16]} : {{16{dmem_data_in[31]}}, dmem_data_in[31:16]};
                    endcase
                end
                `MEM_WORD: begin
                    mem_data_reg = dmem_data_in;
                end
                default: begin
                    mem_data_reg = 32'b0;
                end
            endcase
        end else begin
            mem_data_reg = 32'b0;
        end
    end

    // Registrar saídas para o estágio WB
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            wb_pc <= 32'b0;
            wb_alu_result <= 32'b0;
            wb_mem_data <= 32'b0;
            wb_rd_addr <= 5'b0;
            wb_control_signals <= {`CONTROL_SIGNALS_WIDTH{1'b0}};
            wb_valid <= 1'b0;
        end else begin
            wb_pc <= ex_pc;
            wb_alu_result <= ex_alu_result;
            wb_mem_data <= mem_read ? mem_data_reg : 32'b0;
            wb_rd_addr <= ex_rd_addr;
            wb_control_signals <= ex_control_signals;
            wb_valid <= ex_valid;
        end
    end

endmodule

/*  
   MEM_READ: Indica operação de load

    MEM_WRITE: Indica operação de store

    MEM_WIDTH: Tamanho do acesso (00=byte, 01=half-word, 10=word)

    MEM_UNSIGNED: Indica se é load unsigned (LBU/LHU)
*/