module

public import MLIR.Run.Tactic
public import Agave.Common.Sha512Rounds
public import Agave.Serial.Mlir.compress512

/-! `compress512`'s loop body `^bb1` in four parts: the block's words and rounds `0 … 19`, then
rounds `20 … 39`, `40 … 59`, `60 … 79` and the sums, each one declaration, the registers live at
each cut as named facts. -/

namespace MLIR.Agave.Serial

open _root_.Ed25519 MLIR.Agave

namespace compress512

@[expose] public section

/-- `^bb0`'s constants and pointers, as `^bb1` and `^bb2` read them. -/
abbrev Statics (st Kp En : Pointer) (E : ⟪Γ⟫) : Prop :=
  E ⊨ [%2381 := 6#64, %2382 := 3#64, %2383 := 45#64, %2384 := 63#64, %2385 := 7#64, %2386 := 56#64,
    %2387 := 50#64, %2388 := 46#64, %2389 := 23#64, %2390 := 18446744073709551615#64, %2391 := Kp,
    %2392 := 36#64, %2393 := 30#64, %2394 := 25#64, %2395 := Kp.add 8#64, %2396 := Kp.add 16#64,
    %2397 := Kp.add 24#64, %2398 := Kp.add 32#64, %2399 := Kp.add 40#64, %2400 := Kp.add 48#64,
    %2401 := Kp.add 56#64, %2402 := Kp.add 64#64, %2403 := Kp.add 72#64, %2404 := Kp.add 80#64,
    %2405 := Kp.add 88#64, %2406 := Kp.add 96#64, %2407 := Kp.add 104#64, %2408 := Kp.add 112#64,
    %2409 := Kp.add 120#64, %2410 := Kp.add 128#64, %2411 := Kp.add 136#64, %2412 := Kp.add 144#64,
    %2413 := Kp.add 152#64, %2414 := Kp.add 160#64, %2415 := Kp.add 168#64, %2416 := Kp.add 176#64,
    %2417 := Kp.add 184#64, %2418 := Kp.add 192#64, %2419 := Kp.add 200#64, %2420 := Kp.add 208#64,
    %2421 := Kp.add 216#64, %2422 := Kp.add 224#64, %2423 := Kp.add 232#64, %2424 := Kp.add 240#64,
    %2425 := Kp.add 248#64, %2426 := Kp.add 256#64, %2427 := Kp.add 264#64, %2428 := Kp.add 272#64,
    %2429 := Kp.add 280#64, %2430 := Kp.add 288#64, %2431 := Kp.add 296#64, %2432 := Kp.add 304#64,
    %2433 := Kp.add 312#64, %2434 := Kp.add 320#64, %2435 := Kp.add 328#64, %2436 := Kp.add 336#64,
    %2437 := Kp.add 344#64, %2438 := Kp.add 352#64, %2439 := Kp.add 360#64, %2440 := Kp.add 368#64,
    %2441 := Kp.add 376#64, %2442 := Kp.add 384#64, %2443 := Kp.add 392#64, %2444 := Kp.add 400#64,
    %2445 := Kp.add 408#64, %2446 := Kp.add 416#64, %2447 := Kp.add 424#64, %2448 := Kp.add 432#64,
    %2449 := Kp.add 440#64, %2450 := Kp.add 448#64, %2451 := Kp.add 456#64, %2452 := Kp.add 464#64,
    %2453 := Kp.add 472#64, %2454 := Kp.add 480#64, %2455 := Kp.add 488#64, %2456 := Kp.add 496#64,
    %2457 := Kp.add 504#64, %2458 := Kp.add 512#64, %2459 := Kp.add 520#64, %2460 := Kp.add 528#64,
    %2461 := Kp.add 536#64, %2462 := Kp.add 544#64, %2463 := Kp.add 552#64, %2464 := Kp.add 560#64,
    %2465 := Kp.add 568#64, %2466 := Kp.add 576#64, %2467 := Kp.add 584#64, %2468 := Kp.add 592#64,
    %2469 := Kp.add 600#64, %2470 := Kp.add 608#64, %2471 := Kp.add 616#64, %2472 := Kp.add 624#64,
    %2473 := Kp.add 632#64, %2475 := En, %2477 := st.add 8#64, %2478 := st.add 16#64, %2479 :=
    st.add 24#64, %2480 := st.add 32#64, %2481 := st.add 40#64, %2482 := st.add 48#64, %2483 :=
    st.add 56#64]

/-- `^bb1`'s env at block `P`, state words `H`. -/
abbrev hdr (P : Pointer) (H : Vector (BitVec 64) 8) (E : ⟪Γ⟫) : ⟪Γ⟫ :=
  E[%2491 := .value H[7], %2492 := .value H[6], %2493 := .value H[5], %2494 := .value H[4], %2495 :=
    .value H[3], %2496 := .value H[2], %2497 := .value H[1], %2498 := .value P, %2499 :=
    .value H[0]]

/-- The block's registers: its state words `H` and the next block's pointer. -/
abbrev Params (P : Pointer) (H : Vector (BitVec 64) 8) (E : ⟪Γ⟫) : Prop :=
  E ⊨ [%2491 := H[7], %2492 := H[6], %2493 := H[5], %2494 := H[4], %2495 := H[3], %2496 := H[2],
    %2497 := H[1], %2499 := H[0], %2500 := P.add 128#64]

/-- The registers live into round 20, besides `^bb0`'s and the block's. -/
abbrev Live20 (Wf : Nat → BitVec 64) (a20 a19 a18 a17 e20 e19 e18 e17 : BitVec 64) (E : ⟪Γ⟫) :
    Prop :=
  E ⊨ [%2517 := Wf 5, %2520 := Wf 6, %2523 := Wf 7, %2526 := Wf 8, %2529 := Wf 9, %2532 := Wf 10,
    %2535 := Wf 11, %2538 := Wf 12, %2541 := Wf 13, %2544 := Wf 14, %2547 := Wf 15,
    rir_reg% compress512.hty 596 := Wf 16, rir_reg% compress512.hty 621 := e17,
    rir_reg% compress512.hty 622 := a17, rir_reg% compress512.hty 635 := Wf 17,
    rir_reg% compress512.hty 660 := e18, rir_reg% compress512.hty 661 := a18,
    rir_reg% compress512.hty 674 := Wf 18, rir_reg% compress512.hty 699 := e19,
    rir_reg% compress512.hty 700 := a19, rir_reg% compress512.hty 713 := Wf 19,
    rir_reg% compress512.hty 733 := a19 &&& a18, rir_reg% compress512.hty 738 := e20,
    rir_reg% compress512.hty 739 := a20, rir_reg% compress512.hty 752 := Wf 20,
    rir_reg% compress512.hty 757 := Sha512.Sigma1 e20, rir_reg% compress512.hty 761 :=
    Sha512.Ch e20 e19 e18]

/-- The registers live into round 40, besides `^bb0`'s and the block's. -/
abbrev Live40 (Wf : Nat → BitVec 64) (a40 a39 a38 a37 e40 e39 e38 e37 : BitVec 64) (E : ⟪Γ⟫) :
    Prop :=
  E ⊨ [rir_reg% compress512.hty 947 := Wf 25, rir_reg% compress512.hty 986 := Wf 26,
    rir_reg% compress512.hty 1025 := Wf 27, rir_reg% compress512.hty 1064 := Wf 28,
    rir_reg% compress512.hty 1103 := Wf 29, rir_reg% compress512.hty 1142 := Wf 30,
    rir_reg% compress512.hty 1181 := Wf 31, rir_reg% compress512.hty 1220 := Wf 32,
    rir_reg% compress512.hty 1259 := Wf 33, rir_reg% compress512.hty 1298 := Wf 34,
    rir_reg% compress512.hty 1337 := Wf 35, rir_reg% compress512.hty 1376 := Wf 36,
    rir_reg% compress512.hty 1401 := e37, rir_reg% compress512.hty 1402 := a37,
    rir_reg% compress512.hty 1415 := Wf 37, rir_reg% compress512.hty 1440 := e38,
    rir_reg% compress512.hty 1441 := a38, rir_reg% compress512.hty 1454 := Wf 38,
    rir_reg% compress512.hty 1479 := e39, rir_reg% compress512.hty 1480 := a39,
    rir_reg% compress512.hty 1493 := Wf 39, rir_reg% compress512.hty 1513 := a39 &&& a38,
    rir_reg% compress512.hty 1518 := e40, rir_reg% compress512.hty 1519 := a40,
    rir_reg% compress512.hty 1532 := Wf 40, rir_reg% compress512.hty 1537 := Sha512.Sigma1 e40,
    rir_reg% compress512.hty 1541 := Sha512.Ch e40 e39 e38]

/-- The registers live into round 60, besides `^bb0`'s and the block's. -/
abbrev Live60 (Wf : Nat → BitVec 64) (a60 a59 a58 a57 e60 e59 e58 e57 : BitVec 64) (E : ⟪Γ⟫) :
    Prop :=
  E ⊨ [rir_reg% compress512.hty 1727 := Wf 45, rir_reg% compress512.hty 1766 := Wf 46,
    rir_reg% compress512.hty 1805 := Wf 47, rir_reg% compress512.hty 1844 := Wf 48,
    rir_reg% compress512.hty 1883 := Wf 49, rir_reg% compress512.hty 1922 := Wf 50,
    rir_reg% compress512.hty 1961 := Wf 51, rir_reg% compress512.hty 2000 := Wf 52,
    rir_reg% compress512.hty 2039 := Wf 53, rir_reg% compress512.hty 2078 := Wf 54,
    rir_reg% compress512.hty 2117 := Wf 55, rir_reg% compress512.hty 2156 := Wf 56,
    rir_reg% compress512.hty 2181 := e57, rir_reg% compress512.hty 2182 := a57,
    rir_reg% compress512.hty 2195 := Wf 57, rir_reg% compress512.hty 2220 := e58,
    rir_reg% compress512.hty 2221 := a58, rir_reg% compress512.hty 2234 := Wf 58,
    rir_reg% compress512.hty 2259 := e59, rir_reg% compress512.hty 2260 := a59,
    rir_reg% compress512.hty 2273 := Wf 59, rir_reg% compress512.hty 2293 := a59 &&& a58,
    rir_reg% compress512.hty 2298 := e60, rir_reg% compress512.hty 2299 := a60,
    rir_reg% compress512.hty 2312 := Wf 60, rir_reg% compress512.hty 2317 := Sha512.Sigma1 e60,
    rir_reg% compress512.hty 2321 := Sha512.Ch e60 e59 e58]

/-- `llvm.intr.bswap` on 64 bits, as the step leaves it. -/
abbrev bswap64 (x : BitVec 64) : BitVec 64 :=
  List.foldl (fun acc i => acc ||| (x >>> (8 * i) &&& 255#64) <<< (64 - 8 * (i + 1))) 0#64
    (List.range 8)

end

section Proof

/-- `^bb1` from position `p`: the rest of the block, its exit, then `g`. -/
local macro "BODY " E:term:max ppSpace p:term:max ppSpace S:term:max ppSpace g:term:max : term =>
  `((compress512.bb1.runBodyFrom $E $p $S >>= fun x =>
      Exit.run compress512.blockParams x.fst compress512.bb1.exit x.snd >>= fun x =>
        @bind PoisonOr _ (Vals [] × GlobalState) _
          (Func.continue (func := compress512) x.1.fst x.1.snd x.snd) $g))

set_option hygiene false in
/-- Block word `t`: its address, its load, its byte swap `w`, then `w` replaced by `Wf t`. -/
local macro "word " w:ident t:num : tactic =>
  `(tactic|
    ( step_pure
      step_load inline
      step_pure with $w:ident hw
      have e := hw.trans (hW0 $t (by decide))
      clear hw
      subst e))

set_option hygiene false in
/-- `h : A ∧ B` into a fact `A` and `h : B`. -/
local macro "peel " h:ident : tactic =>
  `(tactic|
    ( have := $h:ident.1
      replace $h:ident := $h:ident.2))

-- twenty pattern sites in one declaration
set_option maxHeartbeats 1000000 in
/-- `^bb1` from its start, on block `P` with the state words `H`: the block's words `Wf 0 … Wf 15`
and rounds `0 … 19`, then on with `rounds Wf 20` and the registers live into round `20`. -/
public theorem rounds0 (st Kp En P : Pointer) (A : Vals compress512.Γ.args)
    (H : Vector (BitVec 64) 8) (Wf : Nat → BitVec 64) (E : ⟪Γ⟫) (S : GlobalState)
    (g : Vals [] × GlobalState → PoisonOr β) (K : PoisonOr β) (hArgs : E.args = A.get)
    (hst : Statics st Kp En E) (hB : Fits S.mem P 1024) (hBo : ¬P.offset.uaddOverflow 128#64)
    (hKf : Fits S.mem Kp 5120) (hKo : Kp.offset = 0)
    (hK : ∀ t, t < 80 → S.mem.readAt (Kp.add (BitVec.ofNat 64 (8 * t))) 64 = Sha512.K[t]!)
    (hWs :
      ∀ t,
        16 ≤ t →
          t < 80 →
          Wf t =
            Sha512.sigma1 (Wf (t - 2)) + Wf (t - 7) + Sha512.sigma0 (Wf (t - 15)) + Wf (t - 16))
    (hW00 : bswap64 ((S.mem.readAt P 1024).setWidth 64) = Wf 0)
    (hW0 : ∀ t, t < 16 → bswap64 ((S.mem.readAt P 1024).extractLsb' (64 * t) 64) = Wf t)
    (hcont :
      ∀ (E' : ⟪Γ⟫) (a20' a19' a18' a17' e20' e19' e18' e17' : BitVec 64),
        rounds Wf 20 #v[H[0], H[1], H[2], H[3], H[4], H[5], H[6], H[7]] =
            #v[a20', a19', a18', a17', e20', e19', e18', e17'] →
          E'.args = A.get →
          Statics st Kp En E' →
          Params P H E' →
          Live20 Wf a20' a19' a18' a17' e20' e19' e18' e17' E' → BODY E' 643 S g = K) :
    (compress512.runFrom (hdr P H E) 1 S >>= g) = K := by
  block_init
  iterate 100 peel hst
  step_pure
  step_load inline
  step_pure with w0 hw
  have e := hw.trans hW00
  clear hw
  subst e
  word w1 1
  word w2 2
  word w3 3
  word w4 4
  word w5 5
  word w6 6
  word w7 7
  word w8 8
  word w9 9
  word w10 10
  word w11 11
  word w12 12
  word w13 13
  word w14 14
  word w15 15
  subst hS
  clear hread_P hread_Kp hW0 hW00
  have hS : S = S := rfl
  have hK0 : S.mem.readAt Kp 64 = Sha512.K[0]! := by simpa using hK 0 (by decide)
  step_pattern using runBodyFrom_round0 (hk := hK0) inline
  name_acc hacc
  step_pattern using runBodyFrom_roundA (o := .whk) (hk := hK 1 (by decide)) (hacc := hacc) inline
  name_acc hacc
  step_pattern using runBodyFrom_roundA (o := .whk) (hk := hK 2 (by decide)) (hacc := hacc) inline
  name_acc hacc
  step_pattern using runBodyFrom_roundA (o := .whk) (hk := hK 3 (by decide)) (hacc := hacc) inline
  name_acc hacc
  step_pattern using runBodyFrom_roundA (o := .hwk) (hk := hK 4 (by decide)) (hacc := hacc) inline
  name_acc hacc
  step_pattern using runBodyFrom_roundA (o := .kwh) (hk := hK 5 (by decide)) (hacc := hacc) inline
  name_acc hacc
  step_pattern using runBodyFrom_roundA (o := .kwh) (hk := hK 6 (by decide)) (hacc := hacc) inline
  name_acc hacc
  step_pattern using runBodyFrom_roundA (o := .kwh) (hk := hK 7 (by decide)) (hacc := hacc) inline
  name_acc hacc
  step_pattern using runBodyFrom_roundA (o := .kwh) (hk := hK 8 (by decide)) (hacc := hacc) inline
  name_acc hacc
  step_pattern using runBodyFrom_roundA (o := .kwh) (hk := hK 9 (by decide)) (hacc := hacc) inline
  name_acc hacc
  step_pattern using runBodyFrom_roundA (o := .kwh) (hk := hK 10 (by decide)) (hacc := hacc) inline
  name_acc hacc
  step_pattern using runBodyFrom_roundA (o := .kwh) (hk := hK 11 (by decide)) (hacc := hacc) inline
  name_acc hacc
  step_pattern using runBodyFrom_roundA (o := .kwh) (hk := hK 12 (by decide)) (hacc := hacc) inline
  name_acc hacc
  step_pattern using runBodyFrom_roundA (o := .kwh) (hk := hK 13 (by decide)) (hacc := hacc) inline
  name_acc hacc
  step_pattern using runBodyFrom_roundA (o := .kwh) (hk := hK 14 (by decide)) (hacc := hacc) inline
  name_acc hacc
  step_pattern using runBodyFrom_round15 (hk := hK 15 (by decide)) (hsch :=
    hWs 16 (by decide) (by decide)) (hacc := hacc) inline
  name_acc hacc
  step_pattern using runBodyFrom_roundS (o := .kwh) (hk := hK 16 (by decide)) (hsch :=
    hWs 17 (by decide) (by decide)) (hacc := hacc) inline
  name_acc hacc
  step_pattern using runBodyFrom_roundS (o := .kwh) (hk := hK 17 (by decide)) (hsch :=
    hWs 18 (by decide) (by decide)) (hacc := hacc) inline
  name_acc hacc
  step_pattern using runBodyFrom_roundS (o := .kwh) (hk := hK 18 (by decide)) (hsch :=
    hWs 19 (by decide) (by decide)) (hacc := hacc) inline
  name_acc hacc
  step_pattern using runBodyFrom_roundS (o := .kwh) (hk := hK 19 (by decide)) (hsch :=
    hWs 20 (by decide) (by decide)) (hacc := hacc) inline
  name_acc hacc
  with_reducible refine hcont _ _ _ _ _ _ _ _ _ hacc hArgs ?_ ?_ ?_
  · env_reads
  · env_reads
  · env_reads

-- twenty pattern sites in one declaration
set_option maxHeartbeats 1000000 in
/-- Rounds `20 … 39`, then on with `rounds Wf 40` and the registers live into round `40`. -/
public theorem rounds20 (st Kp En P : Pointer) (A : Vals compress512.Γ.args)
    (H : Vector (BitVec 64) 8) (Wf : Nat → BitVec 64) (a20 a19 a18 a17 e20 e19 e18 e17 : BitVec 64)
    (E : ⟪Γ⟫) (S : GlobalState) (g : Vals [] × GlobalState → PoisonOr β) (K : PoisonOr β)
    (hArgs : E.args = A.get) (hst : Statics st Kp En E) (hpar : Params P H E)
    (hlive : Live20 Wf a20 a19 a18 a17 e20 e19 e18 e17 E) (hKf : Fits S.mem Kp 5120)
    (hKo : Kp.offset = 0)
    (hK : ∀ t, t < 80 → S.mem.readAt (Kp.add (BitVec.ofNat 64 (8 * t))) 64 = Sha512.K[t]!)
    (hWs :
      ∀ t,
        16 ≤ t →
          t < 80 →
          Wf t =
            Sha512.sigma1 (Wf (t - 2)) + Wf (t - 7) + Sha512.sigma0 (Wf (t - 15)) + Wf (t - 16))
    (hacc :
      rounds Wf 20 #v[H[0], H[1], H[2], H[3], H[4], H[5], H[6], H[7]] =
        #v[a20, a19, a18, a17, e20, e19, e18, e17])
    (hcont :
      ∀ (E' : ⟪Γ⟫) (a40' a39' a38' a37' e40' e39' e38' e37' : BitVec 64),
        rounds Wf 40 #v[H[0], H[1], H[2], H[3], H[4], H[5], H[6], H[7]] =
            #v[a40', a39', a38', a37', e40', e39', e38', e37'] →
          E'.args = A.get →
          Statics st Kp En E' →
          Params P H E' →
          Live40 Wf a40' a39' a38' a37' e40' e39' e38' e37' E' → BODY E' 1423 S g = K) :
    BODY E 643 S g = K := by
  iterate 100 peel hst
  iterate 8 peel hpar
  iterate 26 peel hlive
  have hS : S = S := rfl
  step_pattern using runBodyFrom_roundS (o := .kwh) (hk := hK 20 (by decide)) (hsch :=
    hWs 21 (by decide) (by decide)) (hacc := hacc) inline
  name_acc hacc
  step_pattern using runBodyFrom_roundS (o := .kwh) (hk := hK 21 (by decide)) (hsch :=
    hWs 22 (by decide) (by decide)) (hacc := hacc) inline
  name_acc hacc
  step_pattern using runBodyFrom_roundS (o := .kwh) (hk := hK 22 (by decide)) (hsch :=
    hWs 23 (by decide) (by decide)) (hacc := hacc) inline
  name_acc hacc
  step_pattern using runBodyFrom_roundS (o := .kwh) (hk := hK 23 (by decide)) (hsch :=
    hWs 24 (by decide) (by decide)) (hacc := hacc) inline
  name_acc hacc
  step_pattern using runBodyFrom_roundS (o := .kwh) (hk := hK 24 (by decide)) (hsch :=
    hWs 25 (by decide) (by decide)) (hacc := hacc) inline
  name_acc hacc
  step_pattern using runBodyFrom_roundS (o := .kwh) (hk := hK 25 (by decide)) (hsch :=
    hWs 26 (by decide) (by decide)) (hacc := hacc) inline
  name_acc hacc
  step_pattern using runBodyFrom_roundS (o := .kwh) (hk := hK 26 (by decide)) (hsch :=
    hWs 27 (by decide) (by decide)) (hacc := hacc) inline
  name_acc hacc
  step_pattern using runBodyFrom_roundS (o := .kwh) (hk := hK 27 (by decide)) (hsch :=
    hWs 28 (by decide) (by decide)) (hacc := hacc) inline
  name_acc hacc
  step_pattern using runBodyFrom_roundS (o := .kwh) (hk := hK 28 (by decide)) (hsch :=
    hWs 29 (by decide) (by decide)) (hacc := hacc) inline
  name_acc hacc
  step_pattern using runBodyFrom_roundS (o := .kwh) (hk := hK 29 (by decide)) (hsch :=
    hWs 30 (by decide) (by decide)) (hacc := hacc) inline
  name_acc hacc
  step_pattern using runBodyFrom_roundS (o := .wkh) (hk := hK 30 (by decide)) (hsch :=
    hWs 31 (by decide) (by decide)) (hacc := hacc) inline
  name_acc hacc
  step_pattern using runBodyFrom_roundS (o := .wkh) (hk := hK 31 (by decide)) (hsch :=
    hWs 32 (by decide) (by decide)) (hacc := hacc) inline
  name_acc hacc
  step_pattern using runBodyFrom_roundS (o := .wkh) (hk := hK 32 (by decide)) (hsch :=
    hWs 33 (by decide) (by decide)) (hacc := hacc) inline
  name_acc hacc
  step_pattern using runBodyFrom_roundS (o := .wkh) (hk := hK 33 (by decide)) (hsch :=
    hWs 34 (by decide) (by decide)) (hacc := hacc) inline
  name_acc hacc
  step_pattern using runBodyFrom_roundS (o := .wkh) (hk := hK 34 (by decide)) (hsch :=
    hWs 35 (by decide) (by decide)) (hacc := hacc) inline
  name_acc hacc
  step_pattern using runBodyFrom_roundS (o := .wkh) (hk := hK 35 (by decide)) (hsch :=
    hWs 36 (by decide) (by decide)) (hacc := hacc) inline
  name_acc hacc
  step_pattern using runBodyFrom_roundS (o := .wkh) (hk := hK 36 (by decide)) (hsch :=
    hWs 37 (by decide) (by decide)) (hacc := hacc) inline
  name_acc hacc
  step_pattern using runBodyFrom_roundS (o := .wkh) (hk := hK 37 (by decide)) (hsch :=
    hWs 38 (by decide) (by decide)) (hacc := hacc) inline
  name_acc hacc
  step_pattern using runBodyFrom_roundS (o := .wkh) (hk := hK 38 (by decide)) (hsch :=
    hWs 39 (by decide) (by decide)) (hacc := hacc) inline
  name_acc hacc
  step_pattern using runBodyFrom_roundS (o := .wkh) (hk := hK 39 (by decide)) (hsch :=
    hWs 40 (by decide) (by decide)) (hacc := hacc) inline
  name_acc hacc
  with_reducible refine hcont _ _ _ _ _ _ _ _ _ hacc hArgs ?_ ?_ ?_
  · env_reads
  · env_reads
  · env_reads

-- twenty pattern sites in one declaration
set_option maxHeartbeats 1000000 in
/-- Rounds `40 … 59`, then on with `rounds Wf 60` and the registers live into round `60`. -/
public theorem rounds40 (st Kp En P : Pointer) (A : Vals compress512.Γ.args)
    (H : Vector (BitVec 64) 8) (Wf : Nat → BitVec 64) (a40 a39 a38 a37 e40 e39 e38 e37 : BitVec 64)
    (E : ⟪Γ⟫) (S : GlobalState) (g : Vals [] × GlobalState → PoisonOr β) (K : PoisonOr β)
    (hArgs : E.args = A.get) (hst : Statics st Kp En E) (hpar : Params P H E)
    (hlive : Live40 Wf a40 a39 a38 a37 e40 e39 e38 e37 E) (hKf : Fits S.mem Kp 5120)
    (hKo : Kp.offset = 0)
    (hK : ∀ t, t < 80 → S.mem.readAt (Kp.add (BitVec.ofNat 64 (8 * t))) 64 = Sha512.K[t]!)
    (hWs :
      ∀ t,
        16 ≤ t →
          t < 80 →
          Wf t =
            Sha512.sigma1 (Wf (t - 2)) + Wf (t - 7) + Sha512.sigma0 (Wf (t - 15)) + Wf (t - 16))
    (hacc :
      rounds Wf 40 #v[H[0], H[1], H[2], H[3], H[4], H[5], H[6], H[7]] =
        #v[a40, a39, a38, a37, e40, e39, e38, e37])
    (hcont :
      ∀ (E' : ⟪Γ⟫) (a60' a59' a58' a57' e60' e59' e58' e57' : BitVec 64),
        rounds Wf 60 #v[H[0], H[1], H[2], H[3], H[4], H[5], H[6], H[7]] =
            #v[a60', a59', a58', a57', e60', e59', e58', e57'] →
          E'.args = A.get →
          Statics st Kp En E' →
          Params P H E' →
          Live60 Wf a60' a59' a58' a57' e60' e59' e58' e57' E' → BODY E' 2203 S g = K) :
    BODY E 1423 S g = K := by
  iterate 100 peel hst
  iterate 8 peel hpar
  iterate 26 peel hlive
  have hS : S = S := rfl
  step_pattern using runBodyFrom_roundS (o := .wkh) (hk := hK 40 (by decide)) (hsch :=
    hWs 41 (by decide) (by decide)) (hacc := hacc) inline
  name_acc hacc
  step_pattern using runBodyFrom_roundS (o := .wkh) (hk := hK 41 (by decide)) (hsch :=
    hWs 42 (by decide) (by decide)) (hacc := hacc) inline
  name_acc hacc
  step_pattern using runBodyFrom_roundS (o := .wkh) (hk := hK 42 (by decide)) (hsch :=
    hWs 43 (by decide) (by decide)) (hacc := hacc) inline
  name_acc hacc
  step_pattern using runBodyFrom_roundS (o := .wkh) (hk := hK 43 (by decide)) (hsch :=
    hWs 44 (by decide) (by decide)) (hacc := hacc) inline
  name_acc hacc
  step_pattern using runBodyFrom_roundS (o := .wkh) (hk := hK 44 (by decide)) (hsch :=
    hWs 45 (by decide) (by decide)) (hacc := hacc) inline
  name_acc hacc
  step_pattern using runBodyFrom_roundS (o := .wkh) (hk := hK 45 (by decide)) (hsch :=
    hWs 46 (by decide) (by decide)) (hacc := hacc) inline
  name_acc hacc
  step_pattern using runBodyFrom_roundS (o := .wkh) (hk := hK 46 (by decide)) (hsch :=
    hWs 47 (by decide) (by decide)) (hacc := hacc) inline
  name_acc hacc
  step_pattern using runBodyFrom_roundS (o := .wkh) (hk := hK 47 (by decide)) (hsch :=
    hWs 48 (by decide) (by decide)) (hacc := hacc) inline
  name_acc hacc
  step_pattern using runBodyFrom_roundS (o := .wkh) (hk := hK 48 (by decide)) (hsch :=
    hWs 49 (by decide) (by decide)) (hacc := hacc) inline
  name_acc hacc
  step_pattern using runBodyFrom_roundS (o := .wkh) (hk := hK 49 (by decide)) (hsch :=
    hWs 50 (by decide) (by decide)) (hacc := hacc) inline
  name_acc hacc
  step_pattern using runBodyFrom_roundS (o := .wkh) (hk := hK 50 (by decide)) (hsch :=
    hWs 51 (by decide) (by decide)) (hacc := hacc) inline
  name_acc hacc
  step_pattern using runBodyFrom_roundS (o := .wkh) (hk := hK 51 (by decide)) (hsch :=
    hWs 52 (by decide) (by decide)) (hacc := hacc) inline
  name_acc hacc
  step_pattern using runBodyFrom_roundS (o := .wkh) (hk := hK 52 (by decide)) (hsch :=
    hWs 53 (by decide) (by decide)) (hacc := hacc) inline
  name_acc hacc
  step_pattern using runBodyFrom_roundS (o := .wkh) (hk := hK 53 (by decide)) (hsch :=
    hWs 54 (by decide) (by decide)) (hacc := hacc) inline
  name_acc hacc
  step_pattern using runBodyFrom_roundS (o := .wkh) (hk := hK 54 (by decide)) (hsch :=
    hWs 55 (by decide) (by decide)) (hacc := hacc) inline
  name_acc hacc
  step_pattern using runBodyFrom_roundS (o := .wkh) (hk := hK 55 (by decide)) (hsch :=
    hWs 56 (by decide) (by decide)) (hacc := hacc) inline
  name_acc hacc
  step_pattern using runBodyFrom_roundS (o := .wkh) (hk := hK 56 (by decide)) (hsch :=
    hWs 57 (by decide) (by decide)) (hacc := hacc) inline
  name_acc hacc
  step_pattern using runBodyFrom_roundS (o := .wkh) (hk := hK 57 (by decide)) (hsch :=
    hWs 58 (by decide) (by decide)) (hacc := hacc) inline
  name_acc hacc
  step_pattern using runBodyFrom_roundS (o := .wkh) (hk := hK 58 (by decide)) (hsch :=
    hWs 59 (by decide) (by decide)) (hacc := hacc) inline
  name_acc hacc
  step_pattern using runBodyFrom_roundS (o := .wkh) (hk := hK 59 (by decide)) (hsch :=
    hWs 60 (by decide) (by decide)) (hacc := hacc) inline
  name_acc hacc
  with_reducible refine hcont _ _ _ _ _ _ _ _ _ hacc hArgs ?_ ?_ ?_
  · env_reads
  · env_reads
  · env_reads

-- twenty pattern sites in one declaration
set_option maxHeartbeats 1000000 in
/-- Rounds `60 … 79` and the state words' sums, then on to the exit with the new words `N`. -/
public theorem rounds60 (st Kp En P : Pointer) (A : Vals compress512.Γ.args)
    (H : Vector (BitVec 64) 8) (Wf : Nat → BitVec 64) (a60 a59 a58 a57 e60 e59 e58 e57 : BitVec 64)
    (E : ⟪Γ⟫) (S : GlobalState) (g : Vals [] × GlobalState → PoisonOr β) (K : PoisonOr β)
    (hArgs : E.args = A.get) (hst : Statics st Kp En E) (hpar : Params P H E)
    (hlive : Live60 Wf a60 a59 a58 a57 e60 e59 e58 e57 E) (hKf : Fits S.mem Kp 5120)
    (hKo : Kp.offset = 0)
    (hK : ∀ t, t < 80 → S.mem.readAt (Kp.add (BitVec.ofNat 64 (8 * t))) 64 = Sha512.K[t]!)
    (hWs :
      ∀ t,
        16 ≤ t →
          t < 80 →
          Wf t =
            Sha512.sigma1 (Wf (t - 2)) + Wf (t - 7) + Sha512.sigma0 (Wf (t - 15)) + Wf (t - 16))
    (hacc :
      rounds Wf 60 #v[H[0], H[1], H[2], H[3], H[4], H[5], H[6], H[7]] =
        #v[a60, a59, a58, a57, e60, e59, e58, e57])
    (hcont :
      ∀ (E' : ⟪Γ⟫) (N : Vector (BitVec 64) 8),
        N =
            Vector.zipWith (· + ·) #v[H[0], H[1], H[2], H[3], H[4], H[5], H[6], H[7]]
              (rounds Wf 80 #v[H[0], H[1], H[2], H[3], H[4], H[5], H[6], H[7]]) →
          E'.args = A.get →
          Statics st Kp En E' →
          (E' ⊨ [%2500 := P.add 128#64, rir_reg% compress512.hty 3078 := N[0],
            rir_reg% compress512.hty 3079 := N[1], rir_reg% compress512.hty 3080 := N[2],
            rir_reg% compress512.hty 3081 := N[3], rir_reg% compress512.hty 3083 := N[4],
            rir_reg% compress512.hty 3084 := N[5], rir_reg% compress512.hty 3085 := N[6],
            rir_reg% compress512.hty 3086 := N[7], rir_reg% compress512.hty 3087 :=
            BitVec.ofBool (P.add 128#64 == En)]) →
          BODY E' 2969 S g = K) :
    BODY E 2203 S g = K := by
  iterate 100 peel hst
  iterate 8 peel hpar
  iterate 26 peel hlive
  have hS : S = S := rfl
  step_pattern using runBodyFrom_roundS (o := .wkh) (hk := hK 60 (by decide)) (hsch :=
    hWs 61 (by decide) (by decide)) (hacc := hacc) inline
  name_acc hacc
  step_pattern using runBodyFrom_roundS (o := .wkh) (hk := hK 61 (by decide)) (hsch :=
    hWs 62 (by decide) (by decide)) (hacc := hacc) inline
  name_acc hacc
  step_pattern using runBodyFrom_roundS (o := .wkh) (hk := hK 62 (by decide)) (hsch :=
    hWs 63 (by decide) (by decide)) (hacc := hacc) inline
  name_acc hacc
  step_pattern using runBodyFrom_roundS (o := .wkh) (hk := hK 63 (by decide)) (hsch :=
    hWs 64 (by decide) (by decide)) (hacc := hacc) inline
  name_acc hacc
  step_pattern using runBodyFrom_roundS (o := .wkh) (hk := hK 64 (by decide)) (hsch :=
    hWs 65 (by decide) (by decide)) (hacc := hacc) inline
  name_acc hacc
  step_pattern using runBodyFrom_roundS (o := .wkh) (hk := hK 65 (by decide)) (hsch :=
    hWs 66 (by decide) (by decide)) (hacc := hacc) inline
  name_acc hacc
  step_pattern using runBodyFrom_roundS (o := .wkh) (hk := hK 66 (by decide)) (hsch :=
    hWs 67 (by decide) (by decide)) (hacc := hacc) inline
  name_acc hacc
  step_pattern using runBodyFrom_roundS (o := .wkh) (hk := hK 67 (by decide)) (hsch :=
    hWs 68 (by decide) (by decide)) (hacc := hacc) inline
  name_acc hacc
  step_pattern using runBodyFrom_roundS (o := .wkh) (hk := hK 68 (by decide)) (hsch :=
    hWs 69 (by decide) (by decide)) (hacc := hacc) inline
  name_acc hacc
  step_pattern using runBodyFrom_roundS (o := .wkh) (hk := hK 69 (by decide)) (hsch :=
    hWs 70 (by decide) (by decide)) (hacc := hacc) inline
  name_acc hacc
  step_pattern using runBodyFrom_roundS (o := .wkh) (hk := hK 70 (by decide)) (hsch :=
    hWs 71 (by decide) (by decide)) (hacc := hacc) inline
  name_acc hacc
  step_pattern using runBodyFrom_roundS (o := .wkh) (hk := hK 71 (by decide)) (hsch :=
    hWs 72 (by decide) (by decide)) (hacc := hacc) inline
  name_acc hacc
  step_pattern using runBodyFrom_roundS (o := .wkh) (hk := hK 72 (by decide)) (hsch :=
    hWs 73 (by decide) (by decide)) (hacc := hacc) inline
  name_acc hacc
  step_pattern using runBodyFrom_roundS (o := .wkh) (hk := hK 73 (by decide)) (hsch :=
    hWs 74 (by decide) (by decide)) (hacc := hacc) inline
  name_acc hacc
  step_pattern using runBodyFrom_roundS (o := .wkh) (hk := hK 74 (by decide)) (hsch :=
    hWs 75 (by decide) (by decide)) (hacc := hacc) inline
  name_acc hacc
  step_pattern using runBodyFrom_roundS (o := .wkh) (hk := hK 75 (by decide)) (hsch :=
    hWs 76 (by decide) (by decide)) (hacc := hacc) inline
  name_acc hacc
  step_pattern using runBodyFrom_roundS (o := .wkh) (hk := hK 76 (by decide)) (hsch :=
    hWs 77 (by decide) (by decide)) (hacc := hacc) inline
  name_acc hacc
  step_pattern using runBodyFrom_round77 (hk := hK 77 (by decide)) (hacc := hacc) inline
  name_acc hacc
  step_pattern using runBodyFrom_round78 (hk := hK 78 (by decide)) (hsch :=
    hWs 78 (by decide) (by decide)) (hacc := hacc) inline
  name_acc hacc
  step_pattern using runBodyFrom_round79 (hk := hK 79 (by decide)) (hsch :=
    hWs 79 (by decide) (by decide)) (hacc := hacc) inline
  name_acc hacc
  step_pure
  with_reducible refine hcont _ _ hacc hArgs ?_ ?_
  · env_reads
  · env_reads

/-- `^bb1`'s exit, on the next block's pointer: to `^bb2` with the new state words `N` at the end
`En`, else back to `^bb1` on them. -/
public theorem exit_eq (En P : Pointer) (N : Vector (BitVec 64) 8) (E : ⟪Γ⟫) (S : GlobalState)
    (g : Vals [] × GlobalState → PoisonOr β) (K : PoisonOr β)
    (hR :
      E ⊨ [%2500 := P.add 128#64, rir_reg% compress512.hty 3078 := N[0],
        rir_reg% compress512.hty 3079 := N[1], rir_reg% compress512.hty 3080 := N[2],
        rir_reg% compress512.hty 3081 := N[3], rir_reg% compress512.hty 3083 := N[4],
        rir_reg% compress512.hty 3084 := N[5], rir_reg% compress512.hty 3085 := N[6],
        rir_reg% compress512.hty 3086 := N[7], rir_reg% compress512.hty 3087 :=
        BitVec.ofBool (P.add 128#64 == En)])
    (h2 :
      P.add 128#64 = En →
        (compress512.runFrom
              E[rir_dst% compress512.hty 3088 := .value N[0], rir_dst% compress512.hty 3089 :=
                .value N[1], rir_dst% compress512.hty 3090 := .value N[2],
                rir_dst% compress512.hty 3091 := .value N[3], rir_dst% compress512.hty 3092 :=
                .value N[4], rir_dst% compress512.hty 3093 := .value N[5],
                rir_dst% compress512.hty 3094 := .value N[6], rir_dst% compress512.hty 3095 :=
                .value N[7]]
              2 S >>=
            g) =
          K)
    (h1 : P.add 128#64 ≠ En → (compress512.runFrom (hdr (P.add 128#64) N E) 1 S >>= g) = K) :
    BODY E 2969 S g = K := by
  finish_block
  · subst hE
    exact h2 hbr
  · subst hE
    exact h1 hbr

end Proof

end compress512

end MLIR.Agave.Serial
