
module

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab



namespace Firedancer.LaneNI.Mlir

@[expose] public section

mlir_def fd_curve25519_scalar_reduce := "llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.nofree, llvm.noundef, llvm.returned, llvm.writeonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}], frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<ptr (ptr, ptr)>, linkage = #llvm.linkage<external>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", "sspstrong", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "znver4"]], res_attrs = [{llvm.noundef}], sym_name = "fd_curve25519_scalar_reduce", target_cpu = "znver4", target_features = #llvm.target_features<["+64bit", "+adx", "+aes", "+avx", "+avx2", "+avx512bf16", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+clzero", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fast-vector-fsqrt", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+mwaitx", "+pclmul", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdpru", "+rdrnd", "+rdseed", "+sahf", "+sha", "+shstk", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+sse4a", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tile", "-avx10.1", "-avx10.2", "-avx512bmm", "-avx512fp16", "-avx512vp2intersect", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-ccmp", "-cf", "-cldemote", "-cmpccxadd", "-egpr", "-enqcmd", "-fma4", "-hreset", "-jmpabs", "-kl", "-lwp", "-movdir64b", "-movdiri", "-movrs", "-ndd", "-nf", "-pconfig", "-ppx", "-prefetchi", "-ptwrite", "-push2pop2", "-raoint", "-rtm", "-serialize", "-sgx", "-sha512", "-sm3", "-sm4", "-tbm", "-tsxldtrk", "-uintr", "-usermsr", "-waitpkg", "-widekl", "-xop", "-zu"]>, tune_cpu = "znver4", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg0: !llvm.ptr, %arg1: !llvm.ptr):
  %0 = "llvm.mlir.constant"() <{value = dense<[63, 62, 61, 39]> : vector<4xi64>}> : () -> vector<4xi64>
  %1 = "llvm.mlir.constant"() <{value = dense<[4398044413952, 2199022206976, 1099511103488, 549755551744]> : vector<4xi64>}> : () -> vector<4xi64>
  %2 = "llvm.mlir.constant"() <{value = dense<[21, 20, 19, 18]> : vector<4xi64>}> : () -> vector<4xi64>
  %3 = "llvm.mlir.constant"() <{value = dense<[9223367638808264704, 4611683819404132352, 2305841909702066176, 262143]> : vector<4xi64>}> : () -> vector<4xi64>
  %4 = "llvm.mlir.constant"() <{value = dense<[42, 41, 40, 3]> : vector<4xi64>}> : () -> vector<4xi64>
  %5 = "llvm.mlir.poison"() : () -> vector<4xi64>
  %6 = "llvm.mlir.constant"() <{value = dense<[2097151, 1048575, 524287, 0]> : vector<4xi64>}> : () -> vector<4xi64>
  %7 = "llvm.mlir.constant"() <{value = dense<[0, 1, 2, 0]> : vector<4xi64>}> : () -> vector<4xi64>
  %8 = "llvm.mlir.constant"() <{value = 3 : i32}> : () -> i32
  %9 = "llvm.mlir.constant"() <{value = 2 : i32}> : () -> i32
  %10 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %11 = "llvm.mlir.constant"() <{value = 40 : i64}> : () -> i64
  %12 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %13 = "llvm.mlir.constant"() <{value = 2097151 : i64}> : () -> i64
  %14 = "llvm.mlir.constant"() <{value = 21 : i64}> : () -> i64
  %15 = "llvm.mlir.constant"() <{value = 42 : i64}> : () -> i64
  %16 = "llvm.mlir.constant"() <{value = dense<[1, 2, 3, 4]> : vector<4xi64>}> : () -> vector<4xi64>
  %17 = "llvm.mlir.constant"() <{value = 20 : i64}> : () -> i64
  %18 = "llvm.mlir.constant"() <{value = 41 : i64}> : () -> i64
  %19 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %20 = "llvm.mlir.constant"() <{value = 19 : i64}> : () -> i64
  %21 = "llvm.mlir.constant"() <{value = 2 : i64}> : () -> i64
  %22 = "llvm.mlir.constant"() <{value = 18 : i64}> : () -> i64
  %23 = "llvm.mlir.constant"() <{value = 39 : i64}> : () -> i64
  %24 = "llvm.mlir.constant"() <{value = 3 : i64}> : () -> i64
  %25 = "llvm.mlir.constant"() <{value = 17 : i64}> : () -> i64
  %26 = "llvm.mlir.constant"() <{value = 38 : i64}> : () -> i64
  %27 = "llvm.mlir.constant"() <{value = 5 : i64}> : () -> i64
  %28 = "llvm.mlir.constant"() <{value = 16 : i64}> : () -> i64
  %29 = "llvm.mlir.constant"() <{value = 37 : i64}> : () -> i64
  %30 = "llvm.mlir.constant"() <{value = dense<[6, 7]> : vector<2xi64>}> : () -> vector<2xi64>
  %31 = "llvm.mlir.constant"() <{value = dense<[15, 14]> : vector<2xi64>}> : () -> vector<2xi64>
  %32 = "llvm.mlir.constant"() <{value = dense<2097151> : vector<4xi64>}> : () -> vector<4xi64>
  %33 = "llvm.mlir.poison"() : () -> vector<2xi64>
  %34 = "llvm.mlir.constant"() <{value = dense<[35, 36, 0, 0]> : vector<4xi64>}> : () -> vector<4xi64>
  %35 = "llvm.mlir.constant"() <{value = dense<[-1, 2097151, -1, -1]> : vector<4xi64>}> : () -> vector<4xi64>
  %36 = "llvm.mlir.constant"() <{value = 666643 : i64}> : () -> i64
  %37 = "llvm.mlir.constant"() <{value = 470296 : i64}> : () -> i64
  %38 = "llvm.mlir.constant"() <{value = dense<[654183, -683901, -997805, 136657]> : vector<4xi64>}> : () -> vector<4xi64>
  %39 = "llvm.mlir.constant"() <{value = -997805 : i64}> : () -> i64
  %40 = "llvm.mlir.constant"() <{value = 136657 : i64}> : () -> i64
  %41 = "llvm.mlir.constant"() <{value = -683901 : i64}> : () -> i64
  %42 = "llvm.mlir.constant"() <{value = 654183 : i64}> : () -> i64
  %43 = "llvm.mlir.constant"() <{value = dense<[136657, -683901, 654183, -997805]> : vector<4xi64>}> : () -> vector<4xi64>
  %44 = "llvm.mlir.constant"() <{value = dense<[136657, -683901, 470296, 654183]> : vector<4xi64>}> : () -> vector<4xi64>
  %45 = "llvm.mlir.constant"() <{value = 1048576 : i64}> : () -> i64
  %46 = "llvm.mlir.constant"() <{value = 8796090925056 : i64}> : () -> i64
  %47 = "llvm.mlir.constant"() <{value = 9223372036852678656 : i64}> : () -> i64
  %48 = "llvm.mlir.constant"() <{value = -2097152 : i64}> : () -> i64
  %49 = "llvm.mlir.constant"() <{value = -1 : i64}> : () -> i64
  %50 = "llvm.mlir.poison"() : () -> i64
  %51 = "llvm.mlir.undef"() : () -> vector<4xi64>
  %52 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %53 = "llvm.insertelement"(%51, %50, %52) : (vector<4xi64>, i64, i32) -> vector<4xi64>
  %54 = "llvm.insertelement"(%53, %50, %10) : (vector<4xi64>, i64, i32) -> vector<4xi64>
  %55 = "llvm.insertelement"(%54, %50, %9) : (vector<4xi64>, i64, i32) -> vector<4xi64>
  %56 = "llvm.insertelement"(%55, %49, %8) : (vector<4xi64>, i64, i32) -> vector<4xi64>
  %57 = "llvm.getelementptr"(%arg1) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %58 = "llvm.getelementptr"(%arg1) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 40>}> : (!llvm.ptr) -> !llvm.ptr
  %59 = "llvm.getelementptr"(%arg1) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 48>}> : (!llvm.ptr) -> !llvm.ptr
  %60 = "llvm.load"(%arg1) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %61 = "llvm.load"(%57) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %62 = "llvm.extractelement"(%60, %12) : (vector<4xi64>, i64) -> i64
  %63 = "llvm.and"(%62, %13) : (i64, i64) -> i64
  %64 = "llvm.lshr"(%62, %14) : (i64, i64) -> i64
  %65 = "llvm.and"(%64, %13) : (i64, i64) -> i64
  %66 = "llvm.lshr"(%62, %15) : (i64, i64) -> i64
  %67 = "llvm.and"(%66, %13) : (i64, i64) -> i64
  %68 = "llvm.intr.fshl"(%61, %60, %16) : (vector<4xi64>, vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %69 = "llvm.extractelement"(%68, %12) : (vector<4xi64>, i64) -> i64
  %70 = "llvm.and"(%69, %13) : (i64, i64) -> i64
  %71 = "llvm.extractelement"(%61, %12) : (vector<4xi64>, i64) -> i64
  %72 = "llvm.lshr"(%71, %17) : (i64, i64) -> i64
  %73 = "llvm.and"(%72, %13) : (i64, i64) -> i64
  %74 = "llvm.lshr"(%71, %18) : (i64, i64) -> i64
  %75 = "llvm.and"(%74, %13) : (i64, i64) -> i64
  %76 = "llvm.extractelement"(%68, %19) : (vector<4xi64>, i64) -> i64
  %77 = "llvm.and"(%76, %13) : (i64, i64) -> i64
  %78 = "llvm.extractelement"(%61, %19) : (vector<4xi64>, i64) -> i64
  %79 = "llvm.lshr"(%78, %20) : (i64, i64) -> i64
  %80 = "llvm.and"(%79, %13) : (i64, i64) -> i64
  %81 = "llvm.lshr"(%78, %11) : (i64, i64) -> i64
  %82 = "llvm.and"(%81, %13) : (i64, i64) -> i64
  %83 = "llvm.extractelement"(%68, %21) : (vector<4xi64>, i64) -> i64
  %84 = "llvm.and"(%83, %13) : (i64, i64) -> i64
  %85 = "llvm.extractelement"(%61, %21) : (vector<4xi64>, i64) -> i64
  %86 = "llvm.lshr"(%85, %22) : (i64, i64) -> i64
  %87 = "llvm.and"(%86, %13) : (i64, i64) -> i64
  %88 = "llvm.lshr"(%85, %23) : (i64, i64) -> i64
  %89 = "llvm.and"(%88, %13) : (i64, i64) -> i64
  %90 = "llvm.extractelement"(%68, %24) : (vector<4xi64>, i64) -> i64
  %91 = "llvm.and"(%90, %13) : (i64, i64) -> i64
  %92 = "llvm.extractelement"(%61, %24) : (vector<4xi64>, i64) -> i64
  %93 = "llvm.lshr"(%92, %25) : (i64, i64) -> i64
  %94 = "llvm.and"(%93, %13) : (i64, i64) -> i64
  %95 = "llvm.lshr"(%92, %26) : (i64, i64) -> i64
  %96 = "llvm.and"(%95, %13) : (i64, i64) -> i64
  %97 = "llvm.load"(%58) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<2xi64>
  %98 = "llvm.load"(%59) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<2xi64>
  %99 = "llvm.extractelement"(%97, %12) : (vector<2xi64>, i64) -> i64
  %100 = "llvm.intr.fshl"(%99, %92, %27) : (i64, i64, i64) -> i64
  %101 = "llvm.and"(%100, %13) : (i64, i64) -> i64
  %102 = "llvm.lshr"(%99, %28) : (i64, i64) -> i64
  %103 = "llvm.and"(%102, %13) : (i64, i64) -> i64
  %104 = "llvm.lshr"(%99, %29) : (i64, i64) -> i64
  %105 = "llvm.and"(%104, %13) : (i64, i64) -> i64
  %106 = "llvm.intr.fshl"(%98, %97, %30) : (vector<2xi64>, vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %107 = "llvm.lshr"(%98, %31) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %108 = "llvm.shufflevector"(%107, %106) <{mask = array<i32: 0, 2, 1, 3>}> : (vector<2xi64>, vector<2xi64>) -> vector<4xi64>
  %109 = "llvm.and"(%108, %32) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %110 = "llvm.extractelement"(%109, %21) : (vector<4xi64>, i64) -> i64
  %111 = "llvm.extractelement"(%109, %24) : (vector<4xi64>, i64) -> i64
  %112 = "llvm.shufflevector"(%98, %33) <{mask = array<i32: 0, 1, -1, -1>}> : (vector<2xi64>, vector<2xi64>) -> vector<4xi64>
  %113 = "llvm.shufflevector"(%112, %109) <{mask = array<i32: 1, 0, 6, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %114 = "llvm.lshr"(%113, %34) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %115 = "llvm.and"(%114, %35) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %116 = "llvm.extractelement"(%114, %12) : (vector<4xi64>, i64) -> i64
  %117 = "llvm.mul"(%116, %36) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %118 = "llvm.mul"(%116, %37) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %119 = "llvm.mul"(%115, %38) <{overflowFlags = 1 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %120 = "llvm.mul"(%116, %39) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %121 = "llvm.add"(%120, %96) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %122 = "llvm.mul"(%116, %40) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %123 = "llvm.add"(%122, %101) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %124 = "llvm.mul"(%116, %41) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %125 = "llvm.add"(%124, %103) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %126 = "llvm.mul"(%110, %36) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %127 = "llvm.mul"(%110, %40) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %128 = "llvm.add"(%121, %127) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %129 = "llvm.mul"(%110, %41) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %130 = "llvm.add"(%123, %129) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %131 = "llvm.mul"(%111, %36) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %132 = "llvm.mul"(%111, %37) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %133 = "llvm.mul"(%111, %41) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %134 = "llvm.add"(%128, %133) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %135 = "llvm.extractelement"(%115, %19) : (vector<4xi64>, i64) -> i64
  %136 = "llvm.mul"(%135, %36) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %137 = "llvm.add"(%136, %82) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %138 = "llvm.mul"(%135, %37) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %139 = "llvm.mul"(%135, %42) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %140 = "llvm.mul"(%135, %39) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %141 = "llvm.extractelement"(%109, %12) : (vector<4xi64>, i64) -> i64
  %142 = "llvm.mul"(%141, %36) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %143 = "llvm.add"(%142, %80) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %144 = "llvm.mul"(%141, %37) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %145 = "llvm.add"(%137, %144) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %146 = "llvm.mul"(%141, %42) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %147 = "llvm.mul"(%141, %39) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %148 = "llvm.shufflevector"(%115, %109) <{mask = array<i32: 1, 4, 6, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %149 = "llvm.mul"(%148, %43) <{overflowFlags = 1 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %150 = "llvm.intr.vector.reduce.add"(%149) : (vector<4xi64>) -> i64
  %151 = "llvm.add"(%150, %118) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %152 = "llvm.add"(%151, %91) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %153 = "llvm.extractelement"(%109, %19) : (vector<4xi64>, i64) -> i64
  %154 = "llvm.mul"(%153, %36) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %155 = "llvm.add"(%154, %77) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %156 = "llvm.mul"(%153, %37) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %157 = "llvm.add"(%143, %156) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %158 = "llvm.mul"(%153, %42) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %159 = "llvm.add"(%145, %158) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %160 = "llvm.mul"(%153, %39) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %161 = "llvm.mul"(%153, %40) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %162 = "llvm.add"(%139, %87) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %163 = "llvm.add"(%162, %147) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %164 = "llvm.add"(%163, %161) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %165 = "llvm.add"(%164, %126) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %166 = "llvm.add"(%165, %132) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %167 = "llvm.mul"(%109, %44) <{overflowFlags = 1 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %168 = "llvm.add"(%155, %45) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %169 = "llvm.lshr"(%168, %14) : (i64, i64) -> i64
  %170 = "llvm.add"(%157, %169) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %171 = "llvm.and"(%168, %46) : (i64, i64) -> i64
  %172 = "llvm.sub"(%155, %171) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %173 = "llvm.add"(%159, %45) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %174 = "llvm.lshr"(%173, %14) : (i64, i64) -> i64
  %175 = "llvm.add"(%138, %84) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %176 = "llvm.add"(%175, %146) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %177 = "llvm.add"(%176, %160) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %178 = "llvm.add"(%177, %131) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %179 = "llvm.add"(%178, %174) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %180 = "llvm.and"(%173, %47) : (i64, i64) -> i64
  %181 = "llvm.sub"(%159, %180) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %182 = "llvm.add"(%166, %45) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %183 = "llvm.ashr"(%182, %14) : (i64, i64) -> i64
  %184 = "llvm.intr.vector.reduce.add"(%167) : (vector<4xi64>) -> i64
  %185 = "llvm.add"(%184, %117) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %186 = "llvm.add"(%140, %183) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %187 = "llvm.add"(%185, %186) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %188 = "llvm.add"(%187, %89) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %189 = "llvm.and"(%182, %48) : (i64, i64) -> i64
  %190 = "llvm.add"(%152, %45) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %191 = "llvm.ashr"(%190, %14) : (i64, i64) -> i64
  %192 = "llvm.intr.vector.reduce.add"(%119) : (vector<4xi64>) -> i64
  %193 = "llvm.add"(%192, %191) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %194 = "llvm.add"(%193, %94) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %195 = "llvm.and"(%190, %48) : (i64, i64) -> i64
  %196 = "llvm.sub"(%152, %195) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %197 = "llvm.add"(%134, %45) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %198 = "llvm.ashr"(%197, %14) : (i64, i64) -> i64
  %199 = "llvm.add"(%130, %198) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %200 = "llvm.and"(%197, %48) : (i64, i64) -> i64
  %201 = "llvm.sub"(%134, %200) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %202 = "llvm.add"(%125, %45) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %203 = "llvm.ashr"(%202, %14) : (i64, i64) -> i64
  %204 = "llvm.add"(%203, %105) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %205 = "llvm.and"(%202, %48) : (i64, i64) -> i64
  %206 = "llvm.sub"(%125, %205) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %207 = "llvm.add"(%170, %45) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %208 = "llvm.lshr"(%207, %14) : (i64, i64) -> i64
  %209 = "llvm.and"(%207, %47) : (i64, i64) -> i64
  %210 = "llvm.add"(%179, %45) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %211 = "llvm.ashr"(%210, %14) : (i64, i64) -> i64
  %212 = "llvm.and"(%210, %48) : (i64, i64) -> i64
  %213 = "llvm.add"(%188, %45) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %214 = "llvm.ashr"(%213, %14) : (i64, i64) -> i64
  %215 = "llvm.add"(%214, %196) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %216 = "llvm.and"(%213, %48) : (i64, i64) -> i64
  %217 = "llvm.sub"(%188, %216) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %218 = "llvm.add"(%194, %45) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %219 = "llvm.ashr"(%218, %14) : (i64, i64) -> i64
  %220 = "llvm.add"(%219, %201) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %221 = "llvm.and"(%218, %48) : (i64, i64) -> i64
  %222 = "llvm.sub"(%194, %221) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %223 = "llvm.add"(%199, %45) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %224 = "llvm.ashr"(%223, %14) : (i64, i64) -> i64
  %225 = "llvm.add"(%224, %206) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %226 = "llvm.and"(%223, %48) : (i64, i64) -> i64
  %227 = "llvm.sub"(%199, %226) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %228 = "llvm.mul"(%204, %36) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %229 = "llvm.add"(%228, %75) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %230 = "llvm.mul"(%204, %37) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %231 = "llvm.add"(%172, %230) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %232 = "llvm.mul"(%204, %42) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %233 = "llvm.mul"(%204, %39) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %234 = "llvm.mul"(%204, %40) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %235 = "llvm.mul"(%204, %41) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %236 = "llvm.add"(%166, %235) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %237 = "llvm.sub"(%236, %189) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %238 = "llvm.add"(%237, %211) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %239 = "llvm.mul"(%225, %36) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %240 = "llvm.add"(%239, %73) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %241 = "llvm.mul"(%225, %37) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %242 = "llvm.add"(%229, %241) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %243 = "llvm.mul"(%225, %42) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %244 = "llvm.add"(%231, %243) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %245 = "llvm.mul"(%225, %39) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %246 = "llvm.mul"(%225, %40) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %247 = "llvm.mul"(%225, %41) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %248 = "llvm.mul"(%227, %36) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %249 = "llvm.add"(%248, %70) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %250 = "llvm.mul"(%227, %37) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %251 = "llvm.add"(%240, %250) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %252 = "llvm.mul"(%227, %42) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %253 = "llvm.add"(%242, %252) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %254 = "llvm.mul"(%227, %39) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %255 = "llvm.add"(%244, %254) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %256 = "llvm.mul"(%227, %40) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %257 = "llvm.mul"(%227, %41) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %258 = "llvm.add"(%181, %233) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %259 = "llvm.add"(%258, %208) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %260 = "llvm.add"(%259, %246) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %261 = "llvm.add"(%260, %257) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %262 = "llvm.mul"(%220, %36) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %263 = "llvm.add"(%262, %67) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %264 = "llvm.mul"(%220, %37) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %265 = "llvm.add"(%249, %264) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %266 = "llvm.mul"(%220, %42) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %267 = "llvm.add"(%251, %266) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %268 = "llvm.mul"(%220, %39) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %269 = "llvm.add"(%253, %268) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %270 = "llvm.mul"(%220, %40) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %271 = "llvm.add"(%255, %270) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %272 = "llvm.mul"(%220, %41) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %273 = "llvm.mul"(%222, %36) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %274 = "llvm.add"(%273, %65) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %275 = "llvm.mul"(%222, %37) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %276 = "llvm.add"(%263, %275) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %277 = "llvm.mul"(%222, %42) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %278 = "llvm.add"(%265, %277) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %279 = "llvm.mul"(%222, %39) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %280 = "llvm.add"(%267, %279) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %281 = "llvm.mul"(%222, %40) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %282 = "llvm.add"(%269, %281) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %283 = "llvm.mul"(%222, %41) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %284 = "llvm.add"(%271, %283) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %285 = "llvm.mul"(%215, %36) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %286 = "llvm.add"(%285, %63) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %287 = "llvm.mul"(%215, %37) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %288 = "llvm.add"(%274, %287) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %289 = "llvm.mul"(%215, %42) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %290 = "llvm.add"(%276, %289) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %291 = "llvm.mul"(%215, %39) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %292 = "llvm.add"(%278, %291) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %293 = "llvm.mul"(%215, %40) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %294 = "llvm.add"(%280, %293) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %295 = "llvm.mul"(%215, %41) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %296 = "llvm.add"(%282, %295) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %297 = "llvm.add"(%286, %45) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %298 = "llvm.ashr"(%297, %14) : (i64, i64) -> i64
  %299 = "llvm.add"(%288, %298) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %300 = "llvm.and"(%297, %48) : (i64, i64) -> i64
  %301 = "llvm.sub"(%286, %300) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %302 = "llvm.add"(%290, %45) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %303 = "llvm.ashr"(%302, %14) : (i64, i64) -> i64
  %304 = "llvm.add"(%292, %303) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %305 = "llvm.and"(%302, %48) : (i64, i64) -> i64
  %306 = "llvm.sub"(%290, %305) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %307 = "llvm.add"(%294, %45) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %308 = "llvm.ashr"(%307, %14) : (i64, i64) -> i64
  %309 = "llvm.add"(%296, %308) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %310 = "llvm.and"(%307, %48) : (i64, i64) -> i64
  %311 = "llvm.sub"(%294, %310) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %312 = "llvm.add"(%284, %45) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %313 = "llvm.ashr"(%312, %14) : (i64, i64) -> i64
  %314 = "llvm.add"(%232, %170) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %315 = "llvm.sub"(%314, %209) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %316 = "llvm.add"(%315, %245) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %317 = "llvm.add"(%316, %256) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %318 = "llvm.add"(%317, %272) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %319 = "llvm.add"(%318, %313) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %320 = "llvm.and"(%312, %48) : (i64, i64) -> i64
  %321 = "llvm.sub"(%284, %320) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %322 = "llvm.add"(%261, %45) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %323 = "llvm.ashr"(%322, %14) : (i64, i64) -> i64
  %324 = "llvm.add"(%179, %234) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %325 = "llvm.sub"(%324, %212) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %326 = "llvm.add"(%325, %247) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %327 = "llvm.add"(%326, %323) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %328 = "llvm.and"(%322, %48) : (i64, i64) -> i64
  %329 = "llvm.sub"(%261, %328) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %330 = "llvm.add"(%238, %45) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %331 = "llvm.ashr"(%330, %14) : (i64, i64) -> i64
  %332 = "llvm.add"(%331, %217) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %333 = "llvm.and"(%330, %48) : (i64, i64) -> i64
  %334 = "llvm.sub"(%238, %333) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %335 = "llvm.add"(%299, %45) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %336 = "llvm.ashr"(%335, %14) : (i64, i64) -> i64
  %337 = "llvm.and"(%335, %48) : (i64, i64) -> i64
  %338 = "llvm.add"(%304, %45) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %339 = "llvm.ashr"(%338, %14) : (i64, i64) -> i64
  %340 = "llvm.and"(%338, %48) : (i64, i64) -> i64
  %341 = "llvm.add"(%309, %45) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %342 = "llvm.ashr"(%341, %14) : (i64, i64) -> i64
  %343 = "llvm.add"(%321, %342) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %344 = "llvm.and"(%341, %48) : (i64, i64) -> i64
  %345 = "llvm.add"(%319, %45) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %346 = "llvm.ashr"(%345, %14) : (i64, i64) -> i64
  %347 = "llvm.add"(%329, %346) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %348 = "llvm.and"(%345, %48) : (i64, i64) -> i64
  %349 = "llvm.sub"(%319, %348) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %350 = "llvm.add"(%327, %45) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %351 = "llvm.ashr"(%350, %14) : (i64, i64) -> i64
  %352 = "llvm.add"(%334, %351) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %353 = "llvm.and"(%350, %48) : (i64, i64) -> i64
  %354 = "llvm.sub"(%327, %353) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %355 = "llvm.add"(%332, %45) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %356 = "llvm.ashr"(%355, %14) : (i64, i64) -> i64
  %357 = "llvm.and"(%355, %48) : (i64, i64) -> i64
  %358 = "llvm.sub"(%332, %357) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %359 = "llvm.mul"(%356, %36) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %360 = "llvm.add"(%301, %359) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %361 = "llvm.mul"(%356, %37) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %362 = "llvm.mul"(%356, %42) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %363 = "llvm.mul"(%356, %39) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %364 = "llvm.mul"(%356, %40) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %365 = "llvm.mul"(%356, %41) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %366 = "llvm.ashr"(%360, %14) : (i64, i64) -> i64
  %367 = "llvm.add"(%361, %299) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %368 = "llvm.sub"(%367, %337) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %369 = "llvm.add"(%368, %366) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %370 = "llvm.and"(%360, %13) : (i64, i64) -> i64
  %371 = "llvm.ashr"(%369, %14) : (i64, i64) -> i64
  %372 = "llvm.add"(%306, %362) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %373 = "llvm.add"(%372, %336) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %374 = "llvm.add"(%373, %371) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %375 = "llvm.and"(%369, %13) : (i64, i64) -> i64
  %376 = "llvm.ashr"(%374, %14) : (i64, i64) -> i64
  %377 = "llvm.add"(%304, %363) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %378 = "llvm.sub"(%377, %340) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %379 = "llvm.add"(%378, %376) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %380 = "llvm.and"(%374, %13) : (i64, i64) -> i64
  %381 = "llvm.ashr"(%379, %14) : (i64, i64) -> i64
  %382 = "llvm.add"(%311, %364) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %383 = "llvm.add"(%382, %339) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %384 = "llvm.add"(%383, %381) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %385 = "llvm.and"(%379, %13) : (i64, i64) -> i64
  %386 = "llvm.ashr"(%384, %14) : (i64, i64) -> i64
  %387 = "llvm.add"(%309, %365) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %388 = "llvm.sub"(%387, %344) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %389 = "llvm.add"(%388, %386) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %390 = "llvm.and"(%384, %13) : (i64, i64) -> i64
  %391 = "llvm.ashr"(%389, %14) : (i64, i64) -> i64
  %392 = "llvm.add"(%343, %391) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %393 = "llvm.and"(%389, %13) : (i64, i64) -> i64
  %394 = "llvm.ashr"(%392, %14) : (i64, i64) -> i64
  %395 = "llvm.add"(%394, %349) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %396 = "llvm.and"(%392, %13) : (i64, i64) -> i64
  %397 = "llvm.ashr"(%395, %14) : (i64, i64) -> i64
  %398 = "llvm.add"(%347, %397) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %399 = "llvm.and"(%395, %13) : (i64, i64) -> i64
  %400 = "llvm.ashr"(%398, %14) : (i64, i64) -> i64
  %401 = "llvm.add"(%400, %354) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %402 = "llvm.and"(%398, %13) : (i64, i64) -> i64
  %403 = "llvm.ashr"(%401, %14) : (i64, i64) -> i64
  %404 = "llvm.add"(%352, %403) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %405 = "llvm.and"(%401, %13) : (i64, i64) -> i64
  %406 = "llvm.ashr"(%404, %14) : (i64, i64) -> i64
  %407 = "llvm.add"(%406, %358) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %408 = "llvm.and"(%404, %13) : (i64, i64) -> i64
  %409 = "llvm.ashr"(%407, %14) : (i64, i64) -> i64
  %410 = "llvm.and"(%407, %13) : (i64, i64) -> i64
  %411 = "llvm.mul"(%409, %36) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %412 = "llvm.mul"(%409, %37) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %413 = "llvm.add"(%412, %375) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %414 = "llvm.mul"(%409, %42) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %415 = "llvm.add"(%414, %380) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %416 = "llvm.mul"(%409, %39) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %417 = "llvm.add"(%416, %385) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %418 = "llvm.mul"(%409, %40) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %419 = "llvm.add"(%418, %390) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %420 = "llvm.mul"(%409, %41) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %421 = "llvm.add"(%420, %393) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %422 = "llvm.add"(%411, %370) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %423 = "llvm.ashr"(%422, %14) : (i64, i64) -> i64
  %424 = "llvm.add"(%413, %423) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %425 = "llvm.ashr"(%424, %14) : (i64, i64) -> i64
  %426 = "llvm.add"(%415, %425) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %427 = "llvm.ashr"(%426, %14) : (i64, i64) -> i64
  %428 = "llvm.add"(%417, %427) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %429 = "llvm.ashr"(%428, %14) : (i64, i64) -> i64
  %430 = "llvm.add"(%419, %429) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %431 = "llvm.ashr"(%430, %14) : (i64, i64) -> i64
  %432 = "llvm.add"(%421, %431) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %433 = "llvm.ashr"(%432, %14) : (i64, i64) -> i64
  %434 = "llvm.add"(%433, %396) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %435 = "llvm.ashr"(%434, %14) : (i64, i64) -> i64
  %436 = "llvm.add"(%435, %399) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %437 = "llvm.ashr"(%436, %14) : (i64, i64) -> i64
  %438 = "llvm.add"(%437, %402) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %439 = "llvm.ashr"(%438, %14) : (i64, i64) -> i64
  %440 = "llvm.add"(%439, %405) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %441 = "llvm.ashr"(%440, %14) : (i64, i64) -> i64
  %442 = "llvm.add"(%441, %408) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %443 = "llvm.lshr"(%442, %14) : (i64, i64) -> i64
  %444 = "llvm.add"(%443, %410) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %445 = "llvm.insertelement"(%56, %422, %12) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %446 = "llvm.insertelement"(%445, %428, %19) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %447 = "llvm.insertelement"(%446, %434, %21) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %448 = "llvm.lshr"(%447, %7) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %449 = "llvm.and"(%448, %6) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %450 = "llvm.insertelement"(%5, %426, %12) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %451 = "llvm.insertelement"(%450, %432, %19) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %452 = "llvm.insertelement"(%451, %438, %21) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %453 = "llvm.insertelement"(%452, %440, %24) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %454 = "llvm.shl"(%453, %4) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %455 = "llvm.lshr"(%453, %4) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %456 = "llvm.shufflevector"(%454, %455) <{mask = array<i32: 0, 1, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %457 = "llvm.and"(%456, %3) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %458 = "llvm.insertelement"(%5, %424, %12) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %459 = "llvm.insertelement"(%458, %430, %19) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %460 = "llvm.insertelement"(%459, %436, %21) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %461 = "llvm.insertelement"(%460, %442, %24) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %462 = "llvm.shl"(%461, %2) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %463 = "llvm.and"(%462, %1) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %464 = "llvm.or"(%463, %449) <{isDisjoint}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %465 = "llvm.or"(%457, %464) <{isDisjoint}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %466 = "llvm.insertelement"(%5, %428, %12) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %467 = "llvm.insertelement"(%466, %434, %19) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %468 = "llvm.insertelement"(%467, %440, %21) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %469 = "llvm.insertelement"(%468, %444, %24) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %470 = "llvm.shl"(%469, %0) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %471 = "llvm.or"(%465, %470) <{isDisjoint}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.store"(%471, %arg0) <{alignment = 8 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  "llvm.return"(%arg0) : (!llvm.ptr) -> ()
}) : () -> ()

end

end Firedancer.LaneNI.Mlir
