`timescale 1ns / 1ps

module tb_control_unit();

    reg [6:0] opcode;
    wire [1:0] ALUOp;
    wire ALUSrc;
    
    control_unit uut (
        .opcode(opcode),
        .ALUOp(ALUOp),
        .ALUSrc(ALUSrc)
    );
    
    initial begin
        $display("=== Teste da Control Unit ===");
        $display("Opcode\tALUOp\tALUSrc");
        
        // Teste R-type
        opcode = 7'b0110011;
        #10;
        $display("%b\t%b\t%b (R-type)", opcode, ALUOp, ALUSrc);
        
        // Teste I-type (load)
        opcode = 7'b0000011;
        #10;
        $display("%b\t%b\t%b (I-type load)", opcode, ALUOp, ALUSrc);
        
        // Teste S-type
        opcode = 7'b0100011;
        #10;
        $display("%b\t%b\t%b (S-type)", opcode, ALUOp, ALUSrc);
        
        // Teste I-type (arith)
        opcode = 7'b0010011;
        #10;
        $display("%b\t%b\t%b (I-type arith)", opcode, ALUOp, ALUSrc);
        
        // Teste B-type
        opcode = 7'b1100011;
        #10;
        $display("%b\t%b\t%b (B-type)", opcode, ALUOp, ALUSrc);
        
        $finish;
    end

endmodule