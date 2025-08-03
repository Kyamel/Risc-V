`timescale 1ns / 1ps

module tb_alu();

    reg [31:0] a, b;
    reg [3:0] ALUOp;
    wire [31:0] Result;
    wire Zero;
    
    alu uut (
        .a(a),
        .b(b),
        .ALUOp(ALUOp),
        .Result(Result),
        .Zero(Zero)
    );
    
    initial begin
        $display("=== Teste da ALU ===");
        $display("Op   A       B       Result  Zero");
        
        // Teste ADD
        a = 32'd5; b = 32'd7; ALUOp = 4'b0000;
        #10;
        $display("ADD  %d  %d  %d  %b", a, b, Result, Zero);
        
        // Teste SUB
        a = 32'd10; b = 32'd4; ALUOp = 4'b0001;
        #10;
        $display("SUB  %d  %d  %d  %b", a, b, Result, Zero);
        
        // Teste SLL (shift left logical)
        a = 32'b1; b = 32'd3; ALUOp = 4'b0010;
        #10;
        $display("SLL  %b  %d  %b  %b", a, b, Result, Zero);
        
        // Teste SLT (set less than)
        a = 32'd5; b = 32'd10; ALUOp = 4'b0011;
        #10;
        $display("SLT  %d  %d  %d  %b", a, b, Result, Zero);
        
        // Teste XOR
        a = 32'b1100; b = 32'b1010; ALUOp = 4'b0101;
        #10;
        $display("XOR  %b  %b  %b  %b", a, b, Result, Zero);
        
        // Teste SRA (shift right arithmetic)
        a = 32'shFFFF0000; b = 32'd4; ALUOp = 4'b0111;
        #10;
        $display("SRA  %h  %d  %h  %b", a, b, Result, Zero);
        
        // Teste Zero flag
        a = 32'd10; b = 32'd10; ALUOp = 4'b0001; // SUB 10-10
        #10;
        $display("SUB  %d  %d  %d  %b (Zero flag)", a, b, Result, Zero);
        
        $finish;
    end

endmodule