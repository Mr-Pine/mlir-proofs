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
^bb0(%arg125: !llvm.ptr, %arg126: !llvm.ptr):
  %2937 = "llvm.mlir.constant"() <{value = dense<[8796093022207, 8796093022207, 8796093022207, 8796093022207, 1099511627775, 1099511627775, 1099511627775, 1099511627775]> : vector<8xi64>}> : () -> vector<8xi64>
  %2938 = "llvm.mlir.constant"() <{value = dense<8796093022207> : vector<8xi64>}> : () -> vector<8xi64>
  %2939 = "llvm.mlir.constant"() <{value = 19 : i64}> : () -> i64
  %2940 = "llvm.mlir.constant"() <{value = dense<[43, 43, 43, 43, 40, 40, 40, 40]> : vector<8xi64>}> : () -> vector<8xi64>
  %2941 = "llvm.mlir.constant"() <{value = dense<43> : vector<8xi64>}> : () -> vector<8xi64>
  %2942 = "llvm.mlir.constant"() <{value = 2199023255550 : i64}> : () -> i64
  %2943 = "llvm.mlir.constant"() <{value = 7 : i32}> : () -> i32
  %2944 = "llvm.mlir.constant"() <{value = 6 : i32}> : () -> i32
  %2945 = "llvm.mlir.constant"() <{value = 5 : i32}> : () -> i32
  %2946 = "llvm.mlir.constant"() <{value = 4 : i32}> : () -> i32
  %2947 = "llvm.mlir.constant"() <{value = 3 : i32}> : () -> i32
  %2948 = "llvm.mlir.constant"() <{value = 2 : i32}> : () -> i32
  %2949 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %2950 = "llvm.mlir.constant"() <{value = 17592186044414 : i64}> : () -> i64
  %2951 = "llvm.mlir.poison"() : () -> i64
  %2952 = "llvm.mlir.constant"() <{value = 17592186044378 : i64}> : () -> i64
  %2953 = "llvm.mlir.undef"() : () -> vector<8xi64>
  %2954 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %2955 = "llvm.insertelement"(%2953, %2952, %2954) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2956 = "llvm.insertelement"(%2955, %2951, %2949) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2957 = "llvm.insertelement"(%2956, %2951, %2948) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2958 = "llvm.insertelement"(%2957, %2952, %2947) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2959 = "llvm.insertelement"(%2958, %2950, %2946) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2960 = "llvm.insertelement"(%2959, %2951, %2945) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2961 = "llvm.insertelement"(%2960, %2951, %2944) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2962 = "llvm.insertelement"(%2961, %2950, %2943) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2963 = "llvm.insertelement"(%2953, %2950, %2954) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2964 = "llvm.insertelement"(%2963, %2951, %2949) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2965 = "llvm.insertelement"(%2964, %2951, %2948) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2966 = "llvm.insertelement"(%2965, %2950, %2947) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2967 = "llvm.insertelement"(%2966, %2950, %2946) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2968 = "llvm.insertelement"(%2967, %2951, %2945) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2969 = "llvm.insertelement"(%2968, %2951, %2944) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2970 = "llvm.insertelement"(%2969, %2950, %2943) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2971 = "llvm.insertelement"(%2953, %2950, %2954) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2972 = "llvm.insertelement"(%2971, %2951, %2949) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2973 = "llvm.insertelement"(%2972, %2951, %2948) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2974 = "llvm.insertelement"(%2973, %2950, %2947) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2975 = "llvm.insertelement"(%2974, %2942, %2946) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2976 = "llvm.insertelement"(%2975, %2951, %2945) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2977 = "llvm.insertelement"(%2976, %2951, %2944) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2978 = "llvm.insertelement"(%2977, %2942, %2943) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2979 = "llvm.insertelement"(%2953, %2951, %2954) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2980 = "llvm.insertelement"(%2979, %2951, %2949) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2981 = "llvm.insertelement"(%2980, %2951, %2948) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2982 = "llvm.insertelement"(%2981, %2951, %2947) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2983 = "llvm.insertelement"(%2982, %2939, %2946) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2984 = "llvm.insertelement"(%2983, %2939, %2945) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2985 = "llvm.insertelement"(%2984, %2939, %2944) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2986 = "llvm.insertelement"(%2985, %2939, %2943) : (vector<8xi64>, i64, i32) -> vector<8xi64>
  %2987 = "llvm.load"(%arg126) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %2988 = "llvm.getelementptr"(%arg126) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %2989 = "llvm.load"(%2988) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %2990 = "llvm.getelementptr"(%arg126) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %2991 = "llvm.load"(%2990) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %2992 = "llvm.sub"(%2962, %2987) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2993 = "llvm.shufflevector"(%2992, %2987) <{mask = array<i32: 0, 9, 10, 3, 4, 13, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%2993, %arg125) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2994 = "llvm.load"(%2988) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %2995 = "llvm.sub"(%2970, %2989) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2996 = "llvm.shufflevector"(%2995, %2994) <{mask = array<i32: 0, 9, 10, 3, 4, 13, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %2997 = "llvm.getelementptr"(%arg125) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2996, %2997) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %2998 = "llvm.load"(%2990) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
  %2999 = "llvm.sub"(%2978, %2991) <{overflowFlags = 0 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3000 = "llvm.shufflevector"(%2999, %2998) <{mask = array<i32: 0, 9, 10, 3, 4, 13, 14, 7>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3001 = "llvm.getelementptr"(%arg125) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %3002 = "llvm.lshr"(%2993, %2941) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3003 = "llvm.lshr"(%2996, %2941) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3004 = "llvm.lshr"(%3000, %2940) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3005 = "llvm.mul"(%3004, %2986) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3006 = "llvm.and"(%2993, %2938) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3007 = "llvm.shufflevector"(%3005, %3004) <{mask = array<i32: 4, 5, 6, 7, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3008 = "llvm.add"(%3007, %3006) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%3008, %arg125) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %3009 = "llvm.and"(%2996, %2938) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3010 = "llvm.add"(%3009, %3002) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%3010, %2997) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<8xi64>, !llvm.ptr) -> ()
  %3011 = "llvm.and"(%3000, %2937) : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  %3012 = "llvm.add"(%3011, %3003) <{overflowFlags = 3 : i32}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
  "llvm.store"(%3012, %3001) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<8xi64>, !llvm.ptr) -> ()
  "llvm.return"(%arg125) : (!llvm.ptr) -> ()
}) : () -> ()

end

end MLIR.Firedancer.Avx512
