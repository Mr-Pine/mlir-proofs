
module

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

public import Firedancer.Lane.Mlir.fd_ed25519_base_point_wnaf_table
public import Firedancer.Lane.Mlir.fd_curve25519_scalar_wnaf
public import Firedancer.Lane.Mlir.fd_curve25519_scalar_wnaf
public import Firedancer.Lane.Mlir.fd_ed25519_point_dbln
public import Firedancer.Lane.Mlir.fd_ed25519_point_add_with_opts
public import Firedancer.Lane.Mlir.fd_ed25519_partial_dbl
public import Firedancer.Lane.Mlir.fd_ed25519_point_add_with_opts
public import Firedancer.Lane.Mlir.fd_ed25519_point_add_with_opts
public import Firedancer.Lane.Mlir.fd_ed25519_point_add_with_opts
public import Firedancer.Lane.Mlir.fd_ed25519_point_add_with_opts

namespace Firedancer.Lane.Mlir

@[expose] public section

noncomputable mlir_def fd_ed25519_double_scalar_mul_base := "llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.nofree, llvm.noundef, llvm.returned}, {llvm.noundef}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.noundef}], frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<ptr (ptr, ptr, ptr, ptr)>, linkage = #llvm.linkage<external>, no_unwind, passthrough = ["sspstrong", ["min-legal-vector-width", "512"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "znver4"]], res_attrs = [{llvm.noundef}], sym_name = "fd_ed25519_double_scalar_mul_base", target_cpu = "znver4", target_features = #llvm.target_features<["+64bit", "+adx", "+aes", "+avx", "+avx2", "+avx512bf16", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+clzero", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fast-vector-fsqrt", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+mwaitx", "+pclmul", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdpru", "+rdrnd", "+rdseed", "+sahf", "+sha", "+shstk", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+sse4a", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tile", "-avx10.1", "-avx10.2", "-avx512bmm", "-avx512fp16", "-avx512vp2intersect", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-ccmp", "-cf", "-cldemote", "-cmpccxadd", "-egpr", "-enqcmd", "-fma4", "-hreset", "-jmpabs", "-kl", "-lwp", "-movdir64b", "-movdiri", "-movrs", "-ndd", "-nf", "-pconfig", "-ppx", "-prefetchi", "-ptwrite", "-push2pop2", "-raoint", "-rtm", "-serialize", "-sgx", "-sha512", "-sm3", "-sm4", "-tbm", "-tsxldtrk", "-uintr", "-usermsr", "-waitpkg", "-widekl", "-xop", "-zu"]>, tune_cpu = "znver4", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg0: !llvm.ptr, %arg1: !llvm.ptr, %arg2: !llvm.ptr, %arg3: !llvm.ptr):
  %0 = "llvm.mlir.constant"() <{value = -8 : i32}> : () -> i32
  %1 = "llvm.mlir.constant"() <{value = -1 : i64}> : () -> i64
  %2 = "llvm.mlir.addressof"() <{global_name = @fd_ed25519_base_point_wnaf_table}> : () -> !llvm.ptr
  %3 = "llvm.mlir.constant"() <{value = 2199023255550 : i64}> : () -> i64
  %4 = "llvm.mlir.constant"() <{value = 17592186044378 : i64}> : () -> i64
  %5 = "llvm.mlir.constant"() <{value = 17592186044414 : i64}> : () -> i64
  %6 = "llvm.mlir.constant"() <{value = 1 : i16}> : () -> i16
  %7 = "llvm.mlir.constant"() <{value = -7 : i32}> : () -> i32
  %8 = "llvm.mlir.constant"() <{value = -6 : i32}> : () -> i32
  %9 = "llvm.mlir.constant"() <{value = -5 : i32}> : () -> i32
  %10 = "llvm.mlir.constant"() <{value = -4 : i32}> : () -> i32
  %11 = "llvm.mlir.constant"() <{value = -3 : i32}> : () -> i32
  %12 = "llvm.mlir.constant"() <{value = -2 : i32}> : () -> i32
  %13 = "llvm.mlir.constant"() <{value = -1 : i32}> : () -> i32
  %14 = "llvm.mlir.constant"() <{value = 0 : i16}> : () -> i16
  %15 = "llvm.mlir.constant"() <{value = 255 : i32}> : () -> i32
  %16 = "llvm.mlir.constant"() <{value = 0 : i8}> : () -> i8
  %17 = "llvm.mlir.constant"() <{value = dense<[0, 1, 1, 0, 0, 0, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %18 = "llvm.mlir.constant"() <{value = 8 : i64}> : () -> i64
  %19 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %20 = "llvm.mlir.constant"() <{value = dense<24> : vector<8xi64>}> : () -> vector<8xi64>
  %21 = "llvm.mlir.constant"() <{value = dense<7> : vector<8xi64>}> : () -> vector<8xi64>
  %22 = "llvm.mlir.constant"() <{value = dense<9> : vector<8xi64>}> : () -> vector<8xi64>
  %23 = "llvm.mlir.constant"() <{value = dense<[0, 0, 0, 15037786634, 0, 0, 0, 309467527341]> : vector<8xi64>}> : () -> vector<8xi64>
  %24 = "llvm.mlir.constant"() <{value = dense<[0, 0, 0, 507525298899, 0, 0, 0, 6596238350568]> : vector<8xi64>}> : () -> vector<8xi64>
  %25 = "llvm.mlir.constant"() <{value = dense<[1, 1, 1, 3934839304537, 0, 0, 0, 521695520920]> : vector<8xi64>}> : () -> vector<8xi64>
  %26 = "llvm.mlir.constant"() <{value = dense<0> : vector<8xi64>}> : () -> vector<8xi64>
  %27 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %28 = "llvm.mlir.constant"() <{value = dense<[8796093022207, 8796093022207, 8796093022207, 8796093022207, 1099511627775, 1099511627775, 1099511627775, 1099511627775]> : vector<8xi64>}> : () -> vector<8xi64>
  %29 = "llvm.mlir.constant"() <{value = dense<1048576> : vector<8xi64>}> : () -> vector<8xi64>
  %30 = "llvm.mlir.constant"() <{value = dense<[159383552, 159383552, 159383552, 159383552, 1048576, 1048576, 1048576, 1048576]> : vector<8xi64>}> : () -> vector<8xi64>
  %31 = "llvm.mlir.constant"() <{value = dense<8796093022207> : vector<8xi64>}> : () -> vector<8xi64>
  %32 = "llvm.mlir.constant"() <{value = 19 : i64}> : () -> i64
  %33 = "llvm.mlir.constant"() <{value = dense<[43, 43, 43, 43, 40, 40, 40, 40]> : vector<8xi64>}> : () -> vector<8xi64>
  %34 = "llvm.mlir.constant"() <{value = dense<43> : vector<8xi64>}> : () -> vector<8xi64>
  %35 = "llvm.mlir.constant"() <{value = dense<-1048576> : vector<8xi64>}> : () -> vector<8xi64>
  %36 = "llvm.mlir.constant"() <{value = dense<[-159383552, -159383552, -159383552, -159383552, -1048576, -1048576, -1048576, -1048576]> : vector<8xi64>}> : () -> vector<8xi64>
  %37 = "llvm.mlir.constant"() <{value = 1099511627775 : i64}> : () -> i64
  %38 = "llvm.mlir.constant"() <{value = 7 : i32}> : () -> i32
  %39 = "llvm.mlir.constant"() <{value = 6 : i32}> : () -> i32
  %40 = "llvm.mlir.constant"() <{value = 5 : i32}> : () -> i32
  %41 = "llvm.mlir.constant"() <{value = 3 : i32}> : () -> i32
  %42 = "llvm.mlir.constant"() <{value = 2 : i32}> : () -> i32
  %43 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %44 = "llvm.mlir.constant"() <{value = 4 : i32}> : () -> i32
  %45 = "llvm.mlir.constant"() <{value = 8 : i32}> : () -> i32
  %46 = "llvm.mlir.constant"() <{value = 128 : i64}> : () -> i64
  %47 = "llvm.mlir.poison"() : () -> vector<8xi64>
  %48 = "llvm.mlir.poison"() : () -> i64
  %49 = "llvm.mlir.constant"() <{value = 8796093022207 : i64}> : () -> i64
  %50 = "llvm.mlir.constant"() <{value = 8796093022189 : i64}> : () -> i64
  %51 = "llvm.mlir.undef"() : () -> vector<8xi64>
  %52 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %53 = "llvm.insertelement"(%51, %50, %52) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %54 = "llvm.insertelement"(%53, %48, %43) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %55 = "llvm.insertelement"(%54, %48, %42) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %56 = "llvm.insertelement"(%55, %48, %41) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %57 = "llvm.insertelement"(%56, %49, %44) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %58 = "llvm.insertelement"(%57, %48, %40) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %59 = "llvm.insertelement"(%58, %48, %39) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %60 = "llvm.insertelement"(%59, %48, %38) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %61 = "llvm.insertelement"(%51, %49, %52) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %62 = "llvm.insertelement"(%61, %48, %43) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %63 = "llvm.insertelement"(%62, %48, %42) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %64 = "llvm.insertelement"(%63, %48, %41) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %65 = "llvm.insertelement"(%64, %49, %44) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %66 = "llvm.insertelement"(%65, %48, %40) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %67 = "llvm.insertelement"(%66, %48, %39) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %68 = "llvm.insertelement"(%67, %48, %38) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %69 = "llvm.insertelement"(%51, %49, %52) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %70 = "llvm.insertelement"(%69, %48, %43) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %71 = "llvm.insertelement"(%70, %48, %42) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %72 = "llvm.insertelement"(%71, %48, %41) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %73 = "llvm.insertelement"(%72, %37, %44) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %74 = "llvm.insertelement"(%73, %48, %40) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %75 = "llvm.insertelement"(%74, %48, %39) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %76 = "llvm.insertelement"(%75, %48, %38) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %77 = "llvm.insertelement"(%51, %48, %52) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %78 = "llvm.insertelement"(%77, %48, %43) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %79 = "llvm.insertelement"(%78, %48, %42) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %80 = "llvm.insertelement"(%79, %48, %41) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %81 = "llvm.insertelement"(%80, %32, %44) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %82 = "llvm.insertelement"(%81, %32, %40) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %83 = "llvm.insertelement"(%82, %32, %39) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %84 = "llvm.insertelement"(%83, %32, %38) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %85 = "llvm.insertelement"(%51, %48, %52) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %86 = "llvm.insertelement"(%85, %48, %43) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %87 = "llvm.insertelement"(%86, %48, %42) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %88 = "llvm.insertelement"(%87, %4, %41) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %89 = "llvm.insertelement"(%88, %48, %44) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %90 = "llvm.insertelement"(%89, %48, %40) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %91 = "llvm.insertelement"(%90, %48, %39) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %92 = "llvm.insertelement"(%91, %5, %38) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %93 = "llvm.insertelement"(%51, %48, %52) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %94 = "llvm.insertelement"(%93, %48, %43) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %95 = "llvm.insertelement"(%94, %48, %42) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %96 = "llvm.insertelement"(%95, %5, %41) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %97 = "llvm.insertelement"(%96, %48, %44) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %98 = "llvm.insertelement"(%97, %48, %40) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %99 = "llvm.insertelement"(%98, %48, %39) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %100 = "llvm.insertelement"(%99, %5, %38) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %101 = "llvm.insertelement"(%51, %48, %52) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %102 = "llvm.insertelement"(%101, %48, %43) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %103 = "llvm.insertelement"(%102, %48, %42) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %104 = "llvm.insertelement"(%103, %5, %41) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %105 = "llvm.insertelement"(%104, %48, %44) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %106 = "llvm.insertelement"(%105, %48, %40) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %107 = "llvm.insertelement"(%106, %48, %39) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %108 = "llvm.insertelement"(%107, %3, %38) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %109 = "llvm.alloca"(%43) <{alignment = 64 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_curve25519_edwards", (vector<8xi64>, vector<8xi64>, vector<8xi64>)>>}> : (i32) -> !llvm.ptr
  %110 = "llvm.alloca"(%43) <{alignment = 64 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_curve25519_edwards", (vector<8xi64>, vector<8xi64>, vector<8xi64>)>>}> : (i32) -> !llvm.ptr
  %111 = "llvm.alloca"(%43) <{alignment = 16 : i64, elem_type = !llvm.array<256 x i16>}> : (i32) -> !llvm.ptr
  %112 = "llvm.alloca"(%43) <{alignment = 16 : i64, elem_type = !llvm.array<256 x i16>}> : (i32) -> !llvm.ptr
  %113 = "llvm.alloca"(%43) <{alignment = 64 : i64, elem_type = !llvm.array<8 x struct<"struct.fd_curve25519_edwards", (vector<8xi64>, vector<8xi64>, vector<8xi64>)>>}> : (i32) -> !llvm.ptr
  %114 = "llvm.alloca"(%43) <{alignment = 64 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_curve25519_edwards", (vector<8xi64>, vector<8xi64>, vector<8xi64>)>>}> : (i32) -> !llvm.ptr
  %115 = "llvm.alloca"(%43) <{alignment = 64 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_curve25519_edwards", (vector<8xi64>, vector<8xi64>, vector<8xi64>)>>}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%111) : (!llvm.ptr) -> ()
  "llvm.call"(%111, %arg1, %44) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_curve25519_scalar_wnaf, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i32) -> ()
  "llvm.intr.lifetime.start"(%112) : (!llvm.ptr) -> ()
  "llvm.call"(%112, %arg3, %45) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_curve25519_scalar_wnaf, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i32) -> ()
  "llvm.intr.lifetime.start"(%113) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%114) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%115) : (!llvm.ptr) -> ()
  %116 = "llvm.load"(%arg2) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %117 = "llvm.getelementptr"(%arg2) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %118 = "llvm.load"(%117) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %119 = "llvm.getelementptr"(%113) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %120 = "llvm.getelementptr"(%arg2) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %121 = "llvm.load"(%120) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %122 = "llvm.getelementptr"(%113) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %123 = "llvm.call"(%114, %arg2, %43) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_dbln, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i32) -> !llvm.ptr
  %124 = "llvm.shufflevector"(%116, %47) <{mask = array<i32: 1, -1, -1, -1, 5, -1, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %125 = "llvm.shufflevector"(%118, %47) <{mask = array<i32: 1, -1, -1, -1, 5, -1, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %126 = "llvm.shufflevector"(%121, %47) <{mask = array<i32: 1, -1, -1, -1, 5, -1, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %127 = "llvm.sub"(%124, %116) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %128 = "llvm.add"(%127, %60) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %129 = "llvm.shufflevector"(%128, %116) <{mask = array<i32: 0, 8, 10, 11, 4, 12, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %130 = "llvm.sub"(%125, %118) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %131 = "llvm.add"(%130, %68) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %132 = "llvm.shufflevector"(%131, %118) <{mask = array<i32: 0, 8, 10, 11, 4, 12, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %133 = "llvm.sub"(%126, %121) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %134 = "llvm.add"(%133, %76) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %135 = "llvm.shufflevector"(%134, %121) <{mask = array<i32: 0, 8, 10, 11, 4, 12, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %136 = "llvm.add"(%129, %116) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %137 = "llvm.shufflevector"(%129, %136) <{mask = array<i32: 0, 9, 2, 3, 4, 13, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %138 = "llvm.add"(%132, %118) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %139 = "llvm.shufflevector"(%132, %138) <{mask = array<i32: 0, 9, 2, 3, 4, 13, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %140 = "llvm.add"(%135, %121) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %141 = "llvm.shufflevector"(%135, %140) <{mask = array<i32: 0, 9, 2, 3, 4, 13, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %142 = "llvm.add"(%137, %36) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %143 = "llvm.add"(%139, %35) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %144 = "llvm.add"(%141, %35) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %145 = "llvm.ashr"(%142, %34) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %146 = "llvm.ashr"(%143, %34) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %147 = "llvm.ashr"(%144, %33) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %148 = "llvm.mul"(%147, %84) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %149 = "llvm.and"(%142, %31) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %150 = "llvm.shufflevector"(%148, %147) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %151 = "llvm.add"(%149, %30) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %152 = "llvm.add"(%151, %150) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %153 = "llvm.and"(%143, %31) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %154 = "llvm.add"(%145, %29) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %155 = "llvm.add"(%154, %153) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %156 = "llvm.and"(%144, %28) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %157 = "llvm.add"(%146, %29) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %158 = "llvm.add"(%157, %156) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %159 = "llvm.shufflevector"(%152, %47) <{mask = array<i32: 0, 1, 2, 3, 0, 1, 2, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %160 = "llvm.shufflevector"(%155, %47) <{mask = array<i32: 0, 1, 2, 3, 0, 1, 2, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %161 = "llvm.shufflevector"(%158, %47) <{mask = array<i32: 0, 1, 2, 3, 0, 1, 2, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %162 = "llvm.shufflevector"(%152, %47) <{mask = array<i32: 4, 5, 6, 7, 4, 5, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %163 = "llvm.shufflevector"(%155, %47) <{mask = array<i32: 4, 5, 6, 7, 4, 5, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %164 = "llvm.shufflevector"(%158, %47) <{mask = array<i32: 4, 5, 6, 7, 4, 5, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %165 = "llvm.call_intrinsic"(%26, %159, %25) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %166 = "llvm.call_intrinsic"(%26, %160, %25) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %167 = "llvm.call_intrinsic"(%166, %159, %24) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %168 = "llvm.call_intrinsic"(%26, %161, %25) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %169 = "llvm.call_intrinsic"(%168, %160, %24) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %170 = "llvm.call_intrinsic"(%169, %159, %23) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %171 = "llvm.call_intrinsic"(%26, %162, %25) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %172 = "llvm.call_intrinsic"(%171, %161, %24) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %173 = "llvm.call_intrinsic"(%172, %160, %23) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %174 = "llvm.call_intrinsic"(%26, %163, %25) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %175 = "llvm.call_intrinsic"(%174, %162, %24) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %176 = "llvm.call_intrinsic"(%175, %161, %23) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %177 = "llvm.call_intrinsic"(%26, %164, %25) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %178 = "llvm.call_intrinsic"(%177, %163, %24) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %179 = "llvm.call_intrinsic"(%178, %162, %23) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %180 = "llvm.call_intrinsic"(%26, %164, %24) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %181 = "llvm.call_intrinsic"(%180, %163, %23) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %182 = "llvm.call_intrinsic"(%26, %159, %25) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %183 = "llvm.shl"(%182, %22) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %184 = "llvm.add"(%183, %167) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %185 = "llvm.call_intrinsic"(%26, %160, %25) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %186 = "llvm.call_intrinsic"(%185, %159, %24) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %187 = "llvm.shl"(%186, %22) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %188 = "llvm.add"(%187, %170) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %189 = "llvm.call_intrinsic"(%26, %161, %25) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %190 = "llvm.call_intrinsic"(%189, %160, %24) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %191 = "llvm.call_intrinsic"(%190, %159, %23) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %192 = "llvm.shl"(%191, %22) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %193 = "llvm.add"(%192, %173) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %194 = "llvm.call_intrinsic"(%26, %162, %25) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %195 = "llvm.call_intrinsic"(%194, %161, %24) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %196 = "llvm.call_intrinsic"(%195, %160, %23) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %197 = "llvm.shl"(%196, %22) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %198 = "llvm.add"(%197, %176) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %199 = "llvm.call_intrinsic"(%26, %163, %25) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %200 = "llvm.call_intrinsic"(%199, %162, %24) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %201 = "llvm.call_intrinsic"(%200, %161, %23) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %202 = "llvm.shl"(%201, %22) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %203 = "llvm.add"(%202, %179) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %204 = "llvm.call_intrinsic"(%26, %164, %25) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %205 = "llvm.call_intrinsic"(%204, %163, %24) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %206 = "llvm.call_intrinsic"(%205, %162, %23) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %207 = "llvm.shl"(%206, %22) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %208 = "llvm.add"(%207, %181) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %209 = "llvm.call_intrinsic"(%26, %164, %24) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %210 = "llvm.call_intrinsic"(%209, %163, %23) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %211 = "llvm.shl"(%210, %22) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %212 = "llvm.call_intrinsic"(%211, %164, %23) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %213 = "llvm.call_intrinsic"(%26, %164, %23) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %214 = "llvm.shl"(%213, %22) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %215 = "llvm.shufflevector"(%193, %47) <{mask = array<i32: 4, 5, 6, 7, 0, 1, 2, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %216 = "llvm.shufflevector"(%198, %47) <{mask = array<i32: 4, 5, 6, 7, 0, 1, 2, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %217 = "llvm.shufflevector"(%203, %47) <{mask = array<i32: 4, 5, 6, 7, 0, 1, 2, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %218 = "llvm.add"(%215, %165) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %219 = "llvm.shufflevector"(%165, %218) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %220 = "llvm.add"(%216, %184) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %221 = "llvm.shufflevector"(%184, %220) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %222 = "llvm.add"(%217, %188) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %223 = "llvm.shufflevector"(%188, %222) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %224 = "llvm.add"(%208, %215) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %225 = "llvm.shufflevector"(%224, %208) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %226 = "llvm.add"(%212, %216) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %227 = "llvm.shufflevector"(%226, %212) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %228 = "llvm.add"(%214, %217) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %229 = "llvm.shufflevector"(%228, %214) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %230 = "llvm.shl"(%225, %21) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %231 = "llvm.add"(%230, %219) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %232 = "llvm.mul"(%225, %20) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %233 = "llvm.add"(%231, %232) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %234 = "llvm.shl"(%227, %21) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %235 = "llvm.add"(%234, %221) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %236 = "llvm.mul"(%227, %20) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %237 = "llvm.add"(%235, %236) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %238 = "llvm.shl"(%229, %21) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %239 = "llvm.add"(%238, %223) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %240 = "llvm.mul"(%229, %20) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %241 = "llvm.add"(%239, %240) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %242 = "llvm.lshr"(%233, %34) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %243 = "llvm.lshr"(%237, %34) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %244 = "llvm.lshr"(%241, %33) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %245 = "llvm.mul"(%244, %84) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %246 = "llvm.and"(%233, %31) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %247 = "llvm.shufflevector"(%245, %244) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %248 = "llvm.add"(%247, %246) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%248, %113) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %249 = "llvm.and"(%237, %31) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %250 = "llvm.add"(%249, %242) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%250, %119) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %251 = "llvm.and"(%241, %28) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %252 = "llvm.add"(%251, %243) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%252, %122) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %253 = "llvm.getelementptr"(%115) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %254 = "llvm.getelementptr"(%115) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.br"(%19)[^bb2] : (i64) -> ()
^bb1:  // pred: ^bb2
  "llvm.store"(%17, %arg0) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %255 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.memset"(%255, %16, %46) <{arg_attrs = [{llvm.align = 64 : i64, llvm.dereferenceable = 128 : i64, llvm.nonnull, llvm.noundef}, {}, {}], isVolatile = false}> : (!llvm.ptr, i8, i64) -> ()
  "llvm.br"(%15)[^bb3] : (i32) -> ()
^bb2(%256: i64):  // 2 preds: ^bb0, ^bb2
  %257 = "llvm.getelementptr"(%113, %256) <{elem_type = !llvm.array<192 x i8>, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %258 = "llvm.getelementptr"(%257) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -192>}> : (!llvm.ptr) -> !llvm.ptr
  %259 = "llvm.call"(%115, %114, %258, %43) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_add_with_opts, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, i32) -> !llvm.ptr
  %260 = "llvm.load"(%115) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[0]<>, domain = <id = distinct[1]<>, description = "fd_ed25519_point_add_final_mul">, description = "fd_ed25519_point_add_final_mul: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %261 = "llvm.load"(%253) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[0]<>, domain = <id = distinct[1]<>, description = "fd_ed25519_point_add_final_mul">, description = "fd_ed25519_point_add_final_mul: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %262 = "llvm.getelementptr"(%257) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %263 = "llvm.load"(%254) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[0]<>, domain = <id = distinct[1]<>, description = "fd_ed25519_point_add_final_mul">, description = "fd_ed25519_point_add_final_mul: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %264 = "llvm.getelementptr"(%257) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %265 = "llvm.shufflevector"(%260, %47) <{mask = array<i32: 1, -1, -1, -1, 5, -1, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %266 = "llvm.shufflevector"(%261, %47) <{mask = array<i32: 1, -1, -1, -1, 5, -1, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %267 = "llvm.shufflevector"(%263, %47) <{mask = array<i32: 1, -1, -1, -1, 5, -1, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %268 = "llvm.sub"(%265, %260) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %269 = "llvm.add"(%268, %60) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %270 = "llvm.shufflevector"(%269, %260) <{mask = array<i32: 0, 8, 10, 11, 4, 12, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %271 = "llvm.sub"(%266, %261) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %272 = "llvm.add"(%271, %68) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %273 = "llvm.shufflevector"(%272, %261) <{mask = array<i32: 0, 8, 10, 11, 4, 12, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %274 = "llvm.sub"(%267, %263) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %275 = "llvm.add"(%274, %76) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %276 = "llvm.shufflevector"(%275, %263) <{mask = array<i32: 0, 8, 10, 11, 4, 12, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %277 = "llvm.add"(%270, %260) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %278 = "llvm.shufflevector"(%270, %277) <{mask = array<i32: 0, 9, 2, 3, 4, 13, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %279 = "llvm.add"(%273, %261) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %280 = "llvm.shufflevector"(%273, %279) <{mask = array<i32: 0, 9, 2, 3, 4, 13, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %281 = "llvm.add"(%276, %263) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %282 = "llvm.shufflevector"(%276, %281) <{mask = array<i32: 0, 9, 2, 3, 4, 13, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %283 = "llvm.add"(%278, %36) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %284 = "llvm.add"(%280, %35) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %285 = "llvm.add"(%282, %35) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %286 = "llvm.ashr"(%283, %34) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %287 = "llvm.ashr"(%284, %34) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %288 = "llvm.ashr"(%285, %33) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %289 = "llvm.mul"(%288, %84) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %290 = "llvm.and"(%283, %31) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %291 = "llvm.shufflevector"(%289, %288) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %292 = "llvm.add"(%290, %30) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %293 = "llvm.add"(%292, %291) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %294 = "llvm.and"(%284, %31) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %295 = "llvm.add"(%286, %29) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %296 = "llvm.add"(%295, %294) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %297 = "llvm.and"(%285, %28) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %298 = "llvm.add"(%287, %29) <{overflowFlags = 1 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %299 = "llvm.add"(%298, %297) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %300 = "llvm.shufflevector"(%293, %47) <{mask = array<i32: 0, 1, 2, 3, 0, 1, 2, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %301 = "llvm.shufflevector"(%296, %47) <{mask = array<i32: 0, 1, 2, 3, 0, 1, 2, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %302 = "llvm.shufflevector"(%299, %47) <{mask = array<i32: 0, 1, 2, 3, 0, 1, 2, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %303 = "llvm.shufflevector"(%293, %47) <{mask = array<i32: 4, 5, 6, 7, 4, 5, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %304 = "llvm.shufflevector"(%296, %47) <{mask = array<i32: 4, 5, 6, 7, 4, 5, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %305 = "llvm.shufflevector"(%299, %47) <{mask = array<i32: 4, 5, 6, 7, 4, 5, 6, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %306 = "llvm.call_intrinsic"(%26, %300, %25) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %307 = "llvm.call_intrinsic"(%26, %301, %25) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %308 = "llvm.call_intrinsic"(%307, %300, %24) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %309 = "llvm.call_intrinsic"(%26, %302, %25) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %310 = "llvm.call_intrinsic"(%309, %301, %24) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %311 = "llvm.call_intrinsic"(%310, %300, %23) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %312 = "llvm.call_intrinsic"(%26, %303, %25) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %313 = "llvm.call_intrinsic"(%312, %302, %24) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %314 = "llvm.call_intrinsic"(%313, %301, %23) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %315 = "llvm.call_intrinsic"(%26, %304, %25) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %316 = "llvm.call_intrinsic"(%315, %303, %24) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %317 = "llvm.call_intrinsic"(%316, %302, %23) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %318 = "llvm.call_intrinsic"(%26, %305, %25) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %319 = "llvm.call_intrinsic"(%318, %304, %24) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %320 = "llvm.call_intrinsic"(%319, %303, %23) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %321 = "llvm.call_intrinsic"(%26, %305, %24) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %322 = "llvm.call_intrinsic"(%321, %304, %23) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %323 = "llvm.call_intrinsic"(%26, %300, %25) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %324 = "llvm.shl"(%323, %22) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %325 = "llvm.add"(%324, %308) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %326 = "llvm.call_intrinsic"(%26, %301, %25) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %327 = "llvm.call_intrinsic"(%326, %300, %24) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %328 = "llvm.shl"(%327, %22) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %329 = "llvm.add"(%328, %311) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %330 = "llvm.call_intrinsic"(%26, %302, %25) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %331 = "llvm.call_intrinsic"(%330, %301, %24) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %332 = "llvm.call_intrinsic"(%331, %300, %23) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %333 = "llvm.shl"(%332, %22) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %334 = "llvm.add"(%333, %314) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %335 = "llvm.call_intrinsic"(%26, %303, %25) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %336 = "llvm.call_intrinsic"(%335, %302, %24) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %337 = "llvm.call_intrinsic"(%336, %301, %23) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %338 = "llvm.shl"(%337, %22) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %339 = "llvm.add"(%338, %317) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %340 = "llvm.call_intrinsic"(%26, %304, %25) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %341 = "llvm.call_intrinsic"(%340, %303, %24) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %342 = "llvm.call_intrinsic"(%341, %302, %23) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %343 = "llvm.shl"(%342, %22) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %344 = "llvm.add"(%343, %320) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %345 = "llvm.call_intrinsic"(%26, %305, %25) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %346 = "llvm.call_intrinsic"(%345, %304, %24) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %347 = "llvm.call_intrinsic"(%346, %303, %23) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %348 = "llvm.shl"(%347, %22) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %349 = "llvm.add"(%348, %322) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %350 = "llvm.call_intrinsic"(%26, %305, %24) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %351 = "llvm.call_intrinsic"(%350, %304, %23) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %352 = "llvm.shl"(%351, %22) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %353 = "llvm.call_intrinsic"(%352, %305, %23) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %354 = "llvm.call_intrinsic"(%26, %305, %23) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %355 = "llvm.shl"(%354, %22) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %356 = "llvm.shufflevector"(%334, %47) <{mask = array<i32: 4, 5, 6, 7, 0, 1, 2, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %357 = "llvm.shufflevector"(%339, %47) <{mask = array<i32: 4, 5, 6, 7, 0, 1, 2, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %358 = "llvm.shufflevector"(%344, %47) <{mask = array<i32: 4, 5, 6, 7, 0, 1, 2, 3>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %359 = "llvm.add"(%356, %306) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %360 = "llvm.shufflevector"(%306, %359) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %361 = "llvm.add"(%357, %325) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %362 = "llvm.shufflevector"(%325, %361) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %363 = "llvm.add"(%358, %329) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %364 = "llvm.shufflevector"(%329, %363) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %365 = "llvm.add"(%349, %356) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %366 = "llvm.shufflevector"(%365, %349) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %367 = "llvm.add"(%353, %357) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %368 = "llvm.shufflevector"(%367, %353) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %369 = "llvm.add"(%355, %358) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %370 = "llvm.shufflevector"(%369, %355) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %371 = "llvm.shl"(%366, %21) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %372 = "llvm.add"(%371, %360) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %373 = "llvm.mul"(%366, %20) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %374 = "llvm.add"(%372, %373) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %375 = "llvm.shl"(%368, %21) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %376 = "llvm.add"(%375, %362) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %377 = "llvm.mul"(%368, %20) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %378 = "llvm.add"(%376, %377) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %379 = "llvm.shl"(%370, %21) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %380 = "llvm.add"(%379, %364) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %381 = "llvm.mul"(%370, %20) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %382 = "llvm.add"(%380, %381) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %383 = "llvm.lshr"(%374, %34) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %384 = "llvm.lshr"(%378, %34) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %385 = "llvm.lshr"(%382, %33) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %386 = "llvm.mul"(%385, %84) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %387 = "llvm.and"(%374, %31) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %388 = "llvm.shufflevector"(%386, %385) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %389 = "llvm.add"(%388, %387) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%389, %257) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %390 = "llvm.and"(%378, %31) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %391 = "llvm.add"(%390, %383) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%391, %262) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %392 = "llvm.and"(%382, %28) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %393 = "llvm.add"(%392, %384) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%393, %264) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %394 = "llvm.add"(%256, %19) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %395 = "llvm.icmp"(%394, %18) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%395, %394)[^bb1, ^bb2] <{loop_annotation = #llvm.loop_annotation<mustProgress = true>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb3(%396: i32):  // 2 preds: ^bb1, ^bb19
  %397 = "llvm.zext"(%396) <{nonNeg}> : (i32) -> i64
  %398 = "llvm.getelementptr"(%111, %397) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %399 = "llvm.load"(%398) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i16
  %400 = "llvm.icmp"(%399, %14) <{predicate = 0 : i64}> : (i16, i16) -> i1
  "llvm.cond_br"(%400, %396)[^bb4, ^bb20] <{operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i32) -> ()
^bb4:  // pred: ^bb3
  %401 = "llvm.getelementptr"(%112, %397) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %402 = "llvm.load"(%401) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i16
  %403 = "llvm.icmp"(%402, %14) <{predicate = 0 : i64}> : (i16, i16) -> i1
  "llvm.cond_br"(%403, %396)[^bb5, ^bb20] <{operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i32) -> ()
^bb5:  // pred: ^bb4
  %404 = "llvm.add"(%396, %13) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %405 = "llvm.zext"(%404) <{nonNeg}> : (i32) -> i64
  %406 = "llvm.getelementptr"(%111, %405) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %407 = "llvm.load"(%406) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i16
  %408 = "llvm.icmp"(%407, %14) <{predicate = 0 : i64}> : (i16, i16) -> i1
  "llvm.cond_br"(%408, %404)[^bb6, ^bb20] <{operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i32) -> ()
^bb6:  // pred: ^bb5
  %409 = "llvm.getelementptr"(%112, %405) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %410 = "llvm.load"(%409) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i16
  %411 = "llvm.icmp"(%410, %14) <{predicate = 0 : i64}> : (i16, i16) -> i1
  "llvm.cond_br"(%411, %404)[^bb7, ^bb20] <{operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i32) -> ()
^bb7:  // pred: ^bb6
  %412 = "llvm.add"(%396, %12) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %413 = "llvm.zext"(%412) <{nonNeg}> : (i32) -> i64
  %414 = "llvm.getelementptr"(%111, %413) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %415 = "llvm.load"(%414) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i16
  %416 = "llvm.icmp"(%415, %14) <{predicate = 0 : i64}> : (i16, i16) -> i1
  "llvm.cond_br"(%416, %412)[^bb8, ^bb20] <{operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i32) -> ()
^bb8:  // pred: ^bb7
  %417 = "llvm.getelementptr"(%112, %413) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %418 = "llvm.load"(%417) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i16
  %419 = "llvm.icmp"(%418, %14) <{predicate = 0 : i64}> : (i16, i16) -> i1
  "llvm.cond_br"(%419, %412)[^bb9, ^bb20] <{operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i32) -> ()
^bb9:  // pred: ^bb8
  %420 = "llvm.add"(%396, %11) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %421 = "llvm.zext"(%420) <{nonNeg}> : (i32) -> i64
  %422 = "llvm.getelementptr"(%111, %421) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %423 = "llvm.load"(%422) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i16
  %424 = "llvm.icmp"(%423, %14) <{predicate = 0 : i64}> : (i16, i16) -> i1
  "llvm.cond_br"(%424, %420)[^bb10, ^bb20] <{operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i32) -> ()
^bb10:  // pred: ^bb9
  %425 = "llvm.getelementptr"(%112, %421) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %426 = "llvm.load"(%425) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i16
  %427 = "llvm.icmp"(%426, %14) <{predicate = 0 : i64}> : (i16, i16) -> i1
  "llvm.cond_br"(%427, %420)[^bb11, ^bb20] <{operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i32) -> ()
^bb11:  // pred: ^bb10
  %428 = "llvm.add"(%396, %10) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %429 = "llvm.zext"(%428) <{nonNeg}> : (i32) -> i64
  %430 = "llvm.getelementptr"(%111, %429) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %431 = "llvm.load"(%430) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i16
  %432 = "llvm.icmp"(%431, %14) <{predicate = 0 : i64}> : (i16, i16) -> i1
  "llvm.cond_br"(%432, %428)[^bb12, ^bb20] <{operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i32) -> ()
^bb12:  // pred: ^bb11
  %433 = "llvm.getelementptr"(%112, %429) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %434 = "llvm.load"(%433) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i16
  %435 = "llvm.icmp"(%434, %14) <{predicate = 0 : i64}> : (i16, i16) -> i1
  "llvm.cond_br"(%435, %428)[^bb13, ^bb20] <{operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i32) -> ()
^bb13:  // pred: ^bb12
  %436 = "llvm.add"(%396, %9) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %437 = "llvm.zext"(%436) <{nonNeg}> : (i32) -> i64
  %438 = "llvm.getelementptr"(%111, %437) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %439 = "llvm.load"(%438) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i16
  %440 = "llvm.icmp"(%439, %14) <{predicate = 0 : i64}> : (i16, i16) -> i1
  "llvm.cond_br"(%440, %436)[^bb14, ^bb20] <{operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i32) -> ()
^bb14:  // pred: ^bb13
  %441 = "llvm.getelementptr"(%112, %437) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %442 = "llvm.load"(%441) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i16
  %443 = "llvm.icmp"(%442, %14) <{predicate = 0 : i64}> : (i16, i16) -> i1
  "llvm.cond_br"(%443, %436)[^bb15, ^bb20] <{operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i32) -> ()
^bb15:  // pred: ^bb14
  %444 = "llvm.add"(%396, %8) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %445 = "llvm.zext"(%444) <{nonNeg}> : (i32) -> i64
  %446 = "llvm.getelementptr"(%111, %445) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %447 = "llvm.load"(%446) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i16
  %448 = "llvm.icmp"(%447, %14) <{predicate = 0 : i64}> : (i16, i16) -> i1
  "llvm.cond_br"(%448, %444)[^bb16, ^bb20] <{operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i32) -> ()
^bb16:  // pred: ^bb15
  %449 = "llvm.getelementptr"(%112, %445) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %450 = "llvm.load"(%449) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i16
  %451 = "llvm.icmp"(%450, %14) <{predicate = 0 : i64}> : (i16, i16) -> i1
  "llvm.cond_br"(%451, %444)[^bb17, ^bb20] <{operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i32) -> ()
^bb17:  // pred: ^bb16
  %452 = "llvm.add"(%396, %7) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %453 = "llvm.zext"(%452) <{nonNeg}> : (i32) -> i64
  %454 = "llvm.getelementptr"(%111, %453) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %455 = "llvm.load"(%454) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i16
  %456 = "llvm.icmp"(%455, %14) <{predicate = 0 : i64}> : (i16, i16) -> i1
  "llvm.cond_br"(%456, %452)[^bb18, ^bb20] <{operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i32) -> ()
^bb18:  // pred: ^bb17
  %457 = "llvm.getelementptr"(%112, %453) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %458 = "llvm.load"(%457) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i16
  %459 = "llvm.icmp"(%458, %14) <{predicate = 0 : i64}> : (i16, i16) -> i1
  "llvm.cond_br"(%459, %452)[^bb19, ^bb20] <{operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i32) -> ()
^bb19:  // pred: ^bb18
  %460 = "llvm.add"(%396, %0) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %461 = "llvm.icmp"(%452, %52) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%461, %460)[^bb33, ^bb3] <{loop_annotation = #llvm.loop_annotation<mustProgress = true>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i32) -> ()
^bb20(%462: i32):  // 16 preds: ^bb3, ^bb4, ^bb5, ^bb6, ^bb7, ^bb8, ^bb9, ^bb10, ^bb11, ^bb12, ^bb13, ^bb14, ^bb15, ^bb16, ^bb17, ^bb18
  %463 = "llvm.icmp"(%462, %13) <{predicate = 4 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%463)[^bb21, ^bb33] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb21:  // pred: ^bb20
  %464 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %465 = "llvm.getelementptr"(%110) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %466 = "llvm.getelementptr"(%110) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %467 = "llvm.getelementptr"(%109) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %468 = "llvm.getelementptr"(%109) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %469 = "llvm.zext"(%462) <{nonNeg}> : (i32) -> i64
  "llvm.br"(%469)[^bb22] : (i64) -> ()
^bb22(%470: i64):  // 2 preds: ^bb21, ^bb32
  %471 = "llvm.call"(%115, %arg0) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_ed25519_partial_dbl, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %472 = "llvm.getelementptr"(%111, %470) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %473 = "llvm.load"(%472) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i16
  %474 = "llvm.icmp"(%473, %14) <{predicate = 4 : i64}> : (i16, i16) -> i1
  "llvm.cond_br"(%474)[^bb23, ^bb24] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb23:  // pred: ^bb22
  "llvm.intr.experimental.noalias.scope.decl"() <{scope = #llvm.alias_scope<id = distinct[2]<>, domain = <id = distinct[3]<>, description = "fd_ed25519_point_add_final_mul">, description = "fd_ed25519_point_add_final_mul: argument 0">}> : () -> ()
  %475 = "llvm.load"(%115) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[2]<>, domain = <id = distinct[3]<>, description = "fd_ed25519_point_add_final_mul">, description = "fd_ed25519_point_add_final_mul: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  "llvm.store"(%475, %arg0) <{alias_scopes = [#llvm.alias_scope<id = distinct[2]<>, domain = <id = distinct[3]<>, description = "fd_ed25519_point_add_final_mul">, description = "fd_ed25519_point_add_final_mul: argument 0">], alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %476 = "llvm.load"(%253) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[2]<>, domain = <id = distinct[3]<>, description = "fd_ed25519_point_add_final_mul">, description = "fd_ed25519_point_add_final_mul: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  "llvm.store"(%476, %255) <{alias_scopes = [#llvm.alias_scope<id = distinct[2]<>, domain = <id = distinct[3]<>, description = "fd_ed25519_point_add_final_mul">, description = "fd_ed25519_point_add_final_mul: argument 0">], alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %477 = "llvm.load"(%254) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[2]<>, domain = <id = distinct[3]<>, description = "fd_ed25519_point_add_final_mul">, description = "fd_ed25519_point_add_final_mul: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  "llvm.store"(%477, %464) <{alias_scopes = [#llvm.alias_scope<id = distinct[2]<>, domain = <id = distinct[3]<>, description = "fd_ed25519_point_add_final_mul">, description = "fd_ed25519_point_add_final_mul: argument 0">], alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %478 = "llvm.lshr"(%473, %6) : (i16, i16) -> i16
  %479 = "llvm.zext"(%478) <{nonNeg}> : (i16) -> i64
  %480 = "llvm.getelementptr"(%113, %479) <{elem_type = !llvm.array<192 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %481 = "llvm.call"(%115, %arg0, %480, %43) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_add_with_opts, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, i32) -> !llvm.ptr
  "llvm.br"()[^bb26] : () -> ()
^bb24:  // pred: ^bb22
  %482 = "llvm.icmp"(%473, %14) <{predicate = 2 : i64}> : (i16, i16) -> i1
  "llvm.cond_br"(%482)[^bb25, ^bb26] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb25:  // pred: ^bb24
  "llvm.intr.experimental.noalias.scope.decl"() <{scope = #llvm.alias_scope<id = distinct[4]<>, domain = <id = distinct[5]<>, description = "fd_ed25519_point_add_final_mul">, description = "fd_ed25519_point_add_final_mul: argument 0">}> : () -> ()
  %483 = "llvm.load"(%115) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[4]<>, domain = <id = distinct[5]<>, description = "fd_ed25519_point_add_final_mul">, description = "fd_ed25519_point_add_final_mul: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  "llvm.store"(%483, %arg0) <{alias_scopes = [#llvm.alias_scope<id = distinct[4]<>, domain = <id = distinct[5]<>, description = "fd_ed25519_point_add_final_mul">, description = "fd_ed25519_point_add_final_mul: argument 0">], alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %484 = "llvm.load"(%253) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[4]<>, domain = <id = distinct[5]<>, description = "fd_ed25519_point_add_final_mul">, description = "fd_ed25519_point_add_final_mul: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  "llvm.store"(%484, %255) <{alias_scopes = [#llvm.alias_scope<id = distinct[4]<>, domain = <id = distinct[5]<>, description = "fd_ed25519_point_add_final_mul">, description = "fd_ed25519_point_add_final_mul: argument 0">], alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %485 = "llvm.load"(%254) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[4]<>, domain = <id = distinct[5]<>, description = "fd_ed25519_point_add_final_mul">, description = "fd_ed25519_point_add_final_mul: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  "llvm.store"(%485, %464) <{alias_scopes = [#llvm.alias_scope<id = distinct[4]<>, domain = <id = distinct[5]<>, description = "fd_ed25519_point_add_final_mul">, description = "fd_ed25519_point_add_final_mul: argument 0">], alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %486 = "llvm.sub"(%14, %473) <{overflowFlags = 0 : i32}> : (i16, i16) -> i16
  %487 = "llvm.lshr"(%486, %6) : (i16, i16) -> i16
  %488 = "llvm.zext"(%487) <{nonNeg}> : (i16) -> i64
  %489 = "llvm.getelementptr"(%113, %488) <{elem_type = !llvm.array<192 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%110) : (!llvm.ptr) -> ()
  %490 = "llvm.load"(%489) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %491 = "llvm.getelementptr"(%489) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %492 = "llvm.load"(%491) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %493 = "llvm.getelementptr"(%489) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %494 = "llvm.load"(%493) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %495 = "llvm.sub"(%92, %490) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %496 = "llvm.sub"(%100, %492) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %497 = "llvm.sub"(%108, %494) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %498 = "llvm.shufflevector"(%490, %495) <{mask = array<i32: 1, 0, 2, 11, 5, 4, 6, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%498, %110) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %499 = "llvm.shufflevector"(%492, %496) <{mask = array<i32: 1, 0, 2, 11, 5, 4, 6, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%499, %465) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %500 = "llvm.shufflevector"(%494, %497) <{mask = array<i32: 1, 0, 2, 11, 5, 4, 6, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%500, %466) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %501 = "llvm.call"(%115, %arg0, %110, %43) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_add_with_opts, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, i32) -> !llvm.ptr
  "llvm.intr.lifetime.end"(%110) : (!llvm.ptr) -> ()
  "llvm.br"()[^bb26] : () -> ()
^bb26:  // 3 preds: ^bb23, ^bb24, ^bb25
  %502 = "llvm.getelementptr"(%112, %470) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %503 = "llvm.load"(%502) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i16
  %504 = "llvm.icmp"(%503, %14) <{predicate = 4 : i64}> : (i16, i16) -> i1
  "llvm.cond_br"(%504)[^bb27, ^bb28] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb27:  // pred: ^bb26
  "llvm.intr.experimental.noalias.scope.decl"() <{scope = #llvm.alias_scope<id = distinct[6]<>, domain = <id = distinct[7]<>, description = "fd_ed25519_point_add_final_mul">, description = "fd_ed25519_point_add_final_mul: argument 0">}> : () -> ()
  %505 = "llvm.load"(%115) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[6]<>, domain = <id = distinct[7]<>, description = "fd_ed25519_point_add_final_mul">, description = "fd_ed25519_point_add_final_mul: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  "llvm.store"(%505, %arg0) <{alias_scopes = [#llvm.alias_scope<id = distinct[6]<>, domain = <id = distinct[7]<>, description = "fd_ed25519_point_add_final_mul">, description = "fd_ed25519_point_add_final_mul: argument 0">], alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %506 = "llvm.load"(%253) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[6]<>, domain = <id = distinct[7]<>, description = "fd_ed25519_point_add_final_mul">, description = "fd_ed25519_point_add_final_mul: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  "llvm.store"(%506, %255) <{alias_scopes = [#llvm.alias_scope<id = distinct[6]<>, domain = <id = distinct[7]<>, description = "fd_ed25519_point_add_final_mul">, description = "fd_ed25519_point_add_final_mul: argument 0">], alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %507 = "llvm.load"(%254) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[6]<>, domain = <id = distinct[7]<>, description = "fd_ed25519_point_add_final_mul">, description = "fd_ed25519_point_add_final_mul: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  "llvm.store"(%507, %464) <{alias_scopes = [#llvm.alias_scope<id = distinct[6]<>, domain = <id = distinct[7]<>, description = "fd_ed25519_point_add_final_mul">, description = "fd_ed25519_point_add_final_mul: argument 0">], alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %508 = "llvm.lshr"(%503, %6) : (i16, i16) -> i16
  %509 = "llvm.zext"(%508) <{nonNeg}> : (i16) -> i64
  %510 = "llvm.getelementptr"(%2, %509) <{elem_type = !llvm.array<192 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %511 = "llvm.call"(%115, %arg0, %510, %43) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_add_with_opts, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, i32) -> !llvm.ptr
  "llvm.br"()[^bb30] : () -> ()
^bb28:  // pred: ^bb26
  %512 = "llvm.icmp"(%503, %14) <{predicate = 2 : i64}> : (i16, i16) -> i1
  "llvm.cond_br"(%512)[^bb29, ^bb30] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb29:  // pred: ^bb28
  "llvm.intr.experimental.noalias.scope.decl"() <{scope = #llvm.alias_scope<id = distinct[8]<>, domain = <id = distinct[9]<>, description = "fd_ed25519_point_add_final_mul">, description = "fd_ed25519_point_add_final_mul: argument 0">}> : () -> ()
  %513 = "llvm.load"(%115) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[8]<>, domain = <id = distinct[9]<>, description = "fd_ed25519_point_add_final_mul">, description = "fd_ed25519_point_add_final_mul: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  "llvm.store"(%513, %arg0) <{alias_scopes = [#llvm.alias_scope<id = distinct[8]<>, domain = <id = distinct[9]<>, description = "fd_ed25519_point_add_final_mul">, description = "fd_ed25519_point_add_final_mul: argument 0">], alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %514 = "llvm.load"(%253) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[8]<>, domain = <id = distinct[9]<>, description = "fd_ed25519_point_add_final_mul">, description = "fd_ed25519_point_add_final_mul: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  "llvm.store"(%514, %255) <{alias_scopes = [#llvm.alias_scope<id = distinct[8]<>, domain = <id = distinct[9]<>, description = "fd_ed25519_point_add_final_mul">, description = "fd_ed25519_point_add_final_mul: argument 0">], alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %515 = "llvm.load"(%254) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[8]<>, domain = <id = distinct[9]<>, description = "fd_ed25519_point_add_final_mul">, description = "fd_ed25519_point_add_final_mul: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  "llvm.store"(%515, %464) <{alias_scopes = [#llvm.alias_scope<id = distinct[8]<>, domain = <id = distinct[9]<>, description = "fd_ed25519_point_add_final_mul">, description = "fd_ed25519_point_add_final_mul: argument 0">], alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %516 = "llvm.sub"(%14, %503) <{overflowFlags = 0 : i32}> : (i16, i16) -> i16
  %517 = "llvm.lshr"(%516, %6) : (i16, i16) -> i16
  %518 = "llvm.zext"(%517) <{nonNeg}> : (i16) -> i64
  %519 = "llvm.getelementptr"(%2, %518) <{elem_type = !llvm.array<192 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%109) : (!llvm.ptr) -> ()
  %520 = "llvm.load"(%519) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %521 = "llvm.getelementptr"(%519) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %522 = "llvm.load"(%521) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %523 = "llvm.getelementptr"(%519) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %524 = "llvm.load"(%523) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %525 = "llvm.sub"(%92, %520) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %526 = "llvm.sub"(%100, %522) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %527 = "llvm.sub"(%108, %524) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %528 = "llvm.shufflevector"(%520, %525) <{mask = array<i32: 1, 0, 2, 11, 5, 4, 6, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%528, %109) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %529 = "llvm.shufflevector"(%522, %526) <{mask = array<i32: 1, 0, 2, 11, 5, 4, 6, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%529, %467) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %530 = "llvm.shufflevector"(%524, %527) <{mask = array<i32: 1, 0, 2, 11, 5, 4, 6, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%530, %468) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %531 = "llvm.call"(%115, %arg0, %109, %43) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_point_add_with_opts, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, i32) -> !llvm.ptr
  "llvm.intr.lifetime.end"(%109) : (!llvm.ptr) -> ()
  "llvm.br"()[^bb30] : () -> ()
^bb30:  // 3 preds: ^bb27, ^bb28, ^bb29
  %532 = "llvm.icmp"(%470, %27) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%532)[^bb31, ^bb32] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb31:  // pred: ^bb30
  "llvm.intr.experimental.noalias.scope.decl"() <{scope = #llvm.alias_scope<id = distinct[10]<>, domain = <id = distinct[11]<>, description = "fd_ed25519_point_add_final_mul">, description = "fd_ed25519_point_add_final_mul: argument 0">}> : () -> ()
  %533 = "llvm.load"(%115) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[10]<>, domain = <id = distinct[11]<>, description = "fd_ed25519_point_add_final_mul">, description = "fd_ed25519_point_add_final_mul: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  "llvm.store"(%533, %arg0) <{alias_scopes = [#llvm.alias_scope<id = distinct[10]<>, domain = <id = distinct[11]<>, description = "fd_ed25519_point_add_final_mul">, description = "fd_ed25519_point_add_final_mul: argument 0">], alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %534 = "llvm.load"(%253) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[10]<>, domain = <id = distinct[11]<>, description = "fd_ed25519_point_add_final_mul">, description = "fd_ed25519_point_add_final_mul: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  "llvm.store"(%534, %255) <{alias_scopes = [#llvm.alias_scope<id = distinct[10]<>, domain = <id = distinct[11]<>, description = "fd_ed25519_point_add_final_mul">, description = "fd_ed25519_point_add_final_mul: argument 0">], alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %535 = "llvm.load"(%254) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[10]<>, domain = <id = distinct[11]<>, description = "fd_ed25519_point_add_final_mul">, description = "fd_ed25519_point_add_final_mul: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  "llvm.store"(%535, %464) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.br"()[^bb33] : () -> ()
^bb32:  // pred: ^bb30
  "llvm.intr.experimental.noalias.scope.decl"() <{scope = #llvm.alias_scope<id = distinct[12]<>, domain = <id = distinct[13]<>, description = "fd_ed25519_point_add_final_mul_projective">, description = "fd_ed25519_point_add_final_mul_projective: argument 0">}> : () -> ()
  %536 = "llvm.load"(%115) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[12]<>, domain = <id = distinct[13]<>, description = "fd_ed25519_point_add_final_mul_projective">, description = "fd_ed25519_point_add_final_mul_projective: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  "llvm.store"(%536, %arg0) <{alias_scopes = [#llvm.alias_scope<id = distinct[12]<>, domain = <id = distinct[13]<>, description = "fd_ed25519_point_add_final_mul_projective">, description = "fd_ed25519_point_add_final_mul_projective: argument 0">], alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %537 = "llvm.load"(%253) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[12]<>, domain = <id = distinct[13]<>, description = "fd_ed25519_point_add_final_mul_projective">, description = "fd_ed25519_point_add_final_mul_projective: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  "llvm.store"(%537, %255) <{alias_scopes = [#llvm.alias_scope<id = distinct[12]<>, domain = <id = distinct[13]<>, description = "fd_ed25519_point_add_final_mul_projective">, description = "fd_ed25519_point_add_final_mul_projective: argument 0">], alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %538 = "llvm.load"(%254) <{alignment = 64 : i64, noalias_scopes = [#llvm.alias_scope<id = distinct[12]<>, domain = <id = distinct[13]<>, description = "fd_ed25519_point_add_final_mul_projective">, description = "fd_ed25519_point_add_final_mul_projective: argument 0">], ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  "llvm.store"(%538, %464) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %539 = "llvm.add"(%470, %1) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %540 = "llvm.icmp"(%470, %27) <{predicate = 4 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%540, %539)[^bb22, ^bb33] <{loop_annotation = #llvm.loop_annotation<mustProgress = true>, operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i64) -> ()
^bb33:  // 4 preds: ^bb19, ^bb20, ^bb31, ^bb32
  "llvm.intr.lifetime.end"(%115) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%114) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%113) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%112) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%111) : (!llvm.ptr) -> ()
  "llvm.return"(%arg0) : (!llvm.ptr) -> ()
}) : () -> ()

    with
      @fd_ed25519_base_point_wnaf_table := Firedancer.Lane.Mlir.fd_ed25519_base_point_wnaf_table,
      @fd_curve25519_scalar_wnaf := Firedancer.Lane.Mlir.fd_curve25519_scalar_wnaf,
      @fd_curve25519_scalar_wnaf := Firedancer.Lane.Mlir.fd_curve25519_scalar_wnaf,
      @fd_ed25519_point_dbln := Firedancer.Lane.Mlir.fd_ed25519_point_dbln,
      @fd_ed25519_point_add_with_opts := Firedancer.Lane.Mlir.fd_ed25519_point_add_with_opts,
      @fd_ed25519_partial_dbl := Firedancer.Lane.Mlir.fd_ed25519_partial_dbl,
      @fd_ed25519_point_add_with_opts := Firedancer.Lane.Mlir.fd_ed25519_point_add_with_opts,
      @fd_ed25519_point_add_with_opts := Firedancer.Lane.Mlir.fd_ed25519_point_add_with_opts,
      @fd_ed25519_point_add_with_opts := Firedancer.Lane.Mlir.fd_ed25519_point_add_with_opts,
      @fd_ed25519_point_add_with_opts := Firedancer.Lane.Mlir.fd_ed25519_point_add_with_opts

end

end Firedancer.Lane.Mlir
