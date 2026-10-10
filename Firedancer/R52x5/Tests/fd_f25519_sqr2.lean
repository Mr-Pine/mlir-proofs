module

public import Firedancer.R52x5.fd_f25519_sqr2

meta import Firedancer.R52x5.fd_f25519_sqr2

namespace MLIR.Firedancer.R52x5

/-- Block `k`, offset 0. -/
private def ptr (k : Nat) : Pointer :=
  ⟨⟨k⟩, 0⟩

/-- Pack eight 64-bit lanes, lane 0 lowest. -/
private def pack (l : List Nat) : BitVec 512 :=
  l.foldr (fun x acc => acc <<< 64 ||| BitVec.ofNat 512 x) 0

/-- Four 64-byte blocks `0 … 3`, block `k` holding `pack [k + 1, …, k + 5]`. -/
private def state : GlobalState :=
  ⟨⟨4⟩,
    ⟨Std.ExtHashMap.ofList
        ((List.range 4).map fun k => (⟨k⟩, .ofBytes 64 (pack ((List.range 5).map (· + k + 1)))))⟩⟩

/-- `r1` and `r2` hold the squares, the second of its input after the first store. -/
private def check (ks : List Nat) : Bool :=
  let m := state.mem
  let p k := ptr ks[k]!
  let m1 := m.storeVec (p 0) (fd_f25519_sqr.spec (m.readVec (p 1)))
  match
    fd_f25519_sqr2.eval 1
      (fd_f25519_sqr2.args (.value (p 0)) (.value (p 1)) (.value (p 2)) (.value (p 3))) state with
  | .value (some .nil, s') =>
    s'.mem.readVec (p 0) == fd_f25519_sqr.spec (m.readVec (p 1)) &&
      s'.mem.readVec (p 2) == fd_f25519_sqr.spec (m1.readVec (p 3))
  | _ => false

#guard check [0, 1, 2, 3]

-- outputs over inputs
#guard check [1, 1, 3, 3]

-- `a2 = r1`, outside `call_eq`: the second square reads the first
#guard check [0, 1, 2, 0]

end MLIR.Firedancer.R52x5
