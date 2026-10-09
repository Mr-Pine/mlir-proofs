module

public import Firedancer.R52x5.fd_f25519_mul2

meta import Firedancer.R52x5.fd_f25519_mul2

namespace MLIR.Firedancer.R52x5

/-- Block `k`, offset 0. -/
private def ptr (k : Nat) : Pointer :=
  ⟨⟨k⟩, 0⟩

/-- Pack eight 64-bit lanes, lane 0 lowest. -/
private def pack (l : List Nat) : BitVec 512 :=
  l.foldr (fun x acc => acc <<< 64 ||| BitVec.ofNat 512 x) 0

/-- Six 64-byte blocks `0 … 5`, block `k` holding `pack [k + 1, …, k + 5]`. -/
private def state : GlobalState :=
  ⟨⟨6⟩,
    ⟨Std.ExtHashMap.ofList
        ((List.range 6).map fun k => (⟨k⟩, ⟨64, pack ((List.range 5).map (· + k + 1))⟩))⟩⟩

/-- `fd_f25519_mul2(r1, a1, b1, r2, a2, b2)` on blocks `[r1, a1, b1, r2, a2, b2]`: the state after,
or `none` for UB. -/
private def run (ks : List Nat) : Option GlobalState :=
  match
    fd_f25519_mul2.eval 1
      (fd_f25519_mul2.args (.value (ptr ks[0]!)) (.value (ptr ks[1]!)) (.value (ptr ks[2]!))
        (.value (ptr ks[3]!)) (.value (ptr ks[4]!)) (.value (ptr ks[5]!)))
      state with
  | .value (some .nil, s') => some s'
  | _ => none

/-- `r1` and `r2` hold the products, the second of its inputs after the first store. -/
private def check (ks : List Nat) : Bool :=
  let m := state.mem
  let p k := ptr ks[k]!
  let m1 := m.storeVec (p 0) (fd_f25519_mul.spec (m.readVec (p 1)) (m.readVec (p 2)))
  match run ks with
  | some s' =>
    s'.mem.readVec (p 0) == fd_f25519_mul.spec (m.readVec (p 1)) (m.readVec (p 2)) &&
      s'.mem.readVec (p 3) == fd_f25519_mul.spec (m1.readVec (p 4)) (m1.readVec (p 5))
  | none => false

#guard check [0, 1, 2, 3, 4, 5]

-- outputs over inputs: `r1 = a1`, `r2 = b2`
#guard check [1, 1, 2, 5, 4, 5]

-- `a2 = r1`, outside `call_eq`: the second product reads the first
#guard check [0, 1, 2, 3, 0, 5]

end MLIR.Firedancer.R52x5
