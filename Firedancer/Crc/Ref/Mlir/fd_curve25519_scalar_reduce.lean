
module

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab



namespace MLIR.Firedancer.Crc.Ref

@[expose] public section

mlir_def fd_curve25519_scalar_reduce := "llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.nofree, llvm.noundef, llvm.returned, llvm.writeonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}], function_type = !llvm.func<ptr (ptr, ptr)>, linkage = #llvm.linkage<external>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "znver4"]], res_attrs = [{llvm.noundef}], sym_name = "fd_curve25519_scalar_reduce", target_cpu = "znver4", target_features = #llvm.target_features<["+64bit", "+adx", "+aes", "+avx", "+avx2", "+avx512bf16", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+clzero", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+mwaitx", "+pclmul", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdpru", "+rdrnd", "+rdseed", "+sahf", "+sha", "+shstk", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+sse4a", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tile", "-avx10.1", "-avx10.2", "-avx512bmm", "-avx512fp16", "-avx512vp2intersect", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-ccmp", "-cf", "-cldemote", "-cmpccxadd", "-egpr", "-enqcmd", "-fma4", "-hreset", "-jmpabs", "-kl", "-lwp", "-movdir64b", "-movdiri", "-movrs", "-ndd", "-nf", "-pconfig", "-ppx", "-prefetchi", "-ptwrite", "-push2pop2", "-raoint", "-rtm", "-serialize", "-sgx", "-sha512", "-sm3", "-sm4", "-tbm", "-tsxldtrk", "-uintr", "-usermsr", "-waitpkg", "-widekl", "-xop", "-zu"]>, tune_cpu = "znver4", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg0: !llvm.ptr, %arg1: !llvm.ptr):
  %0 = "llvm.mlir.constant"() <{value = 16 : i64}> : () -> i64
  %1 = "llvm.mlir.constant"() <{value = 40 : i64}> : () -> i64
  %2 = "llvm.mlir.constant"() <{value = 2097151 : i64}> : () -> i64
  %3 = "llvm.mlir.constant"() <{value = 21 : i64}> : () -> i64
  %4 = "llvm.mlir.constant"() <{value = 42 : i64}> : () -> i64
  %5 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %6 = "llvm.mlir.constant"() <{value = 20 : i64}> : () -> i64
  %7 = "llvm.mlir.constant"() <{value = 41 : i64}> : () -> i64
  %8 = "llvm.mlir.constant"() <{value = 2 : i64}> : () -> i64
  %9 = "llvm.mlir.constant"() <{value = 19 : i64}> : () -> i64
  %10 = "llvm.mlir.constant"() <{value = 3 : i64}> : () -> i64
  %11 = "llvm.mlir.constant"() <{value = 18 : i64}> : () -> i64
  %12 = "llvm.mlir.constant"() <{value = 39 : i64}> : () -> i64
  %13 = "llvm.mlir.constant"() <{value = 4 : i64}> : () -> i64
  %14 = "llvm.mlir.constant"() <{value = 17 : i64}> : () -> i64
  %15 = "llvm.mlir.constant"() <{value = 38 : i64}> : () -> i64
  %16 = "llvm.mlir.constant"() <{value = 5 : i64}> : () -> i64
  %17 = "llvm.mlir.constant"() <{value = 37 : i64}> : () -> i64
  %18 = "llvm.mlir.constant"() <{value = 6 : i64}> : () -> i64
  %19 = "llvm.mlir.constant"() <{value = 15 : i64}> : () -> i64
  %20 = "llvm.mlir.constant"() <{value = 36 : i64}> : () -> i64
  %21 = "llvm.mlir.constant"() <{value = 7 : i64}> : () -> i64
  %22 = "llvm.mlir.constant"() <{value = 14 : i64}> : () -> i64
  %23 = "llvm.mlir.constant"() <{value = 35 : i64}> : () -> i64
  %24 = "llvm.mlir.constant"() <{value = 666643 : i64}> : () -> i64
  %25 = "llvm.mlir.constant"() <{value = 470296 : i64}> : () -> i64
  %26 = "llvm.mlir.constant"() <{value = 654183 : i64}> : () -> i64
  %27 = "llvm.mlir.constant"() <{value = -997805 : i64}> : () -> i64
  %28 = "llvm.mlir.constant"() <{value = 136657 : i64}> : () -> i64
  %29 = "llvm.mlir.constant"() <{value = -683901 : i64}> : () -> i64
  %30 = "llvm.mlir.constant"() <{value = 1048576 : i64}> : () -> i64
  %31 = "llvm.mlir.constant"() <{value = 8796090925056 : i64}> : () -> i64
  %32 = "llvm.mlir.constant"() <{value = 9223372036852678656 : i64}> : () -> i64
  %33 = "llvm.mlir.constant"() <{value = -2097152 : i64}> : () -> i64
  %34 = "llvm.mlir.constant"() <{value = 4398044413952 : i64}> : () -> i64
  %35 = "llvm.mlir.constant"() <{value = 9223367638808264704 : i64}> : () -> i64
  %36 = "llvm.mlir.constant"() <{value = 63 : i64}> : () -> i64
  %37 = "llvm.mlir.constant"() <{value = 1048575 : i64}> : () -> i64
  %38 = "llvm.mlir.constant"() <{value = 2199022206976 : i64}> : () -> i64
  %39 = "llvm.mlir.constant"() <{value = 4611683819404132352 : i64}> : () -> i64
  %40 = "llvm.mlir.constant"() <{value = 62 : i64}> : () -> i64
  %41 = "llvm.mlir.constant"() <{value = 524287 : i64}> : () -> i64
  %42 = "llvm.mlir.constant"() <{value = 1099511103488 : i64}> : () -> i64
  %43 = "llvm.mlir.constant"() <{value = 2305841909702066176 : i64}> : () -> i64
  %44 = "llvm.mlir.constant"() <{value = 61 : i64}> : () -> i64
  %45 = "llvm.mlir.constant"() <{value = 262143 : i64}> : () -> i64
  %46 = "llvm.mlir.constant"() <{value = 549755551744 : i64}> : () -> i64
  %47 = "llvm.load"(%arg1) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %48 = "llvm.getelementptr"(%arg1) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %49 = "llvm.load"(%48) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %50 = "llvm.getelementptr"(%arg1) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %51 = "llvm.load"(%50) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %52 = "llvm.getelementptr"(%arg1) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %53 = "llvm.load"(%52) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %54 = "llvm.getelementptr"(%arg1) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %55 = "llvm.load"(%54) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %56 = "llvm.getelementptr"(%arg1) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 40>}> : (!llvm.ptr) -> !llvm.ptr
  %57 = "llvm.load"(%56) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %58 = "llvm.getelementptr"(%arg1) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 48>}> : (!llvm.ptr) -> !llvm.ptr
  %59 = "llvm.load"(%58) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %60 = "llvm.getelementptr"(%arg1) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 56>}> : (!llvm.ptr) -> !llvm.ptr
  %61 = "llvm.load"(%60) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %62 = "llvm.and"(%47, %2) : (i64, i64) -> i64
  %63 = "llvm.lshr"(%47, %3) : (i64, i64) -> i64
  %64 = "llvm.and"(%63, %2) : (i64, i64) -> i64
  %65 = "llvm.lshr"(%47, %4) : (i64, i64) -> i64
  %66 = "llvm.and"(%65, %2) : (i64, i64) -> i64
  %67 = "llvm.intr.fshl"(%49, %47, %5) : (i64, i64, i64) -> i64
  %68 = "llvm.and"(%67, %2) : (i64, i64) -> i64
  %69 = "llvm.lshr"(%49, %6) : (i64, i64) -> i64
  %70 = "llvm.and"(%69, %2) : (i64, i64) -> i64
  %71 = "llvm.lshr"(%49, %7) : (i64, i64) -> i64
  %72 = "llvm.and"(%71, %2) : (i64, i64) -> i64
  %73 = "llvm.intr.fshl"(%51, %49, %8) : (i64, i64, i64) -> i64
  %74 = "llvm.and"(%73, %2) : (i64, i64) -> i64
  %75 = "llvm.lshr"(%51, %9) : (i64, i64) -> i64
  %76 = "llvm.and"(%75, %2) : (i64, i64) -> i64
  %77 = "llvm.lshr"(%51, %1) : (i64, i64) -> i64
  %78 = "llvm.and"(%77, %2) : (i64, i64) -> i64
  %79 = "llvm.intr.fshl"(%53, %51, %10) : (i64, i64, i64) -> i64
  %80 = "llvm.and"(%79, %2) : (i64, i64) -> i64
  %81 = "llvm.lshr"(%53, %11) : (i64, i64) -> i64
  %82 = "llvm.and"(%81, %2) : (i64, i64) -> i64
  %83 = "llvm.lshr"(%53, %12) : (i64, i64) -> i64
  %84 = "llvm.and"(%83, %2) : (i64, i64) -> i64
  %85 = "llvm.intr.fshl"(%55, %53, %13) : (i64, i64, i64) -> i64
  %86 = "llvm.and"(%85, %2) : (i64, i64) -> i64
  %87 = "llvm.lshr"(%55, %14) : (i64, i64) -> i64
  %88 = "llvm.and"(%87, %2) : (i64, i64) -> i64
  %89 = "llvm.lshr"(%55, %15) : (i64, i64) -> i64
  %90 = "llvm.and"(%89, %2) : (i64, i64) -> i64
  %91 = "llvm.intr.fshl"(%57, %55, %16) : (i64, i64, i64) -> i64
  %92 = "llvm.and"(%91, %2) : (i64, i64) -> i64
  %93 = "llvm.lshr"(%57, %0) : (i64, i64) -> i64
  %94 = "llvm.and"(%93, %2) : (i64, i64) -> i64
  %95 = "llvm.lshr"(%57, %17) : (i64, i64) -> i64
  %96 = "llvm.and"(%95, %2) : (i64, i64) -> i64
  %97 = "llvm.intr.fshl"(%59, %57, %18) : (i64, i64, i64) -> i64
  %98 = "llvm.and"(%97, %2) : (i64, i64) -> i64
  %99 = "llvm.lshr"(%59, %19) : (i64, i64) -> i64
  %100 = "llvm.and"(%99, %2) : (i64, i64) -> i64
  %101 = "llvm.lshr"(%59, %20) : (i64, i64) -> i64
  %102 = "llvm.and"(%101, %2) : (i64, i64) -> i64
  %103 = "llvm.intr.fshl"(%61, %59, %21) : (i64, i64, i64) -> i64
  %104 = "llvm.and"(%103, %2) : (i64, i64) -> i64
  %105 = "llvm.lshr"(%61, %22) : (i64, i64) -> i64
  %106 = "llvm.and"(%105, %2) : (i64, i64) -> i64
  %107 = "llvm.lshr"(%61, %23) : (i64, i64) -> i64
  %108 = "llvm.mul"(%107, %24) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %109 = "llvm.add"(%108, %84) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %110 = "llvm.mul"(%107, %25) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %111 = "llvm.add"(%110, %86) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %112 = "llvm.mul"(%107, %26) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %113 = "llvm.add"(%112, %88) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %114 = "llvm.mul"(%107, %27) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %115 = "llvm.add"(%114, %90) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %116 = "llvm.mul"(%107, %28) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %117 = "llvm.add"(%116, %92) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %118 = "llvm.mul"(%107, %29) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %119 = "llvm.add"(%118, %94) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %120 = "llvm.mul"(%106, %24) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %121 = "llvm.mul"(%106, %25) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %122 = "llvm.mul"(%106, %26) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %123 = "llvm.mul"(%106, %27) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %124 = "llvm.mul"(%106, %28) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %125 = "llvm.add"(%115, %124) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %126 = "llvm.mul"(%106, %29) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %127 = "llvm.add"(%117, %126) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %128 = "llvm.mul"(%104, %24) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %129 = "llvm.mul"(%104, %25) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %130 = "llvm.mul"(%104, %26) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %131 = "llvm.mul"(%104, %27) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %132 = "llvm.mul"(%104, %28) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %133 = "llvm.mul"(%104, %29) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %134 = "llvm.add"(%125, %133) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %135 = "llvm.mul"(%102, %24) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %136 = "llvm.add"(%135, %78) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %137 = "llvm.mul"(%102, %25) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %138 = "llvm.mul"(%102, %26) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %139 = "llvm.mul"(%102, %27) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %140 = "llvm.mul"(%102, %28) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %141 = "llvm.mul"(%102, %29) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %142 = "llvm.mul"(%100, %24) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %143 = "llvm.add"(%142, %76) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %144 = "llvm.mul"(%100, %25) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %145 = "llvm.add"(%136, %144) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %146 = "llvm.mul"(%100, %26) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %147 = "llvm.mul"(%100, %27) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %148 = "llvm.mul"(%100, %28) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %149 = "llvm.mul"(%100, %29) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %150 = "llvm.add"(%111, %140) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %151 = "llvm.add"(%150, %149) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %152 = "llvm.add"(%151, %122) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %153 = "llvm.add"(%152, %131) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %154 = "llvm.mul"(%98, %24) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %155 = "llvm.add"(%154, %74) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %156 = "llvm.mul"(%98, %25) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %157 = "llvm.add"(%143, %156) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %158 = "llvm.mul"(%98, %26) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %159 = "llvm.add"(%145, %158) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %160 = "llvm.mul"(%98, %27) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %161 = "llvm.mul"(%98, %28) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %162 = "llvm.add"(%138, %82) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %163 = "llvm.add"(%162, %147) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %164 = "llvm.add"(%163, %161) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %165 = "llvm.add"(%164, %120) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %166 = "llvm.add"(%165, %129) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %167 = "llvm.mul"(%98, %29) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %168 = "llvm.add"(%155, %30) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %169 = "llvm.lshr"(%168, %3) : (i64, i64) -> i64
  %170 = "llvm.add"(%157, %169) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %171 = "llvm.and"(%168, %31) : (i64, i64) -> i64
  %172 = "llvm.sub"(%155, %171) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %173 = "llvm.add"(%159, %30) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %174 = "llvm.lshr"(%173, %3) : (i64, i64) -> i64
  %175 = "llvm.add"(%137, %80) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %176 = "llvm.add"(%175, %146) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %177 = "llvm.add"(%176, %160) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %178 = "llvm.add"(%177, %128) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %179 = "llvm.add"(%178, %174) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %180 = "llvm.and"(%173, %32) : (i64, i64) -> i64
  %181 = "llvm.sub"(%159, %180) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %182 = "llvm.add"(%166, %30) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %183 = "llvm.ashr"(%182, %3) : (i64, i64) -> i64
  %184 = "llvm.add"(%109, %139) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %185 = "llvm.add"(%184, %148) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %186 = "llvm.add"(%185, %167) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %187 = "llvm.add"(%186, %121) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %188 = "llvm.add"(%187, %130) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %189 = "llvm.add"(%188, %183) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %190 = "llvm.and"(%182, %33) : (i64, i64) -> i64
  %191 = "llvm.add"(%153, %30) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %192 = "llvm.ashr"(%191, %3) : (i64, i64) -> i64
  %193 = "llvm.add"(%113, %141) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %194 = "llvm.add"(%193, %123) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %195 = "llvm.add"(%194, %132) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %196 = "llvm.add"(%195, %192) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %197 = "llvm.and"(%191, %33) : (i64, i64) -> i64
  %198 = "llvm.sub"(%153, %197) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %199 = "llvm.add"(%134, %30) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %200 = "llvm.ashr"(%199, %3) : (i64, i64) -> i64
  %201 = "llvm.add"(%127, %200) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %202 = "llvm.and"(%199, %33) : (i64, i64) -> i64
  %203 = "llvm.sub"(%134, %202) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %204 = "llvm.add"(%119, %30) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %205 = "llvm.ashr"(%204, %3) : (i64, i64) -> i64
  %206 = "llvm.add"(%205, %96) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %207 = "llvm.and"(%204, %33) : (i64, i64) -> i64
  %208 = "llvm.sub"(%119, %207) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %209 = "llvm.add"(%170, %30) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %210 = "llvm.lshr"(%209, %3) : (i64, i64) -> i64
  %211 = "llvm.and"(%209, %32) : (i64, i64) -> i64
  %212 = "llvm.add"(%179, %30) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %213 = "llvm.ashr"(%212, %3) : (i64, i64) -> i64
  %214 = "llvm.and"(%212, %33) : (i64, i64) -> i64
  %215 = "llvm.add"(%189, %30) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %216 = "llvm.ashr"(%215, %3) : (i64, i64) -> i64
  %217 = "llvm.add"(%216, %198) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %218 = "llvm.and"(%215, %33) : (i64, i64) -> i64
  %219 = "llvm.sub"(%189, %218) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %220 = "llvm.add"(%196, %30) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %221 = "llvm.ashr"(%220, %3) : (i64, i64) -> i64
  %222 = "llvm.add"(%221, %203) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %223 = "llvm.and"(%220, %33) : (i64, i64) -> i64
  %224 = "llvm.sub"(%196, %223) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %225 = "llvm.add"(%201, %30) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %226 = "llvm.ashr"(%225, %3) : (i64, i64) -> i64
  %227 = "llvm.add"(%226, %208) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %228 = "llvm.and"(%225, %33) : (i64, i64) -> i64
  %229 = "llvm.sub"(%201, %228) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %230 = "llvm.mul"(%206, %24) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %231 = "llvm.add"(%230, %72) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %232 = "llvm.mul"(%206, %25) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %233 = "llvm.add"(%172, %232) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %234 = "llvm.mul"(%206, %26) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %235 = "llvm.mul"(%206, %27) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %236 = "llvm.mul"(%206, %28) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %237 = "llvm.mul"(%206, %29) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %238 = "llvm.add"(%166, %237) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %239 = "llvm.sub"(%238, %190) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %240 = "llvm.add"(%239, %213) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %241 = "llvm.mul"(%227, %24) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %242 = "llvm.add"(%241, %70) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %243 = "llvm.mul"(%227, %25) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %244 = "llvm.add"(%231, %243) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %245 = "llvm.mul"(%227, %26) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %246 = "llvm.add"(%233, %245) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %247 = "llvm.mul"(%227, %27) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %248 = "llvm.mul"(%227, %28) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %249 = "llvm.mul"(%227, %29) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %250 = "llvm.mul"(%229, %24) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %251 = "llvm.add"(%250, %68) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %252 = "llvm.mul"(%229, %25) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %253 = "llvm.add"(%242, %252) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %254 = "llvm.mul"(%229, %26) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %255 = "llvm.add"(%244, %254) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %256 = "llvm.mul"(%229, %27) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %257 = "llvm.add"(%246, %256) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %258 = "llvm.mul"(%229, %28) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %259 = "llvm.mul"(%229, %29) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %260 = "llvm.add"(%181, %235) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %261 = "llvm.add"(%260, %210) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %262 = "llvm.add"(%261, %248) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %263 = "llvm.add"(%262, %259) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %264 = "llvm.mul"(%222, %24) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %265 = "llvm.add"(%264, %66) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %266 = "llvm.mul"(%222, %25) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %267 = "llvm.add"(%251, %266) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %268 = "llvm.mul"(%222, %26) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %269 = "llvm.add"(%253, %268) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %270 = "llvm.mul"(%222, %27) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %271 = "llvm.add"(%255, %270) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %272 = "llvm.mul"(%222, %28) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %273 = "llvm.add"(%257, %272) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %274 = "llvm.mul"(%222, %29) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %275 = "llvm.mul"(%224, %24) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %276 = "llvm.add"(%275, %64) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %277 = "llvm.mul"(%224, %25) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %278 = "llvm.add"(%265, %277) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %279 = "llvm.mul"(%224, %26) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %280 = "llvm.add"(%267, %279) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %281 = "llvm.mul"(%224, %27) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %282 = "llvm.add"(%269, %281) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %283 = "llvm.mul"(%224, %28) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %284 = "llvm.add"(%271, %283) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %285 = "llvm.mul"(%224, %29) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %286 = "llvm.add"(%273, %285) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %287 = "llvm.mul"(%217, %24) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %288 = "llvm.add"(%287, %62) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %289 = "llvm.mul"(%217, %25) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %290 = "llvm.add"(%276, %289) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %291 = "llvm.mul"(%217, %26) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %292 = "llvm.add"(%278, %291) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %293 = "llvm.mul"(%217, %27) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %294 = "llvm.add"(%280, %293) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %295 = "llvm.mul"(%217, %28) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %296 = "llvm.add"(%282, %295) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %297 = "llvm.mul"(%217, %29) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %298 = "llvm.add"(%284, %297) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %299 = "llvm.add"(%288, %30) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %300 = "llvm.ashr"(%299, %3) : (i64, i64) -> i64
  %301 = "llvm.add"(%290, %300) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %302 = "llvm.and"(%299, %33) : (i64, i64) -> i64
  %303 = "llvm.sub"(%288, %302) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %304 = "llvm.add"(%292, %30) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %305 = "llvm.ashr"(%304, %3) : (i64, i64) -> i64
  %306 = "llvm.add"(%294, %305) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %307 = "llvm.and"(%304, %33) : (i64, i64) -> i64
  %308 = "llvm.sub"(%292, %307) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %309 = "llvm.add"(%296, %30) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %310 = "llvm.ashr"(%309, %3) : (i64, i64) -> i64
  %311 = "llvm.add"(%298, %310) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %312 = "llvm.and"(%309, %33) : (i64, i64) -> i64
  %313 = "llvm.sub"(%296, %312) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %314 = "llvm.add"(%286, %30) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %315 = "llvm.ashr"(%314, %3) : (i64, i64) -> i64
  %316 = "llvm.add"(%234, %170) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %317 = "llvm.sub"(%316, %211) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %318 = "llvm.add"(%317, %247) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %319 = "llvm.add"(%318, %258) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %320 = "llvm.add"(%319, %274) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %321 = "llvm.add"(%320, %315) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %322 = "llvm.and"(%314, %33) : (i64, i64) -> i64
  %323 = "llvm.sub"(%286, %322) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %324 = "llvm.add"(%263, %30) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %325 = "llvm.ashr"(%324, %3) : (i64, i64) -> i64
  %326 = "llvm.add"(%179, %236) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %327 = "llvm.sub"(%326, %214) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %328 = "llvm.add"(%327, %249) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %329 = "llvm.add"(%328, %325) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %330 = "llvm.and"(%324, %33) : (i64, i64) -> i64
  %331 = "llvm.sub"(%263, %330) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %332 = "llvm.add"(%240, %30) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %333 = "llvm.ashr"(%332, %3) : (i64, i64) -> i64
  %334 = "llvm.add"(%333, %219) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %335 = "llvm.and"(%332, %33) : (i64, i64) -> i64
  %336 = "llvm.sub"(%240, %335) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %337 = "llvm.add"(%301, %30) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %338 = "llvm.ashr"(%337, %3) : (i64, i64) -> i64
  %339 = "llvm.and"(%337, %33) : (i64, i64) -> i64
  %340 = "llvm.add"(%306, %30) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %341 = "llvm.ashr"(%340, %3) : (i64, i64) -> i64
  %342 = "llvm.and"(%340, %33) : (i64, i64) -> i64
  %343 = "llvm.add"(%311, %30) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %344 = "llvm.ashr"(%343, %3) : (i64, i64) -> i64
  %345 = "llvm.add"(%323, %344) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %346 = "llvm.and"(%343, %33) : (i64, i64) -> i64
  %347 = "llvm.add"(%321, %30) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %348 = "llvm.ashr"(%347, %3) : (i64, i64) -> i64
  %349 = "llvm.add"(%331, %348) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %350 = "llvm.and"(%347, %33) : (i64, i64) -> i64
  %351 = "llvm.sub"(%321, %350) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %352 = "llvm.add"(%329, %30) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %353 = "llvm.ashr"(%352, %3) : (i64, i64) -> i64
  %354 = "llvm.add"(%336, %353) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %355 = "llvm.and"(%352, %33) : (i64, i64) -> i64
  %356 = "llvm.sub"(%329, %355) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %357 = "llvm.add"(%334, %30) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %358 = "llvm.ashr"(%357, %3) : (i64, i64) -> i64
  %359 = "llvm.and"(%357, %33) : (i64, i64) -> i64
  %360 = "llvm.sub"(%334, %359) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %361 = "llvm.mul"(%358, %24) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %362 = "llvm.add"(%303, %361) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %363 = "llvm.mul"(%358, %25) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %364 = "llvm.mul"(%358, %26) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %365 = "llvm.mul"(%358, %27) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %366 = "llvm.mul"(%358, %28) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %367 = "llvm.mul"(%358, %29) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %368 = "llvm.ashr"(%362, %3) : (i64, i64) -> i64
  %369 = "llvm.add"(%363, %301) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %370 = "llvm.sub"(%369, %339) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %371 = "llvm.add"(%370, %368) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %372 = "llvm.and"(%362, %2) : (i64, i64) -> i64
  %373 = "llvm.ashr"(%371, %3) : (i64, i64) -> i64
  %374 = "llvm.add"(%308, %364) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %375 = "llvm.add"(%374, %338) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %376 = "llvm.add"(%375, %373) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %377 = "llvm.and"(%371, %2) : (i64, i64) -> i64
  %378 = "llvm.ashr"(%376, %3) : (i64, i64) -> i64
  %379 = "llvm.add"(%306, %365) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %380 = "llvm.sub"(%379, %342) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %381 = "llvm.add"(%380, %378) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %382 = "llvm.and"(%376, %2) : (i64, i64) -> i64
  %383 = "llvm.ashr"(%381, %3) : (i64, i64) -> i64
  %384 = "llvm.add"(%313, %366) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %385 = "llvm.add"(%384, %341) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %386 = "llvm.add"(%385, %383) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %387 = "llvm.and"(%381, %2) : (i64, i64) -> i64
  %388 = "llvm.ashr"(%386, %3) : (i64, i64) -> i64
  %389 = "llvm.add"(%311, %367) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %390 = "llvm.sub"(%389, %346) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %391 = "llvm.add"(%390, %388) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %392 = "llvm.and"(%386, %2) : (i64, i64) -> i64
  %393 = "llvm.ashr"(%391, %3) : (i64, i64) -> i64
  %394 = "llvm.add"(%345, %393) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %395 = "llvm.and"(%391, %2) : (i64, i64) -> i64
  %396 = "llvm.ashr"(%394, %3) : (i64, i64) -> i64
  %397 = "llvm.add"(%396, %351) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %398 = "llvm.and"(%394, %2) : (i64, i64) -> i64
  %399 = "llvm.ashr"(%397, %3) : (i64, i64) -> i64
  %400 = "llvm.add"(%349, %399) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %401 = "llvm.and"(%397, %2) : (i64, i64) -> i64
  %402 = "llvm.ashr"(%400, %3) : (i64, i64) -> i64
  %403 = "llvm.add"(%402, %356) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %404 = "llvm.and"(%400, %2) : (i64, i64) -> i64
  %405 = "llvm.ashr"(%403, %3) : (i64, i64) -> i64
  %406 = "llvm.add"(%354, %405) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %407 = "llvm.and"(%403, %2) : (i64, i64) -> i64
  %408 = "llvm.ashr"(%406, %3) : (i64, i64) -> i64
  %409 = "llvm.add"(%408, %360) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %410 = "llvm.and"(%406, %2) : (i64, i64) -> i64
  %411 = "llvm.ashr"(%409, %3) : (i64, i64) -> i64
  %412 = "llvm.and"(%409, %2) : (i64, i64) -> i64
  %413 = "llvm.mul"(%411, %24) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %414 = "llvm.add"(%413, %372) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %415 = "llvm.mul"(%411, %25) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %416 = "llvm.add"(%415, %377) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %417 = "llvm.mul"(%411, %26) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %418 = "llvm.add"(%417, %382) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %419 = "llvm.mul"(%411, %27) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %420 = "llvm.add"(%419, %387) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %421 = "llvm.mul"(%411, %28) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %422 = "llvm.add"(%421, %392) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %423 = "llvm.mul"(%411, %29) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %424 = "llvm.add"(%423, %395) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %425 = "llvm.ashr"(%414, %3) : (i64, i64) -> i64
  %426 = "llvm.add"(%416, %425) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %427 = "llvm.and"(%414, %2) : (i64, i64) -> i64
  %428 = "llvm.ashr"(%426, %3) : (i64, i64) -> i64
  %429 = "llvm.add"(%418, %428) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %430 = "llvm.ashr"(%429, %3) : (i64, i64) -> i64
  %431 = "llvm.add"(%420, %430) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %432 = "llvm.ashr"(%431, %3) : (i64, i64) -> i64
  %433 = "llvm.add"(%422, %432) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %434 = "llvm.ashr"(%433, %3) : (i64, i64) -> i64
  %435 = "llvm.add"(%424, %434) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %436 = "llvm.ashr"(%435, %3) : (i64, i64) -> i64
  %437 = "llvm.add"(%436, %398) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %438 = "llvm.ashr"(%437, %3) : (i64, i64) -> i64
  %439 = "llvm.add"(%438, %401) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %440 = "llvm.ashr"(%439, %3) : (i64, i64) -> i64
  %441 = "llvm.add"(%440, %404) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %442 = "llvm.ashr"(%441, %3) : (i64, i64) -> i64
  %443 = "llvm.add"(%442, %407) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %444 = "llvm.ashr"(%443, %3) : (i64, i64) -> i64
  %445 = "llvm.add"(%444, %410) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %446 = "llvm.lshr"(%445, %3) : (i64, i64) -> i64
  %447 = "llvm.add"(%446, %412) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %448 = "llvm.shl"(%426, %3) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %449 = "llvm.and"(%448, %34) : (i64, i64) -> i64
  %450 = "llvm.or"(%449, %427) <{isDisjoint}> : (i64, i64) -> i64
  %451 = "llvm.shl"(%429, %4) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %452 = "llvm.and"(%451, %35) : (i64, i64) -> i64
  %453 = "llvm.or"(%450, %452) <{isDisjoint}> : (i64, i64) -> i64
  %454 = "llvm.shl"(%431, %36) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %455 = "llvm.or"(%453, %454) <{isDisjoint}> : (i64, i64) -> i64
  "llvm.store"(%455, %arg0) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %456 = "llvm.lshr"(%431, %5) : (i64, i64) -> i64
  %457 = "llvm.and"(%456, %37) : (i64, i64) -> i64
  %458 = "llvm.shl"(%433, %6) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %459 = "llvm.and"(%458, %38) : (i64, i64) -> i64
  %460 = "llvm.or"(%459, %457) <{isDisjoint}> : (i64, i64) -> i64
  %461 = "llvm.shl"(%435, %7) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %462 = "llvm.and"(%461, %39) : (i64, i64) -> i64
  %463 = "llvm.or"(%460, %462) <{isDisjoint}> : (i64, i64) -> i64
  %464 = "llvm.shl"(%437, %40) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %465 = "llvm.or"(%463, %464) <{isDisjoint}> : (i64, i64) -> i64
  %466 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%465, %466) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %467 = "llvm.lshr"(%437, %8) : (i64, i64) -> i64
  %468 = "llvm.and"(%467, %41) : (i64, i64) -> i64
  %469 = "llvm.shl"(%439, %9) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %470 = "llvm.and"(%469, %42) : (i64, i64) -> i64
  %471 = "llvm.or"(%470, %468) <{isDisjoint}> : (i64, i64) -> i64
  %472 = "llvm.shl"(%441, %1) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %473 = "llvm.and"(%472, %43) : (i64, i64) -> i64
  %474 = "llvm.or"(%471, %473) <{isDisjoint}> : (i64, i64) -> i64
  %475 = "llvm.shl"(%443, %44) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %476 = "llvm.or"(%474, %475) <{isDisjoint}> : (i64, i64) -> i64
  %477 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%476, %477) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %478 = "llvm.lshr"(%443, %10) : (i64, i64) -> i64
  %479 = "llvm.and"(%478, %45) : (i64, i64) -> i64
  %480 = "llvm.shl"(%445, %11) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %481 = "llvm.and"(%480, %46) : (i64, i64) -> i64
  %482 = "llvm.or"(%479, %481) <{isDisjoint}> : (i64, i64) -> i64
  %483 = "llvm.shl"(%447, %12) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %484 = "llvm.or"(%482, %483) <{isDisjoint}> : (i64, i64) -> i64
  %485 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%484, %485) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  "llvm.return"(%arg0) : (!llvm.ptr) -> ()
}) : () -> ()

end

end MLIR.Firedancer.Crc.Ref
