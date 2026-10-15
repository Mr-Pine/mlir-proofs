
module

public import MLIR.Semantics.GlobalInitializer
public import MLIR.Syntax.Elab



namespace Firedancer.LaneNI.Mlir

@[expose] public section

mlir_const_def fd_ed25519_base_point := "llvm.mlir.global"() <{addr_space = 0 : i32, alignment = 64 : i64, constant, dso_local, global_type = !llvm.array<1 x struct<"struct.fd_curve25519_edwards", (vector<8xi64>, vector<8xi64>, vector<8xi64>)>>, linkage = #llvm.linkage<internal>, sym_name = "fd_ed25519_base_point", unnamed_addr = 0 : i64, visibility_ = 0 : i64}> ({
  %0 = "llvm.mlir.undef"() : () -> !llvm.array<1 x struct<"struct.fd_curve25519_edwards", (vector<8xi64>, vector<8xi64>, vector<8xi64>)>>
  %1 = "llvm.mlir.constant"() <{value = dense<[1806891319892, 1759218604441, 0, 4963950264797, 286998243226, 879609302220, 0, 889305571247]> : vector<8xi64>}> : () -> vector<8xi64>
  %2 = "llvm.mlir.constant"() <{value = dense<[5175273663173, 5277655813324, 0, 2381000326097, 7581689711182, 7036874417766, 0, 787695955620]> : vector<8xi64>}> : () -> vector<8xi64>
  %3 = "llvm.mlir.constant"() <{value = dense<[5912276620570, 7036874417752, 1, 2970602692003, 1206867684910, 3518437208883, 0, 8002368565694]> : vector<8xi64>}> : () -> vector<8xi64>
  %4 = "llvm.mlir.undef"() : () -> !llvm.struct<"struct.fd_curve25519_edwards", (vector<8xi64>, vector<8xi64>, vector<8xi64>)>
  %5 = "llvm.insertvalue"(%4, %3) <{position = array<i64: 0>}> : (!llvm.struct<"struct.fd_curve25519_edwards", (vector<8xi64>, vector<8xi64>, vector<8xi64>)>, vector<8xi64>) -> !llvm.struct<"struct.fd_curve25519_edwards", (vector<8xi64>, vector<8xi64>, vector<8xi64>)>
  %6 = "llvm.insertvalue"(%5, %2) <{position = array<i64: 1>}> : (!llvm.struct<"struct.fd_curve25519_edwards", (vector<8xi64>, vector<8xi64>, vector<8xi64>)>, vector<8xi64>) -> !llvm.struct<"struct.fd_curve25519_edwards", (vector<8xi64>, vector<8xi64>, vector<8xi64>)>
  %7 = "llvm.insertvalue"(%6, %1) <{position = array<i64: 2>}> : (!llvm.struct<"struct.fd_curve25519_edwards", (vector<8xi64>, vector<8xi64>, vector<8xi64>)>, vector<8xi64>) -> !llvm.struct<"struct.fd_curve25519_edwards", (vector<8xi64>, vector<8xi64>, vector<8xi64>)>
  %8 = "llvm.insertvalue"(%0, %7) <{position = array<i64: 0>}> : (!llvm.array<1 x struct<"struct.fd_curve25519_edwards", (vector<8xi64>, vector<8xi64>, vector<8xi64>)>>, !llvm.struct<"struct.fd_curve25519_edwards", (vector<8xi64>, vector<8xi64>, vector<8xi64>)>) -> !llvm.array<1 x struct<"struct.fd_curve25519_edwards", (vector<8xi64>, vector<8xi64>, vector<8xi64>)>>
  "llvm.return"(%8) : (!llvm.array<1 x struct<"struct.fd_curve25519_edwards", (vector<8xi64>, vector<8xi64>, vector<8xi64>)>>) -> ()
}) : () -> ()

end

end Firedancer.LaneNI.Mlir
