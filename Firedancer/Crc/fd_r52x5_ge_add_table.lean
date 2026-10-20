module

public import MLIR.Run.Tactic
public import Firedancer.Avx512.Common.Vec
public import Firedancer.Crc.fd_r52x5_add
public import Firedancer.Crc.fd_r52x5_mul
public import Firedancer.Crc.fd_r52x5_sub
public import Firedancer.Crc.Mlir.fd_r52x5_ge_add_table

namespace MLIR.Firedancer.Crc

open Firedancer.Avx512

/-! ## Specification -/

@[expose] public section

/-- `fd_r52x5_ge_add_table( r, P1, Q )` of the table entry `Q = (Y + X, Y - X, Z, 2 d T)`: the four
results `(E F, G H, F G, E H)` for `B = (Y + X) (X1 + Y1)`, `A = (Y - X) (Y1 - X1)`, `E = B - A`,
`D = Z (2 Z1)`, `C = T1 (2 d T)`, `F = D - C`, `G = C + D`, `H = A + B`. -/
def fd_r52x5_ge_add_table.spec (X1 Y1 Z1 T1 YpX YmX QZ QT2d : Wwl) : Wwl × Wwl × Wwl × Wwl :=
  let t1 := fd_r52x5_add.spec X1 Y1
  let t2 := fd_r52x5_mul.spec YpX t1
  let t3 := fd_r52x5_sub.spec Y1 X1
  let t4 := fd_r52x5_mul.spec YmX t3
  let t5 := fd_r52x5_sub.spec t2 t4
  let t6 := fd_r52x5_add.spec Z1 Z1
  let t7 := fd_r52x5_mul.spec QZ t6
  let t8 := fd_r52x5_mul.spec T1 QT2d
  let t9 := fd_r52x5_sub.spec t7 t8
  let t10 := fd_r52x5_mul.spec t5 t9
  let t11 := fd_r52x5_add.spec t8 t7
  let t12 := fd_r52x5_add.spec t4 t2
  let t13 := fd_r52x5_mul.spec t11 t12
  let t14 := fd_r52x5_mul.spec t9 t11
  let t15 := fd_r52x5_mul.spec t5 t12
  (t10, t13, t14, t15)

end

/-! ## Proof -/

section Proof

/-- `fd_r52x5_ge_add_table( rX, rY, rZ, rT, … )` stores the four results at `rX … rT` in that order;
the pointers may alias. -/
public theorem fd_r52x5_ge_add_table.call_eq (rX rY rZ rT : Pointer) (X1 Y1 Z1 T1 YpX YmX QZ QT2d : Wwl)
    (s : GlobalState) (hwf : s.WF) (hX : Room s.mem rX 512) (hY : Room s.mem rY 512)
    (hZ : Room s.mem rZ 512) (hT : Room s.mem rT 512) :
    fd_r52x5_ge_add_table.call
        (fd_r52x5_ge_add_table.args (.value rX) (.value rY) (.value rZ) (.value rT) (Ty.wrap X1)
          (Ty.wrap Y1) (Ty.wrap Z1) (Ty.wrap T1) (Ty.wrap YpX) (Ty.wrap YmX) (Ty.wrap QZ)
          (Ty.wrap QT2d)) s =
      .value
        (.nil,
          let r := fd_r52x5_ge_add_table.spec X1 Y1 Z1 T1 YpX YmX QZ QT2d
          { s with
            mem := (((s.mem.storeVec rX r.1).storeVec rY r.2.1).storeVec rZ r.2.2.1).storeVec rT
              r.2.2.2 }) := by
  func_init
  block_init
  step_call using fd_r52x5_add.call_eq
  step_call using fd_r52x5_mul.call_eq
  step_call using fd_r52x5_sub.call_eq
  step_call using fd_r52x5_mul.call_eq
  step_call using fd_r52x5_sub.call_eq
  step_call using fd_r52x5_add.call_eq
  step_call using fd_r52x5_mul.call_eq
  step_call using fd_r52x5_mul.call_eq
  step_call using fd_r52x5_sub.call_eq
  step_call using fd_r52x5_mul.call_eq
  step_call using fd_r52x5_add.call_eq
  step_call using fd_r52x5_add.call_eq
  step_call using fd_r52x5_mul.call_eq
  step_call using fd_r52x5_mul.call_eq
  step_call using fd_r52x5_mul.call_eq
  step_store
  step_store
  step_store
  step_store
  finish_block
  rw [hS]
  rfl

end Proof

end MLIR.Firedancer.Crc
