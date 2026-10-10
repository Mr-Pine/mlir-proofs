module

public import MLIR.Semantics.Func
public import MLIR.Run.Memory
public import Firedancer.Avx512.Common.FoldUnsigned
public import Firedancer.Avx512.Common.Vec

/-! The callees of the r43x6 field and point code: their types, and specs to state callers
against. A spec says what a callee returns on poison-free values and how the state changes. -/

namespace MLIR.Firedancer.Avx512

@[expose] public section

/-- `<4 x i64>`, a `wv_t`. -/
abbrev V4 : Ty :=
  .vec 4 64

/-- `wv_ld`'s type. -/
abbrev WvLd :=
  Vals [.ptr] → EffectM (Vals [V4])

/-- `fd_r43x6_unpack`'s type. -/
abbrev Unpack :=
  Vals [V4] → EffectM (Vals [V])

/-- `fd_r43x6_sqr_fast`'s type. -/
abbrev SqrFast :=
  Vals [V] → EffectM (Vals [V])

/-- `fd_r43x6_mul_fast`'s type. -/
abbrev MulFast :=
  Vals [V, V] → EffectM (Vals [V])

/-- `fd_r43x6_pow22523_2`'s type: `(_z1, z1, _z2, z2)`. -/
abbrev Pow22523_2 :=
  Vals [.ptr, V, .ptr, V] → EffectM (Vals [])

/-- `fd_r43x6_diagnose`'s and `fd_r43x6_is_nonzero`'s type. -/
abbrev Classify :=
  Vals [V] → EffectM (Vals [.bv 32])

/-- `ld` returns the 32 bytes at `p`, lane 0 lowest, and leaves a well-formed state alone. -/
abbrev WvLd.Spec (ld : WvLd) : Prop :=
  ∀ p s,
    s.WF →
      Fits s.mem p V4.width →
      ld (.cons (.value p) .nil) s = .value (.cons (V4.unflatten (s.mem.readAt p V4.width)) .nil, s)

/-- `unpack` splits as `unpackS` on poison-free lanes, and leaves a well-formed state alone. -/
abbrev Unpack.Spec (unpack : Unpack) (unpackS : Vector (BitVec 64) 4 → Vector (BitVec 64) 8) :
    Prop :=
  ∀ x s, s.WF → unpack (.cons (Ty.wrap x) .nil) s = .value (.cons (Ty.wrap (unpackS x)) .nil, s)

/-- `sqr` squares as `sqrS` on poison-free lanes, and leaves a well-formed state alone. -/
abbrev SqrFast.Spec (sqr : SqrFast) (sqrS : Vector (BitVec 64) 8 → Vector (BitVec 64) 8) : Prop :=
  ∀ x s, s.WF → sqr (.cons (Ty.wrap x) .nil) s = .value (.cons (Ty.wrap (sqrS x)) .nil, s)

/-- `mul` multiplies as `mulS` on poison-free lanes, and leaves a well-formed state alone. -/
abbrev MulFast.Spec (mul : MulFast)
    (mulS : Vector (BitVec 64) 8 → Vector (BitVec 64) 8 → Vector (BitVec 64) 8) : Prop :=
  ∀ x y s,
    s.WF →
      mul (.cons (Ty.wrap x) (.cons (Ty.wrap y) .nil)) s =
        .value (.cons (Ty.wrap (mulS x y)) .nil, s)

/-- `pow` stores `powS z1` at `_z1`, then `powS z2` at `_z2`; its 20 stack slots use up 20 block
ids. -/
abbrev Pow22523_2.Spec (pow : Pow22523_2) (powS : Vector (BitVec 64) 8 → Vector (BitVec 64) 8) :
    Prop :=
  ∀ p x q y s,
    s.WF →
      Room s.mem p 512 →
      Room s.mem q 512 →
      pow (.cons (.value p) (.cons (Ty.wrap x) (.cons (.value q) (.cons (Ty.wrap y) .nil)))) s =
        .value
          (.nil,
            { alloc := ⟨s.alloc.nextFreeBlock + 20⟩,
              mem := (s.mem.storeVec p (powS x)).storeVec q (powS y) })

/-- `f` answers `classS` on poison-free lanes, and leaves a well-formed state alone. -/
abbrev Classify.Spec (f : Classify) (classS : Vector (BitVec 64) 8 → BitVec 32) : Prop :=
  ∀ x s, s.WF → f (.cons (Ty.wrap x) .nil) s = .value (.cons (.value (classS x)) .nil, s)

end

end MLIR.Firedancer.Avx512
