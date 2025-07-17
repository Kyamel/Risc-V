module ALUControl (
    input  [1:0] ALUOp,
    input  [2:0] funct3,
    input  [6:0] funct7,
    output reg [3:0] ALUControlOut
);

    always @(*) begin
        case (ALUOp)
            2'b00: ALUControlOut = 4'b0010; // LW/SW: ADD
            2'b01: begin // Branch
                case (funct3)
                    3'b000: ALUControlOut = 4'b0110; // BEQ → SUB
                    3'b001: ALUControlOut = 4'b0111; // BNE → custom
                    default: ALUControlOut = 4'b1111;
                endcase
            end
            2'b10: begin // R/I type
                case (funct3)
                    3'b000: ALUControlOut = (funct7[5]) ? 4'b0110 : 4'b0010; // SUB : ADD
                    3'b111: ALUControlOut = 4'b0000; // AND
                    3'b110: ALUControlOut = 4'b0001; // OR
                    3'b100: ALUControlOut = 4'b0011; // XOR
                    3'b001: ALUControlOut = 4'b0100; // SLL
                    3'b101: ALUControlOut = 4'b0101; // SRL
                    default: ALUControlOut = 4'b1111;
                endcase
            end
            default: ALUControlOut = 4'b1111;
        endcase
    end

endmodule
