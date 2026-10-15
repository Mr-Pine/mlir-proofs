module

public import Firedancer.Crc.Ref.Verdict

/-!
# Cache semantics (spec and mathematical correctness)

The verification cache of PR firedancer #12267 (`crc/ref/fd_ed25519_ref_cache.c`) carries the
documented contract (`fd_ed25519_crc.h`):

> every cached function returns what its uncached counterpart returns, for all inputs and cache
> states: the cache changes only how long a call takes.

`fd_ed25519_verify_cached` differs from `fd_ed25519_verify` only in that it looks up a precomputed
split table of `−A` for the key (`crc_adx_verify_one` → `crc_adx_verify_core` with `a_tbl`), then
does credit/admission bookkeeping that never touches the returned code. A hit runs the table path
of `verify_core`; a miss runs the plain path. Admission (`crc_adx_cache_admit_point`) only ever
stores a table it built from the decoded, negated `A` of a key whose signature verified.

We model the cache as its key→table lookup (the sets, LRU, filter and credit affect *which* keys
are cached and *when* — timing, not results), the core as `core : Option Table → Item → code × ok`,
and prove:

* **results are cache-invariant** — a sound table yields the same code and `ok`, so the cached
  result equals the uncached one (`query_result`), hence a whole cached batch equals the uncached
  batch (`runCached_eq`);
* **the soundness invariant is preserved** by admission (`admit_inv`): the cache only ever holds
  tables sound for their key.

The single local fact left as the hypothesis `hcore` — a table sound for the key makes the core
return the same `(code, ok)` with or without it — is the table-vs-plain `verify_core` equivalence;
it reduces to `Dsmb.spec_val` (both `double_scalar_mul_base_split` and `double_scalar_mul_base`
compute `[k](−A) + [S]B`), the deferred crypto refinement.
-/

namespace MLIR.Firedancer.Crc.Ref.Cache

open MLIR.Firedancer.Crc.Ref.Verdict

@[expose] public section

variable {Item Key Table : Type} [DecidableEq Key]
  (key : Item → Key)
  (core : Option Table → Item → BitVec 32 × Bool)
  (sound : Table → Key → Prop)

/-- `fd_ed25519_verify(_cached)` from the core's `(code, ok)`: an error code is returned as is, else
`SUCCESS`/`ERR_MSG` from `ok`. -/
def result (tbl : Option Table) (item : Item) : BitVec 32 :=
  match core tbl item with
  | (code, ok) => if code = SUCCESS then (if ok then SUCCESS else ERR_MSG) else code

/-- The cache holds only tables sound for their key. -/
def Inv (c : Key → Option Table) : Prop := ∀ k t, c k = some t → sound t k

/-- Admission: when the bookkeeping decides to insert (`ins`), store the table built from the key's
decoded `−A`; otherwise leave the cache unchanged. -/
def admit (build : Key → Table) (ins : Item → Bool) (c : Key → Option Table) (item : Item) :
    Key → Option Table :=
  if ins item then Function.update c (key item) (some (build (key item))) else c

/-- One cached batch pass: each item queries the current cache, then offers itself for admission. -/
def runCached (build : Key → Table) (ins : Item → Bool) :
    (Key → Option Table) → List Item → List (BitVec 32)
  | _, [] => []
  | c, item :: rest =>
    result core (c (key item)) item :: runCached build ins (admit key build ins c item) rest

/-! ## Mathematical correctness -/

variable {key core sound}

omit [DecidableEq Key] in
/-- **Result invariance (one signature).** On a cache holding only sound tables, the cached result
equals the uncached result — the lookup never changes the verdict. -/
theorem query_result
    (hcore : ∀ t item, sound t (key item) → core (some t) item = core none item)
    {c : Key → Option Table} (hInv : Inv sound c) (item : Item) :
    result core (c (key item)) item = result core none item := by
  cases h : c (key item) with
  | none => rfl
  | some t => unfold result; rw [hcore t item (hInv _ _ h)]

/-- **Invariant preservation.** Admission keeps the cache holding only sound tables, given that a
built table is sound for its key. -/
theorem admit_inv {build : Key → Table} {ins : Item → Bool}
    (hbuild : ∀ k, sound (build k) k) {c : Key → Option Table} (hInv : Inv sound c) (item : Item) :
    Inv sound (admit key build ins c item) := by
  intro k t hkt
  unfold admit at hkt
  split at hkt
  · rw [Function.update_apply] at hkt
    split at hkt
    · rename_i hk; cases hkt; rw [hk]; exact hbuild _
    · exact hInv k t hkt
  · exact hInv k t hkt

/-- **Cached batch = uncached batch.** Every result of a cached pass equals the plain
`fd_ed25519_verify` of that item, whatever the starting cache (holding only sound tables) and
however admission mutates it. -/
theorem runCached_eq
    (hcore : ∀ t item, sound t (key item) → core (some t) item = core none item)
    {build : Key → Table} {ins : Item → Bool} (hbuild : ∀ k, sound (build k) k) :
    ∀ (items : List Item) (c : Key → Option Table), Inv sound c →
      runCached key core build ins c items = items.map (result core none) := by
  intro items
  induction items with
  | nil => intro c _; rfl
  | cons item rest ih =>
    intro c hInv
    rw [runCached, List.map_cons, query_result hcore hInv item,
      ih (admit key build ins c item) (admit_inv hbuild hInv item)]

end

end MLIR.Firedancer.Crc.Ref.Cache
