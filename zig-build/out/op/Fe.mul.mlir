"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.noalias, llvm.nocapture, llvm.nonnull, llvm.sret = !llvm.struct<"Fe", (array<5 x i64>)>, llvm.writeonly}, {llvm.align = 8 : i64, llvm.nocapture, llvm.nonnull, llvm.readonly}, {llvm.align = 8 : i64, llvm.nocapture, llvm.nonnull, llvm.readonly}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<void (ptr, ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = write, errnoMem = none, targetMem0 = none, targetMem1 = none>, minsize, no_unwind, optsize, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", ["target-cpu", "x86-64"]], sym_name = "Fe.mul", target_cpu = "x86-64", target_features = #llvm.target_features<["+64bit", "+cmov", "+cx8", "+fxsr", "+idivq-to-divl", "+macrofusion", "+mmx", "+nopl", "+slow-3ops-lea", "+slow-incdec", "+vzeroupper", "+x87", "-16bit-mode", "-32bit-mode", "-adx", "-aes", "-allow-light-256-bit", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tf32", "-amx-tile", "-amx-transpose", "-avx", "-avx10.1-256", "-avx10.1-512", "-avx10.2-256", "-avx10.2-512", "-avx2", "-avx512bf16", "-avx512bitalg", "-avx512bw", "-avx512cd", "-avx512dq", "-avx512f", "-avx512fp16", "-avx512ifma", "-avx512vbmi", "-avx512vbmi2", "-avx512vl", "-avx512vnni", "-avx512vp2intersect", "-avx512vpopcntdq", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-bmi", "-bmi2", "-branch-hint", "-branchfusion", "-ccmp", "-cf", "-cldemote", "-clflushopt", "-clwb", "-clzero", "-cmpccxadd", "-crc32", "-cx16", "-egpr", "-enqcmd", "-ermsb", "-evex512", "-f16c", "-false-deps-getmant", "-false-deps-lzcnt-tzcnt", "-false-deps-mulc", "-false-deps-mullq", "-false-deps-perm", "-false-deps-popcnt", "-false-deps-range", "-fast-11bytenop", "-fast-15bytenop", "-fast-7bytenop", "-fast-bextr", "-fast-dpwssd", "-fast-gather", "-fast-hops", "-fast-imm16", "-fast-lzcnt", "-fast-movbe", "-fast-scalar-fsqrt", "-fast-scalar-shift-masks", "-fast-shld-rotate", "-fast-variable-crosslane-shuffle", "-fast-variable-perlane-shuffle", "-fast-vector-fsqrt", "-fast-vector-shift-masks", "-faster-shift-than-shuffle", "-fma", "-fma4", "-fsgsbase", "-fsrm", "-gfni", "-harden-sls-ijmp", "-harden-sls-ret", "-hreset", "-idivl-to-divb", "-inline-asm-use-gpr32", "-invpcid", "-kl", "-lea-sp", "-lea-uses-ag", "-lvi-cfi", "-lvi-load-hardening", "-lwp", "-lzcnt", "-movbe", "-movdir64b", "-movdiri", "-movrs", "-mwaitx", "-ndd", "-nf", "-no-bypass-delay", "-no-bypass-delay-blend", "-no-bypass-delay-mov", "-no-bypass-delay-shuffle", "-pad-short-functions", "-pclmul", "-pconfig", "-pku", "-popcnt", "-ppx", "-prefer-128-bit", "-prefer-256-bit", "-prefer-mask-registers", "-prefer-movmsk-over-vtest", "-prefer-no-gather", "-prefer-no-scatter", "-prefetchi", "-prfchw", "-ptwrite", "-push2pop2", "-raoint", "-rdpid", "-rdpru", "-rdrnd", "-rdseed", "-retpoline", "-retpoline-external-thunk", "-retpoline-indirect-branches", "-retpoline-indirect-calls", "-rtm", "-sahf", "-sbb-dep-breaking", "-serialize", "-seses", "-sgx", "-sha", "-sha512", "-shstk", "-slow-lea", "-slow-pmaddwd", "-slow-pmulld", "-slow-shld", "-slow-two-mem-ops", "-slow-unaligned-mem-16", "-slow-unaligned-mem-32", "-sm3", "-sm4", "-soft-float", "-sse", "-sse2", "-sse3", "-sse4.1", "-sse4.2", "-sse4a", "-sse-unaligned-mem", "-ssse3", "-tagged-globals", "-tbm", "-tsxldtrk", "-tuning-fast-imm-vector-shift", "-uintr", "-use-glm-div-sqrt-costs", "-use-slm-arith-costs", "-usermsr", "-vaes", "-vpclmulqdq", "-waitpkg", "-wbnoinvd", "-widekl", "-xop", "-xsave", "-xsavec", "-xsaveopt", "-xsaves", "-zu"]>, unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg16: !llvm.ptr, %arg17: !llvm.ptr, %arg18: !llvm.ptr):
  %363 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %364 = "llvm.mlir.constant"() <{value = 19 : i128}> : () -> i128
  %365 = "llvm.mlir.constant"() <{value = 40 : i64}> : () -> i64
  %366 = "llvm.alloca"(%363) <{alignment = 8 : i64, elem_type = !llvm.struct<"Fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
  %367 = "llvm.alloca"(%363) <{alignment = 16 : i64, elem_type = !llvm.array<5 x i128>}> : (i32) -> !llvm.ptr
  %368 = "llvm.load"(%arg17) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %369 = "llvm.zext"(%368) : (i64) -> i128
  %370 = "llvm.load"(%arg18) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %371 = "llvm.zext"(%370) : (i64) -> i128
  %372 = "llvm.getelementptr"(%arg17) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %373 = "llvm.load"(%372) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %374 = "llvm.zext"(%373) : (i64) -> i128
  %375 = "llvm.getelementptr"(%arg18) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %376 = "llvm.load"(%375) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %377 = "llvm.zext"(%376) : (i64) -> i128
  %378 = "llvm.getelementptr"(%arg17) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %379 = "llvm.load"(%378) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %380 = "llvm.zext"(%379) : (i64) -> i128
  %381 = "llvm.getelementptr"(%arg18) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %382 = "llvm.load"(%381) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %383 = "llvm.zext"(%382) : (i64) -> i128
  %384 = "llvm.getelementptr"(%arg17) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %385 = "llvm.load"(%384) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %386 = "llvm.zext"(%385) : (i64) -> i128
  %387 = "llvm.getelementptr"(%arg18) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %388 = "llvm.load"(%387) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %389 = "llvm.zext"(%388) : (i64) -> i128
  %390 = "llvm.getelementptr"(%arg17) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %391 = "llvm.load"(%390) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %392 = "llvm.zext"(%391) : (i64) -> i128
  %393 = "llvm.getelementptr"(%arg18) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %394 = "llvm.load"(%393) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %395 = "llvm.zext"(%394) : (i64) -> i128
  %396 = "llvm.mul"(%374, %364) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %397 = "llvm.mul"(%380, %364) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %398 = "llvm.mul"(%386, %364) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %399 = "llvm.mul"(%392, %364) <{overflowFlags = 3 : i32}> : (i128, i128) -> i128
  %400 = "llvm.mul"(%371, %369) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %401 = "llvm.mul"(%396, %395) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %402 = "llvm.mul"(%397, %389) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %403 = "llvm.mul"(%398, %383) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %404 = "llvm.mul"(%399, %377) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %405 = "llvm.add"(%402, %400) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %406 = "llvm.add"(%405, %403) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %407 = "llvm.add"(%406, %401) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %408 = "llvm.add"(%407, %404) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  "llvm.store"(%408, %367) <{alignment = 16 : i64, ordering = 0 : i64}> : (i128, !llvm.ptr) -> ()
  %409 = "llvm.getelementptr"(%367) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %410 = "llvm.mul"(%377, %369) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %411 = "llvm.mul"(%374, %371) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %412 = "llvm.add"(%410, %411) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %413 = "llvm.mul"(%397, %395) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %414 = "llvm.mul"(%398, %389) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %415 = "llvm.mul"(%399, %383) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %416 = "llvm.add"(%412, %414) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %417 = "llvm.add"(%416, %413) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %418 = "llvm.add"(%417, %415) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  "llvm.store"(%418, %409) <{alignment = 16 : i64, ordering = 0 : i64}> : (i128, !llvm.ptr) -> ()
  %419 = "llvm.getelementptr"(%367) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %420 = "llvm.mul"(%383, %369) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %421 = "llvm.mul"(%377, %374) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %422 = "llvm.mul"(%380, %371) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %423 = "llvm.mul"(%398, %395) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %424 = "llvm.mul"(%399, %389) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %425 = "llvm.add"(%422, %421) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %426 = "llvm.add"(%425, %420) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %427 = "llvm.add"(%426, %423) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %428 = "llvm.add"(%427, %424) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  "llvm.store"(%428, %419) <{alignment = 16 : i64, ordering = 0 : i64}> : (i128, !llvm.ptr) -> ()
  %429 = "llvm.getelementptr"(%367) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 48>}> : (!llvm.ptr) -> !llvm.ptr
  %430 = "llvm.mul"(%389, %369) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %431 = "llvm.mul"(%383, %374) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %432 = "llvm.mul"(%380, %377) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %433 = "llvm.mul"(%386, %371) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %434 = "llvm.mul"(%399, %395) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %435 = "llvm.add"(%431, %432) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %436 = "llvm.add"(%435, %433) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %437 = "llvm.add"(%436, %430) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %438 = "llvm.add"(%437, %434) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  "llvm.store"(%438, %429) <{alignment = 16 : i64, ordering = 0 : i64}> : (i128, !llvm.ptr) -> ()
  %439 = "llvm.getelementptr"(%367) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %440 = "llvm.mul"(%395, %369) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %441 = "llvm.mul"(%389, %374) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %442 = "llvm.mul"(%383, %380) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %443 = "llvm.mul"(%386, %377) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %444 = "llvm.mul"(%392, %371) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %445 = "llvm.add"(%443, %442) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %446 = "llvm.add"(%445, %441) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %447 = "llvm.add"(%446, %444) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  %448 = "llvm.add"(%447, %440) <{overflowFlags = 2 : i32}> : (i128, i128) -> i128
  "llvm.store"(%448, %439) <{alignment = 16 : i64, ordering = 0 : i64}> : (i128, !llvm.ptr) -> ()
  "llvm.call"(%366, %367) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.sret = !llvm.struct<"Fe", (array<5 x i64>)>}, {llvm.align = 16 : i64, llvm.nonnull}], callee = @Fe.carry128, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = write, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.intr.memcpy"(%arg16, %366, %365) <{arg_attrs = [{llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.nonnull, llvm.noundef}, {llvm.align = 8 : i64, llvm.dereferenceable = 40 : i64, llvm.nonnull, llvm.noundef}, {}], isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()
