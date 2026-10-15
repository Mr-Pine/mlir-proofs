module

public import Mathlib.Tactic

/-!
# Transaction verdict rule (spec and mathematical correctness)

`crc_adx_verdict` (PR firedancer #12267, `crc/ref/fd_ed25519_ref_verify.c`) collapses the
per-signature result codes of a batch into one transaction verdict. `fd_ed25519_crc.h` states the
rule:

> the first code that is neither `SUCCESS` nor `ERR_MSG`, else `ERR_MSG` when any equation
> failed, else `SUCCESS`.

The C keeps a flag `ok`, returns the first "other" code it meets, and otherwise returns
`ERR_MSG` when `ok` was cleared (an `ERR_MSG` was seen) or `SUCCESS` when it was not:

```c
int ok = 1;
for( j ) { if( codes[j]==SUCCESS ) continue; if( codes[j]!=ERR_MSG ) return codes[j]; ok = 0; }
return ok ? SUCCESS : ERR_MSG;
```

Here we model codes as `BitVec 32` (`int`), state the rule as a pure fold, and prove it matches
the English specification.
-/

namespace MLIR.Firedancer.Crc.Ref.Verdict

@[expose] public section

/-- `FD_ED25519_SUCCESS`. -/
def SUCCESS : BitVec 32 := 0

/-- `FD_ED25519_ERR_MSG`. -/
def ERR_MSG : BitVec 32 := -3

/-- The verdict of the remaining codes, with `ok` recording that no `ERR_MSG` has been seen: the
first code that is neither `SUCCESS` nor `ERR_MSG` short-circuits; otherwise `ERR_MSG` when one
was seen, else `SUCCESS`. -/
def runFrom (ok : Bool) : List (BitVec 32) → BitVec 32
  | [] => if ok then SUCCESS else ERR_MSG
  | c :: cs =>
    if c = SUCCESS then runFrom ok cs
    else if c = ERR_MSG then runFrom false cs
    else c

/-- The transaction verdict of a batch's codes. -/
def verdict (codes : List (BitVec 32)) : BitVec 32 := runFrom true codes

/-! ## Mathematical correctness

`SUCCESS` and `ERR_MSG` are distinct, so the three cases of the rule are exclusive. -/

theorem success_ne_errmsg : SUCCESS ≠ ERR_MSG := by decide

/-- A code already recorded (`ok = false`) never yields `SUCCESS`. -/
theorem runFrom_false_ne_success (codes : List (BitVec 32)) : runFrom false codes ≠ SUCCESS := by
  induction codes with
  | nil => decide
  | cons c cs ih =>
    simp only [runFrom]
    split
    · exact ih
    · split
      · exact ih
      · rename_i h _; exact h

/-- **Success.** The verdict is `SUCCESS` exactly when every code is `SUCCESS`. -/
theorem verdict_eq_success_iff (codes : List (BitVec 32)) :
    verdict codes = SUCCESS ↔ ∀ c ∈ codes, c = SUCCESS := by
  show runFrom true codes = SUCCESS ↔ _
  induction codes with
  | nil => simp [runFrom]
  | cons c cs ih =>
    simp only [runFrom, List.mem_cons, forall_eq_or_imp]
    split
    · rename_i hc; simp [hc, ih]
    · split
      · rename_i hc; simp only [hc]
        constructor
        · intro h; exact absurd h (runFrom_false_ne_success cs)
        · rintro ⟨hmsg, -⟩; exact absurd hmsg success_ne_errmsg.symm
      · rename_i hcs hcm
        constructor
        · intro h; exact absurd h hcs
        · rintro ⟨hc, -⟩; exact absurd hc hcs

/-- **Failure.** The verdict is `ERR_MSG` exactly when at least one code is `ERR_MSG` and every
code is `SUCCESS` or `ERR_MSG` (no other failure appears). -/
theorem verdict_eq_errmsg_iff (codes : List (BitVec 32)) :
    verdict codes = ERR_MSG ↔
      (∃ c ∈ codes, c = ERR_MSG) ∧ ∀ c ∈ codes, c = SUCCESS ∨ c = ERR_MSG := by
  show runFrom true codes = ERR_MSG ↔ _
  suffices h : ∀ ok, runFrom ok codes = ERR_MSG ↔
      ((∃ c ∈ codes, c = ERR_MSG) ∨ ok = false) ∧ ∀ c ∈ codes, c = SUCCESS ∨ c = ERR_MSG by
    rw [h true]; simp
  intro ok
  induction codes generalizing ok with
  | nil =>
    cases ok <;> simp [runFrom, success_ne_errmsg]
  | cons c cs ih =>
    simp only [runFrom, List.mem_cons, forall_eq_or_imp, exists_eq_or_imp]
    split
    · rename_i hc
      rw [ih ok]; simp [hc, success_ne_errmsg]
    · split
      · rename_i hc
        rw [ih false]; simp [hc]
      · rename_i hcs hcm
        constructor
        · intro h; exact absurd h hcm
        · rintro ⟨-, hc, -⟩; exact absurd hc (by simp [hcs, hcm])

/-- **Short-circuit.** When the first code is neither `SUCCESS` nor `ERR_MSG`, the verdict is that
code, whatever follows. -/
theorem verdict_cons_other (c : BitVec 32) (cs : List (BitVec 32))
    (h1 : c ≠ SUCCESS) (h2 : c ≠ ERR_MSG) : verdict (c :: cs) = c := by
  simp [verdict, runFrom, h1, h2]

/-! ## Batch transaction verdict

`fd_ed25519_verify_batch_single_msg` runs `fd_ed25519_verify` on each signature and collapses the
per-signature codes with `verdict` (`fd_ed25519_crc.h`). With `verify` the per-signature result,
the transaction accepts exactly when every signature verifies. -/

/-- A batch's transaction verdict accepts (`SUCCESS`) exactly when every signature in it returned
`SUCCESS`. -/
theorem verdict_accepts_iff_all_verify (verify : α → BitVec 32) (batch : List α) :
    verdict (batch.map verify) = SUCCESS ↔ ∀ item ∈ batch, verify item = SUCCESS := by
  rw [verdict_eq_success_iff]; simp

end

end MLIR.Firedancer.Crc.Ref.Verdict
