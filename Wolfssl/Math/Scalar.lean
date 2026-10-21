module

public import Ed25519.Scalar
public import Wolfssl.sc_reduce
public import Wolfssl.sc_muladd
import Std.Data.ExtHashMap.Lemmas

namespace MLIR.Wolfssl

open _root_.Wolfssl.Mlir

open _root_.Ed25519

/-! ## Reduce -/

@[expose] public section

/-- What `sc_reduce` is for: the 32 bytes it stores are congruent modulo `ℓ` to the 64 bytes it
reads. (`x mod ℓ` itself, the canonical result, is stronger.) -/
def sc_reduce.ReducesModEll : Prop :=
  ∀ x : BitVec 512, (sc_reduce.spec x).toNat % ell = x.toNat % ell

end

/-- On `2^255 ℓ - 1` the last limb ends at `-1`: `sc_reduce` stores 32 bytes of `0xff`. -/
public theorem sc_reduce.spec_counterexample :
    sc_reduce.spec (BitVec.ofNat 512 (2 ^ 255 * ell - 1)) = BitVec.allOnes 256 := by
  decide +kernel

/-- `sc_reduce` does not reduce modulo `ℓ`: `2^256 - 1` and `2^255 ℓ - 1` differ modulo `ℓ`. -/
public theorem sc_reduce.not_reducesModEll : ¬sc_reduce.ReducesModEll := by
  intro h
  have := h (BitVec.ofNat 512 (2 ^ 255 * ell - 1))
  rw [sc_reduce.spec_counterexample] at this
  revert this
  decide +kernel

/-! ## Multiply and add -/

@[expose] public section

/-- What `sc_muladd(s, a, b, c)` is for: on 32-byte buffers `a`, `b`, `c` holding `A`, `B`, `C`
and a separate output `s`, when it returns, the 32 bytes at `s` are congruent modulo `ℓ` to
`A * B + C`. (`(A * B + C) mod ℓ` itself is stronger.) -/
def sc_muladd.MulAddModEll : Prop :=
  ∀ (s a b c : Pointer) (st : GlobalState) (A B C : BitVec 256),
    st.WF → Room st.mem s 256 → Fits st.mem a 256 → Fits st.mem b 256 → Fits st.mem c 256 →
      ¬s.offset.uaddOverflow 32#64 → ¬a.offset.uaddOverflow 32#64 →
      ¬b.offset.uaddOverflow 32#64 → ¬c.offset.uaddOverflow 32#64 →
      [s.id, a.id, b.id, c.id].Nodup →
      st.mem.readAt a 256 = A → st.mem.readAt b 256 = B → st.mem.readAt c 256 = C →
      ∀ (r : Vals sc_muladd.tRets) (st' : GlobalState),
        sc_muladd.call (sc_muladd.args (.value s) (.value a) (.value b) (.value c)) st =
            .value (r, st') →
          (st'.mem.readAt s 256).toNat % ell = (A.toNat * B.toNat + C.toNat) % ell

/-- No blocks and no globals, the allocator at block `1`. -/
def sc_muladd.empty : GlobalState :=
  ⟨⟨1⟩, ⟨{}⟩⟩

/-- Four 32-byte blocks `1 … 4` allocated on `empty`, for `s`, `a`, `b`, `c`. -/
def sc_muladd.blocks : GlobalState :=
  (((sc_muladd.empty.alloca 32).alloca 32).alloca 32).alloca 32

/-- `blocks` with `A`, `B`, `C` stored in blocks `2`, `3`, `4`. -/
def sc_muladd.witness (A B C : BitVec 256) : GlobalState :=
  { sc_muladd.blocks with
    mem :=
      ((sc_muladd.blocks.mem.storeAt ⟨⟨2⟩, 0⟩ A).storeAt ⟨⟨3⟩, 0⟩ B).storeAt ⟨⟨4⟩, 0⟩ C }

end

/-! The witness's facts. -/

theorem sc_muladd.empty_wf : sc_muladd.empty.WF where
  bound := by simp [sc_muladd.empty]
  pos := by decide
  null := by simp [sc_muladd.empty]
  global := by intro _ _ _ h; cases h
  merged := by intro _ _ _ _ _ h; cases h

theorem sc_muladd.wf1 : (sc_muladd.empty.alloca 32).WF :=
  sc_muladd.empty_wf.alloca

theorem sc_muladd.wf2 : ((sc_muladd.empty.alloca 32).alloca 32).WF :=
  sc_muladd.wf1.alloca

theorem sc_muladd.wf3 : (((sc_muladd.empty.alloca 32).alloca 32).alloca 32).WF :=
  sc_muladd.wf2.alloca

theorem sc_muladd.witness_wf (A B C : BitVec 256) : (sc_muladd.witness A B C).WF := by
  simp only [sc_muladd.witness, GlobalState.WF_storeAt]
  exact sc_muladd.wf3.alloca

theorem sc_muladd.room_s : Room sc_muladd.blocks.mem ⟨⟨1⟩, 0⟩ 256 :=
  (((Room.allocaPtr (w := 256) (s := sc_muladd.empty) (n := 32) (by decide)).alloca
          sc_muladd.wf1).alloca sc_muladd.wf2).alloca sc_muladd.wf3

theorem sc_muladd.room_a : Room sc_muladd.blocks.mem ⟨⟨2⟩, 0⟩ 256 :=
  ((Room.allocaPtr (w := 256) (s := sc_muladd.empty.alloca 32) (n := 32) (by decide)).alloca
      sc_muladd.wf2).alloca sc_muladd.wf3

theorem sc_muladd.room_b : Room sc_muladd.blocks.mem ⟨⟨3⟩, 0⟩ 256 :=
  (Room.allocaPtr (w := 256) (s := (sc_muladd.empty.alloca 32).alloca 32) (n := 32)
      (by decide)).alloca sc_muladd.wf3

theorem sc_muladd.room_c : Room sc_muladd.blocks.mem ⟨⟨4⟩, 0⟩ 256 :=
  Room.allocaPtr (w := 256) (s := ((sc_muladd.empty.alloca 32).alloca 32).alloca 32) (n := 32)
    (by decide)

theorem sc_muladd.witness_read_a (A B C : BitVec 256) :
    (sc_muladd.witness A B C).mem.readAt ⟨⟨2⟩, 0⟩ 256 = A := by
  simp only [sc_muladd.witness]
  rw [MemoryState.readAt_storeAt_disjoint (by simp [Range.Disjoint, Range.of]),
    MemoryState.readAt_storeAt_disjoint (by simp [Range.Disjoint, Range.of]),
    MemoryState.readAt_storeAt_self sc_muladd.room_a]

theorem sc_muladd.witness_read_b (A B C : BitVec 256) :
    (sc_muladd.witness A B C).mem.readAt ⟨⟨3⟩, 0⟩ 256 = B := by
  simp only [sc_muladd.witness]
  rw [MemoryState.readAt_storeAt_disjoint (by simp [Range.Disjoint, Range.of]),
    MemoryState.readAt_storeAt_self sc_muladd.room_b.storeAt]

theorem sc_muladd.witness_read_c (A B C : BitVec 256) :
    (sc_muladd.witness A B C).mem.readAt ⟨⟨4⟩, 0⟩ 256 = C := by
  simp only [sc_muladd.witness]
  rw [MemoryState.readAt_storeAt_self sc_muladd.room_c.storeAt.storeAt]

/-- The counterexample's inputs are `4ℓ - 1` and `4ℓ + 1`. -/
theorem sc_muladd.inputs_eq :
    0x40000000000000000000000000000000537be77a8bde735960498c6973d74fb3#256 =
        BitVec.ofNat 256 (4 * ell - 1) ∧
      0x40000000000000000000000000000000537be77a8bde735960498c6973d74fb5#256 =
        BitVec.ofNat 256 (4 * ell + 1) := by
  decide +kernel

/-- `sc_muladd` does not multiply and add modulo `ℓ`: on `a = 4ℓ - 1`, `b = 4ℓ + 1`, `c = 0` it
returns, having stored 32 bytes of `0xff`, while `a * b + c ≡ -1 (mod ℓ)`. -/
public theorem sc_muladd.not_mulAddModEll : ¬sc_muladd.MulAddModEll := by
  intro h
  obtain ⟨hA, hB⟩ := sc_muladd.inputs_eq
  have hs :
    Room
      (sc_muladd.witness (BitVec.ofNat 256 (4 * ell - 1)) (BitVec.ofNat 256 (4 * ell + 1)) 0).mem
      ⟨⟨1⟩, 0⟩ 256 :=
    sc_muladd.room_s.storeAt.storeAt.storeAt
  have hrun :=
    sc_muladd.call_counterexample ⟨⟨1⟩, 0⟩ ⟨⟨2⟩, 0⟩ ⟨⟨3⟩, 0⟩ ⟨⟨4⟩, 0⟩
      (sc_muladd.witness (BitVec.ofNat 256 (4 * ell - 1)) (BitVec.ofNat 256 (4 * ell + 1)) 0)
      (sc_muladd.witness_wf _ _ _) hs (by decide)
      ((Fits.storeAt_self sc_muladd.room_a).storeAt.storeAt) (by decide)
      ((Fits.storeAt_self sc_muladd.room_b.storeAt).storeAt) (by decide)
      (Fits.storeAt_self sc_muladd.room_c.storeAt.storeAt) (by decide) (by decide)
      (by rw [sc_muladd.witness_read_a, hA]) (by rw [sc_muladd.witness_read_b, hB])
      (sc_muladd.witness_read_c _ _ _)
  have := h _ _ _ _ _ _ _ _ (sc_muladd.witness_wf _ _ _) hs
    ((Fits.storeAt_self sc_muladd.room_a).storeAt.storeAt)
    ((Fits.storeAt_self sc_muladd.room_b.storeAt).storeAt)
    (Fits.storeAt_self sc_muladd.room_c.storeAt.storeAt) (by decide) (by decide) (by decide)
    (by decide) (by decide) (sc_muladd.witness_read_a _ _ _) (sc_muladd.witness_read_b _ _ _)
    (sc_muladd.witness_read_c _ _ _) _ _ hrun
  rw [MemoryState.readAt_storeAt_self hs] at this
  revert this
  decide +kernel

end MLIR.Wolfssl
