module

-- build/llvm23/mlir_canonicalized/ref/op/fiat_25519_carry.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

namespace MLIR.Firedancer.Ref

@[expose] public section

mlir_def fiat_25519_carry :=
#tbaa_root = #llvm.tbaa_root<id = "Simple C/C++ TBAA">
#tbaa_type_desc = #llvm.tbaa_type_desc<id = "omnipotent char", members = {<#tbaa_root, 0>}>
#tbaa_type_desc1 = #llvm.tbaa_type_desc<id = "long", members = {<#tbaa_type_desc, 0>}>
#tbaa_tag1 = #llvm.tbaa_tag<base_type = #tbaa_type_desc1, access_type = #tbaa_type_desc1, offset = 0>
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nocapture, llvm.nofree, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<void (ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"]], sym_name = "fiat_25519_carry", target_cpu = "x86-64", target_features = #llvm.target_features<["+cmov", "+cx8", "+fxsr", "+mmx", "+sse", "+sse2", "+x87"]>, tune_cpu = "generic", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg135: !llvm.ptr, %arg136: !llvm.ptr):
  %2104 = "llvm.mlir.constant"() <{value = 51 : i64}> : () -> i64
  %2105 = "llvm.mlir.constant"() <{value = 2251799813685247 : i64}> : () -> i64
  %2106 = "llvm.mlir.constant"() <{value = 19 : i64}> : () -> i64
  %2107 = "llvm.load"(%arg136) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %2108 = "llvm.lshr"(%2107, %2104) : (i64, i64) -> i64
  %2109 = "llvm.getelementptr"(%arg136) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %2110 = "llvm.load"(%2109) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %2111 = "llvm.add"(%2108, %2110) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %2112 = "llvm.lshr"(%2111, %2104) : (i64, i64) -> i64
  %2113 = "llvm.getelementptr"(%arg136) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %2114 = "llvm.load"(%2113) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %2115 = "llvm.add"(%2112, %2114) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %2116 = "llvm.lshr"(%2115, %2104) : (i64, i64) -> i64
  %2117 = "llvm.getelementptr"(%arg136) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %2118 = "llvm.load"(%2117) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %2119 = "llvm.add"(%2116, %2118) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %2120 = "llvm.lshr"(%2119, %2104) : (i64, i64) -> i64
  %2121 = "llvm.getelementptr"(%arg136) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %2122 = "llvm.load"(%2121) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %2123 = "llvm.add"(%2120, %2122) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %2124 = "llvm.and"(%2107, %2105) : (i64, i64) -> i64
  %2125 = "llvm.lshr"(%2123, %2104) : (i64, i64) -> i64
  %2126 = "llvm.mul"(%2125, %2106) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %2127 = "llvm.add"(%2126, %2124) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %2128 = "llvm.lshr"(%2127, %2104) : (i64, i64) -> i64
  %2129 = "llvm.and"(%2111, %2105) : (i64, i64) -> i64
  %2130 = "llvm.add"(%2128, %2129) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %2131 = "llvm.and"(%2127, %2105) : (i64, i64) -> i64
  %2132 = "llvm.and"(%2130, %2105) : (i64, i64) -> i64
  %2133 = "llvm.lshr"(%2130, %2104) : (i64, i64) -> i64
  %2134 = "llvm.and"(%2115, %2105) : (i64, i64) -> i64
  %2135 = "llvm.add"(%2133, %2134) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %2136 = "llvm.and"(%2119, %2105) : (i64, i64) -> i64
  %2137 = "llvm.and"(%2123, %2105) : (i64, i64) -> i64
  "llvm.store"(%2131, %arg135) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (i64, !llvm.ptr) -> ()
  %2138 = "llvm.getelementptr"(%arg135) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2132, %2138) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (i64, !llvm.ptr) -> ()
  %2139 = "llvm.getelementptr"(%arg135) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2135, %2139) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (i64, !llvm.ptr) -> ()
  %2140 = "llvm.getelementptr"(%arg135) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2136, %2140) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (i64, !llvm.ptr) -> ()
  %2141 = "llvm.getelementptr"(%arg135) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2137, %2141) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (i64, !llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()

end

end MLIR.Firedancer.Ref
