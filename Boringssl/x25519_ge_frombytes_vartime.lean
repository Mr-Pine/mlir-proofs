module

public import MLIR.Run.Tactic
public import Firedancer.Common.Tactics
public import Boringssl.Common.Point
public import Boringssl.Globals
public import Boringssl.fe_frombytes
public import Boringssl.fe_1
public import Boringssl.fe_sq_tt
public import Boringssl.fe_mul_ttt
public import Boringssl.fe_mul_ttl
public import Boringssl.fe_sub
public import Boringssl.fe_add
public import Boringssl.fe_carry
public import Boringssl.fe_neg
public import Boringssl.fe_pow22523
public import Boringssl.fe_isnonzero_fe_loose
public import Boringssl.fe_isnegative
public import Boringssl.Mlir.x25519_ge_frombytes_vartime
import Std.Tactic.BVDecide
meta import Std.Tactic.BVDecide.Reflect

namespace MLIR.Boringssl

/-! ## Specification -/

@[expose] public section

namespace x25519_ge_frombytes_vartime

open Firedancer.Ref

/-- `y`: `s`'s low 255 bits. -/
def y (s : BitVec 256) : Fin 5 → BitVec 64 :=
  fiat_25519_from_bytes.spec s

/-- `u = y² - 1`, carried. -/
def u (s : BitVec 256) : Fin 5 → BitVec 64 :=
  fiat_25519_carry.spec (fiat_25519_sub.spec (fiat_25519_carry_square.spec (y s)) fe_1.spec)

/-- `v = d y² + 1`. -/
def v (s : BitVec 256) : Fin 5 → BitVec 64 :=
  fiat_25519_add.spec
    (fiat_25519_carry_mul.spec (fiat_25519_carry_square.spec (y s)) fd_f25519_d.limbs) fe_1.spec

/-- The candidate root `x = u (u v)^((p - 5) / 8)`. -/
def x (s : BitVec 256) : Fin 5 → BitVec 64 :=
  fiat_25519_carry_mul.spec (fd_f25519_pow22523.spec (fiat_25519_carry_mul.spec (u s) (v s))) (u s)

/-- `v x²`. -/
def vxx (s : BitVec 256) : Fin 5 → BitVec 64 :=
  fiat_25519_carry_mul.spec (fiat_25519_carry_square.spec (x s)) (v s)

/-- `fe_isnonzero(v x² - u)`: `0` when `x` is a root. -/
def check₁ (s : BitVec 256) : BitVec 32 :=
  fe_isnonzero_fe_loose.spec (fiat_25519_sub.spec (vxx s) (u s))

/-- `fe_isnonzero(v x² + u)`: `0` when `√-1 x` is a root. -/
def check₂ (s : BitVec 256) : BitVec 32 :=
  fe_isnonzero_fe_loose.spec (fiat_25519_add.spec (vxx s) (u s))

/-- The root `x` of sign `s`'s top bit, from a root `x` of either sign. -/
def signed (s : BitVec 256) (x : Fin 5 → BitVec 64) : Fin 5 → BitVec 64 :=
  if fd_f25519_sgn.spec x = (s.extractLsb' 248 8 >>> 7).setWidth 32 then x
  else fiat_25519_carry.spec (fiat_25519_opp.spec x)

/-- The `ge_p3` `(x : y : 1 : x y)` for a root `x`, its sign fixed. -/
def point (s : BitVec 256) (x : Fin 5 → BitVec 64) : GeP3 :=
  let x := signed s x
  ⟨x, y s, fe_1.spec, fiat_25519_carry_mul.spec x (y s)⟩

/-- The blocks the call uses on each path. -/
def blocks (s : BitVec 256) : Nat :=
  if check₁ s = 0#32 then 58 else if check₂ s = 0#32 then 82 else 60

end x25519_ge_frombytes_vartime

open x25519_ge_frombytes_vartime Firedancer.Ref in
/-- The point `s` encodes, `none` when neither `x` nor `√-1 x` is a root of `v x² = u`. -/
def x25519_ge_frombytes_vartime.spec (s : BitVec 256) : Option GeP3 :=
  if check₁ s = 0#32 then some (point s (x s))
  else
    if check₂ s = 0#32 then some (point s (fiat_25519_carry_mul.spec (x s) fd_f25519_sqrtm1.limbs))
    else none

end

/-! ## Proof -/

section Proof

open x25519_ge_frombytes_vartime

/-- A byte shifted right by 7 has a clear sign bit. -/
private theorem lshr_seven_msb (b : BitVec 8) : (b >>> 7).msb = false := by bv_decide

-- five paths of up to thirty calls, eight blocks' facts carried through each: about 250000
-- heartbeats
set_option maxHeartbeats 400000 in
/-- `x25519_ge_frombytes_vartime` decodes the 32 bytes at `buf` into the `ge_p3` at `h`: when
`spec` is a point, it stores it and returns 1; else it returns 0, `h`'s `X, Y, Z` holding the
candidate `(x : y : 1)`. `h` is in another block than `buf`. The globals', temporaries' and callees'
blocks are freed again: only the counter moves on, by `blocks`. -/
public theorem x25519_ge_frombytes_vartime.call_eq (h buf : Pointer) (s : GlobalState) (hwf : s.WF)
    (hh : s.mem.PointRoom h) (hbuf : Fits s.mem buf (8 * 32))
    (hbuf_off : ¬buf.offset.uaddOverflow 32#64) (hsep : h.id ≠ buf.id) :
    x25519_ge_frombytes_vartime.call (x25519_ge_frombytes_vartime.args (.value h) (.value buf)) s =
      .value
        (.cons
            (.value
              (if (x25519_ge_frombytes_vartime.spec (s.mem.readAt buf 256)).isSome then 1#32
              else 0#32))
            .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + blocks (s.mem.readAt buf 256)⟩,
            mem :=
              (x25519_ge_frombytes_vartime.spec (s.mem.readAt buf 256)).elim
                (s.mem.storeP2 h ⟨x (s.mem.readAt buf 256), y (s.mem.readAt buf 256), fe_1.spec⟩)
                (s.mem.storeP3 h) }) := by
  -- `buf`'s bytes, the counter and the result kept opaque (`generalize` would be beta-reduced back)
  obtain ⟨b, hb⟩ : ∃ b, s.mem.readAt buf 256 = b := ⟨_, rfl⟩
  obtain ⟨n, hn⟩ : ∃ n, blocks b = n := ⟨_, rfl⟩
  obtain ⟨res, hres⟩ : ∃ res, x25519_ge_frombytes_vartime.spec b = res := ⟨_, rfl⟩
  rw [hb, hn, hres]
  func_init
  have hh₀ : S₀.mem.PointRoom h := hS ▸ hh
  have hh_off : h.offset.toNat + 160 ≤ 2 ^ 64 := hh.1
  block_init
  step_pure
  step_addressof d.value_eq with dp
  step_pure
  step_addressof sqrtm1.value_eq with sqrtm1p
  step_pure
  -- fe u; fe_loose v; fe w; fe vxx; fe_loose check;
  step_alloca with u
  step_alloca with v
  step_alloca with w
  step_alloca with vxx
  step_alloca with check
  step_alloca with t
  have hd_read := Boringssl.d.readLimbs hdp_fits hdp_off hread_dp
  have hsqrtm1_read := Boringssl.sqrtm1.readLimbs hsqrtm1p_fits hsqrtm1p_off hread_sqrtm1p
  clear hread_dp hread_sqrtm1p
  limbs_fit dp
  limbs_fit sqrtm1p
  iterate 5 step_pure
  limbs_room u
  limbs_room v
  limbs_room w
  limbs_room vxx
  limbs_room check
  -- fe_frombytes(&h->Y, s); fe_1(&h->Z);
  step_pure
  step_call using fe_frombytes.call_eq
  name_limbs ly
  step_pure
  step_call using fe_1.call_eq
  -- fe_sq_tt(&w, &h->Y); fe_mul_ttt(&vxx, &w, &d);
  step_call using fe_sq_tt.call_eq
  name_limbs lw0
  step_call using fe_mul_ttt.call_eq consuming hd_read hdp_limbs
  name_limbs lvxx0
  -- fe_sub(&v, &w, &h->Z); fe_carry(&u, &v); fe_add(&v, &vxx, &h->Z);
  step_call using fe_sub.call_eq consuming hread_w
  name_limbs lv0
  step_call using fe_carry.call_eq consuming hread_v
  name_limbs lu
  step_call using fe_add.call_eq consuming hread_vxx hread_h_80
  name_limbs lv
  -- fe_mul_ttl(&w, &u, &v); fe_pow22523(&h->X, &w); fe_mul_ttt(&h->X, &h->X, &u);
  step_call using fe_mul_ttl.call_eq
  name_limbs lw
  step_call using fe_pow22523.call_eq consuming hread_w hw_limbs
  name_limbs lx0
  step_call using fe_mul_ttt.call_eq
  name_limbs lx
  -- fe_sq_tt(&vxx, &h->X); fe_mul_ttl(&vxx, &vxx, &v); fe_sub(&check, &vxx, &u);
  step_call using fe_sq_tt.call_eq
  name_limbs lxx
  step_call using fe_mul_ttl.call_eq consuming hread_v hv_limbs
  name_limbs lvxx
  step_call using fe_sub.call_eq
  name_limbs lcheck
  -- if (fe_isnonzero(&check)) {
  step_call using fe_isnonzero_fe_loose.call_eq with check1 consuming hread_check
  rw [← hlvxx, ← hlu, ← hlcheck] at hcheck1
  step_pure
  finish_block
  all_goals
    have hc1 := hbr
    rw [hcheck1] at hc1
    clear hbr hcheck1
  case' isFalse =>
    -- fe_add(&check, &vxx, &u); if (fe_isnonzero(&check)) return 0;
    block_init
    step_call using fe_add.call_eq consuming hread_vxx hvxx_limbs hread_u hu_limbs
    name_limbs lcheck2
    step_call using fe_isnonzero_fe_loose.call_eq with check2 consuming hread_check hcheck_limbs
    rw [← hlvxx, ← hlu, ← hlcheck2] at hcheck2
    step_pure
    finish_block
    all_goals
      have hc2 := hbr
      rw [hcheck2] at hc2
      clear hbr hcheck2
    case isFalse =>
      -- return 0;
      clear_reads
      clear_facts h buf u v w vxx check t dp sqrtm1p
      block_init
      iterate 5 step_pure
      finish_block
      rw [hS]
      clear hS
      erase_frame
      subst_vars
      simp only [MemoryState.storeLimbs_storeLimbs_self]
      rw [MemoryState.storeLimbs_comm_fe_X (a := 80) hh_off (by omega) (by omega),
        MemoryState.storeLimbs_comm_fe_X (a := 40) hh_off (by omega) (by omega)]
      simp only [x25519_ge_frombytes_vartime.spec, blocks, check₁, check₂, vxx, x, u, v, y]
      simp only [hc1, hc2, ↓reduceIte, Option.isSome_none, Option.elim_none, Bool.false_eq_true]
      rfl
    -- fe_mul_ttt(&h->X, &h->X, &sqrtm1);
    block_init
    step_call using fe_mul_ttt.call_eq
    name_limbs lx1
    finish_block
  all_goals
    -- the checks' temporaries and the globals are dead
    clear_facts u vxx check sqrtm1p
    clear hsqrtm1_read
    -- if (fe_isnegative(&h->X) != (s[31] >> 7)) {
    block_init
    step_call using fe_isnegative.call_eq with sgn_x
    step_pure
    step_load with buf31 consuming hb hbuf
    step_pure with expected_x_sign
    have hmsb : expected_x_sign.msb = false := hexpected_x_sign ▸ lshr_seven_msb buf31
    step_pure [hmsb]
    step_pure
    finish_block
    all_goals
      have hsgn := hbr
      rw [hsgn_x] at hsgn
      clear hbr hsgn_x
    case' isFalse =>
      -- fe_loose t; fe_neg(&t, &h->X); fe_carry(&h->X, &t);
      block_init
      step_pure
      limbs_room t
      step_call using fe_neg.call_eq
      name_limbs lt
      step_call using fe_carry.call_eq
      name_limbs lx2
      step_pure
      finish_block
    all_goals
      -- fe_mul_ttt(&h->T, &h->X, &h->Y); return 1;
      block_init
      step_pure
      step_call using fe_mul_ttt.call_eq
      name_limbs lT
      -- only the state's definition is needed from here on
      clear_reads
      clear_facts h buf u v w vxx check t
      finish_block
      block_init
      iterate 5 step_pure
      finish_block
      rw [hS]
      clear hS
      erase_frame
      subst_vars
      simp only [MemoryState.storeLimbs_storeLimbs_self]
      rw [MemoryState.storeLimbs_comm_fe_X (a := 80) hh_off (by omega) (by omega),
        MemoryState.storeLimbs_comm_fe_X (a := 40) hh_off (by omega) (by omega)]
      simp only [x25519_ge_frombytes_vartime.spec, blocks, point, signed, check₁, check₂, vxx, x, u,
        v, y]
      simp only [*, ↓reduceIte, Option.isSome_some, Option.elim_some]
      rfl

end Proof

end MLIR.Boringssl
