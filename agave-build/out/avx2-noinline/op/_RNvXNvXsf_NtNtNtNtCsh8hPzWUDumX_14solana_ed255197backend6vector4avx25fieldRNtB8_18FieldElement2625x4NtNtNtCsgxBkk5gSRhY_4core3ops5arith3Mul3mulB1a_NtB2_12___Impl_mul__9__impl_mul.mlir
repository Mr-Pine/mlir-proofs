#alias_scope_domain126 = #llvm.alias_scope_domain<id = distinct[126]<>, description = "_RNvXNvMsb_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6vector4avx25fieldNtB8_18FieldElement2625x48reduce64B1a_NtB2_17___Impl_reduce64__14__impl_reduce64">
#alias_scope220 = #llvm.alias_scope<id = distinct[362]<>, domain = #alias_scope_domain126, description = "_RNvXNvMsb_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6vector4avx25fieldNtB8_18FieldElement2625x48reduce64B1a_NtB2_17___Impl_reduce64__14__impl_reduce64: argument 0">
#alias_scope221 = #llvm.alias_scope<id = distinct[363]<>, domain = #alias_scope_domain126, description = "_RNvXNvMsb_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6vector4avx25fieldNtB8_18FieldElement2625x48reduce64B1a_NtB2_17___Impl_reduce64__14__impl_reduce64: argument 1">
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.align = 32 : i64, llvm.dead_on_unwind, llvm.dereferenceable = 160 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.writable, llvm.writeonly}, {llvm.align = 32 : i64, llvm.dereferenceable = 160 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.align = 32 : i64, llvm.dereferenceable = 160 : i64, llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<void (ptr, ptr, ptr)>, inline_hint, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", "nonlazybind", ["probe-stack", "inline-asm"], ["target-cpu", "x86-64-v2"]], sym_name = "_RNvXNvXsf_NtNtNtNtCsh8hPzWUDumX_14solana_ed255197backend6vector4avx25fieldRNtB8_18FieldElement2625x4NtNtNtCsgxBkk5gSRhY_4core3ops5arith3Mul3mulB1a_NtB2_12___Impl_mul__9__impl_mul", target_cpu = "x86-64-v2", target_features = #llvm.target_features<["+avx", "+avx2", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+crc32", "+ssse3", "+avx", "+avx2", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+crc32", "+ssse3"]>, unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg13: !llvm.ptr, %arg14: !llvm.ptr, %arg15: !llvm.ptr):
  %149 = "llvm.mlir.constant"() <{value = 33554431 : i32}> : () -> i32
  %150 = "llvm.mlir.constant"() <{value = 67108863 : i32}> : () -> i32
  %151 = "llvm.mlir.constant"() <{value = dense<51> : vector<4xi64>}> : () -> vector<4xi64>
  %152 = "llvm.mlir.constant"() <{value = dense<33554431> : vector<4xi64>}> : () -> vector<4xi64>
  %153 = "llvm.mlir.constant"() <{value = dense<25> : vector<4xi64>}> : () -> vector<4xi64>
  %154 = "llvm.mlir.constant"() <{value = dense<67108863> : vector<4xi64>}> : () -> vector<4xi64>
  %155 = "llvm.mlir.constant"() <{value = dense<26> : vector<4xi64>}> : () -> vector<4xi64>
  %156 = "llvm.mlir.constant"() <{value = dense<4294967295> : vector<4xi64>}> : () -> vector<4xi64>
  %157 = "llvm.mlir.constant"() <{value = dense<1> : vector<8xi32>}> : () -> vector<8xi32>
  %158 = "llvm.mlir.constant"() <{value = dense<19> : vector<4xi64>}> : () -> vector<4xi64>
  %159 = "llvm.mlir.constant"() <{value = 7 : i32}> : () -> i32
  %160 = "llvm.mlir.constant"() <{value = 6 : i32}> : () -> i32
  %161 = "llvm.mlir.constant"() <{value = 5 : i32}> : () -> i32
  %162 = "llvm.mlir.constant"() <{value = 4 : i32}> : () -> i32
  %163 = "llvm.mlir.constant"() <{value = 3 : i32}> : () -> i32
  %164 = "llvm.mlir.constant"() <{value = 2 : i32}> : () -> i32
  %165 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %166 = "llvm.mlir.poison"() : () -> i32
  %167 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %168 = "llvm.mlir.undef"() : () -> vector<8xi32>
  %169 = "llvm.insertelement"(%168, %167, %167) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %170 = "llvm.insertelement"(%169, %167, %165) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %171 = "llvm.insertelement"(%170, %166, %164) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %172 = "llvm.insertelement"(%171, %166, %163) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %173 = "llvm.insertelement"(%172, %167, %162) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %174 = "llvm.insertelement"(%173, %167, %161) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %175 = "llvm.insertelement"(%174, %166, %160) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %176 = "llvm.insertelement"(%175, %166, %159) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %177 = "llvm.insertelement"(%168, %166, %167) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %178 = "llvm.insertelement"(%177, %166, %165) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %179 = "llvm.insertelement"(%178, %167, %164) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %180 = "llvm.insertelement"(%179, %167, %163) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %181 = "llvm.insertelement"(%180, %166, %162) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %182 = "llvm.insertelement"(%181, %166, %161) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %183 = "llvm.insertelement"(%182, %167, %160) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %184 = "llvm.insertelement"(%183, %167, %159) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %185 = "llvm.insertelement"(%168, %150, %167) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %186 = "llvm.insertelement"(%185, %166, %165) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %187 = "llvm.insertelement"(%186, %150, %164) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %188 = "llvm.insertelement"(%187, %166, %163) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %189 = "llvm.insertelement"(%188, %150, %162) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %190 = "llvm.insertelement"(%189, %166, %161) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %191 = "llvm.insertelement"(%190, %150, %160) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %192 = "llvm.insertelement"(%191, %166, %159) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %193 = "llvm.insertelement"(%168, %149, %167) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %194 = "llvm.insertelement"(%193, %166, %165) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %195 = "llvm.insertelement"(%194, %149, %164) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %196 = "llvm.insertelement"(%195, %166, %163) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %197 = "llvm.insertelement"(%196, %149, %162) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %198 = "llvm.insertelement"(%197, %166, %161) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %199 = "llvm.insertelement"(%198, %149, %160) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %200 = "llvm.insertelement"(%199, %166, %159) : (vector<8xi32>, i32, i32) -> vector<8xi32>
  %201 = "llvm.load"(%arg14) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi32>
  %202 = "llvm.shufflevector"(%201, %176) <{mask = array<i32: 0, 8, 1, 9, 4, 12, 5, 13>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %203 = "llvm.shufflevector"(%201, %184) <{mask = array<i32: 2, 10, 3, 11, 6, 14, 7, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %204 = "llvm.bitcast"(%202) : (vector<8xi32>) -> vector<4xi64>
  %205 = "llvm.bitcast"(%203) : (vector<8xi32>) -> vector<4xi64>
  %206 = "llvm.getelementptr"(%arg14) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %207 = "llvm.load"(%206) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi32>
  %208 = "llvm.shufflevector"(%207, %176) <{mask = array<i32: 0, 8, 1, 9, 4, 12, 5, 13>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %209 = "llvm.shufflevector"(%207, %184) <{mask = array<i32: 2, 10, 3, 11, 6, 14, 7, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %210 = "llvm.bitcast"(%208) : (vector<8xi32>) -> vector<4xi64>
  %211 = "llvm.bitcast"(%209) : (vector<8xi32>) -> vector<4xi64>
  %212 = "llvm.getelementptr"(%arg14) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %213 = "llvm.load"(%212) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi32>
  %214 = "llvm.shufflevector"(%213, %176) <{mask = array<i32: 0, 8, 1, 9, 4, 12, 5, 13>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %215 = "llvm.shufflevector"(%213, %184) <{mask = array<i32: 2, 10, 3, 11, 6, 14, 7, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %216 = "llvm.bitcast"(%214) : (vector<8xi32>) -> vector<4xi64>
  %217 = "llvm.bitcast"(%215) : (vector<8xi32>) -> vector<4xi64>
  %218 = "llvm.getelementptr"(%arg14) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 96>}> : (!llvm.ptr) -> !llvm.ptr
  %219 = "llvm.load"(%218) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi32>
  %220 = "llvm.shufflevector"(%219, %176) <{mask = array<i32: 0, 8, 1, 9, 4, 12, 5, 13>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %221 = "llvm.shufflevector"(%219, %184) <{mask = array<i32: 2, 10, 3, 11, 6, 14, 7, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %222 = "llvm.bitcast"(%220) : (vector<8xi32>) -> vector<4xi64>
  %223 = "llvm.bitcast"(%221) : (vector<8xi32>) -> vector<4xi64>
  %224 = "llvm.getelementptr"(%arg14) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %225 = "llvm.load"(%224) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi32>
  %226 = "llvm.shufflevector"(%225, %176) <{mask = array<i32: 0, 8, 1, 9, 4, 12, 5, 13>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %227 = "llvm.shufflevector"(%225, %184) <{mask = array<i32: 2, 10, 3, 11, 6, 14, 7, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %228 = "llvm.bitcast"(%226) : (vector<8xi32>) -> vector<4xi64>
  %229 = "llvm.bitcast"(%227) : (vector<8xi32>) -> vector<4xi64>
  %230 = "llvm.load"(%arg15) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi32>
  %231 = "llvm.shufflevector"(%230, %176) <{mask = array<i32: 0, 8, 1, 9, 4, 12, 5, 13>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %232 = "llvm.shufflevector"(%230, %184) <{mask = array<i32: 2, 10, 3, 11, 6, 14, 7, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %233 = "llvm.bitcast"(%231) : (vector<8xi32>) -> vector<4xi64>
  %234 = "llvm.bitcast"(%232) : (vector<8xi32>) -> vector<4xi64>
  %235 = "llvm.getelementptr"(%arg15) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %236 = "llvm.load"(%235) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi32>
  %237 = "llvm.shufflevector"(%236, %176) <{mask = array<i32: 0, 8, 1, 9, 4, 12, 5, 13>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %238 = "llvm.shufflevector"(%236, %184) <{mask = array<i32: 2, 10, 3, 11, 6, 14, 7, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %239 = "llvm.bitcast"(%237) : (vector<8xi32>) -> vector<4xi64>
  %240 = "llvm.bitcast"(%238) : (vector<8xi32>) -> vector<4xi64>
  %241 = "llvm.getelementptr"(%arg15) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %242 = "llvm.load"(%241) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi32>
  %243 = "llvm.shufflevector"(%242, %176) <{mask = array<i32: 0, 8, 1, 9, 4, 12, 5, 13>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %244 = "llvm.shufflevector"(%242, %184) <{mask = array<i32: 2, 10, 3, 11, 6, 14, 7, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %245 = "llvm.bitcast"(%243) : (vector<8xi32>) -> vector<4xi64>
  %246 = "llvm.bitcast"(%244) : (vector<8xi32>) -> vector<4xi64>
  %247 = "llvm.getelementptr"(%arg15) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 96>}> : (!llvm.ptr) -> !llvm.ptr
  %248 = "llvm.load"(%247) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi32>
  %249 = "llvm.shufflevector"(%248, %176) <{mask = array<i32: 0, 8, 1, 9, 4, 12, 5, 13>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %250 = "llvm.shufflevector"(%248, %184) <{mask = array<i32: 2, 10, 3, 11, 6, 14, 7, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %251 = "llvm.bitcast"(%249) : (vector<8xi32>) -> vector<4xi64>
  %252 = "llvm.bitcast"(%250) : (vector<8xi32>) -> vector<4xi64>
  %253 = "llvm.getelementptr"(%arg15) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  %254 = "llvm.load"(%253) <{alignment = 32 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<8xi32>
  %255 = "llvm.shufflevector"(%254, %176) <{mask = array<i32: 0, 8, 1, 9, 4, 12, 5, 13>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %256 = "llvm.shufflevector"(%254, %184) <{mask = array<i32: 2, 10, 3, 11, 6, 14, 7, 15>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %257 = "llvm.bitcast"(%255) : (vector<8xi32>) -> vector<4xi64>
  %258 = "llvm.bitcast"(%256) : (vector<8xi32>) -> vector<4xi64>
  %259 = "llvm.mul"(%234, %158) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %260 = "llvm.mul"(%239, %158) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %261 = "llvm.mul"(%240, %158) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %262 = "llvm.mul"(%245, %158) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %263 = "llvm.mul"(%246, %158) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %264 = "llvm.mul"(%251, %158) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %265 = "llvm.mul"(%252, %158) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %266 = "llvm.mul"(%257, %158) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %267 = "llvm.mul"(%258, %158) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %268 = "llvm.mul"(%233, %204) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %269 = "llvm.shl"(%203, %157) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %270 = "llvm.bitcast"(%269) : (vector<8xi32>) -> vector<4xi64>
  %271 = "llvm.and"(%267, %156) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %272 = "llvm.mul"(%271, %270) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %273 = "llvm.and"(%266, %156) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %274 = "llvm.mul"(%273, %210) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %275 = "llvm.shl"(%209, %157) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %276 = "llvm.bitcast"(%275) : (vector<8xi32>) -> vector<4xi64>
  %277 = "llvm.and"(%265, %156) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %278 = "llvm.mul"(%277, %276) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %279 = "llvm.and"(%264, %156) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %280 = "llvm.mul"(%279, %216) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %281 = "llvm.shl"(%215, %157) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %282 = "llvm.bitcast"(%281) : (vector<8xi32>) -> vector<4xi64>
  %283 = "llvm.and"(%263, %156) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %284 = "llvm.mul"(%283, %282) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %285 = "llvm.and"(%262, %156) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %286 = "llvm.mul"(%285, %222) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %287 = "llvm.shl"(%221, %157) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %288 = "llvm.bitcast"(%287) : (vector<8xi32>) -> vector<4xi64>
  %289 = "llvm.and"(%261, %156) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %290 = "llvm.mul"(%289, %288) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %291 = "llvm.and"(%260, %156) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %292 = "llvm.mul"(%291, %228) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %293 = "llvm.shl"(%227, %157) <{overflowFlags = 0 : i32}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %294 = "llvm.bitcast"(%293) : (vector<8xi32>) -> vector<4xi64>
  %295 = "llvm.and"(%259, %156) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %296 = "llvm.mul"(%295, %294) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %297 = "llvm.add"(%296, %268) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %298 = "llvm.add"(%297, %292) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %299 = "llvm.add"(%298, %290) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %300 = "llvm.add"(%299, %286) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %301 = "llvm.add"(%300, %284) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %302 = "llvm.add"(%301, %280) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %303 = "llvm.add"(%302, %278) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %304 = "llvm.add"(%303, %274) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %305 = "llvm.add"(%304, %272) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %306 = "llvm.mul"(%234, %204) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %307 = "llvm.mul"(%233, %205) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %308 = "llvm.mul"(%271, %210) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %309 = "llvm.mul"(%273, %211) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %310 = "llvm.mul"(%277, %216) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %311 = "llvm.mul"(%279, %217) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %312 = "llvm.mul"(%283, %222) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %313 = "llvm.mul"(%285, %223) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %314 = "llvm.mul"(%289, %228) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %315 = "llvm.mul"(%291, %229) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %316 = "llvm.mul"(%239, %204) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %317 = "llvm.mul"(%234, %270) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %318 = "llvm.mul"(%233, %210) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %319 = "llvm.mul"(%271, %276) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %320 = "llvm.mul"(%273, %216) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %321 = "llvm.mul"(%277, %282) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %322 = "llvm.mul"(%279, %222) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %323 = "llvm.mul"(%283, %288) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %324 = "llvm.mul"(%285, %228) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %325 = "llvm.mul"(%289, %294) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %326 = "llvm.mul"(%240, %204) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %327 = "llvm.mul"(%239, %205) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %328 = "llvm.mul"(%234, %210) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %329 = "llvm.mul"(%233, %211) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %330 = "llvm.mul"(%271, %216) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %331 = "llvm.mul"(%273, %217) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %332 = "llvm.mul"(%277, %222) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %333 = "llvm.mul"(%279, %223) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %334 = "llvm.mul"(%283, %228) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %335 = "llvm.mul"(%285, %229) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %336 = "llvm.mul"(%245, %204) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %337 = "llvm.mul"(%240, %270) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %338 = "llvm.mul"(%239, %210) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %339 = "llvm.mul"(%234, %276) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %340 = "llvm.mul"(%233, %216) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %341 = "llvm.mul"(%271, %282) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %342 = "llvm.mul"(%273, %222) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %343 = "llvm.mul"(%277, %288) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %344 = "llvm.mul"(%279, %228) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %345 = "llvm.mul"(%283, %294) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %346 = "llvm.add"(%340, %339) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %347 = "llvm.add"(%346, %338) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %348 = "llvm.add"(%347, %337) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %349 = "llvm.add"(%348, %336) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %350 = "llvm.add"(%349, %345) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %351 = "llvm.add"(%350, %344) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %352 = "llvm.add"(%351, %343) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %353 = "llvm.add"(%352, %342) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %354 = "llvm.add"(%353, %341) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %355 = "llvm.mul"(%246, %204) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %356 = "llvm.mul"(%245, %205) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %357 = "llvm.mul"(%240, %210) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %358 = "llvm.mul"(%239, %211) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %359 = "llvm.mul"(%234, %216) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %360 = "llvm.mul"(%233, %217) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %361 = "llvm.mul"(%271, %222) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %362 = "llvm.mul"(%273, %223) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %363 = "llvm.mul"(%277, %228) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %364 = "llvm.mul"(%279, %229) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %365 = "llvm.mul"(%251, %204) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %366 = "llvm.mul"(%246, %270) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %367 = "llvm.mul"(%245, %210) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %368 = "llvm.mul"(%240, %276) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %369 = "llvm.mul"(%239, %216) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %370 = "llvm.mul"(%234, %282) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %371 = "llvm.mul"(%233, %222) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %372 = "llvm.mul"(%271, %288) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %373 = "llvm.mul"(%273, %228) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %374 = "llvm.mul"(%277, %294) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %375 = "llvm.mul"(%252, %204) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %376 = "llvm.mul"(%251, %205) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %377 = "llvm.mul"(%246, %210) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %378 = "llvm.mul"(%245, %211) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %379 = "llvm.mul"(%240, %216) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %380 = "llvm.mul"(%239, %217) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %381 = "llvm.mul"(%234, %222) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %382 = "llvm.mul"(%233, %223) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %383 = "llvm.mul"(%271, %228) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %384 = "llvm.mul"(%273, %229) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %385 = "llvm.mul"(%257, %204) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %386 = "llvm.mul"(%252, %270) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %387 = "llvm.mul"(%251, %210) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %388 = "llvm.mul"(%246, %276) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %389 = "llvm.mul"(%245, %216) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %390 = "llvm.mul"(%240, %282) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %391 = "llvm.mul"(%239, %222) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %392 = "llvm.mul"(%234, %288) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %393 = "llvm.mul"(%233, %228) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %394 = "llvm.mul"(%271, %294) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %395 = "llvm.mul"(%258, %204) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %396 = "llvm.mul"(%257, %205) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %397 = "llvm.mul"(%252, %210) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %398 = "llvm.mul"(%251, %211) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %399 = "llvm.mul"(%246, %216) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %400 = "llvm.mul"(%245, %217) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %401 = "llvm.mul"(%240, %222) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %402 = "llvm.mul"(%239, %223) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %403 = "llvm.mul"(%234, %228) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %404 = "llvm.mul"(%233, %229) <{overflowFlags = 2 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %405 = "llvm.lshr"(%305, %155) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %406 = "llvm.add"(%307, %306) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %407 = "llvm.add"(%406, %314) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %408 = "llvm.add"(%407, %315) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %409 = "llvm.add"(%408, %312) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %410 = "llvm.add"(%409, %313) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %411 = "llvm.add"(%410, %310) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %412 = "llvm.add"(%411, %311) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %413 = "llvm.add"(%412, %308) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %414 = "llvm.add"(%413, %309) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %415 = "llvm.add"(%414, %405) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %416 = "llvm.and"(%305, %154) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %417 = "llvm.lshr"(%354, %155) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %418 = "llvm.add"(%360, %359) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %419 = "llvm.add"(%418, %357) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %420 = "llvm.add"(%419, %358) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %421 = "llvm.add"(%420, %355) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %422 = "llvm.add"(%421, %356) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %423 = "llvm.add"(%422, %363) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %424 = "llvm.add"(%423, %364) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %425 = "llvm.add"(%424, %361) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %426 = "llvm.add"(%425, %362) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %427 = "llvm.add"(%426, %417) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %428 = "llvm.and"(%354, %154) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %429 = "llvm.lshr"(%415, %153) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %430 = "llvm.add"(%318, %317) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %431 = "llvm.add"(%430, %316) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %432 = "llvm.add"(%431, %325) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %433 = "llvm.add"(%432, %324) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %434 = "llvm.add"(%433, %323) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %435 = "llvm.add"(%434, %322) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %436 = "llvm.add"(%435, %321) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %437 = "llvm.add"(%436, %320) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %438 = "llvm.add"(%437, %319) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %439 = "llvm.add"(%438, %429) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %440 = "llvm.and"(%415, %152) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %441 = "llvm.lshr"(%427, %153) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %442 = "llvm.add"(%371, %370) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %443 = "llvm.add"(%442, %368) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %444 = "llvm.add"(%443, %369) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %445 = "llvm.add"(%444, %367) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %446 = "llvm.add"(%445, %366) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %447 = "llvm.add"(%446, %365) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %448 = "llvm.add"(%447, %374) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %449 = "llvm.add"(%448, %373) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %450 = "llvm.add"(%449, %372) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %451 = "llvm.add"(%450, %441) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %452 = "llvm.and"(%427, %152) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %453 = "llvm.lshr"(%439, %155) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %454 = "llvm.add"(%329, %328) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %455 = "llvm.add"(%454, %326) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %456 = "llvm.add"(%455, %327) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %457 = "llvm.add"(%456, %334) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %458 = "llvm.add"(%457, %335) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %459 = "llvm.add"(%458, %332) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %460 = "llvm.add"(%459, %333) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %461 = "llvm.add"(%460, %330) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %462 = "llvm.add"(%461, %331) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %463 = "llvm.add"(%462, %453) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %464 = "llvm.lshr"(%451, %155) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %465 = "llvm.add"(%382, %381) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %466 = "llvm.add"(%465, %379) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %467 = "llvm.add"(%466, %380) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %468 = "llvm.add"(%467, %377) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %469 = "llvm.add"(%468, %378) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %470 = "llvm.add"(%469, %375) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %471 = "llvm.add"(%470, %376) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %472 = "llvm.add"(%471, %383) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %473 = "llvm.add"(%472, %384) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %474 = "llvm.add"(%473, %464) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %475 = "llvm.lshr"(%463, %153) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %476 = "llvm.add"(%475, %428) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %477 = "llvm.lshr"(%474, %153) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %478 = "llvm.add"(%392, %393) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %479 = "llvm.add"(%478, %391) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %480 = "llvm.add"(%479, %390) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %481 = "llvm.add"(%480, %389) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %482 = "llvm.add"(%481, %388) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %483 = "llvm.add"(%482, %387) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %484 = "llvm.add"(%483, %386) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %485 = "llvm.add"(%484, %385) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %486 = "llvm.add"(%485, %394) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %487 = "llvm.add"(%486, %477) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %488 = "llvm.lshr"(%476, %155) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %489 = "llvm.add"(%488, %452) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %490 = "llvm.lshr"(%487, %155) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %491 = "llvm.add"(%404, %403) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %492 = "llvm.add"(%491, %401) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %493 = "llvm.add"(%492, %402) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %494 = "llvm.add"(%493, %399) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %495 = "llvm.add"(%494, %400) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %496 = "llvm.add"(%495, %397) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %497 = "llvm.add"(%496, %398) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %498 = "llvm.add"(%497, %395) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %499 = "llvm.add"(%498, %396) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %500 = "llvm.add"(%499, %490) <{overflowFlags = 0 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %501 = "llvm.lshr"(%500, %153) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %502 = "llvm.and"(%501, %154) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %503 = "llvm.lshr"(%500, %151) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %504 = "llvm.mul"(%502, %158) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %505 = "llvm.mul"(%503, %158) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %506 = "llvm.add"(%504, %416) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %507 = "llvm.add"(%505, %440) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %508 = "llvm.lshr"(%506, %155) : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %509 = "llvm.add"(%507, %508) <{overflowFlags = 3 : i32}> : (vector<4xi64>, vector<4xi64>) -> vector<4xi64>
  %510 = "llvm.bitcast"(%506) : (vector<4xi64>) -> vector<8xi32>
  %511 = "llvm.and"(%510, %192) : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %512 = "llvm.bitcast"(%509) : (vector<4xi64>) -> vector<8xi32>
  %513 = "llvm.shufflevector"(%511, %512) <{mask = array<i32: 0, 2, 8, 10, 4, 6, 12, 14>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %514 = "llvm.bitcast"(%439) : (vector<4xi64>) -> vector<8xi32>
  %515 = "llvm.and"(%514, %192) : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %516 = "llvm.bitcast"(%463) : (vector<4xi64>) -> vector<8xi32>
  %517 = "llvm.and"(%516, %200) : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %518 = "llvm.shufflevector"(%515, %517) <{mask = array<i32: 0, 2, 8, 10, 4, 6, 12, 14>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %519 = "llvm.bitcast"(%489) : (vector<4xi64>) -> vector<8xi32>
  %520 = "llvm.bitcast"(%476) : (vector<4xi64>) -> vector<8xi32>
  %521 = "llvm.and"(%520, %192) : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %522 = "llvm.shufflevector"(%521, %519) <{mask = array<i32: 0, 2, 8, 10, 4, 6, 12, 14>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %523 = "llvm.bitcast"(%451) : (vector<4xi64>) -> vector<8xi32>
  %524 = "llvm.and"(%523, %192) : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %525 = "llvm.bitcast"(%474) : (vector<4xi64>) -> vector<8xi32>
  %526 = "llvm.and"(%525, %200) : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %527 = "llvm.shufflevector"(%524, %526) <{mask = array<i32: 0, 2, 8, 10, 4, 6, 12, 14>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %528 = "llvm.bitcast"(%487) : (vector<4xi64>) -> vector<8xi32>
  %529 = "llvm.and"(%528, %192) : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %530 = "llvm.bitcast"(%500) : (vector<4xi64>) -> vector<8xi32>
  %531 = "llvm.and"(%530, %200) : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  %532 = "llvm.shufflevector"(%529, %531) <{mask = array<i32: 0, 2, 8, 10, 4, 6, 12, 14>}> : (vector<8xi32>, vector<8xi32>) -> vector<8xi32>
  "llvm.store"(%513, %arg13) <{alias_scopes = [#alias_scope220], alignment = 32 : i64, noalias_scopes = [#alias_scope221], ordering = 0 : i64}> : (vector<8xi32>, !llvm.ptr) -> ()
  %533 = "llvm.getelementptr"(%arg13) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%518, %533) <{alias_scopes = [#alias_scope220], alignment = 32 : i64, noalias_scopes = [#alias_scope221], ordering = 0 : i64}> : (vector<8xi32>, !llvm.ptr) -> ()
  %534 = "llvm.getelementptr"(%arg13) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%522, %534) <{alias_scopes = [#alias_scope220], alignment = 32 : i64, noalias_scopes = [#alias_scope221], ordering = 0 : i64}> : (vector<8xi32>, !llvm.ptr) -> ()
  %535 = "llvm.getelementptr"(%arg13) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 96>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%527, %535) <{alias_scopes = [#alias_scope220], alignment = 32 : i64, noalias_scopes = [#alias_scope221], ordering = 0 : i64}> : (vector<8xi32>, !llvm.ptr) -> ()
  %536 = "llvm.getelementptr"(%arg13) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 128>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%532, %536) <{alias_scopes = [#alias_scope220], alignment = 32 : i64, noalias_scopes = [#alias_scope221], ordering = 0 : i64}> : (vector<8xi32>, !llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()
