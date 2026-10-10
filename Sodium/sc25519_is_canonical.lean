module

public import Ed25519.Scalar
public import MLIR.Run.Tactic
public import Sodium.Mlir.sc25519_is_canonical
import Std.Tactic.BVDecide
meta import Std.Tactic.BVDecide.Reflect

namespace MLIR.Sodium

/-! ## Specification -/

@[expose] public section

namespace sc25519_is_canonical

/-- `L`, the 32 bytes of `ℓ`. -/
def L : BitVec 256 :=
  BitVec.ofNat 256 Ed25519.ell

/-- One iteration on `(c, n)` with the bytes `s[i]`, `L[i]`, in `int`:
`c |= ((s[i] - L[i]) >> 8) & n; n &= ((s[i] ^ L[i]) - 1) >> 8;`. -/
def stepB (cn : BitVec 32 × BitVec 32) (si li : BitVec 8) : BitVec 32 × BitVec 32 :=
  (cn.1 ||| (si.setWidth 32 - li.setWidth 32).sshiftRight 8 &&& cn.2,
    cn.2 &&& ((si.setWidth 32 ^^^ li.setWidth 32) - 1#32).sshiftRight 8)

/-- The iteration at byte `i` of `s`. -/
def step (s : BitVec 256) (cn : BitVec 32 × BitVec 32) (i : Nat) : BitVec 32 × BitVec 32 :=
  stepB cn (s.extractLsb' (8 * i) 8) (L.extractLsb' (8 * i) 8)

/-- The loop from `i` down: bytes `i - 1, …, 0`. -/
def loop (s : BitVec 256) : Nat → BitVec 32 × BitVec 32 → BitVec 32 × BitVec 32
  | 0, cn => cn
  | i + 1, cn => loop s i (step s cn i)

end sc25519_is_canonical

/-- `c != 0` after the loop over the 32 bytes `s` from the top, `c = 0`, `n = 1`. -/
def sc25519_is_canonical.spec (s : BitVec 256) : BitVec 32 :=
  (BitVec.ofBool ((sc25519_is_canonical.loop s 32 (0#32, 1#32)).1 != 0#32)).setWidth 32

end

/-! ## Proof -/

section Proof

set_option hygiene false in
/-- One iteration: bytes `i - 1` and `i - 2`, then the branch on `i - 2 == 0`. -/
local macro "iter" : tactic =>
  `(tactic|
    ( block_init
      obtain ⟨hov1, hov2⟩ := sadd_m _ (le32 (i := i) (by omega))
      obtain ⟨hsub1, hsub2⟩ := add_m (i := i) (by omega)
      -- i--; c |= ((s[i] - L[i]) >> 8) & n; n &= ((s[i] ^ L[i]) - 1) >> 8;
      step_pure [hov1, hsub1]
      step_pure [Nat.mod_lt]
      step_load with s1
      step_pure
      step_pure [Nat.mod_lt]
      step_load with l1
      iterate 9 step_pure
      -- the same at i - 2
      step_pure [hov2, hsub2]
      step_pure [Nat.mod_lt]
      step_load with s2
      step_pure
      step_pure [Nat.mod_lt]
      step_load with l2
      iterate 9 step_pure
      -- while (i != 0)
      step_pure
      finish_block))

public theorem sc25519_is_canonical_L.value_eq (s : GlobalState) :
    sc25519_is_canonical_L.value s = .value (Ty.wrap sc25519_is_canonical_L.lit, s) :=
  GlobalInitializer.compute_value _ _ ⟨_, by with_unfolding_all rfl⟩

/-- `L`'s bits: `ℓ`. -/
theorem sc25519_is_canonical_L.flatBits_lit {hw : (Ty.array 32 (.bv 8)).width = 256} :
    Ty.flatBits (hw := hw) sc25519_is_canonical_L.lit = sc25519_is_canonical.L := by
  apply BitVec.eq_of_toNat_eq
  rw [Ty.flatBits_eq, BitVec.toNat_cast, Ty.flattenRaw_array, sc25519_is_canonical_L.lit]
  decide +kernel

namespace sc25519_is_canonical

/-- The constants the loop reads. -/
abbrev Consts (Lp : Pointer) (E : ⟪Γ⟫) : Prop :=
  E ⊨ [%1523 := 0#32, %1525 := 18446744073709551615#64, %1526 := Lp, %1527 := 8#32, %1528 :=
    4294967295#32, %1529 := 18446744073709551614#64, %1530 := 0#64]

/-- `s[i] - L[i]` (`sub nsw`) does not wrap. -/
@[local simp]
theorem ssub_byte (x y : BitVec 8) : (x.setWidth 32).ssubOverflow (y.setWidth 32) = false := by
  bv_decide

/-- `(s[i] ^ L[i]) - 1` (`add nsw`) does not wrap. -/
@[local simp]
theorem sadd_xor (x y : BitVec 8) :
    (y.setWidth 32 ^^^ x.setWidth 32).saddOverflow 4294967295#32 = false := by bv_decide

/-- `i - 1` and `i - 2` (`add nsw`) do not wrap. -/
theorem sadd_m (x : BitVec 64) (h : x ≤ 32#64) :
    x.saddOverflow 18446744073709551615#64 = false ∧
      x.saddOverflow 18446744073709551614#64 = false := by
  bv_decide

/-- `i ≤ 32` as a counter bound. -/
theorem le32 (h : i ≤ 32) : BitVec.ofNat 64 i ≤ 32#64 := by
  rw [BitVec.le_def, BitVec.toNat_ofNat]
  simp only [BitVec.toNat_ofNat]
  omega

/-- `i - 1` and `i - 2` as the counter. -/
theorem add_m (h : 2 ≤ i ∧ i ≤ 32) :
    BitVec.ofNat 64 i + 18446744073709551615#64 = BitVec.ofNat 64 (i - 1) ∧
      BitVec.ofNat 64 i + 18446744073709551614#64 = BitVec.ofNat 64 (i - 2) := by
  constructor <;> apply BitVec.eq_of_toNat_eq <;>
    rw [BitVec.toNat_add, BitVec.toNat_ofNat, BitVec.toNat_ofNat, BitVec.toNat_ofNat] <;>
    omega

/-- The counter at `j > 0` is not `0`. -/
theorem ofNat_ne (h : 0 < j ∧ j ≤ 32) : BitVec.ofNat 64 j ≠ 0#64 := by
  intro e
  have := congrArg BitVec.toNat e
  rw [BitVec.toNat_ofNat, BitVec.toNat_ofNat, Nat.mod_eq_of_lt (by omega)] at this
  omega

/-- A byte index as the load's offset computes it. -/
theorem mod_mul8 (h : j < 2 ^ 64) : j % 18446744073709551616 * 8 = 8 * j := by
  rw [Nat.mod_eq_of_lt h, Nat.mul_comm]

/-- Two iterations as the code computes them: `c`. -/
theorem iter_c (s1 l1 s2 l2 : BitVec 8) (cn : BitVec 32 × BitVec 32) :
    ((s2.setWidth 32 - l2.setWidth 32).sshiftRight 8 &&&
          (((l1.setWidth 32 ^^^ s1.setWidth 32) + 4294967295#32).sshiftRight 8 &&& cn.2) |||
        ((s1.setWidth 32 - l1.setWidth 32).sshiftRight 8 &&& cn.2 ||| cn.1)) =
      (stepB (stepB cn s1 l1) s2 l2).1 := by
  simp only [stepB]
  bv_decide

/-- Two iterations as the code computes them: `n`. -/
theorem iter_n (s1 l1 s2 l2 : BitVec 8) (cn : BitVec 32 × BitVec 32) :
    (((l2.setWidth 32 ^^^ s2.setWidth 32) + 4294967295#32).sshiftRight 8 &&&
        (((l1.setWidth 32 ^^^ s1.setWidth 32) + 4294967295#32).sshiftRight 8 &&& cn.2)) =
      (stepB (stepB cn s1 l1) s2 l2).2 := by
  simp only [stepB]
  bv_decide

/-- Two iterations of the loop. -/
theorem loop_two (s : BitVec 256) (cn : BitVec 32 × BitVec 32) (h : 2 ≤ i) :
    loop s i cn = loop s (i - 2) (step s (step s cn (i - 1)) (i - 2)) := by
  obtain ⟨j, rfl⟩ : ∃ j, i = j + 2 := ⟨i - 2, by omega⟩
  rfl

/-- `^bb1` at `i = 2 (m + 1)` with `(c, n) = cn`: the loop ends with `loop s i cn`'s `c`. -/
theorem run_loop (p Lp : Pointer) (S : GlobalState) (g : Vals [.bv 32] × GlobalState → PoisonOr β)
    (K : PoisonOr β) (hp : Fits S.mem p 256) (hp_off : ¬p.offset.uaddOverflow 32#64)
    (hL : Fits S.mem Lp 256) (hLo : Lp.offset = 0) (hread : S.mem.readAt Lp 256 = L) :
    ∀ m i (cn : BitVec 32 × BitVec 32) (E : ⟪Γ⟫),
      i / 2 = m + 1 ∧ i % 2 = 0 ∧ i ≤ 32 →
        E.args = (args (.value p)).get →
        Consts Lp E →
        (∀ E' : ⟪Γ⟫,
          E'.args = (args (.value p)).get →
            (E' ⊨ [%1523 := 0#32, %1559 := (loop (S.mem.readAt p 256) i cn).1]) →
            (sc25519_is_canonical.runFrom E' 2 S >>= g) = K) →
        (sc25519_is_canonical.runFrom
              (E[%1531 := .value (BitVec.ofNat 64 i), %1532 := .value cn.1, %1533 := .value cn.2]) 1
              S >>=
            g) =
          K := by
  intro m
  induction m with
  | zero =>
    intro i cn E hi hArgs hc hK
    iter
    · step_loop using hK
      rw [mod_mul8 (j := i - 1) (by omega), mod_mul8 (j := i - 2) (by omega), iter_c,
        loop_two _ _ (by omega), show i - 2 = 0 by omega]
      rfl
    · exact (hbr (by rw [show i - 2 = 0 by omega])).elim
  | succ m ih =>
    intro i cn E hi hArgs hc hK
    iter
    · exact (ofNat_ne (j := i - 2) (by omega) hbr).elim
    · obtain ⟨cn', hcn'⟩ :
        ∃ cn', step (S.mem.readAt p 256) (step (S.mem.readAt p 256) cn (i - 1)) (i - 2) = cn' :=
        ⟨_, rfl⟩
      step_loop using ih (i - 2) cn'
      · rw [mod_mul8 (j := i - 1) (by omega), mod_mul8 (j := i - 2) (by omega), iter_c, ← hcn']
        rfl
      · rw [mod_mul8 (j := i - 1) (by omega), mod_mul8 (j := i - 2) (by omega), iter_n, ← hcn']
        rfl
      · intro h
        subst hS
        exact
          hK E₀ hArgs₀
            ⟨h.1, by
              rw [loop_two _ _ (by omega), hcn']; exact h.2⟩

end sc25519_is_canonical

/-- `sc25519_is_canonical` returns `spec` of the 32 bytes at `p` (`1` iff `S < ℓ`, `spec_eq`);
`L`'s block is freed again, only the counter moves on. -/
public theorem sc25519_is_canonical.call_eq (p : Pointer) (s : GlobalState) (hwf : s.WF)
    (hp : Fits s.mem p 256) (hp_off : ¬p.offset.uaddOverflow 32#64) :
    sc25519_is_canonical.call (sc25519_is_canonical.args (.value p)) s =
      .value
        (.cons (.value (sc25519_is_canonical.spec (s.mem.readAt p 256))) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 1⟩, mem := s.mem }) := by
  func_init
  block_init
  iterate 4 step_pure
  step_addressof sc25519_is_canonical_L.value_eq with Lp
  erw [sc25519_is_canonical_L.flatBits_lit] at hread_Lp
  iterate 4 step_pure
  finish_block
  -- do { … } while (i != 0);
  step_loop using
    sc25519_is_canonical.run_loop p Lp S _ _ hp hp_off hLp_fits hLp_off hread_Lp 15 32 (0#32, 1#32)
  -- return (c != 0);
  intro ⟨h0, hc⟩
  block_init
  iterate 2 step_pure
  finish_block
  subst hS
  erase_frame
  rfl

end Proof

/-! ## `S < ℓ` -/

/-- `spec` is `S < ℓ`. -/
public theorem sc25519_is_canonical.spec_eq (s : BitVec 256) :
    sc25519_is_canonical.spec s = if s.toNat < Ed25519.ell then 1#32 else 0#32 := by
  have h : s.toNat < Ed25519.ell ↔ s < sc25519_is_canonical.L := by
    rw [BitVec.lt_def]
    rfl
  simp only [h, sc25519_is_canonical.spec, sc25519_is_canonical.loop, sc25519_is_canonical.step,
    sc25519_is_canonical.stepB]
  bv_decide

end MLIR.Sodium
