// Banco de Registradores - 16 registradores 32 bits
module register_file #(
    parameter WIDTH = 32,  // Largura do registrador
    parameter DEPTH = 16   // Número de registradores (x0-x15)
)(
    input wire clk,
    input wire reset,      // Renomeado para match com a instanciação
    
    // Endereços de 5 bits (compatível com campos de instrução)
    input wire [4:0] rs1_addr,
    input wire [4:0] rs2_addr,
    output reg [31:0] rs1_data,
    output reg [31:0] rs2_data,

    input wire [4:0] rd_addr,
    input wire [31:0] rd_data,
    input wire reg_write,  // Nome mais descritivo que rd_we
    
    // Interface opcional de debug
    output wire [31:0] debug_registers [0:15]
);

    reg [31:0] regs [0:DEPTH-1];

    // Conexão de debug
    assign debug_registers = regs;

    // Escrita síncrona (e reset)
    always @(posedge clk) begin
        if (rst) begin
            for (int i = 0; i < 16; i++)
                regs[i] <= 32'd0;
        end else if (rd_we && rd_addr != 5'd0) begin
            regs[rd_addr[3:0]] <= rd_data;  // Ignora o 5º bit
        end
    end

    // Leitura combinacional com forwarding
    always @(*) begin
        // rs1_data
        if (rs1_addr == 5'd0) begin
            rs1_data = 32'd0;
        end else if (rs1_addr == rd_addr && rd_we) begin
            rs1_data = rd_data;  // Forwarding
        end else begin
            rs1_data = regs[rs1_addr[3:0]];  // Lê do array
        end

        // rs2_data (mesma lógica)
        if (rs2_addr == 5'd0) begin
            rs2_data = 32'd0;
        end else if (rs2_addr == rd_addr && rd_we) begin
            rs2_data = rd_data;
        end else begin
            rs2_data = regs[rs2_addr[3:0]];
        end
    end

endmodule