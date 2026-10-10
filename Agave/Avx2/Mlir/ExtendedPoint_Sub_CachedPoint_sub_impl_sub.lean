module

-- agave-build/out/avx2-noinline/op/_RNvXNvXsi_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6vector4avx27edwardsRNtB8_13ExtendedPointINtNtNtCsgxBkk5gSRhY_4core3ops5arith3SubRNtB8_11CachedPointE3subB1c_NtB2_12___Impl_sub__9__impl_sub.mlir
-- <&solana_ed25519[c79103de3f6f5451]::backend::vector::avx2::edwards::ExtendedPoint as <&solana_ed25519[c79103de3f6f5451]::backend::vector::avx2::edwards::ExtendedPoint as core[c0acaeba6ab4c2e0]::ops::arith::Sub<&solana_ed25519[c79103de3f6f5451]::backend::vector::avx2::edwards::CachedPoint>>::sub::__Impl_sub__>::_impl_sub

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Agave.Avx2.Mlir.ExtendedPoint_Add_CachedPoint_add_impl_add

meta import MLIR.Semantics.Func
meta import Agave.Avx2.Mlir.ExtendedPoint_Add_CachedPoint_add_impl_add

namespace MLIR.Agave.Avx2

@[expose] public section

mlir_def ExtendedPoint_Sub_CachedPoint_sub_impl_sub :=
#alias_scope_domain127 = #llvm.alias_scope_domain<id = distinct[127]<>, description = "_RNvXNvXsg_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6vector4avx27edwardsRNtB8_11CachedPointNtNtNtCsgxBkk5gSRhY_4core3ops5arith3Neg3negB1c_NtB2_12___Impl_neg__9__impl_neg">
#alias_scope_domain128 = #llvm.alias_scope_domain<id = distinct[128]<>, description = "_RNvXNvMsb_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6vector4avx25fieldNtB8_18FieldElement2625x47shuffleB1a_NtB2_16___Impl_shuffle__13__impl_shuffle">
#alias_scope222 = #llvm.alias_scope<id = distinct[364]<>, domain = #alias_scope_domain127, description = "_RNvXNvXsg_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6vector4avx27edwardsRNtB8_11CachedPointNtNtNtCsgxBkk5gSRhY_4core3ops5arith3Neg3negB1c_NtB2_12___Impl_neg__9__impl_neg: argument 0">
#alias_scope223 = #llvm.alias_scope<id = distinct[365]<>, domain = #alias_scope_domain127, description = "_RNvXNvXsg_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6vector4avx27edwardsRNtB8_11CachedPointNtNtNtCsgxBkk5gSRhY_4core3ops5arith3Neg3negB1c_NtB2_12___Impl_neg__9__impl_neg: argument 1">
#alias_scope224 = #llvm.alias_scope<id = distinct[366]<>, domain = #alias_scope_domain128, description = "_RNvXNvMsb_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6vector4avx25fieldNtB8_18FieldElement2625x47shuffleB1a_NtB2_16___Impl_shuffle__13__impl_shuffle: argument 1">
#alias_scope225 = #llvm.alias_scope<id = distinct[367]<>, domain = #alias_scope_domain128, description = "_RNvXNvMsb_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6vector4avx25fieldNtB8_18FieldElement2625x47shuffleB1a_NtB2_16___Impl_shuffle__13__impl_shuffle: argument 0">
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.align = 32 : i64, llvm.dead_on_unwind, llvm.dereferenceable = 160 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.writable, llvm.writeonly}, {llvm.align = 32 : i64, llvm.dereferenceable = 160 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.align = 32 : i64, llvm.dereferenceable = 160 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<void (ptr, ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", "nonlazybind", ["probe-stack", "inline-asm"], ["target-cpu", "x86-64-v2"]], sym_name = "_RNvXNvXsi_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6vector4avx27edwardsRNtB8_13ExtendedPointINtNtNtCsgxBkk5gSRhY_4core3ops5arith3SubRNtB8_11CachedPointE3subB1c_NtB2_12___Impl_sub__9__impl_sub", target_cpu = "x86-64-v2", target_features = #llvm.target_features<["+avx", "+avx2", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+crc32", "+ssse3", "+avx", "+avx2", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+crc32", "+ssse3"]>, unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg10: !llvm.ptr, %arg11: !llvm.ptr, %arg12: !llvm.ptr):
  %90 = "llvm.mlir.constant"() <{value = 134217726 : i32}> : () -> i32
  %91 = "llvm.mlir.constant"() <{value = 7 : i32}> : () -> i32
  %92 = "llvm.mlir.constant"() <{value = 6 : i32}> : () -> i32
  %93 = "llvm.mlir.constant"() <{value = 5 : i32}> : () -> i32
  %94 = "llvm.mlir.constant"() <{value = 4 : i32}> : () -> i32
  %95 = "llvm.mlir.constant"() <{value = 3 : i32}> : () -> i32
  %96 = "llvm.mlir.constant"() <{value = 2 : i32}> : () -> i32
  %97 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %98 = "llvm.mlir.poison"() : () -> vector<8xi32>
  %99 = "llvm.mlir.constant"() <{value = 67108862 : i32}> : () -> i32
  %100 = "llvm.mlir.poison"() : () -> i32
  %101 = "llvm.mlir.constant"() <{value = 134217690 : i32}> : () -> i32
  %102 = "llvm.mlir.undef"() : () -> vector<8xi32>
  %103 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %104 = "llvm.insertelement"(%102, %100, %103) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %105 = "llvm.insertelement"(%104, %100, %97) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %106 = "llvm.insertelement"(%105, %100, %96) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %107 = "llvm.insertelement"(%106, %100, %95) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %108 = "llvm.insertelement"(%107, %100, %94) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %109 = "llvm.insertelement"(%108, %101, %93) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %110 = "llvm.insertelement"(%109, %100, %92) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %111 = "llvm.insertelement"(%110, %99, %91) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %112 = "llvm.insertelement"(%102, %100, %103) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %113 = "llvm.insertelement"(%112, %100, %97) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %114 = "llvm.insertelement"(%113, %100, %96) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %115 = "llvm.insertelement"(%114, %100, %95) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %116 = "llvm.insertelement"(%115, %100, %94) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %117 = "llvm.insertelement"(%116, %90, %93) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %118 = "llvm.insertelement"(%117, %100, %92) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %119 = "llvm.insertelement"(%118, %99, %91) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %120 = "llvm.alloca"(%97) <{alignment = 32 : i64, elem_type = !llvm.array<160 x i8>}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%120) : (!llvm.ptr) -> ()
  "llvm.intr.experimental.noalias.scope.decl"() <{scope = #alias_scope222}> : () -> ()
  "llvm.intr.experimental.noalias.scope.decl"() <{scope = #alias_scope223}> : () -> ()
  %121 = "llvm.load"(%arg12) <{alias_scopes = [#alias_scope224, #alias_scope223], alignment = 32 : i64, noalias_scopes = [#alias_scope225, #alias_scope222], ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi32>
  %122 = "llvm.getelementptr"(%arg12) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %123 = "llvm.load"(%122) <{alias_scopes = [#alias_scope224, #alias_scope223], alignment = 32 : i64, noalias_scopes = [#alias_scope225, #alias_scope222], ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi32>
  %124 = "llvm.getelementptr"(%arg12) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %125 = "llvm.load"(%124) <{alias_scopes = [#alias_scope224, #alias_scope223], alignment = 32 : i64, noalias_scopes = [#alias_scope225, #alias_scope222], ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi32>
  %126 = "llvm.getelementptr"(%arg12) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 96>}> : (!llvm.ptr) -> !llvm.ptr
  %127 = "llvm.load"(%126) <{alias_scopes = [#alias_scope224, #alias_scope223], alignment = 32 : i64, noalias_scopes = [#alias_scope225, #alias_scope222], ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi32>
  %128 = "llvm.shufflevector"(%121, %98) <{mask = array<i32: 1, 0, 3, 2, 4, 5, 6, 7>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %129 = "llvm.shufflevector"(%123, %98) <{mask = array<i32: 1, 0, 3, 2, 4, 5, 6, 7>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %130 = "llvm.shufflevector"(%125, %98) <{mask = array<i32: 1, 0, 3, 2, 4, 5, 6, 7>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %131 = "llvm.shufflevector"(%127, %98) <{mask = array<i32: 1, 0, 3, 2, 4, 5, 6, 7>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %132 = "llvm.getelementptr"(%arg12) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %133 = "llvm.load"(%132) <{alias_scopes = [#alias_scope224, #alias_scope223], alignment = 32 : i64, noalias_scopes = [#alias_scope225, #alias_scope222], ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi32>
  %134 = "llvm.shufflevector"(%133, %98) <{mask = array<i32: 1, 0, 3, 2, 4, 5, 6, 7>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %135 = "llvm.sub"(%111, %128) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %136 = "llvm.sub"(%119, %129) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %137 = "llvm.sub"(%119, %130) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %138 = "llvm.sub"(%119, %131) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %139 = "llvm.sub"(%119, %134) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %140 = "llvm.shufflevector"(%128, %135) <{mask = array<i32: 0, 1, 2, 3, 4, 13, 6, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %141 = "llvm.shufflevector"(%129, %136) <{mask = array<i32: 0, 1, 2, 3, 4, 13, 6, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %142 = "llvm.shufflevector"(%130, %137) <{mask = array<i32: 0, 1, 2, 3, 4, 13, 6, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %143 = "llvm.shufflevector"(%131, %138) <{mask = array<i32: 0, 1, 2, 3, 4, 13, 6, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %144 = "llvm.shufflevector"(%134, %139) <{mask = array<i32: 0, 1, 2, 3, 4, 13, 6, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  "llvm.store"(%140, %120) <{alias_scopes = [#alias_scope222], alignment = 32 : i64, noalias_scopes = [#alias_scope223], ordering = 0 : i64}> : (vector<8xi32>, !llvm.ptr) -> ()
  %145 = "llvm.getelementptr"(%120) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%141, %145) <{alias_scopes = [#alias_scope222], alignment = 32 : i64, noalias_scopes = [#alias_scope223], ordering = 0 : i64}> : (vector<8xi32>, !llvm.ptr) -> ()
  %146 = "llvm.getelementptr"(%120) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%142, %146) <{alias_scopes = [#alias_scope222], alignment = 32 : i64, noalias_scopes = [#alias_scope223], ordering = 0 : i64}> : (vector<8xi32>, !llvm.ptr) -> ()
  %147 = "llvm.getelementptr"(%120) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 96>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%143, %147) <{alias_scopes = [#alias_scope222], alignment = 32 : i64, noalias_scopes = [#alias_scope223], ordering = 0 : i64}> : (vector<8xi32>, !llvm.ptr) -> ()
  %148 = "llvm.getelementptr"(%120) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%144, %148) <{alias_scopes = [#alias_scope222], alignment = 32 : i64, noalias_scopes = [#alias_scope223], ordering = 0 : i64}> : (vector<8xi32>, !llvm.ptr) -> ()
  "llvm.call"(%arg10, %arg11, %120) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 32 : i64, llvm.dereferenceable = 160 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef}, {llvm.align = 32 : i64, llvm.dereferenceable = 160 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.align = 32 : i64, llvm.dereferenceable = 160 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], callee = @_RNvXNvXsh_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6vector4avx27edwardsRNtB8_13ExtendedPointINtNtNtCsgxBkk5gSRhY_4core3ops5arith3AddRNtB8_11CachedPointE3addB1c_NtB2_12___Impl_add__9__impl_add, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%120) : (!llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()
  with
    @_RNvXNvXsh_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6vector4avx27edwardsRNtB8_13ExtendedPointINtNtNtCsgxBkk5gSRhY_4core3ops5arith3AddRNtB8_11CachedPointE3addB1c_NtB2_12___Impl_add__9__impl_add := ExtendedPoint_Add_CachedPoint_add_impl_add

end

end MLIR.Agave.Avx2
