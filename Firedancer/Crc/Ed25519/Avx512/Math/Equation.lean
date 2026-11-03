module

public import Firedancer.Crc.Ed25519.Avx512.Math.Ladder
public import Firedancer.Crc.Ed25519.Avx512.Math.Decode
public import Firedancer.Crc.Ed25519.Avx512.Math.BaseTable
import Ed25519.BasePoint
import Mathlib.Tactic.FinCases
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.Ring
import Mathlib.Tactic.Linarith

/-! crc's equation check on the group: `fd_r52x5_ge_eq_z1` as point equality,
`fd_r52x5_double_scalar_mul_base` as `k A + S B` over the base table, and `fd_ed25519_verify` with
no spec hypotheses left. -/

namespace MLIR.Firedancer.Crc.Ed25519.Avx512

open MLIR.Firedancer.R52x5
open _root_.Ed25519 (p Point)
open fd_r52x5_double_scalar_mul_base

/-! ## `fd_r52x5_ge_eq_z1` -/

/-- `fd_r52x5_ge_eq_z1` of `R'` extended `Q` against `R` affine reduced `PR`: `0` exactly when
`Q ≠ PR`. -/
public theorem ge_eq_z1_zero_iff {R' R : Quad5} {Q PR : Point} (hR' : ExtF R' Q)
    (hR : R.Affine PR.x PR.y) (hb : R.Below 52) :
    fd_r52x5_ge_eq_z1.spec R' R = 0#32 ↔ Q ≠ PR := by
  obtain ⟨hz, hx, hy⟩ := Quad5.proj_iff.1 hR'.1.proj
  obtain ⟨r0, r1, -, -⟩ := hR
  have hM := fd_r52x5_quad_mul.spec_is hb.is (Quad5.permute_is 2 2 2 2 hR'.is)
    (fun _ => by norm_num) (fun _ => by norm_num)
  obtain ⟨c0, v0⟩ := fd_r52x5_canon.spec_canon ((fd_r52x5_quad_mul.spec R (Quad5.permute 2 2 2 2 R')).elem 0)
  obtain ⟨c1, v1⟩ := fd_r52x5_canon.spec_canon ((fd_r52x5_quad_mul.spec R (Quad5.permute 2 2 2 2 R')).elem 1)
  obtain ⟨a0, w0⟩ := fd_r52x5_canon.spec_canon (R'.elem 0)
  obtain ⟨a1, w1⟩ := fd_r52x5_canon.spec_canon (R'.elem 1)
  have m0 : (fd_r52x5_quad_mul.spec R (Quad5.permute 2 2 2 2 R')).val 0 = R.val 0 * R'.val 2 := hM.val 0
  have m1 : (fd_r52x5_quad_mul.spec R (Quad5.permute 2 2 2 2 R')).val 1 = R.val 1 * R'.val 2 := hM.val 1
  change _ = (fd_r52x5_quad_mul.spec R (Quad5.permute 2 2 2 2 R')).val 0 at v0
  change _ = (fd_r52x5_quad_mul.spec R (Quad5.permute 2 2 2 2 R')).val 1 at v1
  change _ = R'.val 0 at w0
  change _ = R'.val 1 at w1
  unfold fd_r52x5_ge_eq_z1.spec fd_r52x5_quad_lane_canon.spec
  dsimp only
  rw [Canon.limbs_eq c0 a0, Canon.limbs_eq c1 a1, v0, v1, w0, w1, m0, m1, r0, r1]
  have ex : PR.x * R'.val 2 = R'.val 0 ↔ Q.x = PR.x := by
    rw [hx]; constructor
    · intro h; exact (mul_right_cancel₀ hz h).symm
    · intro h; rw [h]
  have ey : PR.y * R'.val 2 = R'.val 1 ↔ Q.y = PR.y := by
    rw [hy]; constructor
    · intro h; exact (mul_right_cancel₀ hz h).symm
    · intro h; rw [h]
  have hne : (Q ≠ PR) ↔ ¬(Q.x = PR.x ∧ Q.y = PR.y) := by rw [Ne, Ed25519.Point.ext_iff]
  rw [hne]
  by_cases h1 : Q.x = PR.x <;> by_cases h2 : Q.y = PR.y <;> simp [ex, ey, h1, h2]

/-! ## `fd_r52x5_double_scalar_mul_base` -/

/-- `fd_r52x5_double_scalar_mul_base` of `k`, `A` extended `PA`, `S`, over a table of the odd
multiples of `PB`: `k PA + S PB`, for `k, S ≤ 2^253`. -/
public theorem dsmb_extF {TB : Nat → Quad5} {A : Quad5} {PA PB : Point} {k S : BitVec 256}
    (hTB : OddTab TB 128 PB) (hA : ExtF A PA) (hk : k.toNat ≤ 2 ^ 253) (hS : S.toNat ≤ 2 ^ 253) :
    ExtF (spec TB k A S) (k.toNat • PA + S.toNat • PB) := by
  unfold spec
  split
  · rename_i h0
    have hk0 : fd_r52x5_wnaf.count 4 k = 0 := by unfold steps at h0; omega
    have hS0 : fd_r52x5_wnaf.count 8 S = 0 := by unfold steps at h0; omega
    rw [fd_r52x5_wnaf.count_eq_zero _ _ hk0, fd_r52x5_wnaf.count_eq_zero _ _ hS0]
    exact quadZero_extF.congr (by simp)
  · rename_i h0
    have h := ladder_extF (odd_table_oddTab hA 8) hTB (DK_digit k) (DS_digit S) (steps k S - 1)
      quadZero_extF
    refine h.congr ?_
    have e : steps k S - 1 + 1 = steps k S := by omega
    rw [e, fd_r52x5_double_scalar_mul_base.dsum_DK k hk (steps k S) (le_max_left _ _),
      fd_r52x5_double_scalar_mul_base.dsum_DS S hS (steps k S) (le_max_right _ _), smul_zero, zero_add,
      natCast_zsmul, natCast_zsmul]

/-! ## The equation check -/

/-- The equation check over the base table computes the group equation. -/
public theorem equationSpec : EquationSpec := by
  intro A R PA PR k S hAa hAb hRa hRb hk hS
  have hA' := neg_lane_extF hAa hAb
  have h := dsmb_extF fd_ed25519_r52x5_base_table.oddTab hA' hk hS
  exact ge_eq_z1_zero_iff h hRa hRb

/-! ## `fd_ed25519_verify` -/

/-- crc's `fd_ed25519_verify` returns `Ed25519.Firedancer.verify`'s code on any well-formed state
whose globals hold its constants. -/
public theorem fd_ed25519_verify.call_ret_final (msg : Pointer) (msgSz : BitVec 64)
    (sig pk sha : Pointer) (s : GlobalState) (hwf : s.WF)
    (hg : s.mem.Globals fd_ed25519_verify.globals)
    (hmsg : Fits s.mem msg (8 * msgSz.toNat)) (hmsg_off : ¬msg.offset.uaddOverflow msgSz)
    (hmsgSz : msgSz.toNat < 2 ^ 63) (hsig : Fits s.mem sig (8 * 64))
    (hsig_off : ¬sig.offset.uaddOverflow 64#64) (hpk : Fits s.mem pk (8 * 32))
    (hpk_off : ¬pk.offset.uaddOverflow 32#64) (hsha : s.mem.ShaFit sha) (hshaw : Writable s.mem sha)
    (hmsg_sha : msg.id ≠ sha.id) (hsig_sha : sig.id ≠ sha.id) (hpk_sha : pk.id ≠ sha.id) :
    ∃ s',
      fd_ed25519_verify.call
          (fd_ed25519_verify.args (.value msg) (.value msgSz) (.value sig) (.value pk) (.value sha))
          s =
        .value
          (.cons
              (.value
                (Ed25519.Firedancer.verify (Ed25519.bytesLE (s.mem.readAt msg (8 * msgSz.toNat)))
                  (s.mem.readAt sig 256) (s.mem.readAt (sig.add 32#64) 256) (s.mem.readAt pk 256)))
              .nil,
            s') :=
  fd_ed25519_verify.call_ret'' msg msgSz sig pk sha equationSpec s hwf hg hmsg hmsg_off hmsgSz hsig
    hsig_off hpk hpk_off hsha hshaw hmsg_sha hsig_sha hpk_sha

end MLIR.Firedancer.Crc.Ed25519.Avx512
