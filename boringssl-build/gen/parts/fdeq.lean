
/-! ## Firedancer's reduction -/

/-- A floor carry's residual fits 21 bits. -/
theorem x25519_sc_reduce.resid_le (a : BitVec 64) : a - a.sshiftRight 21 <<< 21 ≤ 2097151#64 := by
  bv_decide

/-- The C's 32 bytes of the limbs, the first eleven below `2^21`, are Firedancer's four packed
words. -/
theorem x25519_sc_reduce.bytes_eq_pack {s0 s1 s2 s3 s4 s5 s6 s7 s8 s9 s10 s11 f0 f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 : BitVec 64}
    (e0 : s0 = f0) (e1 : s1 = f1) (e2 : s2 = f2) (e3 : s3 = f3) (e4 : s4 = f4) (e5 : s5 = f5) (e6 : s6 = f6) (e7 : s7 = f7) (e8 : s8 = f8) (e9 : s9 = f9) (e10 : s10 = f10) (e11 : s11 = f11)
    (h0 : s0 ≤ 2097151#64) (h1 : s1 ≤ 2097151#64) (h2 : s2 ≤ 2097151#64) (h3 : s3 ≤ 2097151#64) (h4 : s4 ≤ 2097151#64) (h5 : s5 ≤ 2097151#64) (h6 : s6 ≤ 2097151#64) (h7 : s7 ≤ 2097151#64) (h8 : s8 ≤ 2097151#64) (h9 : s9 ≤ 2097151#64) (h10 : s10 ≤ 2097151#64) :
    (s11.sshiftRight 17).setWidth 8 ++ (s11.sshiftRight 9).setWidth 8 ++ (s11.sshiftRight 1).setWidth 8 ++ (s10.sshiftRight 14 ||| s11 <<< 7).setWidth 8 ++ (s10.sshiftRight 6).setWidth 8 ++ (s9.sshiftRight 19 ||| s10 <<< 2).setWidth 8 ++ (s9.sshiftRight 11).setWidth 8 ++ (s9.sshiftRight 3).setWidth 8 ++ (s8.sshiftRight 16 ||| s9 <<< 5).setWidth 8 ++ (s8.sshiftRight 8).setWidth 8 ++ s8.setWidth 8 ++ (s7.sshiftRight 13).setWidth 8 ++ (s7.sshiftRight 5).setWidth 8 ++ (s6.sshiftRight 18 ||| s7 <<< 3).setWidth 8 ++ (s6.sshiftRight 10).setWidth 8 ++ (s6.sshiftRight 2).setWidth 8 ++ (s5.sshiftRight 15 ||| s6 <<< 6).setWidth 8 ++ (s5.sshiftRight 7).setWidth 8 ++ (s4.sshiftRight 20 ||| s5 <<< 1).setWidth 8 ++ (s4.sshiftRight 12).setWidth 8 ++ (s4.sshiftRight 4).setWidth 8 ++ (s3.sshiftRight 17 ||| s4 <<< 4).setWidth 8 ++ (s3.sshiftRight 9).setWidth 8 ++ (s3.sshiftRight 1).setWidth 8 ++ (s2.sshiftRight 14 ||| s3 <<< 7).setWidth 8 ++ (s2.sshiftRight 6).setWidth 8 ++ (s1.sshiftRight 19 ||| s2 <<< 2).setWidth 8 ++ (s1.sshiftRight 11).setWidth 8 ++ (s1.sshiftRight 3).setWidth 8 ++ (s0.sshiftRight 16 ||| s1 <<< 5).setWidth 8 ++ (s0.sshiftRight 8).setWidth 8 ++ s0.setWidth 8 =
      (f9 >>> 3 ||| f10 <<< 18 ||| f11 <<< 39) ++
        ((f6 >>> 2 ||| f7 <<< 19 ||| f8 <<< 40 ||| f9 <<< 61) ++
          ((f3 >>> 1 ||| f4 <<< 20 ||| f5 <<< 41 ||| f6 <<< 62) ++
            (f0 ||| f1 <<< 21 ||| f2 <<< 42 ||| f3 <<< 63))) := by
  subst_vars
  bv_decide

