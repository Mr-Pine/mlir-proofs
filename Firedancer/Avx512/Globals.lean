module

public import MLIR.Run.Tactic
public import Firedancer.Avx512.Common.Point
public import Firedancer.Avx512.Mlir.fd_ed25519_order8_point_y0
public import Firedancer.Avx512.Mlir.fd_ed25519_order8_point_y1
public import Firedancer.Avx512.Mlir.fd_ed25519_base_point_wnaf_table

/-! The globals: their values, and the field elements and points read back from the block
`addressof` gives them. -/

namespace MLIR.Firedancer.Avx512

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

end MLIR.Firedancer.Avx512
