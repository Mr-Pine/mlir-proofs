module

public import MLIR.Run.Tactic
public import Firedancer.Common.Tactics
public import Boringssl.Common.Point
public import Boringssl.fe_add
public import Boringssl.fe_sub
public import Boringssl.fe_carry
public import Boringssl.fe_sq_tt
public import Boringssl.fe_sq_tl
public import Boringssl.fe_sq2_tt
public import Boringssl.Mlir.ge_p2_dbl

namespace MLIR.Boringssl

/-! ## Specification -/

@[expose] public section

open Firedancer.Ref in
/-- `2 P` as a `ge_p1p1`, as the C names it: `X = (X + Y)² - (Y² + X²)`, `Y = Y² + X²`,
`Z = Y² - X²`, `T = 2 Z² - (Y² - X²)`. -/
def ge_p2_dbl.spec (P : GeP2) : GeP1p1 :=
  let trX := fiat_25519_carry_square.spec P.X
  let trZ := fiat_25519_carry_square.spec P.Y
  let trT := fe_sq2_tt.spec P.Z
  let rY := fiat_25519_add.spec P.X P.Y
  let t0 := fiat_25519_carry_square.spec rY
  let rY := fiat_25519_add.spec trZ trX
  let rZ := fiat_25519_sub.spec trZ trX
  let trZ := fiat_25519_carry.spec rY
  let rX := fiat_25519_sub.spec t0 trZ
  let trZ := fiat_25519_carry.spec rZ
  let rT := fiat_25519_sub.spec trT trZ
  ⟨rX, rY, rZ, rT⟩

end

/-! ## Proof -/

section Proof

/-- `ge_p2_dbl` stores `spec` of the `ge_p2` at `p` at `r`; all reads of `p` come first, so `r` may
alias it. Its four temporaries and `fe_sq2_tt`'s count five blocks. -/
public theorem ge_p2_dbl.call_eq (r p : Pointer) (s : GlobalState) (hwf : s.WF)
    (hr : s.mem.PointRoom r) (hp : s.mem.Fe3Fit p) :
    ge_p2_dbl.call (ge_p2_dbl.args (.value r) (.value p)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 5⟩,
            mem := s.mem.storeP1p1 r (ge_p2_dbl.spec (s.mem.readP2 p)) }) := by
  func_init
  have hp₀ : S₀.mem.Fe3Fit p := hS ▸ hp
  have hr₀ : S₀.mem.PointRoom r := hS ▸ hr
  block_init
  step_pure
  -- fe trX, trZ, trT; fe t0;
  step_alloca with trX
  step_alloca with trZ
  step_alloca with trT
  step_alloca with t0
  iterate 4 step_pure
  limbs_room trX
  limbs_room trZ
  limbs_room trT
  limbs_room t0
  -- fe_sq_tt(&trX, &p->X); fe_sq_tt(&trZ, &p->Y); fe_sq2_tt(&trT, &p->Z);
  step_call using fe_sq_tt.call_eq
  step_pure
  step_call using fe_sq_tt.call_eq
  step_pure
  step_call using fe_sq2_tt.call_eq
  -- fe_add(&r->Y, &p->X, &p->Y); fe_sq_tl(&t0, &r->Y);
  step_pure
  step_call using fe_add.call_eq
  step_call using fe_sq_tl.call_eq
  -- fe_add(&r->Y, &trZ, &trX); fe_sub(&r->Z, &trZ, &trX);
  step_call using fe_add.call_eq
  step_pure
  step_call using fe_sub.call_eq
  -- fe_carry(&trZ, &r->Y); fe_sub(&r->X, &t0, &trZ);
  step_call using fe_carry.call_eq
  step_call using fe_sub.call_eq
  -- fe_carry(&trZ, &r->Z); fe_sub(&r->T, &trT, &trZ);
  step_call using fe_carry.call_eq
  step_pure
  step_call using fe_sub.call_eq
  iterate 4 step_pure
  finish_block
  rw [hS]
  erase_frame
  rw [MemoryState.storeLimbs_storeLimbs_self,
    MemoryState.storeLimbs_comm_fe_X (a := 80) hr₀.1 (by omega) (by omega),
    MemoryState.storeLimbs_comm_fe_X (a := 40) hr₀.1 (by omega) (by omega)]
  rfl

end Proof

end MLIR.Boringssl
