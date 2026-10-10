module

-- agave-build/out/serial-noinline/op/_RNvMso_NtCs2JGgYtL0Fal_14solana_ed255196scalarNtB5_6Scalar17non_adjacent_form.mlir
-- <solana_ed25519[1fe0933b11699477]::scalar::Scalar>::non_adjacent_form

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

namespace MLIR.Agave.Serial

@[expose] public section

mlir_def Scalar_non_adjacent_form :=
#alias_scope_domain83 = #llvm.alias_scope_domain<id = distinct[83]<>, description = "_RNvNtCs2JGgYtL0Fal_14solana_ed255196scalar16read_le_u64_into">
#alias_scope158 = #llvm.alias_scope<id = distinct[254]<>, domain = #alias_scope_domain83, description = "_RNvNtCs2JGgYtL0Fal_14solana_ed255196scalar16read_le_u64_into: argument 0">
#alias_scope159 = #llvm.alias_scope<id = distinct[255]<>, domain = #alias_scope_domain83, description = "_RNvNtCs2JGgYtL0Fal_14solana_ed255196scalar16read_le_u64_into: argument 1">
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.align = 1 : i64, llvm.dead_on_unwind, llvm.dereferenceable = 256 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.writable, llvm.writeonly}, {llvm.dereferenceable = 32 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.noundef, llvm.range = #llvm.constant_range<i64, 5, 9>}], dso_local, function_type = !llvm.func<void (ptr, ptr, i64)>, linkage = #llvm.linkage<internal>, passthrough = ["nonlazybind", ["probe-stack", "inline-asm"], ["target-cpu", "x86-64-v2"]], personality = @rust_eh_personality, sym_name = "_RNvMso_NtCs2JGgYtL0Fal_14solana_ed255196scalarNtB5_6Scalar17non_adjacent_form", target_cpu = "x86-64-v2", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg14: !llvm.ptr, %arg15: !llvm.ptr, %arg16: i64):
  %120 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %121 = "llvm.mlir.constant"() <{value = 0 : i8}> : () -> i8
  %122 = "llvm.mlir.constant"() <{value = 256 : i64}> : () -> i64
  %123 = "llvm.mlir.constant"() <{value = 40 : i64}> : () -> i64
  %124 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %125 = "llvm.mlir.constant"() <{value = -1 : i64}> : () -> i64
  %126 = "llvm.mlir.constant"() <{value = 64 : i64}> : () -> i64
  %127 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %128 = "llvm.mlir.constant"() <{value = 6 : i64}> : () -> i64
  %129 = "llvm.mlir.constant"() <{value = 63 : i64}> : () -> i64
  %130 = "llvm.alloca"(%120) <{alignment = 16 : i64, elem_type = !llvm.array<40 x i8>}> : (i32) -> !llvm.ptr
  "llvm.intr.memset"(%arg14, %121, %122) <{arg_attrs = [{llvm.align = 1 : i64, llvm.dereferenceable = 256 : i64, llvm.nonnull, llvm.noundef}, {}, {}], isVolatile = false}> : (!llvm.ptr, i8, i64) -> ()
  "llvm.intr.lifetime.start"(%130) : (!llvm.ptr) -> ()
  "llvm.intr.memset"(%130, %121, %123) <{arg_attrs = [{llvm.align = 16 : i64, llvm.dereferenceable = 40 : i64, llvm.nonnull, llvm.noundef}, {}, {}], isVolatile = false}> : (!llvm.ptr, i8, i64) -> ()
  "llvm.intr.experimental.noalias.scope.decl"() <{scope = #alias_scope158}> : () -> ()
  "llvm.intr.experimental.noalias.scope.decl"() <{scope = #alias_scope159}> : () -> ()
  %131 = "llvm.load"(%arg15) <{alias_scopes = [#alias_scope158], alignment = 1 : i64, noalias_scopes = [#alias_scope159], ordering = 0 : i64}> : (!llvm.ptr) -> vector<2xi64>
  "llvm.store"(%131, %130) <{alias_scopes = [#alias_scope159], alignment = 16 : i64, noalias_scopes = [#alias_scope158], ordering = 0 : i64}> : (vector<2xi64>, !llvm.ptr) -> ()
  %132 = "llvm.getelementptr"(%130) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %133 = "llvm.getelementptr"(%arg15) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %134 = "llvm.load"(%133) <{alias_scopes = [#alias_scope158], alignment = 1 : i64, noalias_scopes = [#alias_scope159], ordering = 0 : i64}> : (!llvm.ptr) -> vector<2xi64>
  "llvm.store"(%134, %132) <{alias_scopes = [#alias_scope159], alignment = 16 : i64, noalias_scopes = [#alias_scope158], ordering = 0 : i64}> : (vector<2xi64>, !llvm.ptr) -> ()
  %135 = "llvm.shl"(%124, %arg16) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %136 = "llvm.add"(%135, %125) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %137 = "llvm.sub"(%126, %arg16) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %138 = "llvm.lshr"(%135, %124) <{isExact}> : (i64, i64) -> i64
  %139 = "llvm.trunc"(%135) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.br"(%127, %127)[^bb1] : (i64, i64) -> ()
^bb1(%140: i64, %141: i64):  // 2 preds: ^bb0, ^bb7
  "llvm.br"(%140)[^bb3] : (i64) -> ()
^bb2:  // 2 preds: ^bb6, ^bb7
  "llvm.intr.lifetime.end"(%130) : (!llvm.ptr) -> ()
  "llvm.return"() : () -> ()
^bb3(%142: i64):  // 2 preds: ^bb1, ^bb6
  %143 = "llvm.lshr"(%142, %128) : (i64, i64) -> i64
  %144 = "llvm.and"(%142, %129) : (i64, i64) -> i64
  %145 = "llvm.icmp"(%144, %137) <{predicate = 6 : i64}> : (i64, i64) -> i1
  %146 = "llvm.getelementptr"(%130, %143) <{elem_type = i64, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %147 = "llvm.load"(%146) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %148 = "llvm.lshr"(%147, %144) : (i64, i64) -> i64
  "llvm.cond_br"(%145, %148)[^bb5, ^bb4] <{operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i64) -> ()
^bb4:  // pred: ^bb3
  %149 = "llvm.getelementptr"(%146) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %150 = "llvm.load"(%149) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %151 = "llvm.sub"(%127, %142) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %152 = "llvm.and"(%151, %129) : (i64, i64) -> i64
  %153 = "llvm.shl"(%150, %152) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %154 = "llvm.or"(%153, %148) : (i64, i64) -> i64
  "llvm.br"(%154)[^bb5] : (i64) -> ()
^bb5(%155: i64):  // 2 preds: ^bb3, ^bb4
  %156 = "llvm.and"(%155, %136) : (i64, i64) -> i64
  %157 = "llvm.add"(%156, %141) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %158 = "llvm.and"(%157, %124) : (i64, i64) -> i64
  %159 = "llvm.icmp"(%158, %127) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%159, %157, %142)[^bb6, ^bb7] <{operandSegmentSizes = array<i32: 1, 0, 2>}> : (i1, i64, i64) -> ()
^bb6:  // pred: ^bb5
  %160 = "llvm.add"(%142, %124) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %161 = "llvm.icmp"(%160, %122) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%161, %160)[^bb2, ^bb3] <{operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb7(%162: i64, %163: i64):  // pred: ^bb5
  %164 = "llvm.icmp"(%162, %138) <{predicate = 9 : i64}> : (i64, i64) -> i1
  %165 = "llvm.trunc"(%162) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %166 = "llvm.select"(%164, %139, %121) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i8, i8) -> i8
  %167 = "llvm.sub"(%165, %166) <{overflowFlags = 0 : i32}> : (i8, i8) -> i8
  %168 = "llvm.zext"(%164) : (i1) -> i64
  %169 = "llvm.getelementptr"(%arg14, %163) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%167, %169) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %170 = "llvm.add"(%163, %arg16) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %171 = "llvm.icmp"(%170, %122) <{predicate = 6 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%171, %170, %168)[^bb1, ^bb2] <{operandSegmentSizes = array<i32: 1, 2, 0>}> : (i1, i64, i64) -> ()
}) : () -> ()

end

end MLIR.Agave.Serial
