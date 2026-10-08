module

-- build/native/gcc/mlir_canonicalized/avx512/region/fd_ed25519_point_from.mlir

public import SSA.Projects.RIR.Semantics.Func
public import SSA.Projects.RIR.Syntax.Elab

meta import SSA.Projects.RIR.Semantics.Func

namespace LeanMLIR.RIR.Firedancer.Avx512

@[expose] public section

mlir_def fd_ed25519_point_from :=
{
  ^bb0(%arg0: !llvm.ptr, %arg1: !llvm.ptr, %arg2: !llvm.ptr, %arg3: !llvm.ptr, %arg4: !llvm.ptr):
    %0 = "llvm.mlir.constant"() <{value = dense<[0, 1, 8, 9, 4, 5, 12, 13]> : vector<8xi64>}> : () -> vector<8xi64>
    %1 = "llvm.mlir.constant"() <{value = dense<[2, 3, 10, 11, 6, 7, 12, 13]> : vector<8xi64>}> : () -> vector<8xi64>
    %2 = "llvm.load"(%arg1) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
    %3 = "llvm.load"(%arg2) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
    %4 = "llvm.load"(%arg3) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
    %5 = "llvm.load"(%arg4) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> vector<8xi64>
    %6 = "x86vector.avx512.intr.vpermi2var.q.512"(%2, %0, %4) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
    %7 = "x86vector.avx512.intr.vpermi2var.q.512"(%3, %0, %5) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
    %8 = "x86vector.avx512.intr.vpermi2var.q.512"(%2, %1, %4) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
    %9 = "x86vector.avx512.intr.vpermi2var.q.512"(%3, %1, %5) : (vector<8xi64>, vector<8xi64>, vector<8xi64>) -> vector<8xi64>
    %10 = "llvm.shufflevector"(%6, %7) <{mask = array<i32: 0, 8, 2, 10, 4, 12, 6, 14>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
    %11 = "llvm.shufflevector"(%6, %7) <{mask = array<i32: 1, 9, 3, 11, 5, 13, 7, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
    %12 = "llvm.shufflevector"(%8, %9) <{mask = array<i32: 0, 8, 2, 10, -1, -1, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
    %13 = "llvm.shufflevector"(%8, %9) <{mask = array<i32: 1, 9, 3, 11, -1, -1, -1, -1>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
    %14 = "llvm.shufflevector"(%10, %13) <{mask = array<i32: 0, 1, 2, 3, 8, 9, 10, 11>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
    "llvm.store"(%14, %arg0) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<8xi64>, !llvm.ptr) -> ()
    %15 = "llvm.shufflevector"(%11, %10) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
    %16 = "llvm.getelementptr"(%arg0) <{elem_type = !llvm.struct<"struct.fd_curve25519_edwards", (vector<8xi64>, vector<8xi64>, vector<8xi64>)>, inbounds, rawConstantIndices = array<i32: 0, 1>}> : (!llvm.ptr) -> !llvm.ptr
    "llvm.store"(%15, %16) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<8xi64>, !llvm.ptr) -> ()
    %17 = "llvm.shufflevector"(%12, %11) <{mask = array<i32: 0, 1, 2, 3, 12, 13, 14, 15>}> : (vector<8xi64>, vector<8xi64>) -> vector<8xi64>
    %18 = "llvm.getelementptr"(%arg0) <{elem_type = !llvm.struct<"struct.fd_curve25519_edwards", (vector<8xi64>, vector<8xi64>, vector<8xi64>)>, inbounds, rawConstantIndices = array<i32: 0, 2>}> : (!llvm.ptr) -> !llvm.ptr
    "llvm.store"(%17, %18) <{alignment = 64 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (vector<8xi64>, !llvm.ptr) -> ()
    "llvm.return"(%arg0) : (!llvm.ptr) -> ()
}

end

end LeanMLIR.RIR.Firedancer.Avx512
