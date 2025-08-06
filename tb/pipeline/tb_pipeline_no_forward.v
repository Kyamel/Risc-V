`timescale 1ns / 1ps

// Include ALU definitions
`include "alu_defines.vh"

module tb_pipeline_no_forwarding();

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

    // Signals
    reg clk;
    reg rst;
    
    // Pipeline control signals
    reg stall;
    reg flush;
    
    // IF Stage signals
    wire [31:0] pc_if;
    wire [31:0] instruction_if;
    
    // IF/ID Pipeline regs
    wire [31:0] pc_id;
    wire [31:0] instruction_id;

    
    // ID Stage signals
    wire [6:0] opcode;
    wire [4:0] rs1;
    wire [4:0] rs2;
    wire [4:0] rd;
    wire [2:0] funct3;
    wire [6:0] funct7;
    wire [31:0] imm_data;
    wire [31:0] read_data_1;
    wire [31:0] read_data_2;
    
    // Control signals from control unit
    wire [1:0] ALUOp;
    wire ALUSrc;
    wire Branch;
    wire MemRead;
    wire MemWrite;
    wire RegWrite;
    wire MemtoReg;
    
    // ID/EX Pipeline regs
    wire [31:0] ex_read_data_1;
    wire [31:0] ex_read_data_2;
    wire [31:0] ex_imm_data;
    wire [31:0] ex_pc_out;
    wire [4:0] ex_rs1;
    wire [4:0] ex_rs2;
    wire [4:0] ex_rd;
    wire ex_ALUSrc;
    wire [1:0] ex_ALUOp;
    wire ex_Branch;
    wire ex_MemRead;
    wire ex_MemWrite;
    wire ex_RegWrite;
    wire ex_MemtoReg;

    // EX Stage signals
    wire [31:0] alu_result; 
    wire alu_zero;
    wire [31:0] alu_b_input;
    wire [3:0] ALUOperation;
    wire [31:0] ex_adder_out; // PC + immediate for branch
    
    // EX/MEM Pipeline regs
    wire [31:0] mem_addr;
    wire [31:0] mem_write_data;
    wire [4:0] mem_rd;
    wire [31:0] mem_adder_out;
    wire mem_Branch;
    wire mem_MemRead;
    wire mem_MemWrite;
    wire mem_RegWrite;
    wire mem_MemtoReg;
    
    // MEM Stage signals
    wire [31:0] mem_read_data;
    
    // MEM/WB Pipeline regs
    wire [31:0] wb_read_data;
    wire [31:0] wb_result;
    wire [4:0] wb_rd;
    wire wb_RegWrite;
    wire wb_MemtoReg;
    
    // WB Stage signals
    wire [31:0] wb_write_data;
    
    // ========== IF Stage ==========
    pc_generator pc_gen (
        .clk(clk),
        .rst(rst),
        .pc_in(pc_if + 4), // Simple increment for testing (no branch logic yet)
        .pc_out(pc_if)
    );
    
    instruction_memory #(
        .INIT_FILE(TEST_PROGRAM)
    ) instr_mem (
        .instr_addr(pc_if),
        .instr(instruction_if)
    );
    
    // ========== IF/ID Pipeline Register ==========
    if_id if_id_reg (
        .clk(clk),
        .rst(rst),
        .stall(stall),
        .flush(flush),
        .pc_in(pc_if),
        .instr_in(instruction_if),
        .pc_out(pc_id),
        .instr_out(instruction_id)
    );
    
    // ========== ID Stage ==========
    instr_parser parser (
        .instr(instruction_id),
        .opcode(opcode),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd)
    );
    
    control_unit ctrl_unit (
        .opcode(opcode),
        // EX stage control signals
        .ALUOp(ALUOp),
        .ALUSrc(ALUSrc),
        // MEM stage control signals
        .Branch(Branch),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        // WB stage control signals
        .RegWrite(RegWrite),
        .MemtoReg(MemtoReg)
    );
    
    immediate_data_extractor imm_extractor (
        .instr(instruction_id),
        .imm_data(imm_data)
    );

    reg [$clog2(32)-1:0] debug_read_index_tb;
    wire [32-1:0] debug_data_out_tb;
    
    register_file #(
        .WIDTH(32),
        .DEPTH(32)
    ) reg_file (
        .clk(clk),
        .rst(rst),
        .rs1(rs1),
        .rs2(rs2),
        .rd(wb_rd),            // Write back from WB stage
        .wd(wb_write_data),    // Write data from WB stage
        .rw(wb_RegWrite),      // Write enable from WB stage
        .read_data_1(read_data_1),
        .read_data_2(read_data_2),
        .debug_read_index(debug_read_index_tb), // <- aqui
        .debug_data_out(debug_data_out_tb)  
    );
    
    // ========== ID/EX Pipeline Register ==========
    id_ex id_ex_reg (
        .clk(clk),
        .rst(rst),
        .stall(stall),
        .flush(flush),
        // ID stage inputs
        .id_read_data_1(read_data_1),
        .id_read_data_2(read_data_2),
        .id_imm_data(imm_data),
        .id_pc_out(pc_id),
        .id_rs1(rs1),
        .id_rs2(rs2),
        .id_rd(rd),
        // Control signals
        .id_ALUSrc(ALUSrc),
        .id_ALUOp(ALUOp),
        .id_Branch(Branch),
        .id_MemRead(MemRead),
        .id_MemWrite(MemWrite),
        .id_RegWrite(RegWrite),
        .id_MemtoReg(MemtoReg),
        // EX stage outputs
        .ex_read_data_1(ex_read_data_1),
        .ex_read_data_2(ex_read_data_2),
        .ex_imm_data(ex_imm_data),
        .ex_pc_out(ex_pc_out),
        .ex_rs1(ex_rs1),
        .ex_rs2(ex_rs2),
        .ex_rd(ex_rd),
        // Control signals to EX/MEM/WB
        .ex_ALUSrc(ex_ALUSrc),
        .ex_ALUOp(ex_ALUOp),
        .ex_Branch(ex_Branch),
        .ex_MemRead(ex_MemRead),
        .ex_MemWrite(ex_MemWrite),
        .ex_RegWrite(ex_RegWrite),
        .ex_MemtoReg(ex_MemtoReg)
    );
    
    // ========== EX Stage ==========
    alu_control alu_ctrl (
        .ALUOp(ex_ALUOp),
        .Funct({funct7, funct3}),
        .Op(ALUOperation)
    );
    
    // ALU input selection
    assign alu_b_input = ex_ALUSrc ? ex_imm_data : ex_read_data_2;
    
    alu alu_unit (
        .a(ex_read_data_1),
        .b(alu_b_input),
        .ALUOp(ALUOperation),
        .Result(alu_result),
        .Zero(alu_zero)
    );
    
    // Branch address calculation (PC + immediate)
    assign ex_adder_out = ex_pc_out + ex_imm_data;
    
    // ========== EX/MEM Pipeline Register ==========
    ex_mem ex_mem_reg (
        .clk(clk),
        .rst(rst),
        .stall(stall),
        .flush(flush),
        // Control signals from EX stage
        .ex_Branch(ex_Branch),
        .ex_MemRead(ex_MemRead),
        .ex_MemWrite(ex_MemWrite),
        .ex_RegWrite(ex_RegWrite),
        .ex_MemtoReg(ex_MemtoReg),
        // Data from EX stage
        .ex_adder_out(ex_adder_out),
        .ex_result(alu_result),
        .ex_rd(ex_rd),
        .ex_read_data_2_mux(ex_read_data_2), // No forwarding yet
        // Outputs to MEM stage
        .mem_addr(mem_addr),
        .mem_write_data(mem_write_data),
        .mem_rd(mem_rd),
        .mem_adder_out(mem_adder_out),
        // Control signals to MEM stage
        .mem_Branch(mem_Branch),
        .mem_MemRead(mem_MemRead),
        .mem_MemWrite(mem_MemWrite),
        .mem_RegWrite(mem_RegWrite),
        .mem_MemtoReg(mem_MemtoReg)
    );
    
    // ========== MEM Stage ==========
    data_memory #(
        .WIDTH(32),
        .DEPTH(1024),
        .INIT_FILE("none")
    ) data_mem (
        .clk(clk),
        .mem_addr(mem_addr),
        .write_data(mem_write_data),
        .mem_write(mem_MemWrite),
        .mem_read(mem_MemRead),
        .read_data(mem_read_data)
    );
    
    // ========== MEM/WB Pipeline Register ==========
    mem_wb mem_wb_reg (
        .clk(clk),
        .rst(rst),
        .stall(stall),
        .flush(flush),
        // Inputs from MEM stage
        .mem_read_data(mem_read_data),
        .mem_result(mem_addr), // ALU result passed through
        .mem_rd(mem_rd),
        .mem_RegWrite(mem_RegWrite),
        .mem_MemtoReg(mem_MemtoReg),
        // Outputs to WB stage
        .wb_read_data(wb_read_data),
        .wb_result(wb_result),
        .wb_rd(wb_rd),
        .wb_RegWrite(wb_RegWrite),
        .wb_MemtoReg(wb_MemtoReg)
    );
    
    // ========== WB Stage ==========
    // Write-back data selection
    assign wb_write_data = wb_MemtoReg ? wb_read_data : wb_result;
    
    // Assign instruction fields for ALU control
    assign funct3 = instruction_id[14:12];
    assign funct7 = instruction_id[31:25];
    
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
                instr = instr_mem.memory[addr[31:2]];
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
            $display("\n=== Estado dos Registradores ===");
            for (i = 0; i < 32; i = i + 4) begin
                debug_read_index_tb = i;
                #1;
                $write("x%02d=0x%08h  ", i, debug_data_out_tb);

                debug_read_index_tb = i + 1;
                #1;
                $write("x%02d=0x%08h  ", i + 1, debug_data_out_tb);

                debug_read_index_tb = i + 2;
                #1;
                $write("x%02d=0x%08h  ", i + 2, debug_data_out_tb);

                debug_read_index_tb = i + 3;
                #1;
                $display("x%02d=0x%08h", i + 3, debug_data_out_tb);
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
        $display("\n%sStarting complete pipeline test (no forwarding)...%s", GREEN, NC);
        for (integer i = 0; i < 20; i = i + 1) begin
            display_pipeline_info(i);
            
            // Insert some test scenarios
            case (i)
                7: begin
                    $display("%sTesting stall at cycle 7%s", RED, NC);
                    stall = 1;
                end
                8: begin
                    stall = 0;
                end
                12: begin
                    $display("%sTesting flush at cycle 12%s", RED, NC);
                    flush = 1;
                end
                13: begin
                    flush = 0;
                end
                15: begin
                    display_registers();
                end
            endcase
            
            #(CLK_PERIOD);
        end
        
        // Final register state
        display_registers();
        
        // Finish simulation
        $display("\n%s=== Complete Pipeline Test Finished ===%s", GREEN, NC);
        $finish;
    end

    // Clock generation
    always #(CLK_PERIOD/2) clk = ~clk;

endmodule