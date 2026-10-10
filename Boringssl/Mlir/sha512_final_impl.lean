module

-- boringssl-build/out/op/_ZL17sha512_final_implPhmP15sha512_state_st.mlir
-- sha512_final_impl(unsigned char*, unsigned long, sha512_state_st*)

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Boringssl.Mlir.sha512_block_data_order
public import Boringssl.Mlir.OPENSSL_memset
public import Boringssl.Mlir.CRYPTO_store_u64_be
public import Boringssl.Mlir.FIPS_service_indicator_update_state

meta import MLIR.Semantics.Func
meta import Boringssl.Mlir.sha512_block_data_order
meta import Boringssl.Mlir.OPENSSL_memset
meta import Boringssl.Mlir.CRYPTO_store_u64_be
meta import Boringssl.Mlir.FIPS_service_indicator_update_state

namespace MLIR.Boringssl

@[expose] public section

noncomputable mlir_def sha512_final_impl :=
#loop_annotation = #llvm.loop_annotation<mustProgress = true>
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.noundef}, {llvm.noundef, llvm.range = #llvm.constant_range<i64, 0, 65536>}, {llvm.noundef}], dso_local, function_type = !llvm.func<void (ptr, i64, ptr)>, linkage = #llvm.linkage<internal>, no_inline, no_unwind, passthrough = ["mustprogress", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"], ["warn-stack-size", "25344"]], sym_name = "_ZL17sha512_final_implPhmP15sha512_state_st", target_cpu = "x86-64", target_features = #llvm.target_features<["+cmov", "+cx8", "+fxsr", "+mmx", "+sse", "+sse2", "+x87"]>, tune_cpu = "generic", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg18: !llvm.ptr, %arg19: i64, %arg20: !llvm.ptr):
  %137 = "llvm.mlir.constant"() <{value = -128 : i8}> : () -> i8
  %138 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %139 = "llvm.mlir.constant"() <{value = 111 : i16}> : () -> i16
  %140 = "llvm.mlir.constant"() <{value = 127 : i64}> : () -> i64
  %141 = "llvm.mlir.constant"() <{value = 0 : i32}> : () -> i32
  %142 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %143 = "llvm.mlir.constant"() <{value = 112 : i64}> : () -> i64
  %144 = "llvm.mlir.constant"() <{value = 3 : i64}> : () -> i64
  %145 = "llvm.getelementptr"(%arg20) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 80>}> : (!llvm.ptr) -> !llvm.ptr
  %146 = "llvm.getelementptr"(%arg20) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 64>}> : (!llvm.ptr) -> !llvm.ptr
  %147 = "llvm.load"(%146) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i16
  %148 = "llvm.zext"(%147) : (i16) -> i64
  %149 = "llvm.getelementptr"(%145, %148) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  "llvm.store"(%137, %149) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  %150 = "llvm.add"(%148, %138) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %151 = "llvm.icmp"(%147, %139) <{predicate = 8 : i64}> : (i16, i16) -> i1
  "llvm.cond_br"(%151, %150)[^bb1, ^bb2] <{operandSegmentSizes = array<i32: 1, 0, 1>}> : (i1, i64) -> ()
^bb1:  // pred: ^bb0
  %152 = "llvm.getelementptr"(%145, %150) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %153 = "llvm.sub"(%140, %148) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %154 = "llvm.call"(%152, %141, %153) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @_ZN4bssl14OPENSSL_memsetEPvim, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>, res_attrs = [{llvm.noundef}]}> : (!llvm.ptr, i32, i64) -> !llvm.ptr
  "llvm.call"(%arg20, %145, %138) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @_ZL23sha512_block_data_orderPmPKhm, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  "llvm.br"(%142)[^bb2] : (i64) -> ()
^bb2(%155: i64):  // 2 preds: ^bb0, ^bb1
  %156 = "llvm.getelementptr"(%145, %155) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %157 = "llvm.sub"(%143, %155) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %158 = "llvm.call"(%156, %141, %157) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.noundef}], callee = @_ZN4bssl14OPENSSL_memsetEPvim, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>, res_attrs = [{llvm.noundef}]}> : (!llvm.ptr, i32, i64) -> !llvm.ptr
  %159 = "llvm.getelementptr"(%arg20) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 68>}> : (!llvm.ptr) -> !llvm.ptr
  %160 = "llvm.load"(%159) <{alignment = 4 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i32
  %161 = "llvm.zext"(%160) : (i32) -> i64
  %162 = "llvm.getelementptr"(%arg20) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 72>}> : (!llvm.ptr) -> !llvm.ptr
  %163 = "llvm.load"(%162) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %164 = "llvm.intr.fshl"(%161, %163, %144) : (i64, i64, i64) -> i64
  %165 = "llvm.shl"(%163, %144) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %166 = "llvm.getelementptr"(%arg20) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 192>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.call"(%166, %164) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @_ZN4bssl19CRYPTO_store_u64_beEPvm, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, i64) -> ()
  %167 = "llvm.getelementptr"(%arg20) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 200>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.call"(%167, %165) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @_ZN4bssl19CRYPTO_store_u64_beEPvm, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, i64) -> ()
  "llvm.call"(%arg20, %145, %138) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef}], callee = @_ZL23sha512_block_data_orderPmPKhm, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
  %168 = "llvm.lshr"(%arg19, %144) : (i64, i64) -> i64
  %169 = "llvm.icmp"(%168, %142) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%169, %142, %arg18)[^bb3, ^bb4] <{operandSegmentSizes = array<i32: 1, 0, 2>}> : (i1, i64, !llvm.ptr) -> ()
^bb3:  // 2 preds: ^bb2, ^bb4
  "llvm.call"() <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<tail>, callee = @_ZN4bssl35FIPS_service_indicator_update_stateEv, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 0, 0>}> : () -> ()
  "llvm.return"() : () -> ()
^bb4(%170: i64, %171: !llvm.ptr):  // 2 preds: ^bb2, ^bb4
  %172 = "llvm.getelementptr"(%arg20, %170) <{elem_type = !llvm.array<8 x i8>, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: -2147483648>}> : (!llvm.ptr, i64) -> !llvm.ptr
  %173 = "llvm.load"(%172) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  "llvm.call"(%171, %173) <{CConv = #llvm.cconv<ccc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @_ZN4bssl19CRYPTO_store_u64_beEPvm, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, i64) -> ()
  %174 = "llvm.getelementptr"(%171) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %175 = "llvm.add"(%170, %138) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %176 = "llvm.icmp"(%175, %168) <{predicate = 0 : i64}> : (i64, i64) -> i1
  "llvm.cond_br"(%176, %175, %174)[^bb3, ^bb4] <{loop_annotation = #loop_annotation, operandSegmentSizes = array<i32: 1, 0, 2>}> : (i1, i64, !llvm.ptr) -> ()
}) : () -> ()
  with @_ZL23sha512_block_data_orderPmPKhm := sha512_block_data_order,
    @_ZN4bssl14OPENSSL_memsetEPvim := OPENSSL_memset,
    @_ZN4bssl19CRYPTO_store_u64_beEPvm := CRYPTO_store_u64_be,
    @_ZN4bssl35FIPS_service_indicator_update_stateEv := FIPS_service_indicator_update_state

end

end MLIR.Boringssl
