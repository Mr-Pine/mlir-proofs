
module

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

public import Firedancer.Lane.Mlir.fd_ed25519_lane_base_table
public import Firedancer.Lane.Mlir.verify_x8_identity
public import Firedancer.Lane.Mlir.fd_ed25519_lane_bcast_fe
public import Firedancer.Lane.Mlir.fd_ed25519_lane_bcast_fe
public import Firedancer.Lane.Mlir.fd_ed25519_lane_pow22523_2
public import Firedancer.Lane.Mlir.fd_ed25519_lane_small_order
public import Firedancer.Lane.Mlir.fd_ed25519_lane_small_order
public import Firedancer.Lane.Mlir.fd_sha512_init
public import Firedancer.Lane.Mlir.fd_sha512_append
public import Firedancer.Lane.Mlir.fd_sha512_append
public import Firedancer.Lane.Mlir.fd_sha512_append
public import Firedancer.Lane.Mlir.fd_sha512_fini
public import Firedancer.Lane.Mlir.fd_curve25519_scalar_reduce
public import Firedancer.Lane.Mlir.fd_ed25519_lane_bcast_fe
public import Firedancer.Lane.Mlir.fd_ed25519_lane_point_dbl
public import Firedancer.Lane.Mlir.fd_ed25519_lane_point_add
public import Firedancer.Lane.Mlir.fd_ed25519_lane_point_dbl
public import Firedancer.Lane.Mlir.fd_ed25519_lane_point_add
public import Firedancer.Lane.Mlir.fd_ed25519_lane_point_dbl
public import Firedancer.Lane.Mlir.fd_ed25519_lane_point_add
public import Firedancer.Lane.Mlir.fd_ed25519_lane_point_dbl
public import Firedancer.Lane.Mlir.fd_ed25519_lane_point_dbl
public import Firedancer.Lane.Mlir.fd_ed25519_lane_point_dbl
public import Firedancer.Lane.Mlir.fd_ed25519_lane_point_dbl
public import Firedancer.Lane.Mlir.fd_ed25519_lane_point_dbl
public import Firedancer.Lane.Mlir.fd_ed25519_lane_point_add_sel
public import Firedancer.Lane.Mlir.fd_ed25519_lane_point_add_sel

namespace Firedancer.Lane.Mlir

@[expose] public section

noncomputable mlir_def verify_x8 (batch : MLIR.Vals [.bv 64, .ptr, .ptr, .ptr] → MLIR.EffectM (MLIR.Vals [])) := "llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.writeonly}, {llvm.noundef, llvm.range = #llvm.constant_range<i64, 3, 0>}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<void (ptr, ptr, ptr, ptr, ptr, ptr, i64)>, linkage = #llvm.linkage<internal>, no_unwind, passthrough = ["sspstrong", ["min-legal-vector-width", "512"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "znver4"]], sym_name = "verify_x8", target_cpu = "znver4", target_features = #llvm.target_features<["+64bit", "+adx", "+aes", "+avx", "+avx2", "+avx512bf16", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+clzero", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fast-vector-fsqrt", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+mwaitx", "+pclmul", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdpru", "+rdrnd", "+rdseed", "+sahf", "+sha", "+shstk", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+sse4a", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tile", "-avx10.1", "-avx10.2", "-avx512bmm", "-avx512fp16", "-avx512vp2intersect", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-ccmp", "-cf", "-cldemote", "-cmpccxadd", "-egpr", "-enqcmd", "-fma4", "-hreset", "-jmpabs", "-kl", "-lwp", "-movdir64b", "-movdiri", "-movrs", "-ndd", "-nf", "-pconfig", "-ppx", "-prefetchi", "-ptwrite", "-push2pop2", "-raoint", "-rtm", "-serialize", "-sgx", "-sha512", "-sm3", "-sm4", "-tbm", "-tsxldtrk", "-uintr", "-usermsr", "-waitpkg", "-widekl", "-xop", "-zu"]>, tune_cpu = "znver4", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg0: !llvm.ptr, %arg1: !llvm.ptr, %arg2: !llvm.ptr, %arg3: !llvm.ptr, %arg4: !llvm.ptr, %arg5: !llvm.ptr, %arg6: i64):
  %0 = "llvm.mlir.constant"() <{value = -3 : i32}> : () -> i32
  %1 = "llvm.mlir.constant"() <{value = dense<-3> : vector<8xi32>}> : () -> vector<8xi32>
  %2 = "llvm.mlir.constant"() <{value = dense<64> : vector<16xi32>}> : () -> vector<16xi32>
  %3 = "llvm.mlir.constant"() <{value = dense<-3> : vector<16xi32>}> : () -> vector<16xi32>
  %4 = "llvm.mlir.constant"() <{value = dense<48> : vector<16xi32>}> : () -> vector<16xi32>
  %5 = "llvm.mlir.constant"() <{value = -64 : i64}> : () -> i64
  %6 = "llvm.mlir.constant"() <{value = -1 : i64}> : () -> i64
  %7 = "llvm.mlir.addressof"() <{global_name = @fd_ed25519_lane_base_table}> : () -> !llvm.ptr
  %8 = "llvm.mlir.constant"() <{value = dense<160> : vector<8xi32>}> : () -> vector<8xi32>
  %9 = "llvm.mlir.constant"() <{value = 0 : i16}> : () -> i16
  %10 = "llvm.mlir.constant"() <{value = 2147483647 : i64}> : () -> i64
  %11 = "llvm.mlir.constant"() <{value = 696 : i64}> : () -> i64
  %12 = "llvm.mlir.constant"() <{value = 1016 : i64}> : () -> i64
  %13 = "llvm.mlir.constant"() <{value = 688 : i64}> : () -> i64
  %14 = "llvm.mlir.constant"() <{value = 1008 : i64}> : () -> i64
  %15 = "llvm.mlir.constant"() <{value = 680 : i64}> : () -> i64
  %16 = "llvm.mlir.constant"() <{value = 1000 : i64}> : () -> i64
  %17 = "llvm.mlir.constant"() <{value = 672 : i64}> : () -> i64
  %18 = "llvm.mlir.constant"() <{value = 992 : i64}> : () -> i64
  %19 = "llvm.mlir.constant"() <{value = 664 : i64}> : () -> i64
  %20 = "llvm.mlir.constant"() <{value = 984 : i64}> : () -> i64
  %21 = "llvm.mlir.constant"() <{value = 656 : i64}> : () -> i64
  %22 = "llvm.mlir.constant"() <{value = 976 : i64}> : () -> i64
  %23 = "llvm.mlir.constant"() <{value = 648 : i64}> : () -> i64
  %24 = "llvm.mlir.constant"() <{value = 968 : i64}> : () -> i64
  %25 = "llvm.mlir.constant"() <{value = dense<[3934839304537, 507525298899, 15037786634, 521695520920, 6596238350568, 309467527341, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %26 = "llvm.mlir.constant"() <{value = dense<"0x01000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000001"> : vector<505xi1>}> : () -> vector<505xi1>
  %27 = "llvm.mlir.poison"() : () -> vector<64xi8>
  %28 = "llvm.mlir.constant"() <{value = 15 : i64}> : () -> i64
  %29 = "llvm.mlir.constant"() <{value = 10 : i64}> : () -> i64
  %30 = "llvm.mlir.constant"() <{value = 65280 : i32}> : () -> i32
  %31 = "llvm.mlir.constant"() <{value = 768 : i32}> : () -> i32
  %32 = "llvm.mlir.constant"() <{value = 256 : i32}> : () -> i32
  %33 = "llvm.mlir.constant"() <{value = 4 : i8}> : () -> i8
  %34 = "llvm.mlir.constant"() <{value = 240 : i32}> : () -> i32
  %35 = "llvm.mlir.constant"() <{value = 15 : i8}> : () -> i8
  %36 = "llvm.mlir.constant"() <{value = dense<9007199254740916> : vector<8xi64>}> : () -> vector<8xi64>
  %37 = "llvm.mlir.constant"() <{value = 1233 : i64}> : () -> i64
  %38 = "llvm.mlir.constant"() <{value = -2 : i32}> : () -> i32
  %39 = "llvm.mlir.constant"() <{value = dense<8> : vector<8xi32>}> : () -> vector<8xi32>
  %40 = "llvm.mlir.constant"() <{value = dense<-1> : vector<8xi32>}> : () -> vector<8xi32>
  %41 = "llvm.mlir.constant"() <{value = dense<-2> : vector<8xi32>}> : () -> vector<8xi32>
  %42 = "llvm.mlir.constant"() <{value = dense<false> : vector<8xi1>}> : () -> vector<8xi1>
  %43 = "llvm.mlir.constant"() <{value = dense<true> : vector<8xi1>}> : () -> vector<8xi1>
  %44 = "llvm.mlir.constant"() <{value = dense<0> : vector<8xi32>}> : () -> vector<8xi32>
  %45 = "llvm.mlir.constant"() <{value = dense<1> : vector<8xi32>}> : () -> vector<8xi32>
  %46 = "llvm.mlir.constant"() <{value = dense<[0, 1, 2, 3, 4, 5, 6, 7]> : vector<8xi32>}> : () -> vector<8xi32>
  %47 = "llvm.mlir.poison"() : () -> vector<8xi32>
  %48 = "llvm.mlir.constant"() <{value = 7 : i32}> : () -> i32
  %49 = "llvm.mlir.constant"() <{value = 6 : i32}> : () -> i32
  %50 = "llvm.mlir.constant"() <{value = 5 : i32}> : () -> i32
  %51 = "llvm.mlir.constant"() <{value = 3 : i32}> : () -> i32
  %52 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %53 = "llvm.mlir.constant"() <{value = 0 : i8}> : () -> i8
  %54 = "llvm.mlir.constant"() <{value = 256 : i64}> : () -> i64
  %55 = "llvm.mlir.constant"() <{value = -1 : i32}> : () -> i32
  %56 = "llvm.mlir.constant"() <{value = 32 : i64}> : () -> i64
  %57 = "llvm.mlir.constant"() <{value = 63 : i64}> : () -> i64
  %58 = "llvm.mlir.constant"() <{value = 16 : i8}> : () -> i8
  %59 = "llvm.mlir.constant"() <{value = 32 : i8}> : () -> i8
  %60 = "llvm.mlir.addressof"() <{global_name = @verify_x8.identity}> : () -> !llvm.ptr
  %61 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %62 = "llvm.mlir.constant"() <{value = 56 : i64}> : () -> i64
  %63 = "llvm.mlir.constant"() <{value = 1 : i8}> : () -> i8
  %64 = "llvm.mlir.constant"() <{value = 6346243789798364140 : i64}> : () -> i64
  %65 = "llvm.mlir.constant"() <{value = 1503914060200516822 : i64}> : () -> i64
  %66 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %67 = "llvm.mlir.constant"() <{value = 1152921504606846976 : i64}> : () -> i64
  %68 = "llvm.mlir.constant"() <{value = 4 : i64}> : () -> i64
  %69 = "llvm.mlir.constant"() <{value = 8 : i64}> : () -> i64
  %70 = "llvm.mlir.constant"() <{value = 2 : i32}> : () -> i32
  %71 = "llvm.mlir.constant"() <{value = 4 : i32}> : () -> i32
  %72 = "llvm.mlir.constant"() <{value = 3 : i64}> : () -> i64
  %73 = "llvm.mlir.constant"() <{value = 24 : i64}> : () -> i64
  %74 = "llvm.mlir.constant"() <{value = 8 : i32}> : () -> i32
  %75 = "llvm.mlir.constant"() <{value = 16 : i32}> : () -> i32
  %76 = "llvm.mlir.constant"() <{value = 5 : i64}> : () -> i64
  %77 = "llvm.mlir.constant"() <{value = 32 : i32}> : () -> i32
  %78 = "llvm.mlir.constant"() <{value = 6 : i64}> : () -> i64
  %79 = "llvm.mlir.constant"() <{value = 64 : i32}> : () -> i32
  %80 = "llvm.mlir.constant"() <{value = 7 : i64}> : () -> i64
  %81 = "llvm.mlir.constant"() <{value = 128 : i32}> : () -> i32
  %82 = "llvm.mlir.constant"() <{value = 320 : i64}> : () -> i64
  %83 = "llvm.mlir.constant"() <{value = dense<[6365466163363, 253762649449, 7518893317, 260847760460, 7696165686388, 704489577558, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %84 = "llvm.mlir.constant"() <{value = dense<[3467281080496, 6582290652611, 5210002954932, 329084955603, 4526638806224, 373767602335, 0, 0]> : vector<8xi64>}> : () -> vector<8xi64>
  %85 = "llvm.mlir.constant"() <{value = 64 : i64}> : () -> i64
  %86 = "llvm.mlir.constant"() <{value = true}> : () -> i1
  %87 = "llvm.mlir.poison"() : () -> vector<8xi64>
  %88 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %89 = "llvm.mlir.constant"() <{value = 2 : i64}> : () -> i64
  %90 = "llvm.mlir.constant"() <{value = dense<[62, 61, 60, 59, 58, 57, 56, 63]> : vector<8xi64>}> : () -> vector<8xi64>
  %91 = "llvm.mlir.constant"() <{value = dense<[2, 4, 8, 16, 32, 64, 128, 4294967295]> : vector<8xi64>}> : () -> vector<8xi64>
  %92 = "llvm.mlir.constant"() <{value = 960 : i64}> : () -> i64
  %93 = "llvm.mlir.constant"() <{value = 640 : i64}> : () -> i64
  %94 = "llvm.mlir.constant"() <{value = dense<0> : vector<8xi64>}> : () -> vector<8xi64>
  %95 = "llvm.mlir.constant"() <{value = dense<1> : vector<8xi64>}> : () -> vector<8xi64>
  %96 = "llvm.mlir.constant"() <{value = dense<2251799813685247> : vector<8xi64>}> : () -> vector<8xi64>
  %97 = "llvm.mlir.constant"() <{value = dense<3> : vector<8xi64>}> : () -> vector<8xi64>
  %98 = "llvm.mlir.constant"() <{value = dense<6> : vector<8xi64>}> : () -> vector<8xi64>
  %99 = "llvm.mlir.constant"() <{value = 576 : i64}> : () -> i64
  %100 = "llvm.mlir.constant"() <{value = dense<12> : vector<8xi64>}> : () -> vector<8xi64>
  %101 = "llvm.mlir.constant"() <{value = dense<2> : vector<8xi64>}> : () -> vector<8xi64>
  %102 = "llvm.mlir.constant"() <{value = dense<38> : vector<8xi64>}> : () -> vector<8xi64>
  %103 = "llvm.mlir.constant"() <{value = dense<19> : vector<8xi64>}> : () -> vector<8xi64>
  %104 = "llvm.mlir.constant"() <{value = dense<51> : vector<8xi64>}> : () -> vector<8xi64>
  %105 = "llvm.mlir.constant"() <{value = dense<9007199254740915> : vector<8xi64>}> : () -> vector<8xi64>
  %106 = "llvm.mlir.constant"() <{value = dense<9007199254740988> : vector<8xi64>}> : () -> vector<8xi64>
  %107 = "llvm.mlir.constant"() <{value = false}> : () -> i1
  %108 = "llvm.mlir.constant"() <{value = dense<4503599627370458> : vector<8xi64>}> : () -> vector<8xi64>
  %109 = "llvm.mlir.constant"() <{value = dense<4503599627370494> : vector<8xi64>}> : () -> vector<8xi64>
  %110 = "llvm.mlir.constant"() <{value = dense<2251799813685229> : vector<8xi64>}> : () -> vector<8xi64>
  %111 = "llvm.mlir.constant"() <{value = -1 : i8}> : () -> i8
  %112 = "llvm.mlir.constant"() <{value = dense<2251799813685228> : vector<8xi64>}> : () -> vector<8xi64>
  %113 = "llvm.mlir.constant"() <{value = -32 : i64}> : () -> i64
  %114 = "llvm.mlir.poison"() : () -> vector<16xi32>
  %115 = "llvm.mlir.constant"() <{value = dense<0> : vector<16xi32>}> : () -> vector<16xi32>
  %116 = "llvm.mlir.constant"() <{value = dense<[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]> : vector<16xi32>}> : () -> vector<16xi32>
  %117 = "llvm.mlir.constant"() <{value = dense<16> : vector<16xi32>}> : () -> vector<16xi32>
  %118 = "llvm.mlir.constant"() <{value = dense<1> : vector<16xi32>}> : () -> vector<16xi32>
  %119 = "llvm.mlir.constant"() <{value = dense<true> : vector<16xi1>}> : () -> vector<16xi1>
  %120 = "llvm.mlir.constant"() <{value = dense<false> : vector<16xi1>}> : () -> vector<16xi1>
  %121 = "llvm.mlir.constant"() <{value = dense<-2> : vector<16xi32>}> : () -> vector<16xi32>
  %122 = "llvm.mlir.constant"() <{value = dense<-1> : vector<16xi32>}> : () -> vector<16xi32>
  %123 = "llvm.mlir.constant"() <{value = dense<32> : vector<16xi32>}> : () -> vector<16xi32>
  %124 = "llvm.mlir.constant"() <{value = -8 : i64}> : () -> i64
  %125 = "llvm.mlir.poison"() : () -> i32
  %126 = "llvm.mlir.undef"() : () -> vector<8xi32>
  %127 = "llvm.insertelement"(%126, %125, %61) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %128 = "llvm.insertelement"(%127, %61, %52) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %129 = "llvm.insertelement"(%128, %61, %70) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %130 = "llvm.insertelement"(%129, %61, %51) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %131 = "llvm.insertelement"(%130, %61, %71) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %132 = "llvm.insertelement"(%131, %61, %50) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %133 = "llvm.insertelement"(%132, %61, %49) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %134 = "llvm.insertelement"(%133, %61, %48) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %135 = "llvm.alloca"(%52) <{alignment = 16 : i64, elem_type = !llvm.array<64 x array<8 x i8>>}> : (i32) -> !llvm.ptr
  %136 = "llvm.alloca"(%52) <{alignment = 16 : i64, elem_type = !llvm.array<32 x array<8 x i16>>}> : (i32) -> !llvm.ptr
  %137 = "llvm.alloca"(%52) <{alignment = 16 : i64, elem_type = !llvm.array<64 x i8>}> : (i32) -> !llvm.ptr
  %138 = "llvm.alloca"(%52) <{alignment = 64 : i64, elem_type = !llvm.array<9 x array<200 x i64>>}> : (i32) -> !llvm.ptr
  %139 = "llvm.alloca"(%52) <{alignment = 64 : i64, elem_type = !llvm.struct<"struct.fd_ed25519_lane_fe", (array<5 x vector<8xi64>>)>}> : (i32) -> !llvm.ptr
  %140 = "llvm.alloca"(%52) <{alignment = 64 : i64, elem_type = !llvm.struct<"struct.fd_ed25519_lane_niels", (struct<"struct.fd_ed25519_lane_fe", (array<5 x vector<8xi64>>)>, struct<"struct.fd_ed25519_lane_fe", (array<5 x vector<8xi64>>)>, struct<"struct.fd_ed25519_lane_fe", (array<5 x vector<8xi64>>)>, struct<"struct.fd_ed25519_lane_fe", (array<5 x vector<8xi64>>)>, struct<"struct.fd_ed25519_lane_fe", (array<5 x vector<8xi64>>)>)>}> : (i32) -> !llvm.ptr
  %141 = "llvm.alloca"(%52) <{alignment = 64 : i64, elem_type = !llvm.struct<"struct.fd_ed25519_lane_point", (struct<"struct.fd_ed25519_lane_fe", (array<5 x vector<8xi64>>)>, struct<"struct.fd_ed25519_lane_fe", (array<5 x vector<8xi64>>)>, struct<"struct.fd_ed25519_lane_fe", (array<5 x vector<8xi64>>)>, struct<"struct.fd_ed25519_lane_fe", (array<5 x vector<8xi64>>)>)>}> : (i32) -> !llvm.ptr
  %142 = "llvm.alloca"(%52) <{alignment = 64 : i64, elem_type = !llvm.struct<"struct.fd_ed25519_lane_point", (struct<"struct.fd_ed25519_lane_fe", (array<5 x vector<8xi64>>)>, struct<"struct.fd_ed25519_lane_fe", (array<5 x vector<8xi64>>)>, struct<"struct.fd_ed25519_lane_fe", (array<5 x vector<8xi64>>)>, struct<"struct.fd_ed25519_lane_fe", (array<5 x vector<8xi64>>)>)>}> : (i32) -> !llvm.ptr
  %143 = "llvm.alloca"(%52) <{alignment = 64 : i64, elem_type = !llvm.struct<"struct.fd_ed25519_lane_point", (struct<"struct.fd_ed25519_lane_fe", (array<5 x vector<8xi64>>)>, struct<"struct.fd_ed25519_lane_fe", (array<5 x vector<8xi64>>)>, struct<"struct.fd_ed25519_lane_fe", (array<5 x vector<8xi64>>)>, struct<"struct.fd_ed25519_lane_fe", (array<5 x vector<8xi64>>)>)>}> : (i32) -> !llvm.ptr
  %144 = "llvm.alloca"(%52) <{alignment = 64 : i64, elem_type = !llvm.struct<"struct.fd_ed25519_lane_point", (struct<"struct.fd_ed25519_lane_fe", (array<5 x vector<8xi64>>)>, struct<"struct.fd_ed25519_lane_fe", (array<5 x vector<8xi64>>)>, struct<"struct.fd_ed25519_lane_fe", (array<5 x vector<8xi64>>)>, struct<"struct.fd_ed25519_lane_fe", (array<5 x vector<8xi64>>)>)>}> : (i32) -> !llvm.ptr
  %145 = "llvm.alloca"(%52) <{alignment = 64 : i64, elem_type = !llvm.struct<"struct.fd_ed25519_lane_point", (struct<"struct.fd_ed25519_lane_fe", (array<5 x vector<8xi64>>)>, struct<"struct.fd_ed25519_lane_fe", (array<5 x vector<8xi64>>)>, struct<"struct.fd_ed25519_lane_fe", (array<5 x vector<8xi64>>)>, struct<"struct.fd_ed25519_lane_fe", (array<5 x vector<8xi64>>)>)>}> : (i32) -> !llvm.ptr
  %146 = "llvm.alloca"(%52) <{alignment = 64 : i64, elem_type = !llvm.struct<"struct.fd_ed25519_lane_point", (struct<"struct.fd_ed25519_lane_fe", (array<5 x vector<8xi64>>)>, struct<"struct.fd_ed25519_lane_fe", (array<5 x vector<8xi64>>)>, struct<"struct.fd_ed25519_lane_fe", (array<5 x vector<8xi64>>)>, struct<"struct.fd_ed25519_lane_fe", (array<5 x vector<8xi64>>)>)>}> : (i32) -> !llvm.ptr
  %147 = "llvm.alloca"(%52) <{alignment = 16 : i64, elem_type = !llvm.array<8 x ptr>}> : (i32) -> !llvm.ptr
  %148 = "llvm.alloca"(%52) <{alignment = 16 : i64, elem_type = !llvm.array<8 x ptr>}> : (i32) -> !llvm.ptr
  %149 = "llvm.alloca"(%52) <{alignment = 16 : i64, elem_type = !llvm.array<8 x ptr>}> : (i32) -> !llvm.ptr
  %150 = "llvm.alloca"(%52) <{alignment = 16 : i64, elem_type = !llvm.array<8 x ptr>}> : (i32) -> !llvm.ptr
  %151 = "llvm.alloca"(%52) <{alignment = 16 : i64, elem_type = !llvm.ptr}> : (i32) -> !llvm.ptr
  %152 = "llvm.alloca"(%52) <{alignment = 8 : i64, elem_type = !llvm.ptr}> : (i32) -> !llvm.ptr
  %153 = "llvm.alloca"(%52) <{alignment = 64 : i64, elem_type = !llvm.array<2 x struct<"struct.fd_ed25519_lane_fe", (array<5 x vector<8xi64>>)>>}> : (i32) -> !llvm.ptr
  %154 = "llvm.alloca"(%52) <{alignment = 64 : i64, elem_type = !llvm.array<2 x struct<"struct.fd_ed25519_lane_fe", (array<5 x vector<8xi64>>)>>}> : (i32) -> !llvm.ptr
  %155 = "llvm.alloca"(%52) <{alignment = 64 : i64, elem_type = !llvm.array<2 x struct<"struct.fd_ed25519_lane_fe", (array<5 x vector<8xi64>>)>>}> : (i32) -> !llvm.ptr
  %156 = "llvm.alloca"(%52) <{alignment = 64 : i64, elem_type = !llvm.array<2 x struct<"struct.fd_ed25519_lane_fe", (array<5 x vector<8xi64>>)>>}> : (i32) -> !llvm.ptr
  %157 = "llvm.alloca"(%52) <{alignment = 64 : i64, elem_type = !llvm.struct<"struct.fd_ed25519_lane_fe", (array<5 x vector<8xi64>>)>}> : (i32) -> !llvm.ptr
  %158 = "llvm.alloca"(%52) <{alignment = 64 : i64, elem_type = !llvm.struct<"struct.fd_ed25519_lane_fe", (array<5 x vector<8xi64>>)>}> : (i32) -> !llvm.ptr
  %159 = "llvm.alloca"(%52) <{alignment = 4 : i64, elem_type = i32}> : (i32) -> !llvm.ptr
  %160 = "llvm.alloca"(%52) <{alignment = 4 : i64, elem_type = i32}> : (i32) -> !llvm.ptr
  %161 = "llvm.alloca"(%52) <{alignment = 16 : i64, elem_type = !llvm.array<8 x array<32 x i8>>}> : (i32) -> !llvm.ptr
  %162 = "llvm.alloca"(%52) <{alignment = 16 : i64, elem_type = !llvm.array<8 x array<32 x i8>>}> : (i32) -> !llvm.ptr
  %163 = "llvm.alloca"(%52) <{alignment = 64 : i64, elem_type = !llvm.struct<"struct.fd_ed25519_lane_point", (struct<"struct.fd_ed25519_lane_fe", (array<5 x vector<8xi64>>)>, struct<"struct.fd_ed25519_lane_fe", (array<5 x vector<8xi64>>)>, struct<"struct.fd_ed25519_lane_fe", (array<5 x vector<8xi64>>)>, struct<"struct.fd_ed25519_lane_fe", (array<5 x vector<8xi64>>)>)>}> : (i32) -> !llvm.ptr
  %164 = "llvm.alloca"(%52) <{alignment = 64 : i64, elem_type = !llvm.struct<"struct.fd_ed25519_lane_point", (struct<"struct.fd_ed25519_lane_fe", (array<5 x vector<8xi64>>)>, struct<"struct.fd_ed25519_lane_fe", (array<5 x vector<8xi64>>)>, struct<"struct.fd_ed25519_lane_fe", (array<5 x vector<8xi64>>)>, struct<"struct.fd_ed25519_lane_fe", (array<5 x vector<8xi64>>)>)>}> : (i32) -> !llvm.ptr
  %165 = "llvm.alloca"(%52) <{alignment = 16 : i64, elem_type = !llvm.array<8 x array<1296 x i8>>}> : (i32) -> !llvm.ptr
  %166 = "llvm.alloca"(%52) <{alignment = 16 : i64, elem_type = !llvm.array<8 x array<64 x i8>>}> : (i32) -> !llvm.ptr
  %167 = "llvm.alloca"(%52) <{alignment = 128 : i64, elem_type = !llvm.array<1 x struct<"struct.fd_sha512_private_batch", (array<8 x ptr>, array<8 x i64>, array<8 x ptr>, i64, array<56 x i8>)>>}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%161) : (!llvm.ptr) -> ()
  "llvm.intr.memset"(%161, %53, %54) <{arg_attrs = [{llvm.align = 16 : i64, llvm.dereferenceable = 256 : i64, llvm.nonnull, llvm.noundef}, {}, {}], isVolatile = false}> : (!llvm.ptr, i8, i64) -> ()
  "llvm.intr.lifetime.start"(%162) : (!llvm.ptr) -> ()
  "llvm.intr.memset"(%162, %53, %54) <{arg_attrs = [{llvm.align = 16 : i64, llvm.dereferenceable = 256 : i64, llvm.nonnull, llvm.noundef}, {}, {}], isVolatile = false}> : (!llvm.ptr, i8, i64) -> ()
  "llvm.store"(%55, %arg5) <{alignment = 4 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i32, !llvm.ptr) -> ()
  %168 = "llvm.load"(%arg2) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 omnipotent char", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 omnipotent char", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> !llvm.ptr
  %169 = "llvm.getelementptr"(%168) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %170 = "llvm.getelementptr"(%168) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 63>}> : (!llvm.ptr) -> !llvm.ptr
  %171 = "llvm.load"(%170) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %172 = "llvm.icmp"(%171, %58) <{predicate = 6 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%172)[^bb3, ^bb1] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb1:  // pred: ^bb0
  %173 = "llvm.icmp"(%171, %59) <{predicate = 6 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%173, %60, %60, %61)[^bb2, ^bb4] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 0, 3>}> : (i1, !llvm.ptr, !llvm.ptr, i32) -> ()
^bb2:  // pred: ^bb1
  %174 = "llvm.load"(%169) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %175 = "llvm.getelementptr"(%168) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 40>}> : (!llvm.ptr) -> !llvm.ptr
  %176 = "llvm.load"(%175) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %177 = "llvm.getelementptr"(%168) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 48>}> : (!llvm.ptr) -> !llvm.ptr
  %178 = "llvm.load"(%177) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %179 = "llvm.getelementptr"(%168) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 56>}> : (!llvm.ptr) -> !llvm.ptr
  %180 = "llvm.load"(%179) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %181 = "llvm.call_intrinsic"(%63, %174, %64) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.subborrow.64", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (i8, i64, i64) -> !llvm.struct<(i8, i64)>
  %182 = "llvm.extractvalue"(%181) <{position = array<i64: 0>}> : (!llvm.struct<(i8, i64)>) -> i8
  %183 = "llvm.call_intrinsic"(%182, %176, %65) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.subborrow.64", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (i8, i64, i64) -> !llvm.struct<(i8, i64)>
  %184 = "llvm.extractvalue"(%183) <{position = array<i64: 0>}> : (!llvm.struct<(i8, i64)>) -> i8
  %185 = "llvm.call_intrinsic"(%184, %178, %66) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.subborrow.64", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (i8, i64, i64) -> !llvm.struct<(i8, i64)>
  %186 = "llvm.extractvalue"(%185) <{position = array<i64: 0>}> : (!llvm.struct<(i8, i64)>) -> i8
  %187 = "llvm.call_intrinsic"(%186, %180, %67) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.subborrow.64", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (i8, i64, i64) -> !llvm.struct<(i8, i64)>
  %188 = "llvm.extractvalue"(%187) <{position = array<i64: 0>}> : (!llvm.struct<(i8, i64)>) -> i8
  %189 = "llvm.icmp"(%188, %53) <{predicate = 0 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%189, %60, %60, %61)[^bb4, ^bb3] <{operandSegmentSizes = array<i32: 1, 3, 0>}> : (i1, !llvm.ptr, !llvm.ptr, i32) -> ()
^bb3:  // 2 preds: ^bb0, ^bb2
  %190 = "llvm.load"(%arg3) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 omnipotent char", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 omnipotent char", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.br"(%190, %168, %52)[^bb4] : (!llvm.ptr, !llvm.ptr, i32) -> ()
^bb4(%191: !llvm.ptr, %192: !llvm.ptr, %193: i32):  // 3 preds: ^bb1, ^bb2, ^bb3
  %194 = "llvm.getelementptr"(%arg5) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 4>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%55, %194) <{alignment = 4 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i32, !llvm.ptr) -> ()
  %195 = "llvm.getelementptr"(%arg2) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %196 = "llvm.load"(%195) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 omnipotent char", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 omnipotent char", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> !llvm.ptr
  %197 = "llvm.getelementptr"(%196) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %198 = "llvm.getelementptr"(%196) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 63>}> : (!llvm.ptr) -> !llvm.ptr
  %199 = "llvm.load"(%198) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %200 = "llvm.icmp"(%199, %58) <{predicate = 6 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%200)[^bb7, ^bb5] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb5:  // pred: ^bb4
  %201 = "llvm.icmp"(%199, %59) <{predicate = 6 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%201, %60, %60, %193)[^bb6, ^bb8] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 0, 3>}> : (i1, !llvm.ptr, !llvm.ptr, i32) -> ()
^bb6:  // pred: ^bb5
  %202 = "llvm.load"(%197) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %203 = "llvm.getelementptr"(%196) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 40>}> : (!llvm.ptr) -> !llvm.ptr
  %204 = "llvm.load"(%203) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %205 = "llvm.getelementptr"(%196) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 48>}> : (!llvm.ptr) -> !llvm.ptr
  %206 = "llvm.load"(%205) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %207 = "llvm.getelementptr"(%196) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 56>}> : (!llvm.ptr) -> !llvm.ptr
  %208 = "llvm.load"(%207) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %209 = "llvm.call_intrinsic"(%63, %202, %64) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.subborrow.64", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (i8, i64, i64) -> !llvm.struct<(i8, i64)>
  %210 = "llvm.extractvalue"(%209) <{position = array<i64: 0>}> : (!llvm.struct<(i8, i64)>) -> i8
  %211 = "llvm.call_intrinsic"(%210, %204, %65) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.subborrow.64", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (i8, i64, i64) -> !llvm.struct<(i8, i64)>
  %212 = "llvm.extractvalue"(%211) <{position = array<i64: 0>}> : (!llvm.struct<(i8, i64)>) -> i8
  %213 = "llvm.call_intrinsic"(%212, %206, %66) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.subborrow.64", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (i8, i64, i64) -> !llvm.struct<(i8, i64)>
  %214 = "llvm.extractvalue"(%213) <{position = array<i64: 0>}> : (!llvm.struct<(i8, i64)>) -> i8
  %215 = "llvm.call_intrinsic"(%214, %208, %67) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.subborrow.64", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (i8, i64, i64) -> !llvm.struct<(i8, i64)>
  %216 = "llvm.extractvalue"(%215) <{position = array<i64: 0>}> : (!llvm.struct<(i8, i64)>) -> i8
  %217 = "llvm.icmp"(%216, %53) <{predicate = 0 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%217, %60, %60, %193)[^bb8, ^bb7] <{operandSegmentSizes = array<i32: 1, 3, 0>}> : (i1, !llvm.ptr, !llvm.ptr, i32) -> ()
^bb7:  // 2 preds: ^bb4, ^bb6
  %218 = "llvm.getelementptr"(%arg3) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %219 = "llvm.load"(%218) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 omnipotent char", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 omnipotent char", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> !llvm.ptr
  %220 = "llvm.or"(%193, %70) <{isDisjoint}> : (i32, i32) -> i32
  "llvm.br"(%219, %196, %220)[^bb8] : (!llvm.ptr, !llvm.ptr, i32) -> ()
^bb8(%221: !llvm.ptr, %222: !llvm.ptr, %223: i32):  // 3 preds: ^bb5, ^bb6, ^bb7
  %224 = "llvm.getelementptr"(%arg5) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%55, %224) <{alignment = 4 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i32, !llvm.ptr) -> ()
  %225 = "llvm.getelementptr"(%arg2) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %226 = "llvm.load"(%225) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 omnipotent char", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 omnipotent char", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> !llvm.ptr
  %227 = "llvm.getelementptr"(%226) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %228 = "llvm.getelementptr"(%226) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 63>}> : (!llvm.ptr) -> !llvm.ptr
  %229 = "llvm.load"(%228) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %230 = "llvm.icmp"(%229, %58) <{predicate = 6 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%230)[^bb11, ^bb9] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb9:  // pred: ^bb8
  %231 = "llvm.icmp"(%229, %59) <{predicate = 6 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%231, %60, %60, %223)[^bb10, ^bb12] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 0, 3>}> : (i1, !llvm.ptr, !llvm.ptr, i32) -> ()
^bb10:  // pred: ^bb9
  %232 = "llvm.load"(%227) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %233 = "llvm.getelementptr"(%226) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 40>}> : (!llvm.ptr) -> !llvm.ptr
  %234 = "llvm.load"(%233) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %235 = "llvm.getelementptr"(%226) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 48>}> : (!llvm.ptr) -> !llvm.ptr
  %236 = "llvm.load"(%235) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %237 = "llvm.getelementptr"(%226) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 56>}> : (!llvm.ptr) -> !llvm.ptr
  %238 = "llvm.load"(%237) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %239 = "llvm.call_intrinsic"(%63, %232, %64) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.subborrow.64", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (i8, i64, i64) -> !llvm.struct<(i8, i64)>
  %240 = "llvm.extractvalue"(%239) <{position = array<i64: 0>}> : (!llvm.struct<(i8, i64)>) -> i8
  %241 = "llvm.call_intrinsic"(%240, %234, %65) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.subborrow.64", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (i8, i64, i64) -> !llvm.struct<(i8, i64)>
  %242 = "llvm.extractvalue"(%241) <{position = array<i64: 0>}> : (!llvm.struct<(i8, i64)>) -> i8
  %243 = "llvm.call_intrinsic"(%242, %236, %66) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.subborrow.64", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (i8, i64, i64) -> !llvm.struct<(i8, i64)>
  %244 = "llvm.extractvalue"(%243) <{position = array<i64: 0>}> : (!llvm.struct<(i8, i64)>) -> i8
  %245 = "llvm.call_intrinsic"(%244, %238, %67) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.subborrow.64", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (i8, i64, i64) -> !llvm.struct<(i8, i64)>
  %246 = "llvm.extractvalue"(%245) <{position = array<i64: 0>}> : (!llvm.struct<(i8, i64)>) -> i8
  %247 = "llvm.icmp"(%246, %53) <{predicate = 0 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%247, %60, %60, %223)[^bb12, ^bb11] <{operandSegmentSizes = array<i32: 1, 3, 0>}> : (i1, !llvm.ptr, !llvm.ptr, i32) -> ()
^bb11:  // 2 preds: ^bb8, ^bb10
  %248 = "llvm.getelementptr"(%arg3) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %249 = "llvm.load"(%248) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 omnipotent char", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 omnipotent char", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> !llvm.ptr
  %250 = "llvm.or"(%223, %71) : (i32, i32) -> i32
  "llvm.br"(%249, %226, %250)[^bb12] : (!llvm.ptr, !llvm.ptr, i32) -> ()
^bb12(%251: !llvm.ptr, %252: !llvm.ptr, %253: i32):  // 3 preds: ^bb9, ^bb10, ^bb11
  %254 = "llvm.icmp"(%arg6, %72) <{predicate = 8 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%254, %60, %60, %60, %60, %60, %60, %60, %60, %253)[^bb13, ^bb37] <{operandSegmentSizes = array<i32: 1, 0, 9>}> : (i1, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, i32) -> ()
^bb13:  // pred: ^bb12
  %255 = "llvm.getelementptr"(%arg5) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 12>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%55, %255) <{alignment = 4 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i32, !llvm.ptr) -> ()
  %256 = "llvm.getelementptr"(%arg2) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %257 = "llvm.load"(%256) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 omnipotent char", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 omnipotent char", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> !llvm.ptr
  %258 = "llvm.getelementptr"(%257) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %259 = "llvm.getelementptr"(%257) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 63>}> : (!llvm.ptr) -> !llvm.ptr
  %260 = "llvm.load"(%259) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %261 = "llvm.icmp"(%260, %58) <{predicate = 6 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%261)[^bb16, ^bb14] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb14:  // pred: ^bb13
  %262 = "llvm.icmp"(%260, %59) <{predicate = 6 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%262, %60, %60, %253)[^bb15, ^bb17] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 0, 3>}> : (i1, !llvm.ptr, !llvm.ptr, i32) -> ()
^bb15:  // pred: ^bb14
  %263 = "llvm.load"(%258) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %264 = "llvm.getelementptr"(%257) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 40>}> : (!llvm.ptr) -> !llvm.ptr
  %265 = "llvm.load"(%264) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %266 = "llvm.getelementptr"(%257) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 48>}> : (!llvm.ptr) -> !llvm.ptr
  %267 = "llvm.load"(%266) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %268 = "llvm.getelementptr"(%257) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 56>}> : (!llvm.ptr) -> !llvm.ptr
  %269 = "llvm.load"(%268) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %270 = "llvm.call_intrinsic"(%63, %263, %64) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.subborrow.64", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (i8, i64, i64) -> !llvm.struct<(i8, i64)>
  %271 = "llvm.extractvalue"(%270) <{position = array<i64: 0>}> : (!llvm.struct<(i8, i64)>) -> i8
  %272 = "llvm.call_intrinsic"(%271, %265, %65) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.subborrow.64", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (i8, i64, i64) -> !llvm.struct<(i8, i64)>
  %273 = "llvm.extractvalue"(%272) <{position = array<i64: 0>}> : (!llvm.struct<(i8, i64)>) -> i8
  %274 = "llvm.call_intrinsic"(%273, %267, %66) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.subborrow.64", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (i8, i64, i64) -> !llvm.struct<(i8, i64)>
  %275 = "llvm.extractvalue"(%274) <{position = array<i64: 0>}> : (!llvm.struct<(i8, i64)>) -> i8
  %276 = "llvm.call_intrinsic"(%275, %269, %67) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.subborrow.64", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (i8, i64, i64) -> !llvm.struct<(i8, i64)>
  %277 = "llvm.extractvalue"(%276) <{position = array<i64: 0>}> : (!llvm.struct<(i8, i64)>) -> i8
  %278 = "llvm.icmp"(%277, %53) <{predicate = 0 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%278, %60, %60, %253)[^bb17, ^bb16] <{operandSegmentSizes = array<i32: 1, 3, 0>}> : (i1, !llvm.ptr, !llvm.ptr, i32) -> ()
^bb16:  // 2 preds: ^bb13, ^bb15
  %279 = "llvm.getelementptr"(%arg3) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %280 = "llvm.load"(%279) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 omnipotent char", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 omnipotent char", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> !llvm.ptr
  %281 = "llvm.or"(%253, %74) : (i32, i32) -> i32
  "llvm.br"(%257, %280, %281)[^bb17] : (!llvm.ptr, !llvm.ptr, i32) -> ()
^bb17(%282: !llvm.ptr, %283: !llvm.ptr, %284: i32):  // 3 preds: ^bb14, ^bb15, ^bb16
  %285 = "llvm.icmp"(%arg6, %68) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%285, %60, %60, %60, %60, %282, %283, %60, %60, %284)[^bb37, ^bb18] <{operandSegmentSizes = array<i32: 1, 9, 0>}> : (i1, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, i32) -> ()
^bb18:  // pred: ^bb17
  %286 = "llvm.getelementptr"(%arg5) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%55, %286) <{alignment = 4 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i32, !llvm.ptr) -> ()
  %287 = "llvm.getelementptr"(%arg2) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %288 = "llvm.load"(%287) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 omnipotent char", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 omnipotent char", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> !llvm.ptr
  %289 = "llvm.getelementptr"(%288) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %290 = "llvm.getelementptr"(%288) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 63>}> : (!llvm.ptr) -> !llvm.ptr
  %291 = "llvm.load"(%290) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %292 = "llvm.icmp"(%291, %58) <{predicate = 6 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%292)[^bb21, ^bb19] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb19:  // pred: ^bb18
  %293 = "llvm.icmp"(%291, %59) <{predicate = 6 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%293, %60, %60, %284)[^bb20, ^bb22] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 0, 3>}> : (i1, !llvm.ptr, !llvm.ptr, i32) -> ()
^bb20:  // pred: ^bb19
  %294 = "llvm.load"(%289) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %295 = "llvm.getelementptr"(%288) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 40>}> : (!llvm.ptr) -> !llvm.ptr
  %296 = "llvm.load"(%295) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %297 = "llvm.getelementptr"(%288) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 48>}> : (!llvm.ptr) -> !llvm.ptr
  %298 = "llvm.load"(%297) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %299 = "llvm.getelementptr"(%288) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 56>}> : (!llvm.ptr) -> !llvm.ptr
  %300 = "llvm.load"(%299) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %301 = "llvm.call_intrinsic"(%63, %294, %64) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.subborrow.64", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (i8, i64, i64) -> !llvm.struct<(i8, i64)>
  %302 = "llvm.extractvalue"(%301) <{position = array<i64: 0>}> : (!llvm.struct<(i8, i64)>) -> i8
  %303 = "llvm.call_intrinsic"(%302, %296, %65) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.subborrow.64", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (i8, i64, i64) -> !llvm.struct<(i8, i64)>
  %304 = "llvm.extractvalue"(%303) <{position = array<i64: 0>}> : (!llvm.struct<(i8, i64)>) -> i8
  %305 = "llvm.call_intrinsic"(%304, %298, %66) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.subborrow.64", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (i8, i64, i64) -> !llvm.struct<(i8, i64)>
  %306 = "llvm.extractvalue"(%305) <{position = array<i64: 0>}> : (!llvm.struct<(i8, i64)>) -> i8
  %307 = "llvm.call_intrinsic"(%306, %300, %67) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.subborrow.64", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (i8, i64, i64) -> !llvm.struct<(i8, i64)>
  %308 = "llvm.extractvalue"(%307) <{position = array<i64: 0>}> : (!llvm.struct<(i8, i64)>) -> i8
  %309 = "llvm.icmp"(%308, %53) <{predicate = 0 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%309, %60, %60, %284)[^bb22, ^bb21] <{operandSegmentSizes = array<i32: 1, 3, 0>}> : (i1, !llvm.ptr, !llvm.ptr, i32) -> ()
^bb21:  // 2 preds: ^bb18, ^bb20
  %310 = "llvm.getelementptr"(%arg3) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %311 = "llvm.load"(%310) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 omnipotent char", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 omnipotent char", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> !llvm.ptr
  %312 = "llvm.or"(%284, %75) : (i32, i32) -> i32
  "llvm.br"(%288, %311, %312)[^bb22] : (!llvm.ptr, !llvm.ptr, i32) -> ()
^bb22(%313: !llvm.ptr, %314: !llvm.ptr, %315: i32):  // 3 preds: ^bb19, ^bb20, ^bb21
  %316 = "llvm.icmp"(%arg6, %76) <{predicate = 8 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%316, %60, %60, %314, %313, %282, %283, %60, %60, %315)[^bb23, ^bb37] <{operandSegmentSizes = array<i32: 1, 0, 9>}> : (i1, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, i32) -> ()
^bb23:  // pred: ^bb22
  %317 = "llvm.getelementptr"(%arg5) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 20>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%55, %317) <{alignment = 4 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i32, !llvm.ptr) -> ()
  %318 = "llvm.getelementptr"(%arg2) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 40>}> : (!llvm.ptr) -> !llvm.ptr
  %319 = "llvm.load"(%318) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 omnipotent char", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 omnipotent char", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> !llvm.ptr
  %320 = "llvm.getelementptr"(%319) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %321 = "llvm.getelementptr"(%319) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 63>}> : (!llvm.ptr) -> !llvm.ptr
  %322 = "llvm.load"(%321) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %323 = "llvm.icmp"(%322, %58) <{predicate = 6 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%323)[^bb26, ^bb24] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb24:  // pred: ^bb23
  %324 = "llvm.icmp"(%322, %59) <{predicate = 6 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%324, %60, %60, %315)[^bb25, ^bb27] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 0, 3>}> : (i1, !llvm.ptr, !llvm.ptr, i32) -> ()
^bb25:  // pred: ^bb24
  %325 = "llvm.load"(%320) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %326 = "llvm.getelementptr"(%319) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 40>}> : (!llvm.ptr) -> !llvm.ptr
  %327 = "llvm.load"(%326) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %328 = "llvm.getelementptr"(%319) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 48>}> : (!llvm.ptr) -> !llvm.ptr
  %329 = "llvm.load"(%328) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %330 = "llvm.getelementptr"(%319) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 56>}> : (!llvm.ptr) -> !llvm.ptr
  %331 = "llvm.load"(%330) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %332 = "llvm.call_intrinsic"(%63, %325, %64) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.subborrow.64", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (i8, i64, i64) -> !llvm.struct<(i8, i64)>
  %333 = "llvm.extractvalue"(%332) <{position = array<i64: 0>}> : (!llvm.struct<(i8, i64)>) -> i8
  %334 = "llvm.call_intrinsic"(%333, %327, %65) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.subborrow.64", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (i8, i64, i64) -> !llvm.struct<(i8, i64)>
  %335 = "llvm.extractvalue"(%334) <{position = array<i64: 0>}> : (!llvm.struct<(i8, i64)>) -> i8
  %336 = "llvm.call_intrinsic"(%335, %329, %66) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.subborrow.64", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (i8, i64, i64) -> !llvm.struct<(i8, i64)>
  %337 = "llvm.extractvalue"(%336) <{position = array<i64: 0>}> : (!llvm.struct<(i8, i64)>) -> i8
  %338 = "llvm.call_intrinsic"(%337, %331, %67) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.subborrow.64", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (i8, i64, i64) -> !llvm.struct<(i8, i64)>
  %339 = "llvm.extractvalue"(%338) <{position = array<i64: 0>}> : (!llvm.struct<(i8, i64)>) -> i8
  %340 = "llvm.icmp"(%339, %53) <{predicate = 0 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%340, %60, %60, %315)[^bb27, ^bb26] <{operandSegmentSizes = array<i32: 1, 3, 0>}> : (i1, !llvm.ptr, !llvm.ptr, i32) -> ()
^bb26:  // 2 preds: ^bb23, ^bb25
  %341 = "llvm.getelementptr"(%arg3) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 40>}> : (!llvm.ptr) -> !llvm.ptr
  %342 = "llvm.load"(%341) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 omnipotent char", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 omnipotent char", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> !llvm.ptr
  %343 = "llvm.or"(%315, %77) : (i32, i32) -> i32
  "llvm.br"(%319, %342, %343)[^bb27] : (!llvm.ptr, !llvm.ptr, i32) -> ()
^bb27(%344: !llvm.ptr, %345: !llvm.ptr, %346: i32):  // 3 preds: ^bb24, ^bb25, ^bb26
  %347 = "llvm.icmp"(%arg6, %78) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%347, %60, %60, %314, %313, %282, %283, %344, %345, %346)[^bb37, ^bb28] <{operandSegmentSizes = array<i32: 1, 9, 0>}> : (i1, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, i32) -> ()
^bb28:  // pred: ^bb27
  %348 = "llvm.getelementptr"(%arg5) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%55, %348) <{alignment = 4 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i32, !llvm.ptr) -> ()
  %349 = "llvm.getelementptr"(%arg2) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 48>}> : (!llvm.ptr) -> !llvm.ptr
  %350 = "llvm.load"(%349) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 omnipotent char", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 omnipotent char", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> !llvm.ptr
  %351 = "llvm.getelementptr"(%350) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %352 = "llvm.getelementptr"(%350) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 63>}> : (!llvm.ptr) -> !llvm.ptr
  %353 = "llvm.load"(%352) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %354 = "llvm.icmp"(%353, %58) <{predicate = 6 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%354)[^bb31, ^bb29] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb29:  // pred: ^bb28
  %355 = "llvm.icmp"(%353, %59) <{predicate = 6 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%355, %60, %60, %346)[^bb30, ^bb32] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 0, 3>}> : (i1, !llvm.ptr, !llvm.ptr, i32) -> ()
^bb30:  // pred: ^bb29
  %356 = "llvm.load"(%351) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %357 = "llvm.getelementptr"(%350) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 40>}> : (!llvm.ptr) -> !llvm.ptr
  %358 = "llvm.load"(%357) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %359 = "llvm.getelementptr"(%350) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 48>}> : (!llvm.ptr) -> !llvm.ptr
  %360 = "llvm.load"(%359) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %361 = "llvm.getelementptr"(%350) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 56>}> : (!llvm.ptr) -> !llvm.ptr
  %362 = "llvm.load"(%361) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %363 = "llvm.call_intrinsic"(%63, %356, %64) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.subborrow.64", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (i8, i64, i64) -> !llvm.struct<(i8, i64)>
  %364 = "llvm.extractvalue"(%363) <{position = array<i64: 0>}> : (!llvm.struct<(i8, i64)>) -> i8
  %365 = "llvm.call_intrinsic"(%364, %358, %65) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.subborrow.64", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (i8, i64, i64) -> !llvm.struct<(i8, i64)>
  %366 = "llvm.extractvalue"(%365) <{position = array<i64: 0>}> : (!llvm.struct<(i8, i64)>) -> i8
  %367 = "llvm.call_intrinsic"(%366, %360, %66) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.subborrow.64", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (i8, i64, i64) -> !llvm.struct<(i8, i64)>
  %368 = "llvm.extractvalue"(%367) <{position = array<i64: 0>}> : (!llvm.struct<(i8, i64)>) -> i8
  %369 = "llvm.call_intrinsic"(%368, %362, %67) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.subborrow.64", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (i8, i64, i64) -> !llvm.struct<(i8, i64)>
  %370 = "llvm.extractvalue"(%369) <{position = array<i64: 0>}> : (!llvm.struct<(i8, i64)>) -> i8
  %371 = "llvm.icmp"(%370, %53) <{predicate = 0 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%371, %60, %60, %346)[^bb32, ^bb31] <{operandSegmentSizes = array<i32: 1, 3, 0>}> : (i1, !llvm.ptr, !llvm.ptr, i32) -> ()
^bb31:  // 2 preds: ^bb28, ^bb30
  %372 = "llvm.getelementptr"(%arg3) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 48>}> : (!llvm.ptr) -> !llvm.ptr
  %373 = "llvm.load"(%372) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 omnipotent char", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 omnipotent char", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> !llvm.ptr
  %374 = "llvm.or"(%346, %79) : (i32, i32) -> i32
  "llvm.br"(%350, %373, %374)[^bb32] : (!llvm.ptr, !llvm.ptr, i32) -> ()
^bb32(%375: !llvm.ptr, %376: !llvm.ptr, %377: i32):  // 3 preds: ^bb29, ^bb30, ^bb31
  %378 = "llvm.icmp"(%arg6, %80) <{predicate = 8 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%378, %376, %375, %314, %313, %282, %283, %344, %345, %377)[^bb33, ^bb37] <{operandSegmentSizes = array<i32: 1, 0, 9>}> : (i1, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, i32) -> ()
^bb33:  // pred: ^bb32
  %379 = "llvm.getelementptr"(%arg5) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 28>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%55, %379) <{alignment = 4 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i32, !llvm.ptr) -> ()
  %380 = "llvm.getelementptr"(%arg2) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 56>}> : (!llvm.ptr) -> !llvm.ptr
  %381 = "llvm.load"(%380) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 omnipotent char", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 omnipotent char", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> !llvm.ptr
  %382 = "llvm.getelementptr"(%381) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %383 = "llvm.getelementptr"(%381) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 63>}> : (!llvm.ptr) -> !llvm.ptr
  %384 = "llvm.load"(%383) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %385 = "llvm.icmp"(%384, %58) <{predicate = 6 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%385)[^bb36, ^bb34] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb34:  // pred: ^bb33
  %386 = "llvm.icmp"(%384, %59) <{predicate = 6 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%386, %376, %375, %314, %313, %282, %283, %344, %345, %377)[^bb35, ^bb37] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 0, 9>}> : (i1, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, i32) -> ()
^bb35:  // pred: ^bb34
  %387 = "llvm.load"(%382) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %388 = "llvm.getelementptr"(%381) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 40>}> : (!llvm.ptr) -> !llvm.ptr
  %389 = "llvm.load"(%388) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %390 = "llvm.getelementptr"(%381) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 48>}> : (!llvm.ptr) -> !llvm.ptr
  %391 = "llvm.load"(%390) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %392 = "llvm.getelementptr"(%381) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 56>}> : (!llvm.ptr) -> !llvm.ptr
  %393 = "llvm.load"(%392) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %394 = "llvm.call_intrinsic"(%63, %387, %64) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.subborrow.64", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (i8, i64, i64) -> !llvm.struct<(i8, i64)>
  %395 = "llvm.extractvalue"(%394) <{position = array<i64: 0>}> : (!llvm.struct<(i8, i64)>) -> i8
  %396 = "llvm.call_intrinsic"(%395, %389, %65) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.subborrow.64", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (i8, i64, i64) -> !llvm.struct<(i8, i64)>
  %397 = "llvm.extractvalue"(%396) <{position = array<i64: 0>}> : (!llvm.struct<(i8, i64)>) -> i8
  %398 = "llvm.call_intrinsic"(%397, %391, %66) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.subborrow.64", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (i8, i64, i64) -> !llvm.struct<(i8, i64)>
  %399 = "llvm.extractvalue"(%398) <{position = array<i64: 0>}> : (!llvm.struct<(i8, i64)>) -> i8
  %400 = "llvm.call_intrinsic"(%399, %393, %67) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.subborrow.64", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (i8, i64, i64) -> !llvm.struct<(i8, i64)>
  %401 = "llvm.extractvalue"(%400) <{position = array<i64: 0>}> : (!llvm.struct<(i8, i64)>) -> i8
  %402 = "llvm.icmp"(%401, %53) <{predicate = 0 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%402, %376, %375, %314, %313, %282, %283, %344, %345, %377)[^bb37, ^bb36] <{operandSegmentSizes = array<i32: 1, 9, 0>}> : (i1, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, i32) -> ()
^bb36:  // 2 preds: ^bb33, ^bb35
  %403 = "llvm.getelementptr"(%arg3) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 56>}> : (!llvm.ptr) -> !llvm.ptr
  %404 = "llvm.load"(%403) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 omnipotent char", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 omnipotent char", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> !llvm.ptr
  %405 = "llvm.or"(%377, %81) : (i32, i32) -> i32
  %406 = "llvm.getelementptr"(%156) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 320>}> : (!llvm.ptr) -> !llvm.ptr
  %407 = "llvm.getelementptr"(%155) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 320>}> : (!llvm.ptr) -> !llvm.ptr
  %408 = "llvm.getelementptr"(%154) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 320>}> : (!llvm.ptr) -> !llvm.ptr
  %409 = "llvm.getelementptr"(%153) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 320>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.br"(%409, %408, %407, %406, %405, %404, %381, %345, %344, %283, %282, %313, %314, %375, %376)[^bb38] : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, i32, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
^bb37(%410: !llvm.ptr, %411: !llvm.ptr, %412: !llvm.ptr, %413: !llvm.ptr, %414: !llvm.ptr, %415: !llvm.ptr, %416: !llvm.ptr, %417: !llvm.ptr, %418: i32):  // 7 preds: ^bb12, ^bb17, ^bb22, ^bb27, ^bb32, ^bb34, ^bb35
  %419 = "llvm.getelementptr"(%156) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 320>}> : (!llvm.ptr) -> !llvm.ptr
  %420 = "llvm.getelementptr"(%155) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 320>}> : (!llvm.ptr) -> !llvm.ptr
  %421 = "llvm.getelementptr"(%154) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 320>}> : (!llvm.ptr) -> !llvm.ptr
  %422 = "llvm.getelementptr"(%153) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 320>}> : (!llvm.ptr) -> !llvm.ptr
  %423 = "llvm.icmp"(%418, %61) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%423, %422, %421, %420, %419, %418, %60, %60, %417, %416, %415, %414, %413, %412, %411, %410)[^bb103, ^bb38] <{branch_weights = array<i32: 1107806, 2146375842>, operandSegmentSizes = array<i32: 1, 0, 15>}> : (i1, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, i32, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
^bb38(%424: !llvm.ptr, %425: !llvm.ptr, %426: !llvm.ptr, %427: !llvm.ptr, %428: i32, %429: !llvm.ptr, %430: !llvm.ptr, %431: !llvm.ptr, %432: !llvm.ptr, %433: !llvm.ptr, %434: !llvm.ptr, %435: !llvm.ptr, %436: !llvm.ptr, %437: !llvm.ptr, %438: !llvm.ptr):  // 2 preds: ^bb36, ^bb37
  "llvm.intr.lifetime.start"(%163) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%164) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%151) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%152) : (!llvm.ptr) -> ()
  "llvm.store"(%163, %151) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 _ZTS21fd_ed25519_lane_point", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 _ZTS21fd_ed25519_lane_point", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.store"(%164, %152) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 _ZTS21fd_ed25519_lane_point", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 _ZTS21fd_ed25519_lane_point", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%153) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%154) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%155) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%156) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%157) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%158) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%159) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%160) : (!llvm.ptr) -> ()
  "llvm.store"(%61, %159) <{alignment = 4 : i64, ordering = 0 : i64}> : (i32, !llvm.ptr) -> ()
  "llvm.store"(%61, %160) <{alignment = 4 : i64, ordering = 0 : i64}> : (i32, !llvm.ptr) -> ()
  "llvm.call"(%157, %83) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {}], callee = @fd_ed25519_lane_bcast_fe, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, vector<8xi64>) -> ()
  "llvm.call"(%158, %84) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {}], callee = @fd_ed25519_lane_bcast_fe, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, vector<8xi64>) -> ()
  %439 = "llvm.getelementptr"(%157) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %440 = "llvm.getelementptr"(%157) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %441 = "llvm.getelementptr"(%157) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 192>}> : (!llvm.ptr) -> !llvm.ptr
  %442 = "llvm.getelementptr"(%157) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 256>}> : (!llvm.ptr) -> !llvm.ptr
  %443 = "llvm.load"(%157) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %444 = "llvm.load"(%439) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %445 = "llvm.load"(%440) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %446 = "llvm.load"(%441) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %447 = "llvm.load"(%442) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  "llvm.br"(%86, %159, %156, %155, %154, %153, %429, %438, %431, %436, %433, %251, %221, %191, %151)[^bb40] : (i1, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
^bb39:  // pred: ^bb40
  "llvm.call"(%163, %156, %164, %427) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_lane_pow22523_2, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  %448 = "llvm.load"(%158) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %449 = "llvm.getelementptr"(%158) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %450 = "llvm.load"(%449) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %451 = "llvm.getelementptr"(%158) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %452 = "llvm.load"(%451) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %453 = "llvm.getelementptr"(%158) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 192>}> : (!llvm.ptr) -> !llvm.ptr
  %454 = "llvm.load"(%453) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %455 = "llvm.getelementptr"(%158) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 256>}> : (!llvm.ptr) -> !llvm.ptr
  %456 = "llvm.load"(%455) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  "llvm.br"(%61, %86, %159, %155, %154, %153, %151)[^bb41] : (i32, i1, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
^bb40(%457: i1, %458: !llvm.ptr, %459: !llvm.ptr, %460: !llvm.ptr, %461: !llvm.ptr, %462: !llvm.ptr, %463: !llvm.ptr, %464: !llvm.ptr, %465: !llvm.ptr, %466: !llvm.ptr, %467: !llvm.ptr, %468: !llvm.ptr, %469: !llvm.ptr, %470: !llvm.ptr, %471: !llvm.ptr):  // 2 preds: ^bb38, ^bb40
  %472 = "llvm.load"(%458) <{alignment = 4 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i32
  %473 = "llvm.load"(%470) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %474 = "llvm.getelementptr"(%470) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 6>}> : (!llvm.ptr) -> !llvm.ptr
  %475 = "llvm.load"(%474) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %476 = "llvm.getelementptr"(%470) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 12>}> : (!llvm.ptr) -> !llvm.ptr
  %477 = "llvm.load"(%476) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %478 = "llvm.getelementptr"(%470) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 19>}> : (!llvm.ptr) -> !llvm.ptr
  %479 = "llvm.load"(%478) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %480 = "llvm.getelementptr"(%470) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %481 = "llvm.load"(%480) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %482 = "llvm.load"(%469) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %483 = "llvm.getelementptr"(%469) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 6>}> : (!llvm.ptr) -> !llvm.ptr
  %484 = "llvm.load"(%483) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %485 = "llvm.getelementptr"(%469) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 12>}> : (!llvm.ptr) -> !llvm.ptr
  %486 = "llvm.load"(%485) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %487 = "llvm.getelementptr"(%469) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 19>}> : (!llvm.ptr) -> !llvm.ptr
  %488 = "llvm.load"(%487) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %489 = "llvm.getelementptr"(%469) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %490 = "llvm.load"(%489) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %491 = "llvm.load"(%468) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %492 = "llvm.getelementptr"(%468) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 6>}> : (!llvm.ptr) -> !llvm.ptr
  %493 = "llvm.load"(%492) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %494 = "llvm.getelementptr"(%468) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 12>}> : (!llvm.ptr) -> !llvm.ptr
  %495 = "llvm.load"(%494) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %496 = "llvm.getelementptr"(%468) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 19>}> : (!llvm.ptr) -> !llvm.ptr
  %497 = "llvm.load"(%496) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %498 = "llvm.getelementptr"(%468) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %499 = "llvm.load"(%498) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %500 = "llvm.load"(%467) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %501 = "llvm.getelementptr"(%467) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 6>}> : (!llvm.ptr) -> !llvm.ptr
  %502 = "llvm.load"(%501) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %503 = "llvm.getelementptr"(%467) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 12>}> : (!llvm.ptr) -> !llvm.ptr
  %504 = "llvm.load"(%503) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %505 = "llvm.getelementptr"(%467) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 19>}> : (!llvm.ptr) -> !llvm.ptr
  %506 = "llvm.load"(%505) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %507 = "llvm.getelementptr"(%467) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %508 = "llvm.load"(%507) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %509 = "llvm.load"(%466) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %510 = "llvm.getelementptr"(%466) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 6>}> : (!llvm.ptr) -> !llvm.ptr
  %511 = "llvm.load"(%510) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %512 = "llvm.getelementptr"(%466) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 12>}> : (!llvm.ptr) -> !llvm.ptr
  %513 = "llvm.load"(%512) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %514 = "llvm.getelementptr"(%466) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 19>}> : (!llvm.ptr) -> !llvm.ptr
  %515 = "llvm.load"(%514) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %516 = "llvm.getelementptr"(%466) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %517 = "llvm.load"(%516) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %518 = "llvm.load"(%465) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %519 = "llvm.getelementptr"(%465) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 6>}> : (!llvm.ptr) -> !llvm.ptr
  %520 = "llvm.load"(%519) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %521 = "llvm.getelementptr"(%465) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 12>}> : (!llvm.ptr) -> !llvm.ptr
  %522 = "llvm.load"(%521) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %523 = "llvm.getelementptr"(%465) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 19>}> : (!llvm.ptr) -> !llvm.ptr
  %524 = "llvm.load"(%523) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %525 = "llvm.getelementptr"(%465) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %526 = "llvm.load"(%525) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %527 = "llvm.load"(%464) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %528 = "llvm.getelementptr"(%464) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 6>}> : (!llvm.ptr) -> !llvm.ptr
  %529 = "llvm.load"(%528) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %530 = "llvm.getelementptr"(%464) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 12>}> : (!llvm.ptr) -> !llvm.ptr
  %531 = "llvm.load"(%530) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %532 = "llvm.getelementptr"(%464) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 19>}> : (!llvm.ptr) -> !llvm.ptr
  %533 = "llvm.load"(%532) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %534 = "llvm.getelementptr"(%464) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %535 = "llvm.load"(%534) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %536 = "llvm.load"(%463) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %537 = "llvm.getelementptr"(%463) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 6>}> : (!llvm.ptr) -> !llvm.ptr
  %538 = "llvm.load"(%537) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %539 = "llvm.getelementptr"(%463) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 12>}> : (!llvm.ptr) -> !llvm.ptr
  %540 = "llvm.load"(%539) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %541 = "llvm.getelementptr"(%463) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 19>}> : (!llvm.ptr) -> !llvm.ptr
  %542 = "llvm.load"(%541) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %543 = "llvm.getelementptr"(%463) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %544 = "llvm.load"(%543) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %545 = "llvm.insertelement"(%87, %490, %66) : (vector<8xi64>, i64, i64) -> vector<8xi64>
  %546 = "llvm.insertelement"(%545, %499, %88) : (vector<8xi64>, i64, i64) -> vector<8xi64>
  %547 = "llvm.insertelement"(%546, %508, %89) : (vector<8xi64>, i64, i64) -> vector<8xi64>
  %548 = "llvm.insertelement"(%547, %517, %72) : (vector<8xi64>, i64, i64) -> vector<8xi64>
  %549 = "llvm.insertelement"(%548, %526, %68) : (vector<8xi64>, i64, i64) -> vector<8xi64>
  %550 = "llvm.insertelement"(%549, %535, %76) : (vector<8xi64>, i64, i64) -> vector<8xi64>
  %551 = "llvm.insertelement"(%550, %544, %78) : (vector<8xi64>, i64, i64) -> vector<8xi64>
  %552 = "llvm.insertelement"(%551, %481, %80) : (vector<8xi64>, i64, i64) -> vector<8xi64>
  %553 = "llvm.lshr"(%552, %90) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %554 = "llvm.and"(%553, %91) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %555 = "llvm.intr.vector.reduce.or"(%554) : (vector<8xi64>) -> i64
  %556 = "llvm.trunc"(%555) <{overflowFlags = 3 : i32}> : (i64) -> i32
  %557 = "llvm.or"(%472, %556) : (i32, i32) -> i32
  "llvm.store"(%557, %458) <{alignment = 4 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i32, !llvm.ptr) -> ()
  %558 = "llvm.load"(%471) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 _ZTS21fd_ed25519_lane_point", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 _ZTS21fd_ed25519_lane_point", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> !llvm.ptr
  %559 = "llvm.getelementptr"(%558) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 960>}> : (!llvm.ptr) -> !llvm.ptr
  %560 = "llvm.getelementptr"(%558) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 640>}> : (!llvm.ptr) -> !llvm.ptr
  %561 = "llvm.getelementptr"(%558) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 320>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.memset"(%558, %53, %82) <{arg_attrs = [{llvm.align = 64 : i64, llvm.dereferenceable = 320 : i64, llvm.nonnull, llvm.noundef}, {}, {}], isVolatile = false, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr, i8, i64) -> ()
  "llvm.store"(%94, %559) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.store"(%95, %560) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %562 = "llvm.getelementptr"(%558) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1024>}> : (!llvm.ptr) -> !llvm.ptr
  %563 = "llvm.getelementptr"(%558) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 704>}> : (!llvm.ptr) -> !llvm.ptr
  %564 = "llvm.getelementptr"(%558) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 384>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.memset"(%563, %53, %54) <{arg_attrs = [{llvm.align = 64 : i64, llvm.dereferenceable = 256 : i64, llvm.nonnull, llvm.noundef}, {}, {}], isVolatile = false}> : (!llvm.ptr, i8, i64) -> ()
  "llvm.intr.memset"(%562, %53, %54) <{arg_attrs = [{llvm.align = 64 : i64, llvm.dereferenceable = 256 : i64, llvm.nonnull, llvm.noundef}, {}, {}], isVolatile = false}> : (!llvm.ptr, i8, i64) -> ()
  %565 = "llvm.insertelement"(%87, %473, %66) : (vector<8xi64>, i64, i64) -> vector<8xi64>
  %566 = "llvm.insertelement"(%565, %482, %88) : (vector<8xi64>, i64, i64) -> vector<8xi64>
  %567 = "llvm.insertelement"(%566, %491, %89) : (vector<8xi64>, i64, i64) -> vector<8xi64>
  %568 = "llvm.insertelement"(%567, %500, %72) : (vector<8xi64>, i64, i64) -> vector<8xi64>
  %569 = "llvm.insertelement"(%568, %509, %68) : (vector<8xi64>, i64, i64) -> vector<8xi64>
  %570 = "llvm.insertelement"(%569, %518, %76) : (vector<8xi64>, i64, i64) -> vector<8xi64>
  %571 = "llvm.insertelement"(%570, %527, %78) : (vector<8xi64>, i64, i64) -> vector<8xi64>
  %572 = "llvm.insertelement"(%571, %536, %80) : (vector<8xi64>, i64, i64) -> vector<8xi64>
  %573 = "llvm.and"(%572, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%573, %561) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %574 = "llvm.insertelement"(%87, %475, %66) : (vector<8xi64>, i64, i64) -> vector<8xi64>
  %575 = "llvm.insertelement"(%574, %484, %88) : (vector<8xi64>, i64, i64) -> vector<8xi64>
  %576 = "llvm.insertelement"(%575, %493, %89) : (vector<8xi64>, i64, i64) -> vector<8xi64>
  %577 = "llvm.insertelement"(%576, %502, %72) : (vector<8xi64>, i64, i64) -> vector<8xi64>
  %578 = "llvm.insertelement"(%577, %511, %68) : (vector<8xi64>, i64, i64) -> vector<8xi64>
  %579 = "llvm.insertelement"(%578, %520, %76) : (vector<8xi64>, i64, i64) -> vector<8xi64>
  %580 = "llvm.insertelement"(%579, %529, %78) : (vector<8xi64>, i64, i64) -> vector<8xi64>
  %581 = "llvm.insertelement"(%580, %538, %80) : (vector<8xi64>, i64, i64) -> vector<8xi64>
  %582 = "llvm.lshr"(%581, %97) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %583 = "llvm.and"(%582, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%583, %564) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %584 = "llvm.getelementptr"(%558) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 448>}> : (!llvm.ptr) -> !llvm.ptr
  %585 = "llvm.insertelement"(%87, %477, %66) : (vector<8xi64>, i64, i64) -> vector<8xi64>
  %586 = "llvm.insertelement"(%585, %486, %88) : (vector<8xi64>, i64, i64) -> vector<8xi64>
  %587 = "llvm.insertelement"(%586, %495, %89) : (vector<8xi64>, i64, i64) -> vector<8xi64>
  %588 = "llvm.insertelement"(%587, %504, %72) : (vector<8xi64>, i64, i64) -> vector<8xi64>
  %589 = "llvm.insertelement"(%588, %513, %68) : (vector<8xi64>, i64, i64) -> vector<8xi64>
  %590 = "llvm.insertelement"(%589, %522, %76) : (vector<8xi64>, i64, i64) -> vector<8xi64>
  %591 = "llvm.insertelement"(%590, %531, %78) : (vector<8xi64>, i64, i64) -> vector<8xi64>
  %592 = "llvm.insertelement"(%591, %540, %80) : (vector<8xi64>, i64, i64) -> vector<8xi64>
  %593 = "llvm.lshr"(%592, %98) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %594 = "llvm.and"(%593, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%594, %584) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %595 = "llvm.getelementptr"(%558) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 512>}> : (!llvm.ptr) -> !llvm.ptr
  %596 = "llvm.insertelement"(%87, %479, %66) : (vector<8xi64>, i64, i64) -> vector<8xi64>
  %597 = "llvm.insertelement"(%596, %488, %88) : (vector<8xi64>, i64, i64) -> vector<8xi64>
  %598 = "llvm.insertelement"(%597, %497, %89) : (vector<8xi64>, i64, i64) -> vector<8xi64>
  %599 = "llvm.insertelement"(%598, %506, %72) : (vector<8xi64>, i64, i64) -> vector<8xi64>
  %600 = "llvm.insertelement"(%599, %515, %68) : (vector<8xi64>, i64, i64) -> vector<8xi64>
  %601 = "llvm.insertelement"(%600, %524, %76) : (vector<8xi64>, i64, i64) -> vector<8xi64>
  %602 = "llvm.insertelement"(%601, %533, %78) : (vector<8xi64>, i64, i64) -> vector<8xi64>
  %603 = "llvm.insertelement"(%602, %542, %80) : (vector<8xi64>, i64, i64) -> vector<8xi64>
  %604 = "llvm.lshr"(%603, %95) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %605 = "llvm.and"(%604, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%605, %595) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %606 = "llvm.getelementptr"(%558) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 576>}> : (!llvm.ptr) -> !llvm.ptr
  %607 = "llvm.insertelement"(%87, %481, %66) : (vector<8xi64>, i64, i64) -> vector<8xi64>
  %608 = "llvm.insertelement"(%607, %490, %88) : (vector<8xi64>, i64, i64) -> vector<8xi64>
  %609 = "llvm.insertelement"(%608, %499, %89) : (vector<8xi64>, i64, i64) -> vector<8xi64>
  %610 = "llvm.insertelement"(%609, %508, %72) : (vector<8xi64>, i64, i64) -> vector<8xi64>
  %611 = "llvm.insertelement"(%610, %517, %68) : (vector<8xi64>, i64, i64) -> vector<8xi64>
  %612 = "llvm.insertelement"(%611, %526, %76) : (vector<8xi64>, i64, i64) -> vector<8xi64>
  %613 = "llvm.insertelement"(%612, %535, %78) : (vector<8xi64>, i64, i64) -> vector<8xi64>
  %614 = "llvm.insertelement"(%613, %544, %80) : (vector<8xi64>, i64, i64) -> vector<8xi64>
  %615 = "llvm.lshr"(%614, %100) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %616 = "llvm.and"(%615, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%616, %606) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %617 = "llvm.load"(%561) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %618 = "llvm.load"(%564) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %619 = "llvm.load"(%584) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %620 = "llvm.load"(%595) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %621 = "llvm.call_intrinsic"(%94, %617, %617) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %622 = "llvm.call_intrinsic"(%621, %617, %618) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %623 = "llvm.shl"(%622, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %624 = "llvm.call_intrinsic"(%94, %617, %618) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %625 = "llvm.shl"(%624, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %626 = "llvm.call_intrinsic"(%625, %617, %619) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %627 = "llvm.shl"(%626, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %628 = "llvm.call_intrinsic"(%627, %618, %618) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %629 = "llvm.call_intrinsic"(%94, %617, %619) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %630 = "llvm.shl"(%629, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %631 = "llvm.call_intrinsic"(%630, %618, %618) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %632 = "llvm.call_intrinsic"(%631, %617, %620) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %633 = "llvm.call_intrinsic"(%632, %618, %619) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %634 = "llvm.shl"(%633, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %635 = "llvm.call_intrinsic"(%94, %617, %620) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %636 = "llvm.call_intrinsic"(%635, %618, %619) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %637 = "llvm.shl"(%636, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %638 = "llvm.call_intrinsic"(%637, %617, %616) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %639 = "llvm.call_intrinsic"(%638, %618, %620) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %640 = "llvm.shl"(%639, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %641 = "llvm.call_intrinsic"(%640, %619, %619) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %642 = "llvm.call_intrinsic"(%94, %617, %616) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %643 = "llvm.call_intrinsic"(%642, %618, %620) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %644 = "llvm.shl"(%643, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %645 = "llvm.call_intrinsic"(%644, %619, %619) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %646 = "llvm.call_intrinsic"(%645, %618, %616) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %647 = "llvm.call_intrinsic"(%646, %619, %620) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %648 = "llvm.call_intrinsic"(%94, %618, %616) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %649 = "llvm.call_intrinsic"(%648, %619, %620) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %650 = "llvm.shl"(%649, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %651 = "llvm.call_intrinsic"(%650, %619, %616) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %652 = "llvm.shl"(%651, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %653 = "llvm.call_intrinsic"(%652, %620, %620) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %654 = "llvm.call_intrinsic"(%94, %619, %616) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %655 = "llvm.shl"(%654, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %656 = "llvm.call_intrinsic"(%655, %620, %620) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %657 = "llvm.call_intrinsic"(%656, %620, %616) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %658 = "llvm.call_intrinsic"(%94, %620, %616) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %659 = "llvm.shl"(%658, %101) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %660 = "llvm.call_intrinsic"(%659, %616, %616) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %661 = "llvm.call_intrinsic"(%94, %616, %616) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %662 = "llvm.mul"(%647, %102) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %663 = "llvm.call_intrinsic"(%662, %617, %617) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %664 = "llvm.mul"(%653, %103) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %665 = "llvm.add"(%664, %623) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %666 = "llvm.mul"(%657, %102) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %667 = "llvm.add"(%666, %628) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %668 = "llvm.mul"(%660, %103) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %669 = "llvm.add"(%668, %634) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %670 = "llvm.mul"(%661, %102) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %671 = "llvm.add"(%670, %641) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %672 = "llvm.lshr"(%663, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %673 = "llvm.lshr"(%665, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %674 = "llvm.lshr"(%667, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %675 = "llvm.lshr"(%669, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %676 = "llvm.lshr"(%671, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %677 = "llvm.and"(%663, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %678 = "llvm.call_intrinsic"(%677, %676, %103) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %679 = "llvm.and"(%665, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %680 = "llvm.add"(%672, %679) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %681 = "llvm.and"(%667, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %682 = "llvm.add"(%681, %673) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %683 = "llvm.and"(%669, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %684 = "llvm.add"(%683, %674) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %685 = "llvm.and"(%671, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %686 = "llvm.add"(%685, %675) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %687 = "llvm.call_intrinsic"(%94, %678, %443) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %688 = "llvm.shl"(%687, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %689 = "llvm.call_intrinsic"(%688, %678, %444) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %690 = "llvm.call_intrinsic"(%689, %680, %443) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %691 = "llvm.call_intrinsic"(%94, %678, %444) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %692 = "llvm.call_intrinsic"(%691, %680, %443) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %693 = "llvm.shl"(%692, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %694 = "llvm.call_intrinsic"(%693, %678, %445) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %695 = "llvm.call_intrinsic"(%694, %680, %444) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %696 = "llvm.call_intrinsic"(%695, %682, %443) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %697 = "llvm.call_intrinsic"(%94, %678, %445) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %698 = "llvm.call_intrinsic"(%697, %680, %444) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %699 = "llvm.call_intrinsic"(%698, %682, %443) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %700 = "llvm.shl"(%699, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %701 = "llvm.call_intrinsic"(%700, %678, %446) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %702 = "llvm.call_intrinsic"(%701, %680, %445) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %703 = "llvm.call_intrinsic"(%702, %682, %444) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %704 = "llvm.call_intrinsic"(%703, %684, %443) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %705 = "llvm.call_intrinsic"(%94, %678, %446) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %706 = "llvm.call_intrinsic"(%705, %680, %445) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %707 = "llvm.call_intrinsic"(%706, %682, %444) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %708 = "llvm.call_intrinsic"(%707, %684, %443) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %709 = "llvm.shl"(%708, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %710 = "llvm.call_intrinsic"(%709, %678, %447) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %711 = "llvm.call_intrinsic"(%710, %680, %446) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %712 = "llvm.call_intrinsic"(%711, %682, %445) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %713 = "llvm.call_intrinsic"(%712, %684, %444) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %714 = "llvm.call_intrinsic"(%713, %686, %443) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %715 = "llvm.call_intrinsic"(%94, %678, %447) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %716 = "llvm.call_intrinsic"(%715, %680, %446) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %717 = "llvm.call_intrinsic"(%716, %682, %445) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %718 = "llvm.call_intrinsic"(%717, %684, %444) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %719 = "llvm.call_intrinsic"(%718, %686, %443) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %720 = "llvm.shl"(%719, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %721 = "llvm.call_intrinsic"(%720, %680, %447) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %722 = "llvm.call_intrinsic"(%721, %682, %446) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %723 = "llvm.call_intrinsic"(%722, %684, %445) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %724 = "llvm.call_intrinsic"(%723, %686, %444) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %725 = "llvm.call_intrinsic"(%94, %680, %447) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %726 = "llvm.call_intrinsic"(%725, %682, %446) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %727 = "llvm.call_intrinsic"(%726, %684, %445) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %728 = "llvm.call_intrinsic"(%727, %686, %444) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %729 = "llvm.shl"(%728, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %730 = "llvm.call_intrinsic"(%729, %682, %447) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %731 = "llvm.call_intrinsic"(%730, %684, %446) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %732 = "llvm.call_intrinsic"(%731, %686, %445) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %733 = "llvm.call_intrinsic"(%94, %682, %447) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %734 = "llvm.call_intrinsic"(%733, %684, %446) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %735 = "llvm.call_intrinsic"(%734, %686, %445) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %736 = "llvm.shl"(%735, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %737 = "llvm.call_intrinsic"(%736, %684, %447) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %738 = "llvm.call_intrinsic"(%737, %686, %446) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %739 = "llvm.call_intrinsic"(%94, %684, %447) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %740 = "llvm.call_intrinsic"(%739, %686, %446) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %741 = "llvm.shl"(%740, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %742 = "llvm.call_intrinsic"(%741, %686, %447) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %743 = "llvm.call_intrinsic"(%94, %686, %447) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %744 = "llvm.mul"(%724, %103) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %745 = "llvm.call_intrinsic"(%744, %678, %443) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %746 = "llvm.mul"(%732, %103) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %747 = "llvm.add"(%746, %690) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %748 = "llvm.getelementptr"(%461) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %749 = "llvm.mul"(%738, %103) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %750 = "llvm.add"(%749, %696) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %751 = "llvm.getelementptr"(%461) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %752 = "llvm.mul"(%742, %103) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %753 = "llvm.add"(%752, %704) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %754 = "llvm.getelementptr"(%461) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 192>}> : (!llvm.ptr) -> !llvm.ptr
  %755 = "llvm.mul"(%743, %102) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %756 = "llvm.add"(%755, %714) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %757 = "llvm.getelementptr"(%461) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 256>}> : (!llvm.ptr) -> !llvm.ptr
  %758 = "llvm.lshr"(%745, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %759 = "llvm.lshr"(%747, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %760 = "llvm.lshr"(%750, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %761 = "llvm.lshr"(%753, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %762 = "llvm.lshr"(%756, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %763 = "llvm.and"(%745, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %764 = "llvm.call_intrinsic"(%763, %762, %103) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %765 = "llvm.and"(%747, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %766 = "llvm.add"(%758, %765) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %767 = "llvm.and"(%750, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %768 = "llvm.add"(%767, %759) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %769 = "llvm.and"(%753, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %770 = "llvm.add"(%769, %760) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %771 = "llvm.and"(%756, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %772 = "llvm.add"(%771, %761) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %773 = "llvm.add"(%678, %105) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %774 = "llvm.add"(%680, %106) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %775 = "llvm.getelementptr"(%462) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %776 = "llvm.add"(%682, %106) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %777 = "llvm.getelementptr"(%558) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 768>}> : (!llvm.ptr) -> !llvm.ptr
  %778 = "llvm.load"(%777) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %779 = "llvm.sub"(%776, %778) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %780 = "llvm.getelementptr"(%462) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %781 = "llvm.add"(%684, %106) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %782 = "llvm.getelementptr"(%558) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 832>}> : (!llvm.ptr) -> !llvm.ptr
  %783 = "llvm.load"(%782) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %784 = "llvm.sub"(%781, %783) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %785 = "llvm.getelementptr"(%462) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 192>}> : (!llvm.ptr) -> !llvm.ptr
  %786 = "llvm.add"(%686, %106) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %787 = "llvm.getelementptr"(%558) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 896>}> : (!llvm.ptr) -> !llvm.ptr
  %788 = "llvm.load"(%787) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %789 = "llvm.sub"(%786, %788) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %790 = "llvm.getelementptr"(%462) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 256>}> : (!llvm.ptr) -> !llvm.ptr
  %791 = "llvm.lshr"(%773, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %792 = "llvm.lshr"(%774, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %793 = "llvm.lshr"(%779, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %794 = "llvm.lshr"(%784, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %795 = "llvm.lshr"(%789, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %796 = "llvm.and"(%773, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %797 = "llvm.call_intrinsic"(%796, %795, %103) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%797, %462) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %798 = "llvm.and"(%774, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %799 = "llvm.add"(%798, %791) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%799, %775) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %800 = "llvm.and"(%779, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %801 = "llvm.add"(%800, %792) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%801, %780) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %802 = "llvm.and"(%784, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %803 = "llvm.add"(%802, %793) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%803, %785) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %804 = "llvm.and"(%789, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %805 = "llvm.add"(%804, %794) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%805, %790) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %806 = "llvm.add"(%764, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%806, %461) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.store"(%766, %748) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %807 = "llvm.add"(%768, %778) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%807, %751) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %808 = "llvm.add"(%770, %783) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%808, %754) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %809 = "llvm.add"(%772, %788) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%809, %757) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %810 = "llvm.call_intrinsic"(%94, %806, %806) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %811 = "llvm.call_intrinsic"(%810, %806, %766) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %812 = "llvm.shl"(%811, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %813 = "llvm.call_intrinsic"(%94, %806, %766) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %814 = "llvm.shl"(%813, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %815 = "llvm.call_intrinsic"(%814, %806, %807) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %816 = "llvm.shl"(%815, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %817 = "llvm.call_intrinsic"(%816, %766, %766) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %818 = "llvm.call_intrinsic"(%94, %806, %807) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %819 = "llvm.shl"(%818, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %820 = "llvm.call_intrinsic"(%819, %766, %766) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %821 = "llvm.call_intrinsic"(%820, %806, %808) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %822 = "llvm.call_intrinsic"(%821, %766, %807) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %823 = "llvm.shl"(%822, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %824 = "llvm.call_intrinsic"(%94, %806, %808) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %825 = "llvm.call_intrinsic"(%824, %766, %807) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %826 = "llvm.shl"(%825, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %827 = "llvm.call_intrinsic"(%826, %806, %809) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %828 = "llvm.call_intrinsic"(%827, %766, %808) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %829 = "llvm.shl"(%828, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %830 = "llvm.call_intrinsic"(%829, %807, %807) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %831 = "llvm.call_intrinsic"(%94, %806, %809) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %832 = "llvm.call_intrinsic"(%831, %766, %808) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %833 = "llvm.shl"(%832, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %834 = "llvm.call_intrinsic"(%833, %807, %807) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %835 = "llvm.call_intrinsic"(%834, %766, %809) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %836 = "llvm.call_intrinsic"(%835, %807, %808) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %837 = "llvm.call_intrinsic"(%94, %766, %809) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %838 = "llvm.call_intrinsic"(%837, %807, %808) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %839 = "llvm.shl"(%838, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %840 = "llvm.call_intrinsic"(%839, %807, %809) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %841 = "llvm.shl"(%840, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %842 = "llvm.call_intrinsic"(%841, %808, %808) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %843 = "llvm.call_intrinsic"(%94, %807, %809) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %844 = "llvm.shl"(%843, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %845 = "llvm.call_intrinsic"(%844, %808, %808) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %846 = "llvm.call_intrinsic"(%845, %808, %809) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %847 = "llvm.call_intrinsic"(%94, %808, %809) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %848 = "llvm.shl"(%847, %101) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %849 = "llvm.call_intrinsic"(%848, %809, %809) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %850 = "llvm.call_intrinsic"(%94, %809, %809) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %851 = "llvm.mul"(%836, %102) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %852 = "llvm.call_intrinsic"(%851, %806, %806) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %853 = "llvm.mul"(%842, %103) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %854 = "llvm.add"(%853, %812) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %855 = "llvm.mul"(%846, %102) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %856 = "llvm.add"(%855, %817) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %857 = "llvm.mul"(%849, %103) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %858 = "llvm.add"(%857, %823) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %859 = "llvm.mul"(%850, %102) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %860 = "llvm.add"(%859, %830) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %861 = "llvm.lshr"(%852, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %862 = "llvm.lshr"(%854, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %863 = "llvm.lshr"(%856, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %864 = "llvm.lshr"(%858, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %865 = "llvm.lshr"(%860, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %866 = "llvm.and"(%852, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %867 = "llvm.call_intrinsic"(%866, %865, %103) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %868 = "llvm.and"(%854, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %869 = "llvm.add"(%861, %868) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %870 = "llvm.and"(%856, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %871 = "llvm.add"(%870, %862) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %872 = "llvm.and"(%858, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %873 = "llvm.add"(%872, %863) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %874 = "llvm.and"(%860, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %875 = "llvm.add"(%874, %864) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %876 = "llvm.call_intrinsic"(%94, %867, %806) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %877 = "llvm.shl"(%876, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %878 = "llvm.call_intrinsic"(%877, %867, %766) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %879 = "llvm.call_intrinsic"(%878, %869, %806) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %880 = "llvm.call_intrinsic"(%94, %867, %766) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %881 = "llvm.call_intrinsic"(%880, %869, %806) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %882 = "llvm.shl"(%881, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %883 = "llvm.call_intrinsic"(%882, %867, %807) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %884 = "llvm.call_intrinsic"(%883, %869, %766) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %885 = "llvm.call_intrinsic"(%884, %871, %806) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %886 = "llvm.call_intrinsic"(%94, %867, %807) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %887 = "llvm.call_intrinsic"(%886, %869, %766) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %888 = "llvm.call_intrinsic"(%887, %871, %806) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %889 = "llvm.shl"(%888, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %890 = "llvm.call_intrinsic"(%889, %867, %808) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %891 = "llvm.call_intrinsic"(%890, %869, %807) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %892 = "llvm.call_intrinsic"(%891, %871, %766) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %893 = "llvm.call_intrinsic"(%892, %873, %806) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %894 = "llvm.call_intrinsic"(%94, %867, %808) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %895 = "llvm.call_intrinsic"(%894, %869, %807) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %896 = "llvm.call_intrinsic"(%895, %871, %766) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %897 = "llvm.call_intrinsic"(%896, %873, %806) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %898 = "llvm.shl"(%897, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %899 = "llvm.call_intrinsic"(%898, %867, %809) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %900 = "llvm.call_intrinsic"(%899, %869, %808) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %901 = "llvm.call_intrinsic"(%900, %871, %807) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %902 = "llvm.call_intrinsic"(%901, %873, %766) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %903 = "llvm.call_intrinsic"(%902, %875, %806) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %904 = "llvm.call_intrinsic"(%94, %867, %809) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %905 = "llvm.call_intrinsic"(%904, %869, %808) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %906 = "llvm.call_intrinsic"(%905, %871, %807) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %907 = "llvm.call_intrinsic"(%906, %873, %766) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %908 = "llvm.call_intrinsic"(%907, %875, %806) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %909 = "llvm.shl"(%908, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %910 = "llvm.call_intrinsic"(%909, %869, %809) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %911 = "llvm.call_intrinsic"(%910, %871, %808) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %912 = "llvm.call_intrinsic"(%911, %873, %807) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %913 = "llvm.call_intrinsic"(%912, %875, %766) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %914 = "llvm.call_intrinsic"(%94, %869, %809) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %915 = "llvm.call_intrinsic"(%914, %871, %808) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %916 = "llvm.call_intrinsic"(%915, %873, %807) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %917 = "llvm.call_intrinsic"(%916, %875, %766) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %918 = "llvm.shl"(%917, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %919 = "llvm.call_intrinsic"(%918, %871, %809) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %920 = "llvm.call_intrinsic"(%919, %873, %808) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %921 = "llvm.call_intrinsic"(%920, %875, %807) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %922 = "llvm.call_intrinsic"(%94, %871, %809) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %923 = "llvm.call_intrinsic"(%922, %873, %808) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %924 = "llvm.call_intrinsic"(%923, %875, %807) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %925 = "llvm.shl"(%924, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %926 = "llvm.call_intrinsic"(%925, %873, %809) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %927 = "llvm.call_intrinsic"(%926, %875, %808) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %928 = "llvm.call_intrinsic"(%94, %873, %809) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %929 = "llvm.call_intrinsic"(%928, %875, %808) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %930 = "llvm.shl"(%929, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %931 = "llvm.call_intrinsic"(%930, %875, %809) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %932 = "llvm.call_intrinsic"(%94, %875, %809) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %933 = "llvm.mul"(%913, %103) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %934 = "llvm.call_intrinsic"(%933, %867, %806) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %935 = "llvm.mul"(%921, %103) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %936 = "llvm.add"(%935, %879) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %937 = "llvm.mul"(%927, %103) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %938 = "llvm.add"(%937, %885) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %939 = "llvm.mul"(%931, %103) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %940 = "llvm.add"(%939, %893) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %941 = "llvm.mul"(%932, %102) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %942 = "llvm.add"(%941, %903) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %943 = "llvm.lshr"(%934, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %944 = "llvm.lshr"(%936, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %945 = "llvm.lshr"(%938, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %946 = "llvm.lshr"(%940, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %947 = "llvm.lshr"(%942, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %948 = "llvm.and"(%934, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %949 = "llvm.call_intrinsic"(%948, %947, %103) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %950 = "llvm.and"(%936, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %951 = "llvm.add"(%943, %950) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %952 = "llvm.and"(%938, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %953 = "llvm.add"(%952, %944) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %954 = "llvm.and"(%940, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %955 = "llvm.add"(%954, %945) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %956 = "llvm.and"(%942, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %957 = "llvm.add"(%956, %946) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %958 = "llvm.call_intrinsic"(%94, %797, %949) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %959 = "llvm.shl"(%958, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %960 = "llvm.call_intrinsic"(%959, %797, %951) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %961 = "llvm.call_intrinsic"(%960, %799, %949) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %962 = "llvm.call_intrinsic"(%94, %797, %951) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %963 = "llvm.call_intrinsic"(%962, %799, %949) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %964 = "llvm.shl"(%963, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %965 = "llvm.call_intrinsic"(%964, %797, %953) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %966 = "llvm.call_intrinsic"(%965, %799, %951) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %967 = "llvm.call_intrinsic"(%966, %801, %949) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %968 = "llvm.call_intrinsic"(%94, %797, %953) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %969 = "llvm.call_intrinsic"(%968, %799, %951) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %970 = "llvm.call_intrinsic"(%969, %801, %949) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %971 = "llvm.shl"(%970, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %972 = "llvm.call_intrinsic"(%971, %797, %955) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %973 = "llvm.call_intrinsic"(%972, %799, %953) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %974 = "llvm.call_intrinsic"(%973, %801, %951) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %975 = "llvm.call_intrinsic"(%974, %803, %949) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %976 = "llvm.call_intrinsic"(%94, %797, %955) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %977 = "llvm.call_intrinsic"(%976, %799, %953) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %978 = "llvm.call_intrinsic"(%977, %801, %951) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %979 = "llvm.call_intrinsic"(%978, %803, %949) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %980 = "llvm.shl"(%979, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %981 = "llvm.call_intrinsic"(%980, %797, %957) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %982 = "llvm.call_intrinsic"(%981, %799, %955) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %983 = "llvm.call_intrinsic"(%982, %801, %953) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %984 = "llvm.call_intrinsic"(%983, %803, %951) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %985 = "llvm.call_intrinsic"(%984, %805, %949) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %986 = "llvm.call_intrinsic"(%94, %797, %957) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %987 = "llvm.call_intrinsic"(%986, %799, %955) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %988 = "llvm.call_intrinsic"(%987, %801, %953) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %989 = "llvm.call_intrinsic"(%988, %803, %951) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %990 = "llvm.call_intrinsic"(%989, %805, %949) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %991 = "llvm.shl"(%990, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %992 = "llvm.call_intrinsic"(%991, %799, %957) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %993 = "llvm.call_intrinsic"(%992, %801, %955) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %994 = "llvm.call_intrinsic"(%993, %803, %953) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %995 = "llvm.call_intrinsic"(%994, %805, %951) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %996 = "llvm.call_intrinsic"(%94, %799, %957) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %997 = "llvm.call_intrinsic"(%996, %801, %955) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %998 = "llvm.call_intrinsic"(%997, %803, %953) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %999 = "llvm.call_intrinsic"(%998, %805, %951) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1000 = "llvm.shl"(%999, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1001 = "llvm.call_intrinsic"(%1000, %801, %957) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1002 = "llvm.call_intrinsic"(%1001, %803, %955) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1003 = "llvm.call_intrinsic"(%1002, %805, %953) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1004 = "llvm.call_intrinsic"(%94, %801, %957) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1005 = "llvm.call_intrinsic"(%1004, %803, %955) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1006 = "llvm.call_intrinsic"(%1005, %805, %953) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1007 = "llvm.shl"(%1006, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1008 = "llvm.call_intrinsic"(%1007, %803, %957) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1009 = "llvm.call_intrinsic"(%1008, %805, %955) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1010 = "llvm.call_intrinsic"(%94, %803, %957) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1011 = "llvm.call_intrinsic"(%1010, %805, %955) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1012 = "llvm.shl"(%1011, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1013 = "llvm.call_intrinsic"(%1012, %805, %957) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1014 = "llvm.call_intrinsic"(%94, %805, %957) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1015 = "llvm.mul"(%995, %103) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1016 = "llvm.call_intrinsic"(%1015, %797, %949) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1017 = "llvm.mul"(%1003, %103) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1018 = "llvm.add"(%1017, %961) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1019 = "llvm.getelementptr"(%460) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %1020 = "llvm.mul"(%1009, %103) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1021 = "llvm.add"(%1020, %967) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1022 = "llvm.getelementptr"(%460) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %1023 = "llvm.mul"(%1013, %103) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1024 = "llvm.add"(%1023, %975) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1025 = "llvm.getelementptr"(%460) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 192>}> : (!llvm.ptr) -> !llvm.ptr
  %1026 = "llvm.mul"(%1014, %102) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1027 = "llvm.add"(%1026, %985) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1028 = "llvm.getelementptr"(%460) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 256>}> : (!llvm.ptr) -> !llvm.ptr
  %1029 = "llvm.lshr"(%1016, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1030 = "llvm.lshr"(%1018, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1031 = "llvm.lshr"(%1021, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1032 = "llvm.lshr"(%1024, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1033 = "llvm.lshr"(%1027, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1034 = "llvm.and"(%1016, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1035 = "llvm.call_intrinsic"(%1034, %1033, %103) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%1035, %460) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %1036 = "llvm.and"(%1018, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1037 = "llvm.add"(%1029, %1036) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%1037, %1019) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %1038 = "llvm.and"(%1021, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1039 = "llvm.add"(%1038, %1030) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%1039, %1022) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %1040 = "llvm.and"(%1024, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1041 = "llvm.add"(%1040, %1031) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%1041, %1025) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %1042 = "llvm.and"(%1027, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1043 = "llvm.add"(%1042, %1032) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%1043, %1028) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %1044 = "llvm.call_intrinsic"(%94, %949, %949) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1045 = "llvm.call_intrinsic"(%1044, %949, %951) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1046 = "llvm.shl"(%1045, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1047 = "llvm.call_intrinsic"(%94, %949, %951) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1048 = "llvm.shl"(%1047, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1049 = "llvm.call_intrinsic"(%1048, %949, %953) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1050 = "llvm.shl"(%1049, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1051 = "llvm.call_intrinsic"(%1050, %951, %951) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1052 = "llvm.call_intrinsic"(%94, %949, %953) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1053 = "llvm.shl"(%1052, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1054 = "llvm.call_intrinsic"(%1053, %951, %951) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1055 = "llvm.call_intrinsic"(%1054, %949, %955) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1056 = "llvm.call_intrinsic"(%1055, %951, %953) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1057 = "llvm.shl"(%1056, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1058 = "llvm.call_intrinsic"(%94, %949, %955) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1059 = "llvm.call_intrinsic"(%1058, %951, %953) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1060 = "llvm.shl"(%1059, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1061 = "llvm.call_intrinsic"(%1060, %949, %957) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1062 = "llvm.call_intrinsic"(%1061, %951, %955) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1063 = "llvm.shl"(%1062, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1064 = "llvm.call_intrinsic"(%1063, %953, %953) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1065 = "llvm.call_intrinsic"(%94, %949, %957) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1066 = "llvm.call_intrinsic"(%1065, %951, %955) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1067 = "llvm.shl"(%1066, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1068 = "llvm.call_intrinsic"(%1067, %953, %953) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1069 = "llvm.call_intrinsic"(%1068, %951, %957) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1070 = "llvm.call_intrinsic"(%1069, %953, %955) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1071 = "llvm.call_intrinsic"(%94, %951, %957) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1072 = "llvm.call_intrinsic"(%1071, %953, %955) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1073 = "llvm.shl"(%1072, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1074 = "llvm.call_intrinsic"(%1073, %953, %957) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1075 = "llvm.shl"(%1074, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1076 = "llvm.call_intrinsic"(%1075, %955, %955) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1077 = "llvm.call_intrinsic"(%94, %953, %957) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1078 = "llvm.shl"(%1077, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1079 = "llvm.call_intrinsic"(%1078, %955, %955) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1080 = "llvm.call_intrinsic"(%1079, %955, %957) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1081 = "llvm.call_intrinsic"(%94, %955, %957) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1082 = "llvm.shl"(%1081, %101) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1083 = "llvm.call_intrinsic"(%1082, %957, %957) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1084 = "llvm.call_intrinsic"(%94, %957, %957) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1085 = "llvm.mul"(%1070, %102) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1086 = "llvm.call_intrinsic"(%1085, %949, %949) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1087 = "llvm.mul"(%1076, %103) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1088 = "llvm.add"(%1087, %1046) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1089 = "llvm.getelementptr"(%459) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %1090 = "llvm.mul"(%1080, %102) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1091 = "llvm.add"(%1090, %1051) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1092 = "llvm.getelementptr"(%459) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %1093 = "llvm.mul"(%1083, %103) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1094 = "llvm.add"(%1093, %1057) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1095 = "llvm.getelementptr"(%459) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 192>}> : (!llvm.ptr) -> !llvm.ptr
  %1096 = "llvm.mul"(%1084, %102) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1097 = "llvm.add"(%1096, %1064) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1098 = "llvm.getelementptr"(%459) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 256>}> : (!llvm.ptr) -> !llvm.ptr
  %1099 = "llvm.lshr"(%1086, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1100 = "llvm.lshr"(%1088, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1101 = "llvm.lshr"(%1091, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1102 = "llvm.lshr"(%1094, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1103 = "llvm.lshr"(%1097, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1104 = "llvm.and"(%1086, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1105 = "llvm.call_intrinsic"(%1104, %1103, %103) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1106 = "llvm.and"(%1088, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1107 = "llvm.add"(%1099, %1106) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1108 = "llvm.and"(%1091, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1109 = "llvm.add"(%1108, %1100) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1110 = "llvm.and"(%1094, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1111 = "llvm.add"(%1110, %1101) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1112 = "llvm.and"(%1097, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1113 = "llvm.add"(%1112, %1102) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1114 = "llvm.call_intrinsic"(%94, %1105, %806) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1115 = "llvm.shl"(%1114, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1116 = "llvm.call_intrinsic"(%1115, %1105, %766) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1117 = "llvm.call_intrinsic"(%1116, %1107, %806) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1118 = "llvm.call_intrinsic"(%94, %1105, %766) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1119 = "llvm.call_intrinsic"(%1118, %1107, %806) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1120 = "llvm.shl"(%1119, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1121 = "llvm.call_intrinsic"(%1120, %1105, %807) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1122 = "llvm.call_intrinsic"(%1121, %1107, %766) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1123 = "llvm.call_intrinsic"(%1122, %1109, %806) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1124 = "llvm.call_intrinsic"(%94, %1105, %807) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1125 = "llvm.call_intrinsic"(%1124, %1107, %766) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1126 = "llvm.call_intrinsic"(%1125, %1109, %806) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1127 = "llvm.shl"(%1126, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1128 = "llvm.call_intrinsic"(%1127, %1105, %808) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1129 = "llvm.call_intrinsic"(%1128, %1107, %807) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1130 = "llvm.call_intrinsic"(%1129, %1109, %766) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1131 = "llvm.call_intrinsic"(%1130, %1111, %806) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1132 = "llvm.call_intrinsic"(%94, %1105, %808) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1133 = "llvm.call_intrinsic"(%1132, %1107, %807) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1134 = "llvm.call_intrinsic"(%1133, %1109, %766) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1135 = "llvm.call_intrinsic"(%1134, %1111, %806) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1136 = "llvm.shl"(%1135, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1137 = "llvm.call_intrinsic"(%1136, %1105, %809) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1138 = "llvm.call_intrinsic"(%1137, %1107, %808) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1139 = "llvm.call_intrinsic"(%1138, %1109, %807) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1140 = "llvm.call_intrinsic"(%1139, %1111, %766) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1141 = "llvm.call_intrinsic"(%1140, %1113, %806) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1142 = "llvm.call_intrinsic"(%94, %1105, %809) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1143 = "llvm.call_intrinsic"(%1142, %1107, %808) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1144 = "llvm.call_intrinsic"(%1143, %1109, %807) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1145 = "llvm.call_intrinsic"(%1144, %1111, %766) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1146 = "llvm.call_intrinsic"(%1145, %1113, %806) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1147 = "llvm.shl"(%1146, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1148 = "llvm.call_intrinsic"(%1147, %1107, %809) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1149 = "llvm.call_intrinsic"(%1148, %1109, %808) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1150 = "llvm.call_intrinsic"(%1149, %1111, %807) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1151 = "llvm.call_intrinsic"(%1150, %1113, %766) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1152 = "llvm.call_intrinsic"(%94, %1107, %809) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1153 = "llvm.call_intrinsic"(%1152, %1109, %808) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1154 = "llvm.call_intrinsic"(%1153, %1111, %807) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1155 = "llvm.call_intrinsic"(%1154, %1113, %766) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1156 = "llvm.shl"(%1155, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1157 = "llvm.call_intrinsic"(%1156, %1109, %809) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1158 = "llvm.call_intrinsic"(%1157, %1111, %808) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1159 = "llvm.call_intrinsic"(%1158, %1113, %807) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1160 = "llvm.call_intrinsic"(%94, %1109, %809) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1161 = "llvm.call_intrinsic"(%1160, %1111, %808) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1162 = "llvm.call_intrinsic"(%1161, %1113, %807) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1163 = "llvm.shl"(%1162, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1164 = "llvm.call_intrinsic"(%1163, %1111, %809) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1165 = "llvm.call_intrinsic"(%1164, %1113, %808) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1166 = "llvm.call_intrinsic"(%94, %1111, %809) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1167 = "llvm.call_intrinsic"(%1166, %1113, %808) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1168 = "llvm.shl"(%1167, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1169 = "llvm.call_intrinsic"(%1168, %1113, %809) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1170 = "llvm.call_intrinsic"(%94, %1113, %809) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1171 = "llvm.mul"(%1151, %103) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1172 = "llvm.call_intrinsic"(%1171, %1105, %806) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1173 = "llvm.mul"(%1159, %103) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1174 = "llvm.add"(%1173, %1117) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1175 = "llvm.mul"(%1165, %103) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1176 = "llvm.add"(%1175, %1123) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1177 = "llvm.mul"(%1169, %103) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1178 = "llvm.add"(%1177, %1131) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1179 = "llvm.mul"(%1170, %102) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1180 = "llvm.add"(%1179, %1141) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1181 = "llvm.lshr"(%1172, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1182 = "llvm.lshr"(%1174, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1183 = "llvm.lshr"(%1176, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1184 = "llvm.lshr"(%1178, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1185 = "llvm.lshr"(%1180, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1186 = "llvm.and"(%1172, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1187 = "llvm.call_intrinsic"(%1186, %1185, %103) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1188 = "llvm.and"(%1174, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1189 = "llvm.add"(%1181, %1188) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1190 = "llvm.and"(%1176, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1191 = "llvm.add"(%1190, %1182) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1192 = "llvm.and"(%1178, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1193 = "llvm.add"(%1192, %1183) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1194 = "llvm.and"(%1180, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1195 = "llvm.add"(%1194, %1184) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1196 = "llvm.call_intrinsic"(%94, %1187, %797) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1197 = "llvm.shl"(%1196, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1198 = "llvm.call_intrinsic"(%1197, %1187, %799) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1199 = "llvm.call_intrinsic"(%1198, %1189, %797) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1200 = "llvm.call_intrinsic"(%94, %1187, %799) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1201 = "llvm.call_intrinsic"(%1200, %1189, %797) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1202 = "llvm.shl"(%1201, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1203 = "llvm.call_intrinsic"(%1202, %1187, %801) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1204 = "llvm.call_intrinsic"(%1203, %1189, %799) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1205 = "llvm.call_intrinsic"(%1204, %1191, %797) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1206 = "llvm.call_intrinsic"(%94, %1187, %801) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1207 = "llvm.call_intrinsic"(%1206, %1189, %799) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1208 = "llvm.call_intrinsic"(%1207, %1191, %797) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1209 = "llvm.shl"(%1208, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1210 = "llvm.call_intrinsic"(%1209, %1187, %803) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1211 = "llvm.call_intrinsic"(%1210, %1189, %801) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1212 = "llvm.call_intrinsic"(%1211, %1191, %799) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1213 = "llvm.call_intrinsic"(%1212, %1193, %797) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1214 = "llvm.call_intrinsic"(%94, %1187, %803) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1215 = "llvm.call_intrinsic"(%1214, %1189, %801) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1216 = "llvm.call_intrinsic"(%1215, %1191, %799) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1217 = "llvm.call_intrinsic"(%1216, %1193, %797) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1218 = "llvm.shl"(%1217, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1219 = "llvm.call_intrinsic"(%1218, %1187, %805) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1220 = "llvm.call_intrinsic"(%1219, %1189, %803) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1221 = "llvm.call_intrinsic"(%1220, %1191, %801) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1222 = "llvm.call_intrinsic"(%1221, %1193, %799) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1223 = "llvm.call_intrinsic"(%1222, %1195, %797) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1224 = "llvm.call_intrinsic"(%94, %1187, %805) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1225 = "llvm.call_intrinsic"(%1224, %1189, %803) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1226 = "llvm.call_intrinsic"(%1225, %1191, %801) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1227 = "llvm.call_intrinsic"(%1226, %1193, %799) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1228 = "llvm.call_intrinsic"(%1227, %1195, %797) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1229 = "llvm.shl"(%1228, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1230 = "llvm.call_intrinsic"(%1229, %1189, %805) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1231 = "llvm.call_intrinsic"(%1230, %1191, %803) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1232 = "llvm.call_intrinsic"(%1231, %1193, %801) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1233 = "llvm.call_intrinsic"(%1232, %1195, %799) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1234 = "llvm.call_intrinsic"(%94, %1189, %805) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1235 = "llvm.call_intrinsic"(%1234, %1191, %803) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1236 = "llvm.call_intrinsic"(%1235, %1193, %801) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1237 = "llvm.call_intrinsic"(%1236, %1195, %799) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1238 = "llvm.shl"(%1237, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1239 = "llvm.call_intrinsic"(%1238, %1191, %805) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1240 = "llvm.call_intrinsic"(%1239, %1193, %803) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1241 = "llvm.call_intrinsic"(%1240, %1195, %801) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1242 = "llvm.call_intrinsic"(%94, %1191, %805) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1243 = "llvm.call_intrinsic"(%1242, %1193, %803) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1244 = "llvm.call_intrinsic"(%1243, %1195, %801) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1245 = "llvm.shl"(%1244, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1246 = "llvm.call_intrinsic"(%1245, %1193, %805) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1247 = "llvm.call_intrinsic"(%1246, %1195, %803) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1248 = "llvm.call_intrinsic"(%94, %1193, %805) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1249 = "llvm.call_intrinsic"(%1248, %1195, %803) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1250 = "llvm.shl"(%1249, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1251 = "llvm.call_intrinsic"(%1250, %1195, %805) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1252 = "llvm.call_intrinsic"(%94, %1195, %805) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1253 = "llvm.mul"(%1233, %103) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1254 = "llvm.call_intrinsic"(%1253, %1187, %797) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1255 = "llvm.mul"(%1241, %103) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1256 = "llvm.add"(%1255, %1199) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1257 = "llvm.mul"(%1247, %103) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1258 = "llvm.add"(%1257, %1205) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1259 = "llvm.mul"(%1251, %103) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1260 = "llvm.add"(%1259, %1213) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1261 = "llvm.mul"(%1252, %102) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1262 = "llvm.add"(%1261, %1223) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1263 = "llvm.lshr"(%1254, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1264 = "llvm.lshr"(%1256, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1265 = "llvm.lshr"(%1258, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1266 = "llvm.lshr"(%1260, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1267 = "llvm.lshr"(%1262, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1268 = "llvm.and"(%1254, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1269 = "llvm.call_intrinsic"(%1268, %1267, %103) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%1269, %459) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %1270 = "llvm.and"(%1256, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1271 = "llvm.add"(%1263, %1270) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%1271, %1089) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %1272 = "llvm.and"(%1258, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1273 = "llvm.add"(%1272, %1264) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%1273, %1092) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %1274 = "llvm.and"(%1260, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1275 = "llvm.add"(%1274, %1265) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%1275, %1095) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %1276 = "llvm.and"(%1262, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1277 = "llvm.add"(%1276, %1266) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%1277, %1098) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.cond_br"(%457, %107, %160, %427, %426, %425, %424, %430, %437, %432, %435, %434, %252, %222, %192, %152)[^bb40, ^bb39] <{loop_annotation = #llvm.loop_annotation<mustProgress = true>, operandSegmentSizes = array<i32: 1, 15, 0>}> : (i1, i1, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
^bb41(%1278: i32, %1279: i1, %1280: !llvm.ptr, %1281: !llvm.ptr, %1282: !llvm.ptr, %1283: !llvm.ptr, %1284: !llvm.ptr):  // 2 preds: ^bb39, ^bb41
  %1285 = "llvm.load"(%1284) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 _ZTS21fd_ed25519_lane_point", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 _ZTS21fd_ed25519_lane_point", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> !llvm.ptr
  %1286 = "llvm.load"(%1285) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %1287 = "llvm.getelementptr"(%1285) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %1288 = "llvm.load"(%1287) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %1289 = "llvm.getelementptr"(%1285) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %1290 = "llvm.load"(%1289) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %1291 = "llvm.getelementptr"(%1285) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 192>}> : (!llvm.ptr) -> !llvm.ptr
  %1292 = "llvm.load"(%1291) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %1293 = "llvm.getelementptr"(%1285) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 256>}> : (!llvm.ptr) -> !llvm.ptr
  %1294 = "llvm.load"(%1293) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %1295 = "llvm.load"(%1281) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %1296 = "llvm.getelementptr"(%1281) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %1297 = "llvm.load"(%1296) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %1298 = "llvm.getelementptr"(%1281) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %1299 = "llvm.load"(%1298) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %1300 = "llvm.getelementptr"(%1281) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 192>}> : (!llvm.ptr) -> !llvm.ptr
  %1301 = "llvm.load"(%1300) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %1302 = "llvm.getelementptr"(%1281) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 256>}> : (!llvm.ptr) -> !llvm.ptr
  %1303 = "llvm.load"(%1302) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %1304 = "llvm.call_intrinsic"(%94, %1286, %1295) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1305 = "llvm.shl"(%1304, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1306 = "llvm.call_intrinsic"(%1305, %1286, %1297) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1307 = "llvm.call_intrinsic"(%1306, %1288, %1295) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1308 = "llvm.call_intrinsic"(%94, %1286, %1297) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1309 = "llvm.call_intrinsic"(%1308, %1288, %1295) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1310 = "llvm.shl"(%1309, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1311 = "llvm.call_intrinsic"(%1310, %1286, %1299) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1312 = "llvm.call_intrinsic"(%1311, %1288, %1297) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1313 = "llvm.call_intrinsic"(%1312, %1290, %1295) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1314 = "llvm.call_intrinsic"(%94, %1286, %1299) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1315 = "llvm.call_intrinsic"(%1314, %1288, %1297) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1316 = "llvm.call_intrinsic"(%1315, %1290, %1295) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1317 = "llvm.shl"(%1316, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1318 = "llvm.call_intrinsic"(%1317, %1286, %1301) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1319 = "llvm.call_intrinsic"(%1318, %1288, %1299) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1320 = "llvm.call_intrinsic"(%1319, %1290, %1297) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1321 = "llvm.call_intrinsic"(%1320, %1292, %1295) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1322 = "llvm.call_intrinsic"(%94, %1286, %1301) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1323 = "llvm.call_intrinsic"(%1322, %1288, %1299) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1324 = "llvm.call_intrinsic"(%1323, %1290, %1297) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1325 = "llvm.call_intrinsic"(%1324, %1292, %1295) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1326 = "llvm.shl"(%1325, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1327 = "llvm.call_intrinsic"(%1326, %1286, %1303) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1328 = "llvm.call_intrinsic"(%1327, %1288, %1301) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1329 = "llvm.call_intrinsic"(%1328, %1290, %1299) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1330 = "llvm.call_intrinsic"(%1329, %1292, %1297) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1331 = "llvm.call_intrinsic"(%1330, %1294, %1295) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1332 = "llvm.call_intrinsic"(%94, %1286, %1303) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1333 = "llvm.call_intrinsic"(%1332, %1288, %1301) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1334 = "llvm.call_intrinsic"(%1333, %1290, %1299) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1335 = "llvm.call_intrinsic"(%1334, %1292, %1297) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1336 = "llvm.call_intrinsic"(%1335, %1294, %1295) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1337 = "llvm.shl"(%1336, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1338 = "llvm.call_intrinsic"(%1337, %1288, %1303) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1339 = "llvm.call_intrinsic"(%1338, %1290, %1301) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1340 = "llvm.call_intrinsic"(%1339, %1292, %1299) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1341 = "llvm.call_intrinsic"(%1340, %1294, %1297) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1342 = "llvm.call_intrinsic"(%94, %1288, %1303) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1343 = "llvm.call_intrinsic"(%1342, %1290, %1301) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1344 = "llvm.call_intrinsic"(%1343, %1292, %1299) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1345 = "llvm.call_intrinsic"(%1344, %1294, %1297) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1346 = "llvm.shl"(%1345, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1347 = "llvm.call_intrinsic"(%1346, %1290, %1303) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1348 = "llvm.call_intrinsic"(%1347, %1292, %1301) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1349 = "llvm.call_intrinsic"(%1348, %1294, %1299) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1350 = "llvm.call_intrinsic"(%94, %1290, %1303) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1351 = "llvm.call_intrinsic"(%1350, %1292, %1301) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1352 = "llvm.call_intrinsic"(%1351, %1294, %1299) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1353 = "llvm.shl"(%1352, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1354 = "llvm.call_intrinsic"(%1353, %1292, %1303) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1355 = "llvm.call_intrinsic"(%1354, %1294, %1301) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1356 = "llvm.call_intrinsic"(%94, %1292, %1303) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1357 = "llvm.call_intrinsic"(%1356, %1294, %1301) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1358 = "llvm.shl"(%1357, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1359 = "llvm.call_intrinsic"(%1358, %1294, %1303) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1360 = "llvm.call_intrinsic"(%94, %1294, %1303) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1361 = "llvm.mul"(%1341, %103) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1362 = "llvm.call_intrinsic"(%1361, %1286, %1295) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1363 = "llvm.mul"(%1349, %103) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1364 = "llvm.add"(%1363, %1307) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1365 = "llvm.mul"(%1355, %103) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1366 = "llvm.add"(%1365, %1313) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1367 = "llvm.mul"(%1359, %103) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1368 = "llvm.add"(%1367, %1321) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1369 = "llvm.mul"(%1360, %102) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1370 = "llvm.add"(%1369, %1331) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1371 = "llvm.lshr"(%1362, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1372 = "llvm.lshr"(%1364, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1373 = "llvm.lshr"(%1366, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1374 = "llvm.lshr"(%1368, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1375 = "llvm.lshr"(%1370, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1376 = "llvm.and"(%1362, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1377 = "llvm.call_intrinsic"(%1376, %1375, %103) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%1377, %1285) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %1378 = "llvm.and"(%1364, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1379 = "llvm.add"(%1371, %1378) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%1379, %1287) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %1380 = "llvm.and"(%1366, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1381 = "llvm.add"(%1380, %1372) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%1381, %1289) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %1382 = "llvm.and"(%1368, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1383 = "llvm.add"(%1382, %1373) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%1383, %1291) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %1384 = "llvm.and"(%1370, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1385 = "llvm.add"(%1384, %1374) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%1385, %1293) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %1386 = "llvm.call_intrinsic"(%94, %1377, %1377) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1387 = "llvm.call_intrinsic"(%1386, %1377, %1379) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1388 = "llvm.shl"(%1387, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1389 = "llvm.call_intrinsic"(%94, %1377, %1379) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1390 = "llvm.shl"(%1389, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1391 = "llvm.call_intrinsic"(%1390, %1377, %1381) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1392 = "llvm.shl"(%1391, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1393 = "llvm.call_intrinsic"(%1392, %1379, %1379) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1394 = "llvm.call_intrinsic"(%94, %1377, %1381) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1395 = "llvm.shl"(%1394, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1396 = "llvm.call_intrinsic"(%1395, %1379, %1379) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1397 = "llvm.call_intrinsic"(%1396, %1377, %1383) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1398 = "llvm.call_intrinsic"(%1397, %1379, %1381) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1399 = "llvm.shl"(%1398, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1400 = "llvm.call_intrinsic"(%94, %1377, %1383) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1401 = "llvm.call_intrinsic"(%1400, %1379, %1381) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1402 = "llvm.shl"(%1401, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1403 = "llvm.call_intrinsic"(%1402, %1377, %1385) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1404 = "llvm.call_intrinsic"(%1403, %1379, %1383) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1405 = "llvm.shl"(%1404, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1406 = "llvm.call_intrinsic"(%1405, %1381, %1381) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1407 = "llvm.call_intrinsic"(%94, %1377, %1385) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1408 = "llvm.call_intrinsic"(%1407, %1379, %1383) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1409 = "llvm.shl"(%1408, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1410 = "llvm.call_intrinsic"(%1409, %1381, %1381) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1411 = "llvm.call_intrinsic"(%1410, %1379, %1385) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1412 = "llvm.call_intrinsic"(%1411, %1381, %1383) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1413 = "llvm.call_intrinsic"(%94, %1379, %1385) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1414 = "llvm.call_intrinsic"(%1413, %1381, %1383) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1415 = "llvm.shl"(%1414, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1416 = "llvm.call_intrinsic"(%1415, %1381, %1385) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1417 = "llvm.shl"(%1416, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1418 = "llvm.call_intrinsic"(%1417, %1383, %1383) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1419 = "llvm.call_intrinsic"(%94, %1381, %1385) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1420 = "llvm.shl"(%1419, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1421 = "llvm.call_intrinsic"(%1420, %1383, %1383) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1422 = "llvm.call_intrinsic"(%1421, %1383, %1385) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1423 = "llvm.call_intrinsic"(%94, %1383, %1385) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1424 = "llvm.shl"(%1423, %101) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1425 = "llvm.call_intrinsic"(%1424, %1385, %1385) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1426 = "llvm.call_intrinsic"(%94, %1385, %1385) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1427 = "llvm.mul"(%1412, %102) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1428 = "llvm.call_intrinsic"(%1427, %1377, %1377) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1429 = "llvm.mul"(%1418, %103) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1430 = "llvm.add"(%1429, %1388) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1431 = "llvm.mul"(%1422, %102) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1432 = "llvm.add"(%1431, %1393) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1433 = "llvm.mul"(%1425, %103) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1434 = "llvm.add"(%1433, %1399) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1435 = "llvm.mul"(%1426, %102) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1436 = "llvm.add"(%1435, %1406) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1437 = "llvm.lshr"(%1428, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1438 = "llvm.lshr"(%1430, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1439 = "llvm.lshr"(%1432, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1440 = "llvm.lshr"(%1434, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1441 = "llvm.lshr"(%1436, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1442 = "llvm.and"(%1428, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1443 = "llvm.call_intrinsic"(%1442, %1441, %103) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1444 = "llvm.and"(%1430, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1445 = "llvm.add"(%1437, %1444) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1446 = "llvm.and"(%1432, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1447 = "llvm.add"(%1446, %1438) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1448 = "llvm.and"(%1434, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1449 = "llvm.add"(%1448, %1439) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1450 = "llvm.and"(%1436, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1451 = "llvm.add"(%1450, %1440) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1452 = "llvm.load"(%1282) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %1453 = "llvm.getelementptr"(%1282) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %1454 = "llvm.load"(%1453) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %1455 = "llvm.getelementptr"(%1282) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %1456 = "llvm.load"(%1455) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %1457 = "llvm.getelementptr"(%1282) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 192>}> : (!llvm.ptr) -> !llvm.ptr
  %1458 = "llvm.load"(%1457) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %1459 = "llvm.getelementptr"(%1282) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 256>}> : (!llvm.ptr) -> !llvm.ptr
  %1460 = "llvm.load"(%1459) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %1461 = "llvm.call_intrinsic"(%94, %1443, %1452) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1462 = "llvm.shl"(%1461, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1463 = "llvm.call_intrinsic"(%1462, %1443, %1454) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1464 = "llvm.call_intrinsic"(%1463, %1445, %1452) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1465 = "llvm.call_intrinsic"(%94, %1443, %1454) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1466 = "llvm.call_intrinsic"(%1465, %1445, %1452) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1467 = "llvm.shl"(%1466, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1468 = "llvm.call_intrinsic"(%1467, %1443, %1456) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1469 = "llvm.call_intrinsic"(%1468, %1445, %1454) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1470 = "llvm.call_intrinsic"(%1469, %1447, %1452) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1471 = "llvm.call_intrinsic"(%94, %1443, %1456) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1472 = "llvm.call_intrinsic"(%1471, %1445, %1454) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1473 = "llvm.call_intrinsic"(%1472, %1447, %1452) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1474 = "llvm.shl"(%1473, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1475 = "llvm.call_intrinsic"(%1474, %1443, %1458) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1476 = "llvm.call_intrinsic"(%1475, %1445, %1456) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1477 = "llvm.call_intrinsic"(%1476, %1447, %1454) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1478 = "llvm.call_intrinsic"(%1477, %1449, %1452) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1479 = "llvm.call_intrinsic"(%94, %1443, %1458) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1480 = "llvm.call_intrinsic"(%1479, %1445, %1456) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1481 = "llvm.call_intrinsic"(%1480, %1447, %1454) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1482 = "llvm.call_intrinsic"(%1481, %1449, %1452) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1483 = "llvm.shl"(%1482, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1484 = "llvm.call_intrinsic"(%1483, %1443, %1460) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1485 = "llvm.call_intrinsic"(%1484, %1445, %1458) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1486 = "llvm.call_intrinsic"(%1485, %1447, %1456) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1487 = "llvm.call_intrinsic"(%1486, %1449, %1454) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1488 = "llvm.call_intrinsic"(%1487, %1451, %1452) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1489 = "llvm.call_intrinsic"(%94, %1443, %1460) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1490 = "llvm.call_intrinsic"(%1489, %1445, %1458) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1491 = "llvm.call_intrinsic"(%1490, %1447, %1456) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1492 = "llvm.call_intrinsic"(%1491, %1449, %1454) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1493 = "llvm.call_intrinsic"(%1492, %1451, %1452) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1494 = "llvm.shl"(%1493, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1495 = "llvm.call_intrinsic"(%1494, %1445, %1460) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1496 = "llvm.call_intrinsic"(%1495, %1447, %1458) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1497 = "llvm.call_intrinsic"(%1496, %1449, %1456) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1498 = "llvm.call_intrinsic"(%1497, %1451, %1454) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1499 = "llvm.call_intrinsic"(%94, %1445, %1460) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1500 = "llvm.call_intrinsic"(%1499, %1447, %1458) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1501 = "llvm.call_intrinsic"(%1500, %1449, %1456) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1502 = "llvm.call_intrinsic"(%1501, %1451, %1454) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1503 = "llvm.shl"(%1502, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1504 = "llvm.call_intrinsic"(%1503, %1447, %1460) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1505 = "llvm.call_intrinsic"(%1504, %1449, %1458) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1506 = "llvm.call_intrinsic"(%1505, %1451, %1456) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1507 = "llvm.call_intrinsic"(%94, %1447, %1460) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1508 = "llvm.call_intrinsic"(%1507, %1449, %1458) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1509 = "llvm.call_intrinsic"(%1508, %1451, %1456) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1510 = "llvm.shl"(%1509, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1511 = "llvm.call_intrinsic"(%1510, %1449, %1460) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1512 = "llvm.call_intrinsic"(%1511, %1451, %1458) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1513 = "llvm.call_intrinsic"(%94, %1449, %1460) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1514 = "llvm.call_intrinsic"(%1513, %1451, %1458) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1515 = "llvm.shl"(%1514, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1516 = "llvm.call_intrinsic"(%1515, %1451, %1460) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1517 = "llvm.call_intrinsic"(%94, %1451, %1460) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1518 = "llvm.mul"(%1498, %103) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1519 = "llvm.call_intrinsic"(%1518, %1443, %1452) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1520 = "llvm.mul"(%1506, %103) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1521 = "llvm.add"(%1520, %1464) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1522 = "llvm.mul"(%1512, %103) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1523 = "llvm.add"(%1522, %1470) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1524 = "llvm.mul"(%1516, %103) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1525 = "llvm.add"(%1524, %1478) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1526 = "llvm.mul"(%1517, %102) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1527 = "llvm.add"(%1526, %1488) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1528 = "llvm.lshr"(%1519, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1529 = "llvm.lshr"(%1521, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1530 = "llvm.lshr"(%1523, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1531 = "llvm.lshr"(%1525, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1532 = "llvm.lshr"(%1527, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1533 = "llvm.and"(%1519, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1534 = "llvm.call_intrinsic"(%1533, %1532, %103) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1535 = "llvm.and"(%1521, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1536 = "llvm.add"(%1528, %1535) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1537 = "llvm.and"(%1523, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1538 = "llvm.add"(%1537, %1529) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1539 = "llvm.and"(%1525, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1540 = "llvm.add"(%1539, %1530) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1541 = "llvm.and"(%1527, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1542 = "llvm.add"(%1541, %1531) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1543 = "llvm.add"(%1534, %108) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1544 = "llvm.load"(%1283) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %1545 = "llvm.sub"(%1543, %1544) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1546 = "llvm.add"(%1536, %109) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1547 = "llvm.getelementptr"(%1283) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %1548 = "llvm.load"(%1547) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %1549 = "llvm.sub"(%1546, %1548) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1550 = "llvm.add"(%1538, %109) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1551 = "llvm.getelementptr"(%1283) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %1552 = "llvm.load"(%1551) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %1553 = "llvm.sub"(%1550, %1552) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1554 = "llvm.add"(%1540, %109) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1555 = "llvm.getelementptr"(%1283) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 192>}> : (!llvm.ptr) -> !llvm.ptr
  %1556 = "llvm.load"(%1555) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %1557 = "llvm.sub"(%1554, %1556) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1558 = "llvm.add"(%1542, %109) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1559 = "llvm.getelementptr"(%1283) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 256>}> : (!llvm.ptr) -> !llvm.ptr
  %1560 = "llvm.load"(%1559) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %1561 = "llvm.sub"(%1558, %1560) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1562 = "llvm.add"(%1544, %1534) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1563 = "llvm.add"(%1548, %1536) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1564 = "llvm.add"(%1552, %1538) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1565 = "llvm.add"(%1556, %1540) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1566 = "llvm.add"(%1560, %1542) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1567 = "llvm.lshr"(%1545, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1568 = "llvm.add"(%1549, %1567) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1569 = "llvm.and"(%1545, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1570 = "llvm.lshr"(%1568, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1571 = "llvm.add"(%1553, %1570) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1572 = "llvm.and"(%1568, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1573 = "llvm.lshr"(%1571, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1574 = "llvm.add"(%1557, %1573) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1575 = "llvm.and"(%1571, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1576 = "llvm.lshr"(%1574, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1577 = "llvm.add"(%1561, %1576) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1578 = "llvm.and"(%1574, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1579 = "llvm.lshr"(%1577, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1580 = "llvm.mul"(%1579, %103) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1581 = "llvm.add"(%1580, %1569) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1582 = "llvm.and"(%1577, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1583 = "llvm.lshr"(%1581, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1584 = "llvm.add"(%1583, %1572) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1585 = "llvm.and"(%1581, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1586 = "llvm.lshr"(%1584, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1587 = "llvm.add"(%1586, %1575) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1588 = "llvm.lshr"(%1587, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1589 = "llvm.add"(%1588, %1578) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1590 = "llvm.lshr"(%1589, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1591 = "llvm.add"(%1590, %1582) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1592 = "llvm.lshr"(%1591, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1593 = "llvm.mul"(%1592, %103) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1594 = "llvm.add"(%1593, %1585) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1595 = "llvm.icmp"(%1594, %110) <{predicate = 0 : i64}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi1>
  %1596 = "llvm.or"(%1587, %1584) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1597 = "llvm.or"(%1596, %1589) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1598 = "llvm.or"(%1597, %1591) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1599 = "llvm.and"(%1598, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1600 = "llvm.or"(%1594, %1599) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1601 = "llvm.icmp"(%1600, %94) <{predicate = 0 : i64}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi1>
  %1602 = "llvm.and"(%1584, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1603 = "llvm.and"(%1602, %1587) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1604 = "llvm.and"(%1603, %1589) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1605 = "llvm.and"(%1604, %1591) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1606 = "llvm.icmp"(%1605, %96) <{predicate = 0 : i64}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi1>
  %1607 = "llvm.and"(%1606, %1595) : (vector<8xi1>, vector<8xi1>) -> vector<8xi1>
  %1608 = "llvm.or"(%1607, %1601) : (vector<8xi1>, vector<8xi1>) -> vector<8xi1>
  %1609 = "llvm.bitcast"(%1608) : (vector<8xi1>) -> i8
  %1610 = "llvm.lshr"(%1562, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1611 = "llvm.add"(%1563, %1610) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1612 = "llvm.and"(%1562, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1613 = "llvm.lshr"(%1611, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1614 = "llvm.add"(%1564, %1613) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1615 = "llvm.and"(%1611, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1616 = "llvm.lshr"(%1614, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1617 = "llvm.add"(%1565, %1616) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1618 = "llvm.and"(%1614, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1619 = "llvm.lshr"(%1617, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1620 = "llvm.add"(%1566, %1619) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1621 = "llvm.and"(%1617, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1622 = "llvm.lshr"(%1620, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1623 = "llvm.mul"(%1622, %103) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1624 = "llvm.add"(%1623, %1612) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1625 = "llvm.and"(%1620, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1626 = "llvm.lshr"(%1624, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1627 = "llvm.add"(%1626, %1615) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1628 = "llvm.and"(%1624, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1629 = "llvm.lshr"(%1627, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1630 = "llvm.add"(%1629, %1618) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1631 = "llvm.lshr"(%1630, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1632 = "llvm.add"(%1631, %1621) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1633 = "llvm.lshr"(%1632, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1634 = "llvm.add"(%1633, %1625) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1635 = "llvm.lshr"(%1634, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1636 = "llvm.mul"(%1635, %103) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1637 = "llvm.add"(%1636, %1628) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1638 = "llvm.icmp"(%1637, %110) <{predicate = 0 : i64}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi1>
  %1639 = "llvm.or"(%1630, %1627) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1640 = "llvm.or"(%1639, %1632) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1641 = "llvm.or"(%1640, %1634) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1642 = "llvm.and"(%1641, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1643 = "llvm.or"(%1637, %1642) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1644 = "llvm.icmp"(%1643, %94) <{predicate = 0 : i64}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi1>
  %1645 = "llvm.and"(%1627, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1646 = "llvm.and"(%1645, %1630) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1647 = "llvm.and"(%1646, %1632) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1648 = "llvm.and"(%1647, %1634) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1649 = "llvm.icmp"(%1648, %96) <{predicate = 0 : i64}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi1>
  %1650 = "llvm.and"(%1649, %1638) : (vector<8xi1>, vector<8xi1>) -> vector<8xi1>
  %1651 = "llvm.or"(%1650, %1644) : (vector<8xi1>, vector<8xi1>) -> vector<8xi1>
  %1652 = "llvm.bitcast"(%1651) : (vector<8xi1>) -> i8
  %1653 = "llvm.call_intrinsic"(%94, %1377, %448) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1654 = "llvm.shl"(%1653, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1655 = "llvm.call_intrinsic"(%1654, %1377, %450) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1656 = "llvm.call_intrinsic"(%1655, %1379, %448) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1657 = "llvm.call_intrinsic"(%94, %1377, %450) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1658 = "llvm.call_intrinsic"(%1657, %1379, %448) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1659 = "llvm.shl"(%1658, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1660 = "llvm.call_intrinsic"(%1659, %1377, %452) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1661 = "llvm.call_intrinsic"(%1660, %1379, %450) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1662 = "llvm.call_intrinsic"(%1661, %1381, %448) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1663 = "llvm.call_intrinsic"(%94, %1377, %452) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1664 = "llvm.call_intrinsic"(%1663, %1379, %450) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1665 = "llvm.call_intrinsic"(%1664, %1381, %448) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1666 = "llvm.shl"(%1665, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1667 = "llvm.call_intrinsic"(%1666, %1377, %454) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1668 = "llvm.call_intrinsic"(%1667, %1379, %452) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1669 = "llvm.call_intrinsic"(%1668, %1381, %450) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1670 = "llvm.call_intrinsic"(%1669, %1383, %448) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1671 = "llvm.call_intrinsic"(%94, %1377, %454) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1672 = "llvm.call_intrinsic"(%1671, %1379, %452) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1673 = "llvm.call_intrinsic"(%1672, %1381, %450) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1674 = "llvm.call_intrinsic"(%1673, %1383, %448) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1675 = "llvm.shl"(%1674, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1676 = "llvm.call_intrinsic"(%1675, %1377, %456) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1677 = "llvm.call_intrinsic"(%1676, %1379, %454) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1678 = "llvm.call_intrinsic"(%1677, %1381, %452) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1679 = "llvm.call_intrinsic"(%1678, %1383, %450) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1680 = "llvm.call_intrinsic"(%1679, %1385, %448) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1681 = "llvm.call_intrinsic"(%94, %1377, %456) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1682 = "llvm.call_intrinsic"(%1681, %1379, %454) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1683 = "llvm.call_intrinsic"(%1682, %1381, %452) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1684 = "llvm.call_intrinsic"(%1683, %1383, %450) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1685 = "llvm.call_intrinsic"(%1684, %1385, %448) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1686 = "llvm.shl"(%1685, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1687 = "llvm.call_intrinsic"(%1686, %1379, %456) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1688 = "llvm.call_intrinsic"(%1687, %1381, %454) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1689 = "llvm.call_intrinsic"(%1688, %1383, %452) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1690 = "llvm.call_intrinsic"(%1689, %1385, %450) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1691 = "llvm.call_intrinsic"(%94, %1379, %456) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1692 = "llvm.call_intrinsic"(%1691, %1381, %454) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1693 = "llvm.call_intrinsic"(%1692, %1383, %452) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1694 = "llvm.call_intrinsic"(%1693, %1385, %450) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1695 = "llvm.shl"(%1694, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1696 = "llvm.call_intrinsic"(%1695, %1381, %456) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1697 = "llvm.call_intrinsic"(%1696, %1383, %454) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1698 = "llvm.call_intrinsic"(%1697, %1385, %452) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1699 = "llvm.call_intrinsic"(%94, %1381, %456) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1700 = "llvm.call_intrinsic"(%1699, %1383, %454) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1701 = "llvm.call_intrinsic"(%1700, %1385, %452) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1702 = "llvm.shl"(%1701, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1703 = "llvm.call_intrinsic"(%1702, %1383, %456) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1704 = "llvm.call_intrinsic"(%1703, %1385, %454) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1705 = "llvm.call_intrinsic"(%94, %1383, %456) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1706 = "llvm.call_intrinsic"(%1705, %1385, %454) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1707 = "llvm.shl"(%1706, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1708 = "llvm.call_intrinsic"(%1707, %1385, %456) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1709 = "llvm.call_intrinsic"(%94, %1385, %456) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1710 = "llvm.mul"(%1690, %103) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1711 = "llvm.call_intrinsic"(%1710, %1377, %448) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1712 = "llvm.mul"(%1698, %103) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1713 = "llvm.add"(%1712, %1656) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1714 = "llvm.mul"(%1704, %103) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1715 = "llvm.add"(%1714, %1662) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1716 = "llvm.mul"(%1708, %103) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1717 = "llvm.add"(%1716, %1670) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1718 = "llvm.mul"(%1709, %102) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1719 = "llvm.add"(%1718, %1680) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1720 = "llvm.lshr"(%1711, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1721 = "llvm.lshr"(%1713, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1722 = "llvm.lshr"(%1715, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1723 = "llvm.lshr"(%1717, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1724 = "llvm.lshr"(%1719, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1725 = "llvm.and"(%1711, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1726 = "llvm.call_intrinsic"(%1725, %1724, %103) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1727 = "llvm.and"(%1713, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1728 = "llvm.add"(%1720, %1727) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1729 = "llvm.and"(%1715, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1730 = "llvm.add"(%1729, %1721) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1731 = "llvm.and"(%1717, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1732 = "llvm.add"(%1731, %1722) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1733 = "llvm.and"(%1719, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1734 = "llvm.add"(%1733, %1723) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1735 = "llvm.xor"(%1609, %111) : (i8, i8) -> i8
  %1736 = "llvm.and"(%1652, %1735) : (i8, i8) -> i8
  %1737 = "llvm.bitcast"(%1736) : (i8) -> vector<8xi1>
  %1738 = "llvm.select"(%1737, %1726, %1377) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1739 = "llvm.select"(%1737, %1728, %1379) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1740 = "llvm.select"(%1737, %1730, %1381) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1741 = "llvm.select"(%1737, %1732, %1383) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1742 = "llvm.select"(%1737, %1734, %1385) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1743 = "llvm.lshr"(%1738, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1744 = "llvm.add"(%1743, %1739) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1745 = "llvm.and"(%1738, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1746 = "llvm.lshr"(%1744, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1747 = "llvm.add"(%1746, %1740) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1748 = "llvm.and"(%1744, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1749 = "llvm.lshr"(%1747, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1750 = "llvm.add"(%1749, %1741) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1751 = "llvm.and"(%1747, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1752 = "llvm.lshr"(%1750, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1753 = "llvm.add"(%1752, %1742) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1754 = "llvm.and"(%1750, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1755 = "llvm.lshr"(%1753, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1756 = "llvm.mul"(%1755, %103) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1757 = "llvm.add"(%1756, %1745) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1758 = "llvm.and"(%1753, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1759 = "llvm.lshr"(%1757, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1760 = "llvm.add"(%1759, %1748) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1761 = "llvm.and"(%1757, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1762 = "llvm.lshr"(%1760, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1763 = "llvm.add"(%1762, %1751) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1764 = "llvm.lshr"(%1763, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1765 = "llvm.add"(%1764, %1754) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1766 = "llvm.lshr"(%1765, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1767 = "llvm.add"(%1766, %1758) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1768 = "llvm.lshr"(%1767, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1769 = "llvm.mul"(%1768, %103) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1770 = "llvm.add"(%1769, %1761) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1771 = "llvm.icmp"(%1770, %112) <{predicate = 8 : i64}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi1>
  %1772 = "llvm.sub"(%108, %1738) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1773 = "llvm.sub"(%109, %1739) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1774 = "llvm.sub"(%109, %1740) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1775 = "llvm.sub"(%109, %1741) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1776 = "llvm.sub"(%109, %1742) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1777 = "llvm.and"(%1760, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1778 = "llvm.and"(%1777, %1763) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1779 = "llvm.and"(%1778, %1765) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1780 = "llvm.and"(%1779, %1767) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1781 = "llvm.icmp"(%1780, %96) <{predicate = 0 : i64}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi1>
  %1782 = "llvm.and"(%1781, %1771) : (vector<8xi1>, vector<8xi1>) -> vector<8xi1>
  %1783 = "llvm.bitcast"(%1782) : (vector<8xi1>) -> i8
  %1784 = "llvm.or"(%1652, %1609) : (i8, i8) -> i8
  %1785 = "llvm.trunc"(%1770) <{overflowFlags = 0 : i32}> : (vector<8xi64>) -> vector<8xi1>
  %1786 = "llvm.bitcast"(%1785) : (vector<8xi1>) -> i8
  %1787 = "llvm.load"(%1280) <{alignment = 4 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i32
  %1788 = "llvm.trunc"(%1787) <{overflowFlags = 0 : i32}> : (i32) -> i8
  %1789 = "llvm.xor"(%1786, %1788) : (i8, i8) -> i8
  %1790 = "llvm.xor"(%1789, %1783) : (i8, i8) -> i8
  %1791 = "llvm.bitcast"(%1790) : (i8) -> vector<8xi1>
  %1792 = "llvm.bitcast"(%1784) : (i8) -> vector<8xi1>
  %1793 = "llvm.getelementptr"(%1285) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 320>}> : (!llvm.ptr) -> !llvm.ptr
  %1794 = "llvm.select"(%1791, %1772, %1738) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1795 = "llvm.select"(%1792, %1794, %94) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%1795, %1285) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %1796 = "llvm.load"(%1793) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %1797 = "llvm.select"(%1792, %1796, %95) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%1797, %1793) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %1798 = "llvm.select"(%1791, %1773, %1739) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1799 = "llvm.select"(%1792, %1798, %94) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%1799, %1287) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %1800 = "llvm.getelementptr"(%1285) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 384>}> : (!llvm.ptr) -> !llvm.ptr
  %1801 = "llvm.load"(%1800) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %1802 = "llvm.select"(%1792, %1801, %94) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%1802, %1800) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %1803 = "llvm.select"(%1791, %1774, %1740) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1804 = "llvm.select"(%1792, %1803, %94) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%1804, %1289) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %1805 = "llvm.getelementptr"(%1285) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 448>}> : (!llvm.ptr) -> !llvm.ptr
  %1806 = "llvm.load"(%1805) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %1807 = "llvm.select"(%1792, %1806, %94) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%1807, %1805) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %1808 = "llvm.select"(%1791, %1775, %1741) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1809 = "llvm.select"(%1792, %1808, %94) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%1809, %1291) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %1810 = "llvm.getelementptr"(%1285) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 512>}> : (!llvm.ptr) -> !llvm.ptr
  %1811 = "llvm.load"(%1810) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %1812 = "llvm.select"(%1792, %1811, %94) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%1812, %1810) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %1813 = "llvm.select"(%1791, %1776, %1742) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1814 = "llvm.select"(%1792, %1813, %94) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%1814, %1293) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %1815 = "llvm.getelementptr"(%1285) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 576>}> : (!llvm.ptr) -> !llvm.ptr
  %1816 = "llvm.load"(%1815) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %1817 = "llvm.select"(%1792, %1816, %94) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%1817, %1815) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %1818 = "llvm.zext"(%1784) : (i8) -> i32
  %1819 = "llvm.getelementptr"(%1285) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 960>}> : (!llvm.ptr) -> !llvm.ptr
  %1820 = "llvm.call_intrinsic"(%94, %1795, %1797) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1821 = "llvm.shl"(%1820, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1822 = "llvm.call_intrinsic"(%1821, %1795, %1802) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1823 = "llvm.call_intrinsic"(%1822, %1799, %1797) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1824 = "llvm.call_intrinsic"(%94, %1795, %1802) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1825 = "llvm.call_intrinsic"(%1824, %1799, %1797) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1826 = "llvm.shl"(%1825, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1827 = "llvm.call_intrinsic"(%1826, %1795, %1807) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1828 = "llvm.call_intrinsic"(%1827, %1799, %1802) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1829 = "llvm.call_intrinsic"(%1828, %1804, %1797) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1830 = "llvm.call_intrinsic"(%94, %1795, %1807) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1831 = "llvm.call_intrinsic"(%1830, %1799, %1802) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1832 = "llvm.call_intrinsic"(%1831, %1804, %1797) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1833 = "llvm.shl"(%1832, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1834 = "llvm.call_intrinsic"(%1833, %1795, %1812) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1835 = "llvm.call_intrinsic"(%1834, %1799, %1807) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1836 = "llvm.call_intrinsic"(%1835, %1804, %1802) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1837 = "llvm.call_intrinsic"(%1836, %1809, %1797) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1838 = "llvm.call_intrinsic"(%94, %1795, %1812) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1839 = "llvm.call_intrinsic"(%1838, %1799, %1807) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1840 = "llvm.call_intrinsic"(%1839, %1804, %1802) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1841 = "llvm.call_intrinsic"(%1840, %1809, %1797) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1842 = "llvm.shl"(%1841, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1843 = "llvm.call_intrinsic"(%1842, %1795, %1817) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1844 = "llvm.call_intrinsic"(%1843, %1799, %1812) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1845 = "llvm.call_intrinsic"(%1844, %1804, %1807) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1846 = "llvm.call_intrinsic"(%1845, %1809, %1802) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1847 = "llvm.call_intrinsic"(%1846, %1814, %1797) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1848 = "llvm.call_intrinsic"(%94, %1795, %1817) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1849 = "llvm.call_intrinsic"(%1848, %1799, %1812) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1850 = "llvm.call_intrinsic"(%1849, %1804, %1807) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1851 = "llvm.call_intrinsic"(%1850, %1809, %1802) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1852 = "llvm.call_intrinsic"(%1851, %1814, %1797) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1853 = "llvm.shl"(%1852, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1854 = "llvm.call_intrinsic"(%1853, %1799, %1817) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1855 = "llvm.call_intrinsic"(%1854, %1804, %1812) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1856 = "llvm.call_intrinsic"(%1855, %1809, %1807) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1857 = "llvm.call_intrinsic"(%1856, %1814, %1802) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1858 = "llvm.call_intrinsic"(%94, %1799, %1817) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1859 = "llvm.call_intrinsic"(%1858, %1804, %1812) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1860 = "llvm.call_intrinsic"(%1859, %1809, %1807) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1861 = "llvm.call_intrinsic"(%1860, %1814, %1802) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1862 = "llvm.shl"(%1861, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1863 = "llvm.call_intrinsic"(%1862, %1804, %1817) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1864 = "llvm.call_intrinsic"(%1863, %1809, %1812) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1865 = "llvm.call_intrinsic"(%1864, %1814, %1807) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1866 = "llvm.call_intrinsic"(%94, %1804, %1817) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1867 = "llvm.call_intrinsic"(%1866, %1809, %1812) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1868 = "llvm.call_intrinsic"(%1867, %1814, %1807) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1869 = "llvm.shl"(%1868, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1870 = "llvm.call_intrinsic"(%1869, %1809, %1817) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1871 = "llvm.call_intrinsic"(%1870, %1814, %1812) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1872 = "llvm.call_intrinsic"(%94, %1809, %1817) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1873 = "llvm.call_intrinsic"(%1872, %1814, %1812) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1874 = "llvm.shl"(%1873, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1875 = "llvm.call_intrinsic"(%1874, %1814, %1817) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1876 = "llvm.call_intrinsic"(%94, %1814, %1817) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1877 = "llvm.mul"(%1857, %103) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1878 = "llvm.call_intrinsic"(%1877, %1795, %1797) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1879 = "llvm.mul"(%1865, %103) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1880 = "llvm.add"(%1879, %1823) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1881 = "llvm.getelementptr"(%1285) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1024>}> : (!llvm.ptr) -> !llvm.ptr
  %1882 = "llvm.mul"(%1871, %103) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1883 = "llvm.add"(%1882, %1829) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1884 = "llvm.getelementptr"(%1285) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1088>}> : (!llvm.ptr) -> !llvm.ptr
  %1885 = "llvm.mul"(%1875, %103) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1886 = "llvm.add"(%1885, %1837) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1887 = "llvm.getelementptr"(%1285) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1152>}> : (!llvm.ptr) -> !llvm.ptr
  %1888 = "llvm.mul"(%1876, %102) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1889 = "llvm.add"(%1888, %1847) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1890 = "llvm.getelementptr"(%1285) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1216>}> : (!llvm.ptr) -> !llvm.ptr
  %1891 = "llvm.lshr"(%1878, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1892 = "llvm.lshr"(%1880, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1893 = "llvm.lshr"(%1883, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1894 = "llvm.lshr"(%1886, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1895 = "llvm.lshr"(%1889, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1896 = "llvm.and"(%1878, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1897 = "llvm.call_intrinsic"(%1896, %1895, %103) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%1897, %1819) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %1898 = "llvm.and"(%1880, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1899 = "llvm.add"(%1891, %1898) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%1899, %1881) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %1900 = "llvm.and"(%1883, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1901 = "llvm.add"(%1900, %1892) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%1901, %1884) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %1902 = "llvm.and"(%1886, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1903 = "llvm.add"(%1902, %1893) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%1903, %1887) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %1904 = "llvm.and"(%1889, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %1905 = "llvm.add"(%1904, %1894) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%1905, %1890) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.cond_br"(%1279, %1818, %107, %160, %426, %425, %424, %152)[^bb41, ^bb42] <{loop_annotation = #llvm.loop_annotation<mustProgress = true>, operandSegmentSizes = array<i32: 1, 7, 0>}> : (i1, i32, i1, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
^bb42:  // pred: ^bb41
  "llvm.intr.lifetime.end"(%159) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%160) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%158) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%157) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%156) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%155) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%154) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%153) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%151) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%152) : (!llvm.ptr) -> ()
  %1906 = "llvm.call"(%163) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}], callee = @fd_ed25519_lane_small_order, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i32
  %1907 = "llvm.call"(%164) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}], callee = @fd_ed25519_lane_small_order, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> i32
  %1908 = "llvm.icmp"(%arg6, %69) <{predicate = 6 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1908, %66, %61)[^bb51, ^bb43] <{operandSegmentSizes = array<i32: 1, 2, 0>}> : (i1, i64, i32) -> ()
^bb43:  // pred: ^bb42
  %1909 = "llvm.icmp"(%arg6, %56) <{predicate = 6 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1909, %66, %61)[^bb48, ^bb44] <{operandSegmentSizes = array<i32: 1, 2, 0>}> : (i1, i64, i32) -> ()
^bb44:  // pred: ^bb43
  %1910 = "llvm.and"(%arg6, %73) : (i64, i64) -> i64
  %1911 = "llvm.and"(%arg6, %113) : (i64, i64) -> i64
  %1912 = "llvm.insertelement"(%114, %1278, %66) : (vector<16xi32>, i32, i64) -> vector<16xi32>
  %1913 = "llvm.shufflevector"(%1912, %114) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<16xi32>, vector<16xi32>) -> vector<16xi32>
  %1914 = "llvm.insertelement"(%114, %1818, %66) : (vector<16xi32>, i32, i64) -> vector<16xi32>
  %1915 = "llvm.shufflevector"(%1914, %114) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<16xi32>, vector<16xi32>) -> vector<16xi32>
  %1916 = "llvm.insertelement"(%114, %1906, %66) : (vector<16xi32>, i32, i64) -> vector<16xi32>
  %1917 = "llvm.shufflevector"(%1916, %114) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<16xi32>, vector<16xi32>) -> vector<16xi32>
  %1918 = "llvm.insertelement"(%114, %1907, %66) : (vector<16xi32>, i32, i64) -> vector<16xi32>
  %1919 = "llvm.shufflevector"(%1918, %114) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<16xi32>, vector<16xi32>) -> vector<16xi32>
  %1920 = "llvm.insertelement"(%114, %428, %66) : (vector<16xi32>, i32, i64) -> vector<16xi32>
  %1921 = "llvm.shufflevector"(%1920, %114) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<16xi32>, vector<16xi32>) -> vector<16xi32>
  "llvm.br"(%66, %115, %115, %116)[^bb45] : (i64, vector<16xi32>, vector<16xi32>, vector<16xi32>) -> ()
^bb45(%1922: i64, %1923: vector<16xi32>, %1924: vector<16xi32>, %1925: vector<16xi32>):  // 2 preds: ^bb44, ^bb45
  %1926 = "llvm.add"(%1925, %117) <{overflowFlags = 0 : i32}> : (vector<16xi32>, vector<16xi32>) -> vector<16xi32>
  %1927 = "llvm.shl"(%118, %1925) <{overflowFlags = 2 : i32}> : (vector<16xi32>, vector<16xi32>) -> vector<16xi32>
  %1928 = "llvm.shl"(%118, %1926) <{overflowFlags = 2 : i32}> : (vector<16xi32>, vector<16xi32>) -> vector<16xi32>
  %1929 = "llvm.and"(%1927, %1921) : (vector<16xi32>, vector<16xi32>) -> vector<16xi32>
  %1930 = "llvm.and"(%1928, %1921) : (vector<16xi32>, vector<16xi32>) -> vector<16xi32>
  %1931 = "llvm.icmp"(%1929, %115) <{predicate = 1 : i64}> : (vector<16xi32>, vector<16xi32>) -> vector<16xi1>
  %1932 = "llvm.icmp"(%1930, %115) <{predicate = 1 : i64}> : (vector<16xi32>, vector<16xi32>) -> vector<16xi1>
  %1933 = "llvm.and"(%1927, %1913) : (vector<16xi32>, vector<16xi32>) -> vector<16xi32>
  %1934 = "llvm.and"(%1928, %1913) : (vector<16xi32>, vector<16xi32>) -> vector<16xi32>
  %1935 = "llvm.icmp"(%1933, %115) <{predicate = 0 : i64}> : (vector<16xi32>, vector<16xi32>) -> vector<16xi1>
  %1936 = "llvm.icmp"(%1934, %115) <{predicate = 0 : i64}> : (vector<16xi32>, vector<16xi32>) -> vector<16xi1>
  %1937 = "llvm.xor"(%1935, %119) : (vector<16xi1>, vector<16xi1>) -> vector<16xi1>
  %1938 = "llvm.xor"(%1936, %119) : (vector<16xi1>, vector<16xi1>) -> vector<16xi1>
  %1939 = "llvm.select"(%1931, %1937, %120) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<16xi1>, vector<16xi1>, vector<16xi1>) -> vector<16xi1>
  %1940 = "llvm.select"(%1932, %1938, %120) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<16xi1>, vector<16xi1>, vector<16xi1>) -> vector<16xi1>
  %1941 = "llvm.and"(%1927, %1915) : (vector<16xi32>, vector<16xi32>) -> vector<16xi32>
  %1942 = "llvm.and"(%1928, %1915) : (vector<16xi32>, vector<16xi32>) -> vector<16xi32>
  %1943 = "llvm.icmp"(%1941, %115) <{predicate = 0 : i64}> : (vector<16xi32>, vector<16xi32>) -> vector<16xi1>
  %1944 = "llvm.icmp"(%1942, %115) <{predicate = 0 : i64}> : (vector<16xi32>, vector<16xi32>) -> vector<16xi1>
  %1945 = "llvm.xor"(%1943, %119) : (vector<16xi1>, vector<16xi1>) -> vector<16xi1>
  %1946 = "llvm.xor"(%1944, %119) : (vector<16xi1>, vector<16xi1>) -> vector<16xi1>
  %1947 = "llvm.select"(%1939, %1945, %120) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<16xi1>, vector<16xi1>, vector<16xi1>) -> vector<16xi1>
  %1948 = "llvm.select"(%1940, %1946, %120) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<16xi1>, vector<16xi1>, vector<16xi1>) -> vector<16xi1>
  %1949 = "llvm.and"(%1927, %1917) : (vector<16xi32>, vector<16xi32>) -> vector<16xi32>
  %1950 = "llvm.and"(%1928, %1917) : (vector<16xi32>, vector<16xi32>) -> vector<16xi32>
  %1951 = "llvm.icmp"(%1949, %115) <{predicate = 1 : i64}> : (vector<16xi32>, vector<16xi32>) -> vector<16xi1>
  %1952 = "llvm.icmp"(%1950, %115) <{predicate = 1 : i64}> : (vector<16xi32>, vector<16xi32>) -> vector<16xi1>
  %1953 = "llvm.select"(%1947, %1951, %120) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<16xi1>, vector<16xi1>, vector<16xi1>) -> vector<16xi1>
  %1954 = "llvm.select"(%1948, %1952, %120) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<16xi1>, vector<16xi1>, vector<16xi1>) -> vector<16xi1>
  %1955 = "llvm.getelementptr"(%arg5, %1922) <{elem_type = !llvm.array<4 x i8>, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %1956 = "llvm.getelementptr"(%1955) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.masked.store"(%121, %1955, %1953) <{alignment = 4 : i32}> : (vector<16xi32>, !llvm.ptr, vector<16xi1>) -> ()
  "llvm.intr.masked.store"(%121, %1956, %1954) <{alignment = 4 : i32}> : (vector<16xi32>, !llvm.ptr, vector<16xi1>) -> ()
  %1957 = "llvm.and"(%1927, %1919) : (vector<16xi32>, vector<16xi32>) -> vector<16xi32>
  %1958 = "llvm.and"(%1928, %1919) : (vector<16xi32>, vector<16xi32>) -> vector<16xi32>
  %1959 = "llvm.icmp"(%1957, %115) <{predicate = 0 : i64}> : (vector<16xi32>, vector<16xi32>) -> vector<16xi1>
  %1960 = "llvm.icmp"(%1958, %115) <{predicate = 0 : i64}> : (vector<16xi32>, vector<16xi32>) -> vector<16xi1>
  %1961 = "llvm.select"(%1939, %1943, %120) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<16xi1>, vector<16xi1>, vector<16xi1>) -> vector<16xi1>
  %1962 = "llvm.select"(%1940, %1944, %120) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<16xi1>, vector<16xi1>, vector<16xi1>) -> vector<16xi1>
  "llvm.intr.masked.store"(%122, %1955, %1961) <{alignment = 4 : i32}> : (vector<16xi32>, !llvm.ptr, vector<16xi1>) -> ()
  "llvm.intr.masked.store"(%122, %1956, %1962) <{alignment = 4 : i32}> : (vector<16xi32>, !llvm.ptr, vector<16xi1>) -> ()
  %1963 = "llvm.select"(%1931, %1935, %120) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<16xi1>, vector<16xi1>, vector<16xi1>) -> vector<16xi1>
  %1964 = "llvm.select"(%1932, %1936, %120) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<16xi1>, vector<16xi1>, vector<16xi1>) -> vector<16xi1>
  "llvm.intr.masked.store"(%121, %1955, %1963) <{alignment = 4 : i32}> : (vector<16xi32>, !llvm.ptr, vector<16xi1>) -> ()
  "llvm.intr.masked.store"(%121, %1956, %1964) <{alignment = 4 : i32}> : (vector<16xi32>, !llvm.ptr, vector<16xi1>) -> ()
  %1965 = "llvm.select"(%1961, %119, %1953) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<16xi1>, vector<16xi1>, vector<16xi1>) -> vector<16xi1>
  %1966 = "llvm.select"(%1965, %119, %1963) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<16xi1>, vector<16xi1>, vector<16xi1>) -> vector<16xi1>
  %1967 = "llvm.xor"(%1966, %119) : (vector<16xi1>, vector<16xi1>) -> vector<16xi1>
  %1968 = "llvm.select"(%1931, %1967, %120) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<16xi1>, vector<16xi1>, vector<16xi1>) -> vector<16xi1>
  %1969 = "llvm.select"(%1968, %1959, %120) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<16xi1>, vector<16xi1>, vector<16xi1>) -> vector<16xi1>
  %1970 = "llvm.select"(%1969, %1927, %115) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<16xi1>, vector<16xi32>, vector<16xi32>) -> vector<16xi32>
  %1971 = "llvm.or"(%1923, %1970) : (vector<16xi32>, vector<16xi32>) -> vector<16xi32>
  %1972 = "llvm.select"(%1962, %119, %1954) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<16xi1>, vector<16xi1>, vector<16xi1>) -> vector<16xi1>
  %1973 = "llvm.select"(%1972, %119, %1964) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<16xi1>, vector<16xi1>, vector<16xi1>) -> vector<16xi1>
  %1974 = "llvm.xor"(%1973, %119) : (vector<16xi1>, vector<16xi1>) -> vector<16xi1>
  %1975 = "llvm.select"(%1932, %1974, %120) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<16xi1>, vector<16xi1>, vector<16xi1>) -> vector<16xi1>
  %1976 = "llvm.select"(%1975, %1960, %120) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<16xi1>, vector<16xi1>, vector<16xi1>) -> vector<16xi1>
  %1977 = "llvm.select"(%1976, %1928, %115) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<16xi1>, vector<16xi32>, vector<16xi32>) -> vector<16xi32>
  %1978 = "llvm.or"(%1924, %1977) : (vector<16xi32>, vector<16xi32>) -> vector<16xi32>
  %1979 = "llvm.add"(%1922, %56) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %1980 = "llvm.add"(%1925, %123) <{overflowFlags = 0 : i32}> : (vector<16xi32>, vector<16xi32>) -> vector<16xi32>
  %1981 = "llvm.icmp"(%1979, %1911) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1981, %1979, %1971, %1978, %1980)[^bb46, ^bb45] <{loop_annotation = #llvm.loop_annotation<unroll = <runtimeDisable = true>, mustProgress = true, isVectorized = true>, operandSegmentSizes = array<i32: 1, 0, 4>}> : (i1, i64, vector<16xi32>, vector<16xi32>, vector<16xi32>) -> ()
^bb46:  // pred: ^bb45
  %1982 = "llvm.or"(%1978, %1971) : (vector<16xi32>, vector<16xi32>) -> vector<16xi32>
  %1983 = "llvm.intr.vector.reduce.or"(%1982) : (vector<16xi32>) -> i32
  %1984 = "llvm.icmp"(%arg6, %1911) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1984, %1983)[^bb52, ^bb47] <{operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i32) -> ()
^bb47:  // pred: ^bb46
  %1985 = "llvm.icmp"(%1910, %66) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%1985, %1911, %1983, %1911, %1983)[^bb51, ^bb48] <{branch_weights = array<i32: 8, 24>, operandSegmentSizes = array<i32: 1, 2, 2>}> : (i1, i64, i32, i64, i32) -> ()
^bb48(%1986: i64, %1987: i32):  // 2 preds: ^bb43, ^bb47
  %1988 = "llvm.and"(%arg6, %124) : (i64, i64) -> i64
  %1989 = "llvm.insertelement"(%134, %1987, %66) : (vector<8xi32>, i32, i64) -> vector<8xi32>
  %1990 = "llvm.insertelement"(%47, %1278, %66) : (vector<8xi32>, i32, i64) -> vector<8xi32>
  %1991 = "llvm.shufflevector"(%1990, %47) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1992 = "llvm.insertelement"(%47, %1818, %66) : (vector<8xi32>, i32, i64) -> vector<8xi32>
  %1993 = "llvm.shufflevector"(%1992, %47) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1994 = "llvm.insertelement"(%47, %1906, %66) : (vector<8xi32>, i32, i64) -> vector<8xi32>
  %1995 = "llvm.shufflevector"(%1994, %47) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1996 = "llvm.insertelement"(%47, %1907, %66) : (vector<8xi32>, i32, i64) -> vector<8xi32>
  %1997 = "llvm.shufflevector"(%1996, %47) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %1998 = "llvm.insertelement"(%47, %428, %66) : (vector<8xi32>, i32, i64) -> vector<8xi32>
  %1999 = "llvm.shufflevector"(%1998, %47) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %2000 = "llvm.trunc"(%1986) <{overflowFlags = 0 : i32}> : (i64) -> i32
  %2001 = "llvm.insertelement"(%47, %2000, %66) : (vector<8xi32>, i32, i64) -> vector<8xi32>
  %2002 = "llvm.shufflevector"(%2001, %47) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %2003 = "llvm.or"(%2002, %46) <{isDisjoint}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  "llvm.br"(%1986, %1989, %2003)[^bb49] : (i64, vector<8xi32>, vector<8xi32>) -> ()
^bb49(%2004: i64, %2005: vector<8xi32>, %2006: vector<8xi32>):  // 2 preds: ^bb48, ^bb49
  %2007 = "llvm.shl"(%45, %2006) <{overflowFlags = 2 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %2008 = "llvm.and"(%2007, %1999) : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %2009 = "llvm.icmp"(%2008, %44) <{predicate = 1 : i64}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi1>
  %2010 = "llvm.and"(%2007, %1991) : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %2011 = "llvm.icmp"(%2010, %44) <{predicate = 0 : i64}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi1>
  %2012 = "llvm.xor"(%2011, %43) : (vector<8xi1>, vector<8xi1>) -> vector<8xi1>
  %2013 = "llvm.select"(%2009, %2012, %42) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi1>, vector<8xi1>) -> vector<8xi1>
  %2014 = "llvm.and"(%2007, %1993) : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %2015 = "llvm.icmp"(%2014, %44) <{predicate = 0 : i64}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi1>
  %2016 = "llvm.xor"(%2015, %43) : (vector<8xi1>, vector<8xi1>) -> vector<8xi1>
  %2017 = "llvm.select"(%2013, %2016, %42) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi1>, vector<8xi1>) -> vector<8xi1>
  %2018 = "llvm.and"(%2007, %1995) : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %2019 = "llvm.icmp"(%2018, %44) <{predicate = 1 : i64}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi1>
  %2020 = "llvm.select"(%2017, %2019, %42) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi1>, vector<8xi1>) -> vector<8xi1>
  %2021 = "llvm.getelementptr"(%arg5, %2004) <{elem_type = !llvm.array<4 x i8>, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.intr.masked.store"(%41, %2021, %2020) <{alignment = 4 : i32}> : (vector<8xi32>, !llvm.ptr, vector<8xi1>) -> ()
  %2022 = "llvm.and"(%2007, %1997) : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %2023 = "llvm.icmp"(%2022, %44) <{predicate = 0 : i64}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi1>
  %2024 = "llvm.select"(%2013, %2015, %42) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi1>, vector<8xi1>) -> vector<8xi1>
  "llvm.intr.masked.store"(%40, %2021, %2024) <{alignment = 4 : i32}> : (vector<8xi32>, !llvm.ptr, vector<8xi1>) -> ()
  %2025 = "llvm.select"(%2009, %2011, %42) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi1>, vector<8xi1>) -> vector<8xi1>
  "llvm.intr.masked.store"(%41, %2021, %2025) <{alignment = 4 : i32}> : (vector<8xi32>, !llvm.ptr, vector<8xi1>) -> ()
  %2026 = "llvm.select"(%2024, %43, %2020) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi1>, vector<8xi1>) -> vector<8xi1>
  %2027 = "llvm.select"(%2026, %43, %2025) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi1>, vector<8xi1>) -> vector<8xi1>
  %2028 = "llvm.xor"(%2027, %43) : (vector<8xi1>, vector<8xi1>) -> vector<8xi1>
  %2029 = "llvm.select"(%2009, %2028, %42) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi1>, vector<8xi1>) -> vector<8xi1>
  %2030 = "llvm.select"(%2029, %2023, %42) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi1>, vector<8xi1>) -> vector<8xi1>
  %2031 = "llvm.select"(%2030, %2007, %44) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %2032 = "llvm.or"(%2005, %2031) : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %2033 = "llvm.add"(%2004, %69) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %2034 = "llvm.add"(%2006, %39) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %2035 = "llvm.icmp"(%2033, %1988) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%2035, %2033, %2032, %2034)[^bb50, ^bb49] <{loop_annotation = #llvm.loop_annotation<unroll = <runtimeDisable = true>, mustProgress = true, isVectorized = true>, operandSegmentSizes = array<i32: 1, 0, 3>}> : (i1, i64, vector<8xi32>, vector<8xi32>) -> ()
^bb50:  // pred: ^bb49
  %2036 = "llvm.intr.vector.reduce.or"(%2032) : (vector<8xi32>) -> i32
  %2037 = "llvm.icmp"(%arg6, %1988) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%2037, %2036, %1988, %2036)[^bb52, ^bb51] <{operandSegmentSizes = array<i32: 1, 1, 2>}> : (i1, i32, i64, i32) -> ()
^bb51(%2038: i64, %2039: i32):  // 3 preds: ^bb42, ^bb47, ^bb50
  "llvm.br"(%2038, %2039)[^bb53] : (i64, i32) -> ()
^bb52(%2040: i32):  // 3 preds: ^bb46, ^bb50, ^bb61
  %2041 = "llvm.icmp"(%2040, %61) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%2041)[^bb102, ^bb62] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb53(%2042: i64, %2043: i32):  // 2 preds: ^bb51, ^bb61
  %2044 = "llvm.trunc"(%2042) <{overflowFlags = 0 : i32}> : (i64) -> i32
  %2045 = "llvm.shl"(%52, %2044) <{overflowFlags = 2 : i32}> : (i32, i32) -> i32
  %2046 = "llvm.and"(%2045, %428) : (i32, i32) -> i32
  %2047 = "llvm.icmp"(%2046, %61) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%2047, %2043)[^bb61, ^bb54] <{operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i32) -> ()
^bb54:  // pred: ^bb53
  %2048 = "llvm.and"(%2045, %1278) : (i32, i32) -> i32
  %2049 = "llvm.icmp"(%2048, %61) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%2049)[^bb55, ^bb56] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb55:  // pred: ^bb54
  %2050 = "llvm.getelementptr"(%arg5, %2042) <{elem_type = !llvm.array<4 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%38, %2050) <{alignment = 4 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i32, !llvm.ptr) -> ()
  "llvm.br"(%2043)[^bb61] : (i32) -> ()
^bb56:  // pred: ^bb54
  %2051 = "llvm.and"(%2045, %1818) : (i32, i32) -> i32
  %2052 = "llvm.icmp"(%2051, %61) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%2052)[^bb57, ^bb58] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb57:  // pred: ^bb56
  %2053 = "llvm.getelementptr"(%arg5, %2042) <{elem_type = !llvm.array<4 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%55, %2053) <{alignment = 4 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i32, !llvm.ptr) -> ()
  "llvm.br"(%2043)[^bb61] : (i32) -> ()
^bb58:  // pred: ^bb56
  %2054 = "llvm.and"(%2045, %1906) : (i32, i32) -> i32
  %2055 = "llvm.icmp"(%2054, %61) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%2055)[^bb60, ^bb59] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb59:  // pred: ^bb58
  %2056 = "llvm.getelementptr"(%arg5, %2042) <{elem_type = !llvm.array<4 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%38, %2056) <{alignment = 4 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i32, !llvm.ptr) -> ()
  "llvm.br"(%2043)[^bb61] : (i32) -> ()
^bb60:  // pred: ^bb58
  %2057 = "llvm.and"(%2045, %1907) : (i32, i32) -> i32
  %2058 = "llvm.icmp"(%2057, %61) <{predicate = 0 : i64}> : (i32, i32) -> i1
  %2059 = "llvm.select"(%2058, %2045, %61) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i32, i32) -> i32
  %2060 = "llvm.or"(%2059, %2043) : (i32, i32) -> i32
  "llvm.br"(%2060)[^bb61] : (i32) -> ()
^bb61(%2061: i32):  // 5 preds: ^bb53, ^bb55, ^bb57, ^bb59, ^bb60
  %2062 = "llvm.add"(%2042, %88) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %2063 = "llvm.icmp"(%2062, %arg6) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%2063, %2061, %2062, %2061)[^bb52, ^bb53] <{loop_annotation = #llvm.loop_annotation<unroll = <runtimeDisable = true>, mustProgress = true, isVectorized = true>, operandSegmentSizes = array<i32: 1, 1, 2>}> : (i1, i32, i64, i32) -> ()
^bb62:  // pred: ^bb52
  "llvm.intr.lifetime.start"(%165) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%166) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%167) : (!llvm.ptr) -> ()
  %2064 = "llvm.getelementptr"(%167) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 192>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%66, %2064) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "fd_sha512_private_batch", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 64>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 128>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 192>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 192>]}> : (i64, !llvm.ptr) -> ()
  %2065 = "llvm.getelementptr"(%167) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %2066 = "llvm.getelementptr"(%167) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.br"(%66)[^bb66] : (i64) -> ()
^bb63:  // pred: ^bb74
  %2067 = "llvm.load"(%2064) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "fd_sha512_private_batch", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 64>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 128>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 192>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 192>]}> : (!llvm.ptr) -> i64
  %2068 = "llvm.icmp"(%2067, %66) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%2068)[^bb65, ^bb64] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb64:  // pred: ^bb63
  "llvm.call"(%2067, %167, %2065, %2066) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_sha512_private_batch_avx512, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (i64, !llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.br"()[^bb65] : () -> ()
^bb65:  // 2 preds: ^bb63, ^bb64
  "llvm.br"(%66)[^bb76] : (i64) -> ()
^bb66(%2069: i64):  // 2 preds: ^bb62, ^bb74
  %2070 = "llvm.trunc"(%2069) <{overflowFlags = 0 : i32}> : (i64) -> i32
  %2071 = "llvm.shl"(%52, %2070) <{overflowFlags = 2 : i32}> : (i32, i32) -> i32
  %2072 = "llvm.and"(%2071, %2040) : (i32, i32) -> i32
  %2073 = "llvm.icmp"(%2072, %61) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%2073)[^bb74, ^bb67] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb67:  // pred: ^bb66
  %2074 = "llvm.getelementptr"(%arg1, %2069) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %2075 = "llvm.load"(%2074) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %2076 = "llvm.icmp"(%2075, %37) <{predicate = 6 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%2076)[^bb68, ^bb73] <{branch_weights = array<i32: 2000, 1>, operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb68:  // pred: ^bb67
  %2077 = "llvm.getelementptr"(%165, %2069) <{elem_type = !llvm.array<1296 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %2078 = "llvm.getelementptr"(%arg2, %2069) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %2079 = "llvm.load"(%2078) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 omnipotent char", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 omnipotent char", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.memcpy"(%2077, %2079, %56) <{alias_scopes = [#llvm.alias_scope<id = distinct[0]<>, domain = <id = distinct[1]<>, description = "fd_memcpy">, description = "fd_memcpy: argument 0">, #llvm.alias_scope<id = distinct[2]<>, domain = <id = distinct[1]<>, description = "fd_memcpy">, description = "fd_memcpy: argument 1">], arg_attrs = [{llvm.align = 16 : i64, llvm.dereferenceable = 32 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 1 : i64, llvm.dereferenceable = 32 : i64, llvm.nonnull, llvm.noundef, llvm.readonly}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  %2080 = "llvm.getelementptr"(%2077) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %2081 = "llvm.getelementptr"(%arg3, %2069) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %2082 = "llvm.load"(%2081) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 omnipotent char", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 omnipotent char", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.memcpy"(%2080, %2082, %56) <{alias_scopes = [#llvm.alias_scope<id = distinct[3]<>, domain = <id = distinct[4]<>, description = "fd_memcpy">, description = "fd_memcpy: argument 0">, #llvm.alias_scope<id = distinct[5]<>, domain = <id = distinct[4]<>, description = "fd_memcpy">, description = "fd_memcpy: argument 1">], arg_attrs = [{llvm.align = 16 : i64, llvm.dereferenceable = 32 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 1 : i64, llvm.dereferenceable = 32 : i64, llvm.nonnull, llvm.noundef, llvm.readonly}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  %2083 = "llvm.icmp"(%2075, %66) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%2083)[^bb70, ^bb69] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb69:  // pred: ^bb68
  %2084 = "llvm.getelementptr"(%2077) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %2085 = "llvm.getelementptr"(%arg0, %2069) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %2086 = "llvm.load"(%2085) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 omnipotent char", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 omnipotent char", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.memcpy"(%2084, %2086, %2075) <{alias_scopes = [#llvm.alias_scope<id = distinct[6]<>, domain = <id = distinct[7]<>, description = "fd_memcpy">, description = "fd_memcpy: argument 0">, #llvm.alias_scope<id = distinct[8]<>, domain = <id = distinct[7]<>, description = "fd_memcpy">, description = "fd_memcpy: argument 1">], arg_attrs = [{llvm.align = 16 : i64, llvm.dereferenceable = 1 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 1 : i64, llvm.dereferenceable = 1 : i64, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.range = #llvm.constant_range<i64, 1, 0>}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.br"()[^bb70] : () -> ()
^bb70:  // 2 preds: ^bb68, ^bb69
  %2087 = "llvm.add"(%2075, %85) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %2088 = "llvm.getelementptr"(%166, %2069) <{elem_type = !llvm.array<64 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %2089 = "llvm.load"(%2064) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "fd_sha512_private_batch", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 64>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 128>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 192>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 192>]}> : (!llvm.ptr) -> i64
  %2090 = "llvm.getelementptr"(%167, %2089) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%2077, %2090) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr, !llvm.ptr) -> ()
  %2091 = "llvm.getelementptr"(%2065, %2089) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%2087, %2091) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i64, !llvm.ptr) -> ()
  %2092 = "llvm.getelementptr"(%2066, %2089) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%2088, %2092) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr, !llvm.ptr) -> ()
  %2093 = "llvm.add"(%2089, %88) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %2094 = "llvm.icmp"(%2093, %69) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%2094, %2093)[^bb71, ^bb72] <{branch_weights = array<i32: 1, 2000>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb71:  // pred: ^bb70
  "llvm.call"(%69, %167, %2065, %2066) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_sha512_private_batch_avx512, fastmathFlags = #llvm.fastmath<none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (i64, !llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.br"(%66)[^bb72] : (i64) -> ()
^bb72(%2095: i64):  // 2 preds: ^bb70, ^bb71
  "llvm.store"(%2095, %2064) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "fd_sha512_private_batch", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 64>, <#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 128>, <#llvm.tbaa_type_desc<id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 192>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 192>]}> : (i64, !llvm.ptr) -> ()
  "llvm.br"()[^bb74] : () -> ()
^bb73:  // pred: ^bb67
  %2096 = "llvm.getelementptr"(%arg4, %2069) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %2097 = "llvm.load"(%2096) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 _ZTS17fd_sha512_private", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 _ZTS17fd_sha512_private", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> !llvm.ptr
  %2098 = "llvm.call"(%2097) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}], callee = @fd_sha512_init, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (!llvm.ptr) -> !llvm.ptr
  %2099 = "llvm.getelementptr"(%arg2, %2069) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %2100 = "llvm.load"(%2099) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 omnipotent char", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 omnipotent char", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> !llvm.ptr
  %2101 = "llvm.call"(%2098, %2100, %56) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_sha512_append, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> !llvm.ptr
  %2102 = "llvm.getelementptr"(%arg3, %2069) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %2103 = "llvm.load"(%2102) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 omnipotent char", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 omnipotent char", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> !llvm.ptr
  %2104 = "llvm.call"(%2101, %2103, %56) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_sha512_append, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> !llvm.ptr
  %2105 = "llvm.getelementptr"(%arg0, %2069) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %2106 = "llvm.load"(%2105) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 omnipotent char", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 omnipotent char", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> !llvm.ptr
  %2107 = "llvm.load"(%2074) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "long", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i64
  %2108 = "llvm.call"(%2104, %2106, %2107) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_sha512_append, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> !llvm.ptr
  %2109 = "llvm.getelementptr"(%166, %2069) <{elem_type = !llvm.array<64 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %2110 = "llvm.call"(%2108, %2109) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_sha512_fini, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  "llvm.br"()[^bb74] : () -> ()
^bb74:  // 3 preds: ^bb66, ^bb72, ^bb73
  %2111 = "llvm.add"(%2069, %88) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %2112 = "llvm.icmp"(%2111, %arg6) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%2112, %2111)[^bb63, ^bb66] <{loop_annotation = #llvm.loop_annotation<mustProgress = true>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb75:  // pred: ^bb78
  %2113 = "llvm.load"(%163) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %2114 = "llvm.sub"(%36, %2113) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2115 = "llvm.getelementptr"(%163) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %2116 = "llvm.load"(%2115) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %2117 = "llvm.sub"(%106, %2116) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2118 = "llvm.getelementptr"(%163) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %2119 = "llvm.load"(%2118) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %2120 = "llvm.sub"(%106, %2119) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2121 = "llvm.getelementptr"(%163) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 192>}> : (!llvm.ptr) -> !llvm.ptr
  %2122 = "llvm.load"(%2121) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %2123 = "llvm.sub"(%106, %2122) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2124 = "llvm.getelementptr"(%163) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 256>}> : (!llvm.ptr) -> !llvm.ptr
  %2125 = "llvm.load"(%2124) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %2126 = "llvm.sub"(%106, %2125) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2127 = "llvm.lshr"(%2114, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2128 = "llvm.lshr"(%2117, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2129 = "llvm.lshr"(%2120, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2130 = "llvm.lshr"(%2123, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2131 = "llvm.lshr"(%2126, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2132 = "llvm.and"(%2114, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2133 = "llvm.call_intrinsic"(%2132, %2131, %103) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%2133, %163) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2134 = "llvm.and"(%2117, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2135 = "llvm.add"(%2134, %2127) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%2135, %2115) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2136 = "llvm.and"(%2120, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2137 = "llvm.add"(%2136, %2128) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%2137, %2118) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2138 = "llvm.and"(%2123, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2139 = "llvm.add"(%2138, %2129) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%2139, %2121) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2140 = "llvm.and"(%2126, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2141 = "llvm.add"(%2140, %2130) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%2141, %2124) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2142 = "llvm.getelementptr"(%163) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 960>}> : (!llvm.ptr) -> !llvm.ptr
  %2143 = "llvm.load"(%2142) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %2144 = "llvm.sub"(%36, %2143) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2145 = "llvm.getelementptr"(%163) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1024>}> : (!llvm.ptr) -> !llvm.ptr
  %2146 = "llvm.load"(%2145) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %2147 = "llvm.sub"(%106, %2146) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2148 = "llvm.getelementptr"(%163) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1088>}> : (!llvm.ptr) -> !llvm.ptr
  %2149 = "llvm.load"(%2148) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %2150 = "llvm.sub"(%106, %2149) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2151 = "llvm.getelementptr"(%163) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1152>}> : (!llvm.ptr) -> !llvm.ptr
  %2152 = "llvm.load"(%2151) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %2153 = "llvm.sub"(%106, %2152) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2154 = "llvm.getelementptr"(%163) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1216>}> : (!llvm.ptr) -> !llvm.ptr
  %2155 = "llvm.load"(%2154) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %2156 = "llvm.sub"(%106, %2155) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2157 = "llvm.lshr"(%2144, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2158 = "llvm.getelementptr"(%163) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1024>}> : (!llvm.ptr) -> !llvm.ptr
  %2159 = "llvm.lshr"(%2147, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2160 = "llvm.getelementptr"(%163) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1088>}> : (!llvm.ptr) -> !llvm.ptr
  %2161 = "llvm.lshr"(%2150, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2162 = "llvm.getelementptr"(%163) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1152>}> : (!llvm.ptr) -> !llvm.ptr
  %2163 = "llvm.lshr"(%2153, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2164 = "llvm.getelementptr"(%163) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1216>}> : (!llvm.ptr) -> !llvm.ptr
  %2165 = "llvm.lshr"(%2156, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2166 = "llvm.and"(%2144, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2167 = "llvm.call_intrinsic"(%2166, %2165, %103) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%2167, %2142) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2168 = "llvm.and"(%2147, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2169 = "llvm.add"(%2168, %2157) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%2169, %2158) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2170 = "llvm.and"(%2150, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2171 = "llvm.add"(%2170, %2159) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%2171, %2160) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2172 = "llvm.and"(%2153, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2173 = "llvm.add"(%2172, %2161) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%2173, %2162) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2174 = "llvm.and"(%2156, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2175 = "llvm.add"(%2174, %2163) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%2175, %2164) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%135) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%136) : (!llvm.ptr) -> ()
  "llvm.br"(%66)[^bb80] : (i64) -> ()
^bb76(%2176: i64):  // 2 preds: ^bb65, ^bb78
  %2177 = "llvm.trunc"(%2176) <{overflowFlags = 0 : i32}> : (i64) -> i32
  %2178 = "llvm.shl"(%52, %2177) <{overflowFlags = 2 : i32}> : (i32, i32) -> i32
  %2179 = "llvm.and"(%2178, %2040) : (i32, i32) -> i32
  %2180 = "llvm.icmp"(%2179, %61) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%2180)[^bb78, ^bb77] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb77:  // pred: ^bb76
  %2181 = "llvm.getelementptr"(%161, %2176) <{elem_type = !llvm.array<32 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %2182 = "llvm.getelementptr"(%166, %2176) <{elem_type = !llvm.array<64 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %2183 = "llvm.call"(%2181, %2182) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @fd_curve25519_scalar_reduce, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> !llvm.ptr
  %2184 = "llvm.getelementptr"(%162, %2176) <{elem_type = !llvm.array<32 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %2185 = "llvm.getelementptr"(%arg2, %2176) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %2186 = "llvm.load"(%2185) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 omnipotent char", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 omnipotent char", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> !llvm.ptr
  %2187 = "llvm.getelementptr"(%2186) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.memcpy"(%2184, %2187, %56) <{alias_scopes = [#llvm.alias_scope<id = distinct[9]<>, domain = <id = distinct[10]<>, description = "fd_memcpy">, description = "fd_memcpy: argument 0">, #llvm.alias_scope<id = distinct[11]<>, domain = <id = distinct[10]<>, description = "fd_memcpy">, description = "fd_memcpy: argument 1">], arg_attrs = [{llvm.align = 16 : i64, llvm.dereferenceable = 32 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 1 : i64, llvm.dereferenceable = 32 : i64, llvm.nonnull, llvm.noundef, llvm.readonly}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.br"()[^bb78] : () -> ()
^bb78:  // 2 preds: ^bb76, ^bb77
  %2188 = "llvm.add"(%2176, %88) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %2189 = "llvm.icmp"(%2188, %arg6) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%2189, %2188)[^bb75, ^bb76] <{loop_annotation = #llvm.loop_annotation<mustProgress = true>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb79:  // pred: ^bb82
  "llvm.intr.lifetime.start"(%138) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%139) : (!llvm.ptr) -> ()
  "llvm.call"(%139, %25) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {}], callee = @fd_ed25519_lane_bcast_fe, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, vector<8xi64>) -> ()
  "llvm.intr.lifetime.start"(%140) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%141) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%142) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%143) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%144) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%145) : (!llvm.ptr) -> ()
  "llvm.store"(%95, %138) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2190 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %2191 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 320>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.memset"(%2190, %53, %54) <{arg_attrs = [{llvm.align = 64 : i64, llvm.dereferenceable = 256 : i64, llvm.nonnull, llvm.noundef}, {}, {}], isVolatile = false}> : (!llvm.ptr, i8, i64) -> ()
  "llvm.store"(%95, %2191) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2192 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 384>}> : (!llvm.ptr) -> !llvm.ptr
  %2193 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 960>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.memset"(%2192, %53, %99) <{arg_attrs = [{llvm.align = 64 : i64, llvm.dereferenceable = 576 : i64, llvm.nonnull, llvm.noundef}, {}, {}], isVolatile = false}> : (!llvm.ptr, i8, i64) -> ()
  "llvm.store"(%108, %2193) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2194 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1024>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%109, %2194) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2195 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1088>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%109, %2195) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2196 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1152>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%109, %2196) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2197 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1216>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%109, %2197) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2198 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1280>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%95, %2198) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2199 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1344>}> : (!llvm.ptr) -> !llvm.ptr
  %2200 = "llvm.getelementptr"(%163) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 320>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.memset"(%2199, %53, %54) <{arg_attrs = [{llvm.align = 64 : i64, llvm.dereferenceable = 256 : i64, llvm.nonnull, llvm.noundef}, {}, {}], isVolatile = false}> : (!llvm.ptr, i8, i64) -> ()
  %2201 = "llvm.load"(%2200) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %2202 = "llvm.load"(%163) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %2203 = "llvm.add"(%2202, %2201) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2204 = "llvm.getelementptr"(%163) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 384>}> : (!llvm.ptr) -> !llvm.ptr
  %2205 = "llvm.load"(%2204) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %2206 = "llvm.load"(%2115) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %2207 = "llvm.add"(%2206, %2205) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2208 = "llvm.getelementptr"(%140) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %2209 = "llvm.getelementptr"(%163) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 448>}> : (!llvm.ptr) -> !llvm.ptr
  %2210 = "llvm.load"(%2209) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %2211 = "llvm.load"(%2118) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %2212 = "llvm.add"(%2211, %2210) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2213 = "llvm.getelementptr"(%140) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %2214 = "llvm.getelementptr"(%163) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 512>}> : (!llvm.ptr) -> !llvm.ptr
  %2215 = "llvm.load"(%2214) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %2216 = "llvm.load"(%2121) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %2217 = "llvm.add"(%2216, %2215) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2218 = "llvm.getelementptr"(%140) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 192>}> : (!llvm.ptr) -> !llvm.ptr
  %2219 = "llvm.getelementptr"(%163) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 576>}> : (!llvm.ptr) -> !llvm.ptr
  %2220 = "llvm.load"(%2219) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %2221 = "llvm.load"(%2124) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %2222 = "llvm.add"(%2221, %2220) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2223 = "llvm.getelementptr"(%140) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 256>}> : (!llvm.ptr) -> !llvm.ptr
  %2224 = "llvm.lshr"(%2203, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2225 = "llvm.lshr"(%2207, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2226 = "llvm.lshr"(%2212, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2227 = "llvm.lshr"(%2217, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2228 = "llvm.lshr"(%2222, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2229 = "llvm.and"(%2203, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2230 = "llvm.call_intrinsic"(%2229, %2228, %103) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%2230, %140) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2231 = "llvm.and"(%2207, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2232 = "llvm.add"(%2231, %2224) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%2232, %2208) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2233 = "llvm.and"(%2212, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2234 = "llvm.add"(%2233, %2225) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%2234, %2213) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2235 = "llvm.and"(%2217, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2236 = "llvm.add"(%2235, %2226) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%2236, %2218) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2237 = "llvm.and"(%2222, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2238 = "llvm.add"(%2237, %2227) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%2238, %2223) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2239 = "llvm.getelementptr"(%140) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 320>}> : (!llvm.ptr) -> !llvm.ptr
  %2240 = "llvm.add"(%2201, %36) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2241 = "llvm.sub"(%2240, %2202) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2242 = "llvm.add"(%2205, %106) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2243 = "llvm.sub"(%2242, %2206) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2244 = "llvm.getelementptr"(%140) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 384>}> : (!llvm.ptr) -> !llvm.ptr
  %2245 = "llvm.add"(%2210, %106) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2246 = "llvm.sub"(%2245, %2211) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2247 = "llvm.getelementptr"(%140) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 448>}> : (!llvm.ptr) -> !llvm.ptr
  %2248 = "llvm.add"(%2215, %106) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2249 = "llvm.sub"(%2248, %2216) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2250 = "llvm.getelementptr"(%140) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 512>}> : (!llvm.ptr) -> !llvm.ptr
  %2251 = "llvm.add"(%2220, %106) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2252 = "llvm.sub"(%2251, %2221) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2253 = "llvm.lshr"(%2241, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2254 = "llvm.lshr"(%2243, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2255 = "llvm.lshr"(%2246, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2256 = "llvm.lshr"(%2249, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2257 = "llvm.getelementptr"(%140) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 576>}> : (!llvm.ptr) -> !llvm.ptr
  %2258 = "llvm.lshr"(%2252, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2259 = "llvm.and"(%2241, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2260 = "llvm.call_intrinsic"(%2259, %2258, %103) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%2260, %2239) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2261 = "llvm.and"(%2243, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2262 = "llvm.add"(%2261, %2253) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%2262, %2244) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2263 = "llvm.and"(%2246, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2264 = "llvm.add"(%2263, %2254) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%2264, %2247) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2265 = "llvm.and"(%2249, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2266 = "llvm.add"(%2265, %2255) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%2266, %2250) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2267 = "llvm.and"(%2252, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2268 = "llvm.add"(%2267, %2256) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%2268, %2257) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2269 = "llvm.getelementptr"(%140) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1280>}> : (!llvm.ptr) -> !llvm.ptr
  %2270 = "llvm.getelementptr"(%163) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 640>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.memcpy"(%2269, %2270, %82) <{arg_attrs = [{llvm.align = 64 : i64, llvm.dereferenceable = 320 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 64 : i64, llvm.dereferenceable = 320 : i64, llvm.nonnull, llvm.noundef, llvm.readonly}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  %2271 = "llvm.getelementptr"(%140) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 640>}> : (!llvm.ptr) -> !llvm.ptr
  %2272 = "llvm.load"(%2142) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %2273 = "llvm.load"(%2158) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %2274 = "llvm.load"(%2160) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %2275 = "llvm.load"(%2162) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %2276 = "llvm.load"(%2164) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %2277 = "llvm.load"(%139) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %2278 = "llvm.getelementptr"(%139) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %2279 = "llvm.load"(%2278) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %2280 = "llvm.getelementptr"(%139) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %2281 = "llvm.load"(%2280) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %2282 = "llvm.getelementptr"(%139) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 192>}> : (!llvm.ptr) -> !llvm.ptr
  %2283 = "llvm.load"(%2282) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %2284 = "llvm.getelementptr"(%139) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 256>}> : (!llvm.ptr) -> !llvm.ptr
  %2285 = "llvm.load"(%2284) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %2286 = "llvm.call_intrinsic"(%94, %2272, %2277) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2287 = "llvm.shl"(%2286, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2288 = "llvm.call_intrinsic"(%2287, %2272, %2279) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2289 = "llvm.call_intrinsic"(%2288, %2273, %2277) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2290 = "llvm.call_intrinsic"(%94, %2272, %2279) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2291 = "llvm.call_intrinsic"(%2290, %2273, %2277) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2292 = "llvm.shl"(%2291, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2293 = "llvm.call_intrinsic"(%2292, %2272, %2281) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2294 = "llvm.call_intrinsic"(%2293, %2273, %2279) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2295 = "llvm.call_intrinsic"(%2294, %2274, %2277) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2296 = "llvm.call_intrinsic"(%94, %2272, %2281) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2297 = "llvm.call_intrinsic"(%2296, %2273, %2279) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2298 = "llvm.call_intrinsic"(%2297, %2274, %2277) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2299 = "llvm.shl"(%2298, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2300 = "llvm.call_intrinsic"(%2299, %2272, %2283) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2301 = "llvm.call_intrinsic"(%2300, %2273, %2281) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2302 = "llvm.call_intrinsic"(%2301, %2274, %2279) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2303 = "llvm.call_intrinsic"(%2302, %2275, %2277) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2304 = "llvm.call_intrinsic"(%94, %2272, %2283) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2305 = "llvm.call_intrinsic"(%2304, %2273, %2281) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2306 = "llvm.call_intrinsic"(%2305, %2274, %2279) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2307 = "llvm.call_intrinsic"(%2306, %2275, %2277) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2308 = "llvm.shl"(%2307, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2309 = "llvm.call_intrinsic"(%2308, %2272, %2285) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2310 = "llvm.call_intrinsic"(%2309, %2273, %2283) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2311 = "llvm.call_intrinsic"(%2310, %2274, %2281) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2312 = "llvm.call_intrinsic"(%2311, %2275, %2279) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2313 = "llvm.call_intrinsic"(%2312, %2276, %2277) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2314 = "llvm.call_intrinsic"(%94, %2272, %2285) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2315 = "llvm.call_intrinsic"(%2314, %2273, %2283) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2316 = "llvm.call_intrinsic"(%2315, %2274, %2281) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2317 = "llvm.call_intrinsic"(%2316, %2275, %2279) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2318 = "llvm.call_intrinsic"(%2317, %2276, %2277) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2319 = "llvm.shl"(%2318, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2320 = "llvm.call_intrinsic"(%2319, %2273, %2285) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2321 = "llvm.call_intrinsic"(%2320, %2274, %2283) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2322 = "llvm.call_intrinsic"(%2321, %2275, %2281) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2323 = "llvm.call_intrinsic"(%2322, %2276, %2279) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2324 = "llvm.call_intrinsic"(%94, %2273, %2285) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2325 = "llvm.call_intrinsic"(%2324, %2274, %2283) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2326 = "llvm.call_intrinsic"(%2325, %2275, %2281) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2327 = "llvm.call_intrinsic"(%2326, %2276, %2279) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2328 = "llvm.shl"(%2327, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2329 = "llvm.call_intrinsic"(%2328, %2274, %2285) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2330 = "llvm.call_intrinsic"(%2329, %2275, %2283) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2331 = "llvm.call_intrinsic"(%2330, %2276, %2281) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2332 = "llvm.call_intrinsic"(%94, %2274, %2285) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2333 = "llvm.call_intrinsic"(%2332, %2275, %2283) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2334 = "llvm.call_intrinsic"(%2333, %2276, %2281) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2335 = "llvm.shl"(%2334, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2336 = "llvm.call_intrinsic"(%2335, %2275, %2285) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2337 = "llvm.call_intrinsic"(%2336, %2276, %2283) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2338 = "llvm.call_intrinsic"(%94, %2275, %2285) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2339 = "llvm.call_intrinsic"(%2338, %2276, %2283) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2340 = "llvm.shl"(%2339, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2341 = "llvm.call_intrinsic"(%2340, %2276, %2285) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2342 = "llvm.call_intrinsic"(%94, %2276, %2285) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2343 = "llvm.mul"(%2323, %103) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2344 = "llvm.call_intrinsic"(%2343, %2272, %2277) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2345 = "llvm.mul"(%2331, %103) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2346 = "llvm.add"(%2345, %2289) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2347 = "llvm.getelementptr"(%140) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 704>}> : (!llvm.ptr) -> !llvm.ptr
  %2348 = "llvm.mul"(%2337, %103) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2349 = "llvm.add"(%2348, %2295) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2350 = "llvm.getelementptr"(%140) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 768>}> : (!llvm.ptr) -> !llvm.ptr
  %2351 = "llvm.mul"(%2341, %103) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2352 = "llvm.add"(%2351, %2303) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2353 = "llvm.getelementptr"(%140) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 832>}> : (!llvm.ptr) -> !llvm.ptr
  %2354 = "llvm.mul"(%2342, %102) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2355 = "llvm.add"(%2354, %2313) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2356 = "llvm.getelementptr"(%140) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 896>}> : (!llvm.ptr) -> !llvm.ptr
  %2357 = "llvm.lshr"(%2344, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2358 = "llvm.lshr"(%2346, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2359 = "llvm.lshr"(%2349, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2360 = "llvm.lshr"(%2352, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2361 = "llvm.lshr"(%2355, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2362 = "llvm.and"(%2344, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2363 = "llvm.call_intrinsic"(%2362, %2361, %103) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%2363, %2271) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2364 = "llvm.and"(%2346, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2365 = "llvm.add"(%2357, %2364) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%2365, %2347) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2366 = "llvm.and"(%2349, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2367 = "llvm.add"(%2366, %2358) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%2367, %2350) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2368 = "llvm.and"(%2352, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2369 = "llvm.add"(%2368, %2359) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%2369, %2353) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2370 = "llvm.and"(%2355, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2371 = "llvm.add"(%2370, %2360) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%2371, %2356) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2372 = "llvm.getelementptr"(%140) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 960>}> : (!llvm.ptr) -> !llvm.ptr
  %2373 = "llvm.sub"(%108, %2363) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%2373, %2372) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2374 = "llvm.sub"(%109, %2365) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2375 = "llvm.getelementptr"(%140) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1024>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2374, %2375) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2376 = "llvm.sub"(%109, %2367) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2377 = "llvm.getelementptr"(%140) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1088>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2376, %2377) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2378 = "llvm.sub"(%109, %2369) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2379 = "llvm.getelementptr"(%140) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1152>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2378, %2379) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2380 = "llvm.sub"(%109, %2371) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2381 = "llvm.getelementptr"(%140) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1216>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2380, %2381) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2382 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1600>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.memcpy"(%2382, %140, %82) <{arg_attrs = [{llvm.align = 64 : i64, llvm.dereferenceable = 320 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 64 : i64, llvm.dereferenceable = 320 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  %2383 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1920>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.memcpy"(%2383, %2239, %82) <{arg_attrs = [{llvm.align = 64 : i64, llvm.dereferenceable = 320 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 64 : i64, llvm.dereferenceable = 320 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  %2384 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 2240>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.memcpy"(%2384, %2271, %82) <{arg_attrs = [{llvm.align = 64 : i64, llvm.dereferenceable = 320 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 64 : i64, llvm.dereferenceable = 320 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  %2385 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 2560>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.memcpy"(%2385, %2372, %82) <{arg_attrs = [{llvm.align = 64 : i64, llvm.dereferenceable = 320 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 64 : i64, llvm.dereferenceable = 320 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  %2386 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 2880>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.memcpy"(%2386, %2270, %82) <{arg_attrs = [{llvm.align = 64 : i64, llvm.dereferenceable = 320 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 64 : i64, llvm.dereferenceable = 320 : i64, llvm.nonnull, llvm.noundef, llvm.readonly}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.call"(%141, %163, %52) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.noundef}], callee = @fd_ed25519_lane_point_dbl, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i32) -> ()
  %2387 = "llvm.getelementptr"(%141) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 320>}> : (!llvm.ptr) -> !llvm.ptr
  %2388 = "llvm.load"(%2387) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %2389 = "llvm.load"(%141) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %2390 = "llvm.add"(%2389, %2388) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2391 = "llvm.getelementptr"(%141) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 384>}> : (!llvm.ptr) -> !llvm.ptr
  %2392 = "llvm.load"(%2391) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %2393 = "llvm.getelementptr"(%141) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %2394 = "llvm.load"(%2393) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %2395 = "llvm.add"(%2394, %2392) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2396 = "llvm.getelementptr"(%141) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 448>}> : (!llvm.ptr) -> !llvm.ptr
  %2397 = "llvm.load"(%2396) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %2398 = "llvm.getelementptr"(%141) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %2399 = "llvm.load"(%2398) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %2400 = "llvm.add"(%2399, %2397) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2401 = "llvm.getelementptr"(%141) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 512>}> : (!llvm.ptr) -> !llvm.ptr
  %2402 = "llvm.load"(%2401) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %2403 = "llvm.getelementptr"(%141) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 192>}> : (!llvm.ptr) -> !llvm.ptr
  %2404 = "llvm.load"(%2403) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %2405 = "llvm.add"(%2404, %2402) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2406 = "llvm.getelementptr"(%141) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 576>}> : (!llvm.ptr) -> !llvm.ptr
  %2407 = "llvm.load"(%2406) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %2408 = "llvm.getelementptr"(%141) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 256>}> : (!llvm.ptr) -> !llvm.ptr
  %2409 = "llvm.load"(%2408) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %2410 = "llvm.add"(%2409, %2407) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2411 = "llvm.lshr"(%2390, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2412 = "llvm.lshr"(%2395, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2413 = "llvm.lshr"(%2400, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2414 = "llvm.lshr"(%2405, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2415 = "llvm.lshr"(%2410, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2416 = "llvm.and"(%2390, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2417 = "llvm.call_intrinsic"(%2416, %2415, %103) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2418 = "llvm.and"(%2395, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2419 = "llvm.add"(%2418, %2411) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2420 = "llvm.and"(%2400, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2421 = "llvm.add"(%2420, %2412) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2422 = "llvm.and"(%2405, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2423 = "llvm.add"(%2422, %2413) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2424 = "llvm.and"(%2410, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2425 = "llvm.add"(%2424, %2414) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2426 = "llvm.add"(%2388, %36) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2427 = "llvm.sub"(%2426, %2389) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2428 = "llvm.add"(%2392, %106) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2429 = "llvm.sub"(%2428, %2394) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2430 = "llvm.add"(%2397, %106) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2431 = "llvm.sub"(%2430, %2399) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2432 = "llvm.add"(%2402, %106) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2433 = "llvm.sub"(%2432, %2404) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2434 = "llvm.add"(%2407, %106) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2435 = "llvm.sub"(%2434, %2409) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2436 = "llvm.lshr"(%2427, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2437 = "llvm.lshr"(%2429, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2438 = "llvm.lshr"(%2431, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2439 = "llvm.lshr"(%2433, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2440 = "llvm.lshr"(%2435, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2441 = "llvm.and"(%2427, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2442 = "llvm.call_intrinsic"(%2441, %2440, %103) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2443 = "llvm.and"(%2429, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2444 = "llvm.add"(%2443, %2436) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2445 = "llvm.and"(%2431, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2446 = "llvm.add"(%2445, %2437) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2447 = "llvm.and"(%2433, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2448 = "llvm.add"(%2447, %2438) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2449 = "llvm.and"(%2435, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2450 = "llvm.add"(%2449, %2439) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2451 = "llvm.getelementptr"(%141) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 640>}> : (!llvm.ptr) -> !llvm.ptr
  %2452 = "llvm.load"(%2451) <{alignment = 64 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi64>
  %2453 = "llvm.getelementptr"(%141) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 704>}> : (!llvm.ptr) -> !llvm.ptr
  %2454 = "llvm.load"(%2453) <{alignment = 64 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi64>
  %2455 = "llvm.getelementptr"(%141) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 768>}> : (!llvm.ptr) -> !llvm.ptr
  %2456 = "llvm.load"(%2455) <{alignment = 64 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi64>
  %2457 = "llvm.getelementptr"(%141) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 832>}> : (!llvm.ptr) -> !llvm.ptr
  %2458 = "llvm.load"(%2457) <{alignment = 64 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi64>
  %2459 = "llvm.getelementptr"(%141) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 896>}> : (!llvm.ptr) -> !llvm.ptr
  %2460 = "llvm.load"(%2459) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %2461 = "llvm.getelementptr"(%141) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 960>}> : (!llvm.ptr) -> !llvm.ptr
  %2462 = "llvm.load"(%2461) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %2463 = "llvm.getelementptr"(%141) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1024>}> : (!llvm.ptr) -> !llvm.ptr
  %2464 = "llvm.load"(%2463) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %2465 = "llvm.getelementptr"(%141) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1088>}> : (!llvm.ptr) -> !llvm.ptr
  %2466 = "llvm.load"(%2465) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %2467 = "llvm.getelementptr"(%141) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1152>}> : (!llvm.ptr) -> !llvm.ptr
  %2468 = "llvm.load"(%2467) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %2469 = "llvm.getelementptr"(%141) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1216>}> : (!llvm.ptr) -> !llvm.ptr
  %2470 = "llvm.load"(%2469) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %2471 = "llvm.call_intrinsic"(%94, %2462, %2277) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2472 = "llvm.shl"(%2471, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2473 = "llvm.call_intrinsic"(%2472, %2462, %2279) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2474 = "llvm.call_intrinsic"(%2473, %2464, %2277) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2475 = "llvm.call_intrinsic"(%94, %2462, %2279) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2476 = "llvm.call_intrinsic"(%2475, %2464, %2277) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2477 = "llvm.shl"(%2476, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2478 = "llvm.call_intrinsic"(%2477, %2462, %2281) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2479 = "llvm.call_intrinsic"(%2478, %2464, %2279) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2480 = "llvm.call_intrinsic"(%2479, %2466, %2277) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2481 = "llvm.call_intrinsic"(%94, %2462, %2281) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2482 = "llvm.call_intrinsic"(%2481, %2464, %2279) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2483 = "llvm.call_intrinsic"(%2482, %2466, %2277) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2484 = "llvm.shl"(%2483, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2485 = "llvm.call_intrinsic"(%2484, %2462, %2283) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2486 = "llvm.call_intrinsic"(%2485, %2464, %2281) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2487 = "llvm.call_intrinsic"(%2486, %2466, %2279) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2488 = "llvm.call_intrinsic"(%2487, %2468, %2277) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2489 = "llvm.call_intrinsic"(%94, %2462, %2283) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2490 = "llvm.call_intrinsic"(%2489, %2464, %2281) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2491 = "llvm.call_intrinsic"(%2490, %2466, %2279) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2492 = "llvm.call_intrinsic"(%2491, %2468, %2277) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2493 = "llvm.shl"(%2492, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2494 = "llvm.call_intrinsic"(%2493, %2462, %2285) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2495 = "llvm.call_intrinsic"(%2494, %2464, %2283) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2496 = "llvm.call_intrinsic"(%2495, %2466, %2281) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2497 = "llvm.call_intrinsic"(%2496, %2468, %2279) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2498 = "llvm.call_intrinsic"(%2497, %2470, %2277) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2499 = "llvm.call_intrinsic"(%94, %2462, %2285) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2500 = "llvm.call_intrinsic"(%2499, %2464, %2283) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2501 = "llvm.call_intrinsic"(%2500, %2466, %2281) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2502 = "llvm.call_intrinsic"(%2501, %2468, %2279) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2503 = "llvm.call_intrinsic"(%2502, %2470, %2277) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2504 = "llvm.shl"(%2503, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2505 = "llvm.call_intrinsic"(%2504, %2464, %2285) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2506 = "llvm.call_intrinsic"(%2505, %2466, %2283) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2507 = "llvm.call_intrinsic"(%2506, %2468, %2281) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2508 = "llvm.call_intrinsic"(%2507, %2470, %2279) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2509 = "llvm.call_intrinsic"(%94, %2464, %2285) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2510 = "llvm.call_intrinsic"(%2509, %2466, %2283) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2511 = "llvm.call_intrinsic"(%2510, %2468, %2281) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2512 = "llvm.call_intrinsic"(%2511, %2470, %2279) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2513 = "llvm.shl"(%2512, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2514 = "llvm.call_intrinsic"(%2513, %2466, %2285) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2515 = "llvm.call_intrinsic"(%2514, %2468, %2283) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2516 = "llvm.call_intrinsic"(%2515, %2470, %2281) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2517 = "llvm.call_intrinsic"(%94, %2466, %2285) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2518 = "llvm.call_intrinsic"(%2517, %2468, %2283) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2519 = "llvm.call_intrinsic"(%2518, %2470, %2281) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2520 = "llvm.shl"(%2519, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2521 = "llvm.call_intrinsic"(%2520, %2468, %2285) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2522 = "llvm.call_intrinsic"(%2521, %2470, %2283) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2523 = "llvm.call_intrinsic"(%94, %2468, %2285) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2524 = "llvm.call_intrinsic"(%2523, %2470, %2283) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2525 = "llvm.shl"(%2524, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2526 = "llvm.call_intrinsic"(%2525, %2470, %2285) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2527 = "llvm.call_intrinsic"(%94, %2470, %2285) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2528 = "llvm.mul"(%2508, %103) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2529 = "llvm.call_intrinsic"(%2528, %2462, %2277) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2530 = "llvm.mul"(%2516, %103) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2531 = "llvm.add"(%2530, %2474) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2532 = "llvm.mul"(%2522, %103) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2533 = "llvm.add"(%2532, %2480) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2534 = "llvm.mul"(%2526, %103) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2535 = "llvm.add"(%2534, %2488) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2536 = "llvm.mul"(%2527, %102) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2537 = "llvm.add"(%2536, %2498) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2538 = "llvm.lshr"(%2529, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2539 = "llvm.lshr"(%2531, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2540 = "llvm.lshr"(%2533, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2541 = "llvm.lshr"(%2535, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2542 = "llvm.lshr"(%2537, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2543 = "llvm.and"(%2529, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2544 = "llvm.call_intrinsic"(%2543, %2542, %103) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2545 = "llvm.and"(%2531, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2546 = "llvm.add"(%2538, %2545) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2547 = "llvm.and"(%2533, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2548 = "llvm.add"(%2547, %2539) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2549 = "llvm.and"(%2535, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2550 = "llvm.add"(%2549, %2540) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2551 = "llvm.and"(%2537, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2552 = "llvm.add"(%2551, %2541) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2553 = "llvm.sub"(%108, %2544) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2554 = "llvm.sub"(%109, %2546) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2555 = "llvm.sub"(%109, %2548) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2556 = "llvm.sub"(%109, %2550) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2557 = "llvm.sub"(%109, %2552) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2558 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 3200>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2417, %2558) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2559 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 3264>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2419, %2559) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2560 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 3328>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2421, %2560) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2561 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 3392>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2423, %2561) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2562 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 3456>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2425, %2562) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2563 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 3520>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2442, %2563) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2564 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 3584>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2444, %2564) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2565 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 3648>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2446, %2565) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2566 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 3712>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2448, %2566) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2567 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 3776>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2450, %2567) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2568 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 3840>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2544, %2568) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2569 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 3904>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2546, %2569) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2570 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 3968>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2548, %2570) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2571 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 4032>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2550, %2571) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2572 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 4096>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2552, %2572) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2573 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 4160>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2553, %2573) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2574 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 4224>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2554, %2574) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2575 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 4288>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2555, %2575) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2576 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 4352>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2556, %2576) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2577 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 4416>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2557, %2577) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2578 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 4480>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2452, %2578) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2579 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 4544>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2454, %2579) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2580 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 4608>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2456, %2580) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2581 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 4672>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2458, %2581) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2582 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 4736>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2460, %2582) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.call"(%142, %141, %140) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_lane_point_add, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  %2583 = "llvm.getelementptr"(%142) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 320>}> : (!llvm.ptr) -> !llvm.ptr
  %2584 = "llvm.load"(%2583) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %2585 = "llvm.load"(%142) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %2586 = "llvm.add"(%2585, %2584) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2587 = "llvm.getelementptr"(%142) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 384>}> : (!llvm.ptr) -> !llvm.ptr
  %2588 = "llvm.load"(%2587) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %2589 = "llvm.getelementptr"(%142) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %2590 = "llvm.load"(%2589) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %2591 = "llvm.add"(%2590, %2588) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2592 = "llvm.getelementptr"(%142) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 448>}> : (!llvm.ptr) -> !llvm.ptr
  %2593 = "llvm.load"(%2592) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %2594 = "llvm.getelementptr"(%142) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %2595 = "llvm.load"(%2594) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %2596 = "llvm.add"(%2595, %2593) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2597 = "llvm.getelementptr"(%142) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 512>}> : (!llvm.ptr) -> !llvm.ptr
  %2598 = "llvm.load"(%2597) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %2599 = "llvm.getelementptr"(%142) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 192>}> : (!llvm.ptr) -> !llvm.ptr
  %2600 = "llvm.load"(%2599) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %2601 = "llvm.add"(%2600, %2598) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2602 = "llvm.getelementptr"(%142) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 576>}> : (!llvm.ptr) -> !llvm.ptr
  %2603 = "llvm.load"(%2602) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %2604 = "llvm.getelementptr"(%142) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 256>}> : (!llvm.ptr) -> !llvm.ptr
  %2605 = "llvm.load"(%2604) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %2606 = "llvm.add"(%2605, %2603) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2607 = "llvm.lshr"(%2586, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2608 = "llvm.lshr"(%2591, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2609 = "llvm.lshr"(%2596, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2610 = "llvm.lshr"(%2601, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2611 = "llvm.lshr"(%2606, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2612 = "llvm.and"(%2586, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2613 = "llvm.call_intrinsic"(%2612, %2611, %103) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2614 = "llvm.and"(%2591, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2615 = "llvm.add"(%2614, %2607) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2616 = "llvm.and"(%2596, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2617 = "llvm.add"(%2616, %2608) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2618 = "llvm.and"(%2601, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2619 = "llvm.add"(%2618, %2609) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2620 = "llvm.and"(%2606, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2621 = "llvm.add"(%2620, %2610) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2622 = "llvm.add"(%2584, %36) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2623 = "llvm.sub"(%2622, %2585) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2624 = "llvm.add"(%2588, %106) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2625 = "llvm.sub"(%2624, %2590) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2626 = "llvm.add"(%2593, %106) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2627 = "llvm.sub"(%2626, %2595) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2628 = "llvm.add"(%2598, %106) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2629 = "llvm.sub"(%2628, %2600) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2630 = "llvm.add"(%2603, %106) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2631 = "llvm.sub"(%2630, %2605) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2632 = "llvm.lshr"(%2623, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2633 = "llvm.lshr"(%2625, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2634 = "llvm.lshr"(%2627, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2635 = "llvm.lshr"(%2629, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2636 = "llvm.lshr"(%2631, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2637 = "llvm.and"(%2623, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2638 = "llvm.call_intrinsic"(%2637, %2636, %103) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2639 = "llvm.and"(%2625, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2640 = "llvm.add"(%2639, %2632) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2641 = "llvm.and"(%2627, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2642 = "llvm.add"(%2641, %2633) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2643 = "llvm.and"(%2629, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2644 = "llvm.add"(%2643, %2634) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2645 = "llvm.and"(%2631, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2646 = "llvm.add"(%2645, %2635) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2647 = "llvm.getelementptr"(%142) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 640>}> : (!llvm.ptr) -> !llvm.ptr
  %2648 = "llvm.load"(%2647) <{alignment = 64 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi64>
  %2649 = "llvm.getelementptr"(%142) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 704>}> : (!llvm.ptr) -> !llvm.ptr
  %2650 = "llvm.load"(%2649) <{alignment = 64 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi64>
  %2651 = "llvm.getelementptr"(%142) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 768>}> : (!llvm.ptr) -> !llvm.ptr
  %2652 = "llvm.load"(%2651) <{alignment = 64 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi64>
  %2653 = "llvm.getelementptr"(%142) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 832>}> : (!llvm.ptr) -> !llvm.ptr
  %2654 = "llvm.load"(%2653) <{alignment = 64 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi64>
  %2655 = "llvm.getelementptr"(%142) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 896>}> : (!llvm.ptr) -> !llvm.ptr
  %2656 = "llvm.load"(%2655) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %2657 = "llvm.getelementptr"(%142) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 960>}> : (!llvm.ptr) -> !llvm.ptr
  %2658 = "llvm.load"(%2657) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %2659 = "llvm.getelementptr"(%142) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1024>}> : (!llvm.ptr) -> !llvm.ptr
  %2660 = "llvm.load"(%2659) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %2661 = "llvm.getelementptr"(%142) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1088>}> : (!llvm.ptr) -> !llvm.ptr
  %2662 = "llvm.load"(%2661) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %2663 = "llvm.getelementptr"(%142) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1152>}> : (!llvm.ptr) -> !llvm.ptr
  %2664 = "llvm.load"(%2663) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %2665 = "llvm.getelementptr"(%142) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1216>}> : (!llvm.ptr) -> !llvm.ptr
  %2666 = "llvm.load"(%2665) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %2667 = "llvm.call_intrinsic"(%94, %2658, %2277) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2668 = "llvm.shl"(%2667, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2669 = "llvm.call_intrinsic"(%2668, %2658, %2279) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2670 = "llvm.call_intrinsic"(%2669, %2660, %2277) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2671 = "llvm.call_intrinsic"(%94, %2658, %2279) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2672 = "llvm.call_intrinsic"(%2671, %2660, %2277) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2673 = "llvm.shl"(%2672, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2674 = "llvm.call_intrinsic"(%2673, %2658, %2281) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2675 = "llvm.call_intrinsic"(%2674, %2660, %2279) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2676 = "llvm.call_intrinsic"(%2675, %2662, %2277) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2677 = "llvm.call_intrinsic"(%94, %2658, %2281) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2678 = "llvm.call_intrinsic"(%2677, %2660, %2279) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2679 = "llvm.call_intrinsic"(%2678, %2662, %2277) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2680 = "llvm.shl"(%2679, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2681 = "llvm.call_intrinsic"(%2680, %2658, %2283) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2682 = "llvm.call_intrinsic"(%2681, %2660, %2281) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2683 = "llvm.call_intrinsic"(%2682, %2662, %2279) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2684 = "llvm.call_intrinsic"(%2683, %2664, %2277) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2685 = "llvm.call_intrinsic"(%94, %2658, %2283) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2686 = "llvm.call_intrinsic"(%2685, %2660, %2281) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2687 = "llvm.call_intrinsic"(%2686, %2662, %2279) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2688 = "llvm.call_intrinsic"(%2687, %2664, %2277) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2689 = "llvm.shl"(%2688, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2690 = "llvm.call_intrinsic"(%2689, %2658, %2285) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2691 = "llvm.call_intrinsic"(%2690, %2660, %2283) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2692 = "llvm.call_intrinsic"(%2691, %2662, %2281) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2693 = "llvm.call_intrinsic"(%2692, %2664, %2279) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2694 = "llvm.call_intrinsic"(%2693, %2666, %2277) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2695 = "llvm.call_intrinsic"(%94, %2658, %2285) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2696 = "llvm.call_intrinsic"(%2695, %2660, %2283) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2697 = "llvm.call_intrinsic"(%2696, %2662, %2281) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2698 = "llvm.call_intrinsic"(%2697, %2664, %2279) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2699 = "llvm.call_intrinsic"(%2698, %2666, %2277) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2700 = "llvm.shl"(%2699, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2701 = "llvm.call_intrinsic"(%2700, %2660, %2285) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2702 = "llvm.call_intrinsic"(%2701, %2662, %2283) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2703 = "llvm.call_intrinsic"(%2702, %2664, %2281) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2704 = "llvm.call_intrinsic"(%2703, %2666, %2279) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2705 = "llvm.call_intrinsic"(%94, %2660, %2285) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2706 = "llvm.call_intrinsic"(%2705, %2662, %2283) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2707 = "llvm.call_intrinsic"(%2706, %2664, %2281) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2708 = "llvm.call_intrinsic"(%2707, %2666, %2279) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2709 = "llvm.shl"(%2708, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2710 = "llvm.call_intrinsic"(%2709, %2662, %2285) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2711 = "llvm.call_intrinsic"(%2710, %2664, %2283) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2712 = "llvm.call_intrinsic"(%2711, %2666, %2281) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2713 = "llvm.call_intrinsic"(%94, %2662, %2285) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2714 = "llvm.call_intrinsic"(%2713, %2664, %2283) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2715 = "llvm.call_intrinsic"(%2714, %2666, %2281) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2716 = "llvm.shl"(%2715, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2717 = "llvm.call_intrinsic"(%2716, %2664, %2285) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2718 = "llvm.call_intrinsic"(%2717, %2666, %2283) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2719 = "llvm.call_intrinsic"(%94, %2664, %2285) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2720 = "llvm.call_intrinsic"(%2719, %2666, %2283) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2721 = "llvm.shl"(%2720, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2722 = "llvm.call_intrinsic"(%2721, %2666, %2285) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2723 = "llvm.call_intrinsic"(%94, %2666, %2285) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2724 = "llvm.mul"(%2704, %103) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2725 = "llvm.call_intrinsic"(%2724, %2658, %2277) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2726 = "llvm.mul"(%2712, %103) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2727 = "llvm.add"(%2726, %2670) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2728 = "llvm.mul"(%2718, %103) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2729 = "llvm.add"(%2728, %2676) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2730 = "llvm.mul"(%2722, %103) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2731 = "llvm.add"(%2730, %2684) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2732 = "llvm.mul"(%2723, %102) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2733 = "llvm.add"(%2732, %2694) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2734 = "llvm.lshr"(%2725, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2735 = "llvm.lshr"(%2727, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2736 = "llvm.lshr"(%2729, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2737 = "llvm.lshr"(%2731, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2738 = "llvm.lshr"(%2733, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2739 = "llvm.and"(%2725, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2740 = "llvm.call_intrinsic"(%2739, %2738, %103) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2741 = "llvm.and"(%2727, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2742 = "llvm.add"(%2734, %2741) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2743 = "llvm.and"(%2729, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2744 = "llvm.add"(%2743, %2735) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2745 = "llvm.and"(%2731, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2746 = "llvm.add"(%2745, %2736) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2747 = "llvm.and"(%2733, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2748 = "llvm.add"(%2747, %2737) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2749 = "llvm.sub"(%108, %2740) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2750 = "llvm.sub"(%109, %2742) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2751 = "llvm.sub"(%109, %2744) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2752 = "llvm.sub"(%109, %2746) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2753 = "llvm.sub"(%109, %2748) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2754 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 4800>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2613, %2754) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2755 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 4864>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2615, %2755) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2756 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 4928>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2617, %2756) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2757 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 4992>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2619, %2757) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2758 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 5056>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2621, %2758) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2759 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 5120>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2638, %2759) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2760 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 5184>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2640, %2760) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2761 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 5248>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2642, %2761) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2762 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 5312>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2644, %2762) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2763 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 5376>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2646, %2763) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2764 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 5440>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2740, %2764) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2765 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 5504>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2742, %2765) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2766 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 5568>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2744, %2766) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2767 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 5632>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2746, %2767) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2768 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 5696>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2748, %2768) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2769 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 5760>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2749, %2769) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2770 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 5824>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2750, %2770) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2771 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 5888>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2751, %2771) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2772 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 5952>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2752, %2772) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2773 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 6016>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2753, %2773) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2774 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 6080>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2648, %2774) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2775 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 6144>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2650, %2775) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2776 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 6208>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2652, %2776) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2777 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 6272>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2654, %2777) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2778 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 6336>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2656, %2778) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.call"(%143, %141, %52) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_lane_point_dbl, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i32) -> ()
  %2779 = "llvm.getelementptr"(%143) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 320>}> : (!llvm.ptr) -> !llvm.ptr
  %2780 = "llvm.load"(%2779) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %2781 = "llvm.load"(%143) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %2782 = "llvm.add"(%2781, %2780) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2783 = "llvm.getelementptr"(%143) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 384>}> : (!llvm.ptr) -> !llvm.ptr
  %2784 = "llvm.load"(%2783) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %2785 = "llvm.getelementptr"(%143) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %2786 = "llvm.load"(%2785) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %2787 = "llvm.add"(%2786, %2784) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2788 = "llvm.getelementptr"(%143) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 448>}> : (!llvm.ptr) -> !llvm.ptr
  %2789 = "llvm.load"(%2788) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %2790 = "llvm.getelementptr"(%143) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %2791 = "llvm.load"(%2790) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %2792 = "llvm.add"(%2791, %2789) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2793 = "llvm.getelementptr"(%143) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 512>}> : (!llvm.ptr) -> !llvm.ptr
  %2794 = "llvm.load"(%2793) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %2795 = "llvm.getelementptr"(%143) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 192>}> : (!llvm.ptr) -> !llvm.ptr
  %2796 = "llvm.load"(%2795) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %2797 = "llvm.add"(%2796, %2794) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2798 = "llvm.getelementptr"(%143) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 576>}> : (!llvm.ptr) -> !llvm.ptr
  %2799 = "llvm.load"(%2798) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %2800 = "llvm.getelementptr"(%143) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 256>}> : (!llvm.ptr) -> !llvm.ptr
  %2801 = "llvm.load"(%2800) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %2802 = "llvm.add"(%2801, %2799) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2803 = "llvm.lshr"(%2782, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2804 = "llvm.lshr"(%2787, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2805 = "llvm.lshr"(%2792, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2806 = "llvm.lshr"(%2797, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2807 = "llvm.lshr"(%2802, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2808 = "llvm.and"(%2782, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2809 = "llvm.call_intrinsic"(%2808, %2807, %103) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2810 = "llvm.and"(%2787, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2811 = "llvm.add"(%2810, %2803) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2812 = "llvm.and"(%2792, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2813 = "llvm.add"(%2812, %2804) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2814 = "llvm.and"(%2797, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2815 = "llvm.add"(%2814, %2805) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2816 = "llvm.and"(%2802, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2817 = "llvm.add"(%2816, %2806) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2818 = "llvm.add"(%2780, %36) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2819 = "llvm.sub"(%2818, %2781) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2820 = "llvm.add"(%2784, %106) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2821 = "llvm.sub"(%2820, %2786) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2822 = "llvm.add"(%2789, %106) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2823 = "llvm.sub"(%2822, %2791) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2824 = "llvm.add"(%2794, %106) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2825 = "llvm.sub"(%2824, %2796) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2826 = "llvm.add"(%2799, %106) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2827 = "llvm.sub"(%2826, %2801) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2828 = "llvm.lshr"(%2819, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2829 = "llvm.lshr"(%2821, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2830 = "llvm.lshr"(%2823, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2831 = "llvm.lshr"(%2825, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2832 = "llvm.lshr"(%2827, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2833 = "llvm.and"(%2819, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2834 = "llvm.call_intrinsic"(%2833, %2832, %103) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2835 = "llvm.and"(%2821, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2836 = "llvm.add"(%2835, %2828) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2837 = "llvm.and"(%2823, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2838 = "llvm.add"(%2837, %2829) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2839 = "llvm.and"(%2825, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2840 = "llvm.add"(%2839, %2830) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2841 = "llvm.and"(%2827, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2842 = "llvm.add"(%2841, %2831) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2843 = "llvm.getelementptr"(%143) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 640>}> : (!llvm.ptr) -> !llvm.ptr
  %2844 = "llvm.load"(%2843) <{alignment = 64 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi64>
  %2845 = "llvm.getelementptr"(%143) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 704>}> : (!llvm.ptr) -> !llvm.ptr
  %2846 = "llvm.load"(%2845) <{alignment = 64 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi64>
  %2847 = "llvm.getelementptr"(%143) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 768>}> : (!llvm.ptr) -> !llvm.ptr
  %2848 = "llvm.load"(%2847) <{alignment = 64 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi64>
  %2849 = "llvm.getelementptr"(%143) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 832>}> : (!llvm.ptr) -> !llvm.ptr
  %2850 = "llvm.load"(%2849) <{alignment = 64 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi64>
  %2851 = "llvm.getelementptr"(%143) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 896>}> : (!llvm.ptr) -> !llvm.ptr
  %2852 = "llvm.load"(%2851) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %2853 = "llvm.getelementptr"(%143) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 960>}> : (!llvm.ptr) -> !llvm.ptr
  %2854 = "llvm.load"(%2853) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %2855 = "llvm.getelementptr"(%143) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1024>}> : (!llvm.ptr) -> !llvm.ptr
  %2856 = "llvm.load"(%2855) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %2857 = "llvm.getelementptr"(%143) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1088>}> : (!llvm.ptr) -> !llvm.ptr
  %2858 = "llvm.load"(%2857) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %2859 = "llvm.getelementptr"(%143) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1152>}> : (!llvm.ptr) -> !llvm.ptr
  %2860 = "llvm.load"(%2859) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %2861 = "llvm.getelementptr"(%143) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1216>}> : (!llvm.ptr) -> !llvm.ptr
  %2862 = "llvm.load"(%2861) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %2863 = "llvm.call_intrinsic"(%94, %2854, %2277) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2864 = "llvm.shl"(%2863, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2865 = "llvm.call_intrinsic"(%2864, %2854, %2279) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2866 = "llvm.call_intrinsic"(%2865, %2856, %2277) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2867 = "llvm.call_intrinsic"(%94, %2854, %2279) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2868 = "llvm.call_intrinsic"(%2867, %2856, %2277) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2869 = "llvm.shl"(%2868, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2870 = "llvm.call_intrinsic"(%2869, %2854, %2281) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2871 = "llvm.call_intrinsic"(%2870, %2856, %2279) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2872 = "llvm.call_intrinsic"(%2871, %2858, %2277) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2873 = "llvm.call_intrinsic"(%94, %2854, %2281) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2874 = "llvm.call_intrinsic"(%2873, %2856, %2279) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2875 = "llvm.call_intrinsic"(%2874, %2858, %2277) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2876 = "llvm.shl"(%2875, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2877 = "llvm.call_intrinsic"(%2876, %2854, %2283) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2878 = "llvm.call_intrinsic"(%2877, %2856, %2281) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2879 = "llvm.call_intrinsic"(%2878, %2858, %2279) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2880 = "llvm.call_intrinsic"(%2879, %2860, %2277) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2881 = "llvm.call_intrinsic"(%94, %2854, %2283) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2882 = "llvm.call_intrinsic"(%2881, %2856, %2281) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2883 = "llvm.call_intrinsic"(%2882, %2858, %2279) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2884 = "llvm.call_intrinsic"(%2883, %2860, %2277) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2885 = "llvm.shl"(%2884, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2886 = "llvm.call_intrinsic"(%2885, %2854, %2285) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2887 = "llvm.call_intrinsic"(%2886, %2856, %2283) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2888 = "llvm.call_intrinsic"(%2887, %2858, %2281) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2889 = "llvm.call_intrinsic"(%2888, %2860, %2279) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2890 = "llvm.call_intrinsic"(%2889, %2862, %2277) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2891 = "llvm.call_intrinsic"(%94, %2854, %2285) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2892 = "llvm.call_intrinsic"(%2891, %2856, %2283) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2893 = "llvm.call_intrinsic"(%2892, %2858, %2281) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2894 = "llvm.call_intrinsic"(%2893, %2860, %2279) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2895 = "llvm.call_intrinsic"(%2894, %2862, %2277) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2896 = "llvm.shl"(%2895, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2897 = "llvm.call_intrinsic"(%2896, %2856, %2285) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2898 = "llvm.call_intrinsic"(%2897, %2858, %2283) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2899 = "llvm.call_intrinsic"(%2898, %2860, %2281) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2900 = "llvm.call_intrinsic"(%2899, %2862, %2279) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2901 = "llvm.call_intrinsic"(%94, %2856, %2285) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2902 = "llvm.call_intrinsic"(%2901, %2858, %2283) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2903 = "llvm.call_intrinsic"(%2902, %2860, %2281) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2904 = "llvm.call_intrinsic"(%2903, %2862, %2279) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2905 = "llvm.shl"(%2904, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2906 = "llvm.call_intrinsic"(%2905, %2858, %2285) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2907 = "llvm.call_intrinsic"(%2906, %2860, %2283) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2908 = "llvm.call_intrinsic"(%2907, %2862, %2281) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2909 = "llvm.call_intrinsic"(%94, %2858, %2285) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2910 = "llvm.call_intrinsic"(%2909, %2860, %2283) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2911 = "llvm.call_intrinsic"(%2910, %2862, %2281) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2912 = "llvm.shl"(%2911, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2913 = "llvm.call_intrinsic"(%2912, %2860, %2285) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2914 = "llvm.call_intrinsic"(%2913, %2862, %2283) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2915 = "llvm.call_intrinsic"(%94, %2860, %2285) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2916 = "llvm.call_intrinsic"(%2915, %2862, %2283) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2917 = "llvm.shl"(%2916, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2918 = "llvm.call_intrinsic"(%2917, %2862, %2285) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2919 = "llvm.call_intrinsic"(%94, %2862, %2285) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2920 = "llvm.mul"(%2900, %103) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2921 = "llvm.call_intrinsic"(%2920, %2854, %2277) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2922 = "llvm.mul"(%2908, %103) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2923 = "llvm.add"(%2922, %2866) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2924 = "llvm.mul"(%2914, %103) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2925 = "llvm.add"(%2924, %2872) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2926 = "llvm.mul"(%2918, %103) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2927 = "llvm.add"(%2926, %2880) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2928 = "llvm.mul"(%2919, %102) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2929 = "llvm.add"(%2928, %2890) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2930 = "llvm.lshr"(%2921, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2931 = "llvm.lshr"(%2923, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2932 = "llvm.lshr"(%2925, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2933 = "llvm.lshr"(%2927, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2934 = "llvm.lshr"(%2929, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2935 = "llvm.and"(%2921, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2936 = "llvm.call_intrinsic"(%2935, %2934, %103) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2937 = "llvm.and"(%2923, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2938 = "llvm.add"(%2930, %2937) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2939 = "llvm.and"(%2925, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2940 = "llvm.add"(%2939, %2931) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2941 = "llvm.and"(%2927, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2942 = "llvm.add"(%2941, %2932) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2943 = "llvm.and"(%2929, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2944 = "llvm.add"(%2943, %2933) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2945 = "llvm.sub"(%108, %2936) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2946 = "llvm.sub"(%109, %2938) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2947 = "llvm.sub"(%109, %2940) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2948 = "llvm.sub"(%109, %2942) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2949 = "llvm.sub"(%109, %2944) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2950 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 6400>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2809, %2950) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2951 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 6464>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2811, %2951) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2952 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 6528>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2813, %2952) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2953 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 6592>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2815, %2953) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2954 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 6656>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2817, %2954) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2955 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 6720>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2834, %2955) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2956 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 6784>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2836, %2956) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2957 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 6848>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2838, %2957) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2958 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 6912>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2840, %2958) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2959 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 6976>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2842, %2959) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2960 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 7040>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2936, %2960) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2961 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 7104>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2938, %2961) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2962 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 7168>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2940, %2962) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2963 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 7232>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2942, %2963) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2964 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 7296>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2944, %2964) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2965 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 7360>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2945, %2965) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2966 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 7424>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2946, %2966) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2967 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 7488>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2947, %2967) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2968 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 7552>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2948, %2968) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2969 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 7616>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2949, %2969) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2970 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 7680>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2844, %2970) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2971 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 7744>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2846, %2971) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2972 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 7808>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2848, %2972) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2973 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 7872>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2850, %2973) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2974 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 7936>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2852, %2974) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.call"(%145, %143, %140) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_lane_point_add, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  %2975 = "llvm.getelementptr"(%145) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 320>}> : (!llvm.ptr) -> !llvm.ptr
  %2976 = "llvm.load"(%2975) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %2977 = "llvm.load"(%145) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %2978 = "llvm.add"(%2977, %2976) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2979 = "llvm.getelementptr"(%145) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 384>}> : (!llvm.ptr) -> !llvm.ptr
  %2980 = "llvm.load"(%2979) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %2981 = "llvm.getelementptr"(%145) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %2982 = "llvm.load"(%2981) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %2983 = "llvm.add"(%2982, %2980) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2984 = "llvm.getelementptr"(%145) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 448>}> : (!llvm.ptr) -> !llvm.ptr
  %2985 = "llvm.load"(%2984) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %2986 = "llvm.getelementptr"(%145) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %2987 = "llvm.load"(%2986) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %2988 = "llvm.add"(%2987, %2985) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2989 = "llvm.getelementptr"(%145) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 512>}> : (!llvm.ptr) -> !llvm.ptr
  %2990 = "llvm.load"(%2989) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %2991 = "llvm.getelementptr"(%145) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 192>}> : (!llvm.ptr) -> !llvm.ptr
  %2992 = "llvm.load"(%2991) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %2993 = "llvm.add"(%2992, %2990) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2994 = "llvm.getelementptr"(%145) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 576>}> : (!llvm.ptr) -> !llvm.ptr
  %2995 = "llvm.load"(%2994) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %2996 = "llvm.getelementptr"(%145) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 256>}> : (!llvm.ptr) -> !llvm.ptr
  %2997 = "llvm.load"(%2996) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %2998 = "llvm.add"(%2997, %2995) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2999 = "llvm.lshr"(%2978, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3000 = "llvm.lshr"(%2983, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3001 = "llvm.lshr"(%2988, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3002 = "llvm.lshr"(%2993, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3003 = "llvm.lshr"(%2998, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3004 = "llvm.and"(%2978, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3005 = "llvm.call_intrinsic"(%3004, %3003, %103) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3006 = "llvm.and"(%2983, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3007 = "llvm.add"(%3006, %2999) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3008 = "llvm.and"(%2988, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3009 = "llvm.add"(%3008, %3000) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3010 = "llvm.and"(%2993, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3011 = "llvm.add"(%3010, %3001) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3012 = "llvm.and"(%2998, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3013 = "llvm.add"(%3012, %3002) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3014 = "llvm.add"(%2976, %36) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3015 = "llvm.sub"(%3014, %2977) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3016 = "llvm.add"(%2980, %106) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3017 = "llvm.sub"(%3016, %2982) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3018 = "llvm.add"(%2985, %106) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3019 = "llvm.sub"(%3018, %2987) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3020 = "llvm.add"(%2990, %106) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3021 = "llvm.sub"(%3020, %2992) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3022 = "llvm.add"(%2995, %106) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3023 = "llvm.sub"(%3022, %2997) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3024 = "llvm.lshr"(%3015, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3025 = "llvm.lshr"(%3017, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3026 = "llvm.lshr"(%3019, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3027 = "llvm.lshr"(%3021, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3028 = "llvm.lshr"(%3023, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3029 = "llvm.and"(%3015, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3030 = "llvm.call_intrinsic"(%3029, %3028, %103) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3031 = "llvm.and"(%3017, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3032 = "llvm.add"(%3031, %3024) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3033 = "llvm.and"(%3019, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3034 = "llvm.add"(%3033, %3025) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3035 = "llvm.and"(%3021, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3036 = "llvm.add"(%3035, %3026) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3037 = "llvm.and"(%3023, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3038 = "llvm.add"(%3037, %3027) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3039 = "llvm.getelementptr"(%145) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 640>}> : (!llvm.ptr) -> !llvm.ptr
  %3040 = "llvm.load"(%3039) <{alignment = 64 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi64>
  %3041 = "llvm.getelementptr"(%145) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 704>}> : (!llvm.ptr) -> !llvm.ptr
  %3042 = "llvm.load"(%3041) <{alignment = 64 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi64>
  %3043 = "llvm.getelementptr"(%145) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 768>}> : (!llvm.ptr) -> !llvm.ptr
  %3044 = "llvm.load"(%3043) <{alignment = 64 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi64>
  %3045 = "llvm.getelementptr"(%145) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 832>}> : (!llvm.ptr) -> !llvm.ptr
  %3046 = "llvm.load"(%3045) <{alignment = 64 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi64>
  %3047 = "llvm.getelementptr"(%145) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 896>}> : (!llvm.ptr) -> !llvm.ptr
  %3048 = "llvm.load"(%3047) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %3049 = "llvm.getelementptr"(%145) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 960>}> : (!llvm.ptr) -> !llvm.ptr
  %3050 = "llvm.load"(%3049) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %3051 = "llvm.getelementptr"(%145) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1024>}> : (!llvm.ptr) -> !llvm.ptr
  %3052 = "llvm.load"(%3051) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %3053 = "llvm.getelementptr"(%145) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1088>}> : (!llvm.ptr) -> !llvm.ptr
  %3054 = "llvm.load"(%3053) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %3055 = "llvm.getelementptr"(%145) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1152>}> : (!llvm.ptr) -> !llvm.ptr
  %3056 = "llvm.load"(%3055) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %3057 = "llvm.getelementptr"(%145) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1216>}> : (!llvm.ptr) -> !llvm.ptr
  %3058 = "llvm.load"(%3057) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %3059 = "llvm.call_intrinsic"(%94, %3050, %2277) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3060 = "llvm.shl"(%3059, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3061 = "llvm.call_intrinsic"(%3060, %3050, %2279) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3062 = "llvm.call_intrinsic"(%3061, %3052, %2277) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3063 = "llvm.call_intrinsic"(%94, %3050, %2279) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3064 = "llvm.call_intrinsic"(%3063, %3052, %2277) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3065 = "llvm.shl"(%3064, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3066 = "llvm.call_intrinsic"(%3065, %3050, %2281) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3067 = "llvm.call_intrinsic"(%3066, %3052, %2279) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3068 = "llvm.call_intrinsic"(%3067, %3054, %2277) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3069 = "llvm.call_intrinsic"(%94, %3050, %2281) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3070 = "llvm.call_intrinsic"(%3069, %3052, %2279) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3071 = "llvm.call_intrinsic"(%3070, %3054, %2277) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3072 = "llvm.shl"(%3071, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3073 = "llvm.call_intrinsic"(%3072, %3050, %2283) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3074 = "llvm.call_intrinsic"(%3073, %3052, %2281) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3075 = "llvm.call_intrinsic"(%3074, %3054, %2279) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3076 = "llvm.call_intrinsic"(%3075, %3056, %2277) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3077 = "llvm.call_intrinsic"(%94, %3050, %2283) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3078 = "llvm.call_intrinsic"(%3077, %3052, %2281) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3079 = "llvm.call_intrinsic"(%3078, %3054, %2279) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3080 = "llvm.call_intrinsic"(%3079, %3056, %2277) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3081 = "llvm.shl"(%3080, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3082 = "llvm.call_intrinsic"(%3081, %3050, %2285) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3083 = "llvm.call_intrinsic"(%3082, %3052, %2283) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3084 = "llvm.call_intrinsic"(%3083, %3054, %2281) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3085 = "llvm.call_intrinsic"(%3084, %3056, %2279) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3086 = "llvm.call_intrinsic"(%3085, %3058, %2277) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3087 = "llvm.call_intrinsic"(%94, %3050, %2285) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3088 = "llvm.call_intrinsic"(%3087, %3052, %2283) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3089 = "llvm.call_intrinsic"(%3088, %3054, %2281) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3090 = "llvm.call_intrinsic"(%3089, %3056, %2279) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3091 = "llvm.call_intrinsic"(%3090, %3058, %2277) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3092 = "llvm.shl"(%3091, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3093 = "llvm.call_intrinsic"(%3092, %3052, %2285) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3094 = "llvm.call_intrinsic"(%3093, %3054, %2283) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3095 = "llvm.call_intrinsic"(%3094, %3056, %2281) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3096 = "llvm.call_intrinsic"(%3095, %3058, %2279) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3097 = "llvm.call_intrinsic"(%94, %3052, %2285) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3098 = "llvm.call_intrinsic"(%3097, %3054, %2283) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3099 = "llvm.call_intrinsic"(%3098, %3056, %2281) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3100 = "llvm.call_intrinsic"(%3099, %3058, %2279) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3101 = "llvm.shl"(%3100, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3102 = "llvm.call_intrinsic"(%3101, %3054, %2285) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3103 = "llvm.call_intrinsic"(%3102, %3056, %2283) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3104 = "llvm.call_intrinsic"(%3103, %3058, %2281) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3105 = "llvm.call_intrinsic"(%94, %3054, %2285) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3106 = "llvm.call_intrinsic"(%3105, %3056, %2283) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3107 = "llvm.call_intrinsic"(%3106, %3058, %2281) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3108 = "llvm.shl"(%3107, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3109 = "llvm.call_intrinsic"(%3108, %3056, %2285) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3110 = "llvm.call_intrinsic"(%3109, %3058, %2283) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3111 = "llvm.call_intrinsic"(%94, %3056, %2285) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3112 = "llvm.call_intrinsic"(%3111, %3058, %2283) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3113 = "llvm.shl"(%3112, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3114 = "llvm.call_intrinsic"(%3113, %3058, %2285) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3115 = "llvm.call_intrinsic"(%94, %3058, %2285) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3116 = "llvm.mul"(%3096, %103) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3117 = "llvm.call_intrinsic"(%3116, %3050, %2277) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3118 = "llvm.mul"(%3104, %103) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3119 = "llvm.add"(%3118, %3062) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3120 = "llvm.mul"(%3110, %103) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3121 = "llvm.add"(%3120, %3068) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3122 = "llvm.mul"(%3114, %103) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3123 = "llvm.add"(%3122, %3076) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3124 = "llvm.mul"(%3115, %102) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3125 = "llvm.add"(%3124, %3086) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3126 = "llvm.lshr"(%3117, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3127 = "llvm.lshr"(%3119, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3128 = "llvm.lshr"(%3121, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3129 = "llvm.lshr"(%3123, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3130 = "llvm.lshr"(%3125, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3131 = "llvm.and"(%3117, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3132 = "llvm.call_intrinsic"(%3131, %3130, %103) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3133 = "llvm.and"(%3119, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3134 = "llvm.add"(%3126, %3133) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3135 = "llvm.and"(%3121, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3136 = "llvm.add"(%3135, %3127) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3137 = "llvm.and"(%3123, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3138 = "llvm.add"(%3137, %3128) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3139 = "llvm.and"(%3125, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3140 = "llvm.add"(%3139, %3129) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3141 = "llvm.sub"(%108, %3132) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3142 = "llvm.sub"(%109, %3134) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3143 = "llvm.sub"(%109, %3136) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3144 = "llvm.sub"(%109, %3138) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3145 = "llvm.sub"(%109, %3140) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3146 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8000>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3005, %3146) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %3147 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8064>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3007, %3147) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %3148 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8128>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3009, %3148) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %3149 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8192>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3011, %3149) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %3150 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8256>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3013, %3150) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %3151 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8320>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3030, %3151) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %3152 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8384>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3032, %3152) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %3153 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8448>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3034, %3153) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %3154 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8512>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3036, %3154) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %3155 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8576>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3038, %3155) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %3156 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8640>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3132, %3156) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %3157 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8704>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3134, %3157) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %3158 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8768>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3136, %3158) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %3159 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8832>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3138, %3159) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %3160 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8896>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3140, %3160) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %3161 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8960>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3141, %3161) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %3162 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 9024>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3142, %3162) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %3163 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 9088>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3143, %3163) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %3164 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 9152>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3144, %3164) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %3165 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 9216>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3145, %3165) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %3166 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 9280>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3040, %3166) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %3167 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 9344>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3042, %3167) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %3168 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 9408>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3044, %3168) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %3169 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 9472>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3046, %3169) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %3170 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 9536>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3048, %3170) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.call"(%144, %142, %52) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_lane_point_dbl, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i32) -> ()
  %3171 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 320>}> : (!llvm.ptr) -> !llvm.ptr
  %3172 = "llvm.load"(%3171) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %3173 = "llvm.load"(%144) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %3174 = "llvm.add"(%3173, %3172) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3175 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 384>}> : (!llvm.ptr) -> !llvm.ptr
  %3176 = "llvm.load"(%3175) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %3177 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %3178 = "llvm.load"(%3177) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %3179 = "llvm.add"(%3178, %3176) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3180 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 448>}> : (!llvm.ptr) -> !llvm.ptr
  %3181 = "llvm.load"(%3180) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %3182 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %3183 = "llvm.load"(%3182) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %3184 = "llvm.add"(%3183, %3181) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3185 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 512>}> : (!llvm.ptr) -> !llvm.ptr
  %3186 = "llvm.load"(%3185) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %3187 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 192>}> : (!llvm.ptr) -> !llvm.ptr
  %3188 = "llvm.load"(%3187) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %3189 = "llvm.add"(%3188, %3186) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3190 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 576>}> : (!llvm.ptr) -> !llvm.ptr
  %3191 = "llvm.load"(%3190) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %3192 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 256>}> : (!llvm.ptr) -> !llvm.ptr
  %3193 = "llvm.load"(%3192) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %3194 = "llvm.add"(%3193, %3191) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3195 = "llvm.lshr"(%3174, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3196 = "llvm.lshr"(%3179, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3197 = "llvm.lshr"(%3184, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3198 = "llvm.lshr"(%3189, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3199 = "llvm.lshr"(%3194, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3200 = "llvm.and"(%3174, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3201 = "llvm.call_intrinsic"(%3200, %3199, %103) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3202 = "llvm.and"(%3179, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3203 = "llvm.add"(%3202, %3195) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3204 = "llvm.and"(%3184, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3205 = "llvm.add"(%3204, %3196) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3206 = "llvm.and"(%3189, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3207 = "llvm.add"(%3206, %3197) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3208 = "llvm.and"(%3194, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3209 = "llvm.add"(%3208, %3198) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3210 = "llvm.add"(%3172, %36) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3211 = "llvm.sub"(%3210, %3173) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3212 = "llvm.add"(%3176, %106) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3213 = "llvm.sub"(%3212, %3178) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3214 = "llvm.add"(%3181, %106) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3215 = "llvm.sub"(%3214, %3183) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3216 = "llvm.add"(%3186, %106) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3217 = "llvm.sub"(%3216, %3188) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3218 = "llvm.add"(%3191, %106) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3219 = "llvm.sub"(%3218, %3193) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3220 = "llvm.lshr"(%3211, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3221 = "llvm.lshr"(%3213, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3222 = "llvm.lshr"(%3215, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3223 = "llvm.lshr"(%3217, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3224 = "llvm.lshr"(%3219, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3225 = "llvm.and"(%3211, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3226 = "llvm.call_intrinsic"(%3225, %3224, %103) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3227 = "llvm.and"(%3213, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3228 = "llvm.add"(%3227, %3220) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3229 = "llvm.and"(%3215, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3230 = "llvm.add"(%3229, %3221) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3231 = "llvm.and"(%3217, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3232 = "llvm.add"(%3231, %3222) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3233 = "llvm.and"(%3219, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3234 = "llvm.add"(%3233, %3223) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3235 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 640>}> : (!llvm.ptr) -> !llvm.ptr
  %3236 = "llvm.load"(%3235) <{alignment = 64 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi64>
  %3237 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 704>}> : (!llvm.ptr) -> !llvm.ptr
  %3238 = "llvm.load"(%3237) <{alignment = 64 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi64>
  %3239 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 768>}> : (!llvm.ptr) -> !llvm.ptr
  %3240 = "llvm.load"(%3239) <{alignment = 64 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi64>
  %3241 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 832>}> : (!llvm.ptr) -> !llvm.ptr
  %3242 = "llvm.load"(%3241) <{alignment = 64 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi64>
  %3243 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 896>}> : (!llvm.ptr) -> !llvm.ptr
  %3244 = "llvm.load"(%3243) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %3245 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 960>}> : (!llvm.ptr) -> !llvm.ptr
  %3246 = "llvm.load"(%3245) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %3247 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1024>}> : (!llvm.ptr) -> !llvm.ptr
  %3248 = "llvm.load"(%3247) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %3249 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1088>}> : (!llvm.ptr) -> !llvm.ptr
  %3250 = "llvm.load"(%3249) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %3251 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1152>}> : (!llvm.ptr) -> !llvm.ptr
  %3252 = "llvm.load"(%3251) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %3253 = "llvm.getelementptr"(%144) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1216>}> : (!llvm.ptr) -> !llvm.ptr
  %3254 = "llvm.load"(%3253) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %3255 = "llvm.call_intrinsic"(%94, %3246, %2277) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3256 = "llvm.shl"(%3255, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3257 = "llvm.call_intrinsic"(%3256, %3246, %2279) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3258 = "llvm.call_intrinsic"(%3257, %3248, %2277) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3259 = "llvm.call_intrinsic"(%94, %3246, %2279) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3260 = "llvm.call_intrinsic"(%3259, %3248, %2277) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3261 = "llvm.shl"(%3260, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3262 = "llvm.call_intrinsic"(%3261, %3246, %2281) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3263 = "llvm.call_intrinsic"(%3262, %3248, %2279) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3264 = "llvm.call_intrinsic"(%3263, %3250, %2277) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3265 = "llvm.call_intrinsic"(%94, %3246, %2281) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3266 = "llvm.call_intrinsic"(%3265, %3248, %2279) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3267 = "llvm.call_intrinsic"(%3266, %3250, %2277) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3268 = "llvm.shl"(%3267, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3269 = "llvm.call_intrinsic"(%3268, %3246, %2283) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3270 = "llvm.call_intrinsic"(%3269, %3248, %2281) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3271 = "llvm.call_intrinsic"(%3270, %3250, %2279) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3272 = "llvm.call_intrinsic"(%3271, %3252, %2277) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3273 = "llvm.call_intrinsic"(%94, %3246, %2283) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3274 = "llvm.call_intrinsic"(%3273, %3248, %2281) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3275 = "llvm.call_intrinsic"(%3274, %3250, %2279) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3276 = "llvm.call_intrinsic"(%3275, %3252, %2277) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3277 = "llvm.shl"(%3276, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3278 = "llvm.call_intrinsic"(%3277, %3246, %2285) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3279 = "llvm.call_intrinsic"(%3278, %3248, %2283) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3280 = "llvm.call_intrinsic"(%3279, %3250, %2281) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3281 = "llvm.call_intrinsic"(%3280, %3252, %2279) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3282 = "llvm.call_intrinsic"(%3281, %3254, %2277) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3283 = "llvm.call_intrinsic"(%94, %3246, %2285) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3284 = "llvm.call_intrinsic"(%3283, %3248, %2283) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3285 = "llvm.call_intrinsic"(%3284, %3250, %2281) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3286 = "llvm.call_intrinsic"(%3285, %3252, %2279) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3287 = "llvm.call_intrinsic"(%3286, %3254, %2277) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3288 = "llvm.shl"(%3287, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3289 = "llvm.call_intrinsic"(%3288, %3248, %2285) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3290 = "llvm.call_intrinsic"(%3289, %3250, %2283) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3291 = "llvm.call_intrinsic"(%3290, %3252, %2281) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3292 = "llvm.call_intrinsic"(%3291, %3254, %2279) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3293 = "llvm.call_intrinsic"(%94, %3248, %2285) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3294 = "llvm.call_intrinsic"(%3293, %3250, %2283) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3295 = "llvm.call_intrinsic"(%3294, %3252, %2281) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3296 = "llvm.call_intrinsic"(%3295, %3254, %2279) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3297 = "llvm.shl"(%3296, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3298 = "llvm.call_intrinsic"(%3297, %3250, %2285) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3299 = "llvm.call_intrinsic"(%3298, %3252, %2283) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3300 = "llvm.call_intrinsic"(%3299, %3254, %2281) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3301 = "llvm.call_intrinsic"(%94, %3250, %2285) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3302 = "llvm.call_intrinsic"(%3301, %3252, %2283) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3303 = "llvm.call_intrinsic"(%3302, %3254, %2281) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3304 = "llvm.shl"(%3303, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3305 = "llvm.call_intrinsic"(%3304, %3252, %2285) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3306 = "llvm.call_intrinsic"(%3305, %3254, %2283) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3307 = "llvm.call_intrinsic"(%94, %3252, %2285) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3308 = "llvm.call_intrinsic"(%3307, %3254, %2283) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3309 = "llvm.shl"(%3308, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3310 = "llvm.call_intrinsic"(%3309, %3254, %2285) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3311 = "llvm.call_intrinsic"(%94, %3254, %2285) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3312 = "llvm.mul"(%3292, %103) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3313 = "llvm.call_intrinsic"(%3312, %3246, %2277) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3314 = "llvm.mul"(%3300, %103) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3315 = "llvm.add"(%3314, %3258) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3316 = "llvm.mul"(%3306, %103) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3317 = "llvm.add"(%3316, %3264) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3318 = "llvm.mul"(%3310, %103) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3319 = "llvm.add"(%3318, %3272) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3320 = "llvm.mul"(%3311, %102) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3321 = "llvm.add"(%3320, %3282) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3322 = "llvm.lshr"(%3313, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3323 = "llvm.lshr"(%3315, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3324 = "llvm.lshr"(%3317, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3325 = "llvm.lshr"(%3319, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3326 = "llvm.lshr"(%3321, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3327 = "llvm.and"(%3313, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3328 = "llvm.call_intrinsic"(%3327, %3326, %103) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3329 = "llvm.and"(%3315, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3330 = "llvm.add"(%3322, %3329) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3331 = "llvm.and"(%3317, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3332 = "llvm.add"(%3331, %3323) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3333 = "llvm.and"(%3319, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3334 = "llvm.add"(%3333, %3324) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3335 = "llvm.and"(%3321, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3336 = "llvm.add"(%3335, %3325) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3337 = "llvm.sub"(%108, %3328) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3338 = "llvm.sub"(%109, %3330) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3339 = "llvm.sub"(%109, %3332) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3340 = "llvm.sub"(%109, %3334) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3341 = "llvm.sub"(%109, %3336) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3342 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 9600>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3201, %3342) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %3343 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 9664>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3203, %3343) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %3344 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 9728>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3205, %3344) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %3345 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 9792>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3207, %3345) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %3346 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 9856>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3209, %3346) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %3347 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 9920>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3226, %3347) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %3348 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 9984>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3228, %3348) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %3349 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 10048>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3230, %3349) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %3350 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 10112>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3232, %3350) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %3351 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 10176>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3234, %3351) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %3352 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 10240>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3328, %3352) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %3353 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 10304>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3330, %3353) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %3354 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 10368>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3332, %3354) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %3355 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 10432>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3334, %3355) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %3356 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 10496>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3336, %3356) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %3357 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 10560>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3337, %3357) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %3358 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 10624>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3338, %3358) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %3359 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 10688>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3339, %3359) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %3360 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 10752>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3340, %3360) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %3361 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 10816>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3341, %3361) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %3362 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 10880>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3236, %3362) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %3363 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 10944>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3238, %3363) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %3364 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 11008>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3240, %3364) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %3365 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 11072>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3242, %3365) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %3366 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 11136>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3244, %3366) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.call"(%145, %144, %140) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_lane_point_add, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  %3367 = "llvm.load"(%2975) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %3368 = "llvm.load"(%145) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %3369 = "llvm.add"(%3368, %3367) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3370 = "llvm.load"(%2979) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %3371 = "llvm.load"(%2981) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %3372 = "llvm.add"(%3371, %3370) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3373 = "llvm.load"(%2984) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %3374 = "llvm.load"(%2986) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %3375 = "llvm.add"(%3374, %3373) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3376 = "llvm.load"(%2989) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %3377 = "llvm.load"(%2991) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %3378 = "llvm.add"(%3377, %3376) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3379 = "llvm.load"(%2994) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %3380 = "llvm.load"(%2996) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %3381 = "llvm.add"(%3380, %3379) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3382 = "llvm.lshr"(%3369, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3383 = "llvm.lshr"(%3372, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3384 = "llvm.lshr"(%3375, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3385 = "llvm.lshr"(%3378, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3386 = "llvm.lshr"(%3381, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3387 = "llvm.and"(%3369, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3388 = "llvm.call_intrinsic"(%3387, %3386, %103) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3389 = "llvm.and"(%3372, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3390 = "llvm.add"(%3389, %3382) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3391 = "llvm.and"(%3375, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3392 = "llvm.add"(%3391, %3383) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3393 = "llvm.and"(%3378, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3394 = "llvm.add"(%3393, %3384) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3395 = "llvm.and"(%3381, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3396 = "llvm.add"(%3395, %3385) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3397 = "llvm.add"(%3367, %36) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3398 = "llvm.sub"(%3397, %3368) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3399 = "llvm.add"(%3370, %106) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3400 = "llvm.sub"(%3399, %3371) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3401 = "llvm.add"(%3373, %106) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3402 = "llvm.sub"(%3401, %3374) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3403 = "llvm.add"(%3376, %106) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3404 = "llvm.sub"(%3403, %3377) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3405 = "llvm.add"(%3379, %106) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3406 = "llvm.sub"(%3405, %3380) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3407 = "llvm.lshr"(%3398, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3408 = "llvm.lshr"(%3400, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3409 = "llvm.lshr"(%3402, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3410 = "llvm.lshr"(%3404, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3411 = "llvm.lshr"(%3406, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3412 = "llvm.and"(%3398, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3413 = "llvm.call_intrinsic"(%3412, %3411, %103) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3414 = "llvm.and"(%3400, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3415 = "llvm.add"(%3414, %3407) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3416 = "llvm.and"(%3402, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3417 = "llvm.add"(%3416, %3408) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3418 = "llvm.and"(%3404, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3419 = "llvm.add"(%3418, %3409) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3420 = "llvm.and"(%3406, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3421 = "llvm.add"(%3420, %3410) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3422 = "llvm.load"(%3039) <{alignment = 64 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi64>
  %3423 = "llvm.load"(%3041) <{alignment = 64 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi64>
  %3424 = "llvm.load"(%3043) <{alignment = 64 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi64>
  %3425 = "llvm.load"(%3045) <{alignment = 64 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi64>
  %3426 = "llvm.load"(%3047) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %3427 = "llvm.load"(%3049) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %3428 = "llvm.load"(%3051) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %3429 = "llvm.load"(%3053) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %3430 = "llvm.load"(%3055) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %3431 = "llvm.load"(%3057) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %3432 = "llvm.load"(%139) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %3433 = "llvm.load"(%2278) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %3434 = "llvm.load"(%2280) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %3435 = "llvm.load"(%2282) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %3436 = "llvm.load"(%2284) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %3437 = "llvm.call_intrinsic"(%94, %3427, %3432) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3438 = "llvm.shl"(%3437, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3439 = "llvm.call_intrinsic"(%3438, %3427, %3433) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3440 = "llvm.call_intrinsic"(%3439, %3428, %3432) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3441 = "llvm.call_intrinsic"(%94, %3427, %3433) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3442 = "llvm.call_intrinsic"(%3441, %3428, %3432) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3443 = "llvm.shl"(%3442, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3444 = "llvm.call_intrinsic"(%3443, %3427, %3434) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3445 = "llvm.call_intrinsic"(%3444, %3428, %3433) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3446 = "llvm.call_intrinsic"(%3445, %3429, %3432) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3447 = "llvm.call_intrinsic"(%94, %3427, %3434) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3448 = "llvm.call_intrinsic"(%3447, %3428, %3433) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3449 = "llvm.call_intrinsic"(%3448, %3429, %3432) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3450 = "llvm.shl"(%3449, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3451 = "llvm.call_intrinsic"(%3450, %3427, %3435) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3452 = "llvm.call_intrinsic"(%3451, %3428, %3434) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3453 = "llvm.call_intrinsic"(%3452, %3429, %3433) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3454 = "llvm.call_intrinsic"(%3453, %3430, %3432) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3455 = "llvm.call_intrinsic"(%94, %3427, %3435) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3456 = "llvm.call_intrinsic"(%3455, %3428, %3434) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3457 = "llvm.call_intrinsic"(%3456, %3429, %3433) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3458 = "llvm.call_intrinsic"(%3457, %3430, %3432) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3459 = "llvm.shl"(%3458, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3460 = "llvm.call_intrinsic"(%3459, %3427, %3436) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3461 = "llvm.call_intrinsic"(%3460, %3428, %3435) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3462 = "llvm.call_intrinsic"(%3461, %3429, %3434) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3463 = "llvm.call_intrinsic"(%3462, %3430, %3433) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3464 = "llvm.call_intrinsic"(%3463, %3431, %3432) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3465 = "llvm.call_intrinsic"(%94, %3427, %3436) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3466 = "llvm.call_intrinsic"(%3465, %3428, %3435) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3467 = "llvm.call_intrinsic"(%3466, %3429, %3434) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3468 = "llvm.call_intrinsic"(%3467, %3430, %3433) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3469 = "llvm.call_intrinsic"(%3468, %3431, %3432) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3470 = "llvm.shl"(%3469, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3471 = "llvm.call_intrinsic"(%3470, %3428, %3436) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3472 = "llvm.call_intrinsic"(%3471, %3429, %3435) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3473 = "llvm.call_intrinsic"(%3472, %3430, %3434) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3474 = "llvm.call_intrinsic"(%3473, %3431, %3433) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3475 = "llvm.call_intrinsic"(%94, %3428, %3436) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3476 = "llvm.call_intrinsic"(%3475, %3429, %3435) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3477 = "llvm.call_intrinsic"(%3476, %3430, %3434) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3478 = "llvm.call_intrinsic"(%3477, %3431, %3433) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3479 = "llvm.shl"(%3478, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3480 = "llvm.call_intrinsic"(%3479, %3429, %3436) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3481 = "llvm.call_intrinsic"(%3480, %3430, %3435) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3482 = "llvm.call_intrinsic"(%3481, %3431, %3434) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3483 = "llvm.call_intrinsic"(%94, %3429, %3436) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3484 = "llvm.call_intrinsic"(%3483, %3430, %3435) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3485 = "llvm.call_intrinsic"(%3484, %3431, %3434) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3486 = "llvm.shl"(%3485, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3487 = "llvm.call_intrinsic"(%3486, %3430, %3436) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3488 = "llvm.call_intrinsic"(%3487, %3431, %3435) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3489 = "llvm.call_intrinsic"(%94, %3430, %3436) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3490 = "llvm.call_intrinsic"(%3489, %3431, %3435) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3491 = "llvm.shl"(%3490, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3492 = "llvm.call_intrinsic"(%3491, %3431, %3436) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3493 = "llvm.call_intrinsic"(%94, %3431, %3436) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3494 = "llvm.mul"(%3474, %103) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3495 = "llvm.call_intrinsic"(%3494, %3427, %3432) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3496 = "llvm.mul"(%3482, %103) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3497 = "llvm.add"(%3496, %3440) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3498 = "llvm.mul"(%3488, %103) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3499 = "llvm.add"(%3498, %3446) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3500 = "llvm.mul"(%3492, %103) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3501 = "llvm.add"(%3500, %3454) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3502 = "llvm.mul"(%3493, %102) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3503 = "llvm.add"(%3502, %3464) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3504 = "llvm.lshr"(%3495, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3505 = "llvm.lshr"(%3497, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3506 = "llvm.lshr"(%3499, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3507 = "llvm.lshr"(%3501, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3508 = "llvm.lshr"(%3503, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3509 = "llvm.and"(%3495, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3510 = "llvm.call_intrinsic"(%3509, %3508, %103) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3511 = "llvm.and"(%3497, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3512 = "llvm.add"(%3504, %3511) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3513 = "llvm.and"(%3499, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3514 = "llvm.add"(%3513, %3505) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3515 = "llvm.and"(%3501, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3516 = "llvm.add"(%3515, %3506) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3517 = "llvm.and"(%3503, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3518 = "llvm.add"(%3517, %3507) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3519 = "llvm.sub"(%108, %3510) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3520 = "llvm.sub"(%109, %3512) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3521 = "llvm.sub"(%109, %3514) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3522 = "llvm.sub"(%109, %3516) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3523 = "llvm.sub"(%109, %3518) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3524 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 11200>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3388, %3524) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %3525 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 11264>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3390, %3525) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %3526 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 11328>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3392, %3526) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %3527 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 11392>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3394, %3527) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %3528 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 11456>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3396, %3528) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %3529 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 11520>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3413, %3529) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %3530 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 11584>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3415, %3530) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %3531 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 11648>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3417, %3531) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %3532 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 11712>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3419, %3532) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %3533 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 11776>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3421, %3533) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %3534 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 11840>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3510, %3534) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %3535 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 11904>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3512, %3535) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %3536 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 11968>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3514, %3536) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %3537 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 12032>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3516, %3537) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %3538 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 12096>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3518, %3538) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %3539 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 12160>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3519, %3539) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %3540 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 12224>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3520, %3540) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %3541 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 12288>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3521, %3541) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %3542 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 12352>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3522, %3542) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %3543 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 12416>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3523, %3543) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %3544 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 12480>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3422, %3544) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %3545 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 12544>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3423, %3545) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %3546 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 12608>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3424, %3546) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %3547 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 12672>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3425, %3547) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %3548 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 12736>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3426, %3548) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.call"(%145, %143, %52) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_lane_point_dbl, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i32) -> ()
  %3549 = "llvm.load"(%2975) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %3550 = "llvm.load"(%145) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %3551 = "llvm.add"(%3550, %3549) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3552 = "llvm.load"(%2979) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %3553 = "llvm.load"(%2981) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %3554 = "llvm.add"(%3553, %3552) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3555 = "llvm.load"(%2984) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %3556 = "llvm.load"(%2986) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %3557 = "llvm.add"(%3556, %3555) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3558 = "llvm.load"(%2989) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %3559 = "llvm.load"(%2991) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %3560 = "llvm.add"(%3559, %3558) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3561 = "llvm.load"(%2994) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %3562 = "llvm.load"(%2996) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %3563 = "llvm.add"(%3562, %3561) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3564 = "llvm.lshr"(%3551, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3565 = "llvm.lshr"(%3554, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3566 = "llvm.lshr"(%3557, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3567 = "llvm.lshr"(%3560, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3568 = "llvm.lshr"(%3563, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3569 = "llvm.and"(%3551, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3570 = "llvm.call_intrinsic"(%3569, %3568, %103) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3571 = "llvm.and"(%3554, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3572 = "llvm.add"(%3571, %3564) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3573 = "llvm.and"(%3557, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3574 = "llvm.add"(%3573, %3565) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3575 = "llvm.and"(%3560, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3576 = "llvm.add"(%3575, %3566) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3577 = "llvm.and"(%3563, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3578 = "llvm.add"(%3577, %3567) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3579 = "llvm.add"(%3549, %36) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3580 = "llvm.sub"(%3579, %3550) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3581 = "llvm.add"(%3552, %106) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3582 = "llvm.sub"(%3581, %3553) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3583 = "llvm.add"(%3555, %106) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3584 = "llvm.sub"(%3583, %3556) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3585 = "llvm.add"(%3558, %106) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3586 = "llvm.sub"(%3585, %3559) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3587 = "llvm.add"(%3561, %106) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3588 = "llvm.sub"(%3587, %3562) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3589 = "llvm.lshr"(%3580, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3590 = "llvm.lshr"(%3582, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3591 = "llvm.lshr"(%3584, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3592 = "llvm.lshr"(%3586, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3593 = "llvm.lshr"(%3588, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3594 = "llvm.and"(%3580, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3595 = "llvm.call_intrinsic"(%3594, %3593, %103) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3596 = "llvm.and"(%3582, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3597 = "llvm.add"(%3596, %3589) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3598 = "llvm.and"(%3584, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3599 = "llvm.add"(%3598, %3590) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3600 = "llvm.and"(%3586, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3601 = "llvm.add"(%3600, %3591) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3602 = "llvm.and"(%3588, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3603 = "llvm.add"(%3602, %3592) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3604 = "llvm.load"(%3039) <{alignment = 64 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi64>
  %3605 = "llvm.load"(%3041) <{alignment = 64 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi64>
  %3606 = "llvm.load"(%3043) <{alignment = 64 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi64>
  %3607 = "llvm.load"(%3045) <{alignment = 64 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi64>
  %3608 = "llvm.load"(%3047) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %3609 = "llvm.load"(%3049) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %3610 = "llvm.load"(%3051) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %3611 = "llvm.load"(%3053) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %3612 = "llvm.load"(%3055) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %3613 = "llvm.load"(%3057) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %3614 = "llvm.call_intrinsic"(%94, %3609, %3432) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3615 = "llvm.shl"(%3614, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3616 = "llvm.call_intrinsic"(%3615, %3609, %3433) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3617 = "llvm.call_intrinsic"(%3616, %3610, %3432) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3618 = "llvm.call_intrinsic"(%94, %3609, %3433) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3619 = "llvm.call_intrinsic"(%3618, %3610, %3432) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3620 = "llvm.shl"(%3619, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3621 = "llvm.call_intrinsic"(%3620, %3609, %3434) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3622 = "llvm.call_intrinsic"(%3621, %3610, %3433) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3623 = "llvm.call_intrinsic"(%3622, %3611, %3432) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3624 = "llvm.call_intrinsic"(%94, %3609, %3434) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3625 = "llvm.call_intrinsic"(%3624, %3610, %3433) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3626 = "llvm.call_intrinsic"(%3625, %3611, %3432) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3627 = "llvm.shl"(%3626, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3628 = "llvm.call_intrinsic"(%3627, %3609, %3435) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3629 = "llvm.call_intrinsic"(%3628, %3610, %3434) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3630 = "llvm.call_intrinsic"(%3629, %3611, %3433) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3631 = "llvm.call_intrinsic"(%3630, %3612, %3432) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3632 = "llvm.call_intrinsic"(%94, %3609, %3435) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3633 = "llvm.call_intrinsic"(%3632, %3610, %3434) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3634 = "llvm.call_intrinsic"(%3633, %3611, %3433) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3635 = "llvm.call_intrinsic"(%3634, %3612, %3432) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3636 = "llvm.shl"(%3635, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3637 = "llvm.call_intrinsic"(%3636, %3609, %3436) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3638 = "llvm.call_intrinsic"(%3637, %3610, %3435) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3639 = "llvm.call_intrinsic"(%3638, %3611, %3434) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3640 = "llvm.call_intrinsic"(%3639, %3612, %3433) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3641 = "llvm.call_intrinsic"(%3640, %3613, %3432) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3642 = "llvm.call_intrinsic"(%94, %3609, %3436) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3643 = "llvm.call_intrinsic"(%3642, %3610, %3435) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3644 = "llvm.call_intrinsic"(%3643, %3611, %3434) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3645 = "llvm.call_intrinsic"(%3644, %3612, %3433) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3646 = "llvm.call_intrinsic"(%3645, %3613, %3432) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3647 = "llvm.shl"(%3646, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3648 = "llvm.call_intrinsic"(%3647, %3610, %3436) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3649 = "llvm.call_intrinsic"(%3648, %3611, %3435) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3650 = "llvm.call_intrinsic"(%3649, %3612, %3434) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3651 = "llvm.call_intrinsic"(%3650, %3613, %3433) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3652 = "llvm.call_intrinsic"(%94, %3610, %3436) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3653 = "llvm.call_intrinsic"(%3652, %3611, %3435) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3654 = "llvm.call_intrinsic"(%3653, %3612, %3434) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3655 = "llvm.call_intrinsic"(%3654, %3613, %3433) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3656 = "llvm.shl"(%3655, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3657 = "llvm.call_intrinsic"(%3656, %3611, %3436) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3658 = "llvm.call_intrinsic"(%3657, %3612, %3435) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3659 = "llvm.call_intrinsic"(%3658, %3613, %3434) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3660 = "llvm.call_intrinsic"(%94, %3611, %3436) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3661 = "llvm.call_intrinsic"(%3660, %3612, %3435) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3662 = "llvm.call_intrinsic"(%3661, %3613, %3434) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3663 = "llvm.shl"(%3662, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3664 = "llvm.call_intrinsic"(%3663, %3612, %3436) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3665 = "llvm.call_intrinsic"(%3664, %3613, %3435) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3666 = "llvm.call_intrinsic"(%94, %3612, %3436) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3667 = "llvm.call_intrinsic"(%3666, %3613, %3435) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3668 = "llvm.shl"(%3667, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3669 = "llvm.call_intrinsic"(%3668, %3613, %3436) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3670 = "llvm.call_intrinsic"(%94, %3613, %3436) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3671 = "llvm.mul"(%3651, %103) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3672 = "llvm.call_intrinsic"(%3671, %3609, %3432) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3673 = "llvm.mul"(%3659, %103) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3674 = "llvm.add"(%3673, %3617) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3675 = "llvm.mul"(%3665, %103) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3676 = "llvm.add"(%3675, %3623) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3677 = "llvm.mul"(%3669, %103) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3678 = "llvm.add"(%3677, %3631) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3679 = "llvm.mul"(%3670, %102) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3680 = "llvm.add"(%3679, %3641) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3681 = "llvm.lshr"(%3672, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3682 = "llvm.lshr"(%3674, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3683 = "llvm.lshr"(%3676, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3684 = "llvm.lshr"(%3678, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3685 = "llvm.lshr"(%3680, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3686 = "llvm.and"(%3672, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3687 = "llvm.call_intrinsic"(%3686, %3685, %103) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3688 = "llvm.and"(%3674, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3689 = "llvm.add"(%3681, %3688) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3690 = "llvm.and"(%3676, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3691 = "llvm.add"(%3690, %3682) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3692 = "llvm.and"(%3678, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3693 = "llvm.add"(%3692, %3683) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3694 = "llvm.and"(%3680, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3695 = "llvm.add"(%3694, %3684) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3696 = "llvm.sub"(%108, %3687) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3697 = "llvm.sub"(%109, %3689) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3698 = "llvm.sub"(%109, %3691) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3699 = "llvm.sub"(%109, %3693) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3700 = "llvm.sub"(%109, %3695) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3701 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 12800>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3570, %3701) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %3702 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 12864>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3572, %3702) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %3703 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 12928>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3574, %3703) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %3704 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 12992>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3576, %3704) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %3705 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 13056>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3578, %3705) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %3706 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 13120>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3595, %3706) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %3707 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 13184>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3597, %3707) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %3708 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 13248>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3599, %3708) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %3709 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 13312>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3601, %3709) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %3710 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 13376>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3603, %3710) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %3711 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 13440>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3687, %3711) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %3712 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 13504>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3689, %3712) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %3713 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 13568>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3691, %3713) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %3714 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 13632>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3693, %3714) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %3715 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 13696>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3695, %3715) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %3716 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 13760>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3696, %3716) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %3717 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 13824>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3697, %3717) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %3718 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 13888>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3698, %3718) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %3719 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 13952>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3699, %3719) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %3720 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 14016>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3700, %3720) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %3721 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 14080>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3604, %3721) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %3722 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 14144>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3605, %3722) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %3723 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 14208>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3606, %3723) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %3724 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 14272>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3607, %3724) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %3725 = "llvm.getelementptr"(%138) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 14336>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3608, %3725) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%145) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%144) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%143) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%142) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%141) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%140) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%146) : (!llvm.ptr) -> ()
  %3726 = "llvm.getelementptr"(%146) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 960>}> : (!llvm.ptr) -> !llvm.ptr
  %3727 = "llvm.getelementptr"(%146) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 640>}> : (!llvm.ptr) -> !llvm.ptr
  %3728 = "llvm.getelementptr"(%146) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 320>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.memset"(%146, %53, %82) <{arg_attrs = [{llvm.align = 64 : i64, llvm.dereferenceable = 320 : i64, llvm.nonnull, llvm.noundef}, {}, {}], isVolatile = false, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr, i8, i64) -> ()
  "llvm.store"(%94, %3726) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.store"(%95, %3727) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.store"(%95, %3728) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %3729 = "llvm.getelementptr"(%146) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1024>}> : (!llvm.ptr) -> !llvm.ptr
  %3730 = "llvm.getelementptr"(%146) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 704>}> : (!llvm.ptr) -> !llvm.ptr
  %3731 = "llvm.getelementptr"(%146) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 384>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.memset"(%3731, %53, %54) <{arg_attrs = [{llvm.align = 64 : i64, llvm.dereferenceable = 256 : i64, llvm.nonnull, llvm.noundef}, {}, {}], isVolatile = false}> : (!llvm.ptr, i8, i64) -> ()
  "llvm.intr.memset"(%3730, %53, %54) <{arg_attrs = [{llvm.align = 64 : i64, llvm.dereferenceable = 256 : i64, llvm.nonnull, llvm.noundef}, {}, {}], isVolatile = false}> : (!llvm.ptr, i8, i64) -> ()
  "llvm.intr.memset"(%3729, %53, %54) <{arg_attrs = [{llvm.align = 64 : i64, llvm.dereferenceable = 256 : i64, llvm.nonnull, llvm.noundef}, {}, {}], isVolatile = false}> : (!llvm.ptr, i8, i64) -> ()
  %3732 = "llvm.getelementptr"(%147) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %3733 = "llvm.getelementptr"(%148) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %3734 = "llvm.getelementptr"(%149) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %3735 = "llvm.getelementptr"(%150) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %3736 = "llvm.getelementptr"(%147) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %3737 = "llvm.getelementptr"(%148) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %3738 = "llvm.getelementptr"(%149) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %3739 = "llvm.getelementptr"(%150) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %3740 = "llvm.getelementptr"(%147) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %3741 = "llvm.getelementptr"(%148) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %3742 = "llvm.getelementptr"(%149) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %3743 = "llvm.getelementptr"(%150) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %3744 = "llvm.getelementptr"(%147) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %3745 = "llvm.getelementptr"(%148) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %3746 = "llvm.getelementptr"(%149) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %3747 = "llvm.getelementptr"(%150) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %3748 = "llvm.getelementptr"(%147) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 40>}> : (!llvm.ptr) -> !llvm.ptr
  %3749 = "llvm.getelementptr"(%148) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 40>}> : (!llvm.ptr) -> !llvm.ptr
  %3750 = "llvm.getelementptr"(%149) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 40>}> : (!llvm.ptr) -> !llvm.ptr
  %3751 = "llvm.getelementptr"(%150) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 40>}> : (!llvm.ptr) -> !llvm.ptr
  %3752 = "llvm.getelementptr"(%147) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 48>}> : (!llvm.ptr) -> !llvm.ptr
  %3753 = "llvm.getelementptr"(%148) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 48>}> : (!llvm.ptr) -> !llvm.ptr
  %3754 = "llvm.getelementptr"(%149) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 48>}> : (!llvm.ptr) -> !llvm.ptr
  %3755 = "llvm.getelementptr"(%150) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 48>}> : (!llvm.ptr) -> !llvm.ptr
  %3756 = "llvm.getelementptr"(%147) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 56>}> : (!llvm.ptr) -> !llvm.ptr
  %3757 = "llvm.getelementptr"(%148) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 56>}> : (!llvm.ptr) -> !llvm.ptr
  %3758 = "llvm.getelementptr"(%149) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 56>}> : (!llvm.ptr) -> !llvm.ptr
  %3759 = "llvm.getelementptr"(%150) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 56>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.br"(%57)[^bb83] : (i64) -> ()
^bb80(%3760: i64):  // 2 preds: ^bb75, ^bb82
  "llvm.intr.lifetime.start"(%137) : (!llvm.ptr) -> ()
  %3761 = "llvm.getelementptr"(%161, %3760) <{elem_type = !llvm.array<32 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.br"(%66, %61)[^bb81] : (i64, i32) -> ()
^bb81(%3762: i64, %3763: i32):  // 2 preds: ^bb80, ^bb81
  %3764 = "llvm.lshr"(%3762, %88) <{isExact}> : (i64, i64) -> i64
  %3765 = "llvm.getelementptr"(%3761, %3764) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %3766 = "llvm.load"(%3765) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %3767 = "llvm.and"(%3766, %35) : (i8, i8) -> i8
  %3768 = "llvm.zext"(%3767) <{nonNeg}> : (i8) -> i32
  %3769 = "llvm.add"(%3763, %3768) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %3770 = "llvm.add"(%3769, %74) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %3771 = "llvm.lshr"(%3770, %71) : (i32, i32) -> i32
  %3772 = "llvm.and"(%3770, %34) : (i32, i32) -> i32
  %3773 = "llvm.sub"(%3769, %3772) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %3774 = "llvm.trunc"(%3773) <{overflowFlags = 1 : i32}> : (i32) -> i8
  %3775 = "llvm.getelementptr"(%137, %3762) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%3774, %3775) <{alignment = 4 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (i8, !llvm.ptr) -> ()
  %3776 = "llvm.lshr"(%3766, %33) : (i8, i8) -> i8
  %3777 = "llvm.zext"(%3776) <{nonNeg}> : (i8) -> i32
  %3778 = "llvm.add"(%3771, %3777) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %3779 = "llvm.add"(%3778, %74) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %3780 = "llvm.lshr"(%3779, %71) : (i32, i32) -> i32
  %3781 = "llvm.and"(%3779, %34) : (i32, i32) -> i32
  %3782 = "llvm.sub"(%3778, %3781) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %3783 = "llvm.trunc"(%3782) <{overflowFlags = 1 : i32}> : (i32) -> i8
  %3784 = "llvm.getelementptr"(%137, %3762) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %3785 = "llvm.getelementptr"(%3784) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3783, %3785) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (i8, !llvm.ptr) -> ()
  %3786 = "llvm.or"(%3762, %89) <{isDisjoint}> : (i64, i64) -> i64
  %3787 = "llvm.lshr"(%3786, %88) <{isExact}> : (i64, i64) -> i64
  %3788 = "llvm.getelementptr"(%3761, %3787) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %3789 = "llvm.load"(%3788) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %3790 = "llvm.and"(%3789, %35) : (i8, i8) -> i8
  %3791 = "llvm.zext"(%3790) <{nonNeg}> : (i8) -> i32
  %3792 = "llvm.add"(%3780, %3791) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %3793 = "llvm.add"(%3792, %74) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %3794 = "llvm.lshr"(%3793, %71) : (i32, i32) -> i32
  %3795 = "llvm.and"(%3793, %34) : (i32, i32) -> i32
  %3796 = "llvm.sub"(%3792, %3795) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %3797 = "llvm.trunc"(%3796) <{overflowFlags = 1 : i32}> : (i32) -> i8
  %3798 = "llvm.getelementptr"(%137, %3786) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%3797, %3798) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (i8, !llvm.ptr) -> ()
  %3799 = "llvm.lshr"(%3789, %33) : (i8, i8) -> i8
  %3800 = "llvm.zext"(%3799) <{nonNeg}> : (i8) -> i32
  %3801 = "llvm.add"(%3794, %3800) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %3802 = "llvm.add"(%3801, %74) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %3803 = "llvm.lshr"(%3802, %71) : (i32, i32) -> i32
  %3804 = "llvm.and"(%3802, %34) : (i32, i32) -> i32
  %3805 = "llvm.sub"(%3801, %3804) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %3806 = "llvm.trunc"(%3805) <{overflowFlags = 1 : i32}> : (i32) -> i8
  %3807 = "llvm.getelementptr"(%137, %3762) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %3808 = "llvm.getelementptr"(%3807) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 3>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3806, %3808) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (i8, !llvm.ptr) -> ()
  %3809 = "llvm.add"(%3762, %68) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %3810 = "llvm.icmp"(%3809, %85) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%3810, %3809, %3803)[^bb82, ^bb81] <{loop_annotation = #llvm.loop_annotation<mustProgress = true>, operandSegmentSizes = array<i32: 1, 0, 2>}> : (i1, i64, i32) -> ()
^bb82:  // pred: ^bb81
  %3811 = "llvm.getelementptr"(%162, %3760) <{elem_type = !llvm.array<32 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %3812 = "llvm.load"(%3811) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %3813 = "llvm.zext"(%3812) : (i8) -> i32
  %3814 = "llvm.add"(%3813, %81) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %3815 = "llvm.lshr"(%3814, %74) : (i32, i32) -> i32
  %3816 = "llvm.and"(%3814, %32) : (i32, i32) -> i32
  %3817 = "llvm.sub"(%3813, %3816) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %3818 = "llvm.trunc"(%3817) <{overflowFlags = 1 : i32}> : (i32) -> i16
  %3819 = "llvm.getelementptr"(%3811) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1>}> : (!llvm.ptr) -> !llvm.ptr
  %3820 = "llvm.load"(%3819) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %3821 = "llvm.zext"(%3820) : (i8) -> i32
  %3822 = "llvm.add"(%3815, %3821) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %3823 = "llvm.add"(%3822, %81) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %3824 = "llvm.lshr"(%3823, %74) : (i32, i32) -> i32
  %3825 = "llvm.and"(%3823, %31) : (i32, i32) -> i32
  %3826 = "llvm.sub"(%3822, %3825) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %3827 = "llvm.trunc"(%3826) <{overflowFlags = 1 : i32}> : (i32) -> i16
  %3828 = "llvm.getelementptr"(%3811) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 2>}> : (!llvm.ptr) -> !llvm.ptr
  %3829 = "llvm.load"(%3828) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %3830 = "llvm.zext"(%3829) : (i8) -> i32
  %3831 = "llvm.add"(%3824, %3830) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %3832 = "llvm.add"(%3831, %81) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %3833 = "llvm.lshr"(%3832, %74) : (i32, i32) -> i32
  %3834 = "llvm.and"(%3832, %30) : (i32, i32) -> i32
  %3835 = "llvm.sub"(%3831, %3834) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %3836 = "llvm.trunc"(%3835) <{overflowFlags = 1 : i32}> : (i32) -> i16
  %3837 = "llvm.getelementptr"(%3811) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 3>}> : (!llvm.ptr) -> !llvm.ptr
  %3838 = "llvm.load"(%3837) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %3839 = "llvm.zext"(%3838) : (i8) -> i32
  %3840 = "llvm.add"(%3833, %3839) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %3841 = "llvm.add"(%3840, %81) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %3842 = "llvm.lshr"(%3841, %74) : (i32, i32) -> i32
  %3843 = "llvm.and"(%3841, %30) : (i32, i32) -> i32
  %3844 = "llvm.sub"(%3840, %3843) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %3845 = "llvm.trunc"(%3844) <{overflowFlags = 1 : i32}> : (i32) -> i16
  %3846 = "llvm.getelementptr"(%3811) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 4>}> : (!llvm.ptr) -> !llvm.ptr
  %3847 = "llvm.load"(%3846) <{alignment = 4 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %3848 = "llvm.zext"(%3847) : (i8) -> i32
  %3849 = "llvm.add"(%3842, %3848) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %3850 = "llvm.add"(%3849, %81) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %3851 = "llvm.lshr"(%3850, %74) : (i32, i32) -> i32
  %3852 = "llvm.and"(%3850, %30) : (i32, i32) -> i32
  %3853 = "llvm.sub"(%3849, %3852) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %3854 = "llvm.trunc"(%3853) <{overflowFlags = 1 : i32}> : (i32) -> i16
  %3855 = "llvm.getelementptr"(%3811) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 5>}> : (!llvm.ptr) -> !llvm.ptr
  %3856 = "llvm.load"(%3855) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %3857 = "llvm.zext"(%3856) : (i8) -> i32
  %3858 = "llvm.add"(%3851, %3857) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %3859 = "llvm.add"(%3858, %81) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %3860 = "llvm.lshr"(%3859, %74) : (i32, i32) -> i32
  %3861 = "llvm.and"(%3859, %30) : (i32, i32) -> i32
  %3862 = "llvm.sub"(%3858, %3861) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %3863 = "llvm.trunc"(%3862) <{overflowFlags = 1 : i32}> : (i32) -> i16
  %3864 = "llvm.getelementptr"(%3811) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 6>}> : (!llvm.ptr) -> !llvm.ptr
  %3865 = "llvm.load"(%3864) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %3866 = "llvm.zext"(%3865) : (i8) -> i32
  %3867 = "llvm.add"(%3860, %3866) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %3868 = "llvm.add"(%3867, %81) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %3869 = "llvm.lshr"(%3868, %74) : (i32, i32) -> i32
  %3870 = "llvm.and"(%3868, %30) : (i32, i32) -> i32
  %3871 = "llvm.sub"(%3867, %3870) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %3872 = "llvm.trunc"(%3871) <{overflowFlags = 1 : i32}> : (i32) -> i16
  %3873 = "llvm.getelementptr"(%3811) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 7>}> : (!llvm.ptr) -> !llvm.ptr
  %3874 = "llvm.load"(%3873) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %3875 = "llvm.zext"(%3874) : (i8) -> i32
  %3876 = "llvm.add"(%3869, %3875) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %3877 = "llvm.add"(%3876, %81) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %3878 = "llvm.lshr"(%3877, %74) : (i32, i32) -> i32
  %3879 = "llvm.and"(%3877, %30) : (i32, i32) -> i32
  %3880 = "llvm.sub"(%3876, %3879) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %3881 = "llvm.trunc"(%3880) <{overflowFlags = 1 : i32}> : (i32) -> i16
  %3882 = "llvm.getelementptr"(%3811) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %3883 = "llvm.load"(%3882) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %3884 = "llvm.zext"(%3883) : (i8) -> i32
  %3885 = "llvm.add"(%3878, %3884) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %3886 = "llvm.add"(%3885, %81) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %3887 = "llvm.lshr"(%3886, %74) : (i32, i32) -> i32
  %3888 = "llvm.and"(%3886, %30) : (i32, i32) -> i32
  %3889 = "llvm.sub"(%3885, %3888) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %3890 = "llvm.trunc"(%3889) <{overflowFlags = 1 : i32}> : (i32) -> i16
  %3891 = "llvm.getelementptr"(%3811) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 9>}> : (!llvm.ptr) -> !llvm.ptr
  %3892 = "llvm.load"(%3891) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %3893 = "llvm.zext"(%3892) : (i8) -> i32
  %3894 = "llvm.add"(%3887, %3893) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %3895 = "llvm.add"(%3894, %81) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %3896 = "llvm.lshr"(%3895, %74) : (i32, i32) -> i32
  %3897 = "llvm.and"(%3895, %30) : (i32, i32) -> i32
  %3898 = "llvm.sub"(%3894, %3897) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %3899 = "llvm.trunc"(%3898) <{overflowFlags = 1 : i32}> : (i32) -> i16
  %3900 = "llvm.getelementptr"(%3811) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 10>}> : (!llvm.ptr) -> !llvm.ptr
  %3901 = "llvm.load"(%3900) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %3902 = "llvm.zext"(%3901) : (i8) -> i32
  %3903 = "llvm.add"(%3896, %3902) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %3904 = "llvm.add"(%3903, %81) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %3905 = "llvm.lshr"(%3904, %74) : (i32, i32) -> i32
  %3906 = "llvm.and"(%3904, %30) : (i32, i32) -> i32
  %3907 = "llvm.sub"(%3903, %3906) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %3908 = "llvm.trunc"(%3907) <{overflowFlags = 1 : i32}> : (i32) -> i16
  %3909 = "llvm.getelementptr"(%3811) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 11>}> : (!llvm.ptr) -> !llvm.ptr
  %3910 = "llvm.load"(%3909) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %3911 = "llvm.zext"(%3910) : (i8) -> i32
  %3912 = "llvm.add"(%3905, %3911) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %3913 = "llvm.add"(%3912, %81) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %3914 = "llvm.lshr"(%3913, %74) : (i32, i32) -> i32
  %3915 = "llvm.and"(%3913, %30) : (i32, i32) -> i32
  %3916 = "llvm.sub"(%3912, %3915) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %3917 = "llvm.trunc"(%3916) <{overflowFlags = 1 : i32}> : (i32) -> i16
  %3918 = "llvm.getelementptr"(%3811) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 12>}> : (!llvm.ptr) -> !llvm.ptr
  %3919 = "llvm.load"(%3918) <{alignment = 4 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %3920 = "llvm.zext"(%3919) : (i8) -> i32
  %3921 = "llvm.add"(%3914, %3920) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %3922 = "llvm.add"(%3921, %81) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %3923 = "llvm.lshr"(%3922, %74) : (i32, i32) -> i32
  %3924 = "llvm.and"(%3922, %30) : (i32, i32) -> i32
  %3925 = "llvm.sub"(%3921, %3924) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %3926 = "llvm.trunc"(%3925) <{overflowFlags = 1 : i32}> : (i32) -> i16
  %3927 = "llvm.getelementptr"(%3811) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 13>}> : (!llvm.ptr) -> !llvm.ptr
  %3928 = "llvm.load"(%3927) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %3929 = "llvm.zext"(%3928) : (i8) -> i32
  %3930 = "llvm.add"(%3923, %3929) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %3931 = "llvm.add"(%3930, %81) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %3932 = "llvm.lshr"(%3931, %74) : (i32, i32) -> i32
  %3933 = "llvm.and"(%3931, %30) : (i32, i32) -> i32
  %3934 = "llvm.sub"(%3930, %3933) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %3935 = "llvm.trunc"(%3934) <{overflowFlags = 1 : i32}> : (i32) -> i16
  %3936 = "llvm.getelementptr"(%3811) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 14>}> : (!llvm.ptr) -> !llvm.ptr
  %3937 = "llvm.load"(%3936) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %3938 = "llvm.zext"(%3937) : (i8) -> i32
  %3939 = "llvm.add"(%3932, %3938) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %3940 = "llvm.add"(%3939, %81) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %3941 = "llvm.lshr"(%3940, %74) : (i32, i32) -> i32
  %3942 = "llvm.and"(%3940, %30) : (i32, i32) -> i32
  %3943 = "llvm.sub"(%3939, %3942) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %3944 = "llvm.trunc"(%3943) <{overflowFlags = 1 : i32}> : (i32) -> i16
  %3945 = "llvm.getelementptr"(%3811) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 15>}> : (!llvm.ptr) -> !llvm.ptr
  %3946 = "llvm.load"(%3945) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %3947 = "llvm.zext"(%3946) : (i8) -> i32
  %3948 = "llvm.add"(%3941, %3947) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %3949 = "llvm.add"(%3948, %81) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %3950 = "llvm.lshr"(%3949, %74) : (i32, i32) -> i32
  %3951 = "llvm.and"(%3949, %30) : (i32, i32) -> i32
  %3952 = "llvm.sub"(%3948, %3951) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %3953 = "llvm.trunc"(%3952) <{overflowFlags = 1 : i32}> : (i32) -> i16
  %3954 = "llvm.getelementptr"(%3811) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %3955 = "llvm.load"(%3954) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %3956 = "llvm.zext"(%3955) : (i8) -> i32
  %3957 = "llvm.add"(%3950, %3956) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %3958 = "llvm.add"(%3957, %81) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %3959 = "llvm.lshr"(%3958, %74) : (i32, i32) -> i32
  %3960 = "llvm.and"(%3958, %30) : (i32, i32) -> i32
  %3961 = "llvm.sub"(%3957, %3960) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %3962 = "llvm.trunc"(%3961) <{overflowFlags = 1 : i32}> : (i32) -> i16
  %3963 = "llvm.getelementptr"(%3811) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 17>}> : (!llvm.ptr) -> !llvm.ptr
  %3964 = "llvm.load"(%3963) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %3965 = "llvm.zext"(%3964) : (i8) -> i32
  %3966 = "llvm.add"(%3959, %3965) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %3967 = "llvm.add"(%3966, %81) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %3968 = "llvm.lshr"(%3967, %74) : (i32, i32) -> i32
  %3969 = "llvm.and"(%3967, %30) : (i32, i32) -> i32
  %3970 = "llvm.sub"(%3966, %3969) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %3971 = "llvm.trunc"(%3970) <{overflowFlags = 1 : i32}> : (i32) -> i16
  %3972 = "llvm.getelementptr"(%3811) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 18>}> : (!llvm.ptr) -> !llvm.ptr
  %3973 = "llvm.load"(%3972) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %3974 = "llvm.zext"(%3973) : (i8) -> i32
  %3975 = "llvm.add"(%3968, %3974) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %3976 = "llvm.add"(%3975, %81) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %3977 = "llvm.lshr"(%3976, %74) : (i32, i32) -> i32
  %3978 = "llvm.and"(%3976, %30) : (i32, i32) -> i32
  %3979 = "llvm.sub"(%3975, %3978) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %3980 = "llvm.trunc"(%3979) <{overflowFlags = 1 : i32}> : (i32) -> i16
  %3981 = "llvm.getelementptr"(%3811) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 19>}> : (!llvm.ptr) -> !llvm.ptr
  %3982 = "llvm.load"(%3981) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %3983 = "llvm.zext"(%3982) : (i8) -> i32
  %3984 = "llvm.add"(%3977, %3983) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %3985 = "llvm.add"(%3984, %81) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %3986 = "llvm.lshr"(%3985, %74) : (i32, i32) -> i32
  %3987 = "llvm.and"(%3985, %30) : (i32, i32) -> i32
  %3988 = "llvm.sub"(%3984, %3987) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %3989 = "llvm.trunc"(%3988) <{overflowFlags = 1 : i32}> : (i32) -> i16
  %3990 = "llvm.getelementptr"(%3811) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 20>}> : (!llvm.ptr) -> !llvm.ptr
  %3991 = "llvm.load"(%3990) <{alignment = 4 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %3992 = "llvm.zext"(%3991) : (i8) -> i32
  %3993 = "llvm.add"(%3986, %3992) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %3994 = "llvm.add"(%3993, %81) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %3995 = "llvm.lshr"(%3994, %74) : (i32, i32) -> i32
  %3996 = "llvm.and"(%3994, %30) : (i32, i32) -> i32
  %3997 = "llvm.sub"(%3993, %3996) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %3998 = "llvm.trunc"(%3997) <{overflowFlags = 1 : i32}> : (i32) -> i16
  %3999 = "llvm.getelementptr"(%3811) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 21>}> : (!llvm.ptr) -> !llvm.ptr
  %4000 = "llvm.load"(%3999) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %4001 = "llvm.zext"(%4000) : (i8) -> i32
  %4002 = "llvm.add"(%3995, %4001) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %4003 = "llvm.add"(%4002, %81) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %4004 = "llvm.lshr"(%4003, %74) : (i32, i32) -> i32
  %4005 = "llvm.and"(%4003, %30) : (i32, i32) -> i32
  %4006 = "llvm.sub"(%4002, %4005) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %4007 = "llvm.trunc"(%4006) <{overflowFlags = 1 : i32}> : (i32) -> i16
  %4008 = "llvm.getelementptr"(%3811) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 22>}> : (!llvm.ptr) -> !llvm.ptr
  %4009 = "llvm.load"(%4008) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %4010 = "llvm.zext"(%4009) : (i8) -> i32
  %4011 = "llvm.add"(%4004, %4010) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %4012 = "llvm.add"(%4011, %81) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %4013 = "llvm.lshr"(%4012, %74) : (i32, i32) -> i32
  %4014 = "llvm.and"(%4012, %30) : (i32, i32) -> i32
  %4015 = "llvm.sub"(%4011, %4014) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %4016 = "llvm.trunc"(%4015) <{overflowFlags = 1 : i32}> : (i32) -> i16
  %4017 = "llvm.getelementptr"(%3811) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 23>}> : (!llvm.ptr) -> !llvm.ptr
  %4018 = "llvm.load"(%4017) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %4019 = "llvm.zext"(%4018) : (i8) -> i32
  %4020 = "llvm.add"(%4013, %4019) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %4021 = "llvm.add"(%4020, %81) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %4022 = "llvm.lshr"(%4021, %74) : (i32, i32) -> i32
  %4023 = "llvm.and"(%4021, %30) : (i32, i32) -> i32
  %4024 = "llvm.sub"(%4020, %4023) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %4025 = "llvm.trunc"(%4024) <{overflowFlags = 1 : i32}> : (i32) -> i16
  %4026 = "llvm.getelementptr"(%3811) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %4027 = "llvm.load"(%4026) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %4028 = "llvm.zext"(%4027) : (i8) -> i32
  %4029 = "llvm.add"(%4022, %4028) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %4030 = "llvm.add"(%4029, %81) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %4031 = "llvm.lshr"(%4030, %74) : (i32, i32) -> i32
  %4032 = "llvm.and"(%4030, %30) : (i32, i32) -> i32
  %4033 = "llvm.sub"(%4029, %4032) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %4034 = "llvm.trunc"(%4033) <{overflowFlags = 1 : i32}> : (i32) -> i16
  %4035 = "llvm.getelementptr"(%3811) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 25>}> : (!llvm.ptr) -> !llvm.ptr
  %4036 = "llvm.load"(%4035) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %4037 = "llvm.zext"(%4036) : (i8) -> i32
  %4038 = "llvm.add"(%4031, %4037) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %4039 = "llvm.add"(%4038, %81) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %4040 = "llvm.lshr"(%4039, %74) : (i32, i32) -> i32
  %4041 = "llvm.and"(%4039, %30) : (i32, i32) -> i32
  %4042 = "llvm.sub"(%4038, %4041) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %4043 = "llvm.trunc"(%4042) <{overflowFlags = 1 : i32}> : (i32) -> i16
  %4044 = "llvm.getelementptr"(%3811) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 26>}> : (!llvm.ptr) -> !llvm.ptr
  %4045 = "llvm.load"(%4044) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %4046 = "llvm.zext"(%4045) : (i8) -> i32
  %4047 = "llvm.add"(%4040, %4046) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %4048 = "llvm.add"(%4047, %81) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %4049 = "llvm.lshr"(%4048, %74) : (i32, i32) -> i32
  %4050 = "llvm.and"(%4048, %30) : (i32, i32) -> i32
  %4051 = "llvm.sub"(%4047, %4050) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %4052 = "llvm.trunc"(%4051) <{overflowFlags = 1 : i32}> : (i32) -> i16
  %4053 = "llvm.getelementptr"(%3811) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 27>}> : (!llvm.ptr) -> !llvm.ptr
  %4054 = "llvm.load"(%4053) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %4055 = "llvm.zext"(%4054) : (i8) -> i32
  %4056 = "llvm.add"(%4049, %4055) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %4057 = "llvm.add"(%4056, %81) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %4058 = "llvm.lshr"(%4057, %74) : (i32, i32) -> i32
  %4059 = "llvm.and"(%4057, %30) : (i32, i32) -> i32
  %4060 = "llvm.sub"(%4056, %4059) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %4061 = "llvm.trunc"(%4060) <{overflowFlags = 1 : i32}> : (i32) -> i16
  %4062 = "llvm.getelementptr"(%3811) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 28>}> : (!llvm.ptr) -> !llvm.ptr
  %4063 = "llvm.load"(%4062) <{alignment = 4 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %4064 = "llvm.zext"(%4063) : (i8) -> i32
  %4065 = "llvm.add"(%4058, %4064) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %4066 = "llvm.add"(%4065, %81) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %4067 = "llvm.lshr"(%4066, %74) : (i32, i32) -> i32
  %4068 = "llvm.and"(%4066, %30) : (i32, i32) -> i32
  %4069 = "llvm.sub"(%4065, %4068) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %4070 = "llvm.trunc"(%4069) <{overflowFlags = 1 : i32}> : (i32) -> i16
  %4071 = "llvm.getelementptr"(%3811) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 29>}> : (!llvm.ptr) -> !llvm.ptr
  %4072 = "llvm.load"(%4071) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %4073 = "llvm.zext"(%4072) : (i8) -> i32
  %4074 = "llvm.add"(%4067, %4073) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %4075 = "llvm.add"(%4074, %81) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %4076 = "llvm.lshr"(%4075, %74) : (i32, i32) -> i32
  %4077 = "llvm.and"(%4075, %30) : (i32, i32) -> i32
  %4078 = "llvm.sub"(%4074, %4077) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %4079 = "llvm.trunc"(%4078) <{overflowFlags = 1 : i32}> : (i32) -> i16
  %4080 = "llvm.getelementptr"(%3811) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 30>}> : (!llvm.ptr) -> !llvm.ptr
  %4081 = "llvm.load"(%4080) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %4082 = "llvm.zext"(%4081) : (i8) -> i32
  %4083 = "llvm.add"(%4076, %4082) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %4084 = "llvm.add"(%4083, %81) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %4085 = "llvm.lshr"(%4084, %74) : (i32, i32) -> i32
  %4086 = "llvm.and"(%4084, %30) : (i32, i32) -> i32
  %4087 = "llvm.sub"(%4083, %4086) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %4088 = "llvm.trunc"(%4087) <{overflowFlags = 1 : i32}> : (i32) -> i16
  %4089 = "llvm.getelementptr"(%3811) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 31>}> : (!llvm.ptr) -> !llvm.ptr
  %4090 = "llvm.load"(%4089) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> i8
  %4091 = "llvm.zext"(%4090) : (i8) -> i32
  %4092 = "llvm.add"(%4085, %4091) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %4093 = "llvm.add"(%4092, %81) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %4094 = "llvm.and"(%4093, %30) : (i32, i32) -> i32
  %4095 = "llvm.sub"(%4092, %4094) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %4096 = "llvm.trunc"(%4095) <{overflowFlags = 1 : i32}> : (i32) -> i16
  %4097 = "llvm.getelementptr"(%135, %3760) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %4098 = "llvm.load"(%137) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<64xi8>
  %4099 = "llvm.shufflevector"(%4098, %27) <{mask = array<i32: 0, -1, -1, -1, -1, -1, -1, -1, 1, -1, -1, -1, -1, -1, -1, -1, 2, -1, -1, -1, -1, -1, -1, -1, 3, -1, -1, -1, -1, -1, -1, -1, 4, -1, -1, -1, -1, -1, -1, -1, 5, -1, -1, -1, -1, -1, -1, -1, 6, -1, -1, -1, -1, -1, -1, -1, 7, -1, -1, -1, -1, -1, -1, -1, 8, -1, -1, -1, -1, -1, -1, -1, 9, -1, -1, -1, -1, -1, -1, -1, 10, -1, -1, -1, -1, -1, -1, -1, 11, -1, -1, -1, -1, -1, -1, -1, 12, -1, -1, -1, -1, -1, -1, -1, 13, -1, -1, -1, -1, -1, -1, -1, 14, -1, -1, -1, -1, -1, -1, -1, 15, -1, -1, -1, -1, -1, -1, -1, 16, -1, -1, -1, -1, -1, -1, -1, 17, -1, -1, -1, -1, -1, -1, -1, 18, -1, -1, -1, -1, -1, -1, -1, 19, -1, -1, -1, -1, -1, -1, -1, 20, -1, -1, -1, -1, -1, -1, -1, 21, -1, -1, -1, -1, -1, -1, -1, 22, -1, -1, -1, -1, -1, -1, -1, 23, -1, -1, -1, -1, -1, -1, -1, 24, -1, -1, -1, -1, -1, -1, -1, 25, -1, -1, -1, -1, -1, -1, -1, 26, -1, -1, -1, -1, -1, -1, -1, 27, -1, -1, -1, -1, -1, -1, -1, 28, -1, -1, -1, -1, -1, -1, -1, 29, -1, -1, -1, -1, -1, -1, -1, 30, -1, -1, -1, -1, -1, -1, -1, 31, -1, -1, -1, -1, -1, -1, -1, 32, -1, -1, -1, -1, -1, -1, -1, 33, -1, -1, -1, -1, -1, -1, -1, 34, -1, -1, -1, -1, -1, -1, -1, 35, -1, -1, -1, -1, -1, -1, -1, 36, -1, -1, -1, -1, -1, -1, -1, 37, -1, -1, -1, -1, -1, -1, -1, 38, -1, -1, -1, -1, -1, -1, -1, 39, -1, -1, -1, -1, -1, -1, -1, 40, -1, -1, -1, -1, -1, -1, -1, 41, -1, -1, -1, -1, -1, -1, -1, 42, -1, -1, -1, -1, -1, -1, -1, 43, -1, -1, -1, -1, -1, -1, -1, 44, -1, -1, -1, -1, -1, -1, -1, 45, -1, -1, -1, -1, -1, -1, -1, 46, -1, -1, -1, -1, -1, -1, -1, 47, -1, -1, -1, -1, -1, -1, -1, 48, -1, -1, -1, -1, -1, -1, -1, 49, -1, -1, -1, -1, -1, -1, -1, 50, -1, -1, -1, -1, -1, -1, -1, 51, -1, -1, -1, -1, -1, -1, -1, 52, -1, -1, -1, -1, -1, -1, -1, 53, -1, -1, -1, -1, -1, -1, -1, 54, -1, -1, -1, -1, -1, -1, -1, 55, -1, -1, -1, -1, -1, -1, -1, 56, -1, -1, -1, -1, -1, -1, -1, 57, -1, -1, -1, -1, -1, -1, -1, 58, -1, -1, -1, -1, -1, -1, -1, 59, -1, -1, -1, -1, -1, -1, -1, 60, -1, -1, -1, -1, -1, -1, -1, 61, -1, -1, -1, -1, -1, -1, -1, 62, -1, -1, -1, -1, -1, -1, -1, 63>}> : (vector<64xi8>, vector<64xi8>) -> vector<505xi8>
  "llvm.intr.masked.store"(%4099, %4097, %26) <{alignment = 1 : i32}> : (vector<505xi8>, !llvm.ptr, vector<505xi1>) -> ()
  %4100 = "llvm.getelementptr"(%136, %3760) <{elem_type = !llvm.array<2 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%3818, %4100) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i16, !llvm.ptr) -> ()
  %4101 = "llvm.getelementptr"(%4100) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3827, %4101) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i16, !llvm.ptr) -> ()
  %4102 = "llvm.getelementptr"(%4100) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3836, %4102) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i16, !llvm.ptr) -> ()
  %4103 = "llvm.getelementptr"(%4100) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 48>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3845, %4103) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i16, !llvm.ptr) -> ()
  %4104 = "llvm.getelementptr"(%4100) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3854, %4104) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i16, !llvm.ptr) -> ()
  %4105 = "llvm.getelementptr"(%4100) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 80>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3863, %4105) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i16, !llvm.ptr) -> ()
  %4106 = "llvm.getelementptr"(%4100) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 96>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3872, %4106) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i16, !llvm.ptr) -> ()
  %4107 = "llvm.getelementptr"(%4100) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 112>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3881, %4107) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i16, !llvm.ptr) -> ()
  %4108 = "llvm.getelementptr"(%4100) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3890, %4108) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i16, !llvm.ptr) -> ()
  %4109 = "llvm.getelementptr"(%4100) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 144>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3899, %4109) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i16, !llvm.ptr) -> ()
  %4110 = "llvm.getelementptr"(%4100) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 160>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3908, %4110) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i16, !llvm.ptr) -> ()
  %4111 = "llvm.getelementptr"(%4100) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 176>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3917, %4111) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i16, !llvm.ptr) -> ()
  %4112 = "llvm.getelementptr"(%4100) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 192>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3926, %4112) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i16, !llvm.ptr) -> ()
  %4113 = "llvm.getelementptr"(%4100) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 208>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3935, %4113) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i16, !llvm.ptr) -> ()
  %4114 = "llvm.getelementptr"(%4100) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 224>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3944, %4114) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i16, !llvm.ptr) -> ()
  %4115 = "llvm.getelementptr"(%4100) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 240>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3953, %4115) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i16, !llvm.ptr) -> ()
  %4116 = "llvm.getelementptr"(%4100) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 256>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3962, %4116) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i16, !llvm.ptr) -> ()
  %4117 = "llvm.getelementptr"(%4100) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 272>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3971, %4117) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i16, !llvm.ptr) -> ()
  %4118 = "llvm.getelementptr"(%4100) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 288>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3980, %4118) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i16, !llvm.ptr) -> ()
  %4119 = "llvm.getelementptr"(%4100) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 304>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3989, %4119) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i16, !llvm.ptr) -> ()
  %4120 = "llvm.getelementptr"(%4100) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 320>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3998, %4120) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i16, !llvm.ptr) -> ()
  %4121 = "llvm.getelementptr"(%4100) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 336>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%4007, %4121) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i16, !llvm.ptr) -> ()
  %4122 = "llvm.getelementptr"(%4100) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 352>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%4016, %4122) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i16, !llvm.ptr) -> ()
  %4123 = "llvm.getelementptr"(%4100) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 368>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%4025, %4123) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i16, !llvm.ptr) -> ()
  %4124 = "llvm.getelementptr"(%4100) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 384>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%4034, %4124) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i16, !llvm.ptr) -> ()
  %4125 = "llvm.getelementptr"(%4100) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 400>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%4043, %4125) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i16, !llvm.ptr) -> ()
  %4126 = "llvm.getelementptr"(%4100) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 416>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%4052, %4126) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i16, !llvm.ptr) -> ()
  %4127 = "llvm.getelementptr"(%4100) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 432>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%4061, %4127) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i16, !llvm.ptr) -> ()
  %4128 = "llvm.getelementptr"(%4100) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 448>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%4070, %4128) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i16, !llvm.ptr) -> ()
  %4129 = "llvm.getelementptr"(%4100) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 464>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%4079, %4129) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i16, !llvm.ptr) -> ()
  %4130 = "llvm.getelementptr"(%4100) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 480>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%4088, %4130) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i16, !llvm.ptr) -> ()
  %4131 = "llvm.getelementptr"(%4100) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 496>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%4096, %4131) <{alignment = 2 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i16, !llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%137) : (!llvm.ptr) -> ()
  %4132 = "llvm.add"(%3760, %88) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %4133 = "llvm.icmp"(%4132, %69) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%4133, %4132)[^bb79, ^bb80] <{loop_annotation = #llvm.loop_annotation<mustProgress = true>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb83(%4134: i64):  // 2 preds: ^bb79, ^bb87
  %4135 = "llvm.icmp"(%4134, %57) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%4135)[^bb85, ^bb84] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb84:  // pred: ^bb83
  "llvm.call"(%146, %146, %61) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_lane_point_dbl, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i32) -> ()
  "llvm.call"(%146, %146, %61) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_lane_point_dbl, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i32) -> ()
  "llvm.call"(%146, %146, %61) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_lane_point_dbl, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i32) -> ()
  "llvm.call"(%146, %146, %52) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_lane_point_dbl, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i32) -> ()
  "llvm.br"()[^bb85] : () -> ()
^bb85:  // 2 preds: ^bb83, ^bb84
  "llvm.intr.lifetime.start"(%147) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%148) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%149) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%150) : (!llvm.ptr) -> ()
  %4136 = "llvm.getelementptr"(%135, %4134) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %4137 = "llvm.load"(%4136) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi8>
  %4138 = "llvm.extractelement"(%4137, %66) : (vector<8xi8>, i64) -> i8
  %4139 = "llvm.icmp"(%4138, %53) <{predicate = 2 : i64}> : (i8, i8) -> i1
  %4140 = "llvm.intr.abs"(%4137) <{is_int_min_poison = false}> : (vector<8xi8>) -> vector<8xi8>
  %4141 = "llvm.extractelement"(%4140, %66) : (vector<8xi8>, i64) -> i8
  %4142 = "llvm.zext"(%4141) : (i8) -> i64
  %4143 = "llvm.getelementptr"(%138, %4142) <{elem_type = !llvm.array<1600 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %4144 = "llvm.getelementptr"(%4143) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 320>}> : (!llvm.ptr) -> !llvm.ptr
  %4145 = "llvm.select"(%4139, %4144, %4143) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, !llvm.ptr, !llvm.ptr) -> !llvm.ptr
  "llvm.store"(%4145, %147) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr, !llvm.ptr) -> ()
  %4146 = "llvm.select"(%4139, %4143, %4144) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, !llvm.ptr, !llvm.ptr) -> !llvm.ptr
  "llvm.store"(%4146, %148) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr, !llvm.ptr) -> ()
  %4147 = "llvm.select"(%4139, %92, %93) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i64, i64) -> i64
  %4148 = "llvm.getelementptr"(%4143, %4147) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%4148, %149) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr, !llvm.ptr) -> ()
  %4149 = "llvm.getelementptr"(%4143) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1280>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%4149, %150) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr, !llvm.ptr) -> ()
  %4150 = "llvm.extractelement"(%4137, %88) : (vector<8xi8>, i64) -> i8
  %4151 = "llvm.icmp"(%4150, %53) <{predicate = 2 : i64}> : (i8, i8) -> i1
  %4152 = "llvm.extractelement"(%4140, %88) : (vector<8xi8>, i64) -> i8
  %4153 = "llvm.zext"(%4152) : (i8) -> i64
  %4154 = "llvm.getelementptr"(%138, %4153) <{elem_type = !llvm.array<1600 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %4155 = "llvm.getelementptr"(%4154) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %4156 = "llvm.getelementptr"(%4154) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 328>}> : (!llvm.ptr) -> !llvm.ptr
  %4157 = "llvm.select"(%4151, %4156, %4155) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, !llvm.ptr, !llvm.ptr) -> !llvm.ptr
  "llvm.store"(%4157, %3732) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr, !llvm.ptr) -> ()
  %4158 = "llvm.select"(%4151, %4155, %4156) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, !llvm.ptr, !llvm.ptr) -> !llvm.ptr
  "llvm.store"(%4158, %3733) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr, !llvm.ptr) -> ()
  %4159 = "llvm.select"(%4151, %24, %23) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i64, i64) -> i64
  %4160 = "llvm.getelementptr"(%4154, %4159) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%4160, %3734) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr, !llvm.ptr) -> ()
  %4161 = "llvm.getelementptr"(%4154) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1288>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%4161, %3735) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr, !llvm.ptr) -> ()
  %4162 = "llvm.extractelement"(%4137, %89) : (vector<8xi8>, i64) -> i8
  %4163 = "llvm.icmp"(%4162, %53) <{predicate = 2 : i64}> : (i8, i8) -> i1
  %4164 = "llvm.extractelement"(%4140, %89) : (vector<8xi8>, i64) -> i8
  %4165 = "llvm.zext"(%4164) : (i8) -> i64
  %4166 = "llvm.getelementptr"(%138, %4165) <{elem_type = !llvm.array<1600 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %4167 = "llvm.getelementptr"(%4166) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %4168 = "llvm.getelementptr"(%4166) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 336>}> : (!llvm.ptr) -> !llvm.ptr
  %4169 = "llvm.select"(%4163, %4168, %4167) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, !llvm.ptr, !llvm.ptr) -> !llvm.ptr
  "llvm.store"(%4169, %3736) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr, !llvm.ptr) -> ()
  %4170 = "llvm.select"(%4163, %4167, %4168) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, !llvm.ptr, !llvm.ptr) -> !llvm.ptr
  "llvm.store"(%4170, %3737) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr, !llvm.ptr) -> ()
  %4171 = "llvm.select"(%4163, %22, %21) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i64, i64) -> i64
  %4172 = "llvm.getelementptr"(%4166, %4171) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%4172, %3738) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr, !llvm.ptr) -> ()
  %4173 = "llvm.getelementptr"(%4166) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1296>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%4173, %3739) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr, !llvm.ptr) -> ()
  %4174 = "llvm.extractelement"(%4137, %72) : (vector<8xi8>, i64) -> i8
  %4175 = "llvm.icmp"(%4174, %53) <{predicate = 2 : i64}> : (i8, i8) -> i1
  %4176 = "llvm.extractelement"(%4140, %72) : (vector<8xi8>, i64) -> i8
  %4177 = "llvm.zext"(%4176) : (i8) -> i64
  %4178 = "llvm.getelementptr"(%138, %4177) <{elem_type = !llvm.array<1600 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %4179 = "llvm.getelementptr"(%4178) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %4180 = "llvm.getelementptr"(%4178) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 344>}> : (!llvm.ptr) -> !llvm.ptr
  %4181 = "llvm.select"(%4175, %4180, %4179) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, !llvm.ptr, !llvm.ptr) -> !llvm.ptr
  "llvm.store"(%4181, %3740) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr, !llvm.ptr) -> ()
  %4182 = "llvm.select"(%4175, %4179, %4180) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, !llvm.ptr, !llvm.ptr) -> !llvm.ptr
  "llvm.store"(%4182, %3741) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr, !llvm.ptr) -> ()
  %4183 = "llvm.select"(%4175, %20, %19) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i64, i64) -> i64
  %4184 = "llvm.getelementptr"(%4178, %4183) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%4184, %3742) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr, !llvm.ptr) -> ()
  %4185 = "llvm.getelementptr"(%4178) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1304>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%4185, %3743) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr, !llvm.ptr) -> ()
  %4186 = "llvm.extractelement"(%4137, %68) : (vector<8xi8>, i64) -> i8
  %4187 = "llvm.icmp"(%4186, %53) <{predicate = 2 : i64}> : (i8, i8) -> i1
  %4188 = "llvm.extractelement"(%4140, %68) : (vector<8xi8>, i64) -> i8
  %4189 = "llvm.zext"(%4188) : (i8) -> i64
  %4190 = "llvm.getelementptr"(%138, %4189) <{elem_type = !llvm.array<1600 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %4191 = "llvm.getelementptr"(%4190) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %4192 = "llvm.getelementptr"(%4190) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 352>}> : (!llvm.ptr) -> !llvm.ptr
  %4193 = "llvm.select"(%4187, %4192, %4191) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, !llvm.ptr, !llvm.ptr) -> !llvm.ptr
  "llvm.store"(%4193, %3744) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr, !llvm.ptr) -> ()
  %4194 = "llvm.select"(%4187, %4191, %4192) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, !llvm.ptr, !llvm.ptr) -> !llvm.ptr
  "llvm.store"(%4194, %3745) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr, !llvm.ptr) -> ()
  %4195 = "llvm.select"(%4187, %18, %17) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i64, i64) -> i64
  %4196 = "llvm.getelementptr"(%4190, %4195) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%4196, %3746) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr, !llvm.ptr) -> ()
  %4197 = "llvm.getelementptr"(%4190) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1312>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%4197, %3747) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr, !llvm.ptr) -> ()
  %4198 = "llvm.extractelement"(%4137, %76) : (vector<8xi8>, i64) -> i8
  %4199 = "llvm.icmp"(%4198, %53) <{predicate = 2 : i64}> : (i8, i8) -> i1
  %4200 = "llvm.extractelement"(%4140, %76) : (vector<8xi8>, i64) -> i8
  %4201 = "llvm.zext"(%4200) : (i8) -> i64
  %4202 = "llvm.getelementptr"(%138, %4201) <{elem_type = !llvm.array<1600 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %4203 = "llvm.getelementptr"(%4202) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 40>}> : (!llvm.ptr) -> !llvm.ptr
  %4204 = "llvm.getelementptr"(%4202) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 360>}> : (!llvm.ptr) -> !llvm.ptr
  %4205 = "llvm.select"(%4199, %4204, %4203) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, !llvm.ptr, !llvm.ptr) -> !llvm.ptr
  "llvm.store"(%4205, %3748) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr, !llvm.ptr) -> ()
  %4206 = "llvm.select"(%4199, %4203, %4204) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, !llvm.ptr, !llvm.ptr) -> !llvm.ptr
  "llvm.store"(%4206, %3749) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr, !llvm.ptr) -> ()
  %4207 = "llvm.select"(%4199, %16, %15) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i64, i64) -> i64
  %4208 = "llvm.getelementptr"(%4202, %4207) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%4208, %3750) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr, !llvm.ptr) -> ()
  %4209 = "llvm.getelementptr"(%4202) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1320>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%4209, %3751) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr, !llvm.ptr) -> ()
  %4210 = "llvm.extractelement"(%4137, %78) : (vector<8xi8>, i64) -> i8
  %4211 = "llvm.icmp"(%4210, %53) <{predicate = 2 : i64}> : (i8, i8) -> i1
  %4212 = "llvm.extractelement"(%4140, %78) : (vector<8xi8>, i64) -> i8
  %4213 = "llvm.zext"(%4212) : (i8) -> i64
  %4214 = "llvm.getelementptr"(%138, %4213) <{elem_type = !llvm.array<1600 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %4215 = "llvm.getelementptr"(%4214) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 48>}> : (!llvm.ptr) -> !llvm.ptr
  %4216 = "llvm.getelementptr"(%4214) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 368>}> : (!llvm.ptr) -> !llvm.ptr
  %4217 = "llvm.select"(%4211, %4216, %4215) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, !llvm.ptr, !llvm.ptr) -> !llvm.ptr
  "llvm.store"(%4217, %3752) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr, !llvm.ptr) -> ()
  %4218 = "llvm.select"(%4211, %4215, %4216) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, !llvm.ptr, !llvm.ptr) -> !llvm.ptr
  "llvm.store"(%4218, %3753) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr, !llvm.ptr) -> ()
  %4219 = "llvm.select"(%4211, %14, %13) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i64, i64) -> i64
  %4220 = "llvm.getelementptr"(%4214, %4219) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%4220, %3754) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr, !llvm.ptr) -> ()
  %4221 = "llvm.getelementptr"(%4214) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1328>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%4221, %3755) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr, !llvm.ptr) -> ()
  %4222 = "llvm.extractelement"(%4137, %80) : (vector<8xi8>, i64) -> i8
  %4223 = "llvm.icmp"(%4222, %53) <{predicate = 2 : i64}> : (i8, i8) -> i1
  %4224 = "llvm.extractelement"(%4140, %80) : (vector<8xi8>, i64) -> i8
  %4225 = "llvm.zext"(%4224) : (i8) -> i64
  %4226 = "llvm.getelementptr"(%138, %4225) <{elem_type = !llvm.array<1600 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %4227 = "llvm.getelementptr"(%4226) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 56>}> : (!llvm.ptr) -> !llvm.ptr
  %4228 = "llvm.getelementptr"(%4226) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 376>}> : (!llvm.ptr) -> !llvm.ptr
  %4229 = "llvm.select"(%4223, %4228, %4227) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, !llvm.ptr, !llvm.ptr) -> !llvm.ptr
  "llvm.store"(%4229, %3756) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr, !llvm.ptr) -> ()
  %4230 = "llvm.select"(%4223, %4227, %4228) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, !llvm.ptr, !llvm.ptr) -> !llvm.ptr
  "llvm.store"(%4230, %3757) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr, !llvm.ptr) -> ()
  %4231 = "llvm.select"(%4223, %12, %11) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i64, i64) -> i64
  %4232 = "llvm.getelementptr"(%4226, %4231) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%4232, %3758) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr, !llvm.ptr) -> ()
  %4233 = "llvm.getelementptr"(%4226) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1336>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%4233, %3759) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr, !llvm.ptr) -> ()
  %4234 = "llvm.trunc"(%4134) <{overflowFlags = 3 : i32}> : (i64) -> i32
  %4235 = "llvm.and"(%4234, %52) : (i32, i32) -> i32
  %4236 = "llvm.icmp"(%4235, %61) <{predicate = 0 : i64}> : (i32, i32) -> i1
  %4237 = "llvm.xor"(%4235, %52) : (i32, i32) -> i32
  "llvm.call"(%146, %146, %147, %148, %149, %150, %69, %52, %61, %4237) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_lane_point_add_sel, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = read, argMem = readwrite, inaccessibleMem = none, errnoMem = read, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, i64, i32, i32, i32) -> ()
  "llvm.cond_br"(%4236)[^bb86, ^bb87] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb86:  // pred: ^bb85
  %4238 = "llvm.lshr"(%4134, %88) <{isExact}> : (i64, i64) -> i64
  %4239 = "llvm.and"(%4238, %10) : (i64, i64) -> i64
  %4240 = "llvm.getelementptr"(%136, %4239) <{elem_type = !llvm.array<16 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %4241 = "llvm.load"(%4240) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "short", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi16>
  %4242 = "llvm.extractelement"(%4241, %66) : (vector<8xi16>, i64) -> i16
  %4243 = "llvm.icmp"(%4242, %9) <{predicate = 2 : i64}> : (i16, i16) -> i1
  %4244 = "llvm.intr.abs"(%4241) <{is_int_min_poison = false}> : (vector<8xi16>) -> vector<8xi16>
  %4245 = "llvm.zext"(%4244) : (vector<8xi16>) -> vector<8xi32>
  %4246 = "llvm.mul"(%4245, %8) <{overflowFlags = 3 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %4247 = "llvm.extractelement"(%4246, %66) : (vector<8xi32>, i64) -> i32
  %4248 = "llvm.zext"(%4247) <{nonNeg}> : (i32) -> i64
  %4249 = "llvm.getelementptr"(%7, %4248) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %4250 = "llvm.select"(%4243, %76, %66) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i64, i64) -> i64
  %4251 = "llvm.getelementptr"(%4249, %4250) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%4251, %147) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr, !llvm.ptr) -> ()
  %4252 = "llvm.select"(%4243, %66, %76) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i64, i64) -> i64
  %4253 = "llvm.getelementptr"(%4249, %4252) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%4253, %148) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr, !llvm.ptr) -> ()
  %4254 = "llvm.select"(%4243, %28, %29) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i64, i64) -> i64
  %4255 = "llvm.getelementptr"(%4249, %4254) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%4255, %149) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr, !llvm.ptr) -> ()
  %4256 = "llvm.extractelement"(%4241, %88) : (vector<8xi16>, i64) -> i16
  %4257 = "llvm.icmp"(%4256, %9) <{predicate = 2 : i64}> : (i16, i16) -> i1
  %4258 = "llvm.extractelement"(%4246, %88) : (vector<8xi32>, i64) -> i32
  %4259 = "llvm.zext"(%4258) <{nonNeg}> : (i32) -> i64
  %4260 = "llvm.getelementptr"(%7, %4259) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %4261 = "llvm.select"(%4257, %76, %66) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i64, i64) -> i64
  %4262 = "llvm.getelementptr"(%4260, %4261) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%4262, %3732) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr, !llvm.ptr) -> ()
  %4263 = "llvm.select"(%4257, %66, %76) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i64, i64) -> i64
  %4264 = "llvm.getelementptr"(%4260, %4263) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%4264, %3733) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr, !llvm.ptr) -> ()
  %4265 = "llvm.select"(%4257, %28, %29) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i64, i64) -> i64
  %4266 = "llvm.getelementptr"(%4260, %4265) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%4266, %3734) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr, !llvm.ptr) -> ()
  %4267 = "llvm.extractelement"(%4241, %89) : (vector<8xi16>, i64) -> i16
  %4268 = "llvm.icmp"(%4267, %9) <{predicate = 2 : i64}> : (i16, i16) -> i1
  %4269 = "llvm.extractelement"(%4246, %89) : (vector<8xi32>, i64) -> i32
  %4270 = "llvm.zext"(%4269) <{nonNeg}> : (i32) -> i64
  %4271 = "llvm.getelementptr"(%7, %4270) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %4272 = "llvm.select"(%4268, %76, %66) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i64, i64) -> i64
  %4273 = "llvm.getelementptr"(%4271, %4272) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%4273, %3736) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr, !llvm.ptr) -> ()
  %4274 = "llvm.select"(%4268, %66, %76) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i64, i64) -> i64
  %4275 = "llvm.getelementptr"(%4271, %4274) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%4275, %3737) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr, !llvm.ptr) -> ()
  %4276 = "llvm.select"(%4268, %28, %29) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i64, i64) -> i64
  %4277 = "llvm.getelementptr"(%4271, %4276) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%4277, %3738) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr, !llvm.ptr) -> ()
  %4278 = "llvm.extractelement"(%4241, %72) : (vector<8xi16>, i64) -> i16
  %4279 = "llvm.icmp"(%4278, %9) <{predicate = 2 : i64}> : (i16, i16) -> i1
  %4280 = "llvm.extractelement"(%4246, %72) : (vector<8xi32>, i64) -> i32
  %4281 = "llvm.zext"(%4280) <{nonNeg}> : (i32) -> i64
  %4282 = "llvm.getelementptr"(%7, %4281) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %4283 = "llvm.select"(%4279, %76, %66) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i64, i64) -> i64
  %4284 = "llvm.getelementptr"(%4282, %4283) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%4284, %3740) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr, !llvm.ptr) -> ()
  %4285 = "llvm.select"(%4279, %66, %76) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i64, i64) -> i64
  %4286 = "llvm.getelementptr"(%4282, %4285) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%4286, %3741) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr, !llvm.ptr) -> ()
  %4287 = "llvm.select"(%4279, %28, %29) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i64, i64) -> i64
  %4288 = "llvm.getelementptr"(%4282, %4287) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%4288, %3742) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr, !llvm.ptr) -> ()
  %4289 = "llvm.extractelement"(%4241, %68) : (vector<8xi16>, i64) -> i16
  %4290 = "llvm.icmp"(%4289, %9) <{predicate = 2 : i64}> : (i16, i16) -> i1
  %4291 = "llvm.extractelement"(%4246, %68) : (vector<8xi32>, i64) -> i32
  %4292 = "llvm.zext"(%4291) <{nonNeg}> : (i32) -> i64
  %4293 = "llvm.getelementptr"(%7, %4292) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %4294 = "llvm.select"(%4290, %76, %66) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i64, i64) -> i64
  %4295 = "llvm.getelementptr"(%4293, %4294) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%4295, %3744) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr, !llvm.ptr) -> ()
  %4296 = "llvm.select"(%4290, %66, %76) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i64, i64) -> i64
  %4297 = "llvm.getelementptr"(%4293, %4296) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%4297, %3745) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr, !llvm.ptr) -> ()
  %4298 = "llvm.select"(%4290, %28, %29) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i64, i64) -> i64
  %4299 = "llvm.getelementptr"(%4293, %4298) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%4299, %3746) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr, !llvm.ptr) -> ()
  %4300 = "llvm.extractelement"(%4241, %76) : (vector<8xi16>, i64) -> i16
  %4301 = "llvm.icmp"(%4300, %9) <{predicate = 2 : i64}> : (i16, i16) -> i1
  %4302 = "llvm.extractelement"(%4246, %76) : (vector<8xi32>, i64) -> i32
  %4303 = "llvm.zext"(%4302) <{nonNeg}> : (i32) -> i64
  %4304 = "llvm.getelementptr"(%7, %4303) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %4305 = "llvm.select"(%4301, %76, %66) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i64, i64) -> i64
  %4306 = "llvm.getelementptr"(%4304, %4305) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%4306, %3748) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr, !llvm.ptr) -> ()
  %4307 = "llvm.select"(%4301, %66, %76) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i64, i64) -> i64
  %4308 = "llvm.getelementptr"(%4304, %4307) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%4308, %3749) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr, !llvm.ptr) -> ()
  %4309 = "llvm.select"(%4301, %28, %29) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i64, i64) -> i64
  %4310 = "llvm.getelementptr"(%4304, %4309) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%4310, %3750) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr, !llvm.ptr) -> ()
  %4311 = "llvm.extractelement"(%4241, %78) : (vector<8xi16>, i64) -> i16
  %4312 = "llvm.icmp"(%4311, %9) <{predicate = 2 : i64}> : (i16, i16) -> i1
  %4313 = "llvm.extractelement"(%4246, %78) : (vector<8xi32>, i64) -> i32
  %4314 = "llvm.zext"(%4313) <{nonNeg}> : (i32) -> i64
  %4315 = "llvm.getelementptr"(%7, %4314) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %4316 = "llvm.select"(%4312, %76, %66) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i64, i64) -> i64
  %4317 = "llvm.getelementptr"(%4315, %4316) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%4317, %3752) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr, !llvm.ptr) -> ()
  %4318 = "llvm.select"(%4312, %66, %76) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i64, i64) -> i64
  %4319 = "llvm.getelementptr"(%4315, %4318) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%4319, %3753) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr, !llvm.ptr) -> ()
  %4320 = "llvm.select"(%4312, %28, %29) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i64, i64) -> i64
  %4321 = "llvm.getelementptr"(%4315, %4320) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%4321, %3754) <{alignment = 16 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr, !llvm.ptr) -> ()
  %4322 = "llvm.extractelement"(%4241, %80) : (vector<8xi16>, i64) -> i16
  %4323 = "llvm.icmp"(%4322, %9) <{predicate = 2 : i64}> : (i16, i16) -> i1
  %4324 = "llvm.extractelement"(%4246, %80) : (vector<8xi32>, i64) -> i32
  %4325 = "llvm.zext"(%4324) <{nonNeg}> : (i32) -> i64
  %4326 = "llvm.getelementptr"(%7, %4325) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %4327 = "llvm.select"(%4323, %76, %66) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i64, i64) -> i64
  %4328 = "llvm.getelementptr"(%4326, %4327) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%4328, %3756) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr, !llvm.ptr) -> ()
  %4329 = "llvm.select"(%4323, %66, %76) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i64, i64) -> i64
  %4330 = "llvm.getelementptr"(%4326, %4329) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%4330, %3757) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr, !llvm.ptr) -> ()
  %4331 = "llvm.select"(%4323, %28, %29) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i64, i64) -> i64
  %4332 = "llvm.getelementptr"(%4326, %4331) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%4332, %3758) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, access_type = <id = "p1 long", members = {<#llvm.tbaa_type_desc<id = "any pointer", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, 0>}>, offset = 0>]}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%146, %146, %147, %148, %149, %150, %88, %61, %52, %61) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_ed25519_lane_point_add_sel, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = read, argMem = readwrite, inaccessibleMem = none, errnoMem = read, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, i64, i32, i32, i32) -> ()
  "llvm.br"()[^bb87] : () -> ()
^bb87:  // 2 preds: ^bb85, ^bb86
  "llvm.intr.lifetime.end"(%150) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%149) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%148) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%147) : (!llvm.ptr) -> ()
  %4333 = "llvm.add"(%4134, %6) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %4334 = "llvm.icmp"(%4134, %66) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%4334, %4333)[^bb88, ^bb83] <{loop_annotation = #llvm.loop_annotation<mustProgress = true>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb88:  // pred: ^bb87
  %4335 = "llvm.load"(%164) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %4336 = "llvm.getelementptr"(%164) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %4337 = "llvm.load"(%4336) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %4338 = "llvm.getelementptr"(%164) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %4339 = "llvm.load"(%4338) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %4340 = "llvm.getelementptr"(%164) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 192>}> : (!llvm.ptr) -> !llvm.ptr
  %4341 = "llvm.load"(%4340) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %4342 = "llvm.getelementptr"(%164) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 256>}> : (!llvm.ptr) -> !llvm.ptr
  %4343 = "llvm.load"(%4342) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %4344 = "llvm.load"(%3727) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %4345 = "llvm.load"(%3730) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %4346 = "llvm.getelementptr"(%146) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 768>}> : (!llvm.ptr) -> !llvm.ptr
  %4347 = "llvm.load"(%4346) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %4348 = "llvm.getelementptr"(%146) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 832>}> : (!llvm.ptr) -> !llvm.ptr
  %4349 = "llvm.load"(%4348) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %4350 = "llvm.getelementptr"(%146) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 896>}> : (!llvm.ptr) -> !llvm.ptr
  %4351 = "llvm.load"(%4350) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %4352 = "llvm.call_intrinsic"(%94, %4335, %4344) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4353 = "llvm.shl"(%4352, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4354 = "llvm.call_intrinsic"(%4353, %4335, %4345) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4355 = "llvm.call_intrinsic"(%4354, %4337, %4344) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4356 = "llvm.call_intrinsic"(%94, %4335, %4345) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4357 = "llvm.call_intrinsic"(%4356, %4337, %4344) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4358 = "llvm.shl"(%4357, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4359 = "llvm.call_intrinsic"(%4358, %4335, %4347) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4360 = "llvm.call_intrinsic"(%4359, %4337, %4345) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4361 = "llvm.call_intrinsic"(%4360, %4339, %4344) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4362 = "llvm.call_intrinsic"(%94, %4335, %4347) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4363 = "llvm.call_intrinsic"(%4362, %4337, %4345) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4364 = "llvm.call_intrinsic"(%4363, %4339, %4344) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4365 = "llvm.shl"(%4364, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4366 = "llvm.call_intrinsic"(%4365, %4335, %4349) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4367 = "llvm.call_intrinsic"(%4366, %4337, %4347) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4368 = "llvm.call_intrinsic"(%4367, %4339, %4345) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4369 = "llvm.call_intrinsic"(%4368, %4341, %4344) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4370 = "llvm.call_intrinsic"(%94, %4335, %4349) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4371 = "llvm.call_intrinsic"(%4370, %4337, %4347) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4372 = "llvm.call_intrinsic"(%4371, %4339, %4345) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4373 = "llvm.call_intrinsic"(%4372, %4341, %4344) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4374 = "llvm.shl"(%4373, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4375 = "llvm.call_intrinsic"(%4374, %4335, %4351) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4376 = "llvm.call_intrinsic"(%4375, %4337, %4349) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4377 = "llvm.call_intrinsic"(%4376, %4339, %4347) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4378 = "llvm.call_intrinsic"(%4377, %4341, %4345) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4379 = "llvm.call_intrinsic"(%4378, %4343, %4344) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4380 = "llvm.call_intrinsic"(%94, %4335, %4351) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4381 = "llvm.call_intrinsic"(%4380, %4337, %4349) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4382 = "llvm.call_intrinsic"(%4381, %4339, %4347) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4383 = "llvm.call_intrinsic"(%4382, %4341, %4345) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4384 = "llvm.call_intrinsic"(%4383, %4343, %4344) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4385 = "llvm.shl"(%4384, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4386 = "llvm.call_intrinsic"(%4385, %4337, %4351) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4387 = "llvm.call_intrinsic"(%4386, %4339, %4349) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4388 = "llvm.call_intrinsic"(%4387, %4341, %4347) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4389 = "llvm.call_intrinsic"(%4388, %4343, %4345) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4390 = "llvm.call_intrinsic"(%94, %4337, %4351) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4391 = "llvm.call_intrinsic"(%4390, %4339, %4349) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4392 = "llvm.call_intrinsic"(%4391, %4341, %4347) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4393 = "llvm.call_intrinsic"(%4392, %4343, %4345) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4394 = "llvm.shl"(%4393, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4395 = "llvm.call_intrinsic"(%4394, %4339, %4351) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4396 = "llvm.call_intrinsic"(%4395, %4341, %4349) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4397 = "llvm.call_intrinsic"(%4396, %4343, %4347) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4398 = "llvm.call_intrinsic"(%94, %4339, %4351) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4399 = "llvm.call_intrinsic"(%4398, %4341, %4349) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4400 = "llvm.call_intrinsic"(%4399, %4343, %4347) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4401 = "llvm.shl"(%4400, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4402 = "llvm.call_intrinsic"(%4401, %4341, %4351) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4403 = "llvm.call_intrinsic"(%4402, %4343, %4349) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4404 = "llvm.call_intrinsic"(%94, %4341, %4351) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4405 = "llvm.call_intrinsic"(%4404, %4343, %4349) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4406 = "llvm.shl"(%4405, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4407 = "llvm.call_intrinsic"(%4406, %4343, %4351) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4408 = "llvm.call_intrinsic"(%94, %4343, %4351) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4409 = "llvm.mul"(%4389, %103) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4410 = "llvm.call_intrinsic"(%4409, %4335, %4344) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4411 = "llvm.mul"(%4397, %103) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4412 = "llvm.add"(%4411, %4355) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4413 = "llvm.mul"(%4403, %103) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4414 = "llvm.add"(%4413, %4361) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4415 = "llvm.mul"(%4407, %103) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4416 = "llvm.add"(%4415, %4369) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4417 = "llvm.mul"(%4408, %102) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4418 = "llvm.add"(%4417, %4379) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4419 = "llvm.lshr"(%4410, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4420 = "llvm.lshr"(%4412, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4421 = "llvm.lshr"(%4414, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4422 = "llvm.lshr"(%4416, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4423 = "llvm.lshr"(%4418, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4424 = "llvm.and"(%4410, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4425 = "llvm.call_intrinsic"(%4424, %4423, %103) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4426 = "llvm.and"(%4412, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4427 = "llvm.and"(%4414, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4428 = "llvm.and"(%4416, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4429 = "llvm.and"(%4418, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4430 = "llvm.getelementptr"(%164) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 320>}> : (!llvm.ptr) -> !llvm.ptr
  %4431 = "llvm.load"(%4430) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %4432 = "llvm.getelementptr"(%164) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 384>}> : (!llvm.ptr) -> !llvm.ptr
  %4433 = "llvm.load"(%4432) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %4434 = "llvm.getelementptr"(%164) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 448>}> : (!llvm.ptr) -> !llvm.ptr
  %4435 = "llvm.load"(%4434) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %4436 = "llvm.getelementptr"(%164) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 512>}> : (!llvm.ptr) -> !llvm.ptr
  %4437 = "llvm.load"(%4436) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %4438 = "llvm.getelementptr"(%164) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 576>}> : (!llvm.ptr) -> !llvm.ptr
  %4439 = "llvm.load"(%4438) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %4440 = "llvm.call_intrinsic"(%94, %4431, %4344) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4441 = "llvm.shl"(%4440, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4442 = "llvm.call_intrinsic"(%4441, %4431, %4345) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4443 = "llvm.call_intrinsic"(%4442, %4433, %4344) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4444 = "llvm.call_intrinsic"(%94, %4431, %4345) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4445 = "llvm.call_intrinsic"(%4444, %4433, %4344) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4446 = "llvm.shl"(%4445, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4447 = "llvm.call_intrinsic"(%4446, %4431, %4347) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4448 = "llvm.call_intrinsic"(%4447, %4433, %4345) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4449 = "llvm.call_intrinsic"(%4448, %4435, %4344) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4450 = "llvm.call_intrinsic"(%94, %4431, %4347) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4451 = "llvm.call_intrinsic"(%4450, %4433, %4345) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4452 = "llvm.call_intrinsic"(%4451, %4435, %4344) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4453 = "llvm.shl"(%4452, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4454 = "llvm.call_intrinsic"(%4453, %4431, %4349) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4455 = "llvm.call_intrinsic"(%4454, %4433, %4347) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4456 = "llvm.call_intrinsic"(%4455, %4435, %4345) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4457 = "llvm.call_intrinsic"(%4456, %4437, %4344) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4458 = "llvm.call_intrinsic"(%94, %4431, %4349) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4459 = "llvm.call_intrinsic"(%4458, %4433, %4347) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4460 = "llvm.call_intrinsic"(%4459, %4435, %4345) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4461 = "llvm.call_intrinsic"(%4460, %4437, %4344) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4462 = "llvm.shl"(%4461, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4463 = "llvm.call_intrinsic"(%4462, %4431, %4351) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4464 = "llvm.call_intrinsic"(%4463, %4433, %4349) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4465 = "llvm.call_intrinsic"(%4464, %4435, %4347) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4466 = "llvm.call_intrinsic"(%4465, %4437, %4345) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4467 = "llvm.call_intrinsic"(%4466, %4439, %4344) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4468 = "llvm.call_intrinsic"(%94, %4431, %4351) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4469 = "llvm.call_intrinsic"(%4468, %4433, %4349) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4470 = "llvm.call_intrinsic"(%4469, %4435, %4347) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4471 = "llvm.call_intrinsic"(%4470, %4437, %4345) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4472 = "llvm.call_intrinsic"(%4471, %4439, %4344) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4473 = "llvm.shl"(%4472, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4474 = "llvm.call_intrinsic"(%4473, %4433, %4351) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4475 = "llvm.call_intrinsic"(%4474, %4435, %4349) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4476 = "llvm.call_intrinsic"(%4475, %4437, %4347) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4477 = "llvm.call_intrinsic"(%4476, %4439, %4345) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4478 = "llvm.call_intrinsic"(%94, %4433, %4351) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4479 = "llvm.call_intrinsic"(%4478, %4435, %4349) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4480 = "llvm.call_intrinsic"(%4479, %4437, %4347) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4481 = "llvm.call_intrinsic"(%4480, %4439, %4345) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4482 = "llvm.shl"(%4481, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4483 = "llvm.call_intrinsic"(%4482, %4435, %4351) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4484 = "llvm.call_intrinsic"(%4483, %4437, %4349) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4485 = "llvm.call_intrinsic"(%4484, %4439, %4347) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4486 = "llvm.call_intrinsic"(%94, %4435, %4351) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4487 = "llvm.call_intrinsic"(%4486, %4437, %4349) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4488 = "llvm.call_intrinsic"(%4487, %4439, %4347) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4489 = "llvm.shl"(%4488, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4490 = "llvm.call_intrinsic"(%4489, %4437, %4351) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4491 = "llvm.call_intrinsic"(%4490, %4439, %4349) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4492 = "llvm.call_intrinsic"(%94, %4437, %4351) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4493 = "llvm.call_intrinsic"(%4492, %4439, %4349) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4494 = "llvm.shl"(%4493, %95) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4495 = "llvm.call_intrinsic"(%4494, %4439, %4351) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4496 = "llvm.call_intrinsic"(%94, %4439, %4351) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52h.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4497 = "llvm.mul"(%4477, %103) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4498 = "llvm.call_intrinsic"(%4497, %4431, %4344) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4499 = "llvm.mul"(%4485, %103) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4500 = "llvm.add"(%4499, %4443) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4501 = "llvm.mul"(%4491, %103) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4502 = "llvm.add"(%4501, %4449) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4503 = "llvm.mul"(%4495, %103) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4504 = "llvm.add"(%4503, %4457) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4505 = "llvm.mul"(%4496, %102) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4506 = "llvm.add"(%4505, %4467) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4507 = "llvm.lshr"(%4498, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4508 = "llvm.lshr"(%4500, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4509 = "llvm.lshr"(%4502, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4510 = "llvm.lshr"(%4504, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4511 = "llvm.lshr"(%4506, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4512 = "llvm.and"(%4498, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4513 = "llvm.call_intrinsic"(%4512, %4511, %103) <{fastmathFlags = #llvm.fastmath<none>, intrin = "llvm.x86.avx512.vpmadd52l.uq.512", op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4514 = "llvm.and"(%4500, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4515 = "llvm.and"(%4502, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4516 = "llvm.and"(%4504, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4517 = "llvm.and"(%4506, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4518 = "llvm.add"(%4425, %108) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4519 = "llvm.load"(%146) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %4520 = "llvm.sub"(%4518, %4519) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4521 = "llvm.getelementptr"(%146) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %4522 = "llvm.load"(%4521) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %4523 = "llvm.getelementptr"(%146) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %4524 = "llvm.load"(%4523) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %4525 = "llvm.getelementptr"(%146) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 192>}> : (!llvm.ptr) -> !llvm.ptr
  %4526 = "llvm.load"(%4525) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %4527 = "llvm.getelementptr"(%146) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 256>}> : (!llvm.ptr) -> !llvm.ptr
  %4528 = "llvm.load"(%4527) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %4529 = "llvm.add"(%4513, %108) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4530 = "llvm.load"(%3728) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %4531 = "llvm.sub"(%4529, %4530) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4532 = "llvm.load"(%3731) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %4533 = "llvm.getelementptr"(%146) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 448>}> : (!llvm.ptr) -> !llvm.ptr
  %4534 = "llvm.load"(%4533) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %4535 = "llvm.getelementptr"(%146) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 512>}> : (!llvm.ptr) -> !llvm.ptr
  %4536 = "llvm.load"(%4535) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %4537 = "llvm.getelementptr"(%146) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 576>}> : (!llvm.ptr) -> !llvm.ptr
  %4538 = "llvm.load"(%4537) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, access_type = <id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, offset = 0>]}> : (!llvm.ptr) -> vector<8xi64>
  %4539 = "llvm.lshr"(%4520, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4540 = "llvm.add"(%4426, %109) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4541 = "llvm.add"(%4540, %4419) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4542 = "llvm.sub"(%4541, %4522) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4543 = "llvm.add"(%4542, %4539) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4544 = "llvm.and"(%4520, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4545 = "llvm.lshr"(%4543, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4546 = "llvm.add"(%4420, %109) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4547 = "llvm.add"(%4546, %4427) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4548 = "llvm.sub"(%4547, %4524) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4549 = "llvm.add"(%4548, %4545) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4550 = "llvm.and"(%4543, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4551 = "llvm.lshr"(%4549, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4552 = "llvm.add"(%4421, %109) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4553 = "llvm.add"(%4552, %4428) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4554 = "llvm.sub"(%4553, %4526) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4555 = "llvm.add"(%4554, %4551) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4556 = "llvm.and"(%4549, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4557 = "llvm.lshr"(%4555, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4558 = "llvm.add"(%4422, %109) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4559 = "llvm.add"(%4558, %4429) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4560 = "llvm.sub"(%4559, %4528) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4561 = "llvm.add"(%4560, %4557) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4562 = "llvm.and"(%4555, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4563 = "llvm.lshr"(%4561, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4564 = "llvm.mul"(%4563, %103) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4565 = "llvm.add"(%4564, %4544) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4566 = "llvm.and"(%4561, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4567 = "llvm.lshr"(%4565, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4568 = "llvm.add"(%4567, %4550) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4569 = "llvm.and"(%4565, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4570 = "llvm.lshr"(%4568, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4571 = "llvm.add"(%4570, %4556) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4572 = "llvm.lshr"(%4571, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4573 = "llvm.add"(%4572, %4562) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4574 = "llvm.lshr"(%4573, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4575 = "llvm.add"(%4574, %4566) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4576 = "llvm.lshr"(%4575, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4577 = "llvm.mul"(%4576, %103) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4578 = "llvm.add"(%4577, %4569) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4579 = "llvm.icmp"(%4578, %110) <{predicate = 0 : i64}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi1>
  %4580 = "llvm.or"(%4571, %4568) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4581 = "llvm.or"(%4580, %4573) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4582 = "llvm.or"(%4581, %4575) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4583 = "llvm.and"(%4582, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4584 = "llvm.or"(%4578, %4583) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4585 = "llvm.icmp"(%4584, %94) <{predicate = 0 : i64}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi1>
  %4586 = "llvm.and"(%4568, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4587 = "llvm.and"(%4586, %4571) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4588 = "llvm.and"(%4587, %4573) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4589 = "llvm.and"(%4588, %4575) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4590 = "llvm.icmp"(%4589, %96) <{predicate = 0 : i64}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi1>
  %4591 = "llvm.and"(%4590, %4579) : (vector<8xi1>, vector<8xi1>) -> vector<8xi1>
  %4592 = "llvm.or"(%4591, %4585) : (vector<8xi1>, vector<8xi1>) -> vector<8xi1>
  %4593 = "llvm.lshr"(%4531, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4594 = "llvm.add"(%4514, %109) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4595 = "llvm.add"(%4594, %4507) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4596 = "llvm.sub"(%4595, %4532) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4597 = "llvm.add"(%4596, %4593) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4598 = "llvm.and"(%4531, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4599 = "llvm.lshr"(%4597, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4600 = "llvm.add"(%4508, %109) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4601 = "llvm.add"(%4600, %4515) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4602 = "llvm.sub"(%4601, %4534) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4603 = "llvm.add"(%4602, %4599) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4604 = "llvm.and"(%4597, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4605 = "llvm.lshr"(%4603, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4606 = "llvm.add"(%4509, %109) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4607 = "llvm.add"(%4606, %4516) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4608 = "llvm.sub"(%4607, %4536) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4609 = "llvm.add"(%4608, %4605) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4610 = "llvm.and"(%4603, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4611 = "llvm.lshr"(%4609, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4612 = "llvm.add"(%4510, %109) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4613 = "llvm.add"(%4612, %4517) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4614 = "llvm.sub"(%4613, %4538) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4615 = "llvm.add"(%4614, %4611) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4616 = "llvm.and"(%4609, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4617 = "llvm.lshr"(%4615, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4618 = "llvm.mul"(%4617, %103) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4619 = "llvm.add"(%4618, %4598) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4620 = "llvm.and"(%4615, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4621 = "llvm.lshr"(%4619, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4622 = "llvm.add"(%4621, %4604) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4623 = "llvm.and"(%4619, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4624 = "llvm.lshr"(%4622, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4625 = "llvm.add"(%4624, %4610) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4626 = "llvm.lshr"(%4625, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4627 = "llvm.add"(%4626, %4616) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4628 = "llvm.lshr"(%4627, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4629 = "llvm.add"(%4628, %4620) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4630 = "llvm.lshr"(%4629, %104) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4631 = "llvm.mul"(%4630, %103) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4632 = "llvm.add"(%4631, %4623) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4633 = "llvm.icmp"(%4632, %110) <{predicate = 0 : i64}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi1>
  %4634 = "llvm.or"(%4625, %4622) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4635 = "llvm.or"(%4634, %4627) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4636 = "llvm.or"(%4635, %4629) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4637 = "llvm.and"(%4636, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4638 = "llvm.or"(%4632, %4637) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4639 = "llvm.icmp"(%4638, %94) <{predicate = 0 : i64}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi1>
  %4640 = "llvm.and"(%4622, %96) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4641 = "llvm.and"(%4640, %4625) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4642 = "llvm.and"(%4641, %4627) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4643 = "llvm.and"(%4642, %4629) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %4644 = "llvm.icmp"(%4643, %96) <{predicate = 0 : i64}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi1>
  %4645 = "llvm.and"(%4644, %4633) : (vector<8xi1>, vector<8xi1>) -> vector<8xi1>
  %4646 = "llvm.or"(%4645, %4639) : (vector<8xi1>, vector<8xi1>) -> vector<8xi1>
  %4647 = "llvm.and"(%4592, %4646) : (vector<8xi1>, vector<8xi1>) -> vector<8xi1>
  %4648 = "llvm.bitcast"(%4647) : (vector<8xi1>) -> i8
  %4649 = "llvm.zext"(%4648) : (i8) -> i32
  "llvm.intr.lifetime.end"(%146) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%139) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%138) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%136) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%135) : (!llvm.ptr) -> ()
  %4650 = "llvm.icmp"(%arg6, %69) <{predicate = 6 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%4650, %66)[^bb97, ^bb89] <{operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i64) -> ()
^bb89:  // pred: ^bb88
  %4651 = "llvm.icmp"(%arg6, %85) <{predicate = 6 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%4651, %66)[^bb94, ^bb90] <{operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i64) -> ()
^bb90:  // pred: ^bb89
  %4652 = "llvm.and"(%arg6, %62) : (i64, i64) -> i64
  %4653 = "llvm.and"(%arg6, %5) : (i64, i64) -> i64
  %4654 = "llvm.insertelement"(%114, %4649, %66) : (vector<16xi32>, i32, i64) -> vector<16xi32>
  %4655 = "llvm.shufflevector"(%4654, %114) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<16xi32>, vector<16xi32>) -> vector<16xi32>
  %4656 = "llvm.insertelement"(%114, %2040, %66) : (vector<16xi32>, i32, i64) -> vector<16xi32>
  %4657 = "llvm.shufflevector"(%4656, %114) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<16xi32>, vector<16xi32>) -> vector<16xi32>
  "llvm.br"(%66, %116)[^bb91] : (i64, vector<16xi32>) -> ()
^bb91(%4658: i64, %4659: vector<16xi32>):  // 2 preds: ^bb90, ^bb91
  %4660 = "llvm.add"(%4659, %117) <{overflowFlags = 0 : i32}> : (vector<16xi32>, vector<16xi32>) -> vector<16xi32>
  %4661 = "llvm.add"(%4659, %123) <{overflowFlags = 0 : i32}> : (vector<16xi32>, vector<16xi32>) -> vector<16xi32>
  %4662 = "llvm.add"(%4659, %4) <{overflowFlags = 0 : i32}> : (vector<16xi32>, vector<16xi32>) -> vector<16xi32>
  %4663 = "llvm.shl"(%118, %4659) <{overflowFlags = 2 : i32}> : (vector<16xi32>, vector<16xi32>) -> vector<16xi32>
  %4664 = "llvm.shl"(%118, %4660) <{overflowFlags = 2 : i32}> : (vector<16xi32>, vector<16xi32>) -> vector<16xi32>
  %4665 = "llvm.shl"(%118, %4661) <{overflowFlags = 2 : i32}> : (vector<16xi32>, vector<16xi32>) -> vector<16xi32>
  %4666 = "llvm.shl"(%118, %4662) <{overflowFlags = 2 : i32}> : (vector<16xi32>, vector<16xi32>) -> vector<16xi32>
  %4667 = "llvm.and"(%4663, %4657) : (vector<16xi32>, vector<16xi32>) -> vector<16xi32>
  %4668 = "llvm.and"(%4664, %4657) : (vector<16xi32>, vector<16xi32>) -> vector<16xi32>
  %4669 = "llvm.and"(%4665, %4657) : (vector<16xi32>, vector<16xi32>) -> vector<16xi32>
  %4670 = "llvm.and"(%4666, %4657) : (vector<16xi32>, vector<16xi32>) -> vector<16xi32>
  %4671 = "llvm.icmp"(%4667, %115) <{predicate = 1 : i64}> : (vector<16xi32>, vector<16xi32>) -> vector<16xi1>
  %4672 = "llvm.icmp"(%4668, %115) <{predicate = 1 : i64}> : (vector<16xi32>, vector<16xi32>) -> vector<16xi1>
  %4673 = "llvm.icmp"(%4669, %115) <{predicate = 1 : i64}> : (vector<16xi32>, vector<16xi32>) -> vector<16xi1>
  %4674 = "llvm.icmp"(%4670, %115) <{predicate = 1 : i64}> : (vector<16xi32>, vector<16xi32>) -> vector<16xi1>
  %4675 = "llvm.and"(%4663, %4655) : (vector<16xi32>, vector<16xi32>) -> vector<16xi32>
  %4676 = "llvm.and"(%4664, %4655) : (vector<16xi32>, vector<16xi32>) -> vector<16xi32>
  %4677 = "llvm.and"(%4665, %4655) : (vector<16xi32>, vector<16xi32>) -> vector<16xi32>
  %4678 = "llvm.and"(%4666, %4655) : (vector<16xi32>, vector<16xi32>) -> vector<16xi32>
  %4679 = "llvm.icmp"(%4675, %115) <{predicate = 0 : i64}> : (vector<16xi32>, vector<16xi32>) -> vector<16xi1>
  %4680 = "llvm.icmp"(%4676, %115) <{predicate = 0 : i64}> : (vector<16xi32>, vector<16xi32>) -> vector<16xi1>
  %4681 = "llvm.icmp"(%4677, %115) <{predicate = 0 : i64}> : (vector<16xi32>, vector<16xi32>) -> vector<16xi1>
  %4682 = "llvm.icmp"(%4678, %115) <{predicate = 0 : i64}> : (vector<16xi32>, vector<16xi32>) -> vector<16xi1>
  %4683 = "llvm.select"(%4679, %3, %115) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<16xi1>, vector<16xi32>, vector<16xi32>) -> vector<16xi32>
  %4684 = "llvm.select"(%4680, %3, %115) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<16xi1>, vector<16xi32>, vector<16xi32>) -> vector<16xi32>
  %4685 = "llvm.select"(%4681, %3, %115) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<16xi1>, vector<16xi32>, vector<16xi32>) -> vector<16xi32>
  %4686 = "llvm.select"(%4682, %3, %115) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<16xi1>, vector<16xi32>, vector<16xi32>) -> vector<16xi32>
  %4687 = "llvm.getelementptr"(%arg5, %4658) <{elem_type = !llvm.array<4 x i8>, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %4688 = "llvm.getelementptr"(%4687) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %4689 = "llvm.getelementptr"(%4687) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %4690 = "llvm.getelementptr"(%4687) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 192>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.intr.masked.store"(%4683, %4687, %4671) <{alignment = 4 : i32}> : (vector<16xi32>, !llvm.ptr, vector<16xi1>) -> ()
  "llvm.intr.masked.store"(%4684, %4688, %4672) <{alignment = 4 : i32}> : (vector<16xi32>, !llvm.ptr, vector<16xi1>) -> ()
  "llvm.intr.masked.store"(%4685, %4689, %4673) <{alignment = 4 : i32}> : (vector<16xi32>, !llvm.ptr, vector<16xi1>) -> ()
  "llvm.intr.masked.store"(%4686, %4690, %4674) <{alignment = 4 : i32}> : (vector<16xi32>, !llvm.ptr, vector<16xi1>) -> ()
  %4691 = "llvm.add"(%4658, %85) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %4692 = "llvm.add"(%4659, %2) <{overflowFlags = 0 : i32}> : (vector<16xi32>, vector<16xi32>) -> vector<16xi32>
  %4693 = "llvm.icmp"(%4691, %4653) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%4693, %4691, %4692)[^bb92, ^bb91] <{loop_annotation = #llvm.loop_annotation<unroll = <runtimeDisable = true>, mustProgress = true, isVectorized = true>, operandSegmentSizes = array<i32: 1, 0, 2>}> : (i1, i64, vector<16xi32>) -> ()
^bb92:  // pred: ^bb91
  %4694 = "llvm.icmp"(%arg6, %4653) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%4694)[^bb98, ^bb93] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb93:  // pred: ^bb92
  %4695 = "llvm.icmp"(%4652, %66) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%4695, %4653, %4653)[^bb97, ^bb94] <{branch_weights = array<i32: 8, 56>, operandSegmentSizes = array<i32: 1, 1, 1>}> : (i1, i64, i64) -> ()
^bb94(%4696: i64):  // 2 preds: ^bb89, ^bb93
  %4697 = "llvm.and"(%arg6, %124) : (i64, i64) -> i64
  %4698 = "llvm.insertelement"(%47, %4649, %66) : (vector<8xi32>, i32, i64) -> vector<8xi32>
  %4699 = "llvm.shufflevector"(%4698, %47) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %4700 = "llvm.insertelement"(%47, %2040, %66) : (vector<8xi32>, i32, i64) -> vector<8xi32>
  %4701 = "llvm.shufflevector"(%4700, %47) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %4702 = "llvm.trunc"(%4696) <{overflowFlags = 0 : i32}> : (i64) -> i32
  %4703 = "llvm.insertelement"(%47, %4702, %66) : (vector<8xi32>, i32, i64) -> vector<8xi32>
  %4704 = "llvm.shufflevector"(%4703, %47) <{mask = array<i32: 0, 0, 0, 0, 0, 0, 0, 0>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %4705 = "llvm.or"(%4704, %46) <{isDisjoint}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  "llvm.br"(%4696, %4705)[^bb95] : (i64, vector<8xi32>) -> ()
^bb95(%4706: i64, %4707: vector<8xi32>):  // 2 preds: ^bb94, ^bb95
  %4708 = "llvm.shl"(%45, %4707) <{overflowFlags = 2 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %4709 = "llvm.and"(%4708, %4701) : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %4710 = "llvm.icmp"(%4709, %44) <{predicate = 1 : i64}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi1>
  %4711 = "llvm.and"(%4708, %4699) : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %4712 = "llvm.icmp"(%4711, %44) <{predicate = 0 : i64}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi1>
  %4713 = "llvm.select"(%4712, %1, %44) <{fastmathFlags = #llvm.fastmath<none>}> : (vector<8xi1>, vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %4714 = "llvm.getelementptr"(%arg5, %4706) <{elem_type = !llvm.array<4 x i8>, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.intr.masked.store"(%4713, %4714, %4710) <{alignment = 4 : i32}> : (vector<8xi32>, !llvm.ptr, vector<8xi1>) -> ()
  %4715 = "llvm.add"(%4706, %69) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %4716 = "llvm.add"(%4707, %39) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %4717 = "llvm.icmp"(%4715, %4697) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%4717, %4715, %4716)[^bb96, ^bb95] <{loop_annotation = #llvm.loop_annotation<unroll = <runtimeDisable = true>, mustProgress = true, isVectorized = true>, operandSegmentSizes = array<i32: 1, 0, 2>}> : (i1, i64, vector<8xi32>) -> ()
^bb96:  // pred: ^bb95
  %4718 = "llvm.icmp"(%arg6, %4697) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%4718, %4697)[^bb98, ^bb97] <{operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb97(%4719: i64):  // 3 preds: ^bb88, ^bb93, ^bb96
  "llvm.br"(%4719)[^bb99] : (i64) -> ()
^bb98:  // 3 preds: ^bb92, ^bb96, ^bb101
  "llvm.intr.lifetime.end"(%167) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%166) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%165) : (!llvm.ptr) -> ()
  "llvm.br"()[^bb102] : () -> ()
^bb99(%4720: i64):  // 2 preds: ^bb97, ^bb101
  %4721 = "llvm.trunc"(%4720) <{overflowFlags = 0 : i32}> : (i64) -> i32
  %4722 = "llvm.shl"(%52, %4721) <{overflowFlags = 2 : i32}> : (i32, i32) -> i32
  %4723 = "llvm.and"(%4722, %2040) : (i32, i32) -> i32
  %4724 = "llvm.icmp"(%4723, %61) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%4724)[^bb101, ^bb100] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb100:  // pred: ^bb99
  %4725 = "llvm.and"(%4722, %4649) : (i32, i32) -> i32
  %4726 = "llvm.icmp"(%4725, %61) <{predicate = 0 : i64}> : (i32, i32) -> i1
  %4727 = "llvm.select"(%4726, %0, %61) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i32, i32) -> i32
  %4728 = "llvm.getelementptr"(%arg5, %4720) <{elem_type = !llvm.array<4 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%4727, %4728) <{alignment = 4 : i64, ordering = 0 : i64, tbaa = [#llvm.tbaa_tag<base_type = <id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, access_type = <id = "int", members = {<#llvm.tbaa_type_desc<id = "omnipotent char", members = {<#llvm.tbaa_root<id = "Simple C/C++ TBAA">, 0>}>, 0>}>, offset = 0>]}> : (i32, !llvm.ptr) -> ()
  "llvm.br"()[^bb101] : () -> ()
^bb101:  // 2 preds: ^bb99, ^bb100
  %4729 = "llvm.add"(%4720, %88) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %4730 = "llvm.icmp"(%4729, %arg6) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%4730, %4729)[^bb98, ^bb99] <{loop_annotation = #llvm.loop_annotation<unroll = <runtimeDisable = true>, mustProgress = true, isVectorized = true>, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb102:  // 2 preds: ^bb52, ^bb98
  "llvm.intr.lifetime.end"(%164) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%163) : (!llvm.ptr) -> ()
  "llvm.br"()[^bb103] : () -> ()
^bb103:  // 2 preds: ^bb37, ^bb102
  "llvm.intr.lifetime.end"(%162) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%161) : (!llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()

    with
      @fd_ed25519_lane_base_table := Firedancer.Lane.Mlir.fd_ed25519_lane_base_table,
      @verify_x8.identity := Firedancer.Lane.Mlir.verify_x8_identity,
      @fd_ed25519_lane_bcast_fe := Firedancer.Lane.Mlir.fd_ed25519_lane_bcast_fe,
      @fd_ed25519_lane_bcast_fe := Firedancer.Lane.Mlir.fd_ed25519_lane_bcast_fe,
      @fd_ed25519_lane_pow22523_2 := Firedancer.Lane.Mlir.fd_ed25519_lane_pow22523_2,
      @fd_ed25519_lane_small_order := Firedancer.Lane.Mlir.fd_ed25519_lane_small_order,
      @fd_ed25519_lane_small_order := Firedancer.Lane.Mlir.fd_ed25519_lane_small_order,
      @fd_sha512_private_batch_avx512 := batch,
      @fd_sha512_private_batch_avx512 := batch,
      @fd_sha512_init := Firedancer.Lane.Mlir.fd_sha512_init,
      @fd_sha512_append := Firedancer.Lane.Mlir.fd_sha512_append,
      @fd_sha512_append := Firedancer.Lane.Mlir.fd_sha512_append,
      @fd_sha512_append := Firedancer.Lane.Mlir.fd_sha512_append,
      @fd_sha512_fini := Firedancer.Lane.Mlir.fd_sha512_fini,
      @fd_curve25519_scalar_reduce := Firedancer.Lane.Mlir.fd_curve25519_scalar_reduce,
      @fd_ed25519_lane_bcast_fe := Firedancer.Lane.Mlir.fd_ed25519_lane_bcast_fe,
      @fd_ed25519_lane_point_dbl := Firedancer.Lane.Mlir.fd_ed25519_lane_point_dbl,
      @fd_ed25519_lane_point_add := Firedancer.Lane.Mlir.fd_ed25519_lane_point_add,
      @fd_ed25519_lane_point_dbl := Firedancer.Lane.Mlir.fd_ed25519_lane_point_dbl,
      @fd_ed25519_lane_point_add := Firedancer.Lane.Mlir.fd_ed25519_lane_point_add,
      @fd_ed25519_lane_point_dbl := Firedancer.Lane.Mlir.fd_ed25519_lane_point_dbl,
      @fd_ed25519_lane_point_add := Firedancer.Lane.Mlir.fd_ed25519_lane_point_add,
      @fd_ed25519_lane_point_dbl := Firedancer.Lane.Mlir.fd_ed25519_lane_point_dbl,
      @fd_ed25519_lane_point_dbl := Firedancer.Lane.Mlir.fd_ed25519_lane_point_dbl,
      @fd_ed25519_lane_point_dbl := Firedancer.Lane.Mlir.fd_ed25519_lane_point_dbl,
      @fd_ed25519_lane_point_dbl := Firedancer.Lane.Mlir.fd_ed25519_lane_point_dbl,
      @fd_ed25519_lane_point_dbl := Firedancer.Lane.Mlir.fd_ed25519_lane_point_dbl,
      @fd_ed25519_lane_point_add_sel := Firedancer.Lane.Mlir.fd_ed25519_lane_point_add_sel,
      @fd_ed25519_lane_point_add_sel := Firedancer.Lane.Mlir.fd_ed25519_lane_point_add_sel

end

end Firedancer.Lane.Mlir
