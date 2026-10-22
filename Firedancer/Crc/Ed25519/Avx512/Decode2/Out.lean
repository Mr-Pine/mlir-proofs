module

public import Firedancer.Crc.Ed25519.Avx512.Decode2.Check
public import Firedancer.Crc.Ed25519.Avx512.Decode2.Tail
import Firedancer.Crc.Ed25519.Avx512.Decode2.Tactics

/-! `fd_r52x5_ge_decode2` from `^bb10`: the lane checks of lane 1, `^bb14` and the return. -/

namespace MLIR.Firedancer.Crc.Ed25519.Avx512

open MLIR.Firedancer.R52x5

@[expose] public section

namespace fd_r52x5_ge_decode2

attribute [local mlir_env 1100] read_write_same

/-- The encodings and the outputs: what `^bb14` reads of memory. -/
structure Ptrs (B : GlobalState) (a ea b eb : Pointer) (sA sB : BitVec 256) (m : MemoryState) :
    Prop where
  fa : Fits m ea 256
  fb : Fits m eb 256
  ra : m.readAt ea 256 = sA
  rb : m.readAt eb 256 = sB
  oa : ea.offset.toNat + 32 < 2 ^ 64
  ob : eb.offset.toNat + 32 < 2 ^ 64
  la : ea.id.id < B.alloc.nextFreeBlock
  lb : eb.id.id < B.alloc.nextFreeBlock
  qa : m.Quad5Room a
  qb : m.Quad5Room b
  pa : a.id.id < B.alloc.nextFreeBlock
  pb : b.id.id < B.alloc.nextFreeBlock

set_option maxHeartbeats 4000000 in
/-- `^bb14`: both lanes decoded: `x` fixed and signed, both points stored, `3` returned. -/
theorem bb14_run {β : Type} {E : ⟪Γ⟫} {S : GlobalState}
    {g : Vals [.bv 32] × GlobalState → PoisonOr β} {K : PoisonOr β} {B : GlobalState}
    {M : MemoryState} {c : Nat} {a ea b eb : Pointer} {sA sB : BitVec 256} (X Y : Quad5)
    (c0 c1 : BitVec 32) (hc0 : c0 = 0 ∨ c0 = 1) (hc1 : c1 = 0 ∨ c1 = 1)
    (hArgs : E.args = (argsOf a ea b eb).get)
    (hR : E ⊨ [rir_reg% hty 732 := X.P0, rir_reg% hty 733 := X.P1, rir_reg% hty 734 := X.P2,
      rir_reg% hty 735 := X.P3, rir_reg% hty 736 := X.P4,
      rir_reg% hty 388 := Y.P0, rir_reg% hty 394 := Y.P1, rir_reg% hty 400 := Y.P2,
      rir_reg% hty 406 := Y.P3, rir_reg% hty 412 := Y.P4,
      rir_reg% hty 769 := (0 : BitVec 32) - c0, rir_reg% hty 775 := (0 : BitVec 32) - c1,
      rir_reg% hty 369 := B.slot 230, rir_reg% hty 370 := B.slot 231,
      rir_reg% hty 371 := B.slot 232, rir_reg% hty 372 := B.slot 233,
      rir_reg% hty 373 := B.slot 234,
      rir_reg% hty 374 := B.slot 235, rir_reg% hty 375 := B.slot 236,
      rir_reg% hty 376 := B.slot 237, rir_reg% hty 377 := B.slot 238,
      rir_reg% hty 378 := B.slot 239, rir_reg% hty 379 := B.slot 240,
      rir_reg% hty 380 := B.slot 241, rir_reg% hty 381 := B.slot 242,
      rir_reg% hty 382 := B.slot 243, rir_reg% hty 383 := B.slot 244,
      rir_reg% hty 384 := B.slot 245, rir_reg% hty 139 := B.slot 0, rir_reg% hty 140 := B.slot 1,
      rir_reg% hty 43 := (Vector.replicate 4 1718705420411056#64 : Wl),
      rir_reg% hty 42 := (Vector.replicate 4 234908883556509#64 : Wl),
      rir_reg% hty 41 := (Vector.replicate 4 2233514472574048#64 : Wl),
      rir_reg% hty 40 := (Vector.replicate 4 2117202627021982#64 : Wl),
      rir_reg% hty 39 := (Vector.replicate 4 765476049583133#64 : Wl),
      rir_reg% hty 74 := m8Undef, rir_reg% hty 59 := 0#64, rir_reg% hty 55 := 1#64,
      rir_reg% hty 32 := 2#64, rir_reg% hty 31 := 3#64, rir_reg% hty 62 := 0#32,
      rir_reg% hty 58 := 1#32, rir_reg% hty 56 := 3#32,
      rir_reg% hty 30 := Vector.replicate 2 PoisonOr.poison,
      rir_reg% hty 29 := Ty.wrap (t := .vec 2 32) (Vector.replicate 2 1#32),
      rir_reg% hty 28 := Vector.replicate 2 PoisonOr.poison,
      rir_reg% hty 27 := Ty.wrap (t := .vec 2 8) (Vector.replicate 2 7#8),
      rir_reg% hty 106 := mask1Bytes, rir_reg% hty 138 := mask0Bytes])
    (hI : Inv B M c S) (hP : Ptrs B a ea b eb sA sB M)
    (hK : ∀ S' : GlobalState, S'.alloc.nextFreeBlock = B.alloc.nextFreeBlock + 246 + (c + 42) →
      S'.mem.eraseFrom B.alloc.nextFreeBlock =
        (M.storeQuad5 a (points sA sB X Y c0 c1).1).storeQuad5 b (points sA sB X Y c0 c1).2 →
      g (.cons (.value 3) .nil, { S' with mem := endY S'.mem B }) = K) :
    (fd_r52x5_ge_decode2.runFrom E 14 S >>= g) = K := by
  have hsa := hI.fits hP.fa
  have hsb := hI.fits hP.fb
  have hsA := (hI.readAt hP.la).trans hP.ra
  have hsB := (hI.readAt hP.lb).trans hP.rb
  have hqa := hI.quad5Room hP.qa
  have hqb := hI.quad5Room hP.qb
  block_init
  refine bb14a_run X c0 c1 hc0 hc1 hArgs (by chain_reads) hI fun E1 S1 hA1 hW1 hR1 hI1 => ?_
  have hsa1 := hI1.fits hP.fa
  have hsb1 := hI1.fits hP.fb
  have hsA1 := (hI1.readAt hP.la).trans hP.ra
  have hsB1 := (hI1.readAt hP.lb).trans hP.rb
  refine bb14b_run (blend2Q (c0 == 1) (c1 == 1) (mulQ X sqrtm1Q) X) sA sB hA1 (by chain_reads) hsa1 hsb1 hsA1 hsB1 hP.oa hP.ob hP.la hP.lb hI1
    fun E2 S2 hA2 hW2 hR2 hI2 => ?_
  refine bb14c_run _ Y hA2 (by chain_reads) hI2 (hI2.quad5Room hP.qa) (hI2.quad5Room hP.qb) hP.pa hP.pb
    fun E3 S3 hA3 hW3 halloc3 herase3 hwf3 hF3 => ?_
  have h3 : E3.read (rir_reg% hty 56) = .value 3#32 := by chain_reads
  finish_block
  rw [bb15_run (B := B) 3 (by
    refine ⟨?_, ?_, ?_⟩
    · simp only [hE, read_write_same]; rfl
    · rw [hE]; simp (disch := decide) only [Env.read_write_ne']; chain_reads
    · rw [hE]; simp (disch := decide) only [Env.read_write_ne']; chain_reads)]
  refine hK S3 halloc3 ?_
  rw [herase3]
  rfl


theorem laneCheck_01 (vx2 u nu : Quad5) (j : Fin 4) :
    ((laneCheck vx2 u nu j).2 = 0 ∨ (laneCheck vx2 u nu j).2 = 1) ∧
      ((laneCheck vx2 u nu j).1 = 0 ∨ (laneCheck vx2 u nu j).1 = 1) := by
  simp only [laneCheck]
  split
  · exact ⟨limbs_eq_01 _ _, limbs_eq_01 _ _⟩
  · simp

/-- What the call returns from `^bb10`, `R` the result: the returned value and memory (`endY`
of a state erasing to `storeOut M a b R`, `alloc` past the frame, the checks and the output). -/
def Done (B : GlobalState) (M : MemoryState) (c : Nat) (a b : Pointer)
    (R : BitVec 32 × Option (Quad5 × Quad5)) (g : Vals [.bv 32] × GlobalState → PoisonOr β)
    (K : PoisonOr β) : Prop :=
  ∀ S' : GlobalState,
    S'.alloc.nextFreeBlock =
        B.alloc.nextFreeBlock + 246 + (c + 36 + (match R.2 with | none => 0 | some _ => 42)) →
      S'.mem.eraseFrom B.alloc.nextFreeBlock = storeOut M a b R →
      g (.cons (.value R.1) .nil, { S' with mem := endY S'.mem B }) = K

set_option maxHeartbeats 4000000 in
/-- From `^bb13`, lane 1 decoded (`fix1` its fix): `2` if lane 0 did not, else `^bb14`. -/
theorem from13 {β : Type} {E : ⟪Γ⟫} {S : GlobalState}
    {g : Vals [.bv 32] × GlobalState → PoisonOr β} {K : PoisonOr β} {B : GlobalState}
    {M : MemoryState} {c : Nat} {a ea b eb : Pointer} {sA sB : BitVec 256} (X Y VX2 U NU : Quad5)
    (hArgs : E.args = (argsOf a ea b eb).get)
    (hR : E ⊨ [rir_reg% hty 732 := X.P0, rir_reg% hty 733 := X.P1, rir_reg% hty 734 := X.P2,
      rir_reg% hty 735 := X.P3, rir_reg% hty 736 := X.P4,
      rir_reg% hty 388 := Y.P0, rir_reg% hty 394 := Y.P1, rir_reg% hty 400 := Y.P2,
      rir_reg% hty 406 := Y.P3, rir_reg% hty 412 := Y.P4,
      rir_reg% hty 769 := (0 : BitVec 32) - (laneCheck VX2 U NU 0).2,
      rir_reg% hty 770 := (laneCheck VX2 U NU 0).1,
      rir_reg% hty 366 := B.slot 227, rir_reg% hty 367 := B.slot 228,
      rir_reg% hty 368 := B.slot 229,
      rir_reg% hty 369 := B.slot 230, rir_reg% hty 370 := B.slot 231,
      rir_reg% hty 371 := B.slot 232, rir_reg% hty 372 := B.slot 233,
      rir_reg% hty 373 := B.slot 234,
      rir_reg% hty 374 := B.slot 235, rir_reg% hty 375 := B.slot 236,
      rir_reg% hty 376 := B.slot 237, rir_reg% hty 377 := B.slot 238,
      rir_reg% hty 378 := B.slot 239, rir_reg% hty 379 := B.slot 240,
      rir_reg% hty 380 := B.slot 241, rir_reg% hty 381 := B.slot 242,
      rir_reg% hty 382 := B.slot 243, rir_reg% hty 383 := B.slot 244,
      rir_reg% hty 384 := B.slot 245, rir_reg% hty 139 := B.slot 0, rir_reg% hty 140 := B.slot 1,
      rir_reg% hty 43 := (Vector.replicate 4 1718705420411056#64 : Wl),
      rir_reg% hty 42 := (Vector.replicate 4 234908883556509#64 : Wl),
      rir_reg% hty 41 := (Vector.replicate 4 2233514472574048#64 : Wl),
      rir_reg% hty 40 := (Vector.replicate 4 2117202627021982#64 : Wl),
      rir_reg% hty 39 := (Vector.replicate 4 765476049583133#64 : Wl),
      rir_reg% hty 74 := m8Undef, rir_reg% hty 59 := 0#64, rir_reg% hty 55 := 1#64,
      rir_reg% hty 32 := 2#64, rir_reg% hty 31 := 3#64, rir_reg% hty 62 := 0#32,
      rir_reg% hty 58 := 1#32, rir_reg% hty 57 := 2#32, rir_reg% hty 56 := 3#32,
      rir_reg% hty 30 := Vector.replicate 2 PoisonOr.poison,
      rir_reg% hty 29 := Ty.wrap (t := .vec 2 32) (Vector.replicate 2 1#32),
      rir_reg% hty 28 := Vector.replicate 2 PoisonOr.poison,
      rir_reg% hty 27 := Ty.wrap (t := .vec 2 8) (Vector.replicate 2 7#8),
      rir_reg% hty 106 := mask1Bytes, rir_reg% hty 138 := mask0Bytes])
    (hc1 : (laneCheck VX2 U NU 1).1 = 1)
    (hf : E ⊨ [rir_reg% hty 775 := (0 : BitVec 32) - (laneCheck VX2 U NU 1).2])
    (hI : Inv B M (c + 36) S) (hP : Ptrs B a ea b eb sA sB M)
    (hK : Done B M c a b (tail sA sB X Y VX2 U NU) g K) :
    (fd_r52x5_ge_decode2.runFrom E 13 S >>= g) = K := by
  have h01 := laneCheck_01 VX2 U NU 0
  have h11 := laneCheck_01 VX2 U NU 1
  refine bb13_run (laneCheck VX2 U NU 0).1 _ (by chain_reads) hI ?_ ?_
  · intro h0 S' hI'
    have ht : tail sA sB X Y VX2 U NU = (2, none) := by
      simp only [tail, hc1, h0, show (1 : BitVec 32) ≠ 0 by decide, ↓reduceIte]
    rw [ht] at hK
    exact hK S' (by rw [hI'.alloc]; simp only) (by rw [hI'.erase]; rfl)
  · intro h0 E14 S14 hA14 hW14 hI14
    have hok : (laneCheck VX2 U NU 0).1 = 1 := by
      rcases h01.2 with h | h
      · exact absurd h h0
      · exact h
    have ht : tail sA sB X Y VX2 U NU =
        (3, some (points sA sB X Y (laneCheck VX2 U NU 0).2 (laneCheck VX2 U NU 1).2)) := by
      simp only [tail, hc1, hok, show (1 : BitVec 32) ≠ 0 by decide, ↓reduceIte]
    rw [ht] at hK
    refine bb14_run X Y _ _ h01.1 h11.1 (hA14.trans hArgs) (by chain_reads) hI14 hP
      fun S' halloc herase => hK S' (by rw [halloc]) herase

set_option maxHeartbeats 4000000 in
/-- From `^bb10`: lane 1's checks, then `^bb12` (`ok0`), `^bb13` (`2`) or `^bb14` (`3`), against
`tail`; `ok0`, `-c0` lane 0's `ok` and fix. -/
theorem from10 {β : Type} {E : ⟪Γ⟫} {S : GlobalState}
    {g : Vals [.bv 32] × GlobalState → PoisonOr β} {K : PoisonOr β} {B : GlobalState}
    {M : MemoryState} {c : Nat} {a ea b eb : Pointer} {sA sB : BitVec 256} (X Y VX2 U NU : Quad5)
    (hArgs : E.args = (argsOf a ea b eb).get)
    (hR : E ⊨ [rir_reg% hty 732 := X.P0, rir_reg% hty 733 := X.P1, rir_reg% hty 734 := X.P2,
      rir_reg% hty 735 := X.P3, rir_reg% hty 736 := X.P4,
      rir_reg% hty 388 := Y.P0, rir_reg% hty 394 := Y.P1, rir_reg% hty 400 := Y.P2,
      rir_reg% hty 406 := Y.P3, rir_reg% hty 412 := Y.P4,
      rir_reg% hty 742 := VX2.P0, rir_reg% hty 743 := VX2.P1,
      rir_reg% hty 744 := VX2.P2, rir_reg% hty 745 := VX2.P3, rir_reg% hty 746 := VX2.P4,
      rir_reg% hty 418 := U.P0, rir_reg% hty 419 := U.P1, rir_reg% hty 420 := U.P2,
      rir_reg% hty 421 := U.P3, rir_reg% hty 422 := U.P4,
      rir_reg% hty 747 := NU.P0, rir_reg% hty 748 := NU.P1, rir_reg% hty 749 := NU.P2,
      rir_reg% hty 750 := NU.P3, rir_reg% hty 751 := NU.P4,
      rir_reg% hty 769 := (0 : BitVec 32) - (laneCheck VX2 U NU 0).2,
      rir_reg% hty 770 := (laneCheck VX2 U NU 0).1,
      rir_reg% hty 366 := B.slot 227, rir_reg% hty 367 := B.slot 228,
      rir_reg% hty 368 := B.slot 229,
      rir_reg% hty 369 := B.slot 230, rir_reg% hty 370 := B.slot 231,
      rir_reg% hty 371 := B.slot 232, rir_reg% hty 372 := B.slot 233,
      rir_reg% hty 373 := B.slot 234,
      rir_reg% hty 374 := B.slot 235, rir_reg% hty 375 := B.slot 236,
      rir_reg% hty 376 := B.slot 237, rir_reg% hty 377 := B.slot 238,
      rir_reg% hty 378 := B.slot 239, rir_reg% hty 379 := B.slot 240,
      rir_reg% hty 380 := B.slot 241, rir_reg% hty 381 := B.slot 242,
      rir_reg% hty 382 := B.slot 243, rir_reg% hty 383 := B.slot 244,
      rir_reg% hty 384 := B.slot 245, rir_reg% hty 139 := B.slot 0, rir_reg% hty 140 := B.slot 1,
      rir_reg% hty 43 := (Vector.replicate 4 1718705420411056#64 : Wl),
      rir_reg% hty 42 := (Vector.replicate 4 234908883556509#64 : Wl),
      rir_reg% hty 41 := (Vector.replicate 4 2233514472574048#64 : Wl),
      rir_reg% hty 40 := (Vector.replicate 4 2117202627021982#64 : Wl),
      rir_reg% hty 39 := (Vector.replicate 4 765476049583133#64 : Wl),
      rir_reg% hty 74 := m8Undef, rir_reg% hty 59 := 0#64, rir_reg% hty 55 := 1#64,
      rir_reg% hty 32 := 2#64, rir_reg% hty 31 := 3#64, rir_reg% hty 62 := 0#32,
      rir_reg% hty 58 := 1#32, rir_reg% hty 57 := 2#32, rir_reg% hty 56 := 3#32,
      rir_reg% hty 44 := 4294967295#32,
      rir_reg% hty 30 := Vector.replicate 2 PoisonOr.poison,
      rir_reg% hty 29 := Ty.wrap (t := .vec 2 32) (Vector.replicate 2 1#32),
      rir_reg% hty 28 := Vector.replicate 2 PoisonOr.poison,
      rir_reg% hty 27 := Ty.wrap (t := .vec 2 8) (Vector.replicate 2 7#8),
      rir_reg% hty 106 := mask1Bytes, rir_reg% hty 138 := mask0Bytes])
    (hI : Inv B M (c + 18) S) (hP : Ptrs B a ea b eb sA sB M)
    (hK : Done B M c a b (tail sA sB X Y VX2 U NU) g K) :
    (fd_r52x5_ge_decode2.runFrom E 10 S >>= g) = K := by
  have h01 := laneCheck_01 VX2 U NU 0
  refine bb10_run VX2 U NU (by chain_reads) hI ?_ ?_
  · intro E11 S11 hA11 hW11 he1 hv hn f0 f2 hI11
    refine bb11_run _ _ (by chain_reads) ⟨hI11.wf, hv, hn, f0, f2⟩ ?_ ?_
    · intro E12 hA12 hW12 he2
      refine bb12_run (laneCheck VX2 U NU 0).1 (by chain_reads) hI11 fun S' hI' => ?_
      have ht : tail sA sB X Y VX2 U NU = ((laneCheck VX2 U NU 0).1, none) := by
        simp only [tail, laneCheck, he1, he2, ↓reduceIte]
      rw [ht] at hK
      exact hK S' (by rw [hI'.alloc]; simp only) (by rw [hI'.erase]; rfl)
    · intro E13 hA13 hW13 he2 hR13
      have hc1 : (laneCheck VX2 U NU 1).1 = 1 ∧ (laneCheck VX2 U NU 1).2 = 1 := by
        rcases limbs_eq_01 (fd_r52x5_quad_lane_canon.spec VX2 1) (fd_r52x5_quad_lane_canon.spec NU 1)
          with h | h
        · exact absurd h he2
        · simp only [laneCheck, he1, h, ↓reduceIte, and_self]
      refine from13 X Y VX2 U NU (hA13.trans hA11 |>.trans hArgs) (by chain_reads) hc1.1
        (by rw [hc1.2]; chain_reads) hI11 hP hK
  · intro E13 S13 hA13 hW13 he1 hR13 hI13
    have hc1 : (laneCheck VX2 U NU 1).1 = 1 ∧ (laneCheck VX2 U NU 1).2 = 0 := by
      simp only [laneCheck, he1, ↓reduceIte, and_self]
    refine from13 X Y VX2 U NU (hA13.trans hArgs) (by chain_reads) hc1.1
      (by rw [hc1.2]; chain_reads) hI13 hP hK

end fd_r52x5_ge_decode2

end

end MLIR.Firedancer.Crc.Ed25519.Avx512
