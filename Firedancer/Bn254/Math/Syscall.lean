module

public import Firedancer.Bn254.Syscall
public import Firedancer.Bn254.Math.Bytes
public import Firedancer.Bn254.Math.ScalarMul
import Std.Tactic.BVDecide
meta import Std.Tactic.BVDecide.Reflect

/-! The G1 syscalls against Agave (`solana-bn254` 3.2.1 on arkworks 0.5): byte formats, padding,
flags, range and curve checks, infinity encoding, errors. `fd_bn254_g1_{add,scalar_mul}_syscall`
(both builds) and `fd_bn254_g1_{compress,decompress}` compute these specs. -/

namespace Firedancer.Bn254

open Jac WeierstrassCurve WeierstrassCurve.Affine

/-! ## The specification

Agave decodes with arkworks `Compress::No`, `Validate::Yes` (add, mul) or `Validate::No`
(compress, decompress). Coordinates are big- or little-endian; the top two bits of `y` (or of
compressed `x`) are flags: infinity `0x40` (whatever the coordinates), negative `0x80` (ignored
when uncompressed); both is an error. Masked coordinates must be `< p`. All-zero input is
infinity. -/

@[expose] public section

/-- Agave's uncompressed G1 decoding, with the curve check `y² = x³ + 3`. -/
def decodeG1 (be : Bool) (b : Vector (BitVec 8) 64) : Option ECPoint :=
  if b = Vector.replicate 64 0 then some 0
  else
    let x := bytesToNat be (loadBytes b 0 32)
    let fl := flagByte be (loadBytes b 32 32)
    let y := bytesToNat be (loadBytes b 32 32) % 2 ^ 254
    if p_bn254 ≤ x ∨ (fl &&& FLAG_INF ≠ 0 ∧ fl &&& FLAG_NEG ≠ 0) ∨ p_bn254 ≤ y then none
    else
      if fl &&& FLAG_INF ≠ 0 then some 0
      else
        if h : (y : ZMod p_bn254) ^ 2 = (x : ZMod p_bn254) ^ 3 + 3 then
          some (.some (x : ZMod p_bn254) (y : ZMod p_bn254) (nonsingular_of_eqn h3 h))
        else none

/-- Agave's uncompressed G1 encoding: `x ‖ y` without flags, infinity as 64 zero bytes. -/
def encodeG1 (be : Bool) : ECPoint → Vector (BitVec 8) 64
  | .zero => Vector.replicate 64 0
  | .some x y _ => natToBytes be x.val ++ natToBytes be y.val

/-- `input` zero-padded (or truncated) to `m` bytes. -/
def padTo {n : ℕ} (m : ℕ) (input : Vector (BitVec 8) n) : Vector (BitVec 8) m :=
  Vector.ofFn fun j => if h : j.val < n then input[j.val] else 0

/-- `alt_bn128_versioned_g1_addition`: `P + Q`, from at most 128 zero-padded bytes. -/
def g1Add (be : Bool) {n : ℕ} (input : Vector (BitVec 8) n) : Option (Vector (BitVec 8) 64) :=
  if 128 < n ∨ (be = false ∧ n ≠ 128) then none
  else
    let buf := padTo 128 input
    match decodeG1 be (loadBytes buf 0 64), decodeG1 be (loadBytes buf 64 64) with
    | some P, some Q => some (encodeG1 be (P + Q))
    | _, _ => none

/-- `alt_bn128_versioned_g1_multiplication` V1: `s • P` for the unreduced 256-bit scalar `s`. -/
def g1Mul (be : Bool) {n : ℕ} (input : Vector (BitVec 8) n) : Option (Vector (BitVec 8) 64) :=
  if 96 < n ∨ (be = false ∧ n ≠ 96) then none
  else
    let buf := padTo 96 input
    match decodeG1 be (loadBytes buf 0 64) with
    | some P => some (encodeG1 be (bytesToNat be (loadBytes buf 64 32) • P))
    | none => none

/-- ORs `f` into the most significant byte of a 32-byte encoding. -/
def orFlag (be : Bool) (b : Vector (BitVec 8) 32) (f : BitVec 8) : Vector (BitVec 8) 32 :=
  if be then b.set 0 (b[0] ||| f) else b.set 31 (b[31] ||| f)

/-- `alt_bn128_apply_g1_compress`: no curve check; `x` flagged infinity or `y > (p-1)/2`. -/
def g1Compress (be : Bool) (input : Vector (BitVec 8) 64) : Option (Vector (BitVec 8) 32) :=
  if input = Vector.replicate 64 0 then some (Vector.replicate 32 0)
  else
    let x := bytesToNat be (loadBytes input 0 32)
    let fl := flagByte be (loadBytes input 32 32)
    let y := bytesToNat be (loadBytes input 32 32) % 2 ^ 254
    if p_bn254 ≤ x ∨ (fl &&& FLAG_INF ≠ 0 ∧ fl &&& FLAG_NEG ≠ 0) ∨ p_bn254 ≤ y then none
    else
      if fl &&& FLAG_INF ≠ 0 then some (orFlag be (Vector.replicate 32 0) FLAG_INF)
      else some (orFlag be (natToBytes be x) (if p_bn254 / 2 < y then FLAG_NEG else 0))

/-- The square root of `a` whose sign (`> (p-1)/2`) is `neg`, if `a` is a square. -/
noncomputable def sqrtSigned (a : ZMod p_bn254) (neg : Bool) : Option (ZMod p_bn254) :=
  if h : IsSquare a then
    let w := Classical.choose h
    some (if decide (p_bn254 / 2 < w.val) = neg then w else -w)
  else none

/-- `alt_bn128_apply_g1_decompress`: the `y` of the flagged sign with `y² = x³ + 3`. -/
noncomputable def g1Decompress (be : Bool) (input : Vector (BitVec 8) 32) :
    Option (Vector (BitVec 8) 64) :=
  if input = Vector.replicate 32 0 then some (Vector.replicate 64 0)
  else
    let fl := flagByte be input
    let x := bytesToNat be input % 2 ^ 254
    if (fl &&& FLAG_INF ≠ 0 ∧ fl &&& FLAG_NEG ≠ 0) ∨ p_bn254 ≤ x then none
    else
      if fl &&& FLAG_INF ≠ 0 then some (Vector.replicate 64 0)
      else
        match sqrtSigned ((x : ZMod p_bn254) ^ 3 + 3) (fl &&& FLAG_NEG ≠ 0) with
        | none => none
        | some y => some (natToBytes be x ++ natToBytes be y.val)

end

/-! ## Decoding -/

theorem memeq_ne_zero {n : ℕ} (a b : Vector (BitVec 8) n) : fd_memeq a b ≠ 0 ↔ a = b := by
  unfold fd_memeq; split_ifs with h <;> simp [h]

theorem one32_ne : (1 : BitVec 32) ≠ 0 := by decide

/-- `frombytes_internal`: zero for all-zero input, `NULL` on a range or flag error, zero for the
infinity flag, else the plain coordinates with `Z` Montgomery one. -/
theorem internal_spec (p : fd_bn254_g1_t) (in_ : Vector (BitVec 8) 64) (be : BitVec 32) :
    let res := fd_bn254_g1_frombytes_internal.spec p in_ be
    let X := bytesToNat (be ≠ 0) (loadBytes in_ 0 32)
    let fl := flagByte (be ≠ 0) (loadBytes in_ 32 32)
    let Y := bytesToNat (be ≠ 0) (loadBytes in_ 32 32) % 2 ^ 254
    if in_ = Vector.replicate 64 0 then res.ret = some res.p ∧ limbsEval res.p.Z = 0
    else
      if p_bn254 ≤ X ∨ (fl &&& FLAG_INF ≠ 0 ∧ fl &&& FLAG_NEG ≠ 0) ∨ p_bn254 ≤ Y then res.ret = none
      else
        res.ret = some res.p ∧
          if fl &&& FLAG_INF ≠ 0 then limbsEval res.p.Z = 0
          else
            limbsEval res.p.X = X ∧ limbsEval res.p.Y = Y ∧ res.p.Z = fd_bn254_const_one_mont := by
  intro res X fl Y
  simp only [res, fd_bn254_g1_frombytes_internal.spec]
  by_cases hz : in_ = Vector.replicate 64 0
  · rw [ite_eq_left ((memeq_ne_zero _ _).mpr hz), ite_eq_left hz]
    exact ⟨rfl, limbsEval_set_zero⟩
  rw [ite_eq_right (fun h => hz ((memeq_ne_zero _ _).mp h)), ite_eq_right hz]
  obtain ⟨-, hx1, hx2⟩ := fd_bn254_fp_frombytes_nm.val p.X (loadBytes in_ 0 32) be none
  simp only [Option.isSome_none, Bool.false_eq_true, ↓reduceIte, false_and, false_or] at hx1 hx2
  rcases hxr : (fd_bn254_fp_frombytes_nm.spec p.X (loadBytes in_ 0 32) be none).ret with _ | qx
  · rw [ite_eq_left (.inl (hx1.mp hxr))]
  have hX : X < p_bn254 := by
    by_contra hc; rw [hx1.mpr (not_lt.mp hc)] at hxr; cases hxr
  obtain ⟨hxq, hxv⟩ := hx2 qx hxr
  simp only
  obtain ⟨hy0, hy1, hy2⟩ :=
    fd_bn254_fp_frombytes_nm.val
      ({ p with X := (fd_bn254_fp_frombytes_nm.spec p.X (loadBytes in_ 0 32) be none).r }).Y
      (loadBytes in_ 32 32) be (some (0, 0))
  simp only [Option.isSome_some, ↓reduceIte, true_and, Option.map_some] at hy0 hy1 hy2
  rcases hyr :
    (fd_bn254_fp_frombytes_nm.spec
        ({ p with X := (fd_bn254_fp_frombytes_nm.spec p.X (loadBytes in_ 0 32) be none).r }).Y
        (loadBytes in_ 32 32) be (some (0, 0))).ret with
    _ | qy
  · rw [ite_eq_left
        (by
          rcases hy1.mp hyr with h | h; exacts [.inr (.inl h), .inr (.inr h)])]
    simp only [hyr]
  have hY : ¬((fl &&& FLAG_INF ≠ 0 ∧ fl &&& FLAG_NEG ≠ 0) ∨ p_bn254 ≤ Y) := fun h => by
    rw [hy1.mpr h] at hyr; cases hyr
  obtain ⟨hyq, hyv⟩ := hy2 qy hyr
  simp only [hyr, hy0, Option.getD_some]
  rw [ite_eq_right
      (by
        rintro (h | h); omega; exact hY h)]
  by_cases hinf : fl &&& FLAG_INF ≠ 0
  · have hfl :
      (if flagByte (be ≠ 0) (loadBytes in_ 32 32) &&& FLAG_INF ≠ 0 then (1 : BitVec 32) else 0) ≠
        0 := by
      rw [ite_eq_left hinf]; exact one32_ne
    rw [ite_eq_left hfl, ite_eq_left hinf]
    exact ⟨rfl, limbsEval_set_zero⟩
  · have hfl :
      ¬(if flagByte (be ≠ 0) (loadBytes in_ 32 32) &&& FLAG_INF ≠ 0 then (1 : BitVec 32) else 0) ≠
          0 := by
      rw [ite_eq_right hinf]; simp
    rw [ite_eq_right hfl, ite_eq_right hinf]
    dsimp only
    exact ⟨rfl, by rw [hxq, hxv], by rw [hyq, hyv], fd_bn254_fp_set_one.spec_eq⟩

public theorem flag_inf_eq : FLAG_INF = 0x40 :=
  rfl

public theorem flag_neg_eq : FLAG_NEG = 0x80 :=
  rfl

/-- `frombytes_check_subgroup` decodes as Agave: `NULL` exactly when `decodeG1` fails, else an
affine representative of the decoded point. -/
public theorem check_subgroup_rep (p : fd_bn254_g1_t) (in_ : Vector (BitVec 8) 64)
    (be : BitVec 32) :
    match decodeG1 (be ≠ 0) in_ with
    | none => (fd_bn254_g1_frombytes_check_subgroup.spec p in_ be).ret = none
    | some P =>
      (fd_bn254_g1_frombytes_check_subgroup.spec p in_ be).ret =
          some (fd_bn254_g1_frombytes_check_subgroup.spec p in_ be).p ∧
        ARep (fd_bn254_g1_frombytes_check_subgroup.spec p in_ be).p P := by
  have hi := internal_spec p in_ be
  simp only [fd_bn254_g1_frombytes_check_subgroup.spec]
  generalize fd_bn254_g1_frombytes_internal.spec p in_ be = res at hi ⊢
  unfold decodeG1
  dsimp only
  by_cases hz : in_ = Vector.replicate 64 0
  · rw [ite_eq_left hz] at hi
    simp only [hz, ↓reduceIte]
    obtain ⟨hr, hZ⟩ := hi
    have hp0 := PRep.zero_of_z hZ
    simp only [hr, ite_eq_left ((hp0.is_zero_iff).mpr rfl)]
    exact ⟨trivial, hp0, fun h => absurd rfl h⟩
  rw [ite_eq_right hz] at hi
  simp only [hz, ↓reduceIte]
  by_cases herr :
    p_bn254 ≤ bytesToNat (be ≠ 0) (loadBytes in_ 0 32) ∨
      (flagByte (be ≠ 0) (loadBytes in_ 32 32) &&& FLAG_INF ≠ 0 ∧
        flagByte (be ≠ 0) (loadBytes in_ 32 32) &&& FLAG_NEG ≠ 0) ∨
      p_bn254 ≤ bytesToNat (be ≠ 0) (loadBytes in_ 32 32) % 2 ^ 254
  · rw [ite_eq_left herr] at hi
    simp only [herr, ↓reduceIte, hi]
  rw [ite_eq_right herr] at hi
  obtain ⟨hr, hp⟩ := hi
  simp only [herr, ↓reduceIte, hr]
  by_cases hinf : flagByte (be ≠ 0) (loadBytes in_ 32 32) &&& FLAG_INF ≠ 0
  · rw [ite_eq_left hinf] at hp
    have hp0 := PRep.zero_of_z hp
    rw [ite_eq_left hinf]
    simp only [ite_eq_left ((hp0.is_zero_iff).mpr rfl)]
    exact ⟨trivial, hp0, fun h => absurd rfl h⟩
  rw [ite_eq_right hinf] at hp
  obtain ⟨hpx, hpy, hpz⟩ := hp
  have hX : bytesToNat (be ≠ 0) (loadBytes in_ 0 32) < p_bn254 := by omega
  have hY : bytesToNat (be ≠ 0) (loadBytes in_ 32 32) % 2 ^ 254 < p_bn254 := by omega
  have hnz : ¬fd_bn254_g1_is_zero.spec res.p ≠ 0 := by
    rw [fd_bn254_g1_is_zero.spec, hpz, fd_bn254_fp_is_zero.spec_iff fd_bn254_const_one_mont.tr]
    exact one_ne_zero
  rw [ite_eq_right hinf]
  simp only [hnz, ↓reduceIte]
  have tX :=
    fd_bn254_fp_to_mont.tr (x := res.p.X)
      (by
        rw [hpx]; exact hX)
  have tY :=
    fd_bn254_fp_to_mont.tr (x := res.p.Y)
      (by
        rw [hpy]; exact hY)
  rw [hpx] at tX
  rw [hpy] at tY
  have hlhs := fd_bn254_fp_sqr.tr tY
  have hrhs :=
    fd_bn254_fp_add.tr (fd_bn254_fp_mul.tr (fd_bn254_fp_sqr.tr tX) tX) fd_bn254_const_b_mont.tr
  have heq := fd_bn254_fp_eq.spec_iff hlhs hrhs
  by_cases hc :
    ((bytesToNat (be ≠ 0) (loadBytes in_ 32 32) % 2 ^ 254 : ℕ) : ZMod p_bn254) ^ 2 =
      ((bytesToNat (be ≠ 0) (loadBytes in_ 0 32) : ℕ) : ZMod p_bn254) ^ 3 + 3
  · have hc' :
      ((bytesToNat (be ≠ 0) (loadBytes in_ 32 32) % 2 ^ 254 : ℕ) : ZMod p_bn254) ^ 2 =
        ((bytesToNat (be ≠ 0) (loadBytes in_ 0 32) : ℕ) : ZMod p_bn254) ^ 2 *
            ((bytesToNat (be ≠ 0) (loadBytes in_ 0 32) : ℕ) : ZMod p_bn254) +
          3 := by
      rw [hc]; ring
    rw [dite_eq_left hc, ite_eq_right (fun h => (heq.mpr hc') h)]
    exact ⟨rfl, ARep.of_xyz _ tX tY fd_bn254_fp_set_one.spec_eq⟩
  · have hc' :
      ¬((bytesToNat (be ≠ 0) (loadBytes in_ 32 32) % 2 ^ 254 : ℕ) : ZMod p_bn254) ^ 2 =
          ((bytesToNat (be ≠ 0) (loadBytes in_ 0 32) : ℕ) : ZMod p_bn254) ^ 2 *
              ((bytesToNat (be ≠ 0) (loadBytes in_ 0 32) : ℕ) : ZMod p_bn254) +
            3 := by
      rw [← pow_succ]; exact hc
    rw [dite_eq_right hc, ite_eq_left (not_not.mp (mt heq.mp hc'))]

public theorem check_subgroup_none {p : fd_bn254_g1_t} {in_ : Vector (BitVec 8) 64} {be : BitVec 32}
    (h : decodeG1 (be ≠ 0) in_ = none) :
    (fd_bn254_g1_frombytes_check_subgroup.spec p in_ be).ret = none := by
  have := check_subgroup_rep p in_ be
  rw [h] at this; exact this

public theorem check_subgroup_some {p : fd_bn254_g1_t} {in_ : Vector (BitVec 8) 64} {be : BitVec 32}
    {P : ECPoint} (h : decodeG1 (be ≠ 0) in_ = some P) :
    (fd_bn254_g1_frombytes_check_subgroup.spec p in_ be).ret =
        some (fd_bn254_g1_frombytes_check_subgroup.spec p in_ be).p ∧
      ARep (fd_bn254_g1_frombytes_check_subgroup.spec p in_ be).p P := by
  have := check_subgroup_rep p in_ be
  rw [h] at this; exact this

/-! ## Encoding -/

theorem limbsEval_of_cast {a : fd_bn254_fp_t} {x : ZMod p_bn254} (ha : fpCanon a)
    (h : (limbsEval a : ZMod p_bn254) = x) : limbsEval a = x.val := by
  rw [← h, ZMod.val_cast_of_lt ha]

variable {B : Backend}

/-- `g1_tobytes` of a representative of `P` is Agave's encoding of `P`. -/
public theorem fd_bn254_g1_tobytes.spec_eq (hB : B.Spec) {p : fd_bn254_g1_t} {P : ECPoint}
    (hp : PRep p P) (be : BitVec 32) : fd_bn254_g1_tobytes.spec B p be = encodeG1 (be ≠ 0) P := by
  rw [fd_bn254_g1_tobytes.spec]
  cases P with
  | zero =>
    rw [ite_eq_left (hp.is_zero_iff.mpr rfl)]; rfl
  | some x y h =>
    rw [ite_eq_right (mt hp.is_zero_iff.mp (Point.some_ne_zero h))]
    obtain ⟨tx, ty⟩ := fd_bn254_g1_to_affine.tr hB hp
    obtain ⟨cx, vx⟩ := fd_bn254_fp_from_mont.val tx
    obtain ⟨cy, vy⟩ := fd_bn254_fp_from_mont.val ty
    dsimp only
    rw [fd_bn254_fp_tobytes_nm.buf_eq, fd_bn254_fp_tobytes_nm.buf_eq, limbsEval_of_cast cx vx,
      limbsEval_of_cast cy vy]
    rfl

/-! ## The syscalls -/

theorem memcpy_pad {n : ℕ} (m : ℕ) (in_ : Vector (BitVec 8) n) (_h : n ≤ m) :
    memcpyBytes (Vector.replicate m 0) in_ n = padTo m in_ := by
  ext j hj
  simp only [memcpyBytes, padTo, Vector.getElem_ofFn]
  by_cases hjn : j < n
  · simp [hjn]
  · simp [hjn]

/-- `fd_bn254_g1_add_syscall` (either build) is Agave's G1 addition: `0` with its 64 bytes, or `-1`
leaving `out`. -/
public theorem fd_bn254_g1_add_syscall.spec_eq (hB : B.Spec) (out : Vector (BitVec 8) 64)
    (in_sz : BitVec 64) (in_ : Vector (BitVec 8) in_sz.toNat) (big_endian : BitVec 32) :
    fd_bn254_g1_add_syscall.spec B out in_sz in_ big_endian =
      match g1Add (big_endian ≠ 0) in_ with
      | none => ⟨out, -1⟩
      | some o => ⟨o, 0⟩ := by
  simp only [fd_bn254_g1_add_syscall.spec, g1Add]
  by_cases h1 : in_sz > 128
  · have h1' : 128 < in_sz.toNat := by
      rw [gt_iff_lt, BitVec.lt_def, show (128 : BitVec 64).toNat = 128 from rfl] at h1; exact h1
    rw [ite_eq_left h1, ite_eq_left (.inl h1')]
  rw [ite_eq_right h1]
  have h1' : in_sz.toNat ≤ 128 := by
    rw [gt_iff_lt, BitVec.lt_def, show (128 : BitVec 64).toNat = 128 from rfl] at h1; omega
  by_cases h2 : big_endian = 0 ∧ in_sz ≠ 128
  · rw [ite_eq_left h2,
      ite_eq_left (.inr ⟨by simp [h2.1], fun h => h2.2 (BitVec.eq_of_toNat_eq h)⟩)]
  have h3 : ¬(128 < in_sz.toNat ∨ (decide (big_endian ≠ 0) = false ∧ in_sz.toNat ≠ 128)) := by
    rintro (h | ⟨hb, hn⟩)
    · omega
    · apply h2;
      refine
        ⟨by simpa using hb, fun h =>
          hn
            (by
              rw [h]; rfl)⟩
  rw [ite_eq_right h2, ite_eq_right h3]
  rw [memcpy_pad 128 in_ h1']
  rcases hA : decodeG1 (big_endian ≠ 0) (loadBytes (padTo 128 in_) 0 64) with _ | P
  · simp only [check_subgroup_none hA]
  obtain ⟨ha1, ha2⟩ := check_subgroup_some (p := default) hA
  simp only [ha1]
  rcases hB' : decodeG1 (big_endian ≠ 0) (loadBytes (padTo 128 in_) 64 64) with _ | Q
  · simp only [check_subgroup_none hB']
  obtain ⟨hb1, hb2⟩ := check_subgroup_some (p := default) hB'
  simp only [hb1]
  rw [fd_bn254_g1_tobytes.spec_eq hB (fd_bn254_g1_affine_add.rep hB default ha2 hb2).prep]

/-- `fd_bn254_g1_scalar_mul_syscall` (either build) is Agave's G1 multiplication (scalar
unreduced), if every point is killed by `r`. -/
public theorem fd_bn254_g1_scalar_mul_syscall.spec_eq (hB : B.Spec)
    (hr : ∀ P : ECPoint, r_bn254 • P = 0) (out : Vector (BitVec 8) 64) (in_sz : BitVec 64)
    (in_ : Vector (BitVec 8) in_sz.toNat) (big_endian : BitVec 32) :
    fd_bn254_g1_scalar_mul_syscall.spec B out in_sz in_ big_endian =
      match g1Mul (big_endian ≠ 0) in_ with
      | none => ⟨out, -1⟩
      | some o => ⟨o, 0⟩ := by
  simp only [fd_bn254_g1_scalar_mul_syscall.spec, g1Mul]
  by_cases h1 : in_sz > 96
  · have h1' : 96 < in_sz.toNat := by
      rw [gt_iff_lt, BitVec.lt_def, show (96 : BitVec 64).toNat = 96 from rfl] at h1; exact h1
    rw [ite_eq_left h1, ite_eq_left (.inl h1')]
  rw [ite_eq_right h1]
  have h1' : in_sz.toNat ≤ 96 := by
    rw [gt_iff_lt, BitVec.lt_def, show (96 : BitVec 64).toNat = 96 from rfl] at h1; omega
  by_cases h2 : big_endian = 0 ∧ in_sz ≠ 96
  · rw [ite_eq_left h2,
      ite_eq_left (.inr ⟨by simp [h2.1], fun h => h2.2 (BitVec.eq_of_toNat_eq h)⟩)]
  have h3 : ¬(96 < in_sz.toNat ∨ (decide (big_endian ≠ 0) = false ∧ in_sz.toNat ≠ 96)) := by
    rintro (h | ⟨hb, hn⟩)
    · omega
    · apply h2;
      refine
        ⟨by simpa using hb, fun h =>
          hn
            (by
              rw [h]; rfl)⟩
  rw [ite_eq_right h2, ite_eq_right h3]
  have hmin : (fd_ulong_min in_sz 96).toNat = in_sz.toNat := by
    unfold fd_ulong_min
    split_ifs with h
    · rfl
    · rw [BitVec.lt_def, show (96 : BitVec 64).toNat = 96 from rfl] at h
      show (96 : BitVec 64).toNat = _; rw [show (96 : BitVec 64).toNat = 96 from rfl]; omega
  rw [hmin, memcpy_pad 96 in_ h1']
  rcases hA : decodeG1 (big_endian ≠ 0) (loadBytes (padTo 96 in_) 0 64) with _ | P
  · simp only [check_subgroup_none hA]
  obtain ⟨ha1, ha2⟩ := check_subgroup_some (p := default) hA
  simp only [ha1]
  rw [fd_bn254_g1_tobytes.spec_eq hB (fd_bn254_g1_scalar_mul.rep hB hr ha2 default _),
    limbsEval_read]

/-! ## Compression -/

theorem flagByte_load64 (in_ : Vector (BitVec 8) 64) (be : BitVec 32) :
    flagByte (be ≠ 0) (loadBytes in_ 32 32) = if be ≠ 0 then in_[32] else in_[63] := by
  unfold flagByte loadBytes
  by_cases h : be ≠ 0 <;> simp

theorem orFlag_zero (be : Bool) (b : Vector (BitVec 8) 32) : orFlag be b 0 = b := by
  unfold orFlag; split_ifs <;> simp

theorem flag_inf_byte (fl : BitVec 8) (h : fl &&& FLAG_INF ≠ 0) :
    (fl.setWidth 32 &&& FLAG_INF.setWidth 32).setWidth 8 = FLAG_INF := by
  unfold FLAG_INF at *; bv_decide

theorem flag_inf_byte0 (fl : BitVec 8) (h : ¬fl &&& FLAG_INF ≠ 0) :
    (fl.setWidth 32 &&& FLAG_INF.setWidth 32).setWidth 8 = 0 := by
  unfold FLAG_INF at *; bv_decide

/-- `fd_bn254_g1_compress` is Agave's G1 compression: `out` is stored only on success. -/
public theorem fd_bn254_g1_compress.spec_eq (out : Vector (BitVec 8) 32)
    (in_ : Vector (BitVec 8) 64) (be : BitVec 32) :
    fd_bn254_g1_compress.spec out in_ be =
      match g1Compress (be ≠ 0) in_ with
      | none => ⟨out, none⟩
      | some o => ⟨o, some o⟩ := by
  have hi := internal_spec ⟨#v[0, 0, 0, 0], #v[0, 0, 0, 0], #v[0, 0, 0, 0]⟩ in_ be
  simp only [fd_bn254_g1_compress.spec]
  generalize
    fd_bn254_g1_frombytes_internal.spec ⟨#v[0, 0, 0, 0], #v[0, 0, 0, 0], #v[0, 0, 0, 0]⟩ in_ be =
    res at hi ⊢
  unfold g1Compress
  dsimp only
  have hfb := flagByte_load64 in_ be
  by_cases hz : in_ = Vector.replicate 64 0
  · rw [ite_eq_left hz] at hi
    obtain ⟨hr, hZ⟩ := hi
    have hp0 := PRep.zero_of_z hZ
    rw [ite_eq_left hz]
    simp only [hr, ite_eq_left ((hp0.is_zero_iff).mpr rfl)]
    subst hz
    simp
  rw [ite_eq_right hz] at hi
  rw [ite_eq_right hz]
  by_cases herr :
    p_bn254 ≤ bytesToNat (be ≠ 0) (loadBytes in_ 0 32) ∨
      (flagByte (be ≠ 0) (loadBytes in_ 32 32) &&& FLAG_INF ≠ 0 ∧
        flagByte (be ≠ 0) (loadBytes in_ 32 32) &&& FLAG_NEG ≠ 0) ∨
      p_bn254 ≤ bytesToNat (be ≠ 0) (loadBytes in_ 32 32) % 2 ^ 254
  · rw [ite_eq_left herr] at hi
    rw [ite_eq_left herr]
    simp only [hi]
  rw [ite_eq_right herr] at hi
  rw [ite_eq_right herr]
  obtain ⟨hr, hp⟩ := hi
  simp only [hr]
  by_cases hinf : flagByte (be ≠ 0) (loadBytes in_ 32 32) &&& FLAG_INF ≠ 0
  · rw [ite_eq_left hinf] at hp
    have hp0 := PRep.zero_of_z hp
    rw [ite_eq_left hinf]
    simp only [ite_eq_left ((hp0.is_zero_iff).mpr rfl)]
    rw [← hfb, flag_inf_byte _ hinf]
    unfold orFlag
    by_cases hb : be ≠ 0 <;> simp
  rw [ite_eq_right hinf] at hp
  obtain ⟨hpx, hpy, hpz⟩ := hp
  have hnz : ¬fd_bn254_g1_is_zero.spec res.p ≠ 0 := by
    rw [fd_bn254_g1_is_zero.spec, hpz, fd_bn254_fp_is_zero.spec_iff fd_bn254_const_one_mont.tr]
    exact one_ne_zero
  rw [ite_eq_right hinf]
  simp only [hnz, ↓reduceIte, fd_bn254_fp_tobytes_nm.buf_eq, hpx]
  have hneg := fd_bn254_fp_is_neg_nm.spec_ne_zero res.p.Y
  rw [hpy] at hneg
  unfold orFlag
  by_cases hn : p_bn254 / 2 < bytesToNat (be ≠ 0) (loadBytes in_ 32 32) % 2 ^ 254
  · rw [ite_eq_left (hneg.mpr hn), ite_eq_left hn]
    by_cases hb : be ≠ 0 <;> simp
  · rw [ite_eq_right (mt hneg.mp hn), ite_eq_right hn]
    by_cases hb : be ≠ 0 <;> simp

/-! ## Decompression -/

theorem storeBytes_two (out : Vector (BitVec 8) 64) (a b : Vector (BitVec 8) 32) :
    storeBytes (storeBytes out 0 a) 32 b = a ++ b := by
  refine Vector.ext fun j hj => ?_
  simp only [storeBytes, Vector.getElem_ofFn]
  rw [Vector.getElem_append]
  by_cases h : j < 32
  · simp [h, show ¬(32 ≤ j ∧ j - 32 < 32) by omega]
  · simp [h, show 32 ≤ j ∧ j - 32 < 32 by omega]

theorem val_neg_of_ne {w : ZMod p_bn254} (hw : w ≠ 0) : (-w).val = p_bn254 - w.val := by
  rw [ZMod.neg_val, ite_eq_right hw]

/-- The two roots `±w` give the same signed choice. -/
theorem signed_val {w0 w : ZMod p_bn254} (hw : w ≠ 0) (h : w0 = w ∨ w0 = -w) (neg : Bool) :
    (if decide (p_bn254 / 2 < w0.val) = neg then w0 else -w0).val =
      if decide (p_bn254 / 2 < w.val) = neg then w.val else p_bn254 - w.val := by
  have hpo : p_bn254 % 2 = 1 := by norm_num [p_bn254]
  have hlt := ZMod.val_lt w
  have hw0 : w.val ≠ 0 := by rwa [Ne, ZMod.val_eq_zero]
  have hneg := val_neg_of_ne hw
  rcases h with rfl | rfl
  · split_ifs with h1
    · rfl
    · exact hneg
  · rw [hneg, neg_neg]
    have hs' : p_bn254 / 2 < p_bn254 - w.val ↔ ¬p_bn254 / 2 < w.val := by omega
    by_cases hs : p_bn254 / 2 < w.val <;> cases neg <;> simp [hs, hs', hneg]

set_option linter.auxLemma false in
theorem dm1 {α : Type} (x : Option fd_bn254_fp_t) (n : Unit → α) (f : fd_bn254_fp_t → α) :
    fd_bn254_g1_decompress.spec.match_1 (fun _ => α) x n f = optElim x (n ()) f := by
  cases x <;> rfl

set_option linter.auxLemma false in
theorem dm3 {α : Type} (x : BitVec 32 × BitVec 32) (f : BitVec 32 → BitVec 32 → α) :
    fd_bn254_g1_decompress.spec.match_3 (fun _ => α) x f = f x.1 x.2 := by
  cases x; rfl

theorem optElim_none {α β : Type} (n : α) (f : β → α) : optElim none n f = n :=
  rfl

theorem optElim_some {α β : Type} (b : β) (n : α) (f : β → α) : optElim (some b) n f = f b :=
  rfl

theorem sqrtSigned_none {a : ZMod p_bn254} (h : ¬IsSquare a) (neg : Bool) :
    sqrtSigned a neg = none :=
  dite_eq_right h

theorem sqrtSigned_some {a w : ZMod p_bn254} (hw : w ≠ 0) (hw2 : w ^ 2 = a) (neg : Bool) :
    ∃ v,
      sqrtSigned a neg = some v ∧
        v.val = if decide (p_bn254 / 2 < w.val) = neg then w.val else p_bn254 - w.val := by
  have hsq : IsSquare a := ⟨w, by rw [← hw2, sq]⟩
  refine ⟨_, dite_eq_left hsq, ?_⟩
  have hc := Classical.choose_spec hsq
  have h2 : Classical.choose hsq ^ 2 = w ^ 2 := by
    rw [hw2, sq]; exact hc.symm
  exact signed_val hw (sq_eq_sq_iff_eq_or_eq_neg.mp h2) neg

theorem is_neg_nm_eq (x : fd_bn254_fp_t) :
    fd_bn254_fp_is_neg_nm.spec x = if p_bn254 / 2 < limbsEval x then 1 else 0 := by
  have h := fd_bn254_fp_is_neg_nm.spec_ne_zero x
  have h01 : fd_bn254_fp_is_neg_nm.spec x = 1 ∨ fd_bn254_fp_is_neg_nm.spec x = 0 := by
    unfold fd_bn254_fp_is_neg_nm.spec; split <;> simp
  by_cases hs : p_bn254 / 2 < limbsEval x
  · rw [ite_eq_left hs]; exact h01.resolve_right (h.mpr hs)
  · rw [ite_eq_right hs]; exact not_not.mp (mt h.mp hs)

/-- The sign fix-up yields the root of the requested sign. -/
theorem yf_val (m : fd_bn254_fp_t) {w : ZMod p_bn254} (hw : w ≠ 0) (hm : limbsEval m = w.val)
    (fN : Prop) [Decidable fN] :
    limbsEval
        (if (if fN then (1 : BitVec 32) else 0) ≠ fd_bn254_fp_is_neg_nm.spec m then
          fd_bn254_fp_neg_nm.spec m
        else m) =
      if decide (p_bn254 / 2 < w.val) = decide fN then w.val else p_bn254 - w.val := by
  have hlt : limbsEval m < p_bn254 := hm ▸ ZMod.val_lt w
  have h0 : w.val ≠ 0 := by rwa [Ne, ZMod.val_eq_zero]
  have hneg := fd_bn254_fp_neg_nm.val m hlt
  rw [hm, ite_eq_right h0] at hneg
  rw [is_neg_nm_eq, hm]
  by_cases hf : fN <;> by_cases hs : p_bn254 / 2 < w.val <;> simp [hf, hs, hneg, hm]

/-- `fd_bn254_g1_decompress` is Agave's G1 decompression: `out` is stored only on success. -/
public theorem fd_bn254_g1_decompress.spec_eq (out : Vector (BitVec 8) 64)
    (in_ : Vector (BitVec 8) 32) (be : BitVec 32) :
    fd_bn254_g1_decompress.spec out in_ be =
      match g1Decompress (be ≠ 0) in_ with
      | none => ⟨out, none⟩
      | some o => ⟨o, some o⟩ := by
  rw [fd_bn254_g1_decompress.spec, g1Decompress]
  simp (config := { iota := false, etaStruct := .none, proj := false, zeta := false }) only [dm1,
    dm3]
  simp (config := { iota := false, etaStruct := .none, proj := false, zeta := true }) only []
  by_cases hz : in_ = Vector.replicate 32 0
  · rw [ite_eq_left ((memeq_ne_zero _ _).mpr hz), ite_eq_left hz]
  rw [ite_eq_right (fun h => hz ((memeq_ne_zero _ _).mp h)), ite_eq_right hz]
  obtain ⟨hf0, hf1, hf2⟩ := fd_bn254_fp_frombytes_nm.val default in_ be (some (0, 0))
  simp only [Option.isSome_some, ↓reduceIte, true_and, Option.map_some] at hf0 hf1 hf2
  generalize fd_bn254_fp_frombytes_nm.spec default in_ be (some (0, 0)) = R at hf0 hf1 hf2 ⊢
  rcases hxr : R.ret with _ | qx
  · rw [ite_eq_left (hf1.mp hxr), optElim_none]
  have herr :
    ¬((flagByte (be ≠ 0) in_ &&& FLAG_INF ≠ 0 ∧ flagByte (be ≠ 0) in_ &&& FLAG_NEG ≠ 0) ∨
        p_bn254 ≤ bytesToNat (be ≠ 0) in_ % 2 ^ 254) :=
    fun h => by
    rw [hf1.mpr h] at hxr; cases hxr
  rw [ite_eq_right herr, optElim_some]
  obtain ⟨hxq, hxv⟩ := hf2 qx hxr
  simp only [hf0, Option.getD_some, hxq]
  by_cases hinf : flagByte (be ≠ 0) in_ &&& FLAG_INF ≠ 0
  · rw [ite_eq_left
        (by
          rw [ite_eq_left hinf]; exact one32_ne),
      ite_eq_left hinf]
  rw [ite_eq_right
      (by
        rw [ite_eq_right hinf]; simp),
    ite_eq_right hinf]
  have hqx : limbsEval qx < p_bn254 := by
    rw [hxv]; omega
  have tX := fd_bn254_fp_to_mont.tr hqx
  rw [hxv] at tX
  have t3 :=
    fd_bn254_fp_add.tr (fd_bn254_fp_mul.tr (fd_bn254_fp_sqr.tr tX) tX) fd_bn254_const_b_mont.tr
  obtain ⟨hs1, hs2⟩ := fd_bn254_fp_sqrt.tr t3 default
  generalize
    fd_bn254_fp_sqrt.spec default
      (fd_bn254_fp_add.spec
        (fd_bn254_fp_mul.spec (fd_bn254_fp_sqr.spec (fd_bn254_fp_to_mont.spec qx))
          (fd_bn254_fp_to_mont.spec qx))
        fd_bn254_const_b_mont) =
    S at hs1 hs2 ⊢
  have ha :
    (((bytesToNat (be ≠ 0) in_ % 2 ^ 254 : ℕ) : ZMod p_bn254) ^ 2 *
          ((bytesToNat (be ≠ 0) in_ % 2 ^ 254 : ℕ) : ZMod p_bn254) +
        3) =
      ((bytesToNat (be ≠ 0) in_ % 2 ^ 254 : ℕ) : ZMod p_bn254) ^ 3 + 3 := by
    ring
  rw [ha] at hs1 hs2
  generalize hSS : sqrtSigned _ _ = SS
  rcases hsr : S.ret with _ | yv
  · rw [sqrtSigned_none (hs1.mp hsr)] at hSS
    subst hSS
    rfl
  rw [optElim_some]
  obtain ⟨hyr, w, tw, hw2⟩ := hs2 yv hsr
  have hw : w ≠ 0 := by
    rintro rfl
    exact
      cube_add_three_ne_zero _
        (by
          rw [← hw2]; ring)
  obtain ⟨hmc, hmv⟩ := fd_bn254_fp_from_mont.val tw
  have hm : limbsEval (fd_bn254_fp_from_mont.spec yv) = w.val := by
    rw [← hmv, ZMod.val_natCast, Nat.mod_eq_of_lt hmc]
  obtain ⟨v, hv, hvv⟩ := sqrtSigned_some hw hw2 (decide (flagByte (be ≠ 0) in_ &&& FLAG_NEG ≠ 0))
  rw [hv] at hSS
  subst hSS
  rw [hyr, storeBytes_two, fd_bn254_fp_tobytes_nm.buf_eq, fd_bn254_fp_tobytes_nm.buf_eq,
    yf_val _ hw hm, ← hvv, hxv]

/-! ## The two builds -/

/-- The s2n build of `fd_bn254_g1_add_syscall` is Agave's G1 addition. -/
public theorem fd_bn254_g1_add_syscall.s2n_eq (out : Vector (BitVec 8) 64) (in_sz : BitVec 64)
    (in_ : Vector (BitVec 8) in_sz.toNat) (big_endian : BitVec 32) :
    fd_bn254_g1_add_syscall.s2n out in_sz in_ big_endian =
      match g1Add (big_endian ≠ 0) in_ with
      | none => ⟨out, -1⟩
      | some o => ⟨o, 0⟩ :=
  fd_bn254_g1_add_syscall.spec_eq Backend.s2n_spec out in_sz in_ big_endian

/-- The portable build of `fd_bn254_g1_add_syscall` is Agave's G1 addition. -/
public theorem fd_bn254_g1_add_syscall.ref_eq (out : Vector (BitVec 8) 64) (in_sz : BitVec 64)
    (in_ : Vector (BitVec 8) in_sz.toNat) (big_endian : BitVec 32) :
    fd_bn254_g1_add_syscall.ref out in_sz in_ big_endian =
      match g1Add (big_endian ≠ 0) in_ with
      | none => ⟨out, -1⟩
      | some o => ⟨o, 0⟩ :=
  fd_bn254_g1_add_syscall.spec_eq Backend.ref_spec out in_sz in_ big_endian

/-- The s2n build of `fd_bn254_g1_scalar_mul_syscall` is Agave's G1 scalar multiplication. -/
public theorem fd_bn254_g1_scalar_mul_syscall.s2n_eq (hr : ∀ P : ECPoint, r_bn254 • P = 0)
    (out : Vector (BitVec 8) 64) (in_sz : BitVec 64) (in_ : Vector (BitVec 8) in_sz.toNat)
    (big_endian : BitVec 32) :
    fd_bn254_g1_scalar_mul_syscall.s2n out in_sz in_ big_endian =
      match g1Mul (big_endian ≠ 0) in_ with
      | none => ⟨out, -1⟩
      | some o => ⟨o, 0⟩ :=
  fd_bn254_g1_scalar_mul_syscall.spec_eq Backend.s2n_spec hr out in_sz in_ big_endian

/-- The portable build of `fd_bn254_g1_scalar_mul_syscall` is Agave's G1 scalar multiplication. -/
public theorem fd_bn254_g1_scalar_mul_syscall.ref_eq (hr : ∀ P : ECPoint, r_bn254 • P = 0)
    (out : Vector (BitVec 8) 64) (in_sz : BitVec 64) (in_ : Vector (BitVec 8) in_sz.toNat)
    (big_endian : BitVec 32) :
    fd_bn254_g1_scalar_mul_syscall.ref out in_sz in_ big_endian =
      match g1Mul (big_endian ≠ 0) in_ with
      | none => ⟨out, -1⟩
      | some o => ⟨o, 0⟩ :=
  fd_bn254_g1_scalar_mul_syscall.spec_eq Backend.ref_spec hr out in_sz in_ big_endian

end Firedancer.Bn254
