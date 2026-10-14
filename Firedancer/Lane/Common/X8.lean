module

public import Firedancer.Lane.Common.Verify
public import Firedancer.Ref.fd_curve25519_scalar_validate
public import Firedancer.Ref.fd_curve25519_scalar_reduce

/-! `verify_x8` of `fd_ed25519_multi_msg.c` as a function: the results of up to eight items, from
their signatures, keys and digests. -/

namespace MLIR.Firedancer.Lane

open Firedancer.Avx512
open Firedancer.Ref (fd_curve25519_scalar_validate.spec fd_curve25519_scalar_reduce.spec)

@[expose] public section

/-- The broadcast constants and the fixed-base table `verify_x8` uses: `d`, `√-1`, `2d`, the
order-8 `y`s. -/
structure Consts where
  d : Fe
  sqrtm1 : Fe
  k2d : Fe
  y0 : Fe
  y1 : Fe
  tbl : Nat → BitVec 64

/-- `FD_ED25519_SUCCESS`, `_ERR_SIG`, `_ERR_PUBKEY`, `_ERR_MSG`. -/
abbrev errSig : BitVec 32 := -1#32
abbrev errPubkey : BitVec 32 := -2#32
abbrev errMsg : BitVec 32 := -3#32

/-- `verify_x8`'s identity encoding `{1}`. -/
abbrev identityBytes : BitVec 256 := 1#256

/-- `verify_x8`'s lane masks: candidates (scalar valid), the decodings, small order, live items. -/
structure X8 where
  cand : Fin 8 → Bool
  aValid : BitVec 32
  rValid : BitVec 32
  aSmall : BitVec 32
  rSmall : BitVec 32
  live : Fin 8 → Bool
  valid : BitVec 32

/-- Item `j` is a candidate: `j < cnt` and its `S` valid. -/
def x8Cand (cnt : Nat) (S : Fin 8 → BitVec 256) (j : Fin 8) : Bool :=
  decide (j.val < cnt) && fd_curve25519_scalar_validate.spec (S j)

/-- The encodings `verify_x8` decodes: a candidate's, else the identity's. -/
def x8Buf (cnt : Nat) (S X : Fin 8 → BitVec 256) (j : Fin 8) : BitVec 256 :=
  if x8Cand cnt S j then X j else identityBytes

/-- One set of `fd_ed25519_lane_decode2`, on `x8Buf`. -/
def x8Dec (C : Consts) (cnt : Nat) (S X : Fin 8 → BitVec 256) : Point × BitVec 32 :=
  let b := x8Buf cnt S X
  let pre := decPre C.d b
  decFin C.sqrtm1 (signs b) pre (pow22523 pre.uv7)

/-- `verify_x8` on items `j < cnt` with signatures `R j ‖ S j`, keys `A j`, and digests `H j` of
`R j ‖ A j ‖ M j` (used for live items only). -/
def x8 (C : Consts) (cnt : Nat) (R S A : Fin 8 → BitVec 256) (H : Fin 8 → BitVec 512) : X8 :=
  let a := (x8Dec C cnt S A).1
  let aValid := (x8Dec C cnt S A).2
  let r := (x8Dec C cnt S R).1
  let rValid := (x8Dec C cnt S R).2
  let aSmall := smallOrder C.y0 C.y1 a
  let rSmall := smallOrder C.y0 C.y1 r
  let live := fun j : Fin 8 => x8Cand cnt S j && aValid.getLsbD j && rValid.getLsbD j &&
    !aSmall.getLsbD j && !rSmall.getLsbD j
  let k := fun j => if live j then fd_curve25519_scalar_reduce.spec (H j) else 0
  let s := fun j => if live j then S j else 0
  let a' : Point := ⟨sub Fe.zero a.x, a.y, a.z, sub Fe.zero a.t⟩
  ⟨x8Cand cnt S, aValid, rValid, aSmall, rSmall, live, verify C.k2d C.tbl a' r k s⟩

/-- Item `j`'s result, in `fd_ed25519_verify`'s precedence: scalar, `A`, `R`, small-order `A`,
small-order `R`, the equation. -/
def X8.result (X : X8) (j : Fin 8) : BitVec 32 :=
  if !X.cand j then errSig
  else if !X.aValid.getLsbD j then errPubkey
  else if !X.rValid.getLsbD j then errSig
  else if X.aSmall.getLsbD j then errPubkey
  else if X.rSmall.getLsbD j then errSig
  else if X.valid.getLsbD j then 0#32
  else errMsg

end

end MLIR.Firedancer.Lane
