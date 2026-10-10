module

-- agave-build/out/avx2-noinline/op/_RNvMs2_NtCsh8hPzWUDumX_14solana_ed255196windowINtB5_15NafLookupTable8NtNtNtNtNtB7_7backend6vector4avx27edwards11CachedPointE6selectB7_.mlir
-- <solana_ed25519[c79103de3f6f5451]::window::NafLookupTable8<solana_ed25519[c79103de3f6f5451]::backend::vector::avx2::edwards::CachedPoint>>::select

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Agave.Avx2.Mlir.BASEPOINT_ODD_LOOKUP_TABLE
public import Agave.Avx2.Mlir.anon_e79fcfe266c5706188f989b4d452749f_38

meta import MLIR.Semantics.Func
meta import Agave.Avx2.Mlir.BASEPOINT_ODD_LOOKUP_TABLE
meta import Agave.Avx2.Mlir.anon_e79fcfe266c5706188f989b4d452749f_38

namespace MLIR.Agave.Avx2

@[expose] public section

noncomputable mlir_def NafLookupTable8_CachedPoint_select :=
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.align = 32 : i64, llvm.dead_on_unwind, llvm.dereferenceable = 160 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.writable, llvm.writeonly}, {llvm.noundef, llvm.range = #llvm.constant_range<i64, -128, 128>}], dso_local, function_type = !llvm.func<void (ptr, i64)>, linkage = #llvm.linkage<internal>, passthrough = ["nonlazybind", ["probe-stack", "inline-asm"], ["target-cpu", "x86-64-v2"]], sym_name = "_RNvMs2_NtCsh8hPzWUDumX_14solana_ed255196windowINtB5_15NafLookupTable8NtNtNtNtNtB7_7backend6vector4avx27edwards11CachedPointE6selectB7_", target_cpu = "x86-64-v2", target_features = #llvm.target_features<["+avx", "+avx2", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+crc32", "+ssse3"]>, unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg1: !llvm.ptr, %arg2: i64):
  %34 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %35 = "llvm.mlir.constant"() <{value = 128 : i64}> : () -> i64
  %36 = "llvm.mlir.constant"() <{value = 64 : i64}> : () -> i64
  %37 = "llvm.mlir.addressof"() <{global_name = @anon.e79fcfe266c5706188f989b4d452749f.38}> : () -> !llvm.ptr
  %38 = "llvm.mlir.addressof"() <{global_name = @_RNvNtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6vector4avx29constants26BASEPOINT_ODD_LOOKUP_TABLE}> : () -> !llvm.ptr
  %39 = "llvm.mlir.constant"() <{value = 160 : i64}> : () -> i64
  %40 = "llvm.lshr"(%arg2, %34) : (i64, i64) -> i64
  %41 = "llvm.icmp"(%arg2, %35) <{predicate = 6 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%41)[^bb1, ^bb2] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb1:  // pred: ^bb0
  %42 = "llvm.getelementptr"(%38, %40) <{elem_type = !llvm.struct<(struct<(array<5 x vector<4xi64>>)>)>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.intr.memcpy"(%arg1, %42, %39) <{arg_attrs = [{llvm.align = 32 : i64, llvm.dereferenceable = 160 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 32 : i64, llvm.dereferenceable = 160 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.return"() : () -> ()
^bb2:  // pred: ^bb0
  "llvm.call"(%40, %36, %37) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 24 : i64, llvm.noalias, llvm.nofree, llvm.noundef, llvm.readonly}], callee = @_RNvNtCsgxBkk5gSRhY_4core9panicking18panic_bounds_check, fastmathFlags = #llvm.fastmath<none>, no_inline, noreturn, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (i64, i64, !llvm.ptr) -> ()
  "llvm.unreachable"() : () -> ()
}) : () -> ()
  with
    @_RNvNtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6vector4avx29constants26BASEPOINT_ODD_LOOKUP_TABLE := BASEPOINT_ODD_LOOKUP_TABLE,
    @anon.e79fcfe266c5706188f989b4d452749f.38 := anon_e79fcfe266c5706188f989b4d452749f_38

end

end MLIR.Agave.Avx2
