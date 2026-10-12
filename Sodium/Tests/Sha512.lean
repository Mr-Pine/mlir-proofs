module

public import Sodium.crypto_hash_sha512_init
public import Sodium.crypto_hash_sha512_update
public import Sodium.crypto_hash_sha512_final

meta import Sodium.crypto_hash_sha512_init
meta import Sodium.crypto_hash_sha512_update
meta import Sodium.crypto_hash_sha512_final

/-! `init`, `update` and `final` run on the lifts: the digest is SHA-512 of the bytes, and each
step's struct is its spec's. -/

namespace MLIR.Sodium

open _root_.Ed25519

private def st : Pointer :=
  ⟨⟨1⟩, 0⟩

private def inp : Pointer :=
  ⟨⟨2⟩, 0⟩

private def out : Pointer :=
  ⟨⟨3⟩, 0⟩

/-- Message byte `i`. -/
private def msg (n : Nat) : List (BitVec 8) :=
  (List.range n).map fun i => BitVec.ofNat 8 (i % 251)

private def bitsOf (l : List (BitVec 8)) : BitVec (8 * l.length) :=
  BitVec.ofNat _ (l.foldr (fun b acc => b.toNat + 256 * acc) 0)

/-- A struct of `0xaa` bytes, `buf` undefined; the input `n` message bytes; room for the digest. -/
private def state (n : Nat) : GlobalState :=
  ⟨⟨4⟩,
    ⟨Std.ExtHashMap.ofList
        [(⟨1⟩, ⟨208, (0xaa#8).replicate 208, (BitVec.allOnes 640).setWidth 1664, true,
            fun _ => none⟩),
          (⟨2⟩, ⟨n, (bitsOf (msg n)).cast (by simp [msg]), BitVec.allOnes (8 * n), true,
            fun _ => none⟩),
          (⟨3⟩, ⟨64, 0#512, 0#512, true, fun _ => none⟩)]⟩⟩

/-- `init`, `update` with the `n` bytes in pieces of `lens`, `final`: the digest's bytes. -/
private def run (n : Nat) (lens : List Nat) : Option (List (BitVec 8)) := do
  let .value (some _, s) :=
    crypto_hash_sha512_init.eval 10 (crypto_hash_sha512_init.args (.value st)) (state n)
    | none
  let (s, _) ←
    lens.foldlM
        (fun (acc : GlobalState × Nat) len =>
          match
            crypto_hash_sha512_update.eval 1000
              (crypto_hash_sha512_update.args (.value st) (.value (inp.add (BitVec.ofNat 64 acc.2)))
                (.value (BitVec.ofNat 64 len)))
              acc.1 with
          | .value (some _, s') => some (s', acc.2 + len)
          | _ => none)
        (s, 0)
  let .value (some _, s) :=
    crypto_hash_sha512_final.eval 1000 (crypto_hash_sha512_final.args (.value st) (.value out))
      s | none
  some (bytesLE (s.mem.readAt out 512))

#guard run 3 [3] == some (Sha512.digest (msg 3))

#guard
  [0, 1, 63, 64, 100, 128, 200].all fun n =>
    run (64 + n) [32, 32, n] == some (Sha512.digest (msg (64 + n)))

#guard
  [[128], [111], [112], [127], [64, 64], [100, 200, 300], [1, 127, 128, 129], [256, 0, 5]].all
    fun lens => run (lens.foldl (· + ·) 0) lens == some (Sha512.digest (msg (lens.foldl (· + ·) 0)))

/-- The struct's fields, to compare. -/
private def fields (v : HashState) :=
  (v.state.toList, v.count0, v.count1, v.buf, v.bufDef)

/-- After `init` and updates with `lens`, the lift's struct is the specs' (`init.spec`,
`update.spec`) and the counter matches `cores`. -/
private def specsMatch (n : Nat) (lens : List Nat) : Bool :=
  Id.run do
    let s0 := state n
    let .value (some _, s) :=
      crypto_hash_sha512_init.eval 10 (crypto_hash_sha512_init.args (.value st)) s0
      | return false
    if
        fields (s.mem.readHashState st) !=
          fields (crypto_hash_sha512_init.spec (s0.mem.readHashState st)) then
      return false
    let mut s := s
    let mut off := 0
    for len in lens do
      let p := inp.add (BitVec.ofNat 64 off)
      let l := BitVec.ofNat 64 len
      let v := s.mem.readHashState st
      match
        crypto_hash_sha512_update.eval 1000
          (crypto_hash_sha512_update.args (.value st) (.value p) (.value l)) s with
      | .value (some _, s') =>
        if
            fields (s'.mem.readHashState st) !=
              fields (crypto_hash_sha512_update.spec v l (s.mem.readAt p (8 * l.toNat))) then
          return false
        if
            s'.alloc.nextFreeBlock !=
              s.alloc.nextFreeBlock + 1 + crypto_hash_sha512_update.cores v l then
          return false
        s := s'
        off := off + len
      | _ =>
        return false
    return true

#guard
  [[3], [0], [32, 32, 100], [111, 1, 16], [128, 256, 7], [127, 129]].all fun lens =>
    specsMatch (lens.foldl (· + ·) 0) lens

end MLIR.Sodium
