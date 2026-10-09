module

-- build/llvm23/mlir_canonicalized/ref/op/fiat_25519_subborrowx_u51.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

namespace MLIR.Firedancer.Ref

@[expose] public section

mlir_def fiat_25519_subborrowx_u51 :=
#tbaa_root = #llvm.tbaa_root<id = "Simple C/C++ TBAA">
#tbaa_type_desc = #llvm.tbaa_type_desc<id = "omnipotent char", members = {<#tbaa_root, 0>}>
#tbaa_tag = #llvm.tbaa_tag<base_type = #tbaa_type_desc, access_type = #tbaa_type_desc, offset = 0>
#tbaa_type_desc1 = #llvm.tbaa_type_desc<id = "long", members = {<#tbaa_type_desc, 0>}>
#tbaa_tag1 = #llvm.tbaa_tag<base_type = #tbaa_type_desc1, access_type = #tbaa_type_desc1, offset = 0>
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.writeonly}, {llvm.noundef, llvm.zeroext}, {llvm.noundef}, {llvm.noundef, llvm.range = #llvm.constant_range<i64, 2251799813685229, 2251799813685248>}], dso_local, function_type = !llvm.func<void (ptr, ptr, i8, i64, i64)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"]], sym_name = "fiat_25519_subborrowx_u51", target_cpu = "x86-64", target_features = #llvm.target_features<["+cmov", "+cx8", "+fxsr", "+mmx", "+sse", "+sse2", "+x87"]>, tune_cpu = "generic", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg15: !llvm.ptr, %arg16: !llvm.ptr, %arg17: i8, %arg18: i64, %arg19: i64):
  %53 = "llvm.mlir.constant"() <{value = 51 : i64}> : () -> i64
  %54 = "llvm.mlir.constant"() <{value = 2251799813685247 : i64}> : () -> i64
  %55 = "llvm.mlir.constant"() <{value = 0 : i8}> : () -> i8
  %56 = "llvm.zext"(%arg17) : (i8) -> i64
  %57 = "llvm.add"(%arg19, %56) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %58 = "llvm.sub"(%arg18, %57) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %59 = "llvm.lshr"(%58, %53) : (i64, i64) -> i64
  %60 = "llvm.trunc"(%59) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %61 = "llvm.and"(%58, %54) : (i64, i64) -> i64
  "llvm.store"(%61, %arg15) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (i64, !llvm.ptr) -> ()
  %62 = "llvm.sub"(%55, %60) <{overflowFlags = 0 : i32}> : (i8, i8) -> i8
  "llvm.store"(%62, %arg16) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (i8, !llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()

end

end MLIR.Firedancer.Ref
