module

public import MLIR.Run.Tactic
public import Sodium.Common.Bytes
public import Sodium.Mlir.ge25519_has_small_order
import Std.Tactic.BVDecide
meta import Std.Tactic.BVDecide.Reflect

namespace MLIR.Sodium

/-! ## Specification -/

@[expose] public section

/-- The table `blacklist`, each entry's 32 bytes as a little-endian number. -/
def ge25519_has_small_order.blacklist : List (BitVec 256) :=
  [0#256, 1#256, 0x5fc536d880238b13933c6d305acdfd5f098eff289f4c345b027b2c28f95e826#256,
    0x7a03ac9277fdc74ec6cc392cfa53202a0f67100d760b3cba4fd84d3d706a17c7#256,
    0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffec#256,
    0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffed#256,
    0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffee#256]

open ge25519_has_small_order in
/-- `1` when `s` is an entry of `blacklist` but for the sign bit, as the C computes it: per entry
`t`, `c` is the `OR` of `s[j] ^ t[j]` (`s[31]` masked by `0x7f`), `0` exactly on a match;
`k |= c - 1` sets bit 8 when some `c` is `0`. -/
def ge25519_has_small_order.spec (s : BitVec 256) : BitVec 32 :=
  let byte (x : BitVec 256) (j : Nat) := x.extractLsb' (8 * j) 8
  let c (t : BitVec 256) :=
    orBytes (fun j => byte s j ^^^ byte t j) ((byte s 31 &&& 0x7f#8) ^^^ byte t 31) 31
  let k := blacklist.foldl (fun k t => k ||| ((c t).setWidth 32 - 1#32)) 0#32
  (k >>> 8) &&& 1#32

end

/-! ## Proof -/

section Proof

-- one block of 187 instructions, the deep steps costing most: about 300000 heartbeats
set_option maxHeartbeats 400000 in
/-- `ge25519_has_small_order` returns `spec` of the 32 bytes at `s`, read as seven 4-byte vectors
and four bytes; memory is unchanged. -/
public theorem ge25519_has_small_order.call_eq (s : Pointer) (st : GlobalState) (hwf : st.WF)
    (hs : Fits st.mem s 256) (hso : ¬s.offset.uaddOverflow 32#64) :
    ge25519_has_small_order.call (ge25519_has_small_order.args (.value s)) st =
      .value (.cons (.value (ge25519_has_small_order.spec (st.mem.readAt s 256))) .nil, st) := by
  obtain ⟨b, hb⟩ : ∃ b, st.mem.readAt s 256 = b := ⟨_, rfl⟩
  rw [hb]
  func_init
  block_init
  iterate 33 step_pure
  step_load
  step_pure
  step_load
  iterate 2 step_pure
  step_load
  iterate 2 step_pure
  step_load
  iterate 2 step_pure
  step_load
  iterate 2 step_pure
  step_load
  iterate 2 step_pure
  step_load
  step_pure
  step_pure with v2172
  iterate 7 step_pure
  step_pure with v2180
  iterate 13 step_pure
  step_pure with v2194
  iterate 13 step_pure
  step_pure with v2208
  iterate 8 step_pure
  step_pure with v2217
  iterate 8 step_pure
  step_pure with v2226
  iterate 8 step_pure
  step_pure with v2235
  step_pure
  step_load with v2237
  step_pure with v2238
  step_pure with v2239
  step_pure with v2240
  step_pure with v2241
  step_pure with v2242
  step_pure with v2243
  step_pure
  step_load with v2245
  step_pure with v2246
  step_pure with v2247
  step_pure with v2248
  step_pure with v2249
  step_pure with v2250
  step_pure with v2251
  step_pure with v2252
  step_pure with v2253
  step_pure with v2254
  step_pure
  step_load with v2256
  step_pure with v2257
  step_pure with v2258
  step_pure with v2259
  step_pure with v2260
  step_pure with v2261
  step_pure with v2262
  step_pure with v2263
  step_pure with v2264
  step_pure with v2265
  step_pure with v2266
  step_pure with v2267
  step_pure with v2268
  step_pure with v2269
  step_pure with v2270
  step_pure with v2271
  step_pure
  step_load with v2273
  step_pure with v2274
  step_pure with v2275
  step_pure with v2276
  step_pure with v2277
  step_pure with v2278
  step_pure with v2279
  step_pure with v2280
  step_pure with v2281
  step_pure with v2282
  step_pure with v2283
  step_pure with v2284
  step_pure
  step_pure [byte_sub_one_saddOverflow, byte_add_511_saddOverflow, byte_add_511_uaddOverflow] with
    v2286
  step_pure
  step_pure [byte_sub_one_saddOverflow, byte_add_511_saddOverflow, byte_add_511_uaddOverflow] with
    v2288
  step_pure with v2289
  step_pure
  step_pure [byte_sub_one_saddOverflow, byte_add_511_saddOverflow, byte_add_511_uaddOverflow] with
    v2291
  step_pure with v2292
  step_pure
  step_pure [byte_sub_one_saddOverflow, byte_add_511_saddOverflow, byte_add_511_uaddOverflow] with
    v2294
  step_pure with v2295
  step_pure
  step_pure [byte_sub_one_saddOverflow, byte_add_511_saddOverflow, byte_add_511_uaddOverflow] with
    v2297
  step_pure with v2298
  step_pure
  step_pure [byte_sub_one_saddOverflow, byte_add_511_saddOverflow, byte_add_511_uaddOverflow] with
    v2300
  step_pure with v2301
  step_pure
  step_pure [byte_sub_one_saddOverflow, byte_add_511_saddOverflow, byte_add_511_uaddOverflow] with
    v2303
  step_pure with v2304
  step_pure with v2305
  step_pure with v2306
  finish_block
  rw [hS]
  clear hS hE hArgs hb hs hwf hso
  congr
  simp only [Ty.extractVecElem_eq, fin_val_ofNat, Nat.reduceMod, Nat.reduceMul] at *
  simp only [ge25519_has_small_order.spec, ge25519_has_small_order.blacklist, orBytes, List.foldl,
    Nat.reduceMul]
  bv_decide

end Proof

end MLIR.Sodium
