module

public import SSA.Projects.RIR.Run.Tactic
public import Ed25519.Sha512

/-! Zig's `Sha512` object in memory: `total_len : u128` at `d`, the state `s : [8]u64` at `d + 16`,
`buf : [128]u8` at `d + 80`, `buf_len : u8` at `d + 208`; 224 bytes. -/

namespace LeanMLIR.RIR.Zig

open _root_.Ed25519

@[expose] public section

namespace Sha512Obj

/-- The state words `s[0 … 7]` of the object at `d`. -/
def state (m : MemoryState) (d : Pointer) : Vector (BitVec 64) 8 :=
  Vector.ofFn fun i => m.readAt (d.add (16#64 + BitVec.ofNat 64 (8 * i.val))) 64

/-- `f i, …, f (i + n - 1)` stored as the state words `i, …, i + n - 1` of the object at `d`. -/
def storeWords (d : Pointer) (f : Nat → BitVec 64) : (i n : Nat) → MemoryState → MemoryState
  | _, 0, m => m
  | i, n + 1, m =>
    storeWords d f (i + 1) n (m.storeAt (d.add (16#64 + BitVec.ofNat 64 (8 * i))) (f i))

/-- `v` stored as the state words of the object at `d`. -/
def setState (m : MemoryState) (d : Pointer) (v : Vector (BitVec 64) 8) : MemoryState :=
  storeWords d (fun i => v[i]!) 0 8 m

/-- `total_len`, the bytes absorbed. -/
def totalLen (m : MemoryState) (d : Pointer) : BitVec 128 :=
  m.readAt d 128

/-- `buf`. -/
def buf (m : MemoryState) (d : Pointer) : BitVec 1024 :=
  m.readAt (d.add 80#64) 1024

/-- `buf_len`. -/
def bufLen (m : MemoryState) (d : Pointer) : BitVec 8 :=
  m.readAt (d.add 208#64) 8

/-- The object's 224 bytes fit, their offsets not wrapping. -/
def Fit (m : MemoryState) (d : Pointer) : Prop :=
  Fits m d 1792 ∧ d.offset.toNat + 224 < 2 ^ 64

/-- The object at `d` has absorbed the bytes `M`: their whole blocks compressed from `IV`, the rest
buffered, their count in `total_len` (mod `2^128`). -/
structure Absorbed (m : MemoryState) (d : Pointer) (M : List (BitVec 8)) : Prop where
  state : state m d = Sha512.compressBlocks Sha512.IV M
  bufLen : (bufLen m d).toNat = M.length % 128
  buf : (bytesLE (buf m d)).take (M.length % 128) = M.drop (M.length / 128 * 128)
  totalLen : totalLen m d = BitVec.ofNat 128 M.length

end Sha512Obj

end

end LeanMLIR.RIR.Zig
