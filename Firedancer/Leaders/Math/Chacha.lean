module

public import Firedancer.Leaders.ChachaRng
public import Firedancer.Leaders.Math.Agave

/-! Both ChaCha20 block functions are RFC 8439's, and both RNGs read the same `u64` stream. -/

namespace Firedancer.Leaders.Math

open Firedancer.Leaders Agave

@[expose] public section

/-! ## RFC 8439 ChaCha20 -/

/-- The RFC 8439 quarter round (left rotations by 16, 12, 8, 7 as right rotations by 16, 20, 24,
25). -/
def qr (a b c d : BitVec 32) : BitVec 32 × BitVec 32 × BitVec 32 × BitVec 32 :=
  let a := a + b;
  let d := (d ^^^ a).rotateRight 16
  let c := c + d;
  let b := (b ^^^ c).rotateRight 20
  let a := a + b;
  let d := (d ^^^ a).rotateRight 24
  let c := c + d;
  let b := (b ^^^ c).rotateRight 25
  (a, b, c, d)

/-- The quarter round on state words `ia ib ic id`. -/
def qrAt (s : Vector (BitVec 32) 16) (ia ib ic id : Fin 16) : Vector (BitVec 32) 16 :=
  let r := qr s[ia] s[ib] s[ic] s[id]
  ((s.set ia r.1).set ib r.2.1 |>.set ic r.2.2.1).set id r.2.2.2

/-- A column round and a diagonal round. -/
def doubleRound (s : Vector (BitVec 32) 16) : Vector (BitVec 32) 16 :=
  let s := qrAt s 0 4 8 12
  let s := qrAt s 1 5 9 13
  let s := qrAt s 2 6 10 14
  let s := qrAt s 3 7 11 15
  let s := qrAt s 0 5 10 15
  let s := qrAt s 1 6 11 12
  let s := qrAt s 2 7 8 13
  let s := qrAt s 3 4 9 14
  s

/-- `n` double rounds. -/
def doubleRounds : Nat → Vector (BitVec 32) 16 → Vector (BitVec 32) 16
  | 0, s => s
  | n + 1, s => doubleRounds n (doubleRound s)

/-- The ChaCha constants. -/
def sigma : Vector (BitVec 32) 4 :=
  #v[0x61707865#32, 0x3320646e#32, 0x79622d32#32, 0x6b206574#32]

/-- The initial state: constants, key words `k`, counter/nonce row `d`. -/
def initState (k : Vector (BitVec 32) 8) (d : Vector (BitVec 32) 4) : Vector (BitVec 32) 16 :=
  #v[sigma[0], sigma[1], sigma[2], sigma[3], k[0], k[1], k[2], k[3], k[4], k[5], k[6], k[7], d[0],
    d[1], d[2], d[3]]

/-- The RFC 8439 ChaCha20 block (ten double rounds plus the input), as words. -/
def rfcBlock (k : Vector (BitVec 32) 8) (d : Vector (BitVec 32) 4) : Vector (BitVec 32) 16 :=
  let s0 := initState k d
  let s := doubleRounds 10 s0
  Vector.ofFn fun i => s[i] + s0[i]

/-- The counter row of block `b`: a 64-bit little-endian counter, nonce words 0. -/
def ctrRow (b : Nat) : Vector (BitVec 32) 4 :=
  #v[BitVec.ofNat 32 b, BitVec.ofNat 32 (b / 2 ^ 32), 0#32, 0#32]

/-- Word `p` of the ChaCha20 keystream for key words `k`: word `p % 16` of block `p / 16`. -/
def ksWord (k : Vector (BitVec 32) 8) (p : Nat) : BitVec 32 :=
  (rfcBlock k (ctrRow (p / 16)))[p % 16]

/-- The `u64` at word position `p`: words `p` and `p + 1`, little-endian. -/
def ks64 (k : Vector (BitVec 32) 8) (p : Nat) : BitVec 64 :=
  ksWord k (p + 1) ++ ksWord k p

/-- Byte `q` of the keystream. -/
def ksByte (k : Vector (BitVec 32) 8) (q : Nat) : BitVec 8 :=
  (ksWord k (q / 4)).extractLsb' (8 * (q % 4)) 8

/-! ## Firedancer's block -/

theorem fd_rotate_left_16 (x : BitVec 32) :
    fd_uint_rotate_left.spec x 16#32 = x.rotateRight 16 := by
  simp only [fd_uint_rotate_left.spec]
  ext i hi
  simp [BitVec.getElem_rotateRight, BitVec.getElem_or, BitVec.getElem_shiftLeft,
    BitVec.getElem_ushiftRight]
  by_cases h : i < 16
  · simp [h, BitVec.getLsbD_eq_getElem (show 16 + i < 32 by omega)]
  · simp [h, BitVec.getLsbD_of_ge x (16 + i) (by omega)]

theorem fd_rotate_left_12 (x : BitVec 32) :
    fd_uint_rotate_left.spec x 12#32 = x.rotateRight 20 := by
  simp only [fd_uint_rotate_left.spec]
  ext i hi
  simp [BitVec.getElem_rotateRight, BitVec.getElem_or, BitVec.getElem_shiftLeft,
    BitVec.getElem_ushiftRight]
  by_cases h : i < 12
  · simp [h, BitVec.getLsbD_eq_getElem (show 20 + i < 32 by omega)]
  · simp [h, BitVec.getLsbD_of_ge x (20 + i) (by omega)]

theorem fd_rotate_left_8 (x : BitVec 32) : fd_uint_rotate_left.spec x 8#32 = x.rotateRight 24 := by
  simp only [fd_uint_rotate_left.spec]
  ext i hi
  simp [BitVec.getElem_rotateRight, BitVec.getElem_or, BitVec.getElem_shiftLeft,
    BitVec.getElem_ushiftRight]
  by_cases h : i < 8
  · simp [h, BitVec.getLsbD_eq_getElem (show 24 + i < 32 by omega)]
  · simp [h, BitVec.getLsbD_of_ge x (24 + i) (by omega)]

theorem fd_rotate_left_7 (x : BitVec 32) : fd_uint_rotate_left.spec x 7#32 = x.rotateRight 25 := by
  simp only [fd_uint_rotate_left.spec]
  ext i hi
  simp [BitVec.getElem_rotateRight, BitVec.getElem_or, BitVec.getElem_shiftLeft,
    BitVec.getElem_ushiftRight]
  by_cases h : i < 7
  · simp [h, BitVec.getLsbD_eq_getElem (show 25 + i < 32 by omega)]
  · simp [h, BitVec.getLsbD_of_ge x (25 + i) (by omega)]

theorem fd_quarter_round_eq (a b c d : BitVec 32) :
    fd_chacha_quarter_round.spec a b c d = qr a b c d := by
  simp only [fd_chacha_quarter_round.spec, qr, fd_rotate_left_16, fd_rotate_left_12,
    fd_rotate_left_8, fd_rotate_left_7]

theorem fd_quarter_round_at_eq (s : Vector (BitVec 32) 16) (ia ib ic id : Fin 16) :
    fd_chacha_quarter_round.at s ia ib ic id = qrAt s ia ib ic id := by
  unfold fd_chacha_quarter_round.at qrAt; rw [fd_quarter_round_eq]

theorem fd_double_round_eq (s : Vector (BitVec 32) 16) :
    fd_chacha_block.double_round s = doubleRound s := by
  simp only [fd_chacha_block.double_round, doubleRound, fd_quarter_round_at_eq]

theorem fd_block_loop_eq (n : Nat) (s : Vector (BitVec 32) 16) :
    fd_chacha_block.loop n s = doubleRounds n s := by
  induction n generalizing s with
  | zero => rfl
  | succ n ih => simp only [fd_chacha_block.loop, ih, fd_double_round_eq, doubleRounds]

/-- `fd_chacha20_block` is the RFC 8439 block on the key's little-endian words. -/
theorem fd_chacha20_block_eq (key : Vector (BitVec 8) 32) (idx_nonce : Vector (BitVec 32) 4) :
    fd_chacha20_block.spec key idx_nonce =
      bytesOfUints (k := 16) (rfcBlock (uintsOfBytes (k := 8) key) idx_nonce) := by
  simp only [fd_chacha20_block.spec, fd_chacha_block.spec, rfcBlock, fd_block_loop_eq]
  rfl

/-! ## `rand_chacha`'s block -/

/-- The rows of a lane state as the 16 state words. -/
def toWords (x : State) : Vector (BitVec 32) 16 :=
  #v[x.a[0], x.a[1], x.a[2], x.a[3], x.b[0], x.b[1], x.b[2], x.b[3], x.c[0], x.c[1], x.c[2], x.c[3],
    x.d[0], x.d[1], x.d[2], x.d[3]]

/-- `round` is the RFC quarter round on each column. -/
theorem round_eq (x : State) :
    round x =
      { a := Vector.ofFn fun j => (qr x.a[j] x.b[j] x.c[j] x.d[j]).1
        b := Vector.ofFn fun j => (qr x.a[j] x.b[j] x.c[j] x.d[j]).2.1
        c := Vector.ofFn fun j => (qr x.a[j] x.b[j] x.c[j] x.d[j]).2.2.1
        d := Vector.ofFn fun j => (qr x.a[j] x.b[j] x.c[j] x.d[j]).2.2.2 } := by
  simp only [round, qr, u32x4.add, u32x4.xor, u32x4.rotr, Vector.getElem_ofFn, Fin.getElem_fin]

/-! ### Word-level form of the double round -/

theorem qrAt_0_4_8_12 (a0 a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11 a12 a13 a14 a15 : BitVec 32) :
    qrAt #v[a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15] 0 4 8 12 =
      #v[(qr a0 a4 a8 a12).1, a1, a2, a3, (qr a0 a4 a8 a12).2.1, a5, a6, a7,
        (qr a0 a4 a8 a12).2.2.1, a9, a10, a11, (qr a0 a4 a8 a12).2.2.2, a13, a14, a15] :=
  rfl

theorem qrAt_1_5_9_13 (a0 a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11 a12 a13 a14 a15 : BitVec 32) :
    qrAt #v[a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15] 1 5 9 13 =
      #v[a0, (qr a1 a5 a9 a13).1, a2, a3, a4, (qr a1 a5 a9 a13).2.1, a6, a7, a8,
        (qr a1 a5 a9 a13).2.2.1, a10, a11, a12, (qr a1 a5 a9 a13).2.2.2, a14, a15] :=
  rfl

theorem qrAt_2_6_10_14 (a0 a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11 a12 a13 a14 a15 : BitVec 32) :
    qrAt #v[a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15] 2 6 10 14 =
      #v[a0, a1, (qr a2 a6 a10 a14).1, a3, a4, a5, (qr a2 a6 a10 a14).2.1, a7, a8, a9,
        (qr a2 a6 a10 a14).2.2.1, a11, a12, a13, (qr a2 a6 a10 a14).2.2.2, a15] :=
  rfl

theorem qrAt_3_7_11_15 (a0 a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11 a12 a13 a14 a15 : BitVec 32) :
    qrAt #v[a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15] 3 7 11 15 =
      #v[a0, a1, a2, (qr a3 a7 a11 a15).1, a4, a5, a6, (qr a3 a7 a11 a15).2.1, a8, a9, a10,
        (qr a3 a7 a11 a15).2.2.1, a12, a13, a14, (qr a3 a7 a11 a15).2.2.2] :=
  rfl

theorem qrAt_0_5_10_15 (a0 a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11 a12 a13 a14 a15 : BitVec 32) :
    qrAt #v[a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15] 0 5 10 15 =
      #v[(qr a0 a5 a10 a15).1, a1, a2, a3, a4, (qr a0 a5 a10 a15).2.1, a6, a7, a8, a9,
        (qr a0 a5 a10 a15).2.2.1, a11, a12, a13, a14, (qr a0 a5 a10 a15).2.2.2] :=
  rfl

theorem qrAt_1_6_11_12 (a0 a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11 a12 a13 a14 a15 : BitVec 32) :
    qrAt #v[a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15] 1 6 11 12 =
      #v[a0, (qr a1 a6 a11 a12).1, a2, a3, a4, a5, (qr a1 a6 a11 a12).2.1, a7, a8, a9, a10,
        (qr a1 a6 a11 a12).2.2.1, (qr a1 a6 a11 a12).2.2.2, a13, a14, a15] :=
  rfl

theorem qrAt_2_7_8_13 (a0 a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11 a12 a13 a14 a15 : BitVec 32) :
    qrAt #v[a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15] 2 7 8 13 =
      #v[a0, a1, (qr a2 a7 a8 a13).1, a3, a4, a5, a6, (qr a2 a7 a8 a13).2.1,
        (qr a2 a7 a8 a13).2.2.1, a9, a10, a11, a12, (qr a2 a7 a8 a13).2.2.2, a14, a15] :=
  rfl

theorem qrAt_3_4_9_14 (a0 a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11 a12 a13 a14 a15 : BitVec 32) :
    qrAt #v[a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15] 3 4 9 14 =
      #v[a0, a1, a2, (qr a3 a4 a9 a14).1, (qr a3 a4 a9 a14).2.1, a5, a6, a7, a8,
        (qr a3 a4 a9 a14).2.2.1, a10, a11, a12, a13, (qr a3 a4 a9 a14).2.2.2, a15] :=
  rfl

/-- The column round on 16 words. -/
def colW (w : Vector (BitVec 32) 16) : Vector (BitVec 32) 16 :=
  #v[(qr w[0] w[4] w[8] w[12]).1, (qr w[1] w[5] w[9] w[13]).1, (qr w[2] w[6] w[10] w[14]).1,
    (qr w[3] w[7] w[11] w[15]).1, (qr w[0] w[4] w[8] w[12]).2.1, (qr w[1] w[5] w[9] w[13]).2.1,
    (qr w[2] w[6] w[10] w[14]).2.1, (qr w[3] w[7] w[11] w[15]).2.1, (qr w[0] w[4] w[8] w[12]).2.2.1,
    (qr w[1] w[5] w[9] w[13]).2.2.1, (qr w[2] w[6] w[10] w[14]).2.2.1,
    (qr w[3] w[7] w[11] w[15]).2.2.1, (qr w[0] w[4] w[8] w[12]).2.2.2,
    (qr w[1] w[5] w[9] w[13]).2.2.2, (qr w[2] w[6] w[10] w[14]).2.2.2,
    (qr w[3] w[7] w[11] w[15]).2.2.2]

/-- `diagonalize` on 16 words. -/
def permD (w : Vector (BitVec 32) 16) : Vector (BitVec 32) 16 :=
  #v[w[0], w[1], w[2], w[3], w[5], w[6], w[7], w[4], w[10], w[11], w[8], w[9], w[15], w[12], w[13],
    w[14]]

/-- `undiagonalize` on 16 words. -/
def permU (w : Vector (BitVec 32) 16) : Vector (BitVec 32) 16 :=
  #v[w[0], w[1], w[2], w[3], w[7], w[4], w[5], w[6], w[10], w[11], w[8], w[9], w[13], w[14], w[15],
    w[12]]

theorem doubleRound_eq (w : Vector (BitVec 32) 16) :
    doubleRound w = permU (colW (permD (colW w))) := by
  obtain ⟨⟨l⟩, h⟩ := w
  match l, h with
  | [a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15],
    _ =>
    simp only [doubleRound, qrAt_0_4_8_12, qrAt_1_5_9_13, qrAt_2_6_10_14, qrAt_3_7_11_15,
      qrAt_0_5_10_15, qrAt_1_6_11_12, qrAt_2_7_8_13, qrAt_3_4_9_14]
    rfl

theorem toWords_round (x : State) : toWords (round x) = colW (toWords x) := by
  rw [round_eq]; rfl

theorem toWords_diagonalize (x : State) : toWords (diagonalize x) = permD (toWords x) :=
  rfl

theorem toWords_undiagonalize (x : State) : toWords (undiagonalize x) = permU (toWords x) :=
  rfl

theorem toWords_double_round (x : State) :
    toWords (undiagonalize (round (diagonalize (round x)))) = doubleRound (toWords x) := by
  rw [doubleRound_eq, toWords_undiagonalize, toWords_round, toWords_diagonalize, toWords_round]

theorem toWords_rounds (n : Nat) (x : State) :
    toWords (rounds n x) = doubleRounds n (toWords x) := by
  induction n generalizing x with
  | zero => rfl
  | succ n ih => simp only [rounds, doubleRounds, ih, toWords_double_round]

theorem initState_eq (b c d : u32x4) : initState (b ++ c) d = toWords { a := kRow, b, c, d } := by
  obtain ⟨⟨lb⟩, hb⟩ := b; obtain ⟨⟨lc⟩, hc⟩ := c; obtain ⟨⟨ld⟩, hd⟩ := d
  match lb, hb, lc, hc, ld, hd with
  | [_, _, _, _], _, [_, _, _, _], _, [_, _, _, _], _ => rfl

/-- A `rand_chacha` lane block is the RFC 8439 block with key rows `b ++ c` and row `d`. -/
theorem refillLane_eq (st : ChaCha) (i : Fin 4) :
    refillLane st 10 i = rfcBlock (st.b ++ st.c) (d0123 st.d i) := by
  unfold refillLane rfcBlock
  generalize d0123 st.d i = d
  rw [initState_eq]
  simp only []
  rw [← toWords_rounds]
  generalize rounds 10 _ = y
  obtain ⟨⟨⟨lb⟩, hb⟩, ⟨⟨lc⟩, hc⟩, _⟩ := st
  obtain ⟨⟨ld⟩, hd⟩ := d
  obtain ⟨⟨⟨la'⟩, ha'⟩, ⟨⟨lb'⟩, hb'⟩, ⟨⟨lc'⟩, hc'⟩, ⟨⟨ld'⟩, hd'⟩⟩ := y
  match lb, hb, lc, hc, ld, hd, la', ha', lb', hb', lc', hc', ld', hd' with
  | [_, _, _, _], _, [_, _, _, _], _, [_, _, _, _], _, [_, _, _, _], _, [_, _, _, _], _,
    [_, _, _, _], _, [_, _, _, _], _ => rfl

end

end Firedancer.Leaders.Math
