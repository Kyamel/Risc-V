// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design internal header
// See Vmain.h for the primary calling header

#ifndef VERILATED_VMAIN___024ROOT_H_
#define VERILATED_VMAIN___024ROOT_H_  // guard

#include "verilated.h"


class Vmain__Syms;

class alignas(VL_CACHE_LINE_BYTES) Vmain___024root final : public VerilatedModule {
  public:

    // DESIGN SPECIFIC STATE
    // Anonymous structures to workaround compiler member-count bugs
    struct {
        VL_IN8(reset,0,0);
        CData/*0:0*/ main__DOT__cpu_clk;
        VL_IN8(clk,0,0);
        VL_IN8(step_en,0,0);
        VL_OUT8(debug_stall,0,0);
        VL_OUT8(debug_flush,0,0);
        CData/*3:0*/ main__DOT__dmem_byte_enable;
        CData/*0:0*/ main__DOT__cpu__DOT__if_id_valid;
        CData/*4:0*/ main__DOT__cpu__DOT__id_ex_rd_addr;
        CData/*4:0*/ main__DOT__cpu__DOT__id_ex_rs1_addr;
        CData/*4:0*/ main__DOT__cpu__DOT__id_ex_rs2_addr;
        CData/*0:0*/ main__DOT__cpu__DOT__id_ex_valid;
        CData/*4:0*/ main__DOT__cpu__DOT__ex_mem_rd_addr;
        CData/*0:0*/ main__DOT__cpu__DOT__ex_mem_valid;
        CData/*4:0*/ main__DOT__cpu__DOT__mem_wb_rd_addr;
        CData/*0:0*/ main__DOT__cpu__DOT__mem_wb_valid;
        CData/*0:0*/ main__DOT__cpu__DOT__flush;
        CData/*0:0*/ main__DOT__cpu__DOT__pc_src;
        CData/*1:0*/ main__DOT__cpu__DOT__forward_a;
        CData/*1:0*/ main__DOT__cpu__DOT__forward_b;
        CData/*0:0*/ main__DOT__cpu__DOT__instruction_decode__DOT__ctrl_unit__DOT__reg_write;
        CData/*0:0*/ main__DOT__cpu__DOT__instruction_decode__DOT__ctrl_unit__DOT__mem_to_reg;
        CData/*0:0*/ main__DOT__cpu__DOT__instruction_decode__DOT__ctrl_unit__DOT__mem_read;
        CData/*0:0*/ main__DOT__cpu__DOT__instruction_decode__DOT__ctrl_unit__DOT__mem_write;
        CData/*0:0*/ main__DOT__cpu__DOT__instruction_decode__DOT__ctrl_unit__DOT__branch;
        CData/*0:0*/ main__DOT__cpu__DOT__instruction_decode__DOT__ctrl_unit__DOT__jump;
        CData/*0:0*/ main__DOT__cpu__DOT__instruction_decode__DOT__ctrl_unit__DOT__alu_src;
        CData/*3:0*/ main__DOT__cpu__DOT__instruction_decode__DOT__ctrl_unit__DOT__alu_op;
        CData/*2:0*/ main__DOT__cpu__DOT__instruction_decode__DOT__ctrl_unit__DOT__imm_type;
        CData/*1:0*/ main__DOT__cpu__DOT__instruction_decode__DOT__ctrl_unit__DOT__pc_src;
        CData/*0:0*/ main__DOT__cpu__DOT__execute__DOT__branch_condition_met;
        CData/*0:0*/ main__DOT__cpu__DOT__control_unit__DOT__reg_write;
        CData/*0:0*/ main__DOT__cpu__DOT__control_unit__DOT__mem_to_reg;
        CData/*0:0*/ main__DOT__cpu__DOT__control_unit__DOT__mem_read;
        CData/*0:0*/ main__DOT__cpu__DOT__control_unit__DOT__mem_write;
        CData/*0:0*/ main__DOT__cpu__DOT__control_unit__DOT__branch;
        CData/*0:0*/ main__DOT__cpu__DOT__control_unit__DOT__jump;
        CData/*0:0*/ main__DOT__cpu__DOT__control_unit__DOT__alu_src;
        CData/*3:0*/ main__DOT__cpu__DOT__control_unit__DOT__alu_op;
        CData/*2:0*/ main__DOT__cpu__DOT__control_unit__DOT__imm_type;
        CData/*1:0*/ main__DOT__cpu__DOT__control_unit__DOT__pc_src;
        CData/*0:0*/ __VstlFirstIteration;
        CData/*0:0*/ __VicoFirstIteration;
        CData/*0:0*/ __Vtrigprevexpr___TOP__main__DOT__cpu_clk__0;
        CData/*0:0*/ __Vtrigprevexpr___TOP__reset__0;
        CData/*0:0*/ __VactContinue;
        VL_OUT(debug_pc,31,0);
        VL_OUT(debug_instruction,31,0);
        IData/*31:0*/ main__DOT__dmem_data_in;
        IData/*31:0*/ main__DOT__unnamedblk1__DOT__i;
        IData/*31:0*/ main__DOT__cpu__DOT__if_id_pc;
        IData/*31:0*/ main__DOT__cpu__DOT__if_id_instruction;
        IData/*31:0*/ main__DOT__cpu__DOT__id_ex_pc;
        IData/*31:0*/ main__DOT__cpu__DOT__id_ex_instruction;
        IData/*31:0*/ main__DOT__cpu__DOT__id_ex_rs1_data;
        IData/*31:0*/ main__DOT__cpu__DOT__id_ex_rs2_data;
        IData/*31:0*/ main__DOT__cpu__DOT__id_ex_immediate;
        IData/*19:0*/ main__DOT__cpu__DOT__id_ex_control_signals;
        IData/*31:0*/ main__DOT__cpu__DOT__ex_mem_pc;
        IData/*31:0*/ main__DOT__cpu__DOT__ex_mem_alu_result;
        IData/*31:0*/ main__DOT__cpu__DOT__ex_mem_rs2_data;
        IData/*19:0*/ main__DOT__cpu__DOT__ex_mem_control_signals;
        IData/*31:0*/ main__DOT__cpu__DOT__mem_wb_pc;
        IData/*31:0*/ main__DOT__cpu__DOT__mem_wb_alu_result;
    };
    struct {
        IData/*31:0*/ main__DOT__cpu__DOT__mem_wb_mem_data;
        IData/*19:0*/ main__DOT__cpu__DOT__mem_wb_control_signals;
        IData/*31:0*/ main__DOT__cpu__DOT__new_pc;
        IData/*31:0*/ main__DOT__cpu__DOT__wb_data;
        IData/*19:0*/ main__DOT__cpu__DOT__control_signals;
        IData/*31:0*/ main__DOT__cpu__DOT__instruction_fetch__DOT__pc_reg;
        IData/*31:0*/ main__DOT__cpu__DOT__instruction_fetch__DOT__pc_next;
        IData/*19:0*/ main__DOT__cpu__DOT__instruction_decode__DOT__control_signals;
        IData/*31:0*/ main__DOT__cpu__DOT__instruction_decode__DOT__immediate;
        IData/*31:0*/ main__DOT__cpu__DOT__execute__DOT__alu_input_b;
        IData/*31:0*/ main__DOT__cpu__DOT__execute__DOT__forwarded_rs1;
        IData/*31:0*/ main__DOT__cpu__DOT__execute__DOT__forwarded_rs2;
        IData/*31:0*/ main__DOT__cpu__DOT__execute__DOT__alu_result;
        IData/*31:0*/ main__DOT__cpu__DOT__memory_access__DOT__read_data;
        IData/*31:0*/ main__DOT__cpu__DOT__reg_file__DOT__unnamedblk1__DOT__i;
        IData/*31:0*/ main__DOT__cpu__DOT__reg_file__DOT____Vlvbound_h9617656b__0;
        IData/*31:0*/ __VactIterCount;
        VlUnpacked<IData/*31:0*/, 256> main__DOT__imem_internal;
        VlUnpacked<IData/*31:0*/, 256> main__DOT__dmem_internal;
        VlUnpacked<IData/*31:0*/, 32> main__DOT__debug_registers_internal;
        VlUnpacked<IData/*31:0*/, 31> main__DOT__cpu__DOT__reg_file__DOT__regs;
        VlUnpacked<CData/*0:0*/, 2> __Vm_traceActivity;
    };
    VlTriggerVec<1> __VstlTriggered;
    VlTriggerVec<1> __VicoTriggered;
    VlTriggerVec<2> __VactTriggered;
    VlTriggerVec<2> __VnbaTriggered;

    // INTERNAL VARIABLES
    Vmain__Syms* const vlSymsp;

    // CONSTRUCTORS
    Vmain___024root(Vmain__Syms* symsp, const char* v__name);
    ~Vmain___024root();
    VL_UNCOPYABLE(Vmain___024root);

    // INTERNAL METHODS
    void __Vconfigure(bool first);
};


#endif  // guard
