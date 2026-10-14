
module

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

public import Firedancer.Lane.Mlir.fd_sha512_private_batch_avx_K
public import Firedancer.Lane.Mlir.fd_sha512_hash

namespace Firedancer.Lane.Mlir

@[expose] public section

mlir_def fd_sha512_private_batch_avx := "llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.noundef}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}], frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<void (i64, ptr, ptr, ptr)>, linkage = #llvm.linkage<external>, no_unwind, passthrough = ["sspstrong", ["min-legal-vector-width", "256"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "znver4"]], sym_name = "fd_sha512_private_batch_avx", target_cpu = "znver4", target_features = #llvm.target_features<["+64bit", "+adx", "+aes", "+avx", "+avx2", "+avx512bf16", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+clzero", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fast-vector-fsqrt", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+mwaitx", "+pclmul", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdpru", "+rdrnd", "+rdseed", "+sahf", "+sha", "+shstk", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+sse4a", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tile", "-avx10.1", "-avx10.2", "-avx512bmm", "-avx512fp16", "-avx512vp2intersect", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-ccmp", "-cf", "-cldemote", "-cmpccxadd", "-egpr", "-enqcmd", "-fma4", "-hreset", "-jmpabs", "-kl", "-lwp", "-movdir64b", "-movdiri", "-movrs", "-ndd", "-nf", "-pconfig", "-ppx", "-prefetchi", "-ptwrite", "-push2pop2", "-raoint", "-rtm", "-serialize", "-sgx", "-sha512", "-sm3", "-sm4", "-tbm", "-tsxldtrk", "-uintr", "-usermsr", "-waitpkg", "-widekl", "-xop", "-zu"]>, tune_cpu = "znver4", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg0: i64, %arg1: !llvm.ptr, %arg2: !llvm.ptr, %arg3: !llvm.ptr):
  %0 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %1 = "llvm.mlir.constant"() <{value = 2 : i64}> : () -> i64
  %2 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %3 = "llvm.mlir.constant"() <{value = 127 : i64}> : () -> i64
  %4 = "llvm.mlir.constant"() <{value = -128 : i64}> : () -> i64
  %5 = "llvm.mlir.constant"() <{value = 144 : i64}> : () -> i64
  %6 = "llvm.mlir.constant"() <{value = 384 : i64}> : () -> i64
  %7 = "llvm.mlir.constant"() <{value = 7 : i64}> : () -> i64
  %8 = "llvm.mlir.constant"() <{value = dense<0> : vector<4xi64>}> : () -> vector<4xi64>
  %9 = "llvm.mlir.constant"() <{value = 32 : i64}> : () -> i64
  %10 = "llvm.mlir.constant"() <{value = 64 : i64}> : () -> i64
  %11 = "llvm.mlir.constant"() <{value = 96 : i64}> : () -> i64
  %12 = "llvm.mlir.constant"() <{value = 128 : i64}> : () -> i64
  %13 = "llvm.mlir.constant"() <{value = 160 : i64}> : () -> i64
  %14 = "llvm.mlir.constant"() <{value = 192 : i64}> : () -> i64
  %15 = "llvm.mlir.constant"() <{value = 224 : i64}> : () -> i64
  %16 = "llvm.mlir.constant"() <{value = 31 : i64}> : () -> i64
  %17 = "llvm.mlir.constant"() <{value = -32 : i64}> : () -> i64
  %18 = "llvm.mlir.constant"() <{value = 5 : i64}> : () -> i64
  %19 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %20 = "llvm.mlir.poison"() : () -> i64
  %21 = "llvm.mlir.constant"() <{value = 256 : i64}> : () -> i64
  %22 = "llvm.mlir.constant"() <{value = -256 : i64}> : () -> i64
  %23 = "llvm.mlir.constant"() <{value = -8 : i64}> : () -> i64
  %24 = "llvm.mlir.constant"() <{value = 3 : i64}> : () -> i64
  %25 = "llvm.mlir.constant"() <{value = 8 : i64}> : () -> i64
  %26 = "llvm.mlir.constant"() <{value = 56 : i64}> : () -> i64
  %27 = "llvm.mlir.constant"() <{value = 16 : i64}> : () -> i64
  %28 = "llvm.mlir.constant"() <{value = 24 : i64}> : () -> i64
  %29 = "llvm.mlir.constant"() <{value = 40 : i64}> : () -> i64
  %30 = "llvm.mlir.constant"() <{value = 48 : i64}> : () -> i64
  %31 = "llvm.mlir.constant"() <{value = -64 : i64}> : () -> i64
  %32 = "llvm.mlir.constant"() <{value = 4 : i64}> : () -> i64
  %33 = "llvm.mlir.constant"() <{value = -4 : i64}> : () -> i64
  %34 = "llvm.mlir.constant"() <{value = -2 : i64}> : () -> i64
  %35 = "llvm.mlir.constant"() <{value = -128 : i8}> : () -> i8
  %36 = "llvm.mlir.constant"() <{value = 504403158265495552 : i64}> : () -> i64
  %37 = "llvm.mlir.constant"() <{value = -16 : i64}> : () -> i64
  %38 = "llvm.mlir.poison"() : () -> vector<4xi64>
  %39 = "llvm.mlir.constant"() <{value = -1 : i32}> : () -> i32
  %40 = "llvm.mlir.poison"() : () -> vector<8xi32>
  %41 = "llvm.mlir.constant"() <{value = dense<[1, 2, 4, 8, 16, 32, 64, 128]> : vector<8xi32>}> : () -> vector<8xi32>
  %42 = "llvm.mlir.constant"() <{value = dense<0> : vector<8xi32>}> : () -> vector<8xi32>
  %43 = "llvm.mlir.constant"() <{value = dense<7> : vector<4xi64>}> : () -> vector<4xi64>
  %44 = "llvm.mlir.constant"() <{value = 0 : i8}> : () -> i8
  %45 = "llvm.mlir.constant"() <{value = dense<[327033209, 1541459225, 327033209, 1541459225, 327033209, 1541459225, 327033209, 1541459225]> : vector<8xi32>}> : () -> vector<8xi32>
  %46 = "llvm.mlir.constant"() <{value = dense<[-79577749, 528734635, -79577749, 528734635, -79577749, 528734635, -79577749, 528734635]> : vector<8xi32>}> : () -> vector<8xi32>
  %47 = "llvm.mlir.constant"() <{value = dense<[725511199, -1694144372, 725511199, -1694144372, 725511199, -1694144372, 725511199, -1694144372]> : vector<8xi32>}> : () -> vector<8xi32>
  %48 = "llvm.mlir.constant"() <{value = dense<[-1377402159, 1359893119, -1377402159, 1359893119, -1377402159, 1359893119, -1377402159, 1359893119]> : vector<8xi32>}> : () -> vector<8xi32>
  %49 = "llvm.mlir.constant"() <{value = dense<[1595750129, -1521486534, 1595750129, -1521486534, 1595750129, -1521486534, 1595750129, -1521486534]> : vector<8xi32>}> : () -> vector<8xi32>
  %50 = "llvm.mlir.constant"() <{value = dense<[-23791573, 1013904242, -23791573, 1013904242, -23791573, 1013904242, -23791573, 1013904242]> : vector<8xi32>}> : () -> vector<8xi32>
  %51 = "llvm.mlir.constant"() <{value = dense<[-2067093701, -1150833019, -2067093701, -1150833019, -2067093701, -1150833019, -2067093701, -1150833019]> : vector<8xi32>}> : () -> vector<8xi32>
  %52 = "llvm.mlir.constant"() <{value = dense<[-205731576, 1779033703, -205731576, 1779033703, -205731576, 1779033703, -205731576, 1779033703]> : vector<8xi32>}> : () -> vector<8xi32>
  %53 = "llvm.mlir.constant"() <{value = dense<7640891576956012808> : vector<4xi64>}> : () -> vector<4xi64>
  %54 = "llvm.mlir.constant"() <{value = dense<-4942790177534073029> : vector<4xi64>}> : () -> vector<4xi64>
  %55 = "llvm.mlir.constant"() <{value = dense<4354685564936845355> : vector<4xi64>}> : () -> vector<4xi64>
  %56 = "llvm.mlir.constant"() <{value = dense<-6534734903238641935> : vector<4xi64>}> : () -> vector<4xi64>
  %57 = "llvm.mlir.constant"() <{value = dense<5840696475078001361> : vector<4xi64>}> : () -> vector<4xi64>
  %58 = "llvm.mlir.constant"() <{value = dense<-7276294671716946913> : vector<4xi64>}> : () -> vector<4xi64>
  %59 = "llvm.mlir.constant"() <{value = dense<2270897969802886507> : vector<4xi64>}> : () -> vector<4xi64>
  %60 = "llvm.mlir.constant"() <{value = dense<6620516959819538809> : vector<4xi64>}> : () -> vector<4xi64>
  %61 = "llvm.mlir.constant"() <{value = dense<32> : vector<4xi64>}> : () -> vector<4xi64>
  %62 = "llvm.mlir.constant"() <{value = dense<50> : vector<4xi64>}> : () -> vector<4xi64>
  %63 = "llvm.mlir.constant"() <{value = dense<46> : vector<4xi64>}> : () -> vector<4xi64>
  %64 = "llvm.mlir.constant"() <{value = dense<23> : vector<4xi64>}> : () -> vector<4xi64>
  %65 = "llvm.mlir.constant"() <{value = dense<-1> : vector<4xi64>}> : () -> vector<4xi64>
  %66 = "llvm.mlir.constant"() <{value = dense<4794697086780616226> : vector<4xi64>}> : () -> vector<4xi64>
  %67 = "llvm.mlir.constant"() <{value = dense<36> : vector<4xi64>}> : () -> vector<4xi64>
  %68 = "llvm.mlir.constant"() <{value = dense<30> : vector<4xi64>}> : () -> vector<4xi64>
  %69 = "llvm.mlir.constant"() <{value = dense<25> : vector<4xi64>}> : () -> vector<4xi64>
  %70 = "llvm.mlir.constant"() <{value = dense<8158064640168781261> : vector<4xi64>}> : () -> vector<4xi64>
  %71 = "llvm.mlir.constant"() <{value = dense<-5349999486874862801> : vector<4xi64>}> : () -> vector<4xi64>
  %72 = "llvm.mlir.constant"() <{value = dense<-1606136188198331460> : vector<4xi64>}> : () -> vector<4xi64>
  %73 = "llvm.mlir.constant"() <{value = dense<4131703408338449720> : vector<4xi64>}> : () -> vector<4xi64>
  %74 = "llvm.mlir.constant"() <{value = dense<6480981068601479193> : vector<4xi64>}> : () -> vector<4xi64>
  %75 = "llvm.mlir.constant"() <{value = dense<-7908458776815382629> : vector<4xi64>}> : () -> vector<4xi64>
  %76 = "llvm.mlir.constant"() <{value = dense<-6116909921290321640> : vector<4xi64>}> : () -> vector<4xi64>
  %77 = "llvm.mlir.constant"() <{value = dense<-2880145864133508542> : vector<4xi64>}> : () -> vector<4xi64>
  %78 = "llvm.mlir.constant"() <{value = dense<1334009975649890238> : vector<4xi64>}> : () -> vector<4xi64>
  %79 = "llvm.mlir.constant"() <{value = dense<2608012711638119052> : vector<4xi64>}> : () -> vector<4xi64>
  %80 = "llvm.mlir.constant"() <{value = dense<6128411473006802146> : vector<4xi64>}> : () -> vector<4xi64>
  %81 = "llvm.mlir.constant"() <{value = dense<8268148722764581231> : vector<4xi64>}> : () -> vector<4xi64>
  %82 = "llvm.mlir.constant"() <{value = dense<-9160688886553864527> : vector<4xi64>}> : () -> vector<4xi64>
  %83 = "llvm.mlir.constant"() <{value = dense<-7215885187991268811> : vector<4xi64>}> : () -> vector<4xi64>
  %84 = "llvm.mlir.constant"() <{value = dense<-4495734319001033068> : vector<4xi64>}> : () -> vector<4xi64>
  %85 = "llvm.mlir.constant"() <{value = dense<63> : vector<4xi64>}> : () -> vector<4xi64>
  %86 = "llvm.mlir.constant"() <{value = dense<56> : vector<4xi64>}> : () -> vector<4xi64>
  %87 = "llvm.mlir.constant"() <{value = dense<45> : vector<4xi64>}> : () -> vector<4xi64>
  %88 = "llvm.mlir.constant"() <{value = dense<3> : vector<4xi64>}> : () -> vector<4xi64>
  %89 = "llvm.mlir.constant"() <{value = dense<6> : vector<4xi64>}> : () -> vector<4xi64>
  %90 = "llvm.mlir.addressof"() <{global_name = @fd_sha512_private_batch_avx.K}> : () -> !llvm.ptr
  %91 = "llvm.mlir.constant"() <{value = dense<128> : vector<4xi64>}> : () -> vector<4xi64>
  %92 = "llvm.mlir.poison"() : () -> vector<32xi8>
  %93 = "llvm.alloca"(%0) <{alignment = 32 : i64, elem_type = !llvm.array<4 x i64>}> : (i32) -> !llvm.ptr
  %94 = "llvm.alloca"(%0) <{alignment = 32 : i64, elem_type = !llvm.array<4 x i64>}> : (i32) -> !llvm.ptr
  %95 = "llvm.alloca"(%0) <{alignment = 128 : i64, elem_type = !llvm.array<1024 x i8>}> : (i32) -> !llvm.ptr
  %96 = "llvm.icmp"(%arg0, %1) <{predicate = 6 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%96)[^bb1, ^bb3] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb1:  // pred: ^bb0
  %97 = "llvm.icmp"(%arg0, %19) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%97)[^bb2, ^bb32] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb2:  // pred: ^bb1
  %98 = "llvm.load"(%arg1) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> !llvm.ptr
  %99 = "llvm.load"(%arg2) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %100 = "llvm.load"(%arg3) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> !llvm.ptr
  %101 = "llvm.call"(%98, %99, %100) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_sha512_hash, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, i64, !llvm.ptr) -> !llvm.ptr
  "llvm.br"()[^bb32] : () -> ()
^bb3:  // pred: ^bb0
  "llvm.intr.lifetime.start"(%93) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%94) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%95) : (!llvm.ptr) -> ()
  %102 = "llvm.ptrtoint"(%95) : (!llvm.ptr) -> i64
  "llvm.br"(%102, %2)[^bb6] : (i64, i64) -> ()
^bb4:  // pred: ^bb22
  %103 = "llvm.insertelement"(%38, %102, %2) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %104 = "llvm.shufflevector"(%103, %38) <{mask = array<i32: 0, 0, 0, 0>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %105 = "llvm.trunc"(%arg0) <{overflowFlags = 0 : i32}> : (i64) -> i32
  %106 = "llvm.shl"(%105, %0) <{overflowFlags = 0 : i32}> : (i32, i32) -> i32
  %107 = "llvm.shl"(%39, %106) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %108 = "llvm.xor"(%107, %39) : (i32, i32) -> i32
  %109 = "llvm.insertelement"(%40, %108, %2) : (vector<8xi32>, i32, i64) -> vector<8xi32>
  %110 = "llvm.shufflevector"(%109, %40) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %111 = "llvm.and"(%110, %41) : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %112 = "llvm.icmp"(%111, %42) <{predicate = 1 : i64}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi1>
  %113 = "llvm.sext"(%112) : (vector<8xi1>) -> vector<8xi32>
  %114 = "llvm.bitcast"(%113) : (vector<8xi32>) -> vector<4xi64>
  %115 = "llvm.load"(%93) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<4xi64>
  %116 = "llvm.load"(%94) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<4xi64>
  %117 = "llvm.load"(%arg2) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<4xi64>
  %118 = "llvm.lshr"(%117, %43) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %119 = "llvm.add"(%118, %116) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %120 = "llvm.and"(%119, %114) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %121 = "llvm.icmp"(%120, %8) <{predicate = 1 : i64}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi1>
  %122 = "llvm.sext"(%121) : (vector<4xi1>) -> vector<4xi64>
  %123 = "llvm.bitcast"(%122) : (vector<4xi64>) -> vector<8xi32>
  %124 = "llvm.icmp"(%123, %42) <{predicate = 2 : i64}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi1>
  %125 = "llvm.bitcast"(%124) : (vector<8xi1>) -> i8
  %126 = "llvm.icmp"(%125, %44) <{predicate = 0 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%126, %45, %46, %47, %48, %49, %50, %51, %52)[^bb27, ^bb5] <{branch_weights = array<i32: 1, 127>, operandSegmentSizes = array<i32: 1, 8, 0>}> : (i1, vector<8xi32>, vector<8xi32>, vector<8xi32>, vector<8xi32>, vector<8xi32>, vector<8xi32>, vector<8xi32>, vector<8xi32>) -> ()
^bb5:  // pred: ^bb4
  %127 = "llvm.load"(%arg1) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.br"(%122, %121, %53, %54, %55, %56, %57, %58, %59, %60, %127, %120)[^bb23] : (vector<4xi64>, vector<4xi1>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
^bb6(%128: i64, %129: i64):  // 2 preds: ^bb3, ^bb22
  %130 = "llvm.getelementptr"(%arg1, %129) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %131 = "llvm.load"(%130) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %132 = "llvm.getelementptr"(%arg2, %129) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %133 = "llvm.load"(%132) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %134 = "llvm.and"(%133, %3) : (i64, i64) -> i64
  %135 = "llvm.and"(%133, %4) : (i64, i64) -> i64
  %136 = "llvm.add"(%134, %5) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %137 = "llvm.and"(%136, %6) : (i64, i64) -> i64
  %138 = "llvm.getelementptr"(%93, %129) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%128, %138) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %139 = "llvm.lshr"(%136, %7) : (i64, i64) -> i64
  %140 = "llvm.getelementptr"(%94, %129) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%139, %140) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %141 = "llvm.add"(%137, %128) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %142 = "llvm.inttoptr"(%128) : (i64) -> !llvm.ptr
  "llvm.store"(%8, %142) <{alignment = 128 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<4xi64>, !llvm.ptr) -> ()
  %143 = "llvm.or"(%128, %9) <{isDisjoint}> : (i64, i64) -> i64
  %144 = "llvm.inttoptr"(%143) : (i64) -> !llvm.ptr
  "llvm.store"(%8, %144) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<4xi64>, !llvm.ptr) -> ()
  %145 = "llvm.or"(%128, %10) <{isDisjoint}> : (i64, i64) -> i64
  %146 = "llvm.inttoptr"(%145) : (i64) -> !llvm.ptr
  "llvm.store"(%8, %146) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<4xi64>, !llvm.ptr) -> ()
  %147 = "llvm.or"(%128, %11) <{isDisjoint}> : (i64, i64) -> i64
  %148 = "llvm.inttoptr"(%147) : (i64) -> !llvm.ptr
  "llvm.store"(%8, %148) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<4xi64>, !llvm.ptr) -> ()
  %149 = "llvm.add"(%128, %12) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %150 = "llvm.inttoptr"(%149) : (i64) -> !llvm.ptr
  "llvm.store"(%8, %150) <{alignment = 128 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<4xi64>, !llvm.ptr) -> ()
  %151 = "llvm.add"(%128, %13) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %152 = "llvm.inttoptr"(%151) : (i64) -> !llvm.ptr
  "llvm.store"(%8, %152) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<4xi64>, !llvm.ptr) -> ()
  %153 = "llvm.add"(%128, %14) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %154 = "llvm.inttoptr"(%153) : (i64) -> !llvm.ptr
  "llvm.store"(%8, %154) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<4xi64>, !llvm.ptr) -> ()
  %155 = "llvm.add"(%128, %15) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %156 = "llvm.inttoptr"(%155) : (i64) -> !llvm.ptr
  "llvm.store"(%8, %156) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<4xi64>, !llvm.ptr) -> ()
  %157 = "llvm.add"(%135, %131) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %158 = "llvm.icmp"(%134, %16) <{predicate = 8 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%158, %134, %128, %157)[^bb7, ^bb10] <{operandSegmentSizes = array<i32: 1, 0, 3>}> : (i1, i64, i64, i64) -> ()
^bb7:  // pred: ^bb6
  %159 = "llvm.add"(%134, %17) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %160 = "llvm.lshr"(%159, %18) : (i64, i64) -> i64
  %161 = "llvm.add"(%160, %19) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %162 = "llvm.and"(%161, %7) : (i64, i64) -> i64
  %163 = "llvm.icmp"(%162, %2) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%163, %157, %128, %134, %20, %20, %20, %157, %128, %134, %2)[^bb9, ^bb8] <{operandSegmentSizes = array<i32: 1, 6, 4>}> : (i1, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64) -> ()
^bb8(%164: i64, %165: i64, %166: i64, %167: i64):  // 2 preds: ^bb7, ^bb8
  %168 = "llvm.inttoptr"(%165) : (i64) -> !llvm.ptr
  %169 = "llvm.inttoptr"(%164) : (i64) -> !llvm.ptr
  %170 = "llvm.load"(%169) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.store"(%170, %168) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<4xi64>, !llvm.ptr) -> ()
  %171 = "llvm.add"(%165, %9) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %172 = "llvm.add"(%164, %9) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %173 = "llvm.add"(%166, %17) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %174 = "llvm.add"(%167, %19) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %175 = "llvm.icmp"(%174, %162) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%175, %172, %171, %173, %171, %172, %173, %172, %171, %173, %174)[^bb9, ^bb8] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true>>, operandSegmentSizes = array<i32: 1, 6, 4>}> : (i1, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64) -> ()
^bb9(%176: i64, %177: i64, %178: i64, %179: i64, %180: i64, %181: i64):  // 2 preds: ^bb7, ^bb8
  %182 = "llvm.icmp"(%159, %15) <{predicate = 6 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%182, %181, %179, %180, %176, %177, %178)[^bb10, ^bb14] <{operandSegmentSizes = array<i32: 1, 3, 3>}> : (i1, i64, i64, i64, i64, i64, i64) -> ()
^bb10(%183: i64, %184: i64, %185: i64):  // 3 preds: ^bb6, ^bb9, ^bb14
  %186 = "llvm.icmp"(%183, %7) <{predicate = 8 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%186, %183, %184, %185)[^bb11, ^bb16] <{operandSegmentSizes = array<i32: 1, 0, 3>}> : (i1, i64, i64, i64) -> ()
^bb11:  // pred: ^bb10
  %187 = "llvm.add"(%183, %23) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %188 = "llvm.lshr"(%187, %24) : (i64, i64) -> i64
  %189 = "llvm.add"(%188, %19) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %190 = "llvm.and"(%189, %7) : (i64, i64) -> i64
  %191 = "llvm.icmp"(%190, %2) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%191, %185, %184, %183, %20, %20, %20, %185, %184, %183, %2)[^bb13, ^bb12] <{operandSegmentSizes = array<i32: 1, 6, 4>}> : (i1, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64) -> ()
^bb12(%192: i64, %193: i64, %194: i64, %195: i64):  // 2 preds: ^bb11, ^bb12
  %196 = "llvm.inttoptr"(%192) : (i64) -> !llvm.ptr
  %197 = "llvm.load"(%196) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %198 = "llvm.inttoptr"(%193) : (i64) -> !llvm.ptr
  "llvm.store"(%197, %198) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %199 = "llvm.add"(%193, %25) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %200 = "llvm.add"(%192, %25) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %201 = "llvm.add"(%194, %23) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %202 = "llvm.add"(%195, %19) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %203 = "llvm.icmp"(%202, %190) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%203, %200, %199, %201, %199, %200, %201, %200, %199, %201, %202)[^bb13, ^bb12] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true>>, operandSegmentSizes = array<i32: 1, 6, 4>}> : (i1, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64) -> ()
^bb13(%204: i64, %205: i64, %206: i64, %207: i64, %208: i64, %209: i64):  // 2 preds: ^bb11, ^bb12
  %210 = "llvm.icmp"(%187, %26) <{predicate = 6 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%210, %209, %207, %208, %204, %205, %206)[^bb16, ^bb15] <{operandSegmentSizes = array<i32: 1, 3, 3>}> : (i1, i64, i64, i64, i64, i64, i64) -> ()
^bb14(%211: i64, %212: i64, %213: i64):  // 2 preds: ^bb9, ^bb14
  %214 = "llvm.inttoptr"(%212) : (i64) -> !llvm.ptr
  %215 = "llvm.inttoptr"(%211) : (i64) -> !llvm.ptr
  %216 = "llvm.load"(%215) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.store"(%216, %214) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<4xi64>, !llvm.ptr) -> ()
  %217 = "llvm.add"(%212, %9) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %218 = "llvm.add"(%211, %9) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %219 = "llvm.inttoptr"(%217) : (i64) -> !llvm.ptr
  %220 = "llvm.inttoptr"(%218) : (i64) -> !llvm.ptr
  %221 = "llvm.load"(%220) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.store"(%221, %219) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<4xi64>, !llvm.ptr) -> ()
  %222 = "llvm.add"(%212, %10) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %223 = "llvm.add"(%211, %10) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %224 = "llvm.inttoptr"(%222) : (i64) -> !llvm.ptr
  %225 = "llvm.inttoptr"(%223) : (i64) -> !llvm.ptr
  %226 = "llvm.load"(%225) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.store"(%226, %224) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<4xi64>, !llvm.ptr) -> ()
  %227 = "llvm.add"(%212, %11) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %228 = "llvm.add"(%211, %11) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %229 = "llvm.inttoptr"(%227) : (i64) -> !llvm.ptr
  %230 = "llvm.inttoptr"(%228) : (i64) -> !llvm.ptr
  %231 = "llvm.load"(%230) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.store"(%231, %229) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<4xi64>, !llvm.ptr) -> ()
  %232 = "llvm.add"(%212, %12) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %233 = "llvm.add"(%211, %12) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %234 = "llvm.inttoptr"(%232) : (i64) -> !llvm.ptr
  %235 = "llvm.inttoptr"(%233) : (i64) -> !llvm.ptr
  %236 = "llvm.load"(%235) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.store"(%236, %234) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<4xi64>, !llvm.ptr) -> ()
  %237 = "llvm.add"(%212, %13) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %238 = "llvm.add"(%211, %13) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %239 = "llvm.inttoptr"(%237) : (i64) -> !llvm.ptr
  %240 = "llvm.inttoptr"(%238) : (i64) -> !llvm.ptr
  %241 = "llvm.load"(%240) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.store"(%241, %239) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<4xi64>, !llvm.ptr) -> ()
  %242 = "llvm.add"(%212, %14) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %243 = "llvm.add"(%211, %14) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %244 = "llvm.inttoptr"(%242) : (i64) -> !llvm.ptr
  %245 = "llvm.inttoptr"(%243) : (i64) -> !llvm.ptr
  %246 = "llvm.load"(%245) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.store"(%246, %244) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<4xi64>, !llvm.ptr) -> ()
  %247 = "llvm.add"(%212, %15) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %248 = "llvm.add"(%211, %15) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %249 = "llvm.inttoptr"(%247) : (i64) -> !llvm.ptr
  %250 = "llvm.inttoptr"(%248) : (i64) -> !llvm.ptr
  %251 = "llvm.load"(%250) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.store"(%251, %249) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<4xi64>, !llvm.ptr) -> ()
  %252 = "llvm.add"(%212, %21) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %253 = "llvm.add"(%211, %21) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %254 = "llvm.add"(%213, %22) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %255 = "llvm.icmp"(%254, %16) <{predicate = 8 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%255, %253, %252, %254, %254, %252, %253)[^bb14, ^bb10] <{loop_annotation = #llvm.loop_annotation<mustProgress = true>, operandSegmentSizes = array<i32: 1, 3, 3>}> : (i1, i64, i64, i64, i64, i64, i64) -> ()
^bb15(%256: i64, %257: i64, %258: i64):  // 2 preds: ^bb13, ^bb15
  %259 = "llvm.inttoptr"(%256) : (i64) -> !llvm.ptr
  %260 = "llvm.load"(%259) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %261 = "llvm.inttoptr"(%257) : (i64) -> !llvm.ptr
  "llvm.store"(%260, %261) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %262 = "llvm.add"(%257, %25) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %263 = "llvm.add"(%256, %25) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %264 = "llvm.inttoptr"(%263) : (i64) -> !llvm.ptr
  %265 = "llvm.load"(%264) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %266 = "llvm.inttoptr"(%262) : (i64) -> !llvm.ptr
  "llvm.store"(%265, %266) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %267 = "llvm.add"(%257, %27) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %268 = "llvm.add"(%256, %27) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %269 = "llvm.inttoptr"(%268) : (i64) -> !llvm.ptr
  %270 = "llvm.load"(%269) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %271 = "llvm.inttoptr"(%267) : (i64) -> !llvm.ptr
  "llvm.store"(%270, %271) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %272 = "llvm.add"(%257, %28) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %273 = "llvm.add"(%256, %28) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %274 = "llvm.inttoptr"(%273) : (i64) -> !llvm.ptr
  %275 = "llvm.load"(%274) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %276 = "llvm.inttoptr"(%272) : (i64) -> !llvm.ptr
  "llvm.store"(%275, %276) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %277 = "llvm.add"(%257, %9) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %278 = "llvm.add"(%256, %9) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %279 = "llvm.inttoptr"(%278) : (i64) -> !llvm.ptr
  %280 = "llvm.load"(%279) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %281 = "llvm.inttoptr"(%277) : (i64) -> !llvm.ptr
  "llvm.store"(%280, %281) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %282 = "llvm.add"(%257, %29) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %283 = "llvm.add"(%256, %29) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %284 = "llvm.inttoptr"(%283) : (i64) -> !llvm.ptr
  %285 = "llvm.load"(%284) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %286 = "llvm.inttoptr"(%282) : (i64) -> !llvm.ptr
  "llvm.store"(%285, %286) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %287 = "llvm.add"(%257, %30) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %288 = "llvm.add"(%256, %30) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %289 = "llvm.inttoptr"(%288) : (i64) -> !llvm.ptr
  %290 = "llvm.load"(%289) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %291 = "llvm.inttoptr"(%287) : (i64) -> !llvm.ptr
  "llvm.store"(%290, %291) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %292 = "llvm.add"(%257, %26) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %293 = "llvm.add"(%256, %26) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %294 = "llvm.inttoptr"(%293) : (i64) -> !llvm.ptr
  %295 = "llvm.load"(%294) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %296 = "llvm.inttoptr"(%292) : (i64) -> !llvm.ptr
  "llvm.store"(%295, %296) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %297 = "llvm.add"(%257, %10) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %298 = "llvm.add"(%256, %10) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %299 = "llvm.add"(%258, %31) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %300 = "llvm.icmp"(%299, %7) <{predicate = 8 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%300, %298, %297, %299, %299, %297, %298)[^bb15, ^bb16] <{loop_annotation = #llvm.loop_annotation<mustProgress = true>, operandSegmentSizes = array<i32: 1, 3, 3>}> : (i1, i64, i64, i64, i64, i64, i64) -> ()
^bb16(%301: i64, %302: i64, %303: i64):  // 3 preds: ^bb10, ^bb13, ^bb15
  %304 = "llvm.icmp"(%301, %24) <{predicate = 8 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%304, %301, %302, %303)[^bb17, ^bb18] <{operandSegmentSizes = array<i32: 1, 0, 3>}> : (i1, i64, i64, i64) -> ()
^bb17:  // pred: ^bb16
  %305 = "llvm.inttoptr"(%303) : (i64) -> !llvm.ptr
  %306 = "llvm.load"(%305) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i32
  %307 = "llvm.inttoptr"(%302) : (i64) -> !llvm.ptr
  "llvm.store"(%306, %307) <{alignment = 4 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i32, !llvm.ptr) -> ()
  %308 = "llvm.or"(%302, %32) <{isDisjoint}> : (i64, i64) -> i64
  %309 = "llvm.add"(%303, %32) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %310 = "llvm.add"(%301, %33) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  "llvm.br"(%310, %308, %309)[^bb18] : (i64, i64, i64) -> ()
^bb18(%311: i64, %312: i64, %313: i64):  // 2 preds: ^bb16, ^bb17
  %314 = "llvm.icmp"(%311, %19) <{predicate = 8 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%314, %311, %312, %313)[^bb19, ^bb20] <{operandSegmentSizes = array<i32: 1, 0, 3>}> : (i1, i64, i64, i64) -> ()
^bb19:  // pred: ^bb18
  %315 = "llvm.inttoptr"(%313) : (i64) -> !llvm.ptr
  %316 = "llvm.load"(%315) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i16
  %317 = "llvm.inttoptr"(%312) : (i64) -> !llvm.ptr
  "llvm.store"(%316, %317) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i16, !llvm.ptr) -> ()
  %318 = "llvm.add"(%312, %1) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %319 = "llvm.add"(%313, %1) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %320 = "llvm.add"(%311, %34) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  "llvm.br"(%320, %318, %319)[^bb20] : (i64, i64, i64) -> ()
^bb20(%321: i64, %322: i64, %323: i64):  // 2 preds: ^bb18, ^bb19
  %324 = "llvm.icmp"(%321, %2) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%324, %322)[^bb22, ^bb21] <{operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i64) -> ()
^bb21:  // pred: ^bb20
  %325 = "llvm.inttoptr"(%323) : (i64) -> !llvm.ptr
  %326 = "llvm.load"(%325) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %327 = "llvm.inttoptr"(%322) : (i64) -> !llvm.ptr
  "llvm.store"(%326, %327) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (i8, !llvm.ptr) -> ()
  %328 = "llvm.add"(%322, %19) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.br"(%328)[^bb22] : (i64) -> ()
^bb22(%329: i64):  // 2 preds: ^bb20, ^bb21
  %330 = "llvm.inttoptr"(%329) : (i64) -> !llvm.ptr
  "llvm.store"(%35, %330) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (i8, !llvm.ptr) -> ()
  %331 = "llvm.lshr"(%133, %18) : (i64, i64) -> i64
  %332 = "llvm.and"(%331, %36) : (i64, i64) -> i64
  %333 = "llvm.add"(%141, %37) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %334 = "llvm.inttoptr"(%333) : (i64) -> !llvm.ptr
  "llvm.store"(%332, %334) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %335 = "llvm.shl"(%133, %24) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %336 = "llvm.intr.bswap"(%335) : (i64) -> i64
  %337 = "llvm.add"(%141, %23) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %338 = "llvm.inttoptr"(%337) : (i64) -> !llvm.ptr
  "llvm.store"(%336, %338) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %339 = "llvm.add"(%129, %19) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %340 = "llvm.icmp"(%339, %arg0) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%340, %141, %339)[^bb4, ^bb6] <{loop_annotation = #llvm.loop_annotation<mustProgress = true>, operandSegmentSizes = array<i32: 1, 0, 2>}> : (i1, i64, i64) -> ()
^bb23(%341: vector<4xi64>, %342: vector<4xi1>, %343: vector<4xi64>, %344: vector<4xi64>, %345: vector<4xi64>, %346: vector<4xi64>, %347: vector<4xi64>, %348: vector<4xi64>, %349: vector<4xi64>, %350: vector<4xi64>, %351: vector<4xi64>, %352: vector<4xi64>):  // 2 preds: ^bb5, ^bb25
  %353 = "llvm.icmp"(%352, %116) <{predicate = 0 : i64}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi1>
  %354 = "llvm.select"(%353, %115, %351) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<4xi1>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %355 = "llvm.select"(%342, %354, %104) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<4xi1>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %356 = "llvm.extractelement"(%355, %2) : (vector<4xi64>, i64) -> i64
  %357 = "llvm.inttoptr"(%356) : (i64) -> !llvm.ptr
  %358 = "llvm.extractelement"(%355, %19) : (vector<4xi64>, i64) -> i64
  %359 = "llvm.inttoptr"(%358) : (i64) -> !llvm.ptr
  %360 = "llvm.extractelement"(%355, %1) : (vector<4xi64>, i64) -> i64
  %361 = "llvm.inttoptr"(%360) : (i64) -> !llvm.ptr
  %362 = "llvm.extractelement"(%355, %24) : (vector<4xi64>, i64) -> i64
  %363 = "llvm.inttoptr"(%362) : (i64) -> !llvm.ptr
  %364 = "llvm.load"(%357) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<4xi64>
  %365 = "llvm.intr.fshl"(%364, %364, %61) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %366 = "llvm.bitcast"(%365) : (vector<4xi64>) -> vector<32xi8>
  %367 = "llvm.load"(%359) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<4xi64>
  %368 = "llvm.intr.fshl"(%367, %367, %61) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %369 = "llvm.bitcast"(%368) : (vector<4xi64>) -> vector<32xi8>
  %370 = "llvm.load"(%361) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<4xi64>
  %371 = "llvm.intr.fshl"(%370, %370, %61) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %372 = "llvm.bitcast"(%371) : (vector<4xi64>) -> vector<32xi8>
  %373 = "llvm.load"(%363) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<4xi64>
  %374 = "llvm.intr.fshl"(%373, %373, %61) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %375 = "llvm.bitcast"(%374) : (vector<4xi64>) -> vector<32xi8>
  %376 = "llvm.shufflevector"(%366, %372) <{mask = array<i32: 3, 2, 1, 0, 7, 6, 5, 4, 11, 10, 9, 8, 15, 14, 13, 12, 35, 34, 33, 32, 39, 38, 37, 36, 43, 42, 41, 40, 47, 46, 45, 44>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %377 = "llvm.bitcast"(%376) : (vector<32xi8>) -> vector<8xi32>
  %378 = "llvm.shufflevector"(%366, %372) <{mask = array<i32: 19, 18, 17, 16, 23, 22, 21, 20, 27, 26, 25, 24, 31, 30, 29, 28, 51, 50, 49, 48, 55, 54, 53, 52, 59, 58, 57, 56, 63, 62, 61, 60>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %379 = "llvm.bitcast"(%378) : (vector<32xi8>) -> vector<8xi32>
  %380 = "llvm.shufflevector"(%369, %375) <{mask = array<i32: 3, 2, 1, 0, 7, 6, 5, 4, 11, 10, 9, 8, 15, 14, 13, 12, 35, 34, 33, 32, 39, 38, 37, 36, 43, 42, 41, 40, 47, 46, 45, 44>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %381 = "llvm.bitcast"(%380) : (vector<32xi8>) -> vector<8xi32>
  %382 = "llvm.shufflevector"(%369, %375) <{mask = array<i32: 19, 18, 17, 16, 23, 22, 21, 20, 27, 26, 25, 24, 31, 30, 29, 28, 51, 50, 49, 48, 55, 54, 53, 52, 59, 58, 57, 56, 63, 62, 61, 60>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %383 = "llvm.bitcast"(%382) : (vector<32xi8>) -> vector<8xi32>
  %384 = "llvm.shufflevector"(%377, %381) <{mask = array<i32: 0, 1, 8, 9, 4, 5, 12, 13>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %385 = "llvm.bitcast"(%384) : (vector<8xi32>) -> vector<4xi64>
  %386 = "llvm.shufflevector"(%377, %381) <{mask = array<i32: 2, 3, 10, 11, 6, 7, 14, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %387 = "llvm.bitcast"(%386) : (vector<8xi32>) -> vector<4xi64>
  %388 = "llvm.shufflevector"(%379, %383) <{mask = array<i32: 0, 1, 8, 9, 4, 5, 12, 13>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %389 = "llvm.bitcast"(%388) : (vector<8xi32>) -> vector<4xi64>
  %390 = "llvm.shufflevector"(%379, %383) <{mask = array<i32: 2, 3, 10, 11, 6, 7, 14, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %391 = "llvm.bitcast"(%390) : (vector<8xi32>) -> vector<4xi64>
  %392 = "llvm.getelementptr"(%357) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %393 = "llvm.load"(%392) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<4xi64>
  %394 = "llvm.intr.fshl"(%393, %393, %61) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %395 = "llvm.bitcast"(%394) : (vector<4xi64>) -> vector<32xi8>
  %396 = "llvm.getelementptr"(%359) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %397 = "llvm.load"(%396) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<4xi64>
  %398 = "llvm.intr.fshl"(%397, %397, %61) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %399 = "llvm.bitcast"(%398) : (vector<4xi64>) -> vector<32xi8>
  %400 = "llvm.getelementptr"(%361) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %401 = "llvm.load"(%400) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<4xi64>
  %402 = "llvm.intr.fshl"(%401, %401, %61) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %403 = "llvm.bitcast"(%402) : (vector<4xi64>) -> vector<32xi8>
  %404 = "llvm.getelementptr"(%363) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %405 = "llvm.load"(%404) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<4xi64>
  %406 = "llvm.intr.fshl"(%405, %405, %61) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %407 = "llvm.bitcast"(%406) : (vector<4xi64>) -> vector<32xi8>
  %408 = "llvm.shufflevector"(%395, %403) <{mask = array<i32: 3, 2, 1, 0, 7, 6, 5, 4, 11, 10, 9, 8, 15, 14, 13, 12, 35, 34, 33, 32, 39, 38, 37, 36, 43, 42, 41, 40, 47, 46, 45, 44>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %409 = "llvm.bitcast"(%408) : (vector<32xi8>) -> vector<8xi32>
  %410 = "llvm.shufflevector"(%395, %403) <{mask = array<i32: 19, 18, 17, 16, 23, 22, 21, 20, 27, 26, 25, 24, 31, 30, 29, 28, 51, 50, 49, 48, 55, 54, 53, 52, 59, 58, 57, 56, 63, 62, 61, 60>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %411 = "llvm.bitcast"(%410) : (vector<32xi8>) -> vector<8xi32>
  %412 = "llvm.shufflevector"(%399, %407) <{mask = array<i32: 3, 2, 1, 0, 7, 6, 5, 4, 11, 10, 9, 8, 15, 14, 13, 12, 35, 34, 33, 32, 39, 38, 37, 36, 43, 42, 41, 40, 47, 46, 45, 44>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %413 = "llvm.bitcast"(%412) : (vector<32xi8>) -> vector<8xi32>
  %414 = "llvm.shufflevector"(%399, %407) <{mask = array<i32: 19, 18, 17, 16, 23, 22, 21, 20, 27, 26, 25, 24, 31, 30, 29, 28, 51, 50, 49, 48, 55, 54, 53, 52, 59, 58, 57, 56, 63, 62, 61, 60>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %415 = "llvm.bitcast"(%414) : (vector<32xi8>) -> vector<8xi32>
  %416 = "llvm.shufflevector"(%409, %413) <{mask = array<i32: 0, 1, 8, 9, 4, 5, 12, 13>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %417 = "llvm.bitcast"(%416) : (vector<8xi32>) -> vector<4xi64>
  %418 = "llvm.shufflevector"(%409, %413) <{mask = array<i32: 2, 3, 10, 11, 6, 7, 14, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %419 = "llvm.bitcast"(%418) : (vector<8xi32>) -> vector<4xi64>
  %420 = "llvm.shufflevector"(%411, %415) <{mask = array<i32: 0, 1, 8, 9, 4, 5, 12, 13>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %421 = "llvm.bitcast"(%420) : (vector<8xi32>) -> vector<4xi64>
  %422 = "llvm.shufflevector"(%411, %415) <{mask = array<i32: 2, 3, 10, 11, 6, 7, 14, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %423 = "llvm.bitcast"(%422) : (vector<8xi32>) -> vector<4xi64>
  %424 = "llvm.getelementptr"(%357) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %425 = "llvm.load"(%424) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<4xi64>
  %426 = "llvm.intr.fshl"(%425, %425, %61) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %427 = "llvm.bitcast"(%426) : (vector<4xi64>) -> vector<32xi8>
  %428 = "llvm.getelementptr"(%359) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %429 = "llvm.load"(%428) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<4xi64>
  %430 = "llvm.intr.fshl"(%429, %429, %61) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %431 = "llvm.bitcast"(%430) : (vector<4xi64>) -> vector<32xi8>
  %432 = "llvm.getelementptr"(%361) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %433 = "llvm.load"(%432) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<4xi64>
  %434 = "llvm.intr.fshl"(%433, %433, %61) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %435 = "llvm.bitcast"(%434) : (vector<4xi64>) -> vector<32xi8>
  %436 = "llvm.getelementptr"(%363) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %437 = "llvm.load"(%436) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<4xi64>
  %438 = "llvm.intr.fshl"(%437, %437, %61) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %439 = "llvm.bitcast"(%438) : (vector<4xi64>) -> vector<32xi8>
  %440 = "llvm.shufflevector"(%427, %435) <{mask = array<i32: 3, 2, 1, 0, 7, 6, 5, 4, 11, 10, 9, 8, 15, 14, 13, 12, 35, 34, 33, 32, 39, 38, 37, 36, 43, 42, 41, 40, 47, 46, 45, 44>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %441 = "llvm.bitcast"(%440) : (vector<32xi8>) -> vector<8xi32>
  %442 = "llvm.shufflevector"(%427, %435) <{mask = array<i32: 19, 18, 17, 16, 23, 22, 21, 20, 27, 26, 25, 24, 31, 30, 29, 28, 51, 50, 49, 48, 55, 54, 53, 52, 59, 58, 57, 56, 63, 62, 61, 60>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %443 = "llvm.bitcast"(%442) : (vector<32xi8>) -> vector<8xi32>
  %444 = "llvm.shufflevector"(%431, %439) <{mask = array<i32: 3, 2, 1, 0, 7, 6, 5, 4, 11, 10, 9, 8, 15, 14, 13, 12, 35, 34, 33, 32, 39, 38, 37, 36, 43, 42, 41, 40, 47, 46, 45, 44>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %445 = "llvm.bitcast"(%444) : (vector<32xi8>) -> vector<8xi32>
  %446 = "llvm.shufflevector"(%431, %439) <{mask = array<i32: 19, 18, 17, 16, 23, 22, 21, 20, 27, 26, 25, 24, 31, 30, 29, 28, 51, 50, 49, 48, 55, 54, 53, 52, 59, 58, 57, 56, 63, 62, 61, 60>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %447 = "llvm.bitcast"(%446) : (vector<32xi8>) -> vector<8xi32>
  %448 = "llvm.shufflevector"(%441, %445) <{mask = array<i32: 0, 1, 8, 9, 4, 5, 12, 13>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %449 = "llvm.bitcast"(%448) : (vector<8xi32>) -> vector<4xi64>
  %450 = "llvm.shufflevector"(%441, %445) <{mask = array<i32: 2, 3, 10, 11, 6, 7, 14, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %451 = "llvm.bitcast"(%450) : (vector<8xi32>) -> vector<4xi64>
  %452 = "llvm.shufflevector"(%443, %447) <{mask = array<i32: 0, 1, 8, 9, 4, 5, 12, 13>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %453 = "llvm.bitcast"(%452) : (vector<8xi32>) -> vector<4xi64>
  %454 = "llvm.shufflevector"(%443, %447) <{mask = array<i32: 2, 3, 10, 11, 6, 7, 14, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %455 = "llvm.bitcast"(%454) : (vector<8xi32>) -> vector<4xi64>
  %456 = "llvm.getelementptr"(%357) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 96>}> : (!llvm.ptr) -> !llvm.ptr
  %457 = "llvm.load"(%456) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<4xi64>
  %458 = "llvm.intr.fshl"(%457, %457, %61) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %459 = "llvm.bitcast"(%458) : (vector<4xi64>) -> vector<32xi8>
  %460 = "llvm.getelementptr"(%359) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 96>}> : (!llvm.ptr) -> !llvm.ptr
  %461 = "llvm.load"(%460) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<4xi64>
  %462 = "llvm.intr.fshl"(%461, %461, %61) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %463 = "llvm.bitcast"(%462) : (vector<4xi64>) -> vector<32xi8>
  %464 = "llvm.getelementptr"(%361) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 96>}> : (!llvm.ptr) -> !llvm.ptr
  %465 = "llvm.load"(%464) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<4xi64>
  %466 = "llvm.intr.fshl"(%465, %465, %61) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %467 = "llvm.bitcast"(%466) : (vector<4xi64>) -> vector<32xi8>
  %468 = "llvm.getelementptr"(%363) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 96>}> : (!llvm.ptr) -> !llvm.ptr
  %469 = "llvm.load"(%468) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<4xi64>
  %470 = "llvm.intr.fshl"(%469, %469, %61) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %471 = "llvm.bitcast"(%470) : (vector<4xi64>) -> vector<32xi8>
  %472 = "llvm.shufflevector"(%459, %467) <{mask = array<i32: 3, 2, 1, 0, 7, 6, 5, 4, 11, 10, 9, 8, 15, 14, 13, 12, 35, 34, 33, 32, 39, 38, 37, 36, 43, 42, 41, 40, 47, 46, 45, 44>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %473 = "llvm.bitcast"(%472) : (vector<32xi8>) -> vector<8xi32>
  %474 = "llvm.shufflevector"(%459, %467) <{mask = array<i32: 19, 18, 17, 16, 23, 22, 21, 20, 27, 26, 25, 24, 31, 30, 29, 28, 51, 50, 49, 48, 55, 54, 53, 52, 59, 58, 57, 56, 63, 62, 61, 60>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %475 = "llvm.bitcast"(%474) : (vector<32xi8>) -> vector<8xi32>
  %476 = "llvm.shufflevector"(%463, %471) <{mask = array<i32: 3, 2, 1, 0, 7, 6, 5, 4, 11, 10, 9, 8, 15, 14, 13, 12, 35, 34, 33, 32, 39, 38, 37, 36, 43, 42, 41, 40, 47, 46, 45, 44>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %477 = "llvm.bitcast"(%476) : (vector<32xi8>) -> vector<8xi32>
  %478 = "llvm.shufflevector"(%463, %471) <{mask = array<i32: 19, 18, 17, 16, 23, 22, 21, 20, 27, 26, 25, 24, 31, 30, 29, 28, 51, 50, 49, 48, 55, 54, 53, 52, 59, 58, 57, 56, 63, 62, 61, 60>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %479 = "llvm.bitcast"(%478) : (vector<32xi8>) -> vector<8xi32>
  %480 = "llvm.shufflevector"(%473, %477) <{mask = array<i32: 0, 1, 8, 9, 4, 5, 12, 13>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %481 = "llvm.bitcast"(%480) : (vector<8xi32>) -> vector<4xi64>
  %482 = "llvm.shufflevector"(%473, %477) <{mask = array<i32: 2, 3, 10, 11, 6, 7, 14, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %483 = "llvm.bitcast"(%482) : (vector<8xi32>) -> vector<4xi64>
  %484 = "llvm.shufflevector"(%475, %479) <{mask = array<i32: 0, 1, 8, 9, 4, 5, 12, 13>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %485 = "llvm.bitcast"(%484) : (vector<8xi32>) -> vector<4xi64>
  %486 = "llvm.shufflevector"(%475, %479) <{mask = array<i32: 2, 3, 10, 11, 6, 7, 14, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %487 = "llvm.bitcast"(%486) : (vector<8xi32>) -> vector<4xi64>
  %488 = "llvm.intr.fshl"(%347, %347, %62) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %489 = "llvm.intr.fshl"(%347, %347, %63) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %490 = "llvm.intr.fshl"(%347, %347, %64) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %491 = "llvm.xor"(%489, %490) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %492 = "llvm.xor"(%491, %488) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %493 = "llvm.and"(%347, %348) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %494 = "llvm.xor"(%347, %65) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %495 = "llvm.and"(%349, %494) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %496 = "llvm.or"(%493, %495) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %497 = "llvm.add"(%350, %66) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %498 = "llvm.add"(%497, %496) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %499 = "llvm.add"(%498, %492) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %500 = "llvm.add"(%499, %385) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %501 = "llvm.intr.fshl"(%343, %343, %67) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %502 = "llvm.intr.fshl"(%343, %343, %68) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %503 = "llvm.intr.fshl"(%343, %343, %69) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %504 = "llvm.xor"(%502, %503) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %505 = "llvm.xor"(%504, %501) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %506 = "llvm.and"(%343, %344) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %507 = "llvm.xor"(%343, %344) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %508 = "llvm.and"(%507, %345) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %509 = "llvm.xor"(%508, %506) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %510 = "llvm.add"(%505, %509) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %511 = "llvm.add"(%500, %346) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %512 = "llvm.add"(%510, %500) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %513 = "llvm.intr.fshl"(%511, %511, %62) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %514 = "llvm.intr.fshl"(%511, %511, %63) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %515 = "llvm.intr.fshl"(%511, %511, %64) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %516 = "llvm.xor"(%514, %515) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %517 = "llvm.xor"(%516, %513) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %518 = "llvm.and"(%511, %347) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %519 = "llvm.xor"(%511, %65) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %520 = "llvm.and"(%348, %519) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %521 = "llvm.or"(%518, %520) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %522 = "llvm.add"(%349, %70) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %523 = "llvm.add"(%522, %387) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %524 = "llvm.add"(%523, %521) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %525 = "llvm.add"(%524, %517) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %526 = "llvm.intr.fshl"(%512, %512, %67) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %527 = "llvm.intr.fshl"(%512, %512, %68) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %528 = "llvm.intr.fshl"(%512, %512, %69) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %529 = "llvm.xor"(%527, %528) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %530 = "llvm.xor"(%529, %526) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %531 = "llvm.and"(%512, %343) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %532 = "llvm.xor"(%512, %343) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %533 = "llvm.and"(%532, %344) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %534 = "llvm.xor"(%533, %531) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %535 = "llvm.add"(%530, %534) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %536 = "llvm.add"(%525, %345) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %537 = "llvm.add"(%535, %525) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %538 = "llvm.intr.fshl"(%536, %536, %62) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %539 = "llvm.intr.fshl"(%536, %536, %63) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %540 = "llvm.intr.fshl"(%536, %536, %64) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %541 = "llvm.xor"(%539, %540) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %542 = "llvm.xor"(%541, %538) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %543 = "llvm.and"(%536, %511) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %544 = "llvm.xor"(%536, %65) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %545 = "llvm.and"(%347, %544) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %546 = "llvm.or"(%543, %545) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %547 = "llvm.add"(%348, %71) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %548 = "llvm.add"(%547, %389) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %549 = "llvm.add"(%548, %546) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %550 = "llvm.add"(%549, %542) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %551 = "llvm.intr.fshl"(%537, %537, %67) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %552 = "llvm.intr.fshl"(%537, %537, %68) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %553 = "llvm.intr.fshl"(%537, %537, %69) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %554 = "llvm.xor"(%552, %553) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %555 = "llvm.xor"(%554, %551) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %556 = "llvm.and"(%537, %512) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %557 = "llvm.xor"(%537, %512) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %558 = "llvm.and"(%557, %343) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %559 = "llvm.xor"(%558, %556) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %560 = "llvm.add"(%555, %559) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %561 = "llvm.add"(%550, %344) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %562 = "llvm.add"(%560, %550) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %563 = "llvm.intr.fshl"(%561, %561, %62) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %564 = "llvm.intr.fshl"(%561, %561, %63) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %565 = "llvm.intr.fshl"(%561, %561, %64) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %566 = "llvm.xor"(%564, %565) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %567 = "llvm.xor"(%566, %563) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %568 = "llvm.and"(%561, %536) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %569 = "llvm.xor"(%561, %65) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %570 = "llvm.and"(%511, %569) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %571 = "llvm.or"(%568, %570) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %572 = "llvm.add"(%347, %72) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %573 = "llvm.add"(%572, %391) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %574 = "llvm.add"(%573, %571) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %575 = "llvm.add"(%574, %567) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %576 = "llvm.intr.fshl"(%562, %562, %67) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %577 = "llvm.intr.fshl"(%562, %562, %68) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %578 = "llvm.intr.fshl"(%562, %562, %69) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %579 = "llvm.xor"(%577, %578) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %580 = "llvm.xor"(%579, %576) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %581 = "llvm.and"(%562, %537) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %582 = "llvm.xor"(%562, %537) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %583 = "llvm.and"(%582, %512) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %584 = "llvm.xor"(%583, %581) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %585 = "llvm.add"(%580, %584) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %586 = "llvm.add"(%575, %343) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %587 = "llvm.add"(%585, %575) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %588 = "llvm.intr.fshl"(%586, %586, %62) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %589 = "llvm.intr.fshl"(%586, %586, %63) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %590 = "llvm.intr.fshl"(%586, %586, %64) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %591 = "llvm.xor"(%589, %590) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %592 = "llvm.xor"(%591, %588) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %593 = "llvm.and"(%586, %561) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %594 = "llvm.xor"(%586, %65) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %595 = "llvm.and"(%536, %594) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %596 = "llvm.or"(%593, %595) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %597 = "llvm.add"(%511, %73) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %598 = "llvm.add"(%597, %417) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %599 = "llvm.add"(%598, %596) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %600 = "llvm.add"(%599, %592) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %601 = "llvm.intr.fshl"(%587, %587, %67) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %602 = "llvm.intr.fshl"(%587, %587, %68) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %603 = "llvm.intr.fshl"(%587, %587, %69) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %604 = "llvm.xor"(%602, %603) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %605 = "llvm.xor"(%604, %601) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %606 = "llvm.and"(%587, %562) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %607 = "llvm.xor"(%587, %562) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %608 = "llvm.and"(%607, %537) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %609 = "llvm.xor"(%608, %606) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %610 = "llvm.add"(%605, %609) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %611 = "llvm.add"(%600, %512) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %612 = "llvm.add"(%610, %600) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %613 = "llvm.intr.fshl"(%611, %611, %62) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %614 = "llvm.intr.fshl"(%611, %611, %63) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %615 = "llvm.intr.fshl"(%611, %611, %64) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %616 = "llvm.xor"(%614, %615) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %617 = "llvm.xor"(%616, %613) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %618 = "llvm.and"(%611, %586) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %619 = "llvm.xor"(%611, %65) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %620 = "llvm.and"(%561, %619) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %621 = "llvm.or"(%618, %620) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %622 = "llvm.add"(%419, %74) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %623 = "llvm.add"(%622, %536) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %624 = "llvm.add"(%623, %621) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %625 = "llvm.add"(%624, %617) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %626 = "llvm.intr.fshl"(%612, %612, %67) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %627 = "llvm.intr.fshl"(%612, %612, %68) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %628 = "llvm.intr.fshl"(%612, %612, %69) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %629 = "llvm.xor"(%627, %628) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %630 = "llvm.xor"(%629, %626) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %631 = "llvm.and"(%612, %587) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %632 = "llvm.xor"(%612, %587) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %633 = "llvm.and"(%632, %562) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %634 = "llvm.xor"(%633, %631) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %635 = "llvm.add"(%630, %634) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %636 = "llvm.add"(%625, %537) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %637 = "llvm.add"(%635, %625) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %638 = "llvm.intr.fshl"(%636, %636, %62) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %639 = "llvm.intr.fshl"(%636, %636, %63) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %640 = "llvm.intr.fshl"(%636, %636, %64) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %641 = "llvm.xor"(%639, %640) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %642 = "llvm.xor"(%641, %638) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %643 = "llvm.and"(%636, %611) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %644 = "llvm.xor"(%636, %65) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %645 = "llvm.and"(%586, %644) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %646 = "llvm.or"(%643, %645) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %647 = "llvm.add"(%421, %75) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %648 = "llvm.add"(%647, %561) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %649 = "llvm.add"(%648, %646) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %650 = "llvm.add"(%649, %642) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %651 = "llvm.intr.fshl"(%637, %637, %67) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %652 = "llvm.intr.fshl"(%637, %637, %68) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %653 = "llvm.intr.fshl"(%637, %637, %69) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %654 = "llvm.xor"(%652, %653) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %655 = "llvm.xor"(%654, %651) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %656 = "llvm.and"(%637, %612) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %657 = "llvm.xor"(%637, %612) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %658 = "llvm.and"(%657, %587) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %659 = "llvm.xor"(%658, %656) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %660 = "llvm.add"(%655, %659) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %661 = "llvm.add"(%650, %562) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %662 = "llvm.add"(%660, %650) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %663 = "llvm.intr.fshl"(%661, %661, %62) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %664 = "llvm.intr.fshl"(%661, %661, %63) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %665 = "llvm.intr.fshl"(%661, %661, %64) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %666 = "llvm.xor"(%664, %665) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %667 = "llvm.xor"(%666, %663) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %668 = "llvm.and"(%661, %636) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %669 = "llvm.xor"(%661, %65) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %670 = "llvm.and"(%611, %669) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %671 = "llvm.or"(%668, %670) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %672 = "llvm.add"(%423, %76) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %673 = "llvm.add"(%672, %586) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %674 = "llvm.add"(%673, %671) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %675 = "llvm.add"(%674, %667) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %676 = "llvm.intr.fshl"(%662, %662, %67) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %677 = "llvm.intr.fshl"(%662, %662, %68) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %678 = "llvm.intr.fshl"(%662, %662, %69) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %679 = "llvm.xor"(%677, %678) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %680 = "llvm.xor"(%679, %676) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %681 = "llvm.and"(%662, %637) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %682 = "llvm.xor"(%662, %637) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %683 = "llvm.and"(%682, %612) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %684 = "llvm.xor"(%683, %681) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %685 = "llvm.add"(%680, %684) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %686 = "llvm.add"(%675, %587) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %687 = "llvm.add"(%685, %675) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %688 = "llvm.intr.fshl"(%686, %686, %62) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %689 = "llvm.intr.fshl"(%686, %686, %63) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %690 = "llvm.intr.fshl"(%686, %686, %64) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %691 = "llvm.xor"(%689, %690) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %692 = "llvm.xor"(%691, %688) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %693 = "llvm.and"(%686, %661) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %694 = "llvm.xor"(%686, %65) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %695 = "llvm.and"(%636, %694) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %696 = "llvm.or"(%693, %695) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %697 = "llvm.add"(%449, %77) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %698 = "llvm.add"(%697, %611) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %699 = "llvm.add"(%698, %696) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %700 = "llvm.add"(%699, %692) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %701 = "llvm.intr.fshl"(%687, %687, %67) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %702 = "llvm.intr.fshl"(%687, %687, %68) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %703 = "llvm.intr.fshl"(%687, %687, %69) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %704 = "llvm.xor"(%702, %703) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %705 = "llvm.xor"(%704, %701) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %706 = "llvm.and"(%687, %662) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %707 = "llvm.xor"(%687, %662) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %708 = "llvm.and"(%707, %637) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %709 = "llvm.xor"(%708, %706) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %710 = "llvm.add"(%705, %709) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %711 = "llvm.add"(%700, %612) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %712 = "llvm.add"(%710, %700) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %713 = "llvm.intr.fshl"(%711, %711, %62) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %714 = "llvm.intr.fshl"(%711, %711, %63) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %715 = "llvm.intr.fshl"(%711, %711, %64) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %716 = "llvm.xor"(%714, %715) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %717 = "llvm.xor"(%716, %713) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %718 = "llvm.and"(%711, %686) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %719 = "llvm.xor"(%711, %65) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %720 = "llvm.and"(%661, %719) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %721 = "llvm.or"(%718, %720) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %722 = "llvm.add"(%451, %78) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %723 = "llvm.add"(%722, %636) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %724 = "llvm.add"(%723, %721) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %725 = "llvm.add"(%724, %717) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %726 = "llvm.intr.fshl"(%712, %712, %67) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %727 = "llvm.intr.fshl"(%712, %712, %68) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %728 = "llvm.intr.fshl"(%712, %712, %69) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %729 = "llvm.xor"(%727, %728) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %730 = "llvm.xor"(%729, %726) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %731 = "llvm.and"(%712, %687) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %732 = "llvm.xor"(%712, %687) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %733 = "llvm.and"(%732, %662) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %734 = "llvm.xor"(%733, %731) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %735 = "llvm.add"(%730, %734) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %736 = "llvm.add"(%725, %637) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %737 = "llvm.add"(%735, %725) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %738 = "llvm.intr.fshl"(%736, %736, %62) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %739 = "llvm.intr.fshl"(%736, %736, %63) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %740 = "llvm.intr.fshl"(%736, %736, %64) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %741 = "llvm.xor"(%739, %740) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %742 = "llvm.xor"(%741, %738) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %743 = "llvm.and"(%736, %711) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %744 = "llvm.xor"(%736, %65) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %745 = "llvm.and"(%686, %744) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %746 = "llvm.or"(%743, %745) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %747 = "llvm.add"(%453, %79) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %748 = "llvm.add"(%747, %661) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %749 = "llvm.add"(%748, %746) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %750 = "llvm.add"(%749, %742) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %751 = "llvm.intr.fshl"(%737, %737, %67) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %752 = "llvm.intr.fshl"(%737, %737, %68) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %753 = "llvm.intr.fshl"(%737, %737, %69) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %754 = "llvm.xor"(%752, %753) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %755 = "llvm.xor"(%754, %751) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %756 = "llvm.and"(%737, %712) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %757 = "llvm.xor"(%737, %712) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %758 = "llvm.and"(%757, %687) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %759 = "llvm.xor"(%758, %756) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %760 = "llvm.add"(%755, %759) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %761 = "llvm.add"(%750, %662) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %762 = "llvm.add"(%760, %750) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %763 = "llvm.intr.fshl"(%761, %761, %62) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %764 = "llvm.intr.fshl"(%761, %761, %63) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %765 = "llvm.intr.fshl"(%761, %761, %64) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %766 = "llvm.xor"(%764, %765) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %767 = "llvm.xor"(%766, %763) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %768 = "llvm.and"(%761, %736) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %769 = "llvm.xor"(%761, %65) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %770 = "llvm.and"(%711, %769) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %771 = "llvm.or"(%768, %770) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %772 = "llvm.add"(%455, %80) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %773 = "llvm.add"(%772, %686) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %774 = "llvm.add"(%773, %771) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %775 = "llvm.add"(%774, %767) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %776 = "llvm.intr.fshl"(%762, %762, %67) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %777 = "llvm.intr.fshl"(%762, %762, %68) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %778 = "llvm.intr.fshl"(%762, %762, %69) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %779 = "llvm.xor"(%777, %778) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %780 = "llvm.xor"(%779, %776) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %781 = "llvm.and"(%762, %737) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %782 = "llvm.xor"(%762, %737) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %783 = "llvm.and"(%782, %712) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %784 = "llvm.xor"(%783, %781) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %785 = "llvm.add"(%780, %784) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %786 = "llvm.add"(%775, %687) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %787 = "llvm.add"(%785, %775) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %788 = "llvm.intr.fshl"(%786, %786, %62) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %789 = "llvm.intr.fshl"(%786, %786, %63) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %790 = "llvm.intr.fshl"(%786, %786, %64) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %791 = "llvm.xor"(%789, %790) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %792 = "llvm.xor"(%791, %788) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %793 = "llvm.and"(%786, %761) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %794 = "llvm.xor"(%786, %65) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %795 = "llvm.and"(%736, %794) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %796 = "llvm.or"(%793, %795) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %797 = "llvm.add"(%481, %81) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %798 = "llvm.add"(%797, %711) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %799 = "llvm.add"(%798, %796) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %800 = "llvm.add"(%799, %792) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %801 = "llvm.intr.fshl"(%787, %787, %67) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %802 = "llvm.intr.fshl"(%787, %787, %68) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %803 = "llvm.intr.fshl"(%787, %787, %69) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %804 = "llvm.xor"(%802, %803) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %805 = "llvm.xor"(%804, %801) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %806 = "llvm.and"(%787, %762) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %807 = "llvm.xor"(%787, %762) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %808 = "llvm.and"(%807, %737) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %809 = "llvm.xor"(%808, %806) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %810 = "llvm.add"(%805, %809) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %811 = "llvm.add"(%800, %712) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %812 = "llvm.add"(%810, %800) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %813 = "llvm.intr.fshl"(%811, %811, %62) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %814 = "llvm.intr.fshl"(%811, %811, %63) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %815 = "llvm.intr.fshl"(%811, %811, %64) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %816 = "llvm.xor"(%814, %815) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %817 = "llvm.xor"(%816, %813) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %818 = "llvm.and"(%811, %786) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %819 = "llvm.xor"(%811, %65) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %820 = "llvm.and"(%761, %819) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %821 = "llvm.or"(%818, %820) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %822 = "llvm.add"(%483, %82) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %823 = "llvm.add"(%822, %736) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %824 = "llvm.add"(%823, %821) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %825 = "llvm.add"(%824, %817) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %826 = "llvm.intr.fshl"(%812, %812, %67) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %827 = "llvm.intr.fshl"(%812, %812, %68) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %828 = "llvm.intr.fshl"(%812, %812, %69) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %829 = "llvm.xor"(%827, %828) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %830 = "llvm.xor"(%829, %826) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %831 = "llvm.and"(%812, %787) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %832 = "llvm.xor"(%812, %787) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %833 = "llvm.and"(%832, %762) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %834 = "llvm.xor"(%833, %831) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %835 = "llvm.add"(%830, %834) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %836 = "llvm.add"(%825, %737) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %837 = "llvm.add"(%835, %825) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %838 = "llvm.intr.fshl"(%836, %836, %62) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %839 = "llvm.intr.fshl"(%836, %836, %63) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %840 = "llvm.intr.fshl"(%836, %836, %64) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %841 = "llvm.xor"(%839, %840) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %842 = "llvm.xor"(%841, %838) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %843 = "llvm.and"(%836, %811) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %844 = "llvm.xor"(%836, %65) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %845 = "llvm.and"(%786, %844) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %846 = "llvm.or"(%843, %845) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %847 = "llvm.add"(%485, %83) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %848 = "llvm.add"(%847, %761) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %849 = "llvm.add"(%848, %846) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %850 = "llvm.add"(%849, %842) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %851 = "llvm.intr.fshl"(%837, %837, %67) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %852 = "llvm.intr.fshl"(%837, %837, %68) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %853 = "llvm.intr.fshl"(%837, %837, %69) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %854 = "llvm.xor"(%852, %853) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %855 = "llvm.xor"(%854, %851) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %856 = "llvm.and"(%837, %812) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %857 = "llvm.xor"(%837, %812) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %858 = "llvm.and"(%857, %787) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %859 = "llvm.xor"(%858, %856) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %860 = "llvm.add"(%855, %859) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %861 = "llvm.add"(%850, %762) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %862 = "llvm.add"(%860, %850) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %863 = "llvm.intr.fshl"(%861, %861, %62) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %864 = "llvm.intr.fshl"(%861, %861, %63) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %865 = "llvm.intr.fshl"(%861, %861, %64) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %866 = "llvm.xor"(%864, %865) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %867 = "llvm.xor"(%866, %863) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %868 = "llvm.and"(%861, %836) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %869 = "llvm.xor"(%861, %65) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %870 = "llvm.and"(%811, %869) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %871 = "llvm.or"(%868, %870) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %872 = "llvm.add"(%487, %84) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %873 = "llvm.add"(%872, %786) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %874 = "llvm.add"(%873, %871) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %875 = "llvm.add"(%874, %867) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %876 = "llvm.intr.fshl"(%862, %862, %67) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %877 = "llvm.intr.fshl"(%862, %862, %68) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %878 = "llvm.intr.fshl"(%862, %862, %69) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %879 = "llvm.xor"(%877, %878) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %880 = "llvm.xor"(%879, %876) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %881 = "llvm.and"(%862, %837) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %882 = "llvm.xor"(%862, %837) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %883 = "llvm.and"(%882, %812) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %884 = "llvm.xor"(%883, %881) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %885 = "llvm.add"(%880, %884) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %886 = "llvm.add"(%875, %787) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %887 = "llvm.add"(%885, %875) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.br"(%27, %811, %836, %861, %886, %812, %837, %862, %887, %487, %485, %483, %481, %385, %387, %389, %391, %455, %453, %451, %449, %417, %419, %421, %423)[^bb24] : (i64, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
^bb24(%888: i64, %889: vector<4xi64>, %890: vector<4xi64>, %891: vector<4xi64>, %892: vector<4xi64>, %893: vector<4xi64>, %894: vector<4xi64>, %895: vector<4xi64>, %896: vector<4xi64>, %897: vector<4xi64>, %898: vector<4xi64>, %899: vector<4xi64>, %900: vector<4xi64>, %901: vector<4xi64>, %902: vector<4xi64>, %903: vector<4xi64>, %904: vector<4xi64>, %905: vector<4xi64>, %906: vector<4xi64>, %907: vector<4xi64>, %908: vector<4xi64>, %909: vector<4xi64>, %910: vector<4xi64>, %911: vector<4xi64>, %912: vector<4xi64>):  // 2 preds: ^bb23, ^bb24
  %913 = "llvm.intr.fshl"(%902, %902, %85) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %914 = "llvm.intr.fshl"(%902, %902, %86) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %915 = "llvm.lshr"(%902, %43) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %916 = "llvm.xor"(%914, %915) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %917 = "llvm.xor"(%916, %913) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %918 = "llvm.intr.fshl"(%898, %898, %87) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %919 = "llvm.intr.fshl"(%898, %898, %88) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %920 = "llvm.lshr"(%898, %89) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %921 = "llvm.xor"(%919, %920) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %922 = "llvm.xor"(%921, %918) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %923 = "llvm.add"(%901, %907) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %924 = "llvm.add"(%923, %917) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %925 = "llvm.add"(%924, %922) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %926 = "llvm.getelementptr"(%90, %888) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %927 = "llvm.load"(%926) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %928 = "llvm.insertelement"(%38, %927, %2) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %929 = "llvm.shufflevector"(%928, %38) <{mask = array<i32: 0, 0, 0, 0>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %930 = "llvm.intr.fshl"(%892, %892, %62) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %931 = "llvm.intr.fshl"(%892, %892, %63) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %932 = "llvm.intr.fshl"(%892, %892, %64) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %933 = "llvm.xor"(%931, %932) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %934 = "llvm.xor"(%933, %930) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %935 = "llvm.and"(%891, %892) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %936 = "llvm.xor"(%892, %65) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %937 = "llvm.and"(%890, %936) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %938 = "llvm.or"(%937, %935) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %939 = "llvm.add"(%934, %925) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %940 = "llvm.add"(%939, %889) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %941 = "llvm.add"(%940, %938) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %942 = "llvm.add"(%941, %929) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %943 = "llvm.intr.fshl"(%896, %896, %67) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %944 = "llvm.intr.fshl"(%896, %896, %68) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %945 = "llvm.intr.fshl"(%896, %896, %69) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %946 = "llvm.xor"(%944, %945) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %947 = "llvm.xor"(%946, %943) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %948 = "llvm.and"(%895, %896) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %949 = "llvm.xor"(%895, %896) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %950 = "llvm.and"(%949, %894) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %951 = "llvm.xor"(%950, %948) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %952 = "llvm.add"(%951, %947) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %953 = "llvm.add"(%942, %893) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %954 = "llvm.add"(%952, %942) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %955 = "llvm.intr.fshl"(%903, %903, %85) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %956 = "llvm.intr.fshl"(%903, %903, %86) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %957 = "llvm.lshr"(%903, %43) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %958 = "llvm.xor"(%956, %957) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %959 = "llvm.xor"(%958, %955) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %960 = "llvm.intr.fshl"(%897, %897, %87) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %961 = "llvm.intr.fshl"(%897, %897, %88) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %962 = "llvm.lshr"(%897, %89) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %963 = "llvm.xor"(%961, %962) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %964 = "llvm.xor"(%963, %960) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %965 = "llvm.add"(%902, %906) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %966 = "llvm.add"(%965, %959) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %967 = "llvm.add"(%966, %964) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %968 = "llvm.getelementptr"(%926) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %969 = "llvm.load"(%968) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %970 = "llvm.insertelement"(%38, %969, %2) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %971 = "llvm.shufflevector"(%970, %38) <{mask = array<i32: 0, 0, 0, 0>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %972 = "llvm.intr.fshl"(%953, %953, %62) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %973 = "llvm.intr.fshl"(%953, %953, %63) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %974 = "llvm.intr.fshl"(%953, %953, %64) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %975 = "llvm.xor"(%973, %974) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %976 = "llvm.xor"(%975, %972) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %977 = "llvm.and"(%953, %892) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %978 = "llvm.xor"(%953, %65) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %979 = "llvm.and"(%891, %978) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %980 = "llvm.or"(%977, %979) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %981 = "llvm.add"(%890, %967) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %982 = "llvm.add"(%981, %971) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %983 = "llvm.add"(%982, %980) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %984 = "llvm.add"(%983, %976) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %985 = "llvm.intr.fshl"(%954, %954, %67) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %986 = "llvm.intr.fshl"(%954, %954, %68) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %987 = "llvm.intr.fshl"(%954, %954, %69) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %988 = "llvm.xor"(%986, %987) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %989 = "llvm.xor"(%988, %985) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %990 = "llvm.and"(%954, %896) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %991 = "llvm.xor"(%954, %896) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %992 = "llvm.and"(%991, %895) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %993 = "llvm.xor"(%992, %990) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %994 = "llvm.add"(%989, %993) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %995 = "llvm.add"(%984, %894) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %996 = "llvm.add"(%994, %984) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %997 = "llvm.intr.fshl"(%904, %904, %85) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %998 = "llvm.intr.fshl"(%904, %904, %86) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %999 = "llvm.lshr"(%904, %43) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1000 = "llvm.xor"(%998, %999) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1001 = "llvm.xor"(%1000, %997) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1002 = "llvm.intr.fshl"(%925, %925, %87) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1003 = "llvm.intr.fshl"(%925, %925, %88) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1004 = "llvm.lshr"(%925, %89) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1005 = "llvm.xor"(%1003, %1004) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1006 = "llvm.xor"(%1005, %1002) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1007 = "llvm.add"(%903, %905) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1008 = "llvm.add"(%1007, %1001) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1009 = "llvm.add"(%1008, %1006) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1010 = "llvm.getelementptr"(%926) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %1011 = "llvm.load"(%1010) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %1012 = "llvm.insertelement"(%38, %1011, %2) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %1013 = "llvm.shufflevector"(%1012, %38) <{mask = array<i32: 0, 0, 0, 0>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1014 = "llvm.intr.fshl"(%995, %995, %62) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1015 = "llvm.intr.fshl"(%995, %995, %63) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1016 = "llvm.intr.fshl"(%995, %995, %64) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1017 = "llvm.xor"(%1015, %1016) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1018 = "llvm.xor"(%1017, %1014) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1019 = "llvm.and"(%995, %953) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1020 = "llvm.xor"(%995, %65) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1021 = "llvm.and"(%892, %1020) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1022 = "llvm.or"(%1019, %1021) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1023 = "llvm.add"(%1009, %891) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1024 = "llvm.add"(%1023, %1013) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1025 = "llvm.add"(%1024, %1022) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1026 = "llvm.add"(%1025, %1018) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1027 = "llvm.intr.fshl"(%996, %996, %67) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1028 = "llvm.intr.fshl"(%996, %996, %68) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1029 = "llvm.intr.fshl"(%996, %996, %69) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1030 = "llvm.xor"(%1028, %1029) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1031 = "llvm.xor"(%1030, %1027) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1032 = "llvm.and"(%996, %954) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1033 = "llvm.xor"(%996, %954) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1034 = "llvm.and"(%1033, %896) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1035 = "llvm.xor"(%1034, %1032) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1036 = "llvm.add"(%1031, %1035) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1037 = "llvm.add"(%1026, %895) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1038 = "llvm.add"(%1036, %1026) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1039 = "llvm.intr.fshl"(%909, %909, %85) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1040 = "llvm.intr.fshl"(%909, %909, %86) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1041 = "llvm.lshr"(%909, %43) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1042 = "llvm.xor"(%1040, %1041) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1043 = "llvm.xor"(%1042, %1039) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1044 = "llvm.intr.fshl"(%967, %967, %87) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1045 = "llvm.intr.fshl"(%967, %967, %88) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1046 = "llvm.lshr"(%967, %89) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1047 = "llvm.xor"(%1045, %1046) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1048 = "llvm.xor"(%1047, %1044) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1049 = "llvm.add"(%904, %1043) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1050 = "llvm.add"(%1049, %900) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1051 = "llvm.add"(%1050, %1048) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1052 = "llvm.getelementptr"(%926) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %1053 = "llvm.load"(%1052) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %1054 = "llvm.insertelement"(%38, %1053, %2) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %1055 = "llvm.shufflevector"(%1054, %38) <{mask = array<i32: 0, 0, 0, 0>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1056 = "llvm.intr.fshl"(%1037, %1037, %62) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1057 = "llvm.intr.fshl"(%1037, %1037, %63) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1058 = "llvm.intr.fshl"(%1037, %1037, %64) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1059 = "llvm.xor"(%1057, %1058) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1060 = "llvm.xor"(%1059, %1056) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1061 = "llvm.and"(%1037, %995) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1062 = "llvm.xor"(%1037, %65) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1063 = "llvm.and"(%953, %1062) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1064 = "llvm.or"(%1061, %1063) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1065 = "llvm.add"(%1051, %892) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1066 = "llvm.add"(%1065, %1055) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1067 = "llvm.add"(%1066, %1064) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1068 = "llvm.add"(%1067, %1060) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1069 = "llvm.intr.fshl"(%1038, %1038, %67) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1070 = "llvm.intr.fshl"(%1038, %1038, %68) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1071 = "llvm.intr.fshl"(%1038, %1038, %69) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1072 = "llvm.xor"(%1070, %1071) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1073 = "llvm.xor"(%1072, %1069) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1074 = "llvm.and"(%1038, %996) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1075 = "llvm.xor"(%1038, %996) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1076 = "llvm.and"(%1075, %954) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1077 = "llvm.xor"(%1076, %1074) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1078 = "llvm.add"(%1073, %1077) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1079 = "llvm.add"(%1068, %896) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1080 = "llvm.add"(%1078, %1068) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1081 = "llvm.intr.fshl"(%910, %910, %85) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1082 = "llvm.intr.fshl"(%910, %910, %86) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1083 = "llvm.lshr"(%910, %43) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1084 = "llvm.xor"(%1082, %1083) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1085 = "llvm.xor"(%1084, %1081) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1086 = "llvm.intr.fshl"(%1009, %1009, %87) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1087 = "llvm.intr.fshl"(%1009, %1009, %88) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1088 = "llvm.lshr"(%1009, %89) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1089 = "llvm.xor"(%1087, %1088) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1090 = "llvm.xor"(%1089, %1086) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1091 = "llvm.add"(%1085, %909) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1092 = "llvm.add"(%1091, %899) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1093 = "llvm.add"(%1092, %1090) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1094 = "llvm.getelementptr"(%926) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %1095 = "llvm.load"(%1094) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %1096 = "llvm.insertelement"(%38, %1095, %2) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %1097 = "llvm.shufflevector"(%1096, %38) <{mask = array<i32: 0, 0, 0, 0>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1098 = "llvm.intr.fshl"(%1079, %1079, %62) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1099 = "llvm.intr.fshl"(%1079, %1079, %63) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1100 = "llvm.intr.fshl"(%1079, %1079, %64) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1101 = "llvm.xor"(%1099, %1100) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1102 = "llvm.xor"(%1101, %1098) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1103 = "llvm.and"(%1079, %1037) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1104 = "llvm.xor"(%1079, %65) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1105 = "llvm.and"(%995, %1104) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1106 = "llvm.or"(%1103, %1105) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1107 = "llvm.add"(%953, %1093) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1108 = "llvm.add"(%1107, %1097) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1109 = "llvm.add"(%1108, %1106) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1110 = "llvm.add"(%1109, %1102) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1111 = "llvm.intr.fshl"(%1080, %1080, %67) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1112 = "llvm.intr.fshl"(%1080, %1080, %68) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1113 = "llvm.intr.fshl"(%1080, %1080, %69) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1114 = "llvm.xor"(%1112, %1113) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1115 = "llvm.xor"(%1114, %1111) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1116 = "llvm.and"(%1080, %1038) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1117 = "llvm.xor"(%1080, %1038) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1118 = "llvm.and"(%1117, %996) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1119 = "llvm.xor"(%1118, %1116) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1120 = "llvm.add"(%1115, %1119) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1121 = "llvm.add"(%1110, %954) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1122 = "llvm.add"(%1120, %1110) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1123 = "llvm.intr.fshl"(%911, %911, %85) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1124 = "llvm.intr.fshl"(%911, %911, %86) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1125 = "llvm.lshr"(%911, %43) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1126 = "llvm.xor"(%1124, %1125) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1127 = "llvm.xor"(%1126, %1123) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1128 = "llvm.intr.fshl"(%1051, %1051, %87) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1129 = "llvm.intr.fshl"(%1051, %1051, %88) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1130 = "llvm.lshr"(%1051, %89) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1131 = "llvm.xor"(%1129, %1130) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1132 = "llvm.xor"(%1131, %1128) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1133 = "llvm.add"(%1127, %910) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1134 = "llvm.add"(%1133, %898) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1135 = "llvm.add"(%1134, %1132) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1136 = "llvm.getelementptr"(%926) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 40>}> : (!llvm.ptr) -> !llvm.ptr
  %1137 = "llvm.load"(%1136) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %1138 = "llvm.insertelement"(%38, %1137, %2) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %1139 = "llvm.shufflevector"(%1138, %38) <{mask = array<i32: 0, 0, 0, 0>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1140 = "llvm.intr.fshl"(%1121, %1121, %62) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1141 = "llvm.intr.fshl"(%1121, %1121, %63) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1142 = "llvm.intr.fshl"(%1121, %1121, %64) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1143 = "llvm.xor"(%1141, %1142) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1144 = "llvm.xor"(%1143, %1140) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1145 = "llvm.and"(%1121, %1079) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1146 = "llvm.xor"(%1121, %65) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1147 = "llvm.and"(%1037, %1146) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1148 = "llvm.or"(%1145, %1147) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1149 = "llvm.add"(%1139, %1135) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1150 = "llvm.add"(%1149, %995) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1151 = "llvm.add"(%1150, %1148) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1152 = "llvm.add"(%1151, %1144) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1153 = "llvm.intr.fshl"(%1122, %1122, %67) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1154 = "llvm.intr.fshl"(%1122, %1122, %68) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1155 = "llvm.intr.fshl"(%1122, %1122, %69) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1156 = "llvm.xor"(%1154, %1155) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1157 = "llvm.xor"(%1156, %1153) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1158 = "llvm.and"(%1122, %1080) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1159 = "llvm.xor"(%1122, %1080) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1160 = "llvm.and"(%1159, %1038) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1161 = "llvm.xor"(%1160, %1158) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1162 = "llvm.add"(%1157, %1161) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1163 = "llvm.add"(%1152, %996) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1164 = "llvm.add"(%1162, %1152) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1165 = "llvm.intr.fshl"(%912, %912, %85) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1166 = "llvm.intr.fshl"(%912, %912, %86) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1167 = "llvm.lshr"(%912, %43) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1168 = "llvm.xor"(%1166, %1167) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1169 = "llvm.xor"(%1168, %1165) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1170 = "llvm.intr.fshl"(%1093, %1093, %87) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1171 = "llvm.intr.fshl"(%1093, %1093, %88) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1172 = "llvm.lshr"(%1093, %89) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1173 = "llvm.xor"(%1171, %1172) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1174 = "llvm.xor"(%1173, %1170) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1175 = "llvm.add"(%1169, %911) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1176 = "llvm.add"(%1175, %897) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1177 = "llvm.add"(%1176, %1174) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1178 = "llvm.getelementptr"(%926) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 48>}> : (!llvm.ptr) -> !llvm.ptr
  %1179 = "llvm.load"(%1178) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %1180 = "llvm.insertelement"(%38, %1179, %2) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %1181 = "llvm.shufflevector"(%1180, %38) <{mask = array<i32: 0, 0, 0, 0>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1182 = "llvm.intr.fshl"(%1163, %1163, %62) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1183 = "llvm.intr.fshl"(%1163, %1163, %63) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1184 = "llvm.intr.fshl"(%1163, %1163, %64) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1185 = "llvm.xor"(%1183, %1184) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1186 = "llvm.xor"(%1185, %1182) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1187 = "llvm.and"(%1163, %1121) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1188 = "llvm.xor"(%1163, %65) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1189 = "llvm.and"(%1079, %1188) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1190 = "llvm.or"(%1187, %1189) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1191 = "llvm.add"(%1181, %1177) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1192 = "llvm.add"(%1191, %1037) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1193 = "llvm.add"(%1192, %1190) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1194 = "llvm.add"(%1193, %1186) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1195 = "llvm.intr.fshl"(%1164, %1164, %67) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1196 = "llvm.intr.fshl"(%1164, %1164, %68) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1197 = "llvm.intr.fshl"(%1164, %1164, %69) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1198 = "llvm.xor"(%1196, %1197) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1199 = "llvm.xor"(%1198, %1195) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1200 = "llvm.and"(%1164, %1122) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1201 = "llvm.xor"(%1164, %1122) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1202 = "llvm.and"(%1201, %1080) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1203 = "llvm.xor"(%1202, %1200) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1204 = "llvm.add"(%1199, %1203) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1205 = "llvm.add"(%1194, %1038) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1206 = "llvm.add"(%1204, %1194) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1207 = "llvm.intr.fshl"(%908, %908, %85) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1208 = "llvm.intr.fshl"(%908, %908, %86) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1209 = "llvm.lshr"(%908, %43) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1210 = "llvm.xor"(%1208, %1209) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1211 = "llvm.xor"(%1210, %1207) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1212 = "llvm.intr.fshl"(%1135, %1135, %87) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1213 = "llvm.intr.fshl"(%1135, %1135, %88) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1214 = "llvm.lshr"(%1135, %89) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1215 = "llvm.xor"(%1213, %1214) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1216 = "llvm.xor"(%1215, %1212) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1217 = "llvm.add"(%1211, %912) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1218 = "llvm.add"(%1217, %925) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1219 = "llvm.add"(%1218, %1216) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1220 = "llvm.getelementptr"(%926) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 56>}> : (!llvm.ptr) -> !llvm.ptr
  %1221 = "llvm.load"(%1220) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %1222 = "llvm.insertelement"(%38, %1221, %2) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %1223 = "llvm.shufflevector"(%1222, %38) <{mask = array<i32: 0, 0, 0, 0>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1224 = "llvm.intr.fshl"(%1205, %1205, %62) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1225 = "llvm.intr.fshl"(%1205, %1205, %63) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1226 = "llvm.intr.fshl"(%1205, %1205, %64) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1227 = "llvm.xor"(%1225, %1226) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1228 = "llvm.xor"(%1227, %1224) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1229 = "llvm.and"(%1205, %1163) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1230 = "llvm.xor"(%1205, %65) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1231 = "llvm.and"(%1121, %1230) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1232 = "llvm.or"(%1229, %1231) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1233 = "llvm.add"(%1223, %1219) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1234 = "llvm.add"(%1233, %1079) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1235 = "llvm.add"(%1234, %1232) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1236 = "llvm.add"(%1235, %1228) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1237 = "llvm.intr.fshl"(%1206, %1206, %67) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1238 = "llvm.intr.fshl"(%1206, %1206, %68) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1239 = "llvm.intr.fshl"(%1206, %1206, %69) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1240 = "llvm.xor"(%1238, %1239) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1241 = "llvm.xor"(%1240, %1237) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1242 = "llvm.and"(%1206, %1164) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1243 = "llvm.xor"(%1206, %1164) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1244 = "llvm.and"(%1243, %1122) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1245 = "llvm.xor"(%1244, %1242) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1246 = "llvm.add"(%1241, %1245) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1247 = "llvm.add"(%1236, %1080) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1248 = "llvm.add"(%1246, %1236) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1249 = "llvm.intr.fshl"(%907, %907, %85) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1250 = "llvm.intr.fshl"(%907, %907, %86) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1251 = "llvm.lshr"(%907, %43) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1252 = "llvm.xor"(%1250, %1251) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1253 = "llvm.xor"(%1252, %1249) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1254 = "llvm.intr.fshl"(%1177, %1177, %87) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1255 = "llvm.intr.fshl"(%1177, %1177, %88) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1256 = "llvm.lshr"(%1177, %89) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1257 = "llvm.xor"(%1255, %1256) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1258 = "llvm.xor"(%1257, %1254) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1259 = "llvm.add"(%1253, %908) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1260 = "llvm.add"(%1259, %967) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1261 = "llvm.add"(%1260, %1258) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1262 = "llvm.getelementptr"(%926) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %1263 = "llvm.load"(%1262) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %1264 = "llvm.insertelement"(%38, %1263, %2) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %1265 = "llvm.shufflevector"(%1264, %38) <{mask = array<i32: 0, 0, 0, 0>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1266 = "llvm.intr.fshl"(%1247, %1247, %62) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1267 = "llvm.intr.fshl"(%1247, %1247, %63) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1268 = "llvm.intr.fshl"(%1247, %1247, %64) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1269 = "llvm.xor"(%1267, %1268) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1270 = "llvm.xor"(%1269, %1266) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1271 = "llvm.and"(%1247, %1205) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1272 = "llvm.xor"(%1247, %65) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1273 = "llvm.and"(%1163, %1272) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1274 = "llvm.or"(%1271, %1273) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1275 = "llvm.add"(%1265, %1261) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1276 = "llvm.add"(%1275, %1121) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1277 = "llvm.add"(%1276, %1274) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1278 = "llvm.add"(%1277, %1270) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1279 = "llvm.intr.fshl"(%1248, %1248, %67) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1280 = "llvm.intr.fshl"(%1248, %1248, %68) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1281 = "llvm.intr.fshl"(%1248, %1248, %69) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1282 = "llvm.xor"(%1280, %1281) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1283 = "llvm.xor"(%1282, %1279) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1284 = "llvm.and"(%1248, %1206) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1285 = "llvm.xor"(%1248, %1206) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1286 = "llvm.and"(%1285, %1164) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1287 = "llvm.xor"(%1286, %1284) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1288 = "llvm.add"(%1283, %1287) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1289 = "llvm.add"(%1278, %1122) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1290 = "llvm.add"(%1288, %1278) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1291 = "llvm.intr.fshl"(%906, %906, %85) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1292 = "llvm.intr.fshl"(%906, %906, %86) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1293 = "llvm.lshr"(%906, %43) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1294 = "llvm.xor"(%1292, %1293) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1295 = "llvm.xor"(%1294, %1291) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1296 = "llvm.intr.fshl"(%1219, %1219, %87) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1297 = "llvm.intr.fshl"(%1219, %1219, %88) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1298 = "llvm.lshr"(%1219, %89) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1299 = "llvm.xor"(%1297, %1298) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1300 = "llvm.xor"(%1299, %1296) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1301 = "llvm.add"(%1295, %907) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1302 = "llvm.add"(%1301, %1009) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1303 = "llvm.add"(%1302, %1300) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1304 = "llvm.getelementptr"(%926) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 72>}> : (!llvm.ptr) -> !llvm.ptr
  %1305 = "llvm.load"(%1304) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %1306 = "llvm.insertelement"(%38, %1305, %2) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %1307 = "llvm.shufflevector"(%1306, %38) <{mask = array<i32: 0, 0, 0, 0>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1308 = "llvm.intr.fshl"(%1289, %1289, %62) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1309 = "llvm.intr.fshl"(%1289, %1289, %63) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1310 = "llvm.intr.fshl"(%1289, %1289, %64) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1311 = "llvm.xor"(%1309, %1310) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1312 = "llvm.xor"(%1311, %1308) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1313 = "llvm.and"(%1289, %1247) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1314 = "llvm.xor"(%1289, %65) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1315 = "llvm.and"(%1205, %1314) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1316 = "llvm.or"(%1313, %1315) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1317 = "llvm.add"(%1307, %1303) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1318 = "llvm.add"(%1317, %1163) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1319 = "llvm.add"(%1318, %1316) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1320 = "llvm.add"(%1319, %1312) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1321 = "llvm.intr.fshl"(%1290, %1290, %67) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1322 = "llvm.intr.fshl"(%1290, %1290, %68) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1323 = "llvm.intr.fshl"(%1290, %1290, %69) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1324 = "llvm.xor"(%1322, %1323) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1325 = "llvm.xor"(%1324, %1321) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1326 = "llvm.and"(%1290, %1248) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1327 = "llvm.xor"(%1290, %1248) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1328 = "llvm.and"(%1327, %1206) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1329 = "llvm.xor"(%1328, %1326) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1330 = "llvm.add"(%1325, %1329) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1331 = "llvm.add"(%1320, %1164) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1332 = "llvm.add"(%1330, %1320) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1333 = "llvm.intr.fshl"(%905, %905, %85) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1334 = "llvm.intr.fshl"(%905, %905, %86) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1335 = "llvm.lshr"(%905, %43) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1336 = "llvm.xor"(%1334, %1335) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1337 = "llvm.xor"(%1336, %1333) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1338 = "llvm.intr.fshl"(%1261, %1261, %87) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1339 = "llvm.intr.fshl"(%1261, %1261, %88) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1340 = "llvm.lshr"(%1261, %89) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1341 = "llvm.xor"(%1339, %1340) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1342 = "llvm.xor"(%1341, %1338) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1343 = "llvm.add"(%1337, %906) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1344 = "llvm.add"(%1343, %1051) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1345 = "llvm.add"(%1344, %1342) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1346 = "llvm.getelementptr"(%926) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 80>}> : (!llvm.ptr) -> !llvm.ptr
  %1347 = "llvm.load"(%1346) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %1348 = "llvm.insertelement"(%38, %1347, %2) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %1349 = "llvm.shufflevector"(%1348, %38) <{mask = array<i32: 0, 0, 0, 0>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1350 = "llvm.intr.fshl"(%1331, %1331, %62) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1351 = "llvm.intr.fshl"(%1331, %1331, %63) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1352 = "llvm.intr.fshl"(%1331, %1331, %64) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1353 = "llvm.xor"(%1351, %1352) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1354 = "llvm.xor"(%1353, %1350) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1355 = "llvm.and"(%1331, %1289) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1356 = "llvm.xor"(%1331, %65) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1357 = "llvm.and"(%1247, %1356) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1358 = "llvm.or"(%1355, %1357) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1359 = "llvm.add"(%1349, %1345) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1360 = "llvm.add"(%1359, %1205) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1361 = "llvm.add"(%1360, %1358) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1362 = "llvm.add"(%1361, %1354) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1363 = "llvm.intr.fshl"(%1332, %1332, %67) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1364 = "llvm.intr.fshl"(%1332, %1332, %68) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1365 = "llvm.intr.fshl"(%1332, %1332, %69) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1366 = "llvm.xor"(%1364, %1365) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1367 = "llvm.xor"(%1366, %1363) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1368 = "llvm.and"(%1332, %1290) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1369 = "llvm.xor"(%1332, %1290) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1370 = "llvm.and"(%1369, %1248) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1371 = "llvm.xor"(%1370, %1368) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1372 = "llvm.add"(%1367, %1371) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1373 = "llvm.add"(%1362, %1206) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1374 = "llvm.add"(%1372, %1362) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1375 = "llvm.intr.fshl"(%900, %900, %85) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1376 = "llvm.intr.fshl"(%900, %900, %86) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1377 = "llvm.lshr"(%900, %43) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1378 = "llvm.xor"(%1376, %1377) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1379 = "llvm.xor"(%1378, %1375) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1380 = "llvm.intr.fshl"(%1303, %1303, %87) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1381 = "llvm.intr.fshl"(%1303, %1303, %88) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1382 = "llvm.lshr"(%1303, %89) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1383 = "llvm.xor"(%1381, %1382) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1384 = "llvm.xor"(%1383, %1380) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1385 = "llvm.add"(%1379, %905) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1386 = "llvm.add"(%1385, %1093) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1387 = "llvm.add"(%1386, %1384) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1388 = "llvm.getelementptr"(%926) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 88>}> : (!llvm.ptr) -> !llvm.ptr
  %1389 = "llvm.load"(%1388) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %1390 = "llvm.insertelement"(%38, %1389, %2) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %1391 = "llvm.shufflevector"(%1390, %38) <{mask = array<i32: 0, 0, 0, 0>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1392 = "llvm.intr.fshl"(%1373, %1373, %62) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1393 = "llvm.intr.fshl"(%1373, %1373, %63) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1394 = "llvm.intr.fshl"(%1373, %1373, %64) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1395 = "llvm.xor"(%1393, %1394) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1396 = "llvm.xor"(%1395, %1392) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1397 = "llvm.and"(%1373, %1331) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1398 = "llvm.xor"(%1373, %65) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1399 = "llvm.and"(%1289, %1398) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1400 = "llvm.or"(%1397, %1399) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1401 = "llvm.add"(%1391, %1387) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1402 = "llvm.add"(%1401, %1247) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1403 = "llvm.add"(%1402, %1400) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1404 = "llvm.add"(%1403, %1396) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1405 = "llvm.intr.fshl"(%1374, %1374, %67) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1406 = "llvm.intr.fshl"(%1374, %1374, %68) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1407 = "llvm.intr.fshl"(%1374, %1374, %69) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1408 = "llvm.xor"(%1406, %1407) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1409 = "llvm.xor"(%1408, %1405) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1410 = "llvm.and"(%1374, %1332) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1411 = "llvm.xor"(%1374, %1332) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1412 = "llvm.and"(%1411, %1290) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1413 = "llvm.xor"(%1412, %1410) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1414 = "llvm.add"(%1409, %1413) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1415 = "llvm.add"(%1404, %1248) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1416 = "llvm.add"(%1414, %1404) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1417 = "llvm.intr.fshl"(%899, %899, %85) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1418 = "llvm.intr.fshl"(%899, %899, %86) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1419 = "llvm.lshr"(%899, %43) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1420 = "llvm.xor"(%1418, %1419) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1421 = "llvm.xor"(%1420, %1417) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1422 = "llvm.intr.fshl"(%1345, %1345, %87) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1423 = "llvm.intr.fshl"(%1345, %1345, %88) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1424 = "llvm.lshr"(%1345, %89) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1425 = "llvm.xor"(%1423, %1424) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1426 = "llvm.xor"(%1425, %1422) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1427 = "llvm.add"(%1421, %900) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1428 = "llvm.add"(%1427, %1135) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1429 = "llvm.add"(%1428, %1426) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1430 = "llvm.getelementptr"(%926) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 96>}> : (!llvm.ptr) -> !llvm.ptr
  %1431 = "llvm.load"(%1430) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %1432 = "llvm.insertelement"(%38, %1431, %2) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %1433 = "llvm.shufflevector"(%1432, %38) <{mask = array<i32: 0, 0, 0, 0>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1434 = "llvm.intr.fshl"(%1415, %1415, %62) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1435 = "llvm.intr.fshl"(%1415, %1415, %63) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1436 = "llvm.intr.fshl"(%1415, %1415, %64) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1437 = "llvm.xor"(%1435, %1436) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1438 = "llvm.xor"(%1437, %1434) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1439 = "llvm.and"(%1415, %1373) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1440 = "llvm.xor"(%1415, %65) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1441 = "llvm.and"(%1331, %1440) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1442 = "llvm.or"(%1439, %1441) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1443 = "llvm.add"(%1433, %1429) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1444 = "llvm.add"(%1443, %1289) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1445 = "llvm.add"(%1444, %1442) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1446 = "llvm.add"(%1445, %1438) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1447 = "llvm.intr.fshl"(%1416, %1416, %67) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1448 = "llvm.intr.fshl"(%1416, %1416, %68) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1449 = "llvm.intr.fshl"(%1416, %1416, %69) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1450 = "llvm.xor"(%1448, %1449) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1451 = "llvm.xor"(%1450, %1447) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1452 = "llvm.and"(%1416, %1374) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1453 = "llvm.xor"(%1416, %1374) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1454 = "llvm.and"(%1453, %1332) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1455 = "llvm.xor"(%1454, %1452) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1456 = "llvm.add"(%1451, %1455) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1457 = "llvm.add"(%1446, %1290) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1458 = "llvm.add"(%1456, %1446) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1459 = "llvm.intr.fshl"(%898, %898, %85) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1460 = "llvm.intr.fshl"(%898, %898, %86) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1461 = "llvm.lshr"(%898, %43) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1462 = "llvm.xor"(%1460, %1461) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1463 = "llvm.xor"(%1462, %1459) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1464 = "llvm.intr.fshl"(%1387, %1387, %87) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1465 = "llvm.intr.fshl"(%1387, %1387, %88) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1466 = "llvm.lshr"(%1387, %89) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1467 = "llvm.xor"(%1465, %1466) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1468 = "llvm.xor"(%1467, %1464) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1469 = "llvm.add"(%1463, %899) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1470 = "llvm.add"(%1469, %1177) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1471 = "llvm.add"(%1470, %1468) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1472 = "llvm.getelementptr"(%926) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 104>}> : (!llvm.ptr) -> !llvm.ptr
  %1473 = "llvm.load"(%1472) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %1474 = "llvm.insertelement"(%38, %1473, %2) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %1475 = "llvm.shufflevector"(%1474, %38) <{mask = array<i32: 0, 0, 0, 0>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1476 = "llvm.intr.fshl"(%1457, %1457, %62) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1477 = "llvm.intr.fshl"(%1457, %1457, %63) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1478 = "llvm.intr.fshl"(%1457, %1457, %64) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1479 = "llvm.xor"(%1477, %1478) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1480 = "llvm.xor"(%1479, %1476) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1481 = "llvm.and"(%1457, %1415) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1482 = "llvm.xor"(%1457, %65) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1483 = "llvm.and"(%1373, %1482) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1484 = "llvm.or"(%1481, %1483) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1485 = "llvm.add"(%1475, %1471) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1486 = "llvm.add"(%1485, %1331) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1487 = "llvm.add"(%1486, %1484) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1488 = "llvm.add"(%1487, %1480) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1489 = "llvm.intr.fshl"(%1458, %1458, %67) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1490 = "llvm.intr.fshl"(%1458, %1458, %68) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1491 = "llvm.intr.fshl"(%1458, %1458, %69) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1492 = "llvm.xor"(%1490, %1491) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1493 = "llvm.xor"(%1492, %1489) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1494 = "llvm.and"(%1458, %1416) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1495 = "llvm.xor"(%1458, %1416) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1496 = "llvm.and"(%1495, %1374) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1497 = "llvm.xor"(%1496, %1494) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1498 = "llvm.add"(%1493, %1497) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1499 = "llvm.add"(%1488, %1332) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1500 = "llvm.add"(%1498, %1488) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1501 = "llvm.intr.fshl"(%897, %897, %85) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1502 = "llvm.intr.fshl"(%897, %897, %86) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1503 = "llvm.lshr"(%897, %43) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1504 = "llvm.xor"(%1502, %1503) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1505 = "llvm.xor"(%1504, %1501) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1506 = "llvm.intr.fshl"(%1429, %1429, %87) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1507 = "llvm.intr.fshl"(%1429, %1429, %88) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1508 = "llvm.lshr"(%1429, %89) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1509 = "llvm.xor"(%1507, %1508) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1510 = "llvm.xor"(%1509, %1506) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1511 = "llvm.add"(%1505, %898) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1512 = "llvm.add"(%1511, %1219) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1513 = "llvm.add"(%1512, %1510) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1514 = "llvm.getelementptr"(%926) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 112>}> : (!llvm.ptr) -> !llvm.ptr
  %1515 = "llvm.load"(%1514) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %1516 = "llvm.insertelement"(%38, %1515, %2) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %1517 = "llvm.shufflevector"(%1516, %38) <{mask = array<i32: 0, 0, 0, 0>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1518 = "llvm.intr.fshl"(%1499, %1499, %62) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1519 = "llvm.intr.fshl"(%1499, %1499, %63) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1520 = "llvm.intr.fshl"(%1499, %1499, %64) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1521 = "llvm.xor"(%1519, %1520) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1522 = "llvm.xor"(%1521, %1518) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1523 = "llvm.and"(%1499, %1457) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1524 = "llvm.xor"(%1499, %65) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1525 = "llvm.and"(%1415, %1524) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1526 = "llvm.or"(%1523, %1525) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1527 = "llvm.add"(%1517, %1513) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1528 = "llvm.add"(%1527, %1373) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1529 = "llvm.add"(%1528, %1526) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1530 = "llvm.add"(%1529, %1522) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1531 = "llvm.intr.fshl"(%1500, %1500, %67) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1532 = "llvm.intr.fshl"(%1500, %1500, %68) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1533 = "llvm.intr.fshl"(%1500, %1500, %69) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1534 = "llvm.xor"(%1532, %1533) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1535 = "llvm.xor"(%1534, %1531) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1536 = "llvm.and"(%1500, %1458) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1537 = "llvm.xor"(%1500, %1458) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1538 = "llvm.and"(%1537, %1416) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1539 = "llvm.xor"(%1538, %1536) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1540 = "llvm.add"(%1535, %1539) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1541 = "llvm.add"(%1530, %1374) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1542 = "llvm.add"(%1540, %1530) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1543 = "llvm.intr.fshl"(%925, %925, %85) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1544 = "llvm.intr.fshl"(%925, %925, %86) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1545 = "llvm.lshr"(%925, %43) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1546 = "llvm.xor"(%1544, %1545) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1547 = "llvm.xor"(%1546, %1543) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1548 = "llvm.intr.fshl"(%1471, %1471, %87) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1549 = "llvm.intr.fshl"(%1471, %1471, %88) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1550 = "llvm.lshr"(%1471, %89) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1551 = "llvm.xor"(%1549, %1550) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1552 = "llvm.xor"(%1551, %1548) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1553 = "llvm.add"(%1547, %897) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1554 = "llvm.add"(%1553, %1261) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1555 = "llvm.add"(%1554, %1552) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1556 = "llvm.getelementptr"(%926) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 120>}> : (!llvm.ptr) -> !llvm.ptr
  %1557 = "llvm.load"(%1556) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %1558 = "llvm.insertelement"(%38, %1557, %2) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %1559 = "llvm.shufflevector"(%1558, %38) <{mask = array<i32: 0, 0, 0, 0>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1560 = "llvm.intr.fshl"(%1541, %1541, %62) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1561 = "llvm.intr.fshl"(%1541, %1541, %63) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1562 = "llvm.intr.fshl"(%1541, %1541, %64) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1563 = "llvm.xor"(%1561, %1562) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1564 = "llvm.xor"(%1563, %1560) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1565 = "llvm.and"(%1541, %1499) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1566 = "llvm.xor"(%1541, %65) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1567 = "llvm.and"(%1457, %1566) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1568 = "llvm.or"(%1565, %1567) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1569 = "llvm.add"(%1559, %1555) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1570 = "llvm.add"(%1569, %1415) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1571 = "llvm.add"(%1570, %1568) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1572 = "llvm.add"(%1571, %1564) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1573 = "llvm.intr.fshl"(%1542, %1542, %67) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1574 = "llvm.intr.fshl"(%1542, %1542, %68) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1575 = "llvm.intr.fshl"(%1542, %1542, %69) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1576 = "llvm.xor"(%1574, %1575) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1577 = "llvm.xor"(%1576, %1573) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1578 = "llvm.and"(%1542, %1500) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1579 = "llvm.xor"(%1542, %1500) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1580 = "llvm.and"(%1579, %1458) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1581 = "llvm.xor"(%1580, %1578) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1582 = "llvm.add"(%1577, %1581) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1583 = "llvm.add"(%1572, %1416) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1584 = "llvm.add"(%1582, %1572) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1585 = "llvm.add"(%888, %27) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1586 = "llvm.icmp"(%888, %10) <{predicate = 6 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1586, %1585, %1457, %1499, %1541, %1583, %1458, %1500, %1542, %1584, %1555, %1513, %1471, %1429, %925, %967, %1009, %1051, %1387, %1345, %1303, %1261, %1093, %1135, %1177, %1219)[^bb24, ^bb25] <{loop_annotation = #llvm.loop_annotation<mustProgress = true>, operandSegmentSizes = array<i32: 1, 25, 0>}> : (i1, i64, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
^bb25:  // pred: ^bb24
  %1587 = "llvm.select"(%342, %1584, %8) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<4xi1>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1588 = "llvm.add"(%1587, %343) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1589 = "llvm.select"(%342, %1542, %8) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<4xi1>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1590 = "llvm.add"(%1589, %344) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1591 = "llvm.select"(%342, %1500, %8) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<4xi1>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1592 = "llvm.add"(%1591, %345) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1593 = "llvm.select"(%342, %1458, %8) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<4xi1>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1594 = "llvm.add"(%1593, %346) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1595 = "llvm.select"(%342, %1583, %8) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<4xi1>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1596 = "llvm.add"(%1595, %347) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1597 = "llvm.select"(%342, %1541, %8) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<4xi1>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1598 = "llvm.add"(%1597, %348) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1599 = "llvm.select"(%342, %1499, %8) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<4xi1>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1600 = "llvm.add"(%1599, %349) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1601 = "llvm.select"(%342, %1457, %8) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<4xi1>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1602 = "llvm.add"(%1601, %350) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1603 = "llvm.add"(%354, %91) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1604 = "llvm.add"(%341, %352) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1605 = "llvm.icmp"(%1604, %8) <{predicate = 1 : i64}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi1>
  %1606 = "llvm.sext"(%1605) : (vector<4xi1>) -> vector<4xi64>
  %1607 = "llvm.bitcast"(%1606) : (vector<4xi64>) -> vector<8xi32>
  %1608 = "llvm.icmp"(%1607, %42) <{predicate = 2 : i64}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi1>
  %1609 = "llvm.bitcast"(%1608) : (vector<8xi1>) -> i8
  %1610 = "llvm.icmp"(%1609, %44) <{predicate = 0 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%1610, %1606, %1605, %1588, %1590, %1592, %1594, %1596, %1598, %1600, %1602, %1603, %1604)[^bb26, ^bb23] <{branch_weights = array<i32: 127, 255873>, operandSegmentSizes = array<i32: 1, 0, 12>}> : (i1, vector<4xi64>, vector<4xi1>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
^bb26:  // pred: ^bb25
  %1611 = "llvm.bitcast"(%1588) : (vector<4xi64>) -> vector<8xi32>
  %1612 = "llvm.bitcast"(%1592) : (vector<4xi64>) -> vector<8xi32>
  %1613 = "llvm.bitcast"(%1590) : (vector<4xi64>) -> vector<8xi32>
  %1614 = "llvm.bitcast"(%1594) : (vector<4xi64>) -> vector<8xi32>
  %1615 = "llvm.bitcast"(%1596) : (vector<4xi64>) -> vector<8xi32>
  %1616 = "llvm.bitcast"(%1600) : (vector<4xi64>) -> vector<8xi32>
  %1617 = "llvm.bitcast"(%1598) : (vector<4xi64>) -> vector<8xi32>
  %1618 = "llvm.bitcast"(%1602) : (vector<4xi64>) -> vector<8xi32>
  "llvm.br"(%1618, %1616, %1617, %1615, %1614, %1612, %1613, %1611)[^bb27] : (vector<8xi32>, vector<8xi32>, vector<8xi32>, vector<8xi32>, vector<8xi32>, vector<8xi32>, vector<8xi32>, vector<8xi32>) -> ()
^bb27(%1619: vector<8xi32>, %1620: vector<8xi32>, %1621: vector<8xi32>, %1622: vector<8xi32>, %1623: vector<8xi32>, %1624: vector<8xi32>, %1625: vector<8xi32>, %1626: vector<8xi32>):  // 2 preds: ^bb4, ^bb26
  %1627 = "llvm.shufflevector"(%1626, %1624) <{mask = array<i32: 0, 1, 2, 3, 8, 9, 10, 11>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1628 = "llvm.shufflevector"(%1626, %1624) <{mask = array<i32: 4, 5, 6, 7, 12, 13, 14, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1629 = "llvm.shufflevector"(%1625, %1623) <{mask = array<i32: 0, 1, 2, 3, 8, 9, 10, 11>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1630 = "llvm.shufflevector"(%1625, %1623) <{mask = array<i32: 4, 5, 6, 7, 12, 13, 14, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1631 = "llvm.shufflevector"(%1627, %1629) <{mask = array<i32: 0, 1, 8, 9, 4, 5, 12, 13>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1632 = "llvm.bitcast"(%1631) : (vector<8xi32>) -> vector<4xi64>
  %1633 = "llvm.shufflevector"(%1627, %1629) <{mask = array<i32: 2, 3, 10, 11, 6, 7, 14, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1634 = "llvm.bitcast"(%1633) : (vector<8xi32>) -> vector<4xi64>
  %1635 = "llvm.shufflevector"(%1628, %1630) <{mask = array<i32: 0, 1, 8, 9, 4, 5, 12, 13>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1636 = "llvm.bitcast"(%1635) : (vector<8xi32>) -> vector<4xi64>
  %1637 = "llvm.shufflevector"(%1622, %1620) <{mask = array<i32: 0, 1, 2, 3, 8, 9, 10, 11>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1638 = "llvm.shufflevector"(%1622, %1620) <{mask = array<i32: 4, 5, 6, 7, 12, 13, 14, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1639 = "llvm.shufflevector"(%1621, %1619) <{mask = array<i32: 0, 1, 2, 3, 8, 9, 10, 11>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1640 = "llvm.shufflevector"(%1621, %1619) <{mask = array<i32: 4, 5, 6, 7, 12, 13, 14, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1641 = "llvm.shufflevector"(%1637, %1639) <{mask = array<i32: 0, 1, 8, 9, 4, 5, 12, 13>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1642 = "llvm.bitcast"(%1641) : (vector<8xi32>) -> vector<4xi64>
  %1643 = "llvm.shufflevector"(%1637, %1639) <{mask = array<i32: 2, 3, 10, 11, 6, 7, 14, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1644 = "llvm.bitcast"(%1643) : (vector<8xi32>) -> vector<4xi64>
  %1645 = "llvm.shufflevector"(%1638, %1640) <{mask = array<i32: 0, 1, 8, 9, 4, 5, 12, 13>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1646 = "llvm.bitcast"(%1645) : (vector<8xi32>) -> vector<4xi64>
  "llvm.switch"(%arg0)[^bb31, ^bb28, ^bb29, ^bb30] <{case_operand_segments = array<i32: 0, 0, 0>, case_values = dense<[4, 3, 2]> : vector<3xi64>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i64) -> ()
^bb28:  // pred: ^bb27
  %1647 = "llvm.shufflevector"(%1638, %1640) <{mask = array<i32: 2, 3, 10, 11, 6, 7, 14, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1648 = "llvm.bitcast"(%1647) : (vector<8xi32>) -> vector<4xi64>
  %1649 = "llvm.shufflevector"(%1628, %1630) <{mask = array<i32: 2, 3, 10, 11, 6, 7, 14, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1650 = "llvm.bitcast"(%1649) : (vector<8xi32>) -> vector<4xi64>
  %1651 = "llvm.getelementptr"(%arg3) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %1652 = "llvm.load"(%1651) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> !llvm.ptr
  %1653 = "llvm.intr.fshl"(%1650, %1650, %61) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1654 = "llvm.bitcast"(%1653) : (vector<4xi64>) -> vector<32xi8>
  %1655 = "llvm.shufflevector"(%1654, %92) <{mask = array<i32: 3, 2, 1, 0, 7, 6, 5, 4, 11, 10, 9, 8, 15, 14, 13, 12, 19, 18, 17, 16, 23, 22, 21, 20, 27, 26, 25, 24, 31, 30, 29, 28>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  "llvm.store"(%1655, %1652) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<32xi8>, !llvm.ptr) -> ()
  %1656 = "llvm.load"(%1651) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> !llvm.ptr
  %1657 = "llvm.getelementptr"(%1656) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %1658 = "llvm.intr.fshl"(%1648, %1648, %61) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1659 = "llvm.bitcast"(%1658) : (vector<4xi64>) -> vector<32xi8>
  %1660 = "llvm.shufflevector"(%1659, %92) <{mask = array<i32: 3, 2, 1, 0, 7, 6, 5, 4, 11, 10, 9, 8, 15, 14, 13, 12, 19, 18, 17, 16, 23, 22, 21, 20, 27, 26, 25, 24, 31, 30, 29, 28>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  "llvm.store"(%1660, %1657) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<32xi8>, !llvm.ptr) -> ()
  "llvm.br"()[^bb29] : () -> ()
^bb29:  // 2 preds: ^bb27, ^bb28
  %1661 = "llvm.getelementptr"(%arg3) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %1662 = "llvm.load"(%1661) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> !llvm.ptr
  %1663 = "llvm.intr.fshl"(%1636, %1636, %61) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1664 = "llvm.bitcast"(%1663) : (vector<4xi64>) -> vector<32xi8>
  %1665 = "llvm.shufflevector"(%1664, %92) <{mask = array<i32: 3, 2, 1, 0, 7, 6, 5, 4, 11, 10, 9, 8, 15, 14, 13, 12, 19, 18, 17, 16, 23, 22, 21, 20, 27, 26, 25, 24, 31, 30, 29, 28>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  "llvm.store"(%1665, %1662) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<32xi8>, !llvm.ptr) -> ()
  %1666 = "llvm.load"(%1661) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> !llvm.ptr
  %1667 = "llvm.getelementptr"(%1666) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %1668 = "llvm.intr.fshl"(%1646, %1646, %61) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1669 = "llvm.bitcast"(%1668) : (vector<4xi64>) -> vector<32xi8>
  %1670 = "llvm.shufflevector"(%1669, %92) <{mask = array<i32: 3, 2, 1, 0, 7, 6, 5, 4, 11, 10, 9, 8, 15, 14, 13, 12, 19, 18, 17, 16, 23, 22, 21, 20, 27, 26, 25, 24, 31, 30, 29, 28>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  "llvm.store"(%1670, %1667) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<32xi8>, !llvm.ptr) -> ()
  "llvm.br"()[^bb30] : () -> ()
^bb30:  // 2 preds: ^bb27, ^bb29
  %1671 = "llvm.getelementptr"(%arg3) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %1672 = "llvm.load"(%1671) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> !llvm.ptr
  %1673 = "llvm.intr.fshl"(%1634, %1634, %61) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1674 = "llvm.bitcast"(%1673) : (vector<4xi64>) -> vector<32xi8>
  %1675 = "llvm.shufflevector"(%1674, %92) <{mask = array<i32: 3, 2, 1, 0, 7, 6, 5, 4, 11, 10, 9, 8, 15, 14, 13, 12, 19, 18, 17, 16, 23, 22, 21, 20, 27, 26, 25, 24, 31, 30, 29, 28>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  "llvm.store"(%1675, %1672) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<32xi8>, !llvm.ptr) -> ()
  %1676 = "llvm.load"(%1671) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> !llvm.ptr
  %1677 = "llvm.getelementptr"(%1676) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %1678 = "llvm.intr.fshl"(%1644, %1644, %61) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1679 = "llvm.bitcast"(%1678) : (vector<4xi64>) -> vector<32xi8>
  %1680 = "llvm.shufflevector"(%1679, %92) <{mask = array<i32: 3, 2, 1, 0, 7, 6, 5, 4, 11, 10, 9, 8, 15, 14, 13, 12, 19, 18, 17, 16, 23, 22, 21, 20, 27, 26, 25, 24, 31, 30, 29, 28>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  "llvm.store"(%1680, %1677) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<32xi8>, !llvm.ptr) -> ()
  %1681 = "llvm.load"(%arg3) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> !llvm.ptr
  %1682 = "llvm.intr.fshl"(%1632, %1632, %61) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1683 = "llvm.bitcast"(%1682) : (vector<4xi64>) -> vector<32xi8>
  %1684 = "llvm.shufflevector"(%1683, %92) <{mask = array<i32: 3, 2, 1, 0, 7, 6, 5, 4, 11, 10, 9, 8, 15, 14, 13, 12, 19, 18, 17, 16, 23, 22, 21, 20, 27, 26, 25, 24, 31, 30, 29, 28>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  "llvm.store"(%1684, %1681) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<32xi8>, !llvm.ptr) -> ()
  %1685 = "llvm.load"(%arg3) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> !llvm.ptr
  %1686 = "llvm.getelementptr"(%1685) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %1687 = "llvm.intr.fshl"(%1642, %1642, %61) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1688 = "llvm.bitcast"(%1687) : (vector<4xi64>) -> vector<32xi8>
  %1689 = "llvm.shufflevector"(%1688, %92) <{mask = array<i32: 3, 2, 1, 0, 7, 6, 5, 4, 11, 10, 9, 8, 15, 14, 13, 12, 19, 18, 17, 16, 23, 22, 21, 20, 27, 26, 25, 24, 31, 30, 29, 28>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  "llvm.store"(%1689, %1686) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<32xi8>, !llvm.ptr) -> ()
  "llvm.br"()[^bb31] : () -> ()
^bb31:  // 2 preds: ^bb27, ^bb30
  "llvm.intr.lifetime.end"(%95) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%94) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%93) : (!llvm.ptr) -> ()
  "llvm.br"()[^bb32] : () -> ()
^bb32:  // 3 preds: ^bb1, ^bb2, ^bb31
  "llvm.return"() : () -> ()
}) : () -> ()

    with
      @fd_sha512_private_batch_avx.K := Firedancer.Lane.Mlir.fd_sha512_private_batch_avx_K,
      @fd_sha512_hash := Firedancer.Lane.Mlir.fd_sha512_hash

end

end Firedancer.Lane.Mlir
