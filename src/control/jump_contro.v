`timescale 1ns / 1ps

module jump_control_unit (
    input wire        jump_signal,      // JAL/JALR
    input wire [31:0] pc_current,       // PC atual
    input wire [31:0] immediate,        // Offset para JAL
    input wire [31:0] rs1_data,         // Para JALR
    input wire [6:0]  opcode,
    output wire [31:0] jump_target,
    output wire [31:0] link_address     // PC+4 para rd
);

assign link_address = pc_current + 32'd4;

// Cálculo do endereço de jump
assign jump_target = (opcode == 7'b1100111) ? // JALR
                     (rs1_data + immediate) & ~32'd1 :  // JALR: (rs1+imm) & ~1
                     (pc_current + immediate);          // JAL: PC + offset

endmodule
