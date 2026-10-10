module

public import MLIR.Run.Tactic
public import Firedancer.Common.Tactics
public import Boringssl.Common.Point
public import Sodium.Common.Point
public import Sodium.fe25519_add
public import Sodium.fe25519_sub
public import Sodium.fe25519_sq
public import Sodium.fe25519_sq2
public import Sodium.Mlir.ge25519_p2_dbl

namespace MLIR.Sodium

/-! ## Specification -/

@[expose] public section

open Firedancer.Ref in
/-- `2 P` as a `ge25519_p1p1`, as the C names it: `X = (X + Y)² - (Y² + X²)`, `Y = Y² + X²`,
`Z = Y² - X²`, `T = 2 Z² - (Y² - X²)`, the sums not carried. -/
def ge25519_p2_dbl.spec (P : GeP2) : GeP1p1 :=
  let rX := fe25519_sq.spec P.X
  let rZ := fe25519_sq.spec P.Y
  let rT := fe25519_sq2.spec P.Z
  let rY := fiat_25519_add.spec P.X P.Y
  let t0 := fe25519_sq.spec rY
  let rY := fiat_25519_add.spec rZ rX
  let rZ := fe25519_sub.spec rZ rX
  let rX := fe25519_sub.spec t0 rY
  let rT := fe25519_sub.spec rT rZ
  ⟨rX, rY, rZ, rT⟩

end

/-! ## Proof -/

section Proof

/-- `ge25519_p2_dbl` stores `spec` of the `ge25519_p2` at `p` at `r`, in another block. Its
temporary is freed again: only the counter moves on, by one block. -/
public theorem ge25519_p2_dbl.call_eq (r p : Pointer) (s : GlobalState) (hwf : s.WF)
    (hr : s.mem.PointRoom r) (hp : s.mem.Fe3Fit p) (hsep : r.id ≠ p.id) :
    ge25519_p2_dbl.call (ge25519_p2_dbl.args (.value r) (.value p)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 1⟩,
            mem := s.mem.storeP1p1 r (ge25519_p2_dbl.spec (s.mem.readP2 p)) }) := by
  func_init
  have hp₀ : S₀.mem.Fe3Fit p := hS ▸ hp
  have hr₀ : S₀.mem.PointRoom r := hS ▸ hr
  block_init
  step_pure
  -- fe25519 t0;
  step_alloca with t0
  step_pure
  limbs_room t0
  -- fe25519_sq(r->X, p->X); fe25519_sq(r->Z, p->Y); fe25519_sq2(r->T, p->Z);
  step_call using fe25519_sq.call_eq
  iterate 2 step_pure
  step_call using fe25519_sq.call_eq
  iterate 2 step_pure
  step_call using fe25519_sq2.call_eq
  -- fe25519_add(r->Y, p->X, p->Y); fe25519_sq(t0, r->Y);
  step_pure
  step_call using fe25519_add.call_eq
  step_call using fe25519_sq.call_eq
  -- fe25519_add(r->Y, r->Z, r->X); fe25519_sub(r->Z, r->Z, r->X);
  step_call using fe25519_add.call_eq
  step_call using fe25519_sub.call_eq
  -- fe25519_sub(r->X, t0, r->Y); fe25519_sub(r->T, r->T, r->Z);
  step_call using fe25519_sub.call_eq
  step_call using fe25519_sub.call_eq
  step_pure
  finish_block
  rw [hS]
  erase_frame
  sort_point_stores hr₀.1
  rfl

end Proof

end MLIR.Sodium
