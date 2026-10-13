module

public import MLIR.Run.Tactic
public import Ed25519.Sha512
public import Sodium.rotr64
public import Firedancer.Ref.fd_sha512_core_ref
import Std.Tactic.BVDecide
import Mathlib.Tactic.IntervalCases

/-! `SHA512_Transform`'s unrolled rounds `RNDr(S, W, t, i)`, `t ≥ 1`, as an instruction template:
the working variables in registers, `W[i + t]` and `Krnd[i + t]` loaded, `d + T1` and `T1 + T2`
stored to their `S` slots. -/

namespace MLIR.Sodium

open _root_.Ed25519

@[expose] public section

/-! ## The round's arithmetic -/

/-- `ROTR` by `rotr64` on a constant count. -/
theorem rotr64_lit (x : BitVec 64) (n : Nat) (h : n < 64) :
    rotr64.spec x (BitVec.ofNat 32 n) = x.rotateRight n := by
  rw [rotr64.spec_eq x _
      (by
        simp; omega)]
  simp only [BitVec.toNat_ofNat]
  rw [Nat.mod_eq_of_lt (by omega)]

/-- A round's two new words `a' = T1 + T2`, `e' = d + T1`, the sums in the code's order. -/
theorem round_code (a b c d e f g h k w : BitVec 64) :
    Sha512.round #v[a, b, c, d, e, f, g, h] k w =
      #v[((((Sha512.Ch e f g + h) + Sha512.Sigma1 e) + w) + k + Sha512.Maj a b c) + Sha512.Sigma0 a,
        a, b, c, (((Sha512.Ch e f g + h) + Sha512.Sigma1 e) + w) + k + d, e, f, g] := by
  have e1 :
    h + Sha512.Sigma1 e + Sha512.Ch e f g + k + w + (Sha512.Sigma0 a + Sha512.Maj a b c) =
      ((((Sha512.Ch e f g + h) + Sha512.Sigma1 e) + w) + k + Sha512.Maj a b c) +
        Sha512.Sigma0 a := by
    ac_rfl
  have e2 :
    d + (h + Sha512.Sigma1 e + Sha512.Ch e f g + k + w) =
      (((Sha512.Ch e f g + h) + Sha512.Sigma1 e) + w) + k + d := by
    ac_rfl
  rw [← e1, ← e2]
  rfl

/-- Round `0` of an iteration, the sums in its code's order. -/
theorem round_code0 (a b c d e f g h k w : BitVec 64) :
    Sha512.round #v[a, b, c, d, e, f, g, h] k w =
      #v[(Sha512.Sigma0 a + ((((w + Sha512.Sigma1 e) + k) + Sha512.Ch e f g) + h)) +
          Sha512.Maj a b c,
        a, b, c, ((((w + Sha512.Sigma1 e) + k) + Sha512.Ch e f g) + h) + d, e, f, g] := by
  have e1 :
    h + Sha512.Sigma1 e + Sha512.Ch e f g + k + w + (Sha512.Sigma0 a + Sha512.Maj a b c) =
      (Sha512.Sigma0 a + ((((w + Sha512.Sigma1 e) + k) + Sha512.Ch e f g) + h)) +
        Sha512.Maj a b c := by
    ac_rfl
  have e2 :
    d + (h + Sha512.Sigma1 e + Sha512.Ch e f g + k + w) =
      ((((w + Sha512.Sigma1 e) + k) + Sha512.Ch e f g) + h) + d := by
    ac_rfl
  rw [← e1, ← e2]
  rfl

theorem ch_code0 (e f g : BitVec 64) : ((g ^^^ f) &&& e) ^^^ g = Sha512.Ch e f g := by
  simp only [Sha512.Ch]; bv_decide

theorem maj_code0 (a b c : BitVec 64) : ((c ||| b) &&& a) ||| (c &&& b) = Sha512.Maj a b c := by
  simp only [Sha512.Maj]; bv_decide

/-- A vector of eight, as its lanes. -/
theorem vec8_eta (v : Vector (BitVec 64) 8) :
    v = #v[v[0], v[1], v[2], v[3], v[4], v[5], v[6], v[7]] := by
  ext i hi
  interval_cases i <;> rfl

theorem sigma1_code (e : BitVec 64) :
    (rotr64.spec e 18#32 ^^^ rotr64.spec e 14#32) ^^^ rotr64.spec e 41#32 = Sha512.Sigma1 e := by
  rw [rotr64_lit e 18 (by decide), rotr64_lit e 14 (by decide), rotr64_lit e 41 (by decide),
    Sha512.Sigma1]
  bv_decide

theorem sigma0_code (a : BitVec 64) :
    (rotr64.spec a 34#32 ^^^ rotr64.spec a 28#32) ^^^ rotr64.spec a 39#32 = Sha512.Sigma0 a := by
  rw [rotr64_lit a 34 (by decide), rotr64_lit a 28 (by decide), rotr64_lit a 39 (by decide),
    Sha512.Sigma0]
  bv_decide

theorem ch_code (e f g : BitVec 64) : (e &&& (f ^^^ g)) ^^^ g = Sha512.Ch e f g := by
  simp only [Sha512.Ch]; bv_decide

theorem ch_code' (e f g : BitVec 64) : (e &&& (g ^^^ f)) ^^^ g = Sha512.Ch e f g := by
  simp only [Sha512.Ch]; bv_decide

theorem maj_code (a b c : BitVec 64) : (a &&& (b ||| c)) ||| (b &&& c) = Sha512.Maj a b c := by
  simp only [Sha512.Maj]; bv_decide

theorem maj_code' (a b c : BitVec 64) : (a &&& (c ||| b)) ||| (c &&& b) = Sha512.Maj a b c := by
  simp only [Sha512.Maj]; bv_decide

/-- `i | k` for `i` a multiple of `16` and `k < 16`: no common bits. -/
theorem and_ofNat_16 {i k : Nat} (hi : i % 16 = 0) (hk : k < 16) :
    BitVec.ofNat 64 i &&& BitVec.ofNat 64 k = 0#64 := by
  apply BitVec.eq_of_getLsbD_eq
  intro m hm
  simp only [BitVec.getLsbD_and, BitVec.getLsbD_ofNat]
  by_cases h4 : m < 4
  · have := Nat.testBit_mod_two_pow i 4 m
    rw [show i % 2 ^ 4 = 0 by omega, Nat.zero_testBit] at this
    simp [h4] at this
    simp [this]
  · simp [Nat.testBit_lt_two_pow
          (show k < 2 ^ m from
            Nat.lt_of_lt_of_le hk (Nat.pow_le_pow_right (by decide) (by omega) : 2 ^ 4 ≤ 2 ^ m))]

/-- `i | k` is `i + k` then. -/
theorem or_ofNat_16 {i k : Nat} (hi : i % 16 = 0) (hk : k < 16) :
    BitVec.ofNat 64 i ||| BitVec.ofNat 64 k = BitVec.ofNat 64 (i + k) := by
  rw [← BitVec.add_eq_or_of_and_eq_zero _ _ (and_ofNat_16 hi hk), BitVec.ofNat_add]

/-! ## The `S` slots -/

open Memory in
/-- Lane `k` of eight stored words. -/
theorem readAt_storeWords8_lane {m : MemoryState} {p : Pointer} (hm : Room m p 512)
    (hp : p.offset.toNat + 56 < 2 ^ 64) (v : Vector (BitVec 64) 8) {k : Nat} (hk : k < 8) :
    (m.storeWords8 p v).readAt (p.add (BitVec.ofNat 64 (8 * k))) 64 = v[k] := by
  have ho (c : BitVec 64) (hc : c.toNat ≤ 56) :
    (p.add c).offsetInBits = p.offsetInBits + 8 * c.toNat := by
    simp only [Pointer.offsetInBits, Pointer.add, BitVec.toNat_add]
    rw [Nat.mod_eq_of_lt (by omega)]; omega
  obtain ⟨⟨blk, hblk, -, hsz⟩, blk', hblk', hwr⟩ := hm
  rw [hblk] at hblk'
  cases hblk'
  simp only [MemoryBlock.lengthInBits] at hsz
  simp only [MemoryState.storeWords8, MemoryState.readAt, MemoryState.storeAt,
    Pointer.add_id, MemoryState.modifyBlock_modifyBlock_self, implies_true,
    MemoryState.getElem?_modifyBlock_self, hblk, Option.map_some, Function.comp_apply,
    MemoryBlock.update, hwr, ite_true]
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  interval_cases k <;>
    simp (disch := decide) only [BitVec.getLsbD_extractLsb', hi, decide_true, Bool.true_and,
      getLsbD_spliceBits, ho, Nat.mul_zero, Pointer.add_zero, BitVec.toNat_ofNat] <;>
    grind

open Memory in
/-- A store to lane `k` of eight stored words: the words with lane `k` set. -/
theorem storeWords8_storeAt_lane {m : MemoryState} {p : Pointer} (hp : p.offset.toNat + 56 < 2 ^ 64)
    (v : Vector (BitVec 64) 8) (y : BitVec 64) {k : Nat} (hk : k < 8) :
    (m.storeWords8 p v).storeAt (p.add (BitVec.ofNat 64 (8 * k))) y =
      m.storeWords8 p (v.set k y hk) := by
  have ho (c : BitVec 64) (hc : c.toNat ≤ 56) :
    (p.add c).offsetInBits = p.offsetInBits + 8 * c.toNat := by
    simp only [Pointer.offsetInBits, Pointer.add, BitVec.toNat_add]
    rw [Nat.mod_eq_of_lt (by omega)]; omega
  interval_cases k <;>
    · simp only [MemoryState.storeWords8, MemoryState.storeAt, Pointer.add_id,
        MemoryState.modifyBlock_modifyBlock_self, implies_true, Function.comp_apply]
      congr 1
      funext blk
      simp (disch := decide) only [Function.comp_apply, MemoryBlock.mk.injEq, true_and, and_true,
        ho, Nat.mul_zero, Pointer.add_zero, BitVec.toNat_ofNat]
      refine ⟨heq_of_eq ?_, heq_of_eq ?_⟩ <;> apply BitVec.eq_of_getLsbD_eq <;> intro i hi <;>
        simp only [getLsbD_spliceBits, Vector.getElem_set] <;>
        simp <;>
        grind

/-- A store to lane `k` of eight stored words, all named. -/
theorem storeWords8_storeAt_lane0 {m : MemoryState} {p : Pointer}
    (hp : p.offset.toNat + 56 < 2 ^ 64) (x0 x1 x2 x3 x4 x5 x6 x7 y : BitVec 64) :
    (m.storeWords8 p #v[x0, x1, x2, x3, x4, x5, x6, x7]).storeAt p y =
      m.storeWords8 p #v[y, x1, x2, x3, x4, x5, x6, x7] := by
  have :=
    storeWords8_storeAt_lane (m := m) hp #v[x0, x1, x2, x3, x4, x5, x6, x7] y (k := 0) (by decide)
  simp only [Nat.mul_zero, Pointer.add_zero] at this
  exact this

theorem storeWords8_storeAt_lane1 {m : MemoryState} {p : Pointer}
    (hp : p.offset.toNat + 56 < 2 ^ 64) (x0 x1 x2 x3 x4 x5 x6 x7 y : BitVec 64) :
    (m.storeWords8 p #v[x0, x1, x2, x3, x4, x5, x6, x7]).storeAt (p.add 8#64) y =
      m.storeWords8 p #v[x0, y, x2, x3, x4, x5, x6, x7] := by
  exact storeWords8_storeAt_lane hp #v[x0, x1, x2, x3, x4, x5, x6, x7] y (k := 1) (by decide)

theorem storeWords8_storeAt_lane2 {m : MemoryState} {p : Pointer}
    (hp : p.offset.toNat + 56 < 2 ^ 64) (x0 x1 x2 x3 x4 x5 x6 x7 y : BitVec 64) :
    (m.storeWords8 p #v[x0, x1, x2, x3, x4, x5, x6, x7]).storeAt (p.add 16#64) y =
      m.storeWords8 p #v[x0, x1, y, x3, x4, x5, x6, x7] := by
  exact storeWords8_storeAt_lane hp #v[x0, x1, x2, x3, x4, x5, x6, x7] y (k := 2) (by decide)

theorem storeWords8_storeAt_lane3 {m : MemoryState} {p : Pointer}
    (hp : p.offset.toNat + 56 < 2 ^ 64) (x0 x1 x2 x3 x4 x5 x6 x7 y : BitVec 64) :
    (m.storeWords8 p #v[x0, x1, x2, x3, x4, x5, x6, x7]).storeAt (p.add 24#64) y =
      m.storeWords8 p #v[x0, x1, x2, y, x4, x5, x6, x7] := by
  exact storeWords8_storeAt_lane hp #v[x0, x1, x2, x3, x4, x5, x6, x7] y (k := 3) (by decide)

theorem storeWords8_storeAt_lane4 {m : MemoryState} {p : Pointer}
    (hp : p.offset.toNat + 56 < 2 ^ 64) (x0 x1 x2 x3 x4 x5 x6 x7 y : BitVec 64) :
    (m.storeWords8 p #v[x0, x1, x2, x3, x4, x5, x6, x7]).storeAt (p.add 32#64) y =
      m.storeWords8 p #v[x0, x1, x2, x3, y, x5, x6, x7] := by
  exact storeWords8_storeAt_lane hp #v[x0, x1, x2, x3, x4, x5, x6, x7] y (k := 4) (by decide)

theorem storeWords8_storeAt_lane5 {m : MemoryState} {p : Pointer}
    (hp : p.offset.toNat + 56 < 2 ^ 64) (x0 x1 x2 x3 x4 x5 x6 x7 y : BitVec 64) :
    (m.storeWords8 p #v[x0, x1, x2, x3, x4, x5, x6, x7]).storeAt (p.add 40#64) y =
      m.storeWords8 p #v[x0, x1, x2, x3, x4, y, x6, x7] := by
  exact storeWords8_storeAt_lane hp #v[x0, x1, x2, x3, x4, x5, x6, x7] y (k := 5) (by decide)

theorem storeWords8_storeAt_lane6 {m : MemoryState} {p : Pointer}
    (hp : p.offset.toNat + 56 < 2 ^ 64) (x0 x1 x2 x3 x4 x5 x6 x7 y : BitVec 64) :
    (m.storeWords8 p #v[x0, x1, x2, x3, x4, x5, x6, x7]).storeAt (p.add 48#64) y =
      m.storeWords8 p #v[x0, x1, x2, x3, x4, x5, y, x7] := by
  exact storeWords8_storeAt_lane hp #v[x0, x1, x2, x3, x4, x5, x6, x7] y (k := 6) (by decide)

theorem storeWords8_storeAt_lane7 {m : MemoryState} {p : Pointer}
    (hp : p.offset.toNat + 56 < 2 ^ 64) (x0 x1 x2 x3 x4 x5 x6 x7 y : BitVec 64) :
    (m.storeWords8 p #v[x0, x1, x2, x3, x4, x5, x6, x7]).storeAt (p.add 56#64) y =
      m.storeWords8 p #v[x0, x1, x2, x3, x4, x5, x6, y] := by
  exact storeWords8_storeAt_lane hp #v[x0, x1, x2, x3, x4, x5, x6, x7] y (k := 7) (by decide)

/-! ## The template -/

/-- `(x, y)`, or `(y, x)` when `sw`: the operand order of a commutative operation. -/
def ord (sw : Bool) (x y : Dst Γ τ) : Reg Γ τ × Reg Γ τ :=
  match sw with
  | false => (.val x.i x.h, .val y.i y.h)
  | true => (.val y.i y.h, .val x.i x.h)

/-- `RNDr(S, W, t, i)` for `t ≥ 1`: `Σ₁(e)` by three `rotr64`, `Ch(e, f, g)`, `W[i | t]` and
`Krnd[i | t]` loaded, `T1 = Ch + h + Σ₁ + W + K`, `d + T1` stored to `d`'s slot, `Σ₀(a)`,
`Maj(a, b, c)`, `T1 + Maj + Σ₀` stored to `h`'s slot. `sw` swaps the operands of `f ^ g` and of
`b | c`, `b & c`. -/
def roundRun (sw : Bool) (ra rb rc rd re rf rg rh : Dst Γ (.bv 64))
    (k14 k18 k41 k28 k34 k39 : Dst Γ (.bv 32)) (ri kj : Dst Γ (.bv 64)) (w kp pd ph : Reg Γ .ptr)
    (s1a s1b s1x s1c s1 c0 c1 ch idx : Dst Γ (.bv 64)) (pw : Dst Γ .ptr) (wt : Dst Γ (.bv 64))
    (pk : Dst Γ .ptr) (kt t0 t1 t2 t e' s0a s0b s0x s0c s0 m0 m1 m2 maj u a' : Dst Γ (.bv 64)) :
    List (Instr Γ) :=
  [.call rotr64.call (.cons (.val re.i re.h) (.cons (.val k14.i k14.h) .nil)) (.cons s1a .nil),
    .call rotr64.call (.cons (.val re.i re.h) (.cons (.val k18.i k18.h) .nil)) (.cons s1b .nil),
    .binop .xor s1x (.val s1b.i s1b.h) (.val s1a.i s1a.h),
    .call rotr64.call (.cons (.val re.i re.h) (.cons (.val k41.i k41.h) .nil)) (.cons s1c .nil),
    .binop .xor s1 (.val s1x.i s1x.h) (.val s1c.i s1c.h),
    .binop .xor c0 (ord sw rf rg).1 (ord sw rf rg).2,
    .binop .and c1 (.val re.i re.h) (.val c0.i c0.h),
    .binop .xor ch (.val c1.i c1.h) (.val rg.i rg.h),
    .binop (.or true) idx (.val ri.i ri.h) (.val kj.i kj.h),
    .binop (.gepDyn {} 0 8) pw w (.val idx.i idx.h), .load wt (.val pw.i pw.h),
    .binop (.gepDyn {} 0 8) pk kp (.val idx.i idx.h), .load kt (.val pk.i pk.h),
    .binop (.add {}) t0 (.val ch.i ch.h) (.val rh.i rh.h),
    .binop (.add {}) t1 (.val t0.i t0.h) (.val s1.i s1.h),
    .binop (.add {}) t2 (.val t1.i t1.h) (.val wt.i wt.h),
    .binop (.add {}) t (.val t2.i t2.h) (.val kt.i kt.h),
    .binop (.add {}) e' (.val t.i t.h) (.val rd.i rd.h), .store pd (.val e'.i e'.h),
    .call rotr64.call (.cons (.val ra.i ra.h) (.cons (.val k28.i k28.h) .nil)) (.cons s0a .nil),
    .call rotr64.call (.cons (.val ra.i ra.h) (.cons (.val k34.i k34.h) .nil)) (.cons s0b .nil),
    .binop .xor s0x (.val s0b.i s0b.h) (.val s0a.i s0a.h),
    .call rotr64.call (.cons (.val ra.i ra.h) (.cons (.val k39.i k39.h) .nil)) (.cons s0c .nil),
    .binop .xor s0 (.val s0x.i s0x.h) (.val s0c.i s0c.h),
    .binop (.or false) m0 (ord sw rb rc).1 (ord sw rb rc).2,
    .binop .and m1 (.val ra.i ra.h) (.val m0.i m0.h),
    .binop .and m2 (ord sw rb rc).1 (ord sw rb rc).2,
    .binop (.or false) maj (.val m1.i m1.h) (.val m2.i m2.h),
    .binop (.add {}) u (.val t.i t.h) (.val maj.i maj.h),
    .binop (.add {}) a' (.val u.i u.h) (.val s0.i s0.h), .store ph (.val a'.i a'.h)]

/-- Where the body at `pos` is `roundRun`, the registers hold round `i + k`'s working variables
`#v[A, …, H]` and the constants, and `W[i + k] = Wt`, `Krnd[i + k]` are known: running on from `pos`
then `g` gives `K` if it does from `pos + 31` with the round's new words `A'`, `E'` in `a'`, `e'`
and stored at `PH`, `PD`. -/
theorem runBodyFrom_roundRun {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat} {sw : Bool}
    {ra rb rc rd re rf rg rh : Dst Γ (.bv 64)} {k14 k18 k41 k28 k34 k39 : Dst Γ (.bv 32)}
    {ri kj : Dst Γ (.bv 64)} {w kp pd ph : Reg Γ .ptr}
    {s1a s1b s1x s1c s1 c0 c1 ch idx : Dst Γ (.bv 64)} {pw : Dst Γ .ptr} {wt : Dst Γ (.bv 64)}
    {pk : Dst Γ .ptr} {kt t0 t1 t2 t e' s0a s0b s0x s0c s0 m0 m1 m2 maj u a' : Dst Γ (.bv 64)}
    {rest : List (Instr Γ)} {A B C D Ee F G H Wt : BitVec 64} {Wp Kp PD PH : Pointer}
    {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β} (i k : Nat)
    (hbody :
      blk.body.drop pos =
        roundRun sw ra rb rc rd re rf rg rh k14 k18 k41 k28 k34 k39 ri kj w kp pd ph s1a s1b s1x
            s1c s1 c0 c1 ch idx pw wt pk kt t0 t1 t2 t e' s0a s0b s0x s0c s0 m0 m1 m2 maj u a' ++
          rest)
    (hR :
      E ⊨ [ra := A, rb := B, rc := C, rd := D, re := Ee, rf := F, rg := G, rh := H, k14 := 14#32,
        k18 := 18#32, k41 := 41#32, k28 := 28#32, k34 := 34#32, k39 := 39#32,
        ri := BitVec.ofNat 64 i, kj := BitVec.ofNat 64 k])
    (hw : E.read w = .value Wp) (hkp : E.read kp = .value Kp) (hpd : E.read pd = .value PD)
    (hph : E.read ph = .value PH) (hkpw : kp ≠ .val pw.i pw.h) (hpdw : pd ≠ .val pw.i pw.h)
    (hpdk : pd ≠ .val pk.i pk.h) (hphw : ph ≠ .val pw.i pw.h) (hphk : ph ≠ .val pk.i pk.h)
    (hd :
      [ra.i, rb.i, rc.i, rd.i, re.i, rf.i, rg.i, rh.i, k14.i, k18.i, k41.i, k28.i, k34.i, k39.i,
          ri.i, kj.i, s1a.i, s1b.i, s1x.i, s1c.i, s1.i, c0.i, c1.i, ch.i, idx.i, pw.i, wt.i, pk.i,
          kt.i, t0.i, t1.i, t2.i, t.i, e'.i, s0a.i, s0b.i, s0x.i, s0c.i, s0.i, m0.i, m1.i, m2.i,
          maj.i, u.i, a'.i].Nodup)
    (hi : i % 16 = 0) (hk : k < 16) (hik : i + k < 80) (hwf : S.WF)
    (hfW : Fits S.mem (Wp.add (BitVec.ofNat 64 (8 * (i + k)))) 64)
    (hW : S.mem.readAt (Wp.add (BitVec.ofNat 64 (8 * (i + k)))) 64 = Wt)
    (hfK : Fits S.mem (Kp.add (BitVec.ofNat 64 (8 * (i + k)))) 64)
    (hKt : S.mem.readAt (Kp.add (BitVec.ofNat 64 (8 * (i + k)))) 64 = Sha512.K[i + k]!)
    (hrd : Room S.mem PD 64) (hrh : Room S.mem PH 64)
    (hK :
      ∀ (vs1a vs1b vs1x vs1c vs1 vc0 vc1 vch vidx : ⟦.bv 64⟧) (vwt : ⟦.bv 64⟧) (vpk : ⟦.ptr⟧)
        (vkt vt0 vt1 vt2 vt vs0a vs0b vs0x vs0c vs0 vm0 vm1 vm2 vmaj vu : ⟦.bv 64⟧)
        (A' E' : BitVec 64)
        (_hr : Sha512.round #v[A, B, C, D, Ee, F, G, H] Sha512.K[i + k]! Wt =
            #v[A', A, B, C, E', Ee, F, G]),
          (blk.runBodyFrom
                E[s1a := vs1a, s1b := vs1b, s1x := vs1x, s1c := vs1c, s1 := vs1, c0 := vc0,
                  c1 := vc1, ch := vch, idx := vidx,
                  pw := .value (Wp.add (BitVec.ofNat 64 (8 * (i + k)))), wt := vwt, pk := vpk,
                  kt := vkt,
                  t0 := vt0, t1 := vt1, t2 := vt2, t := vt, e' := .value E', s0a := vs0a,
                  s0b := vs0b, s0x := vs0x, s0c := vs0c, s0 := vs0, m0 := vm0, m1 := vm1, m2 := vm2,
                  maj := vmaj, u := vu, a' := .value A']
                (pos + 31) { alloc := S.alloc, mem := (S.mem.storeAt PD E').storeAt PH A' } >>=
              g) =
            K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  have hik64 : i + k < 18446744073709551616 := by omega
  have hik8 : 8 * (i + k) < 18446744073709551616 := by omega
  cases sw <;> dsimp only [roundRun, ord] at hbody
  all_goals
    step_call using rotr64.call_eq
    step_call using rotr64.call_eq
    step_pure
    step_call using rotr64.call_eq
    step_pure
    step_pure
    step_pure
    step_pure
    step_pure [and_ofNat_16 hi hk, or_ofNat_16 hi hk]
    step_pure [Nat.mod_eq_of_lt hik64, Nat.mul_comm (i + k) 8, hik8]
    step_load consuming hfW hW
    step_pure [Nat.mod_eq_of_lt hik64, Nat.mul_comm (i + k) 8, hik8]
    step_load consuming hfK hKt
    iterate 3 step_pure
    step_pure with transparent vT1
    step_pure with ve
    step_store
    step_call using rotr64.call_eq
    step_call using rotr64.call_eq
    step_pure
    step_call using rotr64.call_eq
    iterate 6 step_pure
    step_pure with va
    step_store
    have hr :
        Sha512.round #v[A, B, C, D, Ee, F, G, H] Sha512.K[i + k]! Wt =
          #v[va, A, B, C, ve, Ee, F, G] := by
      rw [hva, hve, round_code, getElem!_pos Sha512.K (i + k) hik]
      first
        | simp only [sigma1_code, sigma0_code, ch_code, maj_code]; done
        | simp only [sigma1_code, sigma0_code, ch_code', maj_code']
    rw [hE, hS]
    exact hK _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ va ve hr

end

end MLIR.Sodium
