module

public import MLIR.Run.Tactic
public import Firedancer.Ref.fd_curve25519_scalar_validate
public import Firedancer.Crc.Ref.Fe64Carry
public import Firedancer.Crc.Ref.Mlir.fd_curve25519_scalar_validate
public import Firedancer.Crc.Ref.Mlir.fd_curve25519_scalar_validate_50
import Std.Tactic.BVDecide

/-!
# `fd_curve25519_scalar_validate` (MLIR lift ↔ spec)

Stated with the tree's `Firedancer.Ref.fd_curve25519_scalar_validate.spec` (`s < ℓ`). This `validate`
runs `fd_ulong_sub_borrow` (`Fe64Carry`) through two stack slots; it has a second lifted copy.
-/

namespace MLIR.Firedancer.Crc.Ref

open Firedancer.Ref (scalarL MemoryState.readAt_add_of_fits MemoryState.readAt_of_fits)

/-! ## Proof -/

section Proof

set_option hygiene false in
/-- The proof of `fd_curve25519_scalar_validate.call_eq`, for each copy calling `sb`. -/
local macro "validate_proof " sb:ident : tactic =>
  `(tactic|
    ( func_init
      block_init
      -- the constants
      iterate 9 step_pure
      -- ulong r; int b;
      step_alloca with r
      step_alloca with b
      -- if( FD_UNLIKELY( s[31] & 0xF0 ) ): compiled as `s[31] < 0x10`
      step_pure
      step_load
      step_pure
      finish_block <;> block_init
      case isTrue =>
        -- return s;
        finish_block
        subst hS
        erase_frame
        simp (disch := decide) only [MemoryState.readAt_add_of_fits (v := 256) hfits₀ hoff,
          Nat.reduceMul] at hbr
        rw [ite_eq_left
            (by
              simp only [Firedancer.Ref.fd_curve25519_scalar_validate.spec, scalarL]; bv_decide)]
        rfl
      case isFalse =>
        -- if( FD_LIKELY( s[31] & 0xE0 ) ) return NULL;
        step_pure
        finish_block <;> block_init
        case isFalse =>
          finish_block
          subst hS
          erase_frame
          simp (disch := decide) only [MemoryState.readAt_add_of_fits (v := 256) hfits₀ hoff,
            Nat.reduceMul] at hbr
          rw [ite_eq_right
              (by
                simp only [Firedancer.Ref.fd_curve25519_scalar_validate.spec, scalarL]; bv_decide)]
          rfl
        case isTrue =>
          -- ulong s0 = fd_ulong_load_8_fast( s ); … s3
          step_load with s0
          step_pure
          step_load with s1
          step_pure
          step_load with s2
          step_pure
          step_load with s3
          -- the slots' `lifetime.start`s
          step_pure
          step_pure
          -- fd_ulong_sub_borrow( &r, &b, s0, l0, 1 ); …
          step_call using $sb
          step_load
          step_call using $sb
          step_load
          step_call using $sb
          step_load
          step_call using $sb
          step_load
          -- return b ? s : NULL;
          step_pure
          step_pure
          step_pure
          step_pure
          finish_block
          block_init
          finish_block
          subst hS hs0 hs1 hs2 hs3
          erase_frame
          simp (disch := decide) only [MemoryState.readAt_add_of_fits (v := 256) hfits₀ hoff,
            MemoryState.readAt_of_fits (v := 256) (w := 64) hfits₀, Nat.reduceMul]
          rw [fd_curve25519_scalar_validate.borrow_eq]
          rfl))

/-! `fd_ulong_sub_borrow`'s borrow out is `a.toNat < b.toNat + b'`; these turn the chain into
compares `bv_decide` reads. -/

theorem lt_add_ite {a n : Nat} {c : Prop} [Decidable c] :
    (a < n + if c then 0 else 1) ↔ c ∧ a < n ∨ ¬c ∧ a < n + 1 := by split <;> simp [*]

theorem add_ite_le {a n : Nat} {c : Prop} [Decidable c] :
    (n + (if c then 0 else 1) ≤ a) ↔ c ∧ n ≤ a ∨ ¬c ∧ n + 1 ≤ a := by split <;> simp [*]

theorem ite_le {a : Nat} {c : Prop} [Decidable c] : ((if c then 0 else 1) ≤ a) ↔ c ∨ 1 ≤ a := by
  split <;> simp [*]

theorem le_toNat_iff {x : BitVec 64} {n : Nat} (h : n < 2 ^ 64) :
    n ≤ x.toNat ↔ BitVec.ofNat 64 n ≤ x := by simp [BitVec.le_def, Nat.mod_eq_of_lt h]

theorem toNat_lt_iff {x : BitVec 64} {n : Nat} (h : n < 2 ^ 64) :
    x.toNat < n ↔ x < BitVec.ofNat 64 n := by simp [BitVec.lt_def, Nat.mod_eq_of_lt h]

theorem ite_flip {α : Type} {x y : α} {A B : Prop} [Decidable A] [Decidable B] (h : A ↔ ¬B) :
    (if A then x else y) = if B then y else x := by by_cases hb : B <;> simp [h, hb]

/-- The borrow chain against `ℓ - 1` with borrow in `1` borrows out iff `x < ℓ`, as the steps
leave it. -/
theorem fd_curve25519_scalar_validate.borrow_eq (x : BitVec 256) (p : Pointer) :
    (if
          BitVec.ofBool
              (BitVec.setWidth 32
                  (if
                      (x.extractLsb' 192 64).toNat <
                        1152921504606846976 +
                          if
                              (if
                                    (1503914060200516822 +
                                        if 6346243789798364141 ≤ (x.extractLsb' 0 64).toNat then 0
                                        else 1) ≤
                                      (x.extractLsb' 64 64).toNat then
                                  0
                                else 1) ≤
                                (x.extractLsb' 128 64).toNat then
                            0
                          else 1 then
                    1#8
                  else 0#8) ==
                0#32) =
            1#1 then
        Pointer.null
      else p) =
      if Firedancer.Ref.fd_curve25519_scalar_validate.spec x then p else Pointer.null := by
  simp only [Firedancer.Ref.fd_curve25519_scalar_validate.spec, scalarL]
  simp (disch := decide) only [lt_add_ite, add_ite_le, ite_le, toNat_lt_iff, le_toNat_iff,
    Nat.reduceAdd]
  apply ite_flip
  bv_decide

/-- `validate` returns `p` when the 32 bytes at `p` are a canonical scalar (below `ℓ`), else
`NULL`; it allocates the slots of `r` and `b`. -/
public theorem fd_curve25519_scalar_validate.call_eq (p : Pointer) (s : GlobalState) (hwf : s.WF)
    (hfits : Fits s.mem p (8 * 32)) (hoff : ¬p.offset.uaddOverflow 32#64) :
    fd_curve25519_scalar_validate.call (fd_curve25519_scalar_validate.args (.value p)) s =
      .value
        (.cons
            (.value
              (if Firedancer.Ref.fd_curve25519_scalar_validate.spec (s.mem.readAt p 256) then p
              else Pointer.null))
            .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 2⟩, mem := s.mem }) := by
  validate_proof fd_ulong_sub_borrow.call_eq

/-- `validate (copy `.50`)` returns `p` when the 32 bytes at `p` are a canonical scalar (below `ℓ`), else
`NULL`; it allocates the slots of `r` and `b`. -/
public theorem fd_curve25519_scalar_validate_50.call_eq (p : Pointer) (s : GlobalState) (hwf : s.WF)
    (hfits : Fits s.mem p (8 * 32)) (hoff : ¬p.offset.uaddOverflow 32#64) :
    fd_curve25519_scalar_validate_50.call (fd_curve25519_scalar_validate_50.args (.value p)) s =
      .value
        (.cons
            (.value
              (if Firedancer.Ref.fd_curve25519_scalar_validate.spec (s.mem.readAt p 256) then p
              else Pointer.null))
            .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 2⟩, mem := s.mem }) := by
  validate_proof fd_ulong_sub_borrow_51.call_eq

end Proof

end MLIR.Firedancer.Crc.Ref
