`include "constants.v"

module pipeline_registers (
    input wire clk,
    input wire reset,
    input wire stall,
    input wire flush,
    
    // IF/ID Register
    input wire [31:0] if_pc,
    input wire [31:0] if_instruction,
    input wire if_valid,
    output reg [31:0] id_pc,
    output reg [31:0] id_instruction,
    output reg id_valid,
    
    // ID/EX Register
    input wire [31:0] id_pc_in,
    input wire [31:0] id_instruction_in,
    input wire [31:0] id_rs1_data_in,
    input wire [31:0] id_rs2_data_in,
    input wire [31:0] id_immediate_in,
    input wire [4:0] id_rd_addr_in,
    input wire [4:0] id_rs1_addr_in,
    input wire [4:0] id_rs2_addr_in,
    input wire [`CONTROL_SIGNALS_WIDTH-1:0] id_control_signals_in,
    input wire id_valid_in,
    output reg [31:0] ex_pc,
    output reg [31:0] ex_instruction,
    output reg [31:0] ex_rs1_data,
    output reg [31:0] ex_rs2_data,
    output reg [31:0] ex_immediate,
    output reg [4:0] ex_rd_addr,
    output reg [4:0] ex_rs1_addr,
    output reg [4:0] ex_rs2_addr,
    output reg [`CONTROL_SIGNALS_WIDTH-1:0] ex_control_signals,
    output reg ex_valid,
    
    // EX/MEM Register
    input wire [31:0] ex_pc_in,
    input wire [31:0] ex_alu_result_in,
    input wire [31:0] ex_rs2_data_in,
    input wire [4:0] ex_rd_addr_in,
    input wire [`CONTROL_SIGNALS_WIDTH-1:0] ex_control_signals_in,
    input wire ex_valid_in,
    output reg [31:0] mem_pc,
    output reg [31:0] mem_alu_result,
    output reg [31:0] mem_rs2_data,
    output reg [4:0] mem_rd_addr,
    output reg [`CONTROL_SIGNALS_WIDTH-1:0] mem_control_signals,
    output reg mem_valid,
    
    // MEM/WB Register
    input wire [31:0] mem_pc_in,
    input wire [31:0] mem_alu_result_in,
    input wire [31:0] mem_mem_data_in,
    input wire [4:0] mem_rd_addr_in,
    input wire [`CONTROL_SIGNALS_WIDTH-1:0] mem_control_signals_in,
    input wire mem_valid_in,
    output reg [31:0] wb_pc,
    output reg [31:0] wb_alu_result,
    output reg [31:0] wb_mem_data,
    output reg [4:0] wb_rd_addr,
    output reg [`CONTROL_SIGNALS_WIDTH-1:0] wb_control_signals,
    output reg wb_valid
);

    // IF/ID Pipeline Register
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            id_pc <= 32'h0;
            id_instruction <= 32'h0;
            id_valid <= 1'b0;
        end
        else if (flush) begin
            id_pc <= 32'h0;
            id_instruction <= 32'h0;
            id_valid <= 1'b0;
        end
        else if (!stall) begin
            id_pc <= if_pc;
            id_instruction <= if_instruction;
            id_valid <= if_valid;
        end
    end

    // ID/EX Pipeline Register
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            ex_pc <= 32'h0;
            ex_instruction <= 32'h0;
            ex_rs1_data <= 32'h0;
            ex_rs2_data <= 32'h0;
            ex_immediate <= 32'h0;
            ex_rd_addr <= 5'h0;
            ex_rs1_addr <= 5'h0;
            ex_rs2_addr <= 5'h0;
            ex_control_signals <= {`CONTROL_SIGNALS_WIDTH{1'b0}};
            ex_valid <= 1'b0;
        end
        else if (flush) begin
            ex_pc <= 32'h0;
            ex_instruction <= 32'h0;
            ex_rs1_data <= 32'h0;
            ex_rs2_data <= 32'h0;
            ex_immediate <= 32'h0;
            ex_rd_addr <= 5'h0;
            ex_rs1_addr <= 5'h0;
            ex_rs2_addr <= 5'h0;
            ex_control_signals <= {`CONTROL_SIGNALS_WIDTH{1'b0}};
            ex_valid <= 1'b0;
        end
        else if (!stall) begin
            ex_pc <= id_pc_in;
            ex_instruction <= id_instruction_in;
            ex_rs1_data <= id_rs1_data_in;
            ex_rs2_data <= id_rs2_data_in;
            ex_immediate <= id_immediate_in;
            ex_rd_addr <= id_rd_addr_in;
            ex_rs1_addr <= id_rs1_addr_in;
            ex_rs2_addr <= id_rs2_addr_in;
            ex_control_signals <= id_control_signals_in;
            ex_valid <= id_valid_in;
        end
    end

    // EX/MEM Pipeline Register
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            mem_pc <= 32'h0;
            mem_alu_result <= 32'h0;
            mem_rs2_data <= 32'h0;
            mem_rd_addr <= 5'h0;
            mem_control_signals <= {`CONTROL_SIGNALS_WIDTH{1'b0}};
            mem_valid <= 1'b0;
        end
        else begin
            mem_pc <= ex_pc_in;
            mem_alu_result <= ex_alu_result_in;
            mem_rs2_data <= ex_rs2_data_in;
            mem_rd_addr <= ex_rd_addr_in;
            mem_control_signals <= ex_control_signals_in;
            mem_valid <= ex_valid_in;
        end
    end

    // MEM/WB Pipeline Register
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            wb_pc <= 32'h0;
            wb_alu_result <= 32'h0;
            wb_mem_data <= 32'h0;
            wb_rd_addr <= 5'h0;
            wb_control_signals <= {`CONTROL_SIGNALS_WIDTH{1'b0}};
            wb_valid <= 1'b0;
        end
        else begin
            wb_pc <= mem_pc_in;
            wb_alu_result <= mem_alu_result_in;
            wb_mem_data <= mem_mem_data_in;
            wb_rd_addr <= mem_rd_addr_in;
            wb_control_signals <= mem_control_signals_in;
            wb_valid <= mem_valid_in;
        end
    end

endmodule
