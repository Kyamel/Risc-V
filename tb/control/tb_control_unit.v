`timescale 1ns / 1ps
`include "constants.v"

module tb_control_unit();

    reg [31:0] instruction;
    wire [`CONTROL_SIGNALS_WIDTH-1:0] control_signals;

    control_unit uut (
        .instruction(instruction),
        .control_signals(control_signals)
    );

    task display_signal;
        input [`CONTROL_SIGNALS_WIDTH-1:0] sig;
        begin
            $write("reg_write=%b, mem_to_reg=%b, mem_read=%b, mem_write=%b, ", 
                sig[`CTRL_REG_WRITE], sig[`CTRL_MEM_TO_REG], 
                sig[`CTRL_MEM_READ], sig[`CTRL_MEM_WRITE]);
            $write("branch=%b, jump=%b, alu_src=%b, ", 
                sig[`CTRL_BRANCH], sig[`CTRL_JUMP], sig[`CTRL_ALU_SRC]);
            $write("alu_op=%b, imm_type=%b, pc_src=%b", 
                sig[`CTRL_ALU_OP], sig[`CTRL_IMM_TYPE], sig[`CTRL_PC_SRC]);
            $display("");
        end
    endtask

    task check_signals;
        input reg_write_exp;
        input mem_to_reg_exp;
        input mem_read_exp;
        input mem_write_exp;
        input branch_exp;
        input jump_exp;
        input alu_src_exp;
        input [3:0] alu_op_exp;
        input [2:0] imm_type_exp;
        input [1:0] pc_src_exp;
        begin
            #1;
            if (control_signals[`CTRL_REG_WRITE] !== reg_write_exp ||
                control_signals[`CTRL_MEM_TO_REG] !== mem_to_reg_exp ||
                control_signals[`CTRL_MEM_READ] !== mem_read_exp ||
                control_signals[`CTRL_MEM_WRITE] !== mem_write_exp ||
                control_signals[`CTRL_BRANCH] !== branch_exp ||
                control_signals[`CTRL_JUMP] !== jump_exp ||
                control_signals[`CTRL_ALU_SRC] !== alu_src_exp ||
                control_signals[`CTRL_ALU_OP] !== alu_op_exp ||
                control_signals[`CTRL_IMM_TYPE] !== imm_type_exp ||
                control_signals[`CTRL_PC_SRC] !== pc_src_exp) begin
                
                $display("\033[31mFAIL\033[0m Instruction=%h", instruction);
                $write("  Got:      ");
                display_signal(control_signals);
                $write("  Expected: ");
                $display("reg_write=%b, mem_to_reg=%b, mem_read=%b, mem_write=%b, branch=%b, jump=%b, alu_src=%b, alu_op=%b, imm_type=%b, pc_src=%b",
                        reg_write_exp, mem_to_reg_exp, mem_read_exp, mem_write_exp,
                        branch_exp, jump_exp, alu_src_exp, alu_op_exp, imm_type_exp, pc_src_exp);
            end else begin
                $display("\033[32mPASS\033[0m Instruction=%h", instruction);
                $write("  Result:   ");
                display_signal(control_signals);
            end
        end
    endtask

    initial begin
        $display("== Teste da Unidade de Controle ==");

        // R-Type ADD: opcode=0110011, funct3=000, funct7=0000000
        instruction = {7'b0000000, 5'b0, 5'b0, 3'b000, 5'b0, 7'b0110011};
        check_signals(
            1,  // reg_write
            0,  // mem_to_reg
            0,  // mem_read
            0,  // mem_write
            0,  // branch
            0,  // jump
            0,  // alu_src
            `ALU_ADD,  // alu_op
            3'b000,  // imm_type
            2'b00    // pc_src
        );

        // I-Type ADDI: opcode=0010011, funct3=000
        instruction = {12'b0, 5'b0, 3'b000, 5'b0, 7'b0010011};
        check_signals(
            1,  // reg_write
            0,  // mem_to_reg
            0,  // mem_read
            0,  // mem_write
            0,  // branch
            0,  // jump
            1,  // alu_src
            `ALU_ADD,  // alu_op
            3'b000,  // imm_type
            2'b00    // pc_src
        );

        // LOAD LW: opcode=0000011, funct3=010
        instruction = {12'b0, 5'b0, 3'b010, 5'b0, 7'b0000011};
        check_signals(
            1,  // reg_write
            1,  // mem_to_reg
            1,  // mem_read
            0,  // mem_write
            0,  // branch
            0,  // jump
            1,  // alu_src
            `ALU_ADD,  // alu_op
            3'b000,  // imm_type
            2'b00    // pc_src
        );

        // STORE SW: opcode=0100011, funct3=010
        instruction = {7'b0, 5'b0, 5'b0, 3'b010, 5'b0, 7'b0100011};
        check_signals(
            0,  // reg_write
            0,  // mem_to_reg
            0,  // mem_read
            1,  // mem_write
            0,  // branch
            0,  // jump
            1,  // alu_src
            `ALU_ADD,  // alu_op
            3'b001,  // imm_type
            2'b00    // pc_src
        );

        // BRANCH BEQ: opcode=1100011, funct3=000
        instruction = {7'b0, 5'b0, 5'b0, 3'b000, 5'b0, 7'b1100011};
        check_signals(
            0,  // reg_write
            0,  // mem_to_reg
            0,  // mem_read
            0,  // mem_write
            1,  // branch
            0,  // jump
            0,  // alu_src
            `ALU_SUB,  // alu_op
            3'b010,  // imm_type
            2'b00    // pc_src
        );

        // JAL
        instruction = {20'b0, 7'b1101111};
        check_signals(
            1,  // reg_write
            0,  // mem_to_reg
            0,  // mem_read
            0,  // mem_write
            0,  // branch
            1,  // jump
            0,  // alu_src
            `ALU_ADD,  // alu_op (não usado em JAL)
            3'b011,  // imm_type
            2'b01    // pc_src (jump)
        );

        $display("Fim dos testes");
        $finish;
    end

endmodule