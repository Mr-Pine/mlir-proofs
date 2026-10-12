module

-- agave-build/out/serial-noinline-big/op/_RINvNtCsgxBkk5gSRhY_4core5slice20copy_from_slice_implhECs2JGgYtL0Fal_14solana_ed25519.mlir
-- core[c0acaeba6ab4c2e0]::slice::copy_from_slice_impl::<u8>

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

namespace MLIR.Agave.Serial

@[expose] public section

mlir_def copy_from_slice_impl_u8 :=
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.writeonly}, {llvm.noundef, llvm.range = #llvm.constant_range<i64, 0, 128>}, {llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.noundef, llvm.range = #llvm.constant_range<i64, 0, 128>}, {llvm.align = 8 : i64, llvm.dereferenceable = 24 : i64, llvm.noalias, llvm.nofree, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<void (ptr, i64, ptr, i64, ptr)>, linkage = #llvm.linkage<internal>, passthrough = ["nonlazybind", ["probe-stack", "inline-asm"], ["target-cpu", "x86-64-v2"]], sym_name = "_RINvNtCsgxBkk5gSRhY_4core5slice20copy_from_slice_implhECs2JGgYtL0Fal_14solana_ed25519", target_cpu = "x86-64-v2", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg18: !llvm.ptr, %arg19: i64, %arg20: !llvm.ptr, %arg21: i64, %arg22: !llvm.ptr):
  %332 = "llvm.icmp"(%arg19, %arg21) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%332)[^bb2, ^bb1] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb1:  // pred: ^bb0
  "llvm.call"(%arg19, %arg21, %arg22) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 24 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], callee = @_RNvNvNtCsgxBkk5gSRhY_4core5slice20copy_from_slice_impl17len_mismatch_fail, fastmathFlags = #llvm.fastmath<none>, no_inline, noreturn, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (i64, i64, !llvm.ptr) -> ()
  "llvm.unreachable"() : () -> ()
^bb2:  // pred: ^bb0
  "llvm.intr.memcpy"(%arg18, %arg20, %arg19) <{arg_attrs = [{llvm.align = 1 : i64, llvm.nonnull}, {llvm.align = 1 : i64, llvm.nonnull}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()

end

end MLIR.Agave.Serial
