module

-- boringssl-build/out/op/_ZN4bssl35FIPS_service_indicator_update_stateEv.mlir
-- bssl::FIPS_service_indicator_update_state()

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

namespace MLIR.Boringssl

@[expose] public section

mlir_def FIPS_service_indicator_update_state :=
"llvm.func"() <{CConv = #llvm.cconv<ccc>, dso_local, function_type = !llvm.func<void ()>, linkage = #llvm.linkage<internal>, no_inline, no_unwind, passthrough = ["mustprogress", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"], ["warn-stack-size", "25344"]], sym_name = "_ZN4bssl35FIPS_service_indicator_update_stateEv", target_cpu = "x86-64", target_features = #llvm.target_features<["+cmov", "+cx8", "+fxsr", "+mmx", "+sse", "+sse2", "+x87"]>, tune_cpu = "generic", unnamed_addr = 1 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
  "llvm.return"() : () -> ()
}) : () -> ()

end

end MLIR.Boringssl
