module

-- agave-build/out/serial-noinline-big/op/_RNvMs2_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u646scalarNtB5_8Scalar5215from_bytes_wide.mlir
-- <solana_ed25519[1fe0933b11699477]::backend::serial::u64::scalar::Scalar52>::from_bytes_wide

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Agave.Serial.Mlir.Scalar52_montgomery_mul
public import Agave.Serial.Mlir.Scalar52_add
public import Agave.Serial.Mlir.anon_042b818bc72209407b52bd0e4d6c8368_40
public import Agave.Serial.Mlir.anon_042b818bc72209407b52bd0e4d6c8368_41

meta import MLIR.Semantics.Func
meta import Agave.Serial.Mlir.Scalar52_montgomery_mul
meta import Agave.Serial.Mlir.Scalar52_add
meta import Agave.Serial.Mlir.anon_042b818bc72209407b52bd0e4d6c8368_40
meta import Agave.Serial.Mlir.anon_042b818bc72209407b52bd0e4d6c8368_41

namespace MLIR.Agave.Serial

@[expose] public section

mlir_def Scalar52_from_bytes_wide :=
#alias_scope_domain15 = #llvm.alias_scope_domain<id = distinct[15]<>, description = "_RNvXCshxoft6be3N1_7zeroizeyNtB2_7Zeroize7zeroizeCs2JGgYtL0Fal_14solana_ed25519">
#alias_scope_domain16 = #llvm.alias_scope_domain<id = distinct[16]<>, description = "_RNvXs4_Cshxoft6be3N1_7zeroizeINtNtNtCsgxBkk5gSRhY_4core5slice4iter7IterMutyENtB5_7Zeroize7zeroizeCs2JGgYtL0Fal_14solana_ed25519">
#alias_scope_domain17 = #llvm.alias_scope_domain<id = distinct[17]<>, description = "_RNvXs6_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u646scalarNtB5_8Scalar52NtNtCsgxBkk5gSRhY_4core7default7Default7default">
#alias_scope_domain18 = #llvm.alias_scope_domain<id = distinct[18]<>, description = "_RNvXCshxoft6be3N1_7zeroizeNtNtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u646scalar8Scalar52NtB2_7Zeroize7zeroizeBy_">
#alias_scope_domain19 = #llvm.alias_scope_domain<id = distinct[19]<>, description = "_RNvXs6_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u646scalarNtB5_8Scalar52NtNtCsgxBkk5gSRhY_4core7default7Default7default">
#alias_scope_domain20 = #llvm.alias_scope_domain<id = distinct[20]<>, description = "_RNvXCshxoft6be3N1_7zeroizeNtNtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u646scalar8Scalar52NtB2_7Zeroize7zeroizeBy_">
#alias_scope23 = #llvm.alias_scope<id = distinct[99]<>, domain = #alias_scope_domain15, description = "_RNvXCshxoft6be3N1_7zeroizeyNtB2_7Zeroize7zeroizeCs2JGgYtL0Fal_14solana_ed25519: argument 0">
#alias_scope24 = #llvm.alias_scope<id = distinct[100]<>, domain = #alias_scope_domain16, description = "_RNvXs4_Cshxoft6be3N1_7zeroizeINtNtNtCsgxBkk5gSRhY_4core5slice4iter7IterMutyENtB5_7Zeroize7zeroizeCs2JGgYtL0Fal_14solana_ed25519: argument 0">
#alias_scope25 = #llvm.alias_scope<id = distinct[101]<>, domain = #alias_scope_domain17, description = "_RNvXs6_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u646scalarNtB5_8Scalar52NtNtCsgxBkk5gSRhY_4core7default7Default7default: argument 0">
#alias_scope26 = #llvm.alias_scope<id = distinct[102]<>, domain = #alias_scope_domain18, description = "_RNvXCshxoft6be3N1_7zeroizeNtNtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u646scalar8Scalar52NtB2_7Zeroize7zeroizeBy_: argument 0">
#alias_scope27 = #llvm.alias_scope<id = distinct[103]<>, domain = #alias_scope_domain19, description = "_RNvXs6_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u646scalarNtB5_8Scalar52NtNtCsgxBkk5gSRhY_4core7default7Default7default: argument 0">
#alias_scope28 = #llvm.alias_scope<id = distinct[104]<>, domain = #alias_scope_domain20, description = "_RNvXCshxoft6be3N1_7zeroizeNtNtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u646scalar8Scalar52NtB2_7Zeroize7zeroizeBy_: argument 0">
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.align = 8 : i64, llvm.dead_on_unwind, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.writable, llvm.writeonly}, {llvm.dereferenceable = 64 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<void (ptr, ptr)>, linkage = #llvm.linkage<internal>, no_inline, no_unwind, passthrough = ["nofree", "norecurse", "nonlazybind", ["probe-stack", "inline-asm"], ["target-cpu", "x86-64-v2"]], personality = @rust_eh_personality, sym_name = "_RNvMs2_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u646scalarNtB5_8Scalar5215from_bytes_wide", target_cpu = "x86-64-v2", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg62: !llvm.ptr, %arg63: !llvm.ptr):
  %902 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %903 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %904 = "llvm.mlir.constant"() <{value = 8 : i64}> : () -> i64
  %905 = "llvm.mlir.constant"() <{value = 16 : i64}> : () -> i64
  %906 = "llvm.mlir.constant"() <{value = 24 : i64}> : () -> i64
  %907 = "llvm.mlir.constant"() <{value = 32 : i64}> : () -> i64
  %908 = "llvm.mlir.constant"() <{value = 40 : i64}> : () -> i64
  %909 = "llvm.mlir.constant"() <{value = 48 : i64}> : () -> i64
  %910 = "llvm.mlir.constant"() <{value = 56 : i64}> : () -> i64
  %911 = "llvm.mlir.constant"() <{value = 36 : i64}> : () -> i64
  %912 = "llvm.mlir.constant"() <{value = 4503599627370495 : i64}> : () -> i64
  %913 = "llvm.mlir.constant"() <{value = 12 : i64}> : () -> i64
  %914 = "llvm.mlir.constant"() <{value = 4 : i64}> : () -> i64
  %915 = "llvm.mlir.constant"() <{value = 20 : i64}> : () -> i64
  %916 = "llvm.mlir.addressof"() <{global_name = @anon.042b818bc72209407b52bd0e4d6c8368.41}> : () -> !llvm.ptr
  %917 = "llvm.mlir.addressof"() <{global_name = @anon.042b818bc72209407b52bd0e4d6c8368.40}> : () -> !llvm.ptr
  %918 = "llvm.mlir.constant"() <{value = 0 : i8}> : () -> i8
  %919 = "llvm.alloca"(%902) <{alignment = 8 : i64, elem_type = !llvm.array<40 x i8>}> : (i32) -> !llvm.ptr
  %920 = "llvm.alloca"(%902) <{alignment = 8 : i64, elem_type = !llvm.array<40 x i8>}> : (i32) -> !llvm.ptr
  %921 = "llvm.alloca"(%902) <{alignment = 8 : i64, elem_type = !llvm.array<40 x i8>}> : (i32) -> !llvm.ptr
  %922 = "llvm.alloca"(%902) <{alignment = 8 : i64, elem_type = !llvm.array<40 x i8>}> : (i32) -> !llvm.ptr
  %923 = "llvm.alloca"(%902) <{alignment = 8 : i64, elem_type = !llvm.array<40 x i8>}> : (i32) -> !llvm.ptr
  %924 = "llvm.alloca"(%902) <{alignment = 8 : i64, elem_type = !llvm.array<40 x i8>}> : (i32) -> !llvm.ptr
  %925 = "llvm.alloca"(%902) <{alignment = 8 : i64, elem_type = i64}> : (i32) -> !llvm.ptr
  %926 = "llvm.alloca"(%902) <{alignment = 8 : i64, elem_type = i64}> : (i32) -> !llvm.ptr
  %927 = "llvm.alloca"(%902) <{alignment = 8 : i64, elem_type = i64}> : (i32) -> !llvm.ptr
  %928 = "llvm.alloca"(%902) <{alignment = 8 : i64, elem_type = i64}> : (i32) -> !llvm.ptr
  %929 = "llvm.alloca"(%902) <{alignment = 8 : i64, elem_type = i64}> : (i32) -> !llvm.ptr
  %930 = "llvm.alloca"(%902) <{alignment = 8 : i64, elem_type = i64}> : (i32) -> !llvm.ptr
  %931 = "llvm.alloca"(%902) <{alignment = 8 : i64, elem_type = i64}> : (i32) -> !llvm.ptr
  %932 = "llvm.alloca"(%902) <{alignment = 8 : i64, elem_type = i64}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%925) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%926) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%927) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%928) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%929) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%930) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%931) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%932) : (!llvm.ptr) -> ()
  "llvm.store"(%903, %931) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  "llvm.store"(%903, %932) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %933 = "llvm.load"(%arg63) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  "llvm.store"(%933, %925) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %934 = "llvm.getelementptr"(%arg63) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %935 = "llvm.load"(%934) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  "llvm.store"(%935, %926) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %936 = "llvm.getelementptr"(%arg63) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %937 = "llvm.load"(%936) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  "llvm.store"(%937, %927) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %938 = "llvm.getelementptr"(%arg63) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %939 = "llvm.load"(%938) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %940 = "llvm.zext"(%939) : (i8) -> i64
  %941 = "llvm.getelementptr"(%arg63) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 25>}> : (!llvm.ptr) -> !llvm.ptr
  %942 = "llvm.load"(%941) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %943 = "llvm.zext"(%942) : (i8) -> i64
  %944 = "llvm.shl"(%943, %904) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %945 = "llvm.or"(%944, %940) <{isDisjoint}> : (i64, i64) -> i64
  %946 = "llvm.getelementptr"(%arg63) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 26>}> : (!llvm.ptr) -> !llvm.ptr
  %947 = "llvm.load"(%946) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %948 = "llvm.zext"(%947) : (i8) -> i64
  %949 = "llvm.shl"(%948, %905) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %950 = "llvm.or"(%949, %945) <{isDisjoint}> : (i64, i64) -> i64
  %951 = "llvm.getelementptr"(%arg63) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 27>}> : (!llvm.ptr) -> !llvm.ptr
  %952 = "llvm.load"(%951) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %953 = "llvm.zext"(%952) : (i8) -> i64
  %954 = "llvm.shl"(%953, %906) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %955 = "llvm.or"(%954, %950) <{isDisjoint}> : (i64, i64) -> i64
  %956 = "llvm.getelementptr"(%arg63) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 28>}> : (!llvm.ptr) -> !llvm.ptr
  %957 = "llvm.load"(%956) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %958 = "llvm.zext"(%957) : (i8) -> i64
  %959 = "llvm.shl"(%958, %907) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %960 = "llvm.or"(%959, %955) <{isDisjoint}> : (i64, i64) -> i64
  %961 = "llvm.getelementptr"(%arg63) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 29>}> : (!llvm.ptr) -> !llvm.ptr
  %962 = "llvm.load"(%961) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %963 = "llvm.zext"(%962) : (i8) -> i64
  %964 = "llvm.shl"(%963, %908) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %965 = "llvm.or"(%964, %960) : (i64, i64) -> i64
  %966 = "llvm.getelementptr"(%arg63) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 30>}> : (!llvm.ptr) -> !llvm.ptr
  %967 = "llvm.load"(%966) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %968 = "llvm.zext"(%967) : (i8) -> i64
  %969 = "llvm.shl"(%968, %909) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %970 = "llvm.or"(%969, %965) : (i64, i64) -> i64
  %971 = "llvm.getelementptr"(%arg63) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 31>}> : (!llvm.ptr) -> !llvm.ptr
  %972 = "llvm.load"(%971) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %973 = "llvm.zext"(%972) : (i8) -> i64
  %974 = "llvm.shl"(%973, %910) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %975 = "llvm.or"(%974, %970) : (i64, i64) -> i64
  "llvm.store"(%975, %928) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %976 = "llvm.getelementptr"(%arg63) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %977 = "llvm.load"(%976) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %978 = "llvm.zext"(%977) : (i8) -> i64
  %979 = "llvm.getelementptr"(%arg63) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 33>}> : (!llvm.ptr) -> !llvm.ptr
  %980 = "llvm.load"(%979) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %981 = "llvm.zext"(%980) : (i8) -> i64
  %982 = "llvm.shl"(%981, %904) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %983 = "llvm.or"(%982, %978) <{isDisjoint}> : (i64, i64) -> i64
  %984 = "llvm.getelementptr"(%arg63) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 34>}> : (!llvm.ptr) -> !llvm.ptr
  %985 = "llvm.load"(%984) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %986 = "llvm.zext"(%985) : (i8) -> i64
  %987 = "llvm.shl"(%986, %905) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %988 = "llvm.or"(%987, %983) <{isDisjoint}> : (i64, i64) -> i64
  %989 = "llvm.getelementptr"(%arg63) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 35>}> : (!llvm.ptr) -> !llvm.ptr
  %990 = "llvm.load"(%989) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %991 = "llvm.zext"(%990) : (i8) -> i64
  %992 = "llvm.shl"(%991, %906) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %993 = "llvm.or"(%992, %988) <{isDisjoint}> : (i64, i64) -> i64
  %994 = "llvm.getelementptr"(%arg63) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 36>}> : (!llvm.ptr) -> !llvm.ptr
  %995 = "llvm.load"(%994) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %996 = "llvm.zext"(%995) : (i8) -> i64
  %997 = "llvm.shl"(%996, %907) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %998 = "llvm.or"(%997, %993) <{isDisjoint}> : (i64, i64) -> i64
  %999 = "llvm.getelementptr"(%arg63) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 37>}> : (!llvm.ptr) -> !llvm.ptr
  %1000 = "llvm.load"(%999) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1001 = "llvm.zext"(%1000) : (i8) -> i64
  %1002 = "llvm.shl"(%1001, %908) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1003 = "llvm.or"(%1002, %998) : (i64, i64) -> i64
  %1004 = "llvm.getelementptr"(%arg63) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 38>}> : (!llvm.ptr) -> !llvm.ptr
  %1005 = "llvm.load"(%1004) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1006 = "llvm.zext"(%1005) : (i8) -> i64
  %1007 = "llvm.shl"(%1006, %909) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1008 = "llvm.or"(%1007, %1003) : (i64, i64) -> i64
  %1009 = "llvm.getelementptr"(%arg63) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 39>}> : (!llvm.ptr) -> !llvm.ptr
  %1010 = "llvm.load"(%1009) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1011 = "llvm.zext"(%1010) : (i8) -> i64
  %1012 = "llvm.shl"(%1011, %910) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %1013 = "llvm.or"(%1012, %1008) : (i64, i64) -> i64
  "llvm.store"(%1013, %929) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %1014 = "llvm.getelementptr"(%arg63) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 40>}> : (!llvm.ptr) -> !llvm.ptr
  %1015 = "llvm.load"(%1014) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1016 = "llvm.zext"(%1015) : (i8) -> i64
  %1017 = "llvm.getelementptr"(%arg63) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 41>}> : (!llvm.ptr) -> !llvm.ptr
  %1018 = "llvm.load"(%1017) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1019 = "llvm.zext"(%1018) : (i8) -> i64
  %1020 = "llvm.shl"(%1019, %904) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1021 = "llvm.or"(%1020, %1016) <{isDisjoint}> : (i64, i64) -> i64
  %1022 = "llvm.getelementptr"(%arg63) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 42>}> : (!llvm.ptr) -> !llvm.ptr
  %1023 = "llvm.load"(%1022) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1024 = "llvm.zext"(%1023) : (i8) -> i64
  %1025 = "llvm.shl"(%1024, %905) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1026 = "llvm.or"(%1025, %1021) <{isDisjoint}> : (i64, i64) -> i64
  %1027 = "llvm.getelementptr"(%arg63) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 43>}> : (!llvm.ptr) -> !llvm.ptr
  %1028 = "llvm.load"(%1027) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1029 = "llvm.zext"(%1028) : (i8) -> i64
  %1030 = "llvm.shl"(%1029, %906) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1031 = "llvm.or"(%1030, %1026) <{isDisjoint}> : (i64, i64) -> i64
  %1032 = "llvm.getelementptr"(%arg63) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 44>}> : (!llvm.ptr) -> !llvm.ptr
  %1033 = "llvm.load"(%1032) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1034 = "llvm.zext"(%1033) : (i8) -> i64
  %1035 = "llvm.shl"(%1034, %907) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1036 = "llvm.or"(%1035, %1031) <{isDisjoint}> : (i64, i64) -> i64
  %1037 = "llvm.getelementptr"(%arg63) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 45>}> : (!llvm.ptr) -> !llvm.ptr
  %1038 = "llvm.load"(%1037) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1039 = "llvm.zext"(%1038) : (i8) -> i64
  %1040 = "llvm.shl"(%1039, %908) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1041 = "llvm.or"(%1040, %1036) : (i64, i64) -> i64
  %1042 = "llvm.getelementptr"(%arg63) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 46>}> : (!llvm.ptr) -> !llvm.ptr
  %1043 = "llvm.load"(%1042) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1044 = "llvm.zext"(%1043) : (i8) -> i64
  %1045 = "llvm.shl"(%1044, %909) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1046 = "llvm.getelementptr"(%arg63) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 47>}> : (!llvm.ptr) -> !llvm.ptr
  %1047 = "llvm.load"(%1046) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1048 = "llvm.zext"(%1047) : (i8) -> i64
  %1049 = "llvm.shl"(%1048, %910) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %1050 = "llvm.or"(%1045, %1049) <{isDisjoint}> : (i64, i64) -> i64
  %1051 = "llvm.or"(%1050, %1041) : (i64, i64) -> i64
  "llvm.store"(%1051, %930) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %1052 = "llvm.getelementptr"(%arg63) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 48>}> : (!llvm.ptr) -> !llvm.ptr
  %1053 = "llvm.load"(%931) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1054 = "llvm.load"(%1052) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1055 = "llvm.zext"(%1054) : (i8) -> i64
  %1056 = "llvm.or"(%1053, %1055) : (i64, i64) -> i64
  %1057 = "llvm.getelementptr"(%arg63) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 49>}> : (!llvm.ptr) -> !llvm.ptr
  %1058 = "llvm.load"(%1057) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1059 = "llvm.zext"(%1058) : (i8) -> i64
  %1060 = "llvm.shl"(%1059, %904) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1061 = "llvm.or"(%1060, %1056) : (i64, i64) -> i64
  %1062 = "llvm.getelementptr"(%arg63) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 50>}> : (!llvm.ptr) -> !llvm.ptr
  %1063 = "llvm.load"(%1062) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1064 = "llvm.zext"(%1063) : (i8) -> i64
  %1065 = "llvm.shl"(%1064, %905) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1066 = "llvm.or"(%1065, %1061) : (i64, i64) -> i64
  %1067 = "llvm.getelementptr"(%arg63) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 51>}> : (!llvm.ptr) -> !llvm.ptr
  %1068 = "llvm.load"(%1067) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1069 = "llvm.zext"(%1068) : (i8) -> i64
  %1070 = "llvm.shl"(%1069, %906) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1071 = "llvm.or"(%1070, %1066) : (i64, i64) -> i64
  %1072 = "llvm.getelementptr"(%arg63) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 52>}> : (!llvm.ptr) -> !llvm.ptr
  %1073 = "llvm.load"(%1072) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i16
  %1074 = "llvm.zext"(%1073) : (i16) -> i64
  %1075 = "llvm.shl"(%1074, %907) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1076 = "llvm.getelementptr"(%arg63) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 54>}> : (!llvm.ptr) -> !llvm.ptr
  %1077 = "llvm.load"(%1076) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i16
  %1078 = "llvm.zext"(%1077) : (i16) -> i64
  %1079 = "llvm.shl"(%1078, %909) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %1080 = "llvm.or"(%1075, %1079) <{isDisjoint}> : (i64, i64) -> i64
  %1081 = "llvm.or"(%1080, %1071) : (i64, i64) -> i64
  "llvm.store"(%1081, %931) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %1082 = "llvm.getelementptr"(%arg63) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 56>}> : (!llvm.ptr) -> !llvm.ptr
  %1083 = "llvm.load"(%932) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1084 = "llvm.load"(%1082) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1085 = "llvm.zext"(%1084) : (i8) -> i64
  %1086 = "llvm.or"(%1083, %1085) : (i64, i64) -> i64
  %1087 = "llvm.getelementptr"(%arg63) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 57>}> : (!llvm.ptr) -> !llvm.ptr
  %1088 = "llvm.load"(%1087) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1089 = "llvm.zext"(%1088) : (i8) -> i64
  %1090 = "llvm.shl"(%1089, %904) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1091 = "llvm.or"(%1090, %1086) : (i64, i64) -> i64
  %1092 = "llvm.getelementptr"(%arg63) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 58>}> : (!llvm.ptr) -> !llvm.ptr
  %1093 = "llvm.load"(%1092) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1094 = "llvm.zext"(%1093) : (i8) -> i64
  %1095 = "llvm.shl"(%1094, %905) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1096 = "llvm.or"(%1095, %1091) : (i64, i64) -> i64
  %1097 = "llvm.getelementptr"(%arg63) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 59>}> : (!llvm.ptr) -> !llvm.ptr
  %1098 = "llvm.load"(%1097) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1099 = "llvm.zext"(%1098) : (i8) -> i64
  %1100 = "llvm.shl"(%1099, %906) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1101 = "llvm.getelementptr"(%arg63) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 60>}> : (!llvm.ptr) -> !llvm.ptr
  %1102 = "llvm.load"(%1101) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i16
  %1103 = "llvm.zext"(%1102) : (i16) -> i64
  %1104 = "llvm.shl"(%1103, %907) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %1105 = "llvm.or"(%1100, %1104) <{isDisjoint}> : (i64, i64) -> i64
  %1106 = "llvm.getelementptr"(%arg63) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 62>}> : (!llvm.ptr) -> !llvm.ptr
  %1107 = "llvm.load"(%1106) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i16
  %1108 = "llvm.zext"(%1107) : (i16) -> i64
  %1109 = "llvm.shl"(%1108, %909) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %1110 = "llvm.or"(%1105, %1109) <{isDisjoint}> : (i64, i64) -> i64
  %1111 = "llvm.or"(%1110, %1096) : (i64, i64) -> i64
  "llvm.store"(%1111, %932) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%924) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%923) : (!llvm.ptr) -> ()
  %1112 = "llvm.load"(%925) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1113 = "llvm.and"(%1112, %912) : (i64, i64) -> i64
  "llvm.store"(%1113, %924) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %1114 = "llvm.load"(%926) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1115 = "llvm.intr.fshl"(%1114, %1112, %913) : (i64, i64, i64) -> i64
  %1116 = "llvm.getelementptr"(%924) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %1117 = "llvm.and"(%1115, %912) : (i64, i64) -> i64
  "llvm.store"(%1117, %1116) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %1118 = "llvm.load"(%927) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1119 = "llvm.intr.fshl"(%1118, %1114, %906) : (i64, i64, i64) -> i64
  %1120 = "llvm.getelementptr"(%924) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %1121 = "llvm.and"(%1119, %912) : (i64, i64) -> i64
  "llvm.store"(%1121, %1120) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %1122 = "llvm.load"(%928) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1123 = "llvm.intr.fshl"(%1122, %1118, %911) : (i64, i64, i64) -> i64
  %1124 = "llvm.getelementptr"(%924) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %1125 = "llvm.and"(%1123, %912) : (i64, i64) -> i64
  "llvm.store"(%1125, %1124) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %1126 = "llvm.load"(%929) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1127 = "llvm.intr.fshl"(%1126, %1122, %909) : (i64, i64, i64) -> i64
  %1128 = "llvm.getelementptr"(%924) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %1129 = "llvm.and"(%1127, %912) : (i64, i64) -> i64
  "llvm.store"(%1129, %1128) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %1130 = "llvm.lshr"(%1126, %914) : (i64, i64) -> i64
  %1131 = "llvm.and"(%1130, %912) : (i64, i64) -> i64
  "llvm.store"(%1131, %923) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %1132 = "llvm.intr.fshl"(%1041, %1126, %904) : (i64, i64, i64) -> i64
  %1133 = "llvm.getelementptr"(%923) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %1134 = "llvm.and"(%1132, %912) : (i64, i64) -> i64
  "llvm.store"(%1134, %1133) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %1135 = "llvm.intr.fshl"(%1071, %1051, %915) : (i64, i64, i64) -> i64
  %1136 = "llvm.getelementptr"(%923) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %1137 = "llvm.and"(%1135, %912) : (i64, i64) -> i64
  "llvm.store"(%1137, %1136) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %1138 = "llvm.intr.fshl"(%1096, %1081, %907) : (i64, i64, i64) -> i64
  %1139 = "llvm.getelementptr"(%923) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %1140 = "llvm.and"(%1138, %912) : (i64, i64) -> i64
  "llvm.store"(%1140, %1139) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %1141 = "llvm.getelementptr"(%923) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %1142 = "llvm.lshr"(%1111, %915) : (i64, i64) -> i64
  "llvm.store"(%1142, %1141) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%922) : (!llvm.ptr) -> ()
  "llvm.call"(%922, %924, %916) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nofree, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nofree, llvm.noundef, llvm.readonly}], callee = @_RNvMs2_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u646scalarNtB5_8Scalar5214montgomery_mul, fastmathFlags = #llvm.fastmath<none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.intr.memcpy"(%924, %922, %908) <{arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.intr.lifetime.end"(%922) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%921) : (!llvm.ptr) -> ()
  "llvm.call"(%921, %923, %917) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nofree, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nofree, llvm.noundef, llvm.readonly}], callee = @_RNvMs2_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u646scalarNtB5_8Scalar5214montgomery_mul, fastmathFlags = #llvm.fastmath<none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.intr.memcpy"(%923, %921, %908) <{arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.intr.lifetime.end"(%921) : (!llvm.ptr) -> ()
  "llvm.call"(%arg62, %923, %924) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nofree, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nofree, llvm.noundef, llvm.readonly}], callee = @_RNvMs2_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u646scalarNtB5_8Scalar523add, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.store"(%903, %925) <{alias_scopes = [#alias_scope23], alignment = 8 : i64, noalias_scopes = [#alias_scope24], ordering = 0 : i64, volatile_}> : (i64, !llvm.ptr) -> ()
  "llvm.fence"() <{ordering = 7 : i64, syncscope = "singlethread"}> : () -> ()
  "llvm.store"(%903, %926) <{alias_scopes = [#alias_scope23], alignment = 8 : i64, noalias_scopes = [#alias_scope24], ordering = 0 : i64, volatile_}> : (i64, !llvm.ptr) -> ()
  "llvm.fence"() <{ordering = 7 : i64, syncscope = "singlethread"}> : () -> ()
  "llvm.store"(%903, %927) <{alias_scopes = [#alias_scope23], alignment = 8 : i64, noalias_scopes = [#alias_scope24], ordering = 0 : i64, volatile_}> : (i64, !llvm.ptr) -> ()
  "llvm.fence"() <{ordering = 7 : i64, syncscope = "singlethread"}> : () -> ()
  "llvm.store"(%903, %928) <{alias_scopes = [#alias_scope23], alignment = 8 : i64, noalias_scopes = [#alias_scope24], ordering = 0 : i64, volatile_}> : (i64, !llvm.ptr) -> ()
  "llvm.fence"() <{ordering = 7 : i64, syncscope = "singlethread"}> : () -> ()
  "llvm.store"(%903, %929) <{alias_scopes = [#alias_scope23], alignment = 8 : i64, noalias_scopes = [#alias_scope24], ordering = 0 : i64, volatile_}> : (i64, !llvm.ptr) -> ()
  "llvm.fence"() <{ordering = 7 : i64, syncscope = "singlethread"}> : () -> ()
  "llvm.store"(%903, %930) <{alias_scopes = [#alias_scope23], alignment = 8 : i64, noalias_scopes = [#alias_scope24], ordering = 0 : i64, volatile_}> : (i64, !llvm.ptr) -> ()
  "llvm.fence"() <{ordering = 7 : i64, syncscope = "singlethread"}> : () -> ()
  "llvm.store"(%903, %931) <{alias_scopes = [#alias_scope23], alignment = 8 : i64, noalias_scopes = [#alias_scope24], ordering = 0 : i64, volatile_}> : (i64, !llvm.ptr) -> ()
  "llvm.fence"() <{ordering = 7 : i64, syncscope = "singlethread"}> : () -> ()
  "llvm.store"(%903, %932) <{alias_scopes = [#alias_scope23], alignment = 8 : i64, noalias_scopes = [#alias_scope24], ordering = 0 : i64, volatile_}> : (i64, !llvm.ptr) -> ()
  "llvm.fence"() <{ordering = 7 : i64, syncscope = "singlethread"}> : () -> ()
  "llvm.intr.lifetime.start"(%920) : (!llvm.ptr) -> ()
  "llvm.intr.memset"(%920, %918, %908) <{alias_scopes = [#alias_scope25], arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.nonnull, llvm.noundef}, {}, {}], isVolatile = false, noalias_scopes = [#alias_scope26]}> : (!llvm.ptr, i8, i64) -> ()
  "llvm.intr.memcpy"(%924, %920, %908) <{arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.nonnull}, {llvm.align = 8 : i64, llvm.nonnull}, {}], isVolatile = true}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.intr.lifetime.end"(%920) : (!llvm.ptr) -> ()
  "llvm.fence"() <{ordering = 7 : i64, syncscope = "singlethread"}> : () -> ()
  "llvm.intr.lifetime.start"(%919) : (!llvm.ptr) -> ()
  "llvm.intr.memset"(%919, %918, %908) <{alias_scopes = [#alias_scope27], arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.nonnull, llvm.noundef}, {}, {}], isVolatile = false, noalias_scopes = [#alias_scope28]}> : (!llvm.ptr, i8, i64) -> ()
  "llvm.intr.memcpy"(%923, %919, %908) <{arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.nonnull}, {llvm.align = 8 : i64, llvm.nonnull}, {}], isVolatile = true}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.intr.lifetime.end"(%919) : (!llvm.ptr) -> ()
  "llvm.fence"() <{ordering = 7 : i64, syncscope = "singlethread"}> : () -> ()
  "llvm.intr.lifetime.end"(%923) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%924) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%925) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%926) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%927) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%928) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%929) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%930) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%931) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%932) : (!llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()
  with
    @_RNvMs2_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u646scalarNtB5_8Scalar5214montgomery_mul := Scalar52_montgomery_mul,
    @_RNvMs2_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u646scalarNtB5_8Scalar523add := Scalar52_add,
    @anon.042b818bc72209407b52bd0e4d6c8368.40 := anon_042b818bc72209407b52bd0e4d6c8368_40,
    @anon.042b818bc72209407b52bd0e4d6c8368.41 := anon_042b818bc72209407b52bd0e4d6c8368_41

end

end MLIR.Agave.Serial
