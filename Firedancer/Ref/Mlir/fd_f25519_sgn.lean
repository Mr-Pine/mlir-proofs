module

-- build/llvm23/mlir_canonicalized/ref/op/fd_f25519_sgn.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Firedancer.Ref.Mlir.fd_f25519_tobytes

meta import MLIR.Semantics.Func
meta import Firedancer.Ref.Mlir.fd_f25519_tobytes

namespace MLIR.Firedancer.Ref

@[expose] public section

mlir_def fd_f25519_sgn :=
#tbaa_root = #llvm.tbaa_root<id = "Simple C/C++ TBAA">
#tbaa_type_desc = #llvm.tbaa_type_desc<id = "omnipotent char", members = {<#tbaa_root, 0>}>
#tbaa_tag = #llvm.tbaa_tag<base_type = #tbaa_type_desc, access_type = #tbaa_type_desc, offset = 0>
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<i32 (ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"]], res_attrs = [{llvm.range = #llvm.constant_range<i32, 0, 2>}], sym_name = "fd_f25519_sgn", target_cpu = "x86-64", target_features = #llvm.target_features<["+cmov", "+cx8", "+fxsr", "+mmx", "+sse", "+sse2", "+x87"]>, tune_cpu = "generic", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg82: !llvm.ptr):
  %1763 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %1764 = "llvm.mlir.constant"() <{value = 1 : i8}> : () -> i8
  %1765 = "llvm.alloca"(%1763) <{alignment = 16 : i64, elem_type = !llvm.array<32 x i8>}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%1765) : (!llvm.ptr) -> ()
  %1766 = "llvm.call"(%1765, %arg82) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_f25519_tobytes, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %1767 = "llvm.load"(%1765) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> i8
  %1768 = "llvm.and"(%1767, %1764) : (i8, i8) -> i8
  %1769 = "llvm.zext"(%1768) <{nonNeg}> : (i8) -> i32
  "llvm.intr.lifetime.end"(%1765) : (!llvm.ptr) -> ()
  "llvm.return"(%1769) : (i32) -> ()
}) : () -> ()
  with @fd_f25519_tobytes := fd_f25519_tobytes

end

end MLIR.Firedancer.Ref
