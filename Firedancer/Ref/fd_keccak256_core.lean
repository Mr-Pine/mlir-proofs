module

namespace MLIR.Firedancer.Ref

/-! ## Specification

`fd_keccak256_core( ulong * state )` permutes the 25 `ulong`s at `state` in place; here a list of
25 words, word `i` at `state[i]`. Lists keep `#eval` and `decide +kernel` linear (a `Fin 25 →`
state re-evaluates the whole round tree per lane). `getD … 0` reads only indices below 25. -/

@[expose] public section

/-- `fd_keccak256_rc` (`ballet/keccak256/fd_keccak256_private.h:8`). -/
def fd_keccak256_rc : List (BitVec 64) :=
  [0x0000000000000001#64, 0x0000000000008082#64, 0x800000000000808A#64, 0x8000000080008000#64,
   0x000000000000808B#64, 0x0000000080000001#64, 0x8000000080008081#64, 0x8000000000008009#64,
   0x000000000000008A#64, 0x0000000000000088#64, 0x0000000080008009#64, 0x000000008000000A#64,
   0x000000008000808B#64, 0x800000000000008B#64, 0x8000000000008089#64, 0x8000000000008003#64,
   0x8000000000008002#64, 0x8000000000000080#64, 0x000000000000800A#64, 0x800000008000000A#64,
   0x8000000080008081#64, 0x8000000000008080#64, 0x0000000080000001#64, 0x8000000080008008#64]

/-- `fd_ulong_rotate_left` (`util/bits/fd_bits.h:209`): `(x << (n&63)) | (x >> ((-n)&63))`. -/
def fd_ulong_rotate_left.spec (x : BitVec 64) (n : BitVec 32) : BitVec 64 :=
  (x <<< (n &&& 63#32).toNat) ||| (x >>> (-n &&& 63#32).toNat)

namespace fd_keccak256_core

/-- `rho_consts` (`fd_keccak256_private.h:32`). -/
def rho_consts : List (BitVec 8) :=
  [1, 3, 6, 10, 15, 21, 28, 36, 45, 55, 2, 14, 27, 41, 56, 8, 25, 43, 62, 18, 39, 61, 20, 44]

/-- `pi_consts` (`fd_keccak256_private.h:41`). -/
def pi_consts : List (BitVec 8) :=
  [10, 7, 11, 17, 18, 3, 5, 16, 8, 21, 24, 4, 15, 23, 19, 13, 12, 2, 20, 14, 22, 9, 6, 1]

end fd_keccak256_core

open fd_keccak256_core in
/-- `fd_keccak256_core` (`ballet/keccak256/fd_keccak256_private.h:31`, `FD_HAS_S2NBIGNUM` unset). -/
def fd_keccak256_core.spec (state : List (BitVec 64)) : List (BitVec 64) :=
  let NUM_ROUNDS := 24
  let ROTATE := fd_ulong_rotate_left.spec
  -- `ulong b[5]; ulong t;`: threaded through the loops as the C leaves them, first read after written
  let b : List (BitVec 64) := List.replicate 5 0#64
  let t : BitVec 64 := 0#64
  let (state, _, _) := (List.range NUM_ROUNDS).foldl
    (fun (acc : List (BitVec 64) × List (BitVec 64) × BitVec 64) round =>
      let (state, b, t) := acc
      -- Theta step
      let b := (List.range 5).foldl
        (fun b i =>
          b.set i (state.getD i 0 ^^^ state.getD (i + 5) 0 ^^^ state.getD (i + 10) 0 ^^^
            state.getD (i + 15) 0 ^^^ state.getD (i + 20) 0))
        b
      let (state, _) := (List.range 5).foldl
        (fun (acc : List (BitVec 64) × BitVec 64) i =>
          let (state, _) := acc
          let t := b.getD ((i + 4) % 5) 0 ^^^ ROTATE (b.getD ((i + 1) % 5) 0) 1#32
          -- for( ulong j = 0; j < 25; j += 5 )
          let state := [0, 5, 10, 15, 20].foldl
            (fun state j => state.set (i + j) (state.getD (i + j) 0 ^^^ t)) state
          (state, t))
        (state, t)
      -- Rho and pi steps
      let t := state.getD 1 0
      let (state, b, t) := (List.range 24).foldl
        (fun (acc : List (BitVec 64) × List (BitVec 64) × BitVec 64) i =>
          let (state, b, t) := acc
          let pi_val := (pi_consts.getD i 0).toNat
          let rho_val : BitVec 32 := (rho_consts.getD i 0).setWidth 32
          let b := b.set 0 (state.getD pi_val 0)
          let state := state.set pi_val (ROTATE t rho_val)
          let t := b.getD 0 0
          (state, b, t))
        (state, b, t)
      -- Chi step; for( ulong i = 0; i < 25; i += 5 )
      let (state, b) := [0, 5, 10, 15, 20].foldl
        (fun (acc : List (BitVec 64) × List (BitVec 64)) i =>
          let (state, b) := acc
          let b := (List.range 5).foldl (fun b j => b.set j (state.getD (i + j) 0)) b
          let state := (List.range 5).foldl
            (fun state j =>
              state.set (i + j)
                (state.getD (i + j) 0 ^^^ (~~~(b.getD ((j + 1) % 5) 0) &&& b.getD ((j + 2) % 5) 0)))
            state
          (state, b))
        (state, b)
      -- Iota step
      let state := state.set 0 (state.getD 0 0 ^^^ fd_keccak256_rc.getD round 0)
      (state, b, t))
    (state, b, t)
  state

/-! ### s2n-bignum `sha3_keccak_f1600`

`x86/proofs/utils/keccak_spec.ml` and `arm/proofs/utils/keccak_spec.ml` at `cba3956c` (copies in
`~/fd-specs/ref-crates/s2n-bignum/{x86,arm}/utils/`) define these terms identically; `EL i l` is
`l.getD i 0`, `word_rol` is `rotateLeft`. `SHA3_KECCAK_F1600_SUBROUTINE_CORRECT` (x86 and arm)
assumes the 24 words at `rc` are `round_constants` and that `a`'s 200 bytes, `rc`'s 192, the stack
frame and the code do not overlap. -/

namespace sha3_keccak_f1600

/-- `round_constants` (`keccak_spec.ml`). -/
def round_constants : List (BitVec 64) :=
  [0x0000000000000001#64, 0x0000000000008082#64, 0x800000000000808a#64, 0x8000000080008000#64,
   0x000000000000808b#64, 0x0000000080000001#64, 0x8000000080008081#64, 0x8000000000008009#64,
   0x000000000000008a#64, 0x0000000000000088#64, 0x0000000080008009#64, 0x000000008000000a#64,
   0x000000008000808b#64, 0x800000000000008b#64, 0x8000000000008089#64, 0x8000000000008003#64,
   0x8000000000008002#64, 0x8000000000000080#64, 0x000000000000800a#64, 0x800000008000000a#64,
   0x8000000080008081#64, 0x8000000000008080#64, 0x0000000080000001#64, 0x8000000080008008#64]

/-- `keccak_round RCi Alist` (`keccak_spec.ml`): one round, lists in row-major order. -/
def keccak_round (RCi : BitVec 64) (Alist : List (BitVec 64)) : List (BitVec 64) :=
  let A00 := Alist.getD 0 0
  let A10 := Alist.getD 1 0
  let A20 := Alist.getD 2 0
  let A30 := Alist.getD 3 0
  let A40 := Alist.getD 4 0
  let A01 := Alist.getD 5 0
  let A11 := Alist.getD 6 0
  let A21 := Alist.getD 7 0
  let A31 := Alist.getD 8 0
  let A41 := Alist.getD 9 0
  let A02 := Alist.getD 10 0
  let A12 := Alist.getD 11 0
  let A22 := Alist.getD 12 0
  let A32 := Alist.getD 13 0
  let A42 := Alist.getD 14 0
  let A03 := Alist.getD 15 0
  let A13 := Alist.getD 16 0
  let A23 := Alist.getD 17 0
  let A33 := Alist.getD 18 0
  let A43 := Alist.getD 19 0
  let A04 := Alist.getD 20 0
  let A14 := Alist.getD 21 0
  let A24 := Alist.getD 22 0
  let A34 := Alist.getD 23 0
  let A44 := Alist.getD 24 0
  let C0 := A00 ^^^ A01 ^^^ A02 ^^^ A03 ^^^ A04
  let C1 := A10 ^^^ A11 ^^^ A12 ^^^ A13 ^^^ A14
  let C2 := A20 ^^^ A21 ^^^ A22 ^^^ A23 ^^^ A24
  let C3 := A30 ^^^ A31 ^^^ A32 ^^^ A33 ^^^ A34
  let C4 := A40 ^^^ A41 ^^^ A42 ^^^ A43 ^^^ A44
  let D0 := C4 ^^^ C1.rotateLeft 1
  let D1 := C0 ^^^ C2.rotateLeft 1
  let D2 := C1 ^^^ C3.rotateLeft 1
  let D3 := C2 ^^^ C4.rotateLeft 1
  let D4 := C3 ^^^ C0.rotateLeft 1
  let At00 := A00 ^^^ D0
  let At01 := A01 ^^^ D0
  let At02 := A02 ^^^ D0
  let At03 := A03 ^^^ D0
  let At04 := A04 ^^^ D0
  let At10 := A10 ^^^ D1
  let At11 := A11 ^^^ D1
  let At12 := A12 ^^^ D1
  let At13 := A13 ^^^ D1
  let At14 := A14 ^^^ D1
  let At20 := A20 ^^^ D2
  let At21 := A21 ^^^ D2
  let At22 := A22 ^^^ D2
  let At23 := A23 ^^^ D2
  let At24 := A24 ^^^ D2
  let At30 := A30 ^^^ D3
  let At31 := A31 ^^^ D3
  let At32 := A32 ^^^ D3
  let At33 := A33 ^^^ D3
  let At34 := A34 ^^^ D3
  let At40 := A40 ^^^ D4
  let At41 := A41 ^^^ D4
  let At42 := A42 ^^^ D4
  let At43 := A43 ^^^ D4
  let At44 := A44 ^^^ D4
  let B00 := At00.rotateLeft 0
  let B01 := At30.rotateLeft 28
  let B02 := At10.rotateLeft 1
  let B03 := At40.rotateLeft 27
  let B04 := At20.rotateLeft 62
  let B10 := At11.rotateLeft 44
  let B11 := At41.rotateLeft 20
  let B12 := At21.rotateLeft 6
  let B13 := At01.rotateLeft 36
  let B14 := At31.rotateLeft 55
  let B20 := At22.rotateLeft 43
  let B21 := At02.rotateLeft 3
  let B22 := At32.rotateLeft 25
  let B23 := At12.rotateLeft 10
  let B24 := At42.rotateLeft 39
  let B30 := At33.rotateLeft 21
  let B31 := At13.rotateLeft 45
  let B32 := At43.rotateLeft 8
  let B33 := At23.rotateLeft 15
  let B34 := At03.rotateLeft 41
  let B40 := At44.rotateLeft 14
  let B41 := At24.rotateLeft 61
  let B42 := At04.rotateLeft 18
  let B43 := At34.rotateLeft 56
  let B44 := At14.rotateLeft 2
  [(B00 ^^^ (~~~B10 &&& B20)) ^^^ RCi,
   B10 ^^^ (~~~B20 &&& B30),
   B20 ^^^ (~~~B30 &&& B40),
   B30 ^^^ (~~~B40 &&& B00),
   B40 ^^^ (~~~B00 &&& B10),
   B01 ^^^ (~~~B11 &&& B21),
   B11 ^^^ (~~~B21 &&& B31),
   B21 ^^^ (~~~B31 &&& B41),
   B31 ^^^ (~~~B41 &&& B01),
   B41 ^^^ (~~~B01 &&& B11),
   B02 ^^^ (~~~B12 &&& B22),
   B12 ^^^ (~~~B22 &&& B32),
   B22 ^^^ (~~~B32 &&& B42),
   B32 ^^^ (~~~B42 &&& B02),
   B42 ^^^ (~~~B02 &&& B12),
   B03 ^^^ (~~~B13 &&& B23),
   B13 ^^^ (~~~B23 &&& B33),
   B23 ^^^ (~~~B33 &&& B43),
   B33 ^^^ (~~~B43 &&& B03),
   B43 ^^^ (~~~B03 &&& B13),
   B04 ^^^ (~~~B14 &&& B24),
   B14 ^^^ (~~~B24 &&& B34),
   B24 ^^^ (~~~B34 &&& B44),
   B34 ^^^ (~~~B44 &&& B04),
   B44 ^^^ (~~~B04 &&& B14)]

/-- `keccak n l` (`keccak_spec.ml`): `n` rounds from `l`, round `i` with `EL i round_constants`. -/
def keccak : Nat → List (BitVec 64) → List (BitVec 64)
  | 0, l => l
  | n + 1, l => keccak_round (round_constants.getD n 0) (keccak n l)

end sha3_keccak_f1600

open sha3_keccak_f1600 in
/-- `sha3_keccak_f1600( a, rc )` by s2n-bignum's `SHA3_KECCAK_F1600_SUBROUTINE_CORRECT`
(`cba3956c`): the 25 words at `a` become `keccak 24 A`. -/
def sha3_keccak_f1600.spec (A : List (BitVec 64)) : List (BitVec 64) :=
  keccak 24 A

/-- The contract's `rc` precondition for `fd_keccak256_rc`. -/
theorem fd_keccak256_rc_eq_round_constants :
    fd_keccak256_rc = sha3_keccak_f1600.round_constants := by
  decide

/-- `fd_keccak256_core` (`ballet/keccak256/fd_keccak256_s2n.c:10`, `FD_HAS_S2NBIGNUM` set):
`sha3_keccak_f1600( state, fd_keccak256_rc )`, the table a separate `static const`. -/
def fd_keccak256_core.s2n (state : List (BitVec 64)) : List (BitVec 64) :=
  sha3_keccak_f1600.spec state

end

end MLIR.Firedancer.Ref
