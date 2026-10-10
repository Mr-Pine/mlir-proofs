module

-- boringssl-build/out/op/_ZN4bssl17x25519_ge_tobytesEPhPKNS_5ge_p2E.mlir
-- bssl::x25519_ge_tobytes(unsigned char*, bssl::ge_p2 const*)

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Boringssl.Mlir.fe_mul_ttt
public import Boringssl.Mlir.fe_tobytes
public import Boringssl.Mlir.fe_isnegative
public import Boringssl.Mlir.fe_invert

meta import MLIR.Semantics.Func
meta import Boringssl.Mlir.fe_mul_ttt
meta import Boringssl.Mlir.fe_tobytes
meta import Boringssl.Mlir.fe_isnegative
meta import Boringssl.Mlir.fe_invert

namespace MLIR.Boringssl

@[expose] public section

mlir_def x25519_ge_tobytes :=
"llvm.func"() <{CConv = #llvm.cconv<ccc>, arg_attrs = [{llvm.nocapture, llvm.nofree, llvm.noundef}, {llvm.noundef}], dso_local, function_type = !llvm.func<void (ptr, ptr)>, linkage = #llvm.linkage<internal>, no_inline, no_unwind, passthrough = ["mustprogress", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"], ["warn-stack-size", "25344"]], sym_name = "_ZN4bssl17x25519_ge_tobytesEPhPKNS_5ge_p2E", target_cpu = "x86-64", target_features = #llvm.target_features<["+cmov", "+cx8", "+fxsr", "+mmx", "+sse", "+sse2", "+x87"]>, tune_cpu = "generic", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg167: !llvm.ptr, %arg168: !llvm.ptr):
  %1948 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %1949 = "llvm.mlir.constant"() <{value = 7 : i8}> : () -> i8
  %1950 = "llvm.alloca"(%1948) <{alignment = 8 : i64, elem_type = !llvm.struct<"struct.bssl::fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
  %1951 = "llvm.alloca"(%1948) <{alignment = 8 : i64, elem_type = !llvm.struct<"struct.bssl::fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
  %1952 = "llvm.alloca"(%1948) <{alignment = 8 : i64, elem_type = !llvm.struct<"struct.bssl::fe", (array<5 x i64>)>}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%1950) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1951) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%1952) : (!llvm.ptr) -> ()
  %1953 = "llvm.getelementptr"(%arg168) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 80>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.call"(%1950, %1953) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @_ZL9fe_invertPN4bssl2feEPKS0_, fastmathFlags = #llvm.fastmath<none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%1951, %arg168, %1950) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @_ZL10fe_mul_tttPN4bssl2feEPKS0_S3_, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  %1954 = "llvm.getelementptr"(%arg168) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 40>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.call"(%1952, %1954, %1950) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @_ZL10fe_mul_tttPN4bssl2feEPKS0_S3_, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 3, 0>}> : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
  "llvm.call"(%arg167, %1952) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.nonnull, llvm.noundef}], callee = @_ZL10fe_tobytesPhPKN4bssl2feE, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (!llvm.ptr, !llvm.ptr) -> ()
  %1955 = "llvm.call"(%1951) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.nonnull, llvm.noundef}], callee = @_ZL13fe_isnegativePKN4bssl2feE, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (!llvm.ptr) -> i32
  %1956 = "llvm.getelementptr"(%arg167) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 31>}> : (!llvm.ptr) -> !llvm.ptr
  %1957 = "llvm.load"(%1956) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %1958 = "llvm.trunc"(%1955) <{overflowFlags = 3 : i32}> : (i32) -> i8
  %1959 = "llvm.shl"(%1958, %1949) <{overflowFlags = 2 : i32}> : (i8, i8) -> i8
  %1960 = "llvm.xor"(%1959, %1957) : (i8, i8) -> i8
  "llvm.store"(%1960, %1956) <{alignment = 1 : i64, ordering = 0 : i64}> : (i8, !llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1952) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1951) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%1950) : (!llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()
  with @_ZL10fe_mul_tttPN4bssl2feEPKS0_S3_ := fe_mul_ttt,
    @_ZL10fe_tobytesPhPKN4bssl2feE := fe_tobytes, @_ZL13fe_isnegativePKN4bssl2feE := fe_isnegative,
    @_ZL9fe_invertPN4bssl2feEPKS0_ := fe_invert

end

end MLIR.Boringssl
