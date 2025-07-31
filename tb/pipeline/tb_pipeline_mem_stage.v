`timescale 1ns / 1ps

`define MEM_BYTE 2'b00
`define MEM_HALF 2'b01
`define MEM_WORD 2'b10

module tb_mem_stage;

    // --- Sinais de Controle ---
    reg clk = 0;
    reg reset;

    // --- Entradas para o DUT (simulando a saída do registrador EX/MEM) ---
    reg [31:0] ex_mem_pc;
    reg [31:0] ex_mem_alu_result;
    reg [31:0] ex_mem_rs2_data;
    reg [4:0]  ex_mem_rd_addr;
    reg [`CONTROL_SIGNALS_WIDTH-1:0] ex_mem_control_signals;
    reg        ex_mem_valid;

    // --- Interface com a memória de dados (DUT -> Memória Simulada) ---
    wire [31:0] dmem_addr;
    wire [31:0] dmem_data_out;
    wire        dmem_read;
    wire        dmem_write;
    wire [3:0]  dmem_byte_enable;
    
    // --- Interface com a memória de dados (Memória Simulada -> DUT) ---
    reg [31:0] dmem_data_in;

    // --- Saídas do DUT (para o registrador MEM/WB) ---
    wire [31:0] mem_wb_pc;
    wire [31:0] mem_wb_alu_result;
    wire [31:0] mem_wb_mem_data;
    wire [4:0]  mem_wb_rd_addr;
    wire [`CONTROL_SIGNALS_WIDTH-1:0] mem_wb_control_signals;
    wire        mem_wb_valid;

    // --- Memória de Dados Simulada ---
    reg [31:0] data_memory [0:1023];

    // Instância do DUT (Device Under Test)
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

    // Geração de Clock
    always #5 clk = ~clk;

    // Lógica da Memória Simulada
    always @(*) begin
        dmem_data_in = data_memory[dmem_addr >> 2];
    end

    always @(posedge clk) begin
        if (dmem_write) begin
            if (dmem_byte_enable[0]) data_memory[dmem_addr >> 2][7:0]   <= dmem_data_out[7:0];
            if (dmem_byte_enable[1]) data_memory[dmem_addr >> 2][15:8]  <= dmem_data_out[15:8];
            if (dmem_byte_enable[2]) data_memory[dmem_addr >> 2][23:16] <= dmem_data_out[23:16];
            if (dmem_byte_enable[3]) data_memory[dmem_addr >> 2][31:24] <= dmem_data_out[31:24];
        end
    end

    // Tarefa para avançar um ciclo
    task next_cycle;
        #10;
    endtask

    // --- Sequência de Teste Principal ---
    initial begin
        $display("\n== Teste do MEM Stage (Simplificado) ==");
        
        // Estado inicial
        reset <= 1;
        ex_mem_control_signals <= 0;
        #10;
        reset <= 0;

        // --- Teste 1: Store Word (sw) ---
        $display("\n-- Teste 1: Store Word (sw) --");
        ex_mem_pc <= 32'h1000;
        ex_mem_alu_result <= 32'h0000_0100; // Endereço de memória
        ex_mem_rs2_data <= 32'hDEADBEEF;   // Dado a ser escrito
        ex_mem_rd_addr <= 5'b0;
        ex_mem_control_signals[`CTRL_MEM_WRITE] <= 1;
        ex_mem_control_signals[`CTRL_MEM_READ] <= 0;
        ex_mem_control_signals[`CTRL_MEM_WIDTH] <= `MEM_WORD;
        ex_mem_valid <= 1;
        
        next_cycle();
        $display("[INFO] SW: Endereço=0x%h, Dado=0x%h, WriteEnable=%b", dmem_addr, dmem_data_out, dmem_write);
        
        // Desativa a escrita para o próximo teste
        ex_mem_control_signals[`CTRL_MEM_WRITE] <= 0;

        // --- Teste 2: Load Word (lw) ---
        $display("\n-- Teste 2: Load Word (lw) --");
        ex_mem_pc <= 32'h1004;
        ex_mem_alu_result <= 32'h0000_0100; // Mesmo endereço
        ex_mem_control_signals[`CTRL_MEM_READ] <= 1;
        ex_mem_valid <= 1;

        next_cycle();
        if (mem_wb_mem_data === 32'hDEADBEEF)
            $display("[PASS] LW: Dado lido corretamente (0x%h)", mem_wb_mem_data);
        else
            $display("[FAIL] LW: Dado lido incorreto (0x%h)", mem_wb_mem_data);

        // --- Dump da Memória ---
        $display("\n-- Dump da Memória (Endereço 0x100) --");
        $display("Mem[0x100] = 0x%h", data_memory[32'h100 >> 2]);

        $display("\n== Fim dos testes ==");
        $finish;
    end

endmodule