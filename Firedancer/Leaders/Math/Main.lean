module

public import Firedancer.Leaders.Math.Wsample
public import Firedancer.Leaders.Math.Order
import Std.Tactic.BVDecide
meta import Std.Tactic.BVDecide.Reflect

/-! Firedancer's leader schedule equals Agave's, slot for slot, on the consensus domain. -/

namespace Firedancer.Leaders.Math

open Firedancer.Leaders Agave

@[expose] public section

/-! ## Layout -/

/-- The region checks of `fd_epoch_leaders_new` pass, with an aligned non-`NULL` sampler address. -/
theorem layout (shmem slot_cnt pub_cnt : BitVec 64) (h1 : shmem < 0x8000000000000000#64)
    (h2 : fd_ulong_is_aligned.spec shmem FD_EPOCH_LEADERS_ALIGN ≠ 0#32) (h3 : 1#64 ≤ pub_cnt)
    (h4 : pub_cnt ≤ 2000#64) (h5 : 1#64 ≤ slot_cnt) (h6 : slot_cnt ≤ 432000#64) :
    let sched_cnt := (slot_cnt + FD_EPOCH_SLOTS_PER_ROTATION - 1#64) / FD_EPOCH_SLOTS_PER_ROTATION
    let laddr := shmem + sizeof_fd_epoch_leaders_t
    let laddr := fd_ulong_align_up.spec laddr 4#64
    let laddr := laddr + 4#64 * sched_cnt
    let laddr := fd_ulong_align_up.spec laddr 32#64
    let laddr := laddr + 32#64 * sched_cnt
    let laddr := fd_ulong_align_up.spec laddr (fd_ulong_max.spec 32#64 FD_WSAMPLE_ALIGN)
    ∃ wm,
      laddr = wm ∧
        wm ≠ 0#64 ∧
        fd_ulong_is_aligned.spec wm 64#64 ≠ 0#32 ∧
        wm + FD_WSAMPLE_FOOTPRINT pub_cnt false ≤
          wm + FD_EPOCH_LEADERS_FOOTPRINT pub_cnt slot_cnt := by
  refine ⟨_, rfl, ?_⟩
  simp only [fd_ulong_is_aligned.spec, fd_ulong_align_up.spec, fd_ulong_max.spec,
    FD_EPOCH_LEADERS_FOOTPRINT, FD_LAYOUT_APPEND, FD_ULONG_ALIGN_UP, FD_WSAMPLE_FOOTPRINT,
    FD_EPOCH_SLOTS_PER_ROTATION, sizeof_fd_epoch_leaders_t, alignof_fd_epoch_leaders_t,
    FD_WSAMPLE_ALIGN, FD_EPOCH_LEADERS_ALIGN] at *
  bv_decide

/-- `fd_wsample_footprint` is `FD_WSAMPLE_FOOTPRINT` for `1 ≤ ele_cnt ≤ 2000`. -/
theorem wsample_footprint_eq (m : BitVec 64) (h1 : 1 ≤ m.toNat) (h2 : m.toNat ≤ 2000) :
    fd_wsample_footprint.spec m 0#32 = FD_WSAMPLE_FOOTPRINT m false := by
  obtain ⟨h, hch, hle, hmin, hh⟩ := compute_height_eq m (by omega)
  unfold fd_wsample_footprint.spec
  rw [hch]
  simp only [sizeof_fd_wsample_t, sizeof_tree_ele_t, FD_WSAMPLE_FOOTPRINT, ne_eq, not_true_eq_false,
    ite_false, Bool.false_eq_true]
  have h4 : h ≤ 4 := by
    false_or_by_contra
    rcases hmin with h0 | h0
    · omega
    · have : 9 ^ 4 ≤ 9 ^ (h - 1) := Nat.pow_le_pow_right (by omega) (by omega)
      omega
  have hle' : ∀ c : Nat, c < 2 ^ 64 → (m ≤ BitVec.ofNat 64 c ↔ m.toNat ≤ c) := by
    intro c hc; rw [BitVec.le_def]; simp; omega
  match h, h4 with
  | 0, _ =>
    simp at hle
    rw [ite_eq_left
        (by
          rw [hle' 1 (by decide)]; omega)];
    decide
  | 1, _ =>
    simp at hle hmin
    rw [ite_eq_right
        (by
          rw [hle' 1 (by decide)]; omega),
      ite_eq_left
        (by
          rw [hle' 9 (by decide)]; omega)]
    decide
  | 2, _ =>
    simp at hle hmin
    rw [ite_eq_right
        (by
          rw [hle' 1 (by decide)]; omega),
      ite_eq_right
        (by
          rw [hle' 9 (by decide)]; omega),
      ite_eq_left
        (by
          rw [hle' 81 (by decide)]; omega)]
    decide
  | 3, _ =>
    simp at hle hmin
    rw [ite_eq_right
        (by
          rw [hle' 1 (by decide)]; omega),
      ite_eq_right
        (by
          rw [hle' 9 (by decide)]; omega),
      ite_eq_right
        (by
          rw [hle' 81 (by decide)]; omega),
      ite_eq_left
        (by
          rw [hle' 729 (by decide)]; omega)]
    decide
  | 4, _ =>
    simp at hle hmin
    rw [ite_eq_right
        (by
          rw [hle' 1 (by decide)]; omega),
      ite_eq_right
        (by
          rw [hle' 9 (by decide)]; omega),
      ite_eq_right
        (by
          rw [hle' 81 (by decide)]; omega),
      ite_eq_right
        (by
          rw [hle' 729 (by decide)]; omega),
      ite_eq_left
        (by
          rw [hle' 6561 (by decide)]; omega)]
    decide

/-- The ChaCha key of `fd_epoch_leaders_new` is Agave's seed. -/
theorem epoch_key_eq (epoch : BitVec 64) :
    storeBytes (Vector.replicate 32 0#8) 0
        (#v[epoch.extractLsb' 0 8, epoch.extractLsb' 8 8, epoch.extractLsb' 16 8,
            epoch.extractLsb' 24 8, epoch.extractLsb' 32 8, epoch.extractLsb' 40 8,
            epoch.extractLsb' 48 8, epoch.extractLsb' 56 8] :
          Vector (BitVec 8) 8) =
      epochSeed epoch := by
  apply Vector.ext
  intro j hj
  simp only [storeBytes, epochSeed, Vector.getElem_ofFn]
  by_cases h8 : j < 8
  · rw [dite_eq_left_of_eq_true (eq_true ⟨Nat.zero_le _, by omega⟩), ite_eq_left h8]
    match j, h8 with
    | 0, _ => rfl
    | 1, _ => rfl
    | 2, _ => rfl
    | 3, _ => rfl
    | 4, _ => rfl
    | 5, _ => rfl
    | 6, _ => rfl
    | 7, _ => rfl
  · rw [dite_eq_right_of_eq_false (eq_false (by omega)), ite_eq_right h8]; simp

/-! ## The sampling loops -/

/-- `sched` and Agave's leaders agree: `acc[t]` is `sl[sched[t]]`, in range. -/
def SchedRel (sl : Array SlotLeader) (sched : Array (BitVec 32)) (acc : Array SlotLeader) : Prop :=
  sched.size = acc.size ∧
    ∀ t, t < sched.size → sched[t]!.toNat < sl.size ∧ acc[t]! = sl[sched[t]!.toNat]!

theorem SchedRel.push {sl : Array SlotLeader} {sched : Array (BitVec 32)} {acc : Array SlotLeader}
    (h : SchedRel sl sched acc) (r : Nat) (hr : r < sl.size) (hr' : r < 2 ^ 32) :
    SchedRel sl (sched.push ((BitVec.ofNat 64 r).setWidth 32)) (acc.push sl[r]!) := by
  obtain ⟨h1, h2⟩ := h
  have hv : ((BitVec.ofNat 64 r).setWidth 32).toNat = r := by
    simp; omega
  refine ⟨by simp [h1], fun t ht => ?_⟩
  simp only [Array.size_push] at ht
  rcases Nat.lt_or_eq_of_le (Nat.le_of_lt_succ ht) with ht | ht
  · rw [getElem!_pos _ t
        (by
          simp; omega),
      Array.getElem_push_lt ht,
      getElem!_pos _ t
        (by
          simp; omega),
      Array.getElem_push_lt (by omega), ← getElem!_pos sched t ht, ← getElem!_pos acc t (by omega)]
    exact h2 t ht
  · subst ht
    rw [getElem!_pos _ sched.size (by simp), Array.getElem_push_eq,
      getElem!_pos _ sched.size
        (by
          simp; omega)]
    simp only [h1, Array.getElem_push_eq, hv]
    exact ⟨hr, trivial⟩

/-- The `sched` loop of `fd_epoch_leaders_new` and Agave's `repeat_with(..).take(..)` agree draw
for draw. -/
theorem sample_loop_eq (h : Nat) (ws : List (BitVec 64)) (s : fd_wsample_t)
    (hs : SamplerInv h (ws.map (·.toNat)) s) (hlen : ws.length ≤ 9 ^ h) (hh : h < 11)
    (hlen2 : ws.length ≤ 2000) (htot : (ws.map (·.toNat)).sum < 2 ^ 64)
    (hpos : 0 < (ws.map (·.toNat)).sum) (arr : Array (BitVec 64)) (hsz : arr.size = ws.length)
    (harr : ∀ j, j < ws.length → arr[j]! = BitVec.ofNat 64 (pre (ws.map (·.toNat)) (j + 1)))
    (sl : Array SlotLeader) (hsl : sl.size = ws.length) (key : Vector (BitVec 8) 32)
    (fuel n : Nat) :
    ∀ c i (sched : Array (BitVec 32)) (acc : Array SlotLeader) (rngF : fd_chacha_rng_t)
      (rngA : ChaCha20Rng) (P : Nat),
      n - i = c →
        i ≤ n →
        FdRel key rngF P →
        AgRel (uintsOfBytes (k := 8) key) rngA P →
        4 * (P + 2 * fuel * c) + 1024 < 2 ^ 64 →
        SchedRel sl sched acc →
        sched.size = i →
        FueledRel (fun a b => ∃ acc', b = some acc' ∧ SchedRel sl a.1 acc' ∧ a.1.size = n)
          (fd_epoch_leaders_new.sample_loop fuel s n sched rngF i)
          (sampleLeaders sl
            { weights := arr.pop,
              total_weight_sampler :=
                UniformU64Sampler.new_like_instance_sample
                  (BitVec.ofNat 64 (ws.map (·.toNat)).sum) }
            fuel c acc rngA) := by
  intro c
  induction c with
  | zero =>
    intro i sched acc rngF rngA P hc hi hF hA hb hrel hsz0
    rw [fd_epoch_leaders_new.sample_loop, ite_eq_right (by omega)]
    exact
      ⟨acc, rfl, hrel, by
        simp only; omega⟩
  | succ c ih =>
    intro i sched acc rngF rngA P hc hi hF hA hb hrel hsz0
    rw [fd_epoch_leaders_new.sample_loop, ite_eq_left (by omega)]
    simp only [sampleLeaders]
    have hstep :=
      sample_eq h ws s hs hlen hh htot hpos arr hsz harr (fuel := fuel) hF hA
        (by
          have : 2 * fuel ≤ 2 * fuel * (c + 1) := Nat.le_mul_of_pos_right _ (by omega); omega)
    generalize fd_wsample_sample.spec fuel s rngF = rF at hstep
    generalize WeightedU64Index.sample _ ChaCha20Rng.next_u64 fuel rngA = rA at hstep
    cases rF with
    | outOfFuel =>
      cases rA with
      | outOfFuel => trivial
      | done _ => exact hstep.elim
    | done a =>
      cases rA with
      | outOfFuel => exact hstep.elim
      | done b =>
        obtain ⟨vF, rngF'⟩ := a
        obtain ⟨idx, rngA'⟩ := b
        obtain ⟨hv, hidx, P', hP1, hP2, hF', hA'⟩ := hstep
        simp only at hv hidx hF' hA' ⊢
        rw [Array.getElem?_eq_getElem (by omega)]
        simp only
        rw [hv]
        have :=
          ih (i + 1) _ _ rngF' rngA' P' (by omega) (by omega) hF' hA'
            (by
              have : 2 * fuel * (c + 1) = 2 * fuel * c + 2 * fuel := by rw [Nat.mul_succ]
              omega)
            (hrel.push idx (by omega) (by omega)) (by simp [hsz0])
        rwa [← getElem!_pos sl idx (by omega)]

theorem mapM_congr' {β γ : Type} (f g : β → Option γ) :
    ∀ l : List β, (∀ x ∈ l, f x = g x) → l.mapM f = l.mapM g
  | [], _ => rfl
  | a :: l, h => by
    simp only [List.mapM_cons, h a (List.mem_cons_self ..),
      mapM_congr' f g l (fun x hx => h x (List.mem_cons_of_mem _ hx))]

theorem mapM_some {β γ : Type} (f : β → Option γ) :
    ∀ l : List β, (∀ x ∈ l, ∃ y, f x = some y) → ∃ ys, l.mapM f = some ys
  | [], _ => ⟨[], rfl⟩
  | a :: l, h => by
    obtain ⟨y, hy⟩ := h a (List.mem_cons_self ..)
    obtain ⟨ys, hys⟩ := mapM_some f l (fun x hx => h x (List.mem_cons_of_mem _ hx))
    exact ⟨y :: ys, by simp [List.mapM_cons, hy, hys]⟩

theorem fueledRel_oof' {α β : Type} {R : α → β → Prop} {y : Fueled β}
    (h : FueledRel R .outOfFuel y) : y = .outOfFuel := by
  cases y with
  | done b => exact h.elim
  | outOfFuel => rfl

theorem fueledRel_done' {α β : Type} {R : α → β → Prop} {a : α} {y : Fueled β}
    (h : FueledRel R (.done a) y) : ∃ b, y = .done b ∧ R a b := by
  cases y with
  | done b => exact ⟨b, rfl, h⟩
  | outOfFuel => exact h.elim

/-! ## The schedules -/

/-- Firedancer's schedule: `fd_stake_weights_by_node`, `fd_epoch_leaders_new`, then
`fd_epoch_leaders_get`/`_get_vote` per slot; `none` on any other outcome. -/
def fdSchedule (fuel : Nat) (shmem epoch slot0 slot_cnt : BitVec 64)
    (elems : Array fd_vote_stake_weight_t) : Fueled (Option (List SlotLeader)) :=
  match fd_stake_weights_by_node.spec elems with
  | .ok weights cnt =>
    match fd_epoch_leaders_new.spec fuel shmem epoch slot0 slot_cnt cnt weights with
    | .ok leaders =>
      .done
        ((List.range slot_cnt.toNat).mapM fun i => do
          let id ← fd_epoch_leaders_get.spec leaders (slot0 + BitVec.ofNat 64 i)
          let vote_address ← fd_epoch_leaders_get_vote.spec leaders (slot0 + BitVec.ofNat 64 i)
          return { id, vote_address })
    | .outOfFuel => .outOfFuel
    | _ => .done none
  | .outOfFuel => .outOfFuel
  | .logErr => .done none

/-- The consensus domain: 1 to 2000 records with pairwise-distinct vote keys and nonzero stakes
summing below 2^64, and a whole number of 4-slot rotations, at most 432000 slots. -/
structure Domain (elems : Array fd_vote_stake_weight_t) (slot_cnt : BitVec 64) : Prop where
  cnt_pos : 1 ≤ elems.size
  cnt_le : elems.size ≤ 2000
  votes : elems.toList.Pairwise fun a b => a.vote_key ≠ b.vote_key
  stakes : ∀ r ∈ elems.toList, r.stake ≠ 0#64
  total : (elems.toList.map (·.stake.toNat)).sum < 2 ^ 64
  slots_pos : 0 < slot_cnt.toNat
  slots_le : slot_cnt.toNat ≤ 432000
  slots_rot : slot_cnt.toNat % 4 = 0

/-- On the domain, with per-roll fuel below 2^31, Firedancer's schedule is Agave's slot for slot
(both out of fuel together) and Agave does not panic. -/
theorem leaders_eq_agave (fuel : Nat) (hfuel : fuel < 2 ^ 31)
    (shmem epoch slot0 slot_cnt : BitVec 64) (elems : Array fd_vote_stake_weight_t)
    (hd : Domain elems slot_cnt) (hm0 : shmem ≠ 0#64) (hm1 : shmem.toNat % 64 = 0)
    (hm2 : shmem.toNat < 2 ^ 63) (hslot : slot0.toNat + slot_cnt.toNat ≤ 2 ^ 64) :
    fdSchedule fuel shmem epoch slot0 slot_cnt elems =
        slotLeaders fuel (elems.toList.map toAgave) epoch slot_cnt.toNat ∧
      slotLeaders fuel (elems.toList.map toAgave) epoch slot_cnt.toNat ≠ .done none := by
  obtain ⟨weights, hws, hwsz, hwperm, hsort⟩ :=
    stake_weights_eq_sort_stakes elems hd.cnt_le hd.votes
  unfold fdSchedule slotLeaders stake_weighted_slot_leaders
  rw [hws, hsort]
  simp only [List.map_map]
  have hm := hd.cnt_le
  have hm1' := hd.cnt_pos
  have hpub : (BitVec.ofNat 64 elems.size).toNat = elems.size := by
    simp; omega
  obtain ⟨wm, hE, hwm0, hwm1, hwfp⟩ :=
    layout shmem slot_cnt (BitVec.ofNat 64 elems.size)
      (by
        rw [BitVec.lt_def]; simp; omega)
      (by
        have : shmem &&& 63#64 = 0#64 := by
          apply BitVec.eq_of_toNat_eq
          rw [BitVec.toNat_and, show (63#64).toNat = 2 ^ 6 - 1 from rfl,
            Nat.and_two_pow_sub_one_eq_mod]
          simp; omega
        simp [fd_ulong_is_aligned.spec, FD_EPOCH_LEADERS_ALIGN, this])
      (by
        rw [BitVec.le_def, hpub]; simp; omega)
      (by
        rw [BitVec.le_def, hpub]; simp; omega)
      (by
        rw [BitVec.le_def]; simp; have := hd.slots_pos; omega)
      (by
        rw [BitVec.le_def]; simp; have := hd.slots_le; omega)
  have hal : fd_ulong_is_aligned.spec shmem FD_EPOCH_LEADERS_ALIGN ≠ 0#32 := by
    have : shmem &&& 63#64 = 0#64 := by
      apply BitVec.eq_of_toNat_eq
      rw [BitVec.toNat_and, show (63#64).toNat = 2 ^ 6 - 1 from rfl, Nat.and_two_pow_sub_one_eq_mod]
      simp; omega
    simp [fd_ulong_is_aligned.spec, FD_EPOCH_LEADERS_ALIGN, this]
  have hsc := hd.slots_le; have hsp := hd.slots_pos; have hsr := hd.slots_rot
  unfold fd_epoch_leaders_new.spec
  dsimp only
  rw [hE, ite_eq_right hm0, ite_eq_right hal,
    ite_eq_right
      (by
        intro h0;
        have h1 : (BitVec.ofNat 64 elems.size).toNat = 0 := by
          rw [h0]; rfl
        omega),
    ite_eq_right
      (by
        rw [gt_iff_lt, BitVec.lt_def, show MAX_SLOTS_PER_EPOCH.toNat = 432000 from rfl]; omega),
    wsample_footprint_eq _ (by omega) (by omega)]
  have hfp :
    fd_epoch_leaders_footprint.spec (BitVec.ofNat 64 elems.size) slot_cnt =
      FD_EPOCH_LEADERS_FOOTPRINT (BitVec.ofNat 64 elems.size) slot_cnt := by
    unfold fd_epoch_leaders_footprint.spec
    rw [ite_eq_right]
    intro hc
    rcases hc with hc | hc | hc
    · have h1 : (BitVec.ofNat 64 elems.size).toNat = 0 := by
        rw [hc]; rfl
      omega
    · rw [gt_iff_lt, BitVec.lt_def, hpub] at hc
      have : (UINT_MAX - 3#64).toNat = 4294967292 := rfl
      omega
    · have h1 : slot_cnt.toNat = 0 := by
        rw [hc]; rfl
      omega
  rw [hfp, ite_eq_right (fun h => h hwfp), epoch_key_eq]
  obtain ⟨rng0, hnew, hmode⟩ :
    ∃ r, fd_chacha_rng_new.spec FD_CHACHA_RNG_MODE_MOD = some r ∧ r.mode = FD_CHACHA_RNG_MODE_MOD :=
    ⟨_, rfl, rfl⟩
  rw [hnew]
  dsimp only
  rw [hpub, ← hwsz]
  have hnz : ∀ i (hi : i < weights.size), weights[i].stake ≠ 0#64 := by
    intro i hi
    exact
      hd.stakes _
        (hwperm.subset
          (by
            rw [← Array.getElem_toList]; exact List.getElem_mem _))
  have hsum : (stakeList weights).sum = (elems.toList.map (·.stake.toNat)).sum :=
    (hwperm.map _).sum_nat
  obtain ⟨h, s, hloop, hjoin, hsinv, hle9, hh11⟩ :=
    build_sampler weights wm hwm0 hwm1 (by omega) (by omega) hnz
      (by
        rw [hsum]; exact hd.total)
  rw [hloop]
  dsimp only
  rw [hjoin]
  dsimp only
  have hws_def :
    List.map ((fun x => x.snd) ∘ toAgave) weights.toList = weights.toList.map (·.stake) := rfl
  rw [hws_def]
  have hwsN : (weights.toList.map (·.stake)).map (·.toNat) = stakeList weights := by
    simp [stakeList]
  have hpos : 0 < (stakeList weights).sum := by
    have hne : weights.toList ≠ [] := by
      intro h0
      have h1 : weights.toList.length = 0 := by
        rw [h0]; rfl
      rw [Array.length_toList] at h1; omega
    obtain ⟨a, rest, har⟩ := List.exists_cons_of_ne_nil hne
    have ha : a.stake ≠ 0#64 :=
      hd.stakes a
        (hwperm.subset
          (by
            rw [har]; exact List.mem_cons_self ..))
    have : 0 < a.stake.toNat := by
      rcases Nat.eq_zero_or_pos a.stake.toNat with h0 | h0
      · exact absurd (BitVec.eq_of_toNat_eq (by simpa using h0)) ha
      · exact h0
    simp only [stakeList, har, List.map_cons, List.sum_cons]; omega
  have htot : (stakeList weights).sum < 2 ^ 64 := by
    rw [hsum]; exact hd.total
  obtain ⟨arr, hwi, harrsz, harr⟩ :=
    weighted_new_ok (weights.toList.map (·.stake))
      (by
        simp; omega)
      (by
        rw [hwsN]; exact htot)
      (by
        rw [hwsN]; exact hpos)
  rw [hwi]
  dsimp only
  have hsched :
    ((slot_cnt + FD_EPOCH_SLOTS_PER_ROTATION - 1#64) / FD_EPOCH_SLOTS_PER_ROTATION).toNat =
      slot_cnt.toNat / 4 := by
    simp only [FD_EPOCH_SLOTS_PER_ROTATION]
    rw [BitVec.toNat_udiv,
      BitVec.toNat_sub_of_le
        (by
          rw [BitVec.le_def]; simp; omega)]
    simp; omega
  rw [hsched, show NUM_CONSECUTIVE_LEADER_SLOTS = 4 from rfl]
  have hF := FdRel_init rng0 hmode (epochSeed epoch)
  have hA := AgRel_from_seed (epochSeed epoch)
  rw [key_words_eq] at hA
  have hsl :
    (List.map ((fun x => x.fst) ∘ toAgave) weights.toList).toArray.size =
      (weights.toList.map (·.stake)).length := by
    simp
  have hbound : 4 * (0 + 2 * fuel * (slot_cnt.toNat / 4)) + 1024 < 2 ^ 64 := by
    have : fuel * (slot_cnt.toNat / 4) ≤ 2 ^ 31 * 108000 := Nat.mul_le_mul (by omega) (by omega)
    rw [Nat.mul_assoc]; omega
  have hle :=
    sample_loop_eq h (weights.toList.map (·.stake)) s
      (by
        rw [hwsN]; exact hsinv)
      (by
        simp; omega)
      hh11
      (by
        simp; omega)
      (by
        rw [hwsN]; exact htot)
      (by
        rw [hwsN]; exact hpos)
      arr harrsz harr _ hsl (epochSeed epoch) fuel (slot_cnt.toNat / 4) (slot_cnt.toNat / 4) 0 #[]
      #[] _ _ 0 (by omega) (by omega) hF hA hbound ⟨rfl, fun t ht => by simp at ht⟩ rfl
  generalize fd_epoch_leaders_new.sample_loop _ _ _ _ _ _ = rF at hle ⊢
  generalize sampleLeaders _ _ _ _ _ _ = rA at hle ⊢
  cases rF with
  | outOfFuel =>
    rw [fueledRel_oof' hle]; exact ⟨rfl, fun h => by cases h⟩
  | done a =>
    obtain ⟨sched, rng'⟩ := a
    obtain ⟨b, hb, acc, rfl, hrel, hsz⟩ := fueledRel_done' hle
    subst hb
    simp only at hrel hsz
    have hwl :
      (List.map ((fun x => x.fst) ∘ toAgave) weights.toList).toArray.size = weights.size := by simp
    have hrange : ∀ t, t < sched.size → sched[t]!.toNat < weights.size := fun t ht => by
      have := (hrel.2 t ht).1; rwa [hwl] at this
    dsimp only
    rw [ite_eq_right
        (by
          intro hany
          rw [Array.any_eq_true] at hany
          obtain ⟨t, ht, hc⟩ := hany
          have := hrange t ht
          rw [getElem!_pos sched t ht] at this
          simp at hc; omega)]
    dsimp only
    have hacc4 : acc.size * 4 = slot_cnt.toNat := by
      rw [← hrel.1, hsz]; omega
    have hne :
      Fueled.done (List.mapM (slotLeaderAt acc 4) (List.range slot_cnt.toNat)) ≠
        Fueled.done none := by
      intro hn
      have hn' : List.mapM (slotLeaderAt acc 4) (List.range slot_cnt.toNat) = none := by
        injection hn
      obtain ⟨ys, hys⟩ :=
        mapM_some (slotLeaderAt acc 4) (List.range slot_cnt.toNat)
          (fun i hi => by
            rw [List.mem_range] at hi
            unfold slotLeaderAt
            rw [hacc4, ite_eq_right (by omega), Nat.mod_eq_of_lt hi,
              getElem?_pos acc (i / 4) (by omega)]
            exact ⟨_, rfl⟩)
      rw [hys] at hn'; cases hn'
    refine ⟨?_, hne⟩
    congr 1
    apply mapM_congr'
    intro i hi
    rw [List.mem_range] at hi
    have hi4 : i / 4 < sched.size := by omega
    have hslot_i : (slot0 + BitVec.ofNat 64 i).toNat = slot0.toNat + i := by
      rw [BitVec.toNat_add]; simp; omega
    have hnlt : ¬(slot0 + BitVec.ofNat 64 i < slot0) := by
      rw [BitVec.lt_def, hslot_i]; omega
    have hdelta : slot0 + BitVec.ofNat 64 i - slot0 = BitVec.ofNat 64 i := by
      apply BitVec.eq_of_toNat_eq
      rw [BitVec.toNat_sub_of_le
          (by
            rw [BitVec.le_def, hslot_i]; omega),
        hslot_i];
      simp; omega
    have hnge : ¬(BitVec.ofNat 64 i ≥ slot_cnt) := by
      rw [ge_iff_le, BitVec.le_def]; simp; omega
    have hdiv : (BitVec.ofNat 64 i / FD_EPOCH_SLOTS_PER_ROTATION).toNat = i / 4 := by
      simp [FD_EPOCH_SLOTS_PER_ROTATION]; omega
    have hidx := hrange (i / 4) hi4
    have hacc := (hrel.2 (i / 4) hi4).2
    unfold fd_epoch_leaders_get.spec fd_epoch_leaders_get_vote.spec slotLeaderAt
    simp only [hdelta, hnlt, hnge, ite_false, hdiv]
    rw [getElem!_pos (Array.map (fun i => weights[i]!.id_key) (Array.range weights.size)) _
        (by simpa using hidx),
      getElem!_pos (Array.map (fun s => weights[s.toNat]!.vote_key) sched) _ (by simpa using hi4)]
    simp only [Array.getElem_map, Array.getElem_range]
    rw [hacc4, ite_eq_right (by omega), Nat.mod_eq_of_lt hi]
    have hia : i / 4 < acc.size := by
      rw [← hrel.1]; exact hi4
    rw [getElem?_pos acc (i / 4) hia, ← getElem!_pos acc (i / 4) hia, hacc,
      getElem!_pos ((List.map ((fun x => x.fst) ∘ toAgave) weights.toList).toArray) _
        (by simpa using hidx),
      ← getElem!_pos sched (i / 4) hi4, getElem!_pos weights _ hidx]
    simp [toAgave]

/-! ## Off the domain (not theorems)

Known differences outside `Domain`, checked by the differential runs, not proved here:
- `slot_cnt % 4 ≠ 0`: Firedancer samples `⌈slot_cnt/4⌉` rotations, Agave `⌊len/4⌋` and its `Index`
  wraps the tail slots to rotation 0; the first `⌊slot_cnt/4⌋` rotations agree.
- Duplicate `(stake, vote)` records: Agave's `dedup_by` keeps one, Firedancer weights each.
- More than 2000 records: `fd_stake_weights_by_node` exits (`FD_TEST`).
- `slot_cnt = 0`: Firedancer exits (footprint 0), Agave returns an empty schedule.
- A zero stake or a total ≥ 2^64: Firedancer exits; Agave panics only when all stakes are zero or
  the total overflows.
- Fuel ≥ 2^31: the C counter overflows (UB); beyond 2^61 draws Firedancer's 64-bit byte offset wraps
  while `rand_chacha`'s 64-bit block counter does not, so the streams would differ. -/

end

end Firedancer.Leaders.Math
