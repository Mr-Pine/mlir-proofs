
module

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

public import Firedancer.LaneNI.Mlir.fd_sha512_private_batch_avx_K
public import Firedancer.LaneNI.Mlir.fd_sha512_hash
public import Firedancer.LaneNI.Mlir.fd_ulong_align_dn_14
public import Firedancer.LaneNI.Mlir.fd_ulong_align_up_15
public import Firedancer.LaneNI.Mlir.wv_st
public import Firedancer.LaneNI.Mlir.wv_st
public import Firedancer.LaneNI.Mlir.wv_st
public import Firedancer.LaneNI.Mlir.wv_st
public import Firedancer.LaneNI.Mlir.wv_st
public import Firedancer.LaneNI.Mlir.wv_st
public import Firedancer.LaneNI.Mlir.wv_st
public import Firedancer.LaneNI.Mlir.wv_st
public import Firedancer.LaneNI.Mlir.wv_st
public import Firedancer.LaneNI.Mlir.fd_ulong_bswap_16
public import Firedancer.LaneNI.Mlir.fd_ulong_bswap_16
public import Firedancer.LaneNI.Mlir.wv_stu_17
public import Firedancer.LaneNI.Mlir.wv_stu_17
public import Firedancer.LaneNI.Mlir.wv_stu_17
public import Firedancer.LaneNI.Mlir.wv_stu_17
public import Firedancer.LaneNI.Mlir.wv_stu_17
public import Firedancer.LaneNI.Mlir.wv_stu_17
public import Firedancer.LaneNI.Mlir.wv_stu_17
public import Firedancer.LaneNI.Mlir.wv_stu_17

namespace Firedancer.LaneNI.Mlir

@[expose] public section

mlir_def fd_sha512_private_batch_avx := "llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.noundef}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}], frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<void (i64, ptr, ptr, ptr)>, linkage = #llvm.linkage<external>, no_inline, no_unwind, passthrough = ["sspstrong", ["min-legal-vector-width", "256"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "znver4"]], sym_name = "fd_sha512_private_batch_avx", target_cpu = "znver4", target_features = #llvm.target_features<["+64bit", "+adx", "+aes", "+avx", "+avx2", "+avx512bf16", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+clzero", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fast-vector-fsqrt", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+mwaitx", "+pclmul", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdpru", "+rdrnd", "+rdseed", "+sahf", "+sha", "+shstk", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+sse4a", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tile", "-avx10.1", "-avx10.2", "-avx512bmm", "-avx512fp16", "-avx512vp2intersect", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-ccmp", "-cf", "-cldemote", "-cmpccxadd", "-egpr", "-enqcmd", "-fma4", "-hreset", "-jmpabs", "-kl", "-lwp", "-movdir64b", "-movdiri", "-movrs", "-ndd", "-nf", "-pconfig", "-ppx", "-prefetchi", "-ptwrite", "-push2pop2", "-raoint", "-rtm", "-serialize", "-sgx", "-sha512", "-sm3", "-sm4", "-tbm", "-tsxldtrk", "-uintr", "-usermsr", "-waitpkg", "-widekl", "-xop", "-zu"]>, tune_cpu = "znver4", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg0: i64, %arg1: !llvm.ptr, %arg2: !llvm.ptr, %arg3: !llvm.ptr):
  %0 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %1 = "llvm.mlir.constant"() <{value = 2 : i64}> : () -> i64
  %2 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %3 = "llvm.mlir.constant"() <{value = 127 : i64}> : () -> i64
  %4 = "llvm.mlir.constant"() <{value = 17 : i64}> : () -> i64
  %5 = "llvm.mlir.constant"() <{value = 7 : i64}> : () -> i64
  %6 = "llvm.mlir.constant"() <{value = dense<0> : vector<4xi64>}> : () -> vector<4xi64>
  %7 = "llvm.mlir.constant"() <{value = 32 : i64}> : () -> i64
  %8 = "llvm.mlir.constant"() <{value = 64 : i64}> : () -> i64
  %9 = "llvm.mlir.constant"() <{value = 96 : i64}> : () -> i64
  %10 = "llvm.mlir.constant"() <{value = 128 : i64}> : () -> i64
  %11 = "llvm.mlir.constant"() <{value = 160 : i64}> : () -> i64
  %12 = "llvm.mlir.constant"() <{value = 192 : i64}> : () -> i64
  %13 = "llvm.mlir.constant"() <{value = 224 : i64}> : () -> i64
  %14 = "llvm.mlir.constant"() <{value = 31 : i64}> : () -> i64
  %15 = "llvm.mlir.constant"() <{value = -32 : i64}> : () -> i64
  %16 = "llvm.mlir.constant"() <{value = 8 : i64}> : () -> i64
  %17 = "llvm.mlir.constant"() <{value = -8 : i64}> : () -> i64
  %18 = "llvm.mlir.constant"() <{value = 3 : i64}> : () -> i64
  %19 = "llvm.mlir.constant"() <{value = 4 : i64}> : () -> i64
  %20 = "llvm.mlir.constant"() <{value = -4 : i64}> : () -> i64
  %21 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %22 = "llvm.mlir.constant"() <{value = -2 : i64}> : () -> i64
  %23 = "llvm.mlir.constant"() <{value = -128 : i8}> : () -> i8
  %24 = "llvm.mlir.constant"() <{value = 61 : i64}> : () -> i64
  %25 = "llvm.mlir.constant"() <{value = -16 : i64}> : () -> i64
  %26 = "llvm.mlir.poison"() : () -> vector<4xi64>
  %27 = "llvm.mlir.constant"() <{value = -1 : i32}> : () -> i32
  %28 = "llvm.mlir.poison"() : () -> vector<8xi32>
  %29 = "llvm.mlir.constant"() <{value = dense<[1, 2, 4, 8, 16, 32, 64, 128]> : vector<8xi32>}> : () -> vector<8xi32>
  %30 = "llvm.mlir.constant"() <{value = dense<0> : vector<8xi32>}> : () -> vector<8xi32>
  %31 = "llvm.mlir.constant"() <{value = dense<7> : vector<4xi64>}> : () -> vector<4xi64>
  %32 = "llvm.mlir.constant"() <{value = 0 : i8}> : () -> i8
  %33 = "llvm.mlir.constant"() <{value = dense<[327033209, 1541459225, 327033209, 1541459225, 327033209, 1541459225, 327033209, 1541459225]> : vector<8xi32>}> : () -> vector<8xi32>
  %34 = "llvm.mlir.constant"() <{value = dense<[-79577749, 528734635, -79577749, 528734635, -79577749, 528734635, -79577749, 528734635]> : vector<8xi32>}> : () -> vector<8xi32>
  %35 = "llvm.mlir.constant"() <{value = dense<[725511199, -1694144372, 725511199, -1694144372, 725511199, -1694144372, 725511199, -1694144372]> : vector<8xi32>}> : () -> vector<8xi32>
  %36 = "llvm.mlir.constant"() <{value = dense<[-1377402159, 1359893119, -1377402159, 1359893119, -1377402159, 1359893119, -1377402159, 1359893119]> : vector<8xi32>}> : () -> vector<8xi32>
  %37 = "llvm.mlir.constant"() <{value = dense<[1595750129, -1521486534, 1595750129, -1521486534, 1595750129, -1521486534, 1595750129, -1521486534]> : vector<8xi32>}> : () -> vector<8xi32>
  %38 = "llvm.mlir.constant"() <{value = dense<[-23791573, 1013904242, -23791573, 1013904242, -23791573, 1013904242, -23791573, 1013904242]> : vector<8xi32>}> : () -> vector<8xi32>
  %39 = "llvm.mlir.constant"() <{value = dense<[-2067093701, -1150833019, -2067093701, -1150833019, -2067093701, -1150833019, -2067093701, -1150833019]> : vector<8xi32>}> : () -> vector<8xi32>
  %40 = "llvm.mlir.constant"() <{value = dense<[-205731576, 1779033703, -205731576, 1779033703, -205731576, 1779033703, -205731576, 1779033703]> : vector<8xi32>}> : () -> vector<8xi32>
  %41 = "llvm.mlir.constant"() <{value = dense<7640891576956012808> : vector<4xi64>}> : () -> vector<4xi64>
  %42 = "llvm.mlir.constant"() <{value = dense<-4942790177534073029> : vector<4xi64>}> : () -> vector<4xi64>
  %43 = "llvm.mlir.constant"() <{value = dense<4354685564936845355> : vector<4xi64>}> : () -> vector<4xi64>
  %44 = "llvm.mlir.constant"() <{value = dense<-6534734903238641935> : vector<4xi64>}> : () -> vector<4xi64>
  %45 = "llvm.mlir.constant"() <{value = dense<5840696475078001361> : vector<4xi64>}> : () -> vector<4xi64>
  %46 = "llvm.mlir.constant"() <{value = dense<-7276294671716946913> : vector<4xi64>}> : () -> vector<4xi64>
  %47 = "llvm.mlir.constant"() <{value = dense<2270897969802886507> : vector<4xi64>}> : () -> vector<4xi64>
  %48 = "llvm.mlir.constant"() <{value = dense<6620516959819538809> : vector<4xi64>}> : () -> vector<4xi64>
  %49 = "llvm.mlir.constant"() <{value = dense<32> : vector<4xi64>}> : () -> vector<4xi64>
  %50 = "llvm.mlir.constant"() <{value = dense<50> : vector<4xi64>}> : () -> vector<4xi64>
  %51 = "llvm.mlir.constant"() <{value = dense<46> : vector<4xi64>}> : () -> vector<4xi64>
  %52 = "llvm.mlir.constant"() <{value = dense<23> : vector<4xi64>}> : () -> vector<4xi64>
  %53 = "llvm.mlir.constant"() <{value = dense<-1> : vector<4xi64>}> : () -> vector<4xi64>
  %54 = "llvm.mlir.constant"() <{value = dense<4794697086780616226> : vector<4xi64>}> : () -> vector<4xi64>
  %55 = "llvm.mlir.constant"() <{value = dense<36> : vector<4xi64>}> : () -> vector<4xi64>
  %56 = "llvm.mlir.constant"() <{value = dense<30> : vector<4xi64>}> : () -> vector<4xi64>
  %57 = "llvm.mlir.constant"() <{value = dense<25> : vector<4xi64>}> : () -> vector<4xi64>
  %58 = "llvm.mlir.constant"() <{value = dense<8158064640168781261> : vector<4xi64>}> : () -> vector<4xi64>
  %59 = "llvm.mlir.constant"() <{value = dense<-5349999486874862801> : vector<4xi64>}> : () -> vector<4xi64>
  %60 = "llvm.mlir.constant"() <{value = dense<-1606136188198331460> : vector<4xi64>}> : () -> vector<4xi64>
  %61 = "llvm.mlir.constant"() <{value = dense<4131703408338449720> : vector<4xi64>}> : () -> vector<4xi64>
  %62 = "llvm.mlir.constant"() <{value = dense<6480981068601479193> : vector<4xi64>}> : () -> vector<4xi64>
  %63 = "llvm.mlir.constant"() <{value = dense<-7908458776815382629> : vector<4xi64>}> : () -> vector<4xi64>
  %64 = "llvm.mlir.constant"() <{value = dense<-6116909921290321640> : vector<4xi64>}> : () -> vector<4xi64>
  %65 = "llvm.mlir.constant"() <{value = dense<-2880145864133508542> : vector<4xi64>}> : () -> vector<4xi64>
  %66 = "llvm.mlir.constant"() <{value = dense<1334009975649890238> : vector<4xi64>}> : () -> vector<4xi64>
  %67 = "llvm.mlir.constant"() <{value = dense<2608012711638119052> : vector<4xi64>}> : () -> vector<4xi64>
  %68 = "llvm.mlir.constant"() <{value = dense<6128411473006802146> : vector<4xi64>}> : () -> vector<4xi64>
  %69 = "llvm.mlir.constant"() <{value = dense<8268148722764581231> : vector<4xi64>}> : () -> vector<4xi64>
  %70 = "llvm.mlir.constant"() <{value = dense<-9160688886553864527> : vector<4xi64>}> : () -> vector<4xi64>
  %71 = "llvm.mlir.constant"() <{value = dense<-7215885187991268811> : vector<4xi64>}> : () -> vector<4xi64>
  %72 = "llvm.mlir.constant"() <{value = dense<-4495734319001033068> : vector<4xi64>}> : () -> vector<4xi64>
  %73 = "llvm.mlir.constant"() <{value = 16 : i64}> : () -> i64
  %74 = "llvm.mlir.constant"() <{value = dense<63> : vector<4xi64>}> : () -> vector<4xi64>
  %75 = "llvm.mlir.constant"() <{value = dense<56> : vector<4xi64>}> : () -> vector<4xi64>
  %76 = "llvm.mlir.constant"() <{value = dense<45> : vector<4xi64>}> : () -> vector<4xi64>
  %77 = "llvm.mlir.constant"() <{value = dense<3> : vector<4xi64>}> : () -> vector<4xi64>
  %78 = "llvm.mlir.constant"() <{value = dense<6> : vector<4xi64>}> : () -> vector<4xi64>
  %79 = "llvm.mlir.addressof"() <{global_name = @fd_sha512_private_batch_avx.K}> : () -> !llvm.ptr
  %80 = "llvm.mlir.constant"() <{value = dense<128> : vector<4xi64>}> : () -> vector<4xi64>
  %81 = "llvm.mlir.poison"() : () -> vector<32xi8>
  %82 = "llvm.alloca"(%0) <{alignment = 32 : i64, elem_type = !llvm.array<4 x i64>}> : (i32) -> !llvm.ptr
  %83 = "llvm.alloca"(%0) <{alignment = 32 : i64, elem_type = !llvm.array<4 x i64>}> : (i32) -> !llvm.ptr
  %84 = "llvm.alloca"(%0) <{alignment = 128 : i64, elem_type = !llvm.array<1024 x i8>}> : (i32) -> !llvm.ptr
  %85 = "llvm.icmp"(%arg0, %1) <{predicate = 6 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%85)[^bb1, ^bb3] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb1:  // pred: ^bb0
  %86 = "llvm.icmp"(%arg0, %21) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%86)[^bb2, ^bb26] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb2:  // pred: ^bb1
  %87 = "llvm.load"(%arg1) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> !llvm.ptr
  %88 = "llvm.load"(%arg2) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %89 = "llvm.load"(%arg3) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> !llvm.ptr
  %90 = "llvm.call"(%87, %88, %89) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_sha512_hash, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, i64, !llvm.ptr) -> !llvm.ptr
  "llvm.br"()[^bb26] : () -> ()
^bb3:  // pred: ^bb0
  "llvm.intr.lifetime.start"(%82) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%83) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%84) : (!llvm.ptr) -> ()
  %91 = "llvm.ptrtoint"(%84) : (!llvm.ptr) -> i64
  "llvm.br"(%91, %2)[^bb6] : (i64, i64) -> ()
^bb4:  // pred: ^bb16
  %92 = "llvm.insertelement"(%26, %91, %2) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %93 = "llvm.shufflevector"(%92, %26) <{mask = array<i32: 0, 0, 0, 0>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %94 = "llvm.trunc"(%arg0) <{overflowFlags = 0 : i32}> : (i64) -> i32
  %95 = "llvm.shl"(%94, %0) <{overflowFlags = 0 : i32}> : (i32, i32) -> i32
  %96 = "llvm.shl"(%27, %95) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %97 = "llvm.xor"(%96, %27) : (i32, i32) -> i32
  %98 = "llvm.insertelement"(%28, %97, %2) : (vector<8xi32>, i32, i64) -> vector<8xi32>
  %99 = "llvm.shufflevector"(%98, %28) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %100 = "llvm.and"(%99, %29) : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %101 = "llvm.icmp"(%100, %30) <{predicate = 1 : i64}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi1>
  %102 = "llvm.sext"(%101) : (vector<8xi1>) -> vector<8xi32>
  %103 = "llvm.bitcast"(%102) : (vector<8xi32>) -> vector<4xi64>
  %104 = "llvm.load"(%82) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<4xi64>
  %105 = "llvm.load"(%83) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<4xi64>
  %106 = "llvm.load"(%arg2) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<4xi64>
  %107 = "llvm.lshr"(%106, %31) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %108 = "llvm.add"(%107, %105) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %109 = "llvm.and"(%108, %103) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %110 = "llvm.icmp"(%109, %6) <{predicate = 1 : i64}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi1>
  %111 = "llvm.sext"(%110) : (vector<4xi1>) -> vector<4xi64>
  %112 = "llvm.bitcast"(%111) : (vector<4xi64>) -> vector<8xi32>
  %113 = "llvm.icmp"(%112, %30) <{predicate = 2 : i64}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi1>
  %114 = "llvm.bitcast"(%113) : (vector<8xi1>) -> i8
  %115 = "llvm.icmp"(%114, %32) <{predicate = 0 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%115, %33, %34, %35, %36, %37, %38, %39, %40)[^bb21, ^bb5] <{branch_weights = array<i32: 1, 127>, operandSegmentSizes = array<i32: 1, 8, 0>}> : (i1, vector<8xi32>, vector<8xi32>, vector<8xi32>, vector<8xi32>, vector<8xi32>, vector<8xi32>, vector<8xi32>, vector<8xi32>) -> ()
^bb5:  // pred: ^bb4
  %116 = "llvm.load"(%arg1) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.br"(%111, %110, %41, %42, %43, %44, %45, %46, %47, %48, %116, %109)[^bb17] : (vector<4xi64>, vector<4xi1>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
^bb6(%117: i64, %118: i64):  // 2 preds: ^bb3, ^bb16
  %119 = "llvm.getelementptr"(%arg1, %118) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %120 = "llvm.load"(%119) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %121 = "llvm.getelementptr"(%arg2, %118) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %122 = "llvm.load"(%121) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %123 = "llvm.and"(%122, %3) : (i64, i64) -> i64
  %124 = "llvm.call"(%122) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}], callee = @fd_ulong_align_dn.14, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (i64) -> i64
  %125 = "llvm.add"(%123, %4) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %126 = "llvm.call"(%125) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}], callee = @fd_ulong_align_up.15, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (i64) -> i64
  %127 = "llvm.getelementptr"(%82, %118) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%117, %127) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %128 = "llvm.lshr"(%126, %5) : (i64, i64) -> i64
  %129 = "llvm.getelementptr"(%83, %118) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%128, %129) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %130 = "llvm.add"(%126, %117) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %131 = "llvm.inttoptr"(%117) : (i64) -> !llvm.ptr
  "llvm.call"(%131, %6) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @wv_st, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, vector<4xi64>) -> ()
  %132 = "llvm.add"(%117, %7) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %133 = "llvm.inttoptr"(%132) : (i64) -> !llvm.ptr
  "llvm.call"(%133, %6) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @wv_st, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, vector<4xi64>) -> ()
  %134 = "llvm.add"(%117, %8) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %135 = "llvm.inttoptr"(%134) : (i64) -> !llvm.ptr
  "llvm.call"(%135, %6) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @wv_st, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, vector<4xi64>) -> ()
  %136 = "llvm.add"(%117, %9) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %137 = "llvm.inttoptr"(%136) : (i64) -> !llvm.ptr
  "llvm.call"(%137, %6) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @wv_st, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, vector<4xi64>) -> ()
  %138 = "llvm.add"(%117, %10) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %139 = "llvm.inttoptr"(%138) : (i64) -> !llvm.ptr
  "llvm.call"(%139, %6) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @wv_st, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, vector<4xi64>) -> ()
  %140 = "llvm.add"(%117, %11) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %141 = "llvm.inttoptr"(%140) : (i64) -> !llvm.ptr
  "llvm.call"(%141, %6) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @wv_st, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, vector<4xi64>) -> ()
  %142 = "llvm.add"(%117, %12) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %143 = "llvm.inttoptr"(%142) : (i64) -> !llvm.ptr
  "llvm.call"(%143, %6) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @wv_st, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, vector<4xi64>) -> ()
  %144 = "llvm.add"(%117, %13) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %145 = "llvm.inttoptr"(%144) : (i64) -> !llvm.ptr
  "llvm.call"(%145, %6) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @wv_st, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, vector<4xi64>) -> ()
  %146 = "llvm.add"(%124, %120) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %147 = "llvm.icmp"(%123, %14) <{predicate = 8 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%147, %146, %117, %123, %123, %117, %146)[^bb8, ^bb7] <{operandSegmentSizes = array<i32: 1, 3, 3>}> : (i1, i64, i64, i64, i64, i64, i64) -> ()
^bb7(%148: i64, %149: i64, %150: i64):  // 2 preds: ^bb6, ^bb8
  %151 = "llvm.icmp"(%148, %5) <{predicate = 8 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%151, %150, %149, %148, %148, %149, %150)[^bb9, ^bb10] <{operandSegmentSizes = array<i32: 1, 3, 3>}> : (i1, i64, i64, i64, i64, i64, i64) -> ()
^bb8(%152: i64, %153: i64, %154: i64):  // 2 preds: ^bb6, ^bb8
  %155 = "llvm.inttoptr"(%153) : (i64) -> !llvm.ptr
  %156 = "llvm.inttoptr"(%152) : (i64) -> !llvm.ptr
  %157 = "llvm.load"(%156) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.call"(%155, %157) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @wv_st, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, vector<4xi64>) -> ()
  %158 = "llvm.add"(%153, %7) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %159 = "llvm.add"(%152, %7) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %160 = "llvm.add"(%154, %15) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %161 = "llvm.icmp"(%160, %14) <{predicate = 8 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%161, %159, %158, %160, %160, %158, %159)[^bb8, ^bb7] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true>, mustProgress = true>, operandSegmentSizes = array<i32: 1, 3, 3>}> : (i1, i64, i64, i64, i64, i64, i64) -> ()
^bb9(%162: i64, %163: i64, %164: i64):  // 2 preds: ^bb7, ^bb9
  %165 = "llvm.inttoptr"(%162) : (i64) -> !llvm.ptr
  %166 = "llvm.load"(%165) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %167 = "llvm.inttoptr"(%163) : (i64) -> !llvm.ptr
  "llvm.store"(%166, %167) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %168 = "llvm.add"(%163, %16) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %169 = "llvm.add"(%162, %16) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %170 = "llvm.add"(%164, %17) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %171 = "llvm.icmp"(%170, %5) <{predicate = 8 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%171, %169, %168, %170, %170, %168, %169)[^bb9, ^bb10] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true>, mustProgress = true>, operandSegmentSizes = array<i32: 1, 3, 3>}> : (i1, i64, i64, i64, i64, i64, i64) -> ()
^bb10(%172: i64, %173: i64, %174: i64):  // 2 preds: ^bb7, ^bb9
  %175 = "llvm.icmp"(%172, %18) <{predicate = 8 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%175, %172, %173, %174)[^bb11, ^bb12] <{operandSegmentSizes = array<i32: 1, 0, 3>}> : (i1, i64, i64, i64) -> ()
^bb11:  // pred: ^bb10
  %176 = "llvm.inttoptr"(%174) : (i64) -> !llvm.ptr
  %177 = "llvm.load"(%176) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i32
  %178 = "llvm.inttoptr"(%173) : (i64) -> !llvm.ptr
  "llvm.store"(%177, %178) <{alignment = 4 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i32, !llvm.ptr) -> ()
  %179 = "llvm.add"(%173, %19) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %180 = "llvm.add"(%174, %19) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %181 = "llvm.add"(%172, %20) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  "llvm.br"(%181, %179, %180)[^bb12] : (i64, i64, i64) -> ()
^bb12(%182: i64, %183: i64, %184: i64):  // 2 preds: ^bb10, ^bb11
  %185 = "llvm.icmp"(%182, %21) <{predicate = 8 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%185, %182, %183, %184)[^bb13, ^bb14] <{operandSegmentSizes = array<i32: 1, 0, 3>}> : (i1, i64, i64, i64) -> ()
^bb13:  // pred: ^bb12
  %186 = "llvm.inttoptr"(%184) : (i64) -> !llvm.ptr
  %187 = "llvm.load"(%186) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i16
  %188 = "llvm.inttoptr"(%183) : (i64) -> !llvm.ptr
  "llvm.store"(%187, %188) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i16, !llvm.ptr) -> ()
  %189 = "llvm.add"(%183, %1) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %190 = "llvm.add"(%184, %1) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %191 = "llvm.add"(%182, %22) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  "llvm.br"(%191, %189, %190)[^bb14] : (i64, i64, i64) -> ()
^bb14(%192: i64, %193: i64, %194: i64):  // 2 preds: ^bb12, ^bb13
  %195 = "llvm.icmp"(%192, %2) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%195, %193)[^bb16, ^bb15] <{operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i64) -> ()
^bb15:  // pred: ^bb14
  %196 = "llvm.inttoptr"(%194) : (i64) -> !llvm.ptr
  %197 = "llvm.load"(%196) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %198 = "llvm.inttoptr"(%193) : (i64) -> !llvm.ptr
  "llvm.store"(%197, %198) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (i8, !llvm.ptr) -> ()
  %199 = "llvm.add"(%193, %21) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.br"(%199)[^bb16] : (i64) -> ()
^bb16(%200: i64):  // 2 preds: ^bb14, ^bb15
  %201 = "llvm.inttoptr"(%200) : (i64) -> !llvm.ptr
  "llvm.store"(%23, %201) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (i8, !llvm.ptr) -> ()
  %202 = "llvm.lshr"(%122, %24) : (i64, i64) -> i64
  %203 = "llvm.call"(%202) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}], callee = @fd_ulong_bswap.16, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (i64) -> i64
  %204 = "llvm.add"(%130, %25) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %205 = "llvm.inttoptr"(%204) : (i64) -> !llvm.ptr
  "llvm.store"(%203, %205) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %206 = "llvm.shl"(%122, %18) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %207 = "llvm.call"(%206) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}], callee = @fd_ulong_bswap.16, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (i64) -> i64
  %208 = "llvm.add"(%130, %17) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %209 = "llvm.inttoptr"(%208) : (i64) -> !llvm.ptr
  "llvm.store"(%207, %209) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %210 = "llvm.add"(%118, %21) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %211 = "llvm.icmp"(%210, %arg0) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%211, %130, %210)[^bb4, ^bb6] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true>, mustProgress = true>, operandSegmentSizes = array<i32: 1, 0, 2>}> : (i1, i64, i64) -> ()
^bb17(%212: vector<4xi64>, %213: vector<4xi1>, %214: vector<4xi64>, %215: vector<4xi64>, %216: vector<4xi64>, %217: vector<4xi64>, %218: vector<4xi64>, %219: vector<4xi64>, %220: vector<4xi64>, %221: vector<4xi64>, %222: vector<4xi64>, %223: vector<4xi64>):  // 2 preds: ^bb5, ^bb19
  %224 = "llvm.icmp"(%223, %105) <{predicate = 0 : i64}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi1>
  %225 = "llvm.select"(%224, %104, %222) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<4xi1>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %226 = "llvm.select"(%213, %225, %93) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<4xi1>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %227 = "llvm.extractelement"(%226, %2) : (vector<4xi64>, i64) -> i64
  %228 = "llvm.inttoptr"(%227) : (i64) -> !llvm.ptr
  %229 = "llvm.extractelement"(%226, %21) : (vector<4xi64>, i64) -> i64
  %230 = "llvm.inttoptr"(%229) : (i64) -> !llvm.ptr
  %231 = "llvm.extractelement"(%226, %1) : (vector<4xi64>, i64) -> i64
  %232 = "llvm.inttoptr"(%231) : (i64) -> !llvm.ptr
  %233 = "llvm.extractelement"(%226, %18) : (vector<4xi64>, i64) -> i64
  %234 = "llvm.inttoptr"(%233) : (i64) -> !llvm.ptr
  %235 = "llvm.load"(%228) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<4xi64>
  %236 = "llvm.intr.fshl"(%235, %235, %49) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %237 = "llvm.bitcast"(%236) : (vector<4xi64>) -> vector<32xi8>
  %238 = "llvm.load"(%230) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<4xi64>
  %239 = "llvm.intr.fshl"(%238, %238, %49) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %240 = "llvm.bitcast"(%239) : (vector<4xi64>) -> vector<32xi8>
  %241 = "llvm.load"(%232) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<4xi64>
  %242 = "llvm.intr.fshl"(%241, %241, %49) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %243 = "llvm.bitcast"(%242) : (vector<4xi64>) -> vector<32xi8>
  %244 = "llvm.load"(%234) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<4xi64>
  %245 = "llvm.intr.fshl"(%244, %244, %49) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %246 = "llvm.bitcast"(%245) : (vector<4xi64>) -> vector<32xi8>
  %247 = "llvm.shufflevector"(%237, %243) <{mask = array<i32: 3, 2, 1, 0, 7, 6, 5, 4, 11, 10, 9, 8, 15, 14, 13, 12, 35, 34, 33, 32, 39, 38, 37, 36, 43, 42, 41, 40, 47, 46, 45, 44>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %248 = "llvm.bitcast"(%247) : (vector<32xi8>) -> vector<8xi32>
  %249 = "llvm.shufflevector"(%237, %243) <{mask = array<i32: 19, 18, 17, 16, 23, 22, 21, 20, 27, 26, 25, 24, 31, 30, 29, 28, 51, 50, 49, 48, 55, 54, 53, 52, 59, 58, 57, 56, 63, 62, 61, 60>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %250 = "llvm.bitcast"(%249) : (vector<32xi8>) -> vector<8xi32>
  %251 = "llvm.shufflevector"(%240, %246) <{mask = array<i32: 3, 2, 1, 0, 7, 6, 5, 4, 11, 10, 9, 8, 15, 14, 13, 12, 35, 34, 33, 32, 39, 38, 37, 36, 43, 42, 41, 40, 47, 46, 45, 44>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %252 = "llvm.bitcast"(%251) : (vector<32xi8>) -> vector<8xi32>
  %253 = "llvm.shufflevector"(%240, %246) <{mask = array<i32: 19, 18, 17, 16, 23, 22, 21, 20, 27, 26, 25, 24, 31, 30, 29, 28, 51, 50, 49, 48, 55, 54, 53, 52, 59, 58, 57, 56, 63, 62, 61, 60>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %254 = "llvm.bitcast"(%253) : (vector<32xi8>) -> vector<8xi32>
  %255 = "llvm.shufflevector"(%248, %252) <{mask = array<i32: 0, 1, 8, 9, 4, 5, 12, 13>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %256 = "llvm.bitcast"(%255) : (vector<8xi32>) -> vector<4xi64>
  %257 = "llvm.shufflevector"(%248, %252) <{mask = array<i32: 2, 3, 10, 11, 6, 7, 14, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %258 = "llvm.bitcast"(%257) : (vector<8xi32>) -> vector<4xi64>
  %259 = "llvm.shufflevector"(%250, %254) <{mask = array<i32: 0, 1, 8, 9, 4, 5, 12, 13>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %260 = "llvm.bitcast"(%259) : (vector<8xi32>) -> vector<4xi64>
  %261 = "llvm.shufflevector"(%250, %254) <{mask = array<i32: 2, 3, 10, 11, 6, 7, 14, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %262 = "llvm.bitcast"(%261) : (vector<8xi32>) -> vector<4xi64>
  %263 = "llvm.getelementptr"(%228) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %264 = "llvm.load"(%263) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<4xi64>
  %265 = "llvm.intr.fshl"(%264, %264, %49) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %266 = "llvm.bitcast"(%265) : (vector<4xi64>) -> vector<32xi8>
  %267 = "llvm.getelementptr"(%230) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %268 = "llvm.load"(%267) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<4xi64>
  %269 = "llvm.intr.fshl"(%268, %268, %49) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %270 = "llvm.bitcast"(%269) : (vector<4xi64>) -> vector<32xi8>
  %271 = "llvm.getelementptr"(%232) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %272 = "llvm.load"(%271) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<4xi64>
  %273 = "llvm.intr.fshl"(%272, %272, %49) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %274 = "llvm.bitcast"(%273) : (vector<4xi64>) -> vector<32xi8>
  %275 = "llvm.getelementptr"(%234) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %276 = "llvm.load"(%275) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<4xi64>
  %277 = "llvm.intr.fshl"(%276, %276, %49) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %278 = "llvm.bitcast"(%277) : (vector<4xi64>) -> vector<32xi8>
  %279 = "llvm.shufflevector"(%266, %274) <{mask = array<i32: 3, 2, 1, 0, 7, 6, 5, 4, 11, 10, 9, 8, 15, 14, 13, 12, 35, 34, 33, 32, 39, 38, 37, 36, 43, 42, 41, 40, 47, 46, 45, 44>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %280 = "llvm.bitcast"(%279) : (vector<32xi8>) -> vector<8xi32>
  %281 = "llvm.shufflevector"(%266, %274) <{mask = array<i32: 19, 18, 17, 16, 23, 22, 21, 20, 27, 26, 25, 24, 31, 30, 29, 28, 51, 50, 49, 48, 55, 54, 53, 52, 59, 58, 57, 56, 63, 62, 61, 60>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %282 = "llvm.bitcast"(%281) : (vector<32xi8>) -> vector<8xi32>
  %283 = "llvm.shufflevector"(%270, %278) <{mask = array<i32: 3, 2, 1, 0, 7, 6, 5, 4, 11, 10, 9, 8, 15, 14, 13, 12, 35, 34, 33, 32, 39, 38, 37, 36, 43, 42, 41, 40, 47, 46, 45, 44>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %284 = "llvm.bitcast"(%283) : (vector<32xi8>) -> vector<8xi32>
  %285 = "llvm.shufflevector"(%270, %278) <{mask = array<i32: 19, 18, 17, 16, 23, 22, 21, 20, 27, 26, 25, 24, 31, 30, 29, 28, 51, 50, 49, 48, 55, 54, 53, 52, 59, 58, 57, 56, 63, 62, 61, 60>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %286 = "llvm.bitcast"(%285) : (vector<32xi8>) -> vector<8xi32>
  %287 = "llvm.shufflevector"(%280, %284) <{mask = array<i32: 0, 1, 8, 9, 4, 5, 12, 13>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %288 = "llvm.bitcast"(%287) : (vector<8xi32>) -> vector<4xi64>
  %289 = "llvm.shufflevector"(%280, %284) <{mask = array<i32: 2, 3, 10, 11, 6, 7, 14, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %290 = "llvm.bitcast"(%289) : (vector<8xi32>) -> vector<4xi64>
  %291 = "llvm.shufflevector"(%282, %286) <{mask = array<i32: 0, 1, 8, 9, 4, 5, 12, 13>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %292 = "llvm.bitcast"(%291) : (vector<8xi32>) -> vector<4xi64>
  %293 = "llvm.shufflevector"(%282, %286) <{mask = array<i32: 2, 3, 10, 11, 6, 7, 14, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %294 = "llvm.bitcast"(%293) : (vector<8xi32>) -> vector<4xi64>
  %295 = "llvm.getelementptr"(%228) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %296 = "llvm.load"(%295) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<4xi64>
  %297 = "llvm.intr.fshl"(%296, %296, %49) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %298 = "llvm.bitcast"(%297) : (vector<4xi64>) -> vector<32xi8>
  %299 = "llvm.getelementptr"(%230) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %300 = "llvm.load"(%299) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<4xi64>
  %301 = "llvm.intr.fshl"(%300, %300, %49) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %302 = "llvm.bitcast"(%301) : (vector<4xi64>) -> vector<32xi8>
  %303 = "llvm.getelementptr"(%232) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %304 = "llvm.load"(%303) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<4xi64>
  %305 = "llvm.intr.fshl"(%304, %304, %49) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %306 = "llvm.bitcast"(%305) : (vector<4xi64>) -> vector<32xi8>
  %307 = "llvm.getelementptr"(%234) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %308 = "llvm.load"(%307) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<4xi64>
  %309 = "llvm.intr.fshl"(%308, %308, %49) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %310 = "llvm.bitcast"(%309) : (vector<4xi64>) -> vector<32xi8>
  %311 = "llvm.shufflevector"(%298, %306) <{mask = array<i32: 3, 2, 1, 0, 7, 6, 5, 4, 11, 10, 9, 8, 15, 14, 13, 12, 35, 34, 33, 32, 39, 38, 37, 36, 43, 42, 41, 40, 47, 46, 45, 44>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %312 = "llvm.bitcast"(%311) : (vector<32xi8>) -> vector<8xi32>
  %313 = "llvm.shufflevector"(%298, %306) <{mask = array<i32: 19, 18, 17, 16, 23, 22, 21, 20, 27, 26, 25, 24, 31, 30, 29, 28, 51, 50, 49, 48, 55, 54, 53, 52, 59, 58, 57, 56, 63, 62, 61, 60>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %314 = "llvm.bitcast"(%313) : (vector<32xi8>) -> vector<8xi32>
  %315 = "llvm.shufflevector"(%302, %310) <{mask = array<i32: 3, 2, 1, 0, 7, 6, 5, 4, 11, 10, 9, 8, 15, 14, 13, 12, 35, 34, 33, 32, 39, 38, 37, 36, 43, 42, 41, 40, 47, 46, 45, 44>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %316 = "llvm.bitcast"(%315) : (vector<32xi8>) -> vector<8xi32>
  %317 = "llvm.shufflevector"(%302, %310) <{mask = array<i32: 19, 18, 17, 16, 23, 22, 21, 20, 27, 26, 25, 24, 31, 30, 29, 28, 51, 50, 49, 48, 55, 54, 53, 52, 59, 58, 57, 56, 63, 62, 61, 60>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %318 = "llvm.bitcast"(%317) : (vector<32xi8>) -> vector<8xi32>
  %319 = "llvm.shufflevector"(%312, %316) <{mask = array<i32: 0, 1, 8, 9, 4, 5, 12, 13>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %320 = "llvm.bitcast"(%319) : (vector<8xi32>) -> vector<4xi64>
  %321 = "llvm.shufflevector"(%312, %316) <{mask = array<i32: 2, 3, 10, 11, 6, 7, 14, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %322 = "llvm.bitcast"(%321) : (vector<8xi32>) -> vector<4xi64>
  %323 = "llvm.shufflevector"(%314, %318) <{mask = array<i32: 0, 1, 8, 9, 4, 5, 12, 13>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %324 = "llvm.bitcast"(%323) : (vector<8xi32>) -> vector<4xi64>
  %325 = "llvm.shufflevector"(%314, %318) <{mask = array<i32: 2, 3, 10, 11, 6, 7, 14, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %326 = "llvm.bitcast"(%325) : (vector<8xi32>) -> vector<4xi64>
  %327 = "llvm.getelementptr"(%228) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 96>}> : (!llvm.ptr) -> !llvm.ptr
  %328 = "llvm.load"(%327) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<4xi64>
  %329 = "llvm.intr.fshl"(%328, %328, %49) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %330 = "llvm.bitcast"(%329) : (vector<4xi64>) -> vector<32xi8>
  %331 = "llvm.getelementptr"(%230) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 96>}> : (!llvm.ptr) -> !llvm.ptr
  %332 = "llvm.load"(%331) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<4xi64>
  %333 = "llvm.intr.fshl"(%332, %332, %49) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %334 = "llvm.bitcast"(%333) : (vector<4xi64>) -> vector<32xi8>
  %335 = "llvm.getelementptr"(%232) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 96>}> : (!llvm.ptr) -> !llvm.ptr
  %336 = "llvm.load"(%335) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<4xi64>
  %337 = "llvm.intr.fshl"(%336, %336, %49) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %338 = "llvm.bitcast"(%337) : (vector<4xi64>) -> vector<32xi8>
  %339 = "llvm.getelementptr"(%234) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 96>}> : (!llvm.ptr) -> !llvm.ptr
  %340 = "llvm.load"(%339) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<4xi64>
  %341 = "llvm.intr.fshl"(%340, %340, %49) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %342 = "llvm.bitcast"(%341) : (vector<4xi64>) -> vector<32xi8>
  %343 = "llvm.shufflevector"(%330, %338) <{mask = array<i32: 3, 2, 1, 0, 7, 6, 5, 4, 11, 10, 9, 8, 15, 14, 13, 12, 35, 34, 33, 32, 39, 38, 37, 36, 43, 42, 41, 40, 47, 46, 45, 44>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %344 = "llvm.bitcast"(%343) : (vector<32xi8>) -> vector<8xi32>
  %345 = "llvm.shufflevector"(%330, %338) <{mask = array<i32: 19, 18, 17, 16, 23, 22, 21, 20, 27, 26, 25, 24, 31, 30, 29, 28, 51, 50, 49, 48, 55, 54, 53, 52, 59, 58, 57, 56, 63, 62, 61, 60>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %346 = "llvm.bitcast"(%345) : (vector<32xi8>) -> vector<8xi32>
  %347 = "llvm.shufflevector"(%334, %342) <{mask = array<i32: 3, 2, 1, 0, 7, 6, 5, 4, 11, 10, 9, 8, 15, 14, 13, 12, 35, 34, 33, 32, 39, 38, 37, 36, 43, 42, 41, 40, 47, 46, 45, 44>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %348 = "llvm.bitcast"(%347) : (vector<32xi8>) -> vector<8xi32>
  %349 = "llvm.shufflevector"(%334, %342) <{mask = array<i32: 19, 18, 17, 16, 23, 22, 21, 20, 27, 26, 25, 24, 31, 30, 29, 28, 51, 50, 49, 48, 55, 54, 53, 52, 59, 58, 57, 56, 63, 62, 61, 60>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %350 = "llvm.bitcast"(%349) : (vector<32xi8>) -> vector<8xi32>
  %351 = "llvm.shufflevector"(%344, %348) <{mask = array<i32: 0, 1, 8, 9, 4, 5, 12, 13>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %352 = "llvm.bitcast"(%351) : (vector<8xi32>) -> vector<4xi64>
  %353 = "llvm.shufflevector"(%344, %348) <{mask = array<i32: 2, 3, 10, 11, 6, 7, 14, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %354 = "llvm.bitcast"(%353) : (vector<8xi32>) -> vector<4xi64>
  %355 = "llvm.shufflevector"(%346, %350) <{mask = array<i32: 0, 1, 8, 9, 4, 5, 12, 13>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %356 = "llvm.bitcast"(%355) : (vector<8xi32>) -> vector<4xi64>
  %357 = "llvm.shufflevector"(%346, %350) <{mask = array<i32: 2, 3, 10, 11, 6, 7, 14, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %358 = "llvm.bitcast"(%357) : (vector<8xi32>) -> vector<4xi64>
  %359 = "llvm.intr.fshl"(%218, %218, %50) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %360 = "llvm.intr.fshl"(%218, %218, %51) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %361 = "llvm.intr.fshl"(%218, %218, %52) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %362 = "llvm.xor"(%360, %361) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %363 = "llvm.xor"(%362, %359) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %364 = "llvm.and"(%218, %219) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %365 = "llvm.xor"(%218, %53) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %366 = "llvm.and"(%220, %365) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %367 = "llvm.or"(%364, %366) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %368 = "llvm.add"(%221, %54) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %369 = "llvm.add"(%368, %367) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %370 = "llvm.add"(%369, %363) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %371 = "llvm.add"(%370, %256) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %372 = "llvm.intr.fshl"(%214, %214, %55) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %373 = "llvm.intr.fshl"(%214, %214, %56) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %374 = "llvm.intr.fshl"(%214, %214, %57) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %375 = "llvm.xor"(%373, %374) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %376 = "llvm.xor"(%375, %372) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %377 = "llvm.and"(%214, %215) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %378 = "llvm.xor"(%214, %215) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %379 = "llvm.and"(%378, %216) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %380 = "llvm.xor"(%379, %377) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %381 = "llvm.add"(%376, %380) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %382 = "llvm.add"(%371, %217) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %383 = "llvm.add"(%381, %371) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %384 = "llvm.intr.fshl"(%382, %382, %50) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %385 = "llvm.intr.fshl"(%382, %382, %51) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %386 = "llvm.intr.fshl"(%382, %382, %52) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %387 = "llvm.xor"(%385, %386) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %388 = "llvm.xor"(%387, %384) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %389 = "llvm.and"(%382, %218) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %390 = "llvm.xor"(%382, %53) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %391 = "llvm.and"(%219, %390) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %392 = "llvm.or"(%389, %391) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %393 = "llvm.add"(%220, %58) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %394 = "llvm.add"(%393, %258) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %395 = "llvm.add"(%394, %392) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %396 = "llvm.add"(%395, %388) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %397 = "llvm.intr.fshl"(%383, %383, %55) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %398 = "llvm.intr.fshl"(%383, %383, %56) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %399 = "llvm.intr.fshl"(%383, %383, %57) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %400 = "llvm.xor"(%398, %399) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %401 = "llvm.xor"(%400, %397) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %402 = "llvm.and"(%383, %214) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %403 = "llvm.xor"(%383, %214) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %404 = "llvm.and"(%403, %215) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %405 = "llvm.xor"(%404, %402) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %406 = "llvm.add"(%401, %405) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %407 = "llvm.add"(%396, %216) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %408 = "llvm.add"(%406, %396) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %409 = "llvm.intr.fshl"(%407, %407, %50) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %410 = "llvm.intr.fshl"(%407, %407, %51) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %411 = "llvm.intr.fshl"(%407, %407, %52) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %412 = "llvm.xor"(%410, %411) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %413 = "llvm.xor"(%412, %409) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %414 = "llvm.and"(%407, %382) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %415 = "llvm.xor"(%407, %53) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %416 = "llvm.and"(%218, %415) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %417 = "llvm.or"(%414, %416) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %418 = "llvm.add"(%219, %59) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %419 = "llvm.add"(%418, %260) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %420 = "llvm.add"(%419, %417) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %421 = "llvm.add"(%420, %413) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %422 = "llvm.intr.fshl"(%408, %408, %55) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %423 = "llvm.intr.fshl"(%408, %408, %56) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %424 = "llvm.intr.fshl"(%408, %408, %57) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %425 = "llvm.xor"(%423, %424) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %426 = "llvm.xor"(%425, %422) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %427 = "llvm.and"(%408, %383) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %428 = "llvm.xor"(%408, %383) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %429 = "llvm.and"(%428, %214) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %430 = "llvm.xor"(%429, %427) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %431 = "llvm.add"(%426, %430) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %432 = "llvm.add"(%421, %215) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %433 = "llvm.add"(%431, %421) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %434 = "llvm.intr.fshl"(%432, %432, %50) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %435 = "llvm.intr.fshl"(%432, %432, %51) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %436 = "llvm.intr.fshl"(%432, %432, %52) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %437 = "llvm.xor"(%435, %436) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %438 = "llvm.xor"(%437, %434) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %439 = "llvm.and"(%432, %407) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %440 = "llvm.xor"(%432, %53) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %441 = "llvm.and"(%382, %440) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %442 = "llvm.or"(%439, %441) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %443 = "llvm.add"(%218, %60) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %444 = "llvm.add"(%443, %262) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %445 = "llvm.add"(%444, %442) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %446 = "llvm.add"(%445, %438) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %447 = "llvm.intr.fshl"(%433, %433, %55) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %448 = "llvm.intr.fshl"(%433, %433, %56) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %449 = "llvm.intr.fshl"(%433, %433, %57) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %450 = "llvm.xor"(%448, %449) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %451 = "llvm.xor"(%450, %447) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %452 = "llvm.and"(%433, %408) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %453 = "llvm.xor"(%433, %408) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %454 = "llvm.and"(%453, %383) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %455 = "llvm.xor"(%454, %452) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %456 = "llvm.add"(%451, %455) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %457 = "llvm.add"(%446, %214) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %458 = "llvm.add"(%456, %446) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %459 = "llvm.intr.fshl"(%457, %457, %50) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %460 = "llvm.intr.fshl"(%457, %457, %51) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %461 = "llvm.intr.fshl"(%457, %457, %52) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %462 = "llvm.xor"(%460, %461) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %463 = "llvm.xor"(%462, %459) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %464 = "llvm.and"(%457, %432) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %465 = "llvm.xor"(%457, %53) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %466 = "llvm.and"(%407, %465) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %467 = "llvm.or"(%464, %466) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %468 = "llvm.add"(%382, %61) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %469 = "llvm.add"(%468, %288) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %470 = "llvm.add"(%469, %467) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %471 = "llvm.add"(%470, %463) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %472 = "llvm.intr.fshl"(%458, %458, %55) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %473 = "llvm.intr.fshl"(%458, %458, %56) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %474 = "llvm.intr.fshl"(%458, %458, %57) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %475 = "llvm.xor"(%473, %474) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %476 = "llvm.xor"(%475, %472) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %477 = "llvm.and"(%458, %433) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %478 = "llvm.xor"(%458, %433) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %479 = "llvm.and"(%478, %408) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %480 = "llvm.xor"(%479, %477) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %481 = "llvm.add"(%476, %480) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %482 = "llvm.add"(%471, %383) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %483 = "llvm.add"(%481, %471) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %484 = "llvm.intr.fshl"(%482, %482, %50) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %485 = "llvm.intr.fshl"(%482, %482, %51) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %486 = "llvm.intr.fshl"(%482, %482, %52) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %487 = "llvm.xor"(%485, %486) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %488 = "llvm.xor"(%487, %484) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %489 = "llvm.and"(%482, %457) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %490 = "llvm.xor"(%482, %53) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %491 = "llvm.and"(%432, %490) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %492 = "llvm.or"(%489, %491) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %493 = "llvm.add"(%290, %62) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %494 = "llvm.add"(%493, %407) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %495 = "llvm.add"(%494, %492) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %496 = "llvm.add"(%495, %488) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %497 = "llvm.intr.fshl"(%483, %483, %55) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %498 = "llvm.intr.fshl"(%483, %483, %56) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %499 = "llvm.intr.fshl"(%483, %483, %57) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %500 = "llvm.xor"(%498, %499) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %501 = "llvm.xor"(%500, %497) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %502 = "llvm.and"(%483, %458) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %503 = "llvm.xor"(%483, %458) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %504 = "llvm.and"(%503, %433) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %505 = "llvm.xor"(%504, %502) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %506 = "llvm.add"(%501, %505) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %507 = "llvm.add"(%496, %408) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %508 = "llvm.add"(%506, %496) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %509 = "llvm.intr.fshl"(%507, %507, %50) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %510 = "llvm.intr.fshl"(%507, %507, %51) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %511 = "llvm.intr.fshl"(%507, %507, %52) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %512 = "llvm.xor"(%510, %511) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %513 = "llvm.xor"(%512, %509) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %514 = "llvm.and"(%507, %482) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %515 = "llvm.xor"(%507, %53) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %516 = "llvm.and"(%457, %515) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %517 = "llvm.or"(%514, %516) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %518 = "llvm.add"(%292, %63) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %519 = "llvm.add"(%518, %432) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %520 = "llvm.add"(%519, %517) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %521 = "llvm.add"(%520, %513) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %522 = "llvm.intr.fshl"(%508, %508, %55) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %523 = "llvm.intr.fshl"(%508, %508, %56) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %524 = "llvm.intr.fshl"(%508, %508, %57) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %525 = "llvm.xor"(%523, %524) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %526 = "llvm.xor"(%525, %522) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %527 = "llvm.and"(%508, %483) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %528 = "llvm.xor"(%508, %483) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %529 = "llvm.and"(%528, %458) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %530 = "llvm.xor"(%529, %527) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %531 = "llvm.add"(%526, %530) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %532 = "llvm.add"(%521, %433) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %533 = "llvm.add"(%531, %521) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %534 = "llvm.intr.fshl"(%532, %532, %50) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %535 = "llvm.intr.fshl"(%532, %532, %51) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %536 = "llvm.intr.fshl"(%532, %532, %52) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %537 = "llvm.xor"(%535, %536) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %538 = "llvm.xor"(%537, %534) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %539 = "llvm.and"(%532, %507) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %540 = "llvm.xor"(%532, %53) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %541 = "llvm.and"(%482, %540) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %542 = "llvm.or"(%539, %541) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %543 = "llvm.add"(%294, %64) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %544 = "llvm.add"(%543, %457) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %545 = "llvm.add"(%544, %542) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %546 = "llvm.add"(%545, %538) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %547 = "llvm.intr.fshl"(%533, %533, %55) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %548 = "llvm.intr.fshl"(%533, %533, %56) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %549 = "llvm.intr.fshl"(%533, %533, %57) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %550 = "llvm.xor"(%548, %549) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %551 = "llvm.xor"(%550, %547) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %552 = "llvm.and"(%533, %508) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %553 = "llvm.xor"(%533, %508) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %554 = "llvm.and"(%553, %483) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %555 = "llvm.xor"(%554, %552) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %556 = "llvm.add"(%551, %555) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %557 = "llvm.add"(%546, %458) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %558 = "llvm.add"(%556, %546) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %559 = "llvm.intr.fshl"(%557, %557, %50) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %560 = "llvm.intr.fshl"(%557, %557, %51) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %561 = "llvm.intr.fshl"(%557, %557, %52) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %562 = "llvm.xor"(%560, %561) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %563 = "llvm.xor"(%562, %559) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %564 = "llvm.and"(%557, %532) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %565 = "llvm.xor"(%557, %53) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %566 = "llvm.and"(%507, %565) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %567 = "llvm.or"(%564, %566) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %568 = "llvm.add"(%320, %65) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %569 = "llvm.add"(%568, %482) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %570 = "llvm.add"(%569, %567) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %571 = "llvm.add"(%570, %563) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %572 = "llvm.intr.fshl"(%558, %558, %55) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %573 = "llvm.intr.fshl"(%558, %558, %56) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %574 = "llvm.intr.fshl"(%558, %558, %57) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %575 = "llvm.xor"(%573, %574) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %576 = "llvm.xor"(%575, %572) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %577 = "llvm.and"(%558, %533) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %578 = "llvm.xor"(%558, %533) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %579 = "llvm.and"(%578, %508) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %580 = "llvm.xor"(%579, %577) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %581 = "llvm.add"(%576, %580) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %582 = "llvm.add"(%571, %483) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %583 = "llvm.add"(%581, %571) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %584 = "llvm.intr.fshl"(%582, %582, %50) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %585 = "llvm.intr.fshl"(%582, %582, %51) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %586 = "llvm.intr.fshl"(%582, %582, %52) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %587 = "llvm.xor"(%585, %586) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %588 = "llvm.xor"(%587, %584) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %589 = "llvm.and"(%582, %557) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %590 = "llvm.xor"(%582, %53) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %591 = "llvm.and"(%532, %590) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %592 = "llvm.or"(%589, %591) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %593 = "llvm.add"(%322, %66) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %594 = "llvm.add"(%593, %507) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %595 = "llvm.add"(%594, %592) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %596 = "llvm.add"(%595, %588) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %597 = "llvm.intr.fshl"(%583, %583, %55) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %598 = "llvm.intr.fshl"(%583, %583, %56) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %599 = "llvm.intr.fshl"(%583, %583, %57) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %600 = "llvm.xor"(%598, %599) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %601 = "llvm.xor"(%600, %597) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %602 = "llvm.and"(%583, %558) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %603 = "llvm.xor"(%583, %558) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %604 = "llvm.and"(%603, %533) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %605 = "llvm.xor"(%604, %602) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %606 = "llvm.add"(%601, %605) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %607 = "llvm.add"(%596, %508) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %608 = "llvm.add"(%606, %596) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %609 = "llvm.intr.fshl"(%607, %607, %50) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %610 = "llvm.intr.fshl"(%607, %607, %51) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %611 = "llvm.intr.fshl"(%607, %607, %52) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %612 = "llvm.xor"(%610, %611) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %613 = "llvm.xor"(%612, %609) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %614 = "llvm.and"(%607, %582) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %615 = "llvm.xor"(%607, %53) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %616 = "llvm.and"(%557, %615) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %617 = "llvm.or"(%614, %616) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %618 = "llvm.add"(%324, %67) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %619 = "llvm.add"(%618, %532) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %620 = "llvm.add"(%619, %617) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %621 = "llvm.add"(%620, %613) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %622 = "llvm.intr.fshl"(%608, %608, %55) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %623 = "llvm.intr.fshl"(%608, %608, %56) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %624 = "llvm.intr.fshl"(%608, %608, %57) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %625 = "llvm.xor"(%623, %624) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %626 = "llvm.xor"(%625, %622) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %627 = "llvm.and"(%608, %583) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %628 = "llvm.xor"(%608, %583) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %629 = "llvm.and"(%628, %558) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %630 = "llvm.xor"(%629, %627) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %631 = "llvm.add"(%626, %630) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %632 = "llvm.add"(%621, %533) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %633 = "llvm.add"(%631, %621) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %634 = "llvm.intr.fshl"(%632, %632, %50) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %635 = "llvm.intr.fshl"(%632, %632, %51) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %636 = "llvm.intr.fshl"(%632, %632, %52) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %637 = "llvm.xor"(%635, %636) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %638 = "llvm.xor"(%637, %634) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %639 = "llvm.and"(%632, %607) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %640 = "llvm.xor"(%632, %53) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %641 = "llvm.and"(%582, %640) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %642 = "llvm.or"(%639, %641) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %643 = "llvm.add"(%326, %68) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %644 = "llvm.add"(%643, %557) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %645 = "llvm.add"(%644, %642) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %646 = "llvm.add"(%645, %638) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %647 = "llvm.intr.fshl"(%633, %633, %55) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %648 = "llvm.intr.fshl"(%633, %633, %56) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %649 = "llvm.intr.fshl"(%633, %633, %57) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %650 = "llvm.xor"(%648, %649) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %651 = "llvm.xor"(%650, %647) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %652 = "llvm.and"(%633, %608) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %653 = "llvm.xor"(%633, %608) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %654 = "llvm.and"(%653, %583) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %655 = "llvm.xor"(%654, %652) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %656 = "llvm.add"(%651, %655) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %657 = "llvm.add"(%646, %558) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %658 = "llvm.add"(%656, %646) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %659 = "llvm.intr.fshl"(%657, %657, %50) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %660 = "llvm.intr.fshl"(%657, %657, %51) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %661 = "llvm.intr.fshl"(%657, %657, %52) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %662 = "llvm.xor"(%660, %661) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %663 = "llvm.xor"(%662, %659) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %664 = "llvm.and"(%657, %632) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %665 = "llvm.xor"(%657, %53) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %666 = "llvm.and"(%607, %665) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %667 = "llvm.or"(%664, %666) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %668 = "llvm.add"(%352, %69) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %669 = "llvm.add"(%668, %582) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %670 = "llvm.add"(%669, %667) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %671 = "llvm.add"(%670, %663) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %672 = "llvm.intr.fshl"(%658, %658, %55) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %673 = "llvm.intr.fshl"(%658, %658, %56) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %674 = "llvm.intr.fshl"(%658, %658, %57) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %675 = "llvm.xor"(%673, %674) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %676 = "llvm.xor"(%675, %672) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %677 = "llvm.and"(%658, %633) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %678 = "llvm.xor"(%658, %633) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %679 = "llvm.and"(%678, %608) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %680 = "llvm.xor"(%679, %677) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %681 = "llvm.add"(%676, %680) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %682 = "llvm.add"(%671, %583) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %683 = "llvm.add"(%681, %671) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %684 = "llvm.intr.fshl"(%682, %682, %50) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %685 = "llvm.intr.fshl"(%682, %682, %51) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %686 = "llvm.intr.fshl"(%682, %682, %52) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %687 = "llvm.xor"(%685, %686) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %688 = "llvm.xor"(%687, %684) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %689 = "llvm.and"(%682, %657) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %690 = "llvm.xor"(%682, %53) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %691 = "llvm.and"(%632, %690) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %692 = "llvm.or"(%689, %691) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %693 = "llvm.add"(%354, %70) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %694 = "llvm.add"(%693, %607) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %695 = "llvm.add"(%694, %692) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %696 = "llvm.add"(%695, %688) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %697 = "llvm.intr.fshl"(%683, %683, %55) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %698 = "llvm.intr.fshl"(%683, %683, %56) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %699 = "llvm.intr.fshl"(%683, %683, %57) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %700 = "llvm.xor"(%698, %699) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %701 = "llvm.xor"(%700, %697) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %702 = "llvm.and"(%683, %658) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %703 = "llvm.xor"(%683, %658) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %704 = "llvm.and"(%703, %633) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %705 = "llvm.xor"(%704, %702) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %706 = "llvm.add"(%701, %705) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %707 = "llvm.add"(%696, %608) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %708 = "llvm.add"(%706, %696) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %709 = "llvm.intr.fshl"(%707, %707, %50) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %710 = "llvm.intr.fshl"(%707, %707, %51) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %711 = "llvm.intr.fshl"(%707, %707, %52) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %712 = "llvm.xor"(%710, %711) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %713 = "llvm.xor"(%712, %709) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %714 = "llvm.and"(%707, %682) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %715 = "llvm.xor"(%707, %53) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %716 = "llvm.and"(%657, %715) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %717 = "llvm.or"(%714, %716) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %718 = "llvm.add"(%356, %71) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %719 = "llvm.add"(%718, %632) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %720 = "llvm.add"(%719, %717) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %721 = "llvm.add"(%720, %713) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %722 = "llvm.intr.fshl"(%708, %708, %55) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %723 = "llvm.intr.fshl"(%708, %708, %56) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %724 = "llvm.intr.fshl"(%708, %708, %57) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %725 = "llvm.xor"(%723, %724) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %726 = "llvm.xor"(%725, %722) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %727 = "llvm.and"(%708, %683) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %728 = "llvm.xor"(%708, %683) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %729 = "llvm.and"(%728, %658) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %730 = "llvm.xor"(%729, %727) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %731 = "llvm.add"(%726, %730) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %732 = "llvm.add"(%721, %633) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %733 = "llvm.add"(%731, %721) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %734 = "llvm.intr.fshl"(%732, %732, %50) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %735 = "llvm.intr.fshl"(%732, %732, %51) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %736 = "llvm.intr.fshl"(%732, %732, %52) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %737 = "llvm.xor"(%735, %736) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %738 = "llvm.xor"(%737, %734) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %739 = "llvm.and"(%732, %707) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %740 = "llvm.xor"(%732, %53) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %741 = "llvm.and"(%682, %740) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %742 = "llvm.or"(%739, %741) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %743 = "llvm.add"(%358, %72) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %744 = "llvm.add"(%743, %657) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %745 = "llvm.add"(%744, %742) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %746 = "llvm.add"(%745, %738) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %747 = "llvm.intr.fshl"(%733, %733, %55) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %748 = "llvm.intr.fshl"(%733, %733, %56) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %749 = "llvm.intr.fshl"(%733, %733, %57) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %750 = "llvm.xor"(%748, %749) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %751 = "llvm.xor"(%750, %747) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %752 = "llvm.and"(%733, %708) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %753 = "llvm.xor"(%733, %708) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %754 = "llvm.and"(%753, %683) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %755 = "llvm.xor"(%754, %752) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %756 = "llvm.add"(%751, %755) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %757 = "llvm.add"(%746, %658) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %758 = "llvm.add"(%756, %746) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.br"(%73, %682, %707, %732, %757, %683, %708, %733, %758, %358, %356, %354, %352, %256, %258, %260, %262, %326, %324, %322, %320, %288, %290, %292, %294)[^bb18] : (i64, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
^bb18(%759: i64, %760: vector<4xi64>, %761: vector<4xi64>, %762: vector<4xi64>, %763: vector<4xi64>, %764: vector<4xi64>, %765: vector<4xi64>, %766: vector<4xi64>, %767: vector<4xi64>, %768: vector<4xi64>, %769: vector<4xi64>, %770: vector<4xi64>, %771: vector<4xi64>, %772: vector<4xi64>, %773: vector<4xi64>, %774: vector<4xi64>, %775: vector<4xi64>, %776: vector<4xi64>, %777: vector<4xi64>, %778: vector<4xi64>, %779: vector<4xi64>, %780: vector<4xi64>, %781: vector<4xi64>, %782: vector<4xi64>, %783: vector<4xi64>):  // 2 preds: ^bb17, ^bb18
  %784 = "llvm.intr.fshl"(%773, %773, %74) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %785 = "llvm.intr.fshl"(%773, %773, %75) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %786 = "llvm.lshr"(%773, %31) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %787 = "llvm.xor"(%785, %786) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %788 = "llvm.xor"(%787, %784) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %789 = "llvm.intr.fshl"(%769, %769, %76) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %790 = "llvm.intr.fshl"(%769, %769, %77) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %791 = "llvm.lshr"(%769, %78) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %792 = "llvm.xor"(%790, %791) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %793 = "llvm.xor"(%792, %789) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %794 = "llvm.add"(%772, %778) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %795 = "llvm.add"(%794, %788) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %796 = "llvm.add"(%795, %793) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %797 = "llvm.getelementptr"(%79, %759) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %798 = "llvm.load"(%797) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %799 = "llvm.insertelement"(%26, %798, %2) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %800 = "llvm.shufflevector"(%799, %26) <{mask = array<i32: 0, 0, 0, 0>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %801 = "llvm.intr.fshl"(%763, %763, %50) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %802 = "llvm.intr.fshl"(%763, %763, %51) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %803 = "llvm.intr.fshl"(%763, %763, %52) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %804 = "llvm.xor"(%802, %803) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %805 = "llvm.xor"(%804, %801) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %806 = "llvm.and"(%762, %763) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %807 = "llvm.xor"(%763, %53) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %808 = "llvm.and"(%761, %807) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %809 = "llvm.or"(%808, %806) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %810 = "llvm.add"(%805, %796) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %811 = "llvm.add"(%810, %760) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %812 = "llvm.add"(%811, %809) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %813 = "llvm.add"(%812, %800) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %814 = "llvm.intr.fshl"(%767, %767, %55) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %815 = "llvm.intr.fshl"(%767, %767, %56) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %816 = "llvm.intr.fshl"(%767, %767, %57) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %817 = "llvm.xor"(%815, %816) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %818 = "llvm.xor"(%817, %814) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %819 = "llvm.and"(%766, %767) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %820 = "llvm.xor"(%766, %767) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %821 = "llvm.and"(%820, %765) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %822 = "llvm.xor"(%821, %819) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %823 = "llvm.add"(%822, %818) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %824 = "llvm.add"(%813, %764) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %825 = "llvm.add"(%823, %813) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %826 = "llvm.intr.fshl"(%774, %774, %74) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %827 = "llvm.intr.fshl"(%774, %774, %75) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %828 = "llvm.lshr"(%774, %31) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %829 = "llvm.xor"(%827, %828) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %830 = "llvm.xor"(%829, %826) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %831 = "llvm.intr.fshl"(%768, %768, %76) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %832 = "llvm.intr.fshl"(%768, %768, %77) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %833 = "llvm.lshr"(%768, %78) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %834 = "llvm.xor"(%832, %833) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %835 = "llvm.xor"(%834, %831) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %836 = "llvm.add"(%773, %777) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %837 = "llvm.add"(%836, %830) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %838 = "llvm.add"(%837, %835) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %839 = "llvm.getelementptr"(%797) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %840 = "llvm.load"(%839) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %841 = "llvm.insertelement"(%26, %840, %2) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %842 = "llvm.shufflevector"(%841, %26) <{mask = array<i32: 0, 0, 0, 0>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %843 = "llvm.intr.fshl"(%824, %824, %50) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %844 = "llvm.intr.fshl"(%824, %824, %51) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %845 = "llvm.intr.fshl"(%824, %824, %52) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %846 = "llvm.xor"(%844, %845) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %847 = "llvm.xor"(%846, %843) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %848 = "llvm.and"(%824, %763) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %849 = "llvm.xor"(%824, %53) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %850 = "llvm.and"(%762, %849) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %851 = "llvm.or"(%848, %850) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %852 = "llvm.add"(%761, %838) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %853 = "llvm.add"(%852, %842) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %854 = "llvm.add"(%853, %851) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %855 = "llvm.add"(%854, %847) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %856 = "llvm.intr.fshl"(%825, %825, %55) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %857 = "llvm.intr.fshl"(%825, %825, %56) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %858 = "llvm.intr.fshl"(%825, %825, %57) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %859 = "llvm.xor"(%857, %858) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %860 = "llvm.xor"(%859, %856) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %861 = "llvm.and"(%825, %767) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %862 = "llvm.xor"(%825, %767) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %863 = "llvm.and"(%862, %766) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %864 = "llvm.xor"(%863, %861) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %865 = "llvm.add"(%860, %864) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %866 = "llvm.add"(%855, %765) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %867 = "llvm.add"(%865, %855) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %868 = "llvm.intr.fshl"(%775, %775, %74) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %869 = "llvm.intr.fshl"(%775, %775, %75) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %870 = "llvm.lshr"(%775, %31) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %871 = "llvm.xor"(%869, %870) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %872 = "llvm.xor"(%871, %868) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %873 = "llvm.intr.fshl"(%796, %796, %76) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %874 = "llvm.intr.fshl"(%796, %796, %77) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %875 = "llvm.lshr"(%796, %78) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %876 = "llvm.xor"(%874, %875) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %877 = "llvm.xor"(%876, %873) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %878 = "llvm.add"(%774, %776) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %879 = "llvm.add"(%878, %872) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %880 = "llvm.add"(%879, %877) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %881 = "llvm.getelementptr"(%797) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %882 = "llvm.load"(%881) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %883 = "llvm.insertelement"(%26, %882, %2) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %884 = "llvm.shufflevector"(%883, %26) <{mask = array<i32: 0, 0, 0, 0>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %885 = "llvm.intr.fshl"(%866, %866, %50) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %886 = "llvm.intr.fshl"(%866, %866, %51) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %887 = "llvm.intr.fshl"(%866, %866, %52) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %888 = "llvm.xor"(%886, %887) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %889 = "llvm.xor"(%888, %885) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %890 = "llvm.and"(%866, %824) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %891 = "llvm.xor"(%866, %53) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %892 = "llvm.and"(%763, %891) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %893 = "llvm.or"(%890, %892) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %894 = "llvm.add"(%880, %762) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %895 = "llvm.add"(%894, %884) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %896 = "llvm.add"(%895, %893) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %897 = "llvm.add"(%896, %889) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %898 = "llvm.intr.fshl"(%867, %867, %55) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %899 = "llvm.intr.fshl"(%867, %867, %56) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %900 = "llvm.intr.fshl"(%867, %867, %57) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %901 = "llvm.xor"(%899, %900) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %902 = "llvm.xor"(%901, %898) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %903 = "llvm.and"(%867, %825) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %904 = "llvm.xor"(%867, %825) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %905 = "llvm.and"(%904, %767) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %906 = "llvm.xor"(%905, %903) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %907 = "llvm.add"(%902, %906) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %908 = "llvm.add"(%897, %766) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %909 = "llvm.add"(%907, %897) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %910 = "llvm.intr.fshl"(%780, %780, %74) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %911 = "llvm.intr.fshl"(%780, %780, %75) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %912 = "llvm.lshr"(%780, %31) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %913 = "llvm.xor"(%911, %912) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %914 = "llvm.xor"(%913, %910) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %915 = "llvm.intr.fshl"(%838, %838, %76) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %916 = "llvm.intr.fshl"(%838, %838, %77) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %917 = "llvm.lshr"(%838, %78) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %918 = "llvm.xor"(%916, %917) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %919 = "llvm.xor"(%918, %915) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %920 = "llvm.add"(%775, %914) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %921 = "llvm.add"(%920, %771) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %922 = "llvm.add"(%921, %919) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %923 = "llvm.getelementptr"(%797) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %924 = "llvm.load"(%923) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %925 = "llvm.insertelement"(%26, %924, %2) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %926 = "llvm.shufflevector"(%925, %26) <{mask = array<i32: 0, 0, 0, 0>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %927 = "llvm.intr.fshl"(%908, %908, %50) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %928 = "llvm.intr.fshl"(%908, %908, %51) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %929 = "llvm.intr.fshl"(%908, %908, %52) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %930 = "llvm.xor"(%928, %929) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %931 = "llvm.xor"(%930, %927) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %932 = "llvm.and"(%908, %866) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %933 = "llvm.xor"(%908, %53) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %934 = "llvm.and"(%824, %933) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %935 = "llvm.or"(%932, %934) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %936 = "llvm.add"(%922, %763) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %937 = "llvm.add"(%936, %926) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %938 = "llvm.add"(%937, %935) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %939 = "llvm.add"(%938, %931) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %940 = "llvm.intr.fshl"(%909, %909, %55) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %941 = "llvm.intr.fshl"(%909, %909, %56) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %942 = "llvm.intr.fshl"(%909, %909, %57) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %943 = "llvm.xor"(%941, %942) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %944 = "llvm.xor"(%943, %940) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %945 = "llvm.and"(%909, %867) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %946 = "llvm.xor"(%909, %867) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %947 = "llvm.and"(%946, %825) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %948 = "llvm.xor"(%947, %945) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %949 = "llvm.add"(%944, %948) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %950 = "llvm.add"(%939, %767) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %951 = "llvm.add"(%949, %939) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %952 = "llvm.intr.fshl"(%781, %781, %74) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %953 = "llvm.intr.fshl"(%781, %781, %75) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %954 = "llvm.lshr"(%781, %31) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %955 = "llvm.xor"(%953, %954) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %956 = "llvm.xor"(%955, %952) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %957 = "llvm.intr.fshl"(%880, %880, %76) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %958 = "llvm.intr.fshl"(%880, %880, %77) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %959 = "llvm.lshr"(%880, %78) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %960 = "llvm.xor"(%958, %959) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %961 = "llvm.xor"(%960, %957) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %962 = "llvm.add"(%956, %780) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %963 = "llvm.add"(%962, %770) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %964 = "llvm.add"(%963, %961) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %965 = "llvm.getelementptr"(%797) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %966 = "llvm.load"(%965) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %967 = "llvm.insertelement"(%26, %966, %2) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %968 = "llvm.shufflevector"(%967, %26) <{mask = array<i32: 0, 0, 0, 0>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %969 = "llvm.intr.fshl"(%950, %950, %50) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %970 = "llvm.intr.fshl"(%950, %950, %51) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %971 = "llvm.intr.fshl"(%950, %950, %52) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %972 = "llvm.xor"(%970, %971) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %973 = "llvm.xor"(%972, %969) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %974 = "llvm.and"(%950, %908) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %975 = "llvm.xor"(%950, %53) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %976 = "llvm.and"(%866, %975) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %977 = "llvm.or"(%974, %976) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %978 = "llvm.add"(%824, %964) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %979 = "llvm.add"(%978, %968) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %980 = "llvm.add"(%979, %977) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %981 = "llvm.add"(%980, %973) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %982 = "llvm.intr.fshl"(%951, %951, %55) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %983 = "llvm.intr.fshl"(%951, %951, %56) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %984 = "llvm.intr.fshl"(%951, %951, %57) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %985 = "llvm.xor"(%983, %984) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %986 = "llvm.xor"(%985, %982) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %987 = "llvm.and"(%951, %909) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %988 = "llvm.xor"(%951, %909) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %989 = "llvm.and"(%988, %867) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %990 = "llvm.xor"(%989, %987) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %991 = "llvm.add"(%986, %990) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %992 = "llvm.add"(%981, %825) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %993 = "llvm.add"(%991, %981) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %994 = "llvm.intr.fshl"(%782, %782, %74) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %995 = "llvm.intr.fshl"(%782, %782, %75) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %996 = "llvm.lshr"(%782, %31) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %997 = "llvm.xor"(%995, %996) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %998 = "llvm.xor"(%997, %994) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %999 = "llvm.intr.fshl"(%922, %922, %76) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1000 = "llvm.intr.fshl"(%922, %922, %77) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1001 = "llvm.lshr"(%922, %78) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1002 = "llvm.xor"(%1000, %1001) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1003 = "llvm.xor"(%1002, %999) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1004 = "llvm.add"(%998, %781) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1005 = "llvm.add"(%1004, %769) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1006 = "llvm.add"(%1005, %1003) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1007 = "llvm.getelementptr"(%797) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 40>}> : (!llvm.ptr) -> !llvm.ptr
  %1008 = "llvm.load"(%1007) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %1009 = "llvm.insertelement"(%26, %1008, %2) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %1010 = "llvm.shufflevector"(%1009, %26) <{mask = array<i32: 0, 0, 0, 0>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1011 = "llvm.intr.fshl"(%992, %992, %50) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1012 = "llvm.intr.fshl"(%992, %992, %51) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1013 = "llvm.intr.fshl"(%992, %992, %52) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1014 = "llvm.xor"(%1012, %1013) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1015 = "llvm.xor"(%1014, %1011) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1016 = "llvm.and"(%992, %950) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1017 = "llvm.xor"(%992, %53) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1018 = "llvm.and"(%908, %1017) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1019 = "llvm.or"(%1016, %1018) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1020 = "llvm.add"(%1010, %1006) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1021 = "llvm.add"(%1020, %866) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1022 = "llvm.add"(%1021, %1019) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1023 = "llvm.add"(%1022, %1015) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1024 = "llvm.intr.fshl"(%993, %993, %55) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1025 = "llvm.intr.fshl"(%993, %993, %56) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1026 = "llvm.intr.fshl"(%993, %993, %57) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1027 = "llvm.xor"(%1025, %1026) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1028 = "llvm.xor"(%1027, %1024) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1029 = "llvm.and"(%993, %951) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1030 = "llvm.xor"(%993, %951) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1031 = "llvm.and"(%1030, %909) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1032 = "llvm.xor"(%1031, %1029) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1033 = "llvm.add"(%1028, %1032) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1034 = "llvm.add"(%1023, %867) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1035 = "llvm.add"(%1033, %1023) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1036 = "llvm.intr.fshl"(%783, %783, %74) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1037 = "llvm.intr.fshl"(%783, %783, %75) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1038 = "llvm.lshr"(%783, %31) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1039 = "llvm.xor"(%1037, %1038) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1040 = "llvm.xor"(%1039, %1036) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1041 = "llvm.intr.fshl"(%964, %964, %76) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1042 = "llvm.intr.fshl"(%964, %964, %77) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1043 = "llvm.lshr"(%964, %78) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1044 = "llvm.xor"(%1042, %1043) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1045 = "llvm.xor"(%1044, %1041) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1046 = "llvm.add"(%1040, %782) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1047 = "llvm.add"(%1046, %768) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1048 = "llvm.add"(%1047, %1045) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1049 = "llvm.getelementptr"(%797) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 48>}> : (!llvm.ptr) -> !llvm.ptr
  %1050 = "llvm.load"(%1049) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %1051 = "llvm.insertelement"(%26, %1050, %2) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %1052 = "llvm.shufflevector"(%1051, %26) <{mask = array<i32: 0, 0, 0, 0>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1053 = "llvm.intr.fshl"(%1034, %1034, %50) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1054 = "llvm.intr.fshl"(%1034, %1034, %51) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1055 = "llvm.intr.fshl"(%1034, %1034, %52) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1056 = "llvm.xor"(%1054, %1055) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1057 = "llvm.xor"(%1056, %1053) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1058 = "llvm.and"(%1034, %992) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1059 = "llvm.xor"(%1034, %53) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1060 = "llvm.and"(%950, %1059) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1061 = "llvm.or"(%1058, %1060) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1062 = "llvm.add"(%1052, %1048) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1063 = "llvm.add"(%1062, %908) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1064 = "llvm.add"(%1063, %1061) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1065 = "llvm.add"(%1064, %1057) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1066 = "llvm.intr.fshl"(%1035, %1035, %55) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1067 = "llvm.intr.fshl"(%1035, %1035, %56) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1068 = "llvm.intr.fshl"(%1035, %1035, %57) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1069 = "llvm.xor"(%1067, %1068) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1070 = "llvm.xor"(%1069, %1066) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1071 = "llvm.and"(%1035, %993) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1072 = "llvm.xor"(%1035, %993) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1073 = "llvm.and"(%1072, %951) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1074 = "llvm.xor"(%1073, %1071) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1075 = "llvm.add"(%1070, %1074) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1076 = "llvm.add"(%1065, %909) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1077 = "llvm.add"(%1075, %1065) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1078 = "llvm.intr.fshl"(%779, %779, %74) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1079 = "llvm.intr.fshl"(%779, %779, %75) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1080 = "llvm.lshr"(%779, %31) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1081 = "llvm.xor"(%1079, %1080) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1082 = "llvm.xor"(%1081, %1078) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1083 = "llvm.intr.fshl"(%1006, %1006, %76) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1084 = "llvm.intr.fshl"(%1006, %1006, %77) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1085 = "llvm.lshr"(%1006, %78) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1086 = "llvm.xor"(%1084, %1085) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1087 = "llvm.xor"(%1086, %1083) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1088 = "llvm.add"(%1082, %783) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1089 = "llvm.add"(%1088, %796) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1090 = "llvm.add"(%1089, %1087) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1091 = "llvm.getelementptr"(%797) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 56>}> : (!llvm.ptr) -> !llvm.ptr
  %1092 = "llvm.load"(%1091) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %1093 = "llvm.insertelement"(%26, %1092, %2) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %1094 = "llvm.shufflevector"(%1093, %26) <{mask = array<i32: 0, 0, 0, 0>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1095 = "llvm.intr.fshl"(%1076, %1076, %50) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1096 = "llvm.intr.fshl"(%1076, %1076, %51) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1097 = "llvm.intr.fshl"(%1076, %1076, %52) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1098 = "llvm.xor"(%1096, %1097) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1099 = "llvm.xor"(%1098, %1095) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1100 = "llvm.and"(%1076, %1034) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1101 = "llvm.xor"(%1076, %53) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1102 = "llvm.and"(%992, %1101) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1103 = "llvm.or"(%1100, %1102) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1104 = "llvm.add"(%1094, %1090) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1105 = "llvm.add"(%1104, %950) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1106 = "llvm.add"(%1105, %1103) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1107 = "llvm.add"(%1106, %1099) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1108 = "llvm.intr.fshl"(%1077, %1077, %55) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1109 = "llvm.intr.fshl"(%1077, %1077, %56) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1110 = "llvm.intr.fshl"(%1077, %1077, %57) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1111 = "llvm.xor"(%1109, %1110) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1112 = "llvm.xor"(%1111, %1108) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1113 = "llvm.and"(%1077, %1035) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1114 = "llvm.xor"(%1077, %1035) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1115 = "llvm.and"(%1114, %993) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1116 = "llvm.xor"(%1115, %1113) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1117 = "llvm.add"(%1112, %1116) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1118 = "llvm.add"(%1107, %951) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1119 = "llvm.add"(%1117, %1107) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1120 = "llvm.intr.fshl"(%778, %778, %74) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1121 = "llvm.intr.fshl"(%778, %778, %75) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1122 = "llvm.lshr"(%778, %31) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1123 = "llvm.xor"(%1121, %1122) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1124 = "llvm.xor"(%1123, %1120) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1125 = "llvm.intr.fshl"(%1048, %1048, %76) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1126 = "llvm.intr.fshl"(%1048, %1048, %77) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1127 = "llvm.lshr"(%1048, %78) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1128 = "llvm.xor"(%1126, %1127) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1129 = "llvm.xor"(%1128, %1125) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1130 = "llvm.add"(%1124, %779) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1131 = "llvm.add"(%1130, %838) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1132 = "llvm.add"(%1131, %1129) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1133 = "llvm.getelementptr"(%797) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %1134 = "llvm.load"(%1133) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %1135 = "llvm.insertelement"(%26, %1134, %2) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %1136 = "llvm.shufflevector"(%1135, %26) <{mask = array<i32: 0, 0, 0, 0>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1137 = "llvm.intr.fshl"(%1118, %1118, %50) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1138 = "llvm.intr.fshl"(%1118, %1118, %51) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1139 = "llvm.intr.fshl"(%1118, %1118, %52) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1140 = "llvm.xor"(%1138, %1139) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1141 = "llvm.xor"(%1140, %1137) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1142 = "llvm.and"(%1118, %1076) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1143 = "llvm.xor"(%1118, %53) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1144 = "llvm.and"(%1034, %1143) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1145 = "llvm.or"(%1142, %1144) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1146 = "llvm.add"(%1136, %1132) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1147 = "llvm.add"(%1146, %992) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1148 = "llvm.add"(%1147, %1145) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1149 = "llvm.add"(%1148, %1141) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1150 = "llvm.intr.fshl"(%1119, %1119, %55) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1151 = "llvm.intr.fshl"(%1119, %1119, %56) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1152 = "llvm.intr.fshl"(%1119, %1119, %57) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1153 = "llvm.xor"(%1151, %1152) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1154 = "llvm.xor"(%1153, %1150) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1155 = "llvm.and"(%1119, %1077) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1156 = "llvm.xor"(%1119, %1077) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1157 = "llvm.and"(%1156, %1035) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1158 = "llvm.xor"(%1157, %1155) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1159 = "llvm.add"(%1154, %1158) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1160 = "llvm.add"(%1149, %993) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1161 = "llvm.add"(%1159, %1149) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1162 = "llvm.intr.fshl"(%777, %777, %74) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1163 = "llvm.intr.fshl"(%777, %777, %75) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1164 = "llvm.lshr"(%777, %31) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1165 = "llvm.xor"(%1163, %1164) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1166 = "llvm.xor"(%1165, %1162) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1167 = "llvm.intr.fshl"(%1090, %1090, %76) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1168 = "llvm.intr.fshl"(%1090, %1090, %77) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1169 = "llvm.lshr"(%1090, %78) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1170 = "llvm.xor"(%1168, %1169) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1171 = "llvm.xor"(%1170, %1167) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1172 = "llvm.add"(%1166, %778) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1173 = "llvm.add"(%1172, %880) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1174 = "llvm.add"(%1173, %1171) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1175 = "llvm.getelementptr"(%797) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 72>}> : (!llvm.ptr) -> !llvm.ptr
  %1176 = "llvm.load"(%1175) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %1177 = "llvm.insertelement"(%26, %1176, %2) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %1178 = "llvm.shufflevector"(%1177, %26) <{mask = array<i32: 0, 0, 0, 0>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1179 = "llvm.intr.fshl"(%1160, %1160, %50) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1180 = "llvm.intr.fshl"(%1160, %1160, %51) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1181 = "llvm.intr.fshl"(%1160, %1160, %52) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1182 = "llvm.xor"(%1180, %1181) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1183 = "llvm.xor"(%1182, %1179) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1184 = "llvm.and"(%1160, %1118) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1185 = "llvm.xor"(%1160, %53) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1186 = "llvm.and"(%1076, %1185) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1187 = "llvm.or"(%1184, %1186) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1188 = "llvm.add"(%1178, %1174) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1189 = "llvm.add"(%1188, %1034) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1190 = "llvm.add"(%1189, %1187) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1191 = "llvm.add"(%1190, %1183) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1192 = "llvm.intr.fshl"(%1161, %1161, %55) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1193 = "llvm.intr.fshl"(%1161, %1161, %56) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1194 = "llvm.intr.fshl"(%1161, %1161, %57) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1195 = "llvm.xor"(%1193, %1194) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1196 = "llvm.xor"(%1195, %1192) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1197 = "llvm.and"(%1161, %1119) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1198 = "llvm.xor"(%1161, %1119) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1199 = "llvm.and"(%1198, %1077) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1200 = "llvm.xor"(%1199, %1197) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1201 = "llvm.add"(%1196, %1200) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1202 = "llvm.add"(%1191, %1035) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1203 = "llvm.add"(%1201, %1191) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1204 = "llvm.intr.fshl"(%776, %776, %74) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1205 = "llvm.intr.fshl"(%776, %776, %75) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1206 = "llvm.lshr"(%776, %31) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1207 = "llvm.xor"(%1205, %1206) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1208 = "llvm.xor"(%1207, %1204) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1209 = "llvm.intr.fshl"(%1132, %1132, %76) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1210 = "llvm.intr.fshl"(%1132, %1132, %77) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1211 = "llvm.lshr"(%1132, %78) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1212 = "llvm.xor"(%1210, %1211) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1213 = "llvm.xor"(%1212, %1209) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1214 = "llvm.add"(%1208, %777) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1215 = "llvm.add"(%1214, %922) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1216 = "llvm.add"(%1215, %1213) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1217 = "llvm.getelementptr"(%797) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 80>}> : (!llvm.ptr) -> !llvm.ptr
  %1218 = "llvm.load"(%1217) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %1219 = "llvm.insertelement"(%26, %1218, %2) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %1220 = "llvm.shufflevector"(%1219, %26) <{mask = array<i32: 0, 0, 0, 0>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1221 = "llvm.intr.fshl"(%1202, %1202, %50) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1222 = "llvm.intr.fshl"(%1202, %1202, %51) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1223 = "llvm.intr.fshl"(%1202, %1202, %52) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1224 = "llvm.xor"(%1222, %1223) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1225 = "llvm.xor"(%1224, %1221) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1226 = "llvm.and"(%1202, %1160) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1227 = "llvm.xor"(%1202, %53) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1228 = "llvm.and"(%1118, %1227) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1229 = "llvm.or"(%1226, %1228) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1230 = "llvm.add"(%1220, %1216) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1231 = "llvm.add"(%1230, %1076) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1232 = "llvm.add"(%1231, %1229) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1233 = "llvm.add"(%1232, %1225) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1234 = "llvm.intr.fshl"(%1203, %1203, %55) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1235 = "llvm.intr.fshl"(%1203, %1203, %56) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1236 = "llvm.intr.fshl"(%1203, %1203, %57) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1237 = "llvm.xor"(%1235, %1236) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1238 = "llvm.xor"(%1237, %1234) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1239 = "llvm.and"(%1203, %1161) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1240 = "llvm.xor"(%1203, %1161) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1241 = "llvm.and"(%1240, %1119) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1242 = "llvm.xor"(%1241, %1239) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1243 = "llvm.add"(%1238, %1242) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1244 = "llvm.add"(%1233, %1077) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1245 = "llvm.add"(%1243, %1233) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1246 = "llvm.intr.fshl"(%771, %771, %74) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1247 = "llvm.intr.fshl"(%771, %771, %75) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1248 = "llvm.lshr"(%771, %31) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1249 = "llvm.xor"(%1247, %1248) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1250 = "llvm.xor"(%1249, %1246) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1251 = "llvm.intr.fshl"(%1174, %1174, %76) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1252 = "llvm.intr.fshl"(%1174, %1174, %77) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1253 = "llvm.lshr"(%1174, %78) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1254 = "llvm.xor"(%1252, %1253) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1255 = "llvm.xor"(%1254, %1251) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1256 = "llvm.add"(%1250, %776) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1257 = "llvm.add"(%1256, %964) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1258 = "llvm.add"(%1257, %1255) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1259 = "llvm.getelementptr"(%797) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 88>}> : (!llvm.ptr) -> !llvm.ptr
  %1260 = "llvm.load"(%1259) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %1261 = "llvm.insertelement"(%26, %1260, %2) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %1262 = "llvm.shufflevector"(%1261, %26) <{mask = array<i32: 0, 0, 0, 0>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1263 = "llvm.intr.fshl"(%1244, %1244, %50) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1264 = "llvm.intr.fshl"(%1244, %1244, %51) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1265 = "llvm.intr.fshl"(%1244, %1244, %52) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1266 = "llvm.xor"(%1264, %1265) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1267 = "llvm.xor"(%1266, %1263) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1268 = "llvm.and"(%1244, %1202) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1269 = "llvm.xor"(%1244, %53) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1270 = "llvm.and"(%1160, %1269) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1271 = "llvm.or"(%1268, %1270) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1272 = "llvm.add"(%1262, %1258) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1273 = "llvm.add"(%1272, %1118) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1274 = "llvm.add"(%1273, %1271) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1275 = "llvm.add"(%1274, %1267) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1276 = "llvm.intr.fshl"(%1245, %1245, %55) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1277 = "llvm.intr.fshl"(%1245, %1245, %56) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1278 = "llvm.intr.fshl"(%1245, %1245, %57) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1279 = "llvm.xor"(%1277, %1278) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1280 = "llvm.xor"(%1279, %1276) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1281 = "llvm.and"(%1245, %1203) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1282 = "llvm.xor"(%1245, %1203) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1283 = "llvm.and"(%1282, %1161) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1284 = "llvm.xor"(%1283, %1281) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1285 = "llvm.add"(%1280, %1284) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1286 = "llvm.add"(%1275, %1119) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1287 = "llvm.add"(%1285, %1275) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1288 = "llvm.intr.fshl"(%770, %770, %74) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1289 = "llvm.intr.fshl"(%770, %770, %75) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1290 = "llvm.lshr"(%770, %31) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1291 = "llvm.xor"(%1289, %1290) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1292 = "llvm.xor"(%1291, %1288) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1293 = "llvm.intr.fshl"(%1216, %1216, %76) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1294 = "llvm.intr.fshl"(%1216, %1216, %77) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1295 = "llvm.lshr"(%1216, %78) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1296 = "llvm.xor"(%1294, %1295) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1297 = "llvm.xor"(%1296, %1293) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1298 = "llvm.add"(%1292, %771) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1299 = "llvm.add"(%1298, %1006) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1300 = "llvm.add"(%1299, %1297) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1301 = "llvm.getelementptr"(%797) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 96>}> : (!llvm.ptr) -> !llvm.ptr
  %1302 = "llvm.load"(%1301) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %1303 = "llvm.insertelement"(%26, %1302, %2) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %1304 = "llvm.shufflevector"(%1303, %26) <{mask = array<i32: 0, 0, 0, 0>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1305 = "llvm.intr.fshl"(%1286, %1286, %50) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1306 = "llvm.intr.fshl"(%1286, %1286, %51) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1307 = "llvm.intr.fshl"(%1286, %1286, %52) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1308 = "llvm.xor"(%1306, %1307) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1309 = "llvm.xor"(%1308, %1305) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1310 = "llvm.and"(%1286, %1244) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1311 = "llvm.xor"(%1286, %53) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1312 = "llvm.and"(%1202, %1311) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1313 = "llvm.or"(%1310, %1312) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1314 = "llvm.add"(%1304, %1300) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1315 = "llvm.add"(%1314, %1160) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1316 = "llvm.add"(%1315, %1313) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1317 = "llvm.add"(%1316, %1309) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1318 = "llvm.intr.fshl"(%1287, %1287, %55) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1319 = "llvm.intr.fshl"(%1287, %1287, %56) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1320 = "llvm.intr.fshl"(%1287, %1287, %57) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1321 = "llvm.xor"(%1319, %1320) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1322 = "llvm.xor"(%1321, %1318) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1323 = "llvm.and"(%1287, %1245) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1324 = "llvm.xor"(%1287, %1245) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1325 = "llvm.and"(%1324, %1203) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1326 = "llvm.xor"(%1325, %1323) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1327 = "llvm.add"(%1322, %1326) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1328 = "llvm.add"(%1317, %1161) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1329 = "llvm.add"(%1327, %1317) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1330 = "llvm.intr.fshl"(%769, %769, %74) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1331 = "llvm.intr.fshl"(%769, %769, %75) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1332 = "llvm.lshr"(%769, %31) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1333 = "llvm.xor"(%1331, %1332) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1334 = "llvm.xor"(%1333, %1330) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1335 = "llvm.intr.fshl"(%1258, %1258, %76) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1336 = "llvm.intr.fshl"(%1258, %1258, %77) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1337 = "llvm.lshr"(%1258, %78) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1338 = "llvm.xor"(%1336, %1337) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1339 = "llvm.xor"(%1338, %1335) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1340 = "llvm.add"(%1334, %770) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1341 = "llvm.add"(%1340, %1048) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1342 = "llvm.add"(%1341, %1339) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1343 = "llvm.getelementptr"(%797) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 104>}> : (!llvm.ptr) -> !llvm.ptr
  %1344 = "llvm.load"(%1343) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %1345 = "llvm.insertelement"(%26, %1344, %2) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %1346 = "llvm.shufflevector"(%1345, %26) <{mask = array<i32: 0, 0, 0, 0>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1347 = "llvm.intr.fshl"(%1328, %1328, %50) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1348 = "llvm.intr.fshl"(%1328, %1328, %51) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1349 = "llvm.intr.fshl"(%1328, %1328, %52) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1350 = "llvm.xor"(%1348, %1349) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1351 = "llvm.xor"(%1350, %1347) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1352 = "llvm.and"(%1328, %1286) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1353 = "llvm.xor"(%1328, %53) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1354 = "llvm.and"(%1244, %1353) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1355 = "llvm.or"(%1352, %1354) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1356 = "llvm.add"(%1346, %1342) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1357 = "llvm.add"(%1356, %1202) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1358 = "llvm.add"(%1357, %1355) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1359 = "llvm.add"(%1358, %1351) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1360 = "llvm.intr.fshl"(%1329, %1329, %55) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1361 = "llvm.intr.fshl"(%1329, %1329, %56) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1362 = "llvm.intr.fshl"(%1329, %1329, %57) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1363 = "llvm.xor"(%1361, %1362) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1364 = "llvm.xor"(%1363, %1360) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1365 = "llvm.and"(%1329, %1287) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1366 = "llvm.xor"(%1329, %1287) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1367 = "llvm.and"(%1366, %1245) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1368 = "llvm.xor"(%1367, %1365) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1369 = "llvm.add"(%1364, %1368) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1370 = "llvm.add"(%1359, %1203) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1371 = "llvm.add"(%1369, %1359) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1372 = "llvm.intr.fshl"(%768, %768, %74) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1373 = "llvm.intr.fshl"(%768, %768, %75) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1374 = "llvm.lshr"(%768, %31) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1375 = "llvm.xor"(%1373, %1374) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1376 = "llvm.xor"(%1375, %1372) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1377 = "llvm.intr.fshl"(%1300, %1300, %76) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1378 = "llvm.intr.fshl"(%1300, %1300, %77) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1379 = "llvm.lshr"(%1300, %78) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1380 = "llvm.xor"(%1378, %1379) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1381 = "llvm.xor"(%1380, %1377) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1382 = "llvm.add"(%1376, %769) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1383 = "llvm.add"(%1382, %1090) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1384 = "llvm.add"(%1383, %1381) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1385 = "llvm.getelementptr"(%797) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 112>}> : (!llvm.ptr) -> !llvm.ptr
  %1386 = "llvm.load"(%1385) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %1387 = "llvm.insertelement"(%26, %1386, %2) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %1388 = "llvm.shufflevector"(%1387, %26) <{mask = array<i32: 0, 0, 0, 0>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1389 = "llvm.intr.fshl"(%1370, %1370, %50) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1390 = "llvm.intr.fshl"(%1370, %1370, %51) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1391 = "llvm.intr.fshl"(%1370, %1370, %52) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1392 = "llvm.xor"(%1390, %1391) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1393 = "llvm.xor"(%1392, %1389) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1394 = "llvm.and"(%1370, %1328) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1395 = "llvm.xor"(%1370, %53) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1396 = "llvm.and"(%1286, %1395) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1397 = "llvm.or"(%1394, %1396) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1398 = "llvm.add"(%1388, %1384) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1399 = "llvm.add"(%1398, %1244) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1400 = "llvm.add"(%1399, %1397) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1401 = "llvm.add"(%1400, %1393) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1402 = "llvm.intr.fshl"(%1371, %1371, %55) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1403 = "llvm.intr.fshl"(%1371, %1371, %56) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1404 = "llvm.intr.fshl"(%1371, %1371, %57) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1405 = "llvm.xor"(%1403, %1404) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1406 = "llvm.xor"(%1405, %1402) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1407 = "llvm.and"(%1371, %1329) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1408 = "llvm.xor"(%1371, %1329) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1409 = "llvm.and"(%1408, %1287) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1410 = "llvm.xor"(%1409, %1407) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1411 = "llvm.add"(%1406, %1410) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1412 = "llvm.add"(%1401, %1245) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1413 = "llvm.add"(%1411, %1401) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1414 = "llvm.intr.fshl"(%796, %796, %74) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1415 = "llvm.intr.fshl"(%796, %796, %75) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1416 = "llvm.lshr"(%796, %31) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1417 = "llvm.xor"(%1415, %1416) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1418 = "llvm.xor"(%1417, %1414) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1419 = "llvm.intr.fshl"(%1342, %1342, %76) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1420 = "llvm.intr.fshl"(%1342, %1342, %77) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1421 = "llvm.lshr"(%1342, %78) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1422 = "llvm.xor"(%1420, %1421) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1423 = "llvm.xor"(%1422, %1419) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1424 = "llvm.add"(%1418, %768) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1425 = "llvm.add"(%1424, %1132) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1426 = "llvm.add"(%1425, %1423) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1427 = "llvm.getelementptr"(%797) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 120>}> : (!llvm.ptr) -> !llvm.ptr
  %1428 = "llvm.load"(%1427) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %1429 = "llvm.insertelement"(%26, %1428, %2) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %1430 = "llvm.shufflevector"(%1429, %26) <{mask = array<i32: 0, 0, 0, 0>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1431 = "llvm.intr.fshl"(%1412, %1412, %50) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1432 = "llvm.intr.fshl"(%1412, %1412, %51) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1433 = "llvm.intr.fshl"(%1412, %1412, %52) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1434 = "llvm.xor"(%1432, %1433) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1435 = "llvm.xor"(%1434, %1431) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1436 = "llvm.and"(%1412, %1370) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1437 = "llvm.xor"(%1412, %53) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1438 = "llvm.and"(%1328, %1437) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1439 = "llvm.or"(%1436, %1438) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1440 = "llvm.add"(%1430, %1426) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1441 = "llvm.add"(%1440, %1286) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1442 = "llvm.add"(%1441, %1439) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1443 = "llvm.add"(%1442, %1435) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1444 = "llvm.intr.fshl"(%1413, %1413, %55) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1445 = "llvm.intr.fshl"(%1413, %1413, %56) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1446 = "llvm.intr.fshl"(%1413, %1413, %57) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1447 = "llvm.xor"(%1445, %1446) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1448 = "llvm.xor"(%1447, %1444) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1449 = "llvm.and"(%1413, %1371) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1450 = "llvm.xor"(%1413, %1371) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1451 = "llvm.and"(%1450, %1329) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1452 = "llvm.xor"(%1451, %1449) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1453 = "llvm.add"(%1448, %1452) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1454 = "llvm.add"(%1443, %1287) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1455 = "llvm.add"(%1453, %1443) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1456 = "llvm.add"(%759, %73) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1457 = "llvm.icmp"(%759, %8) <{predicate = 6 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1457, %1456, %1328, %1370, %1412, %1454, %1329, %1371, %1413, %1455, %1426, %1384, %1342, %1300, %796, %838, %880, %922, %1258, %1216, %1174, %1132, %964, %1006, %1048, %1090)[^bb18, ^bb19] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true>, mustProgress = true>, operandSegmentSizes = array<i32: 1, 25, 0>}> : (i1, i64, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
^bb19:  // pred: ^bb18
  %1458 = "llvm.select"(%213, %1455, %6) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<4xi1>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1459 = "llvm.add"(%1458, %214) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1460 = "llvm.select"(%213, %1413, %6) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<4xi1>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1461 = "llvm.add"(%1460, %215) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1462 = "llvm.select"(%213, %1371, %6) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<4xi1>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1463 = "llvm.add"(%1462, %216) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1464 = "llvm.select"(%213, %1329, %6) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<4xi1>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1465 = "llvm.add"(%1464, %217) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1466 = "llvm.select"(%213, %1454, %6) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<4xi1>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1467 = "llvm.add"(%1466, %218) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1468 = "llvm.select"(%213, %1412, %6) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<4xi1>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1469 = "llvm.add"(%1468, %219) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1470 = "llvm.select"(%213, %1370, %6) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<4xi1>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1471 = "llvm.add"(%1470, %220) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1472 = "llvm.select"(%213, %1328, %6) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<4xi1>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1473 = "llvm.add"(%1472, %221) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1474 = "llvm.add"(%225, %80) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1475 = "llvm.add"(%212, %223) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1476 = "llvm.icmp"(%1475, %6) <{predicate = 1 : i64}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi1>
  %1477 = "llvm.sext"(%1476) : (vector<4xi1>) -> vector<4xi64>
  %1478 = "llvm.bitcast"(%1477) : (vector<4xi64>) -> vector<8xi32>
  %1479 = "llvm.icmp"(%1478, %30) <{predicate = 2 : i64}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi1>
  %1480 = "llvm.bitcast"(%1479) : (vector<8xi1>) -> i8
  %1481 = "llvm.icmp"(%1480, %32) <{predicate = 0 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%1481, %1477, %1476, %1459, %1461, %1463, %1465, %1467, %1469, %1471, %1473, %1474, %1475)[^bb20, ^bb17] <{branch_weights = array<i32: 127, 255873>, operandSegmentSizes = array<i32: 1, 0, 12>}> : (i1, vector<4xi64>, vector<4xi1>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
^bb20:  // pred: ^bb19
  %1482 = "llvm.bitcast"(%1459) : (vector<4xi64>) -> vector<8xi32>
  %1483 = "llvm.bitcast"(%1463) : (vector<4xi64>) -> vector<8xi32>
  %1484 = "llvm.bitcast"(%1461) : (vector<4xi64>) -> vector<8xi32>
  %1485 = "llvm.bitcast"(%1465) : (vector<4xi64>) -> vector<8xi32>
  %1486 = "llvm.bitcast"(%1467) : (vector<4xi64>) -> vector<8xi32>
  %1487 = "llvm.bitcast"(%1471) : (vector<4xi64>) -> vector<8xi32>
  %1488 = "llvm.bitcast"(%1469) : (vector<4xi64>) -> vector<8xi32>
  %1489 = "llvm.bitcast"(%1473) : (vector<4xi64>) -> vector<8xi32>
  "llvm.br"(%1489, %1487, %1488, %1486, %1485, %1483, %1484, %1482)[^bb21] : (vector<8xi32>, vector<8xi32>, vector<8xi32>, vector<8xi32>, vector<8xi32>, vector<8xi32>, vector<8xi32>, vector<8xi32>) -> ()
^bb21(%1490: vector<8xi32>, %1491: vector<8xi32>, %1492: vector<8xi32>, %1493: vector<8xi32>, %1494: vector<8xi32>, %1495: vector<8xi32>, %1496: vector<8xi32>, %1497: vector<8xi32>):  // 2 preds: ^bb4, ^bb20
  %1498 = "llvm.shufflevector"(%1497, %1495) <{mask = array<i32: 0, 1, 2, 3, 8, 9, 10, 11>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1499 = "llvm.shufflevector"(%1497, %1495) <{mask = array<i32: 4, 5, 6, 7, 12, 13, 14, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1500 = "llvm.shufflevector"(%1496, %1494) <{mask = array<i32: 0, 1, 2, 3, 8, 9, 10, 11>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1501 = "llvm.shufflevector"(%1496, %1494) <{mask = array<i32: 4, 5, 6, 7, 12, 13, 14, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1502 = "llvm.shufflevector"(%1498, %1500) <{mask = array<i32: 0, 1, 8, 9, 4, 5, 12, 13>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1503 = "llvm.bitcast"(%1502) : (vector<8xi32>) -> vector<4xi64>
  %1504 = "llvm.shufflevector"(%1498, %1500) <{mask = array<i32: 2, 3, 10, 11, 6, 7, 14, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1505 = "llvm.bitcast"(%1504) : (vector<8xi32>) -> vector<4xi64>
  %1506 = "llvm.shufflevector"(%1499, %1501) <{mask = array<i32: 0, 1, 8, 9, 4, 5, 12, 13>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1507 = "llvm.bitcast"(%1506) : (vector<8xi32>) -> vector<4xi64>
  %1508 = "llvm.shufflevector"(%1493, %1491) <{mask = array<i32: 0, 1, 2, 3, 8, 9, 10, 11>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1509 = "llvm.shufflevector"(%1493, %1491) <{mask = array<i32: 4, 5, 6, 7, 12, 13, 14, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1510 = "llvm.shufflevector"(%1492, %1490) <{mask = array<i32: 0, 1, 2, 3, 8, 9, 10, 11>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1511 = "llvm.shufflevector"(%1492, %1490) <{mask = array<i32: 4, 5, 6, 7, 12, 13, 14, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1512 = "llvm.shufflevector"(%1508, %1510) <{mask = array<i32: 0, 1, 8, 9, 4, 5, 12, 13>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1513 = "llvm.bitcast"(%1512) : (vector<8xi32>) -> vector<4xi64>
  %1514 = "llvm.shufflevector"(%1508, %1510) <{mask = array<i32: 2, 3, 10, 11, 6, 7, 14, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1515 = "llvm.bitcast"(%1514) : (vector<8xi32>) -> vector<4xi64>
  %1516 = "llvm.shufflevector"(%1509, %1511) <{mask = array<i32: 0, 1, 8, 9, 4, 5, 12, 13>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1517 = "llvm.bitcast"(%1516) : (vector<8xi32>) -> vector<4xi64>
  "llvm.switch"(%arg0)[^bb25, ^bb22, ^bb23, ^bb24] <{case_operand_segments = array<i32: 0, 0, 0>, case_values = dense<[4, 3, 2]> : vector<3xi64>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i64) -> ()
^bb22:  // pred: ^bb21
  %1518 = "llvm.shufflevector"(%1509, %1511) <{mask = array<i32: 2, 3, 10, 11, 6, 7, 14, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1519 = "llvm.bitcast"(%1518) : (vector<8xi32>) -> vector<4xi64>
  %1520 = "llvm.shufflevector"(%1499, %1501) <{mask = array<i32: 2, 3, 10, 11, 6, 7, 14, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1521 = "llvm.bitcast"(%1520) : (vector<8xi32>) -> vector<4xi64>
  %1522 = "llvm.getelementptr"(%arg3) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %1523 = "llvm.load"(%1522) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> !llvm.ptr
  %1524 = "llvm.intr.fshl"(%1521, %1521, %49) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1525 = "llvm.bitcast"(%1524) : (vector<4xi64>) -> vector<32xi8>
  %1526 = "llvm.shufflevector"(%1525, %81) <{mask = array<i32: 3, 2, 1, 0, 7, 6, 5, 4, 11, 10, 9, 8, 15, 14, 13, 12, 19, 18, 17, 16, 23, 22, 21, 20, 27, 26, 25, 24, 31, 30, 29, 28>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %1527 = "llvm.bitcast"(%1526) : (vector<32xi8>) -> vector<4xi64>
  "llvm.call"(%1523, %1527) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @wv_stu.17, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, vector<4xi64>) -> ()
  %1528 = "llvm.load"(%1522) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> !llvm.ptr
  %1529 = "llvm.getelementptr"(%1528) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %1530 = "llvm.intr.fshl"(%1519, %1519, %49) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1531 = "llvm.bitcast"(%1530) : (vector<4xi64>) -> vector<32xi8>
  %1532 = "llvm.shufflevector"(%1531, %81) <{mask = array<i32: 3, 2, 1, 0, 7, 6, 5, 4, 11, 10, 9, 8, 15, 14, 13, 12, 19, 18, 17, 16, 23, 22, 21, 20, 27, 26, 25, 24, 31, 30, 29, 28>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %1533 = "llvm.bitcast"(%1532) : (vector<32xi8>) -> vector<4xi64>
  "llvm.call"(%1529, %1533) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @wv_stu.17, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, vector<4xi64>) -> ()
  "llvm.br"()[^bb23] : () -> ()
^bb23:  // 2 preds: ^bb21, ^bb22
  %1534 = "llvm.getelementptr"(%arg3) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %1535 = "llvm.load"(%1534) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> !llvm.ptr
  %1536 = "llvm.intr.fshl"(%1507, %1507, %49) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1537 = "llvm.bitcast"(%1536) : (vector<4xi64>) -> vector<32xi8>
  %1538 = "llvm.shufflevector"(%1537, %81) <{mask = array<i32: 3, 2, 1, 0, 7, 6, 5, 4, 11, 10, 9, 8, 15, 14, 13, 12, 19, 18, 17, 16, 23, 22, 21, 20, 27, 26, 25, 24, 31, 30, 29, 28>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %1539 = "llvm.bitcast"(%1538) : (vector<32xi8>) -> vector<4xi64>
  "llvm.call"(%1535, %1539) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @wv_stu.17, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, vector<4xi64>) -> ()
  %1540 = "llvm.load"(%1534) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> !llvm.ptr
  %1541 = "llvm.getelementptr"(%1540) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %1542 = "llvm.intr.fshl"(%1517, %1517, %49) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1543 = "llvm.bitcast"(%1542) : (vector<4xi64>) -> vector<32xi8>
  %1544 = "llvm.shufflevector"(%1543, %81) <{mask = array<i32: 3, 2, 1, 0, 7, 6, 5, 4, 11, 10, 9, 8, 15, 14, 13, 12, 19, 18, 17, 16, 23, 22, 21, 20, 27, 26, 25, 24, 31, 30, 29, 28>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %1545 = "llvm.bitcast"(%1544) : (vector<32xi8>) -> vector<4xi64>
  "llvm.call"(%1541, %1545) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @wv_stu.17, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, vector<4xi64>) -> ()
  "llvm.br"()[^bb24] : () -> ()
^bb24:  // 2 preds: ^bb21, ^bb23
  %1546 = "llvm.getelementptr"(%arg3) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %1547 = "llvm.load"(%1546) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> !llvm.ptr
  %1548 = "llvm.intr.fshl"(%1505, %1505, %49) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1549 = "llvm.bitcast"(%1548) : (vector<4xi64>) -> vector<32xi8>
  %1550 = "llvm.shufflevector"(%1549, %81) <{mask = array<i32: 3, 2, 1, 0, 7, 6, 5, 4, 11, 10, 9, 8, 15, 14, 13, 12, 19, 18, 17, 16, 23, 22, 21, 20, 27, 26, 25, 24, 31, 30, 29, 28>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %1551 = "llvm.bitcast"(%1550) : (vector<32xi8>) -> vector<4xi64>
  "llvm.call"(%1547, %1551) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @wv_stu.17, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, vector<4xi64>) -> ()
  %1552 = "llvm.load"(%1546) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> !llvm.ptr
  %1553 = "llvm.getelementptr"(%1552) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %1554 = "llvm.intr.fshl"(%1515, %1515, %49) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1555 = "llvm.bitcast"(%1554) : (vector<4xi64>) -> vector<32xi8>
  %1556 = "llvm.shufflevector"(%1555, %81) <{mask = array<i32: 3, 2, 1, 0, 7, 6, 5, 4, 11, 10, 9, 8, 15, 14, 13, 12, 19, 18, 17, 16, 23, 22, 21, 20, 27, 26, 25, 24, 31, 30, 29, 28>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %1557 = "llvm.bitcast"(%1556) : (vector<32xi8>) -> vector<4xi64>
  "llvm.call"(%1553, %1557) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @wv_stu.17, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, vector<4xi64>) -> ()
  %1558 = "llvm.load"(%arg3) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> !llvm.ptr
  %1559 = "llvm.intr.fshl"(%1503, %1503, %49) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1560 = "llvm.bitcast"(%1559) : (vector<4xi64>) -> vector<32xi8>
  %1561 = "llvm.shufflevector"(%1560, %81) <{mask = array<i32: 3, 2, 1, 0, 7, 6, 5, 4, 11, 10, 9, 8, 15, 14, 13, 12, 19, 18, 17, 16, 23, 22, 21, 20, 27, 26, 25, 24, 31, 30, 29, 28>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %1562 = "llvm.bitcast"(%1561) : (vector<32xi8>) -> vector<4xi64>
  "llvm.call"(%1558, %1562) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @wv_stu.17, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, vector<4xi64>) -> ()
  %1563 = "llvm.load"(%arg3) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> !llvm.ptr
  %1564 = "llvm.getelementptr"(%1563) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %1565 = "llvm.intr.fshl"(%1513, %1513, %49) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1566 = "llvm.bitcast"(%1565) : (vector<4xi64>) -> vector<32xi8>
  %1567 = "llvm.shufflevector"(%1566, %81) <{mask = array<i32: 3, 2, 1, 0, 7, 6, 5, 4, 11, 10, 9, 8, 15, 14, 13, 12, 19, 18, 17, 16, 23, 22, 21, 20, 27, 26, 25, 24, 31, 30, 29, 28>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %1568 = "llvm.bitcast"(%1567) : (vector<32xi8>) -> vector<4xi64>
  "llvm.call"(%1564, %1568) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @wv_stu.17, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, vector<4xi64>) -> ()
  "llvm.br"()[^bb25] : () -> ()
^bb25:  // 2 preds: ^bb21, ^bb24
  "llvm.intr.lifetime.end"(%84) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%83) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%82) : (!llvm.ptr) -> ()
  "llvm.br"()[^bb26] : () -> ()
^bb26:  // 3 preds: ^bb1, ^bb2, ^bb25
  "llvm.return"() : () -> ()
}) : () -> ()

    with
      @fd_sha512_private_batch_avx.K := Firedancer.LaneNI.Mlir.fd_sha512_private_batch_avx_K,
      @fd_sha512_hash := Firedancer.LaneNI.Mlir.fd_sha512_hash,
      @fd_ulong_align_dn.14 := Firedancer.LaneNI.Mlir.fd_ulong_align_dn_14,
      @fd_ulong_align_up.15 := Firedancer.LaneNI.Mlir.fd_ulong_align_up_15,
      @wv_st := Firedancer.LaneNI.Mlir.wv_st,
      @wv_st := Firedancer.LaneNI.Mlir.wv_st,
      @wv_st := Firedancer.LaneNI.Mlir.wv_st,
      @wv_st := Firedancer.LaneNI.Mlir.wv_st,
      @wv_st := Firedancer.LaneNI.Mlir.wv_st,
      @wv_st := Firedancer.LaneNI.Mlir.wv_st,
      @wv_st := Firedancer.LaneNI.Mlir.wv_st,
      @wv_st := Firedancer.LaneNI.Mlir.wv_st,
      @wv_st := Firedancer.LaneNI.Mlir.wv_st,
      @fd_ulong_bswap.16 := Firedancer.LaneNI.Mlir.fd_ulong_bswap_16,
      @fd_ulong_bswap.16 := Firedancer.LaneNI.Mlir.fd_ulong_bswap_16,
      @wv_stu.17 := Firedancer.LaneNI.Mlir.wv_stu_17,
      @wv_stu.17 := Firedancer.LaneNI.Mlir.wv_stu_17,
      @wv_stu.17 := Firedancer.LaneNI.Mlir.wv_stu_17,
      @wv_stu.17 := Firedancer.LaneNI.Mlir.wv_stu_17,
      @wv_stu.17 := Firedancer.LaneNI.Mlir.wv_stu_17,
      @wv_stu.17 := Firedancer.LaneNI.Mlir.wv_stu_17,
      @wv_stu.17 := Firedancer.LaneNI.Mlir.wv_stu_17,
      @wv_stu.17 := Firedancer.LaneNI.Mlir.wv_stu_17

end

end Firedancer.LaneNI.Mlir
