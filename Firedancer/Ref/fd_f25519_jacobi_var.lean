module

public import Firedancer.Ref.fd_f25519_posdivsteps_62_var
public import Firedancer.Ref.fd_f25519_update_fg_62_var

namespace MLIR.Firedancer.Ref

/-! ## Specification -/

@[expose] public section

namespace fd_f25519_jacobi_var

/-- The locals across the `for( int cnt=0; cnt<25; cnt++ )` loop. -/
structure State where
  f : Vector (BitVec 64) 5
  g : Vector (BitVec 64) 5
  len : BitVec 32
  eta : BitVec 64
  jac : BitVec 32

/-- `for( int j=1; j<len; j++ ) hi |= f[j];` from `hi = 0`. -/
def hi (f : Vector (BitVec 64) 5) (len : BitVec 32) : BitVec 64 :=
  (List.range' 1 (len.toInt - 1).toNat).foldl (fun hi j => hi ||| (f[j]?.getD 0)) 0#64

/-- The loop with `k` iterations left (`fd_f25519.c:250-264`); `0` once they run out. -/
def loop : (k : Nat) → State → BitVec 32
  | 0, _ => 0#32
  | k + 1, s =>
    let res :=
      fd_f25519_posdivsteps_62_var.spec s.eta (s.f[0] ||| (s.f[1] <<< 62))
        (s.g[0] ||| (s.g[1] <<< 62)) s.jac
    let eta := res.eta
    let jac := res.jac
    let fg := fd_f25519_update_fg_62_var.spec s.len s.f s.g res.t
    let f := fg.1
    let g := fg.2
    if f[0] = 1#64 ∧ hi f s.len = 0#64 then 1#32 - 2#32 * (jac &&& 1#32)
    else
      let i := (s.len - 1#32).toNat
      let len :=
        if (1#32).slt s.len ∧ ((f[i]?.getD 0) ||| (g[i]?.getD 0)) = 0#64 then s.len - 1#32
        else s.len
      loop k ⟨f, g, len, eta, jac⟩

end fd_f25519_jacobi_var

/-- `fd_f25519_jacobi_var` (`ballet/ed25519/fd_f25519.c:243`). -/
def fd_f25519_jacobi_var.spec (x : Vector (BitVec 64) 5) : BitVec 32 :=
  let f : Vector (BitVec 64) 5 :=
    #v[(1#64 <<< 62) - 19#64, (1#64 <<< 62) - 1#64, (1#64 <<< 62) - 1#64, (1#64 <<< 62) - 1#64,
      127#64]
  let g : Vector (BitVec 64) 5 := #v[x[0], x[1], x[2], x[3], x[4]]
  fd_f25519_jacobi_var.loop 25 ⟨f, g, 5#32, -1#64, 0#32⟩

end

end MLIR.Firedancer.Ref
