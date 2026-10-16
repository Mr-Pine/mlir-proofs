module

/-! Keccak-f[1600] from FIPS 202 §3 (θ ρ π χ ι, Algorithms 1-7), written from the standard, not
from any implementation. Lane `(x, y)` of the state is the 64-bit word `A[x + 5 y]`, its bit `z`
the state bit `A[x, y, z] = S[64 (5 y + x) + z]` (§3.1.2); with the bit-to-byte order of
Appendix B.1 that is the little-endian word at byte offset `8 (5 y + x)` of the 200-byte state. -/

namespace MLIR.Firedancer.Math.KeccakF

@[expose] public section

/-- The state, 25 lanes of `w = 64` bits, lane `(x, y)` at index `x + 5 y`. -/
abbrev State := Vector (BitVec 64) 25

/-- Lane `(x, y)`. -/
def lane (A : State) (x y : Fin 5) : BitVec 64 :=
  A[x.val + 5 * y.val]

/-- The state whose lane `(x, y)` is `f x y`. -/
def ofLanes (f : Fin 5 → Fin 5 → BitVec 64) : State :=
  Vector.ofFn fun i : Fin 25 => f ⟨i.val % 5, Nat.mod_lt _ (by decide)⟩ ⟨i.val / 5, by omega⟩

/-- θ (Algorithm 1): `A′[x, y] = A[x, y] ⊕ C[x - 1] ⊕ rot(C[x + 1], 1)`, `C[x]` the column parity. -/
def θ (A : State) : State :=
  let C : Fin 5 → BitVec 64 := fun x =>
    lane A x 0 ^^^ lane A x 1 ^^^ lane A x 2 ^^^ lane A x 3 ^^^ lane A x 4
  let D : Fin 5 → BitVec 64 := fun x => C (x - 1) ^^^ (C (x + 1)).rotateLeft 1
  ofLanes fun x y => lane A x y ^^^ D x

/-- The ρ offsets (Algorithm 2): from `(x, y) = (1, 0)`, step `t` rotates lane `(x, y)` by
`(t + 1)(t + 2)/2` and moves to `(y, (2 x + 3 y) mod 5)`. -/
def ρOffsets : List ((Fin 5 × Fin 5) × Nat) :=
  ((List.range 24).foldl
    (fun (acc : List ((Fin 5 × Fin 5) × Nat) × Fin 5 × Fin 5) t =>
      let (l, x, y) := acc
      (l ++ [((x, y), (t + 1) * (t + 2) / 2)], y, 2 * x + 3 * y))
    ([], 1, 0)).1

/-- ρ (Algorithm 2): lane `(0, 0)` unchanged, the others rotated by their offset mod 64
(`A′[x, y, z] = A[x, y, (z - off) mod w]`, a left rotation). -/
def ρ (A : State) : State :=
  ofLanes fun x y =>
    match ρOffsets.lookup (x, y) with
    | some off => (lane A x y).rotateLeft (off % 64)
    | none => lane A x y

/-- π (Algorithm 3): `A′[x, y] = A[(x + 3 y) mod 5, x]`. -/
def π (A : State) : State :=
  ofLanes fun x y => lane A (x + 3 * y) x

/-- χ (Algorithm 4): `A′[x, y] = A[x, y] ⊕ ((A[x + 1, y] ⊕ 1) · A[x + 2, y])`. -/
def χ (A : State) : State :=
  ofLanes fun x y => lane A x y ^^^ (~~~(lane A (x + 1) y) &&& lane A (x + 2) y)

/-- `rc(t)` (Algorithm 5): bit `R[0]` after `t mod 255` LFSR steps from `R = 10000000`. -/
def rc (t : Nat) : Bool :=
  -- `R[i]` is bit `i`; a step is `R ← 0 ‖ R; R[0,4,5,6] ⊕= R[8]; R ← Trunc₈(R)`
  if t % 255 = 0 then true
  else
    let R := (List.range (t % 255)).foldl
      (fun (R : BitVec 8) _ =>
        let R : BitVec 9 := R.setWidth 9 <<< 1
        let r8 := R.getLsbD 8
        let R := if r8 then R ^^^ 0b001110001#9 else R
        R.setWidth 8)
      0b00000001#8
    R.getLsbD 0

/-- `RC` of round `i_r` (Algorithm 6): bit `2^j - 1` is `rc(j + 7 i_r)` for `j ≤ ℓ = 6`. -/
def RC (ir : Nat) : BitVec 64 :=
  (List.range 7).foldl
    (fun (acc : BitVec 64) j => if rc (j + 7 * ir) then acc ||| 1#64 <<< (2 ^ j - 1) else acc)
    0#64

/-- ι (Algorithm 6): lane `(0, 0)` xored with `RC(i_r)`. -/
def ι (A : State) (ir : Nat) : State :=
  ofLanes fun x y => if x = 0 ∧ y = 0 then lane A x y ^^^ RC ir else lane A x y

/-- `Rnd(A, i_r) = ι(χ(π(ρ(θ(A)))), i_r)` (§3.3). -/
def Rnd (A : State) (ir : Nat) : State :=
  ι (χ (π (ρ (θ A)))) ir

/-- Keccak-f[1600] = Keccak-p[1600, 24] (§3.4, Algorithm 7): rounds `i_r = 0, …, 23`. -/
def keccakF (A : State) : State :=
  (List.range 24).foldl Rnd A

end

end MLIR.Firedancer.Math.KeccakF
