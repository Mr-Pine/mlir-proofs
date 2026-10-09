module

public import MLIR.Run.Tactic
public import Firedancer.Ref.Globals
public import Firedancer.R52x5.Common.Fe
public import Firedancer.R52x5.Common.QuadMem
public import Firedancer.R52x5.Mlir.fd_f25519_one
public import Firedancer.R52x5.Mlir.fd_f25519_d
public import Firedancer.R52x5.Mlir.fd_f25519_sqrtm1
public import Firedancer.R52x5.Mlir.fd_ed25519_order8_point_y0
public import Firedancer.R52x5.Mlir.fd_ed25519_order8_point_y1
public import Firedancer.R52x5.Mlir.fd_ed25519_base_point_wnaf_table
import Mathlib.Tactic.FinCases
import Mathlib.Data.Fintype.Basic

/-! The globals: their values, and the field elements and points read back from the block
`addressof` gives them. -/

namespace MLIR.Firedancer.R52x5

open Firedancer.Avx512 (Wwl wwl)

@[expose] public section

/-- The lanes of `fd_f25519_one`, 1. -/
def fd_f25519_one.vec : Wwl :=
  wwl 1 0 0 0 0 0 0 0

/-- The lanes of `fd_f25519_d`, `d = -121665/121666`. -/
def fd_f25519_d.vec : Wwl :=
  wwl 929955233495203 466365720129213 1662059464998953 2033849074728123 1442794654840575 0 0 0

/-- The lanes of `fd_f25519_sqrtm1`, `√-1`. -/
def fd_f25519_sqrtm1.vec : Wwl :=
  wwl 1718705420411056 234908883556509 2233514472574048 2117202627021982 765476049583133 0 0 0

/-- The lanes of `fd_ed25519_order8_point_y0`, the y-coordinate of an order-8 point. -/
def fd_ed25519_order8_point_y0.vec : Wwl :=
  wwl 2166873539340326 1778179147085316 1886209374839743 1223329526802818 105300633354275 0 0 0

/-- The lanes of `fd_ed25519_order8_point_y1`, the y-coordinate of the other order-8 points. -/
def fd_ed25519_order8_point_y1.vec : Wwl :=
  wwl 84926274344903 473620666599931 365590438845504 1028470286882429 2146499180330972 0 0 0

/-- `fd_ed25519_base_point_wnaf_table[j]`: entry `j` of the bits `addressof` stores. -/
noncomputable def fd_ed25519_base_point_wnaf_table.point (j : Nat) : Quad5 :=
  quad5At (Ty.flatBits fd_ed25519_base_point_wnaf_table.lit (w := 196608) (hw := rfl)) (1536 * j)

end

public theorem fd_f25519_one.value_eq (s : GlobalState) :
    fd_f25519_one.value s = .value (Ty.wrap fd_f25519_one.lit, s) :=
  GlobalInitializer.compute_value _ _ ⟨_, by with_unfolding_all rfl⟩

/-- `fd_f25519_one`'s lanes, at the block `addressof` stores them in. -/
public theorem fd_f25519_one.readVec {m : MemoryState} {p : Pointer}
    {hw : (Ty.array 1 (.struct [.vec 8 64])).width = 512}
    (h : m.readAt p 512 = Ty.flatBits fd_f25519_one.lit (hw := hw)) :
    m.readVec p = fd_f25519_one.vec := by
  simp only [MemoryState.readVec, h, extractVecElem_flatBits]
  decide

/-- `fd_f25519_one`'s limbs: the reference implementation's. -/
public theorem fd_f25519_one.limbs_eq : limbs fd_f25519_one.vec = Ref.fd_f25519_one.limbs := by
  funext i
  fin_cases i <;> rfl

public theorem fd_f25519_d.value_eq (s : GlobalState) :
    fd_f25519_d.value s = .value (Ty.wrap fd_f25519_d.lit, s) :=
  GlobalInitializer.compute_value _ _ ⟨_, by with_unfolding_all rfl⟩

/-- `fd_f25519_d`'s lanes, at the block `addressof` stores them in. -/
public theorem fd_f25519_d.readVec {m : MemoryState} {p : Pointer}
    {hw : (Ty.array 1 (.struct [.vec 8 64])).width = 512}
    (h : m.readAt p 512 = Ty.flatBits fd_f25519_d.lit (hw := hw)) :
    m.readVec p = fd_f25519_d.vec := by
  simp only [MemoryState.readVec, h, extractVecElem_flatBits]
  decide

/-- `fd_f25519_d`'s limbs: the reference implementation's. -/
public theorem fd_f25519_d.limbs_eq : limbs fd_f25519_d.vec = Ref.fd_f25519_d.limbs := by
  funext i
  fin_cases i <;> rfl

public theorem fd_f25519_sqrtm1.value_eq (s : GlobalState) :
    fd_f25519_sqrtm1.value s = .value (Ty.wrap fd_f25519_sqrtm1.lit, s) :=
  GlobalInitializer.compute_value _ _ ⟨_, by with_unfolding_all rfl⟩

/-- `fd_f25519_sqrtm1`'s lanes, at the block `addressof` stores them in. -/
public theorem fd_f25519_sqrtm1.readVec {m : MemoryState} {p : Pointer}
    {hw : (Ty.array 1 (.struct [.vec 8 64])).width = 512}
    (h : m.readAt p 512 = Ty.flatBits fd_f25519_sqrtm1.lit (hw := hw)) :
    m.readVec p = fd_f25519_sqrtm1.vec := by
  simp only [MemoryState.readVec, h, extractVecElem_flatBits]
  decide

/-- `fd_f25519_sqrtm1`'s limbs: the reference implementation's. -/
public theorem fd_f25519_sqrtm1.limbs_eq :
    limbs fd_f25519_sqrtm1.vec = Ref.fd_f25519_sqrtm1.limbs := by
  funext i
  fin_cases i <;> rfl

public theorem fd_ed25519_order8_point_y0.value_eq (s : GlobalState) :
    fd_ed25519_order8_point_y0.value s = .value (Ty.wrap fd_ed25519_order8_point_y0.lit, s) :=
  GlobalInitializer.compute_value _ _ ⟨_, by with_unfolding_all rfl⟩

/-- `fd_ed25519_order8_point_y0`'s lanes, at the block `addressof` stores them in. -/
public theorem fd_ed25519_order8_point_y0.readVec {m : MemoryState} {p : Pointer}
    {hw : (Ty.array 1 (.struct [.vec 8 64])).width = 512}
    (h : m.readAt p 512 = Ty.flatBits fd_ed25519_order8_point_y0.lit (hw := hw)) :
    m.readVec p = fd_ed25519_order8_point_y0.vec := by
  simp only [MemoryState.readVec, h, extractVecElem_flatBits]
  decide

/-- `fd_ed25519_order8_point_y0`'s limbs: the reference implementation's. -/
public theorem fd_ed25519_order8_point_y0.limbs_eq :
    limbs fd_ed25519_order8_point_y0.vec = Ref.fd_ed25519_order8_point_y0.limbs := by
  funext i
  fin_cases i <;> rfl

public theorem fd_ed25519_order8_point_y1.value_eq (s : GlobalState) :
    fd_ed25519_order8_point_y1.value s = .value (Ty.wrap fd_ed25519_order8_point_y1.lit, s) :=
  GlobalInitializer.compute_value _ _ ⟨_, by with_unfolding_all rfl⟩

/-- `fd_ed25519_order8_point_y1`'s lanes, at the block `addressof` stores them in. -/
public theorem fd_ed25519_order8_point_y1.readVec {m : MemoryState} {p : Pointer}
    {hw : (Ty.array 1 (.struct [.vec 8 64])).width = 512}
    (h : m.readAt p 512 = Ty.flatBits fd_ed25519_order8_point_y1.lit (hw := hw)) :
    m.readVec p = fd_ed25519_order8_point_y1.vec := by
  simp only [MemoryState.readVec, h, extractVecElem_flatBits]
  decide

/-- `fd_ed25519_order8_point_y1`'s limbs: the reference implementation's. -/
public theorem fd_ed25519_order8_point_y1.limbs_eq :
    limbs fd_ed25519_order8_point_y1.vec = Ref.fd_ed25519_order8_point_y1.limbs := by
  funext i
  fin_cases i <;> rfl

public theorem fd_ed25519_base_point_wnaf_table.value_eq (s : GlobalState) :
    fd_ed25519_base_point_wnaf_table.value s =
      .value (Ty.wrap fd_ed25519_base_point_wnaf_table.lit, s) :=
  GlobalInitializer.compute_value _ _ ⟨_, by with_unfolding_all rfl⟩

/-- Entry `j` of `fd_ed25519_base_point_wnaf_table`, at the block `addressof` stores it in. -/
public theorem fd_ed25519_base_point_wnaf_table.readQuad5 {m : MemoryState} {p : Pointer}
    (hf : Fits m p 196608) (ho : p.offset = 0)
    (h :
      m.readAt p 196608 =
        Ty.flatBits fd_ed25519_base_point_wnaf_table.lit (w := 196608) (hw := rfl))
    (hj : j < 128) :
    m.readQuad5 (p.add (BitVec.ofNat 64 (192 * j))) = fd_ed25519_base_point_wnaf_table.point j := by
  rw [MemoryState.readQuad5_add_of_readAt hf h
      (by
        rw [ho]; simp; omega)
      (by omega),
    show 8 * (192 * j) = 1536 * j by omega]
  rfl

end MLIR.Firedancer.R52x5
