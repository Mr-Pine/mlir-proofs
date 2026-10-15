
module

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab



namespace Firedancer.LaneNI.Mlir

@[expose] public section

mlir_def fd_curve25519_scalar_muladd := "llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.nofree, llvm.noundef, llvm.returned, llvm.writeonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}], frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<ptr (ptr, ptr, ptr, ptr)>, linkage = #llvm.linkage<external>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", "sspstrong", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "znver4"]], res_attrs = [{llvm.noundef}], sym_name = "fd_curve25519_scalar_muladd", target_cpu = "znver4", target_features = #llvm.target_features<["+64bit", "+adx", "+aes", "+avx", "+avx2", "+avx512bf16", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+clzero", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fast-vector-fsqrt", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+mwaitx", "+pclmul", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdpru", "+rdrnd", "+rdseed", "+sahf", "+sha", "+shstk", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+sse4a", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tile", "-avx10.1", "-avx10.2", "-avx512bmm", "-avx512fp16", "-avx512vp2intersect", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-ccmp", "-cf", "-cldemote", "-cmpccxadd", "-egpr", "-enqcmd", "-fma4", "-hreset", "-jmpabs", "-kl", "-lwp", "-movdir64b", "-movdiri", "-movrs", "-ndd", "-nf", "-pconfig", "-ppx", "-prefetchi", "-ptwrite", "-push2pop2", "-raoint", "-rtm", "-serialize", "-sgx", "-sha512", "-sm3", "-sm4", "-tbm", "-tsxldtrk", "-uintr", "-usermsr", "-waitpkg", "-widekl", "-xop", "-zu"]>, tune_cpu = "znver4", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg0: !llvm.ptr, %arg1: !llvm.ptr, %arg2: !llvm.ptr, %arg3: !llvm.ptr):
  %0 = "llvm.mlir.constant"() <{value = dense<[63, 62, 61, 39]> : vector<4xi64>}> : () -> vector<4xi64>
  %1 = "llvm.mlir.constant"() <{value = dense<[4398044413952, 2199022206976, 1099511103488, 549755551744]> : vector<4xi64>}> : () -> vector<4xi64>
  %2 = "llvm.mlir.constant"() <{value = dense<[21, 20, 19, 18]> : vector<4xi64>}> : () -> vector<4xi64>
  %3 = "llvm.mlir.constant"() <{value = dense<[9223367638808264704, 4611683819404132352, 2305841909702066176, 262143]> : vector<4xi64>}> : () -> vector<4xi64>
  %4 = "llvm.mlir.constant"() <{value = dense<[42, 41, 40, 3]> : vector<4xi64>}> : () -> vector<4xi64>
  %5 = "llvm.mlir.poison"() : () -> vector<4xi64>
  %6 = "llvm.mlir.constant"() <{value = dense<[2097151, 1048575, 524287, 0]> : vector<4xi64>}> : () -> vector<4xi64>
  %7 = "llvm.mlir.constant"() <{value = dense<[0, 1, 2, 0]> : vector<4xi64>}> : () -> vector<4xi64>
  %8 = "llvm.mlir.constant"() <{value = 2 : i64}> : () -> i64
  %9 = "llvm.mlir.constant"() <{value = 3 : i32}> : () -> i32
  %10 = "llvm.mlir.constant"() <{value = 2 : i32}> : () -> i32
  %11 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %12 = "llvm.mlir.constant"() <{value = 2097151 : i64}> : () -> i64
  %13 = "llvm.mlir.constant"() <{value = 21 : i64}> : () -> i64
  %14 = "llvm.mlir.constant"() <{value = 42 : i64}> : () -> i64
  %15 = "llvm.mlir.constant"() <{value = 20 : i64}> : () -> i64
  %16 = "llvm.mlir.constant"() <{value = 41 : i64}> : () -> i64
  %17 = "llvm.mlir.poison"() : () -> vector<2xi64>
  %18 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %19 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %20 = "llvm.mlir.constant"() <{value = dense<[1, 2]> : vector<2xi64>}> : () -> vector<2xi64>
  %21 = "llvm.mlir.constant"() <{value = 19 : i64}> : () -> i64
  %22 = "llvm.mlir.constant"() <{value = 40 : i64}> : () -> i64
  %23 = "llvm.mlir.constant"() <{value = 18 : i64}> : () -> i64
  %24 = "llvm.mlir.constant"() <{value = 39 : i64}> : () -> i64
  %25 = "llvm.mlir.constant"() <{value = dense<[3, 1]> : vector<2xi64>}> : () -> vector<2xi64>
  %26 = "llvm.mlir.constant"() <{value = dense<[2, 3]> : vector<2xi64>}> : () -> vector<2xi64>
  %27 = "llvm.mlir.constant"() <{value = 3 : i64}> : () -> i64
  %28 = "llvm.mlir.constant"() <{value = 1048576 : i64}> : () -> i64
  %29 = "llvm.mlir.constant"() <{value = 17592183947264 : i64}> : () -> i64
  %30 = "llvm.mlir.constant"() <{value = -2097152 : i64}> : () -> i64
  %31 = "llvm.mlir.constant"() <{value = 562949951324160 : i64}> : () -> i64
  %32 = "llvm.mlir.constant"() <{value = 2251799811588096 : i64}> : () -> i64
  %33 = "llvm.mlir.constant"() <{value = 666643 : i64}> : () -> i64
  %34 = "llvm.mlir.constant"() <{value = 470296 : i64}> : () -> i64
  %35 = "llvm.mlir.constant"() <{value = 654183 : i64}> : () -> i64
  %36 = "llvm.mlir.constant"() <{value = -997805 : i64}> : () -> i64
  %37 = "llvm.mlir.constant"() <{value = 136657 : i64}> : () -> i64
  %38 = "llvm.mlir.constant"() <{value = -683901 : i64}> : () -> i64
  %39 = "llvm.mlir.constant"() <{value = -1 : i64}> : () -> i64
  %40 = "llvm.mlir.poison"() : () -> i64
  %41 = "llvm.mlir.undef"() : () -> vector<4xi64>
  %42 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %43 = "llvm.insertelement"(%41, %40, %42) : (vector<4xi64>, i64, i32) -> vector<4xi64>
  %44 = "llvm.insertelement"(%43, %40, %11) : (vector<4xi64>, i64, i32) -> vector<4xi64>
  %45 = "llvm.insertelement"(%44, %40, %10) : (vector<4xi64>, i64, i32) -> vector<4xi64>
  %46 = "llvm.insertelement"(%45, %39, %9) : (vector<4xi64>, i64, i32) -> vector<4xi64>
  %47 = "llvm.load"(%arg1) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %48 = "llvm.load"(%arg2) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %49 = "llvm.load"(%arg3) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %50 = "llvm.getelementptr"(%arg1) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %51 = "llvm.load"(%50) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %52 = "llvm.getelementptr"(%arg2) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %53 = "llvm.load"(%52) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %54 = "llvm.getelementptr"(%arg3) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %55 = "llvm.load"(%54) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %56 = "llvm.getelementptr"(%arg1) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %57 = "llvm.load"(%56) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %58 = "llvm.getelementptr"(%arg2) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %59 = "llvm.load"(%58) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %60 = "llvm.getelementptr"(%arg3) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %61 = "llvm.load"(%60) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %62 = "llvm.getelementptr"(%arg1) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %63 = "llvm.load"(%62) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %64 = "llvm.getelementptr"(%arg2) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %65 = "llvm.load"(%64) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %66 = "llvm.getelementptr"(%arg3) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %67 = "llvm.load"(%66) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %68 = "llvm.and"(%47, %12) : (i64, i64) -> i64
  %69 = "llvm.lshr"(%47, %13) : (i64, i64) -> i64
  %70 = "llvm.and"(%69, %12) : (i64, i64) -> i64
  %71 = "llvm.lshr"(%47, %14) : (i64, i64) -> i64
  %72 = "llvm.and"(%71, %12) : (i64, i64) -> i64
  %73 = "llvm.lshr"(%51, %15) : (i64, i64) -> i64
  %74 = "llvm.and"(%73, %12) : (i64, i64) -> i64
  %75 = "llvm.lshr"(%51, %16) : (i64, i64) -> i64
  %76 = "llvm.and"(%75, %12) : (i64, i64) -> i64
  %77 = "llvm.insertelement"(%17, %51, %18) : (vector<2xi64>, i64, i64) -> vector<2xi64>
  %78 = "llvm.insertelement"(%77, %57, %19) : (vector<2xi64>, i64, i64) -> vector<2xi64>
  %79 = "llvm.insertelement"(%17, %47, %18) : (vector<2xi64>, i64, i64) -> vector<2xi64>
  %80 = "llvm.insertelement"(%79, %51, %19) : (vector<2xi64>, i64, i64) -> vector<2xi64>
  %81 = "llvm.intr.fshl"(%78, %80, %20) : (vector<2xi64>, vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %82 = "llvm.extractelement"(%81, %18) : (vector<2xi64>, i64) -> i64
  %83 = "llvm.and"(%82, %12) : (i64, i64) -> i64
  %84 = "llvm.extractelement"(%81, %19) : (vector<2xi64>, i64) -> i64
  %85 = "llvm.and"(%84, %12) : (i64, i64) -> i64
  %86 = "llvm.lshr"(%57, %21) : (i64, i64) -> i64
  %87 = "llvm.and"(%86, %12) : (i64, i64) -> i64
  %88 = "llvm.lshr"(%57, %22) : (i64, i64) -> i64
  %89 = "llvm.and"(%88, %12) : (i64, i64) -> i64
  %90 = "llvm.lshr"(%63, %23) : (i64, i64) -> i64
  %91 = "llvm.and"(%90, %12) : (i64, i64) -> i64
  %92 = "llvm.lshr"(%63, %24) : (i64, i64) -> i64
  %93 = "llvm.and"(%48, %12) : (i64, i64) -> i64
  %94 = "llvm.lshr"(%48, %13) : (i64, i64) -> i64
  %95 = "llvm.and"(%94, %12) : (i64, i64) -> i64
  %96 = "llvm.lshr"(%48, %14) : (i64, i64) -> i64
  %97 = "llvm.and"(%96, %12) : (i64, i64) -> i64
  %98 = "llvm.insertelement"(%17, %63, %18) : (vector<2xi64>, i64, i64) -> vector<2xi64>
  %99 = "llvm.insertelement"(%98, %53, %19) : (vector<2xi64>, i64, i64) -> vector<2xi64>
  %100 = "llvm.insertelement"(%17, %57, %18) : (vector<2xi64>, i64, i64) -> vector<2xi64>
  %101 = "llvm.insertelement"(%100, %48, %19) : (vector<2xi64>, i64, i64) -> vector<2xi64>
  %102 = "llvm.intr.fshl"(%99, %101, %25) : (vector<2xi64>, vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %103 = "llvm.extractelement"(%102, %18) : (vector<2xi64>, i64) -> i64
  %104 = "llvm.and"(%103, %12) : (i64, i64) -> i64
  %105 = "llvm.extractelement"(%102, %19) : (vector<2xi64>, i64) -> i64
  %106 = "llvm.and"(%105, %12) : (i64, i64) -> i64
  %107 = "llvm.lshr"(%53, %15) : (i64, i64) -> i64
  %108 = "llvm.and"(%107, %12) : (i64, i64) -> i64
  %109 = "llvm.lshr"(%53, %16) : (i64, i64) -> i64
  %110 = "llvm.and"(%109, %12) : (i64, i64) -> i64
  %111 = "llvm.lshr"(%59, %21) : (i64, i64) -> i64
  %112 = "llvm.and"(%111, %12) : (i64, i64) -> i64
  %113 = "llvm.lshr"(%59, %22) : (i64, i64) -> i64
  %114 = "llvm.and"(%113, %12) : (i64, i64) -> i64
  %115 = "llvm.insertelement"(%17, %59, %18) : (vector<2xi64>, i64, i64) -> vector<2xi64>
  %116 = "llvm.insertelement"(%115, %65, %19) : (vector<2xi64>, i64, i64) -> vector<2xi64>
  %117 = "llvm.insertelement"(%17, %53, %18) : (vector<2xi64>, i64, i64) -> vector<2xi64>
  %118 = "llvm.insertelement"(%117, %59, %19) : (vector<2xi64>, i64, i64) -> vector<2xi64>
  %119 = "llvm.intr.fshl"(%116, %118, %26) : (vector<2xi64>, vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %120 = "llvm.extractelement"(%119, %18) : (vector<2xi64>, i64) -> i64
  %121 = "llvm.and"(%120, %12) : (i64, i64) -> i64
  %122 = "llvm.extractelement"(%119, %19) : (vector<2xi64>, i64) -> i64
  %123 = "llvm.and"(%122, %12) : (i64, i64) -> i64
  %124 = "llvm.lshr"(%65, %23) : (i64, i64) -> i64
  %125 = "llvm.and"(%124, %12) : (i64, i64) -> i64
  %126 = "llvm.lshr"(%65, %24) : (i64, i64) -> i64
  %127 = "llvm.and"(%49, %12) : (i64, i64) -> i64
  %128 = "llvm.lshr"(%49, %13) : (i64, i64) -> i64
  %129 = "llvm.and"(%128, %12) : (i64, i64) -> i64
  %130 = "llvm.lshr"(%49, %14) : (i64, i64) -> i64
  %131 = "llvm.and"(%130, %12) : (i64, i64) -> i64
  %132 = "llvm.lshr"(%55, %15) : (i64, i64) -> i64
  %133 = "llvm.and"(%132, %12) : (i64, i64) -> i64
  %134 = "llvm.lshr"(%55, %16) : (i64, i64) -> i64
  %135 = "llvm.and"(%134, %12) : (i64, i64) -> i64
  %136 = "llvm.insertelement"(%17, %55, %18) : (vector<2xi64>, i64, i64) -> vector<2xi64>
  %137 = "llvm.insertelement"(%136, %61, %19) : (vector<2xi64>, i64, i64) -> vector<2xi64>
  %138 = "llvm.insertelement"(%17, %49, %18) : (vector<2xi64>, i64, i64) -> vector<2xi64>
  %139 = "llvm.insertelement"(%138, %55, %19) : (vector<2xi64>, i64, i64) -> vector<2xi64>
  %140 = "llvm.intr.fshl"(%137, %139, %20) : (vector<2xi64>, vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %141 = "llvm.extractelement"(%140, %18) : (vector<2xi64>, i64) -> i64
  %142 = "llvm.and"(%141, %12) : (i64, i64) -> i64
  %143 = "llvm.extractelement"(%140, %19) : (vector<2xi64>, i64) -> i64
  %144 = "llvm.and"(%143, %12) : (i64, i64) -> i64
  %145 = "llvm.lshr"(%61, %21) : (i64, i64) -> i64
  %146 = "llvm.and"(%145, %12) : (i64, i64) -> i64
  %147 = "llvm.lshr"(%61, %22) : (i64, i64) -> i64
  %148 = "llvm.and"(%147, %12) : (i64, i64) -> i64
  %149 = "llvm.intr.fshl"(%67, %61, %27) : (i64, i64, i64) -> i64
  %150 = "llvm.and"(%149, %12) : (i64, i64) -> i64
  %151 = "llvm.lshr"(%67, %23) : (i64, i64) -> i64
  %152 = "llvm.and"(%151, %12) : (i64, i64) -> i64
  %153 = "llvm.lshr"(%67, %24) : (i64, i64) -> i64
  %154 = "llvm.mul"(%93, %68) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %155 = "llvm.add"(%127, %154) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %156 = "llvm.mul"(%95, %68) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %157 = "llvm.mul"(%70, %93) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %158 = "llvm.mul"(%97, %68) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %159 = "llvm.mul"(%95, %70) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %160 = "llvm.mul"(%72, %93) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %161 = "llvm.add"(%158, %160) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %162 = "llvm.add"(%161, %131) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %163 = "llvm.add"(%162, %159) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %164 = "llvm.mul"(%106, %68) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %165 = "llvm.mul"(%97, %70) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %166 = "llvm.mul"(%95, %72) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %167 = "llvm.mul"(%83, %93) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %168 = "llvm.mul"(%108, %68) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %169 = "llvm.mul"(%106, %70) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %170 = "llvm.mul"(%97, %72) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %171 = "llvm.mul"(%83, %95) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %172 = "llvm.mul"(%74, %93) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %173 = "llvm.add"(%171, %170) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %174 = "llvm.add"(%173, %172) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %175 = "llvm.add"(%174, %168) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %176 = "llvm.add"(%175, %133) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %177 = "llvm.add"(%176, %169) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %178 = "llvm.mul"(%110, %68) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %179 = "llvm.mul"(%108, %70) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %180 = "llvm.mul"(%106, %72) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %181 = "llvm.mul"(%83, %97) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %182 = "llvm.mul"(%74, %95) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %183 = "llvm.mul"(%76, %93) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %184 = "llvm.mul"(%121, %68) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %185 = "llvm.mul"(%110, %70) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %186 = "llvm.mul"(%108, %72) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %187 = "llvm.mul"(%106, %83) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %188 = "llvm.mul"(%74, %97) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %189 = "llvm.mul"(%76, %95) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %190 = "llvm.mul"(%85, %93) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %191 = "llvm.add"(%189, %188) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %192 = "llvm.add"(%191, %185) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %193 = "llvm.add"(%192, %186) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %194 = "llvm.add"(%193, %187) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %195 = "llvm.add"(%194, %190) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %196 = "llvm.add"(%195, %184) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %197 = "llvm.add"(%196, %144) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %198 = "llvm.mul"(%112, %68) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %199 = "llvm.mul"(%121, %70) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %200 = "llvm.mul"(%110, %72) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %201 = "llvm.mul"(%108, %83) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %202 = "llvm.mul"(%106, %74) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %203 = "llvm.mul"(%76, %97) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %204 = "llvm.mul"(%85, %95) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %205 = "llvm.mul"(%87, %93) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %206 = "llvm.mul"(%114, %68) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %207 = "llvm.mul"(%112, %70) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %208 = "llvm.mul"(%121, %72) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %209 = "llvm.mul"(%110, %83) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %210 = "llvm.mul"(%108, %74) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %211 = "llvm.mul"(%106, %76) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %212 = "llvm.mul"(%85, %97) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %213 = "llvm.mul"(%87, %95) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %214 = "llvm.mul"(%89, %93) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %215 = "llvm.add"(%210, %209) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %216 = "llvm.add"(%215, %211) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %217 = "llvm.add"(%216, %212) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %218 = "llvm.add"(%217, %213) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %219 = "llvm.add"(%218, %214) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %220 = "llvm.add"(%219, %206) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %221 = "llvm.add"(%220, %148) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %222 = "llvm.add"(%221, %207) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %223 = "llvm.add"(%222, %208) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %224 = "llvm.mul"(%123, %68) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %225 = "llvm.mul"(%114, %70) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %226 = "llvm.mul"(%112, %72) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %227 = "llvm.mul"(%121, %83) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %228 = "llvm.mul"(%110, %74) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %229 = "llvm.mul"(%108, %76) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %230 = "llvm.mul"(%85, %106) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %231 = "llvm.mul"(%87, %97) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %232 = "llvm.mul"(%89, %95) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %233 = "llvm.mul"(%104, %93) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %234 = "llvm.mul"(%125, %68) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %235 = "llvm.mul"(%123, %70) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %236 = "llvm.mul"(%114, %72) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %237 = "llvm.mul"(%112, %83) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %238 = "llvm.mul"(%121, %74) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %239 = "llvm.mul"(%110, %76) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %240 = "llvm.mul"(%85, %108) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %241 = "llvm.mul"(%87, %106) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %242 = "llvm.mul"(%89, %97) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %243 = "llvm.mul"(%104, %95) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %244 = "llvm.mul"(%91, %93) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %245 = "llvm.add"(%240, %239) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %246 = "llvm.add"(%245, %241) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %247 = "llvm.add"(%246, %242) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %248 = "llvm.add"(%247, %236) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %249 = "llvm.add"(%248, %237) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %250 = "llvm.add"(%249, %238) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %251 = "llvm.add"(%250, %243) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %252 = "llvm.add"(%251, %244) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %253 = "llvm.add"(%252, %234) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %254 = "llvm.add"(%253, %152) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %255 = "llvm.add"(%254, %235) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %256 = "llvm.mul"(%126, %68) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %257 = "llvm.mul"(%125, %70) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %258 = "llvm.mul"(%123, %72) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %259 = "llvm.mul"(%114, %83) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %260 = "llvm.mul"(%112, %74) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %261 = "llvm.mul"(%121, %76) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %262 = "llvm.mul"(%85, %110) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %263 = "llvm.mul"(%87, %108) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %264 = "llvm.mul"(%89, %106) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %265 = "llvm.mul"(%104, %97) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %266 = "llvm.mul"(%91, %95) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %267 = "llvm.mul"(%92, %93) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %268 = "llvm.mul"(%126, %70) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %269 = "llvm.mul"(%125, %72) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %270 = "llvm.mul"(%123, %83) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %271 = "llvm.mul"(%114, %74) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %272 = "llvm.mul"(%112, %76) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %273 = "llvm.mul"(%121, %85) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %274 = "llvm.mul"(%87, %110) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %275 = "llvm.mul"(%89, %108) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %276 = "llvm.mul"(%104, %106) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %277 = "llvm.mul"(%91, %97) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %278 = "llvm.mul"(%92, %95) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %279 = "llvm.add"(%275, %274) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %280 = "llvm.add"(%279, %271) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %281 = "llvm.add"(%280, %272) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %282 = "llvm.add"(%281, %273) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %283 = "llvm.add"(%282, %278) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %284 = "llvm.add"(%283, %268) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %285 = "llvm.add"(%284, %276) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %286 = "llvm.add"(%285, %277) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %287 = "llvm.add"(%286, %269) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %288 = "llvm.add"(%287, %270) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %289 = "llvm.mul"(%126, %72) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %290 = "llvm.mul"(%125, %83) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %291 = "llvm.mul"(%123, %74) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %292 = "llvm.mul"(%114, %76) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %293 = "llvm.mul"(%112, %85) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %294 = "llvm.mul"(%121, %87) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %295 = "llvm.mul"(%89, %110) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %296 = "llvm.mul"(%104, %108) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %297 = "llvm.mul"(%91, %106) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %298 = "llvm.mul"(%92, %97) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %299 = "llvm.mul"(%126, %83) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %300 = "llvm.mul"(%125, %74) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %301 = "llvm.mul"(%123, %76) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %302 = "llvm.mul"(%114, %85) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %303 = "llvm.mul"(%112, %87) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %304 = "llvm.mul"(%121, %89) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %305 = "llvm.mul"(%104, %110) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %306 = "llvm.mul"(%91, %108) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %307 = "llvm.mul"(%92, %106) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %308 = "llvm.add"(%303, %302) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %309 = "llvm.add"(%308, %304) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %310 = "llvm.add"(%309, %307) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %311 = "llvm.add"(%310, %299) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %312 = "llvm.add"(%311, %305) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %313 = "llvm.add"(%312, %306) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %314 = "llvm.add"(%313, %300) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %315 = "llvm.add"(%314, %301) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %316 = "llvm.mul"(%126, %74) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %317 = "llvm.mul"(%125, %76) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %318 = "llvm.mul"(%123, %85) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %319 = "llvm.mul"(%114, %87) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %320 = "llvm.mul"(%112, %89) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %321 = "llvm.mul"(%104, %121) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %322 = "llvm.mul"(%91, %110) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %323 = "llvm.mul"(%92, %108) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %324 = "llvm.mul"(%126, %76) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %325 = "llvm.mul"(%125, %85) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %326 = "llvm.mul"(%123, %87) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %327 = "llvm.mul"(%114, %89) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %328 = "llvm.mul"(%104, %112) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %329 = "llvm.mul"(%91, %121) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %330 = "llvm.mul"(%92, %110) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %331 = "llvm.add"(%330, %327) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %332 = "llvm.add"(%331, %324) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %333 = "llvm.add"(%332, %328) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %334 = "llvm.add"(%333, %329) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %335 = "llvm.add"(%334, %325) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %336 = "llvm.add"(%335, %326) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %337 = "llvm.mul"(%126, %85) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %338 = "llvm.mul"(%125, %87) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %339 = "llvm.mul"(%123, %89) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %340 = "llvm.mul"(%104, %114) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %341 = "llvm.mul"(%91, %112) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %342 = "llvm.mul"(%92, %121) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %343 = "llvm.mul"(%126, %87) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %344 = "llvm.mul"(%125, %89) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %345 = "llvm.mul"(%123, %104) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %346 = "llvm.mul"(%91, %114) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %347 = "llvm.mul"(%92, %112) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %348 = "llvm.add"(%343, %347) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %349 = "llvm.add"(%348, %346) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %350 = "llvm.add"(%349, %344) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %351 = "llvm.add"(%350, %345) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %352 = "llvm.mul"(%126, %89) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %353 = "llvm.mul"(%125, %104) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %354 = "llvm.mul"(%123, %91) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %355 = "llvm.mul"(%92, %114) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %356 = "llvm.mul"(%104, %126) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %357 = "llvm.mul"(%125, %91) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %358 = "llvm.add"(%357, %356) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %359 = "llvm.mul"(%123, %92) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %360 = "llvm.add"(%358, %359) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %361 = "llvm.mul"(%91, %126) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %362 = "llvm.mul"(%125, %92) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %363 = "llvm.add"(%362, %361) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %364 = "llvm.mul"(%126, %92) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %365 = "llvm.add"(%155, %28) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %366 = "llvm.lshr"(%365, %13) : (i64, i64) -> i64
  %367 = "llvm.add"(%156, %157) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %368 = "llvm.add"(%367, %129) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %369 = "llvm.add"(%368, %366) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %370 = "llvm.and"(%365, %29) : (i64, i64) -> i64
  %371 = "llvm.sub"(%155, %370) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %372 = "llvm.add"(%163, %28) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %373 = "llvm.lshr"(%372, %13) : (i64, i64) -> i64
  %374 = "llvm.add"(%166, %165) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %375 = "llvm.add"(%374, %167) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %376 = "llvm.add"(%375, %164) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %377 = "llvm.add"(%376, %142) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %378 = "llvm.add"(%377, %373) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %379 = "llvm.and"(%372, %30) : (i64, i64) -> i64
  %380 = "llvm.sub"(%163, %379) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %381 = "llvm.add"(%177, %28) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %382 = "llvm.lshr"(%381, %13) : (i64, i64) -> i64
  %383 = "llvm.add"(%182, %181) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %384 = "llvm.add"(%383, %183) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %385 = "llvm.add"(%384, %178) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %386 = "llvm.add"(%385, %135) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %387 = "llvm.add"(%386, %179) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %388 = "llvm.add"(%387, %180) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %389 = "llvm.add"(%388, %382) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %390 = "llvm.and"(%381, %30) : (i64, i64) -> i64
  %391 = "llvm.sub"(%177, %390) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %392 = "llvm.add"(%197, %28) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %393 = "llvm.lshr"(%392, %13) : (i64, i64) -> i64
  %394 = "llvm.add"(%200, %203) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %395 = "llvm.add"(%394, %201) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %396 = "llvm.add"(%395, %202) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %397 = "llvm.add"(%396, %204) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %398 = "llvm.add"(%397, %205) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %399 = "llvm.add"(%398, %198) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %400 = "llvm.add"(%399, %146) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %401 = "llvm.add"(%400, %199) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %402 = "llvm.add"(%401, %393) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %403 = "llvm.and"(%392, %30) : (i64, i64) -> i64
  %404 = "llvm.add"(%223, %28) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %405 = "llvm.lshr"(%404, %13) : (i64, i64) -> i64
  %406 = "llvm.add"(%229, %228) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %407 = "llvm.add"(%406, %230) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %408 = "llvm.add"(%407, %231) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %409 = "llvm.add"(%408, %232) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %410 = "llvm.add"(%409, %225) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %411 = "llvm.add"(%410, %226) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %412 = "llvm.add"(%411, %227) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %413 = "llvm.add"(%412, %233) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %414 = "llvm.add"(%413, %224) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %415 = "llvm.add"(%414, %150) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %416 = "llvm.add"(%415, %405) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %417 = "llvm.and"(%404, %30) : (i64, i64) -> i64
  %418 = "llvm.sub"(%223, %417) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %419 = "llvm.add"(%255, %28) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %420 = "llvm.lshr"(%419, %13) : (i64, i64) -> i64
  %421 = "llvm.add"(%263, %262) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %422 = "llvm.add"(%421, %264) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %423 = "llvm.add"(%422, %259) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %424 = "llvm.add"(%423, %260) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %425 = "llvm.add"(%424, %261) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %426 = "llvm.add"(%425, %267) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %427 = "llvm.add"(%426, %256) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %428 = "llvm.add"(%427, %153) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %429 = "llvm.add"(%428, %265) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %430 = "llvm.add"(%429, %266) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %431 = "llvm.add"(%430, %257) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %432 = "llvm.add"(%431, %258) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %433 = "llvm.add"(%432, %420) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %434 = "llvm.and"(%419, %30) : (i64, i64) -> i64
  %435 = "llvm.add"(%288, %28) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %436 = "llvm.lshr"(%435, %13) : (i64, i64) -> i64
  %437 = "llvm.add"(%292, %295) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %438 = "llvm.add"(%437, %293) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %439 = "llvm.add"(%438, %294) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %440 = "llvm.add"(%439, %298) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %441 = "llvm.add"(%440, %289) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %442 = "llvm.add"(%441, %296) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %443 = "llvm.add"(%442, %297) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %444 = "llvm.add"(%443, %290) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %445 = "llvm.add"(%444, %291) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %446 = "llvm.add"(%445, %436) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %447 = "llvm.and"(%435, %30) : (i64, i64) -> i64
  %448 = "llvm.add"(%315, %28) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %449 = "llvm.lshr"(%448, %13) : (i64, i64) -> i64
  %450 = "llvm.add"(%320, %319) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %451 = "llvm.add"(%450, %323) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %452 = "llvm.add"(%451, %316) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %453 = "llvm.add"(%452, %321) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %454 = "llvm.add"(%453, %322) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %455 = "llvm.add"(%454, %317) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %456 = "llvm.add"(%455, %318) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %457 = "llvm.add"(%456, %449) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %458 = "llvm.and"(%448, %30) : (i64, i64) -> i64
  %459 = "llvm.add"(%336, %28) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %460 = "llvm.lshr"(%459, %13) : (i64, i64) -> i64
  %461 = "llvm.add"(%337, %342) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %462 = "llvm.add"(%461, %340) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %463 = "llvm.add"(%462, %341) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %464 = "llvm.add"(%463, %338) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %465 = "llvm.add"(%464, %339) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %466 = "llvm.add"(%465, %460) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %467 = "llvm.and"(%459, %30) : (i64, i64) -> i64
  %468 = "llvm.add"(%351, %28) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %469 = "llvm.lshr"(%468, %13) : (i64, i64) -> i64
  %470 = "llvm.add"(%352, %355) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %471 = "llvm.add"(%470, %353) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %472 = "llvm.add"(%471, %354) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %473 = "llvm.add"(%472, %469) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %474 = "llvm.and"(%468, %30) : (i64, i64) -> i64
  %475 = "llvm.sub"(%351, %474) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %476 = "llvm.add"(%360, %28) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %477 = "llvm.lshr"(%476, %13) : (i64, i64) -> i64
  %478 = "llvm.add"(%363, %477) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %479 = "llvm.and"(%476, %31) : (i64, i64) -> i64
  %480 = "llvm.sub"(%360, %479) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %481 = "llvm.add"(%364, %28) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %482 = "llvm.lshr"(%481, %13) : (i64, i64) -> i64
  %483 = "llvm.and"(%481, %32) : (i64, i64) -> i64
  %484 = "llvm.sub"(%364, %483) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %485 = "llvm.add"(%369, %28) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %486 = "llvm.lshr"(%485, %13) : (i64, i64) -> i64
  %487 = "llvm.add"(%380, %486) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %488 = "llvm.and"(%485, %30) : (i64, i64) -> i64
  %489 = "llvm.sub"(%369, %488) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %490 = "llvm.add"(%378, %28) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %491 = "llvm.lshr"(%490, %13) : (i64, i64) -> i64
  %492 = "llvm.add"(%391, %491) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %493 = "llvm.and"(%490, %30) : (i64, i64) -> i64
  %494 = "llvm.sub"(%378, %493) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %495 = "llvm.add"(%389, %28) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %496 = "llvm.lshr"(%495, %13) : (i64, i64) -> i64
  %497 = "llvm.and"(%495, %30) : (i64, i64) -> i64
  %498 = "llvm.sub"(%389, %497) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %499 = "llvm.add"(%402, %28) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %500 = "llvm.lshr"(%499, %13) : (i64, i64) -> i64
  %501 = "llvm.add"(%418, %500) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %502 = "llvm.and"(%499, %30) : (i64, i64) -> i64
  %503 = "llvm.sub"(%402, %502) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %504 = "llvm.add"(%416, %28) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %505 = "llvm.lshr"(%504, %13) : (i64, i64) -> i64
  %506 = "llvm.and"(%504, %30) : (i64, i64) -> i64
  %507 = "llvm.add"(%433, %28) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %508 = "llvm.lshr"(%507, %13) : (i64, i64) -> i64
  %509 = "llvm.and"(%507, %30) : (i64, i64) -> i64
  %510 = "llvm.add"(%446, %28) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %511 = "llvm.lshr"(%510, %13) : (i64, i64) -> i64
  %512 = "llvm.and"(%510, %30) : (i64, i64) -> i64
  %513 = "llvm.add"(%457, %28) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %514 = "llvm.lshr"(%513, %13) : (i64, i64) -> i64
  %515 = "llvm.and"(%513, %30) : (i64, i64) -> i64
  %516 = "llvm.add"(%466, %28) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %517 = "llvm.lshr"(%516, %13) : (i64, i64) -> i64
  %518 = "llvm.add"(%517, %475) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %519 = "llvm.and"(%516, %30) : (i64, i64) -> i64
  %520 = "llvm.sub"(%466, %519) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %521 = "llvm.add"(%473, %28) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %522 = "llvm.lshr"(%521, %13) : (i64, i64) -> i64
  %523 = "llvm.add"(%522, %480) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %524 = "llvm.and"(%521, %30) : (i64, i64) -> i64
  %525 = "llvm.sub"(%473, %524) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %526 = "llvm.add"(%478, %28) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %527 = "llvm.lshr"(%526, %13) : (i64, i64) -> i64
  %528 = "llvm.add"(%527, %484) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %529 = "llvm.and"(%526, %31) : (i64, i64) -> i64
  %530 = "llvm.sub"(%478, %529) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %531 = "llvm.mul"(%482, %33) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %532 = "llvm.mul"(%482, %34) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %533 = "llvm.mul"(%482, %35) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %534 = "llvm.mul"(%482, %36) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %535 = "llvm.mul"(%482, %37) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %536 = "llvm.mul"(%482, %38) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %537 = "llvm.add"(%336, %536) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %538 = "llvm.sub"(%537, %467) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %539 = "llvm.add"(%538, %514) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %540 = "llvm.mul"(%528, %33) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %541 = "llvm.mul"(%528, %34) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %542 = "llvm.mul"(%528, %35) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %543 = "llvm.mul"(%528, %36) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %544 = "llvm.mul"(%528, %37) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %545 = "llvm.mul"(%528, %38) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %546 = "llvm.mul"(%530, %33) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %547 = "llvm.mul"(%530, %34) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %548 = "llvm.mul"(%530, %35) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %549 = "llvm.mul"(%530, %36) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %550 = "llvm.mul"(%530, %37) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %551 = "llvm.mul"(%530, %38) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %552 = "llvm.add"(%315, %534) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %553 = "llvm.add"(%552, %544) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %554 = "llvm.add"(%553, %551) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %555 = "llvm.sub"(%554, %458) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %556 = "llvm.add"(%555, %511) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %557 = "llvm.mul"(%523, %33) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %558 = "llvm.add"(%501, %557) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %559 = "llvm.mul"(%523, %34) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %560 = "llvm.mul"(%523, %35) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %561 = "llvm.mul"(%523, %36) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %562 = "llvm.mul"(%523, %37) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %563 = "llvm.mul"(%523, %38) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %564 = "llvm.mul"(%525, %33) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %565 = "llvm.add"(%503, %564) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %566 = "llvm.mul"(%525, %34) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %567 = "llvm.add"(%558, %566) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %568 = "llvm.mul"(%525, %35) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %569 = "llvm.mul"(%525, %36) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %570 = "llvm.mul"(%525, %37) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %571 = "llvm.mul"(%525, %38) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %572 = "llvm.add"(%542, %532) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %573 = "llvm.add"(%572, %549) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %574 = "llvm.add"(%573, %288) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %575 = "llvm.add"(%574, %562) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %576 = "llvm.add"(%575, %571) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %577 = "llvm.sub"(%576, %447) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %578 = "llvm.add"(%577, %508) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %579 = "llvm.mul"(%518, %33) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %580 = "llvm.add"(%496, %197) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %581 = "llvm.sub"(%580, %403) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %582 = "llvm.add"(%581, %579) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %583 = "llvm.mul"(%518, %34) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %584 = "llvm.add"(%565, %583) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %585 = "llvm.mul"(%518, %35) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %586 = "llvm.add"(%567, %585) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %587 = "llvm.mul"(%518, %36) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %588 = "llvm.mul"(%518, %37) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %589 = "llvm.add"(%547, %540) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %590 = "llvm.add"(%589, %255) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %591 = "llvm.add"(%590, %560) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %592 = "llvm.add"(%591, %569) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %593 = "llvm.sub"(%592, %434) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %594 = "llvm.add"(%593, %505) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %595 = "llvm.add"(%594, %588) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %596 = "llvm.mul"(%518, %38) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %597 = "llvm.add"(%582, %28) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %598 = "llvm.ashr"(%597, %13) : (i64, i64) -> i64
  %599 = "llvm.add"(%584, %598) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %600 = "llvm.and"(%597, %30) : (i64, i64) -> i64
  %601 = "llvm.sub"(%582, %600) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %602 = "llvm.add"(%586, %28) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %603 = "llvm.ashr"(%602, %13) : (i64, i64) -> i64
  %604 = "llvm.add"(%416, %546) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %605 = "llvm.add"(%604, %559) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %606 = "llvm.add"(%605, %568) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %607 = "llvm.sub"(%606, %506) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %608 = "llvm.add"(%607, %587) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %609 = "llvm.add"(%608, %603) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %610 = "llvm.and"(%602, %30) : (i64, i64) -> i64
  %611 = "llvm.sub"(%586, %610) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %612 = "llvm.add"(%595, %28) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %613 = "llvm.ashr"(%612, %13) : (i64, i64) -> i64
  %614 = "llvm.add"(%541, %531) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %615 = "llvm.add"(%614, %548) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %616 = "llvm.add"(%615, %561) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %617 = "llvm.add"(%616, %570) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %618 = "llvm.add"(%617, %596) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %619 = "llvm.add"(%618, %433) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %620 = "llvm.sub"(%619, %509) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %621 = "llvm.add"(%620, %613) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %622 = "llvm.and"(%612, %30) : (i64, i64) -> i64
  %623 = "llvm.add"(%578, %28) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %624 = "llvm.ashr"(%623, %13) : (i64, i64) -> i64
  %625 = "llvm.add"(%543, %533) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %626 = "llvm.add"(%625, %550) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %627 = "llvm.add"(%626, %563) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %628 = "llvm.add"(%627, %446) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %629 = "llvm.sub"(%628, %512) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %630 = "llvm.add"(%629, %624) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %631 = "llvm.and"(%623, %30) : (i64, i64) -> i64
  %632 = "llvm.sub"(%578, %631) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %633 = "llvm.add"(%556, %28) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %634 = "llvm.ashr"(%633, %13) : (i64, i64) -> i64
  %635 = "llvm.add"(%545, %535) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %636 = "llvm.add"(%635, %457) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %637 = "llvm.sub"(%636, %515) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %638 = "llvm.add"(%637, %634) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %639 = "llvm.and"(%633, %30) : (i64, i64) -> i64
  %640 = "llvm.sub"(%556, %639) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %641 = "llvm.add"(%539, %28) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %642 = "llvm.ashr"(%641, %13) : (i64, i64) -> i64
  %643 = "llvm.add"(%642, %520) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %644 = "llvm.and"(%641, %30) : (i64, i64) -> i64
  %645 = "llvm.sub"(%539, %644) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %646 = "llvm.add"(%599, %28) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %647 = "llvm.ashr"(%646, %13) : (i64, i64) -> i64
  %648 = "llvm.add"(%611, %647) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %649 = "llvm.and"(%646, %30) : (i64, i64) -> i64
  %650 = "llvm.sub"(%599, %649) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %651 = "llvm.add"(%609, %28) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %652 = "llvm.ashr"(%651, %13) : (i64, i64) -> i64
  %653 = "llvm.and"(%651, %30) : (i64, i64) -> i64
  %654 = "llvm.add"(%621, %28) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %655 = "llvm.ashr"(%654, %13) : (i64, i64) -> i64
  %656 = "llvm.add"(%655, %632) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %657 = "llvm.and"(%654, %30) : (i64, i64) -> i64
  %658 = "llvm.sub"(%621, %657) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %659 = "llvm.add"(%630, %28) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %660 = "llvm.ashr"(%659, %13) : (i64, i64) -> i64
  %661 = "llvm.add"(%660, %640) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %662 = "llvm.and"(%659, %30) : (i64, i64) -> i64
  %663 = "llvm.sub"(%630, %662) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %664 = "llvm.add"(%638, %28) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %665 = "llvm.ashr"(%664, %13) : (i64, i64) -> i64
  %666 = "llvm.add"(%665, %645) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %667 = "llvm.and"(%664, %30) : (i64, i64) -> i64
  %668 = "llvm.sub"(%638, %667) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %669 = "llvm.mul"(%643, %33) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %670 = "llvm.add"(%498, %669) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %671 = "llvm.mul"(%643, %34) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %672 = "llvm.add"(%601, %671) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %673 = "llvm.mul"(%643, %35) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %674 = "llvm.add"(%650, %673) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %675 = "llvm.mul"(%643, %36) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %676 = "llvm.add"(%648, %675) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %677 = "llvm.mul"(%643, %37) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %678 = "llvm.mul"(%643, %38) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %679 = "llvm.add"(%595, %678) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %680 = "llvm.add"(%679, %652) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %681 = "llvm.sub"(%680, %622) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %682 = "llvm.mul"(%666, %33) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %683 = "llvm.add"(%492, %682) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %684 = "llvm.mul"(%666, %34) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %685 = "llvm.add"(%670, %684) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %686 = "llvm.mul"(%666, %35) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %687 = "llvm.add"(%672, %686) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %688 = "llvm.mul"(%666, %36) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %689 = "llvm.add"(%674, %688) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %690 = "llvm.mul"(%666, %37) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %691 = "llvm.add"(%676, %690) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %692 = "llvm.mul"(%666, %38) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %693 = "llvm.mul"(%668, %33) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %694 = "llvm.add"(%494, %693) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %695 = "llvm.mul"(%668, %34) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %696 = "llvm.add"(%683, %695) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %697 = "llvm.mul"(%668, %35) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %698 = "llvm.add"(%685, %697) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %699 = "llvm.mul"(%668, %36) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %700 = "llvm.add"(%687, %699) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %701 = "llvm.mul"(%668, %37) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %702 = "llvm.add"(%689, %701) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %703 = "llvm.mul"(%668, %38) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %704 = "llvm.add"(%691, %703) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %705 = "llvm.mul"(%661, %33) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %706 = "llvm.mul"(%661, %34) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %707 = "llvm.mul"(%661, %35) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %708 = "llvm.mul"(%661, %36) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %709 = "llvm.mul"(%661, %37) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %710 = "llvm.add"(%700, %709) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %711 = "llvm.mul"(%661, %38) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %712 = "llvm.add"(%702, %711) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %713 = "llvm.mul"(%663, %33) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %714 = "llvm.mul"(%663, %34) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %715 = "llvm.mul"(%663, %35) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %716 = "llvm.mul"(%663, %36) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %717 = "llvm.mul"(%663, %37) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %718 = "llvm.mul"(%663, %38) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %719 = "llvm.add"(%710, %718) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %720 = "llvm.mul"(%656, %33) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %721 = "llvm.add"(%720, %371) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %722 = "llvm.mul"(%656, %34) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %723 = "llvm.mul"(%656, %35) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %724 = "llvm.add"(%487, %723) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %725 = "llvm.add"(%724, %705) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %726 = "llvm.add"(%725, %714) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %727 = "llvm.mul"(%656, %36) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %728 = "llvm.mul"(%656, %37) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %729 = "llvm.add"(%696, %728) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %730 = "llvm.add"(%729, %707) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %731 = "llvm.add"(%730, %716) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %732 = "llvm.mul"(%656, %38) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %733 = "llvm.add"(%721, %28) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %734 = "llvm.ashr"(%733, %13) : (i64, i64) -> i64
  %735 = "llvm.add"(%489, %722) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %736 = "llvm.add"(%735, %713) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %737 = "llvm.add"(%736, %734) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %738 = "llvm.and"(%733, %30) : (i64, i64) -> i64
  %739 = "llvm.sub"(%721, %738) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %740 = "llvm.add"(%726, %28) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %741 = "llvm.ashr"(%740, %13) : (i64, i64) -> i64
  %742 = "llvm.add"(%694, %727) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %743 = "llvm.add"(%742, %706) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %744 = "llvm.add"(%743, %715) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %745 = "llvm.add"(%744, %741) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %746 = "llvm.and"(%740, %30) : (i64, i64) -> i64
  %747 = "llvm.add"(%731, %28) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %748 = "llvm.ashr"(%747, %13) : (i64, i64) -> i64
  %749 = "llvm.add"(%698, %732) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %750 = "llvm.add"(%749, %708) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %751 = "llvm.add"(%750, %717) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %752 = "llvm.add"(%751, %748) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %753 = "llvm.and"(%747, %30) : (i64, i64) -> i64
  %754 = "llvm.add"(%719, %28) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %755 = "llvm.ashr"(%754, %13) : (i64, i64) -> i64
  %756 = "llvm.add"(%712, %755) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %757 = "llvm.and"(%754, %30) : (i64, i64) -> i64
  %758 = "llvm.sub"(%719, %757) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %759 = "llvm.add"(%704, %28) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %760 = "llvm.ashr"(%759, %13) : (i64, i64) -> i64
  %761 = "llvm.add"(%677, %609) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %762 = "llvm.sub"(%761, %653) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %763 = "llvm.add"(%762, %692) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %764 = "llvm.add"(%763, %760) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %765 = "llvm.and"(%759, %30) : (i64, i64) -> i64
  %766 = "llvm.sub"(%704, %765) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %767 = "llvm.add"(%681, %28) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %768 = "llvm.ashr"(%767, %13) : (i64, i64) -> i64
  %769 = "llvm.add"(%658, %768) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %770 = "llvm.and"(%767, %30) : (i64, i64) -> i64
  %771 = "llvm.sub"(%681, %770) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %772 = "llvm.add"(%737, %28) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %773 = "llvm.ashr"(%772, %13) : (i64, i64) -> i64
  %774 = "llvm.and"(%772, %30) : (i64, i64) -> i64
  %775 = "llvm.add"(%745, %28) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %776 = "llvm.ashr"(%775, %13) : (i64, i64) -> i64
  %777 = "llvm.and"(%775, %30) : (i64, i64) -> i64
  %778 = "llvm.add"(%752, %28) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %779 = "llvm.ashr"(%778, %13) : (i64, i64) -> i64
  %780 = "llvm.add"(%758, %779) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %781 = "llvm.and"(%778, %30) : (i64, i64) -> i64
  %782 = "llvm.add"(%756, %28) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %783 = "llvm.ashr"(%782, %13) : (i64, i64) -> i64
  %784 = "llvm.add"(%766, %783) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %785 = "llvm.and"(%782, %30) : (i64, i64) -> i64
  %786 = "llvm.sub"(%756, %785) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %787 = "llvm.add"(%764, %28) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %788 = "llvm.ashr"(%787, %13) : (i64, i64) -> i64
  %789 = "llvm.add"(%771, %788) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %790 = "llvm.and"(%787, %30) : (i64, i64) -> i64
  %791 = "llvm.sub"(%764, %790) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %792 = "llvm.add"(%769, %28) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %793 = "llvm.ashr"(%792, %13) : (i64, i64) -> i64
  %794 = "llvm.and"(%792, %30) : (i64, i64) -> i64
  %795 = "llvm.sub"(%769, %794) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %796 = "llvm.mul"(%793, %33) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %797 = "llvm.add"(%739, %796) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %798 = "llvm.mul"(%793, %34) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %799 = "llvm.mul"(%793, %35) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %800 = "llvm.mul"(%793, %36) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %801 = "llvm.mul"(%793, %37) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %802 = "llvm.mul"(%793, %38) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %803 = "llvm.ashr"(%797, %13) : (i64, i64) -> i64
  %804 = "llvm.add"(%737, %798) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %805 = "llvm.sub"(%804, %774) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %806 = "llvm.add"(%805, %803) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %807 = "llvm.and"(%797, %12) : (i64, i64) -> i64
  %808 = "llvm.ashr"(%806, %13) : (i64, i64) -> i64
  %809 = "llvm.add"(%726, %799) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %810 = "llvm.sub"(%809, %746) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %811 = "llvm.add"(%810, %773) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %812 = "llvm.add"(%811, %808) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %813 = "llvm.and"(%806, %12) : (i64, i64) -> i64
  %814 = "llvm.ashr"(%812, %13) : (i64, i64) -> i64
  %815 = "llvm.add"(%745, %800) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %816 = "llvm.sub"(%815, %777) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %817 = "llvm.add"(%816, %814) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %818 = "llvm.and"(%812, %12) : (i64, i64) -> i64
  %819 = "llvm.ashr"(%817, %13) : (i64, i64) -> i64
  %820 = "llvm.add"(%731, %801) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %821 = "llvm.sub"(%820, %753) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %822 = "llvm.add"(%821, %776) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %823 = "llvm.add"(%822, %819) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %824 = "llvm.and"(%817, %12) : (i64, i64) -> i64
  %825 = "llvm.ashr"(%823, %13) : (i64, i64) -> i64
  %826 = "llvm.add"(%752, %802) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %827 = "llvm.sub"(%826, %781) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %828 = "llvm.add"(%827, %825) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %829 = "llvm.and"(%823, %12) : (i64, i64) -> i64
  %830 = "llvm.ashr"(%828, %13) : (i64, i64) -> i64
  %831 = "llvm.add"(%780, %830) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %832 = "llvm.and"(%828, %12) : (i64, i64) -> i64
  %833 = "llvm.ashr"(%831, %13) : (i64, i64) -> i64
  %834 = "llvm.add"(%833, %786) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %835 = "llvm.and"(%831, %12) : (i64, i64) -> i64
  %836 = "llvm.ashr"(%834, %13) : (i64, i64) -> i64
  %837 = "llvm.add"(%784, %836) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %838 = "llvm.and"(%834, %12) : (i64, i64) -> i64
  %839 = "llvm.ashr"(%837, %13) : (i64, i64) -> i64
  %840 = "llvm.add"(%839, %791) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %841 = "llvm.and"(%837, %12) : (i64, i64) -> i64
  %842 = "llvm.ashr"(%840, %13) : (i64, i64) -> i64
  %843 = "llvm.add"(%789, %842) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %844 = "llvm.and"(%840, %12) : (i64, i64) -> i64
  %845 = "llvm.ashr"(%843, %13) : (i64, i64) -> i64
  %846 = "llvm.add"(%845, %795) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %847 = "llvm.and"(%843, %12) : (i64, i64) -> i64
  %848 = "llvm.ashr"(%846, %13) : (i64, i64) -> i64
  %849 = "llvm.and"(%846, %12) : (i64, i64) -> i64
  %850 = "llvm.mul"(%848, %33) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %851 = "llvm.mul"(%848, %34) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %852 = "llvm.add"(%851, %813) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %853 = "llvm.mul"(%848, %35) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %854 = "llvm.add"(%853, %818) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %855 = "llvm.mul"(%848, %36) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %856 = "llvm.add"(%855, %824) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %857 = "llvm.mul"(%848, %37) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %858 = "llvm.add"(%857, %829) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %859 = "llvm.mul"(%848, %38) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %860 = "llvm.add"(%859, %832) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %861 = "llvm.add"(%850, %807) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %862 = "llvm.ashr"(%861, %13) : (i64, i64) -> i64
  %863 = "llvm.add"(%852, %862) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %864 = "llvm.ashr"(%863, %13) : (i64, i64) -> i64
  %865 = "llvm.add"(%854, %864) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %866 = "llvm.ashr"(%865, %13) : (i64, i64) -> i64
  %867 = "llvm.add"(%856, %866) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %868 = "llvm.ashr"(%867, %13) : (i64, i64) -> i64
  %869 = "llvm.add"(%858, %868) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %870 = "llvm.ashr"(%869, %13) : (i64, i64) -> i64
  %871 = "llvm.add"(%860, %870) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %872 = "llvm.ashr"(%871, %13) : (i64, i64) -> i64
  %873 = "llvm.add"(%872, %835) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %874 = "llvm.ashr"(%873, %13) : (i64, i64) -> i64
  %875 = "llvm.add"(%874, %838) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %876 = "llvm.ashr"(%875, %13) : (i64, i64) -> i64
  %877 = "llvm.add"(%876, %841) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %878 = "llvm.ashr"(%877, %13) : (i64, i64) -> i64
  %879 = "llvm.add"(%878, %844) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %880 = "llvm.ashr"(%879, %13) : (i64, i64) -> i64
  %881 = "llvm.add"(%880, %847) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %882 = "llvm.lshr"(%881, %13) : (i64, i64) -> i64
  %883 = "llvm.add"(%882, %849) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %884 = "llvm.insertelement"(%46, %861, %18) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %885 = "llvm.insertelement"(%884, %867, %19) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %886 = "llvm.insertelement"(%885, %873, %8) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %887 = "llvm.lshr"(%886, %7) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %888 = "llvm.and"(%887, %6) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %889 = "llvm.insertelement"(%5, %865, %18) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %890 = "llvm.insertelement"(%889, %871, %19) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %891 = "llvm.insertelement"(%890, %877, %8) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %892 = "llvm.insertelement"(%891, %879, %27) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %893 = "llvm.shl"(%892, %4) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %894 = "llvm.lshr"(%892, %4) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %895 = "llvm.shufflevector"(%893, %894) <{mask = array<i32: 0, 1, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %896 = "llvm.and"(%895, %3) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %897 = "llvm.insertelement"(%5, %863, %18) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %898 = "llvm.insertelement"(%897, %869, %19) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %899 = "llvm.insertelement"(%898, %875, %8) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %900 = "llvm.insertelement"(%899, %881, %27) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %901 = "llvm.shl"(%900, %2) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %902 = "llvm.and"(%901, %1) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %903 = "llvm.or"(%902, %888) <{isDisjoint}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %904 = "llvm.or"(%896, %903) <{isDisjoint}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %905 = "llvm.insertelement"(%5, %867, %18) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %906 = "llvm.insertelement"(%905, %873, %19) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %907 = "llvm.insertelement"(%906, %879, %8) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %908 = "llvm.insertelement"(%907, %883, %27) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %909 = "llvm.shl"(%908, %0) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %910 = "llvm.or"(%904, %909) <{isDisjoint}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.store"(%910, %arg0) <{alignment = 8 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  "llvm.return"(%arg0) : (!llvm.ptr) -> ()
}) : () -> ()

end

end Firedancer.LaneNI.Mlir
