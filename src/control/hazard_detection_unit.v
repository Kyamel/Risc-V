`timescale 1ns / 1ps

module hazard_detection_unit (
    input wire id_ex_mem_read,
    input wire [4:0] id_ex_rd,
    input wire [4:0] if_id_rs1,
    input wire [4:0] if_id_rs2,
    output reg pc_write,
    output reg if_id_write,
    output reg stall
);
    always @(*) begin
        if (id_ex_mem_read && 
            ((id_ex_rd == if_id_rs1 && if_id_rs1 != 5'b0) || 
             (id_ex_rd == if_id_rs2 && if_id_rs2 != 5'b0))) begin
            pc_write = 1'b0;
            if_id_write = 1'b0;
            stall = 1'b1;
        end else begin
            pc_write = 1'b1;
            if_id_write = 1'b1;
            stall = 1'b0;
        end
    end
endmodule