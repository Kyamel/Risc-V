`timescale 1ns / 1ps

module alu_control (
    input wire [1:0] ALUOp,     // Sinal da control unit
    input wire [9:0] Funct,      // {funct7[6:0], funct3[2:0]} da instrução
    output reg [3:0] Op          // Operação para a ALU

    // --------------------------
    // Conecte a esse modulo com:
    // wire [9:0] funct = {if_id_instr[31:25], if_id_instr[14:12]};
    // --------------------------
);

    // Definição dos códigos de operação da ALU
    localparam [3:0]
        ADD  = 4'b0000,
        SUB  = 4'b0001,
        SLL  = 4'b0010,
        SLT  = 4'b0011,
        SLTU = 4'b0100,
        XOR  = 4'b0101,
        SRL  = 4'b0110,
        SRA  = 4'b0111,
        OR   = 4'b1000,
        AND  = 4'b1001;

    always @(*) begin
        case (ALUOp)
            2'b00: Op = ADD;  // Para loads/stores (soma de endereços)
            2'b01: Op = SUB;  // Para branches (subtração para comparação)
            
            // Instruções tipo R e I (aritméticas)
            2'b10, 2'b11: begin
                case (Funct[2:0])  // funct3
                    3'b000: 
                        if (ALUOp == 2'b10 && Funct[9:7] == 7'b0100000) 
                            Op = SUB;  // SUB quando funct7[5] = 1
                        else 
                            Op = ADD;  // ADD/ADDI
                    
                    3'b001: Op = SLL;   // SLL/SLLI
                    3'b010: Op = SLT;   // SLT/SLTI
                    3'b011: Op = SLTU;  // SLTU/SLTIU
                    3'b100: Op = XOR;   // XOR/XORI
                    3'b101: 
                        if (Funct[9:7] == 7'b0000000)
                            Op = SRL;   // SRL/SRLI
                        else
                            Op = SRA;   // SRA/SRAI
                    
                    3'b110: Op = OR;    // OR/ORI
                    3'b111: Op = AND;   // AND/ANDI
                    default: Op = ADD;
                endcase
            end
            
            default: Op = ADD;
        endcase
    end

endmodule