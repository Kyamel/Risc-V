`timescale 1ns / 1ps

module data_memory #(
    parameter WIDTH = 32,               // Word width in bits
    parameter DEPTH = 1024,             // Number of words
    parameter INIT_FILE = "none"        // Optional initialization file (hex)
) (
    input wire clk,

    input wire [WIDTH-1:0] mem_addr,    // Byte address (from the ALU)
    input wire [WIDTH-1:0] write_data,
    input wire mem_write,
    input wire mem_read,
    output reg [WIDTH-1:0] read_data
);

    localparam ADDR_WIDTH = $clog2(DEPTH);
    reg [WIDTH-1:0] memory [0:DEPTH-1];

    // Initialization: all zeros, then the optional file
    integer i;
    initial begin
        for (i = 0; i < DEPTH; i = i + 1) begin
            memory[i] = 32'h0;
        end

        if (INIT_FILE != "none") begin
            $readmemh(INIT_FILE, memory);
        end
    end

    // Word index (word accesses only; the low 2 bits are ignored)
    wire [ADDR_WIDTH-1:0] word_addr = mem_addr[$clog2(DEPTH)+1:2];

    // Combinational read
    always @(*) begin
        if (mem_read) begin
            read_data = memory[word_addr];
        end else begin
            read_data = 32'h0;
        end
    end

    // Synchronous write
    always @(posedge clk) begin
        if (mem_write) begin
            memory[word_addr] <= write_data;
            $display("MEM WRITE: addr=0x%08h, data=0x%08h", mem_addr, write_data);
        end
    end

endmodule
