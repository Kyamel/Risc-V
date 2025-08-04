`timescale 1ns / 1ps

// Include ALU definitions
`include "alu_defines.vh"

module tb_fetch_and_decode();

    // Parameters
    parameter CLK_PERIOD = 10; // 10 ns = 100 MHz
    parameter TEST_PROGRAM = "compiler/program.hex";
    
    // ANSI color codes
    parameter GREEN = "\033[0;32m";
    parameter RED   = "\033[0;31m";
    parameter NC    = "\033[0m";

    // Signals
    reg clk;
    reg rst;
    wire [31:0] pc;
    wire [31:0] instruction;
    
    // Instruction fields
    wire [6:0] opcode;
    wire [4:0] rs1;
    wire [4:0] rs2;
    wire [4:0] rd;
    wire [2:0] funct3;
    wire [6:0] funct7;
    wire [31:0] imm_data;
    
    // Control signals
    wire [1:0] ALUOp;
    wire ALUSrc;
    wire [3:0] ALUOperation;
    
    // Test program instructions
    localparam [31:0] 
        ADD_INSTR  = 32'h00C58633,  // add x12, x11, x12
        ADDI_INSTR = 32'h00C58613,  // addi x12, x11, 12
        LW_INSTR   = 32'h0045A603,  // lw x12, 4(x11)
        SW_INSTR   = 32'h00C5A423,  // sw x12, 8(x11)
        BEQ_INSTR  = 32'h00C58663,  // beq x11, x12, 12
        AND_INSTR  = 32'h00C5F633;  // and x12, x11, x12

    // Instantiate modules
    instruction_memory #(
        .INIT_FILE(TEST_PROGRAM)
    ) instr_mem (
        .instr_addr(pc),
        .instr(instruction)
    );
    
    instr_parser parser (
        .instr(instruction),
        .opcode(opcode),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd)
    );
    
    control_unit ctrl_unit (
        .opcode(opcode),
        .ALUOp(ALUOp),
        .ALUSrc(ALUSrc)
    );
    
    immediate_data_extractor imm_extractor (
        .instr(instruction),
        .imm_data(imm_data)
    );
    
    alu_control alu_ctrl (
        .ALUOp(ALUOp),
        .Funct({funct7, funct3}),
        .Op(ALUOperation)
    );
    
    // Assign instruction fields
    assign funct3 = instruction[14:12];
    assign funct7 = instruction[31:25];
    
    // PC counter (simplified for testing)
    reg [31:0] pc_reg;
    assign pc = pc_reg;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            pc_reg <= 0;
        end else begin
            pc_reg <= pc_reg + 4;
        end
    end

    // Display instruction information
    task display_instruction_info;
        input [31:0] instr;
        input integer cycle;
        begin
            $display("\n=== Cycle %0d: Instruction Decoding ===", cycle);
            $display("PC: 0x%08h | Instruction: 0x%08h", pc, instr);

            // Display decoded assembly instruction
            $write("Decoded Instruction: ");
            case (opcode)
                7'b0110011: begin // R-type
                    case (funct3)
                        3'b000: $display("add x%0d, x%0d, x%0d", rd, rs1, rs2);
                        3'b001: $display("sll x%0d, x%0d, x%0d", rd, rs1, rs2);
                        3'b010: $display("slt x%0d, x%0d, x%0d", rd, rs1, rs2);
                        3'b100: $display("xor x%0d, x%0d, x%0d", rd, rs1, rs2);
                        3'b101: $display("srl x%0d, x%0d, x%0d", rd, rs1, rs2);
                        3'b110: $display("or  x%0d, x%0d, x%0d", rd, rs1, rs2);
                        3'b111: $display("and x%0d, x%0d, x%0d", rd, rs1, rs2);
                        default: $display("Unknown R-type (funct3=0x%0h)", funct3);
                    endcase
                end

                7'b0010011: begin // I-type (immediate ALU)
                    case (funct3)
                        3'b000: $display("addi x%0d, x%0d, %0d", rd, rs1, $signed(imm_data));
                        3'b010: $display("slti x%0d, x%0d, %0d", rd, rs1, $signed(imm_data));
                        3'b100: $display("xori x%0d, x%0d, %0d", rd, rs1, $signed(imm_data));
                        3'b110: $display("ori  x%0d, x%0d, %0d", rd, rs1, $signed(imm_data));
                        3'b111: $display("andi x%0d, x%0d, %0d", rd, rs1, $signed(imm_data));
                        default: $display("Unknown I-type (funct3=0x%0h)", funct3);
                    endcase
                end

                7'b0000011: begin // I-type (Load)
                    case (funct3)
                        3'b000: $display("lb x%0d, %0d(x%0d)", rd, $signed(imm_data), rs1);
                        3'b001: $display("lh x%0d, %0d(x%0d)", rd, $signed(imm_data), rs1);
                        3'b010: $display("lw x%0d, %0d(x%0d)", rd, $signed(imm_data), rs1);
                        default: $display("Unknown Load (funct3=0x%0h)", funct3);
                    endcase
                end

                7'b0100011: begin // S-type (Store)
                    case (funct3)
                        3'b000: $display("sb x%0d, %0d(x%0d)", rs2, $signed(imm_data), rs1);
                        3'b001: $display("sh x%0d, %0d(x%0d)", rs2, $signed(imm_data), rs1);
                        3'b010: $display("sw x%0d, %0d(x%0d)", rs2, $signed(imm_data), rs1);
                        default: $display("Unknown Store (funct3=0x%0h)", funct3);
                    endcase
                end

                7'b1100011: begin // B-type (Branch)
                    case (funct3)
                        3'b000: $display("beq x%0d, x%0d, %0d", rs1, rs2, $signed(imm_data));
                        3'b001: $display("bne x%0d, x%0d, %0d", rs1, rs2, $signed(imm_data));
                        3'b100: $display("blt x%0d, x%0d, %0d", rs1, rs2, $signed(imm_data));
                        3'b101: $display("bge x%0d, x%0d, %0d", rs1, rs2, $signed(imm_data));
                        default: $display("Unknown Branch (funct3=0x%0h)", funct3);
                    endcase
                end

                7'b0110111: $display("lui x%0d, 0x%05h", rd, imm_data >> 12);
                7'b0010111: $display("auipc x%0d, 0x%05h", rd, imm_data >> 12);
                7'b1101111: $display("jal x%0d, %0d", rd, $signed(imm_data));
                7'b1100111: $display("jalr x%0d, x%0d, %0d", rd, rs1, $signed(imm_data));

                default: $display("Unknown or unsupported opcode: 0x%02h", opcode);
            endcase

            // Dump internal decode info
            $display("Decoded Fields:");
            $display("  opcode : 0x%02h", opcode);
            $display("  funct3 : 0x%01h", funct3);
            $display("  funct7 : 0x%02h", funct7);
            $display("  rs1    : x%0d", rs1);
            $display("  rs2    : x%0d", rs2);
            $display("  rd     : x%0d", rd);
            $display("  imm    : 0x%08h (%0d)", imm_data, $signed(imm_data));

            // Show control signals
            $display("Control Signals:");
            $display("  ALUOp       : %b", ALUOp);
            $display("  ALUSrc      : %b", ALUSrc);
            $display("  ALUOperation: %s", get_alu_op_name(ALUOperation));
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

    // Test sequence
    initial begin
        // Initialize
        clk = 0;
        rst = 1;
        
        // Release reset
        #(CLK_PERIOD*2);
        rst = 0;
        
        // Run through all instructions
        $display("\nStarting instruction decoding test...");
        for (integer i = 0; i < 16; i = i + 1) begin
            display_instruction_info(instruction, i);
            #(CLK_PERIOD);
        end
        
        // Finish simulation
        $display("\n=== Test Complete ===");
        $finish;
    end

    // Clock generation
    always #(CLK_PERIOD/2) clk = ~clk;

endmodule