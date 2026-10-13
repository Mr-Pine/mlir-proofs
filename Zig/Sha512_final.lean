module

public import MLIR.Run.Tactic
public import Ed25519.Sha512
public import Zig.Common.Sha512
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

/-! ## Specification -/

@[expose] public section

/-- The length's bytes `x`, `x >>> 8`, … stored at `buf[127 - i]`, `buf[126 - i]`, …. -/
def lenStores (d : Pointer) : (x : BitVec 128) → (i n : Nat) → MemoryState → MemoryState
  | _, _, 0, m => m
  | x, i, n + 1, m =>
    lenStores d (x >>> 8) (i + 1) n
      (m.storeAt (d.add (80#64 + BitVec.ofNat 64 (127 - i))) (BitVec.setWidth 8 x))

/-- `llvm.intr.bswap` on 64 bits, as the operation unfolds. -/
abbrev bswap64 (x : BitVec 64) : BitVec 64 :=
  (List.range 8).foldl (fun acc i => acc ||| (x >>> (8 * i) &&& 255#64) <<< (64 - 8 * (i + 1))) 0#64

/-- `f j, …, f (j + n - 1)` byte-swapped into `out` at `8 j, …`. -/
def outStores (out : Pointer) (f : Nat → BitVec 64) : (j n : Nat) → MemoryState → MemoryState
  | _, 0, m => m
  | j, n + 1, m =>
    outStores out f (j + 1) n (m.storeAt (out.add (BitVec.ofNat 64 (8 * j))) (bswap64 (f j)))

/-- `bb1` and the length loop: `buf[112 … 127]` the bit length `8 T` big-endian. -/
def lenState (s : GlobalState) (d : Pointer) : GlobalState :=
  let T := Sha512Obj.totalLen s.mem d
  { s with
    mem := lenStores d (T >>> 5) 1 15 (s.mem.storeAt (d.add 207#64) (BitVec.setWidth 8 T <<< 3)) }

/-- From `bb1`: the length, the last round, the digest's words into `out`. -/
def fromLen (s : GlobalState) (d out : Pointer) : GlobalState :=
  let s5 := Sha512_update.roundState (lenState s d) d (d.add 80#64)
  { s5 with mem := outStores out (fun k => (Sha512Obj.state s5.mem d)[k]!) 0 8 s5.mem }

/-- `bb0`: `buf[bl …]` zeroed, `buf[bl] = 0x80`, `buf_len` one more. -/
def padMem (m : MemoryState) (d : Pointer) (bl : BitVec 8) : MemoryState :=
  ((m.storeAt (d.add (80#64 + BitVec.setWidth 64 bl))
            (BitVec.replicate (BitVec.ofNat 64 (128 - bl.toNat)).toNat 0#8)).storeAt
        (d.add (80#64 + BitVec.setWidth 64 bl)) 128#8).storeAt
    (d.add 208#64) (bl + 1#8)

/-- The state `Sha512.final` leaves: the padding into the buffer (a round first if the length no
longer fits), the bit length, the last round, the digest into `out`. -/
def post (s : GlobalState) (d out : Pointer) : GlobalState :=
  let bl := Sha512Obj.bufLen s.mem d
  let s1 : GlobalState := { s with mem := padMem s.mem d bl }
  let s2 : GlobalState :=
    if 111 < bl.toNat then
      let r := Sha512_update.roundState s1 d (d.add 80#64)
      { r with mem := r.mem.storeAt (d.add 80#64) 0#1024 }
    else s1
  fromLen s2 d out

/-- `^bb1`'s env: its constants, `buf`. -/
abbrev env1 (d : Pointer) (E : ⟪Γ⟫) : ⟪Γ⟫ :=
  E[%3846 := .value 0#64, %3850 := .value 5#128, %3851 := .value 3#8, %3852 := .value 1#64, %3853 :=
    .value 16#64, %3854 := .value 127#64, %3855 := .value 8#128, %3856 := .value 8#64, %3857 :=
    .value 3#64, %3858 := .value (d.add 80#64)]

/-- `^bb2`'s env: `^bb1`'s and `128`, `0`. -/
abbrev env2 (d : Pointer) (E : ⟪Γ⟫) : ⟪Γ⟫ :=
  (env1 d E)[%3844 := .value 128#64, %3845 := .value 0#8]

/-- `^bb3`'s env at byte `i`, the length shifted to `x`. -/
abbrev env3 (d : Pointer) (i : Nat) (x : BitVec 128) (E : ⟪Γ⟫) : ⟪Γ⟫ :=
  E[%3846 := .value 0#64, %3852 := .value 1#64, %3853 := .value 16#64, %3854 := .value 127#64,
    %3855 := .value 8#128, %3856 := .value 8#64, %3857 := .value 3#64, %3858 :=
    .value (d.add 80#64), %3875 := .value (BitVec.ofNat 64 i), %3876 := .value x]

/-- `^bb5`'s env: `0`, `1`, `8`, `3`, `buf`. -/
abbrev env5 (d : Pointer) (E : ⟪Γ⟫) : ⟪Γ⟫ :=
  E[%3846 := .value 0#64, %3852 := .value 1#64, %3856 := .value 8#64, %3857 := .value 3#64, %3858 :=
    .value (d.add 80#64)]

/-- `^bb6`'s env at word `j`. -/
abbrev env6 (d : Pointer) (j : Nat) (E : ⟪Γ⟫) : ⟪Γ⟫ :=
  E[%3852 := .value 1#64, %3856 := .value 8#64, %3857 := .value 3#64, %3883 := .value (d.add 16#64),
    %3884 := .value (BitVec.ofNat 64 j)]

end

/-! ## Proof -/

theorem Room.setState {m : MemoryState} {d : Pointer} {v : Vector (BitVec 64) 8} (h : Room m p w) :
    Room (Sha512Obj.setState m d v) p w :=
  (Sha512_update.room_storeWords 8 0).2 h

attribute [local mlir_transport] Room.setState Sha512_update.Fits.setState

theorem room_lenStores {m : MemoryState} {d : Pointer} :
    ∀ n i (x : BitVec 128), Room (lenStores d x i n m) p w ↔ Room m p w := by
  intro n
  induction n generalizing m with
  | zero =>
    intro _ _; rfl
  | succ n ih =>
    intro i x; rw [lenStores, ih]; simp

theorem inBounds_lenStores {m : MemoryState} {d : Pointer} :
    ∀ n i (x : BitVec 128), InBounds (lenStores d x i n m) p w ↔ InBounds m p w := by
  intro n
  induction n generalizing m with
  | zero =>
    intro _ _; rfl
  | succ n ih =>
    intro i x; rw [lenStores, ih]; simp

theorem Fits.lenStores {m : MemoryState} {d : Pointer} (h : Fits m p w) :
    ∀ n i (x : BitVec 128), Fits (Sha512_final.lenStores d x i n m) p w := by
  intro n
  induction n generalizing m with
  | zero =>
    intro _ _; exact h
  | succ n ih =>
    intro i x; exact ih h.storeAt (i + 1) (x >>> 8)

/-- `bb3`/`bb4` from byte `i`, `m` left: the length's bytes into the buffer's end. -/
theorem len_loop (d out : Pointer) (R : PoisonOr (Vals [] × GlobalState))
    (hdo : d.offset.toNat + 224 < 2 ^ 64) :
    ∀ m i (x : BitVec 128) (S : GlobalState) (E : ⟪Γ⟫),
      i + m = 16 →
        1 ≤ i →
        E.args = (Sha512_final.args (.value d) (.value out)).get →
        Room S.mem d 1792 →
        (∀ E' : ⟪Γ⟫,
          E'.args = (Sha512_final.args (.value d) (.value out)).get →
            Sha512_final.runFrom (env5 d E') 5 { S with mem := lenStores d x i m S.mem } = R) →
        Sha512_final.runFrom (env3 d i x E) 3 S = R := by
  intro m
  induction m with
  | zero =>
    intro i x S E hi _ hArgs hr hK
    obtain rfl : i = 16 := by omega
    block_init
    step_pure
    finish_block
    step_loop using hK
  | succ m ih =>
    intro i x S E hi hi1 hArgs hr hK
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
    have hfb : Room S.mem (d.add (80#64 + BitVec.ofNat 64 (127 - i))) 8 :=
      Room.add_of_le
        (by
          simp [BitVec.uaddOverflow]; omega)
        (by
          simp; omega)
        hr
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
      step_loop using ih (i + 1) (x >>> 8)
      have hA : E₀.args = (Sha512_final.args (.value d) (.value out)).get := by
        rw [hE] at hArgs; simpa only [Env.write_args] using hArgs
      rw [hE, hS]
      exact hK E₀ hA

theorem room_outStores {m : MemoryState} {out : Pointer} {f : Nat → BitVec 64} :
    ∀ n j, Room (Sha512_final.outStores out f j n m) p w ↔ Room m p w := by
  intro n
  induction n generalizing m with
  | zero =>
    intro _; rfl
  | succ n ih =>
    intro j; rw [outStores, ih]; simp

theorem Fits.outStores {m : MemoryState} {out : Pointer} {f : Nat → BitVec 64} (h : Fits m p w) :
    ∀ n j, Fits (Sha512_final.outStores out f j n m) p w := by
  intro n
  induction n generalizing m with
  | zero =>
    intro _; exact h
  | succ n ih =>
    intro j; exact ih h.storeAt (j + 1)

/-- `bb6`/`bb7` from word `j`, `m` left: the state words byte-swapped into `out`, then the
return. -/
theorem out_loop (d out : Pointer) (f : Nat → BitVec 64) (R : PoisonOr (Vals [] × GlobalState))
    (hdo : d.offset.toNat + 224 < 2 ^ 64) (hoo : out.offset.toNat + 64 < 2 ^ 64)
    (hsep : (Range.of d 1792).Disjoint (Range.of out 512)) :
    ∀ m j (S : GlobalState) (E : ⟪Γ⟫),
      j + m = 8 →
        E.args = (Sha512_final.args (.value d) (.value out)).get →
        Fits S.mem d 640 →
        Room S.mem out 512 →
        (∀ k, j ≤ k → k < 8 → S.mem.readAt (d.add (16#64 + BitVec.ofNat 64 (8 * k))) 64 = f k) →
        .value (.nil, { S with mem := outStores out f j m S.mem }) = R →
        Sha512_final.runFrom (env6 d j E) 6 S = R := by
  intro m
  induction m with
  | zero =>
    intro j S E hj hArgs hf ho hw hfin
    obtain rfl : j = 8 := by omega
    block_init
    step_pure
    finish_block
    block_init
    finish_block
    exact hfin
  | succ m ih =>
    intro j S E hj hArgs hf ho hw hfin
    have h8 : j * 8 = 8 * j := by omega
    have hm : j % 18446744073709551616 = j := by omega
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
    have hfw : Fits S.mem (d.add (16#64 + BitVec.ofNat 64 (8 * j))) 64 :=
      Fits.add_of_le
        (by
          simp [BitVec.uaddOverflow]; omega)
        (by
          simp; omega)
        hf
    have hrw := hw j (Nat.le_refl _) (by omega)
    have hfo : Room S.mem (out.add (BitVec.ofNat 64 (8 * j))) 64 :=
      Room.add_of_le
        (by
          simp [BitVec.uaddOverflow]; omega)
        (by
          simp; omega)
        ho
    have hw' (k : Nat) (hk : j + 1 ≤ k) (hk' : k < 8) :
      (S.mem.storeAt (out.add (BitVec.ofNat 64 (8 * j))) (bswap64 (f j))).readAt
          (d.add (16#64 + BitVec.ofNat 64 (8 * k))) 64 =
        f k := by
      rw [MemoryState.readAt_storeAt_disjoint, hw k (by omega) hk']
      simp only [Range.Disjoint, Range.of, Pointer.offsetInBits, Pointer.add, BitVec.toNat_add,
        BitVec.toNat_ofNat] at hsep ⊢
      rcases hsep with h | h | h
      · exact Or.inl (Ne.symm h)
      · right; right; omega
      · right; left; omega
    generalize hM : S.mem = M at hw' hfin
    clear hw
    block_init
    step_pure
    finish_block
    · exfalso
      have := congrArg BitVec.toNat hbr
      simp at this
      omega
    · block_init
      step_pure [hm, h8, hlt]
      step_load consuming hrw hfw
      step_pure [hsh, hshr, hsshr]
      step_pure [hsh, hshr, hsshr, hm8, hlt]
      step_pure
      step_store consuming hfo
      step_pure [o1, o2, ← BitVec.ofNat_add]
      finish_block
      step_loop using ih (j + 1)
      · exact hw'
      · exact hfin

theorem wf_lenStores {d : Pointer} {a : AllocState} :
    ∀ n i (x : BitVec 128) (m : MemoryState),
      ({ alloc := a, mem := m } : GlobalState).WF →
        ({ alloc := a, mem := lenStores d x i n m } : GlobalState).WF := by
  intro n
  induction n with
  | zero =>
    intro _ _ _ h; exact h
  | succ n ih =>
    intro i x m h; exact ih (i + 1) (x >>> 8) _ h.storeAt_mk

/-- `bb1` on: the length into the buffer, its round, the state words byte-swapped into `out`. -/
theorem fromBB1 (d out : Pointer) (S : GlobalState) (E : ⟪Γ⟫) (R : PoisonOr (Vals [] × GlobalState))
    (hArgs : E.args = (Sha512_final.args (.value d) (.value out)).get) (hwf : S.WF)
    (hdr : Room S.mem d 1792) (hdf : Fits S.mem d 640) (hbuf : Fits S.mem (d.add 80#64) 1024)
    (hdo : d.offset.toNat + 224 < 2 ^ 64) (ho : Room S.mem out 512)
    (hoo : out.offset.toNat + 64 < 2 ^ 64) (hsep : (Range.of d 1792).Disjoint (Range.of out 512))
    (hfin : .value (.nil, fromLen S d out) = R) : Sha512_final.runFrom (env1 d E) 1 S = R := by
  have hfT : Fits S.mem d 128 := hdf.mono (by omega)
  have hf207 : Room S.mem (d.add 207#64) 8 :=
    Room.add_of_le
      (by
        simp [BitVec.uaddOverflow]; omega)
      (by simp) hdr
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
  step_loop using len_loop d out R hdo 15 1 (T >>> 5)
  have hwf5 : S.WF := by
    rw [hS]; exact wf_lenStores 15 1 (T >>> 5) _ hwf
  have hdf5 : Fits S.mem d 640 := by
    rw [hS]; exact Fits.lenStores hdf 15 1 _
  have hbuf5 : Fits S.mem (d.add 80#64) 1024 := by
    rw [hS]; exact Fits.lenStores hbuf 15 1 _
  have hr5 : Room S.mem d 1792 := by
    rw [hS]; exact (room_lenStores 15 1 _).2 hdr
  have ho5 : Room S.mem out 512 := by
    rw [hS]; exact (room_lenStores 15 1 _).2 ho
  clear hfits_d_207 hwf hdr hdf hbuf ho hfT
  have hdo80 : (d.add 80#64).offset.toNat + 128 < 2 ^ 64 := by
    simp [Pointer.add, BitVec.toNat_add]; omega
  have hdo' : d.offset.toNat + 80 < 2 ^ 64 := by omega
  block_init
  step_call using Sha512_round.call_eq consuming hwf5 hbuf5
  step_pure
  finish_block
  step_loop using out_loop d out (fun k => (Sha512Obj.state S.mem d)[k]!) R hdo hoo hsep 8 0
  · intro k hk
    simp [Sha512Obj.state, hk]
  · exact hfin

/-- `bb2`: the padded block's round, the buffer zeroed. -/
theorem bb2_run (d out : Pointer) (A : AllocState) (M : MemoryState) (E : ⟪Γ⟫)
    (R : PoisonOr (Vals [] × GlobalState))
    (hArgs : E.args = (Sha512_final.args (.value d) (.value out)).get)
    (hwf : ({ alloc := A, mem := M } : GlobalState).WF) (hdr : Room M d 1792) (hdf : Fits M d 640)
    (hbuf : Fits M (d.add 80#64) 1024) (hdo : d.offset.toNat + 224 < 2 ^ 64)
    (hK :
      ∀ E' : ⟪Γ⟫,
        E'.args = (Sha512_final.args (.value d) (.value out)).get →
          Sha512_final.runFrom (env1 d E') 1
              { Sha512_update.roundState ⟨A, M⟩ d (d.add 80#64) with
                mem :=
                  (Sha512_update.roundState ⟨A, M⟩ d (d.add 80#64)).mem.storeAt (d.add 80#64)
                    0#1024 } =
            R) :
    Sha512_final.runFrom (env2 d E) 2 ⟨A, M⟩ = R := by
  have hdo80 : (d.add 80#64).offset.toNat + 128 < 2 ^ 64 := by
    simp [Pointer.add, BitVec.toNat_add]; omega
  have hdo' : d.offset.toNat + 80 < 2 ^ 64 := by omega
  have hmz : Room M (d.add 80#64) 1024 :=
    Room.add_of_le
      (by
        simp [BitVec.uaddOverflow]; omega)
      (by simp) hdr
  block_init
  step_call using Sha512_round.call_eq consuming hwf hdf hbuf hdr
  step_memset consuming hmz
  finish_block
  step_loop using hK

theorem SameBlocks.lenStores {m m' : MemoryState} (h : Sha512_update.SameBlocks m m')
    {d : Pointer} :
    ∀ n i (x : BitVec 128), Sha512_update.SameBlocks (Sha512_final.lenStores d x i n m) m' := by
  intro n
  induction n generalizing m with
  | zero =>
    intro _ _; exact h
  | succ n ih =>
    intro i x; exact ih h.storeAt (i + 1) (x >>> 8)

theorem SameBlocks.outStores {m m' : MemoryState} (h : Sha512_update.SameBlocks m m')
    {out : Pointer} {f : Nat → BitVec 64} :
    ∀ n j, Sha512_update.SameBlocks (Sha512_final.outStores out f j n m) m' := by
  intro n
  induction n generalizing m with
  | zero =>
    intro _; exact h
  | succ n ih =>
    intro j; exact ih h.storeAt (j + 1)

theorem SameBlocks.fromLen {s : GlobalState} {m' : MemoryState}
    (h : Sha512_update.SameBlocks s.mem m') :
    Sha512_update.SameBlocks (Sha512_final.fromLen s d out).mem m' :=
  SameBlocks.outStores (Sha512_update.SameBlocks.roundState (SameBlocks.lenStores h.storeAt 15 1 _))
    8 0

theorem fin_eq {s X : GlobalState} (hwf : s.WF)
    (h : Sha512_update.SameBlocks (fromLen X d out).mem s.mem) :
    PoisonOr.value
        ((Vals.nil, fromLen X d out).fst,
          ({  alloc := (Vals.nil, fromLen X d out).snd.alloc
              mem := (Vals.nil, fromLen X d out).snd.mem.eraseFrom s.alloc.nextFreeBlock } :
            GlobalState)) =
      PoisonOr.value (Vals.nil, fromLen X d out) := by
  simp only [h.eraseFrom hwf]

/-- `Sha512.final` on the object at `d` leaves `post`, the digest at `out`; `buf_len` below 128
with that many bytes of `buf` known, `out` room for 64 bytes apart from the object. -/
public theorem call_eq (d out : Pointer) (s : GlobalState) (hwf : s.WF) (hd : Sha512Obj.Fit s.mem d)
    (hbuf : Fits s.mem (d.add 80#64) (8 * (Sha512Obj.bufLen s.mem d).toNat))
    (hbl : (Sha512Obj.bufLen s.mem d).toNat < 128) (ho : Room s.mem out 512)
    (hoo : out.offset.toNat + 64 < 2 ^ 64) (hsep : (Range.of d 1792).Disjoint (Range.of out 512)) :
    Sha512_final.call (Sha512_final.args (.value d) (.value out)) s =
      .value (.nil, post s d out) := by
  obtain ⟨hdo, hdr, hdf, hf208⟩ := hd
  generalize hbl0 : Sha512Obj.bufLen s.mem d = bl at hbl hbuf
  have hblr : s.mem.readAt (d.add 208#64) 8 = bl := hbl0
  func_init
  have hb0 : Sha512Obj.bufLen S₀.mem d = bl := hS ▸ hbl0
  clear hbl0
  have hblm : bl.toNat % 18446744073709551616 = bl.toNat := Nat.mod_eq_of_lt (by omega)
  have hblt : bl.toNat < 18446744073709551616 := by omega
  have hs1 : (128#64).ssubOverflow (BitVec.setWidth 64 bl) = false := by bv_decide
  have hs2 : (128#64).usubOverflow (BitVec.setWidth 64 bl) = false := by
    simp [BitVec.usubOverflow]; omega
  have hk : 128#64 - BitVec.setWidth 64 bl = BitVec.ofNat 64 (128 - bl.toNat) := by
    apply BitVec.eq_of_toNat_eq; simp; omega
  have hkn : (BitVec.ofNat 64 (128 - bl.toNat)).toNat = 128 - bl.toNat := by
    simp; omega
  have hms :
    Room S.mem (d.add (80#64 + BitVec.setWidth 64 bl))
      (8 * (BitVec.ofNat 64 (128 - bl.toNat)).toNat) := by
    rw [hkn];
    exact
      Room.add_of_le
        (by
          simp [BitVec.uaddOverflow]; omega)
        (by
          simp; omega)
        hdr
  have hdisB :
    (Range.of (d.add (80#64 + BitVec.setWidth 64 bl))
          (8 * (BitVec.ofNat 64 (128 - bl.toNat)).toNat)).Disjoint
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
  have hb1024 : Fits S.mem (d.add 80#64) 1024 := by
    have h2 : Fits S.mem ((d.add 80#64).add (BitVec.setWidth 64 bl)) (8 * (128 - bl.toNat)) := by
      rw [Pointer.add_add]; rw [hkn] at hfits_d_0; exact hfits_d_0
    exact
      Fits.append (off := BitVec.setWidth 64 bl)
        (by
          simp [Pointer.add, BitVec.uaddOverflow]; omega)
        (by
          simp; omega)
        (by omega) hbuf h2
  clear hfits_d_0 hread_d_0 hbuf hdisB
  have hf8 : Room S.mem (d.add (80#64 + BitVec.setWidth 64 bl)) 8 :=
    Room.add_of_le
      (by
        simp [BitVec.uaddOverflow]; omega)
      (by
        simp; omega)
      hdr
  have hov : bl.uaddOverflow 1#8 = false := by
    simp [BitVec.uaddOverflow]; omega
  have hdis8 :
    (Range.of (d.add (80#64 + BitVec.setWidth 64 bl)) 8).Disjoint (Range.of (d.add 208#64) 8) := by
    simp only [Range.Disjoint, Range.of, Pointer.offsetInBits, Pointer.add, BitVec.toNat_add,
      BitVec.toNat_setWidth, BitVec.toNat_ofNat]
    right; left; omega
  step_load
  step_pure
  step_pure [hblm, hblt]
  step_store consuming hf8
  step_load
  step_pure [hov]
  step_store
  step_pure
  finish_block
  · have hc : 111 < bl.toNat := by
      simp [BitVec.ult] at hbr; omega
    clear hread_d_208 hfits_d_0
    have hrun :
      Sha512_final.runFrom E 2 S =
        .value
          (.nil,
            fromLen
              { Sha512_update.roundState S d (d.add 80#64) with
                mem :=
                  (Sha512_update.roundState S d (d.add 80#64)).mem.storeAt (d.add 80#64) 0#1024 }
              d out) := by
      rw [hS] at hwf hdr hdf hb1024 ho ⊢
      step_loop using
        bb2_run d out _ _ (hwf := hwf) (hdr := hdr) (hdf := hdf) (hbuf := hb1024) (hdo := hdo)
      have hwf2 : S.WF := by
        rw [hS]; exact (Sha512_update.roundState_wf hwf).storeAt
      have hdr2 : Room S.mem d 1792 := by
        rw [hS]; exact (Sha512_update.room_roundState.2 hdr).storeAt
      have hdf2 : Fits S.mem d 640 := by
        rw [hS]; exact (Sha512_update.Fits.roundState hdf).storeAt
      have hb2 : Fits S.mem (d.add 80#64) 1024 := by
        rw [hS]
        exact
          Fits.storeAt_self
            (Sha512_update.room_roundState.2
              (Room.add_of_le
                (by
                  simp [BitVec.uaddOverflow]; omega)
                (by simp) hdr))
      have ho2 : Room S.mem out 512 := by
        rw [hS]; exact (Sha512_update.room_roundState.2 ho).storeAt
      clear hwf hdr hdf hb1024 ho
      step_loop using fromBB1 d out S (hfin := rfl)
    rw [hrun, PoisonOr.value_bind]
    subst hS
    rw [fin_eq hwf₀
        (SameBlocks.fromLen
          (Sha512_update.SameBlocks.storeAt
            (Sha512_update.SameBlocks.roundState fun _ =>
              (MemoryState.mem_storeAt.trans
                (MemoryState.mem_storeAt.trans MemoryState.mem_storeAt)))))]
    simp only [post, hb0]
    rw [ite_eq_left_of_eq_true _ _ (eq_true hc)]
    rfl
  · have hc : ¬111 < bl.toNat := by
      simp [BitVec.ult] at hbr; omega
    clear hread_d_208 hfits_d_0
    have hrun : Sha512_final.runFrom E 1 S = .value (.nil, fromLen S d out) := by
      step_loop using fromBB1 d out S (hbuf := hb1024) (hfin := rfl)
    rw [hrun, PoisonOr.value_bind]
    subst hS
    rw [fin_eq hwf₀
        (SameBlocks.fromLen fun _ =>
          (MemoryState.mem_storeAt.trans (MemoryState.mem_storeAt.trans MemoryState.mem_storeAt)))]
    simp only [post, hb0]
    rw [ite_eq_right_of_eq_false _ _ (eq_false hc)]
    rfl

/-! ## The digest -/

/-- A byte read at `d + a` through a store at `d + c`: the stored byte, else the old one. -/
theorem readAt_byte_storeAt {m : MemoryState} {d : Pointer} {c a : BitVec 64} {w : Nat}
    {x : BitVec w} (hf : Room m d 1792) (hdo : d.offset.toNat + 224 < 2 ^ 64)
    (hc : c.toNat * 8 + w ≤ 1792) (ha : a.toNat < 224) (hw : w % 8 = 0) :
    (m.storeAt (d.add c) x).readAt (d.add a) 8 =
      if c.toNat ≤ a.toNat ∧ a.toNat * 8 < c.toNat * 8 + w then
        x.extractLsb' (8 * (a.toNat - c.toNat)) 8
      else m.readAt (d.add a) 8 := by
  have hfc : InBounds m (d.add c) w :=
    (Room.add_of_le
        (by
          simp [BitVec.uaddOverflow]; omega)
        (by omega) hf).inBounds
  have hoff (b : BitVec 64) (hb : b.toNat ≤ 224) :
    (d.add b).offsetInBits = d.offsetInBits + b.toNat * 8 := by
    rw [Pointer.offsetInBits_add
        (by
          simp [BitVec.uaddOverflow]; omega)]
  split
  · rw [MemoryState.readAt_storeAt_subrange (q := d.add a) (w' := 8) hfc rfl
        (by
          rw [hoff c (by omega), hoff a (by omega)]; omega)
        (by
          rw [hoff c (by omega), hoff a (by omega)]; omega)]
    congr 1
    rw [hoff c (by omega), hoff a (by omega)]
    omega
  · rw [MemoryState.readAt_storeAt_disjoint]
    simp only [Range.Disjoint, Range.of, hoff c (by omega), hoff a (by omega), Pointer.add_id]
    omega

/-- `buf`'s bytes, by their reads. -/
theorem bytesLE_buf {m : MemoryState} {d : Pointer} (hf : Room m d 1792)
    (hdo : d.offset.toNat + 224 < 2 ^ 64) {L : List (BitVec 8)} (hL : L.length = 128)
    (h : ∀ k (hk : k < 128), m.readAt (d.add (BitVec.ofNat 64 (80 + k))) 8 = L[k]) :
    bytesLE (Sha512Obj.buf m d) = L := by
  apply List.ext_getElem
  · simp [hL]
  · intro k h1 h2
    simp only [length_bytesLE] at h1
    rw [getElem_bytesLE, ← h k (by omega), Sha512Obj.buf,
      show BitVec.ofNat 64 (80 + k) = 80#64 + BitVec.ofNat 64 k by
        apply BitVec.eq_of_toNat_eq; simp,
      ← Pointer.add_add,
      MemoryState.readAt_add_of_readAt (v := 1024) (w := 8)
        (Room.add_of_le (w := 1024)
            (by
              simp [BitVec.uaddOverflow]; omega)
            (by simp) hf).inBounds
        (by
          simp [BitVec.uaddOverflow, Pointer.add, BitVec.toNat_add]; omega)
        (by
          simp; omega)
        rfl]
    congr 1
    simp
    omega

/-- Byte `k` of `buf`, read by itself. -/
theorem readAt_byte_buf {m : MemoryState} {d : Pointer} (hf : Room m d 1792)
    (hdo : d.offset.toNat + 224 < 2 ^ 64) {k : Nat} (hk : k < 128) :
    m.readAt (d.add (BitVec.ofNat 64 (80 + k))) 8 =
      (bytesLE (Sha512Obj.buf m d))[k]'(by
          simp; omega) := by
  rw [getElem_bytesLE, Sha512Obj.buf,
    show BitVec.ofNat 64 (80 + k) = 80#64 + BitVec.ofNat 64 k by
      apply BitVec.eq_of_toNat_eq; simp,
    ← Pointer.add_add,
    MemoryState.readAt_add_of_readAt (v := 1024) (w := 8)
      (Room.add_of_le (w := 1024)
          (by
            simp [BitVec.uaddOverflow]; omega)
          (by simp) hf).inBounds
      (by
        simp [BitVec.uaddOverflow, Pointer.add, BitVec.toNat_add]; omega)
      (by
        simp; omega)
      rfl]
  congr 1
  simp
  omega

/-- `bb0`'s buffer: the buffered bytes `P`, `0x80`, zeros. -/
theorem buf_padMem {m : MemoryState} {d : Pointer} {bl : BitVec 8} {P : List (BitVec 8)}
    (hf : Room m d 1792) (hdo : d.offset.toNat + 224 < 2 ^ 64) (hbl : bl.toNat < 128)
    (hP : (bytesLE (Sha512Obj.buf m d)).take bl.toNat = P) :
    bytesLE (Sha512Obj.buf (padMem m d bl) d) =
      P ++ [0x80#8] ++ List.replicate (127 - bl.toNat) 0#8 := by
  have hPl : P.length = bl.toNat := by
    rw [← hP]; simp; omega
  have hX : (80#64 + BitVec.setWidth 64 bl).toNat = 80 + bl.toNat := by
    simp; omega
  have hk' : (BitVec.ofNat 64 (128 - bl.toNat)).toNat = 128 - bl.toNat := by
    simp; omega
  have hf1 :
    Room
      (m.storeAt (d.add (80#64 + BitVec.setWidth 64 bl))
        (BitVec.replicate (BitVec.ofNat 64 (128 - bl.toNat)).toNat 0#8))
      d 1792 :=
    hf.storeAt
  apply
    bytesLE_buf hf1.storeAt.storeAt hdo
      (by
        simp [hPl]; omega)
  intro k hk
  have ha : (BitVec.ofNat 64 (80 + k)).toNat = 80 + k := by
    simp; omega
  try simp only [padMem]
  rw [readAt_byte_storeAt hf1.storeAt hdo (by simp)
      (by
        rw [ha]; omega)
      (by decide)]
  rw [ite_eq_right_of_eq_false _ _
      (eq_false
        (by
          simp; omega))]
  rw [readAt_byte_storeAt hf1 hdo
      (by
        rw [hX]; omega)
      (by
        rw [ha]; omega)
      (by decide)]
  by_cases e : k = bl.toNat
  · rw [ite_eq_left_of_eq_true _ _
        (eq_true
          (by
            rw [hX, ha]; omega))]
    subst e
    simp [hPl]
  · rw [ite_eq_right_of_eq_false _ _
        (eq_false
          (by
            rw [hX, ha]; omega)),
      readAt_byte_storeAt hf hdo
        (by
          rw [hX, hk']; omega)
        (by
          rw [ha]; omega)
        (by omega)]
    by_cases lt : k < bl.toNat
    · rw [ite_eq_right_of_eq_false _ _
          (eq_false
            (by
              rw [hX, ha]; omega)),
        readAt_byte_buf hf hdo hk]
      rw [List.getElem_append_left
          (by
            simp [hPl]; omega),
        List.getElem_append_left
          (by
            simp [hPl]; omega)]
      simp only [← hP, List.getElem_take]
    · rw [ite_eq_left_of_eq_true _ _
          (eq_true
            (by
              rw [hX, ha, hk']; omega))]
      rw [List.getElem_append_right
          (by
            simp [hPl]; omega)]
      simp only [List.getElem_replicate]
      apply BitVec.eq_of_getLsbD_eq
      intro i hi
      simp [BitVec.getLsbD_extractLsb', BitVec.getLsbD_replicate]

/-- Byte `80 + k` after the length loop's stores from `i`, `n` of them. -/
theorem readAt_lenStores {d : Pointer} (hdo : d.offset.toNat + 224 < 2 ^ 64) {k : Nat}
    (hk : k < 128) :
    ∀ n i (x : BitVec 128) (m : MemoryState),
      Room m d 1792 →
        i + n ≤ 16 →
        1 ≤ i →
        (lenStores d x i n m).readAt (d.add (BitVec.ofNat 64 (80 + k))) 8 =
          if i ≤ 127 - k ∧ 127 - k < i + n ∧ 112 ≤ k then
            BitVec.setWidth 8 (x >>> (8 * (127 - k - i)))
          else m.readAt (d.add (BitVec.ofNat 64 (80 + k))) 8 := by
  have ha : (BitVec.ofNat 64 (80 + k)).toNat = 80 + k := by
    simp; omega
  intro n
  induction n with
  | zero =>
    intro i x m _ _ _; rw [ite_eq_right_of_eq_false _ _ (eq_false (by omega))]; rfl
  | succ n ih =>
    intro i x m hf h1 h2
    have hc : (BitVec.ofNat 64 (127 - i)).toNat = 127 - i := by
      simp; omega
    have hc' : (80#64 + BitVec.ofNat 64 (127 - i)).toNat = 80 + (127 - i) := by
      simp; omega
    rw [lenStores, ih (i + 1) (x >>> 8) _ hf.storeAt (by omega) (by omega),
      readAt_byte_storeAt hf hdo
        (by
          rw [hc']; omega)
        (by
          rw [ha]; omega)
        (by decide)]
    by_cases e : 127 - k = i ∧ 112 ≤ k
    · rw [ite_eq_right_of_eq_false _ _ (eq_false (by omega)),
        ite_eq_left_of_eq_true _ _
          (eq_true
            (by
              rw [hc', ha]; omega)),
        ite_eq_left_of_eq_true _ _ (eq_true (by omega))]
      rw [show 127 - k - i = 0 by omega]
      apply BitVec.eq_of_getLsbD_eq
      intro b hb
      simp [hc', ha, show 80 + k - (80 + (127 - i)) = 0 by omega, hb]
    · by_cases r : i + 1 ≤ 127 - k ∧ 127 - k < i + 1 + n ∧ 112 ≤ k
      · rw [ite_eq_left_of_eq_true _ _ (eq_true r),
          ite_eq_left_of_eq_true _ _
            (eq_true (show i ≤ 127 - k ∧ 127 - k < i + (n + 1) ∧ 112 ≤ k by omega))]
        rw [← BitVec.shiftRight_add, show 8 + 8 * (127 - k - (i + 1)) = 8 * (127 - k - i) by omega]
      · rw [ite_eq_right_of_eq_false _ _ (eq_false r),
          ite_eq_right_of_eq_false _ _
            (eq_false
              (by
                rw [hc', ha]; omega)),
          ite_eq_right_of_eq_false _ _
            (eq_false (show ¬(i ≤ 127 - k ∧ 127 - k < i + (n + 1) ∧ 112 ≤ k) by omega))]

/-- The length loop's buffer: the first 112 bytes kept, then `8 total_len` big-endian. -/
theorem buf_lenState {s : GlobalState} {d : Pointer} (hf : Room s.mem d 1792)
    (hdo : d.offset.toNat + 224 < 2 ^ 64) :
    bytesLE (Sha512Obj.buf (lenState s d).mem d) =
      (bytesLE (Sha512Obj.buf s.mem d)).take 112 ++
        Sha512.bytesBE (Sha512Obj.totalLen s.mem d <<< 3) := by
  generalize hT : Sha512Obj.totalLen s.mem d = T
  simp only [lenState, hT]
  have hf1 : Room (s.mem.storeAt (d.add 207#64) (BitVec.setWidth 8 T <<< 3)) d 1792 := hf.storeAt
  apply bytesLE_buf ((room_lenStores 15 1 _).2 hf1) hdo (by simp [Sha512.bytesBE])
  intro k hk
  have ha : (BitVec.ofNat 64 (80 + k)).toNat = 80 + k := by
    simp; omega
  rw [readAt_lenStores hdo hk 15 1 _ _ hf1 (by omega) (Nat.le_refl _)]
  by_cases h1 : 112 ≤ k ∧ k ≤ 126
  · rw [ite_eq_left_of_eq_true _ _ (eq_true (by omega)),
      List.getElem_append_right
        (by
          simp; omega)]
    simp only [Sha512.bytesBE, List.getElem_reverse, length_bytesLE, List.length_take]
    rw [getElem_bytesLE]
    apply BitVec.eq_of_getLsbD_eq
    intro b hb
    simp only [BitVec.getLsbD_setWidth, BitVec.getLsbD_ushiftRight, BitVec.getLsbD_extractLsb',
      BitVec.getLsbD_shiftLeft]
    simp only [hb, decide_true, Bool.true_and]
    rw [show 5 + (8 * (127 - k - 1) + b) = 8 * (15 - (k - 112)) + b - 3 by omega]
    simp [show 8 * (15 - (k - 112)) + b < 128 by omega,
      show ¬(8 * (15 - (k - 112)) + b < 3) by omega]
  · rw [ite_eq_right_of_eq_false _ _ (eq_false (by omega)),
      readAt_byte_storeAt hf hdo (by simp)
        (by
          rw [ha]; omega)
        (by decide)]
    by_cases h2 : k = 127
    · subst h2
      rw [ite_eq_left_of_eq_true _ _
          (eq_true
            (by
              rw [ha]; simp)),
        List.getElem_append_right (by simp)]
      simp only [Sha512.bytesBE, List.getElem_reverse, length_bytesLE, List.length_take,
        getElem_bytesLE]
      simp only [show (BitVec.ofNat 64 (80 + 127)).toNat - (207#64).toNat = 0 by decide,
        show 128 / 8 - 1 - (127 - min 112 (1024 / 8)) = 0 by decide]
      bv_decide
    · rw [ite_eq_right_of_eq_false _ _
          (eq_false
            (by
              rw [ha]; simp; omega)),
        readAt_byte_buf hf hdo hk,
        List.getElem_append_left
          (by
            simp; omega),
        List.getElem_take]

/-! ### The output -/

theorem bytesLE_bswap64 (x : BitVec 64) : bytesLE (bswap64 x) = Sha512.bytesBE x := by
  simp only [Sha512.bytesBE, bytesLE, bswap64, List.range, List.range.loop, List.foldl,
    List.ofFn_succ, List.ofFn_zero, List.reverse_cons, List.reverse_nil, List.nil_append,
    List.cons_append, List.cons.injEq, Fin.val_succ, Fin.val_zero, and_true]
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩ <;> bv_decide

/-- Eight 64-bit words spliced in order fill 512 bits. -/
theorem splice8 (r : BitVec 512) (x0 x1 x2 x3 x4 x5 x6 x7 : BitVec 64) :
    Memory.spliceBits
        (Memory.spliceBits
          (Memory.spliceBits
            (Memory.spliceBits
              (Memory.spliceBits
                (Memory.spliceBits (Memory.spliceBits (Memory.spliceBits r 0 x0) 64 x1) 128 x2) 192
                x3)
              256 x4)
            320 x5)
          384 x6)
        448 x7 =
      x7 ++ x6 ++ x5 ++ x4 ++ x3 ++ x2 ++ x1 ++ x0 := by
  simp only [Memory.spliceBits]
  bv_decide

theorem readAt_storeAt_out {m : MemoryState} {out : Pointer} (hfo : InBounds m out 512)
    (hoo : out.offset.toNat + 64 < 2 ^ 64) {j : Nat} (hj : j < 8) (x : BitVec 64) :
    (m.storeAt (out.add (BitVec.ofNat 64 (8 * j))) x).readAt out 512 =
      Memory.spliceBits (m.readAt out 512) (64 * j) x := by
  rw [MemoryState.readAt_add_storeAt hfo
      (by
        simp [BitVec.uaddOverflow]; omega)
      (by
        simp; omega)]
  congr 1
  simp
  omega

/-- The 64 bytes `outStores` writes: each word big-endian. -/
theorem bytesLE_outStores {m : MemoryState} {out : Pointer} (hfo : InBounds m out 512)
    (hoo : out.offset.toNat + 64 < 2 ^ 64) (f : Nat → BitVec 64) :
    bytesLE ((outStores out f 0 8 m).readAt out 512) =
      Sha512.bytesBE (f 0) ++ Sha512.bytesBE (f 1) ++ Sha512.bytesBE (f 2) ++
        Sha512.bytesBE (f 3) ++
        Sha512.bytesBE (f 4) ++
        Sha512.bytesBE (f 5) ++
        Sha512.bytesBE (f 6) ++
        Sha512.bytesBE (f 7) := by
  simp only [outStores]
  rw [readAt_storeAt_out (by simp [InBounds.storeAt_iff, hfo]) hoo (j := 7) (by omega),
    readAt_storeAt_out (by simp [InBounds.storeAt_iff, hfo]) hoo (j := 6) (by omega),
    readAt_storeAt_out (by simp [InBounds.storeAt_iff, hfo]) hoo (j := 5) (by omega),
    readAt_storeAt_out (by simp [InBounds.storeAt_iff, hfo]) hoo (j := 4) (by omega),
    readAt_storeAt_out (by simp [InBounds.storeAt_iff, hfo]) hoo (j := 3) (by omega),
    readAt_storeAt_out (by simp [InBounds.storeAt_iff, hfo]) hoo (j := 2) (by omega),
    readAt_storeAt_out (by simp [InBounds.storeAt_iff, hfo]) hoo (j := 1) (by omega),
    readAt_storeAt_out hfo hoo (j := 0) (by omega)]
  simp only [show 64 * 0 = 0 from rfl, show 64 * 1 = 64 from rfl, show 64 * 2 = 128 from rfl,
    show 64 * 3 = 192 from rfl, show 64 * 4 = 256 from rfl, show 64 * 5 = 320 from rfl,
    show 64 * 6 = 384 from rfl, show 64 * 7 = 448 from rfl, splice8]
  simp only [bytesLE_append _ _ (by decide : 64 % 8 = 0), bytesLE_bswap64, List.append_assoc]

/-! ### The state words and counts through the stores -/

theorem state_padMem {m : MemoryState} {d : Pointer} {bl : BitVec 8}
    (hdo : d.offset.toNat + 224 < 2 ^ 64) (hbl : bl.toNat < 128) :
    Sha512Obj.state (padMem m d bl) d = Sha512Obj.state m d := by
  have hX : (80#64 + BitVec.setWidth 64 bl).toNat = 80 + bl.toNat := by
    simp; omega
  have hk : (BitVec.ofNat 64 (128 - bl.toNat)).toNat = 128 - bl.toNat := by
    simp; omega
  simp only [padMem]
  rw [Sha512_update.state_storeAt hdo
      (Sha512_update.obj_disjoint hdo (by decide) (by decide) (by simp)),
    Sha512_update.state_storeAt hdo
      (Sha512_update.obj_disjoint hdo
        (by
          rw [hX]; omega)
        (by decide)
        (by
          rw [hX]; simp; omega)),
    Sha512_update.state_storeAt hdo
      (Sha512_update.obj_disjoint hdo
        (by
          rw [hX]; omega)
        (by decide)
        (by
          rw [hX, hk]; simp; omega))]

theorem totalLen_padMem {m : MemoryState} {d : Pointer} {bl : BitVec 8}
    (hdo : d.offset.toNat + 224 < 2 ^ 64) (hbl : bl.toNat < 128) :
    Sha512Obj.totalLen (padMem m d bl) d = Sha512Obj.totalLen m d := by
  have hX : (80#64 + BitVec.setWidth 64 bl).toNat = 80 + bl.toNat := by
    simp; omega
  have hk : (BitVec.ofNat 64 (128 - bl.toNat)).toNat = 128 - bl.toNat := by
    simp; omega
  have h0 (c : BitVec 64) (w : Nat) (hc : c.toNat ≤ 224) (h : 128 ≤ c.toNat * 8) :
    (Range.of (d.add c) w).Disjoint (Range.of d 128) := by
    simpa using
      Sha512_update.obj_disjoint (a := c) (c := 0#64) (v := w) (w := 128) hdo hc (by decide)
        (by
          simp; omega)
  simp only [padMem, Sha512Obj.totalLen]
  rw [MemoryState.readAt_storeAt_disjoint (h0 _ _ (by decide) (by decide)),
    MemoryState.readAt_storeAt_disjoint
      (h0 _ _
        (by
          rw [hX]; omega)
        (by
          rw [hX]; omega)),
    MemoryState.readAt_storeAt_disjoint
      (h0 _ _
        (by
          rw [hX]; omega)
        (by
          rw [hX]; omega))]

theorem state_lenStores {d : Pointer} (hdo : d.offset.toNat + 224 < 2 ^ 64) :
    ∀ n i (x : BitVec 128) (m : MemoryState),
      i + n ≤ 16 → Sha512Obj.state (lenStores d x i n m) d = Sha512Obj.state m d := by
  intro n
  induction n with
  | zero =>
    intro _ _ _ _; rfl
  | succ n ih =>
    intro i x m h
    have hc : (80#64 + BitVec.ofNat 64 (127 - i)).toNat = 80 + (127 - i) := by
      simp; omega
    rw [lenStores, ih _ _ _ (by omega),
      Sha512_update.state_storeAt hdo
        (Sha512_update.obj_disjoint hdo
          (by
            rw [hc]; omega)
          (by decide)
          (by
            rw [hc]; simp; omega))]

theorem state_lenState {s : GlobalState} {d : Pointer} (hdo : d.offset.toNat + 224 < 2 ^ 64) :
    Sha512Obj.state (lenState s d).mem d = Sha512Obj.state s.mem d := by
  simp only [lenState]
  rw [state_lenStores hdo 15 1 _ _ (by omega),
    Sha512_update.state_storeAt hdo
      (Sha512_update.obj_disjoint hdo (by decide) (by decide) (by simp))]

/-- The digest's words: the object's state after `final`'s last round. -/
theorem state_final {s : GlobalState} {d : Pointer} {M : List (BitVec 8)}
    (hA : Sha512Obj.Absorbed s.mem d M) (hf : Room s.mem d 1792)
    (hdo : d.offset.toNat + 224 < 2 ^ 64) :
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
  have hf1 : Room s1.mem d 1792 := by
    simp only [s1, padMem, Room.storeAt_iff]; exact hf
  have hP :=
    buf_padMem (P := M.drop (M.length / 128 * 128)) hf hdo hbl
      (by
        rw [hblM]; exact hA.buf)
  have hT1 : Sha512Obj.totalLen s1.mem d = BitVec.ofNat 128 M.length := by
    simp only [s1]; rw [totalLen_padMem hdo hbl, hA.totalLen]
  have hst1 : Sha512Obj.state s1.mem d = Sha512.compressBlocks Sha512.IV M := by
    simp only [s1]; rw [state_padMem hdo hbl, hA.state]
  have hPl : (M.drop (M.length / 128 * 128)).length = bl.toNat := by
    simp; omega
  have hL : BitVec.ofNat 128 M.length <<< 3 = BitVec.ofNat 128 (8 * M.length) := by
    apply BitVec.eq_of_toNat_eq; simp [BitVec.toNat_shiftLeft, Nat.shiftLeft_eq]; omega
  -- the last round on `lenState s2`
  have hf2 : Room s2.mem d 1792 := by
    simp only [s2]; split
    · exact (Sha512_update.room_roundState.2 hf1).storeAt
    · exact hf1
  have hfl : Room (lenState s2 d).mem d 1792 := by
    simp only [lenState]; exact (room_lenStores 15 1 _).2 hf2.storeAt
  rw [Sha512_update.roundState, Sha512_update.state_setState hfl hdo, state_lenState hdo,
    show (lenState s2 d).mem.readAt (d.add 80#64) 1024 = Sha512Obj.buf (lenState s2 d).mem d from
      rfl,
    buf_lenState hf2 hdo]
  simp only [s2]
  split
  · rename_i hc
    have hr80 :=
      Sha512_update.obj_disjoint (d := d) (a := 80#64) (c := 16#64) (v := 1024) (w := 512) hdo
        (by decide) (by decide) (by simp)
    have hfr : InBounds (Sha512_update.roundState s1 d (d.add 80#64)).mem (d.add 80#64) 1024 :=
      (Sha512_update.room_roundState.2
          (Room.add_of_le
            (by
              simp [BitVec.uaddOverflow]; omega)
            (by simp) hf1)).inBounds
    have hT0 : (Range.of (d.add 80#64) 1024).Disjoint (Range.of d 128) := by
      simpa using
        Sha512_update.obj_disjoint (d := d) (a := 80#64) (c := 0#64) (v := 1024) (w := 128) hdo
          (by decide) (by decide) (by simp)
    dsimp only
    rw [Sha512_update.state_storeAt hdo hr80, Sha512Obj.buf, MemoryState.readAt_storeAt_self hfr,
      Sha512Obj.totalLen, MemoryState.readAt_storeAt_disjoint hT0,
      Sha512_update.roundState_readAt (by omega) (Sha512_update.disjoint_totalLen hdo), ←
      Sha512Obj.totalLen, hT1, hL, Sha512_update.roundState, Sha512_update.state_setState hf1 hdo,
      hst1, show s1.mem.readAt (d.add 80#64) 1024 = Sha512Obj.buf s1.mem d from rfl, hP]
    have hz : bytesLE (0#1024) = List.replicate 128 (0#8) := by
      apply List.ext_getElem
      · simp
      · intro i h1 h2; rw [getElem_bytesLE, List.getElem_replicate]; simp
    rw [hz, List.take_replicate, Sha512.pad,
      show (239 - M.length % 128) % 128 = (127 - bl.toNat) + 112 by omega, ←
      List.replicate_append_replicate]
    have e :
      M ++ [0x80#8] ++ (List.replicate (127 - bl.toNat) 0#8 ++ List.replicate 112 0#8) ++
          Sha512.bytesBE (BitVec.ofNat 128 (8 * M.length)) =
        (M ++ ([0x80#8] ++ List.replicate (127 - bl.toNat) 0#8)) ++
          (List.replicate 112 0#8 ++ Sha512.bytesBE (BitVec.ofNat 128 (8 * M.length))) := by
      simp only [List.append_assoc]
    rw [e,
      Sha512_update.compressBlocks_block
        (by
          simp; omega)
        (by simp [Sha512.bytesBE]),
      Sha512_update.compressBlocks_fill
        (by
          simp; omega)]
    simp only [List.append_assoc, show min 112 128 = 112 from rfl]
  · rename_i hc
    rw [hst1, hP, hT1, hL]
    have ht :
      (M.drop (M.length / 128 * 128) ++ [0x80#8] ++ List.replicate (127 - bl.toNat) 0#8).take 112 =
        M.drop (M.length / 128 * 128) ++ [0x80#8] ++ List.replicate (111 - bl.toNat) 0#8 := by
      rw [List.take_append,
        List.take_of_length_le
          (by
            simp; omega),
        List.take_replicate]
      simp only [List.length_append, hPl, List.length_singleton]
      congr 2
      omega
    rw [ht, Sha512.pad, show (239 - M.length % 128) % 128 = 111 - bl.toNat by omega]
    have e :
      M ++ [0x80#8] ++ List.replicate (111 - bl.toNat) 0#8 ++
          Sha512.bytesBE (BitVec.ofNat 128 (8 * M.length)) =
        M ++
          ([0x80#8] ++ List.replicate (111 - bl.toNat) 0#8 ++
            Sha512.bytesBE (BitVec.ofNat 128 (8 * M.length))) := by
      simp only [List.append_assoc]
    rw [e,
      Sha512_update.compressBlocks_fill
        (by
          simp [Sha512.bytesBE]; omega)]
    simp only [List.append_assoc]

theorem flatMap_vec8 (H : Vector (BitVec 64) 8) :
    Sha512.bytesBE H[0]! ++ Sha512.bytesBE H[1]! ++ Sha512.bytesBE H[2]! ++ Sha512.bytesBE H[3]! ++
        Sha512.bytesBE H[4]! ++
        Sha512.bytesBE H[5]! ++
        Sha512.bytesBE H[6]! ++
        Sha512.bytesBE H[7]! =
      H.toList.flatMap Sha512.bytesBE := by
  rcases H with ⟨⟨l⟩, hl⟩
  simp only [List.size_toArray] at hl
  match l, hl with
  | [a, b, c, e, f, g, h, i], _ => simp

/-- `Sha512.final` on an object that has absorbed `M`: the 64 bytes at `out` are SHA-512 of
`M`. -/
public theorem digest {s : GlobalState} {d out : Pointer} {M : List (BitVec 8)}
    (hA : Sha512Obj.Absorbed s.mem d M) (hd : Sha512Obj.Fit s.mem d) (ho : InBounds s.mem out 512)
    (hoo : out.offset.toNat + 64 < 2 ^ 64) :
    bytesLE ((post s d out).mem.readAt out 512) = Sha512.digest M := by
  have hH := state_final hA hd.2.1 hd.1
  simp only at hH
  simp only [post, fromLen]
  generalize hs2 : (if 111 < (Sha512Obj.bufLen s.mem d).toNat then _ else _ : GlobalState) =
    s2 at hH
  have ho2 : InBounds s2.mem out 512 := by
    rw [← hs2]; split
    · exact
        (Sha512_update.inBounds_roundState.2
            (by
              simp only [padMem, InBounds.storeAt_iff]; exact ho)).storeAt
    · simp only [padMem, InBounds.storeAt_iff]; exact ho
  rw [bytesLE_outStores
      (Sha512_update.inBounds_roundState.2
        (by
          simp only [lenState]; exact (inBounds_lenStores 15 1 _).2 ho2.storeAt))
      hoo,
    hH, flatMap_vec8]
  rfl

/-! ### The rest of memory -/

public theorem Fits.post {s : GlobalState} (h : Fits s.mem q w) :
    Fits (Sha512_final.post s d out).mem q w := by
  simp only [Sha512_final.post, fromLen, lenState]
  split <;>
    exact
      Fits.outStores
        (Sha512_update.Fits.roundState
          (Fits.lenStores
            (by
              first
              |
                exact
                  (Sha512_update.Fits.roundState (s := { s with mem := _ })
                      h.storeAt.storeAt.storeAt).storeAt.storeAt
              | exact h.storeAt.storeAt.storeAt.storeAt)
            15 1 _))
        8 0

public theorem room_post {s : GlobalState} : Room (post s d out).mem q w ↔ Room s.mem q w := by
  simp only [post, fromLen, lenState]
  split <;>
    simp only [room_outStores, Sha512_update.room_roundState, room_lenStores, Room.storeAt_iff,
      padMem]

public theorem post_wf {s : GlobalState} (h : s.WF) : (post s d out).WF := by
  have hw : ({ s with mem := padMem s.mem d (Sha512Obj.bufLen s.mem d) } : GlobalState).WF := by
    simp only [padMem]; exact h.storeAt.storeAt.storeAt
  have hout :
    ∀ (t : GlobalState) (f : Nat → BitVec 64),
      t.WF → ({ t with mem := outStores out f 0 8 t.mem } : GlobalState).WF := by
    intro t f ht
    simp only [outStores]
    exact ht.storeAt.storeAt.storeAt.storeAt.storeAt.storeAt.storeAt.storeAt
  have hX : ∀ X : GlobalState, X.WF → (lenState X d).WF := fun X hX =>
    wf_lenStores 15 1 _ _ hX.storeAt
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
  simp only [Range.Disjoint, Range.of, Pointer.offsetInBits, Pointer.add,
    BitVec.toNat_add] at hsep ⊢
  rcases hsep with h | h | h
  · exact Or.inl h
  · right; left; rw [Nat.mod_eq_of_lt (by omega)]; omega
  · right; right; rw [Nat.mod_eq_of_lt (by omega)]; omega

theorem readAt_outStores_q {m : MemoryState} {out q : Pointer} {w : Nat} {f : Nat → BitVec 64}
    (hoo : out.offset.toNat + 64 < 2 ^ 64) (h : (Range.of out 512).Disjoint (Range.of q w)) :
    ∀ n j, j + n ≤ 8 → (outStores out f j n m).readAt q w = m.readAt q w := by
  intro n
  induction n generalizing m with
  | zero =>
    intro _ _; rfl
  | succ n ih =>
    intro j hj
    rw [outStores, ih (j + 1) (by omega),
      MemoryState.readAt_storeAt_disjoint
        (out_disjoint_q hoo h
          (by
            simp; omega))]

theorem readAt_lenStores_q {d q : Pointer} {w : Nat} (hdo : d.offset.toNat + 224 < 2 ^ 64)
    (h : (Range.of d 1792).Disjoint (Range.of q w)) :
    ∀ n i (x : BitVec 128) (m : MemoryState),
      i + n ≤ 16 → (lenStores d x i n m).readAt q w = m.readAt q w := by
  intro n
  induction n with
  | zero =>
    intro _ _ _ _; rfl
  | succ n ih =>
    intro i x m hi
    have hc : (80#64 + BitVec.ofNat 64 (127 - i)).toNat = 80 + (127 - i) := by
      simp; omega
    rw [lenStores, ih (i + 1) _ _ (by omega),
      MemoryState.readAt_storeAt_disjoint
        (Sha512_update.obj_disjoint_q hdo h
          (by
            rw [hc]; omega))]

/-- `post` keeps every read apart from the object and `out`. -/
public theorem post_readAt {s : GlobalState} {d out q : Pointer} {w : Nat}
    (hdo : d.offset.toNat + 224 < 2 ^ 64) (hoo : out.offset.toNat + 64 < 2 ^ 64)
    (hbl : (Sha512Obj.bufLen s.mem d).toNat < 128) (h1 : (Range.of d 1792).Disjoint (Range.of q w))
    (h2 : (Range.of out 512).Disjoint (Range.of q w)) :
    (post s d out).mem.readAt q w = s.mem.readAt q w := by
  have hdo' : d.offset.toNat + 80 < 2 ^ 64 := by omega
  have h16 := Sha512_update.obj_disjoint_q (a := 16#64) (v := 512) hdo h1 (by simp)
  have hpad : (padMem s.mem d (Sha512Obj.bufLen s.mem d)).readAt q w = s.mem.readAt q w := by
    have hX :
      (80#64 + BitVec.setWidth 64 (Sha512Obj.bufLen s.mem d)).toNat =
        80 + (Sha512Obj.bufLen s.mem d).toNat := by
      simp; omega
    have hk :
      (BitVec.ofNat 64 (128 - (Sha512Obj.bufLen s.mem d).toNat)).toNat =
        128 - (Sha512Obj.bufLen s.mem d).toNat := by
      simp; omega
    simp only [padMem]
    rw [MemoryState.readAt_storeAt_disjoint (Sha512_update.obj_disjoint_q hdo h1 (by simp)),
      MemoryState.readAt_storeAt_disjoint
        (Sha512_update.obj_disjoint_q hdo h1
          (by
            rw [hX]; omega)),
      MemoryState.readAt_storeAt_disjoint
        (Sha512_update.obj_disjoint_q hdo h1
          (by
            rw [hX, hk]; omega))]
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
