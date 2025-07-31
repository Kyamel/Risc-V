`timescale 1ns / 1ps
`include "constants.v"

module branch_unit (
    input wire [31:0] id_ex_pc,
    input wire [31:0] id_ex_instruction,
    input wire [31:0] id_ex_rs1_data,
    input wire [31:0] id_ex_rs2_data,
    input wire [31:0] id_ex_immediate,
    input wire [`CONTROL_SIGNALS_WIDTH-1:0] id_ex_control_signals,

    output reg pc_src,
    output reg [31:0] new_pc,
    output reg flush    
);

    // Extrair sinais de controle e campos da instrução
    wire is_branch = id_ex_control_signals[`CTRL_BRANCH];  // Usando macro com prefixo CTRL_
    wire [2:0] funct3 = id_ex_instruction[14:12];         // Campo funct3 para tipo de branch
    wire is_jump = id_ex_control_signals[`CTRL_JUMP];     // Sinal de instrução jump

    always @(*) begin
        // Valores padrão
        pc_src = 1'b0;
        new_pc = 32'b0;
        flush = 1'b0;

        // Lógica para branches
        if (is_branch) begin
            case (funct3)
                `BRANCH_EQ:  pc_src = (id_ex_rs1_data == id_ex_rs2_data);  // beq
                `BRANCH_NE:  pc_src = (id_ex_rs1_data != id_ex_rs2_data);  // bne
                `BRANCH_LT:  pc_src = ($signed(id_ex_rs1_data) < $signed(id_ex_rs2_data));  // blt
                `BRANCH_GE:  pc_src = ($signed(id_ex_rs1_data) >= $signed(id_ex_rs2_data)); // bge
                `BRANCH_LTU: pc_src = (id_ex_rs1_data < id_ex_rs2_data);   // bltu
                `BRANCH_GEU: pc_src = (id_ex_rs1_data >= id_ex_rs2_data);  // bgeu
                default: pc_src = 1'b0;
            endcase

            if (pc_src) begin
                new_pc = id_ex_pc + id_ex_immediate;
                flush = 1'b1;
            end
        end
        // Lógica para jumps (JAL/JALR)
        else if (is_jump) begin
            pc_src = 1'b1;
            new_pc = id_ex_pc + id_ex_immediate;  // Para JALR, o cálculo é diferente
            flush = 1'b1;
        end
    end

endmodule