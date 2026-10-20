module

public import Firedancer.Crc.Verify.Decode2.Head
public import Firedancer.Crc.Verify.Decode2.Mid
public import Firedancer.Crc.Verify.Decode2.Loop
public import Firedancer.Crc.Verify.Decode2.Check
public import Firedancer.Crc.Verify.Decode2.Tail
public import Firedancer.Crc.Verify.Decode2.Out
import Firedancer.Crc.Verify.Decode2.Tactics

/-! `fd_r52x5_ge_decode2`'s blocks composed: the branches into the loops, the entry, `call_eq`. -/

namespace MLIR.Firedancer.Crc.Verify

open MLIR.Firedancer.R52x5

@[expose] public section

namespace fd_r52x5_ge_decode2

set_option linter.all false

attribute [local mlir_env 1100] read_write_same

private theorem bb0_length : 961 ≥ bb0.body.length := by decide +kernel

private theorem bb7_length : 152 ≥ bb7.body.length := by decide +kernel

private theorem bb0_take : 0 + 139 ≤ bb0.body.length := by decide +kernel

/-- `Nat` bounds decided by their instances directly, without a search. -/
local instance (priority := high) decLtOrLe (a b c d : Nat) : Decidable (a < b ∨ c ≤ d) :=
  instDecidableOr

local instance (priority := high) decNatLt (a b : Nat) : Decidable (a < b) := Nat.decLt a b

local instance (priority := high) decNatLe (a b : Nat) : Decidable (a ≤ b) := Nat.decLe a b

local instance (priority := high) decNatEq (a b : Nat) : Decidable (a = b) := instDecidableEqNat a b

set_option maxHeartbeats 4000000 in
/-- `^bb1`: its quad call sites, then into `^bb4`'s loop. -/
theorem bb1_run {β : Type} {E : ⟪Γ⟫} {S : GlobalState}
    {g : Vals [.bv 32] × GlobalState → PoisonOr β} {K : PoisonOr β} {B : GlobalState}
    {M : MemoryState} {c : Nat} {a ea b eb : Pointer} (Q1357 Q1276 Q1221 : Quad5)
    (hArgs : E.args = (argsOf a ea b eb).get)
    (hR : E ⊨ [rir_reg% hty 654 := Ty.wrap (t := .vec 4 64) (Q1357.P0),
      rir_reg% hty 655 := Ty.wrap (t := .vec 4 64) (Q1357.P1),
      rir_reg% hty 656 := Ty.wrap (t := .vec 4 64) (Q1357.P2),
      rir_reg% hty 657 := Ty.wrap (t := .vec 4 64) (Q1357.P3),
      rir_reg% hty 658 := Ty.wrap (t := .vec 4 64) (Q1357.P4),
      rir_reg% hty 573 := Ty.wrap (t := .vec 4 64) (Q1276.P0),
      rir_reg% hty 574 := Ty.wrap (t := .vec 4 64) (Q1276.P1),
      rir_reg% hty 575 := Ty.wrap (t := .vec 4 64) (Q1276.P2),
      rir_reg% hty 576 := Ty.wrap (t := .vec 4 64) (Q1276.P3),
      rir_reg% hty 577 := Ty.wrap (t := .vec 4 64) (Q1276.P4),
      rir_reg% hty 261 := PoisonOr.value (B.slot 122),
      rir_reg% hty 262 := PoisonOr.value (B.slot 123),
      rir_reg% hty 263 := PoisonOr.value (B.slot 124),
      rir_reg% hty 264 := PoisonOr.value (B.slot 125),
      rir_reg% hty 265 := PoisonOr.value (B.slot 126),
      rir_reg% hty 266 := PoisonOr.value (B.slot 127),
      rir_reg% hty 267 := PoisonOr.value (B.slot 128),
      rir_reg% hty 268 := PoisonOr.value (B.slot 129),
      rir_reg% hty 269 := PoisonOr.value (B.slot 130),
      rir_reg% hty 270 := PoisonOr.value (B.slot 131),
      rir_reg% hty 271 := PoisonOr.value (B.slot 132),
      rir_reg% hty 272 := PoisonOr.value (B.slot 133),
      rir_reg% hty 273 := PoisonOr.value (B.slot 134),
      rir_reg% hty 274 := PoisonOr.value (B.slot 135),
      rir_reg% hty 275 := PoisonOr.value (B.slot 136),
      rir_reg% hty 518 := Ty.wrap (t := .vec 4 64) (Q1221.P0),
      rir_reg% hty 519 := Ty.wrap (t := .vec 4 64) (Q1221.P1),
      rir_reg% hty 520 := Ty.wrap (t := .vec 4 64) (Q1221.P2),
      rir_reg% hty 521 := Ty.wrap (t := .vec 4 64) (Q1221.P3),
      rir_reg% hty 522 := Ty.wrap (t := .vec 4 64) (Q1221.P4),
      rir_reg% hty 276 := PoisonOr.value (B.slot 137),
      rir_reg% hty 277 := PoisonOr.value (B.slot 138),
      rir_reg% hty 278 := PoisonOr.value (B.slot 139),
      rir_reg% hty 279 := PoisonOr.value (B.slot 140),
      rir_reg% hty 280 := PoisonOr.value (B.slot 141),
      rir_reg% hty 281 := PoisonOr.value (B.slot 142),
      rir_reg% hty 282 := PoisonOr.value (B.slot 143),
      rir_reg% hty 283 := PoisonOr.value (B.slot 144),
      rir_reg% hty 284 := PoisonOr.value (B.slot 145),
      rir_reg% hty 285 := PoisonOr.value (B.slot 146),
      rir_reg% hty 58 := PoisonOr.value (1#32)])
    (hI : Inv B M c S)
    (hK : ∀ (E' : ⟪Γ⟫) (S' : GlobalState), E'.args = (argsOf a ea b eb).get →
      Writes E E' 583 648 →
      (E' ⊨ [rir_reg% hty 638 := Ty.wrap (t := .vec 4 64) ((mulQ (sqrQ (sqrQ (sqrQ (sqrQ (sqrQ (sqrQ (sqrQ (sqrQ (sqrQ (sqrQ (mulQ Q1357 Q1276))))))))))) Q1221).P0), rir_reg% hty 639 := Ty.wrap (t := .vec 4 64) ((mulQ (sqrQ (sqrQ (sqrQ (sqrQ (sqrQ (sqrQ (sqrQ (sqrQ (sqrQ (sqrQ (mulQ Q1357 Q1276))))))))))) Q1221).P1), rir_reg% hty 640 := Ty.wrap (t := .vec 4 64) ((mulQ (sqrQ (sqrQ (sqrQ (sqrQ (sqrQ (sqrQ (sqrQ (sqrQ (sqrQ (sqrQ (mulQ Q1357 Q1276))))))))))) Q1221).P2), rir_reg% hty 641 := Ty.wrap (t := .vec 4 64) ((mulQ (sqrQ (sqrQ (sqrQ (sqrQ (sqrQ (sqrQ (sqrQ (sqrQ (sqrQ (sqrQ (mulQ Q1357 Q1276))))))))))) Q1221).P3), rir_reg% hty 642 := Ty.wrap (t := .vec 4 64) ((mulQ (sqrQ (sqrQ (sqrQ (sqrQ (sqrQ (sqrQ (sqrQ (sqrQ (sqrQ (sqrQ (mulQ Q1357 Q1276))))))))))) Q1221).P4)]) → Inv B M c S' →
      (fd_r52x5_ge_decode2.runFrom (hdr4 E' (sqrQ (mulQ (sqrQ (sqrQ (sqrQ (sqrQ (sqrQ (sqrQ (sqrQ (sqrQ (sqrQ (sqrQ (mulQ Q1357 Q1276))))))))))) Q1221)) 1) 4 S' >>= g) = K) :
    (fd_r52x5_ge_decode2.runFrom E 1 S >>= g) = K := by
  block_init
  refine bb1g0_run Q1357 Q1276 hArgs (by chain_reads) hI fun E1 S1 hA1 hW1 hR1 hI1 => ?_
  refine bb1g1_run (sqrQ (sqrQ (sqrQ (mulQ Q1357 Q1276)))) hA1 (by chain_reads) hI1 fun E2 S2 hA2 hW2 hR2 hI2 => ?_
  refine bb1g2_run (sqrQ (sqrQ (sqrQ (sqrQ (sqrQ (sqrQ (sqrQ (mulQ Q1357 Q1276)))))))) Q1221 hA2 (by chain_reads) hI2 fun E3 S3 hA3 hW3 hR3 hI3 => ?_
  refine bb1g3_run (mulQ (sqrQ (sqrQ (sqrQ (sqrQ (sqrQ (sqrQ (sqrQ (sqrQ (sqrQ (sqrQ (mulQ Q1357 Q1276))))))))))) Q1221) hA3 (by chain_reads) hI3 fun E4 S4 hA4 hW4 hR4 hI4 => ?_
  have h1 : E4.read (rir_reg% hty 58) = .value 1#32 := by chain_reads
  finish_block
  rw [hE] at hArgs ⊢
  have hR3' := hR3
  refine hK E4 S4 hArgs ((((hW1.mono (by decide) (by decide)).trans (hW2.mono (by decide) (by decide))).trans
    (hW3.mono (by decide) (by decide))).trans (hW4.mono (by decide) (by decide))) ?_ hI4
  chain_reads

/-- `^bb3`: its quad call sites, then into `^bb6`'s loop. -/
theorem bb3_run {β : Type} {E : ⟪Γ⟫} {S : GlobalState}
    {g : Vals [.bv 32] × GlobalState → PoisonOr β} {K : PoisonOr β} {B : GlobalState}
    {M : MemoryState} {c : Nat} {a ea b eb : Pointer} (Q1380 Q1341 : Quad5)
    (hArgs : E.args = (argsOf a ea b eb).get)
    (hR : E ⊨ [rir_reg% hty 677 := Ty.wrap (t := .vec 4 64) (Q1380.P0),
      rir_reg% hty 678 := Ty.wrap (t := .vec 4 64) (Q1380.P1),
      rir_reg% hty 679 := Ty.wrap (t := .vec 4 64) (Q1380.P2),
      rir_reg% hty 680 := Ty.wrap (t := .vec 4 64) (Q1380.P3),
      rir_reg% hty 681 := Ty.wrap (t := .vec 4 64) (Q1380.P4),
      rir_reg% hty 638 := Ty.wrap (t := .vec 4 64) (Q1341.P0),
      rir_reg% hty 639 := Ty.wrap (t := .vec 4 64) (Q1341.P1),
      rir_reg% hty 640 := Ty.wrap (t := .vec 4 64) (Q1341.P2),
      rir_reg% hty 641 := Ty.wrap (t := .vec 4 64) (Q1341.P3),
      rir_reg% hty 642 := Ty.wrap (t := .vec 4 64) (Q1341.P4),
      rir_reg% hty 291 := PoisonOr.value (B.slot 152),
      rir_reg% hty 292 := PoisonOr.value (B.slot 153),
      rir_reg% hty 293 := PoisonOr.value (B.slot 154),
      rir_reg% hty 294 := PoisonOr.value (B.slot 155),
      rir_reg% hty 295 := PoisonOr.value (B.slot 156),
      rir_reg% hty 296 := PoisonOr.value (B.slot 157),
      rir_reg% hty 297 := PoisonOr.value (B.slot 158),
      rir_reg% hty 298 := PoisonOr.value (B.slot 159),
      rir_reg% hty 299 := PoisonOr.value (B.slot 160),
      rir_reg% hty 300 := PoisonOr.value (B.slot 161),
      rir_reg% hty 58 := PoisonOr.value (1#32)])
    (hI : Inv B M c S)
    (hK : ∀ (E' : ⟪Γ⟫) (S' : GlobalState), E'.args = (argsOf a ea b eb).get →
      Writes E E' 661 671 →
      (E' ⊨ [rir_reg% hty 661 := Ty.wrap (t := .vec 4 64) ((mulQ Q1380 Q1341).P0), rir_reg% hty 662 := Ty.wrap (t := .vec 4 64) ((mulQ Q1380 Q1341).P1), rir_reg% hty 663 := Ty.wrap (t := .vec 4 64) ((mulQ Q1380 Q1341).P2), rir_reg% hty 664 := Ty.wrap (t := .vec 4 64) ((mulQ Q1380 Q1341).P3), rir_reg% hty 665 := Ty.wrap (t := .vec 4 64) ((mulQ Q1380 Q1341).P4)]) → Inv B M c S' →
      (fd_r52x5_ge_decode2.runFrom (hdr6 E' (sqrQ (mulQ Q1380 Q1341)) 1) 6 S' >>= g) = K) :
    (fd_r52x5_ge_decode2.runFrom E 3 S >>= g) = K := by
  block_init
  refine bb3g0_run _ _ hArgs (by chain_reads) hI fun E1 S1 hA1 hW1 hR1 hI1 => ?_
  have h1 : E1.read (rir_reg% hty 58) = .value 1#32 := by chain_reads
  finish_block
  rw [hE] at hArgs ⊢
  refine hK E1 S1 hArgs (hW1.mono (by decide) (by decide)) ?_ hI1
  chain_reads

/-- `^bb5`: its quad call sites, then into `^bb8`'s loop. -/
theorem bb5_run {β : Type} {E : ⟪Γ⟫} {S : GlobalState}
    {g : Vals [.bv 32] × GlobalState → PoisonOr β} {K : PoisonOr β} {B : GlobalState}
    {M : MemoryState} {c : Nat} {a ea b eb : Pointer} (Q1403 Q1364 : Quad5)
    (hArgs : E.args = (argsOf a ea b eb).get)
    (hR : E ⊨ [rir_reg% hty 700 := Ty.wrap (t := .vec 4 64) (Q1403.P0),
      rir_reg% hty 701 := Ty.wrap (t := .vec 4 64) (Q1403.P1),
      rir_reg% hty 702 := Ty.wrap (t := .vec 4 64) (Q1403.P2),
      rir_reg% hty 703 := Ty.wrap (t := .vec 4 64) (Q1403.P3),
      rir_reg% hty 704 := Ty.wrap (t := .vec 4 64) (Q1403.P4),
      rir_reg% hty 661 := Ty.wrap (t := .vec 4 64) (Q1364.P0),
      rir_reg% hty 662 := Ty.wrap (t := .vec 4 64) (Q1364.P1),
      rir_reg% hty 663 := Ty.wrap (t := .vec 4 64) (Q1364.P2),
      rir_reg% hty 664 := Ty.wrap (t := .vec 4 64) (Q1364.P3),
      rir_reg% hty 665 := Ty.wrap (t := .vec 4 64) (Q1364.P4),
      rir_reg% hty 306 := PoisonOr.value (B.slot 167),
      rir_reg% hty 307 := PoisonOr.value (B.slot 168),
      rir_reg% hty 308 := PoisonOr.value (B.slot 169),
      rir_reg% hty 309 := PoisonOr.value (B.slot 170),
      rir_reg% hty 310 := PoisonOr.value (B.slot 171),
      rir_reg% hty 311 := PoisonOr.value (B.slot 172),
      rir_reg% hty 312 := PoisonOr.value (B.slot 173),
      rir_reg% hty 313 := PoisonOr.value (B.slot 174),
      rir_reg% hty 314 := PoisonOr.value (B.slot 175),
      rir_reg% hty 315 := PoisonOr.value (B.slot 176),
      rir_reg% hty 58 := PoisonOr.value (1#32)])
    (hI : Inv B M c S)
    (hK : ∀ (E' : ⟪Γ⟫) (S' : GlobalState), E'.args = (argsOf a ea b eb).get →
      Writes E E' 684 694 →
      (E' ⊨ [rir_reg% hty 684 := Ty.wrap (t := .vec 4 64) ((mulQ Q1403 Q1364).P0), rir_reg% hty 685 := Ty.wrap (t := .vec 4 64) ((mulQ Q1403 Q1364).P1), rir_reg% hty 686 := Ty.wrap (t := .vec 4 64) ((mulQ Q1403 Q1364).P2), rir_reg% hty 687 := Ty.wrap (t := .vec 4 64) ((mulQ Q1403 Q1364).P3), rir_reg% hty 688 := Ty.wrap (t := .vec 4 64) ((mulQ Q1403 Q1364).P4)]) → Inv B M c S' →
      (fd_r52x5_ge_decode2.runFrom (hdr8 E' (sqrQ (mulQ Q1403 Q1364)) 1) 8 S' >>= g) = K) :
    (fd_r52x5_ge_decode2.runFrom E 5 S >>= g) = K := by
  block_init
  refine bb5g0_run _ _ hArgs (by chain_reads) hI fun E1 S1 hA1 hW1 hR1 hI1 => ?_
  have h1 : E1.read (rir_reg% hty 58) = .value 1#32 := by chain_reads
  finish_block
  rw [hE] at hArgs ⊢
  refine hK E1 S1 hArgs (hW1.mono (by decide) (by decide)) ?_ hI1
  chain_reads

set_option maxHeartbeats 4000000 in
/-- `^bb7`: the end of the power, `x`, `v x²`, `-u`, lane 0's first check, and on to `^bb9` or
`^bb10`. -/
theorem bb7_run {β : Type} {E : ⟪Γ⟫} {S : GlobalState}
    {g : Vals [.bv 32] × GlobalState → PoisonOr β} {K : PoisonOr β} {B : GlobalState}
    {M : MemoryState} {c : Nat} {a ea b eb : Pointer} (Q1463 Q1341 Q1156 Q1121 Q1141 Q1131 : Quad5)
    (hArgs : E.args = (argsOf a ea b eb).get)
    (hR : E ⊨ [rir_reg% hty 760 := Ty.wrap (t := .vec 4 64) (Q1463.P0),
      rir_reg% hty 761 := Ty.wrap (t := .vec 4 64) (Q1463.P1),
      rir_reg% hty 762 := Ty.wrap (t := .vec 4 64) (Q1463.P2),
      rir_reg% hty 763 := Ty.wrap (t := .vec 4 64) (Q1463.P3),
      rir_reg% hty 764 := Ty.wrap (t := .vec 4 64) (Q1463.P4),
      rir_reg% hty 638 := Ty.wrap (t := .vec 4 64) (Q1341.P0),
      rir_reg% hty 639 := Ty.wrap (t := .vec 4 64) (Q1341.P1),
      rir_reg% hty 640 := Ty.wrap (t := .vec 4 64) (Q1341.P2),
      rir_reg% hty 641 := Ty.wrap (t := .vec 4 64) (Q1341.P3),
      rir_reg% hty 642 := Ty.wrap (t := .vec 4 64) (Q1341.P4),
      rir_reg% hty 321 := PoisonOr.value (B.slot 182),
      rir_reg% hty 322 := PoisonOr.value (B.slot 183),
      rir_reg% hty 323 := PoisonOr.value (B.slot 184),
      rir_reg% hty 324 := PoisonOr.value (B.slot 185),
      rir_reg% hty 325 := PoisonOr.value (B.slot 186),
      rir_reg% hty 326 := PoisonOr.value (B.slot 187),
      rir_reg% hty 327 := PoisonOr.value (B.slot 188),
      rir_reg% hty 328 := PoisonOr.value (B.slot 189),
      rir_reg% hty 329 := PoisonOr.value (B.slot 190),
      rir_reg% hty 330 := PoisonOr.value (B.slot 191),
      rir_reg% hty 331 := PoisonOr.value (B.slot 192),
      rir_reg% hty 332 := PoisonOr.value (B.slot 193),
      rir_reg% hty 333 := PoisonOr.value (B.slot 194),
      rir_reg% hty 334 := PoisonOr.value (B.slot 195),
      rir_reg% hty 335 := PoisonOr.value (B.slot 196),
      rir_reg% hty 453 := Ty.wrap (t := .vec 4 64) (Q1156.P0),
      rir_reg% hty 454 := Ty.wrap (t := .vec 4 64) (Q1156.P1),
      rir_reg% hty 455 := Ty.wrap (t := .vec 4 64) (Q1156.P2),
      rir_reg% hty 456 := Ty.wrap (t := .vec 4 64) (Q1156.P3),
      rir_reg% hty 457 := Ty.wrap (t := .vec 4 64) (Q1156.P4),
      rir_reg% hty 336 := PoisonOr.value (B.slot 197),
      rir_reg% hty 337 := PoisonOr.value (B.slot 198),
      rir_reg% hty 338 := PoisonOr.value (B.slot 199),
      rir_reg% hty 339 := PoisonOr.value (B.slot 200),
      rir_reg% hty 340 := PoisonOr.value (B.slot 201),
      rir_reg% hty 418 := Ty.wrap (t := .vec 4 64) (Q1121.P0),
      rir_reg% hty 419 := Ty.wrap (t := .vec 4 64) (Q1121.P1),
      rir_reg% hty 420 := Ty.wrap (t := .vec 4 64) (Q1121.P2),
      rir_reg% hty 421 := Ty.wrap (t := .vec 4 64) (Q1121.P3),
      rir_reg% hty 422 := Ty.wrap (t := .vec 4 64) (Q1121.P4),
      rir_reg% hty 438 := Ty.wrap (t := .vec 4 64) (Q1141.P0),
      rir_reg% hty 439 := Ty.wrap (t := .vec 4 64) (Q1141.P1),
      rir_reg% hty 440 := Ty.wrap (t := .vec 4 64) (Q1141.P2),
      rir_reg% hty 441 := Ty.wrap (t := .vec 4 64) (Q1141.P3),
      rir_reg% hty 442 := Ty.wrap (t := .vec 4 64) (Q1141.P4),
      rir_reg% hty 341 := PoisonOr.value (B.slot 202),
      rir_reg% hty 342 := PoisonOr.value (B.slot 203),
      rir_reg% hty 343 := PoisonOr.value (B.slot 204),
      rir_reg% hty 344 := PoisonOr.value (B.slot 205),
      rir_reg% hty 345 := PoisonOr.value (B.slot 206),
      rir_reg% hty 346 := PoisonOr.value (B.slot 207),
      rir_reg% hty 347 := PoisonOr.value (B.slot 208),
      rir_reg% hty 348 := PoisonOr.value (B.slot 209),
      rir_reg% hty 349 := PoisonOr.value (B.slot 210),
      rir_reg% hty 350 := PoisonOr.value (B.slot 211),
      rir_reg% hty 351 := PoisonOr.value (B.slot 212),
      rir_reg% hty 352 := PoisonOr.value (B.slot 213),
      rir_reg% hty 353 := PoisonOr.value (B.slot 214),
      rir_reg% hty 354 := PoisonOr.value (B.slot 215),
      rir_reg% hty 355 := PoisonOr.value (B.slot 216),
      rir_reg% hty 428 := Ty.wrap (t := .vec 4 64) (Q1131.P0),
      rir_reg% hty 429 := Ty.wrap (t := .vec 4 64) (Q1131.P1),
      rir_reg% hty 430 := Ty.wrap (t := .vec 4 64) (Q1131.P2),
      rir_reg% hty 431 := Ty.wrap (t := .vec 4 64) (Q1131.P3),
      rir_reg% hty 432 := Ty.wrap (t := .vec 4 64) (Q1131.P4),
      rir_reg% hty 356 := PoisonOr.value (B.slot 217),
      rir_reg% hty 357 := PoisonOr.value (B.slot 218),
      rir_reg% hty 358 := PoisonOr.value (B.slot 219),
      rir_reg% hty 359 := PoisonOr.value (B.slot 220),
      rir_reg% hty 360 := PoisonOr.value (B.slot 221),
      rir_reg% hty 361 := PoisonOr.value (B.slot 222),
      rir_reg% hty 362 := PoisonOr.value (B.slot 223),
      rir_reg% hty 363 := PoisonOr.value (B.slot 224),
      rir_reg% hty 364 := PoisonOr.value (B.slot 225),
      rir_reg% hty 365 := PoisonOr.value (B.slot 226),
      rir_reg% hty 366 := PoisonOr.value (B.slot 227),
      rir_reg% hty 367 := PoisonOr.value (B.slot 228),
      rir_reg% hty 368 := PoisonOr.value (B.slot 229),
      rir_reg% hty 62 := PoisonOr.value (0#32),
      rir_reg% hty 58 := PoisonOr.value (1#32)])
    (hI : Inv B M c S)
    (hK9 : ∀ (E' : ⟪Γ⟫) (S' : GlobalState), E'.args = (argsOf a ea b eb).get →
      Writes E E' 707 754 →
      (E' ⊨ [rir_reg% hty 732 := Ty.wrap (t := .vec 4 64) ((mulQ (mulQ Q1121 Q1141) (mulQ (sqrQ (sqrQ (mulQ Q1463 Q1341))) Q1156)).P0), rir_reg% hty 733 := Ty.wrap (t := .vec 4 64) ((mulQ (mulQ Q1121 Q1141) (mulQ (sqrQ (sqrQ (mulQ Q1463 Q1341))) Q1156)).P1),
        rir_reg% hty 734 := Ty.wrap (t := .vec 4 64) ((mulQ (mulQ Q1121 Q1141) (mulQ (sqrQ (sqrQ (mulQ Q1463 Q1341))) Q1156)).P2), rir_reg% hty 735 := Ty.wrap (t := .vec 4 64) ((mulQ (mulQ Q1121 Q1141) (mulQ (sqrQ (sqrQ (mulQ Q1463 Q1341))) Q1156)).P3), rir_reg% hty 736 := Ty.wrap (t := .vec 4 64) ((mulQ (mulQ Q1121 Q1141) (mulQ (sqrQ (sqrQ (mulQ Q1463 Q1341))) Q1156)).P4),
        rir_reg% hty 742 := Ty.wrap (t := .vec 4 64) ((mulQ Q1131 (sqrQ (mulQ (mulQ Q1121 Q1141) (mulQ (sqrQ (sqrQ (mulQ Q1463 Q1341))) Q1156)))).P0), rir_reg% hty 743 := Ty.wrap (t := .vec 4 64) ((mulQ Q1131 (sqrQ (mulQ (mulQ Q1121 Q1141) (mulQ (sqrQ (sqrQ (mulQ Q1463 Q1341))) Q1156)))).P1),
        rir_reg% hty 744 := Ty.wrap (t := .vec 4 64) ((mulQ Q1131 (sqrQ (mulQ (mulQ Q1121 Q1141) (mulQ (sqrQ (sqrQ (mulQ Q1463 Q1341))) Q1156)))).P2), rir_reg% hty 745 := Ty.wrap (t := .vec 4 64) ((mulQ Q1131 (sqrQ (mulQ (mulQ Q1121 Q1141) (mulQ (sqrQ (sqrQ (mulQ Q1463 Q1341))) Q1156)))).P3),
        rir_reg% hty 746 := Ty.wrap (t := .vec 4 64) ((mulQ Q1131 (sqrQ (mulQ (mulQ Q1121 Q1141) (mulQ (sqrQ (sqrQ (mulQ Q1463 Q1341))) Q1156)))).P4),
        rir_reg% hty 747 := Ty.wrap (t := .vec 4 64) ((fd_r52x5_quad_neg.spec Q1121).P0), rir_reg% hty 748 := Ty.wrap (t := .vec 4 64) ((fd_r52x5_quad_neg.spec Q1121).P1),
        rir_reg% hty 749 := Ty.wrap (t := .vec 4 64) ((fd_r52x5_quad_neg.spec Q1121).P2), rir_reg% hty 750 := Ty.wrap (t := .vec 4 64) ((fd_r52x5_quad_neg.spec Q1121).P3),
        rir_reg% hty 751 := Ty.wrap (t := .vec 4 64) ((fd_r52x5_quad_neg.spec Q1121).P4)]) →
      fd_r52x5_limbs_eq.spec (fd_r52x5_quad_lane_canon.spec (mulQ Q1131 (sqrQ (mulQ (mulQ Q1121 Q1141) (mulQ (sqrQ (sqrQ (mulQ Q1463 Q1341))) Q1156)))) 0)
        (fd_r52x5_quad_lane_canon.spec Q1121 0) = 0 →
      S'.WF ∧ S'.mem.readLimbs (B.slot 227) = fd_r52x5_quad_lane_canon.spec (mulQ Q1131 (sqrQ (mulQ (mulQ Q1121 Q1141) (mulQ (sqrQ (sqrQ (mulQ Q1463 Q1341))) Q1156)))) 0 ∧
        S'.mem.readLimbs (B.slot 229) = fd_r52x5_quad_lane_canon.spec (fd_r52x5_quad_neg.spec Q1121) 0 ∧
        S'.mem.LimbsFit (B.slot 227) ∧ S'.mem.LimbsFit (B.slot 229) →
      Inv B M (c + 18) S' → (fd_r52x5_ge_decode2.runFrom E' 9 S' >>= g) = K)
    (hK10 : ∀ (E' : ⟪Γ⟫) (S' : GlobalState), E'.args = (argsOf a ea b eb).get →
      Writes E E' 707 771 →
      (E' ⊨ [rir_reg% hty 732 := Ty.wrap (t := .vec 4 64) ((mulQ (mulQ Q1121 Q1141) (mulQ (sqrQ (sqrQ (mulQ Q1463 Q1341))) Q1156)).P0), rir_reg% hty 733 := Ty.wrap (t := .vec 4 64) ((mulQ (mulQ Q1121 Q1141) (mulQ (sqrQ (sqrQ (mulQ Q1463 Q1341))) Q1156)).P1),
        rir_reg% hty 734 := Ty.wrap (t := .vec 4 64) ((mulQ (mulQ Q1121 Q1141) (mulQ (sqrQ (sqrQ (mulQ Q1463 Q1341))) Q1156)).P2), rir_reg% hty 735 := Ty.wrap (t := .vec 4 64) ((mulQ (mulQ Q1121 Q1141) (mulQ (sqrQ (sqrQ (mulQ Q1463 Q1341))) Q1156)).P3), rir_reg% hty 736 := Ty.wrap (t := .vec 4 64) ((mulQ (mulQ Q1121 Q1141) (mulQ (sqrQ (sqrQ (mulQ Q1463 Q1341))) Q1156)).P4),
        rir_reg% hty 742 := Ty.wrap (t := .vec 4 64) ((mulQ Q1131 (sqrQ (mulQ (mulQ Q1121 Q1141) (mulQ (sqrQ (sqrQ (mulQ Q1463 Q1341))) Q1156)))).P0), rir_reg% hty 743 := Ty.wrap (t := .vec 4 64) ((mulQ Q1131 (sqrQ (mulQ (mulQ Q1121 Q1141) (mulQ (sqrQ (sqrQ (mulQ Q1463 Q1341))) Q1156)))).P1),
        rir_reg% hty 744 := Ty.wrap (t := .vec 4 64) ((mulQ Q1131 (sqrQ (mulQ (mulQ Q1121 Q1141) (mulQ (sqrQ (sqrQ (mulQ Q1463 Q1341))) Q1156)))).P2), rir_reg% hty 745 := Ty.wrap (t := .vec 4 64) ((mulQ Q1131 (sqrQ (mulQ (mulQ Q1121 Q1141) (mulQ (sqrQ (sqrQ (mulQ Q1463 Q1341))) Q1156)))).P3),
        rir_reg% hty 746 := Ty.wrap (t := .vec 4 64) ((mulQ Q1131 (sqrQ (mulQ (mulQ Q1121 Q1141) (mulQ (sqrQ (sqrQ (mulQ Q1463 Q1341))) Q1156)))).P4),
        rir_reg% hty 747 := Ty.wrap (t := .vec 4 64) ((fd_r52x5_quad_neg.spec Q1121).P0), rir_reg% hty 748 := Ty.wrap (t := .vec 4 64) ((fd_r52x5_quad_neg.spec Q1121).P1),
        rir_reg% hty 749 := Ty.wrap (t := .vec 4 64) ((fd_r52x5_quad_neg.spec Q1121).P2), rir_reg% hty 750 := Ty.wrap (t := .vec 4 64) ((fd_r52x5_quad_neg.spec Q1121).P3),
        rir_reg% hty 751 := Ty.wrap (t := .vec 4 64) ((fd_r52x5_quad_neg.spec Q1121).P4), rir_reg% hty 769 := PoisonOr.value (0#32), rir_reg% hty 770 := PoisonOr.value (1#32)]) →
      fd_r52x5_limbs_eq.spec (fd_r52x5_quad_lane_canon.spec (mulQ Q1131 (sqrQ (mulQ (mulQ Q1121 Q1141) (mulQ (sqrQ (sqrQ (mulQ Q1463 Q1341))) Q1156)))) 0)
        (fd_r52x5_quad_lane_canon.spec Q1121 0) ≠ 0 →
      Inv B M (c + 18) S' → (fd_r52x5_ge_decode2.runFrom E' 10 S' >>= g) = K) :
    (fd_r52x5_ge_decode2.runFrom E 7 S >>= g) = K := by
  block_init
  refine bb7g0_run _ _ _ _ _ hArgs (by chain_reads) hI fun E1 S1 hA1 hW1 hR1 hI1 => ?_
  refine bb7g1_run _ _ _ _ hA1 (by chain_reads) hI1 fun E2 S2 hA2 hW2 hR2 hI2 => ?_
  refine lane0_run (mulQ Q1131 (sqrQ (mulQ (mulQ Q1121 Q1141) (mulQ (sqrQ (sqrQ (mulQ Q1463 Q1341))) Q1156)))) Q1121 (fd_r52x5_quad_neg.spec Q1121) hA2 (by chain_reads) hI2
    fun E3 S3 hA3 hW3 hR3 hv hn f0 f2 hI3 => ?_
  rw [BasicBlock.runBodyFrom_done bb7_length]
  simp only [EffectM.pure_eq, PoisonOr.value_bind, reduceBlockExit, Exit.run]
  have hc := hR3.2
  rw [hc]
  by_cases h0 : fd_r52x5_limbs_eq.spec (fd_r52x5_quad_lane_canon.spec (mulQ Q1131 (sqrQ (mulQ (mulQ Q1121 Q1141) (mulQ (sqrQ (sqrQ (mulQ Q1463 Q1341))) Q1156)))) 0)
      (fd_r52x5_quad_lane_canon.spec Q1121 0) = 0
  · simp only [h0, show (BitVec.ofBool ((0 : BitVec 32) == 0#32) == 1#1) = true by decide,
      ↓reduceIte, Regs.read_nil, Env.writeMany_nil, EffectM.pure_eq, PoisonOr.value_bind]
    dsimp only [Jump.run, Regs.read_nil, EffectM.pure_eq, PoisonOr.value_bind, reduceWriteManyDsts,
      Env.writeMany_nil]
    rw [Func.continue_next]
    refine hK9 E3 S3 hA3 ?_ ?_ h0 ⟨hI3.wf, hv, hn, f0, f2⟩ hI3
    · exact ((hW1.mono (by decide) (by decide)).trans (hW2.mono (by decide) (by decide))).trans
        (hW3.mono (by decide) (by decide))
    · chain_reads
  · have h1 : (BitVec.ofBool (fd_r52x5_limbs_eq.spec (fd_r52x5_quad_lane_canon.spec (mulQ Q1131 (sqrQ (mulQ (mulQ Q1121 Q1141) (mulQ (sqrQ (sqrQ (mulQ Q1463 Q1341))) Q1156)))) 0)
        (fd_r52x5_quad_lane_canon.spec Q1121 0) == 0#32) == 1#1) = false := by
      rcases limbs_eq_01 (fd_r52x5_quad_lane_canon.spec (mulQ Q1131 (sqrQ (mulQ (mulQ Q1121 Q1141) (mulQ (sqrQ (sqrQ (mulQ Q1463 Q1341))) Q1156)))) 0)
        (fd_r52x5_quad_lane_canon.spec Q1121 0) with h | h
      · exact absurd h h0
      · rw [h]; decide
    simp only [h1, Bool.false_eq_true, ↓reduceIte, Regs.read_cons, Regs.read_nil, EffectM.pure_eq,
      PoisonOr.value_bind, reduceWriteManyDsts, Env.writeMany_nil, Env.writeMany_cons]
    dsimp only [Jump.run, Regs.read_cons, Regs.read_nil, EffectM.pure_eq, PoisonOr.value_bind,
      reduceWriteManyDsts, Env.writeMany_nil, Env.writeMany_cons]
    rw [Func.continue_next]
    have r0 : E3.read (rir_reg% hty 62) = .value 0#32 := by chain_reads
    have r1 : E3.read (rir_reg% hty 58) = .value 1#32 := by chain_reads
    rw [r0, r1]
    refine hK10 _ S3 ?_ ?_ ?_ h0 hI3
    · rw [← hA3]; rfl
    · refine (((hW1.mono (by decide) (by decide)).trans (hW2.mono (by decide) (by decide))).trans
        (hW3.mono (by decide) (by decide))).trans ?_
      writes_chain
    · have hW' : Writes E3 E3[rir_dst% hty 769 := PoisonOr.value 0#32, rir_dst% hty 770 := PoisonOr.value 1#32] 769 771 := by
        writes_chain
      clear hW'
      refine ⟨?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩
      all_goals first
        | (simp (disch := decide) only [read_write_same, Env.read_write_ne']; done)
        | (simp (disch := decide) only [Env.read_write_ne']; chain_reads)

/-- A run from `p` whose next `k` instructions take `E` to `E'`: the run from `p + k` in `E'`. -/
theorem runBodyFrom_of_take {blk : BasicBlock Γ tRets bp} :
    ∀ (k p : Nat) (E E' : ⟪Γ⟫) (S S' : GlobalState), p + k ≤ blk.body.length →
    List.foldlM Instr.run E ((blk.body.drop p).take k) S = PoisonOr.value (E', S') →
    blk.runBodyFrom E p S = blk.runBodyFrom E' (p + k) S'
  | 0, p, E, E', S, S', _, h => by
    cases h
    rfl
  | k + 1, p, E, E', S, S', hk, h => by
    have hp : p < blk.body.length := by omega
    rw [List.drop_eq_getElem_cons hp, List.take_succ_cons, List.foldlM_cons] at h
    change StateT.bind (Instr.run E blk.body[p]) _ S = _ at h
    simp only [StateT.bind] at h
    cases hr : Instr.run E blk.body[p] S with
    | poison => rw [hr] at h; cases h
    | value r =>
      rw [hr] at h
      rw [BasicBlock.runBodyFrom_step_of_run hp hr, show p + (k + 1) = p + 1 + k by omega]
      exact runBodyFrom_of_take k (p + 1) r.1 E' r.2 S' (by omega) h

/-- The env after `^bb0`'s first `139` instructions, its constants. -/
def constsOf (E : ⟪Γ⟫) : ⟪Γ⟫ :=
  match List.foldlM Instr.run E ((bb0.body.drop 0).take 139) ⟨⟨0⟩, default⟩ with
  | .value (e, _) => e
  | _ => E

set_option maxRecDepth 100000 in
/-- `^bb0`'s constants: running on from `0` gives what it does from `139` in an env with the entry's
constants. -/
theorem lead_run {β : Type} {E : ⟪Γ⟫} {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β}
    {K : PoisonOr β}
    (hK : ∀ E' : ⟪Γ⟫, E'.args = E.args → (∀ B, writeSlots E' B 0 slotDsts = entryEnv E' B) →
      (bb0.runBodyFrom E' 139 S >>= g) = K) :
    (bb0.runBodyFrom E 0 S >>= g) = K := by
  rw [runBodyFrom_of_take 139 0 E (constsOf E) S S bb0_take rir_rfl%]
  refine hK _ rir_rfl% fun B => ?_
  unfold entryEnv
  refine congrArg (writeSlots · B 0 slotDsts) ?_
  symm
  exact Env.write_eq_of (Env.write_eq_of (Env.write_eq_of (Env.write_eq_of (Env.write_eq_of (Env.write_eq_of (Env.write_eq_of (Env.write_eq_of (Env.write_eq_of (Env.write_eq_of (Env.write_eq_of (Env.write_eq_of (Env.write_eq_of (Env.write_eq_of (Env.write_eq_of (Env.write_eq_of (Env.write_eq_of (Env.write_eq_of (Env.write_eq_of (Env.write_eq_of (Env.write_eq_of (Env.write_eq_of (Env.write_eq_of (Env.write_eq_of (Env.write_eq_of (Env.write_eq_of (Env.write_eq_of (Env.write_eq_of (Env.write_eq_of (Env.write_eq_of (Env.write_eq_of (Env.write_eq_of (rfl) rir_rfl%) rir_rfl%) rir_rfl%) rir_rfl%) rir_rfl%) rir_rfl%) rir_rfl%) rir_rfl%) rir_rfl%) rir_rfl%) rir_rfl%) rir_rfl%) rir_rfl%) rir_rfl%) rir_rfl%) rir_rfl%) rir_rfl%) rir_rfl%) rir_rfl%) rir_rfl%) rir_rfl%) rir_rfl%) rir_rfl%) rir_rfl%) rir_rfl%) rir_rfl%) rir_rfl%) rir_rfl%) rir_rfl%) rir_rfl%) rir_rfl%) rir_rfl%

set_option maxRecDepth 100000 in
set_option maxHeartbeats 8000000 in
theorem call_eq (a ea b eb : Pointer) (s : GlobalState) (hwf : s.WF)
    (ha : s.mem.Quad5Room a) (hb : s.mem.Quad5Room b) (hsa : Fits s.mem ea 256)
    (hsb : Fits s.mem eb 256) (hsa_off : ea.offset.toNat + 32 < 2 ^ 64)
    (hsb_off : eb.offset.toNat + 32 < 2 ^ 64) :
    fd_r52x5_ge_decode2.call (argsOf a ea b eb) s =
      let R := spec (s.mem.readAt ea 256) (s.mem.readAt eb 256)
      .value
        (.cons (.value R.1) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + blocks R⟩, mem := storeOut s.mem a b R }) := by
  generalize hR : spec (s.mem.readAt ea 256) (s.mem.readAt eb 256) = R
  func_init
  block_init
  refine lead_run fun E hA hEnt' => ?_
  have hArgs : E.args = (argsOf a ea b eb).get := hA.trans hEargs
  clear hA hEargs hE
  have hS0 : S.alloc.nextFreeBlock = S₀.alloc.nextFreeBlock := by rw [hS]
  have hsA : S.mem.readAt ea 256 = S₀.mem.readAt ea 256 := by rw [hS]
  have hsB : S.mem.readAt eb 256 = S₀.mem.readAt eb 256 := by rw [hS]
  rw [hsA, hsB] at hR
  have hI : Inv S₀ S.mem 0 (allocas S slotSizes) :=
    ⟨WF_allocas _ _ hwf, frame_allocas hwf hS0, by
      rw [eraseFrom_allocas _ _ (by omega), ← hS0, hwf.eraseFrom], by
      rw [alloc_allocas, hS0, show slotSizes.length = 246 by simp [slotSizes]]⟩
  rw [bb0_allocas hS0]
  obtain ⟨Eent, hEnt⟩ : ∃ X, X = writeSlots E S₀ 0 slotDsts := ⟨_, rfl⟩
  rw [← hEnt]
  have hArgsE : Eent.args = (argsOf a ea b eb).get := by
    rw [hEnt, writeSlots_args]
    exact hArgs
  replace hEnt : Eent = entryEnv E S₀ := hEnt.trans (hEnt' S₀)
  clear hEnt'
  have hsa_lt : ea.id.id < S₀.alloc.nextFreeBlock := hwf₀.lt hsa₀.mem
  have hsb_lt : eb.id.id < S₀.alloc.nextFreeBlock := hwf₀.lt hsb₀.mem
  have hy : Eent.read (rir_reg% hty 66) = yUndef := by
    rw [← yUndef_eq]; chain_reads
  refine ys_run (S₀.mem.readAt ea 256) (S₀.mem.readAt eb 256) hArgsE (by chain_reads) hI
    (fits_allocas_of slotSizes S hwf hsa) (fits_allocas_of slotSizes S hwf hsb)
    ((hI.readAt hsa_lt).trans hsA) ((hI.readAt hsb_lt).trans hsB) hsa_off hsb_off hsa_lt hsb_lt
    fun E1 S1 hA1 hW1 hR1 hI1 => ?_
  refine bb0g0_run _ hA1 (by chain_reads) hI1 fun E2 S2 hA2 hW2 hR2 hI2 => ?_
  refine bb0g1_run _ hA2 (by chain_reads) hI2 fun E3 S3 hA3 hW3 hR3 hI3 => ?_
  refine bb0g2_run _ _ hA3 (by chain_reads) hI3 fun E4 S4 hA4 hW4 hR4 hI4 => ?_
  refine bb0g3_run _ _ _ hA4 (by chain_reads) hI4 fun E5 S5 hA5 hW5 hR5 hI5 => ?_
  refine bb0g4_run _ hA5 (by chain_reads) hI5 fun E6 S6 hA6 hW6 hR6 hI6 => ?_
  refine bb0g5_run _ _ hA6 (by chain_reads) hI6 fun E7 S7 hA7 hW7 hR7 hI7 => ?_
  refine bb0g6_run _ hA7 (by chain_reads) hI7 fun E8 S8 hA8 hW8 hR8 hI8 => ?_
  refine bb0g7_run _ hA8 (by chain_reads) hI8 fun E9 S9 hA9 hW9 hR9 hI9 => ?_
  refine bb0g8_run _ _ hA9 (by chain_reads) hI9 fun E10 S10 hA10 hW10 hR10 hI10 => ?_
  have h1 : E10.read (rir_reg% hty 58) = .value 1#32 := by chain_reads
  rw [BasicBlock.runBodyFrom_done bb0_length]
  simp only [EffectM.pure_eq, PoisonOr.value_bind, reduceBlockExit, Exit.run]
  dsimp only [Jump.run, Fin.isValue, Regs.read_nil, EffectM.pure_eq, PoisonOr.value_bind,
    Regs.read_cons, reduceWriteManyDsts, Env.writeMany_nil, Env.writeMany_cons]
  rw [Func.continue_next]
  simp only [hR10, h1]
  refine loop2 S₀ S.mem 0 _ _ 18 1 S10 E10 _ rfl hI10 (by unfold pre2; chain_reads)
    fun El2 Sl2 hWl2 hOl2 hIl2 => ?_
  refine bb1_run _ _ _ (hWl2.1.trans hA10) (by unfold out2 at hOl2; chain_reads) hIl2
    fun Eb1 Sb1 hAb1 hWb1 hRb1 hIb1 => ?_
  refine loop4 S₀ S.mem 0 _ _ 48 1 Sb1 Eb1 _ rfl hIb1 (by unfold pre4; chain_reads)
    fun El4 Sl4 hWl4 hOl4 hIl4 => ?_
  refine bb3_run _ _ (hWl4.1.trans hAb1) (by unfold out4 at hOl4; chain_reads) hIl4
    fun Eb3 Sb3 hAb3 hWb3 hRb3 hIb3 => ?_
  refine loop6 S₀ S.mem 0 _ _ 98 1 Sb3 Eb3 _ rfl hIb3 (by unfold pre6; chain_reads)
    fun El6 Sl6 hWl6 hOl6 hIl6 => ?_
  refine bb5_run _ _ (hWl6.1.trans hAb3) (by unfold out6 at hOl6; chain_reads) hIl6
    fun Eb5 Sb5 hAb5 hWb5 hRb5 hIb5 => ?_
  refine loop8 S₀ S.mem 0 _ _ 48 1 Sb5 Eb5 _ rfl hIb5 (by unfold pre8; chain_reads)
    fun El8 Sl8 hWl8 hOl8 hIl8 => ?_
  have hP : Ptrs S₀ a ea b eb (S₀.mem.readAt ea 256) (S₀.mem.readAt eb 256) S.mem :=
    ⟨hsa, hsb, by rw [hS], by rw [hS], hsa_off, hsb_off, hsa_lt, hsb_lt, ha, hb,
      hwf₀.lt ha₀.mem, hwf₀.lt hb₀.mem⟩
  have hDone0 : Done S₀ S.mem 0 a b R
      (fun (p : Vals [.bv 32] × GlobalState) =>
        (PoisonOr.value (p.1, GlobalState.mk p.2.alloc (p.2.mem.eraseFrom S₀.alloc.nextFreeBlock)) :
          PoisonOr (Vals [.bv 32] × GlobalState)))
      (PoisonOr.value (Vals.cons (PoisonOr.value R.1) Vals.nil,
        GlobalState.mk (AllocState.mk (S₀.alloc.nextFreeBlock + blocks R)) (storeOut S₀.mem a b R))) := by
    intro S' halloc herase
    have hm : (endY S'.mem S₀).eraseFrom S₀.alloc.nextFreeBlock = storeOut S₀.mem a b R := by
      simp only [endY]
      rw [eraseFrom_lifetimeEnd_slot, eraseFrom_lifetimeEnd_slot, herase, hS]
    show PoisonOr.value _ = PoisonOr.value _
    rw [hm]
    obtain ⟨⟨n⟩, m'⟩ := S'
    simp only at halloc
    subst halloc
    have e := blocks_eq S₀.alloc.nextFreeBlock R
    exact congrArg (fun n => (PoisonOr.value ((Vals.cons (t := .bv 32) (PoisonOr.value R.1) Vals.nil :
      Vals [.bv 32]), GlobalState.mk (AllocState.mk n) (storeOut S₀.mem a b R)) :
        PoisonOr (Vals [.bv 32] × GlobalState))) e
  have hT : tail (S₀.mem.readAt ea 256) (S₀.mem.readAt eb 256) (pre (S₀.mem.readAt ea 256) (S₀.mem.readAt eb 256)).x (pre (S₀.mem.readAt ea 256) (S₀.mem.readAt eb 256)).y (pre (S₀.mem.readAt ea 256) (S₀.mem.readAt eb 256)).vx2 (pre (S₀.mem.readAt ea 256) (S₀.mem.readAt eb 256)).u (pre (S₀.mem.readAt ea 256) (S₀.mem.readAt eb 256)).nu = R :=
    (spec_eq_tail _ _).symm.trans hR
  have hDone : Done S₀ S.mem 0 a b
      (tail (S₀.mem.readAt ea 256) (S₀.mem.readAt eb 256) (pre (S₀.mem.readAt ea 256) (S₀.mem.readAt eb 256)).x
        (pre (S₀.mem.readAt ea 256) (S₀.mem.readAt eb 256)).y (pre (S₀.mem.readAt ea 256) (S₀.mem.readAt eb 256)).vx2
        (pre (S₀.mem.readAt ea 256) (S₀.mem.readAt eb 256)).u (pre (S₀.mem.readAt ea 256) (S₀.mem.readAt eb 256)).nu)
      (fun (p : Vals [.bv 32] × GlobalState) =>
        (PoisonOr.value (p.1, GlobalState.mk p.2.alloc (p.2.mem.eraseFrom S₀.alloc.nextFreeBlock)) :
          PoisonOr (Vals [.bv 32] × GlobalState)))
      (PoisonOr.value (Vals.cons (PoisonOr.value R.1) Vals.nil,
        GlobalState.mk (AllocState.mk (S₀.alloc.nextFreeBlock + blocks R)) (storeOut S₀.mem a b R))) := by
    intro S' h1 h2
    revert h1 h2
    rw [hT]
    exact hDone0 S'
  have hpre : El8 ⊨ [rir_reg% hty 139 := PoisonOr.value (S₀.slot 0),
      rir_reg% hty 140 := PoisonOr.value (S₀.slot 1),
      rir_reg% hty 321 := PoisonOr.value (S₀.slot 182),
      rir_reg% hty 322 := PoisonOr.value (S₀.slot 183),
      rir_reg% hty 323 := PoisonOr.value (S₀.slot 184),
      rir_reg% hty 324 := PoisonOr.value (S₀.slot 185),
      rir_reg% hty 325 := PoisonOr.value (S₀.slot 186),
      rir_reg% hty 326 := PoisonOr.value (S₀.slot 187),
      rir_reg% hty 327 := PoisonOr.value (S₀.slot 188),
      rir_reg% hty 328 := PoisonOr.value (S₀.slot 189),
      rir_reg% hty 329 := PoisonOr.value (S₀.slot 190),
      rir_reg% hty 330 := PoisonOr.value (S₀.slot 191),
      rir_reg% hty 331 := PoisonOr.value (S₀.slot 192),
      rir_reg% hty 332 := PoisonOr.value (S₀.slot 193),
      rir_reg% hty 333 := PoisonOr.value (S₀.slot 194),
      rir_reg% hty 334 := PoisonOr.value (S₀.slot 195),
      rir_reg% hty 335 := PoisonOr.value (S₀.slot 196),
      rir_reg% hty 336 := PoisonOr.value (S₀.slot 197),
      rir_reg% hty 337 := PoisonOr.value (S₀.slot 198),
      rir_reg% hty 338 := PoisonOr.value (S₀.slot 199),
      rir_reg% hty 339 := PoisonOr.value (S₀.slot 200),
      rir_reg% hty 340 := PoisonOr.value (S₀.slot 201),
      rir_reg% hty 341 := PoisonOr.value (S₀.slot 202),
      rir_reg% hty 342 := PoisonOr.value (S₀.slot 203),
      rir_reg% hty 343 := PoisonOr.value (S₀.slot 204),
      rir_reg% hty 344 := PoisonOr.value (S₀.slot 205),
      rir_reg% hty 345 := PoisonOr.value (S₀.slot 206),
      rir_reg% hty 346 := PoisonOr.value (S₀.slot 207),
      rir_reg% hty 347 := PoisonOr.value (S₀.slot 208),
      rir_reg% hty 348 := PoisonOr.value (S₀.slot 209),
      rir_reg% hty 349 := PoisonOr.value (S₀.slot 210),
      rir_reg% hty 350 := PoisonOr.value (S₀.slot 211),
      rir_reg% hty 351 := PoisonOr.value (S₀.slot 212),
      rir_reg% hty 352 := PoisonOr.value (S₀.slot 213),
      rir_reg% hty 353 := PoisonOr.value (S₀.slot 214),
      rir_reg% hty 354 := PoisonOr.value (S₀.slot 215),
      rir_reg% hty 355 := PoisonOr.value (S₀.slot 216),
      rir_reg% hty 356 := PoisonOr.value (S₀.slot 217),
      rir_reg% hty 357 := PoisonOr.value (S₀.slot 218),
      rir_reg% hty 358 := PoisonOr.value (S₀.slot 219),
      rir_reg% hty 359 := PoisonOr.value (S₀.slot 220),
      rir_reg% hty 360 := PoisonOr.value (S₀.slot 221),
      rir_reg% hty 361 := PoisonOr.value (S₀.slot 222),
      rir_reg% hty 362 := PoisonOr.value (S₀.slot 223),
      rir_reg% hty 363 := PoisonOr.value (S₀.slot 224),
      rir_reg% hty 364 := PoisonOr.value (S₀.slot 225),
      rir_reg% hty 365 := PoisonOr.value (S₀.slot 226),
      rir_reg% hty 366 := PoisonOr.value (S₀.slot 227),
      rir_reg% hty 367 := PoisonOr.value (S₀.slot 228),
      rir_reg% hty 368 := PoisonOr.value (S₀.slot 229),
      rir_reg% hty 369 := PoisonOr.value (S₀.slot 230),
      rir_reg% hty 370 := PoisonOr.value (S₀.slot 231),
      rir_reg% hty 371 := PoisonOr.value (S₀.slot 232),
      rir_reg% hty 372 := PoisonOr.value (S₀.slot 233),
      rir_reg% hty 373 := PoisonOr.value (S₀.slot 234),
      rir_reg% hty 374 := PoisonOr.value (S₀.slot 235),
      rir_reg% hty 375 := PoisonOr.value (S₀.slot 236),
      rir_reg% hty 376 := PoisonOr.value (S₀.slot 237),
      rir_reg% hty 377 := PoisonOr.value (S₀.slot 238),
      rir_reg% hty 378 := PoisonOr.value (S₀.slot 239),
      rir_reg% hty 379 := PoisonOr.value (S₀.slot 240),
      rir_reg% hty 380 := PoisonOr.value (S₀.slot 241),
      rir_reg% hty 381 := PoisonOr.value (S₀.slot 242),
      rir_reg% hty 382 := PoisonOr.value (S₀.slot 243),
      rir_reg% hty 383 := PoisonOr.value (S₀.slot 244),
      rir_reg% hty 384 := PoisonOr.value (S₀.slot 245),
      rir_reg% hty 62 := PoisonOr.value (0#32),
      rir_reg% hty 58 := PoisonOr.value (1#32),
      rir_reg% hty 57 := PoisonOr.value (2#32),
      rir_reg% hty 56 := PoisonOr.value (3#32),
      rir_reg% hty 44 := PoisonOr.value (4294967295#32),
      rir_reg% hty 43 := Ty.wrap (t := .vec 4 64) (Vector.replicate 4 1718705420411056#64 : Wl),
      rir_reg% hty 42 := Ty.wrap (t := .vec 4 64) (Vector.replicate 4 234908883556509#64 : Wl),
      rir_reg% hty 41 := Ty.wrap (t := .vec 4 64) (Vector.replicate 4 2233514472574048#64 : Wl),
      rir_reg% hty 40 := Ty.wrap (t := .vec 4 64) (Vector.replicate 4 2117202627021982#64 : Wl),
      rir_reg% hty 39 := Ty.wrap (t := .vec 4 64) (Vector.replicate 4 765476049583133#64 : Wl),
      rir_reg% hty 74 := m8Undef,
      rir_reg% hty 59 := PoisonOr.value (0#64),
      rir_reg% hty 55 := PoisonOr.value (1#64),
      rir_reg% hty 32 := PoisonOr.value (2#64),
      rir_reg% hty 31 := PoisonOr.value (3#64),
      rir_reg% hty 30 := Vector.replicate 2 PoisonOr.poison,
      rir_reg% hty 29 := Ty.wrap (t := .vec 2 32) (Vector.replicate 2 1#32),
      rir_reg% hty 28 := Vector.replicate 2 PoisonOr.poison,
      rir_reg% hty 27 := Ty.wrap (t := .vec 2 8) (Vector.replicate 2 7#8),
      rir_reg% hty 106 := mask1Bytes,
      rir_reg% hty 138 := mask0Bytes] := by
    have w0 : Writes Eent E1 385 935 := hW1.mono
    have w1 : Writes Eent E2 385 935 := w0.trans hW2.mono
    have w2 : Writes Eent E3 385 935 := w1.trans hW3.mono
    have w3 : Writes Eent E4 385 935 := w2.trans hW4.mono
    have w4 : Writes Eent E5 385 935 := w3.trans hW5.mono
    have w5 : Writes Eent E6 385 935 := w4.trans hW6.mono
    have w6 : Writes Eent E7 385 935 := w5.trans hW7.mono
    have w7 : Writes Eent E8 385 935 := w6.trans hW8.mono
    have w8 : Writes Eent E9 385 935 := w7.trans hW9.mono
    have w9 : Writes Eent E10 385 935 := w8.trans hW10.mono
    have w10 : Writes Eent El2 385 935 := w9.trans hWl2.mono
    have w11 : Writes Eent Eb1 385 935 := w10.trans hWb1.mono
    have w12 : Writes Eent El4 385 935 := w11.trans hWl4.mono
    have w13 : Writes Eent Eb3 385 935 := w12.trans hWb3.mono
    have w14 : Writes Eent El6 385 935 := w13.trans hWl6.mono
    have w15 : Writes Eent Eb5 385 935 := w14.trans hWb5.mono
    have w16 : Writes Eent El8 385 935 := w15.trans hWl8.mono
    clear hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hWl2 hWb1 hWl4 hWb3 hWl6 hWb5 hWl8 w0 w1 w2 w3 w4 w5 w6 w7 w8 w9 w10 w11 w12 w13 w14 w15
    chain_reads
  refine bb7_run _ _ _ _ _ _ (hWl8.1.trans hAb5) (by unfold out8 at hOl8; chain_reads) hIl8 ?_ ?_
  · intro E9 S9 hA9 hW9 hR9 h0 hP9 hI9
    replace h0 : fd_r52x5_limbs_eq.spec (fd_r52x5_quad_lane_canon.spec (pre (S₀.mem.readAt ea 256) (S₀.mem.readAt eb 256)).vx2 0)
        (fd_r52x5_quad_lane_canon.spec (pre (S₀.mem.readAt ea 256) (S₀.mem.readAt eb 256)).u 0) = 0 := h0
    replace hP9 : S9.WF ∧ S9.mem.readLimbs (S₀.slot 227) = fd_r52x5_quad_lane_canon.spec (pre (S₀.mem.readAt ea 256) (S₀.mem.readAt eb 256)).vx2 0 ∧
        S9.mem.readLimbs (S₀.slot 229) = fd_r52x5_quad_lane_canon.spec (pre (S₀.mem.readAt ea 256) (S₀.mem.readAt eb 256)).nu 0 ∧
        S9.mem.LimbsFit (S₀.slot 227) ∧ S9.mem.LimbsFit (S₀.slot 229) := hP9
    refine bb9_run _ _ (by chain_reads) hP9 fun E9' hA9' hW9' hR9' => ?_
    have hc0 : laneCheck (pre (S₀.mem.readAt ea 256) (S₀.mem.readAt eb 256)).vx2 (pre (S₀.mem.readAt ea 256) (S₀.mem.readAt eb 256)).u (pre (S₀.mem.readAt ea 256) (S₀.mem.readAt eb 256)).nu 0 =
        (fd_r52x5_limbs_eq.spec (fd_r52x5_quad_lane_canon.spec (pre (S₀.mem.readAt ea 256) (S₀.mem.readAt eb 256)).vx2 0)
          (fd_r52x5_quad_lane_canon.spec (pre (S₀.mem.readAt ea 256) (S₀.mem.readAt eb 256)).nu 0),
         fd_r52x5_limbs_eq.spec (fd_r52x5_quad_lane_canon.spec (pre (S₀.mem.readAt ea 256) (S₀.mem.readAt eb 256)).vx2 0)
          (fd_r52x5_quad_lane_canon.spec (pre (S₀.mem.readAt ea 256) (S₀.mem.readAt eb 256)).nu 0)) := by
      simp only [laneCheck, h0, ↓reduceIte]
    refine from10 (sA := S₀.mem.readAt ea 256) (sB := S₀.mem.readAt eb 256) (pre (S₀.mem.readAt ea 256) (S₀.mem.readAt eb 256)).x (pre (S₀.mem.readAt ea 256) (S₀.mem.readAt eb 256)).y (pre (S₀.mem.readAt ea 256) (S₀.mem.readAt eb 256)).vx2
      (pre (S₀.mem.readAt ea 256) (S₀.mem.readAt eb 256)).u (pre (S₀.mem.readAt ea 256) (S₀.mem.readAt eb 256)).nu ((hA9'.trans hA9)) ?_ hI9 hP ?_
    · rw [hc0]
      chain_reads
    · exact hDone
  · intro E10 S10 hA10 hW10 hR10 h0 hI10
    replace h0 : fd_r52x5_limbs_eq.spec (fd_r52x5_quad_lane_canon.spec (pre (S₀.mem.readAt ea 256) (S₀.mem.readAt eb 256)).vx2 0)
        (fd_r52x5_quad_lane_canon.spec (pre (S₀.mem.readAt ea 256) (S₀.mem.readAt eb 256)).u 0) ≠ 0 := h0
    have hc0 : laneCheck (pre (S₀.mem.readAt ea 256) (S₀.mem.readAt eb 256)).vx2 (pre (S₀.mem.readAt ea 256) (S₀.mem.readAt eb 256)).u (pre (S₀.mem.readAt ea 256) (S₀.mem.readAt eb 256)).nu 0 = (1, 0) := by
      simp only [laneCheck, h0, ↓reduceIte]
    refine from10 (sA := S₀.mem.readAt ea 256) (sB := S₀.mem.readAt eb 256) (pre (S₀.mem.readAt ea 256) (S₀.mem.readAt eb 256)).x (pre (S₀.mem.readAt ea 256) (S₀.mem.readAt eb 256)).y (pre (S₀.mem.readAt ea 256) (S₀.mem.readAt eb 256)).vx2
      (pre (S₀.mem.readAt ea 256) (S₀.mem.readAt eb 256)).u (pre (S₀.mem.readAt ea 256) (S₀.mem.readAt eb 256)).nu hA10 ?_ hI10 hP ?_
    · rw [hc0]
      chain_reads
    · exact hDone

end fd_r52x5_ge_decode2

end

end MLIR.Firedancer.Crc.Verify
