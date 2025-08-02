`timescale 1ns / 1ps

module tb_pipeline_full();

    // Entradas
    reg clk = 0;
    reg reset;
    
    // Sinais de debug
    wire [31:0] debug_pc;
    wire [31:0] debug_instruction;
    wire [31:0] debug_registers [0:31];
    wire [31:0] debug_alu_result;
    wire [31:0] debug_wb_data;
    wire [31:0] debug_imem_out;
    wire [31:0] debug_dmem_out;
    
    // Clock (10ns período)
    always #5 clk = ~clk;
    
    // Conexões completas do pipeline
    wire [31:0] imem_addr, imem_data;
    wire imem_read;
    wire [31:0] if_id_pc, if_id_instruction;
    wire if_id_valid;
    
    wire [4:0] id_rs1_addr, id_rs2_addr;
    wire [31:0] id_rs1_data, id_rs2_data;
    
    wire [31:0] id_ex_pc, id_ex_instruction;
    wire [31:0] id_ex_rs1_data, id_ex_rs2_data;
    wire [31:0] id_ex_immediate;
    wire [4:0] id_ex_rd_addr;
    wire [`CONTROL_SIGNALS_WIDTH-1:0] id_ex_control_signals;
    
    wire [31:0] ex_mem_pc;
    wire [31:0] ex_mem_alu_result;
    wire [31:0] ex_mem_rs2_data;
    wire [4:0] ex_mem_rd_addr;
    wire [`CONTROL_SIGNALS_WIDTH-1:0] ex_mem_control_signals;
    
    wire [31:0] mem_wb_pc;
    wire [31:0] mem_wb_alu_result;
    wire [31:0] mem_wb_mem_data;
    wire [4:0] mem_wb_rd_addr;
    wire [`CONTROL_SIGNALS_WIDTH-1:0] mem_wb_control_signals;
    
    wire [31:0] dmem_addr;
    wire [31:0] dmem_data_in;
    wire [31:0] dmem_data_out;
    wire dmem_read;
    wire dmem_write;
    wire [3:0] dmem_byte_enable;

    // Instância da memória de instruções
    instruction_memory #(
        .DEPTH(1024),
        .INIT_FILE("compiler/program.hex")
    ) imem (
        .clk(clk),
        .reset(reset),
        .addr(imem_addr),
        .data_out(imem_data),
        .read_en(imem_read),
        .debug_addr(debug_pc),
        .debug_data_out(debug_imem_out)
    );
    
    // Instância da memória de dados
    data_memory #(
        .DEPTH(1024),
        .INIT_FILE("compiler/data.hex")
    ) dmem (
        .clk(clk),
        .reset(reset),
        .addr(dmem_addr),
        .data_in(dmem_data_out),
        .data_out(dmem_data_in),
        .read_en(dmem_read),
        .write_en(dmem_write),
        .byte_enable(dmem_byte_enable),
        .debug_addr(dmem_addr),
        .debug_data_out(debug_dmem_out)
    );
    
    // Instância dos estágios do pipeline
    if_stage if_stage_inst (
        .clk(clk),
        .reset(reset),
        .stall(1'b0),
        .flush(1'b0),
        .pc_src(1'b0),
        .new_pc(32'b0),
        .imem_addr(imem_addr),
        .imem_data(imem_data),
        .imem_read(imem_read),
        .if_id_pc(if_id_pc),
        .if_id_instruction(if_id_instruction),
        .if_id_valid(if_id_valid)
    );
    
    id_stage id_stage_inst (
        .clk(clk),
        .reset(reset),
        .stall(1'b0),
        .flush(1'b0),
        .if_id_pc(if_id_pc),
        .if_id_instruction(if_id_instruction),
        .if_id_valid(if_id_valid),
        .mem_wb_rd_addr(mem_wb_rd_addr),
        .mem_wb_rd_data(debug_wb_data),
        .mem_wb_reg_write(mem_wb_control_signals[`CTRL_REG_WRITE]),
        .id_ex_pc(id_ex_pc),
        .id_ex_instruction(id_ex_instruction),
        .id_ex_rs1_data(id_ex_rs1_data),
        .id_ex_rs2_data(id_ex_rs2_data),
        .id_ex_immediate(id_ex_immediate),
        .id_ex_rd_addr(id_ex_rd_addr),
        .id_ex_control_signals(id_ex_control_signals),
        .rs1_addr(id_rs1_addr),
        .rs2_addr(id_rs2_addr),
        .rs1_data(id_rs1_data),
        .rs2_data(id_rs2_data)
    );
    
    ex_stage ex_stage_inst (
        .clk(clk),
        .reset(reset),
        .id_ex_pc(id_ex_pc),
        .id_ex_instruction(id_ex_instruction),
        .id_ex_rs1_data(id_ex_rs1_data),
        .id_ex_rs2_data(id_ex_rs2_data),
        .id_ex_immediate(id_ex_immediate),
        .id_ex_rd_addr(id_ex_rd_addr),
        .id_ex_control_signals(id_ex_control_signals),
        .ex_mem_pc(ex_mem_pc),
        .ex_mem_alu_result(ex_mem_alu_result),
        .ex_mem_rs2_data(ex_mem_rs2_data),
        .ex_mem_rd_addr(ex_mem_rd_addr),
        .ex_mem_control_signals(ex_mem_control_signals),
        .forward_a(2'b00), // Desabilitado inicialmente
        .forward_b(2'b00), // Desabilitado inicialmente
        .mem_wb_alu_result(mem_wb_alu_result),
        .mem_wb_mem_data(mem_wb_mem_data),
        .branch_taken(),
        .branch_target()
    );
    
    mem_stage mem_stage_inst (
        .clk(clk),
        .reset(reset),
        .ex_mem_pc(ex_mem_pc),
        .ex_mem_alu_result(ex_mem_alu_result),
        .ex_mem_rs2_data(ex_mem_rs2_data),
        .ex_mem_rd_addr(ex_mem_rd_addr),
        .ex_mem_control_signals(ex_mem_control_signals),
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
        .mem_wb_control_signals(mem_wb_control_signals)
    );
    
    // Atribuição do WB data para debug
    assign debug_wb_data = mem_wb_control_signals[`CTRL_MEM_TO_REG] ? mem_wb_mem_data : mem_wb_alu_result;
    
    // Banco de registradores
    register_file #(
        .WIDTH(32),
        .DEPTH(32)
    ) reg_file (
        .clk(clk),
        .reset(reset),
        .rs1_addr(id_rs1_addr),
        .rs2_addr(id_rs2_addr),
        .rd_addr(mem_wb_rd_addr),
        .rd_data(debug_wb_data),
        .reg_write(mem_wb_control_signals[`CTRL_REG_WRITE]),
        .rs1_data(id_rs1_data),
        .rs2_data(id_rs2_data),
        .debug_registers(debug_registers)
    );
    
    // Atribuições para debug
    assign debug_pc = if_id_pc;
    assign debug_instruction = if_id_instruction;
    assign debug_alu_result = ex_mem_alu_result;
    
    integer cycle_count = 0;
    integer i;
    
    initial begin
        // Inicialização
        $dumpfile("pipeline_full.vcd");
        $dumpvars(0, tb_pipeline_full);
        
        reset = 1;
        #20;
        reset = 0;
        
        $display("\n=== Conteúdo Inicial da Memória de Instruções ===");
        for (i = 0; i < 8; i = i + 1) begin
            force imem.debug_addr = i * 4;
            #1;
            $display("imem[%h] = %h", i * 4, debug_imem_out);
            release imem.debug_addr;
        end
        
        $display("\n=== Execução do Pipeline Completo ===");
        $display("Ciclo |   PC   | Instrução  | ALU Res | WB Data  | RD");
        $display("-----------------------------------------------------");
        
        // Executa por 20 ciclos
        for (cycle_count = 0; cycle_count < 20; cycle_count = cycle_count + 1) begin
            @(posedge clk);
            #1; // Pequeno atraso para estabilização
            
            $display("%5d | %h | %h | %h | %h | x%d",
                   cycle_count,
                   if_id_pc,
                   if_id_instruction,
                   debug_alu_result,
                   debug_wb_data,
                   mem_wb_rd_addr);
        end
        
        $display("\n=== Estado Final dos Registradores ===");
        for (i = 0; i < 32; i = i + 1) begin
            $display("x%2d = %h", i, debug_registers[i]);
        end
        
        $display("\n=== Primeiras Posições da Memória de Dados ===");
        for (i = 0; i < 8; i = i + 1) begin
            force dmem.debug_addr = i * 4;
            #1;
            $display("dmem[%h] = %h", i * 4, debug_dmem_out);
            release dmem.debug_addr;
        end
        
        $finish;
    end

endmodule