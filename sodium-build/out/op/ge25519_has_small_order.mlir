"llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<i32 (ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["nofree", "norecurse", "nosync", "ssp", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"]], res_attrs = [{llvm.range = #llvm.constant_range<i32, 0, 2>}], sym_name = "ge25519_has_small_order", target_cpu = "x86-64", target_features = #llvm.target_features<["+cmov", "+cx8", "+fxsr", "+mmx", "+sse", "+sse2", "+x87"]>, tune_cpu = "generic", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg41: !llvm.ptr):
  %2120 = "llvm.mlir.constant"() <{value = dense<[1, 0, 0, 0]> : vector<4xi8>}> : () -> vector<4xi8>
  %2121 = "llvm.mlir.constant"() <{value = dense<[38, -24, -107, -113]> : vector<4xi8>}> : () -> vector<4xi8>
  %2122 = "llvm.mlir.constant"() <{value = dense<[-62, -78, 39, -80]> : vector<4xi8>}> : () -> vector<4xi8>
  %2123 = "llvm.mlir.constant"() <{value = dense<[69, -61, -12, -119]> : vector<4xi8>}> : () -> vector<4xi8>
  %2124 = "llvm.mlir.constant"() <{value = dense<[-14, -17, -104, -16]> : vector<4xi8>}> : () -> vector<4xi8>
  %2125 = "llvm.mlir.constant"() <{value = dense<[-43, -33, -84, 5]> : vector<4xi8>}> : () -> vector<4xi8>
  %2126 = "llvm.mlir.constant"() <{value = dense<[-45, -58, 51, 57]> : vector<4xi8>}> : () -> vector<4xi8>
  %2127 = "llvm.mlir.constant"() <{value = dense<[-79, 56, 2, -120]> : vector<4xi8>}> : () -> vector<4xi8>
  %2128 = "llvm.mlir.constant"() <{value = dense<[-57, 23, 106, 112]> : vector<4xi8>}> : () -> vector<4xi8>
  %2129 = "llvm.mlir.constant"() <{value = dense<[61, 77, -40, 79]> : vector<4xi8>}> : () -> vector<4xi8>
  %2130 = "llvm.mlir.constant"() <{value = dense<[-70, 60, 11, 118]> : vector<4xi8>}> : () -> vector<4xi8>
  %2131 = "llvm.mlir.constant"() <{value = dense<[13, 16, 103, 15]> : vector<4xi8>}> : () -> vector<4xi8>
  %2132 = "llvm.mlir.constant"() <{value = dense<[42, 32, 83, -6]> : vector<4xi8>}> : () -> vector<4xi8>
  %2133 = "llvm.mlir.constant"() <{value = dense<[44, 57, -52, -58]> : vector<4xi8>}> : () -> vector<4xi8>
  %2134 = "llvm.mlir.constant"() <{value = dense<[78, -57, -3, 119]> : vector<4xi8>}> : () -> vector<4xi8>
  %2135 = "llvm.mlir.constant"() <{value = dense<[-20, -1, -1, -1]> : vector<4xi8>}> : () -> vector<4xi8>
  %2136 = "llvm.mlir.constant"() <{value = dense<-1> : vector<4xi8>}> : () -> vector<4xi8>
  %2137 = "llvm.mlir.constant"() <{value = dense<[-19, -1, -1, -1]> : vector<4xi8>}> : () -> vector<4xi8>
  %2138 = "llvm.mlir.constant"() <{value = dense<[-18, -1, -1, -1]> : vector<4xi8>}> : () -> vector<4xi8>
  %2139 = "llvm.mlir.constant"() <{value = 109 : i8}> : () -> i8
  %2140 = "llvm.mlir.constant"() <{value = -110 : i8}> : () -> i8
  %2141 = "llvm.mlir.constant"() <{value = 83 : i8}> : () -> i8
  %2142 = "llvm.mlir.constant"() <{value = -84 : i8}> : () -> i8
  %2143 = "llvm.mlir.constant"() <{value = -4 : i8}> : () -> i8
  %2144 = "llvm.mlir.constant"() <{value = 3 : i8}> : () -> i8
  %2145 = "llvm.mlir.constant"() <{value = -1 : i8}> : () -> i8
  %2146 = "llvm.mlir.constant"() <{value = 127 : i8}> : () -> i8
  %2147 = "llvm.mlir.constant"() <{value = 5 : i8}> : () -> i8
  %2148 = "llvm.mlir.constant"() <{value = 122 : i8}> : () -> i8
  %2149 = "llvm.mlir.constant"() <{value = -1 : i32}> : () -> i32
  %2150 = "llvm.mlir.constant"() <{value = 511 : i32}> : () -> i32
  %2151 = "llvm.mlir.constant"() <{value = 8 : i32}> : () -> i32
  %2152 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %2153 = "llvm.load"(%arg41) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi8>
  %2154 = "llvm.getelementptr"(%arg41) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 4>}> : (!llvm.ptr) -> !llvm.ptr
  %2155 = "llvm.load"(%2154) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi8>
  %2156 = "llvm.or"(%2153, %2155) : (vector<4xi8>, vector<4xi8>) -> vector<4xi8>
  %2157 = "llvm.getelementptr"(%arg41) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %2158 = "llvm.load"(%2157) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi8>
  %2159 = "llvm.or"(%2156, %2158) : (vector<4xi8>, vector<4xi8>) -> vector<4xi8>
  %2160 = "llvm.getelementptr"(%arg41) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 12>}> : (!llvm.ptr) -> !llvm.ptr
  %2161 = "llvm.load"(%2160) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi8>
  %2162 = "llvm.or"(%2159, %2161) : (vector<4xi8>, vector<4xi8>) -> vector<4xi8>
  %2163 = "llvm.getelementptr"(%arg41) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %2164 = "llvm.load"(%2163) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi8>
  %2165 = "llvm.or"(%2162, %2164) : (vector<4xi8>, vector<4xi8>) -> vector<4xi8>
  %2166 = "llvm.getelementptr"(%arg41) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 20>}> : (!llvm.ptr) -> !llvm.ptr
  %2167 = "llvm.load"(%2166) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi8>
  %2168 = "llvm.or"(%2165, %2167) : (vector<4xi8>, vector<4xi8>) -> vector<4xi8>
  %2169 = "llvm.getelementptr"(%arg41) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %2170 = "llvm.load"(%2169) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi8>
  %2171 = "llvm.or"(%2168, %2170) : (vector<4xi8>, vector<4xi8>) -> vector<4xi8>
  %2172 = "llvm.intr.vector.reduce.or"(%2171) : (vector<4xi8>) -> i8
  %2173 = "llvm.xor"(%2153, %2120) : (vector<4xi8>, vector<4xi8>) -> vector<4xi8>
  %2174 = "llvm.or"(%2173, %2155) : (vector<4xi8>, vector<4xi8>) -> vector<4xi8>
  %2175 = "llvm.or"(%2174, %2158) : (vector<4xi8>, vector<4xi8>) -> vector<4xi8>
  %2176 = "llvm.or"(%2175, %2161) : (vector<4xi8>, vector<4xi8>) -> vector<4xi8>
  %2177 = "llvm.or"(%2176, %2164) : (vector<4xi8>, vector<4xi8>) -> vector<4xi8>
  %2178 = "llvm.or"(%2177, %2167) : (vector<4xi8>, vector<4xi8>) -> vector<4xi8>
  %2179 = "llvm.or"(%2178, %2170) : (vector<4xi8>, vector<4xi8>) -> vector<4xi8>
  %2180 = "llvm.intr.vector.reduce.or"(%2179) : (vector<4xi8>) -> i8
  %2181 = "llvm.xor"(%2153, %2121) : (vector<4xi8>, vector<4xi8>) -> vector<4xi8>
  %2182 = "llvm.xor"(%2155, %2122) : (vector<4xi8>, vector<4xi8>) -> vector<4xi8>
  %2183 = "llvm.or"(%2181, %2182) : (vector<4xi8>, vector<4xi8>) -> vector<4xi8>
  %2184 = "llvm.xor"(%2158, %2123) : (vector<4xi8>, vector<4xi8>) -> vector<4xi8>
  %2185 = "llvm.or"(%2183, %2184) : (vector<4xi8>, vector<4xi8>) -> vector<4xi8>
  %2186 = "llvm.xor"(%2161, %2124) : (vector<4xi8>, vector<4xi8>) -> vector<4xi8>
  %2187 = "llvm.or"(%2185, %2186) : (vector<4xi8>, vector<4xi8>) -> vector<4xi8>
  %2188 = "llvm.xor"(%2164, %2125) : (vector<4xi8>, vector<4xi8>) -> vector<4xi8>
  %2189 = "llvm.or"(%2187, %2188) : (vector<4xi8>, vector<4xi8>) -> vector<4xi8>
  %2190 = "llvm.xor"(%2167, %2126) : (vector<4xi8>, vector<4xi8>) -> vector<4xi8>
  %2191 = "llvm.or"(%2189, %2190) : (vector<4xi8>, vector<4xi8>) -> vector<4xi8>
  %2192 = "llvm.xor"(%2170, %2127) : (vector<4xi8>, vector<4xi8>) -> vector<4xi8>
  %2193 = "llvm.or"(%2191, %2192) : (vector<4xi8>, vector<4xi8>) -> vector<4xi8>
  %2194 = "llvm.intr.vector.reduce.or"(%2193) : (vector<4xi8>) -> i8
  %2195 = "llvm.xor"(%2153, %2128) : (vector<4xi8>, vector<4xi8>) -> vector<4xi8>
  %2196 = "llvm.xor"(%2155, %2129) : (vector<4xi8>, vector<4xi8>) -> vector<4xi8>
  %2197 = "llvm.or"(%2195, %2196) : (vector<4xi8>, vector<4xi8>) -> vector<4xi8>
  %2198 = "llvm.xor"(%2158, %2130) : (vector<4xi8>, vector<4xi8>) -> vector<4xi8>
  %2199 = "llvm.or"(%2197, %2198) : (vector<4xi8>, vector<4xi8>) -> vector<4xi8>
  %2200 = "llvm.xor"(%2161, %2131) : (vector<4xi8>, vector<4xi8>) -> vector<4xi8>
  %2201 = "llvm.or"(%2199, %2200) : (vector<4xi8>, vector<4xi8>) -> vector<4xi8>
  %2202 = "llvm.xor"(%2164, %2132) : (vector<4xi8>, vector<4xi8>) -> vector<4xi8>
  %2203 = "llvm.or"(%2201, %2202) : (vector<4xi8>, vector<4xi8>) -> vector<4xi8>
  %2204 = "llvm.xor"(%2167, %2133) : (vector<4xi8>, vector<4xi8>) -> vector<4xi8>
  %2205 = "llvm.or"(%2203, %2204) : (vector<4xi8>, vector<4xi8>) -> vector<4xi8>
  %2206 = "llvm.xor"(%2170, %2134) : (vector<4xi8>, vector<4xi8>) -> vector<4xi8>
  %2207 = "llvm.or"(%2205, %2206) : (vector<4xi8>, vector<4xi8>) -> vector<4xi8>
  %2208 = "llvm.intr.vector.reduce.or"(%2207) : (vector<4xi8>) -> i8
  %2209 = "llvm.xor"(%2153, %2135) : (vector<4xi8>, vector<4xi8>) -> vector<4xi8>
  %2210 = "llvm.and"(%2155, %2158) : (vector<4xi8>, vector<4xi8>) -> vector<4xi8>
  %2211 = "llvm.and"(%2210, %2161) : (vector<4xi8>, vector<4xi8>) -> vector<4xi8>
  %2212 = "llvm.and"(%2211, %2164) : (vector<4xi8>, vector<4xi8>) -> vector<4xi8>
  %2213 = "llvm.and"(%2212, %2167) : (vector<4xi8>, vector<4xi8>) -> vector<4xi8>
  %2214 = "llvm.and"(%2213, %2170) : (vector<4xi8>, vector<4xi8>) -> vector<4xi8>
  %2215 = "llvm.xor"(%2214, %2136) : (vector<4xi8>, vector<4xi8>) -> vector<4xi8>
  %2216 = "llvm.or"(%2209, %2215) : (vector<4xi8>, vector<4xi8>) -> vector<4xi8>
  %2217 = "llvm.intr.vector.reduce.or"(%2216) : (vector<4xi8>) -> i8
  %2218 = "llvm.xor"(%2153, %2137) : (vector<4xi8>, vector<4xi8>) -> vector<4xi8>
  %2219 = "llvm.and"(%2155, %2158) : (vector<4xi8>, vector<4xi8>) -> vector<4xi8>
  %2220 = "llvm.and"(%2219, %2161) : (vector<4xi8>, vector<4xi8>) -> vector<4xi8>
  %2221 = "llvm.and"(%2220, %2164) : (vector<4xi8>, vector<4xi8>) -> vector<4xi8>
  %2222 = "llvm.and"(%2221, %2167) : (vector<4xi8>, vector<4xi8>) -> vector<4xi8>
  %2223 = "llvm.and"(%2222, %2170) : (vector<4xi8>, vector<4xi8>) -> vector<4xi8>
  %2224 = "llvm.xor"(%2223, %2136) : (vector<4xi8>, vector<4xi8>) -> vector<4xi8>
  %2225 = "llvm.or"(%2218, %2224) : (vector<4xi8>, vector<4xi8>) -> vector<4xi8>
  %2226 = "llvm.intr.vector.reduce.or"(%2225) : (vector<4xi8>) -> i8
  %2227 = "llvm.xor"(%2153, %2138) : (vector<4xi8>, vector<4xi8>) -> vector<4xi8>
  %2228 = "llvm.and"(%2155, %2158) : (vector<4xi8>, vector<4xi8>) -> vector<4xi8>
  %2229 = "llvm.and"(%2228, %2161) : (vector<4xi8>, vector<4xi8>) -> vector<4xi8>
  %2230 = "llvm.and"(%2229, %2164) : (vector<4xi8>, vector<4xi8>) -> vector<4xi8>
  %2231 = "llvm.and"(%2230, %2167) : (vector<4xi8>, vector<4xi8>) -> vector<4xi8>
  %2232 = "llvm.and"(%2231, %2170) : (vector<4xi8>, vector<4xi8>) -> vector<4xi8>
  %2233 = "llvm.xor"(%2232, %2136) : (vector<4xi8>, vector<4xi8>) -> vector<4xi8>
  %2234 = "llvm.or"(%2227, %2233) : (vector<4xi8>, vector<4xi8>) -> vector<4xi8>
  %2235 = "llvm.intr.vector.reduce.or"(%2234) : (vector<4xi8>) -> i8
  %2236 = "llvm.getelementptr"(%arg41) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 28>}> : (!llvm.ptr) -> !llvm.ptr
  %2237 = "llvm.load"(%2236) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %2238 = "llvm.or"(%2172, %2237) : (i8, i8) -> i8
  %2239 = "llvm.or"(%2180, %2237) : (i8, i8) -> i8
  %2240 = "llvm.xor"(%2237, %2139) : (i8, i8) -> i8
  %2241 = "llvm.or"(%2194, %2240) : (i8, i8) -> i8
  %2242 = "llvm.xor"(%2237, %2140) : (i8, i8) -> i8
  %2243 = "llvm.or"(%2208, %2242) : (i8, i8) -> i8
  %2244 = "llvm.getelementptr"(%arg41) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 29>}> : (!llvm.ptr) -> !llvm.ptr
  %2245 = "llvm.load"(%2244) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %2246 = "llvm.or"(%2238, %2245) : (i8, i8) -> i8
  %2247 = "llvm.or"(%2239, %2245) : (i8, i8) -> i8
  %2248 = "llvm.xor"(%2245, %2141) : (i8, i8) -> i8
  %2249 = "llvm.or"(%2241, %2248) : (i8, i8) -> i8
  %2250 = "llvm.xor"(%2245, %2142) : (i8, i8) -> i8
  %2251 = "llvm.or"(%2243, %2250) : (i8, i8) -> i8
  %2252 = "llvm.and"(%2237, %2245) : (i8, i8) -> i8
  %2253 = "llvm.and"(%2237, %2245) : (i8, i8) -> i8
  %2254 = "llvm.and"(%2237, %2245) : (i8, i8) -> i8
  %2255 = "llvm.getelementptr"(%arg41) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 30>}> : (!llvm.ptr) -> !llvm.ptr
  %2256 = "llvm.load"(%2255) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %2257 = "llvm.or"(%2246, %2256) : (i8, i8) -> i8
  %2258 = "llvm.or"(%2247, %2256) : (i8, i8) -> i8
  %2259 = "llvm.xor"(%2256, %2143) : (i8, i8) -> i8
  %2260 = "llvm.or"(%2249, %2259) : (i8, i8) -> i8
  %2261 = "llvm.xor"(%2256, %2144) : (i8, i8) -> i8
  %2262 = "llvm.or"(%2251, %2261) : (i8, i8) -> i8
  %2263 = "llvm.and"(%2252, %2256) : (i8, i8) -> i8
  %2264 = "llvm.xor"(%2263, %2145) : (i8, i8) -> i8
  %2265 = "llvm.or"(%2217, %2264) : (i8, i8) -> i8
  %2266 = "llvm.and"(%2253, %2256) : (i8, i8) -> i8
  %2267 = "llvm.xor"(%2266, %2145) : (i8, i8) -> i8
  %2268 = "llvm.or"(%2226, %2267) : (i8, i8) -> i8
  %2269 = "llvm.and"(%2254, %2256) : (i8, i8) -> i8
  %2270 = "llvm.xor"(%2269, %2145) : (i8, i8) -> i8
  %2271 = "llvm.or"(%2235, %2270) : (i8, i8) -> i8
  %2272 = "llvm.getelementptr"(%arg41) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 31>}> : (!llvm.ptr) -> !llvm.ptr
  %2273 = "llvm.load"(%2272) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %2274 = "llvm.and"(%2273, %2146) : (i8, i8) -> i8
  %2275 = "llvm.or"(%2257, %2274) : (i8, i8) -> i8
  %2276 = "llvm.or"(%2258, %2274) : (i8, i8) -> i8
  %2277 = "llvm.xor"(%2274, %2147) : (i8, i8) -> i8
  %2278 = "llvm.or"(%2260, %2277) : (i8, i8) -> i8
  %2279 = "llvm.xor"(%2274, %2148) : (i8, i8) -> i8
  %2280 = "llvm.or"(%2262, %2279) : (i8, i8) -> i8
  %2281 = "llvm.xor"(%2274, %2146) : (i8, i8) -> i8
  %2282 = "llvm.or"(%2265, %2281) : (i8, i8) -> i8
  %2283 = "llvm.or"(%2268, %2281) : (i8, i8) -> i8
  %2284 = "llvm.or"(%2271, %2281) : (i8, i8) -> i8
  %2285 = "llvm.zext"(%2275) : (i8) -> i32
  %2286 = "llvm.add"(%2285, %2149) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %2287 = "llvm.zext"(%2276) : (i8) -> i32
  %2288 = "llvm.add"(%2287, %2149) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %2289 = "llvm.or"(%2288, %2286) : (i32, i32) -> i32
  %2290 = "llvm.zext"(%2278) : (i8) -> i32
  %2291 = "llvm.add"(%2290, %2149) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %2292 = "llvm.or"(%2291, %2289) : (i32, i32) -> i32
  %2293 = "llvm.zext"(%2280) : (i8) -> i32
  %2294 = "llvm.add"(%2293, %2149) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %2295 = "llvm.or"(%2294, %2292) : (i32, i32) -> i32
  %2296 = "llvm.zext"(%2282) : (i8) -> i32
  %2297 = "llvm.add"(%2296, %2150) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %2298 = "llvm.or"(%2297, %2295) : (i32, i32) -> i32
  %2299 = "llvm.zext"(%2283) : (i8) -> i32
  %2300 = "llvm.add"(%2299, %2150) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %2301 = "llvm.or"(%2300, %2298) : (i32, i32) -> i32
  %2302 = "llvm.zext"(%2284) : (i8) -> i32
  %2303 = "llvm.add"(%2302, %2150) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %2304 = "llvm.or"(%2303, %2301) : (i32, i32) -> i32
  %2305 = "llvm.lshr"(%2304, %2151) : (i32, i32) -> i32
  %2306 = "llvm.and"(%2305, %2152) : (i32, i32) -> i32
  "llvm.return"(%2306) : (i32) -> ()
}) : () -> ()
