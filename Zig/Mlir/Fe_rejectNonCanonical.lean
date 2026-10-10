module

-- zig-build/out/op/Fe.rejectNonCanonical.mlir

public import MLIR.Semantics.Func
public import MLIR.Syntax.Elab

meta import MLIR.Semantics.Func

namespace MLIR.Zig

@[expose] public section

mlir_def Fe_rejectNonCanonical :=
"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.align = 1 : i64, llvm.nocapture, llvm.nonnull, llvm.readonly}], dso_local, frame_pointer = #llvm.framePointerKind<all>, function_type = !llvm.func<i16 (ptr)>, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = none, errnoMem = none, targetMem0 = none, targetMem1 = none>, minsize, no_inline, no_unwind, optsize, passthrough = ["mustprogress", "nofree", "norecurse", "nosync", ["target-cpu", "x86-64"]], res_attrs = [{llvm.range = #llvm.constant_range<i16, 0, 2>}], sym_name = "Fe.rejectNonCanonical", target_cpu = "x86-64", target_features = #llvm.target_features<["+64bit", "+cmov", "+cx8", "+fxsr", "+idivq-to-divl", "+macrofusion", "+mmx", "+nopl", "+slow-3ops-lea", "+slow-incdec", "+vzeroupper", "+x87", "-16bit-mode", "-32bit-mode", "-adx", "-aes", "-allow-light-256-bit", "-amx-avx512", "-amx-bf16", "-amx-complex", "-amx-fp16", "-amx-fp8", "-amx-int8", "-amx-movrs", "-amx-tf32", "-amx-tile", "-amx-transpose", "-avx", "-avx10.1-256", "-avx10.1-512", "-avx10.2-256", "-avx10.2-512", "-avx2", "-avx512bf16", "-avx512bitalg", "-avx512bw", "-avx512cd", "-avx512dq", "-avx512f", "-avx512fp16", "-avx512ifma", "-avx512vbmi", "-avx512vbmi2", "-avx512vl", "-avx512vnni", "-avx512vp2intersect", "-avx512vpopcntdq", "-avxifma", "-avxneconvert", "-avxvnni", "-avxvnniint16", "-avxvnniint8", "-bmi", "-bmi2", "-branch-hint", "-branchfusion", "-ccmp", "-cf", "-cldemote", "-clflushopt", "-clwb", "-clzero", "-cmpccxadd", "-crc32", "-cx16", "-egpr", "-enqcmd", "-ermsb", "-evex512", "-f16c", "-false-deps-getmant", "-false-deps-lzcnt-tzcnt", "-false-deps-mulc", "-false-deps-mullq", "-false-deps-perm", "-false-deps-popcnt", "-false-deps-range", "-fast-11bytenop", "-fast-15bytenop", "-fast-7bytenop", "-fast-bextr", "-fast-dpwssd", "-fast-gather", "-fast-hops", "-fast-imm16", "-fast-lzcnt", "-fast-movbe", "-fast-scalar-fsqrt", "-fast-scalar-shift-masks", "-fast-shld-rotate", "-fast-variable-crosslane-shuffle", "-fast-variable-perlane-shuffle", "-fast-vector-fsqrt", "-fast-vector-shift-masks", "-faster-shift-than-shuffle", "-fma", "-fma4", "-fsgsbase", "-fsrm", "-gfni", "-harden-sls-ijmp", "-harden-sls-ret", "-hreset", "-idivl-to-divb", "-inline-asm-use-gpr32", "-invpcid", "-kl", "-lea-sp", "-lea-uses-ag", "-lvi-cfi", "-lvi-load-hardening", "-lwp", "-lzcnt", "-movbe", "-movdir64b", "-movdiri", "-movrs", "-mwaitx", "-ndd", "-nf", "-no-bypass-delay", "-no-bypass-delay-blend", "-no-bypass-delay-mov", "-no-bypass-delay-shuffle", "-pad-short-functions", "-pclmul", "-pconfig", "-pku", "-popcnt", "-ppx", "-prefer-128-bit", "-prefer-256-bit", "-prefer-mask-registers", "-prefer-movmsk-over-vtest", "-prefer-no-gather", "-prefer-no-scatter", "-prefetchi", "-prfchw", "-ptwrite", "-push2pop2", "-raoint", "-rdpid", "-rdpru", "-rdrnd", "-rdseed", "-retpoline", "-retpoline-external-thunk", "-retpoline-indirect-branches", "-retpoline-indirect-calls", "-rtm", "-sahf", "-sbb-dep-breaking", "-serialize", "-seses", "-sgx", "-sha", "-sha512", "-shstk", "-slow-lea", "-slow-pmaddwd", "-slow-pmulld", "-slow-shld", "-slow-two-mem-ops", "-slow-unaligned-mem-16", "-slow-unaligned-mem-32", "-sm3", "-sm4", "-soft-float", "-sse", "-sse2", "-sse3", "-sse4.1", "-sse4.2", "-sse4a", "-sse-unaligned-mem", "-ssse3", "-tagged-globals", "-tbm", "-tsxldtrk", "-tuning-fast-imm-vector-shift", "-uintr", "-use-glm-div-sqrt-costs", "-use-slm-arith-costs", "-usermsr", "-vaes", "-vpclmulqdq", "-waitpkg", "-wbnoinvd", "-widekl", "-xop", "-xsave", "-xsavec", "-xsaveopt", "-xsaves", "-zu"]>, unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg6: !llvm.ptr):
  %139 = "llvm.mlir.constant"() <{value = 127 : i8}> : () -> i8
  %140 = "llvm.mlir.constant"() <{value = -1 : i8}> : () -> i8
  %141 = "llvm.mlir.constant"() <{value = 511 : i16}> : () -> i16
  %142 = "llvm.mlir.constant"() <{value = 236 : i16}> : () -> i16
  %143 = "llvm.mlir.constant"() <{value = 8 : i16}> : () -> i16
  %144 = "llvm.mlir.constant"() <{value = 1 : i16}> : () -> i16
  %145 = "llvm.getelementptr"(%arg6) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 31>}> : (!llvm.ptr) -> !llvm.ptr
  %146 = "llvm.load"(%145) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %147 = "llvm.and"(%146, %139) : (i8, i8) -> i8
  %148 = "llvm.xor"(%147, %139) : (i8, i8) -> i8
  %149 = "llvm.getelementptr"(%arg6) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 30>}> : (!llvm.ptr) -> !llvm.ptr
  %150 = "llvm.load"(%149) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %151 = "llvm.getelementptr"(%arg6) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 29>}> : (!llvm.ptr) -> !llvm.ptr
  %152 = "llvm.load"(%151) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %153 = "llvm.and"(%152, %150) : (i8, i8) -> i8
  %154 = "llvm.getelementptr"(%arg6) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 28>}> : (!llvm.ptr) -> !llvm.ptr
  %155 = "llvm.load"(%154) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %156 = "llvm.and"(%153, %155) : (i8, i8) -> i8
  %157 = "llvm.getelementptr"(%arg6) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 27>}> : (!llvm.ptr) -> !llvm.ptr
  %158 = "llvm.load"(%157) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %159 = "llvm.and"(%156, %158) : (i8, i8) -> i8
  %160 = "llvm.getelementptr"(%arg6) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 26>}> : (!llvm.ptr) -> !llvm.ptr
  %161 = "llvm.load"(%160) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %162 = "llvm.and"(%159, %161) : (i8, i8) -> i8
  %163 = "llvm.getelementptr"(%arg6) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 25>}> : (!llvm.ptr) -> !llvm.ptr
  %164 = "llvm.load"(%163) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %165 = "llvm.and"(%162, %164) : (i8, i8) -> i8
  %166 = "llvm.getelementptr"(%arg6) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %167 = "llvm.load"(%166) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %168 = "llvm.and"(%165, %167) : (i8, i8) -> i8
  %169 = "llvm.getelementptr"(%arg6) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 23>}> : (!llvm.ptr) -> !llvm.ptr
  %170 = "llvm.load"(%169) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %171 = "llvm.and"(%168, %170) : (i8, i8) -> i8
  %172 = "llvm.getelementptr"(%arg6) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 22>}> : (!llvm.ptr) -> !llvm.ptr
  %173 = "llvm.load"(%172) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %174 = "llvm.and"(%171, %173) : (i8, i8) -> i8
  %175 = "llvm.getelementptr"(%arg6) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 21>}> : (!llvm.ptr) -> !llvm.ptr
  %176 = "llvm.load"(%175) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %177 = "llvm.and"(%174, %176) : (i8, i8) -> i8
  %178 = "llvm.getelementptr"(%arg6) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 20>}> : (!llvm.ptr) -> !llvm.ptr
  %179 = "llvm.load"(%178) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %180 = "llvm.and"(%177, %179) : (i8, i8) -> i8
  %181 = "llvm.getelementptr"(%arg6) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 19>}> : (!llvm.ptr) -> !llvm.ptr
  %182 = "llvm.load"(%181) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %183 = "llvm.and"(%180, %182) : (i8, i8) -> i8
  %184 = "llvm.getelementptr"(%arg6) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 18>}> : (!llvm.ptr) -> !llvm.ptr
  %185 = "llvm.load"(%184) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %186 = "llvm.and"(%183, %185) : (i8, i8) -> i8
  %187 = "llvm.getelementptr"(%arg6) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 17>}> : (!llvm.ptr) -> !llvm.ptr
  %188 = "llvm.load"(%187) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %189 = "llvm.and"(%186, %188) : (i8, i8) -> i8
  %190 = "llvm.getelementptr"(%arg6) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %191 = "llvm.load"(%190) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %192 = "llvm.and"(%189, %191) : (i8, i8) -> i8
  %193 = "llvm.getelementptr"(%arg6) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 15>}> : (!llvm.ptr) -> !llvm.ptr
  %194 = "llvm.load"(%193) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %195 = "llvm.and"(%192, %194) : (i8, i8) -> i8
  %196 = "llvm.getelementptr"(%arg6) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 14>}> : (!llvm.ptr) -> !llvm.ptr
  %197 = "llvm.load"(%196) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %198 = "llvm.and"(%195, %197) : (i8, i8) -> i8
  %199 = "llvm.getelementptr"(%arg6) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 13>}> : (!llvm.ptr) -> !llvm.ptr
  %200 = "llvm.load"(%199) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %201 = "llvm.and"(%198, %200) : (i8, i8) -> i8
  %202 = "llvm.getelementptr"(%arg6) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 12>}> : (!llvm.ptr) -> !llvm.ptr
  %203 = "llvm.load"(%202) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %204 = "llvm.and"(%201, %203) : (i8, i8) -> i8
  %205 = "llvm.getelementptr"(%arg6) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 11>}> : (!llvm.ptr) -> !llvm.ptr
  %206 = "llvm.load"(%205) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %207 = "llvm.and"(%204, %206) : (i8, i8) -> i8
  %208 = "llvm.getelementptr"(%arg6) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 10>}> : (!llvm.ptr) -> !llvm.ptr
  %209 = "llvm.load"(%208) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %210 = "llvm.and"(%207, %209) : (i8, i8) -> i8
  %211 = "llvm.getelementptr"(%arg6) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 9>}> : (!llvm.ptr) -> !llvm.ptr
  %212 = "llvm.load"(%211) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %213 = "llvm.and"(%210, %212) : (i8, i8) -> i8
  %214 = "llvm.getelementptr"(%arg6) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %215 = "llvm.load"(%214) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %216 = "llvm.and"(%213, %215) : (i8, i8) -> i8
  %217 = "llvm.getelementptr"(%arg6) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 7>}> : (!llvm.ptr) -> !llvm.ptr
  %218 = "llvm.load"(%217) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %219 = "llvm.and"(%216, %218) : (i8, i8) -> i8
  %220 = "llvm.getelementptr"(%arg6) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 6>}> : (!llvm.ptr) -> !llvm.ptr
  %221 = "llvm.load"(%220) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %222 = "llvm.and"(%219, %221) : (i8, i8) -> i8
  %223 = "llvm.getelementptr"(%arg6) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 5>}> : (!llvm.ptr) -> !llvm.ptr
  %224 = "llvm.load"(%223) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %225 = "llvm.and"(%222, %224) : (i8, i8) -> i8
  %226 = "llvm.getelementptr"(%arg6) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 4>}> : (!llvm.ptr) -> !llvm.ptr
  %227 = "llvm.load"(%226) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %228 = "llvm.and"(%225, %227) : (i8, i8) -> i8
  %229 = "llvm.getelementptr"(%arg6) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 3>}> : (!llvm.ptr) -> !llvm.ptr
  %230 = "llvm.load"(%229) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %231 = "llvm.and"(%228, %230) : (i8, i8) -> i8
  %232 = "llvm.getelementptr"(%arg6) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 2>}> : (!llvm.ptr) -> !llvm.ptr
  %233 = "llvm.load"(%232) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %234 = "llvm.and"(%231, %233) : (i8, i8) -> i8
  %235 = "llvm.getelementptr"(%arg6) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1>}> : (!llvm.ptr) -> !llvm.ptr
  %236 = "llvm.load"(%235) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %237 = "llvm.and"(%234, %236) : (i8, i8) -> i8
  %238 = "llvm.xor"(%237, %140) : (i8, i8) -> i8
  %239 = "llvm.or"(%148, %238) : (i8, i8) -> i8
  %240 = "llvm.zext"(%239) : (i8) -> i16
  %241 = "llvm.add"(%240, %141) <{overflowFlags = 3 : i32}> : (i16, i16) -> i16
  %242 = "llvm.load"(%arg6) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %243 = "llvm.zext"(%242) : (i8) -> i16
  %244 = "llvm.sub"(%142, %243) <{overflowFlags = 1 : i32}> : (i16, i16) -> i16
  %245 = "llvm.and"(%241, %244) : (i16, i16) -> i16
  %246 = "llvm.lshr"(%245, %143) : (i16, i16) -> i16
  %247 = "llvm.and"(%246, %144) : (i16, i16) -> i16
  "llvm.return"(%247) : (i16) -> ()
}) : () -> ()

end

end MLIR.Zig
