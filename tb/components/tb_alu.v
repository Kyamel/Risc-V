`timescale 1ns / 1ps

module tb_alu;

    reg  [31:0] a, b;
    reg  [3:0]  alu_control;
    wire [31:0] result;
    wire        zero;

    alu uut (
        .a(a),
        .b(b),
        .alu_control(alu_control),
        .result(result),
        .zero(zero)
    );

    task test_case;
        input [3:0] ctrl;
        input [31:0] a_in, b_in;
        input [31:0] expected;
        input expected_zero;
        begin
            alu_control = ctrl;
            a = a_in;
            b = b_in;
            #1;

            if (result !== expected || zero !== expected_zero) begin
                $display("\033[31mFAIL\033[0m: ctrl=%b a=%0d b=%0d => result=%0d (esperado %0d), zero=%b (esperado %b)",
                          ctrl, a, b, result, expected, zero, expected_zero);
            end else begin
                $display("\033[32mPASS\033[0m: ctrl=%b a=%0d b=%0d => result=%0d, zero=%b",
                          ctrl, a, b, result, zero);
            end
        end
    endtask

    initial begin
        $display("\n== Teste ALU ==");

        test_case(4'b0000, 10, 5, 15, 0);         // ADD
        test_case(4'b0001, 10, 10, 0, 1);         // SUB (zero)
        test_case(4'b0010, 8'hF0, 8'h0F, 8'h00, 1); // AND
        test_case(4'b0011, 8'hF0, 8'h0F, 8'hFF, 0); // OR
        test_case(4'b0100, 8'hF0, 8'h0F, 8'hFF, 0); // XOR
        test_case(4'b0101, 32'h00000001, 5, 32'h00000020, 0); // SLL
        test_case(4'b0110, 32'h80000000, 31, 32'h00000001, 0); // SRL
        test_case(4'b0111, 32'h80000000, 31, 32'hFFFFFFFF, 0); // SRA (aritmético)
        test_case(4'b1000, -5, 3, 1, 0);          // SLT signed
        test_case(4'b1000, 3, -5, 0, 0);
        test_case(4'b1001, 3, 5, 1, 0);           // SLTU unsigned
        test_case(4'b1001, 5, 3, 0, 0);
        test_case(4'b1010, 0, 32'hDEADBEEF, 32'hDEADBEEF, 0); // LUI (passa b)

        $display("\n== Fim dos testes da ALU ==");
        $finish;
    end
endmodule
