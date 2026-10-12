module

-- agave-build/out/serial-noinline-big/op/_RNvXs5_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u645fieldRNtB5_14FieldElement51NtNtNtCsgxBkk5gSRhY_4core3ops5arith3Mul3mul.mlir
-- <&solana_ed25519[1fe0933b11699477]::backend::serial::u64::field::FieldElement51 as core[c0acaeba6ab4c2e0]::ops::arith::Mul>::mul

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

namespace MLIR.Agave.Serial

@[expose] public section

mlir_def FieldElement51_Mul_mul :=
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.align = 8 : i64, llvm.dead_on_unwind, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.writable, llvm.writeonly}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<void (ptr, ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", "nonlazybind", ["probe-stack", "inline-asm"], ["target-cpu", "x86-64-v2"]], sym_name = "_RNvXs5_NtNtNtNtCs2JGgYtL0Fal_14solana_ed255197backend6serial3u645fieldRNtB5_14FieldElement51NtNtNtCsgxBkk5gSRhY_4core3ops5arith3Mul3mul", target_cpu = "x86-64-v2", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg92: !llvm.ptr, %arg93: !llvm.ptr, %arg94: !llvm.ptr):
  %2219 = "llvm.mlir.constant"() <{value = 19 : i64}> : () -> i64
  %2220 = "llvm.mlir.constant"() <{value = 51 : i128}> : () -> i128
  %2221 = "llvm.mlir.constant"() <{value = 18446744073709551615 : i128}> : () -> i128
  %2222 = "llvm.mlir.constant"() <{value = 2251799813685247 : i64}> : () -> i64
  %2223 = "llvm.mlir.constant"() <{value = 51 : i64}> : () -> i64
  %2224 = "llvm.getelementptr"(%arg94) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %2225 = "llvm.load"(%2224) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %2226 = "llvm.mul"(%2225, %2219) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %2227 = "llvm.getelementptr"(%arg94) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %2228 = "llvm.load"(%2227) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %2229 = "llvm.mul"(%2228, %2219) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %2230 = "llvm.getelementptr"(%arg94) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %2231 = "llvm.load"(%2230) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %2232 = "llvm.mul"(%2231, %2219) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %2233 = "llvm.getelementptr"(%arg94) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %2234 = "llvm.load"(%2233) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %2235 = "llvm.mul"(%2234, %2219) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %2236 = "llvm.load"(%arg93) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %2237 = "llvm.load"(%arg94) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %2238 = "llvm.zext"(%2236) : (i64) -> i128
  %2239 = "llvm.zext"(%2237) : (i64) -> i128
  %2240 = "llvm.mul"(%2239, %2238) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2241 = "llvm.getelementptr"(%arg93) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %2242 = "llvm.load"(%2241) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %2243 = "llvm.zext"(%2242) : (i64) -> i128
  %2244 = "llvm.zext"(%2226) : (i64) -> i128
  %2245 = "llvm.mul"(%2243, %2244) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2246 = "llvm.add"(%2245, %2240) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2247 = "llvm.getelementptr"(%arg93) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %2248 = "llvm.load"(%2247) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %2249 = "llvm.zext"(%2248) : (i64) -> i128
  %2250 = "llvm.zext"(%2229) : (i64) -> i128
  %2251 = "llvm.mul"(%2249, %2250) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2252 = "llvm.add"(%2246, %2251) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2253 = "llvm.getelementptr"(%arg93) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %2254 = "llvm.load"(%2253) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %2255 = "llvm.zext"(%2254) : (i64) -> i128
  %2256 = "llvm.zext"(%2232) : (i64) -> i128
  %2257 = "llvm.mul"(%2255, %2256) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2258 = "llvm.add"(%2252, %2257) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2259 = "llvm.getelementptr"(%arg93) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %2260 = "llvm.load"(%2259) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %2261 = "llvm.zext"(%2260) : (i64) -> i128
  %2262 = "llvm.zext"(%2235) : (i64) -> i128
  %2263 = "llvm.mul"(%2261, %2262) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2264 = "llvm.add"(%2258, %2263) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2265 = "llvm.mul"(%2261, %2239) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2266 = "llvm.zext"(%2225) : (i64) -> i128
  %2267 = "llvm.mul"(%2238, %2266) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2268 = "llvm.mul"(%2243, %2250) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2269 = "llvm.mul"(%2249, %2256) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2270 = "llvm.mul"(%2255, %2262) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2271 = "llvm.mul"(%2255, %2239) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2272 = "llvm.mul"(%2261, %2266) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2273 = "llvm.zext"(%2228) : (i64) -> i128
  %2274 = "llvm.mul"(%2238, %2273) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2275 = "llvm.mul"(%2243, %2256) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2276 = "llvm.mul"(%2249, %2262) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2277 = "llvm.mul"(%2249, %2239) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2278 = "llvm.mul"(%2255, %2266) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2279 = "llvm.mul"(%2261, %2273) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2280 = "llvm.zext"(%2231) : (i64) -> i128
  %2281 = "llvm.mul"(%2238, %2280) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2282 = "llvm.mul"(%2243, %2262) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2283 = "llvm.mul"(%2243, %2239) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2284 = "llvm.mul"(%2249, %2266) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2285 = "llvm.mul"(%2255, %2273) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2286 = "llvm.mul"(%2261, %2280) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2287 = "llvm.zext"(%2234) : (i64) -> i128
  %2288 = "llvm.mul"(%2238, %2287) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %2289 = "llvm.lshr"(%2264, %2220) : (i128, i128) -> i128
  %2290 = "llvm.and"(%2289, %2221) : (i128, i128) -> i128
  %2291 = "llvm.add"(%2268, %2267) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2292 = "llvm.add"(%2291, %2269) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2293 = "llvm.add"(%2292, %2270) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2294 = "llvm.add"(%2293, %2265) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2295 = "llvm.add"(%2294, %2290) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2296 = "llvm.trunc"(%2264) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %2297 = "llvm.and"(%2296, %2222) : (i64, i64) -> i64
  %2298 = "llvm.lshr"(%2295, %2220) : (i128, i128) -> i128
  %2299 = "llvm.and"(%2298, %2221) : (i128, i128) -> i128
  %2300 = "llvm.add"(%2275, %2274) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2301 = "llvm.add"(%2300, %2276) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2302 = "llvm.add"(%2301, %2271) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2303 = "llvm.add"(%2302, %2272) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2304 = "llvm.add"(%2303, %2299) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2305 = "llvm.trunc"(%2295) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %2306 = "llvm.and"(%2305, %2222) : (i64, i64) -> i64
  %2307 = "llvm.lshr"(%2304, %2220) : (i128, i128) -> i128
  %2308 = "llvm.and"(%2307, %2221) : (i128, i128) -> i128
  %2309 = "llvm.add"(%2282, %2281) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2310 = "llvm.add"(%2309, %2277) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2311 = "llvm.add"(%2310, %2278) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2312 = "llvm.add"(%2311, %2279) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2313 = "llvm.add"(%2312, %2308) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2314 = "llvm.trunc"(%2304) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %2315 = "llvm.and"(%2314, %2222) : (i64, i64) -> i64
  %2316 = "llvm.lshr"(%2313, %2220) : (i128, i128) -> i128
  %2317 = "llvm.and"(%2316, %2221) : (i128, i128) -> i128
  %2318 = "llvm.add"(%2283, %2288) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2319 = "llvm.add"(%2318, %2284) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2320 = "llvm.add"(%2319, %2285) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2321 = "llvm.add"(%2320, %2286) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2322 = "llvm.add"(%2321, %2317) <{overflowFlags = 0 : i32}> : (i128, i128) -> i128
  %2323 = "llvm.trunc"(%2313) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %2324 = "llvm.and"(%2323, %2222) : (i64, i64) -> i64
  %2325 = "llvm.lshr"(%2322, %2220) : (i128, i128) -> i128
  %2326 = "llvm.trunc"(%2325) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %2327 = "llvm.trunc"(%2322) <{overflowFlags = 0 : i32}> : (i128) -> i64
  %2328 = "llvm.and"(%2327, %2222) : (i64, i64) -> i64
  %2329 = "llvm.mul"(%2326, %2219) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %2330 = "llvm.add"(%2329, %2297) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %2331 = "llvm.lshr"(%2330, %2223) : (i64, i64) -> i64
  %2332 = "llvm.add"(%2331, %2306) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %2333 = "llvm.and"(%2330, %2222) : (i64, i64) -> i64
  "llvm.store"(%2333, %arg92) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %2334 = "llvm.getelementptr"(%arg92) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2332, %2334) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %2335 = "llvm.getelementptr"(%arg92) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2315, %2335) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %2336 = "llvm.getelementptr"(%arg92) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2324, %2336) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  %2337 = "llvm.getelementptr"(%arg92) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%2328, %2337) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()

end

end MLIR.Agave.Serial
