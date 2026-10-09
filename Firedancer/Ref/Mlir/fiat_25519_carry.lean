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
^bb0(%arg139: !llvm.ptr, %arg140: !llvm.ptr):
  %2120 = "llvm.mlir.constant"() <{value = 51 : i64}> : () -> i64
  %2121 = "llvm.mlir.constant"() <{value = 2251799813685247 : i64}> : () -> i64
  %2122 = "llvm.mlir.constant"() <{value = 19 : i64}> : () -> i64
  %2123 = "llvm.load"(%arg140) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %2124 = "llvm.lshr"(%2123, %2120) : (i64, i64) -> i64
  %2125 = "llvm.getelementptr"(%arg140) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %2126 = "llvm.load"(%2125) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %2127 = "llvm.add"(%2124, %2126) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %2128 = "llvm.lshr"(%2127, %2120) : (i64, i64) -> i64
  %2129 = "llvm.getelementptr"(%arg140) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %2130 = "llvm.load"(%2129) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %2131 = "llvm.add"(%2128, %2130) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %2132 = "llvm.lshr"(%2131, %2120) : (i64, i64) -> i64
  %2133 = "llvm.getelementptr"(%arg140) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %2134 = "llvm.load"(%2133) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %2135 = "llvm.add"(%2132, %2134) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %2136 = "llvm.lshr"(%2135, %2120) : (i64, i64) -> i64
  %2137 = "llvm.getelementptr"(%arg140) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %2138 = "llvm.load"(%2137) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %2139 = "llvm.add"(%2136, %2138) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %2140 = "llvm.and"(%2123, %2121) : (i64, i64) -> i64
  %2141 = "llvm.lshr"(%2139, %2120) : (i64, i64) -> i64
  %2142 = "llvm.mul"(%2141, %2122) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %2143 = "llvm.add"(%2142, %2140) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %2144 = "llvm.lshr"(%2143, %2120) : (i64, i64) -> i64
  %2145 = "llvm.and"(%2127, %2121) : (i64, i64) -> i64
  %2146 = "llvm.add"(%2144, %2145) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %2147 = "llvm.and"(%2143, %2121) : (i64, i64) -> i64
  %2148 = "llvm.and"(%2146, %2121) : (i64, i64) -> i64
  %2149 = "llvm.lshr"(%2146, %2120) : (i64, i64) -> i64
  %2150 = "llvm.and"(%2131, %2121) : (i64, i64) -> i64
  %2151 = "llvm.add"(%2149, %2150) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %2152 = "llvm.and"(%2135, %2121) : (i64, i64) -> i64
  %2153 = "llvm.and"(%2139, %2121) : (i64, i64) -> i64
  "llvm.store"(%2147, %arg139) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (i64, !llvm.ptr) -> ()
  %2154 = "llvm.getelementptr"(%arg139) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2148, %2154) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (i64, !llvm.ptr) -> ()
  %2155 = "llvm.getelementptr"(%arg139) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2151, %2155) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (i64, !llvm.ptr) -> ()
  %2156 = "llvm.getelementptr"(%arg139) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2152, %2156) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (i64, !llvm.ptr) -> ()
  %2157 = "llvm.getelementptr"(%arg139) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2153, %2157) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (i64, !llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()

end

end MLIR.Firedancer.Ref
