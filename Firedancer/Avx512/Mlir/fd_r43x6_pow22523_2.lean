module

-- build/llvm23/mlir_canonicalized/avx512/op/fd_r43x6_pow22523_2.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Firedancer.Avx512.Mlir.fd_r43x6_repsqr_mul2
public import Firedancer.Avx512.Mlir.fd_r43x6_sqr_fast

meta import MLIR.Semantics.Func
meta import Firedancer.Avx512.Mlir.fd_r43x6_repsqr_mul2
meta import Firedancer.Avx512.Mlir.fd_r43x6_sqr_fast

namespace MLIR.Firedancer.Avx512

@[expose] public section

mlir_def fd_r43x6_pow22523_2 :=
#tbaa_root = #llvm.tbaa_root<id = "Simple C/C++ TBAA">
#tbaa_type_desc = #llvm.tbaa_type_desc<id = "omnipotent char", members = {<#tbaa_root, 0>}>
#tbaa_tag = #llvm.tbaa_tag<base_type = #tbaa_type_desc, access_type = #tbaa_type_desc, offset = 0>
"llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.nocapture, llvm.nofree, llvm.noundef, llvm.writeonly}, {llvm.noundef}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.writeonly}, {llvm.noundef}], dso_local, function_type = !llvm.func<void (ptr, vector<8xi64>, ptr, vector<8xi64>)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["nofree", "norecurse", "nosync", ["min-legal-vector-width", "512"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "icelake-server"]], sym_name = "fd_r43x6_pow22523_2", target_cpu = "icelake-server", target_features = #llvm.target_features<["+adx", "+aes", "+avx", "+avx2", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+pclmul", "+pconfig", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdrnd", "+rdseed", "+sahf", "+sgx", "+sha", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves"]>, unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg35: !llvm.ptr, %arg36: vector<8xi64>, %arg37: !llvm.ptr, %arg38: vector<8xi64>):
  %477 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %478 = "llvm.mlir.constant"() <{value = dense<[8796093022207, 8796093022207, 8796093022207, 8796093022207, 8796093022207, 1099511627775, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %479 = "llvm.mlir.constant"() <{value = dense<[43, 43, 43, 43, 43, 40, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %480 = "llvm.mlir.poison"() : () -> vector<8xi64>
  %481 = "llvm.mlir.constant"() <{value = dense<[19, 1, 1, 1, 1, 1, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %482 = "llvm.mlir.constant"() <{value = 2 : i64}> : () -> i64
  %483 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %484 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %485 = "llvm.mlir.constant"() <{value = 5 : i64}> : () -> i64
  %486 = "llvm.mlir.constant"() <{value = 10 : i64}> : () -> i64
  %487 = "llvm.mlir.constant"() <{value = 20 : i64}> : () -> i64
  %488 = "llvm.mlir.constant"() <{value = 50 : i64}> : () -> i64
  %489 = "llvm.mlir.constant"() <{value = 100 : i64}> : () -> i64
  %490 = "llvm.alloca"(%477) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %491 = "llvm.alloca"(%477) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %492 = "llvm.alloca"(%477) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %493 = "llvm.alloca"(%477) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %494 = "llvm.alloca"(%477) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %495 = "llvm.alloca"(%477) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %496 = "llvm.alloca"(%477) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %497 = "llvm.alloca"(%477) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %498 = "llvm.alloca"(%477) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %499 = "llvm.alloca"(%477) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %500 = "llvm.alloca"(%477) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %501 = "llvm.alloca"(%477) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %502 = "llvm.alloca"(%477) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %503 = "llvm.alloca"(%477) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %504 = "llvm.alloca"(%477) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %505 = "llvm.alloca"(%477) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %506 = "llvm.alloca"(%477) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %507 = "llvm.alloca"(%477) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %508 = "llvm.alloca"(%477) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %509 = "llvm.alloca"(%477) <{alignment = 64 : i64, elem_type = vector<8xi64>}> : (i32) -> !llvm.ptr
  %510 = "llvm.call"(%arg36) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @fd_r43x6_sqr_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (vector<8xi64>) -> vector<8xi64>
  %511 = "llvm.and"(%510, %478) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %512 = "llvm.lshr"(%510, %479) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %513 = "llvm.shufflevector"(%512, %480) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %514 = "llvm.call_intrinsic"(%511, %481, %513) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %515 = "llvm.call"(%arg38) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @fd_r43x6_sqr_fast, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (vector<8xi64>) -> vector<8xi64>
  %516 = "llvm.and"(%515, %478) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %517 = "llvm.lshr"(%515, %479) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %518 = "llvm.shufflevector"(%517, %480) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %519 = "llvm.call_intrinsic"(%516, %481, %518) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.intr.lifetime.start"(%490) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%491) : (!llvm.ptr) -> ()
  "llvm.call"(%490, %514, %arg36, %491, %519, %arg38, %482) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_repsqr_mul2, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 7, 0>}> : (!llvm.ptr, vector<8xi64>, vector<8xi64>, !llvm.ptr, vector<8xi64>, vector<8xi64>, i64) -> ()
  "llvm.intr.lifetime.start"(%492) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%493) : (!llvm.ptr) -> ()
  %520 = "llvm.load"(%490) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %521 = "llvm.load"(%491) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  "llvm.call"(%492, %520, %514, %493, %521, %519, %483) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_repsqr_mul2, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 7, 0>}> : (!llvm.ptr, vector<8xi64>, vector<8xi64>, !llvm.ptr, vector<8xi64>, vector<8xi64>, i64) -> ()
  "llvm.intr.lifetime.start"(%494) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%495) : (!llvm.ptr) -> ()
  %522 = "llvm.load"(%492) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %523 = "llvm.load"(%493) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  "llvm.call"(%494, %522, %520, %495, %523, %521, %484) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_repsqr_mul2, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 7, 0>}> : (!llvm.ptr, vector<8xi64>, vector<8xi64>, !llvm.ptr, vector<8xi64>, vector<8xi64>, i64) -> ()
  "llvm.intr.lifetime.start"(%496) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%497) : (!llvm.ptr) -> ()
  %524 = "llvm.load"(%494) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %525 = "llvm.load"(%495) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  "llvm.call"(%496, %524, %524, %497, %525, %525, %485) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_repsqr_mul2, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 7, 0>}> : (!llvm.ptr, vector<8xi64>, vector<8xi64>, !llvm.ptr, vector<8xi64>, vector<8xi64>, i64) -> ()
  "llvm.intr.lifetime.start"(%498) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%499) : (!llvm.ptr) -> ()
  %526 = "llvm.load"(%496) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %527 = "llvm.load"(%497) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  "llvm.call"(%498, %526, %526, %499, %527, %527, %486) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_repsqr_mul2, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 7, 0>}> : (!llvm.ptr, vector<8xi64>, vector<8xi64>, !llvm.ptr, vector<8xi64>, vector<8xi64>, i64) -> ()
  "llvm.intr.lifetime.start"(%500) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%501) : (!llvm.ptr) -> ()
  %528 = "llvm.load"(%498) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %529 = "llvm.load"(%499) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  "llvm.call"(%500, %528, %528, %501, %529, %529, %487) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_repsqr_mul2, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 7, 0>}> : (!llvm.ptr, vector<8xi64>, vector<8xi64>, !llvm.ptr, vector<8xi64>, vector<8xi64>, i64) -> ()
  "llvm.intr.lifetime.start"(%502) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%503) : (!llvm.ptr) -> ()
  %530 = "llvm.load"(%500) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %531 = "llvm.load"(%501) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  "llvm.call"(%502, %530, %526, %503, %531, %527, %486) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_repsqr_mul2, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 7, 0>}> : (!llvm.ptr, vector<8xi64>, vector<8xi64>, !llvm.ptr, vector<8xi64>, vector<8xi64>, i64) -> ()
  "llvm.intr.lifetime.start"(%504) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%505) : (!llvm.ptr) -> ()
  %532 = "llvm.load"(%502) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %533 = "llvm.load"(%503) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  "llvm.call"(%504, %532, %532, %505, %533, %533, %488) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_repsqr_mul2, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 7, 0>}> : (!llvm.ptr, vector<8xi64>, vector<8xi64>, !llvm.ptr, vector<8xi64>, vector<8xi64>, i64) -> ()
  "llvm.intr.lifetime.start"(%506) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%507) : (!llvm.ptr) -> ()
  %534 = "llvm.load"(%504) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %535 = "llvm.load"(%505) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  "llvm.call"(%506, %534, %534, %507, %535, %535, %489) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_repsqr_mul2, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 7, 0>}> : (!llvm.ptr, vector<8xi64>, vector<8xi64>, !llvm.ptr, vector<8xi64>, vector<8xi64>, i64) -> ()
  "llvm.intr.lifetime.start"(%508) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%509) : (!llvm.ptr) -> ()
  %536 = "llvm.load"(%506) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %537 = "llvm.load"(%507) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  "llvm.call"(%508, %536, %532, %509, %537, %533, %488) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_repsqr_mul2, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 7, 0>}> : (!llvm.ptr, vector<8xi64>, vector<8xi64>, !llvm.ptr, vector<8xi64>, vector<8xi64>, i64) -> ()
  %538 = "llvm.load"(%508) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %539 = "llvm.load"(%509) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  "llvm.call"(%arg35, %538, %arg36, %arg37, %539, %arg38, %482) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r43x6_repsqr_mul2, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 7, 0>}> : (!llvm.ptr, vector<8xi64>, vector<8xi64>, !llvm.ptr, vector<8xi64>, vector<8xi64>, i64) -> ()
  "llvm.intr.lifetime.end"(%509) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%508) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%507) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%506) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%505) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%504) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%503) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%502) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%501) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%500) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%499) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%498) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%497) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%496) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%495) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%494) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%493) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%492) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%491) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%490) : (!llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()
  with @fd_r43x6_repsqr_mul2 := fd_r43x6_repsqr_mul2, @fd_r43x6_sqr_fast := fd_r43x6_sqr_fast

end

end MLIR.Firedancer.Avx512
