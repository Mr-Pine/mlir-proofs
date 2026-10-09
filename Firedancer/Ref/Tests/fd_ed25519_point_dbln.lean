module

public import Firedancer.Ref.fd_ed25519_point_dbln

meta import Firedancer.Ref.fd_ed25519_point_dbln

namespace MLIR.Firedancer.Ref

private def r : Pointer :=
  ⟨⟨0⟩, 0⟩

private def a : Pointer :=
  ⟨⟨1⟩, 0⟩

/-- Two 160-byte blocks: `r` zeroed, `a` holding `bytes`. -/
private def state (bytes : BitVec 1280) : GlobalState :=
  ⟨⟨2⟩, ⟨Std.ExtHashMap.ofList [(⟨0⟩, ⟨160, 0⟩), (⟨1⟩, ⟨160, bytes⟩)]⟩⟩

private def aBytes : BitVec 1280 :=
  BitVec.ofNat 1280 (2 ^ 1100 + 3 * 2 ^ 700 + 5 * 2 ^ 400 + 7)

/-- `P` with its limbs computed once: the specs' limbs are functions, recomputed at each use. -/
private def memo (P : PointLimbs) : PointLimbs :=
  ⟨(Vector.ofFn P.X).get, (Vector.ofFn P.Y).get, (Vector.ofFn P.T).get, (Vector.ofFn P.Z).get⟩

/-- `fd_ed25519_point_dbln.iter`, memoized after each call's spec. -/
private def iterMemo : Nat → PointLimbs → PointLimbs
  | 0, t => t
  | j + 1, t =>
    iterMemo j
      (memo
        (fd_ed25519_partial_dbl.spec (memo (fd_ed25519_point_add_final_mul_projective.spec t 0))))

/-- `fd_ed25519_point_dbln.spec`, memoized. -/
private def specMemo (P : PointLimbs) (n : Nat) : PointLimbs :=
  memo
    (fd_ed25519_point_add_final_mul.spec (iterMemo (n - 1) (memo (fd_ed25519_partial_dbl.spec P))))

/-- Whether `dbln dst src n` returns `dst` and stores `spec` of `src`'s point at `dst`. -/
private def check (dst src : Pointer) (n : Nat) : Bool :=
  match
    fd_ed25519_point_dbln.eval 10
      (fd_ed25519_point_dbln.args (.value dst) (.value src) (.value (BitVec.ofNat 32 n)))
      (state aBytes) with
  | .value (some (.cons ret .nil), s') =>
    let P := specMemo ((state aBytes).mem.readPoint src) n
    ret == .value dst &&
      (List.finRange 5).all fun k =>
        s'.mem.readLimbs dst k == P.X k && s'.mem.readLimbs (dst.add 40#64) k == P.Y k &&
          s'.mem.readLimbs (dst.add 80#64) k == P.T k &&
          s'.mem.readLimbs (dst.add 120#64) k == P.Z k
  | _ => false

#guard check r a 1

#guard check r a 2

#guard check r a 3

-- in place
#guard check a a 3

end MLIR.Firedancer.Ref
