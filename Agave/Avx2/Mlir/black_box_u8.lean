module

-- agave-build/out/avx2-noinline/op/_RINvCs3X6wZJE6GDg_6subtle9black_boxhECsh8hPzWUDumX_14solana_ed25519.mlir
-- subtle[2e0bf2bcb38a7e1c]::black_box::<u8>

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

namespace MLIR.Agave.Avx2

@[expose] public section

mlir_def black_box_u8 :=
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.noundef}], dso_local, function_type = !llvm.func<i8 (i8)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nonlazybind", ["probe-stack", "inline-asm"], ["target-cpu", "x86-64-v2"]], res_attrs = [{llvm.noundef}], sym_name = "_RINvCs3X6wZJE6GDg_6subtle9black_boxhECsh8hPzWUDumX_14solana_ed25519", target_cpu = "x86-64-v2", target_features = #llvm.target_features<["+avx", "+avx2", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+crc32", "+ssse3"]>, unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg65: i8):
  %2678 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %2679 = "llvm.alloca"(%2678) <{alignment = 1 : i64, elem_type = i8}> : (i32) -> !llvm.ptr
  "llvm.store"(%arg65, %2679) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %2680 = "llvm.load"(%2679) <{alignment = 1 : i64, ordering = 0 : i64, volatile_}> : (!llvm.ptr) -> i8
  "llvm.return"(%2680) : (i8) -> ()
}) : () -> ()

end

end MLIR.Agave.Avx2
