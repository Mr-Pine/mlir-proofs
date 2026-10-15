module

public import Init.Data.BitVec
public import Init.Data.Vector

/-! `fd_f25519_jacobi_var`, the Jacobi symbol of `fd_f25519_is_square_var`, at the bit level:
batches of 62 `posdivsteps` on the low words of `f` and `g`, each batch's transition matrix applied
to the five 62-bit limbs. -/

namespace MLIR.Firedancer.Lane.Jacobi

@[expose] public section

/-- `FD_F25519_M62`, `ULONG_MAX >> 2`. -/
abbrev m62 : BitVec 64 :=
  4611686018427387903#64

/-- `fd_f25519_posdivsteps_62_var`'s loop state: `eta`, the low words `f g`, the transition matrix
`u v q r`, the steps left `i` and the symbol bit `j`. `zeros` is held at 64 bits. -/
structure PD where
  eta : BitVec 64
  f : BitVec 64
  g : BitVec 64
  u : BitVec 64
  v : BitVec 64
  q : BitVec 64
  r : BitVec 64
  i : BitVec 32
  j : BitVec 32

/-- The loop's head: `g` divided by `2` as often as possible, at most `i` times; the symbol flips
for an odd power when `f` is `3` or `5` mod `8`. -/
def PD.divide (s : PD) : PD :=
  let zeros := (s.g ||| BitVec.allOnes 64 <<< s.i.toNat).ctz
  { s with
    g := s.g >>> zeros.toNat
    u := s.u <<< zeros.toNat
    v := s.v <<< zeros.toNat
    eta := s.eta - zeros
    i := s.i - zeros.setWidth 32
    j := s.j ^^^ (zeros &&& (s.f >>> 1 ^^^ s.f >>> 2)).setWidth 32 }

/-- `fd_int_min( a, b )`. -/
def intMin (a b : BitVec 32) : BitVec 32 :=
  if a.slt b then a else b

/-- The loop's tail: for `eta < 0`, `f g` (and the matrix's rows) swapped, the symbol flipped when
both are `3` mod `4`, and up to 6 bits of `g` cancelled; else up to 4; then `g += f w`. -/
def PD.cancel (s : PD) : PD :=
  if s.eta.slt 0 then
    let eta := -s.eta
    let f := s.g
    let g := s.f
    let u := s.q
    let v := s.r
    let q := s.u
    let r := s.v
    let j := s.j ^^^ ((f &&& g) >>> 1).setWidth 32
    let limit := intMin (eta.setWidth 32 + 1) s.i
    let m := BitVec.allOnes 64 >>> (64 - limit).toNat &&& 63
    let w := f * g * (f * f - 2) &&& m
    { eta, f, g := g + f * w, u, v, q := q + u * w, r := r + v * w, i := s.i, j }
  else
    let limit := intMin (s.eta.setWidth 32 + 1) s.i
    let m := BitVec.allOnes 64 >>> (64 - limit).toNat &&& 15
    let w := s.f + ((s.f + 1) &&& 4) <<< 1
    let w := -w * s.g &&& m
    { s with g := s.g + s.f * w, q := s.q + s.u * w, r := s.r + s.v * w }

/-- `for(;;)` of `fd_f25519_posdivsteps_62_var` with `n` passes of fuel: divide, stop at `i == 0`,
else cancel. For odd `f` it stops within 63 passes. -/
def pdLoop : Nat → PD → PD
  | 0, s => s
  | n + 1, s =>
    let s := s.divide
    if s.i = 0 then s else pdLoop n s.cancel

/-- `fd_f25519_posdivsteps_62_var( eta, f0, g0, t, &jac )`: the final state; `eta` returned, `t =
[u, v, q, r]`, `jac` in `j`. -/
def posdivsteps (eta f0 g0 : BitVec 64) (jac : BitVec 32) : PD :=
  pdLoop 63 ⟨eta, f0, g0, 1, 0, 0, 1, 62, jac⟩

/-- `(int128)x`. -/
abbrev ext (x : BitVec 64) : BitVec 128 :=
  x.signExtend 128

/-- The loop of `fd_f25519_update_fg_62_var` from limb `i`, `n` limbs left: `cf += u f[i] + v
g[i]`, `f[i-1]` its low 62 bits, `cf >>= 62`; `cg` likewise. -/
def updLoop (u v q r : BitVec 64) :
    Nat → Nat → BitVec 128 → BitVec 128 → Vector (BitVec 64) 5 → Vector (BitVec 64) 5 →
      BitVec 128 × BitVec 128 × Vector (BitVec 64) 5 × Vector (BitVec 64) 5
  | 0, _, cf, cg, f, g => (cf, cg, f, g)
  | n + 1, i, cf, cg, f, g =>
    let cf := cf + (ext u * ext f[i]! + ext v * ext g[i]!)
    let cg := cg + (ext q * ext f[i]! + ext r * ext g[i]!)
    let f := f.setIfInBounds (i - 1) (cf.setWidth 64 &&& m62)
    let g := g.setIfInBounds (i - 1) (cg.setWidth 64 &&& m62)
    updLoop u v q r n (i + 1) (cf.sshiftRight 62) (cg.sshiftRight 62) f g

/-- `fd_f25519_update_fg_62_var( len, f, g, t )`: `[f, g] = t [f, g] / 2^62` on the low `len`
limbs, the top limb `f[len-1]` unmasked. -/
def updateFg (len : Nat) (f g : Vector (BitVec 64) 5) (u v q r : BitVec 64) :
    Vector (BitVec 64) 5 × Vector (BitVec 64) 5 :=
  let cf := (ext u * ext f[0] + ext v * ext g[0]).sshiftRight 62
  let cg := (ext q * ext f[0] + ext r * ext g[0]).sshiftRight 62
  let (cf, cg, f, g) := updLoop u v q r (len - 1) 1 cf cg f g
  (f.setIfInBounds (len - 1) (cf.setWidth 64), g.setIfInBounds (len - 1) (cg.setWidth 64))

/-- `fd_f25519_jacobi_var`'s loop state: `f g`, `len`, `eta`, `jac`. -/
structure JS where
  f : Vector (BitVec 64) 5
  g : Vector (BitVec 64) 5
  len : Nat
  eta : BitVec 64
  jac : BitVec 32

/-- `hi`: limbs `1 … len-1` of `f` or-ed. -/
def hiOr (f : Vector (BitVec 64) 5) (len : Nat) : BitVec 64 :=
  ((List.range len).drop 1).foldl (fun hi k => hi ||| f[k]!) 0

/-- The loop of `fd_f25519_jacobi_var` with `n` batches left: `posdivsteps`, `update_fg`, done when
`f == 1`; the top limb dropped when zero in both `f` and `g`. `0` when out of batches. -/
def jacLoop : Nat → JS → BitVec 32
  | 0, _ => 0
  | n + 1, s =>
    let pd := posdivsteps s.eta (s.f[0] ||| s.f[1] <<< 62) (s.g[0] ||| s.g[1] <<< 62) s.jac
    let (f, g) := updateFg s.len s.f s.g pd.u pd.v pd.q pd.r
    if f[0] = 1 ∧ hiOr f s.len = 0 then 1 - 2 * (pd.j &&& 1)
    else
      let len := if 1 < s.len ∧ (f[s.len - 1]! ||| g[s.len - 1]!) = 0 then s.len - 1 else s.len
      jacLoop n ⟨f, g, len, pd.eta, pd.j⟩

/-- `p`'s five 62-bit limbs, `f`'s start. -/
def pLimbs : Vector (BitVec 64) 5 :=
  #v[4611686018427387885, 4611686018427387903, 4611686018427387903, 4611686018427387903, 127]

/-- `fd_f25519_jacobi_var( x )`: `(x|p)` in `{-1, 1}`, or `0` if 25 batches did not converge. -/
def jacobi (x : Vector (BitVec 64) 5) : BitVec 32 :=
  jacLoop 25 ⟨pLimbs, x, 5, -1, 0⟩

end

end MLIR.Firedancer.Lane.Jacobi
