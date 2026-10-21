module

public import MLIR.Run.Tactic
public import Firedancer.Ref.fd_ulong_load_8
public import Firedancer.Ref.Mlir.fd_curve25519_scalar_validate
import Std.Tactic.BVDecide

namespace MLIR.Firedancer.Ref

/-! ## Specification -/

@[expose] public section

/-- `ℓ = 2^252 + 27742317777372353535851937790883648493`, the order of edwards25519's prime-order
subgroup. -/
def scalarL : BitVec 256 :=
  0x1000000000000000000000000000000014def9dea2f79cd65812631a5cf5d3ed#256

/-- The scalar `s` is canonical: below `ℓ`. -/
def fd_curve25519_scalar_validate.spec (s : BitVec 256) : Bool :=
  s < scalarL

end

/-! ## Staged for Common -/

/-- A read inside a buffer whose offsets up to `len` do not wrap: those bits of the buffer's read. -/
public theorem MemoryState.readAt_add_of_fits {m : MemoryState} {len : BitVec 64}
    (hfits : Fits m p v) (hoff : ¬p.offset.uaddOverflow len) (hv : v ≤ 8 * len.toNat)
    (hk : 8 * k + w ≤ v) :
    m.readAt (p.add (BitVec.ofNat 64 k)) w = (m.readAt p v).extractLsb' (8 * k) w := by
  have hk' : (BitVec.ofNat 64 k).toNat = k := by
    rw [BitVec.toNat_ofNat]
    exact
      Nat.mod_eq_of_lt
        (by
          have := len.isLt; omega)
  have hov : ¬p.offset.uaddOverflow (BitVec.ofNat 64 k) :=
    BitVec.not_uaddOverflow_of_le hoff (by omega)
  rw [MemoryState.readAt_add_of_readAt (w := w) hfits.inBounds hov (by omega) rfl, hk',
    Nat.mul_comm k 8]

/-- A read at a buffer's start: the low bits of the buffer's read. -/
public theorem MemoryState.readAt_of_fits {m : MemoryState} (hfits : Fits m p v) (hw : w ≤ v) :
    m.readAt p w = (m.readAt p v).extractLsb' 0 w := by
  have :=
    MemoryState.readAt_add_of_readAt (off := 0#64) (w := w) hfits.inBounds
      (by
        have := p.offset.isLt; simp [BitVec.uaddOverflow]; omega)
      (by simpa using hw) rfl
  simpa [Pointer.add] using this

/-! `subborrow`'s borrow out is `a.toNat < b.toNat + c'`; these turn the chain into compares
`bv_decide` reads. -/

public theorem lt_add_ite {a n : Nat} {c : Prop} [Decidable c] :
    (a < n + if c then 0 else 1) ↔ c ∧ a < n ∨ ¬c ∧ a < n + 1 := by split <;> simp [*]

public theorem add_ite_le {a n : Nat} {c : Prop} [Decidable c] :
    (n + (if c then 0 else 1) ≤ a) ↔ c ∧ n ≤ a ∨ ¬c ∧ n + 1 ≤ a := by split <;> simp [*]

public theorem ite_le {a : Nat} {c : Prop} [Decidable c] :
    ((if c then 0 else 1) ≤ a) ↔ c ∨ 1 ≤ a := by
  split <;> simp [*]

public theorem toNat_lt_iff {x : BitVec 64} {n : Nat} (h : n < 2 ^ 64) :
    x.toNat < n ↔ x < BitVec.ofNat 64 n := by simp [BitVec.lt_def, Nat.mod_eq_of_lt h]

public theorem le_toNat_iff {x : BitVec 64} {n : Nat} (h : n < 2 ^ 64) :
    n ≤ x.toNat ↔ BitVec.ofNat 64 n ≤ x := by simp [BitVec.le_def, Nat.mod_eq_of_lt h]

public theorem ite_flip {α : Type} {x y : α} {A B : Prop} [Decidable A] [Decidable B]
    (h : A ↔ ¬B) : (if A then x else y) = if B then y else x := by
  by_cases hb : B <;> simp [h, hb]

/-! ## Proof -/

section Proof

/-- `validate` returns `p` when the 32 bytes at `p` are a canonical scalar (below `ℓ`), else
`NULL`, and leaves the state alone. -/
public theorem fd_curve25519_scalar_validate.call_eq (p : Pointer) (s : GlobalState) (hwf : s.WF)
    (hfits : Fits s.mem p (8 * 32)) (hoff : ¬p.offset.uaddOverflow 32#64) :
    fd_curve25519_scalar_validate.call (fd_curve25519_scalar_validate.args (.value p)) s =
      .value
        (.cons
            (.value
              (if fd_curve25519_scalar_validate.spec (s.mem.readAt p 256) then p else Pointer.null))
            .nil,
          s) := by
  func_init
  block_init
  -- the constants, `NULL` and `s + 31`
  iterate 10 step_pure
  -- if( FD_UNLIKELY( s[31] & 0xF0 ) ): compiled as `s[31] < 0x10`
  step_load
  step_pure
  finish_block <;> block_init
  case isTrue =>
    -- return s;
    finish_block
    subst hS
    simp (disch := decide) only [MemoryState.readAt_add_of_fits (v := 256) hfits hoff,
      Nat.reduceMul] at hbr
    rw [ite_eq_left
        (by
          simp only [fd_curve25519_scalar_validate.spec, scalarL]; bv_decide)]
  case isFalse =>
    -- if( FD_LIKELY( s[31] & 0xE0 ) ) return NULL;
    step_pure
    finish_block <;> block_init
    case isFalse =>
      finish_block
      subst hS
      simp (disch := decide) only [MemoryState.readAt_add_of_fits (v := 256) hfits hoff,
        Nat.reduceMul] at hbr
      rw [ite_eq_right
          (by
            simp only [fd_curve25519_scalar_validate.spec, scalarL]; bv_decide)]
    case isTrue =>
      -- ulong s0 = fd_ulong_load_8_fast( s ); … s3
      step_call using fd_ulong_load_8.call_eq with s0
      step_pure
      step_call using fd_ulong_load_8.call_eq with s1
      step_pure
      step_call using fd_ulong_load_8.call_eq with s2
      step_pure
      step_call using fd_ulong_load_8.call_eq with s3
      -- the `fd_ulong_sub_borrow` chain against `ℓ - 1`, compiled to compares and selects
      iterate 8 step_pure
      finish_block
      block_init
      finish_block
      subst hS hs0 hs1 hs2 hs3
      simp (disch := decide) only [MemoryState.readAt_add_of_fits (v := 256) hfits hoff,
        MemoryState.readAt_of_fits (v := 256) (w := 64) hfits, Nat.reduceMul]
      congr 5
      apply propext
      clear hE
      simp only [fd_curve25519_scalar_validate.spec, scalarL]
      bv_decide

end Proof

end MLIR.Firedancer.Ref
