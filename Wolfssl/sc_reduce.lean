module

public import MLIR.Run.Tactic
public import Wolfssl.Mlir.sc_reduce
public import Wolfssl.Common.Bounds
public import Firedancer.Common.Memory
import Std.Tactic.BVDecide
meta import Std.Tactic.BVDecide.Reflect

namespace MLIR.Wolfssl

open _root_.Wolfssl.Mlir

/-! ## Specification -/

@[expose] public section

/-- `load_6(s + k)` on the 64 bytes `x`. -/
def sc_reduce.load6 (x : BitVec 512) (k : Nat) : BitVec 64 :=
  (x.extractLsb' (8 * k) 48).setWidth 64

/-- `load_7(s + k)` on the 64 bytes `x`. -/
def sc_reduce.load7 (x : BitVec 512) (k : Nat) : BitVec 64 :=
  (x.extractLsb' (8 * k) 56).setWidth 64

/-- `MASK_42 & (load_6(s + k) >> n)` on the 64 bytes `x`, widened to `t[k]`'s 128 bits. -/
def sc_reduce.limb (x : BitVec 512) (k n : Nat) : BitVec 128 :=
  (4398046511103#64 &&& load6 x k >>> n).setWidth 128

/-- The 32 bytes `s[0] … s[31]` the C stores from the reduced limbs `t[0] … t[5]`. -/
def sc_reduce.bytes (t0 t1 t2 t3 t4 t5 : BitVec 128) : BitVec 256 :=
  let s0 := t0.setWidth 8
  let s1 := (t0.sshiftRight 8).setWidth 8
  let s2 := (t0.sshiftRight 16).setWidth 8
  let s3 := (t0.sshiftRight 24).setWidth 8
  let s4 := (t0.sshiftRight 32).setWidth 8
  let s5 := (t0.sshiftRight 40).setWidth 8 ||| t1.setWidth 8 <<< 2
  let s6 := (t1.sshiftRight 6).setWidth 8
  let s7 := (t1.sshiftRight 14).setWidth 8
  let s8 := (t1.sshiftRight 22).setWidth 8
  let s9 := (t1.sshiftRight 30).setWidth 8
  let s10 := (t1.sshiftRight 38).setWidth 8 ||| t2.setWidth 8 <<< 4
  let s11 := (t2.sshiftRight 4).setWidth 8
  let s12 := (t2.sshiftRight 12).setWidth 8
  let s13 := (t2.sshiftRight 20).setWidth 8
  let s14 := (t2.sshiftRight 28).setWidth 8
  let s15 := (t2.sshiftRight 36).setWidth 8 ||| t3.setWidth 8 <<< 6
  let s16 := (t3.sshiftRight 2).setWidth 8
  let s17 := (t3.sshiftRight 10).setWidth 8
  let s18 := (t3.sshiftRight 18).setWidth 8
  let s19 := (t3.sshiftRight 26).setWidth 8
  let s20 := (t3.sshiftRight 34).setWidth 8
  let s21 := t4.setWidth 8
  let s22 := (t4.sshiftRight 8).setWidth 8
  let s23 := (t4.sshiftRight 16).setWidth 8
  let s24 := (t4.sshiftRight 24).setWidth 8
  let s25 := (t4.sshiftRight 32).setWidth 8
  let s26 := (t4.sshiftRight 40).setWidth 8 ||| t5.setWidth 8 <<< 2
  let s27 := (t5.sshiftRight 6).setWidth 8
  let s28 := (t5.sshiftRight 14).setWidth 8
  let s29 := (t5.sshiftRight 22).setWidth 8
  let s30 := (t5.sshiftRight 30).setWidth 8
  let s31 := (t5.sshiftRight 38).setWidth 8
  s31 ++ s30 ++ s29 ++ s28 ++ s27 ++ s26 ++ s25 ++ s24 ++ s23 ++ s22 ++ s21 ++ s20 ++ s19 ++ s18 ++
    s17 ++ s16 ++ s15 ++ s14 ++ s13 ++ s12 ++ s11 ++ s10 ++ s9 ++ s8 ++ s7 ++ s6 ++ s5 ++ s4 ++
    s3 ++ s2 ++ s1 ++ s0

open sc_reduce in
/-- `s mod ℓ` as the C computes it, on the 64 bytes `x`: twelve signed 128-bit limbs of 42 bits,
the limbs at and above `2^252` folded down by `2^252 ≡ -(ORDER_0 + ORDER_1 2^42 + ORDER_2 2^84)
(mod ℓ)`, the carries between, and the six low limbs stored as 32 bytes. `MASK_42` is
`4398046511103`, `ORDER_0 … ORDER_2` are `3411763647469`, `2092548097176`, `1434244213295`; the
byte stores' shifts by `0` are left out. -/
def sc_reduce.spec (x : BitVec 512) : BitVec 256 :=
  let t0 := limb x 0 0
  let t1 := limb x 5 2
  let t2 := limb x 10 4
  let t3 := limb x 15 6
  let t4 := limb x 21 0
  let t5 := limb x 26 2
  let t6 := limb x 31 4
  let t7 := limb x 36 6
  let t8 := limb x 42 0
  let t9 := limb x 47 2
  let t10 := limb x 52 4
  let t11 := (load7 x 57 >>> 6).setWidth 128
  let t5 := t5 - t11 * 3411763647469#128
  let t6 := t6 - t11 * 2092548097176#128
  let t7 := t7 - t11 * 1434244213295#128
  let t4 := t4 - t10 * 3411763647469#128
  let t5 := t5 - t10 * 2092548097176#128
  let t6 := t6 - t10 * 1434244213295#128
  let t3 := t3 - t9 * 3411763647469#128
  let t4 := t4 - t9 * 2092548097176#128
  let t5 := t5 - t9 * 1434244213295#128
  let carry := t3.sshiftRight 42
  let t4 := t4 + carry
  let t3 := t3 &&& 4398046511103#128
  let carry := t5.sshiftRight 42
  let t6 := t6 + carry
  let t5 := t5 &&& 4398046511103#128
  let carry := t7.sshiftRight 42
  let t8 := t8 + carry
  let t7 := t7 &&& 4398046511103#128
  let carry := t4.sshiftRight 42
  let t5 := t5 + carry
  let t4 := t4 &&& 4398046511103#128
  let carry := t6.sshiftRight 42
  let t7 := t7 + carry
  let t6 := t6 &&& 4398046511103#128
  let t2 := t2 - t8 * 3411763647469#128
  let t3 := t3 - t8 * 2092548097176#128
  let t4 := t4 - t8 * 1434244213295#128
  let t1 := t1 - t7 * 3411763647469#128
  let t2 := t2 - t7 * 2092548097176#128
  let t3 := t3 - t7 * 1434244213295#128
  let t0 := t0 - t6 * 3411763647469#128
  let t1 := t1 - t6 * 2092548097176#128
  let t2 := t2 - t6 * 1434244213295#128
  let t6 := 0#128
  let carry := t0.sshiftRight 42
  let t1 := t1 + carry
  let t0 := t0 &&& 4398046511103#128
  let carry := t1.sshiftRight 42
  let t2 := t2 + carry
  let t1 := t1 &&& 4398046511103#128
  let carry := t2.sshiftRight 42
  let t3 := t3 + carry
  let t2 := t2 &&& 4398046511103#128
  let carry := t3.sshiftRight 42
  let t4 := t4 + carry
  let t3 := t3 &&& 4398046511103#128
  let carry := t4.sshiftRight 42
  let t5 := t5 + carry
  let t4 := t4 &&& 4398046511103#128
  let carry := t5.sshiftRight 42
  let t6 := t6 + carry
  let t5 := t5 &&& 4398046511103#128
  let t0 := t0 - t6 * 3411763647469#128
  let t1 := t1 - t6 * 2092548097176#128
  let t2 := t2 - t6 * 1434244213295#128
  let carry := t0.sshiftRight 42
  let t1 := t1 + carry
  let t0 := t0 &&& 4398046511103#128
  let carry := t1.sshiftRight 42
  let t2 := t2 + carry
  let t1 := t1 &&& 4398046511103#128
  let carry := t2.sshiftRight 42
  let t3 := t3 + carry
  let t2 := t2 &&& 4398046511103#128
  let carry := t3.sshiftRight 42
  let t4 := t4 + carry
  let t3 := t3 &&& 4398046511103#128
  let carry := t4.sshiftRight 42
  let t5 := t5 + carry
  let t4 := t4 &&& 4398046511103#128
  bytes t0 t1 t2 t3 t4 t5

end

/-! ## Proof -/

section Proof

/-! The flags of the byte loads' shifts and ors: a byte moved up stays clear of the bits below. -/

theorem sc_reduce.shl32_ushr (y : BitVec 8) : y.setWidth 64 <<< 32 >>> 32 = y.setWidth 64 := by
  bv_decide

theorem sc_reduce.shl40_ushr (y : BitVec 8) : y.setWidth 64 <<< 40 >>> 40 = y.setWidth 64 := by
  bv_decide

theorem sc_reduce.shl48_ushr (y : BitVec 8) : y.setWidth 64 <<< 48 >>> 48 = y.setWidth 64 := by
  bv_decide

theorem sc_reduce.shl32_sshr (y : BitVec 8) :
    (y.setWidth 64 <<< 32).sshiftRight 32 = y.setWidth 64 := by
  bv_decide

theorem sc_reduce.shl40_sshr (y : BitVec 8) :
    (y.setWidth 64 <<< 40).sshiftRight 40 = y.setWidth 64 := by
  bv_decide

theorem sc_reduce.shl48_sshr (y : BitVec 8) :
    (y.setWidth 64 <<< 48).sshiftRight 48 = y.setWidth 64 := by
  bv_decide

theorem sc_reduce.or32 (y : BitVec 8) (w : BitVec 32) :
    y.setWidth 64 <<< 32 &&& w.setWidth 64 = 0#64 := by
  bv_decide

theorem sc_reduce.or40 (y z : BitVec 8) (w : BitVec 32) :
    (y.setWidth 64 <<< 32 ||| w.setWidth 64) &&& z.setWidth 64 <<< 40 = 0#64 := by
  bv_decide

theorem sc_reduce.or40_mask (y z : BitVec 8) (w : BitVec 32) :
    (y.setWidth 64 <<< 32 ||| w.setWidth 64) &&& (z.setWidth 64 <<< 40 &&& 3298534883328#64) =
      0#64 := by
  bv_decide

theorem sc_reduce.or48 (y z v : BitVec 8) (w : BitVec 32) :
    (y.setWidth 64 <<< 32 ||| w.setWidth 64 ||| z.setWidth 64 <<< 40) &&& v.setWidth 64 <<< 48 =
      0#64 := by
  bv_decide

theorem sc_reduce.msb_setWidth32 (w : BitVec 32) : (w.setWidth 64).msb = false := by
  bv_decide

/-! The stores' byte merges: a limb's low bits moved up clear of the previous limb's top bits. -/

theorem sc_reduce.or_shl2 (a b : BitVec 8) : a <<< 2 &&& (b &&& 3#8) = 0#8 := by
  bv_decide

theorem sc_reduce.or_shl4 (a b : BitVec 8) : a <<< 4 &&& (b &&& 15#8) = 0#8 := by
  bv_decide

theorem sc_reduce.or_shl6 (a b : BitVec 8) : a <<< 6 &&& (b &&& 63#8) = 0#8 := by
  bv_decide

/-- Four packed bytes, lane 0 lowest. -/
theorem sc_reduce.packLanes4 (v : Vector (BitVec 8) 4) :
    BitVec.packLanes v = v[3] ++ (v[2] ++ (v[1] ++ v[0])) := by
  simp only [BitVec.packLanes, Vector.tail_eq_cast_extract, Vector.getElem_cast,
    Vector.getElem_extract, Nat.reduceAdd]
  generalize v[0] = a, v[1] = b, v[2] = c, v[3] = d
  bv_decide

/-- Eight packed bytes, lane 0 lowest. -/
theorem sc_reduce.packLanes8 (v : Vector (BitVec 8) 8) :
    BitVec.packLanes v =
      v[7] ++ (v[6] ++ (v[5] ++ (v[4] ++ (v[3] ++ (v[2] ++ (v[1] ++ v[0])))))) := by
  simp only [BitVec.packLanes, Vector.tail_eq_cast_extract, Vector.getElem_cast,
    Vector.getElem_extract, Nat.reduceAdd]
  generalize v[0] = a, v[1] = b, v[2] = c, v[3] = d, v[4] = e, v[5] = f, v[6] = g, v[7] = h
  bv_decide

attribute [local simp] sc_reduce.shl32_ushr sc_reduce.shl40_ushr sc_reduce.shl48_ushr
  sc_reduce.shl32_sshr sc_reduce.shl40_sshr sc_reduce.shl48_sshr sc_reduce.or32 sc_reduce.or40
  sc_reduce.or40_mask sc_reduce.or48 sc_reduce.msb_setWidth32 sc_reduce.or_shl2 sc_reduce.or_shl4
  sc_reduce.or_shl6

/-! ### The limbs' loads

Each `t[k]` but the last is a run of loads at `s + k`, `s + k + 4` and `s + k + 5`: a 32-bit word
and two bytes, shifted into place and or'd as `load_6`'s low 48 bits, then shifted down and masked.
The three shapes the compiler leaves are a pattern each; every lemma gives `t[k]` in the spec's
form. -/

/-- A limb is below `2^42`. -/
theorem sc_reduce.limb_bnd (x : BitVec 512) (k n : Nat) :
    Bnd128 (sc_reduce.limb x k n) 0 4398046511103 := by
  have h : (sc_reduce.limb x k n).toNat ≤ 4398046511103 := by
    unfold sc_reduce.limb
    rw [BitVec.toNat_setWidth, BitVec.toNat_and]
    exact Nat.le_trans (Nat.mod_le _ _) Nat.and_le_left
  refine ⟨?_, ?_⟩ <;> rw [BitVec.toInt_eq_toNat_of_lt (by omega)] <;> omega

/-- The compiled `t[11]`: the word at `s + 57` and the bytes at `s + 61 … 63`. -/
theorem sc_reduce.limb11_eq (x : BitVec 512) :
    (BitVec.setWidth 128 (BitVec.setWidth 64 (x.extractLsb' 488 8) <<< 32) |||
            BitVec.setWidth 128 (x.extractLsb' 456 32) |||
          BitVec.setWidth 128 (BitVec.setWidth 64 (x.extractLsb' 496 8) <<< 40) |||
        BitVec.setWidth 128 (BitVec.setWidth 64 (x.extractLsb' 504 8) <<< 48)) >>> 6 =
      (sc_reduce.load7 x 57 >>> 6).setWidth 128 := by
  unfold sc_reduce.load7
  bv_decide

/-- `load_6(s + k)` as the word at `s + k` and the bytes at `s + k + 4` and `s + k + 5`. -/
theorem sc_reduce.load6_eq (X : BitVec 512) (k : Nat) :
    sc_reduce.load6 X k =
      (X.extractLsb' ((k + 5) * 8) 8 ++ X.extractLsb' ((k + 4) * 8) 8 ++
          X.extractLsb' (k * 8) 32).setWidth 64 := by
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  simp only [sc_reduce.load6, BitVec.getLsbD_setWidth, BitVec.getLsbD_extractLsb',
    BitVec.getLsbD_append]
  grind

/-- The compiled `t[k]` for a shift `n = 2, 4`: the word and bytes or'd at 128 bits. -/
theorem sc_reduce.limbShr_eq (W : BitVec 32) (B C : BitVec 8) (n : Nat) (hn : n = 2 ∨ n = 4) :
    (BitVec.setWidth 128 (BitVec.setWidth 64 B <<< 32) ||| BitVec.setWidth 128 W |||
          BitVec.setWidth 128 (BitVec.setWidth 64 C <<< 40)) >>> n &&& 4398046511103#128 =
      (4398046511103#64 &&& (C ++ B ++ W).setWidth 64 >>> n).setWidth 128 := by
  rcases hn with rfl | rfl <;> bv_decide

/-- `t[k] = MASK_42 & (load_6(s + k) >> n)` for `n = 2, 4`, as fifteen instructions: the word at
`q` (`s + k`), the bytes at `p + k4` and `p + k5` (`k + 4`, `k + 5`) moved up by `c32 c40`, or'd,
shifted down by `cn`, masked by `cm` and widened into `t`. -/
def limbShrRun (p q : Reg Γ .ptr) (k4 k5 : Nat) (c32 c40 cn cm : Dst Γ (.bv 64))
    (w : Dst Γ (.bv 32)) (w' : Dst Γ (.bv 64)) (g4 : Dst Γ .ptr) (b : Dst Γ (.bv 8))
    (b' s4 o4 : Dst Γ (.bv 64)) (g5 : Dst Γ .ptr) (c : Dst Γ (.bv 8))
    (c' s5 o5 sh m : Dst Γ (.bv 64)) (t : Dst Γ (.bv 128)) : List (Instr Γ) :=
  [.load w q, .unop (.zext false) w' (.val w.i w.h),
    .unop (.gepConst { nusw := true, nuw := true } (Int.ofNat k4)) g4 p, .load b (.val g4.i g4.h),
    .unop (.zext false) b' (.val b.i b.h),
    .binop (.shl { nsw := true, nuw := true }) s4 (.val b'.i b'.h) (.val c32.i c32.h),
    .binop (.or true) o4 (.val s4.i s4.h) (.val w'.i w'.h),
    .unop (.gepConst { nusw := true, nuw := true } (Int.ofNat k5)) g5 p, .load c (.val g5.i g5.h),
    .unop (.zext false) c' (.val c.i c.h),
    .binop (.shl { nsw := true, nuw := true }) s5 (.val c'.i c'.h) (.val c40.i c40.h),
    .binop (.or true) o5 (.val o4.i o4.h) (.val s5.i s5.h),
    .binop (.lshr false) sh (.val o5.i o5.h) (.val cn.i cn.h),
    .binop .and m (.val sh.i sh.h) (.val cm.i cm.h), .unop (.zext true) t (.val m.i m.h)]

/-- Where the body at `pos` is `limbShrRun`, `q` holds `P + k` and `X` the 64 bytes at `P`:
running on from `pos` gives `K` if it does from `pos + 15` with `t[k]` in `t` and `P + k4`,
`P + k5` in `g4 g5`, whatever the intermediates hold. -/
theorem runBodyFrom_limbShrRun {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {p q : Reg Γ .ptr} {k k4 k5 n : Nat} {c32 c40 cn cm : Dst Γ (.bv 64)} {w : Dst Γ (.bv 32)}
    {w' : Dst Γ (.bv 64)} {g4 : Dst Γ .ptr} {b : Dst Γ (.bv 8)} {b' s4 o4 : Dst Γ (.bv 64)}
    {g5 : Dst Γ .ptr} {c : Dst Γ (.bv 8)} {c' s5 o5 sh m : Dst Γ (.bv 64)} {t : Dst Γ (.bv 128)}
    {rest : List (Instr Γ)} {P Q : Pointer} {X : BitVec 512} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody :
      blk.body.drop pos =
        limbShrRun p q k4 k5 c32 c40 cn cm w w' g4 b b' s4 o4 g5 c c' s5 o5 sh m t ++ rest)
    (hd :
      [c32.i, c40.i, cn.i, cm.i, w.i, w'.i, g4.i, b.i, b'.i, s4.i, o4.i, g5.i, c.i, c'.i, s5.i,
        o5.i, sh.i, m.i, t.i].Nodup)
    (hpg : p ≠ .val g4.i g4.h) (hp : E.read p = .value P)
    (hq : E.read q = .value Q) (hQ : Q = P.add (BitVec.ofNat 64 k))
    (hR : E ⊨ [c32 := 32#64, c40 := 40#64, cn := BitVec.ofNat 64 n, cm := 4398046511103#64])
    (hfit : Fits S.mem P 512) (hov : ¬P.offset.uaddOverflow 64#64) (hx : S.mem.readAt P 512 = X)
    (hk : k4 = k + 4 ∧ k5 = k + 5 ∧ k + 6 ≤ 64 ∧ (n = 2 ∨ n = 4))
    (hK :
      ∀ (vw : ⟦.bv 32⟧) (vw' : ⟦.bv 64⟧) (vb : ⟦.bv 8⟧) (vb' vs4 vo4 : ⟦.bv 64⟧) (vc : ⟦.bv 8⟧)
        (vc' vs5 vo5 vsh vm : ⟦.bv 64⟧),
        (blk.runBodyFrom
              E[w := vw, w' := vw', g4 := .value (P.add (BitVec.ofNat 64 k4)), b := vb,
                b' := vb', s4 := vs4, o4 := vo4,
                g5 := .value (P.add (BitVec.ofNat 64 k5)), c := vc, c' := vc', s5 := vs5,
                o5 := vo5, sh := vsh, m := vm,
                t := .value (sc_reduce.limb X k n)]
              (pos + 15) S >>=
            g) =
          K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  subst hQ
  obtain ⟨hk4, hk5, hk, hn⟩ := hk
  have h0 : k % 18446744073709551616 = k := Nat.mod_eq_of_lt (by omega)
  have h4 : (k + 4) % 18446744073709551616 = k + 4 := Nat.mod_eq_of_lt (by omega)
  have h5 : (k + 5) % 18446744073709551616 = k + 5 := Nat.mod_eq_of_lt (by omega)
  have hlimb := sc_reduce.limbShr_eq (n := n) (hn := hn)
  rcases hn with rfl | rfl
  all_goals
    step_load [h0] with W
    step_pure
    step_pure
    step_load [h4] with B
    iterate 4 step_pure
    step_load [h5] with C
    iterate 5 step_pure
    step_pure with T
    rw [hlimb, hW, hB, hC, ← sc_reduce.load6_eq X k, ← sc_reduce.limb] at hT
    rw [hE, hT, hS, ← hk4, ← hk5]
    exact hK _ _ _ _ _ _ _ _ _ _ _ _

/-- The compiled `t[k]` for `k = 0, 21, 42`: the high byte masked to its two low bits. -/
theorem sc_reduce.limbMask_eq (W : BitVec 32) (B C : BitVec 8) :
    BitVec.setWidth 128 (BitVec.setWidth 64 B <<< 32) ||| BitVec.setWidth 128 W |||
        BitVec.setWidth 128 (BitVec.setWidth 64 C <<< 40) &&& 3298534883328#128 =
      (4398046511103#64 &&& (C ++ B ++ W).setWidth 64 >>> 0).setWidth 128 := by
  bv_decide

/-- `t[k] = MASK_42 & load_6(s + k)`, as fourteen instructions: `limbShrRun` with the high byte
masked by `cm` (`3 << 40`) before the or, and no shift. -/
def limbMaskRun (p q : Reg Γ .ptr) (k4 k5 : Nat) (c32 c40 cm : Dst Γ (.bv 64))
    (w : Dst Γ (.bv 32)) (w' : Dst Γ (.bv 64)) (g4 : Dst Γ .ptr) (b : Dst Γ (.bv 8))
    (b' s4 o4 : Dst Γ (.bv 64)) (g5 : Dst Γ .ptr) (c : Dst Γ (.bv 8)) (c' s5 m o5 : Dst Γ (.bv 64))
    (t : Dst Γ (.bv 128)) : List (Instr Γ) :=
  [.load w q, .unop (.zext false) w' (.val w.i w.h),
    .unop (.gepConst { nusw := true, nuw := true } (Int.ofNat k4)) g4 p, .load b (.val g4.i g4.h),
    .unop (.zext false) b' (.val b.i b.h),
    .binop (.shl { nsw := true, nuw := true }) s4 (.val b'.i b'.h) (.val c32.i c32.h),
    .binop (.or true) o4 (.val s4.i s4.h) (.val w'.i w'.h),
    .unop (.gepConst { nusw := true, nuw := true } (Int.ofNat k5)) g5 p, .load c (.val g5.i g5.h),
    .unop (.zext false) c' (.val c.i c.h),
    .binop (.shl { nsw := true, nuw := true }) s5 (.val c'.i c'.h) (.val c40.i c40.h),
    .binop .and m (.val s5.i s5.h) (.val cm.i cm.h),
    .binop (.or true) o5 (.val o4.i o4.h) (.val m.i m.h), .unop (.zext true) t (.val o5.i o5.h)]

/-- `runBodyFrom_limbShrRun` for `limbMaskRun`. -/
theorem runBodyFrom_limbMaskRun {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {p q : Reg Γ .ptr} {k k4 k5 : Nat} {c32 c40 cm : Dst Γ (.bv 64)} {w : Dst Γ (.bv 32)}
    {w' : Dst Γ (.bv 64)} {g4 : Dst Γ .ptr} {b : Dst Γ (.bv 8)} {b' s4 o4 : Dst Γ (.bv 64)}
    {g5 : Dst Γ .ptr} {c : Dst Γ (.bv 8)} {c' s5 m o5 : Dst Γ (.bv 64)} {t : Dst Γ (.bv 128)}
    {rest : List (Instr Γ)} {P Q : Pointer} {X : BitVec 512} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody :
      blk.body.drop pos =
        limbMaskRun p q k4 k5 c32 c40 cm w w' g4 b b' s4 o4 g5 c c' s5 m o5 t ++ rest)
    (hd :
      [c32.i, c40.i, cm.i, w.i, w'.i, g4.i, b.i, b'.i, s4.i, o4.i, g5.i, c.i, c'.i, s5.i, m.i,
        o5.i, t.i].Nodup)
    (hpg : p ≠ .val g4.i g4.h) (hp : E.read p = .value P)
    (hq : E.read q = .value Q) (hQ : Q = P.add (BitVec.ofNat 64 k))
    (hR : E ⊨ [c32 := 32#64, c40 := 40#64, cm := 3298534883328#64])
    (hfit : Fits S.mem P 512) (hov : ¬P.offset.uaddOverflow 64#64) (hx : S.mem.readAt P 512 = X)
    (hk : k4 = k + 4 ∧ k5 = k + 5 ∧ k + 6 ≤ 64)
    (hK :
      ∀ (vw : ⟦.bv 32⟧) (vw' : ⟦.bv 64⟧) (vb : ⟦.bv 8⟧) (vb' vs4 vo4 : ⟦.bv 64⟧) (vc : ⟦.bv 8⟧)
        (vc' vs5 vm vo5 : ⟦.bv 64⟧),
        (blk.runBodyFrom
              E[w := vw, w' := vw', g4 := .value (P.add (BitVec.ofNat 64 k4)), b := vb,
                b' := vb', s4 := vs4, o4 := vo4, g5 := .value (P.add (BitVec.ofNat 64 k5)),
                c := vc, c' := vc', s5 := vs5, m := vm, o5 := vo5,
                t := .value (sc_reduce.limb X k 0)]
              (pos + 14) S >>=
            g) =
          K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  subst hQ
  obtain ⟨hk4, hk5, hk⟩ := hk
  have h0 : k % 18446744073709551616 = k := Nat.mod_eq_of_lt (by omega)
  have h4 : (k + 4) % 18446744073709551616 = k + 4 := Nat.mod_eq_of_lt (by omega)
  have h5 : (k + 5) % 18446744073709551616 = k + 5 := Nat.mod_eq_of_lt (by omega)
  step_load [h0] with W
  step_pure
  step_pure
  step_load [h4] with B
  iterate 4 step_pure
  step_load [h5] with C
  iterate 4 step_pure
  step_pure with T
  rw [sc_reduce.limbMask_eq, hW, hB, hC, ← sc_reduce.load6_eq X k, ← sc_reduce.limb] at hT
  rw [hE, hT, hS, ← hk4, ← hk5]
  exact hK _ _ _ _ _ _ _ _ _ _ _

/-- The compiled `t[k]` for `k = 15, 36`: the shift by `6` leaves 42 bits, so no mask. -/
theorem sc_reduce.limbShr6_eq (W : BitVec 32) (B C : BitVec 8) :
    (BitVec.setWidth 128 (BitVec.setWidth 64 B <<< 32) ||| BitVec.setWidth 128 W |||
          BitVec.setWidth 128 (BitVec.setWidth 64 C <<< 40)) >>> 6 =
      (4398046511103#64 &&& (C ++ B ++ W).setWidth 64 >>> 6).setWidth 128 := by
  bv_decide

/-- `t[k] = MASK_42 & (load_6(s + k) >> 6)`, as fourteen instructions: `limbShrRun` without the
mask. -/
def limbShr6Run (p q : Reg Γ .ptr) (k4 k5 : Nat) (c32 c40 c6 : Dst Γ (.bv 64))
    (w : Dst Γ (.bv 32)) (w' : Dst Γ (.bv 64)) (g4 : Dst Γ .ptr) (b : Dst Γ (.bv 8))
    (b' s4 o4 : Dst Γ (.bv 64)) (g5 : Dst Γ .ptr) (c : Dst Γ (.bv 8)) (c' s5 o5 sh : Dst Γ (.bv 64))
    (t : Dst Γ (.bv 128)) : List (Instr Γ) :=
  [.load w q, .unop (.zext false) w' (.val w.i w.h),
    .unop (.gepConst { nusw := true, nuw := true } (Int.ofNat k4)) g4 p, .load b (.val g4.i g4.h),
    .unop (.zext false) b' (.val b.i b.h),
    .binop (.shl { nsw := true, nuw := true }) s4 (.val b'.i b'.h) (.val c32.i c32.h),
    .binop (.or true) o4 (.val s4.i s4.h) (.val w'.i w'.h),
    .unop (.gepConst { nusw := true, nuw := true } (Int.ofNat k5)) g5 p, .load c (.val g5.i g5.h),
    .unop (.zext false) c' (.val c.i c.h),
    .binop (.shl { nsw := true, nuw := true }) s5 (.val c'.i c'.h) (.val c40.i c40.h),
    .binop (.or true) o5 (.val o4.i o4.h) (.val s5.i s5.h),
    .binop (.lshr false) sh (.val o5.i o5.h) (.val c6.i c6.h),
    .unop (.zext true) t (.val sh.i sh.h)]

/-- `runBodyFrom_limbShrRun` for `limbShr6Run`. -/
theorem runBodyFrom_limbShr6Run {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {p q : Reg Γ .ptr} {k k4 k5 : Nat} {c32 c40 c6 : Dst Γ (.bv 64)} {w : Dst Γ (.bv 32)}
    {w' : Dst Γ (.bv 64)} {g4 : Dst Γ .ptr} {b : Dst Γ (.bv 8)} {b' s4 o4 : Dst Γ (.bv 64)}
    {g5 : Dst Γ .ptr} {c : Dst Γ (.bv 8)} {c' s5 o5 sh : Dst Γ (.bv 64)} {t : Dst Γ (.bv 128)}
    {rest : List (Instr Γ)} {P Q : Pointer} {X : BitVec 512} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody :
      blk.body.drop pos =
        limbShr6Run p q k4 k5 c32 c40 c6 w w' g4 b b' s4 o4 g5 c c' s5 o5 sh t ++ rest)
    (hd :
      [c32.i, c40.i, c6.i, w.i, w'.i, g4.i, b.i, b'.i, s4.i, o4.i, g5.i, c.i, c'.i, s5.i, o5.i,
        sh.i, t.i].Nodup)
    (hpg : p ≠ .val g4.i g4.h) (hp : E.read p = .value P)
    (hq : E.read q = .value Q) (hQ : Q = P.add (BitVec.ofNat 64 k))
    (hR : E ⊨ [c32 := 32#64, c40 := 40#64, c6 := 6#64])
    (hfit : Fits S.mem P 512) (hov : ¬P.offset.uaddOverflow 64#64) (hx : S.mem.readAt P 512 = X)
    (hk : k4 = k + 4 ∧ k5 = k + 5 ∧ k + 6 ≤ 64)
    (hK :
      ∀ (vw : ⟦.bv 32⟧) (vw' : ⟦.bv 64⟧) (vb : ⟦.bv 8⟧) (vb' vs4 vo4 : ⟦.bv 64⟧) (vc : ⟦.bv 8⟧)
        (vc' vs5 vo5 vsh : ⟦.bv 64⟧),
        (blk.runBodyFrom
              E[w := vw, w' := vw', g4 := .value (P.add (BitVec.ofNat 64 k4)), b := vb,
                b' := vb', s4 := vs4, o4 := vo4, g5 := .value (P.add (BitVec.ofNat 64 k5)),
                c := vc, c' := vc', s5 := vs5, o5 := vo5, sh := vsh,
                t := .value (sc_reduce.limb X k 6)]
              (pos + 14) S >>=
            g) =
          K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  subst hQ
  obtain ⟨hk4, hk5, hk⟩ := hk
  have h0 : k % 18446744073709551616 = k := Nat.mod_eq_of_lt (by omega)
  have h4 : (k + 4) % 18446744073709551616 = k + 4 := Nat.mod_eq_of_lt (by omega)
  have h5 : (k + 5) % 18446744073709551616 = k + 5 := Nat.mod_eq_of_lt (by omega)
  step_load [h0] with W
  step_pure
  step_pure
  step_load [h4] with B
  iterate 4 step_pure
  step_load [h5] with C
  iterate 4 step_pure
  step_pure with T
  rw [sc_reduce.limbShr6_eq, hW, hB, hC, ← sc_reduce.load6_eq X k, ← sc_reduce.limb] at hT
  rw [hE, hT, hS, ← hk4, ← hk5]
  exact hK _ _ _ _ _ _ _ _ _ _ _

/-! ### The compiled code in the C's terms

The compiler folds each `t[j] -= t[i] * ORDER_k` into `t[i] * -ORDER_k + t[j]` and reorders the
sums; these identities put each named value back in the C's form. -/

theorem sc_reduce.mul_n0 (a b : BitVec 128) :
    a * 340282366920938463463374604020004563987#128 + b = b - a * 3411763647469#128 := by
  grind

theorem sc_reduce.mul_n1 (a b : BitVec 128) :
    a * 340282366920938463463374605339220114280#128 + b = b - a * 2092548097176#128 := by
  grind

theorem sc_reduce.mul_n2 (a b : BitVec 128) :
    a * 340282366920938463463374605997523998161#128 + b = b - a * 1434244213295#128 := by
  grind

theorem sc_reduce.add_mul_n2 (a b : BitVec 128) :
    b + a * 340282366920938463463374605997523998161#128 = b - a * 1434244213295#128 := by
  grind

/-- `t[5]` after the three rows above it. -/
theorem sc_reduce.row5 (a b c d : BitVec 128) :
    a * 340282366920938463463374605997523998161#128 + b +
          c * 340282366920938463463374605339220114280#128 +
        d * 340282366920938463463374604020004563987#128 =
      b - d * 3411763647469#128 - c * 2092548097176#128 - a * 1434244213295#128 := by
  grind

/-- `t[4]` after two rows and `t[3]`'s carry. -/
theorem sc_reduce.row4 (a b c d : BitVec 128) :
    a * 340282366920938463463374605339220114280#128 + b + c +
        d * 340282366920938463463374604020004563987#128 =
      b - d * 3411763647469#128 - a * 2092548097176#128 + c := by
  grind

/-- `t[6]` after two rows and `t[5]`'s carry. -/
theorem sc_reduce.row6 (a b c d : BitVec 128) :
    a * 340282366920938463463374605997523998161#128 + b +
        d * 340282366920938463463374605339220114280#128 + c =
      b - d * 2092548097176#128 - a * 1434244213295#128 + c := by
  grind

/-- `t[1]` after two rows and `t[0]`'s carry. -/
theorem sc_reduce.row1 (a b c d : BitVec 128) :
    a * 340282366920938463463374605339220114280#128 + b +
        d * 340282366920938463463374604020004563987#128 + c =
      b - d * 3411763647469#128 - a * 2092548097176#128 + c := by
  grind

/-- `t[2]` after two rows and `t[1]`'s carry. -/
theorem sc_reduce.row2 (a b c d : BitVec 128) :
    b + a * 340282366920938463463374605997523998161#128 +
        d * 340282366920938463463374605339220114280#128 + c =
      b - d * 2092548097176#128 - a * 1434244213295#128 + c := by
  grind

/-- The compiled stores of the last limbs, unmasked: the C's bytes of the masked limbs. -/
theorem sc_reduce.out_eq (a0 a1 a2 a3 a4 a5 : BitVec 128) :
    BitVec.setWidth 8 (a5 >>> 38) ++
        (BitVec.setWidth 8 (a5 >>> 30) ++
            (BitVec.setWidth 8 (a5 >>> 22) ++
              (BitVec.setWidth 8 (a5 >>> 14) ++ BitVec.setWidth 8 (a5 >>> 6))) ++
          ((BitVec.setWidth 8 a5 <<< 2 ||| BitVec.setWidth 8 (a4 >>> 40) &&& 3#8) ++
            (BitVec.setWidth 8 (a4 >>> 32) ++
              (BitVec.setWidth 8 (a4 >>> 24) ++
                (BitVec.setWidth 8 (a4 >>> 16) ++
                    (BitVec.setWidth 8 (a4 >>> 8) ++
                      (BitVec.setWidth 8 a4 ++
                        (BitVec.setWidth 8 (a3 >>> 34) ++
                          (BitVec.setWidth 8 (a3 >>> 26) ++
                            (BitVec.setWidth 8 (a3 >>> 18) ++
                              (BitVec.setWidth 8 (a3 >>> 10) ++
                                BitVec.setWidth 8 (a3 >>> 2))))))) ++
                  ((BitVec.setWidth 8 a3 <<< 6 ||| BitVec.setWidth 8 (a2 >>> 36) &&& 63#8) ++
                    (BitVec.setWidth 32 (a2 >>> 4) ++
                      ((BitVec.setWidth 8 a2 <<< 4 ||| BitVec.setWidth 8 (a1 >>> 38) &&& 15#8) ++
                        (BitVec.setWidth 32 (a1 >>> 6) ++
                          ((BitVec.setWidth 8 a1 <<< 2 ||| BitVec.setWidth 8 (a0 >>> 40) &&& 3#8) ++
                            (BitVec.setWidth 8 (a0 >>> 32) ++
                              (BitVec.setWidth 8 (a0 >>> 24) ++
                                (BitVec.setWidth 8 (a0 >>> 16) ++
                                  (BitVec.setWidth 8 (a0 >>> 8) ++
                                    BitVec.setWidth 8 a0)))))))))))))) =
      sc_reduce.bytes (a0 &&& 4398046511103#128) (a1 &&& 4398046511103#128)
        (a2 &&& 4398046511103#128) (a3 &&& 4398046511103#128) (a4 &&& 4398046511103#128) a5 := by
  unfold sc_reduce.bytes
  bv_decide

-- One block of 360 instructions, stepped in one declaration: past the default budget in total.
set_option maxHeartbeats 1000000 in
/-- `sc_reduce` stores `spec` of the 64 bytes at `p` as the 32 bytes at `p`. -/
public theorem sc_reduce.call_eq (p : Pointer) (s : GlobalState) (hwf : s.WF)
    (hp : Fits s.mem p (8 * 64)) (hpw : Writable s.mem p) (hp_off : ¬p.offset.uaddOverflow 64#64) :
    sc_reduce.call (sc_reduce.args (.value p)) s =
      .value (.nil, { s with mem := s.mem.storeAt p (sc_reduce.spec (s.mem.readAt p 512)) }) := by
  generalize hx : s.mem.readAt p 512 = x
  generalize hres : sc_reduce.spec x = res
  func_init
  block_init
  -- the constants
  iterate 35 step_pure
  -- t[ 0] = MASK_42 & (load_6(s +  0) >> 0);
  step_pattern using (runBodyFrom_limbMaskRun (k := 0) (hQ := (Pointer.add_zero p).symm)) with t0
  -- t[ 1] = MASK_42 & (load_6(s +  5) >> 2);
  step_pattern using (runBodyFrom_limbShrRun (k := 5) (n := 2) (hQ := rfl)) with t1
  -- t[ 2] = MASK_42 & (load_6(s + 10) >> 4);
  step_pattern using (runBodyFrom_limbShrRun (k := 10) (n := 4) (hQ := rfl)) with t2
  -- t[ 3] = MASK_42 & (load_6(s + 15) >> 6);
  step_pattern using (runBodyFrom_limbShr6Run (k := 15) (hQ := rfl)) with t3
  -- t[ 4] = MASK_42 & (load_6(s + 21) >> 0);
  step_pure
  step_pattern using (runBodyFrom_limbMaskRun (k := 21) (hQ := rfl)) with t4
  -- t[ 5] = MASK_42 & (load_6(s + 26) >> 2);
  step_pattern using (runBodyFrom_limbShrRun (k := 26) (n := 2) (hQ := rfl)) with t5
  -- t[ 6] = MASK_42 & (load_6(s + 31) >> 4);
  step_pattern using (runBodyFrom_limbShrRun (k := 31) (n := 4) (hQ := rfl)) with t6
  -- t[ 7] = MASK_42 & (load_6(s + 36) >> 6);
  step_pattern using (runBodyFrom_limbShr6Run (k := 36) (hQ := rfl)) with t7
  -- t[ 8] = MASK_42 & (load_6(s + 42) >> 0);
  step_pure
  step_pattern using (runBodyFrom_limbMaskRun (k := 42) (hQ := rfl)) with t8
  -- t[ 9] = MASK_42 & (load_6(s + 47) >> 2);
  step_pattern using (runBodyFrom_limbShrRun (k := 47) (n := 2) (hQ := rfl)) with t9
  -- t[10] = MASK_42 & (load_6(s + 52) >> 4);
  step_pattern using (runBodyFrom_limbShrRun (k := 52) (n := 4) (hQ := rfl)) with t10
  -- t[11] =           (load_7(s + 57) >> 6);
  step_load with w57
  step_pure
  step_pure
  step_load with b61
  iterate 4 step_pure
  step_load with b62
  iterate 4 step_pure
  step_load with b63
  iterate 4 step_pure
  step_pure with t11
  rw [hw57, hb61, hb62, hb63, sc_reduce.limb11_eq] at ht11
  bnd t11
  -- the limbs' bounds, for the `nsw` flags below
  have hbt0 := ht0 ▸ sc_reduce.limb_bnd x 0 0
  have hbt1 := ht1 ▸ sc_reduce.limb_bnd x 5 2
  have hbt2 := ht2 ▸ sc_reduce.limb_bnd x 10 4
  have hbt3 := ht3 ▸ sc_reduce.limb_bnd x 15 6
  have hbt4 := ht4 ▸ sc_reduce.limb_bnd x 21 0
  have hbt5 := ht5 ▸ sc_reduce.limb_bnd x 26 2
  have hbt6 := ht6 ▸ sc_reduce.limb_bnd x 31 4
  have hbt7 := ht7 ▸ sc_reduce.limb_bnd x 36 6
  have hbt8 := ht8 ▸ sc_reduce.limb_bnd x 42 0
  have hbt9 := ht9 ▸ sc_reduce.limb_bnd x 47 2
  have hbt10 := ht10 ▸ sc_reduce.limb_bnd x 52 4
  -- t[ 5] -= t[11] * ORDER_0;  t[ 6] -= t[11] * ORDER_1;  t[ 7] -= t[11] * ORDER_2;
  -- t[ 4] -= t[10] * ORDER_0;  t[ 5] -= t[10] * ORDER_1;  t[ 6] -= t[10] * ORDER_2;
  -- t[ 3] -= t[ 9] * ORDER_0;  t[ 4] -= t[ 9] * ORDER_1;  t[ 5] -= t[ 9] * ORDER_2;
  -- and the carries out of t[3], t[5], t[7], t[4], t[6]
  step_pure [nswMul128]
  step_pure [nswMul128]
  step_pure [nswMul128]
  step_pure [nswAdd128] with t7_1
  bnd t7_1
  step_pure [nswMul128]
  step_pure [nswMul128]
  step_pure [nswMul128]
  step_pure [nswMul128]
  step_pure [nswAdd128] with t3_1
  bnd t3_1
  step_pure [nswMul128]
  step_pure [nswMul128]
  step_pure [nswAdd128]
  step_pure [nswAdd128]
  step_pure [nswAdd128] with t5_3
  bnd t5_3
  step_pure with c3
  bnd c3
  step_pure [nswAdd128]
  step_pure [nswAdd128]
  step_pure [nswAdd128] with t4_3
  bnd t4_3
  step_pure with t3_2
  bnd t3_2
  step_pure with c5
  bnd c5
  step_pure [nswAdd128]
  step_pure [nswAdd128]
  step_pure [nswAdd128] with t6_3
  bnd t6_3
  step_pure with t5_4
  bnd t5_4
  step_pure with c7
  bnd c7
  step_pure [nswAdd128] with t8_1
  bnd t8_1
  step_pure with t7_2
  bnd t7_2
  step_pure with c4
  bnd c4
  step_pure [nswAdd128] with t5_5
  bnd t5_5
  step_pure with t4_4
  bnd t4_4
  step_pure with c6
  bnd c6
  step_pure [nswAdd128] with t7_3
  bnd t7_3
  step_pure with t6_4
  bnd t6_4
  -- t[ 2] -= t[ 8] * ORDER_0;  t[ 3] -= t[ 8] * ORDER_1;  t[ 4] -= t[ 8] * ORDER_2;
  -- t[ 1] -= t[ 7] * ORDER_0;  t[ 2] -= t[ 7] * ORDER_1;  t[ 3] -= t[ 7] * ORDER_2;
  -- t[ 0] -= t[ 6] * ORDER_0;  t[ 1] -= t[ 6] * ORDER_1;  t[ 2] -= t[ 6] * ORDER_2;
  -- and the carries out of t[0] … t[5] into t[6]
  step_pure [nswMul128]
  step_pure [nswAdd128] with t2_1
  bnd t2_1
  step_pure [nswMul128]
  step_pure [nswAdd128] with t3_3
  bnd t3_3
  step_pure [nswMul128]
  step_pure [nswAdd128] with t4_5
  bnd t4_5
  step_pure [nswMul128]
  step_pure [nswMul128]
  step_pure [nswMul128]
  step_pure [nswAdd128] with t3_4
  bnd t3_4
  step_pure [nswMul128]
  step_pure [nswAdd128] with t0_1
  bnd t0_1
  step_pure [nswMul128]
  step_pure [nswMul128]
  step_pure with c0
  bnd c0
  step_pure [nswAdd128]
  step_pure [nswAdd128]
  step_pure [nswAdd128] with t1_3
  bnd t1_3
  step_pure with t0_2
  bnd t0_2
  step_pure with c1
  bnd c1
  step_pure [nswAdd128]
  step_pure [nswAdd128]
  step_pure [nswAdd128] with t2_4
  bnd t2_4
  step_pure with t1_4
  bnd t1_4
  step_pure with c2
  bnd c2
  step_pure [nswAdd128] with t3_5
  bnd t3_5
  step_pure with t2_5
  bnd t2_5
  step_pure with c3_1
  bnd c3_1
  step_pure [nswAdd128] with t4_6
  bnd t4_6
  step_pure with t3_6
  bnd t3_6
  step_pure with c4_1
  bnd c4_1
  step_pure [nswAdd128] with t5_6
  bnd t5_6
  step_pure with t4_7
  bnd t4_7
  step_pure with t6_6
  bnd t6_6
  step_pure with t5_7
  bnd t5_7
  -- t[ 0] -= t[ 6] * ORDER_0;  t[ 1] -= t[ 6] * ORDER_1;  t[ 2] -= t[ 6] * ORDER_2;
  -- and the carries out of t[0], t[1], t[2], interleaved with the stores below
  step_pure [nswMul128]
  step_pure [nswMul128]
  step_pure [nswAdd128] with t1_5
  bnd t1_5
  step_pure [nswMul128]
  step_pure [nswAdd128] with t2_6
  bnd t2_6
  step_pure [nswAdd128] with t0_3
  bnd t0_3
  step_pure with c0_1
  bnd c0_1
  step_pure [nswAdd128] with t1_6
  bnd t1_6
  step_pure with c1_1
  bnd c1_1
  step_pure [nswAdd128] with t2_7
  bnd t2_7
  step_pure with c2_1
  bnd c2_1
  -- s[ 0] … s[ 3], s[ 4] = (byte)(t[ 0] >> 32);
  iterate 9 step_pure
  step_store
  iterate 2 step_pure
  step_store
  -- s[ 5] = (byte)(t[ 0] >> 40) | (byte)((byte)t[ 1] <<  2);
  iterate 6 step_pure
  step_store
  -- s[ 6] … s[ 9]: (byte)(t[ 1] >>  6) … (byte)(t[ 1] >> 30);
  iterate 3 step_pure
  step_store
  -- s[10] = (byte)(t[ 1] >> 38) | (byte)((byte)t[ 2] <<  4);
  iterate 6 step_pure
  step_store
  -- s[11] … s[14]: (byte)(t[ 2] >>  4) … (byte)(t[ 2] >> 28);
  iterate 3 step_pure
  step_store
  -- carry = t[ 2] >> 42; t[ 3] += carry; carry = t[ 3] >> 42; t[ 4] += carry;
  -- carry = t[ 4] >> 42; t[ 5] += carry;
  -- s[15] = (byte)(t[ 2] >> 36) | (byte)((byte)t[ 3] <<  6);
  iterate 4 step_pure
  step_pure [nswAdd128] with t3_7
  bnd t3_7
  step_pure
  step_pure [nswAdd128] with t4_8
  bnd t4_8
  step_pure
  step_pure [nswAdd128] with t5_8
  bnd t5_8
  iterate 3 step_pure
  step_store
  -- s[16] … s[23]: (byte)(t[ 3] >>  2) … (byte)(t[ 4] >> 16);
  iterate 3 step_pure
  step_pure [expandOfFn]
  step_pure [expandOfFn]
  step_store
  -- s[24] = (byte)(t[ 4] >> 24);  s[25] = (byte)(t[ 4] >> 32);
  iterate 3 step_pure
  step_store
  iterate 2 step_pure
  step_store
  -- s[26] = (byte)(t[ 4] >> 40) | (byte)((byte)t[ 5] <<  2);
  iterate 6 step_pure
  step_store
  -- s[27] … s[30]: (byte)(t[ 5] >>  6) … (byte)(t[ 5] >> 30);  s[31] = (byte)(t[ 5] >> 38);
  iterate 3 step_pure
  step_pure [expandOfFn]
  step_pure [expandOfFn]
  step_store
  iterate 2 step_pure
  step_store consuming hfits_p_31
  finish_block
  subst hS
  rw [MemoryState.storeAt_storeAt_append (a := 32) (k := 4)
      (BitVec.not_uaddOverflow_of_le hp_off (by decide)) rfl (by decide),
    MemoryState.storeAt_storeAt_append (a := 40) (k := 5)
      (BitVec.not_uaddOverflow_of_le hp_off (by decide)) rfl (by decide),
    MemoryState.storeAt_storeAt_append (a := 48) (k := 6)
      (BitVec.not_uaddOverflow_of_le hp_off (by decide)) rfl (by decide),
    MemoryState.storeAt_storeAt_append (a := 80) (k := 10)
      (BitVec.not_uaddOverflow_of_le hp_off (by decide)) rfl (by decide),
    MemoryState.storeAt_storeAt_append (a := 88) (k := 11)
      (BitVec.not_uaddOverflow_of_le hp_off (by decide)) rfl (by decide),
    MemoryState.storeAt_storeAt_append (a := 120) (k := 15)
      (BitVec.not_uaddOverflow_of_le hp_off (by decide)) rfl (by decide),
    MemoryState.storeAt_storeAt_append (a := 128) (k := 16)
      (BitVec.not_uaddOverflow_of_le hp_off (by decide)) rfl (by decide),
    MemoryState.storeAt_storeAt_append (a := 192) (k := 24)
      (BitVec.not_uaddOverflow_of_le hp_off (by decide)) rfl (by decide),
    MemoryState.storeAt_storeAt_append (a := 200) (k := 25)
      (BitVec.not_uaddOverflow_of_le hp_off (by decide)) rfl (by decide),
    MemoryState.storeAt_storeAt_append (a := 208) (k := 26)
      (BitVec.not_uaddOverflow_of_le hp_off (by decide)) rfl (by decide),
    MemoryState.storeAt_storeAt_append (a := 216) (k := 27)
      (BitVec.not_uaddOverflow_of_le hp_off (by decide)) rfl (by decide),
    MemoryState.storeAt_storeAt_append (a := 248) (k := 31)
      (BitVec.not_uaddOverflow_of_le hp_off (by decide)) rfl (by decide)]
  simp only [sc_reduce.packLanes4, sc_reduce.packLanes8, Vector.getElem_ofFn]
  simp only [Vector.getElem_mk, List.getElem_toArray, List.getElem_cons_succ,
    List.getElem_cons_zero]
  subst hres
  refine
    congrArg
      (fun v =>
        PoisonOr.value (Vals.nil, ({ alloc := S₀.alloc, mem := S₀.mem.storeAt p v } : GlobalState)))
      ((sc_reduce.out_eq _ _ _ _ _ _).trans ?_)
  rw [sc_reduce.mul_n2] at ht7_1
  rw [sc_reduce.mul_n0] at ht3_1 ht2_1 ht0_1 ht0_3
  rw [sc_reduce.mul_n1] at ht3_3 ht1_5
  rw [sc_reduce.mul_n2] at ht4_5 ht2_6
  rw [sc_reduce.add_mul_n2] at ht3_4
  rw [sc_reduce.row5] at ht5_3
  rw [sc_reduce.row4] at ht4_3
  rw [sc_reduce.row6] at ht6_3
  rw [sc_reduce.row1] at ht1_3
  rw [sc_reduce.row2] at ht2_4
  rw [BitVec.add_comm] at ht8_1 ht7_3 ht3_7 ht4_8 ht5_8
  rw [← BitVec.zero_add (t5_6.sshiftRight 42)] at ht6_6
  subst_vars
  rfl

end Proof

end MLIR.Wolfssl
