module instruction_memory (
    input  [31:0] addr,
    output [31:0] instr
);
    reg [31:0] memory [0:255];  // 256 palavras = 1 KB

    initial begin
        $readmemh("program/program.bin", memory);  // leitura do programa
    end

    assign instr = memory[addr[9:2]];  // alinhado por palavra (4 bytes)
endmodule