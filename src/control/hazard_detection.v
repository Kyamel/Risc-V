module hazard_detection_unit(
    input  wire        id_ex_memRead,
    input  wire [4:0]  id_ex_rd,
    input  wire [4:0]  if_id_rs1,
    input  wire [4:0]  if_id_rs2,
    output reg         pc_write,
    output reg         if_id_write,
    output reg         stall
);

always @(*) begin
    if (id_ex_memRead && ((id_ex_rd == if_id_rs1) || (id_ex_rd == if_id_rs2))) begin
        // Load-use hazard detectado → trava pipeline
        pc_write   = 0;
        if_id_write = 0;
        stall      = 1;
    end else begin
        pc_write   = 1;
        if_id_write = 1;
        stall      = 0;
    end
end

endmodule
