`timescale 1ns / 1ps
`include "alu_defines.vh"

module tb_alu_control();

    // Sinais de entrada
    reg [1:0] ALUOp;
    reg [9:0] Funct;

    parameter GREEN = "\033[0;32m";
    parameter RED   = "\033[0;31m";
    parameter NC    = "\033[0m";

    // Sinais de saída
    wire [3:0] Op;
    
    // Instância do módulo testado
    alu_control uut (
        .ALUOp(ALUOp),
        .Funct(Funct),
        .Op(Op)
    );
    
    // Tarefa para obter nome da operação
    function string get_op_name;
        input [3:0] opcode;
        begin
            case (opcode)
                `ALU_ADD:  return "ADD";
                `ALU_SUB:  return "SUB";
                `ALU_SLL:  return "SLL";
                `ALU_SLT:  return "SLT";
                `ALU_SLTU: return "SLTU";
                `ALU_XOR:  return "XOR";
                `ALU_SRL:  return "SRL";
                `ALU_SRA:  return "SRA";
                `ALU_OR:   return "OR";
                `ALU_AND:  return "AND";
                `ALU_LUI:  return "LUI";
                default: return "UNKNOWN";
            endcase
        end
    endfunction

    // Tarefa para verificar resultados
    task check_operation;
        input [3:0] expected_op;
        input string test_name;
        begin
            if (Op === expected_op) begin
                $display("%s[PASS]%s %-20s ALUOp=%b Funct7=%b Funct3=%b => %s", 
                         GREEN, NC, test_name, ALUOp, Funct[9:7], Funct[2:0], get_op_name(Op));
            end else begin
                $display("%s[FAIL]%s %-20s ALUOp=%b Funct7=%b Funct3=%b", 
                         RED, NC, test_name, ALUOp, Funct[9:7], Funct[2:0]);
                $display("  Expected: %s", get_op_name(expected_op));
                $display("  Got:      %s", get_op_name(Op));
            end
        end
    endtask

    // Testes
    initial begin
        $display("\n=== Teste do ALU Control ===");
        
        // Teste 1: Loads/Stores (ALUOp = 00)
        ALUOp = 2'b00;
        Funct = 10'bxxxxxxxxxx;
        #10;
        check_operation(`ALU_ADD, "Load/Store");
        
        // Teste 2: Branches
        ALUOp = 2'b01;
        
        // BEQ
        Funct = 10'bxxxxxxx000;
        #10;
        check_operation(`ALU_SUB, "BEQ");
        
        // BNE
        Funct = 10'bxxxxxxx001;
        #10;
        check_operation(`ALU_SUB, "BNE");
        
        // BLT
        Funct = 10'bxxxxxxx100;
        #10;
        check_operation(`ALU_SLT, "BLT");
        
        // BGE
        Funct = 10'bxxxxxxx101;
        #10;
        check_operation(`ALU_SLT, "BGE");
        
        // BLTU
        Funct = 10'bxxxxxxx110;
        #10;
        check_operation(`ALU_SLTU, "BLTU");
        
        // BGEU
        Funct = 10'bxxxxxxx111;
        #10;
        check_operation(`ALU_SLTU, "BGEU");
        
        // Teste 3: Operações Aritméticas
        ALUOp = 2'b10;
        
        // ADD (funct7=0000000)
        Funct = 10'b0000000000;
        #10;
        check_operation(`ALU_ADD, "ADD");
        
        // SUB (funct7=0100000)
        Funct = 10'b0100000000;
        #10;
        check_operation(`ALU_SUB, "SUB");
        
        // SLL
        Funct = 10'b0000000001;
        #10;
        check_operation(`ALU_SLL, "SLL");
        
        // SLT
        Funct = 10'b0000000010;
        #10;
        check_operation(`ALU_SLT, "SLT");
        
        // XOR
        Funct = 10'b0000000100;
        #10;
        check_operation(`ALU_XOR, "XOR");
        
        // SRL
        Funct = 10'b0000000101;
        #10;
        check_operation(`ALU_SRL, "SRL");
        
        // SRA
        Funct = 10'b0100000101;
        #10;
        check_operation(`ALU_SRA, "SRA");
        
        // OR
        Funct = 10'b0000000110;
        #10;
        check_operation(`ALU_OR, "OR");
        
        // AND
        Funct = 10'b0000000111;
        #10;
        check_operation(`ALU_AND, "AND");
        
        // Teste 4: Operações Imediatas (ALUOp = 11)
        ALUOp = 2'b11;
        
        // ADDI
        Funct = 10'bxxxxxxx000;
        #10;
        check_operation(`ALU_ADD, "ADDI");
        
        // SLLI
        Funct = 10'bxxxxxxx001;
        #10;
        check_operation(`ALU_SLL, "SLLI");
        
        // SLTI
        Funct = 10'bxxxxxxx010;
        #10;
        check_operation(`ALU_SLT, "SLTI");
        
        // XORI
        Funct = 10'bxxxxxxx100;
        #10;
        check_operation(`ALU_XOR, "XORI");
        
        // SRLI
        Funct = 10'b0000000101;
        #10;
        check_operation(`ALU_SRL, "SRLI");
        
        // SRAI
        Funct = 10'b0100000101;
        #10;
        check_operation(`ALU_SRA, "SRAI");
        
        // ORI
        Funct = 10'bxxxxxxx110;
        #10;
        check_operation(`ALU_OR, "ORI");
        
        // ANDI
        Funct = 10'bxxxxxxx111;
        #10;
        check_operation(`ALU_AND, "ANDI");
        
        $display("\n=== Fim dos Testes ===");
        $finish;
    end

endmodule