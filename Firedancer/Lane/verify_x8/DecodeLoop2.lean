module

public import Firedancer.Lane.verify_x8.DecodeRuns
public import Firedancer.Lane.Common.Tactics

/-! `^bb41`, an iteration of `fd_ed25519_lane_decode2`'s second loop. -/

namespace MLIR.Firedancer.Lane.VerifyX8.Decode

open Firedancer.Avx512 Firedancer.Ref
open _root_.Firedancer.Lane.Mlir (verify_x8)
open _root_.Firedancer.Lane.Mlir.verify_x8 (Γ hty)

attribute [-mlir_operation] zipWith_eq_ofFn Operation.vpmadd52l Operation.vpmadd52h

attribute [local mlir_operation] vpmadd52l_wwl vpmadd52h_wwl zipWith_add_wwl zipWith_sub_wwl
  zipWith_and_wwl zipWith_mul_wwl zipWith_shl_wwl zipWith_lshr_wwl

attribute [local mlir_operation] zipWith_mul_shru19 zipWith_add_mul19_mask zipWith_icmp_eq_wwl
  zipWith_icmp_ugt_wwl zipWith_and_i1 zipWith_or_i1 zipWith_or_wwl

public section

variable {β : Type}

/-- `^bb41`'s loads: `r[n]`, its `x`, `u v³`. -/
theorem bb41_L0 {S : GlobalState} {E : ⟪Γ⟫} {G : ⟪Γ⟫ × GlobalState → PoisonOr β}
    {K : PoisonOr β} (rp P u3p : Pointer) (X0 U3 : Fe)
    (hR :
      E ⊨ [rir_reg% hty 1281 := PoisonOr.value u3p, rir_reg% hty 1284 := PoisonOr.value rp])
    (hrp : InBounds S.mem rp 64) (hrpr : S.mem.loadPtr rp = .value P)
    (hPo : ¬P.offset.uaddOverflow 320#64)
    (hP : Fits S.mem P 2560) (hxr : S.mem.readFe P = X0) (hu3po : ¬u3p.offset.uaddOverflow 320#64)
    (hu3 : Fits S.mem u3p 2560) (hu3r : S.mem.readFe u3p = U3)
    (hK :
      ∀ (v1296 : ⟦.ptr⟧) (v1298 : ⟦.ptr⟧) (v1300 : ⟦.ptr⟧) (v1302 : ⟦.ptr⟧),
        (verify_x8.bb41.runBodyFrom E[rir_dst% hty 1285 := PoisonOr.value P,
          rir_dst% hty 1286 := Ty.wrap X0.l0, rir_dst% hty 1287 := PoisonOr.value (P.add 64#64),
          rir_dst% hty 1288 := Ty.wrap X0.l1, rir_dst% hty 1289 := PoisonOr.value (P.add 128#64),
          rir_dst% hty 1290 := Ty.wrap X0.l2, rir_dst% hty 1291 := PoisonOr.value (P.add 192#64),
          rir_dst% hty 1292 := Ty.wrap X0.l3, rir_dst% hty 1293 := PoisonOr.value (P.add 256#64),
          rir_dst% hty 1294 := Ty.wrap X0.l4, rir_dst% hty 1295 := Ty.wrap U3.l0,
          rir_dst% hty 1296 := v1296, rir_dst% hty 1297 := Ty.wrap U3.l1,
          rir_dst% hty 1298 := v1298, rir_dst% hty 1299 := Ty.wrap U3.l2,
          rir_dst% hty 1300 := v1300, rir_dst% hty 1301 := Ty.wrap U3.l3,
          rir_dst% hty 1302 := v1302, rir_dst% hty 1303 := Ty.wrap U3.l4] 19 S >>= G) = K) :
    (verify_x8.bb41.runBodyFrom E 0 S >>= G) = K := by
  split_env hR
  have hPin := hP.inBounds
  have hu3pin := hu3.inBounds
  step_load
  step_load [vec_readFe_l0] inline
  step_pure
  step_load inline
  step_pure
  step_load inline
  step_pure
  step_load inline
  step_pure
  step_load inline
  step_load [vec_readFe_l0] inline
  step_pure
  step_load inline
  step_pure
  step_load inline
  step_pure
  step_load inline
  step_pure
  step_load inline
  subst hS
  simp only
      [vec_readFe_l1 hPin hPo, vec_readFe_l2 hPin hPo, vec_readFe_l3 hPin hPo,
      vec_readFe_l4 hPin hPo, vec_readFe_l1 hu3pin hu3po, vec_readFe_l2 hu3pin hu3po,
      vec_readFe_l3 hu3pin hu3po, vec_readFe_l4 hu3pin hu3po, hxr, hu3r] at hE
  rw [hE]
  exact hK _ _ _ _

/-- `^bb41`'s loads of `v`. -/
theorem bb41_V {S : GlobalState} {E : ⟪Γ⟫} {G : ⟪Γ⟫ × GlobalState → PoisonOr β}
    {K : PoisonOr β} (vp : Pointer) (V : Fe)
    (hR :
      E ⊨ [rir_reg% hty 1282 := PoisonOr.value vp])
    (hvo : ¬vp.offset.uaddOverflow 320#64) (hv : Fits S.mem vp 2560) (hvr : S.mem.readFe vp = V)
    (hK :
      ∀ (v1453 : ⟦.ptr⟧) (v1455 : ⟦.ptr⟧) (v1457 : ⟦.ptr⟧) (v1459 : ⟦.ptr⟧),
        (verify_x8.bb41.runBodyFrom E[rir_dst% hty 1452 := Ty.wrap V.l0, rir_dst% hty 1453 := v1453,
          rir_dst% hty 1454 := Ty.wrap V.l1, rir_dst% hty 1455 := v1455,
          rir_dst% hty 1456 := Ty.wrap V.l2, rir_dst% hty 1457 := v1457,
          rir_dst% hty 1458 := Ty.wrap V.l3, rir_dst% hty 1459 := v1459,
          rir_dst% hty 1460 := Ty.wrap V.l4] 181 S >>= G) = K) :
    (verify_x8.bb41.runBodyFrom E 172 S >>= G) = K := by
  split_env hR
  have hvin := hv.inBounds
  step_load [vec_readFe_l0] inline
  step_pure
  step_load inline
  step_pure
  step_load inline
  step_pure
  step_load inline
  step_pure
  step_load inline
  subst hS
  simp only
      [vec_readFe_l1 hvin hvo, vec_readFe_l2 hvin hvo, vec_readFe_l3 hvin hvo,
      vec_readFe_l4 hvin hvo, hvr] at hE
  rw [hE]
  exact hK _ _ _ _

-- 110 steps in one declaration
set_option maxHeartbeats 1000000 in
/-- `^bb41`'s zero tests: `fd_ed25519_lane_is_zero` of `check - u` and of `check + u`. -/
theorem bb41_Z {S : GlobalState} {E : ⟪Γ⟫} {G : ⟪Γ⟫ × GlobalState → PoisonOr β}
    {K : PoisonOr β} (up : Pointer) (C W U : Fe) (hCW : C = carry W)
    (hC :
      E ⊨ [%94 := Ty.wrap (Vector.replicate 8 0#64),
        %96 := Ty.wrap (Vector.replicate 8 2251799813685247#64),
        %103 := Ty.wrap (Vector.replicate 8 19#64), %104 := Ty.wrap (Vector.replicate 8 51#64),
        %108 := Ty.wrap (Vector.replicate 8 4503599627370458#64),
        %109 := Ty.wrap (Vector.replicate 8 4503599627370494#64),
        %110 := Ty.wrap (Vector.replicate 8 2251799813685229#64)])
    (hR :
      E ⊨ [rir_reg% hty 1283 := PoisonOr.value up, rir_reg% hty 1534 := Ty.wrap C.l0,
        rir_reg% hty 1536 := Ty.wrap C.l1, rir_reg% hty 1538 := Ty.wrap C.l2,
        rir_reg% hty 1540 := Ty.wrap C.l3, rir_reg% hty 1542 := Ty.wrap C.l4])
    (huo : ¬up.offset.uaddOverflow 320#64) (hu : Fits S.mem up 2560) (hur : S.mem.readFe up = U)
    (hK :
      ∀ (v1543 : ⟦.vec 8 64⟧) (v1544 : ⟦.vec 8 64⟧) (v1545 : ⟦.vec 8 64⟧) (v1546 : ⟦.vec 8 64⟧)
        (v1547 : ⟦.ptr⟧) (v1548 : ⟦.vec 8 64⟧) (v1549 : ⟦.vec 8 64⟧) (v1550 : ⟦.vec 8 64⟧)
        (v1551 : ⟦.ptr⟧) (v1552 : ⟦.vec 8 64⟧) (v1553 : ⟦.vec 8 64⟧) (v1554 : ⟦.vec 8 64⟧)
        (v1555 : ⟦.ptr⟧) (v1556 : ⟦.vec 8 64⟧) (v1557 : ⟦.vec 8 64⟧) (v1558 : ⟦.vec 8 64⟧)
        (v1559 : ⟦.ptr⟧) (v1560 : ⟦.vec 8 64⟧) (v1561 : ⟦.vec 8 64⟧) (v1562 : ⟦.vec 8 64⟧)
        (v1563 : ⟦.vec 8 64⟧) (v1564 : ⟦.vec 8 64⟧) (v1565 : ⟦.vec 8 64⟧) (v1566 : ⟦.vec 8 64⟧)
        (v1567 : ⟦.vec 8 64⟧) (v1568 : ⟦.vec 8 64⟧) (v1569 : ⟦.vec 8 64⟧) (v1570 : ⟦.vec 8 64⟧)
        (v1571 : ⟦.vec 8 64⟧) (v1572 : ⟦.vec 8 64⟧) (v1573 : ⟦.vec 8 64⟧) (v1574 : ⟦.vec 8 64⟧)
        (v1575 : ⟦.vec 8 64⟧) (v1576 : ⟦.vec 8 64⟧) (v1577 : ⟦.vec 8 64⟧) (v1578 : ⟦.vec 8 64⟧)
        (v1579 : ⟦.vec 8 64⟧) (v1580 : ⟦.vec 8 64⟧) (v1581 : ⟦.vec 8 64⟧) (v1582 : ⟦.vec 8 64⟧)
        (v1583 : ⟦.vec 8 64⟧) (v1584 : ⟦.vec 8 64⟧) (v1585 : ⟦.vec 8 64⟧) (v1586 : ⟦.vec 8 64⟧)
        (v1587 : ⟦.vec 8 64⟧) (v1588 : ⟦.vec 8 64⟧) (v1589 : ⟦.vec 8 64⟧) (v1590 : ⟦.vec 8 64⟧)
        (v1591 : ⟦.vec 8 64⟧) (v1592 : ⟦.vec 8 64⟧) (v1593 : ⟦.vec 8 64⟧) (v1594 : ⟦.vec 8 64⟧)
        (v1595 : ⟦.vec 8 1⟧) (v1596 : ⟦.vec 8 64⟧) (v1597 : ⟦.vec 8 64⟧) (v1598 : ⟦.vec 8 64⟧)
        (v1599 : ⟦.vec 8 64⟧) (v1600 : ⟦.vec 8 64⟧) (v1601 : ⟦.vec 8 1⟧) (v1602 : ⟦.vec 8 64⟧)
        (v1603 : ⟦.vec 8 64⟧) (v1604 : ⟦.vec 8 64⟧) (v1605 : ⟦.vec 8 64⟧) (v1606 : ⟦.vec 8 1⟧)
        (v1607 : ⟦.vec 8 1⟧) (v1608 : ⟦.vec 8 1⟧) (v1610 : ⟦.vec 8 64⟧) (v1611 : ⟦.vec 8 64⟧)
        (v1612 : ⟦.vec 8 64⟧) (v1613 : ⟦.vec 8 64⟧) (v1614 : ⟦.vec 8 64⟧) (v1615 : ⟦.vec 8 64⟧)
        (v1616 : ⟦.vec 8 64⟧) (v1617 : ⟦.vec 8 64⟧) (v1618 : ⟦.vec 8 64⟧) (v1619 : ⟦.vec 8 64⟧)
        (v1620 : ⟦.vec 8 64⟧) (v1621 : ⟦.vec 8 64⟧) (v1622 : ⟦.vec 8 64⟧) (v1623 : ⟦.vec 8 64⟧)
        (v1624 : ⟦.vec 8 64⟧) (v1625 : ⟦.vec 8 64⟧) (v1626 : ⟦.vec 8 64⟧) (v1627 : ⟦.vec 8 64⟧)
        (v1628 : ⟦.vec 8 64⟧) (v1629 : ⟦.vec 8 64⟧) (v1630 : ⟦.vec 8 64⟧) (v1631 : ⟦.vec 8 64⟧)
        (v1632 : ⟦.vec 8 64⟧) (v1633 : ⟦.vec 8 64⟧) (v1634 : ⟦.vec 8 64⟧) (v1635 : ⟦.vec 8 64⟧)
        (v1636 : ⟦.vec 8 64⟧) (v1637 : ⟦.vec 8 64⟧) (v1638 : ⟦.vec 8 1⟧) (v1639 : ⟦.vec 8 64⟧)
        (v1640 : ⟦.vec 8 64⟧) (v1641 : ⟦.vec 8 64⟧) (v1642 : ⟦.vec 8 64⟧) (v1643 : ⟦.vec 8 64⟧)
        (v1644 : ⟦.vec 8 1⟧) (v1645 : ⟦.vec 8 64⟧) (v1646 : ⟦.vec 8 64⟧) (v1647 : ⟦.vec 8 64⟧)
        (v1648 : ⟦.vec 8 64⟧) (v1649 : ⟦.vec 8 1⟧) (v1650 : ⟦.vec 8 1⟧) (v1651 : ⟦.vec 8 1⟧),
        (verify_x8.bb41.runBodyFrom E[rir_dst% hty 1543 := v1543, rir_dst% hty 1544 := v1544,
          rir_dst% hty 1545 := v1545, rir_dst% hty 1546 := v1546, rir_dst% hty 1547 := v1547,
          rir_dst% hty 1548 := v1548, rir_dst% hty 1549 := v1549, rir_dst% hty 1550 := v1550,
          rir_dst% hty 1551 := v1551, rir_dst% hty 1552 := v1552, rir_dst% hty 1553 := v1553,
          rir_dst% hty 1554 := v1554, rir_dst% hty 1555 := v1555, rir_dst% hty 1556 := v1556,
          rir_dst% hty 1557 := v1557, rir_dst% hty 1558 := v1558, rir_dst% hty 1559 := v1559,
          rir_dst% hty 1560 := v1560, rir_dst% hty 1561 := v1561, rir_dst% hty 1562 := v1562,
          rir_dst% hty 1563 := v1563, rir_dst% hty 1564 := v1564, rir_dst% hty 1565 := v1565,
          rir_dst% hty 1566 := v1566, rir_dst% hty 1567 := v1567][rir_dst% hty 1568 := v1568,
          rir_dst% hty 1569 := v1569, rir_dst% hty 1570 := v1570, rir_dst% hty 1571 := v1571,
          rir_dst% hty 1572 := v1572, rir_dst% hty 1573 := v1573, rir_dst% hty 1574 := v1574,
          rir_dst% hty 1575 := v1575, rir_dst% hty 1576 := v1576, rir_dst% hty 1577 := v1577,
          rir_dst% hty 1578 := v1578, rir_dst% hty 1579 := v1579, rir_dst% hty 1580 := v1580,
          rir_dst% hty 1581 := v1581, rir_dst% hty 1582 := v1582, rir_dst% hty 1583 := v1583,
          rir_dst% hty 1584 := v1584, rir_dst% hty 1585 := v1585, rir_dst% hty 1586 := v1586,
          rir_dst% hty 1587 := v1587, rir_dst% hty 1588 := v1588, rir_dst% hty 1589 := v1589,
          rir_dst% hty 1590 := v1590, rir_dst% hty 1591 := v1591,
          rir_dst% hty 1592 := v1592][rir_dst% hty 1593 := v1593, rir_dst% hty 1594 := v1594,
          rir_dst% hty 1595 := v1595, rir_dst% hty 1596 := v1596, rir_dst% hty 1597 := v1597,
          rir_dst% hty 1598 := v1598, rir_dst% hty 1599 := v1599, rir_dst% hty 1600 := v1600,
          rir_dst% hty 1601 := v1601, rir_dst% hty 1602 := v1602, rir_dst% hty 1603 := v1603,
          rir_dst% hty 1604 := v1604, rir_dst% hty 1605 := v1605, rir_dst% hty 1606 := v1606,
          rir_dst% hty 1607 := v1607, rir_dst% hty 1608 := v1608,
          rir_dst% hty 1609 := PoisonOr.value (z8 (isZero (subRaw C U))),
          rir_dst% hty 1610 := v1610, rir_dst% hty 1611 := v1611, rir_dst% hty 1612 := v1612,
          rir_dst% hty 1613 := v1613, rir_dst% hty 1614 := v1614, rir_dst% hty 1615 := v1615,
          rir_dst% hty 1616 := v1616, rir_dst% hty 1617 := v1617][rir_dst% hty 1618 := v1618,
          rir_dst% hty 1619 := v1619, rir_dst% hty 1620 := v1620, rir_dst% hty 1621 := v1621,
          rir_dst% hty 1622 := v1622, rir_dst% hty 1623 := v1623, rir_dst% hty 1624 := v1624,
          rir_dst% hty 1625 := v1625, rir_dst% hty 1626 := v1626, rir_dst% hty 1627 := v1627,
          rir_dst% hty 1628 := v1628, rir_dst% hty 1629 := v1629, rir_dst% hty 1630 := v1630,
          rir_dst% hty 1631 := v1631, rir_dst% hty 1632 := v1632, rir_dst% hty 1633 := v1633,
          rir_dst% hty 1634 := v1634, rir_dst% hty 1635 := v1635, rir_dst% hty 1636 := v1636,
          rir_dst% hty 1637 := v1637, rir_dst% hty 1638 := v1638, rir_dst% hty 1639 := v1639,
          rir_dst% hty 1640 := v1640, rir_dst% hty 1641 := v1641,
          rir_dst% hty 1642 := v1642][rir_dst% hty 1643 := v1643, rir_dst% hty 1644 := v1644,
          rir_dst% hty 1645 := v1645, rir_dst% hty 1646 := v1646, rir_dst% hty 1647 := v1647,
          rir_dst% hty 1648 := v1648, rir_dst% hty 1649 := v1649, rir_dst% hty 1650 := v1650,
          rir_dst% hty 1651 := v1651,
          rir_dst% hty 1652 := PoisonOr.value (z8 (isZero (addRaw C U)))] 373 S >>= G) = K) :
    (verify_x8.bb41.runBodyFrom E 263 S >>= G) = K := by
  subst hCW
  split_env hC hR
  obtain ⟨hf0, hr0⟩ := fe_limb hu huo hur (o := 0#64) 0 (by decide)
  obtain ⟨hf1, hr1⟩ := fe_limb hu huo hur (o := 64#64) 1 (by decide)
  obtain ⟨hf2, hr2⟩ := fe_limb hu huo hur (o := 128#64) 2 (by decide)
  obtain ⟨hf3, hr3⟩ := fe_limb hu huo hur (o := 192#64) 3 (by decide)
  obtain ⟨hf4, hr4⟩ := fe_limb hu huo hur (o := 256#64) 4 (by decide)
  simp only [Fe.limb, Pointer.add_zero] at hf0 hr0 hr1 hr2 hr3 hr4
  clear hu hur

  step_pure
  step_load
  iterate 3 step_pure
  step_load
  iterate 3 step_pure
  step_load
  iterate 3 step_pure
  step_load
  iterate 3 step_pure
  step_load
  iterate 47 step_pure
  step_pure with zc
  iterate 42 step_pure
  step_pure with zf
  step_pure
  have hzc' : zc = Vector.ofFn fun i => BitVec.ofBool
      ((isZero (subRaw (carry W) U)).getLsbD i) := by
    refine hzc.trans ((zeroTest_compiled _ _ _ _ _).trans ?_)
    rw [isZero_eq, subRaw_eq, normalize_compiled]
  have hzf' : zf = Vector.ofFn fun i => BitVec.ofBool
      ((isZero (addRaw (carry W) U)).getLsbD i) := by
    refine hzf.trans ((zeroTest_compiled _ _ _ _ _).trans ?_)
    rw [isZero_eq, addRaw_comm, normalize_compiled]
  clear hzc hzf
  subst hzc' hzf'
  rw [z8_eq, z8_eq] at hE
  subst hS
  rw [hE]
  exact hK _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
      _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
      _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _

/-- `^bb41`'s choice of `x` or `x √-1`, its parity, its negation and the sign. -/
theorem bb41_F1 {S : GlobalState} {E : ⟪Γ⟫} {G : ⟪Γ⟫ × GlobalState → PoisonOr β}
    {K : PoisonOr β} (sp : Pointer) (X M : Fe) (c f sg : BitVec 32) (hX : Carried X)
    (hM : Carried M)
    (hC :
      E ⊨ [%94 := Ty.wrap (Vector.replicate 8 0#64), %95 := Ty.wrap (Vector.replicate 8 1#64),
        %96 := Ty.wrap (Vector.replicate 8 2251799813685247#64),
        %103 := Ty.wrap (Vector.replicate 8 19#64), %104 := Ty.wrap (Vector.replicate 8 51#64),
        %108 := Ty.wrap (Vector.replicate 8 4503599627370458#64),
        %109 := Ty.wrap (Vector.replicate 8 4503599627370494#64), %111 := PoisonOr.value 255#8,
        %112 := Ty.wrap (Vector.replicate 8 2251799813685228#64)])
    (hR :
      E ⊨ [rir_reg% hty 1280 := PoisonOr.value sp, rir_reg% hty 1377 := Ty.wrap X.l0,
        rir_reg% hty 1379 := Ty.wrap X.l1, rir_reg% hty 1381 := Ty.wrap X.l2,
        rir_reg% hty 1383 := Ty.wrap X.l3, rir_reg% hty 1385 := Ty.wrap X.l4,
        rir_reg% hty 1726 := Ty.wrap M.l0, rir_reg% hty 1728 := Ty.wrap M.l1,
        rir_reg% hty 1730 := Ty.wrap M.l2, rir_reg% hty 1732 := Ty.wrap M.l3,
        rir_reg% hty 1734 := Ty.wrap M.l4, rir_reg% hty 1609 := PoisonOr.value (z8 c),
        rir_reg% hty 1652 := PoisonOr.value (z8 f)])
    (hs : Fits S.mem sp 32) (hsr : S.mem.readAt sp 32 = sg)
    (hK :
      ∀ (v1735 : ⟦.bv 8⟧) (v1736 : ⟦.bv 8⟧) (v1737 : ⟦.vec 8 1⟧) (v1743 : ⟦.vec 8 64⟧)
        (v1744 : ⟦.vec 8 64⟧) (v1745 : ⟦.vec 8 64⟧) (v1746 : ⟦.vec 8 64⟧) (v1747 : ⟦.vec 8 64⟧)
        (v1748 : ⟦.vec 8 64⟧) (v1749 : ⟦.vec 8 64⟧) (v1750 : ⟦.vec 8 64⟧) (v1751 : ⟦.vec 8 64⟧)
        (v1752 : ⟦.vec 8 64⟧) (v1753 : ⟦.vec 8 64⟧) (v1754 : ⟦.vec 8 64⟧) (v1755 : ⟦.vec 8 64⟧)
        (v1756 : ⟦.vec 8 64⟧) (v1757 : ⟦.vec 8 64⟧) (v1758 : ⟦.vec 8 64⟧) (v1759 : ⟦.vec 8 64⟧)
        (v1760 : ⟦.vec 8 64⟧) (v1761 : ⟦.vec 8 64⟧) (v1762 : ⟦.vec 8 64⟧) (v1763 : ⟦.vec 8 64⟧)
        (v1764 : ⟦.vec 8 64⟧) (v1765 : ⟦.vec 8 64⟧) (v1766 : ⟦.vec 8 64⟧) (v1767 : ⟦.vec 8 64⟧)
        (v1768 : ⟦.vec 8 64⟧) (v1769 : ⟦.vec 8 64⟧) (v1770 : ⟦.vec 8 64⟧) (v1771 : ⟦.vec 8 1⟧)
        (v1777 : ⟦.vec 8 64⟧) (v1778 : ⟦.vec 8 64⟧) (v1779 : ⟦.vec 8 64⟧) (v1780 : ⟦.vec 8 64⟧)
        (v1781 : ⟦.vec 8 1⟧) (v1782 : ⟦.vec 8 1⟧) (v1783 : ⟦.bv 8⟧) (v1785 : ⟦.vec 8 1⟧)
        (v1786 : ⟦.bv 8⟧) (v1787 : ⟦.bv 32⟧) (v1788 : ⟦.bv 8⟧) (v1789 : ⟦.bv 8⟧),
        (verify_x8.bb41.runBodyFrom E[rir_dst% hty 1735 := v1735, rir_dst% hty 1736 := v1736,
          rir_dst% hty 1737 := v1737, rir_dst% hty 1738 := Ty.wrap (Fe.ite (f &&& ~~~c) M X).l0,
          rir_dst% hty 1739 := Ty.wrap (Fe.ite (f &&& ~~~c) M X).l1,
          rir_dst% hty 1740 := Ty.wrap (Fe.ite (f &&& ~~~c) M X).l2,
          rir_dst% hty 1741 := Ty.wrap (Fe.ite (f &&& ~~~c) M X).l3,
          rir_dst% hty 1742 := Ty.wrap (Fe.ite (f &&& ~~~c) M X).l4, rir_dst% hty 1743 := v1743,
          rir_dst% hty 1744 := v1744, rir_dst% hty 1745 := v1745, rir_dst% hty 1746 := v1746,
          rir_dst% hty 1747 := v1747, rir_dst% hty 1748 := v1748, rir_dst% hty 1749 := v1749,
          rir_dst% hty 1750 := v1750, rir_dst% hty 1751 := v1751, rir_dst% hty 1752 := v1752,
          rir_dst% hty 1753 := v1753, rir_dst% hty 1754 := v1754, rir_dst% hty 1755 := v1755,
          rir_dst% hty 1756 := v1756, rir_dst% hty 1757 := v1757, rir_dst% hty 1758 := v1758,
          rir_dst% hty 1759 := v1759][rir_dst% hty 1760 := v1760, rir_dst% hty 1761 := v1761,
          rir_dst% hty 1762 := v1762, rir_dst% hty 1763 := v1763, rir_dst% hty 1764 := v1764,
          rir_dst% hty 1765 := v1765, rir_dst% hty 1766 := v1766, rir_dst% hty 1767 := v1767,
          rir_dst% hty 1768 := v1768, rir_dst% hty 1769 := v1769, rir_dst% hty 1770 := v1770,
          rir_dst% hty 1771 := v1771,
          rir_dst% hty 1772 := Ty.wrap
              (wwl_sub (Vector.replicate 8 4503599627370458#64) (Fe.ite (f &&& ~~~c) M X).l0),
          rir_dst% hty 1773 := Ty.wrap
              (wwl_sub (Vector.replicate 8 4503599627370494#64) (Fe.ite (f &&& ~~~c) M X).l1),
          rir_dst% hty 1774 := Ty.wrap
              (wwl_sub (Vector.replicate 8 4503599627370494#64) (Fe.ite (f &&& ~~~c) M X).l2),
          rir_dst% hty 1775 := Ty.wrap
              (wwl_sub (Vector.replicate 8 4503599627370494#64) (Fe.ite (f &&& ~~~c) M X).l3),
          rir_dst% hty 1776 := Ty.wrap
              (wwl_sub (Vector.replicate 8 4503599627370494#64) (Fe.ite (f &&& ~~~c) M X).l4),
          rir_dst% hty 1777 := v1777, rir_dst% hty 1778 := v1778, rir_dst% hty 1779 := v1779,
          rir_dst% hty 1780 := v1780, rir_dst% hty 1781 := v1781, rir_dst% hty 1782 := v1782,
          rir_dst% hty 1783 := v1783,
          rir_dst% hty 1784 := PoisonOr.value (z8 (f ||| c))][rir_dst% hty 1785 := v1785,
          rir_dst% hty 1786 := v1786, rir_dst% hty 1787 := v1787, rir_dst% hty 1788 := v1788,
          rir_dst% hty 1789 := v1789,
          rir_dst% hty 1790 := PoisonOr.value
              (z8 (sg ^^^ parityOf (normalize (Fe.ite (f &&& ~~~c) M X))))] 511 S >>= G) = K) :
    (verify_x8.bb41.runBodyFrom E 455 S >>= G) = K := by
  split_env hC hR
  step_pure [z8_not]
  step_pure [z8_and]
  step_pure
  iterate 5 step_pure
  simp only [sel_z8] at hE
  step_pure
  step_pure [zipWith_add_shru_le _ _ (hM.if_l1 hX (f &&& ~~~c))]
  iterate 2 step_pure
  step_pure [zipWith_add_shru_le _ _ (hM.if_l2 hX (f &&& ~~~c))]
  iterate 2 step_pure
  step_pure [zipWith_add_shru_le _ _ (hM.if_l3 hX (f &&& ~~~c))]
  iterate 2 step_pure
  step_pure [zipWith_add_shru_le _ _ (hM.if_l4 hX (f &&& ~~~c))]
  iterate 2 step_pure
  iterate 16 step_pure
  step_pure
  step_pure [zipWith_sub_le _ (hM.if_l1 hX (f &&& ~~~c))]
  step_pure [zipWith_sub_le _ (hM.if_l2 hX (f &&& ~~~c))]
  step_pure [zipWith_sub_le _ (hM.if_l3 hX (f &&& ~~~c))]
  step_pure [zipWith_sub_le _ (hM.if_l4 hX (f &&& ~~~c))]
  iterate 6 step_pure
  step_pure with gp
  step_pure [z8_or]
  step_pure
  step_pure with pb
  step_load
  iterate 3 step_pure
  have hgp' : gp = z8 (gePOf (normalize (Fe.ite (f &&& ~~~c) M X))) := by
    rw [hgp, geP_compiled, normalize_eq_passC]
    rfl
  have hpb' : pb = z8
      (wwl_ne (wwl_and (normalize (Fe.ite (f &&& ~~~c) M X)).l0 wwl_one) wwl_zero) := by
    rw [hpb, par_compiled, normalize_eq_passC]
    rfl
  clear hgp hpb
  subst hgp' hpb'
  rw [z8_sign_xor] at hE
  subst hS
  rw [hE]
  exact hK _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _

/-- `^bb41`'s stores of `x` (negated by the sign mask `s`) and `y`, the identity's where `v`
fails. -/
theorem bb41_F2 {S : GlobalState} {E : ⟪Γ⟫} {G : ⟪Γ⟫ × GlobalState → PoisonOr β}
    {K : PoisonOr β} (P : Pointer) (XT Y : Fe) (v s : BitVec 32)
    (hC :
      E ⊨ [%94 := Ty.wrap (Vector.replicate 8 0#64), %95 := Ty.wrap (Vector.replicate 8 1#64)])
    (hR :
      E ⊨ [rir_reg% hty 1285 := PoisonOr.value P, rir_reg% hty 1287 := PoisonOr.value (P.add 64#64),
        rir_reg% hty 1289 := PoisonOr.value (P.add 128#64),
        rir_reg% hty 1291 := PoisonOr.value (P.add 192#64),
        rir_reg% hty 1293 := PoisonOr.value (P.add 256#64), rir_reg% hty 1738 := Ty.wrap XT.l0,
        rir_reg% hty 1739 := Ty.wrap XT.l1, rir_reg% hty 1740 := Ty.wrap XT.l2,
        rir_reg% hty 1741 := Ty.wrap XT.l3, rir_reg% hty 1742 := Ty.wrap XT.l4,
        rir_reg% hty 1772 := Ty.wrap (wwl_sub (Vector.replicate 8 4503599627370458#64) XT.l0),
        rir_reg% hty 1773 := Ty.wrap (wwl_sub (Vector.replicate 8 4503599627370494#64) XT.l1),
        rir_reg% hty 1774 := Ty.wrap (wwl_sub (Vector.replicate 8 4503599627370494#64) XT.l2),
        rir_reg% hty 1775 := Ty.wrap (wwl_sub (Vector.replicate 8 4503599627370494#64) XT.l3),
        rir_reg% hty 1776 := Ty.wrap (wwl_sub (Vector.replicate 8 4503599627370494#64) XT.l4),
        rir_reg% hty 1784 := PoisonOr.value (z8 v), rir_reg% hty 1790 := PoisonOr.value (z8 s)])
    (hP : Room S.mem P 10240) (hPo : P.offset = 0) (hy : Fits S.mem (P.add 320#64) 2560)
    (hyr : S.mem.readFe (P.add 320#64) = Y)
    (hK :
      ∀ (v1791 : ⟦.vec 8 1⟧) (v1792 : ⟦.vec 8 1⟧) (v1793 : ⟦.ptr⟧) (v1794 : ⟦.vec 8 64⟧)
        (v1796 : ⟦.vec 8 64⟧) (v1798 : ⟦.vec 8 64⟧) (v1800 : ⟦.ptr⟧) (v1801 : ⟦.vec 8 64⟧)
        (v1803 : ⟦.vec 8 64⟧) (v1805 : ⟦.ptr⟧) (v1806 : ⟦.vec 8 64⟧) (v1808 : ⟦.vec 8 64⟧)
        (v1810 : ⟦.ptr⟧) (v1811 : ⟦.vec 8 64⟧) (v1813 : ⟦.vec 8 64⟧) (v1815 : ⟦.ptr⟧)
        (v1816 : ⟦.vec 8 64⟧),
        (verify_x8.bb41.runBodyFrom E[rir_dst% hty 1791 := v1791, rir_dst% hty 1792 := v1792,
          rir_dst% hty 1793 := v1793, rir_dst% hty 1794 := v1794,
          rir_dst% hty 1795 := Ty.wrap (Fe.ite v (Fe.ite s (negC XT) XT) Fe.zero).l0,
          rir_dst% hty 1796 := v1796, rir_dst% hty 1797 := Ty.wrap (Fe.ite v Y Fe.one).l0,
          rir_dst% hty 1798 := v1798,
          rir_dst% hty 1799 := Ty.wrap (Fe.ite v (Fe.ite s (negC XT) XT) Fe.zero).l1,
          rir_dst% hty 1800 := v1800, rir_dst% hty 1801 := v1801,
          rir_dst% hty 1802 := Ty.wrap (Fe.ite v Y Fe.one).l1, rir_dst% hty 1803 := v1803,
          rir_dst% hty 1804 := Ty.wrap (Fe.ite v (Fe.ite s (negC XT) XT) Fe.zero).l2,
          rir_dst% hty 1805 := v1805, rir_dst% hty 1806 := v1806,
          rir_dst% hty 1807 := Ty.wrap (Fe.ite v Y Fe.one).l2, rir_dst% hty 1808 := v1808,
          rir_dst% hty 1809 := Ty.wrap (Fe.ite v (Fe.ite s (negC XT) XT) Fe.zero).l3,
          rir_dst% hty 1810 := v1810, rir_dst% hty 1811 := v1811,
          rir_dst% hty 1812 := Ty.wrap (Fe.ite v Y Fe.one).l3, rir_dst% hty 1813 := v1813,
          rir_dst% hty 1814 := Ty.wrap (Fe.ite v (Fe.ite s (negC XT) XT) Fe.zero).l4,
          rir_dst% hty 1815 := v1815][rir_dst% hty 1816 := v1816,
          rir_dst% hty 1817 := Ty.wrap (Fe.ite v Y Fe.one).l4,
          rir_dst% hty 1818 := PoisonOr.value (BitVec.setWidth 32 (z8 v)),
          rir_dst% hty 1819 := PoisonOr.value (P.add 960#64)] 550
            { S with
              mem :=
                (((((((((S.mem.storeAt P
                (BitVec.packLanes (Fe.ite v (Fe.ite s (negC XT) XT) Fe.zero).l0)).storeAt
                    (P.add 320#64)
                (BitVec.packLanes (Fe.ite v Y Fe.one).l0)).storeAt (P.add 64#64)
                (BitVec.packLanes (Fe.ite v (Fe.ite s (negC XT) XT) Fe.zero).l1)).storeAt
                    (P.add 384#64)
                (BitVec.packLanes (Fe.ite v Y Fe.one).l1)).storeAt (P.add 128#64)
                (BitVec.packLanes (Fe.ite v (Fe.ite s (negC XT) XT) Fe.zero).l2)).storeAt
                    (P.add 448#64)
                (BitVec.packLanes (Fe.ite v Y Fe.one).l2)).storeAt (P.add 192#64)
                (BitVec.packLanes (Fe.ite v (Fe.ite s (negC XT) XT) Fe.zero).l3)).storeAt
                    (P.add 512#64)
                (BitVec.packLanes (Fe.ite v Y Fe.one).l3)).storeAt (P.add 256#64)
                (BitVec.packLanes (Fe.ite v (Fe.ite s (negC XT) XT) Fe.zero).l4)).storeAt
                    (P.add 576#64)
                (BitVec.packLanes (Fe.ite v Y Fe.one).l4) } >>=
          G) = K) :
    (verify_x8.bb41.runBodyFrom E 511 S >>= G) = K := by
  split_env hC hR
  obtain ⟨hy0, hyr0⟩ := fe_limb hy (by simp only [Pointer.add, hPo]; decide) hyr (o := 0#64) 0
      (by decide)
  obtain ⟨hy1, hyr1⟩ := fe_limb hy (by simp only [Pointer.add, hPo]; decide) hyr (o := 64#64) 1
      (by decide)
  obtain ⟨hy2, hyr2⟩ := fe_limb hy (by simp only [Pointer.add, hPo]; decide) hyr (o := 128#64) 2
      (by decide)
  obtain ⟨hy3, hyr3⟩ := fe_limb hy (by simp only [Pointer.add, hPo]; decide) hyr (o := 192#64) 3
      (by decide)
  obtain ⟨hy4, hyr4⟩ := fe_limb hy (by simp only [Pointer.add, hPo]; decide) hyr (o := 256#64) 4
      (by decide)
  simp only [Fe.limb, Pointer.add_zero, Pointer.add_add, BitVec.reduceAdd]
    at hy0 hy1 hy2 hy3 hy4 hyr0 hyr1 hyr2 hyr3 hyr4
  clear hy hyr
  iterate 5 step_pure
  step_store
  step_load
  step_pure
  step_store
  iterate 2 step_pure
  step_store
  step_pure
  step_load
  step_pure
  step_store
  iterate 2 step_pure
  step_store
  step_pure
  step_load
  step_pure
  step_store
  iterate 2 step_pure
  step_store
  step_pure
  step_load
  step_pure
  step_store
  iterate 2 step_pure
  step_store
  step_pure
  step_load
  step_pure
  step_store
  iterate 2 step_pure
  simp only [sel_z8, sel_z8_k, sel_z8_2k] at hE hS
  subst hS
  rw [hE]
  exact hK _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _

variable {g : Vals [] × GlobalState → PoisonOr β}

-- eleven runs of `^bb41`'s 641 instructions in one declaration
set_option maxHeartbeats 4000000 in
/-- An iteration of `fd_ed25519_lane_decode2`'s second loop (`^bb41`'s body) on one set: from `x`
at `P` (the point `r[n]`, its address at `rp`), `y` at `P + 320`, `u`, `v`, `u v³` at `up`, `vp`,
`u3p` and the sign word `sg` at `sp`, `decFin`'s point at `P` and success mask. -/
theorem bb41_run (c : Call) (flag : BitVec 1) (vl sg : BitVec 32) (sp rp P up vp u3p : Pointer)
    (X0 Q : Fe) (pre : DecPre) (S : GlobalState) (E : ⟪Γ⟫)
    {G : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hG :
      G = fun x =>
        Exit.run verify_x8.blockParams x.1 verify_x8.bb41.exit x.2 >>= fun x =>
          Func.continue (func := verify_x8 c.batch) x.1.1 x.1.2 x.2 >>= g)
    (hA : E.args = c.args) (hD : EnvD c E)
    (hR :
      E ⊨ [rir_reg% hty 1278 := PoisonOr.value vl, rir_reg% hty 1279 := PoisonOr.value flag,
        rir_reg% hty 1280 := PoisonOr.value sp, rir_reg% hty 1281 := PoisonOr.value u3p,
        rir_reg% hty 1282 := PoisonOr.value vp, rir_reg% hty 1283 := PoisonOr.value up,
        rir_reg% hty 1284 := PoisonOr.value rp, rir_reg% hty 448 := Ty.wrap Q.l0,
        rir_reg% hty 450 := Ty.wrap Q.l1, rir_reg% hty 452 := Ty.wrap Q.l2,
        rir_reg% hty 454 := Ty.wrap Q.l3, rir_reg% hty 456 := Ty.wrap Q.l4])
    (hrp : InBounds S.mem rp 64) (hrpr : S.mem.loadPtr rp = .value P)
    (hP : Room S.mem P 10240) (hPo : P.offset = 0)
    (hx : Fits S.mem P 2560) (hxr : S.mem.readFe P = X0)
    (hy : Fits S.mem (P.add 320#64) 2560) (hyr : S.mem.readFe (P.add 320#64) = pre.y)
    (hu : Fits S.mem up 2560) (hur : S.mem.readFe up = pre.u) (huo : ¬up.offset.uaddOverflow 320#64)
    (hv : Fits S.mem vp 2560) (hvr : S.mem.readFe vp = pre.v) (hvo : ¬vp.offset.uaddOverflow 320#64)
    (hu3 : Fits S.mem u3p 2560) (hu3r : S.mem.readFe u3p = pre.uv3)
    (hu3o : ¬u3p.offset.uaddOverflow 320#64)
    (hs : Fits S.mem sp 32) (hsr : S.mem.readAt sp 32 = sg)
    (hne : [sp.id, rp.id, P.id, up.id, vp.id, u3p.id].Nodup)
    (hK :
      ∀ E' : ⟪Γ⟫, E'.args = c.args → EnvD c E' →
        (E' ⊨ [rir_reg% hty 1278 := PoisonOr.value vl, rir_reg% hty 1279 := PoisonOr.value flag,
          rir_reg% hty 1818 := PoisonOr.value (decFin Q sg pre X0).2,
          rir_reg% hty 448 := Ty.wrap Q.l0, rir_reg% hty 450 := Ty.wrap Q.l1,
          rir_reg% hty 452 := Ty.wrap Q.l2, rir_reg% hty 454 := Ty.wrap Q.l3,
          rir_reg% hty 456 := Ty.wrap Q.l4]) →
        (verify_x8.bb41.runBodyFrom E' 641
            { S with
              mem :=
                (xyMem (S.mem.storeFe P (mul X0 pre.uv3)) P (decFin Q sg pre X0).1.x
                  (decFin Q sg pre X0).1.y).storeFe (P.add 960#64) (decFin Q sg pre X0).1.t } >>=
          G) = K) :
    (verify_x8.bb41.runBodyFrom E 0 S >>= G) = K := by
  subst hG
  have hPov : ¬P.offset.uaddOverflow 320#64 := by rw [hPo]; decide
  simp only [List.nodup_cons, List.mem_cons, not_or, List.not_mem_nil, List.nodup_nil, and_true,
    not_false_eq_true] at hne
  obtain ⟨⟨-, hsP, -, -, -⟩, ⟨-, -, -, -⟩, ⟨hPu, hPv, -⟩, -, -⟩ := hne
  generalize hm0 : S.mem = m0 at hyr hur hvr
  split_env hD hR
  step_pattern using bb41_L0 rp P u3p X0 pre.uv3
  subst_limb4
  step_pattern using runBodyFrom_mulLooseRun'
  step_pattern using runBodyFrom_carryStoreRun
  subst_limb4
  simp only [fe_eta, ← mul_eq_carry] at hE hS
  step_pattern using runBodyFrom_sqrCRun (A := mul X0 pre.uv3) with chk
  subst_limb4
  have hvr' : S.mem.readFe vp = pre.v := by
    rw [hS]
    dsimp only
    simp only [MemoryState.storeVec, readFe_storeAt_of_id_ne _ hPv,
      readFe_storeAt_add_of_id_ne _ _ hPv, hm0]
    exact hvr
  step_pattern using bb41_V vp pre.v
  step_pattern using runBodyFrom_mulCRun (A := chk) (B := pre.v) with C
  subst_limb4
  have hur' : S.mem.readFe up = pre.u := by
    rw [hS]
    dsimp only
    simp only [MemoryState.storeVec, readFe_storeAt_of_id_ne _ hPu,
      readFe_storeAt_add_of_id_ne _ _ hPu, hm0]
    exact hur
  step_pattern using bb41_Z up C (mul chk pre.v false) pre.u (by rw [hC, mul_eq_carry])
  subst v1652
  step_pattern using runBodyFrom_mulCRun (A := mul X0 pre.uv3) (B := Q) with M
  subst_limb4
  step_pattern using bb41_F1 sp (mul X0 pre.uv3) M (isZero (subRaw C pre.u))
    (isZero (addRaw C pre.u)) sg (Carried.mul _ _) (by rw [hM]; exact Carried.mul _ _)
  have hyr' : S.mem.readFe (P.add 320#64) = pre.y := by
    rw [hS]
    dsimp only
    rw [hm0]
    change (m0.storeFe P (mul X0 pre.uv3)).readFe (P.add 320#64) = _
    rw [MemoryState.readFe_storeFe_base_apart (c := 640#64) (by rw [hPo]; decide) (by decide)
      (by decide)]
    exact hyr
  clear hfits_P hfits_P_64 hfits_P_128 hfits_P_192 hfits_P_256 hrp hx hu hv hu3 hs
  step_pattern using bb41_F2 P _ pre.y (isZero (addRaw C pre.u) ||| isZero (subRaw C pre.u))
    (sg ^^^ parityOf (normalize (Fe.ite (isZero (addRaw C pre.u) &&& ~~~isZero (subRaw C pre.u)) M
      (mul X0 pre.uv3))))
  subst v1819
  step_pattern using runBodyFrom_mulStoreRun' 1024 1088 1152 1216
  subst_limb4
  have h1 : EnvD c E := by env_reads
  subst hS hM hC hchk
  rw [z8_isZero_or] at hE
  rw [decFin_eq] at hK
  dsimp only at hK
  have h2 : E ⊨ [rir_reg% hty 1278 := PoisonOr.value vl, rir_reg% hty 1279 := PoisonOr.value flag,
      rir_reg% hty 1818 := PoisonOr.value
        (isZero (addRaw (mul (sqr (mul X0 pre.uv3)) pre.v) pre.u) |||
          isZero (subRaw (mul (sqr (mul X0 pre.uv3)) pre.v) pre.u)),
      rir_reg% hty 448 := Ty.wrap Q.l0, rir_reg% hty 450 := Ty.wrap Q.l1,
      rir_reg% hty 452 := Ty.wrap Q.l2, rir_reg% hty 454 := Ty.wrap Q.l3,
      rir_reg% hty 456 := Ty.wrap Q.l4] := by env_reads
  simp only [fe_eta]
  convert hK E hArgs h1 h2 using 4
  simp only [xyMem, MemoryState.storeFe, Pointer.add_add, BitVec.reduceAdd]

end

end MLIR.Firedancer.Lane.VerifyX8.Decode
