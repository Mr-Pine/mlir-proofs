
module

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

public import Firedancer.Lane.Mlir.fd_ed25519_lane_bcast_fe
public import Firedancer.Lane.Mlir.fd_ed25519_lane_bcast_fe

namespace Firedancer.Lane.Mlir

@[expose] public section

mlir_def fd_ed25519_lane_small_order := "llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<i32 (ptr)>, inline_hint, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, passthrough = ["nofree", "norecurse", "nosync", "sspstrong", ["min-legal-vector-width", "512"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "znver4"]], res_attrs = [{llvm.range = #llvm.constant_range<i32, 0, 256>}], sym_name = "fd_ed25519_lane_small_order", target_cpu = "znver4", target_features = #llvm.target_features<["+64bit", "+adx", "+aes", "+avx", "+avx2", "+avx512bf16", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+clzero", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fast-vector-fsqrt", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+mwaitx", "+pclmul", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdpru", "+rdrnd", "+rdseed", "+sahf", "+sha", "+shstk", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+sse4a", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tile", "-avx10.1", "-avx10.2", "-avx512bmm", "-avx512fp16", "-avx512vp2intersect", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-ccmp", "-cf", "-cldemote", "-cmpccxadd", "-egpr", "-enqcmd", "-fma4", "-hreset", "-jmpabs", "-kl", "-lwp", "-movdir64b", "-movdiri", "-movrs", "-ndd", "-nf", "-pconfig", "-ppx", "-prefetchi", "-ptwrite", "-push2pop2", "-raoint", "-rtm", "-serialize", "-sgx", "-sha512", "-sm3", "-sm4", "-tbm", "-tsxldtrk", "-uintr", "-usermsr", "-waitpkg", "-widekl", "-xop", "-zu"]>, tune_cpu = "znver4", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg0: !llvm.ptr):
  %0 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %1 = "llvm.mlir.constant"() <{value = dense<[3034655877158, 7251661554934, 8531478563367, 3751701540842, 152657171260, 51416324880, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %2 = "llvm.mlir.constant"() <{value = dense<[5761437145031, 1544431467273, 264614458840, 5044391481365, 8643435850947, 1048095302895, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %3 = "llvm.mlir.constant"() <{value = dense<4503599627370458> : vector<8xi64>}> : () -> vector<8xi64>
  %4 = "llvm.mlir.constant"() <{value = dense<4503599627370494> : vector<8xi64>}> : () -> vector<8xi64>
  %5 = "llvm.mlir.constant"() <{value = dense<51> : vector<8xi64>}> : () -> vector<8xi64>
  %6 = "llvm.mlir.constant"() <{value = dense<2251799813685247> : vector<8xi64>}> : () -> vector<8xi64>
  %7 = "llvm.mlir.constant"() <{value = dense<19> : vector<8xi64>}> : () -> vector<8xi64>
  %8 = "llvm.mlir.constant"() <{value = dense<2251799813685229> : vector<8xi64>}> : () -> vector<8xi64>
  %9 = "llvm.mlir.constant"() <{value = dense<0> : vector<8xi64>}> : () -> vector<8xi64>
  %10 = "llvm.alloca"(%0) <{alignment = 64 : i64, elem_type = !llvm.struct<"struct.fd_ed25519_lane_fe", (array<5 x vector<8xi64>>)>}> : (i32) -> !llvm.ptr
  %11 = "llvm.alloca"(%0) <{alignment = 64 : i64, elem_type = !llvm.struct<"struct.fd_ed25519_lane_fe", (array<5 x vector<8xi64>>)>}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%10) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%11) : (!llvm.ptr) -> ()
  "llvm.call"(%10, %1) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {}], callee = @fd_ed25519_lane_bcast_fe, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, vector<8xi64>) -> ()
  "llvm.call"(%11, %2) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {}], callee = @fd_ed25519_lane_bcast_fe, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, vector<8xi64>) -> ()
  %12 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 320>}> : (!llvm.ptr) -> !llvm.ptr
  %13 = "llvm.load"(%12) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %14 = "llvm.add"(%13, %3) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %15 = "llvm.load"(%10) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %16 = "llvm.sub"(%14, %15) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %17 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 384>}> : (!llvm.ptr) -> !llvm.ptr
  %18 = "llvm.load"(%17) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %19 = "llvm.add"(%18, %4) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %20 = "llvm.getelementptr"(%10) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %21 = "llvm.load"(%20) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %22 = "llvm.sub"(%19, %21) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%22, %20) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %23 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 448>}> : (!llvm.ptr) -> !llvm.ptr
  %24 = "llvm.load"(%23) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %25 = "llvm.add"(%24, %4) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %26 = "llvm.getelementptr"(%10) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %27 = "llvm.load"(%26) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %28 = "llvm.sub"(%25, %27) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%28, %26) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %29 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 512>}> : (!llvm.ptr) -> !llvm.ptr
  %30 = "llvm.load"(%29) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %31 = "llvm.add"(%30, %4) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %32 = "llvm.getelementptr"(%10) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 192>}> : (!llvm.ptr) -> !llvm.ptr
  %33 = "llvm.load"(%32) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %34 = "llvm.sub"(%31, %33) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%34, %32) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %35 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 576>}> : (!llvm.ptr) -> !llvm.ptr
  %36 = "llvm.load"(%35) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %37 = "llvm.add"(%36, %4) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %38 = "llvm.getelementptr"(%10) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 256>}> : (!llvm.ptr) -> !llvm.ptr
  %39 = "llvm.load"(%38) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %40 = "llvm.sub"(%37, %39) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%40, %38) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %41 = "llvm.load"(%11) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %42 = "llvm.sub"(%14, %41) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %43 = "llvm.getelementptr"(%11) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %44 = "llvm.load"(%43) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %45 = "llvm.sub"(%19, %44) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%45, %43) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %46 = "llvm.getelementptr"(%11) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %47 = "llvm.load"(%46) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %48 = "llvm.sub"(%25, %47) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%48, %46) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %49 = "llvm.getelementptr"(%11) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 192>}> : (!llvm.ptr) -> !llvm.ptr
  %50 = "llvm.load"(%49) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %51 = "llvm.sub"(%31, %50) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%51, %49) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %52 = "llvm.getelementptr"(%11) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 256>}> : (!llvm.ptr) -> !llvm.ptr
  %53 = "llvm.load"(%52) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %54 = "llvm.sub"(%37, %53) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%54, %52) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %55 = "llvm.load"(%arg0) <{alignment = 64 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi64>
  %56 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %57 = "llvm.load"(%56) <{alignment = 64 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi64>
  %58 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %59 = "llvm.load"(%58) <{alignment = 64 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi64>
  %60 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 192>}> : (!llvm.ptr) -> !llvm.ptr
  %61 = "llvm.load"(%60) <{alignment = 64 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi64>
  %62 = "llvm.getelementptr"(%arg0) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 256>}> : (!llvm.ptr) -> !llvm.ptr
  %63 = "llvm.load"(%62) <{alignment = 64 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi64>
  %64 = "llvm.lshr"(%55, %5) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %65 = "llvm.add"(%64, %57) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %66 = "llvm.and"(%55, %6) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %67 = "llvm.lshr"(%65, %5) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %68 = "llvm.add"(%67, %59) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %69 = "llvm.and"(%65, %6) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %70 = "llvm.lshr"(%68, %5) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %71 = "llvm.add"(%70, %61) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %72 = "llvm.and"(%68, %6) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %73 = "llvm.lshr"(%71, %5) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %74 = "llvm.add"(%73, %63) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %75 = "llvm.and"(%71, %6) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %76 = "llvm.lshr"(%74, %5) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %77 = "llvm.mul"(%76, %7) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %78 = "llvm.add"(%77, %66) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %79 = "llvm.and"(%74, %6) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %80 = "llvm.lshr"(%78, %5) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %81 = "llvm.add"(%80, %69) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %82 = "llvm.and"(%78, %6) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %83 = "llvm.lshr"(%81, %5) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %84 = "llvm.add"(%83, %72) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %85 = "llvm.lshr"(%84, %5) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %86 = "llvm.add"(%85, %75) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %87 = "llvm.lshr"(%86, %5) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %88 = "llvm.add"(%87, %79) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %89 = "llvm.lshr"(%88, %5) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %90 = "llvm.mul"(%89, %7) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %91 = "llvm.add"(%90, %82) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %92 = "llvm.icmp"(%91, %8) <{predicate = 0 : i64}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi1>
  %93 = "llvm.or"(%84, %81) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %94 = "llvm.or"(%93, %86) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %95 = "llvm.or"(%94, %88) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %96 = "llvm.and"(%95, %6) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %97 = "llvm.or"(%91, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %98 = "llvm.icmp"(%97, %9) <{predicate = 0 : i64}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi1>
  %99 = "llvm.and"(%81, %6) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %100 = "llvm.and"(%99, %84) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %101 = "llvm.and"(%100, %86) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %102 = "llvm.and"(%101, %88) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %103 = "llvm.icmp"(%102, %6) <{predicate = 0 : i64}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi1>
  %104 = "llvm.and"(%103, %92) : (vector<8xi1>, vector<8xi1>) -> vector<8xi1>
  %105 = "llvm.or"(%104, %98) : (vector<8xi1>, vector<8xi1>) -> vector<8xi1>
  %106 = "llvm.lshr"(%13, %5) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %107 = "llvm.add"(%18, %106) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %108 = "llvm.and"(%13, %6) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %109 = "llvm.lshr"(%107, %5) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %110 = "llvm.add"(%109, %24) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %111 = "llvm.and"(%107, %6) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %112 = "llvm.lshr"(%110, %5) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %113 = "llvm.add"(%112, %30) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %114 = "llvm.and"(%110, %6) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %115 = "llvm.lshr"(%113, %5) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %116 = "llvm.add"(%115, %36) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %117 = "llvm.and"(%113, %6) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %118 = "llvm.lshr"(%116, %5) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %119 = "llvm.mul"(%118, %7) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %120 = "llvm.add"(%119, %108) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %121 = "llvm.and"(%116, %6) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %122 = "llvm.lshr"(%120, %5) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %123 = "llvm.add"(%122, %111) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %124 = "llvm.and"(%120, %6) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %125 = "llvm.lshr"(%123, %5) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %126 = "llvm.add"(%125, %114) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %127 = "llvm.lshr"(%126, %5) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %128 = "llvm.add"(%127, %117) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %129 = "llvm.lshr"(%128, %5) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %130 = "llvm.add"(%129, %121) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %131 = "llvm.lshr"(%130, %5) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %132 = "llvm.mul"(%131, %7) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %133 = "llvm.add"(%132, %124) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %134 = "llvm.icmp"(%133, %8) <{predicate = 0 : i64}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi1>
  %135 = "llvm.or"(%126, %123) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %136 = "llvm.or"(%135, %128) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %137 = "llvm.or"(%136, %130) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %138 = "llvm.and"(%137, %6) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %139 = "llvm.or"(%133, %138) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %140 = "llvm.icmp"(%139, %9) <{predicate = 0 : i64}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi1>
  %141 = "llvm.and"(%123, %6) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %142 = "llvm.and"(%141, %126) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %143 = "llvm.and"(%142, %128) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %144 = "llvm.and"(%143, %130) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %145 = "llvm.icmp"(%144, %6) <{predicate = 0 : i64}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi1>
  %146 = "llvm.and"(%145, %134) : (vector<8xi1>, vector<8xi1>) -> vector<8xi1>
  %147 = "llvm.or"(%146, %140) : (vector<8xi1>, vector<8xi1>) -> vector<8xi1>
  %148 = "llvm.or"(%105, %147) : (vector<8xi1>, vector<8xi1>) -> vector<8xi1>
  %149 = "llvm.load"(%20) <{alignment = 64 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi64>
  %150 = "llvm.load"(%26) <{alignment = 64 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi64>
  %151 = "llvm.load"(%32) <{alignment = 64 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi64>
  %152 = "llvm.load"(%38) <{alignment = 64 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi64>
  %153 = "llvm.lshr"(%16, %5) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %154 = "llvm.add"(%149, %153) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %155 = "llvm.and"(%16, %6) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %156 = "llvm.lshr"(%154, %5) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %157 = "llvm.add"(%156, %150) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %158 = "llvm.and"(%154, %6) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %159 = "llvm.lshr"(%157, %5) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %160 = "llvm.add"(%159, %151) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %161 = "llvm.and"(%157, %6) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %162 = "llvm.lshr"(%160, %5) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %163 = "llvm.add"(%162, %152) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %164 = "llvm.and"(%160, %6) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %165 = "llvm.lshr"(%163, %5) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %166 = "llvm.mul"(%165, %7) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %167 = "llvm.add"(%166, %155) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %168 = "llvm.and"(%163, %6) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %169 = "llvm.lshr"(%167, %5) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %170 = "llvm.add"(%169, %158) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %171 = "llvm.and"(%167, %6) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %172 = "llvm.lshr"(%170, %5) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %173 = "llvm.add"(%172, %161) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %174 = "llvm.lshr"(%173, %5) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %175 = "llvm.add"(%174, %164) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %176 = "llvm.lshr"(%175, %5) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %177 = "llvm.add"(%176, %168) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %178 = "llvm.lshr"(%177, %5) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %179 = "llvm.mul"(%178, %7) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %180 = "llvm.add"(%179, %171) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %181 = "llvm.icmp"(%180, %8) <{predicate = 0 : i64}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi1>
  %182 = "llvm.or"(%173, %170) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %183 = "llvm.or"(%182, %175) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %184 = "llvm.or"(%183, %177) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %185 = "llvm.and"(%184, %6) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %186 = "llvm.or"(%180, %185) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %187 = "llvm.icmp"(%186, %9) <{predicate = 0 : i64}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi1>
  %188 = "llvm.and"(%170, %6) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %189 = "llvm.and"(%188, %173) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %190 = "llvm.and"(%189, %175) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %191 = "llvm.and"(%190, %177) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %192 = "llvm.icmp"(%191, %6) <{predicate = 0 : i64}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi1>
  %193 = "llvm.and"(%192, %181) : (vector<8xi1>, vector<8xi1>) -> vector<8xi1>
  %194 = "llvm.or"(%193, %187) : (vector<8xi1>, vector<8xi1>) -> vector<8xi1>
  %195 = "llvm.or"(%148, %194) : (vector<8xi1>, vector<8xi1>) -> vector<8xi1>
  %196 = "llvm.load"(%43) <{alignment = 64 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi64>
  %197 = "llvm.load"(%46) <{alignment = 64 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi64>
  %198 = "llvm.load"(%49) <{alignment = 64 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi64>
  %199 = "llvm.load"(%52) <{alignment = 64 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi64>
  %200 = "llvm.lshr"(%42, %5) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %201 = "llvm.add"(%196, %200) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %202 = "llvm.and"(%42, %6) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %203 = "llvm.lshr"(%201, %5) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %204 = "llvm.add"(%203, %197) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %205 = "llvm.and"(%201, %6) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %206 = "llvm.lshr"(%204, %5) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %207 = "llvm.add"(%206, %198) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %208 = "llvm.and"(%204, %6) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %209 = "llvm.lshr"(%207, %5) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %210 = "llvm.add"(%209, %199) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %211 = "llvm.and"(%207, %6) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %212 = "llvm.lshr"(%210, %5) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %213 = "llvm.mul"(%212, %7) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %214 = "llvm.add"(%213, %202) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %215 = "llvm.and"(%210, %6) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %216 = "llvm.lshr"(%214, %5) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %217 = "llvm.add"(%216, %205) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %218 = "llvm.and"(%214, %6) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %219 = "llvm.lshr"(%217, %5) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %220 = "llvm.add"(%219, %208) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %221 = "llvm.lshr"(%220, %5) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %222 = "llvm.add"(%221, %211) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %223 = "llvm.lshr"(%222, %5) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %224 = "llvm.add"(%223, %215) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %225 = "llvm.lshr"(%224, %5) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %226 = "llvm.mul"(%225, %7) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %227 = "llvm.add"(%226, %218) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %228 = "llvm.icmp"(%227, %8) <{predicate = 0 : i64}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi1>
  %229 = "llvm.or"(%220, %217) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %230 = "llvm.or"(%229, %222) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %231 = "llvm.or"(%230, %224) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %232 = "llvm.and"(%231, %6) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %233 = "llvm.or"(%227, %232) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %234 = "llvm.icmp"(%233, %9) <{predicate = 0 : i64}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi1>
  %235 = "llvm.and"(%217, %6) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %236 = "llvm.and"(%235, %220) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %237 = "llvm.and"(%236, %222) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %238 = "llvm.and"(%237, %224) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %239 = "llvm.icmp"(%238, %6) <{predicate = 0 : i64}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi1>
  %240 = "llvm.and"(%239, %228) : (vector<8xi1>, vector<8xi1>) -> vector<8xi1>
  %241 = "llvm.or"(%240, %234) : (vector<8xi1>, vector<8xi1>) -> vector<8xi1>
  %242 = "llvm.or"(%195, %241) : (vector<8xi1>, vector<8xi1>) -> vector<8xi1>
  %243 = "llvm.bitcast"(%242) : (vector<8xi1>) -> i8
  %244 = "llvm.zext"(%243) : (i8) -> i32
  "llvm.intr.lifetime.end"(%11) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%10) : (!llvm.ptr) -> ()
  "llvm.return"(%244) : (i32) -> ()
}) : () -> ()

    with
      @fd_ed25519_lane_bcast_fe := Firedancer.Lane.Mlir.fd_ed25519_lane_bcast_fe,
      @fd_ed25519_lane_bcast_fe := Firedancer.Lane.Mlir.fd_ed25519_lane_bcast_fe

end

end Firedancer.Lane.Mlir
