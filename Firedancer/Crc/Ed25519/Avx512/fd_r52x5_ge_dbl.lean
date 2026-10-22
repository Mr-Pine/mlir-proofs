module

public import MLIR.Run.Tactic
public import Firedancer.Avx512.Common.Vec
public import Firedancer.Crc.Ed25519.Avx512.fd_r52x5_add
public import Firedancer.Crc.Ed25519.Avx512.fd_r52x5_mul
public import Firedancer.Crc.Ed25519.Avx512.fd_r52x5_sqr
public import Firedancer.Crc.Ed25519.Avx512.fd_r52x5_sub
public import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_ge_dbl

namespace MLIR.Firedancer.Crc.Ed25519.Avx512

open Firedancer.Avx512

/-! ## Specification -/

@[expose] public section

/-- `fd_r52x5_ge_dbl( r, P1 )`'s four results `(X, Y, Z, T)`, in the generated source's order:
`(E F, H G, G F, H E)` for `A = X1^2`, `B = Y1^2`, `H = A + B`, `E = H - (X1 + Y1)^2`, `G = A - B`,
`F = 2 Z1^2 + G`; `T1` is not read. -/
def fd_r52x5_ge_dbl.spec (X1 Y1 Z1 : Wwl) : Wwl × Wwl × Wwl × Wwl :=
  let t1 := fd_r52x5_sqr.spec X1
  let t2 := fd_r52x5_sqr.spec Y1
  let t3 := fd_r52x5_add.spec t1 t2
  let t4 := fd_r52x5_add.spec X1 Y1
  let t5 := fd_r52x5_sqr.spec t4
  let t6 := fd_r52x5_sub.spec t3 t5
  let t7 := fd_r52x5_sqr.spec Z1
  let t8 := fd_r52x5_add.spec t7 t7
  let t9 := fd_r52x5_sub.spec t1 t2
  let t10 := fd_r52x5_add.spec t8 t9
  let t11 := fd_r52x5_mul.spec t6 t10
  let t12 := fd_r52x5_mul.spec t3 t9
  let t13 := fd_r52x5_mul.spec t9 t10
  let t14 := fd_r52x5_mul.spec t3 t6
  (t11, t12, t13, t14)

end

/-! ## Proof -/

section Proof

/-- `fd_r52x5_ge_dbl( rX, rY, rZ, rT, … )` stores the four results at `rX … rT` in that order; the
pointers may alias. -/
public theorem fd_r52x5_ge_dbl.call_eq (rX rY rZ rT : Pointer) (X1 Y1 Z1 T1 : Wwl) (s : GlobalState)
    (hwf : s.WF) (hX : Room s.mem rX 512) (hY : Room s.mem rY 512) (hZ : Room s.mem rZ 512)
    (hT : Room s.mem rT 512) :
    fd_r52x5_ge_dbl.call
        (fd_r52x5_ge_dbl.args (.value rX) (.value rY) (.value rZ) (.value rT) (Ty.wrap X1)
          (Ty.wrap Y1) (Ty.wrap Z1) (Ty.wrap T1)) s =
      .value
        (.nil,
          let r := fd_r52x5_ge_dbl.spec X1 Y1 Z1
          { s with
            mem := (((s.mem.storeVec rX r.1).storeVec rY r.2.1).storeVec rZ r.2.2.1).storeVec rT
              r.2.2.2 }) := by
  func_init
  block_init
  step_call using fd_r52x5_sqr.call_eq
  step_call using fd_r52x5_sqr.call_eq
  step_call using fd_r52x5_add.call_eq
  step_call using fd_r52x5_add.call_eq
  step_call using fd_r52x5_sqr.call_eq
  step_call using fd_r52x5_sub.call_eq
  step_call using fd_r52x5_sqr.call_eq
  step_call using fd_r52x5_add.call_eq
  step_call using fd_r52x5_sub.call_eq
  step_call using fd_r52x5_add.call_eq
  step_call using fd_r52x5_mul.call_eq
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

end MLIR.Firedancer.Crc.Ed25519.Avx512
