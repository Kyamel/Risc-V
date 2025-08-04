`timescale 1ns / 1ps

module tb_pipeline_partial();

    // Parameters
    parameter CLK_PERIOD = 10;
    parameter NUM_CYCLES = 12;
    
    // Signals
    reg clk;
    reg rst;
    reg stall;
    reg flush;
    
    wire [31:0] pc_current;
    wire [31:0] current_instruction;
    wire [31:0] alu_result;
    wire [31:0] reg_rs1;
    wire [31:0] reg_rs2;

    // Cycle counter
    integer cycle_count;
    initial cycle_count = 0;

    // Pipeline tracking for table
    reg [31:0] cycle_if_pc [0:15];
    reg [31:0] cycle_if_instr [0:15];
    reg [31:0] cycle_id_pc [0:15];
    reg [31:0] cycle_id_instr [0:15];
    reg [31:0] cycle_id_rs1 [0:15];
    reg [31:0] cycle_id_rs2 [0:15];
    reg [31:0] cycle_ex_pc [0:15];
    reg [31:0] cycle_ex_alu [0:15];

    // Instantiate DUT
    pipeline_partial uut (
        .clk(clk),
        .rst(rst),
        .stall(stall),
        .flush(flush),
        .pc_current(pc_current),
        .current_instruction(current_instruction),
        .alu_result_debug(alu_result),
        .reg_rs1_debug(reg_rs1),
        .reg_rs2_debug(reg_rs2)
    );

    // Clock generation
    always #(CLK_PERIOD/2) clk = ~clk;
    
    // Cycle counter and data capture
    always @(posedge clk) begin
        if (!rst) begin
            cycle_count <= cycle_count + 1;
            
            // Capture pipeline data for each cycle
            if (cycle_count < 16) begin
                // IF stage
                cycle_if_pc[cycle_count] <= pc_current;
                cycle_if_instr[cycle_count] <= current_instruction;
                
                // ID stage  
                if (cycle_count > 0) begin
                    cycle_id_pc[cycle_count] <= uut.if_id_pc;
                    cycle_id_instr[cycle_count] <= uut.if_id_instr;
                    cycle_id_rs1[cycle_count] <= reg_rs1;
                    cycle_id_rs2[cycle_count] <= reg_rs2;
                end
                
                // EX stage
                if (cycle_count > 1) begin
                    cycle_ex_pc[cycle_count] <= uut.idex_pc;
                    cycle_ex_alu[cycle_count] <= alu_result;
                end
            end
        end else begin
            cycle_count <= 0;
        end
    end

    // Task: Show instruction memory using internal parser
    task show_instruction_memory;
        integer i;
        reg [31:0] addr, instr;
        reg [6:0] opcode_temp;
        reg [4:0] rd_temp, rs1_temp, rs2_temp;
        reg [2:0] funct3_temp;
        reg [31:0] imm_temp;
        begin
            $display("\n=== MEMORIA DE INSTRUCOES ===");
            $display("Addr   | Hex        | Opcode | Rd | Rs1| Rs2| Imm  | Instrucao");
            $display("-------|------------|--------|----|----|----| ---- |------------------");
            
            for (i = 0; i < 16; i = i + 1) begin
                addr = i * 4;
                instr = uut.instr_mem.memory[i];
                
                // Use internal parser signals (simulate parsing)
                opcode_temp = instr[6:0];
                rd_temp = instr[11:7];
                rs1_temp = instr[19:15];
                rs2_temp = instr[24:20];
                funct3_temp = instr[14:12];
                
                // Extract immediate based on instruction type
                case (opcode_temp)
                    7'b0010011: imm_temp = {{20{instr[31]}}, instr[31:20]}; // I-type
                    7'b0110011: imm_temp = 32'h0; // R-type, no immediate
                    default: imm_temp = 32'hx;
                endcase
                
                $write("0x%04h | 0x%08h |  0x%02h  |x%-2d |x%-2d |x%-2d |%5d | ", 
                       addr, instr, opcode_temp, rd_temp, rs1_temp, rs2_temp, $signed(imm_temp[11:0]));
                
                // Use opcode to determine instruction type
                print_instruction_type(opcode_temp, funct3_temp, instr[30], rd_temp, rs1_temp, rs2_temp, $signed(imm_temp[11:0]));
                $display("");
            end
            $display("");
        end
    endtask

    // Task: Print instruction type based on internal parsing
    task print_instruction_type;
        input [6:0] opcode;
        input [2:0] funct3;
        input funct7_bit30;
        input [4:0] rd, rs1, rs2;
        input signed [11:0] imm;
        begin
            case (opcode)
                7'b0010011: begin // I-type arithmetic
                    case (funct3)
                        3'b000: $write("addi x%0d, x%0d, %0d", rd, rs1, imm);
                        3'b010: $write("slti x%0d, x%0d, %0d", rd, rs1, imm);
                        3'b011: $write("sltiu x%0d, x%0d, %0d", rd, rs1, imm);
                        3'b100: $write("xori x%0d, x%0d, %0d", rd, rs1, imm);
                        3'b110: $write("ori x%0d, x%0d, %0d", rd, rs1, imm);
                        3'b111: $write("andi x%0d, x%0d, %0d", rd, rs1, imm);
                        default: $write("I-type unknown (funct3=0x%0h)", funct3);
                    endcase
                end
                7'b0110011: begin // R-type arithmetic
                    case (funct3)
                        3'b000: begin
                            if (funct7_bit30)
                                $write("sub x%0d, x%0d, x%0d", rd, rs1, rs2);
                            else
                                $write("add x%0d, x%0d, x%0d", rd, rs1, rs2);
                        end
                        3'b001: $write("sll x%0d, x%0d, x%0d", rd, rs1, rs2);
                        3'b010: $write("slt x%0d, x%0d, x%0d", rd, rs1, rs2);
                        3'b011: $write("sltu x%0d, x%0d, x%0d", rd, rs1, rs2);
                        3'b100: $write("xor x%0d, x%0d, x%0d", rd, rs1, rs2);
                        3'b101: begin
                            if (funct7_bit30)
                                $write("sra x%0d, x%0d, x%0d", rd, rs1, rs2);
                            else
                                $write("srl x%0d, x%0d, x%0d", rd, rs1, rs2);
                        end
                        3'b110: $write("or x%0d, x%0d, x%0d", rd, rs1, rs2);
                        3'b111: $write("and x%0d, x%0d, x%0d", rd, rs1, rs2);
                        default: $write("R-type unknown (funct3=0x%0h)", funct3);
                    endcase
                end
                7'b0000011: begin // Load instructions
                    case (funct3)
                        3'b000: $write("lb x%0d, %0d(x%0d)", rd, imm, rs1);
                        3'b001: $write("lh x%0d, %0d(x%0d)", rd, imm, rs1);
                        3'b010: $write("lw x%0d, %0d(x%0d)", rd, imm, rs1);
                        3'b100: $write("lbu x%0d, %0d(x%0d)", rd, imm, rs1);
                        3'b101: $write("lhu x%0d, %0d(x%0d)", rd, imm, rs1);
                        default: $write("Load unknown (funct3=0x%0h)", funct3);
                    endcase
                end
                7'b0100011: begin // Store instructions
                    case (funct3)
                        3'b000: $write("sb x%0d, %0d(x%0d)", rs2, imm, rs1);
                        3'b001: $write("sh x%0d, %0d(x%0d)", rs2, imm, rs1);
                        3'b010: $write("sw x%0d, %0d(x%0d)", rs2, imm, rs1);
                        default: $write("Store unknown (funct3=0x%0h)", funct3);
                    endcase
                end
                7'b1100011: begin // Branch instructions
                    case (funct3)
                        3'b000: $write("beq x%0d, x%0d, %0d", rs1, rs2, imm);
                        3'b001: $write("bne x%0d, x%0d, %0d", rs1, rs2, imm);
                        3'b100: $write("blt x%0d, x%0d, %0d", rs1, rs2, imm);
                        3'b101: $write("bge x%0d, x%0d, %0d", rs1, rs2, imm);
                        3'b110: $write("bltu x%0d, x%0d, %0d", rs1, rs2, imm);
                        3'b111: $write("bgeu x%0d, x%0d, %0d", rs1, rs2, imm);
                        default: $write("Branch unknown (funct3=0x%0h)", funct3);
                    endcase
                end
                7'b1101111: $write("jal x%0d, %0d", rd, imm); // JAL
                7'b1100111: $write("jalr x%0d, x%0d, %0d", rd, rs1, imm); // JALR
                7'b0110111: $write("lui x%0d, 0x%05h", rd, imm); // LUI
                7'b0010111: $write("auipc x%0d, 0x%05h", rd, imm); // AUIPC
                default: $write("Unknown opcode 0x%02h", opcode);
            endcase
        end
    endtask

    // Task: Show pipeline execution table using internal signals
    task show_pipeline_table;
        integer i;
        begin
            $display("=== EXECUCAO DO PIPELINE ===");
            $display("Ciclo |      IF Stage      |         ID Stage         |      EX Stage");
            $display("      |   PC   | Instrucao |   PC   | RS1  | RS2  Imm |   PC   |  ALU");
            $display("------|--------|-----------|--------|------|----------|--------|--------");
            
            for (i = 1; i <= NUM_CYCLES; i = i + 1) begin
                $write(" %2d   ", i);
                
                // IF Stage
                if (i <= NUM_CYCLES && cycle_if_instr[i-1] !== 32'hx) begin
                    $write("| 0x%04h |    ", cycle_if_pc[i-1]);
                    print_short_instr(cycle_if_instr[i-1]);
                end else begin
                    $write("|   ---  |     ---   ");
                end
                
                // ID Stage  
                if (i > 1 && i <= NUM_CYCLES && cycle_id_instr[i-1] !== 32'hx) begin
                    $write("| 0x%04h | %04h | %04h %3d ", 
                           cycle_id_pc[i-1], 
                           cycle_id_rs1[i-1][15:0], 
                           cycle_id_rs2[i-1][15:0],
                           get_immediate_from_instr(cycle_id_instr[i-1]));
                end else begin
                    $write("|   ---  | ---- | ---- --- ");
                end
                
                // EX Stage
                if (i > 2 && i <= NUM_CYCLES && cycle_ex_alu[i-1] !== 32'hx) begin
                    $display("| 0x%04h | 0x%04h", cycle_ex_pc[i-1], cycle_ex_alu[i-1]);
                end else begin
                    $display("|   ---  |   ---");
                end
            end
            $display("");
        end
    endtask

    // Function: Extract immediate from instruction
    function signed [11:0] get_immediate_from_instr;
        input [31:0] instr;
        reg [6:0] opcode;
        begin
            opcode = instr[6:0];
            case (opcode)
                7'b0010011: get_immediate_from_instr = instr[31:20]; // I-type
                7'b0110011: get_immediate_from_instr = 12'h0; // R-type
                default: get_immediate_from_instr = 12'hx;
            endcase
        end
    endfunction

    // Task: Print short instruction format using internal parsing logic
    task print_short_instr;
        input [31:0] instr;
        reg [6:0] opcode;
        reg [2:0] funct3;
        begin
            opcode = instr[6:0];
            funct3 = instr[14:12];
            
            case (opcode)
                7'b0010011: begin // I-type
                    case (funct3)
                        3'b000: $write("addi  ");
                        3'b010: $write("slti  ");
                        3'b011: $write("sltiu ");
                        3'b100: $write("xori  ");
                        3'b110: $write("ori   ");
                        3'b111: $write("andi  ");
                        default: $write("I-??? ");
                    endcase
                end
                7'b0110011: begin // R-type
                    case (funct3)
                        3'b000: begin
                            if (instr[30]) $write("sub   ");
                            else $write("add   ");
                        end
                        3'b001: $write("sll   ");
                        3'b010: $write("slt   ");
                        3'b011: $write("sltu  ");
                        3'b100: $write("xor   ");
                        3'b101: begin
                            if (instr[30]) $write("sra   ");
                            else $write("srl   ");
                        end
                        3'b110: $write("or    ");
                        3'b111: $write("and   ");
                        default: $write("R-??? ");
                    endcase
                end
                7'b0000011: $write("load  ");
                7'b0100011: $write("store ");
                7'b1100011: $write("branch");
                7'b1101111: $write("jal   ");
                7'b1100111: $write("jalr  ");
                7'b0110111: $write("lui   ");
                7'b0010111: $write("auipc ");
                default: $write("???   ");
            endcase
        end
    endtask

    // Task: Show internal control signals
    task show_control_signals;
        integer i;
        begin
            $display("=== SINAIS DE CONTROLE POR CICLO ===");
            $display("Ciclo | Opcode | ALUOp | ALUSrc | ALU_Ctrl | Observacao");
            $display("------|--------|-------|--------|----------|--------------------");
            
            // This would show the control signals evolution
            // For now, we'll show a simplified version
            $display("(Informacao dos sinais de controle seria capturada durante simulacao)");
            $display("");
        end
    endtask

    // Task: Show final register state
    task show_final_registers;
        integer i;
        begin
            $display("=== ESTADO FINAL DOS REGISTRADORES ===");
            $display("Reg | Valor      | Reg | Valor      | Reg | Valor      | Reg | Valor");
            $display("----|------------|-----|------------|-----|------------|-----|--------");
            
            for (i = 0; i < 32; i = i + 4) begin
                if (i < 28) begin
                    $display("x%-2d | 0x%08h | x%-2d | 0x%08h | x%-2d | 0x%08h | x%-2d | 0x%08h",
                            i, uut.regs.regs[i],
                            i+1, uut.regs.regs[i+1], 
                            i+2, uut.regs.regs[i+2],
                            i+3, uut.regs.regs[i+3]);
                end else begin
                    // Last row might have fewer registers
                    case (32 - i)
                        4: $display("x%-2d | 0x%08h | x%-2d | 0x%08h | x%-2d | 0x%08h | x%-2d | 0x%08h",
                                   i, uut.regs.regs[i], i+1, uut.regs.regs[i+1], 
                                   i+2, uut.regs.regs[i+2], i+3, uut.regs.regs[i+3]);
                        3: $display("x%-2d | 0x%08h | x%-2d | 0x%08h | x%-2d | 0x%08h |     |         ",
                                   i, uut.regs.regs[i], i+1, uut.regs.regs[i+1], i+2, uut.regs.regs[i+2]);
                        2: $display("x%-2d | 0x%08h | x%-2d | 0x%08h |     |            |     |         ",
                                   i, uut.regs.regs[i], i+1, uut.regs.regs[i+1]);
                        1: $display("x%-2d | 0x%08h |     |            |     |            |     |         ",
                                   i, uut.regs.regs[i]);
                    endcase
                end
            end
            $display("");
        end
    endtask

    // Main test sequence
    initial begin
        $display("\n===============================================");
        $display("         TESTBENCH PIPELINE RV32I");
        $display("         (Usando Parser Interno)");
        $display("===============================================");
        
        // Initialize
        clk = 0;
        rst = 1;
        stall = 0;
        flush = 0;
        
        // Wait for memory initialization
        #(CLK_PERIOD);
        
        // Show instruction memory using internal components
        show_instruction_memory();
        
        // Reset
        #(CLK_PERIOD);
        rst = 0;
        
        // Run pipeline
        #(CLK_PERIOD * NUM_CYCLES);
        
        // Show results
        show_pipeline_table();
        show_control_signals();
        show_final_registers();
        
        $display("===============================================");
        $display("              SIMULACAO COMPLETA");
        $display("===============================================");
        $finish;
    end

endmodule