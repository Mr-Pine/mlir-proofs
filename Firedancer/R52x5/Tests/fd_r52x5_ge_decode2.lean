module

public import Firedancer.R52x5.fd_r52x5_ge_decode2

meta import MLIR.Semantics.Func
meta import Firedancer.R52x5.fd_r52x5_ge_decode2

/-! `fd_r52x5_ge_decode2` run, with the lifted callees, on encodings that decode and that do not;
the stored points against `spec`'s and the curve points. -/

namespace MLIR.Firedancer.R52x5

section Tests

private def p : Nat :=
  2 ^ 255 - 19

/-- Block `k`, at offset 0. -/
private def ptr (k : Nat) : Pointer :=
  ⟨⟨k⟩, 0⟩

/-- `Pa0 … Pa4` in blocks `0 … 4`, `Pb0 … Pb4` in `6 … 10`, 32 bytes each, zeroed; the encodings
`ea` and `eb` in blocks `5` and `11`; then the globals. -/
private def state (ea eb : Nat) : GlobalState :=
  GlobalState.withGlobals fd_r52x5_ge_decode2.globals
    ⟨⟨12⟩,
      ⟨Std.ExtHashMap.ofList
          ((([0, 1, 2, 3, 4, 6, 7, 8, 9, 10].map fun k =>
              ((⟨k⟩ : BlockId), (.ofBytes 32 0 : MemoryBlock))) ++
            [(⟨5⟩, .ofBytes 32 (BitVec.ofNat 256 ea)),
              (⟨11⟩, .ofBytes 32 (BitVec.ofNat 256 eb))]))⟩⟩

/-- The QUAD in the five blocks from `k`. -/
private def quadAt (m : MemoryState) (k : Nat) : Quad5 :=
  ⟨m.readWv (ptr k), m.readWv (ptr (k + 1)), m.readWv (ptr (k + 2)), m.readWv (ptr (k + 3)),
    m.readWv (ptr (k + 4))⟩

/-- The return value and both QUADs, or `none` for UB / out of fuel. -/
private def run (ea eb : Nat) : Option (BitVec 32 × Quad5 × Quad5) :=
  match
    fd_r52x5_ge_decode2.eval 300
      (fd_r52x5_ge_decode2.args (.value (ptr 0)) (.value (ptr 1)) (.value (ptr 2)) (.value (ptr 3))
        (.value (ptr 4)) (.value (ptr 5)) (.value (ptr 6)) (.value (ptr 7)) (.value (ptr 8))
        (.value (ptr 9)) (.value (ptr 10)) (.value (ptr 11)))
      (state ea eb) with
  | .value (some (.cons (.value r) .nil), s) => some (r, quadAt s.mem 0, quadAt s.mem 6)
  | _ => none

/-- Coordinate `j` of `Q` mod `p`. -/
private def coord (Q : Quad5) (j : Nat) : Nat :=
  (Q.P0[j]!.toNat + 2 ^ 51 * Q.P1[j]!.toNat + 2 ^ 102 * Q.P2[j]!.toNat + 2 ^ 153 * Q.P3[j]!.toNat +
      2 ^ 204 * Q.P4[j]!.toNat) %
    p

private def eqQ (P Q : Quad5) : Bool :=
  P.P0 == Q.P0 && P.P1 == Q.P1 && P.P2 == Q.P2 && P.P3 == Q.P3 && P.P4 == Q.P4

/-- The encodings of the base point (`y = 4/5`, `x` even) and the identity, and a `y` naming no
point. -/
private def enc_B : Nat :=
  0x6666666666666666666666666666666666666666666666666666666666666658

private def enc_O : Nat :=
  1

private def enc_bad : Nat :=
  2

private def B_x : Nat :=
  15112221349535400772501151409588531511454012693041857206046113283949847762202

private def B_y : Nat :=
  0x6666666666666666666666666666666666666666666666666666666666666658

/-- Both decode: `0`, `spec`'s points, holding `(x, y, 1, x y)`. -/
private def decodes (ea eb x₁ y₁ x₂ y₂ : Nat) : Bool :=
  match run ea eb, fd_r52x5_ge_decode2.spec (BitVec.ofNat 256 ea) (BitVec.ofNat 256 eb) with
  | some (r, A, B), (r', some A', B') =>
    r == 0 && r' == 0 && eqQ A A' && eqQ B B' &&
      [coord A 0, coord A 1, coord A 2, coord A 3] == [x₁, y₁, 1, x₁ * y₁ % p] &&
      [coord B 0, coord B 1, coord B 2, coord B 3] == [x₂, y₂, 1, x₂ * y₂ % p]
  | _, _ => false

/-- A failure: `r`, `Pa` untouched (zero), `Pb` the neutral point, as `spec` says. -/
private def fails (ea eb : Nat) (r : BitVec 32) : Bool :=
  match run ea eb, fd_r52x5_ge_decode2.spec (BitVec.ofNat 256 ea) (BitVec.ofNat 256 eb) with
  | some (r', A, B), (r'', none, B') =>
    r' == r && r'' == r && eqQ A ⟨wl_zero, wl_zero, wl_zero, wl_zero, wl_zero⟩ && eqQ B quadZero &&
      eqQ B' quadZero
  | _, _ => false

#guard decodes enc_B enc_O B_x B_y 0 1

#guard decodes enc_O enc_B 0 1 B_x B_y

#guard fails enc_bad enc_B (-1)

#guard fails enc_B enc_bad (-2)

#guard fails enc_bad enc_bad (-1)

end Tests

end MLIR.Firedancer.R52x5
