module

public import MLIR.Run.Tactic
public import Ed25519.Sha512
public import Zig.Common.Sha512
public import Zig.Mlir.Sha512_round
import Std.Tactic.BVDecide

/-! `Sha512.round`, one block's compression: FIPS 180-4 `Sha512.compress` of the object's state
words and the block's bytes. `W` is Zig's schedule `s`, `V` its working variables `v`. `^bb5`
unrolls the 80 rounds: `0 … 3` stepped, `4 … 79` one pattern. -/

namespace MLIR.Zig

open _root_.Ed25519

namespace Sha512_round

set_option hygiene false in
/-- Rounds `t … u` of `^bb5`, each by `runBodyFrom_roundRun` on `W[t]`'s facts, `hv` advanced. -/
local macro "round_sites " t:num u:num : tactic => do
  let mut tacs : Array (Lean.TSyntax `tactic) := #[]
  for k in [t.getNat:u.getNat + 1] do
    let k' := Lean.Syntax.mkNumLit (toString k)
    let k1 := Lean.Syntax.mkNumLit (toString (k + 1))
    tacs :=
      tacs.push
        (←
          `(tactic|
              ( have hwk := hS ▸ hw $k' (by decide)
                have hfk := hS ▸ hf $k' (by decide)
                step_pattern using (runBodyFrom_roundRun $k')
                replace hv : rounds Wf 0 $k1 _ = _ := rounds_step hv hr
                clear hr hwk hfk)))
  `(tactic| ($[$tacs]*))

/-! ## The rounds' arithmetic -/

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
abbrev S1 (e : BitVec 64) : BitVec 64 :=
  (rotl e 50 ^^^ rotl e 46) ^^^ rotl e 23

/-- `Σ₀` as the code computes it. -/
abbrev S0 (a : BitVec 64) : BitVec 64 :=
  (rotl a 36 ^^^ rotl a 30) ^^^ rotl a 25

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
      #v[(((c ||| b) &&& a) ||| (c &&& b)) + S0 a +
          ((((S1 e + k) + h) + w) + (((g ^^^ f) &&& e) ^^^ g)),
        a, b, c, ((((S1 e + k) + h) + w) + (((g ^^^ f) &&& e) ^^^ g)) + d, e, f, g] := by
  apply round_of <;> simp only [S1_eq, S0_eq, ch0, maj0] <;> ac_rfl

/-- Round `1`'s order of operations. -/
theorem round_eq1 (a b c d e f g h k w : BitVec 64) :
    Sha512.round #v[a, b, c, d, e, f, g, h] k w =
      #v[S0 a + ((a &&& (c ||| b)) ||| (c &&& b)) +
          ((((h + k) + w) + ((e &&& (g ^^^ f)) ^^^ g)) + S1 e),
        a, b, c, ((((h + k) + w) + ((e &&& (g ^^^ f)) ^^^ g)) + S1 e) + d, e, f, g] := by
  apply round_of <;> simp only [S1_eq, S0_eq, ch1, maj1] <;> ac_rfl

/-- Rounds `2`, `3`'s order of operations. -/
theorem round_eq2 (a b c d e f g h k w : BitVec 64) :
    Sha512.round #v[a, b, c, d, e, f, g, h] k w =
      #v[S0 a + ((a &&& (b ||| c)) ||| (b &&& c)) +
          ((((h + k) + w) + ((e &&& (f ^^^ g)) ^^^ g)) + S1 e),
        a, b, c, ((((h + k) + w) + ((e &&& (f ^^^ g)) ^^^ g)) + S1 e) + d, e, f, g] := by
  apply round_of <;> simp only [S1_eq, S0_eq, ch2, maj2] <;> ac_rfl

/-- Rounds `4 … 79`'s order of operations. -/
theorem round_eq4 (a b c d e f g h k w : BitVec 64) :
    Sha512.round #v[a, b, c, d, e, f, g, h] k w =
      #v[S0 a + ((a &&& (b ||| c)) ||| (b &&& c)) +
          ((((w + k) + h) + ((e &&& (f ^^^ g)) ^^^ g)) + S1 e),
        a, b, c, ((((w + k) + h) + ((e &&& (f ^^^ g)) ^^^ g)) + S1 e) + d, e, f, g] := by
  apply round_of <;> simp only [S1_eq, S0_eq, ch2, maj2] <;> ac_rfl

/-- Rounds `t0 … t0 + n - 1` on the working variables `v`, `Wf t` the schedule's word `t`. -/
def rounds (Wf : Nat → BitVec 64) (t0 n : Nat) (v : Vector (BitVec 64) 8) : Vector (BitVec 64) 8 :=
  (List.range' t0 n).foldl (fun v t => Sha512.round v Sha512.K[t]! (Wf t)) v

/-- Round `t` after rounds `0 … t - 1`. -/
theorem rounds_step {Wf : Nat → BitVec 64} {v x y : Vector (BitVec 64) 8} {t : Nat}
    (hv : rounds Wf 0 t v = x) (hr : Sha512.round x Sha512.K[t]! (Wf t) = y) :
    rounds Wf 0 (t + 1) v = y := by
  simp only [rounds, ← List.range'_append_1, List.foldl_append] at hv ⊢
  rw [hv]
  simpa using hr

/-! ## Rounds `4 … 79` -/

/-- A round `t ≥ 4` of `^bb5`: `Σ₁(e)`, `Ch(e, f, g)`, the load of `W[t]` at `w + off`,
`T1 = W[t] + K[t] + h + Ch + Σ₁`, `e' = T1 + d`, `Σ₀(a)`, `Maj(a, b, c)`, `a' = Σ₀ + Maj + T1`. -/
def roundRun (ra rb rc rd re rf rg rh k50 k46 k23 k36 k30 k25 kt : Dst Γ (.bv 64)) (w : Reg Γ .ptr)
    (off : Int) (s0 s1 s2 s3 s4 c0 c1 ch : Dst Γ (.bv 64)) (p : Dst Γ .ptr)
    (x t0 t1 t2 t e' z0 z1 z2 z3 z4 m0 m1 m2 m3 u a' : Dst Γ (.bv 64)) : List (Instr Γ) :=
  [.ternop .fshl s0 (.val re.i re.h) (.val re.i re.h) (.val k50.i k50.h),
    .ternop .fshl s1 (.val re.i re.h) (.val re.i re.h) (.val k46.i k46.h),
    .binop .xor s2 (.val s0.i s0.h) (.val s1.i s1.h),
    .ternop .fshl s3 (.val re.i re.h) (.val re.i re.h) (.val k23.i k23.h),
    .binop .xor s4 (.val s2.i s2.h) (.val s3.i s3.h),
    .binop .xor c0 (.val rf.i rf.h) (.val rg.i rg.h),
    .binop .and c1 (.val re.i re.h) (.val c0.i c0.h),
    .binop .xor ch (.val c1.i c1.h) (.val rg.i rg.h),
    .unop (.gepConst { nusw := true, nuw := true } off) p w,
    .load x (.val p.i p.h), .binop (.add {}) t0 (.val x.i x.h) (.val kt.i kt.h),
    .binop (.add {}) t1 (.val t0.i t0.h) (.val rh.i rh.h),
    .binop (.add {}) t2 (.val t1.i t1.h) (.val ch.i ch.h),
    .binop (.add {}) t (.val t2.i t2.h) (.val s4.i s4.h),
    .binop (.add {}) e' (.val t.i t.h) (.val rd.i rd.h),
    .ternop .fshl z0 (.val ra.i ra.h) (.val ra.i ra.h) (.val k36.i k36.h),
    .ternop .fshl z1 (.val ra.i ra.h) (.val ra.i ra.h) (.val k30.i k30.h),
    .binop .xor z2 (.val z0.i z0.h) (.val z1.i z1.h),
    .ternop .fshl z3 (.val ra.i ra.h) (.val ra.i ra.h) (.val k25.i k25.h),
    .binop .xor z4 (.val z2.i z2.h) (.val z3.i z3.h),
    .binop (.or false) m0 (.val rb.i rb.h) (.val rc.i rc.h),
    .binop .and m1 (.val ra.i ra.h) (.val m0.i m0.h),
    .binop .and m2 (.val rb.i rb.h) (.val rc.i rc.h),
    .binop (.or false) m3 (.val m1.i m1.h) (.val m2.i m2.h),
    .binop (.add {}) u (.val z4.i z4.h) (.val m3.i m3.h),
    .binop (.add {}) a' (.val u.i u.h) (.val t.i t.h)]

/-- Where the body at `pos` is `roundRun`, round `tt` on `#v[A, …, H]` reading `W[tt]` at
`Wp + 8 tt`: running on from `pos` then `g` gives `K` if it does from `pos + 26` with the round's
new words `A'`, `E'` in `a'`, `e'`. -/
theorem runBodyFrom_roundRun {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {ra rb rc rd re rf rg rh k50 k46 k23 k36 k30 k25 kt : Dst Γ (.bv 64)} {w : Reg Γ .ptr}
    {off : Int} {s0 s1 s2 s3 s4 c0 c1 ch : Dst Γ (.bv 64)} {p : Dst Γ .ptr}
    {x t0 t1 t2 t e' z0 z1 z2 z3 z4 m0 m1 m2 m3 u a' : Dst Γ (.bv 64)} {rest : List (Instr Γ)}
    {A B C D Ee F G H Kt Wt : BitVec 64} {Wp : Pointer} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β} (tt : Nat)
    (hbody :
      blk.body.drop pos =
        roundRun ra rb rc rd re rf rg rh k50 k46 k23 k36 k30 k25 kt w off s0 s1 s2 s3 s4 c0 c1 ch p
            x t0 t1 t2 t e' z0 z1 z2 z3 z4 m0 m1 m2 m3 u a' ++
          rest)
    (hR :
      E ⊨ [ra := A, rb := B, rc := C, rd := D, re := Ee, rf := F, rg := G, rh := H, k50 := 50#64,
        k46 := 46#64, k23 := 23#64, k36 := 36#64, k30 := 30#64, k25 := 25#64, kt := Kt])
    (hw : E.read w = .value Wp)
    (hd :
      [ra.i, rb.i, rc.i, rd.i, re.i, rf.i, rg.i, rh.i, k50.i, k46.i, k23.i, k36.i, k30.i, k25.i,
          kt.i, s0.i, s1.i, s2.i, s3.i, s4.i, c0.i, c1.i, ch.i, x.i, t0.i, t1.i, t2.i, t.i, e'.i,
          z0.i, z1.i, z2.i, z3.i, z4.i, m0.i, m1.i, m2.i, m3.i, u.i, a'.i].Nodup)
    (hoff : off = ((8 * tt : Nat) : Int)) (htt : tt < 80) (hKt : Kt = Sha512.K[tt]!)
    (hWo : Wp.offset = 0) (hfit : Fits S.mem (Wp.add (BitVec.ofNat 64 (8 * tt))) 64)
    (hload : S.mem.readAt (Wp.add (BitVec.ofNat 64 (8 * tt))) 64 = Wt)
    (hK :
      ∀ (vs0 vs1 vs2 vs3 vs4 vc0 vc1 vch : ⟦.bv 64⟧) (vp : ⟦.ptr⟧)
        (vx vt0 vt1 vt2 vt vz0 vz1 vz2 vz3 vz4 vm0 vm1 vm2 vm3 vu : ⟦.bv 64⟧) (A' E' : BitVec 64),
        (hr :
            Sha512.round #v[A, B, C, D, Ee, F, G, H] Sha512.K[tt]! Wt =
              #v[A', A, B, C, E', Ee, F, G]) →
          (blk.runBodyFrom
                E[s0 := vs0, s1 := vs1, s2 := vs2, s3 := vs3, s4 := vs4, c0 := vc0, c1 := vc1, ch :=
                  vch, p := vp, x := vx, t0 := vt0, t1 := vt1, t2 := vt2, t := vt, e' := .value E',
                  z0 := vz0, z1 := vz1, z2 := vz2, z3 := vz3, z4 := vz4, m0 := vm0, m1 := vm1, m2 :=
                  vm2, m3 := vm3, u := vu, a' := .value A']
                (pos + 26) S >>=
              g) =
            K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  subst hoff hKt
  have h0 : (0 : Int) ≤ 8 * (tt : Int) := by omega
  have h1 : (8 * (tt : Int)).toNat = 8 * tt := by omega
  have hov : ¬Wp.offset.uaddOverflow (BitVec.ofNat 64 (8 * tt)) := by
    simp [BitVec.uaddOverflow, hWo]; omega
  iterate 8 step_pure
  step_pure [h0, h1]
  step_load
  iterate 4 step_pure
  step_pure with ve
  iterate 10 step_pure
  step_pure with va
  have hr :
    Sha512.round #v[A, B, C, D, Ee, F, G, H] Sha512.K[tt]! Wt = #v[va, A, B, C, ve, Ee, F, G] := by
    rw [hva, hve, round_eq4, getElem!_pos Sha512.K tt htt]
  rw [hE, hS]
  exact hK _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ va ve hr

/-! ## The blocks' envs -/

/-- The constants `^bb5` and the blocks after it read: `K` (last first, so a round's `K[t]` and the
rotations are read near the top of the env), `8`, the rotations, `0`, `1`. -/
abbrev kconsts (E : ⟪Γ⟫) : ⟪Γ⟫ :=
  E[%1155 := .value 7801388544844847127#64, %1154 := .value 6902733635092675308#64, %1153 :=
    .value 6448918945643986474#64, %1152 := .value 5532061633213252278#64, %1151 :=
    .value 4836135668995329356#64, %1150 := .value 4368137639120453308#64, %1149 :=
    .value 3659926193048069267#64, %1148 := .value 2944078676154940804#64, %1147 :=
    .value 1977374033974150939#64, %1146 := .value 1242879168328830382#64, %1145 :=
    .value 748580250866718886#64, %1144 := .value 500013540394364858#64, %1143 :=
    .value 17689382322260857208#64, %1142 := .value 16922976911328602910#64, %1141 :=
    .value 15097957966210449927#64, %1140 := .value 14566680578165727644#64, %1139 :=
    .value 14299343276471374635#64, %1138 := .value 13761210420658862357#64, %1137 :=
    .value 11840083180663258601#64, %1136 := .value 10430055236837252648#64, %1135 :=
    .value 10144078919501101548#64, %1134 := .value 9568029438360202098#64, %1133 :=
    .value 8693463985226723168#64, %1132 := .value 8399075790359081724#64, %1131 :=
    .value 7507060721942968483#64, %1130 := .value 6601373596472566643#64, %1129 :=
    .value 5681478168544905931#64, %1128 := .value 4115178125766777443#64, %1127 :=
    .value 3796741975233480872#64, %1126 := .value 2830643537854262169#64, %1125 :=
    .value 2177327727835720531#64, %1124 := .value 1847814050463011016#64, %1123 :=
    .value 1182934255886127544#64, %1122 := .value 17586052441742319658#64, %1121 :=
    .value 15463397548674623760#64, %1120 := .value 15101387698204529176#64, %1119 :=
    .value 14369950271660146224#64, %1118 := .value 14000437183269869457#64, %1117 :=
    .value 12113106623233404929#64, %1116 := .value 11727347734174303076#64, %1115 :=
    .value 10552545826968843579#64, %1114 := .value 9350256976987008742#64, %1113 :=
    .value 8532644243296465576#64, %1112 := .value 7280758554555802590#64, %1111 :=
    .value 5996557281743188959#64, %1110 := .value 5560940570517711597#64, %1109 :=
    .value 3322285676063803686#64, %1108 := .value 2861767655752347644#64, %1107 :=
    .value 1452737877330783856#64, %1106 := .value 489312712824947311#64, %1105 :=
    .value 15395433587784984357#64, %1104 := .value 14330467153632333762#64, %1103 :=
    .value 13788192230050041572#64, %1102 := .value 12683024718118986047#64, %1101 :=
    .value 12119686244451234320#64, %1100 := .value 10970295158949994411#64, %1099 :=
    .value 8573033837759648693#64, %1098 := .value 6679025012923562964#64, %1097 :=
    .value 5365058923640841347#64, %1096 := .value 3308224258029322869#64, %1095 :=
    .value 2597628984639134821#64, %1094 := .value 1135362057144423861#64, %1093 :=
    .value 17275323862435702243#64, %1092 := .value 16472876342353939154#64, %1091 :=
    .value 13951009754708518548#64, %1090 := .value 11230858885718282805#64, %1089 :=
    .value 9286055187155687089#64, %1088 := .value 8268148722764581231#64, %1087 :=
    .value 6128411473006802146#64, %1086 := .value 2608012711638119052#64, %1085 :=
    .value 1334009975649890238#64, %1084 := .value 15566598209576043074#64, %1083 :=
    .value 12329834152419229976#64, %1082 := .value 10538285296894168987#64, %1081 :=
    .value 6480981068601479193#64, %1080 := .value 4131703408338449720#64, %1079 :=
    .value 16840607885511220156#64, %1078 := .value 13096744586834688815#64, %1077 :=
    .value 8158064640168781261#64, %1072 := .value 4794697086780616226#64, %1076 := .value 8#64,
    %1069 := .value 50#64, %1070 := .value 46#64, %1071 := .value 23#64, %1073 := .value 36#64,
    %1074 := .value 30#64, %1075 := .value 25#64, %1055 := .value 0#64, %1058 := .value 1#64]

/-- The schedule's constants, read in `^bb3` and `^bb4`. -/
abbrev sconsts (E : ⟪Γ⟫) : ⟪Γ⟫ :=
  E[%1057 := .value 3#64, %1059 := .value 80#64, %1060 := .value 18446744073709551600#64, %1061 :=
    .value 18446744073709551609#64, %1062 := .value 18446744073709551601#64, %1063 := .value 63#64,
    %1064 := .value 56#64, %1065 := .value 7#64, %1066 := .value 18446744073709551614#64, %1067 :=
    .value 45#64, %1068 := .value 6#64]

/-- `^bb5`'s env: the constants, `V` and `W`. -/
abbrev env5 (V W : Pointer) (E : ⟪Γ⟫) : ⟪Γ⟫ :=
  (kconsts E)[%1156 := .value V, %1157 := .value W]

/-- `^bb1`'s env at word `i`: the constants, `V`, `W`. -/
abbrev env1 (V W : Pointer) (i : Nat) (E : ⟪Γ⟫) : ⟪Γ⟫ :=
  (sconsts (kconsts E))[%1056 := .value 16#64, %1156 := .value V, %1157 := .value W, %1158 :=
    .value (BitVec.ofNat 64 i)]

/-- `^bb3`'s env at word `i`: the constants, `V`, `W`. -/
abbrev env3 (V W : Pointer) (i : Nat) (E : ⟪Γ⟫) : ⟪Γ⟫ :=
  (sconsts (kconsts E))[%1156 := .value V, %1157 := .value W, %1166 := .value (BitVec.ofNat 64 i)]

/-- `^bb6`'s env at word `i`: `1`, `8`, `V`, `&s[0]`. -/
abbrev env6 (V d : Pointer) (i : Nat) (E : ⟪Γ⟫) : ⟪Γ⟫ :=
  E[%1058 := .value 1#64, %1076 := .value 8#64, %1156 := .value V, %1195 := .value (d.add 16#64),
    rir_dst% Sha512_round.hty 2243 := .value (BitVec.ofNat 64 i)]

/-- `v` stored as eight 64-bit words at `p`, lowest first. -/
def storeWords8 (m : MemoryState) (p : Pointer) (v : Vector (BitVec 64) 8) : MemoryState :=
  (((((((m.storeAt p v[0]).storeAt (p.add 8#64) v[1]).storeAt (p.add 16#64) v[2]).storeAt
                    (p.add 24#64) v[3]).storeAt
                (p.add 32#64) v[4]).storeAt
            (p.add 40#64) v[5]).storeAt
        (p.add 48#64) v[6]).storeAt
    (p.add 56#64) v[7]

/-- Slot `t` of the 64-bit words at `W`. -/
abbrev slot (W : Pointer) (t : Nat) : Pointer :=
  W.add (BitVec.ofNat 64 (8 * t))

/-- Slots `0 … n - 1` of `W` hold `f 0 … f (n - 1)`, known. -/
def HoldsW (m : MemoryState) (W : Pointer) (f : Nat → BitVec 64) (n : Nat) : Prop :=
  ∀ t, t < n → Fits m (slot W t) 64 ∧ m.readAt (slot W t) 64 = f t

/-! ## `W`'s slots -/

/-- The stores of `f i`, …, `f (i + n - 1)` into the slots `i … i + n - 1` of `W`. -/
def stores (W : Pointer) (f : Nat → BitVec 64) : (i n : Nat) → MemoryState → MemoryState
  | _, 0, m => m
  | i, n + 1, m => stores W f (i + 1) n (m.storeAt (slot W i) (f i))

theorem slot_offsetInBits {W : Pointer} (hWo : W.offset = 0) {t : Nat} (ht : t < 2 ^ 58) :
    (slot W t).offsetInBits = 64 * t := by
  simp [slot, Pointer.offsetInBits, Pointer.add, hWo]
  omega

theorem slot_noOverflow {W : Pointer} (hWo : W.offset = 0) {t : Nat} :
    ¬W.offset.uaddOverflow (BitVec.ofNat 64 (8 * t)) := by
  simp [BitVec.uaddOverflow, hWo]
  omega

theorem room_slot {m : MemoryState} {W : Pointer} (hWo : W.offset = 0) (hN : N < 2 ^ 58)
    (h : Room m W (64 * N)) {t : Nat} (ht : t < N) : Room m (slot W t) 64 :=
  Room.add_of_le (slot_noOverflow hWo)
    (by
      simp; omega)
    h

/-- A store of `f n` into slot `n` extends what `W` holds. -/
theorem HoldsW.store {m : MemoryState} {W : Pointer} {f : Nat → BitVec 64} {n : Nat}
    (hWo : W.offset = 0) (hN : N < 2 ^ 58) (hr : Room m W (64 * N)) (h : HoldsW m W f n)
    (hn : n < N) : HoldsW (m.storeAt (slot W n) (f n)) W f (n + 1) := by
  intro t ht
  by_cases e : t = n
  · subst e
    have hr' := room_slot hWo hN hr hn
    exact ⟨Fits.storeAt_self hr', MemoryState.readAt_storeAt_self hr' _⟩
  · refine ⟨(h t (by omega)).1.storeAt, ?_⟩
    rw [MemoryState.readAt_storeAt_disjoint]
    · exact (h t (by omega)).2
    · simp only [Range.Disjoint, Range.of, slot_offsetInBits hWo (show n < 2 ^ 58 by omega),
        slot_offsetInBits hWo (show t < 2 ^ 58 by omega)]
      omega

theorem room_stores {m : MemoryState} : Room (stores W f i n m) p w ↔ Room m p w := by
  induction n generalizing i m with
  | zero => rfl
  | succ n ih => simp [stores, ih]

theorem Fits.stores {m : MemoryState} (h : Fits m p w) : Fits (stores W f i n m) p w := by
  induction n generalizing i m with
  | zero => exact h
  | succ n ih => exact ih h.storeAt

theorem Writable.stores {m : MemoryState} (h : Writable m p) : Writable (stores W f i n m) p := by
  induction n generalizing i m with
  | zero => exact h
  | succ n ih => exact ih h.storeAt

/-- `stores` extends what `W` holds. -/
theorem HoldsW.stores {m : MemoryState} {W : Pointer} {f : Nat → BitVec 64} (hWo : W.offset = 0)
    (hN : N < 2 ^ 58) :
    ∀ n i,
      Room m W (64 * N) → HoldsW m W f i → i + n ≤ N → HoldsW (stores W f i n m) W f (i + n) := by
  intro n
  induction n generalizing m with
  | zero =>
    intro i _ h _; exact h
  | succ n ih =>
    intro i hr h hn
    rw [show i + (n + 1) = i + 1 + n by omega]
    exact ih (i + 1) hr.storeAt (h.store hWo hN hr (by omega)) (by omega)

theorem HoldsW.congr {m : MemoryState} {f g : Nat → BitVec 64} (h : HoldsW m W f n)
    (hfg : ∀ t, t < n → f t = g t) : HoldsW m W g n := fun t ht =>
  ⟨(h t ht).1, (h t ht).2.trans (hfg t ht)⟩

theorem HoldsW.storeAt_ne {m : MemoryState} {x : BitVec v} (h : HoldsW m W f n) (hq : q.id ≠ W.id) :
    HoldsW (m.storeAt q x) W f n := fun t ht =>
  ⟨(h t ht).1.storeAt, by
    rw [MemoryState.readAt_storeAt_disjoint (Range.disjoint_of_id_ne (q := slot W t) hq)]
    exact (h t ht).2⟩

theorem holdsW_zero {m : MemoryState} : HoldsW m W f 0 := fun _ h => absurd h (by omega)

theorem readAt_stores_ne {m : MemoryState} (h : q.id ≠ W.id) :
    ∀ n i, (stores W f i n m).readAt q w = m.readAt q w := by
  intro n
  induction n generalizing m with
  | zero =>
    intro _; rfl
  | succ n ih =>
    intro i
    rw [stores, ih,
      MemoryState.readAt_storeAt_disjoint (Range.disjoint_of_id_ne (p := slot W i) h.symm)]

theorem wf_stores {s : GlobalState} :
    ∀ n i (m : MemoryState),
      ({ s with mem := m } : GlobalState).WF →
        ({ s with mem := stores W f i n m } : GlobalState).WF := by
  intro n
  induction n with
  | zero =>
    intro _ _ h; exact h
  | succ n ih =>
    intro i m h; exact ih (i + 1) _ (GlobalState.WF_storeAt.2 h)

theorem eraseFrom_stores {m : MemoryState} (h : k ≤ W.id.id) :
    ∀ n i, (stores W f i n m).eraseFrom k = m.eraseFrom k := by
  intro n
  induction n generalizing m with
  | zero =>
    intro _; rfl
  | succ n ih =>
    intro i
    rw [stores, ih, MemoryState.eraseFrom_storeAt_of_le (by simpa using h)]

/-! ## `^bb1`, `^bb2`: the block's words -/

theorem shl3_facts {i : Nat} (hi : i < 2 ^ 60) :
    BitVec.ofNat 64 (8 * i) >>> 3 = BitVec.ofNat 64 i ∧
      (BitVec.ofNat 64 (8 * i)).sshiftRight 3 = BitVec.ofNat 64 i ∧
      BitVec.ofNat 64 i <<< 3 = BitVec.ofNat 64 (8 * i) ∧
      i % 18446744073709551616 = i ∧
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

/-- `bb1`/`bb2` from word `i`, `m` left: `W[i] = bswap(block word i)`. -/
theorem loop1 (d b V W : Pointer) (B : BitVec 1024) (R : PoisonOr (Vals [] × GlobalState))
    (hWo : W.offset = 0) (hbo : b.offset.toNat + 128 < 2 ^ 64) (hWb : W.id ≠ b.id) :
    ∀ m i (S : GlobalState) (E : ⟪Γ⟫),
      i + m = 16 →
        E.args = (Sha512_round.args (.value d) (.value b)).get →
        S.WF →
        Room S.mem W 5120 →
        Fits S.mem b 1024 →
        S.mem.readAt b 1024 = B →
        (∀ E' : ⟪Γ⟫,
          E'.args = (Sha512_round.args (.value d) (.value b)).get →
            Sha512_round.runFrom (env3 V W 16 E') 3
                { S with mem := stores W (fun t => bswapv (B.extractLsb' (64 * t) 64)) i m S.mem } =
              R) →
        Sha512_round.runFrom (env1 V W i E) 1 S = R := by
  intro m
  induction m with
  | zero =>
    intro i S E hi hArgs hwf hWr hbf hB hK
    obtain rfl : i = 16 := by omega
    block_init
    step_pure
    finish_block
    run_from using hK
  | succ m ih =>
    intro i S E hi hArgs hwf hWr hbf hB hK
    obtain ⟨h1, h2, h3, h4, h5, h6, h7⟩ := shl3_facts (i := i) (by omega)
    obtain ⟨o1, o2⟩ := counter_overflow (i := i) (by omega)
    have hfx : Fits S.mem (b.add (BitVec.ofNat 64 (8 * i))) 64 :=
      Fits.add_of_le
        (by
          simp [BitVec.uaddOverflow]; omega)
        (by
          simp; omega)
        hbf
    have hfw := room_slot (N := 80) hWo (by decide) hWr (t := i) (by omega)
    have hx : S.mem.readAt (b.add (BitVec.ofNat 64 (8 * i))) 64 = B.extractLsb' (64 * i) 64 := by
      rw [MemoryState.readAt_add_of_readAt hbf.inBounds
          (by
            simp [BitVec.uaddOverflow]; omega)
          (by
            simp; omega)
          hB]
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
      run_from using ih (i + 1)
      rw [hE, hS]
      exact hK E₀ hArgs₀

/-! ## `^bb3`, `^bb4`: the schedule -/

theorem sub_facts {i k c : Nat} (hc : c + k = 2 ^ 64) (hk : k ≤ i) (hk' : k ≤ 16)
    (hi : i < 2 ^ 60) :
    (BitVec.ofNat 64 i).saddOverflow (BitVec.ofNat 64 c) = false ∧
      BitVec.ofNat 64 i + BitVec.ofNat 64 c = BitVec.ofNat 64 (i - k) ∧
      (i - k) % 18446744073709551616 = i - k ∧
      (i - k) * 8 = 8 * (i - k) ∧ 8 * (i - k) < 18446744073709551616 := by
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
    x7 + x16 + ((rotl x15 63 ^^^ rotl x15 56) ^^^ x15 >>> 7) +
        ((rotl x2 45 ^^^ rotl x2 3) ^^^ x2 >>> 6) =
      Sha512.sigma1 x2 + x7 + Sha512.sigma0 x15 + x16 := by
  simp only [rotl_63, rotl_56, rotl_45, rotl_3, Sha512.sigma0, Sha512.sigma1]
  ac_rfl

/-- `Wf`'s words `16 … 79` follow the schedule's recurrence. -/
def SchedRec (Wf : Nat → BitVec 64) : Prop :=
  ∀ t,
    16 ≤ t →
      t < 80 →
      Wf t = Sha512.sigma1 (Wf (t - 2)) + Wf (t - 7) + Sha512.sigma0 (Wf (t - 15)) + Wf (t - 16)

/-- `bb3`/`bb4` from word `i`, `m` left: the schedule's words `16 … 79` into `W`. -/
theorem loop2 (d b V W : Pointer) (Wf : Nat → BitVec 64) (R : PoisonOr (Vals [] × GlobalState))
    (hWo : W.offset = 0) (hrec : SchedRec Wf) :
    ∀ m i (S : GlobalState) (E : ⟪Γ⟫),
      i + m = 80 →
        16 ≤ i →
        E.args = (Sha512_round.args (.value d) (.value b)).get →
        S.WF →
        Room S.mem W 5120 →
        HoldsW S.mem W Wf i →
        (∀ E' : ⟪Γ⟫,
          E'.args = (Sha512_round.args (.value d) (.value b)).get →
            Sha512_round.runFrom (env5 V W E') 5 { S with mem := stores W Wf i m S.mem } = R) →
        Sha512_round.runFrom (env3 V W i E) 3 S = R := by
  intro m
  induction m with
  | zero =>
    intro i S E hi _ hArgs hwf hWr hH hK
    obtain rfl : i = 80 := by omega
    block_init
    step_pure
    finish_block
    run_from using hK
  | succ m ih =>
    intro i S E hi hi16 hArgs hwf hWr hH hK
    obtain ⟨-, -, -, h4, h5, -, h7⟩ := shl3_facts (i := i) (by omega)
    obtain ⟨o1, o2⟩ := counter_overflow (i := i) (by omega)
    obtain ⟨a1, a2, a3, a4, a5⟩ :=
      sub_facts (i := i) (k := 16) (c := 18446744073709551600) rfl hi16 (by omega) (by omega)
    obtain ⟨b1, b2, b3, b4, b5⟩ :=
      sub_facts (i := i) (k := 7) (c := 18446744073709551609) rfl (by omega) (by omega) (by omega)
    obtain ⟨c1, c2, c3, c4, c5⟩ :=
      sub_facts (i := i) (k := 15) (c := 18446744073709551601) rfl (by omega) (by omega) (by omega)
    obtain ⟨d1, d2, d3, d4, d5⟩ :=
      sub_facts (i := i) (k := 2) (c := 18446744073709551614) rfl (by omega) (by omega) (by omega)
    obtain ⟨f16, r16⟩ := hH (i - 16) (by omega)
    obtain ⟨f7, r7⟩ := hH (i - 7) (by omega)
    obtain ⟨f15, r15⟩ := hH (i - 15) (by omega)
    obtain ⟨f2, r2⟩ := hH (i - 2) (by omega)
    simp only [slot] at f16 r16 f7 r7 f15 r15 f2 r2
    have fi := room_slot (N := 80) hWo (by decide) hWr (t := i) (by omega)
    have hH' := hH.store (N := 80) (f := Wf) hWo (by decide) hWr (by omega)
    generalize hM : S.mem = M at hH'
    clear hH
    block_init
    step_pure
    finish_block
    · exfalso
      have := congrArg BitVec.toNat hbr
      simp at this
      omega
    · block_init
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
      rw [sched_eq, ← hrec i hi16 (by omega)] at hS
      run_from using ih (i + 1)
      rw [hE, hS]
      exact hK E₀ hArgs₀

/-! ## `^bb6`, `^bb7`: the state words updated -/

theorem storeWords8_eq (m : MemoryState) (V : Pointer) (v : Vector (BitVec 64) 8) :
    storeWords8 m V v = stores V (fun k => v[k]!) 0 8 m := by simp [storeWords8, stores, slot]

/-- `bb6`/`bb7` from word `i`, `m` left: `state[j] += V[j]`, then the return. -/
theorem loop3 (d V : Pointer) (Hf vf : Nat → BitVec 64) (R : PoisonOr (Vals [] × GlobalState))
    (hVo : V.offset = 0) (hdo : d.offset.toNat + 80 < 2 ^ 64) (hVd : V.id ≠ d.id) :
    ∀ m i (S : GlobalState) (E : ⟪Γ⟫),
      i + m = 8 →
        S.WF →
        Fits S.mem d 640 →
        Writable S.mem d →
        HoldsW S.mem V vf 8 →
        (∀ j, i ≤ j → j < 8 → S.mem.readAt (d.add (16#64 + BitVec.ofNat 64 (8 * j))) 64 = Hf j) →
        .value (.nil, { S with mem := Sha512Obj.storeWords d (fun j => Hf j + vf j) i m S.mem }) =
          R →
        Sha512_round.runFrom (env6 V d i E) 6 S = R := by
  intro m
  induction m with
  | zero =>
    intro i S E hi hwf hdf hdw hV hd hR
    obtain rfl : i = 8 := by omega
    block_init
    step_pure
    finish_block
    block_init
    finish_block
    exact hR
  | succ m ih =>
    intro i S E hi hwf hdf hdw hV hd hR
    obtain ⟨-, -, -, h4, h5, -, h7⟩ := shl3_facts (i := i) (by omega)
    obtain ⟨o1, o2⟩ := counter_overflow (i := i) (by omega)
    obtain ⟨fv, rv⟩ := hV i (by omega)
    simp only [slot] at fv rv
    have rd := hd i (Nat.le_refl _) (by omega)
    have fd : Fits S.mem (d.add (16#64 + BitVec.ofNat 64 (8 * i))) 64 :=
      Fits.add_of_le
        (by
          simp [BitVec.uaddOverflow]; omega)
        (by
          simp; omega)
        hdf
    have hV' :
      HoldsW (S.mem.storeAt (d.add (16#64 + BitVec.ofNat 64 (8 * i))) (Hf i + vf i)) V vf 8 :=
      hV.storeAt_ne hVd.symm
    have hd' (j : Nat) (hj : i + 1 ≤ j) (hj' : j < 8) :
      (S.mem.storeAt (d.add (16#64 + BitVec.ofNat 64 (8 * i))) (Hf i + vf i)).readAt
          (d.add (16#64 + BitVec.ofNat 64 (8 * j))) 64 =
        Hf j := by
      rw [MemoryState.readAt_storeAt_disjoint, hd j (by omega) hj']
      simp only [Range.Disjoint, Range.of, Pointer.offsetInBits, Pointer.add, BitVec.toNat_add,
        BitVec.toNat_ofNat]
      omega
    generalize hM : S.mem = M at hV' hd' hR
    clear hV hd
    block_init
    step_pure
    finish_block
    · exfalso
      have := congrArg BitVec.toNat hbr
      simp at this
      omega
    · block_init
      step_pure [h4, h5, h7]
      step_pure [h4, h5, h7]
      step_load consuming rv fv
      step_load consuming rd
      step_pure
      step_store consuming fd
      step_pure [o1, o2, ← BitVec.ofNat_add]
      finish_block
      run_from using ih (i + 1)
      · exact hd'
      · exact hR

/-! ## `^bb5`: the 80 rounds -/

-- one block of 2110 instructions: about 120 steps (~0.15 s each), 76 rounds by the pattern
-- (~1 s each) and the stores take about 1.5M heartbeats
set_option maxHeartbeats 2000000 in
/-- `^bb5`: the 80 rounds on the state words `a … h` read at `d + 16`, `W` the schedule's words
`Wf`; then the working variables stored at `V`. -/
theorem block5 (d V W : Pointer) (Wf : Nat → BitVec 64) (a b c dd e f g h : BitVec 64)
    (S : GlobalState) (E : ⟪Γ⟫) (R : PoisonOr (Vals [] × GlobalState))
    (hArgs : E.args = (Sha512_round.args (.value d) (.value bp)).get)
    (hdo : d.offset.toNat + 80 < 2 ^ 64) (hF0 : Fits S.mem (d.add 16#64) 64)
    (hF1 : Fits S.mem (d.add 24#64) 64) (hF2 : Fits S.mem (d.add 32#64) 64)
    (hF3 : Fits S.mem (d.add 40#64) 64) (hF4 : Fits S.mem (d.add 48#64) 64)
    (hF5 : Fits S.mem (d.add 56#64) 64) (hF6 : Fits S.mem (d.add 64#64) 64)
    (hF7 : Fits S.mem (d.add 72#64) 64) (hd0 : S.mem.readAt (d.add 16#64) 64 = a)
    (hd1 : S.mem.readAt (d.add 24#64) 64 = b) (hd2 : S.mem.readAt (d.add 32#64) 64 = c)
    (hd3 : S.mem.readAt (d.add 40#64) 64 = dd) (hd4 : S.mem.readAt (d.add 48#64) 64 = e)
    (hd5 : S.mem.readAt (d.add 56#64) 64 = f) (hd6 : S.mem.readAt (d.add 64#64) 64 = g)
    (hd7 : S.mem.readAt (d.add 72#64) 64 = h) (hWo : W.offset = 0) (hW : HoldsW S.mem W Wf 80)
    (hVo : V.offset = 0) (hV : Room S.mem V 512)
    (hK :
      ∀ E' : ⟪Γ⟫,
        E'.args = (Sha512_round.args (.value d) (.value bp)).get →
          Sha512_round.runFrom (env6 V d 0 E') 6
              { S with mem := storeWords8 S.mem V (rounds Wf 0 80 #v[a, b, c, dd, e, f, g, h]) } =
            R) :
    Sha512_round.runFrom (env5 V W E) 5 S = R := by
  have hw (t : Nat) (ht : t < 80) := (hW t ht).2
  have hf (t : Nat) (ht : t < 80) := (hW t ht).1
  clear hW
  have hw0 : S.mem.readAt W 64 = Wf 0 := by
    simpa only [slot, Nat.mul_zero, BitVec.ofNat_eq_ofNat, Pointer.add_zero] using hw 0 (by decide)
  have hf0 : Fits S.mem W 64 := by
    simpa only [slot, Nat.mul_zero, BitVec.ofNat_eq_ofNat, Pointer.add_zero] using hf 0 (by decide)
  have hw1 : S.mem.readAt (W.add 8#64) 64 = Wf 1 := hw 1 (by decide)
  have hf1 : Fits S.mem (W.add 8#64) 64 := hf 1 (by decide)
  have hw2 : S.mem.readAt (W.add 16#64) 64 = Wf 2 := hw 2 (by decide)
  have hf2 : Fits S.mem (W.add 16#64) 64 := hf 2 (by decide)
  have hw3 : S.mem.readAt (W.add 24#64) 64 = Wf 3 := hw 3 (by decide)
  have hf3 : Fits S.mem (W.add 24#64) 64 := hf 3 (by decide)
  block_init
  iterate 8
    step_pure
    step_load
  iterate 8 step_pure
  step_load consuming hw0 hf0
  iterate 3 step_pure
  step_pure with t0 ht0
  step_pure with e1 he0
  iterate 10 step_pure
  step_pure with a1 ha0
  have hv : rounds Wf 0 1 #v[a, b, c, dd, e, f, g, h] = #v[a1, a, b, c, e1, e, f, g] := by
    refine rounds_step (x := #v[a, b, c, dd, e, f, g, h]) rfl ?_
    rw [ha0, he0, ht0, show Sha512.K[0]! = 4794697086780616226#64 by decide]; exact round_eq0 ..
  clear ha0 he0 ht0
  iterate 9 step_pure
  step_load consuming hw1 hf1
  iterate 3 step_pure
  step_pure with t1 ht1
  step_pure with e2 he1
  iterate 10 step_pure
  step_pure with a2 ha1
  replace hv : rounds Wf 0 2 #v[a, b, c, dd, e, f, g, h] = #v[a2, a1, a, b, e2, e1, e, f] := by
    refine rounds_step hv ?_
    rw [ha1, he1, ht1, show Sha512.K[1]! = 8158064640168781261#64 by decide]; exact round_eq1 ..
  clear ha1 he1 ht1
  iterate 9 step_pure
  step_load consuming hw2 hf2
  iterate 3 step_pure
  step_pure with t2 ht2
  step_pure with e3 he2
  iterate 10 step_pure
  step_pure with a3 ha2
  replace hv : rounds Wf 0 3 #v[a, b, c, dd, e, f, g, h] = #v[a3, a2, a1, a, e3, e2, e1, e] := by
    refine rounds_step hv ?_
    rw [ha2, he2, ht2, show Sha512.K[2]! = 13096744586834688815#64 by decide]; exact round_eq2 ..
  clear ha2 he2 ht2
  iterate 9 step_pure
  step_load consuming hw3 hf3
  iterate 3 step_pure
  step_pure with t3 ht3
  step_pure with e4 he3
  iterate 10 step_pure
  step_pure with a4 ha3
  replace hv : rounds Wf 0 4 #v[a, b, c, dd, e, f, g, h] = #v[a4, a3, a2, a1, e4, e3, e2, e1] := by
    refine rounds_step hv ?_
    rw [ha3, he3, ht3, show Sha512.K[3]! = 16840607885511220156#64 by decide]; exact round_eq2 ..
  clear ha3 he3 ht3
  round_sites 4 79
  clear hw hf
  step_store
  iterate 7
    step_pure
    step_store
  finish_block
  rw [hv] at hK
  run_from using hK

/-! ## The spec's words -/

theorem bswapv_eq (x : BitVec 64) :
    bswapv x =
      x.extractLsb' 0 8 ++ x.extractLsb' 8 8 ++ x.extractLsb' 16 8 ++ x.extractLsb' 24 8 ++
        x.extractLsb' 32 8 ++
        x.extractLsb' 40 8 ++
        x.extractLsb' 48 8 ++
        x.extractLsb' 56 8 := by
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
theorem compress_getElem! (H : Vector (BitVec 64) 8) (B : List (BitVec 8)) (hj : j < 8) :
    (Sha512.compress H B)[j]! = H[j]! + (rounds (fun t => (Sha512.schedule B)[t]!) 0 80 H)[j]! := by
  rw [getElem!_pos (Sha512.compress H B) j hj, getElem!_pos H j hj,
    getElem!_pos (rounds _ 0 80 H) j hj]
  simp only [Sha512.compress, rounds, Vector.getElem_zipWith, List.range_eq_range']

theorem storeWords_congr {m : MemoryState} {f g : Nat → BitVec 64} :
    ∀ n i,
      (∀ j, i ≤ j → j < i + n → f j = g j) →
        Sha512Obj.storeWords d f i n m = Sha512Obj.storeWords d g i n m := by
  intro n
  induction n generalizing m with
  | zero =>
    intro _ _; rfl
  | succ n ih =>
    intro i h
    simp only [Sha512Obj.storeWords]
    rw [h i (by omega) (by omega)]
    exact ih (i + 1) fun j h1 h2 => h j (by omega) (by omega)

end Sha512_round

open Sha512_round in
/-- `Sha512.round` compresses the 128-byte block at `b` into the state words of the object at `d`
(FIPS 180-4 `Sha512.compress`, the block's bytes in memory order); its frame takes two blocks. -/
public theorem Sha512_round.call_eq (d b : Pointer) (s : GlobalState) (hwf : s.WF)
    (hdf : Fits s.mem d 640) (hdw : Writable s.mem d) (hdo : d.offset.toNat + 80 < 2 ^ 64)
    (hbf : Fits s.mem b 1024) (hbo : b.offset.toNat + 128 < 2 ^ 64) :
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
  have hrd (q : Pointer) (w : Nat) (hq : InBounds S₀.mem q w) :
    S.mem.readAt q w = S₀.mem.readAt q w := by
    rw [hS]; exact readAt_alloca₂ hwf₀ hq
  have hfit (k : Nat) (hk : k + 8 ≤ 80) : Fits S.mem (d.add (BitVec.ofNat 64 k)) 64 :=
    Fits.add_of_le
      (by
        simp [BitVec.uaddOverflow]; omega)
      (by
        simp; omega)
      hdf
  have hrdk (k : Nat) (hk : k + 8 ≤ 80) :
    S.mem.readAt (d.add (BitVec.ofNat 64 k)) 64 = S₀.mem.readAt (d.add (BitVec.ofNat 64 k)) 64 :=
    hrd _ _
      (Fits.add_of_le
          (by
            simp [BitVec.uaddOverflow]; omega)
          (by
            simp; omega)
          hdf₀).inBounds
  generalize hBd : S₀.mem.readAt b 1024 = B
  have hB : S.mem.readAt b 1024 = B := (hrd b 1024 hbf₀.inBounds).trans hBd
  obtain ⟨Wf, hWf⟩ : ∃ Wf : Nat → BitVec 64, Wf = fun t => (Sha512.schedule (bytesLE B))[t]! :=
    ⟨_, rfl⟩
  have hrec : SchedRec Wf := fun t h1 h2 => by
    subst hWf; exact Sha512.getElem!_schedule_ge _ h1 h2
  have h16 : HoldsW (stores W (fun t => bswapv (B.extractLsb' (64 * t) 64)) 0 16 S.mem) W Wf 16 :=
    (HoldsW.stores (N := 80) hW_off (by decide) 16 0 hW_room holdsW_zero (by omega)).congr
      fun t ht => by
      subst hWf; simp only [Sha512.getElem!_schedule_lt _ ht, word_eq B ht]
  have hH :
    Sha512Obj.state S₀.mem d =
      #v[S₀.mem.readAt (d.add 16#64) 64, S₀.mem.readAt (d.add 24#64) 64,
        S₀.mem.readAt (d.add 32#64) 64, S₀.mem.readAt (d.add 40#64) 64,
        S₀.mem.readAt (d.add 48#64) 64, S₀.mem.readAt (d.add 56#64) 64,
        S₀.mem.readAt (d.add 64#64) 64, S₀.mem.readAt (d.add 72#64) 64] :=
    rfl
  have hrun :
    Sha512_round.runFrom E 1 S =
      .value
        (.nil,
          { S with
            mem :=
              Sha512Obj.storeWords d
                (fun j =>
                  (#v[S₀.mem.readAt (d.add 16#64) 64, S₀.mem.readAt (d.add 24#64) 64,
                        S₀.mem.readAt (d.add 32#64) 64, S₀.mem.readAt (d.add 40#64) 64,
                        S₀.mem.readAt (d.add 48#64) 64, S₀.mem.readAt (d.add 56#64) 64,
                        S₀.mem.readAt (d.add 64#64) 64, S₀.mem.readAt (d.add 72#64) 64])[j]! +
                    (rounds Wf 0 80
                        #v[S₀.mem.readAt (d.add 16#64) 64, S₀.mem.readAt (d.add 24#64) 64,
                          S₀.mem.readAt (d.add 32#64) 64, S₀.mem.readAt (d.add 40#64) 64,
                          S₀.mem.readAt (d.add 48#64) 64, S₀.mem.readAt (d.add 56#64) 64,
                          S₀.mem.readAt (d.add 64#64) 64, S₀.mem.readAt (d.add 72#64) 64])[j]!)
                0 8
                (storeWords8
                  (stores W Wf 16 64
                    (stores W (fun t => bswapv (B.extractLsb' (64 * t) 64)) 0 16 S.mem))
                  V
                  (rounds Wf 0 80
                    #v[S₀.mem.readAt (d.add 16#64) 64, S₀.mem.readAt (d.add 24#64) 64,
                      S₀.mem.readAt (d.add 32#64) 64, S₀.mem.readAt (d.add 40#64) 64,
                      S₀.mem.readAt (d.add 48#64) 64, S₀.mem.readAt (d.add 56#64) 64,
                      S₀.mem.readAt (d.add 64#64) 64, S₀.mem.readAt (d.add 72#64) 64])) }) := by
    clear hWf
    run_from using loop1 d b V W B _ hW_off hbo hb_ne_W.symm 16 0
    have hwf1 : S.WF := hS ▸ wf_stores 16 0 _ hwf
    have hW1 : Room S.mem W 5120 := hS ▸ room_stores.2 hW_room
    have h16' : HoldsW S.mem W Wf 16 := hS ▸ h16
    clear h16
    rw [hE]
    refine
      loop2 d b V W Wf _ hW_off hrec 64 16 S E₀ rfl (Nat.le_refl _) hArgs₀ hwf1 hW1 h16'
        fun E₂ hA₂ => ?_
    have hF (k : Nat) (hk : k + 8 ≤ 80) :
      Fits (stores W Wf 16 64 S.mem) (d.add (BitVec.ofNat 64 k)) 64 :=
      Fits.stores (hS ▸ Fits.stores (hfit k hk))
    have hd (k : Nat) (hk : k + 8 ≤ 80) :
      (stores W Wf 16 64 S.mem).readAt (d.add (BitVec.ofNat 64 k)) 64 =
        S₀.mem.readAt (d.add (BitVec.ofNat 64 k)) 64 := by
      rw [readAt_stores_ne (q := d.add _) hd_ne_W, hS]
      exact (readAt_stores_ne (q := d.add _) hd_ne_W _ _).trans (hrdk k hk)
    have hW80 := HoldsW.stores (N := 80) (f := Wf) hW_off (by decide) 64 16 hW1 h16' (by omega)
    have hV2 : Room (stores W Wf 16 64 S.mem) V 512 := room_stores.2 (hS ▸ room_stores.2 hV_room)
    refine
      block5 d V W Wf _ _ _ _ _ _ _ _ _ E₂ _ hA₂ hdo (hF 16 (by omega)) (hF 24 (by omega))
        (hF 32 (by omega)) (hF 40 (by omega)) (hF 48 (by omega)) (hF 56 (by omega))
        (hF 64 (by omega)) (hF 72 (by omega)) (hd 16 (by omega)) (hd 24 (by omega))
        (hd 32 (by omega)) (hd 40 (by omega)) (hd 48 (by omega)) (hd 56 (by omega))
        (hd 64 (by omega)) (hd 72 (by omega)) hW_off hW80 hV_off hV2 fun E₃ hA₃ => ?_
    rw [storeWords8_eq]
    refine
      loop3 d V (fun j => (Sha512Obj.state S₀.mem d)[j]!)
        (fun j =>
          (rounds Wf 0 80
              #v[S₀.mem.readAt (d.add 16#64) 64, S₀.mem.readAt (d.add 24#64) 64,
                S₀.mem.readAt (d.add 32#64) 64, S₀.mem.readAt (d.add 40#64) 64,
                S₀.mem.readAt (d.add 48#64) 64, S₀.mem.readAt (d.add 56#64) 64,
                S₀.mem.readAt (d.add 64#64) 64, S₀.mem.readAt (d.add 72#64) 64])[j]!)
        _ hV_off hdo hd_ne_V.symm 8 0 _ E₃ rfl (wf_stores 8 0 _ (wf_stores 64 16 _ hwf1))
        (Fits.stores (Fits.stores (hS ▸ Fits.stores hdf)))
        (Writable.stores
          (Writable.stores (hS ▸ Writable.stores ((hdw₀.alloca hwf₀).alloca (hwf₀.alloca)))))
        (HoldsW.stores (N := 8) hV_off (by decide) 8 0 hV2 holdsW_zero (by omega))
        (fun j _ hj => ?_) ?_
    · rw [readAt_stores_ne (q := d.add _) hd_ne_V, readAt_stores_ne (q := d.add _) hd_ne_W, hS]
      refine (readAt_stores_ne (q := d.add _) hd_ne_W _ _).trans ((hrd _ _ ?_).trans ?_)
      · exact
          (Fits.add_of_le
              (by
                simp [BitVec.uaddOverflow]; omega)
              (by
                simp; omega)
              hdf₀).inBounds
      · simp [Sha512Obj.state, hj]
    · rw [hS, hH, storeWords8_eq]
  rw [hrun, PoisonOr.value_bind]
  have hWn : S₀.alloc.nextFreeBlock ≤ W.id.id := by
    rw [hW]; simp [GlobalState.slot]
  have hVn : S₀.alloc.nextFreeBlock ≤ V.id.id := by
    rw [hV]; simp [GlobalState.slot]
  subst hS
  congr 2
  rw [Sha512Obj.eraseFrom_storeWords, storeWords8_eq, eraseFrom_stores hVn, eraseFrom_stores hWn,
    eraseFrom_stores hWn, GlobalState.eraseFrom_alloca_of_le (by simp [GlobalState.alloca]),
    GlobalState.eraseFrom_alloca_of_le (Nat.le_refl _), hwf₀.eraseFrom, ← hH, Sha512Obj.setState]
  subst hWf
  congr 1
  exact storeWords_congr 8 0 fun j _ hj => (compress_getElem! _ _ (by omega)).symm

end MLIR.Zig
