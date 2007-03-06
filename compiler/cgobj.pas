{
    Copyright (c) 1998-2005 by Florian Klaempfl
    Member of the Free Pascal development team

    This unit implements the basic code generator object

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

 ****************************************************************************
}
{# @abstract(Abstract code generator unit)
   Abstreact code generator unit. This contains the base class
   to implement for all new supported processors.

   WARNING: None of the routines implemented in these modules,
   or their descendants, should use the temp. allocator, as
   these routines may be called inside genentrycode, and the
   stack frame is already setup!
}
unit cgobj;

{$i fpcdefs.inc}

  interface

    uses
       cclasses,globtype,
       cpubase,cgbase,cgutils,parabase,
       aasmbase,aasmtai,aasmdata,aasmcpu,
       symconst,symbase,symtype,symdef,symtable,rgobj
       ;

    type
       talignment = (AM_NATURAL,AM_NONE,AM_2BYTE,AM_4BYTE,AM_8BYTE);
       tsubsetloadopt = (SL_REG,SL_REGNOSRCMASK,SL_SETZERO,SL_SETMAX);

       {# @abstract(Abstract code generator)
          This class implements an abstract instruction generator. Some of
          the methods of this class are generic, while others must
          be overriden for all new processors which will be supported
          by Free Pascal. For 32-bit processors, the base class
          sould be @link(tcg64f32) and not @var(tcg).
       }
       tcg = class
       public
          alignment : talignment;
          rg        : array[tregistertype] of trgobj;
          t_times   : longint;
       {$ifdef flowgraph}
          aktflownode:word;
       {$endif}
          {************************************************}
          {                 basic routines                 }
          constructor create;

          {# Initialize the register allocators needed for the codegenerator.}
          procedure init_register_allocators;virtual;
          {# Clean up the register allocators needed for the codegenerator.}
          procedure done_register_allocators;virtual;
          {# Set whether live_start or live_end should be updated when allocating registers, needed when e.g. generating initcode after the rest of the code. }
          procedure set_regalloc_extend_backwards(b: boolean);

       {$ifdef flowgraph}
          procedure init_flowgraph;
          procedure done_flowgraph;
       {$endif}
          {# Gets a register suitable to do integer operations on.}
          function getintregister(list:TAsmList;size:Tcgsize):Tregister;virtual;
          {# Gets a register suitable to do integer operations on.}
          function getaddressregister(list:TAsmList):Tregister;virtual;
          function getfpuregister(list:TAsmList;size:Tcgsize):Tregister;virtual;
          function getmmregister(list:TAsmList;size:Tcgsize):Tregister;virtual;
          function getflagregister(list:TAsmList;size:Tcgsize):Tregister;virtual;abstract;
          {Does the generic cg need SIMD registers, like getmmxregister? Or should
           the cpu specific child cg object have such a method?}

          procedure add_reg_instruction(instr:Tai;r:tregister);virtual;
          procedure add_move_instruction(instr:Taicpu);virtual;

          function  uses_registers(rt:Tregistertype):boolean;virtual;
          {# Get a specific register.}
          procedure getcpuregister(list:TAsmList;r:Tregister);virtual;
          procedure ungetcpuregister(list:TAsmList;r:Tregister);virtual;
          {# Get multiple registers specified.}
          procedure alloccpuregisters(list:TAsmList;rt:Tregistertype;const r:Tcpuregisterset);virtual;
          {# Free multiple registers specified.}
          procedure dealloccpuregisters(list:TAsmList;rt:Tregistertype;const r:Tcpuregisterset);virtual;

          procedure allocallcpuregisters(list:TAsmList);virtual;
          procedure deallocallcpuregisters(list:TAsmList);virtual;
          procedure do_register_allocation(list:TAsmList;headertai:tai);virtual;
          procedure translate_register(var reg : tregister);

          function makeregsize(list:TAsmList;reg:Tregister;size:Tcgsize):Tregister;

          {# Emit a label to the instruction stream. }
          procedure a_label(list : TAsmList;l : tasmlabel);virtual;

          {# Allocates register r by inserting a pai_realloc record }
          procedure a_reg_alloc(list : TAsmList;r : tregister);
          {# Deallocates register r by inserting a pa_regdealloc record}
          procedure a_reg_dealloc(list : TAsmList;r : tregister);
          { Synchronize register, make sure it is still valid }
          procedure a_reg_sync(list : TAsmList;r : tregister);

          {# Pass a parameter, which is located in a register, to a routine.

             This routine should push/send the parameter to the routine, as
             required by the specific processor ABI and routine modifiers.
             This must be overriden for each CPU target.

             @param(size size of the operand in the register)
             @param(r register source of the operand)
             @param(cgpara where the parameter will be stored)
          }
          procedure a_param_reg(list : TAsmList;size : tcgsize;r : tregister;const cgpara : TCGPara);virtual;
          {# Pass a parameter, which is a constant, to a routine.

             A generic version is provided. This routine should
             be overriden for optimization purposes if the cpu
             permits directly sending this type of parameter.

             @param(size size of the operand in constant)
             @param(a value of constant to send)
             @param(cgpara where the parameter will be stored)
          }
          procedure a_param_const(list : TAsmList;size : tcgsize;a : aint;const cgpara : TCGPara);virtual;
          {# Pass the value of a parameter, which is located in memory, to a routine.

             A generic version is provided. This routine should
             be overriden for optimization purposes if the cpu
             permits directly sending this type of parameter.

             @param(size size of the operand in constant)
             @param(r Memory reference of value to send)
             @param(cgpara where the parameter will be stored)
          }
          procedure a_param_ref(list : TAsmList;size : tcgsize;const r : treference;const cgpara : TCGPara);virtual;
          {# Pass the value of a parameter, which can be located either in a register or memory location,
             to a routine.

             A generic version is provided.

             @param(l location of the operand to send)
             @param(nr parameter number (starting from one) of routine (from left to right))
             @param(cgpara where the parameter will be stored)
          }
          procedure a_param_loc(list : TAsmList;const l : tlocation;const cgpara : TCGPara);
          {# Pass the address of a reference to a routine. This routine
             will calculate the address of the reference, and pass this
             calculated address as a parameter.

             A generic version is provided. This routine should
             be overriden for optimization purposes if the cpu
             permits directly sending this type of parameter.

             @param(r reference to get address from)
             @param(nr parameter number (starting from one) of routine (from left to right))
          }
          procedure a_paramaddr_ref(list : TAsmList;const r : treference;const cgpara : TCGPara);virtual;

          { Remarks:
            * If a method specifies a size you have only to take care
              of that number of bits, i.e. load_const_reg with OP_8 must
              only load the lower 8 bit of the specified register
              the rest of the register can be undefined
              if  necessary the compiler will call a method
              to zero or sign extend the register
            * The a_load_XX_XX with OP_64 needn't to be
              implemented for 32 bit
              processors, the code generator takes care of that
            * the addr size is for work with the natural pointer
              size
            * the procedures without fpu/mm are only for integer usage
            * normally the first location is the source and the
              second the destination
          }

          {# Emits instruction to call the method specified by symbol name.
             This routine must be overriden for each new target cpu.

             There is no a_call_ref because loading the reference will use
             a temp register on most cpu's resulting in conflicts with the
             registers used for the parameters (PFV)
          }
          procedure a_call_name(list : TAsmList;const s : string);virtual; abstract;
          procedure a_call_reg(list : TAsmList;reg : tregister);virtual; abstract;
          procedure a_call_ref(list : TAsmList;ref : treference);virtual; abstract;
          { same as a_call_name, might be overriden on certain architectures to emit
            static calls without usage of a got trampoline }
          procedure a_call_name_static(list : TAsmList;const s : string);virtual;

          { move instructions }
          procedure a_load_const_reg(list : TAsmList;size : tcgsize;a : aint;register : tregister);virtual; abstract;
          procedure a_load_const_ref(list : TAsmList;size : tcgsize;a : aint;const ref : treference);virtual;
          procedure a_load_const_loc(list : TAsmList;a : aint;const loc : tlocation);
          procedure a_load_reg_ref(list : TAsmList;fromsize,tosize : tcgsize;register : tregister;const ref : treference);virtual; abstract;
          procedure a_load_reg_reg(list : TAsmList;fromsize,tosize : tcgsize;reg1,reg2 : tregister);virtual; abstract;
          procedure a_load_reg_loc(list : TAsmList;fromsize : tcgsize;reg : tregister;const loc: tlocation);
          procedure a_load_ref_reg(list : TAsmList;fromsize,tosize : tcgsize;const ref : treference;register : tregister);virtual; abstract;
          procedure a_load_ref_ref(list : TAsmList;fromsize,tosize : tcgsize;const sref : treference;const dref : treference);virtual;
          procedure a_load_loc_reg(list : TAsmList;tosize: tcgsize; const loc: tlocation; reg : tregister);
          procedure a_load_loc_ref(list : TAsmList;tosize: tcgsize; const loc: tlocation; const ref : treference);
          procedure a_load_loc_subsetreg(list : TAsmList;subsetsize: tcgsize; const loc: tlocation; const sreg : tsubsetregister);
          procedure a_load_loc_subsetref(list : TAsmList;subsetsize: tcgsize; const loc: tlocation; const sref : tsubsetreference);
          procedure a_loadaddr_ref_reg(list : TAsmList;const ref : treference;r : tregister);virtual; abstract;

          procedure a_load_subsetreg_reg(list : TAsmList; subsetsize, tosize: tcgsize; const sreg: tsubsetregister; destreg: tregister); virtual;
          procedure a_load_reg_subsetreg(list : TAsmList; fromsize, subsetsize: tcgsize; fromreg: tregister; const sreg: tsubsetregister); virtual;
          procedure a_load_subsetreg_subsetreg(list: TAsmlist; fromsubsetsize, tosubsetsize : tcgsize; const fromsreg, tosreg: tsubsetregister); virtual;
          procedure a_load_subsetreg_ref(list : TAsmList; subsetsize, tosize: tcgsize; const sreg: tsubsetregister; const destref: treference); virtual;
          procedure a_load_ref_subsetreg(list : TAsmList; fromsize, subsetsize: tcgsize; const fromref: treference; const sreg: tsubsetregister); virtual;
          procedure a_load_const_subsetreg(list: TAsmlist; subsetsize: tcgsize; a: aint; const sreg: tsubsetregister); virtual;
          procedure a_load_subsetreg_loc(list: TAsmlist; subsetsize: tcgsize; const sreg: tsubsetregister; const loc: tlocation); virtual;

          procedure a_load_subsetref_reg(list : TAsmList; subsetsize, tosize: tcgsize; const sref: tsubsetreference; destreg: tregister); virtual;
          procedure a_load_reg_subsetref(list : TAsmList; fromsize, subsetsize: tcgsize; fromreg: tregister; const sref: tsubsetreference);
          procedure a_load_subsetref_subsetref(list: TAsmlist; fromsubsetsize, tosubsetsize : tcgsize; const fromsref, tosref: tsubsetreference); virtual;
          procedure a_load_subsetref_ref(list : TAsmList; subsetsize, tosize: tcgsize; const sref: tsubsetreference; const destref: treference); virtual;
          procedure a_load_ref_subsetref(list : TAsmList; fromsize, subsetsize: tcgsize; const fromref: treference; const sref: tsubsetreference); virtual;
          procedure a_load_const_subsetref(list: TAsmlist; subsetsize: tcgsize; a: aint; const sref: tsubsetreference); virtual;
          procedure a_load_subsetref_loc(list: TAsmlist; subsetsize: tcgsize; const sref: tsubsetreference; const loc: tlocation); virtual;
          procedure a_load_subsetref_subsetreg(list: TAsmlist; fromsubsetsize, tosubsetsize : tcgsize; const fromsref: tsubsetreference; const tosreg: tsubsetregister); virtual;
          procedure a_load_subsetreg_subsetref(list: TAsmlist; fromsubsetsize, tosubsetsize : tcgsize; const fromsreg: tsubsetregister; const tosref: tsubsetreference); virtual;

          { fpu move instructions }
          procedure a_loadfpu_reg_reg(list: TAsmList; fromsize, tosize:tcgsize; reg1, reg2: tregister); virtual; abstract;
          procedure a_loadfpu_ref_reg(list: TAsmList; fromsize, tosize: tcgsize; const ref: treference; reg: tregister); virtual; abstract;
          procedure a_loadfpu_reg_ref(list: TAsmList; fromsize, tosize: tcgsize; reg: tregister; const ref: treference); virtual; abstract;
          procedure a_loadfpu_loc_reg(list: TAsmList; tosize: tcgsize; const loc: tlocation; const reg: tregister);
          procedure a_loadfpu_reg_loc(list: TAsmList; fromsize: tcgsize; const reg: tregister; const loc: tlocation);
          procedure a_paramfpu_reg(list : TAsmList;size : tcgsize;const r : tregister;const cgpara : TCGPara);virtual;
          procedure a_paramfpu_ref(list : TAsmList;size : tcgsize;const ref : treference;const cgpara : TCGPara);virtual;

          { vector register move instructions }
          procedure a_loadmm_reg_reg(list: TAsmList; fromsize, tosize : tcgsize;reg1, reg2: tregister;shuffle : pmmshuffle); virtual; abstract;
          procedure a_loadmm_ref_reg(list: TAsmList; fromsize, tosize : tcgsize;const ref: treference; reg: tregister;shuffle : pmmshuffle); virtual; abstract;
          procedure a_loadmm_reg_ref(list: TAsmList; fromsize, tosize : tcgsize;reg: tregister; const ref: treference;shuffle : pmmshuffle); virtual; abstract;
          procedure a_loadmm_loc_reg(list: TAsmList; size: tcgsize; const loc: tlocation; const reg: tregister;shuffle : pmmshuffle);
          procedure a_loadmm_reg_loc(list: TAsmList; size: tcgsize; const reg: tregister; const loc: tlocation;shuffle : pmmshuffle);
          procedure a_parammm_reg(list: TAsmList; size: tcgsize; reg: tregister;const cgpara : TCGPara;shuffle : pmmshuffle); virtual;
          procedure a_parammm_ref(list: TAsmList; size: tcgsize; const ref: treference;const cgpara : TCGPara;shuffle : pmmshuffle); virtual;
          procedure a_parammm_loc(list: TAsmList; const loc: tlocation; const cgpara : TCGPara;shuffle : pmmshuffle); virtual;
          procedure a_opmm_reg_reg(list: TAsmList; Op: TOpCG; size : tcgsize;src,dst: tregister;shuffle : pmmshuffle); virtual;abstract;
          procedure a_opmm_ref_reg(list: TAsmList; Op: TOpCG; size : tcgsize;const ref: treference; reg: tregister;shuffle : pmmshuffle); virtual;
          procedure a_opmm_loc_reg(list: TAsmList; Op: TOpCG; size : tcgsize;const loc: tlocation; reg: tregister;shuffle : pmmshuffle); virtual;
          procedure a_opmm_reg_ref(list: TAsmList; Op: TOpCG; size : tcgsize;reg: tregister;const ref: treference; shuffle : pmmshuffle); virtual;

          { basic arithmetic operations }
          { note: for operators which require only one argument (not, neg), use }
          { the op_reg_reg, op_reg_ref or op_reg_loc methods and keep in mind   }
          { that in this case the *second* operand is used as both source and   }
          { destination (JM)                                                    }
          procedure a_op_const_reg(list : TAsmList; Op: TOpCG; size: TCGSize; a: Aint; reg: TRegister); virtual; abstract;
          procedure a_op_const_ref(list : TAsmList; Op: TOpCG; size: TCGSize; a: Aint; const ref: TReference); virtual;
          procedure a_op_const_subsetreg(list : TAsmList; Op : TOpCG; size, subsetsize : TCGSize; a : aint; const sreg: tsubsetregister); virtual;
          procedure a_op_const_subsetref(list : TAsmList; Op : TOpCG; size, subsetsize : TCGSize; a : aint; const sref: tsubsetreference); virtual;
          procedure a_op_const_loc(list : TAsmList; Op: TOpCG; a: Aint; const loc: tlocation);
          procedure a_op_reg_reg(list : TAsmList; Op: TOpCG; size: TCGSize; reg1, reg2: TRegister); virtual; abstract;
          procedure a_op_reg_ref(list : TAsmList; Op: TOpCG; size: TCGSize; reg: TRegister; const ref: TReference); virtual;
          procedure a_op_ref_reg(list : TAsmList; Op: TOpCG; size: TCGSize; const ref: TReference; reg: TRegister); virtual;
          procedure a_op_reg_subsetreg(list : TAsmList; Op : TOpCG; opsize, subsetsize : TCGSize; reg: TRegister; const sreg: tsubsetregister); virtual;
          procedure a_op_reg_subsetref(list : TAsmList; Op : TOpCG; opsize, subsetsize : TCGSize; reg: TRegister; const sref: tsubsetreference); virtual;
          procedure a_op_reg_loc(list : TAsmList; Op: TOpCG; reg: tregister; const loc: tlocation);
          procedure a_op_ref_loc(list : TAsmList; Op: TOpCG; const ref: TReference; const loc: tlocation);

          { trinary operations for processors that support them, 'emulated' }
          { on others. None with "ref" arguments since I don't think there  }
          { are any processors that support it (JM)                         }
          procedure a_op_const_reg_reg(list: TAsmList; op: TOpCg; size: tcgsize; a: aint; src, dst: tregister); virtual;
          procedure a_op_reg_reg_reg(list: TAsmList; op: TOpCg; size: tcgsize; src1, src2, dst: tregister); virtual;
          procedure a_op_const_reg_reg_checkoverflow(list: TAsmList; op: TOpCg; size: tcgsize; a: aint; src, dst: tregister;setflags : boolean;var ovloc : tlocation); virtual;
          procedure a_op_reg_reg_reg_checkoverflow(list: TAsmList; op: TOpCg; size: tcgsize; src1, src2, dst: tregister;setflags : boolean;var ovloc : tlocation); virtual;

          {  comparison operations }
          procedure a_cmp_const_reg_label(list : TAsmList;size : tcgsize;cmp_op : topcmp;a : aint;reg : tregister;
            l : tasmlabel);virtual; abstract;
          procedure a_cmp_const_ref_label(list : TAsmList;size : tcgsize;cmp_op : topcmp;a : aint;const ref : treference;
            l : tasmlabel); virtual;
          procedure a_cmp_const_loc_label(list: TAsmList; size: tcgsize;cmp_op: topcmp; a: aint; const loc: tlocation;
            l : tasmlabel);
          procedure a_cmp_reg_reg_label(list : TAsmList;size : tcgsize;cmp_op : topcmp;reg1,reg2 : tregister;l : tasmlabel); virtual; abstract;
          procedure a_cmp_ref_reg_label(list : TAsmList;size : tcgsize;cmp_op : topcmp; const ref: treference; reg : tregister; l : tasmlabel); virtual;
          procedure a_cmp_reg_ref_label(list : TAsmList;size : tcgsize;cmp_op : topcmp;reg : tregister; const ref: treference; l : tasmlabel); virtual;
          procedure a_cmp_subsetreg_reg_label(list : TAsmList; subsetsize, cmpsize : tcgsize; cmp_op : topcmp; const sreg: tsubsetregister; reg : tregister; l : tasmlabel); virtual;
          procedure a_cmp_subsetref_reg_label(list : TAsmList; subsetsize, cmpsize : tcgsize; cmp_op : topcmp; const sref: tsubsetreference; reg : tregister; l : tasmlabel); virtual;

          procedure a_cmp_loc_reg_label(list : TAsmList;size : tcgsize;cmp_op : topcmp; const loc: tlocation; reg : tregister; l : tasmlabel);
          procedure a_cmp_reg_loc_label(list : TAsmList;size : tcgsize;cmp_op : topcmp; reg: tregister; const loc: tlocation; l : tasmlabel);
          procedure a_cmp_ref_loc_label(list: TAsmList; size: tcgsize;cmp_op: topcmp; const ref: treference; const loc: tlocation;
            l : tasmlabel);

          procedure a_jmp_name(list : TAsmList;const s : string); virtual; abstract;
          procedure a_jmp_always(list : TAsmList;l: tasmlabel); virtual; abstract;
          procedure a_jmp_flags(list : TAsmList;const f : TResFlags;l: tasmlabel); virtual; abstract;

          {# Depending on the value to check in the flags, either sets the register reg to one (if the flag is set)
             or zero (if the flag is cleared). The size parameter indicates the destination size register.
          }
          procedure g_flags2reg(list: TAsmList; size: TCgSize; const f: tresflags; reg: TRegister); virtual; abstract;
          procedure g_flags2ref(list: TAsmList; size: TCgSize; const f: tresflags; const ref:TReference); virtual;

          {
             This routine tries to optimize the op_const_reg/ref opcode, and should be
             called at the start of a_op_const_reg/ref. It returns the actual opcode
             to emit, and the constant value to emit. This function can opcode OP_NONE to
             remove the opcode and OP_MOVE to replace it with a simple load

             @param(op The opcode to emit, returns the opcode which must be emitted)
             @param(a  The constant which should be emitted, returns the constant which must
                    be emitted)
          }
          procedure optimize_op_const(var op: topcg; var a : aint);virtual;

         {#
             This routine is used in exception management nodes. It should
             save the exception reason currently in the FUNCTION_RETURN_REG. The
             save should be done either to a temp (pointed to by href).
             or on the stack (pushing the value on the stack).

             The size of the value to save is OS_S32. The default version
             saves the exception reason to a temp. memory area.
          }
         procedure g_exception_reason_save(list : TAsmList; const href : treference);virtual;
         {#
             This routine is used in exception management nodes. It should
             save the exception reason constant. The
             save should be done either to a temp (pointed to by href).
             or on the stack (pushing the value on the stack).

             The size of the value to save is OS_S32. The default version
             saves the exception reason to a temp. memory area.
          }
         procedure g_exception_reason_save_const(list : TAsmList; const href : treference; a: aint);virtual;
         {#
             This routine is used in exception management nodes. It should
             load the exception reason to the FUNCTION_RETURN_REG. The saved value
             should either be in the temp. area (pointed to by href , href should
             *NOT* be freed) or on the stack (the value should be popped).

             The size of the value to save is OS_S32. The default version
             saves the exception reason to a temp. memory area.
          }
         procedure g_exception_reason_load(list : TAsmList; const href : treference);virtual;

          procedure g_maybe_testself(list : TAsmList;reg:tregister);
          procedure g_maybe_testvmt(list : TAsmList;reg:tregister;objdef:tobjectdef);
          {# This should emit the opcode to copy len bytes from the source
             to destination.

             It must be overriden for each new target processor.

             @param(source Source reference of copy)
             @param(dest Destination reference of copy)

          }
          procedure g_concatcopy(list : TAsmList;const source,dest : treference;len : aint);virtual; abstract;
          {# This should emit the opcode to copy len bytes from the an unaligned source
             to destination.

             It must be overriden for each new target processor.

             @param(source Source reference of copy)
             @param(dest Destination reference of copy)

          }
          procedure g_concatcopy_unaligned(list : TAsmList;const source,dest : treference;len : aint);virtual;
          {# This should emit the opcode to a shortrstring from the source
             to destination.

             @param(source Source reference of copy)
             @param(dest Destination reference of copy)

          }
          procedure g_copyshortstring(list : TAsmList;const source,dest : treference;len:byte);
          procedure g_copyvariant(list : TAsmList;const source,dest : treference);

          procedure g_incrrefcount(list : TAsmList;t: tdef; const ref: treference);
          procedure g_decrrefcount(list : TAsmList;t: tdef; const ref: treference);
          procedure g_initialize(list : TAsmList;t : tdef;const ref : treference);
          procedure g_finalize(list : TAsmList;t : tdef;const ref : treference);

          {# Generates range checking code. It is to note
             that this routine does not need to be overriden,
             as it takes care of everything.

             @param(p Node which contains the value to check)
             @param(todef Type definition of node to range check)
          }
          procedure g_rangecheck(list: TAsmList; const l:tlocation; fromdef,todef: tdef); virtual;

          {# Generates overflow checking code for a node }
          procedure g_overflowcheck(list: TAsmList; const Loc:tlocation; def:tdef); virtual;abstract;
          procedure g_overflowCheck_loc(List:TAsmList;const Loc:TLocation;def:TDef;ovloc : tlocation);virtual;

          procedure g_copyvaluepara_openarray(list : TAsmList;const ref:treference;const lenloc:tlocation;elesize:aint;destreg:tregister);virtual;
          procedure g_releasevaluepara_openarray(list : TAsmList;const l:tlocation);virtual;

          {# Emits instructions when compilation is done in profile
             mode (this is set as a command line option). The default
             behavior does nothing, should be overriden as required.
          }
          procedure g_profilecode(list : TAsmList);virtual;
          {# Emits instruction for allocating @var(size) bytes at the stackpointer

             @param(size Number of bytes to allocate)
          }
          procedure g_stackpointer_alloc(list : TAsmList;size : longint);virtual; abstract;
          {# Emits instruction for allocating the locals in entry
             code of a routine. This is one of the first
             routine called in @var(genentrycode).

             @param(localsize Number of bytes to allocate as locals)
          }
          procedure g_proc_entry(list : TAsmList;localsize : longint;nostackframe:boolean);virtual; abstract;
          {# Emits instructions for returning from a subroutine.
             Should also restore the framepointer and stack.

             @param(parasize  Number of bytes of parameters to deallocate from stack)
          }
          procedure g_proc_exit(list : TAsmList;parasize:longint;nostackframe:boolean);virtual;abstract;
          {# This routine is called when generating the code for the entry point
             of a routine. It should save all registers which are not used in this
             routine, and which should be declared as saved in the std_saved_registers
             set.

             This routine is mainly used when linking to code which is generated
             by ABI-compliant compilers (like GCC), to make sure that the reserved
             registers of that ABI are not clobbered.

             @param(usedinproc Registers which are used in the code of this routine)
          }
          procedure g_save_standard_registers(list:TAsmList);virtual;
          {# This routine is called when generating the code for the exit point
             of a routine. It should restore all registers which were previously
             saved in @var(g_save_standard_registers).

             @param(usedinproc Registers which are used in the code of this routine)
          }
          procedure g_restore_standard_registers(list:TAsmList);virtual;
          procedure g_intf_wrapper(list: TAsmList; procdef: tprocdef; const labelname: string; ioffset: longint);virtual;abstract;
          procedure g_adjust_self_value(list:TAsmList;procdef: tprocdef;ioffset: aint);virtual;

          function g_indirect_sym_load(list:TAsmList;const symname: string): tregister;virtual;
        protected
          procedure get_subsetref_load_info(const sref: tsubsetreference; out loadsize: tcgsize; out extra_load: boolean);
          procedure a_load_subsetref_regs_noindex(list: TAsmList; subsetsize: tcgsize; loadbitsize: byte; const sref: tsubsetreference; valuereg, extra_value_reg: tregister); virtual;
          procedure a_load_subsetref_regs_index(list: TAsmList; subsetsize: tcgsize; loadbitsize: byte; const sref: tsubsetreference; valuereg, extra_value_reg: tregister); virtual;

          procedure a_load_regconst_subsetref_intern(list : TAsmList; fromsize, subsetsize: tcgsize; fromreg: tregister; const sref: tsubsetreference; slopt: tsubsetloadopt); virtual;
          procedure a_load_regconst_subsetreg_intern(list : TAsmList; fromsize, subsetsize: tcgsize; fromreg: tregister; const sreg: tsubsetregister; slopt: tsubsetloadopt); virtual;
       end;

{$ifndef cpu64bit}
    {# @abstract(Abstract code generator for 64 Bit operations)
       This class implements an abstract code generator class
       for 64 Bit operations.
    }
    tcg64 = class
        procedure a_load64_const_ref(list : TAsmList;value : int64;const ref : treference);virtual;abstract;
        procedure a_load64_reg_ref(list : TAsmList;reg : tregister64;const ref : treference);virtual;abstract;
        procedure a_load64_ref_reg(list : TAsmList;const ref : treference;reg : tregister64);virtual;abstract;
        procedure a_load64_reg_reg(list : TAsmList;regsrc,regdst : tregister64);virtual;abstract;
        procedure a_load64_const_reg(list : TAsmList;value : int64;reg : tregister64);virtual;abstract;
        procedure a_load64_loc_reg(list : TAsmList;const l : tlocation;reg : tregister64);virtual;abstract;
        procedure a_load64_loc_ref(list : TAsmList;const l : tlocation;const ref : treference);virtual;abstract;
        procedure a_load64_const_loc(list : TAsmList;value : int64;const l : tlocation);virtual;abstract;
        procedure a_load64_reg_loc(list : TAsmList;reg : tregister64;const l : tlocation);virtual;abstract;


        procedure a_load64_subsetref_reg(list : TAsmList; const sref: tsubsetreference; destreg: tregister64);virtual;abstract;
        procedure a_load64_reg_subsetref(list : TAsmList; fromreg: tregister64; const sref: tsubsetreference);virtual;abstract;
        procedure a_load64_const_subsetref(list: TAsmlist; a: int64; const sref: tsubsetreference);virtual;abstract;
        procedure a_load64_ref_subsetref(list : TAsmList; const fromref: treference; const sref: tsubsetreference);virtual;abstract;
        procedure a_load64_subsetref_subsetref(list: TAsmlist; const fromsref, tosref: tsubsetreference); virtual;abstract;
        procedure a_load64_subsetref_ref(list : TAsmList; const sref: tsubsetreference; const destref: treference); virtual;abstract;
        procedure a_load64_loc_subsetref(list : TAsmList; const l: tlocation; const sref : tsubsetreference);
        procedure a_load64_subsetref_loc(list: TAsmlist; const sref: tsubsetreference; const l: tlocation);

        procedure a_load64high_reg_ref(list : TAsmList;reg : tregister;const ref : treference);virtual;abstract;
        procedure a_load64low_reg_ref(list : TAsmList;reg : tregister;const ref : treference);virtual;abstract;
        procedure a_load64high_ref_reg(list : TAsmList;const ref : treference;reg : tregister);virtual;abstract;
        procedure a_load64low_ref_reg(list : TAsmList;const ref : treference;reg : tregister);virtual;abstract;
        procedure a_load64high_loc_reg(list : TAsmList;const l : tlocation;reg : tregister);virtual;abstract;
        procedure a_load64low_loc_reg(list : TAsmList;const l : tlocation;reg : tregister);virtual;abstract;

        procedure a_op64_ref_reg(list : TAsmList;op:TOpCG;size : tcgsize;const ref : treference;reg : tregister64);virtual;abstract;
        procedure a_op64_reg_reg(list : TAsmList;op:TOpCG;size : tcgsize;regsrc,regdst : tregister64);virtual;abstract;
        procedure a_op64_reg_ref(list : TAsmList;op:TOpCG;size : tcgsize;regsrc : tregister64;const ref : treference);virtual;abstract;
        procedure a_op64_const_reg(list : TAsmList;op:TOpCG;size : tcgsize;value : int64;regdst : tregister64);virtual;abstract;
        procedure a_op64_const_ref(list : TAsmList;op:TOpCG;size : tcgsize;value : int64;const ref : treference);virtual;abstract;
        procedure a_op64_const_loc(list : TAsmList;op:TOpCG;size : tcgsize;value : int64;const l: tlocation);virtual;abstract;
        procedure a_op64_reg_loc(list : TAsmList;op:TOpCG;size : tcgsize;reg : tregister64;const l : tlocation);virtual;abstract;
        procedure a_op64_loc_reg(list : TAsmList;op:TOpCG;size : tcgsize;const l : tlocation;reg64 : tregister64);virtual;abstract;
        procedure a_op64_const_reg_reg(list: TAsmList;op:TOpCG;size : tcgsize;value : int64;regsrc,regdst : tregister64);virtual;
        procedure a_op64_reg_reg_reg(list: TAsmList;op:TOpCG;size : tcgsize;regsrc1,regsrc2,regdst : tregister64);virtual;
        procedure a_op64_const_reg_reg_checkoverflow(list: TAsmList;op:TOpCG;size : tcgsize;value : int64;regsrc,regdst : tregister64;setflags : boolean;var ovloc : tlocation);virtual;
        procedure a_op64_reg_reg_reg_checkoverflow(list: TAsmList;op:TOpCG;size : tcgsize;regsrc1,regsrc2,regdst : tregister64;setflags : boolean;var ovloc : tlocation);virtual;

        procedure a_op64_const_subsetref(list : TAsmList; Op : TOpCG; size : TCGSize; a : int64; const sref: tsubsetreference);
        procedure a_op64_reg_subsetref(list : TAsmList; Op : TOpCG; size : TCGSize; reg: tregister64; const sref: tsubsetreference);
        procedure a_op64_ref_subsetref(list : TAsmList; Op : TOpCG; size : TCGSize; const ref: treference; const sref: tsubsetreference);
        procedure a_op64_subsetref_subsetref(list : TAsmList; Op : TOpCG; size : TCGSize; const ssref,dsref: tsubsetreference);

        procedure a_param64_reg(list : TAsmList;reg64 : tregister64;const loc : TCGPara);virtual;abstract;
        procedure a_param64_const(list : TAsmList;value : int64;const loc : TCGPara);virtual;abstract;
        procedure a_param64_ref(list : TAsmList;const r : treference;const loc : TCGPara);virtual;abstract;
        procedure a_param64_loc(list : TAsmList;const l : tlocation;const loc : TCGPara);virtual;abstract;

        {
             This routine tries to optimize the const_reg opcode, and should be
             called at the start of a_op64_const_reg. It returns the actual opcode
             to emit, and the constant value to emit. If this routine returns
             TRUE, @var(no) instruction should be emitted (.eg : imul reg by 1 )

             @param(op The opcode to emit, returns the opcode which must be emitted)
             @param(a  The constant which should be emitted, returns the constant which must
                    be emitted)
             @param(reg The register to emit the opcode with, returns the register with
                   which the opcode will be emitted)
        }
        function optimize64_op_const_reg(list: TAsmList; var op: topcg; var a : int64; var reg: tregister64): boolean;virtual;abstract;


        { override to catch 64bit rangechecks }
        procedure g_rangecheck64(list: TAsmList; const l:tlocation; fromdef,todef: tdef);virtual;abstract;
    end;
{$endif cpu64bit}

    var
       {# Main code generator class }
       cg : tcg;
{$ifndef cpu64bit}
       {# Code generator class for all operations working with 64-Bit operands }
       cg64 : tcg64;
{$endif cpu64bit}


implementation

    uses
       globals,options,systems,
       verbose,defutil,paramgr,symsym,
       tgobj,cutils,procinfo,
       ncgrtti;


{*****************************************************************************
                            basic functionallity
******************************************************************************}

    constructor tcg.create;
      begin
      end;


{*****************************************************************************
                                register allocation
******************************************************************************}


    procedure tcg.init_register_allocators;
      begin
        fillchar(rg,sizeof(rg),0);
        add_reg_instruction_hook:=@add_reg_instruction;
      end;


    procedure tcg.done_register_allocators;
      begin
        { Safety }
        fillchar(rg,sizeof(rg),0);
        add_reg_instruction_hook:=nil;
      end;

    {$ifdef flowgraph}
    procedure Tcg.init_flowgraph;

    begin
      aktflownode:=0;
    end;

    procedure Tcg.done_flowgraph;

    begin
    end;
    {$endif}

    function tcg.getintregister(list:TAsmList;size:Tcgsize):Tregister;
      begin
        if not assigned(rg[R_INTREGISTER]) then
          internalerror(200312122);
        result:=rg[R_INTREGISTER].getregister(list,cgsize2subreg(size));
      end;


    function tcg.getfpuregister(list:TAsmList;size:Tcgsize):Tregister;
      begin
        if not assigned(rg[R_FPUREGISTER]) then
          internalerror(200312123);
        result:=rg[R_FPUREGISTER].getregister(list,cgsize2subreg(size));
      end;


    function tcg.getmmregister(list:TAsmList;size:Tcgsize):Tregister;
      begin
        if not assigned(rg[R_MMREGISTER]) then
          internalerror(2003121214);
        result:=rg[R_MMREGISTER].getregister(list,cgsize2subreg(size));
      end;


    function tcg.getaddressregister(list:TAsmList):Tregister;
      begin
        if assigned(rg[R_ADDRESSREGISTER]) then
          result:=rg[R_ADDRESSREGISTER].getregister(list,R_SUBWHOLE)
        else
          begin
            if not assigned(rg[R_INTREGISTER]) then
              internalerror(200312121);
            result:=rg[R_INTREGISTER].getregister(list,R_SUBWHOLE);
          end;
      end;


    function Tcg.makeregsize(list:TAsmList;reg:Tregister;size:Tcgsize):Tregister;
      var
        subreg:Tsubregister;
      begin
        subreg:=cgsize2subreg(size);
        result:=reg;
        setsubreg(result,subreg);
        { notify RA }
        if result<>reg then
          list.concat(tai_regalloc.resize(result));
      end;


    procedure tcg.getcpuregister(list:TAsmList;r:Tregister);
      begin
        if not assigned(rg[getregtype(r)]) then
          internalerror(200312125);
        rg[getregtype(r)].getcpuregister(list,r);
      end;


    procedure tcg.ungetcpuregister(list:TAsmList;r:Tregister);
      begin
        if not assigned(rg[getregtype(r)]) then
          internalerror(200312126);
        rg[getregtype(r)].ungetcpuregister(list,r);
      end;


    procedure tcg.alloccpuregisters(list:TAsmList;rt:Tregistertype;const r:Tcpuregisterset);
      begin
        if assigned(rg[rt]) then
          rg[rt].alloccpuregisters(list,r)
        else
          internalerror(200310092);
      end;


    procedure tcg.allocallcpuregisters(list:TAsmList);
      begin
        alloccpuregisters(list,R_INTREGISTER,paramanager.get_volatile_registers_int(pocall_default));
{$ifndef i386}
        alloccpuregisters(list,R_FPUREGISTER,paramanager.get_volatile_registers_fpu(pocall_default));
{$ifdef cpumm}
        alloccpuregisters(list,R_MMREGISTER,paramanager.get_volatile_registers_mm(pocall_default));
{$endif cpumm}
{$endif i386}
      end;


    procedure tcg.dealloccpuregisters(list:TAsmList;rt:Tregistertype;const r:Tcpuregisterset);
      begin
        if assigned(rg[rt]) then
          rg[rt].dealloccpuregisters(list,r)
        else
          internalerror(200310093);
      end;


    procedure tcg.deallocallcpuregisters(list:TAsmList);
      begin
        dealloccpuregisters(list,R_INTREGISTER,paramanager.get_volatile_registers_int(pocall_default));
{$ifndef i386}
        dealloccpuregisters(list,R_FPUREGISTER,paramanager.get_volatile_registers_fpu(pocall_default));
{$ifdef cpumm}
        dealloccpuregisters(list,R_MMREGISTER,paramanager.get_volatile_registers_mm(pocall_default));
{$endif cpumm}
{$endif i386}
      end;


    function tcg.uses_registers(rt:Tregistertype):boolean;
      begin
        if assigned(rg[rt]) then
          result:=rg[rt].uses_registers
        else
          result:=false;
      end;


    procedure tcg.add_reg_instruction(instr:Tai;r:tregister);
      var
        rt : tregistertype;
      begin
        rt:=getregtype(r);
        { Only add it when a register allocator is configured.
          No IE can be generated, because the VMT is written
          without a valid rg[] }
        if assigned(rg[rt]) then
          rg[rt].add_reg_instruction(instr,r);
      end;


    procedure tcg.add_move_instruction(instr:Taicpu);
      var
        rt : tregistertype;
      begin
        rt:=getregtype(instr.oper[O_MOV_SOURCE]^.reg);
        if assigned(rg[rt]) then
          rg[rt].add_move_instruction(instr)
        else
          internalerror(200310095);
      end;


    procedure tcg.set_regalloc_extend_backwards(b: boolean);
      var
        rt : tregistertype;
      begin
        for rt:=low(rg) to high(rg) do
          begin
            if assigned(rg[rt]) then
              rg[rt].extend_live_range_backwards := b;;
          end;
      end;


    procedure tcg.do_register_allocation(list:TAsmList;headertai:tai);
      var
        rt : tregistertype;
      begin
        for rt:=R_FPUREGISTER to R_SPECIALREGISTER do
          begin
            if assigned(rg[rt]) then
              rg[rt].do_register_allocation(list,headertai);
          end;
         { running the other register allocator passes could require addition int/addr. registers
           when spilling so run int/addr register allocation at the end }
         if assigned(rg[R_INTREGISTER]) then
           rg[R_INTREGISTER].do_register_allocation(list,headertai);
         if assigned(rg[R_ADDRESSREGISTER]) then
           rg[R_ADDRESSREGISTER].do_register_allocation(list,headertai);
      end;


    procedure tcg.translate_register(var reg : tregister);
      begin
        rg[getregtype(reg)].translate_register(reg);
      end;


    procedure tcg.a_reg_alloc(list : TAsmList;r : tregister);
      begin
         list.concat(tai_regalloc.alloc(r,nil));
      end;


    procedure tcg.a_reg_dealloc(list : TAsmList;r : tregister);
      begin
         list.concat(tai_regalloc.dealloc(r,nil));
      end;


    procedure tcg.a_reg_sync(list : TAsmList;r : tregister);
      var
        instr : tai;
      begin
        instr:=tai_regalloc.sync(r);
        list.concat(instr);
        add_reg_instruction(instr,r);
      end;


    procedure tcg.a_label(list : TAsmList;l : tasmlabel);
      begin
         list.concat(tai_label.create(l));
      end;


{*****************************************************************************
          for better code generation these methods should be overridden
******************************************************************************}

    procedure tcg.a_param_reg(list : TAsmList;size : tcgsize;r : tregister;const cgpara : TCGPara);
      var
         ref : treference;
      begin
         cgpara.check_simple_location;
         case cgpara.location^.loc of
            LOC_REGISTER,LOC_CREGISTER:
              a_load_reg_reg(list,size,cgpara.location^.size,r,cgpara.location^.register);
            LOC_REFERENCE,LOC_CREFERENCE:
              begin
                 reference_reset_base(ref,cgpara.location^.reference.index,cgpara.location^.reference.offset);
                 a_load_reg_ref(list,size,cgpara.location^.size,r,ref);
              end
            else
              internalerror(2002071004);
         end;
      end;


    procedure tcg.a_param_const(list : TAsmList;size : tcgsize;a : aint;const cgpara : TCGPara);
      var
         ref : treference;
      begin
         cgpara.check_simple_location;
         case cgpara.location^.loc of
            LOC_REGISTER,LOC_CREGISTER:
              a_load_const_reg(list,cgpara.location^.size,a,cgpara.location^.register);
            LOC_REFERENCE,LOC_CREFERENCE:
              begin
                 reference_reset_base(ref,cgpara.location^.reference.index,cgpara.location^.reference.offset);
                 a_load_const_ref(list,cgpara.location^.size,a,ref);
              end
            else
              internalerror(2002071004);
         end;
      end;


    procedure tcg.a_param_ref(list : TAsmList;size : tcgsize;const r : treference;const cgpara : TCGPara);
      var
         ref : treference;
      begin
         cgpara.check_simple_location;
         case cgpara.location^.loc of
            LOC_REGISTER,LOC_CREGISTER:
              a_load_ref_reg(list,size,cgpara.location^.size,r,cgpara.location^.register);
            LOC_REFERENCE,LOC_CREFERENCE:
              begin
                 reference_reset(ref);
                 ref.base:=cgpara.location^.reference.index;
                 ref.offset:=cgpara.location^.reference.offset;
                 if (size <> OS_NO) and
                    (tcgsize2size[size] < sizeof(aint)) then
                   begin
                     if (cgpara.size = OS_NO) or
                        assigned(cgpara.location^.next) then
                       internalerror(2006052401);
                     a_load_ref_ref(list,size,cgpara.size,r,ref);
                   end
                 else
                   { use concatcopy, because the parameter can be larger than }
                   { what the OS_* constants can handle                       }
                   g_concatcopy(list,r,ref,cgpara.intsize);
              end
            else
              internalerror(2002071004);
         end;
      end;


    procedure tcg.a_param_loc(list : TAsmList;const l:tlocation;const cgpara : TCGPara);
      begin
        case l.loc of
          LOC_REGISTER,
          LOC_CREGISTER :
            a_param_reg(list,l.size,l.register,cgpara);
          LOC_CONSTANT :
            a_param_const(list,l.size,l.value,cgpara);
          LOC_CREFERENCE,
          LOC_REFERENCE :
            a_param_ref(list,l.size,l.reference,cgpara);
          else
            internalerror(2002032211);
        end;
      end;


    procedure tcg.a_paramaddr_ref(list : TAsmList;const r : treference;const cgpara : TCGPara);
      var
         hr : tregister;
      begin
         cgpara.check_simple_location;
         if cgpara.location^.loc in [LOC_CREGISTER,LOC_REGISTER] then
           a_loadaddr_ref_reg(list,r,cgpara.location^.register)
         else
           begin
             hr:=getaddressregister(list);
             a_loadaddr_ref_reg(list,r,hr);
             a_param_reg(list,OS_ADDR,hr,cgpara);
           end;
      end;


{****************************************************************************
                       some generic implementations
****************************************************************************}

{$ifopt r+}
{$define rangeon}
{$r-}
{$endif}

{$ifopt q+}
{$define overflowon}
{$q-}
{$endif}

   procedure tcg.a_load_subsetreg_reg(list : TAsmList; subsetsize, tosize: tcgsize; const sreg: tsubsetregister; destreg: tregister);
     var
       bitmask: aword;
       tmpreg: tregister;
       stopbit: byte;
     begin
       tmpreg:=getintregister(list,sreg.subsetregsize);
       if (subsetsize in [OS_S8..OS_S128]) then
         begin
           { sign extend in case the value has a bitsize mod 8 <> 0 }
           { both instructions will be optimized away if not        }
           a_op_const_reg_reg(list,OP_SHL,sreg.subsetregsize,(tcgsize2size[sreg.subsetregsize]*8)-sreg.startbit-sreg.bitlen,sreg.subsetreg,tmpreg);
           a_op_const_reg(list,OP_SAR,sreg.subsetregsize,(tcgsize2size[sreg.subsetregsize]*8)-sreg.bitlen,tmpreg);
         end
       else
         begin
           a_op_const_reg_reg(list,OP_SHR,sreg.subsetregsize,sreg.startbit,sreg.subsetreg,tmpreg);
           stopbit := sreg.startbit + sreg.bitlen;
           // on x86(64), 1 shl 32(64) = 1 instead of 0
           // use aword to prevent overflow with 1 shl 31
           if (stopbit - sreg.startbit <> AIntBits) then
             bitmask := (aword(1) shl (stopbit - sreg.startbit)) - 1
           else
             bitmask := high(aword);
           a_op_const_reg(list,OP_AND,sreg.subsetregsize,aint(bitmask),tmpreg);
         end;
       tmpreg := makeregsize(list,tmpreg,subsetsize);
       a_load_reg_reg(list,tcgsize2unsigned[subsetsize],subsetsize,tmpreg,tmpreg);
       a_load_reg_reg(list,subsetsize,tosize,tmpreg,destreg);
     end;


   procedure tcg.a_load_reg_subsetreg(list : TAsmList; fromsize, subsetsize: tcgsize; fromreg: tregister; const sreg: tsubsetregister);
     begin
       a_load_regconst_subsetreg_intern(list,fromsize,subsetsize,fromreg,sreg,SL_REG);
     end;


   procedure tcg.a_load_regconst_subsetreg_intern(list : TAsmList; fromsize, subsetsize: tcgsize; fromreg: tregister; const sreg: tsubsetregister; slopt: tsubsetloadopt);
     var
       bitmask: aword;
       tmpreg: tregister;
       stopbit: byte;
     begin
       stopbit := sreg.startbit + sreg.bitlen;
       // on x86(64), 1 shl 32(64) = 1 instead of 0
       if (stopbit <> AIntBits) then
         bitmask := not(((aword(1) shl stopbit)-1) xor ((aword(1) shl sreg.startbit)-1))
       else
         bitmask := not(high(aword) xor ((aword(1) shl sreg.startbit)-1));
       if not(slopt in [SL_SETZERO,SL_SETMAX]) then
         begin
           tmpreg:=getintregister(list,sreg.subsetregsize);
           a_load_reg_reg(list,fromsize,sreg.subsetregsize,fromreg,tmpreg);
           a_op_const_reg(list,OP_SHL,sreg.subsetregsize,sreg.startbit,tmpreg);
            if (slopt <> SL_REGNOSRCMASK) then
             a_op_const_reg(list,OP_AND,sreg.subsetregsize,aint(not(bitmask)),tmpreg);
         end;
       if (slopt <> SL_SETMAX) then
         a_op_const_reg(list,OP_AND,sreg.subsetregsize,aint(bitmask),sreg.subsetreg);

       case slopt of
         SL_SETZERO : ;
         SL_SETMAX :
           if (sreg.bitlen <> AIntBits) then
             a_op_const_reg(list,OP_OR,sreg.subsetregsize,
               aint(((aword(1) shl sreg.bitlen)-1) shl sreg.startbit),
               sreg.subsetreg)
           else
             a_load_const_reg(list,sreg.subsetregsize,-1,sreg.subsetreg);
         else
           a_op_reg_reg(list,OP_OR,sreg.subsetregsize,tmpreg,sreg.subsetreg);
        end;
     end;


    procedure tcg.a_load_subsetreg_subsetreg(list: TAsmlist; fromsubsetsize, tosubsetsize : tcgsize; const fromsreg, tosreg: tsubsetregister);
      var
        tmpreg: tregister;
        bitmask: aword;
        stopbit: byte;
      begin
        if (fromsreg.bitlen >= tosreg.bitlen) then
          begin
            tmpreg := getintregister(list,tosreg.subsetregsize);
            a_load_reg_reg(list,fromsreg.subsetregsize,tosreg.subsetregsize,fromsreg.subsetreg,tmpreg);
            if (fromsreg.startbit <= tosreg.startbit) then
              a_op_const_reg(list,OP_SHL,tosreg.subsetregsize,tosreg.startbit-fromsreg.startbit,tmpreg)
            else
              a_op_const_reg(list,OP_SHR,tosreg.subsetregsize,fromsreg.startbit-tosreg.startbit,tmpreg);
            stopbit := tosreg.startbit + tosreg.bitlen;
            // on x86(64), 1 shl 32(64) = 1 instead of 0
            if (stopbit <> AIntBits) then
              bitmask := not(((aword(1) shl stopbit)-1) xor ((aword(1) shl tosreg.startbit)-1))
             else
               bitmask := (aword(1) shl tosreg.startbit) - 1;
            a_op_const_reg(list,OP_AND,tosreg.subsetregsize,aint(bitmask),tosreg.subsetreg);
            a_op_const_reg(list,OP_AND,tosreg.subsetregsize,aint(not(bitmask)),tmpreg);
            a_op_reg_reg(list,OP_OR,tosreg.subsetregsize,tmpreg,tosreg.subsetreg);
          end
        else
          begin
            tmpreg := getintregister(list,tosubsetsize);
            a_load_subsetreg_reg(list,fromsubsetsize,tosubsetsize,fromsreg,tmpreg);
            a_load_reg_subsetreg(list,tosubsetsize,tosubsetsize,tmpreg,tosreg);
          end;
      end;


   procedure tcg.a_load_subsetreg_ref(list : TAsmList; subsetsize, tosize: tcgsize; const sreg: tsubsetregister; const destref: treference);
     var
       tmpreg: tregister;
     begin
       tmpreg := getintregister(list,tosize);
       a_load_subsetreg_reg(list,subsetsize,tosize,sreg,tmpreg);
       a_load_reg_ref(list,tosize,tosize,tmpreg,destref);
     end;


   procedure tcg.a_load_ref_subsetreg(list : TAsmList; fromsize, subsetsize: tcgsize; const fromref: treference; const sreg: tsubsetregister);
     var
       tmpreg: tregister;
     begin
       tmpreg := getintregister(list,subsetsize);
       a_load_ref_reg(list,fromsize,subsetsize,fromref,tmpreg);
       a_load_reg_subsetreg(list,subsetsize,subsetsize,tmpreg,sreg);
     end;


  procedure tcg.a_load_const_subsetreg(list: TAsmlist; subsetsize: tcgsize; a: aint; const sreg: tsubsetregister);
    var
      bitmask: aword;
      stopbit: byte;
    begin
       stopbit := sreg.startbit + sreg.bitlen;
       // on x86(64), 1 shl 32(64) = 1 instead of 0
       if (stopbit <> AIntBits) then
         bitmask := not(((aword(1) shl stopbit)-1) xor ((aword(1) shl sreg.startbit)-1))
       else
         bitmask := (aword(1) shl sreg.startbit) - 1;
       if (((aword(a) shl sreg.startbit) and not bitmask) <> not bitmask) then
         a_op_const_reg(list,OP_AND,sreg.subsetregsize,aint(bitmask),sreg.subsetreg);
       a_op_const_reg(list,OP_OR,sreg.subsetregsize,aint((aword(a) shl sreg.startbit) and not(bitmask)),sreg.subsetreg);
    end;


    procedure tcg.a_load_loc_subsetref(list : TAsmList;subsetsize: tcgsize; const loc: tlocation; const sref : tsubsetreference);
      begin
        case loc.loc of
          LOC_REFERENCE,LOC_CREFERENCE:
            a_load_ref_subsetref(list,loc.size,subsetsize,loc.reference,sref);
          LOC_REGISTER,LOC_CREGISTER:
            a_load_reg_subsetref(list,loc.size,subsetsize,loc.register,sref);
          LOC_CONSTANT:
            a_load_const_subsetref(list,subsetsize,loc.value,sref);
          LOC_SUBSETREG,LOC_CSUBSETREG:
            a_load_subsetreg_subsetref(list,loc.size,subsetsize,loc.sreg,sref);
          LOC_SUBSETREF,LOC_CSUBSETREF:
            a_load_subsetref_subsetref(list,loc.size,subsetsize,loc.sref,sref);
          else
            internalerror(200608053);
        end;
      end;


(*
  Subsetrefs are used for (bit)packed arrays and (bit)packed records stored
  in memory. They are like a regular reference, but contain an extra bit
  offset (either constant -startbit- or variable -bitindexreg-, always OS_INT)
  and a bit length (always constant).

  Bit packed values are stored differently in memory depending on whether we
  are on a big or a little endian system (compatible with at least GPC). The
  size of the basic working unit is always the smallest power-of-2 byte size
  which can contain the bit value (so 1..8 bits -> 1 byte, 9..16 bits -> 2
  bytes, 17..32 bits -> 4 bytes etc).

  On a big endian, 5-bit: values are stored like this:
    11111222 22333334 44445555 56666677 77788888
  The leftmost bit of each 5-bit value corresponds to the most significant
  bit.

  On little endian, it goes like this:
    22211111 43333322 55554444 77666665 88888777
  In this case, per byte the left-most bit is more significant than those on
  the right, but the bits in the next byte are all more significant than
  those in the previous byte (e.g., the 222 in the first byte are the low
  three bits of that value, while the 22 in the second byte are the upper
  two bits.

  Big endian, 9 bit values:
    11111111 12222222 22333333 33344444 ...

  Little endian, 9 bit values:
    11111111 22222221 33333322 44444333 ...
  This is memory representation and the 16 bit values are byteswapped.
  Similarly as in the previous case, the 2222222 string contains the lower
  bits of value 2 and the 22 string contains the upper bits. Once loaded into
  registers (two 16 bit registers in the current implementation, although a
  single 32 bit register would be possible too, in particular if 32 bit
  alignment can be guaranteed), this becomes:
    22222221 11111111 44444333 33333322 ...
    (l)ow  u     l     l    u     l   u

  The startbit/bitindex in a subsetreference always refers to
  a) on big endian: the most significant bit of the value
     (bits counted from left to right, both memory an registers)
  b) on little endian: the least significant bit when the value
     is loaded in a register (bit counted from right to left)

  Although a) results in more complex code for big endian systems, it's
  needed for compatibility both with GPC and with e.g. bitpacked arrays in
  Apple's universal interfaces which depend on these layout differences).

  Note: when changing the loadsize calculated in get_subsetref_load_info,
  make sure the appropriate alignment is guaranteed, at least in case of
  {$defined cpurequiresproperalignment}.
*)

    procedure tcg.get_subsetref_load_info(const sref: tsubsetreference; out loadsize: tcgsize; out extra_load: boolean);
      var
        intloadsize: aint;
      begin
        intloadsize := packedbitsloadsize(sref.bitlen);

{$if not defined(arm)}
        { may need to be split into several smaller loads/stores }
        if (tf_requires_proper_alignment in target_info.flags) and
           (intloadsize <> sref.ref.alignment) then
          internalerror(2006082011);
{$endif not defined(arm)}

        if (intloadsize = 0) then
          internalerror(2006081310);

        if (intloadsize > sizeof(aint)) then
          intloadsize := sizeof(aint);
        loadsize := int_cgsize(intloadsize);

        if (loadsize = OS_NO) then
          internalerror(2006081311);
        if (sref.bitlen > sizeof(aint)*8) then
          internalerror(2006081312);

        extra_load :=
          (sref.bitlen <> 1) and
          ((sref.bitindexreg <> NR_NO) or
           (byte(sref.startbit+sref.bitlen) > byte(intloadsize*8)));
      end;


    procedure tcg.a_load_subsetref_regs_noindex(list: TAsmList; subsetsize: tcgsize; loadbitsize: byte; const sref: tsubsetreference; valuereg, extra_value_reg: tregister);
      var
        restbits: byte;
      begin
        if (target_info.endian = endian_big) then
          begin
            { valuereg contains the upper bits, extra_value_reg the lower }
            restbits := (sref.bitlen - (loadbitsize - sref.startbit));
            if (subsetsize in [OS_S8..OS_S128]) then
              begin
                { sign extend }
                a_op_const_reg(list,OP_SHL,OS_INT,AIntBits-loadbitsize+sref.startbit,valuereg);
                a_op_const_reg(list,OP_SAR,OS_INT,AIntBits-sref.bitlen,valuereg);
              end
            else
              begin
                a_op_const_reg(list,OP_SHL,OS_INT,restbits,valuereg);
                { mask other bits }
                if (sref.bitlen <> AIntBits) then
                  a_op_const_reg(list,OP_AND,OS_INT,aint((aword(1) shl sref.bitlen)-1),valuereg);
              end;
            a_op_const_reg(list,OP_SHR,OS_INT,loadbitsize-restbits,extra_value_reg)
          end
        else
          begin
            { valuereg contains the lower bits, extra_value_reg the upper }
            a_op_const_reg(list,OP_SHR,OS_INT,sref.startbit,valuereg);
            if (subsetsize in [OS_S8..OS_S128]) then
              begin
                a_op_const_reg(list,OP_SHL,OS_INT,AIntBits-sref.bitlen+loadbitsize-sref.startbit,extra_value_reg);
                a_op_const_reg(list,OP_SAR,OS_INT,AIntBits-sref.bitlen,extra_value_reg);
              end
            else
              begin
                a_op_const_reg(list,OP_SHL,OS_INT,loadbitsize-sref.startbit,extra_value_reg);
                { mask other bits }
                if (sref.bitlen <> AIntBits) then
                  a_op_const_reg(list,OP_AND,OS_INT,aint((aword(1) shl sref.bitlen)-1),extra_value_reg);
              end;
          end;
        { merge }
        a_op_reg_reg(list,OP_OR,OS_INT,extra_value_reg,valuereg);
      end;


    procedure tcg.a_load_subsetref_regs_index(list: TAsmList; subsetsize: tcgsize; loadbitsize: byte; const sref: tsubsetreference; valuereg, extra_value_reg: tregister);
      var
        tmpreg: tregister;
      begin
        tmpreg := getintregister(list,OS_INT);
        if (target_info.endian = endian_big) then
          begin
            { since this is a dynamic index, it's possible that the value   }
            { is entirely in valuereg.                                      }

            { get the data in valuereg in the right place }
            a_op_reg_reg(list,OP_SHL,OS_INT,sref.bitindexreg,valuereg);
            if (subsetsize in [OS_S8..OS_S128]) then
              begin
                a_op_const_reg(list,OP_SHL,OS_INT,AIntBits-loadbitsize,valuereg);
                a_op_const_reg(list,OP_SAR,OS_INT,AIntBits-sref.bitlen,valuereg)
              end
            else
              begin
                a_op_const_reg(list,OP_SHR,OS_INT,loadbitsize-sref.bitlen,valuereg);
                if (loadbitsize <> AIntBits) then
                  { mask left over bits }
                  a_op_const_reg(list,OP_AND,OS_INT,aint((aword(1) shl sref.bitlen)-1),valuereg);
              end;
            tmpreg := getintregister(list,OS_INT);
            { the bits in extra_value_reg (if any) start at the most significant bit =>         }
            { extra_value_reg must be shr by (loadbitsize-sref.bitlen)+(loadsize-sref.bitindex) }
            { => = -(sref.bitindex+(sref.bitlen-2*loadbitsize))                                 }
            a_op_const_reg_reg(list,OP_ADD,OS_INT,sref.bitlen-2*loadbitsize,sref.bitindexreg,tmpreg);
            a_op_reg_reg(list,OP_NEG,OS_INT,tmpreg,tmpreg);
            a_op_reg_reg(list,OP_SHR,OS_INT,tmpreg,extra_value_reg);
            { if there are no bits in extra_value_reg, then sref.bitindex was      }
            { < loadsize-sref.bitlen, and therefore tmpreg will now be >= loadsize }
            { => extra_value_reg is now 0                                          }

            { merge }
            a_op_reg_reg(list,OP_OR,OS_INT,extra_value_reg,valuereg);
            { no need to mask, necessary masking happened earlier on }
          end
        else
          begin
            a_op_reg_reg(list,OP_SHR,OS_INT,sref.bitindexreg,valuereg);
            { Y-x = -(Y-x) }
            a_op_const_reg_reg(list,OP_SUB,OS_INT,loadbitsize,sref.bitindexreg,tmpreg);
            a_op_reg_reg(list,OP_NEG,OS_INT,tmpreg,tmpreg);
            { tmpreg is in the range 1..<cpu_bitsize> -> will zero extra_value_reg }
            { if all bits are in valuereg                                          }
            a_op_reg_reg(list,OP_SHL,OS_INT,tmpreg,extra_value_reg);
{$ifdef x86}
            { on i386 "x shl 32 = x shl 0", on x86/64 "x shl 64 = x shl 0". Fix so it's 0. }
            if (loadbitsize = AIntBits) then
              begin
                { if (tmpreg >= cpu_bit_size) then tmpreg := 1 else tmpreg := 0 }
                a_op_const_reg(list,OP_SHR,OS_INT,{$ifdef cpu64bit}6{$else}5{$endif},tmpreg);
                { if (tmpreg = cpu_bit_size) then tmpreg := 0 else tmpreg := -1 }
                a_op_const_reg(list,OP_SUB,OS_INT,1,tmpreg);
                { if (tmpreg = cpu_bit_size) then extra_value_reg := 0 }
                a_op_reg_reg(list,OP_AND,OS_INT,tmpreg,extra_value_reg);
              end;
{$endif x86}
            { merge }
            a_op_reg_reg(list,OP_OR,OS_INT,extra_value_reg,valuereg);
            { sign extend or mask other bits }
            if (subsetsize in [OS_S8..OS_S128]) then
              begin
                a_op_const_reg(list,OP_SHL,OS_INT,AIntBits-sref.bitlen,valuereg);
                a_op_const_reg(list,OP_SAR,OS_INT,AIntBits-sref.bitlen,valuereg);
              end
            else
              a_op_const_reg(list,OP_AND,OS_INT,aint((aword(1) shl sref.bitlen)-1),valuereg);
          end;
      end;


    procedure tcg.a_load_subsetref_reg(list : TAsmList; subsetsize, tosize: tcgsize; const sref: tsubsetreference; destreg: tregister);
      var
        tmpref: treference;
        valuereg,extra_value_reg: tregister;
        tosreg: tsubsetregister;
        loadsize: tcgsize;
        loadbitsize: byte;
        extra_load: boolean;
      begin

        get_subsetref_load_info(sref,loadsize,extra_load);
        loadbitsize := tcgsize2size[loadsize]*8;

        { load the (first part) of the bit sequence }
        valuereg := cg.getintregister(list,OS_INT);
        a_load_ref_reg(list,loadsize,OS_INT,sref.ref,valuereg);

        if not extra_load then
          begin
            { everything is guaranteed to be in a single register of loadsize }
            if (sref.bitindexreg = NR_NO) then
              begin
                { use subsetreg routine, it may have been overridden with an optimized version }
                tosreg.subsetreg := valuereg;
                tosreg.subsetregsize := OS_INT;
                { subsetregs always count bits from right to left }
                if (target_info.endian = endian_big) then
                  tosreg.startbit := loadbitsize - (sref.startbit+sref.bitlen)
                else
                  tosreg.startbit := sref.startbit;
                tosreg.bitlen := sref.bitlen;
                a_load_subsetreg_reg(list,subsetsize,tosize,tosreg,destreg);
                exit;
              end
            else
              begin
                if (sref.startbit <> 0) then
                  internalerror(2006081510);
                if (target_info.endian = endian_big) then
                  begin
                    a_op_reg_reg(list,OP_SHL,OS_INT,sref.bitindexreg,valuereg);
                    if (subsetsize in [OS_S8..OS_S128]) then
                      begin
                        { sign extend to entire register }
                        a_op_const_reg(list,OP_SHL,OS_INT,AIntBits-loadbitsize,valuereg);
                        a_op_const_reg(list,OP_SAR,OS_INT,AIntBits-sref.bitlen,valuereg);
                      end
                    else
                      a_op_const_reg(list,OP_SHR,OS_INT,loadbitsize-sref.bitlen,valuereg);
                  end
                else
                  begin
                    a_op_reg_reg(list,OP_SHR,OS_INT,sref.bitindexreg,valuereg);
                    if (subsetsize in [OS_S8..OS_S128]) then
                      begin
                        a_op_const_reg(list,OP_SHL,OS_INT,AIntBits-sref.bitlen,valuereg);
                        a_op_const_reg(list,OP_SAR,OS_INT,AIntBits-sref.bitlen,valuereg);
                      end
                  end;
                { mask other bits/sign extend }
                if not(subsetsize in [OS_S8..OS_S128]) then
                  a_op_const_reg(list,OP_AND,OS_INT,aint((aword(1) shl sref.bitlen)-1),valuereg);
              end
          end
        else
          begin
            { load next value as well }
            extra_value_reg := getintregister(list,OS_INT);
            tmpref := sref.ref;
            inc(tmpref.offset,loadbitsize div 8);
            a_load_ref_reg(list,loadsize,OS_INT,tmpref,extra_value_reg);

            if (sref.bitindexreg = NR_NO) then
              { can be overridden to optimize }
              a_load_subsetref_regs_noindex(list,subsetsize,loadbitsize,sref,valuereg,extra_value_reg)
            else
              begin
                if (sref.startbit <> 0) then
                  internalerror(2006080610);
                a_load_subsetref_regs_index(list,subsetsize,loadbitsize,sref,valuereg,extra_value_reg);
              end;
          end;

        { store in destination }
        { avoid unnecessary sign extension and zeroing }
        valuereg := makeregsize(list,valuereg,OS_INT);
        destreg := makeregsize(list,destreg,OS_INT);
        a_load_reg_reg(list,OS_INT,OS_INT,valuereg,destreg);
        destreg := makeregsize(list,destreg,tosize);
      end;


    procedure tcg.a_load_reg_subsetref(list : TAsmList; fromsize, subsetsize: tcgsize; fromreg: tregister; const sref: tsubsetreference);
      begin
        a_load_regconst_subsetref_intern(list,fromsize,subsetsize,fromreg,sref,SL_REG);
      end;


    procedure tcg.a_load_regconst_subsetref_intern(list : TAsmList; fromsize, subsetsize: tcgsize; fromreg: tregister; const sref: tsubsetreference; slopt: tsubsetloadopt);
      var
        tmpreg, tmpindexreg, valuereg, extra_value_reg, maskreg: tregister;
        tosreg, fromsreg: tsubsetregister;
        tmpref: treference;
        loadsize: tcgsize;
        loadbitsize: byte;
        extra_load: boolean;
      begin
        { the register must be able to contain the requested value }
        if (tcgsize2size[fromsize]*8 < sref.bitlen) then
          internalerror(2006081613);

        get_subsetref_load_info(sref,loadsize,extra_load);
        loadbitsize := tcgsize2size[loadsize]*8;

        { load the (first part) of the bit sequence }
        valuereg := cg.getintregister(list,OS_INT);
        a_load_ref_reg(list,loadsize,OS_INT,sref.ref,valuereg);

        { constant offset of bit sequence? }
        if not extra_load then
          begin
            if (sref.bitindexreg = NR_NO) then
              begin
                { use subsetreg routine, it may have been overridden with an optimized version }
                tosreg.subsetreg := valuereg;
                tosreg.subsetregsize := OS_INT;
                { subsetregs always count bits from right to left }
                if (target_info.endian = endian_big) then
                  tosreg.startbit := loadbitsize - (sref.startbit+sref.bitlen)
                else
                  tosreg.startbit := sref.startbit;
                tosreg.bitlen := sref.bitlen;
                a_load_regconst_subsetreg_intern(list,fromsize,subsetsize,fromreg,tosreg,slopt);
              end
            else
              begin
                if (sref.startbit <> 0) then
                  internalerror(2006081710);
                { should be handled by normal code and will give wrong result }
                { on x86 for the '1 shl bitlen' below                         }
                if (sref.bitlen = AIntBits) then
                  internalerror(2006081711);

                { calculated correct shiftcount for big endian }
                tmpindexreg := getintregister(list,OS_INT);
                a_load_reg_reg(list,OS_INT,OS_INT,sref.bitindexreg,tmpindexreg);
                if (target_info.endian = endian_big) then
                  begin
                    a_op_const_reg(list,OP_SUB,OS_INT,loadbitsize-sref.bitlen,tmpindexreg);
                    a_op_reg_reg(list,OP_NEG,OS_INT,tmpindexreg,tmpindexreg);
                  end;

                { zero the bits we have to insert }
                if (slopt <> SL_SETMAX) then
                  begin
                    maskreg := getintregister(list,OS_INT);
                    a_load_const_reg(list,OS_INT,aint((aword(1) shl sref.bitlen)-1),maskreg);
                    a_op_reg_reg(list,OP_SHL,OS_INT,tmpindexreg,maskreg);
                    a_op_reg_reg(list,OP_NOT,OS_INT,maskreg,maskreg);
                    a_op_reg_reg(list,OP_AND,OS_INT,maskreg,valuereg);
                  end;

                { insert the value }
                if (slopt <> SL_SETZERO) then
                  begin
                    tmpreg := getintregister(list,OS_INT);
                    if (slopt <> SL_SETMAX) then
                      a_load_reg_reg(list,fromsize,OS_INT,fromreg,tmpreg)
                    else if (sref.bitlen <> AIntBits) then
                      a_load_const_reg(list,OS_INT,aint((aword(1) shl sref.bitlen) - 1), tmpreg)
                    else
                      a_load_const_reg(list,OS_INT,-1,tmpreg);
                    if (slopt <> SL_REGNOSRCMASK) then
                      a_op_const_reg(list,OP_AND,OS_INT,aint((aword(1) shl sref.bitlen)-1),tmpreg);
                    a_op_reg_reg(list,OP_SHL,OS_INT,tmpindexreg,tmpreg);
                    a_op_reg_reg(list,OP_OR,OS_INT,tmpreg,valuereg);
                  end;
              end;
            { store back to memory }
            valuereg := makeregsize(list,valuereg,loadsize);
            a_load_reg_ref(list,loadsize,loadsize,valuereg,sref.ref);
            exit;
          end
        else
          begin
            { load next value }
            extra_value_reg := getintregister(list,OS_INT);
            tmpref := sref.ref;
            inc(tmpref.offset,loadbitsize div 8);

            { should maybe be taken out too, can be done more efficiently }
            { on e.g. i386 with shld/shrd                                 }
            if (sref.bitindexreg = NR_NO) then
              begin
                a_load_ref_reg(list,loadsize,OS_INT,tmpref,extra_value_reg);

                fromsreg.subsetreg := fromreg;
                fromsreg.subsetregsize := fromsize;
                tosreg.subsetreg := valuereg;
                tosreg.subsetregsize := OS_INT;

                { transfer first part }
                fromsreg.bitlen := loadbitsize-sref.startbit;
                tosreg.bitlen := fromsreg.bitlen;
                if (target_info.endian = endian_big) then
                  begin
                    { valuereg must contain the upper bits of the value at bits [0..loadbitsize-startbit] }

                    { upper bits of the value ... }
                    fromsreg.startbit := sref.bitlen-(loadbitsize-sref.startbit);
                    { ... to bit 0 }
                    tosreg.startbit := 0
                  end
                else
                  begin
                    { valuereg must contain the lower bits of the value at bits [startbit..loadbitsize] }

                    { lower bits of the value ... }
                    fromsreg.startbit := 0;
                    { ... to startbit }
                    tosreg.startbit := sref.startbit;
                  end;
                a_load_subsetreg_subsetreg(list,subsetsize,subsetsize,fromsreg,tosreg);
                valuereg := makeregsize(list,valuereg,loadsize);
                a_load_reg_ref(list,loadsize,loadsize,valuereg,sref.ref);

                { transfer second part }
                if (target_info.endian = endian_big) then
                  begin
                    { extra_value_reg must contain the lower bits of the value at bits  }
                    { [(loadbitsize-(bitlen-(loadbitsize-startbit)))..loadbitsize]  }
                    { (loadbitsize-(bitlen-(loadbitsize-startbit))) = 2*loadbitsize }
                    { - bitlen - startbit }

                    fromsreg.startbit := 0;
                    tosreg.startbit := 2*loadbitsize - sref.bitlen - sref.startbit
                  end
                else
                  begin
                    { extra_value_reg must contain the upper bits of the value at bits [0..bitlen-(loadbitsize-startbit)] }

                    fromsreg.startbit := fromsreg.bitlen;
                    tosreg.startbit := 0;
                  end;
                tosreg.subsetreg := extra_value_reg;
                fromsreg.bitlen := sref.bitlen-fromsreg.bitlen;
                tosreg.bitlen := fromsreg.bitlen;

                a_load_subsetreg_subsetreg(list,fromsize,subsetsize,fromsreg,tosreg);
                extra_value_reg := makeregsize(list,extra_value_reg,loadsize);
                a_load_reg_ref(list,loadsize,loadsize,extra_value_reg,tmpref);
                exit;
              end
            else
              begin
                if (sref.startbit <> 0) then
                  internalerror(2006081812);
                { should be handled by normal code and will give wrong result }
                { on x86 for the '1 shl bitlen' below                         }
                if (sref.bitlen = AIntBits) then
                  internalerror(2006081713);

                { generate mask to zero the bits we have to insert }
                if (slopt <> SL_SETMAX) then
                  begin
                    maskreg := getintregister(list,OS_INT);
                    if (target_info.endian = endian_big) then
                      begin
                        a_load_const_reg(list,OS_INT,aint(((aword(1) shl sref.bitlen)-1) shl (loadbitsize-sref.bitlen)),maskreg);
                        a_op_reg_reg(list,OP_SHR,OS_INT,sref.bitindexreg,maskreg);
                      end
                    else
                      begin
                        a_load_const_reg(list,OS_INT,aint((aword(1) shl sref.bitlen)-1),maskreg);
                        a_op_reg_reg(list,OP_SHL,OS_INT,sref.bitindexreg,maskreg);
                      end;

                    a_op_reg_reg(list,OP_NOT,OS_INT,maskreg,maskreg);
                    a_op_reg_reg(list,OP_AND,OS_INT,maskreg,valuereg);
                  end;

                { insert the value }
                if (slopt <> SL_SETZERO) then
                  begin
                    tmpreg := getintregister(list,OS_INT);
                    if (slopt <> SL_SETMAX) then
                      a_load_reg_reg(list,fromsize,OS_INT,fromreg,tmpreg)
                    else if (sref.bitlen <> AIntBits) then
                      a_load_const_reg(list,OS_INT,aint((aword(1) shl sref.bitlen) - 1), tmpreg)
                    else
                      a_load_const_reg(list,OS_INT,-1,tmpreg);
                    if (target_info.endian = endian_big) then
                      begin
                        a_op_const_reg(list,OP_SHL,OS_INT,loadbitsize-sref.bitlen,tmpreg);
                        if not(slopt in [SL_REGNOSRCMASK,SL_SETMAX]) then
                          { mask left over bits }
                          a_op_const_reg(list,OP_AND,OS_INT,aint(((aword(1) shl sref.bitlen)-1) shl (loadbitsize-sref.bitlen)),tmpreg);
                        a_op_reg_reg(list,OP_SHR,OS_INT,sref.bitindexreg,tmpreg);
                      end
                    else
                      begin
                        if not(slopt in [SL_REGNOSRCMASK,SL_SETMAX]) then
                          { mask left over bits }
                          a_op_const_reg(list,OP_AND,OS_INT,aint((aword(1) shl sref.bitlen)-1),tmpreg);
                        a_op_reg_reg(list,OP_SHL,OS_INT,sref.bitindexreg,tmpreg);
                      end;
                    a_op_reg_reg(list,OP_OR,OS_INT,tmpreg,valuereg);
                  end;
                valuereg := makeregsize(list,valuereg,loadsize);
                a_load_reg_ref(list,loadsize,loadsize,valuereg,sref.ref);


                a_load_ref_reg(list,loadsize,OS_INT,tmpref,extra_value_reg);
                tmpindexreg := getintregister(list,OS_INT);

               { load current array value }
               if (slopt <> SL_SETZERO) then
                 begin
                   tmpreg := getintregister(list,OS_INT);
                   if (slopt <> SL_SETMAX) then
                     a_load_reg_reg(list,fromsize,OS_INT,fromreg,tmpreg)
                   else if (sref.bitlen <> AIntBits) then
                     a_load_const_reg(list,OS_INT,aint((aword(1) shl sref.bitlen) - 1), tmpreg)
                   else
                     a_load_const_reg(list,OS_INT,-1,tmpreg);
                 end;

                { generate mask to zero the bits we have to insert }
                if (slopt <> SL_SETMAX) then
                  begin
                    maskreg := getintregister(list,OS_INT);
                    if (target_info.endian = endian_big) then
                      begin
                        a_op_const_reg_reg(list,OP_ADD,OS_INT,sref.bitlen-2*loadbitsize,sref.bitindexreg,tmpindexreg);
                        a_op_reg_reg(list,OP_NEG,OS_INT,tmpindexreg,tmpindexreg);
                        a_load_const_reg(list,OS_INT,aint((aword(1) shl sref.bitlen)-1),maskreg);
                        a_op_reg_reg(list,OP_SHL,OS_INT,tmpindexreg,maskreg);
                      end
                    else
                      begin
                        { Y-x = -(Y-x) }
                        a_op_const_reg_reg(list,OP_SUB,OS_INT,loadbitsize,sref.bitindexreg,tmpindexreg);
                        a_op_reg_reg(list,OP_NEG,OS_INT,tmpindexreg,tmpindexreg);
                        a_load_const_reg(list,OS_INT,aint((aword(1) shl sref.bitlen)-1),maskreg);
                        a_op_reg_reg(list,OP_SHR,OS_INT,tmpindexreg,maskreg);
{$ifdef x86}
                        { on i386 "x shl 32 = x shl 0", on x86/64 "x shl 64 = x shl 0". Fix so it's 0. }
                        if (loadbitsize = AIntBits) then
                          begin
                            valuereg := getintregister(list,OS_INT);
                            { if (tmpindexreg >= cpu_bit_size) then valuereg := 1 else valuereg := 0 }
                            a_op_const_reg_reg(list,OP_SHR,OS_INT,{$ifdef cpu64bit}6{$else}5{$endif},tmpindexreg,valuereg);
                            { if (tmpindexreg = cpu_bit_size) then valuereg := 0 else valuereg := -1 }
                            a_op_const_reg(list,OP_SUB,OS_INT,1,valuereg);
                            { if (tmpindexreg = cpu_bit_size) then tmpreg := maskreg := 0 }
                            if (slopt <> SL_SETZERO) then
                              a_op_reg_reg(list,OP_AND,OS_INT,valuereg,tmpreg);
                            a_op_reg_reg(list,OP_AND,OS_INT,valuereg,maskreg);
                          end;
{$endif x86}
                      end;

                    a_op_reg_reg(list,OP_NOT,OS_INT,maskreg,maskreg);
                    a_op_reg_reg(list,OP_AND,OS_INT,maskreg,extra_value_reg);
                  end;

                if (slopt <> SL_SETZERO) then
                  begin
                    if (target_info.endian = endian_big) then
                      a_op_reg_reg(list,OP_SHL,OS_INT,tmpindexreg,tmpreg)
                    else
                      begin
                        if not(slopt in [SL_REGNOSRCMASK,SL_SETMAX]) then
                          a_op_const_reg(list,OP_AND,OS_INT,aint((aword(1) shl sref.bitlen)-1),tmpreg);
                        a_op_reg_reg(list,OP_SHR,OS_INT,tmpindexreg,tmpreg);
                      end;
                    a_op_reg_reg(list,OP_OR,OS_INT,tmpreg,extra_value_reg);
                  end;
                extra_value_reg := makeregsize(list,extra_value_reg,loadsize);
                a_load_reg_ref(list,loadsize,loadsize,extra_value_reg,tmpref);
              end;
          end;
      end;


    procedure tcg.a_load_subsetref_subsetref(list: TAsmlist; fromsubsetsize, tosubsetsize : tcgsize; const fromsref, tosref: tsubsetreference);
      var
        tmpreg: tregister;
      begin
        tmpreg := getintregister(list,tosubsetsize);
        a_load_subsetref_reg(list,fromsubsetsize,tosubsetsize,fromsref,tmpreg);
        a_load_reg_subsetref(list,tosubsetsize,tosubsetsize,tmpreg,tosref);
      end;


    procedure tcg.a_load_subsetref_ref(list : TAsmList; subsetsize, tosize: tcgsize; const sref: tsubsetreference; const destref: treference);
      var
        tmpreg: tregister;
      begin
        tmpreg := getintregister(list,tosize);
        a_load_subsetref_reg(list,subsetsize,tosize,sref,tmpreg);
        a_load_reg_ref(list,tosize,tosize,tmpreg,destref);
      end;


    procedure tcg.a_load_ref_subsetref(list : TAsmList; fromsize, subsetsize: tcgsize; const fromref: treference; const sref: tsubsetreference);
      var
        tmpreg: tregister;
      begin
        tmpreg := getintregister(list,subsetsize);
        a_load_ref_reg(list,fromsize,subsetsize,fromref,tmpreg);
        a_load_reg_subsetref(list,subsetsize,subsetsize,tmpreg,sref);
      end;


    procedure tcg.a_load_const_subsetref(list: TAsmlist; subsetsize: tcgsize; a: aint; const sref: tsubsetreference);
      var
        tmpreg: tregister;
        slopt: tsubsetloadopt;
      begin
        { perform masking of the source value in advance }
        slopt := SL_REGNOSRCMASK;
        if (sref.bitlen <> AIntBits) then
          aword(a) := aword(a) and ((aword(1) shl sref.bitlen) -1); 
        if (
            { broken x86 "x shl regbitsize = x" }
            ((sref.bitlen <> AIntBits) and
             ((aword(a) and ((aword(1) shl sref.bitlen) -1)) = (aword(1) shl sref.bitlen) -1)) or
            ((sref.bitlen = AIntBits) and
             (a = -1))
           ) then
          slopt := SL_SETMAX
        else if (a = 0) then
          slopt := SL_SETZERO;
        tmpreg := getintregister(list,subsetsize);
        if not(slopt in [SL_SETZERO,SL_SETMAX]) then
          a_load_const_reg(list,subsetsize,a,tmpreg);
        a_load_regconst_subsetref_intern(list,subsetsize,subsetsize,tmpreg,sref,slopt);
      end;


    procedure tcg.a_load_subsetref_loc(list: TAsmlist; subsetsize: tcgsize; const sref: tsubsetreference; const loc: tlocation);
      begin
        case loc.loc of
          LOC_REFERENCE,LOC_CREFERENCE:
            a_load_subsetref_ref(list,subsetsize,loc.size,sref,loc.reference);
          LOC_REGISTER,LOC_CREGISTER:
            a_load_subsetref_reg(list,subsetsize,loc.size,sref,loc.register);
          LOC_SUBSETREG,LOC_CSUBSETREG:
            a_load_subsetref_subsetreg(list,subsetsize,loc.size,sref,loc.sreg);
          LOC_SUBSETREF,LOC_CSUBSETREF:
            a_load_subsetref_subsetref(list,subsetsize,loc.size,sref,loc.sref);
          else
            internalerror(200608054);
        end;
      end;


    procedure tcg.a_load_subsetref_subsetreg(list: TAsmlist; fromsubsetsize, tosubsetsize : tcgsize; const fromsref: tsubsetreference; const tosreg: tsubsetregister);
      var
        tmpreg: tregister;
      begin
        tmpreg := getintregister(list,tosubsetsize);
        a_load_subsetref_reg(list,fromsubsetsize,tosubsetsize,fromsref,tmpreg);
        a_load_reg_subsetreg(list,tosubsetsize,tosubsetsize,tmpreg,tosreg);
      end;


    procedure tcg.a_load_subsetreg_subsetref(list: TAsmlist; fromsubsetsize, tosubsetsize : tcgsize; const fromsreg: tsubsetregister; const tosref: tsubsetreference);
      var
        tmpreg: tregister;
      begin
        tmpreg := getintregister(list,tosubsetsize);
        a_load_subsetreg_reg(list,fromsubsetsize,tosubsetsize,fromsreg,tmpreg);
        a_load_reg_subsetref(list,tosubsetsize,tosubsetsize,tmpreg,tosref);
      end;


{$ifdef rangeon}
{$r+}
{$undef rangeon}
{$endif}

{$ifdef overflowon}
{$q+}
{$undef overflowon}
{$endif}


    procedure tcg.a_load_ref_ref(list : TAsmList;fromsize,tosize : tcgsize;const sref : treference;const dref : treference);
      var
        tmpreg: tregister;
      begin
        { verify if we have the same reference }
        if references_equal(sref,dref) then
          exit;
        tmpreg:=getintregister(list,tosize);
        a_load_ref_reg(list,fromsize,tosize,sref,tmpreg);
        a_load_reg_ref(list,tosize,tosize,tmpreg,dref);
      end;


    procedure tcg.a_load_const_ref(list : TAsmList;size : tcgsize;a : aint;const ref : treference);
      var
        tmpreg: tregister;
      begin
        tmpreg:=getintregister(list,size);
        a_load_const_reg(list,size,a,tmpreg);
        a_load_reg_ref(list,size,size,tmpreg,ref);
      end;


    procedure tcg.a_load_const_loc(list : TAsmList;a : aint;const loc: tlocation);
      begin
        case loc.loc of
          LOC_REFERENCE,LOC_CREFERENCE:
            a_load_const_ref(list,loc.size,a,loc.reference);
          LOC_REGISTER,LOC_CREGISTER:
            a_load_const_reg(list,loc.size,a,loc.register);
          LOC_SUBSETREG,LOC_CSUBSETREG:
            a_load_const_subsetreg(list,loc.size,a,loc.sreg);
          LOC_SUBSETREF,LOC_CSUBSETREF:
            a_load_const_subsetref(list,loc.size,a,loc.sref);
          else
            internalerror(200203272);
        end;
      end;


    procedure tcg.a_load_reg_loc(list : TAsmList;fromsize : tcgsize;reg : tregister;const loc: tlocation);
      begin
        case loc.loc of
          LOC_REFERENCE,LOC_CREFERENCE:
            a_load_reg_ref(list,fromsize,loc.size,reg,loc.reference);
          LOC_REGISTER,LOC_CREGISTER:
            a_load_reg_reg(list,fromsize,loc.size,reg,loc.register);
          LOC_SUBSETREG,LOC_CSUBSETREG:
            a_load_reg_subsetreg(list,fromsize,loc.size,reg,loc.sreg);
          LOC_SUBSETREF,LOC_CSUBSETREF:
            a_load_reg_subsetref(list,fromsize,loc.size,reg,loc.sref);
          else
            internalerror(200203271);
        end;
      end;


    procedure tcg.a_load_loc_reg(list : TAsmList; tosize: tcgsize; const loc: tlocation; reg : tregister);
      begin
        case loc.loc of
          LOC_REFERENCE,LOC_CREFERENCE:
            a_load_ref_reg(list,loc.size,tosize,loc.reference,reg);
          LOC_REGISTER,LOC_CREGISTER:
            a_load_reg_reg(list,loc.size,tosize,loc.register,reg);
          LOC_CONSTANT:
            a_load_const_reg(list,tosize,loc.value,reg);
          LOC_SUBSETREG,LOC_CSUBSETREG:
            a_load_subsetreg_reg(list,loc.size,tosize,loc.sreg,reg);
          LOC_SUBSETREF,LOC_CSUBSETREF:
            a_load_subsetref_reg(list,loc.size,tosize,loc.sref,reg);
          else
            internalerror(200109092);
        end;
      end;


    procedure tcg.a_load_loc_ref(list : TAsmList;tosize: tcgsize; const loc: tlocation; const ref : treference);
      begin
        case loc.loc of
          LOC_REFERENCE,LOC_CREFERENCE:
            a_load_ref_ref(list,loc.size,tosize,loc.reference,ref);
          LOC_REGISTER,LOC_CREGISTER:
            a_load_reg_ref(list,loc.size,tosize,loc.register,ref);
          LOC_CONSTANT:
            a_load_const_ref(list,tosize,loc.value,ref);
          LOC_SUBSETREG,LOC_CSUBSETREG:
            a_load_subsetreg_ref(list,loc.size,tosize,loc.sreg,ref);
          LOC_SUBSETREF,LOC_CSUBSETREF:
            a_load_subsetref_ref(list,loc.size,tosize,loc.sref,ref);
          else
            internalerror(200109302);
        end;
      end;


    procedure tcg.a_load_loc_subsetreg(list : TAsmList; subsetsize: tcgsize; const loc: tlocation; const sreg : tsubsetregister);
      begin
        case loc.loc of
          LOC_REFERENCE,LOC_CREFERENCE:
            a_load_ref_subsetreg(list,loc.size,subsetsize,loc.reference,sreg);
          LOC_REGISTER,LOC_CREGISTER:
            a_load_reg_subsetreg(list,loc.size,subsetsize,loc.register,sreg);
          LOC_CONSTANT:
            a_load_const_subsetreg(list,subsetsize,loc.value,sreg);
          LOC_SUBSETREG,LOC_CSUBSETREG:
            a_load_subsetreg_subsetreg(list,loc.size,subsetsize,loc.sreg,sreg);
          LOC_SUBSETREF,LOC_CSUBSETREF:
            a_load_subsetref_subsetreg(list,loc.size,subsetsize,loc.sref,sreg);
          else
            internalerror(2006052310);
        end;
      end;


    procedure tcg.a_load_subsetreg_loc(list: TAsmlist; subsetsize: tcgsize; const sreg: tsubsetregister; const loc: tlocation);
      begin
        case loc.loc of
          LOC_REFERENCE,LOC_CREFERENCE:
            a_load_subsetreg_ref(list,subsetsize,loc.size,sreg,loc.reference);
          LOC_REGISTER,LOC_CREGISTER:
            a_load_subsetreg_reg(list,subsetsize,loc.size,sreg,loc.register);
          LOC_SUBSETREG,LOC_CSUBSETREG:
            a_load_subsetreg_subsetreg(list,subsetsize,loc.size,sreg,loc.sreg);
          LOC_SUBSETREF,LOC_CSUBSETREF:
            a_load_subsetreg_subsetref(list,subsetsize,loc.size,sreg,loc.sref);
          else
            internalerror(2006051510);
        end;
      end;


    procedure tcg.optimize_op_const(var op: topcg; var a : aint);
      var
        powerval : longint;
      begin
        case op of
          OP_OR :
            begin
              { or with zero returns same result }
              if a = 0 then
                op:=OP_NONE
              else
              { or with max returns max }
                if a = -1 then
                  op:=OP_MOVE;
            end;
          OP_AND :
            begin
              { and with max returns same result }
              if (a = -1) then
                op:=OP_NONE
              else
              { and with 0 returns 0 }
                if a=0 then
                  op:=OP_MOVE;
            end;
          OP_DIV :
            begin
              { division by 1 returns result }
              if a = 1 then
                op:=OP_NONE
              else if ispowerof2(int64(a), powerval) and not(cs_check_overflow in current_settings.localswitches) then
                begin
                  a := powerval;
                  op:= OP_SHR;
                end;
            end;
          OP_IDIV:
            begin
              if a = 1 then
                op:=OP_NONE;
            end;
         OP_MUL,OP_IMUL:
            begin
               if a = 1 then
                 op:=OP_NONE
               else
                 if a=0 then
                   op:=OP_MOVE
               else if ispowerof2(int64(a), powerval) and not(cs_check_overflow in current_settings.localswitches)  then
                 begin
                   a := powerval;
                   op:= OP_SHL;
                 end;
            end;
        OP_ADD,OP_SUB:
            begin
               if a = 0 then
                 op:=OP_NONE;
            end;
        OP_SAR,OP_SHL,OP_SHR:
           begin
              if a = 0 then
                op:=OP_NONE;
           end;
        end;
      end;


    procedure tcg.a_loadfpu_loc_reg(list: TAsmList; tosize: tcgsize; const loc: tlocation; const reg: tregister);
      begin
        case loc.loc of
          LOC_REFERENCE, LOC_CREFERENCE:
            a_loadfpu_ref_reg(list,loc.size,tosize,loc.reference,reg);
          LOC_FPUREGISTER, LOC_CFPUREGISTER:
            a_loadfpu_reg_reg(list,loc.size,tosize,loc.register,reg);
          else
            internalerror(200203301);
        end;
      end;


    procedure tcg.a_loadfpu_reg_loc(list: TAsmList; fromsize: tcgsize; const reg: tregister; const loc: tlocation);
      begin
        case loc.loc of
          LOC_REFERENCE, LOC_CREFERENCE:
            a_loadfpu_reg_ref(list,fromsize,loc.size,reg,loc.reference);
          LOC_FPUREGISTER, LOC_CFPUREGISTER:
            a_loadfpu_reg_reg(list,fromsize,loc.size,reg,loc.register);
          else
            internalerror(48991);
         end;
      end;


    procedure tcg.a_paramfpu_reg(list : TAsmList;size : tcgsize;const r : tregister;const cgpara : TCGPara);
      var
         ref : treference;
      begin
         case cgpara.location^.loc of
            LOC_FPUREGISTER,LOC_CFPUREGISTER:
              begin
                cgpara.check_simple_location;
                a_loadfpu_reg_reg(list,size,size,r,cgpara.location^.register);
              end;
            LOC_REFERENCE,LOC_CREFERENCE:
              begin
                cgpara.check_simple_location;
                reference_reset_base(ref,cgpara.location^.reference.index,cgpara.location^.reference.offset);
                a_loadfpu_reg_ref(list,size,size,r,ref);
              end;
            LOC_REGISTER,LOC_CREGISTER:
              begin
                { paramfpu_ref does the check_simpe_location check here if necessary }
                tg.GetTemp(list,TCGSize2Size[size],tt_normal,ref);
                a_loadfpu_reg_ref(list,size,size,r,ref);
                a_paramfpu_ref(list,size,ref,cgpara);
                tg.Ungettemp(list,ref);
              end;
            else
              internalerror(2002071004);
         end;
      end;


    procedure tcg.a_paramfpu_ref(list : TAsmList;size : tcgsize;const ref : treference;const cgpara : TCGPara);
      var
         href : treference;
      begin
         cgpara.check_simple_location;
         case cgpara.location^.loc of
          LOC_FPUREGISTER,LOC_CFPUREGISTER:
            a_loadfpu_ref_reg(list,size,size,ref,cgpara.location^.register);
          LOC_REFERENCE,LOC_CREFERENCE:
            begin
              reference_reset_base(href,cgpara.location^.reference.index,cgpara.location^.reference.offset);
              { concatcopy should choose the best way to copy the data }
              g_concatcopy(list,ref,href,tcgsize2size[size]);
            end;
          else
            internalerror(200402201);
        end;
      end;


    procedure tcg.a_op_const_ref(list : TAsmList; Op: TOpCG; size: TCGSize; a: aint; const ref: TReference);
      var
        tmpreg : tregister;
      begin
        tmpreg:=getintregister(list,size);
        a_load_ref_reg(list,size,size,ref,tmpreg);
        a_op_const_reg(list,op,size,a,tmpreg);
        a_load_reg_ref(list,size,size,tmpreg,ref);
      end;


    procedure tcg.a_op_const_subsetreg(list : TAsmList; Op : TOpCG; size, subsetsize : TCGSize; a : aint; const sreg: tsubsetregister);
      var
        tmpreg: tregister;
      begin
        tmpreg := cg.getintregister(list, size);
        a_load_subsetreg_reg(list,subsetsize,size,sreg,tmpreg);
        a_op_const_reg(list,op,size,a,tmpreg);
        a_load_reg_subsetreg(list,size,subsetsize,tmpreg,sreg);
      end;


    procedure tcg.a_op_const_subsetref(list : TAsmList; Op : TOpCG; size, subsetsize : TCGSize; a : aint; const sref: tsubsetreference);
      var
        tmpreg: tregister;
      begin
        tmpreg := cg.getintregister(list, size);
        a_load_subsetref_reg(list,subsetsize,size,sref,tmpreg);
        a_op_const_reg(list,op,size,a,tmpreg);
        a_load_reg_subsetref(list,size,subsetsize,tmpreg,sref);
      end;


    procedure tcg.a_op_const_loc(list : TAsmList; Op: TOpCG; a: aint; const loc: tlocation);
      begin
        case loc.loc of
          LOC_REGISTER, LOC_CREGISTER:
            a_op_const_reg(list,op,loc.size,a,loc.register);
          LOC_REFERENCE, LOC_CREFERENCE:
            a_op_const_ref(list,op,loc.size,a,loc.reference);
          LOC_SUBSETREG, LOC_CSUBSETREG:
            a_op_const_subsetreg(list,op,loc.size,loc.size,a,loc.sreg);
          LOC_SUBSETREF, LOC_CSUBSETREF:
            a_op_const_subsetref(list,op,loc.size,loc.size,a,loc.sref);
          else
            internalerror(200109061);
        end;
      end;


    procedure tcg.a_op_reg_ref(list : TAsmList; Op: TOpCG; size: TCGSize;reg: TRegister;  const ref: TReference);
      var
        tmpreg : tregister;
      begin
        tmpreg:=getintregister(list,size);
        a_load_ref_reg(list,size,size,ref,tmpreg);
        a_op_reg_reg(list,op,size,reg,tmpreg);
        a_load_reg_ref(list,size,size,tmpreg,ref);
      end;


    procedure tcg.a_op_ref_reg(list : TAsmList; Op: TOpCG; size: TCGSize; const ref: TReference; reg: TRegister);

      var
        tmpreg: tregister;

      begin
        case op of
          OP_NOT,OP_NEG:
            { handle it as "load ref,reg; op reg" }
            begin
              a_load_ref_reg(list,size,size,ref,reg);
              a_op_reg_reg(list,op,size,reg,reg);
            end;
          else
            begin
              tmpreg:=getintregister(list,size);
              a_load_ref_reg(list,size,size,ref,tmpreg);
              a_op_reg_reg(list,op,size,tmpreg,reg);
            end;
        end;
      end;


    procedure tcg.a_op_reg_subsetreg(list : TAsmList; Op : TOpCG; opsize, subsetsize : TCGSize; reg: TRegister; const sreg: tsubsetregister);
      var
        tmpreg: tregister;
      begin
        tmpreg := cg.getintregister(list, opsize);
        a_load_subsetreg_reg(list,subsetsize,opsize,sreg,tmpreg);
        a_op_reg_reg(list,op,opsize,reg,tmpreg);
        a_load_reg_subsetreg(list,opsize,subsetsize,tmpreg,sreg);
      end;


    procedure tcg.a_op_reg_subsetref(list : TAsmList; Op : TOpCG; opsize, subsetsize : TCGSize; reg: TRegister; const sref: tsubsetreference);
      var
        tmpreg: tregister;
      begin
        tmpreg := cg.getintregister(list, opsize);
        a_load_subsetref_reg(list,subsetsize,opsize,sref,tmpreg);
        a_op_reg_reg(list,op,opsize,reg,tmpreg);
        a_load_reg_subsetref(list,opsize,subsetsize,tmpreg,sref);
      end;


    procedure tcg.a_op_reg_loc(list : TAsmList; Op: TOpCG; reg: tregister; const loc: tlocation);

      begin
        case loc.loc of
          LOC_REGISTER, LOC_CREGISTER:
            a_op_reg_reg(list,op,loc.size,reg,loc.register);
          LOC_REFERENCE, LOC_CREFERENCE:
            a_op_reg_ref(list,op,loc.size,reg,loc.reference);
          LOC_SUBSETREG, LOC_CSUBSETREG:
            a_op_reg_subsetreg(list,op,loc.size,loc.size,reg,loc.sreg);
          LOC_SUBSETREF, LOC_CSUBSETREF:
            a_op_reg_subsetref(list,op,loc.size,loc.size,reg,loc.sref);
          else
            internalerror(200109061);
        end;
      end;


    procedure tcg.a_op_ref_loc(list : TAsmList; Op: TOpCG; const ref: TReference; const loc: tlocation);

      var
        tmpreg: tregister;

      begin
        case loc.loc of
          LOC_REGISTER,LOC_CREGISTER:
            a_op_ref_reg(list,op,loc.size,ref,loc.register);
          LOC_REFERENCE,LOC_CREFERENCE:
            begin
              tmpreg:=getintregister(list,loc.size);
              a_load_ref_reg(list,loc.size,loc.size,ref,tmpreg);
              a_op_reg_ref(list,op,loc.size,tmpreg,loc.reference);
            end;
          LOC_SUBSETREG, LOC_CSUBSETREG:
            begin
              tmpreg:=getintregister(list,loc.size);
              a_load_subsetreg_reg(list,loc.size,loc.size,loc.sreg,tmpreg);
              a_op_ref_reg(list,op,loc.size,ref,tmpreg);
              a_load_reg_subsetreg(list,loc.size,loc.size,tmpreg,loc.sreg);
            end;
          LOC_SUBSETREF, LOC_CSUBSETREF:
            begin
              tmpreg:=getintregister(list,loc.size);
              a_load_subsetreF_reg(list,loc.size,loc.size,loc.sref,tmpreg);
              a_op_ref_reg(list,op,loc.size,ref,tmpreg);
              a_load_reg_subsetref(list,loc.size,loc.size,tmpreg,loc.sref);
            end;
          else
            internalerror(200109061);
        end;
      end;


    procedure Tcg.a_op_const_reg_reg(list:TAsmList;op:Topcg;size:Tcgsize;
                                     a:aint;src,dst:Tregister);

    begin
      a_load_reg_reg(list,size,size,src,dst);
      a_op_const_reg(list,op,size,a,dst);
    end;

    procedure tcg.a_op_reg_reg_reg(list: TAsmList; op: TOpCg;
        size: tcgsize; src1, src2, dst: tregister);
      var
        tmpreg: tregister;
      begin
        if (dst<>src1) then
          begin
            a_load_reg_reg(list,size,size,src2,dst);
            a_op_reg_reg(list,op,size,src1,dst);
          end
        else
          begin
            tmpreg:=getintregister(list,size);
            a_load_reg_reg(list,size,size,src2,tmpreg);
            a_op_reg_reg(list,op,size,src1,tmpreg);
            a_load_reg_reg(list,size,size,tmpreg,dst);
          end;
      end;


    procedure tcg.a_op_const_reg_reg_checkoverflow(list: TAsmList; op: TOpCg; size: tcgsize; a: aint; src, dst: tregister;setflags : boolean;var ovloc : tlocation);
      begin
        a_op_const_reg_reg(list,op,size,a,src,dst);
        ovloc.loc:=LOC_VOID;
      end;


    procedure tcg.a_op_reg_reg_reg_checkoverflow(list: TAsmList; op: TOpCg; size: tcgsize; src1, src2, dst: tregister;setflags : boolean;var ovloc : tlocation);
      begin
        a_op_reg_reg_reg(list,op,size,src1,src2,dst);
        ovloc.loc:=LOC_VOID;
      end;


    procedure tcg.a_cmp_const_ref_label(list : TAsmList;size : tcgsize;cmp_op : topcmp;a : aint;const ref : treference;
     l : tasmlabel);

      var
        tmpreg: tregister;

      begin
        tmpreg:=getintregister(list,size);
        a_load_ref_reg(list,size,size,ref,tmpreg);
        a_cmp_const_reg_label(list,size,cmp_op,a,tmpreg,l);
      end;


    procedure tcg.a_cmp_const_loc_label(list : TAsmList;size : tcgsize;cmp_op : topcmp;a : aint;const loc : tlocation;
      l : tasmlabel);

      var
        tmpreg : tregister;

      begin
        case loc.loc of
          LOC_REGISTER,LOC_CREGISTER:
            a_cmp_const_reg_label(list,size,cmp_op,a,loc.register,l);
          LOC_REFERENCE,LOC_CREFERENCE:
            a_cmp_const_ref_label(list,size,cmp_op,a,loc.reference,l);
          LOC_SUBSETREG, LOC_CSUBSETREG:
            begin
              tmpreg:=getintregister(list,size);
              a_load_subsetreg_reg(list,loc.size,size,loc.sreg,tmpreg);
              a_cmp_const_reg_label(list,size,cmp_op,a,tmpreg,l);
            end;
          LOC_SUBSETREF, LOC_CSUBSETREF:
            begin
              tmpreg:=getintregister(list,size);
              a_load_subsetref_reg(list,loc.size,size,loc.sref,tmpreg);
              a_cmp_const_reg_label(list,size,cmp_op,a,tmpreg,l);
            end;
          else
            internalerror(200109061);
        end;
      end;


    procedure tcg.a_cmp_ref_reg_label(list : TAsmList;size : tcgsize;cmp_op : topcmp; const ref: treference; reg : tregister; l : tasmlabel);
      var
        tmpreg: tregister;
      begin
        tmpreg:=getintregister(list,size);
        a_load_ref_reg(list,size,size,ref,tmpreg);
        a_cmp_reg_reg_label(list,size,cmp_op,tmpreg,reg,l);
      end;


    procedure tcg.a_cmp_reg_ref_label(list : TAsmList;size : tcgsize;cmp_op : topcmp; reg : tregister; const ref: treference; l : tasmlabel);
      var
        tmpreg: tregister;
      begin
        tmpreg:=getintregister(list,size);
        a_load_ref_reg(list,size,size,ref,tmpreg);
        a_cmp_reg_reg_label(list,size,cmp_op,reg,tmpreg,l);
      end;


    procedure tcg.a_cmp_reg_loc_label(list : TAsmList;size : tcgsize;cmp_op : topcmp; reg: tregister; const loc: tlocation; l : tasmlabel);
      begin
        a_cmp_loc_reg_label(list,size,swap_opcmp(cmp_op),loc,reg,l);
      end;


    procedure tcg.a_cmp_loc_reg_label(list : TAsmList;size : tcgsize;cmp_op : topcmp; const loc: tlocation; reg : tregister; l : tasmlabel);
      begin
        case loc.loc of
          LOC_REGISTER,
          LOC_CREGISTER:
            a_cmp_reg_reg_label(list,size,cmp_op,loc.register,reg,l);
          LOC_REFERENCE,
          LOC_CREFERENCE :
            a_cmp_ref_reg_label(list,size,cmp_op,loc.reference,reg,l);
          LOC_CONSTANT:
            a_cmp_const_reg_label(list,size,cmp_op,loc.value,reg,l);
          LOC_SUBSETREG,
          LOC_CSUBSETREG:
            a_cmp_subsetreg_reg_label(list,loc.size,size,cmp_op,loc.sreg,reg,l);
          LOC_SUBSETREF,
          LOC_CSUBSETREF:
            a_cmp_subsetref_reg_label(list,loc.size,size,cmp_op,loc.sref,reg,l);
          else
            internalerror(200203231);
        end;
      end;


    procedure tcg.a_cmp_subsetreg_reg_label(list : TAsmList; subsetsize : tcgsize; cmpsize : tcgsize; cmp_op : topcmp; const sreg: tsubsetregister; reg : tregister; l : tasmlabel);
      var
        tmpreg: tregister;
      begin
        tmpreg:=getintregister(list, cmpsize);
        a_load_subsetreg_reg(list,subsetsize,cmpsize,sreg,tmpreg);
        a_cmp_reg_reg_label(list,cmpsize,cmp_op,tmpreg,reg,l);
      end;


    procedure tcg.a_cmp_subsetref_reg_label(list : TAsmList; subsetsize : tcgsize; cmpsize : tcgsize; cmp_op : topcmp; const sref: tsubsetreference; reg : tregister; l : tasmlabel);
      var
        tmpreg: tregister;
      begin
        tmpreg:=getintregister(list, cmpsize);
        a_load_subsetref_reg(list,subsetsize,cmpsize,sref,tmpreg);
        a_cmp_reg_reg_label(list,cmpsize,cmp_op,tmpreg,reg,l);
      end;


    procedure tcg.a_cmp_ref_loc_label(list : TAsmList;size : tcgsize;cmp_op : topcmp;const ref: treference;const loc : tlocation;
      l : tasmlabel);
      var
        tmpreg: tregister;
      begin
        case loc.loc of
          LOC_REGISTER,LOC_CREGISTER:
            a_cmp_ref_reg_label(list,size,cmp_op,ref,loc.register,l);
          LOC_REFERENCE,LOC_CREFERENCE:
            begin
              tmpreg:=getintregister(list,size);
              a_load_ref_reg(list,size,size,loc.reference,tmpreg);
              a_cmp_ref_reg_label(list,size,cmp_op,ref,tmpreg,l);
            end;
          LOC_SUBSETREG, LOC_CSUBSETREG:
            begin
              tmpreg:=getintregister(list, size);
              a_load_ref_reg(list,size,size,loc.reference,tmpreg);
              a_cmp_subsetreg_reg_label(list,loc.size,size,swap_opcmp(cmp_op),loc.sreg,tmpreg,l);
            end;
          LOC_SUBSETREF, LOC_CSUBSETREF:
            begin
              tmpreg:=getintregister(list, size);
              a_load_ref_reg(list,size,size,loc.reference,tmpreg);
              a_cmp_subsetref_reg_label(list,loc.size,size,swap_opcmp(cmp_op),loc.sref,tmpreg,l);
            end;
          else
            internalerror(200109061);
        end;
      end;


    procedure tcg.a_loadmm_loc_reg(list: TAsmList; size: tcgsize; const loc: tlocation; const reg: tregister;shuffle : pmmshuffle);
      begin
        case loc.loc of
          LOC_MMREGISTER,LOC_CMMREGISTER:
            a_loadmm_reg_reg(list,loc.size,size,loc.register,reg,shuffle);
          LOC_REFERENCE,LOC_CREFERENCE:
            a_loadmm_ref_reg(list,loc.size,size,loc.reference,reg,shuffle);
          else
            internalerror(200310121);
        end;
      end;


    procedure tcg.a_loadmm_reg_loc(list: TAsmList; size: tcgsize; const reg: tregister; const loc: tlocation;shuffle : pmmshuffle);
      begin
        case loc.loc of
          LOC_MMREGISTER,LOC_CMMREGISTER:
            a_loadmm_reg_reg(list,size,loc.size,reg,loc.register,shuffle);
          LOC_REFERENCE,LOC_CREFERENCE:
            a_loadmm_reg_ref(list,size,loc.size,reg,loc.reference,shuffle);
          else
            internalerror(200310122);
        end;
      end;


    procedure tcg.a_parammm_reg(list: TAsmList; size: tcgsize; reg: tregister;const cgpara : TCGPara;shuffle : pmmshuffle);
      var
        href : treference;
      begin
         cgpara.check_simple_location;
         case cgpara.location^.loc of
          LOC_MMREGISTER,LOC_CMMREGISTER:
            a_loadmm_reg_reg(list,size,cgpara.location^.size,reg,cgpara.location^.register,shuffle);
          LOC_REFERENCE,LOC_CREFERENCE:
            begin
              reference_reset_base(href,cgpara.location^.reference.index,cgpara.location^.reference.offset);
              a_loadmm_reg_ref(list,size,cgpara.location^.size,reg,href,shuffle);
            end
          else
            internalerror(200310123);
        end;
      end;


    procedure tcg.a_parammm_ref(list: TAsmList; size: tcgsize;const ref: treference;const cgpara : TCGPara;shuffle : pmmshuffle);
      var
         hr : tregister;
         hs : tmmshuffle;
      begin
         cgpara.check_simple_location;
         hr:=getmmregister(list,cgpara.location^.size);
         a_loadmm_ref_reg(list,size,cgpara.location^.size,ref,hr,shuffle);
         if realshuffle(shuffle) then
           begin
             hs:=shuffle^;
             removeshuffles(hs);
             a_parammm_reg(list,cgpara.location^.size,hr,cgpara,@hs);
           end
         else
           a_parammm_reg(list,cgpara.location^.size,hr,cgpara,shuffle);
      end;


    procedure tcg.a_parammm_loc(list: TAsmList;const loc: tlocation; const cgpara : TCGPara;shuffle : pmmshuffle);
      begin
        case loc.loc of
          LOC_MMREGISTER,LOC_CMMREGISTER:
            a_parammm_reg(list,loc.size,loc.register,cgpara,shuffle);
          LOC_REFERENCE,LOC_CREFERENCE:
            a_parammm_ref(list,loc.size,loc.reference,cgpara,shuffle);
          else
            internalerror(200310123);
        end;
      end;


    procedure tcg.a_opmm_ref_reg(list: TAsmList; Op: TOpCG; size : tcgsize;const ref: treference; reg: tregister;shuffle : pmmshuffle);
      var
         hr : tregister;
         hs : tmmshuffle;
      begin
         hr:=getmmregister(list,size);
         a_loadmm_ref_reg(list,size,size,ref,hr,shuffle);
         if realshuffle(shuffle) then
           begin
             hs:=shuffle^;
             removeshuffles(hs);
             a_opmm_reg_reg(list,op,size,hr,reg,@hs);
           end
         else
           a_opmm_reg_reg(list,op,size,hr,reg,shuffle);
      end;


    procedure tcg.a_opmm_reg_ref(list: TAsmList; Op: TOpCG; size : tcgsize;reg: tregister; const ref: treference; shuffle : pmmshuffle);
      var
         hr : tregister;
         hs : tmmshuffle;
      begin
         hr:=getmmregister(list,size);
         a_loadmm_ref_reg(list,size,size,ref,hr,shuffle);
         if realshuffle(shuffle) then
           begin
             hs:=shuffle^;
             removeshuffles(hs);
             a_opmm_reg_reg(list,op,size,reg,hr,@hs);
             a_loadmm_reg_ref(list,size,size,hr,ref,@hs);
           end
         else
           begin
             a_opmm_reg_reg(list,op,size,reg,hr,shuffle);
             a_loadmm_reg_ref(list,size,size,hr,ref,shuffle);
           end;
      end;


    procedure tcg.a_opmm_loc_reg(list: TAsmList; Op: TOpCG; size : tcgsize;const loc: tlocation; reg: tregister;shuffle : pmmshuffle);
      begin
        case loc.loc of
          LOC_CMMREGISTER,LOC_MMREGISTER:
            a_opmm_reg_reg(list,op,size,loc.register,reg,shuffle);
          LOC_CREFERENCE,LOC_REFERENCE:
            a_opmm_ref_reg(list,op,size,loc.reference,reg,shuffle);
          else
            internalerror(200312232);
        end;
      end;


    procedure tcg.g_concatcopy_unaligned(list : TAsmList;const source,dest : treference;len : aint);
      begin
        g_concatcopy(list,source,dest,len);
      end;


    procedure tcg.g_copyshortstring(list : TAsmList;const source,dest : treference;len:byte);
      var
        cgpara1,cgpara2,cgpara3 : TCGPara;
      begin
        cgpara1.init;
        cgpara2.init;
        cgpara3.init;
        paramanager.getintparaloc(pocall_default,1,cgpara1);
        paramanager.getintparaloc(pocall_default,2,cgpara2);
        paramanager.getintparaloc(pocall_default,3,cgpara3);
        paramanager.allocparaloc(list,cgpara3);
        a_paramaddr_ref(list,dest,cgpara3);
        paramanager.allocparaloc(list,cgpara2);
        a_paramaddr_ref(list,source,cgpara2);
        paramanager.allocparaloc(list,cgpara1);
        a_param_const(list,OS_INT,len,cgpara1);
        paramanager.freeparaloc(list,cgpara3);
        paramanager.freeparaloc(list,cgpara2);
        paramanager.freeparaloc(list,cgpara1);
        allocallcpuregisters(list);
        a_call_name(list,'FPC_SHORTSTR_ASSIGN');
        deallocallcpuregisters(list);
        cgpara3.done;
        cgpara2.done;
        cgpara1.done;
      end;

    procedure tcg.g_copyvariant(list : TAsmList;const source,dest : treference);
      var
        cgpara1,cgpara2 : TCGPara;
      begin
        cgpara1.init;
        cgpara2.init;
        paramanager.getintparaloc(pocall_default,1,cgpara1);
        paramanager.getintparaloc(pocall_default,2,cgpara2);
        paramanager.allocparaloc(list,cgpara2);
        a_paramaddr_ref(list,dest,cgpara2);
        paramanager.allocparaloc(list,cgpara1);
        a_paramaddr_ref(list,source,cgpara1);
        paramanager.freeparaloc(list,cgpara2);
        paramanager.freeparaloc(list,cgpara1);
        allocallcpuregisters(list);
        a_call_name(list,'FPC_VARIANT_COPY_OVERWRITE');
        deallocallcpuregisters(list);
        cgpara2.done;
        cgpara1.done;
      end;


    procedure tcg.g_incrrefcount(list : TAsmList;t: tdef; const ref: treference);
      var
        href : treference;
        incrfunc : string;
        cgpara1,cgpara2 : TCGPara;
      begin
         cgpara1.init;
         cgpara2.init;
         paramanager.getintparaloc(pocall_default,1,cgpara1);
         paramanager.getintparaloc(pocall_default,2,cgpara2);
         if is_interfacecom(t) then
          incrfunc:='FPC_INTF_INCR_REF'
         else if is_ansistring(t) then
          incrfunc:='FPC_ANSISTR_INCR_REF'
         else if is_widestring(t) then
          incrfunc:='FPC_WIDESTR_INCR_REF'
         else if is_dynamic_array(t) then
          incrfunc:='FPC_DYNARRAY_INCR_REF'
         else
          incrfunc:='';
         { call the special incr function or the generic addref }
         if incrfunc<>'' then
          begin
            paramanager.allocparaloc(list,cgpara1);
            { widestrings aren't ref. counted on all platforms so we need the address
              to create a real copy }
            if is_widestring(t) then
              a_paramaddr_ref(list,ref,cgpara1)
            else
              { these functions get the pointer by value }
              a_param_ref(list,OS_ADDR,ref,cgpara1);
            paramanager.freeparaloc(list,cgpara1);
            allocallcpuregisters(list);
            a_call_name(list,incrfunc);
            deallocallcpuregisters(list);
          end
         else
          begin
            reference_reset_symbol(href,RTTIWriter.get_rtti_label(t,initrtti),0);
            paramanager.allocparaloc(list,cgpara2);
            a_paramaddr_ref(list,href,cgpara2);
            paramanager.allocparaloc(list,cgpara1);
            a_paramaddr_ref(list,ref,cgpara1);
            paramanager.freeparaloc(list,cgpara1);
            paramanager.freeparaloc(list,cgpara2);
            allocallcpuregisters(list);
            a_call_name(list,'FPC_ADDREF');
            deallocallcpuregisters(list);
          end;
         cgpara2.done;
         cgpara1.done;
      end;


    procedure tcg.g_decrrefcount(list : TAsmList;t: tdef; const ref: treference);
      var
        href : treference;
        decrfunc : string;
        needrtti : boolean;
        cgpara1,cgpara2 : TCGPara;
        tempreg1,tempreg2 : TRegister;
      begin
        cgpara1.init;
        cgpara2.init;
        paramanager.getintparaloc(pocall_default,1,cgpara1);
        paramanager.getintparaloc(pocall_default,2,cgpara2);
        needrtti:=false;
        if is_interfacecom(t) then
          decrfunc:='FPC_INTF_DECR_REF'
        else if is_ansistring(t) then
          decrfunc:='FPC_ANSISTR_DECR_REF'
         else if is_widestring(t) then
          decrfunc:='FPC_WIDESTR_DECR_REF'
         else if is_dynamic_array(t) then
          begin
            decrfunc:='FPC_DYNARRAY_DECR_REF';
            needrtti:=true;
          end
         else
          decrfunc:='';
         { call the special decr function or the generic decref }
         if decrfunc<>'' then
          begin
            if needrtti then
             begin
               reference_reset_symbol(href,RTTIWriter.get_rtti_label(t,initrtti),0);
               tempreg2:=getaddressregister(list);
               a_loadaddr_ref_reg(list,href,tempreg2);
             end;
            tempreg1:=getaddressregister(list);
            a_loadaddr_ref_reg(list,ref,tempreg1);
            if needrtti then
              begin
                paramanager.allocparaloc(list,cgpara2);
                a_param_reg(list,OS_ADDR,tempreg2,cgpara2);
                paramanager.freeparaloc(list,cgpara2);
              end;
            paramanager.allocparaloc(list,cgpara1);
            a_param_reg(list,OS_ADDR,tempreg1,cgpara1);
            paramanager.freeparaloc(list,cgpara1);
            allocallcpuregisters(list);
            a_call_name(list,decrfunc);
            deallocallcpuregisters(list);
          end
         else
          begin
            reference_reset_symbol(href,RTTIWriter.get_rtti_label(t,initrtti),0);
            paramanager.allocparaloc(list,cgpara2);
            a_paramaddr_ref(list,href,cgpara2);
            paramanager.allocparaloc(list,cgpara1);
            a_paramaddr_ref(list,ref,cgpara1);
            paramanager.freeparaloc(list,cgpara1);
            paramanager.freeparaloc(list,cgpara2);
            allocallcpuregisters(list);
            a_call_name(list,'FPC_DECREF');
            deallocallcpuregisters(list);
         end;
        cgpara2.done;
        cgpara1.done;
      end;


    procedure tcg.g_initialize(list : TAsmList;t : tdef;const ref : treference);
      var
         href : treference;
         cgpara1,cgpara2 : TCGPara;
      begin
        cgpara1.init;
        cgpara2.init;
        paramanager.getintparaloc(pocall_default,1,cgpara1);
        paramanager.getintparaloc(pocall_default,2,cgpara2);
         if is_ansistring(t) or
            is_widestring(t) or
            is_interfacecom(t) or
            is_dynamic_array(t) then
           a_load_const_ref(list,OS_ADDR,0,ref)
         else
           begin
              reference_reset_symbol(href,RTTIWriter.get_rtti_label(t,initrtti),0);
              paramanager.allocparaloc(list,cgpara2);
              a_paramaddr_ref(list,href,cgpara2);
              paramanager.allocparaloc(list,cgpara1);
              a_paramaddr_ref(list,ref,cgpara1);
              paramanager.freeparaloc(list,cgpara1);
              paramanager.freeparaloc(list,cgpara2);
              allocallcpuregisters(list);
              a_call_name(list,'FPC_INITIALIZE');
              deallocallcpuregisters(list);
           end;
        cgpara1.done;
        cgpara2.done;
      end;


    procedure tcg.g_finalize(list : TAsmList;t : tdef;const ref : treference);
      var
         href : treference;
         cgpara1,cgpara2 : TCGPara;
      begin
        cgpara1.init;
        cgpara2.init;
        paramanager.getintparaloc(pocall_default,1,cgpara1);
        paramanager.getintparaloc(pocall_default,2,cgpara2);
         if is_ansistring(t) or
            is_widestring(t) or
            is_interfacecom(t) then
            begin
              g_decrrefcount(list,t,ref);
              a_load_const_ref(list,OS_ADDR,0,ref);
            end
         else
           begin
              reference_reset_symbol(href,RTTIWriter.get_rtti_label(t,initrtti),0);
              paramanager.allocparaloc(list,cgpara2);
              a_paramaddr_ref(list,href,cgpara2);
              paramanager.allocparaloc(list,cgpara1);
              a_paramaddr_ref(list,ref,cgpara1);
              paramanager.freeparaloc(list,cgpara1);
              paramanager.freeparaloc(list,cgpara2);
              allocallcpuregisters(list);
              a_call_name(list,'FPC_FINALIZE');
              deallocallcpuregisters(list);
           end;
        cgpara1.done;
        cgpara2.done;
      end;


    procedure tcg.g_rangecheck(list: TAsmList; const l:tlocation;fromdef,todef: tdef);
    { generate range checking code for the value at location p. The type     }
    { type used is checked against todefs ranges. fromdef (p.resultdef) }
    { is the original type used at that location. When both defs are equal   }
    { the check is also insert (needed for succ,pref,inc,dec)                }
      const
        aintmax=high(aint);
      var
        neglabel : tasmlabel;
        hreg : tregister;
        lto,hto,
        lfrom,hfrom : TConstExprInt;
        fromsize, tosize: cardinal;
        from_signed, to_signed: boolean;
      begin
        { range checking on and range checkable value? }
        if not(cs_check_range in current_settings.localswitches) or
           not(fromdef.typ in [orddef,enumdef]) then
          exit;
{$ifndef cpu64bit}
        { handle 64bit rangechecks separate for 32bit processors }
        if is_64bit(fromdef) or is_64bit(todef) then
          begin
             cg64.g_rangecheck64(list,l,fromdef,todef);
             exit;
          end;
{$endif cpu64bit}
        { only check when assigning to scalar, subranges are different, }
        { when todef=fromdef then the check is always generated         }
        getrange(fromdef,lfrom,hfrom);
        getrange(todef,lto,hto);
        from_signed := is_signed(fromdef);
        to_signed := is_signed(todef);
        { check the rangedef of the array, not the array itself }
        { (only change now, since getrange needs the arraydef)   }
        if (todef.typ = arraydef) then
          todef := tarraydef(todef).rangedef;
        { no range check if from and to are equal and are both longint/dword }
        { no range check if from and to are equal and are both longint/dword }
        { (if we have a 32bit processor) or int64/qword, since such          }
        { operations can at most cause overflows (JM)                        }
        { Note that these checks are mostly processor independent, they only }
        { have to be changed once we introduce 64bit subrange types          }
{$ifdef cpu64bit}
        if (fromdef = todef) and
           (fromdef.typ=orddef) and
           (((((torddef(fromdef).ordtype = s64bit) and
               (lfrom = low(int64)) and
               (hfrom = high(int64))) or
              ((torddef(fromdef).ordtype = u64bit) and
               (lfrom = low(qword)) and
               (hfrom = high(qword))) or
              ((torddef(fromdef).ordtype = scurrency) and
               (lfrom = low(int64)) and
               (hfrom = high(int64)))))) then
          exit;
{$else cpu64bit}
        if (fromdef = todef) and
           (fromdef.typ=orddef) and
           (((((torddef(fromdef).ordtype = s32bit) and
               (lfrom = low(longint)) and
               (hfrom = high(longint))) or
              ((torddef(fromdef).ordtype = u32bit) and
               (lfrom = low(cardinal)) and
               (hfrom = high(cardinal)))))) then
          exit;
{$endif cpu64bit}

        { optimize some range checks away in safe cases }
        fromsize := fromdef.size;
        tosize := todef.size;
        if ((from_signed = to_signed) or
            (not from_signed)) and
           (lto<=lfrom) and (hto>=hfrom) and
           (fromsize <= tosize) then
          begin
            { if fromsize < tosize, and both have the same signed-ness or }
            { fromdef is unsigned, then all bit patterns from fromdef are }
            { valid for todef as well                                     }
            if (fromsize < tosize) then
              exit;
            if (fromsize = tosize) and
               (from_signed = to_signed) then
              { only optimize away if all bit patterns which fit in fromsize }
              { are valid for the todef                                      }
              begin
{$ifopt Q+}
{$define overflowon}
{$Q-}
{$endif}
                if to_signed then
                  begin
                    { calculation of the low/high ranges must not overflow 64 bit
                     otherwise we end up comparing with zero for 64 bit data types on
                     64 bit processors }
                    if (lto = (int64(-1) << (tosize * 8 - 1))) and
                       (hto = (-((int64(-1) << (tosize * 8 - 1))+1))) then
                      exit
                  end
                else
                  begin
                    { calculation of the low/high ranges must not overflow 64 bit
                     otherwise we end up having all zeros for 64 bit data types on
                     64 bit processors }
                    if (lto = 0) and
                       (qword(hto) = (qword(-1) >> (64-(tosize * 8))) ) then
                      exit
                  end;
{$ifdef overflowon}
{$Q+}
{$undef overflowon}
{$endif}
              end
          end;

        { generate the rangecheck code for the def where we are going to }
        { store the result                                               }

        { use the trick that                                                 }
        { a <= x <= b <=> 0 <= x-a <= b-a <=> unsigned(x-a) <= unsigned(b-a) }

        { To be able to do that, we have to make sure however that either    }
        { fromdef and todef are both signed or unsigned, or that we leave    }
        { the parts < 0 and > maxlongint out                                 }

        if from_signed xor to_signed then
          begin
             if from_signed then
               { from is signed, to is unsigned }
               begin
                 { if high(from) < 0 -> always range error }
                 if (hfrom < 0) or
                    { if low(to) > maxlongint also range error }
                    (lto > aintmax) then
                   begin
                     a_call_name(list,'FPC_RANGEERROR');
                     exit
                   end;
                 { from is signed and to is unsigned -> when looking at to }
                 { as an signed value, it must be < maxaint (otherwise     }
                 { it will become negative, which is invalid since "to" is unsigned) }
                 if hto > aintmax then
                   hto := aintmax;
               end
             else
               { from is unsigned, to is signed }
               begin
                 if (lfrom > aintmax) or
                    (hto < 0) then
                   begin
                     a_call_name(list,'FPC_RANGEERROR');
                     exit
                   end;
                 { from is unsigned and to is signed -> when looking at to }
                 { as an unsigned value, it must be >= 0 (since negative   }
                 { values are the same as values > maxlongint)             }
                 if lto < 0 then
                   lto := 0;
               end;
          end;
        hreg:=getintregister(list,OS_INT);
        a_load_loc_reg(list,OS_INT,l,hreg);
        a_op_const_reg(list,OP_SUB,OS_INT,aint(lto),hreg);
        current_asmdata.getjumplabel(neglabel);
        {
        if from_signed then
          a_cmp_const_reg_label(list,OS_INT,OC_GTE,aint(hto-lto),hreg,neglabel)
        else
        }
{$ifdef cpu64bit}
        if qword(hto-lto)>qword(aintmax) then
          a_cmp_const_reg_label(list,OS_INT,OC_BE,aintmax,hreg,neglabel)
        else
{$endif cpu64bit}
          a_cmp_const_reg_label(list,OS_INT,OC_BE,aint(hto-lto),hreg,neglabel);
        a_call_name(list,'FPC_RANGEERROR');
        a_label(list,neglabel);
      end;


    procedure tcg.g_overflowCheck_loc(List:TAsmList;const Loc:TLocation;def:TDef;ovloc : tlocation);
      begin
        g_overflowCheck(list,loc,def);
      end;


    procedure tcg.g_flags2ref(list: TAsmList; size: TCgSize; const f: tresflags; const ref:TReference);

      var
        tmpreg : tregister;
      begin
        tmpreg:=getintregister(list,size);
        g_flags2reg(list,size,f,tmpreg);
        a_load_reg_ref(list,size,size,tmpreg,ref);
      end;


    procedure tcg.g_maybe_testself(list : TAsmList;reg:tregister);
      var
        OKLabel : tasmlabel;
        cgpara1 : TCGPara;
      begin
        if (cs_check_object in current_settings.localswitches) or
           (cs_check_range in current_settings.localswitches) then
         begin
           current_asmdata.getjumplabel(oklabel);
           a_cmp_const_reg_label(list,OS_ADDR,OC_NE,0,reg,oklabel);
           cgpara1.init;
           paramanager.getintparaloc(pocall_default,1,cgpara1);
           paramanager.allocparaloc(list,cgpara1);
           a_param_const(list,OS_INT,210,cgpara1);
           paramanager.freeparaloc(list,cgpara1);
           a_call_name(list,'FPC_HANDLEERROR');
           a_label(list,oklabel);
           cgpara1.done;
         end;
      end;


    procedure tcg.g_maybe_testvmt(list : TAsmList;reg:tregister;objdef:tobjectdef);
      var
        hrefvmt : treference;
        cgpara1,cgpara2 : TCGPara;
      begin
        cgpara1.init;
        cgpara2.init;
        paramanager.getintparaloc(pocall_default,1,cgpara1);
        paramanager.getintparaloc(pocall_default,2,cgpara2);
        if (cs_check_object in current_settings.localswitches) then
         begin
           reference_reset_symbol(hrefvmt,current_asmdata.RefAsmSymbol(objdef.vmt_mangledname),0);
           paramanager.allocparaloc(list,cgpara2);
           a_paramaddr_ref(list,hrefvmt,cgpara2);
           paramanager.allocparaloc(list,cgpara1);
           a_param_reg(list,OS_ADDR,reg,cgpara1);
           paramanager.freeparaloc(list,cgpara1);
           paramanager.freeparaloc(list,cgpara2);
           allocallcpuregisters(list);
           a_call_name(list,'FPC_CHECK_OBJECT_EXT');
           deallocallcpuregisters(list);
         end
        else
         if (cs_check_range in current_settings.localswitches) then
          begin
            paramanager.allocparaloc(list,cgpara1);
            a_param_reg(list,OS_ADDR,reg,cgpara1);
            paramanager.freeparaloc(list,cgpara1);
            allocallcpuregisters(list);
            a_call_name(list,'FPC_CHECK_OBJECT');
            deallocallcpuregisters(list);
          end;
        cgpara1.done;
        cgpara2.done;
      end;


{*****************************************************************************
                            Entry/Exit Code Functions
*****************************************************************************}

    procedure tcg.g_copyvaluepara_openarray(list : TAsmList;const ref:treference;const lenloc:tlocation;elesize:aint;destreg:tregister);
      var
        sizereg,sourcereg,lenreg : tregister;
        cgpara1,cgpara2,cgpara3 : TCGPara;
      begin
        { because some abis don't support dynamic stack allocation properly
          open array value parameters are copied onto the heap
        }

        { calculate necessary memory }

        { read/write operations on one register make the life of the register allocator hard }
        if not(lenloc.loc in [LOC_REGISTER,LOC_CREGISTER]) then
          begin
            lenreg:=getintregister(list,OS_INT);
            a_load_loc_reg(list,OS_INT,lenloc,lenreg);
          end
        else
          lenreg:=lenloc.register;

        sizereg:=getintregister(list,OS_INT);
        a_op_const_reg_reg(list,OP_ADD,OS_INT,1,lenreg,sizereg);
        a_op_const_reg(list,OP_IMUL,OS_INT,elesize,sizereg);
        { load source }
        sourcereg:=getaddressregister(list);
        a_loadaddr_ref_reg(list,ref,sourcereg);

        { do getmem call }
        cgpara1.init;
        paramanager.getintparaloc(pocall_default,1,cgpara1);
        paramanager.allocparaloc(list,cgpara1);
        a_param_reg(list,OS_INT,sizereg,cgpara1);
        paramanager.freeparaloc(list,cgpara1);
        allocallcpuregisters(list);
        a_call_name(list,'FPC_GETMEM');
        deallocallcpuregisters(list);
        cgpara1.done;
        { return the new address }
        a_load_reg_reg(list,OS_ADDR,OS_ADDR,NR_FUNCTION_RESULT_REG,destreg);

        { do move call }
        cgpara1.init;
        cgpara2.init;
        cgpara3.init;
        paramanager.getintparaloc(pocall_default,1,cgpara1);
        paramanager.getintparaloc(pocall_default,2,cgpara2);
        paramanager.getintparaloc(pocall_default,3,cgpara3);
        { load size }
        paramanager.allocparaloc(list,cgpara3);
        a_param_reg(list,OS_INT,sizereg,cgpara3);
        { load destination }
        paramanager.allocparaloc(list,cgpara2);
        a_param_reg(list,OS_ADDR,destreg,cgpara2);
        { load source }
        paramanager.allocparaloc(list,cgpara1);
        a_param_reg(list,OS_ADDR,sourcereg,cgpara1);
        paramanager.freeparaloc(list,cgpara3);
        paramanager.freeparaloc(list,cgpara2);
        paramanager.freeparaloc(list,cgpara1);
        allocallcpuregisters(list);
        a_call_name(list,'FPC_MOVE');
        deallocallcpuregisters(list);
        cgpara3.done;
        cgpara2.done;
        cgpara1.done;
      end;


    procedure tcg.g_releasevaluepara_openarray(list : TAsmList;const l:tlocation);
      var
        cgpara1 : TCGPara;
      begin
        { do move call }
        cgpara1.init;
        paramanager.getintparaloc(pocall_default,1,cgpara1);
        { load source }
        paramanager.allocparaloc(list,cgpara1);
        a_param_loc(list,l,cgpara1);
        paramanager.freeparaloc(list,cgpara1);
        allocallcpuregisters(list);
        a_call_name(list,'FPC_FREEMEM');
        deallocallcpuregisters(list);
        cgpara1.done;
      end;


    procedure tcg.g_save_standard_registers(list:TAsmList);
      var
        href : treference;
        size : longint;
        r : integer;
      begin
        { Get temp }
        size:=0;
        for r:=low(saved_standard_registers) to high(saved_standard_registers) do
          if saved_standard_registers[r] in rg[R_INTREGISTER].used_in_proc then
            inc(size,sizeof(aint));
        if size>0 then
          begin
            tg.GetTemp(list,size,tt_noreuse,current_procinfo.save_regs_ref);
            { Copy registers to temp }
            href:=current_procinfo.save_regs_ref;

            for r:=low(saved_standard_registers) to high(saved_standard_registers) do
              begin
                if saved_standard_registers[r] in rg[R_INTREGISTER].used_in_proc then
                  begin
                    a_load_reg_ref(list,OS_ADDR,OS_ADDR,newreg(R_INTREGISTER,saved_standard_registers[r],R_SUBWHOLE),href);
                    inc(href.offset,sizeof(aint));
                  end;
                include(rg[R_INTREGISTER].preserved_by_proc,saved_standard_registers[r]);
              end;
          end;
      end;


    procedure tcg.g_restore_standard_registers(list:TAsmList);
      var
        href : treference;
        r : integer;
        hreg : tregister;
      begin
        { Copy registers from temp }
        href:=current_procinfo.save_regs_ref;
        for r:=low(saved_standard_registers) to high(saved_standard_registers) do
          if saved_standard_registers[r] in rg[R_INTREGISTER].used_in_proc then
            begin
              hreg:=newreg(R_INTREGISTER,saved_standard_registers[r],R_SUBWHOLE);
              { Allocate register so the optimizer does not remove the load }
              a_reg_alloc(list,hreg);
              a_load_ref_reg(list,OS_ADDR,OS_ADDR,href,hreg);
              inc(href.offset,sizeof(aint));
            end;
        tg.UnGetTemp(list,current_procinfo.save_regs_ref);
      end;


    procedure tcg.g_profilecode(list : TAsmList);
      begin
      end;


    procedure tcg.g_exception_reason_save(list : TAsmList; const href : treference);
      begin
        a_load_reg_ref(list, OS_INT, OS_INT, NR_FUNCTION_RESULT_REG, href);
      end;


    procedure tcg.g_exception_reason_save_const(list : TAsmList; const href : treference; a: aint);
      begin
        a_load_const_ref(list, OS_INT, a, href);
      end;


    procedure tcg.g_exception_reason_load(list : TAsmList; const href : treference);
      begin
        a_load_ref_reg(list, OS_INT, OS_INT, href, NR_FUNCTION_RESULT_REG);
      end;


    procedure tcg.g_adjust_self_value(list:TAsmList;procdef: tprocdef;ioffset: aint);
      var
        hsym : tsym;
        href : treference;
        paraloc : tcgparalocation;
      begin
        { calculate the parameter info for the procdef }
        if not procdef.has_paraloc_info then
          begin
            procdef.requiredargarea:=paramanager.create_paraloc_info(procdef,callerside);
            procdef.has_paraloc_info:=true;
          end;
        hsym:=tsym(procdef.parast.Find('self'));
        if not(assigned(hsym) and
               (hsym.typ=paravarsym)) then
          internalerror(200305251);
        paraloc:=tparavarsym(hsym).paraloc[callerside].location^;
        case paraloc.loc of
          LOC_REGISTER:
            cg.a_op_const_reg(list,OP_SUB,paraloc.size,ioffset,paraloc.register);
          LOC_REFERENCE:
            begin
               { offset in the wrapper needs to be adjusted for the stored
                 return address }
               reference_reset_base(href,paraloc.reference.index,paraloc.reference.offset+sizeof(aint));
               cg.a_op_const_ref(list,OP_SUB,paraloc.size,ioffset,href);
            end
          else
            internalerror(200309189);
        end;
      end;


    procedure tcg.a_call_name_static(list : TAsmList;const s : string);
      begin
        a_call_name(list,s);
      end;


   function tcg.g_indirect_sym_load(list:TAsmList;const symname: string): tregister;
      var
        l: tasmsymbol;
        ref: treference;
      begin
        result := NR_NO;
        case target_info.system of
          system_powerpc_darwin,
          system_i386_darwin,
          system_powerpc64_darwin,
          system_x86_64_darwin:
            begin
              l:=current_asmdata.getasmsymbol('L'+symname+'$non_lazy_ptr');
              if not(assigned(l)) then
                begin
                  l:=current_asmdata.DefineAsmSymbol('L'+symname+'$non_lazy_ptr',AB_COMMON,AT_DATA);
                  current_asmdata.asmlists[al_picdata].concat(tai_symbol.create(l,0));
                  current_asmdata.asmlists[al_picdata].concat(tai_const.create_indirect_sym(current_asmdata.RefAsmSymbol(symname)));
{$ifdef cpu64bit}
                  current_asmdata.asmlists[al_picdata].concat(tai_const.create_64bit(0));
{$else cpu64bit}
                  current_asmdata.asmlists[al_picdata].concat(tai_const.create_32bit(0));
{$endif cpu64bit}
                end;
              result := cg.getaddressregister(list);
              reference_reset_symbol(ref,l,0);
{              ref.base:=current_procinfo.got;
              ref.relsymbol:=current_procinfo.CurrGOTLabel;}
              cg.a_load_ref_reg(list,OS_ADDR,OS_ADDR,ref,result);
            end;
          end;
        end;


{*****************************************************************************
                                    TCG64
*****************************************************************************}

{$ifndef cpu64bit}
    procedure tcg64.a_op64_const_reg_reg(list: TAsmList;op:TOpCG;size : tcgsize;value : int64; regsrc,regdst : tregister64);
      begin
        a_load64_reg_reg(list,regsrc,regdst);
        a_op64_const_reg(list,op,size,value,regdst);
      end;


    procedure tcg64.a_op64_reg_reg_reg(list: TAsmList;op:TOpCG;size : tcgsize;regsrc1,regsrc2,regdst : tregister64);
      var
        tmpreg64 : tregister64;
      begin
        { when src1=dst then we need to first create a temp to prevent
          overwriting src1 with src2 }
        if (regsrc1.reghi=regdst.reghi) or
           (regsrc1.reglo=regdst.reghi) or
           (regsrc1.reghi=regdst.reglo) or
           (regsrc1.reglo=regdst.reglo) then
          begin
            tmpreg64.reglo:=cg.getintregister(list,OS_32);
            tmpreg64.reghi:=cg.getintregister(list,OS_32);
            a_load64_reg_reg(list,regsrc2,tmpreg64);
            a_op64_reg_reg(list,op,size,regsrc1,tmpreg64);
            a_load64_reg_reg(list,tmpreg64,regdst);
          end
        else
          begin
            a_load64_reg_reg(list,regsrc2,regdst);
            a_op64_reg_reg(list,op,size,regsrc1,regdst);
          end;
      end;


    procedure tcg64.a_op64_const_subsetref(list : TAsmList; Op : TOpCG; size : TCGSize; a : int64; const sref: tsubsetreference);
      var
        tmpreg64 : tregister64;
      begin
        tmpreg64.reglo:=cg.getintregister(list,OS_32);
        tmpreg64.reghi:=cg.getintregister(list,OS_32);
        a_load64_subsetref_reg(list,sref,tmpreg64);
        a_op64_const_reg(list,op,size,a,tmpreg64);
        a_load64_reg_subsetref(list,tmpreg64,sref);
      end;


    procedure tcg64.a_op64_reg_subsetref(list : TAsmList; Op : TOpCG; size : TCGSize; reg: tregister64; const sref: tsubsetreference);
      var
        tmpreg64 : tregister64;
      begin
        tmpreg64.reglo:=cg.getintregister(list,OS_32);
        tmpreg64.reghi:=cg.getintregister(list,OS_32);
        a_load64_subsetref_reg(list,sref,tmpreg64);
        a_op64_reg_reg(list,op,size,reg,tmpreg64);
        a_load64_reg_subsetref(list,tmpreg64,sref);
      end;


    procedure tcg64.a_op64_ref_subsetref(list : TAsmList; Op : TOpCG; size : TCGSize; const ref: treference; const sref: tsubsetreference);
      var
        tmpreg64 : tregister64;
      begin
        tmpreg64.reglo:=cg.getintregister(list,OS_32);
        tmpreg64.reghi:=cg.getintregister(list,OS_32);
        a_load64_subsetref_reg(list,sref,tmpreg64);
        a_op64_ref_reg(list,op,size,ref,tmpreg64);
        a_load64_reg_subsetref(list,tmpreg64,sref);
      end;


    procedure tcg64.a_op64_subsetref_subsetref(list : TAsmList; Op : TOpCG; size : TCGSize; const ssref,dsref: tsubsetreference);
      var
        tmpreg64 : tregister64;
      begin
        tmpreg64.reglo:=cg.getintregister(list,OS_32);
        tmpreg64.reghi:=cg.getintregister(list,OS_32);
        a_load64_subsetref_reg(list,ssref,tmpreg64);
        a_op64_reg_subsetref(list,op,size,tmpreg64,dsref);
      end;


    procedure tcg64.a_op64_const_reg_reg_checkoverflow(list: TAsmList;op:TOpCG;size : tcgsize;value : int64;regsrc,regdst : tregister64;setflags : boolean;var ovloc : tlocation);
      begin
        a_op64_const_reg_reg(list,op,size,value,regsrc,regdst);
        ovloc.loc:=LOC_VOID;
      end;


    procedure tcg64.a_op64_reg_reg_reg_checkoverflow(list: TAsmList;op:TOpCG;size : tcgsize;regsrc1,regsrc2,regdst : tregister64;setflags : boolean;var ovloc : tlocation);
      begin
        a_op64_reg_reg_reg(list,op,size,regsrc1,regsrc2,regdst);
        ovloc.loc:=LOC_VOID;
      end;


    procedure tcg64.a_load64_loc_subsetref(list : TAsmList;const l: tlocation; const sref : tsubsetreference);
      begin
        case l.loc of
          LOC_REFERENCE, LOC_CREFERENCE:
            a_load64_ref_subsetref(list,l.reference,sref);
          LOC_REGISTER,LOC_CREGISTER:
            a_load64_reg_subsetref(list,l.register64,sref);
          LOC_CONSTANT :
            a_load64_const_subsetref(list,l.value64,sref);
          LOC_SUBSETREF,LOC_CSUBSETREF:
            a_load64_subsetref_subsetref(list,l.sref,sref);
          else
            internalerror(2006082210);
        end;
      end;


    procedure tcg64.a_load64_subsetref_loc(list: TAsmlist; const sref: tsubsetreference; const l: tlocation);
      begin
        case l.loc of
          LOC_REFERENCE, LOC_CREFERENCE:
            a_load64_subsetref_ref(list,sref,l.reference);
          LOC_REGISTER,LOC_CREGISTER:
            a_load64_subsetref_reg(list,sref,l.register64);
          LOC_SUBSETREF,LOC_CSUBSETREF:
            a_load64_subsetref_subsetref(list,sref,l.sref);
          else
            internalerror(2006082211);
        end;
      end;

{$endif cpu64bit}



initialization
    ;
finalization
  cg.free;
{$ifndef cpu64bit}
  cg64.free;
{$endif cpu64bit}
end.
