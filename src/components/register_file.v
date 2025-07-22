// Banco de Registradores - 16 registradores 32 bits
module register_file (
    input wire clk,
    input wire rst,

    input wire [3:0] rs1_addr,
    input wire [3:0] rs2_addr,
    output wire [31:0] rs1_data,
    output wire [31:0] rs2_data,

    input wire [3:0] rd_addr,
    input wire [31:0] rd_data,
    input wire rd_we
);

    reg [31:0] regs [0:15];
    integer i;

    // Reset: zera todos os registradores
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < 16; i = i + 1)
                regs[i] <= 32'd0;
        end else if (rd_we && rd_addr != 4'd0) begin
            // Evita escrever no registrador 0 (zero hardwired)
            regs[rd_addr] <= rd_data;
        end
    end

    // Leitura combinacional
    assign rs1_data = (rs1_addr == 4'd0) ? 32'd0 : regs[rs1_addr];
    assign rs2_data = (rs2_addr == 4'd0) ? 32'd0 : regs[rs2_addr];

endmodule
