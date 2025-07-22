// tb/tb_immediate_generator.v
`timescale 1ns / 1ps

module tb_immediate_generator;

    reg  [31:0] instr;
    wire [31:0] imm_out;

    immediate_generator uut (
        .instr(instr),
        .imm_out(imm_out)
    );

    initial begin
        $display("\n== Teste Immediate Generator ==");

        // I-type: ADDI x1, x0, -1
        instr = 32'b111111111111_00000_000_00001_0010011;
        #1 $display("ADDI -> imm_out = %0d (esperado -1)", imm_out);

        // S-type: SW x1, 8(x2)
        instr = 32'b0000000_00001_00010_010_01000_0100011;
        #1 $display("SW   -> imm_out = %0d (esperado 8)", imm_out);

        // B-type: BEQ x1, x2, -4
        instr = 32'b1111111_00010_00001_000_11110_1100011;
        #1 $display("BEQ  -> imm_out = %0d (esperado -4)", imm_out);

        // U-type: LUI x1, 0x12345
        instr = 32'b00010010001101000101_00001_0110111;
        #1 $display("LUI  -> imm_out = 0x%08x (esperado 0x12345000)", imm_out);

        // J-type: JAL x0, 2048
        instr = 32'b000000000001_00000000_00000000_1101111;  // simplificado
        #1 $display("JAL  -> imm_out = %0d (esperado 2048?)", imm_out);

        $finish;
    end

endmodule
