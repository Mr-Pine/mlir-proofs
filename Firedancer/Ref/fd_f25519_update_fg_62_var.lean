module

public import Init.Data.Vector.Basic
public import Init.Data.BitVec.Basic

namespace MLIR.Firedancer.Ref

/-! ## Specification

`long` is `BitVec 64`, `int128` is `BitVec 128`, `(int128)` is `signExtend 128`, `>>=` on
`int128` is arithmetic (`sshiftRight`). `f`, `g` are the caller's `long[5]` arrays; `len` outside
`[1,5]` (UB, never passed) is not modelled. -/

@[expose] public section

namespace fd_f25519_update_fg_62_var

/-- `FD_F25519_M62` (`fd_f25519.c:151`), `ULONG_MAX>>2`. -/
def M62 : BitVec 64 :=
  BitVec.allOnes 64 >>> 2

/-- The carries and arrays across the `for( int i=1; i<len; i++ )` loop. -/
structure State where
  cf : BitVec 128
  cg : BitVec 128
  f : Vector (BitVec 64) 5
  g : Vector (BitVec 64) 5

/-- One iteration at `i` (`fd_f25519.c:228-231`), with `t = [u,v,q,r]`. -/
def body (t : Vector (BitVec 64) 4) (s : State) (i : Nat) : State :=
  let u := t[0]
  let v := t[1]
  let q := t[2]
  let r := t[3]
  let cf :=
    s.cf +
      (u.signExtend 128 * (s.f[i]?.getD 0).signExtend 128 +
        v.signExtend 128 * (s.g[i]?.getD 0).signExtend 128)
  let cg :=
    s.cg +
      (q.signExtend 128 * (s.f[i]?.getD 0).signExtend 128 +
        r.signExtend 128 * (s.g[i]?.getD 0).signExtend 128)
  let f := s.f.setIfInBounds (i - 1) (cf.setWidth 64 &&& M62)
  let cf := cf.sshiftRight 62
  let g := s.g.setIfInBounds (i - 1) (cg.setWidth 64 &&& M62)
  let cg := cg.sshiftRight 62
  ⟨cf, cg, f, g⟩

end fd_f25519_update_fg_62_var

open fd_f25519_update_fg_62_var in
/-- `fd_f25519_update_fg_62_var` (`ballet/ed25519/fd_f25519.c:218`): the new `f`, `g`. -/
def fd_f25519_update_fg_62_var.spec (len : BitVec 32) (f g : Vector (BitVec 64) 5)
    (t : Vector (BitVec 64) 4) : Vector (BitVec 64) 5 × Vector (BitVec 64) 5 :=
  let u := t[0]
  let v := t[1]
  let q := t[2]
  let r := t[3]
  let cf := u.signExtend 128 * f[0].signExtend 128 + v.signExtend 128 * g[0].signExtend 128
  let cg := q.signExtend 128 * f[0].signExtend 128 + r.signExtend 128 * g[0].signExtend 128
  let cf := cf.sshiftRight 62
  let cg := cg.sshiftRight 62
  let s := (List.range' 1 (len.toInt - 1).toNat).foldl (body t) ⟨cf, cg, f, g⟩
  let f := s.f.setIfInBounds (len.toInt - 1).toNat (s.cf.setWidth 64)
  let g := s.g.setIfInBounds (len.toInt - 1).toNat (s.cg.setWidth 64)
  (f, g)

end

end MLIR.Firedancer.Ref
