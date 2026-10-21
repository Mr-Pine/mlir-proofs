module

public import Zig.Common.Point
public import Zig.Common.Sha512
public import Zig.Mlir.Fe_zero
public import Zig.Mlir.Fe_one
public import Zig.Mlir.Fe_edwards25519d
public import Zig.Mlir.Fe_edwards25519d2
public import Zig.Mlir.Fe_sqrtm1
public import Zig.Mlir.Edwards25519_identityElement
public import Zig.Mlir.Edwards25519_fromBytes_invalid
public import Zig.Mlir.Edwards25519_mulDoubleBasePublic_weak
public import Zig.Mlir.Sha512_iv
public import Zig.Mlir.scalar_field_order_s
import all MLIR.Ty

/-! The globals' values (`step_addressof`'s input) and what their blocks hold (the base point's
table in `BasePointPc`). Five have undefined members: the points' padding, `Sha512.iv`'s `buf` and
padding, the error unions' payloads. Their
`step_addressof` stores the defined bits only, gives `Fits` of each run of them from a byte (the
mask's literal decided by the kernel), and reads the block back as a literal: the `…_of_readAt`
lemmas take that read through `hread.trans (by decide +kernel)`. -/

namespace MLIR.Zig

open _root_.Ed25519

/-! ### Field element constants -/

/-- The limbs of a field element global's block, read back: its initializer's limbs. -/
public theorem _root_.MLIR.MemoryState.readLimbs_of_readAt_fe {m : MemoryState} {p : Pointer}
    {v : Vector (BitVec 64) 5} {hw : (Ty.struct [.array 5 (.bv 64)]).width = 320}
    (hf : Fits m p 320) (ho : p.offset = 0)
    (h : m.readAt p 320 = Ty.flatBits (t := .struct [.array 5 (.bv 64)]) v (hw := hw)) :
    m.readLimbs p = fun i => v[i] := by
  rw [Ty.flatBits_eq] at h
  rw [MemoryState.readLimbs_of_readAt hf ho h]
  funext i
  fin_cases i <;>
    simp (disch := decide) only [BitVec.extractLsb'_cast, Ty.extractLsb'_flattenRaw_array,
      Ty.extractLsb'_flattenRaw_struct_singleton, Ty.extractLsb'_flattenRaw_bv] <;>
    simp [Ty.stride, Ty.width, Ty.padding, Ty.align]

public theorem Fe_zero.value_eq (s : GlobalState) :
    Fe_zero.value s = .value (Ty.wrap Fe_zero.lit, s) :=
  GlobalInitializer.compute_value _ _ ⟨_, by with_unfolding_all rfl⟩

public theorem Fe_one.value_eq (s : GlobalState) :
    Fe_one.value s = .value (Ty.wrap Fe_one.lit, s) :=
  GlobalInitializer.compute_value _ _ ⟨_, by with_unfolding_all rfl⟩

public theorem Fe_edwards25519d.value_eq (s : GlobalState) :
    Fe_edwards25519d.value s = .value (Ty.wrap Fe_edwards25519d.lit, s) :=
  GlobalInitializer.compute_value _ _ ⟨_, by with_unfolding_all rfl⟩

public theorem Fe_edwards25519d2.value_eq (s : GlobalState) :
    Fe_edwards25519d2.value s = .value (Ty.wrap Fe_edwards25519d2.lit, s) :=
  GlobalInitializer.compute_value _ _ ⟨_, by with_unfolding_all rfl⟩

public theorem Fe_sqrtm1.value_eq (s : GlobalState) :
    Fe_sqrtm1.value s = .value (Ty.wrap Fe_sqrtm1.lit, s) :=
  GlobalInitializer.compute_value _ _ ⟨_, by with_unfolding_all rfl⟩

public theorem Fe_zero.lit_eq : Fe_zero.lit = #v[0, 0, 0, 0, 0] :=
  rfl

public theorem Fe_one.lit_eq : Fe_one.lit = #v[1, 0, 0, 0, 0] :=
  rfl

public theorem Fe_edwards25519d.lit_eq :
    Fe_edwards25519d.lit =
      #v[929955233495203, 466365720129213, 1662059464998953, 2033849074728123, 1442794654840575] :=
  rfl

public theorem Fe_edwards25519d2.lit_eq :
    Fe_edwards25519d2.lit =
      #v[1859910466990425, 932731440258426, 1072319116312658, 1815898335770999, 633789495995903] :=
  rfl

public theorem Fe_sqrtm1.lit_eq :
    Fe_sqrtm1.lit =
      #v[1718705420411056, 234908883556509, 2233514472574048, 2117202627021982, 765476049583133] :=
  rfl

public theorem scalar_field_order_s.value_eq (s : GlobalState) :
    scalar_field_order_s.value s = .value (Ty.wrap scalar_field_order_s.lit, s) :=
  GlobalInitializer.compute_value _ _ ⟨_, by with_unfolding_all rfl⟩

/-! ### Points -/

@[expose] public section

/-- Zig's `Edwards25519` struct type. -/
abbrev EdTy : Ty :=
  Edwards25519_identityElement.t

/-- An `Edwards25519` value: `P`'s limbs, `is_base` `b`, the padding undefined. -/
def ZPt.val (P : ZPt) (b : BitVec 1) : ⟦EdTy⟧ :=
  (Vector.ofFn fun i => .value (P.x i), Vector.ofFn fun i => .value (P.y i),
    Vector.ofFn fun i => .value (P.z i), Vector.ofFn fun i => .value (P.t i), .value b,
    Vector.replicate 7 .poison)

/-- The identity `(0, 1, 1, 0)`. -/
def Edwards25519.identity : ZPt :=
  ⟨Fe.mk5 0 0 0 0 0, Fe.mk5 1 0 0 0 0, Fe.mk5 1 0 0 0 0, Fe.mk5 0 0 0 0 0⟩

end

/-- The identity global's bits, its undefined ones zero. -/
@[expose]
public def Edwards25519.identityBits : BitVec 1344 :=
  (Ty.flattenDef EdTy (Edwards25519.identity.val 0)).1.cast (by decide)

/-- The identity global's value: the identity, `is_base` false. -/
public theorem Edwards25519_identityElement.value_eq (s : GlobalState) :
    Edwards25519_identityElement.value s = .value (Edwards25519.identity.val 0, s) :=
  GlobalInitializer.compute_value _ _ ⟨_, by with_unfolding_all rfl⟩

/-! ### Error unions -/

@[expose] public section

/-- An `Edwards25519` value all undefined. -/
def ZPt.undef : ⟦EdTy⟧ :=
  (Vector.replicate 5 .poison, Vector.replicate 5 .poison, Vector.replicate 5 .poison,
    Vector.replicate 5 .poison, .poison, Vector.replicate 7 .poison)

end

/-- `error.InvalidEncoding`: its code `2`, the payload undefined. -/
public theorem Edwards25519_fromBytes_invalid.value_eq (s : GlobalState) :
    Edwards25519_fromBytes_invalid.value s =
      .value ((ZPt.undef, .value 2, Vector.replicate 6 .poison), s) :=
  GlobalInitializer.compute_value _ _ ⟨_, by with_unfolding_all rfl⟩

/-- `error.WeakPublicKey`: its code `4`, the payload undefined. -/
public theorem Edwards25519_mulDoubleBasePublic_weak.value_eq (s : GlobalState) :
    Edwards25519_mulDoubleBasePublic_weak.value s =
      .value ((ZPt.undef, .value 4, Vector.replicate 6 .poison), s) :=
  GlobalInitializer.compute_value _ _ ⟨_, by with_unfolding_all rfl⟩

/-- `error.InvalidEncoding`'s bits, its undefined ones zero. -/
@[expose]
public def Edwards25519_fromBytes_invalid.bits : BitVec 1408 :=
  (Ty.flattenDef Edwards25519_fromBytes_invalid.t
        (ZPt.undef, .value 2, Vector.replicate 6 .poison)).1.cast
    (by decide)

/-- `error.WeakPublicKey`'s bits, its undefined ones zero. -/
@[expose]
public def Edwards25519_mulDoubleBasePublic_weak.bits : BitVec 1408 :=
  (Ty.flattenDef Edwards25519_mulDoubleBasePublic_weak.t
        (ZPt.undef, .value 4, Vector.replicate 6 .poison)).1.cast
    (by decide)

/-! ### `Sha512.iv` -/

@[expose] public section

/-- `Sha512.iv`'s value: `total_len` and `buf_len` zero, the state `IV`, `buf` and the padding
undefined. -/
def Sha512_iv.val : ⟦Sha512_iv.t⟧ :=
  (.value 0, Vector.ofFn fun i => .value Sha512.IV[i], Vector.replicate 128 .poison, .value 0,
    Vector.replicate 15 .poison)

end

/-- `Sha512.iv`'s bits, its undefined ones zero. -/
@[expose]
public def Sha512_iv.bits : BitVec 1792 :=
  (Ty.flattenDef Sha512_iv.t Sha512_iv.val).1.cast (by decide)

public theorem Sha512_iv.value_eq (s : GlobalState) :
    Sha512_iv.value s = .value (Sha512_iv.val, s) :=
  GlobalInitializer.compute_value _ _ ⟨_, by with_unfolding_all rfl⟩

end MLIR.Zig
