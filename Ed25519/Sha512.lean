module

import Mathlib.Tactic.Conv
import Std.Tactic.BVDecide

/-! FIPS 180-4 SHA-512 on byte lists, and bytes of bit vectors. -/

namespace Ed25519

/-! ## Definitions -/

@[expose] public section

/-- `x`'s bytes, least significant first: byte `i` is bits `8 i … 8 i + 7`. -/
def bytesLE (x : BitVec w) : List (BitVec 8) :=
  List.ofFn fun i : Fin (w / 8) => x.extractLsb' (8 * i) 8

namespace Sha512

/-- `x`'s bytes, most significant first. -/
def bytesBE (x : BitVec w) : List (BitVec 8) :=
  (bytesLE x).reverse

/-- `K⁽⁵¹²⁾`, the 80 round constants (§4.2.3). -/
def K : Vector (BitVec 64) 80 :=
  #v[0x428a2f98d728ae22#64, 0x7137449123ef65cd#64, 0xb5c0fbcfec4d3b2f#64, 0xe9b5dba58189dbbc#64,
    0x3956c25bf348b538#64, 0x59f111f1b605d019#64, 0x923f82a4af194f9b#64, 0xab1c5ed5da6d8118#64,
    0xd807aa98a3030242#64, 0x12835b0145706fbe#64, 0x243185be4ee4b28c#64, 0x550c7dc3d5ffb4e2#64,
    0x72be5d74f27b896f#64, 0x80deb1fe3b1696b1#64, 0x9bdc06a725c71235#64, 0xc19bf174cf692694#64,
    0xe49b69c19ef14ad2#64, 0xefbe4786384f25e3#64, 0x0fc19dc68b8cd5b5#64, 0x240ca1cc77ac9c65#64,
    0x2de92c6f592b0275#64, 0x4a7484aa6ea6e483#64, 0x5cb0a9dcbd41fbd4#64, 0x76f988da831153b5#64,
    0x983e5152ee66dfab#64, 0xa831c66d2db43210#64, 0xb00327c898fb213f#64, 0xbf597fc7beef0ee4#64,
    0xc6e00bf33da88fc2#64, 0xd5a79147930aa725#64, 0x06ca6351e003826f#64, 0x142929670a0e6e70#64,
    0x27b70a8546d22ffc#64, 0x2e1b21385c26c926#64, 0x4d2c6dfc5ac42aed#64, 0x53380d139d95b3df#64,
    0x650a73548baf63de#64, 0x766a0abb3c77b2a8#64, 0x81c2c92e47edaee6#64, 0x92722c851482353b#64,
    0xa2bfe8a14cf10364#64, 0xa81a664bbc423001#64, 0xc24b8b70d0f89791#64, 0xc76c51a30654be30#64,
    0xd192e819d6ef5218#64, 0xd69906245565a910#64, 0xf40e35855771202a#64, 0x106aa07032bbd1b8#64,
    0x19a4c116b8d2d0c8#64, 0x1e376c085141ab53#64, 0x2748774cdf8eeb99#64, 0x34b0bcb5e19b48a8#64,
    0x391c0cb3c5c95a63#64, 0x4ed8aa4ae3418acb#64, 0x5b9cca4f7763e373#64, 0x682e6ff3d6b2b8a3#64,
    0x748f82ee5defb2fc#64, 0x78a5636f43172f60#64, 0x84c87814a1f0ab72#64, 0x8cc702081a6439ec#64,
    0x90befffa23631e28#64, 0xa4506cebde82bde9#64, 0xbef9a3f7b2c67915#64, 0xc67178f2e372532b#64,
    0xca273eceea26619c#64, 0xd186b8c721c0c207#64, 0xeada7dd6cde0eb1e#64, 0xf57d4f7fee6ed178#64,
    0x06f067aa72176fba#64, 0x0a637dc5a2c898a6#64, 0x113f9804bef90dae#64, 0x1b710b35131c471b#64,
    0x28db77f523047d84#64, 0x32caab7b40c72493#64, 0x3c9ebe0a15c9bebc#64, 0x431d67c49c100d4c#64,
    0x4cc5d4becb3e42b6#64, 0x597f299cfc657e2a#64, 0x5fcb6fab3ad6faec#64, 0x6c44198c4a475817#64]

/-- `H⁽⁰⁾`, the initial hash value (§5.3.5). -/
def IV : Vector (BitVec 64) 8 :=
  #v[0x6a09e667f3bcc908#64, 0xbb67ae8584caa73b#64, 0x3c6ef372fe94f82b#64, 0xa54ff53a5f1d36f1#64,
    0x510e527fade682d1#64, 0x9b05688c2b3e6c1f#64, 0x1f83d9abfb41bd6b#64, 0x5be0cd19137e2179#64]

/-! The functions of §4.1.3. -/

def Ch (x y z : BitVec 64) : BitVec 64 :=
  (x &&& y) ^^^ (~~~x &&& z)

def Maj (x y z : BitVec 64) : BitVec 64 :=
  (x &&& y) ^^^ (x &&& z) ^^^ (y &&& z)

def Sigma0 (x : BitVec 64) : BitVec 64 :=
  x.rotateRight 28 ^^^ x.rotateRight 34 ^^^ x.rotateRight 39

def Sigma1 (x : BitVec 64) : BitVec 64 :=
  x.rotateRight 14 ^^^ x.rotateRight 18 ^^^ x.rotateRight 41

def sigma0 (x : BitVec 64) : BitVec 64 :=
  x.rotateRight 1 ^^^ x.rotateRight 8 ^^^ x >>> 7

def sigma1 (x : BitVec 64) : BitVec 64 :=
  x.rotateRight 19 ^^^ x.rotateRight 61 ^^^ x >>> 6

/-- Word `t` of a block, big-endian: bytes `8 t … 8 t + 7`, the first most significant. -/
def word (block : List (BitVec 8)) (t : Nat) : BitVec 64 :=
  block[8 * t]! ++ block[8 * t + 1]! ++ block[8 * t + 2]! ++ block[8 * t + 3]! ++
    block[8 * t + 4]! ++
    block[8 * t + 5]! ++
    block[8 * t + 6]! ++
    block[8 * t + 7]!

/-- The message schedule `W₀ … W₇₉` (§6.4.2 step 1): the block's 16 words, then
`W_t = σ₁(W_{t-2}) + W_{t-7} + σ₀(W_{t-15}) + W_{t-16}`. -/
def schedule (block : List (BitVec 8)) : List (BitVec 64) :=
  (List.range 64).foldl (fun W t => W ++ [sigma1 W[t + 14]! + W[t + 9]! + sigma0 W[t + 1]! + W[t]!])
    ((List.range 16).map (word block))

/-- One round (§6.4.2 step 3) on the working variables `a … h` (`v[0] … v[7]`), with `K_t = k`
and `W_t = w`. -/
def round (v : Vector (BitVec 64) 8) (k w : BitVec 64) : Vector (BitVec 64) 8 :=
  let T1 := v[7] + Sigma1 v[4] + Ch v[4] v[5] v[6] + k + w
  let T2 := Sigma0 v[0] + Maj v[0] v[1] v[2]
  #v[T1 + T2, v[0], v[1], v[2], v[3] + T1, v[4], v[5], v[6]]

/-- The hash value after one 128-byte block (§6.4.2): 80 rounds from `H`, then added to `H`. -/
def compress (H : Vector (BitVec 64) 8) (block : List (BitVec 8)) : Vector (BitVec 64) 8 :=
  let W := schedule block
  Vector.zipWith (· + ·) H ((List.range 80).foldl (fun v t => round v K[t]! W[t]!) H)

/-- The hash value after the whole 128-byte blocks of `l`, in order; a short tail is left. -/
def compressBlocks (H : Vector (BitVec 64) 8) (l : List (BitVec 8)) : Vector (BitVec 64) 8 :=
  if _h : 128 ≤ l.length then compressBlocks (compress H (l.take 128)) (l.drop 128) else H
termination_by l.length
decreasing_by rw [List.length_drop]; omega

/-- The padded message (§5.1.2): `0x80`, the fewest zero bytes reaching 112 mod 128, then the bit
length as 128 bits big-endian. -/
def pad (msg : List (BitVec 8)) : List (BitVec 8) :=
  msg ++ [0x80#8] ++ List.replicate ((239 - msg.length % 128) % 128) 0#8 ++
    bytesBE (BitVec.ofNat 128 (8 * msg.length))

/-- SHA-512 (§6.4): the padded message's blocks compressed from `IV`, the words big-endian. -/
def digest (msg : List (BitVec 8)) : List (BitVec 8) :=
  (compressBlocks IV (pad msg)).toList.flatMap bytesBE

end Sha512

end

/-! ## Bytes -/

section Bytes

variable {v w : Nat}

@[simp]
public theorem length_bytesLE (x : BitVec w) : (bytesLE x).length = w / 8 := by simp [bytesLE]

public theorem getElem_bytesLE (x : BitVec w) (i : Nat) (h : i < (bytesLE x).length) :
    (bytesLE x)[i] = x.extractLsb' (8 * i) 8 := by simp [bytesLE]

public theorem getElem!_bytesLE (x : BitVec w) {i : Nat} (h : i < w / 8) :
    (bytesLE x)[i]! = x.extractLsb' (8 * i) 8 := by
  rw [getElem!_pos (bytesLE x) i (by simpa using h), getElem_bytesLE]

public theorem bytesLE_append (x : BitVec v) (y : BitVec w) (hw : w % 8 = 0) :
    bytesLE (x ++ y) = bytesLE y ++ bytesLE x := by
  apply List.ext_getElem
  · simp only [length_bytesLE, List.length_append]; omega
  · intro i h1 h2
    rw [getElem_bytesLE, List.getElem_append]
    apply BitVec.eq_of_getLsbD_eq
    intro j hj
    split
    · rw [getElem_bytesLE]
      simp only [length_bytesLE] at *
      simp [BitVec.getLsbD_append, show 8 * i + j < w by omega]
    · rw [getElem_bytesLE]
      simp only [length_bytesLE] at *
      have e : 8 * i + j - w = 8 * (i - w / 8) + j := by omega
      simp [BitVec.getLsbD_append, show ¬8 * i + j < w by omega, e]

public theorem bytesLE_extractLsb' (x : BitVec w) {s n : Nat} (hs : s % 8 = 0) (hn : n % 8 = 0)
    (h : s + n ≤ w) : bytesLE (x.extractLsb' s n) = ((bytesLE x).drop (s / 8)).take (n / 8) := by
  apply List.ext_getElem
  · simp only [length_bytesLE, List.length_take, List.length_drop]; omega
  · intro i h1 h2
    simp only [length_bytesLE, List.length_take, List.length_drop] at h1 h2
    rw [getElem_bytesLE, List.getElem_take, List.getElem_drop, getElem_bytesLE]
    apply BitVec.eq_of_getLsbD_eq
    intro j hj
    have e : s + (8 * i + j) = 8 * (s / 8 + i) + j := by omega
    simp [BitVec.getLsbD_extractLsb', e, show 8 * i + j < n by omega]

public theorem bytesLE_setWidth (x : BitVec w) {n : Nat} (hn : n % 8 = 0) (h : n ≤ w) :
    bytesLE (x.setWidth n) = (bytesLE x).take (n / 8) := by
  apply List.ext_getElem
  · simp only [length_bytesLE, List.length_take]; omega
  · intro i h1 h2
    simp only [length_bytesLE, List.length_take] at h1 h2
    rw [getElem_bytesLE, List.getElem_take, getElem_bytesLE]
    apply BitVec.eq_of_getLsbD_eq
    intro j hj
    simp [BitVec.getLsbD_extractLsb', show 8 * i + j < n by omega]

public theorem bytesLE_replicate_zero (n : Nat) :
    bytesLE ((0#8).replicate n) = List.replicate n 0#8 := by
  apply List.ext_getElem
  · simp
  · intro i h1 h2
    rw [getElem_bytesLE, List.getElem_replicate]
    apply BitVec.eq_of_getLsbD_eq
    intro j hj
    simp [BitVec.getLsbD_extractLsb', BitVec.getLsbD_replicate]

end Bytes

/-! ## Blocks -/

namespace Sha512

public theorem compressBlocks_of_lt {l : List (BitVec 8)} (h : l.length < 128) :
    compressBlocks H l = H := by
  rw [compressBlocks]
  simp only [show ¬128 ≤ l.length by omega, ↓reduceDIte]

public theorem compressBlocks_of_le {l : List (BitVec 8)} (h : 128 ≤ l.length) :
    compressBlocks H l = compressBlocks (compress H (l.take 128)) (l.drop 128) := by
  rw [compressBlocks]
  simp only [h, ↓reduceDIte]

/-- Whole blocks `a`, then `b`. -/
public theorem compressBlocks_append {a : List (BitVec 8)} (b : List (BitVec 8))
    (ha : a.length % 128 = 0) :
    compressBlocks H (a ++ b) = compressBlocks (compressBlocks H a) b := by
  induction hn : a.length / 128 generalizing a H with
  | zero =>
    have : a = [] := List.eq_nil_of_length_eq_zero (by omega)
    subst this
    rw [List.nil_append, compressBlocks_of_lt (l := []) (by simp)]
  | succ n ih =>
    have hl : 128 ≤ a.length := by omega
    rw [compressBlocks_of_le
        (by
          simp; omega),
      compressBlocks_of_le hl, List.take_append_of_le_length hl, List.drop_append_of_le_length hl,
      ih
        (by
          simp; omega)
        (by
          simp; omega)]

/-- A tail short of a block changes nothing. -/
public theorem compressBlocks_append_short {a b : List (BitVec 8)}
    (h : a.length % 128 + b.length < 128) : compressBlocks H (a ++ b) = compressBlocks H a := by
  have e := List.take_append_drop (a.length / 128 * 128) a
  have hk : (a.take (a.length / 128 * 128)).length % 128 = 0 := by
    simp; omega
  have h1 : (List.drop (a.length / 128 * 128) a ++ b).length < 128 := by
    simp only [List.length_append, List.length_drop]; omega
  have h2 : (List.drop (a.length / 128 * 128) a).length < 128 := by
    simp only [List.length_drop]; omega
  rw [← e, List.append_assoc, compressBlocks_append _ hk, compressBlocks_append _ hk,
    compressBlocks_of_lt h1, compressBlocks_of_lt h2]

/-- Only the whole blocks count. -/
public theorem compressBlocks_take (D : List (BitVec 8)) :
    compressBlocks H D = compressBlocks H (D.take (D.length / 128 * 128)) := by
  conv_lhs => rw [← List.take_append_drop (D.length / 128 * 128) D]
  exact
    compressBlocks_append_short
      (by
        simp only [List.length_take, List.length_drop]; omega)

/-! ## The schedule -/

/-- `schedule`'s fold after `n` steps from `W0`. -/
private def sched (W0 : List (BitVec 64)) (n : Nat) : List (BitVec 64) :=
  (List.range n).foldl (fun W t => W ++ [sigma1 W[t + 14]! + W[t + 9]! + sigma0 W[t + 1]! + W[t]!])
    W0

private theorem sched_succ (W0 : List (BitVec 64)) (n : Nat) :
    sched W0 (n + 1) =
      sched W0 n ++
        [sigma1 (sched W0 n)[n + 14]! + (sched W0 n)[n + 9]! + sigma0 (sched W0 n)[n + 1]! +
            (sched W0 n)[n]!] := by
  simp [sched, List.range_succ, List.foldl_append]

private theorem length_sched (W0 : List (BitVec 64)) (n : Nat) :
    (sched W0 n).length = W0.length + n := by
  induction n with
  | zero => rfl
  | succ n ih =>
    rw [sched_succ]; simp [ih]; omega

private theorem getElem!_append_left {l e : List (BitVec 64)} (h : i < l.length) :
    (l ++ e)[i]! = l[i]! := by
  rw [getElem!_pos (l ++ e) i
      (by
        simp; omega),
    getElem!_pos l i h, List.getElem_append_left]

private theorem sched_stable (W0 : List (BitVec 64)) (h : t < W0.length + n) (k : Nat) :
    (sched W0 (n + k))[t]! = (sched W0 n)[t]! := by
  induction k with
  | zero => rfl
  | succ k ih =>
    rw [← Nat.add_assoc, sched_succ,
      getElem!_append_left
        (by
          rw [length_sched]; omega),
      ih]

public theorem getElem!_schedule_lt (B : List (BitVec 8)) (h : t < 16) :
    (schedule B)[t]! = word B t := by
  change (sched _ (0 + 64))[t]! = _
  rw [sched_stable _ (by simpa using h)]
  rw [show sched ((List.range 16).map (word B)) 0 = (List.range 16).map (word B) from rfl,
    getElem!_pos ((List.range 16).map (word B)) t (by simpa)]
  simp

private theorem sched_le (W0 : List (BitVec 64)) (h : t < W0.length + n) (hm : n ≤ m) :
    (sched W0 m)[t]! = (sched W0 n)[t]! := by
  obtain ⟨k, rfl⟩ : ∃ k, m = n + k := ⟨m - n, by omega⟩
  exact sched_stable W0 h k

public theorem getElem!_schedule_ge (B : List (BitVec 8)) (h1 : 16 ≤ t) (h2 : t < 80) :
    (schedule B)[t]! =
      sigma1 (schedule B)[t - 2]! + (schedule B)[t - 7]! + sigma0 (schedule B)[t - 15]! +
        (schedule B)[t - 16]! := by
  change (sched ((List.range 16).map (word B)) 64)[t]! = _
  obtain ⟨n, rfl⟩ : ∃ n, t = 16 + n := ⟨t - 16, by omega⟩
  have hl : ((List.range 16).map (word B)).length = 16 := by simp
  have hg (t : Nat) (ht : t < 16 + n) : (schedule B)[t]! = (sched _ n)[t]! :=
    sched_le _ (by omega) (by omega)
  rw [hg _ (by omega), hg _ (by omega), hg _ (by omega), hg _ (by omega),
    sched_le (n := n + 1) _ (by omega) (by omega), sched_succ,
    getElem!_pos _ (16 + n) (by simp [length_sched]),
    List.getElem_append_right (by simp [length_sched])]
  simp only [length_sched, hl, Nat.sub_self, List.getElem_cons_zero]
  rw [show 16 + n - 2 = n + 14 by omega, show 16 + n - 7 = n + 9 by omega,
    show 16 + n - 15 = n + 1 by omega, show 16 + n - 16 = n by omega]

end Sha512

end Ed25519
