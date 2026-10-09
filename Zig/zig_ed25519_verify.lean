module

public import MLIR.Run.Tactic
public import Common.Tactics
public import Zig.Steps
public import Zig.Verifier_init
public import Zig.Sha512_update
public import Zig.Sha512_frame
public import Zig.Verifier_verify
public import Zig.Edwards25519_identityElement
public import Zig.Edwards25519_precompute
public import Zig.Math.Decode
public import Zig.Math.Reduce64Link
public import Zig.Mlir.zig_ed25519_verify
import all Zig.Edwards25519_fromBytes
import Std.Tactic.BVDecide

namespace MLIR.Zig

open _root_.Ed25519

/-! ## Specification -/

@[expose] public section

namespace ZigVerify

/-- `verify`'s code once `init` returned `c` with the decoded points, `M` absorbed. -/
def codeOf (c : BitVec 16) (M : List (BitVec 8)) (S : BitVec 256) :
    Option ZPt → Option ZPt → BitVec 16
  | some a, some R => if c = 0#16 then Verifier.verify.code M S a R else c
  | _, _ => c

/-- The blocks `update` and `verify` allocate after `init`. -/
def blocksOf (c : BitVec 16) (M : List (BitVec 8)) (S : BitVec 256) : Option ZPt → Option ZPt → Nat
  | some a, some R => if c = 0#16 then 2 * (M.length / 128) + Verifier.verify.blocks M S a R else 0
  | _, _ => 0

/-- `zig_ed25519_verify`'s error code: `init`'s, else `verify`'s on `r ‖ A ‖ msg`. -/
def code (msg : List (BitVec 8)) (r S A : BitVec 256) : BitVec 16 :=
  codeOf (Verifier.init.code r S A) (bytesLE r ++ bytesLE A ++ msg) S
    (Edwards25519.fromBytes.spec A) (Edwards25519.fromBytes.spec r)

/-- The blocks it allocates. -/
def blocks (msg : List (BitVec 8)) (r S A : BitVec 256) : Nat :=
  4 + Verifier.init.blocks r S A +
    blocksOf (Verifier.init.code r S A) (bytesLE r ++ bytesLE A ++ msg) S
      (Edwards25519.fromBytes.spec A) (Edwards25519.fromBytes.spec r)

theorem codeOf_ne {c : BitVec 16} (h : c ≠ 0#16) (M S oa oR) : codeOf c M S oa oR = c := by
  cases oa <;> cases oR <;> simp [codeOf, h]

theorem blocksOf_ne {c : BitVec 16} (h : c ≠ 0#16) (M S oa oR) : blocksOf c M S oa oR = 0 := by
  cases oa <;> cases oR <;> simp [blocksOf, h]

end ZigVerify

end

/-! ## Proof -/

section Proof

/-- A read inside a block copied whole: the source's. -/
theorem readAt_of_copy {m₀ m : MemoryState} {p q : Pointer} {W : Nat} (hq : Fits m q W)
    (hp : Fits m₀ p W) (hc : m.readAt q W = m₀.readAt p W) {off : BitVec 64}
    (hovq : ¬q.offset.uaddOverflow off) (hovp : ¬p.offset.uaddOverflow off)
    (hw : off.toNat * 8 + w ≤ W) : m.readAt (q.add off) w = m₀.readAt (p.add off) w := by
  rw [MemoryState.readAt_add_of_readAt hq hovq hw hc,
    MemoryState.readAt_add_of_readAt hp hovp hw rfl]

/-- The same from the start. -/
theorem readAt_of_copy0 {m₀ m : MemoryState} {p q : Pointer} {W : Nat}
    (hc : m.readAt q W = m₀.readAt p W) (hw : w ≤ W) : m.readAt q w = m₀.readAt p w := by
  rw [MemoryState.readAt_of_readAt_le hw hc, MemoryState.readAt_of_readAt_le hw rfl]

/-- A state with its counter given. -/
theorem GlobalState.eta_alloc {s : GlobalState} {n : Nat} (h : s.alloc.nextFreeBlock = n) :
    s = { alloc := ⟨n⟩, mem := s.mem } := by
  obtain ⟨⟨k⟩, m⟩ := s
  subst h; rfl

/-- `0 - zext c` does not overflow for a 16-bit code. -/
theorem neg_code_noOverflow (c : BitVec 16) :
    (0#32).ssubOverflow (BitVec.setWidth 32 c) = false := by bv_decide

@[mlir_mem, mlir_transport]
theorem Fits.initMem {m : MemoryState} {out q : Pointer} {r S A : BitVec 256} (h : Fits m q w) :
    Fits (Verifier.init.mem m out r S A) q w :=
  Verifier.init.fits_mem.mpr h

attribute [local mlir_mem, local mlir_transport] Verifier.init.wf

@[mlir_mem, mlir_transport]
theorem Fits.updatePost {s : GlobalState} {d b q : Pointer} {n : BitVec 64} (h : Fits s.mem q w) :
    Fits (Sha512_update.post s d b n).mem q w :=
  Sha512_update.post_fits.mpr h

attribute [local mlir_mem, local mlir_transport] Sha512_update.post_wf

@[mlir_mem, mlir_transport]
theorem Fits.finalMem {m : MemoryState} {d q : Pointer} (h : Fits m q w) :
    Fits (Verifier.verify.finalMem m d) q w :=
  finalMem_fits.mpr h

@[mlir_mem, mlir_transport]
theorem GlobalState.WF.finalMem {s : GlobalState} {d : Pointer} (hwf : s.WF) (k : Nat) :
    ({ alloc := ⟨s.alloc.nextFreeBlock + k⟩, mem := Verifier.verify.finalMem s.mem d } :
        GlobalState).WF := by
  have hb : (⟨⟨s.alloc.nextFreeBlock + k⟩, s.mem⟩ : GlobalState).WF :=
    ⟨fun j hj => Nat.lt_of_lt_of_le (hwf.bound j hj) (Nat.le_add_right _ _),
      Nat.lt_of_lt_of_le hwf.pos (Nat.le_add_right _ _), hwf.null⟩
  exact finalMem_wf hb d

@[mlir_read]
theorem MemoryState.readAt_initMem_of_id_ne {m : MemoryState} {out q : Pointer} {r S A : BitVec 256}
    (h : out.id ≠ q.id) : (Verifier.init.mem m out r S A).readAt q w = m.readAt q w := by
  have hd (p : Pointer) (hp : p.id = out.id) (v : Nat) :
    (Range.of p v).Disjoint (Range.of q w) := by
    simp only [Range.Disjoint, Range.of];
    exact
      .inl
        (by
          rw [hp]; exact h)
  unfold Verifier.init.mem
  split
  · rw [MemoryState.readAt_storeAt_disjoint (hd _ rfl _),
      MemoryState.readAt_storeAt_disjoint (hd _ (by simp [Pointer.add]) _)]
  · rw [MemoryState.readAt_storeAt_disjoint (hd _ (by simp [Pointer.add]) _)]

/-- `Verifier_init.call_eq` on the bytes `r`, `S`, `A` read at `sig`, `sig + 32`, `pk`. -/
theorem Verifier_init.call_eq_of (out sig pk : Pointer) (s : GlobalState) (hwf : s.WF)
    (hout : Fits s.mem out 4752) (hoo : out.offset.toNat + 594 ≤ 2 ^ 64) (hsig : Fits s.mem sig 512)
    (hso : sig.offset.toNat + 64 < 2 ^ 64) (hpk : Fits s.mem pk 256)
    (hpo : pk.offset.toNat + 32 < 2 ^ 64) (hr : s.mem.readAt sig 256 = r)
    (hS : s.mem.readAt (sig.add 32#64) 256 = S) (hA : s.mem.readAt pk 256 = A) :
    Verifier_init.call (Verifier_init.args (.value out) (.value sig) (.value pk)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + Verifier.init.blocks r S A⟩,
            mem := Verifier.init.mem s.mem out r S A }) := by
  subst hr hS hA
  exact Verifier_init.call_eq out sig pk s hwf hout hoo hsig hso hpk hpo

/-- The return block: `0 - zext c` for the code `c` it is passed. -/
theorem ret_block (g : Vals [.bv 32] × GlobalState → PoisonOr β) (K : PoisonOr β) (S : GlobalState)
    (E : ⟪zig_ed25519_verify.Γ⟫) (c : BitVec 16) (hR : E ⊨ [%4 := 0#32, %15 := c])
    (hK : g (.cons (.value (-(c.setWidth 32))) .nil, S) = K) :
    (zig_ed25519_verify.runFrom E ^bb2 S >>= g) = K := by
  block_init
  iterate 4 step_pure
  finish_block
  rw [neg_code_noOverflow]
  exact hK

set_option maxHeartbeats 4000000 in
/-- `zig_ed25519_verify` returns `-code` for `ZigVerify.code` on the message, `r`, `S` and the key,
and leaves memory as it found it. -/
public theorem zig_ed25519_verify.call_eq (msg : Pointer) (len : BitVec 64) (sig pk : Pointer)
    (s : GlobalState) (hwf : s.WF) (hmsg : Fits s.mem msg (8 * len.toNat))
    (hmo : msg.offset.toNat + len.toNat < 2 ^ 64) (hsig : Fits s.mem sig 512)
    (hso : sig.offset.toNat + 64 < 2 ^ 64) (hpk : Fits s.mem pk 256)
    (hpo : pk.offset.toNat + 32 < 2 ^ 64) (hlen : len.toNat + 128 < 2 ^ 64) :
    zig_ed25519_verify.call
        (zig_ed25519_verify.args (.value msg) (.value len) (.value sig) (.value pk)) s =
      let x :=
        ZigVerify.code (bytesLE (s.mem.readAt msg (8 * len.toNat))) (s.mem.readAt sig 256)
          (s.mem.readAt (sig.add 32#64) 256) (s.mem.readAt pk 256)
      let n :=
        ZigVerify.blocks (bytesLE (s.mem.readAt msg (8 * len.toNat))) (s.mem.readAt sig 256)
          (s.mem.readAt (sig.add 32#64) 256) (s.mem.readAt pk 256)
      .value
        (.cons (.value (-(x.setWidth 32))) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + n⟩, mem := s.mem }) := by
  func_init
  have hsig32 : Fits S.mem (sig.add 32#64) 256 :=
    Fits.add_of_le
      (by
        simp only [BitVec.uaddOverflow]; simp; omega)
      (by decide) hsig
  generalize hr : S₀.mem.readAt sig 256 = r at *
  generalize hSv : S₀.mem.readAt (sig.add 32#64) 256 = Sv at *
  generalize hA : S₀.mem.readAt pk 256 = A at *
  generalize hM : S₀.mem.readAt msg (8 * len.toNat) = M at *
  have hread_r : S.mem.readAt sig 256 = r := by
    rw [hS]; exact hr
  have hread_A : S.mem.readAt pk 256 = A := by
    rw [hS]; exact hA
  have hread_M : S.mem.readAt msg (8 * len.toNat) = M := by
    rw [hS]; exact hM
  have hSv' : S.mem.readAt (sig.add 32#64) 256 = Sv := by
    rw [hS]; exact hSv
  clear hr hA hM hSv
  block_init
  iterate 5 step_pure
  step_alloca with vi
  step_alloca with v1
  step_alloca with v2
  step_alloca with sg
  step_memcpy
  step_pure
  step_pure
  step_memcpy
  -- the copied `S`, as named
  have eS :
    ((((S₀.alloca 608).alloca 592).alloca 592).alloca 64).mem.readAt (sig.add 32#64) 256 = Sv := by
    have hd (q : Pointer) (hq : q.id = sg.id) (w : Nat) :
      (Range.of q w).Disjoint (Range.of (sig.add 32#64) 256) := by
      simp only [Range.Disjoint, Range.of, Pointer.add];
      exact
        .inl
          (by
            rw [hq]; exact hsig_ne_sg.symm)
    rw [← hSv', hS]
    dsimp only
    rw [MemoryState.readAt_storeAt_disjoint (hd _ (by simp [Pointer.add]) _),
      MemoryState.readAt_storeAt_disjoint (hd _ rfl _)]
  rw [eS] at hS hread_sg_32
  clear eS hSv'
  -- the copy's halves, as named
  have hsg64 := hsg_fits
  have e_r : S.mem.readAt sg 256 = r := by
    rw [hS]; dsimp only
    rw [MemoryState.readAt_storeAt_disjoint
        (by simp [Range.Disjoint, Range.of, Pointer.add, Pointer.offsetInBits, hsg_off]),
      MemoryState.readAt_storeAt_self
        (by
          rw [hS] at hsg64;
          exact (Fits.storeAt_iff.mp (Fits.storeAt_iff.mp hsg64)).mono (by decide))]
  iterate 3 step_pure
  have f1 : Fits S.mem vi 4752 := hvi_fits.mono (by decide)
  have f2 : vi.offset.toNat + 594 ≤ 2 ^ 64 := by
    rw [hvi_off]; decide
  have f3 : sg.offset.toNat + 64 < 2 ^ 64 := by
    rw [hsg_off]; decide
  have hvi592 := f1
  have hvio := f2
  step_call using Verifier_init.call_eq_of consuming f3 e_r hread_sg_32
  have f1 : Fits S.mem vi 4736 := hvi_fits.mono (by decide)
  step_memcpy consuming f1
  step_pure
  step_load with cd
  rw [Verifier.init.readAt_mem_code ?_ hvio] at hcd
  swap
  · have h := hvi592; rw [hS] at h; simpa only [Fits.storeAt_iff, Verifier.init.fits_mem] using h
  subst hcd
  iterate 2 step_pure
  finish_block
  case isFalse =>
    refine ret_block _ _ S E _ (by env_reads) ?_
    dsimp only
    rw [hS]
    erase_frame
    rw [Verifier.init.eraseFrom_mem_of_le
        (by
          subst hvi; simp [GlobalState.slot_id_id])]
    erase_frame
    simp only [ZigVerify.code, ZigVerify.blocks, ZigVerify.codeOf_ne hbr, ZigVerify.blocksOf_ne hbr,
      GlobalState.alloca]
    rw [show
        S₀.alloc.nextFreeBlock + 1 + 1 + 1 + 1 + Verifier.init.blocks r Sv A =
          S₀.alloc.nextFreeBlock + (4 + Verifier.init.blocks r Sv A + 0)
        by omega]
  case isTrue =>
    block_init
    have f1 := hv2_fits
    have f2 := hv1_fits
    step_memcpy consuming f1 f2
    -- init's results, carried to `v2`
    have hfM :
      Fits
        (((((((S₀.alloca 608).alloca 592).alloca 592).alloca 64).mem.storeAt sg r).storeAt
          (sg.add 32#64) Sv))
        vi 4752 := by
      have h := hvi592; rw [hS] at h
      simp only [Fits.storeAt_iff, Verifier.init.fits_mem] at h
      exact Fits.storeAt (Fits.storeAt h)
    obtain ⟨a, R, hsA, hsR, -, hH, hPa, ha, hra, hPR, hR, hrR, hSb⟩ :=
      Verifier.init.mem_ok (r := r) (S := Sv) (A := A) hfM hvio hbr
    have hY :
      Fits
        (Verifier.init.mem
          (((((((S₀.alloca 608).alloca 592).alloca 592).alloca 64).mem.storeAt sg r).storeAt
            (sg.add 32#64) Sv))
          vi r Sv A)
        vi 4736 :=
      Verifier.init.fits_mem.mpr (hfM.mono (by decide))
    have hv2f : Fits S.mem v2 4736 := hv2_fits
    have hv2 :
      S.mem.readAt v2 4736 =
        (Verifier.init.mem
              (((((((S₀.alloca 608).alloca 592).alloca 592).alloca 64).mem.storeAt sg r).storeAt
                (sg.add 32#64) Sv))
              vi r Sv A).readAt
          vi 4736 := by
      have h := hv2f; rw [hS] at h ⊢; dsimp only at h ⊢
      exact MemoryState.readAt_storeAt_self (Fits.storeAt_iff.mp h) _
    have hov (q : Pointer) (hq : q.offset = 0) (k : Nat) (hk : k < 600) :
      ¬q.offset.uaddOverflow (BitVec.ofNat 64 k) := by
      simp only [BitVec.uaddOverflow, hq, BitVec.toNat_ofNat]; simp; omega
    have hH2 : S.mem.readAt v2 1792 = Verifier.init.hashBits r A :=
      (readAt_of_copy0 hv2 (by decide)).trans hH
    have hpt (off : Nat) (hoff : off * 8 + 1344 ≤ 4736) (P : ZPt)
      (hP :
        (Verifier.init.mem
              (((((((S₀.alloca 608).alloca 592).alloca 592).alloca 64).mem.storeAt sg r).storeAt
                (sg.add 32#64) Sv))
              vi r Sv A).PtFit
          (vi.add (BitVec.ofNat 64 off)))
      (hp :
        (Verifier.init.mem
                (((((((S₀.alloca 608).alloca 592).alloca 592).alloca 64).mem.storeAt sg r).storeAt
                  (sg.add 32#64) Sv))
                vi r Sv A).readPt
            (vi.add (BitVec.ofNat 64 off)) =
          P)
      (hr :
        (Verifier.init.mem
                (((((((S₀.alloca 608).alloca 592).alloca 592).alloca 64).mem.storeAt sg r).storeAt
                  (sg.add 32#64) Sv))
                vi r Sv A).readRest
            (vi.add (BitVec.ofNat 64 off)) =
          0#64) :
      S.mem.PtFit (v2.add (BitVec.ofNat 64 off)) ∧
        S.mem.readPt (v2.add (BitVec.ofNat 64 off)) = P := by
      have hoff' : off < 600 := by omega
      have hfit : S.mem.PtFit (v2.add (BitVec.ofNat 64 off)) := by
        refine ⟨?_, Fits.add_of_le (hov v2 hv2_off off hoff') ?_ hv2f⟩
        · have : (BitVec.ofNat 64 off).toNat = off := by
            rw [BitVec.toNat_ofNat, Nat.mod_eq_of_lt (by omega)]
          simp only [Pointer.add, hv2_off, BitVec.toNat_add, this]; simp; omega
        · rw [BitVec.toNat_ofNat, Nat.mod_eq_of_lt (by omega)]; omega
      refine ⟨hfit, (MemoryState.readPt_of_readAt (rest := 0#64) hfit ?_).1⟩
      rw [readAt_of_copy hv2f hY hv2 (hov v2 hv2_off off hoff') (hov vi hvi_off off hoff')
          (by
            rw [BitVec.toNat_ofNat, Nat.mod_eq_of_lt (by omega)]; omega),
        MemoryState.readAt_eq_ptBits hP.2 hP.1, hp, hr]
    obtain ⟨hPa2, ha2⟩ := hpt 224 (by decide) a hPa ha hra
    obtain ⟨hPR2, hR2⟩ := hpt 392 (by decide) R hPR hR hrR
    have hS2 : S.mem.readAt (v2.add 560#64) 256 = Sv := by
      rw [readAt_of_copy hv2f hY hv2 (hov v2 hv2_off 560 (by decide))
          (hov vi hvi_off 560 (by decide)) (by decide)]
      exact hSb
    clear hpt hv2 hH hPa ha hra hPR hR hrR hSb hY hfM
    -- the hash object at `v2` has absorbed `r ‖ A`; `update` adds the message
    have hfit2 : Sha512Obj.Fit S.mem v2 :=
      ⟨hv2f.mono (by decide), by
        rw [hv2_off]; decide⟩
    have habs := Verifier.init.absorbed hfit2 hH2
    have hsep : (Range.of v2 1792).Disjoint (Range.of msg (8 * len.toNat)) := by
      simp only [Range.Disjoint, Range.of]; exact .inl hmsg_ne_v2.symm
    have hbl : (Sha512Obj.bufLen S.mem v2).toNat < 128 := by
      rw [habs.bufLen]; exact Nat.mod_lt _ (by decide)
    have hT : (Sha512Obj.totalLen S.mem v2).toNat + len.toNat < 2 ^ 128 := by
      rw [habs.totalLen];
      simp only [List.length_append, Ed25519.length_bytesLE, BitVec.toNat_ofNat]; omega
    have habs' := Sha512_update.absorbed habs hfit2.1 hfit2.2 hmsg hmo hsep
    rw [hread_M] at habs'
    -- the points and `S`, past `update`
    have hdj (k w : Nat) (hk : 224 ≤ k) (hkw : k * 8 + w ≤ 4736) :
      (Range.of v2 1792).Disjoint (Range.of (v2.add (BitVec.ofNat 64 k)) w) := by
      have : (BitVec.ofNat 64 k).toNat = k := by
        rw [BitVec.toNat_ofNat, Nat.mod_eq_of_lt (by omega)]
      simp only [Range.Disjoint, Range.of, Pointer.add, Pointer.offsetInBits, hv2_off,
        BitVec.toNat_add, this]
      simp; omega
    have hupd (k w : Nat) (hk : 224 ≤ k) (hkw : k * 8 + w ≤ 4736) :
      (Sha512_update.post S v2 msg len).mem.readAt (v2.add (BitVec.ofNat 64 k)) w =
        S.mem.readAt (v2.add (BitVec.ofNat 64 k)) w :=
      Sha512_update.post_readAt hfit2.1 hfit2.2 hbl (hdj k w hk hkw)
    have hpt (k : Nat) (hk : 224 ≤ k) (hkw : k * 8 + 1344 ≤ 4736) (P : ZPt)
      (hf : S.mem.PtFit (v2.add (BitVec.ofNat 64 k)))
      (hP : S.mem.readPt (v2.add (BitVec.ofNat 64 k)) = P) :
      (Sha512_update.post S v2 msg len).mem.PtFit (v2.add (BitVec.ofNat 64 k)) ∧
        (Sha512_update.post S v2 msg len).mem.readPt (v2.add (BitVec.ofNat 64 k)) = P := by
      have hf' : (Sha512_update.post S v2 msg len).mem.PtFit (v2.add (BitVec.ofNat 64 k)) :=
        ⟨hf.1, Sha512_update.post_fits.mpr hf.2⟩
      refine
        ⟨hf',
          (MemoryState.readPt_of_readAt (rest := S.mem.readRest (v2.add (BitVec.ofNat 64 k))) hf'
              ?_).1⟩
      rw [hupd k 1344 hk hkw, MemoryState.readAt_eq_ptBits hf.2 hf.1, hP]
    obtain ⟨hPa3, ha3⟩ := hpt 224 (by decide) (by decide) a hPa2 ha2
    obtain ⟨hPR3, hR3⟩ := hpt 392 (by decide) (by decide) R hPR2 hR2
    have hS3 : (Sha512_update.post S v2 msg len).mem.readAt (v2.add 560#64) 256 = Sv :=
      (hupd 560 256 (by decide) (by decide)).trans hS2
    clear hpt hupd hdj
    have hbl64 : (Sha512Obj.bufLen S.mem v2).toNat = 64 := by
      rw [habs.bufLen]; simp
    -- stated on the explicit state, out of the steps' sight
    rw [hS] at habs' hPa3 ha3 hPR3 hR3 hS3 hbl64
    clear habs hPa2 ha2 hPR2 hR2 hS2 hH2
    have f1 := hfit2
    clear hfit2
    step_call using Sha512_update.call_eq consuming f1 hsep hbl hT hlen
    have hal := post_alloc (b := msg) (n := len) (hbl64 ▸ (by decide : 64 < 128))
    rw [hbl64] at hal
    rw [← hS] at habs' hPa3 ha3 hPR3 hR3 hS3
    -- the counter in closed form, so `post` is not unfolded for it
    rw [GlobalState.eta_alloc hal] at hS
    -- decoded points' limbs are below `2^52`
    have hlt {b : BitVec 256} {P : ZPt} (h : Edwards25519.fromBytes.spec b = some P) :
      P.Lt (2 ^ 53) := by
      obtain ⟨-, -, -, -, hl⟩ := Decode.fromBytes_eq_some h
      exact hl.mono53
    have hA53 : (S.mem.readPt (v2.add 224#64)).Lt (2 ^ 53) := by
      rw [ha3]; exact hlt hsA
    have hR53 : (S.mem.readPt (v2.add 392#64)).Lt (2 ^ 53) := by
      rw [hR3]; exact hlt hsR
    have f1 : v2.offset.toNat + 592 < 2 ^ 64 := by
      rw [hv2_off]; decide
    have hcall := Verifier_verify.call_eq reduce64Call v2 S hwf hv2f f1 _ habs' hA53 hR53
    rw [ha3, hR3, hS3] at hcall
    clear habs' hA53 hR53 hPa3 ha3 hPR3 hR3 hS3 f1 hlt
    step_call using hcall consuming hcall
    -- `verify`'s code and blocks, opaque from here
    generalize hcv : Verifier.verify.code (bytesLE r ++ (bytesLE A ++ bytesLE M)) Sv a R = cv at *
    generalize hvb : Verifier.verify.blocks (bytesLE r ++ bytesLE A ++ bytesLE M) Sv a R = vb at *
    finish_block
    refine ret_block _ _ S E _ (by env_reads) ?_
    dsimp only
    rw [hS]
    have hle : S₀.alloc.nextFreeBlock ≤ v2.id.id := by
      subst hv2; simp [GlobalState.slot_id_id]
    rw [finalMem_eraseFrom_of_le hle, post_eraseFrom_of_le hle]
    erase_frame
    rw [Verifier.init.eraseFrom_mem_of_le
        (by
          subst hvi; simp [GlobalState.slot_id_id])]
    erase_frame
    have hc : ZigVerify.code (bytesLE M) r Sv A = cv := by
      rw [ZigVerify.code, hsA, hsR, ← hcv];
      simp only [ZigVerify.codeOf, hbr, ↓reduceIte, List.append_assoc]
    have hb :
      ZigVerify.blocks (bytesLE M) r Sv A =
        4 + Verifier.init.blocks r Sv A + (2 * ((64 + len.toNat) / 128) + vb) := by
      rw [ZigVerify.blocks, hsA, hsR, ← hvb]
      simp only [ZigVerify.blocksOf, hbr, ↓reduceIte, List.length_append, length_bytesLE]
      omega
    rw [hc, hb]
    simp only [GlobalState.alloca]
    generalize Verifier.init.blocks r Sv A = IB
    rw [show
        S₀.alloc.nextFreeBlock + 1 + 1 + 1 + 1 + IB + 2 * ((64 + len.toNat) / 128) + vb =
          S₀.alloc.nextFreeBlock + (4 + IB + (2 * ((64 + len.toNat) / 128) + vb))
        by omega]

end Proof

end MLIR.Zig
