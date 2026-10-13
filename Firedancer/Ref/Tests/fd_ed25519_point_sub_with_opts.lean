module

public import Firedancer.Ref.fd_ed25519_point_sub_with_opts

meta import Firedancer.Ref.fd_ed25519_point_sub_with_opts

namespace MLIR.Firedancer.Ref

private def r : Pointer :=
  ⟨⟨0⟩, 0⟩

private def a : Pointer :=
  ⟨⟨1⟩, 0⟩

private def b : Pointer :=
  ⟨⟨2⟩, 0⟩

/-- Three 160-byte blocks: `r` zeroed, `a` and `b` holding two points' bytes; then
`fd_f25519_k`'s. -/
private def state : GlobalState :=
  GlobalState.withGlobals fd_ed25519_point_sub_with_opts.globals
    ⟨⟨3⟩,
      ⟨Std.ExtHashMap.ofList
          [(⟨0⟩, .ofBytes 160 0),
            (⟨1⟩, .ofBytes 160 (BitVec.ofNat 1280 (2 ^ 1100 + 3 * 2 ^ 700 + 5 * 2 ^ 400 + 7))),
            (⟨2⟩,
              .ofBytes 160
                (BitVec.ofNat 1280 (11 * 2 ^ 1200 + 2 ^ 900 + 13 * 2 ^ 500 + 2 ^ 64 + 9)))]⟩⟩

/-- `P` with its limbs computed once: the specs' limbs are functions, recomputed at each use. -/
private def memo (P : PointLimbs) : PointLimbs :=
  let f (l : Fin 5 → BitVec 64) : Fin 5 → BitVec 64 :=
    let v := #v[l 0, l 1, l 2, l 3, l 4]
    fun i => v[i]
  ⟨f P.X, f P.Y, f P.T, f P.Z⟩

/-- Whether `sub_with_opts dst src1 src2 z p s` returns `dst`, stores `spec` of the two points at
`dst`, and frees its frame. -/
private def check (dst src1 src2 : Pointer) (z p s : BitVec 32) : Bool :=
  match
    fd_ed25519_point_sub_with_opts.call
      (fd_ed25519_point_sub_with_opts.args (.value dst) (.value src1) (.value src2) (.value z)
        (.value p) (.value s))
      state with
  | .value (.cons ret .nil, s') =>
    let P :=
      memo
        (fd_ed25519_point_sub_with_opts.spec (memo (state.mem.readPoint src1))
          (memo (state.mem.readPoint src2)) z p s)
    ret == .value dst && s'.mem.mem.size == 4 &&
      (List.finRange 5).all fun k =>
        s'.mem.readLimbs dst k == P.X k && s'.mem.readLimbs (dst.add 40#64) k == P.Y k &&
          s'.mem.readLimbs (dst.add 80#64) k == P.T k &&
          s'.mem.readLimbs (dst.add 120#64) k == P.Z k
  | _ => false

-- every combination of the flags
#guard check r a b 0 0 0

#guard check r a b 0 0 1

#guard check r a b 0 1 0

#guard check r a b 0 1 1

#guard check r a b 1 0 0

#guard check r a b 1 0 1

#guard check r a b 1 1 0

#guard check r a b 1 1 1

-- `r` may be `a` or `b`, and `a` may be `b`
#guard check a a b 1 1 1

#guard check b a b 0 0 0

#guard check r a a 0 1 0

end MLIR.Firedancer.Ref
