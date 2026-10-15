
module

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

public import Firedancer.Lane.Mlir.fd_ed25519_base_point_const_time_table
public import Firedancer.Lane.Mlir.fd_ed25519_point_add_secure
public import Firedancer.Lane.Mlir.fd_ed25519_point_add_secure
public import Firedancer.Lane.Mlir.fd_ed25519_point_add_secure
public import Firedancer.Lane.Mlir.fd_ed25519_point_add_secure

namespace Firedancer.Lane.Mlir

@[expose] public section

noncomputable mlir_def fd_ed25519_scalar_mul_base_const_time := "llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.nofree, llvm.noundef, llvm.returned}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}], frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<ptr (ptr, ptr)>, linkage = #llvm.linkage<external>, no_unwind, passthrough = ["sspstrong", ["min-legal-vector-width", "512"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "znver4"]], res_attrs = [{llvm.noundef}], sym_name = "fd_ed25519_scalar_mul_base_const_time", target_cpu = "znver4", target_features = #llvm.target_features<["+64bit", "+adx", "+aes", "+avx", "+avx2", "+avx512bf16", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+clzero", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fast-vector-fsqrt", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+mwaitx", "+pclmul", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdpru", "+rdrnd", "+rdseed", "+sahf", "+sha", "+shstk", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+sse4a", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tile", "-avx10.1", "-avx10.2", "-avx512bmm", "-avx512fp16", "-avx512vp2intersect", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-ccmp", "-cf", "-cldemote", "-cmpccxadd", "-egpr", "-enqcmd", "-fma4", "-hreset", "-jmpabs", "-kl", "-lwp", "-movdir64b", "-movdiri", "-movrs", "-ndd", "-nf", "-pconfig", "-ppx", "-prefetchi", "-ptwrite", "-push2pop2", "-raoint", "-rtm", "-serialize", "-sgx", "-sha512", "-sm3", "-sm4", "-tbm", "-tsxldtrk", "-uintr", "-usermsr", "-waitpkg", "-widekl", "-xop", "-zu"]>, tune_cpu = "znver4", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, zero_call_used_regs = "all"}> ({
^bb0(%arg0: !llvm.ptr, %arg1: !llvm.ptr):
  %0 = "llvm.mlir.constant"() <{value = dense<[8796093022207, 8796093022207, 8796093022207, 8796093022207, 1099511627775, 1099511627775, 1099511627775, 1099511627775]> : vector<8xi64>}> : () -> vector<8xi64>
  %1 = "llvm.mlir.constant"() <{value = dense<1048576> : vector<8xi64>}> : () -> vector<8xi64>
  %2 = "llvm.mlir.constant"() <{value = dense<[159383552, 159383552, 159383552, 159383552, 1048576, 1048576, 1048576, 1048576]> : vector<8xi64>}> : () -> vector<8xi64>
  %3 = "llvm.mlir.constant"() <{value = dense<8796093022207> : vector<8xi64>}> : () -> vector<8xi64>
  %4 = "llvm.mlir.constant"() <{value = 19 : i64}> : () -> i64
  %5 = "llvm.mlir.constant"() <{value = dense<[43, 43, 43, 43, 40, 40, 40, 40]> : vector<8xi64>}> : () -> vector<8xi64>
  %6 = "llvm.mlir.constant"() <{value = dense<43> : vector<8xi64>}> : () -> vector<8xi64>
  %7 = "llvm.mlir.constant"() <{value = dense<-1048576> : vector<8xi64>}> : () -> vector<8xi64>
  %8 = "llvm.mlir.constant"() <{value = dense<[-159383552, -159383552, -159383552, -159383552, -1048576, -1048576, -1048576, -1048576]> : vector<8xi64>}> : () -> vector<8xi64>
  %9 = "llvm.mlir.constant"() <{value = dense<[0, 0, 1, 0, 0, 0, 1, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %10 = "llvm.mlir.constant"() <{value = dense<24> : vector<8xi64>}> : () -> vector<8xi64>
  %11 = "llvm.mlir.constant"() <{value = dense<7> : vector<8xi64>}> : () -> vector<8xi64>
  %12 = "llvm.mlir.constant"() <{value = dense<9> : vector<8xi64>}> : () -> vector<8xi64>
  %13 = "llvm.mlir.constant"() <{value = dense<1> : vector<8xi64>}> : () -> vector<8xi64>
  %14 = "llvm.mlir.poison"() : () -> vector<8xi64>
  %15 = "llvm.mlir.constant"() <{value = 60 : i64}> : () -> i64
  %16 = "llvm.mlir.constant"() <{value = 1099511627775 : i64}> : () -> i64
  %17 = "llvm.mlir.constant"() <{value = 7 : i32}> : () -> i32
  %18 = "llvm.mlir.constant"() <{value = 6 : i32}> : () -> i32
  %19 = "llvm.mlir.constant"() <{value = 5 : i32}> : () -> i32
  %20 = "llvm.mlir.constant"() <{value = 4 : i32}> : () -> i32
  %21 = "llvm.mlir.constant"() <{value = 3 : i32}> : () -> i32
  %22 = "llvm.mlir.constant"() <{value = 2 : i32}> : () -> i32
  %23 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %24 = "llvm.mlir.constant"() <{value = 0 : i8}> : () -> i8
  %25 = "llvm.mlir.constant"() <{value = 63 : i64}> : () -> i64
  %26 = "llvm.mlir.constant"() <{value = dense<15> : vector<32xi8>}> : () -> vector<32xi8>
  %27 = "llvm.mlir.constant"() <{value = dense<4> : vector<32xi8>}> : () -> vector<32xi8>
  %28 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %29 = "llvm.mlir.constant"() <{value = 8 : i16}> : () -> i16
  %30 = "llvm.mlir.constant"() <{value = 4 : i16}> : () -> i16
  %31 = "llvm.mlir.constant"() <{value = 4 : i8}> : () -> i8
  %32 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %33 = "llvm.mlir.constant"() <{value = 4 : i64}> : () -> i64
  %34 = "llvm.mlir.constant"() <{value = 7 : i64}> : () -> i64
  %35 = "llvm.mlir.constant"() <{value = dense<[0, 1, 1, 0, 0, 0, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %36 = "llvm.mlir.constant"() <{value = 128 : i64}> : () -> i64
  %37 = "llvm.mlir.constant"() <{value = 7 : i8}> : () -> i8
  %38 = "llvm.mlir.constant"() <{value = 1 : i8}> : () -> i8
  %39 = "llvm.mlir.constant"() <{value = -1 : i8}> : () -> i8
  %40 = "llvm.mlir.constant"() <{value = -1 : i32}> : () -> i32
  %41 = "llvm.mlir.constant"() <{value = 31 : i32}> : () -> i32
  %42 = "llvm.mlir.addressof"() <{global_name = @fd_ed25519_base_point_const_time_table}> : () -> !llvm.ptr
  %43 = "llvm.mlir.constant"() <{value = dense<[1, 1, 1, 0, 0, 0, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %44 = "llvm.mlir.constant"() <{value = dense<0> : vector<8xi64>}> : () -> vector<8xi64>
  %45 = "llvm.mlir.constant"() <{value = 2 : i8}> : () -> i8
  %46 = "llvm.mlir.constant"() <{value = 3 : i8}> : () -> i8
  %47 = "llvm.mlir.constant"() <{value = 5 : i8}> : () -> i8
  %48 = "llvm.mlir.constant"() <{value = 6 : i8}> : () -> i8
  %49 = "llvm.mlir.constant"() <{value = 8796093022207 : i64}> : () -> i64
  %50 = "llvm.mlir.poison"() : () -> i64
  %51 = "llvm.mlir.constant"() <{value = 8796093022189 : i64}> : () -> i64
  %52 = "llvm.mlir.undef"() : () -> vector<8xi64>
  %53 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %54 = "llvm.insertelement"(%52, %50, %53) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %55 = "llvm.insertelement"(%54, %50, %23) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %56 = "llvm.insertelement"(%55, %50, %22) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %57 = "llvm.insertelement"(%56, %51, %21) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %58 = "llvm.insertelement"(%57, %50, %20) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %59 = "llvm.insertelement"(%58, %50, %19) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %60 = "llvm.insertelement"(%59, %50, %18) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %61 = "llvm.insertelement"(%60, %49, %17) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %62 = "llvm.insertelement"(%52, %50, %53) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %63 = "llvm.insertelement"(%62, %50, %23) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %64 = "llvm.insertelement"(%63, %50, %22) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %65 = "llvm.insertelement"(%64, %49, %21) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %66 = "llvm.insertelement"(%65, %50, %20) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %67 = "llvm.insertelement"(%66, %50, %19) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %68 = "llvm.insertelement"(%67, %50, %18) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %69 = "llvm.insertelement"(%68, %49, %17) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %70 = "llvm.insertelement"(%52, %50, %53) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %71 = "llvm.insertelement"(%70, %50, %23) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %72 = "llvm.insertelement"(%71, %50, %22) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %73 = "llvm.insertelement"(%72, %49, %21) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %74 = "llvm.insertelement"(%73, %50, %20) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %75 = "llvm.insertelement"(%74, %50, %19) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %76 = "llvm.insertelement"(%75, %50, %18) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %77 = "llvm.insertelement"(%76, %16, %17) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %78 = "llvm.insertelement"(%52, %28, %53) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %79 = "llvm.insertelement"(%78, %28, %23) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %80 = "llvm.insertelement"(%79, %28, %22) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %81 = "llvm.insertelement"(%80, %28, %21) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %82 = "llvm.insertelement"(%81, %50, %20) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %83 = "llvm.insertelement"(%82, %50, %19) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %84 = "llvm.insertelement"(%83, %50, %18) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %85 = "llvm.insertelement"(%84, %50, %17) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %86 = "llvm.insertelement"(%52, %50, %53) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %87 = "llvm.insertelement"(%86, %50, %23) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %88 = "llvm.insertelement"(%87, %50, %22) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %89 = "llvm.insertelement"(%88, %50, %21) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %90 = "llvm.insertelement"(%89, %28, %20) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %91 = "llvm.insertelement"(%90, %28, %19) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %92 = "llvm.insertelement"(%91, %28, %18) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %93 = "llvm.insertelement"(%92, %28, %17) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %94 = "llvm.insertelement"(%52, %51, %53) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %95 = "llvm.insertelement"(%94, %50, %23) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %96 = "llvm.insertelement"(%95, %50, %22) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %97 = "llvm.insertelement"(%96, %50, %21) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %98 = "llvm.insertelement"(%97, %49, %20) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %99 = "llvm.insertelement"(%98, %50, %19) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %100 = "llvm.insertelement"(%99, %50, %18) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %101 = "llvm.insertelement"(%100, %50, %17) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %102 = "llvm.insertelement"(%52, %49, %53) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %103 = "llvm.insertelement"(%102, %50, %23) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %104 = "llvm.insertelement"(%103, %50, %22) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %105 = "llvm.insertelement"(%104, %50, %21) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %106 = "llvm.insertelement"(%105, %49, %20) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %107 = "llvm.insertelement"(%106, %50, %19) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %108 = "llvm.insertelement"(%107, %50, %18) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %109 = "llvm.insertelement"(%108, %50, %17) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %110 = "llvm.insertelement"(%52, %49, %53) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %111 = "llvm.insertelement"(%110, %50, %23) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %112 = "llvm.insertelement"(%111, %50, %22) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %113 = "llvm.insertelement"(%112, %50, %21) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %114 = "llvm.insertelement"(%113, %16, %20) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %115 = "llvm.insertelement"(%114, %50, %19) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %116 = "llvm.insertelement"(%115, %50, %18) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %117 = "llvm.insertelement"(%116, %50, %17) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %118 = "llvm.insertelement"(%52, %50, %53) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %119 = "llvm.insertelement"(%118, %51, %23) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %120 = "llvm.insertelement"(%119, %51, %22) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %121 = "llvm.insertelement"(%120, %50, %21) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %122 = "llvm.insertelement"(%121, %50, %20) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %123 = "llvm.insertelement"(%122, %49, %19) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %124 = "llvm.insertelement"(%123, %49, %18) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %125 = "llvm.insertelement"(%124, %50, %17) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %126 = "llvm.insertelement"(%52, %50, %53) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %127 = "llvm.insertelement"(%126, %49, %23) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %128 = "llvm.insertelement"(%127, %49, %22) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %129 = "llvm.insertelement"(%128, %50, %21) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %130 = "llvm.insertelement"(%129, %50, %20) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %131 = "llvm.insertelement"(%130, %49, %19) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %132 = "llvm.insertelement"(%131, %49, %18) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %133 = "llvm.insertelement"(%132, %50, %17) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %134 = "llvm.insertelement"(%52, %50, %53) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %135 = "llvm.insertelement"(%134, %49, %23) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %136 = "llvm.insertelement"(%135, %49, %22) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %137 = "llvm.insertelement"(%136, %50, %21) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %138 = "llvm.insertelement"(%137, %50, %20) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %139 = "llvm.insertelement"(%138, %16, %19) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %140 = "llvm.insertelement"(%139, %16, %18) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %141 = "llvm.insertelement"(%140, %50, %17) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %142 = "llvm.insertelement"(%52, %50, %53) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %143 = "llvm.insertelement"(%142, %50, %23) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %144 = "llvm.insertelement"(%143, %50, %22) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %145 = "llvm.insertelement"(%144, %50, %21) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %146 = "llvm.insertelement"(%145, %4, %20) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %147 = "llvm.insertelement"(%146, %4, %19) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %148 = "llvm.insertelement"(%147, %4, %18) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %149 = "llvm.insertelement"(%148, %4, %17) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %150 = "llvm.alloca"(%23) <{alignment = 16 : i64, elem_type = !llvm.array<66 x i8>}> : (i32) -> !llvm.ptr
  %151 = "llvm.alloca"(%23) <{alignment = 64 : i64, elem_type = !llvm.array<5 x struct<"struct.fd_curve25519_edwards", (vector<8xi64>, vector<8xi64>, vector<8xi64>)>>}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%150) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%151) : (!llvm.ptr) -> ()
  %152 = "llvm.getelementptr"(%150) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%24, %152) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (i8, !llvm.ptr) -> ()
  %153 = "llvm.getelementptr"(%150) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 63>}> : (!llvm.ptr) -> !llvm.ptr
  %154 = "llvm.load"(%arg1) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<32xi8>
  %155 = "llvm.and"(%154, %26) : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %156 = "llvm.lshr"(%154, %27) : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %157 = "llvm.shufflevector"(%155, %156) <{mask = array<i32: 0, 32, 1, 33, 2, 34, 3, 35, 4, 36, 5, 37, 6, 38, 7, 39, 8, 40, 9, 41, 10, 42, 11, 43, 12, 44, 13, 45, 14, 46, 15, 47, 16, 48, 17, 49, 18, 50, 19, 51, 20, 52, 21, 53, 22, 54, 23, 55, 24, 56, 25, 57, 26, 58, 27, 59, 28, 60, 29, 61, 30, 62, 31, 63>}> : (vector<32xi8>, vector<32xi8>) -> vector<64xi8>
  "llvm.store"(%157, %150) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<64xi8>, !llvm.ptr) -> ()
  "llvm.br"(%28)[^bb1] : (i64) -> ()
^bb1(%158: i64):  // 2 preds: ^bb0, ^bb1
  %159 = "llvm.getelementptr"(%150, %158) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %160 = "llvm.load"(%159) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %161 = "llvm.load"(%152) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %162 = "llvm.add"(%161, %160) <{overflowFlags = 0 : i32}> : (i8, i8) -> i8
  "llvm.store"(%162, %159) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (i8, !llvm.ptr) -> ()
  %163 = "llvm.sext"(%162) : (i8) -> i16
  %164 = "llvm.add"(%163, %29) <{overflowFlags = 1 : i32}> : (i16, i16) -> i16
  %165 = "llvm.lshr"(%164, %30) : (i16, i16) -> i16
  %166 = "llvm.trunc"(%165) <{overflowFlags = 0 : i32}> : (i16) -> i8
  "llvm.store"(%166, %152) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (i8, !llvm.ptr) -> ()
  %167 = "llvm.load"(%159) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %168 = "llvm.shl"(%166, %31) <{overflowFlags = 0 : i32}> : (i8, i8) -> i8
  %169 = "llvm.sub"(%167, %168) <{overflowFlags = 0 : i32}> : (i8, i8) -> i8
  "llvm.store"(%169, %159) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (i8, !llvm.ptr) -> ()
  %170 = "llvm.getelementptr"(%150, %158) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %171 = "llvm.getelementptr"(%170) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1>}> : (!llvm.ptr) -> !llvm.ptr
  %172 = "llvm.load"(%171) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %173 = "llvm.load"(%152) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %174 = "llvm.add"(%173, %172) <{overflowFlags = 0 : i32}> : (i8, i8) -> i8
  "llvm.store"(%174, %171) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (i8, !llvm.ptr) -> ()
  %175 = "llvm.sext"(%174) : (i8) -> i16
  %176 = "llvm.add"(%175, %29) <{overflowFlags = 1 : i32}> : (i16, i16) -> i16
  %177 = "llvm.lshr"(%176, %30) : (i16, i16) -> i16
  %178 = "llvm.trunc"(%177) <{overflowFlags = 0 : i32}> : (i16) -> i8
  "llvm.store"(%178, %152) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (i8, !llvm.ptr) -> ()
  %179 = "llvm.load"(%171) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %180 = "llvm.shl"(%178, %31) <{overflowFlags = 0 : i32}> : (i8, i8) -> i8
  %181 = "llvm.sub"(%179, %180) <{overflowFlags = 0 : i32}> : (i8, i8) -> i8
  "llvm.store"(%181, %171) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (i8, !llvm.ptr) -> ()
  %182 = "llvm.getelementptr"(%150, %158) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %183 = "llvm.getelementptr"(%182) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 2>}> : (!llvm.ptr) -> !llvm.ptr
  %184 = "llvm.load"(%183) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %185 = "llvm.load"(%152) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %186 = "llvm.add"(%185, %184) <{overflowFlags = 0 : i32}> : (i8, i8) -> i8
  "llvm.store"(%186, %183) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (i8, !llvm.ptr) -> ()
  %187 = "llvm.sext"(%186) : (i8) -> i16
  %188 = "llvm.add"(%187, %29) <{overflowFlags = 1 : i32}> : (i16, i16) -> i16
  %189 = "llvm.lshr"(%188, %30) : (i16, i16) -> i16
  %190 = "llvm.trunc"(%189) <{overflowFlags = 0 : i32}> : (i16) -> i8
  "llvm.store"(%190, %152) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (i8, !llvm.ptr) -> ()
  %191 = "llvm.load"(%183) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %192 = "llvm.shl"(%190, %31) <{overflowFlags = 0 : i32}> : (i8, i8) -> i8
  %193 = "llvm.sub"(%191, %192) <{overflowFlags = 0 : i32}> : (i8, i8) -> i8
  "llvm.store"(%193, %183) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (i8, !llvm.ptr) -> ()
  %194 = "llvm.getelementptr"(%150, %158) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %195 = "llvm.getelementptr"(%194) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 3>}> : (!llvm.ptr) -> !llvm.ptr
  %196 = "llvm.load"(%195) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %197 = "llvm.load"(%152) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %198 = "llvm.add"(%197, %196) <{overflowFlags = 0 : i32}> : (i8, i8) -> i8
  "llvm.store"(%198, %195) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (i8, !llvm.ptr) -> ()
  %199 = "llvm.sext"(%198) : (i8) -> i16
  %200 = "llvm.add"(%199, %29) <{overflowFlags = 1 : i32}> : (i16, i16) -> i16
  %201 = "llvm.lshr"(%200, %30) : (i16, i16) -> i16
  %202 = "llvm.trunc"(%201) <{overflowFlags = 0 : i32}> : (i16) -> i8
  "llvm.store"(%202, %152) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (i8, !llvm.ptr) -> ()
  %203 = "llvm.load"(%195) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %204 = "llvm.shl"(%202, %31) <{overflowFlags = 0 : i32}> : (i8, i8) -> i8
  %205 = "llvm.sub"(%203, %204) <{overflowFlags = 0 : i32}> : (i8, i8) -> i8
  "llvm.store"(%205, %195) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (i8, !llvm.ptr) -> ()
  %206 = "llvm.getelementptr"(%150, %158) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %207 = "llvm.getelementptr"(%206) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 4>}> : (!llvm.ptr) -> !llvm.ptr
  %208 = "llvm.load"(%207) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %209 = "llvm.load"(%152) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %210 = "llvm.add"(%209, %208) <{overflowFlags = 0 : i32}> : (i8, i8) -> i8
  "llvm.store"(%210, %207) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (i8, !llvm.ptr) -> ()
  %211 = "llvm.sext"(%210) : (i8) -> i16
  %212 = "llvm.add"(%211, %29) <{overflowFlags = 1 : i32}> : (i16, i16) -> i16
  %213 = "llvm.lshr"(%212, %30) : (i16, i16) -> i16
  %214 = "llvm.trunc"(%213) <{overflowFlags = 0 : i32}> : (i16) -> i8
  "llvm.store"(%214, %152) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (i8, !llvm.ptr) -> ()
  %215 = "llvm.load"(%207) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %216 = "llvm.shl"(%214, %31) <{overflowFlags = 0 : i32}> : (i8, i8) -> i8
  %217 = "llvm.sub"(%215, %216) <{overflowFlags = 0 : i32}> : (i8, i8) -> i8
  "llvm.store"(%217, %207) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (i8, !llvm.ptr) -> ()
  %218 = "llvm.getelementptr"(%150, %158) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %219 = "llvm.getelementptr"(%218) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 5>}> : (!llvm.ptr) -> !llvm.ptr
  %220 = "llvm.load"(%219) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %221 = "llvm.load"(%152) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %222 = "llvm.add"(%221, %220) <{overflowFlags = 0 : i32}> : (i8, i8) -> i8
  "llvm.store"(%222, %219) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (i8, !llvm.ptr) -> ()
  %223 = "llvm.sext"(%222) : (i8) -> i16
  %224 = "llvm.add"(%223, %29) <{overflowFlags = 1 : i32}> : (i16, i16) -> i16
  %225 = "llvm.lshr"(%224, %30) : (i16, i16) -> i16
  %226 = "llvm.trunc"(%225) <{overflowFlags = 0 : i32}> : (i16) -> i8
  "llvm.store"(%226, %152) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (i8, !llvm.ptr) -> ()
  %227 = "llvm.load"(%219) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %228 = "llvm.shl"(%226, %31) <{overflowFlags = 0 : i32}> : (i8, i8) -> i8
  %229 = "llvm.sub"(%227, %228) <{overflowFlags = 0 : i32}> : (i8, i8) -> i8
  "llvm.store"(%229, %219) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (i8, !llvm.ptr) -> ()
  %230 = "llvm.getelementptr"(%150, %158) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %231 = "llvm.getelementptr"(%230) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 6>}> : (!llvm.ptr) -> !llvm.ptr
  %232 = "llvm.load"(%231) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %233 = "llvm.load"(%152) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %234 = "llvm.add"(%233, %232) <{overflowFlags = 0 : i32}> : (i8, i8) -> i8
  "llvm.store"(%234, %231) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (i8, !llvm.ptr) -> ()
  %235 = "llvm.sext"(%234) : (i8) -> i16
  %236 = "llvm.add"(%235, %29) <{overflowFlags = 1 : i32}> : (i16, i16) -> i16
  %237 = "llvm.lshr"(%236, %30) : (i16, i16) -> i16
  %238 = "llvm.trunc"(%237) <{overflowFlags = 0 : i32}> : (i16) -> i8
  "llvm.store"(%238, %152) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (i8, !llvm.ptr) -> ()
  %239 = "llvm.load"(%231) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %240 = "llvm.shl"(%238, %31) <{overflowFlags = 0 : i32}> : (i8, i8) -> i8
  %241 = "llvm.sub"(%239, %240) <{overflowFlags = 0 : i32}> : (i8, i8) -> i8
  "llvm.store"(%241, %231) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (i8, !llvm.ptr) -> ()
  %242 = "llvm.add"(%158, %34) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %243 = "llvm.icmp"(%242, %25) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%243, %242)[^bb2, ^bb1] <{loop_annotation = #llvm.loop_annotation<mustProgress = true>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb2:  // pred: ^bb1
  %244 = "llvm.getelementptr"(%150) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 65>}> : (!llvm.ptr) -> !llvm.ptr
  %245 = "llvm.getelementptr"(%151) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 192>}> : (!llvm.ptr) -> !llvm.ptr
  %246 = "llvm.getelementptr"(%151) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 384>}> : (!llvm.ptr) -> !llvm.ptr
  %247 = "llvm.getelementptr"(%151) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 576>}> : (!llvm.ptr) -> !llvm.ptr
  %248 = "llvm.getelementptr"(%151) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 768>}> : (!llvm.ptr) -> !llvm.ptr
  %249 = "llvm.load"(%153) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %250 = "llvm.load"(%152) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %251 = "llvm.add"(%250, %249) <{overflowFlags = 0 : i32}> : (i8, i8) -> i8
  "llvm.store"(%251, %153) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (i8, !llvm.ptr) -> ()
  "llvm.store"(%35, %arg0) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %252 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.memset"(%252, %24, %36) <{arg_attrs = [{llvm.align = 64 : i64, llvm.dereferenceable = 128 : i64, llvm.nonnull, llvm.noundef}, {}, {}], isVolatile = false}> : (!llvm.ptr, i8, i64) -> ()
  %253 = "llvm.getelementptr"(%151) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 448>}> : (!llvm.ptr) -> !llvm.ptr
  %254 = "llvm.getelementptr"(%151) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %255 = "llvm.getelementptr"(%151) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 512>}> : (!llvm.ptr) -> !llvm.ptr
  %256 = "llvm.getelementptr"(%151) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.br"(%32)[^bb6] : (i64) -> ()
^bb3:  // pred: ^bb6
  "llvm.intr.experimental.noalias.scope.decl"() <{scope = #llvm.alias_scope<id = distinct[0]<>, domain = <id = distinct[1]<>, description = "fd_ed25519_point_dbln_secure">, description = "fd_ed25519_point_dbln_secure: argument 0">}> : () -> ()
  "llvm.intr.experimental.noalias.scope.decl"() <{scope = #llvm.alias_scope<id = distinct[2]<>, domain = <id = distinct[1]<>, description = "fd_ed25519_point_dbln_secure">, description = "fd_ed25519_point_dbln_secure: argument 1">}> : () -> ()
  %257 = "llvm.load"(%arg0) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[0]<>, domain = <id = distinct[1]<>, description = "fd_ed25519_point_dbln_secure">, description = "fd_ed25519_point_dbln_secure: argument 0">, #llvm.alias_scope<id = distinct[2]<>, domain = <id = distinct[1]<>, description = "fd_ed25519_point_dbln_secure">, description = "fd_ed25519_point_dbln_secure: argument 1">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %258 = "llvm.shufflevector"(%257, %14) <{mask = array<i32: 1, 1, 2, 0, 5, 5, 6, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %259 = "llvm.load"(%252) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[0]<>, domain = <id = distinct[1]<>, description = "fd_ed25519_point_dbln_secure">, description = "fd_ed25519_point_dbln_secure: argument 0">, #llvm.alias_scope<id = distinct[2]<>, domain = <id = distinct[1]<>, description = "fd_ed25519_point_dbln_secure">, description = "fd_ed25519_point_dbln_secure: argument 1">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %260 = "llvm.shufflevector"(%259, %14) <{mask = array<i32: 1, 1, 2, 0, 5, 5, 6, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %261 = "llvm.getelementptr"(%151) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 640>}> : (!llvm.ptr) -> !llvm.ptr
  %262 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %263 = "llvm.load"(%262) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[0]<>, domain = <id = distinct[1]<>, description = "fd_ed25519_point_dbln_secure">, description = "fd_ed25519_point_dbln_secure: argument 0">, #llvm.alias_scope<id = distinct[2]<>, domain = <id = distinct[1]<>, description = "fd_ed25519_point_dbln_secure">, description = "fd_ed25519_point_dbln_secure: argument 1">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %264 = "llvm.shufflevector"(%263, %14) <{mask = array<i32: 1, 1, 2, 0, 5, 5, 6, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %265 = "llvm.getelementptr"(%151) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 704>}> : (!llvm.ptr) -> !llvm.ptr
  %266 = "llvm.add"(%258, %257) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %267 = "llvm.shufflevector"(%266, %258) <{mask = array<i32: 0, 9, 10, 11, 4, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %268 = "llvm.add"(%260, %259) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %269 = "llvm.shufflevector"(%268, %260) <{mask = array<i32: 0, 9, 10, 11, 4, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %270 = "llvm.add"(%264, %263) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %271 = "llvm.shufflevector"(%270, %264) <{mask = array<i32: 0, 9, 10, 11, 4, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %272 = "llvm.shufflevector"(%267, %271) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %273 = "llvm.shufflevector"(%269, %271) <{mask = array<i32: 0, 1, 2, 3, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %274 = "llvm.shufflevector"(%267, %269) <{mask = array<i32: 4, 5, 6, 7, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %275 = "llvm.shufflevector"(%269, %14) <{mask = array<i32: 4, 5, 6, 7, 0, 1, 2, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %276 = "llvm.shufflevector"(%271, %267) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %277 = "llvm.shufflevector"(%271, %14) <{mask = array<i32: 4, 5, 6, 7, 0, 1, 2, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %278 = "llvm.shufflevector"(%269, %85) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %279 = "llvm.shl"(%267, %13) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %280 = "llvm.shl"(%269, %13) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %281 = "llvm.shl"(%272, %13) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %282 = "llvm.shl"(%273, %13) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %283 = "llvm.call_intrinsic"(%44, %272, %272) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %284 = "llvm.call_intrinsic"(%44, %281, %269) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %285 = "llvm.call_intrinsic"(%44, %269, %269) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %286 = "llvm.call_intrinsic"(%285, %279, %271) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %287 = "llvm.call_intrinsic"(%44, %279, %274) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %288 = "llvm.call_intrinsic"(%287, %282, %271) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %289 = "llvm.call_intrinsic"(%44, %276, %276) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %290 = "llvm.call_intrinsic"(%289, %281, %275) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %291 = "llvm.call_intrinsic"(%290, %282, %274) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %292 = "llvm.call_intrinsic"(%44, %279, %277) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %293 = "llvm.call_intrinsic"(%292, %280, %278) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %294 = "llvm.call_intrinsic"(%44, %272, %272) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %295 = "llvm.shl"(%294, %12) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %296 = "llvm.call_intrinsic"(%44, %281, %269) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %297 = "llvm.shl"(%296, %12) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %298 = "llvm.call_intrinsic"(%44, %269, %269) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %299 = "llvm.call_intrinsic"(%298, %279, %271) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %300 = "llvm.shl"(%299, %12) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %301 = "llvm.call_intrinsic"(%44, %279, %274) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %302 = "llvm.call_intrinsic"(%301, %282, %271) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %303 = "llvm.shl"(%302, %12) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %304 = "llvm.call_intrinsic"(%44, %276, %276) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %305 = "llvm.call_intrinsic"(%304, %281, %275) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %306 = "llvm.call_intrinsic"(%305, %282, %274) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %307 = "llvm.shl"(%306, %12) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %308 = "llvm.call_intrinsic"(%44, %279, %277) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %309 = "llvm.call_intrinsic"(%308, %280, %278) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %310 = "llvm.shl"(%309, %12) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %311 = "llvm.shufflevector"(%283, %288) <{mask = array<i32: 0, 1, 2, 3, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %312 = "llvm.shufflevector"(%85, %300) <{mask = array<i32: 0, 1, 2, 3, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %313 = "llvm.add"(%312, %311) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %314 = "llvm.shufflevector"(%284, %291) <{mask = array<i32: 0, 1, 2, 3, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %315 = "llvm.shufflevector"(%295, %303) <{mask = array<i32: 0, 1, 2, 3, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %316 = "llvm.add"(%315, %314) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %317 = "llvm.shufflevector"(%286, %293) <{mask = array<i32: 0, 1, 2, 3, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %318 = "llvm.shufflevector"(%297, %307) <{mask = array<i32: 0, 1, 2, 3, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %319 = "llvm.shufflevector"(%85, %293) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %320 = "llvm.shufflevector"(%291, %284) <{mask = array<i32: 4, 5, 6, 7, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %321 = "llvm.shufflevector"(%310, %300) <{mask = array<i32: 4, 5, 6, 7, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %322 = "llvm.add"(%321, %320) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %323 = "llvm.shufflevector"(%310, %93) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %324 = "llvm.add"(%322, %323) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %325 = "llvm.shufflevector"(%288, %283) <{mask = array<i32: 4, 5, 6, 7, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %326 = "llvm.shufflevector"(%307, %297) <{mask = array<i32: 4, 5, 6, 7, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %327 = "llvm.add"(%326, %325) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %328 = "llvm.shufflevector"(%286, %93) <{mask = array<i32: 4, 5, 6, 7, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %329 = "llvm.shufflevector"(%303, %295) <{mask = array<i32: 4, 5, 6, 7, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %330 = "llvm.add"(%329, %328) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %331 = "llvm.shl"(%324, %11) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %332 = "llvm.add"(%313, %331) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %333 = "llvm.mul"(%324, %10) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %334 = "llvm.add"(%332, %333) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %335 = "llvm.shl"(%327, %11) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %336 = "llvm.add"(%316, %335) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %337 = "llvm.mul"(%327, %10) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %338 = "llvm.add"(%336, %337) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %339 = "llvm.shl"(%330, %11) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %340 = "llvm.mul"(%330, %10) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %341 = "llvm.add"(%319, %317) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %342 = "llvm.add"(%341, %339) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %343 = "llvm.add"(%342, %340) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %344 = "llvm.add"(%343, %318) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %345 = "llvm.shl"(%334, %9) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %346 = "llvm.shl"(%338, %9) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %347 = "llvm.shl"(%344, %9) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %348 = "llvm.shufflevector"(%345, %14) <{mask = array<i32: 3, 3, 3, 3, 7, 7, 7, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %349 = "llvm.shufflevector"(%346, %14) <{mask = array<i32: 3, 3, 3, 3, 7, 7, 7, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %350 = "llvm.getelementptr"(%151) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 832>}> : (!llvm.ptr) -> !llvm.ptr
  %351 = "llvm.shufflevector"(%347, %14) <{mask = array<i32: 3, 3, 3, 3, 7, 7, 7, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %352 = "llvm.add"(%348, %345) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %353 = "llvm.shufflevector"(%348, %352) <{mask = array<i32: 0, 1, 10, 3, 4, 5, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %354 = "llvm.add"(%349, %346) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %355 = "llvm.shufflevector"(%349, %354) <{mask = array<i32: 0, 1, 10, 3, 4, 5, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %356 = "llvm.add"(%351, %347) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %357 = "llvm.shufflevector"(%351, %356) <{mask = array<i32: 0, 1, 10, 3, 4, 5, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %358 = "llvm.sub"(%353, %345) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %359 = "llvm.add"(%358, %101) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %360 = "llvm.shufflevector"(%359, %353) <{mask = array<i32: 0, -1, -1, 11, 4, -1, -1, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %361 = "llvm.sub"(%355, %346) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %362 = "llvm.add"(%361, %109) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %363 = "llvm.shufflevector"(%362, %355) <{mask = array<i32: 0, -1, -1, 11, 4, -1, -1, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %364 = "llvm.sub"(%357, %347) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %365 = "llvm.add"(%364, %117) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %366 = "llvm.shufflevector"(%365, %357) <{mask = array<i32: 0, -1, -1, 11, 4, -1, -1, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %367 = "llvm.shufflevector"(%345, %14) <{mask = array<i32: 1, 1, 1, 1, 5, 5, 5, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %368 = "llvm.shufflevector"(%346, %14) <{mask = array<i32: 1, 1, 1, 1, 5, 5, 5, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %369 = "llvm.shufflevector"(%347, %14) <{mask = array<i32: 1, 1, 1, 1, 5, 5, 5, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %370 = "llvm.add"(%360, %367) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %371 = "llvm.add"(%363, %368) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %372 = "llvm.add"(%366, %369) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %373 = "llvm.sub"(%353, %367) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %374 = "llvm.add"(%373, %125) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %375 = "llvm.shufflevector"(%370, %374) <{mask = array<i32: 0, 9, 10, 3, 4, 13, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %376 = "llvm.sub"(%355, %368) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %377 = "llvm.add"(%376, %133) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %378 = "llvm.shufflevector"(%371, %377) <{mask = array<i32: 0, 9, 10, 3, 4, 13, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %379 = "llvm.sub"(%357, %369) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %380 = "llvm.add"(%379, %141) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %381 = "llvm.shufflevector"(%372, %380) <{mask = array<i32: 0, 9, 10, 3, 4, 13, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %382 = "llvm.add"(%375, %8) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %383 = "llvm.add"(%378, %7) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %384 = "llvm.add"(%381, %7) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %385 = "llvm.ashr"(%382, %6) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %386 = "llvm.ashr"(%383, %6) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %387 = "llvm.ashr"(%384, %5) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %388 = "llvm.mul"(%387, %149) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %389 = "llvm.and"(%382, %3) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %390 = "llvm.shufflevector"(%388, %387) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %391 = "llvm.add"(%390, %2) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %392 = "llvm.add"(%391, %389) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %393 = "llvm.and"(%383, %3) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %394 = "llvm.add"(%393, %1) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %395 = "llvm.add"(%394, %385) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %396 = "llvm.and"(%384, %0) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %397 = "llvm.add"(%396, %1) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %398 = "llvm.add"(%397, %386) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %399 = "llvm.shufflevector"(%392, %14) <{mask = array<i32: 2, 3, 2, 3, 6, 7, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %400 = "llvm.shufflevector"(%395, %14) <{mask = array<i32: 2, 3, 2, 3, 6, 7, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %401 = "llvm.shufflevector"(%398, %14) <{mask = array<i32: 2, 3, 2, 3, 6, 7, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %402 = "llvm.shufflevector"(%392, %14) <{mask = array<i32: 0, 1, 1, 0, 0, 1, 1, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %403 = "llvm.shufflevector"(%395, %14) <{mask = array<i32: 0, 1, 1, 0, 0, 1, 1, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %404 = "llvm.shufflevector"(%398, %14) <{mask = array<i32: 0, 1, 1, 0, 0, 1, 1, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %405 = "llvm.shufflevector"(%392, %14) <{mask = array<i32: 4, 5, 5, 4, 4, 5, 5, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %406 = "llvm.shufflevector"(%395, %14) <{mask = array<i32: 4, 5, 5, 4, 4, 5, 5, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %407 = "llvm.shufflevector"(%398, %14) <{mask = array<i32: 4, 5, 5, 4, 4, 5, 5, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %408 = "llvm.call_intrinsic"(%44, %402, %399) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %409 = "llvm.call_intrinsic"(%44, %403, %399) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %410 = "llvm.call_intrinsic"(%409, %402, %400) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %411 = "llvm.call_intrinsic"(%44, %404, %399) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %412 = "llvm.call_intrinsic"(%411, %403, %400) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %413 = "llvm.call_intrinsic"(%412, %402, %401) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %414 = "llvm.call_intrinsic"(%44, %405, %399) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %415 = "llvm.call_intrinsic"(%414, %404, %400) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %416 = "llvm.call_intrinsic"(%415, %403, %401) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %417 = "llvm.call_intrinsic"(%44, %406, %399) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %418 = "llvm.call_intrinsic"(%417, %405, %400) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %419 = "llvm.call_intrinsic"(%418, %404, %401) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %420 = "llvm.call_intrinsic"(%44, %407, %399) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %421 = "llvm.call_intrinsic"(%420, %406, %400) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %422 = "llvm.call_intrinsic"(%421, %405, %401) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %423 = "llvm.call_intrinsic"(%44, %407, %400) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %424 = "llvm.call_intrinsic"(%423, %406, %401) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %425 = "llvm.call_intrinsic"(%44, %402, %399) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %426 = "llvm.shl"(%425, %12) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %427 = "llvm.add"(%426, %410) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %428 = "llvm.call_intrinsic"(%44, %403, %399) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %429 = "llvm.call_intrinsic"(%428, %402, %400) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %430 = "llvm.shl"(%429, %12) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %431 = "llvm.add"(%430, %413) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %432 = "llvm.call_intrinsic"(%44, %404, %399) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %433 = "llvm.call_intrinsic"(%432, %403, %400) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %434 = "llvm.call_intrinsic"(%433, %402, %401) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %435 = "llvm.shl"(%434, %12) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %436 = "llvm.add"(%435, %416) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %437 = "llvm.call_intrinsic"(%44, %405, %399) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %438 = "llvm.call_intrinsic"(%437, %404, %400) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %439 = "llvm.call_intrinsic"(%438, %403, %401) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %440 = "llvm.shl"(%439, %12) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %441 = "llvm.add"(%440, %419) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %442 = "llvm.call_intrinsic"(%44, %406, %399) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %443 = "llvm.call_intrinsic"(%442, %405, %400) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %444 = "llvm.call_intrinsic"(%443, %404, %401) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %445 = "llvm.shl"(%444, %12) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %446 = "llvm.add"(%445, %422) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %447 = "llvm.call_intrinsic"(%44, %407, %399) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %448 = "llvm.call_intrinsic"(%447, %406, %400) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %449 = "llvm.call_intrinsic"(%448, %405, %401) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %450 = "llvm.shl"(%449, %12) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %451 = "llvm.add"(%450, %424) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %452 = "llvm.call_intrinsic"(%44, %407, %400) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %453 = "llvm.call_intrinsic"(%452, %406, %401) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %454 = "llvm.shl"(%453, %12) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %455 = "llvm.call_intrinsic"(%454, %407, %401) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %456 = "llvm.call_intrinsic"(%44, %407, %401) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %457 = "llvm.shl"(%456, %12) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %458 = "llvm.shufflevector"(%436, %14) <{mask = array<i32: 4, 5, 6, 7, 0, 1, 2, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %459 = "llvm.shufflevector"(%441, %14) <{mask = array<i32: 4, 5, 6, 7, 0, 1, 2, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %460 = "llvm.shufflevector"(%446, %14) <{mask = array<i32: 4, 5, 6, 7, 0, 1, 2, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %461 = "llvm.add"(%458, %408) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %462 = "llvm.shufflevector"(%408, %461) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %463 = "llvm.add"(%459, %427) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %464 = "llvm.shufflevector"(%427, %463) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %465 = "llvm.add"(%460, %431) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %466 = "llvm.shufflevector"(%431, %465) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %467 = "llvm.add"(%451, %458) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %468 = "llvm.shufflevector"(%467, %451) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %469 = "llvm.add"(%455, %459) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %470 = "llvm.shufflevector"(%469, %455) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %471 = "llvm.add"(%457, %460) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %472 = "llvm.shufflevector"(%471, %457) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %473 = "llvm.shl"(%468, %11) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %474 = "llvm.add"(%473, %462) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %475 = "llvm.mul"(%468, %10) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %476 = "llvm.add"(%474, %475) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %477 = "llvm.shl"(%470, %11) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %478 = "llvm.add"(%477, %464) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %479 = "llvm.mul"(%470, %10) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %480 = "llvm.add"(%478, %479) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %481 = "llvm.shl"(%472, %11) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %482 = "llvm.add"(%481, %466) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %483 = "llvm.mul"(%472, %10) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %484 = "llvm.add"(%482, %483) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %485 = "llvm.lshr"(%476, %6) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %486 = "llvm.lshr"(%480, %6) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %487 = "llvm.lshr"(%484, %5) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %488 = "llvm.mul"(%487, %149) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %489 = "llvm.and"(%476, %3) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %490 = "llvm.shufflevector"(%488, %487) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %491 = "llvm.add"(%490, %489) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %492 = "llvm.and"(%480, %3) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %493 = "llvm.add"(%492, %485) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %494 = "llvm.and"(%484, %0) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %495 = "llvm.add"(%494, %486) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.br"(%38, %491, %493, %495)[^bb4] : (i8, vector<8xi64>, vector<8xi64>, vector<8xi64>) -> ()
^bb4(%496: i8, %497: vector<8xi64>, %498: vector<8xi64>, %499: vector<8xi64>):  // 2 preds: ^bb3, ^bb4
  %500 = "llvm.shufflevector"(%497, %14) <{mask = array<i32: 1, 1, 2, 0, 5, 5, 6, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %501 = "llvm.shufflevector"(%498, %14) <{mask = array<i32: 1, 1, 2, 0, 5, 5, 6, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %502 = "llvm.shufflevector"(%499, %14) <{mask = array<i32: 1, 1, 2, 0, 5, 5, 6, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %503 = "llvm.add"(%500, %497) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %504 = "llvm.shufflevector"(%503, %500) <{mask = array<i32: 0, 9, 10, 11, 4, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %505 = "llvm.add"(%501, %498) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %506 = "llvm.shufflevector"(%505, %501) <{mask = array<i32: 0, 9, 10, 11, 4, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %507 = "llvm.add"(%502, %499) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %508 = "llvm.shufflevector"(%507, %502) <{mask = array<i32: 0, 9, 10, 11, 4, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %509 = "llvm.shufflevector"(%504, %508) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %510 = "llvm.shufflevector"(%506, %508) <{mask = array<i32: 0, 1, 2, 3, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %511 = "llvm.shufflevector"(%504, %506) <{mask = array<i32: 4, 5, 6, 7, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %512 = "llvm.shufflevector"(%506, %14) <{mask = array<i32: 4, 5, 6, 7, 0, 1, 2, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %513 = "llvm.shufflevector"(%508, %504) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %514 = "llvm.shufflevector"(%508, %14) <{mask = array<i32: 4, 5, 6, 7, 0, 1, 2, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %515 = "llvm.shufflevector"(%506, %85) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %516 = "llvm.shl"(%504, %13) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %517 = "llvm.shl"(%506, %13) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %518 = "llvm.shl"(%509, %13) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %519 = "llvm.shl"(%510, %13) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %520 = "llvm.call_intrinsic"(%44, %509, %509) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %521 = "llvm.call_intrinsic"(%44, %518, %506) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %522 = "llvm.call_intrinsic"(%44, %506, %506) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %523 = "llvm.call_intrinsic"(%522, %516, %508) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %524 = "llvm.call_intrinsic"(%44, %516, %511) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %525 = "llvm.call_intrinsic"(%524, %519, %508) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %526 = "llvm.call_intrinsic"(%44, %513, %513) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %527 = "llvm.call_intrinsic"(%526, %518, %512) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %528 = "llvm.call_intrinsic"(%527, %519, %511) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %529 = "llvm.call_intrinsic"(%44, %516, %514) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %530 = "llvm.call_intrinsic"(%529, %517, %515) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %531 = "llvm.call_intrinsic"(%44, %509, %509) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %532 = "llvm.shl"(%531, %12) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %533 = "llvm.call_intrinsic"(%44, %518, %506) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %534 = "llvm.shl"(%533, %12) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %535 = "llvm.call_intrinsic"(%44, %506, %506) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %536 = "llvm.call_intrinsic"(%535, %516, %508) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %537 = "llvm.shl"(%536, %12) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %538 = "llvm.call_intrinsic"(%44, %516, %511) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %539 = "llvm.call_intrinsic"(%538, %519, %508) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %540 = "llvm.shl"(%539, %12) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %541 = "llvm.call_intrinsic"(%44, %513, %513) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %542 = "llvm.call_intrinsic"(%541, %518, %512) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %543 = "llvm.call_intrinsic"(%542, %519, %511) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %544 = "llvm.shl"(%543, %12) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %545 = "llvm.call_intrinsic"(%44, %516, %514) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %546 = "llvm.call_intrinsic"(%545, %517, %515) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %547 = "llvm.shl"(%546, %12) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %548 = "llvm.shufflevector"(%520, %525) <{mask = array<i32: 0, 1, 2, 3, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %549 = "llvm.shufflevector"(%85, %537) <{mask = array<i32: 0, 1, 2, 3, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %550 = "llvm.add"(%549, %548) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %551 = "llvm.shufflevector"(%521, %528) <{mask = array<i32: 0, 1, 2, 3, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %552 = "llvm.shufflevector"(%532, %540) <{mask = array<i32: 0, 1, 2, 3, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %553 = "llvm.add"(%552, %551) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %554 = "llvm.shufflevector"(%523, %530) <{mask = array<i32: 0, 1, 2, 3, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %555 = "llvm.shufflevector"(%534, %544) <{mask = array<i32: 0, 1, 2, 3, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %556 = "llvm.shufflevector"(%85, %530) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %557 = "llvm.shufflevector"(%528, %521) <{mask = array<i32: 4, 5, 6, 7, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %558 = "llvm.shufflevector"(%547, %537) <{mask = array<i32: 4, 5, 6, 7, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %559 = "llvm.add"(%558, %557) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %560 = "llvm.shufflevector"(%547, %93) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %561 = "llvm.add"(%559, %560) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %562 = "llvm.shufflevector"(%525, %520) <{mask = array<i32: 4, 5, 6, 7, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %563 = "llvm.shufflevector"(%544, %534) <{mask = array<i32: 4, 5, 6, 7, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %564 = "llvm.add"(%563, %562) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %565 = "llvm.shufflevector"(%523, %93) <{mask = array<i32: 4, 5, 6, 7, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %566 = "llvm.shufflevector"(%540, %532) <{mask = array<i32: 4, 5, 6, 7, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %567 = "llvm.add"(%566, %565) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %568 = "llvm.shl"(%561, %11) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %569 = "llvm.add"(%550, %568) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %570 = "llvm.mul"(%561, %10) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %571 = "llvm.add"(%569, %570) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %572 = "llvm.shl"(%564, %11) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %573 = "llvm.add"(%553, %572) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %574 = "llvm.mul"(%564, %10) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %575 = "llvm.add"(%573, %574) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %576 = "llvm.shl"(%567, %11) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %577 = "llvm.mul"(%567, %10) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %578 = "llvm.add"(%556, %554) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %579 = "llvm.add"(%578, %576) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %580 = "llvm.add"(%579, %577) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %581 = "llvm.add"(%580, %555) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %582 = "llvm.shl"(%571, %9) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %583 = "llvm.shl"(%575, %9) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %584 = "llvm.shl"(%581, %9) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %585 = "llvm.shufflevector"(%582, %14) <{mask = array<i32: 3, 3, 3, 3, 7, 7, 7, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %586 = "llvm.shufflevector"(%583, %14) <{mask = array<i32: 3, 3, 3, 3, 7, 7, 7, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %587 = "llvm.shufflevector"(%584, %14) <{mask = array<i32: 3, 3, 3, 3, 7, 7, 7, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %588 = "llvm.add"(%585, %582) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %589 = "llvm.shufflevector"(%585, %588) <{mask = array<i32: 0, 1, 10, 3, 4, 5, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %590 = "llvm.add"(%586, %583) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %591 = "llvm.shufflevector"(%586, %590) <{mask = array<i32: 0, 1, 10, 3, 4, 5, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %592 = "llvm.add"(%587, %584) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %593 = "llvm.shufflevector"(%587, %592) <{mask = array<i32: 0, 1, 10, 3, 4, 5, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %594 = "llvm.sub"(%589, %582) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %595 = "llvm.add"(%594, %101) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %596 = "llvm.shufflevector"(%595, %589) <{mask = array<i32: 0, -1, -1, 11, 4, -1, -1, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %597 = "llvm.sub"(%591, %583) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %598 = "llvm.add"(%597, %109) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %599 = "llvm.shufflevector"(%598, %591) <{mask = array<i32: 0, -1, -1, 11, 4, -1, -1, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %600 = "llvm.sub"(%593, %584) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %601 = "llvm.add"(%600, %117) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %602 = "llvm.shufflevector"(%601, %593) <{mask = array<i32: 0, -1, -1, 11, 4, -1, -1, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %603 = "llvm.shufflevector"(%582, %14) <{mask = array<i32: 1, 1, 1, 1, 5, 5, 5, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %604 = "llvm.shufflevector"(%583, %14) <{mask = array<i32: 1, 1, 1, 1, 5, 5, 5, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %605 = "llvm.shufflevector"(%584, %14) <{mask = array<i32: 1, 1, 1, 1, 5, 5, 5, 5>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %606 = "llvm.add"(%596, %603) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %607 = "llvm.add"(%599, %604) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %608 = "llvm.add"(%602, %605) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %609 = "llvm.sub"(%589, %603) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %610 = "llvm.add"(%609, %125) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %611 = "llvm.shufflevector"(%606, %610) <{mask = array<i32: 0, 9, 10, 3, 4, 13, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %612 = "llvm.sub"(%591, %604) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %613 = "llvm.add"(%612, %133) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %614 = "llvm.shufflevector"(%607, %613) <{mask = array<i32: 0, 9, 10, 3, 4, 13, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %615 = "llvm.sub"(%593, %605) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %616 = "llvm.add"(%615, %141) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %617 = "llvm.shufflevector"(%608, %616) <{mask = array<i32: 0, 9, 10, 3, 4, 13, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %618 = "llvm.add"(%611, %8) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %619 = "llvm.add"(%614, %7) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %620 = "llvm.add"(%617, %7) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %621 = "llvm.ashr"(%618, %6) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %622 = "llvm.ashr"(%619, %6) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %623 = "llvm.ashr"(%620, %5) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %624 = "llvm.mul"(%623, %149) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %625 = "llvm.and"(%618, %3) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %626 = "llvm.shufflevector"(%624, %623) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %627 = "llvm.add"(%626, %2) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %628 = "llvm.add"(%627, %625) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %629 = "llvm.and"(%619, %3) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %630 = "llvm.add"(%629, %1) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %631 = "llvm.add"(%630, %621) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %632 = "llvm.and"(%620, %0) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %633 = "llvm.add"(%632, %1) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %634 = "llvm.add"(%633, %622) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %635 = "llvm.shufflevector"(%628, %14) <{mask = array<i32: 2, 3, 2, 3, 6, 7, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %636 = "llvm.shufflevector"(%631, %14) <{mask = array<i32: 2, 3, 2, 3, 6, 7, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %637 = "llvm.shufflevector"(%634, %14) <{mask = array<i32: 2, 3, 2, 3, 6, 7, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %638 = "llvm.shufflevector"(%628, %14) <{mask = array<i32: 0, 1, 1, 0, 0, 1, 1, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %639 = "llvm.shufflevector"(%631, %14) <{mask = array<i32: 0, 1, 1, 0, 0, 1, 1, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %640 = "llvm.shufflevector"(%634, %14) <{mask = array<i32: 0, 1, 1, 0, 0, 1, 1, 0>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %641 = "llvm.shufflevector"(%628, %14) <{mask = array<i32: 4, 5, 5, 4, 4, 5, 5, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %642 = "llvm.shufflevector"(%631, %14) <{mask = array<i32: 4, 5, 5, 4, 4, 5, 5, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %643 = "llvm.shufflevector"(%634, %14) <{mask = array<i32: 4, 5, 5, 4, 4, 5, 5, 4>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %644 = "llvm.call_intrinsic"(%44, %638, %635) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %645 = "llvm.call_intrinsic"(%44, %639, %635) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %646 = "llvm.call_intrinsic"(%645, %638, %636) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %647 = "llvm.call_intrinsic"(%44, %640, %635) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %648 = "llvm.call_intrinsic"(%647, %639, %636) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %649 = "llvm.call_intrinsic"(%648, %638, %637) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %650 = "llvm.call_intrinsic"(%44, %641, %635) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %651 = "llvm.call_intrinsic"(%650, %640, %636) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %652 = "llvm.call_intrinsic"(%651, %639, %637) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %653 = "llvm.call_intrinsic"(%44, %642, %635) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %654 = "llvm.call_intrinsic"(%653, %641, %636) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %655 = "llvm.call_intrinsic"(%654, %640, %637) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %656 = "llvm.call_intrinsic"(%44, %643, %635) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %657 = "llvm.call_intrinsic"(%656, %642, %636) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %658 = "llvm.call_intrinsic"(%657, %641, %637) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %659 = "llvm.call_intrinsic"(%44, %643, %636) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %660 = "llvm.call_intrinsic"(%659, %642, %637) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %661 = "llvm.call_intrinsic"(%44, %638, %635) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %662 = "llvm.shl"(%661, %12) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %663 = "llvm.add"(%662, %646) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %664 = "llvm.call_intrinsic"(%44, %639, %635) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %665 = "llvm.call_intrinsic"(%664, %638, %636) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %666 = "llvm.shl"(%665, %12) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %667 = "llvm.add"(%666, %649) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %668 = "llvm.call_intrinsic"(%44, %640, %635) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %669 = "llvm.call_intrinsic"(%668, %639, %636) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %670 = "llvm.call_intrinsic"(%669, %638, %637) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %671 = "llvm.shl"(%670, %12) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %672 = "llvm.add"(%671, %652) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %673 = "llvm.call_intrinsic"(%44, %641, %635) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %674 = "llvm.call_intrinsic"(%673, %640, %636) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %675 = "llvm.call_intrinsic"(%674, %639, %637) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %676 = "llvm.shl"(%675, %12) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %677 = "llvm.add"(%676, %655) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %678 = "llvm.call_intrinsic"(%44, %642, %635) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %679 = "llvm.call_intrinsic"(%678, %641, %636) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %680 = "llvm.call_intrinsic"(%679, %640, %637) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %681 = "llvm.shl"(%680, %12) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %682 = "llvm.add"(%681, %658) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %683 = "llvm.call_intrinsic"(%44, %643, %635) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %684 = "llvm.call_intrinsic"(%683, %642, %636) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %685 = "llvm.call_intrinsic"(%684, %641, %637) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %686 = "llvm.shl"(%685, %12) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %687 = "llvm.add"(%686, %660) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %688 = "llvm.call_intrinsic"(%44, %643, %636) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %689 = "llvm.call_intrinsic"(%688, %642, %637) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %690 = "llvm.shl"(%689, %12) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %691 = "llvm.call_intrinsic"(%690, %643, %637) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %692 = "llvm.call_intrinsic"(%44, %643, %637) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %693 = "llvm.shl"(%692, %12) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %694 = "llvm.shufflevector"(%672, %14) <{mask = array<i32: 4, 5, 6, 7, 0, 1, 2, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %695 = "llvm.shufflevector"(%677, %14) <{mask = array<i32: 4, 5, 6, 7, 0, 1, 2, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %696 = "llvm.shufflevector"(%682, %14) <{mask = array<i32: 4, 5, 6, 7, 0, 1, 2, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %697 = "llvm.add"(%694, %644) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %698 = "llvm.shufflevector"(%644, %697) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %699 = "llvm.add"(%695, %663) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %700 = "llvm.shufflevector"(%663, %699) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %701 = "llvm.add"(%696, %667) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %702 = "llvm.shufflevector"(%667, %701) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %703 = "llvm.add"(%687, %694) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %704 = "llvm.shufflevector"(%703, %687) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %705 = "llvm.add"(%691, %695) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %706 = "llvm.shufflevector"(%705, %691) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %707 = "llvm.add"(%693, %696) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %708 = "llvm.shufflevector"(%707, %693) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %709 = "llvm.shl"(%704, %11) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %710 = "llvm.add"(%709, %698) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %711 = "llvm.mul"(%704, %10) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %712 = "llvm.add"(%710, %711) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %713 = "llvm.shl"(%706, %11) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %714 = "llvm.add"(%713, %700) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %715 = "llvm.mul"(%706, %10) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %716 = "llvm.add"(%714, %715) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %717 = "llvm.shl"(%708, %11) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %718 = "llvm.add"(%717, %702) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %719 = "llvm.mul"(%708, %10) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %720 = "llvm.add"(%718, %719) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %721 = "llvm.lshr"(%712, %6) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %722 = "llvm.lshr"(%716, %6) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %723 = "llvm.lshr"(%720, %5) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %724 = "llvm.mul"(%723, %149) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %725 = "llvm.and"(%712, %3) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %726 = "llvm.shufflevector"(%724, %723) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %727 = "llvm.add"(%726, %725) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %728 = "llvm.and"(%716, %3) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %729 = "llvm.add"(%728, %721) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %730 = "llvm.and"(%720, %0) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %731 = "llvm.add"(%730, %722) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %732 = "llvm.add"(%496, %38) <{overflowFlags = 3 : i32}> : (i8, i8) -> i8
  %733 = "llvm.icmp"(%732, %31) <{predicate = 0 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%733, %732, %727, %729, %731)[^bb5, ^bb4] <{loop_annotation = #llvm.loop_annotation<mustProgress = true>, operandSegmentSizes = array<i32: 1, 0, 4>}> : (i1, i8, vector<8xi64>, vector<8xi64>, vector<8xi64>) -> ()
^bb5:  // pred: ^bb4
  %734 = "llvm.getelementptr"(%151) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 896>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%727, %arg0) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[0]<>, domain = <id = distinct[1]<>, description = "fd_ed25519_point_dbln_secure">, description = "fd_ed25519_point_dbln_secure: argument 0">, #llvm.alias_scope<id = distinct[2]<>, domain = <id = distinct[1]<>, description = "fd_ed25519_point_dbln_secure">, description = "fd_ed25519_point_dbln_secure: argument 1">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.store"(%712, %247) <{alias_scopes = [#llvm.alias_scope<id = distinct[0]<>, domain = <id = distinct[1]<>, description = "fd_ed25519_point_dbln_secure">, description = "fd_ed25519_point_dbln_secure: argument 0">], alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[2]<>, domain = <id = distinct[1]<>, description = "fd_ed25519_point_dbln_secure">, description = "fd_ed25519_point_dbln_secure: argument 1">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.store"(%729, %252) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[0]<>, domain = <id = distinct[1]<>, description = "fd_ed25519_point_dbln_secure">, description = "fd_ed25519_point_dbln_secure: argument 0">, #llvm.alias_scope<id = distinct[2]<>, domain = <id = distinct[1]<>, description = "fd_ed25519_point_dbln_secure">, description = "fd_ed25519_point_dbln_secure: argument 1">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.store"(%716, %261) <{alias_scopes = [#llvm.alias_scope<id = distinct[0]<>, domain = <id = distinct[1]<>, description = "fd_ed25519_point_dbln_secure">, description = "fd_ed25519_point_dbln_secure: argument 0">], alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[2]<>, domain = <id = distinct[1]<>, description = "fd_ed25519_point_dbln_secure">, description = "fd_ed25519_point_dbln_secure: argument 1">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.store"(%731, %262) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[0]<>, domain = <id = distinct[1]<>, description = "fd_ed25519_point_dbln_secure">, description = "fd_ed25519_point_dbln_secure: argument 0">, #llvm.alias_scope<id = distinct[2]<>, domain = <id = distinct[1]<>, description = "fd_ed25519_point_dbln_secure">, description = "fd_ed25519_point_dbln_secure: argument 1">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.store"(%720, %265) <{alias_scopes = [#llvm.alias_scope<id = distinct[0]<>, domain = <id = distinct[1]<>, description = "fd_ed25519_point_dbln_secure">, description = "fd_ed25519_point_dbln_secure: argument 0">], alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[2]<>, domain = <id = distinct[1]<>, description = "fd_ed25519_point_dbln_secure">, description = "fd_ed25519_point_dbln_secure: argument 1">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.store"(%635, %248) <{alias_scopes = [#llvm.alias_scope<id = distinct[2]<>, domain = <id = distinct[1]<>, description = "fd_ed25519_point_dbln_secure">, description = "fd_ed25519_point_dbln_secure: argument 1">], alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[0]<>, domain = <id = distinct[1]<>, description = "fd_ed25519_point_dbln_secure">, description = "fd_ed25519_point_dbln_secure: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.store"(%636, %350) <{alias_scopes = [#llvm.alias_scope<id = distinct[2]<>, domain = <id = distinct[1]<>, description = "fd_ed25519_point_dbln_secure">, description = "fd_ed25519_point_dbln_secure: argument 1">], alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[0]<>, domain = <id = distinct[1]<>, description = "fd_ed25519_point_dbln_secure">, description = "fd_ed25519_point_dbln_secure: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.store"(%637, %734) <{alias_scopes = [#llvm.alias_scope<id = distinct[2]<>, domain = <id = distinct[1]<>, description = "fd_ed25519_point_dbln_secure">, description = "fd_ed25519_point_dbln_secure: argument 1">], alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[0]<>, domain = <id = distinct[1]<>, description = "fd_ed25519_point_dbln_secure">, description = "fd_ed25519_point_dbln_secure: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.br"(%28)[^bb8] : (i64) -> ()
^bb6(%735: i64):  // 2 preds: ^bb2, ^bb6
  %736 = "llvm.lshr"(%735, %32) : (i64, i64) -> i64
  %737 = "llvm.getelementptr"(%150, %735) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %738 = "llvm.load"(%737) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %739 = "llvm.ashr"(%738, %37) : (i8, i8) -> i8
  %740 = "llvm.lshr"(%738, %37) : (i8, i8) -> i8
  "llvm.store"(%740, %244) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (i8, !llvm.ptr) -> ()
  %741 = "llvm.shl"(%740, %38) <{overflowFlags = 3 : i32}> : (i8, i8) -> i8
  %742 = "llvm.sub"(%38, %741) <{overflowFlags = 1 : i32}> : (i8, i8) -> i8
  %743 = "llvm.mul"(%742, %738) <{overflowFlags = 0 : i32}> : (i8, i8) -> i8
  %744 = "llvm.add"(%743, %39) <{overflowFlags = 0 : i32}> : (i8, i8) -> i8
  "llvm.store"(%744, %152) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (i8, !llvm.ptr) -> ()
  %745 = "llvm.zext"(%744) : (i8) -> i32
  %746 = "llvm.add"(%745, %40) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %747 = "llvm.ashr"(%746, %41) : (i32, i32) -> i32
  %748 = "llvm.trunc"(%747) <{overflowFlags = 1 : i32}> : (i32) -> i8
  %749 = "llvm.getelementptr"(%42, %736) <{elem_type = !llvm.array<1536 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %750 = "llvm.load"(%749) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[3]<>, domain = <id = distinct[4]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %751 = "llvm.bitcast"(%748) : (i8) -> vector<8xi1>
  %752 = "llvm.select"(%751, %750, %43) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %753 = "llvm.getelementptr"(%749) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %754 = "llvm.load"(%753) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[3]<>, domain = <id = distinct[4]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %755 = "llvm.select"(%751, %754, %44) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %756 = "llvm.getelementptr"(%749) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %757 = "llvm.load"(%756) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[3]<>, domain = <id = distinct[4]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %758 = "llvm.select"(%751, %757, %44) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %759 = "llvm.xor"(%744, %38) : (i8, i8) -> i8
  %760 = "llvm.zext"(%759) : (i8) -> i32
  %761 = "llvm.add"(%760, %40) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %762 = "llvm.ashr"(%761, %41) : (i32, i32) -> i32
  %763 = "llvm.trunc"(%762) <{overflowFlags = 1 : i32}> : (i32) -> i8
  %764 = "llvm.getelementptr"(%749) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 192>}> : (!llvm.ptr) -> !llvm.ptr
  %765 = "llvm.load"(%764) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[5]<>, domain = <id = distinct[6]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %766 = "llvm.bitcast"(%763) : (i8) -> vector<8xi1>
  %767 = "llvm.select"(%766, %765, %752) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %768 = "llvm.getelementptr"(%749) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 256>}> : (!llvm.ptr) -> !llvm.ptr
  %769 = "llvm.load"(%768) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[5]<>, domain = <id = distinct[6]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %770 = "llvm.select"(%766, %769, %755) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %771 = "llvm.getelementptr"(%749) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 320>}> : (!llvm.ptr) -> !llvm.ptr
  %772 = "llvm.load"(%771) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[5]<>, domain = <id = distinct[6]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %773 = "llvm.select"(%766, %772, %758) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %774 = "llvm.xor"(%744, %45) : (i8, i8) -> i8
  %775 = "llvm.zext"(%774) : (i8) -> i32
  %776 = "llvm.add"(%775, %40) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %777 = "llvm.ashr"(%776, %41) : (i32, i32) -> i32
  %778 = "llvm.trunc"(%777) <{overflowFlags = 1 : i32}> : (i32) -> i8
  %779 = "llvm.getelementptr"(%749) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 384>}> : (!llvm.ptr) -> !llvm.ptr
  %780 = "llvm.load"(%779) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[7]<>, domain = <id = distinct[8]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %781 = "llvm.bitcast"(%778) : (i8) -> vector<8xi1>
  %782 = "llvm.select"(%781, %780, %767) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %783 = "llvm.getelementptr"(%749) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 448>}> : (!llvm.ptr) -> !llvm.ptr
  %784 = "llvm.load"(%783) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[7]<>, domain = <id = distinct[8]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %785 = "llvm.select"(%781, %784, %770) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %786 = "llvm.getelementptr"(%749) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 512>}> : (!llvm.ptr) -> !llvm.ptr
  %787 = "llvm.load"(%786) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[7]<>, domain = <id = distinct[8]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %788 = "llvm.select"(%781, %787, %773) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %789 = "llvm.xor"(%744, %46) : (i8, i8) -> i8
  %790 = "llvm.zext"(%789) : (i8) -> i32
  %791 = "llvm.add"(%790, %40) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %792 = "llvm.ashr"(%791, %41) : (i32, i32) -> i32
  %793 = "llvm.trunc"(%792) <{overflowFlags = 1 : i32}> : (i32) -> i8
  %794 = "llvm.getelementptr"(%749) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 576>}> : (!llvm.ptr) -> !llvm.ptr
  %795 = "llvm.load"(%794) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[9]<>, domain = <id = distinct[10]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %796 = "llvm.bitcast"(%793) : (i8) -> vector<8xi1>
  %797 = "llvm.select"(%796, %795, %782) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %798 = "llvm.getelementptr"(%749) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 640>}> : (!llvm.ptr) -> !llvm.ptr
  %799 = "llvm.load"(%798) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[9]<>, domain = <id = distinct[10]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %800 = "llvm.select"(%796, %799, %785) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %801 = "llvm.getelementptr"(%749) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 704>}> : (!llvm.ptr) -> !llvm.ptr
  %802 = "llvm.load"(%801) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[9]<>, domain = <id = distinct[10]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %803 = "llvm.select"(%796, %802, %788) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %804 = "llvm.xor"(%744, %31) : (i8, i8) -> i8
  %805 = "llvm.zext"(%804) : (i8) -> i32
  %806 = "llvm.add"(%805, %40) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %807 = "llvm.ashr"(%806, %41) : (i32, i32) -> i32
  %808 = "llvm.trunc"(%807) <{overflowFlags = 1 : i32}> : (i32) -> i8
  %809 = "llvm.getelementptr"(%749) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 768>}> : (!llvm.ptr) -> !llvm.ptr
  %810 = "llvm.load"(%809) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[11]<>, domain = <id = distinct[12]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %811 = "llvm.bitcast"(%808) : (i8) -> vector<8xi1>
  %812 = "llvm.select"(%811, %810, %797) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %813 = "llvm.getelementptr"(%749) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 832>}> : (!llvm.ptr) -> !llvm.ptr
  %814 = "llvm.load"(%813) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[11]<>, domain = <id = distinct[12]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %815 = "llvm.select"(%811, %814, %800) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %816 = "llvm.getelementptr"(%749) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 896>}> : (!llvm.ptr) -> !llvm.ptr
  %817 = "llvm.load"(%816) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[11]<>, domain = <id = distinct[12]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %818 = "llvm.select"(%811, %817, %803) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %819 = "llvm.xor"(%744, %47) : (i8, i8) -> i8
  %820 = "llvm.zext"(%819) : (i8) -> i32
  %821 = "llvm.add"(%820, %40) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %822 = "llvm.ashr"(%821, %41) : (i32, i32) -> i32
  %823 = "llvm.trunc"(%822) <{overflowFlags = 1 : i32}> : (i32) -> i8
  %824 = "llvm.getelementptr"(%749) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 960>}> : (!llvm.ptr) -> !llvm.ptr
  %825 = "llvm.load"(%824) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[13]<>, domain = <id = distinct[14]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %826 = "llvm.bitcast"(%823) : (i8) -> vector<8xi1>
  %827 = "llvm.select"(%826, %825, %812) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %828 = "llvm.getelementptr"(%749) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1024>}> : (!llvm.ptr) -> !llvm.ptr
  %829 = "llvm.load"(%828) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[13]<>, domain = <id = distinct[14]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %830 = "llvm.select"(%826, %829, %815) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %831 = "llvm.getelementptr"(%749) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1088>}> : (!llvm.ptr) -> !llvm.ptr
  %832 = "llvm.load"(%831) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[13]<>, domain = <id = distinct[14]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %833 = "llvm.select"(%826, %832, %818) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %834 = "llvm.xor"(%744, %48) : (i8, i8) -> i8
  %835 = "llvm.zext"(%834) : (i8) -> i32
  %836 = "llvm.add"(%835, %40) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %837 = "llvm.ashr"(%836, %41) : (i32, i32) -> i32
  %838 = "llvm.trunc"(%837) <{overflowFlags = 1 : i32}> : (i32) -> i8
  %839 = "llvm.getelementptr"(%749) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1152>}> : (!llvm.ptr) -> !llvm.ptr
  %840 = "llvm.load"(%839) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[15]<>, domain = <id = distinct[16]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %841 = "llvm.bitcast"(%838) : (i8) -> vector<8xi1>
  %842 = "llvm.select"(%841, %840, %827) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %843 = "llvm.getelementptr"(%749) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1216>}> : (!llvm.ptr) -> !llvm.ptr
  %844 = "llvm.load"(%843) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[15]<>, domain = <id = distinct[16]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %845 = "llvm.select"(%841, %844, %830) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %846 = "llvm.getelementptr"(%749) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1280>}> : (!llvm.ptr) -> !llvm.ptr
  %847 = "llvm.load"(%846) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[15]<>, domain = <id = distinct[16]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %848 = "llvm.select"(%841, %847, %833) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %849 = "llvm.xor"(%744, %37) : (i8, i8) -> i8
  %850 = "llvm.zext"(%849) : (i8) -> i32
  %851 = "llvm.add"(%850, %40) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %852 = "llvm.ashr"(%851, %41) : (i32, i32) -> i32
  %853 = "llvm.trunc"(%852) <{overflowFlags = 1 : i32}> : (i32) -> i8
  %854 = "llvm.getelementptr"(%749) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1344>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.experimental.noalias.scope.decl"() <{scope = #llvm.alias_scope<id = distinct[17]<>, domain = <id = distinct[18]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">}> : () -> ()
  %855 = "llvm.load"(%854) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[17]<>, domain = <id = distinct[18]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %856 = "llvm.bitcast"(%853) : (i8) -> vector<8xi1>
  %857 = "llvm.select"(%856, %855, %842) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%857, %246) <{alias_scopes = [#llvm.alias_scope<id = distinct[17]<>, domain = <id = distinct[18]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">], alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %858 = "llvm.getelementptr"(%749) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1408>}> : (!llvm.ptr) -> !llvm.ptr
  %859 = "llvm.load"(%858) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[17]<>, domain = <id = distinct[18]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %860 = "llvm.select"(%856, %859, %845) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%860, %253) <{alias_scopes = [#llvm.alias_scope<id = distinct[17]<>, domain = <id = distinct[18]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">], alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %861 = "llvm.getelementptr"(%749) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1472>}> : (!llvm.ptr) -> !llvm.ptr
  %862 = "llvm.load"(%861) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[17]<>, domain = <id = distinct[18]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %863 = "llvm.select"(%856, %862, %848) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%863, %255) <{alias_scopes = [#llvm.alias_scope<id = distinct[17]<>, domain = <id = distinct[18]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">], alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %864 = "llvm.sub"(%61, %857) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %865 = "llvm.sub"(%69, %860) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %866 = "llvm.sub"(%77, %863) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %867 = "llvm.shufflevector"(%857, %864) <{mask = array<i32: 1, 0, 2, 11, 5, 4, 6, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %868 = "llvm.shufflevector"(%860, %865) <{mask = array<i32: 1, 0, 2, 11, 5, 4, 6, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %869 = "llvm.shufflevector"(%863, %866) <{mask = array<i32: 1, 0, 2, 11, 5, 4, 6, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %870 = "llvm.bitcast"(%739) : (i8) -> vector<8xi1>
  %871 = "llvm.select"(%870, %867, %857) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%871, %151) <{alias_scopes = [#llvm.alias_scope<id = distinct[19]<>, domain = <id = distinct[20]<>, description = "fd_ed25519_point_neg_if">, description = "fd_ed25519_point_neg_if: argument 0">], alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %872 = "llvm.select"(%870, %868, %860) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%872, %254) <{alias_scopes = [#llvm.alias_scope<id = distinct[19]<>, domain = <id = distinct[20]<>, description = "fd_ed25519_point_neg_if">, description = "fd_ed25519_point_neg_if: argument 0">], alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %873 = "llvm.select"(%870, %869, %863) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%873, %256) <{alias_scopes = [#llvm.alias_scope<id = distinct[19]<>, domain = <id = distinct[20]<>, description = "fd_ed25519_point_neg_if">, description = "fd_ed25519_point_neg_if: argument 0">], alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.call"(%245, %arg0, %151, %247, %248) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_add_secure, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>, zero_call_used_regs = "all"}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  %874 = "llvm.getelementptr"(%737) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 2>}> : (!llvm.ptr) -> !llvm.ptr
  %875 = "llvm.load"(%874) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %876 = "llvm.ashr"(%875, %37) : (i8, i8) -> i8
  %877 = "llvm.lshr"(%875, %37) : (i8, i8) -> i8
  "llvm.store"(%877, %244) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (i8, !llvm.ptr) -> ()
  %878 = "llvm.shl"(%877, %38) <{overflowFlags = 3 : i32}> : (i8, i8) -> i8
  %879 = "llvm.sub"(%38, %878) <{overflowFlags = 1 : i32}> : (i8, i8) -> i8
  %880 = "llvm.mul"(%879, %875) <{overflowFlags = 0 : i32}> : (i8, i8) -> i8
  %881 = "llvm.add"(%880, %39) <{overflowFlags = 0 : i32}> : (i8, i8) -> i8
  "llvm.store"(%881, %152) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (i8, !llvm.ptr) -> ()
  %882 = "llvm.zext"(%881) : (i8) -> i32
  %883 = "llvm.add"(%882, %40) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %884 = "llvm.ashr"(%883, %41) : (i32, i32) -> i32
  %885 = "llvm.trunc"(%884) <{overflowFlags = 1 : i32}> : (i32) -> i8
  %886 = "llvm.getelementptr"(%749) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1536>}> : (!llvm.ptr) -> !llvm.ptr
  %887 = "llvm.load"(%886) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[21]<>, domain = <id = distinct[22]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %888 = "llvm.bitcast"(%885) : (i8) -> vector<8xi1>
  %889 = "llvm.select"(%888, %887, %43) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %890 = "llvm.getelementptr"(%749) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1600>}> : (!llvm.ptr) -> !llvm.ptr
  %891 = "llvm.load"(%890) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[21]<>, domain = <id = distinct[22]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %892 = "llvm.select"(%888, %891, %44) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %893 = "llvm.getelementptr"(%749) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1664>}> : (!llvm.ptr) -> !llvm.ptr
  %894 = "llvm.load"(%893) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[21]<>, domain = <id = distinct[22]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %895 = "llvm.select"(%888, %894, %44) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %896 = "llvm.xor"(%881, %38) : (i8, i8) -> i8
  %897 = "llvm.zext"(%896) : (i8) -> i32
  %898 = "llvm.add"(%897, %40) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %899 = "llvm.ashr"(%898, %41) : (i32, i32) -> i32
  %900 = "llvm.trunc"(%899) <{overflowFlags = 1 : i32}> : (i32) -> i8
  %901 = "llvm.getelementptr"(%749) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1728>}> : (!llvm.ptr) -> !llvm.ptr
  %902 = "llvm.load"(%901) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[23]<>, domain = <id = distinct[24]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %903 = "llvm.bitcast"(%900) : (i8) -> vector<8xi1>
  %904 = "llvm.select"(%903, %902, %889) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %905 = "llvm.getelementptr"(%749) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1792>}> : (!llvm.ptr) -> !llvm.ptr
  %906 = "llvm.load"(%905) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[23]<>, domain = <id = distinct[24]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %907 = "llvm.select"(%903, %906, %892) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %908 = "llvm.getelementptr"(%749) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1856>}> : (!llvm.ptr) -> !llvm.ptr
  %909 = "llvm.load"(%908) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[23]<>, domain = <id = distinct[24]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %910 = "llvm.select"(%903, %909, %895) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %911 = "llvm.xor"(%881, %45) : (i8, i8) -> i8
  %912 = "llvm.zext"(%911) : (i8) -> i32
  %913 = "llvm.add"(%912, %40) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %914 = "llvm.ashr"(%913, %41) : (i32, i32) -> i32
  %915 = "llvm.trunc"(%914) <{overflowFlags = 1 : i32}> : (i32) -> i8
  %916 = "llvm.getelementptr"(%749) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1920>}> : (!llvm.ptr) -> !llvm.ptr
  %917 = "llvm.load"(%916) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[25]<>, domain = <id = distinct[26]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %918 = "llvm.bitcast"(%915) : (i8) -> vector<8xi1>
  %919 = "llvm.select"(%918, %917, %904) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %920 = "llvm.getelementptr"(%749) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1984>}> : (!llvm.ptr) -> !llvm.ptr
  %921 = "llvm.load"(%920) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[25]<>, domain = <id = distinct[26]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %922 = "llvm.select"(%918, %921, %907) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %923 = "llvm.getelementptr"(%749) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 2048>}> : (!llvm.ptr) -> !llvm.ptr
  %924 = "llvm.load"(%923) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[25]<>, domain = <id = distinct[26]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %925 = "llvm.select"(%918, %924, %910) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %926 = "llvm.xor"(%881, %46) : (i8, i8) -> i8
  %927 = "llvm.zext"(%926) : (i8) -> i32
  %928 = "llvm.add"(%927, %40) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %929 = "llvm.ashr"(%928, %41) : (i32, i32) -> i32
  %930 = "llvm.trunc"(%929) <{overflowFlags = 1 : i32}> : (i32) -> i8
  %931 = "llvm.getelementptr"(%749) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 2112>}> : (!llvm.ptr) -> !llvm.ptr
  %932 = "llvm.load"(%931) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[27]<>, domain = <id = distinct[28]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %933 = "llvm.bitcast"(%930) : (i8) -> vector<8xi1>
  %934 = "llvm.select"(%933, %932, %919) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %935 = "llvm.getelementptr"(%749) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 2176>}> : (!llvm.ptr) -> !llvm.ptr
  %936 = "llvm.load"(%935) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[27]<>, domain = <id = distinct[28]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %937 = "llvm.select"(%933, %936, %922) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %938 = "llvm.getelementptr"(%749) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 2240>}> : (!llvm.ptr) -> !llvm.ptr
  %939 = "llvm.load"(%938) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[27]<>, domain = <id = distinct[28]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %940 = "llvm.select"(%933, %939, %925) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %941 = "llvm.xor"(%881, %31) : (i8, i8) -> i8
  %942 = "llvm.zext"(%941) : (i8) -> i32
  %943 = "llvm.add"(%942, %40) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %944 = "llvm.ashr"(%943, %41) : (i32, i32) -> i32
  %945 = "llvm.trunc"(%944) <{overflowFlags = 1 : i32}> : (i32) -> i8
  %946 = "llvm.getelementptr"(%749) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 2304>}> : (!llvm.ptr) -> !llvm.ptr
  %947 = "llvm.load"(%946) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[29]<>, domain = <id = distinct[30]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %948 = "llvm.bitcast"(%945) : (i8) -> vector<8xi1>
  %949 = "llvm.select"(%948, %947, %934) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %950 = "llvm.getelementptr"(%749) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 2368>}> : (!llvm.ptr) -> !llvm.ptr
  %951 = "llvm.load"(%950) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[29]<>, domain = <id = distinct[30]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %952 = "llvm.select"(%948, %951, %937) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %953 = "llvm.getelementptr"(%749) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 2432>}> : (!llvm.ptr) -> !llvm.ptr
  %954 = "llvm.load"(%953) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[29]<>, domain = <id = distinct[30]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %955 = "llvm.select"(%948, %954, %940) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %956 = "llvm.xor"(%881, %47) : (i8, i8) -> i8
  %957 = "llvm.zext"(%956) : (i8) -> i32
  %958 = "llvm.add"(%957, %40) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %959 = "llvm.ashr"(%958, %41) : (i32, i32) -> i32
  %960 = "llvm.trunc"(%959) <{overflowFlags = 1 : i32}> : (i32) -> i8
  %961 = "llvm.getelementptr"(%749) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 2496>}> : (!llvm.ptr) -> !llvm.ptr
  %962 = "llvm.load"(%961) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[31]<>, domain = <id = distinct[32]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %963 = "llvm.bitcast"(%960) : (i8) -> vector<8xi1>
  %964 = "llvm.select"(%963, %962, %949) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %965 = "llvm.getelementptr"(%749) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 2560>}> : (!llvm.ptr) -> !llvm.ptr
  %966 = "llvm.load"(%965) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[31]<>, domain = <id = distinct[32]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %967 = "llvm.select"(%963, %966, %952) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %968 = "llvm.getelementptr"(%749) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 2624>}> : (!llvm.ptr) -> !llvm.ptr
  %969 = "llvm.load"(%968) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[31]<>, domain = <id = distinct[32]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %970 = "llvm.select"(%963, %969, %955) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %971 = "llvm.xor"(%881, %48) : (i8, i8) -> i8
  %972 = "llvm.zext"(%971) : (i8) -> i32
  %973 = "llvm.add"(%972, %40) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %974 = "llvm.ashr"(%973, %41) : (i32, i32) -> i32
  %975 = "llvm.trunc"(%974) <{overflowFlags = 1 : i32}> : (i32) -> i8
  %976 = "llvm.getelementptr"(%749) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 2688>}> : (!llvm.ptr) -> !llvm.ptr
  %977 = "llvm.load"(%976) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[33]<>, domain = <id = distinct[34]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %978 = "llvm.bitcast"(%975) : (i8) -> vector<8xi1>
  %979 = "llvm.select"(%978, %977, %964) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %980 = "llvm.getelementptr"(%749) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 2752>}> : (!llvm.ptr) -> !llvm.ptr
  %981 = "llvm.load"(%980) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[33]<>, domain = <id = distinct[34]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %982 = "llvm.select"(%978, %981, %967) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %983 = "llvm.getelementptr"(%749) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 2816>}> : (!llvm.ptr) -> !llvm.ptr
  %984 = "llvm.load"(%983) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[33]<>, domain = <id = distinct[34]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %985 = "llvm.select"(%978, %984, %970) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %986 = "llvm.xor"(%881, %37) : (i8, i8) -> i8
  %987 = "llvm.zext"(%986) : (i8) -> i32
  %988 = "llvm.add"(%987, %40) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %989 = "llvm.ashr"(%988, %41) : (i32, i32) -> i32
  %990 = "llvm.trunc"(%989) <{overflowFlags = 1 : i32}> : (i32) -> i8
  %991 = "llvm.getelementptr"(%749) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 2880>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.experimental.noalias.scope.decl"() <{scope = #llvm.alias_scope<id = distinct[35]<>, domain = <id = distinct[36]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">}> : () -> ()
  %992 = "llvm.load"(%991) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[35]<>, domain = <id = distinct[36]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %993 = "llvm.bitcast"(%990) : (i8) -> vector<8xi1>
  %994 = "llvm.select"(%993, %992, %979) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%994, %151) <{alias_scopes = [#llvm.alias_scope<id = distinct[35]<>, domain = <id = distinct[36]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">], alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %995 = "llvm.getelementptr"(%749) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 2944>}> : (!llvm.ptr) -> !llvm.ptr
  %996 = "llvm.load"(%995) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[35]<>, domain = <id = distinct[36]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %997 = "llvm.select"(%993, %996, %982) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%997, %254) <{alias_scopes = [#llvm.alias_scope<id = distinct[35]<>, domain = <id = distinct[36]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">], alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %998 = "llvm.getelementptr"(%749) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 3008>}> : (!llvm.ptr) -> !llvm.ptr
  %999 = "llvm.load"(%998) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[35]<>, domain = <id = distinct[36]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %1000 = "llvm.select"(%993, %999, %985) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%1000, %256) <{alias_scopes = [#llvm.alias_scope<id = distinct[35]<>, domain = <id = distinct[36]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">], alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %1001 = "llvm.sub"(%61, %994) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1002 = "llvm.sub"(%69, %997) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1003 = "llvm.sub"(%77, %1000) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1004 = "llvm.shufflevector"(%994, %1001) <{mask = array<i32: 1, 0, 2, 11, 5, 4, 6, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1005 = "llvm.shufflevector"(%997, %1002) <{mask = array<i32: 1, 0, 2, 11, 5, 4, 6, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1006 = "llvm.shufflevector"(%1000, %1003) <{mask = array<i32: 1, 0, 2, 11, 5, 4, 6, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1007 = "llvm.bitcast"(%876) : (i8) -> vector<8xi1>
  %1008 = "llvm.select"(%1007, %1004, %994) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%1008, %246) <{alias_scopes = [#llvm.alias_scope<id = distinct[37]<>, domain = <id = distinct[38]<>, description = "fd_ed25519_point_neg_if">, description = "fd_ed25519_point_neg_if: argument 0">], alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %1009 = "llvm.select"(%1007, %1005, %997) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%1009, %253) <{alias_scopes = [#llvm.alias_scope<id = distinct[37]<>, domain = <id = distinct[38]<>, description = "fd_ed25519_point_neg_if">, description = "fd_ed25519_point_neg_if: argument 0">], alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %1010 = "llvm.select"(%1007, %1006, %1000) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%1010, %255) <{alias_scopes = [#llvm.alias_scope<id = distinct[37]<>, domain = <id = distinct[38]<>, description = "fd_ed25519_point_neg_if">, description = "fd_ed25519_point_neg_if: argument 0">], alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.call"(%arg0, %245, %246, %247, %248) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_add_secure, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>, zero_call_used_regs = "all"}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  %1011 = "llvm.add"(%735, %33) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1012 = "llvm.icmp"(%735, %15) <{predicate = 6 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1012, %1011)[^bb6, ^bb3] <{loop_annotation = #llvm.loop_annotation<mustProgress = true>, operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i64) -> ()
^bb7:  // pred: ^bb8
  %1013 = "llvm.inline_asm"() <{asm_dialect = 0 : i64, asm_string = "", constraints = "~{memory},~{dirflag},~{fpsr},~{flags}", has_side_effects, tail_call_kind = #llvm.tailcallkind<tail>}> : () -> !llvm.void
  %1014 = "llvm.inline_asm"() <{asm_dialect = 0 : i64, asm_string = "", constraints = "~{memory},~{dirflag},~{fpsr},~{flags}", has_side_effects, tail_call_kind = #llvm.tailcallkind<tail>}> : () -> !llvm.void
  "llvm.intr.lifetime.end"(%151) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%150) : (!llvm.ptr) -> ()
  "llvm.return"(%arg0) : (!llvm.ptr) -> ()
^bb8(%1015: i64):  // 2 preds: ^bb5, ^bb8
  %1016 = "llvm.lshr"(%1015, %32) <{isExact}> : (i64, i64) -> i64
  %1017 = "llvm.getelementptr"(%150, %1015) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %1018 = "llvm.load"(%1017) <{alignment = 4 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %1019 = "llvm.ashr"(%1018, %37) : (i8, i8) -> i8
  %1020 = "llvm.lshr"(%1018, %48) : (i8, i8) -> i8
  %1021 = "llvm.and"(%1020, %45) : (i8, i8) -> i8
  %1022 = "llvm.sub"(%38, %1021) <{overflowFlags = 1 : i32}> : (i8, i8) -> i8
  %1023 = "llvm.mul"(%1022, %1018) <{overflowFlags = 0 : i32}> : (i8, i8) -> i8
  %1024 = "llvm.add"(%1023, %39) <{overflowFlags = 0 : i32}> : (i8, i8) -> i8
  %1025 = "llvm.zext"(%1024) : (i8) -> i32
  %1026 = "llvm.add"(%1025, %40) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %1027 = "llvm.ashr"(%1026, %41) : (i32, i32) -> i32
  %1028 = "llvm.trunc"(%1027) <{overflowFlags = 1 : i32}> : (i32) -> i8
  %1029 = "llvm.getelementptr"(%42, %1016) <{elem_type = !llvm.array<1536 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %1030 = "llvm.load"(%1029) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[39]<>, domain = <id = distinct[40]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %1031 = "llvm.bitcast"(%1028) : (i8) -> vector<8xi1>
  %1032 = "llvm.select"(%1031, %1030, %43) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1033 = "llvm.getelementptr"(%1029) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %1034 = "llvm.load"(%1033) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[39]<>, domain = <id = distinct[40]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %1035 = "llvm.select"(%1031, %1034, %44) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1036 = "llvm.getelementptr"(%1029) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %1037 = "llvm.load"(%1036) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[39]<>, domain = <id = distinct[40]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %1038 = "llvm.select"(%1031, %1037, %44) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1039 = "llvm.xor"(%1024, %38) : (i8, i8) -> i8
  %1040 = "llvm.zext"(%1039) : (i8) -> i32
  %1041 = "llvm.add"(%1040, %40) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %1042 = "llvm.ashr"(%1041, %41) : (i32, i32) -> i32
  %1043 = "llvm.trunc"(%1042) <{overflowFlags = 1 : i32}> : (i32) -> i8
  %1044 = "llvm.getelementptr"(%1029) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 192>}> : (!llvm.ptr) -> !llvm.ptr
  %1045 = "llvm.load"(%1044) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[41]<>, domain = <id = distinct[42]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %1046 = "llvm.bitcast"(%1043) : (i8) -> vector<8xi1>
  %1047 = "llvm.select"(%1046, %1045, %1032) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1048 = "llvm.getelementptr"(%1029) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 256>}> : (!llvm.ptr) -> !llvm.ptr
  %1049 = "llvm.load"(%1048) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[41]<>, domain = <id = distinct[42]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %1050 = "llvm.select"(%1046, %1049, %1035) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1051 = "llvm.getelementptr"(%1029) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 320>}> : (!llvm.ptr) -> !llvm.ptr
  %1052 = "llvm.load"(%1051) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[41]<>, domain = <id = distinct[42]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %1053 = "llvm.select"(%1046, %1052, %1038) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1054 = "llvm.xor"(%1024, %45) : (i8, i8) -> i8
  %1055 = "llvm.zext"(%1054) : (i8) -> i32
  %1056 = "llvm.add"(%1055, %40) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %1057 = "llvm.ashr"(%1056, %41) : (i32, i32) -> i32
  %1058 = "llvm.trunc"(%1057) <{overflowFlags = 1 : i32}> : (i32) -> i8
  %1059 = "llvm.getelementptr"(%1029) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 384>}> : (!llvm.ptr) -> !llvm.ptr
  %1060 = "llvm.load"(%1059) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[43]<>, domain = <id = distinct[44]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %1061 = "llvm.bitcast"(%1058) : (i8) -> vector<8xi1>
  %1062 = "llvm.select"(%1061, %1060, %1047) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1063 = "llvm.getelementptr"(%1029) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 448>}> : (!llvm.ptr) -> !llvm.ptr
  %1064 = "llvm.load"(%1063) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[43]<>, domain = <id = distinct[44]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %1065 = "llvm.select"(%1061, %1064, %1050) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1066 = "llvm.getelementptr"(%1029) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 512>}> : (!llvm.ptr) -> !llvm.ptr
  %1067 = "llvm.load"(%1066) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[43]<>, domain = <id = distinct[44]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %1068 = "llvm.select"(%1061, %1067, %1053) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1069 = "llvm.xor"(%1024, %46) : (i8, i8) -> i8
  %1070 = "llvm.zext"(%1069) : (i8) -> i32
  %1071 = "llvm.add"(%1070, %40) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %1072 = "llvm.ashr"(%1071, %41) : (i32, i32) -> i32
  %1073 = "llvm.trunc"(%1072) <{overflowFlags = 1 : i32}> : (i32) -> i8
  %1074 = "llvm.getelementptr"(%1029) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 576>}> : (!llvm.ptr) -> !llvm.ptr
  %1075 = "llvm.load"(%1074) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[45]<>, domain = <id = distinct[46]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %1076 = "llvm.bitcast"(%1073) : (i8) -> vector<8xi1>
  %1077 = "llvm.select"(%1076, %1075, %1062) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1078 = "llvm.getelementptr"(%1029) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 640>}> : (!llvm.ptr) -> !llvm.ptr
  %1079 = "llvm.load"(%1078) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[45]<>, domain = <id = distinct[46]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %1080 = "llvm.select"(%1076, %1079, %1065) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1081 = "llvm.getelementptr"(%1029) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 704>}> : (!llvm.ptr) -> !llvm.ptr
  %1082 = "llvm.load"(%1081) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[45]<>, domain = <id = distinct[46]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %1083 = "llvm.select"(%1076, %1082, %1068) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1084 = "llvm.xor"(%1024, %31) : (i8, i8) -> i8
  %1085 = "llvm.zext"(%1084) : (i8) -> i32
  %1086 = "llvm.add"(%1085, %40) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %1087 = "llvm.ashr"(%1086, %41) : (i32, i32) -> i32
  %1088 = "llvm.trunc"(%1087) <{overflowFlags = 1 : i32}> : (i32) -> i8
  %1089 = "llvm.getelementptr"(%1029) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 768>}> : (!llvm.ptr) -> !llvm.ptr
  %1090 = "llvm.load"(%1089) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[47]<>, domain = <id = distinct[48]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %1091 = "llvm.bitcast"(%1088) : (i8) -> vector<8xi1>
  %1092 = "llvm.select"(%1091, %1090, %1077) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1093 = "llvm.getelementptr"(%1029) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 832>}> : (!llvm.ptr) -> !llvm.ptr
  %1094 = "llvm.load"(%1093) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[47]<>, domain = <id = distinct[48]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %1095 = "llvm.select"(%1091, %1094, %1080) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1096 = "llvm.getelementptr"(%1029) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 896>}> : (!llvm.ptr) -> !llvm.ptr
  %1097 = "llvm.load"(%1096) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[47]<>, domain = <id = distinct[48]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %1098 = "llvm.select"(%1091, %1097, %1083) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1099 = "llvm.xor"(%1024, %47) : (i8, i8) -> i8
  %1100 = "llvm.zext"(%1099) : (i8) -> i32
  %1101 = "llvm.add"(%1100, %40) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %1102 = "llvm.ashr"(%1101, %41) : (i32, i32) -> i32
  %1103 = "llvm.trunc"(%1102) <{overflowFlags = 1 : i32}> : (i32) -> i8
  %1104 = "llvm.getelementptr"(%1029) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 960>}> : (!llvm.ptr) -> !llvm.ptr
  %1105 = "llvm.load"(%1104) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[49]<>, domain = <id = distinct[50]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %1106 = "llvm.bitcast"(%1103) : (i8) -> vector<8xi1>
  %1107 = "llvm.select"(%1106, %1105, %1092) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1108 = "llvm.getelementptr"(%1029) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1024>}> : (!llvm.ptr) -> !llvm.ptr
  %1109 = "llvm.load"(%1108) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[49]<>, domain = <id = distinct[50]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %1110 = "llvm.select"(%1106, %1109, %1095) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1111 = "llvm.getelementptr"(%1029) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1088>}> : (!llvm.ptr) -> !llvm.ptr
  %1112 = "llvm.load"(%1111) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[49]<>, domain = <id = distinct[50]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %1113 = "llvm.select"(%1106, %1112, %1098) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1114 = "llvm.xor"(%1024, %48) : (i8, i8) -> i8
  %1115 = "llvm.zext"(%1114) : (i8) -> i32
  %1116 = "llvm.add"(%1115, %40) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %1117 = "llvm.ashr"(%1116, %41) : (i32, i32) -> i32
  %1118 = "llvm.trunc"(%1117) <{overflowFlags = 1 : i32}> : (i32) -> i8
  %1119 = "llvm.getelementptr"(%1029) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1152>}> : (!llvm.ptr) -> !llvm.ptr
  %1120 = "llvm.load"(%1119) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[51]<>, domain = <id = distinct[52]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %1121 = "llvm.bitcast"(%1118) : (i8) -> vector<8xi1>
  %1122 = "llvm.select"(%1121, %1120, %1107) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1123 = "llvm.getelementptr"(%1029) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1216>}> : (!llvm.ptr) -> !llvm.ptr
  %1124 = "llvm.load"(%1123) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[51]<>, domain = <id = distinct[52]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %1125 = "llvm.select"(%1121, %1124, %1110) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1126 = "llvm.getelementptr"(%1029) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1280>}> : (!llvm.ptr) -> !llvm.ptr
  %1127 = "llvm.load"(%1126) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[51]<>, domain = <id = distinct[52]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %1128 = "llvm.select"(%1121, %1127, %1113) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1129 = "llvm.xor"(%1024, %37) : (i8, i8) -> i8
  %1130 = "llvm.zext"(%1129) : (i8) -> i32
  %1131 = "llvm.add"(%1130, %40) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %1132 = "llvm.ashr"(%1131, %41) : (i32, i32) -> i32
  %1133 = "llvm.trunc"(%1132) <{overflowFlags = 1 : i32}> : (i32) -> i8
  %1134 = "llvm.getelementptr"(%1029) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1344>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.experimental.noalias.scope.decl"() <{scope = #llvm.alias_scope<id = distinct[53]<>, domain = <id = distinct[54]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">}> : () -> ()
  %1135 = "llvm.load"(%1134) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[53]<>, domain = <id = distinct[54]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %1136 = "llvm.bitcast"(%1133) : (i8) -> vector<8xi1>
  %1137 = "llvm.select"(%1136, %1135, %1122) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%1137, %246) <{alias_scopes = [#llvm.alias_scope<id = distinct[53]<>, domain = <id = distinct[54]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">], alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %1138 = "llvm.getelementptr"(%1029) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1408>}> : (!llvm.ptr) -> !llvm.ptr
  %1139 = "llvm.load"(%1138) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[53]<>, domain = <id = distinct[54]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %1140 = "llvm.select"(%1136, %1139, %1125) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%1140, %253) <{alias_scopes = [#llvm.alias_scope<id = distinct[53]<>, domain = <id = distinct[54]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">], alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %1141 = "llvm.getelementptr"(%1029) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1472>}> : (!llvm.ptr) -> !llvm.ptr
  %1142 = "llvm.load"(%1141) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[53]<>, domain = <id = distinct[54]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %1143 = "llvm.select"(%1136, %1142, %1128) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%1143, %255) <{alias_scopes = [#llvm.alias_scope<id = distinct[53]<>, domain = <id = distinct[54]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">], alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %1144 = "llvm.sub"(%61, %1137) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1145 = "llvm.sub"(%69, %1140) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1146 = "llvm.sub"(%77, %1143) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1147 = "llvm.shufflevector"(%1137, %1144) <{mask = array<i32: 1, 0, 2, 11, 5, 4, 6, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1148 = "llvm.shufflevector"(%1140, %1145) <{mask = array<i32: 1, 0, 2, 11, 5, 4, 6, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1149 = "llvm.shufflevector"(%1143, %1146) <{mask = array<i32: 1, 0, 2, 11, 5, 4, 6, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1150 = "llvm.bitcast"(%1019) : (i8) -> vector<8xi1>
  %1151 = "llvm.select"(%1150, %1147, %1137) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%1151, %151) <{alias_scopes = [#llvm.alias_scope<id = distinct[55]<>, domain = <id = distinct[56]<>, description = "fd_ed25519_point_neg_if">, description = "fd_ed25519_point_neg_if: argument 0">], alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %1152 = "llvm.select"(%1150, %1148, %1140) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%1152, %254) <{alias_scopes = [#llvm.alias_scope<id = distinct[55]<>, domain = <id = distinct[56]<>, description = "fd_ed25519_point_neg_if">, description = "fd_ed25519_point_neg_if: argument 0">], alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %1153 = "llvm.select"(%1150, %1149, %1143) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%1153, %256) <{alias_scopes = [#llvm.alias_scope<id = distinct[55]<>, domain = <id = distinct[56]<>, description = "fd_ed25519_point_neg_if">, description = "fd_ed25519_point_neg_if: argument 0">], alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.call"(%245, %arg0, %151, %247, %248) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_add_secure, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>, zero_call_used_regs = "all"}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  %1154 = "llvm.getelementptr"(%1017) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 2>}> : (!llvm.ptr) -> !llvm.ptr
  %1155 = "llvm.load"(%1154) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %1156 = "llvm.ashr"(%1155, %37) : (i8, i8) -> i8
  %1157 = "llvm.lshr"(%1155, %48) : (i8, i8) -> i8
  %1158 = "llvm.and"(%1157, %45) : (i8, i8) -> i8
  %1159 = "llvm.sub"(%38, %1158) <{overflowFlags = 1 : i32}> : (i8, i8) -> i8
  %1160 = "llvm.mul"(%1159, %1155) <{overflowFlags = 0 : i32}> : (i8, i8) -> i8
  %1161 = "llvm.add"(%1160, %39) <{overflowFlags = 0 : i32}> : (i8, i8) -> i8
  "llvm.store"(%1161, %152) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (i8, !llvm.ptr) -> ()
  %1162 = "llvm.zext"(%1161) : (i8) -> i32
  %1163 = "llvm.add"(%1162, %40) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %1164 = "llvm.ashr"(%1163, %41) : (i32, i32) -> i32
  %1165 = "llvm.trunc"(%1164) <{overflowFlags = 1 : i32}> : (i32) -> i8
  %1166 = "llvm.getelementptr"(%1029) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1536>}> : (!llvm.ptr) -> !llvm.ptr
  %1167 = "llvm.load"(%1166) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[57]<>, domain = <id = distinct[58]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %1168 = "llvm.bitcast"(%1165) : (i8) -> vector<8xi1>
  %1169 = "llvm.select"(%1168, %1167, %43) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1170 = "llvm.getelementptr"(%1029) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1600>}> : (!llvm.ptr) -> !llvm.ptr
  %1171 = "llvm.load"(%1170) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[57]<>, domain = <id = distinct[58]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %1172 = "llvm.select"(%1168, %1171, %44) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1173 = "llvm.getelementptr"(%1029) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1664>}> : (!llvm.ptr) -> !llvm.ptr
  %1174 = "llvm.load"(%1173) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[57]<>, domain = <id = distinct[58]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %1175 = "llvm.select"(%1168, %1174, %44) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1176 = "llvm.xor"(%1161, %38) : (i8, i8) -> i8
  %1177 = "llvm.zext"(%1176) : (i8) -> i32
  %1178 = "llvm.add"(%1177, %40) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %1179 = "llvm.ashr"(%1178, %41) : (i32, i32) -> i32
  %1180 = "llvm.trunc"(%1179) <{overflowFlags = 1 : i32}> : (i32) -> i8
  %1181 = "llvm.getelementptr"(%1029) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1728>}> : (!llvm.ptr) -> !llvm.ptr
  %1182 = "llvm.load"(%1181) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[59]<>, domain = <id = distinct[60]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %1183 = "llvm.bitcast"(%1180) : (i8) -> vector<8xi1>
  %1184 = "llvm.select"(%1183, %1182, %1169) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1185 = "llvm.getelementptr"(%1029) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1792>}> : (!llvm.ptr) -> !llvm.ptr
  %1186 = "llvm.load"(%1185) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[59]<>, domain = <id = distinct[60]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %1187 = "llvm.select"(%1183, %1186, %1172) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1188 = "llvm.getelementptr"(%1029) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1856>}> : (!llvm.ptr) -> !llvm.ptr
  %1189 = "llvm.load"(%1188) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[59]<>, domain = <id = distinct[60]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %1190 = "llvm.select"(%1183, %1189, %1175) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1191 = "llvm.xor"(%1161, %45) : (i8, i8) -> i8
  %1192 = "llvm.zext"(%1191) : (i8) -> i32
  %1193 = "llvm.add"(%1192, %40) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %1194 = "llvm.ashr"(%1193, %41) : (i32, i32) -> i32
  %1195 = "llvm.trunc"(%1194) <{overflowFlags = 1 : i32}> : (i32) -> i8
  %1196 = "llvm.getelementptr"(%1029) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1920>}> : (!llvm.ptr) -> !llvm.ptr
  %1197 = "llvm.load"(%1196) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[61]<>, domain = <id = distinct[62]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %1198 = "llvm.bitcast"(%1195) : (i8) -> vector<8xi1>
  %1199 = "llvm.select"(%1198, %1197, %1184) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1200 = "llvm.getelementptr"(%1029) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1984>}> : (!llvm.ptr) -> !llvm.ptr
  %1201 = "llvm.load"(%1200) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[61]<>, domain = <id = distinct[62]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %1202 = "llvm.select"(%1198, %1201, %1187) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1203 = "llvm.getelementptr"(%1029) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 2048>}> : (!llvm.ptr) -> !llvm.ptr
  %1204 = "llvm.load"(%1203) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[61]<>, domain = <id = distinct[62]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %1205 = "llvm.select"(%1198, %1204, %1190) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1206 = "llvm.xor"(%1161, %46) : (i8, i8) -> i8
  %1207 = "llvm.zext"(%1206) : (i8) -> i32
  %1208 = "llvm.add"(%1207, %40) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %1209 = "llvm.ashr"(%1208, %41) : (i32, i32) -> i32
  %1210 = "llvm.trunc"(%1209) <{overflowFlags = 1 : i32}> : (i32) -> i8
  %1211 = "llvm.getelementptr"(%1029) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 2112>}> : (!llvm.ptr) -> !llvm.ptr
  %1212 = "llvm.load"(%1211) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[63]<>, domain = <id = distinct[64]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %1213 = "llvm.bitcast"(%1210) : (i8) -> vector<8xi1>
  %1214 = "llvm.select"(%1213, %1212, %1199) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1215 = "llvm.getelementptr"(%1029) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 2176>}> : (!llvm.ptr) -> !llvm.ptr
  %1216 = "llvm.load"(%1215) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[63]<>, domain = <id = distinct[64]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %1217 = "llvm.select"(%1213, %1216, %1202) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1218 = "llvm.getelementptr"(%1029) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 2240>}> : (!llvm.ptr) -> !llvm.ptr
  %1219 = "llvm.load"(%1218) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[63]<>, domain = <id = distinct[64]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %1220 = "llvm.select"(%1213, %1219, %1205) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1221 = "llvm.xor"(%1161, %31) : (i8, i8) -> i8
  %1222 = "llvm.zext"(%1221) : (i8) -> i32
  %1223 = "llvm.add"(%1222, %40) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %1224 = "llvm.ashr"(%1223, %41) : (i32, i32) -> i32
  %1225 = "llvm.trunc"(%1224) <{overflowFlags = 1 : i32}> : (i32) -> i8
  %1226 = "llvm.getelementptr"(%1029) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 2304>}> : (!llvm.ptr) -> !llvm.ptr
  %1227 = "llvm.load"(%1226) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[65]<>, domain = <id = distinct[66]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %1228 = "llvm.bitcast"(%1225) : (i8) -> vector<8xi1>
  %1229 = "llvm.select"(%1228, %1227, %1214) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1230 = "llvm.getelementptr"(%1029) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 2368>}> : (!llvm.ptr) -> !llvm.ptr
  %1231 = "llvm.load"(%1230) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[65]<>, domain = <id = distinct[66]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %1232 = "llvm.select"(%1228, %1231, %1217) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1233 = "llvm.getelementptr"(%1029) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 2432>}> : (!llvm.ptr) -> !llvm.ptr
  %1234 = "llvm.load"(%1233) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[65]<>, domain = <id = distinct[66]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %1235 = "llvm.select"(%1228, %1234, %1220) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1236 = "llvm.xor"(%1161, %47) : (i8, i8) -> i8
  %1237 = "llvm.zext"(%1236) : (i8) -> i32
  %1238 = "llvm.add"(%1237, %40) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %1239 = "llvm.ashr"(%1238, %41) : (i32, i32) -> i32
  %1240 = "llvm.trunc"(%1239) <{overflowFlags = 1 : i32}> : (i32) -> i8
  %1241 = "llvm.getelementptr"(%1029) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 2496>}> : (!llvm.ptr) -> !llvm.ptr
  %1242 = "llvm.load"(%1241) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[67]<>, domain = <id = distinct[68]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %1243 = "llvm.bitcast"(%1240) : (i8) -> vector<8xi1>
  %1244 = "llvm.select"(%1243, %1242, %1229) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1245 = "llvm.getelementptr"(%1029) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 2560>}> : (!llvm.ptr) -> !llvm.ptr
  %1246 = "llvm.load"(%1245) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[67]<>, domain = <id = distinct[68]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %1247 = "llvm.select"(%1243, %1246, %1232) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1248 = "llvm.getelementptr"(%1029) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 2624>}> : (!llvm.ptr) -> !llvm.ptr
  %1249 = "llvm.load"(%1248) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[67]<>, domain = <id = distinct[68]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %1250 = "llvm.select"(%1243, %1249, %1235) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1251 = "llvm.xor"(%1161, %48) : (i8, i8) -> i8
  %1252 = "llvm.zext"(%1251) : (i8) -> i32
  %1253 = "llvm.add"(%1252, %40) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %1254 = "llvm.ashr"(%1253, %41) : (i32, i32) -> i32
  %1255 = "llvm.trunc"(%1254) <{overflowFlags = 1 : i32}> : (i32) -> i8
  %1256 = "llvm.getelementptr"(%1029) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 2688>}> : (!llvm.ptr) -> !llvm.ptr
  %1257 = "llvm.load"(%1256) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[69]<>, domain = <id = distinct[70]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %1258 = "llvm.bitcast"(%1255) : (i8) -> vector<8xi1>
  %1259 = "llvm.select"(%1258, %1257, %1244) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1260 = "llvm.getelementptr"(%1029) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 2752>}> : (!llvm.ptr) -> !llvm.ptr
  %1261 = "llvm.load"(%1260) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[69]<>, domain = <id = distinct[70]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %1262 = "llvm.select"(%1258, %1261, %1247) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1263 = "llvm.getelementptr"(%1029) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 2816>}> : (!llvm.ptr) -> !llvm.ptr
  %1264 = "llvm.load"(%1263) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[69]<>, domain = <id = distinct[70]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %1265 = "llvm.select"(%1258, %1264, %1250) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1266 = "llvm.xor"(%1161, %37) : (i8, i8) -> i8
  %1267 = "llvm.zext"(%1266) : (i8) -> i32
  %1268 = "llvm.add"(%1267, %40) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %1269 = "llvm.ashr"(%1268, %41) : (i32, i32) -> i32
  %1270 = "llvm.trunc"(%1269) <{overflowFlags = 1 : i32}> : (i32) -> i8
  %1271 = "llvm.getelementptr"(%1029) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 2880>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.experimental.noalias.scope.decl"() <{scope = #llvm.alias_scope<id = distinct[71]<>, domain = <id = distinct[72]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">}> : () -> ()
  %1272 = "llvm.load"(%1271) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[71]<>, domain = <id = distinct[72]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %1273 = "llvm.bitcast"(%1270) : (i8) -> vector<8xi1>
  %1274 = "llvm.select"(%1273, %1272, %1259) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%1274, %151) <{alias_scopes = [#llvm.alias_scope<id = distinct[71]<>, domain = <id = distinct[72]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">], alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %1275 = "llvm.getelementptr"(%1029) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 2944>}> : (!llvm.ptr) -> !llvm.ptr
  %1276 = "llvm.load"(%1275) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[71]<>, domain = <id = distinct[72]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %1277 = "llvm.select"(%1273, %1276, %1262) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%1277, %254) <{alias_scopes = [#llvm.alias_scope<id = distinct[71]<>, domain = <id = distinct[72]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">], alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %1278 = "llvm.getelementptr"(%1029) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 3008>}> : (!llvm.ptr) -> !llvm.ptr
  %1279 = "llvm.load"(%1278) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[71]<>, domain = <id = distinct[72]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %1280 = "llvm.select"(%1273, %1279, %1265) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%1280, %256) <{alias_scopes = [#llvm.alias_scope<id = distinct[71]<>, domain = <id = distinct[72]<>, description = "fd_ed25519_point_if">, description = "fd_ed25519_point_if: argument 0">], alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %1281 = "llvm.sub"(%61, %1274) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1282 = "llvm.sub"(%69, %1277) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1283 = "llvm.sub"(%77, %1280) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1284 = "llvm.shufflevector"(%1274, %1281) <{mask = array<i32: 1, 0, 2, 11, 5, 4, 6, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1285 = "llvm.shufflevector"(%1277, %1282) <{mask = array<i32: 1, 0, 2, 11, 5, 4, 6, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1286 = "llvm.shufflevector"(%1280, %1283) <{mask = array<i32: 1, 0, 2, 11, 5, 4, 6, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1287 = "llvm.bitcast"(%1156) : (i8) -> vector<8xi1>
  %1288 = "llvm.select"(%1287, %1284, %1274) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%1288, %246) <{alias_scopes = [#llvm.alias_scope<id = distinct[73]<>, domain = <id = distinct[74]<>, description = "fd_ed25519_point_neg_if">, description = "fd_ed25519_point_neg_if: argument 0">], alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %1289 = "llvm.select"(%1287, %1285, %1277) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%1289, %253) <{alias_scopes = [#llvm.alias_scope<id = distinct[73]<>, domain = <id = distinct[74]<>, description = "fd_ed25519_point_neg_if">, description = "fd_ed25519_point_neg_if: argument 0">], alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %1290 = "llvm.select"(%1287, %1286, %1280) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%1290, %255) <{alias_scopes = [#llvm.alias_scope<id = distinct[73]<>, domain = <id = distinct[74]<>, description = "fd_ed25519_point_neg_if">, description = "fd_ed25519_point_neg_if: argument 0">], alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.call"(%arg0, %245, %246, %247, %248) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_add_secure, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>, zero_call_used_regs = "all"}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  %1291 = "llvm.add"(%1015, %33) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1292 = "llvm.icmp"(%1015, %15) <{predicate = 6 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1292, %1291)[^bb8, ^bb7] <{loop_annotation = #llvm.loop_annotation<mustProgress = true>, operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i64) -> ()
}) : () -> ()

    with
      @fd_ed25519_base_point_const_time_table := Firedancer.Lane.Mlir.fd_ed25519_base_point_const_time_table,
      @fd_ed25519_point_add_secure := Firedancer.Lane.Mlir.fd_ed25519_point_add_secure,
      @fd_ed25519_point_add_secure := Firedancer.Lane.Mlir.fd_ed25519_point_add_secure,
      @fd_ed25519_point_add_secure := Firedancer.Lane.Mlir.fd_ed25519_point_add_secure,
      @fd_ed25519_point_add_secure := Firedancer.Lane.Mlir.fd_ed25519_point_add_secure

end

end Firedancer.Lane.Mlir
