module

-- ~/fd-pr9879/build/llvm23-production/mlir_canonicalized/avx512/op/fd_r52x5_ge_is_eq.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Firedancer.R52x5.Mlir.fd_r52x5_quad_mul_fast
public import Firedancer.R52x5.Mlir.fd_r52x5_reduce
public import Firedancer.R52x5.Mlir.wl_permute

meta import MLIR.Semantics.Func
meta import Firedancer.R52x5.Mlir.fd_r52x5_quad_mul_fast
meta import Firedancer.R52x5.Mlir.fd_r52x5_reduce
meta import Firedancer.R52x5.Mlir.wl_permute

namespace MLIR.Firedancer.R52x5

@[expose] public section

mlir_def fd_r52x5_ge_is_eq :=
#tbaa_root = #llvm.tbaa_root<id = "Simple C/C++ TBAA">
#tbaa_type_desc = #llvm.tbaa_type_desc<id = "omnipotent char", members = {<#tbaa_root, 0>}>
#tbaa_tag = #llvm.tbaa_tag<base_type = #tbaa_type_desc, access_type = #tbaa_type_desc, offset = 0>
#tbaa_type_desc1 = #llvm.tbaa_type_desc<id = "long", members = {<#tbaa_type_desc, 0>}>
#tbaa_tag1 = #llvm.tbaa_tag<base_type = #tbaa_type_desc1, access_type = #tbaa_type_desc1, offset = 0>
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<i32 (vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", "sspstrong", ["min-legal-vector-width", "256"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "icelake-server"]], res_attrs = [{llvm.range = #llvm.constant_range<i32, 0, 2>}], sym_name = "fd_r52x5_ge_is_eq", target_cpu = "icelake-server", target_features = #llvm.target_features<["+adx", "+aes", "+avx", "+avx2", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+pclmul", "+pconfig", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdrnd", "+rdseed", "+sahf", "+sgx", "+sha", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves"]>, tune_cpu = "icelake-server", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg3: vector<4xi64>, %arg4: vector<4xi64>, %arg5: vector<4xi64>, %arg6: vector<4xi64>, %arg7: vector<4xi64>, %arg8: vector<4xi64>, %arg9: vector<4xi64>, %arg10: vector<4xi64>, %arg11: vector<4xi64>, %arg12: vector<4xi64>):
  %72 = "llvm.mlir.poison"() : () -> vector<2xi64>
  %73 = "llvm.mlir.poison"() : () -> vector<4xi64>
  %74 = "llvm.mlir.constant"() <{value = 5 : i64}> : () -> i64
  %75 = "llvm.mlir.constant"() <{value = 4 : i64}> : () -> i64
  %76 = "llvm.mlir.poison"() : () -> vector<8xi64>
  %77 = "llvm.mlir.constant"() <{value = 2 : i64}> : () -> i64
  %78 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %79 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %80 = "llvm.mlir.constant"() <{value = 2 : i32}> : () -> i32
  %81 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %82 = "llvm.mlir.constant"() <{value = dense<51> : vector<4xi64>}> : () -> vector<4xi64>
  %83 = "llvm.mlir.constant"() <{value = dense<2251799813685247> : vector<4xi64>}> : () -> vector<4xi64>
  %84 = "llvm.mlir.constant"() <{value = dense<19> : vector<4xi64>}> : () -> vector<4xi64>
  %85 = "llvm.mlir.constant"() <{value = 3 : i32}> : () -> i32
  %86 = "llvm.mlir.constant"() <{value = dense<72057594037927328> : vector<4xi64>}> : () -> vector<4xi64>
  %87 = "llvm.mlir.constant"() <{value = dense<72057594037927904> : vector<4xi64>}> : () -> vector<4xi64>
  %88 = "llvm.mlir.poison"() : () -> i64
  %89 = "llvm.mlir.constant"() <{value = 2251799813685247 : i64}> : () -> i64
  %90 = "llvm.mlir.undef"() : () -> vector<4xi64>
  %91 = "llvm.insertelement"(%90, %89, %81) : (vector<4xi64>, i64, i32) -> vector<4xi64>
  %92 = "llvm.insertelement"(%91, %88, %79) : (vector<4xi64>, i64, i32) -> vector<4xi64>
  %93 = "llvm.insertelement"(%92, %89, %80) : (vector<4xi64>, i64, i32) -> vector<4xi64>
  %94 = "llvm.insertelement"(%93, %88, %85) : (vector<4xi64>, i64, i32) -> vector<4xi64>
  %95 = "llvm.alloca"(%79) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %96 = "llvm.alloca"(%79) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %97 = "llvm.alloca"(%79) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %98 = "llvm.alloca"(%79) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %99 = "llvm.alloca"(%79) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %100 = "llvm.alloca"(%79) <{alignment = 16 : i64, elem_type = !llvm.array<5 x i64>}> : (i32) -> !llvm.ptr
  %101 = "llvm.alloca"(%79) <{alignment = 16 : i64, elem_type = !llvm.array<5 x i64>}> : (i32) -> !llvm.ptr
  %102 = "llvm.call"(%arg3, %80, %81, %80, %79) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %103 = "llvm.call"(%arg4, %80, %81, %80, %79) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %104 = "llvm.call"(%arg5, %80, %81, %80, %79) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %105 = "llvm.call"(%arg6, %80, %81, %80, %79) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %106 = "llvm.call"(%arg7, %80, %81, %80, %79) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %107 = "llvm.call"(%arg8, %81, %80, %79, %80) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %108 = "llvm.call"(%arg9, %81, %80, %79, %80) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %109 = "llvm.call"(%arg10, %81, %80, %79, %80) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %110 = "llvm.call"(%arg11, %81, %80, %79, %80) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %111 = "llvm.call"(%arg12, %81, %80, %79, %80) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%95) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%96) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%97) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%98) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%99) : (!llvm.ptr) -> ()
  "llvm.call"(%95, %96, %97, %98, %99, %102, %103, %104, %105, %106, %107, %108, %109, %110, %111) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_mul_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %112 = "llvm.load"(%95) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %113 = "llvm.load"(%96) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %114 = "llvm.load"(%97) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %115 = "llvm.load"(%98) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  %116 = "llvm.load"(%99) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%99) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%98) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%97) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%96) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%95) : (!llvm.ptr) -> ()
  %117 = "llvm.lshr"(%112, %82) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %118 = "llvm.lshr"(%113, %82) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %119 = "llvm.lshr"(%114, %82) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %120 = "llvm.lshr"(%115, %82) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %121 = "llvm.lshr"(%116, %82) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %122 = "llvm.and"(%112, %83) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %123 = "llvm.call_intrinsic"(%122, %121, %84) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %124 = "llvm.and"(%113, %83) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %125 = "llvm.add"(%124, %117) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %126 = "llvm.and"(%114, %83) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %127 = "llvm.add"(%126, %118) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %128 = "llvm.and"(%115, %83) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %129 = "llvm.add"(%128, %119) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %130 = "llvm.and"(%116, %83) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %131 = "llvm.add"(%130, %120) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %132 = "llvm.call"(%123, %79, %81, %85, %80) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %133 = "llvm.call"(%125, %79, %81, %85, %80) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %134 = "llvm.call"(%127, %79, %81, %85, %80) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %135 = "llvm.call"(%129, %79, %81, %85, %80) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %136 = "llvm.call"(%131, %79, %81, %85, %80) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %137 = "llvm.sub"(%132, %123) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %138 = "llvm.add"(%137, %86) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %139 = "llvm.sub"(%133, %125) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %140 = "llvm.add"(%139, %87) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %141 = "llvm.sub"(%134, %127) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %142 = "llvm.add"(%141, %87) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %143 = "llvm.sub"(%135, %129) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %144 = "llvm.add"(%143, %87) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %145 = "llvm.sub"(%136, %131) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %146 = "llvm.add"(%145, %87) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %147 = "llvm.lshr"(%138, %82) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %148 = "llvm.lshr"(%140, %82) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %149 = "llvm.lshr"(%142, %82) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %150 = "llvm.lshr"(%144, %82) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %151 = "llvm.lshr"(%146, %82) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %152 = "llvm.and"(%138, %83) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %153 = "llvm.call_intrinsic"(%152, %151, %84) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.256", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %154 = "llvm.and"(%140, %94) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %155 = "llvm.add"(%154, %147) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %156 = "llvm.and"(%142, %94) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %157 = "llvm.add"(%156, %148) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %158 = "llvm.and"(%144, %94) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %159 = "llvm.add"(%158, %149) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %160 = "llvm.and"(%146, %94) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %161 = "llvm.add"(%160, %150) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%100) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%101) : (!llvm.ptr) -> ()
  %162 = "llvm.getelementptr"(%100) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %163 = "llvm.shufflevector"(%153, %155) <{mask = array<i32: 0, 4>}> : (vector<4xi64>, vector<4xi64>) -> vector<2xi64>
  "llvm.store"(%163, %100) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (vector<2xi64>, !llvm.ptr) -> ()
  %164 = "llvm.shufflevector"(%153, %155) <{mask = array<i32: 2, 6>}> : (vector<4xi64>, vector<4xi64>) -> vector<2xi64>
  "llvm.store"(%164, %101) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (vector<2xi64>, !llvm.ptr) -> ()
  %165 = "llvm.getelementptr"(%100) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %166 = "llvm.getelementptr"(%101) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %167 = "llvm.getelementptr"(%100) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %168 = "llvm.shufflevector"(%157, %159) <{mask = array<i32: 0, 4>}> : (vector<4xi64>, vector<4xi64>) -> vector<2xi64>
  "llvm.store"(%168, %165) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (vector<2xi64>, !llvm.ptr) -> ()
  %169 = "llvm.shufflevector"(%157, %159) <{mask = array<i32: 2, 6>}> : (vector<4xi64>, vector<4xi64>) -> vector<2xi64>
  "llvm.store"(%169, %166) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (vector<2xi64>, !llvm.ptr) -> ()
  %170 = "llvm.extractelement"(%161, %78) : (vector<4xi64>, i64) -> i64
  %171 = "llvm.getelementptr"(%100) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%170, %171) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (i64, !llvm.ptr) -> ()
  %172 = "llvm.extractelement"(%161, %77) : (vector<4xi64>, i64) -> i64
  %173 = "llvm.getelementptr"(%101) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%172, %173) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (i64, !llvm.ptr) -> ()
  "llvm.call"(%100) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}], callee = @fd_r52x5_reduce, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> ()
  "llvm.call"(%101) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}], callee = @fd_r52x5_reduce, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> ()
  %174 = "llvm.load"(%100) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %175 = "llvm.load"(%167) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %176 = "llvm.load"(%171) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %177 = "llvm.load"(%162) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> vector<2xi64>
  %178 = "llvm.load"(%101) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> vector<4xi64>
  %179 = "llvm.load"(%173) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %180 = "llvm.insertelement"(%76, %179, %75) : (vector<8xi64>, i64, i64) -> vector<8xi64>
  %181 = "llvm.insertelement"(%180, %174, %74) : (vector<8xi64>, i64, i64) -> vector<8xi64>
  %182 = "llvm.shufflevector"(%178, %73) <{mask = array<i32: 0, 1, 2, 3, -1, -1, -1, -1>}> : (vector<4xi64>, vector<4xi64>) -> vector<8xi64>
  %183 = "llvm.shufflevector"(%182, %181) <{mask = array<i32: 0, 1, 2, 3, 12, 13, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %184 = "llvm.shufflevector"(%177, %72) <{mask = array<i32: 0, 1, -1, -1, -1, -1, -1, -1>}> : (vector<2xi64>, vector<2xi64>) -> vector<8xi64>
  %185 = "llvm.shufflevector"(%183, %184) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 8, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %186 = "llvm.intr.vector.reduce.or"(%185) : (vector<8xi64>) -> i64
  %187 = "llvm.or"(%186, %175) : (i64, i64) -> i64
  %188 = "llvm.or"(%187, %176) : (i64, i64) -> i64
  %189 = "llvm.icmp"(%188, %78) <{predicate = 0 : i64}> : (i64, i64) -> i1
  %190 = "llvm.zext"(%189) : (i1) -> i32
  "llvm.intr.lifetime.end"(%101) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%100) : (!llvm.ptr) -> ()
  "llvm.return"(%190) : (i32) -> ()
}) : () -> ()
  with @fd_r52x5_quad_mul_fast := fd_r52x5_quad_mul_fast, @fd_r52x5_reduce := fd_r52x5_reduce,
    @wl_permute := wl_permute

end

end MLIR.Firedancer.R52x5
