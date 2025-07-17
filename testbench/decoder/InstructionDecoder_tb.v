`timescale 1ns / 1ps

module InstructionDecoder_tb;

    // Entradas
    reg [31:0] instr;

    // Saídas
    wire [6:0]  opcode;
    wire [2:0]  funct3;
    wire [6:0]  funct7;
    wire [4:0]  rd;
    wire [4:0]  rs1;
    wire [4:0]  rs2;
    wire [31:0] imm;
    wire [2:0]  instr_type;

    // Instancia o decoder
    InstructionDecoder decoder (
        .instr(instr),
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .rd(rd),
        .rs1(rs1),
        .rs2(rs2),
        .imm(imm),
        .instr_type(instr_type)
    );

    task print_result;
        begin
            $display("Instr: %h", instr);
            $display(" opcode    = %b", opcode);
            $display(" funct3    = %b", funct3);
            $display(" funct7    = %b", funct7);
            $display(" rd        = %d", rd);
            $display(" rs1       = %d", rs1);
            $display(" rs2       = %d", rs2);
            $display(" imm       = %h", imm);
            $display(" instr_type= %b\n", instr_type);
        end
    endtask

    initial begin
        $display("Testando InstructionDecoder...");

        // R-type: add x1, x2, x3
        // opcode=0110011 funct3=000 funct7=0000000 rd=1 rs1=2 rs2=3
        instr = 32'b00000000000110000010000010110011; // sem underscores
        #5 print_result();

        // I-type: addi x1, x2, 0x10
        // opcode=0010011 funct3=000 imm=0x10 rd=1 rs1=2
        instr = 32'b00000000000100000010000010010011;
        #5 print_result();

        // S-type: sw x3, 16(x2)
        // imm split entre 31:25 e 11:7, 16 decimal = 0x10
        // 7'b0000000, rs2=3, rs1=2, funct3=010, imm[4:0]=16, opcode=0100011
        instr = {7'b0000000, 5'd3, 5'd2, 3'b010, 5'd16, 7'b0100011};
        #5 print_result();

        // B-type: beq x2, x3, offset 8
        // imm rearranjado: imm[12], imm[10:5], imm[4:1], imm[11], lsb=0
        // bits: {imm[12], imm[10:5], rs2, rs1, funct3, imm[4:1], imm[11], opcode}
        // offset 8 decimal = 0b0000000001000 (13 bits)
        // imm[12]=0, imm[11]=0, imm[10:5]=000001, imm[4:1]=0000
        instr = {1'b0, 6'b000001, 5'd3, 5'd2, 3'b000, 4'b0000, 1'b0, 7'b1100011};
        #5 print_result();

        // U-type: lui x1, 0x12345
        instr = {20'h12345, 5'd1, 7'b0110111};
        #5 print_result();

        // J-type: jal x1, offset 0x100 (256 decimal)
        // J-type: {imm[20], imm[10:1], imm[11], imm[19:12], rd, opcode}
        // imm = 0x100 = 0b0000000100000000 (9 bits) com zeros para 20 bits
        // Organizar bits conforme especificação J-type:
        // imm[20] = 0
        // imm[10:1] = bits 10 downto 1 of offset (0x100 = bit 8 set, então bits 10:1=0000000100)
        // imm[11] = 0
        // imm[19:12] = 0
        // rd = 1
        // opcode = 1101111
        instr = {1'b0, 10'b0000000100, 1'b0, 8'b00000000, 5'd1, 7'b1101111};
        #5 print_result();

        $finish;
    end

endmodule
