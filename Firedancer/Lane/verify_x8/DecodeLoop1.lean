module

public import Firedancer.Lane.verify_x8.DecodeRuns
public import Firedancer.Lane.Common.Tactics

/-! `^bb40`, an iteration of `fd_ed25519_lane_decode2`'s first loop. -/

namespace MLIR.Firedancer.Lane.VerifyX8.Decode

open Firedancer.Avx512 Firedancer.Ref
open _root_.Firedancer.Lane.Mlir (verify_x8)
open _root_.Firedancer.Lane.Mlir.verify_x8 (Γ hty)

attribute [-mlir_operation] zipWith_eq_ofFn Operation.vpmadd52l Operation.vpmadd52h

attribute [local mlir_operation] vpmadd52l_wwl vpmadd52h_wwl zipWith_add_wwl zipWith_sub_wwl
  zipWith_and_wwl zipWith_mul_wwl zipWith_shl_wwl zipWith_lshr_wwl

public section

variable {β : Type} {g : Vals [] × GlobalState → PoisonOr β}

-- 87 steps in one declaration
set_option maxHeartbeats 1000000 in
/-- `^bb40` up to the sign word: the encodings' qwords at bytes 0, 6, 12, 19, 24 loaded, their sign
bits stored at `sp`. -/
theorem bb40_A1 {S : GlobalState} {E : ⟪Γ⟫} {G : ⟪Γ⟫ × GlobalState → PoisonOr β}
    {K : PoisonOr β} (sp : Pointer) (buf : Fin 8 → Pointer) (X : Fin 8 → BitVec 256)
    (hC :
      E ⊨ [%66 := PoisonOr.value 0#64, %68 := PoisonOr.value 4#64, %72 := PoisonOr.value 3#64,
        %76 := PoisonOr.value 5#64, %78 := PoisonOr.value 6#64, %80 := PoisonOr.value 7#64,
        %87 := Vector.replicate 8 PoisonOr.poison, %88 := PoisonOr.value 1#64,
        %89 := PoisonOr.value 2#64,
        %90 := Ty.wrap #v[62#64, 61#64, 60#64, 59#64, 58#64, 57#64, 56#64, 63#64],
        %91 := Ty.wrap #v[2#64, 4#64, 8#64, 16#64, 32#64, 64#64, 128#64, 4294967295#64]])
    (hR :
      E ⊨ [rir_reg% hty 458 := PoisonOr.value sp, rir_reg% hty 470 := PoisonOr.value (buf 0),
        rir_reg% hty 469 := PoisonOr.value (buf 1), rir_reg% hty 468 := PoisonOr.value (buf 2),
        rir_reg% hty 467 := PoisonOr.value (buf 3), rir_reg% hty 466 := PoisonOr.value (buf 4),
        rir_reg% hty 465 := PoisonOr.value (buf 5), rir_reg% hty 464 := PoisonOr.value (buf 6),
        rir_reg% hty 463 := PoisonOr.value (buf 7)])
    (hf0 : Fits S.mem (buf 0) 256) (hr0 : S.mem.readAt (buf 0) 256 = X 0)
    (ho0 : ¬(buf 0).offset.uaddOverflow 32#64)
    (hf1 : Fits S.mem (buf 1) 256) (hr1 : S.mem.readAt (buf 1) 256 = X 1)
    (ho1 : ¬(buf 1).offset.uaddOverflow 32#64)
    (hf2 : Fits S.mem (buf 2) 256) (hr2 : S.mem.readAt (buf 2) 256 = X 2)
    (ho2 : ¬(buf 2).offset.uaddOverflow 32#64)
    (hf3 : Fits S.mem (buf 3) 256) (hr3 : S.mem.readAt (buf 3) 256 = X 3)
    (ho3 : ¬(buf 3).offset.uaddOverflow 32#64)
    (hf4 : Fits S.mem (buf 4) 256) (hr4 : S.mem.readAt (buf 4) 256 = X 4)
    (ho4 : ¬(buf 4).offset.uaddOverflow 32#64)
    (hf5 : Fits S.mem (buf 5) 256) (hr5 : S.mem.readAt (buf 5) 256 = X 5)
    (ho5 : ¬(buf 5).offset.uaddOverflow 32#64)
    (hf6 : Fits S.mem (buf 6) 256) (hr6 : S.mem.readAt (buf 6) 256 = X 6)
    (ho6 : ¬(buf 6).offset.uaddOverflow 32#64)
    (hf7 : Fits S.mem (buf 7) 256) (hr7 : S.mem.readAt (buf 7) 256 = X 7)
    (ho7 : ¬(buf 7).offset.uaddOverflow 32#64)
    (hsp : Fits S.mem sp 32) (hspr : S.mem.readAt sp 32 = 0) (hspw : Writable S.mem sp)
    (hK :
      ∀ (v472 : ⟦.bv 32⟧) (v474 : ⟦.ptr⟧) (v476 : ⟦.ptr⟧) (v478 : ⟦.ptr⟧) (v480 : ⟦.ptr⟧)
        (v483 : ⟦.ptr⟧) (v485 : ⟦.ptr⟧) (v487 : ⟦.ptr⟧) (v489 : ⟦.ptr⟧) (v492 : ⟦.ptr⟧)
        (v494 : ⟦.ptr⟧) (v496 : ⟦.ptr⟧) (v498 : ⟦.ptr⟧) (v501 : ⟦.ptr⟧) (v503 : ⟦.ptr⟧)
        (v505 : ⟦.ptr⟧) (v507 : ⟦.ptr⟧) (v510 : ⟦.ptr⟧) (v512 : ⟦.ptr⟧) (v514 : ⟦.ptr⟧)
        (v516 : ⟦.ptr⟧) (v519 : ⟦.ptr⟧) (v521 : ⟦.ptr⟧) (v523 : ⟦.ptr⟧) (v525 : ⟦.ptr⟧)
        (v528 : ⟦.ptr⟧) (v530 : ⟦.ptr⟧) (v532 : ⟦.ptr⟧) (v534 : ⟦.ptr⟧) (v537 : ⟦.ptr⟧)
        (v539 : ⟦.ptr⟧) (v541 : ⟦.ptr⟧) (v543 : ⟦.ptr⟧) (v545 : ⟦.vec 8 64⟧) (v546 : ⟦.vec 8 64⟧)
        (v547 : ⟦.vec 8 64⟧) (v548 : ⟦.vec 8 64⟧) (v549 : ⟦.vec 8 64⟧) (v550 : ⟦.vec 8 64⟧)
        (v551 : ⟦.vec 8 64⟧) (v552 : ⟦.vec 8 64⟧) (v553 : ⟦.vec 8 64⟧) (v554 : ⟦.vec 8 64⟧)
        (v555 : ⟦.bv 64⟧) (v556 : ⟦.bv 32⟧) (v557 : ⟦.bv 32⟧),
        (verify_x8.bb40.runBodyFrom E[rir_dst% hty 472 := v472,
          rir_dst% hty 473 := PoisonOr.value ((X 0).setWidth 64), rir_dst% hty 474 := v474,
          rir_dst% hty 475 := PoisonOr.value ((X 0).extractLsb' 48 64), rir_dst% hty 476 := v476,
          rir_dst% hty 477 := PoisonOr.value ((X 0).extractLsb' 96 64), rir_dst% hty 478 := v478,
          rir_dst% hty 479 := PoisonOr.value ((X 0).extractLsb' 152 64), rir_dst% hty 480 := v480,
          rir_dst% hty 481 := PoisonOr.value ((X 0).extractLsb' 192 64),
          rir_dst% hty 482 := PoisonOr.value ((X 1).setWidth 64), rir_dst% hty 483 := v483,
          rir_dst% hty 484 := PoisonOr.value ((X 1).extractLsb' 48 64), rir_dst% hty 485 := v485,
          rir_dst% hty 486 := PoisonOr.value ((X 1).extractLsb' 96 64), rir_dst% hty 487 := v487,
          rir_dst% hty 488 := PoisonOr.value ((X 1).extractLsb' 152 64), rir_dst% hty 489 := v489,
          rir_dst% hty 490 := PoisonOr.value ((X 1).extractLsb' 192 64),
          rir_dst% hty 491 := PoisonOr.value ((X 2).setWidth 64), rir_dst% hty 492 := v492,
          rir_dst% hty 493 := PoisonOr.value ((X 2).extractLsb' 48 64), rir_dst% hty 494 := v494,
          rir_dst% hty 495 := PoisonOr.value ((X 2).extractLsb' 96 64),
          rir_dst% hty 496 := v496][rir_dst% hty 497 := PoisonOr.value ((X 2).extractLsb' 152 64),
          rir_dst% hty 498 := v498, rir_dst% hty 499 := PoisonOr.value ((X 2).extractLsb' 192 64),
          rir_dst% hty 500 := PoisonOr.value ((X 3).setWidth 64), rir_dst% hty 501 := v501,
          rir_dst% hty 502 := PoisonOr.value ((X 3).extractLsb' 48 64), rir_dst% hty 503 := v503,
          rir_dst% hty 504 := PoisonOr.value ((X 3).extractLsb' 96 64), rir_dst% hty 505 := v505,
          rir_dst% hty 506 := PoisonOr.value ((X 3).extractLsb' 152 64), rir_dst% hty 507 := v507,
          rir_dst% hty 508 := PoisonOr.value ((X 3).extractLsb' 192 64),
          rir_dst% hty 509 := PoisonOr.value ((X 4).setWidth 64), rir_dst% hty 510 := v510,
          rir_dst% hty 511 := PoisonOr.value ((X 4).extractLsb' 48 64), rir_dst% hty 512 := v512,
          rir_dst% hty 513 := PoisonOr.value ((X 4).extractLsb' 96 64), rir_dst% hty 514 := v514,
          rir_dst% hty 515 := PoisonOr.value ((X 4).extractLsb' 152 64), rir_dst% hty 516 := v516,
          rir_dst% hty 517 := PoisonOr.value ((X 4).extractLsb' 192 64),
          rir_dst% hty 518 := PoisonOr.value ((X 5).setWidth 64), rir_dst% hty 519 := v519,
          rir_dst% hty 520 := PoisonOr.value ((X 5).extractLsb' 48 64),
          rir_dst% hty 521 := v521][rir_dst% hty 522 := PoisonOr.value ((X 5).extractLsb' 96 64),
          rir_dst% hty 523 := v523, rir_dst% hty 524 := PoisonOr.value ((X 5).extractLsb' 152 64),
          rir_dst% hty 525 := v525, rir_dst% hty 526 := PoisonOr.value ((X 5).extractLsb' 192 64),
          rir_dst% hty 527 := PoisonOr.value ((X 6).setWidth 64), rir_dst% hty 528 := v528,
          rir_dst% hty 529 := PoisonOr.value ((X 6).extractLsb' 48 64), rir_dst% hty 530 := v530,
          rir_dst% hty 531 := PoisonOr.value ((X 6).extractLsb' 96 64), rir_dst% hty 532 := v532,
          rir_dst% hty 533 := PoisonOr.value ((X 6).extractLsb' 152 64), rir_dst% hty 534 := v534,
          rir_dst% hty 535 := PoisonOr.value ((X 6).extractLsb' 192 64),
          rir_dst% hty 536 := PoisonOr.value ((X 7).setWidth 64), rir_dst% hty 537 := v537,
          rir_dst% hty 538 := PoisonOr.value ((X 7).extractLsb' 48 64), rir_dst% hty 539 := v539,
          rir_dst% hty 540 := PoisonOr.value ((X 7).extractLsb' 96 64), rir_dst% hty 541 := v541,
          rir_dst% hty 542 := PoisonOr.value ((X 7).extractLsb' 152 64), rir_dst% hty 543 := v543,
          rir_dst% hty 544 := PoisonOr.value ((X 7).extractLsb' 192 64), rir_dst% hty 545 := v545,
          rir_dst% hty 546 := v546][rir_dst% hty 547 := v547, rir_dst% hty 548 := v548,
          rir_dst% hty 549 := v549, rir_dst% hty 550 := v550, rir_dst% hty 551 := v551,
          rir_dst% hty 552 := v552, rir_dst% hty 553 := v553, rir_dst% hty 554 := v554,
          rir_dst% hty 555 := v555, rir_dst% hty 556 := v556, rir_dst% hty 557 := v557] 87
          { S with mem := S.mem.storeAt sp (signs X) } >>= G) = K) :
    (verify_x8.bb40.runBodyFrom E 0 S >>= G) = K := by
  split_env hC hR
  iterate 2 step_load
  step_pure
  step_load
  step_pure
  step_load
  step_pure
  step_load
  step_pure
  iterate 2 step_load
  step_pure
  step_load
  step_pure
  step_load
  step_pure
  step_load
  step_pure
  iterate 2 step_load
  step_pure
  step_load
  step_pure
  step_load
  step_pure
  step_load
  step_pure
  iterate 2 step_load
  step_pure
  step_load
  step_pure
  step_load
  step_pure
  step_load
  step_pure
  iterate 2 step_load
  step_pure
  step_load
  step_pure
  step_load
  step_pure
  step_load
  step_pure
  iterate 2 step_load
  step_pure
  step_load
  step_pure
  step_load
  step_pure
  step_load
  step_pure
  iterate 2 step_load
  step_pure
  step_load
  step_pure
  step_load
  step_pure
  step_load
  step_pure
  iterate 2 step_load
  step_pure
  step_load
  step_pure
  step_load
  step_pure
  step_load
  step_pure
  step_load
  clear hf0 hf1 hf2 hf3 hf4 hf5 hf6 hf7 hr0 hr1 hr2 hr3 hr4 hr5 hr6 hr7 ho0 ho1 ho2 ho3 ho4 ho5 ho6
    ho7
  iterate 10 step_pure
  step_pure with sg
  obtain ⟨s, hs⟩ : ∃ s, s = signs X := ⟨_, rfl⟩
  folded hs
  have hsg' : sg = s.setWidth 64 := hsg.trans (hs ▸ sign_word X)
  have hext : s.signExtend 64 = s.setWidth 64 := hs ▸ signs_signExtend X
  step_pure [hsg', hext]
  step_pure
  clear hsg' hext hsg
  step_store
  subst_vars
  exact hK _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
      _

-- 69 steps in one declaration
set_option maxHeartbeats 1000000 in
/-- `^bb40` from the load of `r[n]` to the stores of `y`: the point at `P` zeroed and given `y`. -/
theorem bb40_A2 {S : GlobalState} {E : ⟪Γ⟫} {G : ⟪Γ⟫ × GlobalState → PoisonOr β}
    {K : PoisonOr β} (rp P : Pointer) (X : Fin 8 → BitVec 256)
    (hC :
      E ⊨ [%53 := PoisonOr.value 0#8, %54 := PoisonOr.value 256#64, %66 := PoisonOr.value 0#64,
        %68 := PoisonOr.value 4#64, %72 := PoisonOr.value 3#64, %76 := PoisonOr.value 5#64,
        %78 := PoisonOr.value 6#64, %80 := PoisonOr.value 7#64, %82 := PoisonOr.value 320#64,
        %87 := Vector.replicate 8 PoisonOr.poison, %88 := PoisonOr.value 1#64,
        %89 := PoisonOr.value 2#64, %94 := Ty.wrap (Vector.replicate 8 0#64),
        %95 := Ty.wrap (Vector.replicate 8 1#64),
        %96 := Ty.wrap (Vector.replicate 8 2251799813685247#64),
        %97 := Ty.wrap (Vector.replicate 8 3#64), %98 := Ty.wrap (Vector.replicate 8 6#64),
        %100 := Ty.wrap (Vector.replicate 8 12#64)])
    (hR :
      E ⊨ [rir_reg% hty 471 := PoisonOr.value rp,
        rir_reg% hty 473 := PoisonOr.value ((X 0).setWidth 64),
        rir_reg% hty 475 := PoisonOr.value ((X 0).extractLsb' 48 64),
        rir_reg% hty 477 := PoisonOr.value ((X 0).extractLsb' 96 64),
        rir_reg% hty 479 := PoisonOr.value ((X 0).extractLsb' 152 64),
        rir_reg% hty 481 := PoisonOr.value ((X 0).extractLsb' 192 64),
        rir_reg% hty 482 := PoisonOr.value ((X 1).setWidth 64),
        rir_reg% hty 484 := PoisonOr.value ((X 1).extractLsb' 48 64),
        rir_reg% hty 486 := PoisonOr.value ((X 1).extractLsb' 96 64),
        rir_reg% hty 488 := PoisonOr.value ((X 1).extractLsb' 152 64),
        rir_reg% hty 490 := PoisonOr.value ((X 1).extractLsb' 192 64),
        rir_reg% hty 491 := PoisonOr.value ((X 2).setWidth 64),
        rir_reg% hty 493 := PoisonOr.value ((X 2).extractLsb' 48 64),
        rir_reg% hty 495 := PoisonOr.value ((X 2).extractLsb' 96 64),
        rir_reg% hty 497 := PoisonOr.value ((X 2).extractLsb' 152 64),
        rir_reg% hty 499 := PoisonOr.value ((X 2).extractLsb' 192 64),
        rir_reg% hty 500 := PoisonOr.value ((X 3).setWidth 64),
        rir_reg% hty 502 := PoisonOr.value ((X 3).extractLsb' 48 64),
        rir_reg% hty 504 := PoisonOr.value ((X 3).extractLsb' 96 64),
        rir_reg% hty 506 := PoisonOr.value ((X 3).extractLsb' 152 64),
        rir_reg% hty 508 := PoisonOr.value ((X 3).extractLsb' 192 64),
        rir_reg% hty 509 := PoisonOr.value ((X 4).setWidth 64),
        rir_reg% hty 511 := PoisonOr.value ((X 4).extractLsb' 48 64),
        rir_reg% hty 513 := PoisonOr.value ((X 4).extractLsb' 96 64),
        rir_reg% hty 515 := PoisonOr.value ((X 4).extractLsb' 152 64),
        rir_reg% hty 517 := PoisonOr.value ((X 4).extractLsb' 192 64),
        rir_reg% hty 518 := PoisonOr.value ((X 5).setWidth 64),
        rir_reg% hty 520 := PoisonOr.value ((X 5).extractLsb' 48 64),
        rir_reg% hty 522 := PoisonOr.value ((X 5).extractLsb' 96 64),
        rir_reg% hty 524 := PoisonOr.value ((X 5).extractLsb' 152 64),
        rir_reg% hty 526 := PoisonOr.value ((X 5).extractLsb' 192 64),
        rir_reg% hty 527 := PoisonOr.value ((X 6).setWidth 64),
        rir_reg% hty 529 := PoisonOr.value ((X 6).extractLsb' 48 64),
        rir_reg% hty 531 := PoisonOr.value ((X 6).extractLsb' 96 64),
        rir_reg% hty 533 := PoisonOr.value ((X 6).extractLsb' 152 64),
        rir_reg% hty 535 := PoisonOr.value ((X 6).extractLsb' 192 64),
        rir_reg% hty 536 := PoisonOr.value ((X 7).setWidth 64),
        rir_reg% hty 538 := PoisonOr.value ((X 7).extractLsb' 48 64),
        rir_reg% hty 540 := PoisonOr.value ((X 7).extractLsb' 96 64),
        rir_reg% hty 542 := PoisonOr.value ((X 7).extractLsb' 152 64),
        rir_reg% hty 544 := PoisonOr.value ((X 7).extractLsb' 192 64)])
    (hrp : InBounds S.mem rp 64) (hrpr : S.mem.loadPtr rp = .value P)
    (hP : Room S.mem P 10240) (hPo : P.offset = 0)
    (hK :
      ∀ (v559 : ⟦.ptr⟧) (v560 : ⟦.ptr⟧) (v562 : ⟦.ptr⟧) (v563 : ⟦.ptr⟧) (v565 : ⟦.vec 8 64⟧)
        (v566 : ⟦.vec 8 64⟧) (v567 : ⟦.vec 8 64⟧) (v568 : ⟦.vec 8 64⟧) (v569 : ⟦.vec 8 64⟧)
        (v570 : ⟦.vec 8 64⟧) (v571 : ⟦.vec 8 64⟧) (v572 : ⟦.vec 8 64⟧) (v573 : ⟦.vec 8 64⟧)
        (v574 : ⟦.vec 8 64⟧) (v575 : ⟦.vec 8 64⟧) (v576 : ⟦.vec 8 64⟧) (v577 : ⟦.vec 8 64⟧)
        (v578 : ⟦.vec 8 64⟧) (v579 : ⟦.vec 8 64⟧) (v580 : ⟦.vec 8 64⟧) (v581 : ⟦.vec 8 64⟧)
        (v582 : ⟦.vec 8 64⟧) (v583 : ⟦.vec 8 64⟧) (v585 : ⟦.vec 8 64⟧) (v586 : ⟦.vec 8 64⟧)
        (v587 : ⟦.vec 8 64⟧) (v588 : ⟦.vec 8 64⟧) (v589 : ⟦.vec 8 64⟧) (v590 : ⟦.vec 8 64⟧)
        (v591 : ⟦.vec 8 64⟧) (v592 : ⟦.vec 8 64⟧) (v593 : ⟦.vec 8 64⟧) (v594 : ⟦.vec 8 64⟧)
        (v596 : ⟦.vec 8 64⟧) (v597 : ⟦.vec 8 64⟧) (v598 : ⟦.vec 8 64⟧) (v599 : ⟦.vec 8 64⟧)
        (v600 : ⟦.vec 8 64⟧) (v601 : ⟦.vec 8 64⟧) (v602 : ⟦.vec 8 64⟧) (v603 : ⟦.vec 8 64⟧)
        (v604 : ⟦.vec 8 64⟧) (v605 : ⟦.vec 8 64⟧) (v606 : ⟦.ptr⟧) (v607 : ⟦.vec 8 64⟧)
        (v608 : ⟦.vec 8 64⟧) (v609 : ⟦.vec 8 64⟧) (v610 : ⟦.vec 8 64⟧) (v611 : ⟦.vec 8 64⟧)
        (v612 : ⟦.vec 8 64⟧) (v613 : ⟦.vec 8 64⟧) (v614 : ⟦.vec 8 64⟧) (v615 : ⟦.vec 8 64⟧)
        (Y : Fe), Y = yOf X →
        (verify_x8.bb40.runBodyFrom E[rir_dst% hty 558 := PoisonOr.value P,
          rir_dst% hty 559 := v559, rir_dst% hty 560 := v560,
          rir_dst% hty 561 := PoisonOr.value (P.add 320#64), rir_dst% hty 562 := v562,
          rir_dst% hty 563 := v563, rir_dst% hty 564 := PoisonOr.value (P.add 384#64),
          rir_dst% hty 565 := v565, rir_dst% hty 566 := v566, rir_dst% hty 567 := v567,
          rir_dst% hty 568 := v568, rir_dst% hty 569 := v569, rir_dst% hty 570 := v570,
          rir_dst% hty 571 := v571, rir_dst% hty 572 := v572, rir_dst% hty 573 := v573,
          rir_dst% hty 574 := v574, rir_dst% hty 575 := v575, rir_dst% hty 576 := v576,
          rir_dst% hty 577 := v577, rir_dst% hty 578 := v578, rir_dst% hty 579 := v579,
          rir_dst% hty 580 := v580, rir_dst% hty 581 := v581,
          rir_dst% hty 582 := v582][rir_dst% hty 583 := v583,
          rir_dst% hty 584 := PoisonOr.value (P.add 448#64), rir_dst% hty 585 := v585,
          rir_dst% hty 586 := v586, rir_dst% hty 587 := v587, rir_dst% hty 588 := v588,
          rir_dst% hty 589 := v589, rir_dst% hty 590 := v590, rir_dst% hty 591 := v591,
          rir_dst% hty 592 := v592, rir_dst% hty 593 := v593, rir_dst% hty 594 := v594,
          rir_dst% hty 595 := PoisonOr.value (P.add 512#64), rir_dst% hty 596 := v596,
          rir_dst% hty 597 := v597, rir_dst% hty 598 := v598, rir_dst% hty 599 := v599,
          rir_dst% hty 600 := v600, rir_dst% hty 601 := v601, rir_dst% hty 602 := v602,
          rir_dst% hty 603 := v603, rir_dst% hty 604 := v604, rir_dst% hty 605 := v605,
          rir_dst% hty 606 := v606, rir_dst% hty 607 := v607][rir_dst% hty 608 := v608,
          rir_dst% hty 609 := v609, rir_dst% hty 610 := v610, rir_dst% hty 611 := v611,
          rir_dst% hty 612 := v612, rir_dst% hty 613 := v613, rir_dst% hty 614 := v614,
          rir_dst% hty 615 := v615, rir_dst% hty 616 := Ty.wrap Y.l4] 156
          { S with
            mem :=
              (((((((((S.mem.storeAt P 0#2560).storeAt (P.add 960#64)
                                  (BitVec.packLanes (Vector.replicate 8 0#64))).storeAt
                              (P.add 640#64) (BitVec.packLanes (Vector.replicate 8 1#64))).storeAt
                          (P.add 704#64) 0#2048).storeAt
                      (P.add 1024#64) 0#2048).storeAt
                  (P.add 320#64) (BitVec.packLanes Y.l0)).storeAt
              (P.add 384#64) (BitVec.packLanes Y.l1)).storeAt
          (P.add 448#64) (BitVec.packLanes Y.l2)).storeAt
        (P.add 512#64) (BitVec.packLanes Y.l3)).storeAt (P.add 576#64) (BitVec.packLanes Y.l4) } >>=
          G) = K) :
    (verify_x8.bb40.runBodyFrom E 87 S >>= G) = K := by
  split_env hC hR
  step_load
  iterate 3 step_pure
  step_memset
  clear_stored
  step_store
  clear_stored
  step_store
  iterate 3 step_pure
  clear_stored
  step_memset
  clear_stored
  step_memset
  step_pattern using runBodyFrom_insert8Run
  step_pure
  clear_stored
  step_store
  step_pattern using runBodyFrom_insert8Run
  iterate 2 step_pure
  clear_stored
  step_store
  step_pure
  step_pattern using runBodyFrom_insert8Run
  iterate 2 step_pure
  clear_stored
  step_store
  step_pure
  step_pattern using runBodyFrom_insert8Run
  iterate 2 step_pure
  clear_stored
  step_store
  step_pure
  step_pattern using runBodyFrom_insert8Run
  iterate 2 step_pure
  clear_stored
  step_store
  rw [hE, hS]
  subst v572 v581 v592 v603 v614
  exact hK _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
      _ _ _ _ _ _ _ _ ⟨_, _, _, _, _⟩ (yOf_eq X)

-- 47 steps in one declaration
set_option maxHeartbeats 1000000 in
/-- `^bb40`'s `fd_ed25519_lane_sub( &u[n], &y2, &r[n]->z )` and `fd_ed25519_lane_add_raw( &v[n],
&v[n],
&r[n]->z )`, both stored: `z` read off the point at `P`, its limbs past the first zero. -/
theorem bb40_B {S : GlobalState} {E : ⟪Γ⟫} {G : ⟪Γ⟫ × GlobalState → PoisonOr β}
    {K : PoisonOr β} (up vp P : Pointer) (Y2 W V : Fe) (hY2 : Y2 = carry W)
    (hC :
      E ⊨ [%95 := Ty.wrap (Vector.replicate 8 1#64),
        %96 := Ty.wrap (Vector.replicate 8 2251799813685247#64),
        %103 := Ty.wrap (Vector.replicate 8 19#64), %104 := Ty.wrap (Vector.replicate 8 51#64),
        %105 := Ty.wrap (Vector.replicate 8 9007199254740915#64),
        %106 := Ty.wrap (Vector.replicate 8 9007199254740988#64)])
    (hR :
      E ⊨ [rir_reg% hty 461 := PoisonOr.value vp, rir_reg% hty 462 := PoisonOr.value up,
        rir_reg% hty 558 := PoisonOr.value P, rir_reg% hty 678 := Ty.wrap Y2.l0,
        rir_reg% hty 680 := Ty.wrap Y2.l1, rir_reg% hty 682 := Ty.wrap Y2.l2,
        rir_reg% hty 684 := Ty.wrap Y2.l3, rir_reg% hty 686 := Ty.wrap Y2.l4,
        rir_reg% hty 748 := PoisonOr.value (vp.add 64#64),
        rir_reg% hty 751 := PoisonOr.value (vp.add 128#64),
        rir_reg% hty 754 := PoisonOr.value (vp.add 192#64),
        rir_reg% hty 757 := PoisonOr.value (vp.add 256#64), rir_reg% hty 764 := Ty.wrap V.l0,
        rir_reg% hty 766 := Ty.wrap V.l1, rir_reg% hty 768 := Ty.wrap V.l2,
        rir_reg% hty 770 := Ty.wrap V.l3, rir_reg% hty 772 := Ty.wrap V.l4])
    (hz2 : Fits S.mem (P.add 768#64) 512) (hz2r : S.mem.readAt (P.add 768#64) 512 = 0)
    (hz3 : Fits S.mem (P.add 832#64) 512) (hz3r : S.mem.readAt (P.add 832#64) 512 = 0)
    (hz4 : Fits S.mem (P.add 896#64) 512) (hz4r : S.mem.readAt (P.add 896#64) 512 = 0)
    (hPo : P.offset = 0) (hu : Room S.mem up 2560) (huo : ¬up.offset.uaddOverflow 1280#64)
    (hv : Room S.mem vp 2560) (hvo : ¬vp.offset.uaddOverflow 1280#64)
    (hK :
      ∀ (v773 : ⟦.vec 8 64⟧) (v774 : ⟦.vec 8 64⟧) (v775 : ⟦.ptr⟧) (v776 : ⟦.vec 8 64⟧)
        (v777 : ⟦.ptr⟧) (v778 : ⟦.vec 8 64⟧) (v779 : ⟦.vec 8 64⟧) (v780 : ⟦.ptr⟧)
        (v781 : ⟦.vec 8 64⟧) (v782 : ⟦.ptr⟧) (v783 : ⟦.vec 8 64⟧) (v784 : ⟦.vec 8 64⟧)
        (v785 : ⟦.ptr⟧) (v786 : ⟦.vec 8 64⟧) (v787 : ⟦.ptr⟧) (v788 : ⟦.vec 8 64⟧)
        (v789 : ⟦.vec 8 64⟧) (v790 : ⟦.ptr⟧) (v791 : ⟦.vec 8 64⟧) (v792 : ⟦.vec 8 64⟧)
        (v793 : ⟦.vec 8 64⟧) (v794 : ⟦.vec 8 64⟧) (v795 : ⟦.vec 8 64⟧) (v796 : ⟦.vec 8 64⟧)
        (v798 : ⟦.vec 8 64⟧) (v800 : ⟦.vec 8 64⟧) (v802 : ⟦.vec 8 64⟧) (v804 : ⟦.vec 8 64⟧)
        (U : Fe), U = sub (carry W) Fe.one →
        ∀ V0 V2 V3 V4 : Wwl, (⟨V0, V.l1, V2, V3, V4⟩ : Fe) = addRaw V Fe.one →
        (verify_x8.bb40.runBodyFrom E[rir_dst% hty 773 := v773, rir_dst% hty 774 := v774,
          rir_dst% hty 775 := v775, rir_dst% hty 776 := v776, rir_dst% hty 777 := v777,
          rir_dst% hty 778 := v778, rir_dst% hty 779 := v779, rir_dst% hty 780 := v780,
          rir_dst% hty 781 := v781, rir_dst% hty 782 := v782, rir_dst% hty 783 := v783,
          rir_dst% hty 784 := v784, rir_dst% hty 785 := v785, rir_dst% hty 786 := v786,
          rir_dst% hty 787 := v787, rir_dst% hty 788 := v788, rir_dst% hty 789 := v789,
          rir_dst% hty 790 := v790, rir_dst% hty 791 := v791, rir_dst% hty 792 := v792,
          rir_dst% hty 793 := v793, rir_dst% hty 794 := v794, rir_dst% hty 795 := v795,
          rir_dst% hty 796 := v796, rir_dst% hty 797 := Ty.wrap U.l0][rir_dst% hty 798 := v798,
          rir_dst% hty 799 := Ty.wrap U.l1, rir_dst% hty 800 := v800,
          rir_dst% hty 801 := Ty.wrap U.l2, rir_dst% hty 802 := v802,
          rir_dst% hty 803 := Ty.wrap U.l3, rir_dst% hty 804 := v804,
          rir_dst% hty 805 := Ty.wrap U.l4, rir_dst% hty 806 := Ty.wrap V0,
          rir_dst% hty 807 := Ty.wrap V2, rir_dst% hty 808 := Ty.wrap V3,
          rir_dst% hty 809 := Ty.wrap V4] 359
          { S with mem := (S.mem.storeFe up U).storeFe vp ⟨V0, V.l1, V2, V3, V4⟩ } >>= G) = K) :
    (verify_x8.bb40.runBodyFrom E 312 S >>= G) = K := by
  subst hY2
  split_env hC hR
  iterate 5 step_pure
  step_load
  iterate 4 step_pure
  step_load
  iterate 4 step_pure
  step_load
  iterate 9 step_pure
  step_store
  iterate 2 step_pure
  step_store
  iterate 2 step_pure
  step_store
  iterate 2 step_pure
  step_store
  iterate 2 step_pure
  step_store
  step_pure
  step_store
  step_store
  step_pure
  step_store
  step_pure
  step_store
  step_pure
  step_store
  subst v778 v783 v788
  rw [hE, hS]
  exact hK _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ ⟨_, _, _, _, _⟩
      (subOne_eq (carry W)) _ _ _ _ (addOne_eq V)

-- seventeen runs of `^bb40`'s 837 instructions in one declaration
set_option maxHeartbeats 4000000 in
/-- An iteration of `fd_ed25519_lane_decode2`'s first loop (`^bb40`'s body) on the encodings `X` at
`buf`: the sign word at `sp`, the point `r[n]` (at `P`, its address at `rp`) zeroed with `y`, and
`u`, `v`, `u v³`, `u v⁷` at `up`, `vp`, `u3p`, `u7p`. -/
theorem bb40_run (c : Call) (flag : BitVec 1) (sp rp P up vp u3p u7p : Pointer)
    (buf : Fin 8 → Pointer) (X : Fin 8 → BitVec 256) (D : Fe) (S : GlobalState) (E : ⟪Γ⟫)
    {G : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hG :
      G = fun x =>
        Exit.run verify_x8.blockParams x.1 verify_x8.bb40.exit x.2 >>= fun x =>
          Func.continue (func := verify_x8 c.batch) x.1.1 x.1.2 x.2 >>= g)
    (hA : E.args = c.args) (hD : EnvD c E)
    (hR :
      E ⊨ [rir_reg% hty 443 := Ty.wrap D.l0, rir_reg% hty 444 := Ty.wrap D.l1,
        rir_reg% hty 445 := Ty.wrap D.l2, rir_reg% hty 446 := Ty.wrap D.l3,
        rir_reg% hty 447 := Ty.wrap D.l4, rir_reg% hty 457 := PoisonOr.value flag,
        rir_reg% hty 458 := PoisonOr.value sp, rir_reg% hty 459 := PoisonOr.value u7p,
        rir_reg% hty 460 := PoisonOr.value u3p, rir_reg% hty 461 := PoisonOr.value vp,
        rir_reg% hty 462 := PoisonOr.value up, rir_reg% hty 463 := PoisonOr.value (buf 7),
        rir_reg% hty 464 := PoisonOr.value (buf 6), rir_reg% hty 465 := PoisonOr.value (buf 5),
        rir_reg% hty 466 := PoisonOr.value (buf 4), rir_reg% hty 467 := PoisonOr.value (buf 3),
        rir_reg% hty 468 := PoisonOr.value (buf 2), rir_reg% hty 469 := PoisonOr.value (buf 1),
        rir_reg% hty 470 := PoisonOr.value (buf 0), rir_reg% hty 471 := PoisonOr.value rp])
    (hbuf : ∀ j, Fits S.mem (buf j) 256 ∧ S.mem.readAt (buf j) 256 = X j ∧
      ¬(buf j).offset.uaddOverflow 32#64)
    (hsp : Fits S.mem sp 32) (hspr : S.mem.readAt sp 32 = 0) (hspw : Writable S.mem sp)
    (hrp : InBounds S.mem rp 64) (hrpr : S.mem.loadPtr rp = .value P)
    (hP : Room S.mem P 10240) (hPo : P.offset = 0)
    (hup : Room S.mem up 2560) (huo : ¬up.offset.uaddOverflow 1280#64)
    (hvp : Room S.mem vp 2560) (hvo : ¬vp.offset.uaddOverflow 1280#64)
    (hu3 : Room S.mem u3p 2560) (hu3o : ¬u3p.offset.uaddOverflow 1280#64)
    (hu7 : Room S.mem u7p 2560) (hu7o : ¬u7p.offset.uaddOverflow 1280#64)
    (hne : [sp.id, rp.id, P.id, up.id, vp.id, u3p.id, u7p.id].Nodup)
    (hK :
      ∀ E' : ⟪Γ⟫, E'.args = c.args → EnvD c E' →
        (E' ⊨ [rir_reg% hty 443 := Ty.wrap D.l0, rir_reg% hty 444 := Ty.wrap D.l1,
          rir_reg% hty 445 := Ty.wrap D.l2, rir_reg% hty 446 := Ty.wrap D.l3,
          rir_reg% hty 447 := Ty.wrap D.l4, rir_reg% hty 457 := PoisonOr.value flag]) →
        (verify_x8.bb40.runBodyFrom E' 837
            { S with
              mem :=
                ((((pointMem (S.mem.storeAt sp (signs X)) P (decPre D X).y).storeFe up
                  (decPre D X).u).storeFe vp (decPre D X).v).storeFe u3p (decPre D X).uv3).storeFe
                  u7p (decPre D X).uv7 } >>=
          G) = K) :
    (verify_x8.bb40.runBodyFrom E 0 S >>= G) = K := by
  subst hG
  have hf0 := (hbuf 0).1
  have hr0 := (hbuf 0).2.1
  have ho0 := (hbuf 0).2.2
  have hf1 := (hbuf 1).1
  have hr1 := (hbuf 1).2.1
  have ho1 := (hbuf 1).2.2
  have hf2 := (hbuf 2).1
  have hr2 := (hbuf 2).2.1
  have ho2 := (hbuf 2).2.2
  have hf3 := (hbuf 3).1
  have hr3 := (hbuf 3).2.1
  have ho3 := (hbuf 3).2.2
  have hf4 := (hbuf 4).1
  have hr4 := (hbuf 4).2.1
  have ho4 := (hbuf 4).2.2
  have hf5 := (hbuf 5).1
  have hr5 := (hbuf 5).2.1
  have ho5 := (hbuf 5).2.2
  have hf6 := (hbuf 6).1
  have hr6 := (hbuf 6).2.1
  have ho6 := (hbuf 6).2.2
  have hf7 := (hbuf 7).1
  have hr7 := (hbuf 7).2.1
  have ho7 := (hbuf 7).2.2
  clear hbuf
  split_env hD hR
  step_pattern using bb40_A1 sp buf X
  step_pattern using bb40_A2 rp P X
  step_load inline
  step_load inline
  step_load inline
  step_load inline
  step_pattern using runBodyFrom_sqrCRun (A := yOf X) with y2
  subst_limb4
  step_pattern using runBodyFrom_mulGepRun 64 128 192 256
  step_pattern using runBodyFrom_carryRun'
  generalize hVV :
      (carry ⟨(mul ⟨y2.l0, y2.l1, y2.l2, y2.l3, y2.l4⟩ ⟨D.l0, D.l1, D.l2, D.l3, D.l4⟩ false).l0,
      (mul ⟨y2.l0, y2.l1, y2.l2, y2.l3, y2.l4⟩ ⟨D.l0, D.l1, D.l2, D.l3, D.l4⟩ false).l1,
      (mul ⟨y2.l0, y2.l1, y2.l2, y2.l3, y2.l4⟩ ⟨D.l0, D.l1, D.l2, D.l3, D.l4⟩ false).l2,
      (mul ⟨y2.l0, y2.l1, y2.l2, y2.l3, y2.l4⟩ ⟨D.l0, D.l1, D.l2, D.l3, D.l4⟩ false).l3,
      (mul ⟨y2.l0, y2.l1, y2.l2, y2.l3, y2.l4⟩ ⟨D.l0, D.l1, D.l2, D.l3, D.l4⟩ false).l4⟩ : Fe) = VV
      at *
  have hPov : ¬P.offset.uaddOverflow 1280#64 := by rw [hPo]; decide
  have hz : Fits S.mem (P.add 704#64) 2048 ∧ S.mem.readAt (P.add 704#64) 2048 = 0 := by
    rw [hS] at hP ⊢
    have hR := (room_pointMem_iff (P := P) _).1 hP
    exact ⟨pointMem_fits_z hPov hR _, pointMem_readAt_z hPov hR _⟩
  have hzo : ¬(P.add 704#64).offset.uaddOverflow 256#64 := by
    simp [Pointer.add, hPo, BitVec.uaddOverflow]
  obtain ⟨hz2, hz2r⟩ := zero_limb hzo hz.1 hz.2 (o := 64#64) (by decide)
  obtain ⟨hz3, hz3r⟩ := zero_limb hzo hz.1 hz.2 (o := 128#64) (by decide)
  obtain ⟨hz4, hz4r⟩ := zero_limb hzo hz.1 hz.2 (o := 192#64) (by decide)
  simp only [Pointer.add_add, BitVec.reduceAdd] at hz2 hz2r hz3 hz3r hz4 hz4r
  clear hz
  step_pattern using bb40_B up vp P y2 (sqr (yOf X) false) _ (by rw [hy2, sqr_eq_carry])
    with u v0 v2 v3 v4
  step_pattern using runBodyFrom_sqrCRun (A := ⟨v0, VV.l1, v2, v3, v4⟩) with vsq
  subst_limb4
  step_pattern using runBodyFrom_mulCRun (B := ⟨v0, VV.l1, v2, v3, v4⟩) with vcub
  subst_limb4
  step_pattern using runBodyFrom_mulStoreRun' 64 128 192 256
  step_pattern using runBodyFrom_sqrGepRun 64 128 192 256 inline
  step_pattern using runBodyFrom_carryRun'
  step_pattern using runBodyFrom_mulCRun (B := ⟨v0, VV.l1, v2, v3, v4⟩) with w7
  subst_limb4
  step_pattern using runBodyFrom_mulLooseRun'
  step_pattern using runBodyFrom_carryStoreRun
  have h1 : EnvD c E := by env_reads
  have h2 : E ⊨ [rir_reg% hty 443 := Ty.wrap D.l0, rir_reg% hty 444 := Ty.wrap D.l1,
      rir_reg% hty 445 := Ty.wrap D.l2, rir_reg% hty 446 := Ty.wrap D.l3,
      rir_reg% hty 447 := Ty.wrap D.l4, rir_reg% hty 457 := PoisonOr.value flag] := by env_reads
  subst hS Y u vsq vcub w7 v1277 VV y2
  simp only [fe_eta, ← mul_eq_carry, ← sqr_eq_carry] at heq ⊢
  rw [heq]
  convert hK E hArgs h1 h2 using 4
  simp only [MemoryState.storeFe, pointMem, decPre]
  rfl


end

end MLIR.Firedancer.Lane.VerifyX8.Decode
