module

-- boringssl-build/out/op/_ZL14fiat_25519_subPmPKmS1_.mlir
-- fiat_25519_sub(unsigned long*, unsigned long const*, unsigned long const*)

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

namespace MLIR.Boringssl

@[expose] public section

mlir_def fiat_25519_sub :=
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nocapture, llvm.nofree, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<void (ptr, ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"], ["warn-stack-size", "25344"]], sym_name = "_ZL14fiat_25519_subPmPKmS1_", target_cpu = "x86-64", target_features = #llvm.target_features<["+cmov", "+cx8", "+fxsr", "+mmx", "+sse", "+sse2", "+x87"]>, tune_cpu = "generic", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg91: !llvm.ptr, %arg92: !llvm.ptr, %arg93: !llvm.ptr):
  %1370 = "llvm.mlir.constant"() <{value = 4503599627370494 : i64}> : () -> i64
  %1371 = "llvm.mlir.constant"() <{value = dense<[4503599627370458, 4503599627370494]> : vector<2xi64>}> : () -> vector<2xi64>
  %1372 = "llvm.mlir.constant"() <{value = dense<4503599627370494> : vector<2xi64>}> : () -> vector<2xi64>
  %1373 = "llvm.getelementptr"(%arg92) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %1374 = "llvm.getelementptr"(%arg93) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %1375 = "llvm.getelementptr"(%arg92) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %1376 = "llvm.load"(%1375) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1377 = "llvm.add"(%1376, %1370) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1378 = "llvm.getelementptr"(%arg93) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %1379 = "llvm.load"(%1378) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i64
  %1380 = "llvm.sub"(%1377, %1379) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %1381 = "llvm.load"(%arg92) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<2xi64>
  %1382 = "llvm.add"(%1381, %1371) <{overflowFlags = 0 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1383 = "llvm.load"(%arg93) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<2xi64>
  %1384 = "llvm.sub"(%1382, %1383) <{overflowFlags = 0 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1385 = "llvm.getelementptr"(%arg91) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %1386 = "llvm.load"(%1373) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<2xi64>
  %1387 = "llvm.add"(%1386, %1372) <{overflowFlags = 0 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %1388 = "llvm.load"(%1374) <{alignment = 8 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<2xi64>
  %1389 = "llvm.sub"(%1387, %1388) <{overflowFlags = 0 : i32}> : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  "llvm.store"(%1384, %arg91) <{alignment = 8 : i64, ordering = 0 : i64}> : (vector<2xi64>, !llvm.ptr) -> ()
  "llvm.store"(%1389, %1385) <{alignment = 8 : i64, ordering = 0 : i64}> : (vector<2xi64>, !llvm.ptr) -> ()
  %1390 = "llvm.getelementptr"(%arg91) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%1380, %1390) <{alignment = 8 : i64, ordering = 0 : i64}> : (i64, !llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()

end

end MLIR.Boringssl
