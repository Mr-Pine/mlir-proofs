module

public import Agave.Avx2.EXTENDEDPOINT_IDENTITY

meta import Agave.Avx2.EXTENDEDPOINT_IDENTITY

namespace MLIR.Agave.Avx2

#guard
  (List.finRange 5).all fun k =>
    Fe2625x4.ofBits (Ty.flatBits (t := .array 160 (.bv 8)) EXTENDEDPOINT_IDENTITY.lit (hw := rfl))
        k ==
      EXTENDEDPOINT_IDENTITY.point k

end MLIR.Agave.Avx2
