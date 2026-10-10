module

public import MLIR.Run.Tactic
public import Firedancer.Common.Tactics
public import Boringssl.Common.Point
public import Sodium.Common.Point
public import Sodium.Globals
public import Sodium.fe25519_frombytes
public import Sodium.fe25519_1
public import Sodium.fe25519_sq
public import Sodium.fe25519_mul
public import Sodium.fe25519_sub
public import Sodium.fe25519_add
public import Sodium.fe25519_pow22523
public import Sodium.fe25519_iszero
public import Sodium.fe25519_isnegative
public import Sodium.fe25519_neg
public import Sodium.Mlir.ge25519_frombytes_negate_vartime
import Std.Tactic.BVDecide
meta import Std.Tactic.BVDecide.Reflect

namespace MLIR.Sodium

/-! ## Specification -/

@[expose] public section

namespace ge25519_frombytes_negate_vartime

open Firedancer.Ref

/-- `y`: `s`'s low 255 bits. -/
def y (s : BitVec 256) : Fin 5 → BitVec 64 :=
  fe25519_frombytes.spec s

/-- `u = y² - 1`. -/
def u (s : BitVec 256) : Fin 5 → BitVec 64 :=
  fe25519_sub.spec (fe25519_sq.spec (y s)) Boringssl.fe_1.spec

/-- `v = d y² + 1`, not carried. -/
def v (s : BitVec 256) : Fin 5 → BitVec 64 :=
  fiat_25519_add.spec (fe25519_mul.spec (fe25519_sq.spec (y s)) fd_f25519_d.limbs)
    Boringssl.fe_1.spec

/-- `v3 = v³`. -/
def v3 (s : BitVec 256) : Fin 5 → BitVec 64 :=
  fe25519_mul.spec (fe25519_sq.spec (v s)) (v s)

/-- The candidate root `x = u v³ (u v⁷)^((p - 5) / 8)`. -/
def x (s : BitVec 256) : Fin 5 → BitVec 64 :=
  let x := fe25519_mul.spec (fe25519_mul.spec (fe25519_sq.spec (v3 s)) (v s)) (u s)
  fe25519_mul.spec (fe25519_mul.spec (fe25519_pow22523.spec x) (v3 s)) (u s)

/-- `v x²`. -/
def vxx (s : BitVec 256) : Fin 5 → BitVec 64 :=
  fe25519_mul.spec (fe25519_sq.spec (x s)) (v s)

/-- `m_root_check = v x² - u`: `0` when `x` is a root. -/
def m_root_check (s : BitVec 256) : Fin 5 → BitVec 64 :=
  fe25519_sub.spec (vxx s) (u s)

/-- `p_root_check = v x² + u`: `0` when `√-1 x` is a root. -/
def p_root_check (s : BitVec 256) : Fin 5 → BitVec 64 :=
  fiat_25519_add.spec (vxx s) (u s)

/-- The sign `s` asks for, `s[31] >> 7`. -/
def sign (s : BitVec 256) : BitVec 32 :=
  (s.extractLsb' 248 8 >>> 7).setWidth 32

/-- The root `x` negated when its sign is `s`'s: the negation of the point `s` encodes. -/
def negated (s : BitVec 256) (x : Fin 5 → BitVec 64) : Fin 5 → BitVec 64 :=
  if fe25519_isnegative.spec x = sign s then fe25519_neg.spec x else x

/-- The `ge25519_p3` `(x : y : 1 : x y)` for a root `x`, negated. -/
def point (s : BitVec 256) (x : Fin 5 → BitVec 64) : GeP3 :=
  let x := negated s x
  ⟨x, y s, Boringssl.fe_1.spec, fe25519_mul.spec x (y s)⟩

/-- `fe25519_neg`'s block, when it negates the root `x`. -/
def negBlocks (s : BitVec 256) (x : Fin 5 → BitVec 64) : Nat :=
  if fe25519_isnegative.spec x = sign s then 1 else 0

/-- The blocks the call uses on each path. -/
def blocks (s : BitVec 256) : Nat :=
  if fe25519_iszero.spec (m_root_check s) = 0#32 then
    if fe25519_iszero.spec (p_root_check s) = 0#32 then 17
    else 19 + negBlocks s (fe25519_mul.spec (x s) fd_f25519_sqrtm1.limbs)
  else 16 + negBlocks s (x s)

end ge25519_frombytes_negate_vartime

open ge25519_frombytes_negate_vartime Firedancer.Ref in
/-- The negation of the point `s` encodes, `none` when neither `x` nor `√-1 x` is a root of
`v x² = u`. -/
def ge25519_frombytes_negate_vartime.spec (s : BitVec 256) : Option GeP3 :=
  if fe25519_iszero.spec (m_root_check s) = 0#32 then
    if fe25519_iszero.spec (p_root_check s) = 0#32 then none
    else some (point s (fe25519_mul.spec (x s) fd_f25519_sqrtm1.limbs))
  else some (point s (x s))

end

/-! ## Proof -/

section Proof

open ge25519_frombytes_negate_vartime

/-- A byte shifted right by 7 has a clear sign bit. -/
private theorem lshr_seven_msb (b : BitVec 8) : (b >>> 7).msb = false := by bv_decide

namespace ge25519_frombytes_negate_vartime

/-- From `^bb3`, the root `X` at `h->X`: `X` negated when its sign is `s[31] >> 7`, `T = X Y`, then
`^bb6` with `0`, the slots `u … p_root_check` still in the env. -/
theorem tail (h buf u v v3 vxx mrc prc : Pointer) (b : BitVec 256) (X : Fin 5 → BitVec 64)
    (g : Vals [.bv 32] × GlobalState → PoisonOr β) (K : PoisonOr β) (S : GlobalState) (E : ⟪Γ⟫)
    (hArgs : E.args = (args (.value h) (.value buf)).get)
    (hR :
      E ⊨ [%2781 := 0#32, %2784 := 7#8, %2785 := u, %2786 := v, %2787 := v3, %2788 := vxx, %2789 :=
        mrc, %2790 := prc, %2791 := h.add 40#64])
    (hwf : S.WF) (hh : S.mem.PointRoom h) (hfX : S.mem.LimbsFit h)
    (hfY : S.mem.LimbsFit (h.add 40#64)) (hX : S.mem.readLimbs h = X)
    (hY : S.mem.readLimbs (h.add 40#64) = y b) (hbuf : Fits S.mem buf 256)
    (hb : S.mem.readAt buf 256 = b) (hov31 : ¬buf.offset.uaddOverflow 31#64)
    (hK :
      ∀ (E' : ⟪Γ⟫) (S' : GlobalState),
        E'.args = (args (.value h) (.value buf)).get →
          (E' ⊨ [%2785 := u, %2786 := v, %2787 := v3, %2788 := vxx, %2789 := mrc, %2790 := prc,
            %2804 := 0#32]) →
          S' =
            { alloc := ⟨S.alloc.nextFreeBlock + 2 + negBlocks b X⟩,
              mem :=
                (S.mem.storeLimbs h (negated b X)).storeLimbs (h.add 120#64)
                  (fe25519_mul.spec (negated b X) (y b)) } →
          (ge25519_frombytes_negate_vartime.runFrom E' ^bb6 S' >>= g) = K) :
    (ge25519_frombytes_negate_vartime.runFrom E ^bb3 S >>= g) = K := by
  have hkeep : S.mem.storeLimbs h X = S.mem := hX ▸ MemoryState.storeLimbs_readLimbs_self hfX
  -- if (fe25519_isnegative(h->X) == (s[31] >> 7)) {
  block_init
  step_call using fe25519_isnegative.call_eq with sgn_x
  step_pure
  have hfits31 := Fits.add_of_le (w := 8) hov31 (by decide) hbuf
  step_load with buf31 consuming hb hbuf hfits31
  step_pure with expected_x_sign
  have hmsb : expected_x_sign.msb = false := hexpected_x_sign ▸ lshr_seven_msb buf31
  step_pure [hmsb]
  step_pure
  finish_block
  all_goals
    have hsgn := hbr
    rw [hsgn_x, hexpected_x_sign, hbuf31] at hsgn
    clear hbr hsgn_x
  case isTrue =>
    -- fe25519_neg(h->X, h->X);
    block_init
    step_call using fe25519_neg.call_eq
    finish_block
    -- fe25519_mul(h->T, h->X, h->Y); return 0;
    block_init
    step_pure
    step_call using fe25519_mul.call_eq
    finish_block
    step_loop using hK
    simp only [negBlocks, negated, sign, hsgn, ↓reduceIte, true_and]
  case isFalse =>
    -- fe25519_mul(h->T, h->X, h->Y); return 0;
    block_init
    step_pure
    step_call using fe25519_mul.call_eq
    finish_block
    step_loop using hK
    simp only [negBlocks, negated, sign, hsgn, ↓reduceIte, hkeep, true_and]

end ge25519_frombytes_negate_vartime

/-- `ge25519_frombytes_negate_vartime` decodes the 32 bytes at `buf` into the `ge25519_p3` at `h`,
negated: when `spec` is a point, it stores it and returns `0`; else it returns `-1`, `h`'s `X, Y, Z`
holding the candidate `(x : y : 1)`. `h` is in another block than `buf`. The globals', temporaries'
and callees' blocks are freed again: only the counter moves on, by `blocks`. -/
public theorem ge25519_frombytes_negate_vartime.call_eq (h buf : Pointer) (s : GlobalState)
    (hwf : s.WF) (hh : s.mem.PointRoom h) (hbuf : Fits s.mem buf 256)
    (hbuf_off : buf.offset.toNat + 32 < 2 ^ 64) (hsep : h.id ≠ buf.id) :
    ge25519_frombytes_negate_vartime.call
        (ge25519_frombytes_negate_vartime.args (.value h) (.value buf)) s =
      .value
        (.cons
            (.value
              (if (ge25519_frombytes_negate_vartime.spec (s.mem.readAt buf 256)).isSome then 0#32
              else -1#32))
            .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + blocks (s.mem.readAt buf 256)⟩,
            mem :=
              (ge25519_frombytes_negate_vartime.spec (s.mem.readAt buf 256)).elim
                (s.mem.storeP2 h
                  ⟨x (s.mem.readAt buf 256), y (s.mem.readAt buf 256), Boringssl.fe_1.spec⟩)
                (s.mem.storeP3 h) }) := by
  obtain ⟨b, hb⟩ : ∃ b, s.mem.readAt buf 256 = b := ⟨_, rfl⟩
  obtain ⟨n, hn⟩ : ∃ n, blocks b = n := ⟨_, rfl⟩
  obtain ⟨res, hres⟩ : ∃ res, ge25519_frombytes_negate_vartime.spec b = res := ⟨_, rfl⟩
  have hov31 : ¬buf.offset.uaddOverflow 31#64 := by
    simp only [BitVec.uaddOverflow, ge_iff_le, decide_eq_true_eq, Nat.not_le, BitVec.toNat_ofNat]
    omega
  rw [hb, hn, hres]
  func_init
  have hh₀ : S₀.mem.PointRoom h := hS ▸ hh
  have hh_off : h.offset.toNat + 160 ≤ 2 ^ 64 := hh.1
  block_init
  step_pure
  step_addressof d.value_eq with dp
  iterate 2 step_pure
  step_addressof sqrtm1.value_eq with sqrtm1p
  step_pure
  -- fe25519 u; fe25519 v; fe25519 v3; fe25519 vxx; fe25519 m_root_check, p_root_check;
  step_alloca with u
  step_alloca with v
  step_alloca with v3
  step_alloca with vxx
  step_alloca with m_root_check
  step_alloca with p_root_check
  have hd_read := Sodium.d.readLimbs hdp_fits hdp_off hread_dp
  have hsqrtm1_read := Sodium.sqrtm1.readLimbs hsqrtm1p_fits hsqrtm1p_off hread_sqrtm1p
  clear hread_dp hread_sqrtm1p
  limbs_fit dp
  limbs_fit sqrtm1p
  iterate 6 step_pure
  limbs_room u
  limbs_room v
  limbs_room v3
  limbs_room vxx
  limbs_room m_root_check
  limbs_room p_root_check
  -- fe25519_frombytes(h->Y, s); fe25519_1(h->Z);
  step_pure
  step_call using fe25519_frombytes.call_eq
  name_limbs ly
  step_pure
  step_call using fe25519_1.call_eq
  -- fe25519_sq(u, h->Y); fe25519_mul(v, u, d);
  step_call using fe25519_sq.call_eq
  name_limbs lyy
  step_call using fe25519_mul.call_eq consuming hd_read hdp_limbs
  name_limbs ldyy
  -- fe25519_sub(u, u, h->Z); fe25519_add(v, v, h->Z);
  step_call using fe25519_sub.call_eq
  name_limbs lu
  step_call using fe25519_add.call_eq consuming hread_h_80
  name_limbs lv
  -- fe25519_sq(v3, v); fe25519_mul(v3, v3, v);
  step_call using fe25519_sq.call_eq
  name_limbs lvv
  step_call using fe25519_mul.call_eq
  name_limbs lv3
  -- fe25519_sq(h->X, v3); fe25519_mul(h->X, h->X, v); fe25519_mul(h->X, h->X, u);
  step_call using fe25519_sq.call_eq
  name_limbs lx0
  step_call using fe25519_mul.call_eq
  name_limbs lx1
  step_call using fe25519_mul.call_eq
  name_limbs lx2
  -- fe25519_pow22523(h->X, h->X); fe25519_mul(h->X, h->X, v3); fe25519_mul(h->X, h->X, u);
  step_call using fe25519_pow22523.call_eq
  name_limbs lx3
  step_call using fe25519_mul.call_eq consuming hread_v3 hv3_limbs
  name_limbs lx4
  step_call using fe25519_mul.call_eq
  name_limbs lx
  -- fe25519_sq(vxx, h->X); fe25519_mul(vxx, vxx, v); fe25519_sub(m_root_check, vxx, u);
  step_call using fe25519_sq.call_eq
  name_limbs lxx
  step_call using fe25519_mul.call_eq consuming hread_v hv_limbs
  name_limbs lvxx
  step_call using fe25519_sub.call_eq
  name_limbs lm
  -- if (fe25519_iszero(m_root_check) == 0) {
  step_call using fe25519_iszero.call_eq with has_m_root consuming hread_m_root_check
  step_pure
  finish_block
  all_goals
    have hc1 := hbr
    rw [hhas_m_root] at hc1
    clear hbr hhas_m_root
  case' isTrue =>
    -- fe25519_add(p_root_check, vxx, u); if (fe25519_iszero(p_root_check) == 0) return -1;
    block_init
    step_call using fe25519_add.call_eq consuming hread_vxx hvxx_limbs hread_u hu_limbs
    name_limbs lp
    step_call using fe25519_iszero.call_eq with has_p_root consuming hread_p_root_check
    step_pure
    finish_block
    all_goals
      have hc2 := hbr
      rw [hhas_p_root] at hc2
      clear hbr hhas_p_root
    case isTrue =>
      -- return -1;
      clear_reads
      clear_facts h buf u v v3 vxx m_root_check p_root_check dp sqrtm1p
      block_init
      iterate 6 step_pure
      finish_block
      rw [hS]
      clear hS
      erase_frame
      subst_vars
      sort_point_stores hh_off
      simp only [ge25519_frombytes_negate_vartime.spec, blocks, m_root_check, p_root_check, vxx, x,
        v3, u, v, y, MemoryState.storeP2]
      simp only [hc1, hc2, ↓reduceIte, Option.isSome_none, Option.elim_none, Bool.false_eq_true]
      rfl
    -- fe25519_mul(h->X, h->X, sqrtm1);
    block_init
    step_call using fe25519_mul.call_eq
    name_limbs lx5
    finish_block
  all_goals
    -- the checks' temporaries and the globals are dead
    clear_facts u v v3 vxx m_root_check p_root_check sqrtm1p
    clear hsqrtm1_read
    refine
      tail h buf u v v3 vxx m_root_check p_root_check b _ _ _ S E hArgs (by env_reads) hwf hh
        hlimbsFit_h hlimbsFit_h_40 hread_h_readLimbs
        (by
          rw [hread_h_40_readLimbs, hly]; rfl)
        hbuf hb hov31 ?_
    intro E' S' hArgs' hR' hS'
    clear_reads
    clear_facts h buf
    -- return 0;
    block_init
    iterate 6 step_pure
    finish_block
    subst_vars
    erase_frame
    sort_point_stores hh_off
    simp only [ge25519_frombytes_negate_vartime.spec, blocks, point, m_root_check, p_root_check,
      vxx, x, v3, u, v, y]
    simp only [*, ↓reduceIte, Option.isSome_some, Option.elim_some, MemoryState.storeP3,
      ← Nat.add_assoc]
    rfl

end Proof

end MLIR.Sodium
