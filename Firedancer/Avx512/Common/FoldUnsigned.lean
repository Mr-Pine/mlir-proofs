module

public import MLIR.Semantics.Func
public import MLIR.Run.BasicBlock
public import MLIR.Run.Tactic

/-! `fd_r43x6_fold_unsigned`, the four instructions after every `fd_r43x6_mul_fast` and
`fd_r43x6_sqr_fast` call: its spec, the instructions as a template, and the lemma stepping them. -/

namespace MLIR.Firedancer.Avx512

@[expose] public section

/-- `<8 x i64>`. -/
abbrev V : Ty :=
  .vec 8 64

/-- `fd_r43x6_approx_carry_propagate`'s lane rotation: lane 5's carry to lane 0. -/
abbrev rot : Vector (Option (Fin (2 * 8))) 8 :=
  #v[some 5, some 0, some 1, some 2, some 3, some 4, some 6, some 7]

/-- The fold's masks: 43 bits, 40 in lane 5, none in lanes 6 and 7. -/
@[mlir_const]
def foldMask : Vector (BitVec 64) 8 :=
  #v[8796093022207, 8796093022207, 8796093022207, 8796093022207, 8796093022207, 1099511627775, 0, 0]

/-- The fold's shift amounts. -/
@[mlir_const]
def foldShifts : Vector (BitVec 64) 8 :=
  #v[43, 43, 43, 43, 43, 40, 0, 0]

/-- The carries' multipliers: lane 5's carry wraps to lane 0 times `19`. -/
@[mlir_const]
def foldK : Vector (BitVec 64) 8 :=
  #v[19, 1, 1, 1, 1, 1, 0, 0]

/-- Every shift amount is below the lane width. -/
theorem foldShifts_lt (i : Nat) (h : i < 8) : ¬64 ≤ foldShifts[i].toNat := by
  revert i; decide

/-- `fd_r43x6_fold_unsigned`: each lane's low 43 bits (40 in lane 5), plus the lane below's carry,
lane 5's times `19` into lane 0; the carry product's low 52 bits (`vpmadd52l`). -/
@[irreducible]
def fold (x : Vector (BitVec 64) 8) : Vector (BitVec 64) 8 :=
  let c := Vector.zipWith (fun v s => v >>> s.toNat) x foldShifts
  let c : Vector (BitVec 64) 8 := #v[c[5], c[0], c[1], c[2], c[3], c[4], c[6], c[7]]
  let m52 : BitVec 64 := 0xFFFFFFFFFFFFF
  Vector.ofFn fun i => (x[i] &&& foldMask[i]) + ((foldK[i] &&& m52) * (c[i] &&& m52) &&& m52)

/-- `fd_r43x6_fold_unsigned` as four instructions: `x`'s fold into `r`, through `a b c`, with the
masks in `m`, the shifts in `s` and `19, 1, …` in `k`; `p` is the rotation's unused operand. All
value registers, as at every site. -/
def foldRun (x m s p k a b c r : Dst Γ V) : List (Instr Γ) :=
  [.binop (.vector .and) a (.val x.i x.h) (.val m.i m.h),
    .binop (.vector (.lshr false)) b (.val x.i x.h) (.val s.i s.h),
    .binop (.shufflevector rot) c (.val b.i b.h) (.val p.i p.h),
    .ternop .vpmadd52l r (.val a.i a.h) (.val k.i k.h) (.val c.i c.h)]

/-- Where the body at `pos` is `foldRun`, and `x m s k` hold `X` and the fold's constants, running
on from `pos` then `g` gives `K` if it does from `pos + 4` with `fold X` in `r`, whatever the
intermediates `a b c` hold. The registers read and written are distinct (`hd`). -/
theorem runBodyFrom_foldRun {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {x m s p k a b c r : Dst Γ V} {rest : List (Instr Γ)} {X : Vector (BitVec 64) 8}
    {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody : blk.body.drop pos = foldRun x m s p k a b c r ++ rest)
    (hR : E ⊨ [x := X, m := foldMask, s := foldShifts, k := foldK])
    (hd : [x.i, s.i, k.i, a.i, b.i, c.i].Nodup)
    (hK :
      ∀ va vb vc : ⟦V⟧,
        (blk.runBodyFrom E[a := va, b := vb, c := vc, r := Ty.wrap (fold X)] (pos + 4) S >>= g) =
          K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  step_pure with transparent va
  step_pure [foldShifts_lt] with transparent vb
  step_pure with transparent vc
  step_pure with vd
  rw [hE, ← hK]
  congr
  rw [hvd, fold]
  ext i hi : 1
  simp [Vector.getElem_ofFn hi]

end

end MLIR.Firedancer.Avx512
