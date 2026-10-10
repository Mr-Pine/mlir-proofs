module

-- agave-build/out/avx2-noinline/op/_RNvMs8_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6serial3u645fieldNtB5_14FieldElement518to_bytes.mlir
-- <solana_ed25519[c79103de3f6f5451]::backend::serial::u64::field::FieldElement51>::to_bytes

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

namespace MLIR.Agave.Avx2

@[expose] public section

mlir_def FieldElement51_to_bytes :=
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.align = 1 : i64, llvm.dead_on_unwind, llvm.dereferenceable = 32 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.writable, llvm.writeonly}, {llvm.align = 8 : i64, llvm.dead_on_return = -1 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<void (ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", "nonlazybind", ["probe-stack", "inline-asm"], ["target-cpu", "x86-64-v2"]], sym_name = "_RNvMs8_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6serial3u645fieldNtB5_14FieldElement518to_bytes", target_cpu = "x86-64-v2", target_features = #llvm.target_features<["+avx", "+avx2", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+crc32", "+ssse3"]>, unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg45: !llvm.ptr, %arg46: !llvm.ptr):
  %2197 = "llvm.mlir.constant"() <{value = 8 : i64}> : () -> i64
  %2198 = "llvm.mlir.constant"() <{value = 16 : i64}> : () -> i64
  %2199 = "llvm.mlir.constant"() <{value = 24 : i64}> : () -> i64
  %2200 = "llvm.mlir.constant"() <{value = 32 : i64}> : () -> i64
  %2201 = "llvm.mlir.constant"() <{value = 51 : i64}> : () -> i64
  %2202 = "llvm.mlir.constant"() <{value = 2251799813685247 : i64}> : () -> i64
  %2203 = "llvm.mlir.constant"() <{value = 19 : i64}> : () -> i64
  %2204 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %2205 = "llvm.mlir.constant"() <{value = 2 : i64}> : () -> i64
  %2206 = "llvm.mlir.constant"() <{value = 3 : i64}> : () -> i64
  %2207 = "llvm.mlir.constant"() <{value = 4 : i64}> : () -> i64
  %2208 = "llvm.mlir.constant"() <{value = 40 : i64}> : () -> i64
  %2209 = "llvm.mlir.constant"() <{value = 5 : i64}> : () -> i64
  %2210 = "llvm.mlir.constant"() <{value = 48 : i64}> : () -> i64
  %2211 = "llvm.mlir.constant"() <{value = 7 : i64}> : () -> i64
  %2212 = "llvm.mlir.constant"() <{value = 6 : i64}> : () -> i64
  %2213 = "llvm.mlir.constant"() <{value = 13 : i64}> : () -> i64
  %2214 = "llvm.mlir.constant"() <{value = 21 : i64}> : () -> i64
  %2215 = "llvm.mlir.constant"() <{value = 29 : i64}> : () -> i64
  %2216 = "llvm.mlir.constant"() <{value = 10 : i64}> : () -> i64
  %2217 = "llvm.mlir.constant"() <{value = 37 : i64}> : () -> i64
  %2218 = "llvm.mlir.constant"() <{value = 45 : i64}> : () -> i64
  %2219 = "llvm.mlir.constant"() <{value = 12 : i64}> : () -> i64
  %2220 = "llvm.mlir.constant"() <{value = 18 : i64}> : () -> i64
  %2221 = "llvm.mlir.constant"() <{value = 15 : i64}> : () -> i64
  %2222 = "llvm.mlir.constant"() <{value = 26 : i64}> : () -> i64
  %2223 = "llvm.mlir.constant"() <{value = 34 : i64}> : () -> i64
  %2224 = "llvm.mlir.constant"() <{value = 42 : i64}> : () -> i64
  %2225 = "llvm.mlir.constant"() <{value = 50 : i64}> : () -> i64
  %2226 = "llvm.mlir.constant"() <{value = 20 : i64}> : () -> i64
  %2227 = "llvm.mlir.constant"() <{value = 23 : i64}> : () -> i64
  %2228 = "llvm.mlir.constant"() <{value = 31 : i64}> : () -> i64
  %2229 = "llvm.mlir.constant"() <{value = 39 : i64}> : () -> i64
  %2230 = "llvm.mlir.constant"() <{value = 47 : i64}> : () -> i64
  %2231 = "llvm.mlir.constant"() <{value = 28 : i64}> : () -> i64
  %2232 = "llvm.mlir.constant"() <{value = 36 : i64}> : () -> i64
  %2233 = "llvm.mlir.constant"() <{value = 44 : i64}> : () -> i64
  %2234 = "llvm.load"(%arg46) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %2235 = "llvm.getelementptr"(%arg46) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %2236 = "llvm.load"(%2235) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %2237 = "llvm.getelementptr"(%arg46) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %2238 = "llvm.load"(%2237) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %2239 = "llvm.getelementptr"(%arg46) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %2240 = "llvm.load"(%2239) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %2241 = "llvm.getelementptr"(%arg46) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %2242 = "llvm.load"(%2241) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %2243 = "llvm.lshr"(%2234, %2201) : (i64, i64) -> i64
  %2244 = "llvm.lshr"(%2236, %2201) : (i64, i64) -> i64
  %2245 = "llvm.lshr"(%2238, %2201) : (i64, i64) -> i64
  %2246 = "llvm.lshr"(%2240, %2201) : (i64, i64) -> i64
  %2247 = "llvm.lshr"(%2242, %2201) : (i64, i64) -> i64
  %2248 = "llvm.and"(%2234, %2202) : (i64, i64) -> i64
  %2249 = "llvm.and"(%2236, %2202) : (i64, i64) -> i64
  %2250 = "llvm.and"(%2238, %2202) : (i64, i64) -> i64
  %2251 = "llvm.and"(%2240, %2202) : (i64, i64) -> i64
  %2252 = "llvm.and"(%2242, %2202) : (i64, i64) -> i64
  %2253 = "llvm.mul"(%2247, %2203) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %2254 = "llvm.add"(%2253, %2248) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %2255 = "llvm.add"(%2249, %2243) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %2256 = "llvm.add"(%2250, %2244) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %2257 = "llvm.add"(%2251, %2245) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %2258 = "llvm.add"(%2252, %2246) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %2259 = "llvm.add"(%2254, %2203) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %2260 = "llvm.lshr"(%2259, %2201) : (i64, i64) -> i64
  %2261 = "llvm.add"(%2260, %2255) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %2262 = "llvm.lshr"(%2261, %2201) : (i64, i64) -> i64
  %2263 = "llvm.add"(%2262, %2256) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %2264 = "llvm.lshr"(%2263, %2201) : (i64, i64) -> i64
  %2265 = "llvm.add"(%2264, %2257) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %2266 = "llvm.lshr"(%2265, %2201) : (i64, i64) -> i64
  %2267 = "llvm.add"(%2266, %2258) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %2268 = "llvm.lshr"(%2267, %2201) : (i64, i64) -> i64
  %2269 = "llvm.mul"(%2268, %2203) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %2270 = "llvm.add"(%2269, %2254) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %2271 = "llvm.lshr"(%2270, %2201) : (i64, i64) -> i64
  %2272 = "llvm.add"(%2271, %2255) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %2273 = "llvm.lshr"(%2272, %2201) : (i64, i64) -> i64
  %2274 = "llvm.add"(%2273, %2256) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %2275 = "llvm.and"(%2272, %2202) : (i64, i64) -> i64
  %2276 = "llvm.lshr"(%2274, %2201) : (i64, i64) -> i64
  %2277 = "llvm.add"(%2276, %2257) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %2278 = "llvm.and"(%2274, %2202) : (i64, i64) -> i64
  %2279 = "llvm.lshr"(%2277, %2201) : (i64, i64) -> i64
  %2280 = "llvm.add"(%2279, %2258) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %2281 = "llvm.and"(%2277, %2202) : (i64, i64) -> i64
  %2282 = "llvm.and"(%2280, %2202) : (i64, i64) -> i64
  %2283 = "llvm.trunc"(%2270) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%2283, %arg45) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %2284 = "llvm.lshr"(%2270, %2197) : (i64, i64) -> i64
  %2285 = "llvm.getelementptr"(%arg45) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1>}> : (!llvm.ptr) -> !llvm.ptr
  %2286 = "llvm.trunc"(%2284) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%2286, %2285) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %2287 = "llvm.lshr"(%2270, %2198) : (i64, i64) -> i64
  %2288 = "llvm.getelementptr"(%arg45) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 2>}> : (!llvm.ptr) -> !llvm.ptr
  %2289 = "llvm.trunc"(%2287) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%2289, %2288) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %2290 = "llvm.lshr"(%2270, %2199) : (i64, i64) -> i64
  %2291 = "llvm.getelementptr"(%arg45) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 3>}> : (!llvm.ptr) -> !llvm.ptr
  %2292 = "llvm.trunc"(%2290) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%2292, %2291) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %2293 = "llvm.lshr"(%2270, %2200) : (i64, i64) -> i64
  %2294 = "llvm.getelementptr"(%arg45) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 4>}> : (!llvm.ptr) -> !llvm.ptr
  %2295 = "llvm.trunc"(%2293) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%2295, %2294) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %2296 = "llvm.lshr"(%2270, %2208) : (i64, i64) -> i64
  %2297 = "llvm.getelementptr"(%arg45) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 5>}> : (!llvm.ptr) -> !llvm.ptr
  %2298 = "llvm.trunc"(%2296) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%2298, %2297) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %2299 = "llvm.lshr"(%2270, %2210) : (i64, i64) -> i64
  %2300 = "llvm.and"(%2299, %2211) : (i64, i64) -> i64
  %2301 = "llvm.shl"(%2275, %2206) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %2302 = "llvm.or"(%2301, %2300) <{isDisjoint}> : (i64, i64) -> i64
  %2303 = "llvm.getelementptr"(%arg45) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 6>}> : (!llvm.ptr) -> !llvm.ptr
  %2304 = "llvm.trunc"(%2302) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%2304, %2303) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %2305 = "llvm.lshr"(%2272, %2209) : (i64, i64) -> i64
  %2306 = "llvm.getelementptr"(%arg45) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 7>}> : (!llvm.ptr) -> !llvm.ptr
  %2307 = "llvm.trunc"(%2305) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%2307, %2306) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %2308 = "llvm.lshr"(%2272, %2213) : (i64, i64) -> i64
  %2309 = "llvm.getelementptr"(%arg45) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %2310 = "llvm.trunc"(%2308) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%2310, %2309) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %2311 = "llvm.lshr"(%2272, %2214) : (i64, i64) -> i64
  %2312 = "llvm.getelementptr"(%arg45) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 9>}> : (!llvm.ptr) -> !llvm.ptr
  %2313 = "llvm.trunc"(%2311) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%2313, %2312) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %2314 = "llvm.lshr"(%2272, %2215) : (i64, i64) -> i64
  %2315 = "llvm.getelementptr"(%arg45) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 10>}> : (!llvm.ptr) -> !llvm.ptr
  %2316 = "llvm.trunc"(%2314) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%2316, %2315) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %2317 = "llvm.lshr"(%2272, %2217) : (i64, i64) -> i64
  %2318 = "llvm.getelementptr"(%arg45) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 11>}> : (!llvm.ptr) -> !llvm.ptr
  %2319 = "llvm.trunc"(%2317) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%2319, %2318) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %2320 = "llvm.lshr"(%2275, %2218) : (i64, i64) -> i64
  %2321 = "llvm.shl"(%2278, %2212) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %2322 = "llvm.or"(%2321, %2320) <{isDisjoint}> : (i64, i64) -> i64
  %2323 = "llvm.getelementptr"(%arg45) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 12>}> : (!llvm.ptr) -> !llvm.ptr
  %2324 = "llvm.trunc"(%2322) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%2324, %2323) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %2325 = "llvm.lshr"(%2274, %2205) : (i64, i64) -> i64
  %2326 = "llvm.getelementptr"(%arg45) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 13>}> : (!llvm.ptr) -> !llvm.ptr
  %2327 = "llvm.trunc"(%2325) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%2327, %2326) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %2328 = "llvm.lshr"(%2274, %2216) : (i64, i64) -> i64
  %2329 = "llvm.getelementptr"(%arg45) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 14>}> : (!llvm.ptr) -> !llvm.ptr
  %2330 = "llvm.trunc"(%2328) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%2330, %2329) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %2331 = "llvm.lshr"(%2274, %2220) : (i64, i64) -> i64
  %2332 = "llvm.getelementptr"(%arg45) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 15>}> : (!llvm.ptr) -> !llvm.ptr
  %2333 = "llvm.trunc"(%2331) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%2333, %2332) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %2334 = "llvm.lshr"(%2274, %2222) : (i64, i64) -> i64
  %2335 = "llvm.getelementptr"(%arg45) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %2336 = "llvm.trunc"(%2334) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%2336, %2335) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %2337 = "llvm.lshr"(%2274, %2223) : (i64, i64) -> i64
  %2338 = "llvm.getelementptr"(%arg45) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 17>}> : (!llvm.ptr) -> !llvm.ptr
  %2339 = "llvm.trunc"(%2337) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%2339, %2338) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %2340 = "llvm.lshr"(%2274, %2224) : (i64, i64) -> i64
  %2341 = "llvm.getelementptr"(%arg45) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 18>}> : (!llvm.ptr) -> !llvm.ptr
  %2342 = "llvm.trunc"(%2340) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%2342, %2341) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %2343 = "llvm.lshr"(%2278, %2225) : (i64, i64) -> i64
  %2344 = "llvm.shl"(%2281, %2204) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %2345 = "llvm.or"(%2344, %2343) <{isDisjoint}> : (i64, i64) -> i64
  %2346 = "llvm.getelementptr"(%arg45) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 19>}> : (!llvm.ptr) -> !llvm.ptr
  %2347 = "llvm.trunc"(%2345) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%2347, %2346) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %2348 = "llvm.lshr"(%2277, %2211) : (i64, i64) -> i64
  %2349 = "llvm.getelementptr"(%arg45) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 20>}> : (!llvm.ptr) -> !llvm.ptr
  %2350 = "llvm.trunc"(%2348) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%2350, %2349) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %2351 = "llvm.lshr"(%2277, %2221) : (i64, i64) -> i64
  %2352 = "llvm.getelementptr"(%arg45) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 21>}> : (!llvm.ptr) -> !llvm.ptr
  %2353 = "llvm.trunc"(%2351) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%2353, %2352) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %2354 = "llvm.lshr"(%2277, %2227) : (i64, i64) -> i64
  %2355 = "llvm.getelementptr"(%arg45) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 22>}> : (!llvm.ptr) -> !llvm.ptr
  %2356 = "llvm.trunc"(%2354) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%2356, %2355) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %2357 = "llvm.lshr"(%2277, %2228) : (i64, i64) -> i64
  %2358 = "llvm.getelementptr"(%arg45) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 23>}> : (!llvm.ptr) -> !llvm.ptr
  %2359 = "llvm.trunc"(%2357) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%2359, %2358) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %2360 = "llvm.lshr"(%2277, %2229) : (i64, i64) -> i64
  %2361 = "llvm.getelementptr"(%arg45) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %2362 = "llvm.trunc"(%2360) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%2362, %2361) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %2363 = "llvm.lshr"(%2281, %2230) : (i64, i64) -> i64
  %2364 = "llvm.shl"(%2282, %2207) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %2365 = "llvm.or"(%2364, %2363) <{isDisjoint}> : (i64, i64) -> i64
  %2366 = "llvm.getelementptr"(%arg45) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 25>}> : (!llvm.ptr) -> !llvm.ptr
  %2367 = "llvm.trunc"(%2365) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%2367, %2366) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %2368 = "llvm.lshr"(%2280, %2207) : (i64, i64) -> i64
  %2369 = "llvm.getelementptr"(%arg45) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 26>}> : (!llvm.ptr) -> !llvm.ptr
  %2370 = "llvm.trunc"(%2368) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%2370, %2369) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %2371 = "llvm.lshr"(%2280, %2219) : (i64, i64) -> i64
  %2372 = "llvm.getelementptr"(%arg45) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 27>}> : (!llvm.ptr) -> !llvm.ptr
  %2373 = "llvm.trunc"(%2371) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%2373, %2372) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %2374 = "llvm.lshr"(%2280, %2226) : (i64, i64) -> i64
  %2375 = "llvm.getelementptr"(%arg45) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 28>}> : (!llvm.ptr) -> !llvm.ptr
  %2376 = "llvm.trunc"(%2374) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%2376, %2375) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %2377 = "llvm.lshr"(%2280, %2231) : (i64, i64) -> i64
  %2378 = "llvm.getelementptr"(%arg45) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 29>}> : (!llvm.ptr) -> !llvm.ptr
  %2379 = "llvm.trunc"(%2377) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%2379, %2378) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %2380 = "llvm.lshr"(%2280, %2232) : (i64, i64) -> i64
  %2381 = "llvm.getelementptr"(%arg45) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 30>}> : (!llvm.ptr) -> !llvm.ptr
  %2382 = "llvm.trunc"(%2380) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%2382, %2381) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %2383 = "llvm.lshr"(%2282, %2233) : (i64, i64) -> i64
  %2384 = "llvm.getelementptr"(%arg45) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 31>}> : (!llvm.ptr) -> !llvm.ptr
  %2385 = "llvm.trunc"(%2383) <{overflowFlags = 3 : i32}> : (i64) -> i8
  "llvm.store"(%2385, %2384) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()

end

end MLIR.Agave.Avx2
