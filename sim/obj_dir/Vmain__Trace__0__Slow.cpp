// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals
#include "verilated_vcd_c.h"
#include "Vmain__Syms.h"


VL_ATTR_COLD void Vmain___024root__trace_init_sub__TOP__0(Vmain___024root* vlSelf, VerilatedVcd* tracep) {
    (void)vlSelf;  // Prevent unused variable warning
    Vmain__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vmain___024root__trace_init_sub__TOP__0\n"); );
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    const int c = vlSymsp->__Vm_baseCode;
    // Body
    tracep->declBit(c+161,0,"clk",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+162,0,"reset",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+163,0,"step_en",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+164,0,"debug_pc",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+165,0,"debug_instruction",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBit(c+166,0,"debug_stall",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+167,0,"debug_flush",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->pushPrefix("main", VerilatedTracePrefixType::SCOPE_MODULE);
    tracep->declBit(c+161,0,"clk",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+162,0,"reset",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+163,0,"step_en",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+164,0,"debug_pc",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+165,0,"debug_instruction",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBit(c+166,0,"debug_stall",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+167,0,"debug_flush",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+168,0,"cpu_clk",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->pushPrefix("debug_registers_internal", VerilatedTracePrefixType::ARRAY_UNPACKED);
    for (int i = 0; i < 32; ++i) {
        tracep->declBus(c+2+i*1,0,"",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, true,(i+0), 31,0);
    }
    tracep->popPrefix();
    tracep->declBus(c+34,0,"imem_addr",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+35,0,"imem_data",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBit(c+169,0,"imem_read",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+36,0,"dmem_addr",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+37,0,"dmem_data_in",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+38,0,"dmem_data_out",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBit(c+39,0,"dmem_read",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+40,0,"dmem_write",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+41,0,"dmem_byte_enable",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 3,0);
    tracep->pushPrefix("cpu", VerilatedTracePrefixType::SCOPE_MODULE);
    tracep->declBit(c+168,0,"clk",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+162,0,"reset",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+34,0,"imem_addr",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+35,0,"imem_data",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBit(c+169,0,"imem_read",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+36,0,"dmem_addr",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+37,0,"dmem_data_in",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+38,0,"dmem_data_out",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBit(c+39,0,"dmem_read",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+40,0,"dmem_write",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+41,0,"dmem_byte_enable",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 3,0);
    tracep->declBus(c+164,0,"debug_pc",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->pushPrefix("debug_registers", VerilatedTracePrefixType::ARRAY_UNPACKED);
    for (int i = 0; i < 32; ++i) {
        tracep->declBus(c+2+i*1,0,"",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, true,(i+0), 31,0);
    }
    tracep->popPrefix();
    tracep->declBus(c+165,0,"debug_instruction",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBit(c+166,0,"debug_stall",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+167,0,"debug_flush",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+42,0,"if_id_pc",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+43,0,"if_id_instruction",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBit(c+44,0,"if_id_valid",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+45,0,"id_ex_pc",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+46,0,"id_ex_instruction",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+47,0,"id_ex_rs1_data",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+48,0,"id_ex_rs2_data",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+49,0,"id_ex_immediate",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+50,0,"id_ex_rd_addr",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+51,0,"id_ex_rs1_addr",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+52,0,"id_ex_rs2_addr",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+53,0,"id_ex_control_signals",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 19,0);
    tracep->declBit(c+54,0,"id_ex_valid",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+55,0,"ex_mem_pc",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+36,0,"ex_mem_alu_result",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+38,0,"ex_mem_rs2_data",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+56,0,"ex_mem_rd_addr",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+57,0,"ex_mem_control_signals",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 19,0);
    tracep->declBit(c+58,0,"ex_mem_valid",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+59,0,"mem_wb_pc",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+60,0,"mem_wb_alu_result",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+61,0,"mem_wb_mem_data",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+62,0,"mem_wb_rd_addr",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+63,0,"mem_wb_control_signals",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 19,0);
    tracep->declBit(c+64,0,"mem_wb_valid",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+166,0,"stall",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+65,0,"flush",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+66,0,"new_pc",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBit(c+67,0,"pc_src",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+68,0,"forward_a",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 1,0);
    tracep->declBus(c+69,0,"forward_b",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 1,0);
    tracep->declBus(c+70,0,"rs1_data",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+71,0,"rs2_data",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+72,0,"rs1_addr",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+73,0,"rs2_addr",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+74,0,"wb_data",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+75,0,"ex_mem_alu_result_fwd",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBit(c+76,0,"branch_taken",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+77,0,"branch_target",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+43,0,"instruction",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+78,0,"control_signals",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 19,0);
    tracep->pushPrefix("branch_unit", VerilatedTracePrefixType::SCOPE_MODULE);
    tracep->declBus(c+45,0,"id_ex_pc",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+46,0,"id_ex_instruction",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+47,0,"id_ex_rs1_data",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+48,0,"id_ex_rs2_data",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+49,0,"id_ex_immediate",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+53,0,"id_ex_control_signals",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 19,0);
    tracep->declBit(c+67,0,"pc_src",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+66,0,"new_pc",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBit(c+65,0,"flush",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+79,0,"is_branch",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+80,0,"funct3",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 2,0);
    tracep->declBit(c+81,0,"is_jump",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->popPrefix();
    tracep->pushPrefix("control_unit", VerilatedTracePrefixType::SCOPE_MODULE);
    tracep->declBus(c+43,0,"instruction",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+78,0,"control_signals",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 19,0);
    tracep->declBus(c+82,0,"opcode",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 6,0);
    tracep->declBus(c+83,0,"funct3",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 2,0);
    tracep->declBus(c+84,0,"funct7",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 6,0);
    tracep->declBit(c+85,0,"reg_write",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+86,0,"mem_to_reg",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+87,0,"mem_read",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+88,0,"mem_write",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+89,0,"branch",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+90,0,"jump",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+91,0,"alu_src",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+92,0,"alu_op",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 3,0);
    tracep->declBus(c+93,0,"imm_type",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 2,0);
    tracep->declBus(c+94,0,"pc_src",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 1,0);
    tracep->popPrefix();
    tracep->pushPrefix("execute", VerilatedTracePrefixType::SCOPE_MODULE);
    tracep->declBit(c+168,0,"clk",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+162,0,"reset",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+45,0,"id_ex_pc",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+46,0,"id_ex_instruction",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+47,0,"id_ex_rs1_data",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+48,0,"id_ex_rs2_data",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+49,0,"id_ex_immediate",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+50,0,"id_ex_rd_addr",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+51,0,"id_ex_rs1_addr",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+52,0,"id_ex_rs2_addr",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+53,0,"id_ex_control_signals",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 19,0);
    tracep->declBit(c+54,0,"id_ex_valid",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+68,0,"forward_a",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 1,0);
    tracep->declBus(c+69,0,"forward_b",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 1,0);
    tracep->declBus(c+60,0,"mem_wb_alu_result",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+61,0,"mem_wb_mem_data",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+55,0,"ex_mem_pc",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+36,0,"ex_mem_alu_result",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+38,0,"ex_mem_rs2_data",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+56,0,"ex_mem_rd_addr",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+57,0,"ex_mem_control_signals",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 19,0);
    tracep->declBit(c+58,0,"ex_mem_valid",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+75,0,"ex_mem_alu_result_fwd",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBit(c+76,0,"branch_taken",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+77,0,"branch_target",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBit(c+95,0,"reg_write",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+96,0,"mem_to_reg",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+97,0,"mem_read",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+98,0,"mem_write",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+79,0,"branch",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+81,0,"jump",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+99,0,"alu_src",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+100,0,"alu_op",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 3,0);
    tracep->declBus(c+101,0,"alu_input_a",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+102,0,"alu_input_b",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+101,0,"forwarded_rs1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+103,0,"forwarded_rs2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBit(c+104,0,"alu_zero",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+105,0,"pc_plus4",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+80,0,"branch_type",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 2,0);
    tracep->declBit(c+106,0,"branch_condition_met",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+75,0,"alu_result",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->pushPrefix("alu_unit", VerilatedTracePrefixType::SCOPE_MODULE);
    tracep->declBus(c+101,0,"a",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+102,0,"b",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+100,0,"alu_control",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 3,0);
    tracep->declBus(c+75,0,"result",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBit(c+104,0,"zero",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+170,0,"ALU_ADD",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 3,0);
    tracep->declBus(c+171,0,"ALU_SUB",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 3,0);
    tracep->declBus(c+172,0,"ALU_AND",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 3,0);
    tracep->declBus(c+173,0,"ALU_OR",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 3,0);
    tracep->declBus(c+174,0,"ALU_XOR",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 3,0);
    tracep->declBus(c+175,0,"ALU_SLL",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 3,0);
    tracep->declBus(c+176,0,"ALU_SRL",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 3,0);
    tracep->declBus(c+177,0,"ALU_SRA",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 3,0);
    tracep->declBus(c+178,0,"ALU_SLT",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 3,0);
    tracep->declBus(c+179,0,"ALU_SLTU",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 3,0);
    tracep->declBus(c+180,0,"ALU_LUI",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 3,0);
    tracep->popPrefix();
    tracep->popPrefix();
    tracep->pushPrefix("forwarding_unit", VerilatedTracePrefixType::SCOPE_MODULE);
    tracep->declBus(c+51,0,"id_ex_rs1_addr",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+52,0,"id_ex_rs2_addr",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+56,0,"ex_mem_rd_addr",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBit(c+107,0,"ex_mem_reg_write",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+62,0,"mem_wb_rd_addr",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBit(c+108,0,"mem_wb_reg_write",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+68,0,"forward_a",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 1,0);
    tracep->declBus(c+69,0,"forward_b",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 1,0);
    tracep->declBus(c+181,0,"NO_FORWARD",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 1,0);
    tracep->declBus(c+182,0,"FORWARD_FROM_EX",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 1,0);
    tracep->declBus(c+183,0,"FORWARD_FROM_MEM",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 1,0);
    tracep->popPrefix();
    tracep->pushPrefix("hazard_detection", VerilatedTracePrefixType::SCOPE_MODULE);
    tracep->declBus(c+72,0,"if_id_rs1_addr",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+73,0,"if_id_rs2_addr",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+50,0,"id_ex_rd_addr",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBit(c+97,0,"id_ex_mem_read",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+166,0,"stall",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->popPrefix();
    tracep->pushPrefix("instruction_decode", VerilatedTracePrefixType::SCOPE_MODULE);
    tracep->declBit(c+168,0,"clk",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+162,0,"reset",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+166,0,"stall",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+65,0,"flush",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+44,0,"if_id_valid",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+42,0,"if_id_pc",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+43,0,"if_id_instruction",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+72,0,"rs1_addr",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+73,0,"rs2_addr",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+70,0,"rs1_data",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+71,0,"rs2_data",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+62,0,"mem_wb_rd_addr",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+74,0,"mem_wb_rd_data",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBit(c+108,0,"mem_wb_reg_write",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+45,0,"id_ex_pc",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+46,0,"id_ex_instruction",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+47,0,"id_ex_rs1_data",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+48,0,"id_ex_rs2_data",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+49,0,"id_ex_immediate",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+50,0,"id_ex_rd_addr",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+51,0,"id_ex_rs1_addr",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+52,0,"id_ex_rs2_addr",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+53,0,"id_ex_control_signals",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 19,0);
    tracep->declBit(c+54,0,"id_ex_valid",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+72,0,"rs1_addr_full",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+73,0,"rs2_addr_full",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+109,0,"rd_addr_full",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+110,0,"control_signals",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 19,0);
    tracep->declBus(c+111,0,"immediate",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+112,0,"rs1_data_bypassed",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+113,0,"rs2_data_bypassed",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->pushPrefix("ctrl_unit", VerilatedTracePrefixType::SCOPE_MODULE);
    tracep->declBus(c+43,0,"instruction",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+110,0,"control_signals",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 19,0);
    tracep->declBus(c+82,0,"opcode",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 6,0);
    tracep->declBus(c+83,0,"funct3",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 2,0);
    tracep->declBus(c+84,0,"funct7",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 6,0);
    tracep->declBit(c+114,0,"reg_write",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+115,0,"mem_to_reg",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+116,0,"mem_read",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+117,0,"mem_write",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+118,0,"branch",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+119,0,"jump",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+120,0,"alu_src",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+121,0,"alu_op",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 3,0);
    tracep->declBus(c+122,0,"imm_type",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 2,0);
    tracep->declBus(c+123,0,"pc_src",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 1,0);
    tracep->popPrefix();
    tracep->pushPrefix("imm_gen", VerilatedTracePrefixType::SCOPE_MODULE);
    tracep->declBus(c+43,0,"instr",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+111,0,"imm_out",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+82,0,"opcode",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 6,0);
    tracep->popPrefix();
    tracep->popPrefix();
    tracep->pushPrefix("instruction_fetch", VerilatedTracePrefixType::SCOPE_MODULE);
    tracep->declBit(c+168,0,"clk",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+162,0,"reset",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+166,0,"stall",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+65,0,"flush",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+67,0,"pc_src",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+66,0,"new_pc",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+34,0,"imem_addr",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBit(c+169,0,"imem_read",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+35,0,"imem_data",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+42,0,"if_id_pc",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+43,0,"if_id_instruction",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBit(c+44,0,"if_id_valid",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+34,0,"pc_reg",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+124,0,"pc_next",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+34,0,"if_id_pc_next",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+35,0,"if_id_instruction_next",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBit(c+184,0,"if_id_valid_next",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->popPrefix();
    tracep->pushPrefix("memory_access", VerilatedTracePrefixType::SCOPE_MODULE);
    tracep->declBit(c+168,0,"clk",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+162,0,"reset",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+55,0,"ex_mem_pc",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+36,0,"ex_mem_alu_result",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+38,0,"ex_mem_rs2_data",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+56,0,"ex_mem_rd_addr",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+57,0,"ex_mem_control_signals",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 19,0);
    tracep->declBit(c+58,0,"ex_mem_valid",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+36,0,"dmem_addr",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+37,0,"dmem_data_in",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+38,0,"dmem_data_out",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBit(c+39,0,"dmem_read",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+40,0,"dmem_write",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+41,0,"dmem_byte_enable",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 3,0);
    tracep->declBus(c+59,0,"mem_wb_pc",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+60,0,"mem_wb_alu_result",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+61,0,"mem_wb_mem_data",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+62,0,"mem_wb_rd_addr",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+63,0,"mem_wb_control_signals",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 19,0);
    tracep->declBit(c+64,0,"mem_wb_valid",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+39,0,"mem_read_en",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+40,0,"mem_write_en",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+125,0,"mem_width",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 2,0);
    tracep->declBit(c+126,0,"mem_unsigned",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+127,0,"read_data",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->popPrefix();
    tracep->pushPrefix("reg_file", VerilatedTracePrefixType::SCOPE_MODULE);
    tracep->declBus(c+185,0,"WIDTH",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+185,0,"DEPTH",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBit(c+168,0,"clk",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+162,0,"reset",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+72,0,"rs1_addr",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+73,0,"rs2_addr",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+70,0,"rs1_data",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+71,0,"rs2_data",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+62,0,"rd_addr",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+74,0,"rd_data",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBit(c+108,0,"reg_write",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->pushPrefix("debug_registers", VerilatedTracePrefixType::ARRAY_UNPACKED);
    for (int i = 0; i < 32; ++i) {
        tracep->declBus(c+2+i*1,0,"",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, true,(i+0), 31,0);
    }
    tracep->popPrefix();
    tracep->pushPrefix("regs", VerilatedTracePrefixType::ARRAY_UNPACKED);
    for (int i = 0; i < 31; ++i) {
        tracep->declBus(c+128+i*1,0,"",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, true,(i+1), 31,0);
    }
    tracep->popPrefix();
    tracep->pushPrefix("unnamedblk1", VerilatedTracePrefixType::SCOPE_MODULE);
    tracep->declBus(c+159,0,"i",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::INT, false,-1, 31,0);
    tracep->popPrefix();
    tracep->popPrefix();
    tracep->pushPrefix("wb_stage_inst", VerilatedTracePrefixType::SCOPE_MODULE);
    tracep->declBus(c+60,0,"mem_wb_alu_result",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+61,0,"mem_wb_mem_data",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+63,0,"mem_wb_control_signals",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 19,0);
    tracep->declBus(c+74,0,"wb_data",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBit(c+160,0,"mem_to_reg",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->popPrefix();
    tracep->popPrefix();
    tracep->pushPrefix("unnamedblk1", VerilatedTracePrefixType::SCOPE_MODULE);
    tracep->declBus(c+1,0,"i",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::INTEGER, false,-1, 31,0);
    tracep->popPrefix();
    tracep->popPrefix();
}

VL_ATTR_COLD void Vmain___024root__trace_init_top(Vmain___024root* vlSelf, VerilatedVcd* tracep) {
    (void)vlSelf;  // Prevent unused variable warning
    Vmain__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vmain___024root__trace_init_top\n"); );
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    Vmain___024root__trace_init_sub__TOP__0(vlSelf, tracep);
}

VL_ATTR_COLD void Vmain___024root__trace_const_0(void* voidSelf, VerilatedVcd::Buffer* bufp);
VL_ATTR_COLD void Vmain___024root__trace_full_0(void* voidSelf, VerilatedVcd::Buffer* bufp);
void Vmain___024root__trace_chg_0(void* voidSelf, VerilatedVcd::Buffer* bufp);
void Vmain___024root__trace_cleanup(void* voidSelf, VerilatedVcd* /*unused*/);

VL_ATTR_COLD void Vmain___024root__trace_register(Vmain___024root* vlSelf, VerilatedVcd* tracep) {
    (void)vlSelf;  // Prevent unused variable warning
    Vmain__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vmain___024root__trace_register\n"); );
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    tracep->addConstCb(&Vmain___024root__trace_const_0, 0U, vlSelf);
    tracep->addFullCb(&Vmain___024root__trace_full_0, 0U, vlSelf);
    tracep->addChgCb(&Vmain___024root__trace_chg_0, 0U, vlSelf);
    tracep->addCleanupCb(&Vmain___024root__trace_cleanup, vlSelf);
}

VL_ATTR_COLD void Vmain___024root__trace_const_0_sub_0(Vmain___024root* vlSelf, VerilatedVcd::Buffer* bufp);

VL_ATTR_COLD void Vmain___024root__trace_const_0(void* voidSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vmain___024root__trace_const_0\n"); );
    // Init
    Vmain___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vmain___024root*>(voidSelf);
    Vmain__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    // Body
    Vmain___024root__trace_const_0_sub_0((&vlSymsp->TOP), bufp);
}

VL_ATTR_COLD void Vmain___024root__trace_const_0_sub_0(Vmain___024root* vlSelf, VerilatedVcd::Buffer* bufp) {
    (void)vlSelf;  // Prevent unused variable warning
    Vmain__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vmain___024root__trace_const_0_sub_0\n"); );
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    uint32_t* const oldp VL_ATTR_UNUSED = bufp->oldp(vlSymsp->__Vm_baseCode);
    // Body
    bufp->fullCData(oldp+170,(0U),4);
    bufp->fullCData(oldp+171,(1U),4);
    bufp->fullCData(oldp+172,(2U),4);
    bufp->fullCData(oldp+173,(3U),4);
    bufp->fullCData(oldp+174,(4U),4);
    bufp->fullCData(oldp+175,(5U),4);
    bufp->fullCData(oldp+176,(6U),4);
    bufp->fullCData(oldp+177,(7U),4);
    bufp->fullCData(oldp+178,(8U),4);
    bufp->fullCData(oldp+179,(9U),4);
    bufp->fullCData(oldp+180,(0xaU),4);
    bufp->fullCData(oldp+181,(0U),2);
    bufp->fullCData(oldp+182,(1U),2);
    bufp->fullCData(oldp+183,(2U),2);
    bufp->fullBit(oldp+184,(1U));
    bufp->fullIData(oldp+185,(0x20U),32);
}

VL_ATTR_COLD void Vmain___024root__trace_full_0_sub_0(Vmain___024root* vlSelf, VerilatedVcd::Buffer* bufp);

VL_ATTR_COLD void Vmain___024root__trace_full_0(void* voidSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vmain___024root__trace_full_0\n"); );
    // Init
    Vmain___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vmain___024root*>(voidSelf);
    Vmain__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    // Body
    Vmain___024root__trace_full_0_sub_0((&vlSymsp->TOP), bufp);
}

VL_ATTR_COLD void Vmain___024root__trace_full_0_sub_0(Vmain___024root* vlSelf, VerilatedVcd::Buffer* bufp) {
    (void)vlSelf;  // Prevent unused variable warning
    Vmain__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vmain___024root__trace_full_0_sub_0\n"); );
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    uint32_t* const oldp VL_ATTR_UNUSED = bufp->oldp(vlSymsp->__Vm_baseCode);
    // Body
    bufp->fullIData(oldp+1,(vlSelfRef.main__DOT__unnamedblk1__DOT__i),32);
    bufp->fullIData(oldp+2,(vlSelfRef.main__DOT__debug_registers_internal[0]),32);
    bufp->fullIData(oldp+3,(vlSelfRef.main__DOT__debug_registers_internal[1]),32);
    bufp->fullIData(oldp+4,(vlSelfRef.main__DOT__debug_registers_internal[2]),32);
    bufp->fullIData(oldp+5,(vlSelfRef.main__DOT__debug_registers_internal[3]),32);
    bufp->fullIData(oldp+6,(vlSelfRef.main__DOT__debug_registers_internal[4]),32);
    bufp->fullIData(oldp+7,(vlSelfRef.main__DOT__debug_registers_internal[5]),32);
    bufp->fullIData(oldp+8,(vlSelfRef.main__DOT__debug_registers_internal[6]),32);
    bufp->fullIData(oldp+9,(vlSelfRef.main__DOT__debug_registers_internal[7]),32);
    bufp->fullIData(oldp+10,(vlSelfRef.main__DOT__debug_registers_internal[8]),32);
    bufp->fullIData(oldp+11,(vlSelfRef.main__DOT__debug_registers_internal[9]),32);
    bufp->fullIData(oldp+12,(vlSelfRef.main__DOT__debug_registers_internal[10]),32);
    bufp->fullIData(oldp+13,(vlSelfRef.main__DOT__debug_registers_internal[11]),32);
    bufp->fullIData(oldp+14,(vlSelfRef.main__DOT__debug_registers_internal[12]),32);
    bufp->fullIData(oldp+15,(vlSelfRef.main__DOT__debug_registers_internal[13]),32);
    bufp->fullIData(oldp+16,(vlSelfRef.main__DOT__debug_registers_internal[14]),32);
    bufp->fullIData(oldp+17,(vlSelfRef.main__DOT__debug_registers_internal[15]),32);
    bufp->fullIData(oldp+18,(vlSelfRef.main__DOT__debug_registers_internal[16]),32);
    bufp->fullIData(oldp+19,(vlSelfRef.main__DOT__debug_registers_internal[17]),32);
    bufp->fullIData(oldp+20,(vlSelfRef.main__DOT__debug_registers_internal[18]),32);
    bufp->fullIData(oldp+21,(vlSelfRef.main__DOT__debug_registers_internal[19]),32);
    bufp->fullIData(oldp+22,(vlSelfRef.main__DOT__debug_registers_internal[20]),32);
    bufp->fullIData(oldp+23,(vlSelfRef.main__DOT__debug_registers_internal[21]),32);
    bufp->fullIData(oldp+24,(vlSelfRef.main__DOT__debug_registers_internal[22]),32);
    bufp->fullIData(oldp+25,(vlSelfRef.main__DOT__debug_registers_internal[23]),32);
    bufp->fullIData(oldp+26,(vlSelfRef.main__DOT__debug_registers_internal[24]),32);
    bufp->fullIData(oldp+27,(vlSelfRef.main__DOT__debug_registers_internal[25]),32);
    bufp->fullIData(oldp+28,(vlSelfRef.main__DOT__debug_registers_internal[26]),32);
    bufp->fullIData(oldp+29,(vlSelfRef.main__DOT__debug_registers_internal[27]),32);
    bufp->fullIData(oldp+30,(vlSelfRef.main__DOT__debug_registers_internal[28]),32);
    bufp->fullIData(oldp+31,(vlSelfRef.main__DOT__debug_registers_internal[29]),32);
    bufp->fullIData(oldp+32,(vlSelfRef.main__DOT__debug_registers_internal[30]),32);
    bufp->fullIData(oldp+33,(vlSelfRef.main__DOT__debug_registers_internal[31]),32);
    bufp->fullIData(oldp+34,(vlSelfRef.main__DOT__cpu__DOT__instruction_fetch__DOT__pc_reg),32);
    bufp->fullIData(oldp+35,(vlSelfRef.main__DOT__imem_internal
                             [(0xffU & (vlSelfRef.main__DOT__cpu__DOT__instruction_fetch__DOT__pc_reg 
                                        >> 2U))]),32);
    bufp->fullIData(oldp+36,(vlSelfRef.main__DOT__cpu__DOT__ex_mem_alu_result),32);
    bufp->fullIData(oldp+37,(vlSelfRef.main__DOT__dmem_data_in),32);
    bufp->fullIData(oldp+38,(vlSelfRef.main__DOT__cpu__DOT__ex_mem_rs2_data),32);
    bufp->fullBit(oldp+39,((1U & (vlSelfRef.main__DOT__cpu__DOT__ex_mem_control_signals 
                                  >> 2U))));
    bufp->fullBit(oldp+40,((1U & (vlSelfRef.main__DOT__cpu__DOT__ex_mem_control_signals 
                                  >> 3U))));
    bufp->fullCData(oldp+41,(vlSelfRef.main__DOT__dmem_byte_enable),4);
    bufp->fullIData(oldp+42,(vlSelfRef.main__DOT__cpu__DOT__if_id_pc),32);
    bufp->fullIData(oldp+43,(vlSelfRef.main__DOT__cpu__DOT__if_id_instruction),32);
    bufp->fullBit(oldp+44,(vlSelfRef.main__DOT__cpu__DOT__if_id_valid));
    bufp->fullIData(oldp+45,(vlSelfRef.main__DOT__cpu__DOT__id_ex_pc),32);
    bufp->fullIData(oldp+46,(vlSelfRef.main__DOT__cpu__DOT__id_ex_instruction),32);
    bufp->fullIData(oldp+47,(vlSelfRef.main__DOT__cpu__DOT__id_ex_rs1_data),32);
    bufp->fullIData(oldp+48,(vlSelfRef.main__DOT__cpu__DOT__id_ex_rs2_data),32);
    bufp->fullIData(oldp+49,(vlSelfRef.main__DOT__cpu__DOT__id_ex_immediate),32);
    bufp->fullCData(oldp+50,(vlSelfRef.main__DOT__cpu__DOT__id_ex_rd_addr),5);
    bufp->fullCData(oldp+51,(vlSelfRef.main__DOT__cpu__DOT__id_ex_rs1_addr),5);
    bufp->fullCData(oldp+52,(vlSelfRef.main__DOT__cpu__DOT__id_ex_rs2_addr),5);
    bufp->fullIData(oldp+53,(vlSelfRef.main__DOT__cpu__DOT__id_ex_control_signals),20);
    bufp->fullBit(oldp+54,(vlSelfRef.main__DOT__cpu__DOT__id_ex_valid));
    bufp->fullIData(oldp+55,(vlSelfRef.main__DOT__cpu__DOT__ex_mem_pc),32);
    bufp->fullCData(oldp+56,(vlSelfRef.main__DOT__cpu__DOT__ex_mem_rd_addr),5);
    bufp->fullIData(oldp+57,(vlSelfRef.main__DOT__cpu__DOT__ex_mem_control_signals),20);
    bufp->fullBit(oldp+58,(vlSelfRef.main__DOT__cpu__DOT__ex_mem_valid));
    bufp->fullIData(oldp+59,(vlSelfRef.main__DOT__cpu__DOT__mem_wb_pc),32);
    bufp->fullIData(oldp+60,(vlSelfRef.main__DOT__cpu__DOT__mem_wb_alu_result),32);
    bufp->fullIData(oldp+61,(vlSelfRef.main__DOT__cpu__DOT__mem_wb_mem_data),32);
    bufp->fullCData(oldp+62,(vlSelfRef.main__DOT__cpu__DOT__mem_wb_rd_addr),5);
    bufp->fullIData(oldp+63,(vlSelfRef.main__DOT__cpu__DOT__mem_wb_control_signals),20);
    bufp->fullBit(oldp+64,(vlSelfRef.main__DOT__cpu__DOT__mem_wb_valid));
    bufp->fullBit(oldp+65,(vlSelfRef.main__DOT__cpu__DOT__flush));
    bufp->fullIData(oldp+66,(vlSelfRef.main__DOT__cpu__DOT__new_pc),32);
    bufp->fullBit(oldp+67,(vlSelfRef.main__DOT__cpu__DOT__pc_src));
    bufp->fullCData(oldp+68,(vlSelfRef.main__DOT__cpu__DOT__forward_a),2);
    bufp->fullCData(oldp+69,(vlSelfRef.main__DOT__cpu__DOT__forward_b),2);
    bufp->fullIData(oldp+70,(((0U == (0x1fU & (vlSelfRef.main__DOT__cpu__DOT__if_id_instruction 
                                               >> 0xfU)))
                               ? 0U : (((((0x1fU & 
                                           (vlSelfRef.main__DOT__cpu__DOT__if_id_instruction 
                                            >> 0xfU)) 
                                          == (IData)(vlSelfRef.main__DOT__cpu__DOT__mem_wb_rd_addr)) 
                                         & vlSelfRef.main__DOT__cpu__DOT__mem_wb_control_signals) 
                                        & (0U != (IData)(vlSelfRef.main__DOT__cpu__DOT__mem_wb_rd_addr)))
                                        ? vlSelfRef.main__DOT__cpu__DOT__wb_data
                                        : ((0x1eU >= 
                                            (0x1fU 
                                             & ((0xfU 
                                                 & (vlSelfRef.main__DOT__cpu__DOT__if_id_instruction 
                                                    >> 0xfU)) 
                                                - (IData)(1U))))
                                            ? vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs
                                           [(0x1fU 
                                             & ((0xfU 
                                                 & (vlSelfRef.main__DOT__cpu__DOT__if_id_instruction 
                                                    >> 0xfU)) 
                                                - (IData)(1U)))]
                                            : 0U)))),32);
    bufp->fullIData(oldp+71,(((0U == (0x1fU & (vlSelfRef.main__DOT__cpu__DOT__if_id_instruction 
                                               >> 0x14U)))
                               ? 0U : (((((0x1fU & 
                                           (vlSelfRef.main__DOT__cpu__DOT__if_id_instruction 
                                            >> 0x14U)) 
                                          == (IData)(vlSelfRef.main__DOT__cpu__DOT__mem_wb_rd_addr)) 
                                         & vlSelfRef.main__DOT__cpu__DOT__mem_wb_control_signals) 
                                        & (0U != (IData)(vlSelfRef.main__DOT__cpu__DOT__mem_wb_rd_addr)))
                                        ? vlSelfRef.main__DOT__cpu__DOT__wb_data
                                        : ((0x1eU >= 
                                            (0x1fU 
                                             & ((0xfU 
                                                 & (vlSelfRef.main__DOT__cpu__DOT__if_id_instruction 
                                                    >> 0x14U)) 
                                                - (IData)(1U))))
                                            ? vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs
                                           [(0x1fU 
                                             & ((0xfU 
                                                 & (vlSelfRef.main__DOT__cpu__DOT__if_id_instruction 
                                                    >> 0x14U)) 
                                                - (IData)(1U)))]
                                            : 0U)))),32);
    bufp->fullCData(oldp+72,((0x1fU & (vlSelfRef.main__DOT__cpu__DOT__if_id_instruction 
                                       >> 0xfU))),5);
    bufp->fullCData(oldp+73,((0x1fU & (vlSelfRef.main__DOT__cpu__DOT__if_id_instruction 
                                       >> 0x14U))),5);
    bufp->fullIData(oldp+74,(vlSelfRef.main__DOT__cpu__DOT__wb_data),32);
    bufp->fullIData(oldp+75,(vlSelfRef.main__DOT__cpu__DOT__execute__DOT__alu_result),32);
    bufp->fullBit(oldp+76,((1U & ((IData)(vlSelfRef.main__DOT__cpu__DOT__execute__DOT__branch_condition_met) 
                                  | (vlSelfRef.main__DOT__cpu__DOT__id_ex_control_signals 
                                     >> 5U)))));
    bufp->fullIData(oldp+77,((vlSelfRef.main__DOT__cpu__DOT__id_ex_immediate 
                              + vlSelfRef.main__DOT__cpu__DOT__id_ex_pc)),32);
    bufp->fullIData(oldp+78,(vlSelfRef.main__DOT__cpu__DOT__control_signals),20);
    bufp->fullBit(oldp+79,((1U & (vlSelfRef.main__DOT__cpu__DOT__id_ex_control_signals 
                                  >> 4U))));
    bufp->fullCData(oldp+80,((7U & (vlSelfRef.main__DOT__cpu__DOT__id_ex_instruction 
                                    >> 0xcU))),3);
    bufp->fullBit(oldp+81,((1U & (vlSelfRef.main__DOT__cpu__DOT__id_ex_control_signals 
                                  >> 5U))));
    bufp->fullCData(oldp+82,((0x7fU & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)),7);
    bufp->fullCData(oldp+83,((7U & (vlSelfRef.main__DOT__cpu__DOT__if_id_instruction 
                                    >> 0xcU))),3);
    bufp->fullCData(oldp+84,((vlSelfRef.main__DOT__cpu__DOT__if_id_instruction 
                              >> 0x19U)),7);
    bufp->fullBit(oldp+85,(vlSelfRef.main__DOT__cpu__DOT__control_unit__DOT__reg_write));
    bufp->fullBit(oldp+86,(vlSelfRef.main__DOT__cpu__DOT__control_unit__DOT__mem_to_reg));
    bufp->fullBit(oldp+87,(vlSelfRef.main__DOT__cpu__DOT__control_unit__DOT__mem_read));
    bufp->fullBit(oldp+88,(vlSelfRef.main__DOT__cpu__DOT__control_unit__DOT__mem_write));
    bufp->fullBit(oldp+89,(vlSelfRef.main__DOT__cpu__DOT__control_unit__DOT__branch));
    bufp->fullBit(oldp+90,(vlSelfRef.main__DOT__cpu__DOT__control_unit__DOT__jump));
    bufp->fullBit(oldp+91,(vlSelfRef.main__DOT__cpu__DOT__control_unit__DOT__alu_src));
    bufp->fullCData(oldp+92,(vlSelfRef.main__DOT__cpu__DOT__control_unit__DOT__alu_op),4);
    bufp->fullCData(oldp+93,(vlSelfRef.main__DOT__cpu__DOT__control_unit__DOT__imm_type),3);
    bufp->fullCData(oldp+94,(vlSelfRef.main__DOT__cpu__DOT__control_unit__DOT__pc_src),2);
    bufp->fullBit(oldp+95,((1U & vlSelfRef.main__DOT__cpu__DOT__id_ex_control_signals)));
    bufp->fullBit(oldp+96,((1U & (vlSelfRef.main__DOT__cpu__DOT__id_ex_control_signals 
                                  >> 1U))));
    bufp->fullBit(oldp+97,((1U & (vlSelfRef.main__DOT__cpu__DOT__id_ex_control_signals 
                                  >> 2U))));
    bufp->fullBit(oldp+98,((1U & (vlSelfRef.main__DOT__cpu__DOT__id_ex_control_signals 
                                  >> 3U))));
    bufp->fullBit(oldp+99,((1U & (vlSelfRef.main__DOT__cpu__DOT__id_ex_control_signals 
                                  >> 6U))));
    bufp->fullCData(oldp+100,((0xfU & (vlSelfRef.main__DOT__cpu__DOT__id_ex_control_signals 
                                       >> 7U))),4);
    bufp->fullIData(oldp+101,(vlSelfRef.main__DOT__cpu__DOT__execute__DOT__forwarded_rs1),32);
    bufp->fullIData(oldp+102,(vlSelfRef.main__DOT__cpu__DOT__execute__DOT__alu_input_b),32);
    bufp->fullIData(oldp+103,(vlSelfRef.main__DOT__cpu__DOT__execute__DOT__forwarded_rs2),32);
    bufp->fullBit(oldp+104,((0U == vlSelfRef.main__DOT__cpu__DOT__execute__DOT__alu_result)));
    bufp->fullIData(oldp+105,(((IData)(4U) + vlSelfRef.main__DOT__cpu__DOT__id_ex_pc)),32);
    bufp->fullBit(oldp+106,(vlSelfRef.main__DOT__cpu__DOT__execute__DOT__branch_condition_met));
    bufp->fullBit(oldp+107,((1U & vlSelfRef.main__DOT__cpu__DOT__ex_mem_control_signals)));
    bufp->fullBit(oldp+108,((1U & vlSelfRef.main__DOT__cpu__DOT__mem_wb_control_signals)));
    bufp->fullCData(oldp+109,((0x1fU & (vlSelfRef.main__DOT__cpu__DOT__if_id_instruction 
                                        >> 7U))),5);
    bufp->fullIData(oldp+110,(vlSelfRef.main__DOT__cpu__DOT__instruction_decode__DOT__control_signals),20);
    bufp->fullIData(oldp+111,(vlSelfRef.main__DOT__cpu__DOT__instruction_decode__DOT__immediate),32);
    bufp->fullIData(oldp+112,(((vlSelfRef.main__DOT__cpu__DOT__mem_wb_control_signals 
                                & (((IData)(vlSelfRef.main__DOT__cpu__DOT__mem_wb_rd_addr) 
                                    == (0x1fU & (vlSelfRef.main__DOT__cpu__DOT__if_id_instruction 
                                                 >> 0xfU))) 
                                   & (0U != (0x1fU 
                                             & (vlSelfRef.main__DOT__cpu__DOT__if_id_instruction 
                                                >> 0xfU)))))
                                ? vlSelfRef.main__DOT__cpu__DOT__wb_data
                                : ((0U == (0x1fU & 
                                           (vlSelfRef.main__DOT__cpu__DOT__if_id_instruction 
                                            >> 0xfU)))
                                    ? 0U : (((((0x1fU 
                                                & (vlSelfRef.main__DOT__cpu__DOT__if_id_instruction 
                                                   >> 0xfU)) 
                                               == (IData)(vlSelfRef.main__DOT__cpu__DOT__mem_wb_rd_addr)) 
                                              & vlSelfRef.main__DOT__cpu__DOT__mem_wb_control_signals) 
                                             & (0U 
                                                != (IData)(vlSelfRef.main__DOT__cpu__DOT__mem_wb_rd_addr)))
                                             ? vlSelfRef.main__DOT__cpu__DOT__wb_data
                                             : ((0x1eU 
                                                 >= 
                                                 (0x1fU 
                                                  & ((0xfU 
                                                      & (vlSelfRef.main__DOT__cpu__DOT__if_id_instruction 
                                                         >> 0xfU)) 
                                                     - (IData)(1U))))
                                                 ? 
                                                vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs
                                                [(0x1fU 
                                                  & ((0xfU 
                                                      & (vlSelfRef.main__DOT__cpu__DOT__if_id_instruction 
                                                         >> 0xfU)) 
                                                     - (IData)(1U)))]
                                                 : 0U))))),32);
    bufp->fullIData(oldp+113,(((vlSelfRef.main__DOT__cpu__DOT__mem_wb_control_signals 
                                & (((IData)(vlSelfRef.main__DOT__cpu__DOT__mem_wb_rd_addr) 
                                    == (0x1fU & (vlSelfRef.main__DOT__cpu__DOT__if_id_instruction 
                                                 >> 0x14U))) 
                                   & (0U != (0x1fU 
                                             & (vlSelfRef.main__DOT__cpu__DOT__if_id_instruction 
                                                >> 0x14U)))))
                                ? vlSelfRef.main__DOT__cpu__DOT__wb_data
                                : ((0U == (0x1fU & 
                                           (vlSelfRef.main__DOT__cpu__DOT__if_id_instruction 
                                            >> 0x14U)))
                                    ? 0U : (((((0x1fU 
                                                & (vlSelfRef.main__DOT__cpu__DOT__if_id_instruction 
                                                   >> 0x14U)) 
                                               == (IData)(vlSelfRef.main__DOT__cpu__DOT__mem_wb_rd_addr)) 
                                              & vlSelfRef.main__DOT__cpu__DOT__mem_wb_control_signals) 
                                             & (0U 
                                                != (IData)(vlSelfRef.main__DOT__cpu__DOT__mem_wb_rd_addr)))
                                             ? vlSelfRef.main__DOT__cpu__DOT__wb_data
                                             : ((0x1eU 
                                                 >= 
                                                 (0x1fU 
                                                  & ((0xfU 
                                                      & (vlSelfRef.main__DOT__cpu__DOT__if_id_instruction 
                                                         >> 0x14U)) 
                                                     - (IData)(1U))))
                                                 ? 
                                                vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs
                                                [(0x1fU 
                                                  & ((0xfU 
                                                      & (vlSelfRef.main__DOT__cpu__DOT__if_id_instruction 
                                                         >> 0x14U)) 
                                                     - (IData)(1U)))]
                                                 : 0U))))),32);
    bufp->fullBit(oldp+114,(vlSelfRef.main__DOT__cpu__DOT__instruction_decode__DOT__ctrl_unit__DOT__reg_write));
    bufp->fullBit(oldp+115,(vlSelfRef.main__DOT__cpu__DOT__instruction_decode__DOT__ctrl_unit__DOT__mem_to_reg));
    bufp->fullBit(oldp+116,(vlSelfRef.main__DOT__cpu__DOT__instruction_decode__DOT__ctrl_unit__DOT__mem_read));
    bufp->fullBit(oldp+117,(vlSelfRef.main__DOT__cpu__DOT__instruction_decode__DOT__ctrl_unit__DOT__mem_write));
    bufp->fullBit(oldp+118,(vlSelfRef.main__DOT__cpu__DOT__instruction_decode__DOT__ctrl_unit__DOT__branch));
    bufp->fullBit(oldp+119,(vlSelfRef.main__DOT__cpu__DOT__instruction_decode__DOT__ctrl_unit__DOT__jump));
    bufp->fullBit(oldp+120,(vlSelfRef.main__DOT__cpu__DOT__instruction_decode__DOT__ctrl_unit__DOT__alu_src));
    bufp->fullCData(oldp+121,(vlSelfRef.main__DOT__cpu__DOT__instruction_decode__DOT__ctrl_unit__DOT__alu_op),4);
    bufp->fullCData(oldp+122,(vlSelfRef.main__DOT__cpu__DOT__instruction_decode__DOT__ctrl_unit__DOT__imm_type),3);
    bufp->fullCData(oldp+123,(vlSelfRef.main__DOT__cpu__DOT__instruction_decode__DOT__ctrl_unit__DOT__pc_src),2);
    bufp->fullIData(oldp+124,(((IData)(vlSelfRef.main__DOT__cpu__DOT__pc_src)
                                ? vlSelfRef.main__DOT__cpu__DOT__new_pc
                                : ((IData)(4U) + vlSelfRef.main__DOT__cpu__DOT__instruction_fetch__DOT__pc_reg))),32);
    bufp->fullCData(oldp+125,((7U & (vlSelfRef.main__DOT__cpu__DOT__ex_mem_control_signals 
                                     >> 0xcU))),3);
    bufp->fullBit(oldp+126,((1U & (vlSelfRef.main__DOT__cpu__DOT__ex_mem_control_signals 
                                   >> 0xfU))));
    bufp->fullIData(oldp+127,(vlSelfRef.main__DOT__cpu__DOT__memory_access__DOT__read_data),32);
    bufp->fullIData(oldp+128,(vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs[0]),32);
    bufp->fullIData(oldp+129,(vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs[1]),32);
    bufp->fullIData(oldp+130,(vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs[2]),32);
    bufp->fullIData(oldp+131,(vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs[3]),32);
    bufp->fullIData(oldp+132,(vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs[4]),32);
    bufp->fullIData(oldp+133,(vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs[5]),32);
    bufp->fullIData(oldp+134,(vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs[6]),32);
    bufp->fullIData(oldp+135,(vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs[7]),32);
    bufp->fullIData(oldp+136,(vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs[8]),32);
    bufp->fullIData(oldp+137,(vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs[9]),32);
    bufp->fullIData(oldp+138,(vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs[10]),32);
    bufp->fullIData(oldp+139,(vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs[11]),32);
    bufp->fullIData(oldp+140,(vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs[12]),32);
    bufp->fullIData(oldp+141,(vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs[13]),32);
    bufp->fullIData(oldp+142,(vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs[14]),32);
    bufp->fullIData(oldp+143,(vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs[15]),32);
    bufp->fullIData(oldp+144,(vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs[16]),32);
    bufp->fullIData(oldp+145,(vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs[17]),32);
    bufp->fullIData(oldp+146,(vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs[18]),32);
    bufp->fullIData(oldp+147,(vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs[19]),32);
    bufp->fullIData(oldp+148,(vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs[20]),32);
    bufp->fullIData(oldp+149,(vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs[21]),32);
    bufp->fullIData(oldp+150,(vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs[22]),32);
    bufp->fullIData(oldp+151,(vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs[23]),32);
    bufp->fullIData(oldp+152,(vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs[24]),32);
    bufp->fullIData(oldp+153,(vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs[25]),32);
    bufp->fullIData(oldp+154,(vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs[26]),32);
    bufp->fullIData(oldp+155,(vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs[27]),32);
    bufp->fullIData(oldp+156,(vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs[28]),32);
    bufp->fullIData(oldp+157,(vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs[29]),32);
    bufp->fullIData(oldp+158,(vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs[30]),32);
    bufp->fullIData(oldp+159,(vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__unnamedblk1__DOT__i),32);
    bufp->fullBit(oldp+160,((1U & (vlSelfRef.main__DOT__cpu__DOT__mem_wb_control_signals 
                                   >> 1U))));
    bufp->fullBit(oldp+161,(vlSelfRef.clk));
    bufp->fullBit(oldp+162,(vlSelfRef.reset));
    bufp->fullBit(oldp+163,(vlSelfRef.step_en));
    bufp->fullIData(oldp+164,(vlSelfRef.debug_pc),32);
    bufp->fullIData(oldp+165,(vlSelfRef.debug_instruction),32);
    bufp->fullBit(oldp+166,(vlSelfRef.debug_stall));
    bufp->fullBit(oldp+167,(vlSelfRef.debug_flush));
    bufp->fullBit(oldp+168,(vlSelfRef.main__DOT__cpu_clk));
    bufp->fullBit(oldp+169,((1U & (~ (IData)(vlSelfRef.debug_stall)))));
}
