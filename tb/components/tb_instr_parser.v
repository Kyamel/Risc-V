`timescale 1ns / 1ps

module tb_instr_parser();

    // Parâmetros para cores (ANSI escape codes)
    parameter GREEN = "\033[0;32m";
    parameter RED = "\033[0;31m";
    parameter NC = "\033[0m"; // No Color
    
    // Sinais
    reg [31:0] instr;
    wire [6:0] opcode;
    wire [4:0] rs1, rs2, rd;
    
    // Instância do módulo testado
    instr_parser uut (
        .instr(instr),
        .opcode(opcode),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd)
    );
    
    // Tarefa para verificar resultados
    task check_parser;
        input [6:0] exp_opcode;
        input [4:0] exp_rs1, exp_rs2, exp_rd;
        input string test_name;
        begin
            if (opcode === exp_opcode && rs1 === exp_rs1 && 
                rs2 === exp_rs2 && rd === exp_rd) begin
                $display("%s[PASS]%s %-20s Instr: 0x%08h", GREEN, NC, test_name, instr);
                $display("  Opcode: 0x%02h, rs1: x%0d, rs2: x%0d, rd: x%0d", 
                         opcode, rs1, rs2, rd);
            end else begin
                $display("%s[FAIL]%s %-20s Instr: 0x%08h", RED, NC, test_name, instr);
                $display("  Expected: opcode=0x%02h, rs1=x%0d, rs2=x%0d, rd=x%0d", 
                         exp_opcode, exp_rs1, exp_rs2, exp_rd);
                $display("  Got:      opcode=0x%02h, rs1=x%0d, rs2=x%0d, rd=x%0d", 
                         opcode, rs1, rs2, rd);
            end
        end
    endtask

    // Testes
    initial begin
        $display("\n=== Teste do Instruction Parser ===\n");
        
        // Teste 1: ADDI x1, x2, 127
        instr = 32'h07f10093;
        #10;
        check_parser(7'b0010011, 5'd2, 5'd0, 5'd1, "ADDI x1,x2,127");
        
        // Teste 2: ADDI x1, x2, -1
        instr = 32'hfff10093;
        #10;
        check_parser(7'b0010011, 5'd2, 5'd0, 5'd1, "ADDI x1,x2,-1");
        
        // Teste 3: ADDI x1, x2, 0
        instr = 32'h00010093;
        #10;
        check_parser(7'b0010011, 5'd2, 5'd0, 5'd1, "ADDI x1,x2,0");
        
        // Teste 4: SW x3, 16(x4)
        instr = 32'h00322823;
        #10;
        check_parser(7'b0100011, 5'd4, 5'd3, 5'd5, "SW x3,16(x4)");
        
        // Teste 5: SW x5, -4(x6)
        instr = 32'hfe532e23;
        #10;
        check_parser(7'b0100011, 5'd6, 5'd5, 5'd7, "SW x5,-4(x6)");
        
        // Teste 6: LW x7, 8(x8)
        instr = 32'h00842383;
        #10;
        check_parser(7'b0000011, 5'd8, 5'd0, 5'd7, "LW x7,8(x8)");
        
        // Teste 7: BEQ x1, x2, +8
        instr = 32'h00208463;
        #10;
        check_parser(7'b1100011, 5'd1, 5'd2, 5'd0, "BEQ x1,x2,+8");
        
        // Teste 8: BEQ x1, x2, -4
        instr = 32'hfe208ee3;
        #10;
        check_parser(7'b1100011, 5'd1, 5'd2, 5'd0, "BEQ x1,x2,-4");
        
        // Teste 9: LUI x1, 0x12345
        instr = 32'h123450b7;
        #10;
        check_parser(7'b0110111, 5'd0, 5'd0, 5'd1, "LUI x1,0x12345");
        
        // Teste 10: JAL x1, +0xABC
        instr = 32'h2bd000ef;
        #10;
        check_parser(7'b1101111, 5'd0, 5'd0, 5'd1, "JAL x1,+0xABC");
        
        $display("\n=== Fim dos Testes ===");
        $finish;
    end

endmodule