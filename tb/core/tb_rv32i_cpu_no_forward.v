`timescale 1ns / 1ps

// Include ALU definitions
`include "alu_defines.vh"

module tb_rv32i_cpu_no_forward();

    // Parameters
    parameter CLK_PERIOD = 10; // 10 ns = 100 MHz
    parameter TEST_PROGRAM = "compiler/program.hex";
    
    // ANSI color codes
    parameter GREEN = "\033[0;32m";
    parameter RED   = "\033[0;31m";
    parameter NC    = "\033[0m";
    parameter CYAN  = "\033[0;36m";
    parameter YELLOW = "\033[0;33m";
    parameter MAGENTA = "\033[0;35m";
    parameter BLUE = "\033[0;34m";

    // Test signals
    reg clk;
    reg rst;
    reg stall;
    reg flush;
    
    // Debug signals
    reg [$clog2(32)-1:0] debug_reg_index;
    wire [31:0] debug_reg_data;
    reg [$clog2(1024)-1:0] debug_mem_index;
    wire [31:0] debug_mem_data;
    
    // Pipeline debug outputs
    wire [31:0] pc_if;
    wire [31:0] instruction_if;
    wire [31:0] pc_id;
    wire [31:0] instruction_id;
    
    // ID Stage debug outputs
    wire [6:0] opcode;
    wire [4:0] rs1, rs2, rd;
    wire [2:0] funct3;
    wire [6:0] funct7;
    wire [31:0] imm_data;
    wire [31:0] read_data_1, read_data_2;
    
    // Control signals debug outputs
    wire [1:0] ALUOp;
    wire ALUSrc, Branch, MemRead, MemWrite, RegWrite, MemtoReg;
    
    // EX Stage debug outputs
    wire [31:0] ex_read_data_1, ex_read_data_2, ex_imm_data, ex_pc_out;
    wire [4:0] ex_rs1, ex_rs2, ex_rd;
    wire ex_ALUSrc, ex_Branch, ex_MemRead, ex_MemWrite, ex_RegWrite, ex_MemtoReg;
    wire [1:0] ex_ALUOp;
    wire [31:0] alu_result, alu_b_input, ex_adder_out;
    wire alu_zero;
    wire [3:0] ALUOperation;
    
    // MEM Stage debug outputs
    wire [31:0] mem_addr, mem_write_data, mem_adder_out, mem_read_data;
    wire [4:0] mem_rd;
    wire mem_Branch, mem_MemRead, mem_MemWrite, mem_RegWrite, mem_MemtoReg;
    
    // WB Stage debug outputs
    wire [31:0] wb_read_data, wb_result, wb_write_data;
    wire [4:0] wb_rd;
    wire wb_RegWrite, wb_MemtoReg;
    
    // Instantiate CPU
    rv32i_cpu_no_forward #(
        .TEST_PROGRAM(TEST_PROGRAM)
    ) cpu (
        .clk(clk),
        .rst(rst),
        .stall(stall),
        .flush(flush),
        
        // Debug signals
        .debug_reg_index(debug_reg_index),
        .debug_reg_data(debug_reg_data),
        .debug_mem_index(debug_mem_index),
        .debug_mem_data(debug_mem_data),
        
        // Pipeline debug outputs
        .pc_if_out(pc_if),
        .instruction_if_out(instruction_if),
        .pc_id_out(pc_id),
        .instruction_id_out(instruction_id),
        
        // ID Stage debug outputs
        .opcode_out(opcode),
        .rs1_out(rs1),
        .rs2_out(rs2),
        .rd_out(rd),
        .funct3_out(funct3),
        .funct7_out(funct7),
        .imm_data_out(imm_data),
        .read_data_1_out(read_data_1),
        .read_data_2_out(read_data_2),
        
        // Control signals debug outputs
        .ALUOp_out(ALUOp),
        .ALUSrc_out(ALUSrc),
        .Branch_out(Branch),
        .MemRead_out(MemRead),
        .MemWrite_out(MemWrite),
        .RegWrite_out(RegWrite),
        .MemtoReg_out(MemtoReg),
        
        // EX Stage debug outputs
        .ex_read_data_1_out(ex_read_data_1),
        .ex_read_data_2_out(ex_read_data_2),
        .ex_imm_data_out(ex_imm_data),
        .ex_pc_out_out(ex_pc_out),
        .ex_rs1_out(ex_rs1),
        .ex_rs2_out(ex_rs2),
        .ex_rd_out(ex_rd),
        .ex_ALUSrc_out(ex_ALUSrc),
        .ex_ALUOp_out(ex_ALUOp),
        .ex_Branch_out(ex_Branch),
        .ex_MemRead_out(ex_MemRead),
        .ex_MemWrite_out(ex_MemWrite),
        .ex_RegWrite_out(ex_RegWrite),
        .ex_MemtoReg_out(ex_MemtoReg),
        .alu_result_out(alu_result),
        .alu_zero_out(alu_zero),
        .alu_b_input_out(alu_b_input),
        .ALUOperation_out(ALUOperation),
        .ex_adder_out_out(ex_adder_out),
        
        // MEM Stage debug outputs
        .mem_addr_out(mem_addr),
        .mem_write_data_out(mem_write_data),
        .mem_rd_out(mem_rd),
        .mem_adder_out_out(mem_adder_out),
        .mem_Branch_out(mem_Branch),
        .mem_MemRead_out(mem_MemRead),
        .mem_MemWrite_out(mem_MemWrite),
        .mem_RegWrite_out(mem_RegWrite),
        .mem_MemtoReg_out(mem_MemtoReg),
        .mem_read_data_out(mem_read_data),
        
        // WB Stage debug outputs
        .wb_read_data_out(wb_read_data),
        .wb_result_out(wb_result),
        .wb_rd_out(wb_rd),
        .wb_RegWrite_out(wb_RegWrite),
        .wb_MemtoReg_out(wb_MemtoReg),
        .wb_write_data_out(wb_write_data)
    );
    
    // Initialize control signals for testing
    initial begin
        stall = 0;
        flush = 0;
    end

    // Display instruction memory contents
    task display_instruction_memory;
        input [31:0] start_addr;
        input [31:0] num_instructions;
        integer i;
        reg [31:0] addr;
        reg [31:0] instr;
        begin
            $display("\n%s=== Instruction Memory Contents (first %0d instructions) ===%s", CYAN, num_instructions, NC);
            $display("Address    Instruction  Assembly");
            $display("----------------------------------------");
            
            for (i = 0; i < num_instructions; i = i + 1) begin
                addr = start_addr + (i * 4);
                instr = cpu.instr_mem.memory[addr[31:2]];
                $write("0x%08h: 0x%08h  ", addr, instr);
                print_instruction(instr);
                $display("");
            end
        end
    endtask

    // Print instruction in assembly format
    task print_instruction;
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
                7'b0110011: begin // R-type
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
                7'b0010011: begin // I-type arithmetic
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

    // Display complete pipeline information
    task display_pipeline_info;
        input integer cycle;
        begin
            $display("\n%s=== Cycle %0d ===%s", CYAN, cycle, NC);
            
            // IF Stage
            $write("%sIF:%s PC=0x%08h | Instr=0x%08h ", YELLOW, NC, pc_if, instruction_if);
            print_instruction(instruction_if);
            $display("");
            
            // ID Stage
            $write("%sID:%s rs1=x%0d(0x%08h) rs2=x%0d(0x%08h) rd=x%0d ", 
                  YELLOW, NC, rs1, read_data_1, rs2, read_data_2, rd);
            $write("Imm=0x%08h | ", imm_data);
            $write("Ctrl: ALUOp=%b ALUSrc=%b MemR=%b MemW=%b RegW=%b", 
                  ALUOp, ALUSrc, MemRead, MemWrite, RegWrite);
            $display("");
            
            // EX Stage
            $write("%sEX:%s rs1=x%0d(0x%08h) %s=0x%08h ", 
                  YELLOW, NC, ex_rs1, ex_read_data_1, 
                  ex_ALUSrc ? "Imm" : "rs2", alu_b_input);
            $write("(ALU %s) -> Result=0x%08h | Zero=%b | rd=x%0d", 
                  get_alu_op_name(ALUOperation), alu_result, alu_zero, ex_rd);
            $display("");
            
            // MEM Stage
            $write("%sMEM:%s Addr=0x%08h ", YELLOW, NC, mem_addr);
            if (mem_MemRead) 
                $write("READ -> 0x%08h ", mem_read_data);
            else if (mem_MemWrite) 
                $write("WRITE <- 0x%08h ", mem_write_data);
            else 
                $write("NO ACCESS ");
            $write("| rd=x%0d", mem_rd);
            $display("");
            
            // WB Stage
            $write("%sWB:%s ", YELLOW, NC);
            if (wb_RegWrite) begin
                $write("x%0d <- 0x%08h (%s)", wb_rd, wb_write_data, 
                      wb_MemtoReg ? "MEM" : "ALU");
            end else begin
                $write("NO WRITE");
            end
            $display("");
            
            $display("---");
        end
    endtask

    // Helper function for ALU operation names
    function string get_alu_op_name;
        input [3:0] op;
        case (op)
            `ALU_ADD:  return "ADD";
            `ALU_SUB:  return "SUB";
            `ALU_SLL:  return "SLL";
            `ALU_SLT:  return "SLT";
            `ALU_SLTU: return "SLTU";
            `ALU_XOR:  return "XOR";
            `ALU_SRL:  return "SRL";
            `ALU_SRA:  return "SRA";
            `ALU_OR:   return "OR";
            `ALU_AND:  return "AND";
            `ALU_LUI:  return "LUI";
            default:   return "UNKNOWN";
        endcase
    endfunction

    // Display register file state
    task display_registers;
        integer i;
        begin
            $display("\n%s=== Estado dos Registradores ===%s", MAGENTA, NC);
            for (i = 0; i < 32; i = i + 4) begin
                debug_reg_index = i;
                #1;
                $write("x%02d=0x%08h  ", i, debug_reg_data);

                debug_reg_index = i + 1;
                #1;
                $write("x%02d=0x%08h  ", i + 1, debug_reg_data);

                debug_reg_index = i + 2;
                #1;
                $write("x%02d=0x%08h  ", i + 2, debug_reg_data);

                debug_reg_index = i + 3;
                #1;
                $display("x%02d=0x%08h", i + 3, debug_reg_data);
            end
        end
    endtask

    // Display data memory contents
    task display_data_memory;
        input [31:0] start_addr;
        input [31:0] num_words;
        integer i;
        reg [31:0] addr;
        begin
            $display("\n%s=== Memória de Dados (primeiras %0d palavras) ===%s", BLUE, num_words, NC);
            $display("Endereço   Dados");
            $display("--------------------");
            
            for (i = 0; i < num_words; i = i + 1) begin
                addr = start_addr + (i * 4);
                debug_mem_index = addr[31:2]; // Word-addressable
                #1;
                $display("0x%08h: 0x%08h", addr, debug_mem_data);
            end
        end
    endtask

    // Test sequence
    initial begin
        // Initialize
        clk = 0;
        rst = 1;
        
        // Display instruction memory first
        display_instruction_memory(32'h00000000, 16);
        
        // Release reset
        #(CLK_PERIOD*2);
        rst = 0;
        
        // Run through the complete pipeline
        $display("\n%sIniciando teste completo do pipeline (sem forwarding)...%s", GREEN, NC);
        for (integer i = 0; i < 20; i = i + 1) begin
            display_pipeline_info(i);
            
            // Insert some test scenarios
            /*
            case (i)
                7: begin
                    $display("%sTestando stall no ciclo 7%s", RED, NC);
                    stall = 1;
                end
                8: begin
                    stall = 0;
                end
                12: begin
                    $display("%sTestando flush no ciclo 12%s", RED, NC);
                    flush = 1;
                end
                13: begin
                    flush = 0;
                end
                15: begin
                    display_registers();
                    display_data_memory(32'h00000000, 16);
                end
            endcase
            */
            
            #(CLK_PERIOD);
        end
        
        // Final state display
        $display("\n%s=== Estado Final ===%s", GREEN, NC);
        display_registers();
        display_data_memory(32'h00000000, 16);
        
        // Finish simulation
        $display("\n%s=== Teste Completo do Pipeline Finalizado ===%s", GREEN, NC);
        $finish;
    end

    // Clock generation
    always #(CLK_PERIOD/2) clk = ~clk;

endmodule