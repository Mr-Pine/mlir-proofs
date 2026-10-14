
module

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

public import Firedancer.Lane.Mlir.fd_sha512_private_batch_avx512_K
public import Firedancer.Lane.Mlir.fd_sha512_private_batch_avx

namespace Firedancer.Lane.Mlir

@[expose] public section

mlir_def fd_sha512_private_batch_avx512 := "llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<void (i64, ptr, ptr, ptr)>, linkage = #llvm.linkage<external>, no_unwind, passthrough = ["sspstrong", ["min-legal-vector-width", "512"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "znver4"]], sym_name = "fd_sha512_private_batch_avx512", target_cpu = "znver4", target_features = #llvm.target_features<["+64bit", "+adx", "+aes", "+avx", "+avx2", "+avx512bf16", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+clzero", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fast-vector-fsqrt", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+mwaitx", "+pclmul", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdpru", "+rdrnd", "+rdseed", "+sahf", "+sha", "+shstk", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+sse4a", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tile", "-avx10.1", "-avx10.2", "-avx512bmm", "-avx512fp16", "-avx512vp2intersect", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-ccmp", "-cf", "-cldemote", "-cmpccxadd", "-egpr", "-enqcmd", "-fma4", "-hreset", "-jmpabs", "-kl", "-lwp", "-movdir64b", "-movdiri", "-movrs", "-ndd", "-nf", "-pconfig", "-ppx", "-prefetchi", "-ptwrite", "-push2pop2", "-raoint", "-rtm", "-serialize", "-sgx", "-sha512", "-sm3", "-sm4", "-tbm", "-tsxldtrk", "-uintr", "-usermsr", "-waitpkg", "-widekl", "-xop", "-zu"]>, tune_cpu = "znver4", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg0: i64, %arg1: !llvm.ptr, %arg2: !llvm.ptr, %arg3: !llvm.ptr):
  %0 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %1 = "llvm.mlir.constant"() <{value = 5 : i64}> : () -> i64
  %2 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %3 = "llvm.mlir.constant"() <{value = 127 : i64}> : () -> i64
  %4 = "llvm.mlir.constant"() <{value = -128 : i64}> : () -> i64
  %5 = "llvm.mlir.constant"() <{value = 144 : i64}> : () -> i64
  %6 = "llvm.mlir.constant"() <{value = 384 : i64}> : () -> i64
  %7 = "llvm.mlir.constant"() <{value = 7 : i64}> : () -> i64
  %8 = "llvm.mlir.constant"() <{value = dense<0> : vector<8xi64>}> : () -> vector<8xi64>
  %9 = "llvm.mlir.constant"() <{value = 64 : i64}> : () -> i64
  %10 = "llvm.mlir.constant"() <{value = 128 : i64}> : () -> i64
  %11 = "llvm.mlir.constant"() <{value = 192 : i64}> : () -> i64
  %12 = "llvm.mlir.constant"() <{value = 63 : i64}> : () -> i64
  %13 = "llvm.mlir.constant"() <{value = -64 : i64}> : () -> i64
  %14 = "llvm.mlir.constant"() <{value = -8 : i64}> : () -> i64
  %15 = "llvm.mlir.constant"() <{value = 3 : i64}> : () -> i64
  %16 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %17 = "llvm.mlir.poison"() : () -> i64
  %18 = "llvm.mlir.constant"() <{value = 8 : i64}> : () -> i64
  %19 = "llvm.mlir.constant"() <{value = 56 : i64}> : () -> i64
  %20 = "llvm.mlir.constant"() <{value = 16 : i64}> : () -> i64
  %21 = "llvm.mlir.constant"() <{value = 24 : i64}> : () -> i64
  %22 = "llvm.mlir.constant"() <{value = 32 : i64}> : () -> i64
  %23 = "llvm.mlir.constant"() <{value = 40 : i64}> : () -> i64
  %24 = "llvm.mlir.constant"() <{value = 48 : i64}> : () -> i64
  %25 = "llvm.mlir.constant"() <{value = 4 : i64}> : () -> i64
  %26 = "llvm.mlir.constant"() <{value = -4 : i64}> : () -> i64
  %27 = "llvm.mlir.constant"() <{value = 2 : i64}> : () -> i64
  %28 = "llvm.mlir.constant"() <{value = -2 : i64}> : () -> i64
  %29 = "llvm.mlir.constant"() <{value = -128 : i8}> : () -> i8
  %30 = "llvm.mlir.constant"() <{value = 504403158265495552 : i64}> : () -> i64
  %31 = "llvm.mlir.constant"() <{value = -16 : i64}> : () -> i64
  %32 = "llvm.mlir.poison"() : () -> vector<8xi64>
  %33 = "llvm.mlir.constant"() <{value = -1 : i32}> : () -> i32
  %34 = "llvm.mlir.constant"() <{value = -1 : i8}> : () -> i8
  %35 = "llvm.mlir.constant"() <{value = dense<7> : vector<8xi64>}> : () -> vector<8xi64>
  %36 = "llvm.mlir.constant"() <{value = 0 : i8}> : () -> i8
  %37 = "llvm.mlir.constant"() <{value = dense<6620516959819538809> : vector<8xi64>}> : () -> vector<8xi64>
  %38 = "llvm.mlir.constant"() <{value = dense<2270897969802886507> : vector<8xi64>}> : () -> vector<8xi64>
  %39 = "llvm.mlir.constant"() <{value = dense<-7276294671716946913> : vector<8xi64>}> : () -> vector<8xi64>
  %40 = "llvm.mlir.constant"() <{value = dense<5840696475078001361> : vector<8xi64>}> : () -> vector<8xi64>
  %41 = "llvm.mlir.constant"() <{value = dense<-6534734903238641935> : vector<8xi64>}> : () -> vector<8xi64>
  %42 = "llvm.mlir.constant"() <{value = dense<4354685564936845355> : vector<8xi64>}> : () -> vector<8xi64>
  %43 = "llvm.mlir.constant"() <{value = dense<-4942790177534073029> : vector<8xi64>}> : () -> vector<8xi64>
  %44 = "llvm.mlir.constant"() <{value = dense<7640891576956012808> : vector<8xi64>}> : () -> vector<8xi64>
  %45 = "llvm.mlir.constant"() <{value = 6 : i64}> : () -> i64
  %46 = "llvm.mlir.constant"() <{value = dense<50> : vector<8xi64>}> : () -> vector<8xi64>
  %47 = "llvm.mlir.constant"() <{value = dense<46> : vector<8xi64>}> : () -> vector<8xi64>
  %48 = "llvm.mlir.constant"() <{value = dense<23> : vector<8xi64>}> : () -> vector<8xi64>
  %49 = "llvm.mlir.constant"() <{value = dense<-1> : vector<8xi64>}> : () -> vector<8xi64>
  %50 = "llvm.mlir.constant"() <{value = dense<4794697086780616226> : vector<8xi64>}> : () -> vector<8xi64>
  %51 = "llvm.mlir.constant"() <{value = dense<36> : vector<8xi64>}> : () -> vector<8xi64>
  %52 = "llvm.mlir.constant"() <{value = dense<30> : vector<8xi64>}> : () -> vector<8xi64>
  %53 = "llvm.mlir.constant"() <{value = dense<25> : vector<8xi64>}> : () -> vector<8xi64>
  %54 = "llvm.mlir.constant"() <{value = dense<8158064640168781261> : vector<8xi64>}> : () -> vector<8xi64>
  %55 = "llvm.mlir.constant"() <{value = dense<-5349999486874862801> : vector<8xi64>}> : () -> vector<8xi64>
  %56 = "llvm.mlir.constant"() <{value = dense<-1606136188198331460> : vector<8xi64>}> : () -> vector<8xi64>
  %57 = "llvm.mlir.constant"() <{value = dense<4131703408338449720> : vector<8xi64>}> : () -> vector<8xi64>
  %58 = "llvm.mlir.constant"() <{value = dense<6480981068601479193> : vector<8xi64>}> : () -> vector<8xi64>
  %59 = "llvm.mlir.constant"() <{value = dense<-7908458776815382629> : vector<8xi64>}> : () -> vector<8xi64>
  %60 = "llvm.mlir.constant"() <{value = dense<-6116909921290321640> : vector<8xi64>}> : () -> vector<8xi64>
  %61 = "llvm.mlir.constant"() <{value = dense<-2880145864133508542> : vector<8xi64>}> : () -> vector<8xi64>
  %62 = "llvm.mlir.constant"() <{value = dense<1334009975649890238> : vector<8xi64>}> : () -> vector<8xi64>
  %63 = "llvm.mlir.constant"() <{value = dense<2608012711638119052> : vector<8xi64>}> : () -> vector<8xi64>
  %64 = "llvm.mlir.constant"() <{value = dense<6128411473006802146> : vector<8xi64>}> : () -> vector<8xi64>
  %65 = "llvm.mlir.constant"() <{value = dense<8268148722764581231> : vector<8xi64>}> : () -> vector<8xi64>
  %66 = "llvm.mlir.constant"() <{value = dense<-9160688886553864527> : vector<8xi64>}> : () -> vector<8xi64>
  %67 = "llvm.mlir.constant"() <{value = dense<-7215885187991268811> : vector<8xi64>}> : () -> vector<8xi64>
  %68 = "llvm.mlir.constant"() <{value = dense<-4495734319001033068> : vector<8xi64>}> : () -> vector<8xi64>
  %69 = "llvm.mlir.constant"() <{value = dense<63> : vector<8xi64>}> : () -> vector<8xi64>
  %70 = "llvm.mlir.constant"() <{value = dense<56> : vector<8xi64>}> : () -> vector<8xi64>
  %71 = "llvm.mlir.constant"() <{value = dense<45> : vector<8xi64>}> : () -> vector<8xi64>
  %72 = "llvm.mlir.constant"() <{value = dense<3> : vector<8xi64>}> : () -> vector<8xi64>
  %73 = "llvm.mlir.constant"() <{value = dense<6> : vector<8xi64>}> : () -> vector<8xi64>
  %74 = "llvm.mlir.addressof"() <{global_name = @fd_sha512_private_batch_avx512.K}> : () -> !llvm.ptr
  %75 = "llvm.mlir.constant"() <{value = dense<128> : vector<8xi64>}> : () -> vector<8xi64>
  %76 = "llvm.mlir.constant"() <{value = dense<1> : vector<8xi64>}> : () -> vector<8xi64>
  %77 = "llvm.mlir.poison"() : () -> vector<64xi8>
  %78 = "llvm.alloca"(%0) <{alignment = 64 : i64, elem_type = !llvm.array<8 x i64>}> : (i32) -> !llvm.ptr
  %79 = "llvm.alloca"(%0) <{alignment = 64 : i64, elem_type = !llvm.array<8 x i64>}> : (i32) -> !llvm.ptr
  %80 = "llvm.alloca"(%0) <{alignment = 128 : i64, elem_type = !llvm.array<2048 x i8>}> : (i32) -> !llvm.ptr
  %81 = "llvm.icmp"(%arg0, %1) <{predicate = 6 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%81)[^bb1, ^bb2] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb1:  // pred: ^bb0
  "llvm.call"(%arg0, %arg1, %arg2, %arg3) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_sha512_private_batch_avx, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (i64, !llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.br"()[^bb28] : () -> ()
^bb2:  // pred: ^bb0
  "llvm.intr.lifetime.start"(%78) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%79) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%80) : (!llvm.ptr) -> ()
  %82 = "llvm.ptrtoint"(%80) : (!llvm.ptr) -> i64
  "llvm.br"(%82, %2)[^bb5] : (i64, i64) -> ()
^bb3:  // pred: ^bb18
  %83 = "llvm.insertelement"(%32, %82, %2) : (vector<8xi64>, i64, i64) -> vector<8xi64>
  %84 = "llvm.shufflevector"(%83, %32) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %85 = "llvm.load"(%78) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %86 = "llvm.load"(%79) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %87 = "llvm.trunc"(%arg0) <{overflowFlags = 0 : i32}> : (i64) -> i32
  %88 = "llvm.shl"(%33, %87) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %89 = "llvm.trunc"(%88) <{overflowFlags = 0 : i32}> : (i32) -> i8
  %90 = "llvm.xor"(%89, %34) : (i8, i8) -> i8
  %91 = "llvm.load"(%arg2) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %92 = "llvm.lshr"(%91, %35) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %93 = "llvm.add"(%92, %86) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %94 = "llvm.bitcast"(%90) : (i8) -> vector<8xi1>
  %95 = "llvm.select"(%94, %93, %8) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %96 = "llvm.icmp"(%95, %8) <{predicate = 1 : i64}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi1>
  %97 = "llvm.bitcast"(%96) : (vector<8xi1>) -> i8
  %98 = "llvm.icmp"(%97, %36) <{predicate = 0 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%98, %37, %38, %39, %40, %41, %42, %43, %44)[^bb22, ^bb4] <{branch_weights = array<i32: 1, 127>, operandSegmentSizes = array<i32: 1, 8, 0>}> : (i1, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>) -> ()
^bb4:  // pred: ^bb3
  %99 = "llvm.load"(%arg1) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  "llvm.br"(%96, %44, %43, %42, %41, %40, %39, %38, %37, %99, %95)[^bb19] : (vector<8xi1>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>) -> ()
^bb5(%100: i64, %101: i64):  // 2 preds: ^bb2, ^bb18
  %102 = "llvm.getelementptr"(%arg1, %101) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %103 = "llvm.load"(%102) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %104 = "llvm.getelementptr"(%arg2, %101) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %105 = "llvm.load"(%104) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %106 = "llvm.and"(%105, %3) : (i64, i64) -> i64
  %107 = "llvm.and"(%105, %4) : (i64, i64) -> i64
  %108 = "llvm.add"(%106, %5) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %109 = "llvm.and"(%108, %6) : (i64, i64) -> i64
  %110 = "llvm.getelementptr"(%78, %101) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%100, %110) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %111 = "llvm.lshr"(%108, %7) : (i64, i64) -> i64
  %112 = "llvm.getelementptr"(%79, %101) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%111, %112) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %113 = "llvm.add"(%109, %100) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %114 = "llvm.inttoptr"(%100) : (i64) -> !llvm.ptr
  "llvm.store"(%8, %114) <{alignment = 128 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %115 = "llvm.or"(%100, %9) <{isDisjoint}> : (i64, i64) -> i64
  %116 = "llvm.inttoptr"(%115) : (i64) -> !llvm.ptr
  "llvm.store"(%8, %116) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %117 = "llvm.add"(%100, %10) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %118 = "llvm.inttoptr"(%117) : (i64) -> !llvm.ptr
  "llvm.store"(%8, %118) <{alignment = 128 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %119 = "llvm.add"(%100, %11) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %120 = "llvm.inttoptr"(%119) : (i64) -> !llvm.ptr
  "llvm.store"(%8, %120) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %121 = "llvm.add"(%107, %103) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %122 = "llvm.icmp"(%106, %12) <{predicate = 8 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%122, %106, %100, %121)[^bb6, ^bb7] <{operandSegmentSizes = array<i32: 1, 0, 3>}> : (i1, i64, i64, i64) -> ()
^bb6:  // pred: ^bb5
  %123 = "llvm.inttoptr"(%100) : (i64) -> !llvm.ptr
  %124 = "llvm.inttoptr"(%121) : (i64) -> !llvm.ptr
  %125 = "llvm.load"(%124) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  "llvm.store"(%125, %123) <{alignment = 128 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %126 = "llvm.add"(%106, %13) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %127 = "llvm.add"(%121, %9) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %128 = "llvm.or"(%100, %9) <{isDisjoint}> : (i64, i64) -> i64
  "llvm.br"(%126, %128, %127)[^bb7] : (i64, i64, i64) -> ()
^bb7(%129: i64, %130: i64, %131: i64):  // 2 preds: ^bb5, ^bb6
  %132 = "llvm.icmp"(%129, %7) <{predicate = 8 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%132, %129, %130, %131)[^bb8, ^bb12] <{operandSegmentSizes = array<i32: 1, 0, 3>}> : (i1, i64, i64, i64) -> ()
^bb8:  // pred: ^bb7
  %133 = "llvm.add"(%129, %14) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %134 = "llvm.lshr"(%133, %15) : (i64, i64) -> i64
  %135 = "llvm.add"(%134, %16) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %136 = "llvm.and"(%135, %7) : (i64, i64) -> i64
  %137 = "llvm.icmp"(%136, %2) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%137, %131, %130, %129, %17, %17, %17, %131, %130, %129, %2)[^bb10, ^bb9] <{operandSegmentSizes = array<i32: 1, 6, 4>}> : (i1, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64) -> ()
^bb9(%138: i64, %139: i64, %140: i64, %141: i64):  // 2 preds: ^bb8, ^bb9
  %142 = "llvm.inttoptr"(%138) : (i64) -> !llvm.ptr
  %143 = "llvm.load"(%142) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %144 = "llvm.inttoptr"(%139) : (i64) -> !llvm.ptr
  "llvm.store"(%143, %144) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %145 = "llvm.add"(%139, %18) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %146 = "llvm.add"(%138, %18) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %147 = "llvm.add"(%140, %14) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %148 = "llvm.add"(%141, %16) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %149 = "llvm.icmp"(%148, %136) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%149, %146, %145, %147, %145, %146, %147, %146, %145, %147, %148)[^bb10, ^bb9] <{loop_annotation = #llvm.loop_annotation<unroll = <disable = true>>, operandSegmentSizes = array<i32: 1, 6, 4>}> : (i1, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64) -> ()
^bb10(%150: i64, %151: i64, %152: i64, %153: i64, %154: i64, %155: i64):  // 2 preds: ^bb8, ^bb9
  %156 = "llvm.icmp"(%133, %19) <{predicate = 6 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%156, %155, %153, %154, %150, %151, %152)[^bb12, ^bb11] <{operandSegmentSizes = array<i32: 1, 3, 3>}> : (i1, i64, i64, i64, i64, i64, i64) -> ()
^bb11(%157: i64, %158: i64, %159: i64):  // 2 preds: ^bb10, ^bb11
  %160 = "llvm.inttoptr"(%157) : (i64) -> !llvm.ptr
  %161 = "llvm.load"(%160) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %162 = "llvm.inttoptr"(%158) : (i64) -> !llvm.ptr
  "llvm.store"(%161, %162) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %163 = "llvm.add"(%158, %18) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %164 = "llvm.add"(%157, %18) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %165 = "llvm.inttoptr"(%164) : (i64) -> !llvm.ptr
  %166 = "llvm.load"(%165) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %167 = "llvm.inttoptr"(%163) : (i64) -> !llvm.ptr
  "llvm.store"(%166, %167) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %168 = "llvm.add"(%158, %20) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %169 = "llvm.add"(%157, %20) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %170 = "llvm.inttoptr"(%169) : (i64) -> !llvm.ptr
  %171 = "llvm.load"(%170) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %172 = "llvm.inttoptr"(%168) : (i64) -> !llvm.ptr
  "llvm.store"(%171, %172) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %173 = "llvm.add"(%158, %21) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %174 = "llvm.add"(%157, %21) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %175 = "llvm.inttoptr"(%174) : (i64) -> !llvm.ptr
  %176 = "llvm.load"(%175) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %177 = "llvm.inttoptr"(%173) : (i64) -> !llvm.ptr
  "llvm.store"(%176, %177) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %178 = "llvm.add"(%158, %22) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %179 = "llvm.add"(%157, %22) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %180 = "llvm.inttoptr"(%179) : (i64) -> !llvm.ptr
  %181 = "llvm.load"(%180) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %182 = "llvm.inttoptr"(%178) : (i64) -> !llvm.ptr
  "llvm.store"(%181, %182) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %183 = "llvm.add"(%158, %23) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %184 = "llvm.add"(%157, %23) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %185 = "llvm.inttoptr"(%184) : (i64) -> !llvm.ptr
  %186 = "llvm.load"(%185) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %187 = "llvm.inttoptr"(%183) : (i64) -> !llvm.ptr
  "llvm.store"(%186, %187) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %188 = "llvm.add"(%158, %24) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %189 = "llvm.add"(%157, %24) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %190 = "llvm.inttoptr"(%189) : (i64) -> !llvm.ptr
  %191 = "llvm.load"(%190) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %192 = "llvm.inttoptr"(%188) : (i64) -> !llvm.ptr
  "llvm.store"(%191, %192) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %193 = "llvm.add"(%158, %19) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %194 = "llvm.add"(%157, %19) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %195 = "llvm.inttoptr"(%194) : (i64) -> !llvm.ptr
  %196 = "llvm.load"(%195) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %197 = "llvm.inttoptr"(%193) : (i64) -> !llvm.ptr
  "llvm.store"(%196, %197) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %198 = "llvm.add"(%158, %9) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %199 = "llvm.add"(%157, %9) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %200 = "llvm.add"(%159, %13) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %201 = "llvm.icmp"(%200, %7) <{predicate = 8 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%201, %199, %198, %200, %200, %198, %199)[^bb11, ^bb12] <{loop_annotation = #llvm.loop_annotation<mustProgress = true>, operandSegmentSizes = array<i32: 1, 3, 3>}> : (i1, i64, i64, i64, i64, i64, i64) -> ()
^bb12(%202: i64, %203: i64, %204: i64):  // 3 preds: ^bb7, ^bb10, ^bb11
  %205 = "llvm.icmp"(%202, %15) <{predicate = 8 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%205, %202, %203, %204)[^bb13, ^bb14] <{operandSegmentSizes = array<i32: 1, 0, 3>}> : (i1, i64, i64, i64) -> ()
^bb13:  // pred: ^bb12
  %206 = "llvm.inttoptr"(%204) : (i64) -> !llvm.ptr
  %207 = "llvm.load"(%206) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i32
  %208 = "llvm.inttoptr"(%203) : (i64) -> !llvm.ptr
  "llvm.store"(%207, %208) <{alignment = 4 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i32, !llvm.ptr) -> ()
  %209 = "llvm.or"(%203, %25) <{isDisjoint}> : (i64, i64) -> i64
  %210 = "llvm.add"(%204, %25) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %211 = "llvm.add"(%202, %26) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  "llvm.br"(%211, %209, %210)[^bb14] : (i64, i64, i64) -> ()
^bb14(%212: i64, %213: i64, %214: i64):  // 2 preds: ^bb12, ^bb13
  %215 = "llvm.icmp"(%212, %16) <{predicate = 8 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%215, %212, %213, %214)[^bb15, ^bb16] <{operandSegmentSizes = array<i32: 1, 0, 3>}> : (i1, i64, i64, i64) -> ()
^bb15:  // pred: ^bb14
  %216 = "llvm.inttoptr"(%214) : (i64) -> !llvm.ptr
  %217 = "llvm.load"(%216) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i16
  %218 = "llvm.inttoptr"(%213) : (i64) -> !llvm.ptr
  "llvm.store"(%217, %218) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i16, !llvm.ptr) -> ()
  %219 = "llvm.add"(%213, %27) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %220 = "llvm.add"(%214, %27) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %221 = "llvm.add"(%212, %28) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  "llvm.br"(%221, %219, %220)[^bb16] : (i64, i64, i64) -> ()
^bb16(%222: i64, %223: i64, %224: i64):  // 2 preds: ^bb14, ^bb15
  %225 = "llvm.icmp"(%222, %2) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%225, %223)[^bb18, ^bb17] <{operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i64) -> ()
^bb17:  // pred: ^bb16
  %226 = "llvm.inttoptr"(%224) : (i64) -> !llvm.ptr
  %227 = "llvm.load"(%226) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %228 = "llvm.inttoptr"(%223) : (i64) -> !llvm.ptr
  "llvm.store"(%227, %228) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (i8, !llvm.ptr) -> ()
  %229 = "llvm.add"(%223, %16) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  "llvm.br"(%229)[^bb18] : (i64) -> ()
^bb18(%230: i64):  // 2 preds: ^bb16, ^bb17
  %231 = "llvm.inttoptr"(%230) : (i64) -> !llvm.ptr
  "llvm.store"(%29, %231) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (i8, !llvm.ptr) -> ()
  %232 = "llvm.lshr"(%105, %1) : (i64, i64) -> i64
  %233 = "llvm.and"(%232, %30) : (i64, i64) -> i64
  %234 = "llvm.add"(%113, %31) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %235 = "llvm.inttoptr"(%234) : (i64) -> !llvm.ptr
  "llvm.store"(%233, %235) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %236 = "llvm.shl"(%105, %15) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %237 = "llvm.intr.bswap"(%236) : (i64) -> i64
  %238 = "llvm.add"(%113, %14) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %239 = "llvm.inttoptr"(%238) : (i64) -> !llvm.ptr
  "llvm.store"(%237, %239) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %240 = "llvm.add"(%101, %16) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %241 = "llvm.icmp"(%240, %arg0) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%241, %113, %240)[^bb3, ^bb5] <{loop_annotation = #llvm.loop_annotation<mustProgress = true>, operandSegmentSizes = array<i32: 1, 0, 2>}> : (i1, i64, i64) -> ()
^bb19(%242: vector<8xi1>, %243: vector<8xi64>, %244: vector<8xi64>, %245: vector<8xi64>, %246: vector<8xi64>, %247: vector<8xi64>, %248: vector<8xi64>, %249: vector<8xi64>, %250: vector<8xi64>, %251: vector<8xi64>, %252: vector<8xi64>):  // 2 preds: ^bb4, ^bb21
  %253 = "llvm.icmp"(%252, %86) <{predicate = 0 : i64}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi1>
  %254 = "llvm.select"(%253, %85, %251) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %255 = "llvm.select"(%242, %254, %84) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %256 = "llvm.extractelement"(%255, %2) : (vector<8xi64>, i64) -> i64
  %257 = "llvm.extractelement"(%255, %16) : (vector<8xi64>, i64) -> i64
  %258 = "llvm.extractelement"(%255, %27) : (vector<8xi64>, i64) -> i64
  %259 = "llvm.extractelement"(%255, %15) : (vector<8xi64>, i64) -> i64
  %260 = "llvm.extractelement"(%255, %25) : (vector<8xi64>, i64) -> i64
  %261 = "llvm.extractelement"(%255, %1) : (vector<8xi64>, i64) -> i64
  %262 = "llvm.extractelement"(%255, %45) : (vector<8xi64>, i64) -> i64
  %263 = "llvm.extractelement"(%255, %7) : (vector<8xi64>, i64) -> i64
  %264 = "llvm.inttoptr"(%256) : (i64) -> !llvm.ptr
  %265 = "llvm.inttoptr"(%257) : (i64) -> !llvm.ptr
  %266 = "llvm.inttoptr"(%258) : (i64) -> !llvm.ptr
  %267 = "llvm.inttoptr"(%259) : (i64) -> !llvm.ptr
  %268 = "llvm.inttoptr"(%260) : (i64) -> !llvm.ptr
  %269 = "llvm.inttoptr"(%261) : (i64) -> !llvm.ptr
  %270 = "llvm.inttoptr"(%262) : (i64) -> !llvm.ptr
  %271 = "llvm.inttoptr"(%263) : (i64) -> !llvm.ptr
  %272 = "llvm.load"(%264) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<64xi8>
  %273 = "llvm.load"(%265) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<64xi8>
  %274 = "llvm.load"(%266) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<64xi8>
  %275 = "llvm.load"(%267) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<64xi8>
  %276 = "llvm.load"(%268) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<64xi8>
  %277 = "llvm.load"(%269) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<64xi8>
  %278 = "llvm.load"(%270) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<64xi8>
  %279 = "llvm.load"(%271) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<64xi8>
  %280 = "llvm.shufflevector"(%272, %274) <{mask = array<i32: 7, 6, 5, 4, 3, 2, 1, 0, 15, 14, 13, 12, 11, 10, 9, 8, 39, 38, 37, 36, 35, 34, 33, 32, 47, 46, 45, 44, 43, 42, 41, 40, 71, 70, 69, 68, 67, 66, 65, 64, 79, 78, 77, 76, 75, 74, 73, 72, 103, 102, 101, 100, 99, 98, 97, 96, 111, 110, 109, 108, 107, 106, 105, 104>}> : (vector<64xi8>, vector<64xi8>) -> vector<64xi8>
  %281 = "llvm.shufflevector"(%273, %275) <{mask = array<i32: 7, 6, 5, 4, 3, 2, 1, 0, 15, 14, 13, 12, 11, 10, 9, 8, 39, 38, 37, 36, 35, 34, 33, 32, 47, 46, 45, 44, 43, 42, 41, 40, 71, 70, 69, 68, 67, 66, 65, 64, 79, 78, 77, 76, 75, 74, 73, 72, 103, 102, 101, 100, 99, 98, 97, 96, 111, 110, 109, 108, 107, 106, 105, 104>}> : (vector<64xi8>, vector<64xi8>) -> vector<64xi8>
  %282 = "llvm.shufflevector"(%272, %274) <{mask = array<i32: 23, 22, 21, 20, 19, 18, 17, 16, 31, 30, 29, 28, 27, 26, 25, 24, 55, 54, 53, 52, 51, 50, 49, 48, 63, 62, 61, 60, 59, 58, 57, 56, 87, 86, 85, 84, 83, 82, 81, 80, 95, 94, 93, 92, 91, 90, 89, 88, 119, 118, 117, 116, 115, 114, 113, 112, 127, 126, 125, 124, 123, 122, 121, 120>}> : (vector<64xi8>, vector<64xi8>) -> vector<64xi8>
  %283 = "llvm.shufflevector"(%273, %275) <{mask = array<i32: 23, 22, 21, 20, 19, 18, 17, 16, 31, 30, 29, 28, 27, 26, 25, 24, 55, 54, 53, 52, 51, 50, 49, 48, 63, 62, 61, 60, 59, 58, 57, 56, 87, 86, 85, 84, 83, 82, 81, 80, 95, 94, 93, 92, 91, 90, 89, 88, 119, 118, 117, 116, 115, 114, 113, 112, 127, 126, 125, 124, 123, 122, 121, 120>}> : (vector<64xi8>, vector<64xi8>) -> vector<64xi8>
  %284 = "llvm.shufflevector"(%276, %278) <{mask = array<i32: 7, 6, 5, 4, 3, 2, 1, 0, 15, 14, 13, 12, 11, 10, 9, 8, 39, 38, 37, 36, 35, 34, 33, 32, 47, 46, 45, 44, 43, 42, 41, 40, 71, 70, 69, 68, 67, 66, 65, 64, 79, 78, 77, 76, 75, 74, 73, 72, 103, 102, 101, 100, 99, 98, 97, 96, 111, 110, 109, 108, 107, 106, 105, 104>}> : (vector<64xi8>, vector<64xi8>) -> vector<64xi8>
  %285 = "llvm.shufflevector"(%277, %279) <{mask = array<i32: 7, 6, 5, 4, 3, 2, 1, 0, 15, 14, 13, 12, 11, 10, 9, 8, 39, 38, 37, 36, 35, 34, 33, 32, 47, 46, 45, 44, 43, 42, 41, 40, 71, 70, 69, 68, 67, 66, 65, 64, 79, 78, 77, 76, 75, 74, 73, 72, 103, 102, 101, 100, 99, 98, 97, 96, 111, 110, 109, 108, 107, 106, 105, 104>}> : (vector<64xi8>, vector<64xi8>) -> vector<64xi8>
  %286 = "llvm.shufflevector"(%276, %278) <{mask = array<i32: 23, 22, 21, 20, 19, 18, 17, 16, 31, 30, 29, 28, 27, 26, 25, 24, 55, 54, 53, 52, 51, 50, 49, 48, 63, 62, 61, 60, 59, 58, 57, 56, 87, 86, 85, 84, 83, 82, 81, 80, 95, 94, 93, 92, 91, 90, 89, 88, 119, 118, 117, 116, 115, 114, 113, 112, 127, 126, 125, 124, 123, 122, 121, 120>}> : (vector<64xi8>, vector<64xi8>) -> vector<64xi8>
  %287 = "llvm.shufflevector"(%277, %279) <{mask = array<i32: 23, 22, 21, 20, 19, 18, 17, 16, 31, 30, 29, 28, 27, 26, 25, 24, 55, 54, 53, 52, 51, 50, 49, 48, 63, 62, 61, 60, 59, 58, 57, 56, 87, 86, 85, 84, 83, 82, 81, 80, 95, 94, 93, 92, 91, 90, 89, 88, 119, 118, 117, 116, 115, 114, 113, 112, 127, 126, 125, 124, 123, 122, 121, 120>}> : (vector<64xi8>, vector<64xi8>) -> vector<64xi8>
  %288 = "llvm.shufflevector"(%280, %284) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111>}> : (vector<64xi8>, vector<64xi8>) -> vector<64xi8>
  %289 = "llvm.bitcast"(%288) : (vector<64xi8>) -> vector<8xi64>
  %290 = "llvm.shufflevector"(%281, %285) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111>}> : (vector<64xi8>, vector<64xi8>) -> vector<64xi8>
  %291 = "llvm.bitcast"(%290) : (vector<64xi8>) -> vector<8xi64>
  %292 = "llvm.shufflevector"(%282, %286) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111>}> : (vector<64xi8>, vector<64xi8>) -> vector<64xi8>
  %293 = "llvm.bitcast"(%292) : (vector<64xi8>) -> vector<8xi64>
  %294 = "llvm.shufflevector"(%283, %287) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111>}> : (vector<64xi8>, vector<64xi8>) -> vector<64xi8>
  %295 = "llvm.bitcast"(%294) : (vector<64xi8>) -> vector<8xi64>
  %296 = "llvm.shufflevector"(%280, %284) <{mask = array<i32: 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127>}> : (vector<64xi8>, vector<64xi8>) -> vector<64xi8>
  %297 = "llvm.bitcast"(%296) : (vector<64xi8>) -> vector<8xi64>
  %298 = "llvm.shufflevector"(%281, %285) <{mask = array<i32: 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127>}> : (vector<64xi8>, vector<64xi8>) -> vector<64xi8>
  %299 = "llvm.bitcast"(%298) : (vector<64xi8>) -> vector<8xi64>
  %300 = "llvm.shufflevector"(%282, %286) <{mask = array<i32: 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127>}> : (vector<64xi8>, vector<64xi8>) -> vector<64xi8>
  %301 = "llvm.bitcast"(%300) : (vector<64xi8>) -> vector<8xi64>
  %302 = "llvm.shufflevector"(%283, %287) <{mask = array<i32: 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127>}> : (vector<64xi8>, vector<64xi8>) -> vector<64xi8>
  %303 = "llvm.bitcast"(%302) : (vector<64xi8>) -> vector<8xi64>
  %304 = "llvm.shufflevector"(%289, %291) <{mask = array<i32: 0, 8, 2, 10, 4, 12, 6, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %305 = "llvm.shufflevector"(%289, %291) <{mask = array<i32: 1, 9, 3, 11, 5, 13, 7, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %306 = "llvm.shufflevector"(%293, %295) <{mask = array<i32: 0, 8, 2, 10, 4, 12, 6, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %307 = "llvm.shufflevector"(%293, %295) <{mask = array<i32: 1, 9, 3, 11, 5, 13, 7, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %308 = "llvm.shufflevector"(%297, %299) <{mask = array<i32: 0, 8, 2, 10, 4, 12, 6, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %309 = "llvm.shufflevector"(%297, %299) <{mask = array<i32: 1, 9, 3, 11, 5, 13, 7, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %310 = "llvm.shufflevector"(%301, %303) <{mask = array<i32: 0, 8, 2, 10, 4, 12, 6, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %311 = "llvm.shufflevector"(%301, %303) <{mask = array<i32: 1, 9, 3, 11, 5, 13, 7, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %312 = "llvm.getelementptr"(%264) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %313 = "llvm.load"(%312) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<64xi8>
  %314 = "llvm.getelementptr"(%265) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %315 = "llvm.load"(%314) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<64xi8>
  %316 = "llvm.getelementptr"(%266) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %317 = "llvm.load"(%316) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<64xi8>
  %318 = "llvm.getelementptr"(%267) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %319 = "llvm.load"(%318) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<64xi8>
  %320 = "llvm.getelementptr"(%268) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %321 = "llvm.load"(%320) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<64xi8>
  %322 = "llvm.getelementptr"(%269) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %323 = "llvm.load"(%322) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<64xi8>
  %324 = "llvm.getelementptr"(%270) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %325 = "llvm.load"(%324) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<64xi8>
  %326 = "llvm.getelementptr"(%271) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %327 = "llvm.load"(%326) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<64xi8>
  %328 = "llvm.shufflevector"(%313, %317) <{mask = array<i32: 7, 6, 5, 4, 3, 2, 1, 0, 15, 14, 13, 12, 11, 10, 9, 8, 39, 38, 37, 36, 35, 34, 33, 32, 47, 46, 45, 44, 43, 42, 41, 40, 71, 70, 69, 68, 67, 66, 65, 64, 79, 78, 77, 76, 75, 74, 73, 72, 103, 102, 101, 100, 99, 98, 97, 96, 111, 110, 109, 108, 107, 106, 105, 104>}> : (vector<64xi8>, vector<64xi8>) -> vector<64xi8>
  %329 = "llvm.shufflevector"(%315, %319) <{mask = array<i32: 7, 6, 5, 4, 3, 2, 1, 0, 15, 14, 13, 12, 11, 10, 9, 8, 39, 38, 37, 36, 35, 34, 33, 32, 47, 46, 45, 44, 43, 42, 41, 40, 71, 70, 69, 68, 67, 66, 65, 64, 79, 78, 77, 76, 75, 74, 73, 72, 103, 102, 101, 100, 99, 98, 97, 96, 111, 110, 109, 108, 107, 106, 105, 104>}> : (vector<64xi8>, vector<64xi8>) -> vector<64xi8>
  %330 = "llvm.shufflevector"(%313, %317) <{mask = array<i32: 23, 22, 21, 20, 19, 18, 17, 16, 31, 30, 29, 28, 27, 26, 25, 24, 55, 54, 53, 52, 51, 50, 49, 48, 63, 62, 61, 60, 59, 58, 57, 56, 87, 86, 85, 84, 83, 82, 81, 80, 95, 94, 93, 92, 91, 90, 89, 88, 119, 118, 117, 116, 115, 114, 113, 112, 127, 126, 125, 124, 123, 122, 121, 120>}> : (vector<64xi8>, vector<64xi8>) -> vector<64xi8>
  %331 = "llvm.shufflevector"(%315, %319) <{mask = array<i32: 23, 22, 21, 20, 19, 18, 17, 16, 31, 30, 29, 28, 27, 26, 25, 24, 55, 54, 53, 52, 51, 50, 49, 48, 63, 62, 61, 60, 59, 58, 57, 56, 87, 86, 85, 84, 83, 82, 81, 80, 95, 94, 93, 92, 91, 90, 89, 88, 119, 118, 117, 116, 115, 114, 113, 112, 127, 126, 125, 124, 123, 122, 121, 120>}> : (vector<64xi8>, vector<64xi8>) -> vector<64xi8>
  %332 = "llvm.shufflevector"(%321, %325) <{mask = array<i32: 7, 6, 5, 4, 3, 2, 1, 0, 15, 14, 13, 12, 11, 10, 9, 8, 39, 38, 37, 36, 35, 34, 33, 32, 47, 46, 45, 44, 43, 42, 41, 40, 71, 70, 69, 68, 67, 66, 65, 64, 79, 78, 77, 76, 75, 74, 73, 72, 103, 102, 101, 100, 99, 98, 97, 96, 111, 110, 109, 108, 107, 106, 105, 104>}> : (vector<64xi8>, vector<64xi8>) -> vector<64xi8>
  %333 = "llvm.shufflevector"(%323, %327) <{mask = array<i32: 7, 6, 5, 4, 3, 2, 1, 0, 15, 14, 13, 12, 11, 10, 9, 8, 39, 38, 37, 36, 35, 34, 33, 32, 47, 46, 45, 44, 43, 42, 41, 40, 71, 70, 69, 68, 67, 66, 65, 64, 79, 78, 77, 76, 75, 74, 73, 72, 103, 102, 101, 100, 99, 98, 97, 96, 111, 110, 109, 108, 107, 106, 105, 104>}> : (vector<64xi8>, vector<64xi8>) -> vector<64xi8>
  %334 = "llvm.shufflevector"(%321, %325) <{mask = array<i32: 23, 22, 21, 20, 19, 18, 17, 16, 31, 30, 29, 28, 27, 26, 25, 24, 55, 54, 53, 52, 51, 50, 49, 48, 63, 62, 61, 60, 59, 58, 57, 56, 87, 86, 85, 84, 83, 82, 81, 80, 95, 94, 93, 92, 91, 90, 89, 88, 119, 118, 117, 116, 115, 114, 113, 112, 127, 126, 125, 124, 123, 122, 121, 120>}> : (vector<64xi8>, vector<64xi8>) -> vector<64xi8>
  %335 = "llvm.shufflevector"(%323, %327) <{mask = array<i32: 23, 22, 21, 20, 19, 18, 17, 16, 31, 30, 29, 28, 27, 26, 25, 24, 55, 54, 53, 52, 51, 50, 49, 48, 63, 62, 61, 60, 59, 58, 57, 56, 87, 86, 85, 84, 83, 82, 81, 80, 95, 94, 93, 92, 91, 90, 89, 88, 119, 118, 117, 116, 115, 114, 113, 112, 127, 126, 125, 124, 123, 122, 121, 120>}> : (vector<64xi8>, vector<64xi8>) -> vector<64xi8>
  %336 = "llvm.shufflevector"(%328, %332) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111>}> : (vector<64xi8>, vector<64xi8>) -> vector<64xi8>
  %337 = "llvm.bitcast"(%336) : (vector<64xi8>) -> vector<8xi64>
  %338 = "llvm.shufflevector"(%329, %333) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111>}> : (vector<64xi8>, vector<64xi8>) -> vector<64xi8>
  %339 = "llvm.bitcast"(%338) : (vector<64xi8>) -> vector<8xi64>
  %340 = "llvm.shufflevector"(%330, %334) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111>}> : (vector<64xi8>, vector<64xi8>) -> vector<64xi8>
  %341 = "llvm.bitcast"(%340) : (vector<64xi8>) -> vector<8xi64>
  %342 = "llvm.shufflevector"(%331, %335) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111>}> : (vector<64xi8>, vector<64xi8>) -> vector<64xi8>
  %343 = "llvm.bitcast"(%342) : (vector<64xi8>) -> vector<8xi64>
  %344 = "llvm.shufflevector"(%328, %332) <{mask = array<i32: 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127>}> : (vector<64xi8>, vector<64xi8>) -> vector<64xi8>
  %345 = "llvm.bitcast"(%344) : (vector<64xi8>) -> vector<8xi64>
  %346 = "llvm.shufflevector"(%329, %333) <{mask = array<i32: 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127>}> : (vector<64xi8>, vector<64xi8>) -> vector<64xi8>
  %347 = "llvm.bitcast"(%346) : (vector<64xi8>) -> vector<8xi64>
  %348 = "llvm.shufflevector"(%330, %334) <{mask = array<i32: 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127>}> : (vector<64xi8>, vector<64xi8>) -> vector<64xi8>
  %349 = "llvm.bitcast"(%348) : (vector<64xi8>) -> vector<8xi64>
  %350 = "llvm.shufflevector"(%331, %335) <{mask = array<i32: 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127>}> : (vector<64xi8>, vector<64xi8>) -> vector<64xi8>
  %351 = "llvm.bitcast"(%350) : (vector<64xi8>) -> vector<8xi64>
  %352 = "llvm.shufflevector"(%337, %339) <{mask = array<i32: 0, 8, 2, 10, 4, 12, 6, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %353 = "llvm.shufflevector"(%337, %339) <{mask = array<i32: 1, 9, 3, 11, 5, 13, 7, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %354 = "llvm.shufflevector"(%341, %343) <{mask = array<i32: 0, 8, 2, 10, 4, 12, 6, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %355 = "llvm.shufflevector"(%341, %343) <{mask = array<i32: 1, 9, 3, 11, 5, 13, 7, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %356 = "llvm.shufflevector"(%345, %347) <{mask = array<i32: 0, 8, 2, 10, 4, 12, 6, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %357 = "llvm.shufflevector"(%345, %347) <{mask = array<i32: 1, 9, 3, 11, 5, 13, 7, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %358 = "llvm.shufflevector"(%349, %351) <{mask = array<i32: 0, 8, 2, 10, 4, 12, 6, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %359 = "llvm.shufflevector"(%349, %351) <{mask = array<i32: 1, 9, 3, 11, 5, 13, 7, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %360 = "llvm.intr.fshl"(%247, %247, %46) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %361 = "llvm.intr.fshl"(%247, %247, %47) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %362 = "llvm.intr.fshl"(%247, %247, %48) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %363 = "llvm.xor"(%361, %362) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %364 = "llvm.xor"(%363, %360) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %365 = "llvm.and"(%247, %248) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %366 = "llvm.xor"(%247, %49) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %367 = "llvm.and"(%249, %366) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %368 = "llvm.or"(%365, %367) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %369 = "llvm.add"(%250, %50) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %370 = "llvm.add"(%369, %368) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %371 = "llvm.add"(%370, %364) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %372 = "llvm.add"(%371, %304) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %373 = "llvm.intr.fshl"(%243, %243, %51) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %374 = "llvm.intr.fshl"(%243, %243, %52) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %375 = "llvm.intr.fshl"(%243, %243, %53) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %376 = "llvm.xor"(%374, %375) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %377 = "llvm.xor"(%376, %373) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %378 = "llvm.and"(%243, %244) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %379 = "llvm.xor"(%243, %244) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %380 = "llvm.and"(%379, %245) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %381 = "llvm.xor"(%380, %378) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %382 = "llvm.add"(%377, %381) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %383 = "llvm.add"(%372, %246) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %384 = "llvm.add"(%382, %372) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %385 = "llvm.intr.fshl"(%383, %383, %46) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %386 = "llvm.intr.fshl"(%383, %383, %47) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %387 = "llvm.intr.fshl"(%383, %383, %48) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %388 = "llvm.xor"(%386, %387) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %389 = "llvm.xor"(%388, %385) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %390 = "llvm.and"(%383, %247) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %391 = "llvm.xor"(%383, %49) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %392 = "llvm.and"(%248, %391) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %393 = "llvm.or"(%390, %392) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %394 = "llvm.add"(%249, %54) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %395 = "llvm.add"(%394, %305) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %396 = "llvm.add"(%395, %393) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %397 = "llvm.add"(%396, %389) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %398 = "llvm.intr.fshl"(%384, %384, %51) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %399 = "llvm.intr.fshl"(%384, %384, %52) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %400 = "llvm.intr.fshl"(%384, %384, %53) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %401 = "llvm.xor"(%399, %400) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %402 = "llvm.xor"(%401, %398) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %403 = "llvm.and"(%384, %243) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %404 = "llvm.xor"(%384, %243) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %405 = "llvm.and"(%404, %244) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %406 = "llvm.xor"(%405, %403) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %407 = "llvm.add"(%402, %406) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %408 = "llvm.add"(%397, %245) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %409 = "llvm.add"(%407, %397) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %410 = "llvm.intr.fshl"(%408, %408, %46) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %411 = "llvm.intr.fshl"(%408, %408, %47) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %412 = "llvm.intr.fshl"(%408, %408, %48) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %413 = "llvm.xor"(%411, %412) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %414 = "llvm.xor"(%413, %410) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %415 = "llvm.and"(%408, %383) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %416 = "llvm.xor"(%408, %49) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %417 = "llvm.and"(%247, %416) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %418 = "llvm.or"(%415, %417) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %419 = "llvm.add"(%248, %55) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %420 = "llvm.add"(%419, %306) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %421 = "llvm.add"(%420, %418) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %422 = "llvm.add"(%421, %414) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %423 = "llvm.intr.fshl"(%409, %409, %51) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %424 = "llvm.intr.fshl"(%409, %409, %52) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %425 = "llvm.intr.fshl"(%409, %409, %53) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %426 = "llvm.xor"(%424, %425) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %427 = "llvm.xor"(%426, %423) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %428 = "llvm.and"(%409, %384) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %429 = "llvm.xor"(%409, %384) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %430 = "llvm.and"(%429, %243) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %431 = "llvm.xor"(%430, %428) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %432 = "llvm.add"(%427, %431) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %433 = "llvm.add"(%422, %244) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %434 = "llvm.add"(%432, %422) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %435 = "llvm.intr.fshl"(%433, %433, %46) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %436 = "llvm.intr.fshl"(%433, %433, %47) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %437 = "llvm.intr.fshl"(%433, %433, %48) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %438 = "llvm.xor"(%436, %437) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %439 = "llvm.xor"(%438, %435) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %440 = "llvm.and"(%433, %408) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %441 = "llvm.xor"(%433, %49) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %442 = "llvm.and"(%383, %441) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %443 = "llvm.or"(%440, %442) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %444 = "llvm.add"(%247, %56) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %445 = "llvm.add"(%444, %307) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %446 = "llvm.add"(%445, %443) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %447 = "llvm.add"(%446, %439) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %448 = "llvm.intr.fshl"(%434, %434, %51) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %449 = "llvm.intr.fshl"(%434, %434, %52) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %450 = "llvm.intr.fshl"(%434, %434, %53) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %451 = "llvm.xor"(%449, %450) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %452 = "llvm.xor"(%451, %448) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %453 = "llvm.and"(%434, %409) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %454 = "llvm.xor"(%434, %409) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %455 = "llvm.and"(%454, %384) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %456 = "llvm.xor"(%455, %453) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %457 = "llvm.add"(%452, %456) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %458 = "llvm.add"(%447, %243) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %459 = "llvm.add"(%457, %447) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %460 = "llvm.intr.fshl"(%458, %458, %46) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %461 = "llvm.intr.fshl"(%458, %458, %47) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %462 = "llvm.intr.fshl"(%458, %458, %48) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %463 = "llvm.xor"(%461, %462) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %464 = "llvm.xor"(%463, %460) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %465 = "llvm.and"(%458, %433) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %466 = "llvm.xor"(%458, %49) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %467 = "llvm.and"(%408, %466) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %468 = "llvm.or"(%465, %467) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %469 = "llvm.add"(%308, %57) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %470 = "llvm.add"(%469, %383) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %471 = "llvm.add"(%470, %468) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %472 = "llvm.add"(%471, %464) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %473 = "llvm.intr.fshl"(%459, %459, %51) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %474 = "llvm.intr.fshl"(%459, %459, %52) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %475 = "llvm.intr.fshl"(%459, %459, %53) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %476 = "llvm.xor"(%474, %475) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %477 = "llvm.xor"(%476, %473) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %478 = "llvm.and"(%459, %434) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %479 = "llvm.xor"(%459, %434) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %480 = "llvm.and"(%479, %409) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %481 = "llvm.xor"(%480, %478) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %482 = "llvm.add"(%477, %481) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %483 = "llvm.add"(%472, %384) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %484 = "llvm.add"(%482, %472) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %485 = "llvm.intr.fshl"(%483, %483, %46) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %486 = "llvm.intr.fshl"(%483, %483, %47) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %487 = "llvm.intr.fshl"(%483, %483, %48) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %488 = "llvm.xor"(%486, %487) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %489 = "llvm.xor"(%488, %485) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %490 = "llvm.and"(%483, %458) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %491 = "llvm.xor"(%483, %49) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %492 = "llvm.and"(%433, %491) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %493 = "llvm.or"(%490, %492) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %494 = "llvm.add"(%309, %58) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %495 = "llvm.add"(%494, %408) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %496 = "llvm.add"(%495, %493) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %497 = "llvm.add"(%496, %489) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %498 = "llvm.intr.fshl"(%484, %484, %51) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %499 = "llvm.intr.fshl"(%484, %484, %52) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %500 = "llvm.intr.fshl"(%484, %484, %53) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %501 = "llvm.xor"(%499, %500) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %502 = "llvm.xor"(%501, %498) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %503 = "llvm.and"(%484, %459) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %504 = "llvm.xor"(%484, %459) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %505 = "llvm.and"(%504, %434) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %506 = "llvm.xor"(%505, %503) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %507 = "llvm.add"(%502, %506) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %508 = "llvm.add"(%497, %409) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %509 = "llvm.add"(%507, %497) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %510 = "llvm.intr.fshl"(%508, %508, %46) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %511 = "llvm.intr.fshl"(%508, %508, %47) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %512 = "llvm.intr.fshl"(%508, %508, %48) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %513 = "llvm.xor"(%511, %512) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %514 = "llvm.xor"(%513, %510) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %515 = "llvm.and"(%508, %483) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %516 = "llvm.xor"(%508, %49) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %517 = "llvm.and"(%458, %516) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %518 = "llvm.or"(%515, %517) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %519 = "llvm.add"(%310, %59) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %520 = "llvm.add"(%519, %433) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %521 = "llvm.add"(%520, %518) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %522 = "llvm.add"(%521, %514) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %523 = "llvm.intr.fshl"(%509, %509, %51) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %524 = "llvm.intr.fshl"(%509, %509, %52) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %525 = "llvm.intr.fshl"(%509, %509, %53) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %526 = "llvm.xor"(%524, %525) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %527 = "llvm.xor"(%526, %523) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %528 = "llvm.and"(%509, %484) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %529 = "llvm.xor"(%509, %484) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %530 = "llvm.and"(%529, %459) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %531 = "llvm.xor"(%530, %528) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %532 = "llvm.add"(%527, %531) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %533 = "llvm.add"(%522, %434) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %534 = "llvm.add"(%532, %522) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %535 = "llvm.intr.fshl"(%533, %533, %46) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %536 = "llvm.intr.fshl"(%533, %533, %47) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %537 = "llvm.intr.fshl"(%533, %533, %48) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %538 = "llvm.xor"(%536, %537) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %539 = "llvm.xor"(%538, %535) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %540 = "llvm.and"(%533, %508) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %541 = "llvm.xor"(%533, %49) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %542 = "llvm.and"(%483, %541) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %543 = "llvm.or"(%540, %542) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %544 = "llvm.add"(%311, %60) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %545 = "llvm.add"(%544, %458) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %546 = "llvm.add"(%545, %543) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %547 = "llvm.add"(%546, %539) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %548 = "llvm.intr.fshl"(%534, %534, %51) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %549 = "llvm.intr.fshl"(%534, %534, %52) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %550 = "llvm.intr.fshl"(%534, %534, %53) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %551 = "llvm.xor"(%549, %550) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %552 = "llvm.xor"(%551, %548) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %553 = "llvm.and"(%534, %509) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %554 = "llvm.xor"(%534, %509) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %555 = "llvm.and"(%554, %484) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %556 = "llvm.xor"(%555, %553) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %557 = "llvm.add"(%552, %556) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %558 = "llvm.add"(%547, %459) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %559 = "llvm.add"(%557, %547) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %560 = "llvm.intr.fshl"(%558, %558, %46) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %561 = "llvm.intr.fshl"(%558, %558, %47) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %562 = "llvm.intr.fshl"(%558, %558, %48) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %563 = "llvm.xor"(%561, %562) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %564 = "llvm.xor"(%563, %560) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %565 = "llvm.and"(%558, %533) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %566 = "llvm.xor"(%558, %49) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %567 = "llvm.and"(%508, %566) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %568 = "llvm.or"(%565, %567) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %569 = "llvm.add"(%352, %61) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %570 = "llvm.add"(%569, %483) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %571 = "llvm.add"(%570, %568) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %572 = "llvm.add"(%571, %564) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %573 = "llvm.intr.fshl"(%559, %559, %51) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %574 = "llvm.intr.fshl"(%559, %559, %52) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %575 = "llvm.intr.fshl"(%559, %559, %53) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %576 = "llvm.xor"(%574, %575) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %577 = "llvm.xor"(%576, %573) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %578 = "llvm.and"(%559, %534) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %579 = "llvm.xor"(%559, %534) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %580 = "llvm.and"(%579, %509) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %581 = "llvm.xor"(%580, %578) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %582 = "llvm.add"(%577, %581) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %583 = "llvm.add"(%572, %484) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %584 = "llvm.add"(%582, %572) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %585 = "llvm.intr.fshl"(%583, %583, %46) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %586 = "llvm.intr.fshl"(%583, %583, %47) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %587 = "llvm.intr.fshl"(%583, %583, %48) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %588 = "llvm.xor"(%586, %587) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %589 = "llvm.xor"(%588, %585) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %590 = "llvm.and"(%583, %558) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %591 = "llvm.xor"(%583, %49) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %592 = "llvm.and"(%533, %591) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %593 = "llvm.or"(%590, %592) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %594 = "llvm.add"(%353, %62) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %595 = "llvm.add"(%594, %508) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %596 = "llvm.add"(%595, %593) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %597 = "llvm.add"(%596, %589) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %598 = "llvm.intr.fshl"(%584, %584, %51) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %599 = "llvm.intr.fshl"(%584, %584, %52) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %600 = "llvm.intr.fshl"(%584, %584, %53) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %601 = "llvm.xor"(%599, %600) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %602 = "llvm.xor"(%601, %598) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %603 = "llvm.and"(%584, %559) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %604 = "llvm.xor"(%584, %559) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %605 = "llvm.and"(%604, %534) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %606 = "llvm.xor"(%605, %603) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %607 = "llvm.add"(%602, %606) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %608 = "llvm.add"(%597, %509) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %609 = "llvm.add"(%607, %597) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %610 = "llvm.intr.fshl"(%608, %608, %46) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %611 = "llvm.intr.fshl"(%608, %608, %47) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %612 = "llvm.intr.fshl"(%608, %608, %48) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %613 = "llvm.xor"(%611, %612) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %614 = "llvm.xor"(%613, %610) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %615 = "llvm.and"(%608, %583) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %616 = "llvm.xor"(%608, %49) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %617 = "llvm.and"(%558, %616) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %618 = "llvm.or"(%615, %617) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %619 = "llvm.add"(%354, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %620 = "llvm.add"(%619, %533) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %621 = "llvm.add"(%620, %618) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %622 = "llvm.add"(%621, %614) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %623 = "llvm.intr.fshl"(%609, %609, %51) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %624 = "llvm.intr.fshl"(%609, %609, %52) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %625 = "llvm.intr.fshl"(%609, %609, %53) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %626 = "llvm.xor"(%624, %625) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %627 = "llvm.xor"(%626, %623) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %628 = "llvm.and"(%609, %584) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %629 = "llvm.xor"(%609, %584) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %630 = "llvm.and"(%629, %559) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %631 = "llvm.xor"(%630, %628) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %632 = "llvm.add"(%627, %631) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %633 = "llvm.add"(%622, %534) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %634 = "llvm.add"(%632, %622) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %635 = "llvm.intr.fshl"(%633, %633, %46) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %636 = "llvm.intr.fshl"(%633, %633, %47) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %637 = "llvm.intr.fshl"(%633, %633, %48) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %638 = "llvm.xor"(%636, %637) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %639 = "llvm.xor"(%638, %635) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %640 = "llvm.and"(%633, %608) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %641 = "llvm.xor"(%633, %49) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %642 = "llvm.and"(%583, %641) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %643 = "llvm.or"(%640, %642) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %644 = "llvm.add"(%355, %64) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %645 = "llvm.add"(%644, %558) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %646 = "llvm.add"(%645, %643) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %647 = "llvm.add"(%646, %639) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %648 = "llvm.intr.fshl"(%634, %634, %51) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %649 = "llvm.intr.fshl"(%634, %634, %52) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %650 = "llvm.intr.fshl"(%634, %634, %53) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %651 = "llvm.xor"(%649, %650) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %652 = "llvm.xor"(%651, %648) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %653 = "llvm.and"(%634, %609) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %654 = "llvm.xor"(%634, %609) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %655 = "llvm.and"(%654, %584) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %656 = "llvm.xor"(%655, %653) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %657 = "llvm.add"(%652, %656) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %658 = "llvm.add"(%647, %559) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %659 = "llvm.add"(%657, %647) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %660 = "llvm.intr.fshl"(%658, %658, %46) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %661 = "llvm.intr.fshl"(%658, %658, %47) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %662 = "llvm.intr.fshl"(%658, %658, %48) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %663 = "llvm.xor"(%661, %662) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %664 = "llvm.xor"(%663, %660) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %665 = "llvm.and"(%658, %633) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %666 = "llvm.xor"(%658, %49) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %667 = "llvm.and"(%608, %666) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %668 = "llvm.or"(%665, %667) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %669 = "llvm.add"(%356, %65) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %670 = "llvm.add"(%669, %583) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %671 = "llvm.add"(%670, %668) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %672 = "llvm.add"(%671, %664) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %673 = "llvm.intr.fshl"(%659, %659, %51) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %674 = "llvm.intr.fshl"(%659, %659, %52) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %675 = "llvm.intr.fshl"(%659, %659, %53) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %676 = "llvm.xor"(%674, %675) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %677 = "llvm.xor"(%676, %673) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %678 = "llvm.and"(%659, %634) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %679 = "llvm.xor"(%659, %634) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %680 = "llvm.and"(%679, %609) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %681 = "llvm.xor"(%680, %678) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %682 = "llvm.add"(%677, %681) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %683 = "llvm.add"(%672, %584) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %684 = "llvm.add"(%682, %672) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %685 = "llvm.intr.fshl"(%683, %683, %46) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %686 = "llvm.intr.fshl"(%683, %683, %47) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %687 = "llvm.intr.fshl"(%683, %683, %48) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %688 = "llvm.xor"(%686, %687) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %689 = "llvm.xor"(%688, %685) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %690 = "llvm.and"(%683, %658) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %691 = "llvm.xor"(%683, %49) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %692 = "llvm.and"(%633, %691) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %693 = "llvm.or"(%690, %692) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %694 = "llvm.add"(%357, %66) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %695 = "llvm.add"(%694, %608) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %696 = "llvm.add"(%695, %693) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %697 = "llvm.add"(%696, %689) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %698 = "llvm.intr.fshl"(%684, %684, %51) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %699 = "llvm.intr.fshl"(%684, %684, %52) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %700 = "llvm.intr.fshl"(%684, %684, %53) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %701 = "llvm.xor"(%699, %700) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %702 = "llvm.xor"(%701, %698) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %703 = "llvm.and"(%684, %659) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %704 = "llvm.xor"(%684, %659) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %705 = "llvm.and"(%704, %634) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %706 = "llvm.xor"(%705, %703) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %707 = "llvm.add"(%702, %706) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %708 = "llvm.add"(%697, %609) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %709 = "llvm.add"(%707, %697) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %710 = "llvm.intr.fshl"(%708, %708, %46) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %711 = "llvm.intr.fshl"(%708, %708, %47) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %712 = "llvm.intr.fshl"(%708, %708, %48) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %713 = "llvm.xor"(%711, %712) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %714 = "llvm.xor"(%713, %710) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %715 = "llvm.and"(%708, %683) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %716 = "llvm.xor"(%708, %49) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %717 = "llvm.and"(%658, %716) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %718 = "llvm.or"(%715, %717) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %719 = "llvm.add"(%358, %67) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %720 = "llvm.add"(%719, %633) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %721 = "llvm.add"(%720, %718) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %722 = "llvm.add"(%721, %714) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %723 = "llvm.intr.fshl"(%709, %709, %51) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %724 = "llvm.intr.fshl"(%709, %709, %52) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %725 = "llvm.intr.fshl"(%709, %709, %53) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %726 = "llvm.xor"(%724, %725) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %727 = "llvm.xor"(%726, %723) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %728 = "llvm.and"(%709, %684) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %729 = "llvm.xor"(%709, %684) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %730 = "llvm.and"(%729, %659) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %731 = "llvm.xor"(%730, %728) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %732 = "llvm.add"(%727, %731) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %733 = "llvm.add"(%722, %634) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %734 = "llvm.add"(%732, %722) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %735 = "llvm.intr.fshl"(%733, %733, %46) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %736 = "llvm.intr.fshl"(%733, %733, %47) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %737 = "llvm.intr.fshl"(%733, %733, %48) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %738 = "llvm.xor"(%736, %737) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %739 = "llvm.xor"(%738, %735) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %740 = "llvm.and"(%733, %708) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %741 = "llvm.xor"(%733, %49) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %742 = "llvm.and"(%683, %741) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %743 = "llvm.or"(%740, %742) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %744 = "llvm.add"(%359, %68) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %745 = "llvm.add"(%744, %658) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %746 = "llvm.add"(%745, %743) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %747 = "llvm.add"(%746, %739) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %748 = "llvm.intr.fshl"(%734, %734, %51) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %749 = "llvm.intr.fshl"(%734, %734, %52) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %750 = "llvm.intr.fshl"(%734, %734, %53) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %751 = "llvm.xor"(%749, %750) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %752 = "llvm.xor"(%751, %748) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %753 = "llvm.and"(%734, %709) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %754 = "llvm.xor"(%734, %709) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %755 = "llvm.and"(%754, %684) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %756 = "llvm.xor"(%755, %753) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %757 = "llvm.add"(%752, %756) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %758 = "llvm.add"(%747, %659) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %759 = "llvm.add"(%757, %747) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.br"(%304, %20, %683, %708, %733, %758, %684, %709, %734, %759, %305, %306, %307, %308, %309, %310, %311, %352, %353, %354, %355, %356, %357, %358, %359)[^bb20] : (vector<8xi64>, i64, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>) -> ()
^bb20(%760: vector<8xi64>, %761: i64, %762: vector<8xi64>, %763: vector<8xi64>, %764: vector<8xi64>, %765: vector<8xi64>, %766: vector<8xi64>, %767: vector<8xi64>, %768: vector<8xi64>, %769: vector<8xi64>, %770: vector<8xi64>, %771: vector<8xi64>, %772: vector<8xi64>, %773: vector<8xi64>, %774: vector<8xi64>, %775: vector<8xi64>, %776: vector<8xi64>, %777: vector<8xi64>, %778: vector<8xi64>, %779: vector<8xi64>, %780: vector<8xi64>, %781: vector<8xi64>, %782: vector<8xi64>, %783: vector<8xi64>, %784: vector<8xi64>):  // 2 preds: ^bb19, ^bb20
  %785 = "llvm.intr.fshl"(%770, %770, %69) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %786 = "llvm.intr.fshl"(%770, %770, %70) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %787 = "llvm.lshr"(%770, %35) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %788 = "llvm.xor"(%786, %787) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %789 = "llvm.xor"(%788, %785) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %790 = "llvm.intr.fshl"(%783, %783, %71) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %791 = "llvm.intr.fshl"(%783, %783, %72) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %792 = "llvm.lshr"(%783, %73) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %793 = "llvm.xor"(%791, %792) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %794 = "llvm.xor"(%793, %790) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %795 = "llvm.add"(%778, %794) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %796 = "llvm.add"(%795, %789) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %797 = "llvm.add"(%796, %760) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %798 = "llvm.getelementptr"(%74, %761) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %799 = "llvm.load"(%798) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %800 = "llvm.insertelement"(%32, %799, %2) : (vector<8xi64>, i64, i64) -> vector<8xi64>
  %801 = "llvm.shufflevector"(%800, %32) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %802 = "llvm.intr.fshl"(%765, %765, %46) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %803 = "llvm.intr.fshl"(%765, %765, %47) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %804 = "llvm.intr.fshl"(%765, %765, %48) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %805 = "llvm.xor"(%803, %804) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %806 = "llvm.xor"(%805, %802) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %807 = "llvm.and"(%764, %765) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %808 = "llvm.xor"(%765, %49) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %809 = "llvm.and"(%763, %808) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %810 = "llvm.or"(%809, %807) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %811 = "llvm.add"(%762, %806) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %812 = "llvm.add"(%811, %810) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %813 = "llvm.add"(%812, %797) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %814 = "llvm.add"(%813, %801) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %815 = "llvm.intr.fshl"(%769, %769, %51) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %816 = "llvm.intr.fshl"(%769, %769, %52) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %817 = "llvm.intr.fshl"(%769, %769, %53) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %818 = "llvm.xor"(%816, %817) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %819 = "llvm.xor"(%818, %815) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %820 = "llvm.and"(%768, %769) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %821 = "llvm.xor"(%768, %769) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %822 = "llvm.and"(%821, %767) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %823 = "llvm.xor"(%822, %820) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %824 = "llvm.add"(%823, %819) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %825 = "llvm.add"(%814, %766) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %826 = "llvm.add"(%824, %814) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %827 = "llvm.intr.fshl"(%771, %771, %69) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %828 = "llvm.intr.fshl"(%771, %771, %70) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %829 = "llvm.lshr"(%771, %35) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %830 = "llvm.xor"(%828, %829) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %831 = "llvm.xor"(%830, %827) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %832 = "llvm.intr.fshl"(%784, %784, %71) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %833 = "llvm.intr.fshl"(%784, %784, %72) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %834 = "llvm.lshr"(%784, %73) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %835 = "llvm.xor"(%833, %834) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %836 = "llvm.xor"(%835, %832) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %837 = "llvm.add"(%779, %836) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %838 = "llvm.add"(%837, %770) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %839 = "llvm.add"(%838, %831) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %840 = "llvm.getelementptr"(%798) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %841 = "llvm.load"(%840) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %842 = "llvm.insertelement"(%32, %841, %2) : (vector<8xi64>, i64, i64) -> vector<8xi64>
  %843 = "llvm.shufflevector"(%842, %32) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %844 = "llvm.intr.fshl"(%825, %825, %46) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %845 = "llvm.intr.fshl"(%825, %825, %47) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %846 = "llvm.intr.fshl"(%825, %825, %48) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %847 = "llvm.xor"(%845, %846) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %848 = "llvm.xor"(%847, %844) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %849 = "llvm.and"(%825, %765) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %850 = "llvm.xor"(%825, %49) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %851 = "llvm.and"(%764, %850) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %852 = "llvm.or"(%849, %851) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %853 = "llvm.add"(%763, %839) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %854 = "llvm.add"(%853, %843) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %855 = "llvm.add"(%854, %852) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %856 = "llvm.add"(%855, %848) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %857 = "llvm.intr.fshl"(%826, %826, %51) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %858 = "llvm.intr.fshl"(%826, %826, %52) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %859 = "llvm.intr.fshl"(%826, %826, %53) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %860 = "llvm.xor"(%858, %859) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %861 = "llvm.xor"(%860, %857) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %862 = "llvm.and"(%826, %769) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %863 = "llvm.xor"(%826, %769) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %864 = "llvm.and"(%863, %768) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %865 = "llvm.xor"(%864, %862) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %866 = "llvm.add"(%861, %865) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %867 = "llvm.add"(%856, %767) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %868 = "llvm.add"(%866, %856) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %869 = "llvm.intr.fshl"(%772, %772, %69) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %870 = "llvm.intr.fshl"(%772, %772, %70) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %871 = "llvm.lshr"(%772, %35) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %872 = "llvm.xor"(%870, %871) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %873 = "llvm.xor"(%872, %869) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %874 = "llvm.intr.fshl"(%797, %797, %71) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %875 = "llvm.intr.fshl"(%797, %797, %72) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %876 = "llvm.lshr"(%797, %73) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %877 = "llvm.xor"(%875, %876) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %878 = "llvm.xor"(%877, %874) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %879 = "llvm.add"(%771, %780) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %880 = "llvm.add"(%879, %873) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %881 = "llvm.add"(%880, %878) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %882 = "llvm.getelementptr"(%798) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %883 = "llvm.load"(%882) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %884 = "llvm.insertelement"(%32, %883, %2) : (vector<8xi64>, i64, i64) -> vector<8xi64>
  %885 = "llvm.shufflevector"(%884, %32) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %886 = "llvm.intr.fshl"(%867, %867, %46) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %887 = "llvm.intr.fshl"(%867, %867, %47) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %888 = "llvm.intr.fshl"(%867, %867, %48) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %889 = "llvm.xor"(%887, %888) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %890 = "llvm.xor"(%889, %886) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %891 = "llvm.and"(%867, %825) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %892 = "llvm.xor"(%867, %49) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %893 = "llvm.and"(%765, %892) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %894 = "llvm.or"(%891, %893) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %895 = "llvm.add"(%881, %764) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %896 = "llvm.add"(%895, %885) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %897 = "llvm.add"(%896, %894) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %898 = "llvm.add"(%897, %890) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %899 = "llvm.intr.fshl"(%868, %868, %51) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %900 = "llvm.intr.fshl"(%868, %868, %52) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %901 = "llvm.intr.fshl"(%868, %868, %53) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %902 = "llvm.xor"(%900, %901) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %903 = "llvm.xor"(%902, %899) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %904 = "llvm.and"(%868, %826) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %905 = "llvm.xor"(%868, %826) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %906 = "llvm.and"(%905, %769) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %907 = "llvm.xor"(%906, %904) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %908 = "llvm.add"(%903, %907) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %909 = "llvm.add"(%898, %768) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %910 = "llvm.add"(%908, %898) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %911 = "llvm.intr.fshl"(%773, %773, %69) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %912 = "llvm.intr.fshl"(%773, %773, %70) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %913 = "llvm.lshr"(%773, %35) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %914 = "llvm.xor"(%912, %913) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %915 = "llvm.xor"(%914, %911) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %916 = "llvm.intr.fshl"(%839, %839, %71) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %917 = "llvm.intr.fshl"(%839, %839, %72) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %918 = "llvm.lshr"(%839, %73) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %919 = "llvm.xor"(%917, %918) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %920 = "llvm.xor"(%919, %916) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %921 = "llvm.add"(%772, %781) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %922 = "llvm.add"(%921, %915) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %923 = "llvm.add"(%922, %920) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %924 = "llvm.getelementptr"(%798) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %925 = "llvm.load"(%924) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %926 = "llvm.insertelement"(%32, %925, %2) : (vector<8xi64>, i64, i64) -> vector<8xi64>
  %927 = "llvm.shufflevector"(%926, %32) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %928 = "llvm.intr.fshl"(%909, %909, %46) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %929 = "llvm.intr.fshl"(%909, %909, %47) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %930 = "llvm.intr.fshl"(%909, %909, %48) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %931 = "llvm.xor"(%929, %930) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %932 = "llvm.xor"(%931, %928) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %933 = "llvm.and"(%909, %867) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %934 = "llvm.xor"(%909, %49) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %935 = "llvm.and"(%825, %934) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %936 = "llvm.or"(%933, %935) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %937 = "llvm.add"(%923, %765) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %938 = "llvm.add"(%937, %927) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %939 = "llvm.add"(%938, %936) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %940 = "llvm.add"(%939, %932) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %941 = "llvm.intr.fshl"(%910, %910, %51) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %942 = "llvm.intr.fshl"(%910, %910, %52) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %943 = "llvm.intr.fshl"(%910, %910, %53) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %944 = "llvm.xor"(%942, %943) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %945 = "llvm.xor"(%944, %941) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %946 = "llvm.and"(%910, %868) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %947 = "llvm.xor"(%910, %868) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %948 = "llvm.and"(%947, %826) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %949 = "llvm.xor"(%948, %946) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %950 = "llvm.add"(%945, %949) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %951 = "llvm.add"(%940, %769) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %952 = "llvm.add"(%950, %940) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %953 = "llvm.intr.fshl"(%774, %774, %69) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %954 = "llvm.intr.fshl"(%774, %774, %70) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %955 = "llvm.lshr"(%774, %35) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %956 = "llvm.xor"(%954, %955) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %957 = "llvm.xor"(%956, %953) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %958 = "llvm.intr.fshl"(%881, %881, %71) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %959 = "llvm.intr.fshl"(%881, %881, %72) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %960 = "llvm.lshr"(%881, %73) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %961 = "llvm.xor"(%959, %960) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %962 = "llvm.xor"(%961, %958) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %963 = "llvm.add"(%773, %782) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %964 = "llvm.add"(%963, %957) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %965 = "llvm.add"(%964, %962) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %966 = "llvm.getelementptr"(%798) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %967 = "llvm.load"(%966) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %968 = "llvm.insertelement"(%32, %967, %2) : (vector<8xi64>, i64, i64) -> vector<8xi64>
  %969 = "llvm.shufflevector"(%968, %32) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %970 = "llvm.intr.fshl"(%951, %951, %46) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %971 = "llvm.intr.fshl"(%951, %951, %47) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %972 = "llvm.intr.fshl"(%951, %951, %48) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %973 = "llvm.xor"(%971, %972) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %974 = "llvm.xor"(%973, %970) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %975 = "llvm.and"(%951, %909) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %976 = "llvm.xor"(%951, %49) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %977 = "llvm.and"(%867, %976) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %978 = "llvm.or"(%975, %977) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %979 = "llvm.add"(%825, %965) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %980 = "llvm.add"(%979, %969) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %981 = "llvm.add"(%980, %978) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %982 = "llvm.add"(%981, %974) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %983 = "llvm.intr.fshl"(%952, %952, %51) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %984 = "llvm.intr.fshl"(%952, %952, %52) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %985 = "llvm.intr.fshl"(%952, %952, %53) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %986 = "llvm.xor"(%984, %985) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %987 = "llvm.xor"(%986, %983) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %988 = "llvm.and"(%952, %910) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %989 = "llvm.xor"(%952, %910) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %990 = "llvm.and"(%989, %868) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %991 = "llvm.xor"(%990, %988) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %992 = "llvm.add"(%987, %991) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %993 = "llvm.add"(%982, %826) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %994 = "llvm.add"(%992, %982) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %995 = "llvm.intr.fshl"(%775, %775, %69) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %996 = "llvm.intr.fshl"(%775, %775, %70) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %997 = "llvm.lshr"(%775, %35) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %998 = "llvm.xor"(%996, %997) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %999 = "llvm.xor"(%998, %995) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1000 = "llvm.intr.fshl"(%923, %923, %71) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1001 = "llvm.intr.fshl"(%923, %923, %72) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1002 = "llvm.lshr"(%923, %73) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1003 = "llvm.xor"(%1001, %1002) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1004 = "llvm.xor"(%1003, %1000) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1005 = "llvm.add"(%774, %783) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1006 = "llvm.add"(%1005, %999) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1007 = "llvm.add"(%1006, %1004) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1008 = "llvm.getelementptr"(%798) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 40>}> : (!llvm.ptr) -> !llvm.ptr
  %1009 = "llvm.load"(%1008) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %1010 = "llvm.insertelement"(%32, %1009, %2) : (vector<8xi64>, i64, i64) -> vector<8xi64>
  %1011 = "llvm.shufflevector"(%1010, %32) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1012 = "llvm.intr.fshl"(%993, %993, %46) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1013 = "llvm.intr.fshl"(%993, %993, %47) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1014 = "llvm.intr.fshl"(%993, %993, %48) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1015 = "llvm.xor"(%1013, %1014) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1016 = "llvm.xor"(%1015, %1012) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1017 = "llvm.and"(%993, %951) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1018 = "llvm.xor"(%993, %49) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1019 = "llvm.and"(%909, %1018) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1020 = "llvm.or"(%1017, %1019) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1021 = "llvm.add"(%1011, %1007) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1022 = "llvm.add"(%1021, %867) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1023 = "llvm.add"(%1022, %1020) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1024 = "llvm.add"(%1023, %1016) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1025 = "llvm.intr.fshl"(%994, %994, %51) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1026 = "llvm.intr.fshl"(%994, %994, %52) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1027 = "llvm.intr.fshl"(%994, %994, %53) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1028 = "llvm.xor"(%1026, %1027) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1029 = "llvm.xor"(%1028, %1025) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1030 = "llvm.and"(%994, %952) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1031 = "llvm.xor"(%994, %952) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1032 = "llvm.and"(%1031, %910) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1033 = "llvm.xor"(%1032, %1030) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1034 = "llvm.add"(%1029, %1033) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1035 = "llvm.add"(%1024, %868) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1036 = "llvm.add"(%1034, %1024) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1037 = "llvm.intr.fshl"(%776, %776, %69) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1038 = "llvm.intr.fshl"(%776, %776, %70) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1039 = "llvm.lshr"(%776, %35) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1040 = "llvm.xor"(%1038, %1039) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1041 = "llvm.xor"(%1040, %1037) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1042 = "llvm.intr.fshl"(%965, %965, %71) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1043 = "llvm.intr.fshl"(%965, %965, %72) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1044 = "llvm.lshr"(%965, %73) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1045 = "llvm.xor"(%1043, %1044) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1046 = "llvm.xor"(%1045, %1042) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1047 = "llvm.add"(%775, %784) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1048 = "llvm.add"(%1047, %1041) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1049 = "llvm.add"(%1048, %1046) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1050 = "llvm.getelementptr"(%798) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 48>}> : (!llvm.ptr) -> !llvm.ptr
  %1051 = "llvm.load"(%1050) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %1052 = "llvm.insertelement"(%32, %1051, %2) : (vector<8xi64>, i64, i64) -> vector<8xi64>
  %1053 = "llvm.shufflevector"(%1052, %32) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1054 = "llvm.intr.fshl"(%1035, %1035, %46) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1055 = "llvm.intr.fshl"(%1035, %1035, %47) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1056 = "llvm.intr.fshl"(%1035, %1035, %48) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1057 = "llvm.xor"(%1055, %1056) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1058 = "llvm.xor"(%1057, %1054) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1059 = "llvm.and"(%1035, %993) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1060 = "llvm.xor"(%1035, %49) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1061 = "llvm.and"(%951, %1060) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1062 = "llvm.or"(%1059, %1061) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1063 = "llvm.add"(%1053, %1049) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1064 = "llvm.add"(%1063, %909) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1065 = "llvm.add"(%1064, %1062) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1066 = "llvm.add"(%1065, %1058) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1067 = "llvm.intr.fshl"(%1036, %1036, %51) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1068 = "llvm.intr.fshl"(%1036, %1036, %52) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1069 = "llvm.intr.fshl"(%1036, %1036, %53) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1070 = "llvm.xor"(%1068, %1069) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1071 = "llvm.xor"(%1070, %1067) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1072 = "llvm.and"(%1036, %994) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1073 = "llvm.xor"(%1036, %994) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1074 = "llvm.and"(%1073, %952) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1075 = "llvm.xor"(%1074, %1072) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1076 = "llvm.add"(%1071, %1075) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1077 = "llvm.add"(%1066, %910) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1078 = "llvm.add"(%1076, %1066) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1079 = "llvm.intr.fshl"(%777, %777, %69) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1080 = "llvm.intr.fshl"(%777, %777, %70) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1081 = "llvm.lshr"(%777, %35) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1082 = "llvm.xor"(%1080, %1081) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1083 = "llvm.xor"(%1082, %1079) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1084 = "llvm.intr.fshl"(%1007, %1007, %71) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1085 = "llvm.intr.fshl"(%1007, %1007, %72) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1086 = "llvm.lshr"(%1007, %73) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1087 = "llvm.xor"(%1085, %1086) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1088 = "llvm.xor"(%1087, %1084) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1089 = "llvm.add"(%1083, %776) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1090 = "llvm.add"(%1089, %797) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1091 = "llvm.add"(%1090, %1088) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1092 = "llvm.getelementptr"(%798) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 56>}> : (!llvm.ptr) -> !llvm.ptr
  %1093 = "llvm.load"(%1092) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %1094 = "llvm.insertelement"(%32, %1093, %2) : (vector<8xi64>, i64, i64) -> vector<8xi64>
  %1095 = "llvm.shufflevector"(%1094, %32) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1096 = "llvm.intr.fshl"(%1077, %1077, %46) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1097 = "llvm.intr.fshl"(%1077, %1077, %47) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1098 = "llvm.intr.fshl"(%1077, %1077, %48) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1099 = "llvm.xor"(%1097, %1098) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1100 = "llvm.xor"(%1099, %1096) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1101 = "llvm.and"(%1077, %1035) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1102 = "llvm.xor"(%1077, %49) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1103 = "llvm.and"(%993, %1102) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1104 = "llvm.or"(%1101, %1103) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1105 = "llvm.add"(%1095, %1091) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1106 = "llvm.add"(%1105, %951) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1107 = "llvm.add"(%1106, %1104) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1108 = "llvm.add"(%1107, %1100) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1109 = "llvm.intr.fshl"(%1078, %1078, %51) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1110 = "llvm.intr.fshl"(%1078, %1078, %52) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1111 = "llvm.intr.fshl"(%1078, %1078, %53) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1112 = "llvm.xor"(%1110, %1111) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1113 = "llvm.xor"(%1112, %1109) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1114 = "llvm.and"(%1078, %1036) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1115 = "llvm.xor"(%1078, %1036) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1116 = "llvm.and"(%1115, %994) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1117 = "llvm.xor"(%1116, %1114) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1118 = "llvm.add"(%1113, %1117) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1119 = "llvm.add"(%1108, %952) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1120 = "llvm.add"(%1118, %1108) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1121 = "llvm.intr.fshl"(%778, %778, %69) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1122 = "llvm.intr.fshl"(%778, %778, %70) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1123 = "llvm.lshr"(%778, %35) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1124 = "llvm.xor"(%1122, %1123) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1125 = "llvm.xor"(%1124, %1121) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1126 = "llvm.intr.fshl"(%1049, %1049, %71) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1127 = "llvm.intr.fshl"(%1049, %1049, %72) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1128 = "llvm.lshr"(%1049, %73) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1129 = "llvm.xor"(%1127, %1128) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1130 = "llvm.xor"(%1129, %1126) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1131 = "llvm.add"(%1125, %777) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1132 = "llvm.add"(%1131, %839) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1133 = "llvm.add"(%1132, %1130) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1134 = "llvm.getelementptr"(%798) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %1135 = "llvm.load"(%1134) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %1136 = "llvm.insertelement"(%32, %1135, %2) : (vector<8xi64>, i64, i64) -> vector<8xi64>
  %1137 = "llvm.shufflevector"(%1136, %32) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1138 = "llvm.intr.fshl"(%1119, %1119, %46) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1139 = "llvm.intr.fshl"(%1119, %1119, %47) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1140 = "llvm.intr.fshl"(%1119, %1119, %48) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1141 = "llvm.xor"(%1139, %1140) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1142 = "llvm.xor"(%1141, %1138) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1143 = "llvm.and"(%1119, %1077) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1144 = "llvm.xor"(%1119, %49) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1145 = "llvm.and"(%1035, %1144) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1146 = "llvm.or"(%1143, %1145) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1147 = "llvm.add"(%1137, %1133) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1148 = "llvm.add"(%1147, %993) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1149 = "llvm.add"(%1148, %1146) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1150 = "llvm.add"(%1149, %1142) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1151 = "llvm.intr.fshl"(%1120, %1120, %51) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1152 = "llvm.intr.fshl"(%1120, %1120, %52) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1153 = "llvm.intr.fshl"(%1120, %1120, %53) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1154 = "llvm.xor"(%1152, %1153) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1155 = "llvm.xor"(%1154, %1151) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1156 = "llvm.and"(%1120, %1078) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1157 = "llvm.xor"(%1120, %1078) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1158 = "llvm.and"(%1157, %1036) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1159 = "llvm.xor"(%1158, %1156) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1160 = "llvm.add"(%1155, %1159) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1161 = "llvm.add"(%1150, %994) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1162 = "llvm.add"(%1160, %1150) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1163 = "llvm.intr.fshl"(%779, %779, %69) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1164 = "llvm.intr.fshl"(%779, %779, %70) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1165 = "llvm.lshr"(%779, %35) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1166 = "llvm.xor"(%1164, %1165) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1167 = "llvm.xor"(%1166, %1163) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1168 = "llvm.intr.fshl"(%1091, %1091, %71) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1169 = "llvm.intr.fshl"(%1091, %1091, %72) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1170 = "llvm.lshr"(%1091, %73) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1171 = "llvm.xor"(%1169, %1170) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1172 = "llvm.xor"(%1171, %1168) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1173 = "llvm.add"(%1167, %778) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1174 = "llvm.add"(%1173, %881) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1175 = "llvm.add"(%1174, %1172) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1176 = "llvm.getelementptr"(%798) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 72>}> : (!llvm.ptr) -> !llvm.ptr
  %1177 = "llvm.load"(%1176) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %1178 = "llvm.insertelement"(%32, %1177, %2) : (vector<8xi64>, i64, i64) -> vector<8xi64>
  %1179 = "llvm.shufflevector"(%1178, %32) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1180 = "llvm.intr.fshl"(%1161, %1161, %46) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1181 = "llvm.intr.fshl"(%1161, %1161, %47) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1182 = "llvm.intr.fshl"(%1161, %1161, %48) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1183 = "llvm.xor"(%1181, %1182) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1184 = "llvm.xor"(%1183, %1180) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1185 = "llvm.and"(%1161, %1119) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1186 = "llvm.xor"(%1161, %49) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1187 = "llvm.and"(%1077, %1186) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1188 = "llvm.or"(%1185, %1187) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1189 = "llvm.add"(%1179, %1175) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1190 = "llvm.add"(%1189, %1035) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1191 = "llvm.add"(%1190, %1188) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1192 = "llvm.add"(%1191, %1184) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1193 = "llvm.intr.fshl"(%1162, %1162, %51) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1194 = "llvm.intr.fshl"(%1162, %1162, %52) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1195 = "llvm.intr.fshl"(%1162, %1162, %53) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1196 = "llvm.xor"(%1194, %1195) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1197 = "llvm.xor"(%1196, %1193) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1198 = "llvm.and"(%1162, %1120) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1199 = "llvm.xor"(%1162, %1120) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1200 = "llvm.and"(%1199, %1078) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1201 = "llvm.xor"(%1200, %1198) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1202 = "llvm.add"(%1197, %1201) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1203 = "llvm.add"(%1192, %1036) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1204 = "llvm.add"(%1202, %1192) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1205 = "llvm.intr.fshl"(%780, %780, %69) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1206 = "llvm.intr.fshl"(%780, %780, %70) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1207 = "llvm.lshr"(%780, %35) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1208 = "llvm.xor"(%1206, %1207) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1209 = "llvm.xor"(%1208, %1205) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1210 = "llvm.intr.fshl"(%1133, %1133, %71) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1211 = "llvm.intr.fshl"(%1133, %1133, %72) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1212 = "llvm.lshr"(%1133, %73) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1213 = "llvm.xor"(%1211, %1212) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1214 = "llvm.xor"(%1213, %1210) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1215 = "llvm.add"(%1209, %779) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1216 = "llvm.add"(%1215, %923) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1217 = "llvm.add"(%1216, %1214) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1218 = "llvm.getelementptr"(%798) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 80>}> : (!llvm.ptr) -> !llvm.ptr
  %1219 = "llvm.load"(%1218) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %1220 = "llvm.insertelement"(%32, %1219, %2) : (vector<8xi64>, i64, i64) -> vector<8xi64>
  %1221 = "llvm.shufflevector"(%1220, %32) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1222 = "llvm.intr.fshl"(%1203, %1203, %46) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1223 = "llvm.intr.fshl"(%1203, %1203, %47) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1224 = "llvm.intr.fshl"(%1203, %1203, %48) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1225 = "llvm.xor"(%1223, %1224) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1226 = "llvm.xor"(%1225, %1222) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1227 = "llvm.and"(%1203, %1161) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1228 = "llvm.xor"(%1203, %49) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1229 = "llvm.and"(%1119, %1228) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1230 = "llvm.or"(%1227, %1229) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1231 = "llvm.add"(%1221, %1217) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1232 = "llvm.add"(%1231, %1077) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1233 = "llvm.add"(%1232, %1230) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1234 = "llvm.add"(%1233, %1226) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1235 = "llvm.intr.fshl"(%1204, %1204, %51) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1236 = "llvm.intr.fshl"(%1204, %1204, %52) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1237 = "llvm.intr.fshl"(%1204, %1204, %53) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1238 = "llvm.xor"(%1236, %1237) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1239 = "llvm.xor"(%1238, %1235) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1240 = "llvm.and"(%1204, %1162) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1241 = "llvm.xor"(%1204, %1162) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1242 = "llvm.and"(%1241, %1120) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1243 = "llvm.xor"(%1242, %1240) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1244 = "llvm.add"(%1239, %1243) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1245 = "llvm.add"(%1234, %1078) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1246 = "llvm.add"(%1244, %1234) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1247 = "llvm.intr.fshl"(%781, %781, %69) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1248 = "llvm.intr.fshl"(%781, %781, %70) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1249 = "llvm.lshr"(%781, %35) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1250 = "llvm.xor"(%1248, %1249) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1251 = "llvm.xor"(%1250, %1247) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1252 = "llvm.intr.fshl"(%1175, %1175, %71) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1253 = "llvm.intr.fshl"(%1175, %1175, %72) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1254 = "llvm.lshr"(%1175, %73) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1255 = "llvm.xor"(%1253, %1254) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1256 = "llvm.xor"(%1255, %1252) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1257 = "llvm.add"(%1251, %780) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1258 = "llvm.add"(%1257, %965) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1259 = "llvm.add"(%1258, %1256) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1260 = "llvm.getelementptr"(%798) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 88>}> : (!llvm.ptr) -> !llvm.ptr
  %1261 = "llvm.load"(%1260) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %1262 = "llvm.insertelement"(%32, %1261, %2) : (vector<8xi64>, i64, i64) -> vector<8xi64>
  %1263 = "llvm.shufflevector"(%1262, %32) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1264 = "llvm.intr.fshl"(%1245, %1245, %46) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1265 = "llvm.intr.fshl"(%1245, %1245, %47) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1266 = "llvm.intr.fshl"(%1245, %1245, %48) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1267 = "llvm.xor"(%1265, %1266) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1268 = "llvm.xor"(%1267, %1264) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1269 = "llvm.and"(%1245, %1203) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1270 = "llvm.xor"(%1245, %49) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1271 = "llvm.and"(%1161, %1270) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1272 = "llvm.or"(%1269, %1271) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1273 = "llvm.add"(%1263, %1259) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1274 = "llvm.add"(%1273, %1119) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1275 = "llvm.add"(%1274, %1272) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1276 = "llvm.add"(%1275, %1268) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1277 = "llvm.intr.fshl"(%1246, %1246, %51) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1278 = "llvm.intr.fshl"(%1246, %1246, %52) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1279 = "llvm.intr.fshl"(%1246, %1246, %53) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1280 = "llvm.xor"(%1278, %1279) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1281 = "llvm.xor"(%1280, %1277) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1282 = "llvm.and"(%1246, %1204) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1283 = "llvm.xor"(%1246, %1204) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1284 = "llvm.and"(%1283, %1162) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1285 = "llvm.xor"(%1284, %1282) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1286 = "llvm.add"(%1281, %1285) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1287 = "llvm.add"(%1276, %1120) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1288 = "llvm.add"(%1286, %1276) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1289 = "llvm.intr.fshl"(%782, %782, %69) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1290 = "llvm.intr.fshl"(%782, %782, %70) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1291 = "llvm.lshr"(%782, %35) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1292 = "llvm.xor"(%1290, %1291) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1293 = "llvm.xor"(%1292, %1289) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1294 = "llvm.intr.fshl"(%1217, %1217, %71) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1295 = "llvm.intr.fshl"(%1217, %1217, %72) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1296 = "llvm.lshr"(%1217, %73) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1297 = "llvm.xor"(%1295, %1296) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1298 = "llvm.xor"(%1297, %1294) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1299 = "llvm.add"(%1293, %781) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1300 = "llvm.add"(%1299, %1007) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1301 = "llvm.add"(%1300, %1298) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1302 = "llvm.getelementptr"(%798) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 96>}> : (!llvm.ptr) -> !llvm.ptr
  %1303 = "llvm.load"(%1302) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %1304 = "llvm.insertelement"(%32, %1303, %2) : (vector<8xi64>, i64, i64) -> vector<8xi64>
  %1305 = "llvm.shufflevector"(%1304, %32) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1306 = "llvm.intr.fshl"(%1287, %1287, %46) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1307 = "llvm.intr.fshl"(%1287, %1287, %47) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1308 = "llvm.intr.fshl"(%1287, %1287, %48) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1309 = "llvm.xor"(%1307, %1308) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1310 = "llvm.xor"(%1309, %1306) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1311 = "llvm.and"(%1287, %1245) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1312 = "llvm.xor"(%1287, %49) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1313 = "llvm.and"(%1203, %1312) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1314 = "llvm.or"(%1311, %1313) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1315 = "llvm.add"(%1305, %1301) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1316 = "llvm.add"(%1315, %1161) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1317 = "llvm.add"(%1316, %1314) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1318 = "llvm.add"(%1317, %1310) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1319 = "llvm.intr.fshl"(%1288, %1288, %51) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1320 = "llvm.intr.fshl"(%1288, %1288, %52) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1321 = "llvm.intr.fshl"(%1288, %1288, %53) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1322 = "llvm.xor"(%1320, %1321) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1323 = "llvm.xor"(%1322, %1319) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1324 = "llvm.and"(%1288, %1246) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1325 = "llvm.xor"(%1288, %1246) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1326 = "llvm.and"(%1325, %1204) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1327 = "llvm.xor"(%1326, %1324) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1328 = "llvm.add"(%1323, %1327) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1329 = "llvm.add"(%1318, %1162) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1330 = "llvm.add"(%1328, %1318) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1331 = "llvm.intr.fshl"(%783, %783, %69) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1332 = "llvm.intr.fshl"(%783, %783, %70) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1333 = "llvm.lshr"(%783, %35) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1334 = "llvm.xor"(%1332, %1333) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1335 = "llvm.xor"(%1334, %1331) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1336 = "llvm.intr.fshl"(%1259, %1259, %71) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1337 = "llvm.intr.fshl"(%1259, %1259, %72) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1338 = "llvm.lshr"(%1259, %73) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1339 = "llvm.xor"(%1337, %1338) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1340 = "llvm.xor"(%1339, %1336) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1341 = "llvm.add"(%1335, %782) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1342 = "llvm.add"(%1341, %1049) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1343 = "llvm.add"(%1342, %1340) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1344 = "llvm.getelementptr"(%798) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 104>}> : (!llvm.ptr) -> !llvm.ptr
  %1345 = "llvm.load"(%1344) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %1346 = "llvm.insertelement"(%32, %1345, %2) : (vector<8xi64>, i64, i64) -> vector<8xi64>
  %1347 = "llvm.shufflevector"(%1346, %32) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1348 = "llvm.intr.fshl"(%1329, %1329, %46) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1349 = "llvm.intr.fshl"(%1329, %1329, %47) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1350 = "llvm.intr.fshl"(%1329, %1329, %48) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1351 = "llvm.xor"(%1349, %1350) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1352 = "llvm.xor"(%1351, %1348) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1353 = "llvm.and"(%1329, %1287) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1354 = "llvm.xor"(%1329, %49) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1355 = "llvm.and"(%1245, %1354) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1356 = "llvm.or"(%1353, %1355) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1357 = "llvm.add"(%1347, %1343) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1358 = "llvm.add"(%1357, %1203) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1359 = "llvm.add"(%1358, %1356) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1360 = "llvm.add"(%1359, %1352) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1361 = "llvm.intr.fshl"(%1330, %1330, %51) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1362 = "llvm.intr.fshl"(%1330, %1330, %52) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1363 = "llvm.intr.fshl"(%1330, %1330, %53) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1364 = "llvm.xor"(%1362, %1363) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1365 = "llvm.xor"(%1364, %1361) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1366 = "llvm.and"(%1330, %1288) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1367 = "llvm.xor"(%1330, %1288) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1368 = "llvm.and"(%1367, %1246) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1369 = "llvm.xor"(%1368, %1366) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1370 = "llvm.add"(%1365, %1369) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1371 = "llvm.add"(%1360, %1204) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1372 = "llvm.add"(%1370, %1360) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1373 = "llvm.intr.fshl"(%784, %784, %69) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1374 = "llvm.intr.fshl"(%784, %784, %70) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1375 = "llvm.lshr"(%784, %35) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1376 = "llvm.xor"(%1374, %1375) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1377 = "llvm.xor"(%1376, %1373) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1378 = "llvm.intr.fshl"(%1301, %1301, %71) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1379 = "llvm.intr.fshl"(%1301, %1301, %72) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1380 = "llvm.lshr"(%1301, %73) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1381 = "llvm.xor"(%1379, %1380) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1382 = "llvm.xor"(%1381, %1378) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1383 = "llvm.add"(%1377, %783) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1384 = "llvm.add"(%1383, %1091) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1385 = "llvm.add"(%1384, %1382) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1386 = "llvm.getelementptr"(%798) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 112>}> : (!llvm.ptr) -> !llvm.ptr
  %1387 = "llvm.load"(%1386) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %1388 = "llvm.insertelement"(%32, %1387, %2) : (vector<8xi64>, i64, i64) -> vector<8xi64>
  %1389 = "llvm.shufflevector"(%1388, %32) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1390 = "llvm.intr.fshl"(%1371, %1371, %46) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1391 = "llvm.intr.fshl"(%1371, %1371, %47) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1392 = "llvm.intr.fshl"(%1371, %1371, %48) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1393 = "llvm.xor"(%1391, %1392) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1394 = "llvm.xor"(%1393, %1390) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1395 = "llvm.and"(%1371, %1329) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1396 = "llvm.xor"(%1371, %49) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1397 = "llvm.and"(%1287, %1396) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1398 = "llvm.or"(%1395, %1397) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1399 = "llvm.add"(%1389, %1385) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1400 = "llvm.add"(%1399, %1245) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1401 = "llvm.add"(%1400, %1398) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1402 = "llvm.add"(%1401, %1394) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1403 = "llvm.intr.fshl"(%1372, %1372, %51) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1404 = "llvm.intr.fshl"(%1372, %1372, %52) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1405 = "llvm.intr.fshl"(%1372, %1372, %53) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1406 = "llvm.xor"(%1404, %1405) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1407 = "llvm.xor"(%1406, %1403) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1408 = "llvm.and"(%1372, %1330) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1409 = "llvm.xor"(%1372, %1330) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1410 = "llvm.and"(%1409, %1288) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1411 = "llvm.xor"(%1410, %1408) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1412 = "llvm.add"(%1407, %1411) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1413 = "llvm.add"(%1402, %1246) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1414 = "llvm.add"(%1412, %1402) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1415 = "llvm.intr.fshl"(%797, %797, %69) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1416 = "llvm.intr.fshl"(%797, %797, %70) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1417 = "llvm.lshr"(%797, %35) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1418 = "llvm.xor"(%1416, %1417) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1419 = "llvm.xor"(%1418, %1415) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1420 = "llvm.intr.fshl"(%1343, %1343, %71) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1421 = "llvm.intr.fshl"(%1343, %1343, %72) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1422 = "llvm.lshr"(%1343, %73) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1423 = "llvm.xor"(%1421, %1422) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1424 = "llvm.xor"(%1423, %1420) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1425 = "llvm.add"(%1419, %784) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1426 = "llvm.add"(%1425, %1133) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1427 = "llvm.add"(%1426, %1424) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1428 = "llvm.getelementptr"(%798) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 120>}> : (!llvm.ptr) -> !llvm.ptr
  %1429 = "llvm.load"(%1428) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %1430 = "llvm.insertelement"(%32, %1429, %2) : (vector<8xi64>, i64, i64) -> vector<8xi64>
  %1431 = "llvm.shufflevector"(%1430, %32) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1432 = "llvm.intr.fshl"(%1413, %1413, %46) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1433 = "llvm.intr.fshl"(%1413, %1413, %47) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1434 = "llvm.intr.fshl"(%1413, %1413, %48) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1435 = "llvm.xor"(%1433, %1434) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1436 = "llvm.xor"(%1435, %1432) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1437 = "llvm.and"(%1413, %1371) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1438 = "llvm.xor"(%1413, %49) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1439 = "llvm.and"(%1329, %1438) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1440 = "llvm.or"(%1437, %1439) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1441 = "llvm.add"(%1431, %1427) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1442 = "llvm.add"(%1441, %1287) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1443 = "llvm.add"(%1442, %1440) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1444 = "llvm.add"(%1443, %1436) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1445 = "llvm.intr.fshl"(%1414, %1414, %51) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1446 = "llvm.intr.fshl"(%1414, %1414, %52) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1447 = "llvm.intr.fshl"(%1414, %1414, %53) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1448 = "llvm.xor"(%1446, %1447) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1449 = "llvm.xor"(%1448, %1445) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1450 = "llvm.and"(%1414, %1372) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1451 = "llvm.xor"(%1414, %1372) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1452 = "llvm.and"(%1451, %1330) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1453 = "llvm.xor"(%1452, %1450) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1454 = "llvm.add"(%1449, %1453) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1455 = "llvm.add"(%1444, %1288) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1456 = "llvm.add"(%1454, %1444) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1457 = "llvm.add"(%761, %20) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1458 = "llvm.icmp"(%761, %9) <{predicate = 6 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1458, %797, %1457, %1329, %1371, %1413, %1455, %1330, %1372, %1414, %1456, %839, %881, %923, %965, %1007, %1049, %1091, %1133, %1175, %1217, %1259, %1301, %1343, %1385, %1427)[^bb20, ^bb21] <{loop_annotation = #llvm.loop_annotation<mustProgress = true>, operandSegmentSizes = array<i32: 1, 25, 0>}> : (i1, vector<8xi64>, i64, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>) -> ()
^bb21:  // pred: ^bb20
  %1459 = "llvm.select"(%242, %1456, %8) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1460 = "llvm.add"(%1459, %243) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1461 = "llvm.select"(%242, %1414, %8) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1462 = "llvm.add"(%1461, %244) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1463 = "llvm.select"(%242, %1372, %8) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1464 = "llvm.add"(%1463, %245) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1465 = "llvm.select"(%242, %1330, %8) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1466 = "llvm.add"(%1465, %246) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1467 = "llvm.select"(%242, %1455, %8) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1468 = "llvm.add"(%1467, %247) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1469 = "llvm.select"(%242, %1413, %8) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1470 = "llvm.add"(%1469, %248) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1471 = "llvm.select"(%242, %1371, %8) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1472 = "llvm.add"(%1471, %249) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1473 = "llvm.select"(%242, %1329, %8) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1474 = "llvm.add"(%1473, %250) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1475 = "llvm.add"(%254, %75) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1476 = "llvm.intr.usub.sat"(%252, %76) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1477 = "llvm.icmp"(%252, %76) <{predicate = 8 : i64}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi1>
  %1478 = "llvm.bitcast"(%1477) : (vector<8xi1>) -> i8
  %1479 = "llvm.icmp"(%1478, %36) <{predicate = 0 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%1479, %1474, %1472, %1470, %1468, %1466, %1464, %1462, %1460, %1477, %1460, %1462, %1464, %1466, %1468, %1470, %1472, %1474, %1475, %1476)[^bb22, ^bb19] <{branch_weights = array<i32: 127, 255873>, operandSegmentSizes = array<i32: 1, 8, 11>}> : (i1, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi1>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>, vector<8xi64>) -> ()
^bb22(%1480: vector<8xi64>, %1481: vector<8xi64>, %1482: vector<8xi64>, %1483: vector<8xi64>, %1484: vector<8xi64>, %1485: vector<8xi64>, %1486: vector<8xi64>, %1487: vector<8xi64>):  // 2 preds: ^bb3, ^bb21
  %1488 = "llvm.shufflevector"(%1487, %1485) <{mask = array<i32: 0, 1, 4, 5, 8, 9, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1489 = "llvm.shufflevector"(%1486, %1484) <{mask = array<i32: 0, 1, 4, 5, 8, 9, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1490 = "llvm.shufflevector"(%1487, %1485) <{mask = array<i32: 2, 3, 6, 7, 10, 11, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1491 = "llvm.shufflevector"(%1486, %1484) <{mask = array<i32: 2, 3, 6, 7, 10, 11, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1492 = "llvm.shufflevector"(%1483, %1481) <{mask = array<i32: 0, 1, 4, 5, 8, 9, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1493 = "llvm.shufflevector"(%1482, %1480) <{mask = array<i32: 0, 1, 4, 5, 8, 9, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1494 = "llvm.shufflevector"(%1483, %1481) <{mask = array<i32: 2, 3, 6, 7, 10, 11, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1495 = "llvm.shufflevector"(%1482, %1480) <{mask = array<i32: 2, 3, 6, 7, 10, 11, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1496 = "llvm.shufflevector"(%1488, %1492) <{mask = array<i32: 0, 1, 4, 5, 8, 9, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1497 = "llvm.shufflevector"(%1489, %1493) <{mask = array<i32: 0, 1, 4, 5, 8, 9, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1498 = "llvm.shufflevector"(%1490, %1494) <{mask = array<i32: 0, 1, 4, 5, 8, 9, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1499 = "llvm.shufflevector"(%1491, %1495) <{mask = array<i32: 0, 1, 4, 5, 8, 9, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1500 = "llvm.shufflevector"(%1488, %1492) <{mask = array<i32: 2, 3, 6, 7, 10, 11, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1501 = "llvm.shufflevector"(%1489, %1493) <{mask = array<i32: 2, 3, 6, 7, 10, 11, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1502 = "llvm.shufflevector"(%1490, %1494) <{mask = array<i32: 2, 3, 6, 7, 10, 11, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1503 = "llvm.shufflevector"(%1491, %1495) <{mask = array<i32: 2, 3, 6, 7, 10, 11, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1504 = "llvm.shufflevector"(%1496, %1497) <{mask = array<i32: 0, 8, 2, 10, 4, 12, 6, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1505 = "llvm.shufflevector"(%1496, %1497) <{mask = array<i32: 1, 9, 3, 11, 5, 13, 7, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1506 = "llvm.shufflevector"(%1498, %1499) <{mask = array<i32: 0, 8, 2, 10, 4, 12, 6, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1507 = "llvm.shufflevector"(%1498, %1499) <{mask = array<i32: 1, 9, 3, 11, 5, 13, 7, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1508 = "llvm.shufflevector"(%1500, %1501) <{mask = array<i32: 0, 8, 2, 10, 4, 12, 6, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1509 = "llvm.shufflevector"(%1500, %1501) <{mask = array<i32: 1, 9, 3, 11, 5, 13, 7, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1510 = "llvm.shufflevector"(%1502, %1503) <{mask = array<i32: 0, 8, 2, 10, 4, 12, 6, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.switch"(%arg0)[^bb27, ^bb23, ^bb24, ^bb25, ^bb26] <{case_operand_segments = array<i32: 0, 0, 0, 0>, case_values = dense<[8, 7, 6, 5]> : vector<4xi64>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i64) -> ()
^bb23:  // pred: ^bb22
  %1511 = "llvm.shufflevector"(%1502, %1503) <{mask = array<i32: 1, 9, 3, 11, 5, 13, 7, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1512 = "llvm.getelementptr"(%arg3) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 56>}> : (!llvm.ptr) -> !llvm.ptr
  %1513 = "llvm.load"(%1512) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> !llvm.ptr
  %1514 = "llvm.bitcast"(%1511) : (vector<8xi64>) -> vector<64xi8>
  %1515 = "llvm.shufflevector"(%1514, %77) <{mask = array<i32: 7, 6, 5, 4, 3, 2, 1, 0, 15, 14, 13, 12, 11, 10, 9, 8, 23, 22, 21, 20, 19, 18, 17, 16, 31, 30, 29, 28, 27, 26, 25, 24, 39, 38, 37, 36, 35, 34, 33, 32, 47, 46, 45, 44, 43, 42, 41, 40, 55, 54, 53, 52, 51, 50, 49, 48, 63, 62, 61, 60, 59, 58, 57, 56>}> : (vector<64xi8>, vector<64xi8>) -> vector<64xi8>
  "llvm.store"(%1515, %1513) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<64xi8>, !llvm.ptr) -> ()
  "llvm.br"()[^bb24] : () -> ()
^bb24:  // 2 preds: ^bb22, ^bb23
  %1516 = "llvm.getelementptr"(%arg3) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 48>}> : (!llvm.ptr) -> !llvm.ptr
  %1517 = "llvm.load"(%1516) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> !llvm.ptr
  %1518 = "llvm.bitcast"(%1510) : (vector<8xi64>) -> vector<64xi8>
  %1519 = "llvm.shufflevector"(%1518, %77) <{mask = array<i32: 7, 6, 5, 4, 3, 2, 1, 0, 15, 14, 13, 12, 11, 10, 9, 8, 23, 22, 21, 20, 19, 18, 17, 16, 31, 30, 29, 28, 27, 26, 25, 24, 39, 38, 37, 36, 35, 34, 33, 32, 47, 46, 45, 44, 43, 42, 41, 40, 55, 54, 53, 52, 51, 50, 49, 48, 63, 62, 61, 60, 59, 58, 57, 56>}> : (vector<64xi8>, vector<64xi8>) -> vector<64xi8>
  "llvm.store"(%1519, %1517) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<64xi8>, !llvm.ptr) -> ()
  "llvm.br"()[^bb25] : () -> ()
^bb25:  // 2 preds: ^bb22, ^bb24
  %1520 = "llvm.getelementptr"(%arg3) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 40>}> : (!llvm.ptr) -> !llvm.ptr
  %1521 = "llvm.load"(%1520) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> !llvm.ptr
  %1522 = "llvm.bitcast"(%1509) : (vector<8xi64>) -> vector<64xi8>
  %1523 = "llvm.shufflevector"(%1522, %77) <{mask = array<i32: 7, 6, 5, 4, 3, 2, 1, 0, 15, 14, 13, 12, 11, 10, 9, 8, 23, 22, 21, 20, 19, 18, 17, 16, 31, 30, 29, 28, 27, 26, 25, 24, 39, 38, 37, 36, 35, 34, 33, 32, 47, 46, 45, 44, 43, 42, 41, 40, 55, 54, 53, 52, 51, 50, 49, 48, 63, 62, 61, 60, 59, 58, 57, 56>}> : (vector<64xi8>, vector<64xi8>) -> vector<64xi8>
  "llvm.store"(%1523, %1521) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<64xi8>, !llvm.ptr) -> ()
  "llvm.br"()[^bb26] : () -> ()
^bb26:  // 2 preds: ^bb22, ^bb25
  %1524 = "llvm.getelementptr"(%arg3) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %1525 = "llvm.load"(%1524) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> !llvm.ptr
  %1526 = "llvm.bitcast"(%1508) : (vector<8xi64>) -> vector<64xi8>
  %1527 = "llvm.shufflevector"(%1526, %77) <{mask = array<i32: 7, 6, 5, 4, 3, 2, 1, 0, 15, 14, 13, 12, 11, 10, 9, 8, 23, 22, 21, 20, 19, 18, 17, 16, 31, 30, 29, 28, 27, 26, 25, 24, 39, 38, 37, 36, 35, 34, 33, 32, 47, 46, 45, 44, 43, 42, 41, 40, 55, 54, 53, 52, 51, 50, 49, 48, 63, 62, 61, 60, 59, 58, 57, 56>}> : (vector<64xi8>, vector<64xi8>) -> vector<64xi8>
  "llvm.store"(%1527, %1525) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<64xi8>, !llvm.ptr) -> ()
  %1528 = "llvm.getelementptr"(%arg3) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %1529 = "llvm.load"(%1528) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> !llvm.ptr
  %1530 = "llvm.bitcast"(%1507) : (vector<8xi64>) -> vector<64xi8>
  %1531 = "llvm.shufflevector"(%1530, %77) <{mask = array<i32: 7, 6, 5, 4, 3, 2, 1, 0, 15, 14, 13, 12, 11, 10, 9, 8, 23, 22, 21, 20, 19, 18, 17, 16, 31, 30, 29, 28, 27, 26, 25, 24, 39, 38, 37, 36, 35, 34, 33, 32, 47, 46, 45, 44, 43, 42, 41, 40, 55, 54, 53, 52, 51, 50, 49, 48, 63, 62, 61, 60, 59, 58, 57, 56>}> : (vector<64xi8>, vector<64xi8>) -> vector<64xi8>
  "llvm.store"(%1531, %1529) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<64xi8>, !llvm.ptr) -> ()
  %1532 = "llvm.getelementptr"(%arg3) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %1533 = "llvm.load"(%1532) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> !llvm.ptr
  %1534 = "llvm.bitcast"(%1506) : (vector<8xi64>) -> vector<64xi8>
  %1535 = "llvm.shufflevector"(%1534, %77) <{mask = array<i32: 7, 6, 5, 4, 3, 2, 1, 0, 15, 14, 13, 12, 11, 10, 9, 8, 23, 22, 21, 20, 19, 18, 17, 16, 31, 30, 29, 28, 27, 26, 25, 24, 39, 38, 37, 36, 35, 34, 33, 32, 47, 46, 45, 44, 43, 42, 41, 40, 55, 54, 53, 52, 51, 50, 49, 48, 63, 62, 61, 60, 59, 58, 57, 56>}> : (vector<64xi8>, vector<64xi8>) -> vector<64xi8>
  "llvm.store"(%1535, %1533) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<64xi8>, !llvm.ptr) -> ()
  %1536 = "llvm.getelementptr"(%arg3) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %1537 = "llvm.load"(%1536) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> !llvm.ptr
  %1538 = "llvm.bitcast"(%1505) : (vector<8xi64>) -> vector<64xi8>
  %1539 = "llvm.shufflevector"(%1538, %77) <{mask = array<i32: 7, 6, 5, 4, 3, 2, 1, 0, 15, 14, 13, 12, 11, 10, 9, 8, 23, 22, 21, 20, 19, 18, 17, 16, 31, 30, 29, 28, 27, 26, 25, 24, 39, 38, 37, 36, 35, 34, 33, 32, 47, 46, 45, 44, 43, 42, 41, 40, 55, 54, 53, 52, 51, 50, 49, 48, 63, 62, 61, 60, 59, 58, 57, 56>}> : (vector<64xi8>, vector<64xi8>) -> vector<64xi8>
  "llvm.store"(%1539, %1537) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<64xi8>, !llvm.ptr) -> ()
  %1540 = "llvm.load"(%arg3) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> !llvm.ptr
  %1541 = "llvm.bitcast"(%1504) : (vector<8xi64>) -> vector<64xi8>
  %1542 = "llvm.shufflevector"(%1541, %77) <{mask = array<i32: 7, 6, 5, 4, 3, 2, 1, 0, 15, 14, 13, 12, 11, 10, 9, 8, 23, 22, 21, 20, 19, 18, 17, 16, 31, 30, 29, 28, 27, 26, 25, 24, 39, 38, 37, 36, 35, 34, 33, 32, 47, 46, 45, 44, 43, 42, 41, 40, 55, 54, 53, 52, 51, 50, 49, 48, 63, 62, 61, 60, 59, 58, 57, 56>}> : (vector<64xi8>, vector<64xi8>) -> vector<64xi8>
  "llvm.store"(%1542, %1540) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<64xi8>, !llvm.ptr) -> ()
  "llvm.br"()[^bb27] : () -> ()
^bb27:  // 2 preds: ^bb22, ^bb26
  "llvm.intr.lifetime.end"(%80) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%79) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%78) : (!llvm.ptr) -> ()
  "llvm.br"()[^bb28] : () -> ()
^bb28:  // 2 preds: ^bb1, ^bb27
  "llvm.return"() : () -> ()
}) : () -> ()

    with
      @fd_sha512_private_batch_avx512.K := Firedancer.Lane.Mlir.fd_sha512_private_batch_avx512_K,
      @fd_sha512_private_batch_avx := Firedancer.Lane.Mlir.fd_sha512_private_batch_avx

end

end Firedancer.Lane.Mlir
