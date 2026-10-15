module

public import MLIR.Run.Tactic
public import Firedancer.Avx512.Common.QuadOps
public import Firedancer.Avx512.Common.Sub
public import Firedancer.Avx512.fd_f25519_sub
public import Firedancer.Avx512.fd_r43x6_ge_decode2
public import Firedancer.Lane.Common.PointUtil
public import Firedancer.Lane.Common.SqrtRatio
public import Firedancer.Lane.fd_curve25519_affine_frombytes
public import Firedancer.Lane.fd_f25519_sqrt_ratio
public import Firedancer.Lane.verify_x8.Tactics
public import Firedancer.Lane.Mlir.fd_ed25519_point_frombytes
import Std.Tactic.BVDecide
meta import Std.Tactic.BVDecide.Reflect

namespace MLIR.Firedancer.Lane

open Firedancer.Avx512 SqrtRatio

@[expose] public section

/-- `fd_f25519_sgn( x )` as a byte: `fd_f25519_tobytes`'s bit 0. -/
def fd_ed25519_point_frombytes.sgn (x : Wwl) : BitVec 8 :=
  (tobytes x).setWidth 8 &&& 1

/-- `buf[31] >> 7`, from the top 64-bit word. -/
def fd_ed25519_point_frombytes.sign (b : BitVec 256) : BitVec 8 :=
  (b.extractLsb' 192 64 >>> 63).setWidth 8

/-- The point `fd_ed25519_point_frombytes` decodes from `b`: `y` from its low 255 bits,
`u = y² - 1`, `v = d y² + 1`, `x = fd_f25519_sqrt_ratio( u, v )` (none if not a square),
negated unless its sign is `b`'s top bit, and the point `(x, y, 1, x y)`. -/
def fd_ed25519_point_frombytes.spec (b : BitVec 256) : Option Quad :=
  let y := feFrombytes b
  let u := fd_r43x6_sqr y
  let dy := fd_r43x6_mul u fd_r43x6_ge_decode2.d
  let u := fd_f25519_sub.spec u one
  let v := Avx512.fold (wwl_add dy one)
  let R := fd_f25519_sqrt_ratio.spec u v
  if R.2 = 0 then none
  else
    let x :=
      if fd_ed25519_point_frombytes.sgn R.1 = fd_ed25519_point_frombytes.sign b then R.1
      else fd_f25519_sqrt_ratio.neg R.1
    some (Quad.pack x y one (fd_r43x6_mul x y))

end

/-! ## Proof -/

section Proof

attribute [-mlir_operation] zipWith_eq_ofFn

/-- `fd_f25519_sub( u, u, fd_f25519_one )` as compiled. -/
theorem sub_one_eq (X : Wwl) :
    vadd (foldSignedPre (vadd X fd_r43x6_ge_decode2.pSubOne)) negBias =
      fd_f25519_sub.spec X one := by
  delta foldSignedPre
  unfold fd_f25519_sub.spec
  ext i hi : 1
  rcases i with _ | _ | _ | _ | _ | _ | _ | _ | i
  all_goals try (exfalso; omega)
  all_goals
    simp only [Vector.getElem_ofFn, Vector.getElem_zipWith, Vector.getElem_mk,
      List.getElem_toArray, List.getElem_cons_zero, List.getElem_cons_succ, negRot, wwl_add,
      wwl_and, fd_r43x6_ge_decode2.pSubOne, one, vsar, vmul, vadd, foldMask, foldShifts, negBias,
      neg18, negSel, Fin.getElem_fin, Vector.getElem_replicate, Nat.reduceAdd, BitVec.reduceToNat]
    simp only [reduceGetElemLit]
    bv_decide

/-- The sign test as compiled: a byte compare's flag. -/
theorem eq_of_ofBool_beq {a b : BitVec 8} (h : BitVec.ofBool (a == b) = 1#1) : a = b := by
  revert h
  bv_decide

set_option hygiene false in
/-- `^bb4` on the root `X`: `t = x y`, the point packed into `r`; then `^bb5`. -/
local macro "bb4_steps " X:term : tactic =>
  `(tactic|
    ( block_init
      step_pure with x0
      step_pure with x1
      step_pure with x2
      step_pure with x3
      step_pure with x4
      step_pure with x5
      replace hx0 : x0 = Vector.replicate 8 ($X)[0] := by rw [hx0]; rfl
      replace hx1 : x1 = Vector.replicate 8 ($X)[1] := by rw [hx1]; rfl
      replace hx2 : x2 = Vector.replicate 8 ($X)[2] := by rw [hx2]; rfl
      replace hx3 : x3 = Vector.replicate 8 ($X)[3] := by rw [hx3]; rfl
      replace hx4 : x4 = Vector.replicate 8 ($X)[4] := by rw [hx4]; rfl
      replace hx5 : x5 = Vector.replicate 8 ($X)[5] := by rw [hx5]; rfl
      step_pattern using runBodyFrom_mulRowsRun ($X) with t
      step_pattern using runBodyFrom_quadPackStoreRun inline
      finish_block
      block_init
      iterate 3 step_pure
      finish_block))

private theorem nsw_mask_sshr (a b : BitVec 64) :
    (a &&& 8796093022207#64).saddOverflow (b.sshiftRight 43) = false := by bv_decide

private theorem nsw_sshr_neg1 (b : BitVec 64) :
    (b.sshiftRight 43).saddOverflow 18446744073709551615#64 = false := by bv_decide

private theorem nsw_sshr_neg1_mask (b c : BitVec 64) :
    (b.sshiftRight 43 + 18446744073709551615#64).saddOverflow (c &&& 1099511627775#64) = false := by
  bv_decide

private theorem nsw_sshr40_sshr40 (t y : BitVec 64) :
    (t.sshiftRight 40).saddOverflow (y.sshiftRight 40) = false := by bv_decide

private theorem nsw_mul19 (t y : BitVec 64) :
    (t.sshiftRight 40 + y.sshiftRight 40).smulOverflow 19#64 = false := by bv_decide

private theorem nsw_mul19_mask (t y z : BitVec 64) :
    ((t.sshiftRight 40 + y.sshiftRight 40) * 19#64).saddOverflow (z &&& 8796093022207#64) =
      false := by
  bv_decide

private theorem nsw_carry_sshr (a b u : BitVec 64) :
    ((a &&& 8796093022207#64) + b.sshiftRight 43).saddOverflow (u.sshiftRight 43) = false := by
  bv_decide

private theorem nuw_mask43_19 (x : BitVec 64) :
    (x &&& 8796093022207#64).saddOverflow 19#64 = false ∧
      (x &&& 8796093022207#64).uaddOverflow 19#64 = false := by
  bv_decide

private theorem nuw_mask43_shr43 (x y : BitVec 64) :
    (x &&& 8796093022207#64).saddOverflow (y >>> 43) = false ∧
      (x &&& 8796093022207#64).uaddOverflow (y >>> 43) = false := by
  bv_decide

private theorem nuw_mask40_1 (x : BitVec 64) :
    (x &&& 1099511627775#64).saddOverflow 1#64 = false ∧
      (x &&& 1099511627775#64).uaddOverflow 1#64 = false := by
  bv_decide

private theorem nsw_mask40_1_sshr (x z : BitVec 64) :
    ((x &&& 1099511627775#64) + 1#64).saddOverflow (z.sshiftRight 43) = false := by bv_decide

private theorem nuw_top (x a b u w : BitVec 64) :
    ((x &&& 1099511627775#64) + 1#64 +
              ((a &&& 8796093022207#64) + b.sshiftRight 43 + u.sshiftRight 43).sshiftRight
                43).saddOverflow
          (w >>> 43) =
        false ∧
      ((x &&& 1099511627775#64) + 1#64 +
              ((a &&& 8796093022207#64) + b.sshiftRight 43 + u.sshiftRight 43).sshiftRight
                43).uaddOverflow
          (w >>> 43) =
        false := by
  bv_decide

private theorem nsw_sshr43_mask43 (r x : BitVec 64) :
    (r.sshiftRight 43).saddOverflow (x &&& 8796093022207#64) = false := by bv_decide

private theorem nsw_sshr43_mask40 (r x : BitVec 64) :
    (r.sshiftRight 43).saddOverflow (x &&& 1099511627775#64) = false := by bv_decide

private theorem nsw_sel19_mask43 (c : Prop) [Decidable c] (x : BitVec 64) :
    (if c then 18446744073709551597#64 else 0#64).saddOverflow (x &&& 8796093022207#64) =
      false := by
  split <;> bv_decide

attribute [local simp] nsw_mask_sshr nsw_sshr_neg1 nsw_sshr_neg1_mask nsw_sshr40_sshr40 nsw_mul19
  nsw_mul19_mask nsw_carry_sshr nuw_mask43_19 nuw_mask43_shr43 nuw_mask40_1 nsw_mask40_1_sshr
  nuw_top nsw_sshr43_mask43 nsw_sshr43_mask40 nsw_sel19_mask43

/-- The sign test's `(buf[0] & 1) - 1`: no overflow. -/
private theorem nsw_bit_sub1 (b : BitVec 8) : (b &&& 1#8).saddOverflow 255#8 = false := by
  bv_decide

attribute [local simp] nsw_bit_sub1

/-- `buf[31] >> 7` truncated to a byte: exact either way. -/
private theorem trunc_shr63 (x : BitVec 64) :
    BitVec.setWidth 64 (BitVec.setWidth 8 (x >>> 63)) = x >>> 63 ∧
      BitVec.signExtend 64 (BitVec.setWidth 8 (x >>> 63)) = x >>> 63 := by
  bv_decide

attribute [local simp] trunc_shr63


-- six inlined multiplications and squares, the sign's reduction and two paths to `^bb4`
set_option maxHeartbeats 1000000 in
/-- `fd_ed25519_point_frombytes( r, buf )` stores `spec` of the bytes at `buf` at `r` and returns
`r`, or returns `NULL` with memory unchanged when there is no point; its temporaries are freed. -/
public theorem fd_ed25519_point_frombytes.call_eq (r buf : Pointer) (s : GlobalState) (hwf : s.WF)
    (hr : s.mem.QuadRoom r) (hb : Fits s.mem buf 256) (hoff : buf.offset.toNat + 32 ≤ 2 ^ 64) :
    _root_.Firedancer.Lane.Mlir.fd_ed25519_point_frombytes.call
        (_root_.Firedancer.Lane.Mlir.fd_ed25519_point_frombytes.args (.value r) (.value buf)) s =
      .value
        (match fd_ed25519_point_frombytes.spec (s.mem.readAt buf 256) with
        | none =>
          (.cons (.value Pointer.null) .nil, { alloc := ⟨s.alloc.nextFreeBlock + 4⟩, mem := s.mem })
        | some P =>
          (.cons (.value r) .nil,
            { alloc := ⟨s.alloc.nextFreeBlock + 4⟩, mem := s.mem.storeQuad r P })) := by
  have hov24 : ¬buf.offset.uaddOverflow 24#64 := by
    simp only [BitVec.uaddOverflow, decide_eq_true_eq]
    simp
    omega
  have hb24 : Fits s.mem (buf.add 24#64) 64 := Fits.add_of_le hov24 (by decide) hb
  obtain ⟨res, hres⟩ : ∃ res, fd_ed25519_point_frombytes.spec (s.mem.readAt buf 256) = res :=
    ⟨_, rfl⟩
  rw [hres]
  func_init
  block_init
  iterate 61 step_pure
  iterate 15 step_pattern using runBodyFrom_insertRun
  iterate 4 step_pure
  iterate 2 step_pattern using runBodyFrom_insertRun
  step_alloca with xp
  step_alloca with up
  step_alloca with vp
  step_pure
  -- `buf[31] >> 7`'s word, then fd_f25519_frombytes( y, buf )
  step_pure [hov24]
  step_load with transparent top
  step_load with transparent lb
  step_pure [zipWith_eq_ofFn] with ub
  step_pattern using runBodyFrom_unpackRun with y
  step_pure
  step_pure
  -- fd_f25519_sqr( u, y )
  step_pattern using runBodyFrom_sqrRunNW (hX := unpack_lt _) with ysq
  -- fd_f25519_mul( v, u, fd_f25519_d )
  step_pure with b0
  step_pure with b1
  step_pure with b2
  step_pure with b3
  step_pure with b4
  step_pure with b5
  replace hb0 : b0 = Vector.replicate 8 ysq[0] := by rw [hb0]; rfl
  replace hb1 : b1 = Vector.replicate 8 ysq[1] := by rw [hb1]; rfl
  replace hb2 : b2 = Vector.replicate 8 ysq[2] := by rw [hb2]; rfl
  replace hb3 : b3 = Vector.replicate 8 ysq[3] := by rw [hb3]; rfl
  replace hb4 : b4 = Vector.replicate 8 ysq[4] := by rw [hb4]; rfl
  replace hb5 : b5 = Vector.replicate 8 ysq[5] := by rw [hb5]; rfl
  step_pattern using runBodyFrom_mulRowsRun ysq (Y := fd_r43x6_ge_decode2.d) with dy
  -- fd_f25519_sub( u, u, fd_f25519_one )
  step_pattern using runBodyFrom_subOneRun with u hu
  step_store
  -- fd_f25519_add( v, v, fd_f25519_one )
  step_pure [zipWith_add_wrap] with v'
  step_pattern using runBodyFrom_foldRun with v
  step_store
  -- was_square = fd_f25519_sqrt_ratio( x, u, v )
  step_call using _root_.Firedancer.Lane.Mlir.fd_f25519_sqrt_ratio.call_eq
  have eY : y = feFrombytes (S₀.mem.readAt buf 256) := by rw [hy, hub]; rfl
  have hsp :
      fd_ed25519_point_frombytes.spec (S₀.mem.readAt buf 256) =
        if (fd_f25519_sqrt_ratio.spec u v).2 = 0 then none
        else
          let x :=
            if fd_ed25519_point_frombytes.sgn (fd_f25519_sqrt_ratio.spec u v).1 =
                fd_ed25519_point_frombytes.sign (S₀.mem.readAt buf 256) then
              (fd_f25519_sqrt_ratio.spec u v).1
            else fd_f25519_sqrt_ratio.neg (fd_f25519_sqrt_ratio.spec u v).1
          some (Quad.pack x y one (fd_r43x6_mul x y)) := by
    rw [hu, hv, hv', hdy, sub_one_eq, hysq, ← hy, eY]
    simp only [fd_ed25519_point_frombytes.spec]
  step_pure
  finish_block
  · -- `!was_square`: `NULL`
    block_init
    iterate 3 step_pure
    finish_block
    subst hS
    erase_frame
    rw [← hres, hsp]
    simp only [hbr, BitVec.ofNat_eq_ofNat, ↓reduceIte, GlobalState.alloca, Nat.add_assoc,
      Nat.reduceAdd]
  · -- `was_square`: `x` negated unless its sign is the encoding's
    block_init
    step_pure with transparent sh
    step_pure with tr
    step_load with X
    -- fd_f25519_sgn( x ): fd_r43x6_mod's limb 0, the pack's low byte
    step_pure with y0
    step_pure with y1
    step_pure with y2
    step_pure with y3
    step_pure with y4
    step_pure with y5
    iterate 17 step_pure
    step_pure with t5
    iterate 4 step_pure
    step_pure with u0
    iterate 2 step_pure
    step_pure with u1
    iterate 2 step_pure
    step_pure with u2
    iterate 2 step_pure
    step_pure with u3
    iterate 2 step_pure
    step_pure with transparent u4
    iterate 2 step_pure
    step_pure with v0
    iterate 2 step_pure
    step_pure with v1
    iterate 2 step_pure
    step_pure with v2
    iterate 2 step_pure
    step_pure with v3
    iterate 2 step_pure
    step_pure with v4
    iterate 4 step_pure
    step_pure with w5
    iterate 3 step_pure
    step_pure with r0
    step_pure
    step_pure with r1
    step_pure
    step_pure with r2'
    step_pure
    step_pure with r3
    iterate 6 step_pure
    step_pure with r4
    step_pure
    step_pure with r5
    iterate 14 step_pure
    step_pure with transparent bytes
    step_pure with transparent b0
    step_pure with sb
    step_pure with eqs
    have hm := mod_y0_compiled ht5 hu0 hu1 hu2 hu3 hv0 hv1 hv2 hv3 hv4 hw5 hr0
    rw [show (⟨y0, y1, y2, y3, y4, y5⟩ : Limbs) = extractLimbs X by
      rw [hy0, hy1, hy2, hy3, hy4, hy5]; rfl] at hm
    have esb : sb = fd_ed25519_point_frombytes.sgn X := by
      rw [hsb]
      exact sgn_compiled hm
    finish_block
    · -- `fd_f25519_sgn( x ) == expected_x_sign`
      block_init
      step_load with X'
      finish_block
      bb4_steps X'
      have hc : fd_ed25519_point_frombytes.sgn X =
          fd_ed25519_point_frombytes.sign (S₀.mem.readAt buf 256) := by
        have h1 : sb = tr := eq_of_ofBool_beq (heqs ▸ hbr)
        rw [← esb, h1, htr, MemoryState.readAt_add_of_readAt hb₀.inBounds hov24 (by decide) rfl]
        rfl
      subst hS
      erase_frame
      rw [← hres, hsp, ← hX]
      simp only [show ¬(fd_f25519_sqrt_ratio.spec u v).2 = 0 from ‹_›, hc, ↓reduceIte,
        GlobalState.alloca, Nat.add_assoc, Nat.reduceAdd]
      subst_vars
      rfl
    · -- `fd_f25519_neg( x, x )`
      block_init
      step_pattern using runBodyFrom_negRun with nx
      finish_block
      bb4_steps nx
      have hc : ¬fd_ed25519_point_frombytes.sgn X =
          fd_ed25519_point_frombytes.sign (S₀.mem.readAt buf 256) := by
        intro hc
        apply hbr
        rw [heqs, esb, hc, htr,
          MemoryState.readAt_add_of_readAt hb₀.inBounds hov24 (by decide) rfl]
        simp [fd_ed25519_point_frombytes.sign]
      subst hS
      erase_frame
      rw [← hres, hsp, ← hX]
      simp only [show ¬(fd_f25519_sqrt_ratio.spec u v).2 = 0 from ‹_›, hc, ↓reduceIte,
        GlobalState.alloca, Nat.add_assoc, Nat.reduceAdd]
      rw [negFold_eq_neg] at hnx
      subst_vars
      rfl

end Proof

end MLIR.Firedancer.Lane
