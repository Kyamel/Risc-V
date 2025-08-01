// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vmain.h for the primary calling header

#include "Vmain__pch.h"
#include "Vmain___024root.h"

VL_ATTR_COLD void Vmain___024root___eval_static(Vmain___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vmain__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vmain___024root___eval_static\n"); );
    auto& vlSelfRef = std::ref(*vlSelf).get();
}

VL_ATTR_COLD void Vmain___024root___eval_initial__TOP(Vmain___024root* vlSelf);
VL_ATTR_COLD void Vmain___024root____Vm_traceActivitySetAll(Vmain___024root* vlSelf);

VL_ATTR_COLD void Vmain___024root___eval_initial(Vmain___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vmain__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vmain___024root___eval_initial\n"); );
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    Vmain___024root___eval_initial__TOP(vlSelf);
    Vmain___024root____Vm_traceActivitySetAll(vlSelf);
    vlSelfRef.__Vtrigprevexpr___TOP__main__DOT__cpu_clk__0 
        = vlSelfRef.main__DOT__cpu_clk;
    vlSelfRef.__Vtrigprevexpr___TOP__reset__0 = vlSelfRef.reset;
}

VL_ATTR_COLD void Vmain___024root___eval_initial__TOP(Vmain___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vmain__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vmain___024root___eval_initial__TOP\n"); );
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.main__DOT__debug_registers_internal[0U] = 0U;
    vlSelfRef.main__DOT__unnamedblk1__DOT__i = 0U;
    while (VL_GTS_III(32, 0x100U, vlSelfRef.main__DOT__unnamedblk1__DOT__i)) {
        vlSelfRef.main__DOT__imem_internal[(0xffU & vlSelfRef.main__DOT__unnamedblk1__DOT__i)] = 0U;
        vlSelfRef.main__DOT__dmem_internal[(0xffU & vlSelfRef.main__DOT__unnamedblk1__DOT__i)] = 0U;
        vlSelfRef.main__DOT__unnamedblk1__DOT__i = 
            ((IData)(1U) + vlSelfRef.main__DOT__unnamedblk1__DOT__i);
    }
}

VL_ATTR_COLD void Vmain___024root___eval_final(Vmain___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vmain__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vmain___024root___eval_final\n"); );
    auto& vlSelfRef = std::ref(*vlSelf).get();
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vmain___024root___dump_triggers__stl(Vmain___024root* vlSelf);
#endif  // VL_DEBUG
VL_ATTR_COLD bool Vmain___024root___eval_phase__stl(Vmain___024root* vlSelf);

VL_ATTR_COLD void Vmain___024root___eval_settle(Vmain___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vmain__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vmain___024root___eval_settle\n"); );
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    IData/*31:0*/ __VstlIterCount;
    CData/*0:0*/ __VstlContinue;
    // Body
    __VstlIterCount = 0U;
    vlSelfRef.__VstlFirstIteration = 1U;
    __VstlContinue = 1U;
    while (__VstlContinue) {
        if (VL_UNLIKELY((0x64U < __VstlIterCount))) {
#ifdef VL_DEBUG
            Vmain___024root___dump_triggers__stl(vlSelf);
#endif
            VL_FATAL_MT("main.sv", 3, "", "Settle region did not converge.");
        }
        __VstlIterCount = ((IData)(1U) + __VstlIterCount);
        __VstlContinue = 0U;
        if (Vmain___024root___eval_phase__stl(vlSelf)) {
            __VstlContinue = 1U;
        }
        vlSelfRef.__VstlFirstIteration = 0U;
    }
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vmain___024root___dump_triggers__stl(Vmain___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vmain__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vmain___024root___dump_triggers__stl\n"); );
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((1U & (~ vlSelfRef.__VstlTriggered.any()))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if ((1ULL & vlSelfRef.__VstlTriggered.word(0U))) {
        VL_DBG_MSGF("         'stl' region trigger index 0 is active: Internal 'stl' trigger - first iteration\n");
    }
}
#endif  // VL_DEBUG

VL_ATTR_COLD void Vmain___024root___stl_sequent__TOP__0(Vmain___024root* vlSelf);

VL_ATTR_COLD void Vmain___024root___eval_stl(Vmain___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vmain__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vmain___024root___eval_stl\n"); );
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((1ULL & vlSelfRef.__VstlTriggered.word(0U))) {
        Vmain___024root___stl_sequent__TOP__0(vlSelf);
        Vmain___024root____Vm_traceActivitySetAll(vlSelf);
    }
}

VL_ATTR_COLD void Vmain___024root___stl_sequent__TOP__0(Vmain___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vmain__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vmain___024root___stl_sequent__TOP__0\n"); );
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.debug_pc = vlSelfRef.main__DOT__cpu__DOT__if_id_pc;
    vlSelfRef.debug_instruction = vlSelfRef.main__DOT__cpu__DOT__if_id_instruction;
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
    vlSelfRef.main__DOT__cpu_clk = ((IData)(vlSelfRef.clk) 
                                    & (IData)(vlSelfRef.step_en));
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
    vlSelfRef.main__DOT__cpu__DOT__wb_data = ((2U & vlSelfRef.main__DOT__cpu__DOT__mem_wb_control_signals)
                                               ? vlSelfRef.main__DOT__cpu__DOT__mem_wb_mem_data
                                               : vlSelfRef.main__DOT__cpu__DOT__mem_wb_alu_result);
    vlSelfRef.main__DOT__dmem_data_in = vlSelfRef.main__DOT__dmem_internal
        [(0xffU & (vlSelfRef.main__DOT__cpu__DOT__ex_mem_alu_result 
                   >> 2U))];
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
    vlSelfRef.main__DOT__cpu__DOT__pc_src = 0U;
    vlSelfRef.main__DOT__cpu__DOT__new_pc = 0U;
    vlSelfRef.main__DOT__cpu__DOT__flush = 0U;
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
    vlSelfRef.main__DOT__cpu__DOT__execute__DOT__forwarded_rs1 
        = ((0U == (IData)(vlSelfRef.main__DOT__cpu__DOT__forward_a))
            ? vlSelfRef.main__DOT__cpu__DOT__id_ex_rs1_data
            : ((1U == (IData)(vlSelfRef.main__DOT__cpu__DOT__forward_a))
                ? vlSelfRef.main__DOT__cpu__DOT__mem_wb_mem_data
                : ((2U == (IData)(vlSelfRef.main__DOT__cpu__DOT__forward_a))
                    ? vlSelfRef.main__DOT__cpu__DOT__mem_wb_alu_result
                    : vlSelfRef.main__DOT__cpu__DOT__id_ex_rs1_data)));
    if ((0x10U & vlSelfRef.main__DOT__cpu__DOT__id_ex_control_signals)) {
        vlSelfRef.main__DOT__cpu__DOT__pc_src = ((0x4000U 
                                                  & vlSelfRef.main__DOT__cpu__DOT__id_ex_instruction)
                                                  ? 
                                                 ((0x2000U 
                                                   & vlSelfRef.main__DOT__cpu__DOT__id_ex_instruction)
                                                   ? 
                                                  ((0x1000U 
                                                    & vlSelfRef.main__DOT__cpu__DOT__id_ex_instruction)
                                                    ? 
                                                   (vlSelfRef.main__DOT__cpu__DOT__id_ex_rs1_data 
                                                    >= vlSelfRef.main__DOT__cpu__DOT__id_ex_rs2_data)
                                                    : 
                                                   (vlSelfRef.main__DOT__cpu__DOT__id_ex_rs1_data 
                                                    < vlSelfRef.main__DOT__cpu__DOT__id_ex_rs2_data))
                                                   : 
                                                  ((0x1000U 
                                                    & vlSelfRef.main__DOT__cpu__DOT__id_ex_instruction)
                                                    ? 
                                                   VL_GTES_III(32, vlSelfRef.main__DOT__cpu__DOT__id_ex_rs1_data, vlSelfRef.main__DOT__cpu__DOT__id_ex_rs2_data)
                                                    : 
                                                   VL_LTS_III(32, vlSelfRef.main__DOT__cpu__DOT__id_ex_rs1_data, vlSelfRef.main__DOT__cpu__DOT__id_ex_rs2_data)))
                                                  : 
                                                 ((1U 
                                                   & (~ 
                                                      (vlSelfRef.main__DOT__cpu__DOT__id_ex_instruction 
                                                       >> 0xdU))) 
                                                  && ((0x1000U 
                                                       & vlSelfRef.main__DOT__cpu__DOT__id_ex_instruction)
                                                       ? 
                                                      (vlSelfRef.main__DOT__cpu__DOT__id_ex_rs1_data 
                                                       != vlSelfRef.main__DOT__cpu__DOT__id_ex_rs2_data)
                                                       : 
                                                      (vlSelfRef.main__DOT__cpu__DOT__id_ex_rs1_data 
                                                       == vlSelfRef.main__DOT__cpu__DOT__id_ex_rs2_data))));
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
    vlSelfRef.main__DOT__cpu__DOT__instruction_fetch__DOT__pc_next 
        = ((IData)(vlSelfRef.main__DOT__cpu__DOT__pc_src)
            ? vlSelfRef.main__DOT__cpu__DOT__new_pc
            : ((IData)(4U) + vlSelfRef.main__DOT__cpu__DOT__instruction_fetch__DOT__pc_reg));
    vlSelfRef.main__DOT__cpu__DOT__execute__DOT__forwarded_rs2 
        = ((0U == (IData)(vlSelfRef.main__DOT__cpu__DOT__forward_b))
            ? vlSelfRef.main__DOT__cpu__DOT__id_ex_rs2_data
            : ((1U == (IData)(vlSelfRef.main__DOT__cpu__DOT__forward_b))
                ? vlSelfRef.main__DOT__cpu__DOT__mem_wb_mem_data
                : ((2U == (IData)(vlSelfRef.main__DOT__cpu__DOT__forward_b))
                    ? vlSelfRef.main__DOT__cpu__DOT__mem_wb_alu_result
                    : vlSelfRef.main__DOT__cpu__DOT__id_ex_rs2_data)));
    vlSelfRef.main__DOT__cpu__DOT__execute__DOT__branch_condition_met = 0U;
    if ((0x10U & vlSelfRef.main__DOT__cpu__DOT__id_ex_control_signals)) {
        vlSelfRef.main__DOT__cpu__DOT__execute__DOT__branch_condition_met 
            = ((0x4000U & vlSelfRef.main__DOT__cpu__DOT__id_ex_instruction)
                ? ((0x2000U & vlSelfRef.main__DOT__cpu__DOT__id_ex_instruction)
                    ? ((0x1000U & vlSelfRef.main__DOT__cpu__DOT__id_ex_instruction)
                        ? (vlSelfRef.main__DOT__cpu__DOT__execute__DOT__forwarded_rs1 
                           >= vlSelfRef.main__DOT__cpu__DOT__execute__DOT__forwarded_rs2)
                        : (vlSelfRef.main__DOT__cpu__DOT__execute__DOT__forwarded_rs1 
                           < vlSelfRef.main__DOT__cpu__DOT__execute__DOT__forwarded_rs2))
                    : ((0x1000U & vlSelfRef.main__DOT__cpu__DOT__id_ex_instruction)
                        ? VL_GTES_III(32, vlSelfRef.main__DOT__cpu__DOT__execute__DOT__forwarded_rs1, vlSelfRef.main__DOT__cpu__DOT__execute__DOT__forwarded_rs2)
                        : VL_LTS_III(32, vlSelfRef.main__DOT__cpu__DOT__execute__DOT__forwarded_rs1, vlSelfRef.main__DOT__cpu__DOT__execute__DOT__forwarded_rs2)))
                : ((1U & (~ (vlSelfRef.main__DOT__cpu__DOT__id_ex_instruction 
                             >> 0xdU))) && ((0x1000U 
                                             & vlSelfRef.main__DOT__cpu__DOT__id_ex_instruction)
                                             ? (vlSelfRef.main__DOT__cpu__DOT__execute__DOT__forwarded_rs1 
                                                != vlSelfRef.main__DOT__cpu__DOT__execute__DOT__forwarded_rs2)
                                             : (vlSelfRef.main__DOT__cpu__DOT__execute__DOT__forwarded_rs1 
                                                == vlSelfRef.main__DOT__cpu__DOT__execute__DOT__forwarded_rs2))));
    }
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
}

VL_ATTR_COLD void Vmain___024root___eval_triggers__stl(Vmain___024root* vlSelf);

VL_ATTR_COLD bool Vmain___024root___eval_phase__stl(Vmain___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vmain__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vmain___024root___eval_phase__stl\n"); );
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    CData/*0:0*/ __VstlExecute;
    // Body
    Vmain___024root___eval_triggers__stl(vlSelf);
    __VstlExecute = vlSelfRef.__VstlTriggered.any();
    if (__VstlExecute) {
        Vmain___024root___eval_stl(vlSelf);
    }
    return (__VstlExecute);
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vmain___024root___dump_triggers__ico(Vmain___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vmain__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vmain___024root___dump_triggers__ico\n"); );
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((1U & (~ vlSelfRef.__VicoTriggered.any()))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if ((1ULL & vlSelfRef.__VicoTriggered.word(0U))) {
        VL_DBG_MSGF("         'ico' region trigger index 0 is active: Internal 'ico' trigger - first iteration\n");
    }
}
#endif  // VL_DEBUG

#ifdef VL_DEBUG
VL_ATTR_COLD void Vmain___024root___dump_triggers__act(Vmain___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vmain__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vmain___024root___dump_triggers__act\n"); );
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((1U & (~ vlSelfRef.__VactTriggered.any()))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if ((1ULL & vlSelfRef.__VactTriggered.word(0U))) {
        VL_DBG_MSGF("         'act' region trigger index 0 is active: @(posedge main.cpu_clk)\n");
    }
    if ((2ULL & vlSelfRef.__VactTriggered.word(0U))) {
        VL_DBG_MSGF("         'act' region trigger index 1 is active: @(posedge reset)\n");
    }
}
#endif  // VL_DEBUG

#ifdef VL_DEBUG
VL_ATTR_COLD void Vmain___024root___dump_triggers__nba(Vmain___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vmain__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vmain___024root___dump_triggers__nba\n"); );
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((1U & (~ vlSelfRef.__VnbaTriggered.any()))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if ((1ULL & vlSelfRef.__VnbaTriggered.word(0U))) {
        VL_DBG_MSGF("         'nba' region trigger index 0 is active: @(posedge main.cpu_clk)\n");
    }
    if ((2ULL & vlSelfRef.__VnbaTriggered.word(0U))) {
        VL_DBG_MSGF("         'nba' region trigger index 1 is active: @(posedge reset)\n");
    }
}
#endif  // VL_DEBUG

VL_ATTR_COLD void Vmain___024root____Vm_traceActivitySetAll(Vmain___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vmain__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vmain___024root____Vm_traceActivitySetAll\n"); );
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.__Vm_traceActivity[0U] = 1U;
    vlSelfRef.__Vm_traceActivity[1U] = 1U;
}

VL_ATTR_COLD void Vmain___024root___ctor_var_reset(Vmain___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vmain__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vmain___024root___ctor_var_reset\n"); );
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelf->clk = VL_RAND_RESET_I(1);
    vlSelf->reset = VL_RAND_RESET_I(1);
    vlSelf->step_en = VL_RAND_RESET_I(1);
    vlSelf->debug_pc = VL_RAND_RESET_I(32);
    vlSelf->debug_instruction = VL_RAND_RESET_I(32);
    vlSelf->debug_stall = VL_RAND_RESET_I(1);
    vlSelf->debug_flush = VL_RAND_RESET_I(1);
    vlSelf->main__DOT__cpu_clk = VL_RAND_RESET_I(1);
    for (int __Vi0 = 0; __Vi0 < 256; ++__Vi0) {
        vlSelf->main__DOT__imem_internal[__Vi0] = VL_RAND_RESET_I(32);
    }
    for (int __Vi0 = 0; __Vi0 < 256; ++__Vi0) {
        vlSelf->main__DOT__dmem_internal[__Vi0] = VL_RAND_RESET_I(32);
    }
    for (int __Vi0 = 0; __Vi0 < 32; ++__Vi0) {
        vlSelf->main__DOT__debug_registers_internal[__Vi0] = VL_RAND_RESET_I(32);
    }
    vlSelf->main__DOT__dmem_data_in = VL_RAND_RESET_I(32);
    vlSelf->main__DOT__dmem_byte_enable = VL_RAND_RESET_I(4);
    vlSelf->main__DOT__unnamedblk1__DOT__i = VL_RAND_RESET_I(32);
    vlSelf->main__DOT__cpu__DOT__if_id_pc = VL_RAND_RESET_I(32);
    vlSelf->main__DOT__cpu__DOT__if_id_instruction = VL_RAND_RESET_I(32);
    vlSelf->main__DOT__cpu__DOT__if_id_valid = VL_RAND_RESET_I(1);
    vlSelf->main__DOT__cpu__DOT__id_ex_pc = VL_RAND_RESET_I(32);
    vlSelf->main__DOT__cpu__DOT__id_ex_instruction = VL_RAND_RESET_I(32);
    vlSelf->main__DOT__cpu__DOT__id_ex_rs1_data = VL_RAND_RESET_I(32);
    vlSelf->main__DOT__cpu__DOT__id_ex_rs2_data = VL_RAND_RESET_I(32);
    vlSelf->main__DOT__cpu__DOT__id_ex_immediate = VL_RAND_RESET_I(32);
    vlSelf->main__DOT__cpu__DOT__id_ex_rd_addr = VL_RAND_RESET_I(5);
    vlSelf->main__DOT__cpu__DOT__id_ex_rs1_addr = VL_RAND_RESET_I(5);
    vlSelf->main__DOT__cpu__DOT__id_ex_rs2_addr = VL_RAND_RESET_I(5);
    vlSelf->main__DOT__cpu__DOT__id_ex_control_signals = VL_RAND_RESET_I(20);
    vlSelf->main__DOT__cpu__DOT__id_ex_valid = VL_RAND_RESET_I(1);
    vlSelf->main__DOT__cpu__DOT__ex_mem_pc = VL_RAND_RESET_I(32);
    vlSelf->main__DOT__cpu__DOT__ex_mem_alu_result = VL_RAND_RESET_I(32);
    vlSelf->main__DOT__cpu__DOT__ex_mem_rs2_data = VL_RAND_RESET_I(32);
    vlSelf->main__DOT__cpu__DOT__ex_mem_rd_addr = VL_RAND_RESET_I(5);
    vlSelf->main__DOT__cpu__DOT__ex_mem_control_signals = VL_RAND_RESET_I(20);
    vlSelf->main__DOT__cpu__DOT__ex_mem_valid = VL_RAND_RESET_I(1);
    vlSelf->main__DOT__cpu__DOT__mem_wb_pc = VL_RAND_RESET_I(32);
    vlSelf->main__DOT__cpu__DOT__mem_wb_alu_result = VL_RAND_RESET_I(32);
    vlSelf->main__DOT__cpu__DOT__mem_wb_mem_data = VL_RAND_RESET_I(32);
    vlSelf->main__DOT__cpu__DOT__mem_wb_rd_addr = VL_RAND_RESET_I(5);
    vlSelf->main__DOT__cpu__DOT__mem_wb_control_signals = VL_RAND_RESET_I(20);
    vlSelf->main__DOT__cpu__DOT__mem_wb_valid = VL_RAND_RESET_I(1);
    vlSelf->main__DOT__cpu__DOT__flush = VL_RAND_RESET_I(1);
    vlSelf->main__DOT__cpu__DOT__new_pc = VL_RAND_RESET_I(32);
    vlSelf->main__DOT__cpu__DOT__pc_src = VL_RAND_RESET_I(1);
    vlSelf->main__DOT__cpu__DOT__forward_a = VL_RAND_RESET_I(2);
    vlSelf->main__DOT__cpu__DOT__forward_b = VL_RAND_RESET_I(2);
    vlSelf->main__DOT__cpu__DOT__wb_data = VL_RAND_RESET_I(32);
    vlSelf->main__DOT__cpu__DOT__control_signals = VL_RAND_RESET_I(20);
    vlSelf->main__DOT__cpu__DOT__instruction_fetch__DOT__pc_reg = VL_RAND_RESET_I(32);
    vlSelf->main__DOT__cpu__DOT__instruction_fetch__DOT__pc_next = VL_RAND_RESET_I(32);
    vlSelf->main__DOT__cpu__DOT__instruction_decode__DOT__control_signals = VL_RAND_RESET_I(20);
    vlSelf->main__DOT__cpu__DOT__instruction_decode__DOT__immediate = VL_RAND_RESET_I(32);
    vlSelf->main__DOT__cpu__DOT__instruction_decode__DOT__ctrl_unit__DOT__reg_write = VL_RAND_RESET_I(1);
    vlSelf->main__DOT__cpu__DOT__instruction_decode__DOT__ctrl_unit__DOT__mem_to_reg = VL_RAND_RESET_I(1);
    vlSelf->main__DOT__cpu__DOT__instruction_decode__DOT__ctrl_unit__DOT__mem_read = VL_RAND_RESET_I(1);
    vlSelf->main__DOT__cpu__DOT__instruction_decode__DOT__ctrl_unit__DOT__mem_write = VL_RAND_RESET_I(1);
    vlSelf->main__DOT__cpu__DOT__instruction_decode__DOT__ctrl_unit__DOT__branch = VL_RAND_RESET_I(1);
    vlSelf->main__DOT__cpu__DOT__instruction_decode__DOT__ctrl_unit__DOT__jump = VL_RAND_RESET_I(1);
    vlSelf->main__DOT__cpu__DOT__instruction_decode__DOT__ctrl_unit__DOT__alu_src = VL_RAND_RESET_I(1);
    vlSelf->main__DOT__cpu__DOT__instruction_decode__DOT__ctrl_unit__DOT__alu_op = VL_RAND_RESET_I(4);
    vlSelf->main__DOT__cpu__DOT__instruction_decode__DOT__ctrl_unit__DOT__imm_type = VL_RAND_RESET_I(3);
    vlSelf->main__DOT__cpu__DOT__instruction_decode__DOT__ctrl_unit__DOT__pc_src = VL_RAND_RESET_I(2);
    vlSelf->main__DOT__cpu__DOT__execute__DOT__alu_input_b = VL_RAND_RESET_I(32);
    vlSelf->main__DOT__cpu__DOT__execute__DOT__forwarded_rs1 = VL_RAND_RESET_I(32);
    vlSelf->main__DOT__cpu__DOT__execute__DOT__forwarded_rs2 = VL_RAND_RESET_I(32);
    vlSelf->main__DOT__cpu__DOT__execute__DOT__branch_condition_met = VL_RAND_RESET_I(1);
    vlSelf->main__DOT__cpu__DOT__execute__DOT__alu_result = VL_RAND_RESET_I(32);
    vlSelf->main__DOT__cpu__DOT__memory_access__DOT__read_data = VL_RAND_RESET_I(32);
    vlSelf->main__DOT__cpu__DOT__control_unit__DOT__reg_write = VL_RAND_RESET_I(1);
    vlSelf->main__DOT__cpu__DOT__control_unit__DOT__mem_to_reg = VL_RAND_RESET_I(1);
    vlSelf->main__DOT__cpu__DOT__control_unit__DOT__mem_read = VL_RAND_RESET_I(1);
    vlSelf->main__DOT__cpu__DOT__control_unit__DOT__mem_write = VL_RAND_RESET_I(1);
    vlSelf->main__DOT__cpu__DOT__control_unit__DOT__branch = VL_RAND_RESET_I(1);
    vlSelf->main__DOT__cpu__DOT__control_unit__DOT__jump = VL_RAND_RESET_I(1);
    vlSelf->main__DOT__cpu__DOT__control_unit__DOT__alu_src = VL_RAND_RESET_I(1);
    vlSelf->main__DOT__cpu__DOT__control_unit__DOT__alu_op = VL_RAND_RESET_I(4);
    vlSelf->main__DOT__cpu__DOT__control_unit__DOT__imm_type = VL_RAND_RESET_I(3);
    vlSelf->main__DOT__cpu__DOT__control_unit__DOT__pc_src = VL_RAND_RESET_I(2);
    for (int __Vi0 = 0; __Vi0 < 31; ++__Vi0) {
        vlSelf->main__DOT__cpu__DOT__reg_file__DOT__regs[__Vi0] = VL_RAND_RESET_I(32);
    }
    vlSelf->main__DOT__cpu__DOT__reg_file__DOT__unnamedblk1__DOT__i = 0;
    vlSelf->main__DOT__cpu__DOT__reg_file__DOT____Vlvbound_h9617656b__0 = VL_RAND_RESET_I(32);
    vlSelf->__Vtrigprevexpr___TOP__main__DOT__cpu_clk__0 = VL_RAND_RESET_I(1);
    vlSelf->__Vtrigprevexpr___TOP__reset__0 = VL_RAND_RESET_I(1);
    for (int __Vi0 = 0; __Vi0 < 2; ++__Vi0) {
        vlSelf->__Vm_traceActivity[__Vi0] = 0;
    }
}
