`timescale 1ns / 1ps

module instr_parser (
    input  wire [31:0] instr, // IF/ID instruction input

    output wire [6:0]  opcode, // opcode to control unit
    output wire [4:0]  rs1,    // to register_file and ID/EX stage
    output wire [4:0]  rs2,    // to register_file and ID/EX stage
    output wire [4:0]  rd      // to ID/EX stage
);

    assign opcode = instr[6:0];
    
    // I-type instructions (ADDI, LW)
    wire is_itype = (instr[6:0] == 7'b0010011) || (instr[6:0] == 7'b0000011);
    // S-type instructions (SW)
    wire is_stype = (instr[6:0] == 7'b0100011);
    // B-type instructions (BEQ)
    wire is_btype = (instr[6:0] == 7'b1100011);
    // U-type instructions (LUI, AUIPC)
    wire is_utype = (instr[6:0] == 7'b0110111) || (instr[6:0] == 7'b0010111);
    // J-type instructions (JAL)
    wire is_jtype = (instr[6:0] == 7'b1101111);
    // R-type instructions (default)
    wire is_rtype = ~(is_itype | is_stype | is_btype | is_utype | is_jtype);

    assign rs1 = is_itype ? instr[19:15] :
                is_stype ? instr[19:15] :
                is_btype ? instr[19:15] :
                is_utype ? 5'b0 :
                is_jtype ? 5'b0 :
                /* rtype/default */ instr[19:15];

    assign rs2 = is_itype ? 5'b0 :
                is_stype ? instr[24:20] :
                is_btype ? instr[24:20] :
                is_utype ? 5'b0 :
                is_jtype ? 5'b0 :
                /* rtype/default */ instr[24:20];

    assign rd = is_itype ? instr[11:7] :
               is_stype ? instr[11:7] : // Not actually used in S-type, but we extract it
               is_btype ? 5'b0 :
               is_utype ? instr[11:7] :
               is_jtype ? instr[11:7] :
               /* rtype/default */ instr[11:7];

endmodule