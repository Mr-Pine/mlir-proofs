module

-- crc/out/mlirproofs/regions/verify/fd_r52x5_quad_ge_dbl.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_quad_add_nc
public import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_quad_mul
public import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_quad_negate_lazy
public import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_quad_reduce
public import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_quad_sqr
public import Firedancer.Crc.Ed25519.Avx512.Mlir.wl_permute

meta import MLIR.Semantics.Func
meta import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_quad_add_nc
meta import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_quad_mul
meta import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_quad_negate_lazy
meta import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_quad_reduce
meta import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_quad_sqr
meta import Firedancer.Crc.Ed25519.Avx512.Mlir.wl_permute

namespace MLIR.Firedancer.Crc.Ed25519.Avx512

@[expose] public section

mlir_def fd_r52x5_quad_ge_dbl :=
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nocapture, llvm.nonnull, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nonnull, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nonnull, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nonnull, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nonnull, llvm.noundef, llvm.writeonly}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<void (ptr, ptr, ptr, ptr, ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", "sspstrong", ["min-legal-vector-width", "256"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "icelake-server"]], sym_name = "fd_r52x5_quad_ge_dbl", target_cpu = "icelake-server", target_features = #llvm.target_features<["+adx", "+aes", "+avx", "+avx2", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+pclmul", "+pconfig", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdrnd", "+rdseed", "+sahf", "+sgx", "+sha", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves"]>, tune_cpu = "icelake-server", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg154: !llvm.ptr, %arg155: !llvm.ptr, %arg156: !llvm.ptr, %arg157: !llvm.ptr, %arg158: !llvm.ptr, %arg159: vector<4xi64>, %arg160: vector<4xi64>, %arg161: vector<4xi64>, %arg162: vector<4xi64>, %arg163: vector<4xi64>):
  %819 = "llvm.mlir.undef"() : () -> vector<4xi64>
  %820 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %821 = "llvm.mlir.poison"() : () -> i64
  %822 = "llvm.mlir.constant"() <{value = 31 : i32}> : () -> i32
  %823 = "llvm.mlir.constant"() <{value = 30 : i32}> : () -> i32
  %824 = "llvm.mlir.constant"() <{value = 29 : i32}> : () -> i32
  %825 = "llvm.mlir.constant"() <{value = 28 : i32}> : () -> i32
  %826 = "llvm.mlir.constant"() <{value = 27 : i32}> : () -> i32
  %827 = "llvm.mlir.constant"() <{value = 26 : i32}> : () -> i32
  %828 = "llvm.mlir.constant"() <{value = 25 : i32}> : () -> i32
  %829 = "llvm.mlir.constant"() <{value = 24 : i32}> : () -> i32
  %830 = "llvm.mlir.constant"() <{value = 23 : i32}> : () -> i32
  %831 = "llvm.mlir.constant"() <{value = 22 : i32}> : () -> i32
  %832 = "llvm.mlir.constant"() <{value = 21 : i32}> : () -> i32
  %833 = "llvm.mlir.constant"() <{value = 20 : i32}> : () -> i32
  %834 = "llvm.mlir.constant"() <{value = 19 : i32}> : () -> i32
  %835 = "llvm.mlir.constant"() <{value = 18 : i32}> : () -> i32
  %836 = "llvm.mlir.constant"() <{value = 17 : i32}> : () -> i32
  %837 = "llvm.mlir.constant"() <{value = 16 : i32}> : () -> i32
  %838 = "llvm.mlir.constant"() <{value = 15 : i32}> : () -> i32
  %839 = "llvm.mlir.constant"() <{value = 14 : i32}> : () -> i32
  %840 = "llvm.mlir.constant"() <{value = 13 : i32}> : () -> i32
  %841 = "llvm.mlir.constant"() <{value = 12 : i32}> : () -> i32
  %842 = "llvm.mlir.constant"() <{value = 11 : i32}> : () -> i32
  %843 = "llvm.mlir.constant"() <{value = 10 : i32}> : () -> i32
  %844 = "llvm.mlir.constant"() <{value = 9 : i32}> : () -> i32
  %845 = "llvm.mlir.constant"() <{value = 8 : i32}> : () -> i32
  %846 = "llvm.mlir.constant"() <{value = 7 : i32}> : () -> i32
  %847 = "llvm.mlir.constant"() <{value = 6 : i32}> : () -> i32
  %848 = "llvm.mlir.constant"() <{value = 5 : i32}> : () -> i32
  %849 = "llvm.mlir.constant"() <{value = 4 : i32}> : () -> i32
  %850 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %851 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %852 = "llvm.mlir.constant"() <{value = 3 : i32}> : () -> i32
  %853 = "llvm.mlir.constant"() <{value = 2 : i32}> : () -> i32
  %854 = "llvm.mlir.constant"() <{value = 0 : i8}> : () -> i8
  %855 = "llvm.mlir.poison"() : () -> i8
  %856 = "llvm.mlir.undef"() : () -> vector<32xi8>
  %857 = "llvm.insertelement"(%856, %854, %851) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %858 = "llvm.insertelement"(%857, %854, %850) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %859 = "llvm.insertelement"(%858, %854, %853) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %860 = "llvm.insertelement"(%859, %854, %852) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %861 = "llvm.insertelement"(%860, %854, %849) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %862 = "llvm.insertelement"(%861, %854, %848) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %863 = "llvm.insertelement"(%862, %854, %847) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %864 = "llvm.insertelement"(%863, %854, %846) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %865 = "llvm.insertelement"(%864, %854, %845) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %866 = "llvm.insertelement"(%865, %854, %844) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %867 = "llvm.insertelement"(%866, %854, %843) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %868 = "llvm.insertelement"(%867, %854, %842) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %869 = "llvm.insertelement"(%868, %854, %841) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %870 = "llvm.insertelement"(%869, %854, %840) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %871 = "llvm.insertelement"(%870, %854, %839) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %872 = "llvm.insertelement"(%871, %854, %838) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %873 = "llvm.insertelement"(%872, %855, %837) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %874 = "llvm.insertelement"(%873, %855, %836) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %875 = "llvm.insertelement"(%874, %855, %835) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %876 = "llvm.insertelement"(%875, %855, %834) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %877 = "llvm.insertelement"(%876, %855, %833) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %878 = "llvm.insertelement"(%877, %855, %832) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %879 = "llvm.insertelement"(%878, %855, %831) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %880 = "llvm.insertelement"(%879, %855, %830) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %881 = "llvm.insertelement"(%880, %854, %829) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %882 = "llvm.insertelement"(%881, %854, %828) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %883 = "llvm.insertelement"(%882, %854, %827) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %884 = "llvm.insertelement"(%883, %854, %826) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %885 = "llvm.insertelement"(%884, %854, %825) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %886 = "llvm.insertelement"(%885, %854, %824) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %887 = "llvm.insertelement"(%886, %854, %823) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %888 = "llvm.insertelement"(%887, %854, %822) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %889 = "llvm.insertelement"(%819, %821, %851) : (vector<4xi64>, i64, i32) -> vector<4xi64>
  %890 = "llvm.insertelement"(%889, %820, %850) : (vector<4xi64>, i64, i32) -> vector<4xi64>
  %891 = "llvm.insertelement"(%890, %820, %853) : (vector<4xi64>, i64, i32) -> vector<4xi64>
  %892 = "llvm.insertelement"(%891, %821, %852) : (vector<4xi64>, i64, i32) -> vector<4xi64>
  %893 = "llvm.insertelement"(%856, %854, %851) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %894 = "llvm.insertelement"(%893, %854, %850) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %895 = "llvm.insertelement"(%894, %854, %853) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %896 = "llvm.insertelement"(%895, %854, %852) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %897 = "llvm.insertelement"(%896, %854, %849) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %898 = "llvm.insertelement"(%897, %854, %848) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %899 = "llvm.insertelement"(%898, %854, %847) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %900 = "llvm.insertelement"(%899, %854, %846) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %901 = "llvm.insertelement"(%900, %855, %845) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %902 = "llvm.insertelement"(%901, %855, %844) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %903 = "llvm.insertelement"(%902, %855, %843) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %904 = "llvm.insertelement"(%903, %855, %842) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %905 = "llvm.insertelement"(%904, %855, %841) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %906 = "llvm.insertelement"(%905, %855, %840) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %907 = "llvm.insertelement"(%906, %855, %839) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %908 = "llvm.insertelement"(%907, %855, %838) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %909 = "llvm.insertelement"(%908, %855, %837) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %910 = "llvm.insertelement"(%909, %855, %836) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %911 = "llvm.insertelement"(%910, %855, %835) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %912 = "llvm.insertelement"(%911, %855, %834) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %913 = "llvm.insertelement"(%912, %855, %833) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %914 = "llvm.insertelement"(%913, %855, %832) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %915 = "llvm.insertelement"(%914, %855, %831) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %916 = "llvm.insertelement"(%915, %855, %830) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %917 = "llvm.insertelement"(%916, %855, %829) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %918 = "llvm.insertelement"(%917, %855, %828) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %919 = "llvm.insertelement"(%918, %855, %827) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %920 = "llvm.insertelement"(%919, %855, %826) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %921 = "llvm.insertelement"(%920, %855, %825) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %922 = "llvm.insertelement"(%921, %855, %824) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %923 = "llvm.insertelement"(%922, %855, %823) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %924 = "llvm.insertelement"(%923, %855, %822) : (vector<32xi8>, i8, i32) -> vector<32xi8>
  %925 = "llvm.alloca"(%850) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %926 = "llvm.alloca"(%850) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %927 = "llvm.alloca"(%850) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %928 = "llvm.alloca"(%850) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %929 = "llvm.alloca"(%850) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %930 = "llvm.alloca"(%850) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %931 = "llvm.alloca"(%850) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %932 = "llvm.alloca"(%850) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %933 = "llvm.alloca"(%850) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %934 = "llvm.alloca"(%850) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %935 = "llvm.alloca"(%850) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %936 = "llvm.alloca"(%850) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %937 = "llvm.alloca"(%850) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %938 = "llvm.alloca"(%850) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %939 = "llvm.alloca"(%850) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %940 = "llvm.alloca"(%850) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %941 = "llvm.alloca"(%850) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %942 = "llvm.alloca"(%850) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %943 = "llvm.alloca"(%850) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %944 = "llvm.alloca"(%850) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %945 = "llvm.alloca"(%850) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %946 = "llvm.alloca"(%850) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %947 = "llvm.alloca"(%850) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %948 = "llvm.alloca"(%850) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %949 = "llvm.alloca"(%850) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %950 = "llvm.alloca"(%850) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %951 = "llvm.alloca"(%850) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %952 = "llvm.alloca"(%850) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %953 = "llvm.alloca"(%850) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %954 = "llvm.alloca"(%850) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %955 = "llvm.alloca"(%850) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %956 = "llvm.alloca"(%850) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %957 = "llvm.alloca"(%850) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %958 = "llvm.alloca"(%850) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %959 = "llvm.alloca"(%850) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %960 = "llvm.alloca"(%850) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %961 = "llvm.alloca"(%850) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %962 = "llvm.alloca"(%850) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %963 = "llvm.alloca"(%850) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %964 = "llvm.alloca"(%850) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %965 = "llvm.alloca"(%850) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %966 = "llvm.alloca"(%850) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %967 = "llvm.alloca"(%850) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %968 = "llvm.alloca"(%850) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %969 = "llvm.alloca"(%850) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %970 = "llvm.alloca"(%850) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %971 = "llvm.alloca"(%850) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %972 = "llvm.alloca"(%850) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %973 = "llvm.alloca"(%850) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %974 = "llvm.alloca"(%850) <{alignment = 32 : i64, elem_type = vector<4xi64>}> : (i32) -> !llvm.ptr
  %975 = "llvm.call"(%arg159, %850, %851, %852, %853) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %976 = "llvm.call"(%arg160, %850, %851, %852, %853) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %977 = "llvm.call"(%arg161, %850, %851, %852, %853) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %978 = "llvm.call"(%arg162, %850, %851, %852, %853) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %979 = "llvm.call"(%arg163, %850, %851, %852, %853) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%925) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%926) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%927) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%928) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%929) : (!llvm.ptr) -> ()
  "llvm.call"(%925, %926, %927, %928, %929, %975, %976, %977, %978, %979, %arg159, %arg160, %arg161, %arg162, %arg163) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_add_nc, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %980 = "llvm.load"(%925) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %981 = "llvm.load"(%926) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %982 = "llvm.load"(%927) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %983 = "llvm.load"(%928) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %984 = "llvm.load"(%929) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%929) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%928) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%927) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%926) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%925) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%930) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%931) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%932) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%933) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%934) : (!llvm.ptr) -> ()
  "llvm.call"(%930, %931, %932, %933, %934, %980, %981, %982, %983, %984) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_reduce, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %985 = "llvm.load"(%930) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %986 = "llvm.load"(%931) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %987 = "llvm.load"(%932) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %988 = "llvm.load"(%933) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %989 = "llvm.load"(%934) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%934) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%933) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%932) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%931) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%930) : (!llvm.ptr) -> ()
  %990 = "llvm.call"(%985, %851, %850, %851, %850) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %991 = "llvm.call"(%986, %851, %850, %851, %850) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %992 = "llvm.call"(%987, %851, %850, %851, %850) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %993 = "llvm.call"(%988, %851, %850, %851, %850) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %994 = "llvm.call"(%989, %851, %850, %851, %850) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %995 = "llvm.shufflevector"(%arg159, %990) <{mask = array<i32: 0, 1, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %996 = "llvm.shufflevector"(%arg160, %991) <{mask = array<i32: 0, 1, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %997 = "llvm.shufflevector"(%arg161, %992) <{mask = array<i32: 0, 1, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %998 = "llvm.shufflevector"(%arg162, %993) <{mask = array<i32: 0, 1, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %999 = "llvm.shufflevector"(%arg163, %994) <{mask = array<i32: 0, 1, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%935) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%936) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%937) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%938) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%939) : (!llvm.ptr) -> ()
  "llvm.call"(%935, %936, %937, %938, %939, %995, %996, %997, %998, %999) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_sqr, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1000 = "llvm.load"(%935) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1001 = "llvm.load"(%936) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1002 = "llvm.load"(%937) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1003 = "llvm.load"(%938) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1004 = "llvm.load"(%939) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%939) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%938) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%937) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%936) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%935) : (!llvm.ptr) -> ()
  %1005 = "llvm.call"(%1000, %851, %851, %851, %851) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %1006 = "llvm.call"(%1001, %851, %851, %851, %851) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %1007 = "llvm.call"(%1002, %851, %851, %851, %851) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %1008 = "llvm.call"(%1003, %851, %851, %851, %851) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %1009 = "llvm.call"(%1004, %851, %851, %851, %851) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %1010 = "llvm.call"(%1000, %850, %850, %850, %850) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %1011 = "llvm.call"(%1001, %850, %850, %850, %850) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %1012 = "llvm.call"(%1002, %850, %850, %850, %850) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %1013 = "llvm.call"(%1003, %850, %850, %850, %850) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %1014 = "llvm.call"(%1004, %850, %850, %850, %850) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %1015 = "llvm.shufflevector"(%1010, %1000) <{mask = array<i32: 0, 1, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1016 = "llvm.shufflevector"(%1011, %1001) <{mask = array<i32: 0, 1, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1017 = "llvm.shufflevector"(%1012, %1002) <{mask = array<i32: 0, 1, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1018 = "llvm.shufflevector"(%1013, %1003) <{mask = array<i32: 0, 1, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1019 = "llvm.shufflevector"(%1014, %1004) <{mask = array<i32: 0, 1, 2, 7>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%940) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%941) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%942) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%943) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%944) : (!llvm.ptr) -> ()
  "llvm.call"(%940, %941, %942, %943, %944, %1015, %1016, %1017, %1018, %1019) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_negate_lazy, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1020 = "llvm.load"(%940) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<32xi8>
  %1021 = "llvm.load"(%941) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<32xi8>
  %1022 = "llvm.load"(%942) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<32xi8>
  %1023 = "llvm.load"(%943) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<32xi8>
  %1024 = "llvm.load"(%944) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<32xi8>
  "llvm.intr.lifetime.end"(%944) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%943) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%942) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%941) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%940) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%945) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%946) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%947) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%948) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%949) : (!llvm.ptr) -> ()
  "llvm.call"(%945, %946, %947, %948, %949, %1000, %1001, %1002, %1003, %1004, %1000, %1001, %1002, %1003, %1004) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_add_nc, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1025 = "llvm.load"(%945) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<32xi8>
  %1026 = "llvm.load"(%946) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<32xi8>
  %1027 = "llvm.load"(%947) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<32xi8>
  %1028 = "llvm.load"(%948) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<32xi8>
  %1029 = "llvm.load"(%949) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<32xi8>
  "llvm.intr.lifetime.end"(%949) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%948) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%947) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%946) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%945) : (!llvm.ptr) -> ()
  %1030 = "llvm.shufflevector"(%888, %1025) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 48, 49, 50, 51, 52, 53, 54, 55, 24, 25, 26, 27, 28, 29, 30, 31>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %1031 = "llvm.bitcast"(%1030) : (vector<32xi8>) -> vector<4xi64>
  %1032 = "llvm.shufflevector"(%888, %1026) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 48, 49, 50, 51, 52, 53, 54, 55, 24, 25, 26, 27, 28, 29, 30, 31>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %1033 = "llvm.bitcast"(%1032) : (vector<32xi8>) -> vector<4xi64>
  %1034 = "llvm.shufflevector"(%888, %1027) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 48, 49, 50, 51, 52, 53, 54, 55, 24, 25, 26, 27, 28, 29, 30, 31>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %1035 = "llvm.bitcast"(%1034) : (vector<32xi8>) -> vector<4xi64>
  %1036 = "llvm.shufflevector"(%888, %1028) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 48, 49, 50, 51, 52, 53, 54, 55, 24, 25, 26, 27, 28, 29, 30, 31>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %1037 = "llvm.bitcast"(%1036) : (vector<32xi8>) -> vector<4xi64>
  %1038 = "llvm.shufflevector"(%888, %1029) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 48, 49, 50, 51, 52, 53, 54, 55, 24, 25, 26, 27, 28, 29, 30, 31>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %1039 = "llvm.bitcast"(%1038) : (vector<32xi8>) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%950) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%951) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%952) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%953) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%954) : (!llvm.ptr) -> ()
  "llvm.call"(%950, %951, %952, %953, %954, %1005, %1006, %1007, %1008, %1009, %1031, %1033, %1035, %1037, %1039) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_add_nc, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1040 = "llvm.load"(%950) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1041 = "llvm.load"(%951) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1042 = "llvm.load"(%952) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1043 = "llvm.load"(%953) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1044 = "llvm.load"(%954) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%954) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%953) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%952) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%951) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%950) : (!llvm.ptr) -> ()
  %1045 = "llvm.shufflevector"(%1010, %892) <{mask = array<i32: 0, 5, 6, 3>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1046 = "llvm.shufflevector"(%1011, %892) <{mask = array<i32: 0, 5, 6, 3>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1047 = "llvm.shufflevector"(%1012, %892) <{mask = array<i32: 0, 5, 6, 3>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1048 = "llvm.shufflevector"(%1013, %892) <{mask = array<i32: 0, 5, 6, 3>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %1049 = "llvm.shufflevector"(%1014, %892) <{mask = array<i32: 0, 5, 6, 3>}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%955) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%956) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%957) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%958) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%959) : (!llvm.ptr) -> ()
  "llvm.call"(%955, %956, %957, %958, %959, %1040, %1041, %1042, %1043, %1044, %1045, %1046, %1047, %1048, %1049) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_add_nc, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1050 = "llvm.load"(%955) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1051 = "llvm.load"(%956) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1052 = "llvm.load"(%957) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1053 = "llvm.load"(%958) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1054 = "llvm.load"(%959) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%959) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%958) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%957) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%956) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%955) : (!llvm.ptr) -> ()
  %1055 = "llvm.shufflevector"(%924, %1020) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 6, 7, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %1056 = "llvm.bitcast"(%1055) : (vector<32xi8>) -> vector<4xi64>
  %1057 = "llvm.shufflevector"(%924, %1021) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 6, 7, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %1058 = "llvm.bitcast"(%1057) : (vector<32xi8>) -> vector<4xi64>
  %1059 = "llvm.shufflevector"(%924, %1022) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 6, 7, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %1060 = "llvm.bitcast"(%1059) : (vector<32xi8>) -> vector<4xi64>
  %1061 = "llvm.shufflevector"(%924, %1023) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 6, 7, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %1062 = "llvm.bitcast"(%1061) : (vector<32xi8>) -> vector<4xi64>
  %1063 = "llvm.shufflevector"(%924, %1024) <{mask = array<i32: 0, 1, 2, 3, 4, 5, 6, 7, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63>}> : (vector<32xi8>, vector<32xi8>) -> vector<32xi8>
  %1064 = "llvm.bitcast"(%1063) : (vector<32xi8>) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%960) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%961) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%962) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%963) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%964) : (!llvm.ptr) -> ()
  "llvm.call"(%960, %961, %962, %963, %964, %1050, %1051, %1052, %1053, %1054, %1056, %1058, %1060, %1062, %1064) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_add_nc, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1065 = "llvm.load"(%960) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1066 = "llvm.load"(%961) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1067 = "llvm.load"(%962) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1068 = "llvm.load"(%963) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1069 = "llvm.load"(%964) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%964) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%963) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%962) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%961) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%960) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%965) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%966) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%967) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%968) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%969) : (!llvm.ptr) -> ()
  "llvm.call"(%965, %966, %967, %968, %969, %1065, %1066, %1067, %1068, %1069) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_reduce, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 10, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1070 = "llvm.load"(%965) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1071 = "llvm.load"(%966) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1072 = "llvm.load"(%967) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1073 = "llvm.load"(%968) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1074 = "llvm.load"(%969) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%969) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%968) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%967) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%966) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%965) : (!llvm.ptr) -> ()
  %1075 = "llvm.call"(%1070, %852, %850, %850, %852) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %1076 = "llvm.call"(%1071, %852, %850, %850, %852) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %1077 = "llvm.call"(%1072, %852, %850, %850, %852) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %1078 = "llvm.call"(%1073, %852, %850, %850, %852) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %1079 = "llvm.call"(%1074, %852, %850, %850, %852) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %1080 = "llvm.call"(%1070, %853, %851, %853, %851) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %1081 = "llvm.call"(%1071, %853, %851, %853, %851) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %1082 = "llvm.call"(%1072, %853, %851, %853, %851) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %1083 = "llvm.call"(%1073, %853, %851, %853, %851) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  %1084 = "llvm.call"(%1074, %853, %851, %853, %851) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @wl_permute, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (vector<4xi64>, i32, i32, i32, i32) -> vector<4xi64>
  "llvm.intr.lifetime.start"(%970) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%971) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%972) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%973) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%974) : (!llvm.ptr) -> ()
  "llvm.call"(%970, %971, %972, %973, %974, %1075, %1076, %1077, %1078, %1079, %1080, %1081, %1082, %1083, %1084) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @fd_r52x5_quad_mul, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 15, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>, vector<4xi64>) -> ()
  %1085 = "llvm.load"(%970) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1086 = "llvm.load"(%971) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1087 = "llvm.load"(%972) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1088 = "llvm.load"(%973) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  %1089 = "llvm.load"(%974) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi64>
  "llvm.intr.lifetime.end"(%974) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%973) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%972) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%971) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%970) : (!llvm.ptr) -> ()
  "llvm.store"(%1085, %arg154) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  "llvm.store"(%1086, %arg155) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  "llvm.store"(%1087, %arg156) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  "llvm.store"(%1088, %arg157) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  "llvm.store"(%1089, %arg158) <{alignment = 32 : i64, ordering = 0 : i64}> : (vector<4xi64>, !llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()
  with @fd_r52x5_quad_add_nc := fd_r52x5_quad_add_nc, @fd_r52x5_quad_mul := fd_r52x5_quad_mul,
    @fd_r52x5_quad_negate_lazy := fd_r52x5_quad_negate_lazy,
    @fd_r52x5_quad_reduce := fd_r52x5_quad_reduce, @fd_r52x5_quad_sqr := fd_r52x5_quad_sqr,
    @wl_permute := wl_permute

end

end MLIR.Firedancer.Crc.Ed25519.Avx512
