
module

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

public import Firedancer.Lane.Mlir.__func___fd_f25519_debug
public import Firedancer.Lane.Mlir._str_21
public import Firedancer.Lane.Mlir._str_1_20

namespace Firedancer.Lane.Mlir

@[expose] public section

mlir_def fd_f25519_debug (fd_hex_encode : MLIR.Vals [.ptr, .ptr, .bv 64] → MLIR.EffectM (MLIR.Vals [.ptr])) (fd_log_private_0 : _) (fd_log_private_1 : MLIR.Vals [.bv 32, .bv 64, .ptr, .bv 32, .ptr, .ptr] → MLIR.EffectM (MLIR.Vals [])) (fd_log_private_hexdump_msg : MLIR.Vals [.ptr, .ptr, .bv 64] → MLIR.EffectM (MLIR.Vals [.ptr])) (fd_log_wallclock : MLIR.Vals [] → MLIR.EffectM (MLIR.Vals [.bv 64])) := "llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<void (ptr, ptr)>, linkage = #llvm.linkage<external>, no_unwind, passthrough = ["sspstrong", ["min-legal-vector-width", "512"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "znver4"]], sym_name = "fd_f25519_debug", target_cpu = "znver4", target_features = #llvm.target_features<["+64bit", "+adx", "+aes", "+avx", "+avx2", "+avx512bf16", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+clzero", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fast-vector-fsqrt", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+mwaitx", "+pclmul", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdpru", "+rdrnd", "+rdseed", "+sahf", "+sha", "+shstk", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+sse4a", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tile", "-avx10.1", "-avx10.2", "-avx512bmm", "-avx512fp16", "-avx512vp2intersect", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-ccmp", "-cf", "-cldemote", "-cmpccxadd", "-egpr", "-enqcmd", "-fma4", "-hreset", "-jmpabs", "-kl", "-lwp", "-movdir64b", "-movdiri", "-movrs", "-ndd", "-nf", "-pconfig", "-ppx", "-prefetchi", "-ptwrite", "-push2pop2", "-raoint", "-rtm", "-serialize", "-sgx", "-sha512", "-sm3", "-sm4", "-tbm", "-tsxldtrk", "-uintr", "-usermsr", "-waitpkg", "-widekl", "-xop", "-zu"]>, tune_cpu = "znver4", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg0: !llvm.ptr, %arg1: !llvm.ptr):
  %0 = "llvm.mlir.constant"() <{value = 28 : i32}> : () -> i32
  %1 = "llvm.mlir.constant"() <{value = 64 : i64}> : () -> i64
  %2 = "llvm.mlir.addressof"() <{global_name = @__func__.fd_f25519_debug}> : () -> !llvm.ptr
  %3 = "llvm.mlir.constant"() <{value = 27 : i32}> : () -> i32
  %4 = "llvm.mlir.addressof"() <{global_name = @".str.21"}> : () -> !llvm.ptr
  %5 = "llvm.mlir.addressof"() <{global_name = @".str.1.20"}> : () -> !llvm.ptr
  %6 = "llvm.mlir.poison"() : () -> vector<8xi64>
  %7 = "llvm.mlir.constant"() <{value = 44 : i64}> : () -> i64
  %8 = "llvm.mlir.constant"() <{value = 22 : i64}> : () -> i64
  %9 = "llvm.mlir.constant"() <{value = 23 : i64}> : () -> i64
  %10 = "llvm.mlir.constant"() <{value = 21 : i64}> : () -> i64
  %11 = "llvm.mlir.constant"() <{value = 42 : i64}> : () -> i64
  %12 = "llvm.mlir.constant"() <{value = 20 : i64}> : () -> i64
  %13 = "llvm.mlir.constant"() <{value = 7 : i32}> : () -> i32
  %14 = "llvm.mlir.constant"() <{value = 6 : i32}> : () -> i32
  %15 = "llvm.mlir.constant"() <{value = 5 : i32}> : () -> i32
  %16 = "llvm.mlir.constant"() <{value = 4 : i32}> : () -> i32
  %17 = "llvm.mlir.constant"() <{value = 3 : i32}> : () -> i32
  %18 = "llvm.mlir.constant"() <{value = 2 : i32}> : () -> i32
  %19 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %20 = "llvm.mlir.constant"() <{value = 0 : i8}> : () -> i8
  %21 = "llvm.mlir.constant"() <{value = 65 : i64}> : () -> i64
  %22 = "llvm.mlir.constant"() <{value = 32 : i64}> : () -> i64
  %23 = "llvm.mlir.constant"() <{value = 40 : i64}> : () -> i64
  %24 = "llvm.mlir.constant"() <{value = 8796093022207 : i64}> : () -> i64
  %25 = "llvm.mlir.constant"() <{value = 43 : i64}> : () -> i64
  %26 = "llvm.mlir.constant"() <{value = 1099511627775 : i64}> : () -> i64
  %27 = "llvm.mlir.constant"() <{value = -1 : i64}> : () -> i64
  %28 = "llvm.mlir.constant"() <{value = 19 : i64}> : () -> i64
  %29 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %30 = "llvm.mlir.constant"() <{value = 1099511627776 : i64}> : () -> i64
  %31 = "llvm.mlir.constant"() <{value = -19 : i64}> : () -> i64
  %32 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %33 = "llvm.mlir.poison"() : () -> vector<4xi64>
  %34 = "llvm.mlir.constant"() <{value = 2 : i64}> : () -> i64
  %35 = "llvm.mlir.constant"() <{value = 3 : i64}> : () -> i64
  %36 = "llvm.mlir.constant"() <{value = dense<8796093022207> : vector<4xi64>}> : () -> vector<4xi64>
  %37 = "llvm.mlir.poison"() : () -> vector<2xi64>
  %38 = "llvm.mlir.constant"() <{value = dense<[8796093022207, -1]> : vector<2xi64>}> : () -> vector<2xi64>
  %39 = "llvm.mlir.poison"() : () -> i64
  %40 = "llvm.mlir.undef"() : () -> vector<8xi64>
  %41 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %42 = "llvm.insertelement"(%40, %39, %41) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %43 = "llvm.insertelement"(%42, %39, %19) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %44 = "llvm.insertelement"(%43, %39, %18) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %45 = "llvm.insertelement"(%44, %39, %17) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %46 = "llvm.insertelement"(%45, %39, %16) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %47 = "llvm.insertelement"(%46, %39, %15) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %48 = "llvm.insertelement"(%47, %32, %14) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %49 = "llvm.insertelement"(%48, %32, %13) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %50 = "llvm.insertelement"(%40, %32, %41) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %51 = "llvm.insertelement"(%50, %10, %19) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %52 = "llvm.insertelement"(%51, %11, %18) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %53 = "llvm.insertelement"(%52, %39, %17) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %54 = "llvm.insertelement"(%53, %12, %16) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %55 = "llvm.insertelement"(%54, %39, %15) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %56 = "llvm.insertelement"(%55, %39, %14) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %57 = "llvm.insertelement"(%56, %39, %13) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %58 = "llvm.insertelement"(%40, %32, %41) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %59 = "llvm.insertelement"(%58, %25, %19) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %60 = "llvm.insertelement"(%59, %8, %18) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %61 = "llvm.insertelement"(%60, %29, %17) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %62 = "llvm.insertelement"(%61, %39, %16) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %63 = "llvm.insertelement"(%62, %9, %15) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %64 = "llvm.insertelement"(%63, %39, %14) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %65 = "llvm.insertelement"(%64, %39, %13) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %66 = "llvm.insertelement"(%40, %32, %41) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %67 = "llvm.insertelement"(%66, %25, %19) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %68 = "llvm.insertelement"(%67, %8, %18) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %69 = "llvm.insertelement"(%68, %39, %17) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %70 = "llvm.insertelement"(%69, %7, %16) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %71 = "llvm.insertelement"(%70, %9, %15) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %72 = "llvm.insertelement"(%71, %39, %14) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %73 = "llvm.insertelement"(%72, %39, %13) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %74 = "llvm.alloca"(%19) <{alignment = 16 : i64, elem_type = !llvm.array<32 x i8>}> : (i32) -> !llvm.ptr
  %75 = "llvm.alloca"(%19) <{alignment = 16 : i64, elem_type = !llvm.array<65 x i8>}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%74) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%75) : (!llvm.ptr) -> ()
  "llvm.intr.memset"(%75, %20, %21) <{arg_attrs = [{llvm.align = 16 : i64, llvm.dereferenceable = 65 : i64, llvm.nonnull, llvm.noundef}, {}, {}], isVolatile = false}> : (!llvm.ptr, i8, i64) -> ()
  %76 = "llvm.load"(%arg1) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %77 = "llvm.getelementptr"(%arg1) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %78 = "llvm.load"(%77) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %79 = "llvm.getelementptr"(%arg1) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %80 = "llvm.load"(%79) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %81 = "llvm.getelementptr"(%arg1) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %82 = "llvm.load"(%81) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %83 = "llvm.getelementptr"(%arg1) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %84 = "llvm.load"(%83) <{alignment = 32 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %85 = "llvm.getelementptr"(%arg1) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 40>}> : (!llvm.ptr) -> !llvm.ptr
  %86 = "llvm.load"(%85) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %87 = "llvm.and"(%76, %24) : (i64, i64) -> i64
  %88 = "llvm.ashr"(%86, %23) : (i64, i64) -> i64
  %89 = "llvm.and"(%78, %24) : (i64, i64) -> i64
  %90 = "llvm.ashr"(%76, %25) : (i64, i64) -> i64
  %91 = "llvm.add"(%89, %90) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %92 = "llvm.and"(%80, %24) : (i64, i64) -> i64
  %93 = "llvm.ashr"(%78, %25) : (i64, i64) -> i64
  %94 = "llvm.add"(%92, %93) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %95 = "llvm.and"(%82, %24) : (i64, i64) -> i64
  %96 = "llvm.ashr"(%80, %25) : (i64, i64) -> i64
  %97 = "llvm.add"(%95, %96) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %98 = "llvm.and"(%84, %24) : (i64, i64) -> i64
  %99 = "llvm.ashr"(%82, %25) : (i64, i64) -> i64
  %100 = "llvm.add"(%98, %99) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %101 = "llvm.and"(%86, %26) : (i64, i64) -> i64
  %102 = "llvm.ashr"(%84, %25) : (i64, i64) -> i64
  %103 = "llvm.add"(%102, %27) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %104 = "llvm.add"(%103, %101) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %105 = "llvm.ashr"(%104, %23) : (i64, i64) -> i64
  %106 = "llvm.and"(%104, %26) : (i64, i64) -> i64
  %107 = "llvm.add"(%105, %88) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %108 = "llvm.mul"(%107, %28) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %109 = "llvm.add"(%108, %87) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %110 = "llvm.ashr"(%109, %25) : (i64, i64) -> i64
  %111 = "llvm.and"(%109, %24) : (i64, i64) -> i64
  %112 = "llvm.add"(%91, %110) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %113 = "llvm.ashr"(%112, %25) : (i64, i64) -> i64
  %114 = "llvm.and"(%112, %24) : (i64, i64) -> i64
  %115 = "llvm.add"(%94, %113) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %116 = "llvm.ashr"(%115, %25) : (i64, i64) -> i64
  %117 = "llvm.and"(%115, %24) : (i64, i64) -> i64
  %118 = "llvm.add"(%97, %116) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %119 = "llvm.ashr"(%118, %25) : (i64, i64) -> i64
  %120 = "llvm.and"(%118, %24) : (i64, i64) -> i64
  %121 = "llvm.add"(%100, %119) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %122 = "llvm.ashr"(%121, %25) : (i64, i64) -> i64
  %123 = "llvm.and"(%121, %24) : (i64, i64) -> i64
  %124 = "llvm.add"(%111, %28) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %125 = "llvm.lshr"(%124, %25) : (i64, i64) -> i64
  %126 = "llvm.and"(%124, %24) : (i64, i64) -> i64
  %127 = "llvm.add"(%114, %125) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %128 = "llvm.lshr"(%127, %25) : (i64, i64) -> i64
  %129 = "llvm.and"(%127, %24) : (i64, i64) -> i64
  %130 = "llvm.add"(%117, %128) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %131 = "llvm.lshr"(%130, %25) : (i64, i64) -> i64
  %132 = "llvm.and"(%130, %24) : (i64, i64) -> i64
  %133 = "llvm.add"(%120, %131) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %134 = "llvm.lshr"(%133, %25) : (i64, i64) -> i64
  %135 = "llvm.and"(%133, %24) : (i64, i64) -> i64
  %136 = "llvm.add"(%123, %134) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %137 = "llvm.lshr"(%136, %25) : (i64, i64) -> i64
  %138 = "llvm.and"(%136, %24) : (i64, i64) -> i64
  %139 = "llvm.add"(%106, %29) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %140 = "llvm.add"(%139, %122) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %141 = "llvm.add"(%140, %137) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %142 = "llvm.and"(%141, %26) : (i64, i64) -> i64
  %143 = "llvm.icmp"(%141, %30) <{predicate = 6 : i64}> : (i64, i64) -> i1
  %144 = "llvm.select"(%143, %31, %32) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i64, i64) -> i64
  %145 = "llvm.add"(%144, %126) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %146 = "llvm.ashr"(%145, %25) : (i64, i64) -> i64
  %147 = "llvm.add"(%146, %129) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %148 = "llvm.ashr"(%147, %25) : (i64, i64) -> i64
  %149 = "llvm.add"(%148, %132) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %150 = "llvm.ashr"(%149, %25) : (i64, i64) -> i64
  %151 = "llvm.add"(%150, %135) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %152 = "llvm.ashr"(%151, %25) : (i64, i64) -> i64
  %153 = "llvm.insertelement"(%33, %145, %32) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %154 = "llvm.insertelement"(%153, %147, %29) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %155 = "llvm.insertelement"(%154, %149, %34) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %156 = "llvm.insertelement"(%155, %151, %35) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %157 = "llvm.and"(%156, %36) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %158 = "llvm.add"(%152, %138) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %159 = "llvm.ashr"(%158, %25) : (i64, i64) -> i64
  %160 = "llvm.add"(%159, %142) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %161 = "llvm.insertelement"(%37, %158, %32) : (vector<2xi64>, i64, i64) -> vector<2xi64>
  %162 = "llvm.insertelement"(%161, %160, %29) : (vector<2xi64>, i64, i64) -> vector<2xi64>
  %163 = "llvm.and"(%162, %38) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %164 = "llvm.shufflevector"(%157, %33) <{mask = array<i32: 0, 1, 2, 3, -1, -1, -1, -1>}> : (vector<4xi64>, vector<4xi64>) -> vector<8xi64>
  %165 = "llvm.shufflevector"(%164, %49) <{mask = array<i32: 0, 1, 2, 3, -1, -1, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %166 = "llvm.shufflevector"(%163, %37) <{mask = array<i32: 0, 1, -1, -1, -1, -1, -1, -1>}> : (vector<2xi64>, vector<2xi64>) -> vector<8xi64>
  %167 = "llvm.shufflevector"(%165, %166) <{mask = array<i32: 0, 1, 2, 3, 8, 9, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %168 = "llvm.lshr"(%167, %57) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %169 = "llvm.shl"(%167, %65) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %170 = "llvm.shl"(%167, %73) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %171 = "llvm.shufflevector"(%168, %6) <{mask = array<i32: 0, 1, 2, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<4xi64>
  %172 = "llvm.shufflevector"(%169, %6) <{mask = array<i32: 1, 2, 3, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<4xi64>
  %173 = "llvm.or"(%171, %172) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %174 = "llvm.shufflevector"(%170, %6) <{mask = array<i32: 1, 2, 4, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<4xi64>
  %175 = "llvm.or"(%173, %174) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.store"(%175, %74) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<4xi64>, !llvm.ptr) -> ()
  %176 = "llvm.call"(%75, %74, %22) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_hex_encode, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> !llvm.ptr
  %177 = "llvm.call"() <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, callee = @fd_log_wallclock, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 0, 0>}> : () -> i64
  %178 = "llvm.call"(%5, %arg0, %75) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_log_private_0, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>, var_callee_type = !llvm.func<ptr (ptr, ...)>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> !llvm.ptr
  "llvm.call"(%17, %177, %4, %3, %2, %178) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_log_private_1, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 6, 0>}> : (i32, i64, !llvm.ptr, i32, !llvm.ptr, !llvm.ptr) -> ()
  %179 = "llvm.call"() <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, callee = @fd_log_wallclock, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 0, 0>}> : () -> i64
  %180 = "llvm.call"(%arg0, %arg1, %1) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_log_private_hexdump_msg, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> !llvm.ptr
  "llvm.call"(%17, %179, %4, %0, %2, %180) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_log_private_1, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 6, 0>}> : (i32, i64, !llvm.ptr, i32, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%75) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%74) : (!llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()

    with
      @__func__.fd_f25519_debug := Firedancer.Lane.Mlir.__func___fd_f25519_debug,
      @.str.21 := Firedancer.Lane.Mlir._str_21,
      @.str.1.20 := Firedancer.Lane.Mlir._str_1_20,
      @fd_hex_encode := fd_hex_encode,
      @fd_log_wallclock := fd_log_wallclock,
      @fd_log_private_0 := fd_log_private_0,
      @fd_log_private_1 := fd_log_private_1,
      @fd_log_wallclock := fd_log_wallclock,
      @fd_log_private_hexdump_msg := fd_log_private_hexdump_msg,
      @fd_log_private_1 := fd_log_private_1

end

end Firedancer.Lane.Mlir
