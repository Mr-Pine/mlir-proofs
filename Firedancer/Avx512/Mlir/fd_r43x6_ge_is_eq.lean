module

-- build/llvm23/mlir_canonicalized/avx512/op/fd_r43x6_ge_is_eq.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Firedancer.Avx512.Mlir.fd_r43x6_is_nonzero
public import Firedancer.Avx512.Mlir.fd_r43x6_quad_mul_fast

meta import MLIR.Semantics.Func
meta import Firedancer.Avx512.Mlir.fd_r43x6_is_nonzero
meta import Firedancer.Avx512.Mlir.fd_r43x6_quad_mul_fast

namespace MLIR.Firedancer.Avx512

@[expose] public section

mlir_def fd_r43x6_ge_is_eq :=
#tbaa_root = #llvm.tbaa_root<id = "Simple C/C++ TBAA">
#tbaa_type_desc = #llvm.tbaa_type_desc<id = "omnipotent char", members = {<#tbaa_root, 0>}>
#tbaa_tag = #llvm.tbaa_tag<base_type = #tbaa_type_desc, access_type = #tbaa_type_desc, offset = 0>
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], dso_local, function_type = !llvm.func<i32 (vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", ["min-legal-vector-width", "512"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "icelake-server"]], res_attrs = [{llvm.range = #llvm.constant_range<i32, 0, 2>}], sym_name = "fd_r43x6_ge_is_eq", target_cpu = "icelake-server", target_features = #llvm.target_features<["+adx", "+aes", "+avx", "+avx2", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+pclmul", "+pconfig", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdrnd", "+rdseed", "+sahf", "+sgx", "+sha", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves"]>, unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg6: vector<8xi64>, %arg7: vector<8xi64>, %arg8: vector<8xi64>, %arg9: vector<8xi64>, %arg10: vector<8xi64>, %arg11: vector<8xi64>):
  %67 = "llvm.mlir.constant"() <{value = -1 : i32}> : () -> i32
  %68 = "llvm.mlir.constant"() <{value = dense<[8796093022189, 8796093022207, 8796093022207, 8796093022207, 8796093022207, 1099511627775, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %69 = "llvm.mlir.constant"() <{value = 7 : i32}> : () -> i32
  %70 = "llvm.mlir.constant"() <{value = 6 : i32}> : () -> i32
  %71 = "llvm.mlir.constant"() <{value = 5 : i32}> : () -> i32
  %72 = "llvm.mlir.constant"() <{value = 4 : i32}> : () -> i32
  %73 = "llvm.mlir.constant"() <{value = 3 : i32}> : () -> i32
  %74 = "llvm.mlir.constant"() <{value = 2 : i32}> : () -> i32
  %75 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %76 = "llvm.mlir.poison"() : () -> vector<8xi64>
  %77 = "llvm.mlir.poison"() : () -> i64
  %78 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %79 = "llvm.mlir.undef"() : () -> vector<8xi64>
  %80 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %81 = "llvm.insertelement"(%79, %78, %80) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %82 = "llvm.insertelement"(%81, %77, %75) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %83 = "llvm.insertelement"(%82, %78, %74) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %84 = "llvm.insertelement"(%83, %77, %73) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %85 = "llvm.insertelement"(%84, %78, %72) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %86 = "llvm.insertelement"(%85, %77, %71) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %87 = "llvm.insertelement"(%86, %78, %70) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %88 = "llvm.insertelement"(%87, %77, %69) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %89 = "llvm.insertelement"(%79, %77, %80) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %90 = "llvm.insertelement"(%89, %78, %75) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %91 = "llvm.insertelement"(%90, %77, %74) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %92 = "llvm.insertelement"(%91, %78, %73) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %93 = "llvm.insertelement"(%92, %77, %72) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %94 = "llvm.insertelement"(%93, %78, %71) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %95 = "llvm.insertelement"(%94, %77, %70) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %96 = "llvm.insertelement"(%95, %78, %69) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %97 = "llvm.alloca"(%75) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %98 = "llvm.alloca"(%75) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %99 = "llvm.alloca"(%75) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %100 = "llvm.shufflevector"(%arg6, %76) <{mask = array<i32: 2, 0, 2, 1, 6, 4, 6, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %101 = "llvm.shufflevector"(%arg7, %76) <{mask = array<i32: 2, 0, 2, 1, 6, 4, 6, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %102 = "llvm.shufflevector"(%arg8, %76) <{mask = array<i32: 2, 0, 2, 1, 6, 4, 6, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %103 = "llvm.shufflevector"(%arg9, %76) <{mask = array<i32: 0, 2, 1, 2, 4, 6, 5, 6>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %104 = "llvm.shufflevector"(%arg10, %76) <{mask = array<i32: 0, 2, 1, 2, 4, 6, 5, 6>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %105 = "llvm.shufflevector"(%arg11, %76) <{mask = array<i32: 0, 2, 1, 2, 4, 6, 5, 6>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.intr.lifetime.start"(%97) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%98) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%99) : (!llvm.ptr) -> ()
  "llvm.call"(%97, %98, %99, %100, %101, %102, %103, %104, %105) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_quad_mul_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 9, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>) -> ()
  %106 = "llvm.load"(%97) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %107 = "llvm.load"(%98) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %108 = "llvm.load"(%99) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  "llvm.intr.lifetime.end"(%99) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%98) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%97) : (!llvm.ptr) -> ()
  %109 = "llvm.shufflevector"(%106, %107) <{mask = array<i32: 0, 8, 2, 10, 4, 12, 6, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %110 = "llvm.shufflevector"(%106, %107) <{mask = array<i32: 1, 9, 3, 11, 5, 13, 7, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %111 = "llvm.shufflevector"(%108, %88) <{mask = array<i32: 0, 8, 2, 10, 4, 12, 6, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %112 = "llvm.shufflevector"(%108, %96) <{mask = array<i32: 1, 9, 3, 11, 5, 13, 7, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %113 = "llvm.shufflevector"(%109, %111) <{mask = array<i32: 0, 1, 8, 4, 5, 12, 9, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %114 = "llvm.shufflevector"(%110, %112) <{mask = array<i32: 0, 1, 8, 4, 5, 12, 9, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %115 = "llvm.shufflevector"(%109, %111) <{mask = array<i32: 2, 3, 10, 6, 7, 14, 9, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %116 = "llvm.shufflevector"(%110, %112) <{mask = array<i32: 2, 3, 10, 6, 7, 14, 9, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %117 = "llvm.sub"(%114, %113) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %118 = "llvm.add"(%117, %68) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %119 = "llvm.call"(%118) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @fd_r43x6_is_nonzero, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (vector<8xi64>) -> i32
  %120 = "llvm.xor"(%119, %67) : (i32, i32) -> i32
  %121 = "llvm.sub"(%116, %115) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %122 = "llvm.add"(%121, %68) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %123 = "llvm.call"(%122) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @fd_r43x6_is_nonzero, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (vector<8xi64>) -> i32
  %124 = "llvm.xor"(%123, %75) : (i32, i32) -> i32
  %125 = "llvm.and"(%124, %120) : (i32, i32) -> i32
  "llvm.return"(%125) : (i32) -> ()
}) : () -> ()
  with @fd_r43x6_is_nonzero := fd_r43x6_is_nonzero,
    @fd_r43x6_quad_mul_fast := fd_r43x6_quad_mul_fast

end

end MLIR.Firedancer.Avx512
