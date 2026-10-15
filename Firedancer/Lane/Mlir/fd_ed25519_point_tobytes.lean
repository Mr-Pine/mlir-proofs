
module

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

public import Firedancer.Lane.Mlir.fd_f25519_inv

namespace Firedancer.Lane.Mlir

@[expose] public section

mlir_def fd_ed25519_point_tobytes := "llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.nofree, llvm.noundef, llvm.returned, llvm.writeonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}], frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<ptr (ptr, ptr)>, linkage = #llvm.linkage<external>, no_unwind, passthrough = ["sspstrong", ["min-legal-vector-width", "512"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "znver4"]], res_attrs = [{llvm.noundef}], sym_name = "fd_ed25519_point_tobytes", target_cpu = "znver4", target_features = #llvm.target_features<["+64bit", "+adx", "+aes", "+avx", "+avx2", "+avx512bf16", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+clzero", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fast-vector-fsqrt", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+mwaitx", "+pclmul", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdpru", "+rdrnd", "+rdseed", "+sahf", "+sha", "+shstk", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+sse4a", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tile", "-avx10.1", "-avx10.2", "-avx512bmm", "-avx512fp16", "-avx512vp2intersect", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-ccmp", "-cf", "-cldemote", "-cmpccxadd", "-egpr", "-enqcmd", "-fma4", "-hreset", "-jmpabs", "-kl", "-lwp", "-movdir64b", "-movdiri", "-movrs", "-ndd", "-nf", "-pconfig", "-ppx", "-prefetchi", "-ptwrite", "-push2pop2", "-raoint", "-rtm", "-serialize", "-sgx", "-sha512", "-sm3", "-sm4", "-tbm", "-tsxldtrk", "-uintr", "-usermsr", "-waitpkg", "-widekl", "-xop", "-zu"]>, tune_cpu = "znver4", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg0: !llvm.ptr, %arg1: !llvm.ptr):
  %0 = "llvm.mlir.constant"() <{value = 7 : i8}> : () -> i8
  %1 = "llvm.mlir.constant"() <{value = 31 : i64}> : () -> i64
  %2 = "llvm.mlir.undef"() : () -> vector<4xi64>
  %3 = "llvm.mlir.constant"() <{value = 44 : i64}> : () -> i64
  %4 = "llvm.mlir.constant"() <{value = 22 : i64}> : () -> i64
  %5 = "llvm.mlir.constant"() <{value = 23 : i64}> : () -> i64
  %6 = "llvm.mlir.constant"() <{value = 21 : i64}> : () -> i64
  %7 = "llvm.mlir.constant"() <{value = 42 : i64}> : () -> i64
  %8 = "llvm.mlir.constant"() <{value = 20 : i64}> : () -> i64
  %9 = "llvm.mlir.constant"() <{value = dense<[8796093022207, -1]> : vector<2xi64>}> : () -> vector<2xi64>
  %10 = "llvm.mlir.poison"() : () -> vector<2xi64>
  %11 = "llvm.mlir.constant"() <{value = dense<8796093022207> : vector<4xi64>}> : () -> vector<4xi64>
  %12 = "llvm.mlir.constant"() <{value = 3 : i64}> : () -> i64
  %13 = "llvm.mlir.constant"() <{value = 2 : i64}> : () -> i64
  %14 = "llvm.mlir.poison"() : () -> vector<4xi64>
  %15 = "llvm.mlir.constant"() <{value = 43 : i64}> : () -> i64
  %16 = "llvm.mlir.constant"() <{value = -19 : i64}> : () -> i64
  %17 = "llvm.mlir.constant"() <{value = dense<1099511627776> : vector<2xi64>}> : () -> vector<2xi64>
  %18 = "llvm.mlir.constant"() <{value = 1099511627775 : i64}> : () -> i64
  %19 = "llvm.mlir.constant"() <{value = dense<1> : vector<2xi64>}> : () -> vector<2xi64>
  %20 = "llvm.mlir.constant"() <{value = 8796093022207 : i64}> : () -> i64
  %21 = "llvm.mlir.constant"() <{value = dense<19> : vector<2xi64>}> : () -> vector<2xi64>
  %22 = "llvm.mlir.constant"() <{value = dense<40> : vector<2xi64>}> : () -> vector<2xi64>
  %23 = "llvm.mlir.constant"() <{value = dense<-1> : vector<2xi64>}> : () -> vector<2xi64>
  %24 = "llvm.mlir.constant"() <{value = dense<43> : vector<2xi64>}> : () -> vector<2xi64>
  %25 = "llvm.mlir.constant"() <{value = dense<1099511627775> : vector<2xi64>}> : () -> vector<2xi64>
  %26 = "llvm.mlir.constant"() <{value = dense<8796093022207> : vector<2xi64>}> : () -> vector<2xi64>
  %27 = "llvm.mlir.constant"() <{value = dense<[19, 1, 1, 1, 1, 1, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %28 = "llvm.mlir.constant"() <{value = dense<[43, 43, 43, 43, 43, 40, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %29 = "llvm.mlir.constant"() <{value = dense<[8796093022207, 8796093022207, 8796093022207, 8796093022207, 8796093022207, 1099511627775, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %30 = "llvm.mlir.constant"() <{value = dense<24> : vector<8xi64>}> : () -> vector<8xi64>
  %31 = "llvm.mlir.constant"() <{value = dense<7> : vector<8xi64>}> : () -> vector<8xi64>
  %32 = "llvm.mlir.constant"() <{value = dense<[-1, -1, -1, -1, -1, -1, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %33 = "llvm.mlir.constant"() <{value = dense<9> : vector<8xi64>}> : () -> vector<8xi64>
  %34 = "llvm.mlir.constant"() <{value = dense<0> : vector<8xi64>}> : () -> vector<8xi64>
  %35 = "llvm.mlir.poison"() : () -> vector<8xi64>
  %36 = "llvm.mlir.constant"() <{value = 7 : i32}> : () -> i32
  %37 = "llvm.mlir.constant"() <{value = 6 : i32}> : () -> i32
  %38 = "llvm.mlir.constant"() <{value = 5 : i32}> : () -> i32
  %39 = "llvm.mlir.constant"() <{value = 4 : i32}> : () -> i32
  %40 = "llvm.mlir.constant"() <{value = 3 : i32}> : () -> i32
  %41 = "llvm.mlir.constant"() <{value = 2 : i32}> : () -> i32
  %42 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %43 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %44 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %45 = "llvm.mlir.poison"() : () -> i64
  %46 = "llvm.mlir.undef"() : () -> vector<8xi64>
  %47 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %48 = "llvm.insertelement"(%46, %45, %47) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %49 = "llvm.insertelement"(%48, %43, %42) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %50 = "llvm.insertelement"(%49, %45, %41) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %51 = "llvm.insertelement"(%50, %45, %40) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %52 = "llvm.insertelement"(%51, %45, %39) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %53 = "llvm.insertelement"(%52, %45, %38) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %54 = "llvm.insertelement"(%53, %45, %37) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %55 = "llvm.insertelement"(%54, %45, %36) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %56 = "llvm.insertelement"(%46, %45, %47) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %57 = "llvm.insertelement"(%56, %45, %42) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %58 = "llvm.insertelement"(%57, %45, %41) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %59 = "llvm.insertelement"(%58, %45, %40) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %60 = "llvm.insertelement"(%59, %45, %39) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %61 = "llvm.insertelement"(%60, %45, %38) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %62 = "llvm.insertelement"(%61, %45, %37) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %63 = "llvm.insertelement"(%62, %43, %36) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %64 = "llvm.insertelement"(%46, %45, %47) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %65 = "llvm.insertelement"(%64, %45, %42) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %66 = "llvm.insertelement"(%65, %45, %41) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %67 = "llvm.insertelement"(%66, %45, %40) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %68 = "llvm.insertelement"(%67, %45, %39) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %69 = "llvm.insertelement"(%68, %45, %38) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %70 = "llvm.insertelement"(%69, %43, %37) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %71 = "llvm.insertelement"(%70, %43, %36) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %72 = "llvm.insertelement"(%46, %45, %47) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %73 = "llvm.insertelement"(%72, %45, %42) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %74 = "llvm.insertelement"(%73, %45, %41) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %75 = "llvm.insertelement"(%74, %45, %40) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %76 = "llvm.insertelement"(%75, %45, %39) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %77 = "llvm.insertelement"(%76, %43, %38) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %78 = "llvm.insertelement"(%77, %43, %37) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %79 = "llvm.insertelement"(%78, %43, %36) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %80 = "llvm.insertelement"(%46, %43, %47) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %81 = "llvm.insertelement"(%80, %43, %42) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %82 = "llvm.insertelement"(%81, %43, %41) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %83 = "llvm.insertelement"(%82, %45, %40) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %84 = "llvm.insertelement"(%83, %45, %39) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %85 = "llvm.insertelement"(%84, %45, %38) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %86 = "llvm.insertelement"(%85, %45, %37) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %87 = "llvm.insertelement"(%86, %45, %36) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %88 = "llvm.insertelement"(%46, %45, %47) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %89 = "llvm.insertelement"(%88, %45, %42) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %90 = "llvm.insertelement"(%89, %45, %41) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %91 = "llvm.insertelement"(%90, %45, %40) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %92 = "llvm.insertelement"(%91, %43, %39) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %93 = "llvm.insertelement"(%92, %43, %38) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %94 = "llvm.insertelement"(%93, %43, %37) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %95 = "llvm.insertelement"(%94, %43, %36) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %96 = "llvm.insertelement"(%46, %43, %47) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %97 = "llvm.insertelement"(%96, %43, %42) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %98 = "llvm.insertelement"(%97, %45, %41) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %99 = "llvm.insertelement"(%98, %45, %40) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %100 = "llvm.insertelement"(%99, %45, %39) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %101 = "llvm.insertelement"(%100, %45, %38) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %102 = "llvm.insertelement"(%101, %45, %37) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %103 = "llvm.insertelement"(%102, %45, %36) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %104 = "llvm.insertelement"(%46, %45, %47) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %105 = "llvm.insertelement"(%104, %45, %42) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %106 = "llvm.insertelement"(%105, %45, %41) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %107 = "llvm.insertelement"(%106, %43, %40) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %108 = "llvm.insertelement"(%107, %43, %39) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %109 = "llvm.insertelement"(%108, %43, %38) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %110 = "llvm.insertelement"(%109, %43, %37) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %111 = "llvm.insertelement"(%110, %43, %36) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %112 = "llvm.insertelement"(%46, %43, %47) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %113 = "llvm.insertelement"(%112, %45, %42) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %114 = "llvm.insertelement"(%113, %45, %41) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %115 = "llvm.insertelement"(%114, %45, %40) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %116 = "llvm.insertelement"(%115, %45, %39) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %117 = "llvm.insertelement"(%116, %45, %38) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %118 = "llvm.insertelement"(%117, %45, %37) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %119 = "llvm.insertelement"(%118, %45, %36) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %120 = "llvm.insertelement"(%46, %45, %47) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %121 = "llvm.insertelement"(%120, %45, %42) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %122 = "llvm.insertelement"(%121, %43, %41) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %123 = "llvm.insertelement"(%122, %43, %40) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %124 = "llvm.insertelement"(%123, %43, %39) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %125 = "llvm.insertelement"(%124, %43, %38) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %126 = "llvm.insertelement"(%125, %43, %37) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %127 = "llvm.insertelement"(%126, %43, %36) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %128 = "llvm.insertelement"(%46, %43, %47) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %129 = "llvm.insertelement"(%128, %6, %42) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %130 = "llvm.insertelement"(%129, %7, %41) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %131 = "llvm.insertelement"(%130, %45, %40) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %132 = "llvm.insertelement"(%131, %8, %39) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %133 = "llvm.insertelement"(%132, %45, %38) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %134 = "llvm.insertelement"(%133, %45, %37) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %135 = "llvm.insertelement"(%134, %45, %36) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %136 = "llvm.insertelement"(%46, %43, %47) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %137 = "llvm.insertelement"(%136, %15, %42) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %138 = "llvm.insertelement"(%137, %4, %41) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %139 = "llvm.insertelement"(%138, %44, %40) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %140 = "llvm.insertelement"(%139, %45, %39) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %141 = "llvm.insertelement"(%140, %5, %38) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %142 = "llvm.insertelement"(%141, %45, %37) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %143 = "llvm.insertelement"(%142, %45, %36) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %144 = "llvm.insertelement"(%46, %43, %47) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %145 = "llvm.insertelement"(%144, %15, %42) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %146 = "llvm.insertelement"(%145, %4, %41) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %147 = "llvm.insertelement"(%146, %45, %40) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %148 = "llvm.insertelement"(%147, %3, %39) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %149 = "llvm.insertelement"(%148, %5, %38) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %150 = "llvm.insertelement"(%149, %45, %37) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %151 = "llvm.insertelement"(%150, %45, %36) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %152 = "llvm.insertelement"(%2, %45, %47) : (vector<4xi64>, i64, i32) -> vector<4xi64>
  %153 = "llvm.insertelement"(%152, %15, %42) : (vector<4xi64>, i64, i32) -> vector<4xi64>
  %154 = "llvm.insertelement"(%153, %45, %41) : (vector<4xi64>, i64, i32) -> vector<4xi64>
  %155 = "llvm.insertelement"(%154, %45, %40) : (vector<4xi64>, i64, i32) -> vector<4xi64>
  %156 = "llvm.alloca"(%42) <{alignment = 64 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_f25519", (vector<8xi64>)>>}> : (i32) -> !llvm.ptr
  %157 = "llvm.alloca"(%42) <{alignment = 64 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_f25519", (vector<8xi64>)>>}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%156) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%157) : (!llvm.ptr) -> ()
  %158 = "llvm.load"(%arg1) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %159 = "llvm.getelementptr"(%arg1) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %160 = "llvm.load"(%159) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %161 = "llvm.getelementptr"(%arg1) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %162 = "llvm.load"(%161) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %163 = "llvm.shufflevector"(%158, %160) <{mask = array<i32: -1, -1, 2, 10, -1, -1, 6, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %164 = "llvm.shufflevector"(%158, %160) <{mask = array<i32: -1, -1, 3, 11, -1, -1, 7, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %165 = "llvm.insertelement"(%162, %43, %44) : (vector<8xi64>, i64, i64) -> vector<8xi64>
  %166 = "llvm.shufflevector"(%162, %55) <{mask = array<i32: -1, 9, 3, -1, -1, -1, 7, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %167 = "llvm.shufflevector"(%163, %165) <{mask = array<i32: 2, 3, 10, 6, 7, 14, 9, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%167, %156) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %168 = "llvm.shufflevector"(%164, %166) <{mask = array<i32: 2, 3, 10, 6, 7, 14, 9, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%168, %157) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %169 = "llvm.call"(%157, %156) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_f25519_inv, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %170 = "llvm.load"(%157) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %171 = "llvm.shufflevector"(%158, %35) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %172 = "llvm.shufflevector"(%160, %35) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %173 = "llvm.shufflevector"(%162, %35) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %174 = "llvm.shufflevector"(%158, %35) <{mask = array<i32: 4, 4, 4, 4, 4, 4, 4, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %175 = "llvm.shufflevector"(%160, %35) <{mask = array<i32: 4, 4, 4, 4, 4, 4, 4, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %176 = "llvm.shufflevector"(%162, %35) <{mask = array<i32: 4, 4, 4, 4, 4, 4, 4, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %177 = "llvm.call_intrinsic"(%34, %171, %170) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %178 = "llvm.shl"(%177, %33) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %179 = "llvm.call_intrinsic"(%178, %172, %170) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %180 = "llvm.call_intrinsic"(%34, %172, %170) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %181 = "llvm.shl"(%180, %33) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %182 = "llvm.call_intrinsic"(%181, %173, %170) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %183 = "llvm.call_intrinsic"(%34, %173, %170) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %184 = "llvm.shl"(%183, %33) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %185 = "llvm.call_intrinsic"(%184, %174, %170) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %186 = "llvm.call_intrinsic"(%34, %174, %170) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %187 = "llvm.shl"(%186, %33) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %188 = "llvm.call_intrinsic"(%187, %175, %170) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %189 = "llvm.call_intrinsic"(%34, %175, %170) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %190 = "llvm.shl"(%189, %33) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %191 = "llvm.call_intrinsic"(%190, %176, %170) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %192 = "llvm.call_intrinsic"(%34, %176, %170) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %193 = "llvm.shl"(%192, %33) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %194 = "llvm.shufflevector"(%63, %179) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %195 = "llvm.shufflevector"(%71, %182) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %196 = "llvm.shufflevector"(%79, %185) <{mask = array<i32: 5, 6, 7, 8, 9, 10, 11, 12>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %197 = "llvm.shufflevector"(%185, %87) <{mask = array<i32: 5, 6, 7, 8, 9, 10, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %198 = "llvm.shufflevector"(%95, %188) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %199 = "llvm.shufflevector"(%188, %103) <{mask = array<i32: 4, 5, 6, 7, 8, 9, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %200 = "llvm.shufflevector"(%111, %191) <{mask = array<i32: 3, 4, 5, 6, 7, 8, 9, 10>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %201 = "llvm.shufflevector"(%191, %119) <{mask = array<i32: 3, 4, 5, 6, 7, 8, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %202 = "llvm.shufflevector"(%127, %193) <{mask = array<i32: 2, 3, 4, 5, 6, 7, 8, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %203 = "llvm.shufflevector"(%193, %35) <{mask = array<i32: 2, 3, 4, 5, 6, 7, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %204 = "llvm.call_intrinsic"(%194, %171, %170) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %205 = "llvm.add"(%196, %195) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %206 = "llvm.add"(%205, %198) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %207 = "llvm.add"(%206, %200) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %208 = "llvm.add"(%207, %204) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %209 = "llvm.add"(%208, %202) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %210 = "llvm.add"(%199, %197) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %211 = "llvm.add"(%210, %201) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %212 = "llvm.add"(%211, %203) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %213 = "llvm.and"(%209, %32) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %214 = "llvm.shufflevector"(%209, %212) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %215 = "llvm.shl"(%214, %31) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %216 = "llvm.add"(%215, %213) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %217 = "llvm.mul"(%214, %30) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %218 = "llvm.add"(%216, %217) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %219 = "llvm.and"(%218, %29) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %220 = "llvm.lshr"(%218, %28) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %221 = "llvm.shufflevector"(%220, %35) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %222 = "llvm.call_intrinsic"(%219, %27, %221) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %223 = "llvm.shufflevector"(%158, %35) <{mask = array<i32: 1, 1, 1, 1, 1, 1, 1, 1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %224 = "llvm.shufflevector"(%160, %35) <{mask = array<i32: 1, 1, 1, 1, 1, 1, 1, 1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %225 = "llvm.shufflevector"(%162, %35) <{mask = array<i32: 1, 1, 1, 1, 1, 1, 1, 1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %226 = "llvm.shufflevector"(%158, %35) <{mask = array<i32: 5, 5, 5, 5, 5, 5, 5, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %227 = "llvm.shufflevector"(%160, %35) <{mask = array<i32: 5, 5, 5, 5, 5, 5, 5, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %228 = "llvm.shufflevector"(%162, %35) <{mask = array<i32: 5, 5, 5, 5, 5, 5, 5, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %229 = "llvm.call_intrinsic"(%34, %223, %170) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %230 = "llvm.shl"(%229, %33) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %231 = "llvm.call_intrinsic"(%230, %224, %170) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %232 = "llvm.call_intrinsic"(%34, %224, %170) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %233 = "llvm.shl"(%232, %33) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %234 = "llvm.call_intrinsic"(%233, %225, %170) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %235 = "llvm.call_intrinsic"(%34, %225, %170) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %236 = "llvm.shl"(%235, %33) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %237 = "llvm.call_intrinsic"(%236, %226, %170) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %238 = "llvm.call_intrinsic"(%34, %226, %170) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %239 = "llvm.shl"(%238, %33) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %240 = "llvm.call_intrinsic"(%239, %227, %170) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %241 = "llvm.call_intrinsic"(%34, %227, %170) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %242 = "llvm.shl"(%241, %33) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %243 = "llvm.call_intrinsic"(%242, %228, %170) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %244 = "llvm.call_intrinsic"(%34, %228, %170) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %245 = "llvm.shl"(%244, %33) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %246 = "llvm.shufflevector"(%63, %231) <{mask = array<i32: 7, 8, 9, 10, 11, 12, 13, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %247 = "llvm.shufflevector"(%71, %234) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %248 = "llvm.shufflevector"(%79, %237) <{mask = array<i32: 5, 6, 7, 8, 9, 10, 11, 12>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %249 = "llvm.shufflevector"(%237, %87) <{mask = array<i32: 5, 6, 7, 8, 9, 10, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %250 = "llvm.shufflevector"(%95, %240) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %251 = "llvm.shufflevector"(%240, %103) <{mask = array<i32: 4, 5, 6, 7, 8, 9, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %252 = "llvm.shufflevector"(%111, %243) <{mask = array<i32: 3, 4, 5, 6, 7, 8, 9, 10>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %253 = "llvm.shufflevector"(%243, %119) <{mask = array<i32: 3, 4, 5, 6, 7, 8, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %254 = "llvm.shufflevector"(%127, %245) <{mask = array<i32: 2, 3, 4, 5, 6, 7, 8, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %255 = "llvm.shufflevector"(%245, %35) <{mask = array<i32: 2, 3, 4, 5, 6, 7, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %256 = "llvm.call_intrinsic"(%246, %223, %170) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %257 = "llvm.add"(%248, %247) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %258 = "llvm.add"(%257, %250) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %259 = "llvm.add"(%258, %252) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %260 = "llvm.add"(%259, %256) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %261 = "llvm.add"(%260, %254) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %262 = "llvm.add"(%251, %249) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %263 = "llvm.add"(%262, %253) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %264 = "llvm.add"(%263, %255) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %265 = "llvm.and"(%261, %32) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %266 = "llvm.shufflevector"(%261, %264) <{mask = array<i32: 6, 7, 8, 9, 10, 11, 12, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %267 = "llvm.shl"(%266, %31) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %268 = "llvm.add"(%267, %265) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %269 = "llvm.mul"(%266, %30) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %270 = "llvm.add"(%268, %269) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %271 = "llvm.and"(%270, %29) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %272 = "llvm.lshr"(%270, %28) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %273 = "llvm.shufflevector"(%272, %35) <{mask = array<i32: 5, 0, 1, 2, 3, 4, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %274 = "llvm.call_intrinsic"(%271, %27, %273) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %275 = "llvm.shufflevector"(%222, %274) <{mask = array<i32: 0, 8>}> : (vector<8xi64>, vector<8xi64>) -> vector<2xi64>
  %276 = "llvm.and"(%275, %26) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %277 = "llvm.shufflevector"(%222, %274) <{mask = array<i32: 5, 13>}> : (vector<8xi64>, vector<8xi64>) -> vector<2xi64>
  %278 = "llvm.and"(%277, %25) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %279 = "llvm.shufflevector"(%222, %274) <{mask = array<i32: 4, 12>}> : (vector<8xi64>, vector<8xi64>) -> vector<2xi64>
  %280 = "llvm.ashr"(%279, %24) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %281 = "llvm.add"(%280, %23) <{overflowFlags = 1 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %282 = "llvm.add"(%281, %278) <{overflowFlags = 1 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %283 = "llvm.ashr"(%277, %22) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %284 = "llvm.ashr"(%282, %22) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %285 = "llvm.add"(%284, %283) <{overflowFlags = 1 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %286 = "llvm.mul"(%285, %21) <{overflowFlags = 1 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %287 = "llvm.add"(%286, %276) <{overflowFlags = 1 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %288 = "llvm.and"(%287, %26) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %289 = "llvm.add"(%288, %21) <{overflowFlags = 3 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %290 = "llvm.extractelement"(%289, %44) : (vector<2xi64>, i64) -> i64
  %291 = "llvm.and"(%290, %20) : (i64, i64) -> i64
  %292 = "llvm.shufflevector"(%222, %274) <{mask = array<i32: 1, 9>}> : (vector<8xi64>, vector<8xi64>) -> vector<2xi64>
  %293 = "llvm.and"(%292, %26) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %294 = "llvm.ashr"(%275, %24) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %295 = "llvm.add"(%293, %294) <{overflowFlags = 1 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %296 = "llvm.ashr"(%287, %24) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %297 = "llvm.add"(%295, %296) <{overflowFlags = 1 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %298 = "llvm.and"(%297, %26) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %299 = "llvm.lshr"(%289, %24) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %300 = "llvm.add"(%298, %299) <{overflowFlags = 3 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %301 = "llvm.extractelement"(%300, %44) : (vector<2xi64>, i64) -> i64
  %302 = "llvm.and"(%301, %20) : (i64, i64) -> i64
  %303 = "llvm.shufflevector"(%222, %274) <{mask = array<i32: 2, 10>}> : (vector<8xi64>, vector<8xi64>) -> vector<2xi64>
  %304 = "llvm.and"(%303, %26) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %305 = "llvm.ashr"(%292, %24) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %306 = "llvm.add"(%304, %305) <{overflowFlags = 1 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %307 = "llvm.ashr"(%297, %24) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %308 = "llvm.add"(%306, %307) <{overflowFlags = 1 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %309 = "llvm.and"(%308, %26) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %310 = "llvm.lshr"(%300, %24) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %311 = "llvm.add"(%309, %310) <{overflowFlags = 3 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %312 = "llvm.extractelement"(%311, %44) : (vector<2xi64>, i64) -> i64
  %313 = "llvm.and"(%312, %20) : (i64, i64) -> i64
  %314 = "llvm.shufflevector"(%222, %274) <{mask = array<i32: 3, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<2xi64>
  %315 = "llvm.and"(%314, %26) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %316 = "llvm.ashr"(%303, %24) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %317 = "llvm.add"(%315, %316) <{overflowFlags = 1 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %318 = "llvm.ashr"(%308, %24) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %319 = "llvm.add"(%317, %318) <{overflowFlags = 1 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %320 = "llvm.and"(%319, %26) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %321 = "llvm.lshr"(%311, %24) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %322 = "llvm.add"(%320, %321) <{overflowFlags = 3 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %323 = "llvm.extractelement"(%322, %44) : (vector<2xi64>, i64) -> i64
  %324 = "llvm.and"(%323, %20) : (i64, i64) -> i64
  %325 = "llvm.and"(%279, %26) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %326 = "llvm.ashr"(%314, %24) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %327 = "llvm.add"(%325, %326) <{overflowFlags = 1 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %328 = "llvm.ashr"(%319, %24) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %329 = "llvm.add"(%327, %328) <{overflowFlags = 1 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %330 = "llvm.and"(%329, %26) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %331 = "llvm.lshr"(%322, %24) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %332 = "llvm.add"(%330, %331) <{overflowFlags = 3 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %333 = "llvm.extractelement"(%332, %44) : (vector<2xi64>, i64) -> i64
  %334 = "llvm.and"(%333, %20) : (i64, i64) -> i64
  %335 = "llvm.and"(%282, %25) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %336 = "llvm.ashr"(%329, %24) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %337 = "llvm.lshr"(%332, %24) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %338 = "llvm.add"(%335, %19) <{overflowFlags = 3 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %339 = "llvm.add"(%338, %336) <{overflowFlags = 1 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %340 = "llvm.add"(%339, %337) <{overflowFlags = 3 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %341 = "llvm.extractelement"(%340, %44) : (vector<2xi64>, i64) -> i64
  %342 = "llvm.and"(%341, %18) : (i64, i64) -> i64
  %343 = "llvm.icmp"(%340, %17) <{predicate = 6 : i64}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi1>
  %344 = "llvm.extractelement"(%343, %44) : (vector<2xi1>, i64) -> i1
  %345 = "llvm.select"(%344, %16, %43) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i64, i64) -> i64
  %346 = "llvm.add"(%345, %291) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %347 = "llvm.ashr"(%346, %15) : (i64, i64) -> i64
  %348 = "llvm.add"(%347, %302) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %349 = "llvm.ashr"(%348, %15) : (i64, i64) -> i64
  %350 = "llvm.add"(%349, %313) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %351 = "llvm.ashr"(%350, %15) : (i64, i64) -> i64
  %352 = "llvm.add"(%351, %324) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %353 = "llvm.ashr"(%352, %15) : (i64, i64) -> i64
  %354 = "llvm.insertelement"(%14, %346, %43) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %355 = "llvm.insertelement"(%354, %348, %44) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %356 = "llvm.insertelement"(%355, %350, %13) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %357 = "llvm.insertelement"(%356, %352, %12) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %358 = "llvm.and"(%357, %11) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %359 = "llvm.add"(%353, %334) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %360 = "llvm.ashr"(%359, %15) : (i64, i64) -> i64
  %361 = "llvm.add"(%360, %342) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %362 = "llvm.insertelement"(%10, %359, %43) : (vector<2xi64>, i64, i64) -> vector<2xi64>
  %363 = "llvm.insertelement"(%362, %361, %44) : (vector<2xi64>, i64, i64) -> vector<2xi64>
  %364 = "llvm.and"(%363, %9) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %365 = "llvm.shufflevector"(%358, %14) <{mask = array<i32: 0, 1, 2, 3, -1, -1, -1, -1>}> : (vector<4xi64>, vector<4xi64>) -> vector<8xi64>
  %366 = "llvm.shufflevector"(%365, %71) <{mask = array<i32: 0, 1, 2, 3, -1, -1, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %367 = "llvm.shufflevector"(%364, %10) <{mask = array<i32: 0, 1, -1, -1, -1, -1, -1, -1>}> : (vector<2xi64>, vector<2xi64>) -> vector<8xi64>
  %368 = "llvm.shufflevector"(%366, %367) <{mask = array<i32: 0, 1, 2, 3, 8, 9, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %369 = "llvm.lshr"(%368, %135) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %370 = "llvm.shufflevector"(%369, %35) <{mask = array<i32: 0, 1, 2, 4, -1, -1, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %371 = "llvm.shl"(%368, %143) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %372 = "llvm.shufflevector"(%371, %35) <{mask = array<i32: 1, 2, 3, 5, -1, -1, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %373 = "llvm.shl"(%368, %151) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %374 = "llvm.shufflevector"(%373, %35) <{mask = array<i32: 1, 2, 4, 5, -1, -1, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %375 = "llvm.or"(%370, %372) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %376 = "llvm.or"(%375, %374) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %377 = "llvm.shufflevector"(%376, %35) <{mask = array<i32: 0, 1, 2, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<4xi64>
  "llvm.store"(%377, %arg0) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<4xi64>, !llvm.ptr) -> ()
  %378 = "llvm.extractelement"(%289, %43) : (vector<2xi64>, i64) -> i64
  %379 = "llvm.and"(%378, %20) : (i64, i64) -> i64
  %380 = "llvm.extractelement"(%300, %43) : (vector<2xi64>, i64) -> i64
  %381 = "llvm.and"(%380, %20) : (i64, i64) -> i64
  %382 = "llvm.extractelement"(%311, %43) : (vector<2xi64>, i64) -> i64
  %383 = "llvm.and"(%382, %20) : (i64, i64) -> i64
  %384 = "llvm.extractelement"(%322, %43) : (vector<2xi64>, i64) -> i64
  %385 = "llvm.and"(%384, %20) : (i64, i64) -> i64
  %386 = "llvm.extractelement"(%332, %43) : (vector<2xi64>, i64) -> i64
  %387 = "llvm.and"(%386, %20) : (i64, i64) -> i64
  %388 = "llvm.extractelement"(%340, %43) : (vector<2xi64>, i64) -> i64
  %389 = "llvm.and"(%388, %18) : (i64, i64) -> i64
  %390 = "llvm.extractelement"(%343, %43) : (vector<2xi1>, i64) -> i1
  %391 = "llvm.select"(%390, %16, %43) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i64, i64) -> i64
  %392 = "llvm.add"(%391, %379) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %393 = "llvm.ashr"(%392, %15) : (i64, i64) -> i64
  %394 = "llvm.add"(%393, %381) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %395 = "llvm.ashr"(%394, %15) : (i64, i64) -> i64
  %396 = "llvm.add"(%395, %383) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %397 = "llvm.ashr"(%396, %15) : (i64, i64) -> i64
  %398 = "llvm.add"(%397, %385) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %399 = "llvm.ashr"(%398, %15) : (i64, i64) -> i64
  %400 = "llvm.insertelement"(%14, %392, %43) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %401 = "llvm.insertelement"(%400, %394, %44) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %402 = "llvm.insertelement"(%401, %396, %13) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %403 = "llvm.insertelement"(%402, %398, %12) : (vector<4xi64>, i64, i64) -> vector<4xi64>
  %404 = "llvm.and"(%403, %11) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %405 = "llvm.add"(%399, %387) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %406 = "llvm.ashr"(%405, %15) : (i64, i64) -> i64
  %407 = "llvm.add"(%406, %389) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %408 = "llvm.insertelement"(%10, %405, %43) : (vector<2xi64>, i64, i64) -> vector<2xi64>
  %409 = "llvm.insertelement"(%408, %407, %44) : (vector<2xi64>, i64, i64) -> vector<2xi64>
  %410 = "llvm.and"(%409, %9) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %411 = "llvm.shufflevector"(%404, %14) <{mask = array<i32: 0, 1, 2, 3, -1, -1, -1, -1>}> : (vector<4xi64>, vector<4xi64>) -> vector<8xi64>
  %412 = "llvm.shufflevector"(%411, %71) <{mask = array<i32: 0, 1, 2, 3, -1, -1, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %413 = "llvm.shufflevector"(%410, %10) <{mask = array<i32: 0, 1, -1, -1, -1, -1, -1, -1>}> : (vector<2xi64>, vector<2xi64>) -> vector<8xi64>
  %414 = "llvm.shufflevector"(%412, %413) <{mask = array<i32: 0, 1, 2, 3, 8, 9, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %415 = "llvm.lshr"(%414, %135) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %416 = "llvm.shl"(%404, %155) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %417 = "llvm.shufflevector"(%416, %14) <{mask = array<i32: 1, -1, -1, -1, -1, -1, -1, -1>}> : (vector<4xi64>, vector<4xi64>) -> vector<8xi64>
  %418 = "llvm.shl"(%404, %155) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %419 = "llvm.shufflevector"(%418, %14) <{mask = array<i32: 1, -1, -1, -1, -1, -1, -1, -1>}> : (vector<4xi64>, vector<4xi64>) -> vector<8xi64>
  %420 = "llvm.or"(%417, %415) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %421 = "llvm.or"(%420, %419) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %422 = "llvm.bitcast"(%421) : (vector<8xi64>) -> vector<64xi8>
  %423 = "llvm.extractelement"(%422, %43) : (vector<64xi8>, i64) -> i8
  %424 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 31>}> : (!llvm.ptr) -> !llvm.ptr
  %425 = "llvm.bitcast"(%376) : (vector<8xi64>) -> vector<64xi8>
  %426 = "llvm.extractelement"(%425, %1) : (vector<64xi8>, i64) -> i8
  %427 = "llvm.shl"(%423, %0) <{overflowFlags = 0 : i32}> : (i8, i8) -> i8
  %428 = "llvm.xor"(%427, %426) : (i8, i8) -> i8
  "llvm.store"(%428, %424) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (i8, !llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%157) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%156) : (!llvm.ptr) -> ()
  "llvm.return"(%arg0) : (!llvm.ptr) -> ()
}) : () -> ()

    with
      @fd_f25519_inv := Firedancer.Lane.Mlir.fd_f25519_inv

end

end Firedancer.Lane.Mlir
