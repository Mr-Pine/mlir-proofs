module

public import Firedancer.R52x5.Common.Fe

/-! The carry fold crc's generated avx512 kernels end with. It is `fd_f25519_fold_unsigned` with
`FD_F25519_LIMB_MASK` and the shift `51` broadcast to all eight lanes, so lanes 5-7 keep their low
51 bits rather than being zeroed; on an element with lanes 5-7 zero the two agree. -/

namespace MLIR.Firedancer.Crc

open Firedancer.Avx512
open R52x5 (mask51 foldPerm foldScale fold)

@[expose] public section

/-- `t2 … t6` of `fd_r52x5_add`: each lane's carry above bit 51 into the next lane, lane 4's
times 19 into lane 0. -/
def crcFold (x : Wwl) : Wwl :=
  wwl_madd52lo (wwl_and x (wwl_bcast mask51)) (wwl_permute foldPerm (wwl_shru x 51)) foldScale

end

end MLIR.Firedancer.Crc
