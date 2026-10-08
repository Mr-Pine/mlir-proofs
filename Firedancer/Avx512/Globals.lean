module

public import SSA.Projects.RIR.Run.Tactic
public import Firedancer.Avx512.Common.Point
public import Firedancer.Avx512.Mlir.fd_ed25519_order8_point_y0
public import Firedancer.Avx512.Mlir.fd_ed25519_order8_point_y1
public import Firedancer.Avx512.Mlir.fd_ed25519_base_point_wnaf_table

/-! The globals: their values, and the field elements and points read back from the block
`addressof` gives them. -/

namespace LeanMLIR.RIR.Firedancer.Avx512

@[expose] public section

/-- The lanes of `fd_ed25519_order8_point_y0`, the y-coordinate of an order-8 point. -/
def fd_ed25519_order8_point_y0.vec : Wwl :=
  wwl 3034655877158 7251661554934 8531478563367 3751701540842 152657171260 51416324880 0 0

/-- The lanes of `fd_ed25519_order8_point_y1`, the y-coordinate of the other order-8 points. -/
def fd_ed25519_order8_point_y1.vec : Wwl :=
  wwl 5761437145031 1544431467273 264614458840 5044391481365 8643435850947 1048095302895 0 0

/-- The point at bit `o` of `b`: `P03, P14, P25` 512 bits apart. -/
def quadAt (b : BitVec n) (o : Nat) : Quad :=
  ⟨Vector.ofFn fun i => b.extractLsb' (o + 64 * i.val) 64,
    Vector.ofFn fun i => b.extractLsb' (o + 512 + 64 * i.val) 64,
    Vector.ofFn fun i => b.extractLsb' (o + 1024 + 64 * i.val) 64⟩

/-- `fd_ed25519_base_point_wnaf_table[j]`: entry `j` of the bits `addressof` stores. -/
noncomputable def fd_ed25519_base_point_wnaf_table.point (j : Nat) : Quad :=
  quadAt (Ty.flatBits fd_ed25519_base_point_wnaf_table.lit (w := 196608) (hw := rfl)) (1536 * j)

end

/-- Lane `k` of a field-element global's bits: lane `k` of its vector. -/
theorem extractVecElem_flatBits (lit : ⟦Ty.array 1 (.struct [.vec 8 64])⟧ᵣ)
    {hw : (Ty.array 1 (.struct [.vec 8 64])).width = 512} (k : Fin 8) :
    Ty.extractVecElem 8 64 k (Ty.flatBits lit (hw := hw)) = (lit[0] : Wwl)[k] := by
  have hs : (Ty.struct [Ty.vec 8 64]).stride = 512 := by decide
  have hw' : (Ty.struct [Ty.vec 8 64]).width = 512 := by decide
  have hk := k.isLt
  rw [Ty.extractVecElem_eq, Ty.flatBits_eq, BitVec.extractLsb'_cast,
    Ty.extractLsb'_flattenRaw_array (s := k.val * 64) (w := 64) lit (by rw [hs]; omega)
      (by rw [hs, hw']; omega)]
  have h1 : k.val * 64 / (Ty.struct [Ty.vec 8 64]).stride = 0 := by rw [hs]; omega
  have h2 : k.val * 64 % (Ty.struct [Ty.vec 8 64]).stride = k.val * 64 := by rw [hs]; omega
  simp only [h1, h2]
  rw [Ty.extractLsb'_flattenRaw_struct_singleton _
      (by rw [show (Ty.vec 8 64).width = 512 from rfl]; omega), Ty.flattenRaw_vec]
  exact BitVec.extractLsb'_packLanes _ _ k.isLt

public theorem fd_ed25519_order8_point_y0.value_eq (s : GlobalState) :
    fd_ed25519_order8_point_y0.value s = .value (Ty.wrap fd_ed25519_order8_point_y0.lit, s) :=
  GlobalInitializer.compute_value _ _ ⟨_, by with_unfolding_all rfl⟩

public theorem fd_ed25519_order8_point_y1.value_eq (s : GlobalState) :
    fd_ed25519_order8_point_y1.value s = .value (Ty.wrap fd_ed25519_order8_point_y1.lit, s) :=
  GlobalInitializer.compute_value _ _ ⟨_, by with_unfolding_all rfl⟩

public theorem fd_ed25519_base_point_wnaf_table.value_eq (s : GlobalState) :
    fd_ed25519_base_point_wnaf_table.value s =
      .value (Ty.wrap fd_ed25519_base_point_wnaf_table.lit, s) :=
  GlobalInitializer.compute_value _ _ ⟨_, by with_unfolding_all rfl⟩

/-- `fd_ed25519_order8_point_y0`'s lanes, at the block `addressof` stores them in. -/
public theorem fd_ed25519_order8_point_y0.readVec {m : MemoryState} {p : Pointer}
    {hw : (Ty.array 1 (.struct [.vec 8 64])).width = 512}
    (h : m.readAt p 512 = Ty.flatBits fd_ed25519_order8_point_y0.lit (hw := hw)) :
    m.readVec p = fd_ed25519_order8_point_y0.vec := by
  simp only [MemoryState.readVec, h, extractVecElem_flatBits]
  decide

/-- `fd_ed25519_order8_point_y1`'s lanes, at the block `addressof` stores them in. -/
public theorem fd_ed25519_order8_point_y1.readVec {m : MemoryState} {p : Pointer}
    {hw : (Ty.array 1 (.struct [.vec 8 64])).width = 512}
    (h : m.readAt p 512 = Ty.flatBits fd_ed25519_order8_point_y1.lit (hw := hw)) :
    m.readVec p = fd_ed25519_order8_point_y1.vec := by
  simp only [MemoryState.readVec, h, extractVecElem_flatBits]
  decide

end LeanMLIR.RIR.Firedancer.Avx512
