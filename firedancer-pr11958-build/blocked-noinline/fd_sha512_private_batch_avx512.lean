
module

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

public import Firedancer.LaneNI.Mlir.fd_sha512_private_batch_avx512_K
public import Firedancer.LaneNI.Mlir.fd_sha512_private_batch_avx
public import Firedancer.LaneNI.Mlir.fd_ulong_align_dn
public import Firedancer.LaneNI.Mlir.fd_ulong_align_up
public import Firedancer.LaneNI.Mlir.wwv_st_10
public import Firedancer.LaneNI.Mlir.wwv_st_10
public import Firedancer.LaneNI.Mlir.wwv_st_10
public import Firedancer.LaneNI.Mlir.wwv_st_10
public import Firedancer.LaneNI.Mlir.wwv_st_10
public import Firedancer.LaneNI.Mlir.fd_ulong_bswap_11
public import Firedancer.LaneNI.Mlir.fd_ulong_bswap_11
public import Firedancer.LaneNI.Mlir.wwv_stu
public import Firedancer.LaneNI.Mlir.wwv_stu
public import Firedancer.LaneNI.Mlir.wwv_stu
public import Firedancer.LaneNI.Mlir.wwv_stu
public import Firedancer.LaneNI.Mlir.wwv_stu
public import Firedancer.LaneNI.Mlir.wwv_stu
public import Firedancer.LaneNI.Mlir.wwv_stu
public import Firedancer.LaneNI.Mlir.wwv_stu

namespace Firedancer.LaneNI.Mlir

@[expose] public section

mlir_def fd_sha512_private_batch_avx512 := "llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<void (i64, ptr, ptr, ptr)>, linkage = #llvm.linkage<external>, no_inline, no_unwind, passthrough = ["sspstrong", ["min-legal-vector-width", "512"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "znver4"]], sym_name = "fd_sha512_private_batch_avx512", target_cpu = "znver4", target_features = #llvm.target_features<["+64bit", "+adx", "+aes", "+avx", "+avx2", "+avx512bf16", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+clzero", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fast-vector-fsqrt", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+mwaitx", "+pclmul", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdpru", "+rdrnd", "+rdseed", "+sahf", "+sha", "+shstk", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+sse4a", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tile", "-avx10.1", "-avx10.2", "-avx512bmm", "-avx512fp16", "-avx512vp2intersect", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-ccmp", "-cf", "-cldemote", "-cmpccxadd", "-egpr", "-enqcmd", "-fma4", "-hreset", "-jmpabs", "-kl", "-lwp", "-movdir64b", "-movdiri", "-movrs", "-ndd", "-nf", "-pconfig", "-ppx", "-prefetchi", "-ptwrite", "-push2pop2", "-raoint", "-rtm", "-serialize", "-sgx", "-sha512", "-sm3", "-sm4", "-tbm", "-tsxldtrk", "-uintr", "-usermsr", "-waitpkg", "-widekl", "-xop", "-zu"]>, tune_cpu = "znver4", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg0: i64, %arg1: !llvm.ptr, %arg2: !llvm.ptr, %arg3: !llvm.ptr):
  %0 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %1 = "llvm.mlir.constant"() <{value = 5 : i64}> : () -> i64
  %2 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %3 = "llvm.mlir.constant"() <{value = 127 : i64}> : () -> i64
  %4 = "llvm.mlir.constant"() <{value = 17 : i64}> : () -> i64
  %5 = "llvm.mlir.constant"() <{value = 7 : i64}> : () -> i64
  %6 = "llvm.mlir.constant"() <{value = dense<0> : vector<8xi64>}> : () -> vector<8xi64>
  %7 = "llvm.mlir.constant"() <{value = 64 : i64}> : () -> i64
  %8 = "llvm.mlir.constant"() <{value = 128 : i64}> : () -> i64
  %9 = "llvm.mlir.constant"() <{value = 192 : i64}> : () -> i64
  %10 = "llvm.mlir.constant"() <{value = 63 : i64}> : () -> i64
  %11 = "llvm.mlir.constant"() <{value = -64 : i64}> : () -> i64
  %12 = "llvm.mlir.constant"() <{value = 8 : i64}> : () -> i64
  %13 = "llvm.mlir.constant"() <{value = -8 : i64}> : () -> i64
  %14 = "llvm.mlir.constant"() <{value = 3 : i64}> : () -> i64
  %15 = "llvm.mlir.constant"() <{value = 4 : i64}> : () -> i64
  %16 = "llvm.mlir.constant"() <{value = -4 : i64}> : () -> i64
  %17 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %18 = "llvm.mlir.constant"() <{value = 2 : i64}> : () -> i64
  %19 = "llvm.mlir.constant"() <{value = -2 : i64}> : () -> i64
  %20 = "llvm.mlir.constant"() <{value = -128 : i8}> : () -> i8
  %21 = "llvm.mlir.constant"() <{value = 61 : i64}> : () -> i64
  %22 = "llvm.mlir.constant"() <{value = -16 : i64}> : () -> i64
  %23 = "llvm.mlir.poison"() : () -> vector<8xi64>
  %24 = "llvm.mlir.constant"() <{value = -1 : i32}> : () -> i32
  %25 = "llvm.mlir.constant"() <{value = -1 : i8}> : () -> i8
  %26 = "llvm.mlir.constant"() <{value = dense<7> : vector<8xi64>}> : () -> vector<8xi64>
  %27 = "llvm.mlir.constant"() <{value = 0 : i8}> : () -> i8
  %28 = "llvm.mlir.constant"() <{value = dense<6620516959819538809> : vector<8xi64>}> : () -> vector<8xi64>
  %29 = "llvm.mlir.constant"() <{value = dense<2270897969802886507> : vector<8xi64>}> : () -> vector<8xi64>
  %30 = "llvm.mlir.constant"() <{value = dense<-7276294671716946913> : vector<8xi64>}> : () -> vector<8xi64>
  %31 = "llvm.mlir.constant"() <{value = dense<5840696475078001361> : vector<8xi64>}> : () -> vector<8xi64>
  %32 = "llvm.mlir.constant"() <{value = dense<-6534734903238641935> : vector<8xi64>}> : () -> vector<8xi64>
  %33 = "llvm.mlir.constant"() <{value = dense<4354685564936845355> : vector<8xi64>}> : () -> vector<8xi64>
  %34 = "llvm.mlir.constant"() <{value = dense<-4942790177534073029> : vector<8xi64>}> : () -> vector<8xi64>
  %35 = "llvm.mlir.constant"() <{value = dense<7640891576956012808> : vector<8xi64>}> : () -> vector<8xi64>
  %36 = "llvm.mlir.constant"() <{value = 6 : i64}> : () -> i64
  %37 = "llvm.mlir.constant"() <{value = dense<50> : vector<8xi64>}> : () -> vector<8xi64>
  %38 = "llvm.mlir.constant"() <{value = dense<46> : vector<8xi64>}> : () -> vector<8xi64>
  %39 = "llvm.mlir.constant"() <{value = dense<23> : vector<8xi64>}> : () -> vector<8xi64>
  %40 = "llvm.mlir.constant"() <{value = dense<-1> : vector<8xi64>}> : () -> vector<8xi64>
  %41 = "llvm.mlir.constant"() <{value = dense<4794697086780616226> : vector<8xi64>}> : () -> vector<8xi64>
  %42 = "llvm.mlir.constant"() <{value = dense<36> : vector<8xi64>}> : () -> vector<8xi64>
  %43 = "llvm.mlir.constant"() <{value = dense<30> : vector<8xi64>}> : () -> vector<8xi64>
  %44 = "llvm.mlir.constant"() <{value = dense<25> : vector<8xi64>}> : () -> vector<8xi64>
  %45 = "llvm.mlir.constant"() <{value = dense<8158064640168781261> : vector<8xi64>}> : () -> vector<8xi64>
  %46 = "llvm.mlir.constant"() <{value = dense<-5349999486874862801> : vector<8xi64>}> : () -> vector<8xi64>
  %47 = "llvm.mlir.constant"() <{value = dense<-1606136188198331460> : vector<8xi64>}> : () -> vector<8xi64>
  %48 = "llvm.mlir.constant"() <{value = dense<4131703408338449720> : vector<8xi64>}> : () -> vector<8xi64>
  %49 = "llvm.mlir.constant"() <{value = dense<6480981068601479193> : vector<8xi64>}> : () -> vector<8xi64>
  %50 = "llvm.mlir.constant"() <{value = dense<-7908458776815382629> : vector<8xi64>}> : () -> vector<8xi64>
  %51 = "llvm.mlir.constant"() <{value = dense<-6116909921290321640> : vector<8xi64>}> : () -> vector<8xi64>
  %52 = "llvm.mlir.constant"() <{value = dense<-2880145864133508542> : vector<8xi64>}> : () -> vector<8xi64>
  %53 = "llvm.mlir.constant"() <{value = dense<1334009975649890238> : vector<8xi64>}> : () -> vector<8xi64>
  %54 = "llvm.mlir.constant"() <{value = dense<2608012711638119052> : vector<8xi64>}> : () -> vector<8xi64>
  %55 = "llvm.mlir.constant"() <{value = dense<6128411473006802146> : vector<8xi64>}> : () -> vector<8xi64>
  %56 = "llvm.mlir.constant"() <{value = dense<8268148722764581231> : vector<8xi64>}> : () -> vector<8xi64>
  %57 = "llvm.mlir.constant"() <{value = dense<-9160688886553864527> : vector<8xi64>}> : () -> vector<8xi64>
  %58 = "llvm.mlir.constant"() <{value = dense<-7215885187991268811> : vector<8xi64>}> : () -> vector<8xi64>
  %59 = "llvm.mlir.constant"() <{value = dense<-4495734319001033068> : vector<8xi64>}> : () -> vector<8xi64>
  %60 = "llvm.mlir.constant"() <{value = 16 : i64}> : () -> i64
  %61 = "llvm.mlir.constant"() <{value = dense<63> : vector<8xi64>}> : () -> vector<8xi64>
  %62 = "llvm.mlir.constant"() <{value = dense<56> : vector<8xi64>}> : () -> vector<8xi64>
  %63 = "llvm.mlir.constant"() <{value = dense<45> : vector<8xi64>}> : () -> vector<8xi64>
  %64 = "llvm.mlir.constant"() <{value = dense<3> : vector<8xi64>}> : () -> vector<8xi64>
  %65 = "llvm.mlir.constant"() <{value = dense<6> : vector<8xi64>}> : () -> vector<8xi64>
  %66 = "llvm.mlir.addressof"() <{global_name = @fd_sha512_private_batch_avx512.K}> : () -> !llvm.ptr
  %67 = "llvm.mlir.constant"() <{value = dense<128> : vector<8xi64>}> : () -> vector<8xi64>
  %68 = "llvm.mlir.constant"() <{value = dense<1> : vector<8xi64>}> : () -> vector<8xi64>
  %69 = "llvm.mlir.poison"() : () -> vector<64xi8>
  %70 = "llvm.alloca"(%0) <{alignment = 64 : i64, elem_type = !llvm.array<8 x i64>}> : (i32) -> !llvm.ptr
  %71 = "llvm.alloca"(%0) <{alignment = 64 : i64, elem_type = !llvm.array<8 x i64>}> : (i32) -> !llvm.ptr
  %72 = "llvm.alloca"(%0) <{alignment = 128 : i64, elem_type = !llvm.array<2048 x i8>}> : (i32) -> !llvm.ptr
  %73 = "llvm.icmp"(%arg0, %1) <{predicate = 6 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%73)[^bb1, ^bb2] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb1:  // pred: ^bb0
  "llvm.call"(%arg0, %arg1, %arg2, %arg3) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_sha512_private_batch_avx, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (i64, !llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.br"()[^bb25] : () -> ()
^bb2:  // pred: ^bb0
  "llvm.intr.lifetime.start"(%70) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%71) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%72) : (!llvm.ptr) -> ()
  %74 = "llvm.ptrtoint"(%72) : (!llvm.ptr) -> i64
  "llvm.br"(%74, %2)[^bb5] : (i64, i64) -> ()
^bb3:  // pred: ^bb15
  %75 = "llvm.insertelement"(%23, %74, %2) : (vector<8xi64>, i64, i64) -> vector<8xi64>
  %76 = "llvm.shufflevector"(%75, %23) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %77 = "llvm.load"(%70) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %78 = "llvm.load"(%71) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %79 = "llvm.trunc"(%arg0) <{overflowFlags = 0 : i32}> : (i64) -> i32
  %80 = "llvm.shl"(%24, %79) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %81 = "llvm.trunc"(%80) <{overflowFlags = 0 : i32}> : (i32) -> i8
  %82 = "llvm.xor"(%81, %25) : (i8, i8) -> i8
  %83 = "llvm.load"(%arg2) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %84 = "llvm.lshr"(%83, %26) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %85 = "llvm.add"(%84, %78) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %86 = "llvm.bitcast"(%82) : (i8) -> vector<8xi1>
  %87 = "llvm.select"(%86, %85, %6) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %88 = "llvm.icmp"(%87, %6) <{predicate = 1 : i64}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi1>
  %89 = "llvm.bitcast"(%88) : (vector<8xi1>) -> i8
  %90 = "llvm.icmp"(%89, %27) <{predicate = 0 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%90, %28, %29, %30, %31, %32, %33, %34, %35)[^bb19, ^bb4] <{branch_weights = array<i32: 1, 127>, operandSegmentSizes = array<i32: 1, 8, 0>}> : (i1, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>) -> ()
^bb4:  // pred: ^bb3
  %91 = "llvm.load"(%arg1) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  "llvm.br"(%88, %35, %34, %33, %32, %31, %30, %29, %28, %91, %87)[^bb16] : (vector<8xi1>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>) -> ()
^bb5(%92: i64, %93: i64):  // 2 preds: ^bb2, ^bb15
  %94 = "llvm.getelementptr"(%arg1, %93) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %95 = "llvm.load"(%94) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %96 = "llvm.getelementptr"(%arg2, %93) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %97 = "llvm.load"(%96) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %98 = "llvm.and"(%97, %3) : (i64, i64) -> i64
  %99 = "llvm.call"(%97) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}], callee = @fd_ulong_align_dn, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (i64) -> i64
  %100 = "llvm.add"(%98, %4) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %101 = "llvm.call"(%100) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}], callee = @fd_ulong_align_up, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (i64) -> i64
  %102 = "llvm.getelementptr"(%70, %93) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%92, %102) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %103 = "llvm.lshr"(%101, %5) : (i64, i64) -> i64
  %104 = "llvm.getelementptr"(%71, %93) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%103, %104) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %105 = "llvm.add"(%101, %92) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %106 = "llvm.inttoptr"(%92) : (i64) -> !llvm.ptr
  "llvm.call"(%106, %6) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @wwv_st.10, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, vector<8xi64>) -> ()
  %107 = "llvm.add"(%92, %7) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %108 = "llvm.inttoptr"(%107) : (i64) -> !llvm.ptr
  "llvm.call"(%108, %6) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @wwv_st.10, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, vector<8xi64>) -> ()
  %109 = "llvm.add"(%92, %8) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %110 = "llvm.inttoptr"(%109) : (i64) -> !llvm.ptr
  "llvm.call"(%110, %6) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @wwv_st.10, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, vector<8xi64>) -> ()
  %111 = "llvm.add"(%92, %9) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %112 = "llvm.inttoptr"(%111) : (i64) -> !llvm.ptr
  "llvm.call"(%112, %6) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @wwv_st.10, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, vector<8xi64>) -> ()
  %113 = "llvm.add"(%99, %95) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %114 = "llvm.icmp"(%98, %10) <{predicate = 8 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%114, %98, %92, %113)[^bb6, ^bb7] <{operandSegmentSizes = array<i32: 1, 0, 3>}> : (i1, i64, i64, i64) -> ()
^bb6:  // pred: ^bb5
  %115 = "llvm.inttoptr"(%92) : (i64) -> !llvm.ptr
  %116 = "llvm.inttoptr"(%113) : (i64) -> !llvm.ptr
  %117 = "llvm.load"(%116) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  "llvm.call"(%115, %117) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @wwv_st.10, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, vector<8xi64>) -> ()
  %118 = "llvm.add"(%98, %11) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %119 = "llvm.add"(%113, %7) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %120 = "llvm.add"(%92, %7) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.br"(%118, %120, %119)[^bb7] : (i64, i64, i64) -> ()
^bb7(%121: i64, %122: i64, %123: i64):  // 2 preds: ^bb5, ^bb6
  %124 = "llvm.icmp"(%121, %5) <{predicate = 8 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%124, %123, %122, %121, %121, %122, %123)[^bb8, ^bb9] <{operandSegmentSizes = array<i32: 1, 3, 3>}> : (i1, i64, i64, i64, i64, i64, i64) -> ()
^bb8(%125: i64, %126: i64, %127: i64):  // 2 preds: ^bb7, ^bb8
  %128 = "llvm.inttoptr"(%125) : (i64) -> !llvm.ptr
  %129 = "llvm.load"(%128) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %130 = "llvm.inttoptr"(%126) : (i64) -> !llvm.ptr
  "llvm.store"(%129, %130) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %131 = "llvm.add"(%126, %12) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %132 = "llvm.add"(%125, %12) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %133 = "llvm.add"(%127, %13) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %134 = "llvm.icmp"(%133, %5) <{predicate = 8 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%134, %132, %131, %133, %133, %131, %132)[^bb8, ^bb9] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true>, mustProgress = true>, operandSegmentSizes = array<i32: 1, 3, 3>}> : (i1, i64, i64, i64, i64, i64, i64) -> ()
^bb9(%135: i64, %136: i64, %137: i64):  // 2 preds: ^bb7, ^bb8
  %138 = "llvm.icmp"(%135, %14) <{predicate = 8 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%138, %135, %136, %137)[^bb10, ^bb11] <{operandSegmentSizes = array<i32: 1, 0, 3>}> : (i1, i64, i64, i64) -> ()
^bb10:  // pred: ^bb9
  %139 = "llvm.inttoptr"(%137) : (i64) -> !llvm.ptr
  %140 = "llvm.load"(%139) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i32
  %141 = "llvm.inttoptr"(%136) : (i64) -> !llvm.ptr
  "llvm.store"(%140, %141) <{alignment = 4 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i32, !llvm.ptr) -> ()
  %142 = "llvm.add"(%136, %15) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %143 = "llvm.add"(%137, %15) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %144 = "llvm.add"(%135, %16) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  "llvm.br"(%144, %142, %143)[^bb11] : (i64, i64, i64) -> ()
^bb11(%145: i64, %146: i64, %147: i64):  // 2 preds: ^bb9, ^bb10
  %148 = "llvm.icmp"(%145, %17) <{predicate = 8 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%148, %145, %146, %147)[^bb12, ^bb13] <{operandSegmentSizes = array<i32: 1, 0, 3>}> : (i1, i64, i64, i64) -> ()
^bb12:  // pred: ^bb11
  %149 = "llvm.inttoptr"(%147) : (i64) -> !llvm.ptr
  %150 = "llvm.load"(%149) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i16
  %151 = "llvm.inttoptr"(%146) : (i64) -> !llvm.ptr
  "llvm.store"(%150, %151) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i16, !llvm.ptr) -> ()
  %152 = "llvm.add"(%146, %18) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %153 = "llvm.add"(%147, %18) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %154 = "llvm.add"(%145, %19) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  "llvm.br"(%154, %152, %153)[^bb13] : (i64, i64, i64) -> ()
^bb13(%155: i64, %156: i64, %157: i64):  // 2 preds: ^bb11, ^bb12
  %158 = "llvm.icmp"(%155, %2) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%158, %156)[^bb15, ^bb14] <{operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i64) -> ()
^bb14:  // pred: ^bb13
  %159 = "llvm.inttoptr"(%157) : (i64) -> !llvm.ptr
  %160 = "llvm.load"(%159) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %161 = "llvm.inttoptr"(%156) : (i64) -> !llvm.ptr
  "llvm.store"(%160, %161) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (i8, !llvm.ptr) -> ()
  %162 = "llvm.add"(%156, %17) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.br"(%162)[^bb15] : (i64) -> ()
^bb15(%163: i64):  // 2 preds: ^bb13, ^bb14
  %164 = "llvm.inttoptr"(%163) : (i64) -> !llvm.ptr
  "llvm.store"(%20, %164) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (i8, !llvm.ptr) -> ()
  %165 = "llvm.lshr"(%97, %21) : (i64, i64) -> i64
  %166 = "llvm.call"(%165) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}], callee = @fd_ulong_bswap.11, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (i64) -> i64
  %167 = "llvm.add"(%105, %22) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %168 = "llvm.inttoptr"(%167) : (i64) -> !llvm.ptr
  "llvm.store"(%166, %168) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %169 = "llvm.shl"(%97, %14) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %170 = "llvm.call"(%169) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}], callee = @fd_ulong_bswap.11, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (i64) -> i64
  %171 = "llvm.add"(%105, %13) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %172 = "llvm.inttoptr"(%171) : (i64) -> !llvm.ptr
  "llvm.store"(%170, %172) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %173 = "llvm.add"(%93, %17) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %174 = "llvm.icmp"(%173, %arg0) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%174, %105, %173)[^bb3, ^bb5] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true>, mustProgress = true>, operandSegmentSizes = array<i32: 1, 0, 2>}> : (i1, i64, i64) -> ()
^bb16(%175: vector<8xi1>, %176: vector<8xi64>, %177: vector<8xi64>, %178: vector<8xi64>, %179: vector<8xi64>, %180: vector<8xi64>, %181: vector<8xi64>, %182: vector<8xi64>, %183: vector<8xi64>, %184: vector<8xi64>, %185: vector<8xi64>):  // 2 preds: ^bb4, ^bb18
  %186 = "llvm.icmp"(%185, %78) <{predicate = 0 : i64}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi1>
  %187 = "llvm.select"(%186, %77, %184) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %188 = "llvm.select"(%175, %187, %76) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %189 = "llvm.extractelement"(%188, %2) : (vector<8xi64>, i64) -> i64
  %190 = "llvm.extractelement"(%188, %17) : (vector<8xi64>, i64) -> i64
  %191 = "llvm.extractelement"(%188, %18) : (vector<8xi64>, i64) -> i64
  %192 = "llvm.extractelement"(%188, %14) : (vector<8xi64>, i64) -> i64
  %193 = "llvm.extractelement"(%188, %15) : (vector<8xi64>, i64) -> i64
  %194 = "llvm.extractelement"(%188, %1) : (vector<8xi64>, i64) -> i64
  %195 = "llvm.extractelement"(%188, %36) : (vector<8xi64>, i64) -> i64
  %196 = "llvm.extractelement"(%188, %5) : (vector<8xi64>, i64) -> i64
  %197 = "llvm.inttoptr"(%189) : (i64) -> !llvm.ptr
  %198 = "llvm.inttoptr"(%190) : (i64) -> !llvm.ptr
  %199 = "llvm.inttoptr"(%191) : (i64) -> !llvm.ptr
  %200 = "llvm.inttoptr"(%192) : (i64) -> !llvm.ptr
  %201 = "llvm.inttoptr"(%193) : (i64) -> !llvm.ptr
  %202 = "llvm.inttoptr"(%194) : (i64) -> !llvm.ptr
  %203 = "llvm.inttoptr"(%195) : (i64) -> !llvm.ptr
  %204 = "llvm.inttoptr"(%196) : (i64) -> !llvm.ptr
  %205 = "llvm.load"(%197) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<64xi8>
  %206 = "llvm.load"(%198) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<64xi8>
  %207 = "llvm.load"(%199) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<64xi8>
  %208 = "llvm.load"(%200) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<64xi8>
  %209 = "llvm.load"(%201) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<64xi8>
  %210 = "llvm.load"(%202) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<64xi8>
  %211 = "llvm.load"(%203) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<64xi8>
  %212 = "llvm.load"(%204) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<64xi8>
  %213 = "llvm.shufflevector"(%205, %207) <{mask = array<i32: 7, 6, 5, 4, 3, 2, 1, 0, 15, 14, 13, 12, 11, 10, 9, 8, 39, 38, 37, 36, 35, 34, 33, 32, 47, 46, 45, 44, 43, 42, 41, 40, 71, 70, 69, 68, 67, 66, 65, 64, 79, 78, 77, 76, 75, 74, 73, 72, 103, 102, 101, 100, 99, 98, 97, 96, 111, 110, 109, 108, 107, 106, 105, 104>}> : (vector<64xi8>, vector<64xi8>) -> vector<64xi8>
  %214 = "llvm.shufflevector"(%206, %208) <{mask = array<i32: 7, 6, 5, 4, 3, 2, 1, 0, 15, 14, 13, 12, 11, 10, 9, 8, 39, 38, 37, 36, 35, 34, 33, 32, 47, 46, 45, 44, 43, 42, 41, 40, 71, 70, 69, 68, 67, 66, 65, 64, 79, 78, 77, 76, 75, 74, 73, 72, 103, 102, 101, 100, 99, 98, 97, 96, 111, 110, 109, 108, 107, 106, 105, 104>}> : (vector<64xi8>, vector<64xi8>) -> vector<64xi8>
  %215 = "llvm.shufflevector"(%205, %207) <{mask = array<i32: 23, 22, 21, 20, 19, 18, 17, 16, 31, 30, 29, 28, 27, 26, 25, 24, 55, 54, 53, 52, 51, 50, 49, 48, 63, 62, 61, 60, 59, 58, 57, 56, 87, 86, 85, 84, 83, 82, 81, 80, 95, 94, 93, 92, 91, 90, 89, 88, 119, 118, 117, 116, 115, 114, 113, 112, 127, 126, 125, 124, 123, 122, 121, 120>}> : (vector<64xi8>, vector<64xi8>) -> vector<64xi8>
  %216 = "llvm.shufflevector"(%206, %208) <{mask = array<i32: 23, 22, 21, 20, 19, 18, 17, 16, 31, 30, 29, 28, 27, 26, 25, 24, 55, 54, 53, 52, 51, 50, 49, 48, 63, 62, 61, 60, 59, 58, 57, 56, 87, 86, 85, 84, 83, 82, 81, 80, 95, 94, 93, 92, 91, 90, 89, 88, 119, 118, 117, 116, 115, 114, 113, 112, 127, 126, 125, 124, 123, 122, 121, 120>}> : (vector<64xi8>, vector<64xi8>) -> vector<64xi8>
  %217 = "llvm.shufflevector"(%209, %211) <{mask = array<i32: 7, 6, 5, 4, 3, 2, 1, 0, 15, 14, 13, 12, 11, 10, 9, 8, 39, 38, 37, 36, 35, 34, 33, 32, 47, 46, 45, 44, 43, 42, 41, 40, 71, 70, 69, 68, 67, 66, 65, 64, 79, 78, 77, 76, 75, 74, 73, 72, 103, 102, 101, 100, 99, 98, 97, 96, 111, 110, 109, 108, 107, 106, 105, 104>}> : (vector<64xi8>, vector<64xi8>) -> vector<64xi8>
  %218 = "llvm.shufflevector"(%210, %212) <{mask = array<i32: 7, 6, 5, 4, 3, 2, 1, 0, 15, 14, 13, 12, 11, 10, 9, 8, 39, 38, 37, 36, 35, 34, 33, 32, 47, 46, 45, 44, 43, 42, 41, 40, 71, 70, 69, 68, 67, 66, 65, 64, 79, 78, 77, 76, 75, 74, 73, 72, 103, 102, 101, 100, 99, 98, 97, 96, 111, 110, 109, 108, 107, 106, 105, 104>}> : (vector<64xi8>, vector<64xi8>) -> vector<64xi8>
  %219 = "llvm.shufflevector"(%209, %211) <{mask = array<i32: 23, 22, 21, 20, 19, 18, 17, 16, 31, 30, 29, 28, 27, 26, 25, 24, 55, 54, 53, 52, 51, 50, 49, 48, 63, 62, 61, 60, 59, 58, 57, 56, 87, 86, 85, 84, 83, 82, 81, 80, 95, 94, 93, 92, 91, 90, 89, 88, 119, 118, 117, 116, 115, 114, 113, 112, 127, 126, 125, 124, 123, 122, 121, 120>}> : (vector<64xi8>, vector<64xi8>) -> vector<64xi8>
  %220 = "llvm.shufflevector"(%210, %212) <{mask = array<i32: 23, 22, 21, 20, 19, 18, 17, 16, 31, 30, 29, 28, 27, 26, 25, 24, 55, 54, 53, 52, 51, 50, 49, 48, 63, 62, 61, 60, 59, 58, 57, 56, 87, 86, 85, 84, 83, 82, 81, 80, 95, 94, 93, 92, 91, 90, 89, 88, 119, 118, 117, 116, 115, 114, 113, 112, 127, 126, 125, 124, 123, 122, 121, 120>}> : (vector<64xi8>, vector<64xi8>) -> vector<64xi8>
  %221 = "llvm.shufflevector"(%213, %217) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111>}> : (vector<64xi8>, vector<64xi8>) -> vector<64xi8>
  %222 = "llvm.bitcast"(%221) : (vector<64xi8>) -> vector<8xi64>
  %223 = "llvm.shufflevector"(%214, %218) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111>}> : (vector<64xi8>, vector<64xi8>) -> vector<64xi8>
  %224 = "llvm.bitcast"(%223) : (vector<64xi8>) -> vector<8xi64>
  %225 = "llvm.shufflevector"(%215, %219) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111>}> : (vector<64xi8>, vector<64xi8>) -> vector<64xi8>
  %226 = "llvm.bitcast"(%225) : (vector<64xi8>) -> vector<8xi64>
  %227 = "llvm.shufflevector"(%216, %220) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111>}> : (vector<64xi8>, vector<64xi8>) -> vector<64xi8>
  %228 = "llvm.bitcast"(%227) : (vector<64xi8>) -> vector<8xi64>
  %229 = "llvm.shufflevector"(%213, %217) <{mask = array<i32: 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127>}> : (vector<64xi8>, vector<64xi8>) -> vector<64xi8>
  %230 = "llvm.bitcast"(%229) : (vector<64xi8>) -> vector<8xi64>
  %231 = "llvm.shufflevector"(%214, %218) <{mask = array<i32: 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127>}> : (vector<64xi8>, vector<64xi8>) -> vector<64xi8>
  %232 = "llvm.bitcast"(%231) : (vector<64xi8>) -> vector<8xi64>
  %233 = "llvm.shufflevector"(%215, %219) <{mask = array<i32: 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127>}> : (vector<64xi8>, vector<64xi8>) -> vector<64xi8>
  %234 = "llvm.bitcast"(%233) : (vector<64xi8>) -> vector<8xi64>
  %235 = "llvm.shufflevector"(%216, %220) <{mask = array<i32: 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127>}> : (vector<64xi8>, vector<64xi8>) -> vector<64xi8>
  %236 = "llvm.bitcast"(%235) : (vector<64xi8>) -> vector<8xi64>
  %237 = "llvm.shufflevector"(%222, %224) <{mask = array<i32: 0, 8, 2, 10, 4, 12, 6, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %238 = "llvm.shufflevector"(%222, %224) <{mask = array<i32: 1, 9, 3, 11, 5, 13, 7, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %239 = "llvm.shufflevector"(%226, %228) <{mask = array<i32: 0, 8, 2, 10, 4, 12, 6, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %240 = "llvm.shufflevector"(%226, %228) <{mask = array<i32: 1, 9, 3, 11, 5, 13, 7, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %241 = "llvm.shufflevector"(%230, %232) <{mask = array<i32: 0, 8, 2, 10, 4, 12, 6, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %242 = "llvm.shufflevector"(%230, %232) <{mask = array<i32: 1, 9, 3, 11, 5, 13, 7, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %243 = "llvm.shufflevector"(%234, %236) <{mask = array<i32: 0, 8, 2, 10, 4, 12, 6, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %244 = "llvm.shufflevector"(%234, %236) <{mask = array<i32: 1, 9, 3, 11, 5, 13, 7, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %245 = "llvm.getelementptr"(%197) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %246 = "llvm.load"(%245) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<64xi8>
  %247 = "llvm.getelementptr"(%198) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %248 = "llvm.load"(%247) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<64xi8>
  %249 = "llvm.getelementptr"(%199) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %250 = "llvm.load"(%249) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<64xi8>
  %251 = "llvm.getelementptr"(%200) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %252 = "llvm.load"(%251) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<64xi8>
  %253 = "llvm.getelementptr"(%201) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %254 = "llvm.load"(%253) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<64xi8>
  %255 = "llvm.getelementptr"(%202) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %256 = "llvm.load"(%255) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<64xi8>
  %257 = "llvm.getelementptr"(%203) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %258 = "llvm.load"(%257) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<64xi8>
  %259 = "llvm.getelementptr"(%204) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %260 = "llvm.load"(%259) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<64xi8>
  %261 = "llvm.shufflevector"(%246, %250) <{mask = array<i32: 7, 6, 5, 4, 3, 2, 1, 0, 15, 14, 13, 12, 11, 10, 9, 8, 39, 38, 37, 36, 35, 34, 33, 32, 47, 46, 45, 44, 43, 42, 41, 40, 71, 70, 69, 68, 67, 66, 65, 64, 79, 78, 77, 76, 75, 74, 73, 72, 103, 102, 101, 100, 99, 98, 97, 96, 111, 110, 109, 108, 107, 106, 105, 104>}> : (vector<64xi8>, vector<64xi8>) -> vector<64xi8>
  %262 = "llvm.shufflevector"(%248, %252) <{mask = array<i32: 7, 6, 5, 4, 3, 2, 1, 0, 15, 14, 13, 12, 11, 10, 9, 8, 39, 38, 37, 36, 35, 34, 33, 32, 47, 46, 45, 44, 43, 42, 41, 40, 71, 70, 69, 68, 67, 66, 65, 64, 79, 78, 77, 76, 75, 74, 73, 72, 103, 102, 101, 100, 99, 98, 97, 96, 111, 110, 109, 108, 107, 106, 105, 104>}> : (vector<64xi8>, vector<64xi8>) -> vector<64xi8>
  %263 = "llvm.shufflevector"(%246, %250) <{mask = array<i32: 23, 22, 21, 20, 19, 18, 17, 16, 31, 30, 29, 28, 27, 26, 25, 24, 55, 54, 53, 52, 51, 50, 49, 48, 63, 62, 61, 60, 59, 58, 57, 56, 87, 86, 85, 84, 83, 82, 81, 80, 95, 94, 93, 92, 91, 90, 89, 88, 119, 118, 117, 116, 115, 114, 113, 112, 127, 126, 125, 124, 123, 122, 121, 120>}> : (vector<64xi8>, vector<64xi8>) -> vector<64xi8>
  %264 = "llvm.shufflevector"(%248, %252) <{mask = array<i32: 23, 22, 21, 20, 19, 18, 17, 16, 31, 30, 29, 28, 27, 26, 25, 24, 55, 54, 53, 52, 51, 50, 49, 48, 63, 62, 61, 60, 59, 58, 57, 56, 87, 86, 85, 84, 83, 82, 81, 80, 95, 94, 93, 92, 91, 90, 89, 88, 119, 118, 117, 116, 115, 114, 113, 112, 127, 126, 125, 124, 123, 122, 121, 120>}> : (vector<64xi8>, vector<64xi8>) -> vector<64xi8>
  %265 = "llvm.shufflevector"(%254, %258) <{mask = array<i32: 7, 6, 5, 4, 3, 2, 1, 0, 15, 14, 13, 12, 11, 10, 9, 8, 39, 38, 37, 36, 35, 34, 33, 32, 47, 46, 45, 44, 43, 42, 41, 40, 71, 70, 69, 68, 67, 66, 65, 64, 79, 78, 77, 76, 75, 74, 73, 72, 103, 102, 101, 100, 99, 98, 97, 96, 111, 110, 109, 108, 107, 106, 105, 104>}> : (vector<64xi8>, vector<64xi8>) -> vector<64xi8>
  %266 = "llvm.shufflevector"(%256, %260) <{mask = array<i32: 7, 6, 5, 4, 3, 2, 1, 0, 15, 14, 13, 12, 11, 10, 9, 8, 39, 38, 37, 36, 35, 34, 33, 32, 47, 46, 45, 44, 43, 42, 41, 40, 71, 70, 69, 68, 67, 66, 65, 64, 79, 78, 77, 76, 75, 74, 73, 72, 103, 102, 101, 100, 99, 98, 97, 96, 111, 110, 109, 108, 107, 106, 105, 104>}> : (vector<64xi8>, vector<64xi8>) -> vector<64xi8>
  %267 = "llvm.shufflevector"(%254, %258) <{mask = array<i32: 23, 22, 21, 20, 19, 18, 17, 16, 31, 30, 29, 28, 27, 26, 25, 24, 55, 54, 53, 52, 51, 50, 49, 48, 63, 62, 61, 60, 59, 58, 57, 56, 87, 86, 85, 84, 83, 82, 81, 80, 95, 94, 93, 92, 91, 90, 89, 88, 119, 118, 117, 116, 115, 114, 113, 112, 127, 126, 125, 124, 123, 122, 121, 120>}> : (vector<64xi8>, vector<64xi8>) -> vector<64xi8>
  %268 = "llvm.shufflevector"(%256, %260) <{mask = array<i32: 23, 22, 21, 20, 19, 18, 17, 16, 31, 30, 29, 28, 27, 26, 25, 24, 55, 54, 53, 52, 51, 50, 49, 48, 63, 62, 61, 60, 59, 58, 57, 56, 87, 86, 85, 84, 83, 82, 81, 80, 95, 94, 93, 92, 91, 90, 89, 88, 119, 118, 117, 116, 115, 114, 113, 112, 127, 126, 125, 124, 123, 122, 121, 120>}> : (vector<64xi8>, vector<64xi8>) -> vector<64xi8>
  %269 = "llvm.shufflevector"(%261, %265) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111>}> : (vector<64xi8>, vector<64xi8>) -> vector<64xi8>
  %270 = "llvm.bitcast"(%269) : (vector<64xi8>) -> vector<8xi64>
  %271 = "llvm.shufflevector"(%262, %266) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111>}> : (vector<64xi8>, vector<64xi8>) -> vector<64xi8>
  %272 = "llvm.bitcast"(%271) : (vector<64xi8>) -> vector<8xi64>
  %273 = "llvm.shufflevector"(%263, %267) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111>}> : (vector<64xi8>, vector<64xi8>) -> vector<64xi8>
  %274 = "llvm.bitcast"(%273) : (vector<64xi8>) -> vector<8xi64>
  %275 = "llvm.shufflevector"(%264, %268) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111>}> : (vector<64xi8>, vector<64xi8>) -> vector<64xi8>
  %276 = "llvm.bitcast"(%275) : (vector<64xi8>) -> vector<8xi64>
  %277 = "llvm.shufflevector"(%261, %265) <{mask = array<i32: 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127>}> : (vector<64xi8>, vector<64xi8>) -> vector<64xi8>
  %278 = "llvm.bitcast"(%277) : (vector<64xi8>) -> vector<8xi64>
  %279 = "llvm.shufflevector"(%262, %266) <{mask = array<i32: 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127>}> : (vector<64xi8>, vector<64xi8>) -> vector<64xi8>
  %280 = "llvm.bitcast"(%279) : (vector<64xi8>) -> vector<8xi64>
  %281 = "llvm.shufflevector"(%263, %267) <{mask = array<i32: 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127>}> : (vector<64xi8>, vector<64xi8>) -> vector<64xi8>
  %282 = "llvm.bitcast"(%281) : (vector<64xi8>) -> vector<8xi64>
  %283 = "llvm.shufflevector"(%264, %268) <{mask = array<i32: 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127>}> : (vector<64xi8>, vector<64xi8>) -> vector<64xi8>
  %284 = "llvm.bitcast"(%283) : (vector<64xi8>) -> vector<8xi64>
  %285 = "llvm.shufflevector"(%270, %272) <{mask = array<i32: 0, 8, 2, 10, 4, 12, 6, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %286 = "llvm.shufflevector"(%270, %272) <{mask = array<i32: 1, 9, 3, 11, 5, 13, 7, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %287 = "llvm.shufflevector"(%274, %276) <{mask = array<i32: 0, 8, 2, 10, 4, 12, 6, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %288 = "llvm.shufflevector"(%274, %276) <{mask = array<i32: 1, 9, 3, 11, 5, 13, 7, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %289 = "llvm.shufflevector"(%278, %280) <{mask = array<i32: 0, 8, 2, 10, 4, 12, 6, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %290 = "llvm.shufflevector"(%278, %280) <{mask = array<i32: 1, 9, 3, 11, 5, 13, 7, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %291 = "llvm.shufflevector"(%282, %284) <{mask = array<i32: 0, 8, 2, 10, 4, 12, 6, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %292 = "llvm.shufflevector"(%282, %284) <{mask = array<i32: 1, 9, 3, 11, 5, 13, 7, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %293 = "llvm.intr.fshl"(%180, %180, %37) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %294 = "llvm.intr.fshl"(%180, %180, %38) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %295 = "llvm.intr.fshl"(%180, %180, %39) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %296 = "llvm.xor"(%294, %295) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %297 = "llvm.xor"(%296, %293) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %298 = "llvm.and"(%180, %181) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %299 = "llvm.xor"(%180, %40) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %300 = "llvm.and"(%182, %299) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %301 = "llvm.or"(%298, %300) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %302 = "llvm.add"(%183, %41) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %303 = "llvm.add"(%302, %301) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %304 = "llvm.add"(%303, %297) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %305 = "llvm.add"(%304, %237) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %306 = "llvm.intr.fshl"(%176, %176, %42) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %307 = "llvm.intr.fshl"(%176, %176, %43) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %308 = "llvm.intr.fshl"(%176, %176, %44) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %309 = "llvm.xor"(%307, %308) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %310 = "llvm.xor"(%309, %306) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %311 = "llvm.and"(%176, %177) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %312 = "llvm.xor"(%176, %177) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %313 = "llvm.and"(%312, %178) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %314 = "llvm.xor"(%313, %311) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %315 = "llvm.add"(%310, %314) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %316 = "llvm.add"(%305, %179) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %317 = "llvm.add"(%315, %305) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %318 = "llvm.intr.fshl"(%316, %316, %37) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %319 = "llvm.intr.fshl"(%316, %316, %38) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %320 = "llvm.intr.fshl"(%316, %316, %39) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %321 = "llvm.xor"(%319, %320) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %322 = "llvm.xor"(%321, %318) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %323 = "llvm.and"(%316, %180) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %324 = "llvm.xor"(%316, %40) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %325 = "llvm.and"(%181, %324) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %326 = "llvm.or"(%323, %325) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %327 = "llvm.add"(%182, %45) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %328 = "llvm.add"(%327, %238) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %329 = "llvm.add"(%328, %326) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %330 = "llvm.add"(%329, %322) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %331 = "llvm.intr.fshl"(%317, %317, %42) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %332 = "llvm.intr.fshl"(%317, %317, %43) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %333 = "llvm.intr.fshl"(%317, %317, %44) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %334 = "llvm.xor"(%332, %333) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %335 = "llvm.xor"(%334, %331) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %336 = "llvm.and"(%317, %176) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %337 = "llvm.xor"(%317, %176) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %338 = "llvm.and"(%337, %177) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %339 = "llvm.xor"(%338, %336) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %340 = "llvm.add"(%335, %339) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %341 = "llvm.add"(%330, %178) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %342 = "llvm.add"(%340, %330) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %343 = "llvm.intr.fshl"(%341, %341, %37) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %344 = "llvm.intr.fshl"(%341, %341, %38) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %345 = "llvm.intr.fshl"(%341, %341, %39) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %346 = "llvm.xor"(%344, %345) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %347 = "llvm.xor"(%346, %343) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %348 = "llvm.and"(%341, %316) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %349 = "llvm.xor"(%341, %40) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %350 = "llvm.and"(%180, %349) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %351 = "llvm.or"(%348, %350) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %352 = "llvm.add"(%181, %46) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %353 = "llvm.add"(%352, %239) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %354 = "llvm.add"(%353, %351) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %355 = "llvm.add"(%354, %347) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %356 = "llvm.intr.fshl"(%342, %342, %42) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %357 = "llvm.intr.fshl"(%342, %342, %43) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %358 = "llvm.intr.fshl"(%342, %342, %44) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %359 = "llvm.xor"(%357, %358) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %360 = "llvm.xor"(%359, %356) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %361 = "llvm.and"(%342, %317) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %362 = "llvm.xor"(%342, %317) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %363 = "llvm.and"(%362, %176) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %364 = "llvm.xor"(%363, %361) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %365 = "llvm.add"(%360, %364) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %366 = "llvm.add"(%355, %177) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %367 = "llvm.add"(%365, %355) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %368 = "llvm.intr.fshl"(%366, %366, %37) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %369 = "llvm.intr.fshl"(%366, %366, %38) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %370 = "llvm.intr.fshl"(%366, %366, %39) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %371 = "llvm.xor"(%369, %370) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %372 = "llvm.xor"(%371, %368) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %373 = "llvm.and"(%366, %341) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %374 = "llvm.xor"(%366, %40) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %375 = "llvm.and"(%316, %374) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %376 = "llvm.or"(%373, %375) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %377 = "llvm.add"(%180, %47) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %378 = "llvm.add"(%377, %240) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %379 = "llvm.add"(%378, %376) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %380 = "llvm.add"(%379, %372) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %381 = "llvm.intr.fshl"(%367, %367, %42) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %382 = "llvm.intr.fshl"(%367, %367, %43) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %383 = "llvm.intr.fshl"(%367, %367, %44) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %384 = "llvm.xor"(%382, %383) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %385 = "llvm.xor"(%384, %381) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %386 = "llvm.and"(%367, %342) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %387 = "llvm.xor"(%367, %342) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %388 = "llvm.and"(%387, %317) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %389 = "llvm.xor"(%388, %386) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %390 = "llvm.add"(%385, %389) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %391 = "llvm.add"(%380, %176) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %392 = "llvm.add"(%390, %380) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %393 = "llvm.intr.fshl"(%391, %391, %37) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %394 = "llvm.intr.fshl"(%391, %391, %38) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %395 = "llvm.intr.fshl"(%391, %391, %39) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %396 = "llvm.xor"(%394, %395) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %397 = "llvm.xor"(%396, %393) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %398 = "llvm.and"(%391, %366) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %399 = "llvm.xor"(%391, %40) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %400 = "llvm.and"(%341, %399) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %401 = "llvm.or"(%398, %400) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %402 = "llvm.add"(%241, %48) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %403 = "llvm.add"(%402, %316) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %404 = "llvm.add"(%403, %401) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %405 = "llvm.add"(%404, %397) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %406 = "llvm.intr.fshl"(%392, %392, %42) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %407 = "llvm.intr.fshl"(%392, %392, %43) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %408 = "llvm.intr.fshl"(%392, %392, %44) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %409 = "llvm.xor"(%407, %408) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %410 = "llvm.xor"(%409, %406) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %411 = "llvm.and"(%392, %367) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %412 = "llvm.xor"(%392, %367) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %413 = "llvm.and"(%412, %342) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %414 = "llvm.xor"(%413, %411) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %415 = "llvm.add"(%410, %414) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %416 = "llvm.add"(%405, %317) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %417 = "llvm.add"(%415, %405) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %418 = "llvm.intr.fshl"(%416, %416, %37) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %419 = "llvm.intr.fshl"(%416, %416, %38) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %420 = "llvm.intr.fshl"(%416, %416, %39) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %421 = "llvm.xor"(%419, %420) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %422 = "llvm.xor"(%421, %418) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %423 = "llvm.and"(%416, %391) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %424 = "llvm.xor"(%416, %40) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %425 = "llvm.and"(%366, %424) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %426 = "llvm.or"(%423, %425) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %427 = "llvm.add"(%242, %49) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %428 = "llvm.add"(%427, %341) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %429 = "llvm.add"(%428, %426) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %430 = "llvm.add"(%429, %422) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %431 = "llvm.intr.fshl"(%417, %417, %42) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %432 = "llvm.intr.fshl"(%417, %417, %43) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %433 = "llvm.intr.fshl"(%417, %417, %44) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %434 = "llvm.xor"(%432, %433) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %435 = "llvm.xor"(%434, %431) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %436 = "llvm.and"(%417, %392) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %437 = "llvm.xor"(%417, %392) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %438 = "llvm.and"(%437, %367) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %439 = "llvm.xor"(%438, %436) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %440 = "llvm.add"(%435, %439) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %441 = "llvm.add"(%430, %342) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %442 = "llvm.add"(%440, %430) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %443 = "llvm.intr.fshl"(%441, %441, %37) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %444 = "llvm.intr.fshl"(%441, %441, %38) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %445 = "llvm.intr.fshl"(%441, %441, %39) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %446 = "llvm.xor"(%444, %445) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %447 = "llvm.xor"(%446, %443) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %448 = "llvm.and"(%441, %416) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %449 = "llvm.xor"(%441, %40) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %450 = "llvm.and"(%391, %449) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %451 = "llvm.or"(%448, %450) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %452 = "llvm.add"(%243, %50) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %453 = "llvm.add"(%452, %366) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %454 = "llvm.add"(%453, %451) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %455 = "llvm.add"(%454, %447) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %456 = "llvm.intr.fshl"(%442, %442, %42) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %457 = "llvm.intr.fshl"(%442, %442, %43) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %458 = "llvm.intr.fshl"(%442, %442, %44) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %459 = "llvm.xor"(%457, %458) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %460 = "llvm.xor"(%459, %456) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %461 = "llvm.and"(%442, %417) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %462 = "llvm.xor"(%442, %417) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %463 = "llvm.and"(%462, %392) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %464 = "llvm.xor"(%463, %461) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %465 = "llvm.add"(%460, %464) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %466 = "llvm.add"(%455, %367) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %467 = "llvm.add"(%465, %455) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %468 = "llvm.intr.fshl"(%466, %466, %37) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %469 = "llvm.intr.fshl"(%466, %466, %38) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %470 = "llvm.intr.fshl"(%466, %466, %39) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %471 = "llvm.xor"(%469, %470) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %472 = "llvm.xor"(%471, %468) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %473 = "llvm.and"(%466, %441) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %474 = "llvm.xor"(%466, %40) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %475 = "llvm.and"(%416, %474) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %476 = "llvm.or"(%473, %475) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %477 = "llvm.add"(%244, %51) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %478 = "llvm.add"(%477, %391) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %479 = "llvm.add"(%478, %476) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %480 = "llvm.add"(%479, %472) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %481 = "llvm.intr.fshl"(%467, %467, %42) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %482 = "llvm.intr.fshl"(%467, %467, %43) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %483 = "llvm.intr.fshl"(%467, %467, %44) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %484 = "llvm.xor"(%482, %483) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %485 = "llvm.xor"(%484, %481) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %486 = "llvm.and"(%467, %442) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %487 = "llvm.xor"(%467, %442) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %488 = "llvm.and"(%487, %417) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %489 = "llvm.xor"(%488, %486) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %490 = "llvm.add"(%485, %489) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %491 = "llvm.add"(%480, %392) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %492 = "llvm.add"(%490, %480) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %493 = "llvm.intr.fshl"(%491, %491, %37) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %494 = "llvm.intr.fshl"(%491, %491, %38) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %495 = "llvm.intr.fshl"(%491, %491, %39) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %496 = "llvm.xor"(%494, %495) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %497 = "llvm.xor"(%496, %493) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %498 = "llvm.and"(%491, %466) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %499 = "llvm.xor"(%491, %40) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %500 = "llvm.and"(%441, %499) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %501 = "llvm.or"(%498, %500) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %502 = "llvm.add"(%285, %52) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %503 = "llvm.add"(%502, %416) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %504 = "llvm.add"(%503, %501) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %505 = "llvm.add"(%504, %497) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %506 = "llvm.intr.fshl"(%492, %492, %42) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %507 = "llvm.intr.fshl"(%492, %492, %43) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %508 = "llvm.intr.fshl"(%492, %492, %44) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %509 = "llvm.xor"(%507, %508) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %510 = "llvm.xor"(%509, %506) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %511 = "llvm.and"(%492, %467) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %512 = "llvm.xor"(%492, %467) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %513 = "llvm.and"(%512, %442) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %514 = "llvm.xor"(%513, %511) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %515 = "llvm.add"(%510, %514) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %516 = "llvm.add"(%505, %417) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %517 = "llvm.add"(%515, %505) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %518 = "llvm.intr.fshl"(%516, %516, %37) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %519 = "llvm.intr.fshl"(%516, %516, %38) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %520 = "llvm.intr.fshl"(%516, %516, %39) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %521 = "llvm.xor"(%519, %520) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %522 = "llvm.xor"(%521, %518) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %523 = "llvm.and"(%516, %491) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %524 = "llvm.xor"(%516, %40) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %525 = "llvm.and"(%466, %524) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %526 = "llvm.or"(%523, %525) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %527 = "llvm.add"(%286, %53) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %528 = "llvm.add"(%527, %441) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %529 = "llvm.add"(%528, %526) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %530 = "llvm.add"(%529, %522) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %531 = "llvm.intr.fshl"(%517, %517, %42) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %532 = "llvm.intr.fshl"(%517, %517, %43) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %533 = "llvm.intr.fshl"(%517, %517, %44) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %534 = "llvm.xor"(%532, %533) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %535 = "llvm.xor"(%534, %531) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %536 = "llvm.and"(%517, %492) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %537 = "llvm.xor"(%517, %492) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %538 = "llvm.and"(%537, %467) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %539 = "llvm.xor"(%538, %536) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %540 = "llvm.add"(%535, %539) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %541 = "llvm.add"(%530, %442) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %542 = "llvm.add"(%540, %530) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %543 = "llvm.intr.fshl"(%541, %541, %37) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %544 = "llvm.intr.fshl"(%541, %541, %38) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %545 = "llvm.intr.fshl"(%541, %541, %39) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %546 = "llvm.xor"(%544, %545) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %547 = "llvm.xor"(%546, %543) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %548 = "llvm.and"(%541, %516) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %549 = "llvm.xor"(%541, %40) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %550 = "llvm.and"(%491, %549) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %551 = "llvm.or"(%548, %550) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %552 = "llvm.add"(%287, %54) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %553 = "llvm.add"(%552, %466) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %554 = "llvm.add"(%553, %551) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %555 = "llvm.add"(%554, %547) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %556 = "llvm.intr.fshl"(%542, %542, %42) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %557 = "llvm.intr.fshl"(%542, %542, %43) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %558 = "llvm.intr.fshl"(%542, %542, %44) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %559 = "llvm.xor"(%557, %558) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %560 = "llvm.xor"(%559, %556) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %561 = "llvm.and"(%542, %517) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %562 = "llvm.xor"(%542, %517) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %563 = "llvm.and"(%562, %492) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %564 = "llvm.xor"(%563, %561) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %565 = "llvm.add"(%560, %564) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %566 = "llvm.add"(%555, %467) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %567 = "llvm.add"(%565, %555) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %568 = "llvm.intr.fshl"(%566, %566, %37) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %569 = "llvm.intr.fshl"(%566, %566, %38) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %570 = "llvm.intr.fshl"(%566, %566, %39) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %571 = "llvm.xor"(%569, %570) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %572 = "llvm.xor"(%571, %568) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %573 = "llvm.and"(%566, %541) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %574 = "llvm.xor"(%566, %40) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %575 = "llvm.and"(%516, %574) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %576 = "llvm.or"(%573, %575) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %577 = "llvm.add"(%288, %55) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %578 = "llvm.add"(%577, %491) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %579 = "llvm.add"(%578, %576) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %580 = "llvm.add"(%579, %572) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %581 = "llvm.intr.fshl"(%567, %567, %42) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %582 = "llvm.intr.fshl"(%567, %567, %43) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %583 = "llvm.intr.fshl"(%567, %567, %44) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %584 = "llvm.xor"(%582, %583) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %585 = "llvm.xor"(%584, %581) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %586 = "llvm.and"(%567, %542) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %587 = "llvm.xor"(%567, %542) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %588 = "llvm.and"(%587, %517) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %589 = "llvm.xor"(%588, %586) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %590 = "llvm.add"(%585, %589) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %591 = "llvm.add"(%580, %492) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %592 = "llvm.add"(%590, %580) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %593 = "llvm.intr.fshl"(%591, %591, %37) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %594 = "llvm.intr.fshl"(%591, %591, %38) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %595 = "llvm.intr.fshl"(%591, %591, %39) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %596 = "llvm.xor"(%594, %595) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %597 = "llvm.xor"(%596, %593) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %598 = "llvm.and"(%591, %566) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %599 = "llvm.xor"(%591, %40) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %600 = "llvm.and"(%541, %599) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %601 = "llvm.or"(%598, %600) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %602 = "llvm.add"(%289, %56) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %603 = "llvm.add"(%602, %516) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %604 = "llvm.add"(%603, %601) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %605 = "llvm.add"(%604, %597) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %606 = "llvm.intr.fshl"(%592, %592, %42) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %607 = "llvm.intr.fshl"(%592, %592, %43) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %608 = "llvm.intr.fshl"(%592, %592, %44) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %609 = "llvm.xor"(%607, %608) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %610 = "llvm.xor"(%609, %606) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %611 = "llvm.and"(%592, %567) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %612 = "llvm.xor"(%592, %567) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %613 = "llvm.and"(%612, %542) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %614 = "llvm.xor"(%613, %611) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %615 = "llvm.add"(%610, %614) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %616 = "llvm.add"(%605, %517) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %617 = "llvm.add"(%615, %605) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %618 = "llvm.intr.fshl"(%616, %616, %37) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %619 = "llvm.intr.fshl"(%616, %616, %38) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %620 = "llvm.intr.fshl"(%616, %616, %39) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %621 = "llvm.xor"(%619, %620) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %622 = "llvm.xor"(%621, %618) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %623 = "llvm.and"(%616, %591) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %624 = "llvm.xor"(%616, %40) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %625 = "llvm.and"(%566, %624) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %626 = "llvm.or"(%623, %625) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %627 = "llvm.add"(%290, %57) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %628 = "llvm.add"(%627, %541) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %629 = "llvm.add"(%628, %626) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %630 = "llvm.add"(%629, %622) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %631 = "llvm.intr.fshl"(%617, %617, %42) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %632 = "llvm.intr.fshl"(%617, %617, %43) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %633 = "llvm.intr.fshl"(%617, %617, %44) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %634 = "llvm.xor"(%632, %633) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %635 = "llvm.xor"(%634, %631) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %636 = "llvm.and"(%617, %592) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %637 = "llvm.xor"(%617, %592) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %638 = "llvm.and"(%637, %567) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %639 = "llvm.xor"(%638, %636) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %640 = "llvm.add"(%635, %639) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %641 = "llvm.add"(%630, %542) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %642 = "llvm.add"(%640, %630) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %643 = "llvm.intr.fshl"(%641, %641, %37) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %644 = "llvm.intr.fshl"(%641, %641, %38) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %645 = "llvm.intr.fshl"(%641, %641, %39) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %646 = "llvm.xor"(%644, %645) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %647 = "llvm.xor"(%646, %643) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %648 = "llvm.and"(%641, %616) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %649 = "llvm.xor"(%641, %40) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %650 = "llvm.and"(%591, %649) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %651 = "llvm.or"(%648, %650) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %652 = "llvm.add"(%291, %58) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %653 = "llvm.add"(%652, %566) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %654 = "llvm.add"(%653, %651) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %655 = "llvm.add"(%654, %647) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %656 = "llvm.intr.fshl"(%642, %642, %42) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %657 = "llvm.intr.fshl"(%642, %642, %43) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %658 = "llvm.intr.fshl"(%642, %642, %44) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %659 = "llvm.xor"(%657, %658) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %660 = "llvm.xor"(%659, %656) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %661 = "llvm.and"(%642, %617) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %662 = "llvm.xor"(%642, %617) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %663 = "llvm.and"(%662, %592) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %664 = "llvm.xor"(%663, %661) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %665 = "llvm.add"(%660, %664) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %666 = "llvm.add"(%655, %567) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %667 = "llvm.add"(%665, %655) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %668 = "llvm.intr.fshl"(%666, %666, %37) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %669 = "llvm.intr.fshl"(%666, %666, %38) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %670 = "llvm.intr.fshl"(%666, %666, %39) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %671 = "llvm.xor"(%669, %670) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %672 = "llvm.xor"(%671, %668) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %673 = "llvm.and"(%666, %641) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %674 = "llvm.xor"(%666, %40) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %675 = "llvm.and"(%616, %674) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %676 = "llvm.or"(%673, %675) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %677 = "llvm.add"(%292, %59) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %678 = "llvm.add"(%677, %591) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %679 = "llvm.add"(%678, %676) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %680 = "llvm.add"(%679, %672) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %681 = "llvm.intr.fshl"(%667, %667, %42) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %682 = "llvm.intr.fshl"(%667, %667, %43) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %683 = "llvm.intr.fshl"(%667, %667, %44) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %684 = "llvm.xor"(%682, %683) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %685 = "llvm.xor"(%684, %681) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %686 = "llvm.and"(%667, %642) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %687 = "llvm.xor"(%667, %642) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %688 = "llvm.and"(%687, %617) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %689 = "llvm.xor"(%688, %686) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %690 = "llvm.add"(%685, %689) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %691 = "llvm.add"(%680, %592) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %692 = "llvm.add"(%690, %680) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.br"(%237, %60, %616, %641, %666, %691, %617, %642, %667, %692, %238, %239, %240, %241, %242, %243, %244, %285, %286, %287, %288, %289, %290, %291, %292)[^bb17] : (vector<8xi64>, i64, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>) -> ()
^bb17(%693: vector<8xi64>, %694: i64, %695: vector<8xi64>, %696: vector<8xi64>, %697: vector<8xi64>, %698: vector<8xi64>, %699: vector<8xi64>, %700: vector<8xi64>, %701: vector<8xi64>, %702: vector<8xi64>, %703: vector<8xi64>, %704: vector<8xi64>, %705: vector<8xi64>, %706: vector<8xi64>, %707: vector<8xi64>, %708: vector<8xi64>, %709: vector<8xi64>, %710: vector<8xi64>, %711: vector<8xi64>, %712: vector<8xi64>, %713: vector<8xi64>, %714: vector<8xi64>, %715: vector<8xi64>, %716: vector<8xi64>, %717: vector<8xi64>):  // 2 preds: ^bb16, ^bb17
  %718 = "llvm.intr.fshl"(%703, %703, %61) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %719 = "llvm.intr.fshl"(%703, %703, %62) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %720 = "llvm.lshr"(%703, %26) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %721 = "llvm.xor"(%719, %720) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %722 = "llvm.xor"(%721, %718) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %723 = "llvm.intr.fshl"(%716, %716, %63) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %724 = "llvm.intr.fshl"(%716, %716, %64) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %725 = "llvm.lshr"(%716, %65) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %726 = "llvm.xor"(%724, %725) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %727 = "llvm.xor"(%726, %723) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %728 = "llvm.add"(%711, %727) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %729 = "llvm.add"(%728, %722) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %730 = "llvm.add"(%729, %693) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %731 = "llvm.getelementptr"(%66, %694) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %732 = "llvm.load"(%731) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %733 = "llvm.insertelement"(%23, %732, %2) : (vector<8xi64>, i64, i64) -> vector<8xi64>
  %734 = "llvm.shufflevector"(%733, %23) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %735 = "llvm.intr.fshl"(%698, %698, %37) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %736 = "llvm.intr.fshl"(%698, %698, %38) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %737 = "llvm.intr.fshl"(%698, %698, %39) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %738 = "llvm.xor"(%736, %737) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %739 = "llvm.xor"(%738, %735) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %740 = "llvm.and"(%697, %698) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %741 = "llvm.xor"(%698, %40) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %742 = "llvm.and"(%696, %741) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %743 = "llvm.or"(%742, %740) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %744 = "llvm.add"(%695, %739) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %745 = "llvm.add"(%744, %743) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %746 = "llvm.add"(%745, %730) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %747 = "llvm.add"(%746, %734) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %748 = "llvm.intr.fshl"(%702, %702, %42) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %749 = "llvm.intr.fshl"(%702, %702, %43) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %750 = "llvm.intr.fshl"(%702, %702, %44) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %751 = "llvm.xor"(%749, %750) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %752 = "llvm.xor"(%751, %748) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %753 = "llvm.and"(%701, %702) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %754 = "llvm.xor"(%701, %702) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %755 = "llvm.and"(%754, %700) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %756 = "llvm.xor"(%755, %753) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %757 = "llvm.add"(%756, %752) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %758 = "llvm.add"(%747, %699) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %759 = "llvm.add"(%757, %747) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %760 = "llvm.intr.fshl"(%704, %704, %61) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %761 = "llvm.intr.fshl"(%704, %704, %62) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %762 = "llvm.lshr"(%704, %26) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %763 = "llvm.xor"(%761, %762) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %764 = "llvm.xor"(%763, %760) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %765 = "llvm.intr.fshl"(%717, %717, %63) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %766 = "llvm.intr.fshl"(%717, %717, %64) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %767 = "llvm.lshr"(%717, %65) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %768 = "llvm.xor"(%766, %767) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %769 = "llvm.xor"(%768, %765) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %770 = "llvm.add"(%712, %769) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %771 = "llvm.add"(%770, %703) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %772 = "llvm.add"(%771, %764) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %773 = "llvm.getelementptr"(%731) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %774 = "llvm.load"(%773) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %775 = "llvm.insertelement"(%23, %774, %2) : (vector<8xi64>, i64, i64) -> vector<8xi64>
  %776 = "llvm.shufflevector"(%775, %23) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %777 = "llvm.intr.fshl"(%758, %758, %37) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %778 = "llvm.intr.fshl"(%758, %758, %38) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %779 = "llvm.intr.fshl"(%758, %758, %39) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %780 = "llvm.xor"(%778, %779) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %781 = "llvm.xor"(%780, %777) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %782 = "llvm.and"(%758, %698) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %783 = "llvm.xor"(%758, %40) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %784 = "llvm.and"(%697, %783) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %785 = "llvm.or"(%782, %784) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %786 = "llvm.add"(%696, %772) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %787 = "llvm.add"(%786, %776) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %788 = "llvm.add"(%787, %785) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %789 = "llvm.add"(%788, %781) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %790 = "llvm.intr.fshl"(%759, %759, %42) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %791 = "llvm.intr.fshl"(%759, %759, %43) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %792 = "llvm.intr.fshl"(%759, %759, %44) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %793 = "llvm.xor"(%791, %792) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %794 = "llvm.xor"(%793, %790) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %795 = "llvm.and"(%759, %702) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %796 = "llvm.xor"(%759, %702) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %797 = "llvm.and"(%796, %701) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %798 = "llvm.xor"(%797, %795) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %799 = "llvm.add"(%794, %798) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %800 = "llvm.add"(%789, %700) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %801 = "llvm.add"(%799, %789) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %802 = "llvm.intr.fshl"(%705, %705, %61) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %803 = "llvm.intr.fshl"(%705, %705, %62) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %804 = "llvm.lshr"(%705, %26) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %805 = "llvm.xor"(%803, %804) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %806 = "llvm.xor"(%805, %802) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %807 = "llvm.intr.fshl"(%730, %730, %63) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %808 = "llvm.intr.fshl"(%730, %730, %64) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %809 = "llvm.lshr"(%730, %65) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %810 = "llvm.xor"(%808, %809) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %811 = "llvm.xor"(%810, %807) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %812 = "llvm.add"(%704, %713) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %813 = "llvm.add"(%812, %806) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %814 = "llvm.add"(%813, %811) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %815 = "llvm.getelementptr"(%731) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %816 = "llvm.load"(%815) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %817 = "llvm.insertelement"(%23, %816, %2) : (vector<8xi64>, i64, i64) -> vector<8xi64>
  %818 = "llvm.shufflevector"(%817, %23) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %819 = "llvm.intr.fshl"(%800, %800, %37) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %820 = "llvm.intr.fshl"(%800, %800, %38) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %821 = "llvm.intr.fshl"(%800, %800, %39) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %822 = "llvm.xor"(%820, %821) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %823 = "llvm.xor"(%822, %819) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %824 = "llvm.and"(%800, %758) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %825 = "llvm.xor"(%800, %40) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %826 = "llvm.and"(%698, %825) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %827 = "llvm.or"(%824, %826) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %828 = "llvm.add"(%814, %697) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %829 = "llvm.add"(%828, %818) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %830 = "llvm.add"(%829, %827) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %831 = "llvm.add"(%830, %823) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %832 = "llvm.intr.fshl"(%801, %801, %42) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %833 = "llvm.intr.fshl"(%801, %801, %43) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %834 = "llvm.intr.fshl"(%801, %801, %44) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %835 = "llvm.xor"(%833, %834) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %836 = "llvm.xor"(%835, %832) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %837 = "llvm.and"(%801, %759) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %838 = "llvm.xor"(%801, %759) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %839 = "llvm.and"(%838, %702) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %840 = "llvm.xor"(%839, %837) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %841 = "llvm.add"(%836, %840) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %842 = "llvm.add"(%831, %701) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %843 = "llvm.add"(%841, %831) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %844 = "llvm.intr.fshl"(%706, %706, %61) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %845 = "llvm.intr.fshl"(%706, %706, %62) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %846 = "llvm.lshr"(%706, %26) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %847 = "llvm.xor"(%845, %846) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %848 = "llvm.xor"(%847, %844) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %849 = "llvm.intr.fshl"(%772, %772, %63) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %850 = "llvm.intr.fshl"(%772, %772, %64) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %851 = "llvm.lshr"(%772, %65) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %852 = "llvm.xor"(%850, %851) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %853 = "llvm.xor"(%852, %849) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %854 = "llvm.add"(%705, %714) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %855 = "llvm.add"(%854, %848) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %856 = "llvm.add"(%855, %853) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %857 = "llvm.getelementptr"(%731) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %858 = "llvm.load"(%857) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %859 = "llvm.insertelement"(%23, %858, %2) : (vector<8xi64>, i64, i64) -> vector<8xi64>
  %860 = "llvm.shufflevector"(%859, %23) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %861 = "llvm.intr.fshl"(%842, %842, %37) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %862 = "llvm.intr.fshl"(%842, %842, %38) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %863 = "llvm.intr.fshl"(%842, %842, %39) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %864 = "llvm.xor"(%862, %863) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %865 = "llvm.xor"(%864, %861) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %866 = "llvm.and"(%842, %800) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %867 = "llvm.xor"(%842, %40) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %868 = "llvm.and"(%758, %867) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %869 = "llvm.or"(%866, %868) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %870 = "llvm.add"(%856, %698) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %871 = "llvm.add"(%870, %860) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %872 = "llvm.add"(%871, %869) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %873 = "llvm.add"(%872, %865) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %874 = "llvm.intr.fshl"(%843, %843, %42) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %875 = "llvm.intr.fshl"(%843, %843, %43) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %876 = "llvm.intr.fshl"(%843, %843, %44) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %877 = "llvm.xor"(%875, %876) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %878 = "llvm.xor"(%877, %874) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %879 = "llvm.and"(%843, %801) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %880 = "llvm.xor"(%843, %801) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %881 = "llvm.and"(%880, %759) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %882 = "llvm.xor"(%881, %879) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %883 = "llvm.add"(%878, %882) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %884 = "llvm.add"(%873, %702) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %885 = "llvm.add"(%883, %873) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %886 = "llvm.intr.fshl"(%707, %707, %61) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %887 = "llvm.intr.fshl"(%707, %707, %62) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %888 = "llvm.lshr"(%707, %26) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %889 = "llvm.xor"(%887, %888) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %890 = "llvm.xor"(%889, %886) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %891 = "llvm.intr.fshl"(%814, %814, %63) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %892 = "llvm.intr.fshl"(%814, %814, %64) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %893 = "llvm.lshr"(%814, %65) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %894 = "llvm.xor"(%892, %893) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %895 = "llvm.xor"(%894, %891) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %896 = "llvm.add"(%706, %715) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %897 = "llvm.add"(%896, %890) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %898 = "llvm.add"(%897, %895) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %899 = "llvm.getelementptr"(%731) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %900 = "llvm.load"(%899) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %901 = "llvm.insertelement"(%23, %900, %2) : (vector<8xi64>, i64, i64) -> vector<8xi64>
  %902 = "llvm.shufflevector"(%901, %23) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %903 = "llvm.intr.fshl"(%884, %884, %37) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %904 = "llvm.intr.fshl"(%884, %884, %38) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %905 = "llvm.intr.fshl"(%884, %884, %39) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %906 = "llvm.xor"(%904, %905) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %907 = "llvm.xor"(%906, %903) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %908 = "llvm.and"(%884, %842) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %909 = "llvm.xor"(%884, %40) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %910 = "llvm.and"(%800, %909) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %911 = "llvm.or"(%908, %910) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %912 = "llvm.add"(%758, %898) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %913 = "llvm.add"(%912, %902) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %914 = "llvm.add"(%913, %911) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %915 = "llvm.add"(%914, %907) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %916 = "llvm.intr.fshl"(%885, %885, %42) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %917 = "llvm.intr.fshl"(%885, %885, %43) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %918 = "llvm.intr.fshl"(%885, %885, %44) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %919 = "llvm.xor"(%917, %918) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %920 = "llvm.xor"(%919, %916) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %921 = "llvm.and"(%885, %843) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %922 = "llvm.xor"(%885, %843) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %923 = "llvm.and"(%922, %801) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %924 = "llvm.xor"(%923, %921) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %925 = "llvm.add"(%920, %924) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %926 = "llvm.add"(%915, %759) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %927 = "llvm.add"(%925, %915) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %928 = "llvm.intr.fshl"(%708, %708, %61) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %929 = "llvm.intr.fshl"(%708, %708, %62) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %930 = "llvm.lshr"(%708, %26) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %931 = "llvm.xor"(%929, %930) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %932 = "llvm.xor"(%931, %928) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %933 = "llvm.intr.fshl"(%856, %856, %63) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %934 = "llvm.intr.fshl"(%856, %856, %64) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %935 = "llvm.lshr"(%856, %65) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %936 = "llvm.xor"(%934, %935) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %937 = "llvm.xor"(%936, %933) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %938 = "llvm.add"(%707, %716) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %939 = "llvm.add"(%938, %932) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %940 = "llvm.add"(%939, %937) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %941 = "llvm.getelementptr"(%731) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 40>}> : (!llvm.ptr) -> !llvm.ptr
  %942 = "llvm.load"(%941) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %943 = "llvm.insertelement"(%23, %942, %2) : (vector<8xi64>, i64, i64) -> vector<8xi64>
  %944 = "llvm.shufflevector"(%943, %23) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %945 = "llvm.intr.fshl"(%926, %926, %37) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %946 = "llvm.intr.fshl"(%926, %926, %38) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %947 = "llvm.intr.fshl"(%926, %926, %39) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %948 = "llvm.xor"(%946, %947) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %949 = "llvm.xor"(%948, %945) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %950 = "llvm.and"(%926, %884) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %951 = "llvm.xor"(%926, %40) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %952 = "llvm.and"(%842, %951) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %953 = "llvm.or"(%950, %952) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %954 = "llvm.add"(%944, %940) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %955 = "llvm.add"(%954, %800) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %956 = "llvm.add"(%955, %953) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %957 = "llvm.add"(%956, %949) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %958 = "llvm.intr.fshl"(%927, %927, %42) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %959 = "llvm.intr.fshl"(%927, %927, %43) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %960 = "llvm.intr.fshl"(%927, %927, %44) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %961 = "llvm.xor"(%959, %960) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %962 = "llvm.xor"(%961, %958) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %963 = "llvm.and"(%927, %885) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %964 = "llvm.xor"(%927, %885) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %965 = "llvm.and"(%964, %843) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %966 = "llvm.xor"(%965, %963) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %967 = "llvm.add"(%962, %966) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %968 = "llvm.add"(%957, %801) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %969 = "llvm.add"(%967, %957) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %970 = "llvm.intr.fshl"(%709, %709, %61) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %971 = "llvm.intr.fshl"(%709, %709, %62) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %972 = "llvm.lshr"(%709, %26) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %973 = "llvm.xor"(%971, %972) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %974 = "llvm.xor"(%973, %970) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %975 = "llvm.intr.fshl"(%898, %898, %63) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %976 = "llvm.intr.fshl"(%898, %898, %64) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %977 = "llvm.lshr"(%898, %65) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %978 = "llvm.xor"(%976, %977) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %979 = "llvm.xor"(%978, %975) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %980 = "llvm.add"(%708, %717) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %981 = "llvm.add"(%980, %974) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %982 = "llvm.add"(%981, %979) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %983 = "llvm.getelementptr"(%731) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 48>}> : (!llvm.ptr) -> !llvm.ptr
  %984 = "llvm.load"(%983) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %985 = "llvm.insertelement"(%23, %984, %2) : (vector<8xi64>, i64, i64) -> vector<8xi64>
  %986 = "llvm.shufflevector"(%985, %23) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %987 = "llvm.intr.fshl"(%968, %968, %37) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %988 = "llvm.intr.fshl"(%968, %968, %38) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %989 = "llvm.intr.fshl"(%968, %968, %39) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %990 = "llvm.xor"(%988, %989) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %991 = "llvm.xor"(%990, %987) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %992 = "llvm.and"(%968, %926) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %993 = "llvm.xor"(%968, %40) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %994 = "llvm.and"(%884, %993) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %995 = "llvm.or"(%992, %994) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %996 = "llvm.add"(%986, %982) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %997 = "llvm.add"(%996, %842) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %998 = "llvm.add"(%997, %995) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %999 = "llvm.add"(%998, %991) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1000 = "llvm.intr.fshl"(%969, %969, %42) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1001 = "llvm.intr.fshl"(%969, %969, %43) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1002 = "llvm.intr.fshl"(%969, %969, %44) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1003 = "llvm.xor"(%1001, %1002) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1004 = "llvm.xor"(%1003, %1000) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1005 = "llvm.and"(%969, %927) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1006 = "llvm.xor"(%969, %927) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1007 = "llvm.and"(%1006, %885) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1008 = "llvm.xor"(%1007, %1005) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1009 = "llvm.add"(%1004, %1008) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1010 = "llvm.add"(%999, %843) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1011 = "llvm.add"(%1009, %999) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1012 = "llvm.intr.fshl"(%710, %710, %61) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1013 = "llvm.intr.fshl"(%710, %710, %62) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1014 = "llvm.lshr"(%710, %26) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1015 = "llvm.xor"(%1013, %1014) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1016 = "llvm.xor"(%1015, %1012) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1017 = "llvm.intr.fshl"(%940, %940, %63) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1018 = "llvm.intr.fshl"(%940, %940, %64) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1019 = "llvm.lshr"(%940, %65) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1020 = "llvm.xor"(%1018, %1019) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1021 = "llvm.xor"(%1020, %1017) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1022 = "llvm.add"(%1016, %709) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1023 = "llvm.add"(%1022, %730) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1024 = "llvm.add"(%1023, %1021) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1025 = "llvm.getelementptr"(%731) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 56>}> : (!llvm.ptr) -> !llvm.ptr
  %1026 = "llvm.load"(%1025) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %1027 = "llvm.insertelement"(%23, %1026, %2) : (vector<8xi64>, i64, i64) -> vector<8xi64>
  %1028 = "llvm.shufflevector"(%1027, %23) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1029 = "llvm.intr.fshl"(%1010, %1010, %37) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1030 = "llvm.intr.fshl"(%1010, %1010, %38) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1031 = "llvm.intr.fshl"(%1010, %1010, %39) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1032 = "llvm.xor"(%1030, %1031) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1033 = "llvm.xor"(%1032, %1029) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1034 = "llvm.and"(%1010, %968) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1035 = "llvm.xor"(%1010, %40) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1036 = "llvm.and"(%926, %1035) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1037 = "llvm.or"(%1034, %1036) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1038 = "llvm.add"(%1028, %1024) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1039 = "llvm.add"(%1038, %884) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1040 = "llvm.add"(%1039, %1037) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1041 = "llvm.add"(%1040, %1033) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1042 = "llvm.intr.fshl"(%1011, %1011, %42) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1043 = "llvm.intr.fshl"(%1011, %1011, %43) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1044 = "llvm.intr.fshl"(%1011, %1011, %44) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1045 = "llvm.xor"(%1043, %1044) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1046 = "llvm.xor"(%1045, %1042) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1047 = "llvm.and"(%1011, %969) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1048 = "llvm.xor"(%1011, %969) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1049 = "llvm.and"(%1048, %927) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1050 = "llvm.xor"(%1049, %1047) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1051 = "llvm.add"(%1046, %1050) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1052 = "llvm.add"(%1041, %885) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1053 = "llvm.add"(%1051, %1041) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1054 = "llvm.intr.fshl"(%711, %711, %61) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1055 = "llvm.intr.fshl"(%711, %711, %62) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1056 = "llvm.lshr"(%711, %26) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1057 = "llvm.xor"(%1055, %1056) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1058 = "llvm.xor"(%1057, %1054) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1059 = "llvm.intr.fshl"(%982, %982, %63) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1060 = "llvm.intr.fshl"(%982, %982, %64) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1061 = "llvm.lshr"(%982, %65) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1062 = "llvm.xor"(%1060, %1061) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1063 = "llvm.xor"(%1062, %1059) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1064 = "llvm.add"(%1058, %710) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1065 = "llvm.add"(%1064, %772) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1066 = "llvm.add"(%1065, %1063) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1067 = "llvm.getelementptr"(%731) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %1068 = "llvm.load"(%1067) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %1069 = "llvm.insertelement"(%23, %1068, %2) : (vector<8xi64>, i64, i64) -> vector<8xi64>
  %1070 = "llvm.shufflevector"(%1069, %23) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1071 = "llvm.intr.fshl"(%1052, %1052, %37) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1072 = "llvm.intr.fshl"(%1052, %1052, %38) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1073 = "llvm.intr.fshl"(%1052, %1052, %39) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1074 = "llvm.xor"(%1072, %1073) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1075 = "llvm.xor"(%1074, %1071) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1076 = "llvm.and"(%1052, %1010) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1077 = "llvm.xor"(%1052, %40) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1078 = "llvm.and"(%968, %1077) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1079 = "llvm.or"(%1076, %1078) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1080 = "llvm.add"(%1070, %1066) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1081 = "llvm.add"(%1080, %926) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1082 = "llvm.add"(%1081, %1079) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1083 = "llvm.add"(%1082, %1075) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1084 = "llvm.intr.fshl"(%1053, %1053, %42) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1085 = "llvm.intr.fshl"(%1053, %1053, %43) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1086 = "llvm.intr.fshl"(%1053, %1053, %44) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1087 = "llvm.xor"(%1085, %1086) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1088 = "llvm.xor"(%1087, %1084) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1089 = "llvm.and"(%1053, %1011) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1090 = "llvm.xor"(%1053, %1011) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1091 = "llvm.and"(%1090, %969) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1092 = "llvm.xor"(%1091, %1089) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1093 = "llvm.add"(%1088, %1092) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1094 = "llvm.add"(%1083, %927) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1095 = "llvm.add"(%1093, %1083) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1096 = "llvm.intr.fshl"(%712, %712, %61) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1097 = "llvm.intr.fshl"(%712, %712, %62) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1098 = "llvm.lshr"(%712, %26) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1099 = "llvm.xor"(%1097, %1098) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1100 = "llvm.xor"(%1099, %1096) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1101 = "llvm.intr.fshl"(%1024, %1024, %63) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1102 = "llvm.intr.fshl"(%1024, %1024, %64) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1103 = "llvm.lshr"(%1024, %65) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1104 = "llvm.xor"(%1102, %1103) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1105 = "llvm.xor"(%1104, %1101) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1106 = "llvm.add"(%1100, %711) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1107 = "llvm.add"(%1106, %814) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1108 = "llvm.add"(%1107, %1105) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1109 = "llvm.getelementptr"(%731) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 72>}> : (!llvm.ptr) -> !llvm.ptr
  %1110 = "llvm.load"(%1109) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %1111 = "llvm.insertelement"(%23, %1110, %2) : (vector<8xi64>, i64, i64) -> vector<8xi64>
  %1112 = "llvm.shufflevector"(%1111, %23) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1113 = "llvm.intr.fshl"(%1094, %1094, %37) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1114 = "llvm.intr.fshl"(%1094, %1094, %38) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1115 = "llvm.intr.fshl"(%1094, %1094, %39) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1116 = "llvm.xor"(%1114, %1115) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1117 = "llvm.xor"(%1116, %1113) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1118 = "llvm.and"(%1094, %1052) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1119 = "llvm.xor"(%1094, %40) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1120 = "llvm.and"(%1010, %1119) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1121 = "llvm.or"(%1118, %1120) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1122 = "llvm.add"(%1112, %1108) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1123 = "llvm.add"(%1122, %968) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1124 = "llvm.add"(%1123, %1121) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1125 = "llvm.add"(%1124, %1117) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1126 = "llvm.intr.fshl"(%1095, %1095, %42) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1127 = "llvm.intr.fshl"(%1095, %1095, %43) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1128 = "llvm.intr.fshl"(%1095, %1095, %44) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1129 = "llvm.xor"(%1127, %1128) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1130 = "llvm.xor"(%1129, %1126) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1131 = "llvm.and"(%1095, %1053) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1132 = "llvm.xor"(%1095, %1053) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1133 = "llvm.and"(%1132, %1011) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1134 = "llvm.xor"(%1133, %1131) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1135 = "llvm.add"(%1130, %1134) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1136 = "llvm.add"(%1125, %969) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1137 = "llvm.add"(%1135, %1125) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1138 = "llvm.intr.fshl"(%713, %713, %61) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1139 = "llvm.intr.fshl"(%713, %713, %62) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1140 = "llvm.lshr"(%713, %26) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1141 = "llvm.xor"(%1139, %1140) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1142 = "llvm.xor"(%1141, %1138) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1143 = "llvm.intr.fshl"(%1066, %1066, %63) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1144 = "llvm.intr.fshl"(%1066, %1066, %64) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1145 = "llvm.lshr"(%1066, %65) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1146 = "llvm.xor"(%1144, %1145) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1147 = "llvm.xor"(%1146, %1143) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1148 = "llvm.add"(%1142, %712) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1149 = "llvm.add"(%1148, %856) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1150 = "llvm.add"(%1149, %1147) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1151 = "llvm.getelementptr"(%731) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 80>}> : (!llvm.ptr) -> !llvm.ptr
  %1152 = "llvm.load"(%1151) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %1153 = "llvm.insertelement"(%23, %1152, %2) : (vector<8xi64>, i64, i64) -> vector<8xi64>
  %1154 = "llvm.shufflevector"(%1153, %23) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1155 = "llvm.intr.fshl"(%1136, %1136, %37) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1156 = "llvm.intr.fshl"(%1136, %1136, %38) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1157 = "llvm.intr.fshl"(%1136, %1136, %39) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1158 = "llvm.xor"(%1156, %1157) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1159 = "llvm.xor"(%1158, %1155) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1160 = "llvm.and"(%1136, %1094) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1161 = "llvm.xor"(%1136, %40) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1162 = "llvm.and"(%1052, %1161) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1163 = "llvm.or"(%1160, %1162) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1164 = "llvm.add"(%1154, %1150) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1165 = "llvm.add"(%1164, %1010) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1166 = "llvm.add"(%1165, %1163) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1167 = "llvm.add"(%1166, %1159) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1168 = "llvm.intr.fshl"(%1137, %1137, %42) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1169 = "llvm.intr.fshl"(%1137, %1137, %43) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1170 = "llvm.intr.fshl"(%1137, %1137, %44) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1171 = "llvm.xor"(%1169, %1170) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1172 = "llvm.xor"(%1171, %1168) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1173 = "llvm.and"(%1137, %1095) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1174 = "llvm.xor"(%1137, %1095) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1175 = "llvm.and"(%1174, %1053) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1176 = "llvm.xor"(%1175, %1173) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1177 = "llvm.add"(%1172, %1176) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1178 = "llvm.add"(%1167, %1011) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1179 = "llvm.add"(%1177, %1167) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1180 = "llvm.intr.fshl"(%714, %714, %61) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1181 = "llvm.intr.fshl"(%714, %714, %62) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1182 = "llvm.lshr"(%714, %26) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1183 = "llvm.xor"(%1181, %1182) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1184 = "llvm.xor"(%1183, %1180) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1185 = "llvm.intr.fshl"(%1108, %1108, %63) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1186 = "llvm.intr.fshl"(%1108, %1108, %64) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1187 = "llvm.lshr"(%1108, %65) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1188 = "llvm.xor"(%1186, %1187) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1189 = "llvm.xor"(%1188, %1185) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1190 = "llvm.add"(%1184, %713) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1191 = "llvm.add"(%1190, %898) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1192 = "llvm.add"(%1191, %1189) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1193 = "llvm.getelementptr"(%731) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 88>}> : (!llvm.ptr) -> !llvm.ptr
  %1194 = "llvm.load"(%1193) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %1195 = "llvm.insertelement"(%23, %1194, %2) : (vector<8xi64>, i64, i64) -> vector<8xi64>
  %1196 = "llvm.shufflevector"(%1195, %23) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1197 = "llvm.intr.fshl"(%1178, %1178, %37) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1198 = "llvm.intr.fshl"(%1178, %1178, %38) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1199 = "llvm.intr.fshl"(%1178, %1178, %39) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1200 = "llvm.xor"(%1198, %1199) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1201 = "llvm.xor"(%1200, %1197) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1202 = "llvm.and"(%1178, %1136) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1203 = "llvm.xor"(%1178, %40) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1204 = "llvm.and"(%1094, %1203) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1205 = "llvm.or"(%1202, %1204) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1206 = "llvm.add"(%1196, %1192) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1207 = "llvm.add"(%1206, %1052) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1208 = "llvm.add"(%1207, %1205) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1209 = "llvm.add"(%1208, %1201) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1210 = "llvm.intr.fshl"(%1179, %1179, %42) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1211 = "llvm.intr.fshl"(%1179, %1179, %43) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1212 = "llvm.intr.fshl"(%1179, %1179, %44) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1213 = "llvm.xor"(%1211, %1212) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1214 = "llvm.xor"(%1213, %1210) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1215 = "llvm.and"(%1179, %1137) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1216 = "llvm.xor"(%1179, %1137) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1217 = "llvm.and"(%1216, %1095) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1218 = "llvm.xor"(%1217, %1215) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1219 = "llvm.add"(%1214, %1218) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1220 = "llvm.add"(%1209, %1053) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1221 = "llvm.add"(%1219, %1209) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1222 = "llvm.intr.fshl"(%715, %715, %61) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1223 = "llvm.intr.fshl"(%715, %715, %62) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1224 = "llvm.lshr"(%715, %26) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1225 = "llvm.xor"(%1223, %1224) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1226 = "llvm.xor"(%1225, %1222) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1227 = "llvm.intr.fshl"(%1150, %1150, %63) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1228 = "llvm.intr.fshl"(%1150, %1150, %64) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1229 = "llvm.lshr"(%1150, %65) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1230 = "llvm.xor"(%1228, %1229) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1231 = "llvm.xor"(%1230, %1227) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1232 = "llvm.add"(%1226, %714) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1233 = "llvm.add"(%1232, %940) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1234 = "llvm.add"(%1233, %1231) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1235 = "llvm.getelementptr"(%731) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 96>}> : (!llvm.ptr) -> !llvm.ptr
  %1236 = "llvm.load"(%1235) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %1237 = "llvm.insertelement"(%23, %1236, %2) : (vector<8xi64>, i64, i64) -> vector<8xi64>
  %1238 = "llvm.shufflevector"(%1237, %23) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1239 = "llvm.intr.fshl"(%1220, %1220, %37) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1240 = "llvm.intr.fshl"(%1220, %1220, %38) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1241 = "llvm.intr.fshl"(%1220, %1220, %39) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1242 = "llvm.xor"(%1240, %1241) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1243 = "llvm.xor"(%1242, %1239) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1244 = "llvm.and"(%1220, %1178) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1245 = "llvm.xor"(%1220, %40) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1246 = "llvm.and"(%1136, %1245) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1247 = "llvm.or"(%1244, %1246) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1248 = "llvm.add"(%1238, %1234) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1249 = "llvm.add"(%1248, %1094) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1250 = "llvm.add"(%1249, %1247) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1251 = "llvm.add"(%1250, %1243) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1252 = "llvm.intr.fshl"(%1221, %1221, %42) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1253 = "llvm.intr.fshl"(%1221, %1221, %43) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1254 = "llvm.intr.fshl"(%1221, %1221, %44) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1255 = "llvm.xor"(%1253, %1254) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1256 = "llvm.xor"(%1255, %1252) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1257 = "llvm.and"(%1221, %1179) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1258 = "llvm.xor"(%1221, %1179) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1259 = "llvm.and"(%1258, %1137) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1260 = "llvm.xor"(%1259, %1257) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1261 = "llvm.add"(%1256, %1260) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1262 = "llvm.add"(%1251, %1095) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1263 = "llvm.add"(%1261, %1251) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1264 = "llvm.intr.fshl"(%716, %716, %61) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1265 = "llvm.intr.fshl"(%716, %716, %62) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1266 = "llvm.lshr"(%716, %26) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1267 = "llvm.xor"(%1265, %1266) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1268 = "llvm.xor"(%1267, %1264) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1269 = "llvm.intr.fshl"(%1192, %1192, %63) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1270 = "llvm.intr.fshl"(%1192, %1192, %64) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1271 = "llvm.lshr"(%1192, %65) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1272 = "llvm.xor"(%1270, %1271) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1273 = "llvm.xor"(%1272, %1269) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1274 = "llvm.add"(%1268, %715) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1275 = "llvm.add"(%1274, %982) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1276 = "llvm.add"(%1275, %1273) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1277 = "llvm.getelementptr"(%731) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 104>}> : (!llvm.ptr) -> !llvm.ptr
  %1278 = "llvm.load"(%1277) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %1279 = "llvm.insertelement"(%23, %1278, %2) : (vector<8xi64>, i64, i64) -> vector<8xi64>
  %1280 = "llvm.shufflevector"(%1279, %23) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1281 = "llvm.intr.fshl"(%1262, %1262, %37) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1282 = "llvm.intr.fshl"(%1262, %1262, %38) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1283 = "llvm.intr.fshl"(%1262, %1262, %39) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1284 = "llvm.xor"(%1282, %1283) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1285 = "llvm.xor"(%1284, %1281) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1286 = "llvm.and"(%1262, %1220) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1287 = "llvm.xor"(%1262, %40) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1288 = "llvm.and"(%1178, %1287) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1289 = "llvm.or"(%1286, %1288) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1290 = "llvm.add"(%1280, %1276) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1291 = "llvm.add"(%1290, %1136) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1292 = "llvm.add"(%1291, %1289) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1293 = "llvm.add"(%1292, %1285) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1294 = "llvm.intr.fshl"(%1263, %1263, %42) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1295 = "llvm.intr.fshl"(%1263, %1263, %43) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1296 = "llvm.intr.fshl"(%1263, %1263, %44) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1297 = "llvm.xor"(%1295, %1296) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1298 = "llvm.xor"(%1297, %1294) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1299 = "llvm.and"(%1263, %1221) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1300 = "llvm.xor"(%1263, %1221) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1301 = "llvm.and"(%1300, %1179) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1302 = "llvm.xor"(%1301, %1299) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1303 = "llvm.add"(%1298, %1302) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1304 = "llvm.add"(%1293, %1137) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1305 = "llvm.add"(%1303, %1293) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1306 = "llvm.intr.fshl"(%717, %717, %61) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1307 = "llvm.intr.fshl"(%717, %717, %62) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1308 = "llvm.lshr"(%717, %26) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1309 = "llvm.xor"(%1307, %1308) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1310 = "llvm.xor"(%1309, %1306) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1311 = "llvm.intr.fshl"(%1234, %1234, %63) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1312 = "llvm.intr.fshl"(%1234, %1234, %64) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1313 = "llvm.lshr"(%1234, %65) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1314 = "llvm.xor"(%1312, %1313) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1315 = "llvm.xor"(%1314, %1311) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1316 = "llvm.add"(%1310, %716) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1317 = "llvm.add"(%1316, %1024) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1318 = "llvm.add"(%1317, %1315) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1319 = "llvm.getelementptr"(%731) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 112>}> : (!llvm.ptr) -> !llvm.ptr
  %1320 = "llvm.load"(%1319) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %1321 = "llvm.insertelement"(%23, %1320, %2) : (vector<8xi64>, i64, i64) -> vector<8xi64>
  %1322 = "llvm.shufflevector"(%1321, %23) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1323 = "llvm.intr.fshl"(%1304, %1304, %37) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1324 = "llvm.intr.fshl"(%1304, %1304, %38) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1325 = "llvm.intr.fshl"(%1304, %1304, %39) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1326 = "llvm.xor"(%1324, %1325) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1327 = "llvm.xor"(%1326, %1323) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1328 = "llvm.and"(%1304, %1262) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1329 = "llvm.xor"(%1304, %40) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1330 = "llvm.and"(%1220, %1329) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1331 = "llvm.or"(%1328, %1330) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1332 = "llvm.add"(%1322, %1318) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1333 = "llvm.add"(%1332, %1178) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1334 = "llvm.add"(%1333, %1331) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1335 = "llvm.add"(%1334, %1327) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1336 = "llvm.intr.fshl"(%1305, %1305, %42) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1337 = "llvm.intr.fshl"(%1305, %1305, %43) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1338 = "llvm.intr.fshl"(%1305, %1305, %44) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1339 = "llvm.xor"(%1337, %1338) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1340 = "llvm.xor"(%1339, %1336) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1341 = "llvm.and"(%1305, %1263) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1342 = "llvm.xor"(%1305, %1263) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1343 = "llvm.and"(%1342, %1221) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1344 = "llvm.xor"(%1343, %1341) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1345 = "llvm.add"(%1340, %1344) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1346 = "llvm.add"(%1335, %1179) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1347 = "llvm.add"(%1345, %1335) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1348 = "llvm.intr.fshl"(%730, %730, %61) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1349 = "llvm.intr.fshl"(%730, %730, %62) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1350 = "llvm.lshr"(%730, %26) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1351 = "llvm.xor"(%1349, %1350) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1352 = "llvm.xor"(%1351, %1348) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1353 = "llvm.intr.fshl"(%1276, %1276, %63) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1354 = "llvm.intr.fshl"(%1276, %1276, %64) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1355 = "llvm.lshr"(%1276, %65) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1356 = "llvm.xor"(%1354, %1355) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1357 = "llvm.xor"(%1356, %1353) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1358 = "llvm.add"(%1352, %717) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1359 = "llvm.add"(%1358, %1066) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1360 = "llvm.add"(%1359, %1357) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1361 = "llvm.getelementptr"(%731) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 120>}> : (!llvm.ptr) -> !llvm.ptr
  %1362 = "llvm.load"(%1361) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %1363 = "llvm.insertelement"(%23, %1362, %2) : (vector<8xi64>, i64, i64) -> vector<8xi64>
  %1364 = "llvm.shufflevector"(%1363, %23) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1365 = "llvm.intr.fshl"(%1346, %1346, %37) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1366 = "llvm.intr.fshl"(%1346, %1346, %38) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1367 = "llvm.intr.fshl"(%1346, %1346, %39) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1368 = "llvm.xor"(%1366, %1367) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1369 = "llvm.xor"(%1368, %1365) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1370 = "llvm.and"(%1346, %1304) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1371 = "llvm.xor"(%1346, %40) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1372 = "llvm.and"(%1262, %1371) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1373 = "llvm.or"(%1370, %1372) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1374 = "llvm.add"(%1364, %1360) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1375 = "llvm.add"(%1374, %1220) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1376 = "llvm.add"(%1375, %1373) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1377 = "llvm.add"(%1376, %1369) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1378 = "llvm.intr.fshl"(%1347, %1347, %42) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1379 = "llvm.intr.fshl"(%1347, %1347, %43) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1380 = "llvm.intr.fshl"(%1347, %1347, %44) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1381 = "llvm.xor"(%1379, %1380) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1382 = "llvm.xor"(%1381, %1378) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1383 = "llvm.and"(%1347, %1305) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1384 = "llvm.xor"(%1347, %1305) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1385 = "llvm.and"(%1384, %1263) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1386 = "llvm.xor"(%1385, %1383) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1387 = "llvm.add"(%1382, %1386) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1388 = "llvm.add"(%1377, %1221) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1389 = "llvm.add"(%1387, %1377) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1390 = "llvm.add"(%694, %60) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1391 = "llvm.icmp"(%694, %7) <{predicate = 6 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1391, %730, %1390, %1262, %1304, %1346, %1388, %1263, %1305, %1347, %1389, %772, %814, %856, %898, %940, %982, %1024, %1066, %1108, %1150, %1192, %1234, %1276, %1318, %1360)[^bb17, ^bb18] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true>, mustProgress = true>, operandSegmentSizes = array<i32: 1, 25, 0>}> : (i1, vector<8xi64>, i64, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>) -> ()
^bb18:  // pred: ^bb17
  %1392 = "llvm.select"(%175, %1389, %6) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1393 = "llvm.add"(%1392, %176) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1394 = "llvm.select"(%175, %1347, %6) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1395 = "llvm.add"(%1394, %177) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1396 = "llvm.select"(%175, %1305, %6) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1397 = "llvm.add"(%1396, %178) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1398 = "llvm.select"(%175, %1263, %6) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1399 = "llvm.add"(%1398, %179) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1400 = "llvm.select"(%175, %1388, %6) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1401 = "llvm.add"(%1400, %180) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1402 = "llvm.select"(%175, %1346, %6) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1403 = "llvm.add"(%1402, %181) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1404 = "llvm.select"(%175, %1304, %6) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1405 = "llvm.add"(%1404, %182) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1406 = "llvm.select"(%175, %1262, %6) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1407 = "llvm.add"(%1406, %183) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1408 = "llvm.add"(%187, %67) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1409 = "llvm.intr.usub.sat"(%185, %68) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1410 = "llvm.icmp"(%185, %68) <{predicate = 8 : i64}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi1>
  %1411 = "llvm.bitcast"(%1410) : (vector<8xi1>) -> i8
  %1412 = "llvm.icmp"(%1411, %27) <{predicate = 0 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%1412, %1407, %1405, %1403, %1401, %1399, %1397, %1395, %1393, %1410, %1393, %1395, %1397, %1399, %1401, %1403, %1405, %1407, %1408, %1409)[^bb19, ^bb16] <{branch_weights = array<i32: 127, 255873>, operandSegmentSizes = array<i32: 1, 8, 11>}> : (i1, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi1>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>) -> ()
^bb19(%1413: vector<8xi64>, %1414: vector<8xi64>, %1415: vector<8xi64>, %1416: vector<8xi64>, %1417: vector<8xi64>, %1418: vector<8xi64>, %1419: vector<8xi64>, %1420: vector<8xi64>):  // 2 preds: ^bb3, ^bb18
  %1421 = "llvm.shufflevector"(%1420, %1418) <{mask = array<i32: 0, 1, 4, 5, 8, 9, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1422 = "llvm.shufflevector"(%1419, %1417) <{mask = array<i32: 0, 1, 4, 5, 8, 9, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1423 = "llvm.shufflevector"(%1420, %1418) <{mask = array<i32: 2, 3, 6, 7, 10, 11, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1424 = "llvm.shufflevector"(%1419, %1417) <{mask = array<i32: 2, 3, 6, 7, 10, 11, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1425 = "llvm.shufflevector"(%1416, %1414) <{mask = array<i32: 0, 1, 4, 5, 8, 9, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1426 = "llvm.shufflevector"(%1415, %1413) <{mask = array<i32: 0, 1, 4, 5, 8, 9, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1427 = "llvm.shufflevector"(%1416, %1414) <{mask = array<i32: 2, 3, 6, 7, 10, 11, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1428 = "llvm.shufflevector"(%1415, %1413) <{mask = array<i32: 2, 3, 6, 7, 10, 11, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1429 = "llvm.shufflevector"(%1421, %1425) <{mask = array<i32: 0, 1, 4, 5, 8, 9, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1430 = "llvm.shufflevector"(%1422, %1426) <{mask = array<i32: 0, 1, 4, 5, 8, 9, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1431 = "llvm.shufflevector"(%1423, %1427) <{mask = array<i32: 0, 1, 4, 5, 8, 9, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1432 = "llvm.shufflevector"(%1424, %1428) <{mask = array<i32: 0, 1, 4, 5, 8, 9, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1433 = "llvm.shufflevector"(%1421, %1425) <{mask = array<i32: 2, 3, 6, 7, 10, 11, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1434 = "llvm.shufflevector"(%1422, %1426) <{mask = array<i32: 2, 3, 6, 7, 10, 11, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1435 = "llvm.shufflevector"(%1423, %1427) <{mask = array<i32: 2, 3, 6, 7, 10, 11, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1436 = "llvm.shufflevector"(%1424, %1428) <{mask = array<i32: 2, 3, 6, 7, 10, 11, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1437 = "llvm.shufflevector"(%1429, %1430) <{mask = array<i32: 0, 8, 2, 10, 4, 12, 6, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1438 = "llvm.shufflevector"(%1429, %1430) <{mask = array<i32: 1, 9, 3, 11, 5, 13, 7, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1439 = "llvm.shufflevector"(%1431, %1432) <{mask = array<i32: 0, 8, 2, 10, 4, 12, 6, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1440 = "llvm.shufflevector"(%1431, %1432) <{mask = array<i32: 1, 9, 3, 11, 5, 13, 7, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1441 = "llvm.shufflevector"(%1433, %1434) <{mask = array<i32: 0, 8, 2, 10, 4, 12, 6, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1442 = "llvm.shufflevector"(%1433, %1434) <{mask = array<i32: 1, 9, 3, 11, 5, 13, 7, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1443 = "llvm.shufflevector"(%1435, %1436) <{mask = array<i32: 0, 8, 2, 10, 4, 12, 6, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.switch"(%arg0)[^bb24, ^bb20, ^bb21, ^bb22, ^bb23] <{case_operand_segments = array<i32: 0, 0, 0, 0>, case_values = dense<[8, 7, 6, 5]> : vector<4xi64>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i64) -> ()
^bb20:  // pred: ^bb19
  %1444 = "llvm.shufflevector"(%1435, %1436) <{mask = array<i32: 1, 9, 3, 11, 5, 13, 7, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1445 = "llvm.getelementptr"(%arg3) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 56>}> : (!llvm.ptr) -> !llvm.ptr
  %1446 = "llvm.load"(%1445) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> !llvm.ptr
  %1447 = "llvm.bitcast"(%1444) : (vector<8xi64>) -> vector<64xi8>
  %1448 = "llvm.shufflevector"(%1447, %69) <{mask = array<i32: 7, 6, 5, 4, 3, 2, 1, 0, 15, 14, 13, 12, 11, 10, 9, 8, 23, 22, 21, 20, 19, 18, 17, 16, 31, 30, 29, 28, 27, 26, 25, 24, 39, 38, 37, 36, 35, 34, 33, 32, 47, 46, 45, 44, 43, 42, 41, 40, 55, 54, 53, 52, 51, 50, 49, 48, 63, 62, 61, 60, 59, 58, 57, 56>}> : (vector<64xi8>, vector<64xi8>) -> vector<64xi8>
  %1449 = "llvm.bitcast"(%1448) : (vector<64xi8>) -> vector<8xi64>
  "llvm.call"(%1446, %1449) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @wwv_stu, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, vector<8xi64>) -> ()
  "llvm.br"()[^bb21] : () -> ()
^bb21:  // 2 preds: ^bb19, ^bb20
  %1450 = "llvm.getelementptr"(%arg3) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 48>}> : (!llvm.ptr) -> !llvm.ptr
  %1451 = "llvm.load"(%1450) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> !llvm.ptr
  %1452 = "llvm.bitcast"(%1443) : (vector<8xi64>) -> vector<64xi8>
  %1453 = "llvm.shufflevector"(%1452, %69) <{mask = array<i32: 7, 6, 5, 4, 3, 2, 1, 0, 15, 14, 13, 12, 11, 10, 9, 8, 23, 22, 21, 20, 19, 18, 17, 16, 31, 30, 29, 28, 27, 26, 25, 24, 39, 38, 37, 36, 35, 34, 33, 32, 47, 46, 45, 44, 43, 42, 41, 40, 55, 54, 53, 52, 51, 50, 49, 48, 63, 62, 61, 60, 59, 58, 57, 56>}> : (vector<64xi8>, vector<64xi8>) -> vector<64xi8>
  %1454 = "llvm.bitcast"(%1453) : (vector<64xi8>) -> vector<8xi64>
  "llvm.call"(%1451, %1454) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @wwv_stu, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, vector<8xi64>) -> ()
  "llvm.br"()[^bb22] : () -> ()
^bb22:  // 2 preds: ^bb19, ^bb21
  %1455 = "llvm.getelementptr"(%arg3) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 40>}> : (!llvm.ptr) -> !llvm.ptr
  %1456 = "llvm.load"(%1455) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> !llvm.ptr
  %1457 = "llvm.bitcast"(%1442) : (vector<8xi64>) -> vector<64xi8>
  %1458 = "llvm.shufflevector"(%1457, %69) <{mask = array<i32: 7, 6, 5, 4, 3, 2, 1, 0, 15, 14, 13, 12, 11, 10, 9, 8, 23, 22, 21, 20, 19, 18, 17, 16, 31, 30, 29, 28, 27, 26, 25, 24, 39, 38, 37, 36, 35, 34, 33, 32, 47, 46, 45, 44, 43, 42, 41, 40, 55, 54, 53, 52, 51, 50, 49, 48, 63, 62, 61, 60, 59, 58, 57, 56>}> : (vector<64xi8>, vector<64xi8>) -> vector<64xi8>
  %1459 = "llvm.bitcast"(%1458) : (vector<64xi8>) -> vector<8xi64>
  "llvm.call"(%1456, %1459) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @wwv_stu, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, vector<8xi64>) -> ()
  "llvm.br"()[^bb23] : () -> ()
^bb23:  // 2 preds: ^bb19, ^bb22
  %1460 = "llvm.getelementptr"(%arg3) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %1461 = "llvm.load"(%1460) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> !llvm.ptr
  %1462 = "llvm.bitcast"(%1441) : (vector<8xi64>) -> vector<64xi8>
  %1463 = "llvm.shufflevector"(%1462, %69) <{mask = array<i32: 7, 6, 5, 4, 3, 2, 1, 0, 15, 14, 13, 12, 11, 10, 9, 8, 23, 22, 21, 20, 19, 18, 17, 16, 31, 30, 29, 28, 27, 26, 25, 24, 39, 38, 37, 36, 35, 34, 33, 32, 47, 46, 45, 44, 43, 42, 41, 40, 55, 54, 53, 52, 51, 50, 49, 48, 63, 62, 61, 60, 59, 58, 57, 56>}> : (vector<64xi8>, vector<64xi8>) -> vector<64xi8>
  %1464 = "llvm.bitcast"(%1463) : (vector<64xi8>) -> vector<8xi64>
  "llvm.call"(%1461, %1464) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @wwv_stu, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, vector<8xi64>) -> ()
  %1465 = "llvm.getelementptr"(%arg3) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %1466 = "llvm.load"(%1465) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> !llvm.ptr
  %1467 = "llvm.bitcast"(%1440) : (vector<8xi64>) -> vector<64xi8>
  %1468 = "llvm.shufflevector"(%1467, %69) <{mask = array<i32: 7, 6, 5, 4, 3, 2, 1, 0, 15, 14, 13, 12, 11, 10, 9, 8, 23, 22, 21, 20, 19, 18, 17, 16, 31, 30, 29, 28, 27, 26, 25, 24, 39, 38, 37, 36, 35, 34, 33, 32, 47, 46, 45, 44, 43, 42, 41, 40, 55, 54, 53, 52, 51, 50, 49, 48, 63, 62, 61, 60, 59, 58, 57, 56>}> : (vector<64xi8>, vector<64xi8>) -> vector<64xi8>
  %1469 = "llvm.bitcast"(%1468) : (vector<64xi8>) -> vector<8xi64>
  "llvm.call"(%1466, %1469) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @wwv_stu, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, vector<8xi64>) -> ()
  %1470 = "llvm.getelementptr"(%arg3) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %1471 = "llvm.load"(%1470) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> !llvm.ptr
  %1472 = "llvm.bitcast"(%1439) : (vector<8xi64>) -> vector<64xi8>
  %1473 = "llvm.shufflevector"(%1472, %69) <{mask = array<i32: 7, 6, 5, 4, 3, 2, 1, 0, 15, 14, 13, 12, 11, 10, 9, 8, 23, 22, 21, 20, 19, 18, 17, 16, 31, 30, 29, 28, 27, 26, 25, 24, 39, 38, 37, 36, 35, 34, 33, 32, 47, 46, 45, 44, 43, 42, 41, 40, 55, 54, 53, 52, 51, 50, 49, 48, 63, 62, 61, 60, 59, 58, 57, 56>}> : (vector<64xi8>, vector<64xi8>) -> vector<64xi8>
  %1474 = "llvm.bitcast"(%1473) : (vector<64xi8>) -> vector<8xi64>
  "llvm.call"(%1471, %1474) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @wwv_stu, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, vector<8xi64>) -> ()
  %1475 = "llvm.getelementptr"(%arg3) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %1476 = "llvm.load"(%1475) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> !llvm.ptr
  %1477 = "llvm.bitcast"(%1438) : (vector<8xi64>) -> vector<64xi8>
  %1478 = "llvm.shufflevector"(%1477, %69) <{mask = array<i32: 7, 6, 5, 4, 3, 2, 1, 0, 15, 14, 13, 12, 11, 10, 9, 8, 23, 22, 21, 20, 19, 18, 17, 16, 31, 30, 29, 28, 27, 26, 25, 24, 39, 38, 37, 36, 35, 34, 33, 32, 47, 46, 45, 44, 43, 42, 41, 40, 55, 54, 53, 52, 51, 50, 49, 48, 63, 62, 61, 60, 59, 58, 57, 56>}> : (vector<64xi8>, vector<64xi8>) -> vector<64xi8>
  %1479 = "llvm.bitcast"(%1478) : (vector<64xi8>) -> vector<8xi64>
  "llvm.call"(%1476, %1479) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @wwv_stu, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, vector<8xi64>) -> ()
  %1480 = "llvm.load"(%arg3) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> !llvm.ptr
  %1481 = "llvm.bitcast"(%1437) : (vector<8xi64>) -> vector<64xi8>
  %1482 = "llvm.shufflevector"(%1481, %69) <{mask = array<i32: 7, 6, 5, 4, 3, 2, 1, 0, 15, 14, 13, 12, 11, 10, 9, 8, 23, 22, 21, 20, 19, 18, 17, 16, 31, 30, 29, 28, 27, 26, 25, 24, 39, 38, 37, 36, 35, 34, 33, 32, 47, 46, 45, 44, 43, 42, 41, 40, 55, 54, 53, 52, 51, 50, 49, 48, 63, 62, 61, 60, 59, 58, 57, 56>}> : (vector<64xi8>, vector<64xi8>) -> vector<64xi8>
  %1483 = "llvm.bitcast"(%1482) : (vector<64xi8>) -> vector<8xi64>
  "llvm.call"(%1480, %1483) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @wwv_stu, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, vector<8xi64>) -> ()
  "llvm.br"()[^bb24] : () -> ()
^bb24:  // 2 preds: ^bb19, ^bb23
  "llvm.intr.lifetime.end"(%72) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%71) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%70) : (!llvm.ptr) -> ()
  "llvm.br"()[^bb25] : () -> ()
^bb25:  // 2 preds: ^bb1, ^bb24
  "llvm.return"() : () -> ()
}) : () -> ()

    with
      @fd_sha512_private_batch_avx512.K := Firedancer.LaneNI.Mlir.fd_sha512_private_batch_avx512_K,
      @fd_sha512_private_batch_avx := Firedancer.LaneNI.Mlir.fd_sha512_private_batch_avx,
      @fd_ulong_align_dn := Firedancer.LaneNI.Mlir.fd_ulong_align_dn,
      @fd_ulong_align_up := Firedancer.LaneNI.Mlir.fd_ulong_align_up,
      @wwv_st.10 := Firedancer.LaneNI.Mlir.wwv_st_10,
      @wwv_st.10 := Firedancer.LaneNI.Mlir.wwv_st_10,
      @wwv_st.10 := Firedancer.LaneNI.Mlir.wwv_st_10,
      @wwv_st.10 := Firedancer.LaneNI.Mlir.wwv_st_10,
      @wwv_st.10 := Firedancer.LaneNI.Mlir.wwv_st_10,
      @fd_ulong_bswap.11 := Firedancer.LaneNI.Mlir.fd_ulong_bswap_11,
      @fd_ulong_bswap.11 := Firedancer.LaneNI.Mlir.fd_ulong_bswap_11,
      @wwv_stu := Firedancer.LaneNI.Mlir.wwv_stu,
      @wwv_stu := Firedancer.LaneNI.Mlir.wwv_stu,
      @wwv_stu := Firedancer.LaneNI.Mlir.wwv_stu,
      @wwv_stu := Firedancer.LaneNI.Mlir.wwv_stu,
      @wwv_stu := Firedancer.LaneNI.Mlir.wwv_stu,
      @wwv_stu := Firedancer.LaneNI.Mlir.wwv_stu,
      @wwv_stu := Firedancer.LaneNI.Mlir.wwv_stu,
      @wwv_stu := Firedancer.LaneNI.Mlir.wwv_stu

end

end Firedancer.LaneNI.Mlir
