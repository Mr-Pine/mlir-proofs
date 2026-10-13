module

public import MLIR.Run.Tactic
public import Firedancer.Common.Tactics
public import Zig.Verifier_init
public import Zig.Verifier_verify
public import Zig.Sha512_update
public import Zig.Sha512_frame
public import Zig.Mlir.zig_ed25519_verify
import Zig.Math.Init
import Std.Tactic.BVDecide
import Mathlib.Tactic.Rename

set_option hygiene false in
/-- `hS` kept reversed as `hck`: later states build on an opaque `S`. -/
local macro "checkpoint " hck:ident : tactic => `(tactic| (have $hck:ident := hS.symm; clear hS))

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

/-- The blocks `update` and `verify` allocate after `init`, `M` absorbed. -/
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

end ZigVerify

end

/-! ## Proof -/

section Proof

open ZigVerify

/-- A failed `init`'s code is the result. -/
public theorem ZigVerify.codeOf_ne {c : BitVec 16} (h : c ≠ 0#16) (M S oa oR) :
    codeOf c M S oa oR = c := by cases oa <;> cases oR <;> simp [codeOf, h]

/-- A failed `init` allocates nothing after. -/
public theorem ZigVerify.blocksOf_ne {c : BitVec 16} (h : c ≠ 0#16) (M S oa oR) :
    blocksOf c M S oa oR = 0 := by cases oa <;> cases oR <;> simp [blocksOf, h]

/-- `Verifier.init`'s `call_eq` on a failure, on the bytes `r`, `S`, `A` read at `sig`, `sig + 32`,
`pk`: the code alone. -/
theorem Verifier_init.call_eq_err (out sig pk : Pointer) (s : GlobalState) (hwf : s.WF)
    (hg : s.mem.Globals Verifier_init.globals) (hout : Room s.mem out 4752)
    (hoo : out.offset.toNat + 594 ≤ 2 ^ 64) (hsig : Fits s.mem sig 512)
    (hso : sig.offset.toNat + 64 < 2 ^ 64) (hpk : Fits s.mem pk 256)
    (hpo : pk.offset.toNat + 32 < 2 ^ 64) (hr : s.mem.readAt sig 256 = r)
    (hS : s.mem.readAt (sig.add 32#64) 256 = S) (hA : s.mem.readAt pk 256 = A)
    (hc : Verifier.init.code r S A ≠ 0#16) :
    Verifier_init.call (Verifier_init.args (.value out) (.value sig) (.value pk)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + Verifier.init.blocks r S A⟩,
            mem := s.mem.storeAt (out.add 592#64) (Verifier.init.code r S A) }) := by
  subst hr hS hA
  rw [Verifier_init.call_eq out sig pk s hwf hg hout hoo hsig hso hpk hpo, Verifier.init.mem]
  simp only [hc, ↓reduceIte]

/-- `Verifier.init`'s `call_eq` on success: the code `0`, the `Verifier`'s bits. -/
theorem Verifier_init.call_eq_ok (out sig pk : Pointer) (s : GlobalState) (hwf : s.WF)
    (hg : s.mem.Globals Verifier_init.globals) (hout : Room s.mem out 4752)
    (hoo : out.offset.toNat + 594 ≤ 2 ^ 64) (hsig : Fits s.mem sig 512)
    (hso : sig.offset.toNat + 64 < 2 ^ 64) (hpk : Fits s.mem pk 256)
    (hpo : pk.offset.toNat + 32 < 2 ^ 64) (hr : s.mem.readAt sig 256 = r)
    (hS : s.mem.readAt (sig.add 32#64) 256 = S) (hA : s.mem.readAt pk 256 = A)
    (hc : Verifier.init.code r S A = 0#16) :
    Verifier_init.call (Verifier_init.args (.value out) (.value sig) (.value pk)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + Verifier.init.blocks r S A⟩,
            mem :=
              (s.mem.storeAt (out.add 592#64) 0#16).storeDef out (Verifier.init.bits r S A)
                Verifier.init.defs }) := by
  subst hr hS hA
  rw [Verifier_init.call_eq out sig pk s hwf hg hout hoo hsig hso hpk hpo, Verifier.init.mem]
  simp only [hc, ↓reduceIte]

/-- The signature copied into the 64-byte slot `sg`: its halves `r`, `S`. -/
theorem sig_copy {m : MemoryState} {sg : Pointer} (hr : Room m sg 512) (ho : sg.offset = 0)
    (hf : Fits m sg 256) (h : m.readAt sg 256 = r) :
    Fits (m.storeAt (sg.add 32#64) S) sg 512 ∧
      (m.storeAt (sg.add 32#64) S).readAt sg 256 = r ∧
      (m.storeAt (sg.add 32#64) S).readAt (sg.add 32#64) 256 = S := by
  have hov : ¬sg.offset.uaddOverflow 32#64 := by simp [BitVec.uaddOverflow, ho]
  have h32 : Room m (sg.add 32#64) 256 := Room.add_of_le hov (by simp) hr
  have hdj : (Range.of (sg.add 32#64) 256).Disjoint (Range.of sg 256) := by
    right; right
    simp [Range.of, Pointer.offsetInBits, Pointer.add, ho]
  exact
    ⟨Fits.append hov rfl rfl hf.storeAt (Fits.storeAt_self h32),
      (MemoryState.readAt_storeAt_disjoint hdj _).trans h,
      MemoryState.readAt_storeAt_self h32 _⟩

/-- `0 - zext c` does not overflow for a 16-bit code. -/
theorem neg_code_noOverflow (c : BitVec 16) :
    (0#32).ssubOverflow (BitVec.setWidth 32 c) = false := by bv_decide

/-- What `init` leaves at `vi` on success: error code `0`, the `Verifier`'s bits. -/
theorem init_ok_facts {m : MemoryState} {vi : Pointer} {x dd : BitVec 4736} (hr : Room m vi 4864)
    (ho : vi.offset = 0) :
    Fits ((m.storeAt (vi.add 592#64) 0#16).storeDef vi x dd) (vi.add 592#64) 16 ∧
      ((m.storeAt (vi.add 592#64) 0#16).storeDef vi x dd).readAt (vi.add 592#64) 16 = 0#16 ∧
      ((m.storeAt (vi.add 592#64) 0#16).storeDef vi x dd).readAt vi 4736 = x ∧
      ((m.storeAt (vi.add 592#64) 0#16).storeDef vi x dd).definedAt vi 4736 = dd := by
  have hov : ¬vi.offset.uaddOverflow 592#64 := by simp [BitVec.uaddOverflow, ho]
  have h592 : Room m (vi.add 592#64) 16 := Room.add_of_le hov (by simp) hr
  have hdj : (Range.of vi 4736).Disjoint (Range.of (vi.add 592#64) 16) := by
    right; left
    simp [Range.of, Pointer.offsetInBits, Pointer.add, ho]
  have hi : Room (m.storeAt (vi.add 592#64) 0#16) vi 4736 := (hr.mono (by omega)).storeAt
  exact
    ⟨Fits.storeDef_of_disjoint (Fits.storeAt_self h592) hdj,
      (MemoryState.readAt_storeDef_disjoint hdj _ _).trans
        (MemoryState.readAt_storeAt_self h592 _),
      MemoryState.readAt_storeDef_self hi _ _, MemoryState.definedAt_storeDef_self hi _ _⟩

/-- A copy of `x`, defined `d`, into the 592 bytes at `v`: read back. -/
theorem copy_facts {m : MemoryState} {v : Pointer} {x dd : BitVec 4736} (hr : Room m v 4736) :
    (m.storeDef v x dd).readAt v 4736 = x ∧ (m.storeDef v x dd).definedAt v 4736 = dd :=
  ⟨MemoryState.readAt_storeDef_self hr _ _, MemoryState.definedAt_storeDef_self hr _ _⟩

/-- What `update` keeps of the `Verifier` at `d`: its object has absorbed the message after `M`,
the points and the scalar past it alike. -/
theorem upd_facts {s : GlobalState} {d b : Pointer} {n : BitVec 64} {M : List (BitVec 8)}
    (hd : Sha512Obj.Fit s.mem d) (hA : Sha512Obj.Absorbed s.mem d M)
    (hbf : InBounds s.mem b (8 * n.toNat)) (hbo : b.offset.toNat + n.toNat < 2 ^ 64)
    (hsep : (Range.of d 1792).Disjoint (Range.of b (8 * n.toNat)))
    (hpa : s.mem.PtLimbsFit (d.add 224#64)) (hpr : s.mem.PtLimbsFit (d.add 392#64))
    (hsf : Fits s.mem (d.add 560#64) 256) (hbl : M.length % 128 = 64)
    (hso : d.offset.toNat + 592 < 2 ^ 64) :
    Sha512Obj.Fit (Sha512_update.post s d b n).mem d ∧
      Sha512Obj.Absorbed (Sha512_update.post s d b n).mem d
        (M ++ bytesLE (s.mem.readAt b (8 * n.toNat))) ∧
      ((Sha512_update.post s d b n).mem.PtLimbsFit (d.add 224#64) ∧
        (Sha512_update.post s d b n).mem.readPt (d.add 224#64) = s.mem.readPt (d.add 224#64)) ∧
      ((Sha512_update.post s d b n).mem.PtLimbsFit (d.add 392#64) ∧
        (Sha512_update.post s d b n).mem.readPt (d.add 392#64) = s.mem.readPt (d.add 392#64)) ∧
      (Fits (Sha512_update.post s d b n).mem (d.add 560#64) 256 ∧
        (Sha512_update.post s d b n).mem.readAt (d.add 560#64) 256 =
          s.mem.readAt (d.add 560#64) 256) ∧
      (Sha512_update.post s d b n).alloc.nextFreeBlock =
        s.alloc.nextFreeBlock + 2 * ((64 + n.toNat) / 128) := by
  have hbl' := Sha512_update.bufLen_lt hA
  obtain ⟨hdo, hr, hf1, hf2⟩ := hd
  have hdj (k : BitVec 64) (w : Nat) (hk : 224 ≤ k.toNat) (hkw : 8 * k.toNat + w ≤ 4736) :
    (Range.of d 1792).Disjoint (Range.of (d.add k) w) := by
    right; left
    simp only [Range.of, Pointer.offsetInBits, Pointer.add, BitVec.toNat_add]
    rw [Nat.mod_eq_of_lt (by omega)]; omega
  have hpt (k : BitVec 64) (hk : 224 ≤ k.toNat) (hkw : 8 * k.toNat + 1344 ≤ 4736)
    (hp : s.mem.PtLimbsFit (d.add k)) :
    (Sha512_update.post s d b n).mem.PtLimbsFit (d.add k) ∧
      (Sha512_update.post s d b n).mem.readPt (d.add k) = s.mem.readPt (d.add k) := by
    obtain ⟨ho, hr', hx, hy, hz, ht⟩ := hp
    have hl (q : Pointer) (h : s.mem.LimbsFit q) : (Sha512_update.post s d b n).mem.LimbsFit q :=
      ⟨h.1, Sha512_update.Fits.post h.2.1, Sha512_update.Fits.post h.2.2.1,
        Sha512_update.Fits.post h.2.2.2.1, Sha512_update.Fits.post h.2.2.2.2.1,
        Sha512_update.Fits.post h.2.2.2.2.2⟩
    have hpl : Live (Sha512_update.post s d b n).mem (d.add k) 1344 := Sha512_update.live_post.2 hr'
    refine ⟨⟨ho, hpl, hl _ hx, hl _ hy, hl _ hz, hl _ ht⟩, ?_⟩
    refine MemoryState.readPt_of_readAt (hpl.inBounds.mono (by omega)) ho ?_
    rw [MemoryState.readAt_of_readAt_le (w := 1280) (by omega)
        (Sha512_update.post_readAt hr hdo hbl' (hdj k 1344 hk hkw)),
      BitVec.setWidth_eq_extractLsb' (by omega)]
    exact MemoryState.readAt_pt_bits hr'.inBounds ho
  refine
    ⟨Sha512_update.Fit.post ⟨hdo, hr, hf1, hf2⟩,
      Sha512_update.absorbed hA ⟨hdo, hr, hf1, hf2⟩ hbf hbo hsep,
      hpt 224#64 (by decide) (by decide) hpa, hpt 392#64 (by decide) (by decide) hpr,
      ⟨Sha512_update.Fits.post hsf,
        Sha512_update.post_readAt hr hdo hbl' (hdj 560#64 256 (by decide) (by decide))⟩,
      ?_⟩
  rw [post_alloc hbl', hA.bufLen, hbl]

/-- `Verifier.verify`'s `call_eq` on the named scalar `Sc` and points `a`, `R`. -/
theorem Verifier_verify.call_eq_of (self : Pointer) (s : GlobalState) (hwf : s.WF)
    (hg : s.mem.Globals Verifier_verify.globals)
    (hself : Room s.mem self 4736) (hso : self.offset.toNat + 592 < 2 ^ 64) (M : List (BitVec 8))
    (hd : Sha512Obj.Fit s.mem self) (hM : Sha512Obj.Absorbed s.mem self M)
    (hpa : s.mem.PtLimbsFit (self.add 224#64)) (hpr : s.mem.PtLimbsFit (self.add 392#64))
    (hsf : Fits s.mem (self.add 560#64) 256) (hAd : s.mem.readPt (self.add 224#64) = a)
    (hRd : s.mem.readPt (self.add 392#64) = R) (hSd : s.mem.readAt (self.add 560#64) 256 = Sc)
    (hA : a.Lt (2 ^ 53)) (hR : R.Lt (2 ^ 53)) :
    Verifier_verify.call (Verifier_verify.args (.value self)) s =
      .value
        (.cons (.value (Verifier.verify.code M Sc a R)) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + Verifier.verify.blocks M Sc a R⟩,
            mem := Verifier.verify.finalMem s.mem self }) := by
  subst hAd hRd hSd
  exact Verifier_verify.call_eq self s hwf hg hself hso M hd hM hpa hpr hsf hA hR

/-- The return block: the slots' lifetimes ended, `0 - zext c` for the code `c` it is passed. -/
theorem ret_block (g : Vals [.bv 32] × GlobalState → PoisonOr β) (K : PoisonOr β) (S : GlobalState)
    (E : ⟪zig_ed25519_verify.Γ⟫) (c : BitVec 16) (v1 v2 : Pointer)
    (hR : E ⊨ [%3986 := 0#32, %3988 := v1, %3989 := v2, %3997 := c])
    (hK :
      g
          (.cons (.value (-(c.setWidth 32))) .nil,
            { S with mem := (S.mem.lifetimeEnd v1).lifetimeEnd v2 }) =
        K) :
    (zig_ed25519_verify.runFrom E ^bb2 S >>= g) = K := by
  block_init
  iterate 4 step_pure
  finish_block
  rw [neg_code_noOverflow]
  simp only [Bool.false_eq_true, ↓reduceIte]
  rw [hS]
  exact hK

attribute [local mlir_read] definedAt_lifetimeStart_of_id_ne definedAt_lifetimeEnd_of_id_ne

attribute [local mlir_erase high] finalMem_eraseFrom_of_le post_eraseFrom_of_le

theorem Room.updPost {s : GlobalState} {d b q : Pointer} {n : BitVec 64} (h : Room s.mem q w) :
    Room (Sha512_update.post s d b n).mem q w :=
  Sha512_update.room_post.2 h

attribute [local mlir_transport] Room.updPost Sha512_update.Fits.post Sha512_update.post_wf

/-- `zig_ed25519_verify` returns `-code` for `ZigVerify.code` on the message, `r`, `S` and the key,
and leaves memory as it found it. -/
public theorem zig_ed25519_verify.call_eq (msg : Pointer) (len : BitVec 64) (sig pk : Pointer)
    (s : GlobalState) (hwf : s.WF) (hg : s.mem.Globals zig_ed25519_verify.globals)
    (hmsg : Fits s.mem msg (8 * len.toNat)) (hmo : msg.offset.toNat + len.toNat < 2 ^ 64)
    (hsig : Fits s.mem sig 512) (hso : sig.offset.toNat + 64 < 2 ^ 64) (hpk : Fits s.mem pk 256)
    (hpo : pk.offset.toNat + 32 < 2 ^ 64) (hlen : len.toNat + 128 < 2 ^ 63) :
    zig_ed25519_verify.call
        (zig_ed25519_verify.args (.value msg) (.value len) (.value sig) (.value pk)) s =
      .value
        (.cons
            (.value
              (-((code (bytesLE (s.mem.readAt msg (8 * len.toNat))) (s.mem.readAt sig 256)
                      (s.mem.readAt (sig.add 32#64) 256) (s.mem.readAt pk 256)).setWidth
                  32)))
            .nil,
          {
            alloc :=
              ⟨s.alloc.nextFreeBlock +
                  blocks (bytesLE (s.mem.readAt msg (8 * len.toNat))) (s.mem.readAt sig 256)
                    (s.mem.readAt (sig.add 32#64) 256) (s.mem.readAt pk 256)⟩,
            mem := s.mem }) := by
  have hsig32 : Fits s.mem (sig.add 32#64) 256 :=
    Fits.add_of_le
      (by
        simp [BitVec.uaddOverflow]; omega)
      (by simp) hsig
  generalize hr : s.mem.readAt sig 256 = r
  generalize hSv : s.mem.readAt (sig.add 32#64) 256 = Sv
  generalize hA : s.mem.readAt pk 256 = A
  generalize hM : s.mem.readAt msg (8 * len.toNat) = M
  func_init
  block_init
  iterate 5 step_pure
  step_alloca with vi
  step_alloca with v1
  step_alloca with v2
  step_alloca with sg
  step_memcpy
  step_pure
  step_pure
  have hsrc : Fits S.mem (sig.add 32#64) (8 * (32#64).toNat) := hsig32
  checkpoint hck0
  have hsg' := fun m' (hm : m' = S.mem.storeAt (sg.add 32#64) (S.mem.readAt (sig.add 32#64) 256)) =>
    (hm ▸ hSv ▸ sig_copy hsg_room hsg_off hfits_sg hread_sg :
      Fits m' sg 512 ∧ m'.readAt sg 256 = r ∧ m'.readAt (sg.add 32#64) 256 = Sv)
  step_memcpy consuming hsrc hfits_sg hread_sg
  obtain ⟨hsgf, hsgr, hsgS⟩ := hsg' _ (congrArg GlobalState.mem hS)
  clear hsg'
  iterate 3 step_pure
  have hvi4752 : Room S.mem vi 4752 := hroom_vi.mono (by omega)
  have hvio : vi.offset.toNat + 594 ≤ 2 ^ 64 := by simp [hvi_off]
  have hsgo : sg.offset.toNat + 64 < 2 ^ 64 := by simp [hsg_off]
  by_cases hc : Verifier.init.code r Sv A = 0#16
  · obtain ⟨-, -, a, R, -, -, ha, hR, -, -, -, -, -, -, hal, hRl, -, -⟩ :=
      Verifier.init.checks_of_code_eq hc
    checkpoint hck1
    have hpost :=
      fun m'
        (hm :
          m' =
            (S.mem.storeAt (vi.add 592#64) 0#16).storeDef vi (Verifier.init.bits r Sv A)
              Verifier.init.defs) =>
      (hm ▸ init_ok_facts hroom_vi hvi_off :
        Fits m' (vi.add 592#64) 16 ∧
          m'.readAt (vi.add 592#64) 16 = 0#16 ∧
          m'.readAt vi 4736 = Verifier.init.bits r Sv A ∧ m'.definedAt vi 4736 = Verifier.init.defs)
    step_call using Verifier_init.call_eq_ok consuming hsgf hsgr hsgS hvi4752
    obtain ⟨hcf, hcr, hvb, hvd⟩ := hpost _ (congrArg GlobalState.mem hS)
    clear hpost
    checkpoint hck2
    have hv1c :=
      fun m' (hm : m' = S.mem.storeDef v1 (Verifier.init.bits r Sv A) Verifier.init.defs) =>
      (hm ▸ copy_facts hroom_v1 :
        m'.readAt v1 4736 = Verifier.init.bits r Sv A ∧ m'.definedAt v1 4736 = Verifier.init.defs)
    step_memcpy consuming hvb hvd
    obtain ⟨hv1b, hv1d⟩ := hv1c _ (congrArg GlobalState.mem hS)
    clear hv1c
    step_pure
    step_load only [hcr] consuming hcf hcr
    iterate 2 step_pure
    finish_block
    block_init
    checkpoint hck3
    have hv2c :=
      fun m' (hm : m' = S.mem.storeDef v2 (Verifier.init.bits r Sv A) Verifier.init.defs) =>
      (hm ▸ copy_facts hroom_v2 :
        m'.readAt v2 4736 = Verifier.init.bits r Sv A ∧ m'.definedAt v2 4736 = Verifier.init.defs)
    step_memcpy consuming hv1b hv1d
    obtain ⟨hv2b, hv2d⟩ := hv2c _ (congrArg GlobalState.mem hS)
    clear hv2c
    obtain ⟨hFit, hAbs, hpa, hpaP, hpr, hprP, hsf, hsfr⟩ :=
      Verifier.init.facts (hroom_v2) hv2_off hv2b hv2d ha hR
    clear hv2b hv2d
    have hbuf := Sha512_update.fits_buf hAbs
    have hbl := Sha512_update.bufLen_lt hAbs
    have hbl64 : (Sha512Obj.bufLen S.mem v2).toNat = 64 := by
      rw [hAbs.bufLen]; simp
    have hT : (Sha512Obj.totalLen S.mem v2).toNat + len.toNat < 2 ^ 128 := by
      rw [hAbs.totalLen]; simp; omega
    have hsep : (Range.of v2 1792).Disjoint (Range.of msg (8 * len.toNat)) := .inl hmsg_ne_v2.symm
    clear hvi_bounds hv1_bounds hv2_bounds hfits_sg_32 hsig hpk hsig32 hsg_room
    checkpoint hck4
    have hupd := fun X (hX : X = Sha512_update.post S v2 msg len) =>
      (hX ▸ upd_facts hFit hAbs hmsg.inBounds hmo hsep hpa hpr hsf (by simp) (by simp [hv2_off]) :
        Sha512Obj.Fit X.mem v2 ∧
          Sha512Obj.Absorbed X.mem v2
            (bytesLE r ++ bytesLE A ++ bytesLE (S.mem.readAt msg (8 * len.toNat))) ∧
          (X.mem.PtLimbsFit (v2.add 224#64) ∧
            X.mem.readPt (v2.add 224#64) = S.mem.readPt (v2.add 224#64)) ∧
          (X.mem.PtLimbsFit (v2.add 392#64) ∧
            X.mem.readPt (v2.add 392#64) = S.mem.readPt (v2.add 392#64)) ∧
          (Fits X.mem (v2.add 560#64) 256 ∧
            X.mem.readAt (v2.add 560#64) 256 = S.mem.readAt (v2.add 560#64) 256) ∧
          X.alloc.nextFreeBlock = S.alloc.nextFreeBlock + 2 * ((64 + len.toNat) / 128))
    rw [hM, hpaP, hprP, hsfr] at hupd
    have hgp := fun X (hX : X = Sha512_update.post S v2 msg len) =>
      (hX ▸ Sha512_update.Globals.post hg : X.mem.Globals _)
    step_call using Sha512_update.call_eq consuming hFit hbuf hmsg hsep hbl hT hAbs hpa hpr hsf hg
      hwritable_vi hwritable_v1 hwritable_v2
    obtain ⟨hFit2, hAbs2, ⟨hpa2, hpaP2⟩, ⟨hpr2, hprP2⟩, ⟨hsf2, hsfr2⟩, hupa⟩ := hupd S hS
    have hg := hgp S hS
    clear hupd hgp
    have hv2o : v2.offset.toNat + 592 < 2 ^ 64 := by simp [hv2_off]
    have ha53 : a.Lt (2 ^ 53) := hal.mono53
    have hR53 : R.Lt (2 ^ 53) := hRl.mono53
    step_call using Verifier_verify.call_eq_of consuming hroom_v2 hFit2 hAbs2 hpa2 hpr2 hsf2 hpaP2
      hprP2 hsfr2 ha53 hR53 hroom_v1 hwf hg
    finish_block
    refine ret_block _ _ S E _ v1 v2 (by env_reads) ?_
    dsimp only
    rw [hS]
    subst_vars
    erase_frame
    rw [hupa, code, blocks, ha, hR]
    simp only [codeOf, blocksOf, hc, ↓reduceIte, List.append_assoc, List.length_append,
      length_bytesLE]
    generalize Verifier.verify.blocks (bytesLE r ++ (bytesLE A ++ bytesLE M)) Sv a R = vb
    generalize Verifier.init.blocks r Sv A = ib
    have e :
      ((((S₀.alloca 608 true).alloca 592 true).alloca 592 true).alloca 64).alloc.nextFreeBlock =
        S₀.alloc.nextFreeBlock + 4 :=
      rfl
    rw [e,
      show
        S₀.alloc.nextFreeBlock + 4 + ib + 2 * ((64 + len.toNat) / 128) + vb =
          S₀.alloc.nextFreeBlock +
            (4 + ib + (2 * ((256 / 8 + (256 / 8 + 8 * len.toNat / 8)) / 128) + vb))
        by omega]
  · checkpoint hck1
    have hcode := fun m' (hm : m' = S.mem.storeAt (vi.add 592#64) (Verifier.init.code r Sv A)) =>
      (hm ▸
          ⟨Fits.storeAt_self
              (Room.add_of_le (by simp [BitVec.uaddOverflow, hvi_off]) (by simp) hroom_vi),
            MemoryState.readAt_storeAt_self
              (Room.add_of_le (by simp [BitVec.uaddOverflow, hvi_off]) (by simp) hroom_vi) _⟩ :
        Fits m' (vi.add 592#64) 16 ∧ m'.readAt (vi.add 592#64) 16 = Verifier.init.code r Sv A)
    step_call using Verifier_init.call_eq_err consuming hsgf hsgr hsgS hvi4752
    obtain ⟨hcf, hcr⟩ := hcode _ (congrArg GlobalState.mem hS)
    clear hcode
    step_memcpy
    step_pure
    step_load only [hcr] consuming hcf hcr
    iterate 2 step_pure
    finish_block
    refine ret_block _ _ S E _ v1 v2 (by env_reads) ?_
    dsimp only
    rw [hS, ← hck1, ← hck0]
    erase_frame
    simp only [code, blocks, ZigVerify.codeOf_ne hc, ZigVerify.blocksOf_ne hc, GlobalState.alloca]
    rw [show
        S₀.alloc.nextFreeBlock + 1 + 1 + 1 + 1 + Verifier.init.blocks r Sv A =
          S₀.alloc.nextFreeBlock + (4 + Verifier.init.blocks r Sv A + 0)
        by omega]

end Proof

end MLIR.Zig
