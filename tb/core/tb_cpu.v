`timescale 1ns / 1ps

// Generic processor testbench. Normally driven by scripts/test.lua
// (make prog / make trace), but it can also be run directly with vvp or with
// the executable built by Verilator.
//
// Plusargs:
//   +PROG=<file.hex>      program (required)
//   +DATA=<file.hex>      initial data memory contents (optional)
//   +END=<hex>            address right after the last program instruction; the
//                         simulation stops when the instruction at this address
//                         reaches WB (every earlier instruction has finished)
//   +MAX_CYCLES=<n>       cycle limit (default 1000)
//   +TRACE                print the pipeline state every cycle
//   +VCD=<file.vcd>       dump a waveform for GTKWave
//
// Output (one item per line):
//   TRACE <cycle> <pc/instr of IF ID EX MEM WB> <flush> <stall> <fwdA> <fwdB>
//         <wb_we> <wb_rd> <wb_data> <mem_we> <mem_addr> <mem_wdata> <illegal>
//   ILLEGAL <pc> <instr>     (instruction naming x16-x31 reached ID)
//   HALT <cycles> | TIMEOUT <cycles>
//   REG <n> <hex>
//   MEM <address> <hex>      (non-zero words only)

module tb_cpu;

    localparam REG_COUNT = 16;  // RV32E

    reg clk = 1'b0;
    reg rst = 1'b1;

    rv32e_cpu #(
        .INSTR_DEPTH(1024),
        .INSTR_INIT_FILE(""),
        .DATA_DEPTH(1024),
        .DATA_INIT_FILE("none"),
        .REG_COUNT(REG_COUNT)
    ) dut (
        .clk(clk),
        .rst(rst)
    );

    always #5 clk = ~clk;

    reg [8*512-1:0] prog_file, data_file, vcd_file;
    reg [31:0] end_addr;
    integer max_cycles, cycle, i;
    reg trace, halted;

    initial begin
        if (!$value$plusargs("PROG=%s", prog_file)) begin
            $display("ERROR: missing +PROG=<file.hex>");
            $finish;
        end
        if (!$value$plusargs("END=%h", end_addr)) end_addr = 32'hFFFFFFFF;
        if (!$value$plusargs("MAX_CYCLES=%d", max_cycles)) max_cycles = 1000;
        trace = $test$plusargs("TRACE");
        if ($value$plusargs("VCD=%s", vcd_file)) begin
            $dumpfile(vcd_file);
            $dumpvars(0, tb_cpu);
        end

        // Let the memories' initial blocks (zero / NOP fill) run first
        #1;
        $readmemh(prog_file, dut.instr_mem.memory);
        if ($value$plusargs("DATA=%s", data_file)) begin
            $readmemh(data_file, dut.data_mem.memory);
        end

        repeat (2) @(posedge clk);
        @(negedge clk) rst = 1'b0;

        // Each iteration samples the middle of a cycle (negedge), when every
        // signal has settled, and then advances to the next one.
        cycle = 0;
        halted = 1'b0;
        while (!halted && cycle < max_cycles) begin
            if (trace) begin
                $display("TRACE %0d %h %h %h %h %h %h %h %h %h %h %b %b %b %b %b %0d %h %b %h %h %b",
                    cycle,
                    dut.pc_out, dut.instruction,
                    dut.id_pc, dut.id_instr,
                    dut.dbg_ex_pc, dut.dbg_ex_instr,
                    dut.dbg_mem_pc, dut.dbg_mem_instr,
                    dut.dbg_wb_pc, dut.dbg_wb_instr,
                    dut.flush, dut.stall, dut.forward_a, dut.forward_b,
                    dut.mem_wb_RegWrite, dut.mem_wb_rd, dut.write_data_mux,
                    dut.ex_mem_MemWrite, dut.ex_mem_alu_result, dut.ex_mem_write_data,
                    dut.illegal_reg);
            end
            // Reported once: on stall the instruction stays in ID; on flush it is discarded anyway
            if (dut.illegal_reg && !dut.stall && !dut.flush) begin
                $display("ILLEGAL %h %h", dut.id_pc, dut.id_instr);
            end
            if (dut.dbg_wb_instr != 32'b0 && dut.dbg_wb_pc >= end_addr) begin
                halted = 1'b1;
            end else begin
                @(negedge clk);
                cycle = cycle + 1;
            end
        end

        if (halted) $display("HALT %0d", cycle);
        else        $display("TIMEOUT %0d", cycle);

        for (i = 0; i < REG_COUNT; i = i + 1) begin
            $display("REG %0d %h", i, dut.reg_file.regs[i]);
        end
        for (i = 0; i < 1024; i = i + 1) begin
            if (dut.data_mem.memory[i] !== 32'b0) begin
                $display("MEM %h %h", i * 4, dut.data_mem.memory[i]);
            end
        end

        $finish;
    end

endmodule
