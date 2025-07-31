`timescale 1ns / 1ps
`include "constants.v"

module tb_control_unit();

    reg [31:0] instruction;
    wire [`CONTROL_SIGNALS_WIDTH-1:0] control_signals;

    control_unit uut (
        .instruction(instruction),
        .control_signals(control_signals)
    );

    task check_signals;
        input [`CONTROL_SIGNALS_WIDTH-1:0] expected;
        begin
            #1;
            if (control_signals !== expected) begin
                $display("\033[31mFAIL\033[0m Instruction=%h -> got %b, expected %b",
                         instruction, control_signals, expected);
            end else begin
                $display("\033[32mPASS\033[0m Instruction=%h -> %b",
                         instruction, control_signals);
            end
        end
    endtask

    initial begin
        $display("== Teste da Unidade de Controle ==");

        // R-Type ADD: opcode=0110011, funct3=000, funct7=0000000
        instruction = {7'b0000000, 5'b0, 5'b0, 3'b000, 5'b0, 7'b0110011};
        check_signals(20'b0000_0000_0000_0000_0001);  // Adjust based on your actual encoding

        // I-Type ADDI: opcode=0010011, funct3=000
        instruction = {12'b0, 5'b0, 3'b000, 5'b0, 7'b0010011};
        check_signals(20'b0000_0000_0100_0000_0001);  // Adjust based on your actual encoding

        // LOAD LW: opcode=0000011, funct3=010
        instruction = {12'b0, 5'b0, 3'b010, 5'b0, 7'b0000011};
        check_signals(20'b0000_0011_0100_0000_0011);  // Adjust based on your actual encoding

        // STORE SW: opcode=0100011, funct3=010
        instruction = {7'b0, 5'b0, 5'b0, 3'b010, 5'b0, 7'b0100011};
        check_signals(20'b0000_1100_0100_0000_0000);  // Adjust based on your actual encoding

        // BRANCH BEQ: opcode=1100011, funct3=000
        instruction = {7'b0, 5'b0, 5'b0, 3'b000, 5'b0, 7'b1100011};
        check_signals(20'b0001_0001_0000_0000_0000);  // Adjust based on your actual encoding

        // JAL
        instruction = {20'b0, 7'b1101111};
        check_signals(20'b0110_0000_0000_0000_0011);  // Adjust based on your actual encoding

        $display("Fim dos testes");
        $finish;
    end

endmodule