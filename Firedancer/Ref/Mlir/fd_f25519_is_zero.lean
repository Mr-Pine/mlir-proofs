module

-- build/llvm23/mlir_canonicalized/ref/op/fd_f25519_is_zero.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

namespace MLIR.Firedancer.Ref

@[expose] public section

mlir_def fd_f25519_is_zero :=
#tbaa_root = #llvm.tbaa_root<id = "Simple C/C++ TBAA">
#tbaa_type_desc = #llvm.tbaa_type_desc<id = "omnipotent char", members = {<#tbaa_root, 0>}>
#tbaa_type_desc1 = #llvm.tbaa_type_desc<id = "long", members = {<#tbaa_type_desc, 0>}>
#tbaa_tag1 = #llvm.tbaa_tag<base_type = #tbaa_type_desc1, access_type = #tbaa_type_desc1, offset = 0>
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<i32 (ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"]], res_attrs = [{llvm.range = #llvm.constant_range<i32, 0, 2>}], sym_name = "fd_f25519_is_zero", target_cpu = "x86-64", target_features = #llvm.target_features<["+cmov", "+cx8", "+fxsr", "+mmx", "+sse", "+sse2", "+x87"]>, tune_cpu = "generic", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg170: !llvm.ptr):
  %2154 = "llvm.mlir.constant"() <{value = 2251799813685247 : i64}> : () -> i64
  %2155 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %2156 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %2157 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %2158 = "llvm.load"(%arg170) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  "llvm.switch"(%2158)[^bb9, ^bb1, ^bb5] <{case_operand_segments = array<i32: 0, 0>, case_values = dense<[0, 2251799813685229]> : vector<2xi64>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i64) -> ()
^bb1:  // pred: ^bb0
  %2159 = "llvm.getelementptr"(%arg170) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %2160 = "llvm.load"(%2159) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %2161 = "llvm.icmp"(%2160, %2156) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%2161)[^bb2, ^bb9] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb2:  // pred: ^bb1
  %2162 = "llvm.getelementptr"(%arg170) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %2163 = "llvm.load"(%2162) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %2164 = "llvm.icmp"(%2163, %2156) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%2164)[^bb3, ^bb9] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb3:  // pred: ^bb2
  %2165 = "llvm.getelementptr"(%arg170) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %2166 = "llvm.load"(%2165) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %2167 = "llvm.icmp"(%2166, %2156) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%2167)[^bb4, ^bb9] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb4:  // pred: ^bb3
  %2168 = "llvm.getelementptr"(%arg170) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %2169 = "llvm.load"(%2168) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %2170 = "llvm.icmp"(%2169, %2156) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%2170, %2155)[^bb10, ^bb9] <{operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i32) -> ()
^bb5:  // pred: ^bb0
  %2171 = "llvm.getelementptr"(%arg170) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %2172 = "llvm.load"(%2171) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %2173 = "llvm.icmp"(%2172, %2154) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%2173)[^bb6, ^bb9] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb6:  // pred: ^bb5
  %2174 = "llvm.getelementptr"(%arg170) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %2175 = "llvm.load"(%2174) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %2176 = "llvm.icmp"(%2175, %2154) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%2176)[^bb7, ^bb9] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb7:  // pred: ^bb6
  %2177 = "llvm.getelementptr"(%arg170) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %2178 = "llvm.load"(%2177) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %2179 = "llvm.icmp"(%2178, %2154) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%2179)[^bb8, ^bb9] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb8:  // pred: ^bb7
  %2180 = "llvm.getelementptr"(%arg170) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %2181 = "llvm.load"(%2180) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %2182 = "llvm.icmp"(%2181, %2154) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%2182, %2155)[^bb10, ^bb9] <{operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i32) -> ()
^bb9:  // 9 preds: ^bb0, ^bb1, ^bb2, ^bb3, ^bb4, ^bb5, ^bb6, ^bb7, ^bb8
  "llvm.br"(%2157)[^bb10] : (i32) -> ()
^bb10(%2183: i32):  // 3 preds: ^bb4, ^bb8, ^bb9
  "llvm.return"(%2183) : (i32) -> ()
}) : () -> ()

end

end MLIR.Firedancer.Ref
