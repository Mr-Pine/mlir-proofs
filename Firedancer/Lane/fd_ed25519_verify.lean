module

public import MLIR.Run.Tactic
public import Firedancer.Avx512.fd_ed25519_verify
public import Firedancer.Lane.Common.Batch
public import Firedancer.Lane.fd_sha512_init
public import Firedancer.Lane.fd_sha512_append
public import Firedancer.Lane.fd_sha512_fini
public import Firedancer.Lane.fd_curve25519_scalar_reduce
public import Firedancer.Lane.fd_ed25519_point_frombytes_2x
public import Firedancer.Lane.fd_ed25519_affine_is_small_order
public import Firedancer.Lane.fd_ed25519_verify_equation
public import Firedancer.Lane.Mlir.fd_ed25519_verify
import Std.Tactic.BVDecide
meta import Std.Tactic.BVDecide.Reflect

namespace MLIR.Firedancer.Lane

open Firedancer.Ref

/-! ## Specification -/

@[expose] public section

/-- The blocks `fd_ed25519_verify` leaves counted: its three locals, `frombytes_2x`'s 26, the
SHA-512 calls' and `verify_equation`'s ten, on the paths `Avx512.fd_ed25519_verify.spec` takes. -/
noncomputable def fd_ed25519_verify.blocks (msgSz : BitVec 64) (msg : BitVec (8 * msgSz.toNat))
    (r S publicKey : BitVec 256) (buf0 : BitVec 1024) : Nat :=
  if !fd_curve25519_scalar_validate.spec S then 3
  else
    let (res, Aprime, R) := Avx512.fd_ed25519_point_frombytes_2x.spec publicKey r
    if res ≠ 0#32 then 29
    else
      if Avx512.fd_ed25519_affine_is_small_order.spec Aprime ≠ 0#32 then 29
      else
        if Avx512.fd_ed25519_affine_is_small_order.spec R ≠ 0#32 then 29
        else 39 + fd_ed25519_verify.hashBlocks buf0 r publicKey msgSz msg

end

/-! ## Proof -/

section Proof

open _root_.Firedancer.Lane.Mlir.fd_ed25519_verify (Γ args)

/-- The lift's runs from a block. -/
local notation "runV" => _root_.Firedancer.Lane.Mlir.fd_ed25519_verify.runFrom

attribute [-mlir_operation] zipWith_eq_ofFn

attribute [local mlir_operation] zipWith_and_wrap zipWith_add_wrap zipWith_sub_wrap zipWith_mul_wrap
  zipWith_lshr_wrap zipWith_ashr_wrap zipWith_shl_wrap zipWith_add_nsw_wrap zipWith_add_nsw_nuw_wrap
  zipWith_sub_nsw_wrap

set_option hygiene false in
/-- The inlined `fd_ed25519_affine_is_small_order( P )` on the point at `P`: its negated tests
named, and `hiff` relating the last to `spec`. -/
local macro "small_steps" P:ident : tactic =>
  `(tactic|
    (
    step_load with p03
    step_pure
    step_load with p14
    step_pure
    step_load with p25
    step_pure
    step_pure
    step_pure
    step_pure
    step_pure with x
    step_pure with y
    -- `fd_f25519_is_zero( x )`, `fd_f25519_is_zero( y )`, negated
    step_pure [zipWith_eq_ofFn] with zx
    step_pure [zipWith_eq_ofFn] with zx8
    step_pure [zipWith_eq_ofFn] with zx0
    step_pure [zipWith_eq_ofFn] with px
    step_pure [zipWith_eq_ofFn] with px8
    step_pure [zipWith_eq_ofFn] with px0
    step_pure [zipWith_eq_ofFn] with izx
    step_pure [zipWith_eq_ofFn] with zy
    step_pure [zipWith_eq_ofFn] with zy8
    step_pure [zipWith_eq_ofFn] with zy0
    step_pure [zipWith_eq_ofFn] with py
    step_pure [zipWith_eq_ofFn] with py8
    step_pure [zipWith_eq_ofFn] with py0
    step_pure [zipWith_eq_ofFn] with izy
    step_pure [zipWith_eq_ofFn] with o1
    -- `fd_f25519_eq( y, fd_ed25519_order8_point_y0 )`, negated
    step_pure with s0
    step_pure with s1
    step_pure with s2
    step_pure with s3
    step_pure with s4
    step_pure with s5
    have hoks := foldMask_add_bias_ok s0
    rw [← hs1] at hoks
    step_pure with s6
    step_pure with s7
    step_pure with s8
    step_pure [zipWith_eq_ofFn] with zs
    step_pure [zipWith_eq_ofFn] with zs8
    step_pure [zipWith_eq_ofFn] with zs0
    step_pure [zipWith_eq_ofFn] with ps
    step_pure [zipWith_eq_ofFn] with ps8
    step_pure [zipWith_eq_ofFn] with ps0
    step_pure [zipWith_eq_ofFn] with ies
    step_pure [zipWith_eq_ofFn] with o2
    -- `fd_f25519_eq( y, fd_ed25519_order8_point_y1 )`, negated
    step_pure with t0
    step_pure with t1
    step_pure with t2
    step_pure with t3
    step_pure with t4
    step_pure with t5
    have hokt := foldMask_add_bias_ok t0
    rw [← ht1] at hokt
    step_pure with t6
    step_pure with t7
    step_pure with t8
    step_pure [zipWith_eq_ofFn] with zt
    step_pure [zipWith_eq_ofFn] with zt8
    step_pure [zipWith_eq_ofFn] with zt0
    step_pure [zipWith_eq_ofFn] with pt
    step_pure [zipWith_eq_ofFn] with pt8
    step_pure [zipWith_eq_ofFn] with pt0
    step_pure [zipWith_eq_ofFn] with iet
    step_pure [zipWith_eq_ofFn] with o3
    have ex : x = (S.mem.readQuad $P).X := by
      rw [hx, hp03, hp14, hp25, hS]
      rfl
    have ey : y = (S.mem.readQuad $P).Y := by
      rw [hy, hp03, hp14, hp25, hS]
      rfl
    have ex0 : izx = ~~~isZeroBit x := by
      rw [hizx, hzx0, hzx8, hzx, hpx0, hpx8, hpx, nz_sel]
      rfl
    have ey0 : izy = ~~~isZeroBit y := by
      rw [hizy, hzy0, hzy8, hzy, hpy0, hpy8, hpy, nz_sel]
      rfl
    have es0 : ies = ~~~isZeroBit s8 := by
      rw [hies, hzs0, hzs8, hzs, hps0, hps8, hps, nz_and]
      rfl
    have et0 : iet = ~~~isZeroBit t8 := by
      rw [hiet, hzt0, hzt8, hzt, hpt0, hpt8, hpt, nz_and]
      rfl
    have es : s8 = fd_f25519_sub.spec y fd_ed25519_order8_point_y0.vec := by
      rw [sub_y0, hs8, hs7, hs6, hs5, hs4, hs3, hs2, hs1, hs0]
      rfl
    have et : t8 = fd_f25519_sub.spec y fd_ed25519_order8_point_y1.vec := by
      rw [sub_y1, ht8, ht7, ht6, ht5, ht4, ht3, ht2, ht1, ht0]
      rfl
    have hiff :
        o3 = 1#1 ↔ Avx512.fd_ed25519_affine_is_small_order.spec (S.mem.readQuad $P) = 0#32 := by
      rw [ho3, ho2, ho1, ex0, ey0, es0, et0, notSmall_iff, isZeroBit_spec, isZeroBit_spec,
        isZeroBit_spec, isZeroBit_spec, es, et, ex, ey]
      rfl
    finish_block))

set_option hygiene false in
/-- `^bb3` on: `fd_ed25519_point_frombytes_2x`, the two small-order tests, the hashing,
`fd_curve25519_scalar_reduce` and `fd_ed25519_verify_equation`, each exit's final equation; `hv`
the scalar's validity. -/
local macro "rest_steps" : tactic =>
  `(tactic|
    (
    -- int res = fd_ed25519_point_frombytes_2x( Aprime, public_key, R, r );
    block_init
    iterate 2 step_pure
    have hA_pt := MemoryState.QuadRoom.of_room hroom_A hA_off
    have hR_pt := MemoryState.QuadRoom.of_room hroom_R hR_off
    clear hroom_A hroom_R hA_bounds hR_bounds
    step_call using fd_ed25519_point_frombytes_2x.call_eq
    obtain ⟨⟨fres, Ap, Rp⟩, hfb⟩ :
      ∃ t,
        Avx512.fd_ed25519_point_frombytes_2x.spec (S₀.mem.readAt pk 256)
            (S₀.mem.readAt sig 256) =
          t :=
      ⟨_, rfl⟩
    rw [hfb] at hS hE hread_A hread_R
    dsimp only at hS hread_A hread_R
    step_pure
    finish_block
    case isFalse =>
      -- a decoding failed: FD_ED25519_ERR_PUBKEY for the key, else FD_ED25519_ERR_SIG
      block_init
      iterate 2 step_pure
      finish_block
      block_init
      iterate 2 step_pure
      finish_block
      block_init
      finish_block
      subst hS hres hnb
      erase_frame
      simp [Avx512.fd_ed25519_verify.spec, fd_ed25519_verify.blocks, hv, hfb, hbr,
        fd_ed25519_verify.Result.mem, ite_ofBool_beq]
    case isTrue =>
      have hres0 := hbr
      clear hbr
      -- if( fd_ed25519_affine_is_small_order( Aprime ) ) return FD_ED25519_ERR_PUBKEY;
      refine
        fd_ed25519_verify.smallA_block msg msgSz sig pk sha A R k S E _ _ hArgs
          ⟨by env_reads, by env_reads⟩ hwf (by mem_fact) ?_ ?_
      · intro hsoA E' h₁ h₂
        rw [hread_A] at hsoA
        -- if( fd_ed25519_affine_is_small_order( R ) ) return FD_ED25519_ERR_SIG;
        refine
          fd_ed25519_verify.smallR_block msg msgSz sig pk sha A R k S E' _ _ h₁ h₂ hwf
            (by mem_fact) ?_ ?_
        · intro hsoR E'' h₁' h₂'
          rw [hread_R] at hsoR
          obtain ⟨hC'', hR''⟩ := h₂'
          -- fd_sha512_fini( fd_sha512_append( fd_sha512_append( fd_sha512_append(
          --   fd_sha512_init( sha ), r, 32UL ), public_key, 32UL ), msg, msg_sz ), k );
          block_init
          step_pure
          have hk_w := MemoryState.Words8Room.of_room hroom_k hk_off
          clear hroom_k hk_bounds
          have hinit :=
            hread_buf ▸ fd_sha512_init.readSha (m := S.mem) ⟨hsha_fits, hsha_off⟩ hshaw
          step_call using _root_.Firedancer.Lane.Mlir.fd_sha512_init.call_eq
          have hsh0 : S.mem.readSha sha = ⟨S₀.mem.readAt sha 1024, sha512IV, 0#64, 0#64, 0#64⟩ := by
            rw [hS]
            exact hinit
          clear hinit
          have hsha : S.mem.ShaFit sha := ⟨hsha_fits, hsha_off⟩
          clear hsha_fits hread_sha_200 hread_sha_184 hread_sha_176 hread_sha_168 hread_sha_160
            hread_sha_152 hread_sha_144 hread_sha_136 hread_sha_128 hfits_sha_200 hfits_sha_184
            hfits_sha_176 hfits_sha_168 hfits_sha_160 hfits_sha_152 hfits_sha_144 hfits_sha_136
            hfits_sha_128
          -- each `append` keeps less than a block buffered: `hu` for the call
          step_call using
            (_root_.Firedancer.Lane.Mlir.fd_sha512_append.call_eq (hu :=
              (congrArg (fun x : ShaState => x.bufUsed.toNat < 128) hsh0).mpr (by simp)))
            consuming hread_r
          step_call using
            (_root_.Firedancer.Lane.Mlir.fd_sha512_append.call_eq (hu :=
              (congrArg (fun x : ShaState => x.bufUsed.toNat < 128) hread_sha).mpr
                (fd_sha512_append.spec_bufUsed_lt _ _ _ (by simp))))
            consuming hread_pk
          step_call using
            (_root_.Firedancer.Lane.Mlir.fd_sha512_append.call_eq (hu :=
              (congrArg (fun x : ShaState => x.bufUsed.toNat < 128) hread_sha).mpr
                (fd_sha512_append.spec_bufUsed_lt _ _ _
                  (fd_sha512_append.spec_bufUsed_lt _ _ _ (by simp)))))
            consuming hread_msg
          step_call using
            (_root_.Firedancer.Lane.Mlir.fd_sha512_fini.call_eq (hu :=
              (congrArg (fun x : ShaState => x.bufUsed.toNat < 128) hread_sha).mpr
                (fd_sha512_append.spec_bufUsed_lt _ _ _
                  (fd_sha512_append.spec_bufUsed_lt _ _ _
                    (fd_sha512_append.spec_bufUsed_lt _ _ _ (by simp))))))
          obtain ⟨⟨sha4, kw⟩, hH⟩ :
            ∃ H,
              fd_ed25519_verify.hash (S₀.mem.readAt sha 1024) (S₀.mem.readAt sig 256)
                  (S₀.mem.readAt pk 256) msgSz (S₀.mem.readAt msg (8 * msgSz.toNat)) =
                H :=
            ⟨_, rfl⟩
          have hH' :
              fd_sha512_fini.spec
                  (fd_sha512_append.spec
                    (fd_sha512_append.spec
                      (fd_sha512_append.spec
                        ⟨S₀.mem.readAt sha 1024, sha512IV, 0#64, 0#64, 0#64⟩ 32#64
                        (S₀.mem.readAt sig 256))
                      32#64 (S₀.mem.readAt pk 256))
                    msgSz (S₀.mem.readAt msg (8 * msgSz.toNat))) =
                (sha4, kw) :=
            hH
          rw [hH'] at hS
          dsimp only at hS
          -- fd_curve25519_scalar_reduce( k, k );
          have hk32 : ¬k.offset.uaddOverflow 32#64 := by simp [BitVec.uaddOverflow, hk_off]
          have hk64 : ¬k.offset.uaddOverflow 64#64 := by simp [BitVec.uaddOverflow, hk_off]
          have hkf := hk_w.fits
          clear hsha
          step_call using fd_curve25519_scalar_reduce.call_eq consuming hk_w
          -- if( fd_ed25519_verify_equation( k, Aprime, S, R ) ) return FD_ED25519_SUCCESS;
          -- return FD_ED25519_ERR_MSG;
          step_call using fd_ed25519_verify_equation.call_eq
          iterate 3 step_pure
          finish_block
          block_init
          iterate 2 step_pure
          finish_block
          block_init
          finish_block
          subst hS hres hnb
          rw [MemoryState.storeSha_storeSha_self hsha_off,
            MemoryState.storeSha_storeSha_self hsha_off,
            MemoryState.storeSha_storeSha_self hsha_off]
          erase_frame
          simp only [Avx512.fd_ed25519_verify.spec, fd_ed25519_verify.blocks, hv, hfb, hres0,
            hsoA, hsoR, hH, fd_ed25519_verify.Result.mem, ite_ofBool_beq, ← hSv]
          simp [Avx512.fd_ed25519_verify_equation.spec, GlobalState.alloca,
            fd_ed25519_verify.hashBlocks, fd_ed25519_verify.shaStates, fd_sha512_init.stores]
          exact ⟨rfl, by omega⟩
        · intro hsoR E'' h₁' h₂' h₃'
          rw [hread_R] at hsoR
          block_init
          iterate 2 step_pure
          finish_block
          block_init
          finish_block
          subst hS hres hnb
          erase_frame
          simp [Avx512.fd_ed25519_verify.spec, fd_ed25519_verify.blocks, hv, hfb, hres0,
            fd_ed25519_verify.Result.mem, hsoA, hsoR]
      · intro hsoA E' h₁ h₂ h₃
        rw [hread_A] at hsoA
        block_init
        iterate 2 step_pure
        finish_block
        block_init
        finish_block
        subst hS hres hnb
        erase_frame
        simp [Avx512.fd_ed25519_verify.spec, fd_ed25519_verify.blocks, hv, hfb, hres0,
          fd_ed25519_verify.Result.mem, hsoA]))

namespace fd_ed25519_verify

open Firedancer.Avx512

/-! ### `fd_curve25519_scalar_validate` inlined -/

/-- `S`'s top byte below `0x10`: `S < 2^252 ≤ ℓ`. -/
theorem validate_lt16 {x : BitVec 512} (h : (x.extractLsb' 504 8).ult 16#8 = true) :
    fd_curve25519_scalar_validate.spec (x.extractLsb' 256 256) = true := by
  simp only [fd_curve25519_scalar_validate.spec, scalarL]
  bv_decide

/-- `S`'s top byte at least `0x20`: `S ≥ 2^253 > ℓ`. -/
theorem validate_ge32 {x : BitVec 512} (h : ¬(x.extractLsb' 504 8).ult 32#8 = true) :
    fd_curve25519_scalar_validate.spec (x.extractLsb' 256 256) = false := by
  simp only [fd_curve25519_scalar_validate.spec, scalarL]
  bv_decide

set_option exponentiation.threshold 512 in
-- the borrow chain's limbs at bits 256 … 448
/-- The inlined `fd_curve25519_scalar_validate`'s borrow chain against `ℓ - 1` (its four limbs
from bit 256 of the signature): no borrow out exactly when `S ≥ ℓ`. -/
theorem validate_borrow (x : BitVec 512) :
    ((if
        x.toNat >>> 448 % 18446744073709551616 <
          1152921504606846976 +
            if
                (if
                      (1503914060200516822 +
                          if 6346243789798364141 ≤ x.toNat >>> 256 % 18446744073709551616 then 0
                          else 1) ≤
                        x.toNat >>> 320 % 18446744073709551616 then
                    0
                  else 1) ≤
                  x.toNat >>> 384 % 18446744073709551616 then
              0
            else 1 then
      1#8
    else 0#8) =
    0#8) ↔ fd_curve25519_scalar_validate.spec (x.extractLsb' 256 256) = false := by
  have hx := x.isLt
  simp only [fd_curve25519_scalar_validate.spec, scalarL, decide_eq_false_iff_not, BitVec.lt_def,
    BitVec.extractLsb'_toNat, Nat.shiftRight_eq_div_pow, Nat.reducePow]
  generalize x.toNat = n at *
  split <;> split <;> split <;> split <;> simp <;> omega

/-! ### `fd_ed25519_affine_is_small_order` inlined -/

/-- The constants of the inlined `fd_ed25519_affine_is_small_order`. -/
abbrev SmallConsts (E : ⟪Γ⟫) : Prop :=
  E ⊨ [%1 :=
    #v[3034496493606#64, 7251660506358#64, 8531477514791#64, 3751700492266#64, 152656122684#64,
      51415276304#64, 0#64, 0#64],
    %2 := #v[159383552#64, 1048576#64, 1048576#64, 1048576#64, 1048576#64, 1048576#64, 0#64, 0#64],
    %3 := #v[18446744073709551615#64, 0#64, 0#64, 0#64, 0#64, 0#64, 0#64, 0#64],
    %4 := Vector.replicate 8 18#64, %5 := #v[43#64, 43#64, 43#64, 43#64, 43#64, 40#64, 0#64, 0#64],
    %6 := foldMask,
    %7 :=
    #v[5761277761479#64, 1544430418697#64, 264613410264#64, 5044390432789#64, 8643434802371#64,
      1048094254319#64, 0#64, 0#64],
    %8 := 0#1, %9 := fd_r43x6_p, %10 := Vector.replicate 8 0#64, %25 := 0#64, %27 := 0#8,
    %30 := 1#64,
    %40 := (#v[.poison, .value 0#64, .poison, .poison, .poison, .poison, .poison, .poison] :
      ⟦.vec 8 64⟧),
    %48 := (#v[.value 0#64, .poison, .poison, .poison, .poison, .poison, .poison, .poison] :
      ⟦.vec 8 64⟧)]


/-- `!fd_f25519_is_zero` as compiled inline: a `select` of the two `!= 0` tests. -/
theorem nz_sel (P Q : BitVec 8) :
    (if BitVec.ofBool (P != 0#8) = 1#1 then BitVec.ofBool (Q != 0#8) else 0#1) =
      ~~~(if BitVec.ofBool (P == 0#8) = 1#1 then 1#1 else BitVec.ofBool (Q == 0#8)) := by
  bv_decide

/-- `!fd_f25519_is_zero` as compiled inline: an `&` of the two `!= 0` tests. -/
theorem nz_and (P Q : BitVec 8) :
    (BitVec.ofBool (P != 0#8) &&& BitVec.ofBool (Q != 0#8)) =
      ~~~(if BitVec.ofBool (P == 0#8) = 1#1 then 1#1 else BitVec.ofBool (Q == 0#8)) := by
  bv_decide

/-- The four negated tests all hold exactly when their widened `|` is `0`. -/
theorem notSmall_iff (a b c d : BitVec 1) :
    (~~~d &&& (~~~a &&& ~~~b &&& ~~~c) = 1#1) ↔
      (BitVec.setWidth 32 b ||| BitVec.setWidth 32 a ||| BitVec.setWidth 32 c |||
        BitVec.setWidth 32 d = 0#32) := by
  bv_decide


/-- The registers the blocks from `^bb3` read: the small-order tests' constants, the codes, the
locals and `S`. -/
abbrev Regs (A R k S : Pointer) (E : ⟪Γ⟫) : Prop :=
  SmallConsts E ∧
    E ⊨ [%0 := 4294967293#32, %18 := 32#64, %21 := 4294967295#32, %28 := 0#32,
      %29 := 4294967294#32, %49 := A, %50 := R, %51 := k, %52 := S]

/-- `^bb5`, `fd_ed25519_affine_is_small_order( Aprime )` inlined: on to `^bb6` if it is `0`, else
out with `FD_ED25519_ERR_PUBKEY`. -/
theorem smallA_block (msg : Pointer) (msgSz : BitVec 64) (sig pk sha A R k : Pointer)
    (S : GlobalState) (E : ⟪Γ⟫) (g : Vals [.bv 32] × GlobalState → PoisonOr β) (K : PoisonOr β)
    (hArgs : E.args = (args (.value msg) (.value msgSz) (.value sig) (.value pk) (.value sha)).get)
    (hR : Regs A R k (sig.add 32#64) E) (hwf : S.WF) (hA : S.mem.QuadFit A)
    (hok :
      Avx512.fd_ed25519_affine_is_small_order.spec (S.mem.readQuad A) = 0#32 →
        ∀ E' : ⟪Γ⟫,
          E'.args = (args (.value msg) (.value msgSz) (.value sig) (.value pk) (.value sha)).get →
            Regs A R k (sig.add 32#64) E' → (runV E' ^bb6 S >>= g) = K)
    (hbad :
      ¬Avx512.fd_ed25519_affine_is_small_order.spec (S.mem.readQuad A) = 0#32 →
        ∀ E' : ⟪Γ⟫,
          E'.args = (args (.value msg) (.value msgSz) (.value sig) (.value pk) (.value sha)).get →
            Regs A R k (sig.add 32#64) E' → (E' ⊨ [%206 := 4294967294#32]) →
              (runV E' ^bb8 S >>= g) = K) :
    (runV E ^bb5 S >>= g) = K := by
  obtain ⟨hC, hR⟩ := hR
  block_init
  small_steps A
  case isTrue =>
    subst hS
    exact hok (hiff.1 hbr) E hArgs ⟨by env_reads, by env_reads⟩
  case isFalse =>
    subst hS
    exact hbad (fun h => hbr (hiff.2 h)) E hArgs ⟨by env_reads, by env_reads⟩ (by env_reads)

/-- `^bb6`, `fd_ed25519_affine_is_small_order( R )` inlined: on to `^bb7` if it is `0`, else out
with `FD_ED25519_ERR_SIG`. -/
theorem smallR_block (msg : Pointer) (msgSz : BitVec 64) (sig pk sha A R k : Pointer)
    (S : GlobalState) (E : ⟪Γ⟫) (g : Vals [.bv 32] × GlobalState → PoisonOr β) (K : PoisonOr β)
    (hArgs : E.args = (args (.value msg) (.value msgSz) (.value sig) (.value pk) (.value sha)).get)
    (hR : Regs A R k (sig.add 32#64) E) (hwf : S.WF) (hRf : S.mem.QuadFit R)
    (hok :
      Avx512.fd_ed25519_affine_is_small_order.spec (S.mem.readQuad R) = 0#32 →
        ∀ E' : ⟪Γ⟫,
          E'.args = (args (.value msg) (.value msgSz) (.value sig) (.value pk) (.value sha)).get →
            Regs A R k (sig.add 32#64) E' → (runV E' ^bb7 S >>= g) = K)
    (hbad :
      ¬Avx512.fd_ed25519_affine_is_small_order.spec (S.mem.readQuad R) = 0#32 →
        ∀ E' : ⟪Γ⟫,
          E'.args = (args (.value msg) (.value msgSz) (.value sig) (.value pk) (.value sha)).get →
            Regs A R k (sig.add 32#64) E' → (E' ⊨ [%206 := 4294967295#32]) →
              (runV E' ^bb8 S >>= g) = K) :
    (runV E ^bb6 S >>= g) = K := by
  obtain ⟨hC, hR⟩ := hR
  block_init
  small_steps R
  case isTrue =>
    subst hS
    exact hok (hiff.1 hbr) E hArgs ⟨by env_reads, by env_reads⟩
  case isFalse =>
    subst hS
    exact hbad (fun h => hbr (hiff.2 h)) E hArgs ⟨by env_reads, by env_reads⟩ (by env_reads)

/-! ### Points past the hash object's stores -/

theorem quadFit_storeSha {m : MemoryState} (h : m.QuadFit q) : (m.storeSha p v).QuadFit q :=
  ⟨h.1, h.2.1.storeSha, h.2.2.1.storeSha, h.2.2.2.storeSha⟩

theorem quadFit_storeWords8 {m : MemoryState} (h : m.QuadFit q) : (m.storeWords8 p v).QuadFit q :=
  ⟨h.1, h.2.1.storeWords8, h.2.2.1.storeWords8, h.2.2.2.storeWords8⟩

theorem readQuad_storeSha_of_id_ne {m : MemoryState} (h : q.id ≠ p.id) :
    (m.storeSha p v).readQuad q = m.readQuad q := by
  have h' (o : BitVec 64) : (q.add o).id ≠ p.id := by simpa [Pointer.add_id] using h
  simp only [MemoryState.readQuad, MemoryState.readVec, MemoryState.readAt_storeSha_of_id_ne h,
    MemoryState.readAt_storeSha_of_id_ne (h' _)]

theorem readQuad_storeWords8_of_id_ne {m : MemoryState} (h : q.id ≠ p.id) :
    (m.storeWords8 p v).readQuad q = m.readQuad q := by
  have h' (o : BitVec 64) : (q.add o).id ≠ p.id := by simpa [Pointer.add_id] using h
  simp only [MemoryState.readQuad, MemoryState.readVec, MemoryState.readAt_storeWords8_of_id_ne h,
    MemoryState.readAt_storeWords8_of_id_ne (h' _)]

end fd_ed25519_verify

attribute [local mlir_transport] fd_ed25519_verify.quadFit_storeSha
  fd_ed25519_verify.quadFit_storeWords8 GlobalState.WF.add_blocks_storeSha
  GlobalState.WF.add_blocks_storeSha_storeWords8 MemoryState.Words8Room.storeSha

attribute [local mlir_erase high] MemoryState.eraseFrom_storeWords8_of_le

attribute [local mlir_erase] MemoryState.eraseFrom_storeSha

attribute [local mlir_read] MemoryState.readSha_storeSha_self MemoryState.readAt_storeWords8_self
  fd_ed25519_verify.readQuad_storeSha_of_id_ne
  fd_ed25519_verify.readQuad_storeWords8_of_id_ne

set_option maxHeartbeats 1000000 in
-- one walk through the function, its small-order tests and the inlined
-- `fd_curve25519_scalar_validate`, the tail stepped on both of the scalar's valid paths
/-- `fd_ed25519_verify` returns `Avx512.fd_ed25519_verify.spec`'s code and leaves its hash object;
its frame, `blocks` blocks, is freed. The signature, key and message are only read, the hash object
only written by the SHA-512 calls. -/
public theorem fd_ed25519_verify.call_eq (msg : Pointer) (msgSz : BitVec 64) (sig pk sha : Pointer)
    (s : GlobalState) (hwf : s.WF)
    (hg : s.mem.Globals _root_.Firedancer.Lane.Mlir.fd_ed25519_verify.globals)
    (hmsg : Fits s.mem msg (8 * msgSz.toNat)) (hmsg_off : ¬msg.offset.uaddOverflow msgSz)
    (hmsgSz : msgSz.toNat < 2 ^ 63) (hsig : Fits s.mem sig (8 * 64))
    (hsig_off : ¬sig.offset.uaddOverflow 64#64) (hpk : Fits s.mem pk (8 * 32))
    (hpk_off : ¬pk.offset.uaddOverflow 32#64) (hsha : s.mem.ShaFit sha) (hshaw : Writable s.mem sha)
    (hmsg_sha : msg.id ≠ sha.id) (hsig_sha : sig.id ≠ sha.id) (hpk_sha : pk.id ≠ sha.id) :
    _root_.Firedancer.Lane.Mlir.fd_ed25519_verify.call
        (_root_.Firedancer.Lane.Mlir.fd_ed25519_verify.args (.value msg) (.value msgSz) (.value sig)
          (.value pk) (.value sha))
        s =
      let res :=
        Avx512.fd_ed25519_verify.spec Avx512.fd_ed25519_base_point_wnaf_table.point msgSz
          (s.mem.readAt msg (8 * msgSz.toNat)) (s.mem.readAt sig 256)
          (s.mem.readAt (sig.add 32#64) 256) (s.mem.readAt pk 256) (s.mem.readAt sha 1024)
      .value
        (.cons (.value res.ret) .nil,
          { alloc :=
              ⟨s.alloc.nextFreeBlock +
                  fd_ed25519_verify.blocks msgSz (s.mem.readAt msg (8 * msgSz.toNat))
                    (s.mem.readAt sig 256) (s.mem.readAt (sig.add 32#64) 256)
                    (s.mem.readAt pk 256) (s.mem.readAt sha 1024)⟩,
            mem := res.mem s.mem sha }) := by
  dsimp only
  generalize hres :
    Avx512.fd_ed25519_verify.spec Avx512.fd_ed25519_base_point_wnaf_table.point msgSz
      (s.mem.readAt msg (8 * msgSz.toNat)) (s.mem.readAt sig 256) (s.mem.readAt (sig.add 32#64) 256)
      (s.mem.readAt pk 256) (s.mem.readAt sha 1024) =
    res
  generalize hnb :
    fd_ed25519_verify.blocks msgSz (s.mem.readAt msg (8 * msgSz.toNat)) (s.mem.readAt sig 256)
      (s.mem.readAt (sig.add 32#64) 256) (s.mem.readAt pk 256) (s.mem.readAt sha 1024) =
    nb
  func_init
  rw [hS] at hres hnb
  -- `S`'s bytes past `sig + 32` do not wrap
  have hS_off : ¬(sig.add 32#64).offset.uaddOverflow 32#64 :=
    Pointer.not_uaddOverflow_add_sub (a := 32#64) (b := 64#64) hsig_off (by decide)
  have hSv : S₀.mem.readAt (sig.add 32#64) 256 = (S₀.mem.readAt sig 512).extractLsb' 256 256 := by
    rw [← hS]
    exact MemoryState.readAt_add_of_fits (k := 32) hsig hsig_off (by decide) (by decide)
  obtain ⟨hsha_fits, hsha_off⟩ := hsha
  -- the inputs as read facts, which the steps carry past the frame's `alloca`s and stores
  have hread_r : S.mem.readAt sig 256 = S₀.mem.readAt sig 256 := by rw [hS]
  have hread_pk : S.mem.readAt pk 256 = S₀.mem.readAt pk 256 := by rw [hS]
  have hread_msg : S.mem.readAt msg (8 * msgSz.toNat) = S₀.mem.readAt msg (8 * msgSz.toNat) := by
    rw [hS]
  have hread_buf : S.mem.readAt sha 1024 = S₀.mem.readAt sha 1024 := by rw [hS]
  have hread_sig : S.mem.readAt sig 512 = S₀.mem.readAt sig 512 := by rw [hS]
  have hsig32 : ¬sig.offset.uaddOverflow 32#64 := BitVec.not_uaddOverflow_of_le hsig_off (by decide)
  block_init
  iterate 33 step_pure
  iterate 2 step_pattern using runBodyFrom_insertRun inline
  -- fd_ed25519_point_t Aprime[1], R[1]; uchar k[64];
  step_alloca with A
  step_alloca with R
  step_alloca with k
  -- uchar const * S = sig + 32;
  -- if( !fd_curve25519_scalar_validate( S ) ) return FD_ED25519_ERR_SIG;
  -- inlined: the top byte below 0x10, else below 0x20 and the borrow chain against ℓ - 1
  step_pure
  step_pure
  step_load
  step_pure
  finish_block
  rotate_left
  · -- the top byte at least 0x10
    have hb16 := hbr
    block_init
    step_pure
    finish_block
    rotate_left
    · -- the top byte at least 0x20: FD_ED25519_ERR_SIG
      have hv : fd_curve25519_scalar_validate.spec (S₀.mem.readAt (sig.add 32#64) 256) = false := by
        rw [hSv]
        exact validate_ge32 hbr
      block_init
      finish_block
      subst hS hres hnb
      erase_frame
      simp [Avx512.fd_ed25519_verify.spec, fd_ed25519_verify.blocks, hv,
        fd_ed25519_verify.Result.mem]
    · -- the borrow chain
      block_init
      step_load
      step_pure
      step_load
      step_pure
      step_load
      step_pure
      step_load
      iterate 9 step_pure
      finish_block
      case isTrue =>
        -- no borrow out: `S ≥ ℓ`, FD_ED25519_ERR_SIG
        have hv :
            fd_curve25519_scalar_validate.spec (S₀.mem.readAt (sig.add 32#64) 256) = false := by
          rw [hSv]
          exact (validate_borrow _).1 hbr
        block_init
        finish_block
        subst hS hres hnb
        erase_frame
        simp [Avx512.fd_ed25519_verify.spec, fd_ed25519_verify.blocks, hv,
          fd_ed25519_verify.Result.mem]
      case isFalse =>
        have hv :
            fd_curve25519_scalar_validate.spec (S₀.mem.readAt (sig.add 32#64) 256) = true := by
          rw [hSv]
          cases h : fd_curve25519_scalar_validate.spec ((S₀.mem.readAt sig 512).extractLsb' 256 256)
          · exact absurd ((validate_borrow _).2 h) hbr
          · rfl
        clear hbr hb16
        rest_steps
  · have hv : fd_curve25519_scalar_validate.spec (S₀.mem.readAt (sig.add 32#64) 256) = true := by
      rw [hSv]
      exact validate_lt16 hbr
    clear hbr
    rest_steps

/-- The lane build's `fd_ed25519_verify` conforms to `VerifyCallSpec`, its frame `blocks`
blocks. -/
public theorem _root_.Firedancer.Lane.Mlir.fd_ed25519_verify.call_spec : VerifyCallSpec :=
  ⟨fun msg msgSz sig pk sha s =>
    fd_ed25519_verify.blocks msgSz (s.mem.readAt msg (8 * msgSz.toNat)) (s.mem.readAt sig 256)
      (s.mem.readAt (sig.add 32#64) 256) (s.mem.readAt pk 256) (s.mem.readAt sha 1024),
    fun msg msgSz sig pk sha s hwf hg hmsg hmo hms hsig hso hpk hpo hsha hshaw h1 h2 h3 =>
    fd_ed25519_verify.call_eq msg msgSz sig pk sha s hwf hg hmsg hmo hms hsig hso hpk hpo hsha
      hshaw h1 h2 h3⟩

end Proof

end MLIR.Firedancer.Lane
