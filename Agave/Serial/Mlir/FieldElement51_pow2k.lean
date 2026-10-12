module

-- agave-build/out/serial-noinline-big/op/_RNvMs8_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u645fieldNtB5_14FieldElement515pow2k.mlir
-- <solana_ed25519[1fe0933b11699477]::backend::serial::u64::field::FieldElement51>::pow2k

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

namespace MLIR.Agave.Serial

@[expose] public section

mlir_def FieldElement51_pow2k :=
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.align = 8 : i64, llvm.dead_on_unwind, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.writable, llvm.writeonly}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.noundef, llvm.range = #llvm.constant_range<i32, 1, 101>}], dso_local, function_type = !llvm.func<void (ptr, ptr, i32)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, passthrough = ["nofree", "norecurse", "nosync", "nonlazybind", ["probe-stack", "inline-asm"], ["target-cpu", "x86-64-v2"]], sym_name = "_RNvMs8_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u645fieldNtB5_14FieldElement515pow2k", target_cpu = "x86-64-v2", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg84: !llvm.ptr, %arg85: !llvm.ptr, %arg86: i32):
  %2074 = "llvm.mlir.constant"() <{value = 19 : i64}> : () -> i64
  %2075 = "llvm.mlir.constant"() <{value = 1 : i128}> : () -> i128
  %2076 = "llvm.mlir.constant"() <{value = 51 : i128}> : () -> i128
  %2077 = "llvm.mlir.constant"() <{value = 18446744073709551615 : i128}> : () -> i128
  %2078 = "llvm.mlir.constant"() <{value = 2251799813685247 : i64}> : () -> i64
  %2079 = "llvm.mlir.constant"() <{value = 51 : i64}> : () -> i64
  %2080 = "llvm.mlir.constant"() <{value = -1 : i32}> : () -> i32
  %2081 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %2082 = "llvm.load"(%arg85) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %2083 = "llvm.getelementptr"(%arg85) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %2084 = "llvm.load"(%2083) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %2085 = "llvm.getelementptr"(%arg85) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %2086 = "llvm.load"(%2085) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %2087 = "llvm.getelementptr"(%arg85) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %2088 = "llvm.load"(%2087) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %2089 = "llvm.getelementptr"(%arg85) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %2090 = "llvm.load"(%2089) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  "llvm.br"(%2090, %2088, %2086, %2084, %2082, %arg86)[^bb1] : (i64, i64, i64, i64, i64, i32) -> ()
^bb1(%2091: i64, %2092: i64, %2093: i64, %2094: i64, %2095: i64, %2096: i32):  // 2 preds: ^bb0, ^bb1
  %2097 = "llvm.mul"(%2092, %2074) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %2098 = "llvm.mul"(%2091, %2074) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %2099 = "llvm.zext"(%2095) : (i64) -> i128
  %2100 = "llvm.mul"(%2099, %2099) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2101 = "llvm.zext"(%2094) : (i64) -> i128
  %2102 = "llvm.zext"(%2098) : (i64) -> i128
  %2103 = "llvm.mul"(%2101, %2102) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2104 = "llvm.zext"(%2093) : (i64) -> i128
  %2105 = "llvm.zext"(%2097) : (i64) -> i128
  %2106 = "llvm.mul"(%2104, %2105) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2107 = "llvm.add"(%2103, %2106) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2108 = "llvm.shl"(%2107, %2075) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2109 = "llvm.add"(%2108, %2100) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2110 = "llvm.zext"(%2092) : (i64) -> i128
  %2111 = "llvm.mul"(%2105, %2110) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2112 = "llvm.mul"(%2099, %2101) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2113 = "llvm.mul"(%2104, %2102) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2114 = "llvm.add"(%2112, %2113) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2115 = "llvm.shl"(%2114, %2075) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2116 = "llvm.add"(%2115, %2111) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2117 = "llvm.mul"(%2101, %2101) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2118 = "llvm.mul"(%2099, %2104) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2119 = "llvm.zext"(%2091) : (i64) -> i128
  %2120 = "llvm.mul"(%2105, %2119) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2121 = "llvm.add"(%2118, %2120) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2122 = "llvm.shl"(%2121, %2075) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2123 = "llvm.add"(%2122, %2117) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2124 = "llvm.mul"(%2102, %2119) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2125 = "llvm.mul"(%2099, %2110) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2126 = "llvm.mul"(%2101, %2104) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2127 = "llvm.add"(%2125, %2126) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2128 = "llvm.shl"(%2127, %2075) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2129 = "llvm.add"(%2128, %2124) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2130 = "llvm.mul"(%2104, %2104) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2131 = "llvm.mul"(%2099, %2119) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2132 = "llvm.mul"(%2101, %2110) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2133 = "llvm.add"(%2131, %2132) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2134 = "llvm.shl"(%2133, %2075) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2135 = "llvm.add"(%2134, %2130) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2136 = "llvm.lshr"(%2109, %2076) : (i128, i128) -> i128
  %2137 = "llvm.and"(%2136, %2077) : (i128, i128) -> i128
  %2138 = "llvm.add"(%2116, %2137) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2139 = "llvm.trunc"(%2109) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %2140 = "llvm.and"(%2139, %2078) : (i64, i64) -> i64
  %2141 = "llvm.lshr"(%2138, %2076) : (i128, i128) -> i128
  %2142 = "llvm.and"(%2141, %2077) : (i128, i128) -> i128
  %2143 = "llvm.add"(%2123, %2142) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2144 = "llvm.trunc"(%2138) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %2145 = "llvm.and"(%2144, %2078) : (i64, i64) -> i64
  %2146 = "llvm.lshr"(%2143, %2076) : (i128, i128) -> i128
  %2147 = "llvm.and"(%2146, %2077) : (i128, i128) -> i128
  %2148 = "llvm.add"(%2129, %2147) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2149 = "llvm.trunc"(%2143) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %2150 = "llvm.and"(%2149, %2078) : (i64, i64) -> i64
  %2151 = "llvm.lshr"(%2148, %2076) : (i128, i128) -> i128
  %2152 = "llvm.and"(%2151, %2077) : (i128, i128) -> i128
  %2153 = "llvm.add"(%2135, %2152) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2154 = "llvm.trunc"(%2148) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %2155 = "llvm.and"(%2154, %2078) : (i64, i64) -> i64
  %2156 = "llvm.lshr"(%2153, %2076) : (i128, i128) -> i128
  %2157 = "llvm.trunc"(%2156) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %2158 = "llvm.trunc"(%2153) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %2159 = "llvm.and"(%2158, %2078) : (i64, i64) -> i64
  %2160 = "llvm.mul"(%2157, %2074) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %2161 = "llvm.add"(%2160, %2140) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %2162 = "llvm.lshr"(%2161, %2079) : (i64, i64) -> i64
  %2163 = "llvm.add"(%2162, %2145) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %2164 = "llvm.and"(%2161, %2078) : (i64, i64) -> i64
  %2165 = "llvm.add"(%2096, %2080) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %2166 = "llvm.icmp"(%2165, %2081) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%2166, %2150, %2155, %2159, %2163, %2164, %2159, %2155, %2150, %2163, %2164, %2165)[^bb2, ^bb1] <{operandSegmentSizes = array<i32: 1, 5, 6>}> : (i1, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i32) -> ()
^bb2(%2167: i64, %2168: i64, %2169: i64, %2170: i64, %2171: i64):  // pred: ^bb1
  "llvm.store"(%2171, %arg84) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %2172 = "llvm.getelementptr"(%arg84) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2170, %2172) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %2173 = "llvm.getelementptr"(%arg84) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2167, %2173) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %2174 = "llvm.getelementptr"(%arg84) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2168, %2174) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %2175 = "llvm.getelementptr"(%arg84) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2169, %2175) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()

end

end MLIR.Agave.Serial
