`timescale 1ns / 1ps
`include "constants.v"

module tb_forwarding_unit;

    // --- Inputs to UUT ---
    reg [4:0] id_ex_rs1_addr;
    reg [4:0] id_ex_rs2_addr;
    reg [4:0] ex_mem_rd_addr;
    reg       ex_mem_reg_write;
    reg [4:0] mem_wb_rd_addr;
    reg       mem_wb_reg_write;

    // --- Outputs from UUT ---
    wire [1:0] forward_a;
    wire [1:0] forward_b;

    // --- Verification variables ---
    integer pass_count;
    integer fail_count;

    // Forwarding codes
    localparam NO_FWD = 2'b00;
    localparam FWD_EX = 2'b01;
    localparam FWD_MEM = 2'b10;

    // Instantiate UUT with corrected port names
    forwarding_unit uut (
        .id_ex_rs1_addr(id_ex_rs1_addr),
        .id_ex_rs2_addr(id_ex_rs2_addr),
        .ex_mem_rd_addr(ex_mem_rd_addr),
        .ex_mem_reg_write(ex_mem_reg_write),
        .mem_wb_rd_addr(mem_wb_rd_addr),
        .mem_wb_reg_write(mem_wb_reg_write),
        .forward_a(forward_a),
        .forward_b(forward_b)
    );

    // Verification task
    task check_result;
        input [1:0] expected_forward_a;
        input [1:0] expected_forward_b;
        input [8*40-1:0] test_case;
    begin
        #10; // Wait for stabilization
        if (forward_a === expected_forward_a && forward_b === expected_forward_b) begin
            $display("\033[32m[PASS]\033[0m %s -> FwdA=%b, FwdB=%b", test_case, forward_a, forward_b);
            pass_count++;
        end else begin
            $display("\033[31m[FAIL]\033[0m %s -> Received: %b,%b | Expected: %b,%b", 
                    test_case, forward_a, forward_b, expected_forward_a, expected_forward_b);
            fail_count++;
        end
    end
    endtask

    // Main simulation block
    initial begin
        $display("Starting Forwarding Unit Test...");
        $display("-----------------------------------");
        pass_count = 0;
        fail_count = 0;

        // --- Case 1: No hazards ---
        id_ex_rs1_addr = 5'd1; id_ex_rs2_addr = 5'd2;
        ex_mem_rd_addr = 5'd3; ex_mem_reg_write = 1'b1;
        mem_wb_rd_addr = 5'd4; mem_wb_reg_write = 1'b1;
        check_result(NO_FWD, NO_FWD, "No hazards");

        // --- Case 2: EX hazard on operand 1 ---
        id_ex_rs1_addr = 5'd3; id_ex_rs2_addr = 5'd1;
        ex_mem_rd_addr = 5'd3; ex_mem_reg_write = 1'b1;
        mem_wb_rd_addr = 5'd5; mem_wb_reg_write = 1'b1;
        check_result(FWD_EX, NO_FWD, "EX hazard on op1");

        // --- Case 3: EX hazard on operand 2 ---
        id_ex_rs1_addr = 5'd1; id_ex_rs2_addr = 5'd3;
        ex_mem_rd_addr = 5'd3; ex_mem_reg_write = 1'b1;
        mem_wb_rd_addr = 5'd5; mem_wb_reg_write = 1'b1;
        check_result(NO_FWD, FWD_EX, "EX hazard on op2");

        // --- Case 4: MEM hazard on operand 1 ---
        id_ex_rs1_addr = 5'd4; id_ex_rs2_addr = 5'd1;
        ex_mem_rd_addr = 5'd2; ex_mem_reg_write = 1'b0;
        mem_wb_rd_addr = 5'd4; mem_wb_reg_write = 1'b1;
        check_result(FWD_MEM, NO_FWD, "MEM hazard on op1");

        // --- Case 5: MEM hazard on operand 2 ---
        id_ex_rs1_addr = 5'd1; id_ex_rs2_addr = 5'd4;
        ex_mem_rd_addr = 5'd2; ex_mem_reg_write = 1'b0;
        mem_wb_rd_addr = 5'd4; mem_wb_reg_write = 1'b1;
        check_result(NO_FWD, FWD_MEM, "MEM hazard on op2");

        // --- Case 6: EX priority over MEM ---
        id_ex_rs1_addr = 5'd3; id_ex_rs2_addr = 5'd1;
        ex_mem_rd_addr = 5'd3; ex_mem_reg_write = 1'b1;
        mem_wb_rd_addr = 5'd3; mem_wb_reg_write = 1'b1;
        check_result(FWD_EX, NO_FWD, "EX priority over MEM");

        // --- Case 7: Zero register (x0) ---
        id_ex_rs1_addr = 5'd0; id_ex_rs2_addr = 5'd0;
        ex_mem_rd_addr = 5'd0; ex_mem_reg_write = 1'b1;
        mem_wb_rd_addr = 5'd0; mem_wb_reg_write = 1'b1;
        check_result(NO_FWD, NO_FWD, "Zero register (x0)");

        // --- Case 8: Write enable disabled ---
        id_ex_rs1_addr = 5'd2; id_ex_rs2_addr = 5'd3;
        ex_mem_rd_addr = 5'd2; ex_mem_reg_write = 1'b0;
        mem_wb_rd_addr = 5'd3; mem_wb_reg_write = 1'b0;
        check_result(NO_FWD, NO_FWD, "Write enable disabled");

        // --- Case 9: Hazard on both operands ---
        id_ex_rs1_addr = 5'd3; id_ex_rs2_addr = 5'd4;
        ex_mem_rd_addr = 5'd3; ex_mem_reg_write = 1'b1;
        mem_wb_rd_addr = 5'd4; mem_wb_reg_write = 1'b1;
        check_result(FWD_EX, FWD_MEM, "Hazard on both operands");

        // --- Case 10: Both stages have matching destination for same operand ---
        id_ex_rs1_addr = 5'd5; id_ex_rs2_addr = 5'd1;
        ex_mem_rd_addr = 5'd5; ex_mem_reg_write = 1'b1;
        mem_wb_rd_addr = 5'd5; mem_wb_reg_write = 1'b1;
        check_result(FWD_EX, NO_FWD, "Both stages match for op1");

        // Final results
        $display("\n-----------------------------------");
        $display("Test Results:");
        $display("Tests Passed: \033[32m%d\033[0m", pass_count);
        $display("Tests Failed: \033[31m%d\033[0m", fail_count);
        $display("-----------------------------------");
        
        if (fail_count == 0) begin
            $display("\033[32mAll tests passed successfully!\033[0m");
        end else begin
            $display("\033[31mSome tests failed. Please check the results.\033[0m");
        end
        
        $finish;
    end
endmodule