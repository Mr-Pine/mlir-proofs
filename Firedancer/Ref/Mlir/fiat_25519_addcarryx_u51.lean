module

-- build/llvm23/mlir_canonicalized/ref/op/fiat_25519_addcarryx_u51.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

namespace MLIR.Firedancer.Ref

@[expose] public section

mlir_def fiat_25519_addcarryx_u51 :=
#tbaa_root = #llvm.tbaa_root<id = "Simple C/C++ TBAA">
#tbaa_type_desc = #llvm.tbaa_type_desc<id = "omnipotent char", members = {<#tbaa_root, 0>}>
#tbaa_tag = #llvm.tbaa_tag<base_type = #tbaa_type_desc, access_type = #tbaa_type_desc, offset = 0>
#tbaa_type_desc1 = #llvm.tbaa_type_desc<id = "long", members = {<#tbaa_type_desc, 0>}>
#tbaa_tag1 = #llvm.tbaa_tag<base_type = #tbaa_type_desc1, access_type = #tbaa_type_desc1, offset = 0>
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.writeonly}, {llvm.noundef, llvm.zeroext}, {llvm.noundef}, {llvm.noundef, llvm.range = #llvm.constant_range<i64, 0, 2251799813685248>}], dso_local, function_type = !llvm.func<void (ptr, ptr, i8, i64, i64)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"]], sym_name = "fiat_25519_addcarryx_u51", target_cpu = "x86-64", target_features = #llvm.target_features<["+cmov", "+cx8", "+fxsr", "+mmx", "+sse", "+sse2", "+x87"]>, tune_cpu = "generic", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg6: !llvm.ptr, %arg7: !llvm.ptr, %arg8: i8, %arg9: i64, %arg10: i64):
  %42 = "llvm.mlir.constant"() <{value = 2251799813685247 : i64}> : () -> i64
  %43 = "llvm.mlir.constant"() <{value = 51 : i64}> : () -> i64
  %44 = "llvm.zext"(%arg8) : (i8) -> i64
  %45 = "llvm.add"(%arg9, %44) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %46 = "llvm.add"(%45, %arg10) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %47 = "llvm.and"(%46, %42) : (i64, i64) -> i64
  %48 = "llvm.lshr"(%46, %43) : (i64, i64) -> i64
  %49 = "llvm.trunc"(%48) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%47, %arg6) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (i64, !llvm.ptr) -> ()
  "llvm.store"(%49, %arg7) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (i8, !llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()

end

end MLIR.Firedancer.Ref
