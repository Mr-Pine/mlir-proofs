module

public import Firedancer.Leaders.Math.Rng

/-! `fd_chacha_rng_ulong_roll` (`MODE_MOD`) and `UniformU64Sampler::sample` are the same rejection
loop on the same keystream. -/

namespace Firedancer.Leaders.Math

open Firedancer.Leaders Agave

@[expose] public section

/-- Two fuelled results that agree on running out of fuel and relate by `R` when done. -/
def FueledRel {α β : Type} (R : α → β → Prop) : Fueled α → Fueled β → Prop
  | .outOfFuel, .outOfFuel => True
  | .done a, .done b => R a b
  | _, _ => False

/-- The rejection loop on keystream `k` from word `P`: the value and the next position. -/
def rollAt (k : Vector (BitVec 32) 8) (n zone : BitVec 64) : Nat → Nat → Fueled (BitVec 64 × Nat)
  | 0, _ => .outOfFuel
  | fuel + 1, P =>
    let (hi, lo) := UniformU64Sampler.wmul (ks64 k P) n
    if lo ≤ zone then .done (hi, P + 2) else rollAt k n zone fuel (P + 2)

theorem rollAt_pos {k : Vector (BitVec 32) 8} {n zone : BitVec 64} :
    ∀ {fuel P v P'}, rollAt k n zone fuel P = .done (v, P') → P' ≤ P + 2 * fuel ∧ P' % 2 = P % 2
  | 0, _, _, _, h => by simp [rollAt] at h
  | fuel + 1, P, v, P', h => by
    simp only [rollAt] at h
    split at h
    · cases h; omega
    · have := rollAt_pos h; omega

theorem uwide_mul_eq (x y : BitVec 64) : fd_uwide_mul.spec x y = UniformU64Sampler.wmul x y := by
  simp only [fd_uwide_mul.spec, UniformU64Sampler.wmul, Prod.mk.injEq]
  constructor <;> apply BitVec.eq_of_toNat_eq <;>
    simp [BitVec.extractLsb'_toNat, BitVec.truncate_eq_setWidth, Nat.shiftRight_eq_div_pow]

/-- `fd_chacha_rng_ulong_roll`'s loop follows `rollAt`. -/
theorem fd_roll_loop {key : Vector (BitVec 8) 32} (n zone : BitVec 64) :
    ∀ fuel rng P,
      FdRel key rng P →
        4 * (P + 2 * fuel) + 1024 < 2 ^ 64 →
        FueledRel (fun a b => a.1 = b.1 ∧ FdRel key a.2 b.2)
          (fd_chacha_rng_ulong_roll.loop n zone fuel rng)
          (rollAt (uintsOfBytes (k := 8) key) n zone fuel P)
  | 0, _, _, _, _ => trivial
  | fuel + 1, rng, P, h, hb => by
    obtain ⟨hv, h'⟩ := FdRel_ulong h (by omega)
    simp only [fd_chacha_rng_ulong_roll.loop, rollAt, hv, uwide_mul_eq]
    split
    · exact ⟨rfl, h'⟩
    · exact fd_roll_loop n zone fuel _ _ h' (by omega)

/-- `UniformU64Sampler::sample`'s loop on a `ChaCha20Rng` follows `rollAt`. -/
theorem agave_sample_loop {k : Vector (BitVec 32) 8} (s : UniformU64Sampler) :
    ∀ fuel rng P,
      AgRel k rng P →
        FueledRel (fun a b => a.1 = b.1 ∧ AgRel k a.2 b.2)
          (s.sampleLoop ChaCha20Rng.next_u64 fuel rng) (rollAt k s.range_end s.zone fuel P)
  | 0, _, _, _ => trivial
  | fuel + 1, rng, P, h => by
    obtain ⟨hv, h'⟩ := AgRel_next_u64 h
    simp only [UniformU64Sampler.sampleLoop, rollAt, hv]
    split
    · exact ⟨rfl, h'⟩
    · exact agave_sample_loop s fuel _ _ h'

/-- The `MODE_MOD` zone is `new_like_instance_sample`'s. -/
theorem fd_zone_eq (rng : fd_chacha_rng_t) (hm : rng.mode = FD_CHACHA_RNG_MODE_MOD)
    (n : BitVec 64) :
    fd_chacha_rng_ulong_roll.zone rng n = (UniformU64Sampler.new_like_instance_sample n).zone := by
  simp [fd_chacha_rng_ulong_roll.zone, hm, fd_ulong_if.spec,
    UniformU64Sampler.new_like_instance_sample]

theorem FueledRel_trans {α β γ : Type} {R : α → β → Prop} {S : γ → β → Prop} {T : α → γ → Prop}
    (hRST : ∀ a b c, R a b → S c b → T a c) :
    ∀ {x y z}, FueledRel R x y → FueledRel S z y → FueledRel T x z
  | .outOfFuel, .outOfFuel, .outOfFuel, _, _ => trivial
  | .done a, .done b, .done c, h1, h2 => hRST a b c h1 h2
  | .outOfFuel, .done _, _, h, _ => h.elim
  | .done _, .outOfFuel, _, h, _ => h.elim
  | _, .outOfFuel, .done _, _, h => h.elim
  | _, .done _, .outOfFuel, _, h => h.elim

/-- For every `n` and stream position, the `MODE_MOD` roll and `UniformU64Sampler::sample` both run
out of fuel or return the same value after the same number of `u64`s. -/
theorem roll_eq_sample {key : Vector (BitVec 8) 32} {rngF : fd_chacha_rng_t} {rngA : ChaCha20Rng}
    {P : Nat} (hF : FdRel key rngF P) (hA : AgRel (uintsOfBytes (k := 8) key) rngA P)
    (n : BitVec 64) (fuel : Nat) (hb : 4 * (P + 2 * fuel) + 1024 < 2 ^ 64) :
    FueledRel
      (fun a b => a.1 = b.1 ∧ ∃ P', FdRel key a.2 P' ∧ AgRel (uintsOfBytes (k := 8) key) b.2 P')
      (fd_chacha_rng_ulong_roll.spec fuel rngF n)
      ((UniformU64Sampler.new_like_instance_sample n).sample ChaCha20Rng.next_u64 fuel rngA) := by
  have h1 := fd_roll_loop (key := key) n (fd_chacha_rng_ulong_roll.zone rngF n) fuel rngF P hF hb
  have h2 := agave_sample_loop (UniformU64Sampler.new_like_instance_sample n) fuel rngA P hA
  rw [← fd_zone_eq rngF hF.2.2.1] at h2
  exact FueledRel_trans (fun a b c h h' => ⟨h.1.trans h'.1.symm, b.2, h.2, h'.2⟩) h1 h2

end

end Firedancer.Leaders.Math
