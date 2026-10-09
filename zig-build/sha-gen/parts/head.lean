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

