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
    (* verilator public *) reg [31:0] imem_internal [0:255];
    (* verilator public *) reg [31:0] dmem_internal [0:255];
    (* verilator public *) wire [31:0] debug_registers_internal [0:31];
    
    // Initialize memories
    initial begin
        integer i;
        for (i = 0; i < 256; i = i + 1) begin
            imem_internal[i] = 32'h00000000;
            dmem_internal[i] = 32'h00000000;
        end
    end

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

    // Fetch da instrução
    assign imem_data = imem_internal[imem_addr[9:2]];

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
