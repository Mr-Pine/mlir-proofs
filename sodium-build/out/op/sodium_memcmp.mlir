#loop_unroll = #llvm.loop_unroll<runtimeDisable = true>
#loop_annotation2 = #llvm.loop_annotation<unroll = #loop_unroll, mustProgress = true, isVectorized = true>
"llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], dso_local, function_type = !llvm.func<i32 (ptr, ptr, i64)>, linkage = #llvm.linkage<internal>, no_inline, no_unwind, passthrough = ["ssp", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"]], res_attrs = [{llvm.range = #llvm.constant_range<i32, -1, 1>}], sym_name = "sodium_memcmp", target_cpu = "x86-64", target_features = #llvm.target_features<["+cmov", "+cx8", "+fxsr", "+mmx", "+sse", "+sse2", "+x87"]>, tune_cpu = "generic", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg2: !llvm.ptr, %arg3: !llvm.ptr, %arg4: i64):
  %72 = "llvm.mlir.constant"() <{value = -1 : i32}> : () -> i32
  %73 = "llvm.mlir.constant"() <{value = 8 : i32}> : () -> i32
  %74 = "llvm.mlir.constant"() <{value = 511 : i32}> : () -> i32
  %75 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %76 = "llvm.mlir.constant"() <{value = 3 : i32}> : () -> i32
  %77 = "llvm.mlir.constant"() <{value = 2 : i32}> : () -> i32
  %78 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %79 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %80 = "llvm.mlir.constant"() <{value = 0 : i8}> : () -> i8
  %81 = "llvm.mlir.constant"() <{value = 4 : i64}> : () -> i64
  %82 = "llvm.mlir.constant"() <{value = 32 : i64}> : () -> i64
  %83 = "llvm.mlir.constant"() <{value = 28 : i64}> : () -> i64
  %84 = "llvm.mlir.constant"() <{value = -32 : i64}> : () -> i64
  %85 = "llvm.mlir.constant"() <{value = dense<0> : vector<16xi8>}> : () -> vector<16xi8>
  %86 = "llvm.mlir.constant"() <{value = -4 : i64}> : () -> i64
  %87 = "llvm.mlir.poison"() : () -> i8
  %88 = "llvm.mlir.undef"() : () -> vector<4xi8>
  %89 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %90 = "llvm.insertelement"(%88, %87, %89) : (vector<4xi8>, i8, i32) -> vector<4xi8>
  %91 = "llvm.insertelement"(%90, %80, %78) : (vector<4xi8>, i8, i32) -> vector<4xi8>
  %92 = "llvm.insertelement"(%91, %80, %77) : (vector<4xi8>, i8, i32) -> vector<4xi8>
  %93 = "llvm.insertelement"(%92, %80, %76) : (vector<4xi8>, i8, i32) -> vector<4xi8>
  %94 = "llvm.alloca"(%78) <{alignment = 1 : i64, elem_type = i8}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%94) : (!llvm.ptr) -> ()
  "llvm.call"(%arg2, %arg3, %arg4) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @_sodium_dummy_symbol_to_prevent_memcmp_lto, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  %95 = "llvm.icmp"(%arg4, %79) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%95, %80)[^bb12, ^bb1] <{operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i8) -> ()
^bb1:  // pred: ^bb0
  %96 = "llvm.icmp"(%arg4, %81) <{predicate = 6 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%96, %80, %79)[^bb10, ^bb2] <{operandSegmentSizes = array<i32: 1, 2, 0>}> : (i1, i8, i64) -> ()
^bb2:  // pred: ^bb1
  %97 = "llvm.icmp"(%arg4, %82) <{predicate = 6 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%97, %79, %80)[^bb7, ^bb3] <{operandSegmentSizes = array<i32: 1, 2, 0>}> : (i1, i64, i8) -> ()
^bb3:  // pred: ^bb2
  %98 = "llvm.and"(%arg4, %83) : (i64, i64) -> i64
  %99 = "llvm.and"(%arg4, %84) : (i64, i64) -> i64
  "llvm.br"(%79, %85, %85)[^bb4] : (i64, vector<16xi8>, vector<16xi8>) -> ()
^bb4(%100: i64, %101: vector<16xi8>, %102: vector<16xi8>):  // 2 preds: ^bb3, ^bb4
  %103 = "llvm.getelementptr"(%arg2, %100) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %104 = "llvm.getelementptr"(%103) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %105 = "llvm.load"(%103) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<16xi8>
  %106 = "llvm.load"(%104) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<16xi8>
  %107 = "llvm.getelementptr"(%arg3, %100) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %108 = "llvm.getelementptr"(%107) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %109 = "llvm.load"(%107) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<16xi8>
  %110 = "llvm.load"(%108) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<16xi8>
  %111 = "llvm.xor"(%109, %105) : (vector<16xi8>, vector<16xi8>) -> vector<16xi8>
  %112 = "llvm.xor"(%110, %106) : (vector<16xi8>, vector<16xi8>) -> vector<16xi8>
  %113 = "llvm.or"(%111, %101) : (vector<16xi8>, vector<16xi8>) -> vector<16xi8>
  %114 = "llvm.or"(%112, %102) : (vector<16xi8>, vector<16xi8>) -> vector<16xi8>
  %115 = "llvm.add"(%100, %82) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %116 = "llvm.icmp"(%115, %99) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%116, %115, %113, %114)[^bb5, ^bb4] <{loop_annotation = #loop_annotation2, operandSegmentSizes = array<i32: 1, 0, 3>}> : (i1, i64, vector<16xi8>, vector<16xi8>) -> ()
^bb5:  // pred: ^bb4
  %117 = "llvm.or"(%114, %113) : (vector<16xi8>, vector<16xi8>) -> vector<16xi8>
  %118 = "llvm.intr.vector.reduce.or"(%117) : (vector<16xi8>) -> i8
  %119 = "llvm.icmp"(%arg4, %99) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%119, %118)[^bb12, ^bb6] <{operandSegmentSizes = array<i32: 1, 1, 0>}> : (i1, i8) -> ()
^bb6:  // pred: ^bb5
  %120 = "llvm.icmp"(%98, %79) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%120, %118, %99, %99, %118)[^bb10, ^bb7] <{branch_weights = array<i32: 4, 28>, operandSegmentSizes = array<i32: 1, 2, 2>}> : (i1, i8, i64, i64, i8) -> ()
^bb7(%121: i64, %122: i8):  // 2 preds: ^bb2, ^bb6
  %123 = "llvm.and"(%arg4, %86) : (i64, i64) -> i64
  %124 = "llvm.insertelement"(%93, %122, %79) : (vector<4xi8>, i8, i64) -> vector<4xi8>
  "llvm.br"(%121, %124)[^bb8] : (i64, vector<4xi8>) -> ()
^bb8(%125: i64, %126: vector<4xi8>):  // 2 preds: ^bb7, ^bb8
  %127 = "llvm.getelementptr"(%arg2, %125) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %128 = "llvm.load"(%127) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi8>
  %129 = "llvm.getelementptr"(%arg3, %125) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %130 = "llvm.load"(%129) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<4xi8>
  %131 = "llvm.xor"(%130, %128) : (vector<4xi8>, vector<4xi8>) -> vector<4xi8>
  %132 = "llvm.or"(%131, %126) : (vector<4xi8>, vector<4xi8>) -> vector<4xi8>
  %133 = "llvm.add"(%125, %81) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %134 = "llvm.icmp"(%133, %123) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%134, %133, %132)[^bb9, ^bb8] <{loop_annotation = #loop_annotation2, operandSegmentSizes = array<i32: 1, 0, 2>}> : (i1, i64, vector<4xi8>) -> ()
^bb9:  // pred: ^bb8
  %135 = "llvm.intr.vector.reduce.or"(%132) : (vector<4xi8>) -> i8
  %136 = "llvm.icmp"(%arg4, %123) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%136, %135, %135, %123)[^bb12, ^bb10] <{operandSegmentSizes = array<i32: 1, 1, 2>}> : (i1, i8, i8, i64) -> ()
^bb10(%137: i8, %138: i64):  // 3 preds: ^bb1, ^bb6, ^bb9
  "llvm.br"(%137, %138)[^bb11] : (i8, i64) -> ()
^bb11(%139: i8, %140: i64):  // 2 preds: ^bb10, ^bb11
  %141 = "llvm.getelementptr"(%arg2, %140) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %142 = "llvm.load"(%141) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %143 = "llvm.getelementptr"(%arg3, %140) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %144 = "llvm.load"(%143) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %145 = "llvm.xor"(%144, %142) : (i8, i8) -> i8
  %146 = "llvm.or"(%145, %139) : (i8, i8) -> i8
  %147 = "llvm.add"(%140, %75) <{overflowFlags = 2 : i32}> : (i64, i64) -> i64
  %148 = "llvm.icmp"(%147, %arg4) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%148, %146, %146, %147)[^bb12, ^bb11] <{loop_annotation = #loop_annotation2, operandSegmentSizes = array<i32: 1, 1, 2>}> : (i1, i8, i8, i64) -> ()
^bb12(%149: i8):  // 4 preds: ^bb0, ^bb5, ^bb9, ^bb11
  "llvm.store"(%149, %94) <{alignment = 1 : i64, ordering = 0 : i64, volatile_}> : (i8, !llvm.ptr) -> ()
  %150 = "llvm.load"(%94) <{alignment = 1 : i64, ordering = 0 : i64, volatile_}> : (!llvm.ptr) -> i8
  %151 = "llvm.inline_asm"(%150) <{asm_dialect = 0 : i64, asm_string = "", constraints = "=r,0,~{dirflag},~{fpsr},~{flags}", tail_call_kind = #llvm.tailcallkind<tail>}> : (i8) -> i8
  "llvm.store"(%151, %94) <{alignment = 1 : i64, ordering = 0 : i64, volatile_}> : (i8, !llvm.ptr) -> ()
  %152 = "llvm.load"(%94) <{alignment = 1 : i64, ordering = 0 : i64, volatile_}> : (!llvm.ptr) -> i8
  %153 = "llvm.zext"(%152) : (i8) -> i32
  %154 = "llvm.add"(%153, %74) <{overflowFlags = 3 : i32}> : (i32, i32) -> i32
  %155 = "llvm.lshr"(%154, %73) : (i32, i32) -> i32
  %156 = "llvm.and"(%155, %78) : (i32, i32) -> i32
  %157 = "llvm.add"(%156, %72) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  "llvm.intr.lifetime.end"(%94) : (!llvm.ptr) -> ()
  "llvm.return"(%157) : (i32) -> ()
}) : () -> ()
