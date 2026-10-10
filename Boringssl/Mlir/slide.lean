module

-- boringssl-build/out/op/_ZL5slidePaPKh.mlir
-- slide(signed char*, unsigned char const*)

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

namespace MLIR.Boringssl

@[expose] public section

mlir_def slide :=
#loop_annotation = #llvm.loop_annotation<mustProgress = true>
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef}, {llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<void (ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"], ["warn-stack-size", "25344"]], sym_name = "_ZL5slidePaPKh", target_cpu = "x86-64", target_features = #llvm.target_features<["+cmov", "+cx8", "+fxsr", "+mmx", "+sse", "+sse2", "+x87"]>, tune_cpu = "generic", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg27: !llvm.ptr, %arg28: !llvm.ptr):
  %206 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %207 = "llvm.mlir.constant"() <{value = 3 : i64}> : () -> i64
  %208 = "llvm.mlir.constant"() <{value = 536870911 : i64}> : () -> i64
  %209 = "llvm.mlir.constant"() <{value = 6 : i8}> : () -> i8
  %210 = "llvm.mlir.constant"() <{value = 1 : i8}> : () -> i8
  %211 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %212 = "llvm.mlir.constant"() <{value = 7 : i8}> : () -> i8
  %213 = "llvm.mlir.constant"() <{value = 2 : i64}> : () -> i64
  %214 = "llvm.mlir.constant"() <{value = 256 : i64}> : () -> i64
  %215 = "llvm.mlir.constant"() <{value = 254 : i32}> : () -> i32
  %216 = "llvm.mlir.constant"() <{value = 0 : i8}> : () -> i8
  %217 = "llvm.mlir.constant"() <{value = 255 : i64}> : () -> i64
  %218 = "llvm.mlir.constant"() <{value = false}> : () -> i1
  %219 = "llvm.mlir.constant"() <{value = 5 : i32}> : () -> i32
  %220 = "llvm.mlir.constant"() <{value = 2 : i32}> : () -> i32
  %221 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %222 = "llvm.mlir.constant"() <{value = 16 : i32}> : () -> i32
  %223 = "llvm.mlir.constant"() <{value = -16 : i32}> : () -> i32
  %224 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %225 = "llvm.mlir.constant"() <{value = 3 : i32}> : () -> i32
  %226 = "llvm.mlir.constant"() <{value = 4 : i32}> : () -> i32
  %227 = "llvm.mlir.constant"() <{value = 4 : i64}> : () -> i64
  %228 = "llvm.mlir.constant"() <{value = 5 : i64}> : () -> i64
  %229 = "llvm.mlir.constant"() <{value = 6 : i32}> : () -> i32
  %230 = "llvm.mlir.constant"() <{value = -1 : i32}> : () -> i32
  "llvm.br"(%206)[^bb1] : (i64) -> ()
^bb1(%231: i64):  // 2 preds: ^bb0, ^bb1
  %232 = "llvm.trunc"(%231) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %233 = "llvm.lshr"(%231, %207) : (i64, i64) -> i64
  %234 = "llvm.and"(%233, %208) : (i64, i64) -> i64
  %235 = "llvm.getelementptr"(%arg28, %234) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %236 = "llvm.load"(%235) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %237 = "llvm.and"(%232, %209) : (i8, i8) -> i8
  %238 = "llvm.lshr"(%236, %237) : (i8, i8) -> i8
  %239 = "llvm.and"(%238, %210) : (i8, i8) -> i8
  %240 = "llvm.getelementptr"(%arg27, %231) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%239, %240) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %241 = "llvm.or"(%231, %211) <{isDisjoint}> : (i64, i64) -> i64
  %242 = "llvm.trunc"(%241) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %243 = "llvm.lshr"(%231, %207) : (i64, i64) -> i64
  %244 = "llvm.and"(%243, %208) : (i64, i64) -> i64
  %245 = "llvm.getelementptr"(%arg28, %244) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %246 = "llvm.load"(%245) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %247 = "llvm.and"(%242, %212) : (i8, i8) -> i8
  %248 = "llvm.lshr"(%246, %247) : (i8, i8) -> i8
  %249 = "llvm.and"(%248, %210) : (i8, i8) -> i8
  %250 = "llvm.getelementptr"(%arg27, %241) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%249, %250) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %251 = "llvm.add"(%231, %213) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %252 = "llvm.icmp"(%251, %214) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%252, %206, %215, %211, %251)[^bb2, ^bb1] <{loop_annotation = #loop_annotation, operandSegmentSizes = array<i32: 1, 3, 1>}> : (i1, i64, i32, i64, i64) -> ()
^bb2(%253: i64, %254: i32, %255: i64):  // 2 preds: ^bb1, ^bb56
  %256 = "llvm.getelementptr"(%arg27, %253) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %257 = "llvm.load"(%256) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %258 = "llvm.icmp"(%257, %216) <{predicate = 1 : i64}> : (i8, i8) -> i1
  %259 = "llvm.icmp"(%253, %217) <{predicate = 6 : i64}> : (i64, i64) -> i1
  %260 = "llvm.select"(%258, %259, %218) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i1, i1) -> i1
  "llvm.cond_br"(%260)[^bb3, ^bb56] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb3:  // pred: ^bb2
  %261 = "llvm.intr.umin"(%254, %219) : (i32, i32) -> i32
  %262 = "llvm.add"(%261, %220) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %263 = "llvm.getelementptr"(%arg27, %255) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %264 = "llvm.load"(%263) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %265 = "llvm.icmp"(%264, %216) <{predicate = 0 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%265)[^bb11, ^bb4] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb4:  // pred: ^bb3
  %266 = "llvm.load"(%256) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %267 = "llvm.sext"(%266) : (i8) -> i32
  %268 = "llvm.sext"(%264) : (i8) -> i32
  %269 = "llvm.shl"(%268, %221) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %270 = "llvm.add"(%269, %267) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %271 = "llvm.icmp"(%270, %222) <{predicate = 2 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%271)[^bb5, ^bb6] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb5:  // pred: ^bb4
  %272 = "llvm.trunc"(%270) <{overflowFlags = 0 : i32}> : (i32) -> i8
  "llvm.store"(%272, %256) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  "llvm.store"(%216, %263) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  "llvm.br"()[^bb11] : () -> ()
^bb6:  // pred: ^bb4
  %273 = "llvm.sub"(%267, %269) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %274 = "llvm.icmp"(%273, %223) <{predicate = 4 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%274)[^bb7, ^bb56] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb7:  // pred: ^bb6
  %275 = "llvm.trunc"(%273) <{overflowFlags = 0 : i32}> : (i32) -> i8
  "llvm.store"(%275, %256) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  "llvm.br"(%255)[^bb8] : (i64) -> ()
^bb8(%276: i64):  // 2 preds: ^bb7, ^bb10
  %277 = "llvm.getelementptr"(%arg27, %276) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %278 = "llvm.load"(%277) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %279 = "llvm.icmp"(%278, %216) <{predicate = 0 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%279)[^bb9, ^bb10] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb9:  // pred: ^bb8
  "llvm.store"(%210, %277) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  "llvm.br"()[^bb11] : () -> ()
^bb10:  // pred: ^bb8
  "llvm.store"(%216, %277) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %280 = "llvm.add"(%276, %211) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %281 = "llvm.icmp"(%280, %214) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%281, %280)[^bb11, ^bb8] <{loop_annotation = #loop_annotation, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb11:  // 4 preds: ^bb3, ^bb5, ^bb9, ^bb10
  %282 = "llvm.add"(%255, %211) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %283 = "llvm.icmp"(%254, %224) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%283)[^bb56, ^bb12] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb12:  // pred: ^bb11
  %284 = "llvm.getelementptr"(%arg27, %282) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %285 = "llvm.load"(%284) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %286 = "llvm.icmp"(%285, %216) <{predicate = 0 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%286)[^bb20, ^bb13] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb13:  // pred: ^bb12
  %287 = "llvm.load"(%256) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %288 = "llvm.sext"(%287) : (i8) -> i32
  %289 = "llvm.sext"(%285) : (i8) -> i32
  %290 = "llvm.shl"(%289, %220) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %291 = "llvm.add"(%290, %288) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %292 = "llvm.icmp"(%291, %222) <{predicate = 2 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%292)[^bb19, ^bb14] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb14:  // pred: ^bb13
  %293 = "llvm.sub"(%288, %290) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %294 = "llvm.icmp"(%293, %223) <{predicate = 4 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%294)[^bb15, ^bb56] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb15:  // pred: ^bb14
  %295 = "llvm.trunc"(%293) <{overflowFlags = 0 : i32}> : (i32) -> i8
  "llvm.store"(%295, %256) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  "llvm.br"(%282)[^bb16] : (i64) -> ()
^bb16(%296: i64):  // 2 preds: ^bb15, ^bb17
  %297 = "llvm.getelementptr"(%arg27, %296) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %298 = "llvm.load"(%297) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %299 = "llvm.icmp"(%298, %216) <{predicate = 0 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%299)[^bb18, ^bb17] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb17:  // pred: ^bb16
  "llvm.store"(%216, %297) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %300 = "llvm.add"(%296, %211) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %301 = "llvm.icmp"(%300, %214) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%301, %300)[^bb20, ^bb16] <{loop_annotation = #loop_annotation, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb18:  // pred: ^bb16
  "llvm.store"(%210, %297) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  "llvm.br"()[^bb20] : () -> ()
^bb19:  // pred: ^bb13
  %302 = "llvm.trunc"(%291) <{overflowFlags = 0 : i32}> : (i32) -> i8
  "llvm.store"(%302, %256) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  "llvm.store"(%216, %284) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  "llvm.br"()[^bb20] : () -> ()
^bb20:  // 4 preds: ^bb12, ^bb17, ^bb18, ^bb19
  %303 = "llvm.add"(%255, %213) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %304 = "llvm.icmp"(%262, %225) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%304)[^bb56, ^bb21] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb21:  // pred: ^bb20
  %305 = "llvm.getelementptr"(%arg27, %303) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %306 = "llvm.load"(%305) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %307 = "llvm.icmp"(%306, %216) <{predicate = 0 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%307)[^bb29, ^bb22] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb22:  // pred: ^bb21
  %308 = "llvm.load"(%256) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %309 = "llvm.sext"(%308) : (i8) -> i32
  %310 = "llvm.sext"(%306) : (i8) -> i32
  %311 = "llvm.shl"(%310, %225) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %312 = "llvm.add"(%311, %309) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %313 = "llvm.icmp"(%312, %222) <{predicate = 2 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%313)[^bb28, ^bb23] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb23:  // pred: ^bb22
  %314 = "llvm.sub"(%309, %311) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %315 = "llvm.icmp"(%314, %223) <{predicate = 4 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%315)[^bb24, ^bb56] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb24:  // pred: ^bb23
  %316 = "llvm.trunc"(%314) <{overflowFlags = 0 : i32}> : (i32) -> i8
  "llvm.store"(%316, %256) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  "llvm.br"(%303)[^bb25] : (i64) -> ()
^bb25(%317: i64):  // 2 preds: ^bb24, ^bb26
  %318 = "llvm.getelementptr"(%arg27, %317) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %319 = "llvm.load"(%318) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %320 = "llvm.icmp"(%319, %216) <{predicate = 0 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%320)[^bb27, ^bb26] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb26:  // pred: ^bb25
  "llvm.store"(%216, %318) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %321 = "llvm.add"(%317, %211) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %322 = "llvm.icmp"(%321, %214) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%322, %321)[^bb29, ^bb25] <{loop_annotation = #loop_annotation, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb27:  // pred: ^bb25
  "llvm.store"(%210, %318) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  "llvm.br"()[^bb29] : () -> ()
^bb28:  // pred: ^bb22
  %323 = "llvm.trunc"(%312) <{overflowFlags = 0 : i32}> : (i32) -> i8
  "llvm.store"(%323, %256) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  "llvm.store"(%216, %305) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  "llvm.br"()[^bb29] : () -> ()
^bb29:  // 4 preds: ^bb21, ^bb26, ^bb27, ^bb28
  %324 = "llvm.add"(%255, %207) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %325 = "llvm.icmp"(%262, %226) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%325)[^bb56, ^bb30] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb30:  // pred: ^bb29
  %326 = "llvm.getelementptr"(%arg27, %324) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %327 = "llvm.load"(%326) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %328 = "llvm.icmp"(%327, %216) <{predicate = 0 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%328)[^bb38, ^bb31] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb31:  // pred: ^bb30
  %329 = "llvm.load"(%256) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %330 = "llvm.sext"(%329) : (i8) -> i32
  %331 = "llvm.sext"(%327) : (i8) -> i32
  %332 = "llvm.shl"(%331, %226) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %333 = "llvm.add"(%332, %330) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %334 = "llvm.icmp"(%333, %222) <{predicate = 2 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%334)[^bb37, ^bb32] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb32:  // pred: ^bb31
  %335 = "llvm.sub"(%330, %332) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %336 = "llvm.icmp"(%335, %223) <{predicate = 4 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%336)[^bb33, ^bb56] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb33:  // pred: ^bb32
  %337 = "llvm.trunc"(%335) <{overflowFlags = 0 : i32}> : (i32) -> i8
  "llvm.store"(%337, %256) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  "llvm.br"(%324)[^bb34] : (i64) -> ()
^bb34(%338: i64):  // 2 preds: ^bb33, ^bb35
  %339 = "llvm.getelementptr"(%arg27, %338) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %340 = "llvm.load"(%339) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %341 = "llvm.icmp"(%340, %216) <{predicate = 0 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%341)[^bb36, ^bb35] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb35:  // pred: ^bb34
  "llvm.store"(%216, %339) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %342 = "llvm.add"(%338, %211) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %343 = "llvm.icmp"(%342, %214) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%343, %342)[^bb38, ^bb34] <{loop_annotation = #loop_annotation, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb36:  // pred: ^bb34
  "llvm.store"(%210, %339) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  "llvm.br"()[^bb38] : () -> ()
^bb37:  // pred: ^bb31
  %344 = "llvm.trunc"(%333) <{overflowFlags = 0 : i32}> : (i32) -> i8
  "llvm.store"(%344, %256) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  "llvm.store"(%216, %326) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  "llvm.br"()[^bb38] : () -> ()
^bb38:  // 4 preds: ^bb30, ^bb35, ^bb36, ^bb37
  %345 = "llvm.add"(%255, %227) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %346 = "llvm.icmp"(%262, %219) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%346)[^bb56, ^bb39] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb39:  // pred: ^bb38
  %347 = "llvm.getelementptr"(%arg27, %345) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %348 = "llvm.load"(%347) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %349 = "llvm.icmp"(%348, %216) <{predicate = 0 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%349)[^bb47, ^bb40] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb40:  // pred: ^bb39
  %350 = "llvm.load"(%256) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %351 = "llvm.sext"(%350) : (i8) -> i32
  %352 = "llvm.sext"(%348) : (i8) -> i32
  %353 = "llvm.shl"(%352, %219) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %354 = "llvm.add"(%353, %351) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %355 = "llvm.icmp"(%354, %222) <{predicate = 2 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%355)[^bb46, ^bb41] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb41:  // pred: ^bb40
  %356 = "llvm.sub"(%351, %353) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %357 = "llvm.icmp"(%356, %223) <{predicate = 4 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%357)[^bb42, ^bb56] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb42:  // pred: ^bb41
  %358 = "llvm.trunc"(%356) <{overflowFlags = 0 : i32}> : (i32) -> i8
  "llvm.store"(%358, %256) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  "llvm.br"(%345)[^bb43] : (i64) -> ()
^bb43(%359: i64):  // 2 preds: ^bb42, ^bb44
  %360 = "llvm.getelementptr"(%arg27, %359) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %361 = "llvm.load"(%360) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %362 = "llvm.icmp"(%361, %216) <{predicate = 0 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%362)[^bb45, ^bb44] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb44:  // pred: ^bb43
  "llvm.store"(%216, %360) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %363 = "llvm.add"(%359, %211) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %364 = "llvm.icmp"(%363, %214) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%364, %363)[^bb47, ^bb43] <{loop_annotation = #loop_annotation, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb45:  // pred: ^bb43
  "llvm.store"(%210, %360) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  "llvm.br"()[^bb47] : () -> ()
^bb46:  // pred: ^bb40
  %365 = "llvm.trunc"(%354) <{overflowFlags = 0 : i32}> : (i32) -> i8
  "llvm.store"(%365, %256) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  "llvm.store"(%216, %347) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  "llvm.br"()[^bb47] : () -> ()
^bb47:  // 4 preds: ^bb39, ^bb44, ^bb45, ^bb46
  %366 = "llvm.add"(%255, %228) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %367 = "llvm.icmp"(%262, %229) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%367)[^bb56, ^bb48] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb48:  // pred: ^bb47
  %368 = "llvm.getelementptr"(%arg27, %366) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %369 = "llvm.load"(%368) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %370 = "llvm.icmp"(%369, %216) <{predicate = 0 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%370)[^bb56, ^bb49] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb49:  // pred: ^bb48
  %371 = "llvm.load"(%256) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %372 = "llvm.sext"(%371) : (i8) -> i32
  %373 = "llvm.sext"(%369) : (i8) -> i32
  %374 = "llvm.shl"(%373, %229) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %375 = "llvm.add"(%374, %372) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %376 = "llvm.icmp"(%375, %222) <{predicate = 2 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%376)[^bb55, ^bb50] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb50:  // pred: ^bb49
  %377 = "llvm.sub"(%372, %374) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %378 = "llvm.icmp"(%377, %223) <{predicate = 4 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%378)[^bb51, ^bb56] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb51:  // pred: ^bb50
  %379 = "llvm.trunc"(%377) <{overflowFlags = 0 : i32}> : (i32) -> i8
  "llvm.store"(%379, %256) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  "llvm.br"(%366)[^bb52] : (i64) -> ()
^bb52(%380: i64):  // 2 preds: ^bb51, ^bb53
  %381 = "llvm.getelementptr"(%arg27, %380) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %382 = "llvm.load"(%381) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %383 = "llvm.icmp"(%382, %216) <{predicate = 0 : i64}> : (i8, i8) -> i1
  "llvm.cond_br"(%383)[^bb54, ^bb53] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb53:  // pred: ^bb52
  "llvm.store"(%216, %381) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %384 = "llvm.add"(%380, %211) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %385 = "llvm.icmp"(%384, %214) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%385, %384)[^bb56, ^bb52] <{loop_annotation = #loop_annotation, operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb54:  // pred: ^bb52
  "llvm.store"(%210, %381) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  "llvm.br"()[^bb56] : () -> ()
^bb55:  // pred: ^bb49
  %386 = "llvm.trunc"(%375) <{overflowFlags = 0 : i32}> : (i32) -> i8
  "llvm.store"(%386, %256) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  "llvm.store"(%216, %368) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  "llvm.br"()[^bb56] : () -> ()
^bb56:  // 16 preds: ^bb2, ^bb6, ^bb11, ^bb14, ^bb20, ^bb23, ^bb29, ^bb32, ^bb38, ^bb41, ^bb47, ^bb48, ^bb50, ^bb53, ^bb54, ^bb55
  %387 = "llvm.add"(%253, %211) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %388 = "llvm.add"(%255, %211) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %389 = "llvm.add"(%254, %230) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  %390 = "llvm.icmp"(%387, %214) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%390, %387, %389, %388)[^bb57, ^bb2] <{loop_annotation = #loop_annotation, operandSegmentSizes = array<i32: 1, 0, 3>}> : (i1, i64, i32, i64) -> ()
^bb57:  // pred: ^bb56
  "llvm.return"() : () -> ()
}) : () -> ()

end

end MLIR.Boringssl
