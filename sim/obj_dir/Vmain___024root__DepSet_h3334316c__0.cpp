// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vmain.h for the primary calling header

#include "Vmain__pch.h"
#include "Vmain___024root.h"

void Vmain___024root___ico_sequent__TOP__0(Vmain___024root* vlSelf);

void Vmain___024root___eval_ico(Vmain___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vmain__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vmain___024root___eval_ico\n"); );
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((1ULL & vlSelfRef.__VicoTriggered.word(0U))) {
        Vmain___024root___ico_sequent__TOP__0(vlSelf);
    }
}

VL_INLINE_OPT void Vmain___024root___ico_sequent__TOP__0(Vmain___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vmain__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vmain___024root___ico_sequent__TOP__0\n"); );
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.main__DOT__cpu_clk = ((IData)(vlSelfRef.clk) 
                                    & (IData)(vlSelfRef.step_en));
}

void Vmain___024root___eval_triggers__ico(Vmain___024root* vlSelf);

bool Vmain___024root___eval_phase__ico(Vmain___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vmain__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vmain___024root___eval_phase__ico\n"); );
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    CData/*0:0*/ __VicoExecute;
    // Body
    Vmain___024root___eval_triggers__ico(vlSelf);
    __VicoExecute = vlSelfRef.__VicoTriggered.any();
    if (__VicoExecute) {
        Vmain___024root___eval_ico(vlSelf);
    }
    return (__VicoExecute);
}

void Vmain___024root___eval_act(Vmain___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vmain__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vmain___024root___eval_act\n"); );
    auto& vlSelfRef = std::ref(*vlSelf).get();
}

void Vmain___024root___nba_sequent__TOP__0(Vmain___024root* vlSelf);
void Vmain___024root___nba_sequent__TOP__1(Vmain___024root* vlSelf);
void Vmain___024root___nba_comb__TOP__0(Vmain___024root* vlSelf);

void Vmain___024root___eval_nba(Vmain___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vmain__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vmain___024root___eval_nba\n"); );
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((1ULL & vlSelfRef.__VnbaTriggered.word(0U))) {
        Vmain___024root___nba_sequent__TOP__0(vlSelf);
    }
    if ((3ULL & vlSelfRef.__VnbaTriggered.word(0U))) {
        Vmain___024root___nba_sequent__TOP__1(vlSelf);
        vlSelfRef.__Vm_traceActivity[1U] = 1U;
        Vmain___024root___nba_comb__TOP__0(vlSelf);
    }
}

VL_INLINE_OPT void Vmain___024root___nba_sequent__TOP__0(Vmain___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vmain__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vmain___024root___nba_sequent__TOP__0\n"); );
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    CData/*7:0*/ __VdlyVal__main__DOT__dmem_internal__v0;
    __VdlyVal__main__DOT__dmem_internal__v0 = 0;
    CData/*7:0*/ __VdlyDim0__main__DOT__dmem_internal__v0;
    __VdlyDim0__main__DOT__dmem_internal__v0 = 0;
    CData/*0:0*/ __VdlySet__main__DOT__dmem_internal__v0;
    __VdlySet__main__DOT__dmem_internal__v0 = 0;
    CData/*7:0*/ __VdlyVal__main__DOT__dmem_internal__v1;
    __VdlyVal__main__DOT__dmem_internal__v1 = 0;
    CData/*7:0*/ __VdlyDim0__main__DOT__dmem_internal__v1;
    __VdlyDim0__main__DOT__dmem_internal__v1 = 0;
    CData/*0:0*/ __VdlySet__main__DOT__dmem_internal__v1;
    __VdlySet__main__DOT__dmem_internal__v1 = 0;
    CData/*7:0*/ __VdlyVal__main__DOT__dmem_internal__v2;
    __VdlyVal__main__DOT__dmem_internal__v2 = 0;
    CData/*7:0*/ __VdlyDim0__main__DOT__dmem_internal__v2;
    __VdlyDim0__main__DOT__dmem_internal__v2 = 0;
    CData/*0:0*/ __VdlySet__main__DOT__dmem_internal__v2;
    __VdlySet__main__DOT__dmem_internal__v2 = 0;
    CData/*7:0*/ __VdlyVal__main__DOT__dmem_internal__v3;
    __VdlyVal__main__DOT__dmem_internal__v3 = 0;
    CData/*7:0*/ __VdlyDim0__main__DOT__dmem_internal__v3;
    __VdlyDim0__main__DOT__dmem_internal__v3 = 0;
    CData/*0:0*/ __VdlySet__main__DOT__dmem_internal__v3;
    __VdlySet__main__DOT__dmem_internal__v3 = 0;
    // Body
    __VdlySet__main__DOT__dmem_internal__v0 = 0U;
    __VdlySet__main__DOT__dmem_internal__v1 = 0U;
    __VdlySet__main__DOT__dmem_internal__v2 = 0U;
    __VdlySet__main__DOT__dmem_internal__v3 = 0U;
    if ((8U & vlSelfRef.main__DOT__cpu__DOT__ex_mem_control_signals)) {
        if ((1U & (IData)(vlSelfRef.main__DOT__dmem_byte_enable))) {
            __VdlyVal__main__DOT__dmem_internal__v0 
                = (0xffU & vlSelfRef.main__DOT__cpu__DOT__ex_mem_rs2_data);
            __VdlyDim0__main__DOT__dmem_internal__v0 
                = (0xffU & (vlSelfRef.main__DOT__cpu__DOT__ex_mem_alu_result 
                            >> 2U));
            __VdlySet__main__DOT__dmem_internal__v0 = 1U;
        }
        if ((2U & (IData)(vlSelfRef.main__DOT__dmem_byte_enable))) {
            __VdlyVal__main__DOT__dmem_internal__v1 
                = (0xffU & (vlSelfRef.main__DOT__cpu__DOT__ex_mem_rs2_data 
                            >> 8U));
            __VdlyDim0__main__DOT__dmem_internal__v1 
                = (0xffU & (vlSelfRef.main__DOT__cpu__DOT__ex_mem_alu_result 
                            >> 2U));
            __VdlySet__main__DOT__dmem_internal__v1 = 1U;
        }
        if ((4U & (IData)(vlSelfRef.main__DOT__dmem_byte_enable))) {
            __VdlyVal__main__DOT__dmem_internal__v2 
                = (0xffU & (vlSelfRef.main__DOT__cpu__DOT__ex_mem_rs2_data 
                            >> 0x10U));
            __VdlyDim0__main__DOT__dmem_internal__v2 
                = (0xffU & (vlSelfRef.main__DOT__cpu__DOT__ex_mem_alu_result 
                            >> 2U));
            __VdlySet__main__DOT__dmem_internal__v2 = 1U;
        }
        if ((8U & (IData)(vlSelfRef.main__DOT__dmem_byte_enable))) {
            __VdlyVal__main__DOT__dmem_internal__v3 
                = (vlSelfRef.main__DOT__cpu__DOT__ex_mem_rs2_data 
                   >> 0x18U);
            __VdlyDim0__main__DOT__dmem_internal__v3 
                = (0xffU & (vlSelfRef.main__DOT__cpu__DOT__ex_mem_alu_result 
                            >> 2U));
            __VdlySet__main__DOT__dmem_internal__v3 = 1U;
        }
    }
    if (__VdlySet__main__DOT__dmem_internal__v0) {
        vlSelfRef.main__DOT__dmem_internal[__VdlyDim0__main__DOT__dmem_internal__v0] 
            = ((0xffffff00U & vlSelfRef.main__DOT__dmem_internal
                [__VdlyDim0__main__DOT__dmem_internal__v0]) 
               | (IData)(__VdlyVal__main__DOT__dmem_internal__v0));
    }
    if (__VdlySet__main__DOT__dmem_internal__v1) {
        vlSelfRef.main__DOT__dmem_internal[__VdlyDim0__main__DOT__dmem_internal__v1] 
            = ((0xffff00ffU & vlSelfRef.main__DOT__dmem_internal
                [__VdlyDim0__main__DOT__dmem_internal__v1]) 
               | ((IData)(__VdlyVal__main__DOT__dmem_internal__v1) 
                  << 8U));
    }
    if (__VdlySet__main__DOT__dmem_internal__v2) {
        vlSelfRef.main__DOT__dmem_internal[__VdlyDim0__main__DOT__dmem_internal__v2] 
            = ((0xff00ffffU & vlSelfRef.main__DOT__dmem_internal
                [__VdlyDim0__main__DOT__dmem_internal__v2]) 
               | ((IData)(__VdlyVal__main__DOT__dmem_internal__v2) 
                  << 0x10U));
    }
    if (__VdlySet__main__DOT__dmem_internal__v3) {
        vlSelfRef.main__DOT__dmem_internal[__VdlyDim0__main__DOT__dmem_internal__v3] 
            = ((0xffffffU & vlSelfRef.main__DOT__dmem_internal
                [__VdlyDim0__main__DOT__dmem_internal__v3]) 
               | ((IData)(__VdlyVal__main__DOT__dmem_internal__v3) 
                  << 0x18U));
    }
}

VL_INLINE_OPT void Vmain___024root___nba_sequent__TOP__1(Vmain___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vmain__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vmain___024root___nba_sequent__TOP__1\n"); );
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    CData/*0:0*/ __VdlySet__main__DOT__cpu__DOT__reg_file__DOT__regs__v0;
    __VdlySet__main__DOT__cpu__DOT__reg_file__DOT__regs__v0 = 0;
    IData/*31:0*/ __VdlyVal__main__DOT__cpu__DOT__reg_file__DOT__regs__v31;
    __VdlyVal__main__DOT__cpu__DOT__reg_file__DOT__regs__v31 = 0;
    CData/*4:0*/ __VdlyDim0__main__DOT__cpu__DOT__reg_file__DOT__regs__v31;
    __VdlyDim0__main__DOT__cpu__DOT__reg_file__DOT__regs__v31 = 0;
    CData/*0:0*/ __VdlySet__main__DOT__cpu__DOT__reg_file__DOT__regs__v31;
    __VdlySet__main__DOT__cpu__DOT__reg_file__DOT__regs__v31 = 0;
    // Body
    __VdlySet__main__DOT__cpu__DOT__reg_file__DOT__regs__v0 = 0U;
    __VdlySet__main__DOT__cpu__DOT__reg_file__DOT__regs__v31 = 0U;
    if ((1U & (~ (IData)(vlSelfRef.reset)))) {
        vlSelfRef.main__DOT__cpu__DOT__mem_wb_mem_data 
            = vlSelfRef.main__DOT__cpu__DOT__memory_access__DOT__read_data;
        vlSelfRef.main__DOT__cpu__DOT__mem_wb_alu_result 
            = vlSelfRef.main__DOT__cpu__DOT__ex_mem_alu_result;
        vlSelfRef.main__DOT__cpu__DOT__mem_wb_valid 
            = vlSelfRef.main__DOT__cpu__DOT__ex_mem_valid;
        vlSelfRef.main__DOT__cpu__DOT__mem_wb_pc = vlSelfRef.main__DOT__cpu__DOT__ex_mem_pc;
    }
    if (vlSelfRef.reset) {
        vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__unnamedblk1__DOT__i = 0x20U;
        __VdlySet__main__DOT__cpu__DOT__reg_file__DOT__regs__v0 = 1U;
        vlSelfRef.main__DOT__cpu__DOT__id_ex_immediate = 0U;
        vlSelfRef.main__DOT__cpu__DOT__id_ex_rs1_addr = 0U;
        vlSelfRef.main__DOT__cpu__DOT__id_ex_rs2_addr = 0U;
        vlSelfRef.main__DOT__cpu__DOT__id_ex_instruction = 0x13U;
        vlSelfRef.main__DOT__cpu__DOT__id_ex_rs1_data = 0U;
        vlSelfRef.main__DOT__cpu__DOT__id_ex_rs2_data = 0U;
    } else {
        if ((vlSelfRef.main__DOT__cpu__DOT__mem_wb_control_signals 
             & (0U != (IData)(vlSelfRef.main__DOT__cpu__DOT__mem_wb_rd_addr)))) {
            vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT____Vlvbound_h9617656b__0 
                = vlSelfRef.main__DOT__cpu__DOT__wb_data;
            if ((0x1eU >= (0x1fU & ((0xfU & (IData)(vlSelfRef.main__DOT__cpu__DOT__mem_wb_rd_addr)) 
                                    - (IData)(1U))))) {
                __VdlyVal__main__DOT__cpu__DOT__reg_file__DOT__regs__v31 
                    = vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT____Vlvbound_h9617656b__0;
                __VdlyDim0__main__DOT__cpu__DOT__reg_file__DOT__regs__v31 
                    = (0x1fU & ((0xfU & (IData)(vlSelfRef.main__DOT__cpu__DOT__mem_wb_rd_addr)) 
                                - (IData)(1U)));
                __VdlySet__main__DOT__cpu__DOT__reg_file__DOT__regs__v31 = 1U;
            }
        }
        if (vlSelfRef.main__DOT__cpu__DOT__flush) {
            vlSelfRef.main__DOT__cpu__DOT__id_ex_immediate = 0U;
            vlSelfRef.main__DOT__cpu__DOT__id_ex_rs1_addr = 0U;
            vlSelfRef.main__DOT__cpu__DOT__id_ex_rs2_addr = 0U;
            vlSelfRef.main__DOT__cpu__DOT__id_ex_instruction = 0x13U;
            vlSelfRef.main__DOT__cpu__DOT__id_ex_rs1_data = 0U;
            vlSelfRef.main__DOT__cpu__DOT__id_ex_rs2_data = 0U;
        } else if ((1U & (~ (IData)(vlSelfRef.debug_stall)))) {
            vlSelfRef.main__DOT__cpu__DOT__id_ex_immediate 
                = vlSelfRef.main__DOT__cpu__DOT__instruction_decode__DOT__immediate;
            vlSelfRef.main__DOT__cpu__DOT__id_ex_rs1_addr 
                = (0x1fU & (vlSelfRef.main__DOT__cpu__DOT__if_id_instruction 
                            >> 0xfU));
            vlSelfRef.main__DOT__cpu__DOT__id_ex_rs2_addr 
                = (0x1fU & (vlSelfRef.main__DOT__cpu__DOT__if_id_instruction 
                            >> 0x14U));
            vlSelfRef.main__DOT__cpu__DOT__id_ex_instruction 
                = vlSelfRef.main__DOT__cpu__DOT__if_id_instruction;
            vlSelfRef.main__DOT__cpu__DOT__id_ex_rs1_data 
                = ((vlSelfRef.main__DOT__cpu__DOT__mem_wb_control_signals 
                    & (((IData)(vlSelfRef.main__DOT__cpu__DOT__mem_wb_rd_addr) 
                        == (0x1fU & (vlSelfRef.main__DOT__cpu__DOT__if_id_instruction 
                                     >> 0xfU))) & (0U 
                                                   != 
                                                   (0x1fU 
                                                    & (vlSelfRef.main__DOT__cpu__DOT__if_id_instruction 
                                                       >> 0xfU)))))
                    ? vlSelfRef.main__DOT__cpu__DOT__wb_data
                    : ((0U == (0x1fU & (vlSelfRef.main__DOT__cpu__DOT__if_id_instruction 
                                        >> 0xfU))) ? 0U
                        : (((((0x1fU & (vlSelfRef.main__DOT__cpu__DOT__if_id_instruction 
                                        >> 0xfU)) == (IData)(vlSelfRef.main__DOT__cpu__DOT__mem_wb_rd_addr)) 
                             & vlSelfRef.main__DOT__cpu__DOT__mem_wb_control_signals) 
                            & (0U != (IData)(vlSelfRef.main__DOT__cpu__DOT__mem_wb_rd_addr)))
                            ? vlSelfRef.main__DOT__cpu__DOT__wb_data
                            : ((0x1eU >= (0x1fU & (
                                                   (0xfU 
                                                    & (vlSelfRef.main__DOT__cpu__DOT__if_id_instruction 
                                                       >> 0xfU)) 
                                                   - (IData)(1U))))
                                ? vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs
                               [(0x1fU & ((0xfU & (vlSelfRef.main__DOT__cpu__DOT__if_id_instruction 
                                                   >> 0xfU)) 
                                          - (IData)(1U)))]
                                : 0U))));
            vlSelfRef.main__DOT__cpu__DOT__id_ex_rs2_data 
                = ((vlSelfRef.main__DOT__cpu__DOT__mem_wb_control_signals 
                    & (((IData)(vlSelfRef.main__DOT__cpu__DOT__mem_wb_rd_addr) 
                        == (0x1fU & (vlSelfRef.main__DOT__cpu__DOT__if_id_instruction 
                                     >> 0x14U))) & 
                       (0U != (0x1fU & (vlSelfRef.main__DOT__cpu__DOT__if_id_instruction 
                                        >> 0x14U)))))
                    ? vlSelfRef.main__DOT__cpu__DOT__wb_data
                    : ((0U == (0x1fU & (vlSelfRef.main__DOT__cpu__DOT__if_id_instruction 
                                        >> 0x14U)))
                        ? 0U : (((((0x1fU & (vlSelfRef.main__DOT__cpu__DOT__if_id_instruction 
                                             >> 0x14U)) 
                                   == (IData)(vlSelfRef.main__DOT__cpu__DOT__mem_wb_rd_addr)) 
                                  & vlSelfRef.main__DOT__cpu__DOT__mem_wb_control_signals) 
                                 & (0U != (IData)(vlSelfRef.main__DOT__cpu__DOT__mem_wb_rd_addr)))
                                 ? vlSelfRef.main__DOT__cpu__DOT__wb_data
                                 : ((0x1eU >= (0x1fU 
                                               & ((0xfU 
                                                   & (vlSelfRef.main__DOT__cpu__DOT__if_id_instruction 
                                                      >> 0x14U)) 
                                                  - (IData)(1U))))
                                     ? vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs
                                    [(0x1fU & ((0xfU 
                                                & (vlSelfRef.main__DOT__cpu__DOT__if_id_instruction 
                                                   >> 0x14U)) 
                                               - (IData)(1U)))]
                                     : 0U))));
        }
    }
    if ((1U & (~ (IData)(vlSelfRef.reset)))) {
        vlSelfRef.main__DOT__cpu__DOT__mem_wb_control_signals 
            = vlSelfRef.main__DOT__cpu__DOT__ex_mem_control_signals;
        vlSelfRef.main__DOT__cpu__DOT__mem_wb_rd_addr 
            = vlSelfRef.main__DOT__cpu__DOT__ex_mem_rd_addr;
    }
    if (__VdlySet__main__DOT__cpu__DOT__reg_file__DOT__regs__v0) {
        vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs[0U] = 0U;
        vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs[1U] = 0U;
        vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs[2U] = 0U;
        vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs[3U] = 0U;
        vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs[4U] = 0U;
        vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs[5U] = 0U;
        vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs[6U] = 0U;
        vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs[7U] = 0U;
        vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs[8U] = 0U;
        vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs[9U] = 0U;
        vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs[0xaU] = 0U;
        vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs[0xbU] = 0U;
        vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs[0xcU] = 0U;
        vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs[0xdU] = 0U;
        vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs[0xeU] = 0U;
        vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs[0xfU] = 0U;
        vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs[0x10U] = 0U;
        vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs[0x11U] = 0U;
        vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs[0x12U] = 0U;
        vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs[0x13U] = 0U;
        vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs[0x14U] = 0U;
        vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs[0x15U] = 0U;
        vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs[0x16U] = 0U;
        vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs[0x17U] = 0U;
        vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs[0x18U] = 0U;
        vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs[0x19U] = 0U;
        vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs[0x1aU] = 0U;
        vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs[0x1bU] = 0U;
        vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs[0x1cU] = 0U;
        vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs[0x1dU] = 0U;
        vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs[0x1eU] = 0U;
    }
    if (__VdlySet__main__DOT__cpu__DOT__reg_file__DOT__regs__v31) {
        vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs[__VdlyDim0__main__DOT__cpu__DOT__reg_file__DOT__regs__v31] 
            = __VdlyVal__main__DOT__cpu__DOT__reg_file__DOT__regs__v31;
    }
    vlSelfRef.main__DOT__cpu__DOT__ex_mem_valid = (
                                                   (1U 
                                                    & (~ (IData)(vlSelfRef.reset))) 
                                                   && (IData)(vlSelfRef.main__DOT__cpu__DOT__id_ex_valid));
    if (vlSelfRef.reset) {
        vlSelfRef.main__DOT__cpu__DOT__ex_mem_rs2_data = 0U;
        vlSelfRef.main__DOT__cpu__DOT__ex_mem_alu_result = 0U;
        vlSelfRef.main__DOT__cpu__DOT__ex_mem_pc = 0U;
        vlSelfRef.main__DOT__cpu__DOT__id_ex_valid = 0U;
        vlSelfRef.main__DOT__cpu__DOT__id_ex_pc = 0U;
        vlSelfRef.main__DOT__cpu__DOT__ex_mem_control_signals = 0U;
        vlSelfRef.main__DOT__cpu__DOT__ex_mem_rd_addr = 0U;
        vlSelfRef.main__DOT__cpu__DOT__if_id_valid = 0U;
        vlSelfRef.main__DOT__cpu__DOT__if_id_pc = 0U;
        vlSelfRef.main__DOT__cpu__DOT__id_ex_control_signals = 0U;
        vlSelfRef.main__DOT__cpu__DOT__id_ex_rd_addr = 0U;
        vlSelfRef.main__DOT__cpu__DOT__if_id_instruction = 0x13U;
        vlSelfRef.main__DOT__cpu__DOT__instruction_fetch__DOT__pc_reg = 0U;
    } else {
        vlSelfRef.main__DOT__cpu__DOT__ex_mem_rs2_data 
            = vlSelfRef.main__DOT__cpu__DOT__execute__DOT__forwarded_rs2;
        vlSelfRef.main__DOT__cpu__DOT__ex_mem_alu_result 
            = vlSelfRef.main__DOT__cpu__DOT__execute__DOT__alu_result;
        vlSelfRef.main__DOT__cpu__DOT__ex_mem_pc = vlSelfRef.main__DOT__cpu__DOT__id_ex_pc;
        vlSelfRef.main__DOT__cpu__DOT__ex_mem_control_signals 
            = vlSelfRef.main__DOT__cpu__DOT__id_ex_control_signals;
        vlSelfRef.main__DOT__cpu__DOT__ex_mem_rd_addr 
            = vlSelfRef.main__DOT__cpu__DOT__id_ex_rd_addr;
        if (vlSelfRef.main__DOT__cpu__DOT__flush) {
            vlSelfRef.main__DOT__cpu__DOT__id_ex_valid = 0U;
            vlSelfRef.main__DOT__cpu__DOT__id_ex_pc = 0U;
            vlSelfRef.main__DOT__cpu__DOT__if_id_valid = 0U;
            vlSelfRef.main__DOT__cpu__DOT__if_id_pc = 0U;
            vlSelfRef.main__DOT__cpu__DOT__id_ex_control_signals = 0U;
            vlSelfRef.main__DOT__cpu__DOT__id_ex_rd_addr = 0U;
            vlSelfRef.main__DOT__cpu__DOT__if_id_instruction = 0x13U;
        } else if ((1U & (~ (IData)(vlSelfRef.debug_stall)))) {
            vlSelfRef.main__DOT__cpu__DOT__id_ex_valid 
                = vlSelfRef.main__DOT__cpu__DOT__if_id_valid;
            vlSelfRef.main__DOT__cpu__DOT__id_ex_pc 
                = vlSelfRef.main__DOT__cpu__DOT__if_id_pc;
            vlSelfRef.main__DOT__cpu__DOT__if_id_valid = 1U;
            vlSelfRef.main__DOT__cpu__DOT__if_id_pc 
                = vlSelfRef.main__DOT__cpu__DOT__instruction_fetch__DOT__pc_reg;
            vlSelfRef.main__DOT__cpu__DOT__id_ex_control_signals 
                = vlSelfRef.main__DOT__cpu__DOT__instruction_decode__DOT__control_signals;
            vlSelfRef.main__DOT__cpu__DOT__id_ex_rd_addr 
                = (0x1fU & (vlSelfRef.main__DOT__cpu__DOT__if_id_instruction 
                            >> 7U));
            vlSelfRef.main__DOT__cpu__DOT__if_id_instruction 
                = vlSelfRef.main__DOT__imem_internal
                [(0xffU & (vlSelfRef.main__DOT__cpu__DOT__instruction_fetch__DOT__pc_reg 
                           >> 2U))];
        }
        if ((1U & (~ (IData)(vlSelfRef.debug_stall)))) {
            vlSelfRef.main__DOT__cpu__DOT__instruction_fetch__DOT__pc_reg 
                = vlSelfRef.main__DOT__cpu__DOT__instruction_fetch__DOT__pc_next;
        }
    }
    vlSelfRef.main__DOT__debug_registers_internal[1U] 
        = vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs
        [0U];
    vlSelfRef.main__DOT__debug_registers_internal[2U] 
        = vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs
        [1U];
    vlSelfRef.main__DOT__debug_registers_internal[3U] 
        = vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs
        [2U];
    vlSelfRef.main__DOT__debug_registers_internal[4U] 
        = vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs
        [3U];
    vlSelfRef.main__DOT__debug_registers_internal[5U] 
        = vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs
        [4U];
    vlSelfRef.main__DOT__debug_registers_internal[6U] 
        = vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs
        [5U];
    vlSelfRef.main__DOT__debug_registers_internal[7U] 
        = vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs
        [6U];
    vlSelfRef.main__DOT__debug_registers_internal[8U] 
        = vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs
        [7U];
    vlSelfRef.main__DOT__debug_registers_internal[9U] 
        = vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs
        [8U];
    vlSelfRef.main__DOT__debug_registers_internal[0xaU] 
        = vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs
        [9U];
    vlSelfRef.main__DOT__debug_registers_internal[0xbU] 
        = vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs
        [0xaU];
    vlSelfRef.main__DOT__debug_registers_internal[0xcU] 
        = vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs
        [0xbU];
    vlSelfRef.main__DOT__debug_registers_internal[0xdU] 
        = vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs
        [0xcU];
    vlSelfRef.main__DOT__debug_registers_internal[0xeU] 
        = vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs
        [0xdU];
    vlSelfRef.main__DOT__debug_registers_internal[0xfU] 
        = vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs
        [0xeU];
    vlSelfRef.main__DOT__debug_registers_internal[0x10U] 
        = vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs
        [0xfU];
    vlSelfRef.main__DOT__debug_registers_internal[0x11U] 
        = vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs
        [0x10U];
    vlSelfRef.main__DOT__debug_registers_internal[0x12U] 
        = vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs
        [0x11U];
    vlSelfRef.main__DOT__debug_registers_internal[0x13U] 
        = vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs
        [0x12U];
    vlSelfRef.main__DOT__debug_registers_internal[0x14U] 
        = vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs
        [0x13U];
    vlSelfRef.main__DOT__debug_registers_internal[0x15U] 
        = vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs
        [0x14U];
    vlSelfRef.main__DOT__debug_registers_internal[0x16U] 
        = vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs
        [0x15U];
    vlSelfRef.main__DOT__debug_registers_internal[0x17U] 
        = vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs
        [0x16U];
    vlSelfRef.main__DOT__debug_registers_internal[0x18U] 
        = vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs
        [0x17U];
    vlSelfRef.main__DOT__debug_registers_internal[0x19U] 
        = vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs
        [0x18U];
    vlSelfRef.main__DOT__debug_registers_internal[0x1aU] 
        = vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs
        [0x19U];
    vlSelfRef.main__DOT__debug_registers_internal[0x1bU] 
        = vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs
        [0x1aU];
    vlSelfRef.main__DOT__debug_registers_internal[0x1cU] 
        = vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs
        [0x1bU];
    vlSelfRef.main__DOT__debug_registers_internal[0x1dU] 
        = vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs
        [0x1cU];
    vlSelfRef.main__DOT__debug_registers_internal[0x1eU] 
        = vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs
        [0x1dU];
    vlSelfRef.main__DOT__debug_registers_internal[0x1fU] 
        = vlSelfRef.main__DOT__cpu__DOT__reg_file__DOT__regs
        [0x1eU];
    vlSelfRef.main__DOT__cpu__DOT__wb_data = ((2U & vlSelfRef.main__DOT__cpu__DOT__mem_wb_control_signals)
                                               ? vlSelfRef.main__DOT__cpu__DOT__mem_wb_mem_data
                                               : vlSelfRef.main__DOT__cpu__DOT__mem_wb_alu_result);
    vlSelfRef.main__DOT__dmem_byte_enable = 0xfU;
    if ((0U == (7U & (vlSelfRef.main__DOT__cpu__DOT__ex_mem_control_signals 
                      >> 0xcU)))) {
        vlSelfRef.main__DOT__dmem_byte_enable = ((2U 
                                                  & vlSelfRef.main__DOT__cpu__DOT__ex_mem_alu_result)
                                                  ? 
                                                 ((1U 
                                                   & vlSelfRef.main__DOT__cpu__DOT__ex_mem_alu_result)
                                                   ? 8U
                                                   : 4U)
                                                  : 
                                                 ((1U 
                                                   & vlSelfRef.main__DOT__cpu__DOT__ex_mem_alu_result)
                                                   ? 2U
                                                   : 1U));
    } else if ((1U == (7U & (vlSelfRef.main__DOT__cpu__DOT__ex_mem_control_signals 
                             >> 0xcU)))) {
        if ((2U & vlSelfRef.main__DOT__cpu__DOT__ex_mem_alu_result)) {
            if ((2U & vlSelfRef.main__DOT__cpu__DOT__ex_mem_alu_result)) {
                vlSelfRef.main__DOT__dmem_byte_enable = 0xcU;
            }
        } else {
            vlSelfRef.main__DOT__dmem_byte_enable = 3U;
        }
    } else {
        vlSelfRef.main__DOT__dmem_byte_enable = 0xfU;
    }
    vlSelfRef.main__DOT__cpu__DOT__forward_a = 0U;
    if (((vlSelfRef.main__DOT__cpu__DOT__ex_mem_control_signals 
          & (0U != (IData)(vlSelfRef.main__DOT__cpu__DOT__ex_mem_rd_addr))) 
         & ((IData)(vlSelfRef.main__DOT__cpu__DOT__ex_mem_rd_addr) 
            == (IData)(vlSelfRef.main__DOT__cpu__DOT__id_ex_rs1_addr)))) {
        vlSelfRef.main__DOT__cpu__DOT__forward_a = 1U;
    } else if (((vlSelfRef.main__DOT__cpu__DOT__mem_wb_control_signals 
                 & (0U != (IData)(vlSelfRef.main__DOT__cpu__DOT__mem_wb_rd_addr))) 
                & ((IData)(vlSelfRef.main__DOT__cpu__DOT__mem_wb_rd_addr) 
                   == (IData)(vlSelfRef.main__DOT__cpu__DOT__id_ex_rs1_addr)))) {
        vlSelfRef.main__DOT__cpu__DOT__forward_a = 2U;
    }
    vlSelfRef.main__DOT__cpu__DOT__forward_b = 0U;
    if (((vlSelfRef.main__DOT__cpu__DOT__ex_mem_control_signals 
          & (0U != (IData)(vlSelfRef.main__DOT__cpu__DOT__ex_mem_rd_addr))) 
         & ((IData)(vlSelfRef.main__DOT__cpu__DOT__ex_mem_rd_addr) 
            == (IData)(vlSelfRef.main__DOT__cpu__DOT__id_ex_rs2_addr)))) {
        vlSelfRef.main__DOT__cpu__DOT__forward_b = 1U;
    } else if (((vlSelfRef.main__DOT__cpu__DOT__mem_wb_control_signals 
                 & (0U != (IData)(vlSelfRef.main__DOT__cpu__DOT__mem_wb_rd_addr))) 
                & ((IData)(vlSelfRef.main__DOT__cpu__DOT__mem_wb_rd_addr) 
                   == (IData)(vlSelfRef.main__DOT__cpu__DOT__id_ex_rs2_addr)))) {
        vlSelfRef.main__DOT__cpu__DOT__forward_b = 2U;
    }
    vlSelfRef.main__DOT__cpu__DOT__execute__DOT__forwarded_rs1 
        = ((0U == (IData)(vlSelfRef.main__DOT__cpu__DOT__forward_a))
            ? vlSelfRef.main__DOT__cpu__DOT__id_ex_rs1_data
            : ((1U == (IData)(vlSelfRef.main__DOT__cpu__DOT__forward_a))
                ? vlSelfRef.main__DOT__cpu__DOT__mem_wb_mem_data
                : ((2U == (IData)(vlSelfRef.main__DOT__cpu__DOT__forward_a))
                    ? vlSelfRef.main__DOT__cpu__DOT__mem_wb_alu_result
                    : vlSelfRef.main__DOT__cpu__DOT__id_ex_rs1_data)));
    vlSelfRef.main__DOT__cpu__DOT__execute__DOT__forwarded_rs2 
        = ((0U == (IData)(vlSelfRef.main__DOT__cpu__DOT__forward_b))
            ? vlSelfRef.main__DOT__cpu__DOT__id_ex_rs2_data
            : ((1U == (IData)(vlSelfRef.main__DOT__cpu__DOT__forward_b))
                ? vlSelfRef.main__DOT__cpu__DOT__mem_wb_mem_data
                : ((2U == (IData)(vlSelfRef.main__DOT__cpu__DOT__forward_b))
                    ? vlSelfRef.main__DOT__cpu__DOT__mem_wb_alu_result
                    : vlSelfRef.main__DOT__cpu__DOT__id_ex_rs2_data)));
    vlSelfRef.debug_pc = vlSelfRef.main__DOT__cpu__DOT__if_id_pc;
    vlSelfRef.main__DOT__cpu__DOT__execute__DOT__branch_condition_met = 0U;
    vlSelfRef.main__DOT__cpu__DOT__execute__DOT__alu_input_b 
        = ((0x40U & vlSelfRef.main__DOT__cpu__DOT__id_ex_control_signals)
            ? vlSelfRef.main__DOT__cpu__DOT__id_ex_immediate
            : vlSelfRef.main__DOT__cpu__DOT__execute__DOT__forwarded_rs2);
    vlSelfRef.main__DOT__cpu__DOT__execute__DOT__alu_result 
        = ((0x400U & vlSelfRef.main__DOT__cpu__DOT__id_ex_control_signals)
            ? ((0x200U & vlSelfRef.main__DOT__cpu__DOT__id_ex_control_signals)
                ? 0U : ((0x100U & vlSelfRef.main__DOT__cpu__DOT__id_ex_control_signals)
                         ? ((0x80U & vlSelfRef.main__DOT__cpu__DOT__id_ex_control_signals)
                             ? 0U : vlSelfRef.main__DOT__cpu__DOT__execute__DOT__alu_input_b)
                         : ((0x80U & vlSelfRef.main__DOT__cpu__DOT__id_ex_control_signals)
                             ? ((vlSelfRef.main__DOT__cpu__DOT__execute__DOT__forwarded_rs1 
                                 < vlSelfRef.main__DOT__cpu__DOT__execute__DOT__alu_input_b)
                                 ? 1U : 0U) : (VL_LTS_III(32, vlSelfRef.main__DOT__cpu__DOT__execute__DOT__forwarded_rs1, vlSelfRef.main__DOT__cpu__DOT__execute__DOT__alu_input_b)
                                                ? 1U
                                                : 0U))))
            : ((0x200U & vlSelfRef.main__DOT__cpu__DOT__id_ex_control_signals)
                ? ((0x100U & vlSelfRef.main__DOT__cpu__DOT__id_ex_control_signals)
                    ? ((0x80U & vlSelfRef.main__DOT__cpu__DOT__id_ex_control_signals)
                        ? VL_SHIFTRS_III(32,32,5, vlSelfRef.main__DOT__cpu__DOT__execute__DOT__forwarded_rs1, 
                                         (0x1fU & vlSelfRef.main__DOT__cpu__DOT__execute__DOT__alu_input_b))
                        : (vlSelfRef.main__DOT__cpu__DOT__execute__DOT__forwarded_rs1 
                           >> (0x1fU & vlSelfRef.main__DOT__cpu__DOT__execute__DOT__alu_input_b)))
                    : ((0x80U & vlSelfRef.main__DOT__cpu__DOT__id_ex_control_signals)
                        ? (vlSelfRef.main__DOT__cpu__DOT__execute__DOT__forwarded_rs1 
                           << (0x1fU & vlSelfRef.main__DOT__cpu__DOT__execute__DOT__alu_input_b))
                        : (vlSelfRef.main__DOT__cpu__DOT__execute__DOT__forwarded_rs1 
                           ^ vlSelfRef.main__DOT__cpu__DOT__execute__DOT__alu_input_b)))
                : ((0x100U & vlSelfRef.main__DOT__cpu__DOT__id_ex_control_signals)
                    ? ((0x80U & vlSelfRef.main__DOT__cpu__DOT__id_ex_control_signals)
                        ? (vlSelfRef.main__DOT__cpu__DOT__execute__DOT__forwarded_rs1 
                           | vlSelfRef.main__DOT__cpu__DOT__execute__DOT__alu_input_b)
                        : (vlSelfRef.main__DOT__cpu__DOT__execute__DOT__forwarded_rs1 
                           & vlSelfRef.main__DOT__cpu__DOT__execute__DOT__alu_input_b))
                    : ((0x80U & vlSelfRef.main__DOT__cpu__DOT__id_ex_control_signals)
                        ? (vlSelfRef.main__DOT__cpu__DOT__execute__DOT__forwarded_rs1 
                           - vlSelfRef.main__DOT__cpu__DOT__execute__DOT__alu_input_b)
                        : (vlSelfRef.main__DOT__cpu__DOT__execute__DOT__forwarded_rs1 
                           + vlSelfRef.main__DOT__cpu__DOT__execute__DOT__alu_input_b)))));
    vlSelfRef.main__DOT__cpu__DOT__pc_src = 0U;
    vlSelfRef.main__DOT__cpu__DOT__new_pc = 0U;
    vlSelfRef.main__DOT__cpu__DOT__flush = 0U;
    if ((0x10U & vlSelfRef.main__DOT__cpu__DOT__id_ex_control_signals)) {
        if ((0x4000U & vlSelfRef.main__DOT__cpu__DOT__id_ex_instruction)) {
            if ((0x2000U & vlSelfRef.main__DOT__cpu__DOT__id_ex_instruction)) {
                if ((0x1000U & vlSelfRef.main__DOT__cpu__DOT__id_ex_instruction)) {
                    vlSelfRef.main__DOT__cpu__DOT__execute__DOT__branch_condition_met 
                        = (vlSelfRef.main__DOT__cpu__DOT__execute__DOT__forwarded_rs1 
                           >= vlSelfRef.main__DOT__cpu__DOT__execute__DOT__forwarded_rs2);
                    vlSelfRef.main__DOT__cpu__DOT__pc_src 
                        = (vlSelfRef.main__DOT__cpu__DOT__id_ex_rs1_data 
                           >= vlSelfRef.main__DOT__cpu__DOT__id_ex_rs2_data);
                } else {
                    vlSelfRef.main__DOT__cpu__DOT__execute__DOT__branch_condition_met 
                        = (vlSelfRef.main__DOT__cpu__DOT__execute__DOT__forwarded_rs1 
                           < vlSelfRef.main__DOT__cpu__DOT__execute__DOT__forwarded_rs2);
                    vlSelfRef.main__DOT__cpu__DOT__pc_src 
                        = (vlSelfRef.main__DOT__cpu__DOT__id_ex_rs1_data 
                           < vlSelfRef.main__DOT__cpu__DOT__id_ex_rs2_data);
                }
            } else if ((0x1000U & vlSelfRef.main__DOT__cpu__DOT__id_ex_instruction)) {
                vlSelfRef.main__DOT__cpu__DOT__execute__DOT__branch_condition_met 
                    = VL_GTES_III(32, vlSelfRef.main__DOT__cpu__DOT__execute__DOT__forwarded_rs1, vlSelfRef.main__DOT__cpu__DOT__execute__DOT__forwarded_rs2);
                vlSelfRef.main__DOT__cpu__DOT__pc_src 
                    = VL_GTES_III(32, vlSelfRef.main__DOT__cpu__DOT__id_ex_rs1_data, vlSelfRef.main__DOT__cpu__DOT__id_ex_rs2_data);
            } else {
                vlSelfRef.main__DOT__cpu__DOT__execute__DOT__branch_condition_met 
                    = VL_LTS_III(32, vlSelfRef.main__DOT__cpu__DOT__execute__DOT__forwarded_rs1, vlSelfRef.main__DOT__cpu__DOT__execute__DOT__forwarded_rs2);
                vlSelfRef.main__DOT__cpu__DOT__pc_src 
                    = VL_LTS_III(32, vlSelfRef.main__DOT__cpu__DOT__id_ex_rs1_data, vlSelfRef.main__DOT__cpu__DOT__id_ex_rs2_data);
            }
        } else {
            vlSelfRef.main__DOT__cpu__DOT__execute__DOT__branch_condition_met 
                = ((1U & (~ (vlSelfRef.main__DOT__cpu__DOT__id_ex_instruction 
                             >> 0xdU))) && ((0x1000U 
                                             & vlSelfRef.main__DOT__cpu__DOT__id_ex_instruction)
                                             ? (vlSelfRef.main__DOT__cpu__DOT__execute__DOT__forwarded_rs1 
                                                != vlSelfRef.main__DOT__cpu__DOT__execute__DOT__forwarded_rs2)
                                             : (vlSelfRef.main__DOT__cpu__DOT__execute__DOT__forwarded_rs1 
                                                == vlSelfRef.main__DOT__cpu__DOT__execute__DOT__forwarded_rs2)));
            vlSelfRef.main__DOT__cpu__DOT__pc_src = 
                ((1U & (~ (vlSelfRef.main__DOT__cpu__DOT__id_ex_instruction 
                           >> 0xdU))) && ((0x1000U 
                                           & vlSelfRef.main__DOT__cpu__DOT__id_ex_instruction)
                                           ? (vlSelfRef.main__DOT__cpu__DOT__id_ex_rs1_data 
                                              != vlSelfRef.main__DOT__cpu__DOT__id_ex_rs2_data)
                                           : (vlSelfRef.main__DOT__cpu__DOT__id_ex_rs1_data 
                                              == vlSelfRef.main__DOT__cpu__DOT__id_ex_rs2_data)));
        }
        if (vlSelfRef.main__DOT__cpu__DOT__pc_src) {
            vlSelfRef.main__DOT__cpu__DOT__new_pc = 
                (vlSelfRef.main__DOT__cpu__DOT__id_ex_pc 
                 + vlSelfRef.main__DOT__cpu__DOT__id_ex_immediate);
            vlSelfRef.main__DOT__cpu__DOT__flush = 1U;
        }
    } else if ((0x20U & vlSelfRef.main__DOT__cpu__DOT__id_ex_control_signals)) {
        vlSelfRef.main__DOT__cpu__DOT__pc_src = 1U;
        vlSelfRef.main__DOT__cpu__DOT__new_pc = (vlSelfRef.main__DOT__cpu__DOT__id_ex_pc 
                                                 + vlSelfRef.main__DOT__cpu__DOT__id_ex_immediate);
        vlSelfRef.main__DOT__cpu__DOT__flush = 1U;
    }
    vlSelfRef.debug_flush = vlSelfRef.main__DOT__cpu__DOT__flush;
    vlSelfRef.debug_instruction = vlSelfRef.main__DOT__cpu__DOT__if_id_instruction;
    vlSelfRef.main__DOT__cpu__DOT__instruction_decode__DOT__ctrl_unit__DOT__reg_write = 0U;
    vlSelfRef.main__DOT__cpu__DOT__instruction_decode__DOT__ctrl_unit__DOT__mem_to_reg = 0U;
    vlSelfRef.main__DOT__cpu__DOT__instruction_decode__DOT__ctrl_unit__DOT__mem_read = 0U;
    vlSelfRef.main__DOT__cpu__DOT__instruction_decode__DOT__ctrl_unit__DOT__mem_write = 0U;
    vlSelfRef.main__DOT__cpu__DOT__instruction_decode__DOT__ctrl_unit__DOT__branch = 0U;
    vlSelfRef.main__DOT__cpu__DOT__instruction_decode__DOT__ctrl_unit__DOT__jump = 0U;
    vlSelfRef.main__DOT__cpu__DOT__instruction_decode__DOT__ctrl_unit__DOT__alu_src = 0U;
    vlSelfRef.main__DOT__cpu__DOT__instruction_decode__DOT__ctrl_unit__DOT__alu_op = 0U;
    vlSelfRef.main__DOT__cpu__DOT__instruction_decode__DOT__ctrl_unit__DOT__imm_type = 0U;
    vlSelfRef.main__DOT__cpu__DOT__instruction_decode__DOT__ctrl_unit__DOT__pc_src = 0U;
    vlSelfRef.main__DOT__cpu__DOT__instruction_decode__DOT__control_signals = 0U;
    if ((0x40U & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)) {
        if ((0x20U & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)) {
            vlSelfRef.main__DOT__cpu__DOT__instruction_decode__DOT__immediate 
                = ((0x10U & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)
                    ? 0U : ((8U & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)
                             ? ((4U & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)
                                 ? ((2U & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)
                                     ? ((1U & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)
                                         ? ((((- (IData)(
                                                         (vlSelfRef.main__DOT__cpu__DOT__if_id_instruction 
                                                          >> 0x1fU))) 
                                              << 0x15U) 
                                             | (0x100000U 
                                                & (vlSelfRef.main__DOT__cpu__DOT__if_id_instruction 
                                                   >> 0xbU))) 
                                            | (((0xff000U 
                                                 & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction) 
                                                | (0x800U 
                                                   & (vlSelfRef.main__DOT__cpu__DOT__if_id_instruction 
                                                      >> 9U))) 
                                               | (0x7feU 
                                                  & (vlSelfRef.main__DOT__cpu__DOT__if_id_instruction 
                                                     >> 0x14U))))
                                         : 0U) : 0U)
                                 : 0U) : ((4U & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)
                                           ? ((2U & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)
                                               ? ((1U 
                                                   & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)
                                                   ? 
                                                  (((- (IData)(
                                                               (vlSelfRef.main__DOT__cpu__DOT__if_id_instruction 
                                                                >> 0x1fU))) 
                                                    << 0xcU) 
                                                   | (vlSelfRef.main__DOT__cpu__DOT__if_id_instruction 
                                                      >> 0x14U))
                                                   : 0U)
                                               : 0U)
                                           : ((2U & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)
                                               ? ((1U 
                                                   & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)
                                                   ? 
                                                  (((- (IData)(
                                                               (vlSelfRef.main__DOT__cpu__DOT__if_id_instruction 
                                                                >> 0x1fU))) 
                                                    << 0xcU) 
                                                   | ((0x800U 
                                                       & (vlSelfRef.main__DOT__cpu__DOT__if_id_instruction 
                                                          << 4U)) 
                                                      | ((0x7e0U 
                                                          & (vlSelfRef.main__DOT__cpu__DOT__if_id_instruction 
                                                             >> 0x14U)) 
                                                         | (0x1eU 
                                                            & (vlSelfRef.main__DOT__cpu__DOT__if_id_instruction 
                                                               >> 7U)))))
                                                   : 0U)
                                               : 0U))));
            if ((1U & (~ (vlSelfRef.main__DOT__cpu__DOT__if_id_instruction 
                          >> 4U)))) {
                if ((8U & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)) {
                    if ((4U & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)) {
                        if ((2U & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)) {
                            if ((1U & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)) {
                                vlSelfRef.main__DOT__cpu__DOT__instruction_decode__DOT__ctrl_unit__DOT__jump = 1U;
                                vlSelfRef.main__DOT__cpu__DOT__instruction_decode__DOT__ctrl_unit__DOT__reg_write = 1U;
                                vlSelfRef.main__DOT__cpu__DOT__instruction_decode__DOT__ctrl_unit__DOT__pc_src = 1U;
                                vlSelfRef.main__DOT__cpu__DOT__instruction_decode__DOT__ctrl_unit__DOT__imm_type = 3U;
                            }
                        }
                    }
                } else if ((4U & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)) {
                    if ((2U & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)) {
                        if ((1U & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)) {
                            vlSelfRef.main__DOT__cpu__DOT__instruction_decode__DOT__ctrl_unit__DOT__jump = 1U;
                            vlSelfRef.main__DOT__cpu__DOT__instruction_decode__DOT__ctrl_unit__DOT__reg_write = 1U;
                            vlSelfRef.main__DOT__cpu__DOT__instruction_decode__DOT__ctrl_unit__DOT__alu_src = 1U;
                            vlSelfRef.main__DOT__cpu__DOT__instruction_decode__DOT__ctrl_unit__DOT__pc_src = 2U;
                            vlSelfRef.main__DOT__cpu__DOT__instruction_decode__DOT__ctrl_unit__DOT__imm_type = 0U;
                        }
                    }
                } else if ((2U & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)) {
                    if ((1U & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)) {
                        vlSelfRef.main__DOT__cpu__DOT__instruction_decode__DOT__ctrl_unit__DOT__branch = 1U;
                        vlSelfRef.main__DOT__cpu__DOT__instruction_decode__DOT__ctrl_unit__DOT__alu_op = 1U;
                        vlSelfRef.main__DOT__cpu__DOT__instruction_decode__DOT__ctrl_unit__DOT__imm_type = 2U;
                    }
                }
            }
        } else {
            vlSelfRef.main__DOT__cpu__DOT__instruction_decode__DOT__immediate = 0U;
        }
    } else if ((0x20U & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)) {
        if ((0x10U & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)) {
            vlSelfRef.main__DOT__cpu__DOT__instruction_decode__DOT__immediate 
                = ((8U & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)
                    ? 0U : ((4U & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)
                             ? ((2U & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)
                                 ? ((1U & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)
                                     ? (0xfffff000U 
                                        & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)
                                     : 0U) : 0U) : 0U));
            if ((1U & (~ (vlSelfRef.main__DOT__cpu__DOT__if_id_instruction 
                          >> 3U)))) {
                if ((4U & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)) {
                    if ((2U & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)) {
                        if ((1U & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)) {
                            vlSelfRef.main__DOT__cpu__DOT__instruction_decode__DOT__ctrl_unit__DOT__reg_write = 1U;
                            vlSelfRef.main__DOT__cpu__DOT__instruction_decode__DOT__ctrl_unit__DOT__alu_src = 1U;
                            vlSelfRef.main__DOT__cpu__DOT__instruction_decode__DOT__ctrl_unit__DOT__alu_op = 0xaU;
                            vlSelfRef.main__DOT__cpu__DOT__instruction_decode__DOT__ctrl_unit__DOT__imm_type = 4U;
                        }
                    }
                } else if ((2U & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)) {
                    if ((1U & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)) {
                        vlSelfRef.main__DOT__cpu__DOT__instruction_decode__DOT__ctrl_unit__DOT__reg_write = 1U;
                        vlSelfRef.main__DOT__cpu__DOT__instruction_decode__DOT__ctrl_unit__DOT__alu_src = 0U;
                        vlSelfRef.main__DOT__cpu__DOT__instruction_decode__DOT__ctrl_unit__DOT__alu_op 
                            = ((0x4000U & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)
                                ? ((0x2000U & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)
                                    ? ((0x1000U & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)
                                        ? 9U : 8U) : 
                                   ((0x1000U & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)
                                     ? ((0x40000000U 
                                         & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)
                                         ? 7U : 6U)
                                     : 5U)) : ((0x2000U 
                                                & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)
                                                ? (
                                                   (0x1000U 
                                                    & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)
                                                    ? 4U
                                                    : 3U)
                                                : (
                                                   (0x1000U 
                                                    & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)
                                                    ? 2U
                                                    : 
                                                   ((0x40000000U 
                                                     & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)
                                                     ? 1U
                                                     : 0U))));
                    }
                }
            }
        } else {
            vlSelfRef.main__DOT__cpu__DOT__instruction_decode__DOT__immediate 
                = ((8U & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)
                    ? 0U : ((4U & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)
                             ? 0U : ((2U & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)
                                      ? ((1U & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)
                                          ? (((- (IData)(
                                                         (vlSelfRef.main__DOT__cpu__DOT__if_id_instruction 
                                                          >> 0x1fU))) 
                                              << 0xcU) 
                                             | ((0xfe0U 
                                                 & (vlSelfRef.main__DOT__cpu__DOT__if_id_instruction 
                                                    >> 0x14U)) 
                                                | (0x1fU 
                                                   & (vlSelfRef.main__DOT__cpu__DOT__if_id_instruction 
                                                      >> 7U))))
                                          : 0U) : 0U)));
            if ((1U & (~ (vlSelfRef.main__DOT__cpu__DOT__if_id_instruction 
                          >> 3U)))) {
                if ((1U & (~ (vlSelfRef.main__DOT__cpu__DOT__if_id_instruction 
                              >> 2U)))) {
                    if ((2U & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)) {
                        if ((1U & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)) {
                            vlSelfRef.main__DOT__cpu__DOT__instruction_decode__DOT__ctrl_unit__DOT__mem_write = 1U;
                            vlSelfRef.main__DOT__cpu__DOT__instruction_decode__DOT__ctrl_unit__DOT__alu_src = 1U;
                            vlSelfRef.main__DOT__cpu__DOT__instruction_decode__DOT__ctrl_unit__DOT__alu_op = 0U;
                            vlSelfRef.main__DOT__cpu__DOT__instruction_decode__DOT__ctrl_unit__DOT__imm_type = 1U;
                        }
                    }
                }
            }
        }
    } else if ((0x10U & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)) {
        vlSelfRef.main__DOT__cpu__DOT__instruction_decode__DOT__immediate 
            = ((8U & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)
                ? 0U : ((4U & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)
                         ? ((2U & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)
                             ? ((1U & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)
                                 ? (0xfffff000U & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)
                                 : 0U) : 0U) : ((2U 
                                                 & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)
                                                 ? 
                                                ((1U 
                                                  & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)
                                                  ? 
                                                 (((- (IData)(
                                                              (vlSelfRef.main__DOT__cpu__DOT__if_id_instruction 
                                                               >> 0x1fU))) 
                                                   << 0xcU) 
                                                  | (vlSelfRef.main__DOT__cpu__DOT__if_id_instruction 
                                                     >> 0x14U))
                                                  : 0U)
                                                 : 0U)));
        if ((1U & (~ (vlSelfRef.main__DOT__cpu__DOT__if_id_instruction 
                      >> 3U)))) {
            if ((4U & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)) {
                if ((2U & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)) {
                    if ((1U & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)) {
                        vlSelfRef.main__DOT__cpu__DOT__instruction_decode__DOT__ctrl_unit__DOT__reg_write = 1U;
                        vlSelfRef.main__DOT__cpu__DOT__instruction_decode__DOT__ctrl_unit__DOT__alu_src = 1U;
                        vlSelfRef.main__DOT__cpu__DOT__instruction_decode__DOT__ctrl_unit__DOT__alu_op = 0U;
                        vlSelfRef.main__DOT__cpu__DOT__instruction_decode__DOT__ctrl_unit__DOT__imm_type = 4U;
                        vlSelfRef.main__DOT__cpu__DOT__instruction_decode__DOT__ctrl_unit__DOT__pc_src = 3U;
                    }
                }
            } else if ((2U & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)) {
                if ((1U & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)) {
                    vlSelfRef.main__DOT__cpu__DOT__instruction_decode__DOT__ctrl_unit__DOT__reg_write = 1U;
                    vlSelfRef.main__DOT__cpu__DOT__instruction_decode__DOT__ctrl_unit__DOT__alu_src = 1U;
                    vlSelfRef.main__DOT__cpu__DOT__instruction_decode__DOT__ctrl_unit__DOT__imm_type = 0U;
                    vlSelfRef.main__DOT__cpu__DOT__instruction_decode__DOT__ctrl_unit__DOT__alu_op 
                        = ((0x4000U & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)
                            ? ((0x2000U & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)
                                ? ((0x1000U & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)
                                    ? 9U : 8U) : ((0x1000U 
                                                   & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)
                                                   ? 
                                                  ((0x40000000U 
                                                    & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)
                                                    ? 7U
                                                    : 6U)
                                                   : 5U))
                            : ((0x2000U & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)
                                ? ((0x1000U & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)
                                    ? 4U : 3U) : ((0x1000U 
                                                   & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)
                                                   ? 2U
                                                   : 0U)));
                }
            }
        }
    } else {
        vlSelfRef.main__DOT__cpu__DOT__instruction_decode__DOT__immediate 
            = ((8U & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)
                ? 0U : ((4U & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)
                         ? 0U : ((2U & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)
                                  ? ((1U & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)
                                      ? (((- (IData)(
                                                     (vlSelfRef.main__DOT__cpu__DOT__if_id_instruction 
                                                      >> 0x1fU))) 
                                          << 0xcU) 
                                         | (vlSelfRef.main__DOT__cpu__DOT__if_id_instruction 
                                            >> 0x14U))
                                      : 0U) : 0U)));
        if ((1U & (~ (vlSelfRef.main__DOT__cpu__DOT__if_id_instruction 
                      >> 3U)))) {
            if ((1U & (~ (vlSelfRef.main__DOT__cpu__DOT__if_id_instruction 
                          >> 2U)))) {
                if ((2U & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)) {
                    if ((1U & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)) {
                        vlSelfRef.main__DOT__cpu__DOT__instruction_decode__DOT__ctrl_unit__DOT__reg_write = 1U;
                        vlSelfRef.main__DOT__cpu__DOT__instruction_decode__DOT__ctrl_unit__DOT__mem_to_reg = 1U;
                        vlSelfRef.main__DOT__cpu__DOT__instruction_decode__DOT__ctrl_unit__DOT__mem_read = 1U;
                        vlSelfRef.main__DOT__cpu__DOT__instruction_decode__DOT__ctrl_unit__DOT__alu_src = 1U;
                        vlSelfRef.main__DOT__cpu__DOT__instruction_decode__DOT__ctrl_unit__DOT__alu_op = 0U;
                        vlSelfRef.main__DOT__cpu__DOT__instruction_decode__DOT__ctrl_unit__DOT__imm_type = 0U;
                    }
                }
            }
        }
    }
    vlSelfRef.main__DOT__cpu__DOT__instruction_decode__DOT__control_signals 
        = ((0xffff0U & vlSelfRef.main__DOT__cpu__DOT__instruction_decode__DOT__control_signals) 
           | ((((IData)(vlSelfRef.main__DOT__cpu__DOT__instruction_decode__DOT__ctrl_unit__DOT__mem_write) 
                << 3U) | ((IData)(vlSelfRef.main__DOT__cpu__DOT__instruction_decode__DOT__ctrl_unit__DOT__mem_read) 
                          << 2U)) | (((IData)(vlSelfRef.main__DOT__cpu__DOT__instruction_decode__DOT__ctrl_unit__DOT__mem_to_reg) 
                                      << 1U) | (IData)(vlSelfRef.main__DOT__cpu__DOT__instruction_decode__DOT__ctrl_unit__DOT__reg_write))));
    vlSelfRef.main__DOT__cpu__DOT__instruction_decode__DOT__control_signals 
        = ((0xff80fU & vlSelfRef.main__DOT__cpu__DOT__instruction_decode__DOT__control_signals) 
           | (((IData)(vlSelfRef.main__DOT__cpu__DOT__instruction_decode__DOT__ctrl_unit__DOT__alu_op) 
               << 7U) | (((IData)(vlSelfRef.main__DOT__cpu__DOT__instruction_decode__DOT__ctrl_unit__DOT__alu_src) 
                          << 6U) | (((IData)(vlSelfRef.main__DOT__cpu__DOT__instruction_decode__DOT__ctrl_unit__DOT__jump) 
                                     << 5U) | ((IData)(vlSelfRef.main__DOT__cpu__DOT__instruction_decode__DOT__ctrl_unit__DOT__branch) 
                                               << 4U)))));
    vlSelfRef.main__DOT__cpu__DOT__instruction_decode__DOT__control_signals 
        = ((0xf07ffU & vlSelfRef.main__DOT__cpu__DOT__instruction_decode__DOT__control_signals) 
           | (((IData)(vlSelfRef.main__DOT__cpu__DOT__instruction_decode__DOT__ctrl_unit__DOT__pc_src) 
               << 0xeU) | ((IData)(vlSelfRef.main__DOT__cpu__DOT__instruction_decode__DOT__ctrl_unit__DOT__imm_type) 
                           << 0xbU)));
    vlSelfRef.main__DOT__cpu__DOT__control_unit__DOT__reg_write = 0U;
    vlSelfRef.main__DOT__cpu__DOT__control_unit__DOT__mem_to_reg = 0U;
    vlSelfRef.main__DOT__cpu__DOT__control_unit__DOT__mem_read = 0U;
    vlSelfRef.main__DOT__cpu__DOT__control_unit__DOT__mem_write = 0U;
    vlSelfRef.main__DOT__cpu__DOT__control_unit__DOT__branch = 0U;
    vlSelfRef.main__DOT__cpu__DOT__control_unit__DOT__jump = 0U;
    vlSelfRef.main__DOT__cpu__DOT__control_unit__DOT__alu_src = 0U;
    vlSelfRef.main__DOT__cpu__DOT__control_unit__DOT__alu_op = 0U;
    vlSelfRef.main__DOT__cpu__DOT__control_unit__DOT__imm_type = 0U;
    vlSelfRef.main__DOT__cpu__DOT__control_unit__DOT__pc_src = 0U;
    if ((0x40U & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)) {
        if ((0x20U & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)) {
            if ((1U & (~ (vlSelfRef.main__DOT__cpu__DOT__if_id_instruction 
                          >> 4U)))) {
                if ((8U & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)) {
                    if ((4U & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)) {
                        if ((2U & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)) {
                            if ((1U & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)) {
                                vlSelfRef.main__DOT__cpu__DOT__control_unit__DOT__jump = 1U;
                                vlSelfRef.main__DOT__cpu__DOT__control_unit__DOT__reg_write = 1U;
                                vlSelfRef.main__DOT__cpu__DOT__control_unit__DOT__pc_src = 1U;
                                vlSelfRef.main__DOT__cpu__DOT__control_unit__DOT__imm_type = 3U;
                            }
                        }
                    }
                } else if ((4U & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)) {
                    if ((2U & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)) {
                        if ((1U & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)) {
                            vlSelfRef.main__DOT__cpu__DOT__control_unit__DOT__jump = 1U;
                            vlSelfRef.main__DOT__cpu__DOT__control_unit__DOT__reg_write = 1U;
                            vlSelfRef.main__DOT__cpu__DOT__control_unit__DOT__alu_src = 1U;
                            vlSelfRef.main__DOT__cpu__DOT__control_unit__DOT__pc_src = 2U;
                            vlSelfRef.main__DOT__cpu__DOT__control_unit__DOT__imm_type = 0U;
                        }
                    }
                } else if ((2U & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)) {
                    if ((1U & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)) {
                        vlSelfRef.main__DOT__cpu__DOT__control_unit__DOT__branch = 1U;
                        vlSelfRef.main__DOT__cpu__DOT__control_unit__DOT__alu_op = 1U;
                        vlSelfRef.main__DOT__cpu__DOT__control_unit__DOT__imm_type = 2U;
                    }
                }
            }
        }
    } else if ((0x20U & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)) {
        if ((0x10U & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)) {
            if ((1U & (~ (vlSelfRef.main__DOT__cpu__DOT__if_id_instruction 
                          >> 3U)))) {
                if ((4U & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)) {
                    if ((2U & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)) {
                        if ((1U & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)) {
                            vlSelfRef.main__DOT__cpu__DOT__control_unit__DOT__reg_write = 1U;
                            vlSelfRef.main__DOT__cpu__DOT__control_unit__DOT__alu_src = 1U;
                            vlSelfRef.main__DOT__cpu__DOT__control_unit__DOT__alu_op = 0xaU;
                            vlSelfRef.main__DOT__cpu__DOT__control_unit__DOT__imm_type = 4U;
                        }
                    }
                } else if ((2U & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)) {
                    if ((1U & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)) {
                        vlSelfRef.main__DOT__cpu__DOT__control_unit__DOT__reg_write = 1U;
                        vlSelfRef.main__DOT__cpu__DOT__control_unit__DOT__alu_src = 0U;
                        vlSelfRef.main__DOT__cpu__DOT__control_unit__DOT__alu_op 
                            = ((0x4000U & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)
                                ? ((0x2000U & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)
                                    ? ((0x1000U & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)
                                        ? 9U : 8U) : 
                                   ((0x1000U & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)
                                     ? ((0x40000000U 
                                         & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)
                                         ? 7U : 6U)
                                     : 5U)) : ((0x2000U 
                                                & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)
                                                ? (
                                                   (0x1000U 
                                                    & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)
                                                    ? 4U
                                                    : 3U)
                                                : (
                                                   (0x1000U 
                                                    & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)
                                                    ? 2U
                                                    : 
                                                   ((0x40000000U 
                                                     & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)
                                                     ? 1U
                                                     : 0U))));
                    }
                }
            }
        } else if ((1U & (~ (vlSelfRef.main__DOT__cpu__DOT__if_id_instruction 
                             >> 3U)))) {
            if ((1U & (~ (vlSelfRef.main__DOT__cpu__DOT__if_id_instruction 
                          >> 2U)))) {
                if ((2U & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)) {
                    if ((1U & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)) {
                        vlSelfRef.main__DOT__cpu__DOT__control_unit__DOT__mem_write = 1U;
                        vlSelfRef.main__DOT__cpu__DOT__control_unit__DOT__alu_src = 1U;
                        vlSelfRef.main__DOT__cpu__DOT__control_unit__DOT__alu_op = 0U;
                        vlSelfRef.main__DOT__cpu__DOT__control_unit__DOT__imm_type = 1U;
                    }
                }
            }
        }
    } else if ((0x10U & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)) {
        if ((1U & (~ (vlSelfRef.main__DOT__cpu__DOT__if_id_instruction 
                      >> 3U)))) {
            if ((4U & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)) {
                if ((2U & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)) {
                    if ((1U & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)) {
                        vlSelfRef.main__DOT__cpu__DOT__control_unit__DOT__reg_write = 1U;
                        vlSelfRef.main__DOT__cpu__DOT__control_unit__DOT__alu_src = 1U;
                        vlSelfRef.main__DOT__cpu__DOT__control_unit__DOT__alu_op = 0U;
                        vlSelfRef.main__DOT__cpu__DOT__control_unit__DOT__imm_type = 4U;
                        vlSelfRef.main__DOT__cpu__DOT__control_unit__DOT__pc_src = 3U;
                    }
                }
            } else if ((2U & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)) {
                if ((1U & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)) {
                    vlSelfRef.main__DOT__cpu__DOT__control_unit__DOT__reg_write = 1U;
                    vlSelfRef.main__DOT__cpu__DOT__control_unit__DOT__alu_src = 1U;
                    vlSelfRef.main__DOT__cpu__DOT__control_unit__DOT__imm_type = 0U;
                    vlSelfRef.main__DOT__cpu__DOT__control_unit__DOT__alu_op 
                        = ((0x4000U & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)
                            ? ((0x2000U & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)
                                ? ((0x1000U & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)
                                    ? 9U : 8U) : ((0x1000U 
                                                   & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)
                                                   ? 
                                                  ((0x40000000U 
                                                    & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)
                                                    ? 7U
                                                    : 6U)
                                                   : 5U))
                            : ((0x2000U & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)
                                ? ((0x1000U & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)
                                    ? 4U : 3U) : ((0x1000U 
                                                   & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)
                                                   ? 2U
                                                   : 0U)));
                }
            }
        }
    } else if ((1U & (~ (vlSelfRef.main__DOT__cpu__DOT__if_id_instruction 
                         >> 3U)))) {
        if ((1U & (~ (vlSelfRef.main__DOT__cpu__DOT__if_id_instruction 
                      >> 2U)))) {
            if ((2U & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)) {
                if ((1U & vlSelfRef.main__DOT__cpu__DOT__if_id_instruction)) {
                    vlSelfRef.main__DOT__cpu__DOT__control_unit__DOT__reg_write = 1U;
                    vlSelfRef.main__DOT__cpu__DOT__control_unit__DOT__mem_to_reg = 1U;
                    vlSelfRef.main__DOT__cpu__DOT__control_unit__DOT__mem_read = 1U;
                    vlSelfRef.main__DOT__cpu__DOT__control_unit__DOT__alu_src = 1U;
                    vlSelfRef.main__DOT__cpu__DOT__control_unit__DOT__alu_op = 0U;
                    vlSelfRef.main__DOT__cpu__DOT__control_unit__DOT__imm_type = 0U;
                }
            }
        }
    }
    vlSelfRef.main__DOT__cpu__DOT__control_signals = 0U;
    vlSelfRef.main__DOT__cpu__DOT__control_signals 
        = ((0xffff0U & vlSelfRef.main__DOT__cpu__DOT__control_signals) 
           | ((((IData)(vlSelfRef.main__DOT__cpu__DOT__control_unit__DOT__mem_write) 
                << 3U) | ((IData)(vlSelfRef.main__DOT__cpu__DOT__control_unit__DOT__mem_read) 
                          << 2U)) | (((IData)(vlSelfRef.main__DOT__cpu__DOT__control_unit__DOT__mem_to_reg) 
                                      << 1U) | (IData)(vlSelfRef.main__DOT__cpu__DOT__control_unit__DOT__reg_write))));
    vlSelfRef.main__DOT__cpu__DOT__control_signals 
        = ((0xff80fU & vlSelfRef.main__DOT__cpu__DOT__control_signals) 
           | (((IData)(vlSelfRef.main__DOT__cpu__DOT__control_unit__DOT__alu_op) 
               << 7U) | (((IData)(vlSelfRef.main__DOT__cpu__DOT__control_unit__DOT__alu_src) 
                          << 6U) | (((IData)(vlSelfRef.main__DOT__cpu__DOT__control_unit__DOT__jump) 
                                     << 5U) | ((IData)(vlSelfRef.main__DOT__cpu__DOT__control_unit__DOT__branch) 
                                               << 4U)))));
    vlSelfRef.main__DOT__cpu__DOT__control_signals 
        = ((0xf07ffU & vlSelfRef.main__DOT__cpu__DOT__control_signals) 
           | (((IData)(vlSelfRef.main__DOT__cpu__DOT__control_unit__DOT__pc_src) 
               << 0xeU) | ((IData)(vlSelfRef.main__DOT__cpu__DOT__control_unit__DOT__imm_type) 
                           << 0xbU)));
    vlSelfRef.debug_stall = ((vlSelfRef.main__DOT__cpu__DOT__id_ex_control_signals 
                              >> 2U) & ((0U != (IData)(vlSelfRef.main__DOT__cpu__DOT__id_ex_rd_addr)) 
                                        & (((IData)(vlSelfRef.main__DOT__cpu__DOT__id_ex_rd_addr) 
                                            == (0x1fU 
                                                & (vlSelfRef.main__DOT__cpu__DOT__if_id_instruction 
                                                   >> 0xfU))) 
                                           | ((IData)(vlSelfRef.main__DOT__cpu__DOT__id_ex_rd_addr) 
                                              == (0x1fU 
                                                  & (vlSelfRef.main__DOT__cpu__DOT__if_id_instruction 
                                                     >> 0x14U))))));
    vlSelfRef.main__DOT__cpu__DOT__instruction_fetch__DOT__pc_next 
        = ((IData)(vlSelfRef.main__DOT__cpu__DOT__pc_src)
            ? vlSelfRef.main__DOT__cpu__DOT__new_pc
            : ((IData)(4U) + vlSelfRef.main__DOT__cpu__DOT__instruction_fetch__DOT__pc_reg));
}

VL_INLINE_OPT void Vmain___024root___nba_comb__TOP__0(Vmain___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vmain__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vmain___024root___nba_comb__TOP__0\n"); );
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.main__DOT__dmem_data_in = vlSelfRef.main__DOT__dmem_internal
        [(0xffU & (vlSelfRef.main__DOT__cpu__DOT__ex_mem_alu_result 
                   >> 2U))];
    if ((4U & vlSelfRef.main__DOT__cpu__DOT__ex_mem_control_signals)) {
        if ((0U == (7U & (vlSelfRef.main__DOT__cpu__DOT__ex_mem_control_signals 
                          >> 0xcU)))) {
            vlSelfRef.main__DOT__cpu__DOT__memory_access__DOT__read_data 
                = ((2U & vlSelfRef.main__DOT__cpu__DOT__ex_mem_alu_result)
                    ? ((1U & vlSelfRef.main__DOT__cpu__DOT__ex_mem_alu_result)
                        ? ((0x8000U & vlSelfRef.main__DOT__cpu__DOT__ex_mem_control_signals)
                            ? (vlSelfRef.main__DOT__dmem_data_in 
                               >> 0x18U) : (((- (IData)(
                                                        (vlSelfRef.main__DOT__dmem_data_in 
                                                         >> 0x1fU))) 
                                             << 8U) 
                                            | (vlSelfRef.main__DOT__dmem_data_in 
                                               >> 0x18U)))
                        : ((0x8000U & vlSelfRef.main__DOT__cpu__DOT__ex_mem_control_signals)
                            ? (0xffU & (vlSelfRef.main__DOT__dmem_data_in 
                                        >> 0x10U)) : 
                           (((- (IData)((1U & (vlSelfRef.main__DOT__dmem_data_in 
                                               >> 0x17U)))) 
                             << 8U) | (0xffU & (vlSelfRef.main__DOT__dmem_data_in 
                                                >> 0x10U)))))
                    : ((1U & vlSelfRef.main__DOT__cpu__DOT__ex_mem_alu_result)
                        ? ((0x8000U & vlSelfRef.main__DOT__cpu__DOT__ex_mem_control_signals)
                            ? (0xffU & (vlSelfRef.main__DOT__dmem_data_in 
                                        >> 8U)) : (
                                                   ((- (IData)(
                                                               (1U 
                                                                & (vlSelfRef.main__DOT__dmem_data_in 
                                                                   >> 0xfU)))) 
                                                    << 8U) 
                                                   | (0xffU 
                                                      & (vlSelfRef.main__DOT__dmem_data_in 
                                                         >> 8U))))
                        : ((0x8000U & vlSelfRef.main__DOT__cpu__DOT__ex_mem_control_signals)
                            ? (0xffU & vlSelfRef.main__DOT__dmem_data_in)
                            : (((- (IData)((1U & (vlSelfRef.main__DOT__dmem_data_in 
                                                  >> 7U)))) 
                                << 8U) | (0xffU & vlSelfRef.main__DOT__dmem_data_in)))));
        } else if ((1U == (7U & (vlSelfRef.main__DOT__cpu__DOT__ex_mem_control_signals 
                                 >> 0xcU)))) {
            if ((2U & vlSelfRef.main__DOT__cpu__DOT__ex_mem_alu_result)) {
                if ((2U & vlSelfRef.main__DOT__cpu__DOT__ex_mem_alu_result)) {
                    vlSelfRef.main__DOT__cpu__DOT__memory_access__DOT__read_data 
                        = ((0x8000U & vlSelfRef.main__DOT__cpu__DOT__ex_mem_control_signals)
                            ? (vlSelfRef.main__DOT__dmem_data_in 
                               >> 0x10U) : (((- (IData)(
                                                        (vlSelfRef.main__DOT__dmem_data_in 
                                                         >> 0x1fU))) 
                                             << 0x10U) 
                                            | (vlSelfRef.main__DOT__dmem_data_in 
                                               >> 0x10U)));
                }
            } else {
                vlSelfRef.main__DOT__cpu__DOT__memory_access__DOT__read_data 
                    = ((0x8000U & vlSelfRef.main__DOT__cpu__DOT__ex_mem_control_signals)
                        ? (0xffffU & vlSelfRef.main__DOT__dmem_data_in)
                        : (((- (IData)((1U & (vlSelfRef.main__DOT__dmem_data_in 
                                              >> 0xfU)))) 
                            << 0x10U) | (0xffffU & vlSelfRef.main__DOT__dmem_data_in)));
            }
        } else {
            vlSelfRef.main__DOT__cpu__DOT__memory_access__DOT__read_data 
                = vlSelfRef.main__DOT__dmem_data_in;
        }
    } else {
        vlSelfRef.main__DOT__cpu__DOT__memory_access__DOT__read_data = 0U;
    }
}

void Vmain___024root___eval_triggers__act(Vmain___024root* vlSelf);

bool Vmain___024root___eval_phase__act(Vmain___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vmain__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vmain___024root___eval_phase__act\n"); );
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    VlTriggerVec<2> __VpreTriggered;
    CData/*0:0*/ __VactExecute;
    // Body
    Vmain___024root___eval_triggers__act(vlSelf);
    __VactExecute = vlSelfRef.__VactTriggered.any();
    if (__VactExecute) {
        __VpreTriggered.andNot(vlSelfRef.__VactTriggered, vlSelfRef.__VnbaTriggered);
        vlSelfRef.__VnbaTriggered.thisOr(vlSelfRef.__VactTriggered);
        Vmain___024root___eval_act(vlSelf);
    }
    return (__VactExecute);
}

bool Vmain___024root___eval_phase__nba(Vmain___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vmain__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vmain___024root___eval_phase__nba\n"); );
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    CData/*0:0*/ __VnbaExecute;
    // Body
    __VnbaExecute = vlSelfRef.__VnbaTriggered.any();
    if (__VnbaExecute) {
        Vmain___024root___eval_nba(vlSelf);
        vlSelfRef.__VnbaTriggered.clear();
    }
    return (__VnbaExecute);
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vmain___024root___dump_triggers__ico(Vmain___024root* vlSelf);
#endif  // VL_DEBUG
#ifdef VL_DEBUG
VL_ATTR_COLD void Vmain___024root___dump_triggers__nba(Vmain___024root* vlSelf);
#endif  // VL_DEBUG
#ifdef VL_DEBUG
VL_ATTR_COLD void Vmain___024root___dump_triggers__act(Vmain___024root* vlSelf);
#endif  // VL_DEBUG

void Vmain___024root___eval(Vmain___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vmain__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vmain___024root___eval\n"); );
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    IData/*31:0*/ __VicoIterCount;
    CData/*0:0*/ __VicoContinue;
    IData/*31:0*/ __VnbaIterCount;
    CData/*0:0*/ __VnbaContinue;
    // Body
    __VicoIterCount = 0U;
    vlSelfRef.__VicoFirstIteration = 1U;
    __VicoContinue = 1U;
    while (__VicoContinue) {
        if (VL_UNLIKELY((0x64U < __VicoIterCount))) {
#ifdef VL_DEBUG
            Vmain___024root___dump_triggers__ico(vlSelf);
#endif
            VL_FATAL_MT("main.sv", 3, "", "Input combinational region did not converge.");
        }
        __VicoIterCount = ((IData)(1U) + __VicoIterCount);
        __VicoContinue = 0U;
        if (Vmain___024root___eval_phase__ico(vlSelf)) {
            __VicoContinue = 1U;
        }
        vlSelfRef.__VicoFirstIteration = 0U;
    }
    __VnbaIterCount = 0U;
    __VnbaContinue = 1U;
    while (__VnbaContinue) {
        if (VL_UNLIKELY((0x64U < __VnbaIterCount))) {
#ifdef VL_DEBUG
            Vmain___024root___dump_triggers__nba(vlSelf);
#endif
            VL_FATAL_MT("main.sv", 3, "", "NBA region did not converge.");
        }
        __VnbaIterCount = ((IData)(1U) + __VnbaIterCount);
        __VnbaContinue = 0U;
        vlSelfRef.__VactIterCount = 0U;
        vlSelfRef.__VactContinue = 1U;
        while (vlSelfRef.__VactContinue) {
            if (VL_UNLIKELY((0x64U < vlSelfRef.__VactIterCount))) {
#ifdef VL_DEBUG
                Vmain___024root___dump_triggers__act(vlSelf);
#endif
                VL_FATAL_MT("main.sv", 3, "", "Active region did not converge.");
            }
            vlSelfRef.__VactIterCount = ((IData)(1U) 
                                         + vlSelfRef.__VactIterCount);
            vlSelfRef.__VactContinue = 0U;
            if (Vmain___024root___eval_phase__act(vlSelf)) {
                vlSelfRef.__VactContinue = 1U;
            }
        }
        if (Vmain___024root___eval_phase__nba(vlSelf)) {
            __VnbaContinue = 1U;
        }
    }
}

#ifdef VL_DEBUG
void Vmain___024root___eval_debug_assertions(Vmain___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vmain__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vmain___024root___eval_debug_assertions\n"); );
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if (VL_UNLIKELY((vlSelfRef.clk & 0xfeU))) {
        Verilated::overWidthError("clk");}
    if (VL_UNLIKELY((vlSelfRef.reset & 0xfeU))) {
        Verilated::overWidthError("reset");}
    if (VL_UNLIKELY((vlSelfRef.step_en & 0xfeU))) {
        Verilated::overWidthError("step_en");}
}
#endif  // VL_DEBUG
