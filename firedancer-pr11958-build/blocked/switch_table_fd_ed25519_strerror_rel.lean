
module

public import MLIR.Semantics.GlobalInitializer
public import MLIR.Syntax.Elab

public import Firedancer.Lane.Mlir._str_7_56
public import Firedancer.Lane.Mlir._str_6_57
public import Firedancer.Lane.Mlir._str_5_58
public import Firedancer.Lane.Mlir._str_4_59
public import Firedancer.Lane.Mlir.switch_table_fd_ed25519_strerror_rel

namespace Firedancer.Lane.Mlir

@[expose] public section

mlir_const_def switch_table_fd_ed25519_strerror_rel := "llvm.mlir.global"() <{addr_space = 0 : i32, alignment = 4 : i64, constant, dso_local, global_type = !llvm.array<4 x i32>, linkage = #llvm.linkage<private>, sym_name = "switch.table.fd_ed25519_strerror.rel", unnamed_addr = 2 : i64, visibility_ = 0 : i64}> ({
  %0 = "llvm.mlir.undef"() : () -> !llvm.array<4 x i32>
  %1 = "llvm.mlir.addressof"() <{global_name = @".str.7.56"}> : () -> !llvm.ptr
  %2 = "llvm.mlir.addressof"() <{global_name = @".str.6.57"}> : () -> !llvm.ptr
  %3 = "llvm.mlir.addressof"() <{global_name = @".str.5.58"}> : () -> !llvm.ptr
  %4 = "llvm.mlir.addressof"() <{global_name = @".str.4.59"}> : () -> !llvm.ptr
  %5 = "llvm.mlir.addressof"() <{global_name = @switch.table.fd_ed25519_strerror.rel}> : () -> !llvm.ptr
  %6 = "llvm.ptrtoint"(%5) : (!llvm.ptr) -> i64
  %7 = "llvm.ptrtoint"(%4) : (!llvm.ptr) -> i64
  %8 = "llvm.sub"(%7, %6) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %9 = "llvm.trunc"(%8) <{overflowFlags = 0 : i32}> : (i64) -> i32
  %10 = "llvm.ptrtoint"(%3) : (!llvm.ptr) -> i64
  %11 = "llvm.sub"(%10, %6) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %12 = "llvm.trunc"(%11) <{overflowFlags = 0 : i32}> : (i64) -> i32
  %13 = "llvm.ptrtoint"(%2) : (!llvm.ptr) -> i64
  %14 = "llvm.sub"(%13, %6) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %15 = "llvm.trunc"(%14) <{overflowFlags = 0 : i32}> : (i64) -> i32
  %16 = "llvm.ptrtoint"(%1) : (!llvm.ptr) -> i64
  %17 = "llvm.sub"(%16, %6) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %18 = "llvm.trunc"(%17) <{overflowFlags = 0 : i32}> : (i64) -> i32
  %19 = "llvm.insertvalue"(%0, %18) <{position = array<i64: 0>}> : (!llvm.array<4 x i32>, i32) -> !llvm.array<4 x i32>
  %20 = "llvm.insertvalue"(%19, %15) <{position = array<i64: 1>}> : (!llvm.array<4 x i32>, i32) -> !llvm.array<4 x i32>
  %21 = "llvm.insertvalue"(%20, %12) <{position = array<i64: 2>}> : (!llvm.array<4 x i32>, i32) -> !llvm.array<4 x i32>
  %22 = "llvm.insertvalue"(%21, %9) <{position = array<i64: 3>}> : (!llvm.array<4 x i32>, i32) -> !llvm.array<4 x i32>
  "llvm.return"(%22) : (!llvm.array<4 x i32>) -> ()
}) : () -> ()

    with
      @.str.7.56 := Firedancer.Lane.Mlir._str_7_56,
      @.str.6.57 := Firedancer.Lane.Mlir._str_6_57,
      @.str.5.58 := Firedancer.Lane.Mlir._str_5_58,
      @.str.4.59 := Firedancer.Lane.Mlir._str_4_59,
      @switch.table.fd_ed25519_strerror.rel := Firedancer.Lane.Mlir.switch_table_fd_ed25519_strerror_rel

end

end Firedancer.Lane.Mlir
