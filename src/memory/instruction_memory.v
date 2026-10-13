`timescale 1ns / 1ps

module instruction_memory #(
    parameter WIDTH     = 32,          // Instruction width
    parameter DEPTH     = 256,         // Number of instructions
    parameter INIT_FILE = ""           // Optional initialization file (hex)
)(
    input wire [31:0] instr_addr,      // Byte address (PC)

    output wire [WIDTH-1:0] instr
);

    reg [WIDTH-1:0] memory [0:DEPTH-1];

    // Combinational read
    assign instr = memory[instr_addr[$clog2(DEPTH)+1:2]]; // addr >> 2

    // Initialization: everything is a NOP (addi x0, x0, 0), then the optional file
    integer i;
    initial begin
        for (i = 0; i < DEPTH; i = i + 1) begin
            memory[i] = 32'h00000013;
        end
        if (INIT_FILE != "") begin
            $display("Loading instruction memory from %s", INIT_FILE);
            $readmemh(INIT_FILE, memory);
        end
    end

endmodule
