`timescale 1ns / 1ps

module tb_immediate_generator;

    reg  [31:0] instr;
    wire [31:0] imm_out;

    immediate_generator uut (
        .instr(instr),
        .imm_out(imm_out)
    );

    task test_imm;
        input string test_name;
        input [31:0] expected;
        input integer is_signed;
        reg pass;
        reg [6:0] opcode;
        reg [2:0] funct3;
        reg [6:0] funct7;
        reg [4:0] rd, rs1, rs2;
        begin
            #1;
            opcode = instr[6:0];
            funct3 = instr[14:12];
            funct7 = instr[31:25];
            rd     = instr[11:7];
            rs1    = instr[19:15];
            rs2    = instr[24:20];

            pass = ((is_signed && ($signed(imm_out) === $signed(expected))) || 
                    (!is_signed && (imm_out === expected)));

            if (pass) begin
                $write("[PASS] ");
                $write("%c[1;32m", 27); // Green
            end else begin
                $write("[FAIL] ");
                $write("%c[1;31m", 27); // Red
            end

            $display("Instr: %032b", instr);
            $display("  opcode: %07b", opcode);

            case (opcode)
                7'b0010011, 7'b0000011, 7'b1100111: begin // I-type
                    $display("  Type: I");
                    $display("  rd: x%0d, rs1: x%0d, imm: %0d (0x%08x)", rd, rs1, $signed(imm_out), imm_out);
                end
                7'b0100011: begin // S-type
                    $display("  Type: S");
                    $display("  rs1: x%0d, rs2: x%0d, imm: %0d (0x%08x)", rs1, rs2, $signed(imm_out), imm_out);
                end
                7'b1100011: begin // B-type
                    $display("  Type: B");
                    $display("  rs1: x%0d, rs2: x%0d", rs1, rs2);
                    $display("  B-type bits: imm[12|10:5] = %b_%b, imm[4:1|11] = %b_%b",
                             instr[31], instr[30:25], instr[11:8], instr[7]);
                    $display("  imm: %0d (0x%08x)", $signed(imm_out), imm_out);
                end
                7'b0110111, 7'b0010111: begin // U-type
                    $display("  Type: U");
                    $display("  rd: x%0d, imm: 0x%08x", rd, imm_out);
                end
                7'b1101111: begin // J-type
                    $display("  Type: J");
                    $display("  rd: x%0d", rd);
                    $display("  J-type bits: imm[20|10:1|11|19:12] = %b_%b_%b_%b",
                             instr[31], instr[30:21], instr[20], instr[19:12]);
                    $display("  imm: %0d (0x%08x)", $signed(imm_out), imm_out);
                end
                default: begin
                    $display("  Tipo: Desconhecido");
                end
            endcase

            $display("%s: imm_out = 0x%08x (%0d) (esperado 0x%08x)", 
                     test_name, imm_out, is_signed ? $signed(imm_out) : imm_out, expected);
            $write("%c[0m", 27); // Reset color
        end
    endtask

    initial begin
        $display("\n== Teste Immediate Generator ==");

        // I-type tests
        instr = 32'b111111111111_00000_000_00001_0010011; // ADDI x1, x0, -1
        test_imm("ADDI -1", 32'hFFFFFFFF, 1);
        
        instr = 32'b000000000000_00000_000_00001_0010011; // ADDI x1, x0, 0
        test_imm("ADDI 0", 32'h00000000, 1);
        
        instr = 32'b000000001010_00000_000_00001_0010011; // ADDI x1, x0, 10
        test_imm("ADDI +10", 32'h0000000A, 1);

        // S-type test
        instr = 32'b1111111_00001_00010_010_11000_0100011; // SW x1, -8(x2) - corrigido
        test_imm("SW -8", 32'hFFFFFFF8, 1);

        // B-type tests
        instr = 32'b0_000000_00010_00001_000_0000_0_1100011; // BEQ x1, x2, 0
        test_imm("BEQ 0", 32'h00000000, 1);
        
        instr = 32'b0_000000_00010_00001_000_0100_0_1100011; // BEQ x1, x2, +8 - imm[4:1]=0100, imm[11]=0
        test_imm("BEQ +4", 32'h00000008, 1); 
        
        instr = 32'b1_111111_00010_00001_000_1100_1_1100011; // BEQ x1, x2, -8 - imm[4:1]=1100, imm[11]=1
        test_imm("BEQ -4", 32'hFFFFFFF8, 1);

        // U-type test
        instr = 32'b00010010001101000101_00001_0110111; // LUI x1, 0x12345
        test_imm("LUI 0x12345", 32'h12345000, 0);
        
        // J-type tests
        instr = 32'b0_0000000000_1_00000000_00000_1101111; // JAL x0, +2048 - imm[11]=1, outros zerados
        test_imm("JAL 2048", 32'h00000800, 1);
        
        instr = 32'b1_0000000000_1_11111111_11111_1101111; // JAL x31, -2048 - imm[11]=1, imm[19:12]=0xFF
        test_imm("JAL -2048", 32'hFFFFF800, 1);

        $finish;
    end

endmodule
