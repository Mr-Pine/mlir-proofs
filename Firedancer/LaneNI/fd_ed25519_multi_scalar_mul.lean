module

public import MLIR.Run.Tactic
public import Firedancer.LaneNI.fd_ed25519_point_set_zero
public import Firedancer.LaneNI.fd_ulong_min_35
public import Firedancer.LaneNI.fd_ed25519_multi_scalar_mul_with_opts
public import Firedancer.LaneNI.fd_ed25519_point_add
public import Firedancer.LaneNI.Mlir.fd_ed25519_multi_scalar_mul

namespace MLIR.Firedancer.LaneNI

open Firedancer.Avx512

/-! ## Specification

`Σ n[j] A[j]` in batches of 32 points (`FD_BALLET_ED25519_MSM_BATCH_SZ`), each batch's sum added
to `r`. -/

@[expose] public section

namespace fd_ed25519_multi_scalar_mul

/-- Batch `k`'s sum: `multi_scalar_mul_with_opts` of points `32k …`, at most 32 of them. -/
abbrev batch (x : Nat → BitVec 256) (A : Nat → Quad) (sz k : Nat) : Quad :=
  fd_ed25519_multi_scalar_mul_with_opts.spec (fun j => x (32 * k + j)) (fun j => A (32 * k + j))
    (min (sz - 32 * k) 32)

/-- `r` after `k` batches: `r = r + batch`, from the neutral point. -/
def acc (x : Nat → BitVec 256) (A : Nat → Quad) (sz : Nat) : Nat → Quad
  | 0 => fd_ed25519_point_set_zero.spec
  | k + 1 => fd_ed25519_point_add_with_opts.spec (acc x A sz k) (batch x A sz k) 0

/-- The blocks batch `k` allocates. -/
abbrev batchBlocks (x : Nat → BitVec 256) (sz k : Nat) : Nat :=
  fd_ed25519_multi_scalar_mul_with_opts.blocks (fun j => x (32 * k + j)) (min (sz - 32 * k) 32) + 15

/-- The blocks `k` batches allocate: `multi_scalar_mul_with_opts`'s and `point_add`'s fifteen. -/
def accBlocks (x : Nat → BitVec 256) (sz : Nat) : Nat → Nat
  | 0 => 0
  | k + 1 => accBlocks x sz k + batchBlocks x sz k

/-- `Σ n[j] A[j]` as the code computes it: `⌈sz / 32⌉` batches. -/
def spec (x : Nat → BitVec 256) (A : Nat → Quad) (sz : Nat) : Quad :=
  acc x A sz ((sz + 31) / 32)

/-- The blocks the function allocates, its callees' included: one local, and the batches'. -/
def blocks (x : Nat → BitVec 256) (sz : Nat) : Nat :=
  1 + accBlocks x sz ((sz + 31) / 32)

end fd_ed25519_multi_scalar_mul

end

/-! ## Proof -/

section Proof

namespace fd_ed25519_multi_scalar_mul

open _root_.Firedancer.LaneNI.Mlir.fd_ed25519_multi_scalar_mul

/-- The lift's runs from a block. -/
local notation "runM" => _root_.Firedancer.LaneNI.Mlir.fd_ed25519_multi_scalar_mul.runFrom

/-! ### Counters -/

/-- `sz - i` on counters that do not wrap. -/
theorem usubOverflow_ofNat64 {a b : Nat} (h : b ≤ a) (ha : a < 2 ^ 64) :
    (BitVec.ofNat 64 a).usubOverflow (BitVec.ofNat 64 b) = false := by
  simp [BitVec.usubOverflow]
  omega

/-- `sz - i` on counters that do not wrap. -/
theorem sub_ofNat64 {a b : Nat} (h : b ≤ a) :
    BitVec.ofNat 64 a - BitVec.ofNat 64 b = BitVec.ofNat 64 (a - b) := by
  apply BitVec.eq_of_toNat_eq
  simp [BitVec.toNat_sub]
  omega

/-- `fd_ulong_min( c, 32 )` on a small counter. -/
theorem min32_ofNat64 {c : Nat} (h : c < 2 ^ 64) :
    (if (BitVec.ofNat 64 c).ult 32#64 then BitVec.ofNat 64 c else 32#64) =
      BitVec.ofNat 64 (min c 32) := by
  split <;> rename_i hc <;> simp [BitVec.ult, Nat.mod_eq_of_lt h] at hc <;>
    [rw [Nat.min_eq_left (by omega)]; rw [Nat.min_eq_right (by omega)]]

/-- `i << 5` on a counter. -/
theorem shl5_ofNat64 {i : Nat} : BitVec.ofNat 64 i <<< 5 = BitVec.ofNat 64 (32 * i) := by
  apply BitVec.eq_of_toNat_eq
  rw [BitVec.toNat_shiftLeft, BitVec.toNat_ofNat, BitVec.toNat_ofNat, Nat.shiftLeft_eq]
  omega

/-- `i + 32` on a counter that does not wrap. -/
theorem add32_ofNat64 {k : Nat} :
    BitVec.ofNat 64 (32 * k) + 32#64 = BitVec.ofNat 64 (32 * (k + 1)) := by
  rw [show (32#64 : BitVec 64) = BitVec.ofNat 64 32 from rfl, ← BitVec.ofNat_add]
  rfl

/-- `i < sz` on counters that do not wrap. -/
theorem ult_ofNat64 {a b : Nat} (ha : a < 2 ^ 64) (hb : b < 2 ^ 64) :
    (BitVec.ofNat 64 a).ult (BitVec.ofNat 64 b) = decide (a < b) := by
  simp [BitVec.ult, Nat.mod_eq_of_lt ha, Nat.mod_eq_of_lt hb]

/-- A state's block counter advanced. -/
theorem WF.add_blocks_mk {m : MemoryState} (h : (⟨⟨B⟩, m⟩ : GlobalState).WF) :
    (⟨⟨B + k⟩, m⟩ : GlobalState).WF :=
  GlobalState.WF.add_blocks (s := ⟨⟨B⟩, m⟩) h

attribute [local mlir_transport] WF.add_blocks_mk

/-- Bits elsewhere are unaffected by `alloca`. -/
theorem readAt_alloca_of_ne {s : GlobalState} (hne : p.id ≠ s.allocaPtr.id) :
    (s.alloca k d).mem.readAt p w = s.mem.readAt p w := by
  simp only [MemoryState.readAt, GlobalState.getElem?_alloca hne]

/-! ### Memory -/

/-- The memory after `k` batches from `M`: `h` the last batch's sum, `r` their running sum. -/
def memAt (M : MemoryState) (r h : Pointer) (x : Nat → BitVec 256) (A : Nat → Quad) (sz : Nat) :
    Nat → MemoryState
  | 0 => M.storeQuad r fd_ed25519_point_set_zero.spec
  | k + 1 => (M.storeQuad h (batch x A sz k)).storeQuad r (acc x A sz (k + 1))

/-- What a batch needs of the memory before the loop. -/
structure LoopFacts (M : MemoryState) (r h n a : Pointer) (sz : Nat) (x : Nat → BitVec 256)
    (A : Nat → Quad) : Prop where
  roomR : M.QuadRoom r
  roomH : M.QuadRoom h
  rh : r.id ≠ h.id
  rn : r.id ≠ n.id
  ra : r.id ≠ a.id
  hn : h.id ≠ n.id
  ha : h.id ≠ a.id
  fitN : Fits M n (8 * 32 * sz)
  fitA : Fits M a (1536 * sz)
  x_eq : ∀ j, M.readAt (n.add (BitVec.ofNat 64 (32 * j))) 256 = x j
  A_eq : ∀ j, M.readQuad (a.add (BitVec.ofNat 64 (192 * j))) = A j

/-- Room for `r` after `k` batches. -/
theorem LoopFacts.roomR_at (h : LoopFacts M r hp n a sz x A) (k : Nat) :
    (memAt M r hp x A sz k).QuadRoom r := by
  cases k <;> simp only [memAt] <;> [exact h.roomR.storeQuad; exact h.roomR.storeQuad.storeQuad]

/-- Room for `h` after `k` batches. -/
theorem LoopFacts.roomH_at (h : LoopFacts M r hp n a sz x A) (k : Nat) :
    (memAt M r hp x A sz k).QuadRoom hp := by
  cases k <;> simp only [memAt] <;> [exact h.roomH.storeQuad; exact h.roomH.storeQuad.storeQuad]

/-- `r` a point after `k` batches. -/
theorem LoopFacts.fitR_at (h : LoopFacts M r hp n a sz x A) (k : Nat) :
    (memAt M r hp x A sz k).QuadFit r := by
  cases k <;> simp only [memAt] <;>
    [exact MemoryState.QuadFit.storeQuad_self h.roomR;
      exact MemoryState.QuadFit.storeQuad_self h.roomR.storeQuad]

/-- `r` after `k` batches: their running sum. -/
theorem LoopFacts.r_at (h : LoopFacts M r hp n a sz x A) (k : Nat) :
    (memAt M r hp x A sz k).readQuad r = acc x A sz k := by
  cases k <;> simp only [memAt] <;>
    [exact MemoryState.readQuad_storeQuad_self h.roomR;
      exact MemoryState.readQuad_storeQuad_self h.roomR.storeQuad]

/-- The scalars after `k` batches. -/
theorem LoopFacts.fitN_at (h : LoopFacts M r hp n a sz x A) (k : Nat) :
    Fits (memAt M r hp x A sz k) n (8 * 32 * sz) := by
  cases k <;> simp only [memAt] <;> [exact h.fitN.storeQuad; exact h.fitN.storeQuad.storeQuad]

/-- The points after `k` batches. -/
theorem LoopFacts.fitA_at (h : LoopFacts M r hp n a sz x A) (k : Nat) :
    Fits (memAt M r hp x A sz k) a (1536 * sz) := by
  cases k <;> simp only [memAt] <;> [exact h.fitA.storeQuad; exact h.fitA.storeQuad.storeQuad]

/-- Scalar `j` after `k` batches. -/
theorem LoopFacts.x_at (h : LoopFacts M r hp n a sz x A) (k j : Nat) :
    (memAt M r hp x A sz k).readAt (n.add (BitVec.ofNat 64 (32 * j))) 256 = x j := by
  have hr : r.id ≠ (n.add (BitVec.ofNat 64 (32 * j))).id := by simpa [Pointer.add_id] using h.rn
  have hh : hp.id ≠ (n.add (BitVec.ofNat 64 (32 * j))).id := by simpa [Pointer.add_id] using h.hn
  cases k <;> simp only [memAt] <;>
    simp only [MemoryState.readAt_storeQuad_of_id_ne hr, MemoryState.readAt_storeQuad_of_id_ne hh,
      h.x_eq]

/-- Point `j` after `k` batches. -/
theorem LoopFacts.A_at (h : LoopFacts M r hp n a sz x A) (k j : Nat) :
    (memAt M r hp x A sz k).readQuad (a.add (BitVec.ofNat 64 (192 * j))) = A j := by
  have hr : r.id ≠ (a.add (BitVec.ofNat 64 (192 * j))).id := by simpa [Pointer.add_id] using h.ra
  have hh : hp.id ≠ (a.add (BitVec.ofNat 64 (192 * j))).id := by simpa [Pointer.add_id] using h.ha
  cases k <;> simp only [memAt] <;>
    simp only [MemoryState.readQuad_storeQuad_of_id_ne hr,
      MemoryState.readQuad_storeQuad_of_id_ne hh, h.A_eq]

/-- A batch's stores at `h` and `r`. -/
theorem LoopFacts.memAt_succ (h : LoopFacts M r hp n a sz x A) (k : Nat) :
    ((memAt M r hp x A sz k).storeQuad hp (batch x A sz k)).storeQuad r (acc x A sz (k + 1)) =
      memAt M r hp x A sz (k + 1) := by
  cases k with
  | zero =>
    simp only [memAt]
    rw [MemoryState.storeQuad_comm h.rh, MemoryState.storeQuad_storeQuad_self h.roomR.1]
  | succ k =>
    simp only [memAt]
    rw [MemoryState.storeQuad_comm h.rh, MemoryState.storeQuad_storeQuad_self h.roomH.1,
      MemoryState.storeQuad_storeQuad_self h.roomR.1]

/-! ### The loop -/

/-- `^bb2`, batch `k`: `h` its sum, `r = r + h`; then around, or out to `^bb1` after the last. -/
theorem batch_block (r n a hp : Pointer) (sz : Nat) (x : Nat → BitVec 256) (A : Nat → Quad)
    (M : MemoryState) (hM : LoopFacts M r hp n a sz x A) (hno : n.offset.toNat + 32 * sz < 2 ^ 64)
    (hao : a.offset.toNat + 192 * sz < 2 ^ 63) (g : Vals [.ptr] × GlobalState → PoisonOr β)
    (K : PoisonOr β) (k : Nat) (hk : 32 * k < sz) (B : Nat) (E : ⟪Γ⟫)
    (hArgs : E.args = (args (.value r) (.value n) (.value a) (.value (BitVec.ofNat 64 sz))).get)
    (hR : E ⊨ [%1 := 0#64, %2 := 5#64, %3 := 32#64, %4 := hp, %7 := BitVec.ofNat 64 (32 * k)])
    (hwf : (⟨⟨B⟩, memAt M r hp x A sz k⟩ : GlobalState).WF)
    (hback :
      32 * (k + 1) < sz →
        ∀ E' : ⟪Γ⟫,
          E'.args = (args (.value r) (.value n) (.value a) (.value (BitVec.ofNat 64 sz))).get →
            (E' ⊨ [%1 := 0#64, %2 := 5#64, %3 := 32#64, %4 := hp,
              %7 := BitVec.ofNat 64 (32 * (k + 1))]) →
            (⟨⟨B + batchBlocks x sz k⟩, memAt M r hp x A sz (k + 1)⟩ : GlobalState).WF →
            (runM E' ^bb2 ⟨⟨B + batchBlocks x sz k⟩, memAt M r hp x A sz (k + 1)⟩ >>= g) = K)
    (hexit :
      ¬32 * (k + 1) < sz →
        ∀ E' : ⟪Γ⟫,
          E'.args = (args (.value r) (.value n) (.value a) (.value (BitVec.ofNat 64 sz))).get →
            (E' ⊨ [%4 := hp]) →
            (⟨⟨B + batchBlocks x sz k⟩, memAt M r hp x A sz (k + 1)⟩ : GlobalState).WF →
            (runM E' ^bb1 ⟨⟨B + batchBlocks x sz k⟩, memAt M r hp x A sz (k + 1)⟩ >>= g) = K) :
    (runM E ^bb2 ⟨⟨B⟩, memAt M r hp x A sz k⟩ >>= g) = K := by
  have hsz : sz < 2 ^ 59 := by omega
  have hr := hM.roomR_at k
  have hh := hM.roomH_at k
  have hrf := hM.fitR_at k
  have hrv := hM.r_at k
  have hb : min (sz - 32 * k) 32 ≤ 32 := Nat.min_le_right _ _
  have hn' : Fits (memAt M r hp x A sz k) (n.add (BitVec.ofNat 64 (32 * (32 * k))))
      (8 * 32 * min (sz - 32 * k) 32) :=
    Fits.add_of_le (by simp [BitVec.uaddOverflow]; omega)
      (by rw [BitVec.toNat_ofNat, Nat.mod_eq_of_lt (by omega)]; omega) (hM.fitN_at k)
  have ha' : Fits (memAt M r hp x A sz k) (a.add (BitVec.ofNat 64 (32 * k * 192)))
      (1536 * min (sz - 32 * k) 32) :=
    Fits.add_of_le (by simp [BitVec.uaddOverflow]; omega)
      (by rw [BitVec.toNat_ofNat, Nat.mod_eq_of_lt (by omega)]; omega) (hM.fitA_at k)
  have hno' : (n.add (BitVec.ofNat 64 (32 * (32 * k)))).offset.toNat + 32 * min (sz - 32 * k) 32 <
      2 ^ 64 := by
    simp only [Pointer.add, BitVec.toNat_add, BitVec.toNat_ofNat]
    omega
  have hao' : (a.add (BitVec.ofNat 64 (32 * k * 192))).offset.toNat +
      192 * min (sz - 32 * k) 32 < 2 ^ 64 := by
    simp only [Pointer.add, BitVec.toNat_add, BitVec.toNat_ofNat]
    omega
  have hnov : ¬n.offset.uaddOverflow (BitVec.ofNat 64 (32 * (32 * k))) := by
    simp [BitVec.uaddOverflow]
    omega
  have haov : ¬a.offset.uaddOverflow (BitVec.ofNat 64 (32 * k * 192)) := by
    simp [BitVec.uaddOverflow]
    omega
  have hlt : 0 + (BitVec.ofNat 64 (32 * k)).toNat * 192 < 2 ^ 63 := by
    rw [BitVec.toNat_ofNat, Nat.mod_eq_of_lt (by omega)]
    omega
  have hX : (fun j => (memAt M r hp x A sz k).readAt
      ((n.add (BitVec.ofNat 64 (32 * (32 * k)))).add (BitVec.ofNat 64 (32 * j))) 256) =
      fun j => x (32 * k + j) := by
    funext j
    rw [add_ofNat_add, ← Nat.mul_add, hM.x_at]
  have hY : (fun j => (memAt M r hp x A sz k).readQuad
      ((a.add (BitVec.ofNat 64 (32 * k * 192))).add (BitVec.ofNat 64 (192 * j)))) =
      fun j => A (32 * k + j) := by
    funext j
    rw [add_ofNat_add, show 32 * k * 192 + 192 * j = 192 * (32 * k + j) by omega, hM.A_at]
  block_init
  step_pure [usubOverflow_ofNat64 (le_of_lt hk) (show sz < 2 ^ 64 by omega),
    sub_ofNat64 (le_of_lt hk)]
  step_call using Firedancer.LaneNI.Mlir.fd_ulong_min_35.call_eq
    [min32_ofNat64 (show sz - 32 * k < 2 ^ 64 by omega)]
  step_pure [shl5_ofNat64]
  step_pure [gep_value (f := { nuw := true }) hnov (Or.inl rfl)]
  step_pure [gepDyn_of_lt (f := { nusw := true, nuw := true }) rfl hlt,
    Nat.mod_eq_of_lt (show 32 * k < 2 ^ 64 by omega),
    gep_value (f := { nuw := true }) haov (Or.inl rfl)]
  step_call using Firedancer.LaneNI.Mlir.fd_ed25519_multi_scalar_mul_with_opts.call_eq
  step_call using Firedancer.LaneNI.Mlir.fd_ed25519_point_add.call_eq
  step_pure [add32_ofNat64]
  step_pure [ult_ofNat64 (show 32 * (k + 1) < 2 ^ 64 by omega) (show sz < 2 ^ 64 by omega)]
  finish_block
  all_goals
    have hS' : S = ⟨⟨B + batchBlocks x sz k⟩, memAt M r hp x A sz (k + 1)⟩ := by
      rw [hS, hX, hY,
        MemoryState.readQuad_storeQuad_of_id_ne hM.rh.symm, hM.r_at, ← hM.memAt_succ k]
      simp only [batchBlocks, Nat.add_assoc]
      rfl
    subst hS'
  all_goals
    have hwf' :
        (⟨⟨B + batchBlocks x sz k⟩, memAt M r hp x A sz (k + 1)⟩ : GlobalState).WF := by
      rw [← hM.memAt_succ k]
      exact (WF.add_blocks_mk hwf).storeQuad_mk.storeQuad_mk
  case isTrue => exact hback (by simpa using hbr) E hArgs (by env_reads) hwf'
  case isFalse => exact hexit (by simpa using hbr) E hArgs (by env_reads) hwf'

/-- The loop from `^bb2` at batch `k`: the batches `k …`; at `^bb1`, `r` holds `spec`. -/
theorem batch_loop (r n a hp : Pointer) (sz : Nat) (x : Nat → BitVec 256) (A : Nat → Quad)
    (M : MemoryState) (hM : LoopFacts M r hp n a sz x A) (hno : n.offset.toNat + 32 * sz < 2 ^ 64)
    (hao : a.offset.toNat + 192 * sz < 2 ^ 63) (g : Vals [.ptr] × GlobalState → PoisonOr β)
    (K : PoisonOr β) (B : Nat) :
    ∀ m k (E : ⟪Γ⟫), k + m = (sz + 31) / 32 → 32 * k < sz →
      E.args = (args (.value r) (.value n) (.value a) (.value (BitVec.ofNat 64 sz))).get →
      (E ⊨ [%1 := 0#64, %2 := 5#64, %3 := 32#64, %4 := hp, %7 := BitVec.ofNat 64 (32 * k)]) →
      (⟨⟨B + accBlocks x sz k⟩, memAt M r hp x A sz k⟩ : GlobalState).WF →
      (∀ E' : ⟪Γ⟫,
        E'.args = (args (.value r) (.value n) (.value a) (.value (BitVec.ofNat 64 sz))).get →
          (E' ⊨ [%4 := hp]) →
          (⟨⟨B + accBlocks x sz ((sz + 31) / 32)⟩, memAt M r hp x A sz ((sz + 31) / 32)⟩ :
              GlobalState).WF →
          (runM E' ^bb1
                ⟨⟨B + accBlocks x sz ((sz + 31) / 32)⟩, memAt M r hp x A sz ((sz + 31) / 32)⟩ >>=
              g) = K) →
      (runM E ^bb2 ⟨⟨B + accBlocks x sz k⟩, memAt M r hp x A sz k⟩ >>= g) = K := by
  intro m
  induction m with
  | zero => intro k E hm hk; omega
  | succ m ih =>
    intro k E hm hk hArgs hR hwf hK
    refine batch_block r n a hp sz x A M hM hno hao g K k hk _ E hArgs hR hwf ?_ ?_
    · intro hk' E' h' hR' hwf'
      have hB : B + accBlocks x sz k + batchBlocks x sz k = B + accBlocks x sz (k + 1) := by
        simp only [accBlocks, Nat.add_assoc]
      rw [hB] at hwf' ⊢
      exact ih (k + 1) E' (by omega) hk' h' hR' hwf' hK
    · intro hk' E' h' hR' hwf'
      obtain hK1 : k + 1 = (sz + 31) / 32 := by omega
      have hB : B + accBlocks x sz (k + 1) = B + accBlocks x sz k + batchBlocks x sz k := by
        simp only [accBlocks, Nat.add_assoc]
      rw [← hK1, hB] at hK
      exact hK E' h' hR' hwf'

end fd_ed25519_multi_scalar_mul

open fd_ed25519_multi_scalar_mul in
/-- `fd_ed25519_multi_scalar_mul` stores `spec` of the `sz` scalars at `n`, 32 bytes apart, and
points at `a`, 192 bytes apart, at `r` and returns `r`; `r` is apart from the inputs. The block
counter advances by `blocks`. -/
public theorem _root_.Firedancer.LaneNI.Mlir.fd_ed25519_multi_scalar_mul.call_eq
    (r n a : Pointer) (sz : Nat) (s : GlobalState) (hwf : s.WF) (hr : s.mem.QuadRoom r)
    (hn : Fits s.mem n (8 * 32 * sz)) (hno : n.offset.toNat + 32 * sz < 2 ^ 64)
    (ha : Fits s.mem a (1536 * sz)) (hao : a.offset.toNat + 192 * sz < 2 ^ 63)
    (hrn : r.id ≠ n.id) (hra : r.id ≠ a.id) :
    _root_.Firedancer.LaneNI.Mlir.fd_ed25519_multi_scalar_mul.call
        (_root_.Firedancer.LaneNI.Mlir.fd_ed25519_multi_scalar_mul.args (.value r) (.value n)
          (.value a) (.value (BitVec.ofNat 64 sz))) s =
      .value
        (.cons (.value r) .nil,
          { alloc :=
              ⟨s.alloc.nextFreeBlock +
                  blocks (fun j => s.mem.readAt (n.add (BitVec.ofNat 64 (32 * j))) 256) sz⟩,
            mem :=
              s.mem.storeQuad r
                (spec (fun j => s.mem.readAt (n.add (BitVec.ofNat 64 (32 * j))) 256)
                  (fun j => s.mem.readQuad (a.add (BitVec.ofNat 64 (192 * j)))) sz) }) := by
  generalize hP :
    spec (fun j => s.mem.readAt (n.add (BitVec.ofNat 64 (32 * j))) 256)
      (fun j => s.mem.readQuad (a.add (BitVec.ofNat 64 (192 * j)))) sz = P
  generalize hk : blocks (fun j => s.mem.readAt (n.add (BitVec.ofNat 64 (32 * j))) 256) sz = k
  have hP' := hP
  have hk' := hk
  func_init
  block_init
  iterate 4 step_pure
  step_alloca with hp
  step_pure
  step_call using Firedancer.LaneNI.Mlir.fd_ed25519_point_set_zero.call_eq
  step_pure
  finish_block
  case isTrue =>
    obtain rfl : sz = 0 := by
      have := congrArg BitVec.toNat hbr
      simp only [BitVec.toNat_ofNat, Nat.mod_eq_of_lt (show sz < 2 ^ 64 by omega)] at this
      exact this
    clear hP' hk'
    block_init
    step_pure
    finish_block
    rw [← hP, ← hk]
    subst hS
    dsimp only
    rw [MemoryState.eraseFrom_lifetimeEnd_of_le
        (show S₀.alloc.nextFreeBlock ≤ hp.id.id by slot_bound),
      MemoryState.eraseFrom_storeQuad]
    erase_frame
    simp only [GlobalState.alloca, blocks, spec, show (0 + 31) / 32 = 0 from rfl, acc, accBlocks]
  case isFalse =>
    have hsz : 0 < sz := Nat.pos_of_ne_zero fun h => hbr (by rw [h])
    clear hP' hk'
    have hpa : hp = S₀.allocaPtr := by rw [hhp, GlobalState.allocaPtr_eq_slot]
    have hfr : S₀.mem.eraseFrom S₀.alloc.nextFreeBlock = S₀.mem :=
      congrArg GlobalState.mem (GlobalState.eraseFrom_self hwf₀)
    have hM : LoopFacts ((S₀.alloca 192 true).mem.lifetimeStart hp) r hp n a sz
        (fun j => S₀.mem.readAt (n.add (BitVec.ofNat 64 (32 * j))) 256)
        (fun j => S₀.mem.readQuad (a.add (BitVec.ofNat 64 (192 * j)))) :=
      { roomR :=
          MemoryState.QuadRoom.of_storeQuad (P := fd_ed25519_point_set_zero.spec) (p := r)
            (by subst hS; assumption)
        roomH :=
          MemoryState.QuadRoom.of_storeQuad (P := fd_ed25519_point_set_zero.spec) (p := r)
            (by subst hS; exact MemoryState.QuadRoom.of_room hroom_hp hhp_off)
        rh := hr_ne_hp
        rn := hrn
        ra := hra
        hn := hn_ne_hp.symm
        ha := ha_ne_hp.symm
        fitN := (hn₀.alloca hwf₀).lifetimeStart hn_ne_hp
        fitA := (ha₀.alloca hwf₀).lifetimeStart ha_ne_hp
        x_eq := fun j => by
          rw [MemoryState.readAt_lifetimeStart, readAt_alloca_of_ne]
          simpa [Pointer.add_id, ← hpa] using hn_ne_hp
        A_eq := fun j => by
          rw [MemoryState.readQuad_lifetimeStart, MemoryState.readQuad_alloca]
          simpa [Pointer.add_id, ← hpa] using ha_ne_hp }
    subst hS
    refine
      batch_loop r n a hp sz _ _ _ hM hno hao _ _ (S₀.alloc.nextFreeBlock + 1) ((sz + 31) / 32) 0 E
        (by omega) (by omega) hArgs (by env_reads) hwf fun E' h' hR' hwf' => ?_
    obtain ⟨K, hK⟩ : ∃ K, (sz + 31) / 32 = K + 1 := ⟨(sz + 31) / 32 - 1, by omega⟩
    rw [hK] at hwf' ⊢
    simp only [memAt] at hwf' ⊢
    block_init
    step_pure
    finish_block
    rw [← hP, ← hk]
    subst hS
    dsimp only
    rw [← hpa, MemoryState.eraseFrom_lifetimeEnd_of_le
        (show S₀.alloc.nextFreeBlock ≤ hp.id.id by slot_bound),
      MemoryState.eraseFrom_storeQuad,
      MemoryState.eraseFrom_storeQuad_of_le (show S₀.alloc.nextFreeBlock ≤ hp.id.id by slot_bound)]
    erase_frame
    simp only [blocks, spec, hK, Nat.add_assoc, hfr]

end Proof

end MLIR.Firedancer.LaneNI
