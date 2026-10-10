module

public import MLIR.Run.Tactic
public import Firedancer.Common.Tactics
public import Boringssl.Common.Point
public import Boringssl.fe_add
public import Boringssl.fe_sub
public import Boringssl.fe_carry
public import Boringssl.fe_mul_tll
public import Boringssl.fe_mul_tlt
public import Boringssl.fe_mul_ttl
public import Boringssl.Mlir.x25519_ge_add

namespace MLIR.Boringssl

/-! ## Specification -/

@[expose] public section

open Firedancer.Ref in
/-- `P + Q` as a `ge_p1p1`, as the C names it: for `PP = (Y + X) YplusX`, `MM = (Y - X) YminusX`,
`TT = T2d T`, `ZZ = Z Z'`, `X = PP - MM`, `Y = PP + MM`, `Z = 2 ZZ + TT`, `T = 2 ZZ - TT`. -/
def x25519_ge_add.spec (P : GeP3) (Q : GeCached) : GeP1p1 :=
  let rX := fiat_25519_add.spec P.Y P.X
  let rY := fiat_25519_sub.spec P.Y P.X
  let trZ := fiat_25519_carry_mul.spec rX Q.YplusX
  let trY := fiat_25519_carry_mul.spec rY Q.YminusX
  let trT := fiat_25519_carry_mul.spec Q.T2d P.T
  let trX := fiat_25519_carry_mul.spec P.Z Q.Z
  let rT := fiat_25519_add.spec trX trX
  let rX := fiat_25519_sub.spec trZ trY
  let rY := fiat_25519_add.spec trZ trY
  let trZ := fiat_25519_carry.spec rT
  let rZ := fiat_25519_add.spec trZ trT
  let rT := fiat_25519_sub.spec trZ trT
  ⟨rX, rY, rZ, rT⟩

end

/-! ## Proof -/

section Proof

/-- `x25519_ge_add` stores `spec` of the `ge_p3` at `p` and the `ge_cached` at `q` at `r`, in
another block than both. Its four temporaries count four blocks. -/
public theorem x25519_ge_add.call_eq (r p q : Pointer) (s : GlobalState) (hwf : s.WF)
    (hr : s.mem.PointRoom r) (hp : s.mem.PointFit p) (hq : s.mem.PointFit q) (hrp : r.id ≠ p.id)
    (hrq : r.id ≠ q.id) :
    x25519_ge_add.call (x25519_ge_add.args (.value r) (.value p) (.value q)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 4⟩,
            mem :=
              s.mem.storeP1p1 r (x25519_ge_add.spec (s.mem.readP3 p) (s.mem.readCached q)) }) := by
  func_init
  have hp₀ : S₀.mem.PointFit p := hS ▸ hp
  have hq₀ : S₀.mem.PointFit q := hS ▸ hq
  have hr₀ : S₀.mem.PointRoom r := hS ▸ hr
  block_init
  step_pure
  -- fe trX, trY, trZ, trT;
  step_alloca with trX
  step_alloca with trY
  step_alloca with trZ
  step_alloca with trT
  iterate 4 step_pure
  limbs_room trX
  limbs_room trY
  limbs_room trZ
  limbs_room trT
  -- fe_add(&r->X, &p->Y, &p->X); fe_sub(&r->Y, &p->Y, &p->X);
  step_pure
  step_call using fe_add.call_eq
  step_pure
  step_call using fe_sub.call_eq
  -- fe_mul_tll(&trZ, &r->X, &q->YplusX); fe_mul_tll(&trY, &r->Y, &q->YminusX);
  step_call using fe_mul_tll.call_eq
  step_pure
  step_call using fe_mul_tll.call_eq
  -- fe_mul_tlt(&trT, &q->T2d, &p->T); fe_mul_ttl(&trX, &p->Z, &q->Z);
  iterate 2 step_pure
  step_call using fe_mul_tlt.call_eq
  iterate 2 step_pure
  step_call using fe_mul_ttl.call_eq
  -- fe_add(&r->T, &trX, &trX);
  step_pure
  step_call using fe_add.call_eq
  -- fe_sub(&r->X, &trZ, &trY); fe_add(&r->Y, &trZ, &trY);
  step_call using fe_sub.call_eq
  step_call using fe_add.call_eq
  -- fe_carry(&trZ, &r->T);
  step_call using fe_carry.call_eq
  -- fe_add(&r->Z, &trZ, &trT); fe_sub(&r->T, &trZ, &trT);
  step_pure
  step_call using fe_add.call_eq
  step_call using fe_sub.call_eq
  iterate 4 step_pure
  finish_block
  rw [hS]
  erase_frame
  rw [MemoryState.storeP1p1_of_XYTXYZT hr₀.1]
  rfl

end Proof

end MLIR.Boringssl
