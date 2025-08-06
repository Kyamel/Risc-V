`timescale 1ns / 1ps

module instr_parser (
    input  wire [31:0] instr, // IF/ID instruction input

    output wire [6:0]  opcode, // opcode to control unit
    output wire [4:0]  rs1,    // to register_file and ID/EX stage
    output wire [4:0]  rs2,    // to register_file and ID/EX stage
    output wire [4:0]  rd,     // to ID/EX stage
    output wire [2:0]  funct3, // function field for ALU control
    output wire [6:0]  funct7  // function field for ALU control
);

    assign opcode = instr[6:0];
    assign funct3 = instr[14:12];
    assign funct7 = instr[31:25];
    
    // I-type instructions (ADDI, LW, JALR)
    wire is_itype = (instr[6:0] == 7'b0010011) || (instr[6:0] == 7'b0000011) || (instr[6:0] == 7'b1100111);
    // S-type instructions (SW)
    wire is_stype = (instr[6:0] == 7'b0100011);
    // B-type instructions (BEQ, BNE, etc)
    wire is_btype = (instr[6:0] == 7'b1100011);
    // U-type instructions (LUI, AUIPC)
    wire is_utype = (instr[6:0] == 7'b0110111) || (instr[6:0] == 7'b0010111);
    // J-type instructions (JAL)
    wire is_jtype = (instr[6:0] == 7'b1101111);
    // R-type instructions (default)
    wire is_rtype = ~(is_itype | is_stype | is_btype | is_utype | is_jtype);

    // rs1 field extraction
    assign rs1 = is_utype ? 5'b0 :          // U-type não usa rs1
                 is_jtype ? 5'b0 :          // J-type não usa rs1
                 instr[19:15];              // Todos os outros tipos

    // rs2 field extraction
    assign rs2 = is_itype ? 5'b0 :          // I-type não usa rs2
                 is_utype ? 5'b0 :          // U-type não usa rs2
                 is_jtype ? 5'b0 :          // J-type não usa rs2
                 instr[24:20];              // R-type, S-type, B-type

    // rd field extraction
    assign rd = is_stype ? 5'b0 :           // S-type não tem rd
                is_btype ? 5'b0 :           // B-type não tem rd
                instr[11:7];                // Todos os outros tipos

endmodule