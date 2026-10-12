module

public import MLIR.Run.Tactic
public import Zig.Common.Globals
public import Zig.Mlir.Edwards25519_basePointPc

meta import MLIR.Semantics.Func

/-! `step_addressof` of the large partly defined globals: `Sha512.iv` (1792 bits, `buf` undefined),
by its `value_eq` and by the global itself, and `Edwards25519.basePointPc` (21504 bits), by the
global itself; each in seconds, the image's literals evaluated by the kernel. -/

namespace MLIR.Zig.Tests.Globals

@[expose] public section

/-- `Sha512.iv`'s `buf_len`, byte `208`. -/
mlir_def ivLen := {
  %0 = "llvm.mlir.addressof"() <{global_name = @Sha512.iv}> : () -> !llvm.ptr
  %1 = "llvm.getelementptr"(%0) <{elem_type = i8, rawConstantIndices = array<i32: 208>}> : (!llvm.ptr) -> !llvm.ptr
  %2 = "llvm.load"(%1) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  "llvm.return"(%2) : (i8) -> ()
} with @Sha512.iv := Sha512_iv

/-- `is_base` of `basePointPc`'s entry `0`, at byte `160`. -/
noncomputable mlir_def tableBase := {
  %0 = "llvm.mlir.addressof"() <{global_name = @Edwards25519.basePointPc}> : () -> !llvm.ptr
  %1 = "llvm.getelementptr"(%0) <{elem_type = i8, rawConstantIndices = array<i32: 160>}> : (!llvm.ptr) -> !llvm.ptr
  %2 = "llvm.load"(%1) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i1
  "llvm.return"(%2) : (i1) -> ()
} with @Edwards25519.basePointPc := Edwards25519_basePointPc

end

example (s : GlobalState) (hwf : s.WF) :
    ivLen.call ivLen.args s =
      .value (.cons (.value 0#8) .nil, { s with alloc := ⟨s.alloc.nextFreeBlock + 1⟩ }) := by
  func_init
  block_init
  step_addressof Sha512_iv.value_eq with iv
  guard_hyp hiv_fits : Fits S.mem iv 640
  step_pure
  step_load with v
  finish_block
  subst hS hv
  erase_frame
  rfl

example (s : GlobalState) (hwf : s.WF) :
    ivLen.call ivLen.args s =
      .value (.cons (.value 0#8) .nil, { s with alloc := ⟨s.alloc.nextFreeBlock + 1⟩ }) := by
  func_init
  block_init
  step_addressof Sha512_iv with iv
  step_pure
  step_load with v
  finish_block
  subst hS hv
  erase_frame
  rfl

example (s : GlobalState) (hwf : s.WF) :
    tableBase.call tableBase.args s =
      .value (.cons (.value 0#1) .nil, { s with alloc := ⟨s.alloc.nextFreeBlock + 1⟩ }) := by
  func_init
  block_init
  step_addressof Edwards25519_basePointPc with t
  step_pure
  step_load with v
  finish_block
  subst hS hv
  erase_frame
  rfl

end MLIR.Zig.Tests.Globals
