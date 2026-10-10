module

public import Boringssl.Common.Point

/-! Stores to the field elements of one point, sorted by offset: `simp only` with these and
`storeLimbs_storeLimbs_self` brings a point function's stores into its object's store order, the
last store to each field element kept. -/

namespace MLIR

@[expose] public section

namespace MemoryState

variable {m : MemoryState} {p : Pointer}

theorem storeLimbs_sort_40_0 (hp : p.offset.toNat + 120 ≤ 2 ^ 64) :
    (m.storeLimbs (p.add 40#64) A).storeLimbs p B = (m.storeLimbs p B).storeLimbs (p.add 40#64) A :=
  storeLimbs_comm_fe_X (a := 40) hp (by omega) (by omega)

theorem storeLimbs_sort_80_0 (hp : p.offset.toNat + 120 ≤ 2 ^ 64) :
    (m.storeLimbs (p.add 80#64) A).storeLimbs p B = (m.storeLimbs p B).storeLimbs (p.add 80#64) A :=
  storeLimbs_comm_fe_X (a := 80) hp (by omega) (by omega)

theorem storeLimbs_sort_80_40 (hp : p.offset.toNat + 120 ≤ 2 ^ 64) :
    (m.storeLimbs (p.add 80#64) A).storeLimbs (p.add 40#64) B =
      (m.storeLimbs (p.add 40#64) B).storeLimbs (p.add 80#64) A :=
  storeLimbs_comm_fe (a := 80) (b := 40) hp (by omega) (by omega) (by omega)

theorem storeLimbs_sort_120_0 (hp : p.offset.toNat + 160 ≤ 2 ^ 64) :
    (m.storeLimbs (p.add 120#64) A).storeLimbs p B =
      (m.storeLimbs p B).storeLimbs (p.add 120#64) A :=
  storeLimbs_comm_fe_X (a := 120) hp (by omega) (by omega)

theorem storeLimbs_sort_120_40 (hp : p.offset.toNat + 160 ≤ 2 ^ 64) :
    (m.storeLimbs (p.add 120#64) A).storeLimbs (p.add 40#64) B =
      (m.storeLimbs (p.add 40#64) B).storeLimbs (p.add 120#64) A :=
  storeLimbs_comm_fe (a := 120) (b := 40) hp (by omega) (by omega) (by omega)

theorem storeLimbs_sort_120_80 (hp : p.offset.toNat + 160 ≤ 2 ^ 64) :
    (m.storeLimbs (p.add 120#64) A).storeLimbs (p.add 80#64) B =
      (m.storeLimbs (p.add 80#64) B).storeLimbs (p.add 120#64) A :=
  storeLimbs_comm_fe (a := 120) (b := 80) hp (by omega) (by omega) (by omega)

end MemoryState

end

/-- Sort the stores to the point at `p`, `h : p.offset.toNat + 160 ≤ 2 ^ 64`, into its object's
store order, each field element's last store kept. -/
macro "sort_point_stores " h:term : tactic =>
  `(tactic|
    ( have hp160 : _ := $h
      have hp120 := Nat.le_trans (Nat.add_le_add_left (show 120 ≤ 160 by decide) _) hp160
      simp only [MemoryState.storeLimbs_sort_40_0 hp120, MemoryState.storeLimbs_sort_80_0 hp120,
        MemoryState.storeLimbs_sort_80_40 hp120, MemoryState.storeLimbs_sort_120_0 hp160,
        MemoryState.storeLimbs_sort_120_40 hp160, MemoryState.storeLimbs_sort_120_80 hp160,
        MemoryState.storeLimbs_storeLimbs_self]))

end MLIR
