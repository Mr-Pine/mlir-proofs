module

public import Firedancer.Ref.fd_sha512_append
public import Firedancer.R52x5.fd_sha512_init

meta import Firedancer.Ref.fd_sha512_append
meta import Firedancer.R52x5.fd_sha512_init

namespace MLIR.Firedancer.R52x5

private def sha : Pointer :=
  ⟨⟨0⟩, 0⟩

/-- One 256-byte block of `0xaa` bytes. -/
private def state : GlobalState :=
  ⟨⟨1⟩, ⟨Std.ExtHashMap.ofList [(⟨0⟩, .ofBytes 256 ((0xaa#8).replicate 256))]⟩⟩

-- the struct the spec's stores leave: `sha512IV`, nothing buffered or counted, the rest untouched
#guard
  match fd_sha512_init.eval 1 (fd_sha512_init.args (.value sha)) state with
  | .value (some (.cons r .nil), s) =>
    let v := s.mem.readSha sha
    r == .value sha && v.buf == (0xaa#8).replicate 128 && v.state == Ref.sha512IV &&
      v.bufUsed == 0 &&
      v.bitCntLo == 0 &&
      v.bitCntHi == 0 &&
      s.mem.readAt sha 2048 ==
        (((((((((state.mem.storeAt (sha.add 128#64) Ref.sha512IV[0]).storeAt (sha.add 136#64)
                                          Ref.sha512IV[1]).storeAt
                                      (sha.add 144#64) Ref.sha512IV[2]).storeAt
                                  (sha.add 152#64) Ref.sha512IV[3]).storeAt
                              (sha.add 160#64) Ref.sha512IV[4]).storeAt
                          (sha.add 168#64) Ref.sha512IV[5]).storeAt
                      (sha.add 176#64) Ref.sha512IV[6]).storeAt
                  (sha.add 184#64) Ref.sha512IV[7]).storeAt
              (sha.add 200#64) ((0#8).replicate 24)).readAt
          sha 2048
  | _ => false

end MLIR.Firedancer.R52x5
