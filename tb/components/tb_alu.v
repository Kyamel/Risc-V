`timescale 1ns / 1ps

module tb_alu();

    // Parâmetros para cores (ANSI escape codes)
    parameter GREEN = "\033[0;32m";
    parameter RED = "\033[0;31m";
    parameter NC = "\033[0m"; // No Color
    
    // Parâmetros de operações ALU
    parameter ADD  = 4'b0000;
    parameter SUB  = 4'b0001;
    parameter AND  = 4'b0010;
    parameter OR   = 4'b0011;
    parameter XOR  = 4'b0100;
    parameter SLL  = 4'b0101;
    parameter SRL  = 4'b0110;
    parameter SRA  = 4'b0111;
    parameter SLT  = 4'b1000;
    parameter SLTU = 4'b1001;
    parameter LUI  = 4'b1010;

    // Sinais de entrada
    reg [31:0] a;
    reg [31:0] b;
    reg [3:0] ALUOp;
    
    // Sinais de saída
    wire [31:0] Result;
    wire Zero;
    
    // Instância da ALU
    alu uut (
        .a(a),
        .b(b),
        .ALUOp(ALUOp),
        .Result(Result),
        .Zero(Zero)
    );
    
    // Tarefa para exibir a operação atual
    function string get_op_name;
        input [3:0] opcode;
        begin
            case (opcode)
                ADD:  return "ADD";
                SUB:  return "SUB";
                AND:  return "AND";
                OR:   return "OR";
                XOR:  return "XOR";
                SLL:  return "SLL";
                SRL:  return "SRL";
                SRA:  return "SRA";
                SLT:  return "SLT";
                SLTU: return "SLTU";
                LUI:  return "LUI";
                default: return "UNKNOWN";
            endcase
        end
    endfunction

    // Tarefa para verificar resultados
    task check_result;
        input [31:0] expected;
        input expected_zero;
        input string test_name;
        begin
            if (Result === expected && Zero === expected_zero) begin
                $display("%s[PASS]%s %-6s a=0x%08h b=0x%08h => res=0x%08h zero=%b", 
                         GREEN, NC, get_op_name(ALUOp), a, b, Result, Zero);
            end else begin
                $display("%s[FAIL]%s %-6s a=0x%08h b=0x%08h", RED, NC, get_op_name(ALUOp), a, b);
                $display("  Expected: res=0x%08h zero=%b", expected, expected_zero);
                $display("  Got:      res=0x%08h zero=%b", Result, Zero);
            end
        end
    endtask

    // Testes
    initial begin
        $display("\n=== Teste da ALU ===");
        
        // Teste 1: ADD
        a = 32'd5; b = 32'd7; ALUOp = ADD;
        #10;
        check_result(32'd12, 1'b0, "ADD básico");
        
        // Teste 2: SUB
        a = 32'd10; b = 32'd4; ALUOp = SUB;
        #10;
        check_result(32'd6, 1'b0, "SUB básico");
        
        // Teste 3: AND
        a = 32'hFFFF0000; b = 32'h0000FFFF; ALUOp = AND;
        #10;
        check_result(32'h00000000, 1'b1, "AND bit a bit");
        
        // Teste 4: OR
        a = 32'hAAAA0000; b = 32'h00005555; ALUOp = OR;
        #10;
        check_result(32'hAAAA5555, 1'b0, "OR bit a bit");
        
        // Teste 5: XOR
        a = 32'hAAAAAAAA; b = 32'h55555555; ALUOp = XOR;
        #10;
        check_result(32'hFFFFFFFF, 1'b0, "XOR bit a bit");
        
        // Teste 6: SLL
        a = 32'h00000001; b = 32'd3; ALUOp = SLL;
        #10;
        check_result(32'h00000008, 1'b0, "Shift Left Logical");
        
        // Teste 7: SRL
        a = 32'h80000000; b = 32'd4; ALUOp = SRL;
        #10;
        check_result(32'h08000000, 1'b0, "Shift Right Logical");
        
        // Teste 8: SRA
        a = 32'h80000000; b = 32'd4; ALUOp = SRA;
        #10;
        check_result(32'hF8000000, 1'b0, "Shift Right Arith");
        
        // Teste 9: SLT
        a = 32'd5; b = 32'd10; ALUOp = SLT;
        #10;
        check_result(32'd1, 1'b0, "Set Less Than");
        
        // Teste 10: SLTU
        a = 32'hFFFFFFFF; b = 32'd1; ALUOp = SLTU;
        #10;
        check_result(32'd0, 1'b1, "Set Less Than Unsigned");
        
        // Teste 11: LUI
        a = 32'hxxxxxxxx; b = 32'h0000ABCD; ALUOp = LUI;
        #10;
        check_result(32'h0000ABCD, 1'b0, "Load Upper Immediate");
        
        // Teste 12: Zero flag
        a = 32'd10; b = 32'd10; ALUOp = SUB;
        #10;
        check_result(32'd0, 1'b1, "Zero Flag Test");
        
        $display("\n=== Fim dos Testes ===");
        $finish;
    end

endmodule