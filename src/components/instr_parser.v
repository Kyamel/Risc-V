`timescale 1ns / 1ps

module instr_parser (
    input  wire [31:0] instr,

    output wire [6:0]  opcode,
    output wire [4:0]  rs1,
    output wire [4:0]  rs2,
    output wire [4:0]  rd
);

    assign opcode = instr[6:0];
    assign rd     = instr[11:7];
    //assign funct3 = instr[14:12];
    assign rs1    = instr[19:15];
    assign rs2    = instr[24:20];
    // bit 30 também pode ser extraído aqui se quiser

endmodule
