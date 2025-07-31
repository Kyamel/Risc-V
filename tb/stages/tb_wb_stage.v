`timescale 1ns/1ps
`include "core/constants.v"

module tb_wb_stage;

    // Entradas
    reg [31:0] mem_wb_alu_result;
    reg [31:0] mem_wb_mem_data;
    reg [`CONTROL_SIGNALS_WIDTH-1:0] mem_wb_control_signals;

    // Saída
    wire [31:0] wb_data;

    // DUT
    wb_stage dut (
        .mem_wb_alu_result(mem_wb_alu_result),
        .mem_wb_mem_data(mem_wb_mem_data),
        .mem_wb_control_signals(mem_wb_control_signals),
        .wb_data(wb_data)
    );

    // Função de checagem
    task check;
        input string name;
        input [31:0] got;
        input [31:0] expected;
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
        // Teste: CTRL_MEM_TO_REG = 0 (usar resultado da ALU)
        // -------------------
        mem_wb_alu_result = 32'hDEADBEEF;
        mem_wb_mem_data = 32'hCAFEBABE;
        mem_wb_control_signals = 0;
        mem_wb_control_signals[`CTRL_MEM_TO_REG] = 0;
        #1;
        check("ALU result (CTRL_MEM_TO_REG = 0)", wb_data, 32'hDEADBEEF);

        // -------------------
        // Teste: CTRL_MEM_TO_REG = 1 (usar dado da memória)
        // -------------------
        mem_wb_control_signals[`CTRL_MEM_TO_REG] = 1;
        #1;
        check("Mem result (CTRL_MEM_TO_REG = 1)", wb_data, 32'hCAFEBABE);

        // -------------------
        // Teste: Verificar se a seleção ainda funciona com reg_write = 0
        // -------------------
        mem_wb_control_signals[`CTRL_REG_WRITE] = 0;
        mem_wb_alu_result = 32'h12345678;
        mem_wb_mem_data = 32'h87654321;
        mem_wb_control_signals[`CTRL_MEM_TO_REG] = 0; // Seleciona ALU result
        #1;
        check("Seleção com reg_write=0 (ALU)", wb_data, 32'h12345678);

        mem_wb_control_signals[`CTRL_MEM_TO_REG] = 1; // Seleciona mem data
        #1;
        check("Seleção com reg_write=0 (Mem)", wb_data, 32'h87654321);

        $display("\n---- FIM DOS TESTES ----\n");
        $finish;
    end

endmodule