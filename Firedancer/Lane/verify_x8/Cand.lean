module

public import Firedancer.Lane.verify_x8.CandDefs

/-! `verify_x8`'s entry block and first loop (`^bb0 … ^bb37`): the `alloca`s, `k` and `s` zeroed,
and per item `results[j] = FD_ED25519_ERR_SIG`, the scalar check, the buffers and `candidates`;
`clang` runs `j = 0, 1, 2` unconditionally (`3 ≤ cnt`). -/

namespace MLIR.Firedancer.Lane.VerifyX8

open Firedancer.Avx512 Firedancer.Ref
open _root_.Firedancer.Lane.Mlir (verify_x8)
open _root_.Firedancer.Lane.Mlir.verify_x8 (Γ hty)

variable {β : Type} {g : Vals [] × GlobalState → PoisonOr β} {K : PoisonOr β}

set_option hygiene false in
/-- Item `n`'s inputs at the join's state `S`, the join after it (`hK`), and its candidate bit
`hv`; the join's state and continuations cleared. -/
local macro "item_init " n:num hn:term:max nxt:ident off:term:max : tactic =>
  `(tactic| (
    obtain ⟨hr, hro, hsb, hsl, hso, hpb, hpl, hpo, hsf, hsr, hsigo, hne0, hne1, hne2⟩ :=
      hS.item hc $hn
    simp only [Nat.reduceMul] at hr hro hsb hsl hso hpb hpl hpo
    have hK := fun (E' : ⟪Γ⟫) (hA' : E'.args = c.args) hR' =>
      $nxt c hc E' { S with mem := S.mem.storeAt (c.a.results.add $off) 4294967295#32 } hA' hR'
        (hS.step hc $hn) h38 h103
    have hv : c.X.cand $n = _ := c.cand_eq hc $hn (by decide)
    clear hS h38 h103
    generalize hsig : (c.it $n).sig = sig at hsl hsf hsr hsigo hne2 hv))

set_option hygiene false in
/-- A candidate: `a_buf[n] = public_keys[n]`, `r_buf[n] = sigs[n]`, `candidates |= 1<<n` (bit `n`
clear before: item `1`'s `or` is `disjoint`); on to the next join. -/
local macro "item_valid " n:num hcn:ident hK:ident : tactic =>
  `(tactic| (
    block_init
    step_pure
    step_load
    step_pure [c.cm_and (n := $n) (by decide)]
    finish_block
    step_loop using $hK
    all_goals first
      | exact (c.bufA_of_cand $hcn).symm
      | exact ((c.bufR_of_cand $hcn).trans hsig).symm
      | exact (c.cm_succ_of_cand (n := $n) (by decide) $hcn).symm))

set_option hygiene false in
/-- No candidate: the buffers stay `identity`; on to the next join. -/
local macro "item_invalid " n:num hcn:ident hK:ident : tactic =>
  `(tactic| (
    step_loop using $hK
    all_goals first
      | exact (c.bufA_of_not $hcn).symm
      | exact (c.bufR_of_not $hcn).symm
      | exact (c.cm_succ_of_not (n := $n) (by decide) $hcn).symm))

set_option hygiene false in
/-- Item `n` from its first block: `results[n] = FD_ED25519_ERR_SIG`, then
`fd_curve25519_scalar_validate( sigs[n]+32 )` as `clang` inlines it: the top byte below `0x10`, at
or above `0x20`, else the `subborrow.64` chain against `ℓ`. -/
local macro "item_check " n:num : tactic =>
  `(tactic| (
    step_pure
    step_store
    step_pure
    step_load
    step_pure
    step_pure
    step_load with b
    step_pure
    finish_block
    case isTrue =>
      have hcn : c.X.cand $n = true := hv.trans (validate_lo (hb ▸ hbr))
      item_valid $n hcn hK
    case isFalse =>
      block_init
      step_pure
      finish_block
      case isFalse =>
        have hcn : c.X.cand $n = false := hv.trans (validate_hi (hb ▸ hbr))
        item_invalid $n hcn hK
      case isTrue =>
        block_init
        step_load with l0
        step_pure
        step_load with l1
        step_pure
        step_load with l2
        step_pure
        step_load with l3
        iterate 9 step_pure
        finish_block
        case isTrue =>
          have hcn : c.X.cand $n = false := hv.trans (validate_sbb_zero hl0 hl1 hl2 hl3 hbr)
          item_invalid $n hcn hK
        case isFalse =>
          have hcn : c.X.cand $n = true := hv.trans (validate_sbb_ne hl0 hl1 hl2 hl3 hbr)
          item_valid $n hcn hK))

set_option hygiene false in
/-- The loop left at `cnt = n`: the buffers of the items from `n` on stay `identity`. -/
local macro "item_exit " hcnt:ident : tactic =>
  `(tactic| (
    have hK37 := fun (E' : ⟪Γ⟫) (hA' : E'.args = c.args) hR' =>
      bb37_run c E' S hA' hR' ($hcnt ▸ hS) (c.cand_ge' (j := 7) (by rw [$hcnt:ident]; decide)) h38
        h103
    step_loop using hK37
    all_goals first
      | exact (c.bufA_of_not (c.cand_ge' (by rw [$hcnt:ident]; decide))).symm
      | exact (c.bufR_of_not (c.cand_ge' (by rw [$hcnt:ident]; decide))).symm
      | exact ((congrArg c.cm $hcnt).symm.trans c.cm_cnt)))

set_option hygiene false in
/-- Item `7` a candidate: on to `^bb36`. -/
local macro "last_valid" : tactic =>
  `(tactic| (
    step_loop using hK36 hcn
    exact ((c.bufR_of_cand hcn).trans hsig).symm))

set_option hygiene false in
/-- Item `7` no candidate: on to `^bb37`. -/
local macro "last_invalid" : tactic =>
  `(tactic| (
    step_loop using hK37 hcn
    exact (c.cm_succ_of_not (n := 7) (by decide) hcn).symm.trans hm8))

set_option hygiene false in
/-- Item `0` no candidate: the buffers stay `identity`; on to `^bb4`. -/
local macro "first_invalid" : tactic =>
  `(tactic| (
    step_loop using hK
    · exact (c.bufA_of_not hcn).symm
    · exact (c.bufR_of_not hcn).symm
    · exact ((c.cm_succ_of_not (n := 0) (by decide) hcn).trans c.cm_zero).symm))

/-- `^bb37`: the loop's end; with candidates on to `^bb38`, else to the return. -/
theorem bb37_run (c : Call) (E : ⟪Γ⟫) (S : GlobalState) (hA : E.args = c.args)
    (hR : Env37 c E) (hS : c.Inv c.cnt S) (h7 : c.X.cand 7 = false) (h38 : To38 c g K)
    (h103 : To103 c g K) : ((verify_x8 c.batch).runFrom E 37 S >>= g) = K := by
  block_init
  iterate 5 step_pure
  finish_block
  case isTrue =>
    -- if( FD_UNLIKELY( !candidates ) ) return;
    step_loop using h103
    exact hS.base
  case isFalse =>
    step_loop using h38
    · exact (c.bufA_of_not h7).symm
    · exact (c.bufR_of_not h7).symm
    · exact hS.at38

/-- `^bb36`: item `7` a candidate, `cnt = 8`: `a_buf[7] = public_keys[7]`, `candidates |= 1<<7`;
on to `^bb38`. -/
theorem bb36_run (c : Call) (E : ⟪Γ⟫) (S : GlobalState) (hA : E.args = c.args)
    (hR : Env36 c E) (hS : c.Inv c.cnt S) (hcnt : c.cnt = 8) (hcn : c.X.cand 7 = true)
    (hpb : InBounds S.mem (c.a.pks.add 56#64) 64)
    (hpl : S.mem.loadPtr (c.a.pks.add 56#64) = .value (c.it 7).pk)
    (hpo : ¬c.a.pks.offset.uaddOverflow 56#64) (h38 : To38 c g K) :
    ((verify_x8 c.batch).runFrom E 36 S >>= g) = K := by
  have hK38 := fun (E' : ⟪Γ⟫) (hA' : E'.args = c.args) hR' =>
    h38 E' S hA' hR' hS.at38 (c.candMask_ne hcn)
  have hm8 : c.cm 8 = c.candMask := (congrArg c.cm hcnt).symm.trans c.cm_cnt
  clear hS h38 hcnt
  block_init
  step_pure
  step_load
  iterate 5 step_pure
  finish_block
  step_loop using hK38
  · exact (c.cm_succ_of_cand (n := 7) (by decide) hcn).symm.trans hm8
  · exact (c.bufA_of_cand hcn).symm

/-- `^bb33`: item `7` (`cnt = 8`); on to `^bb38` or `^bb37`. -/
theorem bb33_run (c : Call) (hc : c.Ok) (E : ⟪Γ⟫) (S : GlobalState) (hA : E.args = c.args)
    (hR : Env33 c E) (hS : c.Inv 7 S) (hcnt : c.cnt = 8) (h38 : To38 c g K)
    (h103 : To103 c g K) : ((verify_x8 c.batch).runFrom E 33 S >>= g) = K := by
  have hn : 7 < c.cnt := by omega
  obtain ⟨hr, hro, hsb, hsl, hso, hpb, hpl, hpo, hsf, hsr, hsigo, hne0, hne1, hne2⟩ :=
    hS.item hc hn
  simp only [Nat.reduceMul] at hr hro hsb hsl hso hpb hpl hpo
  have hv : c.X.cand 7 = _ := c.cand_eq hc hn (by decide)
  have hK36 := fun (h7 : c.X.cand 7 = true) (E' : ⟪Γ⟫) (hA' : E'.args = c.args) hR' hpb hpl =>
    bb36_run c E' { S with mem := S.mem.storeAt (c.a.results.add 28#64) 4294967295#32 } hA' hR'
      (hcnt ▸ hS.step hc hn) hcnt h7 hpb hpl hpo h38
  have hK37 := fun (h7 : c.X.cand 7 = false) (E' : ⟪Γ⟫) (hA' : E'.args = c.args) hR' =>
    bb37_run c E' { S with mem := S.mem.storeAt (c.a.results.add 28#64) 4294967295#32 } hA' hR'
      (hcnt ▸ hS.step hc hn) h7 h38 h103
  have hm8 : c.cm 8 = c.candMask := (congrArg c.cm hcnt).symm.trans c.cm_cnt
  clear hS h38 h103 hcnt hpo
  generalize hsig : (c.it 7).sig = sig at hsl hsf hsr hsigo hne2 hv
  block_init
  step_pure
  step_store
  step_pure
  step_load
  step_pure
  step_pure
  step_load with b
  step_pure
  finish_block
  case isTrue =>
    have hcn : c.X.cand 7 = true := hv.trans (validate_lo (hb ▸ hbr))
    last_valid
  case isFalse =>
    block_init
    step_pure
    finish_block
    case isFalse =>
      have hcn : c.X.cand 7 = false := hv.trans (validate_hi (hb ▸ hbr))
      last_invalid
    case isTrue =>
      block_init
      step_load with l0
      step_pure
      step_load with l1
      step_pure
      step_load with l2
      step_pure
      step_load with l3
      iterate 9 step_pure
      finish_block
      case isTrue =>
        have hcn : c.X.cand 7 = false := hv.trans (validate_sbb_zero hl0 hl1 hl2 hl3 hbr)
        last_invalid
      case isFalse =>
        have hcn : c.X.cand 7 = true := hv.trans (validate_sbb_ne hl0 hl1 hl2 hl3 hbr)
        last_valid

/-- `^bb32`: on to item `7` when `cnt = 8`, else to `^bb37`. -/
theorem bb32_run (c : Call) (hc : c.Ok) (E : ⟪Γ⟫) (S : GlobalState) (hA : E.args = c.args)
    (hR : Env32 c E) (hS : c.Inv 7 S) (h38 : To38 c g K) (h103 : To103 c g K) :
    ((verify_x8 c.batch).runFrom E 32 S >>= g) = K := by
  block_init
  step_pure
  finish_block
  case isFalse =>
    have hcnt : c.cnt = 7 := by have := hc.le_of_not_ult (by decide) hbr; have := hS.le; omega
    item_exit hcnt
  case isTrue =>
    have hcnt : c.cnt = 8 := by have := hc.lt_of_ult (by decide) hbr; have := hc.cnt8; omega
    step_loop using fun (E' : ⟪Γ⟫) (hA' : E'.args = c.args) hR' =>
      bb33_run c hc E' S hA' hR' hS hcnt h38 h103

/-- `^bb28`: item `6`. -/
theorem bb28_run (c : Call) (hc : c.Ok) (E : ⟪Γ⟫) (S : GlobalState) (hA : E.args = c.args)
    (hR : Env28 c E) (hS : c.Inv 6 S) (hn : 6 < c.cnt) (h38 : To38 c g K)
    (h103 : To103 c g K) : ((verify_x8 c.batch).runFrom E 28 S >>= g) = K := by
  item_init 6 hn bb32_run 24#64
  block_init
  item_check 6

/-- `^bb27`: on to item `6` when `6 < cnt`, else to `^bb37`. -/
theorem bb27_run (c : Call) (hc : c.Ok) (E : ⟪Γ⟫) (S : GlobalState) (hA : E.args = c.args)
    (hR : Env27 c E) (hS : c.Inv 6 S) (h38 : To38 c g K) (h103 : To103 c g K) :
    ((verify_x8 c.batch).runFrom E 27 S >>= g) = K := by
  block_init
  step_pure
  finish_block
  case isTrue =>
    have hcnt : c.cnt = 6 := hc.eq_of_ofNat (by decide) hbr
    item_exit hcnt
  case isFalse =>
    have hn : 6 < c.cnt := by have := Call.Ok.ne_of_ofNat hbr; have := hS.le; omega
    step_loop using fun (E' : ⟪Γ⟫) (hA' : E'.args = c.args) hR' =>
      bb28_run c hc E' S hA' hR' hS hn h38 h103

/-- `^bb23`: item `5`. -/
theorem bb23_run (c : Call) (hc : c.Ok) (E : ⟪Γ⟫) (S : GlobalState) (hA : E.args = c.args)
    (hR : Env23 c E) (hS : c.Inv 5 S) (hn : 5 < c.cnt) (h38 : To38 c g K)
    (h103 : To103 c g K) : ((verify_x8 c.batch).runFrom E 23 S >>= g) = K := by
  item_init 5 hn bb27_run 20#64
  block_init
  item_check 5

/-- `^bb22`: on to item `5` when `5 < cnt`, else to `^bb37`. -/
theorem bb22_run (c : Call) (hc : c.Ok) (E : ⟪Γ⟫) (S : GlobalState) (hA : E.args = c.args)
    (hR : Env22 c E) (hS : c.Inv 5 S) (h38 : To38 c g K) (h103 : To103 c g K) :
    ((verify_x8 c.batch).runFrom E 22 S >>= g) = K := by
  block_init
  step_pure
  finish_block
  case isFalse =>
    have hcnt : c.cnt = 5 := by have := hc.le_of_not_ult (by decide) hbr; have := hS.le; omega
    item_exit hcnt
  case isTrue =>
    have hn : 5 < c.cnt := hc.lt_of_ult (by decide) hbr
    step_loop using fun (E' : ⟪Γ⟫) (hA' : E'.args = c.args) hR' =>
      bb23_run c hc E' S hA' hR' hS hn h38 h103

/-- `^bb18`: item `4`. -/
theorem bb18_run (c : Call) (hc : c.Ok) (E : ⟪Γ⟫) (S : GlobalState) (hA : E.args = c.args)
    (hR : Env18 c E) (hS : c.Inv 4 S) (hn : 4 < c.cnt) (h38 : To38 c g K)
    (h103 : To103 c g K) : ((verify_x8 c.batch).runFrom E 18 S >>= g) = K := by
  item_init 4 hn bb22_run 16#64
  block_init
  item_check 4

/-- `^bb17`: on to item `4` when `4 < cnt`, else to `^bb37`. -/
theorem bb17_run (c : Call) (hc : c.Ok) (E : ⟪Γ⟫) (S : GlobalState) (hA : E.args = c.args)
    (hR : Env17 c E) (hS : c.Inv 4 S) (h38 : To38 c g K) (h103 : To103 c g K) :
    ((verify_x8 c.batch).runFrom E 17 S >>= g) = K := by
  block_init
  step_pure
  finish_block
  case isTrue =>
    have hcnt : c.cnt = 4 := hc.eq_of_ofNat (by decide) hbr
    item_exit hcnt
  case isFalse =>
    have hn : 4 < c.cnt := by have := Call.Ok.ne_of_ofNat hbr; have := hS.le; omega
    step_loop using fun (E' : ⟪Γ⟫) (hA' : E'.args = c.args) hR' =>
      bb18_run c hc E' S hA' hR' hS hn h38 h103

/-- `^bb13`: item `3`. -/
theorem bb13_run (c : Call) (hc : c.Ok) (E : ⟪Γ⟫) (S : GlobalState) (hA : E.args = c.args)
    (hR : Env13 c E) (hS : c.Inv 3 S) (hn : 3 < c.cnt) (h38 : To38 c g K)
    (h103 : To103 c g K) : ((verify_x8 c.batch).runFrom E 13 S >>= g) = K := by
  item_init 3 hn bb17_run 12#64
  block_init
  item_check 3

/-- `^bb12`: on to item `3` when `3 < cnt`, else to `^bb37`. -/
theorem bb12_run (c : Call) (hc : c.Ok) (E : ⟪Γ⟫) (S : GlobalState) (hA : E.args = c.args)
    (hR : Env12 c E) (hS : c.Inv 3 S) (h38 : To38 c g K) (h103 : To103 c g K) :
    ((verify_x8 c.batch).runFrom E 12 S >>= g) = K := by
  block_init
  step_pure
  finish_block
  case isFalse =>
    have hcnt : c.cnt = 3 := by have := hc.le_of_not_ult (by decide) hbr; have := hS.le; omega
    item_exit hcnt
  case isTrue =>
    have hn : 3 < c.cnt := hc.lt_of_ult (by decide) hbr
    step_loop using fun (E' : ⟪Γ⟫) (hA' : E'.args = c.args) hR' =>
      bb13_run c hc E' S hA' hR' hS hn h38 h103

/-- `^bb8`: item `2`. -/
theorem bb8_run (c : Call) (hc : c.Ok) (E : ⟪Γ⟫) (S : GlobalState) (hA : E.args = c.args)
    (hR : Env8 c E) (hS : c.Inv 2 S) (h38 : To38 c g K) (h103 : To103 c g K) :
    ((verify_x8 c.batch).runFrom E 8 S >>= g) = K := by
  have hn : 2 < c.cnt := by have := hc.cnt3; omega
  item_init 2 hn bb12_run 8#64
  block_init
  item_check 2

/-- `^bb4`: item `1`. -/
theorem bb4_run (c : Call) (hc : c.Ok) (E : ⟪Γ⟫) (S : GlobalState) (hA : E.args = c.args)
    (hR : Env4 c E) (hS : c.Inv 1 S) (h38 : To38 c g K) (h103 : To103 c g K) :
    ((verify_x8 c.batch).runFrom E 4 S >>= g) = K := by
  have hn : 1 < c.cnt := by have := hc.cnt3; omega
  item_init 1 hn bb8_run 4#64
  block_init
  item_check 1

/-- `^bb3`: item `0` a candidate: `a_buf[0] = public_keys[0]`, `r_buf[0] = sigs[0]`,
`candidates = 1`; on to `^bb4`. -/
theorem bb3_run (c : Call) (hc : c.Ok) (E : ⟪Γ⟫) (S : GlobalState) (hA : E.args = c.args)
    (hR : Env3 c E) (hS : c.Inv 1 S) (hcn : c.X.cand 0 = true) (hpb : InBounds S.mem c.a.pks 64)
    (hpl : S.mem.loadPtr c.a.pks = .value (c.it 0).pk) (h38 : To38 c g K) (h103 : To103 c g K) :
    ((verify_x8 c.batch).runFrom E 3 S >>= g) = K := by
  have hK := fun (E' : ⟪Γ⟫) (hA' : E'.args = c.args) hR' => bb4_run c hc E' S hA' hR' hS h38 h103
  clear hS h38 h103
  block_init
  step_load
  finish_block
  step_loop using hK
  · exact (c.bufA_of_cand hcn).symm
  · exact (c.bufR_of_cand hcn).symm
  · exact (c.cm_one hcn).symm

/-- `^bb1`: item `0`'s top byte from `0x10` on: below `0x20` the `subborrow.64` chain against `ℓ`;
on to `^bb3` or `^bb4`. -/
theorem bb1_run (c : Call) (hc : c.Ok) (E : ⟪Γ⟫) (S : GlobalState) (hA : E.args = c.args)
    (hR : Env1 c E) (hS : c.Inv 1 S)
    (hv :
      c.X.cand 0 =
        fd_curve25519_scalar_validate.spec ((c.s.mem.readAt (c.it 0).sig 512).extractLsb' 256 256))
    (hsf : Fits S.mem (c.it 0).sig 512)
    (hsr : S.mem.readAt (c.it 0).sig 512 = c.s.mem.readAt (c.it 0).sig 512)
    (hsigo : ¬(c.it 0).sig.offset.uaddOverflow 64#64) (hpb : InBounds S.mem c.a.pks 64)
    (hpl : S.mem.loadPtr c.a.pks = .value (c.it 0).pk) (h38 : To38 c g K) (h103 : To103 c g K) :
    ((verify_x8 c.batch).runFrom E 1 S >>= g) = K := by
  have hK := fun (E' : ⟪Γ⟫) (hA' : E'.args = c.args) hR' => bb4_run c hc E' S hA' hR' hS h38 h103
  have hK3 := fun (h : c.X.cand 0 = true) (E' : ⟪Γ⟫) (hA' : E'.args = c.args) hR' =>
    bb3_run c hc E' S hA' hR' hS h hpb hpl h38 h103
  clear hS h38 h103 hpb hpl
  unfold Env1 at hR
  generalize hsig : (c.it 0).sig = sig at hsf hsr hsigo hv hR
  block_init
  step_pure
  finish_block
  case isFalse =>
    -- s[31] ≥ 0x20: invalid
    have hcn : c.X.cand 0 = false := hv.trans (validate_hi hbr)
    first_invalid
  case isTrue =>
    -- the limbs of `s` against `ℓ`
    block_init
    step_load with l0
    step_pure
    step_load with l1
    step_pure
    step_load with l2
    step_pure
    step_load with l3
    iterate 9 step_pure
    finish_block
    case isTrue =>
      have hcn : c.X.cand 0 = false := hv.trans (validate_sbb_zero hl0 hl1 hl2 hl3 hbr)
      first_invalid
    case isFalse =>
      step_loop using hK3 (hv.trans (validate_sbb_ne hl0 hl1 hl2 hl3 hbr))

-- `^bb0` is one block of 179 instructions: the constants, the `alloca`s, item `0`'s start
set_option maxHeartbeats 500000 in
/-- `^bb0 … ^bb37`: on to `^bb38` with the candidates' buffers, or, without candidates, to the
return. -/
public theorem cand_run (c : Call) (hc : c.Ok) (E : ⟪Γ⟫) (hA : E.args = c.args)
    (h38 :
      ∀ (E' : ⟪Γ⟫) (S' : GlobalState), E'.args = c.args → Env38 c E' → c.At38 S' →
        c.candMask ≠ 0 → ((verify_x8 c.batch).runFrom E' 38 S' >>= g) = K)
    (h103 :
      ∀ (E' : ⟪Γ⟫) (S' : GlobalState), E'.args = c.args → Env103 c E' → c.Base S' c.mem38 →
        c.candMask = 0 → ((verify_x8 c.batch).runFrom E' 103 S' >>= g) = K) :
    ((verify_x8 c.batch).runFrom E 0 c.s >>= g) = K := by
  have hwf := hc.wf
  have hg := c.globals_own hc
  generalize hs₀ : c.s = s₀ at hwf hg ⊢
  block_init
  -- the constants and the two globals
  iterate 7 step_pure
  step_addressof tbl_value_eq with tblp
  have htbl : c.tbl = tblp := by
    have h := hglobal_tblp
    rw [hS, ← hs₀] at h
    exact ptr_of_global h htblp_off
  iterate 18 step_pure
  -- `kdMask`, a 505-lane literal: named, then compared by the kernel
  step_pure only with kdm
  have hkdm' : kdm = kdMask := by
    rw [hkdm]
    apply Vector.toList_inj.mp
    rw [kdMask, Vector.toList_ofFn]
    decide +kernel
  clear hkdm
  subst hkdm'
  iterate 33 step_pure
  step_addressof idp_value_eq with idpp
  have hidp : c.idp = idpp := by
    have h := hglobal_idpp
    rw [hS, ← hs₀] at h
    exact ptr_of_global h hidpp_off
  -- item `0`'s inputs, and `results` apart from the globals
  have hgall : S.mem.Globals ((verify_x8 c.batch).globals ++ c.G) := by
    rw [hS, ← hs₀]; exact hc.globals
  have hn : 0 < c.cnt := by have := hc.cnt3; omega
  obtain ⟨hr0, -, hsb0, hsl0, -, hpb0, hpl0, -, hsf0, hsigo0, hne0, hne1, hne2⟩ := hc.item hn
  simp only [Nat.zero_mul, Pointer.add_zero] at hr0 hsb0 hsl0 hpb0 hpl0
  rw [hs₀, ← hS] at hr0 hsb0 hsl0 hpb0 hpl0 hsf0
  have hv : c.X.cand 0 = _ := c.cand_eq hc hn (by decide)
  rw [hs₀] at hv
  have hsr0 : S.mem.readAt (c.it 0).sig 512 = s₀.mem.readAt (c.it 0).sig 512 := by rw [hS]
  have hrt : c.a.results.id ≠ c.tbl.id :=
    hc.results_ne_global (g := ⟨"fd_ed25519_lane_base_table",
      _root_.Firedancer.Lane.Mlir.fd_ed25519_lane_base_table⟩) (by simp)
      (by rw [GlobalInitializer.image_constant])
  have hri : c.a.results.id ≠ c.idp.id :=
    hc.results_ne_global
      (g := ⟨"verify_x8.identity", _root_.Firedancer.Lane.Mlir.verify_x8_identity⟩) (by simp)
      (by rw [GlobalInitializer.image_constant])
  rw [htbl] at hrt
  rw [hidp] at hri
  dsimp only [Call.args] at hArgs
  generalize hsig : (c.it 0).sig = sig at hsl0 hsf0 hsigo0 hne2 hv hsr0
  generalize hpk : (c.it 0).pk = pk at hpl0
  generalize hres : c.a.results = res at hArgs hr0 hne0 hne1 hne2 hrt hri
  generalize hsigs : c.a.sigs = sigs at hArgs hsb0 hsl0 hne0
  generalize hpks : c.a.pks = pks at hArgs hpb0 hpl0 hne1
  iterate 74 step_pure
  -- the 33 `alloca`s
  iterate 26 step_alloca
  step_alloca with k
  step_alloca with s
  iterate 5 step_alloca
  -- uchar k[8][32] = {{0}}, s[8][32] = {{0}};
  step_pure
  step_memset
  step_pure
  step_memset
  -- results[0] = FD_ED25519_ERR_SIG;
  step_store
  have hInv : c.Inv 1 S := by
    have hsl := forall_lt_33
        (P := fun j hj =>
          InBounds S.mem (s₀.slot j) (8 * slotBytes[j]) ∧ Writable S.mem (s₀.slot j))
        (by rw [← hv135]; exact ⟨hv135_bounds, hwritable_v135⟩)
        (by rw [← hv136]; exact ⟨hv136_bounds, hwritable_v136⟩)
        (by rw [← hv137]; exact ⟨hv137_bounds, hwritable_v137⟩)
        (by rw [← hv138]; exact ⟨hv138_bounds, hwritable_v138⟩)
        (by rw [← hv139]; exact ⟨hv139_bounds, hwritable_v139⟩)
        (by rw [← hv140]; exact ⟨hv140_bounds, hwritable_v140⟩)
        (by rw [← hv141]; exact ⟨hv141_bounds, hwritable_v141⟩)
        (by rw [← hv142]; exact ⟨hv142_bounds, hwritable_v142⟩)
        (by rw [← hv143]; exact ⟨hv143_bounds, hwritable_v143⟩)
        (by rw [← hv144]; exact ⟨hv144_bounds, hwritable_v144⟩)
        (by rw [← hv145]; exact ⟨hv145_bounds, hwritable_v145⟩)
        (by rw [← hv146]; exact ⟨hv146_bounds, hwritable_v146⟩)
        (by rw [← hv147]; exact ⟨hv147_bounds, hwritable_v147⟩)
        (by rw [← hv148]; exact ⟨hv148_bounds, hwritable_v148⟩)
        (by rw [← hv149]; exact ⟨hv149_bounds, hwritable_v149⟩)
        (by rw [← hv150]; exact ⟨hv150_bounds, hwritable_v150⟩)
        (by rw [← hv151]; exact ⟨hv151_bounds, hwritable_v151⟩)
        (by rw [← hv152]; exact ⟨hv152_bounds, hwritable_v152⟩)
        (by rw [← hv153]; exact ⟨hv153_bounds, hwritable_v153⟩)
        (by rw [← hv154]; exact ⟨hv154_bounds, hwritable_v154⟩)
        (by rw [← hv155]; exact ⟨hv155_bounds, hwritable_v155⟩)
        (by rw [← hv156]; exact ⟨hv156_bounds, hwritable_v156⟩)
        (by rw [← hv157]; exact ⟨hv157_bounds, hwritable_v157⟩)
        (by rw [← hv158]; exact ⟨hv158_bounds, hwritable_v158⟩)
        (by rw [← hv159]; exact ⟨hv159_bounds, hwritable_v159⟩)
        (by rw [← hv160]; exact ⟨hv160_bounds, hwritable_v160⟩)
        (by rw [← hk]; exact ⟨hk_bounds, hwritable_k⟩)
        (by rw [← hs]; exact ⟨hs_bounds, hwritable_s⟩)
        (by rw [← hv163]; exact ⟨hv163_bounds, hwritable_v163⟩)
        (by rw [← hv164]; exact ⟨hv164_bounds, hwritable_v164⟩)
        (by rw [← hv165]; exact ⟨hv165_bounds, hwritable_v165⟩)
        (by rw [← hv166]; exact ⟨hv166_bounds, hwritable_v166⟩)
        (by rw [← hv167]; exact ⟨hv167_bounds, hwritable_v167⟩)
    refine ⟨by omega, ⟨hwf, hgall, ?_, fun j hj => by rw [hs₀]; exact (hsl j hj).1,
      fun j hj => by rw [hs₀]; exact (hsl j hj).2, ?_, hc.tbl_lt, hc.idp_lt,
      by rw [htbl]; exact htblp_fits, by rw [htbl]; exact hread_tblp,
      by rw [hidp]; exact hidpp_fits, by rw [hidp]; exact hread_idpp⟩,
      ⟨by rw [hs₀, ← hk]; exact hfits_k, by rw [hs₀, ← hk]; exact hread_k,
        by rw [hs₀, ← hs]; exact hfits_s, by rw [hs₀, ← hs]; exact hread_s⟩,
      by rw [hres, htbl]; exact hrt, by rw [hres, hidp]; exact hri⟩
    · rw [hS, ← hs₀]
      simp only [GlobalState.alloca_alloc]
      omega
    · rw [hS, hs₀, hres]
      erase_frame
      rw [(hs₀ ▸ hc.wf : s₀.WF).eraseFrom]
      simp only [storeResults, Nat.zero_mul, Pointer.add_zero]
      rfl
  have hK3 := fun (h : c.X.cand 0 = true) (E' : ⟪Γ⟫) (hA' : E'.args = c.args) hR' =>
    bb3_run c hc E' S hA' hR' hInv h (by rw [hpks]; exact hpb0) (by rw [hpks, hpk]; exact hpl0) h38
      h103
  have hK1 := fun
      (h : ¬((c.s.mem.readAt (c.it 0).sig 512).extractLsb' 504 8).ult 16#8 = true) (E' : ⟪Γ⟫)
      (hA' : E'.args = c.args) hR' =>
    bb1_run c hc E' S hA' hR' hInv (by rw [hs₀, hsig]; exact hv) (by rw [hsig]; exact hsf0)
      (by rw [hsig, hs₀]; exact hsr0) (by rw [hsig]; exact hsigo0) (by rw [hpks]; exact hpb0)
      (by rw [hpks, hpk]; exact hpl0) h38 h103
  clear hInv h38 h103
  -- the joins' registers as the walk names them
  simp only [Env1, Env3, hs₀, htbl, hidp, hsig, ← hv135, ← hv136, ← hv137, ← hv138, ← hv139,
    ← hv140, ← hv141, ← hv142, ← hv143, ← hv144, ← hv145, ← hv146, ← hv147, ← hv148, ← hv149,
    ← hv150, ← hv151, ← hv152, ← hv153, ← hv154, ← hv155, ← hv156, ← hv157, ← hv158, ← hv159,
    ← hv160, ← hk, ← hs, ← hv163, ← hv164, ← hv165, ← hv166, ← hv167] at hK1 hK3
  -- the frame's facts, now in `hInv`
  clear hidpp_ne_k hidpp_ne_s hidpp_ne_v135 hidpp_ne_v136 hidpp_ne_v137 hidpp_ne_v138 hidpp_ne_v139
    hidpp_ne_v140 hidpp_ne_v141 hidpp_ne_v142 hidpp_ne_v143 hidpp_ne_v144 hidpp_ne_v145
    hidpp_ne_v146 hidpp_ne_v147 hidpp_ne_v148 hidpp_ne_v149 hidpp_ne_v150 hidpp_ne_v151
    hidpp_ne_v152 hidpp_ne_v153 hidpp_ne_v154 hidpp_ne_v155 hidpp_ne_v156 hidpp_ne_v157
    hidpp_ne_v158 hidpp_ne_v159 hidpp_ne_v160 hidpp_ne_v163 hidpp_ne_v164 hidpp_ne_v165
    hidpp_ne_v166 hidpp_ne_v167 hidpp_off hk_bounds hk_off hpks_ne_k hpks_ne_s hpks_ne_v135
    hpks_ne_v136 hpks_ne_v137 hpks_ne_v138 hpks_ne_v139 hpks_ne_v140 hpks_ne_v141 hpks_ne_v142
    hpks_ne_v143 hpks_ne_v144 hpks_ne_v145 hpks_ne_v146 hpks_ne_v147 hpks_ne_v148 hpks_ne_v149
    hpks_ne_v150 hpks_ne_v151 hpks_ne_v152 hpks_ne_v153 hpks_ne_v154 hpks_ne_v155 hpks_ne_v156
    hpks_ne_v157 hpks_ne_v158 hpks_ne_v159 hpks_ne_v160 hpks_ne_v163 hpks_ne_v164 hpks_ne_v165
    hpks_ne_v166 hpks_ne_v167 hres_ne_k hres_ne_s hres_ne_v135 hres_ne_v136 hres_ne_v137
    hres_ne_v138 hres_ne_v139 hres_ne_v140 hres_ne_v141 hres_ne_v142 hres_ne_v143 hres_ne_v144
    hres_ne_v145 hres_ne_v146 hres_ne_v147 hres_ne_v148 hres_ne_v149 hres_ne_v150 hres_ne_v151
    hres_ne_v152 hres_ne_v153 hres_ne_v154 hres_ne_v155 hres_ne_v156 hres_ne_v157 hres_ne_v158
    hres_ne_v159 hres_ne_v160 hres_ne_v163 hres_ne_v164 hres_ne_v165 hres_ne_v166 hres_ne_v167
    hs_bounds hs_off hsig_ne_k hsig_ne_s hsig_ne_v135 hsig_ne_v136 hsig_ne_v137 hsig_ne_v138
    hsig_ne_v139 hsig_ne_v140 hsig_ne_v141 hsig_ne_v142 hsig_ne_v143 hsig_ne_v144 hsig_ne_v145
    hsig_ne_v146 hsig_ne_v147 hsig_ne_v148 hsig_ne_v149 hsig_ne_v150 hsig_ne_v151 hsig_ne_v152
    hsig_ne_v153 hsig_ne_v154 hsig_ne_v155 hsig_ne_v156 hsig_ne_v157 hsig_ne_v158 hsig_ne_v159
    hsig_ne_v160 hsig_ne_v163 hsig_ne_v164 hsig_ne_v165 hsig_ne_v166 hsig_ne_v167 hsigs_ne_k
    hsigs_ne_s hsigs_ne_v135 hsigs_ne_v136 hsigs_ne_v137 hsigs_ne_v138 hsigs_ne_v139 hsigs_ne_v140
    hsigs_ne_v141 hsigs_ne_v142 hsigs_ne_v143 hsigs_ne_v144 hsigs_ne_v145 hsigs_ne_v146
    hsigs_ne_v147 hsigs_ne_v148 hsigs_ne_v149 hsigs_ne_v150 hsigs_ne_v151 hsigs_ne_v152
    hsigs_ne_v153 hsigs_ne_v154 hsigs_ne_v155 hsigs_ne_v156 hsigs_ne_v157 hsigs_ne_v158
    hsigs_ne_v159 hsigs_ne_v160 hsigs_ne_v163 hsigs_ne_v164 hsigs_ne_v165 hsigs_ne_v166
    hsigs_ne_v167 htblp_ne_k htblp_ne_s htblp_ne_v135 htblp_ne_v136 htblp_ne_v137 htblp_ne_v138
    htblp_ne_v139 htblp_ne_v140 htblp_ne_v141 htblp_ne_v142 htblp_ne_v143 htblp_ne_v144
    htblp_ne_v145 htblp_ne_v146 htblp_ne_v147 htblp_ne_v148 htblp_ne_v149 htblp_ne_v150
    htblp_ne_v151 htblp_ne_v152 htblp_ne_v153 htblp_ne_v154 htblp_ne_v155 htblp_ne_v156
    htblp_ne_v157 htblp_ne_v158 htblp_ne_v159 htblp_ne_v160 htblp_ne_v163 htblp_ne_v164
    htblp_ne_v165 htblp_ne_v166 htblp_ne_v167 htblp_off hv135_bounds hv135_off hv136_bounds
    hv136_off hv137_bounds hv137_off hv138_bounds hv138_off hv139_bounds hv139_off hv140_bounds
    hv140_off hv141_bounds hv141_off hv142_bounds hv142_off hv143_bounds hv143_off hv144_bounds
    hv144_off hv145_bounds hv145_off hv146_bounds hv146_off hv147_bounds hv147_off hv148_bounds
    hv148_off hv149_bounds hv149_off hv150_bounds hv150_off hv151_bounds hv151_off hv152_bounds
    hv152_off hv153_bounds hv153_off hv154_bounds hv154_off hv155_bounds hv155_off hv156_bounds
    hv156_off hv157_bounds hv157_off hv158_bounds hv158_off hv159_bounds hv159_off hv160_bounds
    hv160_off hv163_bounds hv163_off hv164_bounds hv164_off hv165_bounds hv165_off hv166_bounds
    hv166_off hv167_bounds hv167_off hwritable_k hwritable_s hwritable_v135 hwritable_v136
    hwritable_v137 hwritable_v138 hwritable_v139 hwritable_v140 hwritable_v141 hwritable_v142
    hwritable_v143 hwritable_v144 hwritable_v145 hwritable_v146 hwritable_v147 hwritable_v148
    hwritable_v149 hwritable_v150 hwritable_v151 hwritable_v152 hwritable_v153 hwritable_v154
    hwritable_v155 hwritable_v156 hwritable_v157 hwritable_v158 hwritable_v159 hwritable_v160
    hwritable_v163 hwritable_v164 hwritable_v165 hwritable_v166 hwritable_v167 hdefined_idpp
    hdefined_tblp hfits_k hfits_res hfits_s hglobal_idpp hglobal_tblp hidpp_fits hidpp_live
    hread_idpp hread_k hread_res hread_s hread_tblp hroom_k hroom_s htblp_fits htblp_live hg hgall
    hr0 hrt hri hne0 hne1 hne2 hn
  -- fd_curve25519_scalar_validate( sigs[0]+32 )
  step_load
  step_pure
  step_pure
  step_load with b
  step_pure
  finish_block
  case isTrue =>
    -- s[31] < 0x10: valid
    replace hArgs : E.args = c.args := by rw [hArgs, ← hres, ← hsigs, ← hpks]
    step_loop using hK3 (hv.trans (validate_lo (hb ▸ hbr)))
  case isFalse =>
    replace hArgs : E.args = c.args := by rw [hArgs, ← hres, ← hsigs, ← hpks]
    step_loop using hK1 (hb ▸ hbr)


end MLIR.Firedancer.Lane.VerifyX8

