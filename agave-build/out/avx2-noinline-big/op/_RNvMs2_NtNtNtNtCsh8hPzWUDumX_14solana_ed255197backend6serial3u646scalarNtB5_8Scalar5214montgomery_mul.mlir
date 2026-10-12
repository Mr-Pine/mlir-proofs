#alias_scope_domain54 = #llvm.alias_scope_domain<id = distinct[54]<>, description = "_RNvMs2_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6serial3u646scalarNtB5_8Scalar5212mul_internal">
#alias_scope_domain55 = #llvm.alias_scope_domain<id = distinct[55]<>, description = "_RNvMs2_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6serial3u646scalarNtB5_8Scalar5217montgomery_reduce">
#alias_scope_domain56 = #llvm.alias_scope_domain<id = distinct[56]<>, description = "_RNvXCshxoft6be3N1_7zeroizeoNtB2_7Zeroize7zeroizeCsh8hPzWUDumX_14solana_ed25519">
#alias_scope_domain57 = #llvm.alias_scope_domain<id = distinct[57]<>, description = "_RNvXs4_Cshxoft6be3N1_7zeroizeINtNtNtCsgxBkk5gSRhY_4core5slice4iter7IterMutoENtB5_7Zeroize7zeroizeCsh8hPzWUDumX_14solana_ed25519">
#alias_scope73 = #llvm.alias_scope<id = distinct[202]<>, domain = #alias_scope_domain54, description = "_RNvMs2_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6serial3u646scalarNtB5_8Scalar5212mul_internal: argument 0">
#alias_scope74 = #llvm.alias_scope<id = distinct[203]<>, domain = #alias_scope_domain54, description = "_RNvMs2_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6serial3u646scalarNtB5_8Scalar5212mul_internal: argument 1">
#alias_scope75 = #llvm.alias_scope<id = distinct[204]<>, domain = #alias_scope_domain54, description = "_RNvMs2_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6serial3u646scalarNtB5_8Scalar5212mul_internal: argument 2">
#alias_scope76 = #llvm.alias_scope<id = distinct[205]<>, domain = #alias_scope_domain55, description = "_RNvMs2_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6serial3u646scalarNtB5_8Scalar5217montgomery_reduce: argument 0">
#alias_scope77 = #llvm.alias_scope<id = distinct[206]<>, domain = #alias_scope_domain55, description = "_RNvMs2_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6serial3u646scalarNtB5_8Scalar5217montgomery_reduce: argument 1">
#alias_scope78 = #llvm.alias_scope<id = distinct[207]<>, domain = #alias_scope_domain56, description = "_RNvXCshxoft6be3N1_7zeroizeoNtB2_7Zeroize7zeroizeCsh8hPzWUDumX_14solana_ed25519: argument 0">
#alias_scope79 = #llvm.alias_scope<id = distinct[208]<>, domain = #alias_scope_domain57, description = "_RNvXs4_Cshxoft6be3N1_7zeroizeINtNtNtCsgxBkk5gSRhY_4core5slice4iter7IterMutoENtB5_7Zeroize7zeroizeCsh8hPzWUDumX_14solana_ed25519: argument 0">
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.align = 8 : i64, llvm.dead_on_unwind, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.writable, llvm.writeonly}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<void (ptr, ptr, ptr)>, linkage = #llvm.linkage<internal>, no_inline, no_unwind, passthrough = ["nofree", "norecurse", "nonlazybind", ["probe-stack", "inline-asm"], ["target-cpu", "x86-64-v2"]], sym_name = "_RNvMs2_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6serial3u646scalarNtB5_8Scalar5214montgomery_mul", target_cpu = "x86-64-v2", target_features = #llvm.target_features<["+avx", "+avx2", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+crc32", "+ssse3"]>, unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg72: !llvm.ptr, %arg73: !llvm.ptr, %arg74: !llvm.ptr):
  %2169 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %2170 = "llvm.mlir.constant"() <{value = 1439961107955227 : i64}> : () -> i64
  %2171 = "llvm.mlir.constant"() <{value = 4503599627370495 : i64}> : () -> i64
  %2172 = "llvm.mlir.constant"() <{value = 671914833335277 : i128}> : () -> i128
  %2173 = "llvm.mlir.constant"() <{value = 52 : i128}> : () -> i128
  %2174 = "llvm.mlir.constant"() <{value = 3916664325105025 : i128}> : () -> i128
  %2175 = "llvm.mlir.constant"() <{value = 1367801 : i128}> : () -> i128
  %2176 = "llvm.mlir.constant"() <{value = 44 : i128}> : () -> i128
  %2177 = "llvm.mlir.constant"() <{value = 0 : i128}> : () -> i128
  %2178 = "llvm.alloca"(%2169) <{alignment = 8 : i64, elem_type = !llvm.array<40 x i8>}> : (i32) -> !llvm.ptr
  %2179 = "llvm.alloca"(%2169) <{alignment = 16 : i64, elem_type = i128}> : (i32) -> !llvm.ptr
  %2180 = "llvm.alloca"(%2169) <{alignment = 16 : i64, elem_type = i128}> : (i32) -> !llvm.ptr
  %2181 = "llvm.alloca"(%2169) <{alignment = 16 : i64, elem_type = i128}> : (i32) -> !llvm.ptr
  %2182 = "llvm.alloca"(%2169) <{alignment = 16 : i64, elem_type = i128}> : (i32) -> !llvm.ptr
  %2183 = "llvm.alloca"(%2169) <{alignment = 16 : i64, elem_type = i128}> : (i32) -> !llvm.ptr
  %2184 = "llvm.alloca"(%2169) <{alignment = 16 : i64, elem_type = i128}> : (i32) -> !llvm.ptr
  %2185 = "llvm.alloca"(%2169) <{alignment = 16 : i64, elem_type = i128}> : (i32) -> !llvm.ptr
  %2186 = "llvm.alloca"(%2169) <{alignment = 16 : i64, elem_type = i128}> : (i32) -> !llvm.ptr
  %2187 = "llvm.alloca"(%2169) <{alignment = 16 : i64, elem_type = i128}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%2179) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2180) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2181) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2182) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2183) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2184) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2185) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2186) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%2187) : (!llvm.ptr) -> ()
  "llvm.intr.experimental.noalias.scope.decl"() <{scope = #alias_scope73}> : () -> ()
  "llvm.intr.experimental.noalias.scope.decl"() <{scope = #alias_scope74}> : () -> ()
  "llvm.intr.experimental.noalias.scope.decl"() <{scope = #alias_scope75}> : () -> ()
  %2188 = "llvm.load"(%arg73) <{alias_scopes = [#alias_scope74], alignment = 8 : i64, noalias_scopes = [#alias_scope73, #alias_scope75], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %2189 = "llvm.load"(%arg74) <{alias_scopes = [#alias_scope75], alignment = 8 : i64, noalias_scopes = [#alias_scope73, #alias_scope74], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %2190 = "llvm.zext"(%2188) : (i64) -> i128
  %2191 = "llvm.zext"(%2189) : (i64) -> i128
  %2192 = "llvm.mul"(%2191, %2190) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2193 = "llvm.getelementptr"(%arg74) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %2194 = "llvm.load"(%2193) <{alias_scopes = [#alias_scope75], alignment = 8 : i64, noalias_scopes = [#alias_scope73, #alias_scope74], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %2195 = "llvm.zext"(%2194) : (i64) -> i128
  %2196 = "llvm.mul"(%2195, %2190) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2197 = "llvm.getelementptr"(%arg73) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %2198 = "llvm.load"(%2197) <{alias_scopes = [#alias_scope74], alignment = 8 : i64, noalias_scopes = [#alias_scope73, #alias_scope75], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %2199 = "llvm.zext"(%2198) : (i64) -> i128
  %2200 = "llvm.mul"(%2199, %2191) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2201 = "llvm.add"(%2200, %2196) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  "llvm.store"(%2201, %2180) <{alias_scopes = [#alias_scope73], alignment = 16 : i64, noalias_scopes = [#alias_scope74, #alias_scope75], ordering = 0 : i64}> : (i128, !llvm.ptr) -> ()
  %2202 = "llvm.getelementptr"(%arg74) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %2203 = "llvm.load"(%2202) <{alias_scopes = [#alias_scope75], alignment = 8 : i64, noalias_scopes = [#alias_scope73, #alias_scope74], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %2204 = "llvm.zext"(%2203) : (i64) -> i128
  %2205 = "llvm.mul"(%2204, %2190) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2206 = "llvm.mul"(%2199, %2195) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2207 = "llvm.add"(%2205, %2206) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2208 = "llvm.getelementptr"(%arg73) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %2209 = "llvm.load"(%2208) <{alias_scopes = [#alias_scope74], alignment = 8 : i64, noalias_scopes = [#alias_scope73, #alias_scope75], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %2210 = "llvm.zext"(%2209) : (i64) -> i128
  %2211 = "llvm.mul"(%2210, %2191) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2212 = "llvm.add"(%2207, %2211) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  "llvm.store"(%2212, %2181) <{alias_scopes = [#alias_scope73], alignment = 16 : i64, noalias_scopes = [#alias_scope74, #alias_scope75], ordering = 0 : i64}> : (i128, !llvm.ptr) -> ()
  %2213 = "llvm.getelementptr"(%arg74) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %2214 = "llvm.load"(%2213) <{alias_scopes = [#alias_scope75], alignment = 8 : i64, noalias_scopes = [#alias_scope73, #alias_scope74], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %2215 = "llvm.zext"(%2214) : (i64) -> i128
  %2216 = "llvm.mul"(%2215, %2190) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2217 = "llvm.mul"(%2204, %2199) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2218 = "llvm.mul"(%2210, %2195) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2219 = "llvm.getelementptr"(%arg73) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %2220 = "llvm.load"(%2219) <{alias_scopes = [#alias_scope74], alignment = 8 : i64, noalias_scopes = [#alias_scope73, #alias_scope75], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %2221 = "llvm.zext"(%2220) : (i64) -> i128
  %2222 = "llvm.mul"(%2221, %2191) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2223 = "llvm.add"(%2218, %2217) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2224 = "llvm.add"(%2223, %2216) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2225 = "llvm.add"(%2224, %2222) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  "llvm.store"(%2225, %2182) <{alias_scopes = [#alias_scope73], alignment = 16 : i64, noalias_scopes = [#alias_scope74, #alias_scope75], ordering = 0 : i64}> : (i128, !llvm.ptr) -> ()
  %2226 = "llvm.getelementptr"(%arg74) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %2227 = "llvm.load"(%2226) <{alias_scopes = [#alias_scope75], alignment = 8 : i64, noalias_scopes = [#alias_scope73, #alias_scope74], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %2228 = "llvm.zext"(%2227) : (i64) -> i128
  %2229 = "llvm.mul"(%2228, %2190) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2230 = "llvm.mul"(%2215, %2199) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2231 = "llvm.mul"(%2210, %2204) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2232 = "llvm.mul"(%2221, %2195) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2233 = "llvm.getelementptr"(%arg73) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %2234 = "llvm.load"(%2233) <{alias_scopes = [#alias_scope74], alignment = 8 : i64, noalias_scopes = [#alias_scope73, #alias_scope75], ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %2235 = "llvm.zext"(%2234) : (i64) -> i128
  %2236 = "llvm.mul"(%2235, %2191) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2237 = "llvm.add"(%2230, %2231) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2238 = "llvm.add"(%2237, %2232) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2239 = "llvm.add"(%2238, %2229) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2240 = "llvm.add"(%2239, %2236) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  "llvm.store"(%2240, %2183) <{alias_scopes = [#alias_scope73], alignment = 16 : i64, noalias_scopes = [#alias_scope74, #alias_scope75], ordering = 0 : i64}> : (i128, !llvm.ptr) -> ()
  %2241 = "llvm.mul"(%2228, %2199) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2242 = "llvm.mul"(%2215, %2210) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2243 = "llvm.mul"(%2221, %2204) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2244 = "llvm.mul"(%2235, %2195) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2245 = "llvm.add"(%2243, %2242) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2246 = "llvm.add"(%2245, %2241) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2247 = "llvm.add"(%2246, %2244) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  "llvm.store"(%2247, %2184) <{alias_scopes = [#alias_scope73], alignment = 16 : i64, noalias_scopes = [#alias_scope74, #alias_scope75], ordering = 0 : i64}> : (i128, !llvm.ptr) -> ()
  %2248 = "llvm.mul"(%2228, %2210) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2249 = "llvm.mul"(%2221, %2215) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2250 = "llvm.add"(%2248, %2249) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2251 = "llvm.mul"(%2235, %2204) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2252 = "llvm.add"(%2250, %2251) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  "llvm.store"(%2252, %2185) <{alias_scopes = [#alias_scope73], alignment = 16 : i64, noalias_scopes = [#alias_scope74, #alias_scope75], ordering = 0 : i64}> : (i128, !llvm.ptr) -> ()
  %2253 = "llvm.mul"(%2228, %2221) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2254 = "llvm.mul"(%2235, %2215) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2255 = "llvm.add"(%2254, %2253) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  "llvm.store"(%2255, %2186) <{alias_scopes = [#alias_scope73], alignment = 16 : i64, noalias_scopes = [#alias_scope74, #alias_scope75], ordering = 0 : i64}> : (i128, !llvm.ptr) -> ()
  %2256 = "llvm.mul"(%2235, %2228) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  "llvm.store"(%2256, %2187) <{alias_scopes = [#alias_scope73], alignment = 16 : i64, noalias_scopes = [#alias_scope74, #alias_scope75], ordering = 0 : i64}> : (i128, !llvm.ptr) -> ()
  %2257 = "llvm.trunc"(%2192) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %2258 = "llvm.mul"(%2257, %2170) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %2259 = "llvm.and"(%2258, %2171) : (i64, i64) -> i64
  %2260 = "llvm.zext"(%2259) <{nonNeg}> : (i64) -> i128
  %2261 = "llvm.mul"(%2260, %2172) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %2262 = "llvm.add"(%2261, %2192) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2263 = "llvm.lshr"(%2262, %2173) : (i128, i128) -> i128
  %2264 = "llvm.mul"(%2260, %2174) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %2265 = "llvm.add"(%2264, %2201) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2266 = "llvm.add"(%2265, %2263) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2267 = "llvm.trunc"(%2266) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %2268 = "llvm.mul"(%2267, %2170) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %2269 = "llvm.and"(%2268, %2171) : (i64, i64) -> i64
  %2270 = "llvm.zext"(%2269) <{nonNeg}> : (i64) -> i128
  %2271 = "llvm.mul"(%2270, %2172) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %2272 = "llvm.add"(%2271, %2266) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2273 = "llvm.lshr"(%2272, %2173) : (i128, i128) -> i128
  %2274 = "llvm.mul"(%2260, %2175) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %2275 = "llvm.mul"(%2270, %2174) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %2276 = "llvm.add"(%2212, %2274) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2277 = "llvm.add"(%2276, %2275) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2278 = "llvm.add"(%2277, %2273) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2279 = "llvm.trunc"(%2278) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %2280 = "llvm.mul"(%2279, %2170) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %2281 = "llvm.and"(%2280, %2171) : (i64, i64) -> i64
  %2282 = "llvm.zext"(%2281) <{nonNeg}> : (i64) -> i128
  %2283 = "llvm.mul"(%2282, %2172) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %2284 = "llvm.add"(%2283, %2278) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2285 = "llvm.lshr"(%2284, %2173) : (i128, i128) -> i128
  %2286 = "llvm.mul"(%2270, %2175) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %2287 = "llvm.mul"(%2282, %2174) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %2288 = "llvm.add"(%2286, %2225) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2289 = "llvm.add"(%2288, %2287) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2290 = "llvm.add"(%2289, %2285) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2291 = "llvm.trunc"(%2290) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %2292 = "llvm.mul"(%2291, %2170) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %2293 = "llvm.and"(%2292, %2171) : (i64, i64) -> i64
  %2294 = "llvm.zext"(%2293) <{nonNeg}> : (i64) -> i128
  %2295 = "llvm.mul"(%2294, %2172) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %2296 = "llvm.add"(%2295, %2290) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2297 = "llvm.lshr"(%2296, %2173) : (i128, i128) -> i128
  %2298 = "llvm.shl"(%2260, %2176) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %2299 = "llvm.mul"(%2282, %2175) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %2300 = "llvm.mul"(%2294, %2174) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %2301 = "llvm.add"(%2240, %2298) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2302 = "llvm.add"(%2301, %2299) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2303 = "llvm.add"(%2302, %2300) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2304 = "llvm.add"(%2303, %2297) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2305 = "llvm.trunc"(%2304) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %2306 = "llvm.mul"(%2305, %2170) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %2307 = "llvm.and"(%2306, %2171) : (i64, i64) -> i64
  %2308 = "llvm.zext"(%2307) <{nonNeg}> : (i64) -> i128
  %2309 = "llvm.mul"(%2308, %2172) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %2310 = "llvm.add"(%2309, %2304) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2311 = "llvm.lshr"(%2310, %2173) : (i128, i128) -> i128
  %2312 = "llvm.shl"(%2270, %2176) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %2313 = "llvm.mul"(%2294, %2175) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %2314 = "llvm.mul"(%2308, %2174) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %2315 = "llvm.add"(%2312, %2247) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2316 = "llvm.add"(%2315, %2313) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2317 = "llvm.add"(%2316, %2314) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2318 = "llvm.add"(%2317, %2311) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2319 = "llvm.trunc"(%2318) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %2320 = "llvm.and"(%2319, %2171) : (i64, i64) -> i64
  %2321 = "llvm.lshr"(%2318, %2173) : (i128, i128) -> i128
  %2322 = "llvm.shl"(%2282, %2176) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %2323 = "llvm.mul"(%2308, %2175) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %2324 = "llvm.add"(%2322, %2252) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2325 = "llvm.add"(%2324, %2323) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2326 = "llvm.add"(%2325, %2321) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2327 = "llvm.trunc"(%2326) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %2328 = "llvm.and"(%2327, %2171) : (i64, i64) -> i64
  %2329 = "llvm.lshr"(%2326, %2173) : (i128, i128) -> i128
  %2330 = "llvm.shl"(%2294, %2176) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %2331 = "llvm.add"(%2330, %2255) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2332 = "llvm.add"(%2331, %2329) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2333 = "llvm.trunc"(%2332) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %2334 = "llvm.and"(%2333, %2171) : (i64, i64) -> i64
  %2335 = "llvm.lshr"(%2332, %2173) : (i128, i128) -> i128
  %2336 = "llvm.shl"(%2308, %2176) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %2337 = "llvm.add"(%2336, %2256) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2338 = "llvm.add"(%2337, %2335) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2339 = "llvm.trunc"(%2338) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %2340 = "llvm.and"(%2339, %2171) : (i64, i64) -> i64
  %2341 = "llvm.lshr"(%2338, %2173) : (i128, i128) -> i128
  %2342 = "llvm.trunc"(%2341) <{overflowFlags = 0 : i32}> : (i128) -> i64
  "llvm.intr.lifetime.start"(%2178) : (!llvm.ptr) -> ()
  "llvm.store"(%2320, %2178) <{alignment = 8 : i64, noalias_scopes = [#alias_scope76, #alias_scope77], ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %2343 = "llvm.getelementptr"(%2178) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2328, %2343) <{alignment = 8 : i64, noalias_scopes = [#alias_scope76, #alias_scope77], ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %2344 = "llvm.getelementptr"(%2178) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2334, %2344) <{alignment = 8 : i64, noalias_scopes = [#alias_scope76, #alias_scope77], ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %2345 = "llvm.getelementptr"(%2178) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2340, %2345) <{alignment = 8 : i64, noalias_scopes = [#alias_scope76, #alias_scope77], ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %2346 = "llvm.getelementptr"(%2178) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2342, %2346) <{alignment = 8 : i64, noalias_scopes = [#alias_scope76, #alias_scope77], ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  "llvm.call"(%arg72, %2178) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], callee = @_RNvMs2_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6serial3u646scalarNtB5_8Scalar523sub, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2178) : (!llvm.ptr) -> ()
  "llvm.store"(%2177, %2179) <{alias_scopes = [#alias_scope78], alignment = 16 : i64, noalias_scopes = [#alias_scope79], ordering = 0 : i64, volatile_}> : (i128, !llvm.ptr) -> ()
  "llvm.fence"() <{ordering = 7 : i64, syncscope = "singlethread"}> : () -> ()
  "llvm.store"(%2177, %2180) <{alias_scopes = [#alias_scope78], alignment = 16 : i64, noalias_scopes = [#alias_scope79], ordering = 0 : i64, volatile_}> : (i128, !llvm.ptr) -> ()
  "llvm.fence"() <{ordering = 7 : i64, syncscope = "singlethread"}> : () -> ()
  "llvm.store"(%2177, %2181) <{alias_scopes = [#alias_scope78], alignment = 16 : i64, noalias_scopes = [#alias_scope79], ordering = 0 : i64, volatile_}> : (i128, !llvm.ptr) -> ()
  "llvm.fence"() <{ordering = 7 : i64, syncscope = "singlethread"}> : () -> ()
  "llvm.store"(%2177, %2182) <{alias_scopes = [#alias_scope78], alignment = 16 : i64, noalias_scopes = [#alias_scope79], ordering = 0 : i64, volatile_}> : (i128, !llvm.ptr) -> ()
  "llvm.fence"() <{ordering = 7 : i64, syncscope = "singlethread"}> : () -> ()
  "llvm.store"(%2177, %2183) <{alias_scopes = [#alias_scope78], alignment = 16 : i64, noalias_scopes = [#alias_scope79], ordering = 0 : i64, volatile_}> : (i128, !llvm.ptr) -> ()
  "llvm.fence"() <{ordering = 7 : i64, syncscope = "singlethread"}> : () -> ()
  "llvm.store"(%2177, %2184) <{alias_scopes = [#alias_scope78], alignment = 16 : i64, noalias_scopes = [#alias_scope79], ordering = 0 : i64, volatile_}> : (i128, !llvm.ptr) -> ()
  "llvm.fence"() <{ordering = 7 : i64, syncscope = "singlethread"}> : () -> ()
  "llvm.store"(%2177, %2185) <{alias_scopes = [#alias_scope78], alignment = 16 : i64, noalias_scopes = [#alias_scope79], ordering = 0 : i64, volatile_}> : (i128, !llvm.ptr) -> ()
  "llvm.fence"() <{ordering = 7 : i64, syncscope = "singlethread"}> : () -> ()
  "llvm.store"(%2177, %2186) <{alias_scopes = [#alias_scope78], alignment = 16 : i64, noalias_scopes = [#alias_scope79], ordering = 0 : i64, volatile_}> : (i128, !llvm.ptr) -> ()
  "llvm.fence"() <{ordering = 7 : i64, syncscope = "singlethread"}> : () -> ()
  "llvm.store"(%2177, %2187) <{alias_scopes = [#alias_scope78], alignment = 16 : i64, noalias_scopes = [#alias_scope79], ordering = 0 : i64, volatile_}> : (i128, !llvm.ptr) -> ()
  "llvm.fence"() <{ordering = 7 : i64, syncscope = "singlethread"}> : () -> ()
  "llvm.intr.lifetime.end"(%2179) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2180) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2181) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2182) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2183) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2184) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2185) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2186) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%2187) : (!llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()
