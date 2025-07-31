`timescale 1ns/1ps
`include "constants.v"

module tb_mem_stage;

    // Entradas
    reg clk = 0;
    reg reset = 0;
    reg [31:0] ex_mem_pc;
    reg [31:0] ex_mem_alu_result;
    reg [31:0] ex_mem_rs2_data;
    reg [4:0]  ex_mem_rd_addr;
    reg [`CONTROL_SIGNALS_WIDTH-1:0] ex_mem_control_signals;
    reg ex_mem_valid;

    // Memória
    reg [31:0] dmem_data_in;
    wire [31:0] dmem_addr;
    wire [31:0] dmem_data_out;
    wire dmem_read;
    wire dmem_write;
    wire [3:0] dmem_byte_enable;

    // Saídas WB
    wire [31:0] mem_wb_pc;
    wire [31:0] mem_wb_alu_result;
    wire [31:0] mem_wb_mem_data;
    wire [4:0]  mem_wb_rd_addr;
    wire [`CONTROL_SIGNALS_WIDTH-1:0] mem_wb_control_signals;
    wire mem_wb_valid;

    // DUT
    mem_stage dut (
        .clk(clk),
        .reset(reset),
        .ex_mem_pc(ex_mem_pc),
        .ex_mem_alu_result(ex_mem_alu_result),
        .ex_mem_rs2_data(ex_mem_rs2_data),
        .ex_mem_rd_addr(ex_mem_rd_addr),
        .ex_mem_control_signals(ex_mem_control_signals),
        .ex_mem_valid(ex_mem_valid),
        .dmem_addr(dmem_addr),
        .dmem_data_in(dmem_data_in),
        .dmem_data_out(dmem_data_out),
        .dmem_read(dmem_read),
        .dmem_write(dmem_write),
        .dmem_byte_enable(dmem_byte_enable),
        .mem_wb_pc(mem_wb_pc),
        .mem_wb_alu_result(mem_wb_alu_result),
        .mem_wb_mem_data(mem_wb_mem_data),
        .mem_wb_rd_addr(mem_wb_rd_addr),
        .mem_wb_control_signals(mem_wb_control_signals),
        .mem_wb_valid(mem_wb_valid)
    );

    // Clock
    always #5 clk = ~clk;

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
        $display("\n---- TESTE MEM_STAGE ----\n");
        reset = 1;
        #10;
        reset = 0;
        ex_mem_valid = 1;

        // -------------------
        // Teste LBU (load byte unsigned)
        // -------------------
        ex_mem_pc = 32'h00000004;
        ex_mem_alu_result = 32'h00000000; // endereço final
        dmem_data_in = 32'hFF_00_00_00; // byte 0 = 0xFF
        ex_mem_rs2_data = 32'hDEADBEEF; // dummy
        ex_mem_rd_addr = 5'd1;

        ex_mem_control_signals = 0;
        ex_mem_control_signals[`CTRL_MEM_READ] = 1;
        ex_mem_control_signals[`CTRL_MEM_WIDTH] = `MEM_BYTE;
        ex_mem_control_signals[`CTRL_MEM_UNSIGNED] = 1;

        #10;
        check("LBU", mem_wb_mem_data, 32'h000000FF);

        // -------------------
        // Teste LB (load byte signed)
        // -------------------
        ex_mem_alu_result = 32'h00000000;
        dmem_data_in = 32'h80_00_00_00; // byte 0 = 0x80 (signed = -128)
        ex_mem_control_signals[`CTRL_MEM_UNSIGNED] = 0;
        #10;
        check("LB", mem_wb_mem_data, 32'hFFFFFF80);

        // -------------------
        // Teste LHU (load half unsigned)
        // -------------------
        ex_mem_alu_result = 32'h00000002;
        dmem_data_in = 32'h0000_FFFF; // half superior
        ex_mem_control_signals[`CTRL_MEM_WIDTH] = `MEM_HALF;
        ex_mem_control_signals[`CTRL_MEM_UNSIGNED] = 1;
        #10;
        check("LHU", mem_wb_mem_data, 32'h0000FFFF);

        // -------------------
        // Teste LH (load half signed)
        // -------------------
        dmem_data_in = 32'h0000_8000; // 0x8000 = -32768
        ex_mem_control_signals[`CTRL_MEM_UNSIGNED] = 0;
        #10;
        check("LH", mem_wb_mem_data, 32'hFFFF8000);

        // -------------------
        // Teste LW (load word)
        // -------------------
        ex_mem_alu_result = 32'h00000000;
        dmem_data_in = 32'hCAFEBABE;
        ex_mem_control_signals[`CTRL_MEM_WIDTH] = `MEM_WORD;
        #10;
        check("LW", mem_wb_mem_data, 32'hCAFEBABE);

        // -------------------
        // Teste SW (store word)
        // -------------------
        ex_mem_alu_result = 32'h10000000;
        ex_mem_rs2_data = 32'h12345678;
        ex_mem_control_signals = 0;
        ex_mem_control_signals[`CTRL_MEM_WRITE] = 1;
        ex_mem_control_signals[`CTRL_MEM_WIDTH] = `MEM_WORD;
        #1; // Wait for combinational logic
        check("SW addr", dmem_addr, 32'h10000000);
        check("SW data", dmem_data_out, 32'h12345678);
        check("SW write", dmem_write, 1'b1);
        check("SW byte enable", dmem_byte_enable, 4'b1111);

        $display("\n---- FIM DOS TESTES ----\n");
        $finish;
    end
endmodule