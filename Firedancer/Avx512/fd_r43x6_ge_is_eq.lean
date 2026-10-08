module

public import SSA.Projects.RIR.Run.Tactic
public import Firedancer.Avx512.Common.Point
public import Firedancer.Avx512.fd_r43x6_is_nonzero
public import Firedancer.Avx512.Mlir.fd_r43x6_ge_is_eq
import Std.Tactic.BVDecide
meta import Std.Tactic.BVDecide.Reflect

namespace LeanMLIR.RIR.Firedancer.Avx512

/-! ## Specification -/

@[expose] public section

/-- `1` when `X` and `Y` are the same point by the cross products `xn1 = X.x Y.z`, `xn2 = Y.x X.z`,
`yn1 = X.y Y.z`, `yn2 = Y.y X.z`, else `0`. -/
def fd_r43x6_ge_is_eq.spec (X Y : Quad) : BitVec 32 :=
  let X := X.permute 2 0 2 1
  let Y := Y.permute 0 2 1 2
  let M := quadMul X Y
  let xn2 := M.X
  let xn1 := M.Y
  let yn2 := M.Z
  let yn1 := M.T
  let ok (x : Wwl) : BitVec 32 := if fd_r43x6_is_nonzero.spec x = 0 then 1 else 0
  ok (fd_r43x6_sub_fast xn1 xn2) &&& ok (fd_r43x6_sub_fast yn1 yn2)

end

/-! ## Proof -/

section Proof

attribute [-mlir_operation] zipWith_eq_ofFn
-- `vpermi2var` stays folded until its index is a literal, for `reduceVpermi2var`
attribute [-mlir_operation] Operation.vpermi2var

theorem Quad.permute_2021 (P : Quad) : P.permute 2 0 2 1 = P.perm4 2 0 2 1 := by
  quad_lanes

theorem Quad.permute_0212 (P : Quad) : P.permute 0 2 1 2 = P.perm4 0 2 1 2 := by
  quad_lanes

/-- `fd_r43x6_sub_fast` as compiled: `x - y + p`. -/
theorem fd_r43x6_sub_fast_eq (x y : Wwl) :
    fd_r43x6_sub_fast x y = wwl_add (wwl_sub x y) fd_r43x6_p := by
  ext i hi : 1
  simp only [fd_r43x6_sub_fast, wwl_add, wwl_sub, Vector.getElem_ofFn, Fin.getElem_fin,
    add_sub_comm']

/-- The code's `!nz1 & !nz2`, from `nz ^ -1` and `nz ^ 1`. -/
theorem not_and_not (n1 n2 : BitVec 32) (h1 : n1 = 0 ∨ n1 = 1) (h2 : n2 = 0 ∨ n2 = 1) :
    (n2 ^^^ 1#32) &&& (n1 ^^^ 4294967295#32) =
      (if n1 = 0 then 1 else 0) &&& (if n2 = 0 then 1 else 0) := by
  rcases h1 with rfl | rfl <;> rcases h2 with rfl | rfl <;> decide

/-- `fd_r43x6_ge_is_eq` returns `spec` of the points `X` and `Y`; its three temporaries use up
three block ids. -/
public theorem fd_r43x6_ge_is_eq.call_eq (X03 X14 X25 Y03 Y14 Y25 : Wwl) (s : GlobalState)
    (hwf : s.WF) :
    fd_r43x6_ge_is_eq.call
        (fd_r43x6_ge_is_eq.args (Ty.wrap X03) (Ty.wrap X14) (Ty.wrap X25) (Ty.wrap Y03)
          (Ty.wrap Y14) (Ty.wrap Y25)) s =
      .value (.cons (.value (fd_r43x6_ge_is_eq.spec ⟨X03, X14, X25⟩ ⟨Y03, Y14, Y25⟩)) .nil,
        { s with alloc := ⟨s.alloc.nextFreeBlock + 3⟩ }) := by
  func_init
  block_init
  iterate 33 step_pure
  iterate 3 step_alloca
  -- FD_R43X6_QUAD_PERMUTE( X, 2,0,2,1, X ); FD_R43X6_QUAD_PERMUTE( Y, 0,2,1,2, Y )
  step_pure with xa03
  step_pure with xa14
  step_pure with xa25
  step_pure with ya03
  step_pure with ya14
  step_pure with ya25
  -- FD_R43X6_QUAD_MUL_FAST( X, X, Y )
  iterate 3 step_pure
  step_call using fd_r43x6_quad_mul_fast.call_eq
  step_load with m03
  step_load with m14
  step_load with m25
  iterate 3 step_pure
  -- FD_R43X6_QUAD_UNPACK( xn2, xn1, yn2, yn1, X )
  iterate 4 step_pure
  step_pure [reduceVpermi2var] with xn2
  step_pure [reduceVpermi2var] with xn1
  step_pure [reduceVpermi2var] with yn2
  step_pure [reduceVpermi2var] with yn1
  -- !fd_r43x6_is_nonzero( fd_r43x6_sub_fast( xn1, xn2 ) ) & …( yn1, yn2 )
  step_pure [wrapZipWith]
  step_pure [wrapZipWith] with dx
  step_call using fd_r43x6_is_nonzero.call_eq
  step_pure
  step_pure [wrapZipWith]
  step_pure [wrapZipWith] with dy
  step_call using fd_r43x6_is_nonzero.call_eq
  step_pure
  step_pure
  finish_block
  subst hS
  erase_frame
  have e1 : Quad.perm4 2 0 2 1 ⟨X03, X14, X25⟩ = ⟨xa03, xa14, xa25⟩ := by
    rw [hxa03, hxa14, hxa25]; rfl
  have e2 : Quad.perm4 0 2 1 2 ⟨Y03, Y14, Y25⟩ = ⟨ya03, ya14, ya25⟩ := by
    rw [hya03, hya14, hya25]; rfl
  have e3 : quadMul ⟨xa03, xa14, xa25⟩ ⟨ya03, ya14, ya25⟩ = ⟨m03, m14, m25⟩ := by
    rw [hm03, hm14, hm25]; rfl
  have e4 : fd_r43x6_sub_fast (Quad.Y ⟨m03, m14, m25⟩) (Quad.X ⟨m03, m14, m25⟩) = dx := by
    rw [fd_r43x6_sub_fast_eq, hdx, hxn1, hxn2]; rfl
  have e5 : fd_r43x6_sub_fast (Quad.T ⟨m03, m14, m25⟩) (Quad.Z ⟨m03, m14, m25⟩) = dy := by
    rw [fd_r43x6_sub_fast_eq, hdy, hyn1, hyn2]; rfl
  rw [not_and_not _ _ (fd_r43x6_is_nonzero.spec_01 _) (fd_r43x6_is_nonzero.spec_01 _)]
  simp only [fd_r43x6_ge_is_eq.spec, Quad.permute_2021, Quad.permute_0212]
  rw [e1, e2, e3, e4, e5]
  rfl

end Proof

end LeanMLIR.RIR.Firedancer.Avx512
