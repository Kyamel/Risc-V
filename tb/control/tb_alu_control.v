`timescale 1ns / 1ps

module tb_alu_control();

    // Parâmetros para cores (ANSI escape codes)
    parameter GREEN = "\033[0;32m";
    parameter RED = "\033[0;31m";
    parameter NC = "\033[0m"; // No Color
    
    // Parâmetros de operações ALU
    parameter ADD  = 4'b0000;
    parameter SUB  = 4'b0001;
    parameter SLL  = 4'b0010;
    parameter SLT  = 4'b0011;
    parameter SLTU = 4'b0100;
    parameter XOR  = 4'b0101;
    parameter SRL  = 4'b0110;
    parameter SRA  = 4'b0111;
    parameter OR   = 4'b1000;
    parameter AND  = 4'b1001;

    // Sinais de entrada
    reg [1:0] ALUOp;
    reg [9:0] Funct;
    
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
                ADD:  return "ADD";
                SUB:  return "SUB";
                SLL:  return "SLL";
                SLT:  return "SLT";
                SLTU: return "SLTU";
                XOR:  return "XOR";
                SRL:  return "SRL";
                SRA:  return "SRA";
                OR:   return "OR";
                AND:  return "AND";
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
        check_operation(ADD, "Load/Store");
        
        // Teste 2: Branches
        ALUOp = 2'b01;
        
        // BEQ
        Funct = 10'bxxxxxxx000;
        #10;
        check_operation(SUB, "BEQ");
        
        // BNE
        Funct = 10'bxxxxxxx001;
        #10;
        check_operation(SUB, "BNE");
        
        // BLT
        Funct = 10'bxxxxxxx100;
        #10;
        check_operation(SLT, "BLT");
        
        // BGE
        Funct = 10'bxxxxxxx101;
        #10;
        check_operation(SLT, "BGE");
        
        // BLTU
        Funct = 10'bxxxxxxx110;
        #10;
        check_operation(SLTU, "BLTU");
        
        // BGEU
        Funct = 10'bxxxxxxx111;
        #10;
        check_operation(SLTU, "BGEU");
        
        // Teste 3: Operações Aritméticas
        ALUOp = 2'b10;
        
        // ADD (funct7=0000000)
        Funct = 10'b0000000000;
        #10;
        check_operation(ADD, "ADD");
        
        // SUB (funct7=0100000)
        Funct = 10'b0100000000;
        #10;
        check_operation(SUB, "SUB");
        
        // SLL
        Funct = 10'b0000000001;
        #10;
        check_operation(SLL, "SLL");
        
        // SLT
        Funct = 10'b0000000010;
        #10;
        check_operation(SLT, "SLT");
        
        // XOR
        Funct = 10'b0000000100;
        #10;
        check_operation(XOR, "XOR");
        
        // SRL
        Funct = 10'b0000000101;
        #10;
        check_operation(SRL, "SRL");
        
        // SRA
        Funct = 10'b0100000101;
        #10;
        check_operation(SRA, "SRA");
        
        // OR
        Funct = 10'b0000000110;
        #10;
        check_operation(OR, "OR");
        
        // AND
        Funct = 10'b0000000111;
        #10;
        check_operation(AND, "AND");
        
        // Teste 4: Operações Imediatas (ALUOp = 11)
        ALUOp = 2'b11;
        
        // ADDI
        Funct = 10'bxxxxxxx000;
        #10;
        check_operation(ADD, "ADDI");
        
        // SLLI
        Funct = 10'bxxxxxxx001;
        #10;
        check_operation(SLL, "SLLI");
        
        // SLTI
        Funct = 10'bxxxxxxx010;
        #10;
        check_operation(SLT, "SLTI");
        
        // XORI
        Funct = 10'bxxxxxxx100;
        #10;
        check_operation(XOR, "XORI");
        
        // SRLI
        Funct = 10'b0000000101;
        #10;
        check_operation(SRL, "SRLI");
        
        // SRAI
        Funct = 10'b0100000101;
        #10;
        check_operation(SRA, "SRAI");
        
        // ORI
        Funct = 10'bxxxxxxx110;
        #10;
        check_operation(OR, "ORI");
        
        // ANDI
        Funct = 10'bxxxxxxx111;
        #10;
        check_operation(AND, "ANDI");
        
        $display("\n=== Fim dos Testes ===");
        $finish;
    end

endmodule