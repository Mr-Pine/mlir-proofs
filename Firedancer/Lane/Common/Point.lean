module

public import Firedancer.Lane.Common.Fe

/-! `fd_ed25519_lane_point_t`, the table form `fd_ed25519_lane_niels_t`, and the group operations
of `fd_ed25519_lane.h`, as functions. -/

namespace MLIR.Firedancer.Lane

open Firedancer.Avx512

@[expose] public section

/-- `fd_ed25519_lane_point_t`: extended coordinates `X, Y, Z, T`, in that order in memory. -/
structure Point where
  x : Fe
  y : Fe
  z : Fe
  t : Fe

/-- `fd_ed25519_lane_niels_t`: `y + x`, `y - x`, `2dt`, `2p - 2dt`, `z`. -/
structure Niels where
  p : Fe
  m : Fe
  k : Fe
  nk : Fe
  z : Fe

/-- `fd_ed25519_lane_zero`: the neutral point `(0, 1, 1, 0)`. -/
def Point.zero : Point :=
  ⟨Fe.zero, Fe.one, Fe.one, Fe.zero⟩

/-- `fd_ed25519_lane_point_dbl` into a destination whose `t` is `t0`: with `withT` false, `t0`
stays. -/
def Point.dbl (p : Point) (withT : Bool) (t0 : Fe) : Point :=
  let s := add p.x p.y
  let a := sqr p.x false
  let b := sqr p.y false
  let c := sqr p.z false
  let s := sqr s false
  let g := subBig b a 11
  let h := addRaw a b
  let e := subBig s h 12
  let h := Fe.zipWith wwl_sub (bigP 12) h
  let g := carry g
  let c := addRaw c c
  let f := subBig g c 11
  let e := carry e
  let f := carry f
  let h := carry h
  ⟨mul e f, mul g h, mul f g, if withT then mul e h else t0⟩

/-- `fd_ed25519_lane_point_add_fin` from the loose products `a, b, c, d`. -/
def Point.addFin (a b c d : Fe) (withT : Bool) (t0 : Fe) : Point :=
  let e := subBig b a 11
  let h := addRaw b a
  let d2 := addRaw d d
  let f := subBig d2 c 11
  let g := addRaw d2 c
  let e := carry e
  let f := carry f
  let g := carry g
  let h := carry h
  ⟨mul e f, mul g h, mul f g, if withT then mul e h else t0⟩

/-- The complete addition of `fd_ed25519_lane_point_add` and `_add_sel`, with the operand's
`y + x`, `y - x`, `2dt`, `z`; `affine`: its `z` is one, `d = p.z`. -/
def Point.addQ (p : Point) (qp qm qk qz : Fe) (affine withT : Bool) (t0 : Fe) : Point :=
  let a := sub p.y p.x
  let b := add p.y p.x
  let a := mul a qm false
  let b := mul b qp false
  let c := mul p.t qk false
  let d := if affine then p.z else mul p.z qz false
  Point.addFin a b c d withT t0

/-- `fd_ed25519_lane_point_add`. -/
def Point.add (p : Point) (q : Niels) (affine withT : Bool) (t0 : Fe) : Point :=
  p.addQ q.p q.m q.k q.z affine withT t0

/-- `fd_ed25519_lane_to_niels`, `k2d` the broadcast `2d`. -/
def Point.toNiels (p : Point) (k2d : Fe) : Niels :=
  let k := mul p.t k2d
  ⟨Lane.add p.y p.x, sub p.y p.x, k, neg k, p.z⟩

/-- The identity's table form, entry 0 of `fd_ed25519_lane_verify`'s table. -/
def Niels.zero : Niels :=
  ⟨Fe.one, Fe.one, Fe.zero, twoP, Fe.one⟩

/-- The table form with `y + x`, `y - x` swapped and `-2dt` for `2dt`: the negated entry. -/
def Niels.negSel (q : Niels) (neg : Bool) : Fe × Fe × Fe :=
  if neg then (q.m, q.p, q.nk) else (q.p, q.m, q.k)

end

end MLIR.Firedancer.Lane
