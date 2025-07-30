`include "constants.v"

module branch_unit (
    input wire [31:0] id_ex_pc,
    input wire [31:0] id_ex_instruction,
    input wire [31:0] id_ex_rs1_data,
    input wire [31:0] id_ex_rs2_data,
    input wire [31:0] id_ex_immediate,
    input wire [`CONTROL_SIGNALS_WIDTH-1:0] id_ex_control_signals,

    output reg pc_src,
    output reg [31:0] new_pc,
    output reg flush    
);

    wire is_branch;
    wire [2:0] funct3;

    assign is_branch = id_ex_control_signals[`IS_BRANCH];  // sinal definido na control_unit
    assign funct3 = id_ex_instruction[14:12]; // para distinguir o tipo de branch

    always @(*) begin
        pc_src = 1'b0;
        new_pc = 32'b0;
        flush = 1'b0;

        if (is_branch) begin
            case (funct3)
                3'b000: pc_src = (id_ex_rs1_data == id_ex_rs2_data); // beq
                3'b001: pc_src = (id_ex_rs1_data != id_ex_rs2_data); // bne
                3'b100: pc_src = ($signed(id_ex_rs1_data) < $signed(id_ex_rs2_data)); // blt
                3'b101: pc_src = ($signed(id_ex_rs1_data) >= $signed(id_ex_rs2_data)); // bge
                3'b110: pc_src = (id_ex_rs1_data < id_ex_rs2_data); // bltu
                3'b111: pc_src = (id_ex_rs1_data >= id_ex_rs2_data); // bgeu
                default: pc_src = 1'b0;
            endcase

            if (pc_src) begin
                new_pc = id_ex_pc + id_ex_immediate;
                flush = 1'b1;
            end else begin
                new_pc = 32'b0;
                flush = 1'b0;
            end
        end
    end

endmodule
