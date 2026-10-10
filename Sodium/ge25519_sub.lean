module

public import MLIR.Run.Tactic
public import Firedancer.Common.Tactics
public import Boringssl.Common.Point
public import Sodium.Common.Point
public import Sodium.fe25519_add
public import Sodium.fe25519_sub
public import Sodium.fe25519_mul
public import Sodium.Mlir.ge25519_sub

namespace MLIR.Sodium

/-! ## Specification -/

@[expose] public section

open Firedancer.Ref in
/-- `P - Q` as a `ge25519_p1p1`, as the C names it: for `PM = (Y + X) YminusX`,
`MP = (Y - X) YplusX`, `TT = T2d T`, `ZZ = Z Z'`: `X = PM - MP`, `Y = PM + MP`, `Z = 2 ZZ - TT`,
`T = 2 ZZ + TT`. -/
def ge25519_sub.spec (P : GeP3) (Q : GeCached) : GeP1p1 :=
  let rX := fiat_25519_add.spec P.Y P.X
  let rY := fe25519_sub.spec P.Y P.X
  let rZ := fe25519_mul.spec rX Q.YminusX
  let rY := fe25519_mul.spec rY Q.YplusX
  let rT := fe25519_mul.spec Q.T2d P.T
  let rX := fe25519_mul.spec P.Z Q.Z
  let t0 := fiat_25519_add.spec rX rX
  let rX := fe25519_sub.spec rZ rY
  let rY := fiat_25519_add.spec rZ rY
  let rZ := fe25519_sub.spec t0 rT
  let rT := fiat_25519_add.spec t0 rT
  ⟨rX, rY, rZ, rT⟩

end

/-! ## Proof -/

section Proof

/-- `ge25519_sub` stores `spec` of the `ge25519_p3` at `p` and the `ge25519_cached` at `q` at `r`,
in another block than both. Its temporary is freed again: only the counter moves on, by one block.
-/
public theorem ge25519_sub.call_eq (r p q : Pointer) (s : GlobalState) (hwf : s.WF)
    (hr : s.mem.PointRoom r) (hp : s.mem.PointFit p) (hq : s.mem.PointFit q) (hrp : r.id ≠ p.id)
    (hrq : r.id ≠ q.id) :
    ge25519_sub.call (ge25519_sub.args (.value r) (.value p) (.value q)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 1⟩,
            mem :=
              s.mem.storeP1p1 r (ge25519_sub.spec (s.mem.readP3 p) (s.mem.readCached q)) }) := by
  func_init
  have hp₀ : S₀.mem.PointFit p := hS ▸ hp
  have hq₀ : S₀.mem.PointFit q := hS ▸ hq
  have hr₀ : S₀.mem.PointRoom r := hS ▸ hr
  block_init
  step_pure
  -- fe25519 t0;
  step_alloca with t0
  step_pure
  limbs_room t0
  -- fe25519_add(r->X, p->Y, p->X); fe25519_sub(r->Y, p->Y, p->X);
  step_pure
  step_call using fe25519_add.call_eq
  step_pure
  step_call using fe25519_sub.call_eq
  -- fe25519_mul(r->Z, r->X, q->YminusX); fe25519_mul(r->Y, r->Y, q->YplusX);
  iterate 2 step_pure
  step_call using fe25519_mul.call_eq
  step_call using fe25519_mul.call_eq
  -- fe25519_mul(r->T, q->T2d, p->T);
  iterate 3 step_pure
  step_call using fe25519_mul.call_eq
  -- fe25519_mul(r->X, p->Z, q->Z); fe25519_add(t0, r->X, r->X);
  iterate 2 step_pure
  step_call using fe25519_mul.call_eq
  step_call using fe25519_add.call_eq
  -- fe25519_sub(r->X, r->Z, r->Y); fe25519_add(r->Y, r->Z, r->Y);
  step_call using fe25519_sub.call_eq
  step_call using fe25519_add.call_eq
  -- fe25519_sub(r->Z, t0, r->T); fe25519_add(r->T, t0, r->T);
  step_call using fe25519_sub.call_eq
  step_call using fe25519_add.call_eq
  step_pure
  finish_block
  rw [hS]
  erase_frame
  sort_point_stores hr₀.1
  rfl

end Proof

end MLIR.Sodium
