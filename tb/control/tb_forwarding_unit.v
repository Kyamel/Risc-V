`timescale 1ns / 1ps

module tb_forwarding_unit;

    // Inputs
    reg [4:0] ex_rs1;
    reg [4:0] ex_rs2;
    reg [4:0] mem_rd;
    reg       mem_reg_write;
    reg [4:0] wb_rd;
    reg       wb_reg_write;

    // Outputs
    wire [1:0] forward_a;
    wire [1:0] forward_b;

    integer pass_count;
    integer fail_count;

    // Forwarding codes (same as Patterson & Hennessy)
    localparam NO_FWD     = 2'b00;  // Value from the register file
    localparam FWD_MEM_WB = 2'b01;  // Value from the MEM/WB register (WB stage)
    localparam FWD_EX_MEM = 2'b10;  // Value from the EX/MEM register (MEM stage)

    forwarding_unit uut (
        .EX_rs1(ex_rs1),
        .EX_rs2(ex_rs2),
        .MEM_rd(mem_rd),
        .MEM_RegWrite(mem_reg_write),
        .WB_rd(wb_rd),
        .WB_RegWrite(wb_reg_write),
        .ForwardA(forward_a),
        .ForwardB(forward_b)
    );

    task check_result;
        input [1:0] expected_forward_a;
        input [1:0] expected_forward_b;
        input [8*40-1:0] test_case;
    begin
        #10; // Wait for the combinational logic
        if (forward_a === expected_forward_a && forward_b === expected_forward_b) begin
            $display("\033[32m[PASS]\033[0m %0s -> FwdA=%b, FwdB=%b", test_case, forward_a, forward_b);
            pass_count++;
        end else begin
            $display("\033[31m[FAIL]\033[0m %0s -> Received: %b,%b | Expected: %b,%b",
                    test_case, forward_a, forward_b, expected_forward_a, expected_forward_b);
            fail_count++;
        end
    end
    endtask

    initial begin
        $display("Starting Forwarding Unit Test...");
        pass_count = 0;
        fail_count = 0;

        ex_rs1 = 5'd1; ex_rs2 = 5'd2;
        mem_rd = 5'd3; mem_reg_write = 1'b1;
        wb_rd  = 5'd4; wb_reg_write  = 1'b1;
        check_result(NO_FWD, NO_FWD, "No hazards");

        ex_rs1 = 5'd3; ex_rs2 = 5'd1;
        mem_rd = 5'd3; mem_reg_write = 1'b1;
        wb_rd  = 5'd5; wb_reg_write  = 1'b1;
        check_result(FWD_EX_MEM, NO_FWD, "EX/MEM hazard on rs1");

        ex_rs1 = 5'd1; ex_rs2 = 5'd3;
        mem_rd = 5'd3; mem_reg_write = 1'b1;
        wb_rd  = 5'd5; wb_reg_write  = 1'b1;
        check_result(NO_FWD, FWD_EX_MEM, "EX/MEM hazard on rs2");

        ex_rs1 = 5'd4; ex_rs2 = 5'd1;
        mem_rd = 5'd2; mem_reg_write = 1'b0;
        wb_rd  = 5'd4; wb_reg_write  = 1'b1;
        check_result(FWD_MEM_WB, NO_FWD, "MEM/WB hazard on rs1");

        ex_rs1 = 5'd1; ex_rs2 = 5'd4;
        mem_rd = 5'd2; mem_reg_write = 1'b0;
        wb_rd  = 5'd4; wb_reg_write  = 1'b1;
        check_result(NO_FWD, FWD_MEM_WB, "MEM/WB hazard on rs2");

        // The most recent value (EX/MEM) wins
        ex_rs1 = 5'd3; ex_rs2 = 5'd1;
        mem_rd = 5'd3; mem_reg_write = 1'b1;
        wb_rd  = 5'd3; wb_reg_write  = 1'b1;
        check_result(FWD_EX_MEM, NO_FWD, "EX/MEM has priority");

        ex_rs1 = 5'd0; ex_rs2 = 5'd0;
        mem_rd = 5'd0; mem_reg_write = 1'b1;
        wb_rd  = 5'd0; wb_reg_write  = 1'b1;
        check_result(NO_FWD, NO_FWD, "x0 is never forwarded");

        ex_rs1 = 5'd2; ex_rs2 = 5'd3;
        mem_rd = 5'd2; mem_reg_write = 1'b0;
        wb_rd  = 5'd3; wb_reg_write  = 1'b0;
        check_result(NO_FWD, NO_FWD, "Write enable disabled");

        ex_rs1 = 5'd3; ex_rs2 = 5'd4;
        mem_rd = 5'd3; mem_reg_write = 1'b1;
        wb_rd  = 5'd4; wb_reg_write  = 1'b1;
        check_result(FWD_EX_MEM, FWD_MEM_WB, "Hazard on both operands");

        $display("\nPassed: %0d, failed: %0d", pass_count, fail_count);
        $finish;
    end
endmodule
