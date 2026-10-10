module

public import Boringssl.x25519_ge_frombytes_vartime

meta import Boringssl.x25519_ge_frombytes_vartime

namespace MLIR.Boringssl

/-- A block holding the `n` bytes `b`. -/
private def blk (n : Nat) (b : BitVec (8 * n)) : MemoryBlock :=
  .ofBytes n b

/-- Limbs' number. -/
private def natOf (l : Fin 5 → BitVec 64) : Nat :=
  (l 0).toNat + (l 1).toNat * 2 ^ 51 + (l 2).toNat * 2 ^ 102 + (l 3).toNat * 2 ^ 153 +
    (l 4).toNat * 2 ^ 204

private def p : Nat :=
  2 ^ 255 - 19

/-- `b ^ e % m` by squaring. -/
private def powMod (b e m : Nat) : Nat :=
  if e = 0 then 1 % m
  else
    let h := powMod (b * b % m) (e / 2) m
    if e % 2 = 0 then h else h * b % m
termination_by e
decreasing_by omega

/-- `d = -121665 / 121666`. -/
private def dNat : Nat :=
  (p - 121665) * powMod 121666 (p - 2) p % p

/-- `√-1`. -/
private def iNat : Nat :=
  powMod 2 ((p - 1) / 4) p

/-- The point `s` encodes, as `(x, y)` below `p`, by RFC 8032's recovery (any `y` below
`2²⁵⁵`, any sign of `x = 0`). -/
private def decodeNat (s : Nat) : Option (Nat × Nat) :=
  let y := s % 2 ^ 255 % p
  let u := (y * y + p - 1) % p
  let v := (dNat * y * y + 1) % p
  let x := u * powMod (u * v % p) ((p - 5) / 8) p % p
  let vxx := v * x * x % p
  let x? := if vxx = u then some x else if (vxx + u) % p = 0 then some (x * iNat % p) else none
  x?.map fun x => (if x % 2 = s / 2 ^ 255 then x else (p - x) % p, y)

/-- `h` (160 bytes) in block 1, `s` in block 2; the result and `h`'s `X, Y, Z, T` values. -/
private def run (s : BitVec 256) : Option (BitVec 32 × List Nat) :=
  let st : GlobalState := ⟨⟨3⟩, ⟨Std.ExtHashMap.ofList [(⟨1⟩, blk 160 0), (⟨2⟩, blk 32 s)]⟩⟩
  match
    x25519_ge_frombytes_vartime.call
      (x25519_ge_frombytes_vartime.args (.value ⟨⟨1⟩, 0⟩) (.value ⟨⟨2⟩, 0⟩)) st with
  | .value (.cons (.value r) .nil, s') =>
    let P := s'.mem.readP3 ⟨⟨1⟩, 0⟩
    some (r, [P.X, P.Y, P.Z, P.T].map fun l => natOf l % p)
  | _ => none

/-- The result `decodeNat` expects: `1` and `(x, y, 1, x y)`, or `0`. -/
private def expected (s : Nat) : BitVec 32 × Option (List Nat) :=
  match decodeNat s with
  | some (x, y) => (1, some [x, y, 1, x * y % p])
  | none => (0, none)

/-- Encodings: the base point and its negation, `y = 3`, `y = 1` with the sign set (`x = 0`),
`y = p + 3` (non-canonical), and `y = 2`, `y = 7` (no point). -/
private def bufs : List Nat :=
  [0x6666666666666666666666666666666666666666666666666666666666666658,
    0xe666666666666666666666666666666666666666666666666666666666666658, 3, 2 ^ 255 + 1, p + 3, 2, 7]

-- the result `decodeNat` expects, and the point's values on success
#guard
  bufs.all fun s =>
    match run (BitVec.ofNat 256 s), expected s with
    | some (r, vals), (r', some vals') => r == r' && vals == vals'
    | some (r, _), (r', none) => r == r'
    | none, _ => false

-- `decodeNat` fails exactly on `y = 2` and `y = 7`
#guard bufs.map (fun s => (decodeNat s).isSome) == [true, true, true, true, true, false, false]

end MLIR.Boringssl
