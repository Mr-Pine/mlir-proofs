module

public import SSA.Projects.RIR.Run.Tactic
public import Common.Limbs
public import Firedancer.Ref.Mlir.fd_f25519_zero
public import Firedancer.Ref.Mlir.fd_f25519_one
public import Firedancer.Ref.Mlir.fd_f25519_d
public import Firedancer.Ref.Mlir.fd_f25519_k
public import Firedancer.Ref.Mlir.fd_f25519_sqrtm1
public import Firedancer.Ref.Mlir.fd_ed25519_order8_point_y0
public import Firedancer.Ref.Mlir.fd_ed25519_order8_point_y1

/-! The field-element globals: their limbs, their initializers' values, and their limbs read back
from the block `addressof` gives them. -/

namespace LeanMLIR.RIR.Firedancer.Ref

@[expose] public section

/-- The limbs of `fd_f25519_zero`, 0. -/
def fd_f25519_zero.limbs : Fin 5 → BitVec 64 := fun i => #v[0#64, 0#64, 0#64, 0#64, 0#64][i]

/-- The limbs of `fd_f25519_one`, 1. -/
def fd_f25519_one.limbs : Fin 5 → BitVec 64 := fun i => #v[1#64, 0#64, 0#64, 0#64, 0#64][i]

/-- The limbs of `fd_f25519_d`, `d = -121665/121666`. -/
def fd_f25519_d.limbs : Fin 5 → BitVec 64 := fun i =>
  #v[929955233495203#64, 466365720129213#64, 1662059464998953#64, 2033849074728123#64,
      1442794654840575#64][i]

/-- The limbs of `fd_f25519_k`, `k = 2d`. -/
def fd_f25519_k.limbs : Fin 5 → BitVec 64 := fun i =>
  #v[1859910466990425#64, 932731440258426#64, 1072319116312658#64, 1815898335770999#64,
      633789495995903#64][i]

/-- The limbs of `fd_f25519_sqrtm1`, `√-1`. -/
def fd_f25519_sqrtm1.limbs : Fin 5 → BitVec 64 := fun i =>
  #v[1718705420411056#64, 234908883556509#64, 2233514472574048#64, 2117202627021982#64,
      765476049583133#64][i]

/-- The limbs of `fd_ed25519_order8_point_y0`, the y-coordinate of an order-8 point. -/
def fd_ed25519_order8_point_y0.limbs : Fin 5 → BitVec 64 := fun i =>
  #v[2166873539340326#64, 1778179147085316#64, 1886209374839743#64, 1223329526802818#64,
      105300633354275#64][i]

/-- The limbs of `fd_ed25519_order8_point_y1`, the y-coordinate of the other order-8 points. -/
def fd_ed25519_order8_point_y1.limbs : Fin 5 → BitVec 64 := fun i =>
  #v[84926274344903#64, 473620666599931#64, 365590438845504#64, 1028470286882429#64,
      2146499180330972#64][i]

end

public theorem fd_f25519_zero.value_eq (s : GlobalState) :
    fd_f25519_zero.value s = .value (Ty.wrap fd_f25519_zero.lit, s) :=
  GlobalInitializer.compute_value _ _ ⟨_, by with_unfolding_all rfl⟩

/-- `fd_f25519_zero`'s limbs, at the block `addressof` stores them in. -/
public theorem fd_f25519_zero.readLimbs {m : MemoryState} {p : Pointer}
    {hw : (Ty.array 1 (.struct [.array 5 (.bv 64)])).width = 320} (hf : Fits m p 320)
    (ho : p.offset = 0) (h : m.readAt p 320 = Ty.flatBits fd_f25519_zero.lit (hw := hw)) :
    m.readLimbs p = fd_f25519_zero.limbs := by
  rw [MemoryState.readLimbs_of_readAt_flattenRaw hf ho h]
  funext i
  fin_cases i <;> rfl

public theorem fd_f25519_one.value_eq (s : GlobalState) :
    fd_f25519_one.value s = .value (Ty.wrap fd_f25519_one.lit, s) :=
  GlobalInitializer.compute_value _ _ ⟨_, by with_unfolding_all rfl⟩

/-- `fd_f25519_one`'s limbs, at the block `addressof` stores them in. -/
public theorem fd_f25519_one.readLimbs {m : MemoryState} {p : Pointer}
    {hw : (Ty.array 1 (.struct [.array 5 (.bv 64)])).width = 320} (hf : Fits m p 320)
    (ho : p.offset = 0) (h : m.readAt p 320 = Ty.flatBits fd_f25519_one.lit (hw := hw)) :
    m.readLimbs p = fd_f25519_one.limbs := by
  rw [MemoryState.readLimbs_of_readAt_flattenRaw hf ho h]
  funext i
  fin_cases i <;> rfl

public theorem fd_f25519_d.value_eq (s : GlobalState) :
    fd_f25519_d.value s = .value (Ty.wrap fd_f25519_d.lit, s) :=
  GlobalInitializer.compute_value _ _ ⟨_, by with_unfolding_all rfl⟩

/-- `fd_f25519_d`'s limbs, at the block `addressof` stores them in. -/
public theorem fd_f25519_d.readLimbs {m : MemoryState} {p : Pointer}
    {hw : (Ty.array 1 (.struct [.array 5 (.bv 64)])).width = 320} (hf : Fits m p 320)
    (ho : p.offset = 0) (h : m.readAt p 320 = Ty.flatBits fd_f25519_d.lit (hw := hw)) :
    m.readLimbs p = fd_f25519_d.limbs := by
  rw [MemoryState.readLimbs_of_readAt_flattenRaw hf ho h]
  funext i
  fin_cases i <;> rfl

public theorem fd_f25519_k.value_eq (s : GlobalState) :
    fd_f25519_k.value s = .value (Ty.wrap fd_f25519_k.lit, s) :=
  GlobalInitializer.compute_value _ _ ⟨_, by with_unfolding_all rfl⟩

/-- `fd_f25519_k`'s limbs, at the block `addressof` stores them in. -/
public theorem fd_f25519_k.readLimbs {m : MemoryState} {p : Pointer}
    {hw : (Ty.array 1 (.struct [.array 5 (.bv 64)])).width = 320} (hf : Fits m p 320)
    (ho : p.offset = 0) (h : m.readAt p 320 = Ty.flatBits fd_f25519_k.lit (hw := hw)) :
    m.readLimbs p = fd_f25519_k.limbs := by
  rw [MemoryState.readLimbs_of_readAt_flattenRaw hf ho h]
  funext i
  fin_cases i <;> rfl

public theorem fd_f25519_sqrtm1.value_eq (s : GlobalState) :
    fd_f25519_sqrtm1.value s = .value (Ty.wrap fd_f25519_sqrtm1.lit, s) :=
  GlobalInitializer.compute_value _ _ ⟨_, by with_unfolding_all rfl⟩

/-- `fd_f25519_sqrtm1`'s limbs, at the block `addressof` stores them in. -/
public theorem fd_f25519_sqrtm1.readLimbs {m : MemoryState} {p : Pointer}
    {hw : (Ty.array 1 (.struct [.array 5 (.bv 64)])).width = 320} (hf : Fits m p 320)
    (ho : p.offset = 0) (h : m.readAt p 320 = Ty.flatBits fd_f25519_sqrtm1.lit (hw := hw)) :
    m.readLimbs p = fd_f25519_sqrtm1.limbs := by
  rw [MemoryState.readLimbs_of_readAt_flattenRaw hf ho h]
  funext i
  fin_cases i <;> rfl

public theorem fd_ed25519_order8_point_y0.value_eq (s : GlobalState) :
    fd_ed25519_order8_point_y0.value s = .value (Ty.wrap fd_ed25519_order8_point_y0.lit, s) :=
  GlobalInitializer.compute_value _ _ ⟨_, by with_unfolding_all rfl⟩

/-- `fd_ed25519_order8_point_y0`'s limbs, at the block `addressof` stores them in. -/
public theorem fd_ed25519_order8_point_y0.readLimbs {m : MemoryState} {p : Pointer}
    {hw : (Ty.array 1 (.struct [.array 5 (.bv 64)])).width = 320} (hf : Fits m p 320)
    (ho : p.offset = 0)
    (h : m.readAt p 320 = Ty.flatBits fd_ed25519_order8_point_y0.lit (hw := hw)) :
    m.readLimbs p = fd_ed25519_order8_point_y0.limbs := by
  rw [MemoryState.readLimbs_of_readAt_flattenRaw hf ho h]
  funext i
  fin_cases i <;> rfl

public theorem fd_ed25519_order8_point_y1.value_eq (s : GlobalState) :
    fd_ed25519_order8_point_y1.value s = .value (Ty.wrap fd_ed25519_order8_point_y1.lit, s) :=
  GlobalInitializer.compute_value _ _ ⟨_, by with_unfolding_all rfl⟩

/-- `fd_ed25519_order8_point_y1`'s limbs, at the block `addressof` stores them in. -/
public theorem fd_ed25519_order8_point_y1.readLimbs {m : MemoryState} {p : Pointer}
    {hw : (Ty.array 1 (.struct [.array 5 (.bv 64)])).width = 320} (hf : Fits m p 320)
    (ho : p.offset = 0)
    (h : m.readAt p 320 = Ty.flatBits fd_ed25519_order8_point_y1.lit (hw := hw)) :
    m.readLimbs p = fd_ed25519_order8_point_y1.limbs := by
  rw [MemoryState.readLimbs_of_readAt_flattenRaw hf ho h]
  funext i
  fin_cases i <;> rfl

end LeanMLIR.RIR.Firedancer.Ref
