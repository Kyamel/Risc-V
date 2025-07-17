// And_tb.v
`timescale 1ns / 1ps

module And_tb;

    reg  [31:0] rs1;
    reg  [31:0] rs2;
    wire [31:0] result;

    // Instância do módulo AND
    And uut (
        .rs1(rs1),
        .rs2(rs2),
        .result(result)
    );

    initial begin
        // Monitorar as variáveis na simulação
        $monitor("Time=%0t | rs1=%h rs2=%h result=%h", $time, rs1, rs2, result);

        // Teste 1
        rs1 = 32'hFFFF_FFFF;
        rs2 = 32'h0F0F_0F0F;
        #10;

        // Teste 2
        rs1 = 32'h1234_5678;
        rs2 = 32'hFFFF_0000;
        #10;

        // Teste 3
        rs1 = 32'h0000_0000;
        rs2 = 32'hFFFF_FFFF;
        #10;

        // Teste 4
        rs1 = 32'hAAAA_AAAA;
        rs2 = 32'h5555_5555;
        #10;

        $finish;
    end

endmodule
