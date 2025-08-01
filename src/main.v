`timescale 1ns / 1ps

module main (
    input wire clk,
    input wire reset,
    input wire step_en,

    output wire [31:0] debug_pc,
    output wire [31:0] debug_instruction,
    output wire debug_stall,
    output wire debug_flush
);

    // Clock do processador (ativado por step_en)
    wire cpu_clk;
    assign cpu_clk = clk & step_en;

    // Memórias internas expostas para o C++ via Verilator
    (* verilator public_flat_rd *) reg [31:0] dmem_internal [0:255];
    (* verilator public_flat_rd *) wire [31:0] debug_registers_internal [0:31];

    // Interconexão
    wire [31:0] imem_addr;
    wire [31:0] imem_data;
    wire imem_read;

    wire [31:0] dmem_addr;
    wire [31:0] dmem_data_in;
    wire [31:0] dmem_data_out;
    wire dmem_read;
    wire dmem_write;
    wire [3:0] dmem_byte_enable;

    // Load da memória
    assign dmem_data_in = dmem_internal[dmem_addr[9:2]];

    // Escrita na RAM com byte enable
    always @(posedge cpu_clk) begin
        if (dmem_write) begin
            if (dmem_byte_enable[0])
                dmem_internal[dmem_addr[9:2]][7:0]   <= dmem_data_out[7:0];
            if (dmem_byte_enable[1])
                dmem_internal[dmem_addr[9:2]][15:8]  <= dmem_data_out[15:8];
            if (dmem_byte_enable[2])
                dmem_internal[dmem_addr[9:2]][23:16] <= dmem_data_out[23:16];
            if (dmem_byte_enable[3])
                dmem_internal[dmem_addr[9:2]][31:24] <= dmem_data_out[31:24];
        end
    end

    // Sinais de debug para inicialização externa via Verilator
    // Expostos para acesso externo (C++ via Verilator)
    (* verilator public_flat_rw *) wire        debug_en;
    (* verilator public_flat_rw *) wire [31:0] debug_addr;
    (* verilator public_flat_rw *) wire [31:0] debug_data_in;
    (* verilator public_flat_rw *) wire        debug_write_en;
    (* verilator public_flat_rd *) wire [31:0] debug_data_out;
    (* verilator public_flat_rd *) wire [31:0] debug_mem_out [0:1023];

    // Instanciação da memória de instrução
    instruction_memory imem (
        .clk(clk),                      // Usa o clock global
        .reset(reset),                  // Reset para zerar ou preparar estado
        .addr(imem_addr),               // Endereço requisitado pela CPU
        .data_out(imem_data),           // Dados para a CPU
        .read_en(imem_read),            // Habilita leitura
        .debug_en(debug_en),            // Habilita debug (externo via C++)
        .debug_addr(debug_addr),        // Endereço de debug
        .debug_data_in(debug_data_in),  // Valor para escrita em debug
        .debug_write_en(debug_write_en),// Habilita escrita em debug
        .debug_data_out(debug_data_out), // Saída de leitura de debug
        .debug_mem_out(debug_mem_out)
    );

    // Instanciação do processador
    rv32e_cpu cpu (
        .clk(cpu_clk),
        .reset(reset),
        .imem_addr(imem_addr),
        .imem_data(imem_data),
        .imem_read(imem_read),
        .dmem_addr(dmem_addr),
        .dmem_data_in(dmem_data_in),
        .dmem_data_out(dmem_data_out),
        .dmem_read(dmem_read),
        .dmem_write(dmem_write),
        .dmem_byte_enable(dmem_byte_enable),
        .debug_pc(debug_pc),
        .debug_instruction(debug_instruction),
        .debug_stall(debug_stall),
        .debug_flush(debug_flush),
        .debug_registers(debug_registers_internal)
    );

endmodule
