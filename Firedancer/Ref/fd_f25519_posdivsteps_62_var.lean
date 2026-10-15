module

public import Firedancer.Ref.fd_ulong_find_lsb

namespace MLIR.Firedancer.Ref

/-! ## Specification

`long`/`ulong` are `BitVec 64`, `int` is `BitVec 32`; casts between them are `setWidth`
(truncation) or `signExtend`. A shift by an `int` count `n` is `<<< n.toNat`. The `for(;;)` loop
takes a `fuel` bound (`fuel`). -/

@[expose] public section

namespace fd_f25519_posdivsteps_62_var

/-- The loop's locals (`fd_f25519.c:164-167`) and `eta`. -/
structure State where
  u : BitVec 64
  v : BitVec 64
  q : BitVec 64
  r : BitVec 64
  f : BitVec 64
  g : BitVec 64
  eta : BitVec 64
  i : BitVec 32
  j : BitVec 32

/-- `fd_int_min` (`util/bits/fd_bits.h:408`): `(x<=y) ? x : y`, signed. -/
def fd_int_min (x y : BitVec 32) : BitVec 32 :=
  if x.sle y then x else y

/-- One pass of the `for(;;)` body (`fd_f25519.c:169-207`): the new locals, and whether it hit
`if( !i ) break;`. -/
def body (s : State) : State × Bool :=
  let zeros := fd_ulong_find_lsb.spec (s.g ||| (BitVec.allOnes 64 <<< s.i.toNat))
  let g := s.g >>> zeros.toNat
  let u := s.u <<< zeros.toNat
  let v := s.v <<< zeros.toNat
  let eta := s.eta - zeros.signExtend 64
  let i := s.i - zeros
  let j := s.j ^^^ (zeros.signExtend 64 &&& ((s.f >>> 1) ^^^ (s.f >>> 2))).setWidth 32
  if i = 0#32 then (⟨u, v, s.q, s.r, s.f, g, eta, i, j⟩, true)
  else
    if eta.slt 0#64 then
      let eta := -eta
      let tmp := s.f
      let f := g
      let g := tmp
      let tmp := u
      let u := s.q
      let q := tmp
      let tmp := v
      let v := s.r
      let r := tmp
      let j := j ^^^ ((f &&& g) >>> 1).setWidth 32
      let limit := fd_int_min (eta.setWidth 32 + 1#32) i
      let m := (BitVec.allOnes 64 >>> (64#32 - limit).toNat) &&& 63#64
      let w := (f * g * (f * f - 2#64)) &&& m
      let g := g + f * w
      let q := q + u * w
      let r := r + v * w
      (⟨u, v, q, r, f, g, eta, i, j⟩, false)
    else
      let limit := fd_int_min (eta.setWidth 32 + 1#32) i
      let m := (BitVec.allOnes 64 >>> (64#32 - limit).toNat) &&& 15#64
      let w := s.f + (((s.f + 1#64) &&& 4#64) <<< 1)
      let w := ((-w) * g) &&& m
      let g := g + s.f * w
      let q := s.q + u * w
      let r := s.r + v * w
      (⟨u, v, q, r, s.f, g, eta, i, j⟩, false)

/-- The `for(;;)` loop from `s`, at most `fuel` passes. -/
def loop : (fuel : Nat) → State → State
  | 0, s => s
  | fuel + 1, s =>
    let r := body s
    if r.2 then r.1 else loop fuel r.1

/-- A bound on the passes: each pass after the first lowers `i` (from 62) by at least 1 while
`f` is odd. -/
def fuel : Nat :=
  256

/-- What the function returns (`eta`) and writes (`t[0..3]`, `*jac`). -/
structure Result where
  eta : BitVec 64
  t : Vector (BitVec 64) 4
  jac : BitVec 32

end fd_f25519_posdivsteps_62_var

open fd_f25519_posdivsteps_62_var in
/-- `fd_f25519_posdivsteps_62_var` (`ballet/ed25519/fd_f25519.c:159`); `jac` is `*jac` on entry. -/
def fd_f25519_posdivsteps_62_var.spec (eta f0 g0 : BitVec 64) (jac : BitVec 32) : Result :=
  let s := loop fuel ⟨1#64, 0#64, 0#64, 1#64, f0, g0, eta, 62#32, jac⟩
  ⟨s.eta, #v[s.u, s.v, s.q, s.r], s.j⟩

end

end MLIR.Firedancer.Ref
