module

public import MLIR.Run.Tactic
public import Ed25519.Sha512
public import Agave.Common.Sha512Rounds
public import Agave.Common.Sha512
import Firedancer.Common.Point
public import Agave.Avx2.Mlir.compress512
import Std.Tactic.BVDecide
meta import Std.Tactic.BVDecide.Reflect

/-! What `compress512`'s blocks share: `^bb0`'s constants, the code's round and schedule update,
and the message schedule buffers in memory. -/

namespace MLIR.Agave.Avx2.compress512

open _root_.Ed25519 MLIR.Agave

@[expose] public section

/-- `^bb0`'s constants, which the later blocks read. -/
abbrev Consts (E : ⟪Γ⟫) : Prop :=
  E ⊨ [%3801 := 1#32, %3802 := 1#64, %3803 := 0#64, %3804 := 8#64, %3805 := 16#64, %3806 :=
    (Vector.replicate 16 .poison : ⟦.vec 16 8⟧), %3807 :=
    #v[4794697086780616226#64, 8158064640168781261#64], %3808 :=
    #v[13096744586834688815#64, 16840607885511220156#64], %3809 :=
    #v[4131703408338449720#64, 6480981068601479193#64], %3810 :=
    #v[10538285296894168987#64, 12329834152419229976#64], %3811 := 64#64, %3812 :=
    #v[15566598209576043074#64, 1334009975649890238#64], %3813 := 80#64, %3814 :=
    #v[2608012711638119052#64, 6128411473006802146#64], %3815 :=
    #v[8268148722764581231#64, 9286055187155687089#64], %3816 :=
    #v[11230858885718282805#64, 13951009754708518548#64], %3817 := 0#32, %3819 :=
    Vector.replicate 2 1#64, %3820 := Vector.replicate 2 7#64, %3821 := Vector.replicate 2 56#64,
    %3822 := Vector.replicate 2 8#64, %3823 := Vector.replicate 2 63#64, %3824 :=
    Vector.replicate 2 6#64, %3825 := Vector.replicate 2 3#64, %3826 := Vector.replicate 2 19#64,
    %3827 := Vector.replicate 2 45#64, %3828 := Vector.replicate 2 61#64, %3829 := 4#64, %3830 :=
    50#64, %3831 := 46#64, %3832 := 23#64, %3833 := 36#64, %3834 := 30#64, %3835 := 25#64, %3836 :=
    2#64, %3837 := 4#32, %3838 := 15#64, %3839 := 0#8, %3840 := 512#64, %3841 :=
    (Vector.replicate 32 .poison : ⟦.vec 32 8⟧), %3842 :=
    #v[4794697086780616226#64, 8158064640168781261#64, 4794697086780616226#64,
      8158064640168781261#64],
    %3843 := (Vector.replicate 4 .poison : ⟦.vec 4 64⟧), %3844 :=
    #v[13096744586834688815#64, 16840607885511220156#64, 13096744586834688815#64,
      16840607885511220156#64],
    %3845 :=
    #v[4131703408338449720#64, 6480981068601479193#64, 4131703408338449720#64,
      6480981068601479193#64],
    %3846 :=
    #v[10538285296894168987#64, 12329834152419229976#64, 10538285296894168987#64,
      12329834152419229976#64],
    %3847 :=
    #v[15566598209576043074#64, 1334009975649890238#64, 15566598209576043074#64,
      1334009975649890238#64],
    %3848 :=
    #v[2608012711638119052#64, 6128411473006802146#64, 2608012711638119052#64,
      6128411473006802146#64],
    %3849 :=
    #v[8268148722764581231#64, 9286055187155687089#64, 8268148722764581231#64,
      9286055187155687089#64],
    %3850 :=
    #v[11230858885718282805#64, 13951009754708518548#64, 11230858885718282805#64,
      13951009754708518548#64],
    %3851 := 7#64, %3852 := (Vector.replicate 2 .poison : ⟦.vec 2 64⟧), %3853 :=
    Vector.replicate 4 1#64, %3854 := Vector.replicate 4 7#64, %3855 := Vector.replicate 4 56#64,
    %3856 := Vector.replicate 4 8#64, %3857 := Vector.replicate 4 63#64, %3858 :=
    Vector.replicate 4 6#64, %3859 := Vector.replicate 4 3#64, %3860 := Vector.replicate 4 19#64,
    %3861 := Vector.replicate 4 45#64, %3862 := Vector.replicate 4 61#64, %3863 := 5#64, %3864 :=
    640#64, %3865 := 18446744073709551615#64]

/-- `K`'s block and the stack buffers: `ms` and `t2`, `ms2` of the two-block path. -/
abbrev Ptrs (Kp ms t2 ms2 : Pointer) (E : ⟪Γ⟫) : Prop :=
  E ⊨ [%3818 := Kp, %3866 := ms, %3867 := t2, %3868 := ms2]

/-- `sha_round(s, w)` on the working variables `v` (`a … h`), the word `w` already summed with its
`K`, as the code sums it. -/
def wround (v : Vector (BitVec 64) 8) (w : BitVec 64) : Vector (BitVec 64) 8 :=
  let t := Sha512.Sigma1 v[4] + v[7] + Sha512.Ch v[4] v[5] v[6] + w
  #v[Sha512.Maj v[0] v[1] v[2] + Sha512.Sigma0 v[0] + t, v[0], v[1], v[2], t + v[3], v[4], v[5],
    v[6]]

/-- The words `W t + K t` the rounds read. -/
abbrev wk (W : Nat → BitVec 64) (t : Nat) : BitVec 64 :=
  W t + Sha512.K[t]!

/-- `sha512_update_x` on one block's lanes: from `x[0]`, `x[1]`, `x[4]`, `x[5]`, `x[7]`, the next
two schedule words. -/
def upd2 (x0 x1 x4 x5 x7 : Vector (BitVec 64) 2) : Vector (BitVec 64) 2 :=
  #v[x0[0] + x4[1] + Sha512.sigma0 x0[1] + Sha512.sigma1 x7[0],
    x0[1] + x5[0] + Sha512.sigma0 x1[0] + Sha512.sigma1 x7[1]]

end

@[expose] public section

/-- `y = sha512_update_x(x, k64)`'s result: the next schedule words `xn` plus their `K`, `kv`. -/
def ypair (kv xn : Vector (BitVec 64) 2) : Vector (BitVec 64) 2 :=
  #v[kv[0] + xn[0], kv[1] + xn[1]]

/-- The schedule pair `p`: words `2 p`, `2 p + 1`. -/
def xp (W : Nat → BitVec 64) (p : Nat) : Vector (BitVec 64) 2 :=
  #v[W (2 * p), W (2 * p + 1)]

/-- `W` follows the message schedule's recurrence (§6.4.2) from word `16` to `79`. -/
abbrev Sched (W : Nat → BitVec 64) : Prop :=
  ∀ t,
    16 ≤ t →
      t < 80 → W t = Sha512.sigma1 (W (t - 2)) + W (t - 7) + Sha512.sigma0 (W (t - 15)) + W (t - 16)

/-- The message schedule of the block `B`. -/
abbrev bsched (B : BitVec 1024) (t : Nat) : BitVec 64 :=
  (Sha512.schedule (bytesLE B))[t]!

/-- Eight state words stored at `p`, the lowest first, as `accumulate_state` stores them. -/
def storeWords (m : MemoryState) (p : Pointer) (v : Vector (BitVec 64) 8) : MemoryState :=
  (((((((m.storeAt p v[0]).storeAt (p.add 8#64) v[1]).storeAt (p.add 16#64) v[2]).storeAt
                    (p.add 24#64) v[3]).storeAt
                (p.add 32#64) v[4]).storeAt
            (p.add 40#64) v[5]).storeAt
        (p.add 48#64) v[6]).storeAt
    (p.add 56#64) v[7]

/-- `K`'s block holds the round constants, read as pairs from any word. -/
abbrev KPairs (m : MemoryState) (Kp : Pointer) : Prop :=
  ∀ k,
    k + 2 ≤ 80 →
      m.readAt (Kp.add (BitVec.ofNat 64 (k * 8))) 128 =
        BitVec.packLanes #v[Sha512.K[k]!, Sha512.K[k + 1]!]

/-- `sha512_update_x_avx2` on two blocks' lanes: `upd2` on lanes `0, 1` and on lanes `2, 3`. -/
def upd4 (x0 x1 x4 x5 x7 : Vector (BitVec 64) 4) : Vector (BitVec 64) 4 :=
  #v[x0[0] + x4[1] + Sha512.sigma0 x0[1] + Sha512.sigma1 x7[0],
    x0[1] + x5[0] + Sha512.sigma0 x1[0] + Sha512.sigma1 x7[1],
    x0[2] + x4[3] + Sha512.sigma0 x0[3] + Sha512.sigma1 x7[2],
    x0[3] + x5[2] + Sha512.sigma0 x1[2] + Sha512.sigma1 x7[3]]

/-- The schedule pair `p` of two blocks, as `load_data_avx2` packs them: the first block's in
lanes `0, 1`, the second's in `2, 3`. -/
def xq (W₀ W₁ : Nat → BitVec 64) (p : Nat) : Vector (BitVec 64) 4 :=
  #v[W₀ (2 * p), W₀ (2 * p + 1), W₁ (2 * p), W₁ (2 * p + 1)]

/-- `y`'s first block's lanes, `_mm256_extracti128_si256(y, 0)`: the next schedule words `xn`
plus `K`. -/
def ylo (xn : Vector (BitVec 64) 4) (k0 k1 : BitVec 64) : Vector (BitVec 64) 2 :=
  #v[xn[0] + k0, xn[1] + k1]

/-- `y`'s second block's lanes, `_mm256_extracti128_si256(y, 1)`. -/
def yhi (xn : Vector (BitVec 64) 4) (k0 k1 : BitVec 64) : Vector (BitVec 64) 2 :=
  #v[xn[2] + k0, xn[3] + k1]

/-- The schedule pairs `p … p + n - 1` (their words plus `K`) stored at bytes `16 p …` of `X`, as
`load_data_avx2` and `rounds_0_63_avx2` store the second block's into `t2`. -/
def tMem (X : Pointer) (W : Nat → BitVec 64) : (p n : Nat) → MemoryState → MemoryState
  | _, 0, mem => mem
  | p, n + 1, mem =>
    tMem X W (p + 1) n
      (mem.storeAt (X.add (BitVec.ofNat 64 (p * 16)))
        (BitVec.packLanes #v[wk W (2 * p), wk W (2 * p + 1)]))

end

/-! ## Arithmetic -/

public theorem saddOverflow_ofNat {i k : Nat} (h : i + k < 2 ^ 63) :
    (BitVec.ofNat 64 i).saddOverflow (BitVec.ofNat 64 k) = false := by
  have hi : (BitVec.ofNat 64 i).toInt = i := by rw [BitVec.toInt_eq_toNat_of_lt] <;> simp <;> omega
  have hk : (BitVec.ofNat 64 k).toInt = k := by rw [BitVec.toInt_eq_toNat_of_lt] <;> simp <;> omega
  simp [BitVec.saddOverflow, hi, hk]
  omega

public theorem uaddOverflow_ofNat {i k : Nat} (h : i + k < 2 ^ 64) :
    (BitVec.ofNat 64 i).uaddOverflow (BitVec.ofNat 64 k) = false := by
  simp [BitVec.uaddOverflow]
  omega

public theorem saddOverflow_ofNat32 {i k : Nat} (h : i + k < 2 ^ 31) :
    (BitVec.ofNat 32 i).saddOverflow (BitVec.ofNat 32 k) = false := by
  have hi : (BitVec.ofNat 32 i).toInt = i := by rw [BitVec.toInt_eq_toNat_of_lt] <;> simp <;> omega
  have hk : (BitVec.ofNat 32 k).toInt = k := by rw [BitVec.toInt_eq_toNat_of_lt] <;> simp <;> omega
  simp [BitVec.saddOverflow, hi, hk]
  omega

public theorem uaddOverflow_ofNat32 {i k : Nat} (h : i + k < 2 ^ 32) :
    (BitVec.ofNat 32 i).uaddOverflow (BitVec.ofNat 32 k) = false := by
  simp [BitVec.uaddOverflow]
  omega

public theorem eq_of_ofNat32_eq {m n : Nat} (h : BitVec.ofNat 32 m = BitVec.ofNat 32 n)
    (hm : m < 2 ^ 32) (hn : n < 2 ^ 32) : m = n := by
  have := congrArg BitVec.toNat h
  simp only [BitVec.toNat_ofNat] at this
  omega

public theorem eq_of_ofNat_eq {m n : Nat} (h : BitVec.ofNat 64 m = BitVec.ofNat 64 n)
    (hm : m < 2 ^ 64) (hn : n < 2 ^ 64) : m = n := by
  have := congrArg BitVec.toNat h
  simp only [BitVec.toNat_ofNat] at this
  omega

/-- `m & 0xf`: `m % 16`. -/
public theorem and_15 (m : Nat) : BitVec.ofNat 64 m &&& 15#64 = BitVec.ofNat 64 (m % 16) := by
  apply BitVec.eq_of_toNat_eq
  rw [BitVec.toNat_and, show (15#64).toNat = 2 ^ 4 - 1 from rfl, Nat.and_two_pow_sub_one_eq_mod,
    BitVec.toNat_ofNat, BitVec.toNat_ofNat]
  omega

/-- A dynamic `getelementptr` by `k` elements of `stride` bytes from a block's start. -/
public theorem gepDyn_slot {f : GepFlags} {X : Pointer} (hX : X.offset = 0) {k stride : Nat}
    (hk : k * stride < 2 ^ 63) (hk' : k < 2 ^ 64) :
    Operation.gepDyn f 0 stride (.value X) (.value (BitVec.ofNat 64 k)) =
      .value (X.add (BitVec.ofNat 64 (k * stride))) := by
  have e : (BitVec.ofNat 64 k).toNat = k := by
    simp; omega
  rw [gepDyn_value
      (by
        rw [e]; omega)
      (.inr
        (by
          rw [e]; omega))
      (by
        simp [BitVec.uaddOverflow, hX, e]; omega),
    e, Nat.zero_add]

/-- `j << s`: `j * 2 ^ s`. -/
public theorem ofNat_shiftLeft (j s : Nat) :
    BitVec.ofNat 64 j <<< s = BitVec.ofNat 64 (j * 2 ^ s) := by
  apply BitVec.eq_of_toNat_eq
  simp [BitVec.toNat_shiftLeft, Nat.shiftLeft_eq]

/-- `j << s`'s `nuw` holds below `2 ^ (64 - s)`. -/
public theorem ofNat_mul_ushiftRight {j s : Nat} (h : j * 2 ^ s < 2 ^ 64) :
    BitVec.ofNat 64 (j * 2 ^ s) >>> s = BitVec.ofNat 64 j := by
  apply BitVec.eq_of_toNat_eq
  have : j < 2 ^ 64 := Nat.lt_of_le_of_lt (Nat.le_mul_of_pos_right j (Nat.two_pow_pos s)) h
  simp only [BitVec.toNat_ushiftRight, BitVec.toNat_ofNat, Nat.shiftRight_eq_div_pow,
    Nat.mod_eq_of_lt h, Nat.mod_eq_of_lt this, Nat.mul_div_cancel _ (Nat.two_pow_pos s)]

/-- `j << s`'s `nsw` holds below `2 ^ 63`. -/
public theorem ofNat_mul_sshiftRight {j s : Nat} (h : j * 2 ^ s < 2 ^ 63) :
    (BitVec.ofNat 64 (j * 2 ^ s)).sshiftRight s = BitVec.ofNat 64 j := by
  rw [BitVec.sshiftRight_eq_of_msb_false
      (by
        simp [BitVec.msb_eq_decide]; omega),
    ← BitVec.ushiftRight_eq]
  exact ofNat_mul_ushiftRight (by omega)

/-! ## The round -/

/-- `Ch` as the code computes it, `g ^ (e & (f ^ g))`. -/
public theorem ch_code (e f g : BitVec 64) : (f ^^^ g) &&& e ^^^ g = Sha512.Ch e f g := by
  simp only [Sha512.Ch]; bv_decide

/-- `Ch` as the code computes it in a round's second half. -/
public theorem ch_code2 (e f g : BitVec 64) : e &&& (g ^^^ f) ^^^ g = Sha512.Ch e f g := by
  simp only [Sha512.Ch]; bv_decide

/-- `Maj` as the code computes it. -/
public theorem maj_code1 (a b c : BitVec 64) : (c ^^^ b) &&& a ^^^ c &&& b = Sha512.Maj a b c := by
  simp only [Sha512.Maj]; bv_decide

/-- `Maj` as the code computes it in a round's second half. -/
public theorem maj_code2 (a b c : BitVec 64) : a &&& (c ^^^ b) ^^^ c &&& b = Sha512.Maj a b c := by
  simp only [Sha512.Maj]; bv_decide

/-- `σ₀` as the vector code computes it. -/
public theorem ssig0_vcode (x : BitVec 64) :
    x >>> 1 ^^^ x >>> 7 ^^^ x <<< 56 ^^^ x >>> 8 ^^^ x <<< 63 = Sha512.sigma0 x := by
  simp only [Sha512.sigma0]; bv_decide

/-- `σ₁` as the vector code computes it. -/
public theorem ssig1_vcode (x : BitVec 64) :
    x <<< 3 ^^^ x >>> 6 ^^^ x >>> 19 ^^^ x <<< 45 ^^^ x >>> 61 = Sha512.sigma1 x := by
  simp only [Sha512.sigma1]; bv_decide

/-- A round of the spec: `wround` on its word plus `K`. -/
public theorem round_eq_wround (v : Vector (BitVec 64) 8) (k x : BitVec 64) :
    Sha512.round v k x = wround v (x + k) := by
  simp only [Sha512.round, wround]
  rw [show
      v[7] + Sha512.Sigma1 v[4] + Sha512.Ch v[4] v[5] v[6] + k + x =
        Sha512.Sigma1 v[4] + v[7] + Sha512.Ch v[4] v[5] v[6] + (x + k)
      by ac_rfl,
    show
      (Sha512.Sigma1 v[4] + v[7] + Sha512.Ch v[4] v[5] v[6] + (x + k)) +
          (Sha512.Sigma0 v[0] + Sha512.Maj v[0] v[1] v[2]) =
        Sha512.Maj v[0] v[1] v[2] + Sha512.Sigma0 v[0] +
          (Sha512.Sigma1 v[4] + v[7] + Sha512.Ch v[4] v[5] v[6] + (x + k))
      by ac_rfl,
    show
      v[3] + (Sha512.Sigma1 v[4] + v[7] + Sha512.Ch v[4] v[5] v[6] + (x + k)) =
        Sha512.Sigma1 v[4] + v[7] + Sha512.Ch v[4] v[5] v[6] + (x + k) + v[3]
      by ac_rfl]

/-- `rounds` one further, as `wround`. -/
public theorem rounds_succ_wround (W : Nat → BitVec 64) (n : Nat) (H : Vector (BitVec 64) 8) :
    rounds W (n + 1) H = wround (rounds W n H) (wk W n) := by rw [rounds_succ, round_eq_wround]

/-- Two rounds as the two-round loop bodies sum them. -/
public theorem two_rounds {v : Vector (BitVec 64) 8} {w0 w1 t1 a1 e1 t2 a2 e2 : BitVec 64}
    (ht1 : t1 = Sha512.Sigma1 v[4] + v[7] + Sha512.Ch v[4] v[5] v[6] + w0)
    (ha1 : a1 = Sha512.Maj v[0] v[1] v[2] + Sha512.Sigma0 v[0] + t1) (he1 : e1 = t1 + v[3])
    (ht2 : t2 = w1 + v[6] + Sha512.Ch e1 v[4] v[5] + Sha512.Sigma1 e1)
    (ha2 : a2 = Sha512.Sigma0 a1 + Sha512.Maj a1 v[0] v[1] + t2) (he2 : e2 = t2 + v[2]) :
    wround (wround v w0) w1 = #v[a2, a1, v[0], v[1], e2, e1, v[4], v[5]] := by
  subst ht1 ha1 he1 ht2 ha2 he2
  simp only [wround, Vector.getElem_mk, List.getElem_toArray, List.getElem_cons_succ,
    List.getElem_cons_zero]
  congr 2
  ac_rfl

/-- Two rounds of the spec, as two `wround`s. -/
public theorem rounds_two (W : Nat → BitVec 64) (m : Nat) (H : Vector (BitVec 64) 8) :
    wround (wround (rounds W (2 * m) H) (wk W (2 * m))) (wk W (2 * m + 1)) =
      rounds W (2 * m + 2) H := by
  rw [rounds_succ_wround, rounds_succ_wround]

/-- `sha512_update_x` on the schedule pairs `m …`: pair `m + 8`. -/
public theorem upd2_xp {W : Nat → BitVec 64} (hW : Sched W) {m : Nat} (hm : m < 32) :
    upd2 (xp W m) (xp W (m + 1)) (xp W (m + 4)) (xp W (m + 5)) (xp W (m + 7)) = xp W (m + 8) := by
  have h0 := hW (2 * (m + 8)) (by omega) (by omega)
  have h1 := hW (2 * (m + 8) + 1) (by omega) (by omega)
  simp only [show 2 * (m + 8) - 2 = 2 * (m + 7) by omega,
    show 2 * (m + 8) - 7 = 2 * (m + 4) + 1 by omega, show 2 * (m + 8) - 15 = 2 * m + 1 by omega,
    show 2 * (m + 8) - 16 = 2 * m by omega, show 2 * (m + 8) + 1 - 2 = 2 * (m + 7) + 1 by omega,
    show 2 * (m + 8) + 1 - 7 = 2 * (m + 5) by omega,
    show 2 * (m + 8) + 1 - 15 = 2 * (m + 1) by omega,
    show 2 * (m + 8) + 1 - 16 = 2 * m + 1 by omega] at h0 h1
  simp only [upd2, xp, Vector.getElem_mk, List.getElem_toArray, List.getElem_cons_succ,
    List.getElem_cons_zero, h0, h1]
  congr 2
  ac_rfl

/-- `ypair` of pair `p`'s `K` words and schedule words: their sums. -/
public theorem ypair_xp (W : Nat → BitVec 64) {p k : Nat} (hk : k = 2 * p) :
    ypair #v[Sha512.K[k]!, Sha512.K[k + 1]!] (xp W p) = #v[wk W (2 * p), wk W (2 * p + 1)] := by
  subst hk
  simp only [ypair, xp, wk, Vector.getElem_mk, List.getElem_toArray, List.getElem_cons_succ,
    List.getElem_cons_zero, BitVec.add_comm (Sha512.K[_]!)]

/-- The block's schedule follows the recurrence. -/
public theorem sched_bsched (B : BitVec 1024) : Sched (bsched B) := fun _ h1 h2 =>
  Sha512.getElem!_schedule_ge _ h1 h2

/-- A block's compression: its rounds' working variables added to `H`. -/
public theorem compress_eq (H : Vector (BitVec 64) 8) (B : BitVec 1024) :
    Sha512.compress H (bytesLE B) = Vector.zipWith (· + ·) H (rounds (bsched B) 80 H) := by
  simp only [rounds, Sha512.compress]

/-- A word of a block's compression: its last round's word plus `H`'s, as `accumulate_state`
sums them. -/
public theorem rounds_add (H : Vector (BitVec 64) 8) (B : BitVec 1024) {i : Nat} (hi : i < 8) :
    (rounds (bsched B) 80 H)[i] + H[i] = (Sha512.compress H (bytesLE B))[i] := by
  rw [compress_eq, Vector.getElem_zipWith, BitVec.add_comm]

/-- The 128 bits `X`, byte-swapped by 64-bit lanes as `_mm_shuffle_epi8` with `load_data`'s mask
and the `bitcast` leave them: each lane's bytes, the lowest first and most significant. -/
public theorem load_lanes {X : BitVec 128} {d sh : Vector (BitVec 8) 16} {x : Vector (BitVec 64) 2}
    (hd : d = Vector.ofFn fun i => Ty.extractVecElem 16 8 i X)
    (hsh :
      sh =
        #v[d[7], d[6], d[5], d[4], d[3], d[2], d[1], d[0], d[15], d[14], d[13], d[12], d[11], d[10],
          d[9], d[8]])
    (hx :
      x =
        #v[sh[7] ++ sh[6] ++ sh[5] ++ sh[4] ++ sh[3] ++ sh[2] ++ sh[1] ++ sh[0],
          sh[15] ++ sh[14] ++ sh[13] ++ sh[12] ++ sh[11] ++ sh[10] ++ sh[9] ++ sh[8]])
    {B : BitVec 1024} {q : Nat} (hq : q < 8) (hX : X = B.extractLsb' (128 * q) 128) :
    x = xp (bsched B) q := by
  have e (i : Nat) (hi : i < 16) : d[i] = (bytesLE B)[16 * q + i]! := by
    rw [hd, getElem!_bytesLE _ (by omega), hX]
    simp only [Vector.getElem_ofFn, Ty.extractVecElem_eq]
    apply BitVec.eq_of_getLsbD_eq
    intro j hj
    simp only [BitVec.getLsbD_extractLsb', hj, decide_true, Bool.true_and]
    rw [decide_eq_true (show i * 8 + j < 8 * 16 by omega), Bool.true_and]
    congr 1
    omega
  subst hx hsh
  simp only [xp, bsched, Sha512.getElem!_schedule_lt _ (show 2 * q < 16 by omega),
    Sha512.getElem!_schedule_lt _ (show 2 * q + 1 < 16 by omega), Sha512.word]
  simp only [Vector.getElem_mk, List.getElem_toArray, List.getElem_cons_succ,
    List.getElem_cons_zero]
  simp (disch := decide) only [e]
  simp only [show 8 * (2 * q) = 16 * q by omega, show 8 * (2 * q + 1) = 16 * q + 8 by omega,
    Nat.add_zero, Nat.add_assoc, Nat.reduceAdd]

/-! ## The schedule buffers -/

@[expose] public section

/-- The buffer `X` holds the words `wk W t` for `lo ≤ t < hi`, word `t` at slot `t % 16`. -/
def HoldsR (m : MemoryState) (X : Pointer) (W : Nat → BitVec 64) (lo hi : Nat) : Prop :=
  ∀ t, lo ≤ t → t < hi → m.readAt (X.add (BitVec.ofNat 64 (t % 16 * 8))) 64 = wk W t

/-- The buffer `X` holds the words `wk W t` for `t < n`, word `t` at byte `8 t`. -/
def HoldsT (m : MemoryState) (X : Pointer) (W : Nat → BitVec 64) (n : Nat) : Prop :=
  ∀ t, t < n → m.readAt (X.add (BitVec.ofNat 64 (t * 8))) 64 = wk W t

end

theorem offsetInBits_slot {X : Pointer} (hX : X.offset = 0) {b : Nat} (hb : b < 2 ^ 64) :
    (X.add (BitVec.ofNat 64 b)).offsetInBits = 8 * b := by
  simp [Pointer.offsetInBits, Pointer.add, hX, Nat.mod_eq_of_lt hb]

/-- A word of a lane pair stored at byte `b` of a buffer, read back. -/
public theorem readAt_storeAt_pair {m : MemoryState} {X : Pointer} (hX : X.offset = 0) {n b : Nat}
    (hf : Room m X (8 * n)) (hb : b + 16 ≤ n) (hn : n < 2 ^ 60) (v : Vector (BitVec 64) 2)
    {l : Nat} (hl : l < 2) :
    (m.storeAt (X.add (BitVec.ofNat 64 b)) (BitVec.packLanes v)).readAt
        (X.add (BitVec.ofNat 64 (b + 8 * l))) 64 =
      v[l] := by
  have hin : Room m (X.add (BitVec.ofNat 64 b)) 128 :=
    Room.add_of_le
      (by
        simp [BitVec.uaddOverflow, hX]; omega)
      (by
        simp; omega)
      hf
  have hself := MemoryState.readAt_storeAt_self hin (BitVec.packLanes v)
  rw [show
      X.add (BitVec.ofNat 64 (b + 8 * l)) =
        (X.add (BitVec.ofNat 64 b)).add (BitVec.ofNat 64 (8 * l))
      by rw [Pointer.add_add, BitVec.ofNat_add],
    MemoryState.readAt_add_of_readAt hin.inBounds.storeAt
      (by
        simp [BitVec.uaddOverflow, Pointer.add, hX]; omega)
      (by
        simp; omega)
      hself]
  rw [show (BitVec.ofNat 64 (8 * l)).toNat * 8 = l * 64 by
      simp; omega]
  exact BitVec.extractLsb'_packLanes v l hl

/-- A word apart from a store's 128 bits, read past it. -/
public theorem readAt_storeAt_pair_ne {m : MemoryState} {X : Pointer} (hX : X.offset = 0)
    {b c : Nat} (hb : b < 2 ^ 60) (hc : c < 2 ^ 60) (h : c + 8 ≤ b ∨ b + 16 ≤ c) (x : BitVec 128) :
    (m.storeAt (X.add (BitVec.ofNat 64 b)) x).readAt (X.add (BitVec.ofNat 64 c)) 64 =
      m.readAt (X.add (BitVec.ofNat 64 c)) 64 := by
  apply MemoryState.readAt_storeAt_disjoint
  simp only [Range.Disjoint, Range.of, offsetInBits_slot hX (show b < 2 ^ 64 by omega),
    offsetInBits_slot hX (show c < 2 ^ 64 by omega)]
  omega

/-- A pair stored at slot `p % 8` of a ring buffer: words `2 p`, `2 p + 1` in, the two it
overwrites out. -/
public theorem HoldsR.store {m : MemoryState} {X : Pointer} {W : Nat → BitVec 64} {lo p : Nat}
    (hX : X.offset = 0) (hf : Room m X 1024) (h : HoldsR m X W lo (2 * p))
    (v : Vector (BitVec 64) 2) (h0 : v[0] = wk W (2 * p)) (h1 : v[1] = wk W (2 * p + 1)) :
    HoldsR (m.storeAt (X.add (BitVec.ofNat 64 (p % 8 * 16))) (BitVec.packLanes v)) X W
      (max lo (2 * p - 14)) (2 * p + 2) := by
  intro t ht1 ht2
  by_cases hlt : t < 2 * p
  · rw [readAt_storeAt_pair_ne hX (by omega) (by omega) (by omega)]
    exact h t (by omega) hlt
  · have e :=
      readAt_storeAt_pair hX (n := 128) hf (b := p % 8 * 16) (by omega) (by decide) v (l :=
        t - 2 * p) (by omega)
    rw [show p % 8 * 16 + 8 * (t - 2 * p) = t % 16 * 8 by omega] at e
    rw [e]
    rcases (show t = 2 * p ∨ t = 2 * p + 1 by omega) with rfl | rfl
    · simpa using h0
    · simpa using h1

/-- A pair stored at byte `16 p` of a buffer holding words `t < 2 p`: words `2 p`, `2 p + 1` in. -/
public theorem HoldsT.store {m : MemoryState} {X : Pointer} {W : Nat → BitVec 64} {p : Nat}
    (hX : X.offset = 0) (hf : Room m X 5120) (hp : p < 40) (h : HoldsT m X W (2 * p))
    (v : Vector (BitVec 64) 2) (h0 : v[0] = wk W (2 * p)) (h1 : v[1] = wk W (2 * p + 1)) :
    HoldsT (m.storeAt (X.add (BitVec.ofNat 64 (p * 16))) (BitVec.packLanes v)) X W (2 * p + 2) := by
  intro t ht
  by_cases hlt : t < 2 * p
  · rw [readAt_storeAt_pair_ne hX (by omega) (by omega) (by omega)]
    exact h t hlt
  · have e :=
      readAt_storeAt_pair hX (n := 640) hf (b := p * 16) (by omega) (by decide) v (l := t - 2 * p)
        (by omega)
    rw [show p * 16 + 8 * (t - 2 * p) = t * 8 by omega] at e
    rw [e]
    rcases (show t = 2 * p ∨ t = 2 * p + 1 by omega) with rfl | rfl
    · simpa using h0
    · simpa using h1

/-! ## A ring buffer's stores -/

@[expose] public section

/-- The schedule pairs `p … p + n - 1` (their words plus `K`) stored at slots `p % 8 …` of the
ring buffer `X`, as `load_data` and `rounds_0_63`'s iterations store them. -/
def pairsMem (X : Pointer) (W : Nat → BitVec 64) : (p n : Nat) → MemoryState → MemoryState
  | _, 0, mem => mem
  | p, n + 1, mem =>
    pairsMem X W (p + 1) n
      (mem.storeAt (X.add (BitVec.ofNat 64 (p % 8 * 16)))
        (BitVec.packLanes #v[wk W (2 * p), wk W (2 * p + 1)]))

end

public theorem pairsMem_succ {X : Pointer} {W : Nat → BitVec 64} {p n : Nat} {mem : MemoryState} :
    pairsMem X W p (n + 1) mem =
      pairsMem X W (p + 1) n
        (mem.storeAt (X.add (BitVec.ofNat 64 (p % 8 * 16)))
          (BitVec.packLanes #v[wk W (2 * p), wk W (2 * p + 1)])) :=
  rfl

public theorem pairsMem_add {X : Pointer} {W : Nat → BitVec 64} {mem : MemoryState} :
    ∀ {p n n'}, pairsMem X W (p + n) n' (pairsMem X W p n mem) = pairsMem X W p (n + n') mem := by
  intro p n n'
  induction n generalizing p mem with
  | zero =>
    rw [Nat.add_zero, Nat.zero_add]; rfl
  | succ n ih =>
    rw [pairsMem_succ, show p + (n + 1) = p + 1 + n by omega, ih,
      show n + 1 + n' = (n + n') + 1 by omega, pairsMem_succ]

@[mlir_transport]
public theorem Fits.pairsMem {mem : MemoryState} (h : Fits mem q w) :
    Fits (pairsMem X W p n mem) q w := by
  induction n generalizing p mem with
  | zero => exact h
  | succ n ih => exact ih h.storeAt

@[mlir_transport]
public theorem Room.pairsMem {mem : MemoryState} (h : Room mem q w) :
    Room (pairsMem X W p n mem) q w := by
  induction n generalizing p mem with
  | zero => exact h
  | succ n ih => exact ih h.storeAt

@[mlir_transport]
public theorem Live.pairsMem {mem : MemoryState} (h : Live mem q w) :
    Live (pairsMem X W p n mem) q w := by
  induction n generalizing p mem with
  | zero => exact h
  | succ n ih => exact ih h.storeAt

@[mlir_transport]
public theorem Writable.pairsMem {mem : MemoryState} (h : Writable mem q) :
    Writable (pairsMem X W p n mem) q := by
  induction n generalizing p mem with
  | zero => exact h
  | succ n ih => exact ih h.storeAt

@[mlir_transport]
public theorem InBounds.pairsMem {mem : MemoryState} (h : InBounds mem q w) :
    InBounds (pairsMem X W p n mem) q w := by
  induction n generalizing p mem with
  | zero => exact h
  | succ n ih => exact ih h.storeAt

/-- The ring buffer's stores keep every block, its length, lifetime and writability. -/
public theorem Room.pairsMem_iff {mem : MemoryState} :
    Room (compress512.pairsMem X W p n mem) q w ↔ Room mem q w := by
  induction n generalizing p mem with
  | zero => rfl
  | succ n ih => rw [pairsMem_succ, ih, Room.storeAt_iff]

/-- The ring buffer's stores keep every block and its length. -/
public theorem InBounds.pairsMem_iff {mem : MemoryState} :
    InBounds (compress512.pairsMem X W p n mem) q w ↔ InBounds mem q w := by
  induction n generalizing p mem with
  | zero => rfl
  | succ n ih => rw [pairsMem_succ, ih, InBounds.storeAt_iff]

@[mlir_transport]
public theorem MemoryState.Sha512Fit.pairsMem {mem : MemoryState} (h : mem.Sha512Fit q) :
    (pairsMem X W p n mem).Sha512Fit q := by
  induction n generalizing p mem with
  | zero => exact h
  | succ n ih => exact ih h.storeAt

@[mlir_transport]
public theorem GlobalState.WF.pairsMem {s : GlobalState} (h : s.WF) :
    ({ s with mem := pairsMem X W p n s.mem } : GlobalState).WF := by
  induction n generalizing p s with
  | zero => exact h
  | succ n ih => exact ih (s := { s with mem := _ }) h.storeAt

/-- A read of another block, past the ring buffer's stores. -/
@[mlir_read]
public theorem readAt_pairsMem_of_id_ne {mem : MemoryState} (h : X.id ≠ q.id) :
    (pairsMem X W p n mem).readAt q w = mem.readAt q w := by
  induction n generalizing p mem with
  | zero => rfl
  | succ n ih =>
    rw [pairsMem_succ, ih,
      MemoryState.readAt_storeAt_disjoint (Range.disjoint_of_id_ne (by simpa using h))]

/-- The ring buffer's stores are gone once its frame is erased. -/
@[mlir_frame, mlir_erase]
public theorem eraseFrom_pairsMem_of_le {mem : MemoryState} (h : B ≤ X.id.id) :
    (pairsMem X W p n mem).eraseFrom B = mem.eraseFrom B := by
  induction n generalizing p mem with
  | zero => rfl
  | succ n ih => rw [pairsMem_succ, ih, MemoryState.eraseFrom_storeAt_of_le (by simpa using h)]

/-- The ring buffer's window after storing pairs `p … p + n - 1`. -/
public theorem HoldsR.pairsMem {mem : MemoryState} {X : Pointer} {W : Nat → BitVec 64}
    (hX : X.offset = 0) (hf : Room mem X 1024) :
    ∀ {p n lo},
      lo ≤ 2 * p →
        2 * p ≤ lo + 16 →
        HoldsR mem X W lo (2 * p) →
        HoldsR (pairsMem X W p n mem) X W (max lo (2 * (p + n) - 16)) (2 * (p + n)) := by
  intro p n
  induction n generalizing p mem with
  | zero =>
    intro lo h1 h2 h
    rwa [show max lo (2 * (p + 0) - 16) = lo by omega]
  | succ n ih =>
    intro lo h1 h2 h
    rw [pairsMem_succ, show p + (n + 1) = p + 1 + n by omega]
    have :=
      ih hf.storeAt (p := p + 1) (lo := max lo (2 * p - 14)) (by omega) (by omega)
        (HoldsR.store hX hf h #v[wk W (2 * p), wk W (2 * p + 1)] rfl rfl)
    rwa [show max (max lo (2 * p - 14)) (2 * (p + 1 + n) - 16) = max lo (2 * (p + 1 + n) - 16) by
        omega] at
      this

/-- The buffer's eight pairs known: the buffer known. -/
public theorem fits_slots {m : MemoryState} {X : Pointer} (hX : X.offset = 0) (h0 : Fits m X 128)
    (h1 : Fits m (X.add 16#64) 128) (h2 : Fits m (X.add 32#64) 128) (h3 : Fits m (X.add 48#64) 128)
    (h4 : Fits m (X.add 64#64) 128) (h5 : Fits m (X.add 80#64) 128) (h6 : Fits m (X.add 96#64) 128)
    (h7 : Fits m (X.add 112#64) 128) : Fits m X 1024 := by
  have hov (k : BitVec 64) (hk : k.toNat < 128) : ¬X.offset.uaddOverflow k := by
    simp [BitVec.uaddOverflow, hX]; omega
  have a1 : Fits m X 256 := Fits.append (v := 128) (hov _ (by decide)) rfl rfl h0 h1
  have a2 : Fits m X 384 := Fits.append (v := 256) (hov _ (by decide)) rfl rfl a1 h2
  have a3 : Fits m X 512 := Fits.append (v := 384) (hov _ (by decide)) rfl rfl a2 h3
  have a4 : Fits m X 640 := Fits.append (v := 512) (hov _ (by decide)) rfl rfl a3 h4
  have a5 : Fits m X 768 := Fits.append (v := 640) (hov _ (by decide)) rfl rfl a4 h5
  have a6 : Fits m X 896 := Fits.append (v := 768) (hov _ (by decide)) rfl rfl a5 h6
  exact Fits.append (v := 896) (hov _ (by decide)) rfl rfl a6 h7

/-- `K`'s pairs past a store into another block. -/
public theorem KPairs.storeAt {m : MemoryState} {Kp q : Pointer} {x : BitVec w} (h : KPairs m Kp)
    (hne : q.id ≠ Kp.id) : KPairs (m.storeAt q x) Kp := fun k hk => by
  rw [MemoryState.readAt_storeAt_disjoint (Range.disjoint_of_id_ne (by simpa using hne))]
  exact h k hk

/-- `K`'s pairs past a lifetime marker. -/
public theorem KPairs.lifetimeStart {m : MemoryState} {Kp q : Pointer} (h : KPairs m Kp) :
    KPairs (m.lifetimeStart q) Kp := fun k hk => by
  rw [MemoryState.readAt_lifetimeStart]
  exact h k hk

/-- `K`'s pairs past a lifetime marker. -/
public theorem KPairs.lifetimeEnd {m : MemoryState} {Kp q : Pointer} (h : KPairs m Kp) :
    KPairs (m.lifetimeEnd q) Kp := fun k hk => by
  rw [MemoryState.readAt_lifetimeEnd]
  exact h k hk

/-- `K`'s pairs past the ring buffer's stores. -/
public theorem KPairs.pairsMem {m : MemoryState} {Kp X : Pointer} (h : KPairs m Kp)
    (hne : X.id ≠ Kp.id) : KPairs (pairsMem X W p n m) Kp := fun k hk => by
  rw [readAt_pairsMem_of_id_ne (by simpa using hne)]
  exact h k hk

/-- `load_data`'s `x[i] + K` on pair `q`: its words plus `K`. -/
public theorem load_y {W : Nat → BitVec 64} {q : Nat} {x y : Vector (BitVec 64) 2} {a b : BitVec 64}
    (hy : y = Vector.ofFn fun i => x[(i : Nat)] + [a, b][(i : Nat)]) (hx : x = xp W q)
    (ha : Sha512.K[2 * q]! = a) (hb : Sha512.K[2 * q + 1]! = b) :
    y = #v[wk W (2 * q), wk W (2 * q + 1)] := by
  subst hy hx ha hb
  ext l hl
  rcases l with _ | _ | l
  · simp [xp]
  · simp [xp]
  · omega

/-- A dynamic `getelementptr` by `k` elements of `stride` bytes from `c` bytes into a block. -/
public theorem gepDyn_slot_add {f : GepFlags} {X : Pointer} (hX : X.offset = 0) {c k stride : Nat}
    (h : c + k * stride < 2 ^ 63) (hk : k < 2 ^ 64) :
    Operation.gepDyn f 0 stride (.value (X.add (BitVec.ofNat 64 c))) (.value (BitVec.ofNat 64 k)) =
      .value (X.add (BitVec.ofNat 64 (c + k * stride))) := by
  have e : (BitVec.ofNat 64 k).toNat = k := by
    simp; omega
  have hc : (X.add (BitVec.ofNat 64 c)).offset.toNat = c := by
    simp [Pointer.add, hX]; omega
  rw [gepDyn_value
      (by
        rw [e]; omega)
      (.inr
        (by
          rw [e]; omega))
      (by
        simp only [BitVec.uaddOverflow, hc, e]; simp; omega),
    e, Nat.zero_add, Pointer.add_add, ← BitVec.ofNat_add]

/-! ## The second block's buffer -/

public theorem tMem_succ {X : Pointer} {W : Nat → BitVec 64} {p n : Nat} {mem : MemoryState} :
    tMem X W p (n + 1) mem =
      tMem X W (p + 1) n
        (mem.storeAt (X.add (BitVec.ofNat 64 (p * 16)))
          (BitVec.packLanes #v[wk W (2 * p), wk W (2 * p + 1)])) :=
  rfl

public theorem tMem_add {X : Pointer} {W : Nat → BitVec 64} {mem : MemoryState} :
    ∀ {p n n'}, tMem X W (p + n) n' (tMem X W p n mem) = tMem X W p (n + n') mem := by
  intro p n n'
  induction n generalizing p mem with
  | zero =>
    rw [Nat.add_zero, Nat.zero_add]; rfl
  | succ n ih =>
    rw [tMem_succ, show p + (n + 1) = p + 1 + n by omega, ih,
      show n + 1 + n' = (n + n') + 1 by omega, tMem_succ]

@[mlir_transport]
public theorem Fits.tMem {mem : MemoryState} (h : Fits mem q w) : Fits (tMem X W p n mem) q w := by
  induction n generalizing p mem with
  | zero => exact h
  | succ n ih => exact ih h.storeAt

@[mlir_transport]
public theorem Room.tMem {mem : MemoryState} (h : Room mem q w) : Room (tMem X W p n mem) q w := by
  induction n generalizing p mem with
  | zero => exact h
  | succ n ih => exact ih h.storeAt

@[mlir_transport]
public theorem Live.tMem {mem : MemoryState} (h : Live mem q w) : Live (tMem X W p n mem) q w := by
  induction n generalizing p mem with
  | zero => exact h
  | succ n ih => exact ih h.storeAt

@[mlir_transport]
public theorem Writable.tMem {mem : MemoryState} (h : Writable mem q) :
    Writable (tMem X W p n mem) q := by
  induction n generalizing p mem with
  | zero => exact h
  | succ n ih => exact ih h.storeAt

@[mlir_transport]
public theorem InBounds.tMem {mem : MemoryState} (h : InBounds mem q w) :
    InBounds (tMem X W p n mem) q w := by
  induction n generalizing p mem with
  | zero => exact h
  | succ n ih => exact ih h.storeAt

@[mlir_transport]
public theorem MemoryState.Sha512Fit.tMem {mem : MemoryState} (h : mem.Sha512Fit q) :
    (tMem X W p n mem).Sha512Fit q := by
  induction n generalizing p mem with
  | zero => exact h
  | succ n ih => exact ih h.storeAt

@[mlir_transport]
public theorem GlobalState.WF.tMem {s : GlobalState} (h : s.WF) :
    ({ s with mem := tMem X W p n s.mem } : GlobalState).WF := by
  induction n generalizing p s with
  | zero => exact h
  | succ n ih => exact ih (s := { s with mem := _ }) h.storeAt

@[mlir_read]
public theorem readAt_tMem_of_id_ne {mem : MemoryState} (h : X.id ≠ q.id) :
    (tMem X W p n mem).readAt q w = mem.readAt q w := by
  induction n generalizing p mem with
  | zero => rfl
  | succ n ih =>
    rw [tMem_succ, ih,
      MemoryState.readAt_storeAt_disjoint (Range.disjoint_of_id_ne (by simpa using h))]

@[mlir_frame, mlir_erase]
public theorem eraseFrom_tMem_of_le {mem : MemoryState} (h : B ≤ X.id.id) :
    (tMem X W p n mem).eraseFrom B = mem.eraseFrom B := by
  induction n generalizing p mem with
  | zero => rfl
  | succ n ih => rw [tMem_succ, ih, MemoryState.eraseFrom_storeAt_of_le (by simpa using h)]

/-- The buffer's words after storing pairs `p … p + n - 1` from word `2 p` on. -/
public theorem HoldsT.tMem {mem : MemoryState} {X : Pointer} {W : Nat → BitVec 64}
    (hX : X.offset = 0) (hf : Room mem X 5120) :
    ∀ {p n}, p + n ≤ 40 → HoldsT mem X W (2 * p) → HoldsT (tMem X W p n mem) X W (2 * (p + n)) := by
  intro p n
  induction n generalizing p mem with
  | zero =>
    intro _ h; exact h
  | succ n ih =>
    intro hp h
    rw [tMem_succ, show p + (n + 1) = p + 1 + n by omega]
    exact
      ih hf.storeAt (by omega)
        (HoldsT.store hX hf (by omega) h #v[wk W (2 * p), wk W (2 * p + 1)] rfl rfl)

/-- `K`'s pairs past the second block's stores. -/
public theorem KPairs.tMem {m : MemoryState} {Kp X : Pointer} (h : KPairs m Kp)
    (hne : X.id ≠ Kp.id) : KPairs (tMem X W p n m) Kp := fun k hk => by
  rw [readAt_tMem_of_id_ne (by simpa using hne)]
  exact h k hk

/-- `sha512_update_x_avx2` on the two blocks' schedule pairs `m …`: their pairs `m + 8`. -/
public theorem upd4_xq {W₀ W₁ : Nat → BitVec 64} (h₀ : Sched W₀) (h₁ : Sched W₁) {m : Nat}
    (hm : m < 32) :
    upd4 (xq W₀ W₁ m) (xq W₀ W₁ (m + 1)) (xq W₀ W₁ (m + 4)) (xq W₀ W₁ (m + 5)) (xq W₀ W₁ (m + 7)) =
      xq W₀ W₁ (m + 8) := by
  have a0 := congrArg (·[0]) (upd2_xp h₀ hm)
  have a1 := congrArg (·[1]) (upd2_xp h₀ hm)
  have b0 := congrArg (·[0]) (upd2_xp h₁ hm)
  have b1 := congrArg (·[1]) (upd2_xp h₁ hm)
  simp only [upd2, xp, Vector.getElem_mk, List.getElem_toArray, List.getElem_cons_succ,
    List.getElem_cons_zero] at a0 a1 b0 b1
  simp only [upd4, xq, Vector.getElem_mk, List.getElem_toArray, List.getElem_cons_succ,
    List.getElem_cons_zero, a0, a1, b0, b1]

/-- A store into another block commutes with the ring buffer's stores. -/
public theorem pairsMem_storeAt_comm {mem : MemoryState} {X q : Pointer} {x : BitVec w}
    (h : q.id ≠ X.id) :
    pairsMem X W p n (mem.storeAt q x) = (pairsMem X W p n mem).storeAt q x := by
  induction n generalizing p mem with
  | zero => rfl
  | succ n ih =>
    rw [pairsMem_succ, pairsMem_succ, ← ih,
      MemoryState.storeAt_comm (Range.disjoint_of_id_ne (by simpa using h))]

/-- `ylo` of the two blocks' pair `p` and its `K`: the first block's words plus `K`. -/
public theorem ylo_xq (W₀ W₁ : Nat → BitVec 64) (p : Nat) :
    ylo (xq W₀ W₁ p) Sha512.K[2 * p]! Sha512.K[2 * p + 1]! = #v[wk W₀ (2 * p), wk W₀ (2 * p + 1)] :=
  rfl

/-- `yhi` of the two blocks' pair `p` and its `K`: the second block's words plus `K`. -/
public theorem yhi_xq (W₀ W₁ : Nat → BitVec 64) (p : Nat) :
    yhi (xq W₀ W₁ p) Sha512.K[2 * p]! Sha512.K[2 * p + 1]! = #v[wk W₁ (2 * p), wk W₁ (2 * p + 1)] :=
  rfl

public theorem byte_of {D : BitVec 1024} {s a : Nat} (h : a + 8 ≤ 64) (hs : s + 64 ≤ 1024) (k : Nat)
    (hk : k = (s + a) / 8) (h8 : (s + a) % 8 = 0) :
    (D.extractLsb' s 64).extractLsb' a 8 = (bytesLE D)[k]! := by
  rw [getElem!_bytesLE _ (by omega)]
  apply BitVec.eq_of_getLsbD_eq
  intro j hj
  simp only [BitVec.getLsbD_extractLsb', hj, decide_true, Bool.true_and]
  rw [decide_eq_true (show a + j < 64 by omega), Bool.true_and]
  congr 1
  omega

/-- A 64-bit lane's bytes, the lowest first and most significant: a block's big-endian word. -/
public theorem lane_word {D : BitVec 1024} {t : Nat} (ht : t < 16) :
    (D.extractLsb' (64 * t) 64).extractLsb' 0 8 ++ (D.extractLsb' (64 * t) 64).extractLsb' 8 8 ++
        (D.extractLsb' (64 * t) 64).extractLsb' 16 8 ++
        (D.extractLsb' (64 * t) 64).extractLsb' 24 8 ++
        (D.extractLsb' (64 * t) 64).extractLsb' 32 8 ++
        (D.extractLsb' (64 * t) 64).extractLsb' 40 8 ++
        (D.extractLsb' (64 * t) 64).extractLsb' 48 8 ++
        (D.extractLsb' (64 * t) 64).extractLsb' 56 8 =
      Sha512.word (bytesLE D) t := by
  simp only [Sha512.word]
  rw [byte_of (k := 8 * t) (by omega) (by omega) (by omega) (by omega),
    byte_of (k := 8 * t + 1) (by omega) (by omega) (by omega) (by omega),
    byte_of (k := 8 * t + 2) (by omega) (by omega) (by omega) (by omega),
    byte_of (k := 8 * t + 3) (by omega) (by omega) (by omega) (by omega),
    byte_of (k := 8 * t + 4) (by omega) (by omega) (by omega) (by omega),
    byte_of (k := 8 * t + 5) (by omega) (by omega) (by omega) (by omega),
    byte_of (k := 8 * t + 6) (by omega) (by omega) (by omega) (by omega),
    byte_of (k := 8 * t + 7) (by omega) (by omega) (by omega) (by omega)]

public theorem ext_ext {w : Nat} (X : BitVec w) {a v b u : Nat} (h : b + u ≤ v) :
    (X.extractLsb' a v).extractLsb' b u = X.extractLsb' (a + b) u := by
  apply BitVec.eq_of_getLsbD_eq
  intro j hj
  simp only [BitVec.getLsbD_extractLsb', hj, decide_true, Bool.true_and]
  rw [decide_eq_true (show b + j < v by omega), Bool.true_and, Nat.add_assoc]

/-- `load_data_avx2`'s lanes of pair `q` of the two blocks at `X`: the 128-bit loads `XL`, `XH` of
both blocks combined, byte-swapped by 64-bit lanes. -/
public theorem load_lanes4 {X : BitVec 2048} {XL XH : BitVec 128} {lo hi : Vector (BitVec 64) 2}
    {c x : Vector (BitVec 64) 4} {b s : Vector (BitVec 8) 32}
    (hlo : lo = Vector.ofFn fun i => Ty.extractVecElem 2 64 i XL)
    (hhi : hi = Vector.ofFn fun i => Ty.extractVecElem 2 64 i XH)
    (hc : c = #v[lo[0], lo[1], hi[0], hi[1]])
    (hb :
      b =
        #v[BitVec.extractLsb' 0 8 c[0], BitVec.extractLsb' 8 8 c[0], BitVec.extractLsb' 16 8 c[0],
          BitVec.extractLsb' 24 8 c[0], BitVec.extractLsb' 32 8 c[0], BitVec.extractLsb' 40 8 c[0],
          BitVec.extractLsb' 48 8 c[0], BitVec.extractLsb' 56 8 c[0], BitVec.extractLsb' 0 8 c[1],
          BitVec.extractLsb' 8 8 c[1], BitVec.extractLsb' 16 8 c[1], BitVec.extractLsb' 24 8 c[1],
          BitVec.extractLsb' 32 8 c[1], BitVec.extractLsb' 40 8 c[1], BitVec.extractLsb' 48 8 c[1],
          BitVec.extractLsb' 56 8 c[1], BitVec.extractLsb' 0 8 c[2], BitVec.extractLsb' 8 8 c[2],
          BitVec.extractLsb' 16 8 c[2], BitVec.extractLsb' 24 8 c[2], BitVec.extractLsb' 32 8 c[2],
          BitVec.extractLsb' 40 8 c[2], BitVec.extractLsb' 48 8 c[2], BitVec.extractLsb' 56 8 c[2],
          BitVec.extractLsb' 0 8 c[3], BitVec.extractLsb' 8 8 c[3], BitVec.extractLsb' 16 8 c[3],
          BitVec.extractLsb' 24 8 c[3], BitVec.extractLsb' 32 8 c[3], BitVec.extractLsb' 40 8 c[3],
          BitVec.extractLsb' 48 8 c[3], BitVec.extractLsb' 56 8 c[3]])
    (hs :
      s =
        #v[b[7], b[6], b[5], b[4], b[3], b[2], b[1], b[0], b[15], b[14], b[13], b[12], b[11], b[10],
          b[9], b[8], b[23], b[22], b[21], b[20], b[19], b[18], b[17], b[16], b[31], b[30], b[29],
          b[28], b[27], b[26], b[25], b[24]])
    (hx :
      x =
        #v[s[7] ++ s[6] ++ s[5] ++ s[4] ++ s[3] ++ s[2] ++ s[1] ++ s[0],
          s[15] ++ s[14] ++ s[13] ++ s[12] ++ s[11] ++ s[10] ++ s[9] ++ s[8],
          s[23] ++ s[22] ++ s[21] ++ s[20] ++ s[19] ++ s[18] ++ s[17] ++ s[16],
          s[31] ++ s[30] ++ s[29] ++ s[28] ++ s[27] ++ s[26] ++ s[25] ++ s[24]])
    {q : Nat} (hq : q < 8) (hXL : XL = X.extractLsb' (128 * q) 128)
    (hXH : XH = X.extractLsb' (1024 + 128 * q) 128) :
    x = xq (bsched (X.extractLsb' 0 1024)) (bsched (X.extractLsb' 1024 1024)) q := by
  have hc0 : c[0] = (X.extractLsb' 0 1024).extractLsb' (64 * (2 * q)) 64 := by
    rw [hc, hlo, hXL];
    simp only [Vector.getElem_mk, List.getElem_toArray, List.getElem_cons_zero, Vector.getElem_ofFn,
      Ty.extractVecElem_eq]
    rw [ext_ext _ (by decide), ext_ext _ (by omega)]; congr 1; omega
  have hc1 : c[1] = (X.extractLsb' 0 1024).extractLsb' (64 * (2 * q + 1)) 64 := by
    rw [hc, hlo, hXL];
    simp only [Vector.getElem_mk, List.getElem_toArray, List.getElem_cons_zero,
      List.getElem_cons_succ, Vector.getElem_ofFn, Ty.extractVecElem_eq]
    rw [ext_ext _ (by decide), ext_ext _ (by omega)]; congr 1; simp; omega
  have hc2 : c[2] = (X.extractLsb' 1024 1024).extractLsb' (64 * (2 * q)) 64 := by
    rw [hc, hhi, hXH];
    simp only [Vector.getElem_mk, List.getElem_toArray, List.getElem_cons_zero,
      List.getElem_cons_succ, Vector.getElem_ofFn, Ty.extractVecElem_eq]
    rw [ext_ext _ (by decide), ext_ext _ (by omega)]; congr 1; simp; omega
  have hc3 : c[3] = (X.extractLsb' 1024 1024).extractLsb' (64 * (2 * q + 1)) 64 := by
    rw [hc, hhi, hXH];
    simp only [Vector.getElem_mk, List.getElem_toArray, List.getElem_cons_zero,
      List.getElem_cons_succ, Vector.getElem_ofFn, Ty.extractVecElem_eq]
    rw [ext_ext _ (by decide), ext_ext _ (by omega)]; congr 1; simp; omega
  clear hc hlo hhi hXL hXH
  subst hx hs hb
  simp only [Vector.getElem_mk, List.getElem_toArray, List.getElem_cons_succ,
    List.getElem_cons_zero]
  simp only [hc0, hc1, hc2, hc3]
  simp only [xq, bsched, Sha512.getElem!_schedule_lt _ (show 2 * q < 16 by omega),
    Sha512.getElem!_schedule_lt _ (show 2 * q + 1 < 16 by omega)]
  congr 2
  simp only [List.cons.injEq, and_true]
  exact
    ⟨lane_word (D := X.extractLsb' 0 1024) (t := 2 * q) (by omega),
      lane_word (D := X.extractLsb' 0 1024) (t := 2 * q + 1) (by omega),
      lane_word (D := X.extractLsb' 1024 1024) (t := 2 * q) (by omega),
      lane_word (D := X.extractLsb' 1024 1024) (t := 2 * q + 1) (by omega)⟩

/-- `load_data_avx2`'s `x[i] + K` on pair `q`, its first block's lanes. -/
public theorem load_ylo {W₀ W₁ : Nat → BitVec 64} {q : Nat} {x y : Vector (BitVec 64) 4}
    {lo : Vector (BitVec 64) 2} {a b : BitVec 64}
    (hy : y = Vector.ofFn fun i => x[(i : Nat)] + [a, b, a, b][(i : Nat)]) (hx : x = xq W₀ W₁ q)
    (ha : Sha512.K[2 * q]! = a) (hb : Sha512.K[2 * q + 1]! = b) (hlo : lo = #v[y[0], y[1]]) :
    lo = #v[wk W₀ (2 * q), wk W₀ (2 * q + 1)] := by
  subst hlo hy hx ha hb
  simp [xq]

/-- `load_data_avx2`'s `x[i] + K` on pair `q`, its second block's lanes. -/
public theorem load_yhi {W₀ W₁ : Nat → BitVec 64} {q : Nat} {x y : Vector (BitVec 64) 4}
    {hi : Vector (BitVec 64) 2} {a b : BitVec 64}
    (hy : y = Vector.ofFn fun i => x[(i : Nat)] + [a, b, a, b][(i : Nat)]) (hx : x = xq W₀ W₁ q)
    (ha : Sha512.K[2 * q]! = a) (hb : Sha512.K[2 * q + 1]! = b) (hhi : hi = #v[y[2], y[3]]) :
    hi = #v[wk W₁ (2 * q), wk W₁ (2 * q + 1)] := by
  subst hhi hy hx ha hb
  simp [xq]

/-- The second block's buffer, all its pairs stored: known. -/
public theorem fits_tMem {mem : MemoryState} {X : Pointer} {W : Nat → BitVec 64} (hX : X.offset = 0)
    (h : Room mem X 5120) : ∀ n, n < 40 → Fits (tMem X W 0 (n + 1) mem) X (128 * (n + 1)) := by
  intro n
  induction n with
  | zero =>
    intro _
    have e : X.add (BitVec.ofNat 64 (0 * 16)) = X := by simp only [Nat.zero_mul, Pointer.add_zero']
    rw [tMem_succ, e]
    exact Fits.storeAt_self (Room.mono (by decide) h)
  | succ n ih =>
    intro hn
    rw [← tMem_add (n := n + 1) (n' := 1), Nat.zero_add, tMem_succ]
    have hr : Room (tMem X W 0 (n + 1) mem) (X.add (BitVec.ofNat 64 ((n + 1) * 16))) 128 :=
      Room.add_of_le
        (by
          simp [BitVec.uaddOverflow, hX]; omega)
        (by
          simp; omega)
        (Room.tMem h)
    exact
      Fits.append (v := 128 * (n + 1)) (off := BitVec.ofNat 64 ((n + 1) * 16))
        (by
          simp [BitVec.uaddOverflow, hX]; omega)
        (by
          simp; omega)
        (by omega) (ih (by omega)).storeAt (Fits.storeAt_self hr)

/-- The ring buffer, its first eight pairs stored: known. -/
public theorem fits_pairsMem {mem : MemoryState} {X : Pointer} {W : Nat → BitVec 64}
    (hX : X.offset = 0) (h : Room mem X 1024) :
    ∀ n, n < 8 → Fits (pairsMem X W 0 (n + 1) mem) X (128 * (n + 1)) := by
  intro n
  induction n with
  | zero =>
    intro _
    have e : X.add (BitVec.ofNat 64 (0 % 8 * 16)) = X := by
      simp only [Nat.zero_mod, Nat.zero_mul, Pointer.add_zero']
    rw [pairsMem_succ, e]
    exact Fits.storeAt_self (Room.mono (by decide) h)
  | succ n ih =>
    intro hn
    rw [← pairsMem_add (n := n + 1) (n' := 1), Nat.zero_add, pairsMem_succ,
      show (n + 1) % 8 * 16 = (n + 1) * 16 by omega]
    have hr : Room (pairsMem X W 0 (n + 1) mem) (X.add (BitVec.ofNat 64 ((n + 1) * 16))) 128 :=
      Room.add_of_le
        (by
          simp [BitVec.uaddOverflow, hX]; omega)
        (by
          simp; omega)
        (Room.pairsMem h)
    exact
      Fits.append (v := 128 * (n + 1)) (off := BitVec.ofNat 64 ((n + 1) * 16))
        (by
          simp [BitVec.uaddOverflow, hX]; omega)
        (by
          simp; omega)
        (by omega) (ih (by omega)).storeAt (Fits.storeAt_self hr)

public theorem ofNat_add_neg_one (r : Nat) :
    BitVec.ofNat 64 (r + 1) + 18446744073709551615#64 = BitVec.ofNat 64 r := by
  rw [BitVec.ofNat_add]
  generalize BitVec.ofNat 64 r = x
  bv_decide

end MLIR.Agave.Avx2.compress512
