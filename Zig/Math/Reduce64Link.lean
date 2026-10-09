module

public import Zig.Verifier_verify
public import Zig.scalar_reduce64

namespace MLIR.Zig

/-- `scalar.reduce64`'s call, as `Verifier.verify` takes it. -/
public theorem reduce64Call : Reduce64Call := by
  intro out p s hwf hout hp _ hpo _
  rw [scalar_reduce64.call_eq out p s hwf hout hp hpo, scalar.reduce64.spec_eq]
  rfl

end MLIR.Zig
