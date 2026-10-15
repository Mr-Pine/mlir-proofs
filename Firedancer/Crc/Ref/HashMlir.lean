module

public import MLIR.Run.Tactic
public import Firedancer.Crc.Ref.Mlir.fd_hash
import Std.Tactic.BVDecide

/-!
# `fd_hash` refinement (MLIR lift ↔ spec)

`fd_hash_generic` (xxhash-r39, `src/util/fd_hash.c`) as a function of the seed and the `sz` bytes
at `buf`, read little-endian, and the lift computing it.
-/

namespace MLIR.Firedancer.Crc.Ref

namespace fd_hash

@[expose] public section

/-! The xxhash primes `C1` … `C5`. -/

def C1 : BitVec 64 :=
  11400714785074694791#64

def C2 : BitVec 64 :=
  14029467366897019727#64

def C3 : BitVec 64 :=
  1609587929392839161#64

def C4 : BitVec 64 :=
  9650029242287828579#64

def C5 : BitVec 64 :=
  2870177450012600261#64

/-- `FD_LOAD( ulong, p+i )`: the little-endian `ulong` at byte `i`. -/
def ld64 (b : BitVec n) (i : Nat) : BitVec 64 :=
  b.extractLsb' (8 * i) 64

/-- `(ulong)FD_LOAD( uint, p+i )`. -/
def ld32 (b : BitVec n) (i : Nat) : BitVec 64 :=
  (b.extractLsb' (8 * i) 32).setWidth 64

/-- `(ulong)p[i]`. -/
def ld8 (b : BitVec n) (i : Nat) : BitVec 64 :=
  (b.extractLsb' (8 * i) 8).setWidth 64

/-- One lane of a 32-byte block: `w += v*C2; w = ROTATE_LEFT( w, 31 ); w *= C1;`. -/
def lane (w v : BitVec 64) : BitVec 64 :=
  (v * C2 + w).rotateLeft 31 * C1

/-- The four lanes `w`, `x`, `y`, `z`. -/
abbrev Lanes :=
  BitVec 64 × BitVec 64 × BitVec 64 × BitVec 64

/-- The block at byte `i` folded into the lanes. -/
def block (b : BitVec n) (i : Nat) (a : Lanes) : Lanes :=
  (lane a.1 (ld64 b i), lane a.2.1 (ld64 b (i + 8)), lane a.2.2.1 (ld64 b (i + 16)),
    lane a.2.2.2 (ld64 b (i + 24)))

/-- `do { … p += 32; } while( p<=stop32 );` from byte `i`: the lanes and the next byte. -/
def blocks (b : BitVec n) (sz i : Nat) (a : Lanes) : Lanes × Nat :=
  if i + 64 ≤ sz then blocks b sz (i + 32) (block b i a) else (block b i a, i + 32)
termination_by sz - i

/-- `w *= C2; w = ROTATE_LEFT( w, 31 ); w *= C1; h ^= w; h = h*C1 + C4;`. -/
def merge (h w : BitVec 64) : BitVec 64 :=
  (h ^^^ (w * C2).rotateLeft 31 * C1) * C1 + C4

/-- The lanes merged into `h` after the last block. -/
def finish (a : Lanes) : BitVec 64 :=
  let (w, x, y, z) := a
  let h := w.rotateLeft 1 + x.rotateLeft 7 + y.rotateLeft 12 + z.rotateLeft 18
  merge (merge (merge (merge h w) x) y) z

/-- `h` before `h += sz`, and the first byte the blocks leave. -/
def head (seed : BitVec 64) (b : BitVec n) (sz : Nat) : BitVec 64 × Nat :=
  if sz < 32 then (seed + C5, 0)
  else
    let r := blocks b sz 0 (seed + (C1 + C2), seed + C2, seed, seed - C1)
    (finish r.1, r.2)

/-- `while( (p+8)<=stop ) { … }` from byte `i`. -/
def words (b : BitVec n) (sz i : Nat) (h : BitVec 64) : BitVec 64 × Nat :=
  if i + 8 ≤ sz then
    words b sz (i + 8) ((h ^^^ (ld64 b i * C2).rotateLeft 31 * C1).rotateLeft 27 * C1 + C4)
  else (h, i)
termination_by sz - i

/-- `if( (p+4)<=stop ) { … }` at byte `i`. -/
def word32 (b : BitVec n) (sz i : Nat) (h : BitVec 64) : BitVec 64 × Nat :=
  if i + 4 ≤ sz then ((h ^^^ ld32 b i * C1).rotateLeft 23 * C2 + C3, i + 4) else (h, i)

/-- `while( p<stop ) { … }` from byte `i`. -/
def bytes (b : BitVec n) (sz i : Nat) (h : BitVec 64) : BitVec 64 :=
  if i < sz then bytes b sz (i + 1) ((h ^^^ ld8 b i * C5).rotateLeft 11 * C1) else h
termination_by sz - i

/-- The final avalanche. -/
def avalanche (h : BitVec 64) : BitVec 64 :=
  let h := h ^^^ h >>> 33
  let h := h * C2
  let h := h ^^^ h >>> 29
  let h := h * C3
  h ^^^ h >>> 32

end

end fd_hash

open fd_hash in
/-- `fd_hash_generic( seed, buf, sz )` of the `sz` bytes `b`. -/
@[expose]
public def fd_hash.spec (seed : BitVec 64) (b : BitVec n) (sz : Nat) : BitVec 64 :=
  let r := head seed b sz
  let r := words b sz r.2 (r.1 + BitVec.ofNat 64 sz)
  let r := word32 b sz r.2 r.1
  avalanche (bytes b sz r.2 r.1)

/-- `buf`'s addresses, through its `n` bytes and 32 past them, are below `2^63`. -/
public abbrev fd_hash.NoWrap (m : MemoryState) (buf : Pointer) (n : Nat) : Prop :=
  (m.addr buf.id).toNat + buf.offset.toNat + n + 32 < 2 ^ 63

section Proof

namespace fd_hash_generic

open fd_hash

theorem toNat_ofNat64 {i : Nat} (h : i < 2 ^ 64) : (BitVec.ofNat 64 i).toNat = i := by
  rw [BitVec.toNat_ofNat, Nat.mod_eq_of_lt h]

theorem noOv {m : MemoryState} {buf : Pointer} {n i : Nat} (h : NoWrap m buf n) (hi : i ≤ n + 32) :
    ¬buf.offset.uaddOverflow (BitVec.ofNat 64 i) := by
  simp only [BitVec.uaddOverflow, ge_iff_le, decide_eq_true_eq, Nat.not_le,
    toNat_ofNat64 (show i < 2 ^ 64 by omega)]
  omega

theorem fits_at {m : MemoryState} {buf : Pointer} {n i v : Nat} (hb : Fits m buf (8 * n))
    (h : NoWrap m buf n) (hi : i * 8 + v ≤ 8 * n) : Fits m (buf.add (BitVec.ofNat 64 i)) v :=
  Fits.add_of_le (noOv h (by omega))
    (by
      rw [toNat_ofNat64 (by omega)]; exact hi)
    hb

theorem read_at {m : MemoryState} {buf : Pointer} {n i v : Nat} (hb : Fits m buf (8 * n))
    (h : NoWrap m buf n) (hi : i * 8 + v ≤ 8 * n) :
    m.readAt (buf.add (BitVec.ofNat 64 i)) v = (m.readAt buf (8 * n)).extractLsb' (8 * i) v := by
  rw [MemoryState.readAt_add_of_readAt hb.inBounds (noOv h (by omega))
      (by
        rw [toNat_ofNat64 (by omega)]; exact hi)
      rfl,
    toNat_ofNat64 (by omega)]
  congr 1; omega

theorem add_eq_iff (buf : Pointer) {i : Nat} (sz : BitVec 64) (h : i < 2 ^ 64) :
    buf.add (BitVec.ofNat 64 i) = buf.add sz ↔ i = sz.toNat := by
  constructor
  · intro he
    have := congrArg (·.offset) he
    simp only [Pointer.add, BitVec.add_right_inj] at this
    rw [← this, toNat_ofNat64 h]
  · rintro rfl
    rw [BitVec.ofNat_toNat, BitVec.setWidth_eq]

variable (seed : BitVec 64) (buf : Pointer) (sz : BitVec 64) {β : Type}
  (g : Vals [.bv 64] × GlobalState → PoisonOr β)

/-- Pointers into `buf` compare by offset (`ptricmp` compares addresses). -/
theorem addr_ult {m : MemoryState} {buf : Pointer} {n : Nat} (h : NoWrap m buf n) {x y : BitVec 64}
    (hx : x.toNat ≤ n + 32) (hy : y.toNat ≤ n + 32) :
    (m.addr buf.id + (buf.add x).offset).ult (m.addr buf.id + (buf.add y).offset) =
      decide (x.toNat < y.toNat) := by
  have hb := (m.addr buf.id).isLt
  have ho := buf.offset.isLt
  simp only [NoWrap] at h
  simp only [Pointer.add, BitVec.ult, BitVec.toNat_add, Nat.add_mod_mod]
  repeat rw [Nat.mod_eq_of_lt (by omega)]
  simp only [decide_eq_decide]
  omega

theorem addr_ult_nat {m : MemoryState} {buf : Pointer} {n x y : Nat} (h : NoWrap m buf n)
    (hx : x ≤ n + 32) (hy : y ≤ n + 32) :
    (m.addr buf.id + (buf.add (BitVec.ofNat 64 x)).offset).ult
        (m.addr buf.id + (buf.add (BitVec.ofNat 64 y)).offset) =
      decide (x < y) := by
  rw [addr_ult h
      (by
        rw [toNat_ofNat64 (by omega)]; omega)
      (by
        rw [toNat_ofNat64 (by omega)]; omega),
    toNat_ofNat64 (by omega), toNat_ofNat64 (by omega)]

theorem addr_ult_sz_left {m : MemoryState} {buf : Pointer} {sz : BitVec 64} {y : Nat}
    (h : NoWrap m buf sz.toNat) (hy : y ≤ sz.toNat + 32) :
    (m.addr buf.id + (buf.add sz).offset).ult
        (m.addr buf.id + (buf.add (BitVec.ofNat 64 y)).offset) =
      decide (sz.toNat < y) := by
  rw [addr_ult h (by omega)
      (by
        rw [toNat_ofNat64 (by omega)]; omega),
    toNat_ofNat64 (by omega)]

theorem addr_ult_sz_right {m : MemoryState} {buf : Pointer} {sz : BitVec 64} {x : Nat}
    (h : NoWrap m buf sz.toNat) (hx : x ≤ sz.toNat + 32) :
    (m.addr buf.id + (buf.add (BitVec.ofNat 64 x)).offset).ult
        (m.addr buf.id + (buf.add sz).offset) =
      decide (x < sz.toNat) := by
  rw [addr_ult h
      (by
        rw [toNat_ofNat64 (by omega)]; omega)
      (by omega),
    toNat_ofNat64 (by omega)]

/-- `^bb10`'s end pointer: `p + ((sz + buf) - p)`. -/
theorem end_off (A o x sz : BitVec 64) : x + (sz + (A + o) - (A + (o + x))) = sz := by bv_decide

/-- `fshl x x r`, as the steps leave it. -/
abbrev fshl (x : BitVec 64) (r : Nat) : BitVec 64 :=
  BitVec.extractLsb' 64 64 ((x ++ x) <<< r)

theorem fshl_11 (x : BitVec 64) : fshl x 11 = x.rotateLeft 11 := by bv_decide

theorem fshl_23 (x : BitVec 64) : fshl x 23 = x.rotateLeft 23 := by bv_decide

theorem fshl_27 (x : BitVec 64) : fshl x 27 = x.rotateLeft 27 := by bv_decide

theorem fshl_31 (x : BitVec 64) : fshl x 31 = x.rotateLeft 31 := by bv_decide

theorem bytes_step (b : BitVec n) {sz i : Nat} (h : BitVec 64) (hi : i < sz) :
    bytes b sz i h = bytes b sz (i + 1) ((h ^^^ ld8 b i * C5).rotateLeft 11 * C1) := by
  rw [bytes, ite_eq_left hi]

theorem bytes_end (b : BitVec n) {sz i : Nat} (h : BitVec 64) (hi : ¬i < sz) :
    bytes b sz i h = h := by rw [bytes, ite_eq_right hi]

/-- `^bb11`'s update of `h` by the byte `c` at `i`. -/
theorem byte_eq (b : BitVec n) (h : BitVec 64) (c : BitVec 8) (hc : c = b.extractLsb' (8 * i) 8) :
    fshl (BitVec.setWidth 64 c * 2870177450012600261#64 ^^^ h) 11 * 11400714785074694791#64 =
      (h ^^^ ld8 b i * C5).rotateLeft 11 * C1 := by
  rw [fshl_11, BitVec.xor_comm, hc]
  rfl

/-- `^bb8`'s update of `h` by the `uint` `c` at `i`. -/
theorem uint_eq (b : BitVec n) (h : BitVec 64) (c : BitVec 32) (hc : c = b.extractLsb' (8 * i) 32) :
    fshl (BitVec.setWidth 64 c * 11400714785074694791#64 ^^^ h) 23 * 14029467366897019727#64 +
        1609587929392839161#64 =
      (h ^^^ ld32 b i * C1).rotateLeft 23 * C2 + C3 := by
  rw [fshl_23, BitVec.xor_comm, hc]
  rfl

theorem disj31 (v : BitVec 64) :
    (v * 14029467366897019727#64) >>> 33 &&& v * 10658460830393171968#64 = 0#64 := by bv_decide

theorem rot31 (v : BitVec 64) :
    (v * 14029467366897019727#64) >>> 33 ||| v * 10658460830393171968#64 =
      (v * 14029467366897019727#64).rotateLeft 31 := by
  bv_decide

/-- `^bb6`'s update of `h` by the `ulong` `v` at `i`. -/
theorem ulong_eq (b : BitVec n) (h : BitVec 64) (v : BitVec 64)
    (hv : v = b.extractLsb' (8 * i) 64) :
    fshl
            (((v * 14029467366897019727#64) >>> 33 ||| v * 10658460830393171968#64) *
                11400714785074694791#64 ^^^
              h)
            27 *
          11400714785074694791#64 +
        9650029242287828579#64 =
      (h ^^^ (ld64 b i * C2).rotateLeft 31 * C1).rotateLeft 27 * C1 + C4 := by
  rw [rot31, fshl_27, BitVec.xor_comm, hv]
  rfl

theorem words_step (b : BitVec n) {sz i : Nat} (h : BitVec 64) (hi : i + 8 ≤ sz) :
    words b sz i h =
      words b sz (i + 8) ((h ^^^ (ld64 b i * C2).rotateLeft 31 * C1).rotateLeft 27 * C1 + C4) := by
  rw [words, ite_eq_left hi]

theorem words_end (b : BitVec n) {sz i : Nat} (h : BitVec 64) (hi : ¬i + 8 ≤ sz) :
    words b sz i h = (h, i) := by rw [words, ite_eq_right hi]

theorem or1_disj (r : BitVec 64) :
    (r * 11400714785074694791#64) >>> 63 &&& r * 4354685496439837966#64 = 0#64 := by bv_decide

theorem or31_disj (r : BitVec 64) :
    (r * 16065284355873402025#64) >>> 33 &&& r * 9780892964782866432#64 = 0#64 := by bv_decide

theorem rot1 (r : BitVec 64) :
    (r * 11400714785074694791#64) >>> 63 ||| r * 4354685496439837966#64 =
      (r * 11400714785074694791#64).rotateLeft 1 := by
  bv_decide

theorem rot7 (a r : BitVec 64) :
    a + r * 1998710666506355584#64 + (r * 11400714785074694791#64) >>> 57 =
      a + (r * 11400714785074694791#64).rotateLeft 7 := by
  bv_decide

theorem rot12 (a r : BitVec 64) :
    a + r * 8618509107074723840#64 + (r * 11400714785074694791#64) >>> 52 =
      a + (r * 11400714785074694791#64).rotateLeft 12 := by
  bv_decide

theorem rot18 (a r : BitVec 64) :
    a + r * 16629004715205328896#64 + (r * 11400714785074694791#64) >>> 46 =
      a + (r * 11400714785074694791#64).rotateLeft 18 := by
  bv_decide

theorem rotm (r : BitVec 64) :
    (r * 16065284355873402025#64) >>> 33 ||| r * 9780892964782866432#64 =
      (r * 11400714785074694791#64 * 14029467366897019727#64).rotateLeft 31 := by
  have : r * 11400714785074694791#64 * 14029467366897019727#64 = r * 16065284355873402025#64 := by
    rw [BitVec.mul_assoc]; rfl
  rw [this]
  bv_decide

/-- `^bb4`'s `h`, from the rotated lanes `rₖ` of the last block (`lane = rₖ * C1`). -/
theorem bb4_eq (r0 r1 r2 r3 : BitVec 64) :
    ((((((r0 * 11400714785074694791#64) >>> 63 ||| r0 * 4354685496439837966#64) +
                                r1 * 1998710666506355584#64 +
                                (r1 * 11400714785074694791#64) >>> 57 +
                                r2 * 8618509107074723840#64 +
                                (r2 * 11400714785074694791#64) >>> 52 +
                                r3 * 16629004715205328896#64 +
                                (r3 * 11400714785074694791#64) >>> 46 ^^^
                              ((r0 * 16065284355873402025#64) >>> 33 |||
                                  r0 * 9780892964782866432#64) *
                                11400714785074694791#64) *
                            11400714785074694791#64 +
                          9650029242287828579#64 ^^^
                        ((r1 * 16065284355873402025#64) >>> 33 ||| r1 * 9780892964782866432#64) *
                          11400714785074694791#64) *
                      11400714785074694791#64 +
                    9650029242287828579#64 ^^^
                  ((r2 * 16065284355873402025#64) >>> 33 ||| r2 * 9780892964782866432#64) *
                    11400714785074694791#64) *
                11400714785074694791#64 +
              9650029242287828579#64 ^^^
            ((r3 * 16065284355873402025#64) >>> 33 ||| r3 * 9780892964782866432#64) *
              11400714785074694791#64) *
          11400714785074694791#64 +
        9650029242287828579#64 =
      finish
        (r0 * 11400714785074694791#64, r1 * 11400714785074694791#64, r2 * 11400714785074694791#64,
          r3 * 11400714785074694791#64) := by
  rw [rot1, rot7, rot12, rot18, rotm, rotm, rotm, rotm]
  rfl

theorem lane_eq {v w r : BitVec 64} (hr : r = fshl (v * 14029467366897019727#64 + w) 31) :
    r * 11400714785074694791#64 = lane w v := by
  rw [hr, fshl_31]
  rfl

theorem block_def (b : BitVec n) (i : Nat) (a : Lanes) :
    block b i a =
      (lane a.1 (ld64 b i), lane a.2.1 (ld64 b (i + 8)), lane a.2.2.1 (ld64 b (i + 16)),
        lane a.2.2.2 (ld64 b (i + 24))) :=
  rfl

theorem blocks_step (b : BitVec n) {sz i : Nat} (a : Lanes) (hi : i + 64 ≤ sz) :
    blocks b sz i a = blocks b sz (i + 32) (block b i a) := by rw [blocks, ite_eq_left hi]

theorem blocks_end (b : BitVec n) {sz i : Nat} (a : Lanes) (hi : ¬i + 64 ≤ sz) :
    blocks b sz i a = (block b i a, i + 32) := by rw [blocks, ite_eq_right hi]

/-- `^bb12`: the avalanche of `h`. -/
theorem blk12 (s : GlobalState) (h : BitVec 64) (E : ⟪Γ⟫)
    (hArgs : E.args = (args (.value seed) (.value buf) (.value sz)).get)
    (hR :
      E ⊨ [%0 := 32#64, %2 := 14029467366897019727#64, %16 := 33#64, %22 := 1609587929392839161#64,
        %24 := 29#64, %158 := h]) :
    (fd_hash_generic.runFrom E ^bb12 s >>= g) = g (.cons (.value (avalanche h)) .nil, s) := by
  block_init
  iterate 8 step_pure
  finish_block
  simp only [avalanche, C2, C3, BitVec.xor_comm]

/-- `^bb11`, the byte loop at byte `i`, `k + 1` bytes left. -/
theorem loop11 (s : GlobalState) (hb : Fits s.mem buf (8 * sz.toNat))
    (hnw : NoWrap s.mem buf sz.toNat) :
    ∀ k i (h : BitVec 64) (E : ⟪Γ⟫),
      E.args = (args (.value seed) (.value buf) (.value sz)).get →
        (E ⊨ [%0 := 32#64, %2 := 14029467366897019727#64, %5 := 11400714785074694791#64, %16 :=
          33#64, %18 := 2870177450012600261#64, %22 := 1609587929392839161#64, %23 := 11#64, %24 :=
          29#64, %147 := buf.add sz, %148 := buf.add (BitVec.ofNat 64 i), %149 := h]) →
        i + k + 1 = sz.toNat →
        (fd_hash_generic.runFrom E ^bb11 s >>= g) =
          g
            (.cons (.value (avalanche (bytes (s.mem.readAt buf (8 * sz.toNat)) sz.toNat i h))) .nil,
              s) := by
  intro k
  induction k with
  | zero =>
    intro i h E hArgs hR hk
    have hf := fits_at hb hnw (i := i) (v := 8) (by omega)
    block_init
    step_load with c
    iterate 4 step_pure
    step_pure with transparent h'
    step_pure
    step_pure
    finish_block
    · step_loop using blk12
      rw [bytes_step _ _ (by omega), bytes_end _ _ (by omega)]
      rw [hS] at hb hnw
      exact byte_eq _ _ _ (read_at hb hnw (by omega))
    · rw [← BitVec.ofNat_add] at hbr
      exact absurd ((add_eq_iff buf sz (by omega)).2 (by omega)) hbr
  | succ k ih =>
    intro i h E hArgs hR hk
    have hf := fits_at hb hnw (i := i) (v := 8) (by omega)
    block_init
    step_load with c
    iterate 4 step_pure
    step_pure with transparent h'
    step_pure
    step_pure
    finish_block
    · rw [← BitVec.ofNat_add] at hbr
      exact absurd ((add_eq_iff buf sz (by omega)).1 hbr) (by omega)
    · subst hS
      refine (ih (i + 1) h' E hArgs ?_ (by omega)).trans ?_
      · env_reads
        · rw [← BitVec.ofNat_add]
        · rw [hh']
      · rw [bytes_step _ h (by omega), hh', byte_eq _ _ _ (hc.trans (read_at hb hnw (by omega)))]

/-- `^bb9`: the bytes from `i`, if any, then the avalanche. -/
theorem blk9 (s : GlobalState) (hb : Fits s.mem buf (8 * sz.toNat))
    (hnw : NoWrap s.mem buf sz.toNat) (i : Nat) (h : BitVec 64) (E : ⟪Γ⟫)
    (hArgs : E.args = (args (.value seed) (.value buf) (.value sz)).get)
    (hR :
      E ⊨ [%0 := 32#64, %2 := 14029467366897019727#64, %5 := 11400714785074694791#64, %16 := 33#64,
        %18 := 2870177450012600261#64, %22 := 1609587929392839161#64, %23 := 11#64, %24 := 29#64,
        %25 := s.mem.addr buf.id + buf.offset, %26 := buf.add sz, %141 := h, %142 :=
        buf.add (BitVec.ofNat 64 i)])
    (hi : i ≤ sz.toNat) :
    (fd_hash_generic.runFrom E ^bb9 s >>= g) =
      g
        (.cons (.value (avalanche (bytes (s.mem.readAt buf (8 * sz.toNat)) sz.toNat i h))) .nil,
          s) := by
  block_init
  step_pure
  finish_block
  · rw [addr_ult_sz_right hnw (by omega), decide_eq_true_eq] at hbr
    block_init
    iterate 4 step_pure
    finish_block
    step_loop using loop11 seed buf sz g s hb hnw (sz.toNat - i - 1) i h
    exact congrArg buf.add (end_off _ _ _ _)
  · rw [addr_ult_sz_right hnw (by omega), decide_eq_true_eq] at hbr
    step_loop using blk12
    rw [bytes_end _ _ hbr]

/-- `^bb7`: the last `uint`, if any, then `^bb9`. -/
theorem blk7 (s : GlobalState) (hb : Fits s.mem buf (8 * sz.toNat))
    (hnw : NoWrap s.mem buf sz.toNat) (i : Nat) (h : BitVec 64) (E : ⟪Γ⟫)
    (hArgs : E.args = (args (.value seed) (.value buf) (.value sz)).get)
    (hR :
      E ⊨ [%0 := 32#64, %2 := 14029467366897019727#64, %5 := 11400714785074694791#64, %16 := 33#64,
        %18 := 2870177450012600261#64, %21 := 23#64, %22 := 1609587929392839161#64, %23 := 11#64,
        %24 := 29#64, %25 := s.mem.addr buf.id + buf.offset, %26 := buf.add sz, %130 := h, %131 :=
        buf.add (BitVec.ofNat 64 i)])
    (hi : i ≤ sz.toNat) :
    (fd_hash_generic.runFrom E ^bb7 s >>= g) =
      g
        (.cons
            (.value
              (avalanche
                (bytes (s.mem.readAt buf (8 * sz.toNat)) sz.toNat
                  (word32 (s.mem.readAt buf (8 * sz.toNat)) sz.toNat i h).2
                  (word32 (s.mem.readAt buf (8 * sz.toNat)) sz.toNat i h).1)))
            .nil,
          s) := by
  block_init
  step_pure
  step_pure
  finish_block
  · rw [← BitVec.ofNat_add, addr_ult_sz_left hnw (by omega), decide_eq_true_eq] at hbr
    refine (blk9 seed buf sz g s hb hnw i h E hArgs ?_ hi).trans ?_
    · env_reads
    · rw [word32, ite_eq_right (by omega)]
  · rw [← BitVec.ofNat_add, addr_ult_sz_left hnw (by omega), decide_eq_true_eq] at hbr
    have hf := fits_at hb hnw (i := i) (v := 32) (by omega)
    block_init
    step_load with c
    iterate 5 step_pure
    step_pure with transparent h'
    finish_block
    subst hS
    rw [← BitVec.ofNat_add, ← hh'] at hE
    refine (blk9 seed buf sz g _ hb hnw (i + 4) h' E hArgs ?_ (by omega)).trans ?_
    · env_reads
    · rw [word32, ite_eq_left (by omega), hh', uint_eq _ _ _ (hc.trans (read_at hb hnw (by omega)))]

/-- What `^bb7` returns from `(h, i)`. -/
def fin7 (b : BitVec n) (sz : Nat) (p : BitVec 64 × Nat) : BitVec 64 :=
  avalanche (bytes b sz (word32 b sz p.2 p.1).2 (word32 b sz p.2 p.1).1)

/-- `^bb6`, the `ulong` loop at byte `i`, `k + 1` `ulong`s left. -/
theorem loop6 (s : GlobalState) (hb : Fits s.mem buf (8 * sz.toNat))
    (hnw : NoWrap s.mem buf sz.toNat) :
    ∀ k i (h : BitVec 64) (E : ⟪Γ⟫),
      E.args = (args (.value seed) (.value buf) (.value sz)).get →
        (E ⊨ [%0 := 32#64, %2 := 14029467366897019727#64, %5 := 11400714785074694791#64, %16 :=
          33#64, %17 := 9650029242287828579#64, %18 := 2870177450012600261#64, %19 :=
          10658460830393171968#64, %20 := 27#64, %21 := 23#64, %22 := 1609587929392839161#64, %23 :=
          11#64, %24 := 29#64, %25 := s.mem.addr buf.id + buf.offset, %26 := buf.add sz, %115 :=
          buf.add (BitVec.ofNat 64 (i + 8)), %116 := buf.add (BitVec.ofNat 64 i), %117 := h]) →
        i + 8 * (k + 1) ≤ sz.toNat →
        sz.toNat < i + 8 * (k + 2) →
        (fd_hash_generic.runFrom E ^bb6 s >>= g) =
          g
            (.cons
                (.value
                  (fin7 (s.mem.readAt buf (8 * sz.toNat)) sz.toNat
                    (words (s.mem.readAt buf (8 * sz.toNat)) sz.toNat i h)))
                .nil,
              s) := by
  intro k
  induction k with
  | zero =>
    intro i h E hArgs hR hk hk'
    have hf := fits_at hb hnw (i := i) (v := 64) (by omega)
    block_init
    step_load with v
    iterate 3 step_pure
    step_pure [disj31]
    iterate 4 step_pure
    step_pure with transparent h'
    step_pure
    step_pure
    finish_block
    · subst hS
      rw [← BitVec.ofNat_add, addr_ult_sz_left hnw (by omega), decide_eq_true_eq] at hbr
      rw [← BitVec.ofNat_add, ← hh'] at hE
      refine (blk7 seed buf sz g _ hb hnw (i + 8) h' E hArgs ?_ (by omega)).trans ?_
      · env_reads
      · rw [words_step _ _ (by omega), words_end _ _ (by omega), hh',
          ulong_eq _ _ _ (hv.trans (read_at hb hnw (by omega)))]
        rfl
    · subst hS
      rw [← BitVec.ofNat_add, addr_ult_sz_left hnw (by omega), decide_eq_true_eq] at hbr
      omega
  | succ k ih =>
    intro i h E hArgs hR hk hk'
    have hf := fits_at hb hnw (i := i) (v := 64) (by omega)
    block_init
    step_load with v
    iterate 3 step_pure
    step_pure [disj31]
    iterate 4 step_pure
    step_pure with transparent h'
    step_pure
    step_pure
    finish_block
    · subst hS
      rw [← BitVec.ofNat_add, addr_ult_sz_left hnw (by omega), decide_eq_true_eq] at hbr
      omega
    · subst hS
      rw [← BitVec.ofNat_add, ← hh'] at hE
      refine (ih (i + 8) h' E hArgs ?_ (by omega) (by omega)).trans ?_
      · env_reads
      · rw [words_step _ h (by omega), hh', ulong_eq _ _ _ (hv.trans (read_at hb hnw (by omega)))]

/-- `^bb5`: `h += sz`, then the `ulong`s from `i`, then `^bb7`. -/
theorem blk5 (s : GlobalState) (hb : Fits s.mem buf (8 * sz.toNat))
    (hnw : NoWrap s.mem buf sz.toNat) (i : Nat) (h : BitVec 64) (E : ⟪Γ⟫)
    (hArgs : E.args = (args (.value seed) (.value buf) (.value sz)).get)
    (hR :
      E ⊨ [%0 := 32#64, %2 := 14029467366897019727#64, %5 := 11400714785074694791#64, %16 := 33#64,
        %17 := 9650029242287828579#64, %18 := 2870177450012600261#64, %19 :=
        10658460830393171968#64, %20 := 27#64, %21 := 23#64, %22 := 1609587929392839161#64, %23 :=
        11#64, %24 := 29#64, %25 := s.mem.addr buf.id + buf.offset, %26 := buf.add sz, %110 := h,
        %111 := buf.add (BitVec.ofNat 64 i)])
    (hi : i ≤ sz.toNat) :
    (fd_hash_generic.runFrom E ^bb5 s >>= g) =
      g
        (.cons
            (.value
              (fin7 (s.mem.readAt buf (8 * sz.toNat)) sz.toNat
                (words (s.mem.readAt buf (8 * sz.toNat)) sz.toNat i (h + sz))))
            .nil,
          s) := by
  block_init
  step_pure
  step_pure
  step_pure
  finish_block
  · rw [← BitVec.ofNat_add, addr_ult_sz_left hnw (by omega), decide_eq_true_eq] at hbr
    refine (blk7 seed buf sz g s hb hnw i (h + sz) E hArgs ?_ hi).trans ?_
    · env_reads
    · rw [words_end _ _ (by omega)]
      rfl
  · rw [← BitVec.ofNat_add, addr_ult_sz_left hnw (by omega), decide_eq_true_eq] at hbr
    rw [← BitVec.ofNat_add] at hE
    exact
      loop6 seed buf sz g s hb hnw ((sz.toNat - i) / 8 - 1) i (h + sz) E hArgs (by env_reads)
        (by omega) (by omega)

/-- `^bb3`, the block loop at byte `i`, `k + 1` blocks left, then `^bb4` and `^bb5`. -/
theorem loop3 (s : GlobalState) (hb : Fits s.mem buf (8 * sz.toNat))
    (hnw : NoWrap s.mem buf sz.toNat) (h32 : 32 ≤ sz.toNat) :
    ∀ k i (a : Lanes) (E : ⟪Γ⟫),
      E.args = (args (.value seed) (.value buf) (.value sz)).get →
        (E ⊨ [%0 := 32#64, %2 := 14029467366897019727#64, %4 := 31#64, %5 :=
          11400714785074694791#64, %6 := 4354685496439837966#64, %7 := 63#64, %8 :=
          1998710666506355584#64, %9 := 57#64, %10 := 8618509107074723840#64, %11 := 52#64, %12 :=
          16629004715205328896#64, %13 := 46#64, %14 := 16065284355873402025#64, %15 :=
          9780892964782866432#64, %16 := 33#64, %17 := 9650029242287828579#64, %18 :=
          2870177450012600261#64, %19 := 10658460830393171968#64, %20 := 27#64, %21 := 23#64, %22 :=
          1609587929392839161#64, %23 := 11#64, %24 := 29#64, %25 := s.mem.addr buf.id + buf.offset,
          %26 := buf.add sz, %29 := buf.add (BitVec.ofNat 64 (sz.toNat - 32)), %33 := a.2.2.2,
          %34 := a.2.2.1, %35 := a.2.1, %36 := a.1, %37 := buf.add (BitVec.ofNat 64 i)]) →
        i + 32 * (k + 1) ≤ sz.toNat →
        sz.toNat < i + 32 * (k + 2) →
        (fd_hash_generic.runFrom E ^bb3 s >>= g) =
          g
            (.cons
                (.value
                  (fin7 (s.mem.readAt buf (8 * sz.toNat)) sz.toNat
                    (words (s.mem.readAt buf (8 * sz.toNat)) sz.toNat
                      (blocks (s.mem.readAt buf (8 * sz.toNat)) sz.toNat i a).2
                      (finish (blocks (s.mem.readAt buf (8 * sz.toNat)) sz.toNat i a).1 + sz))))
                .nil,
              s) := by
  intro k
  induction k with
  | zero =>
    intro i a E hArgs hR hk hk'
    have hf0 := fits_at hb hnw (i := i) (v := 64) (by omega)
    have hf8 : Fits s.mem (buf.add (BitVec.ofNat 64 i + 8#64)) 64 := by
      rw [← BitVec.ofNat_add]; exact fits_at hb hnw (by omega)
    have hf16 : Fits s.mem (buf.add (BitVec.ofNat 64 i + 16#64)) 64 := by
      rw [← BitVec.ofNat_add]; exact fits_at hb hnw (by omega)
    have hf24 : Fits s.mem (buf.add (BitVec.ofNat 64 i + 24#64)) 64 := by
      rw [← BitVec.ofNat_add]; exact fits_at hb hnw (by omega)
    block_init
    step_load with v0
    iterate 2 step_pure
    step_pure with r0
    step_pure
    step_pure
    step_load with v1
    iterate 2 step_pure
    step_pure with r1
    step_pure
    step_pure
    step_load with v2
    iterate 2 step_pure
    step_pure with r2
    step_pure
    step_pure
    step_load with v3
    iterate 2 step_pure
    step_pure with r3
    step_pure
    step_pure
    step_pure
    finish_block
    · block_init
      iterate 8 step_pure
      step_pure [or1_disj]
      iterate 9 step_pure
      step_pure [or31_disj]
      iterate 7 step_pure
      step_pure [or31_disj]
      iterate 7 step_pure
      step_pure [or31_disj]
      iterate 7 step_pure
      step_pure [or31_disj]
      iterate 4 step_pure
      finish_block
      subst hS
      have e0 : v0 = ld64 (S.mem.readAt buf (8 * sz.toNat)) i :=
        hv0.trans (read_at hb hnw (by omega))
      have e1 : v1 = ld64 (S.mem.readAt buf (8 * sz.toNat)) (i + 8) := by
        rw [hv1, ← BitVec.ofNat_add]; exact read_at hb hnw (by omega)
      have e2 : v2 = ld64 (S.mem.readAt buf (8 * sz.toNat)) (i + 16) := by
        rw [hv2, ← BitVec.ofNat_add]; exact read_at hb hnw (by omega)
      have e3 : v3 = ld64 (S.mem.readAt buf (8 * sz.toNat)) (i + 24) := by
        rw [hv3, ← BitVec.ofNat_add]; exact read_at hb hnw (by omega)
      rw [bb4_eq, lane_eq hr0, lane_eq hr1, lane_eq hr2, lane_eq hr3, e0, e1, e2, e3,
        (BitVec.ofNat_add i 32).symm, ← block_def] at hE
      refine
        (blk5 seed buf sz g _ hb hnw (i + 32) (finish (block (S.mem.readAt buf (8 * sz.toNat)) i a))
              E hArgs ?_ (by omega)).trans
          ?_
      · env_reads
      · rw [blocks_end _ _ (by omega)]
    · subst hS
      rw [(BitVec.ofNat_add i 32).symm, addr_ult_nat hnw (by omega) (by omega),
        decide_eq_true_eq] at hbr
      omega
  | succ k ih =>
    intro i a E hArgs hR hk hk'
    have hf0 := fits_at hb hnw (i := i) (v := 64) (by omega)
    have hf8 : Fits s.mem (buf.add (BitVec.ofNat 64 i + 8#64)) 64 := by
      rw [← BitVec.ofNat_add]; exact fits_at hb hnw (by omega)
    have hf16 : Fits s.mem (buf.add (BitVec.ofNat 64 i + 16#64)) 64 := by
      rw [← BitVec.ofNat_add]; exact fits_at hb hnw (by omega)
    have hf24 : Fits s.mem (buf.add (BitVec.ofNat 64 i + 24#64)) 64 := by
      rw [← BitVec.ofNat_add]; exact fits_at hb hnw (by omega)
    block_init
    step_load with v0
    iterate 2 step_pure
    step_pure with r0
    step_pure
    step_pure
    step_load with v1
    iterate 2 step_pure
    step_pure with r1
    step_pure
    step_pure
    step_load with v2
    iterate 2 step_pure
    step_pure with r2
    step_pure
    step_pure
    step_load with v3
    iterate 2 step_pure
    step_pure with r3
    step_pure
    step_pure
    step_pure
    finish_block
    · subst hS
      rw [(BitVec.ofNat_add i 32).symm, addr_ult_nat hnw (by omega) (by omega),
        decide_eq_true_eq] at hbr
      omega
    · subst hS
      have e0 : v0 = ld64 (S.mem.readAt buf (8 * sz.toNat)) i :=
        hv0.trans (read_at hb hnw (by omega))
      have e1 : v1 = ld64 (S.mem.readAt buf (8 * sz.toNat)) (i + 8) := by
        rw [hv1, ← BitVec.ofNat_add]; exact read_at hb hnw (by omega)
      have e2 : v2 = ld64 (S.mem.readAt buf (8 * sz.toNat)) (i + 16) := by
        rw [hv2, ← BitVec.ofNat_add]; exact read_at hb hnw (by omega)
      have e3 : v3 = ld64 (S.mem.readAt buf (8 * sz.toNat)) (i + 24) := by
        rw [hv3, ← BitVec.ofNat_add]; exact read_at hb hnw (by omega)
      rw [lane_eq hr0, lane_eq hr1, lane_eq hr2, lane_eq hr3, e0, e1, e2, e3,
        (BitVec.ofNat_add i 32).symm] at hE
      refine
        (ih (i + 32)
              (lane a.1 (ld64 (S.mem.readAt buf (8 * sz.toNat)) i),
                lane a.2.1 (ld64 (S.mem.readAt buf (8 * sz.toNat)) (i + 8)),
                lane a.2.2.1 (ld64 (S.mem.readAt buf (8 * sz.toNat)) (i + 16)),
                lane a.2.2.2 (ld64 (S.mem.readAt buf (8 * sz.toNat)) (i + 24)))
              E hArgs ?_ (by omega) (by omega)).trans
          ?_
      · env_reads
      · rw [blocks_step _ a (by omega), block_def]

theorem spec_lt (seed : BitVec 64) (b : BitVec n) {sz : Nat} (h : sz < 32) :
    fd_hash.spec seed b sz = fin7 b sz (words b sz 0 (seed + C5 + BitVec.ofNat 64 sz)) := by
  unfold fd_hash.spec head
  rw [ite_eq_left h]
  rfl

theorem spec_ge (seed : BitVec 64) (b : BitVec n) {sz : Nat} (h : ¬sz < 32) :
    fd_hash.spec seed b sz =
      fin7 b sz
        (words b sz (blocks b sz 0 (seed + (C1 + C2), seed + C2, seed, seed - C1)).2
          (finish (blocks b sz 0 (seed + (C1 + C2), seed + C2, seed, seed - C1)).1 +
            BitVec.ofNat 64 sz)) := by
  unfold fd_hash.spec head
  rw [ite_eq_right h]
  rfl

theorem init_eq (seed : BitVec 64) :
    ((seed + (C1 + C2), seed + C2, seed, seed - C1) : Lanes) =
      (seed + 6983438078262162902#64, seed + 14029467366897019727#64, seed,
        seed + 7046029288634856825#64) := by
  simp only [C1, C2, Prod.mk.injEq]
  bv_decide

/-- `stop - 32`'s offset, as the steps leave it. -/
theorem stop32 (sz : BitVec 64) (h : 32 ≤ sz.toNat) :
    sz + 18446744073709551584#64 = BitVec.ofNat 64 (sz.toNat - 32) := by
  apply BitVec.eq_of_toNat_eq
  rw [BitVec.toNat_ofNat, show 18446744073709551584#64 = -32#64 by decide, ← BitVec.sub_eq_add_neg,
    BitVec.toNat_sub_of_le
      (by
        rw [BitVec.le_def]; simpa using h)]
  simp only [BitVec.toNat_ofNat]
  omega

end fd_hash_generic

open fd_hash in
/-- `fd_hash_generic` returns `fd_hash.spec` of the `sz` bytes at `buf`, state unchanged. The lift
compares pointers by address, hence `NoWrap`. -/
public theorem fd_hash_generic.call_eq (seed : BitVec 64) (buf : Pointer) (sz : BitVec 64)
    (s : GlobalState) (hwf : s.WF) (hb : Fits s.mem buf (8 * sz.toNat))
    (hnw : NoWrap s.mem buf sz.toNat) :
    fd_hash_generic.call (fd_hash_generic.args (.value seed) (.value buf) (.value sz)) s =
      .value
        (.cons (.value (fd_hash.spec seed (s.mem.readAt buf (8 * sz.toNat)) sz.toNat)) .nil,
          s) := by
  have hov : ¬buf.offset.uaddOverflow sz := by
    simp only [NoWrap] at hnw
    simp only [BitVec.uaddOverflow, ge_iff_le, decide_eq_true_eq, Nat.not_le]
    omega
  have hlt : sz.toNat < 2 ^ 63 := by
    simp only [NoWrap] at hnw; omega
  func_init
  block_init
  iterate 26 step_pure
  step_pure [hlt]
  step_pure
  finish_block
  · -- `sz < 32`: `h = seed + C5`, then `^bb5` from byte 0
    block_init
    step_pure
    finish_block
    subst hS
    have h32 : sz.toNat < 32 := by simpa [BitVec.ult] using hbr
    refine
      (bind_pure _).symm.trans
        ((blk5 seed buf sz pure _ hb hnw 0 (seed + 2870177450012600261#64) E hArgs ?_
              (by omega)).trans
          ?_)
    · env_reads
      rw [Pointer.add_zero]
    · rw [spec_lt _ _ h32, BitVec.ofNat_toNat, BitVec.setWidth_eq]
      rfl
  · -- `sz ≥ 32`: the four lanes, then the block loop from byte 0
    have h32 : 32 ≤ sz.toNat := by simpa [BitVec.ult] using hbr
    block_init
    step_pure [gepBack_value (f := { nusw := true })
          (show 32 ≤ (buf.add sz).offset.toNat by
            simp only [Pointer.add, BitVec.toNat_add_of_not_uaddOverflow hov]; omega)
          rfl,
      stop32 sz h32]
    iterate 3 step_pure
    finish_block
    subst hS
    refine
      (bind_pure _).symm.trans
        ((loop3 seed buf sz pure _ hb hnw h32 (sz.toNat / 32 - 1) 0
              (seed + 6983438078262162902#64, seed + 14029467366897019727#64, seed,
                seed + 7046029288634856825#64)
              E hArgs ?_ (by omega) (by omega)).trans
          ?_)
    · env_reads
      rw [Pointer.add_zero]
    · rw [spec_ge _ _ (by omega), init_eq, BitVec.ofNat_toNat, BitVec.setWidth_eq]
      rfl

/-- `fd_hash` calls `fd_hash_generic` (the build has no AVX-512 path). -/
public theorem fd_hash.call_eq (seed : BitVec 64) (buf : Pointer) (sz : BitVec 64) (s : GlobalState)
    (hwf : s.WF) (hb : Fits s.mem buf (8 * sz.toNat)) (hnw : fd_hash.NoWrap s.mem buf sz.toNat) :
    fd_hash.call (fd_hash.args (.value seed) (.value buf) (.value sz)) s =
      .value
        (.cons (.value (fd_hash.spec seed (s.mem.readAt buf (8 * sz.toNat)) sz.toNat)) .nil,
          s) := by
  func_init
  block_init
  step_call using fd_hash_generic.call_eq
  finish_block
  rw [hS]

end Proof

end MLIR.Firedancer.Crc.Ref
