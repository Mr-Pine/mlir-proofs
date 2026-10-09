module

-- build/llvm23/mlir_canonicalized/ref/op/fiat_25519_from_bytes.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

namespace MLIR.Firedancer.Ref

@[expose] public section

mlir_def fiat_25519_from_bytes :=
#tbaa_root = #llvm.tbaa_root<id = "Simple C/C++ TBAA">
#tbaa_type_desc = #llvm.tbaa_type_desc<id = "omnipotent char", members = {<#tbaa_root, 0>}>
#tbaa_tag = #llvm.tbaa_tag<base_type = #tbaa_type_desc, access_type = #tbaa_type_desc, offset = 0>
#tbaa_type_desc1 = #llvm.tbaa_type_desc<id = "long", members = {<#tbaa_type_desc, 0>}>
#tbaa_tag1 = #llvm.tbaa_tag<base_type = #tbaa_type_desc1, access_type = #tbaa_type_desc1, offset = 0>
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nocapture, llvm.nofree, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<void (ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"]], sym_name = "fiat_25519_from_bytes", target_cpu = "x86-64", target_features = #llvm.target_features<["+cmov", "+cx8", "+fxsr", "+mmx", "+sse", "+sse2", "+x87"]>, tune_cpu = "generic", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg22: !llvm.ptr, %arg23: !llvm.ptr):
  %238 = "llvm.mlir.constant"() <{value = 31 : i64}> : () -> i64
  %239 = "llvm.mlir.constant"() <{value = 127 : i8}> : () -> i8
  %240 = "llvm.mlir.constant"() <{value = 44 : i64}> : () -> i64
  %241 = "llvm.mlir.constant"() <{value = 36 : i64}> : () -> i64
  %242 = "llvm.mlir.constant"() <{value = 29 : i64}> : () -> i64
  %243 = "llvm.mlir.constant"() <{value = 28 : i64}> : () -> i64
  %244 = "llvm.mlir.constant"() <{value = 20 : i64}> : () -> i64
  %245 = "llvm.mlir.constant"() <{value = 12 : i64}> : () -> i64
  %246 = "llvm.mlir.constant"() <{value = 26 : i64}> : () -> i64
  %247 = "llvm.mlir.constant"() <{value = 4 : i64}> : () -> i64
  %248 = "llvm.mlir.constant"() <{value = 47 : i64}> : () -> i64
  %249 = "llvm.mlir.constant"() <{value = 39 : i64}> : () -> i64
  %250 = "llvm.mlir.constant"() <{value = 23 : i64}> : () -> i64
  %251 = "llvm.mlir.constant"() <{value = 21 : i64}> : () -> i64
  %252 = "llvm.mlir.constant"() <{value = 15 : i64}> : () -> i64
  %253 = "llvm.mlir.constant"() <{value = 7 : i64}> : () -> i64
  %254 = "llvm.mlir.constant"() <{value = 50 : i64}> : () -> i64
  %255 = "llvm.mlir.constant"() <{value = 18 : i64}> : () -> i64
  %256 = "llvm.mlir.constant"() <{value = 42 : i64}> : () -> i64
  %257 = "llvm.mlir.constant"() <{value = 34 : i64}> : () -> i64
  %258 = "llvm.mlir.constant"() <{value = 10 : i64}> : () -> i64
  %259 = "llvm.mlir.constant"() <{value = 13 : i64}> : () -> i64
  %260 = "llvm.mlir.constant"() <{value = 2 : i64}> : () -> i64
  %261 = "llvm.mlir.constant"() <{value = 45 : i64}> : () -> i64
  %262 = "llvm.mlir.constant"() <{value = 37 : i64}> : () -> i64
  %263 = "llvm.mlir.constant"() <{value = 5 : i64}> : () -> i64
  %264 = "llvm.mlir.constant"() <{value = 6 : i64}> : () -> i64
  %265 = "llvm.mlir.constant"() <{value = 48 : i64}> : () -> i64
  %266 = "llvm.mlir.constant"() <{value = 40 : i64}> : () -> i64
  %267 = "llvm.mlir.constant"() <{value = 32 : i64}> : () -> i64
  %268 = "llvm.mlir.constant"() <{value = 1970324836974592 : i64}> : () -> i64
  %269 = "llvm.mlir.constant"() <{value = 3 : i64}> : () -> i64
  %270 = "llvm.mlir.constant"() <{value = 2216615441596416 : i64}> : () -> i64
  %271 = "llvm.mlir.constant"() <{value = 2251799813685247 : i64}> : () -> i64
  %272 = "llvm.mlir.constant"() <{value = 51 : i64}> : () -> i64
  %273 = "llvm.getelementptr"(%arg23) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 31>}> : (!llvm.ptr) -> !llvm.ptr
  %274 = "llvm.load"(%273) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> i8
  %275 = "llvm.and"(%274, %239) : (i8, i8) -> i8
  %276 = "llvm.zext"(%275) <{nonNeg}> : (i8) -> i64
  %277 = "llvm.shl"(%276, %240) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %278 = "llvm.getelementptr"(%arg23) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 30>}> : (!llvm.ptr) -> !llvm.ptr
  %279 = "llvm.load"(%278) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> i8
  %280 = "llvm.zext"(%279) : (i8) -> i64
  %281 = "llvm.shl"(%280, %241) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %282 = "llvm.getelementptr"(%arg23) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 29>}> : (!llvm.ptr) -> !llvm.ptr
  %283 = "llvm.load"(%282) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> i8
  %284 = "llvm.zext"(%283) : (i8) -> i64
  %285 = "llvm.shl"(%284, %243) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %286 = "llvm.getelementptr"(%arg23) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 28>}> : (!llvm.ptr) -> !llvm.ptr
  %287 = "llvm.load"(%286) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> i8
  %288 = "llvm.zext"(%287) : (i8) -> i64
  %289 = "llvm.shl"(%288, %244) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %290 = "llvm.getelementptr"(%arg23) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 27>}> : (!llvm.ptr) -> !llvm.ptr
  %291 = "llvm.load"(%290) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> i8
  %292 = "llvm.zext"(%291) : (i8) -> i64
  %293 = "llvm.shl"(%292, %245) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %294 = "llvm.getelementptr"(%arg23) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 26>}> : (!llvm.ptr) -> !llvm.ptr
  %295 = "llvm.load"(%294) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> i8
  %296 = "llvm.zext"(%295) : (i8) -> i64
  %297 = "llvm.shl"(%296, %247) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %298 = "llvm.getelementptr"(%arg23) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 25>}> : (!llvm.ptr) -> !llvm.ptr
  %299 = "llvm.load"(%298) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> i8
  %300 = "llvm.zext"(%299) : (i8) -> i64
  %301 = "llvm.shl"(%300, %248) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %302 = "llvm.getelementptr"(%arg23) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %303 = "llvm.load"(%302) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> i8
  %304 = "llvm.zext"(%303) : (i8) -> i64
  %305 = "llvm.shl"(%304, %249) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %306 = "llvm.getelementptr"(%arg23) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 23>}> : (!llvm.ptr) -> !llvm.ptr
  %307 = "llvm.load"(%306) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> i8
  %308 = "llvm.zext"(%307) : (i8) -> i64
  %309 = "llvm.shl"(%308, %238) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %310 = "llvm.getelementptr"(%arg23) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 22>}> : (!llvm.ptr) -> !llvm.ptr
  %311 = "llvm.load"(%310) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> i8
  %312 = "llvm.zext"(%311) : (i8) -> i64
  %313 = "llvm.shl"(%312, %250) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %314 = "llvm.getelementptr"(%arg23) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 21>}> : (!llvm.ptr) -> !llvm.ptr
  %315 = "llvm.load"(%314) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> i8
  %316 = "llvm.zext"(%315) : (i8) -> i64
  %317 = "llvm.shl"(%316, %252) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %318 = "llvm.getelementptr"(%arg23) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 20>}> : (!llvm.ptr) -> !llvm.ptr
  %319 = "llvm.load"(%318) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> i8
  %320 = "llvm.zext"(%319) : (i8) -> i64
  %321 = "llvm.shl"(%320, %253) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %322 = "llvm.getelementptr"(%arg23) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 19>}> : (!llvm.ptr) -> !llvm.ptr
  %323 = "llvm.load"(%322) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> i8
  %324 = "llvm.zext"(%323) : (i8) -> i64
  %325 = "llvm.shl"(%324, %254) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %326 = "llvm.getelementptr"(%arg23) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 18>}> : (!llvm.ptr) -> !llvm.ptr
  %327 = "llvm.load"(%326) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> i8
  %328 = "llvm.zext"(%327) : (i8) -> i64
  %329 = "llvm.shl"(%328, %256) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %330 = "llvm.getelementptr"(%arg23) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 17>}> : (!llvm.ptr) -> !llvm.ptr
  %331 = "llvm.load"(%330) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> i8
  %332 = "llvm.zext"(%331) : (i8) -> i64
  %333 = "llvm.shl"(%332, %257) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %334 = "llvm.getelementptr"(%arg23) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %335 = "llvm.load"(%334) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> i8
  %336 = "llvm.zext"(%335) : (i8) -> i64
  %337 = "llvm.shl"(%336, %246) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %338 = "llvm.getelementptr"(%arg23) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 15>}> : (!llvm.ptr) -> !llvm.ptr
  %339 = "llvm.load"(%338) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> i8
  %340 = "llvm.zext"(%339) : (i8) -> i64
  %341 = "llvm.shl"(%340, %255) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %342 = "llvm.getelementptr"(%arg23) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 14>}> : (!llvm.ptr) -> !llvm.ptr
  %343 = "llvm.load"(%342) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> i8
  %344 = "llvm.zext"(%343) : (i8) -> i64
  %345 = "llvm.shl"(%344, %258) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %346 = "llvm.getelementptr"(%arg23) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 13>}> : (!llvm.ptr) -> !llvm.ptr
  %347 = "llvm.load"(%346) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> i8
  %348 = "llvm.zext"(%347) : (i8) -> i64
  %349 = "llvm.shl"(%348, %260) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %350 = "llvm.getelementptr"(%arg23) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 12>}> : (!llvm.ptr) -> !llvm.ptr
  %351 = "llvm.load"(%350) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> i8
  %352 = "llvm.zext"(%351) : (i8) -> i64
  %353 = "llvm.shl"(%352, %261) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %354 = "llvm.getelementptr"(%arg23) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 11>}> : (!llvm.ptr) -> !llvm.ptr
  %355 = "llvm.load"(%354) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> i8
  %356 = "llvm.zext"(%355) : (i8) -> i64
  %357 = "llvm.shl"(%356, %262) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %358 = "llvm.getelementptr"(%arg23) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 10>}> : (!llvm.ptr) -> !llvm.ptr
  %359 = "llvm.load"(%358) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> i8
  %360 = "llvm.zext"(%359) : (i8) -> i64
  %361 = "llvm.shl"(%360, %242) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %362 = "llvm.getelementptr"(%arg23) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 9>}> : (!llvm.ptr) -> !llvm.ptr
  %363 = "llvm.load"(%362) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> i8
  %364 = "llvm.zext"(%363) : (i8) -> i64
  %365 = "llvm.shl"(%364, %251) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %366 = "llvm.getelementptr"(%arg23) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %367 = "llvm.load"(%366) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> i8
  %368 = "llvm.zext"(%367) : (i8) -> i64
  %369 = "llvm.shl"(%368, %259) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %370 = "llvm.getelementptr"(%arg23) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 7>}> : (!llvm.ptr) -> !llvm.ptr
  %371 = "llvm.load"(%370) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> i8
  %372 = "llvm.zext"(%371) : (i8) -> i64
  %373 = "llvm.shl"(%372, %263) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %374 = "llvm.getelementptr"(%arg23) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 6>}> : (!llvm.ptr) -> !llvm.ptr
  %375 = "llvm.load"(%374) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> i8
  %376 = "llvm.zext"(%375) : (i8) -> i64
  %377 = "llvm.shl"(%376, %265) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %378 = "llvm.getelementptr"(%arg23) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 5>}> : (!llvm.ptr) -> !llvm.ptr
  %379 = "llvm.load"(%378) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> i8
  %380 = "llvm.zext"(%379) : (i8) -> i64
  %381 = "llvm.shl"(%380, %266) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %382 = "llvm.getelementptr"(%arg23) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 4>}> : (!llvm.ptr) -> !llvm.ptr
  %383 = "llvm.load"(%382) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> i8
  %384 = "llvm.zext"(%383) : (i8) -> i64
  %385 = "llvm.shl"(%384, %267) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %386 = "llvm.load"(%arg23) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i32
  %387 = "llvm.zext"(%386) : (i32) -> i64
  %388 = "llvm.or"(%381, %387) <{isDisjoint}> : (i64, i64) -> i64
  %389 = "llvm.or"(%388, %385) <{isDisjoint}> : (i64, i64) -> i64
  %390 = "llvm.and"(%377, %268) : (i64, i64) -> i64
  %391 = "llvm.or"(%389, %390) <{isDisjoint}> : (i64, i64) -> i64
  %392 = "llvm.lshr"(%376, %269) : (i64, i64) -> i64
  %393 = "llvm.and"(%353, %270) : (i64, i64) -> i64
  %394 = "llvm.or"(%357, %393) <{isDisjoint}> : (i64, i64) -> i64
  %395 = "llvm.or"(%394, %361) <{isDisjoint}> : (i64, i64) -> i64
  %396 = "llvm.or"(%395, %365) <{isDisjoint}> : (i64, i64) -> i64
  %397 = "llvm.or"(%396, %369) <{isDisjoint}> : (i64, i64) -> i64
  %398 = "llvm.or"(%397, %373) <{isDisjoint}> : (i64, i64) -> i64
  %399 = "llvm.or"(%398, %392) <{isDisjoint}> : (i64, i64) -> i64
  %400 = "llvm.lshr"(%352, %264) : (i64, i64) -> i64
  %401 = "llvm.or"(%329, %325) <{isDisjoint}> : (i64, i64) -> i64
  %402 = "llvm.or"(%401, %333) <{isDisjoint}> : (i64, i64) -> i64
  %403 = "llvm.or"(%402, %337) <{isDisjoint}> : (i64, i64) -> i64
  %404 = "llvm.or"(%403, %341) <{isDisjoint}> : (i64, i64) -> i64
  %405 = "llvm.or"(%404, %345) <{isDisjoint}> : (i64, i64) -> i64
  %406 = "llvm.or"(%405, %349) <{isDisjoint}> : (i64, i64) -> i64
  %407 = "llvm.add"(%406, %400) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %408 = "llvm.and"(%407, %271) : (i64, i64) -> i64
  %409 = "llvm.lshr"(%407, %272) : (i64, i64) -> i64
  %410 = "llvm.or"(%305, %301) <{isDisjoint}> : (i64, i64) -> i64
  %411 = "llvm.or"(%410, %309) <{isDisjoint}> : (i64, i64) -> i64
  %412 = "llvm.or"(%411, %313) <{isDisjoint}> : (i64, i64) -> i64
  %413 = "llvm.or"(%412, %317) <{isDisjoint}> : (i64, i64) -> i64
  %414 = "llvm.or"(%413, %321) <{isDisjoint}> : (i64, i64) -> i64
  %415 = "llvm.add"(%414, %409) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %416 = "llvm.and"(%415, %271) : (i64, i64) -> i64
  %417 = "llvm.lshr"(%415, %272) : (i64, i64) -> i64
  %418 = "llvm.or"(%277, %281) <{isDisjoint}> : (i64, i64) -> i64
  %419 = "llvm.or"(%418, %285) <{isDisjoint}> : (i64, i64) -> i64
  %420 = "llvm.or"(%419, %289) <{isDisjoint}> : (i64, i64) -> i64
  %421 = "llvm.or"(%420, %293) <{isDisjoint}> : (i64, i64) -> i64
  %422 = "llvm.or"(%421, %297) <{isDisjoint}> : (i64, i64) -> i64
  %423 = "llvm.add"(%422, %417) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  "llvm.store"(%391, %arg22) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (i64, !llvm.ptr) -> ()
  %424 = "llvm.getelementptr"(%arg22) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%399, %424) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (i64, !llvm.ptr) -> ()
  %425 = "llvm.getelementptr"(%arg22) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%408, %425) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (i64, !llvm.ptr) -> ()
  %426 = "llvm.getelementptr"(%arg22) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%416, %426) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (i64, !llvm.ptr) -> ()
  %427 = "llvm.getelementptr"(%arg22) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%423, %427) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (i64, !llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()

end

end MLIR.Firedancer.Ref
