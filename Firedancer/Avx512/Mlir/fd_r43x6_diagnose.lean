module

-- build/llvm23/mlir_canonicalized/avx512/op/fd_r43x6_diagnose.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Firedancer.Avx512.Mlir.fd_int_if
public import Firedancer.Avx512.Mlir.fd_long_if

meta import MLIR.Semantics.Func
meta import Firedancer.Avx512.Mlir.fd_int_if
meta import Firedancer.Avx512.Mlir.fd_long_if

namespace MLIR.Firedancer.Avx512

@[expose] public section

mlir_def fd_r43x6_diagnose :=
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.noundef}], dso_local, function_type = !llvm.func<i32 (vector<8xi64>)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", ["min-legal-vector-width", "512"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "icelake-server"]], res_attrs = [{llvm.noundef, llvm.range = #llvm.constant_range<i32, -1, 2>}], sym_name = "fd_r43x6_diagnose", target_cpu = "icelake-server", target_features = #llvm.target_features<["+adx", "+aes", "+avx", "+avx2", "+avx512bitalg", "+avx512bw", "+avx512cd", "+avx512dq", "+avx512f", "+avx512ifma", "+avx512vbmi", "+avx512vbmi2", "+avx512vl", "+avx512vnni", "+avx512vpopcntdq", "+bmi", "+bmi2", "+clflushopt", "+clwb", "+cmov", "+crc32", "+cx16", "+cx8", "+f16c", "+fma", "+fsgsbase", "+fxsr", "+gfni", "+invpcid", "+lzcnt", "+mmx", "+movbe", "+pclmul", "+pconfig", "+pku", "+popcnt", "+prfchw", "+rdpid", "+rdrnd", "+rdseed", "+sahf", "+sgx", "+sha", "+sse", "+sse2", "+sse3", "+sse4.1", "+sse4.2", "+ssse3", "+vaes", "+vpclmulqdq", "+wbnoinvd", "+x87", "+xsave", "+xsavec", "+xsaveopt", "+xsaves"]>, unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg23: vector<8xi64>):
  %129 = "llvm.mlir.constant"() <{value = 0 : i64}> : () -> i64
  %130 = "llvm.mlir.constant"() <{value = 1 : i64}> : () -> i64
  %131 = "llvm.mlir.constant"() <{value = 2 : i64}> : () -> i64
  %132 = "llvm.mlir.constant"() <{value = 3 : i64}> : () -> i64
  %133 = "llvm.mlir.constant"() <{value = 4 : i64}> : () -> i64
  %134 = "llvm.mlir.constant"() <{value = 5 : i64}> : () -> i64
  %135 = "llvm.mlir.constant"() <{value = -1048576 : i64}> : () -> i64
  %136 = "llvm.mlir.constant"() <{value = 40 : i64}> : () -> i64
  %137 = "llvm.mlir.constant"() <{value = 1099511627775 : i64}> : () -> i64
  %138 = "llvm.mlir.constant"() <{value = 19 : i64}> : () -> i64
  %139 = "llvm.mlir.constant"() <{value = 43 : i64}> : () -> i64
  %140 = "llvm.mlir.constant"() <{value = 8796093022207 : i64}> : () -> i64
  %141 = "llvm.mlir.constant"() <{value = 1048576 : i64}> : () -> i64
  %142 = "llvm.mlir.constant"() <{value = 1099511627776 : i64}> : () -> i64
  %143 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %144 = "llvm.extractelement"(%arg23, %129) : (vector<8xi64>, i64) -> i64
  %145 = "llvm.extractelement"(%arg23, %130) : (vector<8xi64>, i64) -> i64
  %146 = "llvm.extractelement"(%arg23, %131) : (vector<8xi64>, i64) -> i64
  %147 = "llvm.extractelement"(%arg23, %132) : (vector<8xi64>, i64) -> i64
  %148 = "llvm.extractelement"(%arg23, %133) : (vector<8xi64>, i64) -> i64
  %149 = "llvm.extractelement"(%arg23, %134) : (vector<8xi64>, i64) -> i64
  %150 = "llvm.add"(%149, %135) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %151 = "llvm.ashr"(%150, %136) : (i64, i64) -> i64
  %152 = "llvm.and"(%150, %137) : (i64, i64) -> i64
  %153 = "llvm.mul"(%151, %138) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %154 = "llvm.add"(%153, %144) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %155 = "llvm.ashr"(%154, %139) : (i64, i64) -> i64
  %156 = "llvm.and"(%154, %140) : (i64, i64) -> i64
  %157 = "llvm.add"(%155, %145) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %158 = "llvm.ashr"(%157, %139) : (i64, i64) -> i64
  %159 = "llvm.and"(%157, %140) : (i64, i64) -> i64
  %160 = "llvm.add"(%158, %146) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %161 = "llvm.ashr"(%160, %139) : (i64, i64) -> i64
  %162 = "llvm.and"(%160, %140) : (i64, i64) -> i64
  %163 = "llvm.add"(%161, %147) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %164 = "llvm.ashr"(%163, %139) : (i64, i64) -> i64
  %165 = "llvm.and"(%163, %140) : (i64, i64) -> i64
  %166 = "llvm.add"(%164, %148) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %167 = "llvm.ashr"(%166, %139) : (i64, i64) -> i64
  %168 = "llvm.and"(%166, %140) : (i64, i64) -> i64
  %169 = "llvm.add"(%156, %138) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %170 = "llvm.lshr"(%169, %139) : (i64, i64) -> i64
  %171 = "llvm.and"(%169, %140) : (i64, i64) -> i64
  %172 = "llvm.add"(%159, %170) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %173 = "llvm.lshr"(%172, %139) : (i64, i64) -> i64
  %174 = "llvm.and"(%172, %140) : (i64, i64) -> i64
  %175 = "llvm.add"(%162, %173) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %176 = "llvm.lshr"(%175, %139) : (i64, i64) -> i64
  %177 = "llvm.and"(%175, %140) : (i64, i64) -> i64
  %178 = "llvm.add"(%165, %176) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %179 = "llvm.lshr"(%178, %139) : (i64, i64) -> i64
  %180 = "llvm.and"(%178, %140) : (i64, i64) -> i64
  %181 = "llvm.add"(%168, %179) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %182 = "llvm.lshr"(%181, %139) : (i64, i64) -> i64
  %183 = "llvm.and"(%181, %140) : (i64, i64) -> i64
  %184 = "llvm.add"(%152, %141) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %185 = "llvm.add"(%184, %167) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %186 = "llvm.add"(%185, %182) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %187 = "llvm.and"(%186, %137) : (i64, i64) -> i64
  %188 = "llvm.icmp"(%186, %142) <{predicate = 6 : i64}> : (i64, i64) -> i1
  %189 = "llvm.zext"(%188) : (i1) -> i32
  %190 = "llvm.call"(%189) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @fd_long_if, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>}> : (i32) -> i64
  %191 = "llvm.sub"(%171, %190) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %192 = "llvm.ashr"(%191, %139) : (i64, i64) -> i64
  %193 = "llvm.add"(%192, %174) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %194 = "llvm.ashr"(%193, %139) : (i64, i64) -> i64
  %195 = "llvm.add"(%194, %177) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %196 = "llvm.ashr"(%195, %139) : (i64, i64) -> i64
  %197 = "llvm.add"(%196, %180) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %198 = "llvm.ashr"(%197, %139) : (i64, i64) -> i64
  %199 = "llvm.add"(%198, %183) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %200 = "llvm.ashr"(%199, %139) : (i64, i64) -> i64
  %201 = "llvm.add"(%200, %187) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %202 = "llvm.or"(%193, %191) : (i64, i64) -> i64
  %203 = "llvm.or"(%202, %195) : (i64, i64) -> i64
  %204 = "llvm.or"(%203, %197) : (i64, i64) -> i64
  %205 = "llvm.or"(%204, %199) : (i64, i64) -> i64
  %206 = "llvm.and"(%205, %140) : (i64, i64) -> i64
  %207 = "llvm.or"(%206, %201) : (i64, i64) -> i64
  %208 = "llvm.icmp"(%207, %129) <{predicate = 0 : i64}> : (i64, i64) -> i1
  %209 = "llvm.zext"(%208) : (i1) -> i32
  %210 = "llvm.trunc"(%191) <{overflowFlags = 0 : i32}> : (i64) -> i32
  %211 = "llvm.and"(%210, %143) : (i32, i32) -> i32
  %212 = "llvm.call"(%209, %211) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_int_if, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (i32, i32) -> i32
  "llvm.return"(%212) : (i32) -> ()
}) : () -> ()
  with @fd_int_if := fd_int_if, @fd_long_if := fd_long_if

end

end MLIR.Firedancer.Avx512
