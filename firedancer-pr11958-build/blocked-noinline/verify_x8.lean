
module

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

public import Firedancer.LaneNI.Mlir.verify_x8_identity
public import Firedancer.LaneNI.Mlir.fd_curve25519_scalar_validate
public import Firedancer.LaneNI.Mlir.fd_ed25519_lane_decode2
public import Firedancer.LaneNI.Mlir.fd_ed25519_lane_small_order
public import Firedancer.LaneNI.Mlir.fd_ed25519_lane_small_order
public import Firedancer.LaneNI.Mlir.fd_sha512_batch_init
public import Firedancer.LaneNI.Mlir.fd_sha512_batch_fini
public import Firedancer.LaneNI.Mlir.fd_memcpy
public import Firedancer.LaneNI.Mlir.fd_memcpy
public import Firedancer.LaneNI.Mlir.fd_memcpy
public import Firedancer.LaneNI.Mlir.fd_sha512_batch_add
public import Firedancer.LaneNI.Mlir.fd_sha512_init
public import Firedancer.LaneNI.Mlir.fd_sha512_append
public import Firedancer.LaneNI.Mlir.fd_sha512_append
public import Firedancer.LaneNI.Mlir.fd_sha512_append
public import Firedancer.LaneNI.Mlir.fd_sha512_fini
public import Firedancer.LaneNI.Mlir.fd_curve25519_scalar_reduce
public import Firedancer.LaneNI.Mlir.fd_memcpy
public import Firedancer.LaneNI.Mlir.fd_ed25519_lane_verify

namespace Firedancer.LaneNI.Mlir

@[expose] public section

noncomputable mlir_def verify_x8 (batch : MLIR.Vals [.bv 64, .ptr, .ptr, .ptr] → MLIR.EffectM (MLIR.Vals [])) := "llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.writeonly}, {llvm.noundef, llvm.range = #llvm.constant_range<i64, 3, 0>}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<void (ptr, ptr, ptr, ptr, ptr, ptr, i64)>, linkage = #llvm.linkage<internal>, no_inline, no_unwind, passthrough = ["sspstrong", ["min-legal-vector-width", "512"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "znver4"]], sym_name = "verify_x8", target_cpu = "znver4", target_features = #llvm.target_features<["+64bit", "+adx", "+aes", "+avx", "+avx2", "+avx512bf16", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+clzero", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fast-vector-fsqrt", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+mwaitx", "+pclmul", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdpru", "+rdrnd", "+rdseed", "+sahf", "+sha", "+shstk", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+sse4a", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tile", "-avx10.1", "-avx10.2", "-avx512bmm", "-avx512fp16", "-avx512vp2intersect", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-ccmp", "-cf", "-cldemote", "-cmpccxadd", "-egpr", "-enqcmd", "-fma4", "-hreset", "-jmpabs", "-kl", "-lwp", "-movdir64b", "-movdiri", "-movrs", "-ndd", "-nf", "-pconfig", "-ppx", "-prefetchi", "-ptwrite", "-push2pop2", "-raoint", "-rtm", "-serialize", "-sgx", "-sha512", "-sm3", "-sm4", "-tbm", "-tsxldtrk", "-uintr", "-usermsr", "-waitpkg", "-widekl", "-xop", "-zu"]>, tune_cpu = "znver4", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg0: !llvm.ptr, %arg1: !llvm.ptr, %arg2: !llvm.ptr, %arg3: !llvm.ptr, %arg4: !llvm.ptr, %arg5: !llvm.ptr, %arg6: i64):
  %0 = "llvm.mlir.constant"() <{value = -3 : i32}> : () -> i32
  %1 = "llvm.mlir.constant"() <{value = dense<4> : vector<4xi32>}> : () -> vector<4xi32>
  %2 = "llvm.mlir.constant"() <{value = dense<-3> : vector<4xi32>}> : () -> vector<4xi32>
  %3 = "llvm.mlir.constant"() <{value = dense<0> : vector<4xi32>}> : () -> vector<4xi32>
  %4 = "llvm.mlir.constant"() <{value = dense<1> : vector<4xi32>}> : () -> vector<4xi32>
  %5 = "llvm.mlir.constant"() <{value = dense<[0, 1, 2, 3]> : vector<4xi32>}> : () -> vector<4xi32>
  %6 = "llvm.mlir.poison"() : () -> vector<4xi32>
  %7 = "llvm.mlir.constant"() <{value = -4 : i64}> : () -> i64
  %8 = "llvm.mlir.constant"() <{value = dense<-3> : vector<16xi32>}> : () -> vector<16xi32>
  %9 = "llvm.mlir.constant"() <{value = 12 : i64}> : () -> i64
  %10 = "llvm.mlir.constant"() <{value = 4 : i64}> : () -> i64
  %11 = "llvm.mlir.constant"() <{value = dense<19> : vector<8xi64>}> : () -> vector<8xi64>
  %12 = "llvm.mlir.constant"() <{value = dense<2251799813685247> : vector<8xi64>}> : () -> vector<8xi64>
  %13 = "llvm.mlir.constant"() <{value = dense<51> : vector<8xi64>}> : () -> vector<8xi64>
  %14 = "llvm.mlir.constant"() <{value = 5 : i64}> : () -> i64
  %15 = "llvm.mlir.constant"() <{value = dense<9007199254740988> : vector<8xi64>}> : () -> vector<8xi64>
  %16 = "llvm.mlir.constant"() <{value = dense<9007199254740916> : vector<8xi64>}> : () -> vector<8xi64>
  %17 = "llvm.mlir.constant"() <{value = 320 : i64}> : () -> i64
  %18 = "llvm.mlir.constant"() <{value = 64 : i64}> : () -> i64
  %19 = "llvm.mlir.constant"() <{value = 1233 : i64}> : () -> i64
  %20 = "llvm.mlir.constant"() <{value = -2 : i32}> : () -> i32
  %21 = "llvm.mlir.constant"() <{value = dense<8> : vector<8xi32>}> : () -> vector<8xi32>
  %22 = "llvm.mlir.constant"() <{value = dense<-1> : vector<8xi32>}> : () -> vector<8xi32>
  %23 = "llvm.mlir.constant"() <{value = dense<-2> : vector<8xi32>}> : () -> vector<8xi32>
  %24 = "llvm.mlir.constant"() <{value = dense<false> : vector<8xi1>}> : () -> vector<8xi1>
  %25 = "llvm.mlir.constant"() <{value = dense<true> : vector<8xi1>}> : () -> vector<8xi1>
  %26 = "llvm.mlir.constant"() <{value = dense<0> : vector<8xi32>}> : () -> vector<8xi32>
  %27 = "llvm.mlir.constant"() <{value = dense<1> : vector<8xi32>}> : () -> vector<8xi32>
  %28 = "llvm.mlir.constant"() <{value = dense<[0, 1, 2, 3, 4, 5, 6, 7]> : vector<8xi32>}> : () -> vector<8xi32>
  %29 = "llvm.mlir.poison"() : () -> vector<8xi32>
  %30 = "llvm.mlir.constant"() <{value = 7 : i32}> : () -> i32
  %31 = "llvm.mlir.constant"() <{value = 6 : i32}> : () -> i32
  %32 = "llvm.mlir.constant"() <{value = 5 : i32}> : () -> i32
  %33 = "llvm.mlir.constant"() <{value = 4 : i32}> : () -> i32
  %34 = "llvm.mlir.constant"() <{value = 3 : i32}> : () -> i32
  %35 = "llvm.mlir.constant"() <{value = 2 : i32}> : () -> i32
  %36 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %37 = "llvm.mlir.constant"() <{value = 0 : i8}> : () -> i8
  %38 = "llvm.mlir.constant"() <{value = 256 : i64}> : () -> i64
  %39 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %40 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %41 = "llvm.mlir.addressof"() <{global_name = @verify_x8.identity}> : () -> !llvm.ptr
  %42 = "llvm.mlir.constant"() <{value = -1 : i32}> : () -> i32
  %43 = "llvm.mlir.constant"() <{value = 32 : i64}> : () -> i64
  %44 = "llvm.mlir.zero"() : () -> !llvm.ptr
  %45 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %46 = "llvm.mlir.constant"() <{value = 8 : i64}> : () -> i64
  %47 = "llvm.mlir.constant"() <{value = 16 : i64}> : () -> i64
  %48 = "llvm.mlir.constant"() <{value = -16 : i64}> : () -> i64
  %49 = "llvm.mlir.poison"() : () -> vector<16xi32>
  %50 = "llvm.mlir.constant"() <{value = dense<0> : vector<16xi32>}> : () -> vector<16xi32>
  %51 = "llvm.mlir.constant"() <{value = dense<[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]> : vector<16xi32>}> : () -> vector<16xi32>
  %52 = "llvm.mlir.constant"() <{value = dense<1> : vector<16xi32>}> : () -> vector<16xi32>
  %53 = "llvm.mlir.constant"() <{value = dense<true> : vector<16xi1>}> : () -> vector<16xi1>
  %54 = "llvm.mlir.constant"() <{value = dense<false> : vector<16xi1>}> : () -> vector<16xi1>
  %55 = "llvm.mlir.constant"() <{value = dense<-2> : vector<16xi32>}> : () -> vector<16xi32>
  %56 = "llvm.mlir.constant"() <{value = dense<-1> : vector<16xi32>}> : () -> vector<16xi32>
  %57 = "llvm.mlir.constant"() <{value = dense<16> : vector<16xi32>}> : () -> vector<16xi32>
  %58 = "llvm.mlir.constant"() <{value = -8 : i64}> : () -> i64
  %59 = "llvm.mlir.poison"() : () -> i32
  %60 = "llvm.mlir.undef"() : () -> vector<8xi32>
  %61 = "llvm.insertelement"(%60, %59, %39) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %62 = "llvm.insertelement"(%61, %39, %36) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %63 = "llvm.insertelement"(%62, %39, %35) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %64 = "llvm.insertelement"(%63, %39, %34) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %65 = "llvm.insertelement"(%64, %39, %33) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %66 = "llvm.insertelement"(%65, %39, %32) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %67 = "llvm.insertelement"(%66, %39, %31) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %68 = "llvm.insertelement"(%67, %39, %30) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %69 = "llvm.alloca"(%36) <{alignment = 16 : i64, elem_type = !llvm.array<8 x ptr>}> : (i32) -> !llvm.ptr
  %70 = "llvm.alloca"(%36) <{alignment = 16 : i64, elem_type = !llvm.array<8 x ptr>}> : (i32) -> !llvm.ptr
  %71 = "llvm.alloca"(%36) <{alignment = 16 : i64, elem_type = !llvm.array<8 x array<32 x i8>>}> : (i32) -> !llvm.ptr
  %72 = "llvm.alloca"(%36) <{alignment = 16 : i64, elem_type = !llvm.array<8 x array<32 x i8>>}> : (i32) -> !llvm.ptr
  %73 = "llvm.alloca"(%36) <{alignment = 64 : i64, elem_type = !llvm.struct<"struct.fd_ed25519_lane_point", (struct<"struct.fd_ed25519_lane_fe", (array<5 x vector<8xi64>>)>, struct<"struct.fd_ed25519_lane_fe", (array<5 x vector<8xi64>>)>, struct<"struct.fd_ed25519_lane_fe", (array<5 x vector<8xi64>>)>, struct<"struct.fd_ed25519_lane_fe", (array<5 x vector<8xi64>>)>)>}> : (i32) -> !llvm.ptr
  %74 = "llvm.alloca"(%36) <{alignment = 64 : i64, elem_type = !llvm.struct<"struct.fd_ed25519_lane_point", (struct<"struct.fd_ed25519_lane_fe", (array<5 x vector<8xi64>>)>, struct<"struct.fd_ed25519_lane_fe", (array<5 x vector<8xi64>>)>, struct<"struct.fd_ed25519_lane_fe", (array<5 x vector<8xi64>>)>, struct<"struct.fd_ed25519_lane_fe", (array<5 x vector<8xi64>>)>)>}> : (i32) -> !llvm.ptr
  %75 = "llvm.alloca"(%36) <{alignment = 4 : i64, elem_type = i32}> : (i32) -> !llvm.ptr
  %76 = "llvm.alloca"(%36) <{alignment = 4 : i64, elem_type = i32}> : (i32) -> !llvm.ptr
  %77 = "llvm.alloca"(%36) <{alignment = 16 : i64, elem_type = !llvm.array<8 x array<1296 x i8>>}> : (i32) -> !llvm.ptr
  %78 = "llvm.alloca"(%36) <{alignment = 16 : i64, elem_type = !llvm.array<8 x array<64 x i8>>}> : (i32) -> !llvm.ptr
  %79 = "llvm.alloca"(%36) <{alignment = 128 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_sha512_private_batch", (array<8 x ptr>, array<8 x i64>, array<8 x ptr>, i64, array<56 x i8>)>>}> : (i32) -> !llvm.ptr
  %80 = "llvm.alloca"(%36) <{alignment = 64 : i64, elem_type = !llvm.struct<"struct.fd_ed25519_lane_fe", (array<5 x vector<8xi64>>)>}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%69) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%70) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%71) : (!llvm.ptr) -> ()
  "llvm.intr.memset"(%71, %37, %38) <{arg_attrs = [{llvm.align = 16 : i64, llvm.dereferenceable = 256 : i64, llvm.nonnull, llvm.noundef}, {}, {}], isVolatile = false}> : (!llvm.ptr, i8, i64) -> ()
  "llvm.intr.lifetime.start"(%72) : (!llvm.ptr) -> ()
  "llvm.intr.memset"(%72, %37, %38) <{arg_attrs = [{llvm.align = 16 : i64, llvm.dereferenceable = 256 : i64, llvm.nonnull, llvm.noundef}, {}, {}], isVolatile = false}> : (!llvm.ptr, i8, i64) -> ()
  "llvm.br"(%39, %40)[^bb2] : (i32, i64) -> ()
^bb1:  // pred: ^bb5
  %81 = "llvm.icmp"(%98, %39) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%81)[^bb57, ^bb6] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb2(%82: i32, %83: i64):  // 2 preds: ^bb0, ^bb5
  %84 = "llvm.getelementptr"(%70, %83) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%41, %84) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 omnipotent char", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 omnipotent char", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr, !llvm.ptr) -> ()
  %85 = "llvm.getelementptr"(%69, %83) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%41, %85) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 omnipotent char", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 omnipotent char", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr, !llvm.ptr) -> ()
  %86 = "llvm.icmp"(%83, %arg6) <{predicate = 6 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%86, %82)[^bb3, ^bb5] <{operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i32) -> ()
^bb3:  // pred: ^bb2
  %87 = "llvm.getelementptr"(%arg5, %83) <{elem_type = !llvm.array<4 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%42, %87) <{alignment = 4 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i32, !llvm.ptr) -> ()
  %88 = "llvm.getelementptr"(%arg2, %83) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %89 = "llvm.load"(%88) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 omnipotent char", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 omnipotent char", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> !llvm.ptr
  %90 = "llvm.getelementptr"(%89) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %91 = "llvm.call"(%90) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.nonnull, llvm.noundef}], callee = @fd_curve25519_scalar_validate, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> !llvm.ptr
  %92 = "llvm.icmp"(%91, %44) <{predicate = 0 : i64}> : (!llvm.ptr, !llvm.ptr) -> i1
  "llvm.cond_br"(%92, %82)[^bb5, ^bb4] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i32) -> ()
^bb4:  // pred: ^bb3
  %93 = "llvm.getelementptr"(%arg3, %83) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %94 = "llvm.load"(%93) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 omnipotent char", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 omnipotent char", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%94, %85) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 omnipotent char", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 omnipotent char", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.store"(%89, %84) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 omnipotent char", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 omnipotent char", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr, !llvm.ptr) -> ()
  %95 = "llvm.trunc"(%83) <{overflowFlags = 3 : i32}> : (i64) -> i32
  %96 = "llvm.shl"(%36, %95) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %97 = "llvm.or"(%96, %82) : (i32, i32) -> i32
  "llvm.br"(%97)[^bb5] : (i32) -> ()
^bb5(%98: i32):  // 3 preds: ^bb2, ^bb3, ^bb4
  %99 = "llvm.add"(%83, %45) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %100 = "llvm.icmp"(%99, %46) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%100, %98, %99)[^bb1, ^bb2] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true>, mustProgress = true>, operandSegmentSizes = array<i32: 1, 0, 2>}> : (i1, i32, i64) -> ()
^bb6:  // pred: ^bb1
  "llvm.intr.lifetime.start"(%73) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%74) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%75) : (!llvm.ptr) -> ()
  "llvm.store"(%39, %75) <{alignment = 4 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i32, !llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%76) : (!llvm.ptr) -> ()
  "llvm.store"(%39, %76) <{alignment = 4 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i32, !llvm.ptr) -> ()
  "llvm.call"(%73, %69, %75, %74, %70, %76) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_lane_decode2, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = readwrite, argMem = readwrite, inaccessibleMem = none, errnoMem = readwrite, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 6, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  %101 = "llvm.call"(%73) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}], callee = @fd_ed25519_lane_small_order, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i32
  %102 = "llvm.call"(%74) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}], callee = @fd_ed25519_lane_small_order, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i32
  %103 = "llvm.load"(%75) <{alignment = 4 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i32
  %104 = "llvm.load"(%76) <{alignment = 4 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i32
  %105 = "llvm.icmp"(%arg6, %46) <{predicate = 6 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%105, %40, %39)[^bb15, ^bb7] <{operandSegmentSizes = array<i32: 1, 2, 0>}> : (i1, i64, i32) -> ()
^bb7:  // pred: ^bb6
  %106 = "llvm.icmp"(%arg6, %47) <{predicate = 6 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%106, %40, %39)[^bb12, ^bb8] <{operandSegmentSizes = array<i32: 1, 2, 0>}> : (i1, i64, i32) -> ()
^bb8:  // pred: ^bb7
  %107 = "llvm.and"(%arg6, %46) : (i64, i64) -> i64
  %108 = "llvm.and"(%arg6, %48) : (i64, i64) -> i64
  %109 = "llvm.insertelement"(%49, %101, %40) : (vector<16xi32>, i32, i64) -> vector<16xi32>
  %110 = "llvm.shufflevector"(%109, %49) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<16xi32>, vector<16xi32>) -> vector<16xi32>
  %111 = "llvm.insertelement"(%49, %102, %40) : (vector<16xi32>, i32, i64) -> vector<16xi32>
  %112 = "llvm.shufflevector"(%111, %49) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<16xi32>, vector<16xi32>) -> vector<16xi32>
  %113 = "llvm.insertelement"(%49, %103, %40) : (vector<16xi32>, i32, i64) -> vector<16xi32>
  %114 = "llvm.shufflevector"(%113, %49) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<16xi32>, vector<16xi32>) -> vector<16xi32>
  %115 = "llvm.insertelement"(%49, %104, %40) : (vector<16xi32>, i32, i64) -> vector<16xi32>
  %116 = "llvm.shufflevector"(%115, %49) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<16xi32>, vector<16xi32>) -> vector<16xi32>
  %117 = "llvm.insertelement"(%49, %98, %40) : (vector<16xi32>, i32, i64) -> vector<16xi32>
  %118 = "llvm.shufflevector"(%117, %49) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<16xi32>, vector<16xi32>) -> vector<16xi32>
  "llvm.br"(%40, %50, %51)[^bb9] : (i64, vector<16xi32>, vector<16xi32>) -> ()
^bb9(%119: i64, %120: vector<16xi32>, %121: vector<16xi32>):  // 2 preds: ^bb8, ^bb9
  %122 = "llvm.shl"(%52, %121) <{overflowFlags = 2 : i32}> : (vector<16xi32>, vector<16xi32>) -> vector<16xi32>
  %123 = "llvm.and"(%122, %118) : (vector<16xi32>, vector<16xi32>) -> vector<16xi32>
  %124 = "llvm.icmp"(%123, %50) <{predicate = 1 : i64}> : (vector<16xi32>, vector<16xi32>) -> vector<16xi1>
  %125 = "llvm.and"(%114, %122) : (vector<16xi32>, vector<16xi32>) -> vector<16xi32>
  %126 = "llvm.icmp"(%125, %50) <{predicate = 0 : i64}> : (vector<16xi32>, vector<16xi32>) -> vector<16xi1>
  %127 = "llvm.xor"(%126, %53) : (vector<16xi1>, vector<16xi1>) -> vector<16xi1>
  %128 = "llvm.select"(%124, %127, %54) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<16xi1>, vector<16xi1>, vector<16xi1>) -> vector<16xi1>
  %129 = "llvm.and"(%116, %122) : (vector<16xi32>, vector<16xi32>) -> vector<16xi32>
  %130 = "llvm.icmp"(%129, %50) <{predicate = 0 : i64}> : (vector<16xi32>, vector<16xi32>) -> vector<16xi1>
  %131 = "llvm.xor"(%130, %53) : (vector<16xi1>, vector<16xi1>) -> vector<16xi1>
  %132 = "llvm.select"(%128, %131, %54) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<16xi1>, vector<16xi1>, vector<16xi1>) -> vector<16xi1>
  %133 = "llvm.and"(%122, %110) : (vector<16xi32>, vector<16xi32>) -> vector<16xi32>
  %134 = "llvm.icmp"(%133, %50) <{predicate = 1 : i64}> : (vector<16xi32>, vector<16xi32>) -> vector<16xi1>
  %135 = "llvm.select"(%132, %134, %54) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<16xi1>, vector<16xi1>, vector<16xi1>) -> vector<16xi1>
  %136 = "llvm.getelementptr"(%arg5, %119) <{elem_type = !llvm.array<4 x i8>, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.intr.masked.store"(%55, %136, %135) <{alignment = 4 : i32}> : (vector<16xi32>, !llvm.ptr, vector<16xi1>) -> ()
  %137 = "llvm.and"(%122, %112) : (vector<16xi32>, vector<16xi32>) -> vector<16xi32>
  %138 = "llvm.icmp"(%137, %50) <{predicate = 0 : i64}> : (vector<16xi32>, vector<16xi32>) -> vector<16xi1>
  %139 = "llvm.select"(%128, %130, %54) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<16xi1>, vector<16xi1>, vector<16xi1>) -> vector<16xi1>
  "llvm.intr.masked.store"(%56, %136, %139) <{alignment = 4 : i32}> : (vector<16xi32>, !llvm.ptr, vector<16xi1>) -> ()
  %140 = "llvm.select"(%124, %126, %54) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<16xi1>, vector<16xi1>, vector<16xi1>) -> vector<16xi1>
  "llvm.intr.masked.store"(%55, %136, %140) <{alignment = 4 : i32}> : (vector<16xi32>, !llvm.ptr, vector<16xi1>) -> ()
  %141 = "llvm.select"(%139, %53, %135) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<16xi1>, vector<16xi1>, vector<16xi1>) -> vector<16xi1>
  %142 = "llvm.select"(%141, %53, %140) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<16xi1>, vector<16xi1>, vector<16xi1>) -> vector<16xi1>
  %143 = "llvm.xor"(%142, %53) : (vector<16xi1>, vector<16xi1>) -> vector<16xi1>
  %144 = "llvm.select"(%124, %143, %54) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<16xi1>, vector<16xi1>, vector<16xi1>) -> vector<16xi1>
  %145 = "llvm.select"(%144, %138, %54) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<16xi1>, vector<16xi1>, vector<16xi1>) -> vector<16xi1>
  %146 = "llvm.select"(%145, %122, %50) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<16xi1>, vector<16xi32>, vector<16xi32>) -> vector<16xi32>
  %147 = "llvm.or"(%120, %146) : (vector<16xi32>, vector<16xi32>) -> vector<16xi32>
  %148 = "llvm.add"(%119, %47) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %149 = "llvm.add"(%121, %57) <{overflowFlags = 0 : i32}> : (vector<16xi32>, vector<16xi32>) -> vector<16xi32>
  %150 = "llvm.icmp"(%148, %108) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%150, %148, %147, %149)[^bb10, ^bb9] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true, runtimeDisable = true>, mustProgress = true, isVectorized = true>, operandSegmentSizes = array<i32: 1, 0, 3>}> : (i1, i64, vector<16xi32>, vector<16xi32>) -> ()
^bb10:  // pred: ^bb9
  %151 = "llvm.intr.vector.reduce.or"(%147) : (vector<16xi32>) -> i32
  %152 = "llvm.icmp"(%arg6, %108) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%152, %151)[^bb16, ^bb11] <{operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i32) -> ()
^bb11:  // pred: ^bb10
  %153 = "llvm.icmp"(%107, %40) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%153, %108, %151, %108, %151)[^bb15, ^bb12] <{branch_weights = array<i32: 8, 8>, operandSegmentSizes = array<i32: 1, 2, 2>}> : (i1, i64, i32, i64, i32) -> ()
^bb12(%154: i64, %155: i32):  // 2 preds: ^bb7, ^bb11
  %156 = "llvm.and"(%arg6, %58) : (i64, i64) -> i64
  %157 = "llvm.insertelement"(%68, %155, %40) : (vector<8xi32>, i32, i64) -> vector<8xi32>
  %158 = "llvm.insertelement"(%29, %101, %40) : (vector<8xi32>, i32, i64) -> vector<8xi32>
  %159 = "llvm.shufflevector"(%158, %29) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %160 = "llvm.insertelement"(%29, %102, %40) : (vector<8xi32>, i32, i64) -> vector<8xi32>
  %161 = "llvm.shufflevector"(%160, %29) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %162 = "llvm.insertelement"(%29, %103, %40) : (vector<8xi32>, i32, i64) -> vector<8xi32>
  %163 = "llvm.shufflevector"(%162, %29) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %164 = "llvm.insertelement"(%29, %104, %40) : (vector<8xi32>, i32, i64) -> vector<8xi32>
  %165 = "llvm.shufflevector"(%164, %29) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %166 = "llvm.insertelement"(%29, %98, %40) : (vector<8xi32>, i32, i64) -> vector<8xi32>
  %167 = "llvm.shufflevector"(%166, %29) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %168 = "llvm.trunc"(%154) <{overflowFlags = 0 : i32}> : (i64) -> i32
  %169 = "llvm.insertelement"(%29, %168, %40) : (vector<8xi32>, i32, i64) -> vector<8xi32>
  %170 = "llvm.shufflevector"(%169, %29) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %171 = "llvm.or"(%170, %28) <{isDisjoint}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  "llvm.br"(%154, %157, %171)[^bb13] : (i64, vector<8xi32>, vector<8xi32>) -> ()
^bb13(%172: i64, %173: vector<8xi32>, %174: vector<8xi32>):  // 2 preds: ^bb12, ^bb13
  %175 = "llvm.shl"(%27, %174) <{overflowFlags = 2 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %176 = "llvm.and"(%175, %167) : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %177 = "llvm.icmp"(%176, %26) <{predicate = 1 : i64}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi1>
  %178 = "llvm.and"(%163, %175) : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %179 = "llvm.icmp"(%178, %26) <{predicate = 0 : i64}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi1>
  %180 = "llvm.xor"(%179, %25) : (vector<8xi1>, vector<8xi1>) -> vector<8xi1>
  %181 = "llvm.select"(%177, %180, %24) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi1>, vector<8xi1>) -> vector<8xi1>
  %182 = "llvm.and"(%165, %175) : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %183 = "llvm.icmp"(%182, %26) <{predicate = 0 : i64}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi1>
  %184 = "llvm.xor"(%183, %25) : (vector<8xi1>, vector<8xi1>) -> vector<8xi1>
  %185 = "llvm.select"(%181, %184, %24) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi1>, vector<8xi1>) -> vector<8xi1>
  %186 = "llvm.and"(%175, %159) : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %187 = "llvm.icmp"(%186, %26) <{predicate = 1 : i64}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi1>
  %188 = "llvm.select"(%185, %187, %24) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi1>, vector<8xi1>) -> vector<8xi1>
  %189 = "llvm.getelementptr"(%arg5, %172) <{elem_type = !llvm.array<4 x i8>, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.intr.masked.store"(%23, %189, %188) <{alignment = 4 : i32}> : (vector<8xi32>, !llvm.ptr, vector<8xi1>) -> ()
  %190 = "llvm.and"(%175, %161) : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %191 = "llvm.icmp"(%190, %26) <{predicate = 0 : i64}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi1>
  %192 = "llvm.select"(%181, %183, %24) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi1>, vector<8xi1>) -> vector<8xi1>
  "llvm.intr.masked.store"(%22, %189, %192) <{alignment = 4 : i32}> : (vector<8xi32>, !llvm.ptr, vector<8xi1>) -> ()
  %193 = "llvm.select"(%177, %179, %24) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi1>, vector<8xi1>) -> vector<8xi1>
  "llvm.intr.masked.store"(%23, %189, %193) <{alignment = 4 : i32}> : (vector<8xi32>, !llvm.ptr, vector<8xi1>) -> ()
  %194 = "llvm.select"(%192, %25, %188) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi1>, vector<8xi1>) -> vector<8xi1>
  %195 = "llvm.select"(%194, %25, %193) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi1>, vector<8xi1>) -> vector<8xi1>
  %196 = "llvm.xor"(%195, %25) : (vector<8xi1>, vector<8xi1>) -> vector<8xi1>
  %197 = "llvm.select"(%177, %196, %24) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi1>, vector<8xi1>) -> vector<8xi1>
  %198 = "llvm.select"(%197, %191, %24) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi1>, vector<8xi1>) -> vector<8xi1>
  %199 = "llvm.select"(%198, %175, %26) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %200 = "llvm.or"(%173, %199) : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %201 = "llvm.add"(%172, %46) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %202 = "llvm.add"(%174, %21) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %203 = "llvm.icmp"(%201, %156) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%203, %201, %200, %202)[^bb14, ^bb13] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true, runtimeDisable = true>, mustProgress = true, isVectorized = true>, operandSegmentSizes = array<i32: 1, 0, 3>}> : (i1, i64, vector<8xi32>, vector<8xi32>) -> ()
^bb14:  // pred: ^bb13
  %204 = "llvm.intr.vector.reduce.or"(%200) : (vector<8xi32>) -> i32
  %205 = "llvm.icmp"(%arg6, %156) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%205, %204, %156, %204)[^bb16, ^bb15] <{operandSegmentSizes = array<i32: 1, 1, 2>}> : (i1, i32, i64, i32) -> ()
^bb15(%206: i64, %207: i32):  // 3 preds: ^bb6, ^bb11, ^bb14
  "llvm.br"(%206, %207)[^bb17] : (i64, i32) -> ()
^bb16(%208: i32):  // 3 preds: ^bb10, ^bb14, ^bb25
  %209 = "llvm.icmp"(%208, %39) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%209)[^bb56, ^bb26] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb17(%210: i64, %211: i32):  // 2 preds: ^bb15, ^bb25
  %212 = "llvm.trunc"(%210) <{overflowFlags = 0 : i32}> : (i64) -> i32
  %213 = "llvm.shl"(%36, %212) <{overflowFlags = 2 : i32}> : (i32, i32) -> i32
  %214 = "llvm.and"(%213, %98) : (i32, i32) -> i32
  %215 = "llvm.icmp"(%214, %39) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%215, %211)[^bb25, ^bb18] <{operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i32) -> ()
^bb18:  // pred: ^bb17
  %216 = "llvm.and"(%103, %213) : (i32, i32) -> i32
  %217 = "llvm.icmp"(%216, %39) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%217)[^bb19, ^bb20] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb19:  // pred: ^bb18
  %218 = "llvm.getelementptr"(%arg5, %210) <{elem_type = !llvm.array<4 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%20, %218) <{alignment = 4 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i32, !llvm.ptr) -> ()
  "llvm.br"(%211)[^bb25] : (i32) -> ()
^bb20:  // pred: ^bb18
  %219 = "llvm.and"(%104, %213) : (i32, i32) -> i32
  %220 = "llvm.icmp"(%219, %39) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%220)[^bb21, ^bb22] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb21:  // pred: ^bb20
  %221 = "llvm.getelementptr"(%arg5, %210) <{elem_type = !llvm.array<4 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%42, %221) <{alignment = 4 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i32, !llvm.ptr) -> ()
  "llvm.br"(%211)[^bb25] : (i32) -> ()
^bb22:  // pred: ^bb20
  %222 = "llvm.and"(%213, %101) : (i32, i32) -> i32
  %223 = "llvm.icmp"(%222, %39) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%223)[^bb24, ^bb23] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb23:  // pred: ^bb22
  %224 = "llvm.getelementptr"(%arg5, %210) <{elem_type = !llvm.array<4 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%20, %224) <{alignment = 4 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i32, !llvm.ptr) -> ()
  "llvm.br"(%211)[^bb25] : (i32) -> ()
^bb24:  // pred: ^bb22
  %225 = "llvm.and"(%213, %102) : (i32, i32) -> i32
  %226 = "llvm.icmp"(%225, %39) <{predicate = 0 : i64}> : (i32, i32) -> i1
  %227 = "llvm.select"(%226, %213, %39) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i32, i32) -> i32
  %228 = "llvm.or"(%227, %211) : (i32, i32) -> i32
  "llvm.br"(%228)[^bb25] : (i32) -> ()
^bb25(%229: i32):  // 5 preds: ^bb17, ^bb19, ^bb21, ^bb23, ^bb24
  %230 = "llvm.add"(%210, %45) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %231 = "llvm.icmp"(%230, %arg6) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%231, %229, %230, %229)[^bb16, ^bb17] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true>, mustProgress = true, isVectorized = true>, operandSegmentSizes = array<i32: 1, 1, 2>}> : (i1, i32, i64, i32) -> ()
^bb26:  // pred: ^bb16
  "llvm.intr.lifetime.start"(%77) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%78) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%79) : (!llvm.ptr) -> ()
  %232 = "llvm.call"(%79) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}], callee = @fd_sha512_batch_init, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.br"(%40)[^bb28] : (i64) -> ()
^bb27:  // pred: ^bb34
  %233 = "llvm.call"(%79) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}], callee = @fd_sha512_batch_fini, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.br"(%40)[^bb36] : (i64) -> ()
^bb28(%234: i64):  // 2 preds: ^bb26, ^bb34
  %235 = "llvm.trunc"(%234) <{overflowFlags = 0 : i32}> : (i64) -> i32
  %236 = "llvm.shl"(%36, %235) <{overflowFlags = 2 : i32}> : (i32, i32) -> i32
  %237 = "llvm.and"(%236, %208) : (i32, i32) -> i32
  %238 = "llvm.icmp"(%237, %39) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%238)[^bb34, ^bb29] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb29:  // pred: ^bb28
  %239 = "llvm.getelementptr"(%arg1, %234) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %240 = "llvm.load"(%239) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %241 = "llvm.icmp"(%240, %19) <{predicate = 6 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%241)[^bb30, ^bb33] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb30:  // pred: ^bb29
  %242 = "llvm.getelementptr"(%77, %234) <{elem_type = !llvm.array<1296 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %243 = "llvm.getelementptr"(%arg2, %234) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %244 = "llvm.load"(%243) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 omnipotent char", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 omnipotent char", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> !llvm.ptr
  %245 = "llvm.call"(%242, %244, %43) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_memcpy, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> !llvm.ptr
  %246 = "llvm.getelementptr"(%242) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %247 = "llvm.getelementptr"(%arg3, %234) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %248 = "llvm.load"(%247) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 omnipotent char", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 omnipotent char", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> !llvm.ptr
  %249 = "llvm.call"(%246, %248, %43) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_memcpy, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> !llvm.ptr
  %250 = "llvm.icmp"(%240, %40) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%250)[^bb32, ^bb31] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb31:  // pred: ^bb30
  %251 = "llvm.getelementptr"(%242) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %252 = "llvm.getelementptr"(%arg0, %234) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %253 = "llvm.load"(%252) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 omnipotent char", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 omnipotent char", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> !llvm.ptr
  %254 = "llvm.call"(%251, %253, %240) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_memcpy, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> !llvm.ptr
  "llvm.br"()[^bb32] : () -> ()
^bb32:  // 2 preds: ^bb30, ^bb31
  %255 = "llvm.add"(%240, %18) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %256 = "llvm.getelementptr"(%78, %234) <{elem_type = !llvm.array<64 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %257 = "llvm.call"(%79, %242, %255, %256) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_sha512_batch_add, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (!llvm.ptr, !llvm.ptr, i64, !llvm.ptr) -> !llvm.ptr
  "llvm.br"()[^bb34] : () -> ()
^bb33:  // pred: ^bb29
  %258 = "llvm.getelementptr"(%arg4, %234) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %259 = "llvm.load"(%258) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 _ZTS17fd_sha512_private", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 _ZTS17fd_sha512_private", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> !llvm.ptr
  %260 = "llvm.call"(%259) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}], callee = @fd_sha512_init, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> !llvm.ptr
  %261 = "llvm.getelementptr"(%arg2, %234) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %262 = "llvm.load"(%261) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 omnipotent char", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 omnipotent char", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> !llvm.ptr
  %263 = "llvm.call"(%260, %262, %43) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_sha512_append, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> !llvm.ptr
  %264 = "llvm.getelementptr"(%arg3, %234) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %265 = "llvm.load"(%264) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 omnipotent char", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 omnipotent char", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> !llvm.ptr
  %266 = "llvm.call"(%263, %265, %43) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_sha512_append, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> !llvm.ptr
  %267 = "llvm.getelementptr"(%arg0, %234) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %268 = "llvm.load"(%267) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 omnipotent char", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 omnipotent char", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> !llvm.ptr
  %269 = "llvm.load"(%239) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %270 = "llvm.call"(%266, %268, %269) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_sha512_append, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> !llvm.ptr
  %271 = "llvm.getelementptr"(%78, %234) <{elem_type = !llvm.array<64 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %272 = "llvm.call"(%270, %271) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_sha512_fini, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  "llvm.br"()[^bb34] : () -> ()
^bb34:  // 3 preds: ^bb28, ^bb32, ^bb33
  %273 = "llvm.add"(%234, %45) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %274 = "llvm.icmp"(%273, %arg6) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%274, %273)[^bb27, ^bb28] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true>, mustProgress = true>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb35:  // pred: ^bb38
  "llvm.intr.lifetime.start"(%80) : (!llvm.ptr) -> ()
  "llvm.intr.memset"(%80, %37, %17) <{arg_attrs = [{llvm.align = 64 : i64, llvm.dereferenceable = 320 : i64, llvm.nonnull, llvm.noundef}, {}, {}], isVolatile = false, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr, i8, i64) -> ()
  %275 = "llvm.load"(%73) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %276 = "llvm.sub"(%16, %275) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.br"(%45)[^bb39] : (i64) -> ()
^bb36(%277: i64):  // 2 preds: ^bb27, ^bb38
  %278 = "llvm.trunc"(%277) <{overflowFlags = 0 : i32}> : (i64) -> i32
  %279 = "llvm.shl"(%36, %278) <{overflowFlags = 2 : i32}> : (i32, i32) -> i32
  %280 = "llvm.and"(%279, %208) : (i32, i32) -> i32
  %281 = "llvm.icmp"(%280, %39) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%281)[^bb38, ^bb37] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb37:  // pred: ^bb36
  %282 = "llvm.getelementptr"(%71, %277) <{elem_type = !llvm.array<32 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %283 = "llvm.getelementptr"(%78, %277) <{elem_type = !llvm.array<64 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %284 = "llvm.call"(%282, %283) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_curve25519_scalar_reduce, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %285 = "llvm.getelementptr"(%72, %277) <{elem_type = !llvm.array<32 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %286 = "llvm.getelementptr"(%arg2, %277) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %287 = "llvm.load"(%286) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 omnipotent char", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 omnipotent char", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> !llvm.ptr
  %288 = "llvm.getelementptr"(%287) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %289 = "llvm.call"(%285, %288, %43) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_memcpy, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> !llvm.ptr
  "llvm.br"()[^bb38] : () -> ()
^bb38:  // 2 preds: ^bb36, ^bb37
  %290 = "llvm.add"(%277, %45) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %291 = "llvm.icmp"(%290, %arg6) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%291, %290)[^bb35, ^bb36] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true>, mustProgress = true>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb39(%292: i64):  // 2 preds: ^bb35, ^bb39
  %293 = "llvm.getelementptr"(%80, %292) <{elem_type = !llvm.array<64 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %294 = "llvm.load"(%293) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %295 = "llvm.add"(%294, %15) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %296 = "llvm.getelementptr"(%73, %292) <{elem_type = !llvm.array<64 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %297 = "llvm.load"(%296) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %298 = "llvm.sub"(%295, %297) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%298, %296) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %299 = "llvm.add"(%292, %45) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %300 = "llvm.icmp"(%299, %14) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%300, %299)[^bb40, ^bb39] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true>, mustProgress = true>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb40:  // pred: ^bb39
  %301 = "llvm.lshr"(%276, %13) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %302 = "llvm.getelementptr"(%73) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %303 = "llvm.load"(%302) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %304 = "llvm.lshr"(%303, %13) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %305 = "llvm.getelementptr"(%73) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %306 = "llvm.load"(%305) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %307 = "llvm.lshr"(%306, %13) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %308 = "llvm.getelementptr"(%73) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 192>}> : (!llvm.ptr) -> !llvm.ptr
  %309 = "llvm.load"(%308) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %310 = "llvm.lshr"(%309, %13) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %311 = "llvm.getelementptr"(%73) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 256>}> : (!llvm.ptr) -> !llvm.ptr
  %312 = "llvm.load"(%311) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %313 = "llvm.lshr"(%312, %13) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %314 = "llvm.and"(%276, %12) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %315 = "llvm.call_intrinsic"(%314, %313, %11) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%315, %73) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %316 = "llvm.and"(%303, %12) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %317 = "llvm.add"(%316, %301) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%317, %302) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %318 = "llvm.and"(%306, %12) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %319 = "llvm.add"(%318, %304) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%319, %305) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %320 = "llvm.and"(%309, %12) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %321 = "llvm.add"(%320, %307) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%321, %308) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %322 = "llvm.and"(%312, %12) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %323 = "llvm.add"(%322, %310) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%323, %311) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %324 = "llvm.getelementptr"(%73) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 960>}> : (!llvm.ptr) -> !llvm.ptr
  %325 = "llvm.load"(%324) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %326 = "llvm.sub"(%16, %325) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.br"(%45)[^bb41] : (i64) -> ()
^bb41(%327: i64):  // 2 preds: ^bb40, ^bb41
  %328 = "llvm.getelementptr"(%80, %327) <{elem_type = !llvm.array<64 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %329 = "llvm.load"(%328) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %330 = "llvm.add"(%329, %15) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %331 = "llvm.getelementptr"(%324, %327) <{elem_type = !llvm.array<64 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %332 = "llvm.load"(%331) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %333 = "llvm.sub"(%330, %332) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%333, %331) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %334 = "llvm.add"(%327, %45) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %335 = "llvm.icmp"(%334, %14) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%335, %334)[^bb42, ^bb41] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true>, mustProgress = true>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb42:  // pred: ^bb41
  %336 = "llvm.lshr"(%326, %13) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %337 = "llvm.getelementptr"(%73) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1024>}> : (!llvm.ptr) -> !llvm.ptr
  %338 = "llvm.load"(%337) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %339 = "llvm.lshr"(%338, %13) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %340 = "llvm.getelementptr"(%73) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1088>}> : (!llvm.ptr) -> !llvm.ptr
  %341 = "llvm.load"(%340) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %342 = "llvm.lshr"(%341, %13) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %343 = "llvm.getelementptr"(%73) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1152>}> : (!llvm.ptr) -> !llvm.ptr
  %344 = "llvm.load"(%343) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %345 = "llvm.lshr"(%344, %13) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %346 = "llvm.getelementptr"(%73) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1216>}> : (!llvm.ptr) -> !llvm.ptr
  %347 = "llvm.load"(%346) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %348 = "llvm.lshr"(%347, %13) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %349 = "llvm.and"(%326, %12) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %350 = "llvm.call_intrinsic"(%349, %348, %11) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%350, %324) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %351 = "llvm.and"(%338, %12) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %352 = "llvm.add"(%351, %336) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%352, %337) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %353 = "llvm.and"(%341, %12) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %354 = "llvm.add"(%353, %339) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%354, %340) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %355 = "llvm.and"(%344, %12) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %356 = "llvm.add"(%355, %342) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%356, %343) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %357 = "llvm.and"(%347, %12) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %358 = "llvm.add"(%357, %345) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%358, %346) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %359 = "llvm.call"(%73, %74, %71, %72) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_lane_verify, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = read, argMem = readwrite, inaccessibleMem = none, errnoMem = read, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr) -> i32
  %360 = "llvm.icmp"(%arg6, %10) <{predicate = 6 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%360, %40)[^bb51, ^bb43] <{operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i64) -> ()
^bb43:  // pred: ^bb42
  %361 = "llvm.icmp"(%arg6, %47) <{predicate = 6 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%361, %40)[^bb48, ^bb44] <{operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i64) -> ()
^bb44:  // pred: ^bb43
  %362 = "llvm.and"(%arg6, %9) : (i64, i64) -> i64
  %363 = "llvm.and"(%arg6, %48) : (i64, i64) -> i64
  %364 = "llvm.insertelement"(%49, %359, %40) : (vector<16xi32>, i32, i64) -> vector<16xi32>
  %365 = "llvm.shufflevector"(%364, %49) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<16xi32>, vector<16xi32>) -> vector<16xi32>
  %366 = "llvm.insertelement"(%49, %208, %40) : (vector<16xi32>, i32, i64) -> vector<16xi32>
  %367 = "llvm.shufflevector"(%366, %49) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<16xi32>, vector<16xi32>) -> vector<16xi32>
  "llvm.br"(%40, %51)[^bb45] : (i64, vector<16xi32>) -> ()
^bb45(%368: i64, %369: vector<16xi32>):  // 2 preds: ^bb44, ^bb45
  %370 = "llvm.shl"(%52, %369) <{overflowFlags = 2 : i32}> : (vector<16xi32>, vector<16xi32>) -> vector<16xi32>
  %371 = "llvm.and"(%370, %367) : (vector<16xi32>, vector<16xi32>) -> vector<16xi32>
  %372 = "llvm.icmp"(%371, %50) <{predicate = 1 : i64}> : (vector<16xi32>, vector<16xi32>) -> vector<16xi1>
  %373 = "llvm.and"(%370, %365) : (vector<16xi32>, vector<16xi32>) -> vector<16xi32>
  %374 = "llvm.icmp"(%373, %50) <{predicate = 0 : i64}> : (vector<16xi32>, vector<16xi32>) -> vector<16xi1>
  %375 = "llvm.select"(%374, %8, %50) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<16xi1>, vector<16xi32>, vector<16xi32>) -> vector<16xi32>
  %376 = "llvm.getelementptr"(%arg5, %368) <{elem_type = !llvm.array<4 x i8>, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.intr.masked.store"(%375, %376, %372) <{alignment = 4 : i32}> : (vector<16xi32>, !llvm.ptr, vector<16xi1>) -> ()
  %377 = "llvm.add"(%368, %47) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %378 = "llvm.add"(%369, %57) <{overflowFlags = 0 : i32}> : (vector<16xi32>, vector<16xi32>) -> vector<16xi32>
  %379 = "llvm.icmp"(%377, %363) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%379, %377, %378)[^bb46, ^bb45] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true, runtimeDisable = true>, mustProgress = true, isVectorized = true>, operandSegmentSizes = array<i32: 1, 0, 2>}> : (i1, i64, vector<16xi32>) -> ()
^bb46:  // pred: ^bb45
  %380 = "llvm.icmp"(%arg6, %363) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%380)[^bb52, ^bb47] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb47:  // pred: ^bb46
  %381 = "llvm.icmp"(%362, %40) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%381, %363, %363)[^bb51, ^bb48] <{branch_weights = array<i32: 4, 12>, operandSegmentSizes = array<i32: 1, 1, 1>}> : (i1, i64, i64) -> ()
^bb48(%382: i64):  // 2 preds: ^bb43, ^bb47
  %383 = "llvm.and"(%arg6, %7) : (i64, i64) -> i64
  %384 = "llvm.insertelement"(%6, %359, %40) : (vector<4xi32>, i32, i64) -> vector<4xi32>
  %385 = "llvm.shufflevector"(%384, %6) <{mask = array<i32: 0, 0, 0, 0>}> : (vector<4xi32>, vector<4xi32>) -> vector<4xi32>
  %386 = "llvm.insertelement"(%6, %208, %40) : (vector<4xi32>, i32, i64) -> vector<4xi32>
  %387 = "llvm.shufflevector"(%386, %6) <{mask = array<i32: 0, 0, 0, 0>}> : (vector<4xi32>, vector<4xi32>) -> vector<4xi32>
  %388 = "llvm.trunc"(%382) <{overflowFlags = 0 : i32}> : (i64) -> i32
  %389 = "llvm.insertelement"(%6, %388, %40) : (vector<4xi32>, i32, i64) -> vector<4xi32>
  %390 = "llvm.shufflevector"(%389, %6) <{mask = array<i32: 0, 0, 0, 0>}> : (vector<4xi32>, vector<4xi32>) -> vector<4xi32>
  %391 = "llvm.or"(%390, %5) <{isDisjoint}> : (vector<4xi32>, vector<4xi32>) -> vector<4xi32>
  "llvm.br"(%382, %391)[^bb49] : (i64, vector<4xi32>) -> ()
^bb49(%392: i64, %393: vector<4xi32>):  // 2 preds: ^bb48, ^bb49
  %394 = "llvm.shl"(%4, %393) <{overflowFlags = 2 : i32}> : (vector<4xi32>, vector<4xi32>) -> vector<4xi32>
  %395 = "llvm.and"(%394, %387) : (vector<4xi32>, vector<4xi32>) -> vector<4xi32>
  %396 = "llvm.icmp"(%395, %3) <{predicate = 1 : i64}> : (vector<4xi32>, vector<4xi32>) -> vector<4xi1>
  %397 = "llvm.and"(%394, %385) : (vector<4xi32>, vector<4xi32>) -> vector<4xi32>
  %398 = "llvm.icmp"(%397, %3) <{predicate = 0 : i64}> : (vector<4xi32>, vector<4xi32>) -> vector<4xi1>
  %399 = "llvm.select"(%398, %2, %3) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<4xi1>, vector<4xi32>, vector<4xi32>) -> vector<4xi32>
  %400 = "llvm.getelementptr"(%arg5, %392) <{elem_type = !llvm.array<4 x i8>, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.intr.masked.store"(%399, %400, %396) <{alignment = 4 : i32}> : (vector<4xi32>, !llvm.ptr, vector<4xi1>) -> ()
  %401 = "llvm.add"(%392, %10) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %402 = "llvm.add"(%393, %1) <{overflowFlags = 0 : i32}> : (vector<4xi32>, vector<4xi32>) -> vector<4xi32>
  %403 = "llvm.icmp"(%401, %383) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%403, %401, %402)[^bb50, ^bb49] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true, runtimeDisable = true>, mustProgress = true, isVectorized = true>, operandSegmentSizes = array<i32: 1, 0, 2>}> : (i1, i64, vector<4xi32>) -> ()
^bb50:  // pred: ^bb49
  %404 = "llvm.icmp"(%arg6, %383) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%404, %383)[^bb52, ^bb51] <{operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb51(%405: i64):  // 3 preds: ^bb42, ^bb47, ^bb50
  "llvm.br"(%405)[^bb53] : (i64) -> ()
^bb52:  // 3 preds: ^bb46, ^bb50, ^bb55
  "llvm.intr.lifetime.end"(%80) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%79) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%78) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%77) : (!llvm.ptr) -> ()
  "llvm.br"()[^bb56] : () -> ()
^bb53(%406: i64):  // 2 preds: ^bb51, ^bb55
  %407 = "llvm.trunc"(%406) <{overflowFlags = 0 : i32}> : (i64) -> i32
  %408 = "llvm.shl"(%36, %407) <{overflowFlags = 2 : i32}> : (i32, i32) -> i32
  %409 = "llvm.and"(%408, %208) : (i32, i32) -> i32
  %410 = "llvm.icmp"(%409, %39) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%410)[^bb55, ^bb54] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb54:  // pred: ^bb53
  %411 = "llvm.and"(%408, %359) : (i32, i32) -> i32
  %412 = "llvm.icmp"(%411, %39) <{predicate = 0 : i64}> : (i32, i32) -> i1
  %413 = "llvm.select"(%412, %0, %39) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i32, i32) -> i32
  %414 = "llvm.getelementptr"(%arg5, %406) <{elem_type = !llvm.array<4 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%413, %414) <{alignment = 4 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i32, !llvm.ptr) -> ()
  "llvm.br"()[^bb55] : () -> ()
^bb55:  // 2 preds: ^bb53, ^bb54
  %415 = "llvm.add"(%406, %45) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %416 = "llvm.icmp"(%415, %arg6) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%416, %415)[^bb52, ^bb53] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true>, mustProgress = true, isVectorized = true>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb56:  // 2 preds: ^bb16, ^bb52
  "llvm.intr.lifetime.end"(%76) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%75) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%74) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%73) : (!llvm.ptr) -> ()
  "llvm.br"()[^bb57] : () -> ()
^bb57:  // 2 preds: ^bb1, ^bb56
  "llvm.intr.lifetime.end"(%72) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%71) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%70) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%69) : (!llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()

    with
      @verify_x8.identity := Firedancer.LaneNI.Mlir.verify_x8_identity,
      @fd_curve25519_scalar_validate := Firedancer.LaneNI.Mlir.fd_curve25519_scalar_validate,
      @fd_ed25519_lane_decode2 := Firedancer.LaneNI.Mlir.fd_ed25519_lane_decode2,
      @fd_ed25519_lane_small_order := Firedancer.LaneNI.Mlir.fd_ed25519_lane_small_order,
      @fd_ed25519_lane_small_order := Firedancer.LaneNI.Mlir.fd_ed25519_lane_small_order,
      @fd_sha512_batch_init := Firedancer.LaneNI.Mlir.fd_sha512_batch_init,
      @fd_sha512_batch_fini := Firedancer.LaneNI.Mlir.fd_sha512_batch_fini,
      @fd_memcpy := Firedancer.LaneNI.Mlir.fd_memcpy,
      @fd_memcpy := Firedancer.LaneNI.Mlir.fd_memcpy,
      @fd_memcpy := Firedancer.LaneNI.Mlir.fd_memcpy,
      @fd_sha512_batch_add := Firedancer.LaneNI.Mlir.fd_sha512_batch_add,
      @fd_sha512_init := Firedancer.LaneNI.Mlir.fd_sha512_init,
      @fd_sha512_append := Firedancer.LaneNI.Mlir.fd_sha512_append,
      @fd_sha512_append := Firedancer.LaneNI.Mlir.fd_sha512_append,
      @fd_sha512_append := Firedancer.LaneNI.Mlir.fd_sha512_append,
      @fd_sha512_fini := Firedancer.LaneNI.Mlir.fd_sha512_fini,
      @fd_curve25519_scalar_reduce := Firedancer.LaneNI.Mlir.fd_curve25519_scalar_reduce,
      @fd_memcpy := Firedancer.LaneNI.Mlir.fd_memcpy,
      @fd_ed25519_lane_verify := Firedancer.LaneNI.Mlir.fd_ed25519_lane_verify

end

end Firedancer.LaneNI.Mlir
