module

-- sodium-build/out/op/crypto_verify_n.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

namespace MLIR.Sodium

@[expose] public section

mlir_def crypto_verify_n :=
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.nonnull, llvm.noundef}, {llvm.nonnull, llvm.noundef}, {llvm.noundef, llvm.range = #llvm.constant_range<i32, 16, 65>}], dso_local, function_type = !llvm.func<i32 (ptr, ptr, i32)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = read, argMem = read, inaccessibleMem = readwrite, errnoMem = read, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["nofree", "norecurse", "nosync", "ssp", ["min-legal-vector-width", "128"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"]], res_attrs = [{llvm.range = #llvm.constant_range<i32, -1, 65535>}], sym_name = "crypto_verify_n", target_cpu = "x86-64", target_features = #llvm.target_features<["+cmov", "+cx8", "+fxsr", "+mmx", "+sse", "+sse2", "+x87"]>, tune_cpu = "generic", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64}> ({
^bb0(%arg12: !llvm.ptr, %arg13: !llvm.ptr, %arg14: i32):
  %161 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %162 = "llvm.mlir.constant"() <{value = 31 : i32}> : () -> i32
  %163 = "llvm.mlir.constant"() <{value = 4 : i32}> : () -> i32
  %164 = "llvm.mlir.constant"() <{value = 2 : i32}> : () -> i32
  %165 = "llvm.mlir.constant"() <{value = 3 : i32}> : () -> i32
  %166 = "llvm.mlir.constant"() <{value = dense<0> : vector<4xi32>}> : () -> vector<4xi32>
  %167 = "llvm.mlir.constant"() <{value = dense<0> : vector<16xi8>}> : () -> vector<16xi8>
  %168 = "llvm.mlir.constant"() <{value = dense<0> : vector<2xi64>}> : () -> vector<2xi64>
  %169 = "llvm.mlir.constant"() <{value = 16 : i32}> : () -> i32
  %170 = "llvm.mlir.constant"() <{value = -1 : i32}> : () -> i32
  %171 = "llvm.alloca"(%161) <{alignment = 16 : i64, elem_type = vector<2xi64>}> : (i32) -> !llvm.ptr
  %172 = "llvm.alloca"(%161) <{alignment = 16 : i64, elem_type = vector<2xi64>}> : (i32) -> !llvm.ptr
  %173 = "llvm.alloca"(%161) <{alignment = 16 : i64, elem_type = vector<2xi64>}> : (i32) -> !llvm.ptr
  %174 = "llvm.alloca"(%161) <{alignment = 4 : i64, elem_type = i32}> : (i32) -> !llvm.ptr
  %175 = "llvm.alloca"(%161) <{alignment = 8 : i64, elem_type = !llvm.ptr}> : (i32) -> !llvm.ptr
  %176 = "llvm.alloca"(%161) <{alignment = 8 : i64, elem_type = !llvm.ptr}> : (i32) -> !llvm.ptr
  "llvm.intr.lifetime.start"(%171) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%172) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%173) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%174) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%175) : (!llvm.ptr) -> ()
  "llvm.store"(%arg12, %175) <{alignment = 8 : i64, ordering = 0 : i64, volatile_}> : (!llvm.ptr, !llvm.ptr) -> ()
  "llvm.intr.lifetime.start"(%176) : (!llvm.ptr) -> ()
  "llvm.store"(%arg13, %176) <{alignment = 8 : i64, ordering = 0 : i64, volatile_}> : (!llvm.ptr, !llvm.ptr) -> ()
  %177 = "llvm.load"(%175) <{alignment = 8 : i64, ordering = 0 : i64, volatile_}> : (!llvm.ptr) -> !llvm.ptr
  %178 = "llvm.load"(%177) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<2xi64>
  "llvm.store"(%178, %171) <{alignment = 16 : i64, ordering = 0 : i64, volatile_}> : (vector<2xi64>, !llvm.ptr) -> ()
  %179 = "llvm.load"(%176) <{alignment = 8 : i64, ordering = 0 : i64, volatile_}> : (!llvm.ptr) -> !llvm.ptr
  %180 = "llvm.load"(%179) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<2xi64>
  "llvm.store"(%180, %172) <{alignment = 16 : i64, ordering = 0 : i64, volatile_}> : (vector<2xi64>, !llvm.ptr) -> ()
  %181 = "llvm.load"(%171) <{alignment = 16 : i64, ordering = 0 : i64, volatile_}> : (!llvm.ptr) -> vector<2xi64>
  %182 = "llvm.load"(%172) <{alignment = 16 : i64, ordering = 0 : i64, volatile_}> : (!llvm.ptr) -> vector<2xi64>
  %183 = "llvm.xor"(%182, %181) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  "llvm.store"(%183, %173) <{alignment = 16 : i64, ordering = 0 : i64, volatile_}> : (vector<2xi64>, !llvm.ptr) -> ()
  %184 = "llvm.icmp"(%arg14, %162) <{predicate = 8 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%184)[^bb1, ^bb4] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb1:  // pred: ^bb0
  %185 = "llvm.lshr"(%arg14, %163) : (i32, i32) -> i32
  %186 = "llvm.load"(%175) <{alignment = 8 : i64, ordering = 0 : i64, volatile_}> : (!llvm.ptr) -> !llvm.ptr
  %187 = "llvm.getelementptr"(%186) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %188 = "llvm.load"(%187) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<2xi64>
  "llvm.store"(%188, %171) <{alignment = 16 : i64, ordering = 0 : i64, volatile_}> : (vector<2xi64>, !llvm.ptr) -> ()
  %189 = "llvm.load"(%176) <{alignment = 8 : i64, ordering = 0 : i64, volatile_}> : (!llvm.ptr) -> !llvm.ptr
  %190 = "llvm.getelementptr"(%189) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %191 = "llvm.load"(%190) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<2xi64>
  "llvm.store"(%191, %172) <{alignment = 16 : i64, ordering = 0 : i64, volatile_}> : (vector<2xi64>, !llvm.ptr) -> ()
  %192 = "llvm.load"(%173) <{alignment = 16 : i64, ordering = 0 : i64, volatile_}> : (!llvm.ptr) -> vector<2xi64>
  %193 = "llvm.load"(%171) <{alignment = 16 : i64, ordering = 0 : i64, volatile_}> : (!llvm.ptr) -> vector<2xi64>
  %194 = "llvm.load"(%172) <{alignment = 16 : i64, ordering = 0 : i64, volatile_}> : (!llvm.ptr) -> vector<2xi64>
  %195 = "llvm.xor"(%194, %193) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %196 = "llvm.or"(%195, %192) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  "llvm.store"(%196, %173) <{alignment = 16 : i64, ordering = 0 : i64, volatile_}> : (vector<2xi64>, !llvm.ptr) -> ()
  %197 = "llvm.icmp"(%185, %164) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%197)[^bb4, ^bb2] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb2:  // pred: ^bb1
  %198 = "llvm.load"(%175) <{alignment = 8 : i64, ordering = 0 : i64, volatile_}> : (!llvm.ptr) -> !llvm.ptr
  %199 = "llvm.getelementptr"(%198) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %200 = "llvm.load"(%199) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<2xi64>
  "llvm.store"(%200, %171) <{alignment = 16 : i64, ordering = 0 : i64, volatile_}> : (vector<2xi64>, !llvm.ptr) -> ()
  %201 = "llvm.load"(%176) <{alignment = 8 : i64, ordering = 0 : i64, volatile_}> : (!llvm.ptr) -> !llvm.ptr
  %202 = "llvm.getelementptr"(%201) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 32>}> : (!llvm.ptr) -> !llvm.ptr
  %203 = "llvm.load"(%202) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<2xi64>
  "llvm.store"(%203, %172) <{alignment = 16 : i64, ordering = 0 : i64, volatile_}> : (vector<2xi64>, !llvm.ptr) -> ()
  %204 = "llvm.load"(%173) <{alignment = 16 : i64, ordering = 0 : i64, volatile_}> : (!llvm.ptr) -> vector<2xi64>
  %205 = "llvm.load"(%171) <{alignment = 16 : i64, ordering = 0 : i64, volatile_}> : (!llvm.ptr) -> vector<2xi64>
  %206 = "llvm.load"(%172) <{alignment = 16 : i64, ordering = 0 : i64, volatile_}> : (!llvm.ptr) -> vector<2xi64>
  %207 = "llvm.xor"(%206, %205) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %208 = "llvm.or"(%207, %204) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  "llvm.store"(%208, %173) <{alignment = 16 : i64, ordering = 0 : i64, volatile_}> : (vector<2xi64>, !llvm.ptr) -> ()
  %209 = "llvm.icmp"(%185, %165) <{predicate = 0 : i64}> : (i32, i32) -> i1
  "llvm.cond_br"(%209)[^bb4, ^bb3] <{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()
^bb3:  // pred: ^bb2
  %210 = "llvm.load"(%175) <{alignment = 8 : i64, ordering = 0 : i64, volatile_}> : (!llvm.ptr) -> !llvm.ptr
  %211 = "llvm.getelementptr"(%210) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 48>}> : (!llvm.ptr) -> !llvm.ptr
  %212 = "llvm.load"(%211) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<2xi64>
  "llvm.store"(%212, %171) <{alignment = 16 : i64, ordering = 0 : i64, volatile_}> : (vector<2xi64>, !llvm.ptr) -> ()
  %213 = "llvm.load"(%176) <{alignment = 8 : i64, ordering = 0 : i64, volatile_}> : (!llvm.ptr) -> !llvm.ptr
  %214 = "llvm.getelementptr"(%213) <{elem_type = i8, noWrapFlags = 0 : i32, rawConstantIndices = array<i32: 48>}> : (!llvm.ptr) -> !llvm.ptr
  %215 = "llvm.load"(%214) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> vector<2xi64>
  "llvm.store"(%215, %172) <{alignment = 16 : i64, ordering = 0 : i64, volatile_}> : (vector<2xi64>, !llvm.ptr) -> ()
  %216 = "llvm.load"(%173) <{alignment = 16 : i64, ordering = 0 : i64, volatile_}> : (!llvm.ptr) -> vector<2xi64>
  %217 = "llvm.load"(%171) <{alignment = 16 : i64, ordering = 0 : i64, volatile_}> : (!llvm.ptr) -> vector<2xi64>
  %218 = "llvm.load"(%172) <{alignment = 16 : i64, ordering = 0 : i64, volatile_}> : (!llvm.ptr) -> vector<2xi64>
  %219 = "llvm.xor"(%218, %217) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  %220 = "llvm.or"(%219, %216) : (vector<2xi64>, vector<2xi64>) -> vector<2xi64>
  "llvm.store"(%220, %173) <{alignment = 16 : i64, ordering = 0 : i64, volatile_}> : (vector<2xi64>, !llvm.ptr) -> ()
  "llvm.br"()[^bb4] : () -> ()
^bb4:  // 4 preds: ^bb0, ^bb1, ^bb2, ^bb3
  %221 = "llvm.load"(%173) <{alignment = 16 : i64, ordering = 0 : i64, volatile_}> : (!llvm.ptr) -> vector<2xi64>
  %222 = "llvm.bitcast"(%221) : (vector<2xi64>) -> vector<4xi32>
  %223 = "llvm.icmp"(%222, %166) <{predicate = 0 : i64}> : (vector<4xi32>, vector<4xi32>) -> vector<4xi1>
  %224 = "llvm.sext"(%223) : (vector<4xi1>) -> vector<4xi32>
  %225 = "llvm.bitcast"(%224) : (vector<4xi32>) -> vector<16xi8>
  %226 = "llvm.icmp"(%225, %167) <{predicate = 2 : i64}> : (vector<16xi8>, vector<16xi8>) -> vector<16xi1>
  %227 = "llvm.bitcast"(%226) : (vector<16xi1>) -> i16
  %228 = "llvm.zext"(%227) : (i16) -> i32
  "llvm.store"(%228, %174) <{alignment = 4 : i64, ordering = 0 : i64, volatile_}> : (i32, !llvm.ptr) -> ()
  "llvm.store"(%168, %171) <{alignment = 16 : i64, ordering = 0 : i64, volatile_}> : (vector<2xi64>, !llvm.ptr) -> ()
  "llvm.store"(%168, %172) <{alignment = 16 : i64, ordering = 0 : i64, volatile_}> : (vector<2xi64>, !llvm.ptr) -> ()
  "llvm.store"(%168, %173) <{alignment = 16 : i64, ordering = 0 : i64, volatile_}> : (vector<2xi64>, !llvm.ptr) -> ()
  %229 = "llvm.load"(%174) <{alignment = 4 : i64, ordering = 0 : i64, volatile_}> : (!llvm.ptr) -> i32
  %230 = "llvm.add"(%229, %161) <{overflowFlags = 0 : i32}> : (i32, i32) -> i32
  %231 = "llvm.lshr"(%230, %169) : (i32, i32) -> i32
  %232 = "llvm.add"(%231, %170) <{overflowFlags = 1 : i32}> : (i32, i32) -> i32
  "llvm.intr.lifetime.end"(%176) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%175) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%174) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%173) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%172) : (!llvm.ptr) -> ()
  "llvm.intr.lifetime.end"(%171) : (!llvm.ptr) -> ()
  "llvm.return"(%232) : (i32) -> ()
}) : () -> ()

end

end MLIR.Sodium
