module

public import MLIR.Run.Tactic
public import Firedancer.Avx512.Common.Vec
public import Firedancer.Crc.fd_r52x5_add
public import Firedancer.Crc.fd_r52x5_mul
public import Firedancer.Crc.fd_r52x5_sub
public import Firedancer.Crc.Mlir.fd_r52x5_ge_add

namespace MLIR.Firedancer.Crc

open Firedancer.Avx512

/-! ## Specification -/

@[expose] public section

/-- `fd_r52x5_ge_add`'s `c_k`: `2 d` reduced. -/
def fd_r52x5_ge_add.k : Wwl :=
  wwl 1859910466990425 932731440258426 1072319116312658 1815898335770999 633789495995903 0 0 0

/-- `fd_r52x5_ge_add( r, P1, P2 )`'s four results `(X, Y, Z, T)`, in the generated source's
order: `(E F, G H, G F, E H)` for `E = B - A`, `F = D - C`, `G = C + D`, `H = A + B` where `A, B`
are the products of `(Y - X, X + Y)`, `C = T1 (2 d) T2` and `D = 2 Z1 Z2`. -/
def fd_r52x5_ge_add.spec (X1 Y1 Z1 T1 X2 Y2 Z2 T2 : Wwl) : Wwl × Wwl × Wwl × Wwl :=
  let t1 := fd_r52x5_add.spec X1 Y1
  let t2 := fd_r52x5_add.spec X2 Y2
  let t3 := fd_r52x5_mul.spec t1 t2
  let t4 := fd_r52x5_sub.spec Y1 X1
  let t5 := fd_r52x5_sub.spec Y2 X2
  let t6 := fd_r52x5_mul.spec t4 t5
  let t7 := fd_r52x5_sub.spec t3 t6
  let t8 := fd_r52x5_add.spec Z1 Z1
  let t9 := fd_r52x5_mul.spec Z2 t8
  let t10 := fd_r52x5_mul.spec T1 fd_r52x5_ge_add.k
  let t11 := fd_r52x5_mul.spec T2 t10
  let t12 := fd_r52x5_sub.spec t9 t11
  let t13 := fd_r52x5_mul.spec t7 t12
  let t14 := fd_r52x5_add.spec t11 t9
  let t15 := fd_r52x5_add.spec t6 t3
  let t16 := fd_r52x5_mul.spec t14 t15
  let t17 := fd_r52x5_mul.spec t12 t14
  let t18 := fd_r52x5_mul.spec t7 t15
  (t13, t16, t17, t18)

end

/-! ## Proof -/

section Proof

/-- `fd_r52x5_ge_add( rX, rY, rZ, rT, … )` stores the four results at `rX … rT` in that order; the
pointers may alias. -/
public theorem fd_r52x5_ge_add.call_eq (rX rY rZ rT : Pointer) (X1 Y1 Z1 T1 X2 Y2 Z2 T2 : Wwl)
    (s : GlobalState) (hwf : s.WF) (hX : Room s.mem rX 512) (hY : Room s.mem rY 512)
    (hZ : Room s.mem rZ 512) (hT : Room s.mem rT 512) :
    fd_r52x5_ge_add.call
        (fd_r52x5_ge_add.args (.value rX) (.value rY) (.value rZ) (.value rT) (Ty.wrap X1)
          (Ty.wrap Y1) (Ty.wrap Z1) (Ty.wrap T1) (Ty.wrap X2) (Ty.wrap Y2) (Ty.wrap Z2)
          (Ty.wrap T2)) s =
      .value
        (.nil,
          let r := fd_r52x5_ge_add.spec X1 Y1 Z1 T1 X2 Y2 Z2 T2
          { s with
            mem := (((s.mem.storeVec rX r.1).storeVec rY r.2.1).storeVec rZ r.2.2.1).storeVec rT
              r.2.2.2 }) := by
  func_init
  block_init
  step_pure
  step_call using fd_r52x5_add.call_eq
  step_call using fd_r52x5_add.call_eq
  step_call using fd_r52x5_mul.call_eq
  step_call using fd_r52x5_sub.call_eq
  step_call using fd_r52x5_sub.call_eq
  step_call using fd_r52x5_mul.call_eq
  step_call using fd_r52x5_sub.call_eq
  step_call using fd_r52x5_add.call_eq
  step_call using fd_r52x5_mul.call_eq
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
