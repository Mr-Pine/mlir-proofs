module

public import Firedancer.Avx512.Common.Wwl

/-! `fd_ed25519_lane_fe_t` and the field operations of `fd_ed25519_lane.h`, as functions: lane `j`
of every vector is signature `j`'s element. -/

namespace MLIR.Firedancer.Lane

open Firedancer.Avx512

@[expose] public section

/-- `fd_ed25519_lane_fe_t`: lane `j` of `li` is limb `i` (radix `2^51`) of lane `j`'s element. -/
structure Fe where
  l0 : Wwl
  l1 : Wwl
  l2 : Wwl
  l3 : Wwl
  l4 : Wwl

namespace Fe

/-- `limb[i]`. -/
def limb (a : Fe) (i : Fin 5) : Wwl :=
  #v[a.l0, a.l1, a.l2, a.l3, a.l4][i]

/-- Lane `j`'s limbs. -/
def lane (a : Fe) (j : Fin 8) : Fin 5 → BitVec 64 := fun i => (a.limb i)[j]

/-- Every limb `f`. -/
def map (f : Wwl → Wwl) (a : Fe) : Fe :=
  ⟨f a.l0, f a.l1, f a.l2, f a.l3, f a.l4⟩

/-- Limbwise `f`. -/
def zipWith (f : Wwl → Wwl → Wwl) (a b : Fe) : Fe :=
  ⟨f a.l0 b.l0, f a.l1 b.l1, f a.l2 b.l2, f a.l3 b.l3, f a.l4 b.l4⟩

/-- `x` in limb 0 of every lane, `0` above: the broadcast small constant. -/
def small (x : BitVec 64) : Fe :=
  ⟨wwl_bcast x, wwl_zero, wwl_zero, wwl_zero, wwl_zero⟩

/-- All limbs zero. -/
def zero : Fe :=
  small 0

/-- `1` in every lane. -/
def one : Fe :=
  small 1

/-- The broadcast limbs `l0, l, l, l, l`. -/
def bcast2 (l0 l : BitVec 64) : Fe :=
  ⟨wwl_bcast l0, wwl_bcast l, wwl_bcast l, wwl_bcast l, wwl_bcast l⟩

end Fe

/-- `FD_ED25519_LANE_MASK`. -/
abbrev mask51 : BitVec 64 :=
  0x7FFFFFFFFFFFF

/-- `2p` limbwise: `FD_ED25519_LANE_2P0`, `FD_ED25519_LANE_2P`. -/
def twoP : Fe :=
  Fe.bcast2 (2 ^ 52 - 38) (2 ^ 52 - 2)

/-- `2^k p` limbwise: `FD_ED25519_LANE_BIGP0(k)`, `FD_ED25519_LANE_BIGP(k)`. -/
def bigP (k : Nat) : Fe :=
  Fe.bcast2 ((2 ^ 51 - 19) <<< k) ((2 ^ 51 - 1) <<< k)

/-- `fd_ed25519_lane_carry`. -/
def carry (r : Fe) : Fe :=
  let mask := wwl_bcast mask51
  let c0 := wwl_shru r.l0 51
  let c1 := wwl_shru r.l1 51
  let c2 := wwl_shru r.l2 51
  let c3 := wwl_shru r.l3 51
  let c4 := wwl_shru r.l4 51
  ⟨wwl_madd52lo (wwl_and r.l0 mask) c4 (wwl_bcast 19), wwl_add (wwl_and r.l1 mask) c0,
    wwl_add (wwl_and r.l2 mask) c1, wwl_add (wwl_and r.l3 mask) c2,
    wwl_add (wwl_and r.l4 mask) c3⟩

/-- `fd_ed25519_lane_add_raw`. -/
def addRaw (a b : Fe) : Fe :=
  Fe.zipWith wwl_add a b

/-- `a + c - b`, limbwise: the raw subtractions with offset `c`. -/
def subOff (c a b : Fe) : Fe :=
  Fe.zipWith wwl_sub (Fe.zipWith wwl_add a c) b

/-- `fd_ed25519_lane_sub_raw`: `a + 2p - b`. -/
def subRaw (a b : Fe) : Fe :=
  subOff twoP a b

/-- `fd_ed25519_lane_neg`: `2p - a`. -/
def neg (a : Fe) : Fe :=
  Fe.zipWith wwl_sub twoP a

/-- `fd_ed25519_lane_add`. -/
def add (a b : Fe) : Fe :=
  carry (addRaw a b)

/-- `fd_ed25519_lane_sub`: `a + 4p - b`, carried. -/
def sub (a b : Fe) : Fe :=
  carry (subOff (Fe.bcast2 (2 * (2 ^ 52 - 38)) (2 * (2 ^ 52 - 2))) a b)

/-- `fd_ed25519_lane_sub_big`: `a + 2^k p - b`. -/
def subBig (a b : Fe) (k : Nat) : Fe :=
  subOff (bigP k) a b

/-- `fd_ed25519_lane_fold`: degrees `5 … 9` folded by `19`, carried when `c`. -/
def fold (r0 r1 r2 r3 r4 r5 r6 r7 r8 r9 : Wwl) (c : Bool) : Fe :=
  let k19 := wwl_bcast 19
  let r : Fe := ⟨wwl_add r0 (wwl_mul r5 k19), wwl_add r1 (wwl_mul r6 k19),
    wwl_add r2 (wwl_mul r7 k19), wwl_add r3 (wwl_mul r8 k19), wwl_add r4 (wwl_mul r9 k19)⟩
  if c then carry r else r

/-- `x + x`. -/
abbrev dbl2 (x : Wwl) : Wwl :=
  wwl_add x x

/-- `fd_ed25519_lane_mul_`: one `madd52` chain per degree, high halves of the degree below doubled. -/
def mul (a b : Fe) (c : Bool := true) : Fe :=
  let z := wwl_zero
  let a0 := a.l0; let a1 := a.l1; let a2 := a.l2; let a3 := a.l3; let a4 := a.l4
  let b0 := b.l0; let b1 := b.l1; let b2 := b.l2; let b3 := b.l3; let b4 := b.l4
  let r0 := wwl_madd52lo z a0 b0
  let r1 := dbl2 (wwl_madd52hi z a0 b0)
  let r1 := wwl_madd52lo (wwl_madd52lo r1 a0 b1) a1 b0
  let r2 := dbl2 (wwl_madd52hi (wwl_madd52hi z a0 b1) a1 b0)
  let r2 := wwl_madd52lo (wwl_madd52lo (wwl_madd52lo r2 a0 b2) a1 b1) a2 b0
  let r3 := dbl2 (wwl_madd52hi (wwl_madd52hi (wwl_madd52hi z a0 b2) a1 b1) a2 b0)
  let r3 := wwl_madd52lo (wwl_madd52lo (wwl_madd52lo (wwl_madd52lo r3 a0 b3) a1 b2) a2 b1) a3 b0
  let r4 := dbl2 (wwl_madd52hi (wwl_madd52hi (wwl_madd52hi (wwl_madd52hi z a0 b3) a1 b2) a2 b1) a3 b0)
  let r4 := wwl_madd52lo (wwl_madd52lo (wwl_madd52lo (wwl_madd52lo (wwl_madd52lo r4 a0 b4) a1 b3)
    a2 b2) a3 b1) a4 b0
  let r5 := dbl2 (wwl_madd52hi (wwl_madd52hi (wwl_madd52hi (wwl_madd52hi (wwl_madd52hi z a0 b4)
    a1 b3) a2 b2) a3 b1) a4 b0)
  let r5 := wwl_madd52lo (wwl_madd52lo (wwl_madd52lo (wwl_madd52lo r5 a1 b4) a2 b3) a3 b2) a4 b1
  let r6 := dbl2 (wwl_madd52hi (wwl_madd52hi (wwl_madd52hi (wwl_madd52hi z a1 b4) a2 b3) a3 b2) a4 b1)
  let r6 := wwl_madd52lo (wwl_madd52lo (wwl_madd52lo r6 a2 b4) a3 b3) a4 b2
  let r7 := dbl2 (wwl_madd52hi (wwl_madd52hi (wwl_madd52hi z a2 b4) a3 b3) a4 b2)
  let r7 := wwl_madd52lo (wwl_madd52lo r7 a3 b4) a4 b3
  let r8 := dbl2 (wwl_madd52hi (wwl_madd52hi z a3 b4) a4 b3)
  let r8 := wwl_madd52lo r8 a4 b4
  let r9 := dbl2 (wwl_madd52hi z a4 b4)
  fold r0 r1 r2 r3 r4 r5 r6 r7 r8 r9 c

/-- `fd_ed25519_lane_sqr_`: off-diagonal halves doubled, then the diagonal ones. -/
def sqr (a : Fe) (c : Bool := true) : Fe :=
  let z := wwl_zero
  let a0 := a.l0; let a1 := a.l1; let a2 := a.l2; let a3 := a.l3; let a4 := a.l4
  let r0 := wwl_madd52lo z a0 a0
  let r1 := wwl_madd52hi z a0 a0
  let r1 := dbl2 (wwl_madd52lo r1 a0 a1)
  let r2 := dbl2 (wwl_madd52hi z a0 a1)
  let r2 := dbl2 (wwl_madd52lo r2 a0 a2)
  let r2 := wwl_madd52lo r2 a1 a1
  let r3 := dbl2 (wwl_madd52hi z a0 a2)
  let r3 := wwl_madd52hi r3 a1 a1
  let r3 := dbl2 (wwl_madd52lo (wwl_madd52lo r3 a0 a3) a1 a2)
  let r4 := dbl2 (wwl_madd52hi (wwl_madd52hi z a0 a3) a1 a2)
  let r4 := dbl2 (wwl_madd52lo (wwl_madd52lo r4 a0 a4) a1 a3)
  let r4 := wwl_madd52lo r4 a2 a2
  let r5 := dbl2 (wwl_madd52hi (wwl_madd52hi z a0 a4) a1 a3)
  let r5 := wwl_madd52hi r5 a2 a2
  let r5 := dbl2 (wwl_madd52lo (wwl_madd52lo r5 a1 a4) a2 a3)
  let r6 := dbl2 (wwl_madd52hi (wwl_madd52hi z a1 a4) a2 a3)
  let r6 := dbl2 (wwl_madd52lo r6 a2 a4)
  let r6 := wwl_madd52lo r6 a3 a3
  let r7 := dbl2 (wwl_madd52hi z a2 a4)
  let r7 := wwl_madd52hi r7 a3 a3
  let r7 := dbl2 (wwl_madd52lo r7 a3 a4)
  let r8 := dbl2 (dbl2 (wwl_madd52hi z a3 a4))
  let r8 := wwl_madd52lo r8 a4 a4
  let r9 := dbl2 (wwl_madd52hi z a4 a4)
  fold r0 r1 r2 r3 r4 r5 r6 r7 r8 r9 c

/-- `fd_ed25519_lane_normalize`: two sequential carry passes, the top carry folded by `19`. -/
def normalize (a : Fe) : Fe :=
  let mask := wwl_bcast mask51
  let pass (a : Fe) : Fe :=
    let l1 := wwl_add a.l1 (wwl_shru a.l0 51)
    let l0 := wwl_and a.l0 mask
    let l2 := wwl_add a.l2 (wwl_shru l1 51)
    let l1 := wwl_and l1 mask
    let l3 := wwl_add a.l3 (wwl_shru l2 51)
    let l2 := wwl_and l2 mask
    let l4 := wwl_add a.l4 (wwl_shru l3 51)
    let l3 := wwl_and l3 mask
    let l0 := wwl_add l0 (wwl_mul (wwl_shru l4 51) (wwl_bcast 19))
    let l4 := wwl_and l4 mask
    ⟨l0, l1, l2, l3, l4⟩
  pass (pass a)

/-- `fd_ed25519_lane_is_zero`: bit `j` set when lane `j`'s normalized limbs are `0` or `p`'s. -/
def isZero (a : Fe) : BitVec 32 :=
  let a := normalize a
  let z := wwl_eq a.l0 wwl_zero &&& wwl_eq a.l1 wwl_zero &&& wwl_eq a.l2 wwl_zero &&&
    wwl_eq a.l3 wwl_zero &&& wwl_eq a.l4 wwl_zero
  let m := wwl_bcast mask51
  let q := wwl_eq a.l0 (wwl_bcast (mask51 - 18)) &&& wwl_eq a.l1 m &&& wwl_eq a.l2 m &&&
    wwl_eq a.l3 m &&& wwl_eq a.l4 m
  (255 &&& z) ||| (255 &&& q)

/-- `wwl_if` limbwise. -/
def Fe.ite (c : BitVec 32) (a b : Fe) : Fe :=
  Fe.zipWith (wwl_if c) a b

end

end MLIR.Firedancer.Lane
