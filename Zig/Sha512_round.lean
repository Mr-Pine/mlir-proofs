module

public import MLIR.Run.Tactic
public import Ed25519.Sha512
public import Zig.Sha512
public import Zig.Mlir.Sha512_round
import Std.Tactic.BVDecide

/-! `Sha512.round`, one block's compression: FIPS 180-4 `Sha512.compress` of the object's state words
and the block's bytes. The 80 unrolled rounds of `^bb5` are stepped in 4-round chunks, each its
own lemma. -/

namespace MLIR.Zig

open _root_.Ed25519

namespace Sha512_round

/-- `bb5` from position `p`: the rest of the block, its exit, then `g`. -/
local macro "BODY " E:term:max ppSpace p:term:max ppSpace S:term:max ppSpace g:term:max : term =>
  `((Sha512_round.bb5.runBodyFrom $E $p $S >>= fun x =>
      Exit.run Sha512_round.blockParams x.fst Sha512_round.bb5.exit x.snd >>= fun x =>
        Func.continue (func := Sha512_round) x.1.fst x.1.snd x.snd >>= $g))


/-! ## The rounds -/

/-- `v` stored as eight 64-bit words at `p`, lowest first. -/
def storeWords8 (m : MemoryState) (p : Pointer) (v : Vector (BitVec 64) 8) : MemoryState :=
  (((((((m.storeAt p v[0]).storeAt (p.add 8#64) v[1]).storeAt (p.add 16#64) v[2]).storeAt
    (p.add 24#64) v[3]).storeAt (p.add 32#64) v[4]).storeAt (p.add 40#64) v[5]).storeAt
    (p.add 48#64) v[6]).storeAt (p.add 56#64) v[7]


/-- `x` rotated as `fshl x x n` computes it. -/
abbrev rotl (x : BitVec 64) (n : Nat) : BitVec 64 :=
  BitVec.extractLsb' 64 64 ((x ++ x) <<< n)

theorem rotl_50 (x : BitVec 64) : rotl x 50 = x.rotateRight 14 := by bv_decide
theorem rotl_46 (x : BitVec 64) : rotl x 46 = x.rotateRight 18 := by bv_decide
theorem rotl_23 (x : BitVec 64) : rotl x 23 = x.rotateRight 41 := by bv_decide
theorem rotl_36 (x : BitVec 64) : rotl x 36 = x.rotateRight 28 := by bv_decide
theorem rotl_30 (x : BitVec 64) : rotl x 30 = x.rotateRight 34 := by bv_decide
theorem rotl_25 (x : BitVec 64) : rotl x 25 = x.rotateRight 39 := by bv_decide

theorem ch0 (e f g : BitVec 64) : ((g ^^^ f) &&& e) ^^^ g = Sha512.Ch e f g := by
  simp only [Sha512.Ch]; bv_decide
theorem ch1 (e f g : BitVec 64) : (e &&& (g ^^^ f)) ^^^ g = Sha512.Ch e f g := by
  simp only [Sha512.Ch]; bv_decide
theorem ch2 (e f g : BitVec 64) : (e &&& (f ^^^ g)) ^^^ g = Sha512.Ch e f g := by
  simp only [Sha512.Ch]; bv_decide
theorem maj0 (a b c : BitVec 64) : ((c ||| b) &&& a) ||| (c &&& b) = Sha512.Maj a b c := by
  simp only [Sha512.Maj]; bv_decide
theorem maj1 (a b c : BitVec 64) : (a &&& (c ||| b)) ||| (c &&& b) = Sha512.Maj a b c := by
  simp only [Sha512.Maj]; bv_decide
theorem maj2 (a b c : BitVec 64) : (a &&& (b ||| c)) ||| (b &&& c) = Sha512.Maj a b c := by
  simp only [Sha512.Maj]; bv_decide

/-- `Σ₁` as the code computes it. -/
abbrev S1 (e : BitVec 64) : BitVec 64 := (rotl e 50 ^^^ rotl e 46) ^^^ rotl e 23

/-- `Σ₀` as the code computes it. -/
abbrev S0 (a : BitVec 64) : BitVec 64 := (rotl a 36 ^^^ rotl a 30) ^^^ rotl a 25

theorem S1_eq (e : BitVec 64) : S1 e = Sha512.Sigma1 e := by
  simp only [S1, rotl_50, rotl_46, rotl_23, Sha512.Sigma1]

theorem S0_eq (a : BitVec 64) : S0 a = Sha512.Sigma0 a := by
  simp only [S0, rotl_36, rotl_30, rotl_25, Sha512.Sigma0]

/-- A round's two new words, `#v[a', a, b, c, e', e, f, g]`. -/
theorem round_of (a b c d e f g h k w a' e' : BitVec 64)
    (ha : a' = h + Sha512.Sigma1 e + Sha512.Ch e f g + k + w + (Sha512.Sigma0 a + Sha512.Maj a b c))
    (he : e' = d + (h + Sha512.Sigma1 e + Sha512.Ch e f g + k + w)) :
    Sha512.round #v[a, b, c, d, e, f, g, h] k w = #v[a', a, b, c, e', e, f, g] := by
  subst ha he
  rfl

/-- Round `0`'s order of operations. -/
theorem round_eq0 (a b c d e f g h k w : BitVec 64) :
    Sha512.round #v[a, b, c, d, e, f, g, h] k w =
      #v[(((c ||| b) &&& a) ||| (c &&& b)) + S0 a + ((((S1 e + k) + h) + w) + (((g ^^^ f) &&& e) ^^^ g)),
        a, b, c, ((((S1 e + k) + h) + w) + (((g ^^^ f) &&& e) ^^^ g)) + d, e, f, g] := by
  apply round_of <;> simp only [S1_eq, S0_eq, ch0, maj0] <;> ac_rfl

/-- Round `1`'s order of operations. -/
theorem round_eq1 (a b c d e f g h k w : BitVec 64) :
    Sha512.round #v[a, b, c, d, e, f, g, h] k w =
      #v[S0 a + ((a &&& (c ||| b)) ||| (c &&& b)) + ((((h + k) + w) + ((e &&& (g ^^^ f)) ^^^ g)) + S1 e),
        a, b, c, ((((h + k) + w) + ((e &&& (g ^^^ f)) ^^^ g)) + S1 e) + d, e, f, g] := by
  apply round_of <;> simp only [S1_eq, S0_eq, ch1, maj1] <;> ac_rfl

/-- Rounds `2`, `3`'s order of operations. -/
theorem round_eq2 (a b c d e f g h k w : BitVec 64) :
    Sha512.round #v[a, b, c, d, e, f, g, h] k w =
      #v[S0 a + ((a &&& (b ||| c)) ||| (b &&& c)) + ((((h + k) + w) + ((e &&& (f ^^^ g)) ^^^ g)) + S1 e),
        a, b, c, ((((h + k) + w) + ((e &&& (f ^^^ g)) ^^^ g)) + S1 e) + d, e, f, g] := by
  apply round_of <;> simp only [S1_eq, S0_eq, ch2, maj2] <;> ac_rfl

/-- Rounds `4 … 79`'s order of operations. -/
theorem round_eq4 (a b c d e f g h k w : BitVec 64) :
    Sha512.round #v[a, b, c, d, e, f, g, h] k w =
      #v[S0 a + ((a &&& (b ||| c)) ||| (b &&& c)) + ((((w + k) + h) + ((e &&& (f ^^^ g)) ^^^ g)) + S1 e),
        a, b, c, ((((w + k) + h) + ((e &&& (f ^^^ g)) ^^^ g)) + S1 e) + d, e, f, g] := by
  apply round_of <;> simp only [S1_eq, S0_eq, ch2, maj2] <;> ac_rfl

/-- The constants `^bb0` writes. -/
abbrev Consts (E : ⟪Γ⟫) : Prop :=
  E ⊨ [%1 := 0#64, %2 := 16#64, %3 := 3#64, %4 := 1#64, %5 := 80#64,
    %6 := 18446744073709551600#64, %7 := 18446744073709551609#64, %8 := 18446744073709551601#64,
    %9 := 63#64, %10 := 56#64, %11 := 7#64, %12 := 18446744073709551614#64, %13 := 45#64,
    %14 := 6#64, %15 := 50#64, %16 := 46#64, %17 := 23#64, %18 := 4794697086780616226#64,
    %19 := 36#64, %20 := 30#64, %21 := 25#64, %22 := 8#64, %23 := 8158064640168781261#64,
    %24 := 13096744586834688815#64, %25 := 16840607885511220156#64, %26 := 4131703408338449720#64,
    %27 := 6480981068601479193#64, %28 := 10538285296894168987#64, %29 := 12329834152419229976#64,
    %30 := 15566598209576043074#64, %31 := 1334009975649890238#64, %32 := 2608012711638119052#64,
    %33 := 6128411473006802146#64, %34 := 8268148722764581231#64, %35 := 9286055187155687089#64,
    %36 := 11230858885718282805#64, %37 := 13951009754708518548#64,
    %38 := 16472876342353939154#64, %39 := 17275323862435702243#64, %40 := 1135362057144423861#64,
    %41 := 2597628984639134821#64, %42 := 3308224258029322869#64, %43 := 5365058923640841347#64,
    %44 := 6679025012923562964#64, %45 := 8573033837759648693#64, %46 := 10970295158949994411#64,
    %47 := 12119686244451234320#64, %48 := 12683024718118986047#64,
    %49 := 13788192230050041572#64, %50 := 14330467153632333762#64,
    %51 := 15395433587784984357#64, %52 := 489312712824947311#64, %53 := 1452737877330783856#64,
    %54 := 2861767655752347644#64, %55 := 3322285676063803686#64, %56 := 5560940570517711597#64,
    %57 := 5996557281743188959#64, %58 := 7280758554555802590#64, %59 := 8532644243296465576#64,
    %60 := 9350256976987008742#64, %61 := 10552545826968843579#64, %62 := 11727347734174303076#64,
    %63 := 12113106623233404929#64, %64 := 14000437183269869457#64,
    %65 := 14369950271660146224#64, %66 := 15101387698204529176#64,
    %67 := 15463397548674623760#64, %68 := 17586052441742319658#64, %69 := 1182934255886127544#64,
    %70 := 1847814050463011016#64, %71 := 2177327727835720531#64, %72 := 2830643537854262169#64,
    %73 := 3796741975233480872#64, %74 := 4115178125766777443#64, %75 := 5681478168544905931#64,
    %76 := 6601373596472566643#64, %77 := 7507060721942968483#64, %78 := 8399075790359081724#64,
    %79 := 8693463985226723168#64, %80 := 9568029438360202098#64, %81 := 10144078919501101548#64,
    %82 := 10430055236837252648#64, %83 := 11840083180663258601#64,
    %84 := 13761210420658862357#64, %85 := 14299343276471374635#64,
    %86 := 14566680578165727644#64, %87 := 15097957966210449927#64,
    %88 := 16922976911328602910#64, %89 := 17689382322260857208#64, %90 := 500013540394364858#64,
    %91 := 748580250866718886#64, %92 := 1242879168328830382#64, %93 := 1977374033974150939#64,
    %94 := 2944078676154940804#64, %95 := 3659926193048069267#64, %96 := 4368137639120453308#64,
    %97 := 4836135668995329356#64, %98 := 5532061633213252278#64, %99 := 6448918945643986474#64,
    %100 := 6902733635092675308#64, %101 := 7801388544844847127#64]
/-! ## The rounds' block -/

/-- A register read right after its write, whatever the proofs of its type: no cast to reduce,
which for a late register would walk `Γ`'s types. -/
theorem read_write_same (E : ⟪Γ⟫) (i : Fin Γ.n) (h h' : Γ.ty i = t) (v : ⟦t⟧) :
    (E.write ⟨i, h⟩ v).read (.val i h') = v := by
  subst h
  exact Env.read_write_dst E ⟨i, rfl⟩ v

attribute [local mlir_env 1100] read_write_same

/-- `bb5`'s instructions all run by position `2110`; `decide` would walk the list. -/
theorem bb5_done : 2110 ≥ Sha512_round.bb5.body.length := by decide +kernel

/-- Rounds `t0 … t0 + n - 1` on the working variables `v`, `Wf t` the schedule's word `t`. -/
def rounds (Wf : Nat → BitVec 64) (t0 n : Nat) (v : Vector (BitVec 64) 8) : Vector (BitVec 64) 8 :=
  (List.range' t0 n).foldl (fun v t => Sha512.round v Sha512.K[t]! (Wf t)) v

theorem rounds_zero (Wf : Nat → BitVec 64) (t : Nat) (v : Vector (BitVec 64) 8) :
    rounds Wf t 0 v = v := rfl

theorem rounds_succ (Wf : Nat → BitVec 64) (t n : Nat) (v : Vector (BitVec 64) 8) :
    rounds Wf t (n + 1) v = rounds Wf (t + 1) n (Sha512.round v Sha512.K[t]! (Wf t)) := by
  simp only [rounds, List.range'_succ, List.foldl_cons]

theorem rounds_add (Wf : Nat → BitVec 64) (t m n : Nat) (v : Vector (BitVec 64) 8) :
    rounds Wf t (m + n) v = rounds Wf (t + m) n (rounds Wf t m v) := by
  simp only [rounds, ← List.range'_append_1, List.foldl_append]

set_option maxHeartbeats 0 in
/-- Rounds `0` to `3`, after loading the state words. -/
theorem chunk0 (dd blk V W : Pointer) (Wf : Nat → BitVec 64) (a b c d e f g h : BitVec 64)
    (E : ⟪Γ⟫) (S : GlobalState) {β : Type} (κ : Vals [] × GlobalState → PoisonOr β)
    (R : PoisonOr β) (hArgs : E.args = (Sha512_round.args (.value dd) (.value blk)).get)
    (hc : Consts E) (hR : E ⊨ [%102 := V, %103 := W]) (hdo : dd.offset.toNat + 80 < 2 ^ 64)
    (hF0 : Fits S.mem (dd.add 16#64) 64) (hF1 : Fits S.mem (dd.add 24#64) 64)
    (hF2 : Fits S.mem (dd.add 32#64) 64) (hF3 : Fits S.mem (dd.add 40#64) 64)
    (hF4 : Fits S.mem (dd.add 48#64) 64) (hF5 : Fits S.mem (dd.add 56#64) 64)
    (hF6 : Fits S.mem (dd.add 64#64) 64) (hF7 : Fits S.mem (dd.add 72#64) 64)
    (hd0 : S.mem.readAt (dd.add 16#64) 64 = a)
    (hd1 : S.mem.readAt (dd.add 24#64) 64 = b)
    (hd2 : S.mem.readAt (dd.add 32#64) 64 = c)
    (hd3 : S.mem.readAt (dd.add 40#64) 64 = d)
    (hd4 : S.mem.readAt (dd.add 48#64) 64 = e)
    (hd5 : S.mem.readAt (dd.add 56#64) 64 = f)
    (hd6 : S.mem.readAt (dd.add 64#64) 64 = g)
    (hd7 : S.mem.readAt (dd.add 72#64) 64 = h)
    (hWo : W.offset = 0) (hWf : Fits S.mem W 5120)
    (hW : ∀ t, t < 80 → S.mem.readAt (W.add (BitVec.ofNat 64 (8 * t))) 64 = Wf t)
    (hK : ∀ (E' : ⟪Γ⟫) (a' b' c' d' e' f' g' h' : BitVec 64),
      #v[a', b', c', d', e', f', g', h'] = rounds Wf 0 4 #v[a, b, c, d, e, f, g, h] →
        E'.args = (Sha512_round.args (.value dd) (.value blk)).get → Consts E' →
        (E' ⊨ [%259 := a', %233 := b', %207 := c', %181 := d', %248 := e', %222 := f', %196 := g',
          %170 := h', %102 := V, %103 := W, %141 := dd.add 16#64]) →
        BODY E' 119 S κ = R) :
    BODY E 0 S κ = R := by
  iterate 8
    step_pure
    step_load
  iterate 8 step_pure
  have hw : S.mem.readAt W 64 = Wf 0 := by rw [hS]; simpa using hW 0 (by decide)
  step_load consuming hw
  iterate 3 step_pure
  step_pure with t0 ht0
  step_pure with e1 he0
  iterate 10 step_pure
  step_pure with a1 ha0
  have hr0 : Sha512.round #v[a, b, c, d, e, f, g, h] Sha512.K[0]! (Wf 0) =
      #v[a1, a, b, c, e1, e, f, g] := by
    rw [ha0, he0, ht0]; exact round_eq0 ..
  clear ha0 he0 ht0
  iterate 9 step_pure
  have hw : S.mem.readAt (W.add 8#64) 64 = Wf 1 := by
    first | exact hW 1 (by decide) | (rw [hS]; exact hW 1 (by decide))
  step_load consuming hw
  iterate 3 step_pure
  step_pure with t1 ht1
  step_pure with e2 he1
  iterate 10 step_pure
  step_pure with a2 ha1
  have hr1 : Sha512.round #v[a1, a, b, c, e1, e, f, g] Sha512.K[1]! (Wf 1) =
      #v[a2, a1, a, b, e2, e1, e, f] := by
    rw [ha1, he1, ht1]; exact round_eq1 ..
  clear ha1 he1 ht1
  iterate 9 step_pure
  have hw : S.mem.readAt (W.add 16#64) 64 = Wf 2 := by
    first | exact hW 2 (by decide) | (rw [hS]; exact hW 2 (by decide))
  step_load consuming hw
  iterate 3 step_pure
  step_pure with t2 ht2
  step_pure with e3 he2
  iterate 10 step_pure
  step_pure with a3 ha2
  have hr2 : Sha512.round #v[a2, a1, a, b, e2, e1, e, f] Sha512.K[2]! (Wf 2) =
      #v[a3, a2, a1, a, e3, e2, e1, e] := by
    rw [ha2, he2, ht2]; exact round_eq2 ..
  clear ha2 he2 ht2
  iterate 9 step_pure
  have hw : S.mem.readAt (W.add 24#64) 64 = Wf 3 := by
    first | exact hW 3 (by decide) | (rw [hS]; exact hW 3 (by decide))
  step_load consuming hw
  iterate 3 step_pure
  step_pure with t3 ht3
  step_pure with e4 he3
  iterate 10 step_pure
  step_pure with a4 ha3
  have hr3 : Sha512.round #v[a3, a2, a1, a, e3, e2, e1, e] Sha512.K[3]! (Wf 3) =
      #v[a4, a3, a2, a1, e4, e3, e2, e1] := by
    rw [ha3, he3, ht3]; exact round_eq2 ..
  clear ha3 he3 ht3
  have hv : #v[a4, a3, a2, a1, e4, e3, e2, e1] = rounds Wf 0 4 #v[a, b, c, d, e, f, g, h] := by
    rw [rounds_succ, hr0, rounds_succ, hr1, rounds_succ, hr2, rounds_succ, hr3, rounds_zero]
  first | subst hS | skip
  exact hK E a4 a3 a2 a1 e4 e3 e2 e1 hv hArgs (by env_reads) (by env_reads)

set_option maxHeartbeats 0 in
/-- Rounds `4` to `7`. -/
theorem chunk4 (dd blk V W : Pointer) (Wf : Nat → BitVec 64) (a b c d e f g h : BitVec 64)
    (E : ⟪Γ⟫) (S : GlobalState) {β : Type} (κ : Vals [] × GlobalState → PoisonOr β)
    (R : PoisonOr β) (hArgs : E.args = (Sha512_round.args (.value dd) (.value blk)).get)
    (hc : Consts E)
    (hR : E ⊨ [%259 := a, %233 := b, %207 := c, %181 := d, %248 := e, %222 := f, %196 := g,
      %170 := h, %102 := V, %103 := W, %141 := dd.add 16#64])
    (hWo : W.offset = 0) (hWf : Fits S.mem W 5120)
    (hW : ∀ t, t < 80 → S.mem.readAt (W.add (BitVec.ofNat 64 (8 * t))) 64 = Wf t)
    (hK : ∀ (E' : ⟪Γ⟫) (a' b' c' d' e' f' g' h' : BitVec 64),
      #v[a', b', c', d', e', f', g', h'] = rounds Wf 4 4 #v[a, b, c, d, e, f, g, h] →
        E'.args = (Sha512_round.args (.value dd) (.value blk)).get → Consts E' →
        (E' ⊨ [rir_reg% hty 363 := a', rir_reg% hty 337 := b', rir_reg% hty 311 := c', %285 := d',
          rir_reg% hty 352 := e', rir_reg% hty 326 := f', rir_reg% hty 300 := g', %274 := h',
          %102 := V, %103 := W, %141 := dd.add 16#64]) →
        BODY E' 223 S κ = R) :
    BODY E 119 S κ = R := by
  iterate 9 step_pure
  have hw : S.mem.readAt (W.add 32#64) 64 = Wf 4 := by
    first | exact hW 4 (by decide) | (rw [hS]; exact hW 4 (by decide))
  step_load consuming hw
  iterate 3 step_pure
  step_pure with t4 ht4
  step_pure with e5 he4
  iterate 10 step_pure
  step_pure with a5 ha4
  have hr4 : Sha512.round #v[a, b, c, d, e, f, g, h] Sha512.K[4]! (Wf 4) =
      #v[a5, a, b, c, e5, e, f, g] := by
    rw [ha4, he4, ht4]; exact round_eq4 ..
  clear ha4 he4 ht4
  iterate 9 step_pure
  have hw : S.mem.readAt (W.add 40#64) 64 = Wf 5 := by
    first | exact hW 5 (by decide) | (rw [hS]; exact hW 5 (by decide))
  step_load consuming hw
  iterate 3 step_pure
  step_pure with t5 ht5
  step_pure with e6 he5
  iterate 10 step_pure
  step_pure with a6 ha5
  have hr5 : Sha512.round #v[a5, a, b, c, e5, e, f, g] Sha512.K[5]! (Wf 5) =
      #v[a6, a5, a, b, e6, e5, e, f] := by
    rw [ha5, he5, ht5]; exact round_eq4 ..
  clear ha5 he5 ht5
  iterate 9 step_pure
  have hw : S.mem.readAt (W.add 48#64) 64 = Wf 6 := by
    first | exact hW 6 (by decide) | (rw [hS]; exact hW 6 (by decide))
  step_load consuming hw
  iterate 3 step_pure
  step_pure with t6 ht6
  step_pure with e7 he6
  iterate 10 step_pure
  step_pure with a7 ha6
  have hr6 : Sha512.round #v[a6, a5, a, b, e6, e5, e, f] Sha512.K[6]! (Wf 6) =
      #v[a7, a6, a5, a, e7, e6, e5, e] := by
    rw [ha6, he6, ht6]; exact round_eq4 ..
  clear ha6 he6 ht6
  iterate 9 step_pure
  have hw : S.mem.readAt (W.add 56#64) 64 = Wf 7 := by
    first | exact hW 7 (by decide) | (rw [hS]; exact hW 7 (by decide))
  step_load consuming hw
  iterate 3 step_pure
  step_pure with t7 ht7
  step_pure with e8 he7
  iterate 10 step_pure
  step_pure with a8 ha7
  have hr7 : Sha512.round #v[a7, a6, a5, a, e7, e6, e5, e] Sha512.K[7]! (Wf 7) =
      #v[a8, a7, a6, a5, e8, e7, e6, e5] := by
    rw [ha7, he7, ht7]; exact round_eq4 ..
  clear ha7 he7 ht7
  have hv : #v[a8, a7, a6, a5, e8, e7, e6, e5] = rounds Wf 4 4 #v[a, b, c, d, e, f, g, h] := by
    rw [rounds_succ, hr4, rounds_succ, hr5, rounds_succ, hr6, rounds_succ, hr7, rounds_zero]
  first | subst hS | skip
  exact hK E a8 a7 a6 a5 e8 e7 e6 e5 hv hArgs (by env_reads) (by env_reads)

set_option maxHeartbeats 0 in
/-- Rounds `8` to `11`. -/
theorem chunk8 (dd blk V W : Pointer) (Wf : Nat → BitVec 64) (a b c d e f g h : BitVec 64)
    (E : ⟪Γ⟫) (S : GlobalState) {β : Type} (κ : Vals [] × GlobalState → PoisonOr β)
    (R : PoisonOr β) (hArgs : E.args = (Sha512_round.args (.value dd) (.value blk)).get)
    (hc : Consts E)
    (hR : E ⊨ [rir_reg% hty 363 := a, rir_reg% hty 337 := b, rir_reg% hty 311 := c, %285 := d,
      rir_reg% hty 352 := e, rir_reg% hty 326 := f, rir_reg% hty 300 := g, %274 := h, %102 := V,
      %103 := W, %141 := dd.add 16#64])
    (hWo : W.offset = 0) (hWf : Fits S.mem W 5120)
    (hW : ∀ t, t < 80 → S.mem.readAt (W.add (BitVec.ofNat 64 (8 * t))) 64 = Wf t)
    (hK : ∀ (E' : ⟪Γ⟫) (a' b' c' d' e' f' g' h' : BitVec 64),
      #v[a', b', c', d', e', f', g', h'] = rounds Wf 8 4 #v[a, b, c, d, e, f, g, h] →
        E'.args = (Sha512_round.args (.value dd) (.value blk)).get → Consts E' →
        (E' ⊨ [rir_reg% hty 467 := a', rir_reg% hty 441 := b', rir_reg% hty 415 := c',
          rir_reg% hty 389 := d', rir_reg% hty 456 := e', rir_reg% hty 430 := f',
          rir_reg% hty 404 := g', rir_reg% hty 378 := h', %102 := V, %103 := W,
          %141 := dd.add 16#64]) →
        BODY E' 327 S κ = R) :
    BODY E 223 S κ = R := by
  iterate 9 step_pure
  have hw : S.mem.readAt (W.add 64#64) 64 = Wf 8 := by
    first | exact hW 8 (by decide) | (rw [hS]; exact hW 8 (by decide))
  step_load consuming hw
  iterate 3 step_pure
  step_pure with t8 ht8
  step_pure with e9 he8
  iterate 10 step_pure
  step_pure with a9 ha8
  have hr8 : Sha512.round #v[a, b, c, d, e, f, g, h] Sha512.K[8]! (Wf 8) =
      #v[a9, a, b, c, e9, e, f, g] := by
    rw [ha8, he8, ht8]; exact round_eq4 ..
  clear ha8 he8 ht8
  iterate 9 step_pure
  have hw : S.mem.readAt (W.add 72#64) 64 = Wf 9 := by
    first | exact hW 9 (by decide) | (rw [hS]; exact hW 9 (by decide))
  step_load consuming hw
  iterate 3 step_pure
  step_pure with t9 ht9
  step_pure with e10 he9
  iterate 10 step_pure
  step_pure with a10 ha9
  have hr9 : Sha512.round #v[a9, a, b, c, e9, e, f, g] Sha512.K[9]! (Wf 9) =
      #v[a10, a9, a, b, e10, e9, e, f] := by
    rw [ha9, he9, ht9]; exact round_eq4 ..
  clear ha9 he9 ht9
  iterate 9 step_pure
  have hw : S.mem.readAt (W.add 80#64) 64 = Wf 10 := by
    first | exact hW 10 (by decide) | (rw [hS]; exact hW 10 (by decide))
  step_load consuming hw
  iterate 3 step_pure
  step_pure with t10 ht10
  step_pure with e11 he10
  iterate 10 step_pure
  step_pure with a11 ha10
  have hr10 : Sha512.round #v[a10, a9, a, b, e10, e9, e, f] Sha512.K[10]! (Wf 10) =
      #v[a11, a10, a9, a, e11, e10, e9, e] := by
    rw [ha10, he10, ht10]; exact round_eq4 ..
  clear ha10 he10 ht10
  iterate 9 step_pure
  have hw : S.mem.readAt (W.add 88#64) 64 = Wf 11 := by
    first | exact hW 11 (by decide) | (rw [hS]; exact hW 11 (by decide))
  step_load consuming hw
  iterate 3 step_pure
  step_pure with t11 ht11
  step_pure with e12 he11
  iterate 10 step_pure
  step_pure with a12 ha11
  have hr11 : Sha512.round #v[a11, a10, a9, a, e11, e10, e9, e] Sha512.K[11]! (Wf 11) =
      #v[a12, a11, a10, a9, e12, e11, e10, e9] := by
    rw [ha11, he11, ht11]; exact round_eq4 ..
  clear ha11 he11 ht11
  have hv : #v[a12, a11, a10, a9, e12, e11, e10, e9] = rounds Wf 8 4 #v[a, b, c, d, e, f, g, h] := by
    rw [rounds_succ, hr8, rounds_succ, hr9, rounds_succ, hr10, rounds_succ, hr11, rounds_zero]
  first | subst hS | skip
  exact hK E a12 a11 a10 a9 e12 e11 e10 e9 hv hArgs (by env_reads) (by env_reads)

set_option maxHeartbeats 0 in
/-- Rounds `12` to `15`. -/
theorem chunk12 (dd blk V W : Pointer) (Wf : Nat → BitVec 64) (a b c d e f g h : BitVec 64)
    (E : ⟪Γ⟫) (S : GlobalState) {β : Type} (κ : Vals [] × GlobalState → PoisonOr β)
    (R : PoisonOr β) (hArgs : E.args = (Sha512_round.args (.value dd) (.value blk)).get)
    (hc : Consts E)
    (hR : E ⊨ [rir_reg% hty 467 := a, rir_reg% hty 441 := b, rir_reg% hty 415 := c,
      rir_reg% hty 389 := d, rir_reg% hty 456 := e, rir_reg% hty 430 := f, rir_reg% hty 404 := g,
      rir_reg% hty 378 := h, %102 := V, %103 := W, %141 := dd.add 16#64])
    (hWo : W.offset = 0) (hWf : Fits S.mem W 5120)
    (hW : ∀ t, t < 80 → S.mem.readAt (W.add (BitVec.ofNat 64 (8 * t))) 64 = Wf t)
    (hK : ∀ (E' : ⟪Γ⟫) (a' b' c' d' e' f' g' h' : BitVec 64),
      #v[a', b', c', d', e', f', g', h'] = rounds Wf 12 4 #v[a, b, c, d, e, f, g, h] →
        E'.args = (Sha512_round.args (.value dd) (.value blk)).get → Consts E' →
        (E' ⊨ [rir_reg% hty 571 := a', rir_reg% hty 545 := b', rir_reg% hty 519 := c',
          rir_reg% hty 493 := d', rir_reg% hty 560 := e', rir_reg% hty 534 := f',
          rir_reg% hty 508 := g', rir_reg% hty 482 := h', %102 := V, %103 := W,
          %141 := dd.add 16#64]) →
        BODY E' 431 S κ = R) :
    BODY E 327 S κ = R := by
  iterate 9 step_pure
  have hw : S.mem.readAt (W.add 96#64) 64 = Wf 12 := by
    first | exact hW 12 (by decide) | (rw [hS]; exact hW 12 (by decide))
  step_load consuming hw
  iterate 3 step_pure
  step_pure with t12 ht12
  step_pure with e13 he12
  iterate 10 step_pure
  step_pure with a13 ha12
  have hr12 : Sha512.round #v[a, b, c, d, e, f, g, h] Sha512.K[12]! (Wf 12) =
      #v[a13, a, b, c, e13, e, f, g] := by
    rw [ha12, he12, ht12]; exact round_eq4 ..
  clear ha12 he12 ht12
  iterate 9 step_pure
  have hw : S.mem.readAt (W.add 104#64) 64 = Wf 13 := by
    first | exact hW 13 (by decide) | (rw [hS]; exact hW 13 (by decide))
  step_load consuming hw
  iterate 3 step_pure
  step_pure with t13 ht13
  step_pure with e14 he13
  iterate 10 step_pure
  step_pure with a14 ha13
  have hr13 : Sha512.round #v[a13, a, b, c, e13, e, f, g] Sha512.K[13]! (Wf 13) =
      #v[a14, a13, a, b, e14, e13, e, f] := by
    rw [ha13, he13, ht13]; exact round_eq4 ..
  clear ha13 he13 ht13
  iterate 9 step_pure
  have hw : S.mem.readAt (W.add 112#64) 64 = Wf 14 := by
    first | exact hW 14 (by decide) | (rw [hS]; exact hW 14 (by decide))
  step_load consuming hw
  iterate 3 step_pure
  step_pure with t14 ht14
  step_pure with e15 he14
  iterate 10 step_pure
  step_pure with a15 ha14
  have hr14 : Sha512.round #v[a14, a13, a, b, e14, e13, e, f] Sha512.K[14]! (Wf 14) =
      #v[a15, a14, a13, a, e15, e14, e13, e] := by
    rw [ha14, he14, ht14]; exact round_eq4 ..
  clear ha14 he14 ht14
  iterate 9 step_pure
  have hw : S.mem.readAt (W.add 120#64) 64 = Wf 15 := by
    first | exact hW 15 (by decide) | (rw [hS]; exact hW 15 (by decide))
  step_load consuming hw
  iterate 3 step_pure
  step_pure with t15 ht15
  step_pure with e16 he15
  iterate 10 step_pure
  step_pure with a16 ha15
  have hr15 : Sha512.round #v[a15, a14, a13, a, e15, e14, e13, e] Sha512.K[15]! (Wf 15) =
      #v[a16, a15, a14, a13, e16, e15, e14, e13] := by
    rw [ha15, he15, ht15]; exact round_eq4 ..
  clear ha15 he15 ht15
  have hv : #v[a16, a15, a14, a13, e16, e15, e14, e13] = rounds Wf 12 4 #v[a, b, c, d, e, f, g, h] := by
    rw [rounds_succ, hr12, rounds_succ, hr13, rounds_succ, hr14, rounds_succ, hr15, rounds_zero]
  first | subst hS | skip
  exact hK E a16 a15 a14 a13 e16 e15 e14 e13 hv hArgs (by env_reads) (by env_reads)

set_option maxHeartbeats 0 in
/-- Rounds `16` to `19`. -/
theorem chunk16 (dd blk V W : Pointer) (Wf : Nat → BitVec 64) (a b c d e f g h : BitVec 64)
    (E : ⟪Γ⟫) (S : GlobalState) {β : Type} (κ : Vals [] × GlobalState → PoisonOr β)
    (R : PoisonOr β) (hArgs : E.args = (Sha512_round.args (.value dd) (.value blk)).get)
    (hc : Consts E)
    (hR : E ⊨ [rir_reg% hty 571 := a, rir_reg% hty 545 := b, rir_reg% hty 519 := c,
      rir_reg% hty 493 := d, rir_reg% hty 560 := e, rir_reg% hty 534 := f, rir_reg% hty 508 := g,
      rir_reg% hty 482 := h, %102 := V, %103 := W, %141 := dd.add 16#64])
    (hWo : W.offset = 0) (hWf : Fits S.mem W 5120)
    (hW : ∀ t, t < 80 → S.mem.readAt (W.add (BitVec.ofNat 64 (8 * t))) 64 = Wf t)
    (hK : ∀ (E' : ⟪Γ⟫) (a' b' c' d' e' f' g' h' : BitVec 64),
      #v[a', b', c', d', e', f', g', h'] = rounds Wf 16 4 #v[a, b, c, d, e, f, g, h] →
        E'.args = (Sha512_round.args (.value dd) (.value blk)).get → Consts E' →
        (E' ⊨ [rir_reg% hty 675 := a', rir_reg% hty 649 := b', rir_reg% hty 623 := c',
          rir_reg% hty 597 := d', rir_reg% hty 664 := e', rir_reg% hty 638 := f',
          rir_reg% hty 612 := g', rir_reg% hty 586 := h', %102 := V, %103 := W,
          %141 := dd.add 16#64]) →
        BODY E' 535 S κ = R) :
    BODY E 431 S κ = R := by
  iterate 9 step_pure
  have hw : S.mem.readAt (W.add 128#64) 64 = Wf 16 := by
    first | exact hW 16 (by decide) | (rw [hS]; exact hW 16 (by decide))
  step_load consuming hw
  iterate 3 step_pure
  step_pure with t16 ht16
  step_pure with e17 he16
  iterate 10 step_pure
  step_pure with a17 ha16
  have hr16 : Sha512.round #v[a, b, c, d, e, f, g, h] Sha512.K[16]! (Wf 16) =
      #v[a17, a, b, c, e17, e, f, g] := by
    rw [ha16, he16, ht16]; exact round_eq4 ..
  clear ha16 he16 ht16
  iterate 9 step_pure
  have hw : S.mem.readAt (W.add 136#64) 64 = Wf 17 := by
    first | exact hW 17 (by decide) | (rw [hS]; exact hW 17 (by decide))
  step_load consuming hw
  iterate 3 step_pure
  step_pure with t17 ht17
  step_pure with e18 he17
  iterate 10 step_pure
  step_pure with a18 ha17
  have hr17 : Sha512.round #v[a17, a, b, c, e17, e, f, g] Sha512.K[17]! (Wf 17) =
      #v[a18, a17, a, b, e18, e17, e, f] := by
    rw [ha17, he17, ht17]; exact round_eq4 ..
  clear ha17 he17 ht17
  iterate 9 step_pure
  have hw : S.mem.readAt (W.add 144#64) 64 = Wf 18 := by
    first | exact hW 18 (by decide) | (rw [hS]; exact hW 18 (by decide))
  step_load consuming hw
  iterate 3 step_pure
  step_pure with t18 ht18
  step_pure with e19 he18
  iterate 10 step_pure
  step_pure with a19 ha18
  have hr18 : Sha512.round #v[a18, a17, a, b, e18, e17, e, f] Sha512.K[18]! (Wf 18) =
      #v[a19, a18, a17, a, e19, e18, e17, e] := by
    rw [ha18, he18, ht18]; exact round_eq4 ..
  clear ha18 he18 ht18
  iterate 9 step_pure
  have hw : S.mem.readAt (W.add 152#64) 64 = Wf 19 := by
    first | exact hW 19 (by decide) | (rw [hS]; exact hW 19 (by decide))
  step_load consuming hw
  iterate 3 step_pure
  step_pure with t19 ht19
  step_pure with e20 he19
  iterate 10 step_pure
  step_pure with a20 ha19
  have hr19 : Sha512.round #v[a19, a18, a17, a, e19, e18, e17, e] Sha512.K[19]! (Wf 19) =
      #v[a20, a19, a18, a17, e20, e19, e18, e17] := by
    rw [ha19, he19, ht19]; exact round_eq4 ..
  clear ha19 he19 ht19
  have hv : #v[a20, a19, a18, a17, e20, e19, e18, e17] = rounds Wf 16 4 #v[a, b, c, d, e, f, g, h] := by
    rw [rounds_succ, hr16, rounds_succ, hr17, rounds_succ, hr18, rounds_succ, hr19, rounds_zero]
  first | subst hS | skip
  exact hK E a20 a19 a18 a17 e20 e19 e18 e17 hv hArgs (by env_reads) (by env_reads)

set_option maxHeartbeats 0 in
/-- Rounds `20` to `23`. -/
theorem chunk20 (dd blk V W : Pointer) (Wf : Nat → BitVec 64) (a b c d e f g h : BitVec 64)
    (E : ⟪Γ⟫) (S : GlobalState) {β : Type} (κ : Vals [] × GlobalState → PoisonOr β)
    (R : PoisonOr β) (hArgs : E.args = (Sha512_round.args (.value dd) (.value blk)).get)
    (hc : Consts E)
    (hR : E ⊨ [rir_reg% hty 675 := a, rir_reg% hty 649 := b, rir_reg% hty 623 := c,
      rir_reg% hty 597 := d, rir_reg% hty 664 := e, rir_reg% hty 638 := f, rir_reg% hty 612 := g,
      rir_reg% hty 586 := h, %102 := V, %103 := W, %141 := dd.add 16#64])
    (hWo : W.offset = 0) (hWf : Fits S.mem W 5120)
    (hW : ∀ t, t < 80 → S.mem.readAt (W.add (BitVec.ofNat 64 (8 * t))) 64 = Wf t)
    (hK : ∀ (E' : ⟪Γ⟫) (a' b' c' d' e' f' g' h' : BitVec 64),
      #v[a', b', c', d', e', f', g', h'] = rounds Wf 20 4 #v[a, b, c, d, e, f, g, h] →
        E'.args = (Sha512_round.args (.value dd) (.value blk)).get → Consts E' →
        (E' ⊨ [rir_reg% hty 779 := a', rir_reg% hty 753 := b', rir_reg% hty 727 := c',
          rir_reg% hty 701 := d', rir_reg% hty 768 := e', rir_reg% hty 742 := f',
          rir_reg% hty 716 := g', rir_reg% hty 690 := h', %102 := V, %103 := W,
          %141 := dd.add 16#64]) →
        BODY E' 639 S κ = R) :
    BODY E 535 S κ = R := by
  iterate 9 step_pure
  have hw : S.mem.readAt (W.add 160#64) 64 = Wf 20 := by
    first | exact hW 20 (by decide) | (rw [hS]; exact hW 20 (by decide))
  step_load consuming hw
  iterate 3 step_pure
  step_pure with t20 ht20
  step_pure with e21 he20
  iterate 10 step_pure
  step_pure with a21 ha20
  have hr20 : Sha512.round #v[a, b, c, d, e, f, g, h] Sha512.K[20]! (Wf 20) =
      #v[a21, a, b, c, e21, e, f, g] := by
    rw [ha20, he20, ht20]; exact round_eq4 ..
  clear ha20 he20 ht20
  iterate 9 step_pure
  have hw : S.mem.readAt (W.add 168#64) 64 = Wf 21 := by
    first | exact hW 21 (by decide) | (rw [hS]; exact hW 21 (by decide))
  step_load consuming hw
  iterate 3 step_pure
  step_pure with t21 ht21
  step_pure with e22 he21
  iterate 10 step_pure
  step_pure with a22 ha21
  have hr21 : Sha512.round #v[a21, a, b, c, e21, e, f, g] Sha512.K[21]! (Wf 21) =
      #v[a22, a21, a, b, e22, e21, e, f] := by
    rw [ha21, he21, ht21]; exact round_eq4 ..
  clear ha21 he21 ht21
  iterate 9 step_pure
  have hw : S.mem.readAt (W.add 176#64) 64 = Wf 22 := by
    first | exact hW 22 (by decide) | (rw [hS]; exact hW 22 (by decide))
  step_load consuming hw
  iterate 3 step_pure
  step_pure with t22 ht22
  step_pure with e23 he22
  iterate 10 step_pure
  step_pure with a23 ha22
  have hr22 : Sha512.round #v[a22, a21, a, b, e22, e21, e, f] Sha512.K[22]! (Wf 22) =
      #v[a23, a22, a21, a, e23, e22, e21, e] := by
    rw [ha22, he22, ht22]; exact round_eq4 ..
  clear ha22 he22 ht22
  iterate 9 step_pure
  have hw : S.mem.readAt (W.add 184#64) 64 = Wf 23 := by
    first | exact hW 23 (by decide) | (rw [hS]; exact hW 23 (by decide))
  step_load consuming hw
  iterate 3 step_pure
  step_pure with t23 ht23
  step_pure with e24 he23
  iterate 10 step_pure
  step_pure with a24 ha23
  have hr23 : Sha512.round #v[a23, a22, a21, a, e23, e22, e21, e] Sha512.K[23]! (Wf 23) =
      #v[a24, a23, a22, a21, e24, e23, e22, e21] := by
    rw [ha23, he23, ht23]; exact round_eq4 ..
  clear ha23 he23 ht23
  have hv : #v[a24, a23, a22, a21, e24, e23, e22, e21] = rounds Wf 20 4 #v[a, b, c, d, e, f, g, h] := by
    rw [rounds_succ, hr20, rounds_succ, hr21, rounds_succ, hr22, rounds_succ, hr23, rounds_zero]
  first | subst hS | skip
  exact hK E a24 a23 a22 a21 e24 e23 e22 e21 hv hArgs (by env_reads) (by env_reads)

set_option maxHeartbeats 0 in
/-- Rounds `24` to `27`. -/
theorem chunk24 (dd blk V W : Pointer) (Wf : Nat → BitVec 64) (a b c d e f g h : BitVec 64)
    (E : ⟪Γ⟫) (S : GlobalState) {β : Type} (κ : Vals [] × GlobalState → PoisonOr β)
    (R : PoisonOr β) (hArgs : E.args = (Sha512_round.args (.value dd) (.value blk)).get)
    (hc : Consts E)
    (hR : E ⊨ [rir_reg% hty 779 := a, rir_reg% hty 753 := b, rir_reg% hty 727 := c,
      rir_reg% hty 701 := d, rir_reg% hty 768 := e, rir_reg% hty 742 := f, rir_reg% hty 716 := g,
      rir_reg% hty 690 := h, %102 := V, %103 := W, %141 := dd.add 16#64])
    (hWo : W.offset = 0) (hWf : Fits S.mem W 5120)
    (hW : ∀ t, t < 80 → S.mem.readAt (W.add (BitVec.ofNat 64 (8 * t))) 64 = Wf t)
    (hK : ∀ (E' : ⟪Γ⟫) (a' b' c' d' e' f' g' h' : BitVec 64),
      #v[a', b', c', d', e', f', g', h'] = rounds Wf 24 4 #v[a, b, c, d, e, f, g, h] →
        E'.args = (Sha512_round.args (.value dd) (.value blk)).get → Consts E' →
        (E' ⊨ [rir_reg% hty 883 := a', rir_reg% hty 857 := b', rir_reg% hty 831 := c',
          rir_reg% hty 805 := d', rir_reg% hty 872 := e', rir_reg% hty 846 := f',
          rir_reg% hty 820 := g', rir_reg% hty 794 := h', %102 := V, %103 := W,
          %141 := dd.add 16#64]) →
        BODY E' 743 S κ = R) :
    BODY E 639 S κ = R := by
  iterate 9 step_pure
  have hw : S.mem.readAt (W.add 192#64) 64 = Wf 24 := by
    first | exact hW 24 (by decide) | (rw [hS]; exact hW 24 (by decide))
  step_load consuming hw
  iterate 3 step_pure
  step_pure with t24 ht24
  step_pure with e25 he24
  iterate 10 step_pure
  step_pure with a25 ha24
  have hr24 : Sha512.round #v[a, b, c, d, e, f, g, h] Sha512.K[24]! (Wf 24) =
      #v[a25, a, b, c, e25, e, f, g] := by
    rw [ha24, he24, ht24]; exact round_eq4 ..
  clear ha24 he24 ht24
  iterate 9 step_pure
  have hw : S.mem.readAt (W.add 200#64) 64 = Wf 25 := by
    first | exact hW 25 (by decide) | (rw [hS]; exact hW 25 (by decide))
  step_load consuming hw
  iterate 3 step_pure
  step_pure with t25 ht25
  step_pure with e26 he25
  iterate 10 step_pure
  step_pure with a26 ha25
  have hr25 : Sha512.round #v[a25, a, b, c, e25, e, f, g] Sha512.K[25]! (Wf 25) =
      #v[a26, a25, a, b, e26, e25, e, f] := by
    rw [ha25, he25, ht25]; exact round_eq4 ..
  clear ha25 he25 ht25
  iterate 9 step_pure
  have hw : S.mem.readAt (W.add 208#64) 64 = Wf 26 := by
    first | exact hW 26 (by decide) | (rw [hS]; exact hW 26 (by decide))
  step_load consuming hw
  iterate 3 step_pure
  step_pure with t26 ht26
  step_pure with e27 he26
  iterate 10 step_pure
  step_pure with a27 ha26
  have hr26 : Sha512.round #v[a26, a25, a, b, e26, e25, e, f] Sha512.K[26]! (Wf 26) =
      #v[a27, a26, a25, a, e27, e26, e25, e] := by
    rw [ha26, he26, ht26]; exact round_eq4 ..
  clear ha26 he26 ht26
  iterate 9 step_pure
  have hw : S.mem.readAt (W.add 216#64) 64 = Wf 27 := by
    first | exact hW 27 (by decide) | (rw [hS]; exact hW 27 (by decide))
  step_load consuming hw
  iterate 3 step_pure
  step_pure with t27 ht27
  step_pure with e28 he27
  iterate 10 step_pure
  step_pure with a28 ha27
  have hr27 : Sha512.round #v[a27, a26, a25, a, e27, e26, e25, e] Sha512.K[27]! (Wf 27) =
      #v[a28, a27, a26, a25, e28, e27, e26, e25] := by
    rw [ha27, he27, ht27]; exact round_eq4 ..
  clear ha27 he27 ht27
  have hv : #v[a28, a27, a26, a25, e28, e27, e26, e25] = rounds Wf 24 4 #v[a, b, c, d, e, f, g, h] := by
    rw [rounds_succ, hr24, rounds_succ, hr25, rounds_succ, hr26, rounds_succ, hr27, rounds_zero]
  first | subst hS | skip
  exact hK E a28 a27 a26 a25 e28 e27 e26 e25 hv hArgs (by env_reads) (by env_reads)

set_option maxHeartbeats 0 in
/-- Rounds `28` to `31`. -/
theorem chunk28 (dd blk V W : Pointer) (Wf : Nat → BitVec 64) (a b c d e f g h : BitVec 64)
    (E : ⟪Γ⟫) (S : GlobalState) {β : Type} (κ : Vals [] × GlobalState → PoisonOr β)
    (R : PoisonOr β) (hArgs : E.args = (Sha512_round.args (.value dd) (.value blk)).get)
    (hc : Consts E)
    (hR : E ⊨ [rir_reg% hty 883 := a, rir_reg% hty 857 := b, rir_reg% hty 831 := c,
      rir_reg% hty 805 := d, rir_reg% hty 872 := e, rir_reg% hty 846 := f, rir_reg% hty 820 := g,
      rir_reg% hty 794 := h, %102 := V, %103 := W, %141 := dd.add 16#64])
    (hWo : W.offset = 0) (hWf : Fits S.mem W 5120)
    (hW : ∀ t, t < 80 → S.mem.readAt (W.add (BitVec.ofNat 64 (8 * t))) 64 = Wf t)
    (hK : ∀ (E' : ⟪Γ⟫) (a' b' c' d' e' f' g' h' : BitVec 64),
      #v[a', b', c', d', e', f', g', h'] = rounds Wf 28 4 #v[a, b, c, d, e, f, g, h] →
        E'.args = (Sha512_round.args (.value dd) (.value blk)).get → Consts E' →
        (E' ⊨ [rir_reg% hty 987 := a', rir_reg% hty 961 := b', rir_reg% hty 935 := c',
          rir_reg% hty 909 := d', rir_reg% hty 976 := e', rir_reg% hty 950 := f',
          rir_reg% hty 924 := g', rir_reg% hty 898 := h', %102 := V, %103 := W,
          %141 := dd.add 16#64]) →
        BODY E' 847 S κ = R) :
    BODY E 743 S κ = R := by
  iterate 9 step_pure
  have hw : S.mem.readAt (W.add 224#64) 64 = Wf 28 := by
    first | exact hW 28 (by decide) | (rw [hS]; exact hW 28 (by decide))
  step_load consuming hw
  iterate 3 step_pure
  step_pure with t28 ht28
  step_pure with e29 he28
  iterate 10 step_pure
  step_pure with a29 ha28
  have hr28 : Sha512.round #v[a, b, c, d, e, f, g, h] Sha512.K[28]! (Wf 28) =
      #v[a29, a, b, c, e29, e, f, g] := by
    rw [ha28, he28, ht28]; exact round_eq4 ..
  clear ha28 he28 ht28
  iterate 9 step_pure
  have hw : S.mem.readAt (W.add 232#64) 64 = Wf 29 := by
    first | exact hW 29 (by decide) | (rw [hS]; exact hW 29 (by decide))
  step_load consuming hw
  iterate 3 step_pure
  step_pure with t29 ht29
  step_pure with e30 he29
  iterate 10 step_pure
  step_pure with a30 ha29
  have hr29 : Sha512.round #v[a29, a, b, c, e29, e, f, g] Sha512.K[29]! (Wf 29) =
      #v[a30, a29, a, b, e30, e29, e, f] := by
    rw [ha29, he29, ht29]; exact round_eq4 ..
  clear ha29 he29 ht29
  iterate 9 step_pure
  have hw : S.mem.readAt (W.add 240#64) 64 = Wf 30 := by
    first | exact hW 30 (by decide) | (rw [hS]; exact hW 30 (by decide))
  step_load consuming hw
  iterate 3 step_pure
  step_pure with t30 ht30
  step_pure with e31 he30
  iterate 10 step_pure
  step_pure with a31 ha30
  have hr30 : Sha512.round #v[a30, a29, a, b, e30, e29, e, f] Sha512.K[30]! (Wf 30) =
      #v[a31, a30, a29, a, e31, e30, e29, e] := by
    rw [ha30, he30, ht30]; exact round_eq4 ..
  clear ha30 he30 ht30
  iterate 9 step_pure
  have hw : S.mem.readAt (W.add 248#64) 64 = Wf 31 := by
    first | exact hW 31 (by decide) | (rw [hS]; exact hW 31 (by decide))
  step_load consuming hw
  iterate 3 step_pure
  step_pure with t31 ht31
  step_pure with e32 he31
  iterate 10 step_pure
  step_pure with a32 ha31
  have hr31 : Sha512.round #v[a31, a30, a29, a, e31, e30, e29, e] Sha512.K[31]! (Wf 31) =
      #v[a32, a31, a30, a29, e32, e31, e30, e29] := by
    rw [ha31, he31, ht31]; exact round_eq4 ..
  clear ha31 he31 ht31
  have hv : #v[a32, a31, a30, a29, e32, e31, e30, e29] = rounds Wf 28 4 #v[a, b, c, d, e, f, g, h] := by
    rw [rounds_succ, hr28, rounds_succ, hr29, rounds_succ, hr30, rounds_succ, hr31, rounds_zero]
  first | subst hS | skip
  exact hK E a32 a31 a30 a29 e32 e31 e30 e29 hv hArgs (by env_reads) (by env_reads)

set_option maxHeartbeats 0 in
/-- Rounds `32` to `35`. -/
theorem chunk32 (dd blk V W : Pointer) (Wf : Nat → BitVec 64) (a b c d e f g h : BitVec 64)
    (E : ⟪Γ⟫) (S : GlobalState) {β : Type} (κ : Vals [] × GlobalState → PoisonOr β)
    (R : PoisonOr β) (hArgs : E.args = (Sha512_round.args (.value dd) (.value blk)).get)
    (hc : Consts E)
    (hR : E ⊨ [rir_reg% hty 987 := a, rir_reg% hty 961 := b, rir_reg% hty 935 := c,
      rir_reg% hty 909 := d, rir_reg% hty 976 := e, rir_reg% hty 950 := f, rir_reg% hty 924 := g,
      rir_reg% hty 898 := h, %102 := V, %103 := W, %141 := dd.add 16#64])
    (hWo : W.offset = 0) (hWf : Fits S.mem W 5120)
    (hW : ∀ t, t < 80 → S.mem.readAt (W.add (BitVec.ofNat 64 (8 * t))) 64 = Wf t)
    (hK : ∀ (E' : ⟪Γ⟫) (a' b' c' d' e' f' g' h' : BitVec 64),
      #v[a', b', c', d', e', f', g', h'] = rounds Wf 32 4 #v[a, b, c, d, e, f, g, h] →
        E'.args = (Sha512_round.args (.value dd) (.value blk)).get → Consts E' →
        (E' ⊨ [rir_reg% hty 1091 := a', rir_reg% hty 1065 := b', rir_reg% hty 1039 := c',
          rir_reg% hty 1013 := d', rir_reg% hty 1080 := e', rir_reg% hty 1054 := f',
          rir_reg% hty 1028 := g', rir_reg% hty 1002 := h', %102 := V, %103 := W,
          %141 := dd.add 16#64]) →
        BODY E' 951 S κ = R) :
    BODY E 847 S κ = R := by
  iterate 9 step_pure
  have hw : S.mem.readAt (W.add 256#64) 64 = Wf 32 := by
    first | exact hW 32 (by decide) | (rw [hS]; exact hW 32 (by decide))
  step_load consuming hw
  iterate 3 step_pure
  step_pure with t32 ht32
  step_pure with e33 he32
  iterate 10 step_pure
  step_pure with a33 ha32
  have hr32 : Sha512.round #v[a, b, c, d, e, f, g, h] Sha512.K[32]! (Wf 32) =
      #v[a33, a, b, c, e33, e, f, g] := by
    rw [ha32, he32, ht32]; exact round_eq4 ..
  clear ha32 he32 ht32
  iterate 9 step_pure
  have hw : S.mem.readAt (W.add 264#64) 64 = Wf 33 := by
    first | exact hW 33 (by decide) | (rw [hS]; exact hW 33 (by decide))
  step_load consuming hw
  iterate 3 step_pure
  step_pure with t33 ht33
  step_pure with e34 he33
  iterate 10 step_pure
  step_pure with a34 ha33
  have hr33 : Sha512.round #v[a33, a, b, c, e33, e, f, g] Sha512.K[33]! (Wf 33) =
      #v[a34, a33, a, b, e34, e33, e, f] := by
    rw [ha33, he33, ht33]; exact round_eq4 ..
  clear ha33 he33 ht33
  iterate 9 step_pure
  have hw : S.mem.readAt (W.add 272#64) 64 = Wf 34 := by
    first | exact hW 34 (by decide) | (rw [hS]; exact hW 34 (by decide))
  step_load consuming hw
  iterate 3 step_pure
  step_pure with t34 ht34
  step_pure with e35 he34
  iterate 10 step_pure
  step_pure with a35 ha34
  have hr34 : Sha512.round #v[a34, a33, a, b, e34, e33, e, f] Sha512.K[34]! (Wf 34) =
      #v[a35, a34, a33, a, e35, e34, e33, e] := by
    rw [ha34, he34, ht34]; exact round_eq4 ..
  clear ha34 he34 ht34
  iterate 9 step_pure
  have hw : S.mem.readAt (W.add 280#64) 64 = Wf 35 := by
    first | exact hW 35 (by decide) | (rw [hS]; exact hW 35 (by decide))
  step_load consuming hw
  iterate 3 step_pure
  step_pure with t35 ht35
  step_pure with e36 he35
  iterate 10 step_pure
  step_pure with a36 ha35
  have hr35 : Sha512.round #v[a35, a34, a33, a, e35, e34, e33, e] Sha512.K[35]! (Wf 35) =
      #v[a36, a35, a34, a33, e36, e35, e34, e33] := by
    rw [ha35, he35, ht35]; exact round_eq4 ..
  clear ha35 he35 ht35
  have hv : #v[a36, a35, a34, a33, e36, e35, e34, e33] = rounds Wf 32 4 #v[a, b, c, d, e, f, g, h] := by
    rw [rounds_succ, hr32, rounds_succ, hr33, rounds_succ, hr34, rounds_succ, hr35, rounds_zero]
  first | subst hS | skip
  exact hK E a36 a35 a34 a33 e36 e35 e34 e33 hv hArgs (by env_reads) (by env_reads)

set_option maxHeartbeats 0 in
/-- Rounds `36` to `39`. -/
theorem chunk36 (dd blk V W : Pointer) (Wf : Nat → BitVec 64) (a b c d e f g h : BitVec 64)
    (E : ⟪Γ⟫) (S : GlobalState) {β : Type} (κ : Vals [] × GlobalState → PoisonOr β)
    (R : PoisonOr β) (hArgs : E.args = (Sha512_round.args (.value dd) (.value blk)).get)
    (hc : Consts E)
    (hR : E ⊨ [rir_reg% hty 1091 := a, rir_reg% hty 1065 := b, rir_reg% hty 1039 := c,
      rir_reg% hty 1013 := d, rir_reg% hty 1080 := e, rir_reg% hty 1054 := f,
      rir_reg% hty 1028 := g, rir_reg% hty 1002 := h, %102 := V, %103 := W, %141 := dd.add 16#64])
    (hWo : W.offset = 0) (hWf : Fits S.mem W 5120)
    (hW : ∀ t, t < 80 → S.mem.readAt (W.add (BitVec.ofNat 64 (8 * t))) 64 = Wf t)
    (hK : ∀ (E' : ⟪Γ⟫) (a' b' c' d' e' f' g' h' : BitVec 64),
      #v[a', b', c', d', e', f', g', h'] = rounds Wf 36 4 #v[a, b, c, d, e, f, g, h] →
        E'.args = (Sha512_round.args (.value dd) (.value blk)).get → Consts E' →
        (E' ⊨ [rir_reg% hty 1195 := a', rir_reg% hty 1169 := b', rir_reg% hty 1143 := c',
          rir_reg% hty 1117 := d', rir_reg% hty 1184 := e', rir_reg% hty 1158 := f',
          rir_reg% hty 1132 := g', rir_reg% hty 1106 := h', %102 := V, %103 := W,
          %141 := dd.add 16#64]) →
        BODY E' 1055 S κ = R) :
    BODY E 951 S κ = R := by
  iterate 9 step_pure
  have hw : S.mem.readAt (W.add 288#64) 64 = Wf 36 := by
    first | exact hW 36 (by decide) | (rw [hS]; exact hW 36 (by decide))
  step_load consuming hw
  iterate 3 step_pure
  step_pure with t36 ht36
  step_pure with e37 he36
  iterate 10 step_pure
  step_pure with a37 ha36
  have hr36 : Sha512.round #v[a, b, c, d, e, f, g, h] Sha512.K[36]! (Wf 36) =
      #v[a37, a, b, c, e37, e, f, g] := by
    rw [ha36, he36, ht36]; exact round_eq4 ..
  clear ha36 he36 ht36
  iterate 9 step_pure
  have hw : S.mem.readAt (W.add 296#64) 64 = Wf 37 := by
    first | exact hW 37 (by decide) | (rw [hS]; exact hW 37 (by decide))
  step_load consuming hw
  iterate 3 step_pure
  step_pure with t37 ht37
  step_pure with e38 he37
  iterate 10 step_pure
  step_pure with a38 ha37
  have hr37 : Sha512.round #v[a37, a, b, c, e37, e, f, g] Sha512.K[37]! (Wf 37) =
      #v[a38, a37, a, b, e38, e37, e, f] := by
    rw [ha37, he37, ht37]; exact round_eq4 ..
  clear ha37 he37 ht37
  iterate 9 step_pure
  have hw : S.mem.readAt (W.add 304#64) 64 = Wf 38 := by
    first | exact hW 38 (by decide) | (rw [hS]; exact hW 38 (by decide))
  step_load consuming hw
  iterate 3 step_pure
  step_pure with t38 ht38
  step_pure with e39 he38
  iterate 10 step_pure
  step_pure with a39 ha38
  have hr38 : Sha512.round #v[a38, a37, a, b, e38, e37, e, f] Sha512.K[38]! (Wf 38) =
      #v[a39, a38, a37, a, e39, e38, e37, e] := by
    rw [ha38, he38, ht38]; exact round_eq4 ..
  clear ha38 he38 ht38
  iterate 9 step_pure
  have hw : S.mem.readAt (W.add 312#64) 64 = Wf 39 := by
    first | exact hW 39 (by decide) | (rw [hS]; exact hW 39 (by decide))
  step_load consuming hw
  iterate 3 step_pure
  step_pure with t39 ht39
  step_pure with e40 he39
  iterate 10 step_pure
  step_pure with a40 ha39
  have hr39 : Sha512.round #v[a39, a38, a37, a, e39, e38, e37, e] Sha512.K[39]! (Wf 39) =
      #v[a40, a39, a38, a37, e40, e39, e38, e37] := by
    rw [ha39, he39, ht39]; exact round_eq4 ..
  clear ha39 he39 ht39
  have hv : #v[a40, a39, a38, a37, e40, e39, e38, e37] = rounds Wf 36 4 #v[a, b, c, d, e, f, g, h] := by
    rw [rounds_succ, hr36, rounds_succ, hr37, rounds_succ, hr38, rounds_succ, hr39, rounds_zero]
  first | subst hS | skip
  exact hK E a40 a39 a38 a37 e40 e39 e38 e37 hv hArgs (by env_reads) (by env_reads)

set_option maxHeartbeats 0 in
/-- Rounds `40` to `43`. -/
theorem chunk40 (dd blk V W : Pointer) (Wf : Nat → BitVec 64) (a b c d e f g h : BitVec 64)
    (E : ⟪Γ⟫) (S : GlobalState) {β : Type} (κ : Vals [] × GlobalState → PoisonOr β)
    (R : PoisonOr β) (hArgs : E.args = (Sha512_round.args (.value dd) (.value blk)).get)
    (hc : Consts E)
    (hR : E ⊨ [rir_reg% hty 1195 := a, rir_reg% hty 1169 := b, rir_reg% hty 1143 := c,
      rir_reg% hty 1117 := d, rir_reg% hty 1184 := e, rir_reg% hty 1158 := f,
      rir_reg% hty 1132 := g, rir_reg% hty 1106 := h, %102 := V, %103 := W, %141 := dd.add 16#64])
    (hWo : W.offset = 0) (hWf : Fits S.mem W 5120)
    (hW : ∀ t, t < 80 → S.mem.readAt (W.add (BitVec.ofNat 64 (8 * t))) 64 = Wf t)
    (hK : ∀ (E' : ⟪Γ⟫) (a' b' c' d' e' f' g' h' : BitVec 64),
      #v[a', b', c', d', e', f', g', h'] = rounds Wf 40 4 #v[a, b, c, d, e, f, g, h] →
        E'.args = (Sha512_round.args (.value dd) (.value blk)).get → Consts E' →
        (E' ⊨ [rir_reg% hty 1299 := a', rir_reg% hty 1273 := b', rir_reg% hty 1247 := c',
          rir_reg% hty 1221 := d', rir_reg% hty 1288 := e', rir_reg% hty 1262 := f',
          rir_reg% hty 1236 := g', rir_reg% hty 1210 := h', %102 := V, %103 := W,
          %141 := dd.add 16#64]) →
        BODY E' 1159 S κ = R) :
    BODY E 1055 S κ = R := by
  iterate 9 step_pure
  have hw : S.mem.readAt (W.add 320#64) 64 = Wf 40 := by
    first | exact hW 40 (by decide) | (rw [hS]; exact hW 40 (by decide))
  step_load consuming hw
  iterate 3 step_pure
  step_pure with t40 ht40
  step_pure with e41 he40
  iterate 10 step_pure
  step_pure with a41 ha40
  have hr40 : Sha512.round #v[a, b, c, d, e, f, g, h] Sha512.K[40]! (Wf 40) =
      #v[a41, a, b, c, e41, e, f, g] := by
    rw [ha40, he40, ht40]; exact round_eq4 ..
  clear ha40 he40 ht40
  iterate 9 step_pure
  have hw : S.mem.readAt (W.add 328#64) 64 = Wf 41 := by
    first | exact hW 41 (by decide) | (rw [hS]; exact hW 41 (by decide))
  step_load consuming hw
  iterate 3 step_pure
  step_pure with t41 ht41
  step_pure with e42 he41
  iterate 10 step_pure
  step_pure with a42 ha41
  have hr41 : Sha512.round #v[a41, a, b, c, e41, e, f, g] Sha512.K[41]! (Wf 41) =
      #v[a42, a41, a, b, e42, e41, e, f] := by
    rw [ha41, he41, ht41]; exact round_eq4 ..
  clear ha41 he41 ht41
  iterate 9 step_pure
  have hw : S.mem.readAt (W.add 336#64) 64 = Wf 42 := by
    first | exact hW 42 (by decide) | (rw [hS]; exact hW 42 (by decide))
  step_load consuming hw
  iterate 3 step_pure
  step_pure with t42 ht42
  step_pure with e43 he42
  iterate 10 step_pure
  step_pure with a43 ha42
  have hr42 : Sha512.round #v[a42, a41, a, b, e42, e41, e, f] Sha512.K[42]! (Wf 42) =
      #v[a43, a42, a41, a, e43, e42, e41, e] := by
    rw [ha42, he42, ht42]; exact round_eq4 ..
  clear ha42 he42 ht42
  iterate 9 step_pure
  have hw : S.mem.readAt (W.add 344#64) 64 = Wf 43 := by
    first | exact hW 43 (by decide) | (rw [hS]; exact hW 43 (by decide))
  step_load consuming hw
  iterate 3 step_pure
  step_pure with t43 ht43
  step_pure with e44 he43
  iterate 10 step_pure
  step_pure with a44 ha43
  have hr43 : Sha512.round #v[a43, a42, a41, a, e43, e42, e41, e] Sha512.K[43]! (Wf 43) =
      #v[a44, a43, a42, a41, e44, e43, e42, e41] := by
    rw [ha43, he43, ht43]; exact round_eq4 ..
  clear ha43 he43 ht43
  have hv : #v[a44, a43, a42, a41, e44, e43, e42, e41] = rounds Wf 40 4 #v[a, b, c, d, e, f, g, h] := by
    rw [rounds_succ, hr40, rounds_succ, hr41, rounds_succ, hr42, rounds_succ, hr43, rounds_zero]
  first | subst hS | skip
  exact hK E a44 a43 a42 a41 e44 e43 e42 e41 hv hArgs (by env_reads) (by env_reads)

set_option maxHeartbeats 0 in
/-- Rounds `44` to `47`. -/
theorem chunk44 (dd blk V W : Pointer) (Wf : Nat → BitVec 64) (a b c d e f g h : BitVec 64)
    (E : ⟪Γ⟫) (S : GlobalState) {β : Type} (κ : Vals [] × GlobalState → PoisonOr β)
    (R : PoisonOr β) (hArgs : E.args = (Sha512_round.args (.value dd) (.value blk)).get)
    (hc : Consts E)
    (hR : E ⊨ [rir_reg% hty 1299 := a, rir_reg% hty 1273 := b, rir_reg% hty 1247 := c,
      rir_reg% hty 1221 := d, rir_reg% hty 1288 := e, rir_reg% hty 1262 := f,
      rir_reg% hty 1236 := g, rir_reg% hty 1210 := h, %102 := V, %103 := W, %141 := dd.add 16#64])
    (hWo : W.offset = 0) (hWf : Fits S.mem W 5120)
    (hW : ∀ t, t < 80 → S.mem.readAt (W.add (BitVec.ofNat 64 (8 * t))) 64 = Wf t)
    (hK : ∀ (E' : ⟪Γ⟫) (a' b' c' d' e' f' g' h' : BitVec 64),
      #v[a', b', c', d', e', f', g', h'] = rounds Wf 44 4 #v[a, b, c, d, e, f, g, h] →
        E'.args = (Sha512_round.args (.value dd) (.value blk)).get → Consts E' →
        (E' ⊨ [rir_reg% hty 1403 := a', rir_reg% hty 1377 := b', rir_reg% hty 1351 := c',
          rir_reg% hty 1325 := d', rir_reg% hty 1392 := e', rir_reg% hty 1366 := f',
          rir_reg% hty 1340 := g', rir_reg% hty 1314 := h', %102 := V, %103 := W,
          %141 := dd.add 16#64]) →
        BODY E' 1263 S κ = R) :
    BODY E 1159 S κ = R := by
  iterate 9 step_pure
  have hw : S.mem.readAt (W.add 352#64) 64 = Wf 44 := by
    first | exact hW 44 (by decide) | (rw [hS]; exact hW 44 (by decide))
  step_load consuming hw
  iterate 3 step_pure
  step_pure with t44 ht44
  step_pure with e45 he44
  iterate 10 step_pure
  step_pure with a45 ha44
  have hr44 : Sha512.round #v[a, b, c, d, e, f, g, h] Sha512.K[44]! (Wf 44) =
      #v[a45, a, b, c, e45, e, f, g] := by
    rw [ha44, he44, ht44]; exact round_eq4 ..
  clear ha44 he44 ht44
  iterate 9 step_pure
  have hw : S.mem.readAt (W.add 360#64) 64 = Wf 45 := by
    first | exact hW 45 (by decide) | (rw [hS]; exact hW 45 (by decide))
  step_load consuming hw
  iterate 3 step_pure
  step_pure with t45 ht45
  step_pure with e46 he45
  iterate 10 step_pure
  step_pure with a46 ha45
  have hr45 : Sha512.round #v[a45, a, b, c, e45, e, f, g] Sha512.K[45]! (Wf 45) =
      #v[a46, a45, a, b, e46, e45, e, f] := by
    rw [ha45, he45, ht45]; exact round_eq4 ..
  clear ha45 he45 ht45
  iterate 9 step_pure
  have hw : S.mem.readAt (W.add 368#64) 64 = Wf 46 := by
    first | exact hW 46 (by decide) | (rw [hS]; exact hW 46 (by decide))
  step_load consuming hw
  iterate 3 step_pure
  step_pure with t46 ht46
  step_pure with e47 he46
  iterate 10 step_pure
  step_pure with a47 ha46
  have hr46 : Sha512.round #v[a46, a45, a, b, e46, e45, e, f] Sha512.K[46]! (Wf 46) =
      #v[a47, a46, a45, a, e47, e46, e45, e] := by
    rw [ha46, he46, ht46]; exact round_eq4 ..
  clear ha46 he46 ht46
  iterate 9 step_pure
  have hw : S.mem.readAt (W.add 376#64) 64 = Wf 47 := by
    first | exact hW 47 (by decide) | (rw [hS]; exact hW 47 (by decide))
  step_load consuming hw
  iterate 3 step_pure
  step_pure with t47 ht47
  step_pure with e48 he47
  iterate 10 step_pure
  step_pure with a48 ha47
  have hr47 : Sha512.round #v[a47, a46, a45, a, e47, e46, e45, e] Sha512.K[47]! (Wf 47) =
      #v[a48, a47, a46, a45, e48, e47, e46, e45] := by
    rw [ha47, he47, ht47]; exact round_eq4 ..
  clear ha47 he47 ht47
  have hv : #v[a48, a47, a46, a45, e48, e47, e46, e45] = rounds Wf 44 4 #v[a, b, c, d, e, f, g, h] := by
    rw [rounds_succ, hr44, rounds_succ, hr45, rounds_succ, hr46, rounds_succ, hr47, rounds_zero]
  first | subst hS | skip
  exact hK E a48 a47 a46 a45 e48 e47 e46 e45 hv hArgs (by env_reads) (by env_reads)

set_option maxHeartbeats 0 in
/-- Rounds `48` to `51`. -/
theorem chunk48 (dd blk V W : Pointer) (Wf : Nat → BitVec 64) (a b c d e f g h : BitVec 64)
    (E : ⟪Γ⟫) (S : GlobalState) {β : Type} (κ : Vals [] × GlobalState → PoisonOr β)
    (R : PoisonOr β) (hArgs : E.args = (Sha512_round.args (.value dd) (.value blk)).get)
    (hc : Consts E)
    (hR : E ⊨ [rir_reg% hty 1403 := a, rir_reg% hty 1377 := b, rir_reg% hty 1351 := c,
      rir_reg% hty 1325 := d, rir_reg% hty 1392 := e, rir_reg% hty 1366 := f,
      rir_reg% hty 1340 := g, rir_reg% hty 1314 := h, %102 := V, %103 := W, %141 := dd.add 16#64])
    (hWo : W.offset = 0) (hWf : Fits S.mem W 5120)
    (hW : ∀ t, t < 80 → S.mem.readAt (W.add (BitVec.ofNat 64 (8 * t))) 64 = Wf t)
    (hK : ∀ (E' : ⟪Γ⟫) (a' b' c' d' e' f' g' h' : BitVec 64),
      #v[a', b', c', d', e', f', g', h'] = rounds Wf 48 4 #v[a, b, c, d, e, f, g, h] →
        E'.args = (Sha512_round.args (.value dd) (.value blk)).get → Consts E' →
        (E' ⊨ [rir_reg% hty 1507 := a', rir_reg% hty 1481 := b', rir_reg% hty 1455 := c',
          rir_reg% hty 1429 := d', rir_reg% hty 1496 := e', rir_reg% hty 1470 := f',
          rir_reg% hty 1444 := g', rir_reg% hty 1418 := h', %102 := V, %103 := W,
          %141 := dd.add 16#64]) →
        BODY E' 1367 S κ = R) :
    BODY E 1263 S κ = R := by
  iterate 9 step_pure
  have hw : S.mem.readAt (W.add 384#64) 64 = Wf 48 := by
    first | exact hW 48 (by decide) | (rw [hS]; exact hW 48 (by decide))
  step_load consuming hw
  iterate 3 step_pure
  step_pure with t48 ht48
  step_pure with e49 he48
  iterate 10 step_pure
  step_pure with a49 ha48
  have hr48 : Sha512.round #v[a, b, c, d, e, f, g, h] Sha512.K[48]! (Wf 48) =
      #v[a49, a, b, c, e49, e, f, g] := by
    rw [ha48, he48, ht48]; exact round_eq4 ..
  clear ha48 he48 ht48
  iterate 9 step_pure
  have hw : S.mem.readAt (W.add 392#64) 64 = Wf 49 := by
    first | exact hW 49 (by decide) | (rw [hS]; exact hW 49 (by decide))
  step_load consuming hw
  iterate 3 step_pure
  step_pure with t49 ht49
  step_pure with e50 he49
  iterate 10 step_pure
  step_pure with a50 ha49
  have hr49 : Sha512.round #v[a49, a, b, c, e49, e, f, g] Sha512.K[49]! (Wf 49) =
      #v[a50, a49, a, b, e50, e49, e, f] := by
    rw [ha49, he49, ht49]; exact round_eq4 ..
  clear ha49 he49 ht49
  iterate 9 step_pure
  have hw : S.mem.readAt (W.add 400#64) 64 = Wf 50 := by
    first | exact hW 50 (by decide) | (rw [hS]; exact hW 50 (by decide))
  step_load consuming hw
  iterate 3 step_pure
  step_pure with t50 ht50
  step_pure with e51 he50
  iterate 10 step_pure
  step_pure with a51 ha50
  have hr50 : Sha512.round #v[a50, a49, a, b, e50, e49, e, f] Sha512.K[50]! (Wf 50) =
      #v[a51, a50, a49, a, e51, e50, e49, e] := by
    rw [ha50, he50, ht50]; exact round_eq4 ..
  clear ha50 he50 ht50
  iterate 9 step_pure
  have hw : S.mem.readAt (W.add 408#64) 64 = Wf 51 := by
    first | exact hW 51 (by decide) | (rw [hS]; exact hW 51 (by decide))
  step_load consuming hw
  iterate 3 step_pure
  step_pure with t51 ht51
  step_pure with e52 he51
  iterate 10 step_pure
  step_pure with a52 ha51
  have hr51 : Sha512.round #v[a51, a50, a49, a, e51, e50, e49, e] Sha512.K[51]! (Wf 51) =
      #v[a52, a51, a50, a49, e52, e51, e50, e49] := by
    rw [ha51, he51, ht51]; exact round_eq4 ..
  clear ha51 he51 ht51
  have hv : #v[a52, a51, a50, a49, e52, e51, e50, e49] = rounds Wf 48 4 #v[a, b, c, d, e, f, g, h] := by
    rw [rounds_succ, hr48, rounds_succ, hr49, rounds_succ, hr50, rounds_succ, hr51, rounds_zero]
  first | subst hS | skip
  exact hK E a52 a51 a50 a49 e52 e51 e50 e49 hv hArgs (by env_reads) (by env_reads)

set_option maxHeartbeats 0 in
/-- Rounds `52` to `55`. -/
theorem chunk52 (dd blk V W : Pointer) (Wf : Nat → BitVec 64) (a b c d e f g h : BitVec 64)
    (E : ⟪Γ⟫) (S : GlobalState) {β : Type} (κ : Vals [] × GlobalState → PoisonOr β)
    (R : PoisonOr β) (hArgs : E.args = (Sha512_round.args (.value dd) (.value blk)).get)
    (hc : Consts E)
    (hR : E ⊨ [rir_reg% hty 1507 := a, rir_reg% hty 1481 := b, rir_reg% hty 1455 := c,
      rir_reg% hty 1429 := d, rir_reg% hty 1496 := e, rir_reg% hty 1470 := f,
      rir_reg% hty 1444 := g, rir_reg% hty 1418 := h, %102 := V, %103 := W, %141 := dd.add 16#64])
    (hWo : W.offset = 0) (hWf : Fits S.mem W 5120)
    (hW : ∀ t, t < 80 → S.mem.readAt (W.add (BitVec.ofNat 64 (8 * t))) 64 = Wf t)
    (hK : ∀ (E' : ⟪Γ⟫) (a' b' c' d' e' f' g' h' : BitVec 64),
      #v[a', b', c', d', e', f', g', h'] = rounds Wf 52 4 #v[a, b, c, d, e, f, g, h] →
        E'.args = (Sha512_round.args (.value dd) (.value blk)).get → Consts E' →
        (E' ⊨ [rir_reg% hty 1611 := a', rir_reg% hty 1585 := b', rir_reg% hty 1559 := c',
          rir_reg% hty 1533 := d', rir_reg% hty 1600 := e', rir_reg% hty 1574 := f',
          rir_reg% hty 1548 := g', rir_reg% hty 1522 := h', %102 := V, %103 := W,
          %141 := dd.add 16#64]) →
        BODY E' 1471 S κ = R) :
    BODY E 1367 S κ = R := by
  iterate 9 step_pure
  have hw : S.mem.readAt (W.add 416#64) 64 = Wf 52 := by
    first | exact hW 52 (by decide) | (rw [hS]; exact hW 52 (by decide))
  step_load consuming hw
  iterate 3 step_pure
  step_pure with t52 ht52
  step_pure with e53 he52
  iterate 10 step_pure
  step_pure with a53 ha52
  have hr52 : Sha512.round #v[a, b, c, d, e, f, g, h] Sha512.K[52]! (Wf 52) =
      #v[a53, a, b, c, e53, e, f, g] := by
    rw [ha52, he52, ht52]; exact round_eq4 ..
  clear ha52 he52 ht52
  iterate 9 step_pure
  have hw : S.mem.readAt (W.add 424#64) 64 = Wf 53 := by
    first | exact hW 53 (by decide) | (rw [hS]; exact hW 53 (by decide))
  step_load consuming hw
  iterate 3 step_pure
  step_pure with t53 ht53
  step_pure with e54 he53
  iterate 10 step_pure
  step_pure with a54 ha53
  have hr53 : Sha512.round #v[a53, a, b, c, e53, e, f, g] Sha512.K[53]! (Wf 53) =
      #v[a54, a53, a, b, e54, e53, e, f] := by
    rw [ha53, he53, ht53]; exact round_eq4 ..
  clear ha53 he53 ht53
  iterate 9 step_pure
  have hw : S.mem.readAt (W.add 432#64) 64 = Wf 54 := by
    first | exact hW 54 (by decide) | (rw [hS]; exact hW 54 (by decide))
  step_load consuming hw
  iterate 3 step_pure
  step_pure with t54 ht54
  step_pure with e55 he54
  iterate 10 step_pure
  step_pure with a55 ha54
  have hr54 : Sha512.round #v[a54, a53, a, b, e54, e53, e, f] Sha512.K[54]! (Wf 54) =
      #v[a55, a54, a53, a, e55, e54, e53, e] := by
    rw [ha54, he54, ht54]; exact round_eq4 ..
  clear ha54 he54 ht54
  iterate 9 step_pure
  have hw : S.mem.readAt (W.add 440#64) 64 = Wf 55 := by
    first | exact hW 55 (by decide) | (rw [hS]; exact hW 55 (by decide))
  step_load consuming hw
  iterate 3 step_pure
  step_pure with t55 ht55
  step_pure with e56 he55
  iterate 10 step_pure
  step_pure with a56 ha55
  have hr55 : Sha512.round #v[a55, a54, a53, a, e55, e54, e53, e] Sha512.K[55]! (Wf 55) =
      #v[a56, a55, a54, a53, e56, e55, e54, e53] := by
    rw [ha55, he55, ht55]; exact round_eq4 ..
  clear ha55 he55 ht55
  have hv : #v[a56, a55, a54, a53, e56, e55, e54, e53] = rounds Wf 52 4 #v[a, b, c, d, e, f, g, h] := by
    rw [rounds_succ, hr52, rounds_succ, hr53, rounds_succ, hr54, rounds_succ, hr55, rounds_zero]
  first | subst hS | skip
  exact hK E a56 a55 a54 a53 e56 e55 e54 e53 hv hArgs (by env_reads) (by env_reads)

set_option maxHeartbeats 0 in
/-- Rounds `56` to `59`. -/
theorem chunk56 (dd blk V W : Pointer) (Wf : Nat → BitVec 64) (a b c d e f g h : BitVec 64)
    (E : ⟪Γ⟫) (S : GlobalState) {β : Type} (κ : Vals [] × GlobalState → PoisonOr β)
    (R : PoisonOr β) (hArgs : E.args = (Sha512_round.args (.value dd) (.value blk)).get)
    (hc : Consts E)
    (hR : E ⊨ [rir_reg% hty 1611 := a, rir_reg% hty 1585 := b, rir_reg% hty 1559 := c,
      rir_reg% hty 1533 := d, rir_reg% hty 1600 := e, rir_reg% hty 1574 := f,
      rir_reg% hty 1548 := g, rir_reg% hty 1522 := h, %102 := V, %103 := W, %141 := dd.add 16#64])
    (hWo : W.offset = 0) (hWf : Fits S.mem W 5120)
    (hW : ∀ t, t < 80 → S.mem.readAt (W.add (BitVec.ofNat 64 (8 * t))) 64 = Wf t)
    (hK : ∀ (E' : ⟪Γ⟫) (a' b' c' d' e' f' g' h' : BitVec 64),
      #v[a', b', c', d', e', f', g', h'] = rounds Wf 56 4 #v[a, b, c, d, e, f, g, h] →
        E'.args = (Sha512_round.args (.value dd) (.value blk)).get → Consts E' →
        (E' ⊨ [rir_reg% hty 1715 := a', rir_reg% hty 1689 := b', rir_reg% hty 1663 := c',
          rir_reg% hty 1637 := d', rir_reg% hty 1704 := e', rir_reg% hty 1678 := f',
          rir_reg% hty 1652 := g', rir_reg% hty 1626 := h', %102 := V, %103 := W,
          %141 := dd.add 16#64]) →
        BODY E' 1575 S κ = R) :
    BODY E 1471 S κ = R := by
  iterate 9 step_pure
  have hw : S.mem.readAt (W.add 448#64) 64 = Wf 56 := by
    first | exact hW 56 (by decide) | (rw [hS]; exact hW 56 (by decide))
  step_load consuming hw
  iterate 3 step_pure
  step_pure with t56 ht56
  step_pure with e57 he56
  iterate 10 step_pure
  step_pure with a57 ha56
  have hr56 : Sha512.round #v[a, b, c, d, e, f, g, h] Sha512.K[56]! (Wf 56) =
      #v[a57, a, b, c, e57, e, f, g] := by
    rw [ha56, he56, ht56]; exact round_eq4 ..
  clear ha56 he56 ht56
  iterate 9 step_pure
  have hw : S.mem.readAt (W.add 456#64) 64 = Wf 57 := by
    first | exact hW 57 (by decide) | (rw [hS]; exact hW 57 (by decide))
  step_load consuming hw
  iterate 3 step_pure
  step_pure with t57 ht57
  step_pure with e58 he57
  iterate 10 step_pure
  step_pure with a58 ha57
  have hr57 : Sha512.round #v[a57, a, b, c, e57, e, f, g] Sha512.K[57]! (Wf 57) =
      #v[a58, a57, a, b, e58, e57, e, f] := by
    rw [ha57, he57, ht57]; exact round_eq4 ..
  clear ha57 he57 ht57
  iterate 9 step_pure
  have hw : S.mem.readAt (W.add 464#64) 64 = Wf 58 := by
    first | exact hW 58 (by decide) | (rw [hS]; exact hW 58 (by decide))
  step_load consuming hw
  iterate 3 step_pure
  step_pure with t58 ht58
  step_pure with e59 he58
  iterate 10 step_pure
  step_pure with a59 ha58
  have hr58 : Sha512.round #v[a58, a57, a, b, e58, e57, e, f] Sha512.K[58]! (Wf 58) =
      #v[a59, a58, a57, a, e59, e58, e57, e] := by
    rw [ha58, he58, ht58]; exact round_eq4 ..
  clear ha58 he58 ht58
  iterate 9 step_pure
  have hw : S.mem.readAt (W.add 472#64) 64 = Wf 59 := by
    first | exact hW 59 (by decide) | (rw [hS]; exact hW 59 (by decide))
  step_load consuming hw
  iterate 3 step_pure
  step_pure with t59 ht59
  step_pure with e60 he59
  iterate 10 step_pure
  step_pure with a60 ha59
  have hr59 : Sha512.round #v[a59, a58, a57, a, e59, e58, e57, e] Sha512.K[59]! (Wf 59) =
      #v[a60, a59, a58, a57, e60, e59, e58, e57] := by
    rw [ha59, he59, ht59]; exact round_eq4 ..
  clear ha59 he59 ht59
  have hv : #v[a60, a59, a58, a57, e60, e59, e58, e57] = rounds Wf 56 4 #v[a, b, c, d, e, f, g, h] := by
    rw [rounds_succ, hr56, rounds_succ, hr57, rounds_succ, hr58, rounds_succ, hr59, rounds_zero]
  first | subst hS | skip
  exact hK E a60 a59 a58 a57 e60 e59 e58 e57 hv hArgs (by env_reads) (by env_reads)

set_option maxHeartbeats 0 in
/-- Rounds `60` to `63`. -/
theorem chunk60 (dd blk V W : Pointer) (Wf : Nat → BitVec 64) (a b c d e f g h : BitVec 64)
    (E : ⟪Γ⟫) (S : GlobalState) {β : Type} (κ : Vals [] × GlobalState → PoisonOr β)
    (R : PoisonOr β) (hArgs : E.args = (Sha512_round.args (.value dd) (.value blk)).get)
    (hc : Consts E)
    (hR : E ⊨ [rir_reg% hty 1715 := a, rir_reg% hty 1689 := b, rir_reg% hty 1663 := c,
      rir_reg% hty 1637 := d, rir_reg% hty 1704 := e, rir_reg% hty 1678 := f,
      rir_reg% hty 1652 := g, rir_reg% hty 1626 := h, %102 := V, %103 := W, %141 := dd.add 16#64])
    (hWo : W.offset = 0) (hWf : Fits S.mem W 5120)
    (hW : ∀ t, t < 80 → S.mem.readAt (W.add (BitVec.ofNat 64 (8 * t))) 64 = Wf t)
    (hK : ∀ (E' : ⟪Γ⟫) (a' b' c' d' e' f' g' h' : BitVec 64),
      #v[a', b', c', d', e', f', g', h'] = rounds Wf 60 4 #v[a, b, c, d, e, f, g, h] →
        E'.args = (Sha512_round.args (.value dd) (.value blk)).get → Consts E' →
        (E' ⊨ [rir_reg% hty 1819 := a', rir_reg% hty 1793 := b', rir_reg% hty 1767 := c',
          rir_reg% hty 1741 := d', rir_reg% hty 1808 := e', rir_reg% hty 1782 := f',
          rir_reg% hty 1756 := g', rir_reg% hty 1730 := h', %102 := V, %103 := W,
          %141 := dd.add 16#64]) →
        BODY E' 1679 S κ = R) :
    BODY E 1575 S κ = R := by
  iterate 9 step_pure
  have hw : S.mem.readAt (W.add 480#64) 64 = Wf 60 := by
    first | exact hW 60 (by decide) | (rw [hS]; exact hW 60 (by decide))
  step_load consuming hw
  iterate 3 step_pure
  step_pure with t60 ht60
  step_pure with e61 he60
  iterate 10 step_pure
  step_pure with a61 ha60
  have hr60 : Sha512.round #v[a, b, c, d, e, f, g, h] Sha512.K[60]! (Wf 60) =
      #v[a61, a, b, c, e61, e, f, g] := by
    rw [ha60, he60, ht60]; exact round_eq4 ..
  clear ha60 he60 ht60
  iterate 9 step_pure
  have hw : S.mem.readAt (W.add 488#64) 64 = Wf 61 := by
    first | exact hW 61 (by decide) | (rw [hS]; exact hW 61 (by decide))
  step_load consuming hw
  iterate 3 step_pure
  step_pure with t61 ht61
  step_pure with e62 he61
  iterate 10 step_pure
  step_pure with a62 ha61
  have hr61 : Sha512.round #v[a61, a, b, c, e61, e, f, g] Sha512.K[61]! (Wf 61) =
      #v[a62, a61, a, b, e62, e61, e, f] := by
    rw [ha61, he61, ht61]; exact round_eq4 ..
  clear ha61 he61 ht61
  iterate 9 step_pure
  have hw : S.mem.readAt (W.add 496#64) 64 = Wf 62 := by
    first | exact hW 62 (by decide) | (rw [hS]; exact hW 62 (by decide))
  step_load consuming hw
  iterate 3 step_pure
  step_pure with t62 ht62
  step_pure with e63 he62
  iterate 10 step_pure
  step_pure with a63 ha62
  have hr62 : Sha512.round #v[a62, a61, a, b, e62, e61, e, f] Sha512.K[62]! (Wf 62) =
      #v[a63, a62, a61, a, e63, e62, e61, e] := by
    rw [ha62, he62, ht62]; exact round_eq4 ..
  clear ha62 he62 ht62
  iterate 9 step_pure
  have hw : S.mem.readAt (W.add 504#64) 64 = Wf 63 := by
    first | exact hW 63 (by decide) | (rw [hS]; exact hW 63 (by decide))
  step_load consuming hw
  iterate 3 step_pure
  step_pure with t63 ht63
  step_pure with e64 he63
  iterate 10 step_pure
  step_pure with a64 ha63
  have hr63 : Sha512.round #v[a63, a62, a61, a, e63, e62, e61, e] Sha512.K[63]! (Wf 63) =
      #v[a64, a63, a62, a61, e64, e63, e62, e61] := by
    rw [ha63, he63, ht63]; exact round_eq4 ..
  clear ha63 he63 ht63
  have hv : #v[a64, a63, a62, a61, e64, e63, e62, e61] = rounds Wf 60 4 #v[a, b, c, d, e, f, g, h] := by
    rw [rounds_succ, hr60, rounds_succ, hr61, rounds_succ, hr62, rounds_succ, hr63, rounds_zero]
  first | subst hS | skip
  exact hK E a64 a63 a62 a61 e64 e63 e62 e61 hv hArgs (by env_reads) (by env_reads)

set_option maxHeartbeats 0 in
/-- Rounds `64` to `67`. -/
theorem chunk64 (dd blk V W : Pointer) (Wf : Nat → BitVec 64) (a b c d e f g h : BitVec 64)
    (E : ⟪Γ⟫) (S : GlobalState) {β : Type} (κ : Vals [] × GlobalState → PoisonOr β)
    (R : PoisonOr β) (hArgs : E.args = (Sha512_round.args (.value dd) (.value blk)).get)
    (hc : Consts E)
    (hR : E ⊨ [rir_reg% hty 1819 := a, rir_reg% hty 1793 := b, rir_reg% hty 1767 := c,
      rir_reg% hty 1741 := d, rir_reg% hty 1808 := e, rir_reg% hty 1782 := f,
      rir_reg% hty 1756 := g, rir_reg% hty 1730 := h, %102 := V, %103 := W, %141 := dd.add 16#64])
    (hWo : W.offset = 0) (hWf : Fits S.mem W 5120)
    (hW : ∀ t, t < 80 → S.mem.readAt (W.add (BitVec.ofNat 64 (8 * t))) 64 = Wf t)
    (hK : ∀ (E' : ⟪Γ⟫) (a' b' c' d' e' f' g' h' : BitVec 64),
      #v[a', b', c', d', e', f', g', h'] = rounds Wf 64 4 #v[a, b, c, d, e, f, g, h] →
        E'.args = (Sha512_round.args (.value dd) (.value blk)).get → Consts E' →
        (E' ⊨ [rir_reg% hty 1923 := a', rir_reg% hty 1897 := b', rir_reg% hty 1871 := c',
          rir_reg% hty 1845 := d', rir_reg% hty 1912 := e', rir_reg% hty 1886 := f',
          rir_reg% hty 1860 := g', rir_reg% hty 1834 := h', %102 := V, %103 := W,
          %141 := dd.add 16#64]) →
        BODY E' 1783 S κ = R) :
    BODY E 1679 S κ = R := by
  iterate 9 step_pure
  have hw : S.mem.readAt (W.add 512#64) 64 = Wf 64 := by
    first | exact hW 64 (by decide) | (rw [hS]; exact hW 64 (by decide))
  step_load consuming hw
  iterate 3 step_pure
  step_pure with t64 ht64
  step_pure with e65 he64
  iterate 10 step_pure
  step_pure with a65 ha64
  have hr64 : Sha512.round #v[a, b, c, d, e, f, g, h] Sha512.K[64]! (Wf 64) =
      #v[a65, a, b, c, e65, e, f, g] := by
    rw [ha64, he64, ht64]; exact round_eq4 ..
  clear ha64 he64 ht64
  iterate 9 step_pure
  have hw : S.mem.readAt (W.add 520#64) 64 = Wf 65 := by
    first | exact hW 65 (by decide) | (rw [hS]; exact hW 65 (by decide))
  step_load consuming hw
  iterate 3 step_pure
  step_pure with t65 ht65
  step_pure with e66 he65
  iterate 10 step_pure
  step_pure with a66 ha65
  have hr65 : Sha512.round #v[a65, a, b, c, e65, e, f, g] Sha512.K[65]! (Wf 65) =
      #v[a66, a65, a, b, e66, e65, e, f] := by
    rw [ha65, he65, ht65]; exact round_eq4 ..
  clear ha65 he65 ht65
  iterate 9 step_pure
  have hw : S.mem.readAt (W.add 528#64) 64 = Wf 66 := by
    first | exact hW 66 (by decide) | (rw [hS]; exact hW 66 (by decide))
  step_load consuming hw
  iterate 3 step_pure
  step_pure with t66 ht66
  step_pure with e67 he66
  iterate 10 step_pure
  step_pure with a67 ha66
  have hr66 : Sha512.round #v[a66, a65, a, b, e66, e65, e, f] Sha512.K[66]! (Wf 66) =
      #v[a67, a66, a65, a, e67, e66, e65, e] := by
    rw [ha66, he66, ht66]; exact round_eq4 ..
  clear ha66 he66 ht66
  iterate 9 step_pure
  have hw : S.mem.readAt (W.add 536#64) 64 = Wf 67 := by
    first | exact hW 67 (by decide) | (rw [hS]; exact hW 67 (by decide))
  step_load consuming hw
  iterate 3 step_pure
  step_pure with t67 ht67
  step_pure with e68 he67
  iterate 10 step_pure
  step_pure with a68 ha67
  have hr67 : Sha512.round #v[a67, a66, a65, a, e67, e66, e65, e] Sha512.K[67]! (Wf 67) =
      #v[a68, a67, a66, a65, e68, e67, e66, e65] := by
    rw [ha67, he67, ht67]; exact round_eq4 ..
  clear ha67 he67 ht67
  have hv : #v[a68, a67, a66, a65, e68, e67, e66, e65] = rounds Wf 64 4 #v[a, b, c, d, e, f, g, h] := by
    rw [rounds_succ, hr64, rounds_succ, hr65, rounds_succ, hr66, rounds_succ, hr67, rounds_zero]
  first | subst hS | skip
  exact hK E a68 a67 a66 a65 e68 e67 e66 e65 hv hArgs (by env_reads) (by env_reads)

set_option maxHeartbeats 0 in
/-- Rounds `68` to `71`. -/
theorem chunk68 (dd blk V W : Pointer) (Wf : Nat → BitVec 64) (a b c d e f g h : BitVec 64)
    (E : ⟪Γ⟫) (S : GlobalState) {β : Type} (κ : Vals [] × GlobalState → PoisonOr β)
    (R : PoisonOr β) (hArgs : E.args = (Sha512_round.args (.value dd) (.value blk)).get)
    (hc : Consts E)
    (hR : E ⊨ [rir_reg% hty 1923 := a, rir_reg% hty 1897 := b, rir_reg% hty 1871 := c,
      rir_reg% hty 1845 := d, rir_reg% hty 1912 := e, rir_reg% hty 1886 := f,
      rir_reg% hty 1860 := g, rir_reg% hty 1834 := h, %102 := V, %103 := W, %141 := dd.add 16#64])
    (hWo : W.offset = 0) (hWf : Fits S.mem W 5120)
    (hW : ∀ t, t < 80 → S.mem.readAt (W.add (BitVec.ofNat 64 (8 * t))) 64 = Wf t)
    (hK : ∀ (E' : ⟪Γ⟫) (a' b' c' d' e' f' g' h' : BitVec 64),
      #v[a', b', c', d', e', f', g', h'] = rounds Wf 68 4 #v[a, b, c, d, e, f, g, h] →
        E'.args = (Sha512_round.args (.value dd) (.value blk)).get → Consts E' →
        (E' ⊨ [rir_reg% hty 2027 := a', rir_reg% hty 2001 := b', rir_reg% hty 1975 := c',
          rir_reg% hty 1949 := d', rir_reg% hty 2016 := e', rir_reg% hty 1990 := f',
          rir_reg% hty 1964 := g', rir_reg% hty 1938 := h', %102 := V, %103 := W,
          %141 := dd.add 16#64]) →
        BODY E' 1887 S κ = R) :
    BODY E 1783 S κ = R := by
  iterate 9 step_pure
  have hw : S.mem.readAt (W.add 544#64) 64 = Wf 68 := by
    first | exact hW 68 (by decide) | (rw [hS]; exact hW 68 (by decide))
  step_load consuming hw
  iterate 3 step_pure
  step_pure with t68 ht68
  step_pure with e69 he68
  iterate 10 step_pure
  step_pure with a69 ha68
  have hr68 : Sha512.round #v[a, b, c, d, e, f, g, h] Sha512.K[68]! (Wf 68) =
      #v[a69, a, b, c, e69, e, f, g] := by
    rw [ha68, he68, ht68]; exact round_eq4 ..
  clear ha68 he68 ht68
  iterate 9 step_pure
  have hw : S.mem.readAt (W.add 552#64) 64 = Wf 69 := by
    first | exact hW 69 (by decide) | (rw [hS]; exact hW 69 (by decide))
  step_load consuming hw
  iterate 3 step_pure
  step_pure with t69 ht69
  step_pure with e70 he69
  iterate 10 step_pure
  step_pure with a70 ha69
  have hr69 : Sha512.round #v[a69, a, b, c, e69, e, f, g] Sha512.K[69]! (Wf 69) =
      #v[a70, a69, a, b, e70, e69, e, f] := by
    rw [ha69, he69, ht69]; exact round_eq4 ..
  clear ha69 he69 ht69
  iterate 9 step_pure
  have hw : S.mem.readAt (W.add 560#64) 64 = Wf 70 := by
    first | exact hW 70 (by decide) | (rw [hS]; exact hW 70 (by decide))
  step_load consuming hw
  iterate 3 step_pure
  step_pure with t70 ht70
  step_pure with e71 he70
  iterate 10 step_pure
  step_pure with a71 ha70
  have hr70 : Sha512.round #v[a70, a69, a, b, e70, e69, e, f] Sha512.K[70]! (Wf 70) =
      #v[a71, a70, a69, a, e71, e70, e69, e] := by
    rw [ha70, he70, ht70]; exact round_eq4 ..
  clear ha70 he70 ht70
  iterate 9 step_pure
  have hw : S.mem.readAt (W.add 568#64) 64 = Wf 71 := by
    first | exact hW 71 (by decide) | (rw [hS]; exact hW 71 (by decide))
  step_load consuming hw
  iterate 3 step_pure
  step_pure with t71 ht71
  step_pure with e72 he71
  iterate 10 step_pure
  step_pure with a72 ha71
  have hr71 : Sha512.round #v[a71, a70, a69, a, e71, e70, e69, e] Sha512.K[71]! (Wf 71) =
      #v[a72, a71, a70, a69, e72, e71, e70, e69] := by
    rw [ha71, he71, ht71]; exact round_eq4 ..
  clear ha71 he71 ht71
  have hv : #v[a72, a71, a70, a69, e72, e71, e70, e69] = rounds Wf 68 4 #v[a, b, c, d, e, f, g, h] := by
    rw [rounds_succ, hr68, rounds_succ, hr69, rounds_succ, hr70, rounds_succ, hr71, rounds_zero]
  first | subst hS | skip
  exact hK E a72 a71 a70 a69 e72 e71 e70 e69 hv hArgs (by env_reads) (by env_reads)

set_option maxHeartbeats 0 in
/-- Rounds `72` to `75`. -/
theorem chunk72 (dd blk V W : Pointer) (Wf : Nat → BitVec 64) (a b c d e f g h : BitVec 64)
    (E : ⟪Γ⟫) (S : GlobalState) {β : Type} (κ : Vals [] × GlobalState → PoisonOr β)
    (R : PoisonOr β) (hArgs : E.args = (Sha512_round.args (.value dd) (.value blk)).get)
    (hc : Consts E)
    (hR : E ⊨ [rir_reg% hty 2027 := a, rir_reg% hty 2001 := b, rir_reg% hty 1975 := c,
      rir_reg% hty 1949 := d, rir_reg% hty 2016 := e, rir_reg% hty 1990 := f,
      rir_reg% hty 1964 := g, rir_reg% hty 1938 := h, %102 := V, %103 := W, %141 := dd.add 16#64])
    (hWo : W.offset = 0) (hWf : Fits S.mem W 5120)
    (hW : ∀ t, t < 80 → S.mem.readAt (W.add (BitVec.ofNat 64 (8 * t))) 64 = Wf t)
    (hK : ∀ (E' : ⟪Γ⟫) (a' b' c' d' e' f' g' h' : BitVec 64),
      #v[a', b', c', d', e', f', g', h'] = rounds Wf 72 4 #v[a, b, c, d, e, f, g, h] →
        E'.args = (Sha512_round.args (.value dd) (.value blk)).get → Consts E' →
        (E' ⊨ [rir_reg% hty 2131 := a', rir_reg% hty 2105 := b', rir_reg% hty 2079 := c',
          rir_reg% hty 2053 := d', rir_reg% hty 2120 := e', rir_reg% hty 2094 := f',
          rir_reg% hty 2068 := g', rir_reg% hty 2042 := h', %102 := V, %103 := W,
          %141 := dd.add 16#64]) →
        BODY E' 1991 S κ = R) :
    BODY E 1887 S κ = R := by
  iterate 9 step_pure
  have hw : S.mem.readAt (W.add 576#64) 64 = Wf 72 := by
    first | exact hW 72 (by decide) | (rw [hS]; exact hW 72 (by decide))
  step_load consuming hw
  iterate 3 step_pure
  step_pure with t72 ht72
  step_pure with e73 he72
  iterate 10 step_pure
  step_pure with a73 ha72
  have hr72 : Sha512.round #v[a, b, c, d, e, f, g, h] Sha512.K[72]! (Wf 72) =
      #v[a73, a, b, c, e73, e, f, g] := by
    rw [ha72, he72, ht72]; exact round_eq4 ..
  clear ha72 he72 ht72
  iterate 9 step_pure
  have hw : S.mem.readAt (W.add 584#64) 64 = Wf 73 := by
    first | exact hW 73 (by decide) | (rw [hS]; exact hW 73 (by decide))
  step_load consuming hw
  iterate 3 step_pure
  step_pure with t73 ht73
  step_pure with e74 he73
  iterate 10 step_pure
  step_pure with a74 ha73
  have hr73 : Sha512.round #v[a73, a, b, c, e73, e, f, g] Sha512.K[73]! (Wf 73) =
      #v[a74, a73, a, b, e74, e73, e, f] := by
    rw [ha73, he73, ht73]; exact round_eq4 ..
  clear ha73 he73 ht73
  iterate 9 step_pure
  have hw : S.mem.readAt (W.add 592#64) 64 = Wf 74 := by
    first | exact hW 74 (by decide) | (rw [hS]; exact hW 74 (by decide))
  step_load consuming hw
  iterate 3 step_pure
  step_pure with t74 ht74
  step_pure with e75 he74
  iterate 10 step_pure
  step_pure with a75 ha74
  have hr74 : Sha512.round #v[a74, a73, a, b, e74, e73, e, f] Sha512.K[74]! (Wf 74) =
      #v[a75, a74, a73, a, e75, e74, e73, e] := by
    rw [ha74, he74, ht74]; exact round_eq4 ..
  clear ha74 he74 ht74
  iterate 9 step_pure
  have hw : S.mem.readAt (W.add 600#64) 64 = Wf 75 := by
    first | exact hW 75 (by decide) | (rw [hS]; exact hW 75 (by decide))
  step_load consuming hw
  iterate 3 step_pure
  step_pure with t75 ht75
  step_pure with e76 he75
  iterate 10 step_pure
  step_pure with a76 ha75
  have hr75 : Sha512.round #v[a75, a74, a73, a, e75, e74, e73, e] Sha512.K[75]! (Wf 75) =
      #v[a76, a75, a74, a73, e76, e75, e74, e73] := by
    rw [ha75, he75, ht75]; exact round_eq4 ..
  clear ha75 he75 ht75
  have hv : #v[a76, a75, a74, a73, e76, e75, e74, e73] = rounds Wf 72 4 #v[a, b, c, d, e, f, g, h] := by
    rw [rounds_succ, hr72, rounds_succ, hr73, rounds_succ, hr74, rounds_succ, hr75, rounds_zero]
  first | subst hS | skip
  exact hK E a76 a75 a74 a73 e76 e75 e74 e73 hv hArgs (by env_reads) (by env_reads)

set_option maxHeartbeats 0 in
/-- Rounds `76` to `79`, then the working variables stored at `V`. -/
theorem chunk76 (dd blk V W : Pointer) (Wf : Nat → BitVec 64) (a b c d e f g h : BitVec 64)
    (E : ⟪Γ⟫) (S : GlobalState) {β : Type} (κ : Vals [] × GlobalState → PoisonOr β)
    (R : PoisonOr β) (hArgs : E.args = (Sha512_round.args (.value dd) (.value blk)).get)
    (hc : Consts E)
    (hR : E ⊨ [rir_reg% hty 2131 := a, rir_reg% hty 2105 := b, rir_reg% hty 2079 := c,
      rir_reg% hty 2053 := d, rir_reg% hty 2120 := e, rir_reg% hty 2094 := f,
      rir_reg% hty 2068 := g, rir_reg% hty 2042 := h, %102 := V, %103 := W, %141 := dd.add 16#64])
    (hWo : W.offset = 0) (hWf : Fits S.mem W 5120)
    (hVo : V.offset = 0) (hVf : Fits S.mem V 512)
    (hW : ∀ t, t < 80 → S.mem.readAt (W.add (BitVec.ofNat 64 (8 * t))) 64 = Wf t)
    (hK : ∀ (E' : ⟪Γ⟫) (a' b' c' d' e' f' g' h' : BitVec 64),
      #v[a', b', c', d', e', f', g', h'] = rounds Wf 76 4 #v[a, b, c, d, e, f, g, h] →
        E'.args = (Sha512_round.args (.value dd) (.value blk)).get → Consts E' →
        (E' ⊨ [rir_reg% hty 2243 := 0#64, %102 := V, %141 := dd.add 16#64]) →
        (Sha512_round.runFrom E' 6 { S with mem := storeWords8 S.mem V #v[a', b', c', d', e', f', g', h'] } >>= κ) = R) :
    BODY E 1991 S κ = R := by
  iterate 9 step_pure
  have hw : S.mem.readAt (W.add 608#64) 64 = Wf 76 := by
    first | exact hW 76 (by decide) | (rw [hS]; exact hW 76 (by decide))
  step_load consuming hw
  iterate 3 step_pure
  step_pure with t76 ht76
  step_pure with e77 he76
  iterate 10 step_pure
  step_pure with a77 ha76
  have hr76 : Sha512.round #v[a, b, c, d, e, f, g, h] Sha512.K[76]! (Wf 76) =
      #v[a77, a, b, c, e77, e, f, g] := by
    rw [ha76, he76, ht76]; exact round_eq4 ..
  clear ha76 he76 ht76
  iterate 9 step_pure
  have hw : S.mem.readAt (W.add 616#64) 64 = Wf 77 := by
    first | exact hW 77 (by decide) | (rw [hS]; exact hW 77 (by decide))
  step_load consuming hw
  iterate 3 step_pure
  step_pure with t77 ht77
  step_pure with e78 he77
  iterate 10 step_pure
  step_pure with a78 ha77
  have hr77 : Sha512.round #v[a77, a, b, c, e77, e, f, g] Sha512.K[77]! (Wf 77) =
      #v[a78, a77, a, b, e78, e77, e, f] := by
    rw [ha77, he77, ht77]; exact round_eq4 ..
  clear ha77 he77 ht77
  iterate 9 step_pure
  have hw : S.mem.readAt (W.add 624#64) 64 = Wf 78 := by
    first | exact hW 78 (by decide) | (rw [hS]; exact hW 78 (by decide))
  step_load consuming hw
  iterate 3 step_pure
  step_pure with t78 ht78
  step_pure with e79 he78
  iterate 10 step_pure
  step_pure with a79 ha78
  have hr78 : Sha512.round #v[a78, a77, a, b, e78, e77, e, f] Sha512.K[78]! (Wf 78) =
      #v[a79, a78, a77, a, e79, e78, e77, e] := by
    rw [ha78, he78, ht78]; exact round_eq4 ..
  clear ha78 he78 ht78
  iterate 9 step_pure
  have hw : S.mem.readAt (W.add 632#64) 64 = Wf 79 := by
    first | exact hW 79 (by decide) | (rw [hS]; exact hW 79 (by decide))
  step_load consuming hw
  iterate 3 step_pure
  step_pure with t79 ht79
  step_pure with e80 he79
  iterate 10 step_pure
  step_pure with a80 ha79
  have hr79 : Sha512.round #v[a79, a78, a77, a, e79, e78, e77, e] Sha512.K[79]! (Wf 79) =
      #v[a80, a79, a78, a77, e80, e79, e78, e77] := by
    rw [ha79, he79, ht79]; exact round_eq4 ..
  clear ha79 he79 ht79
  have hv : #v[a80, a79, a78, a77, e80, e79, e78, e77] = rounds Wf 76 4 #v[a, b, c, d, e, f, g, h] := by
    rw [rounds_succ, hr76, rounds_succ, hr77, rounds_succ, hr78, rounds_succ, hr79, rounds_zero]
  step_store
  iterate 7
    step_pure
    step_store
  rw [BasicBlock.runBodyFrom_done bb5_done]
  simp only [EffectM.pure_eq, PoisonOr.value_bind, reduceBlockExit, Exit.run]
  dsimp only [Jump.run, Fin.isValue, Regs.read_nil, EffectM.pure_eq, PoisonOr.value_bind,
    Regs.read_cons, reduceWriteManyDsts, Env.writeMany_nil, Env.writeMany_cons]
  rw [Func.continue_next]
  subst hS
  refine hK _ a80 a79 a78 a77 e80 e79 e78 e77 hv hArgs (by env_reads) ⟨?_, ?_, ?_⟩
  · rw [read_write_same]; env_reads
  all_goals rw [Env.read_write_ne']; env_reads


set_option maxHeartbeats 0 in
/-- `bb5`: the 80 rounds from the state words at `dd + 16`, stored at `V`. -/
theorem block5 (dd blk V W : Pointer) (Wf : Nat → BitVec 64) (a b c d e f g h : BitVec 64)
    (E : ⟪Γ⟫) (S : GlobalState) {β : Type} (κ : Vals [] × GlobalState → PoisonOr β)
    (R : PoisonOr β) (hArgs : E.args = (Sha512_round.args (.value dd) (.value blk)).get)
    (hc : Consts E) (hR : E ⊨ [%102 := V, %103 := W]) (hdo : dd.offset.toNat + 80 < 2 ^ 64)
    (hF0 : Fits S.mem (dd.add 16#64) 64) (hF1 : Fits S.mem (dd.add 24#64) 64)
    (hF2 : Fits S.mem (dd.add 32#64) 64) (hF3 : Fits S.mem (dd.add 40#64) 64)
    (hF4 : Fits S.mem (dd.add 48#64) 64) (hF5 : Fits S.mem (dd.add 56#64) 64)
    (hF6 : Fits S.mem (dd.add 64#64) 64) (hF7 : Fits S.mem (dd.add 72#64) 64)
    (hd0 : S.mem.readAt (dd.add 16#64) 64 = a)
    (hd1 : S.mem.readAt (dd.add 24#64) 64 = b)
    (hd2 : S.mem.readAt (dd.add 32#64) 64 = c)
    (hd3 : S.mem.readAt (dd.add 40#64) 64 = d)
    (hd4 : S.mem.readAt (dd.add 48#64) 64 = e)
    (hd5 : S.mem.readAt (dd.add 56#64) 64 = f)
    (hd6 : S.mem.readAt (dd.add 64#64) 64 = g)
    (hd7 : S.mem.readAt (dd.add 72#64) 64 = h)
    (hWo : W.offset = 0) (hWf : Fits S.mem W 5120) (hVo : V.offset = 0) (hVf : Fits S.mem V 512)
    (hW : ∀ t, t < 80 → S.mem.readAt (W.add (BitVec.ofNat 64 (8 * t))) 64 = Wf t)
    (hK : ∀ E' : ⟪Γ⟫, E'.args = (Sha512_round.args (.value dd) (.value blk)).get → Consts E' →
      (E' ⊨ [rir_reg% hty 2243 := 0#64, %102 := V, %141 := dd.add 16#64]) →
      (Sha512_round.runFrom E' 6
        { S with mem := storeWords8 S.mem V (rounds Wf 0 80 #v[a, b, c, d, e, f, g, h]) } >>= κ) = R) :
    (Sha512_round.runFrom E 5 S >>= κ) = R := by
  block_init
  refine chunk0 dd blk V W Wf a b c d e f g h E S κ R hArgs hc hR hdo hF0 hF1 hF2 hF3 hF4 hF5
    hF6 hF7 hd0 hd1 hd2 hd3 hd4 hd5 hd6 hd7 hWo hWf hW
    fun E1 a1 b1 c1 d1 e1 f1 g1 h1 hv1 hA1 hc1 hR1 => ?_
  refine chunk4 dd blk V W Wf a1 b1 c1 d1 e1 f1 g1 h1 E1 S κ R hA1 hc1 hR1 hWo hWf hW
    fun E2 a2 b2 c2 d2 e2 f2 g2 h2 hv2 hA2 hc2 hR2 => ?_
  refine chunk8 dd blk V W Wf a2 b2 c2 d2 e2 f2 g2 h2 E2 S κ R hA2 hc2 hR2 hWo hWf hW
    fun E3 a3 b3 c3 d3 e3 f3 g3 h3 hv3 hA3 hc3 hR3 => ?_
  refine chunk12 dd blk V W Wf a3 b3 c3 d3 e3 f3 g3 h3 E3 S κ R hA3 hc3 hR3 hWo hWf hW
    fun E4 a4 b4 c4 d4 e4 f4 g4 h4 hv4 hA4 hc4 hR4 => ?_
  refine chunk16 dd blk V W Wf a4 b4 c4 d4 e4 f4 g4 h4 E4 S κ R hA4 hc4 hR4 hWo hWf hW
    fun E5 a5 b5 c5 d5 e5 f5 g5 h5 hv5 hA5 hc5 hR5 => ?_
  refine chunk20 dd blk V W Wf a5 b5 c5 d5 e5 f5 g5 h5 E5 S κ R hA5 hc5 hR5 hWo hWf hW
    fun E6 a6 b6 c6 d6 e6 f6 g6 h6 hv6 hA6 hc6 hR6 => ?_
  refine chunk24 dd blk V W Wf a6 b6 c6 d6 e6 f6 g6 h6 E6 S κ R hA6 hc6 hR6 hWo hWf hW
    fun E7 a7 b7 c7 d7 e7 f7 g7 h7 hv7 hA7 hc7 hR7 => ?_
  refine chunk28 dd blk V W Wf a7 b7 c7 d7 e7 f7 g7 h7 E7 S κ R hA7 hc7 hR7 hWo hWf hW
    fun E8 a8 b8 c8 d8 e8 f8 g8 h8 hv8 hA8 hc8 hR8 => ?_
  refine chunk32 dd blk V W Wf a8 b8 c8 d8 e8 f8 g8 h8 E8 S κ R hA8 hc8 hR8 hWo hWf hW
    fun E9 a9 b9 c9 d9 e9 f9 g9 h9 hv9 hA9 hc9 hR9 => ?_
  refine chunk36 dd blk V W Wf a9 b9 c9 d9 e9 f9 g9 h9 E9 S κ R hA9 hc9 hR9 hWo hWf hW
    fun E10 a10 b10 c10 d10 e10 f10 g10 h10 hv10 hA10 hc10 hR10 => ?_
  refine chunk40 dd blk V W Wf a10 b10 c10 d10 e10 f10 g10 h10 E10 S κ R hA10 hc10 hR10 hWo hWf hW
    fun E11 a11 b11 c11 d11 e11 f11 g11 h11 hv11 hA11 hc11 hR11 => ?_
  refine chunk44 dd blk V W Wf a11 b11 c11 d11 e11 f11 g11 h11 E11 S κ R hA11 hc11 hR11 hWo hWf hW
    fun E12 a12 b12 c12 d12 e12 f12 g12 h12 hv12 hA12 hc12 hR12 => ?_
  refine chunk48 dd blk V W Wf a12 b12 c12 d12 e12 f12 g12 h12 E12 S κ R hA12 hc12 hR12 hWo hWf hW
    fun E13 a13 b13 c13 d13 e13 f13 g13 h13 hv13 hA13 hc13 hR13 => ?_
  refine chunk52 dd blk V W Wf a13 b13 c13 d13 e13 f13 g13 h13 E13 S κ R hA13 hc13 hR13 hWo hWf hW
    fun E14 a14 b14 c14 d14 e14 f14 g14 h14 hv14 hA14 hc14 hR14 => ?_
  refine chunk56 dd blk V W Wf a14 b14 c14 d14 e14 f14 g14 h14 E14 S κ R hA14 hc14 hR14 hWo hWf hW
    fun E15 a15 b15 c15 d15 e15 f15 g15 h15 hv15 hA15 hc15 hR15 => ?_
  refine chunk60 dd blk V W Wf a15 b15 c15 d15 e15 f15 g15 h15 E15 S κ R hA15 hc15 hR15 hWo hWf hW
    fun E16 a16 b16 c16 d16 e16 f16 g16 h16 hv16 hA16 hc16 hR16 => ?_
  refine chunk64 dd blk V W Wf a16 b16 c16 d16 e16 f16 g16 h16 E16 S κ R hA16 hc16 hR16 hWo hWf hW
    fun E17 a17 b17 c17 d17 e17 f17 g17 h17 hv17 hA17 hc17 hR17 => ?_
  refine chunk68 dd blk V W Wf a17 b17 c17 d17 e17 f17 g17 h17 E17 S κ R hA17 hc17 hR17 hWo hWf hW
    fun E18 a18 b18 c18 d18 e18 f18 g18 h18 hv18 hA18 hc18 hR18 => ?_
  refine chunk72 dd blk V W Wf a18 b18 c18 d18 e18 f18 g18 h18 E18 S κ R hA18 hc18 hR18 hWo hWf hW
    fun E19 a19 b19 c19 d19 e19 f19 g19 h19 hv19 hA19 hc19 hR19 => ?_
  refine chunk76 dd blk V W Wf a19 b19 c19 d19 e19 f19 g19 h19 E19 S κ R hA19 hc19 hR19 hWo hWf hVo hVf hW
    fun E' a' b' c' d' e' f' g' h' hv hA hc' hR' => ?_
  have hfin : #v[a', b', c', d', e', f', g', h'] = rounds Wf 0 80 #v[a, b, c, d, e, f, g, h] := by
    rw [rounds_add Wf 0 4 76, ← hv1, rounds_add Wf 4 4 72, ← hv2, rounds_add Wf 8 4 68, ← hv3, rounds_add Wf 12 4 64, ← hv4, rounds_add Wf 16 4 60, ← hv5, rounds_add Wf 20 4 56, ← hv6, rounds_add Wf 24 4 52, ← hv7, rounds_add Wf 28 4 48, ← hv8, rounds_add Wf 32 4 44, ← hv9, rounds_add Wf 36 4 40, ← hv10, rounds_add Wf 40 4 36, ← hv11, rounds_add Wf 44 4 32, ← hv12, rounds_add Wf 48 4 28, ← hv13, rounds_add Wf 52 4 24, ← hv14, rounds_add Wf 56 4 20, ← hv15, rounds_add Wf 60 4 16, ← hv16, rounds_add Wf 64 4 12, ← hv17, rounds_add Wf 68 4 8, ← hv18, rounds_add Wf 72 4 4, ← hv19]
    exact hv
  rw [hfin]
  exact hK E' hA hc' hR'


/-! ## The schedule's loops -/

/-- The stores of `f i`, …, `f (i + n - 1)` into the slots `i … i + n - 1` of `W`. -/
def stores (W : Pointer) (f : Nat → BitVec 64) : (i n : Nat) → MemoryState → MemoryState
  | _, 0, m => m
  | i, n + 1, m => stores W f (i + 1) n (m.storeAt (W.add (BitVec.ofNat 64 (8 * i))) (f i))

theorem shl3_facts {i : Nat} (hi : i < 2 ^ 60) :
    BitVec.ofNat 64 (8 * i) >>> 3 = BitVec.ofNat 64 i ∧
      (BitVec.ofNat 64 (8 * i)).sshiftRight 3 = BitVec.ofNat 64 i ∧
      BitVec.ofNat 64 i <<< 3 = BitVec.ofNat 64 (8 * i) ∧ i % 18446744073709551616 = i ∧
      i * 8 = 8 * i ∧ 8 * i % 18446744073709551616 = 8 * i ∧ 8 * i < 18446744073709551616 := by
  have h3 : BitVec.ofNat 64 i <<< 3 = BitVec.ofNat 64 (8 * i) := by
    apply BitVec.eq_of_toNat_eq
    simp [BitVec.toNat_shiftLeft, Nat.shiftLeft_eq]
    omega
  refine ⟨?_, ?_, h3, by omega, by omega, by omega, by omega⟩
  · apply BitVec.eq_of_toNat_eq; simp [BitVec.toNat_ushiftRight, Nat.shiftRight_eq_div_pow]; omega
  · rw [BitVec.sshiftRight_eq_of_msb_false]
    · apply BitVec.eq_of_toNat_eq; simp [BitVec.toNat_ushiftRight, Nat.shiftRight_eq_div_pow]; omega
    · simp [BitVec.msb_eq_decide]; omega

/-- `llvm.intr.bswap` on 64 bits, as the operation unfolds. -/
abbrev bswapv (x : BitVec 64) : BitVec 64 :=
  (List.range 8).foldl (fun acc i => acc ||| (x >>> (8 * i) &&& 255#64) <<< (64 - 8 * (i + 1))) 0#64

set_option maxHeartbeats 0 in
/-- `bb1`/`bb2` from round `i`, `m` left: `W[i] = bswap(block word i)`. -/
theorem loop1 (dd blk V W : Pointer) (B : BitVec 1024) {β : Type}
    (κ : Vals [] × GlobalState → PoisonOr β) (R : PoisonOr β) (hWo : W.offset = 0)
    (hbo : blk.offset.toNat + 128 < 2 ^ 64) (hWb : W.id ≠ blk.id) :
    ∀ m i (S : GlobalState) (E : ⟪Γ⟫), i + m = 16 →
      E.args = (Sha512_round.args (.value dd) (.value blk)).get → Consts E →
      (E ⊨ [%102 := V, %103 := W, %104 := BitVec.ofNat 64 i]) → S.WF →
      Fits S.mem W 5120 → Fits S.mem blk 1024 → S.mem.readAt blk 1024 = B →
      (∀ E' : ⟪Γ⟫, E'.args = (Sha512_round.args (.value dd) (.value blk)).get → Consts E' →
        (E' ⊨ [%102 := V, %103 := W, %112 := 16#64]) →
        (Sha512_round.runFrom E' 3
          { S with mem := stores W (fun t => bswapv (B.extractLsb' (64 * t) 64)) i m S.mem } >>= κ) = R) →
      (Sha512_round.runFrom E 1 S >>= κ) = R := by
  intro m
  induction m with
  | zero =>
    intro i S E hi hArgs hc hR hwf hWf hbf hB hK
    obtain rfl : i = 16 := by omega
    block_init
    step_pure
    finish_block
    step_loop using hK
    env_reads
  | succ m ih =>
    intro i S E hi hArgs hc hR hwf hWf hbf hB hK
    obtain ⟨h1, h2, h3, h4, h5, h6, h7⟩ := shl3_facts (i := i) (by omega)
    obtain ⟨o1, o2⟩ := counter_overflow (i := i) (by omega)
    have hfx : Fits S.mem (blk.add (BitVec.ofNat 64 (8 * i))) 64 :=
      Fits.add_of_le (by simp [BitVec.uaddOverflow]; omega) (by simp; omega) hbf
    have hfw : Fits S.mem (W.add (BitVec.ofNat 64 (8 * i))) 64 :=
      Fits.add_of_le (by simp [BitVec.uaddOverflow, hWo]; omega) (by simp; omega) hWf
    have hx : S.mem.readAt (blk.add (BitVec.ofNat 64 (8 * i))) 64 = B.extractLsb' (64 * i) 64 := by
      rw [MemoryState.readAt_add_of_readAt hbf (by simp [BitVec.uaddOverflow]; omega)
        (by simp; omega) hB]
      congr 1; simp; omega
    block_init
    step_pure
    finish_block
    · exfalso
      have := congrArg BitVec.toNat hbr
      simp at this
      omega
    · block_init
      step_pure [h4, h5, h7]
      step_pure [h3, h1, h2]
      step_pure [h3, h1, h2, h6, h7]
      step_load consuming hx hfx
      step_pure
      step_store consuming hfw
      step_pure [o1, o2, ← BitVec.ofNat_add]
      finish_block
      refine ih (i + 1) S E (by omega) hArgs (by env_reads) (by env_reads) hwf hWf hbf hB
        (fun E' h1 h2 h3 => ?_)
      subst hS
      exact hK E' h1 h2 h3

/-- Slots `0 … n - 1` of `W` hold `f 0 … f (n - 1)`. -/
def HoldsW (m : MemoryState) (W : Pointer) (f : Nat → BitVec 64) (n : Nat) : Prop :=
  ∀ t, t < n → m.readAt (W.add (BitVec.ofNat 64 (8 * t))) 64 = f t

theorem slot_offsetInBits {W : Pointer} (hWo : W.offset = 0) {t : Nat} (ht : t < 2 ^ 58) :
    (W.add (BitVec.ofNat 64 (8 * t))).offsetInBits = 64 * t := by
  simp [Pointer.offsetInBits, Pointer.add, hWo]
  omega

theorem fits_slot {N : Nat} {m : MemoryState} {W : Pointer} (hWo : W.offset = 0) (hN : N < 2 ^ 58)
    (hf : Fits m W (64 * N)) {t : Nat} (ht : t < N) : Fits m (W.add (BitVec.ofNat 64 (8 * t))) 64 :=
  Fits.add_of_le (by simp [BitVec.uaddOverflow, hWo]; omega) (by simp; omega) hf

/-- A store of `f n` into slot `n` extends what `W` holds. -/
theorem HoldsW.store {N : Nat} {m : MemoryState} {W : Pointer} {f : Nat → BitVec 64} {n : Nat}
    (hWo : W.offset = 0) (hN : N < 2 ^ 58) (hf : Fits m W (64 * N)) (h : HoldsW m W f n) (hn : n < N) :
    HoldsW (m.storeAt (W.add (BitVec.ofNat 64 (8 * n))) (f n)) W f (n + 1) := by
  intro t ht
  by_cases e : t = n
  · subst e
    exact MemoryState.readAt_storeAt_self (fits_slot hWo hN hf hn) _
  · rw [MemoryState.readAt_storeAt_disjoint]
    · exact h t (by omega)
    · simp only [Range.Disjoint, Range.of, slot_offsetInBits hWo (show n < 2 ^ 58 by omega),
        slot_offsetInBits hWo (show t < 2 ^ 58 by omega)]
      omega

theorem fits_stores {m : MemoryState} : Fits (stores W f i n m) p w ↔ Fits m p w := by
  induction n generalizing i m with
  | zero => rfl
  | succ n ih => simp [stores, ih]

/-- `stores` extends what `W` holds. -/
theorem HoldsW.stores {N : Nat} {m : MemoryState} {W : Pointer} {f : Nat → BitVec 64}
    (hWo : W.offset = 0) (hN : N < 2 ^ 58) :
    ∀ n i, Fits m W (64 * N) → HoldsW m W f i → i + n ≤ N → HoldsW (stores W f i n m) W f (i + n) := by
  intro n
  induction n generalizing m with
  | zero => intro i _ h _; exact h
  | succ n ih =>
    intro i hf h hn
    rw [show i + (n + 1) = i + 1 + n by omega]
    exact ih (i + 1) hf.storeAt (h.store hWo hN hf (by omega)) (by omega)

theorem sub_facts {i k c : Nat} (hc : c + k = 2 ^ 64) (hk : k ≤ i) (hk' : k ≤ 16) (hi : i < 2 ^ 60) :
    (BitVec.ofNat 64 i).saddOverflow (BitVec.ofNat 64 c) = false ∧
      BitVec.ofNat 64 i + BitVec.ofNat 64 c = BitVec.ofNat 64 (i - k) ∧
      (i - k) % 18446744073709551616 = i - k ∧ (i - k) * 8 = 8 * (i - k) ∧
      8 * (i - k) < 18446744073709551616 := by
  refine ⟨?_, ?_, by omega, by omega, by omega⟩
  · have h1 : (BitVec.ofNat 64 i).toInt = i := by
      rw [BitVec.toInt_eq_toNat_of_lt] <;> simp <;> omega
    have h2 : (BitVec.ofNat 64 c).toInt = -(k : Int) := by
      rw [BitVec.toInt_eq_toNat_bmod]; simp [Int.bmod]; omega
    simp [BitVec.saddOverflow, h1, h2]; omega
  · apply BitVec.eq_of_toNat_eq; simp; omega

theorem rotl_63 (x : BitVec 64) : rotl x 63 = x.rotateRight 1 := by bv_decide
theorem rotl_56 (x : BitVec 64) : rotl x 56 = x.rotateRight 8 := by bv_decide
theorem rotl_45 (x : BitVec 64) : rotl x 45 = x.rotateRight 19 := by bv_decide
theorem rotl_3 (x : BitVec 64) : rotl x 3 = x.rotateRight 61 := by bv_decide

/-- A schedule word as the code computes it. -/
theorem sched_eq (x16 x7 x15 x2 : BitVec 64) :
    x7 + x16 + ((rotl x15 63 ^^^ rotl x15 56) ^^^ x15 >>> 7) + ((rotl x2 45 ^^^ rotl x2 3) ^^^ x2 >>> 6) =
      Sha512.sigma1 x2 + x7 + Sha512.sigma0 x15 + x16 := by
  simp only [rotl_63, rotl_56, rotl_45, rotl_3, Sha512.sigma0, Sha512.sigma1]
  ac_rfl

set_option maxHeartbeats 0 in
/-- `bb4`, round `i` of the schedule: `W[i]` from `W[i - 16]`, `W[i - 15]`, `W[i - 7]`, `W[i - 2]`. -/
theorem loop2_iter (dd blk V W : Pointer) (Wf : Nat → BitVec 64) {β : Type}
    (κ : Vals [] × GlobalState → PoisonOr β) (R : PoisonOr β) (hWo : W.offset = 0)
    (hrec : Wf i = Sha512.sigma1 (Wf (i - 2)) + Wf (i - 7) + Sha512.sigma0 (Wf (i - 15)) + Wf (i - 16))
    (S : GlobalState) (E : ⟪Γ⟫) (hi : 16 ≤ i) (hi' : i < 80)
    (hArgs : E.args = (Sha512_round.args (.value dd) (.value blk)).get) (hc : Consts E)
    (hR : E ⊨ [%102 := V, %103 := W, %112 := BitVec.ofNat 64 i]) (hwf : S.WF)
    (hWf : Fits S.mem W 5120)
    (r16 : S.mem.readAt (W.add (BitVec.ofNat 64 (8 * (i - 16)))) 64 = Wf (i - 16))
    (r7 : S.mem.readAt (W.add (BitVec.ofNat 64 (8 * (i - 7)))) 64 = Wf (i - 7))
    (r15 : S.mem.readAt (W.add (BitVec.ofNat 64 (8 * (i - 15)))) 64 = Wf (i - 15))
    (r2 : S.mem.readAt (W.add (BitVec.ofNat 64 (8 * (i - 2)))) 64 = Wf (i - 2))
    (hK : ∀ E' : ⟪Γ⟫, E'.args = (Sha512_round.args (.value dd) (.value blk)).get → Consts E' →
      (E' ⊨ [%102 := V, %103 := W, %112 := BitVec.ofNat 64 (i + 1)]) →
      (Sha512_round.runFrom E' 3
        { S with mem := S.mem.storeAt (W.add (BitVec.ofNat 64 (8 * i))) (Wf i) } >>= κ) = R) :
    (Sha512_round.runFrom E 4 S >>= κ) = R := by
  obtain ⟨-, -, -, h4, h5, -, h7⟩ := shl3_facts (i := i) (by omega)
  obtain ⟨o1, o2⟩ := counter_overflow (i := i) (by omega)
  obtain ⟨a1, a2, a3, a4, a5⟩ :=
    sub_facts (i := i) (k := 16) (c := 18446744073709551600) rfl hi (by omega) (by omega)
  obtain ⟨b1, b2, b3, b4, b5⟩ :=
    sub_facts (i := i) (k := 7) (c := 18446744073709551609) rfl (by omega) (by omega) (by omega)
  obtain ⟨c1, c2, c3, c4, c5⟩ :=
    sub_facts (i := i) (k := 15) (c := 18446744073709551601) rfl (by omega) (by omega) (by omega)
  obtain ⟨d1, d2, d3, d4, d5⟩ :=
    sub_facts (i := i) (k := 2) (c := 18446744073709551614) rfl (by omega) (by omega) (by omega)
  have f16 := fits_slot (N := 80) hWo (by decide) hWf (t := i - 16) (by omega)
  have f7 := fits_slot (N := 80) hWo (by decide) hWf (t := i - 7) (by omega)
  have f15 := fits_slot (N := 80) hWo (by decide) hWf (t := i - 15) (by omega)
  have f2 := fits_slot (N := 80) hWo (by decide) hWf (t := i - 2) (by omega)
  have fi := fits_slot (N := 80) hWo (by decide) hWf (t := i) (by omega)
  block_init
  step_pure [h4, h5, h7]
  step_pure [a1, a2]
  step_pure [a1, a2, a3, a4, a5]
  step_load consuming r16 f16
  step_pure [b1, b2]
  step_pure [b1, b2, b3, b4, b5]
  step_load consuming r7 f7
  step_pure
  step_pure [c1, c2]
  step_pure [c1, c2, c3, c4, c5]
  step_load consuming r15 f15
  iterate 6 step_pure
  step_pure [d1, d2]
  step_pure [d1, d2, d3, d4, d5]
  step_load consuming r2 f2
  iterate 6 step_pure
  step_store consuming fi
  step_pure [o1, o2, ← BitVec.ofNat_add]
  finish_block
  subst hS
  rw [sched_eq, ← hrec]
  exact hK E hArgs (by env_reads) (by env_reads)

set_option maxHeartbeats 0 in
/-- `bb3`/`bb4` from round `i`, `m` left: the schedule's words `16 … 79` into `W`. -/
theorem loop2 (dd blk V W : Pointer) (Wf : Nat → BitVec 64) {β : Type}
    (κ : Vals [] × GlobalState → PoisonOr β) (R : PoisonOr β) (hWo : W.offset = 0)
    (hrec : ∀ t, 16 ≤ t → t < 80 →
      Wf t = Sha512.sigma1 (Wf (t - 2)) + Wf (t - 7) + Sha512.sigma0 (Wf (t - 15)) + Wf (t - 16)) :
    ∀ m i (S : GlobalState) (E : ⟪Γ⟫), i + m = 80 → 16 ≤ i →
      E.args = (Sha512_round.args (.value dd) (.value blk)).get → Consts E →
      (E ⊨ [%102 := V, %103 := W, %112 := BitVec.ofNat 64 i]) → S.WF →
      Fits S.mem W 5120 → HoldsW S.mem W Wf i →
      (∀ E' : ⟪Γ⟫, E'.args = (Sha512_round.args (.value dd) (.value blk)).get → Consts E' →
        (E' ⊨ [%102 := V, %103 := W]) →
        (Sha512_round.runFrom E' 5 { S with mem := stores W Wf i m S.mem } >>= κ) = R) →
      (Sha512_round.runFrom E 3 S >>= κ) = R := by
  intro m
  induction m with
  | zero =>
    intro i S E hi _ hArgs hc hR hwf hWf hH hK
    obtain rfl : i = 80 := by omega
    block_init
    step_pure
    finish_block
    step_loop using hK
    env_reads
  | succ m ih =>
    intro i S E hi hi16 hArgs hc hR hwf hWf hH hK
    block_init
    step_pure
    finish_block
    · exfalso
      have := congrArg BitVec.toNat hbr
      simp at this
      omega
    · refine loop2_iter dd blk V W Wf κ R hWo (hrec i hi16 (by omega)) S E hi16 (by omega) hArgs
        (by env_reads) (by env_reads) hwf hWf (hH _ (by omega)) (hH _ (by omega)) (hH _ (by omega))
        (hH _ (by omega)) fun E' h1 h2 h3 => ?_
      exact ih (i + 1) _ E' (by omega) (by omega) h1 h2 h3 hwf.storeAt hWf.storeAt
        (hH.store (N := 80) hWo (by decide) hWf (by omega)) fun E'' g1 g2 g3 => hK E'' g1 g2 g3

set_option maxHeartbeats 0 in
/-- `bb7`, word `i`: `state[i] += V[i]`. -/
theorem loop3_iter (dd blk V : Pointer) (i : Nat) (x y : BitVec 64) {β : Type}
    (κ : Vals [] × GlobalState → PoisonOr β) (R : PoisonOr β) (hVo : V.offset = 0)
    (hdo : dd.offset.toNat + 80 < 2 ^ 64) (S : GlobalState) (E : ⟪Γ⟫) (hi : i < 8)
    (hArgs : E.args = (Sha512_round.args (.value dd) (.value blk)).get) (hc : Consts E)
    (hR : E ⊨ [%102 := V, %141 := dd.add 16#64, rir_reg% hty 2243 := BitVec.ofNat 64 i])
    (hwf : S.WF) (hVf : Fits S.mem V 512)
    (hDf : Fits S.mem (dd.add (16#64 + BitVec.ofNat 64 (8 * i))) 64)
    (rv : S.mem.readAt (V.add (BitVec.ofNat 64 (8 * i))) 64 = y)
    (rd : S.mem.readAt (dd.add (16#64 + BitVec.ofNat 64 (8 * i))) 64 = x)
    (hK : ∀ E' : ⟪Γ⟫, E'.args = (Sha512_round.args (.value dd) (.value blk)).get → Consts E' →
      (E' ⊨ [%102 := V, %141 := dd.add 16#64, rir_reg% hty 2243 := BitVec.ofNat 64 (i + 1)]) →
      (Sha512_round.runFrom E' 6
        { S with mem := S.mem.storeAt (dd.add (16#64 + BitVec.ofNat 64 (8 * i))) (x + y) } >>= κ) =
        R) :
    (Sha512_round.runFrom E 7 S >>= κ) = R := by
  obtain ⟨-, -, -, h4, h5, -, h7⟩ := shl3_facts (i := i) (by omega)
  obtain ⟨o1, o2⟩ := counter_overflow (i := i) (by omega)
  have fv := Fits.add_of_le (p := V) (off := BitVec.ofNat 64 (8 * i)) (w := 64)
    (by simp [BitVec.uaddOverflow, hVo]; omega) (by simp; omega) hVf
  block_init
  step_pure [h4, h5, h7]
  step_pure [h4, h5, h7]
  step_load consuming rv fv
  step_load consuming rd
  step_pure
  step_store consuming hDf
  step_pure [o1, o2, ← BitVec.ofNat_add]
  finish_block
  subst hS
  exact hK E hArgs (by env_reads) (by env_reads)

set_option maxHeartbeats 0 in
/-- `bb6`/`bb7` from word `i`, `m` left: `state[i] += V[i]`, then the return. -/
theorem loop3 (dd blk V : Pointer) (Hf vf : Nat → BitVec 64) {β : Type}
    (κ : Vals [] × GlobalState → PoisonOr β) (R : PoisonOr β) (hVo : V.offset = 0)
    (hdo : dd.offset.toNat + 80 < 2 ^ 64) (hVd : V.id ≠ dd.id) :
    ∀ m i (S : GlobalState) (E : ⟪Γ⟫), i + m = 8 →
      E.args = (Sha512_round.args (.value dd) (.value blk)).get → Consts E →
      (E ⊨ [%102 := V, %141 := dd.add 16#64, rir_reg% hty 2243 := BitVec.ofNat 64 i]) → S.WF →
      Fits S.mem V 512 → (∀ j, j < 8 → Fits S.mem (dd.add (16#64 + BitVec.ofNat 64 (8 * j))) 64) →
      (∀ j, i ≤ j → j < 8 → S.mem.readAt (V.add (BitVec.ofNat 64 (8 * j))) 64 = vf j) →
      (∀ j, i ≤ j → j < 8 → S.mem.readAt (dd.add (16#64 + BitVec.ofNat 64 (8 * j))) 64 = Hf j) →
      κ (.nil, { S with mem := Sha512Obj.storeWords dd (fun j => Hf j + vf j) i m S.mem }) = R →
      (Sha512_round.runFrom E 6 S >>= κ) = R := by
  intro m
  induction m with
  | zero =>
    intro i S E hi hArgs hc hR hwf hVf hDf hv hd hfin
    obtain rfl : i = 8 := by omega
    block_init
    step_pure
    finish_block
    block_init
    finish_block
    exact hfin
  | succ m ih =>
    intro i S E hi hArgs hc hR hwf hVf hDf hv hd hfin
    block_init
    step_pure
    finish_block
    · exfalso
      have := congrArg BitVec.toNat hbr
      simp at this
      omega
    · refine loop3_iter dd blk V i (Hf i) (vf i) κ R hVo hdo S E (by omega) hArgs (by env_reads)
        (by env_reads) hwf hVf (hDf i (by omega)) (hv i (by omega) (by omega))
        (hd i (by omega) (by omega)) fun E' h1 h2 h3 => ?_
      refine ih (i + 1) _ E' (by omega) h1 h2 h3 hwf.storeAt hVf.storeAt (fun j hj => (hDf j hj).storeAt)
        (fun j hj hj' => ?_) (fun j hj hj' => ?_) hfin
      · rw [MemoryState.readAt_storeAt_disjoint (Range.disjoint_of_id_ne (by simpa using hVd.symm))]
        exact hv j (by omega) hj'
      · rw [MemoryState.readAt_storeAt_disjoint]
        · exact hd j (by omega) hj'
        · simp only [Range.Disjoint, Range.of, Pointer.offsetInBits, Pointer.add, BitVec.toNat_add,
            BitVec.toNat_ofNat]
          omega

/-! ## Memory through the loops -/

theorem readAt_stores_ne {m : MemoryState} (h : q.id ≠ W.id) :
    ∀ n i, (stores W f i n m).readAt q w = m.readAt q w := by
  intro n
  induction n generalizing m with
  | zero => intro _; rfl
  | succ n ih =>
    intro i
    rw [stores, ih, MemoryState.readAt_storeAt_disjoint (Range.disjoint_of_id_ne (by simpa using h.symm))]

theorem wf_stores {s : GlobalState} :
    ∀ n i (m : MemoryState), ({ s with mem := m } : GlobalState).WF →
      ({ s with mem := stores W f i n m } : GlobalState).WF := by
  intro n
  induction n with
  | zero => intro _ _ h; exact h
  | succ n ih => intro i m h; exact ih (i + 1) _ (GlobalState.WF_storeAt.2 h)

theorem eraseFrom_stores {m : MemoryState} (h : k ≤ W.id.id) :
    ∀ n i, (stores W f i n m).eraseFrom k = m.eraseFrom k := by
  intro n
  induction n generalizing m with
  | zero => intro _; rfl
  | succ n ih =>
    intro i
    rw [stores, ih, MemoryState.eraseFrom_storeAt_of_le (by simpa using h)]

theorem HoldsW.congr {m : MemoryState} {f g : Nat → BitVec 64} (h : HoldsW m W f n)
    (hfg : ∀ t, t < n → f t = g t) : HoldsW m W g n := fun t ht => (h t ht).trans (hfg t ht)

theorem holdsW_zero {m : MemoryState} : HoldsW m W f 0 := fun _ h => absurd h (by omega)

theorem storeWords8_eq (m : MemoryState) (V : Pointer) (v : Vector (BitVec 64) 8) :
    storeWords8 m V v = stores V (fun k => v[k]!) 0 8 m := by
  simp [storeWords8, stores]

/-! ## The spec's words -/

theorem bswapv_eq (x : BitVec 64) :
    bswapv x = x.extractLsb' 0 8 ++ x.extractLsb' 8 8 ++ x.extractLsb' 16 8 ++ x.extractLsb' 24 8 ++
      x.extractLsb' 32 8 ++ x.extractLsb' 40 8 ++ x.extractLsb' 48 8 ++ x.extractLsb' 56 8 := by
  simp only [bswapv, List.range, List.range.loop, List.foldl]
  bv_decide

/-- Block word `t`, big-endian: the code's byte swap of its little-endian load. -/
theorem word_eq (B : BitVec 1024) (ht : t < 16) :
    Sha512.word (bytesLE B) t = bswapv (B.extractLsb' (64 * t) 64) := by
  have e (b : Nat) (hb : b + 8 ≤ 64) :
      (B.extractLsb' (64 * t) 64).extractLsb' b 8 = B.extractLsb' (64 * t + b) 8 := by
    apply BitVec.eq_of_getLsbD_eq
    intro j hj
    simp [BitVec.getLsbD_extractLsb', show b + j < 64 by omega, Nat.add_assoc]
  simp (disch := omega) only [Sha512.word, getElem!_bytesLE, bswapv_eq, e]
  rw [show 8 * (8 * t) = 64 * t + 0 by omega, show 8 * (8 * t + 1) = 64 * t + 8 by omega,
    show 8 * (8 * t + 2) = 64 * t + 16 by omega, show 8 * (8 * t + 3) = 64 * t + 24 by omega,
    show 8 * (8 * t + 4) = 64 * t + 32 by omega, show 8 * (8 * t + 5) = 64 * t + 40 by omega,
    show 8 * (8 * t + 6) = 64 * t + 48 by omega, show 8 * (8 * t + 7) = 64 * t + 56 by omega]

/-- The compression's word `j`: the state word plus the rounds'. -/
theorem compress_getElem (H : Vector (BitVec 64) 8) (B : List (BitVec 8)) (hj : j < 8) :
    (Sha512.compress H B)[j] = H[j] + (rounds (fun t => (Sha512.schedule B)[t]!) 0 80 H)[j] := by
  simp only [Sha512.compress, rounds, Vector.getElem_zipWith, List.range_eq_range']

theorem storeWords_congr {m : MemoryState} {f g : Nat → BitVec 64} :
    ∀ n i, (∀ j, i ≤ j → j < i + n → f j = g j) →
      Sha512Obj.storeWords d f i n m = Sha512Obj.storeWords d g i n m := by
  intro n
  induction n generalizing m with
  | zero => intro _ _; rfl
  | succ n ih =>
    intro i h
    simp only [Sha512Obj.storeWords]
    rw [h i (by omega) (by omega)]
    exact ih (i + 1) fun j h1 h2 => h j (by omega) (by omega)

theorem compress_getElem! (H : Vector (BitVec 64) 8) (B : List (BitVec 8)) (hj : j < 8) :
    (Sha512.compress H B)[j]! = H[j]! + (rounds (fun t => (Sha512.schedule B)[t]!) 0 80 H)[j]! := by
  rw [getElem!_pos (Sha512.compress H B) j hj, getElem!_pos H j hj,
    getElem!_pos (rounds _ 0 80 H) j hj]
  exact compress_getElem H B hj

end Sha512_round

open Sha512_round in
set_option maxHeartbeats 0 in
/-- `Sha512.round` compresses the 128-byte block at `b` into the state words of the object at `d`
(FIPS 180-4 `Sha512.compress`, the block's bytes in memory order); its frame takes two blocks. -/
public theorem Sha512_round.call_eq (d b : Pointer) (s : GlobalState) (hwf : s.WF)
    (hdf : Fits s.mem d 640) (hdo : d.offset.toNat + 80 < 2 ^ 64) (hbf : Fits s.mem b 1024)
    (hbo : b.offset.toNat + 128 < 2 ^ 64) :
    Sha512_round.call (Sha512_round.args (.value d) (.value b)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 2⟩
            mem :=
              Sha512Obj.setState s.mem d
                (Sha512.compress (Sha512Obj.state s.mem d) (bytesLE (s.mem.readAt b 1024))) }) := by
  func_init
  block_init
  iterate 102 step_pure
  step_alloca with V
  step_alloca with W
  finish_block
  have hfit (k : Nat) (hk : k + 8 ≤ 80) : Fits S₀.mem (d.add (BitVec.ofNat 64 k)) 64 :=
    Fits.add_of_le (by simp [BitVec.uaddOverflow]; omega) (by simp; omega) hdf₀
  have hfitS (k : Nat) (hk : k + 8 ≤ 80) : Fits S.mem (d.add (BitVec.ofNat 64 k)) 64 := by
    rw [hS]; exact ((hfit k hk).alloca hwf₀).alloca hwf₀.alloca
  have hrd (q : Pointer) (w : Nat) (hq : Fits S₀.mem q w) : S.mem.readAt q w = S₀.mem.readAt q w := by
    rw [hS, MemoryState.readAt_alloca hwf₀.alloca (hq.alloca hwf₀), MemoryState.readAt_alloca hwf₀ hq]
  generalize hBd : S₀.mem.readAt b 1024 = B
  have hB : S.mem.readAt b 1024 = B := (hrd b 1024 hbf₀).trans hBd
  refine loop1 d b V W B _ _ hW_off hbo hb_ne_W.symm 16 0 S E rfl hArgs (by env_reads)
    (by env_reads) hwf hW_fits hbf hB fun E1 hA1 hc1 hR1 => ?_
  have h16 : HoldsW (stores W (fun t => bswapv (B.extractLsb' (64 * t) 64)) 0 16 S.mem) W
      (fun t => (Sha512.schedule (bytesLE B))[t]!) 16 :=
    (HoldsW.stores (N := 80) hW_off (by decide) 16 0 hW_fits holdsW_zero (by omega)).congr
      fun t ht => by simp only [Sha512.getElem!_schedule_lt _ ht, word_eq B ht]
  refine loop2 d b V W (fun t => (Sha512.schedule (bytesLE B))[t]!) _ _ hW_off (fun t h1 h2 => Sha512.getElem!_schedule_ge _ h1 h2) 64 16 _ E1
    rfl (Nat.le_refl _) hA1 hc1 hR1 (wf_stores 16 0 _ hwf) (fits_stores.2 hW_fits) h16
    fun E2 hA2 hc2 hR2 => ?_
  -- the words the rounds read and write, as `s` holds them
  have hrd2 (k : Nat) (hk : k + 8 ≤ 80) :
      (stores W (fun t => (Sha512.schedule (bytesLE B))[t]!) 16 64
          (stores W (fun t => bswapv (B.extractLsb' (64 * t) 64)) 0 16 S.mem)).readAt
        (d.add (BitVec.ofNat 64 k)) 64 = S₀.mem.readAt (d.add (BitVec.ofNat 64 k)) 64 := by
    rw [readAt_stores_ne (by simpa using hd_ne_W), readAt_stores_ne (by simpa using hd_ne_W),
      hrd _ _ (hfit k hk)]
  have hW80 := HoldsW.stores (N := 80) hW_off (by decide) 64 16 (fits_stores.2 hW_fits) h16 (by omega)
  refine block5 d b V W (fun t => (Sha512.schedule (bytesLE B))[t]!) _ _ _ _ _ _ _ _ E2 _ _ _ hA2 hc2
    hR2 hdo (fits_stores.2 (fits_stores.2 (hfitS 16 (by omega))))
    (fits_stores.2 (fits_stores.2 (hfitS 24 (by omega))))
    (fits_stores.2 (fits_stores.2 (hfitS 32 (by omega))))
    (fits_stores.2 (fits_stores.2 (hfitS 40 (by omega))))
    (fits_stores.2 (fits_stores.2 (hfitS 48 (by omega))))
    (fits_stores.2 (fits_stores.2 (hfitS 56 (by omega))))
    (fits_stores.2 (fits_stores.2 (hfitS 64 (by omega))))
    (fits_stores.2 (fits_stores.2 (hfitS 72 (by omega))))
    (hrd2 16 (by omega)) (hrd2 24 (by omega)) (hrd2 32 (by omega)) (hrd2 40 (by omega))
    (hrd2 48 (by omega)) (hrd2 56 (by omega)) (hrd2 64 (by omega)) (hrd2 72 (by omega))
    hW_off (fits_stores.2 (fits_stores.2 hW_fits)) hV_off (fits_stores.2 (fits_stores.2 hV_fits))
    hW80 fun E3 hA3 hc3 hR3 => ?_
  refine loop3 d b V (fun j => (Sha512Obj.state S₀.mem d)[j]!)
    (fun j => (rounds (fun t => (Sha512.schedule (bytesLE B))[t]!) 0 80
      #v[S₀.mem.readAt (d.add 16#64) 64, S₀.mem.readAt (d.add 24#64) 64, S₀.mem.readAt (d.add 32#64) 64, S₀.mem.readAt (d.add 40#64) 64, S₀.mem.readAt (d.add 48#64) 64, S₀.mem.readAt (d.add 56#64) 64, S₀.mem.readAt (d.add 64#64) 64, S₀.mem.readAt (d.add 72#64) 64])[j]!)
    _ _ hV_off hdo hd_ne_V.symm 8 0 _ E3 rfl hA3 hc3 ⟨hR3.2.1, hR3.2.2, hR3.1⟩ ?_ ?_ ?_ ?_ ?_ ?_
  · dsimp only
    rw [storeWords8_eq]
    exact wf_stores 8 0 _ (wf_stores 64 16 _ (wf_stores 16 0 _ hwf))
  · dsimp only
    rw [storeWords8_eq]
    exact fits_stores.2 (fits_stores.2 (fits_stores.2 hV_fits))
  · intro j hj
    dsimp only
    rw [storeWords8_eq]
    refine fits_stores.2 (fits_stores.2 (fits_stores.2 ?_))
    rw [hS]
    refine ((Fits.add_of_le ?_ ?_ hdf₀).alloca hwf₀).alloca hwf₀.alloca
    · simp [BitVec.uaddOverflow]; omega
    · simp; omega
  · intro j _ hj
    dsimp only
    rw [storeWords8_eq]
    exact HoldsW.stores (N := 8) hV_off (by decide) 8 0
      (fits_stores.2 (fits_stores.2 hV_fits)) holdsW_zero (by omega) j hj
  · intro j _ hj
    dsimp only
    have hf : Fits S₀.mem (d.add (16#64 + BitVec.ofNat 64 (8 * j))) 64 := by
      refine Fits.add_of_le ?_ ?_ hdf₀
      · simp [BitVec.uaddOverflow]; omega
      · simp; omega
    rw [storeWords8_eq, readAt_stores_ne (by simpa using hd_ne_V), readAt_stores_ne (by simpa using hd_ne_W),
      readAt_stores_ne (by simpa using hd_ne_W), hrd _ _ hf]
    simp [Sha512Obj.state, hj]
  · have hstate : Sha512Obj.state S₀.mem d = #v[S₀.mem.readAt (d.add 16#64) 64, S₀.mem.readAt (d.add 24#64) 64, S₀.mem.readAt (d.add 32#64) 64, S₀.mem.readAt (d.add 40#64) 64, S₀.mem.readAt (d.add 48#64) 64, S₀.mem.readAt (d.add 56#64) 64, S₀.mem.readAt (d.add 64#64) 64, S₀.mem.readAt (d.add 72#64) 64] := rfl
    have hWn : S₀.alloc.nextFreeBlock ≤ W.id.id := by rw [hW]; simp [GlobalState.slot]
    have hVn : S₀.alloc.nextFreeBlock ≤ V.id.id := by rw [hV]; simp [GlobalState.slot]
    dsimp only
    rw [Sha512Obj.eraseFrom_storeWords, storeWords8_eq, eraseFrom_stores hVn, eraseFrom_stores hWn,
      eraseFrom_stores hWn, hS, GlobalState.eraseFrom_alloca_of_le (by simp [GlobalState.alloca]),
      GlobalState.eraseFrom_alloca_of_le (Nat.le_refl _), hwf₀.eraseFrom, ← hstate]
    rw [storeWords_congr (g := fun j => (Sha512.compress (Sha512Obj.state S₀.mem d) (bytesLE B))[j]!) 8 0]
    · rfl
    · intro j _ hj
      have hj8 : j < 8 := by omega
      exact (compress_getElem! _ _ hj8).symm
