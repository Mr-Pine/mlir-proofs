module

-- agave-build/out/serial-noinline-big/op/_RINvCs3X6wZJE6GDg_6subtle9black_boxhECs2JGgYtL0Fal_14solana_ed25519.mlir
-- subtle[2e0bf2bcb38a7e1c]::black_box::<u8>

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

namespace MLIR.Agave.Serial

@[expose] public section

mlir_def black_box_u8 :=
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.noundef}], dso_local, function_type = !llvm.func<i8 (i8)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nonlazybind", ["probe-stack", "inline-asm"], ["target-cpu", "x86-64-v2"]], res_attrs = [{llvm.noundef}], sym_name = "_RINvCs3X6wZJE6GDg_6subtle9black_boxhECs2JGgYtL0Fal_14solana_ed25519", target_cpu = "x86-64-v2", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg98: i8):
  %2378 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %2379 = "llvm.alloca"(%2378) <{alignment = 1 : i64, elem_type = i8}> : (i32) -> !llvm.ptr
  "llvm.store"(%arg98, %2379) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %2380 = "llvm.load"(%2379) <{alignment = 1 : i64, ordering = 0 : i64, volatile_}> : (!llvm.ptr) -> i8
  "llvm.return"(%2380) : (i8) -> ()
}) : () -> ()

end

end MLIR.Agave.Serial
