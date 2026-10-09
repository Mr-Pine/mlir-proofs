module

-- build/llvm23/mlir_canonicalized/avx512/op/fd_r43x6_diagnose.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab
public import Firedancer.Avx512.Mlir.fd_int_if

meta import MLIR.Semantics.Func
meta import Firedancer.Avx512.Mlir.fd_int_if

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
  %143 = "llvm.mlir.constant"() <{value = -19 : i64}> : () -> i64
  %144 = "llvm.mlir.constant"() <{value = 1 : i32}> : () -> i32
  %145 = "llvm.extractelement"(%arg23, %129) : (vector<8xi64>, i64) -> i64
  %146 = "llvm.extractelement"(%arg23, %130) : (vector<8xi64>, i64) -> i64
  %147 = "llvm.extractelement"(%arg23, %131) : (vector<8xi64>, i64) -> i64
  %148 = "llvm.extractelement"(%arg23, %132) : (vector<8xi64>, i64) -> i64
  %149 = "llvm.extractelement"(%arg23, %133) : (vector<8xi64>, i64) -> i64
  %150 = "llvm.extractelement"(%arg23, %134) : (vector<8xi64>, i64) -> i64
  %151 = "llvm.add"(%150, %135) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %152 = "llvm.ashr"(%151, %136) : (i64, i64) -> i64
  %153 = "llvm.and"(%151, %137) : (i64, i64) -> i64
  %154 = "llvm.mul"(%152, %138) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %155 = "llvm.add"(%154, %145) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %156 = "llvm.ashr"(%155, %139) : (i64, i64) -> i64
  %157 = "llvm.and"(%155, %140) : (i64, i64) -> i64
  %158 = "llvm.add"(%156, %146) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %159 = "llvm.ashr"(%158, %139) : (i64, i64) -> i64
  %160 = "llvm.and"(%158, %140) : (i64, i64) -> i64
  %161 = "llvm.add"(%159, %147) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %162 = "llvm.ashr"(%161, %139) : (i64, i64) -> i64
  %163 = "llvm.and"(%161, %140) : (i64, i64) -> i64
  %164 = "llvm.add"(%162, %148) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %165 = "llvm.ashr"(%164, %139) : (i64, i64) -> i64
  %166 = "llvm.and"(%164, %140) : (i64, i64) -> i64
  %167 = "llvm.add"(%165, %149) <{overflowFlags = 0 : i32}> : (i64, i64) -> i64
  %168 = "llvm.ashr"(%167, %139) : (i64, i64) -> i64
  %169 = "llvm.and"(%167, %140) : (i64, i64) -> i64
  %170 = "llvm.add"(%157, %138) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %171 = "llvm.lshr"(%170, %139) : (i64, i64) -> i64
  %172 = "llvm.and"(%170, %140) : (i64, i64) -> i64
  %173 = "llvm.add"(%160, %171) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %174 = "llvm.lshr"(%173, %139) : (i64, i64) -> i64
  %175 = "llvm.and"(%173, %140) : (i64, i64) -> i64
  %176 = "llvm.add"(%163, %174) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %177 = "llvm.lshr"(%176, %139) : (i64, i64) -> i64
  %178 = "llvm.and"(%176, %140) : (i64, i64) -> i64
  %179 = "llvm.add"(%166, %177) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %180 = "llvm.lshr"(%179, %139) : (i64, i64) -> i64
  %181 = "llvm.and"(%179, %140) : (i64, i64) -> i64
  %182 = "llvm.add"(%169, %180) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %183 = "llvm.lshr"(%182, %139) : (i64, i64) -> i64
  %184 = "llvm.and"(%182, %140) : (i64, i64) -> i64
  %185 = "llvm.add"(%153, %141) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %186 = "llvm.add"(%185, %168) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %187 = "llvm.add"(%186, %183) <{overflowFlags = 3 : i32}> : (i64, i64) -> i64
  %188 = "llvm.and"(%187, %137) : (i64, i64) -> i64
  %189 = "llvm.icmp"(%187, %142) <{predicate = 6 : i64}> : (i64, i64) -> i1
  %190 = "llvm.select"(%189, %143, %129) <{fastmathFlags = #llvm.fastmath<none>}> : (i1, i64, i64) -> i64
  %191 = "llvm.add"(%190, %172) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %192 = "llvm.ashr"(%191, %139) : (i64, i64) -> i64
  %193 = "llvm.add"(%192, %175) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %194 = "llvm.ashr"(%193, %139) : (i64, i64) -> i64
  %195 = "llvm.add"(%194, %178) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %196 = "llvm.ashr"(%195, %139) : (i64, i64) -> i64
  %197 = "llvm.add"(%196, %181) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %198 = "llvm.ashr"(%197, %139) : (i64, i64) -> i64
  %199 = "llvm.add"(%198, %184) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %200 = "llvm.ashr"(%199, %139) : (i64, i64) -> i64
  %201 = "llvm.add"(%200, %188) <{overflowFlags = 1 : i32}> : (i64, i64) -> i64
  %202 = "llvm.or"(%193, %191) : (i64, i64) -> i64
  %203 = "llvm.or"(%202, %195) : (i64, i64) -> i64
  %204 = "llvm.or"(%203, %197) : (i64, i64) -> i64
  %205 = "llvm.or"(%204, %199) : (i64, i64) -> i64
  %206 = "llvm.and"(%205, %140) : (i64, i64) -> i64
  %207 = "llvm.or"(%206, %201) : (i64, i64) -> i64
  %208 = "llvm.icmp"(%207, %129) <{predicate = 0 : i64}> : (i64, i64) -> i1
  %209 = "llvm.zext"(%208) : (i1) -> i32
  %210 = "llvm.trunc"(%191) <{overflowFlags = 0 : i32}> : (i64) -> i32
  %211 = "llvm.and"(%210, %144) : (i32, i32) -> i32
  %212 = "llvm.call"(%209, %211) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}, {llvm.noundef}], callee = @fd_int_if, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 2, 0>}> : (i32, i32) -> i32
  "llvm.return"(%212) : (i32) -> ()
}) : () -> ()
  with @fd_int_if := fd_int_if

end

end MLIR.Firedancer.Avx512
