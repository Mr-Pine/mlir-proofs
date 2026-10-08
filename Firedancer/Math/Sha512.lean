module

public import Firedancer.Ref.fd_ed25519_verify
import Std.Tactic.BVDecide

/-! FIPS 180-4 SHA-512 on byte lists, and `fd_ed25519_verify.hash` computes it: its digest's
bytes are SHA-512 of `r ‖ publicKey ‖ msg`, whatever `buf0` holds. -/

namespace LeanMLIR.RIR.Firedancer.Ref

open Memory

/-! ## Reference -/

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

def Ch (x y z : BitVec 64) : BitVec 64 := (x &&& y) ^^^ (~~~x &&& z)

def Maj (x y z : BitVec 64) : BitVec 64 := (x &&& y) ^^^ (x &&& z) ^^^ (y &&& z)

def Sigma0 (x : BitVec 64) : BitVec 64 := x.rotateRight 28 ^^^ x.rotateRight 34 ^^^ x.rotateRight 39

def Sigma1 (x : BitVec 64) : BitVec 64 := x.rotateRight 14 ^^^ x.rotateRight 18 ^^^ x.rotateRight 41

def sigma0 (x : BitVec 64) : BitVec 64 := x.rotateRight 1 ^^^ x.rotateRight 8 ^^^ x >>> 7

def sigma1 (x : BitVec 64) : BitVec 64 := x.rotateRight 19 ^^^ x.rotateRight 61 ^^^ x >>> 6

/-- Word `t` of a block, big-endian: bytes `8 t … 8 t + 7`, the first most significant. -/
def word (block : List (BitVec 8)) (t : Nat) : BitVec 64 :=
  block[8 * t]! ++ block[8 * t + 1]! ++ block[8 * t + 2]! ++ block[8 * t + 3]! ++
    block[8 * t + 4]! ++ block[8 * t + 5]! ++ block[8 * t + 6]! ++ block[8 * t + 7]!

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

@[simp] public theorem length_bytesLE (x : BitVec w) : (bytesLE x).length = w / 8 := by
  simp [bytesLE]

public theorem getElem_bytesLE (x : BitVec w) (i : Nat) (h : i < (bytesLE x).length) :
    (bytesLE x)[i] = x.extractLsb' (8 * i) 8 := by
  simp [bytesLE]

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

public theorem bytesLE_bswap (x : BitVec 64) :
    bytesLE (fd_ulong_bswap.spec x) = (bytesLE x).reverse := by
  simp only [bytesLE, fd_ulong_bswap.spec, List.ofFn_succ, List.ofFn_zero, List.reverse_cons,
    List.reverse_nil, List.nil_append, List.cons_append, List.cons.injEq, Fin.val_succ,
    Fin.val_zero, and_true]
  bv_decide

/-- `copy` right past a known prefix `P` of `buf`'s bytes extends it by `x`'s. -/
public theorem take_bytesLE_copy {buf : BitVec 1024} {P : List (BitVec 8)}
    (hP : (bytesLE buf).take P.length = P) {off : BitVec 64} (hoff : off.toNat = P.length)
    {n : Nat} (x : BitVec (8 * n)) (hle : P.length + n ≤ 128) :
    (bytesLE (fd_sha512_append.copy buf off x)).take (P.length + n) = P ++ bytesLE x := by
  apply List.ext_getElem
  · simp only [length_bytesLE, List.length_take, List.length_append]; omega
  · intro i h1 h2
    simp only [length_bytesLE, List.length_take, List.length_append] at h1 h2
    rw [List.getElem_take, getElem_bytesLE, List.getElem_append, fd_sha512_append.copy, hoff]
    split
    · rw [extractLsb'_spliceBits_of_disjoint _ _ _ _ (by omega)]
      rw [← List.getElem_of_eq hP (by simp; omega), List.getElem_take, getElem_bytesLE]
    · rw [extractLsb'_spliceBits_of_subrange _ _ _ _ (by omega) (by omega) (by omega),
        getElem_bytesLE]
      congr 1
      omega

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
    rw [compressBlocks_of_le (by simp; omega), compressBlocks_of_le hl,
      List.take_append_of_le_length hl, List.drop_append_of_le_length hl,
      ih (by simp; omega) (by simp; omega)]

/-- A tail short of a block changes nothing. -/
public theorem compressBlocks_append_short {a b : List (BitVec 8)}
    (h : a.length % 128 + b.length < 128) :
    compressBlocks H (a ++ b) = compressBlocks H a := by
  have e := List.take_append_drop (a.length / 128 * 128) a
  have hk : (a.take (a.length / 128 * 128)).length % 128 = 0 := by simp; omega
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
  exact compressBlocks_append_short (by simp only [List.length_take, List.length_drop]; omega)

/-! ## The schedule -/

/-- `schedule`'s fold after `n` steps from `W0`. -/
private def sched (W0 : List (BitVec 64)) (n : Nat) : List (BitVec 64) :=
  (List.range n).foldl (fun W t => W ++ [sigma1 W[t + 14]! + W[t + 9]! + sigma0 W[t + 1]! + W[t]!])
    W0

private theorem sched_succ (W0 : List (BitVec 64)) (n : Nat) :
    sched W0 (n + 1) = sched W0 n ++
      [sigma1 (sched W0 n)[n + 14]! + (sched W0 n)[n + 9]! + sigma0 (sched W0 n)[n + 1]! +
        (sched W0 n)[n]!] := by
  simp [sched, List.range_succ, List.foldl_append]

private theorem length_sched (W0 : List (BitVec 64)) (n : Nat) :
    (sched W0 n).length = W0.length + n := by
  induction n with
  | zero => rfl
  | succ n ih => rw [sched_succ]; simp [ih]; omega

private theorem getElem!_append_left {l e : List (BitVec 64)} (h : i < l.length) :
    (l ++ e)[i]! = l[i]! := by
  rw [getElem!_pos (l ++ e) i (by simp; omega), getElem!_pos l i h, List.getElem_append_left]

private theorem sched_stable (W0 : List (BitVec 64)) (h : t < W0.length + n) (k : Nat) :
    (sched W0 (n + k))[t]! = (sched W0 n)[t]! := by
  induction k with
  | zero => rfl
  | succ k ih =>
    rw [← Nat.add_assoc, sched_succ, getElem!_append_left (by rw [length_sched]; omega), ih]

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
    (schedule B)[t]! = sigma1 (schedule B)[t - 2]! + (schedule B)[t - 7]! +
      sigma0 (schedule B)[t - 15]! + (schedule B)[t - 16]! := by
  change (sched ((List.range 16).map (word B)) 64)[t]! = _
  obtain ⟨n, rfl⟩ : ∃ n, t = 16 + n := ⟨t - 16, by omega⟩
  have hl : ((List.range 16).map (word B)).length = 16 := by simp
  have hg (t : Nat) (ht : t < 16 + n) : (schedule B)[t]! = (sched _ n)[t]! :=
    sched_le _ (by omega) (by omega)
  rw [hg _ (by omega), hg _ (by omega), hg _ (by omega), hg _ (by omega),
    sched_le (n := n + 1) _ (by omega) (by omega), sched_succ,
    getElem!_pos _ (16 + n) (by simp [length_sched]), List.getElem_append_right
      (by simp [length_sched])]
  simp only [length_sched, hl, Nat.sub_self, List.getElem_cons_zero]
  rw [show 16 + n - 2 = n + 14 by omega, show 16 + n - 7 = n + 9 by omega,
    show 16 + n - 15 = n + 1 by omega, show 16 + n - 16 = n by omega]

end Sha512

/-! ## `fd_sha512_core_ref` -/

namespace fd_sha512_core_ref

open Sha512 (schedule)

private theorem Sigma0_ref (x : BitVec 64) : Sigma0 x = Sha512.Sigma0 x := by
  simp only [Sigma0, Sha512.Sigma0, ROTR, fd_ulong_rotate_right.spec]; bv_decide

private theorem Sigma1_ref (x : BitVec 64) : Sigma1 x = Sha512.Sigma1 x := by
  simp only [Sigma1, Sha512.Sigma1, ROTR, fd_ulong_rotate_right.spec]; bv_decide

private theorem sigma0_ref (x : BitVec 64) : sigma0 x = Sha512.sigma0 x := by
  simp only [sigma0, Sha512.sigma0, ROTR, fd_ulong_rotate_right.spec]; bv_decide

private theorem sigma1_ref (x : BitVec 64) : sigma1 x = Sha512.sigma1 x := by
  simp only [sigma1, Sha512.sigma1, ROTR, fd_ulong_rotate_right.spec]; bv_decide

private theorem round_ref (v : Vector (BitVec 64) 8) (x k : BitVec 64) :
    round v x k = Sha512.round v k x := by
  have e (a b c d : BitVec 64) : x + a + b + c + d = a + b + c + d + x := by ac_rfl
  simp only [round, Sha512.round, Sigma0_ref, Sigma1_ref, e]
  rfl

private theorem word_ref (block : BitVec 1024) (h : t < 16) :
    Sha512.word (bytesLE block) t = fd_ulong_bswap.spec (block.extractLsb' (64 * t) 64) := by
  have e (b : Nat) (hb : b + 8 ≤ 64) :
      (block.extractLsb' (64 * t) 64).extractLsb' b 8 = block.extractLsb' (64 * t + b) 8 := by
    apply BitVec.eq_of_getLsbD_eq
    intro j hj
    simp [BitVec.getLsbD_extractLsb', show b + j < 64 by omega, Nat.add_assoc]
  simp (disch := omega) only [Sha512.word, getElem!_bytesLE, fd_ulong_bswap.spec, e]
  rw [show 8 * (8 * t) = 64 * t + 0 by omega, show 8 * (8 * t + 1) = 64 * t + 8 by omega,
    show 8 * (8 * t + 2) = 64 * t + 16 by omega, show 8 * (8 * t + 3) = 64 * t + 24 by omega,
    show 8 * (8 * t + 4) = 64 * t + 32 by omega, show 8 * (8 * t + 5) = 64 * t + 40 by omega,
    show 8 * (8 * t + 6) = 64 * t + 48 by omega, show 8 * (8 * t + 7) = 64 * t + 56 by omega]

private theorem K_ref (h : i < 80) : K[i] = Sha512.K[i]! := by
  rw [getElem!_pos Sha512.K i h]
  rfl

private theorem loop1_ref (block : BitVec 1024) (i : Nat) (v : Vector (BitVec 64) 8)
    (hi : i ≤ 16) :
    loop1 block i v = (List.range' i (16 - i)).foldl
      (fun v t => Sha512.round v Sha512.K[t]! (schedule (bytesLE block))[t]!) v := by
  rw [loop1]
  split
  · rename_i h
    rw [loop1_ref block (i + 1) _ (by omega), show 16 - i = 16 - (i + 1) + 1 by omega,
      List.range'_succ, List.foldl_cons, round_ref, K_ref (by omega),
      Sha512.getElem!_schedule_lt _ h, word_ref block h]
  · rw [show 16 - i = 0 by omega]
    rfl
termination_by 16 - i

private theorem loop2_ref (block : BitVec 1024) (i : Nat) (v : Vector (BitVec 64) 8)
    (X : Vector (BitVec 64) 16) (hi : 16 ≤ i) (hi' : i ≤ 80)
    (hX : ∀ j < 16, X[(i + j) % 16] = (schedule (bytesLE block))[i - 16 + j]!) :
    loop2 i v X = (List.range' i (80 - i)).foldl
      (fun v t => Sha512.round v Sha512.K[t]! (schedule (bytesLE block))[t]!) v := by
  rw [loop2]
  split
  · rename_i h
    have hx : xNext X i = (schedule (bytesLE block))[i]! := by
      have h0 := hX 0 (by omega)
      simp only [Nat.add_zero] at h0
      rw [xNext, sigma0_ref, sigma1_ref, h0, hX 1 (by omega), hX 9 (by omega), hX 14 (by omega),
        Sha512.getElem!_schedule_ge _ (by omega) h, show i - 16 + 1 = i - 15 by omega,
        show i - 16 + 9 = i - 7 by omega, show i - 16 + 14 = i - 2 by omega]
      have e (a b c d : BitVec 64) : a + (b + c + d) = c + d + b + a := by ac_rfl
      exact e _ _ _ _
    rw [loop2_ref block (i + 1) _ _ (by omega) (by omega), show 80 - i = 80 - (i + 1) + 1 by omega,
      List.range'_succ, List.foldl_cons, hx, round_ref, K_ref h]
    intro j hj
    rw [Vector.getElem_set]
    split
    · obtain rfl : j = 15 := by omega
      rw [hx, show i + 1 - 16 + 15 = i by omega]
    · have := hX (j + 1) (by omega)
      simp only [show i + (j + 1) = i + 1 + j by omega,
        show i - 16 + (j + 1) = i + 1 - 16 + j by omega] at this
      exact this
  · rw [show 80 - i = 0 by omega]
    rfl
termination_by 80 - i

/-- One block, its bytes read little-endian: FIPS compression. -/
public theorem compress_eq (state : Vector (BitVec 64) 8) (block : BitVec 1024) :
    compress state block = Sha512.compress state (bytesLE block) := by
  have hX : ∀ j < 16, (X0 block)[(16 + j) % 16] = (schedule (bytesLE block))[16 - 16 + j]! := by
    intro j hj
    simp only [show (16 + j) % 16 = j by omega, Nat.sub_self, Nat.zero_add, X0,
      Vector.getElem_ofFn, ← word_ref block hj, Sha512.getElem!_schedule_lt _ hj]
  have hr : List.range 80 = List.range' 0 16 ++ List.range' 16 64 := by
    rw [List.range_eq_range', List.range'_append]
  rw [compress, Sha512.compress, loop1_ref _ _ _ (by omega), loop2_ref _ _ _ _ (by omega) (by omega)
    hX]
  simp only [hr, List.foldl_append]
  generalize List.foldl _ _ _ = v
  ext i hi
  simp only [addWords, Vector.getElem_zipWith]
  match i, hi with
  | 0, _ | 1, _ | 2, _ | 3, _ | 4, _ | 5, _ | 6, _ | 7, _ => rfl

private theorem compressFrom_eq (data : BitVec w) (hw : w % 8 = 0) :
    ∀ n j st, 1024 * (j + n) ≤ w →
      compressFrom data j n st =
        Sha512.compressBlocks st (((bytesLE data).drop (128 * j)).take (128 * n))
  | 0, j, st, _ => by
    rw [compressFrom, Nat.mul_zero, List.take_zero, Sha512.compressBlocks_of_lt (by simp)]
  | n + 1, j, st, h => by
    rw [compressFrom, compressFrom_eq data hw n (j + 1) _ (by omega), compress_eq,
      bytesLE_extractLsb' _ (by omega) (by omega) (by omega),
      Sha512.compressBlocks_of_le (l := List.take (128 * (n + 1)) _)
        (by simp only [List.length_take, List.length_drop, length_bytesLE]; omega),
      List.take_take, List.drop_take, List.drop_drop, show 1024 * j / 8 = 128 * j by omega,
      show min 128 (128 * (n + 1)) = 1024 / 8 by omega, show 128 * (n + 1) - 128 = 128 * n by omega,
      show 128 * j + 128 = 128 * (j + 1) by omega]

/-- The code's blocks, their bytes read little-endian: FIPS compression of each in turn. -/
public theorem spec_eq (state : Vector (BitVec 64) 8) {n : Nat} (data : BitVec (1024 * n)) :
    fd_sha512_core_ref.spec state data = Sha512.compressBlocks state (bytesLE data) := by
  rw [fd_sha512_core_ref.spec, compressFrom_eq data (by omega) n 0 state (by omega), Nat.mul_zero,
    List.drop_zero, List.take_of_length_le (by simp; omega)]

/-- `spec_eq` on one block. -/
public theorem spec_one (state : Vector (BitVec 64) 8) (block : BitVec 1024) :
    fd_sha512_core_ref.spec (n := 1) state block =
      Sha512.compressBlocks state (bytesLE block) :=
  spec_eq (n := 1) state block

end fd_sha512_core_ref

/-! ## The hash object -/

/-- `sha` has absorbed the bytes `m`: their whole blocks compressed from `IV`, the rest buffered,
their bit length counted mod `2^128`. -/
public structure _root_.LeanMLIR.RIR.ShaState.Absorbed (sha : ShaState) (m : List (BitVec 8)) :
    Prop where
  state : sha.state = Sha512.compressBlocks Sha512.IV m
  bufUsed : sha.bufUsed.toNat = m.length % 128
  buf : (bytesLE sha.buf).take (m.length % 128) = m.drop (m.length / 128 * 128)
  bitCnt : sha.bitCntHi ++ sha.bitCntLo = BitVec.ofNat 128 (8 * m.length)

/-- `init`'s object has absorbed nothing. -/
public theorem _root_.LeanMLIR.RIR.ShaState.absorbed_init (buf0 : BitVec 1024) :
    ShaState.Absorbed ⟨buf0, sha512IV, 0#64, 0#64, 0#64⟩ [] := by
  refine ⟨?_, rfl, rfl, ?_⟩
  · rw [Sha512.compressBlocks_of_lt (by simp)]
    rfl
  · show 0#64 ++ 0#64 = 0#128
    exact BitVec.eq_of_toNat_eq (by simp)

namespace fd_sha512_append

private theorem toNat_and_127 (n : BitVec 64) : (n &&& 127#64).toNat = n.toNat % 128 := by
  rw [BitVec.toNat_and, show (127#64).toNat = 2 ^ 7 - 1 from rfl, Nat.and_two_pow_sub_one_eq_mod]

private theorem toNat_ushiftRight_7 (n : BitVec 64) : (n >>> 7).toNat = n.toNat / 128 := by
  rw [BitVec.toNat_ushiftRight, Nat.shiftRight_eq_div_pow]

/-- `append`'s bit count: 128-bit addition of `8 sz`. -/
private theorem bitCnt_add (hi lo sz : BitVec 64) :
    (hi + (sz >>> 61) + (BitVec.ofBool ((lo + (sz <<< 3)).ult lo)).setWidth 64) ++
        (lo + (sz <<< 3)) = (hi ++ lo) + BitVec.ofNat 128 (8 * sz.toNat) := by
  have e : BitVec.ofNat 128 (8 * sz.toNat) = sz.setWidth 128 <<< 3 := by
    apply BitVec.eq_of_toNat_eq
    simp only [BitVec.toNat_ofNat, BitVec.toNat_shiftLeft, BitVec.toNat_setWidth]
    have := sz.isLt
    rw [Nat.mod_eq_of_lt (by omega), Nat.shiftLeft_eq, Nat.mod_eq_of_lt (by omega),
      Nat.mod_eq_of_lt (by omega)]
    omega
  rw [e]
  bv_decide

private theorem leftover_state (s : ShaState) (sz : BitVec 64) (data : BitVec (8 * sz.toNat)) :
    (leftover s sz data).state = s.state ∧ (leftover s sz data).bitCntHi = s.bitCntHi ∧
      (leftover s sz data).bitCntLo = s.bitCntLo := by
  unfold leftover
  dsimp only
  split <;> exact ⟨rfl, rfl, rfl⟩

/-- `leftover` from an empty buffer buffers the bytes past the whole blocks. -/
private theorem leftover_buf (s : ShaState) (sz : BitVec 64) (data : BitVec (8 * sz.toNat))
    (hu : s.bufUsed = 0#64) :
    (leftover s sz data).bufUsed.toNat = sz.toNat % 128 ∧
      (bytesLE (leftover s sz data).buf).take (sz.toNat % 128) =
        (bytesLE data).drop (sz.toNat / 128 * 128) := by
  unfold leftover
  dsimp only
  split
  · rename_i h
    have h127 := toNat_and_127 sz
    refine ⟨h127, ?_⟩
    have := take_bytesLE_copy (buf := s.buf) (P := []) (by simp) (off := 0#64) rfl
      (data.extractLsb' (1024 * (sz >>> 7).toNat) (8 * (sz &&& 127#64).toNat))
      (by rw [h127]; simp only [List.length_nil]; omega)
    rw [List.length_nil, Nat.zero_add, List.nil_append] at this
    have hs := toNat_ushiftRight_7 sz
    rw [← h127]
    dsimp only
    rw [this, bytesLE_extractLsb' _ (by omega) (by omega) (by rw [hs, h127]; omega), hs, h127,
      List.take_of_length_le (by simp; omega)]
    congr 1
    omega
  · rename_i h
    have h0 : sz.toNat % 128 = 0 := by
      rw [← toNat_and_127, Decidable.not_not.mp h]
      rfl
    refine ⟨by rw [hu, h0]; rfl, ?_⟩
    rw [h0, List.take_zero, eq_comm, List.drop_eq_nil_iff, length_bytesLE]
    omega

/-- `bulk` from an empty buffer, after whole blocks `m`, with the counts already added. -/
private theorem bulk_absorbed {sha : ShaState} {m : List (BitVec 8)} (sz : BitVec 64)
    (data : BitVec (8 * sz.toNat)) (hm : m.length % 128 = 0)
    (hs : sha.state = Sha512.compressBlocks Sha512.IV m) (hu : sha.bufUsed = 0#64)
    (hc : sha.bitCntHi ++ sha.bitCntLo = BitVec.ofNat 128 (8 * (m.length + sz.toNat))) :
    (bulk sha sz data).Absorbed (m ++ bytesLE data) := by
  have hD : (bytesLE data).length = sz.toNat := by simp
  have hb := toNat_ushiftRight_7 sz
  obtain ⟨s, hbulk, hss, hsu, hsh, hsl⟩ : ∃ s : ShaState, bulk sha sz data = leftover s sz data ∧
      s.state = Sha512.compressBlocks Sha512.IV (m ++ bytesLE data) ∧ s.bufUsed = 0#64 ∧
      s.bitCntHi = sha.bitCntHi ∧ s.bitCntLo = sha.bitCntLo := by
    refine ⟨_, rfl, ?_, ?_, ?_, ?_⟩ <;> try dsimp only
    · rw [Sha512.compressBlocks_append _ hm, ← hs, Sha512.compressBlocks_take, hD]
      split
      · show fd_sha512_core_ref.spec _ _ = _
        rw [fd_sha512_core_ref.spec_eq, bytesLE_setWidth _ (by omega) (by rw [hb]; omega), hb]
        congr 2
        omega
      · rename_i h
        have h0 : sz.toNat / 128 = 0 := by
          rw [← hb, Decidable.not_not.mp h]
          rfl
        rw [h0, Nat.zero_mul, List.take_zero, Sha512.compressBlocks_of_lt (by simp)]
    all_goals split <;> first | rfl | exact hu
  obtain ⟨h1, h2, h3⟩ := leftover_state s sz data
  obtain ⟨h4, h5⟩ := leftover_buf s sz data hsu
  have e1 : (m ++ bytesLE data).length % 128 = sz.toNat % 128 := by simp; omega
  have e2 : (m ++ bytesLE data).length / 128 * 128 = m.length + sz.toNat / 128 * 128 := by
    simp; omega
  rw [hbulk]
  refine ⟨h1.trans hss, by rw [h4, e1], ?_, ?_⟩
  · rw [e1, h5, e2, List.drop_length_add_append]
  · rw [h2, h3, hsh, hsl, hc, List.length_append, hD]

end fd_sha512_append

open fd_sha512_append in
/-- `append` absorbs `data`'s bytes. -/
public theorem _root_.LeanMLIR.RIR.ShaState.Absorbed.append {sha : ShaState}
    {m : List (BitVec 8)} (h : sha.Absorbed m) (sz : BitVec 64) (data : BitVec (8 * sz.toNat)) :
    (fd_sha512_append.spec sha sz data).Absorbed (m ++ bytesLE data) := by
  have hD : (bytesLE data).length = sz.toNat := by simp
  have hc := bitCnt_add sha.bitCntHi sha.bitCntLo sz
  rw [h.bitCnt, ← BitVec.ofNat_add, ← Nat.mul_add] at hc
  have hu := h.bufUsed
  unfold fd_sha512_append.spec
  dsimp only
  split
  · rename_i h0
    have : bytesLE data = [] := List.eq_nil_of_length_eq_zero (by rw [hD, h0]; rfl)
    rw [this, List.append_nil]
    exact h
  split
  · rename_i hsz hbu
    have hrem : (128#64 - sha.bufUsed).toNat = 128 - m.length % 128 := by
      rw [BitVec.toNat_sub_of_le (by rw [BitVec.le_def, hu]; simp; omega), hu]
      rfl
    have hL : 0 < m.length % 128 := by
      rw [← hu]
      have := mt BitVec.toNat_eq.mpr hbu
      simp only [BitVec.toNat_ofNat] at this
      omega
    have hP := h.buf
    have hPl : (m.drop (m.length / 128 * 128)).length = m.length % 128 := by simp; omega
    rw [← hPl] at hP
    split
    · rename_i hlt
      simp only [BitVec.ult, decide_eq_true_eq, hrem] at hlt
      have hcopy := take_bytesLE_copy hP (off := sha.bufUsed) (by rw [hu, hPl]) data
        (by rw [hPl]; omega)
      refine ⟨?_, ?_, ?_, by rw [List.length_append, hD]; exact hc⟩
      · show sha.state = _
        rw [h.state, Sha512.compressBlocks_append_short (by rw [hD]; omega)]
      · show (sha.bufUsed + sz).toNat = _
        rw [BitVec.toNat_add, hu]
        simp only [List.length_append, hD]
        omega
      · show (bytesLE (copy sha.buf sha.bufUsed data)).take ((m ++ bytesLE data).length % 128) = _
        rw [show (m ++ bytesLE data).length % 128 = (m.drop (m.length / 128 * 128)).length +
            sz.toNat by simp; omega, hcopy,
          show (m ++ bytesLE data).length / 128 * 128 = m.length / 128 * 128 by simp; omega,
          List.drop_append_of_le_length (by omega)]
    · rename_i hge
      simp only [BitVec.ult, decide_eq_true_eq, hrem, Nat.not_lt] at hge
      generalize hR : 128#64 - sha.bufUsed = R at *
      have hsub : (sz - R).toNat = sz.toNat - (128 - m.length % 128) := by
        rw [BitVec.toNat_sub_of_le (by rw [BitVec.le_def, hrem]; omega), hrem]
      have hcopy := take_bytesLE_copy hP (off := sha.bufUsed) (by rw [hu, hPl])
        (data.setWidth (8 * R.toNat)) (by rw [hPl, hrem]; omega)
      have hx : bytesLE (data.setWidth (8 * R.toNat)) = (bytesLE data).take (128 - m.length % 128)
          := by
        rw [bytesLE_setWidth _ (by omega) (by omega), hrem]
        congr 1
        omega
      rw [hx, show (m.drop (m.length / 128 * 128)).length + R.toNat = 128 by rw [hPl, hrem]; omega,
        List.take_of_length_le (by simp)] at hcopy
      have hy : bytesLE (data.extractLsb' (8 * R.toNat) (8 * (sz - R).toNat)) =
          (bytesLE data).drop (128 - m.length % 128) := by
        rw [bytesLE_extractLsb' _ (by omega) (by omega) (by rw [hsub, hrem]; omega), hsub, hrem,
          List.take_of_length_le (by simp)]
        congr 1
        omega
      rw [show m ++ bytesLE data = m ++ (bytesLE data).take (128 - m.length % 128) ++
          bytesLE (data.extractLsb' (8 * R.toNat) (8 * (sz - R).toNat)) by
        rw [hy, List.append_assoc, List.take_append_drop]]
      refine bulk_absorbed _ _ (by simp only [List.length_append, List.length_take, hD]; omega)
        ?_ rfl ?_
      · show fd_sha512_core_ref.spec (n := 1) sha.state (copy sha.buf sha.bufUsed _) = _
        rw [fd_sha512_core_ref.spec_one, hcopy]
        rw [h.state, Sha512.compressBlocks_take m]
        rw [show m ++ (bytesLE data).take (128 - m.length % 128) = m.take (m.length / 128 * 128) ++
            (m.drop (m.length / 128 * 128) ++ (bytesLE data).take (128 - m.length % 128)) by
          rw [← List.append_assoc, List.take_append_drop],
          Sha512.compressBlocks_append (a := m.take _) _ (by simp; omega)]
      · rw [hc]
        congr 2
        simp only [List.length_append, List.length_take, hD, hsub]
        omega
  · rename_i hsz hbu
    exact bulk_absorbed sz data (by rw [← hu, Decidable.not_not.mp hbu]; rfl) h.state
      (Decidable.not_not.mp hbu) hc

namespace fd_sha512_fini

open fd_sha512_append (copy)

/-- `last` after a known prefix `Q` of the buffer, `b = |Q|`: the block `Q`, zeros to byte 112,
the counts big-endian. -/
private theorem last_state (s : ShaState) (b : BitVec 64) (Q : List (BitVec 8))
    (hQ : (bytesLE s.buf).take Q.length = Q) (hb : b.toNat = Q.length) (hl : Q.length ≤ 112) :
    (last s b).state = Sha512.compressBlocks s.state (Q ++ List.replicate (112 - Q.length) 0#8 ++
      bytesLE (fd_ulong_bswap.spec s.bitCntHi) ++ bytesLE (fd_ulong_bswap.spec s.bitCntLo)) := by
  have hn : (112#64 - b).toNat = 112 - Q.length := by
    rw [BitVec.toNat_sub_of_le (by rw [BitVec.le_def, hb]; simp; omega), hb]
    rfl
  unfold last
  dsimp only
  rw [hn, fd_sha512_core_ref.spec_one]
  have h1 := take_bytesLE_copy hQ hb ((0#8).replicate (112 - Q.length)) (by omega)
  rw [bytesLE_replicate_zero, show Q.length + (112 - Q.length) =
    (Q ++ List.replicate (112 - Q.length) 0#8).length by simp] at h1
  have h2 := take_bytesLE_copy h1 (off := 112#64) (by simp; omega) (n := 8)
    (fd_ulong_bswap.spec s.bitCntHi) (by simp; omega)
  rw [show (Q ++ List.replicate (112 - Q.length) 0#8).length + 8 =
    (Q ++ List.replicate (112 - Q.length) 0#8 ++ bytesLE (fd_ulong_bswap.spec s.bitCntHi)).length
    by simp; omega] at h2
  have h3 := take_bytesLE_copy h2 (off := 120#64) (by simp; omega) (n := 8)
    (fd_ulong_bswap.spec s.bitCntLo) (by simp; omega)
  rw [show (Q ++ List.replicate (112 - Q.length) 0#8 ++
      bytesLE (fd_ulong_bswap.spec s.bitCntHi)).length + 8 = 128 by simp; omega,
    List.take_of_length_le (by simp)] at h3
  rw [h3]

/-- The counts' words byte-swapped: the bit length big-endian. -/
private theorem bytesBE_append (hi lo : BitVec 64) :
    Sha512.bytesBE (hi ++ lo) =
      bytesLE (fd_ulong_bswap.spec hi) ++ bytesLE (fd_ulong_bswap.spec lo) := by
  rw [Sha512.bytesBE, bytesLE_append _ _ (by decide), List.reverse_append, bytesLE_bswap,
    bytesLE_bswap]

/-- The digest's bytes: the state's words big-endian. -/
private theorem bytesLE_bits_bswap (v : Vector (BitVec 64) 8) :
    bytesLE (Words8.bits (v.map fd_ulong_bswap.spec)) = v.toList.flatMap Sha512.bytesBE := by
  obtain ⟨⟨l⟩, hl⟩ := v
  match l, hl with
  | [a, b, c, d, e, f, g, h], _ =>
    simp only [Words8.bits, Vector.map_mk, Vector.getElem_mk, List.map_toArray, List.map_cons,
      List.map_nil, List.getElem_toArray, List.getElem_cons_zero, List.getElem_cons_succ]
    rw [bytesLE_append _ _ (by decide), bytesLE_append _ _ (by decide),
      bytesLE_append _ _ (by decide), bytesLE_append _ _ (by decide),
      bytesLE_append _ _ (by decide), bytesLE_append _ _ (by decide),
      bytesLE_append _ _ (by decide)]
    simp [bytesLE_bswap, Sha512.bytesBE]

end fd_sha512_fini

open fd_sha512_fini in
/-- `fini` on an object that absorbed `m`: the digest's bytes are SHA-512 of `m`. -/
public theorem _root_.LeanMLIR.RIR.ShaState.Absorbed.fini {sha : ShaState} {m : List (BitVec 8)}
    (h : sha.Absorbed m) : bytesLE (Words8.bits (fd_sha512_fini.spec sha).2) = Sha512.digest m := by
  rw [Sha512.digest]
  suffices hs :
      (fd_sha512_fini.spec sha).1.state = Sha512.compressBlocks Sha512.IV (Sha512.pad m) by
    rw [← hs, ← bytesLE_bits_bswap]
    rfl
  have hu := h.bufUsed
  have hP := h.buf
  have hPl : (m.drop (m.length / 128 * 128)).length = m.length % 128 := by simp; omega
  rw [← hPl] at hP
  have h80 := take_bytesLE_copy hP (off := sha.bufUsed) (by rw [hu, hPl]) (n := 1) 0x80#8
    (by rw [hPl]; omega)
  rw [show bytesLE 0x80#8 = [0x80#8] from rfl] at h80
  have hb1 : (sha.bufUsed + 1#64).toNat = m.length % 128 + 1 := by
    rw [BitVec.toNat_add, hu]; simp; omega
  have hst : sha.state = Sha512.compressBlocks Sha512.IV (m.take (m.length / 128 * 128)) := by
    rw [h.state, Sha512.compressBlocks_take]
  rw [Sha512.pad, ← h.bitCnt, bytesBE_append]
  generalize hk : (239 - m.length % 128) % 128 = k
  have e := List.take_append_drop (m.length / 128 * 128) m
  simp only [List.append_assoc]
  rw [show ∀ X : List (BitVec 8), m ++ X = m.take (m.length / 128 * 128) ++
      (m.drop (m.length / 128 * 128) ++ X) by intro X; rw [← List.append_assoc, e],
    Sha512.compressBlocks_append (a := m.take _) _ (by simp; omega), ← hst]
  generalize m.drop (m.length / 128 * 128) = P at *
  clear e hst
  have hr : m.length % 128 < 128 := Nat.mod_lt _ (by decide)
  generalize m.length % 128 = r at *
  have h80' : (bytesLE (fd_sha512_append.copy sha.buf sha.bufUsed 128#8)).take
      (P ++ [128#8]).length = P ++ [128#8] := by
    rw [List.length_append, List.length_singleton]
    exact h80
  have h112 : (112#64).toNat = 112 := rfl
  unfold fd_sha512_fini.spec
  dsimp only
  split
  · rename_i hlt
    simp only [BitVec.ult, decide_eq_true_eq, hb1, h112] at hlt
    have hn : (128#64 - (sha.bufUsed + 1#64)).toNat = 127 - r := by
      rw [BitVec.toNat_sub_of_le (by rw [BitVec.le_def, hb1]; simp; omega), hb1]
      simp
    rw [hn]
    have h2 := take_bytesLE_copy h80' (off := sha.bufUsed + 1#64) (by rw [hb1]; simp; omega)
      ((0#8).replicate (127 - r)) (by simp; omega)
    rw [bytesLE_replicate_zero, show (P ++ [128#8]).length + (127 - r) = 128 by simp; omega,
      List.take_of_length_le (by simp)] at h2
    rw [last_state _ _ [] (by simp) (by simp) (by simp)]
    dsimp only
    rw [fd_sha512_core_ref.spec_one, h2, ← Sha512.compressBlocks_append _ (by simp; omega),
      show k = 127 - r + 112 by omega, List.replicate_add]
    simp only [List.append_assoc, List.nil_append, List.length_nil, Nat.sub_zero,
      List.cons_append]
  · rename_i hge
    simp only [BitVec.ult, decide_eq_true_eq, hb1, h112, Nat.not_lt] at hge
    rw [last_state _ _ (P ++ [128#8]) h80' (by rw [hb1]; simp; omega) (by simp; omega)]
    dsimp only
    rw [show k = 112 - (P ++ [128#8]).length by simp; omega]
    simp only [List.append_assoc, List.cons_append]

/-! ## `fd_ed25519_verify`'s hash -/

/-- `fd_ed25519_verify`'s digest is SHA-512 of `r ‖ publicKey ‖ msg`, whatever `buf0` holds. -/
public theorem fd_ed25519_verify.hash_eq (buf0 : BitVec 1024) (r publicKey : BitVec 256)
    (msgSz : BitVec 64) (msg : BitVec (8 * msgSz.toNat)) :
    bytesLE (Words8.bits (fd_ed25519_verify.hash buf0 r publicKey msgSz msg).2) =
      Sha512.digest (bytesLE r ++ bytesLE publicKey ++ bytesLE msg) := by
  have h := (((ShaState.absorbed_init buf0).append 32#64 r).append 32#64 publicKey).append msgSz msg
  rw [List.nil_append] at h
  exact h.fini

end LeanMLIR.RIR.Firedancer.Ref
