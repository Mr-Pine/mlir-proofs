module

public import Zig.zig_ed25519_verify
public import Zig.Math.Init
public import Zig.Math.VerifierVerify
public import Zig.Math.Verify

/-! `zig_ed25519_verify` computes `Zig.verify`: Zig's `Ed25519.Signature.verify`, cofactored, with its
error codes. -/

namespace LeanMLIR.RIR.Zig

open _root_.Ed25519

/-- The code the program returns is `verify`'s. -/
public theorem ZigVerify.code_eq (msg : List (BitVec 8)) (r S A : BitVec 256) :
    -((ZigVerify.code msg r S A).setWidth 32) = verify msg r S A := by
  by_cases hc : Verifier.init.code r S A = 0#16
  · obtain ⟨hS, hr, a, R, PA, PR, ha, hR, hPA, hPR, haE, hRE, -, -, haL, hRL, hAx, hRx⟩ :=
      Verifier.init.checks_of_code_eq hc
    rw [ZigVerify.code, ha, hR]
    simp only [ZigVerify.codeOf, hc, ↓reduceIte]
    rw [Verifier.verify.code_eq haE (ZPt.Lt.mono53 haL) hRE (ZPt.Lt.mono53 hRL)]
    unfold verify
    simp only [show ¬ell ≤ S.toNat by omega, ↓reduceIte, hPA, hPR, hAx, hr]
    split_ifs <;> decide
  · rw [Verifier.init.verify_of_code_ne msg hc, ZigVerify.code]
    rw [ZigVerify.codeOf_ne hc]

/-- `zig_ed25519_verify` on a message, a signature `r ‖ S` and a key `A` returns `verify`'s code,
and leaves memory as it found it. -/
public theorem zig_ed25519_verify.correct (msg : Pointer) (len : BitVec 64) (sig pk : Pointer)
    (s : GlobalState) (hwf : s.WF) (hmsg : Fits s.mem msg (8 * len.toNat))
    (hmo : msg.offset.toNat + len.toNat < 2 ^ 64) (hsig : Fits s.mem sig 512)
    (hso : sig.offset.toNat + 64 < 2 ^ 64) (hpk : Fits s.mem pk 256)
    (hpo : pk.offset.toNat + 32 < 2 ^ 64) (hlen : len.toNat + 128 < 2 ^ 64) :
    ∃ n,
      zig_ed25519_verify.call
          (zig_ed25519_verify.args (.value msg) (.value len) (.value sig) (.value pk)) s =
        .value
          (.cons
              (.value
                (verify (bytesLE (s.mem.readAt msg (8 * len.toNat))) (s.mem.readAt sig 256)
                  (s.mem.readAt (sig.add 32#64) 256) (s.mem.readAt pk 256)))
              .nil,
            { alloc := ⟨s.alloc.nextFreeBlock + n⟩, mem := s.mem }) := by
  refine
    ⟨ZigVerify.blocks (bytesLE (s.mem.readAt msg (8 * len.toNat))) (s.mem.readAt sig 256)
        (s.mem.readAt (sig.add 32#64) 256) (s.mem.readAt pk 256),
      ?_⟩
  rw [zig_ed25519_verify.call_eq msg len sig pk s hwf hmsg hmo hsig hso hpk hpo hlen]
  dsimp only
  rw [ZigVerify.code_eq]

end LeanMLIR.RIR.Zig
