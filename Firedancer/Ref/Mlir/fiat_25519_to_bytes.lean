module

-- build/llvm23/mlir_canonicalized/ref/op/fiat_25519_to_bytes.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Firedancer.Ref.Mlir.fiat_25519_addcarryx_u51
public import Firedancer.Ref.Mlir.fiat_25519_cmovznz_u64
public import Firedancer.Ref.Mlir.fiat_25519_subborrowx_u51

meta import MLIR.Semantics.Func
meta import Firedancer.Ref.Mlir.fiat_25519_addcarryx_u51
meta import Firedancer.Ref.Mlir.fiat_25519_cmovznz_u64
meta import Firedancer.Ref.Mlir.fiat_25519_subborrowx_u51

namespace MLIR.Firedancer.Ref

@[expose] public section

mlir_def fiat_25519_to_bytes :=
#tbaa_root = #llvm.tbaa_root<id = "Simple C/C++ TBAA">
#tbaa_type_desc = #llvm.tbaa_type_desc<id = "omnipotent char", members = {<#tbaa_root, 0>}>
#tbaa_tag = #llvm.tbaa_tag<base_type = #tbaa_type_desc, access_type = #tbaa_type_desc, offset = 0>
#tbaa_type_desc1 = #llvm.tbaa_type_desc<id = "long", members = {<#tbaa_type_desc, 0>}>
#tbaa_tag1 = #llvm.tbaa_tag<base_type = #tbaa_type_desc1, access_type = #tbaa_type_desc1, offset = 0>
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nocapture, llvm.nofree, llvm.noundef, llvm.writeonly}, {llvm.nocapture, llvm.nofree, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<void (ptr, ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = readwrite, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"]], sym_name = "fiat_25519_to_bytes", target_cpu = "x86-64", target_features = #llvm.target_features<["+cmov", "+cx8", "+fxsr", "+mmx", "+sse", "+sse2", "+x87"]>, tune_cpu = "generic", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg20: !llvm.ptr, %arg21: !llvm.ptr):
  %63 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %64 = "llvm.mlir.constant"() <{value = 0 : i8}> : () -> i8
  %65 = "llvm.mlir.constant"() <{value = 2251799813685229 : i64}> : () -> i64
  %66 = "llvm.mlir.constant"() <{value = 8 : i64}> : () -> i64
  %67 = "llvm.mlir.constant"() <{value = 2251799813685247 : i64}> : () -> i64
  %68 = "llvm.mlir.constant"() <{value = 16 : i64}> : () -> i64
  %69 = "llvm.mlir.constant"() <{value = 24 : i64}> : () -> i64
  %70 = "llvm.mlir.constant"() <{value = 32 : i64}> : () -> i64
  %71 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %72 = "llvm.mlir.constant"() <{value = -1 : i64}> : () -> i64
  %73 = "llvm.mlir.constant"() <{value = 4 : i64}> : () -> i64
  %74 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %75 = "llvm.mlir.constant"() <{value = 6 : i64}> : () -> i64
  %76 = "llvm.mlir.constant"() <{value = 3 : i64}> : () -> i64
  %77 = "llvm.mlir.constant"() <{value = 40 : i64}> : () -> i64
  %78 = "llvm.mlir.constant"() <{value = 48 : i64}> : () -> i64
  %79 = "llvm.mlir.constant"() <{value = 255 : i64}> : () -> i64
  %80 = "llvm.mlir.constant"() <{value = 56 : i64}> : () -> i64
  %81 = "llvm.alloca"(%63) <{alignment = 8 : i64, elem_type = i64}> : (i32) -> !llvm.ptr
  %82 = "llvm.alloca"(%63) <{alignment = 1 : i64, elem_type = i8}> : (i32) -> !llvm.ptr
  %83 = "llvm.alloca"(%63) <{alignment = 8 : i64, elem_type = i64}> : (i32) -> !llvm.ptr
  %84 = "llvm.alloca"(%63) <{alignment = 1 : i64, elem_type = i8}> : (i32) -> !llvm.ptr
  %85 = "llvm.alloca"(%63) <{alignment = 8 : i64, elem_type = i64}> : (i32) -> !llvm.ptr
  %86 = "llvm.alloca"(%63) <{alignment = 1 : i64, elem_type = i8}> : (i32) -> !llvm.ptr
  %87 = "llvm.alloca"(%63) <{alignment = 8 : i64, elem_type = i64}> : (i32) -> !llvm.ptr
  %88 = "llvm.alloca"(%63) <{alignment = 1 : i64, elem_type = i8}> : (i32) -> !llvm.ptr
  %89 = "llvm.alloca"(%63) <{alignment = 8 : i64, elem_type = i64}> : (i32) -> !llvm.ptr
  %90 = "llvm.alloca"(%63) <{alignment = 1 : i64, elem_type = i8}> : (i32) -> !llvm.ptr
  %91 = "llvm.alloca"(%63) <{alignment = 8 : i64, elem_type = i64}> : (i32) -> !llvm.ptr
  %92 = "llvm.alloca"(%63) <{alignment = 8 : i64, elem_type = i64}> : (i32) -> !llvm.ptr
  %93 = "llvm.alloca"(%63) <{alignment = 1 : i64, elem_type = i8}> : (i32) -> !llvm.ptr
  %94 = "llvm.alloca"(%63) <{alignment = 8 : i64, elem_type = i64}> : (i32) -> !llvm.ptr
  %95 = "llvm.alloca"(%63) <{alignment = 1 : i64, elem_type = i8}> : (i32) -> !llvm.ptr
  %96 = "llvm.alloca"(%63) <{alignment = 8 : i64, elem_type = i64}> : (i32) -> !llvm.ptr
  %97 = "llvm.alloca"(%63) <{alignment = 1 : i64, elem_type = i8}> : (i32) -> !llvm.ptr
  %98 = "llvm.alloca"(%63) <{alignment = 8 : i64, elem_type = i64}> : (i32) -> !llvm.ptr
  %99 = "llvm.alloca"(%63) <{alignment = 1 : i64, elem_type = i8}> : (i32) -> !llvm.ptr
  %100 = "llvm.alloca"(%63) <{alignment = 8 : i64, elem_type = i64}> : (i32) -> !llvm.ptr
  %101 = "llvm.alloca"(%63) <{alignment = 1 : i64, elem_type = i8}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%81) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%82) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%83) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%84) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%85) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%86) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%87) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%88) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%89) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%90) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%91) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%92) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%93) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%94) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%95) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%96) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%97) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%98) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%99) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%100) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%101) : (!llvm.ptr) -> ()
  %102 = "llvm.load"(%arg21) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  "llvm.call"(%81, %82, %64, %102, %65) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef, llvm.zeroext}, {llvm.noundef}, {llvm.noundef}], callee = @fiat_25519_subborrowx_u51, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (!llvm.ptr, !llvm.ptr, i8, i64, i64) -> ()
  %103 = "llvm.load"(%82) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> i8
  %104 = "llvm.getelementptr"(%arg21) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %105 = "llvm.load"(%104) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  "llvm.call"(%83, %84, %103, %105, %67) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef, llvm.zeroext}, {llvm.noundef}, {llvm.noundef}], callee = @fiat_25519_subborrowx_u51, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (!llvm.ptr, !llvm.ptr, i8, i64, i64) -> ()
  %106 = "llvm.load"(%84) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> i8
  %107 = "llvm.getelementptr"(%arg21) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %108 = "llvm.load"(%107) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  "llvm.call"(%85, %86, %106, %108, %67) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef, llvm.zeroext}, {llvm.noundef}, {llvm.noundef}], callee = @fiat_25519_subborrowx_u51, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (!llvm.ptr, !llvm.ptr, i8, i64, i64) -> ()
  %109 = "llvm.load"(%86) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> i8
  %110 = "llvm.getelementptr"(%arg21) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %111 = "llvm.load"(%110) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  "llvm.call"(%87, %88, %109, %111, %67) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef, llvm.zeroext}, {llvm.noundef}, {llvm.noundef}], callee = @fiat_25519_subborrowx_u51, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (!llvm.ptr, !llvm.ptr, i8, i64, i64) -> ()
  %112 = "llvm.load"(%88) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> i8
  %113 = "llvm.getelementptr"(%arg21) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %114 = "llvm.load"(%113) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  "llvm.call"(%89, %90, %112, %114, %67) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef, llvm.zeroext}, {llvm.noundef}, {llvm.noundef}], callee = @fiat_25519_subborrowx_u51, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (!llvm.ptr, !llvm.ptr, i8, i64, i64) -> ()
  %115 = "llvm.load"(%90) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> i8
  "llvm.call"(%91, %115, %71, %72) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef, llvm.zeroext}, {llvm.noundef}, {llvm.noundef}], callee = @fiat_25519_cmovznz_u64, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 4, 0>}> : (!llvm.ptr, i8, i64, i64) -> ()
  %116 = "llvm.load"(%81) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %117 = "llvm.load"(%91) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %118 = "llvm.and"(%117, %65) : (i64, i64) -> i64
  "llvm.call"(%92, %93, %64, %116, %118) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef, llvm.zeroext}, {llvm.noundef}, {llvm.noundef}], callee = @fiat_25519_addcarryx_u51, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (!llvm.ptr, !llvm.ptr, i8, i64, i64) -> ()
  %119 = "llvm.load"(%93) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> i8
  %120 = "llvm.load"(%83) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %121 = "llvm.and"(%117, %67) : (i64, i64) -> i64
  "llvm.call"(%94, %95, %119, %120, %121) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef, llvm.zeroext}, {llvm.noundef}, {llvm.noundef}], callee = @fiat_25519_addcarryx_u51, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (!llvm.ptr, !llvm.ptr, i8, i64, i64) -> ()
  %122 = "llvm.load"(%95) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> i8
  %123 = "llvm.load"(%85) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  "llvm.call"(%96, %97, %122, %123, %121) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef, llvm.zeroext}, {llvm.noundef}, {llvm.noundef}], callee = @fiat_25519_addcarryx_u51, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (!llvm.ptr, !llvm.ptr, i8, i64, i64) -> ()
  %124 = "llvm.load"(%97) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> i8
  %125 = "llvm.load"(%87) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  "llvm.call"(%98, %99, %124, %125, %121) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef, llvm.zeroext}, {llvm.noundef}, {llvm.noundef}], callee = @fiat_25519_addcarryx_u51, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (!llvm.ptr, !llvm.ptr, i8, i64, i64) -> ()
  %126 = "llvm.load"(%99) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (!llvm.ptr) -> i8
  %127 = "llvm.load"(%89) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  "llvm.call"(%100, %101, %126, %127, %121) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<none>, arg_attrs = [{llvm.noundef}, {llvm.noundef}, {llvm.noundef, llvm.zeroext}, {llvm.noundef}, {llvm.noundef}], callee = @fiat_25519_addcarryx_u51, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = write, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 5, 0>}> : (!llvm.ptr, !llvm.ptr, i8, i64, i64) -> ()
  %128 = "llvm.load"(%100) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %129 = "llvm.shl"(%128, %73) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %130 = "llvm.load"(%98) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %131 = "llvm.shl"(%130, %74) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %132 = "llvm.load"(%96) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %133 = "llvm.shl"(%132, %75) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %134 = "llvm.load"(%94) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %135 = "llvm.shl"(%134, %76) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %136 = "llvm.load"(%92) <{alignment = 8 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag1]}> : (!llvm.ptr) -> i64
  %137 = "llvm.trunc"(%136) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %138 = "llvm.lshr"(%136, %66) : (i64, i64) -> i64
  %139 = "llvm.trunc"(%138) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %140 = "llvm.lshr"(%136, %68) : (i64, i64) -> i64
  %141 = "llvm.trunc"(%140) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %142 = "llvm.lshr"(%136, %69) : (i64, i64) -> i64
  %143 = "llvm.trunc"(%142) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %144 = "llvm.lshr"(%136, %70) : (i64, i64) -> i64
  %145 = "llvm.trunc"(%144) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %146 = "llvm.lshr"(%136, %77) : (i64, i64) -> i64
  %147 = "llvm.trunc"(%146) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %148 = "llvm.lshr"(%136, %78) : (i64, i64) -> i64
  %149 = "llvm.and"(%148, %79) : (i64, i64) -> i64
  %150 = "llvm.add"(%149, %135) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %151 = "llvm.trunc"(%150) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %152 = "llvm.lshr"(%150, %66) : (i64, i64) -> i64
  %153 = "llvm.trunc"(%152) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %154 = "llvm.lshr"(%150, %68) : (i64, i64) -> i64
  %155 = "llvm.trunc"(%154) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %156 = "llvm.lshr"(%150, %69) : (i64, i64) -> i64
  %157 = "llvm.trunc"(%156) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %158 = "llvm.lshr"(%150, %70) : (i64, i64) -> i64
  %159 = "llvm.trunc"(%158) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %160 = "llvm.lshr"(%150, %77) : (i64, i64) -> i64
  %161 = "llvm.trunc"(%160) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %162 = "llvm.lshr"(%150, %78) : (i64, i64) -> i64
  %163 = "llvm.and"(%162, %79) : (i64, i64) -> i64
  %164 = "llvm.add"(%163, %133) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %165 = "llvm.trunc"(%164) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %166 = "llvm.lshr"(%164, %66) : (i64, i64) -> i64
  %167 = "llvm.trunc"(%166) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %168 = "llvm.lshr"(%164, %68) : (i64, i64) -> i64
  %169 = "llvm.trunc"(%168) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %170 = "llvm.lshr"(%164, %69) : (i64, i64) -> i64
  %171 = "llvm.trunc"(%170) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %172 = "llvm.lshr"(%164, %70) : (i64, i64) -> i64
  %173 = "llvm.trunc"(%172) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %174 = "llvm.lshr"(%164, %77) : (i64, i64) -> i64
  %175 = "llvm.trunc"(%174) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %176 = "llvm.lshr"(%164, %78) : (i64, i64) -> i64
  %177 = "llvm.trunc"(%176) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %178 = "llvm.lshr"(%164, %80) : (i64, i64) -> i64
  %179 = "llvm.add"(%178, %131) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %180 = "llvm.trunc"(%179) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %181 = "llvm.lshr"(%179, %66) : (i64, i64) -> i64
  %182 = "llvm.trunc"(%181) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %183 = "llvm.lshr"(%179, %68) : (i64, i64) -> i64
  %184 = "llvm.trunc"(%183) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %185 = "llvm.lshr"(%179, %69) : (i64, i64) -> i64
  %186 = "llvm.trunc"(%185) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %187 = "llvm.lshr"(%179, %70) : (i64, i64) -> i64
  %188 = "llvm.trunc"(%187) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %189 = "llvm.lshr"(%179, %77) : (i64, i64) -> i64
  %190 = "llvm.trunc"(%189) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %191 = "llvm.lshr"(%179, %78) : (i64, i64) -> i64
  %192 = "llvm.and"(%191, %79) : (i64, i64) -> i64
  %193 = "llvm.add"(%192, %129) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %194 = "llvm.trunc"(%193) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %195 = "llvm.lshr"(%193, %66) : (i64, i64) -> i64
  %196 = "llvm.trunc"(%195) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %197 = "llvm.lshr"(%193, %68) : (i64, i64) -> i64
  %198 = "llvm.trunc"(%197) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %199 = "llvm.lshr"(%193, %69) : (i64, i64) -> i64
  %200 = "llvm.trunc"(%199) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %201 = "llvm.lshr"(%193, %70) : (i64, i64) -> i64
  %202 = "llvm.trunc"(%201) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %203 = "llvm.lshr"(%193, %77) : (i64, i64) -> i64
  %204 = "llvm.trunc"(%203) <{overflowFlags = 0 : i32}> : (i64) -> i8
  %205 = "llvm.lshr"(%193, %78) : (i64, i64) -> i64
  %206 = "llvm.trunc"(%205) <{overflowFlags = 0 : i32}> : (i64) -> i8
  "llvm.store"(%137, %arg20) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (i8, !llvm.ptr) -> ()
  %207 = "llvm.getelementptr"(%arg20) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%139, %207) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (i8, !llvm.ptr) -> ()
  %208 = "llvm.getelementptr"(%arg20) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 2>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%141, %208) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (i8, !llvm.ptr) -> ()
  %209 = "llvm.getelementptr"(%arg20) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 3>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%143, %209) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (i8, !llvm.ptr) -> ()
  %210 = "llvm.getelementptr"(%arg20) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 4>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%145, %210) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (i8, !llvm.ptr) -> ()
  %211 = "llvm.getelementptr"(%arg20) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 5>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%147, %211) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (i8, !llvm.ptr) -> ()
  %212 = "llvm.getelementptr"(%arg20) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 6>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%151, %212) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (i8, !llvm.ptr) -> ()
  %213 = "llvm.getelementptr"(%arg20) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 7>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%153, %213) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (i8, !llvm.ptr) -> ()
  %214 = "llvm.getelementptr"(%arg20) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%155, %214) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (i8, !llvm.ptr) -> ()
  %215 = "llvm.getelementptr"(%arg20) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 9>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%157, %215) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (i8, !llvm.ptr) -> ()
  %216 = "llvm.getelementptr"(%arg20) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 10>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%159, %216) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (i8, !llvm.ptr) -> ()
  %217 = "llvm.getelementptr"(%arg20) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 11>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%161, %217) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (i8, !llvm.ptr) -> ()
  %218 = "llvm.getelementptr"(%arg20) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 12>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%165, %218) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (i8, !llvm.ptr) -> ()
  %219 = "llvm.getelementptr"(%arg20) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 13>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%167, %219) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (i8, !llvm.ptr) -> ()
  %220 = "llvm.getelementptr"(%arg20) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 14>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%169, %220) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (i8, !llvm.ptr) -> ()
  %221 = "llvm.getelementptr"(%arg20) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 15>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%171, %221) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (i8, !llvm.ptr) -> ()
  %222 = "llvm.getelementptr"(%arg20) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%173, %222) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (i8, !llvm.ptr) -> ()
  %223 = "llvm.getelementptr"(%arg20) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 17>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%175, %223) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (i8, !llvm.ptr) -> ()
  %224 = "llvm.getelementptr"(%arg20) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 18>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%177, %224) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (i8, !llvm.ptr) -> ()
  %225 = "llvm.getelementptr"(%arg20) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 19>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%180, %225) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (i8, !llvm.ptr) -> ()
  %226 = "llvm.getelementptr"(%arg20) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 20>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%182, %226) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (i8, !llvm.ptr) -> ()
  %227 = "llvm.getelementptr"(%arg20) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 21>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%184, %227) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (i8, !llvm.ptr) -> ()
  %228 = "llvm.getelementptr"(%arg20) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 22>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%186, %228) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (i8, !llvm.ptr) -> ()
  %229 = "llvm.getelementptr"(%arg20) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 23>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%188, %229) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (i8, !llvm.ptr) -> ()
  %230 = "llvm.getelementptr"(%arg20) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%190, %230) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (i8, !llvm.ptr) -> ()
  %231 = "llvm.getelementptr"(%arg20) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 25>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%194, %231) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (i8, !llvm.ptr) -> ()
  %232 = "llvm.getelementptr"(%arg20) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 26>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%196, %232) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (i8, !llvm.ptr) -> ()
  %233 = "llvm.getelementptr"(%arg20) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 27>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%198, %233) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (i8, !llvm.ptr) -> ()
  %234 = "llvm.getelementptr"(%arg20) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 28>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%200, %234) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (i8, !llvm.ptr) -> ()
  %235 = "llvm.getelementptr"(%arg20) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 29>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%202, %235) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (i8, !llvm.ptr) -> ()
  %236 = "llvm.getelementptr"(%arg20) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 30>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%204, %236) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (i8, !llvm.ptr) -> ()
  %237 = "llvm.getelementptr"(%arg20) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 31>}> : (!llvm.ptr) -> !llvm.ptr
  "llvm.store"(%206, %237) <{alignment = 1 : i64, ordering = 0 : i64, tbaa = [#tbaa_tag]}> : (i8, !llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%101) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%100) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%99) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%98) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%97) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%96) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%95) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%94) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%93) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%92) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%91) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%90) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%89) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%88) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%87) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%86) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%85) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%84) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%83) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%82) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%81) : (!llvm.ptr) -> ()
  "llvm.return"() : () -> ()
}) : () -> ()
  with @fiat_25519_addcarryx_u51 := fiat_25519_addcarryx_u51,
    @fiat_25519_cmovznz_u64 := fiat_25519_cmovznz_u64,
    @fiat_25519_subborrowx_u51 := fiat_25519_subborrowx_u51

end

end MLIR.Firedancer.Ref
