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
`step_addressof` stores the defined bits only, gives `Fits` of each run of them from a byte (with
`exponentiation.threshold` above the global's width, so the mask's literal is decided), and reads
the block back as a literal: the `…_of_readAt` lemmas take that read through
`hread.trans (by decide +kernel)`. -/

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

/-- The identity global's block (`step_addressof`'s facts): the identity, `is_base` false. -/
public theorem _root_.MLIR.MemoryState.identity_of_readAt {m : MemoryState} {p : Pointer}
    (hr : Room m p 1344) (hf : Fits m p 1281) (ho : p.offset = 0)
    (h : m.readAt p 1344 = Edwards25519.identityBits) :
    m.PtFit p ∧ m.readPt p = Edwards25519.identity ∧ m.readBase p = 0 := by
  have ho' : p.offset.toNat + 168 ≤ 2 ^ 64 := by simp [ho]
  refine
    ⟨.of_fits hr hf ho', MemoryState.readPt_of_readAt (InBounds.mono (by omega) hr.inBounds) ho' ?_,
      ?_⟩
  · rw [MemoryState.readAt_of_readAt_le (by omega) h]
    decide +kernel
  · rw [MemoryState.readBase,
      MemoryState.readAt_add_of_readAt hr.inBounds (p.not_uaddOverflow_of_pt ho' (by decide))
        (by decide) h]
    decide +kernel

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

/-- `error.InvalidEncoding`'s block (`step_addressof`'s facts): its code at byte 168. -/
public theorem _root_.MLIR.MemoryState.invalid_of_readAt {m : MemoryState} {p : Pointer}
    (hr : Room m p 1408) (ho : p.offset = 0)
    (h : m.readAt p 1408 = Edwards25519_fromBytes_invalid.bits) :
    m.readAt (p.add 168#64) 16 = 2#16 := by
  rw [MemoryState.readAt_add_of_readAt hr.inBounds (by simp [BitVec.uaddOverflow, ho]) (by decide)
      h]
  decide +kernel

/-- `error.WeakPublicKey`'s block (`step_addressof`'s facts): its code at byte 168. -/
public theorem _root_.MLIR.MemoryState.weak_of_readAt {m : MemoryState} {p : Pointer}
    (hr : Room m p 1408) (ho : p.offset = 0)
    (h : m.readAt p 1408 = Edwards25519_mulDoubleBasePublic_weak.bits) :
    m.readAt (p.add 168#64) 16 = 4#16 := by
  rw [MemoryState.readAt_add_of_readAt hr.inBounds (by simp [BitVec.uaddOverflow, ho]) (by decide)
      h]
  decide +kernel

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

/-- No bits are known where there is room. -/
public theorem Fits.zero {m : MemoryState} {p : Pointer} (h : Room m p 0) : Fits m p 0 := by
  obtain ⟨b, hb, hl, hw⟩ := h
  exact ⟨b, hb, hl, hw, BitVec.eq_of_toNat_eq (by simp)⟩

/-- `Sha512.iv`'s state words, `buf_len` and `total_len` in its bits. -/
theorem iv_bits :
    (∀ i : Fin 8, Sha512_iv.bits.extractLsb' ((16 + 8 * i.val) * 8) 64 = Sha512.IV[i]) ∧
      Sha512_iv.bits.extractLsb' (208 * 8) 8 = 0#8 ∧ Sha512_iv.bits.setWidth 128 = 0#128 := by
  decide +kernel

/-- `Sha512.iv`'s block (`step_addressof`'s facts): an object that has absorbed nothing. -/
public theorem Sha512Obj.iv_of_readAt {m : MemoryState} {d : Pointer} (hr : MLIR.Room m d 1792)
    (hf : Fits m d 640) (hb : Fits m (d.add 208#64) 8) (ho : d.offset = 0)
    (h : m.readAt d 1792 = Sha512_iv.bits) : Sha512Obj.Fit m d ∧ Sha512Obj.Absorbed m d [] := by
  have hr' (k w : Nat) (hk : k * 8 + w ≤ 1792) :
    m.readAt (d.add (BitVec.ofNat 64 k)) w = Sha512_iv.bits.extractLsb' (k * 8) w := by
    rw [MemoryState.readAt_add_of_readAt hr.inBounds
        (by
          simp [BitVec.uaddOverflow, ho]; omega)
        (by
          simp; omega)
        h]
    congr 1
    simp
    omega
  refine ⟨⟨by simp [ho], hr, hf, hb⟩, ⟨?_, ?_, by simp, ?_, ?_⟩⟩
  · rw [Sha512.compressBlocks_of_lt (by simp)]
    apply Vector.ext
    intro i hi
    simp only [Sha512Obj.state, Vector.getElem_ofFn]
    rw [show 16#64 + BitVec.ofNat 64 (8 * i) = BitVec.ofNat 64 (16 + 8 * i) by
        apply BitVec.eq_of_toNat_eq; simp,
      hr' _ _ (by omega)]
    exact iv_bits.1 ⟨i, hi⟩
  · rw [Sha512Obj.bufLen, hr' 208 8 (by omega), iv_bits.2.1]
    rfl
  · exact (MemoryState.readAt_of_readAt_le (w := 128) (by decide) h).trans iv_bits.2.2
  · exact Fits.zero (Room.add_of_le (by simp [BitVec.uaddOverflow, ho]) (by decide) hr)

end MLIR.Zig
