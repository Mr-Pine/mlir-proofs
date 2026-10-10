module

public import MLIR.Run.Tactic
public import Sodium.Common.Sha512
public import Sodium.Mlir.crypto_hash_sha512_update

/-! What the pieces of `crypto_hash_sha512_update`'s proof share. -/

namespace MLIR.Sodium.crypto_hash_sha512_update

@[expose] public section

/-- `^bb0`'s constants the short copy (`^bb17 … ^bb31`, `^bb56`) reads. -/
abbrev ConstsShort (E : ⟪Γ⟫) : Prop :=
  E ⊨ [%1210 := 0#64, %1212 := 3#64, %1218 := 79#64, %1219 := 31#64, %1221 := 28#64, %1224 := 32#64,
    %1228 := 4#64, %1229 := 1#64, %1231 := 2#64, %1235 := 18446744073709551612#64, %1237 :=
    18446744073709551584#64, %1238 := 0#32]

/-- `^bb0`'s constants `^bb34 … ^bb56` read. -/
abbrev ConstsTail (E : ⟪Γ⟫) : Prop :=
  E ⊨ [%1210 := 0#64, %1211 := 64#64, %1212 := 3#64, %1216 := 80#64, %1217 := 124#64, %1218 :=
    79#64, %1220 := 96#64, %1223 := 16#64, %1224 := 32#64, %1225 := 48#64, %1226 := 112#64, %1228 :=
    4#64, %1229 := 1#64, %1231 := 2#64, %1233 := 15#64, %1234 := 12#64, %1235 :=
    18446744073709551612#64, %1236 := 704#64, %1238 := 0#32]

/-- `^bb0`'s constants `^bb33 … ^bb56` read. -/
abbrev ConstsBlocks (E : ⟪Γ⟫) : Prop :=
  E ⊨ [%1210 := 0#64, %1211 := 64#64, %1212 := 3#64, %1213 := 127#64, %1216 := 80#64, %1217 :=
    124#64, %1218 := 79#64, %1220 := 96#64, %1223 := 16#64, %1224 := 32#64, %1225 := 48#64, %1226 :=
    112#64, %1228 := 4#64, %1229 := 1#64, %1231 := 2#64, %1232 := 18446744073709551488#64, %1233 :=
    15#64, %1234 := 12#64, %1235 := 18446744073709551612#64, %1236 := 704#64, %1238 := 0#32]

/-- `^bb0`'s constants `^bb2 … ^bb56` read. -/
abbrev ConstsFill (E : ⟪Γ⟫) : Prop :=
  E ⊨ [%1210 := 0#64, %1211 := 64#64, %1212 := 3#64, %1213 := 127#64, %1216 := 80#64, %1217 :=
    124#64, %1218 := 79#64, %1219 := 31#64, %1220 := 96#64, %1221 := 28#64, %1222 := 224#64,
    %1223 := 16#64, %1224 := 32#64, %1225 := 48#64, %1226 := 112#64, %1227 := 252#64, %1228 := 4#64,
    %1229 := 1#64, %1230 := 18446744073709551491#64, %1231 := 2#64, %1232 :=
    18446744073709551488#64, %1233 := 15#64, %1234 := 12#64, %1235 := 18446744073709551612#64,
    %1236 := 704#64, %1238 := 0#32]

end

/-- A vector's lanes packed back: its bits. -/
public theorem packLanes_ofFn_extractVecElem {n : Nat} (x : BitVec (8 * n)) :
    BitVec.packLanes (Vector.ofFn fun j : Fin n => Ty.extractVecElem n 8 j x) = x := by
  apply BitVec.eq_of_getLsbD_eq
  intro k hk
  have h :=
    BitVec.extractLsb'_packLanes_of_lt (Vector.ofFn fun j : Fin n => Ty.extractVecElem n 8 j x)
      (s := k) (w := 1) (by omega) (by omega)
  have := congrArg (·.getLsbD 0) h
  simp only [BitVec.getLsbD_extractLsb', Nat.add_zero, Nat.lt_one_iff, decide_true, Bool.true_and,
    Vector.getElem_ofFn] at this
  rw [this, Ty.extractVecElem_eq, BitVec.getLsbD_extractLsb']
  simp only [show k % 8 < 8 by omega, decide_true, Bool.true_and]
  congr 1
  omega

end MLIR.Sodium.crypto_hash_sha512_update
