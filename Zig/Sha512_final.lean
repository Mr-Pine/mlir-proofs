module

public import MLIR.Run.Tactic
public import Ed25519.Sha512
public import Zig.Sha512
public import Zig.Sha512_round
public import Zig.Sha512_update
public import Zig.Mlir.Sha512_final
import Std.Tactic.BVDecide
import all MLIR.Semantics.Effectful.Memory.Bits

/-! `Sha512.final`: the state it leaves (`post`), and the 64 bytes it writes at `out`, SHA-512 of
what the object absorbed (`digest`). -/

namespace MLIR.Zig

open _root_.Ed25519

namespace Sha512_final


/-- The length's bytes `x`, `x >>> 8`, … stored at `buf[127 - i]`, `buf[126 - i]`, …. -/
@[expose] public def lenStores (d : Pointer) : (x : BitVec 128) → (i n : Nat) → MemoryState → MemoryState
  | _, _, 0, m => m
  | x, i, n + 1, m =>
    lenStores d (x >>> 8) (i + 1) n
      (m.storeAt (d.add (80#64 + BitVec.ofNat 64 (127 - i))) (BitVec.setWidth 8 x))

theorem fits_lenStores {m : MemoryState} {d : Pointer} :
    ∀ n i (x : BitVec 128), Fits (lenStores d x i n m) p w ↔ Fits m p w := by
  intro n
  induction n generalizing m with
  | zero => intro _ _; rfl
  | succ n ih => intro i x; rw [lenStores, ih]; simp

set_option maxHeartbeats 0 in
/-- `bb3`/`bb4` from byte `i`, `m` left: the length's bytes into the buffer's end. -/
theorem len_loop (d out : Pointer) {β : Type} (κ : Vals [] × GlobalState → PoisonOr β) (R : PoisonOr β)
    (hdo : d.offset.toNat + 224 < 2 ^ 64) :
    ∀ m i (x : BitVec 128) (S : GlobalState) (E : ⟪Γ⟫), i + m = 16 → 1 ≤ i →
      E.args = (Sha512_final.args (.value d) (.value out)).get →
      (E ⊨ [%2 := 0#64, %8 := 1#64, %9 := 16#64, %10 := 127#64, %11 := 8#128, %12 := 8#64, %13 := 3#64,
        %14 := d.add 80#64, %31 := BitVec.ofNat 64 i, %32 := x]) →
      Fits S.mem d 1792 →
      (∀ E' : ⟪Γ⟫, E'.args = (Sha512_final.args (.value d) (.value out)).get →
        (E' ⊨ [%2 := 0#64, %8 := 1#64, %12 := 8#64, %13 := 3#64, %14 := d.add 80#64]) →
        (Sha512_final.runFrom E' 5 { S with mem := lenStores d x i m S.mem } >>= κ) = R) →
      (Sha512_final.runFrom E 3 S >>= κ) = R := by
  intro m
  induction m with
  | zero =>
    intro i x S E hi _ hArgs hR hf hK
    obtain rfl : i = 16 := by omega
    block_init
    step_pure
    finish_block
    step_loop using hK
  | succ m ih =>
    intro i x S E hi hi1 hArgs hR hf hK
    have hs1 : (127#64).ssubOverflow (BitVec.ofNat 64 i) = false := by
      have h1 : (BitVec.ofNat 64 i).toInt = i := by
        rw [BitVec.toInt_eq_toNat_of_lt] <;> simp <;> omega
      have h2 : (127#64).toInt = 127 := by decide
      simp [BitVec.ssubOverflow, h1, h2]; omega
    have hs2 : (127#64).usubOverflow (BitVec.ofNat 64 i) = false := by
      simp [BitVec.usubOverflow]; omega
    have hsub : 127#64 - BitVec.ofNat 64 i = BitVec.ofNat 64 (127 - i) := by
      apply BitVec.eq_of_toNat_eq; simp; omega
    have hm : (127 - i) % 18446744073709551616 = 127 - i := by omega
    have hlt : 127 - i < 18446744073709551616 := by omega
    obtain ⟨o1, o2⟩ := counter_overflow (i := i) (by omega)
    have hfb : Fits S.mem (d.add (80#64 + BitVec.ofNat 64 (127 - i))) 8 :=
      Fits.add_of_le (by simp [BitVec.uaddOverflow]; omega) (by simp; omega) hf
    block_init
    step_pure
    finish_block
    · exfalso
      have := congrArg BitVec.toNat hbr
      simp at this
      omega
    · block_init
      step_pure [hs1, hs2, hsub]
      step_pure [hsub, hm, hlt]
      step_pure
      step_store consuming hfb
      step_pure
      step_pure [o1, o2, ← BitVec.ofNat_add]
      finish_block
      refine ih (i + 1) (x >>> 8) S E (by omega) (by omega) hArgs (by env_reads) hf fun E' h1 h2 => ?_
      subst hS
      exact hK E' h1 h2


/-- `llvm.intr.bswap` on 64 bits, as the operation unfolds. -/
public abbrev bswap64 (x : BitVec 64) : BitVec 64 :=
  (List.range 8).foldl (fun acc i => acc ||| (x >>> (8 * i) &&& 255#64) <<< (64 - 8 * (i + 1))) 0#64

set_option maxHeartbeats 0 in
theorem out_iter (d out : Pointer) (j : Nat) (y : BitVec 64) (S : GlobalState) (E : ⟪Γ⟫) {β : Type}
    (κ : Vals [] × GlobalState → PoisonOr β) (R : PoisonOr β) (hj : j < 8)
    (hArgs : E.args = (Sha512_final.args (.value d) (.value out)).get)
    (hR : E ⊨ [%8 := 1#64, %12 := 8#64, %13 := 3#64, %39 := d.add 16#64, %40 := BitVec.ofNat 64 j])
    (hdo : d.offset.toNat + 224 < 2 ^ 64) (hfw : Fits S.mem (d.add (16#64 + BitVec.ofNat 64 (8 * j))) 64)
    (hw : S.mem.readAt (d.add (16#64 + BitVec.ofNat 64 (8 * j))) 64 = y)
    (hfo : Fits S.mem (out.add (BitVec.ofNat 64 (8 * j))) 64) (hoo : out.offset.toNat + 64 < 2 ^ 64)
    (hK : ∀ E' : ⟪Γ⟫, E'.args = (Sha512_final.args (.value d) (.value out)).get →
      (E' ⊨ [%8 := 1#64, %12 := 8#64, %13 := 3#64, %39 := d.add 16#64, %40 := BitVec.ofNat 64 (j + 1)]) →
      (Sha512_final.runFrom E' 6
        { S with mem := S.mem.storeAt (out.add (BitVec.ofNat 64 (8 * j))) (bswap64 y) } >>= κ) = R) :
    (Sha512_final.runFrom E 7 S >>= κ) = R := by
  have hm : j % 18446744073709551616 = j := by omega
  have h8 : j * 8 = 8 * j := by omega
  have hlt : 8 * j < 18446744073709551616 := by omega
  have hsh : BitVec.ofNat 64 j <<< 3 = BitVec.ofNat 64 (8 * j) := by
    apply BitVec.eq_of_toNat_eq; simp [BitVec.toNat_shiftLeft, Nat.shiftLeft_eq]; omega
  have hshr : BitVec.ofNat 64 (8 * j) >>> 3 = BitVec.ofNat 64 j := by
    apply BitVec.eq_of_toNat_eq; simp [BitVec.toNat_ushiftRight, Nat.shiftRight_eq_div_pow]; omega
  have hsshr : (BitVec.ofNat 64 (8 * j)).sshiftRight 3 = BitVec.ofNat 64 j := by
    rw [BitVec.sshiftRight_eq_of_msb_false]
    · exact hshr
    · simp [BitVec.msb_eq_decide]; omega
  have hm8 : 8 * j % 18446744073709551616 = 8 * j := by omega
  obtain ⟨o1, o2⟩ := counter_overflow (i := j) (by omega)
  block_init
  step_pure [hm, h8, hlt]
  step_load consuming hw hfw
  step_pure [hsh, hshr, hsshr]
  step_pure [hsh, hshr, hsshr, hm8, hlt]
  step_pure
  step_store consuming hfo
  step_pure [o1, o2, ← BitVec.ofNat_add]
  finish_block
  subst hS
  exact hK E hArgs (by env_reads)

/-- `f j, …, f (j + n - 1)` byte-swapped into `out` at `8 j, …`. -/
@[expose] public def outStores (out : Pointer) (f : Nat → BitVec 64) : (j n : Nat) → MemoryState → MemoryState
  | _, 0, m => m
  | j, n + 1, m => outStores out f (j + 1) n (m.storeAt (out.add (BitVec.ofNat 64 (8 * j))) (bswap64 (f j)))

theorem fits_outStores {m : MemoryState} {out : Pointer} {f : Nat → BitVec 64} :
    ∀ n j, Fits (outStores out f j n m) p w ↔ Fits m p w := by
  intro n
  induction n generalizing m with
  | zero => intro _; rfl
  | succ n ih => intro j; rw [outStores, ih]; simp

set_option maxHeartbeats 0 in
/-- `bb6`/`bb7` from word `j`, `m` left: the state words byte-swapped into `out`, then the return. -/
theorem out_loop (d out : Pointer) (f : Nat → BitVec 64) {β : Type}
    (κ : Vals [] × GlobalState → PoisonOr β) (R : PoisonOr β) (hdo : d.offset.toNat + 224 < 2 ^ 64)
    (hoo : out.offset.toNat + 64 < 2 ^ 64) (hsep : (Range.of d 1792).Disjoint (Range.of out 512)) :
    ∀ m j (S : GlobalState) (E : ⟪Γ⟫), j + m = 8 →
      E.args = (Sha512_final.args (.value d) (.value out)).get →
      (E ⊨ [%8 := 1#64, %12 := 8#64, %13 := 3#64, %39 := d.add 16#64, %40 := BitVec.ofNat 64 j]) →
      Fits S.mem d 1792 → Fits S.mem out 512 →
      (∀ k, j ≤ k → k < 8 → S.mem.readAt (d.add (16#64 + BitVec.ofNat 64 (8 * k))) 64 = f k) →
      κ (.nil, { S with mem := outStores out f j m S.mem }) = R →
      (Sha512_final.runFrom E 6 S >>= κ) = R := by
  intro m
  induction m with
  | zero =>
    intro j S E hj hArgs hR hf ho hw hfin
    obtain rfl : j = 8 := by omega
    block_init
    step_pure
    finish_block
    block_init
    finish_block
    exact hfin
  | succ m ih =>
    intro j S E hj hArgs hR hf ho hw hfin
    block_init
    step_pure
    finish_block
    · exfalso
      have := congrArg BitVec.toNat hbr
      simp at this
      omega
    · refine out_iter d out j (f j) S E κ R (by omega) hArgs (by env_reads) hdo
        (Fits.add_of_le (by simp [BitVec.uaddOverflow]; omega) (by simp; omega) hf) (hw j (by omega) (by omega))
        (Fits.add_of_le (by simp [BitVec.uaddOverflow]; omega) (by simp; omega) ho) hoo fun E' h1 h2 => ?_
      refine ih (j + 1) _ E' (by omega) h1 h2 hf.storeAt ho.storeAt (fun k hk hk' => ?_) hfin
      rw [MemoryState.readAt_storeAt_disjoint, hw k (by omega) hk']
      simp only [Range.Disjoint, Range.of, Pointer.offsetInBits, Pointer.add, BitVec.toNat_add,
        BitVec.toNat_ofNat] at hsep ⊢
      rcases hsep with h | h | h
      · exact Or.inl (Ne.symm h)
      · right; right; omega
      · right; left; omega


/-- `bb1` and the length loop: `buf[112 … 127]` the bit length `8 T` big-endian. -/
@[expose] public def lenState (s : GlobalState) (d : Pointer) : GlobalState :=
  let T := Sha512Obj.totalLen s.mem d
  { s with mem := lenStores d (T >>> 5) 1 15 (s.mem.storeAt (d.add 207#64) (BitVec.setWidth 8 T <<< 3)) }

/-- From `bb1`: the length, the last round, the digest's words into `out`. -/
@[expose] public def fromLen (s : GlobalState) (d out : Pointer) : GlobalState :=
  let s5 := Sha512_update.roundState (lenState s d) d (d.add 80#64)
  { s5 with mem := outStores out (fun k => (Sha512Obj.state s5.mem d)[k]!) 0 8 s5.mem }

theorem wf_lenStores {d : Pointer} :
    ∀ n i (x : BitVec 128) (s : GlobalState), s.WF → ({ s with mem := lenStores d x i n s.mem } : GlobalState).WF := by
  intro n
  induction n with
  | zero => intro _ _ _ h; exact h
  | succ n ih => intro i x s h; exact ih (i + 1) (x >>> 8) _ h.storeAt

set_option maxHeartbeats 0 in
/-- `bb1` on: the length into the buffer, its round, the state words byte-swapped into `out`. -/
theorem fromBB1 (d out : Pointer) (S : GlobalState) (E : ⟪Γ⟫) {β : Type}
    (κ : Vals [] × GlobalState → PoisonOr β) (R : PoisonOr β)
    (hArgs : E.args = (Sha512_final.args (.value d) (.value out)).get)
    (hR : E ⊨ [%2 := 0#64, %6 := 5#128, %7 := 3#8, %8 := 1#64, %9 := 16#64, %10 := 127#64, %11 := 8#128,
      %12 := 8#64, %13 := 3#64, %14 := d.add 80#64])
    (hwf : S.WF) (hf : Fits S.mem d 1792) (hdo : d.offset.toNat + 224 < 2 ^ 64)
    (ho : Fits S.mem out 512) (hoo : out.offset.toNat + 64 < 2 ^ 64)
    (hsep : (Range.of d 1792).Disjoint (Range.of out 512))
    (hfin : κ (.nil, fromLen S d out) = R) :
    (Sha512_final.runFrom E 1 S >>= κ) = R := by
  have hfT : Fits S.mem d 128 := Sha512_update.fits_le hf (by omega)
  have hf207 : Fits S.mem (d.add 207#64) 8 :=
    Fits.add_of_le (by simp [BitVec.uaddOverflow]; omega) (by simp) hf
  simp only [fromLen, lenState, Sha512Obj.totalLen] at hfin
  generalize hT : S.mem.readAt d 128 = T at hfin
  block_init
  step_load
  step_pure
  step_pure
  step_pure
  step_pure
  step_store consuming hf207
  finish_block
  refine len_loop d out κ R hdo 15 1 (T >>> 5) S E rfl (Nat.le_refl _) hArgs (by env_reads) hf
    fun E' h1 h2 => ?_
  subst hS
  dsimp only at hwf hf ho ⊢
  generalize hS4 : (⟨S.alloc, lenStores d (T >>> 5) 1 15
    (S.mem.storeAt (d.add 207#64) (BitVec.setWidth 8 T <<< 3))⟩ : GlobalState) = S4
  have hwf4 : S4.WF := hS4 ▸ wf_lenStores 15 1 (T >>> 5)
    ⟨S.alloc, S.mem.storeAt (d.add 207#64) (BitVec.setWidth 8 T <<< 3)⟩ hwf
  have hf4 : Fits S4.mem d 1792 := hS4 ▸ (fits_lenStores 15 1 (T >>> 5)).2 hf
  have ho4 : Fits S4.mem out 512 := hS4 ▸ (fits_lenStores 15 1 (T >>> 5)).2 ho
  have hd640 : Fits S4.mem d 640 := Sha512_update.fits_le hf4 (by omega)
  have hd80 : Fits S4.mem (d.add 80#64) 1024 :=
    Fits.add_of_le (by simp [BitVec.uaddOverflow]; omega) (by simp) hf4
  have hdo80 : (d.add 80#64).offset.toNat + 128 < 2 ^ 64 := by
    simp [Pointer.add, BitVec.toNat_add]; omega
  have hdo' : d.offset.toNat + 80 < 2 ^ 64 := by omega
  block_init
  step_call using Sha512_round.call_eq consuming hwf4 hd640 hd80 hf4 ho4
  have hS5 : S = Sha512_update.roundState S4 d (d.add 80#64) := hS
  have hf5 : Fits S.mem d 1792 := by
    rw [hS5]; exact Sha512_update.roundState_fits.2 (hS4 ▸ (fits_lenStores 15 1 (T >>> 5)).2 hf)
  have ho5 : Fits S.mem out 512 := by
    rw [hS5]; exact Sha512_update.roundState_fits.2 (hS4 ▸ (fits_lenStores 15 1 (T >>> 5)).2 ho)
  step_pure
  finish_block
  refine out_loop d out (fun k => (Sha512Obj.state S.mem d)[k]!) κ R hdo hoo hsep 8 0 S E rfl hArgs
    (by env_reads) hf5 ho5 (fun k _ hk => by simp [Sha512Obj.state, hk]) ?_
  rw [hS5, ← hS4]
  exact hfin

/-- `bb0`: `buf[bl …]` zeroed, `buf[bl] = 0x80`, `buf_len` one more. -/
@[expose] public def padMem (m : MemoryState) (d : Pointer) (bl : BitVec 8) : MemoryState :=
  ((m.storeAt (d.add (80#64 + BitVec.setWidth 64 bl))
        (BitVec.replicate (BitVec.ofNat 64 (128 - bl.toNat)).toNat 0#8)).storeAt
      (d.add (80#64 + BitVec.setWidth 64 bl)) 128#8).storeAt
    (d.add 208#64) (bl + 1#8)

set_option maxHeartbeats 0 in
/-- `bb2`: the padded block's round, the buffer zeroed. -/
theorem bb2_run (d out : Pointer) (A : AllocState) (M : MemoryState) (E : ⟪Γ⟫) {β : Type}
    (κ : Vals [] × GlobalState → PoisonOr β) (R : PoisonOr β)
    (hArgs : E.args = (Sha512_final.args (.value d) (.value out)).get)
    (hR : E ⊨ [%0 := 128#64, %1 := 0#8, %2 := 0#64, %6 := 5#128, %7 := 3#8, %8 := 1#64, %9 := 16#64,
      %10 := 127#64, %11 := 8#128, %12 := 8#64, %13 := 3#64, %14 := d.add 80#64])
    (hwf : ({ alloc := A, mem := M } : GlobalState).WF) (hf : Fits M d 1792)
    (hdo : d.offset.toNat + 224 < 2 ^ 64)
    (hK : ∀ E' : ⟪Γ⟫, E'.args = (Sha512_final.args (.value d) (.value out)).get →
      (E' ⊨ [%0 := 128#64, %1 := 0#8, %2 := 0#64, %6 := 5#128, %7 := 3#8, %8 := 1#64, %9 := 16#64,
      %10 := 127#64, %11 := 8#128, %12 := 8#64, %13 := 3#64, %14 := d.add 80#64]) →
      (Sha512_final.runFrom E' 1
        { Sha512_update.roundState ⟨A, M⟩ d (d.add 80#64) with
          mem := (Sha512_update.roundState ⟨A, M⟩ d (d.add 80#64)).mem.storeAt (d.add 80#64) 0#1024 } >>= κ) =
        R) :
    (Sha512_final.runFrom E 2 ⟨A, M⟩ >>= κ) = R := by
  have hd640 : Fits M d 640 := Sha512_update.fits_le hf (by omega)
  have hd80 : Fits M (d.add 80#64) 1024 :=
    Fits.add_of_le (by simp [BitVec.uaddOverflow]; omega) (by simp) hf
  have hdo80 : (d.add 80#64).offset.toNat + 128 < 2 ^ 64 := by
    simp [Pointer.add, BitVec.toNat_add]; omega
  have hdo' : d.offset.toNat + 80 < 2 ^ 64 := by omega
  have hmz : Fits (Sha512_update.roundState ⟨A, M⟩ d (d.add 80#64)).mem (d.add 80#64) (8 * (128#64).toNat) :=
    Sha512_update.roundState_fits.2 hd80
  block_init
  step_call using Sha512_round.call_eq consuming hwf
  have hmz' : Fits S.mem (d.add 80#64) (8 * (128#64).toNat) := by rw [hS]; exact hmz
  step_memset consuming hmz'
  finish_block
  subst hS
  exact hK E hArgs (by env_reads)

/-- The state `Sha512.final` leaves: the padding into the buffer (a round first if the length no
longer fits), the bit length, the last round, the digest into `out`. -/
@[expose] public def post (s : GlobalState) (d out : Pointer) : GlobalState :=
  let bl := Sha512Obj.bufLen s.mem d
  let s1 : GlobalState := { s with mem := padMem s.mem d bl }
  let s2 : GlobalState :=
    if 111 < bl.toNat then
      let r := Sha512_update.roundState s1 d (d.add 80#64)
      { r with mem := r.mem.storeAt (d.add 80#64) 0#1024 }
    else s1
  fromLen s2 d out

theorem SameBlocks.lenStores {m m' : MemoryState} (h : Sha512_update.SameBlocks m m') {d : Pointer} :
    ∀ n i (x : BitVec 128), Sha512_update.SameBlocks (lenStores d x i n m) m' := by
  intro n
  induction n generalizing m with
  | zero => intro _ _; exact h
  | succ n ih => intro i x; exact ih h.storeAt (i + 1) (x >>> 8)

theorem SameBlocks.outStores {m m' : MemoryState} (h : Sha512_update.SameBlocks m m') {out : Pointer}
    {f : Nat → BitVec 64} : ∀ n j, Sha512_update.SameBlocks (outStores out f j n m) m' := by
  intro n
  induction n generalizing m with
  | zero => intro _; exact h
  | succ n ih => intro j; exact ih h.storeAt (j + 1)

theorem SameBlocks.fromLen {s : GlobalState} {m' : MemoryState} (h : Sha512_update.SameBlocks s.mem m') :
    Sha512_update.SameBlocks (fromLen s d out).mem m' :=
  SameBlocks.outStores (Sha512_update.SameBlocks.roundState
    (SameBlocks.lenStores h.storeAt 15 1 _)) 8 0

theorem fin_eq {s X : GlobalState} (hwf : s.WF) (h : Sha512_update.SameBlocks (fromLen X d out).mem s.mem) :
    PoisonOr.value ((Vals.nil, fromLen X d out).fst,
      ({ alloc := (Vals.nil, fromLen X d out).snd.alloc
         mem := (Vals.nil, fromLen X d out).snd.mem.eraseFrom s.alloc.nextFreeBlock } : GlobalState)) =
      PoisonOr.value (Vals.nil, fromLen X d out) := by
  simp only [h.eraseFrom hwf]

set_option maxHeartbeats 0 in
/-- `Sha512.final` on the object at `d` leaves `post`, the digest at `out`; `out` apart from the
object. -/
public theorem call_eq (d out : Pointer) (s : GlobalState) (hwf : s.WF) (hf : Fits s.mem d 1792)
    (hdo : d.offset.toNat + 224 < 2 ^ 64) (ho : Fits s.mem out 512) (hoo : out.offset.toNat + 64 < 2 ^ 64)
    (hsep : (Range.of d 1792).Disjoint (Range.of out 512)) (hbl : (Sha512Obj.bufLen s.mem d).toNat < 128) :
    Sha512_final.call (Sha512_final.args (.value d) (.value out)) s = .value (.nil, post s d out) := by
  generalize hbl0 : Sha512Obj.bufLen s.mem d = bl at hbl
  have hblr : s.mem.readAt (d.add 208#64) 8 = bl := hbl0
  have hf208 : Fits s.mem (d.add 208#64) 8 :=
    Fits.add_of_le (by simp [BitVec.uaddOverflow]; omega) (by simp) hf
  func_init
  have hb0 : Sha512Obj.bufLen S₀.mem d = bl := hS ▸ hbl0
  have hf0 : Fits S₀.mem d 1792 := hS ▸ hf
  have ho0 : Fits S₀.mem out 512 := hS ▸ ho
  have hwf0 : S₀.WF := hS ▸ hwf
  clear hbl0
  have hblm : bl.toNat % 18446744073709551616 = bl.toNat := Nat.mod_eq_of_lt (by omega)
  have hblt : bl.toNat < 18446744073709551616 := by omega
  have hs1 : (128#64).ssubOverflow (BitVec.setWidth 64 bl) = false := by bv_decide
  have hs2 : (128#64).usubOverflow (BitVec.setWidth 64 bl) = false := by
    simp [BitVec.usubOverflow]; omega
  have hk : 128#64 - BitVec.setWidth 64 bl = BitVec.ofNat 64 (128 - bl.toNat) := by
    apply BitVec.eq_of_toNat_eq; simp; omega
  have hkn : (BitVec.ofNat 64 (128 - bl.toNat)).toNat = 128 - bl.toNat := by simp; omega
  have hms : Fits S.mem (d.add (80#64 + BitVec.setWidth 64 bl)) (8 * (BitVec.ofNat 64 (128 - bl.toNat)).toNat) := by
    rw [hkn]; exact Fits.add_of_le (by simp [BitVec.uaddOverflow]; omega) (by simp; omega) hf
  have hdisB : (Range.of (d.add (80#64 + BitVec.setWidth 64 bl)) (8 * (BitVec.ofNat 64 (128 - bl.toNat)).toNat)).Disjoint
      (Range.of (d.add 208#64) 8) := by
    rw [hkn]
    simp only [Range.Disjoint, Range.of, Pointer.offsetInBits, Pointer.add, BitVec.toNat_add,
      BitVec.toNat_setWidth, BitVec.toNat_ofNat]
    right; left; omega
  block_init
  iterate 16 step_pure
  step_load
  step_pure
  step_pure [hblm, hblt]
  step_pure [hs1, hs2, hk]
  step_memset consuming hms
  step_load
  step_pure
  step_pure [hblm, hblt]
  have hf8 : Fits S.mem (d.add (80#64 + BitVec.setWidth 64 bl)) 8 := by
    rw [hS]; exact (Fits.add_of_le (by simp [BitVec.uaddOverflow]; omega) (by simp; omega) hf0).storeAt
  have hdis8 : (Range.of (d.add (80#64 + BitVec.setWidth 64 bl)) 8).Disjoint (Range.of (d.add 208#64) 8) := by
    simp only [Range.Disjoint, Range.of, Pointer.offsetInBits, Pointer.add, BitVec.toNat_add,
      BitVec.toNat_setWidth, BitVec.toNat_ofNat]
    right; left; omega
  step_store consuming hf8
  have hov : bl.uaddOverflow 1#8 = false := by simp [BitVec.uaddOverflow]; omega
  step_load
  step_pure [hov]
  step_store
  step_pure
  finish_block
  · have hfS : Fits S.mem d 1792 := by rw [hS]; simp only [Fits.storeAt_iff]; exact hf0
    have hd640 : Fits S.mem d 640 := Sha512_update.fits_le hfS (by omega)
    have hd80 : Fits S.mem (d.add 80#64) 1024 :=
      Fits.add_of_le (by simp [BitVec.uaddOverflow]; omega) (by simp) hfS
    have hdo80 : (d.add 80#64).offset.toNat + 128 < 2 ^ 64 := by
      simp [Pointer.add, BitVec.toNat_add]; omega
    have hdo' : d.offset.toNat + 80 < 2 ^ 64 := by omega
    subst hS
    dsimp only at hfS
    refine bb2_run d out _ _ E _ _ hArgs (by env_reads) hwf hfS hdo fun E' h1 h2 => ?_
    dsimp only at ho
    refine fromBB1 d out _ E' _ _ h1 (by env_reads) (Sha512_update.roundState_wf hwf).storeAt
      (Sha512_update.roundState_fits.2 hfS).storeAt hdo (Sha512_update.roundState_fits.2 ho).storeAt
      hoo hsep ?_
    have hc : 111 < bl.toNat := by simp [BitVec.ult] at hbr; omega
    rw [fin_eq hwf0 (SameBlocks.fromLen (Sha512_update.SameBlocks.storeAt
      (Sha512_update.SameBlocks.roundState (fun _ => (MemoryState.mem_storeAt.trans
        (MemoryState.mem_storeAt.trans MemoryState.mem_storeAt))))))]
    simp only [post, hb0]
    rw [ite_eq_left_of_eq_true _ _ (eq_true hc)]
    rfl
  · have hc : ¬ 111 < bl.toNat := by simp [BitVec.ult] at hbr; omega
    subst hS
    dsimp only at hf ho
    refine fromBB1 d out _ E _ _ hArgs (by env_reads) hwf hf hdo ho hoo hsep ?_
    rw [fin_eq hwf0 (SameBlocks.fromLen (fun _ => (MemoryState.mem_storeAt.trans
        (MemoryState.mem_storeAt.trans MemoryState.mem_storeAt))))]
    simp only [post, hb0]
    rw [ite_eq_right_of_eq_false _ _ (eq_false hc)]
    rfl

/-! ## The digest -/

/-- A byte read at `d + a` through a store at `d + c`: the stored byte, else the old one. -/
theorem readAt_byte_storeAt {m : MemoryState} {d : Pointer} {c a : BitVec 64} {w : Nat} {x : BitVec w}
    (hf : Fits m d 1792) (hdo : d.offset.toNat + 224 < 2 ^ 64) (hc : c.toNat * 8 + w ≤ 1792)
    (ha : a.toNat < 224) (hw : w % 8 = 0) :
    (m.storeAt (d.add c) x).readAt (d.add a) 8 =
      if c.toNat ≤ a.toNat ∧ a.toNat * 8 < c.toNat * 8 + w then x.extractLsb' (8 * (a.toNat - c.toNat)) 8
      else m.readAt (d.add a) 8 := by
  have hfc : Fits m (d.add c) w := Fits.add_of_le (by simp [BitVec.uaddOverflow]; omega) (by omega) hf
  have hoff (b : BitVec 64) (hb : b.toNat ≤ 224) : (d.add b).offsetInBits = d.offsetInBits + b.toNat * 8 := by
    rw [Pointer.offsetInBits_add (by simp [BitVec.uaddOverflow]; omega)]
  split
  · rw [MemoryState.readAt_storeAt_subrange (q := d.add a) (w' := 8) hfc rfl (by rw [hoff c (by omega), hoff a (by omega)]; omega)
      (by rw [hoff c (by omega), hoff a (by omega)]; omega)]
    congr 1
    rw [hoff c (by omega), hoff a (by omega)]
    omega
  · rw [MemoryState.readAt_storeAt_disjoint]
    simp only [Range.Disjoint, Range.of, hoff c (by omega), hoff a (by omega), Pointer.add_id]
    omega

/-- `buf`'s bytes, by their reads. -/
theorem bytesLE_buf {m : MemoryState} {d : Pointer} (hf : Fits m d 1792)
    (hdo : d.offset.toNat + 224 < 2 ^ 64) {L : List (BitVec 8)} (hL : L.length = 128)
    (h : ∀ k (hk : k < 128), m.readAt (d.add (BitVec.ofNat 64 (80 + k))) 8 = L[k]) :
    bytesLE (Sha512Obj.buf m d) = L := by
  apply List.ext_getElem
  · simp [hL]
  · intro k h1 h2
    simp only [length_bytesLE] at h1
    rw [getElem_bytesLE, ← h k (by omega), Sha512Obj.buf, show BitVec.ofNat 64 (80 + k) = 80#64 + BitVec.ofNat 64 k by
      apply BitVec.eq_of_toNat_eq; simp, ← Pointer.add_add,
      MemoryState.readAt_add_of_readAt (v := 1024) (w := 8)
        (Fits.add_of_le (w := 1024) (by simp [BitVec.uaddOverflow]; omega) (by simp) hf)
        (by simp [BitVec.uaddOverflow, Pointer.add, BitVec.toNat_add]; omega) (by simp; omega) rfl]
    congr 1
    simp
    omega

/-- Byte `k` of `buf`, read by itself. -/
theorem readAt_byte_buf {m : MemoryState} {d : Pointer} (hf : Fits m d 1792)
    (hdo : d.offset.toNat + 224 < 2 ^ 64) {k : Nat} (hk : k < 128) :
    m.readAt (d.add (BitVec.ofNat 64 (80 + k))) 8 = (bytesLE (Sha512Obj.buf m d))[k]'(by simp; omega) := by
  rw [getElem_bytesLE, Sha512Obj.buf, show BitVec.ofNat 64 (80 + k) = 80#64 + BitVec.ofNat 64 k by
      apply BitVec.eq_of_toNat_eq; simp, ← Pointer.add_add,
    MemoryState.readAt_add_of_readAt (v := 1024) (w := 8)
      (Fits.add_of_le (w := 1024) (by simp [BitVec.uaddOverflow]; omega) (by simp) hf)
      (by simp [BitVec.uaddOverflow, Pointer.add, BitVec.toNat_add]; omega) (by simp; omega) rfl]
  congr 1
  simp
  omega

/-- `bb0`'s buffer: the buffered bytes `P`, `0x80`, zeros. -/
theorem buf_padMem {m : MemoryState} {d : Pointer} {bl : BitVec 8} {P : List (BitVec 8)}
    (hf : Fits m d 1792) (hdo : d.offset.toNat + 224 < 2 ^ 64) (hbl : bl.toNat < 128)
    (hP : (bytesLE (Sha512Obj.buf m d)).take bl.toNat = P) :
    bytesLE (Sha512Obj.buf (padMem m d bl) d) = P ++ [0x80#8] ++ List.replicate (127 - bl.toNat) 0#8 := by
  have hPl : P.length = bl.toNat := by rw [← hP]; simp; omega
  have hX : (80#64 + BitVec.setWidth 64 bl).toNat = 80 + bl.toNat := by simp; omega
  have hk' : (BitVec.ofNat 64 (128 - bl.toNat)).toNat = 128 - bl.toNat := by simp; omega
  have hf1 : Fits (m.storeAt (d.add (80#64 + BitVec.setWidth 64 bl))
      (BitVec.replicate (BitVec.ofNat 64 (128 - bl.toNat)).toNat 0#8)) d 1792 := hf.storeAt
  apply bytesLE_buf (Fits.storeAt (Fits.storeAt hf1)) hdo (by simp [hPl]; omega)
  intro k hk
  have ha : (BitVec.ofNat 64 (80 + k)).toNat = 80 + k := by simp; omega
  try simp only [padMem]
  rw [readAt_byte_storeAt hf1.storeAt hdo (by simp) (by rw [ha]; omega) (by decide)]
  rw [ite_eq_right_of_eq_false _ _ (eq_false (by simp; omega))]
  rw [readAt_byte_storeAt hf1 hdo (by rw [hX]; omega) (by rw [ha]; omega) (by decide)]
  by_cases e : k = bl.toNat
  · rw [ite_eq_left_of_eq_true _ _ (eq_true (by rw [hX, ha]; omega))]
    subst e
    simp [hPl]
  · rw [ite_eq_right_of_eq_false _ _ (eq_false (by rw [hX, ha]; omega)),
      readAt_byte_storeAt hf hdo (by rw [hX, hk']; omega) (by rw [ha]; omega) (by omega)]
    by_cases lt : k < bl.toNat
    · rw [ite_eq_right_of_eq_false _ _ (eq_false (by rw [hX, ha]; omega)), readAt_byte_buf hf hdo hk]
      rw [List.getElem_append_left (by simp [hPl]; omega), List.getElem_append_left (by simp [hPl]; omega)]
      simp only [← hP, List.getElem_take]
    · rw [ite_eq_left_of_eq_true _ _ (eq_true (by rw [hX, ha, hk']; omega))]
      rw [List.getElem_append_right (by simp [hPl]; omega)]
      simp only [List.getElem_replicate]
      apply BitVec.eq_of_getLsbD_eq
      intro i hi
      simp [BitVec.getLsbD_extractLsb', BitVec.getLsbD_replicate]

/-- Byte `80 + k` after the length loop's stores from `i`, `n` of them. -/
theorem readAt_lenStores {d : Pointer} (hdo : d.offset.toNat + 224 < 2 ^ 64) {k : Nat} (hk : k < 128) :
    ∀ n i (x : BitVec 128) (m : MemoryState), Fits m d 1792 → i + n ≤ 16 → 1 ≤ i →
      (lenStores d x i n m).readAt (d.add (BitVec.ofNat 64 (80 + k))) 8 =
        if i ≤ 127 - k ∧ 127 - k < i + n ∧ 112 ≤ k then BitVec.setWidth 8 (x >>> (8 * (127 - k - i)))
        else m.readAt (d.add (BitVec.ofNat 64 (80 + k))) 8 := by
  have ha : (BitVec.ofNat 64 (80 + k)).toNat = 80 + k := by simp; omega
  intro n
  induction n with
  | zero => intro i x m _ _ _; rw [ite_eq_right_of_eq_false _ _ (eq_false (by omega))]; rfl
  | succ n ih =>
    intro i x m hf h1 h2
    have hc : (BitVec.ofNat 64 (127 - i)).toNat = 127 - i := by simp; omega
    have hc' : (80#64 + BitVec.ofNat 64 (127 - i)).toNat = 80 + (127 - i) := by simp; omega
    rw [lenStores, ih (i + 1) (x >>> 8) _ hf.storeAt (by omega) (by omega),
      readAt_byte_storeAt hf hdo (by rw [hc']; omega) (by rw [ha]; omega) (by decide)]
    by_cases e : 127 - k = i ∧ 112 ≤ k
    · rw [ite_eq_right_of_eq_false _ _ (eq_false (by omega)),
        ite_eq_left_of_eq_true _ _ (eq_true (by rw [hc', ha]; omega)),
        ite_eq_left_of_eq_true _ _ (eq_true (by omega))]
      rw [show 127 - k - i = 0 by omega]
      apply BitVec.eq_of_getLsbD_eq
      intro b hb
      simp [hc', ha, show 80 + k - (80 + (127 - i)) = 0 by omega, hb]
    · by_cases r : i + 1 ≤ 127 - k ∧ 127 - k < i + 1 + n ∧ 112 ≤ k
      · rw [ite_eq_left_of_eq_true _ _ (eq_true r),
          ite_eq_left_of_eq_true _ _ (eq_true (show i ≤ 127 - k ∧ 127 - k < i + (n + 1) ∧ 112 ≤ k by omega))]
        rw [← BitVec.shiftRight_add, show 8 + 8 * (127 - k - (i + 1)) = 8 * (127 - k - i) by omega]
      · rw [ite_eq_right_of_eq_false _ _ (eq_false r),
          ite_eq_right_of_eq_false _ _ (eq_false (by rw [hc', ha]; omega)),
          ite_eq_right_of_eq_false _ _ (eq_false (show ¬(i ≤ 127 - k ∧ 127 - k < i + (n + 1) ∧ 112 ≤ k) by omega))]

/-- The length loop's buffer: the first 112 bytes kept, then `8 total_len` big-endian. -/
theorem buf_lenState {s : GlobalState} {d : Pointer} (hf : Fits s.mem d 1792)
    (hdo : d.offset.toNat + 224 < 2 ^ 64) :
    bytesLE (Sha512Obj.buf (lenState s d).mem d) =
      (bytesLE (Sha512Obj.buf s.mem d)).take 112 ++ Sha512.bytesBE (Sha512Obj.totalLen s.mem d <<< 3) := by
  generalize hT : Sha512Obj.totalLen s.mem d = T
  simp only [lenState, hT]
  have hf1 : Fits (s.mem.storeAt (d.add 207#64) (BitVec.setWidth 8 T <<< 3)) d 1792 := hf.storeAt
  apply bytesLE_buf ((fits_lenStores 15 1 _).2 hf1) hdo (by simp [Sha512.bytesBE])
  intro k hk
  have ha : (BitVec.ofNat 64 (80 + k)).toNat = 80 + k := by simp; omega
  rw [readAt_lenStores hdo hk 15 1 _ _ hf1 (by omega) (Nat.le_refl _)]
  by_cases h1 : 112 ≤ k ∧ k ≤ 126
  · rw [ite_eq_left_of_eq_true _ _ (eq_true (by omega)),
      List.getElem_append_right (by simp; omega)]
    simp only [Sha512.bytesBE, List.getElem_reverse, length_bytesLE, List.length_take]
    rw [getElem_bytesLE]
    apply BitVec.eq_of_getLsbD_eq
    intro b hb
    simp only [BitVec.getLsbD_setWidth, BitVec.getLsbD_ushiftRight, BitVec.getLsbD_extractLsb',
      BitVec.getLsbD_shiftLeft]
    simp only [hb, decide_true, Bool.true_and]
    rw [show 5 + (8 * (127 - k - 1) + b) = 8 * (15 - (k - 112)) + b - 3 by omega]
    simp [show 8 * (15 - (k - 112)) + b < 128 by omega, show ¬(8 * (15 - (k - 112)) + b < 3) by omega]
  · rw [ite_eq_right_of_eq_false _ _ (eq_false (by omega)),
      readAt_byte_storeAt hf hdo (by simp) (by rw [ha]; omega) (by decide)]
    by_cases h2 : k = 127
    · subst h2
      rw [ite_eq_left_of_eq_true _ _ (eq_true (by rw [ha]; simp)),
        List.getElem_append_right (by simp)]
      simp only [Sha512.bytesBE, List.getElem_reverse, length_bytesLE, List.length_take, getElem_bytesLE]
      simp only [show (BitVec.ofNat 64 (80 + 127)).toNat - (207#64).toNat = 0 by decide,
        show 128 / 8 - 1 - (127 - min 112 (1024 / 8)) = 0 by decide]
      bv_decide
    · rw [ite_eq_right_of_eq_false _ _ (eq_false (by rw [ha]; simp; omega)), readAt_byte_buf hf hdo hk,
        List.getElem_append_left (by simp; omega), List.getElem_take]


/-! ### The output -/

theorem bytesLE_bswap64 (x : BitVec 64) : bytesLE (bswap64 x) = Sha512.bytesBE x := by
  simp only [Sha512.bytesBE, bytesLE, bswap64, List.range, List.range.loop, List.foldl, List.ofFn_succ,
    List.ofFn_zero, List.reverse_cons, List.reverse_nil, List.nil_append, List.cons_append,
    List.cons.injEq, Fin.val_succ, Fin.val_zero, and_true]
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩ <;> bv_decide

/-- Eight 64-bit words spliced in order fill 512 bits. -/
theorem splice8 (r : BitVec 512) (x0 x1 x2 x3 x4 x5 x6 x7 : BitVec 64) :
    Memory.spliceBits (Memory.spliceBits (Memory.spliceBits (Memory.spliceBits (Memory.spliceBits
      (Memory.spliceBits (Memory.spliceBits (Memory.spliceBits r 0 x0) 64 x1) 128 x2) 192 x3) 256 x4)
      320 x5) 384 x6) 448 x7 = x7 ++ x6 ++ x5 ++ x4 ++ x3 ++ x2 ++ x1 ++ x0 := by
  simp only [Memory.spliceBits]
  bv_decide

theorem readAt_storeAt_out {m : MemoryState} {out : Pointer} (hfo : Fits m out 512)
    (hoo : out.offset.toNat + 64 < 2 ^ 64) {j : Nat} (hj : j < 8) (x : BitVec 64) :
    (m.storeAt (out.add (BitVec.ofNat 64 (8 * j))) x).readAt out 512 =
      Memory.spliceBits (m.readAt out 512) (64 * j) x := by
  rw [MemoryState.readAt_add_storeAt hfo (by simp [BitVec.uaddOverflow]; omega) (by simp; omega)]
  congr 1
  simp
  omega

/-- The 64 bytes `outStores` writes: each word big-endian. -/
theorem bytesLE_outStores {m : MemoryState} {out : Pointer} (hfo : Fits m out 512)
    (hoo : out.offset.toNat + 64 < 2 ^ 64) (f : Nat → BitVec 64) :
    bytesLE ((outStores out f 0 8 m).readAt out 512) =
      Sha512.bytesBE (f 0) ++ Sha512.bytesBE (f 1) ++ Sha512.bytesBE (f 2) ++ Sha512.bytesBE (f 3) ++
        Sha512.bytesBE (f 4) ++ Sha512.bytesBE (f 5) ++ Sha512.bytesBE (f 6) ++ Sha512.bytesBE (f 7) := by
  simp only [outStores]
  rw [readAt_storeAt_out (by simp [Fits.storeAt_iff, hfo]) hoo (j := 7) (by omega),
    readAt_storeAt_out (by simp [Fits.storeAt_iff, hfo]) hoo (j := 6) (by omega),
    readAt_storeAt_out (by simp [Fits.storeAt_iff, hfo]) hoo (j := 5) (by omega),
    readAt_storeAt_out (by simp [Fits.storeAt_iff, hfo]) hoo (j := 4) (by omega),
    readAt_storeAt_out (by simp [Fits.storeAt_iff, hfo]) hoo (j := 3) (by omega),
    readAt_storeAt_out (by simp [Fits.storeAt_iff, hfo]) hoo (j := 2) (by omega),
    readAt_storeAt_out (by simp [Fits.storeAt_iff, hfo]) hoo (j := 1) (by omega),
    readAt_storeAt_out hfo hoo (j := 0) (by omega)]
  simp only [show 64 * 0 = 0 from rfl, show 64 * 1 = 64 from rfl, show 64 * 2 = 128 from rfl,
    show 64 * 3 = 192 from rfl, show 64 * 4 = 256 from rfl, show 64 * 5 = 320 from rfl,
    show 64 * 6 = 384 from rfl, show 64 * 7 = 448 from rfl, splice8]
  simp only [bytesLE_append _ _ (by decide : 64 % 8 = 0), bytesLE_bswap64, List.append_assoc]


/-! ### The state words and counts through the stores -/

theorem state_padMem {m : MemoryState} {d : Pointer} {bl : BitVec 8} (hdo : d.offset.toNat + 224 < 2 ^ 64)
    (hbl : bl.toNat < 128) : Sha512Obj.state (padMem m d bl) d = Sha512Obj.state m d := by
  have hX : (80#64 + BitVec.setWidth 64 bl).toNat = 80 + bl.toNat := by simp; omega
  have hk : (BitVec.ofNat 64 (128 - bl.toNat)).toNat = 128 - bl.toNat := by simp; omega
  simp only [padMem]
  rw [Sha512_update.state_storeAt hdo (Sha512_update.obj_disjoint hdo (by decide) (by decide) (by simp)),
    Sha512_update.state_storeAt hdo (Sha512_update.obj_disjoint hdo (by rw [hX]; omega) (by decide)
      (by rw [hX]; simp; omega)),
    Sha512_update.state_storeAt hdo (Sha512_update.obj_disjoint hdo (by rw [hX]; omega) (by decide)
      (by rw [hX, hk]; simp; omega))]

theorem totalLen_padMem {m : MemoryState} {d : Pointer} {bl : BitVec 8} (hdo : d.offset.toNat + 224 < 2 ^ 64)
    (hbl : bl.toNat < 128) : Sha512Obj.totalLen (padMem m d bl) d = Sha512Obj.totalLen m d := by
  have hX : (80#64 + BitVec.setWidth 64 bl).toNat = 80 + bl.toNat := by simp; omega
  have hk : (BitVec.ofNat 64 (128 - bl.toNat)).toNat = 128 - bl.toNat := by simp; omega
  have h0 (c : BitVec 64) (w : Nat) (hc : c.toNat ≤ 224) (h : 128 ≤ c.toNat * 8) :
      (Range.of (d.add c) w).Disjoint (Range.of d 128) := by
    simpa using Sha512_update.obj_disjoint (a := c) (c := 0#64) (v := w) (w := 128) hdo hc (by decide)
      (by simp; omega)
  simp only [padMem, Sha512Obj.totalLen]
  rw [MemoryState.readAt_storeAt_disjoint (h0 _ _ (by decide) (by decide)),
    MemoryState.readAt_storeAt_disjoint (h0 _ _ (by rw [hX]; omega) (by rw [hX]; omega)),
    MemoryState.readAt_storeAt_disjoint (h0 _ _ (by rw [hX]; omega) (by rw [hX]; omega))]

theorem state_lenStores {d : Pointer} (hdo : d.offset.toNat + 224 < 2 ^ 64) :
    ∀ n i (x : BitVec 128) (m : MemoryState), i + n ≤ 16 →
      Sha512Obj.state (lenStores d x i n m) d = Sha512Obj.state m d := by
  intro n
  induction n with
  | zero => intro _ _ _ _; rfl
  | succ n ih =>
    intro i x m h
    have hc : (80#64 + BitVec.ofNat 64 (127 - i)).toNat = 80 + (127 - i) := by simp; omega
    rw [lenStores, ih _ _ _ (by omega),
      Sha512_update.state_storeAt hdo (Sha512_update.obj_disjoint hdo (by rw [hc]; omega) (by decide)
        (by rw [hc]; simp; omega))]

theorem state_lenState {s : GlobalState} {d : Pointer} (hdo : d.offset.toNat + 224 < 2 ^ 64) :
    Sha512Obj.state (lenState s d).mem d = Sha512Obj.state s.mem d := by
  simp only [lenState]
  rw [state_lenStores hdo 15 1 _ _ (by omega),
    Sha512_update.state_storeAt hdo (Sha512_update.obj_disjoint hdo (by decide) (by decide) (by simp))]


/-- The digest's words: the object's state after `final`'s last round. -/
theorem state_final {s : GlobalState} {d : Pointer} {M : List (BitVec 8)}
    (hA : Sha512Obj.Absorbed s.mem d M) (hf : Fits s.mem d 1792) (hdo : d.offset.toNat + 224 < 2 ^ 64) :
    let bl := Sha512Obj.bufLen s.mem d
    let s1 : GlobalState := { s with mem := padMem s.mem d bl }
    let s2 : GlobalState :=
      if 111 < bl.toNat then
        let r := Sha512_update.roundState s1 d (d.add 80#64)
        { r with mem := r.mem.storeAt (d.add 80#64) 0#1024 }
      else s1
    Sha512Obj.state (Sha512_update.roundState (lenState s2 d) d (d.add 80#64)).mem d =
      Sha512.compressBlocks Sha512.IV (Sha512.pad M) := by
  intro bl s1 s2
  have hblM : bl.toNat = M.length % 128 := hA.bufLen
  have hbl : bl.toNat < 128 := by omega
  have hf1 : Fits s1.mem d 1792 := by simp only [s1, padMem, Fits.storeAt_iff]; exact hf
  have hP := buf_padMem (P := M.drop (M.length / 128 * 128)) hf hdo hbl (by rw [hblM]; exact hA.buf)
  have hT1 : Sha512Obj.totalLen s1.mem d = BitVec.ofNat 128 M.length := by
    simp only [s1]; rw [totalLen_padMem hdo hbl, hA.totalLen]
  have hst1 : Sha512Obj.state s1.mem d = Sha512.compressBlocks Sha512.IV M := by
    simp only [s1]; rw [state_padMem hdo hbl, hA.state]
  have hPl : (M.drop (M.length / 128 * 128)).length = bl.toNat := by simp; omega
  have hL : BitVec.ofNat 128 M.length <<< 3 = BitVec.ofNat 128 (8 * M.length) := by
    apply BitVec.eq_of_toNat_eq; simp [BitVec.toNat_shiftLeft, Nat.shiftLeft_eq]; omega
  -- the last round on `lenState s2`
  have hf2 : Fits s2.mem d 1792 := by
    simp only [s2]; split
    · exact (Sha512_update.roundState_fits.2 hf1).storeAt
    · exact hf1
  have hfl : Fits (lenState s2 d).mem d 1792 := by
    simp only [lenState]; exact (fits_lenStores 15 1 _).2 hf2.storeAt
  rw [Sha512_update.roundState, Sha512_update.state_setState hfl hdo, state_lenState hdo,
    show (lenState s2 d).mem.readAt (d.add 80#64) 1024 = Sha512Obj.buf (lenState s2 d).mem d from rfl,
    buf_lenState hf2 hdo]
  simp only [s2]
  split
  · rename_i hc
    have hr80 := Sha512_update.obj_disjoint (d := d) (a := 80#64) (c := 16#64) (v := 1024) (w := 512) hdo
      (by decide) (by decide) (by simp)
    have hfr : Fits (Sha512_update.roundState s1 d (d.add 80#64)).mem (d.add 80#64) 1024 :=
      Sha512_update.roundState_fits.2 (Fits.add_of_le (by simp [BitVec.uaddOverflow]; omega) (by simp) hf1)
    have hT0 : (Range.of (d.add 80#64) 1024).Disjoint (Range.of d 128) := by
      simpa using Sha512_update.obj_disjoint (d := d) (a := 80#64) (c := 0#64) (v := 1024) (w := 128) hdo
        (by decide) (by decide) (by simp)
    dsimp only
    rw [Sha512_update.state_storeAt hdo hr80, Sha512Obj.buf, MemoryState.readAt_storeAt_self hfr,
      Sha512Obj.totalLen, MemoryState.readAt_storeAt_disjoint hT0,
      Sha512_update.roundState_readAt (by omega) (Sha512_update.disjoint_totalLen hdo),
      ← Sha512Obj.totalLen, hT1, hL, Sha512_update.roundState,
      Sha512_update.state_setState hf1 hdo, hst1,
      show s1.mem.readAt (d.add 80#64) 1024 = Sha512Obj.buf s1.mem d from rfl, hP]
    have hz : bytesLE (0#1024) = List.replicate 128 (0#8) := by
      apply List.ext_getElem
      · simp
      · intro i h1 h2; rw [getElem_bytesLE, List.getElem_replicate]; simp
    rw [hz, List.take_replicate, Sha512.pad, show (239 - M.length % 128) % 128 = (127 - bl.toNat) + 112 by omega,
      ← List.replicate_append_replicate]
    have e : M ++ [0x80#8] ++ (List.replicate (127 - bl.toNat) 0#8 ++ List.replicate 112 0#8) ++
        Sha512.bytesBE (BitVec.ofNat 128 (8 * M.length)) =
        (M ++ ([0x80#8] ++ List.replicate (127 - bl.toNat) 0#8)) ++
          (List.replicate 112 0#8 ++ Sha512.bytesBE (BitVec.ofNat 128 (8 * M.length))) := by
      simp only [List.append_assoc]
    rw [e, Sha512_update.compressBlocks_block (by simp; omega) (by simp [Sha512.bytesBE]),
      Sha512_update.compressBlocks_fill (by simp; omega)]
    simp only [List.append_assoc, show min 112 128 = 112 from rfl]
  · rename_i hc
    rw [hst1, hP, hT1, hL]
    have ht : (M.drop (M.length / 128 * 128) ++ [0x80#8] ++ List.replicate (127 - bl.toNat) 0#8).take 112 =
        M.drop (M.length / 128 * 128) ++ [0x80#8] ++ List.replicate (111 - bl.toNat) 0#8 := by
      rw [List.take_append, List.take_of_length_le (by simp; omega), List.take_replicate]
      simp only [List.length_append, hPl, List.length_singleton]
      congr 2
      omega
    rw [ht, Sha512.pad, show (239 - M.length % 128) % 128 = 111 - bl.toNat by omega]
    have e : M ++ [0x80#8] ++ List.replicate (111 - bl.toNat) 0#8 ++
        Sha512.bytesBE (BitVec.ofNat 128 (8 * M.length)) =
        M ++ ([0x80#8] ++ List.replicate (111 - bl.toNat) 0#8 ++
          Sha512.bytesBE (BitVec.ofNat 128 (8 * M.length))) := by
      simp only [List.append_assoc]
    rw [e, Sha512_update.compressBlocks_fill (by simp [Sha512.bytesBE]; omega)]
    simp only [List.append_assoc]


theorem flatMap_vec8 (H : Vector (BitVec 64) 8) :
    Sha512.bytesBE H[0]! ++ Sha512.bytesBE H[1]! ++ Sha512.bytesBE H[2]! ++ Sha512.bytesBE H[3]! ++
        Sha512.bytesBE H[4]! ++ Sha512.bytesBE H[5]! ++ Sha512.bytesBE H[6]! ++ Sha512.bytesBE H[7]! =
      H.toList.flatMap Sha512.bytesBE := by
  rcases H with ⟨⟨l⟩, hl⟩
  simp only [List.size_toArray] at hl
  match l, hl with
  | [a, b, c, e, f, g, h, i], _ => simp

/-- `Sha512.final` on an object that has absorbed `M`: the 64 bytes at `out` are SHA-512 of `M`. -/
public theorem digest {s : GlobalState} {d out : Pointer} {M : List (BitVec 8)}
    (hA : Sha512Obj.Absorbed s.mem d M) (hf : Fits s.mem d 1792) (hdo : d.offset.toNat + 224 < 2 ^ 64)
    (ho : Fits s.mem out 512) (hoo : out.offset.toNat + 64 < 2 ^ 64) :
    bytesLE ((post s d out).mem.readAt out 512) = Sha512.digest M := by
  have hH := state_final hA hf hdo
  simp only at hH
  simp only [post, fromLen]
  generalize hs2 : (if 111 < (Sha512Obj.bufLen s.mem d).toNat then _ else _ : GlobalState) = s2 at hH
  have ho2 : Fits s2.mem out 512 := by
    rw [← hs2]; split
    · exact (Sha512_update.roundState_fits.2 (by simp only [padMem, Fits.storeAt_iff]; exact ho)).storeAt
    · simp only [padMem, Fits.storeAt_iff]; exact ho
  rw [bytesLE_outStores (Sha512_update.roundState_fits.2 (by
    simp only [lenState]; exact (fits_lenStores 15 1 _).2 ho2.storeAt)) hoo, hH, flatMap_vec8]
  rfl


/-! ### The rest of memory -/

public theorem post_fits {s : GlobalState} : Fits (post s d out).mem q w ↔ Fits s.mem q w := by
  simp only [post, fromLen, lenState]
  split <;>
    simp only [fits_outStores, Sha512_update.roundState_fits, fits_lenStores, Fits.storeAt_iff, padMem]

public theorem post_wf {s : GlobalState} (h : s.WF) : (post s d out).WF := by
  have hw : ({ s with mem := padMem s.mem d (Sha512Obj.bufLen s.mem d) } : GlobalState).WF := by
    simp only [padMem]; exact h.storeAt.storeAt.storeAt
  have hout : ∀ (t : GlobalState) (f : Nat → BitVec 64), t.WF →
      ({ t with mem := outStores out f 0 8 t.mem } : GlobalState).WF := by
    intro t f ht
    simp only [outStores]
    exact ht.storeAt.storeAt.storeAt.storeAt.storeAt.storeAt.storeAt.storeAt
  have hX : ∀ X : GlobalState, X.WF → (lenState X d).WF := fun X hX =>
    wf_lenStores 15 1 _ { X with mem := X.mem.storeAt (d.add 207#64) _ } hX.storeAt
  simp only [post, fromLen]
  apply hout
  apply Sha512_update.roundState_wf
  apply hX
  split
  · exact (Sha512_update.roundState_wf hw).storeAt
  · exact hw

theorem out_disjoint_q {out q : Pointer} {w : Nat} (hoo : out.offset.toNat + 64 < 2 ^ 64)
    (hsep : (Range.of out 512).Disjoint (Range.of q w)) {a : BitVec 64} {v : Nat}
    (ha : a.toNat * 8 + v ≤ 512) : (Range.of (out.add a) v).Disjoint (Range.of q w) := by
  simp only [Range.Disjoint, Range.of, Pointer.offsetInBits, Pointer.add, BitVec.toNat_add] at hsep ⊢
  rcases hsep with h | h | h
  · exact Or.inl h
  · right; left; rw [Nat.mod_eq_of_lt (by omega)]; omega
  · right; right; rw [Nat.mod_eq_of_lt (by omega)]; omega

theorem readAt_outStores_q {m : MemoryState} {out q : Pointer} {w : Nat} {f : Nat → BitVec 64}
    (hoo : out.offset.toNat + 64 < 2 ^ 64) (h : (Range.of out 512).Disjoint (Range.of q w)) :
    ∀ n j, j + n ≤ 8 → (outStores out f j n m).readAt q w = m.readAt q w := by
  intro n
  induction n generalizing m with
  | zero => intro _ _; rfl
  | succ n ih =>
    intro j hj
    rw [outStores, ih (j + 1) (by omega), MemoryState.readAt_storeAt_disjoint (out_disjoint_q hoo h (by simp; omega))]

theorem readAt_lenStores_q {d q : Pointer} {w : Nat} (hdo : d.offset.toNat + 224 < 2 ^ 64)
    (h : (Range.of d 1792).Disjoint (Range.of q w)) :
    ∀ n i (x : BitVec 128) (m : MemoryState), i + n ≤ 16 → (lenStores d x i n m).readAt q w = m.readAt q w := by
  intro n
  induction n with
  | zero => intro _ _ _ _; rfl
  | succ n ih =>
    intro i x m hi
    have hc : (80#64 + BitVec.ofNat 64 (127 - i)).toNat = 80 + (127 - i) := by simp; omega
    rw [lenStores, ih (i + 1) _ _ (by omega),
      MemoryState.readAt_storeAt_disjoint (Sha512_update.obj_disjoint_q hdo h (by rw [hc]; omega))]

/-- `post` keeps every read apart from the object and `out`. -/
public theorem post_readAt {s : GlobalState} {d out q : Pointer} {w : Nat} (hdo : d.offset.toNat + 224 < 2 ^ 64)
    (hoo : out.offset.toNat + 64 < 2 ^ 64) (hbl : (Sha512Obj.bufLen s.mem d).toNat < 128)
    (h1 : (Range.of d 1792).Disjoint (Range.of q w)) (h2 : (Range.of out 512).Disjoint (Range.of q w)) :
    (post s d out).mem.readAt q w = s.mem.readAt q w := by
  have hdo' : d.offset.toNat + 80 < 2 ^ 64 := by omega
  have h16 := Sha512_update.obj_disjoint_q (a := 16#64) (v := 512) hdo h1 (by simp)
  have hpad : (padMem s.mem d (Sha512Obj.bufLen s.mem d)).readAt q w = s.mem.readAt q w := by
    have hX : (80#64 + BitVec.setWidth 64 (Sha512Obj.bufLen s.mem d)).toNat =
        80 + (Sha512Obj.bufLen s.mem d).toNat := by simp; omega
    have hk : (BitVec.ofNat 64 (128 - (Sha512Obj.bufLen s.mem d).toNat)).toNat =
        128 - (Sha512Obj.bufLen s.mem d).toNat := by simp; omega
    simp only [padMem]
    rw [MemoryState.readAt_storeAt_disjoint (Sha512_update.obj_disjoint_q hdo h1 (by simp)),
      MemoryState.readAt_storeAt_disjoint (Sha512_update.obj_disjoint_q hdo h1 (by rw [hX]; omega)),
      MemoryState.readAt_storeAt_disjoint (Sha512_update.obj_disjoint_q hdo h1 (by rw [hX, hk]; omega))]
  simp only [post, fromLen, lenState]
  rw [readAt_outStores_q hoo h2 8 0 (by omega), Sha512_update.roundState_readAt hdo' h16,
    readAt_lenStores_q hdo h1 15 1 _ _ (by omega),
    MemoryState.readAt_storeAt_disjoint (Sha512_update.obj_disjoint_q hdo h1 (by simp))]
  split
  · rw [MemoryState.readAt_storeAt_disjoint (Sha512_update.obj_disjoint_q hdo h1 (by simp)),
      Sha512_update.roundState_readAt hdo' h16]
    exact hpad
  · exact hpad

end Sha512_final

end MLIR.Zig
