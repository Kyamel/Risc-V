`timescale 1ns / 1ps
module tb_control_unit();

    reg [6:0] opcode;
    reg [2:0] funct3;
    reg [6:0] funct7;
    wire [15:0] control_signals;

    control_unit uut (
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .control_signals(control_signals)
    );

    task check_signals;
        input [15:0] expected;
        begin
            #1;
            if (control_signals !== expected) begin
                $display("\033[31mFAIL\033[0m Opcode=%b funct3=%b funct7=%b -> got %b, expected %b",
                         opcode, funct3, funct7, control_signals, expected);
            end else begin
                $display("\033[32mPASS\033[0m Opcode=%b funct3=%b funct7=%b -> %b",
                         opcode, funct3, funct7, control_signals);
            end
        end
    endtask

    initial begin
        $display("== Teste da Unidade de Controle ==");

        // R-Type ADD: opcode=0110011, funct3=000, funct7=0000000
        opcode = 7'b0110011; funct3 = 3'b000; funct7 = 7'b0000000;
        check_signals(16'b0000_0000_0000_0001);  // reg_write=1, alu_op=0... (ajuste conforme a codificação)

        // I-Type ADDI: opcode=0010011, funct3=000, funct7=0000000
        opcode = 7'b0010011; funct3 = 3'b000; funct7 = 7'b0000000;
        check_signals(16'b0000_0000_0100_0001);  // reg_write=1, alu_src=1

        // LOAD LW: opcode=0000011
        opcode = 7'b0000011; funct3 = 3'b010; funct7 = 7'b0000000;
        check_signals(16'b0000_0011_0100_0011);  // reg_write=1, mem_to_reg=1, mem_read=1, alu_src=1

        // STORE SW: opcode=0100011
        opcode = 7'b0100011; funct3 = 3'b010; funct7 = 7'b0000000;
        check_signals(16'b0000_1100_0100_0000);  // mem_write=1, alu_src=1

        // BRANCH BEQ: opcode=1100011, funct3=000
        opcode = 7'b1100011; funct3 = 3'b000; funct7 = 7'b0000000;
        check_signals(16'b0001_0001_0000_0000);  // branch=1, alu_op=SUB(1)

        // JAL
        opcode = 7'b1101111; funct3 = 3'b000; funct7 = 7'b0000000;
        check_signals(16'b0110_0000_0000_0011);  // jump=1, reg_write=1, pc_src=10

        $display("Fim dos testes");
        $finish;
    end

endmodule
