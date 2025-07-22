// IF/ID Pipeline Register
module if_id_reg (
    input wire clk, rst, enable, flush,
    input wire [31:0] pc_in, instruction_in,
    output reg [31:0] pc_out, instruction_out
);

// ID/EX Pipeline Register
module id_ex_reg (
    input wire clk, rst, enable, flush,
    // Sinais de controle
    input wire [15:0] control_signals_in,
    // Dados
    input wire [31:0] pc_in, rs1_data_in, rs2_data_in, immediate_in,
    input wire [3:0] rs1_addr_in, rs2_addr_in, rd_addr_in,
    // Outputs
    output reg [15:0] control_signals_out,
    output reg [31:0] pc_out, rs1_data_out, rs2_data_out, immediate_out,
    output reg [3:0] rs1_addr_out, rs2_addr_out, rd_addr_out
);

// EX/MEM Pipeline Register
module ex_mem_reg (
    input wire clk, rst, enable, flush,
    // Sinais de controle
    input wire [7:0] control_signals_in,
    // Dados
    input wire [31:0] alu_result_in, rs2_data_in, pc_plus4_in,
    input wire [3:0] rd_addr_in,
    input wire branch_taken_in,
    // Outputs
    output reg [7:0] control_signals_out,
    output reg [31:0] alu_result_out, rs2_data_out, pc_plus4_out,
    output reg [3:0] rd_addr_out,
    output reg branch_taken_out
);

// MEM/WB Pipeline Register
module mem_wb_reg (
    input wire clk, rst, enable, flush,
    // Sinais de controle
    input wire [3:0] control_signals_in,
    // Dados
    input wire [31:0] mem_data_in, alu_result_in, pc_plus4_in,
    input wire [3:0] rd_addr_in,
    // Outputs
    output reg [3:0] control_signals_out,
    output reg [31:0] mem_data_out, alu_result_out, pc_plus4_out,
    output reg [3:0] rd_addr_out
);