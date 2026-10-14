import Lake
open Lake DSL System
open Lean (Name)

package «mlir-firedancer»

-- Firedancer's ed25519 verify (ref), lifted to the register-based IR and proved.
require MLIR from "../lean-mlir"

require mathlib from git
  "https://github.com/leanprover-community/mathlib4-nightly-testing" @ "nightly-testing-2026-09-16"

/-- The modules under `root` (and `root` itself, if it exists), keeping (`tests`) or dropping
(`!tests`) those inside a `Tests` directory. Globs can't exclude, hence the walk. -/
unsafe def modulesImpl (dir : FilePath) (root : Name) (tests : Bool) : Array Glob :=
  match unsafeBaseIO (go.toBaseIO) with
  | .ok mods => mods
  | .error e => panic! s!"lakefile: listing {root}: {e}"
where
  go : IO (Array Glob) := do
    let base := dir / root.toString
    let rootFile := base.addExtension "lean"
    let mut mods := if !tests && (← rootFile.pathExists) then #[.one root] else #[]
    let paths : Array FilePath ←
      base.walkDir (enter := fun d => pure (tests || d.fileName != some "Tests"))
    for p in paths do
      if p.extension != some "lean" then continue
      let rel : List String := (p.withExtension "").components.drop dir.components.length
      if tests == rel.contains "Tests" then mods := mods.push (.one (rel.foldl .str .anonymous))
    return mods

/-- Read whenever Lake loads the package, so new files need no reconfigure. -/
@[implemented_by modulesImpl]
opaque modules (dir : FilePath) (root : Name) (tests : Bool) : Array Glob

def libs : Array Name := #[`Ed25519, `Firedancer, `Zig, `Agave, `Boringssl, `Sodium]

-- Ed25519 as mathematics: the field, the curve's group, SHA-512, decoding, verification.
@[default_target]
lean_lib Ed25519 where
  globs := modules __dir__ `Ed25519 false

-- Every module, not just the root's imports; the same for the ports below.
@[default_target]
lean_lib Firedancer where
  globs := modules __dir__ `Firedancer false

-- Zig std's ed25519 verify, lifted from `zig-build/out/op` and proved.
@[default_target]
lean_lib Zig where
  globs := modules __dir__ `Zig false

-- Agave's ed25519 verify (solana-ed25519), lifted from `agave-build/out/*/op` and proved.
@[default_target]
lean_lib Agave where
  globs := modules __dir__ `Agave false

-- BoringSSL's ED25519_verify, lifted from `boringssl-build/out/op` and proved.
@[default_target]
lean_lib Boringssl where
  globs := modules __dir__ `Boringssl false

-- libsodium's crypto_sign_ed25519_verify_detached, lifted from `sodium-build/out/op` and proved.
@[default_target]
lean_lib Sodium where
  globs := modules __dir__ `Sodium false

-- The `Tests` directories of every port above: `lake build Tests`.
lean_lib Tests where
  roots := #[]
  globs := libs.flatMap (modules __dir__ · true)
