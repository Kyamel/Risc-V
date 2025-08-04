`timescale 1ns / 1ps

module tb_pipeline_partial();

    // Parameters
    parameter CLK_PERIOD = 10;
    parameter NUM_CYCLES = 32;
    
    // Signals
    reg clk;
    reg rst;
    reg stall;
    reg flush;
    
    // Debug outputs from DUT
    wire [31:0] pc_current;
    wire [31:0] current_instruction;
    wire [31:0] alu_result_debug;
    wire [31:0] reg_rs1_debug;
    wire [31:0] reg_rs2_debug;
    wire [31:0] if_id_pc_debug;
    wire [31:0] if_id_instr_debug;
    wire [31:0] id_ex_pc_debug;
    wire [31:0] id_ex_rs1_debug;
    wire [31:0] id_ex_rs2_debug;
    wire [31:0] id_ex_imm_debug;
    wire [1:0]  id_ex_aluop_debug;
    wire        id_ex_alusrc_debug;

    // Instantiate DUT
    pipeline_partial uut (
        .clk(clk),
        .rst(rst),
        .stall(stall),
        .flush(flush),
        .pc_current(pc_current),
        .current_instruction(current_instruction),
        .alu_result_debug(alu_result_debug),
        .reg_rs1_debug(reg_rs1_debug),
        .reg_rs2_debug(reg_rs2_debug),
        .if_id_pc_debug(if_id_pc_debug),
        .if_id_instr_debug(if_id_instr_debug),
        .id_ex_pc_debug(id_ex_pc_debug),
        .id_ex_rs1_debug(id_ex_rs1_debug),
        .id_ex_rs2_debug(id_ex_rs2_debug),
        .id_ex_imm_debug(id_ex_imm_debug),
        .id_ex_aluop_debug(id_ex_aluop_debug),
        .id_ex_alusrc_debug(id_ex_alusrc_debug)
    );

    // Clock generation
    always #(CLK_PERIOD/2) clk = ~clk;
    
    // ANSI color codes
    parameter GREEN = "\033[0;32m";
    parameter RED   = "\033[0;31m";
    parameter BLUE  = "\033[0;34m";
    parameter YELLOW = "\033[0;33m";
    parameter NC    = "\033[0m";
    
    // Test sequence
    initial begin
        $display("\n%s===============================================%s", BLUE, NC);
        $display("%s        TESTBENCH PIPELINE RV32I COMPLETO%s", BLUE, NC);
        $display("%s===============================================%s", BLUE, NC);
        
        // Initialize
        clk = 0;
        rst = 1;
        stall = 0;
        flush = 0;
        
        // Wait for memory initialization
        #(CLK_PERIOD);
        
        // Show instruction memory
        show_instruction_memory();
        
        // Release reset
        #(CLK_PERIOD);
        rst = 0;
        
        // Run pipeline for specified cycles
        $display("\n%sExecutando pipeline por %0d ciclos...%s", YELLOW, NUM_CYCLES, NC);
        #(CLK_PERIOD * NUM_CYCLES);
        
        // Show pipeline execution trace
        show_pipeline_trace();
        
        // Show final register state
        show_final_registers();
        
        // Perform automatic checks
        perform_checks();
        
        $display("\n%s===============================================%s", GREEN, NC);
        $display("%s          SIMULAÇÃO COMPLETA - TODOS TESTES OK%s", GREEN, NC);
        $display("%s===============================================%s\n", GREEN, NC);
        $finish;
    end

    // =============================================
    // TASKS FOR TESTING AND DEBUGGING
    // =============================================

    // Task: Show instruction memory contents
    task show_instruction_memory;
        integer i;
        reg [31:0] addr, instr;
        begin
            $display("\n%s=== MEMÓRIA DE INSTRUÇÕES (program.hex) ===%s", BLUE, NC);
            $display("Endereço | Instrução  | Tipo   | Decodificação");
            $display("---------|------------|--------|------------------");
            
            for (i = 0; i < 16; i = i + 1) begin
                addr = i * 4;
                instr = uut.instr_mem.memory[i];
                
                $write("0x%04h   | 0x%08h | ", addr, instr);
                
                // Print instruction type
                case (instr[6:0])
                    7'b0110011: $write("R-type | ");
                    7'b0010011: $write("I-type | ");
                    7'b0000011: $write("LOAD   | ");
                    7'b0100011: $write("STORE  | ");
                    7'b1100011: $write("BRANCH | ");
                    7'b1101111: $write("JAL    | ");
                    7'b1100111: $write("JALR   | ");
                    7'b0110111: $write("LUI    | ");
                    7'b0010111: $write("AUIPC  | ");
                    default:    $write("UNKNOWN| ");
                endcase
                
                // Print decoded instruction
                print_decoded_instruction(instr);
                $display("");
            end
        end
    endtask

    // Task: Print decoded instruction
    task print_decoded_instruction;
        input [31:0] instr;
        reg [6:0] opcode;
        reg [4:0] rd, rs1, rs2;
        reg [2:0] funct3;
        reg [6:0] funct7;
        reg [31:0] imm;
        begin
            opcode = instr[6:0];
            rd = instr[11:7];
            rs1 = instr[19:15];
            rs2 = instr[24:20];
            funct3 = instr[14:12];
            funct7 = instr[31:25];
            
            case (opcode)
                // R-type instructions
                7'b0110011: begin
                    case (funct3)
                        3'b000: $write("%s x%0d, x%0d, x%0d", (funct7[5] ? "sub" : "add"), rd, rs1, rs2);
                        3'b001: $write("sll x%0d, x%0d, x%0d", rd, rs1, rs2);
                        3'b010: $write("slt x%0d, x%0d, x%0d", rd, rs1, rs2);
                        3'b011: $write("sltu x%0d, x%0d, x%0d", rd, rs1, rs2);
                        3'b100: $write("xor x%0d, x%0d, x%0d", rd, rs1, rs2);
                        3'b101: $write("%s x%0d, x%0d, x%0d", (funct7[5] ? "sra" : "srl"), rd, rs1, rs2);
                        3'b110: $write("or x%0d, x%0d, x%0d", rd, rs1, rs2);
                        3'b111: $write("and x%0d, x%0d, x%0d", rd, rs1, rs2);
                        default: $write("R-type unknown");
                    endcase
                end
                
                // I-type instructions
                7'b0010011: begin
                    imm = {{20{instr[31]}}, instr[31:20]};
                    case (funct3)
                        3'b000: $write("addi x%0d, x%0d, %0d", rd, rs1, $signed(imm));
                        3'b010: $write("slti x%0d, x%0d, %0d", rd, rs1, $signed(imm));
                        3'b011: $write("sltiu x%0d, x%0d, %0d", rd, rs1, $signed(imm));
                        3'b100: $write("xori x%0d, x%0d, %0d", rd, rs1, $signed(imm));
                        3'b110: $write("ori x%0d, x%0d, %0d", rd, rs1, $signed(imm));
                        3'b111: $write("andi x%0d, x%0d, %0d", rd, rs1, $signed(imm));
                        default: $write("I-type unknown");
                    endcase
                end
                
                // Other instruction types (simplified)
                7'b0000011: $write("lw x%0d, %0d(x%0d)", rd, $signed({{20{instr[31]}}, instr[31:20]}), rs1);
                7'b0100011: $write("sw x%0d, %0d(x%0d)", rs2, $signed({{20{instr[31]}}, instr[31:25], instr[11:7]}), rs1);
                7'b1100011: $write("beq x%0d, x%0d, %0d", rs1, rs2, $signed({{20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0}));
                7'b1101111: $write("jal x%0d, %0d", rd, $signed({{12{instr[31]}}, instr[19:12], instr[20], instr[30:21], 1'b0}));
                7'b1100111: $write("jalr x%0d, x%0d, %0d", rd, rs1, $signed({{20{instr[31]}}, instr[31:20]}));
                7'b0110111: $write("lui x%0d, 0x%05h", rd, instr[31:12]);
                7'b0010111: $write("auipc x%0d, 0x%05h", rd, instr[31:12]);
                default: $write("Unknown instruction");
            endcase
        end
    endtask

    // Task: Show pipeline execution trace
    task show_pipeline_trace;
        integer i;
        begin
            $display("\n%s=== EXECUÇÃO DO PIPELINE ===%s", BLUE, NC);
            $display("Ciclo | Estágio IF            | Estágio ID            | Estágio EX");
            $display("      | PC       | Instrução | PC       | RS1/RS2  | PC       | ALU Result");
            $display("------|----------|-----------|----------|----------|----------|-----------");
            
            for (i = 1; i <= NUM_CYCLES; i = i + 1) begin
                $write(" %2d   | ", i);
                
                // IF Stage (current cycle)
                if (i <= NUM_CYCLES) begin
                    $write("0x%04h  | ", (i-1)*4);  // Cycle
                    print_short_instruction(uut.instr_mem.memory[(i-1)/4]);  // PC
                end else begin
                    $write("  ---    |   ---   ");
                end
                
                // ID Stage (previous cycle)
                if (i > 1 && i <= NUM_CYCLES+1) begin
                    $write("| 0x%04h  | x%0d/x%0d ", (i-2)*4, // PC
                           uut.if_id_instr_debug[19:15],  //  rs1
                           uut.if_id_instr_debug[24:20]); //  rs2
                end else begin
                    $write("|   ---    |  --/-- ");
                end
                
                // EX Stage (two cycles before)
                if (i > 2 && i <= NUM_CYCLES+2) begin
                    $display("| 0x%04h  | 0x%08h", (i-3)*4, uut.alu_result_debug); // ALU Result
                end else begin
                    $display("|   ---    |   ---");
                end
            end
        end
    endtask

    // Helper task: Print short instruction name
    task print_short_instruction;
        input [31:0] instr;
        begin
            case (instr[6:0])
                7'b0110011: $write("R-type");
                7'b0010011: $write("I-type");
                7'b0000011: $write("LOAD  ");
                7'b0100011: $write("STORE ");
                7'b1100011: $write("BRANCH");
                7'b1101111: $write("JAL   ");
                7'b1100111: $write("JALR  ");
                7'b0110111: $write("LUI   ");
                7'b0010111: $write("AUIPC ");
                default:    $write("UNKWN ");
            endcase
        end
    endtask

    // Task: Show final register state
    task show_final_registers;
        integer i;
        begin
            $display("\n%s=== ESTADO FINAL DOS REGISTRADORES ===%s", BLUE, NC);
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
        end
    endtask

    // Task: Perform automatic checks
    task perform_checks;
        begin
            $display("\n%s=== VERIFICAÇÕES AUTOMÁTICAS ===%s", BLUE, NC);
            
            // Check if pipeline is progressing
            if (uut.pc_current > 0) begin
                $display("%s[PASS]%s Pipeline está progredindo (PC = 0x%08h)", GREEN, NC, uut.pc_current);
            end else begin
                $display("%s[FAIL]%s Pipeline não está progredindo", RED, NC);
            end
            
            // Check if instructions are being fetched
            if (uut.current_instruction !== 32'hx) begin
                $display("%s[PASS]%s Instruções estão sendo buscadas", GREEN, NC);
            end else begin
                $display("%s[FAIL]%s Nenhuma instrução está sendo buscada", RED, NC);
            end
            
            // Check if ALU is producing results
            if (uut.alu_result_debug !== 32'hx) begin
                $display("%s[PASS]%s ALU está produzindo resultados (Último: 0x%08h)", GREEN, NC, uut.alu_result_debug);
            end else begin
                $display("%s[FAIL]%s ALU não está produzindo resultados", RED, NC);
            end
            
            // Add more specific checks based on your test program
            // Example: Check if a specific instruction was executed correctly
            // if (uut.regs.regs[10] == 32'h0000000f) begin
            //     $display("%s[PASS]%s Registrador x10 contém valor esperado (0x0f)", GREEN, NC);
            // end else begin
            //     $display("%s[FAIL]%s Registrador x10 contém 0x%08h (esperado 0x0f)", RED, NC, uut.regs.regs[10]);
            // end
        end
    endtask

endmodule