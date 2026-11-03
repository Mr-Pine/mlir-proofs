module

-- crc/out/mlirproofs/regions/verify/fd_r52x5_quad_ge_add.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_quad_add_nc
public import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_quad_mul
public import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_quad_negate_lazy
public import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_quad_reduce
public import Firedancer.Crc.Ed25519.Avx512.Mlir.wl_permute

meta import MLIR.Semantics.Func
meta import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_quad_add_nc
meta import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_quad_mul
meta import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_quad_negate_lazy
meta import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_quad_reduce
meta import Firedancer.Crc.Ed25519.Avx512.Mlir.wl_permute

namespace MLIR.Firedancer.Crc.Ed25519.Avx512

@[expose] public section

mlir_def fd_r52x5_quad_ge_add :=
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nocapture, llvm.nonnull, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nonnull, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nonnull, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nonnull, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nonnull, llvm.noundef, llvm.writeonly}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<void (ptr, ptr, ptr, ptr, ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", "sspstrong", ["min-legal-vector-width", "256"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "icelake-server"]], sym_name = "fd_r52x5_quad_ge_add", target_cpu = "icelake-server", target_features = #llvm.target_features<["+adx", "+aes", "+avx", "+avx2", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+pclmul", "+pconfig", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdrnd", "+rdseed", "+sahf", "+sgx", "+sha", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves"]>, tune_cpu = "icelake-server", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg35: !llvm.ptr, %arg36: !llvm.ptr, %arg37: !llvm.ptr, %arg38: !llvm.ptr, %arg39: !llvm.ptr, %arg40: vector<4xi64>, %arg41: vector<4xi64>, %arg42: vector<4xi64>, %arg43: vector<4xi64>, %arg44: vector<4xi64>, %arg45: vector<4xi64>, %arg46: vector<4xi64>, %arg47: vector<4xi64>, %arg48: vector<4xi64>, %arg49: vector<4xi64>):
  %30 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %31 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %32 = "llvm.mlir.constant"() <{value = 3 : i32}> : () -> i32
  %33 = "llvm.mlir.constant"() <{value = 2 : i32}> : () -> i32
  %34 = "llvm.mlir.constant"() <{value = dense<[1, 1, 2, 1859910466990425]> : vector<4xi64>}> : () -> vector<4xi64>
  %35 = "llvm.mlir.constant"() <{value = dense<[0, 0, 0, 932731440258426]> : vector<4xi64>}> : () -> vector<4xi64>
  %36 = "llvm.mlir.constant"() <{value = dense<[0, 0, 0, 1072319116312658]> : vector<4xi64>}> : () -> vector<4xi64>
  %37 = "llvm.mlir.constant"() <{value = dense<[0, 0, 0, 1815898335770999]> : vector<4xi64>}> : () -> vector<4xi64>
  %38 = "llvm.mlir.constant"() <{value = dense<[0, 0, 0, 633789495995903]> : vector<4xi64>}> : () -> vector<4xi64>
  %39 = "llvm.alloca"(%30) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %40 = "llvm.alloca"(%30) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %41 = "llvm.alloca"(%30) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %42 = "llvm.alloca"(%30) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %43 = "llvm.alloca"(%30) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %44 = "llvm.alloca"(%30) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %45 = "llvm.alloca"(%30) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %46 = "llvm.alloca"(%30) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %47 = "llvm.alloca"(%30) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %48 = "llvm.alloca"(%30) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %49 = "llvm.alloca"(%30) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %50 = "llvm.alloca"(%30) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %51 = "llvm.alloca"(%30) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %52 = "llvm.alloca"(%30) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %53 = "llvm.alloca"(%30) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %54 = "llvm.alloca"(%30) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %55 = "llvm.alloca"(%30) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %56 = "llvm.alloca"(%30) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %57 = "llvm.alloca"(%30) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %58 = "llvm.alloca"(%30) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %59 = "llvm.alloca"(%30) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %60 = "llvm.alloca"(%30) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %61 = "llvm.alloca"(%30) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %62 = "llvm.alloca"(%30) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %63 = "llvm.alloca"(%30) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %64 = "llvm.alloca"(%30) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %65 = "llvm.alloca"(%30) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %66 = "llvm.alloca"(%30) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %67 = "llvm.alloca"(%30) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %68 = "llvm.alloca"(%30) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %69 = "llvm.alloca"(%30) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %70 = "llvm.alloca"(%30) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %71 = "llvm.alloca"(%30) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %72 = "llvm.alloca"(%30) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %73 = "llvm.alloca"(%30) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %74 = "llvm.alloca"(%30) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %75 = "llvm.alloca"(%30) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %76 = "llvm.alloca"(%30) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %77 = "llvm.alloca"(%30) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %78 = "llvm.alloca"(%30) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %79 = "llvm.alloca"(%30) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %80 = "llvm.alloca"(%30) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %81 = "llvm.alloca"(%30) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %82 = "llvm.alloca"(%30) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %83 = "llvm.alloca"(%30) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %84 = "llvm.alloca"(%30) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %85 = "llvm.alloca"(%30) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %86 = "llvm.alloca"(%30) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %87 = "llvm.alloca"(%30) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %88 = "llvm.alloca"(%30) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %89 = "llvm.alloca"(%30) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %90 = "llvm.alloca"(%30) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %91 = "llvm.alloca"(%30) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %92 = "llvm.alloca"(%30) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %93 = "llvm.alloca"(%30) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %94 = "llvm.alloca"(%30) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %95 = "llvm.alloca"(%30) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %96 = "llvm.alloca"(%30) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %97 = "llvm.alloca"(%30) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %98 = "llvm.alloca"(%30) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %99 = "llvm.call"(%arg45, %30, %31, %32, %33) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %100 = "llvm.call"(%arg46, %30, %31, %32, %33) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %101 = "llvm.call"(%arg47, %30, %31, %32, %33) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %102 = "llvm.call"(%arg48, %30, %31, %32, %33) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %103 = "llvm.call"(%arg49, %30, %31, %32, %33) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%39) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%40) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%41) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%42) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%43) : (!llvm.ptr) -> ()
  "llvm.call"(%39, %40, %41, %42, %43, %arg45, %arg46, %arg47, %arg48, %arg49) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_negate_lazy, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %104 = "llvm.load"(%39) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %105 = "llvm.load"(%40) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %106 = "llvm.load"(%41) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %107 = "llvm.load"(%42) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %108 = "llvm.load"(%43) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%43) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%42) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%41) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%40) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%39) : (!llvm.ptr) -> ()
  %109 = "llvm.shufflevector"(%104, %arg45) <{mask = array<i32: 0, 5, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %110 = "llvm.shufflevector"(%105, %arg46) <{mask = array<i32: 0, 5, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %111 = "llvm.shufflevector"(%106, %arg47) <{mask = array<i32: 0, 5, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %112 = "llvm.shufflevector"(%107, %arg48) <{mask = array<i32: 0, 5, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %113 = "llvm.shufflevector"(%108, %arg49) <{mask = array<i32: 0, 5, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%44) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%45) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%46) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%47) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%48) : (!llvm.ptr) -> ()
  "llvm.call"(%44, %45, %46, %47, %48, %99, %100, %101, %102, %103, %109, %110, %111, %112, %113) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_add_nc, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %114 = "llvm.load"(%44) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %115 = "llvm.load"(%45) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %116 = "llvm.load"(%46) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %117 = "llvm.load"(%47) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %118 = "llvm.load"(%48) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%48) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%47) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%46) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%45) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%44) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%49) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%50) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%51) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%52) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%53) : (!llvm.ptr) -> ()
  "llvm.call"(%49, %50, %51, %52, %53, %114, %115, %116, %117, %118) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_reduce, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %119 = "llvm.load"(%49) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %120 = "llvm.load"(%50) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %121 = "llvm.load"(%51) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %122 = "llvm.load"(%52) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %123 = "llvm.load"(%53) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%53) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%52) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%51) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%50) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%49) : (!llvm.ptr) -> ()
  %124 = "llvm.shufflevector"(%119, %arg45) <{mask = array<i32: 0, 1, 6, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %125 = "llvm.shufflevector"(%120, %arg46) <{mask = array<i32: 0, 1, 6, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %126 = "llvm.shufflevector"(%121, %arg47) <{mask = array<i32: 0, 1, 6, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %127 = "llvm.shufflevector"(%122, %arg48) <{mask = array<i32: 0, 1, 6, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %128 = "llvm.shufflevector"(%123, %arg49) <{mask = array<i32: 0, 1, 6, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%54) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%55) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%56) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%57) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%58) : (!llvm.ptr) -> ()
  "llvm.call"(%54, %55, %56, %57, %58, %124, %125, %126, %127, %128, %34, %35, %36, %37, %38) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %129 = "llvm.load"(%54) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %130 = "llvm.load"(%55) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %131 = "llvm.load"(%56) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %132 = "llvm.load"(%57) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %133 = "llvm.load"(%58) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%58) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%57) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%56) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%55) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%54) : (!llvm.ptr) -> ()
  %134 = "llvm.call"(%arg40, %30, %31, %32, %33) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %135 = "llvm.call"(%arg41, %30, %31, %32, %33) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %136 = "llvm.call"(%arg42, %30, %31, %32, %33) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %137 = "llvm.call"(%arg43, %30, %31, %32, %33) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %138 = "llvm.call"(%arg44, %30, %31, %32, %33) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%59) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%60) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%61) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%62) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%63) : (!llvm.ptr) -> ()
  "llvm.call"(%59, %60, %61, %62, %63, %arg40, %arg41, %arg42, %arg43, %arg44) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_negate_lazy, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %139 = "llvm.load"(%59) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %140 = "llvm.load"(%60) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %141 = "llvm.load"(%61) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %142 = "llvm.load"(%62) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %143 = "llvm.load"(%63) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%63) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%62) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%61) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%60) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%59) : (!llvm.ptr) -> ()
  %144 = "llvm.shufflevector"(%139, %arg40) <{mask = array<i32: 0, 5, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %145 = "llvm.shufflevector"(%140, %arg41) <{mask = array<i32: 0, 5, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %146 = "llvm.shufflevector"(%141, %arg42) <{mask = array<i32: 0, 5, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %147 = "llvm.shufflevector"(%142, %arg43) <{mask = array<i32: 0, 5, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %148 = "llvm.shufflevector"(%143, %arg44) <{mask = array<i32: 0, 5, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%64) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%65) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%66) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%67) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%68) : (!llvm.ptr) -> ()
  "llvm.call"(%64, %65, %66, %67, %68, %134, %135, %136, %137, %138, %144, %145, %146, %147, %148) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_add_nc, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %149 = "llvm.load"(%64) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %150 = "llvm.load"(%65) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %151 = "llvm.load"(%66) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %152 = "llvm.load"(%67) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %153 = "llvm.load"(%68) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%68) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%67) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%66) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%65) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%64) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%69) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%70) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%71) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%72) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%73) : (!llvm.ptr) -> ()
  "llvm.call"(%69, %70, %71, %72, %73, %149, %150, %151, %152, %153) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_reduce, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %154 = "llvm.load"(%69) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %155 = "llvm.load"(%70) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %156 = "llvm.load"(%71) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %157 = "llvm.load"(%72) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %158 = "llvm.load"(%73) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%73) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%72) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%71) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%70) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%69) : (!llvm.ptr) -> ()
  %159 = "llvm.shufflevector"(%154, %arg40) <{mask = array<i32: 0, 1, 6, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %160 = "llvm.shufflevector"(%155, %arg41) <{mask = array<i32: 0, 1, 6, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %161 = "llvm.shufflevector"(%156, %arg42) <{mask = array<i32: 0, 1, 6, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %162 = "llvm.shufflevector"(%157, %arg43) <{mask = array<i32: 0, 1, 6, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %163 = "llvm.shufflevector"(%158, %arg44) <{mask = array<i32: 0, 1, 6, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%74) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%75) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%76) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%77) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%78) : (!llvm.ptr) -> ()
  "llvm.call"(%74, %75, %76, %77, %78, %159, %160, %161, %162, %163, %129, %130, %131, %132, %133) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %164 = "llvm.load"(%74) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %165 = "llvm.load"(%75) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %166 = "llvm.load"(%76) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %167 = "llvm.load"(%77) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %168 = "llvm.load"(%78) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%78) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%77) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%76) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%75) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%74) : (!llvm.ptr) -> ()
  %169 = "llvm.call"(%164, %31, %30, %32, %33) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %170 = "llvm.call"(%165, %31, %30, %32, %33) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %171 = "llvm.call"(%166, %31, %30, %32, %33) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %172 = "llvm.call"(%167, %31, %30, %32, %33) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %173 = "llvm.call"(%168, %31, %30, %32, %33) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %174 = "llvm.call"(%169, %30, %31, %32, %33) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %175 = "llvm.call"(%170, %30, %31, %32, %33) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %176 = "llvm.call"(%171, %30, %31, %32, %33) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %177 = "llvm.call"(%172, %30, %31, %32, %33) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %178 = "llvm.call"(%173, %30, %31, %32, %33) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%79) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%80) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%81) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%82) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%83) : (!llvm.ptr) -> ()
  "llvm.call"(%79, %80, %81, %82, %83, %169, %170, %171, %172, %173) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_negate_lazy, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %179 = "llvm.load"(%79) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %180 = "llvm.load"(%80) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %181 = "llvm.load"(%81) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %182 = "llvm.load"(%82) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %183 = "llvm.load"(%83) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%83) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%82) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%81) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%80) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%79) : (!llvm.ptr) -> ()
  %184 = "llvm.shufflevector"(%179, %169) <{mask = array<i32: 0, 5, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %185 = "llvm.shufflevector"(%180, %170) <{mask = array<i32: 0, 5, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %186 = "llvm.shufflevector"(%181, %171) <{mask = array<i32: 0, 5, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %187 = "llvm.shufflevector"(%182, %172) <{mask = array<i32: 0, 5, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %188 = "llvm.shufflevector"(%183, %173) <{mask = array<i32: 0, 5, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%84) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%85) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%86) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%87) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%88) : (!llvm.ptr) -> ()
  "llvm.call"(%84, %85, %86, %87, %88, %174, %175, %176, %177, %178, %184, %185, %186, %187, %188) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_add_nc, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %189 = "llvm.load"(%84) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %190 = "llvm.load"(%85) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %191 = "llvm.load"(%86) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %192 = "llvm.load"(%87) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %193 = "llvm.load"(%88) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%88) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%87) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%86) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%85) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%84) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%89) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%90) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%91) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%92) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%93) : (!llvm.ptr) -> ()
  "llvm.call"(%89, %90, %91, %92, %93, %189, %190, %191, %192, %193) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_reduce, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %194 = "llvm.load"(%89) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %195 = "llvm.load"(%90) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %196 = "llvm.load"(%91) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %197 = "llvm.load"(%92) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %198 = "llvm.load"(%93) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%93) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%92) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%91) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%90) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%89) : (!llvm.ptr) -> ()
  %199 = "llvm.call"(%194, %31, %32, %32, %31) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %200 = "llvm.call"(%195, %31, %32, %32, %31) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %201 = "llvm.call"(%196, %31, %32, %32, %31) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %202 = "llvm.call"(%197, %31, %32, %32, %31) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %203 = "llvm.call"(%198, %31, %32, %32, %31) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %204 = "llvm.call"(%194, %33, %30, %33, %30) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %205 = "llvm.call"(%195, %33, %30, %33, %30) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %206 = "llvm.call"(%196, %33, %30, %33, %30) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %207 = "llvm.call"(%197, %33, %30, %33, %30) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %208 = "llvm.call"(%198, %33, %30, %33, %30) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%94) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%95) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%96) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%97) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%98) : (!llvm.ptr) -> ()
  "llvm.call"(%94, %95, %96, %97, %98, %199, %200, %201, %202, %203, %204, %205, %206, %207, %208) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %209 = "llvm.load"(%94) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %210 = "llvm.load"(%95) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %211 = "llvm.load"(%96) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %212 = "llvm.load"(%97) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %213 = "llvm.load"(%98) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%98) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%97) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%96) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%95) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%94) : (!llvm.ptr) -> ()
  "llvm.store"(%209, %arg35) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  "llvm.store"(%210, %arg36) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  "llvm.store"(%211, %arg37) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  "llvm.store"(%212, %arg38) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  "llvm.store"(%213, %arg39) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()
  with @fd_r52x5_quad_add_nc := fd_r52x5_quad_add_nc, @fd_r52x5_quad_mul := fd_r52x5_quad_mul,
    @fd_r52x5_quad_negate_lazy := fd_r52x5_quad_negate_lazy,
    @fd_r52x5_quad_reduce := fd_r52x5_quad_reduce, @wl_permute := wl_permute

end

end MLIR.Firedancer.Crc.Ed25519.Avx512
