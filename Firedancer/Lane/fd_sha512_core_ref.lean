module

public import MLIR.Run.Tactic
public import Firedancer.Ref.fd_sha512_core_ref
public import Firedancer.Lane.Mlir.fd_sha512_core_ref
import Std.Tactic.BVDecide

namespace MLIR.Firedancer.Lane

open Firedancer.Lane.Mlir
open Ref (fd_ulong_bswap.spec)
open Ref.fd_sha512_core_ref (K ROTR Sigma0 Sigma1 sigma0 sigma1 Ch Maj round X0 loop1 xNext loop2
  addWords compress compressFrom)
open Firedancer.Lane.Mlir.fd_sha512_core_ref (Γ)

/-! ## Shared -/

/-- `llvm.intr.bswap`'s byte loop computes `fd_ulong_bswap.spec`. -/
public theorem foldl_bswap_eq (x : BitVec 64) :
    (List.range 8).foldl (fun acc i => acc ||| (x >>> (8 * i) &&& 255#64) <<< (64 - 8 * (i + 1)))
        0#64 =
      fd_ulong_bswap.spec x := by
  simp only [List.range_succ, List.range_zero, List.nil_append, List.foldl_cons, List.foldl_nil,
    List.foldl_append, fd_ulong_bswap.spec]
  bv_decide

/-! ## Proof -/

section Proof

namespace fd_sha512_core_ref

/-! ### The code's forms of the spec's operations -/

/-- `llvm.intr.fshl x x k`: `x` rotated left by `k`. -/
abbrev rotl (x : BitVec 64) (k : Nat) : BitVec 64 :=
  ((x ++ x) <<< k).extractLsb' 64 64

theorem Sigma0_eq (x : BitVec 64) : rotl x 36 ^^^ rotl x 30 ^^^ rotl x 25 = Sigma0 x := by
  simp only [Sigma0, ROTR, Ref.fd_ulong_rotate_right.spec]
  bv_decide

theorem Sigma1_eq (x : BitVec 64) : rotl x 50 ^^^ rotl x 46 ^^^ rotl x 23 = Sigma1 x := by
  simp only [Sigma1, ROTR, Ref.fd_ulong_rotate_right.spec]
  bv_decide

theorem sigma0_eq (x : BitVec 64) : rotl x 63 ^^^ rotl x 56 ^^^ x >>> 7 = sigma0 x := by
  simp only [sigma0, ROTR, Ref.fd_ulong_rotate_right.spec]
  bv_decide

theorem sigma1_eq (x : BitVec 64) : rotl x 45 ^^^ rotl x 3 ^^^ x >>> 6 = sigma1 x := by
  simp only [sigma1, ROTR, Ref.fd_ulong_rotate_right.spec]
  bv_decide

theorem Ch_eq (x y z : BitVec 64) :
    x &&& y ||| z &&& (x ^^^ 18446744073709551615#64) = Ch x y z := by
  rw [Ch]; bv_decide

theorem Maj_eq (x y z : BitVec 64) : x &&& (y ^^^ z) ^^^ y &&& z = Maj x y z := by
  rw [Maj]; bv_decide

/-- `T1` in the first loop's order. -/
theorem T1_eq (x h e f g k : BitVec 64) :
    Ch e f g + h + Sigma1 e + x + k = x + h + Sigma1 e + Ch e f g + k := by ac_rfl

/-- `T1` in the second loop's order. -/
theorem T1_eq' (x h e f g k : BitVec 64) :
    Ch e f g + h + Sigma1 e + k + x = x + h + Sigma1 e + Ch e f g + k := by ac_rfl

theorem e_eq (x h e f g k d : BitVec 64) :
    x + h + Sigma1 e + Ch e f g + k + d = d + (x + h + Sigma1 e + Ch e f g + k) := by ac_rfl

theorem a_eq (x h e f g k a b c : BitVec 64) :
    Sigma0 a + Maj a b c + (x + h + Sigma1 e + Ch e f g + k) =
      x + h + Sigma1 e + Ch e f g + k + (Sigma0 a + Maj a b c) := by ac_rfl

theorem xNext_eq (x0 x1 x9 x14 : BitVec 64) :
    sigma0 x1 + x9 + x0 + sigma1 x14 = x0 + (sigma0 x1 + sigma1 x14 + x9) := by ac_rfl

/-! ### Offsets -/

theorem saddOverflow_ofNat {i k : Nat} (h : i + k < 2 ^ 63) :
    (BitVec.ofNat 64 i).saddOverflow (BitVec.ofNat 64 k) = false := by
  have hi : (BitVec.ofNat 64 i).toInt = i := by rw [BitVec.toInt_eq_toNat_of_lt] <;> simp <;> omega
  have hk : (BitVec.ofNat 64 k).toInt = k := by rw [BitVec.toInt_eq_toNat_of_lt] <;> simp <;> omega
  simp [BitVec.saddOverflow, hi, hk]
  omega

theorem uaddOverflow_ofNat {i k : Nat} (h : i + k < 2 ^ 64) :
    (BitVec.ofNat 64 i).uaddOverflow (BitVec.ofNat 64 k) = false := by
  simp [BitVec.uaddOverflow]
  omega

theorem eq_of_ofNat_eq {m n : Nat} (h : BitVec.ofNat 64 m = BitVec.ofNat 64 n) (hm : m < 2 ^ 64)
    (hn : n < 2 ^ 64) : m = n := by
  have := congrArg BitVec.toNat h
  simp only [BitVec.toNat_ofNat] at this
  omega

/-- `m & 0xf`, the slot of `X` round `m` uses: `m % 16`. -/
theorem and_15 (m : Nat) : BitVec.ofNat 64 m &&& 15#64 = BitVec.ofNat 64 (m % 16) := by
  apply BitVec.eq_of_toNat_eq
  rw [BitVec.toNat_and, show (15#64).toNat = 2 ^ 4 - 1 from rfl, Nat.and_two_pow_sub_one_eq_mod,
    BitVec.toNat_ofNat, BitVec.toNat_ofNat]
  omega

/-- `m & 1` of an even `m`. -/
theorem and_1 {m : Nat} (h : m % 2 = 0) : BitVec.ofNat 64 m &&& 1#64 = 0#64 := by
  apply BitVec.eq_of_toNat_eq
  rw [BitVec.toNat_and, show (1#64).toNat = 2 ^ 1 - 1 from rfl, Nat.and_two_pow_sub_one_eq_mod,
    BitVec.toNat_ofNat]
  simp only [BitVec.toNat_ofNat]
  omega

/-- `m | 1` of an even `m`: `m + 1`. -/
theorem or_1 {m : Nat} (h : m % 2 = 0) : BitVec.ofNat 64 m ||| 1#64 = BitVec.ofNat 64 (m + 1) := by
  rw [← BitVec.add_eq_or_of_and_eq_zero _ _ (and_1 h), BitVec.ofNat_add]

/-- `m & 0xe` of an even `m`: `m % 16`. -/
theorem and_14 {m : Nat} (h : m % 2 = 0) :
    BitVec.ofNat 64 m &&& 14#64 = BitVec.ofNat 64 (m % 16) := by
  rw [← and_15]
  have h1 := and_1 h
  generalize BitVec.ofNat 64 m = x at *
  bv_decide

theorem mod16_mod (m : Nat) : m % 16 % 18446744073709551616 = m % 16 :=
  Nat.mod_eq_of_lt (by omega)

theorem mod16_mul8_lt (m : Nat) : m % 16 * 8 < 18446744073709551616 := by omega

/-- `getelementptr` to slot `m % 16` of `X`. -/
theorem gep_slot {X : Pointer} (hX : X.offset = 0) (m : Nat) :
    Operation.gep { nuw := true } (.value (BitVec.ofNat 64 (m % 16 * 8))) (.value X) =
      .value (X.add (BitVec.ofNat 64 (m % 16 * 8))) := by
  rw [gep_value _ (.inl rfl)]
  simp [BitVec.uaddOverflow, hX]
  omega

/-- `getelementptr` by `8 * i` from a block's start. -/
theorem gep_of_offset_zero {p : Pointer} (hp : p.offset = 0) (i : Nat) :
    Operation.gep { nuw := true } (.value (BitVec.ofNat 64 (i * 8))) (.value p) =
      .value (p.add (BitVec.ofNat 64 (i * 8))) := by
  rw [gep_value _ (.inl rfl)]
  simp [BitVec.uaddOverflow, hp]
  omega

/-- `i << 3`, `W`'s byte offset of word `i`: `i * 8`. -/
theorem ofNat_shiftLeft_3 (i : Nat) : BitVec.ofNat 64 i <<< 3 = BitVec.ofNat 64 (i * 8) := by
  apply BitVec.eq_of_toNat_eq
  simp [BitVec.toNat_shiftLeft, Nat.shiftLeft_eq]

/-- `i << 3`'s `nuw` holds: no bit is shifted out. -/
theorem ofNat_mul8_ushiftRight_3 {i : Nat} (h : i < 16) :
    BitVec.ofNat 64 (i * 8) >>> 3 = BitVec.ofNat 64 i := by
  apply BitVec.eq_of_toNat_eq
  simp [BitVec.toNat_ushiftRight, Nat.shiftRight_eq_div_pow]
  omega

/-- `i << 3`'s `nsw` holds: the result's sign is clear. -/
theorem ofNat_mul8_sshiftRight_3 {i : Nat} (h : i < 16) :
    (BitVec.ofNat 64 (i * 8)).sshiftRight 3 = BitVec.ofNat 64 i := by
  rw [BitVec.sshiftRight_eq_of_msb_false
      (by
        simp [BitVec.msb_eq_decide]; omega),
    ← BitVec.ushiftRight_eq]
  exact ofNat_mul8_ushiftRight_3 h

/-- Slot `m % 16` of `X` fits. -/
theorem fits_slot {m : MemoryState} {X : Pointer} (hX : X.offset = 0) (h : Fits m X 1024)
    (k : Nat) : Fits m (X.add (BitVec.ofNat 64 (k % 16 * 8))) 64 :=
  Fits.add_of_le
    (by
      simp [BitVec.uaddOverflow, hX]; omega)
    (by
      simp; omega)
    h

/-- `K[i]` fits. -/
theorem fits_K {m : MemoryState} {Kp : Pointer} (hK : Kp.offset = 0) (h : Fits m Kp 5120) {i : Nat}
    (hi : i < 80) : Fits m (Kp.add (BitVec.ofNat 64 (i * 8))) 64 :=
  Fits.add_of_le
    (by
      simp [BitVec.uaddOverflow, hK]; omega)
    (by
      simp; omega)
    h

/-! ### The blocks' envs -/

/-- `^bb0`'s constants, which every later block reads. -/
abbrev consts (E : ⟪Γ⟫) : ⟪Γ⟫ :=
  E[%1 := .value 16#64, %2 := .value 56#64, %3 := .value 0#64, %4 :=
    .value 3#64, %5 := .value 50#64, %6 := .value 46#64, %7 := .value 23#64, %8 :=
    .value 18446744073709551615#64, %10 := .value 36#64, %11 := .value 30#64, %12 :=
    .value 25#64, %13 := .value 1#64, %14 := .value 2#64, %15 := .value 15#64, %16 :=
    .value 14#64, %17 := .value 63#64, %18 := .value 7#64, %19 := .value 45#64, %20 :=
    .value 6#64, %21 := .value 9#64, %22 := .value 10#64, %23 := .value 80#64]

/-- `^bb1`, a block's start: the constants, `K`, `X`, `&state[1 … 7]`, the state words
`h0 … h7` (also `a … h`), `W` and the blocks left. -/
abbrev hdr1 (st X Kp Wp : Pointer) (h0 h1 h2 h3 h4 h5 h6 h7 cnt : BitVec 64) (E : ⟪Γ⟫) : ⟪Γ⟫ :=
  (consts E)[%9 := .value Kp, %24 := .value X, %25 := .value (st.add 8#64), %26 :=
    .value (st.add 16#64), %27 := .value (st.add 24#64), %28 := .value (st.add 32#64), %29 :=
    .value (st.add 40#64), %30 := .value (st.add 48#64), %31 := .value (st.add 56#64), %40 :=
    .value h7, %41 := .value h6, %42 := .value h5, %43 := .value h4, %44 := .value h3, %45 :=
    .value h2, %46 := .value h1, %47 := .value h0, %48 := .value Wp, %49 := .value cnt]

/-- `hdr1` with the state words `H`. -/
abbrev hdr1v (st X Kp Wp : Pointer) (H : Vector (BitVec 64) 8) (cnt : BitVec 64) (E : ⟪Γ⟫) : ⟪Γ⟫ :=
  hdr1 st X Kp Wp H[0] H[1] H[2] H[3] H[4] H[5] H[6] H[7] cnt E

/-- `^bb2`, the first loop at round `i`, on `a … h`. -/
abbrev hdr2 (st X Kp Wp : Pointer) (H : Vector (BitVec 64) 8) (cnt : BitVec 64) (E : ⟪Γ⟫)
    (a b c d e f g h : BitVec 64) (i : Nat) : ⟪Γ⟫ :=
  (hdr1v st X Kp Wp H cnt E)[%50 := .value a, %51 := .value b, %52 := .value c, %53 := .value d,
    %54 := .value e, %55 := .value f, %56 := .value (BitVec.ofNat 64 i), %57 := .value h,
    %58 := .value g]

/-- `^bb3`, the second loop at round `i`, on `a … h`. -/
abbrev hdr3 (st X Kp Wp : Pointer) (H : Vector (BitVec 64) 8) (cnt : BitVec 64) (E : ⟪Γ⟫)
    (a b c d e f g h : BitVec 64) (i : Nat) : ⟪Γ⟫ :=
  (hdr1v st X Kp Wp H cnt E)[%126 := .value a, %127 := .value b, %128 := .value c, %129 :=
    .value d, %130 := .value e, %131 := .value f, %132 := .value (BitVec.ofNat 64 i), %133 :=
    .value h, %134 := .value g]


/-- `^bb4`, after the last round, with `a … h`. -/
abbrev exit3 (st X Kp Wp : Pointer) (h0 h1 h2 h3 h4 h5 h6 h7 cnt : BitVec 64) (E : ⟪Γ⟫)
    (a b c d e f g h : BitVec 64) : ⟪Γ⟫ :=
  (hdr1 st X Kp Wp h0 h1 h2 h3 h4 h5 h6 h7 cnt E)[%126 := .value c, %127 := .value d, %130 :=
    .value g, %131 := .value h, %188 := .value f, %189 := .value b, %243 := .value e, %244 :=
    .value a]

/-- `hdr2` on `a … h = v`. -/
abbrev hdr2v (st X Kp Wp : Pointer) (H : Vector (BitVec 64) 8) (cnt : BitVec 64) (E : ⟪Γ⟫)
    (v : Vector (BitVec 64) 8) (i : Nat) : ⟪Γ⟫ :=
  hdr2 st X Kp Wp H cnt E v[0] v[1] v[2] v[3] v[4] v[5] v[6] v[7] i

/-- `hdr3` on `a … h = v`. -/
abbrev hdr3v (st X Kp Wp : Pointer) (H : Vector (BitVec 64) 8) (cnt : BitVec 64) (E : ⟪Γ⟫)
    (v : Vector (BitVec 64) 8) (i : Nat) : ⟪Γ⟫ :=
  hdr3 st X Kp Wp H cnt E v[0] v[1] v[2] v[3] v[4] v[5] v[6] v[7] i

/-- `exit3` on `a … h = v`. -/
abbrev exit3v (st X Kp Wp : Pointer) (H : Vector (BitVec 64) 8) (cnt : BitVec 64) (E : ⟪Γ⟫)
    (v : Vector (BitVec 64) 8) : ⟪Γ⟫ :=
  exit3 st X Kp Wp H[0] H[1] H[2] H[3] H[4] H[5] H[6] H[7] cnt E v[0] v[1] v[2] v[3] v[4] v[5] v[6]
    v[7]

/-- `T1`, as the code computes it: `X[i] + h + Sigma1(e) + Ch(e, f, g) + K[i]`. -/
abbrev T1 (x h e f g k : BitVec 64) : BitVec 64 :=
  x + h + Sigma1 e + Ch e f g + k

/-- `T2 = Sigma0(a) + Maj(a, b, c)`. -/
abbrev T2 (a b c : BitVec 64) : BitVec 64 :=
  Sigma0 a + Maj a b c

/-- The new `X[i & 0xf]` from the old one `x0` and `X[(i + 1, 9, 14) & 0xf]`. -/
abbrev xNew (x0 x1 x9 x14 : BitVec 64) : BitVec 64 :=
  x0 + (sigma0 x1 + sigma1 x14 + x9)

theorem loop1_lt {block : BitVec 1024} {v : Vector (BitVec 64) 8} (h : i < 16) :
    loop1 block i v =
      loop1 block (i + 1) (round v (fd_ulong_bswap.spec (block.extractLsb' (64 * i) 64)) K[i]) := by
  rw [loop1]
  simp only [h, ↓reduceDIte]

theorem loop1_16 {block : BitVec 1024} {v : Vector (BitVec 64) 8} : loop1 block 16 v = v := by
  rw [loop1]
  simp

theorem loop2_lt {v : Vector (BitVec 64) 8} {Xv : Vector (BitVec 64) 16} (h : i < 80) :
    loop2 i v Xv = loop2 (i + 1) (round v (xNext Xv i) K[i]) (Xv.set (i % 16) (xNext Xv i)) := by
  rw [loop2]
  simp only [h, ↓reduceDIte]

theorem loop2_80 {v : Vector (BitVec 64) 8} {Xv : Vector (BitVec 64) 16} : loop2 80 v Xv = v := by
  rw [loop2]
  simp

/-! ### Memory: `K`, `W`, the slots of `X` -/

/-- `K[i]` read from the global's block. -/
theorem readAt_K {m : MemoryState} {Kp : Pointer} {hw : (Ty.array 80 (.bv 64)).width = 5120}
    (hf : Fits m Kp 5120) (ho : Kp.offset = 0)
    (h : m.readAt Kp 5120 = Ty.flatBits fd_sha512_core_ref_K.lit (hw := hw)) {i : Nat}
    (hi : i < 80) : m.readAt (Kp.add (BitVec.ofNat 64 (i * 8))) 64 = K[i] := by
  have hs : (Ty.bv 64).stride = 64 := rfl
  have hK : fd_sha512_core_ref_K.lit = K := by decide
  rw [MemoryState.readAt_add_of_readAt hf.inBounds
      (by
        simp [BitVec.uaddOverflow, ho]; omega)
      (by
        simp; omega)
      h,
    Ty.flatBits_eq, BitVec.extractLsb'_cast,
    show (BitVec.ofNat 64 (i * 8)).toNat * 8 = i * 64 by
      simp; omega,
    Ty.extractLsb'_flattenRaw_array _
      (by
        rw [hs]; omega)
      (by
        rw [hs, Nat.mul_mod_left]; decide)]
  simp only [hs, Nat.mul_mod_left, Nat.mul_div_cancel _ (by decide : 0 < 64),
    Ty.extractLsb'_flattenRaw_bv, hK, BitVec.extractLsb'_eq_self]

/-- Word `i` of a block, read where the block was read whole. -/
theorem readAt_word {m : MemoryState} {Wp : Pointer} (hf : Fits m Wp 1024)
    (ho : Wp.offset.toNat + 128 < 2 ^ 64) {block : BitVec 1024} (h : m.readAt Wp 1024 = block)
    {i : Nat} (hi : i < 16) :
    m.readAt (Wp.add (BitVec.ofNat 64 (i * 8))) 64 = block.extractLsb' (64 * i) 64 := by
  rw [MemoryState.readAt_add_of_readAt hf.inBounds
      (by
        simp [BitVec.uaddOverflow]; omega)
      (by
        simp; omega)
      h]
  congr 1
  simp
  omega

/-- The slot `k` of `X`. -/
abbrev slot (X : Pointer) (k : Nat) : Pointer :=
  X.add (BitVec.ofNat 64 (k * 8))

/-- `X` holds the words `Xv`. -/
abbrev HoldsX (m : MemoryState) (X : Pointer) (Xv : Vector (BitVec 64) 16) : Prop :=
  ∀ k (hk : k < 16), m.readAt (slot X k) 64 = Xv[k]

theorem slot_offsetInBits {X : Pointer} (hX : X.offset = 0) {k : Nat} (hk : k < 16) :
    (slot X k).offsetInBits = 64 * k := by
  simp [slot, Pointer.offsetInBits, Pointer.add, hX]
  omega

theorem readAt_slot_storeAt_self {m : MemoryState} {X : Pointer} (hX : X.offset = 0)
    (hf : Room m X 1024) {k : Nat} (hk : k < 16) (x : BitVec 64) :
    (m.storeAt (slot X k) x).readAt (slot X k) 64 = x :=
  MemoryState.readAt_storeAt_self
    (Room.add_of_le
      (by
        simp [BitVec.uaddOverflow, hX]; omega)
      (by
        simp; omega)
      hf)
    x

theorem readAt_slot_storeAt_ne {m : MemoryState} {X : Pointer} (hX : X.offset = 0) {j k : Nat}
    (hj : j < 16) (hk : k < 16) (hjk : j ≠ k) (x : BitVec 64) :
    (m.storeAt (slot X j) x).readAt (slot X k) 64 = m.readAt (slot X k) 64 := by
  apply MemoryState.readAt_storeAt_disjoint
  simp only [Range.Disjoint, Range.of, slot_offsetInBits hX hj, slot_offsetInBits hX hk]
  omega

/-- A store into slot `j` sets word `j`. -/
theorem HoldsX.store {m : MemoryState} {X : Pointer} {Xv : Vector (BitVec 64) 16}
    (hX : X.offset = 0) (hf : Room m X 1024) (h : HoldsX m X Xv) {j : Nat} (hj : j < 16)
    (x : BitVec 64) : HoldsX (m.storeAt (slot X j) x) X (Xv.set j x) := by
  intro k hk
  by_cases hjk : j = k
  · subst hjk
    rw [readAt_slot_storeAt_self hX hf hj, Vector.getElem_set_self]
  · rw [readAt_slot_storeAt_ne hX hj hk hjk, h k hk, Vector.getElem_set_ne _ _ hjk]

/-- The memory after the first loop's rounds `i … i + n - 1` stored
`X[i] = fd_ulong_bswap( W[i] )`. -/
def mem1 (X : Pointer) (block : BitVec 1024) : (i n : Nat) → MemoryState → MemoryState
  | _, 0, m => m
  | i, n + 1, m =>
    mem1 X block (i + 1) n
      (m.storeAt (slot X i) (fd_ulong_bswap.spec (block.extractLsb' (64 * i) 64)))

/-- The memory after the second loop's rounds `i … i + n - 1` stored their new `X[i & 0xf]`, from
`X = Xv`. -/
def mem2 (X : Pointer) : (i n : Nat) → Vector (BitVec 64) 16 → MemoryState → MemoryState
  | _, 0, _, m => m
  | i, n + 1, Xv, m =>
    mem2 X (i + 1) n (Xv.set (i % 16) (xNext Xv i) (Nat.mod_lt _ (by decide)))
      (m.storeAt (slot X (i % 16)) (xNext Xv i))

/-- `mem1`'s first two rounds, as one iteration of the first loop stores them. -/
theorem mem1_add_two {m : MemoryState} :
    mem1 X block i (n + 2) m =
      mem1 X block (i + 2) n
        ((m.storeAt (slot X i) (fd_ulong_bswap.spec (block.extractLsb' (64 * i) 64))).storeAt
          (slot X (i + 1)) (fd_ulong_bswap.spec (block.extractLsb' (64 * (i + 1)) 64))) :=
  rfl

/-- `mem2`'s first two rounds, as one iteration of the second loop stores them. -/
theorem mem2_add_two {m : MemoryState} :
    mem2 X i (n + 2) Xv m =
      mem2 X (i + 2) n
        ((Xv.set (i % 16) (xNext Xv i) (Nat.mod_lt _ (by decide))).set ((i + 1) % 16)
          (xNext (Xv.set (i % 16) (xNext Xv i) (Nat.mod_lt _ (by decide))) (i + 1))
          (Nat.mod_lt _ (by decide)))
        ((m.storeAt (slot X (i % 16)) (xNext Xv i)).storeAt (slot X ((i + 1) % 16))
          (xNext (Xv.set (i % 16) (xNext Xv i) (Nat.mod_lt _ (by decide))) (i + 1))) :=
  rfl

theorem room_mem1 {m : MemoryState} : Room (mem1 X block i n m) p w ↔ Room m p w := by
  induction n generalizing i m with
  | zero => rfl
  | succ n ih => simp [mem1, ih]

theorem room_mem2 {m : MemoryState} : Room (mem2 X i n Xv m) p w ↔ Room m p w := by
  induction n generalizing i Xv m with
  | zero => rfl
  | succ n ih => simp [mem2, ih]

theorem inBounds_mem1 {m : MemoryState} : InBounds (mem1 X block i n m) p w ↔ InBounds m p w := by
  induction n generalizing i m with
  | zero => rfl
  | succ n ih => simp [mem1, ih]

theorem inBounds_mem2 {m : MemoryState} : InBounds (mem2 X i n Xv m) p w ↔ InBounds m p w := by
  induction n generalizing i Xv m with
  | zero => rfl
  | succ n ih => simp [mem2, ih]

theorem Fits.mem1 {m : MemoryState} (h : Fits m p w) : Fits (mem1 X block i n m) p w := by
  induction n generalizing i m with
  | zero => exact h
  | succ n ih => exact ih h.storeAt

theorem Fits.mem2 {m : MemoryState} (h : Fits m p w) : Fits (mem2 X i n Xv m) p w := by
  induction n generalizing i Xv m with
  | zero => exact h
  | succ n ih => exact ih h.storeAt

theorem Room.mem1 {m : MemoryState} (h : Room m p w) : Room (mem1 X block i n m) p w :=
  room_mem1.2 h

theorem Room.mem2 {m : MemoryState} (h : Room m p w) : Room (mem2 X i n Xv m) p w :=
  room_mem2.2 h

theorem Writable.mem1 {m : MemoryState} (h : Writable m p) : Writable (mem1 X block i n m) p := by
  induction n generalizing i m with
  | zero => exact h
  | succ n ih => exact ih h.storeAt

theorem Writable.mem2 {m : MemoryState} (h : Writable m p) : Writable (mem2 X i n Xv m) p := by
  induction n generalizing i Xv m with
  | zero => exact h
  | succ n ih => exact ih h.storeAt

theorem InBounds.mem1 {m : MemoryState} (h : InBounds m p w) : InBounds (mem1 X block i n m) p w :=
  inBounds_mem1.2 h

theorem InBounds.mem2 {m : MemoryState} (h : InBounds m p w) : InBounds (mem2 X i n Xv m) p w :=
  inBounds_mem2.2 h

theorem Words8Fit.mem1 {m : MemoryState} (h : m.Words8Fit p) :
    (mem1 X block i n m).Words8Fit p := by
  induction n generalizing i m with
  | zero => exact h
  | succ n ih => exact ih h.storeAt

theorem Words8Fit.mem2 {m : MemoryState} (h : m.Words8Fit p) : (mem2 X i n Xv m).Words8Fit p := by
  induction n generalizing i Xv m with
  | zero => exact h
  | succ n ih => exact ih h.storeAt

/-- The first loop's stores from `X[i]` on into room for them: those words are known. -/
theorem fits_slot_mem1 {m : MemoryState} {X : Pointer} (hX : X.offset = 0) {k : Nat} (hk : k < 16)
    (hik : i ≤ k) (hkn : k < i + n) (h : Room m X 1024) :
    Fits (mem1 X block i n m) (slot X k) 64 := by
  induction n generalizing i m with
  | zero => omega
  | succ n ih =>
    rw [mem1]
    by_cases hki : k = i
    · subst hki
      have hr : Room m (slot X k) 64 :=
        Room.add_of_le
          (by
            simp [BitVec.uaddOverflow, hX]; omega)
          (by
            simp; omega)
          h
      exact Fits.mem1 (Fits.storeAt_self hr)
    · exact ih (by omega) (by omega) h.storeAt

/-- After the first loop into room for `X`, all of `X` is known. -/
theorem fits_mem1 {m : MemoryState} {X : Pointer} (hX : X.offset = 0) (h : Room m X 1024) :
    Fits (mem1 X block 0 16 m) X 1024 := by
  have hs (k : Nat) (hk : k < 16) :=
    fits_slot_mem1 (block := block) (i := 0) (n := 16) hX hk (by omega) (by omega) h
  have hov (k : Nat) (hk : k < 16) : ¬X.offset.uaddOverflow (BitVec.ofNat 64 (k * 8)) := by
    simp [BitVec.uaddOverflow, hX]; omega
  have key : ∀ j, 0 < j → j ≤ 16 → Fits (mem1 X block 0 16 m) X (64 * j) := by
    intro j
    induction j with
    | zero =>
      intro h0; omega
    | succ j ih =>
      intro _ hj
      rcases Nat.eq_zero_or_pos j with rfl | hj0
      · simpa [slot, Pointer.add] using hs 0 (by omega)
      · exact
          Fits.append (hov j (by omega))
            (by
              simp; omega)
            (by omega) (ih hj0 (by omega)) (hs j (by omega))
  exact key 16 (by omega) (Nat.le_refl _)

/-- Reads outside `X`'s block are unaffected by `mem1`. -/
theorem readAt_mem1 {m : MemoryState} (h : p.id ≠ X.id) :
    (mem1 X block i n m).readAt p w = m.readAt p w := by
  induction n generalizing i m with
  | zero => rfl
  | succ n ih =>
    rw [mem1, ih,
      MemoryState.readAt_storeAt_disjoint (p := slot X i) (Range.disjoint_of_id_ne h.symm)]

theorem readAt_mem2 {m : MemoryState} (h : p.id ≠ X.id) :
    (mem2 X i n Xv m).readAt p w = m.readAt p w := by
  induction n generalizing i Xv m with
  | zero => rfl
  | succ n ih =>
    rw [mem2, ih,
      MemoryState.readAt_storeAt_disjoint (p := slot X (i % 16)) (Range.disjoint_of_id_ne h.symm)]

theorem WF_mem1 {s : GlobalState} (h : s.WF) :
    ({ s with mem := mem1 X block i n s.mem } : GlobalState).WF := by
  induction n generalizing i s with
  | zero => exact h
  | succ n ih => exact ih (s := { s with mem := _ }) h.storeAt

theorem WF_mem2 {s : GlobalState} (h : s.WF) :
    ({ s with mem := mem2 X i n Xv s.mem } : GlobalState).WF := by
  induction n generalizing i Xv s with
  | zero => exact h
  | succ n ih => exact ih (s := { s with mem := _ }) h.storeAt

attribute [local mlir_transport] Fits.mem1 Fits.mem2 Room.mem1 Room.mem2 InBounds.mem1 InBounds.mem2
  Writable.mem1 Writable.mem2 Words8Fit.mem1 Words8Fit.mem2 WF_mem1 WF_mem2

attribute [local mlir_read] readAt_mem1 readAt_mem2

/-- A block's stores into `X` keep the state `WF`. -/
theorem WF_mem12 {s : GlobalState} (h : s.WF) :
    ({ s with mem := mem2 X i n Xv (mem1 X block i' n' s.mem) } : GlobalState).WF :=
  WF_mem2 (s := { s with mem := mem1 X block i' n' s.mem }) (WF_mem1 h)

/-- After the first loop, `X` holds the block's words, byte-swapped. -/
theorem holdsX_mem1 {m : MemoryState} {X : Pointer} (hX : X.offset = 0) (hf : Room m X 1024)
    (block : BitVec 1024) : HoldsX (mem1 X block 0 16 m) X (X0 block) := by
  suffices
    ∀ n i (m : MemoryState),
      i + n = 16 →
        Room m X 1024 →
        (∀ k (hk : k < 16), k < i → m.readAt (slot X k) 64 = (X0 block)[k]) →
        HoldsX (mem1 X block i n m) X (X0 block)
    from this 16 0 m rfl hf (fun _ _ hk => absurd hk (by omega))
  intro n
  induction n with
  | zero =>
    intro i m hi _ h k hk
    exact h k hk (by omega)
  | succ n ih =>
    intro i m hi hf h
    refine ih (i + 1) _ (by omega) hf.storeAt fun k hk hki' => ?_
    by_cases hki : k = i
    · subst hki
      rw [readAt_slot_storeAt_self hX hf hk, X0, Vector.getElem_ofFn]
    · rw [readAt_slot_storeAt_ne hX (by omega) hk (Ne.symm hki)]
      exact h k hk (by omega)

/-! ### The first loop -/

-- two rounds, 70 steps over an env past 100 writes: between 200000 and 300000 heartbeats
set_option maxHeartbeats 400000 in
/-- Two rounds of the first loop: `X[i] = fd_ulong_bswap( W[i] )` and the round on it, then the
same for `i + 1`; then `^bb3` after round `15`, else round `i + 2`. -/
theorem words_iter (st X Kp Wp : Pointer) (H : Vector (BitVec 64) 8) (cnt : BitVec 64) (i : Nat)
    (hi : i + 2 ≤ 16) (hev : i % 2 = 0) (a b c d e f g h w0 w1 k0 k1 : BitVec 64) (S : GlobalState)
    (E : ⟪Γ⟫) (R : PoisonOr (Vals [] × GlobalState)) (hwf : S.WF) (hX : X.offset = 0)
    (hKo : Kp.offset = 0) (hWo : Wp.offset.toNat + 128 < 2 ^ 64) (hXK : X.id ≠ Kp.id)
    (hXW : X.id ≠ Wp.id) (hXf : Room S.mem X 1024) (hKf : Fits S.mem Kp 5120)
    (hWf : Fits S.mem Wp 1024) (hw0 : S.mem.readAt (Wp.add (BitVec.ofNat 64 (i * 8))) 64 = w0)
    (hw1 : S.mem.readAt (Wp.add (BitVec.ofNat 64 ((i + 1) * 8))) 64 = w1)
    (hk0 : S.mem.readAt (Kp.add (BitVec.ofNat 64 (i * 8))) 64 = k0)
    (hk1 : S.mem.readAt (Kp.add (BitVec.ofNat 64 ((i + 1) * 8))) 64 = k1)
    (hexit :
      i + 2 = 16 →
        ∀ E' : ⟪Γ⟫,
          E'.args = E.args →
            fd_sha512_core_ref.runFrom
                (hdr3 st X Kp Wp H cnt E'
                  (T1 (fd_ulong_bswap.spec w1) g (d + T1 (fd_ulong_bswap.spec w0) h e f g k0) e f
                      k1 +
                    T2 (T1 (fd_ulong_bswap.spec w0) h e f g k0 + T2 a b c) a b)
                  (T1 (fd_ulong_bswap.spec w0) h e f g k0 + T2 a b c) a b
                  (c +
                    T1 (fd_ulong_bswap.spec w1) g (d + T1 (fd_ulong_bswap.spec w0) h e f g k0) e f
                      k1)
                  (d + T1 (fd_ulong_bswap.spec w0) h e f g k0) e f 16)
                3
                { S with
                  mem :=
                    (S.mem.storeAt (slot X i) (fd_ulong_bswap.spec w0)).storeAt (slot X (i + 1))
                      (fd_ulong_bswap.spec w1) } =
              R)
    (hback :
      i + 2 < 16 →
        ∀ E' : ⟪Γ⟫,
          E'.args = E.args →
            fd_sha512_core_ref.runFrom
                (hdr2 st X Kp Wp H cnt E'
                  (T1 (fd_ulong_bswap.spec w1) g (d + T1 (fd_ulong_bswap.spec w0) h e f g k0) e f
                      k1 +
                    T2 (T1 (fd_ulong_bswap.spec w0) h e f g k0 + T2 a b c) a b)
                  (T1 (fd_ulong_bswap.spec w0) h e f g k0 + T2 a b c) a b
                  (c +
                    T1 (fd_ulong_bswap.spec w1) g (d + T1 (fd_ulong_bswap.spec w0) h e f g k0) e f
                      k1)
                  (d + T1 (fd_ulong_bswap.spec w0) h e f g k0) e f (i + 2))
                2
                { S with
                  mem :=
                    (S.mem.storeAt (slot X i) (fd_ulong_bswap.spec w0)).storeAt (slot X (i + 1))
                      (fd_ulong_bswap.spec w1) } =
              R) :
    fd_sha512_core_ref.runFrom (hdr2 st X Kp Wp H cnt E a b c d e f g h i) 2 S = R := by
  have fw0 : Fits S.mem (Wp.add (BitVec.ofNat 64 (i * 8))) 64 :=
    Fits.add_of_le
      (by
        simp [BitVec.uaddOverflow]; omega)
      (by
        simp; omega)
      hWf
  have fw1 : Fits S.mem (Wp.add (BitVec.ofNat 64 ((i + 1) * 8))) 64 :=
    Fits.add_of_le
      (by
        simp [BitVec.uaddOverflow]; omega)
      (by
        simp; omega)
      hWf
  have fx0 : Room S.mem (X.add (BitVec.ofNat 64 (i * 8))) 64 :=
    Room.add_of_le
      (by
        simp [BitVec.uaddOverflow, hX]; omega)
      (by
        simp; omega)
      hXf
  have fx1 : Room S.mem (X.add (BitVec.ofNat 64 ((i + 1) * 8))) 64 :=
    Room.add_of_le
      (by
        simp [BitVec.uaddOverflow, hX]; omega)
      (by
        simp; omega)
      hXf
  have fk0 := fits_K hKo hKf (by omega : i < 80)
  have fk1 := fits_K hKo hKf (by omega : i + 1 < 80)
  have hi64 : i % 18446744073709551616 = i := Nat.mod_eq_of_lt (by omega)
  have hi8 : i * 8 < 18446744073709551616 := by omega
  have hj64 : (i + 1) % 18446744073709551616 = i + 1 := Nat.mod_eq_of_lt (by omega)
  have hj8 : (i + 1) * 8 < 18446744073709551616 := by omega
  have o2 := saddOverflow_ofNat (i := i) (k := 2) (by omega)
  have o2' := uaddOverflow_ofNat (i := i) (k := 2) (by omega)
  block_init
  -- X[i] = fd_ulong_bswap( FD_LOAD( ulong, W + i*sizeof(ulong) ) );
  step_pure [ofNat_shiftLeft_3, ofNat_mul8_ushiftRight_3 (by omega : i < 16),
    ofNat_mul8_sshiftRight_3 (by omega : i < 16)]
  step_pure [Nat.mod_eq_of_lt hi8, hi8]
  step_load consuming hw0
  step_pure [foldl_bswap_eq]
  step_pure [hi64, hi8, gep_of_offset_zero hX i]
  step_store
  -- ulong T1 = X[i] + h + Sigma1(e) + Ch(e, f, g) + K[i];
  iterate 4 step_pure
  step_pure [Sigma1_eq]
  iterate 3 step_pure
  step_pure [Ch_eq]
  step_pure [hi64, hi8, gep_of_offset_zero hKo i]
  step_load consuming hk0
  iterate 3 step_pure
  step_pure [T1_eq]
  -- ulong T2 = Sigma0(a) + Maj(a, b, c);
  iterate 4 step_pure
  step_pure [Sigma0_eq]
  iterate 3 step_pure
  step_pure [Maj_eq]
  step_pure
  -- e = d + T1; a = T1 + T2;
  step_pure [e_eq]
  step_pure [a_eq]
  -- the same for `i | 1`
  step_pure [and_1 hev, or_1 hev]
  step_pure [ofNat_shiftLeft_3, ofNat_mul8_ushiftRight_3 (by omega : i + 1 < 16),
    ofNat_mul8_sshiftRight_3 (by omega : i + 1 < 16)]
  step_pure [Nat.mod_eq_of_lt hj8, hj8]
  step_load consuming hw1
  step_pure [foldl_bswap_eq]
  step_pure [hj64, hj8, gep_of_offset_zero hX (i + 1)]
  step_store
  iterate 4 step_pure
  step_pure [Sigma1_eq]
  iterate 3 step_pure
  step_pure [Ch_eq]
  step_pure [hj64, hj8, gep_of_offset_zero hKo (i + 1)]
  step_load consuming hk1
  iterate 3 step_pure
  step_pure [T1_eq]
  iterate 4 step_pure
  step_pure [Sigma0_eq]
  iterate 3 step_pure
  step_pure [Maj_eq]
  step_pure
  step_pure [e_eq]
  step_pure [a_eq]
  -- i += 2, i < 16
  step_pure [o2, o2', ← BitVec.ofNat_add]
  step_pure
  finish_block
  · step_loop using hexit (eq_of_ofNat_eq hbr (by omega) (by decide))
  · step_loop using
      hback
        (by
          have := mt (congrArg (BitVec.ofNat 64)) hbr; omega)

/-- The first loop from round `i`, `2 n + 2` rounds left: `X[i …] = fd_ulong_bswap( W[i …] )`
stored, then `^bb3` on `loop1`'s working variables. -/
theorem words_loop (st X Kp Wp : Pointer) (H : Vector (BitVec 64) 8) (cnt : BitVec 64)
    (block : BitVec 1024) (R : PoisonOr (Vals [] × GlobalState)) (hX : X.offset = 0)
    (hKo : Kp.offset = 0) (hWo : Wp.offset.toNat + 128 < 2 ^ 64) (hXK : X.id ≠ Kp.id)
    (hXW : X.id ≠ Wp.id) {hw : (Ty.array 80 (.bv 64)).width = 5120} :
    ∀ n i (v : Vector (BitVec 64) 8) (S : GlobalState) (E : ⟪Γ⟫),
      i + 2 * n + 2 = 16 →
        i % 2 = 0 →
        S.WF →
        Room S.mem X 1024 →
        Fits S.mem Kp 5120 →
        Fits S.mem Wp 1024 →
        S.mem.readAt Wp 1024 = block →
        S.mem.readAt Kp 5120 = Ty.flatBits fd_sha512_core_ref_K.lit (hw := hw) →
        (∀ E' : ⟪Γ⟫,
          E'.args = E.args →
            fd_sha512_core_ref.runFrom (hdr3v st X Kp Wp H cnt E' (loop1 block i v) 16) 3
                { S with mem := mem1 X block i (2 * n + 2) S.mem } =
              R) →
        fd_sha512_core_ref.runFrom (hdr2v st X Kp Wp H cnt E v i) 2 S = R := by
  intro n
  induction n with
  | zero =>
    intro i v S E hi hev hwf hXf hKf hWf hW hKr hK
    refine
      words_iter st X Kp Wp H cnt i (by omega) hev v[0] v[1] v[2] v[3] v[4] v[5] v[6] v[7] _ _
        K[i] K[i + 1] S E R hwf hX hKo hWo hXK hXW hXf hKf hWf (readAt_word hWf hWo hW (by omega))
        (readAt_word hWf hWo hW (by omega)) (readAt_K hKf hKo hKr (by omega))
        (readAt_K hKf hKo hKr (by omega)) (fun _ E' hE' => ?_) (fun h => absurd h (by omega))
    have := hK E' hE'
    rw [loop1_lt (by omega), loop1_lt (by omega), show i + 1 + 1 = 16 by omega, loop1_16] at this
    exact this
  | succ n ih =>
    intro i v S E hi hev hwf hXf hKf hWf hW hKr hK
    refine
      words_iter st X Kp Wp H cnt i (by omega) hev v[0] v[1] v[2] v[3] v[4] v[5] v[6] v[7] _ _
        K[i] K[i + 1] S E R hwf hX hKo hWo hXK hXW hXf hKf hWf (readAt_word hWf hWo hW (by omega))
        (readAt_word hWf hWo hW (by omega)) (readAt_K hKf hKo hKr (by omega))
        (readAt_K hKf hKo hKr (by omega)) (fun h => absurd h (by omega)) (fun _ E' hE' => ?_)
    refine
      ih (i + 2)
        (round (round v (fd_ulong_bswap.spec (block.extractLsb' (64 * i) 64)) K[i])
          (fd_ulong_bswap.spec (block.extractLsb' (64 * (i + 1)) 64)) K[i + 1])
        { S with
          mem :=
            (S.mem.storeAt (slot X i) (fd_ulong_bswap.spec (block.extractLsb' (64 * i) 64))).storeAt
              (slot X (i + 1)) (fd_ulong_bswap.spec (block.extractLsb' (64 * (i + 1)) 64)) }
        E' (by omega) (by omega) hwf.storeAt.storeAt hXf.storeAt.storeAt hKf.storeAt.storeAt
        hWf.storeAt.storeAt ?_ ?_ fun E'' hE'' => ?_
    · rw [MemoryState.readAt_storeAt_disjoint (p := slot X (i + 1)) (Range.disjoint_of_id_ne hXW),
        MemoryState.readAt_storeAt_disjoint (p := slot X i) (Range.disjoint_of_id_ne hXW)]
      exact hW
    · rw [MemoryState.readAt_storeAt_disjoint (p := slot X (i + 1)) (Range.disjoint_of_id_ne hXK),
        MemoryState.readAt_storeAt_disjoint (p := slot X i) (Range.disjoint_of_id_ne hXK)]
      exact hKr
    · have := hK E'' (hE''.trans hE')
      rw [show 2 * (n + 1) + 2 = 2 * n + 2 + 2 by omega, mem1_add_two, loop1_lt (by omega),
        loop1_lt (by omega)] at this
      exact this

/-! ### The second loop -/

-- two rounds, 130 steps over an env past 150 writes: between 400000 and 600000 heartbeats
set_option maxHeartbeats 800000 in
/-- Two rounds of the second loop: for `i`, the four reads of `X`, its new word into `X[i & 0xf]`
and the round on it; the same for `i + 1` (reading after that store); then `^bb4` after round
`79`, else round `i + 2`. -/
theorem schedule_iter (st X Kp Wp : Pointer) (H : Vector (BitVec 64) 8) (cnt : BitVec 64) (i : Nat)
    (hi : i + 2 ≤ 80) (hev : i % 2 = 0)
    (a b c d e f g h x0 x1 x9 x14 y0 y1 y9 y14 k0 k1 : BitVec 64) (S : GlobalState) (E : ⟪Γ⟫)
    (R : PoisonOr (Vals [] × GlobalState)) (hwf : S.WF) (hX : X.offset = 0) (hKo : Kp.offset = 0)
    (hXK : X.id ≠ Kp.id) (hXf : Fits S.mem X 1024) (hXr : Room S.mem X 1024)
    (hKf : Fits S.mem Kp 5120)
    (h1 : S.mem.readAt (X.add (BitVec.ofNat 64 ((i + 1) % 16 * 8))) 64 = x1)
    (h14 : S.mem.readAt (X.add (BitVec.ofNat 64 ((i + 14) % 16 * 8))) 64 = x14)
    (h9 : S.mem.readAt (X.add (BitVec.ofNat 64 ((i + 9) % 16 * 8))) 64 = x9)
    (h0 : S.mem.readAt (X.add (BitVec.ofNat 64 (i % 16 * 8))) 64 = x0)
    (hk0 : S.mem.readAt (Kp.add (BitVec.ofNat 64 (i * 8))) 64 = k0)
    (g1 : (S.mem.storeAt (slot X (i % 16)) (xNew x0 x1 x9 x14)).readAt (slot X ((i + 2) % 16)) 64 =
      y1)
    (g14 :
      (S.mem.storeAt (slot X (i % 16)) (xNew x0 x1 x9 x14)).readAt (slot X ((i + 15) % 16)) 64 =
        y14)
    (g9 :
      (S.mem.storeAt (slot X (i % 16)) (xNew x0 x1 x9 x14)).readAt (slot X ((i + 10) % 16)) 64 = y9)
    (g0 : (S.mem.storeAt (slot X (i % 16)) (xNew x0 x1 x9 x14)).readAt (slot X ((i + 1) % 16)) 64 =
      y0)
    (hk1 : S.mem.readAt (Kp.add (BitVec.ofNat 64 ((i + 1) * 8))) 64 = k1)
    (hexit :
      i + 2 = 80 →
        ∀ E' : ⟪Γ⟫,
          E'.args = E.args →
            fd_sha512_core_ref.runFrom
                (exit3 st X Kp Wp H[0] H[1] H[2] H[3] H[4] H[5] H[6] H[7] cnt E'
                  (T1 (xNew y0 y1 y9 y14) g (d + T1 (xNew x0 x1 x9 x14) h e f g k0) e f k1 +
                    T2 (T1 (xNew x0 x1 x9 x14) h e f g k0 + T2 a b c) a b)
                  (T1 (xNew x0 x1 x9 x14) h e f g k0 + T2 a b c) a b
                  (c + T1 (xNew y0 y1 y9 y14) g (d + T1 (xNew x0 x1 x9 x14) h e f g k0) e f k1)
                  (d + T1 (xNew x0 x1 x9 x14) h e f g k0) e f)
                4
                { S with
                  mem :=
                    (S.mem.storeAt (slot X (i % 16)) (xNew x0 x1 x9 x14)).storeAt
                      (slot X ((i + 1) % 16)) (xNew y0 y1 y9 y14) } =
              R)
    (hback :
      i + 2 < 80 →
        ∀ E' : ⟪Γ⟫,
          E'.args = E.args →
            fd_sha512_core_ref.runFrom
                (hdr3 st X Kp Wp H cnt E'
                  (T1 (xNew y0 y1 y9 y14) g (d + T1 (xNew x0 x1 x9 x14) h e f g k0) e f k1 +
                    T2 (T1 (xNew x0 x1 x9 x14) h e f g k0 + T2 a b c) a b)
                  (T1 (xNew x0 x1 x9 x14) h e f g k0 + T2 a b c) a b
                  (c + T1 (xNew y0 y1 y9 y14) g (d + T1 (xNew x0 x1 x9 x14) h e f g k0) e f k1)
                  (d + T1 (xNew x0 x1 x9 x14) h e f g k0) e f (i + 2))
                3
                { S with
                  mem :=
                    (S.mem.storeAt (slot X (i % 16)) (xNew x0 x1 x9 x14)).storeAt
                      (slot X ((i + 1) % 16)) (xNew y0 y1 y9 y14) } =
              R) :
    fd_sha512_core_ref.runFrom (hdr3 st X Kp Wp H cnt E a b c d e f g h i) 3 S = R := by
  have f1 := fits_slot hX hXf (i + 1)
  have f14 := fits_slot hX hXf (i + 14)
  have f9 := fits_slot hX hXf (i + 9)
  have f0 := fits_slot hX hXf i
  have f1' := fits_slot hX hXf (i + 2)
  have f14' := fits_slot hX hXf (i + 15)
  have f9' := fits_slot hX hXf (i + 10)
  have fk0 := fits_K hKo hKf (by omega : i < 80)
  have fk1 := fits_K hKo hKf (by omega : i + 1 < 80)
  have hj64 : (i + 1) % 18446744073709551616 = i + 1 := Nat.mod_eq_of_lt (by omega)
  have hi8 : i * 8 < 18446744073709551616 := by omega
  have hi64 : i % 18446744073709551616 = i := Nat.mod_eq_of_lt (by omega)
  have hj8 : (i + 1) * 8 < 18446744073709551616 := by omega
  have o14 := saddOverflow_ofNat (i := i) (k := 14) (by omega)
  have o14' := uaddOverflow_ofNat (i := i) (k := 14) (by omega)
  have o9 := saddOverflow_ofNat (i := i) (k := 9) (by omega)
  have o9' := uaddOverflow_ofNat (i := i) (k := 9) (by omega)
  have o2 := saddOverflow_ofNat (i := i) (k := 2) (by omega)
  have o2' := uaddOverflow_ofNat (i := i) (k := 2) (by omega)
  have o15 := saddOverflow_ofNat (i := i) (k := 15) (by omega)
  have o15' := uaddOverflow_ofNat (i := i) (k := 15) (by omega)
  have o10 := saddOverflow_ofNat (i := i) (k := 10) (by omega)
  have o10' := uaddOverflow_ofNat (i := i) (k := 10) (by omega)
  block_init
  -- ulong s0 = X[(i +  1UL) & 0x0fUL];
  step_pure [and_1 hev, or_1 hev]
  step_pure [and_15]
  step_pure [mod16_mod, mod16_mul8_lt, gep_slot hX]
  step_load consuming h1
  -- ulong s1 = X[(i + 14UL) & 0x0fUL];
  step_pure [o14, o14', ← BitVec.ofNat_add]
  step_pure [and_14 (by omega : (i + 14) % 2 = 0)]
  step_pure [mod16_mod, mod16_mul8_lt, gep_slot hX]
  step_load consuming h14
  -- s0 = sigma0(s0); s1 = sigma1(s1);
  iterate 4 step_pure
  step_pure [sigma0_eq]
  iterate 4 step_pure
  step_pure [sigma1_eq]
  -- X[i & 0xfUL] += s0 + s1 + X[(i + 9UL) & 0xfUL];
  step_pure [o9, o9', ← BitVec.ofNat_add]
  step_pure [and_15]
  step_pure [mod16_mod, mod16_mul8_lt, gep_slot hX]
  step_load consuming h9
  step_pure [and_14 hev]
  step_pure [mod16_mod, mod16_mul8_lt, gep_slot hX]
  step_load consuming h0
  step_pure
  step_pure
  step_pure [xNext_eq]
  step_store
  replace g1 : S.mem.readAt (X.add (BitVec.ofNat 64 ((i + 2) % 16 * 8))) 64 = y1 := by
    rw [hS]; exact g1
  replace g14 : S.mem.readAt (X.add (BitVec.ofNat 64 ((i + 15) % 16 * 8))) 64 = y14 := by
    rw [hS]; exact g14
  replace g9 : S.mem.readAt (X.add (BitVec.ofNat 64 ((i + 10) % 16 * 8))) 64 = y9 := by
    rw [hS]; exact g9
  replace g0 : S.mem.readAt (X.add (BitVec.ofNat 64 ((i + 1) % 16 * 8))) 64 = y0 := by
    rw [hS]; exact g0
  -- ulong T1 = X[i & 0xfUL ] + h + Sigma1(e) + Ch(e, f, g) + K[i];
  iterate 4 step_pure
  step_pure [Sigma1_eq]
  iterate 3 step_pure
  step_pure [Ch_eq]
  step_pure [hi64, hi8, gep_of_offset_zero hKo i]
  step_load consuming hk0
  iterate 3 step_pure
  step_pure [T1_eq']
  -- ulong T2 = Sigma0(a) + Maj(a, b, c);
  iterate 4 step_pure
  step_pure [Sigma0_eq]
  iterate 3 step_pure
  step_pure [Maj_eq]
  step_pure
  -- e = d + T1; a = T1 + T2;
  step_pure [e_eq]
  step_pure [a_eq]
  -- the same for `i + 1`
  step_pure [o2, o2', ← BitVec.ofNat_add]
  step_pure [and_14 (by omega : (i + 2) % 2 = 0)]
  step_pure [mod16_mod, mod16_mul8_lt, gep_slot hX]
  step_load consuming g1
  step_pure [o15, o15', ← BitVec.ofNat_add]
  step_pure [and_15]
  step_pure [mod16_mod, mod16_mul8_lt, gep_slot hX]
  step_load consuming g14
  iterate 4 step_pure
  step_pure [sigma0_eq]
  iterate 4 step_pure
  step_pure [sigma1_eq]
  step_pure [o10, o10', ← BitVec.ofNat_add]
  step_pure [and_14 (by omega : (i + 10) % 2 = 0)]
  step_pure [mod16_mod, mod16_mul8_lt, gep_slot hX]
  step_load consuming g9
  step_pure [and_15]
  step_pure [mod16_mod, mod16_mul8_lt, gep_slot hX]
  step_load consuming g0
  step_pure
  step_pure
  step_pure [xNext_eq]
  step_store
  iterate 4 step_pure
  step_pure [Sigma1_eq]
  iterate 3 step_pure
  step_pure [Ch_eq]
  step_pure [hj64, hj8, gep_of_offset_zero hKo (i + 1)]
  step_load consuming hk1
  iterate 3 step_pure
  step_pure [T1_eq']
  iterate 4 step_pure
  step_pure [Sigma0_eq]
  iterate 3 step_pure
  step_pure [Maj_eq]
  step_pure
  step_pure [e_eq]
  step_pure [a_eq]
  -- i += 2, i < 80
  step_pure
  finish_block
  · step_loop using hexit (eq_of_ofNat_eq hbr (by omega) (by decide))
  · step_loop using
      hback
        (by
          have := mt (congrArg (BitVec.ofNat 64)) hbr; omega)

/-- The second loop from round `i`, `2 n + 2` rounds left, `X` holding `Xv`: the message
schedule's words stored, then `^bb4` on `loop2`'s working variables. -/
theorem schedule_loop (st X Kp Wp : Pointer) (H : Vector (BitVec 64) 8) (cnt : BitVec 64)
    (R : PoisonOr (Vals [] × GlobalState)) (hX : X.offset = 0) (hKo : Kp.offset = 0)
    (hXK : X.id ≠ Kp.id) {hw : (Ty.array 80 (.bv 64)).width = 5120} :
    ∀ n i (v : Vector (BitVec 64) 8) (Xv : Vector (BitVec 64) 16) (S : GlobalState) (E : ⟪Γ⟫),
      i + 2 * n + 2 = 80 →
        i % 2 = 0 →
        S.WF →
        Fits S.mem X 1024 →
        Room S.mem X 1024 →
        Fits S.mem Kp 5120 →
        HoldsX S.mem X Xv →
        S.mem.readAt Kp 5120 = Ty.flatBits fd_sha512_core_ref_K.lit (hw := hw) →
        (∀ E' : ⟪Γ⟫,
          E'.args = E.args →
            fd_sha512_core_ref.runFrom (exit3v st X Kp Wp H cnt E' (loop2 i v Xv)) 4
                { S with mem := mem2 X i (2 * n + 2) Xv S.mem } =
              R) →
        fd_sha512_core_ref.runFrom (hdr3v st X Kp Wp H cnt E v i) 3 S = R := by
  intro n
  induction n with
  | zero =>
    intro i v Xv S E hi hev hwf hXf hXr hKf hXv hKr hK
    have hXv1 := hXv.store hX hXr (Nat.mod_lt i (by decide)) (xNext Xv i)
    refine
      schedule_iter st X Kp Wp H cnt i (by omega) hev v[0] v[1] v[2] v[3] v[4] v[5] v[6] v[7]
        Xv[i % 16] Xv[(i + 1) % 16] Xv[(i + 9) % 16] Xv[(i + 14) % 16] _ _ _ _ K[i] K[i + 1] S E R
        hwf hX hKo hXK hXf hXr hKf (hXv _ (Nat.mod_lt _ (by decide)))
        (hXv _ (Nat.mod_lt _ (by decide))) (hXv _ (Nat.mod_lt _ (by decide)))
        (hXv _ (Nat.mod_lt _ (by decide))) (readAt_K hKf hKo hKr (by omega))
        (hXv1 _ (Nat.mod_lt _ (by decide))) (hXv1 _ (Nat.mod_lt _ (by decide)))
        (hXv1 _ (Nat.mod_lt _ (by decide))) (hXv1 _ (Nat.mod_lt _ (by decide)))
        (readAt_K hKf hKo hKr (by omega)) (fun _ E' hE' => ?_) (fun h => absurd h (by omega))
    have := hK E' hE'
    rw [show 2 * 0 + 2 = 0 + 2 from rfl, mem2_add_two, loop2_lt (by omega), loop2_lt (by omega),
      show i + 1 + 1 = 80 by omega, loop2_80] at this
    exact this
  | succ n ih =>
    intro i v Xv S E hi hev hwf hXf hXr hKf hXv hKr hK
    have hXv1 := hXv.store hX hXr (Nat.mod_lt i (by decide)) (xNext Xv i)
    refine
      schedule_iter st X Kp Wp H cnt i (by omega) hev v[0] v[1] v[2] v[3] v[4] v[5] v[6] v[7]
        Xv[i % 16] Xv[(i + 1) % 16] Xv[(i + 9) % 16] Xv[(i + 14) % 16] _ _ _ _ K[i] K[i + 1] S E R
        hwf hX hKo hXK hXf hXr hKf (hXv _ (Nat.mod_lt _ (by decide)))
        (hXv _ (Nat.mod_lt _ (by decide))) (hXv _ (Nat.mod_lt _ (by decide)))
        (hXv _ (Nat.mod_lt _ (by decide))) (readAt_K hKf hKo hKr (by omega))
        (hXv1 _ (Nat.mod_lt _ (by decide))) (hXv1 _ (Nat.mod_lt _ (by decide)))
        (hXv1 _ (Nat.mod_lt _ (by decide))) (hXv1 _ (Nat.mod_lt _ (by decide)))
        (readAt_K hKf hKo hKr (by omega)) (fun h => absurd h (by omega)) (fun _ E' hE' => ?_)
    have hXv2 :=
      hXv1.store hX hXr.storeAt (Nat.mod_lt (i + 1) (by decide))
        (xNext (Xv.set (i % 16) (xNext Xv i) (Nat.mod_lt _ (by decide))) (i + 1))
    refine
      ih (i + 2)
        (round (round v (xNext Xv i) K[i])
          (xNext (Xv.set (i % 16) (xNext Xv i) (Nat.mod_lt _ (by decide))) (i + 1)) K[i + 1])
        ((Xv.set (i % 16) (xNext Xv i) (Nat.mod_lt _ (by decide))).set ((i + 1) % 16)
          (xNext (Xv.set (i % 16) (xNext Xv i) (Nat.mod_lt _ (by decide))) (i + 1))
          (Nat.mod_lt _ (by decide)))
        { S with
          mem :=
            (S.mem.storeAt (slot X (i % 16)) (xNext Xv i)).storeAt (slot X ((i + 1) % 16))
              (xNext (Xv.set (i % 16) (xNext Xv i) (Nat.mod_lt _ (by decide))) (i + 1)) }
        E' (by omega) (by omega) hwf.storeAt.storeAt hXf.storeAt.storeAt hXr.storeAt.storeAt
        hKf.storeAt.storeAt hXv2 ?_ fun E'' hE'' => ?_
    · rw [MemoryState.readAt_storeAt_disjoint (p := slot X ((i + 1) % 16))
          (Range.disjoint_of_id_ne hXK),
        MemoryState.readAt_storeAt_disjoint (p := slot X (i % 16)) (Range.disjoint_of_id_ne hXK)]
      exact hKr
    · have := hK E'' (hE''.trans hE')
      rw [show 2 * (n + 1) + 2 = 2 * n + 2 + 2 by omega, mem2_add_two, loop2_lt (by omega),
        loop2_lt (by omega)] at this
      exact this

/-! ### A block's end, and the blocks -/

theorem saddOverflow_sub_one {r : Nat} (h : r + 1 < 2 ^ 63) :
    (BitVec.ofNat 64 (r + 1)).saddOverflow 18446744073709551615#64 = false := by
  have hr : (BitVec.ofNat 64 (r + 1)).toInt = r + 1 := by
    rw [BitVec.toInt_eq_toNat_of_lt] <;> simp <;> omega
  simp [BitVec.saddOverflow, hr]
  omega

theorem ofNat_add_neg_one (r : Nat) :
    BitVec.ofNat 64 (r + 1) + 18446744073709551615#64 = BitVec.ofNat 64 r := by
  rw [BitVec.ofNat_add]
  generalize BitVec.ofNat 64 r = x
  bv_decide

/-- `^bb4`: `state[k] += …`, `W += 16UL*sizeof(ulong)`, `X`'s lifetime's end, `--block_cnt`; then
`^bb5` after the last block, else `^bb1`. -/
theorem update_block (st data X Kp Wp : Pointer) (n : BitVec 64)
    (h0 h1 h2 h3 h4 h5 h6 h7 a b c d e f g h : BitVec 64) (r : Nat) (S : GlobalState) (E : ⟪Γ⟫)
    (R : PoisonOr (Vals [] × GlobalState))
    (hArgs : E.args = (fd_sha512_core_ref.args (.value st) (.value data) (.value n)).get)
    (hwf : S.WF) (hst : S.mem.Words8Fit st) (hstw : Writable S.mem st) (hstX : st.id ≠ X.id)
    (hWo : Wp.offset.toNat + 128 < 2 ^ 64) (hr : r + 1 < 2 ^ 63)
    (hexit :
      r = 0 →
        ∀ E' : ⟪Γ⟫,
          E'.args = E.args →
            fd_sha512_core_ref.runFrom E' 5
                { S with
                  mem :=
                    (S.mem.storeWords8 st
                          #v[h0 + a, h1 + b, h2 + c, h3 + d, h4 + e, h5 + f, h6 + g,
                            h7 + h]).lifetimeEnd
                      X } =
              R)
    (hback :
      r ≠ 0 →
        ∀ E' : ⟪Γ⟫,
          E'.args = E.args →
            fd_sha512_core_ref.runFrom
                (hdr1 st X Kp (Wp.add 128#64) (h0 + a) (h1 + b) (h2 + c) (h3 + d) (h4 + e) (h5 + f)
                  (h6 + g) (h7 + h) (BitVec.ofNat 64 r) E')
                1
                { S with
                  mem :=
                    (S.mem.storeWords8 st
                          #v[h0 + a, h1 + b, h2 + c, h3 + d, h4 + e, h5 + f, h6 + g,
                            h7 + h]).lifetimeEnd
                      X } =
              R) :
    fd_sha512_core_ref.runFrom
        (exit3 st X Kp Wp h0 h1 h2 h3 h4 h5 h6 h7 (BitVec.ofNat 64 (r + 1)) E a b c d e f g h) 4 S =
      R := by
  block_init
  -- state[0] += a; … state[7] += h;
  step_pure [BitVec.add_comm a h0]
  step_store
  step_pure [BitVec.add_comm b h1]
  step_store
  step_pure [BitVec.add_comm c h2]
  step_store
  step_pure [BitVec.add_comm d h3]
  step_store
  step_pure [BitVec.add_comm e h4]
  step_store
  step_pure [BitVec.add_comm f h5]
  step_store
  step_pure [BitVec.add_comm g h6]
  step_store
  step_pure [BitVec.add_comm h h7]
  step_store
  -- W += 16UL*sizeof(ulong); } while( --block_cnt );
  step_pure
  step_pure
  step_pure [saddOverflow_sub_one hr, ofNat_add_neg_one]
  step_pure
  finish_block
  · step_loop using hexit (eq_of_ofNat_eq hbr (by omega) (by decide))
  · step_loop using
      hback
        (by
          rintro rfl; exact hbr rfl)

/-! ### The blocks -/

theorem block_offset {data : Pointer} {N j : Nat} (hdo : data.offset.toNat + 128 * N < 2 ^ 64)
    (hj : j < N) :
    (data.add (BitVec.ofNat 64 (128 * j))).offset.toNat = data.offset.toNat + 128 * j := by
  simp only [Pointer.add, BitVec.toNat_add, BitVec.toNat_ofNat]
  rw [Nat.mod_eq_of_lt (by omega : 128 * j < 2 ^ 64), Nat.mod_eq_of_lt (by omega)]

theorem block_noOverflow {data : Pointer} {N j : Nat} (hdo : data.offset.toNat + 128 * N < 2 ^ 64)
    (hj : j < N) : ¬data.offset.uaddOverflow (BitVec.ofNat 64 (128 * j)) := by
  simp [BitVec.uaddOverflow]
  omega

/-- Block `j` of `N` fits. -/
theorem fits_block {m : MemoryState} {data : Pointer} {N j : Nat} (hf : Fits m data (1024 * N))
    (hdo : data.offset.toNat + 128 * N < 2 ^ 64) (hj : j < N) :
    Fits m (data.add (BitVec.ofNat 64 (128 * j))) 1024 :=
  Fits.add_of_le (block_noOverflow hdo hj)
    (by
      simp; omega)
    hf

/-- Block `j` of `N`, read where the `N` blocks were read whole. -/
theorem readAt_block {m : MemoryState} {data : Pointer} {N j : Nat} {D : BitVec (1024 * N)}
    (hf : Fits m data (1024 * N)) (hdo : data.offset.toNat + 128 * N < 2 ^ 64) (hj : j < N)
    (h : m.readAt data (1024 * N) = D) :
    m.readAt (data.add (BitVec.ofNat 64 (128 * j))) 1024 = D.extractLsb' (1024 * j) 1024 := by
  rw [MemoryState.readAt_add_of_readAt hf.inBounds (block_noOverflow hdo hj)
      (by
        simp; omega)
      h]
  congr 1
  simp
  omega

theorem add_block {data : Pointer} (j : Nat) :
    (data.add (BitVec.ofNat 64 (128 * j))).add 128#64 =
      data.add (BitVec.ofNat 64 (128 * (j + 1))) := by
  rw [Pointer.add_add, Nat.mul_succ, BitVec.ofNat_add]

/-- The memory a block leaves: its stores into `X` within `X`'s lifetime, then its state words. -/
def memBlock (st X : Pointer) (block : BitVec 1024) (H : Vector (BitVec 64) 8) (m : MemoryState) :
    MemoryState :=
  ((mem2 X 16 64 (X0 block) (mem1 X block 0 16 (m.lifetimeStart X))).storeWords8 st
        (compress H block)).lifetimeEnd
    X

/-- The memory after blocks `j … j + n - 1`. -/
def memBlocks (st X : Pointer) (D : BitVec w) :
    (j n : Nat) → Vector (BitVec 64) 8 → MemoryState → MemoryState
  | _, 0, _, m => m
  | j, n + 1, H, m =>
    let block := D.extractLsb' (1024 * j) 1024
    memBlocks st X D (j + 1) n (compress H block) (memBlock st X block H m)

theorem WF_memBlock {s : GlobalState} (h : s.WF) :
    ({ s with mem := memBlock st X block H s.mem } : GlobalState).WF := by
  have h₁ :=
    WF_mem12 (X := X) (Xv := X0 block) (block := block) (i := 16) (n := 64) (i' := 0) (n' := 16)
      (s := { s with mem := s.mem.lifetimeStart X }) h.lifetimeStart
  exact (GlobalState.WF.storeWords8 (p := st) (v := compress H block) h₁).lifetimeEnd (p := X)

theorem Words8Fit.memBlock {m : MemoryState} (h : m.Words8Fit p) (hne : p.id ≠ X.id) :
    (memBlock st X block H m).Words8Fit p :=
  (Words8Fit.mem2 (Words8Fit.mem1 (h.lifetimeStart hne))).storeWords8.lifetimeEnd hne

theorem Writable.memBlock {m : MemoryState} (h : Writable m p) :
    Writable (memBlock st X block H m) p :=
  (Writable.mem2 (Writable.mem1 h.lifetimeStart)).storeWords8.lifetimeEnd

theorem InBounds.memBlock {m : MemoryState} (h : InBounds m p w) :
    InBounds (memBlock st X block H m) p w :=
  (InBounds.mem2 (InBounds.mem1 h.lifetimeStart)).storeWords8.lifetimeEnd

theorem Fits.memBlock {m : MemoryState} (h : Fits m p w) (hne : p.id ≠ X.id) :
    Fits (memBlock st X block H m) p w :=
  (Fits.mem2 (Fits.mem1 (h.lifetimeStart hne))).storeWords8.lifetimeEnd hne

/-- A read outside `X` and the state words: the read before the block. -/
theorem readAt_memBlock {m : MemoryState} (hst : st.offset.toNat + 56 < 2 ^ 64)
    (hd : (Range.of st 512).Disjoint (Range.of q w)) (hne : q.id ≠ X.id) :
    (memBlock st X block H m).readAt q w = m.readAt q w := by
  rw [memBlock, MemoryState.readAt_lifetimeEnd, MemoryState.readAt_storeWords8_of_disjoint hst hd,
    readAt_mem2 hne, readAt_mem1 hne, MemoryState.readAt_lifetimeStart]

/-- `X`'s stores are gone once its frame is erased. -/
theorem eraseFrom_mem1 {m : MemoryState} (h : B ≤ X.id.id) :
    (mem1 X block i n m).eraseFrom B = m.eraseFrom B := by
  induction n generalizing i m with
  | zero => rfl
  | succ n ih =>
    rw [mem1, ih, MemoryState.eraseFrom_storeAt,
      MemoryState.storeAt_eraseFrom_of_le (p := slot X i) h]

theorem eraseFrom_mem2 {m : MemoryState} (h : B ≤ X.id.id) :
    (mem2 X i n Xv m).eraseFrom B = m.eraseFrom B := by
  induction n generalizing i Xv m with
  | zero => rfl
  | succ n ih =>
    rw [mem2, ih, MemoryState.eraseFrom_storeAt,
      MemoryState.storeAt_eraseFrom_of_le (p := slot X (i % 16)) h]

/-- Once `X`'s frame is erased, the blocks leave only the last state words. -/
theorem eraseFrom_memBlocks {m : MemoryState} {D : BitVec w} (h : B ≤ X.id.id) :
    (memBlocks st X D j (n + 1) H m).eraseFrom B =
      (m.eraseFrom B).storeWords8 st (compressFrom D j (n + 1) H) := by
  induction n generalizing j H m with
  | zero =>
    simp only [memBlocks, memBlock, compressFrom, MemoryState.eraseFrom_lifetimeEnd_of_le h,
      MemoryState.eraseFrom_storeWords8, eraseFrom_mem2 h, eraseFrom_mem1 h,
      MemoryState.eraseFrom_lifetimeStart_of_le h]
  | succ n
    ih =>
    rw [memBlocks, ih, memBlock, MemoryState.eraseFrom_lifetimeEnd_of_le h,
      MemoryState.eraseFrom_storeWords8, eraseFrom_mem2 h, eraseFrom_mem1 h,
      MemoryState.eraseFrom_lifetimeStart_of_le h, MemoryState.storeWords8_storeWords8_self]
    rfl

/-- `update_block` on the state words `H` and the working variables `v`. -/
theorem update_block_vec (st data X Kp Wp : Pointer) (n : BitVec 64) (H v : Vector (BitVec 64) 8)
    (r : Nat) (S : GlobalState) (E : ⟪Γ⟫) (R : PoisonOr (Vals [] × GlobalState))
    (hArgs : E.args = (fd_sha512_core_ref.args (.value st) (.value data) (.value n)).get)
    (hwf : S.WF) (hst : S.mem.Words8Fit st) (hstw : Writable S.mem st) (hstX : st.id ≠ X.id)
    (hWo : Wp.offset.toNat + 128 < 2 ^ 64) (hr : r + 1 < 2 ^ 63)
    (hexit :
      r = 0 →
        ∀ E' : ⟪Γ⟫,
          E'.args = E.args →
            fd_sha512_core_ref.runFrom E' 5
                { S with mem := (S.mem.storeWords8 st (addWords H v)).lifetimeEnd X } =
              R)
    (hback :
      r ≠ 0 →
        ∀ E' : ⟪Γ⟫,
          E'.args = E.args →
            fd_sha512_core_ref.runFrom
                (hdr1v st X Kp (Wp.add 128#64) (addWords H v) (BitVec.ofNat 64 r) E') 1
                { S with mem := (S.mem.storeWords8 st (addWords H v)).lifetimeEnd X } =
              R) :
    fd_sha512_core_ref.runFrom (exit3v st X Kp Wp H (BitVec.ofNat 64 (r + 1)) E v) 4 S = R :=
  update_block st data X Kp Wp n H[0] H[1] H[2] H[3] H[4] H[5] H[6] H[7] v[0] v[1] v[2] v[3] v[4]
    v[5] v[6] v[7] r S E R hArgs hwf hst hstw hstX hWo hr hexit hback

-- the continuation's env reads through the loops' envs, and `X`'s lifetime start: over 200000
-- heartbeats
set_option maxHeartbeats 400000 in
/-- A block's rounds from `^bb1`: the two loops, then `^bb4`. -/
theorem rounds_block (st X Kp Wp : Pointer) (H : Vector (BitVec 64) 8) (cnt : BitVec 64)
    (block : BitVec 1024) (S : GlobalState) (E₁ : ⟪Γ⟫) (R : PoisonOr (Vals [] × GlobalState))
    {hw : (Ty.array 80 (.bv 64)).width = 5120} (hwf : S.WF) (hX : X.offset = 0)
    (hKo : Kp.offset = 0) (hWo : Wp.offset.toNat + 128 < 2 ^ 64) (hXK : X.id ≠ Kp.id)
    (hXW : X.id ≠ Wp.id) (hXb : InBounds S.mem X 1024) (hXw : Writable S.mem X)
    (hKf : Fits S.mem Kp 5120) (hWf : Fits S.mem Wp 1024) (hW : S.mem.readAt Wp 1024 = block)
    (hKr : S.mem.readAt Kp 5120 = Ty.flatBits fd_sha512_core_ref_K.lit (hw := hw))
    (hcont :
      ∀ E' : ⟪Γ⟫,
        E'.args = E₁.args →
          fd_sha512_core_ref.runFrom
              (exit3v st X Kp Wp H cnt E' (loop2 16 (loop1 block 0 H) (X0 block))) 4
              { S with
                mem := mem2 X 16 64 (X0 block) (mem1 X block 0 16 (S.mem.lifetimeStart X)) } =
            R) :
    fd_sha512_core_ref.runFrom (hdr1v st X Kp Wp H cnt E₁) 1 S = R := by
  block_init
  -- "llvm.intr.lifetime.start"
  step_pure
  -- `X`'s room has its writability: a `Writable` fact would be carried by unfolding `mem1`, `mem2`
  clear hXw
  finish_block
  -- the args through the env's writes, so the loops' continuations chain them without unfolding
  have hA : E.args = E₁.args := by
    rw [hE]; simp only [Env.write_args]
  step_loop using words_loop st X Kp Wp H cnt block R hX hKo hWo hXK hXW 7 0 H
  -- the stores into the started `X` make it known
  have hXr := room_mem1.1 (hS ▸ hroom_X)
  have hXf : Fits S.mem X 1024 := by
    rw [hS]
    exact fits_mem1 hX hXr
  have hXv : HoldsX S.mem X (X0 block) := by
    rw [hS]
    exact holdsX_mem1 hX hXr block
  replace hXr : Room S.mem X 1024 := by
    rw [hS]
    exact Room.mem1 hXr
  clear hroom_X
  have hA : E.args = E₁.args := by
    rw [hE]; simp only [Env.write_args]; exact hArgs₀
  step_loop using schedule_loop st X Kp Wp H cnt R hX hKo hXK 31 16 (loop1 block 0 H) (X0 block)
  have hA : E.args = E₁.args := by
    rw [hE]; simp only [Env.write_args]; exact hArgs₀
  step_loop using hcont

/-- The blocks from `j`, `r + 1` of them left, on the state words `H`: each block's rounds and
`state[k] += …`; then `^bb5` on `memBlocks`. -/
theorem blocks_loop (st data X Kp : Pointer) (n : BitVec 64) (N : Nat) (D : BitVec (1024 * N))
    (R : PoisonOr (Vals [] × GlobalState)) {hw : (Ty.array 80 (.bv 64)).width = 5120}
    (hX : X.offset = 0) (hKo : Kp.offset = 0) (hdo : data.offset.toNat + 128 * N < 2 ^ 64)
    (hXK : X.id ≠ Kp.id) (hXd : X.id ≠ data.id) (hKst : Kp.id ≠ st.id) (hstX : st.id ≠ X.id)
    (hsep : (Range.of st 512).Disjoint (Range.of data (1024 * N))) :
    ∀ r j (H : Vector (BitVec 64) 8) (S : GlobalState) (E : ⟪Γ⟫),
      j + r + 1 = N →
        E.args = (fd_sha512_core_ref.args (.value st) (.value data) (.value n)).get →
        S.WF →
        S.mem.Words8Fit st →
        Writable S.mem st →
        InBounds S.mem X 1024 →
        Writable S.mem X →
        Fits S.mem Kp 5120 →
        Fits S.mem data (1024 * N) →
        S.mem.readAt data (1024 * N) = D →
        S.mem.readAt Kp 5120 = Ty.flatBits fd_sha512_core_ref_K.lit (hw := hw) →
        (∀ E' : ⟪Γ⟫,
          E'.args = E.args →
            fd_sha512_core_ref.runFrom E' 5 { S with mem := memBlocks st X D j (r + 1) H S.mem } =
              R) →
        fd_sha512_core_ref.runFrom
            (hdr1v st X Kp (data.add (BitVec.ofNat 64 (128 * j))) H (BitVec.ofNat 64 (r + 1)) E) 1
            S =
          R := by
  intro r
  induction r with
  | zero =>
    intro j H S E hj hA hwf hst hstw hXb hXw hKf hdf hD hKr hK
    exact
      rounds_block st X Kp _ H _ _ S E R hwf hX hKo
        (by
          rw [block_offset hdo (by omega)]; omega)
        hXK hXd hXb hXw hKf (fits_block hdf hdo (by omega)) (readAt_block hdf hdo (by omega) hD) hKr
        fun E₁ h₁ =>
        update_block_vec st data X Kp _ n H _ 0 _ E₁ R (h₁.trans hA) (WF_mem12 hwf.lifetimeStart)
          (Words8Fit.mem2 (Words8Fit.mem1 (hst.lifetimeStart hstX)))
          (Writable.mem2 (Writable.mem1 hstw.lifetimeStart)) hstX
          (by
            rw [block_offset hdo (by omega)]; omega)
          (by decide) (fun _ E₂ h₂ => hK E₂ (h₂.trans h₁)) (fun h => absurd rfl h)
  | succ r ih =>
    intro j H S E hj hA hwf hst hstw hXb hXw hKf hdf hD hKr hK
    refine
      rounds_block st X Kp _ H _ _ S E R hwf hX hKo
        (by
          rw [block_offset hdo (by omega)]; omega)
        hXK hXd hXb hXw hKf (fits_block hdf hdo (by omega)) (readAt_block hdf hdo (by omega) hD) hKr
        fun E₁ h₁ =>
        update_block_vec st data X Kp _ n H _ (r + 1) _ E₁ R (h₁.trans hA)
          (WF_mem12 hwf.lifetimeStart) (Words8Fit.mem2 (Words8Fit.mem1 (hst.lifetimeStart hstX)))
          (Writable.mem2 (Writable.mem1 hstw.lifetimeStart)) hstX
          (by
            rw [block_offset hdo (by omega)]; omega)
          (by omega) (fun h => absurd h (by omega)) (fun _ E₂ h₂ => ?_)
    rw [add_block]
    -- the block's memory, as `memBlock`
    change
      fd_sha512_core_ref.runFrom _ 1
          { S with mem := memBlock st X (D.extractLsb' (1024 * j) 1024) H S.mem } =
        R
    apply ih (j + 1)
    · omega
    · exact h₂.trans (h₁.trans hA)
    · exact WF_memBlock hwf
    · exact Words8Fit.memBlock hst hstX
    · exact Writable.memBlock hstw
    · exact InBounds.memBlock hXb
    · exact Writable.memBlock hXw
    · exact Fits.memBlock hKf hXK.symm
    · exact Fits.memBlock hdf hXd.symm
    · rw [readAt_memBlock hst.1 hsep hXd.symm]
      exact hD
    · rw [readAt_memBlock hst.1 (Range.disjoint_of_id_ne hKst.symm) hXK.symm]
      exact hKr
    · exact fun E₃ h₃ => hK E₃ (h₃.trans (h₂.trans h₁))

/-- A read of the entry state's memory, through `X`'s `alloca`. -/
theorem readAt_frame {s : GlobalState} (hwf : s.WF) (h : InBounds s.mem q w) :
    (s.alloca b d).mem.readAt q w = s.mem.readAt q w :=
  MemoryState.readAt_alloca hwf h

end fd_sha512_core_ref

open fd_sha512_core_ref

/-- `fd_sha512_core_ref.K`'s initializer gives its folded constant, leaving the state. -/
public theorem _root_.Firedancer.Lane.Mlir.fd_sha512_core_ref_K.value_eq (s : GlobalState) :
    fd_sha512_core_ref_K.value s = .value (Ty.wrap fd_sha512_core_ref_K.lit, s) :=
  GlobalInitializer.compute_value _ _ ⟨_, by with_unfolding_all rfl⟩

/-- `fd_sha512_core_ref` compresses the `n` 128-byte blocks at `data` into the eight state words
at `st` and stores the result there. The state and the blocks must not overlap; `X` leaves one
block counted. -/
public theorem _root_.Firedancer.Lane.Mlir.fd_sha512_core_ref.call_eq (st data : Pointer)
    (n : BitVec 64) (s : GlobalState) (hwf : s.WF) (hg : s.mem.Globals fd_sha512_core_ref.globals)
    (hst : s.mem.Words8Fit st) (hstw : Writable s.mem st) (hn : n ≠ 0)
    (hdata : Fits s.mem data (1024 * n.toNat)) (hdo : data.offset.toNat + 128 * n.toNat < 2 ^ 64)
    (hsep : (Range.of st 512).Disjoint (Range.of data (1024 * n.toNat))) :
    fd_sha512_core_ref.call (fd_sha512_core_ref.args (.value st) (.value data) (.value n)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 1⟩,
            mem :=
              s.mem.storeWords8 st
                (Ref.fd_sha512_core_ref.spec (s.mem.readWords8 st)
                  (s.mem.readAt data (1024 * n.toNat))) }) := by
  func_init
  have hdata₀ : Fits S₀.mem data (1024 * n.toNat) := hS ▸ hdata
  block_init
  iterate 9 step_pure
  step_addressof fd_sha512_core_ref_K.value_eq with Kp
  iterate 14 step_pure
  step_alloca with X
  iterate 7 step_pure
  -- ulong a = state[0]; … ulong h = state[7];
  iterate 8 step_load inline
  finish_block
  have hD : S.mem.readAt data (1024 * n.toNat) = S₀.mem.readAt data (1024 * n.toNat) := by
    rw [hS]
    exact readAt_frame hwf₀ hdata₀.inBounds
  have hN : n.toNat - 1 + 1 = n.toNat :=
    Nat.sub_add_cancel
      (Nat.pos_of_ne_zero
        (by
          intro h; exact hn (BitVec.eq_of_toNat_eq h)))
  have hXK : X.id ≠ Kp.id := hKp_ne_X.symm
  have hrun :
    fd_sha512_core_ref.runFrom E 1 S =
      .value
        (.nil,
          { S with
            mem :=
              memBlocks st X (S₀.mem.readAt data (1024 * n.toNat)) 0 (n.toNat - 1 + 1)
                (S₀.mem.readWords8 st) S.mem }) := by
    step_loop using
      blocks_loop st data X Kp n n.toNat _ _ hX_off hKp_off hdo hXK hdata_ne_X.symm hst_ne_Kp.symm
        hst_ne_X hsep (n.toNat - 1) 0 (S₀.mem.readWords8 st)
    block_init
    finish_block
    rfl
  rw [hrun, PoisonOr.value_bind]
  subst hS
  congr 2
  rw [eraseFrom_memBlocks
      (by
        rw [hX]; simp),
    GlobalState.eraseFrom_alloca_of_le (by simp), hwf₀.eraseFrom, hN]
  rfl


end Proof

end MLIR.Firedancer.Lane
