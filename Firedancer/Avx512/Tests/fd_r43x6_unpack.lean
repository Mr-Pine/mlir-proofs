module

public import Firedancer.Avx512.fd_r43x6_unpack

meta import Firedancer.Avx512.fd_r43x6_unpack

namespace LeanMLIR.RIR.Firedancer.Avx512

private def state : GlobalState :=
  ⟨⟨1⟩, ⟨∅⟩⟩

/-- The returned lanes if they are `spec u`, else `none`. -/
private def out (u : Wv) : Option Wwl :=
  match fd_r43x6_unpack.eval 1 (fd_r43x6_unpack.args (Ty.wrap (t := .vec 4 64) u)) state with
  | .value (some (.cons v .nil), _) =>
    if v == Ty.wrap (fd_r43x6_unpack.spec u) then some (fd_r43x6_unpack.spec u) else none
  | _ => none

/-- The value of six radix-`2^43` limbs. -/
private def value (x : Wwl) : Nat :=
  (List.range 6).foldl (fun acc i => acc + x[i]!.toNat * 2 ^ (43 * i)) 0

/-- The value of four 64-bit lanes. -/
private def wvValue (u : Wv) : Nat :=
  (List.range 4).foldl (fun acc i => acc + u[i]!.toNat * 2 ^ (64 * i)) 0

-- the limbs hold the same number, below `2^43` each (lane 5 below `2^41`), lanes 6 and 7 zero
private def check (u : Wv) : Bool :=
  match out u with
  | some x => value x == wvValue u && x[6] == 0 && x[7] == 0 &&
      (List.range 5).all (fun i => x[i]!.toNat < 2 ^ 43) && x[5].toNat < 2 ^ 41
  | none => false

#guard check #v[1, 2, 3, 4]

#guard check #v[-1, -1, -1, -1]

#guard check #v[0x0123456789abcdef, 0xfedcba9876543210, 0x0f0f0f0f0f0f0f0f, 0x7fffffffffffffff]

#guard check #v[0, 0, 0, 0]

end LeanMLIR.RIR.Firedancer.Avx512
