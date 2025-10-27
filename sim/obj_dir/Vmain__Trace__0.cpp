// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals
#include "verilated_vcd_c.h"
#include "Vmain__Syms.h"


void Vmain___024root__trace_chg_0_sub_0(Vmain___024root* vlSelf, VerilatedVcd::Buffer* bufp);

void Vmain___024root__trace_chg_0(void* voidSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vmain___024root__trace_chg_0\n"); );
    // Init
    Vmain___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vmain___024root*>(voidSelf);
    Vmain__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    if (VL_UNLIKELY(!vlSymsp->__Vm_activity)) return;
    // Body
    Vmain___024root__trace_chg_0_sub_0((&vlSymsp->TOP), bufp);
}

void Vmain___024root__trace_chg_0_sub_0(Vmain___024root* vlSelf, VerilatedVcd::Buffer* bufp) {
    (void)vlSelf;  // Prevent unused variable warning
    Vmain__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vmain___024root__trace_chg_0_sub_0\n"); );
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    uint32_t* const oldp VL_ATTR_UNUSED = bufp->oldp(vlSymsp->__Vm_baseCode + 1);
    // Body
    if (VL_UNLIKELY(vlSelfRef.__Vm_traceActivity[0U])) {
        bufp->chgIData(oldp+0,(vlSelfRef.main__DOT__unnamedblk1__DOT__i),32);
    }
    if (VL_UNLIKELY(vlSelfRef.__Vm_traceActivity[1U])) {
        bufp->chgIData(oldp+1,(vlSelfRef.main__DOT__debug_registers_internal[0]),32);
        bufp->chgIData(oldp+2,(vlSelfRef.main__DOT__debug_registers_internal[1]),32);
        bufp->chgIData(oldp+3,(vlSelfRef.main__DOT__debug_registers_internal[2]),32);
        bufp->chgIData(oldp+4,(vlSelfRef.main__DOT__debug_registers_internal[3]),32);
        bufp->chgIData(oldp+5,(vlSelfRef.main__DOT__debug_registers_internal[4]),32);
        bufp->chgIData(oldp+6,(vlSelfRef.main__DOT__debug_registers_internal[5]),32);
        bufp->chgIData(oldp+7,(vlSelfRef.main__DOT__debug_registers_internal[6]),32);
        bufp->chgIData(oldp+8,(vlSelfRef.main__DOT__debug_registers_internal[7]),32);
        bufp->chgIData(oldp+9,(vlSelfRef.main__DOT__debug_registers_internal[8]),32);
        bufp->chgIData(oldp+10,(vlSelfRef.main__DOT__debug_registers_internal[9]),32);
        bufp->chgIData(oldp+11,(vlSelfRef.main__DOT__debug_registers_internal[10]),32);
        bufp->chgIData(oldp+12,(vlSelfRef.main__DOT__debug_registers_internal[11]),32);
        bufp->chgIData(oldp+13,(vlSelfRef.main__DOT__debug_registers_internal[12]),32);
        bufp->chgIData(oldp+14,(vlSelfRef.main__DOT__debug_registers_internal[13]),32);
        bufp->chgIData(oldp+15,(vlSelfRef.main__DOT__debug_registers_internal[14]),32);
        bufp->chgIData(oldp+16,(vlSelfRef.main__DOT__debug_registers_internal[15]),32);
        bufp->chgIData(oldp+17,(vlSelfRef.main__DOT__debug_registers_internal[16]),32);
        bufp->chgIData(oldp+18,(vlSelfRef.main__DOT__debug_registers_internal[17]),32);
        bufp->chgIData(oldp+19,(vlSelfRef.main__DOT__debug_registers_internal[18]),32);
        bufp->chgIData(oldp+20,(vlSelfRef.main__DOT__debug_registers_internal[19]),32);
        bufp->chgIData(oldp+21,(vlSelfRef.main__DOT__debug_registers_internal[20]),32);
        bufp->chgIData(oldp+22,(vlSelfRef.main__DOT__debug_registers_internal[21]),32);
        bufp->chgIData(oldp+23,(vlSelfRef.main__DOT__debug_registers_internal[22]),32);
        bufp->chgIData(oldp+24,(vlSelfRef.main__DOT__debug_registers_internal[23]),32);
        bufp->chgIData(oldp+25,(vlSelfRef.main__DOT__debug_registers_internal[24]),32);
        bufp->chgIData(oldp+26,(vlSelfRef.main__DOT__debug_registers_internal[25]),32);
        bufp->chgIData(oldp+27,(vlSelfRef.main__DOT__debug_registers_internal[26]),32);
        bufp->chgIData(oldp+28,(vlSelfRef.main__DOT__debug_registers_internal[27]),32);
        bufp->chgIData(oldp+29,(vlSelfRef.main__DOT__debug_registers_internal[28]),32);
        bufp->chgIData(oldp+30,(vlSelfRef.main__DOT__debug_registers_internal[29]),32);
        bufp->chgIData(oldp+31,(vlSelfRef.main__DOT__debug_registers_internal[30]),32);
        bufp->chgIData(oldp+32,(vlSelfRef.main__DOT__debug_registers_internal[31]),32);
        bufp->chgIData(oldp+33,(vlSelfRef.main__DOT__cpu__DOT__instruction_fetch__DOT__pc_reg),32);
        bufp->chgIData(oldp+34,(vlSelfRef.main__DOT__imem_internal
                                [(0xffU & (vlSelfRef.main__DOT__cpu__DOT__instruction_fetch__DOT__pc_reg 
                                           >> 2U))]),32);
        bufp->chgIData(oldp+35,(vlSelfRef.main__DOT__cpu__DOT__ex_mem_alu_result),32);
        bufp->chgIData(oldp+36,(vlSelfRef.main__DOT__dmem_data_in),32);
        bufp->chgIData(oldp+37,(vlSelfRef.main__DOT__cpu__DOT__ex_mem_rs2_data),32);
        bufp->chgBit(oldp+38,((1U & (vlSelfRef.main__DOT__cpu__DOT__ex_mem_control_signals 
                                     >> 2U))));
        bufp->chgBit(oldp+39,((1U & (vlSelfRef.main__DOT__cpu__DOT__ex_mem_control_signals 
                                     >> 3U))));
        bufp->chgCData(oldp+40,(vlSelfRef.main__DOT__dmem_byte_enable),4);
        bufp->chgIData(oldp+41,(vlSelfRef.main__DOT__cpu__DOT__if_id_pc),32);
        bufp->chgIData(oldp+42,(vlSelfRef.main__DOT__cpu__DOT__if_id_instruction),32);
        bufp->chgBit(oldp+43,(vlSelfRef.main__DOT__cpu__DOT__if_id_valid));
        bufp->chgIData(oldp+44,(vlSelfRef.main__DOT__cpu__DOT__id_ex_pc),32);
        bufp->chgIData(oldp+45,(vlSelfRef.main__DOT__cpu__DOT__id_ex_instruction),32);
        bufp->chgIData(oldp+46,(vlSelfRef.main__DOT__cpu__DOT__id_ex_rs1_data),32);
        bufp->chgIData(oldp+47,(vlSelfRef.main__DOT__cpu__DOT__id_ex_rs2_data),32);
        bufp->chgIData(oldp+48,(vlSelfRef.main__DOT__cpu__DOT__id_ex_immediate),32);
        bufp->chgCData(oldp+49,(vlSelfRef.main__DOT__cpu__DOT__id_ex_rd_addr),5);
        bufp->chgCData(oldp+50,(vlSelfRef.main__DOT__cpu__DOT__id_ex_rs1_addr),5);
        bufp->chgCData(oldp+51,(vlSelfRef.main__DOT__cpu__DOT__id_ex_rs2_addr),5);
        bufp->chgIData(oldp+52,(vlSelfRef.main__DOT__cpu__DOT__id_ex_control_signals),20);
        bufp->chgBit(oldp+53,(vlSelfRef.main__DOT__cpu__DOT__id_ex_valid));
        bufp->chgIData(oldp+54,(vlSelfRef.main__DOT__cpu__DOT__ex_mem_pc),32);
        bufp->chgCData(oldp+55,(vlSelfRef.main__DOT__cpu__DOT__ex_mem_rd_addr),5);
        bufp->chgIData(oldp+56,(vlSelfRef.main__DOT__cpu__DOT__ex_mem_control_signals),20);
        bufp->chgBit(oldp+57,(vlSelfRef.main__DOT__cpu__DOT__ex_mem_valid));
        bufp->chgIData(oldp+58,(vlSelfRef.main__DOT__cpu__DOT__mem_wb_pc),32);
        bufp->chgIData(oldp+59,(vlSelfRef.main__DOT__cpu__DOT__mem_wb_alu_result),32);
        bufp->chgIData(oldp+60,(vlSelfRef.main__DOT__cpu__DOT__mem_wb_mem_data),32);
        bufp->chgCData(oldp+61,(vlSelfRef.main__DOT__cpu__DOT__mem_wb_rd_addr),5);
        bufp->chgIData(oldp+62,(vlSelfRef.main__DOT__cpu__DOT__mem_wb_control_signals),20);
        bufp->chgBit(oldp+63,(vlSelfRef.main__DOT__cpu__DOT__mem_wb_valid));
        bufp->chgBit(oldp+64,(vlSelfRef.main__DOT__cpu__DOT__flush));
        bufp->chgIData(oldp+65,(vlSelfRef.main__DOT__cpu__DOT__new_pc),32);
        bufp->chgBit(oldp+66,(vlSelfRef.main__DOT__cpu__DOT__pc_src));
        bufp->chgCData(oldp+67,(vlSelfRef.main__DOT__cpu__DOT__forward_a),2);
        bufp->chgCData(oldp+68,(vlSelfRef.main__DOT__cpu__DOT__forward_b),2);
        bufp->chgIData(oldp+69,(((0U == (0x1fU & (vlSelfRef.main__DOT__cpu__DOT__if_id_instruction 
                                                  >> 0xfU)))
                                  ? 0U : (((((0x1fU 
                                              & (vlSelfRef.main__DOT__cpu__DOT__if_id_instruction 
                                                 >> 0xfU)) 
                                             == (IData)(vlSelfRef.main__DOT__cpu__DOT__mem_wb_rd_addr)) 
                                            & vlSelfRef.main__DOT__cpu__DOT__mem_wb_control_signals) 
                                           & (0U != (IData)(vlSelfRef.main__DOT__cpu__DOT__mem_wb_rd_addr)))
                                           ? vlSelfRef.main__DOT__cpu__DOT__wb_data
                                           : ((0x1eU 
                                               >= (0x1fU 
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
        bufp->chgIData(oldp+70,(((0U == (0x1fU & (vlSelfRef.main__DOT__cpu__DOT__if_id_instruction 
                                                  >> 0x14U)))
                                  ? 0U : (((((0x1fU 
                                              & (vlSelfRef.main__DOT__cpu__DOT__if_id_instruction 
                                                 >> 0x14U)) 
                                             == (IData)(vlSelfRef.main__DOT__cpu__DOT__mem_wb_rd_addr)) 
                                            & vlSelfRef.main__DOT__cpu__DOT__mem_wb_control_signals) 
                                           & (0U != (IData)(vlSelfRef.main__DOT__cpu__DOT__mem_wb_rd_addr)))
                                           ? vlSelfRef.main__DOT__cpu__DOT__wb_data
                                           : ((0x1eU 
                                               >= (0x1fU 
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
        bufp->chgCData(oldp+71,((0x1fU & (vlSelfRef.main__DOT__cpu__DOT__if_id_instruction 
                                          >> 0xfU))),5);
        bufp->chgCData(oldp+72,((0x1fU & (vlSelfRef.main__DOT__cpu__DOT__if_id_instruction 
                                          >> 0x14U))),5);
        bufp->chgIData(oldp+73,(vlSelfRef.main__DOT__cpu__DOT__wb_data),32);
        bufp->chgIData(oldp+74,(vlSelfRef.main__DOT__cpu__DOT__execute__DOT__alu_result),32);
        bufp->chgBit(oldp+75,((1U & ((IData)(vlSelfRef.main__DOT__cpu__DOT__execute__DOT__branch_condition_met) 
                                     | (vlSelfRef.main__DOT__cpu__DOT__id_ex_control_signals 
                                        >> 5U)))));
        bufp->chgIData(oldp+76,((vlSelfRef.main__DOT__cpu__DOT__id_ex_immediate 
                                 + vlSelfRef.main__DOT__cpu__DOT__id_ex_pc)),32);
        bufp->chgIData(oldp+77,(vlSelfRef.main__DOT__cpu__DOT__control_signals),20);
        bufp->chgBit(oldp+78,((1U & (vlSelfRef.main__DOT__cpu__DOT__id_ex_control_signals 
                                     >> 4U))));
        bufp->chgCData(oldp+79,((7U & (vlSelfRef.main__DOT__cpu__DOT__id_ex_instruction 
                                       >> 0xcU))),3);
        bufp->chgBit(oldp+80,((1U & (vlSelfRef.main__DOT__cpu__DOT__id_ex_control_signals 
                                     >> 5U))));
        bufp->chgCData(oldp+81,((0x7fU & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)),7);
        bufp->chgCData(oldp+82,((7U & (vlSelfRef.main__DOT__cpu__DOT__if_id_instruction 
                                       >> 0xcU))),3);
        bufp->chgCData(oldp+83,((vlSelfRef.main__DOT__cpu__DOT__if_id_instruction 
                                 >> 0x19U)),7);
        bufp->chgBit(oldp+84,(vlSelfRef.main__DOT__cpu__DOT__control_unit__DOT__reg_write));
        bufp->chgBit(oldp+85,(vlSelfRef.main__DOT__cpu__DOT__control_unit__DOT__mem_to_reg));
        bufp->chgBit(oldp+86,(vlSelfRef.main__DOT__cpu__DOT__control_unit__DOT__mem_read));
        bufp->chgBit(oldp+87,(vlSelfRef.main__DOT__cpu__DOT__control_unit__DOT__mem_write));
        bufp->chgBit(oldp+88,(vlSelfRef.main__DOT__cpu__DOT__control_unit__DOT__branch));
        bufp->chgBit(oldp+89,(vlSelfRef.main__DOT__cpu__DOT__control_unit__DOT__jump));
        bufp->chgBit(oldp+90,(vlSelfRef.main__DOT__cpu__DOT__control_unit__DOT__alu_src));
        bufp->chgCData(oldp+91,(vlSelfRef.main__DOT__cpu__DOT__control_unit__DOT__alu_op),4);
        bufp->chgCData(oldp+92,(vlSelfRef.main__DOT__cpu__DOT__control_unit__DOT__imm_type),3);
        bufp->chgCData(oldp+93,(vlSelfRef.main__DOT__cpu__DOT__control_unit__DOT__pc_src),2);
        bufp->chgBit(oldp+94,((1U & vlSelfRef.main__DOT__cpu__DOT__id_ex_control_signals)));
        bufp->chgBit(oldp+95,((1U & (vlSelfRef.main__DOT__cpu__DOT__id_ex_control_signals 
                                     >> 1U))));
        bufp->chgBit(oldp+96,((1U & (vlSelfRef.main__DOT__cpu__DOT__id_ex_control_signals 
                                     >> 2U))));
        bufp->chgBit(oldp+97,((1U & (vlSelfRef.main__DOT__cpu__DOT__id_ex_control_signals 
                                     >> 3U))));
        bufp->chgBit(oldp+98,((1U & (vlSelfRef.main__DOT__cpu__DOT__id_ex_control_signals 
                                     >> 6U))));
        bufp->chgCData(oldp+99,((0xfU & (vlSelfRef.main__DOT__cpu__DOT__id_ex_control_signals 
                                         >> 7U))),4);
        bufp->chgIData(oldp+100,(vlSelfRef.main__DOT__cpu__DOT__execute__DOT__forwarded_rs1),32);
        bufp->chgIData(oldp+101,(vlSelfRef.main__DOT__cpu__DOT__execute__DOT__alu_input_b),32);
        bufp->chgIData(oldp+102,(vlSelfRef.main__DOT__cpu__DOT__execute__DOT__forwarded_rs2),32);
        bufp->chgBit(oldp+103,((0U == vlSelfRef.main__DOT__cpu__DOT__execute__DOT__alu_result)));
        bufp->chgIData(oldp+104,(((IData)(4U) + vlSelfRef.main__DOT__cpu__DOT__id_ex_pc)),32);
        bufp->chgBit(oldp+105,(vlSelfRef.main__DOT__cpu__DOT__execute__DOT__branch_condition_met));
        bufp->chgBit(oldp+106,((1U & vlSelfRef.main__DOT__cpu__DOT__ex_mem_control_signals)));
        bufp->chgBit(oldp+107,((1U & vlSelfRef.main__DOT__cpu__DOT__mem_wb_control_signals)));
        bufp->chgCData(oldp+108,((0x1fU & (vlSelfRef.main__DOT__cpu__DOT__if_id_instruction 
                                           >> 7U))),5);
        bufp->chgIData(oldp+109,(vlSelfRef.main__DOT__cpu__DOT__instruction_decode__DOT__control_signals),20);
        bufp->chgIData(oldp+110,(vlSelfRef.main__DOT__cpu__DOT__instruction_decode__DOT__immediate),32);
        bufp->chgIData(oldp+111,(((vlSelfRef.main__DOT__cpu__DOT__mem_wb_control_signals 
                                   & (((IData)(vlSelfRef.main__DOT__cpu__DOT__mem_wb_rd_addr) 
                                       == (0x1fU & 
                                           (vlSelfRef.main__DOT__cpu__DOT__if_id_instruction 
                                            >> 0xfU))) 
                                      & (0U != (0x1fU 
                                                & (vlSelfRef.main__DOT__cpu__DOT__if_id_instruction 
                                                   >> 0xfU)))))
                                   ? vlSelfRef.main__DOT__cpu__DOT__wb_data
                                   : ((0U == (0x1fU 
                                              & (vlSelfRef.main__DOT__cpu__DOT__if_id_instruction 
                                                 >> 0xfU)))
                                       ? 0U : (((((0x1fU 
                                                   & (vlSelfRef.main__DOT__cpu__DOT__if_id_instruction 
                                                      >> 0xfU)) 
                                                  == (IData)(vlSelfRef.main__DOT__cpu__DOT__mem_wb_rd_addr)) 
                                                 & vlSelfRef.main__DOT__cpu__DOT__mem_wb_control_signals) 
                                                & (0U 
                                                   != (IData)(vlSelfRef.main__DOT__cpu__DOT__mem_wb_rd_addr)))
                                                ? vlSelfRef.main__DOT__cpu__DOT__wb_data
                                                : (
                                                   (0x1eU 
                                                    >= 
                                                    (0x1fU 
                                                     & ((0xfU 
                                                         & (vlSelfRef.main__DOT__cpu__DOT__if_id_instruction 
                                                            >> 0xfU)) 
                                                        - (IData)(1U))))
                                                    ? 
                                                   vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs
                                                   [
                                                   (0x1fU 
                                                    & ((0xfU 
                                                        & (vlSelfRef.main__DOT__cpu__DOT__if_id_instruction 
                                                           >> 0xfU)) 
                                                       - (IData)(1U)))]
                                                    : 0U))))),32);
        bufp->chgIData(oldp+112,(((vlSelfRef.main__DOT__cpu__DOT__mem_wb_control_signals 
                                   & (((IData)(vlSelfRef.main__DOT__cpu__DOT__mem_wb_rd_addr) 
                                       == (0x1fU & 
                                           (vlSelfRef.main__DOT__cpu__DOT__if_id_instruction 
                                            >> 0x14U))) 
                                      & (0U != (0x1fU 
                                                & (vlSelfRef.main__DOT__cpu__DOT__if_id_instruction 
                                                   >> 0x14U)))))
                                   ? vlSelfRef.main__DOT__cpu__DOT__wb_data
                                   : ((0U == (0x1fU 
                                              & (vlSelfRef.main__DOT__cpu__DOT__if_id_instruction 
                                                 >> 0x14U)))
                                       ? 0U : (((((0x1fU 
                                                   & (vlSelfRef.main__DOT__cpu__DOT__if_id_instruction 
                                                      >> 0x14U)) 
                                                  == (IData)(vlSelfRef.main__DOT__cpu__DOT__mem_wb_rd_addr)) 
                                                 & vlSelfRef.main__DOT__cpu__DOT__mem_wb_control_signals) 
                                                & (0U 
                                                   != (IData)(vlSelfRef.main__DOT__cpu__DOT__mem_wb_rd_addr)))
                                                ? vlSelfRef.main__DOT__cpu__DOT__wb_data
                                                : (
                                                   (0x1eU 
                                                    >= 
                                                    (0x1fU 
                                                     & ((0xfU 
                                                         & (vlSelfRef.main__DOT__cpu__DOT__if_id_instruction 
                                                            >> 0x14U)) 
                                                        - (IData)(1U))))
                                                    ? 
                                                   vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs
                                                   [
                                                   (0x1fU 
                                                    & ((0xfU 
                                                        & (vlSelfRef.main__DOT__cpu__DOT__if_id_instruction 
                                                           >> 0x14U)) 
                                                       - (IData)(1U)))]
                                                    : 0U))))),32);
        bufp->chgBit(oldp+113,(vlSelfRef.main__DOT__cpu__DOT__instruction_decode__DOT__ctrl_unit__DOT__reg_write));
        bufp->chgBit(oldp+114,(vlSelfRef.main__DOT__cpu__DOT__instruction_decode__DOT__ctrl_unit__DOT__mem_to_reg));
        bufp->chgBit(oldp+115,(vlSelfRef.main__DOT__cpu__DOT__instruction_decode__DOT__ctrl_unit__DOT__mem_read));
        bufp->chgBit(oldp+116,(vlSelfRef.main__DOT__cpu__DOT__instruction_decode__DOT__ctrl_unit__DOT__mem_write));
        bufp->chgBit(oldp+117,(vlSelfRef.main__DOT__cpu__DOT__instruction_decode__DOT__ctrl_unit__DOT__branch));
        bufp->chgBit(oldp+118,(vlSelfRef.main__DOT__cpu__DOT__instruction_decode__DOT__ctrl_unit__DOT__jump));
        bufp->chgBit(oldp+119,(vlSelfRef.main__DOT__cpu__DOT__instruction_decode__DOT__ctrl_unit__DOT__alu_src));
        bufp->chgCData(oldp+120,(vlSelfRef.main__DOT__cpu__DOT__instruction_decode__DOT__ctrl_unit__DOT__alu_op),4);
        bufp->chgCData(oldp+121,(vlSelfRef.main__DOT__cpu__DOT__instruction_decode__DOT__ctrl_unit__DOT__imm_type),3);
        bufp->chgCData(oldp+122,(vlSelfRef.main__DOT__cpu__DOT__instruction_decode__DOT__ctrl_unit__DOT__pc_src),2);
        bufp->chgIData(oldp+123,(((IData)(vlSelfRef.main__DOT__cpu__DOT__pc_src)
                                   ? vlSelfRef.main__DOT__cpu__DOT__new_pc
                                   : ((IData)(4U) + vlSelfRef.main__DOT__cpu__DOT__instruction_fetch__DOT__pc_reg))),32);
        bufp->chgCData(oldp+124,((7U & (vlSelfRef.main__DOT__cpu__DOT__ex_mem_control_signals 
                                        >> 0xcU))),3);
        bufp->chgBit(oldp+125,((1U & (vlSelfRef.main__DOT__cpu__DOT__ex_mem_control_signals 
                                      >> 0xfU))));
        bufp->chgIData(oldp+126,(vlSelfRef.main__DOT__cpu__DOT__memory_access__DOT__read_data),32);
        bufp->chgIData(oldp+127,(vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs[0]),32);
        bufp->chgIData(oldp+128,(vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs[1]),32);
        bufp->chgIData(oldp+129,(vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs[2]),32);
        bufp->chgIData(oldp+130,(vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs[3]),32);
        bufp->chgIData(oldp+131,(vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs[4]),32);
        bufp->chgIData(oldp+132,(vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs[5]),32);
        bufp->chgIData(oldp+133,(vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs[6]),32);
        bufp->chgIData(oldp+134,(vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs[7]),32);
        bufp->chgIData(oldp+135,(vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs[8]),32);
        bufp->chgIData(oldp+136,(vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs[9]),32);
        bufp->chgIData(oldp+137,(vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs[10]),32);
        bufp->chgIData(oldp+138,(vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs[11]),32);
        bufp->chgIData(oldp+139,(vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs[12]),32);
        bufp->chgIData(oldp+140,(vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs[13]),32);
        bufp->chgIData(oldp+141,(vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs[14]),32);
        bufp->chgIData(oldp+142,(vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs[15]),32);
        bufp->chgIData(oldp+143,(vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs[16]),32);
        bufp->chgIData(oldp+144,(vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs[17]),32);
        bufp->chgIData(oldp+145,(vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs[18]),32);
        bufp->chgIData(oldp+146,(vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs[19]),32);
        bufp->chgIData(oldp+147,(vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs[20]),32);
        bufp->chgIData(oldp+148,(vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs[21]),32);
        bufp->chgIData(oldp+149,(vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs[22]),32);
        bufp->chgIData(oldp+150,(vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs[23]),32);
        bufp->chgIData(oldp+151,(vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs[24]),32);
        bufp->chgIData(oldp+152,(vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs[25]),32);
        bufp->chgIData(oldp+153,(vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs[26]),32);
        bufp->chgIData(oldp+154,(vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs[27]),32);
        bufp->chgIData(oldp+155,(vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs[28]),32);
        bufp->chgIData(oldp+156,(vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs[29]),32);
        bufp->chgIData(oldp+157,(vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs[30]),32);
        bufp->chgIData(oldp+158,(vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__unnamedblk1__DOT__i),32);
        bufp->chgBit(oldp+159,((1U & (vlSelfRef.main__DOT__cpu__DOT__mem_wb_control_signals 
                                      >> 1U))));
    }
    bufp->chgBit(oldp+160,(vlSelfRef.clk));
    bufp->chgBit(oldp+161,(vlSelfRef.reset));
    bufp->chgBit(oldp+162,(vlSelfRef.step_en));
    bufp->chgIData(oldp+163,(vlSelfRef.debug_pc),32);
    bufp->chgIData(oldp+164,(vlSelfRef.debug_instruction),32);
    bufp->chgBit(oldp+165,(vlSelfRef.debug_stall));
    bufp->chgBit(oldp+166,(vlSelfRef.debug_flush));
    bufp->chgBit(oldp+167,(vlSelfRef.main__DOT__cpu_clk));
    bufp->chgBit(oldp+168,((1U & (~ (IData)(vlSelfRef.debug_stall)))));
}

void Vmain___024root__trace_cleanup(void* voidSelf, VerilatedVcd* /*unused*/) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vmain___024root__trace_cleanup\n"); );
    // Init
    Vmain___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vmain___024root*>(voidSelf);
    Vmain__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    // Body
    vlSymsp->__Vm_activity = false;
    vlSymsp->TOP.__Vm_traceActivity[0U] = 0U;
    vlSymsp->TOP.__Vm_traceActivity[1U] = 0U;
}
