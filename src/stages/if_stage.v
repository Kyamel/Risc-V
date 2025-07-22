module if_stage (
    input wire clk, rst,
    input wire stall,
    input wire branch_taken,
    input wire [31:0] branch_target,

    output wire [31:0] pc,
    output wire [31:0] pc_plus4,
    output wire [31:0] imem_addr,
    input wire [31:0] instruction
);

    reg [31:0] pc_reg;

    // Atualização do PC
    always @(posedge clk or posedge rst) begin
        if (rst)
            pc_reg <= 32'h00000000;  // PC inicial
        else if (!stall) begin
            if (branch_taken)
                pc_reg <= branch_target;
            else
                pc_reg <= pc_reg + 4;
        end
    end

    assign pc = pc_reg;
    assign pc_plus4 = pc_reg + 4;
    assign imem_addr = pc_reg;

endmodule