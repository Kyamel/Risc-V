`timescale 1ns / 1ps

// Definimos a constante necessária para compilar o módulo.

// Incluímos o seu módulo de pipeline_registers.
// Certifique-se de que o caminho para o arquivo está correto.
module tb_pipeline_registers;

    // --- Sinais de Controle ---
    reg clk = 0;
    reg reset;
    reg stall;
    reg flush;

    // --- Entradas para o DUT (Device Under Test) ---
    reg [31:0] if_pc;
    reg [31:0] if_instruction;
    reg        if_valid;
    
    reg [31:0] id_pc_in;
    reg [31:0] id_instruction_in;
    reg [31:0] id_rs1_data_in;
    reg [31:0] id_rs2_data_in;
    reg [31:0] id_immediate_in;
    reg [4:0]  id_rd_addr_in;
    reg [4:0]  id_rs1_addr_in;
    reg [4:0]  id_rs2_addr_in;
    reg [`CONTROL_SIGNALS_WIDTH-1:0] id_control_signals_in;
    reg        id_valid_in;
    
    reg [31:0] ex_pc_in;
    reg [31:0] ex_alu_result_in;
    reg [31:0] ex_rs2_data_in;
    reg [4:0]  ex_rd_addr_in;
    reg [`CONTROL_SIGNALS_WIDTH-1:0] ex_control_signals_in;
    reg        ex_valid_in;
    
    reg [31:0] mem_pc_in;
    reg [31:0] mem_alu_result_in;
    reg [31:0] mem_mem_data_in;
    reg [4:0]  mem_rd_addr_in;
    reg [`CONTROL_SIGNALS_WIDTH-1:0] mem_control_signals_in;
    reg        mem_valid_in;

    // --- CORREÇÃO: Declaração explícita dos fios de saída ---
    wire [31:0] id_pc;
    wire [31:0] id_instruction;
    wire        id_valid;
    
    wire [31:0] ex_pc;
    wire [31:0] ex_instruction;
    wire [31:0] ex_rs1_data;
    wire [31:0] ex_rs2_data;
    wire [31:0] ex_immediate;
    wire [4:0]  ex_rd_addr;
    wire [4:0]  ex_rs1_addr;
    wire [4:0]  ex_rs2_addr;
    wire [`CONTROL_SIGNALS_WIDTH-1:0] ex_control_signals;
    wire        ex_valid;
    
    wire [31:0] mem_pc;
    wire [31:0] mem_alu_result;
    wire [31:0] mem_rs2_data;
    wire [4:0]  mem_rd_addr;
    wire [`CONTROL_SIGNALS_WIDTH-1:0] mem_control_signals;
    wire        mem_valid;
    
    wire [31:0] wb_pc;
    wire [31:0] wb_alu_result;
    wire [31:0] wb_mem_data;
    wire [4:0]  wb_rd_addr;
    wire [`CONTROL_SIGNALS_WIDTH-1:0] wb_control_signals;
    wire        wb_valid;


    // Instância do DUT
    pipeline_registers dut (
        .clk(clk), .reset(reset), .stall(stall), .flush(flush),
        
        // IF/ID
        .if_pc(if_pc), .if_instruction(if_instruction), .if_valid(if_valid),
        .id_pc(id_pc), .id_instruction(id_instruction), .id_valid(id_valid),
        
        // ID/EX
        .id_pc_in(id_pc_in), .id_instruction_in(id_instruction_in), .id_rs1_data_in(id_rs1_data_in), 
        .id_rs2_data_in(id_rs2_data_in), .id_immediate_in(id_immediate_in), .id_rd_addr_in(id_rd_addr_in), 
        .id_rs1_addr_in(id_rs1_addr_in), .id_rs2_addr_in(id_rs2_addr_in), .id_control_signals_in(id_control_signals_in), 
        .id_valid_in(id_valid_in),
        .ex_pc(ex_pc), .ex_instruction(ex_instruction), .ex_rs1_data(ex_rs1_data), .ex_rs2_data(ex_rs2_data),
        .ex_immediate(ex_immediate), .ex_rd_addr(ex_rd_addr), .ex_rs1_addr(ex_rs1_addr), .ex_rs2_addr(ex_rs2_addr),
        .ex_control_signals(ex_control_signals), .ex_valid(ex_valid),

        // EX/MEM
        .ex_pc_in(ex_pc_in), .ex_alu_result_in(ex_alu_result_in), .ex_rs2_data_in(ex_rs2_data_in),
        .ex_rd_addr_in(ex_rd_addr_in), .ex_control_signals_in(ex_control_signals_in), .ex_valid_in(ex_valid_in),
        .mem_pc(mem_pc), .mem_alu_result(mem_alu_result), .mem_rs2_data(mem_rs2_data), .mem_rd_addr(mem_rd_addr),
        .mem_control_signals(mem_control_signals), .mem_valid(mem_valid),

        // MEM/WB
        .mem_pc_in(mem_pc_in), .mem_alu_result_in(mem_alu_result_in), .mem_mem_data_in(mem_mem_data_in),
        .mem_rd_addr_in(mem_rd_addr_in), .mem_control_signals_in(mem_control_signals_in), .mem_valid_in(mem_valid_in),
        .wb_pc(wb_pc), .wb_alu_result(wb_alu_result), .wb_mem_data(wb_mem_data), .wb_rd_addr(wb_rd_addr),
        .wb_control_signals(wb_control_signals), .wb_valid(wb_valid)
    );

    // Geração de Clock
    always #5 clk = ~clk;

    // Tarefa para avançar um ciclo de clock
    task next_cycle;
        #10;
    endtask

    // --- Sequência de Teste Principal ---
    initial begin
        $display("\n== Teste dos Registradores de Pipeline (Corrigido) ==");

        // --- Teste 1: Reset ---
        $display("\n-- Teste 1: Reset --");
        reset <= 1;
        stall <= 0;
        flush <= 0;
        next_cycle();
        if (id_pc === 32'h0 && id_valid === 1'b0 && ex_pc === 32'h0 && ex_valid === 1'b0)
            $display("[PASS] Registradores zerados após reset.");
        else
            $display("[FAIL] Registradores não foram zerados corretamente.");
        reset <= 0;

        // --- Teste 2: Propagação de uma instrução ---
        $display("\n-- Teste 2: Propagação de uma instrução --");
        // Ciclo 1: IF -> ID
        if_pc <= 32'h1000; if_instruction <= 32'hAAAA_BBBB; if_valid <= 1'b1;
        next_cycle();
        if (id_pc === 32'h1000) $display("[PASS] Ciclo 1: IF -> ID"); else $display("[FAIL] Ciclo 1");

        // Ciclo 2: ID -> EX
        id_pc_in <= id_pc; id_instruction_in <= id_instruction; id_valid_in <= id_valid;
        if_pc <= 32'h1004; // Nova instrução entra no pipeline
        next_cycle();
        if (ex_pc === 32'h1000) $display("[PASS] Ciclo 2: ID -> EX"); else $display("[FAIL] Ciclo 2");

        // Ciclo 3: EX -> MEM
        ex_pc_in <= ex_pc; ex_valid_in <= ex_valid;
        id_pc_in <= id_pc; id_valid_in <= id_valid;
        next_cycle();
        if (mem_pc === 32'h1000) $display("[PASS] Ciclo 3: EX -> MEM"); else $display("[FAIL] Ciclo 3");

        // Ciclo 4: MEM -> WB
        mem_pc_in <= mem_pc; mem_valid_in <= mem_valid;
        ex_pc_in <= ex_pc; ex_valid_in <= ex_valid;
        next_cycle();
        if (wb_pc === 32'h1000) $display("[PASS] Ciclo 4: MEM -> WB"); else $display("[FAIL] Ciclo 4");

        // --- Teste 3: Stall ---
        $display("\n-- Teste 3: Stall --");
        if_pc <= 32'h2000; if_instruction <= 32'hCCCC_DDDD; if_valid <= 1'b1;
        id_pc_in <= id_pc; id_instruction_in <= id_instruction; id_valid_in <= id_valid;
        next_cycle(); // Deixa os dados entrarem em IF/ID e ID/EX
        
        stall <= 1;
        next_cycle();
        if (id_pc === 32'h2000 && ex_pc === 32'h1004)
            $display("[PASS] Stall: IF/ID e ID/EX congelados corretamente.");
        else
            $display("[FAIL] Stall: IF/ID ou ID/EX não congelaram.");
        
        stall <= 0;
        
        // --- Teste 4: Flush ---
        $display("\n-- Teste 4: Flush --");
        next_cycle(); // Avança um ciclo
        flush <= 1;
        next_cycle();
        if (id_pc === 32'h0 && id_valid === 1'b0 && ex_pc === 32'h0 && ex_valid === 1'b0)
            $display("[PASS] Flush: IF/ID e ID/EX foram limpos.");
        else
            $display("[FAIL] Flush: IF/ID ou ID/EX não foram limpos.");
        
        flush <= 0;

        $display("\n== Fim dos testes ==");
        $finish;
    end

endmodule