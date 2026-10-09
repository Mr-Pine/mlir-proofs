module

-- build/llvm23/mlir_canonicalized/avx512/op/fd_ed25519_point_neg.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

namespace MLIR.Firedancer.Avx512

@[expose] public section

mlir_def fd_ed25519_point_neg :=
#tbaa_root = #llvm.tbaa_root<id = "Simple C/C++ TBAA">
#tbaa_type_desc = #llvm.tbaa_type_desc<id = "omnipotent char", members = {<#tbaa_root, 0>}>
#tbaa_tag = #llvm.tbaa_tag<base_type = #tbaa_type_desc, access_type = #tbaa_type_desc, offset = 0>
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nofree, llvm.nonnull, llvm.noundef, llvm.returned, llvm.writeonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<ptr (ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", ["min-legal-vector-width", "512"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "icelake-server"]], res_attrs = [{llvm.nonnull, llvm.noundef}], sym_name = "fd_ed25519_point_neg", target_cpu = "icelake-server", target_features = #llvm.target_features<["+adx", "+aes", "+avx", "+avx2", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+pclmul", "+pconfig", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdrnd", "+rdseed", "+sahf", "+sgx", "+sha", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves"]>, unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg127: !llvm.ptr, %arg128: !llvm.ptr):
  %2947 = "llvm.mlir.constant"() <{value = dense<[8796093022207, 8796093022207, 8796093022207, 8796093022207, 1099511627775, 1099511627775, 1099511627775, 1099511627775]> : vector<8xi64>}> : () -> vector<8xi64>
  %2948 = "llvm.mlir.constant"() <{value = dense<8796093022207> : vector<8xi64>}> : () -> vector<8xi64>
  %2949 = "llvm.mlir.constant"() <{value = 19 : i64}> : () -> i64
  %2950 = "llvm.mlir.constant"() <{value = dense<[43, 43, 43, 43, 40, 40, 40, 40]> : vector<8xi64>}> : () -> vector<8xi64>
  %2951 = "llvm.mlir.constant"() <{value = dense<43> : vector<8xi64>}> : () -> vector<8xi64>
  %2952 = "llvm.mlir.constant"() <{value = 2199023255550 : i64}> : () -> i64
  %2953 = "llvm.mlir.constant"() <{value = 7 : i32}> : () -> i32
  %2954 = "llvm.mlir.constant"() <{value = 6 : i32}> : () -> i32
  %2955 = "llvm.mlir.constant"() <{value = 5 : i32}> : () -> i32
  %2956 = "llvm.mlir.constant"() <{value = 4 : i32}> : () -> i32
  %2957 = "llvm.mlir.constant"() <{value = 3 : i32}> : () -> i32
  %2958 = "llvm.mlir.constant"() <{value = 2 : i32}> : () -> i32
  %2959 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %2960 = "llvm.mlir.constant"() <{value = 17592186044414 : i64}> : () -> i64
  %2961 = "llvm.mlir.poison"() : () -> i64
  %2962 = "llvm.mlir.constant"() <{value = 17592186044378 : i64}> : () -> i64
  %2963 = "llvm.mlir.undef"() : () -> vector<8xi64>
  %2964 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %2965 = "llvm.insertelement"(%2963, %2962, %2964) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2966 = "llvm.insertelement"(%2965, %2961, %2959) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2967 = "llvm.insertelement"(%2966, %2961, %2958) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2968 = "llvm.insertelement"(%2967, %2962, %2957) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2969 = "llvm.insertelement"(%2968, %2960, %2956) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2970 = "llvm.insertelement"(%2969, %2961, %2955) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2971 = "llvm.insertelement"(%2970, %2961, %2954) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2972 = "llvm.insertelement"(%2971, %2960, %2953) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2973 = "llvm.insertelement"(%2963, %2960, %2964) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2974 = "llvm.insertelement"(%2973, %2961, %2959) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2975 = "llvm.insertelement"(%2974, %2961, %2958) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2976 = "llvm.insertelement"(%2975, %2960, %2957) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2977 = "llvm.insertelement"(%2976, %2960, %2956) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2978 = "llvm.insertelement"(%2977, %2961, %2955) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2979 = "llvm.insertelement"(%2978, %2961, %2954) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2980 = "llvm.insertelement"(%2979, %2960, %2953) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2981 = "llvm.insertelement"(%2963, %2960, %2964) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2982 = "llvm.insertelement"(%2981, %2961, %2959) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2983 = "llvm.insertelement"(%2982, %2961, %2958) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2984 = "llvm.insertelement"(%2983, %2960, %2957) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2985 = "llvm.insertelement"(%2984, %2952, %2956) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2986 = "llvm.insertelement"(%2985, %2961, %2955) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2987 = "llvm.insertelement"(%2986, %2961, %2954) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2988 = "llvm.insertelement"(%2987, %2952, %2953) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2989 = "llvm.insertelement"(%2963, %2961, %2964) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2990 = "llvm.insertelement"(%2989, %2961, %2959) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2991 = "llvm.insertelement"(%2990, %2961, %2958) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2992 = "llvm.insertelement"(%2991, %2961, %2957) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2993 = "llvm.insertelement"(%2992, %2949, %2956) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2994 = "llvm.insertelement"(%2993, %2949, %2955) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2995 = "llvm.insertelement"(%2994, %2949, %2954) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2996 = "llvm.insertelement"(%2995, %2949, %2953) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2997 = "llvm.load"(%arg128) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %2998 = "llvm.getelementptr"(%arg128) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %2999 = "llvm.load"(%2998) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %3000 = "llvm.getelementptr"(%arg128) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %3001 = "llvm.load"(%3000) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %3002 = "llvm.sub"(%2972, %2997) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3003 = "llvm.shufflevector"(%3002, %2997) <{mask = array<i32: 0, 9, 10, 3, 4, 13, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%3003, %arg127) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %3004 = "llvm.load"(%2998) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %3005 = "llvm.sub"(%2980, %2999) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3006 = "llvm.shufflevector"(%3005, %3004) <{mask = array<i32: 0, 9, 10, 3, 4, 13, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3007 = "llvm.getelementptr"(%arg127) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%3006, %3007) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %3008 = "llvm.load"(%3000) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %3009 = "llvm.sub"(%2988, %3001) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3010 = "llvm.shufflevector"(%3009, %3008) <{mask = array<i32: 0, 9, 10, 3, 4, 13, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3011 = "llvm.getelementptr"(%arg127) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %3012 = "llvm.lshr"(%3003, %2951) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3013 = "llvm.lshr"(%3006, %2951) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3014 = "llvm.lshr"(%3010, %2950) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3015 = "llvm.mul"(%3014, %2996) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3016 = "llvm.and"(%3003, %2948) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3017 = "llvm.shufflevector"(%3015, %3014) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3018 = "llvm.add"(%3017, %3016) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%3018, %arg127) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %3019 = "llvm.and"(%3006, %2948) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3020 = "llvm.add"(%3019, %3012) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%3020, %3007) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %3021 = "llvm.and"(%3010, %2947) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3022 = "llvm.add"(%3021, %3013) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%3022, %3011) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.return"(%arg127) : (!llvm.ptr) -> ()
}) : () -> ()

end

end MLIR.Firedancer.Avx512
