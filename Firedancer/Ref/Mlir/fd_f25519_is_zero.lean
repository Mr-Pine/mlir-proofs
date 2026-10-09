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
^bb0(%arg174: !llvm.ptr):
  %2170 = "llvm.mlir.constant"() <{value = 2251799813685247 : i64}> : () -> i64
  %2171 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %2172 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %2173 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %2174 = "llvm.load"(%arg174) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  "llvm.switch"(%2174)[^bb9, ^bb1, ^bb5] <{case_operand_segments = array<i32: 0, 0>, case_values = dense<[0, 2251799813685229]> : vector<2xi64>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i64) -> ()
^bb1:  // pred: ^bb0
  %2175 = "llvm.getelementptr"(%arg174) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %2176 = "llvm.load"(%2175) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %2177 = "llvm.icmp"(%2176, %2172) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%2177)[^bb2, ^bb9] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb2:  // pred: ^bb1
  %2178 = "llvm.getelementptr"(%arg174) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %2179 = "llvm.load"(%2178) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %2180 = "llvm.icmp"(%2179, %2172) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%2180)[^bb3, ^bb9] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb3:  // pred: ^bb2
  %2181 = "llvm.getelementptr"(%arg174) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %2182 = "llvm.load"(%2181) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %2183 = "llvm.icmp"(%2182, %2172) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%2183)[^bb4, ^bb9] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb4:  // pred: ^bb3
  %2184 = "llvm.getelementptr"(%arg174) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %2185 = "llvm.load"(%2184) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %2186 = "llvm.icmp"(%2185, %2172) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%2186, %2171)[^bb10, ^bb9] <{operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i32) -> ()
^bb5:  // pred: ^bb0
  %2187 = "llvm.getelementptr"(%arg174) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %2188 = "llvm.load"(%2187) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %2189 = "llvm.icmp"(%2188, %2170) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%2189)[^bb6, ^bb9] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb6:  // pred: ^bb5
  %2190 = "llvm.getelementptr"(%arg174) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %2191 = "llvm.load"(%2190) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %2192 = "llvm.icmp"(%2191, %2170) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%2192)[^bb7, ^bb9] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb7:  // pred: ^bb6
  %2193 = "llvm.getelementptr"(%arg174) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %2194 = "llvm.load"(%2193) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %2195 = "llvm.icmp"(%2194, %2170) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%2195)[^bb8, ^bb9] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb8:  // pred: ^bb7
  %2196 = "llvm.getelementptr"(%arg174) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %2197 = "llvm.load"(%2196) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %2198 = "llvm.icmp"(%2197, %2170) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%2198, %2171)[^bb10, ^bb9] <{operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i32) -> ()
^bb9:  // 9 preds: ^bb0, ^bb1, ^bb2, ^bb3, ^bb4, ^bb5, ^bb6, ^bb7, ^bb8
  "llvm.br"(%2173)[^bb10] : (i32) -> ()
^bb10(%2199: i32):  // 3 preds: ^bb4, ^bb8, ^bb9
  "llvm.return"(%2199) : (i32) -> ()
}) : () -> ()

end

end MLIR.Firedancer.Ref
