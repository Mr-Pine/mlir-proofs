module

public import MLIR.Run.Tactic
public import Firedancer.Avx512.Common.Vec
public import Firedancer.Crc.Ed25519.Avx512.fd_r52x5_add
public import Firedancer.Crc.Ed25519.Avx512.fd_r52x5_mul
public import Firedancer.Crc.Ed25519.Avx512.fd_r52x5_sub
public import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_ge_to_table

namespace MLIR.Firedancer.Crc.Ed25519.Avx512

open Firedancer.Avx512

/-! ## Specification -/

@[expose] public section

/-- `fd_r52x5_ge_to_table`'s `c_k`: `2 d` reduced. -/
def fd_r52x5_ge_to_table.k : Wwl :=
  wwl 1859910466990425 932731440258426 1072319116312658 1815898335770999 633789495995903 0 0 0

/-- `fd_r52x5_ge_to_table( r, Q )`: the table entry `(X + Y, Y - X, Z, T (2 d))` of `Q`. -/
def fd_r52x5_ge_to_table.spec (X Y Z T : Wwl) : Wwl × Wwl × Wwl × Wwl :=
  let t1 := fd_r52x5_add.spec X Y
  let t2 := fd_r52x5_sub.spec Y X
  let t3 := fd_r52x5_mul.spec T fd_r52x5_ge_to_table.k
  (t1, t2, Z, t3)

end

/-! ## Proof -/

section Proof

/-- `fd_r52x5_ge_to_table( rX, rY, rZ, rT, … )` stores the four results at `rX … rT` in that order;
the pointers may alias. -/
public theorem fd_r52x5_ge_to_table.call_eq (rX rY rZ rT : Pointer) (X Y Z T : Wwl)
    (s : GlobalState) (hwf : s.WF) (hX : Room s.mem rX 512) (hY : Room s.mem rY 512)
    (hZ : Room s.mem rZ 512) (hT : Room s.mem rT 512) :
    fd_r52x5_ge_to_table.call
        (fd_r52x5_ge_to_table.args (.value rX) (.value rY) (.value rZ) (.value rT) (Ty.wrap X)
          (Ty.wrap Y) (Ty.wrap Z) (Ty.wrap T)) s =
      .value
        (.nil,
          let r := fd_r52x5_ge_to_table.spec X Y Z T
          { s with
            mem := (((s.mem.storeVec rX r.1).storeVec rY r.2.1).storeVec rZ r.2.2.1).storeVec rT
              r.2.2.2 }) := by
  func_init
  block_init
  step_pure
  step_call using fd_r52x5_add.call_eq
  step_call using fd_r52x5_sub.call_eq
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
