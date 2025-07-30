`timescale 1ns/1ps
`include "constants.v"

module tb_wb_stage;

    // Entradas
    reg [31:0] mem_alu_result;
    reg [31:0] mem_mem_data;
    reg [`CONTROL_SIGNALS_WIDTH-1:0] mem_control_signals;

    // Saída
    wire [31:0] wb_data;

    // DUT
    wb_stage dut (
        .mem_alu_result(mem_alu_result),
        .mem_mem_data(mem_mem_data),
        .mem_control_signals(mem_control_signals),
        .wb_data(wb_data)
    );

    // Função de checagem
    task check(string name, input [31:0] got, input [31:0] expected);
        begin
            if (got !== expected) begin
                $display("\033[1;31m[FAIL]\033[0m %s: Esperado 0x%h, Obteve 0x%h", name, expected, got);
            end else begin
                $display("\033[1;32m[PASS]\033[0m %s: Valor 0x%h", name, got);
            end
        end
    endtask

    initial begin
        $display("\n---- TESTE WB_STAGE ----\n");

        // -------------------
        // Teste: MEM_TO_REG = 0 (usar resultado da ALU)
        // -------------------
        mem_alu_result = 32'hDEAD_BEEF;
        mem_mem_data = 32'hCAFE_BABE;
        mem_control_signals = 0;
        mem_control_signals[`MEM_TO_REG] = 0;
        #1;
        check("ALU result (MEM_TO_REG = 0)", wb_data, 32'hDEADBEEF);

        // -------------------
        // Teste: MEM_TO_REG = 1 (usar dado da memória)
        // -------------------
        mem_control_signals[`MEM_TO_REG] = 1;
        #1;
        check("Mem result (MEM_TO_REG = 1)", wb_data, 32'hCAFEBABE);

        // -------------------
        // Teste: MEM_TO_REG default (inválido = X) - esperado 0
        // -------------------
        mem_control_signals[`MEM_TO_REG] = 1'bx;
        #1;
        check("MEM_TO_REG inválido", wb_data, 32'h00000000);

        $display("\n---- FIM DOS TESTES ----\n");
        $finish;
    end

endmodule
