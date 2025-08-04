`timescale 1ns / 1ps

module tb_control_unit;

    // Entradas
    reg [6:0] opcode;

    // Saídas
    wire [1:0] ALUOp;
    wire ALUSrc;
    wire RegWrite;

    // Instancia o módulo sob teste
    control_unit uut (
        .opcode(opcode),
        .ALUOp(ALUOp),
        .ALUSrc(ALUSrc),
        .RegWrite(RegWrite)
    );

    // Função para imprimir colorido no terminal
    task check_output;
        input [6:0] test_opcode;
        input [1:0] expected_ALUOp;
        input expected_ALUSrc;
        input expected_RegWrite;
        begin
            opcode = test_opcode;
            #1; // Espera propagação

            $write("Opcode: 0x%02h | ", opcode);

            if (ALUOp == expected_ALUOp && ALUSrc == expected_ALUSrc && RegWrite == expected_RegWrite)
                $display("\033[0;32m[PASS]\033[0m ALUOp=%b ALUSrc=%b RegWrite=%b", ALUOp, ALUSrc, RegWrite);
            else begin
                $display("\033[0;31m[FAIL]\033[0m Expected: ALUOp=%b ALUSrc=%b RegWrite=%b | Got: ALUOp=%b ALUSrc=%b RegWrite=%b",
                         expected_ALUOp, expected_ALUSrc, expected_RegWrite,
                         ALUOp, ALUSrc, RegWrite);
            end
        end
    endtask

    initial begin
        $display("=== Testbench: control_unit ===");

        //            opcode     ALUOp ALUSrc RegWrite
        check_output(7'b0110011, 2'b10, 1'b0, 1'b1); // R-type
        check_output(7'b0010011, 2'b00, 1'b1, 1'b1); // I-type
        check_output(7'b0000011, 2'b00, 1'b1, 1'b1); // Load
        check_output(7'b0100011, 2'b00, 1'b1, 1'b0); // Store
        check_output(7'b1100011, 2'b01, 1'b0, 1'b0); // Branch
        check_output(7'b0110111, 2'b11, 1'b1, 1'b1); // LUI
        check_output(7'b0010111, 2'b00, 1'b1, 1'b1); // AUIPC
        check_output(7'b1101111, 2'b00, 1'b1, 1'b1); // JAL
        check_output(7'b1100111, 2'b00, 1'b1, 1'b1); // JALR

        // Teste com opcode inválido
        check_output(7'b1111111, 2'b00, 1'b0, 1'b0); // Unknown

        $display("=== Testes finalizados ===");
        $finish;
    end

endmodule
