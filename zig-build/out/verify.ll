; ModuleID = 'out/verify.marked.ll'
source_filename = "verify"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-musl"

%Edwards25519 = type { %Fe, %Fe, %Fe, %Fe, i1, [7 x i8] }
%Fe = type { [5 x i64] }
%Sha512 = type { i128, [8 x i64], [128 x i8], i8, [15 x i8] }
%Verifier = type { %Sha512, %Edwards25519, %Edwards25519, [32 x i8] }
%Signature = type { [32 x i8], [32 x i8] }
%Scalar = type { [5 x i64] }

@Edwards25519.basePointPc = internal unnamed_addr constant [16 x %Edwards25519] [%Edwards25519 { %Fe zeroinitializer, %Fe { [5 x i64] [i64 1, i64 0, i64 0, i64 0, i64 0] }, %Fe { [5 x i64] [i64 1, i64 0, i64 0, i64 0, i64 0] }, %Fe zeroinitializer, i1 false, [7 x i8] undef }, %Edwards25519 { %Fe { [5 x i64] [i64 1738742601995546, i64 1146398526822698, i64 2070867633025821, i64 562264141797630, i64 587772402128613] }, %Fe { [5 x i64] [i64 1801439850948184, i64 1351079888211148, i64 450359962737049, i64 900719925474099, i64 1801439850948198] }, %Fe { [5 x i64] [i64 1, i64 0, i64 0, i64 0, i64 0] }, %Fe { [5 x i64] [i64 1841354044333475, i64 16398895984059, i64 755974180946558, i64 900171276175154, i64 1821297809914039] }, i1 true, [7 x i8] undef }, %Edwards25519 { %Fe { [5 x i64] [i64 1541188478825878, i64 1197032412057768, i64 347565293716728, i64 1506927642819620, i64 1387300781447229] }, %Fe { [5 x i64] [i64 1358062783987734, i64 908781688745398, i64 1366384384074070, i64 1708963800187362, i64 1352083541930860] }, %Fe { [5 x i64] [i64 939820407267714, i64 2244711721325457, i64 833935350215291, i64 514982476710626, i64 395358860036744] }, %Fe { [5 x i64] [i64 1321582453765716, i64 2482098724393, i64 1510762286838933, i64 480896982769627, i64 1827079681782950] }, i1 false, [7 x i8] undef }, %Edwards25519 { %Fe { [5 x i64] [i64 1149457744846734, i64 450169995617970, i64 2055507233128843, i64 2062201830518144, i64 136862312283743] }, %Fe { [5 x i64] [i64 2053921896347067, i64 2221205273940902, i64 14874655988550, i64 1346502419946111, i64 1863585651682216] }, %Fe { [5 x i64] [i64 1061705710463460, i64 150884959185907, i64 158377546300656, i64 2007006659873485, i64 1408482789065644] }, %Fe { [5 x i64] [i64 23563409686593, i64 1778464566704718, i64 1451253725396635, i64 2182453144599804, i64 1286531007342173] }, i1 false, [7 x i8] undef }, %Edwards25519 { %Fe { [5 x i64] [i64 660192693713496, i64 1280930407030602, i64 1163287876011131, i64 58322973648342, i64 90786330235622] }, %Fe { [5 x i64] [i64 1035218103105297, i64 1450764704552568, i64 1551268250545928, i64 392951187848458, i64 1921292502562549] }, %Fe { [5 x i64] [i64 1904279982576693, i64 1467233916658614, i64 1298643500842388, i64 324859978027951, i64 133149465829202] }, %Fe { [5 x i64] [i64 713678009822519, i64 1673217155969579, i64 2079600867080155, i64 1104952482317695, i64 971760214539514] }, i1 false, [7 x i8] undef }, %Edwards25519 { %Fe { [5 x i64] [i64 1883925220455435, i64 1018758103841379, i64 1297121302624484, i64 497598097034189, i64 50708912453458] }, %Fe { [5 x i64] [i64 1042591014379288, i64 431959024834328, i64 2100797969324441, i64 482140596916776, i64 1296518441183899] }, %Fe { [5 x i64] [i64 882236476409592, i64 1497675105009012, i64 2181927182817440, i64 722619068391161, i64 819202421408532] }, %Fe { [5 x i64] [i64 1546951503782510, i64 314247300847936, i64 2020425030999419, i64 980284807473636, i64 1889039625571278] }, i1 false, [7 x i8] undef }, %Edwards25519 { %Fe { [5 x i64] [i64 2130990135480605, i64 982749374950046, i64 599583334394473, i64 1894182648668558, i64 2179588788157719] }, %Fe { [5 x i64] [i64 478887761065661, i64 113947697117089, i64 1371552294594728, i64 1520518664440150, i64 2031310216527449] }, %Fe { [5 x i64] [i64 406273932530493, i64 1601638185061342, i64 1151347692721435, i64 1495804819323688, i64 118365337991367] }, %Fe { [5 x i64] [i64 857320240720474, i64 1328692164544589, i64 1863161274117424, i64 2005002848847272, i64 1656314779419788] }, i1 false, [7 x i8] undef }, %Edwards25519 { %Fe { [5 x i64] [i64 1112370244829930, i64 1875011547866993, i64 432612241944241, i64 1700429079007619, i64 966932576908730] }, %Fe { [5 x i64] [i64 1047175363160963, i64 1272436962755737, i64 54269285099994, i64 548161513929109, i64 928275751982494] }, %Fe { [5 x i64] [i64 960540512985497, i64 1426503578465076, i64 2188424813616240, i64 1795326679408039, i64 1607151223114465] }, %Fe { [5 x i64] [i64 154551982002342, i64 135505241281001, i64 375200510022526, i64 1625768331744444, i64 1168996780660709] }, i1 false, [7 x i8] undef }, %Edwards25519 { %Fe { [5 x i64] [i64 2233581206391315, i64 847321536719855, i64 1143763522071466, i64 2176635986873503, i64 544015092356874] }, %Fe { [5 x i64] [i64 810168548829118, i64 1091277158180317, i64 1905862677914949, i64 871313444918061, i64 2245667822025877] }, %Fe { [5 x i64] [i64 207037345464830, i64 1993080251615457, i64 560932193579569, i64 999626924140364, i64 754134581836708] }, %Fe { [5 x i64] [i64 606549093027129, i64 120708372070681, i64 50079640475349, i64 1940797268843777, i64 623236962379938] }, i1 false, [7 x i8] undef }, %Edwards25519 { %Fe { [5 x i64] [i64 1734661280256917, i64 1475881781462133, i64 2119057142044039, i64 1613144896859885, i64 685964170173075] }, %Fe { [5 x i64] [i64 505643235703707, i64 2061505139635634, i64 576838540951108, i64 198013021125224, i64 2093974116356573] }, %Fe { [5 x i64] [i64 1934056789485370, i64 2187228471026461, i64 79683303172571, i64 246283662803711, i64 749534771196139] }, %Fe { [5 x i64] [i64 1414575035615884, i64 1333375141030740, i64 117879133054673, i64 611412171867408, i64 720887331987017] }, i1 false, [7 x i8] undef }, %Edwards25519 { %Fe { [5 x i64] [i64 553729716733766, i64 986471165032694, i64 1431660489761677, i64 145724617029028, i64 409871604646540] }, %Fe { [5 x i64] [i64 959187222359789, i64 2006174714217507, i64 1096848591579110, i64 1985608358563446, i64 351464576135759] }, %Fe { [5 x i64] [i64 1818564342032891, i64 1136491851523721, i64 35093607622580, i64 1441385653535882, i64 732801009348817] }, %Fe { [5 x i64] [i64 1899763765009525, i64 453968927967238, i64 2012144916117209, i64 14638254719875, i64 1948510361033379] }, i1 false, [7 x i8] undef }, %Edwards25519 { %Fe { [5 x i64] [i64 729846219326836, i64 1087087782045139, i64 1607176229556672, i64 959454970790615, i64 600749999132172] }, %Fe { [5 x i64] [i64 1635551968162601, i64 37540660928676, i64 891985434804463, i64 512134985341097, i64 909508093967655] }, %Fe { [5 x i64] [i64 260719394240982, i64 249358397423578, i64 1898576669281045, i64 1319825585617897, i64 2203484913493586] }, %Fe { [5 x i64] [i64 498917687531260, i64 1686344982717566, i64 1263391293231780, i64 726192256837721, i64 1124441044130545] }, i1 false, [7 x i8] undef }, %Edwards25519 { %Fe { [5 x i64] [i64 263578157958884, i64 927572320644087, i64 1952967321453828, i64 1815236529057190, i64 1908346986657029] }, %Fe { [5 x i64] [i64 99847699902717, i64 806845863069994, i64 2226756580524391, i64 1110823523201994, i64 1911910764096600] }, %Fe { [5 x i64] [i64 207103967810401, i64 768727957346634, i64 718644737663762, i64 1362212140629448, i64 1529120863451279] }, %Fe { [5 x i64] [i64 786412295554568, i64 46696096116589, i64 771696060547278, i64 678406248033001, i64 651491669624679] }, i1 false, [7 x i8] undef }, %Edwards25519 { %Fe { [5 x i64] [i64 832852591944782, i64 1443049771911832, i64 965594192675813, i64 1109187486147594, i64 1972279812307351] }, %Fe { [5 x i64] [i64 1598787889438517, i64 2092679737564297, i64 2070050120088212, i64 1204363835958456, i64 962809779917695] }, %Fe { [5 x i64] [i64 2250000172488624, i64 1617330080438570, i64 1107263496438848, i64 2112155113306328, i64 980993448222351] }, %Fe { [5 x i64] [i64 783827866299868, i64 770887901885486, i64 140247240423289, i64 2001990460522811, i64 2225367780520463] }, i1 false, [7 x i8] undef }, %Edwards25519 { %Fe { [5 x i64] [i64 2128348078977926, i64 684167145241146, i64 710972932661139, i64 707258098892712, i64 61778444111603] }, %Fe { [5 x i64] [i64 187645738157129, i64 1968555615929883, i64 1811428368350970, i64 368483309987867, i64 1644735413490412] }, %Fe { [5 x i64] [i64 1081431594790383, i64 1952209085138192, i64 1101000417182974, i64 1343359737131623, i64 837835975770184] }, %Fe { [5 x i64] [i64 229346715450949, i64 1279958390698450, i64 591936774121652, i64 2141086636759471, i64 899751828053388] }, i1 false, [7 x i8] undef }, %Edwards25519 { %Fe { [5 x i64] [i64 1214219747454372, i64 1931810652113743, i64 1290925308170273, i64 157124433198734, i64 394790170709317] }, %Fe { [5 x i64] [i64 1382875631722181, i64 1349928920135911, i64 1711916256545158, i64 47212905564237, i64 183840775072302] }, %Fe { [5 x i64] [i64 684290857876024, i64 657789607835756, i64 1569561823708010, i64 1217543024068483, i64 2219703400977787] }, %Fe { [5 x i64] [i64 532578202911692, i64 1319541426005468, i64 1781351630930322, i64 2119904350936618, i64 1263392443823746] }, i1 false, [7 x i8] undef }], align 8
@Edwards25519.mulDoubleBasePublic.weak = private unnamed_addr constant { %Edwards25519, i16, [6 x i8] } { %Edwards25519 undef, i16 4, [6 x i8] undef }, align 8
@scalar.field_order_s = private unnamed_addr constant [32 x i8] c"\ED\D3\F5\\\1Ac\12X\D6\9C\F7\A2\DE\F9\DE\14\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\10", align 1
@Fe.edwards25519d = private unnamed_addr constant %Fe { [5 x i64] [i64 929955233495203, i64 466365720129213, i64 1662059464998953, i64 2033849074728123, i64 1442794654840575] }, align 8
@Fe.one = private unnamed_addr constant %Fe { [5 x i64] [i64 1, i64 0, i64 0, i64 0, i64 0] }, align 8
@Edwards25519.fromBytes.invalid = private unnamed_addr constant { %Edwards25519, i16, [6 x i8] } { %Edwards25519 undef, i16 2, [6 x i8] undef }, align 8
@Fe.sqrtm1 = private unnamed_addr constant %Fe { [5 x i64] [i64 1718705420411056, i64 234908883556509, i64 2233514472574048, i64 2117202627021982, i64 765476049583133] }, align 8
@Sha512.iv = private unnamed_addr constant %Sha512 { i128 0, [8 x i64] [i64 7640891576956012808, i64 -4942790177534073029, i64 4354685564936845355, i64 -6534734903238641935, i64 5840696475078001361, i64 -7276294671716946913, i64 2270897969802886507, i64 6620516959819538809], [128 x i8] undef, i8 0, [15 x i8] undef }, align 16
@Fe.zero = private unnamed_addr constant %Fe zeroinitializer, align 8
@Edwards25519.identityElement = private unnamed_addr constant %Edwards25519 { %Fe zeroinitializer, %Fe { [5 x i64] [i64 1, i64 0, i64 0, i64 0, i64 0] }, %Fe { [5 x i64] [i64 1, i64 0, i64 0, i64 0, i64 0] }, %Fe zeroinitializer, i1 false, [7 x i8] undef }, align 8
@Fe.edwards25519d2 = private unnamed_addr constant %Fe { [5 x i64] [i64 1859910466990425, i64 932731440258426, i64 1072319116312658, i64 1815898335770999, i64 633789495995903] }, align 8

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(read, argmem: readwrite, inaccessiblemem: readwrite) uwtable
define dso_local range(i32 -5, 1) i32 @zig_ed25519_verify(ptr nocapture nonnull readonly align 1 %0, i64 %1, ptr nocapture nonnull readonly align 1 %2, ptr nocapture nonnull readonly align 1 %3) local_unnamed_addr #0 {
  %5 = alloca { %Verifier, i16, [14 x i8] }, align 16
  %.sroa.0.i = alloca %Verifier, align 16
  %6 = alloca %Verifier, align 16
  %7 = alloca %Signature, align 1
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(32) %7, ptr noundef nonnull readonly align 1 dereferenceable(32) %2, i64 32, i1 false)
  %8 = getelementptr inbounds nuw i8, ptr %7, i64 32
  %9 = getelementptr inbounds nuw i8, ptr %2, i64 32
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(32) %8, ptr noundef nonnull readonly align 1 dereferenceable(32) %9, i64 32, i1 false)
  call void @llvm.lifetime.start.p0(i64 592, ptr nonnull %.sroa.0.i)
  call void @llvm.lifetime.start.p0(i64 592, ptr nonnull %6)
  call void @llvm.lifetime.start.p0(i64 608, ptr nonnull %5)
  call fastcc void @Verifier.init(ptr sret({ %Verifier, i16, [14 x i8] }) %5, ptr nonnull readonly align 1 %7, ptr nonnull readonly align 1 %3)
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 16 dereferenceable(592) %.sroa.0.i, ptr noundef nonnull align 16 dereferenceable(592) %5, i64 592, i1 false)
  %.sroa.2.0..sroa_idx.i = getelementptr inbounds nuw i8, ptr %5, i64 592
  %.sroa.2.0.copyload.i = load i16, ptr %.sroa.2.0..sroa_idx.i, align 16
  call void @llvm.lifetime.end.p0(i64 608, ptr nonnull %5)
  %.not.i = icmp eq i16 %.sroa.2.0.copyload.i, 0
  br i1 %.not.i, label %10, label %Signature.verify.exit, !prof !0

10:                                               ; preds = %4
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 16 dereferenceable(592) %6, ptr noundef nonnull align 16 dereferenceable(592) %.sroa.0.i, i64 592, i1 false)
  call fastcc void @Sha512.update(ptr nonnull align 16 %6, ptr nonnull readonly align 1 %0, i64 %1)
  %11 = call fastcc i16 @Verifier.verify(ptr nonnull align 16 %6)
  br label %Signature.verify.exit

Signature.verify.exit:        ; preds = %4, %10
  %common.ret.op.i = phi i16 [ %11, %10 ], [ %.sroa.2.0.copyload.i, %4 ]
  call void @llvm.lifetime.end.p0(i64 592, ptr nonnull %.sroa.0.i)
  call void @llvm.lifetime.end.p0(i64 592, ptr nonnull %6)
  %switch.idx.cast = zext i16 %common.ret.op.i to i32
  %switch.idx.mult = sub nsw i32 0, %switch.idx.cast
  ret i32 %switch.idx.mult
}

; Function Attrs: mustprogress nocallback nofree nounwind willreturn memory(argmem: readwrite)
declare void @llvm.memcpy.p0.p0.i64(ptr noalias nocapture writeonly, ptr noalias nocapture readonly, i64, i1 immarg) #1

; Function Attrs: minsize nofree noinline norecurse nosync nounwind optsize memory(read, argmem: readwrite, inaccessiblemem: readwrite) uwtable
define internal fastcc i16 @Verifier.verify(ptr nocapture nonnull align 16 %0) unnamed_addr #2 {
  %2 = alloca %Edwards25519, align 8
  %3 = alloca %Edwards25519, align 8
  %4 = alloca { %Edwards25519, i16, [6 x i8] }, align 8
  %5 = alloca %Edwards25519, align 8
  %6 = alloca %Edwards25519, align 8
  %7 = alloca [32 x i8], align 1
  %8 = alloca [32 x i8], align 1
  %9 = alloca [64 x i8], align 1
  call fastcc void @Sha512.final(ptr nonnull align 16 %0, ptr nonnull align 1 %9)
  call fastcc void @scalar.reduce64(ptr sret([32 x i8]) %8, ptr nonnull readonly align 1 %9)
  %10 = getelementptr inbounds nuw i8, ptr %0, i64 560
  call fastcc void @scalar.mul8(ptr sret([32 x i8]) %7, ptr nonnull readonly align 1 %10)
  %11 = getelementptr inbounds nuw i8, ptr %0, i64 224
  call fastcc void @Edwards25519.clearCofactor(ptr sret(%Edwards25519) %6, ptr nonnull readonly align 8 %11)
  call fastcc void @Edwards25519.neg(ptr sret(%Edwards25519) %5, ptr nonnull readonly align 8 %6)
  call fastcc void @Edwards25519.mulDoubleBasePublic(ptr sret({ %Edwards25519, i16, [6 x i8] }) %4, ptr nonnull readonly align 1 %7, ptr nonnull readonly align 8 %5, ptr nonnull readonly align 1 %8)
  %12 = getelementptr inbounds nuw i8, ptr %4, i64 168
  %13 = load i16, ptr %12, align 8
  %.not = icmp eq i16 %13, 0
  br i1 %.not, label %14, label %common.ret, !prof !0

common.ret:                                       ; preds = %1, %14
  %common.ret.op = phi i16 [ %spec.select, %14 ], [ %13, %1 ]
  ret i16 %common.ret.op

14:                                               ; preds = %1
  %15 = getelementptr inbounds nuw i8, ptr %0, i64 392
  call fastcc void @Edwards25519.clearCofactor(ptr sret(%Edwards25519) %3, ptr nonnull readonly align 8 %15)
  call fastcc void @Edwards25519.sub(ptr sret(%Edwards25519) %2, ptr nonnull readonly align 8 %4, ptr nonnull readonly align 8 %3)
  %16 = call fastcc i1 @Verifier.isIdentity(ptr nonnull readonly align 8 %2)
  %spec.select = select i1 %16, i16 0, i16 5
  br label %common.ret
}

; Function Attrs: minsize nofree noinline norecurse nosync nounwind optsize memory(argmem: readwrite, inaccessiblemem: readwrite) uwtable
define internal fastcc void @Verifier.init(ptr noalias nocapture nonnull writeonly sret({ %Verifier, i16, [14 x i8] }) initializes((592, 594)) %0, ptr nocapture nonnull readonly align 1 %1, ptr nocapture nonnull readonly align 1 %2) unnamed_addr #3 {
  %4 = alloca %Verifier, align 16
  %5 = alloca %Sha512, align 16
  %6 = alloca { %Edwards25519, i16, [6 x i8] }, align 8
  %7 = alloca { %Edwards25519, i16, [6 x i8] }, align 8
  %8 = alloca [32 x i8], align 1
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(32) %8, ptr noundef nonnull align 1 dereferenceable(32) %1, i64 32, i1 false)
  %9 = getelementptr inbounds nuw i8, ptr %1, i64 32
  %10 = tail call fastcc i16 @scalar.rejectNonCanonical(ptr nonnull readonly align 1 %9)
  %.not = icmp eq i16 %10, 0
  br i1 %.not, label %13, label %11, !prof !0

common.ret:                                       ; preds = %35, %33, %29, %24, %20, %16, %11
  ret void

11:                                               ; preds = %3
  %12 = getelementptr inbounds nuw i8, ptr %0, i64 592
  store i16 %10, ptr %12, align 16
  br label %common.ret

13:                                               ; preds = %3
  call fastcc void @Edwards25519.fromBytes(ptr sret({ %Edwards25519, i16, [6 x i8] }) %7, ptr nonnull readonly align 1 %2)
  %14 = getelementptr inbounds nuw i8, ptr %7, i64 168
  %15 = load i16, ptr %14, align 8
  %.not6 = icmp eq i16 %15, 0
  br i1 %.not6, label %18, label %16, !prof !0

16:                                               ; preds = %13
  %17 = getelementptr inbounds nuw i8, ptr %0, i64 592
  store i16 %15, ptr %17, align 16
  br label %common.ret

18:                                               ; preds = %13
  %19 = call fastcc i16 @Edwards25519.rejectIdentity(ptr nonnull readonly align 8 %7)
  %.not7 = icmp eq i16 %19, 0
  br i1 %.not7, label %22, label %20, !prof !0

20:                                               ; preds = %18
  %21 = getelementptr inbounds nuw i8, ptr %0, i64 592
  store i16 %19, ptr %21, align 16
  br label %common.ret

22:                                               ; preds = %18
  %23 = call fastcc range(i16 0, 2) i16 @Fe.rejectNonCanonical(ptr nonnull readonly align 1 %8)
  %.not8 = icmp eq i16 %23, 0
  br i1 %.not8, label %26, label %24, !prof !0

24:                                               ; preds = %22
  %25 = getelementptr inbounds nuw i8, ptr %0, i64 592
  store i16 %23, ptr %25, align 16
  br label %common.ret

26:                                               ; preds = %22
  call fastcc void @Edwards25519.fromBytes(ptr sret({ %Edwards25519, i16, [6 x i8] }) %6, ptr nonnull readonly align 1 %1)
  %27 = getelementptr inbounds nuw i8, ptr %6, i64 168
  %28 = load i16, ptr %27, align 8
  %.not9 = icmp eq i16 %28, 0
  br i1 %.not9, label %31, label %29, !prof !0

29:                                               ; preds = %26
  %30 = getelementptr inbounds nuw i8, ptr %0, i64 592
  store i16 %28, ptr %30, align 16
  br label %common.ret

31:                                               ; preds = %26
  %32 = call fastcc i16 @Edwards25519.rejectIdentity(ptr nonnull readonly align 8 %6)
  %.not10 = icmp eq i16 %32, 0
  br i1 %.not10, label %35, label %33, !prof !0

33:                                               ; preds = %31
  %34 = getelementptr inbounds nuw i8, ptr %0, i64 592
  store i16 %32, ptr %34, align 16
  br label %common.ret

35:                                               ; preds = %31
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 16 dereferenceable(224) %5, ptr noundef nonnull align 16 dereferenceable(224) @Sha512.iv, i64 224, i1 false)
  call fastcc void @Sha512.update(ptr nonnull align 16 %5, ptr nonnull readonly align 1 %1, i64 32)
  call fastcc void @Sha512.update(ptr nonnull align 16 %5, ptr nonnull readonly align 1 %2, i64 32)
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 16 dereferenceable(224) %4, ptr noundef nonnull align 16 dereferenceable(224) %5, i64 224, i1 false)
  %36 = getelementptr inbounds nuw i8, ptr %4, i64 560
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 16 dereferenceable(32) %36, ptr noundef nonnull align 1 dereferenceable(32) %9, i64 32, i1 false)
  %37 = getelementptr inbounds nuw i8, ptr %4, i64 224
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 16 dereferenceable(168) %37, ptr noundef nonnull align 8 dereferenceable(168) %7, i64 168, i1 false)
  %38 = getelementptr inbounds nuw i8, ptr %4, i64 392
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(168) %38, ptr noundef nonnull align 8 dereferenceable(168) %6, i64 168, i1 false)
  %39 = getelementptr inbounds nuw i8, ptr %0, i64 592
  store i16 0, ptr %39, align 16
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 16 dereferenceable(592) %0, ptr noundef nonnull align 16 dereferenceable(592) %4, i64 592, i1 false)
  br label %common.ret
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(argmem: readwrite, inaccessiblemem: write) uwtable
define internal fastcc void @Sha512.update(ptr nocapture nonnull align 16 %0, ptr nocapture nonnull readonly align 1 %1, i64 %2) unnamed_addr #4 {
  %4 = getelementptr inbounds nuw i8, ptr %0, i64 208
  %5 = load i8, ptr %4, align 16
  %.not = icmp eq i8 %5, 0
  br i1 %.not, label %.critedge.preheader, label %6

6:                                                ; preds = %3
  %7 = zext i8 %5 to i64
  %8 = add nuw i64 %2, %7
  %9 = icmp ugt i64 %8, 127
  br i1 %9, label %10, label %.critedge.preheader

10:                                               ; preds = %6
  %11 = sub nuw i8 -128, %5
  %12 = zext nneg i8 %11 to i64
  %13 = getelementptr inbounds nuw i8, ptr %0, i64 80
  %14 = getelementptr inbounds nuw i8, ptr %13, i64 %7
  tail call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %14, ptr nonnull align 1 %1, i64 %12, i1 false)
  tail call fastcc void @Sha512.round(ptr nonnull align 16 %0, ptr nonnull readonly align 1 %13)
  store i8 0, ptr %4, align 16
  br label %.critedge.preheader

.critedge.preheader:                              ; preds = %6, %3, %10
  %.1.ph = phi i64 [ 0, %3 ], [ 0, %6 ], [ %12, %10 ]
  br label %.critedge

.critedge:                                        ; preds = %.critedge.preheader, %17
  %.1 = phi i64 [ %15, %17 ], [ %.1.ph, %.critedge.preheader ]
  %15 = add nuw i64 %.1, 128
  %.not41 = icmp ugt i64 %15, %2
  %16 = getelementptr inbounds i8, ptr %1, i64 %.1
  br i1 %.not41, label %18, label %17

17:                                               ; preds = %.critedge
  tail call fastcc void @Sha512.round(ptr nonnull align 16 %0, ptr nonnull readonly align 1 %16)
  br label %.critedge

18:                                               ; preds = %.critedge
  %19 = sub nuw i64 %2, %.1
  %20 = getelementptr inbounds nuw i8, ptr %0, i64 80
  %21 = load i8, ptr %4, align 16
  %22 = zext i8 %21 to i64
  %23 = getelementptr inbounds nuw i8, ptr %20, i64 %22
  tail call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %23, ptr nonnull align 1 %16, i64 %19, i1 false)
  %24 = load i8, ptr %4, align 16
  %25 = icmp ult i64 %19, 256
  tail call void @llvm.assume(i1 %25)
  %26 = trunc nuw i64 %19 to i8
  %27 = add nuw i8 %24, %26
  store i8 %27, ptr %4, align 16
  %28 = load i128, ptr %0, align 16
  %29 = zext i64 %2 to i128
  %30 = add nuw i128 %28, %29
  store i128 %30, ptr %0, align 16
  ret void
}

; Function Attrs: mustprogress nocallback nofree nounwind willreturn memory(argmem: write)
declare void @llvm.memset.p0.i64(ptr nocapture writeonly, i8, i64, i1 immarg) #5

; Function Attrs: minsize nofree noinline norecurse nosync nounwind optsize memory(argmem: readwrite) uwtable
define internal fastcc void @Sha512.final(ptr nocapture nonnull align 16 %0, ptr nocapture nonnull writeonly align 1 %1) unnamed_addr #6 {
  %3 = getelementptr inbounds nuw i8, ptr %0, i64 80
  %4 = getelementptr inbounds nuw i8, ptr %0, i64 208
  %5 = load i8, ptr %4, align 16
  %6 = zext i8 %5 to i64
  %7 = getelementptr inbounds nuw i8, ptr %3, i64 %6
  %8 = sub nuw nsw i64 128, %6
  tail call void @llvm.memset.p0.i64(ptr nonnull align 1 %7, i8 0, i64 %8, i1 false)
  %9 = load i8, ptr %4, align 16
  %10 = zext i8 %9 to i64
  %11 = getelementptr inbounds nuw [128 x i8], ptr %3, i64 0, i64 %10
  store i8 -128, ptr %11, align 1
  %12 = load i8, ptr %4, align 16
  %13 = add nuw i8 %12, 1
  store i8 %13, ptr %4, align 16
  %14 = icmp ugt i8 %12, 111
  br i1 %14, label %21, label %15

15:                                               ; preds = %2, %21
  %16 = load i128, ptr %0, align 16
  %17 = lshr i128 %16, 5
  %18 = getelementptr inbounds nuw i8, ptr %0, i64 207
  %19 = trunc i128 %16 to i8
  %20 = shl i8 %19, 3
  store i8 %20, ptr %18, align 1
  br label %22

21:                                               ; preds = %2
  tail call fastcc void @Sha512.round(ptr nonnull align 16 %0, ptr nonnull readonly align 1 %3)
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 16 dereferenceable(128) %3, i8 0, i64 128, i1 false)
  br label %15

22:                                               ; preds = %23, %15
  %.018 = phi i64 [ 1, %15 ], [ %28, %23 ]
  %.017 = phi i128 [ %17, %15 ], [ %27, %23 ]
  %exitcond.not = icmp eq i64 %.018, 16
  br i1 %exitcond.not, label %29, label %23

23:                                               ; preds = %22
  %24 = sub nuw nsw i64 127, %.018
  %25 = getelementptr inbounds nuw [128 x i8], ptr %3, i64 0, i64 %24
  %26 = trunc i128 %.017 to i8
  store i8 %26, ptr %25, align 1
  %27 = lshr i128 %.017, 8
  %28 = add nuw nsw i64 %.018, 1
  br label %22

29:                                               ; preds = %22
  tail call fastcc void @Sha512.round(ptr nonnull align 16 %0, ptr nonnull readonly align 1 %3)
  %30 = getelementptr inbounds nuw i8, ptr %0, i64 16
  br label %31

31:                                               ; preds = %32, %29
  %.0 = phi i64 [ 0, %29 ], [ %38, %32 ]
  %exitcond19.not = icmp eq i64 %.0, 8
  br i1 %exitcond19.not, label %39, label %32

32:                                               ; preds = %31
  %33 = getelementptr inbounds nuw [8 x i64], ptr %30, i64 0, i64 %.0
  %34 = load i64, ptr %33, align 8
  %35 = shl nuw nsw i64 %.0, 3
  %36 = getelementptr inbounds nuw i8, ptr %1, i64 %35
  %37 = tail call i64 @llvm.bswap.i64(i64 %34)
  store i64 %37, ptr %36, align 1
  %38 = add nuw nsw i64 %.0, 1
  br label %31

39:                                               ; preds = %31
  ret void
}

; Function Attrs: minsize nofree noinline norecurse nosync nounwind optsize memory(argmem: readwrite, inaccessiblemem: write) uwtable
define internal fastcc void @scalar.reduce64(ptr noalias nocapture nonnull writeonly sret([32 x i8]) %0, ptr nocapture nonnull readonly align 1 %1) unnamed_addr #7 {
  %3 = alloca %Scalar, align 8
  %4 = alloca [10 x i64], align 8
  %5 = alloca [64 x i8], align 1
  %6 = alloca [32 x i8], align 1
  call void @llvm.lifetime.start.p0(i64 80, ptr nonnull %4)
  call void @llvm.lifetime.start.p0(i64 64, ptr nonnull %5)
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(64) %5, ptr noundef nonnull readonly align 1 dereferenceable(64) %1, i64 64, i1 false), !noalias !1
  br label %7

7:                                                ; preds = %8, %2
  %.0.i = phi i64 [ 0, %2 ], [ %14, %8 ]
  %exitcond.not.i = icmp eq i64 %.0.i, 9
  br i1 %exitcond.not.i, label %ScalarDouble.fromBytes64.exit, label %8

8:                                                ; preds = %7
  %9 = getelementptr inbounds nuw [10 x i64], ptr %4, i64 0, i64 %.0.i
  %10 = mul nuw nsw i64 %.0.i, 7
  %11 = getelementptr inbounds nuw i8, ptr %5, i64 %10
  %12 = load i64, ptr %11, align 1, !noalias !1
  %13 = and i64 %12, 72057594037927935
  store i64 %13, ptr %9, align 8, !noalias !1
  %14 = add nuw nsw i64 %.0.i, 1
  br label %7

ScalarDouble.fromBytes64.exit:         ; preds = %7
  %15 = getelementptr inbounds nuw i8, ptr %1, i64 63
  %16 = load i8, ptr %15, align 1, !noalias !1
  %17 = zext i8 %16 to i64
  %.sroa.01.0.copyload = load i64, ptr %4, align 8
  %.sroa.22.0..sroa_idx = getelementptr inbounds nuw i8, ptr %4, i64 8
  %.sroa.22.0.copyload = load i64, ptr %.sroa.22.0..sroa_idx, align 8
  %.sroa.33.0..sroa_idx = getelementptr inbounds nuw i8, ptr %4, i64 16
  %.sroa.33.0.copyload = load i64, ptr %.sroa.33.0..sroa_idx, align 8
  %.sroa.44.0..sroa_idx = getelementptr inbounds nuw i8, ptr %4, i64 24
  %.sroa.44.0.copyload = load i64, ptr %.sroa.44.0..sroa_idx, align 8
  %.sroa.55.0..sroa_idx = getelementptr inbounds nuw i8, ptr %4, i64 32
  %.sroa.55.0.copyload = load i64, ptr %.sroa.55.0..sroa_idx, align 8
  %.sroa.66.0..sroa_idx = getelementptr inbounds nuw i8, ptr %4, i64 40
  %.sroa.66.0.copyload = load i64, ptr %.sroa.66.0..sroa_idx, align 8
  %.sroa.77.0..sroa_idx = getelementptr inbounds nuw i8, ptr %4, i64 48
  %.sroa.77.0.copyload = load i64, ptr %.sroa.77.0..sroa_idx, align 8
  %.sroa.88.0..sroa_idx = getelementptr inbounds nuw i8, ptr %4, i64 56
  %.sroa.88.0.copyload = load i64, ptr %.sroa.88.0..sroa_idx, align 8
  %.sroa.99.0..sroa_idx = getelementptr inbounds nuw i8, ptr %4, i64 64
  %.sroa.99.0.copyload = load i64, ptr %.sroa.99.0..sroa_idx, align 8
  call void @llvm.lifetime.end.p0(i64 80, ptr nonnull %4)
  call void @llvm.lifetime.end.p0(i64 64, ptr nonnull %5)
  call void @llvm.lifetime.start.p0(i64 40, ptr nonnull %3)
  %18 = shl i64 %.sroa.66.0.copyload, 32
  %19 = and i64 %18, 72057589742960640
  %20 = lshr i64 %.sroa.55.0.copyload, 24
  %21 = or i64 %19, %20
  %22 = shl i64 %.sroa.77.0.copyload, 32
  %23 = and i64 %22, 72057589742960640
  %24 = lshr i64 %.sroa.66.0.copyload, 24
  %25 = or i64 %23, %24
  %26 = shl i64 %.sroa.88.0.copyload, 32
  %27 = and i64 %26, 72057589742960640
  %28 = lshr i64 %.sroa.77.0.copyload, 24
  %29 = or i64 %27, %28
  %30 = shl i64 %.sroa.99.0.copyload, 32
  %31 = and i64 %30, 72057589742960640
  %32 = lshr i64 %.sroa.88.0.copyload, 24
  %33 = or i64 %31, %32
  %34 = shl nuw nsw i64 %17, 32
  %35 = lshr i64 %.sroa.99.0.copyload, 24
  %36 = or i64 %35, %34
  %37 = zext nneg i64 %21 to i128
  %38 = mul nuw nsw i128 %37, 44162584779952923
  %39 = mul nuw nsw i128 %37, 9390964836247533
  %40 = mul nuw nsw i128 %37, 72057594036560134
  %41 = mul nuw nsw i128 %37, 72057594037927935
  %42 = mul nuw nsw i128 %37, 68719476735
  %43 = zext nneg i64 %25 to i128
  %44 = mul nuw nsw i128 %43, 44162584779952923
  %45 = mul nuw nsw i128 %43, 9390964836247533
  %46 = mul nuw nsw i128 %43, 72057594036560134
  %47 = mul nuw nsw i128 %43, 72057594037927935
  %48 = mul nuw nsw i128 %43, 68719476735
  %49 = zext nneg i64 %29 to i128
  %50 = mul nuw nsw i128 %49, 44162584779952923
  %51 = mul nuw nsw i128 %49, 9390964836247533
  %52 = mul nuw nsw i128 %49, 72057594036560134
  %53 = mul nuw nsw i128 %49, 72057594037927935
  %54 = mul nuw nsw i128 %49, 68719476735
  %55 = zext nneg i64 %33 to i128
  %56 = mul nuw nsw i128 %55, 44162584779952923
  %57 = mul nuw nsw i128 %55, 9390964836247533
  %58 = mul nuw nsw i128 %55, 72057594036560134
  %59 = mul nuw nsw i128 %55, 72057594037927935
  %60 = mul nuw nsw i128 %55, 68719476735
  %61 = zext nneg i64 %36 to i128
  %62 = mul nuw nsw i128 %61, 44162584779952923
  %63 = mul nuw nsw i128 %61, 9390964836247533
  %64 = mul nuw nsw i128 %61, 72057594036560134
  %65 = mul nuw nsw i128 %61, 72057594037927935
  %66 = mul nuw nsw i128 %61, 68719476735
  %67 = add nuw nsw i128 %44, %39
  %68 = add nuw nsw i128 %45, %40
  %69 = add nuw nsw i128 %68, %50
  %70 = add nuw nsw i128 %46, %41
  %71 = add nuw nsw i128 %70, %51
  %72 = add nuw nsw i128 %71, %56
  %73 = add nuw nsw i128 %47, %42
  %74 = add nuw nsw i128 %73, %52
  %75 = add nuw nsw i128 %53, %48
  %76 = add nuw nsw i128 %60, %65
  %77 = lshr i128 %38, 56
  %78 = add nuw nsw i128 %67, %77
  %79 = lshr i128 %78, 56
  %80 = add nuw nsw i128 %69, %79
  %81 = lshr i128 %80, 56
  %82 = add nuw nsw i128 %72, %81
  %83 = lshr i128 %82, 56
  %84 = add nuw nsw i128 %74, %62
  %85 = add nuw nsw i128 %84, %57
  %86 = add nuw nsw i128 %85, %83
  %87 = lshr i128 %86, 56
  %88 = trunc i128 %86 to i64
  %89 = add nuw nsw i128 %75, %63
  %90 = add nuw nsw i128 %89, %58
  %91 = add nuw nsw i128 %90, %87
  %92 = lshr i128 %91, 56
  %93 = trunc i128 %91 to i64
  %94 = add nuw nsw i128 %64, %54
  %95 = add nuw nsw i128 %94, %59
  %96 = add nuw nsw i128 %95, %92
  %97 = lshr i128 %96, 56
  %98 = trunc i128 %96 to i64
  %99 = add nuw nsw i128 %76, %97
  %100 = lshr i128 %99, 56
  %101 = trunc i128 %99 to i64
  %102 = add nuw nsw i128 %100, %66
  %103 = trunc i128 %102 to i64
  %104 = shl i64 %93, 16
  %105 = and i64 %104, 72057594037862400
  %106 = lshr i64 %88, 40
  %107 = and i64 %106, 65535
  %108 = or disjoint i64 %105, %107
  %109 = shl i64 %98, 16
  %110 = and i64 %109, 72057594037862400
  %111 = lshr i64 %93, 40
  %112 = and i64 %111, 65535
  %113 = or disjoint i64 %110, %112
  %114 = shl i64 %101, 16
  %115 = and i64 %114, 72057594037862400
  %116 = lshr i64 %98, 40
  %117 = and i64 %116, 65535
  %118 = or disjoint i64 %115, %117
  %119 = shl i64 %103, 16
  %120 = and i64 %119, 72057594037862400
  %121 = lshr i64 %101, 40
  %122 = and i64 %121, 65535
  %123 = or disjoint i64 %120, %122
  %sh.diff.i.i = lshr i128 %102, 40
  %tr.sh.diff.i.i = trunc nuw nsw i128 %sh.diff.i.i to i64
  %124 = and i64 %tr.sh.diff.i.i, 72057594037862400
  %125 = lshr i64 %103, 40
  %126 = and i64 %125, 65535
  %127 = or disjoint i64 %126, %124
  %128 = and i64 %.sroa.55.0.copyload, 1099511627775
  %129 = zext nneg i64 %108 to i128
  %130 = mul nuw nsw i128 %129, 5175514460705773
  %131 = mul nuw nsw i128 %129, 70332060721272408
  %132 = mul nuw nsw i128 %129, 5342
  %133 = shl nuw nsw i128 %129, 28
  %134 = zext nneg i64 %113 to i128
  %135 = mul nuw nsw i128 %134, 5175514460705773
  %136 = mul nuw nsw i128 %134, 70332060721272408
  %137 = mul nuw nsw i128 %134, 5342
  %138 = zext nneg i64 %118 to i128
  %139 = mul nuw nsw i128 %138, 5175514460705773
  %140 = mul nuw nsw i128 %138, 70332060721272408
  %141 = mul nuw nsw i128 %138, 5342
  %142 = zext nneg i64 %123 to i128
  %143 = mul nuw nsw i128 %142, 5175514460705773
  %144 = mul nuw nsw i128 %142, 699938952792
  %145 = zext nneg i64 %127 to i128
  %146 = mul nuw nsw i128 %145, 113228764141
  %147 = lshr i128 %130, 56
  %148 = trunc i128 %130 to i64
  %149 = and i64 %148, 72057594037927935
  %150 = add nuw nsw i128 %147, %131
  %151 = add nuw nsw i128 %150, %135
  %152 = lshr i128 %151, 56
  %153 = trunc i128 %151 to i64
  %154 = and i64 %153, 72057594037927935
  %155 = add nuw nsw i128 %136, %132
  %156 = add nuw nsw i128 %155, %139
  %157 = add nuw nsw i128 %156, %152
  %158 = lshr i128 %157, 56
  %159 = trunc i128 %157 to i64
  %160 = and i64 %159, 72057594037927935
  %161 = add nuw nsw i128 %140, %137
  %162 = add nuw nsw i128 %161, %143
  %163 = add nuw nsw i128 %162, %158
  %164 = lshr i128 %163, 56
  %165 = trunc i128 %163 to i64
  %166 = and i64 %165, 72057594037927935
  %167 = add nuw nsw i128 %141, %133
  %168 = add nuw nsw i128 %167, %144
  %169 = add nuw nsw i128 %168, %146
  %170 = add nuw nsw i128 %169, %164
  %171 = trunc i128 %170 to i64
  %172 = and i64 %171, 1099511627775
  %173 = sub i64 %.sroa.01.0.copyload, %149
  %.neg9.i = ashr i64 %173, 63
  %174 = lshr i64 %173, 7
  %175 = and i64 %174, 72057594037927936
  %176 = add i64 %175, %173
  %.neg2.i = add i64 %.neg9.i, %.sroa.22.0.copyload
  %177 = sub i64 %.neg2.i, %154
  %.neg.i = ashr i64 %177, 63
  %178 = lshr i64 %177, 7
  %179 = and i64 %178, 72057594037927936
  %180 = add i64 %179, %177
  %.neg5.i = add i64 %.neg.i, %.sroa.33.0.copyload
  %181 = sub i64 %.neg5.i, %160
  %.neg10.i = ashr i64 %181, 63
  %182 = lshr i64 %181, 7
  %183 = and i64 %182, 72057594037927936
  %184 = add i64 %183, %181
  %.neg8.i = sub i64 %.sroa.44.0.copyload, %166
  %185 = add i64 %.neg8.i, %.neg10.i
  %186 = lshr i64 %185, 63
  %187 = shl nuw nsw i64 %186, 56
  %188 = add i64 %187, %185
  %189 = add nuw nsw i64 %186, %172
  %190 = icmp samesign ult i64 %128, %189
  %191 = select i1 %190, i64 1099511627776, i64 0
  %192 = or disjoint i64 %191, %128
  %193 = sub nsw i64 %192, %189
  %194 = add i64 %176, -5175514460705773
  %195 = lshr i64 %194, 63
  %196 = shl nuw nsw i64 %195, 56
  %197 = add i64 %196, %194
  %198 = or disjoint i64 %195, 70332060721272408
  %199 = sub i64 %180, %198
  %200 = lshr i64 %199, 63
  %201 = shl nuw nsw i64 %200, 56
  %202 = add i64 %201, %199
  %203 = or disjoint i64 %200, 5342
  %204 = sub i64 %184, %203
  %.neg.i.i = ashr i64 %204, 63
  %205 = lshr i64 %204, 63
  %206 = shl nuw nsw i64 %205, 56
  %207 = add i64 %206, %204
  %208 = sub i64 %188, %205
  %209 = lshr i64 %208, 63
  %210 = shl nuw nsw i64 %209, 56
  %211 = add i64 %188, %.neg.i.i
  %212 = add i64 %211, %210
  %213 = or disjoint i64 %209, 268435456
  %.not.i.i = icmp slt i64 %193, %213
  %214 = select i1 %.not.i.i, i64 %176, i64 %197
  %215 = select i1 %.not.i.i, i64 %180, i64 %202
  %216 = select i1 %.not.i.i, i64 %184, i64 %207
  %217 = select i1 %.not.i.i, i64 %188, i64 %212
  %218 = select i1 %.not.i.i, i64 0, i64 %213
  %219 = sub nsw i64 %193, %218
  store i64 %214, ptr %3, align 8, !noalias !4
  %.sroa.2.0..sroa_idx.i = getelementptr inbounds nuw i8, ptr %3, i64 8
  store i64 %215, ptr %.sroa.2.0..sroa_idx.i, align 8, !noalias !4
  %.sroa.3.0..sroa_idx.i = getelementptr inbounds nuw i8, ptr %3, i64 16
  store i64 %216, ptr %.sroa.3.0..sroa_idx.i, align 8, !noalias !4
  %.sroa.4.0..sroa_idx.i = getelementptr inbounds nuw i8, ptr %3, i64 24
  store i64 %217, ptr %.sroa.4.0..sroa_idx.i, align 8, !noalias !4
  %.sroa.5.0..sroa_idx.i = getelementptr inbounds nuw i8, ptr %3, i64 32
  store i64 %219, ptr %.sroa.5.0..sroa_idx.i, align 8, !noalias !4
  call fastcc void @Scalar.toBytes(ptr sret([32 x i8]) %6, ptr nonnull readonly align 8 %3)
  call void @llvm.lifetime.end.p0(i64 40, ptr nonnull %3)
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(32) %0, ptr noundef nonnull align 1 dereferenceable(32) %6, i64 32, i1 false)
  ret void
}

; Function Attrs: minsize nofree noinline norecurse nosync nounwind optsize memory(argmem: readwrite, inaccessiblemem: write) uwtable
define internal fastcc void @scalar.mul8(ptr noalias nocapture nonnull writeonly sret([32 x i8]) initializes((0, 32)) %0, ptr nocapture nonnull readonly align 1 %1) unnamed_addr #7 {
  %3 = alloca [32 x i8], align 1
  %4 = alloca %Scalar, align 8
  %5 = alloca %Scalar, align 8
  %6 = alloca %Scalar, align 8
  call fastcc void @Scalar.fromBytes(ptr sret(%Scalar) %6, ptr nonnull readonly align 1 %1)
  call fastcc void @Scalar.add(ptr sret(%Scalar) %5, ptr nonnull readonly align 8 %6, ptr nonnull readonly align 8 %6)
  call fastcc void @Scalar.add(ptr sret(%Scalar) %6, ptr nonnull readonly align 8 %5, ptr nonnull readonly align 8 %5)
  call fastcc void @Scalar.add(ptr sret(%Scalar) %4, ptr nonnull readonly align 8 %6, ptr nonnull readonly align 8 %6)
  call fastcc void @Scalar.toBytes(ptr sret([32 x i8]) %3, ptr nonnull readonly align 8 %4)
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(32) %0, ptr noundef nonnull align 1 dereferenceable(32) %3, i64 32, i1 false)
  ret void
}

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(argmem: readwrite, inaccessiblemem: readwrite) uwtable
define internal fastcc void @Edwards25519.clearCofactor(ptr noalias nocapture nonnull writeonly sret(%Edwards25519) initializes((0, 168)) %0, ptr nocapture nonnull readonly align 8 %1) unnamed_addr #8 {
  %3 = alloca %Edwards25519, align 8
  %4 = alloca %Edwards25519, align 8
  %5 = alloca %Edwards25519, align 8
  call fastcc void @Edwards25519.dbl(ptr sret(%Edwards25519) %5, ptr nonnull readonly align 8 %1)
  call fastcc void @Edwards25519.dbl(ptr sret(%Edwards25519) %4, ptr nonnull readonly align 8 %5)
  call fastcc void @Edwards25519.dbl(ptr sret(%Edwards25519) %3, ptr nonnull readonly align 8 %4)
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(168) %0, ptr noundef nonnull align 8 dereferenceable(168) %3, i64 168, i1 false)
  ret void
}

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(argmem: readwrite) uwtable
define internal fastcc void @Edwards25519.neg(ptr noalias nocapture nonnull writeonly sret(%Edwards25519) initializes((0, 161)) %0, ptr nocapture nonnull readonly align 8 %1) unnamed_addr #9 {
  %3 = alloca %Fe, align 8
  %4 = alloca %Fe, align 8
  %5 = alloca %Edwards25519, align 8
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(168) %5, ptr noundef nonnull align 8 dereferenceable(168) %1, i64 168, i1 false)
  call fastcc void @Fe.neg(ptr sret(%Fe) %4, ptr nonnull readonly align 8 %1)
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(40) %0, ptr noundef nonnull align 8 dereferenceable(40) %4, i64 40, i1 false)
  %6 = getelementptr inbounds nuw i8, ptr %0, i64 40
  %7 = getelementptr inbounds nuw i8, ptr %1, i64 40
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(40) %6, ptr noundef nonnull align 8 dereferenceable(40) %7, i64 40, i1 false)
  %8 = getelementptr inbounds nuw i8, ptr %0, i64 80
  %9 = getelementptr inbounds nuw i8, ptr %1, i64 80
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(40) %8, ptr noundef nonnull align 8 dereferenceable(40) %9, i64 40, i1 false)
  %10 = getelementptr inbounds nuw i8, ptr %0, i64 120
  %11 = getelementptr inbounds nuw i8, ptr %5, i64 120
  call fastcc void @Fe.neg(ptr sret(%Fe) %3, ptr nonnull readonly align 8 %11)
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(40) %10, ptr noundef nonnull align 8 dereferenceable(40) %3, i64 40, i1 false)
  %12 = getelementptr inbounds nuw i8, ptr %0, i64 160
  store i1 false, ptr %12, align 8
  ret void
}

; Function Attrs: minsize nofree noinline norecurse nosync nounwind optsize memory(read, argmem: readwrite, inaccessiblemem: readwrite) uwtable
define internal fastcc void @Edwards25519.mulDoubleBasePublic(ptr noalias nocapture nonnull writeonly sret({ %Edwards25519, i16, [6 x i8] }) %0, ptr nocapture nonnull readonly align 1 %1, ptr nocapture nonnull readonly align 8 %2, ptr nocapture nonnull readonly align 1 %3) unnamed_addr #2 {
  %5 = alloca %Edwards25519, align 8
  %6 = alloca %Edwards25519, align 8
  %7 = alloca %Edwards25519, align 8
  %8 = alloca %Edwards25519, align 8
  %9 = alloca %Edwards25519, align 8
  %10 = alloca %Edwards25519, align 8
  %11 = alloca %Edwards25519, align 8
  %12 = alloca %Edwards25519, align 8
  %13 = alloca [64 x i8], align 1
  %14 = alloca [64 x i8], align 1
  %15 = alloca [9 x %Edwards25519], align 8
  %16 = getelementptr inbounds nuw i8, ptr %2, i64 160
  %17 = load i1, ptr %16, align 8
  br i1 %17, label %18, label %20

common.ret:                                       ; preds = %53, %24
  ret void

18:                                               ; preds = %20, %4
  %19 = phi ptr [ @Edwards25519.basePointPc, %4 ], [ %15, %20 ]
  call fastcc void @Edwards25519.slide(ptr sret([64 x i8]) %14, ptr nonnull readonly align 1 %1)
  call fastcc void @Edwards25519.slide(ptr sret([64 x i8]) %13, ptr nonnull readonly align 1 %3)
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(168) %12, ptr noundef nonnull align 8 dereferenceable(168) @Edwards25519.identityElement, i64 168, i1 false)
  br label %25

20:                                               ; preds = %4
  call fastcc void @Edwards25519.precompute(ptr sret([9 x %Edwards25519]) %15, ptr nonnull readonly align 8 %2)
  %21 = getelementptr inbounds nuw i8, ptr %15, i64 672
  %22 = call fastcc i16 @Edwards25519.rejectIdentity(ptr nonnull readonly align 8 %21)
  %23 = icmp eq i16 %22, 0
  br i1 %23, label %18, label %24

24:                                               ; preds = %20
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(176) %0, ptr noundef nonnull align 8 dereferenceable(176) @Edwards25519.mulDoubleBasePublic.weak, i64 176, i1 false)
  br label %common.ret

25:                                               ; preds = %55, %18
  %.0 = phi i64 [ 63, %18 ], [ %56, %55 ]
  %26 = getelementptr inbounds [64 x i8], ptr %14, i64 0, i64 %.0
  %27 = load i8, ptr %26, align 1
  %28 = icmp sgt i8 %27, 0
  br i1 %28, label %33, label %36

.sink.split:                                      ; preds = %33, %38
  %.sink = phi ptr [ %10, %38 ], [ %11, %33 ]
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(168) %12, ptr noundef nonnull align 8 dereferenceable(168) %.sink, i64 168, i1 false)
  br label %29

29:                                               ; preds = %.sink.split, %36
  %30 = getelementptr inbounds [64 x i8], ptr %13, i64 0, i64 %.0
  %31 = load i8, ptr %30, align 1
  %32 = icmp sgt i8 %31, 0
  br i1 %32, label %44, label %47

33:                                               ; preds = %25
  %34 = zext nneg i8 %27 to i64
  %35 = getelementptr inbounds nuw [9 x %Edwards25519], ptr @Edwards25519.basePointPc, i64 0, i64 %34
  call fastcc void @Edwards25519.add(ptr sret(%Edwards25519) %11, ptr nonnull readonly align 8 %12, ptr nonnull readonly align 8 %35)
  br label %.sink.split

36:                                               ; preds = %25
  %37 = icmp slt i8 %27, 0
  br i1 %37, label %38, label %29

38:                                               ; preds = %36
  %39 = sub nsw i8 0, %27
  %40 = zext nneg i8 %39 to i64
  %41 = getelementptr inbounds nuw [9 x %Edwards25519], ptr @Edwards25519.basePointPc, i64 0, i64 %40
  call fastcc void @Edwards25519.sub(ptr sret(%Edwards25519) %10, ptr nonnull readonly align 8 %12, ptr nonnull readonly align 8 %41)
  br label %.sink.split

.sink.split7:                                     ; preds = %44, %49
  %.sink8 = phi ptr [ %8, %49 ], [ %9, %44 ]
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(168) %12, ptr noundef nonnull align 8 dereferenceable(168) %.sink8, i64 168, i1 false)
  br label %42

42:                                               ; preds = %.sink.split7, %47
  %43 = icmp eq i64 %.0, 0
  br i1 %43, label %53, label %55

44:                                               ; preds = %29
  %45 = zext nneg i8 %31 to i64
  %46 = getelementptr inbounds nuw [9 x %Edwards25519], ptr %19, i64 0, i64 %45
  call fastcc void @Edwards25519.add(ptr sret(%Edwards25519) %9, ptr nonnull readonly align 8 %12, ptr nonnull readonly align 8 %46)
  br label %.sink.split7

47:                                               ; preds = %29
  %48 = icmp slt i8 %31, 0
  br i1 %48, label %49, label %42

49:                                               ; preds = %47
  %50 = sub nsw i8 0, %31
  %51 = zext nneg i8 %50 to i64
  %52 = getelementptr inbounds nuw [9 x %Edwards25519], ptr %19, i64 0, i64 %51
  call fastcc void @Edwards25519.sub(ptr sret(%Edwards25519) %8, ptr nonnull readonly align 8 %12, ptr nonnull readonly align 8 %52)
  br label %.sink.split7

53:                                               ; preds = %42
  %54 = getelementptr inbounds nuw i8, ptr %0, i64 168
  store i16 0, ptr %54, align 8
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(168) %0, ptr noundef nonnull align 8 dereferenceable(168) %12, i64 168, i1 false)
  br label %common.ret

55:                                               ; preds = %42
  call fastcc void @Edwards25519.dbl(ptr sret(%Edwards25519) %7, ptr nonnull readonly align 8 %12)
  call fastcc void @Edwards25519.dbl(ptr sret(%Edwards25519) %6, ptr nonnull readonly align 8 %7)
  call fastcc void @Edwards25519.dbl(ptr sret(%Edwards25519) %5, ptr nonnull readonly align 8 %6)
  call fastcc void @Edwards25519.dbl(ptr sret(%Edwards25519) %12, ptr nonnull readonly align 8 %5)
  %56 = add nsw i64 %.0, -1
  br label %25
}

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(argmem: readwrite, inaccessiblemem: readwrite) uwtable
define internal fastcc void @Edwards25519.sub(ptr noalias nocapture nonnull writeonly sret(%Edwards25519) initializes((0, 168)) %0, ptr nocapture nonnull readonly align 8 %1, ptr nocapture nonnull readonly align 8 %2) unnamed_addr #8 {
  %4 = alloca %Edwards25519, align 8
  %5 = alloca %Edwards25519, align 8
  call fastcc void @Edwards25519.neg(ptr sret(%Edwards25519) %5, ptr nonnull readonly align 8 %2)
  call fastcc void @Edwards25519.add(ptr sret(%Edwards25519) %4, ptr nonnull readonly align 8 %1, ptr nonnull readonly align 8 %5)
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(168) %0, ptr noundef nonnull align 8 dereferenceable(168) %4, i64 168, i1 false)
  ret void
}

; Function Attrs: minsize mustprogress nofree noinline norecurse nosync nounwind optsize willreturn memory(argmem: readwrite) uwtable
define internal fastcc i1 @Verifier.isIdentity(ptr nocapture nonnull readonly align 8 %0) unnamed_addr #10 {
  %2 = alloca %Fe, align 8
  %3 = alloca %Edwards25519, align 8
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(168) %3, ptr noundef nonnull align 8 dereferenceable(168) %0, i64 168, i1 false)
  %4 = tail call fastcc i1 @Fe.isZero(ptr nonnull readonly align 8 %0)
  br i1 %4, label %7, label %5

5:                                                ; preds = %1, %7
  %6 = phi i1 [ %10, %7 ], [ false, %1 ]
  ret i1 %6

7:                                                ; preds = %1
  %8 = getelementptr inbounds nuw i8, ptr %3, i64 40
  %9 = getelementptr inbounds nuw i8, ptr %0, i64 80
  call void @llvm.lifetime.start.p0(i64 40, ptr nonnull %2)
  call fastcc void @Fe.sub(ptr sret(%Fe) %2, ptr nonnull readonly align 8 %8, ptr nonnull readonly align 8 %9)
  %10 = call fastcc i1 @Fe.isZero(ptr nonnull readonly align 8 %2)
  call void @llvm.lifetime.end.p0(i64 40, ptr nonnull %2)
  br label %5
}

; Function Attrs: minsize nofree noinline norecurse nosync nounwind optsize memory(argmem: read) uwtable
define internal fastcc range(i16 0, 2) i16 @scalar.rejectNonCanonical(ptr nocapture nonnull readonly align 1 %0) unnamed_addr #11 {
  br label %2

2:                                                ; preds = %16, %1
  %.09 = phi i64 [ 31, %1 ], [ %22, %16 ]
  %.08 = phi i8 [ 1, %1 ], [ %21, %16 ]
  %.0 = phi i8 [ 0, %1 ], [ %13, %16 ]
  %3 = getelementptr inbounds [32 x i8], ptr %0, i64 0, i64 %.09
  %4 = load i8, ptr %3, align 1
  %5 = zext i8 %4 to i16
  %6 = getelementptr inbounds [32 x i8], ptr @scalar.field_order_s, i64 0, i64 %.09
  %7 = load i8, ptr %6, align 1
  %8 = zext i8 %7 to i16
  %9 = sub nsw i16 %5, %8
  %10 = lshr i16 %9, 8
  %11 = trunc nuw i16 %10 to i8
  %12 = and i8 %.08, %11
  %13 = or i8 %12, %.0
  %14 = icmp eq i64 %.09, 0
  br i1 %14, label %common.ret, label %16

common.ret:                                       ; preds = %2
  %15 = icmp eq i8 %13, 0
  %spec.select = zext i1 %15 to i16
  ret i16 %spec.select

16:                                               ; preds = %2
  %17 = xor i16 %8, %5
  %18 = add nsw i16 %17, -1
  %19 = lshr i16 %18, 8
  %20 = trunc nuw i16 %19 to i8
  %21 = and i8 %.08, %20
  %22 = add nsw i64 %.09, -1
  br label %2
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(argmem: readwrite, inaccessiblemem: readwrite) uwtable
define internal fastcc void @Edwards25519.fromBytes(ptr noalias nocapture nonnull writeonly sret({ %Edwards25519, i16, [6 x i8] }) initializes((0, 161), (168, 170)) %0, ptr nocapture nonnull readonly align 1 %1) unnamed_addr #12 {
  %3 = alloca %Fe, align 8
  %4 = alloca %Fe, align 8
  %5 = alloca %Fe, align 8
  %6 = alloca %Fe, align 8
  %7 = alloca %Fe, align 8
  %8 = alloca %Fe, align 8
  %9 = alloca %Fe, align 8
  %10 = alloca %Fe, align 8
  %11 = alloca %Fe, align 8
  %12 = alloca %Fe, align 8
  %13 = alloca %Fe, align 8
  %14 = alloca %Fe, align 8
  %15 = alloca %Fe, align 8
  %16 = alloca %Fe, align 8
  %17 = alloca %Fe, align 8
  %18 = alloca %Fe, align 8
  %19 = alloca %Fe, align 8
  %20 = alloca %Fe, align 8
  %21 = alloca [32 x i8], align 8
  %.sroa.0 = alloca { %Fe, %Fe, %Fe, %Fe }, align 8
  %.sroa.5.sroa.0 = alloca i8, align 8
  %22 = alloca %Fe, align 8
  %23 = alloca %Fe, align 8
  %24 = alloca %Fe, align 8
  %25 = alloca %Fe, align 8
  %26 = alloca %Fe, align 8
  %27 = alloca %Fe, align 8
  %28 = alloca %Fe, align 8
  %29 = alloca %Fe, align 8
  %30 = alloca %Fe, align 8
  %31 = alloca %Fe, align 8
  %32 = alloca %Fe, align 8
  %33 = alloca %Fe, align 8
  %34 = alloca %Fe, align 8
  %35 = alloca %Fe, align 8
  tail call void @llvm.experimental.noalias.scope.decl(metadata !7)
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %21)
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(32) %21, ptr noundef nonnull readonly align 1 dereferenceable(32) %1, i64 32, i1 false), !noalias !7
  %.0..0..0..0..0..0..i = load i64, ptr %21, align 8, !noalias !7
  %36 = and i64 %.0..0..0..0..0..0..i, 2251799813685247
  %.6.sroa_idx = getelementptr inbounds nuw i8, ptr %21, i64 6
  %.6..6..6..6..6..6..i = load i64, ptr %.6.sroa_idx, align 2, !noalias !7
  %37 = lshr i64 %.6..6..6..6..6..6..i, 3
  %38 = and i64 %37, 2251799813685247
  %.12.sroa_idx = getelementptr inbounds nuw i8, ptr %21, i64 12
  %.12..12..12..12..12..12..i = load i64, ptr %.12.sroa_idx, align 4, !noalias !7
  %39 = lshr i64 %.12..12..12..12..12..12..i, 6
  %40 = and i64 %39, 2251799813685247
  %.19.sroa_idx = getelementptr inbounds nuw i8, ptr %21, i64 19
  %.19..19..19..19..19..19..i = load i64, ptr %.19.sroa_idx, align 1, !noalias !7
  %41 = lshr i64 %.19..19..19..19..19..19..i, 1
  %42 = and i64 %41, 2251799813685247
  %.24.sroa_idx = getelementptr inbounds nuw i8, ptr %21, i64 24
  %.24..24..24..24..24..24..i = load i64, ptr %.24.sroa_idx, align 8, !noalias !7
  %43 = lshr i64 %.24..24..24..24..24..24..i, 12
  %44 = and i64 %43, 2251799813685247
  store i64 %36, ptr %35, align 8, !alias.scope !7
  %.sroa.3.0..sroa_idx.i = getelementptr inbounds nuw i8, ptr %35, i64 8
  store i64 %38, ptr %.sroa.3.0..sroa_idx.i, align 8, !alias.scope !7
  %.sroa.4.0..sroa_idx.i = getelementptr inbounds nuw i8, ptr %35, i64 16
  store i64 %40, ptr %.sroa.4.0..sroa_idx.i, align 8, !alias.scope !7
  %.sroa.5.0..sroa_idx.i = getelementptr inbounds nuw i8, ptr %35, i64 24
  store i64 %42, ptr %.sroa.5.0..sroa_idx.i, align 8, !alias.scope !7
  %.sroa.6.0..sroa_idx.i = getelementptr inbounds nuw i8, ptr %35, i64 32
  store i64 %44, ptr %.sroa.6.0..sroa_idx.i, align 8, !alias.scope !7
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %21)
  call fastcc void @Fe.sq(ptr sret(%Fe) %34, ptr nonnull readonly align 8 %35)
  call fastcc void @Fe.mul(ptr sret(%Fe) %33, ptr nonnull readonly align 8 %34, ptr nonnull readonly align 8 @Fe.edwards25519d)
  call fastcc void @Fe.sub(ptr sret(%Fe) %32, ptr nonnull readonly align 8 %34, ptr nonnull readonly align 8 @Fe.one)
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(40) %34, ptr noundef nonnull align 8 dereferenceable(40) %32, i64 40, i1 false)
  call fastcc void @Fe.add(ptr sret(%Fe) %31, ptr nonnull readonly align 8 %33, ptr nonnull readonly align 8 @Fe.one)
  call fastcc void @Fe.mul(ptr sret(%Fe) %29, ptr nonnull readonly align 8 %32, ptr nonnull readonly align 8 %31)
  call void @llvm.lifetime.start.p0(i64 40, ptr nonnull %4)
  call void @llvm.lifetime.start.p0(i64 40, ptr nonnull %5)
  call void @llvm.lifetime.start.p0(i64 40, ptr nonnull %6)
  call void @llvm.lifetime.start.p0(i64 40, ptr nonnull %7)
  call void @llvm.lifetime.start.p0(i64 40, ptr nonnull %8)
  call void @llvm.lifetime.start.p0(i64 40, ptr nonnull %9)
  call void @llvm.lifetime.start.p0(i64 40, ptr nonnull %10)
  call void @llvm.lifetime.start.p0(i64 40, ptr nonnull %11)
  call void @llvm.lifetime.start.p0(i64 40, ptr nonnull %12)
  call void @llvm.lifetime.start.p0(i64 40, ptr nonnull %13)
  call void @llvm.lifetime.start.p0(i64 40, ptr nonnull %14)
  call void @llvm.lifetime.start.p0(i64 40, ptr nonnull %15)
  call void @llvm.lifetime.start.p0(i64 40, ptr nonnull %16)
  call void @llvm.lifetime.start.p0(i64 40, ptr nonnull %17)
  call void @llvm.lifetime.start.p0(i64 40, ptr nonnull %18)
  call void @llvm.lifetime.start.p0(i64 40, ptr nonnull %19)
  call void @llvm.lifetime.start.p0(i64 40, ptr nonnull %20)
  call fastcc void @Fe.sq(ptr sret(%Fe) %19, ptr nonnull readonly align 8 %29), !noalias !10
  call fastcc void @Fe.mul(ptr sret(%Fe) %20, ptr nonnull readonly align 8 %29, ptr nonnull readonly align 8 %19), !noalias !10
  call fastcc void @Fe.sqn(ptr sret(%Fe) %17, ptr nonnull readonly align 8 %20, i64 2), !noalias !10
  call fastcc void @Fe.mul(ptr sret(%Fe) %16, ptr nonnull readonly align 8 %20, ptr nonnull readonly align 8 %17), !noalias !10
  call fastcc void @Fe.sq(ptr sret(%Fe) %15, ptr nonnull readonly align 8 %16), !noalias !10
  call fastcc void @Fe.mul(ptr sret(%Fe) %18, ptr nonnull readonly align 8 %15, ptr nonnull readonly align 8 %29), !noalias !10
  call fastcc void @Fe.sqn(ptr sret(%Fe) %14, ptr nonnull readonly align 8 %18, i64 5), !noalias !10
  call fastcc void @Fe.mul(ptr sret(%Fe) %20, ptr nonnull readonly align 8 %14, ptr nonnull readonly align 8 %18), !noalias !10
  call fastcc void @Fe.sqn(ptr sret(%Fe) %12, ptr nonnull readonly align 8 %20, i64 5), !noalias !10
  call fastcc void @Fe.mul(ptr sret(%Fe) %13, ptr nonnull readonly align 8 %12, ptr nonnull readonly align 8 %18), !noalias !10
  call fastcc void @Fe.sqn(ptr sret(%Fe) %11, ptr nonnull readonly align 8 %13, i64 15), !noalias !10
  call fastcc void @Fe.mul(ptr sret(%Fe) %18, ptr nonnull readonly align 8 %11, ptr nonnull readonly align 8 %13), !noalias !10
  call fastcc void @Fe.sqn(ptr sret(%Fe) %10, ptr nonnull readonly align 8 %18, i64 30), !noalias !10
  call fastcc void @Fe.mul(ptr sret(%Fe) %13, ptr nonnull readonly align 8 %10, ptr nonnull readonly align 8 %18), !noalias !10
  call fastcc void @Fe.sqn(ptr sret(%Fe) %9, ptr nonnull readonly align 8 %13, i64 60), !noalias !10
  call fastcc void @Fe.mul(ptr sret(%Fe) %18, ptr nonnull readonly align 8 %9, ptr nonnull readonly align 8 %13), !noalias !10
  call fastcc void @Fe.sqn(ptr sret(%Fe) %8, ptr nonnull readonly align 8 %18, i64 120), !noalias !10
  call fastcc void @Fe.mul(ptr sret(%Fe) %7, ptr nonnull readonly align 8 %8, ptr nonnull readonly align 8 %18), !noalias !10
  call fastcc void @Fe.sqn(ptr sret(%Fe) %6, ptr nonnull readonly align 8 %7, i64 10), !noalias !10
  call fastcc void @Fe.mul(ptr sret(%Fe) %5, ptr nonnull readonly align 8 %6, ptr nonnull readonly align 8 %20), !noalias !10
  call fastcc void @Fe.sqn(ptr sret(%Fe) %4, ptr nonnull readonly align 8 %5, i64 2), !noalias !10
  call fastcc void @Fe.mul(ptr sret(%Fe) %28, ptr nonnull readonly align 8 %4, ptr nonnull readonly align 8 %29)
  call void @llvm.lifetime.end.p0(i64 40, ptr nonnull %4)
  call void @llvm.lifetime.end.p0(i64 40, ptr nonnull %5)
  call void @llvm.lifetime.end.p0(i64 40, ptr nonnull %6)
  call void @llvm.lifetime.end.p0(i64 40, ptr nonnull %7)
  call void @llvm.lifetime.end.p0(i64 40, ptr nonnull %8)
  call void @llvm.lifetime.end.p0(i64 40, ptr nonnull %9)
  call void @llvm.lifetime.end.p0(i64 40, ptr nonnull %10)
  call void @llvm.lifetime.end.p0(i64 40, ptr nonnull %11)
  call void @llvm.lifetime.end.p0(i64 40, ptr nonnull %12)
  call void @llvm.lifetime.end.p0(i64 40, ptr nonnull %13)
  call void @llvm.lifetime.end.p0(i64 40, ptr nonnull %14)
  call void @llvm.lifetime.end.p0(i64 40, ptr nonnull %15)
  call void @llvm.lifetime.end.p0(i64 40, ptr nonnull %16)
  call void @llvm.lifetime.end.p0(i64 40, ptr nonnull %17)
  call void @llvm.lifetime.end.p0(i64 40, ptr nonnull %18)
  call void @llvm.lifetime.end.p0(i64 40, ptr nonnull %19)
  call void @llvm.lifetime.end.p0(i64 40, ptr nonnull %20)
  call fastcc void @Fe.mul(ptr sret(%Fe) %30, ptr nonnull readonly align 8 %28, ptr nonnull readonly align 8 %32)
  call fastcc void @Fe.sq(ptr sret(%Fe) %27, ptr nonnull readonly align 8 %30)
  call fastcc void @Fe.mul(ptr sret(%Fe) %26, ptr nonnull readonly align 8 %27, ptr nonnull readonly align 8 %31)
  call fastcc void @Fe.sub(ptr sret(%Fe) %25, ptr nonnull readonly align 8 %26, ptr nonnull readonly align 8 %32)
  %45 = call fastcc i1 @Fe.isZero(ptr nonnull readonly align 8 %25)
  %46 = load i64, ptr %26, align 8, !noalias !13
  %47 = load i64, ptr %34, align 8, !noalias !13
  %48 = add nuw i64 %47, %46
  %49 = getelementptr inbounds nuw i8, ptr %26, i64 8
  %50 = load i64, ptr %49, align 8, !noalias !13
  %51 = getelementptr inbounds nuw i8, ptr %34, i64 8
  %52 = load i64, ptr %51, align 8, !noalias !13
  %53 = add nuw i64 %52, %50
  %54 = getelementptr inbounds nuw i8, ptr %26, i64 16
  %55 = load i64, ptr %54, align 8, !noalias !13
  %56 = getelementptr inbounds nuw i8, ptr %34, i64 16
  %57 = load i64, ptr %56, align 8, !noalias !13
  %58 = add nuw i64 %57, %55
  %59 = getelementptr inbounds nuw i8, ptr %26, i64 24
  %60 = load i64, ptr %59, align 8, !noalias !13
  %61 = getelementptr inbounds nuw i8, ptr %34, i64 24
  %62 = load i64, ptr %61, align 8, !noalias !13
  %63 = add nuw i64 %62, %60
  %64 = getelementptr inbounds nuw i8, ptr %26, i64 32
  %65 = load i64, ptr %64, align 8, !noalias !13
  %66 = getelementptr inbounds nuw i8, ptr %34, i64 32
  %67 = load i64, ptr %66, align 8, !noalias !13
  %68 = add nuw i64 %67, %65
  store i64 %48, ptr %24, align 8
  %.sroa.2.0..sroa_idx = getelementptr inbounds nuw i8, ptr %24, i64 8
  store i64 %53, ptr %.sroa.2.0..sroa_idx, align 8
  %.sroa.3.0..sroa_idx = getelementptr inbounds nuw i8, ptr %24, i64 16
  store i64 %58, ptr %.sroa.3.0..sroa_idx, align 8
  %.sroa.4.0..sroa_idx = getelementptr inbounds nuw i8, ptr %24, i64 24
  store i64 %63, ptr %.sroa.4.0..sroa_idx, align 8
  %.sroa.57.0..sroa_idx = getelementptr inbounds nuw i8, ptr %24, i64 32
  store i64 %68, ptr %.sroa.57.0..sroa_idx, align 8
  %69 = call fastcc i1 @Fe.isZero(ptr nonnull readonly align 8 %24)
  %70 = or i1 %45, %69
  br i1 %70, label %72, label %71

common.ret:                                       ; preds = %71, %72
  ret void

71:                                               ; preds = %2
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(176) %0, ptr noundef nonnull align 8 dereferenceable(176) @Edwards25519.fromBytes.invalid, i64 176, i1 false)
  br label %common.ret

72:                                               ; preds = %2
  call fastcc void @Fe.mul(ptr sret(%Fe) %23, ptr nonnull readonly align 8 %30, ptr nonnull readonly align 8 @Fe.sqrtm1)
  %73 = xor i1 %45, true
  %74 = zext i1 %73 to i64
  call fastcc void @Fe.cMov(ptr nonnull align 8 %30, ptr nonnull readonly align 8 %23, i64 %74)
  call fastcc void @Fe.neg(ptr sret(%Fe) %22, ptr nonnull readonly align 8 %30)
  call void @llvm.lifetime.start.p0(i64 40, ptr nonnull %3)
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(40) %3, ptr noundef nonnull readonly align 8 dereferenceable(40) %30, i64 40, i1 false)
  call fastcc void @Fe.reduce(ptr nonnull align 8 %3), !noalias !16
  %75 = load i64, ptr %3, align 8, !noalias !16
  call void @llvm.lifetime.end.p0(i64 40, ptr nonnull %3)
  %76 = getelementptr inbounds nuw i8, ptr %1, i64 31
  %77 = load i8, ptr %76, align 1
  %78 = lshr i8 %77, 7
  %79 = trunc i64 %75 to i8
  %80 = and i8 %79, 1
  %81 = xor i8 %78, %80
  %82 = zext nneg i8 %81 to i64
  call fastcc void @Fe.cMov(ptr nonnull align 8 %30, ptr nonnull readonly align 8 %22, i64 %82)
  %.sroa.0.120.sroa_idx = getelementptr inbounds nuw i8, ptr %.sroa.0, i64 120
  call fastcc void @Fe.mul(ptr sret(%Fe) %.sroa.0.120.sroa_idx, ptr nonnull readonly align 8 %30, ptr nonnull readonly align 8 %35)
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(40) %.sroa.0, ptr noundef nonnull align 8 dereferenceable(40) %30, i64 40, i1 false)
  %.sroa.0.40.sroa_idx = getelementptr inbounds nuw i8, ptr %.sroa.0, i64 40
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(40) %.sroa.0.40.sroa_idx, ptr noundef nonnull align 8 dereferenceable(40) %35, i64 40, i1 false)
  %.sroa.0.80.sroa_idx = getelementptr inbounds nuw i8, ptr %.sroa.0, i64 80
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(40) %.sroa.0.80.sroa_idx, ptr noundef nonnull align 8 dereferenceable(40) @Fe.one, i64 40, i1 false)
  store i1 false, ptr %.sroa.5.sroa.0, align 8
  %83 = getelementptr inbounds nuw i8, ptr %0, i64 168
  store i16 0, ptr %83, align 8
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(160) %0, ptr noundef nonnull align 8 dereferenceable(160) %.sroa.0, i64 160, i1 false)
  %.sroa.5.0..sroa_idx = getelementptr inbounds nuw i8, ptr %0, i64 160
  %.sroa.5.sroa.0.0..sroa.5.sroa.0.0..sroa.5.sroa.0.0..sroa.5.sroa.0.0. = load i8, ptr %.sroa.5.sroa.0, align 8
  store i8 %.sroa.5.sroa.0.0..sroa.5.sroa.0.0..sroa.5.sroa.0.0..sroa.5.sroa.0.0., ptr %.sroa.5.0..sroa_idx, align 8
  br label %common.ret
}

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(argmem: readwrite) uwtable
define internal fastcc range(i16 0, 4) i16 @Edwards25519.rejectIdentity(ptr nocapture nonnull readonly align 8 %0) unnamed_addr #9 {
common.ret:
  %1 = tail call fastcc i1 @Fe.isZero(ptr nonnull readonly align 8 %0)
  %spec.select = select i1 %1, i16 3, i16 0
  ret i16 %spec.select
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(argmem: readwrite) uwtable
define internal fastcc void @Sha512.round(ptr nocapture nonnull align 16 %0, ptr nocapture nonnull readonly align 1 %1) unnamed_addr #13 {
  %3 = alloca [8 x i64], align 8
  %4 = alloca [80 x i64], align 8
  br label %5

5:                                                ; preds = %6, %2
  %.01544 = phi i64 [ 0, %2 ], [ %12, %6 ]
  %exitcond.not = icmp eq i64 %.01544, 16
  br i1 %exitcond.not, label %.preheader, label %6

6:                                                ; preds = %5
  %7 = getelementptr inbounds nuw [80 x i64], ptr %4, i64 0, i64 %.01544
  %8 = shl nuw nsw i64 %.01544, 3
  %9 = getelementptr inbounds nuw i8, ptr %1, i64 %8
  %10 = load i64, ptr %9, align 1
  %11 = tail call i64 @llvm.bswap.i64(i64 %10)
  store i64 %11, ptr %7, align 8
  %12 = add nuw nsw i64 %.01544, 1
  br label %5

.preheader:                                       ; preds = %5, %13
  %.1 = phi i64 [ %40, %13 ], [ 16, %5 ]
  %exitcond1545.not = icmp eq i64 %.1, 80
  br i1 %exitcond1545.not, label %41, label %13

13:                                               ; preds = %.preheader
  %14 = getelementptr inbounds nuw [80 x i64], ptr %4, i64 0, i64 %.1
  %15 = add nsw i64 %.1, -16
  %16 = getelementptr inbounds nuw [80 x i64], ptr %4, i64 0, i64 %15
  %17 = load i64, ptr %16, align 8
  %18 = add nsw i64 %.1, -7
  %19 = getelementptr inbounds nuw [80 x i64], ptr %4, i64 0, i64 %18
  %20 = load i64, ptr %19, align 8
  %21 = add i64 %20, %17
  %22 = add nsw i64 %.1, -15
  %23 = getelementptr inbounds nuw [80 x i64], ptr %4, i64 0, i64 %22
  %24 = load i64, ptr %23, align 8
  %25 = tail call i64 @llvm.fshl.i64(i64 %24, i64 %24, i64 63)
  %26 = tail call i64 @llvm.fshl.i64(i64 %24, i64 %24, i64 56)
  %27 = xor i64 %25, %26
  %28 = lshr i64 %24, 7
  %29 = xor i64 %27, %28
  %30 = add i64 %21, %29
  %31 = add nsw i64 %.1, -2
  %32 = getelementptr inbounds nuw [80 x i64], ptr %4, i64 0, i64 %31
  %33 = load i64, ptr %32, align 8
  %34 = tail call i64 @llvm.fshl.i64(i64 %33, i64 %33, i64 45)
  %35 = tail call i64 @llvm.fshl.i64(i64 %33, i64 %33, i64 3)
  %36 = xor i64 %34, %35
  %37 = lshr i64 %33, 6
  %38 = xor i64 %36, %37
  %39 = add i64 %30, %38
  store i64 %39, ptr %14, align 8
  %40 = add nuw nsw i64 %.1, 1
  br label %.preheader

41:                                               ; preds = %.preheader
  %42 = getelementptr inbounds nuw i8, ptr %0, i64 16
  %.sroa.0.0.copyload = load i64, ptr %42, align 16
  %.sroa.222.0..sroa_idx = getelementptr inbounds nuw i8, ptr %0, i64 24
  %.sroa.222.0.copyload = load i64, ptr %.sroa.222.0..sroa_idx, align 8
  %.sroa.442.0..sroa_idx = getelementptr inbounds nuw i8, ptr %0, i64 32
  %.sroa.442.0.copyload = load i64, ptr %.sroa.442.0..sroa_idx, align 16
  %.sroa.662.0..sroa_idx = getelementptr inbounds nuw i8, ptr %0, i64 40
  %.sroa.662.0.copyload = load i64, ptr %.sroa.662.0..sroa_idx, align 8
  %.sroa.882.0..sroa_idx = getelementptr inbounds nuw i8, ptr %0, i64 48
  %.sroa.882.0.copyload = load i64, ptr %.sroa.882.0..sroa_idx, align 16
  %.sroa.1102.0..sroa_idx = getelementptr inbounds nuw i8, ptr %0, i64 56
  %.sroa.1102.0.copyload = load i64, ptr %.sroa.1102.0..sroa_idx, align 8
  %.sroa.1322.0..sroa_idx = getelementptr inbounds nuw i8, ptr %0, i64 64
  %.sroa.1322.0.copyload = load i64, ptr %.sroa.1322.0..sroa_idx, align 16
  %.sroa.1542.0..sroa_idx = getelementptr inbounds nuw i8, ptr %0, i64 72
  %.sroa.1542.0.copyload = load i64, ptr %.sroa.1542.0..sroa_idx, align 8
  %43 = tail call i64 @llvm.fshl.i64(i64 %.sroa.882.0.copyload, i64 %.sroa.882.0.copyload, i64 50)
  %44 = tail call i64 @llvm.fshl.i64(i64 %.sroa.882.0.copyload, i64 %.sroa.882.0.copyload, i64 46)
  %45 = xor i64 %43, %44
  %46 = tail call i64 @llvm.fshl.i64(i64 %.sroa.882.0.copyload, i64 %.sroa.882.0.copyload, i64 23)
  %47 = xor i64 %45, %46
  %48 = xor i64 %.sroa.1322.0.copyload, %.sroa.1102.0.copyload
  %49 = and i64 %48, %.sroa.882.0.copyload
  %50 = xor i64 %49, %.sroa.1322.0.copyload
  %51 = load i64, ptr %4, align 8
  %52 = add i64 %47, 4794697086780616226
  %53 = add i64 %52, %.sroa.1542.0.copyload
  %54 = add i64 %53, %51
  %55 = add i64 %54, %50
  %56 = add i64 %55, %.sroa.662.0.copyload
  %57 = tail call i64 @llvm.fshl.i64(i64 %.sroa.0.0.copyload, i64 %.sroa.0.0.copyload, i64 36)
  %58 = tail call i64 @llvm.fshl.i64(i64 %.sroa.0.0.copyload, i64 %.sroa.0.0.copyload, i64 30)
  %59 = xor i64 %57, %58
  %60 = tail call i64 @llvm.fshl.i64(i64 %.sroa.0.0.copyload, i64 %.sroa.0.0.copyload, i64 25)
  %61 = xor i64 %59, %60
  %62 = or i64 %.sroa.442.0.copyload, %.sroa.222.0.copyload
  %63 = and i64 %62, %.sroa.0.0.copyload
  %64 = and i64 %.sroa.442.0.copyload, %.sroa.222.0.copyload
  %65 = or i64 %63, %64
  %66 = add i64 %65, %61
  %67 = add i64 %66, %55
  %68 = tail call i64 @llvm.fshl.i64(i64 %56, i64 %56, i64 50)
  %69 = tail call i64 @llvm.fshl.i64(i64 %56, i64 %56, i64 46)
  %70 = xor i64 %68, %69
  %71 = tail call i64 @llvm.fshl.i64(i64 %56, i64 %56, i64 23)
  %72 = xor i64 %70, %71
  %73 = xor i64 %.sroa.1102.0.copyload, %.sroa.882.0.copyload
  %74 = and i64 %56, %73
  %75 = xor i64 %74, %.sroa.1102.0.copyload
  %76 = getelementptr inbounds nuw i8, ptr %4, i64 8
  %77 = load i64, ptr %76, align 8
  %78 = add i64 %.sroa.1322.0.copyload, 8158064640168781261
  %79 = add i64 %78, %77
  %80 = add i64 %79, %75
  %81 = add i64 %80, %72
  %82 = add i64 %81, %.sroa.442.0.copyload
  %83 = tail call i64 @llvm.fshl.i64(i64 %67, i64 %67, i64 36)
  %84 = tail call i64 @llvm.fshl.i64(i64 %67, i64 %67, i64 30)
  %85 = xor i64 %83, %84
  %86 = tail call i64 @llvm.fshl.i64(i64 %67, i64 %67, i64 25)
  %87 = xor i64 %85, %86
  %88 = or i64 %.sroa.222.0.copyload, %.sroa.0.0.copyload
  %89 = and i64 %67, %88
  %90 = and i64 %.sroa.222.0.copyload, %.sroa.0.0.copyload
  %91 = or i64 %89, %90
  %92 = add i64 %87, %91
  %93 = add i64 %92, %81
  %94 = tail call i64 @llvm.fshl.i64(i64 %82, i64 %82, i64 50)
  %95 = tail call i64 @llvm.fshl.i64(i64 %82, i64 %82, i64 46)
  %96 = xor i64 %94, %95
  %97 = tail call i64 @llvm.fshl.i64(i64 %82, i64 %82, i64 23)
  %98 = xor i64 %96, %97
  %99 = xor i64 %56, %.sroa.882.0.copyload
  %100 = and i64 %82, %99
  %101 = xor i64 %100, %.sroa.882.0.copyload
  %102 = getelementptr inbounds nuw i8, ptr %4, i64 16
  %103 = load i64, ptr %102, align 8
  %104 = add i64 %.sroa.1102.0.copyload, -5349999486874862801
  %105 = add i64 %104, %103
  %106 = add i64 %105, %101
  %107 = add i64 %106, %98
  %108 = add i64 %107, %.sroa.222.0.copyload
  %109 = tail call i64 @llvm.fshl.i64(i64 %93, i64 %93, i64 36)
  %110 = tail call i64 @llvm.fshl.i64(i64 %93, i64 %93, i64 30)
  %111 = xor i64 %109, %110
  %112 = tail call i64 @llvm.fshl.i64(i64 %93, i64 %93, i64 25)
  %113 = xor i64 %111, %112
  %114 = or i64 %67, %.sroa.0.0.copyload
  %115 = and i64 %93, %114
  %116 = and i64 %67, %.sroa.0.0.copyload
  %117 = or i64 %115, %116
  %118 = add i64 %113, %117
  %119 = add i64 %118, %107
  %120 = tail call i64 @llvm.fshl.i64(i64 %108, i64 %108, i64 50)
  %121 = tail call i64 @llvm.fshl.i64(i64 %108, i64 %108, i64 46)
  %122 = xor i64 %120, %121
  %123 = tail call i64 @llvm.fshl.i64(i64 %108, i64 %108, i64 23)
  %124 = xor i64 %122, %123
  %125 = xor i64 %82, %56
  %126 = and i64 %108, %125
  %127 = xor i64 %126, %56
  %128 = getelementptr inbounds nuw i8, ptr %4, i64 24
  %129 = load i64, ptr %128, align 8
  %130 = add i64 %.sroa.882.0.copyload, -1606136188198331460
  %131 = add i64 %130, %129
  %132 = add i64 %131, %127
  %133 = add i64 %132, %124
  %134 = add i64 %133, %.sroa.0.0.copyload
  %135 = tail call i64 @llvm.fshl.i64(i64 %119, i64 %119, i64 36)
  %136 = tail call i64 @llvm.fshl.i64(i64 %119, i64 %119, i64 30)
  %137 = xor i64 %135, %136
  %138 = tail call i64 @llvm.fshl.i64(i64 %119, i64 %119, i64 25)
  %139 = xor i64 %137, %138
  %140 = or i64 %93, %67
  %141 = and i64 %119, %140
  %142 = and i64 %93, %67
  %143 = or i64 %141, %142
  %144 = add i64 %139, %143
  %145 = add i64 %144, %133
  %146 = tail call i64 @llvm.fshl.i64(i64 %134, i64 %134, i64 50)
  %147 = tail call i64 @llvm.fshl.i64(i64 %134, i64 %134, i64 46)
  %148 = xor i64 %146, %147
  %149 = tail call i64 @llvm.fshl.i64(i64 %134, i64 %134, i64 23)
  %150 = xor i64 %148, %149
  %151 = xor i64 %108, %82
  %152 = and i64 %134, %151
  %153 = xor i64 %152, %82
  %154 = getelementptr inbounds nuw i8, ptr %4, i64 32
  %155 = load i64, ptr %154, align 8
  %156 = add i64 %155, 4131703408338449720
  %157 = add i64 %156, %56
  %158 = add i64 %157, %153
  %159 = add i64 %158, %150
  %160 = add i64 %159, %67
  %161 = tail call i64 @llvm.fshl.i64(i64 %145, i64 %145, i64 36)
  %162 = tail call i64 @llvm.fshl.i64(i64 %145, i64 %145, i64 30)
  %163 = xor i64 %161, %162
  %164 = tail call i64 @llvm.fshl.i64(i64 %145, i64 %145, i64 25)
  %165 = xor i64 %163, %164
  %166 = or i64 %119, %93
  %167 = and i64 %145, %166
  %168 = and i64 %119, %93
  %169 = or i64 %167, %168
  %170 = add i64 %165, %169
  %171 = add i64 %170, %159
  %172 = tail call i64 @llvm.fshl.i64(i64 %160, i64 %160, i64 50)
  %173 = tail call i64 @llvm.fshl.i64(i64 %160, i64 %160, i64 46)
  %174 = xor i64 %172, %173
  %175 = tail call i64 @llvm.fshl.i64(i64 %160, i64 %160, i64 23)
  %176 = xor i64 %174, %175
  %177 = xor i64 %134, %108
  %178 = and i64 %160, %177
  %179 = xor i64 %178, %108
  %180 = getelementptr inbounds nuw i8, ptr %4, i64 40
  %181 = load i64, ptr %180, align 8
  %182 = add i64 %181, 6480981068601479193
  %183 = add i64 %182, %82
  %184 = add i64 %183, %179
  %185 = add i64 %184, %176
  %186 = add i64 %185, %93
  %187 = tail call i64 @llvm.fshl.i64(i64 %171, i64 %171, i64 36)
  %188 = tail call i64 @llvm.fshl.i64(i64 %171, i64 %171, i64 30)
  %189 = xor i64 %187, %188
  %190 = tail call i64 @llvm.fshl.i64(i64 %171, i64 %171, i64 25)
  %191 = xor i64 %189, %190
  %192 = or i64 %145, %119
  %193 = and i64 %171, %192
  %194 = and i64 %145, %119
  %195 = or i64 %193, %194
  %196 = add i64 %191, %195
  %197 = add i64 %196, %185
  %198 = tail call i64 @llvm.fshl.i64(i64 %186, i64 %186, i64 50)
  %199 = tail call i64 @llvm.fshl.i64(i64 %186, i64 %186, i64 46)
  %200 = xor i64 %198, %199
  %201 = tail call i64 @llvm.fshl.i64(i64 %186, i64 %186, i64 23)
  %202 = xor i64 %200, %201
  %203 = xor i64 %160, %134
  %204 = and i64 %186, %203
  %205 = xor i64 %204, %134
  %206 = getelementptr inbounds nuw i8, ptr %4, i64 48
  %207 = load i64, ptr %206, align 8
  %208 = add i64 %207, -7908458776815382629
  %209 = add i64 %208, %108
  %210 = add i64 %209, %205
  %211 = add i64 %210, %202
  %212 = add i64 %211, %119
  %213 = tail call i64 @llvm.fshl.i64(i64 %197, i64 %197, i64 36)
  %214 = tail call i64 @llvm.fshl.i64(i64 %197, i64 %197, i64 30)
  %215 = xor i64 %213, %214
  %216 = tail call i64 @llvm.fshl.i64(i64 %197, i64 %197, i64 25)
  %217 = xor i64 %215, %216
  %218 = or i64 %171, %145
  %219 = and i64 %197, %218
  %220 = and i64 %171, %145
  %221 = or i64 %219, %220
  %222 = add i64 %217, %221
  %223 = add i64 %222, %211
  %224 = tail call i64 @llvm.fshl.i64(i64 %212, i64 %212, i64 50)
  %225 = tail call i64 @llvm.fshl.i64(i64 %212, i64 %212, i64 46)
  %226 = xor i64 %224, %225
  %227 = tail call i64 @llvm.fshl.i64(i64 %212, i64 %212, i64 23)
  %228 = xor i64 %226, %227
  %229 = xor i64 %186, %160
  %230 = and i64 %212, %229
  %231 = xor i64 %230, %160
  %232 = getelementptr inbounds nuw i8, ptr %4, i64 56
  %233 = load i64, ptr %232, align 8
  %234 = add i64 %233, -6116909921290321640
  %235 = add i64 %234, %134
  %236 = add i64 %235, %231
  %237 = add i64 %236, %228
  %238 = add i64 %237, %145
  %239 = tail call i64 @llvm.fshl.i64(i64 %223, i64 %223, i64 36)
  %240 = tail call i64 @llvm.fshl.i64(i64 %223, i64 %223, i64 30)
  %241 = xor i64 %239, %240
  %242 = tail call i64 @llvm.fshl.i64(i64 %223, i64 %223, i64 25)
  %243 = xor i64 %241, %242
  %244 = or i64 %197, %171
  %245 = and i64 %223, %244
  %246 = and i64 %197, %171
  %247 = or i64 %245, %246
  %248 = add i64 %243, %247
  %249 = add i64 %248, %237
  %250 = tail call i64 @llvm.fshl.i64(i64 %238, i64 %238, i64 50)
  %251 = tail call i64 @llvm.fshl.i64(i64 %238, i64 %238, i64 46)
  %252 = xor i64 %250, %251
  %253 = tail call i64 @llvm.fshl.i64(i64 %238, i64 %238, i64 23)
  %254 = xor i64 %252, %253
  %255 = xor i64 %212, %186
  %256 = and i64 %238, %255
  %257 = xor i64 %256, %186
  %258 = getelementptr inbounds nuw i8, ptr %4, i64 64
  %259 = load i64, ptr %258, align 8
  %260 = add i64 %259, -2880145864133508542
  %261 = add i64 %260, %160
  %262 = add i64 %261, %257
  %263 = add i64 %262, %254
  %264 = add i64 %263, %171
  %265 = tail call i64 @llvm.fshl.i64(i64 %249, i64 %249, i64 36)
  %266 = tail call i64 @llvm.fshl.i64(i64 %249, i64 %249, i64 30)
  %267 = xor i64 %265, %266
  %268 = tail call i64 @llvm.fshl.i64(i64 %249, i64 %249, i64 25)
  %269 = xor i64 %267, %268
  %270 = or i64 %223, %197
  %271 = and i64 %249, %270
  %272 = and i64 %223, %197
  %273 = or i64 %271, %272
  %274 = add i64 %269, %273
  %275 = add i64 %274, %263
  %276 = tail call i64 @llvm.fshl.i64(i64 %264, i64 %264, i64 50)
  %277 = tail call i64 @llvm.fshl.i64(i64 %264, i64 %264, i64 46)
  %278 = xor i64 %276, %277
  %279 = tail call i64 @llvm.fshl.i64(i64 %264, i64 %264, i64 23)
  %280 = xor i64 %278, %279
  %281 = xor i64 %238, %212
  %282 = and i64 %264, %281
  %283 = xor i64 %282, %212
  %284 = getelementptr inbounds nuw i8, ptr %4, i64 72
  %285 = load i64, ptr %284, align 8
  %286 = add i64 %285, 1334009975649890238
  %287 = add i64 %286, %186
  %288 = add i64 %287, %283
  %289 = add i64 %288, %280
  %290 = add i64 %289, %197
  %291 = tail call i64 @llvm.fshl.i64(i64 %275, i64 %275, i64 36)
  %292 = tail call i64 @llvm.fshl.i64(i64 %275, i64 %275, i64 30)
  %293 = xor i64 %291, %292
  %294 = tail call i64 @llvm.fshl.i64(i64 %275, i64 %275, i64 25)
  %295 = xor i64 %293, %294
  %296 = or i64 %249, %223
  %297 = and i64 %275, %296
  %298 = and i64 %249, %223
  %299 = or i64 %297, %298
  %300 = add i64 %295, %299
  %301 = add i64 %300, %289
  %302 = tail call i64 @llvm.fshl.i64(i64 %290, i64 %290, i64 50)
  %303 = tail call i64 @llvm.fshl.i64(i64 %290, i64 %290, i64 46)
  %304 = xor i64 %302, %303
  %305 = tail call i64 @llvm.fshl.i64(i64 %290, i64 %290, i64 23)
  %306 = xor i64 %304, %305
  %307 = xor i64 %264, %238
  %308 = and i64 %290, %307
  %309 = xor i64 %308, %238
  %310 = getelementptr inbounds nuw i8, ptr %4, i64 80
  %311 = load i64, ptr %310, align 8
  %312 = add i64 %311, 2608012711638119052
  %313 = add i64 %312, %212
  %314 = add i64 %313, %309
  %315 = add i64 %314, %306
  %316 = add i64 %315, %223
  %317 = tail call i64 @llvm.fshl.i64(i64 %301, i64 %301, i64 36)
  %318 = tail call i64 @llvm.fshl.i64(i64 %301, i64 %301, i64 30)
  %319 = xor i64 %317, %318
  %320 = tail call i64 @llvm.fshl.i64(i64 %301, i64 %301, i64 25)
  %321 = xor i64 %319, %320
  %322 = or i64 %275, %249
  %323 = and i64 %301, %322
  %324 = and i64 %275, %249
  %325 = or i64 %323, %324
  %326 = add i64 %321, %325
  %327 = add i64 %326, %315
  %328 = tail call i64 @llvm.fshl.i64(i64 %316, i64 %316, i64 50)
  %329 = tail call i64 @llvm.fshl.i64(i64 %316, i64 %316, i64 46)
  %330 = xor i64 %328, %329
  %331 = tail call i64 @llvm.fshl.i64(i64 %316, i64 %316, i64 23)
  %332 = xor i64 %330, %331
  %333 = xor i64 %290, %264
  %334 = and i64 %316, %333
  %335 = xor i64 %334, %264
  %336 = getelementptr inbounds nuw i8, ptr %4, i64 88
  %337 = load i64, ptr %336, align 8
  %338 = add i64 %337, 6128411473006802146
  %339 = add i64 %338, %238
  %340 = add i64 %339, %335
  %341 = add i64 %340, %332
  %342 = add i64 %341, %249
  %343 = tail call i64 @llvm.fshl.i64(i64 %327, i64 %327, i64 36)
  %344 = tail call i64 @llvm.fshl.i64(i64 %327, i64 %327, i64 30)
  %345 = xor i64 %343, %344
  %346 = tail call i64 @llvm.fshl.i64(i64 %327, i64 %327, i64 25)
  %347 = xor i64 %345, %346
  %348 = or i64 %301, %275
  %349 = and i64 %327, %348
  %350 = and i64 %301, %275
  %351 = or i64 %349, %350
  %352 = add i64 %347, %351
  %353 = add i64 %352, %341
  %354 = tail call i64 @llvm.fshl.i64(i64 %342, i64 %342, i64 50)
  %355 = tail call i64 @llvm.fshl.i64(i64 %342, i64 %342, i64 46)
  %356 = xor i64 %354, %355
  %357 = tail call i64 @llvm.fshl.i64(i64 %342, i64 %342, i64 23)
  %358 = xor i64 %356, %357
  %359 = xor i64 %316, %290
  %360 = and i64 %342, %359
  %361 = xor i64 %360, %290
  %362 = getelementptr inbounds nuw i8, ptr %4, i64 96
  %363 = load i64, ptr %362, align 8
  %364 = add i64 %363, 8268148722764581231
  %365 = add i64 %364, %264
  %366 = add i64 %365, %361
  %367 = add i64 %366, %358
  %368 = add i64 %367, %275
  %369 = tail call i64 @llvm.fshl.i64(i64 %353, i64 %353, i64 36)
  %370 = tail call i64 @llvm.fshl.i64(i64 %353, i64 %353, i64 30)
  %371 = xor i64 %369, %370
  %372 = tail call i64 @llvm.fshl.i64(i64 %353, i64 %353, i64 25)
  %373 = xor i64 %371, %372
  %374 = or i64 %327, %301
  %375 = and i64 %353, %374
  %376 = and i64 %327, %301
  %377 = or i64 %375, %376
  %378 = add i64 %373, %377
  %379 = add i64 %378, %367
  %380 = tail call i64 @llvm.fshl.i64(i64 %368, i64 %368, i64 50)
  %381 = tail call i64 @llvm.fshl.i64(i64 %368, i64 %368, i64 46)
  %382 = xor i64 %380, %381
  %383 = tail call i64 @llvm.fshl.i64(i64 %368, i64 %368, i64 23)
  %384 = xor i64 %382, %383
  %385 = xor i64 %342, %316
  %386 = and i64 %368, %385
  %387 = xor i64 %386, %316
  %388 = getelementptr inbounds nuw i8, ptr %4, i64 104
  %389 = load i64, ptr %388, align 8
  %390 = add i64 %389, -9160688886553864527
  %391 = add i64 %390, %290
  %392 = add i64 %391, %387
  %393 = add i64 %392, %384
  %394 = add i64 %393, %301
  %395 = tail call i64 @llvm.fshl.i64(i64 %379, i64 %379, i64 36)
  %396 = tail call i64 @llvm.fshl.i64(i64 %379, i64 %379, i64 30)
  %397 = xor i64 %395, %396
  %398 = tail call i64 @llvm.fshl.i64(i64 %379, i64 %379, i64 25)
  %399 = xor i64 %397, %398
  %400 = or i64 %353, %327
  %401 = and i64 %379, %400
  %402 = and i64 %353, %327
  %403 = or i64 %401, %402
  %404 = add i64 %399, %403
  %405 = add i64 %404, %393
  %406 = tail call i64 @llvm.fshl.i64(i64 %394, i64 %394, i64 50)
  %407 = tail call i64 @llvm.fshl.i64(i64 %394, i64 %394, i64 46)
  %408 = xor i64 %406, %407
  %409 = tail call i64 @llvm.fshl.i64(i64 %394, i64 %394, i64 23)
  %410 = xor i64 %408, %409
  %411 = xor i64 %368, %342
  %412 = and i64 %394, %411
  %413 = xor i64 %412, %342
  %414 = getelementptr inbounds nuw i8, ptr %4, i64 112
  %415 = load i64, ptr %414, align 8
  %416 = add i64 %415, -7215885187991268811
  %417 = add i64 %416, %316
  %418 = add i64 %417, %413
  %419 = add i64 %418, %410
  %420 = add i64 %419, %327
  %421 = tail call i64 @llvm.fshl.i64(i64 %405, i64 %405, i64 36)
  %422 = tail call i64 @llvm.fshl.i64(i64 %405, i64 %405, i64 30)
  %423 = xor i64 %421, %422
  %424 = tail call i64 @llvm.fshl.i64(i64 %405, i64 %405, i64 25)
  %425 = xor i64 %423, %424
  %426 = or i64 %379, %353
  %427 = and i64 %405, %426
  %428 = and i64 %379, %353
  %429 = or i64 %427, %428
  %430 = add i64 %425, %429
  %431 = add i64 %430, %419
  %432 = tail call i64 @llvm.fshl.i64(i64 %420, i64 %420, i64 50)
  %433 = tail call i64 @llvm.fshl.i64(i64 %420, i64 %420, i64 46)
  %434 = xor i64 %432, %433
  %435 = tail call i64 @llvm.fshl.i64(i64 %420, i64 %420, i64 23)
  %436 = xor i64 %434, %435
  %437 = xor i64 %394, %368
  %438 = and i64 %420, %437
  %439 = xor i64 %438, %368
  %440 = getelementptr inbounds nuw i8, ptr %4, i64 120
  %441 = load i64, ptr %440, align 8
  %442 = add i64 %441, -4495734319001033068
  %443 = add i64 %442, %342
  %444 = add i64 %443, %439
  %445 = add i64 %444, %436
  %446 = add i64 %445, %353
  %447 = tail call i64 @llvm.fshl.i64(i64 %431, i64 %431, i64 36)
  %448 = tail call i64 @llvm.fshl.i64(i64 %431, i64 %431, i64 30)
  %449 = xor i64 %447, %448
  %450 = tail call i64 @llvm.fshl.i64(i64 %431, i64 %431, i64 25)
  %451 = xor i64 %449, %450
  %452 = or i64 %405, %379
  %453 = and i64 %431, %452
  %454 = and i64 %405, %379
  %455 = or i64 %453, %454
  %456 = add i64 %451, %455
  %457 = add i64 %456, %445
  %458 = tail call i64 @llvm.fshl.i64(i64 %446, i64 %446, i64 50)
  %459 = tail call i64 @llvm.fshl.i64(i64 %446, i64 %446, i64 46)
  %460 = xor i64 %458, %459
  %461 = tail call i64 @llvm.fshl.i64(i64 %446, i64 %446, i64 23)
  %462 = xor i64 %460, %461
  %463 = xor i64 %420, %394
  %464 = and i64 %446, %463
  %465 = xor i64 %464, %394
  %466 = getelementptr inbounds nuw i8, ptr %4, i64 128
  %467 = load i64, ptr %466, align 8
  %468 = add i64 %467, -1973867731355612462
  %469 = add i64 %468, %368
  %470 = add i64 %469, %465
  %471 = add i64 %470, %462
  %472 = add i64 %471, %379
  %473 = tail call i64 @llvm.fshl.i64(i64 %457, i64 %457, i64 36)
  %474 = tail call i64 @llvm.fshl.i64(i64 %457, i64 %457, i64 30)
  %475 = xor i64 %473, %474
  %476 = tail call i64 @llvm.fshl.i64(i64 %457, i64 %457, i64 25)
  %477 = xor i64 %475, %476
  %478 = or i64 %431, %405
  %479 = and i64 %457, %478
  %480 = and i64 %431, %405
  %481 = or i64 %479, %480
  %482 = add i64 %477, %481
  %483 = add i64 %482, %471
  %484 = tail call i64 @llvm.fshl.i64(i64 %472, i64 %472, i64 50)
  %485 = tail call i64 @llvm.fshl.i64(i64 %472, i64 %472, i64 46)
  %486 = xor i64 %484, %485
  %487 = tail call i64 @llvm.fshl.i64(i64 %472, i64 %472, i64 23)
  %488 = xor i64 %486, %487
  %489 = xor i64 %446, %420
  %490 = and i64 %472, %489
  %491 = xor i64 %490, %420
  %492 = getelementptr inbounds nuw i8, ptr %4, i64 136
  %493 = load i64, ptr %492, align 8
  %494 = add i64 %493, -1171420211273849373
  %495 = add i64 %494, %394
  %496 = add i64 %495, %491
  %497 = add i64 %496, %488
  %498 = add i64 %497, %405
  %499 = tail call i64 @llvm.fshl.i64(i64 %483, i64 %483, i64 36)
  %500 = tail call i64 @llvm.fshl.i64(i64 %483, i64 %483, i64 30)
  %501 = xor i64 %499, %500
  %502 = tail call i64 @llvm.fshl.i64(i64 %483, i64 %483, i64 25)
  %503 = xor i64 %501, %502
  %504 = or i64 %457, %431
  %505 = and i64 %483, %504
  %506 = and i64 %457, %431
  %507 = or i64 %505, %506
  %508 = add i64 %503, %507
  %509 = add i64 %508, %497
  %510 = tail call i64 @llvm.fshl.i64(i64 %498, i64 %498, i64 50)
  %511 = tail call i64 @llvm.fshl.i64(i64 %498, i64 %498, i64 46)
  %512 = xor i64 %510, %511
  %513 = tail call i64 @llvm.fshl.i64(i64 %498, i64 %498, i64 23)
  %514 = xor i64 %512, %513
  %515 = xor i64 %472, %446
  %516 = and i64 %498, %515
  %517 = xor i64 %516, %446
  %518 = getelementptr inbounds nuw i8, ptr %4, i64 144
  %519 = load i64, ptr %518, align 8
  %520 = add i64 %519, 1135362057144423861
  %521 = add i64 %520, %420
  %522 = add i64 %521, %517
  %523 = add i64 %522, %514
  %524 = add i64 %523, %431
  %525 = tail call i64 @llvm.fshl.i64(i64 %509, i64 %509, i64 36)
  %526 = tail call i64 @llvm.fshl.i64(i64 %509, i64 %509, i64 30)
  %527 = xor i64 %525, %526
  %528 = tail call i64 @llvm.fshl.i64(i64 %509, i64 %509, i64 25)
  %529 = xor i64 %527, %528
  %530 = or i64 %483, %457
  %531 = and i64 %509, %530
  %532 = and i64 %483, %457
  %533 = or i64 %531, %532
  %534 = add i64 %529, %533
  %535 = add i64 %534, %523
  %536 = tail call i64 @llvm.fshl.i64(i64 %524, i64 %524, i64 50)
  %537 = tail call i64 @llvm.fshl.i64(i64 %524, i64 %524, i64 46)
  %538 = xor i64 %536, %537
  %539 = tail call i64 @llvm.fshl.i64(i64 %524, i64 %524, i64 23)
  %540 = xor i64 %538, %539
  %541 = xor i64 %498, %472
  %542 = and i64 %524, %541
  %543 = xor i64 %542, %472
  %544 = getelementptr inbounds nuw i8, ptr %4, i64 152
  %545 = load i64, ptr %544, align 8
  %546 = add i64 %545, 2597628984639134821
  %547 = add i64 %546, %446
  %548 = add i64 %547, %543
  %549 = add i64 %548, %540
  %550 = add i64 %549, %457
  %551 = tail call i64 @llvm.fshl.i64(i64 %535, i64 %535, i64 36)
  %552 = tail call i64 @llvm.fshl.i64(i64 %535, i64 %535, i64 30)
  %553 = xor i64 %551, %552
  %554 = tail call i64 @llvm.fshl.i64(i64 %535, i64 %535, i64 25)
  %555 = xor i64 %553, %554
  %556 = or i64 %509, %483
  %557 = and i64 %535, %556
  %558 = and i64 %509, %483
  %559 = or i64 %557, %558
  %560 = add i64 %555, %559
  %561 = add i64 %560, %549
  %562 = tail call i64 @llvm.fshl.i64(i64 %550, i64 %550, i64 50)
  %563 = tail call i64 @llvm.fshl.i64(i64 %550, i64 %550, i64 46)
  %564 = xor i64 %562, %563
  %565 = tail call i64 @llvm.fshl.i64(i64 %550, i64 %550, i64 23)
  %566 = xor i64 %564, %565
  %567 = xor i64 %524, %498
  %568 = and i64 %550, %567
  %569 = xor i64 %568, %498
  %570 = getelementptr inbounds nuw i8, ptr %4, i64 160
  %571 = load i64, ptr %570, align 8
  %572 = add i64 %571, 3308224258029322869
  %573 = add i64 %572, %472
  %574 = add i64 %573, %569
  %575 = add i64 %574, %566
  %576 = add i64 %575, %483
  %577 = tail call i64 @llvm.fshl.i64(i64 %561, i64 %561, i64 36)
  %578 = tail call i64 @llvm.fshl.i64(i64 %561, i64 %561, i64 30)
  %579 = xor i64 %577, %578
  %580 = tail call i64 @llvm.fshl.i64(i64 %561, i64 %561, i64 25)
  %581 = xor i64 %579, %580
  %582 = or i64 %535, %509
  %583 = and i64 %561, %582
  %584 = and i64 %535, %509
  %585 = or i64 %583, %584
  %586 = add i64 %581, %585
  %587 = add i64 %586, %575
  %588 = tail call i64 @llvm.fshl.i64(i64 %576, i64 %576, i64 50)
  %589 = tail call i64 @llvm.fshl.i64(i64 %576, i64 %576, i64 46)
  %590 = xor i64 %588, %589
  %591 = tail call i64 @llvm.fshl.i64(i64 %576, i64 %576, i64 23)
  %592 = xor i64 %590, %591
  %593 = xor i64 %550, %524
  %594 = and i64 %576, %593
  %595 = xor i64 %594, %524
  %596 = getelementptr inbounds nuw i8, ptr %4, i64 168
  %597 = load i64, ptr %596, align 8
  %598 = add i64 %597, 5365058923640841347
  %599 = add i64 %598, %498
  %600 = add i64 %599, %595
  %601 = add i64 %600, %592
  %602 = add i64 %601, %509
  %603 = tail call i64 @llvm.fshl.i64(i64 %587, i64 %587, i64 36)
  %604 = tail call i64 @llvm.fshl.i64(i64 %587, i64 %587, i64 30)
  %605 = xor i64 %603, %604
  %606 = tail call i64 @llvm.fshl.i64(i64 %587, i64 %587, i64 25)
  %607 = xor i64 %605, %606
  %608 = or i64 %561, %535
  %609 = and i64 %587, %608
  %610 = and i64 %561, %535
  %611 = or i64 %609, %610
  %612 = add i64 %607, %611
  %613 = add i64 %612, %601
  %614 = tail call i64 @llvm.fshl.i64(i64 %602, i64 %602, i64 50)
  %615 = tail call i64 @llvm.fshl.i64(i64 %602, i64 %602, i64 46)
  %616 = xor i64 %614, %615
  %617 = tail call i64 @llvm.fshl.i64(i64 %602, i64 %602, i64 23)
  %618 = xor i64 %616, %617
  %619 = xor i64 %576, %550
  %620 = and i64 %602, %619
  %621 = xor i64 %620, %550
  %622 = getelementptr inbounds nuw i8, ptr %4, i64 176
  %623 = load i64, ptr %622, align 8
  %624 = add i64 %623, 6679025012923562964
  %625 = add i64 %624, %524
  %626 = add i64 %625, %621
  %627 = add i64 %626, %618
  %628 = add i64 %627, %535
  %629 = tail call i64 @llvm.fshl.i64(i64 %613, i64 %613, i64 36)
  %630 = tail call i64 @llvm.fshl.i64(i64 %613, i64 %613, i64 30)
  %631 = xor i64 %629, %630
  %632 = tail call i64 @llvm.fshl.i64(i64 %613, i64 %613, i64 25)
  %633 = xor i64 %631, %632
  %634 = or i64 %587, %561
  %635 = and i64 %613, %634
  %636 = and i64 %587, %561
  %637 = or i64 %635, %636
  %638 = add i64 %633, %637
  %639 = add i64 %638, %627
  %640 = tail call i64 @llvm.fshl.i64(i64 %628, i64 %628, i64 50)
  %641 = tail call i64 @llvm.fshl.i64(i64 %628, i64 %628, i64 46)
  %642 = xor i64 %640, %641
  %643 = tail call i64 @llvm.fshl.i64(i64 %628, i64 %628, i64 23)
  %644 = xor i64 %642, %643
  %645 = xor i64 %602, %576
  %646 = and i64 %628, %645
  %647 = xor i64 %646, %576
  %648 = getelementptr inbounds nuw i8, ptr %4, i64 184
  %649 = load i64, ptr %648, align 8
  %650 = add i64 %649, 8573033837759648693
  %651 = add i64 %650, %550
  %652 = add i64 %651, %647
  %653 = add i64 %652, %644
  %654 = add i64 %653, %561
  %655 = tail call i64 @llvm.fshl.i64(i64 %639, i64 %639, i64 36)
  %656 = tail call i64 @llvm.fshl.i64(i64 %639, i64 %639, i64 30)
  %657 = xor i64 %655, %656
  %658 = tail call i64 @llvm.fshl.i64(i64 %639, i64 %639, i64 25)
  %659 = xor i64 %657, %658
  %660 = or i64 %613, %587
  %661 = and i64 %639, %660
  %662 = and i64 %613, %587
  %663 = or i64 %661, %662
  %664 = add i64 %659, %663
  %665 = add i64 %664, %653
  %666 = tail call i64 @llvm.fshl.i64(i64 %654, i64 %654, i64 50)
  %667 = tail call i64 @llvm.fshl.i64(i64 %654, i64 %654, i64 46)
  %668 = xor i64 %666, %667
  %669 = tail call i64 @llvm.fshl.i64(i64 %654, i64 %654, i64 23)
  %670 = xor i64 %668, %669
  %671 = xor i64 %628, %602
  %672 = and i64 %654, %671
  %673 = xor i64 %672, %602
  %674 = getelementptr inbounds nuw i8, ptr %4, i64 192
  %675 = load i64, ptr %674, align 8
  %676 = add i64 %675, -7476448914759557205
  %677 = add i64 %676, %576
  %678 = add i64 %677, %673
  %679 = add i64 %678, %670
  %680 = add i64 %679, %587
  %681 = tail call i64 @llvm.fshl.i64(i64 %665, i64 %665, i64 36)
  %682 = tail call i64 @llvm.fshl.i64(i64 %665, i64 %665, i64 30)
  %683 = xor i64 %681, %682
  %684 = tail call i64 @llvm.fshl.i64(i64 %665, i64 %665, i64 25)
  %685 = xor i64 %683, %684
  %686 = or i64 %639, %613
  %687 = and i64 %665, %686
  %688 = and i64 %639, %613
  %689 = or i64 %687, %688
  %690 = add i64 %685, %689
  %691 = add i64 %690, %679
  %692 = tail call i64 @llvm.fshl.i64(i64 %680, i64 %680, i64 50)
  %693 = tail call i64 @llvm.fshl.i64(i64 %680, i64 %680, i64 46)
  %694 = xor i64 %692, %693
  %695 = tail call i64 @llvm.fshl.i64(i64 %680, i64 %680, i64 23)
  %696 = xor i64 %694, %695
  %697 = xor i64 %654, %628
  %698 = and i64 %680, %697
  %699 = xor i64 %698, %628
  %700 = getelementptr inbounds nuw i8, ptr %4, i64 200
  %701 = load i64, ptr %700, align 8
  %702 = add i64 %701, -6327057829258317296
  %703 = add i64 %702, %602
  %704 = add i64 %703, %699
  %705 = add i64 %704, %696
  %706 = add i64 %705, %613
  %707 = tail call i64 @llvm.fshl.i64(i64 %691, i64 %691, i64 36)
  %708 = tail call i64 @llvm.fshl.i64(i64 %691, i64 %691, i64 30)
  %709 = xor i64 %707, %708
  %710 = tail call i64 @llvm.fshl.i64(i64 %691, i64 %691, i64 25)
  %711 = xor i64 %709, %710
  %712 = or i64 %665, %639
  %713 = and i64 %691, %712
  %714 = and i64 %665, %639
  %715 = or i64 %713, %714
  %716 = add i64 %711, %715
  %717 = add i64 %716, %705
  %718 = tail call i64 @llvm.fshl.i64(i64 %706, i64 %706, i64 50)
  %719 = tail call i64 @llvm.fshl.i64(i64 %706, i64 %706, i64 46)
  %720 = xor i64 %718, %719
  %721 = tail call i64 @llvm.fshl.i64(i64 %706, i64 %706, i64 23)
  %722 = xor i64 %720, %721
  %723 = xor i64 %680, %654
  %724 = and i64 %706, %723
  %725 = xor i64 %724, %654
  %726 = getelementptr inbounds nuw i8, ptr %4, i64 208
  %727 = load i64, ptr %726, align 8
  %728 = add i64 %727, -5763719355590565569
  %729 = add i64 %728, %628
  %730 = add i64 %729, %725
  %731 = add i64 %730, %722
  %732 = add i64 %731, %639
  %733 = tail call i64 @llvm.fshl.i64(i64 %717, i64 %717, i64 36)
  %734 = tail call i64 @llvm.fshl.i64(i64 %717, i64 %717, i64 30)
  %735 = xor i64 %733, %734
  %736 = tail call i64 @llvm.fshl.i64(i64 %717, i64 %717, i64 25)
  %737 = xor i64 %735, %736
  %738 = or i64 %691, %665
  %739 = and i64 %717, %738
  %740 = and i64 %691, %665
  %741 = or i64 %739, %740
  %742 = add i64 %737, %741
  %743 = add i64 %742, %731
  %744 = tail call i64 @llvm.fshl.i64(i64 %732, i64 %732, i64 50)
  %745 = tail call i64 @llvm.fshl.i64(i64 %732, i64 %732, i64 46)
  %746 = xor i64 %744, %745
  %747 = tail call i64 @llvm.fshl.i64(i64 %732, i64 %732, i64 23)
  %748 = xor i64 %746, %747
  %749 = xor i64 %706, %680
  %750 = and i64 %732, %749
  %751 = xor i64 %750, %680
  %752 = getelementptr inbounds nuw i8, ptr %4, i64 216
  %753 = load i64, ptr %752, align 8
  %754 = add i64 %753, -4658551843659510044
  %755 = add i64 %754, %654
  %756 = add i64 %755, %751
  %757 = add i64 %756, %748
  %758 = add i64 %757, %665
  %759 = tail call i64 @llvm.fshl.i64(i64 %743, i64 %743, i64 36)
  %760 = tail call i64 @llvm.fshl.i64(i64 %743, i64 %743, i64 30)
  %761 = xor i64 %759, %760
  %762 = tail call i64 @llvm.fshl.i64(i64 %743, i64 %743, i64 25)
  %763 = xor i64 %761, %762
  %764 = or i64 %717, %691
  %765 = and i64 %743, %764
  %766 = and i64 %717, %691
  %767 = or i64 %765, %766
  %768 = add i64 %763, %767
  %769 = add i64 %768, %757
  %770 = tail call i64 @llvm.fshl.i64(i64 %758, i64 %758, i64 50)
  %771 = tail call i64 @llvm.fshl.i64(i64 %758, i64 %758, i64 46)
  %772 = xor i64 %770, %771
  %773 = tail call i64 @llvm.fshl.i64(i64 %758, i64 %758, i64 23)
  %774 = xor i64 %772, %773
  %775 = xor i64 %732, %706
  %776 = and i64 %758, %775
  %777 = xor i64 %776, %706
  %778 = getelementptr inbounds nuw i8, ptr %4, i64 224
  %779 = load i64, ptr %778, align 8
  %780 = add i64 %779, -4116276920077217854
  %781 = add i64 %780, %680
  %782 = add i64 %781, %777
  %783 = add i64 %782, %774
  %784 = add i64 %783, %691
  %785 = tail call i64 @llvm.fshl.i64(i64 %769, i64 %769, i64 36)
  %786 = tail call i64 @llvm.fshl.i64(i64 %769, i64 %769, i64 30)
  %787 = xor i64 %785, %786
  %788 = tail call i64 @llvm.fshl.i64(i64 %769, i64 %769, i64 25)
  %789 = xor i64 %787, %788
  %790 = or i64 %743, %717
  %791 = and i64 %769, %790
  %792 = and i64 %743, %717
  %793 = or i64 %791, %792
  %794 = add i64 %789, %793
  %795 = add i64 %794, %783
  %796 = tail call i64 @llvm.fshl.i64(i64 %784, i64 %784, i64 50)
  %797 = tail call i64 @llvm.fshl.i64(i64 %784, i64 %784, i64 46)
  %798 = xor i64 %796, %797
  %799 = tail call i64 @llvm.fshl.i64(i64 %784, i64 %784, i64 23)
  %800 = xor i64 %798, %799
  %801 = xor i64 %758, %732
  %802 = and i64 %784, %801
  %803 = xor i64 %802, %732
  %804 = getelementptr inbounds nuw i8, ptr %4, i64 232
  %805 = load i64, ptr %804, align 8
  %806 = add i64 %805, -3051310485924567259
  %807 = add i64 %806, %706
  %808 = add i64 %807, %803
  %809 = add i64 %808, %800
  %810 = add i64 %809, %717
  %811 = tail call i64 @llvm.fshl.i64(i64 %795, i64 %795, i64 36)
  %812 = tail call i64 @llvm.fshl.i64(i64 %795, i64 %795, i64 30)
  %813 = xor i64 %811, %812
  %814 = tail call i64 @llvm.fshl.i64(i64 %795, i64 %795, i64 25)
  %815 = xor i64 %813, %814
  %816 = or i64 %769, %743
  %817 = and i64 %795, %816
  %818 = and i64 %769, %743
  %819 = or i64 %817, %818
  %820 = add i64 %815, %819
  %821 = add i64 %820, %809
  %822 = tail call i64 @llvm.fshl.i64(i64 %810, i64 %810, i64 50)
  %823 = tail call i64 @llvm.fshl.i64(i64 %810, i64 %810, i64 46)
  %824 = xor i64 %822, %823
  %825 = tail call i64 @llvm.fshl.i64(i64 %810, i64 %810, i64 23)
  %826 = xor i64 %824, %825
  %827 = xor i64 %784, %758
  %828 = and i64 %810, %827
  %829 = xor i64 %828, %758
  %830 = getelementptr inbounds nuw i8, ptr %4, i64 240
  %831 = load i64, ptr %830, align 8
  %832 = add i64 %831, 489312712824947311
  %833 = add i64 %832, %732
  %834 = add i64 %833, %829
  %835 = add i64 %834, %826
  %836 = add i64 %835, %743
  %837 = tail call i64 @llvm.fshl.i64(i64 %821, i64 %821, i64 36)
  %838 = tail call i64 @llvm.fshl.i64(i64 %821, i64 %821, i64 30)
  %839 = xor i64 %837, %838
  %840 = tail call i64 @llvm.fshl.i64(i64 %821, i64 %821, i64 25)
  %841 = xor i64 %839, %840
  %842 = or i64 %795, %769
  %843 = and i64 %821, %842
  %844 = and i64 %795, %769
  %845 = or i64 %843, %844
  %846 = add i64 %841, %845
  %847 = add i64 %846, %835
  %848 = tail call i64 @llvm.fshl.i64(i64 %836, i64 %836, i64 50)
  %849 = tail call i64 @llvm.fshl.i64(i64 %836, i64 %836, i64 46)
  %850 = xor i64 %848, %849
  %851 = tail call i64 @llvm.fshl.i64(i64 %836, i64 %836, i64 23)
  %852 = xor i64 %850, %851
  %853 = xor i64 %810, %784
  %854 = and i64 %836, %853
  %855 = xor i64 %854, %784
  %856 = getelementptr inbounds nuw i8, ptr %4, i64 248
  %857 = load i64, ptr %856, align 8
  %858 = add i64 %857, 1452737877330783856
  %859 = add i64 %858, %758
  %860 = add i64 %859, %855
  %861 = add i64 %860, %852
  %862 = add i64 %861, %769
  %863 = tail call i64 @llvm.fshl.i64(i64 %847, i64 %847, i64 36)
  %864 = tail call i64 @llvm.fshl.i64(i64 %847, i64 %847, i64 30)
  %865 = xor i64 %863, %864
  %866 = tail call i64 @llvm.fshl.i64(i64 %847, i64 %847, i64 25)
  %867 = xor i64 %865, %866
  %868 = or i64 %821, %795
  %869 = and i64 %847, %868
  %870 = and i64 %821, %795
  %871 = or i64 %869, %870
  %872 = add i64 %867, %871
  %873 = add i64 %872, %861
  %874 = tail call i64 @llvm.fshl.i64(i64 %862, i64 %862, i64 50)
  %875 = tail call i64 @llvm.fshl.i64(i64 %862, i64 %862, i64 46)
  %876 = xor i64 %874, %875
  %877 = tail call i64 @llvm.fshl.i64(i64 %862, i64 %862, i64 23)
  %878 = xor i64 %876, %877
  %879 = xor i64 %836, %810
  %880 = and i64 %862, %879
  %881 = xor i64 %880, %810
  %882 = getelementptr inbounds nuw i8, ptr %4, i64 256
  %883 = load i64, ptr %882, align 8
  %884 = add i64 %883, 2861767655752347644
  %885 = add i64 %884, %784
  %886 = add i64 %885, %881
  %887 = add i64 %886, %878
  %888 = add i64 %887, %795
  %889 = tail call i64 @llvm.fshl.i64(i64 %873, i64 %873, i64 36)
  %890 = tail call i64 @llvm.fshl.i64(i64 %873, i64 %873, i64 30)
  %891 = xor i64 %889, %890
  %892 = tail call i64 @llvm.fshl.i64(i64 %873, i64 %873, i64 25)
  %893 = xor i64 %891, %892
  %894 = or i64 %847, %821
  %895 = and i64 %873, %894
  %896 = and i64 %847, %821
  %897 = or i64 %895, %896
  %898 = add i64 %893, %897
  %899 = add i64 %898, %887
  %900 = tail call i64 @llvm.fshl.i64(i64 %888, i64 %888, i64 50)
  %901 = tail call i64 @llvm.fshl.i64(i64 %888, i64 %888, i64 46)
  %902 = xor i64 %900, %901
  %903 = tail call i64 @llvm.fshl.i64(i64 %888, i64 %888, i64 23)
  %904 = xor i64 %902, %903
  %905 = xor i64 %862, %836
  %906 = and i64 %888, %905
  %907 = xor i64 %906, %836
  %908 = getelementptr inbounds nuw i8, ptr %4, i64 264
  %909 = load i64, ptr %908, align 8
  %910 = add i64 %909, 3322285676063803686
  %911 = add i64 %910, %810
  %912 = add i64 %911, %907
  %913 = add i64 %912, %904
  %914 = add i64 %913, %821
  %915 = tail call i64 @llvm.fshl.i64(i64 %899, i64 %899, i64 36)
  %916 = tail call i64 @llvm.fshl.i64(i64 %899, i64 %899, i64 30)
  %917 = xor i64 %915, %916
  %918 = tail call i64 @llvm.fshl.i64(i64 %899, i64 %899, i64 25)
  %919 = xor i64 %917, %918
  %920 = or i64 %873, %847
  %921 = and i64 %899, %920
  %922 = and i64 %873, %847
  %923 = or i64 %921, %922
  %924 = add i64 %919, %923
  %925 = add i64 %924, %913
  %926 = tail call i64 @llvm.fshl.i64(i64 %914, i64 %914, i64 50)
  %927 = tail call i64 @llvm.fshl.i64(i64 %914, i64 %914, i64 46)
  %928 = xor i64 %926, %927
  %929 = tail call i64 @llvm.fshl.i64(i64 %914, i64 %914, i64 23)
  %930 = xor i64 %928, %929
  %931 = xor i64 %888, %862
  %932 = and i64 %914, %931
  %933 = xor i64 %932, %862
  %934 = getelementptr inbounds nuw i8, ptr %4, i64 272
  %935 = load i64, ptr %934, align 8
  %936 = add i64 %935, 5560940570517711597
  %937 = add i64 %936, %836
  %938 = add i64 %937, %933
  %939 = add i64 %938, %930
  %940 = add i64 %939, %847
  %941 = tail call i64 @llvm.fshl.i64(i64 %925, i64 %925, i64 36)
  %942 = tail call i64 @llvm.fshl.i64(i64 %925, i64 %925, i64 30)
  %943 = xor i64 %941, %942
  %944 = tail call i64 @llvm.fshl.i64(i64 %925, i64 %925, i64 25)
  %945 = xor i64 %943, %944
  %946 = or i64 %899, %873
  %947 = and i64 %925, %946
  %948 = and i64 %899, %873
  %949 = or i64 %947, %948
  %950 = add i64 %945, %949
  %951 = add i64 %950, %939
  %952 = tail call i64 @llvm.fshl.i64(i64 %940, i64 %940, i64 50)
  %953 = tail call i64 @llvm.fshl.i64(i64 %940, i64 %940, i64 46)
  %954 = xor i64 %952, %953
  %955 = tail call i64 @llvm.fshl.i64(i64 %940, i64 %940, i64 23)
  %956 = xor i64 %954, %955
  %957 = xor i64 %914, %888
  %958 = and i64 %940, %957
  %959 = xor i64 %958, %888
  %960 = getelementptr inbounds nuw i8, ptr %4, i64 280
  %961 = load i64, ptr %960, align 8
  %962 = add i64 %961, 5996557281743188959
  %963 = add i64 %962, %862
  %964 = add i64 %963, %959
  %965 = add i64 %964, %956
  %966 = add i64 %965, %873
  %967 = tail call i64 @llvm.fshl.i64(i64 %951, i64 %951, i64 36)
  %968 = tail call i64 @llvm.fshl.i64(i64 %951, i64 %951, i64 30)
  %969 = xor i64 %967, %968
  %970 = tail call i64 @llvm.fshl.i64(i64 %951, i64 %951, i64 25)
  %971 = xor i64 %969, %970
  %972 = or i64 %925, %899
  %973 = and i64 %951, %972
  %974 = and i64 %925, %899
  %975 = or i64 %973, %974
  %976 = add i64 %971, %975
  %977 = add i64 %976, %965
  %978 = tail call i64 @llvm.fshl.i64(i64 %966, i64 %966, i64 50)
  %979 = tail call i64 @llvm.fshl.i64(i64 %966, i64 %966, i64 46)
  %980 = xor i64 %978, %979
  %981 = tail call i64 @llvm.fshl.i64(i64 %966, i64 %966, i64 23)
  %982 = xor i64 %980, %981
  %983 = xor i64 %940, %914
  %984 = and i64 %966, %983
  %985 = xor i64 %984, %914
  %986 = getelementptr inbounds nuw i8, ptr %4, i64 288
  %987 = load i64, ptr %986, align 8
  %988 = add i64 %987, 7280758554555802590
  %989 = add i64 %988, %888
  %990 = add i64 %989, %985
  %991 = add i64 %990, %982
  %992 = add i64 %991, %899
  %993 = tail call i64 @llvm.fshl.i64(i64 %977, i64 %977, i64 36)
  %994 = tail call i64 @llvm.fshl.i64(i64 %977, i64 %977, i64 30)
  %995 = xor i64 %993, %994
  %996 = tail call i64 @llvm.fshl.i64(i64 %977, i64 %977, i64 25)
  %997 = xor i64 %995, %996
  %998 = or i64 %951, %925
  %999 = and i64 %977, %998
  %1000 = and i64 %951, %925
  %1001 = or i64 %999, %1000
  %1002 = add i64 %997, %1001
  %1003 = add i64 %1002, %991
  %1004 = tail call i64 @llvm.fshl.i64(i64 %992, i64 %992, i64 50)
  %1005 = tail call i64 @llvm.fshl.i64(i64 %992, i64 %992, i64 46)
  %1006 = xor i64 %1004, %1005
  %1007 = tail call i64 @llvm.fshl.i64(i64 %992, i64 %992, i64 23)
  %1008 = xor i64 %1006, %1007
  %1009 = xor i64 %966, %940
  %1010 = and i64 %992, %1009
  %1011 = xor i64 %1010, %940
  %1012 = getelementptr inbounds nuw i8, ptr %4, i64 296
  %1013 = load i64, ptr %1012, align 8
  %1014 = add i64 %1013, 8532644243296465576
  %1015 = add i64 %1014, %914
  %1016 = add i64 %1015, %1011
  %1017 = add i64 %1016, %1008
  %1018 = add i64 %1017, %925
  %1019 = tail call i64 @llvm.fshl.i64(i64 %1003, i64 %1003, i64 36)
  %1020 = tail call i64 @llvm.fshl.i64(i64 %1003, i64 %1003, i64 30)
  %1021 = xor i64 %1019, %1020
  %1022 = tail call i64 @llvm.fshl.i64(i64 %1003, i64 %1003, i64 25)
  %1023 = xor i64 %1021, %1022
  %1024 = or i64 %977, %951
  %1025 = and i64 %1003, %1024
  %1026 = and i64 %977, %951
  %1027 = or i64 %1025, %1026
  %1028 = add i64 %1023, %1027
  %1029 = add i64 %1028, %1017
  %1030 = tail call i64 @llvm.fshl.i64(i64 %1018, i64 %1018, i64 50)
  %1031 = tail call i64 @llvm.fshl.i64(i64 %1018, i64 %1018, i64 46)
  %1032 = xor i64 %1030, %1031
  %1033 = tail call i64 @llvm.fshl.i64(i64 %1018, i64 %1018, i64 23)
  %1034 = xor i64 %1032, %1033
  %1035 = xor i64 %992, %966
  %1036 = and i64 %1018, %1035
  %1037 = xor i64 %1036, %966
  %1038 = getelementptr inbounds nuw i8, ptr %4, i64 304
  %1039 = load i64, ptr %1038, align 8
  %1040 = add i64 %1039, -9096487096722542874
  %1041 = add i64 %1040, %940
  %1042 = add i64 %1041, %1037
  %1043 = add i64 %1042, %1034
  %1044 = add i64 %1043, %951
  %1045 = tail call i64 @llvm.fshl.i64(i64 %1029, i64 %1029, i64 36)
  %1046 = tail call i64 @llvm.fshl.i64(i64 %1029, i64 %1029, i64 30)
  %1047 = xor i64 %1045, %1046
  %1048 = tail call i64 @llvm.fshl.i64(i64 %1029, i64 %1029, i64 25)
  %1049 = xor i64 %1047, %1048
  %1050 = or i64 %1003, %977
  %1051 = and i64 %1029, %1050
  %1052 = and i64 %1003, %977
  %1053 = or i64 %1051, %1052
  %1054 = add i64 %1049, %1053
  %1055 = add i64 %1054, %1043
  %1056 = tail call i64 @llvm.fshl.i64(i64 %1044, i64 %1044, i64 50)
  %1057 = tail call i64 @llvm.fshl.i64(i64 %1044, i64 %1044, i64 46)
  %1058 = xor i64 %1056, %1057
  %1059 = tail call i64 @llvm.fshl.i64(i64 %1044, i64 %1044, i64 23)
  %1060 = xor i64 %1058, %1059
  %1061 = xor i64 %1018, %992
  %1062 = and i64 %1044, %1061
  %1063 = xor i64 %1062, %992
  %1064 = getelementptr inbounds nuw i8, ptr %4, i64 312
  %1065 = load i64, ptr %1064, align 8
  %1066 = add i64 %1065, -7894198246740708037
  %1067 = add i64 %1066, %966
  %1068 = add i64 %1067, %1063
  %1069 = add i64 %1068, %1060
  %1070 = add i64 %1069, %977
  %1071 = tail call i64 @llvm.fshl.i64(i64 %1055, i64 %1055, i64 36)
  %1072 = tail call i64 @llvm.fshl.i64(i64 %1055, i64 %1055, i64 30)
  %1073 = xor i64 %1071, %1072
  %1074 = tail call i64 @llvm.fshl.i64(i64 %1055, i64 %1055, i64 25)
  %1075 = xor i64 %1073, %1074
  %1076 = or i64 %1029, %1003
  %1077 = and i64 %1055, %1076
  %1078 = and i64 %1029, %1003
  %1079 = or i64 %1077, %1078
  %1080 = add i64 %1075, %1079
  %1081 = add i64 %1080, %1069
  %1082 = tail call i64 @llvm.fshl.i64(i64 %1070, i64 %1070, i64 50)
  %1083 = tail call i64 @llvm.fshl.i64(i64 %1070, i64 %1070, i64 46)
  %1084 = xor i64 %1082, %1083
  %1085 = tail call i64 @llvm.fshl.i64(i64 %1070, i64 %1070, i64 23)
  %1086 = xor i64 %1084, %1085
  %1087 = xor i64 %1044, %1018
  %1088 = and i64 %1070, %1087
  %1089 = xor i64 %1088, %1018
  %1090 = getelementptr inbounds nuw i8, ptr %4, i64 320
  %1091 = load i64, ptr %1090, align 8
  %1092 = add i64 %1091, -6719396339535248540
  %1093 = add i64 %1092, %992
  %1094 = add i64 %1093, %1089
  %1095 = add i64 %1094, %1086
  %1096 = add i64 %1095, %1003
  %1097 = tail call i64 @llvm.fshl.i64(i64 %1081, i64 %1081, i64 36)
  %1098 = tail call i64 @llvm.fshl.i64(i64 %1081, i64 %1081, i64 30)
  %1099 = xor i64 %1097, %1098
  %1100 = tail call i64 @llvm.fshl.i64(i64 %1081, i64 %1081, i64 25)
  %1101 = xor i64 %1099, %1100
  %1102 = or i64 %1055, %1029
  %1103 = and i64 %1081, %1102
  %1104 = and i64 %1055, %1029
  %1105 = or i64 %1103, %1104
  %1106 = add i64 %1101, %1105
  %1107 = add i64 %1106, %1095
  %1108 = tail call i64 @llvm.fshl.i64(i64 %1096, i64 %1096, i64 50)
  %1109 = tail call i64 @llvm.fshl.i64(i64 %1096, i64 %1096, i64 46)
  %1110 = xor i64 %1108, %1109
  %1111 = tail call i64 @llvm.fshl.i64(i64 %1096, i64 %1096, i64 23)
  %1112 = xor i64 %1110, %1111
  %1113 = xor i64 %1070, %1044
  %1114 = and i64 %1096, %1113
  %1115 = xor i64 %1114, %1044
  %1116 = getelementptr inbounds nuw i8, ptr %4, i64 328
  %1117 = load i64, ptr %1116, align 8
  %1118 = add i64 %1117, -6333637450476146687
  %1119 = add i64 %1118, %1018
  %1120 = add i64 %1119, %1115
  %1121 = add i64 %1120, %1112
  %1122 = add i64 %1121, %1029
  %1123 = tail call i64 @llvm.fshl.i64(i64 %1107, i64 %1107, i64 36)
  %1124 = tail call i64 @llvm.fshl.i64(i64 %1107, i64 %1107, i64 30)
  %1125 = xor i64 %1123, %1124
  %1126 = tail call i64 @llvm.fshl.i64(i64 %1107, i64 %1107, i64 25)
  %1127 = xor i64 %1125, %1126
  %1128 = or i64 %1081, %1055
  %1129 = and i64 %1107, %1128
  %1130 = and i64 %1081, %1055
  %1131 = or i64 %1129, %1130
  %1132 = add i64 %1127, %1131
  %1133 = add i64 %1132, %1121
  %1134 = tail call i64 @llvm.fshl.i64(i64 %1122, i64 %1122, i64 50)
  %1135 = tail call i64 @llvm.fshl.i64(i64 %1122, i64 %1122, i64 46)
  %1136 = xor i64 %1134, %1135
  %1137 = tail call i64 @llvm.fshl.i64(i64 %1122, i64 %1122, i64 23)
  %1138 = xor i64 %1136, %1137
  %1139 = xor i64 %1096, %1070
  %1140 = and i64 %1122, %1139
  %1141 = xor i64 %1140, %1070
  %1142 = getelementptr inbounds nuw i8, ptr %4, i64 336
  %1143 = load i64, ptr %1142, align 8
  %1144 = add i64 %1143, -4446306890439682159
  %1145 = add i64 %1144, %1044
  %1146 = add i64 %1145, %1141
  %1147 = add i64 %1146, %1138
  %1148 = add i64 %1147, %1055
  %1149 = tail call i64 @llvm.fshl.i64(i64 %1133, i64 %1133, i64 36)
  %1150 = tail call i64 @llvm.fshl.i64(i64 %1133, i64 %1133, i64 30)
  %1151 = xor i64 %1149, %1150
  %1152 = tail call i64 @llvm.fshl.i64(i64 %1133, i64 %1133, i64 25)
  %1153 = xor i64 %1151, %1152
  %1154 = or i64 %1107, %1081
  %1155 = and i64 %1133, %1154
  %1156 = and i64 %1107, %1081
  %1157 = or i64 %1155, %1156
  %1158 = add i64 %1153, %1157
  %1159 = add i64 %1158, %1147
  %1160 = tail call i64 @llvm.fshl.i64(i64 %1148, i64 %1148, i64 50)
  %1161 = tail call i64 @llvm.fshl.i64(i64 %1148, i64 %1148, i64 46)
  %1162 = xor i64 %1160, %1161
  %1163 = tail call i64 @llvm.fshl.i64(i64 %1148, i64 %1148, i64 23)
  %1164 = xor i64 %1162, %1163
  %1165 = xor i64 %1122, %1096
  %1166 = and i64 %1148, %1165
  %1167 = xor i64 %1166, %1096
  %1168 = getelementptr inbounds nuw i8, ptr %4, i64 344
  %1169 = load i64, ptr %1168, align 8
  %1170 = add i64 %1169, -4076793802049405392
  %1171 = add i64 %1170, %1070
  %1172 = add i64 %1171, %1167
  %1173 = add i64 %1172, %1164
  %1174 = add i64 %1173, %1081
  %1175 = tail call i64 @llvm.fshl.i64(i64 %1159, i64 %1159, i64 36)
  %1176 = tail call i64 @llvm.fshl.i64(i64 %1159, i64 %1159, i64 30)
  %1177 = xor i64 %1175, %1176
  %1178 = tail call i64 @llvm.fshl.i64(i64 %1159, i64 %1159, i64 25)
  %1179 = xor i64 %1177, %1178
  %1180 = or i64 %1133, %1107
  %1181 = and i64 %1159, %1180
  %1182 = and i64 %1133, %1107
  %1183 = or i64 %1181, %1182
  %1184 = add i64 %1179, %1183
  %1185 = add i64 %1184, %1173
  %1186 = tail call i64 @llvm.fshl.i64(i64 %1174, i64 %1174, i64 50)
  %1187 = tail call i64 @llvm.fshl.i64(i64 %1174, i64 %1174, i64 46)
  %1188 = xor i64 %1186, %1187
  %1189 = tail call i64 @llvm.fshl.i64(i64 %1174, i64 %1174, i64 23)
  %1190 = xor i64 %1188, %1189
  %1191 = xor i64 %1148, %1122
  %1192 = and i64 %1174, %1191
  %1193 = xor i64 %1192, %1122
  %1194 = getelementptr inbounds nuw i8, ptr %4, i64 352
  %1195 = load i64, ptr %1194, align 8
  %1196 = add i64 %1195, -3345356375505022440
  %1197 = add i64 %1196, %1096
  %1198 = add i64 %1197, %1193
  %1199 = add i64 %1198, %1190
  %1200 = add i64 %1199, %1107
  %1201 = tail call i64 @llvm.fshl.i64(i64 %1185, i64 %1185, i64 36)
  %1202 = tail call i64 @llvm.fshl.i64(i64 %1185, i64 %1185, i64 30)
  %1203 = xor i64 %1201, %1202
  %1204 = tail call i64 @llvm.fshl.i64(i64 %1185, i64 %1185, i64 25)
  %1205 = xor i64 %1203, %1204
  %1206 = or i64 %1159, %1133
  %1207 = and i64 %1185, %1206
  %1208 = and i64 %1159, %1133
  %1209 = or i64 %1207, %1208
  %1210 = add i64 %1205, %1209
  %1211 = add i64 %1210, %1199
  %1212 = tail call i64 @llvm.fshl.i64(i64 %1200, i64 %1200, i64 50)
  %1213 = tail call i64 @llvm.fshl.i64(i64 %1200, i64 %1200, i64 46)
  %1214 = xor i64 %1212, %1213
  %1215 = tail call i64 @llvm.fshl.i64(i64 %1200, i64 %1200, i64 23)
  %1216 = xor i64 %1214, %1215
  %1217 = xor i64 %1174, %1148
  %1218 = and i64 %1200, %1217
  %1219 = xor i64 %1218, %1148
  %1220 = getelementptr inbounds nuw i8, ptr %4, i64 360
  %1221 = load i64, ptr %1220, align 8
  %1222 = add i64 %1221, -2983346525034927856
  %1223 = add i64 %1222, %1122
  %1224 = add i64 %1223, %1219
  %1225 = add i64 %1224, %1216
  %1226 = add i64 %1225, %1133
  %1227 = tail call i64 @llvm.fshl.i64(i64 %1211, i64 %1211, i64 36)
  %1228 = tail call i64 @llvm.fshl.i64(i64 %1211, i64 %1211, i64 30)
  %1229 = xor i64 %1227, %1228
  %1230 = tail call i64 @llvm.fshl.i64(i64 %1211, i64 %1211, i64 25)
  %1231 = xor i64 %1229, %1230
  %1232 = or i64 %1185, %1159
  %1233 = and i64 %1211, %1232
  %1234 = and i64 %1185, %1159
  %1235 = or i64 %1233, %1234
  %1236 = add i64 %1231, %1235
  %1237 = add i64 %1236, %1225
  %1238 = tail call i64 @llvm.fshl.i64(i64 %1226, i64 %1226, i64 50)
  %1239 = tail call i64 @llvm.fshl.i64(i64 %1226, i64 %1226, i64 46)
  %1240 = xor i64 %1238, %1239
  %1241 = tail call i64 @llvm.fshl.i64(i64 %1226, i64 %1226, i64 23)
  %1242 = xor i64 %1240, %1241
  %1243 = xor i64 %1200, %1174
  %1244 = and i64 %1226, %1243
  %1245 = xor i64 %1244, %1174
  %1246 = getelementptr inbounds nuw i8, ptr %4, i64 368
  %1247 = load i64, ptr %1246, align 8
  %1248 = add i64 %1247, -860691631967231958
  %1249 = add i64 %1248, %1148
  %1250 = add i64 %1249, %1245
  %1251 = add i64 %1250, %1242
  %1252 = add i64 %1251, %1159
  %1253 = tail call i64 @llvm.fshl.i64(i64 %1237, i64 %1237, i64 36)
  %1254 = tail call i64 @llvm.fshl.i64(i64 %1237, i64 %1237, i64 30)
  %1255 = xor i64 %1253, %1254
  %1256 = tail call i64 @llvm.fshl.i64(i64 %1237, i64 %1237, i64 25)
  %1257 = xor i64 %1255, %1256
  %1258 = or i64 %1211, %1185
  %1259 = and i64 %1237, %1258
  %1260 = and i64 %1211, %1185
  %1261 = or i64 %1259, %1260
  %1262 = add i64 %1257, %1261
  %1263 = add i64 %1262, %1251
  %1264 = tail call i64 @llvm.fshl.i64(i64 %1252, i64 %1252, i64 50)
  %1265 = tail call i64 @llvm.fshl.i64(i64 %1252, i64 %1252, i64 46)
  %1266 = xor i64 %1264, %1265
  %1267 = tail call i64 @llvm.fshl.i64(i64 %1252, i64 %1252, i64 23)
  %1268 = xor i64 %1266, %1267
  %1269 = xor i64 %1226, %1200
  %1270 = and i64 %1252, %1269
  %1271 = xor i64 %1270, %1200
  %1272 = getelementptr inbounds nuw i8, ptr %4, i64 376
  %1273 = load i64, ptr %1272, align 8
  %1274 = add i64 %1273, 1182934255886127544
  %1275 = add i64 %1274, %1174
  %1276 = add i64 %1275, %1271
  %1277 = add i64 %1276, %1268
  %1278 = add i64 %1277, %1185
  %1279 = tail call i64 @llvm.fshl.i64(i64 %1263, i64 %1263, i64 36)
  %1280 = tail call i64 @llvm.fshl.i64(i64 %1263, i64 %1263, i64 30)
  %1281 = xor i64 %1279, %1280
  %1282 = tail call i64 @llvm.fshl.i64(i64 %1263, i64 %1263, i64 25)
  %1283 = xor i64 %1281, %1282
  %1284 = or i64 %1237, %1211
  %1285 = and i64 %1263, %1284
  %1286 = and i64 %1237, %1211
  %1287 = or i64 %1285, %1286
  %1288 = add i64 %1283, %1287
  %1289 = add i64 %1288, %1277
  %1290 = tail call i64 @llvm.fshl.i64(i64 %1278, i64 %1278, i64 50)
  %1291 = tail call i64 @llvm.fshl.i64(i64 %1278, i64 %1278, i64 46)
  %1292 = xor i64 %1290, %1291
  %1293 = tail call i64 @llvm.fshl.i64(i64 %1278, i64 %1278, i64 23)
  %1294 = xor i64 %1292, %1293
  %1295 = xor i64 %1252, %1226
  %1296 = and i64 %1278, %1295
  %1297 = xor i64 %1296, %1226
  %1298 = getelementptr inbounds nuw i8, ptr %4, i64 384
  %1299 = load i64, ptr %1298, align 8
  %1300 = add i64 %1299, 1847814050463011016
  %1301 = add i64 %1300, %1200
  %1302 = add i64 %1301, %1297
  %1303 = add i64 %1302, %1294
  %1304 = add i64 %1303, %1211
  %1305 = tail call i64 @llvm.fshl.i64(i64 %1289, i64 %1289, i64 36)
  %1306 = tail call i64 @llvm.fshl.i64(i64 %1289, i64 %1289, i64 30)
  %1307 = xor i64 %1305, %1306
  %1308 = tail call i64 @llvm.fshl.i64(i64 %1289, i64 %1289, i64 25)
  %1309 = xor i64 %1307, %1308
  %1310 = or i64 %1263, %1237
  %1311 = and i64 %1289, %1310
  %1312 = and i64 %1263, %1237
  %1313 = or i64 %1311, %1312
  %1314 = add i64 %1309, %1313
  %1315 = add i64 %1314, %1303
  %1316 = tail call i64 @llvm.fshl.i64(i64 %1304, i64 %1304, i64 50)
  %1317 = tail call i64 @llvm.fshl.i64(i64 %1304, i64 %1304, i64 46)
  %1318 = xor i64 %1316, %1317
  %1319 = tail call i64 @llvm.fshl.i64(i64 %1304, i64 %1304, i64 23)
  %1320 = xor i64 %1318, %1319
  %1321 = xor i64 %1278, %1252
  %1322 = and i64 %1304, %1321
  %1323 = xor i64 %1322, %1252
  %1324 = getelementptr inbounds nuw i8, ptr %4, i64 392
  %1325 = load i64, ptr %1324, align 8
  %1326 = add i64 %1325, 2177327727835720531
  %1327 = add i64 %1326, %1226
  %1328 = add i64 %1327, %1323
  %1329 = add i64 %1328, %1320
  %1330 = add i64 %1329, %1237
  %1331 = tail call i64 @llvm.fshl.i64(i64 %1315, i64 %1315, i64 36)
  %1332 = tail call i64 @llvm.fshl.i64(i64 %1315, i64 %1315, i64 30)
  %1333 = xor i64 %1331, %1332
  %1334 = tail call i64 @llvm.fshl.i64(i64 %1315, i64 %1315, i64 25)
  %1335 = xor i64 %1333, %1334
  %1336 = or i64 %1289, %1263
  %1337 = and i64 %1315, %1336
  %1338 = and i64 %1289, %1263
  %1339 = or i64 %1337, %1338
  %1340 = add i64 %1335, %1339
  %1341 = add i64 %1340, %1329
  %1342 = tail call i64 @llvm.fshl.i64(i64 %1330, i64 %1330, i64 50)
  %1343 = tail call i64 @llvm.fshl.i64(i64 %1330, i64 %1330, i64 46)
  %1344 = xor i64 %1342, %1343
  %1345 = tail call i64 @llvm.fshl.i64(i64 %1330, i64 %1330, i64 23)
  %1346 = xor i64 %1344, %1345
  %1347 = xor i64 %1304, %1278
  %1348 = and i64 %1330, %1347
  %1349 = xor i64 %1348, %1278
  %1350 = getelementptr inbounds nuw i8, ptr %4, i64 400
  %1351 = load i64, ptr %1350, align 8
  %1352 = add i64 %1351, 2830643537854262169
  %1353 = add i64 %1352, %1252
  %1354 = add i64 %1353, %1349
  %1355 = add i64 %1354, %1346
  %1356 = add i64 %1355, %1263
  %1357 = tail call i64 @llvm.fshl.i64(i64 %1341, i64 %1341, i64 36)
  %1358 = tail call i64 @llvm.fshl.i64(i64 %1341, i64 %1341, i64 30)
  %1359 = xor i64 %1357, %1358
  %1360 = tail call i64 @llvm.fshl.i64(i64 %1341, i64 %1341, i64 25)
  %1361 = xor i64 %1359, %1360
  %1362 = or i64 %1315, %1289
  %1363 = and i64 %1341, %1362
  %1364 = and i64 %1315, %1289
  %1365 = or i64 %1363, %1364
  %1366 = add i64 %1361, %1365
  %1367 = add i64 %1366, %1355
  %1368 = tail call i64 @llvm.fshl.i64(i64 %1356, i64 %1356, i64 50)
  %1369 = tail call i64 @llvm.fshl.i64(i64 %1356, i64 %1356, i64 46)
  %1370 = xor i64 %1368, %1369
  %1371 = tail call i64 @llvm.fshl.i64(i64 %1356, i64 %1356, i64 23)
  %1372 = xor i64 %1370, %1371
  %1373 = xor i64 %1330, %1304
  %1374 = and i64 %1356, %1373
  %1375 = xor i64 %1374, %1304
  %1376 = getelementptr inbounds nuw i8, ptr %4, i64 408
  %1377 = load i64, ptr %1376, align 8
  %1378 = add i64 %1377, 3796741975233480872
  %1379 = add i64 %1378, %1278
  %1380 = add i64 %1379, %1375
  %1381 = add i64 %1380, %1372
  %1382 = add i64 %1381, %1289
  %1383 = tail call i64 @llvm.fshl.i64(i64 %1367, i64 %1367, i64 36)
  %1384 = tail call i64 @llvm.fshl.i64(i64 %1367, i64 %1367, i64 30)
  %1385 = xor i64 %1383, %1384
  %1386 = tail call i64 @llvm.fshl.i64(i64 %1367, i64 %1367, i64 25)
  %1387 = xor i64 %1385, %1386
  %1388 = or i64 %1341, %1315
  %1389 = and i64 %1367, %1388
  %1390 = and i64 %1341, %1315
  %1391 = or i64 %1389, %1390
  %1392 = add i64 %1387, %1391
  %1393 = add i64 %1392, %1381
  %1394 = tail call i64 @llvm.fshl.i64(i64 %1382, i64 %1382, i64 50)
  %1395 = tail call i64 @llvm.fshl.i64(i64 %1382, i64 %1382, i64 46)
  %1396 = xor i64 %1394, %1395
  %1397 = tail call i64 @llvm.fshl.i64(i64 %1382, i64 %1382, i64 23)
  %1398 = xor i64 %1396, %1397
  %1399 = xor i64 %1356, %1330
  %1400 = and i64 %1382, %1399
  %1401 = xor i64 %1400, %1330
  %1402 = getelementptr inbounds nuw i8, ptr %4, i64 416
  %1403 = load i64, ptr %1402, align 8
  %1404 = add i64 %1403, 4115178125766777443
  %1405 = add i64 %1404, %1304
  %1406 = add i64 %1405, %1401
  %1407 = add i64 %1406, %1398
  %1408 = add i64 %1407, %1315
  %1409 = tail call i64 @llvm.fshl.i64(i64 %1393, i64 %1393, i64 36)
  %1410 = tail call i64 @llvm.fshl.i64(i64 %1393, i64 %1393, i64 30)
  %1411 = xor i64 %1409, %1410
  %1412 = tail call i64 @llvm.fshl.i64(i64 %1393, i64 %1393, i64 25)
  %1413 = xor i64 %1411, %1412
  %1414 = or i64 %1367, %1341
  %1415 = and i64 %1393, %1414
  %1416 = and i64 %1367, %1341
  %1417 = or i64 %1415, %1416
  %1418 = add i64 %1413, %1417
  %1419 = add i64 %1418, %1407
  %1420 = tail call i64 @llvm.fshl.i64(i64 %1408, i64 %1408, i64 50)
  %1421 = tail call i64 @llvm.fshl.i64(i64 %1408, i64 %1408, i64 46)
  %1422 = xor i64 %1420, %1421
  %1423 = tail call i64 @llvm.fshl.i64(i64 %1408, i64 %1408, i64 23)
  %1424 = xor i64 %1422, %1423
  %1425 = xor i64 %1382, %1356
  %1426 = and i64 %1408, %1425
  %1427 = xor i64 %1426, %1356
  %1428 = getelementptr inbounds nuw i8, ptr %4, i64 424
  %1429 = load i64, ptr %1428, align 8
  %1430 = add i64 %1429, 5681478168544905931
  %1431 = add i64 %1430, %1330
  %1432 = add i64 %1431, %1427
  %1433 = add i64 %1432, %1424
  %1434 = add i64 %1433, %1341
  %1435 = tail call i64 @llvm.fshl.i64(i64 %1419, i64 %1419, i64 36)
  %1436 = tail call i64 @llvm.fshl.i64(i64 %1419, i64 %1419, i64 30)
  %1437 = xor i64 %1435, %1436
  %1438 = tail call i64 @llvm.fshl.i64(i64 %1419, i64 %1419, i64 25)
  %1439 = xor i64 %1437, %1438
  %1440 = or i64 %1393, %1367
  %1441 = and i64 %1419, %1440
  %1442 = and i64 %1393, %1367
  %1443 = or i64 %1441, %1442
  %1444 = add i64 %1439, %1443
  %1445 = add i64 %1444, %1433
  %1446 = tail call i64 @llvm.fshl.i64(i64 %1434, i64 %1434, i64 50)
  %1447 = tail call i64 @llvm.fshl.i64(i64 %1434, i64 %1434, i64 46)
  %1448 = xor i64 %1446, %1447
  %1449 = tail call i64 @llvm.fshl.i64(i64 %1434, i64 %1434, i64 23)
  %1450 = xor i64 %1448, %1449
  %1451 = xor i64 %1408, %1382
  %1452 = and i64 %1434, %1451
  %1453 = xor i64 %1452, %1382
  %1454 = getelementptr inbounds nuw i8, ptr %4, i64 432
  %1455 = load i64, ptr %1454, align 8
  %1456 = add i64 %1455, 6601373596472566643
  %1457 = add i64 %1456, %1356
  %1458 = add i64 %1457, %1453
  %1459 = add i64 %1458, %1450
  %1460 = add i64 %1459, %1367
  %1461 = tail call i64 @llvm.fshl.i64(i64 %1445, i64 %1445, i64 36)
  %1462 = tail call i64 @llvm.fshl.i64(i64 %1445, i64 %1445, i64 30)
  %1463 = xor i64 %1461, %1462
  %1464 = tail call i64 @llvm.fshl.i64(i64 %1445, i64 %1445, i64 25)
  %1465 = xor i64 %1463, %1464
  %1466 = or i64 %1419, %1393
  %1467 = and i64 %1445, %1466
  %1468 = and i64 %1419, %1393
  %1469 = or i64 %1467, %1468
  %1470 = add i64 %1465, %1469
  %1471 = add i64 %1470, %1459
  %1472 = tail call i64 @llvm.fshl.i64(i64 %1460, i64 %1460, i64 50)
  %1473 = tail call i64 @llvm.fshl.i64(i64 %1460, i64 %1460, i64 46)
  %1474 = xor i64 %1472, %1473
  %1475 = tail call i64 @llvm.fshl.i64(i64 %1460, i64 %1460, i64 23)
  %1476 = xor i64 %1474, %1475
  %1477 = xor i64 %1434, %1408
  %1478 = and i64 %1460, %1477
  %1479 = xor i64 %1478, %1408
  %1480 = getelementptr inbounds nuw i8, ptr %4, i64 440
  %1481 = load i64, ptr %1480, align 8
  %1482 = add i64 %1481, 7507060721942968483
  %1483 = add i64 %1482, %1382
  %1484 = add i64 %1483, %1479
  %1485 = add i64 %1484, %1476
  %1486 = add i64 %1485, %1393
  %1487 = tail call i64 @llvm.fshl.i64(i64 %1471, i64 %1471, i64 36)
  %1488 = tail call i64 @llvm.fshl.i64(i64 %1471, i64 %1471, i64 30)
  %1489 = xor i64 %1487, %1488
  %1490 = tail call i64 @llvm.fshl.i64(i64 %1471, i64 %1471, i64 25)
  %1491 = xor i64 %1489, %1490
  %1492 = or i64 %1445, %1419
  %1493 = and i64 %1471, %1492
  %1494 = and i64 %1445, %1419
  %1495 = or i64 %1493, %1494
  %1496 = add i64 %1491, %1495
  %1497 = add i64 %1496, %1485
  %1498 = tail call i64 @llvm.fshl.i64(i64 %1486, i64 %1486, i64 50)
  %1499 = tail call i64 @llvm.fshl.i64(i64 %1486, i64 %1486, i64 46)
  %1500 = xor i64 %1498, %1499
  %1501 = tail call i64 @llvm.fshl.i64(i64 %1486, i64 %1486, i64 23)
  %1502 = xor i64 %1500, %1501
  %1503 = xor i64 %1460, %1434
  %1504 = and i64 %1486, %1503
  %1505 = xor i64 %1504, %1434
  %1506 = getelementptr inbounds nuw i8, ptr %4, i64 448
  %1507 = load i64, ptr %1506, align 8
  %1508 = add i64 %1507, 8399075790359081724
  %1509 = add i64 %1508, %1408
  %1510 = add i64 %1509, %1505
  %1511 = add i64 %1510, %1502
  %1512 = add i64 %1511, %1419
  %1513 = tail call i64 @llvm.fshl.i64(i64 %1497, i64 %1497, i64 36)
  %1514 = tail call i64 @llvm.fshl.i64(i64 %1497, i64 %1497, i64 30)
  %1515 = xor i64 %1513, %1514
  %1516 = tail call i64 @llvm.fshl.i64(i64 %1497, i64 %1497, i64 25)
  %1517 = xor i64 %1515, %1516
  %1518 = or i64 %1471, %1445
  %1519 = and i64 %1497, %1518
  %1520 = and i64 %1471, %1445
  %1521 = or i64 %1519, %1520
  %1522 = add i64 %1517, %1521
  %1523 = add i64 %1522, %1511
  %1524 = tail call i64 @llvm.fshl.i64(i64 %1512, i64 %1512, i64 50)
  %1525 = tail call i64 @llvm.fshl.i64(i64 %1512, i64 %1512, i64 46)
  %1526 = xor i64 %1524, %1525
  %1527 = tail call i64 @llvm.fshl.i64(i64 %1512, i64 %1512, i64 23)
  %1528 = xor i64 %1526, %1527
  %1529 = xor i64 %1486, %1460
  %1530 = and i64 %1512, %1529
  %1531 = xor i64 %1530, %1460
  %1532 = getelementptr inbounds nuw i8, ptr %4, i64 456
  %1533 = load i64, ptr %1532, align 8
  %1534 = add i64 %1533, 8693463985226723168
  %1535 = add i64 %1534, %1434
  %1536 = add i64 %1535, %1531
  %1537 = add i64 %1536, %1528
  %1538 = add i64 %1537, %1445
  %1539 = tail call i64 @llvm.fshl.i64(i64 %1523, i64 %1523, i64 36)
  %1540 = tail call i64 @llvm.fshl.i64(i64 %1523, i64 %1523, i64 30)
  %1541 = xor i64 %1539, %1540
  %1542 = tail call i64 @llvm.fshl.i64(i64 %1523, i64 %1523, i64 25)
  %1543 = xor i64 %1541, %1542
  %1544 = or i64 %1497, %1471
  %1545 = and i64 %1523, %1544
  %1546 = and i64 %1497, %1471
  %1547 = or i64 %1545, %1546
  %1548 = add i64 %1543, %1547
  %1549 = add i64 %1548, %1537
  %1550 = tail call i64 @llvm.fshl.i64(i64 %1538, i64 %1538, i64 50)
  %1551 = tail call i64 @llvm.fshl.i64(i64 %1538, i64 %1538, i64 46)
  %1552 = xor i64 %1550, %1551
  %1553 = tail call i64 @llvm.fshl.i64(i64 %1538, i64 %1538, i64 23)
  %1554 = xor i64 %1552, %1553
  %1555 = xor i64 %1512, %1486
  %1556 = and i64 %1538, %1555
  %1557 = xor i64 %1556, %1486
  %1558 = getelementptr inbounds nuw i8, ptr %4, i64 464
  %1559 = load i64, ptr %1558, align 8
  %1560 = add i64 %1559, -8878714635349349518
  %1561 = add i64 %1560, %1460
  %1562 = add i64 %1561, %1557
  %1563 = add i64 %1562, %1554
  %1564 = add i64 %1563, %1471
  %1565 = tail call i64 @llvm.fshl.i64(i64 %1549, i64 %1549, i64 36)
  %1566 = tail call i64 @llvm.fshl.i64(i64 %1549, i64 %1549, i64 30)
  %1567 = xor i64 %1565, %1566
  %1568 = tail call i64 @llvm.fshl.i64(i64 %1549, i64 %1549, i64 25)
  %1569 = xor i64 %1567, %1568
  %1570 = or i64 %1523, %1497
  %1571 = and i64 %1549, %1570
  %1572 = and i64 %1523, %1497
  %1573 = or i64 %1571, %1572
  %1574 = add i64 %1569, %1573
  %1575 = add i64 %1574, %1563
  %1576 = tail call i64 @llvm.fshl.i64(i64 %1564, i64 %1564, i64 50)
  %1577 = tail call i64 @llvm.fshl.i64(i64 %1564, i64 %1564, i64 46)
  %1578 = xor i64 %1576, %1577
  %1579 = tail call i64 @llvm.fshl.i64(i64 %1564, i64 %1564, i64 23)
  %1580 = xor i64 %1578, %1579
  %1581 = xor i64 %1538, %1512
  %1582 = and i64 %1564, %1581
  %1583 = xor i64 %1582, %1512
  %1584 = getelementptr inbounds nuw i8, ptr %4, i64 472
  %1585 = load i64, ptr %1584, align 8
  %1586 = add i64 %1585, -8302665154208450068
  %1587 = add i64 %1586, %1486
  %1588 = add i64 %1587, %1583
  %1589 = add i64 %1588, %1580
  %1590 = add i64 %1589, %1497
  %1591 = tail call i64 @llvm.fshl.i64(i64 %1575, i64 %1575, i64 36)
  %1592 = tail call i64 @llvm.fshl.i64(i64 %1575, i64 %1575, i64 30)
  %1593 = xor i64 %1591, %1592
  %1594 = tail call i64 @llvm.fshl.i64(i64 %1575, i64 %1575, i64 25)
  %1595 = xor i64 %1593, %1594
  %1596 = or i64 %1549, %1523
  %1597 = and i64 %1575, %1596
  %1598 = and i64 %1549, %1523
  %1599 = or i64 %1597, %1598
  %1600 = add i64 %1595, %1599
  %1601 = add i64 %1600, %1589
  %1602 = tail call i64 @llvm.fshl.i64(i64 %1590, i64 %1590, i64 50)
  %1603 = tail call i64 @llvm.fshl.i64(i64 %1590, i64 %1590, i64 46)
  %1604 = xor i64 %1602, %1603
  %1605 = tail call i64 @llvm.fshl.i64(i64 %1590, i64 %1590, i64 23)
  %1606 = xor i64 %1604, %1605
  %1607 = xor i64 %1564, %1538
  %1608 = and i64 %1590, %1607
  %1609 = xor i64 %1608, %1538
  %1610 = getelementptr inbounds nuw i8, ptr %4, i64 480
  %1611 = load i64, ptr %1610, align 8
  %1612 = add i64 %1611, -8016688836872298968
  %1613 = add i64 %1612, %1512
  %1614 = add i64 %1613, %1609
  %1615 = add i64 %1614, %1606
  %1616 = add i64 %1615, %1523
  %1617 = tail call i64 @llvm.fshl.i64(i64 %1601, i64 %1601, i64 36)
  %1618 = tail call i64 @llvm.fshl.i64(i64 %1601, i64 %1601, i64 30)
  %1619 = xor i64 %1617, %1618
  %1620 = tail call i64 @llvm.fshl.i64(i64 %1601, i64 %1601, i64 25)
  %1621 = xor i64 %1619, %1620
  %1622 = or i64 %1575, %1549
  %1623 = and i64 %1601, %1622
  %1624 = and i64 %1575, %1549
  %1625 = or i64 %1623, %1624
  %1626 = add i64 %1621, %1625
  %1627 = add i64 %1626, %1615
  %1628 = tail call i64 @llvm.fshl.i64(i64 %1616, i64 %1616, i64 50)
  %1629 = tail call i64 @llvm.fshl.i64(i64 %1616, i64 %1616, i64 46)
  %1630 = xor i64 %1628, %1629
  %1631 = tail call i64 @llvm.fshl.i64(i64 %1616, i64 %1616, i64 23)
  %1632 = xor i64 %1630, %1631
  %1633 = xor i64 %1590, %1564
  %1634 = and i64 %1616, %1633
  %1635 = xor i64 %1634, %1564
  %1636 = getelementptr inbounds nuw i8, ptr %4, i64 488
  %1637 = load i64, ptr %1636, align 8
  %1638 = add i64 %1637, -6606660893046293015
  %1639 = add i64 %1638, %1538
  %1640 = add i64 %1639, %1635
  %1641 = add i64 %1640, %1632
  %1642 = add i64 %1641, %1549
  %1643 = tail call i64 @llvm.fshl.i64(i64 %1627, i64 %1627, i64 36)
  %1644 = tail call i64 @llvm.fshl.i64(i64 %1627, i64 %1627, i64 30)
  %1645 = xor i64 %1643, %1644
  %1646 = tail call i64 @llvm.fshl.i64(i64 %1627, i64 %1627, i64 25)
  %1647 = xor i64 %1645, %1646
  %1648 = or i64 %1601, %1575
  %1649 = and i64 %1627, %1648
  %1650 = and i64 %1601, %1575
  %1651 = or i64 %1649, %1650
  %1652 = add i64 %1647, %1651
  %1653 = add i64 %1652, %1641
  %1654 = tail call i64 @llvm.fshl.i64(i64 %1642, i64 %1642, i64 50)
  %1655 = tail call i64 @llvm.fshl.i64(i64 %1642, i64 %1642, i64 46)
  %1656 = xor i64 %1654, %1655
  %1657 = tail call i64 @llvm.fshl.i64(i64 %1642, i64 %1642, i64 23)
  %1658 = xor i64 %1656, %1657
  %1659 = xor i64 %1616, %1590
  %1660 = and i64 %1642, %1659
  %1661 = xor i64 %1660, %1590
  %1662 = getelementptr inbounds nuw i8, ptr %4, i64 496
  %1663 = load i64, ptr %1662, align 8
  %1664 = add i64 %1663, -4685533653050689259
  %1665 = add i64 %1664, %1564
  %1666 = add i64 %1665, %1661
  %1667 = add i64 %1666, %1658
  %1668 = add i64 %1667, %1575
  %1669 = tail call i64 @llvm.fshl.i64(i64 %1653, i64 %1653, i64 36)
  %1670 = tail call i64 @llvm.fshl.i64(i64 %1653, i64 %1653, i64 30)
  %1671 = xor i64 %1669, %1670
  %1672 = tail call i64 @llvm.fshl.i64(i64 %1653, i64 %1653, i64 25)
  %1673 = xor i64 %1671, %1672
  %1674 = or i64 %1627, %1601
  %1675 = and i64 %1653, %1674
  %1676 = and i64 %1627, %1601
  %1677 = or i64 %1675, %1676
  %1678 = add i64 %1673, %1677
  %1679 = add i64 %1678, %1667
  %1680 = tail call i64 @llvm.fshl.i64(i64 %1668, i64 %1668, i64 50)
  %1681 = tail call i64 @llvm.fshl.i64(i64 %1668, i64 %1668, i64 46)
  %1682 = xor i64 %1680, %1681
  %1683 = tail call i64 @llvm.fshl.i64(i64 %1668, i64 %1668, i64 23)
  %1684 = xor i64 %1682, %1683
  %1685 = xor i64 %1642, %1616
  %1686 = and i64 %1668, %1685
  %1687 = xor i64 %1686, %1616
  %1688 = getelementptr inbounds nuw i8, ptr %4, i64 504
  %1689 = load i64, ptr %1688, align 8
  %1690 = add i64 %1689, -4147400797238176981
  %1691 = add i64 %1690, %1590
  %1692 = add i64 %1691, %1687
  %1693 = add i64 %1692, %1684
  %1694 = add i64 %1693, %1601
  %1695 = tail call i64 @llvm.fshl.i64(i64 %1679, i64 %1679, i64 36)
  %1696 = tail call i64 @llvm.fshl.i64(i64 %1679, i64 %1679, i64 30)
  %1697 = xor i64 %1695, %1696
  %1698 = tail call i64 @llvm.fshl.i64(i64 %1679, i64 %1679, i64 25)
  %1699 = xor i64 %1697, %1698
  %1700 = or i64 %1653, %1627
  %1701 = and i64 %1679, %1700
  %1702 = and i64 %1653, %1627
  %1703 = or i64 %1701, %1702
  %1704 = add i64 %1699, %1703
  %1705 = add i64 %1704, %1693
  %1706 = tail call i64 @llvm.fshl.i64(i64 %1694, i64 %1694, i64 50)
  %1707 = tail call i64 @llvm.fshl.i64(i64 %1694, i64 %1694, i64 46)
  %1708 = xor i64 %1706, %1707
  %1709 = tail call i64 @llvm.fshl.i64(i64 %1694, i64 %1694, i64 23)
  %1710 = xor i64 %1708, %1709
  %1711 = xor i64 %1668, %1642
  %1712 = and i64 %1694, %1711
  %1713 = xor i64 %1712, %1642
  %1714 = getelementptr inbounds nuw i8, ptr %4, i64 512
  %1715 = load i64, ptr %1714, align 8
  %1716 = add i64 %1715, -3880063495543823972
  %1717 = add i64 %1716, %1616
  %1718 = add i64 %1717, %1713
  %1719 = add i64 %1718, %1710
  %1720 = add i64 %1719, %1627
  %1721 = tail call i64 @llvm.fshl.i64(i64 %1705, i64 %1705, i64 36)
  %1722 = tail call i64 @llvm.fshl.i64(i64 %1705, i64 %1705, i64 30)
  %1723 = xor i64 %1721, %1722
  %1724 = tail call i64 @llvm.fshl.i64(i64 %1705, i64 %1705, i64 25)
  %1725 = xor i64 %1723, %1724
  %1726 = or i64 %1679, %1653
  %1727 = and i64 %1705, %1726
  %1728 = and i64 %1679, %1653
  %1729 = or i64 %1727, %1728
  %1730 = add i64 %1725, %1729
  %1731 = add i64 %1730, %1719
  %1732 = tail call i64 @llvm.fshl.i64(i64 %1720, i64 %1720, i64 50)
  %1733 = tail call i64 @llvm.fshl.i64(i64 %1720, i64 %1720, i64 46)
  %1734 = xor i64 %1732, %1733
  %1735 = tail call i64 @llvm.fshl.i64(i64 %1720, i64 %1720, i64 23)
  %1736 = xor i64 %1734, %1735
  %1737 = xor i64 %1694, %1668
  %1738 = and i64 %1720, %1737
  %1739 = xor i64 %1738, %1668
  %1740 = getelementptr inbounds nuw i8, ptr %4, i64 520
  %1741 = load i64, ptr %1740, align 8
  %1742 = add i64 %1741, -3348786107499101689
  %1743 = add i64 %1742, %1642
  %1744 = add i64 %1743, %1739
  %1745 = add i64 %1744, %1736
  %1746 = add i64 %1745, %1653
  %1747 = tail call i64 @llvm.fshl.i64(i64 %1731, i64 %1731, i64 36)
  %1748 = tail call i64 @llvm.fshl.i64(i64 %1731, i64 %1731, i64 30)
  %1749 = xor i64 %1747, %1748
  %1750 = tail call i64 @llvm.fshl.i64(i64 %1731, i64 %1731, i64 25)
  %1751 = xor i64 %1749, %1750
  %1752 = or i64 %1705, %1679
  %1753 = and i64 %1731, %1752
  %1754 = and i64 %1705, %1679
  %1755 = or i64 %1753, %1754
  %1756 = add i64 %1751, %1755
  %1757 = add i64 %1756, %1745
  %1758 = tail call i64 @llvm.fshl.i64(i64 %1746, i64 %1746, i64 50)
  %1759 = tail call i64 @llvm.fshl.i64(i64 %1746, i64 %1746, i64 46)
  %1760 = xor i64 %1758, %1759
  %1761 = tail call i64 @llvm.fshl.i64(i64 %1746, i64 %1746, i64 23)
  %1762 = xor i64 %1760, %1761
  %1763 = xor i64 %1720, %1694
  %1764 = and i64 %1746, %1763
  %1765 = xor i64 %1764, %1694
  %1766 = getelementptr inbounds nuw i8, ptr %4, i64 528
  %1767 = load i64, ptr %1766, align 8
  %1768 = add i64 %1767, -1523767162380948706
  %1769 = add i64 %1768, %1668
  %1770 = add i64 %1769, %1765
  %1771 = add i64 %1770, %1762
  %1772 = add i64 %1771, %1679
  %1773 = tail call i64 @llvm.fshl.i64(i64 %1757, i64 %1757, i64 36)
  %1774 = tail call i64 @llvm.fshl.i64(i64 %1757, i64 %1757, i64 30)
  %1775 = xor i64 %1773, %1774
  %1776 = tail call i64 @llvm.fshl.i64(i64 %1757, i64 %1757, i64 25)
  %1777 = xor i64 %1775, %1776
  %1778 = or i64 %1731, %1705
  %1779 = and i64 %1757, %1778
  %1780 = and i64 %1731, %1705
  %1781 = or i64 %1779, %1780
  %1782 = add i64 %1777, %1781
  %1783 = add i64 %1782, %1771
  %1784 = tail call i64 @llvm.fshl.i64(i64 %1772, i64 %1772, i64 50)
  %1785 = tail call i64 @llvm.fshl.i64(i64 %1772, i64 %1772, i64 46)
  %1786 = xor i64 %1784, %1785
  %1787 = tail call i64 @llvm.fshl.i64(i64 %1772, i64 %1772, i64 23)
  %1788 = xor i64 %1786, %1787
  %1789 = xor i64 %1746, %1720
  %1790 = and i64 %1772, %1789
  %1791 = xor i64 %1790, %1720
  %1792 = getelementptr inbounds nuw i8, ptr %4, i64 536
  %1793 = load i64, ptr %1792, align 8
  %1794 = add i64 %1793, -757361751448694408
  %1795 = add i64 %1794, %1694
  %1796 = add i64 %1795, %1791
  %1797 = add i64 %1796, %1788
  %1798 = add i64 %1797, %1705
  %1799 = tail call i64 @llvm.fshl.i64(i64 %1783, i64 %1783, i64 36)
  %1800 = tail call i64 @llvm.fshl.i64(i64 %1783, i64 %1783, i64 30)
  %1801 = xor i64 %1799, %1800
  %1802 = tail call i64 @llvm.fshl.i64(i64 %1783, i64 %1783, i64 25)
  %1803 = xor i64 %1801, %1802
  %1804 = or i64 %1757, %1731
  %1805 = and i64 %1783, %1804
  %1806 = and i64 %1757, %1731
  %1807 = or i64 %1805, %1806
  %1808 = add i64 %1803, %1807
  %1809 = add i64 %1808, %1797
  %1810 = tail call i64 @llvm.fshl.i64(i64 %1798, i64 %1798, i64 50)
  %1811 = tail call i64 @llvm.fshl.i64(i64 %1798, i64 %1798, i64 46)
  %1812 = xor i64 %1810, %1811
  %1813 = tail call i64 @llvm.fshl.i64(i64 %1798, i64 %1798, i64 23)
  %1814 = xor i64 %1812, %1813
  %1815 = xor i64 %1772, %1746
  %1816 = and i64 %1798, %1815
  %1817 = xor i64 %1816, %1746
  %1818 = getelementptr inbounds nuw i8, ptr %4, i64 544
  %1819 = load i64, ptr %1818, align 8
  %1820 = add i64 %1819, 500013540394364858
  %1821 = add i64 %1820, %1720
  %1822 = add i64 %1821, %1817
  %1823 = add i64 %1822, %1814
  %1824 = add i64 %1823, %1731
  %1825 = tail call i64 @llvm.fshl.i64(i64 %1809, i64 %1809, i64 36)
  %1826 = tail call i64 @llvm.fshl.i64(i64 %1809, i64 %1809, i64 30)
  %1827 = xor i64 %1825, %1826
  %1828 = tail call i64 @llvm.fshl.i64(i64 %1809, i64 %1809, i64 25)
  %1829 = xor i64 %1827, %1828
  %1830 = or i64 %1783, %1757
  %1831 = and i64 %1809, %1830
  %1832 = and i64 %1783, %1757
  %1833 = or i64 %1831, %1832
  %1834 = add i64 %1829, %1833
  %1835 = add i64 %1834, %1823
  %1836 = tail call i64 @llvm.fshl.i64(i64 %1824, i64 %1824, i64 50)
  %1837 = tail call i64 @llvm.fshl.i64(i64 %1824, i64 %1824, i64 46)
  %1838 = xor i64 %1836, %1837
  %1839 = tail call i64 @llvm.fshl.i64(i64 %1824, i64 %1824, i64 23)
  %1840 = xor i64 %1838, %1839
  %1841 = xor i64 %1798, %1772
  %1842 = and i64 %1824, %1841
  %1843 = xor i64 %1842, %1772
  %1844 = getelementptr inbounds nuw i8, ptr %4, i64 552
  %1845 = load i64, ptr %1844, align 8
  %1846 = add i64 %1845, 748580250866718886
  %1847 = add i64 %1846, %1746
  %1848 = add i64 %1847, %1843
  %1849 = add i64 %1848, %1840
  %1850 = add i64 %1849, %1757
  %1851 = tail call i64 @llvm.fshl.i64(i64 %1835, i64 %1835, i64 36)
  %1852 = tail call i64 @llvm.fshl.i64(i64 %1835, i64 %1835, i64 30)
  %1853 = xor i64 %1851, %1852
  %1854 = tail call i64 @llvm.fshl.i64(i64 %1835, i64 %1835, i64 25)
  %1855 = xor i64 %1853, %1854
  %1856 = or i64 %1809, %1783
  %1857 = and i64 %1835, %1856
  %1858 = and i64 %1809, %1783
  %1859 = or i64 %1857, %1858
  %1860 = add i64 %1855, %1859
  %1861 = add i64 %1860, %1849
  %1862 = tail call i64 @llvm.fshl.i64(i64 %1850, i64 %1850, i64 50)
  %1863 = tail call i64 @llvm.fshl.i64(i64 %1850, i64 %1850, i64 46)
  %1864 = xor i64 %1862, %1863
  %1865 = tail call i64 @llvm.fshl.i64(i64 %1850, i64 %1850, i64 23)
  %1866 = xor i64 %1864, %1865
  %1867 = xor i64 %1824, %1798
  %1868 = and i64 %1850, %1867
  %1869 = xor i64 %1868, %1798
  %1870 = getelementptr inbounds nuw i8, ptr %4, i64 560
  %1871 = load i64, ptr %1870, align 8
  %1872 = add i64 %1871, 1242879168328830382
  %1873 = add i64 %1872, %1772
  %1874 = add i64 %1873, %1869
  %1875 = add i64 %1874, %1866
  %1876 = add i64 %1875, %1783
  %1877 = tail call i64 @llvm.fshl.i64(i64 %1861, i64 %1861, i64 36)
  %1878 = tail call i64 @llvm.fshl.i64(i64 %1861, i64 %1861, i64 30)
  %1879 = xor i64 %1877, %1878
  %1880 = tail call i64 @llvm.fshl.i64(i64 %1861, i64 %1861, i64 25)
  %1881 = xor i64 %1879, %1880
  %1882 = or i64 %1835, %1809
  %1883 = and i64 %1861, %1882
  %1884 = and i64 %1835, %1809
  %1885 = or i64 %1883, %1884
  %1886 = add i64 %1881, %1885
  %1887 = add i64 %1886, %1875
  %1888 = tail call i64 @llvm.fshl.i64(i64 %1876, i64 %1876, i64 50)
  %1889 = tail call i64 @llvm.fshl.i64(i64 %1876, i64 %1876, i64 46)
  %1890 = xor i64 %1888, %1889
  %1891 = tail call i64 @llvm.fshl.i64(i64 %1876, i64 %1876, i64 23)
  %1892 = xor i64 %1890, %1891
  %1893 = xor i64 %1850, %1824
  %1894 = and i64 %1876, %1893
  %1895 = xor i64 %1894, %1824
  %1896 = getelementptr inbounds nuw i8, ptr %4, i64 568
  %1897 = load i64, ptr %1896, align 8
  %1898 = add i64 %1897, 1977374033974150939
  %1899 = add i64 %1898, %1798
  %1900 = add i64 %1899, %1895
  %1901 = add i64 %1900, %1892
  %1902 = add i64 %1901, %1809
  %1903 = tail call i64 @llvm.fshl.i64(i64 %1887, i64 %1887, i64 36)
  %1904 = tail call i64 @llvm.fshl.i64(i64 %1887, i64 %1887, i64 30)
  %1905 = xor i64 %1903, %1904
  %1906 = tail call i64 @llvm.fshl.i64(i64 %1887, i64 %1887, i64 25)
  %1907 = xor i64 %1905, %1906
  %1908 = or i64 %1861, %1835
  %1909 = and i64 %1887, %1908
  %1910 = and i64 %1861, %1835
  %1911 = or i64 %1909, %1910
  %1912 = add i64 %1907, %1911
  %1913 = add i64 %1912, %1901
  %1914 = tail call i64 @llvm.fshl.i64(i64 %1902, i64 %1902, i64 50)
  %1915 = tail call i64 @llvm.fshl.i64(i64 %1902, i64 %1902, i64 46)
  %1916 = xor i64 %1914, %1915
  %1917 = tail call i64 @llvm.fshl.i64(i64 %1902, i64 %1902, i64 23)
  %1918 = xor i64 %1916, %1917
  %1919 = xor i64 %1876, %1850
  %1920 = and i64 %1902, %1919
  %1921 = xor i64 %1920, %1850
  %1922 = getelementptr inbounds nuw i8, ptr %4, i64 576
  %1923 = load i64, ptr %1922, align 8
  %1924 = add i64 %1923, 2944078676154940804
  %1925 = add i64 %1924, %1824
  %1926 = add i64 %1925, %1921
  %1927 = add i64 %1926, %1918
  %1928 = add i64 %1927, %1835
  %1929 = tail call i64 @llvm.fshl.i64(i64 %1913, i64 %1913, i64 36)
  %1930 = tail call i64 @llvm.fshl.i64(i64 %1913, i64 %1913, i64 30)
  %1931 = xor i64 %1929, %1930
  %1932 = tail call i64 @llvm.fshl.i64(i64 %1913, i64 %1913, i64 25)
  %1933 = xor i64 %1931, %1932
  %1934 = or i64 %1887, %1861
  %1935 = and i64 %1913, %1934
  %1936 = and i64 %1887, %1861
  %1937 = or i64 %1935, %1936
  %1938 = add i64 %1933, %1937
  %1939 = add i64 %1938, %1927
  %1940 = tail call i64 @llvm.fshl.i64(i64 %1928, i64 %1928, i64 50)
  %1941 = tail call i64 @llvm.fshl.i64(i64 %1928, i64 %1928, i64 46)
  %1942 = xor i64 %1940, %1941
  %1943 = tail call i64 @llvm.fshl.i64(i64 %1928, i64 %1928, i64 23)
  %1944 = xor i64 %1942, %1943
  %1945 = xor i64 %1902, %1876
  %1946 = and i64 %1928, %1945
  %1947 = xor i64 %1946, %1876
  %1948 = getelementptr inbounds nuw i8, ptr %4, i64 584
  %1949 = load i64, ptr %1948, align 8
  %1950 = add i64 %1949, 3659926193048069267
  %1951 = add i64 %1950, %1850
  %1952 = add i64 %1951, %1947
  %1953 = add i64 %1952, %1944
  %1954 = add i64 %1953, %1861
  %1955 = tail call i64 @llvm.fshl.i64(i64 %1939, i64 %1939, i64 36)
  %1956 = tail call i64 @llvm.fshl.i64(i64 %1939, i64 %1939, i64 30)
  %1957 = xor i64 %1955, %1956
  %1958 = tail call i64 @llvm.fshl.i64(i64 %1939, i64 %1939, i64 25)
  %1959 = xor i64 %1957, %1958
  %1960 = or i64 %1913, %1887
  %1961 = and i64 %1939, %1960
  %1962 = and i64 %1913, %1887
  %1963 = or i64 %1961, %1962
  %1964 = add i64 %1959, %1963
  %1965 = add i64 %1964, %1953
  %1966 = tail call i64 @llvm.fshl.i64(i64 %1954, i64 %1954, i64 50)
  %1967 = tail call i64 @llvm.fshl.i64(i64 %1954, i64 %1954, i64 46)
  %1968 = xor i64 %1966, %1967
  %1969 = tail call i64 @llvm.fshl.i64(i64 %1954, i64 %1954, i64 23)
  %1970 = xor i64 %1968, %1969
  %1971 = xor i64 %1928, %1902
  %1972 = and i64 %1954, %1971
  %1973 = xor i64 %1972, %1902
  %1974 = getelementptr inbounds nuw i8, ptr %4, i64 592
  %1975 = load i64, ptr %1974, align 8
  %1976 = add i64 %1975, 4368137639120453308
  %1977 = add i64 %1976, %1876
  %1978 = add i64 %1977, %1973
  %1979 = add i64 %1978, %1970
  %1980 = add i64 %1979, %1887
  %1981 = tail call i64 @llvm.fshl.i64(i64 %1965, i64 %1965, i64 36)
  %1982 = tail call i64 @llvm.fshl.i64(i64 %1965, i64 %1965, i64 30)
  %1983 = xor i64 %1981, %1982
  %1984 = tail call i64 @llvm.fshl.i64(i64 %1965, i64 %1965, i64 25)
  %1985 = xor i64 %1983, %1984
  %1986 = or i64 %1939, %1913
  %1987 = and i64 %1965, %1986
  %1988 = and i64 %1939, %1913
  %1989 = or i64 %1987, %1988
  %1990 = add i64 %1985, %1989
  %1991 = add i64 %1990, %1979
  %1992 = tail call i64 @llvm.fshl.i64(i64 %1980, i64 %1980, i64 50)
  %1993 = tail call i64 @llvm.fshl.i64(i64 %1980, i64 %1980, i64 46)
  %1994 = xor i64 %1992, %1993
  %1995 = tail call i64 @llvm.fshl.i64(i64 %1980, i64 %1980, i64 23)
  %1996 = xor i64 %1994, %1995
  %1997 = xor i64 %1954, %1928
  %1998 = and i64 %1980, %1997
  %1999 = xor i64 %1998, %1928
  %2000 = getelementptr inbounds nuw i8, ptr %4, i64 600
  %2001 = load i64, ptr %2000, align 8
  %2002 = add i64 %2001, 4836135668995329356
  %2003 = add i64 %2002, %1902
  %2004 = add i64 %2003, %1999
  %2005 = add i64 %2004, %1996
  %2006 = add i64 %2005, %1913
  %2007 = tail call i64 @llvm.fshl.i64(i64 %1991, i64 %1991, i64 36)
  %2008 = tail call i64 @llvm.fshl.i64(i64 %1991, i64 %1991, i64 30)
  %2009 = xor i64 %2007, %2008
  %2010 = tail call i64 @llvm.fshl.i64(i64 %1991, i64 %1991, i64 25)
  %2011 = xor i64 %2009, %2010
  %2012 = or i64 %1965, %1939
  %2013 = and i64 %1991, %2012
  %2014 = and i64 %1965, %1939
  %2015 = or i64 %2013, %2014
  %2016 = add i64 %2011, %2015
  %2017 = add i64 %2016, %2005
  %2018 = tail call i64 @llvm.fshl.i64(i64 %2006, i64 %2006, i64 50)
  %2019 = tail call i64 @llvm.fshl.i64(i64 %2006, i64 %2006, i64 46)
  %2020 = xor i64 %2018, %2019
  %2021 = tail call i64 @llvm.fshl.i64(i64 %2006, i64 %2006, i64 23)
  %2022 = xor i64 %2020, %2021
  %2023 = xor i64 %1980, %1954
  %2024 = and i64 %2006, %2023
  %2025 = xor i64 %2024, %1954
  %2026 = getelementptr inbounds nuw i8, ptr %4, i64 608
  %2027 = load i64, ptr %2026, align 8
  %2028 = add i64 %2027, 5532061633213252278
  %2029 = add i64 %2028, %1928
  %2030 = add i64 %2029, %2025
  %2031 = add i64 %2030, %2022
  %2032 = add i64 %2031, %1939
  %2033 = tail call i64 @llvm.fshl.i64(i64 %2017, i64 %2017, i64 36)
  %2034 = tail call i64 @llvm.fshl.i64(i64 %2017, i64 %2017, i64 30)
  %2035 = xor i64 %2033, %2034
  %2036 = tail call i64 @llvm.fshl.i64(i64 %2017, i64 %2017, i64 25)
  %2037 = xor i64 %2035, %2036
  %2038 = or i64 %1991, %1965
  %2039 = and i64 %2017, %2038
  %2040 = and i64 %1991, %1965
  %2041 = or i64 %2039, %2040
  %2042 = add i64 %2037, %2041
  %2043 = add i64 %2042, %2031
  %2044 = tail call i64 @llvm.fshl.i64(i64 %2032, i64 %2032, i64 50)
  %2045 = tail call i64 @llvm.fshl.i64(i64 %2032, i64 %2032, i64 46)
  %2046 = xor i64 %2044, %2045
  %2047 = tail call i64 @llvm.fshl.i64(i64 %2032, i64 %2032, i64 23)
  %2048 = xor i64 %2046, %2047
  %2049 = xor i64 %2006, %1980
  %2050 = and i64 %2032, %2049
  %2051 = xor i64 %2050, %1980
  %2052 = getelementptr inbounds nuw i8, ptr %4, i64 616
  %2053 = load i64, ptr %2052, align 8
  %2054 = add i64 %2053, 6448918945643986474
  %2055 = add i64 %2054, %1954
  %2056 = add i64 %2055, %2051
  %2057 = add i64 %2056, %2048
  %2058 = add i64 %2057, %1965
  %2059 = tail call i64 @llvm.fshl.i64(i64 %2043, i64 %2043, i64 36)
  %2060 = tail call i64 @llvm.fshl.i64(i64 %2043, i64 %2043, i64 30)
  %2061 = xor i64 %2059, %2060
  %2062 = tail call i64 @llvm.fshl.i64(i64 %2043, i64 %2043, i64 25)
  %2063 = xor i64 %2061, %2062
  %2064 = or i64 %2017, %1991
  %2065 = and i64 %2043, %2064
  %2066 = and i64 %2017, %1991
  %2067 = or i64 %2065, %2066
  %2068 = add i64 %2063, %2067
  %2069 = add i64 %2068, %2057
  %2070 = tail call i64 @llvm.fshl.i64(i64 %2058, i64 %2058, i64 50)
  %2071 = tail call i64 @llvm.fshl.i64(i64 %2058, i64 %2058, i64 46)
  %2072 = xor i64 %2070, %2071
  %2073 = tail call i64 @llvm.fshl.i64(i64 %2058, i64 %2058, i64 23)
  %2074 = xor i64 %2072, %2073
  %2075 = xor i64 %2032, %2006
  %2076 = and i64 %2058, %2075
  %2077 = xor i64 %2076, %2006
  %2078 = getelementptr inbounds nuw i8, ptr %4, i64 624
  %2079 = load i64, ptr %2078, align 8
  %2080 = add i64 %2079, 6902733635092675308
  %2081 = add i64 %2080, %1980
  %2082 = add i64 %2081, %2077
  %2083 = add i64 %2082, %2074
  %2084 = add i64 %2083, %1991
  %2085 = tail call i64 @llvm.fshl.i64(i64 %2069, i64 %2069, i64 36)
  %2086 = tail call i64 @llvm.fshl.i64(i64 %2069, i64 %2069, i64 30)
  %2087 = xor i64 %2085, %2086
  %2088 = tail call i64 @llvm.fshl.i64(i64 %2069, i64 %2069, i64 25)
  %2089 = xor i64 %2087, %2088
  %2090 = or i64 %2043, %2017
  %2091 = and i64 %2069, %2090
  %2092 = and i64 %2043, %2017
  %2093 = or i64 %2091, %2092
  %2094 = add i64 %2089, %2093
  %2095 = add i64 %2094, %2083
  %2096 = tail call i64 @llvm.fshl.i64(i64 %2084, i64 %2084, i64 50)
  %2097 = tail call i64 @llvm.fshl.i64(i64 %2084, i64 %2084, i64 46)
  %2098 = xor i64 %2096, %2097
  %2099 = tail call i64 @llvm.fshl.i64(i64 %2084, i64 %2084, i64 23)
  %2100 = xor i64 %2098, %2099
  %2101 = xor i64 %2058, %2032
  %2102 = and i64 %2084, %2101
  %2103 = xor i64 %2102, %2032
  %2104 = getelementptr inbounds nuw i8, ptr %4, i64 632
  %2105 = load i64, ptr %2104, align 8
  %2106 = add i64 %2105, 7801388544844847127
  %2107 = add i64 %2106, %2006
  %2108 = add i64 %2107, %2103
  %2109 = add i64 %2108, %2100
  %2110 = add i64 %2109, %2017
  %2111 = tail call i64 @llvm.fshl.i64(i64 %2095, i64 %2095, i64 36)
  %2112 = tail call i64 @llvm.fshl.i64(i64 %2095, i64 %2095, i64 30)
  %2113 = xor i64 %2111, %2112
  %2114 = tail call i64 @llvm.fshl.i64(i64 %2095, i64 %2095, i64 25)
  %2115 = xor i64 %2113, %2114
  %2116 = or i64 %2069, %2043
  %2117 = and i64 %2095, %2116
  %2118 = and i64 %2069, %2043
  %2119 = or i64 %2117, %2118
  %2120 = add i64 %2115, %2119
  %2121 = add i64 %2120, %2109
  store i64 %2121, ptr %3, align 8
  %.sroa.222.0..sroa_idx206 = getelementptr inbounds nuw i8, ptr %3, i64 8
  store i64 %2095, ptr %.sroa.222.0..sroa_idx206, align 8
  %.sroa.442.0..sroa_idx397 = getelementptr inbounds nuw i8, ptr %3, i64 16
  store i64 %2069, ptr %.sroa.442.0..sroa_idx397, align 8
  %.sroa.662.0..sroa_idx588 = getelementptr inbounds nuw i8, ptr %3, i64 24
  store i64 %2043, ptr %.sroa.662.0..sroa_idx588, align 8
  %.sroa.882.0..sroa_idx779 = getelementptr inbounds nuw i8, ptr %3, i64 32
  store i64 %2110, ptr %.sroa.882.0..sroa_idx779, align 8
  %.sroa.1102.0..sroa_idx970 = getelementptr inbounds nuw i8, ptr %3, i64 40
  store i64 %2084, ptr %.sroa.1102.0..sroa_idx970, align 8
  %.sroa.1322.0..sroa_idx1161 = getelementptr inbounds nuw i8, ptr %3, i64 48
  store i64 %2058, ptr %.sroa.1322.0..sroa_idx1161, align 8
  %.sroa.1542.0..sroa_idx1352 = getelementptr inbounds nuw i8, ptr %3, i64 56
  store i64 %2032, ptr %.sroa.1542.0..sroa_idx1352, align 8
  br label %2122

2122:                                             ; preds = %2123, %41
  %.0 = phi i64 [ 0, %41 ], [ %2129, %2123 ]
  %exitcond1546.not = icmp eq i64 %.0, 8
  br i1 %exitcond1546.not, label %2130, label %2123

2123:                                             ; preds = %2122
  %2124 = getelementptr inbounds nuw [8 x i64], ptr %42, i64 0, i64 %.0
  %2125 = getelementptr inbounds nuw [8 x i64], ptr %3, i64 0, i64 %.0
  %2126 = load i64, ptr %2125, align 8
  %2127 = load i64, ptr %2124, align 8
  %2128 = add i64 %2127, %2126
  store i64 %2128, ptr %2124, align 8
  %2129 = add nuw nsw i64 %.0, 1
  br label %2122

2130:                                             ; preds = %2122
  ret void
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: write)
declare void @llvm.assume(i1 noundef) #14

; Function Attrs: mustprogress nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i64 @llvm.bswap.i64(i64) #15

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(argmem: readwrite) uwtable
define internal fastcc void @Scalar.fromBytes(ptr noalias nocapture nonnull writeonly sret(%Scalar) %0, ptr nocapture nonnull readonly align 1 %1) unnamed_addr #13 {
  %3 = alloca [10 x i64], align 8
  %4 = alloca [32 x i8], align 1
  call void @llvm.lifetime.start.p0(i64 80, ptr nonnull %3)
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %4)
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(32) %4, ptr noundef nonnull readonly align 1 dereferenceable(32) %1, i64 32, i1 false), !noalias !19
  br label %5

5:                                                ; preds = %6, %2
  %.0.i = phi i64 [ 0, %2 ], [ %12, %6 ]
  %exitcond.not.i = icmp eq i64 %.0.i, 4
  br i1 %exitcond.not.i, label %ScalarDouble.fromBytes32.exit, label %6

6:                                                ; preds = %5
  %7 = getelementptr inbounds nuw [10 x i64], ptr %3, i64 0, i64 %.0.i
  %8 = mul nuw nsw i64 %.0.i, 7
  %9 = getelementptr inbounds nuw i8, ptr %4, i64 %8
  %10 = load i64, ptr %9, align 1, !noalias !19
  %11 = and i64 %10, 72057594037927935
  store i64 %11, ptr %7, align 8, !noalias !19
  %12 = add nuw nsw i64 %.0.i, 1
  br label %5

ScalarDouble.fromBytes32.exit:         ; preds = %5
  %13 = getelementptr inbounds nuw i8, ptr %4, i64 28
  %14 = load i32, ptr %13, align 1, !noalias !19
  %15 = zext i32 %14 to i64
  %.sroa.01.0.copyload = load i64, ptr %3, align 8
  %.sroa.22.0..sroa_idx = getelementptr inbounds nuw i8, ptr %3, i64 8
  %.sroa.22.0.copyload = load i64, ptr %.sroa.22.0..sroa_idx, align 8
  %.sroa.33.0..sroa_idx = getelementptr inbounds nuw i8, ptr %3, i64 16
  %.sroa.33.0.copyload = load i64, ptr %.sroa.33.0..sroa_idx, align 8
  %.sroa.44.0..sroa_idx = getelementptr inbounds nuw i8, ptr %3, i64 24
  %.sroa.44.0.copyload = load i64, ptr %.sroa.44.0..sroa_idx, align 8
  call void @llvm.lifetime.end.p0(i64 80, ptr nonnull %3)
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %4)
  %16 = lshr i64 %15, 24
  %17 = zext nneg i64 %16 to i128
  %18 = mul nuw nsw i128 %17, 44162584779952923
  %19 = mul nuw nsw i128 %17, 9390964836247533
  %20 = mul nuw nsw i128 %17, 72057594036560134
  %21 = mul nuw nsw i128 %17, 72057594037927935
  %22 = mul nuw nsw i128 %17, 68719476735
  %23 = lshr i128 %18, 56
  %24 = add nuw nsw i128 %23, %19
  %25 = lshr i128 %24, 56
  %26 = add nuw nsw i128 %25, %20
  %27 = lshr i128 %26, 56
  %28 = add nuw nsw i128 %27, %21
  %29 = lshr i128 %28, 56
  %30 = add nuw nsw i128 %29, %22
  %31 = trunc nuw nsw i128 %30 to i64
  %32 = lshr i64 %31, 40
  %33 = zext nneg i64 %32 to i128
  %34 = mul nuw nsw i128 %33, 5175514460705773
  %35 = mul nuw nsw i128 %33, 70332060721272408
  %.neg = mul nuw nsw i128 %33, 18446744073709546274
  %36 = shl nuw nsw i64 %32, 28
  %37 = lshr i128 %34, 56
  %38 = trunc nuw nsw i128 %34 to i64
  %39 = and i64 %38, 72057594037927935
  %40 = add nuw nsw i128 %37, %35
  %41 = lshr i128 %40, 56
  %42 = trunc nuw nsw i128 %40 to i64
  %43 = and i64 %42, 72057594037927935
  %.neg18 = sub nsw i128 %.neg, %41
  %.neg19 = trunc i128 %.neg18 to i64
  %44 = and i64 %36, 1099243192320
  %45 = sub i64 %.sroa.01.0.copyload, %39
  %.neg17 = ashr i64 %45, 63
  %46 = lshr i64 %45, 7
  %47 = and i64 %46, 72057594037927936
  %48 = add i64 %47, %45
  %.neg13 = add i64 %.neg17, %.sroa.22.0.copyload
  %49 = sub i64 %.neg13, %43
  %.neg20 = ashr i64 %49, 63
  %50 = lshr i64 %49, 7
  %51 = and i64 %50, 72057594037927936
  %52 = add i64 %51, %49
  %.neg16 = add i64 %.sroa.33.0.copyload, %.neg19
  %53 = add i64 %.neg16, %.neg20
  %.neg.i = ashr i64 %53, 63
  %54 = lshr i64 %53, 63
  %55 = shl nuw nsw i64 %54, 56
  %56 = add i64 %55, %53
  %57 = sub i64 %.sroa.44.0.copyload, %54
  %58 = lshr i64 %57, 63
  %59 = shl nuw nsw i64 %58, 56
  %60 = add i64 %.neg.i, %.sroa.44.0.copyload
  %61 = add i64 %60, %59
  %62 = or disjoint i64 %58, %44
  %63 = icmp samesign ugt i64 %62, %15
  %64 = select i1 %63, i64 1099511627776, i64 0
  %65 = or disjoint i64 %64, %15
  %66 = sub nsw i64 %65, %62
  %67 = add i64 %48, -5175514460705773
  %68 = lshr i64 %67, 63
  %69 = shl nuw nsw i64 %68, 56
  %70 = add i64 %69, %67
  %71 = or disjoint i64 %68, 70332060721272408
  %72 = sub i64 %52, %71
  %73 = lshr i64 %72, 63
  %74 = shl nuw nsw i64 %73, 56
  %75 = add i64 %74, %72
  %76 = or disjoint i64 %73, 5342
  %77 = sub i64 %56, %76
  %.neg13.i = ashr i64 %77, 63
  %78 = lshr i64 %77, 63
  %79 = shl nuw nsw i64 %78, 56
  %80 = add i64 %79, %77
  %81 = sub i64 %61, %78
  %82 = lshr i64 %81, 63
  %83 = shl nuw nsw i64 %82, 56
  %84 = add i64 %.neg13.i, %61
  %85 = add i64 %84, %83
  %86 = or disjoint i64 %82, 268435456
  %.not.i = icmp slt i64 %66, %86
  %87 = select i1 %.not.i, i64 %48, i64 %70
  %88 = select i1 %.not.i, i64 %52, i64 %75
  %89 = select i1 %.not.i, i64 %56, i64 %80
  %90 = select i1 %.not.i, i64 %61, i64 %85
  %91 = select i1 %.not.i, i64 0, i64 %86
  %92 = sub nsw i64 %66, %91
  store i64 %87, ptr %0, align 8
  %.sroa.28.0..sroa_idx = getelementptr inbounds nuw i8, ptr %0, i64 8
  store i64 %88, ptr %.sroa.28.0..sroa_idx, align 8
  %.sroa.39.0..sroa_idx = getelementptr inbounds nuw i8, ptr %0, i64 16
  store i64 %89, ptr %.sroa.39.0..sroa_idx, align 8
  %.sroa.410.0..sroa_idx = getelementptr inbounds nuw i8, ptr %0, i64 24
  store i64 %90, ptr %.sroa.410.0..sroa_idx, align 8
  %.sroa.511.0..sroa_idx = getelementptr inbounds nuw i8, ptr %0, i64 32
  store i64 %92, ptr %.sroa.511.0..sroa_idx, align 8
  ret void
}

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(argmem: readwrite) uwtable
define internal fastcc void @Scalar.add(ptr noalias nocapture nonnull writeonly sret(%Scalar) initializes((0, 40)) %0, ptr nocapture nonnull readonly align 8 %1, ptr nocapture nonnull readonly align 8 %2) unnamed_addr #9 {
  %4 = load i64, ptr %1, align 8
  %5 = load i64, ptr %2, align 8
  %6 = add nuw i64 %5, %4
  %7 = lshr i64 %6, 56
  %8 = and i64 %6, 72057594037927935
  %9 = getelementptr inbounds nuw i8, ptr %1, i64 8
  %10 = load i64, ptr %9, align 8
  %11 = getelementptr inbounds nuw i8, ptr %2, i64 8
  %12 = load i64, ptr %11, align 8
  %13 = add nuw i64 %12, %10
  %14 = add nuw i64 %13, %7
  %15 = lshr i64 %14, 56
  %16 = and i64 %14, 72057594037927935
  %17 = getelementptr inbounds nuw i8, ptr %1, i64 16
  %18 = load i64, ptr %17, align 8
  %19 = getelementptr inbounds nuw i8, ptr %2, i64 16
  %20 = load i64, ptr %19, align 8
  %21 = add nuw i64 %20, %18
  %22 = add nuw i64 %21, %15
  %23 = lshr i64 %22, 56
  %24 = and i64 %22, 72057594037927935
  %25 = getelementptr inbounds nuw i8, ptr %1, i64 24
  %26 = load i64, ptr %25, align 8
  %27 = getelementptr inbounds nuw i8, ptr %2, i64 24
  %28 = load i64, ptr %27, align 8
  %29 = add nuw i64 %28, %26
  %30 = add nuw i64 %29, %23
  %31 = lshr i64 %30, 56
  %32 = and i64 %30, 72057594037927935
  %33 = getelementptr inbounds nuw i8, ptr %1, i64 32
  %34 = load i64, ptr %33, align 8
  %35 = getelementptr inbounds nuw i8, ptr %2, i64 32
  %36 = load i64, ptr %35, align 8
  %37 = add nuw i64 %36, %34
  %38 = add nuw i64 %37, %31
  %39 = add nsw i64 %8, -5175514460705773
  %40 = lshr i64 %39, 63
  %41 = shl nuw nsw i64 %40, 56
  %42 = add nsw i64 %39, %41
  %43 = or disjoint i64 %40, 70332060721272408
  %44 = icmp samesign ult i64 %16, %43
  %45 = select i1 %44, i64 72057594037927936, i64 0
  %46 = sub nsw i64 %16, %43
  %47 = add nsw i64 %46, %45
  %.neg = select i1 %44, i64 -5343, i64 -5342
  %48 = select i1 %44, i64 5343, i64 5342
  %49 = icmp samesign ult i64 %24, %48
  %.neg9 = sext i1 %49 to i64
  %50 = select i1 %49, i64 72057594037927936, i64 0
  %51 = add nsw i64 %.neg, %24
  %52 = add nsw i64 %51, %50
  %53 = icmp eq i64 %32, 0
  %54 = and i1 %53, %49
  %55 = select i1 %54, i64 72057594037927936, i64 0
  %56 = add nsw i64 %32, %.neg9
  %57 = add nsw i64 %56, %55
  %.neg10 = select i1 %54, i64 -268435457, i64 -268435456
  %58 = add i64 %.neg10, %38
  %59 = lshr i64 %58, 63
  %60 = shl nuw nsw i64 %59, 56
  %61 = add i64 %58, %60
  %62 = add nsw i64 %59, -1
  %63 = xor i64 %42, %8
  %64 = and i64 %62, %63
  %65 = xor i64 %64, %8
  %66 = xor i64 %47, %16
  %67 = and i64 %62, %66
  %68 = xor i64 %67, %16
  %69 = xor i64 %52, %24
  %70 = and i64 %62, %69
  %71 = xor i64 %70, %24
  %72 = xor i64 %57, %32
  %73 = and i64 %62, %72
  %74 = xor i64 %73, %32
  %75 = xor i64 %61, %38
  %76 = and i64 %75, %62
  %77 = xor i64 %76, %38
  store i64 %65, ptr %0, align 8
  %.sroa.22.0..sroa_idx = getelementptr inbounds nuw i8, ptr %0, i64 8
  store i64 %68, ptr %.sroa.22.0..sroa_idx, align 8
  %.sroa.33.0..sroa_idx = getelementptr inbounds nuw i8, ptr %0, i64 16
  store i64 %71, ptr %.sroa.33.0..sroa_idx, align 8
  %.sroa.44.0..sroa_idx = getelementptr inbounds nuw i8, ptr %0, i64 24
  store i64 %74, ptr %.sroa.44.0..sroa_idx, align 8
  %.sroa.55.0..sroa_idx = getelementptr inbounds nuw i8, ptr %0, i64 32
  store i64 %77, ptr %.sroa.55.0..sroa_idx, align 8
  ret void
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(argmem: readwrite, inaccessiblemem: write) uwtable
define internal fastcc void @Scalar.toBytes(ptr noalias nocapture nonnull writeonly sret([32 x i8]) %0, ptr nocapture nonnull readonly align 8 %1) unnamed_addr #4 {
  %3 = alloca [32 x i8], align 1
  br label %4

4:                                                ; preds = %5, %2
  %.0 = phi i64 [ 0, %2 ], [ %10, %5 ]
  %exitcond.not = icmp eq i64 %.0, 4
  br i1 %exitcond.not, label %11, label %5

5:                                                ; preds = %4
  %6 = mul nuw nsw i64 %.0, 7
  %7 = getelementptr inbounds nuw i8, ptr %3, i64 %6
  %8 = getelementptr inbounds nuw [5 x i64], ptr %1, i64 0, i64 %.0
  %9 = load i64, ptr %8, align 8
  store i64 %9, ptr %7, align 1
  %10 = add nuw nsw i64 %.0, 1
  br label %4

11:                                               ; preds = %4
  %12 = getelementptr inbounds nuw i8, ptr %3, i64 28
  %13 = getelementptr inbounds nuw i8, ptr %1, i64 32
  %14 = load i64, ptr %13, align 8
  %15 = icmp ult i64 %14, 4294967296
  tail call void @llvm.assume(i1 %15)
  %16 = trunc nuw i64 %14 to i32
  store i32 %16, ptr %12, align 1
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(32) %0, ptr noundef nonnull align 1 dereferenceable(32) %3, i64 32, i1 false)
  ret void
}

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(argmem: readwrite, inaccessiblemem: readwrite) uwtable
define internal fastcc void @Edwards25519.dbl(ptr noalias nocapture nonnull writeonly sret(%Edwards25519) initializes((0, 161)) %0, ptr nocapture nonnull readonly align 8 %1) unnamed_addr #8 {
  %3 = alloca [5 x i128], align 16
  %4 = alloca %Fe, align 8
  %5 = alloca %Fe, align 8
  %6 = alloca %Fe, align 8
  %7 = alloca %Fe, align 8
  %8 = alloca %Fe, align 8
  %9 = alloca %Fe, align 8
  %10 = alloca %Fe, align 8
  %11 = alloca %Fe, align 8
  %12 = alloca %Fe, align 8
  %13 = alloca %Fe, align 8
  %14 = alloca %Fe, align 8
  %15 = alloca %Fe, align 8
  %16 = alloca %Edwards25519, align 8
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(168) %16, ptr noundef nonnull align 8 dereferenceable(168) %1, i64 168, i1 false)
  %17 = getelementptr inbounds nuw i8, ptr %1, i64 40
  call fastcc void @Fe.add(ptr sret(%Fe) %15, ptr nonnull readonly align 8 %1, ptr nonnull readonly align 8 %17)
  call fastcc void @Fe.sq(ptr sret(%Fe) %14, ptr nonnull readonly align 8 %15)
  call fastcc void @Fe.sq(ptr sret(%Fe) %13, ptr nonnull readonly align 8 %1)
  %18 = getelementptr inbounds nuw i8, ptr %16, i64 40
  call fastcc void @Fe.sq(ptr sret(%Fe) %12, ptr nonnull readonly align 8 %18)
  tail call void @llvm.experimental.noalias.scope.decl(metadata !22)
  %19 = load i64, ptr %12, align 8, !noalias !22
  %20 = load i64, ptr %13, align 8, !noalias !22
  %21 = add nuw i64 %20, %19
  %22 = getelementptr inbounds nuw i8, ptr %12, i64 8
  %23 = load i64, ptr %22, align 8, !noalias !22
  %24 = getelementptr inbounds nuw i8, ptr %13, i64 8
  %25 = load i64, ptr %24, align 8, !noalias !22
  %26 = add nuw i64 %25, %23
  %27 = getelementptr inbounds nuw i8, ptr %12, i64 16
  %28 = load i64, ptr %27, align 8, !noalias !22
  %29 = getelementptr inbounds nuw i8, ptr %13, i64 16
  %30 = load i64, ptr %29, align 8, !noalias !22
  %31 = add nuw i64 %30, %28
  %32 = getelementptr inbounds nuw i8, ptr %12, i64 24
  %33 = load i64, ptr %32, align 8, !noalias !22
  %34 = getelementptr inbounds nuw i8, ptr %13, i64 24
  %35 = load i64, ptr %34, align 8, !noalias !22
  %36 = add nuw i64 %35, %33
  %37 = getelementptr inbounds nuw i8, ptr %12, i64 32
  %38 = load i64, ptr %37, align 8, !noalias !22
  %39 = getelementptr inbounds nuw i8, ptr %13, i64 32
  %40 = load i64, ptr %39, align 8, !noalias !22
  %41 = add nuw i64 %40, %38
  store i64 %21, ptr %11, align 8, !alias.scope !22
  %.sroa.3.0..sroa_idx.i = getelementptr inbounds nuw i8, ptr %11, i64 8
  store i64 %26, ptr %.sroa.3.0..sroa_idx.i, align 8, !alias.scope !22
  %.sroa.4.0..sroa_idx.i = getelementptr inbounds nuw i8, ptr %11, i64 16
  store i64 %31, ptr %.sroa.4.0..sroa_idx.i, align 8, !alias.scope !22
  %.sroa.5.0..sroa_idx.i = getelementptr inbounds nuw i8, ptr %11, i64 24
  store i64 %36, ptr %.sroa.5.0..sroa_idx.i, align 8, !alias.scope !22
  %.sroa.6.0..sroa_idx.i = getelementptr inbounds nuw i8, ptr %11, i64 32
  store i64 %41, ptr %.sroa.6.0..sroa_idx.i, align 8, !alias.scope !22
  call fastcc void @Fe.sub(ptr sret(%Fe) %10, ptr nonnull readonly align 8 %12, ptr nonnull readonly align 8 %13)
  call fastcc void @Fe.sub(ptr sret(%Fe) %13, ptr nonnull readonly align 8 %14, ptr nonnull readonly align 8 %11)
  %42 = getelementptr inbounds nuw i8, ptr %16, i64 80
  call void @llvm.lifetime.start.p0(i64 80, ptr nonnull %3), !noalias !25
  %43 = load i64, ptr %42, align 8, !noalias !28
  %44 = zext i64 %43 to i128
  %45 = getelementptr inbounds nuw i8, ptr %16, i64 88
  %46 = load i64, ptr %45, align 8, !noalias !28
  %47 = zext i64 %46 to i128
  %48 = getelementptr inbounds nuw i8, ptr %16, i64 96
  %49 = load i64, ptr %48, align 8, !noalias !28
  %50 = zext i64 %49 to i128
  %51 = getelementptr inbounds nuw i8, ptr %16, i64 104
  %52 = load i64, ptr %51, align 8, !noalias !28
  %53 = zext i64 %52 to i128
  %54 = getelementptr inbounds nuw i8, ptr %16, i64 112
  %55 = load i64, ptr %54, align 8, !noalias !28
  %56 = zext i64 %55 to i128
  %57 = shl nuw nsw i128 %44, 1
  %58 = shl nuw nsw i128 %47, 1
  %59 = mul nuw nsw i128 %50, 38
  %60 = mul nuw nsw i128 %53, 19
  %61 = mul nuw nsw i128 %56, 19
  %62 = mul nuw i128 %44, %44
  %63 = mul nuw nsw i128 %56, 38
  %64 = mul i128 %63, %47
  %65 = mul nuw i128 %59, %53
  %66 = add nuw i128 %65, %62
  %67 = add nuw i128 %66, %64
  %68 = getelementptr inbounds nuw i8, ptr %3, i64 16
  %69 = mul nuw i128 %57, %47
  %70 = mul nuw i128 %59, %56
  %71 = add nuw i128 %70, %69
  %72 = mul nuw i128 %60, %53
  %73 = add nuw i128 %71, %72
  %74 = getelementptr inbounds nuw i8, ptr %3, i64 32
  %75 = mul nuw i128 %57, %50
  %76 = mul nuw i128 %47, %47
  %77 = add nuw i128 %75, %76
  %78 = mul i128 %63, %53
  %79 = add nuw i128 %77, %78
  %80 = getelementptr inbounds nuw i8, ptr %3, i64 48
  %81 = mul nuw i128 %57, %53
  %82 = mul nuw i128 %58, %50
  %83 = add nuw i128 %81, %82
  %84 = mul nuw i128 %61, %56
  %85 = add nuw i128 %83, %84
  %86 = getelementptr inbounds nuw i8, ptr %3, i64 64
  %87 = mul nuw i128 %57, %56
  %88 = mul nuw i128 %58, %53
  %89 = mul nuw i128 %50, %50
  %90 = add nuw i128 %88, %89
  %91 = add nuw i128 %90, %87
  %92 = shl nuw i128 %67, 1
  store i128 %92, ptr %3, align 16, !noalias !28
  %93 = shl nuw i128 %73, 1
  store i128 %93, ptr %68, align 16, !noalias !28
  %94 = shl nuw i128 %79, 1
  store i128 %94, ptr %74, align 16, !noalias !28
  %95 = shl nuw i128 %85, 1
  store i128 %95, ptr %80, align 16, !noalias !28
  %96 = shl nuw i128 %91, 1
  store i128 %96, ptr %86, align 16, !noalias !28
  call fastcc void @Fe.carry128(ptr sret(%Fe) %9, ptr nonnull align 16 %3)
  call void @llvm.lifetime.end.p0(i64 80, ptr nonnull %3), !noalias !25
  call fastcc void @Fe.sub(ptr sret(%Fe) %8, ptr nonnull readonly align 8 %9, ptr nonnull readonly align 8 %10)
  call fastcc void @Fe.mul(ptr sret(%Fe) %7, ptr nonnull readonly align 8 %13, ptr nonnull readonly align 8 %8)
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(40) %0, ptr noundef nonnull align 8 dereferenceable(40) %7, i64 40, i1 false)
  %97 = getelementptr inbounds nuw i8, ptr %0, i64 40
  call fastcc void @Fe.mul(ptr sret(%Fe) %6, ptr nonnull readonly align 8 %11, ptr nonnull readonly align 8 %10)
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(40) %97, ptr noundef nonnull align 8 dereferenceable(40) %6, i64 40, i1 false)
  %98 = getelementptr inbounds nuw i8, ptr %0, i64 80
  call fastcc void @Fe.mul(ptr sret(%Fe) %5, ptr nonnull readonly align 8 %10, ptr nonnull readonly align 8 %8)
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(40) %98, ptr noundef nonnull align 8 dereferenceable(40) %5, i64 40, i1 false)
  %99 = getelementptr inbounds nuw i8, ptr %0, i64 120
  call fastcc void @Fe.mul(ptr sret(%Fe) %4, ptr nonnull readonly align 8 %13, ptr nonnull readonly align 8 %11)
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(40) %99, ptr noundef nonnull align 8 dereferenceable(40) %4, i64 40, i1 false)
  %100 = getelementptr inbounds nuw i8, ptr %0, i64 160
  store i1 false, ptr %100, align 8
  ret void
}

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(argmem: readwrite) uwtable
define internal fastcc void @Fe.neg(ptr noalias nocapture nonnull writeonly sret(%Fe) initializes((0, 40)) %0, ptr nocapture nonnull readonly align 8 %1) unnamed_addr #9 {
  %3 = alloca %Fe, align 8
  call fastcc void @Fe.sub(ptr sret(%Fe) %3, ptr nonnull readonly align 8 @Fe.zero, ptr nonnull readonly align 8 %1)
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(40) %0, ptr noundef nonnull align 8 dereferenceable(40) %3, i64 40, i1 false)
  ret void
}

; Function Attrs: minsize nofree noinline norecurse nosync nounwind optsize memory(argmem: readwrite, inaccessiblemem: readwrite) uwtable
define internal fastcc void @Edwards25519.precompute(ptr noalias nocapture nonnull writeonly sret([9 x %Edwards25519]) %0, ptr nocapture nonnull readonly align 8 %1) unnamed_addr #3 {
  %3 = alloca %Edwards25519, align 8
  %4 = alloca %Edwards25519, align 8
  %5 = alloca [9 x %Edwards25519], align 8
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(168) %5, ptr noundef nonnull align 8 dereferenceable(168) @Edwards25519.identityElement, i64 168, i1 false)
  %6 = getelementptr inbounds nuw i8, ptr %5, i64 168
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(168) %6, ptr noundef nonnull align 8 dereferenceable(168) %1, i64 168, i1 false)
  br label %7

7:                                                ; preds = %13, %2
  %.0 = phi i64 [ 2, %2 ], [ %15, %13 ]
  %exitcond.not = icmp eq i64 %.0, 9
  br i1 %exitcond.not, label %12, label %8

8:                                                ; preds = %7
  %9 = getelementptr inbounds nuw [9 x %Edwards25519], ptr %5, i64 0, i64 %.0
  %10 = and i64 %.0, 1
  %11 = icmp eq i64 %10, 0
  br i1 %11, label %16, label %19

12:                                               ; preds = %7
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(1512) %0, ptr noundef nonnull align 8 dereferenceable(1512) %5, i64 1512, i1 false)
  ret void

13:                                               ; preds = %19, %16
  %14 = phi ptr [ %4, %16 ], [ %3, %19 ]
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(168) %9, ptr noundef nonnull align 8 dereferenceable(168) %14, i64 168, i1 false)
  %15 = add nuw nsw i64 %.0, 1
  br label %7

16:                                               ; preds = %8
  %17 = lshr exact i64 %.0, 1
  %18 = getelementptr inbounds nuw [9 x %Edwards25519], ptr %5, i64 0, i64 %17
  call fastcc void @Edwards25519.dbl(ptr sret(%Edwards25519) %4, ptr nonnull readonly align 8 %18)
  br label %13

19:                                               ; preds = %8
  %20 = add nsw i64 %.0, -1
  %21 = getelementptr inbounds nuw [9 x %Edwards25519], ptr %5, i64 0, i64 %20
  call fastcc void @Edwards25519.add(ptr sret(%Edwards25519) %3, ptr nonnull readonly align 8 %21, ptr nonnull readonly align 8 %1)
  br label %13
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(read, argmem: readwrite, inaccessiblemem: write) uwtable
define internal fastcc void @Edwards25519.slide(ptr noalias nocapture nonnull writeonly sret([64 x i8]) %0, ptr nocapture nonnull readonly align 1 %1) unnamed_addr #16 {
  %3 = alloca %Scalar, align 8
  %4 = alloca [64 x i8], align 1
  %5 = alloca [32 x i8], align 1
  %6 = getelementptr inbounds nuw i8, ptr %1, i64 31
  %7 = load i8, ptr %6, align 1
  %8 = icmp sgt i8 %7, -1
  br i1 %8, label %9, label %11

9:                                                ; preds = %2, %11
  %10 = phi ptr [ %5, %11 ], [ %1, %2 ]
  br label %12

11:                                               ; preds = %2
  call void @llvm.lifetime.start.p0(i64 40, ptr nonnull %3)
  call fastcc void @Scalar.fromBytes(ptr sret(%Scalar) %3, ptr nonnull readonly align 1 %1), !noalias !31
  call fastcc void @Scalar.toBytes(ptr sret([32 x i8]) %5, ptr nonnull readonly align 8 %3)
  call void @llvm.lifetime.end.p0(i64 40, ptr nonnull %3)
  br label %9

12:                                               ; preds = %13, %9
  %.0 = phi i64 [ 0, %9 ], [ %22, %13 ]
  %exitcond.not = icmp eq i64 %.0, 32
  br i1 %exitcond.not, label %.preheader, label %13

13:                                               ; preds = %12
  %14 = getelementptr inbounds nuw [32 x i8], ptr %10, i64 0, i64 %.0
  %15 = load i8, ptr %14, align 1
  %16 = shl nuw nsw i64 %.0, 1
  %17 = getelementptr inbounds nuw [64 x i8], ptr %4, i64 0, i64 %16
  %18 = and i8 %15, 15
  store i8 %18, ptr %17, align 1
  %19 = or disjoint i64 %16, 1
  %20 = getelementptr inbounds nuw [64 x i8], ptr %4, i64 0, i64 %19
  %21 = lshr i8 %15, 4
  store i8 %21, ptr %20, align 1
  %22 = add nuw nsw i64 %.0, 1
  br label %12

.preheader:                                       ; preds = %12, %23
  %.06 = phi i64 [ %31, %23 ], [ 0, %12 ]
  %.05 = phi i8 [ %28, %23 ], [ 0, %12 ]
  %exitcond7.not = icmp eq i64 %.06, 63
  br i1 %exitcond7.not, label %32, label %23

23:                                               ; preds = %.preheader
  %24 = getelementptr inbounds nuw [63 x i8], ptr %4, i64 0, i64 %.06
  %25 = load i8, ptr %24, align 1
  %26 = add nsw i8 %25, %.05
  %27 = add nsw i8 %26, 8
  %28 = ashr i8 %27, 4
  %29 = and i8 %27, -16
  %30 = sub nsw i8 %26, %29
  store i8 %30, ptr %24, align 1
  %31 = add nuw nsw i64 %.06, 1
  br label %.preheader

32:                                               ; preds = %.preheader
  %33 = getelementptr inbounds nuw i8, ptr %4, i64 63
  %34 = load i8, ptr %33, align 1
  %35 = add nsw i8 %34, %.05
  store i8 %35, ptr %33, align 1
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(64) %0, ptr noundef nonnull align 1 dereferenceable(64) %4, i64 64, i1 false)
  ret void
}

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(argmem: readwrite, inaccessiblemem: readwrite) uwtable
define internal fastcc void @Edwards25519.add(ptr noalias nocapture nonnull writeonly sret(%Edwards25519) initializes((0, 161)) %0, ptr nocapture nonnull readonly align 8 %1, ptr nocapture nonnull readonly align 8 %2) unnamed_addr #8 {
  %4 = alloca %Fe, align 8
  %5 = alloca %Fe, align 8
  %6 = alloca %Fe, align 8
  %7 = alloca %Fe, align 8
  %8 = alloca %Fe, align 8
  %9 = alloca %Fe, align 8
  %10 = alloca %Fe, align 8
  %11 = alloca %Fe, align 8
  %12 = alloca %Fe, align 8
  %13 = alloca %Fe, align 8
  %14 = alloca %Fe, align 8
  %15 = alloca %Fe, align 8
  %16 = alloca %Fe, align 8
  %17 = alloca %Fe, align 8
  %18 = alloca %Fe, align 8
  %19 = alloca %Fe, align 8
  %20 = alloca %Fe, align 8
  %21 = alloca %Edwards25519, align 8
  %22 = alloca %Edwards25519, align 8
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(168) %22, ptr noundef nonnull align 8 dereferenceable(168) %1, i64 168, i1 false)
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(168) %21, ptr noundef nonnull align 8 dereferenceable(168) %2, i64 168, i1 false)
  %23 = getelementptr inbounds nuw i8, ptr %22, i64 40
  call fastcc void @Fe.sub(ptr sret(%Fe) %20, ptr nonnull readonly align 8 %23, ptr nonnull readonly align 8 %1)
  %24 = getelementptr inbounds nuw i8, ptr %21, i64 40
  call fastcc void @Fe.sub(ptr sret(%Fe) %19, ptr nonnull readonly align 8 %24, ptr nonnull readonly align 8 %2)
  call fastcc void @Fe.mul(ptr sret(%Fe) %18, ptr nonnull readonly align 8 %20, ptr nonnull readonly align 8 %19)
  %25 = getelementptr inbounds nuw i8, ptr %1, i64 40
  call fastcc void @Fe.add(ptr sret(%Fe) %17, ptr nonnull readonly align 8 %1, ptr nonnull readonly align 8 %25)
  %26 = getelementptr inbounds nuw i8, ptr %2, i64 40
  call fastcc void @Fe.add(ptr sret(%Fe) %16, ptr nonnull readonly align 8 %2, ptr nonnull readonly align 8 %26)
  call fastcc void @Fe.mul(ptr sret(%Fe) %15, ptr nonnull readonly align 8 %17, ptr nonnull readonly align 8 %16)
  %27 = getelementptr inbounds nuw i8, ptr %22, i64 120
  %28 = getelementptr inbounds nuw i8, ptr %2, i64 120
  call fastcc void @Fe.mul(ptr sret(%Fe) %14, ptr nonnull readonly align 8 %27, ptr nonnull readonly align 8 %28)
  call fastcc void @Fe.mul(ptr sret(%Fe) %13, ptr nonnull readonly align 8 %14, ptr nonnull readonly align 8 @Fe.edwards25519d2)
  %29 = getelementptr inbounds nuw i8, ptr %22, i64 80
  %30 = getelementptr inbounds nuw i8, ptr %2, i64 80
  call fastcc void @Fe.mul(ptr sret(%Fe) %12, ptr nonnull readonly align 8 %29, ptr nonnull readonly align 8 %30)
  %31 = load i64, ptr %12, align 8, !noalias !34
  %32 = shl nuw i64 %31, 1
  %33 = getelementptr inbounds nuw i8, ptr %12, i64 8
  %34 = load i64, ptr %33, align 8, !noalias !34
  %35 = shl nuw i64 %34, 1
  %36 = getelementptr inbounds nuw i8, ptr %12, i64 16
  %37 = load i64, ptr %36, align 8, !noalias !34
  %38 = shl nuw i64 %37, 1
  %39 = getelementptr inbounds nuw i8, ptr %12, i64 24
  %40 = load i64, ptr %39, align 8, !noalias !34
  %41 = shl nuw i64 %40, 1
  %42 = getelementptr inbounds nuw i8, ptr %12, i64 32
  %43 = load i64, ptr %42, align 8, !noalias !34
  %44 = shl nuw i64 %43, 1
  store i64 %32, ptr %12, align 8
  store i64 %35, ptr %33, align 8
  store i64 %38, ptr %36, align 8
  store i64 %41, ptr %39, align 8
  store i64 %44, ptr %42, align 8
  call fastcc void @Fe.sub(ptr sret(%Fe) %11, ptr nonnull readonly align 8 %15, ptr nonnull readonly align 8 %18)
  tail call void @llvm.experimental.noalias.scope.decl(metadata !37)
  %45 = load i64, ptr %15, align 8, !noalias !37
  %46 = load i64, ptr %18, align 8, !noalias !37
  %47 = add nuw i64 %46, %45
  %48 = getelementptr inbounds nuw i8, ptr %15, i64 8
  %49 = load i64, ptr %48, align 8, !noalias !37
  %50 = getelementptr inbounds nuw i8, ptr %18, i64 8
  %51 = load i64, ptr %50, align 8, !noalias !37
  %52 = add nuw i64 %51, %49
  %53 = getelementptr inbounds nuw i8, ptr %15, i64 16
  %54 = load i64, ptr %53, align 8, !noalias !37
  %55 = getelementptr inbounds nuw i8, ptr %18, i64 16
  %56 = load i64, ptr %55, align 8, !noalias !37
  %57 = add nuw i64 %56, %54
  %58 = getelementptr inbounds nuw i8, ptr %15, i64 24
  %59 = load i64, ptr %58, align 8, !noalias !37
  %60 = getelementptr inbounds nuw i8, ptr %18, i64 24
  %61 = load i64, ptr %60, align 8, !noalias !37
  %62 = add nuw i64 %61, %59
  %63 = getelementptr inbounds nuw i8, ptr %15, i64 32
  %64 = load i64, ptr %63, align 8, !noalias !37
  %65 = getelementptr inbounds nuw i8, ptr %18, i64 32
  %66 = load i64, ptr %65, align 8, !noalias !37
  %67 = add nuw i64 %66, %64
  store i64 %47, ptr %10, align 8, !alias.scope !37
  %.sroa.3.0..sroa_idx.i2 = getelementptr inbounds nuw i8, ptr %10, i64 8
  store i64 %52, ptr %.sroa.3.0..sroa_idx.i2, align 8, !alias.scope !37
  %.sroa.4.0..sroa_idx.i3 = getelementptr inbounds nuw i8, ptr %10, i64 16
  store i64 %57, ptr %.sroa.4.0..sroa_idx.i3, align 8, !alias.scope !37
  %.sroa.5.0..sroa_idx.i4 = getelementptr inbounds nuw i8, ptr %10, i64 24
  store i64 %62, ptr %.sroa.5.0..sroa_idx.i4, align 8, !alias.scope !37
  %.sroa.6.0..sroa_idx.i5 = getelementptr inbounds nuw i8, ptr %10, i64 32
  store i64 %67, ptr %.sroa.6.0..sroa_idx.i5, align 8, !alias.scope !37
  tail call void @llvm.experimental.noalias.scope.decl(metadata !40)
  %68 = load i64, ptr %13, align 8, !noalias !40
  %69 = add nuw i64 %68, %32
  %70 = getelementptr inbounds nuw i8, ptr %13, i64 8
  %71 = load i64, ptr %70, align 8, !noalias !40
  %72 = add nuw i64 %71, %35
  %73 = getelementptr inbounds nuw i8, ptr %13, i64 16
  %74 = load i64, ptr %73, align 8, !noalias !40
  %75 = add nuw i64 %74, %38
  %76 = getelementptr inbounds nuw i8, ptr %13, i64 24
  %77 = load i64, ptr %76, align 8, !noalias !40
  %78 = add nuw i64 %77, %41
  %79 = getelementptr inbounds nuw i8, ptr %13, i64 32
  %80 = load i64, ptr %79, align 8, !noalias !40
  %81 = add nuw i64 %80, %44
  store i64 %69, ptr %9, align 8, !alias.scope !40
  %.sroa.3.0..sroa_idx.i6 = getelementptr inbounds nuw i8, ptr %9, i64 8
  store i64 %72, ptr %.sroa.3.0..sroa_idx.i6, align 8, !alias.scope !40
  %.sroa.4.0..sroa_idx.i7 = getelementptr inbounds nuw i8, ptr %9, i64 16
  store i64 %75, ptr %.sroa.4.0..sroa_idx.i7, align 8, !alias.scope !40
  %.sroa.5.0..sroa_idx.i8 = getelementptr inbounds nuw i8, ptr %9, i64 24
  store i64 %78, ptr %.sroa.5.0..sroa_idx.i8, align 8, !alias.scope !40
  %.sroa.6.0..sroa_idx.i9 = getelementptr inbounds nuw i8, ptr %9, i64 32
  store i64 %81, ptr %.sroa.6.0..sroa_idx.i9, align 8, !alias.scope !40
  call fastcc void @Fe.sub(ptr sret(%Fe) %8, ptr nonnull readonly align 8 %12, ptr nonnull readonly align 8 %13)
  call fastcc void @Fe.mul(ptr sret(%Fe) %7, ptr nonnull readonly align 8 %11, ptr nonnull readonly align 8 %8)
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(40) %0, ptr noundef nonnull align 8 dereferenceable(40) %7, i64 40, i1 false)
  %82 = getelementptr inbounds nuw i8, ptr %0, i64 40
  call fastcc void @Fe.mul(ptr sret(%Fe) %6, ptr nonnull readonly align 8 %10, ptr nonnull readonly align 8 %9)
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(40) %82, ptr noundef nonnull align 8 dereferenceable(40) %6, i64 40, i1 false)
  %83 = getelementptr inbounds nuw i8, ptr %0, i64 80
  call fastcc void @Fe.mul(ptr sret(%Fe) %5, ptr nonnull readonly align 8 %9, ptr nonnull readonly align 8 %8)
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(40) %83, ptr noundef nonnull align 8 dereferenceable(40) %5, i64 40, i1 false)
  %84 = getelementptr inbounds nuw i8, ptr %0, i64 120
  call fastcc void @Fe.mul(ptr sret(%Fe) %4, ptr nonnull readonly align 8 %11, ptr nonnull readonly align 8 %10)
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(40) %84, ptr noundef nonnull align 8 dereferenceable(40) %4, i64 40, i1 false)
  %85 = getelementptr inbounds nuw i8, ptr %0, i64 160
  store i1 false, ptr %85, align 8
  ret void
}

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(argmem: readwrite) uwtable
define internal fastcc i1 @Fe.isZero(ptr nocapture nonnull readonly align 8 %0) unnamed_addr #9 {
  %2 = alloca %Fe, align 8
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(40) %2, ptr noundef nonnull align 8 dereferenceable(40) %0, i64 40, i1 false)
  call fastcc void @Fe.reduce(ptr nonnull align 8 %2)
  %3 = load i64, ptr %2, align 8
  %4 = getelementptr inbounds nuw i8, ptr %2, i64 8
  %5 = load i64, ptr %4, align 8
  %6 = or i64 %5, %3
  %7 = getelementptr inbounds nuw i8, ptr %2, i64 16
  %8 = load i64, ptr %7, align 8
  %9 = or i64 %6, %8
  %10 = getelementptr inbounds nuw i8, ptr %2, i64 24
  %11 = load i64, ptr %10, align 8
  %12 = or i64 %9, %11
  %13 = getelementptr inbounds nuw i8, ptr %2, i64 32
  %14 = load i64, ptr %13, align 8
  %15 = or i64 %12, %14
  %16 = icmp eq i64 %15, 0
  ret i1 %16
}

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(argmem: readwrite, inaccessiblemem: write) uwtable
define internal fastcc void @Fe.sq(ptr noalias nocapture nonnull writeonly sret(%Fe) initializes((0, 40)) %0, ptr nocapture nonnull readonly align 8 %1) unnamed_addr #17 {
  %3 = alloca [5 x i128], align 16
  %.sroa.0 = alloca [5 x i64], align 8
  call void @llvm.lifetime.start.p0(i64 80, ptr nonnull %3)
  %4 = load i64, ptr %1, align 8, !noalias !43
  %5 = zext i64 %4 to i128
  %6 = getelementptr inbounds nuw i8, ptr %1, i64 8
  %7 = load i64, ptr %6, align 8, !noalias !43
  %8 = zext i64 %7 to i128
  %9 = getelementptr inbounds nuw i8, ptr %1, i64 16
  %10 = load i64, ptr %9, align 8, !noalias !43
  %11 = zext i64 %10 to i128
  %12 = getelementptr inbounds nuw i8, ptr %1, i64 24
  %13 = load i64, ptr %12, align 8, !noalias !43
  %14 = zext i64 %13 to i128
  %15 = getelementptr inbounds nuw i8, ptr %1, i64 32
  %16 = load i64, ptr %15, align 8, !noalias !43
  %17 = zext i64 %16 to i128
  %18 = shl nuw nsw i128 %5, 1
  %19 = shl nuw nsw i128 %8, 1
  %20 = mul nuw nsw i128 %11, 38
  %21 = mul nuw nsw i128 %14, 19
  %22 = mul nuw nsw i128 %17, 19
  %23 = mul nuw i128 %5, %5
  %24 = mul nuw nsw i128 %17, 38
  %25 = mul i128 %24, %8
  %26 = mul nuw i128 %20, %14
  %27 = add nuw i128 %26, %23
  %28 = add nuw i128 %27, %25
  store i128 %28, ptr %3, align 16, !noalias !43
  %29 = getelementptr inbounds nuw i8, ptr %3, i64 16
  %30 = mul nuw i128 %18, %8
  %31 = mul nuw i128 %20, %17
  %32 = add nuw i128 %31, %30
  %33 = mul nuw i128 %21, %14
  %34 = add nuw i128 %32, %33
  store i128 %34, ptr %29, align 16, !noalias !43
  %35 = getelementptr inbounds nuw i8, ptr %3, i64 32
  %36 = mul nuw i128 %18, %11
  %37 = mul nuw i128 %8, %8
  %38 = add nuw i128 %36, %37
  %39 = mul i128 %24, %14
  %40 = add nuw i128 %38, %39
  store i128 %40, ptr %35, align 16, !noalias !43
  %41 = getelementptr inbounds nuw i8, ptr %3, i64 48
  %42 = mul nuw i128 %18, %14
  %43 = mul nuw i128 %19, %11
  %44 = add nuw i128 %42, %43
  %45 = mul nuw i128 %22, %17
  %46 = add nuw i128 %44, %45
  store i128 %46, ptr %41, align 16, !noalias !43
  %47 = getelementptr inbounds nuw i8, ptr %3, i64 64
  %48 = mul nuw i128 %18, %17
  %49 = mul nuw i128 %19, %14
  %50 = mul nuw i128 %11, %11
  %51 = add nuw i128 %49, %50
  %52 = add nuw i128 %51, %48
  store i128 %52, ptr %47, align 16, !noalias !43
  call fastcc void @Fe.carry128(ptr sret(%Fe) %.sroa.0, ptr nonnull align 16 %3)
  call void @llvm.lifetime.end.p0(i64 80, ptr nonnull %3)
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(40) %0, ptr noundef nonnull align 8 dereferenceable(40) %.sroa.0, i64 40, i1 false)
  ret void
}

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(argmem: readwrite, inaccessiblemem: write) uwtable
define internal fastcc void @Fe.mul(ptr noalias nocapture nonnull writeonly sret(%Fe) initializes((0, 40)) %0, ptr nocapture nonnull readonly align 8 %1, ptr nocapture nonnull readonly align 8 %2) unnamed_addr #17 {
  %4 = alloca %Fe, align 8
  %5 = alloca [5 x i128], align 16
  %6 = load i64, ptr %1, align 8
  %7 = zext i64 %6 to i128
  %8 = load i64, ptr %2, align 8
  %9 = zext i64 %8 to i128
  %10 = getelementptr inbounds nuw i8, ptr %1, i64 8
  %11 = load i64, ptr %10, align 8
  %12 = zext i64 %11 to i128
  %13 = getelementptr inbounds nuw i8, ptr %2, i64 8
  %14 = load i64, ptr %13, align 8
  %15 = zext i64 %14 to i128
  %16 = getelementptr inbounds nuw i8, ptr %1, i64 16
  %17 = load i64, ptr %16, align 8
  %18 = zext i64 %17 to i128
  %19 = getelementptr inbounds nuw i8, ptr %2, i64 16
  %20 = load i64, ptr %19, align 8
  %21 = zext i64 %20 to i128
  %22 = getelementptr inbounds nuw i8, ptr %1, i64 24
  %23 = load i64, ptr %22, align 8
  %24 = zext i64 %23 to i128
  %25 = getelementptr inbounds nuw i8, ptr %2, i64 24
  %26 = load i64, ptr %25, align 8
  %27 = zext i64 %26 to i128
  %28 = getelementptr inbounds nuw i8, ptr %1, i64 32
  %29 = load i64, ptr %28, align 8
  %30 = zext i64 %29 to i128
  %31 = getelementptr inbounds nuw i8, ptr %2, i64 32
  %32 = load i64, ptr %31, align 8
  %33 = zext i64 %32 to i128
  %34 = mul nuw nsw i128 %12, 19
  %35 = mul nuw nsw i128 %18, 19
  %36 = mul nuw nsw i128 %24, 19
  %37 = mul nuw nsw i128 %30, 19
  %38 = mul nuw i128 %9, %7
  %39 = mul nuw i128 %34, %33
  %40 = mul nuw i128 %35, %27
  %41 = mul nuw i128 %36, %21
  %42 = mul nuw i128 %37, %15
  %43 = add nuw i128 %40, %38
  %44 = add nuw i128 %43, %41
  %45 = add nuw i128 %44, %39
  %46 = add nuw i128 %45, %42
  store i128 %46, ptr %5, align 16
  %47 = getelementptr inbounds nuw i8, ptr %5, i64 16
  %48 = mul nuw i128 %15, %7
  %49 = mul nuw i128 %12, %9
  %50 = add nuw i128 %48, %49
  %51 = mul nuw i128 %35, %33
  %52 = mul nuw i128 %36, %27
  %53 = mul nuw i128 %37, %21
  %54 = add nuw i128 %50, %52
  %55 = add nuw i128 %54, %51
  %56 = add nuw i128 %55, %53
  store i128 %56, ptr %47, align 16
  %57 = getelementptr inbounds nuw i8, ptr %5, i64 32
  %58 = mul nuw i128 %21, %7
  %59 = mul nuw i128 %15, %12
  %60 = mul nuw i128 %18, %9
  %61 = mul nuw i128 %36, %33
  %62 = mul nuw i128 %37, %27
  %63 = add nuw i128 %60, %59
  %64 = add nuw i128 %63, %58
  %65 = add nuw i128 %64, %61
  %66 = add nuw i128 %65, %62
  store i128 %66, ptr %57, align 16
  %67 = getelementptr inbounds nuw i8, ptr %5, i64 48
  %68 = mul nuw i128 %27, %7
  %69 = mul nuw i128 %21, %12
  %70 = mul nuw i128 %18, %15
  %71 = mul nuw i128 %24, %9
  %72 = mul nuw i128 %37, %33
  %73 = add nuw i128 %69, %70
  %74 = add nuw i128 %73, %71
  %75 = add nuw i128 %74, %68
  %76 = add nuw i128 %75, %72
  store i128 %76, ptr %67, align 16
  %77 = getelementptr inbounds nuw i8, ptr %5, i64 64
  %78 = mul nuw i128 %33, %7
  %79 = mul nuw i128 %27, %12
  %80 = mul nuw i128 %21, %18
  %81 = mul nuw i128 %24, %15
  %82 = mul nuw i128 %30, %9
  %83 = add nuw i128 %81, %80
  %84 = add nuw i128 %83, %79
  %85 = add nuw i128 %84, %82
  %86 = add nuw i128 %85, %78
  store i128 %86, ptr %77, align 16
  call fastcc void @Fe.carry128(ptr sret(%Fe) %4, ptr nonnull align 16 %5)
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(40) %0, ptr noundef nonnull align 8 dereferenceable(40) %4, i64 40, i1 false)
  ret void
}

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(argmem: readwrite) uwtable
define internal fastcc void @Fe.sub(ptr noalias nocapture nonnull writeonly sret(%Fe) initializes((0, 40)) %0, ptr nocapture nonnull readonly align 8 %1, ptr nocapture nonnull readonly align 8 %2) unnamed_addr #9 {
  %.sroa.0.0.copyload = load i64, ptr %2, align 8
  %.sroa.9.0..sroa_idx = getelementptr inbounds nuw i8, ptr %2, i64 8
  %.sroa.9.0.copyload = load i64, ptr %.sroa.9.0..sroa_idx, align 8
  %.sroa.16.0..sroa_idx = getelementptr inbounds nuw i8, ptr %2, i64 16
  %.sroa.16.0.copyload = load i64, ptr %.sroa.16.0..sroa_idx, align 8
  %.sroa.23.0..sroa_idx = getelementptr inbounds nuw i8, ptr %2, i64 24
  %.sroa.23.0.copyload = load i64, ptr %.sroa.23.0..sroa_idx, align 8
  %.sroa.30.0..sroa_idx = getelementptr inbounds nuw i8, ptr %2, i64 32
  %.sroa.30.0.copyload = load i64, ptr %.sroa.30.0..sroa_idx, align 8
  %4 = lshr i64 %.sroa.0.0.copyload, 51
  %5 = add nuw i64 %.sroa.9.0.copyload, %4
  %6 = and i64 %.sroa.0.0.copyload, 2251799813685247
  %7 = lshr i64 %5, 51
  %8 = add nuw i64 %7, %.sroa.16.0.copyload
  %9 = and i64 %5, 2251799813685247
  %10 = lshr i64 %8, 51
  %11 = add nuw i64 %10, %.sroa.23.0.copyload
  %12 = and i64 %8, 2251799813685247
  %13 = lshr i64 %11, 51
  %14 = add nuw i64 %13, %.sroa.30.0.copyload
  %15 = and i64 %11, 2251799813685247
  %16 = lshr i64 %14, 51
  %17 = and i64 %14, 2251799813685247
  %18 = load i64, ptr %1, align 8
  %.neg25 = mul nsw i64 %16, -19
  %reass.sub = sub i64 %18, %6
  %19 = add i64 %reass.sub, 4503599627370458
  %20 = add i64 %19, %.neg25
  %21 = getelementptr inbounds nuw i8, ptr %1, i64 8
  %22 = load i64, ptr %21, align 8
  %reass.sub31 = sub i64 %22, %9
  %23 = add i64 %reass.sub31, 4503599627370494
  %24 = getelementptr inbounds nuw i8, ptr %1, i64 16
  %25 = load i64, ptr %24, align 8
  %reass.sub32 = sub i64 %25, %12
  %26 = add i64 %reass.sub32, 4503599627370494
  %27 = getelementptr inbounds nuw i8, ptr %1, i64 24
  %28 = load i64, ptr %27, align 8
  %reass.sub33 = sub i64 %28, %15
  %29 = add i64 %reass.sub33, 4503599627370494
  %30 = getelementptr inbounds nuw i8, ptr %1, i64 32
  %31 = load i64, ptr %30, align 8
  %32 = add nuw i64 %31, 4503599627370494
  %33 = sub nuw i64 %32, %17
  store i64 %20, ptr %0, align 8
  %.sroa.9.0..sroa_idx5 = getelementptr inbounds nuw i8, ptr %0, i64 8
  store i64 %23, ptr %.sroa.9.0..sroa_idx5, align 8
  %.sroa.16.0..sroa_idx10 = getelementptr inbounds nuw i8, ptr %0, i64 16
  store i64 %26, ptr %.sroa.16.0..sroa_idx10, align 8
  %.sroa.23.0..sroa_idx15 = getelementptr inbounds nuw i8, ptr %0, i64 24
  store i64 %29, ptr %.sroa.23.0..sroa_idx15, align 8
  %.sroa.30.0..sroa_idx20 = getelementptr inbounds nuw i8, ptr %0, i64 32
  store i64 %33, ptr %.sroa.30.0..sroa_idx20, align 8
  ret void
}

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(argmem: readwrite) uwtable
define internal fastcc void @Fe.add(ptr noalias nocapture nonnull writeonly sret(%Fe) initializes((0, 40)) %0, ptr nocapture nonnull readonly align 8 %1, ptr nocapture nonnull readonly align 8 %2) unnamed_addr #9 {
  %4 = load i64, ptr %1, align 8
  %5 = load i64, ptr %2, align 8
  %6 = add nuw i64 %5, %4
  %7 = getelementptr inbounds nuw i8, ptr %1, i64 8
  %8 = load i64, ptr %7, align 8
  %9 = getelementptr inbounds nuw i8, ptr %2, i64 8
  %10 = load i64, ptr %9, align 8
  %11 = add nuw i64 %10, %8
  %12 = getelementptr inbounds nuw i8, ptr %1, i64 16
  %13 = load i64, ptr %12, align 8
  %14 = getelementptr inbounds nuw i8, ptr %2, i64 16
  %15 = load i64, ptr %14, align 8
  %16 = add nuw i64 %15, %13
  %17 = getelementptr inbounds nuw i8, ptr %1, i64 24
  %18 = load i64, ptr %17, align 8
  %19 = getelementptr inbounds nuw i8, ptr %2, i64 24
  %20 = load i64, ptr %19, align 8
  %21 = add nuw i64 %20, %18
  %22 = getelementptr inbounds nuw i8, ptr %1, i64 32
  %23 = load i64, ptr %22, align 8
  %24 = getelementptr inbounds nuw i8, ptr %2, i64 32
  %25 = load i64, ptr %24, align 8
  %26 = add nuw i64 %25, %23
  store i64 %6, ptr %0, align 8
  %.sroa.3.0..sroa_idx = getelementptr inbounds nuw i8, ptr %0, i64 8
  store i64 %11, ptr %.sroa.3.0..sroa_idx, align 8
  %.sroa.4.0..sroa_idx = getelementptr inbounds nuw i8, ptr %0, i64 16
  store i64 %16, ptr %.sroa.4.0..sroa_idx, align 8
  %.sroa.5.0..sroa_idx = getelementptr inbounds nuw i8, ptr %0, i64 24
  store i64 %21, ptr %.sroa.5.0..sroa_idx, align 8
  %.sroa.6.0..sroa_idx = getelementptr inbounds nuw i8, ptr %0, i64 32
  store i64 %26, ptr %.sroa.6.0..sroa_idx, align 8
  ret void
}

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(argmem: readwrite) uwtable
define internal fastcc void @Fe.cMov(ptr nocapture nonnull align 8 %0, ptr nocapture nonnull readonly align 8 %1, i64 range(i64 0, 2) %2) unnamed_addr #9 {
  %4 = sub nsw i64 0, %2
  %.sroa.0.0.copyload = load i64, ptr %0, align 8
  %.sroa.6.0..sroa_idx = getelementptr inbounds nuw i8, ptr %0, i64 8
  %.sroa.6.0.copyload = load i64, ptr %.sroa.6.0..sroa_idx, align 8
  %.sroa.11.0..sroa_idx = getelementptr inbounds nuw i8, ptr %0, i64 16
  %.sroa.11.0.copyload = load i64, ptr %.sroa.11.0..sroa_idx, align 8
  %.sroa.16.0..sroa_idx = getelementptr inbounds nuw i8, ptr %0, i64 24
  %.sroa.16.0.copyload = load i64, ptr %.sroa.16.0..sroa_idx, align 8
  %.sroa.21.0..sroa_idx = getelementptr inbounds nuw i8, ptr %0, i64 32
  %.sroa.21.0.copyload = load i64, ptr %.sroa.21.0..sroa_idx, align 8
  %5 = load i64, ptr %1, align 8
  %6 = xor i64 %5, %.sroa.0.0.copyload
  %7 = getelementptr inbounds nuw i8, ptr %1, i64 8
  %8 = load i64, ptr %7, align 8
  %9 = xor i64 %8, %.sroa.6.0.copyload
  %10 = getelementptr inbounds nuw i8, ptr %1, i64 16
  %11 = load i64, ptr %10, align 8
  %12 = xor i64 %11, %.sroa.11.0.copyload
  %13 = getelementptr inbounds nuw i8, ptr %1, i64 24
  %14 = load i64, ptr %13, align 8
  %15 = xor i64 %14, %.sroa.16.0.copyload
  %16 = getelementptr inbounds nuw i8, ptr %1, i64 32
  %17 = load i64, ptr %16, align 8
  %18 = xor i64 %17, %.sroa.21.0.copyload
  %19 = and i64 %6, %4
  %20 = and i64 %9, %4
  %21 = and i64 %12, %4
  %22 = and i64 %15, %4
  %23 = and i64 %18, %4
  %24 = xor i64 %19, %.sroa.0.0.copyload
  store i64 %24, ptr %0, align 8
  %25 = xor i64 %20, %.sroa.6.0.copyload
  store i64 %25, ptr %.sroa.6.0..sroa_idx, align 8
  %26 = xor i64 %21, %.sroa.11.0.copyload
  store i64 %26, ptr %.sroa.11.0..sroa_idx, align 8
  %27 = xor i64 %22, %.sroa.16.0.copyload
  store i64 %27, ptr %.sroa.16.0..sroa_idx, align 8
  %28 = xor i64 %23, %.sroa.21.0.copyload
  store i64 %28, ptr %.sroa.21.0..sroa_idx, align 8
  ret void
}

; Function Attrs: minsize mustprogress nofree noinline norecurse nosync nounwind optsize willreturn memory(argmem: read) uwtable
define internal fastcc range(i16 0, 2) i16 @Fe.rejectNonCanonical(ptr nocapture nonnull readonly align 1 %0) unnamed_addr #18 {
common.ret:
  %1 = getelementptr inbounds nuw i8, ptr %0, i64 31
  %2 = load i8, ptr %1, align 1
  %3 = and i8 %2, 127
  %4 = xor i8 %3, 127
  %5 = getelementptr inbounds nuw i8, ptr %0, i64 30
  %6 = load i8, ptr %5, align 1
  %7 = getelementptr inbounds nuw i8, ptr %0, i64 29
  %8 = load i8, ptr %7, align 1
  %9 = and i8 %8, %6
  %10 = getelementptr inbounds nuw i8, ptr %0, i64 28
  %11 = load i8, ptr %10, align 1
  %12 = and i8 %9, %11
  %13 = getelementptr inbounds nuw i8, ptr %0, i64 27
  %14 = load i8, ptr %13, align 1
  %15 = and i8 %12, %14
  %16 = getelementptr inbounds nuw i8, ptr %0, i64 26
  %17 = load i8, ptr %16, align 1
  %18 = and i8 %15, %17
  %19 = getelementptr inbounds nuw i8, ptr %0, i64 25
  %20 = load i8, ptr %19, align 1
  %21 = and i8 %18, %20
  %22 = getelementptr inbounds nuw i8, ptr %0, i64 24
  %23 = load i8, ptr %22, align 1
  %24 = and i8 %21, %23
  %25 = getelementptr inbounds nuw i8, ptr %0, i64 23
  %26 = load i8, ptr %25, align 1
  %27 = and i8 %24, %26
  %28 = getelementptr inbounds nuw i8, ptr %0, i64 22
  %29 = load i8, ptr %28, align 1
  %30 = and i8 %27, %29
  %31 = getelementptr inbounds nuw i8, ptr %0, i64 21
  %32 = load i8, ptr %31, align 1
  %33 = and i8 %30, %32
  %34 = getelementptr inbounds nuw i8, ptr %0, i64 20
  %35 = load i8, ptr %34, align 1
  %36 = and i8 %33, %35
  %37 = getelementptr inbounds nuw i8, ptr %0, i64 19
  %38 = load i8, ptr %37, align 1
  %39 = and i8 %36, %38
  %40 = getelementptr inbounds nuw i8, ptr %0, i64 18
  %41 = load i8, ptr %40, align 1
  %42 = and i8 %39, %41
  %43 = getelementptr inbounds nuw i8, ptr %0, i64 17
  %44 = load i8, ptr %43, align 1
  %45 = and i8 %42, %44
  %46 = getelementptr inbounds nuw i8, ptr %0, i64 16
  %47 = load i8, ptr %46, align 1
  %48 = and i8 %45, %47
  %49 = getelementptr inbounds nuw i8, ptr %0, i64 15
  %50 = load i8, ptr %49, align 1
  %51 = and i8 %48, %50
  %52 = getelementptr inbounds nuw i8, ptr %0, i64 14
  %53 = load i8, ptr %52, align 1
  %54 = and i8 %51, %53
  %55 = getelementptr inbounds nuw i8, ptr %0, i64 13
  %56 = load i8, ptr %55, align 1
  %57 = and i8 %54, %56
  %58 = getelementptr inbounds nuw i8, ptr %0, i64 12
  %59 = load i8, ptr %58, align 1
  %60 = and i8 %57, %59
  %61 = getelementptr inbounds nuw i8, ptr %0, i64 11
  %62 = load i8, ptr %61, align 1
  %63 = and i8 %60, %62
  %64 = getelementptr inbounds nuw i8, ptr %0, i64 10
  %65 = load i8, ptr %64, align 1
  %66 = and i8 %63, %65
  %67 = getelementptr inbounds nuw i8, ptr %0, i64 9
  %68 = load i8, ptr %67, align 1
  %69 = and i8 %66, %68
  %70 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %71 = load i8, ptr %70, align 1
  %72 = and i8 %69, %71
  %73 = getelementptr inbounds nuw i8, ptr %0, i64 7
  %74 = load i8, ptr %73, align 1
  %75 = and i8 %72, %74
  %76 = getelementptr inbounds nuw i8, ptr %0, i64 6
  %77 = load i8, ptr %76, align 1
  %78 = and i8 %75, %77
  %79 = getelementptr inbounds nuw i8, ptr %0, i64 5
  %80 = load i8, ptr %79, align 1
  %81 = and i8 %78, %80
  %82 = getelementptr inbounds nuw i8, ptr %0, i64 4
  %83 = load i8, ptr %82, align 1
  %84 = and i8 %81, %83
  %85 = getelementptr inbounds nuw i8, ptr %0, i64 3
  %86 = load i8, ptr %85, align 1
  %87 = and i8 %84, %86
  %88 = getelementptr inbounds nuw i8, ptr %0, i64 2
  %89 = load i8, ptr %88, align 1
  %90 = and i8 %87, %89
  %91 = getelementptr inbounds nuw i8, ptr %0, i64 1
  %92 = load i8, ptr %91, align 1
  %93 = and i8 %90, %92
  %94 = xor i8 %93, -1
  %95 = or i8 %4, %94
  %96 = zext i8 %95 to i16
  %97 = add nuw nsw i16 %96, 511
  %98 = load i8, ptr %0, align 1
  %99 = zext i8 %98 to i16
  %100 = sub nsw i16 236, %99
  %101 = and i16 %97, %100
  %102 = lshr i16 %101, 8
  %.lobit = and i16 %102, 1
  ret i16 %.lobit
}

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(argmem: readwrite) uwtable
define internal fastcc void @Fe.reduce(ptr nocapture nonnull align 8 %0) unnamed_addr #9 {
  %2 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %3 = load i64, ptr %2, align 8
  %4 = load i64, ptr %0, align 8
  %5 = lshr i64 %4, 51
  %6 = add nuw i64 %5, %3
  %7 = and i64 %4, 2251799813685247
  %8 = getelementptr inbounds nuw i8, ptr %0, i64 16
  %9 = load i64, ptr %8, align 8
  %10 = lshr i64 %6, 51
  %11 = add nuw i64 %9, %10
  %12 = and i64 %6, 2251799813685247
  %13 = getelementptr inbounds nuw i8, ptr %0, i64 24
  %14 = load i64, ptr %13, align 8
  %15 = lshr i64 %11, 51
  %16 = add nuw i64 %14, %15
  %17 = and i64 %11, 2251799813685247
  %18 = getelementptr inbounds nuw i8, ptr %0, i64 32
  %19 = load i64, ptr %18, align 8
  %20 = lshr i64 %16, 51
  %21 = add nuw i64 %19, %20
  %22 = and i64 %16, 2251799813685247
  %23 = lshr i64 %21, 51
  %24 = mul nuw nsw i64 %23, 19
  %25 = add nuw nsw i64 %24, %7
  %26 = and i64 %21, 2251799813685247
  %27 = lshr i64 %25, 51
  %28 = add nuw nsw i64 %27, %12
  %29 = and i64 %25, 2251799813685247
  %30 = lshr i64 %28, 51
  %31 = add nuw nsw i64 %30, %17
  %32 = and i64 %28, 2251799813685247
  %33 = lshr i64 %31, 51
  %34 = add nuw nsw i64 %33, %22
  %35 = and i64 %31, 2251799813685247
  %36 = lshr i64 %34, 51
  %37 = add nuw nsw i64 %36, %26
  %38 = and i64 %34, 2251799813685247
  %39 = lshr i64 %37, 51
  %40 = mul nuw nsw i64 %39, 19
  %41 = add nuw nsw i64 %40, %29
  %42 = and i64 %37, 2251799813685247
  %43 = add nuw nsw i64 %41, 19
  %44 = lshr i64 %43, 51
  %45 = add nuw nsw i64 %44, %32
  %46 = and i64 %43, 2251799813685247
  %47 = lshr i64 %45, 51
  %48 = add nuw nsw i64 %47, %35
  %49 = and i64 %45, 2251799813685247
  %50 = lshr i64 %48, 51
  %51 = add nuw nsw i64 %50, %38
  %52 = and i64 %48, 2251799813685247
  %53 = lshr i64 %51, 51
  %54 = add nuw nsw i64 %53, %42
  %55 = and i64 %51, 2251799813685247
  %56 = lshr i64 %54, 51
  %57 = mul nuw nsw i64 %56, 19
  %58 = add nuw nsw i64 %57, %46
  %59 = add nuw nsw i64 %58, 2251799813685229
  %60 = add nuw nsw i64 %49, 2251799813685247
  %61 = add nuw nsw i64 %52, 2251799813685247
  %62 = add nuw nsw i64 %55, 2251799813685247
  %63 = add nuw nsw i64 %54, 2251799813685247
  %64 = lshr i64 %59, 51
  %65 = add nuw nsw i64 %64, %60
  %66 = and i64 %59, 2251799813685247
  store i64 %66, ptr %0, align 8
  %67 = lshr i64 %65, 51
  %68 = add nuw nsw i64 %67, %61
  %69 = and i64 %65, 2251799813685247
  store i64 %69, ptr %2, align 8
  %70 = lshr i64 %68, 51
  %71 = add nuw nsw i64 %70, %62
  %72 = and i64 %68, 2251799813685247
  store i64 %72, ptr %8, align 8
  %73 = lshr i64 %71, 51
  %74 = add nuw nsw i64 %73, %63
  %75 = and i64 %71, 2251799813685247
  store i64 %75, ptr %13, align 8
  %76 = and i64 %74, 2251799813685247
  store i64 %76, ptr %18, align 8
  ret void
}

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(argmem: readwrite, inaccessiblemem: write) uwtable
define internal fastcc void @Fe.carry128(ptr noalias nocapture nonnull writeonly sret(%Fe) initializes((0, 40)) %0, ptr nocapture nonnull align 16 %1) unnamed_addr #17 {
  %3 = load i128, ptr %1, align 16
  %4 = trunc i128 %3 to i64
  %5 = and i64 %4, 2251799813685247
  %6 = getelementptr inbounds nuw i8, ptr %1, i64 16
  %7 = load i128, ptr %6, align 16
  %8 = lshr i128 %3, 51
  %9 = icmp ult i128 %3, 41538374868278621028243970633760768
  tail call void @llvm.assume(i1 %9)
  %10 = add nuw nsw i128 %7, %8
  store i128 %10, ptr %6, align 16
  %11 = trunc i128 %10 to i64
  %12 = and i64 %11, 2251799813685247
  %13 = getelementptr inbounds nuw i8, ptr %1, i64 32
  %14 = load i128, ptr %13, align 16
  %15 = lshr i128 %10, 51
  %16 = icmp ult i128 %10, 41538374868278621028243970633760768
  tail call void @llvm.assume(i1 %16)
  %17 = add nuw nsw i128 %14, %15
  store i128 %17, ptr %13, align 16
  %18 = trunc i128 %17 to i64
  %19 = and i64 %18, 2251799813685247
  %20 = getelementptr inbounds nuw i8, ptr %1, i64 48
  %21 = load i128, ptr %20, align 16
  %22 = lshr i128 %17, 51
  %23 = icmp ult i128 %17, 41538374868278621028243970633760768
  tail call void @llvm.assume(i1 %23)
  %24 = add nuw nsw i128 %21, %22
  store i128 %24, ptr %20, align 16
  %25 = trunc i128 %24 to i64
  %26 = and i64 %25, 2251799813685247
  %27 = getelementptr inbounds nuw i8, ptr %1, i64 64
  %28 = load i128, ptr %27, align 16
  %29 = lshr i128 %24, 51
  %30 = icmp ult i128 %24, 41538374868278621028243970633760768
  tail call void @llvm.assume(i1 %30)
  %31 = add nuw nsw i128 %28, %29
  store i128 %31, ptr %27, align 16
  %32 = trunc i128 %31 to i64
  %33 = and i64 %32, 2251799813685247
  %34 = lshr i128 %31, 51
  %35 = icmp ult i128 %31, 41538374868278621028243970633760768
  tail call void @llvm.assume(i1 %35)
  %36 = trunc nuw i128 %34 to i64
  %37 = mul nuw i64 %36, 19
  %38 = add nuw i64 %37, %5
  %39 = lshr i64 %38, 51
  %40 = and i64 %38, 2251799813685247
  %41 = add nuw nsw i64 %39, %12
  %42 = lshr i64 %41, 51
  %43 = and i64 %41, 2251799813685247
  %44 = add nuw nsw i64 %42, %19
  store i64 %40, ptr %0, align 8
  %.sroa.8.0..sroa_idx = getelementptr inbounds nuw i8, ptr %0, i64 8
  store i64 %43, ptr %.sroa.8.0..sroa_idx, align 8
  %.sroa.14.0..sroa_idx = getelementptr inbounds nuw i8, ptr %0, i64 16
  store i64 %44, ptr %.sroa.14.0..sroa_idx, align 8
  %.sroa.17.0..sroa_idx = getelementptr inbounds nuw i8, ptr %0, i64 24
  store i64 %26, ptr %.sroa.17.0..sroa_idx, align 8
  %.sroa.18.0..sroa_idx = getelementptr inbounds nuw i8, ptr %0, i64 32
  store i64 %33, ptr %.sroa.18.0..sroa_idx, align 8
  ret void
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(argmem: readwrite, inaccessiblemem: write) uwtable
define internal fastcc void @Fe.sqn(ptr noalias nocapture nonnull writeonly sret(%Fe) %0, ptr nocapture nonnull readonly align 8 %1, i64 range(i64 2, 121) %2) unnamed_addr #4 {
  %4 = alloca %Fe, align 8
  %5 = alloca %Fe, align 8
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(40) %5, ptr noundef nonnull align 8 dereferenceable(40) %1, i64 40, i1 false)
  br label %6

6:                                                ; preds = %7, %3
  %.0 = phi i64 [ 0, %3 ], [ %8, %7 ]
  %exitcond.not = icmp eq i64 %.0, %2
  br i1 %exitcond.not, label %9, label %7

7:                                                ; preds = %6
  call fastcc void @Fe.sq(ptr sret(%Fe) %4, ptr nonnull readonly align 8 %5)
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(40) %5, ptr noundef nonnull align 8 dereferenceable(40) %4, i64 40, i1 false)
  %8 = add nuw nsw i64 %.0, 1
  br label %6

9:                                                ; preds = %6
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(40) %0, ptr noundef nonnull align 8 dereferenceable(40) %5, i64 40, i1 false)
  ret void
}

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: readwrite)
declare void @llvm.experimental.noalias.scope.decl(metadata) #19

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr nocapture) #20

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr nocapture) #20

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i64 @llvm.fshl.i64(i64, i64, i64) #21

attributes #0 = { minsize nofree norecurse nosync nounwind optsize memory(read, argmem: readwrite, inaccessiblemem: readwrite) uwtable "frame-pointer"="all" "target-cpu"="x86-64" "target-features"="+64bit,+cmov,+cx8,+fxsr,+idivq-to-divl,+macrofusion,+mmx,+nopl,+slow-3ops-lea,+slow-incdec,+vzeroupper,+x87,-16bit-mode,-32bit-mode,-adx,-aes,-allow-light-256-bit,-amx-avx512,-amx-bf16,-amx-complex,-amx-fp16,-amx-fp8,-amx-int8,-amx-movrs,-amx-tf32,-amx-tile,-amx-transpose,-avx,-avx10.1-256,-avx10.1-512,-avx10.2-256,-avx10.2-512,-avx2,-avx512bf16,-avx512bitalg,-avx512bw,-avx512cd,-avx512dq,-avx512f,-avx512fp16,-avx512ifma,-avx512vbmi,-avx512vbmi2,-avx512vl,-avx512vnni,-avx512vp2intersect,-avx512vpopcntdq,-avxifma,-avxneconvert,-avxvnni,-avxvnniint16,-avxvnniint8,-bmi,-bmi2,-branch-hint,-branchfusion,-ccmp,-cf,-cldemote,-clflushopt,-clwb,-clzero,-cmpccxadd,-crc32,-cx16,-egpr,-enqcmd,-ermsb,-evex512,-f16c,-false-deps-getmant,-false-deps-lzcnt-tzcnt,-false-deps-mulc,-false-deps-mullq,-false-deps-perm,-false-deps-popcnt,-false-deps-range,-fast-11bytenop,-fast-15bytenop,-fast-7bytenop,-fast-bextr,-fast-dpwssd,-fast-gather,-fast-hops,-fast-imm16,-fast-lzcnt,-fast-movbe,-fast-scalar-fsqrt,-fast-scalar-shift-masks,-fast-shld-rotate,-fast-variable-crosslane-shuffle,-fast-variable-perlane-shuffle,-fast-vector-fsqrt,-fast-vector-shift-masks,-faster-shift-than-shuffle,-fma,-fma4,-fsgsbase,-fsrm,-gfni,-harden-sls-ijmp,-harden-sls-ret,-hreset,-idivl-to-divb,-inline-asm-use-gpr32,-invpcid,-kl,-lea-sp,-lea-uses-ag,-lvi-cfi,-lvi-load-hardening,-lwp,-lzcnt,-movbe,-movdir64b,-movdiri,-movrs,-mwaitx,-ndd,-nf,-no-bypass-delay,-no-bypass-delay-blend,-no-bypass-delay-mov,-no-bypass-delay-shuffle,-pad-short-functions,-pclmul,-pconfig,-pku,-popcnt,-ppx,-prefer-128-bit,-prefer-256-bit,-prefer-mask-registers,-prefer-movmsk-over-vtest,-prefer-no-gather,-prefer-no-scatter,-prefetchi,-prfchw,-ptwrite,-push2pop2,-raoint,-rdpid,-rdpru,-rdrnd,-rdseed,-retpoline,-retpoline-external-thunk,-retpoline-indirect-branches,-retpoline-indirect-calls,-rtm,-sahf,-sbb-dep-breaking,-serialize,-seses,-sgx,-sha,-sha512,-shstk,-slow-lea,-slow-pmaddwd,-slow-pmulld,-slow-shld,-slow-two-mem-ops,-slow-unaligned-mem-16,-slow-unaligned-mem-32,-sm3,-sm4,-soft-float,-sse,-sse2,-sse3,-sse4.1,-sse4.2,-sse4a,-sse-unaligned-mem,-ssse3,-tagged-globals,-tbm,-tsxldtrk,-tuning-fast-imm-vector-shift,-uintr,-use-glm-div-sqrt-costs,-use-slm-arith-costs,-usermsr,-vaes,-vpclmulqdq,-waitpkg,-wbnoinvd,-widekl,-xop,-xsave,-xsavec,-xsaveopt,-xsaves,-zu" }
attributes #1 = { mustprogress nocallback nofree nounwind willreturn memory(argmem: readwrite) }
attributes #2 = { minsize nofree noinline norecurse nosync nounwind optsize memory(read, argmem: readwrite, inaccessiblemem: readwrite) uwtable "frame-pointer"="all" "target-cpu"="x86-64" "target-features"="+64bit,+cmov,+cx8,+fxsr,+idivq-to-divl,+macrofusion,+mmx,+nopl,+slow-3ops-lea,+slow-incdec,+vzeroupper,+x87,-16bit-mode,-32bit-mode,-adx,-aes,-allow-light-256-bit,-amx-avx512,-amx-bf16,-amx-complex,-amx-fp16,-amx-fp8,-amx-int8,-amx-movrs,-amx-tf32,-amx-tile,-amx-transpose,-avx,-avx10.1-256,-avx10.1-512,-avx10.2-256,-avx10.2-512,-avx2,-avx512bf16,-avx512bitalg,-avx512bw,-avx512cd,-avx512dq,-avx512f,-avx512fp16,-avx512ifma,-avx512vbmi,-avx512vbmi2,-avx512vl,-avx512vnni,-avx512vp2intersect,-avx512vpopcntdq,-avxifma,-avxneconvert,-avxvnni,-avxvnniint16,-avxvnniint8,-bmi,-bmi2,-branch-hint,-branchfusion,-ccmp,-cf,-cldemote,-clflushopt,-clwb,-clzero,-cmpccxadd,-crc32,-cx16,-egpr,-enqcmd,-ermsb,-evex512,-f16c,-false-deps-getmant,-false-deps-lzcnt-tzcnt,-false-deps-mulc,-false-deps-mullq,-false-deps-perm,-false-deps-popcnt,-false-deps-range,-fast-11bytenop,-fast-15bytenop,-fast-7bytenop,-fast-bextr,-fast-dpwssd,-fast-gather,-fast-hops,-fast-imm16,-fast-lzcnt,-fast-movbe,-fast-scalar-fsqrt,-fast-scalar-shift-masks,-fast-shld-rotate,-fast-variable-crosslane-shuffle,-fast-variable-perlane-shuffle,-fast-vector-fsqrt,-fast-vector-shift-masks,-faster-shift-than-shuffle,-fma,-fma4,-fsgsbase,-fsrm,-gfni,-harden-sls-ijmp,-harden-sls-ret,-hreset,-idivl-to-divb,-inline-asm-use-gpr32,-invpcid,-kl,-lea-sp,-lea-uses-ag,-lvi-cfi,-lvi-load-hardening,-lwp,-lzcnt,-movbe,-movdir64b,-movdiri,-movrs,-mwaitx,-ndd,-nf,-no-bypass-delay,-no-bypass-delay-blend,-no-bypass-delay-mov,-no-bypass-delay-shuffle,-pad-short-functions,-pclmul,-pconfig,-pku,-popcnt,-ppx,-prefer-128-bit,-prefer-256-bit,-prefer-mask-registers,-prefer-movmsk-over-vtest,-prefer-no-gather,-prefer-no-scatter,-prefetchi,-prfchw,-ptwrite,-push2pop2,-raoint,-rdpid,-rdpru,-rdrnd,-rdseed,-retpoline,-retpoline-external-thunk,-retpoline-indirect-branches,-retpoline-indirect-calls,-rtm,-sahf,-sbb-dep-breaking,-serialize,-seses,-sgx,-sha,-sha512,-shstk,-slow-lea,-slow-pmaddwd,-slow-pmulld,-slow-shld,-slow-two-mem-ops,-slow-unaligned-mem-16,-slow-unaligned-mem-32,-sm3,-sm4,-soft-float,-sse,-sse2,-sse3,-sse4.1,-sse4.2,-sse4a,-sse-unaligned-mem,-ssse3,-tagged-globals,-tbm,-tsxldtrk,-tuning-fast-imm-vector-shift,-uintr,-use-glm-div-sqrt-costs,-use-slm-arith-costs,-usermsr,-vaes,-vpclmulqdq,-waitpkg,-wbnoinvd,-widekl,-xop,-xsave,-xsavec,-xsaveopt,-xsaves,-zu" }
attributes #3 = { minsize nofree noinline norecurse nosync nounwind optsize memory(argmem: readwrite, inaccessiblemem: readwrite) uwtable "frame-pointer"="all" "target-cpu"="x86-64" "target-features"="+64bit,+cmov,+cx8,+fxsr,+idivq-to-divl,+macrofusion,+mmx,+nopl,+slow-3ops-lea,+slow-incdec,+vzeroupper,+x87,-16bit-mode,-32bit-mode,-adx,-aes,-allow-light-256-bit,-amx-avx512,-amx-bf16,-amx-complex,-amx-fp16,-amx-fp8,-amx-int8,-amx-movrs,-amx-tf32,-amx-tile,-amx-transpose,-avx,-avx10.1-256,-avx10.1-512,-avx10.2-256,-avx10.2-512,-avx2,-avx512bf16,-avx512bitalg,-avx512bw,-avx512cd,-avx512dq,-avx512f,-avx512fp16,-avx512ifma,-avx512vbmi,-avx512vbmi2,-avx512vl,-avx512vnni,-avx512vp2intersect,-avx512vpopcntdq,-avxifma,-avxneconvert,-avxvnni,-avxvnniint16,-avxvnniint8,-bmi,-bmi2,-branch-hint,-branchfusion,-ccmp,-cf,-cldemote,-clflushopt,-clwb,-clzero,-cmpccxadd,-crc32,-cx16,-egpr,-enqcmd,-ermsb,-evex512,-f16c,-false-deps-getmant,-false-deps-lzcnt-tzcnt,-false-deps-mulc,-false-deps-mullq,-false-deps-perm,-false-deps-popcnt,-false-deps-range,-fast-11bytenop,-fast-15bytenop,-fast-7bytenop,-fast-bextr,-fast-dpwssd,-fast-gather,-fast-hops,-fast-imm16,-fast-lzcnt,-fast-movbe,-fast-scalar-fsqrt,-fast-scalar-shift-masks,-fast-shld-rotate,-fast-variable-crosslane-shuffle,-fast-variable-perlane-shuffle,-fast-vector-fsqrt,-fast-vector-shift-masks,-faster-shift-than-shuffle,-fma,-fma4,-fsgsbase,-fsrm,-gfni,-harden-sls-ijmp,-harden-sls-ret,-hreset,-idivl-to-divb,-inline-asm-use-gpr32,-invpcid,-kl,-lea-sp,-lea-uses-ag,-lvi-cfi,-lvi-load-hardening,-lwp,-lzcnt,-movbe,-movdir64b,-movdiri,-movrs,-mwaitx,-ndd,-nf,-no-bypass-delay,-no-bypass-delay-blend,-no-bypass-delay-mov,-no-bypass-delay-shuffle,-pad-short-functions,-pclmul,-pconfig,-pku,-popcnt,-ppx,-prefer-128-bit,-prefer-256-bit,-prefer-mask-registers,-prefer-movmsk-over-vtest,-prefer-no-gather,-prefer-no-scatter,-prefetchi,-prfchw,-ptwrite,-push2pop2,-raoint,-rdpid,-rdpru,-rdrnd,-rdseed,-retpoline,-retpoline-external-thunk,-retpoline-indirect-branches,-retpoline-indirect-calls,-rtm,-sahf,-sbb-dep-breaking,-serialize,-seses,-sgx,-sha,-sha512,-shstk,-slow-lea,-slow-pmaddwd,-slow-pmulld,-slow-shld,-slow-two-mem-ops,-slow-unaligned-mem-16,-slow-unaligned-mem-32,-sm3,-sm4,-soft-float,-sse,-sse2,-sse3,-sse4.1,-sse4.2,-sse4a,-sse-unaligned-mem,-ssse3,-tagged-globals,-tbm,-tsxldtrk,-tuning-fast-imm-vector-shift,-uintr,-use-glm-div-sqrt-costs,-use-slm-arith-costs,-usermsr,-vaes,-vpclmulqdq,-waitpkg,-wbnoinvd,-widekl,-xop,-xsave,-xsavec,-xsaveopt,-xsaves,-zu" }
attributes #4 = { minsize nofree norecurse nosync nounwind optsize memory(argmem: readwrite, inaccessiblemem: write) uwtable "frame-pointer"="all" "target-cpu"="x86-64" "target-features"="+64bit,+cmov,+cx8,+fxsr,+idivq-to-divl,+macrofusion,+mmx,+nopl,+slow-3ops-lea,+slow-incdec,+vzeroupper,+x87,-16bit-mode,-32bit-mode,-adx,-aes,-allow-light-256-bit,-amx-avx512,-amx-bf16,-amx-complex,-amx-fp16,-amx-fp8,-amx-int8,-amx-movrs,-amx-tf32,-amx-tile,-amx-transpose,-avx,-avx10.1-256,-avx10.1-512,-avx10.2-256,-avx10.2-512,-avx2,-avx512bf16,-avx512bitalg,-avx512bw,-avx512cd,-avx512dq,-avx512f,-avx512fp16,-avx512ifma,-avx512vbmi,-avx512vbmi2,-avx512vl,-avx512vnni,-avx512vp2intersect,-avx512vpopcntdq,-avxifma,-avxneconvert,-avxvnni,-avxvnniint16,-avxvnniint8,-bmi,-bmi2,-branch-hint,-branchfusion,-ccmp,-cf,-cldemote,-clflushopt,-clwb,-clzero,-cmpccxadd,-crc32,-cx16,-egpr,-enqcmd,-ermsb,-evex512,-f16c,-false-deps-getmant,-false-deps-lzcnt-tzcnt,-false-deps-mulc,-false-deps-mullq,-false-deps-perm,-false-deps-popcnt,-false-deps-range,-fast-11bytenop,-fast-15bytenop,-fast-7bytenop,-fast-bextr,-fast-dpwssd,-fast-gather,-fast-hops,-fast-imm16,-fast-lzcnt,-fast-movbe,-fast-scalar-fsqrt,-fast-scalar-shift-masks,-fast-shld-rotate,-fast-variable-crosslane-shuffle,-fast-variable-perlane-shuffle,-fast-vector-fsqrt,-fast-vector-shift-masks,-faster-shift-than-shuffle,-fma,-fma4,-fsgsbase,-fsrm,-gfni,-harden-sls-ijmp,-harden-sls-ret,-hreset,-idivl-to-divb,-inline-asm-use-gpr32,-invpcid,-kl,-lea-sp,-lea-uses-ag,-lvi-cfi,-lvi-load-hardening,-lwp,-lzcnt,-movbe,-movdir64b,-movdiri,-movrs,-mwaitx,-ndd,-nf,-no-bypass-delay,-no-bypass-delay-blend,-no-bypass-delay-mov,-no-bypass-delay-shuffle,-pad-short-functions,-pclmul,-pconfig,-pku,-popcnt,-ppx,-prefer-128-bit,-prefer-256-bit,-prefer-mask-registers,-prefer-movmsk-over-vtest,-prefer-no-gather,-prefer-no-scatter,-prefetchi,-prfchw,-ptwrite,-push2pop2,-raoint,-rdpid,-rdpru,-rdrnd,-rdseed,-retpoline,-retpoline-external-thunk,-retpoline-indirect-branches,-retpoline-indirect-calls,-rtm,-sahf,-sbb-dep-breaking,-serialize,-seses,-sgx,-sha,-sha512,-shstk,-slow-lea,-slow-pmaddwd,-slow-pmulld,-slow-shld,-slow-two-mem-ops,-slow-unaligned-mem-16,-slow-unaligned-mem-32,-sm3,-sm4,-soft-float,-sse,-sse2,-sse3,-sse4.1,-sse4.2,-sse4a,-sse-unaligned-mem,-ssse3,-tagged-globals,-tbm,-tsxldtrk,-tuning-fast-imm-vector-shift,-uintr,-use-glm-div-sqrt-costs,-use-slm-arith-costs,-usermsr,-vaes,-vpclmulqdq,-waitpkg,-wbnoinvd,-widekl,-xop,-xsave,-xsavec,-xsaveopt,-xsaves,-zu" }
attributes #5 = { mustprogress nocallback nofree nounwind willreturn memory(argmem: write) }
attributes #6 = { minsize nofree noinline norecurse nosync nounwind optsize memory(argmem: readwrite) uwtable "frame-pointer"="all" "target-cpu"="x86-64" "target-features"="+64bit,+cmov,+cx8,+fxsr,+idivq-to-divl,+macrofusion,+mmx,+nopl,+slow-3ops-lea,+slow-incdec,+vzeroupper,+x87,-16bit-mode,-32bit-mode,-adx,-aes,-allow-light-256-bit,-amx-avx512,-amx-bf16,-amx-complex,-amx-fp16,-amx-fp8,-amx-int8,-amx-movrs,-amx-tf32,-amx-tile,-amx-transpose,-avx,-avx10.1-256,-avx10.1-512,-avx10.2-256,-avx10.2-512,-avx2,-avx512bf16,-avx512bitalg,-avx512bw,-avx512cd,-avx512dq,-avx512f,-avx512fp16,-avx512ifma,-avx512vbmi,-avx512vbmi2,-avx512vl,-avx512vnni,-avx512vp2intersect,-avx512vpopcntdq,-avxifma,-avxneconvert,-avxvnni,-avxvnniint16,-avxvnniint8,-bmi,-bmi2,-branch-hint,-branchfusion,-ccmp,-cf,-cldemote,-clflushopt,-clwb,-clzero,-cmpccxadd,-crc32,-cx16,-egpr,-enqcmd,-ermsb,-evex512,-f16c,-false-deps-getmant,-false-deps-lzcnt-tzcnt,-false-deps-mulc,-false-deps-mullq,-false-deps-perm,-false-deps-popcnt,-false-deps-range,-fast-11bytenop,-fast-15bytenop,-fast-7bytenop,-fast-bextr,-fast-dpwssd,-fast-gather,-fast-hops,-fast-imm16,-fast-lzcnt,-fast-movbe,-fast-scalar-fsqrt,-fast-scalar-shift-masks,-fast-shld-rotate,-fast-variable-crosslane-shuffle,-fast-variable-perlane-shuffle,-fast-vector-fsqrt,-fast-vector-shift-masks,-faster-shift-than-shuffle,-fma,-fma4,-fsgsbase,-fsrm,-gfni,-harden-sls-ijmp,-harden-sls-ret,-hreset,-idivl-to-divb,-inline-asm-use-gpr32,-invpcid,-kl,-lea-sp,-lea-uses-ag,-lvi-cfi,-lvi-load-hardening,-lwp,-lzcnt,-movbe,-movdir64b,-movdiri,-movrs,-mwaitx,-ndd,-nf,-no-bypass-delay,-no-bypass-delay-blend,-no-bypass-delay-mov,-no-bypass-delay-shuffle,-pad-short-functions,-pclmul,-pconfig,-pku,-popcnt,-ppx,-prefer-128-bit,-prefer-256-bit,-prefer-mask-registers,-prefer-movmsk-over-vtest,-prefer-no-gather,-prefer-no-scatter,-prefetchi,-prfchw,-ptwrite,-push2pop2,-raoint,-rdpid,-rdpru,-rdrnd,-rdseed,-retpoline,-retpoline-external-thunk,-retpoline-indirect-branches,-retpoline-indirect-calls,-rtm,-sahf,-sbb-dep-breaking,-serialize,-seses,-sgx,-sha,-sha512,-shstk,-slow-lea,-slow-pmaddwd,-slow-pmulld,-slow-shld,-slow-two-mem-ops,-slow-unaligned-mem-16,-slow-unaligned-mem-32,-sm3,-sm4,-soft-float,-sse,-sse2,-sse3,-sse4.1,-sse4.2,-sse4a,-sse-unaligned-mem,-ssse3,-tagged-globals,-tbm,-tsxldtrk,-tuning-fast-imm-vector-shift,-uintr,-use-glm-div-sqrt-costs,-use-slm-arith-costs,-usermsr,-vaes,-vpclmulqdq,-waitpkg,-wbnoinvd,-widekl,-xop,-xsave,-xsavec,-xsaveopt,-xsaves,-zu" }
attributes #7 = { minsize nofree noinline norecurse nosync nounwind optsize memory(argmem: readwrite, inaccessiblemem: write) uwtable "frame-pointer"="all" "target-cpu"="x86-64" "target-features"="+64bit,+cmov,+cx8,+fxsr,+idivq-to-divl,+macrofusion,+mmx,+nopl,+slow-3ops-lea,+slow-incdec,+vzeroupper,+x87,-16bit-mode,-32bit-mode,-adx,-aes,-allow-light-256-bit,-amx-avx512,-amx-bf16,-amx-complex,-amx-fp16,-amx-fp8,-amx-int8,-amx-movrs,-amx-tf32,-amx-tile,-amx-transpose,-avx,-avx10.1-256,-avx10.1-512,-avx10.2-256,-avx10.2-512,-avx2,-avx512bf16,-avx512bitalg,-avx512bw,-avx512cd,-avx512dq,-avx512f,-avx512fp16,-avx512ifma,-avx512vbmi,-avx512vbmi2,-avx512vl,-avx512vnni,-avx512vp2intersect,-avx512vpopcntdq,-avxifma,-avxneconvert,-avxvnni,-avxvnniint16,-avxvnniint8,-bmi,-bmi2,-branch-hint,-branchfusion,-ccmp,-cf,-cldemote,-clflushopt,-clwb,-clzero,-cmpccxadd,-crc32,-cx16,-egpr,-enqcmd,-ermsb,-evex512,-f16c,-false-deps-getmant,-false-deps-lzcnt-tzcnt,-false-deps-mulc,-false-deps-mullq,-false-deps-perm,-false-deps-popcnt,-false-deps-range,-fast-11bytenop,-fast-15bytenop,-fast-7bytenop,-fast-bextr,-fast-dpwssd,-fast-gather,-fast-hops,-fast-imm16,-fast-lzcnt,-fast-movbe,-fast-scalar-fsqrt,-fast-scalar-shift-masks,-fast-shld-rotate,-fast-variable-crosslane-shuffle,-fast-variable-perlane-shuffle,-fast-vector-fsqrt,-fast-vector-shift-masks,-faster-shift-than-shuffle,-fma,-fma4,-fsgsbase,-fsrm,-gfni,-harden-sls-ijmp,-harden-sls-ret,-hreset,-idivl-to-divb,-inline-asm-use-gpr32,-invpcid,-kl,-lea-sp,-lea-uses-ag,-lvi-cfi,-lvi-load-hardening,-lwp,-lzcnt,-movbe,-movdir64b,-movdiri,-movrs,-mwaitx,-ndd,-nf,-no-bypass-delay,-no-bypass-delay-blend,-no-bypass-delay-mov,-no-bypass-delay-shuffle,-pad-short-functions,-pclmul,-pconfig,-pku,-popcnt,-ppx,-prefer-128-bit,-prefer-256-bit,-prefer-mask-registers,-prefer-movmsk-over-vtest,-prefer-no-gather,-prefer-no-scatter,-prefetchi,-prfchw,-ptwrite,-push2pop2,-raoint,-rdpid,-rdpru,-rdrnd,-rdseed,-retpoline,-retpoline-external-thunk,-retpoline-indirect-branches,-retpoline-indirect-calls,-rtm,-sahf,-sbb-dep-breaking,-serialize,-seses,-sgx,-sha,-sha512,-shstk,-slow-lea,-slow-pmaddwd,-slow-pmulld,-slow-shld,-slow-two-mem-ops,-slow-unaligned-mem-16,-slow-unaligned-mem-32,-sm3,-sm4,-soft-float,-sse,-sse2,-sse3,-sse4.1,-sse4.2,-sse4a,-sse-unaligned-mem,-ssse3,-tagged-globals,-tbm,-tsxldtrk,-tuning-fast-imm-vector-shift,-uintr,-use-glm-div-sqrt-costs,-use-slm-arith-costs,-usermsr,-vaes,-vpclmulqdq,-waitpkg,-wbnoinvd,-widekl,-xop,-xsave,-xsavec,-xsaveopt,-xsaves,-zu" }
attributes #8 = { minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(argmem: readwrite, inaccessiblemem: readwrite) uwtable "frame-pointer"="all" "target-cpu"="x86-64" "target-features"="+64bit,+cmov,+cx8,+fxsr,+idivq-to-divl,+macrofusion,+mmx,+nopl,+slow-3ops-lea,+slow-incdec,+vzeroupper,+x87,-16bit-mode,-32bit-mode,-adx,-aes,-allow-light-256-bit,-amx-avx512,-amx-bf16,-amx-complex,-amx-fp16,-amx-fp8,-amx-int8,-amx-movrs,-amx-tf32,-amx-tile,-amx-transpose,-avx,-avx10.1-256,-avx10.1-512,-avx10.2-256,-avx10.2-512,-avx2,-avx512bf16,-avx512bitalg,-avx512bw,-avx512cd,-avx512dq,-avx512f,-avx512fp16,-avx512ifma,-avx512vbmi,-avx512vbmi2,-avx512vl,-avx512vnni,-avx512vp2intersect,-avx512vpopcntdq,-avxifma,-avxneconvert,-avxvnni,-avxvnniint16,-avxvnniint8,-bmi,-bmi2,-branch-hint,-branchfusion,-ccmp,-cf,-cldemote,-clflushopt,-clwb,-clzero,-cmpccxadd,-crc32,-cx16,-egpr,-enqcmd,-ermsb,-evex512,-f16c,-false-deps-getmant,-false-deps-lzcnt-tzcnt,-false-deps-mulc,-false-deps-mullq,-false-deps-perm,-false-deps-popcnt,-false-deps-range,-fast-11bytenop,-fast-15bytenop,-fast-7bytenop,-fast-bextr,-fast-dpwssd,-fast-gather,-fast-hops,-fast-imm16,-fast-lzcnt,-fast-movbe,-fast-scalar-fsqrt,-fast-scalar-shift-masks,-fast-shld-rotate,-fast-variable-crosslane-shuffle,-fast-variable-perlane-shuffle,-fast-vector-fsqrt,-fast-vector-shift-masks,-faster-shift-than-shuffle,-fma,-fma4,-fsgsbase,-fsrm,-gfni,-harden-sls-ijmp,-harden-sls-ret,-hreset,-idivl-to-divb,-inline-asm-use-gpr32,-invpcid,-kl,-lea-sp,-lea-uses-ag,-lvi-cfi,-lvi-load-hardening,-lwp,-lzcnt,-movbe,-movdir64b,-movdiri,-movrs,-mwaitx,-ndd,-nf,-no-bypass-delay,-no-bypass-delay-blend,-no-bypass-delay-mov,-no-bypass-delay-shuffle,-pad-short-functions,-pclmul,-pconfig,-pku,-popcnt,-ppx,-prefer-128-bit,-prefer-256-bit,-prefer-mask-registers,-prefer-movmsk-over-vtest,-prefer-no-gather,-prefer-no-scatter,-prefetchi,-prfchw,-ptwrite,-push2pop2,-raoint,-rdpid,-rdpru,-rdrnd,-rdseed,-retpoline,-retpoline-external-thunk,-retpoline-indirect-branches,-retpoline-indirect-calls,-rtm,-sahf,-sbb-dep-breaking,-serialize,-seses,-sgx,-sha,-sha512,-shstk,-slow-lea,-slow-pmaddwd,-slow-pmulld,-slow-shld,-slow-two-mem-ops,-slow-unaligned-mem-16,-slow-unaligned-mem-32,-sm3,-sm4,-soft-float,-sse,-sse2,-sse3,-sse4.1,-sse4.2,-sse4a,-sse-unaligned-mem,-ssse3,-tagged-globals,-tbm,-tsxldtrk,-tuning-fast-imm-vector-shift,-uintr,-use-glm-div-sqrt-costs,-use-slm-arith-costs,-usermsr,-vaes,-vpclmulqdq,-waitpkg,-wbnoinvd,-widekl,-xop,-xsave,-xsavec,-xsaveopt,-xsaves,-zu" }
attributes #9 = { minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(argmem: readwrite) uwtable "frame-pointer"="all" "target-cpu"="x86-64" "target-features"="+64bit,+cmov,+cx8,+fxsr,+idivq-to-divl,+macrofusion,+mmx,+nopl,+slow-3ops-lea,+slow-incdec,+vzeroupper,+x87,-16bit-mode,-32bit-mode,-adx,-aes,-allow-light-256-bit,-amx-avx512,-amx-bf16,-amx-complex,-amx-fp16,-amx-fp8,-amx-int8,-amx-movrs,-amx-tf32,-amx-tile,-amx-transpose,-avx,-avx10.1-256,-avx10.1-512,-avx10.2-256,-avx10.2-512,-avx2,-avx512bf16,-avx512bitalg,-avx512bw,-avx512cd,-avx512dq,-avx512f,-avx512fp16,-avx512ifma,-avx512vbmi,-avx512vbmi2,-avx512vl,-avx512vnni,-avx512vp2intersect,-avx512vpopcntdq,-avxifma,-avxneconvert,-avxvnni,-avxvnniint16,-avxvnniint8,-bmi,-bmi2,-branch-hint,-branchfusion,-ccmp,-cf,-cldemote,-clflushopt,-clwb,-clzero,-cmpccxadd,-crc32,-cx16,-egpr,-enqcmd,-ermsb,-evex512,-f16c,-false-deps-getmant,-false-deps-lzcnt-tzcnt,-false-deps-mulc,-false-deps-mullq,-false-deps-perm,-false-deps-popcnt,-false-deps-range,-fast-11bytenop,-fast-15bytenop,-fast-7bytenop,-fast-bextr,-fast-dpwssd,-fast-gather,-fast-hops,-fast-imm16,-fast-lzcnt,-fast-movbe,-fast-scalar-fsqrt,-fast-scalar-shift-masks,-fast-shld-rotate,-fast-variable-crosslane-shuffle,-fast-variable-perlane-shuffle,-fast-vector-fsqrt,-fast-vector-shift-masks,-faster-shift-than-shuffle,-fma,-fma4,-fsgsbase,-fsrm,-gfni,-harden-sls-ijmp,-harden-sls-ret,-hreset,-idivl-to-divb,-inline-asm-use-gpr32,-invpcid,-kl,-lea-sp,-lea-uses-ag,-lvi-cfi,-lvi-load-hardening,-lwp,-lzcnt,-movbe,-movdir64b,-movdiri,-movrs,-mwaitx,-ndd,-nf,-no-bypass-delay,-no-bypass-delay-blend,-no-bypass-delay-mov,-no-bypass-delay-shuffle,-pad-short-functions,-pclmul,-pconfig,-pku,-popcnt,-ppx,-prefer-128-bit,-prefer-256-bit,-prefer-mask-registers,-prefer-movmsk-over-vtest,-prefer-no-gather,-prefer-no-scatter,-prefetchi,-prfchw,-ptwrite,-push2pop2,-raoint,-rdpid,-rdpru,-rdrnd,-rdseed,-retpoline,-retpoline-external-thunk,-retpoline-indirect-branches,-retpoline-indirect-calls,-rtm,-sahf,-sbb-dep-breaking,-serialize,-seses,-sgx,-sha,-sha512,-shstk,-slow-lea,-slow-pmaddwd,-slow-pmulld,-slow-shld,-slow-two-mem-ops,-slow-unaligned-mem-16,-slow-unaligned-mem-32,-sm3,-sm4,-soft-float,-sse,-sse2,-sse3,-sse4.1,-sse4.2,-sse4a,-sse-unaligned-mem,-ssse3,-tagged-globals,-tbm,-tsxldtrk,-tuning-fast-imm-vector-shift,-uintr,-use-glm-div-sqrt-costs,-use-slm-arith-costs,-usermsr,-vaes,-vpclmulqdq,-waitpkg,-wbnoinvd,-widekl,-xop,-xsave,-xsavec,-xsaveopt,-xsaves,-zu" }
attributes #10 = { minsize mustprogress nofree noinline norecurse nosync nounwind optsize willreturn memory(argmem: readwrite) uwtable "frame-pointer"="all" "target-cpu"="x86-64" "target-features"="+64bit,+cmov,+cx8,+fxsr,+idivq-to-divl,+macrofusion,+mmx,+nopl,+slow-3ops-lea,+slow-incdec,+vzeroupper,+x87,-16bit-mode,-32bit-mode,-adx,-aes,-allow-light-256-bit,-amx-avx512,-amx-bf16,-amx-complex,-amx-fp16,-amx-fp8,-amx-int8,-amx-movrs,-amx-tf32,-amx-tile,-amx-transpose,-avx,-avx10.1-256,-avx10.1-512,-avx10.2-256,-avx10.2-512,-avx2,-avx512bf16,-avx512bitalg,-avx512bw,-avx512cd,-avx512dq,-avx512f,-avx512fp16,-avx512ifma,-avx512vbmi,-avx512vbmi2,-avx512vl,-avx512vnni,-avx512vp2intersect,-avx512vpopcntdq,-avxifma,-avxneconvert,-avxvnni,-avxvnniint16,-avxvnniint8,-bmi,-bmi2,-branch-hint,-branchfusion,-ccmp,-cf,-cldemote,-clflushopt,-clwb,-clzero,-cmpccxadd,-crc32,-cx16,-egpr,-enqcmd,-ermsb,-evex512,-f16c,-false-deps-getmant,-false-deps-lzcnt-tzcnt,-false-deps-mulc,-false-deps-mullq,-false-deps-perm,-false-deps-popcnt,-false-deps-range,-fast-11bytenop,-fast-15bytenop,-fast-7bytenop,-fast-bextr,-fast-dpwssd,-fast-gather,-fast-hops,-fast-imm16,-fast-lzcnt,-fast-movbe,-fast-scalar-fsqrt,-fast-scalar-shift-masks,-fast-shld-rotate,-fast-variable-crosslane-shuffle,-fast-variable-perlane-shuffle,-fast-vector-fsqrt,-fast-vector-shift-masks,-faster-shift-than-shuffle,-fma,-fma4,-fsgsbase,-fsrm,-gfni,-harden-sls-ijmp,-harden-sls-ret,-hreset,-idivl-to-divb,-inline-asm-use-gpr32,-invpcid,-kl,-lea-sp,-lea-uses-ag,-lvi-cfi,-lvi-load-hardening,-lwp,-lzcnt,-movbe,-movdir64b,-movdiri,-movrs,-mwaitx,-ndd,-nf,-no-bypass-delay,-no-bypass-delay-blend,-no-bypass-delay-mov,-no-bypass-delay-shuffle,-pad-short-functions,-pclmul,-pconfig,-pku,-popcnt,-ppx,-prefer-128-bit,-prefer-256-bit,-prefer-mask-registers,-prefer-movmsk-over-vtest,-prefer-no-gather,-prefer-no-scatter,-prefetchi,-prfchw,-ptwrite,-push2pop2,-raoint,-rdpid,-rdpru,-rdrnd,-rdseed,-retpoline,-retpoline-external-thunk,-retpoline-indirect-branches,-retpoline-indirect-calls,-rtm,-sahf,-sbb-dep-breaking,-serialize,-seses,-sgx,-sha,-sha512,-shstk,-slow-lea,-slow-pmaddwd,-slow-pmulld,-slow-shld,-slow-two-mem-ops,-slow-unaligned-mem-16,-slow-unaligned-mem-32,-sm3,-sm4,-soft-float,-sse,-sse2,-sse3,-sse4.1,-sse4.2,-sse4a,-sse-unaligned-mem,-ssse3,-tagged-globals,-tbm,-tsxldtrk,-tuning-fast-imm-vector-shift,-uintr,-use-glm-div-sqrt-costs,-use-slm-arith-costs,-usermsr,-vaes,-vpclmulqdq,-waitpkg,-wbnoinvd,-widekl,-xop,-xsave,-xsavec,-xsaveopt,-xsaves,-zu" }
attributes #11 = { minsize nofree noinline norecurse nosync nounwind optsize memory(argmem: read) uwtable "frame-pointer"="all" "target-cpu"="x86-64" "target-features"="+64bit,+cmov,+cx8,+fxsr,+idivq-to-divl,+macrofusion,+mmx,+nopl,+slow-3ops-lea,+slow-incdec,+vzeroupper,+x87,-16bit-mode,-32bit-mode,-adx,-aes,-allow-light-256-bit,-amx-avx512,-amx-bf16,-amx-complex,-amx-fp16,-amx-fp8,-amx-int8,-amx-movrs,-amx-tf32,-amx-tile,-amx-transpose,-avx,-avx10.1-256,-avx10.1-512,-avx10.2-256,-avx10.2-512,-avx2,-avx512bf16,-avx512bitalg,-avx512bw,-avx512cd,-avx512dq,-avx512f,-avx512fp16,-avx512ifma,-avx512vbmi,-avx512vbmi2,-avx512vl,-avx512vnni,-avx512vp2intersect,-avx512vpopcntdq,-avxifma,-avxneconvert,-avxvnni,-avxvnniint16,-avxvnniint8,-bmi,-bmi2,-branch-hint,-branchfusion,-ccmp,-cf,-cldemote,-clflushopt,-clwb,-clzero,-cmpccxadd,-crc32,-cx16,-egpr,-enqcmd,-ermsb,-evex512,-f16c,-false-deps-getmant,-false-deps-lzcnt-tzcnt,-false-deps-mulc,-false-deps-mullq,-false-deps-perm,-false-deps-popcnt,-false-deps-range,-fast-11bytenop,-fast-15bytenop,-fast-7bytenop,-fast-bextr,-fast-dpwssd,-fast-gather,-fast-hops,-fast-imm16,-fast-lzcnt,-fast-movbe,-fast-scalar-fsqrt,-fast-scalar-shift-masks,-fast-shld-rotate,-fast-variable-crosslane-shuffle,-fast-variable-perlane-shuffle,-fast-vector-fsqrt,-fast-vector-shift-masks,-faster-shift-than-shuffle,-fma,-fma4,-fsgsbase,-fsrm,-gfni,-harden-sls-ijmp,-harden-sls-ret,-hreset,-idivl-to-divb,-inline-asm-use-gpr32,-invpcid,-kl,-lea-sp,-lea-uses-ag,-lvi-cfi,-lvi-load-hardening,-lwp,-lzcnt,-movbe,-movdir64b,-movdiri,-movrs,-mwaitx,-ndd,-nf,-no-bypass-delay,-no-bypass-delay-blend,-no-bypass-delay-mov,-no-bypass-delay-shuffle,-pad-short-functions,-pclmul,-pconfig,-pku,-popcnt,-ppx,-prefer-128-bit,-prefer-256-bit,-prefer-mask-registers,-prefer-movmsk-over-vtest,-prefer-no-gather,-prefer-no-scatter,-prefetchi,-prfchw,-ptwrite,-push2pop2,-raoint,-rdpid,-rdpru,-rdrnd,-rdseed,-retpoline,-retpoline-external-thunk,-retpoline-indirect-branches,-retpoline-indirect-calls,-rtm,-sahf,-sbb-dep-breaking,-serialize,-seses,-sgx,-sha,-sha512,-shstk,-slow-lea,-slow-pmaddwd,-slow-pmulld,-slow-shld,-slow-two-mem-ops,-slow-unaligned-mem-16,-slow-unaligned-mem-32,-sm3,-sm4,-soft-float,-sse,-sse2,-sse3,-sse4.1,-sse4.2,-sse4a,-sse-unaligned-mem,-ssse3,-tagged-globals,-tbm,-tsxldtrk,-tuning-fast-imm-vector-shift,-uintr,-use-glm-div-sqrt-costs,-use-slm-arith-costs,-usermsr,-vaes,-vpclmulqdq,-waitpkg,-wbnoinvd,-widekl,-xop,-xsave,-xsavec,-xsaveopt,-xsaves,-zu" }
attributes #12 = { minsize nofree norecurse nosync nounwind optsize memory(argmem: readwrite, inaccessiblemem: readwrite) uwtable "frame-pointer"="all" "target-cpu"="x86-64" "target-features"="+64bit,+cmov,+cx8,+fxsr,+idivq-to-divl,+macrofusion,+mmx,+nopl,+slow-3ops-lea,+slow-incdec,+vzeroupper,+x87,-16bit-mode,-32bit-mode,-adx,-aes,-allow-light-256-bit,-amx-avx512,-amx-bf16,-amx-complex,-amx-fp16,-amx-fp8,-amx-int8,-amx-movrs,-amx-tf32,-amx-tile,-amx-transpose,-avx,-avx10.1-256,-avx10.1-512,-avx10.2-256,-avx10.2-512,-avx2,-avx512bf16,-avx512bitalg,-avx512bw,-avx512cd,-avx512dq,-avx512f,-avx512fp16,-avx512ifma,-avx512vbmi,-avx512vbmi2,-avx512vl,-avx512vnni,-avx512vp2intersect,-avx512vpopcntdq,-avxifma,-avxneconvert,-avxvnni,-avxvnniint16,-avxvnniint8,-bmi,-bmi2,-branch-hint,-branchfusion,-ccmp,-cf,-cldemote,-clflushopt,-clwb,-clzero,-cmpccxadd,-crc32,-cx16,-egpr,-enqcmd,-ermsb,-evex512,-f16c,-false-deps-getmant,-false-deps-lzcnt-tzcnt,-false-deps-mulc,-false-deps-mullq,-false-deps-perm,-false-deps-popcnt,-false-deps-range,-fast-11bytenop,-fast-15bytenop,-fast-7bytenop,-fast-bextr,-fast-dpwssd,-fast-gather,-fast-hops,-fast-imm16,-fast-lzcnt,-fast-movbe,-fast-scalar-fsqrt,-fast-scalar-shift-masks,-fast-shld-rotate,-fast-variable-crosslane-shuffle,-fast-variable-perlane-shuffle,-fast-vector-fsqrt,-fast-vector-shift-masks,-faster-shift-than-shuffle,-fma,-fma4,-fsgsbase,-fsrm,-gfni,-harden-sls-ijmp,-harden-sls-ret,-hreset,-idivl-to-divb,-inline-asm-use-gpr32,-invpcid,-kl,-lea-sp,-lea-uses-ag,-lvi-cfi,-lvi-load-hardening,-lwp,-lzcnt,-movbe,-movdir64b,-movdiri,-movrs,-mwaitx,-ndd,-nf,-no-bypass-delay,-no-bypass-delay-blend,-no-bypass-delay-mov,-no-bypass-delay-shuffle,-pad-short-functions,-pclmul,-pconfig,-pku,-popcnt,-ppx,-prefer-128-bit,-prefer-256-bit,-prefer-mask-registers,-prefer-movmsk-over-vtest,-prefer-no-gather,-prefer-no-scatter,-prefetchi,-prfchw,-ptwrite,-push2pop2,-raoint,-rdpid,-rdpru,-rdrnd,-rdseed,-retpoline,-retpoline-external-thunk,-retpoline-indirect-branches,-retpoline-indirect-calls,-rtm,-sahf,-sbb-dep-breaking,-serialize,-seses,-sgx,-sha,-sha512,-shstk,-slow-lea,-slow-pmaddwd,-slow-pmulld,-slow-shld,-slow-two-mem-ops,-slow-unaligned-mem-16,-slow-unaligned-mem-32,-sm3,-sm4,-soft-float,-sse,-sse2,-sse3,-sse4.1,-sse4.2,-sse4a,-sse-unaligned-mem,-ssse3,-tagged-globals,-tbm,-tsxldtrk,-tuning-fast-imm-vector-shift,-uintr,-use-glm-div-sqrt-costs,-use-slm-arith-costs,-usermsr,-vaes,-vpclmulqdq,-waitpkg,-wbnoinvd,-widekl,-xop,-xsave,-xsavec,-xsaveopt,-xsaves,-zu" }
attributes #13 = { minsize nofree norecurse nosync nounwind optsize memory(argmem: readwrite) uwtable "frame-pointer"="all" "target-cpu"="x86-64" "target-features"="+64bit,+cmov,+cx8,+fxsr,+idivq-to-divl,+macrofusion,+mmx,+nopl,+slow-3ops-lea,+slow-incdec,+vzeroupper,+x87,-16bit-mode,-32bit-mode,-adx,-aes,-allow-light-256-bit,-amx-avx512,-amx-bf16,-amx-complex,-amx-fp16,-amx-fp8,-amx-int8,-amx-movrs,-amx-tf32,-amx-tile,-amx-transpose,-avx,-avx10.1-256,-avx10.1-512,-avx10.2-256,-avx10.2-512,-avx2,-avx512bf16,-avx512bitalg,-avx512bw,-avx512cd,-avx512dq,-avx512f,-avx512fp16,-avx512ifma,-avx512vbmi,-avx512vbmi2,-avx512vl,-avx512vnni,-avx512vp2intersect,-avx512vpopcntdq,-avxifma,-avxneconvert,-avxvnni,-avxvnniint16,-avxvnniint8,-bmi,-bmi2,-branch-hint,-branchfusion,-ccmp,-cf,-cldemote,-clflushopt,-clwb,-clzero,-cmpccxadd,-crc32,-cx16,-egpr,-enqcmd,-ermsb,-evex512,-f16c,-false-deps-getmant,-false-deps-lzcnt-tzcnt,-false-deps-mulc,-false-deps-mullq,-false-deps-perm,-false-deps-popcnt,-false-deps-range,-fast-11bytenop,-fast-15bytenop,-fast-7bytenop,-fast-bextr,-fast-dpwssd,-fast-gather,-fast-hops,-fast-imm16,-fast-lzcnt,-fast-movbe,-fast-scalar-fsqrt,-fast-scalar-shift-masks,-fast-shld-rotate,-fast-variable-crosslane-shuffle,-fast-variable-perlane-shuffle,-fast-vector-fsqrt,-fast-vector-shift-masks,-faster-shift-than-shuffle,-fma,-fma4,-fsgsbase,-fsrm,-gfni,-harden-sls-ijmp,-harden-sls-ret,-hreset,-idivl-to-divb,-inline-asm-use-gpr32,-invpcid,-kl,-lea-sp,-lea-uses-ag,-lvi-cfi,-lvi-load-hardening,-lwp,-lzcnt,-movbe,-movdir64b,-movdiri,-movrs,-mwaitx,-ndd,-nf,-no-bypass-delay,-no-bypass-delay-blend,-no-bypass-delay-mov,-no-bypass-delay-shuffle,-pad-short-functions,-pclmul,-pconfig,-pku,-popcnt,-ppx,-prefer-128-bit,-prefer-256-bit,-prefer-mask-registers,-prefer-movmsk-over-vtest,-prefer-no-gather,-prefer-no-scatter,-prefetchi,-prfchw,-ptwrite,-push2pop2,-raoint,-rdpid,-rdpru,-rdrnd,-rdseed,-retpoline,-retpoline-external-thunk,-retpoline-indirect-branches,-retpoline-indirect-calls,-rtm,-sahf,-sbb-dep-breaking,-serialize,-seses,-sgx,-sha,-sha512,-shstk,-slow-lea,-slow-pmaddwd,-slow-pmulld,-slow-shld,-slow-two-mem-ops,-slow-unaligned-mem-16,-slow-unaligned-mem-32,-sm3,-sm4,-soft-float,-sse,-sse2,-sse3,-sse4.1,-sse4.2,-sse4a,-sse-unaligned-mem,-ssse3,-tagged-globals,-tbm,-tsxldtrk,-tuning-fast-imm-vector-shift,-uintr,-use-glm-div-sqrt-costs,-use-slm-arith-costs,-usermsr,-vaes,-vpclmulqdq,-waitpkg,-wbnoinvd,-widekl,-xop,-xsave,-xsavec,-xsaveopt,-xsaves,-zu" }
attributes #14 = { mustprogress nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: write) }
attributes #15 = { mustprogress nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #16 = { minsize nofree norecurse nosync nounwind optsize memory(read, argmem: readwrite, inaccessiblemem: write) uwtable "frame-pointer"="all" "target-cpu"="x86-64" "target-features"="+64bit,+cmov,+cx8,+fxsr,+idivq-to-divl,+macrofusion,+mmx,+nopl,+slow-3ops-lea,+slow-incdec,+vzeroupper,+x87,-16bit-mode,-32bit-mode,-adx,-aes,-allow-light-256-bit,-amx-avx512,-amx-bf16,-amx-complex,-amx-fp16,-amx-fp8,-amx-int8,-amx-movrs,-amx-tf32,-amx-tile,-amx-transpose,-avx,-avx10.1-256,-avx10.1-512,-avx10.2-256,-avx10.2-512,-avx2,-avx512bf16,-avx512bitalg,-avx512bw,-avx512cd,-avx512dq,-avx512f,-avx512fp16,-avx512ifma,-avx512vbmi,-avx512vbmi2,-avx512vl,-avx512vnni,-avx512vp2intersect,-avx512vpopcntdq,-avxifma,-avxneconvert,-avxvnni,-avxvnniint16,-avxvnniint8,-bmi,-bmi2,-branch-hint,-branchfusion,-ccmp,-cf,-cldemote,-clflushopt,-clwb,-clzero,-cmpccxadd,-crc32,-cx16,-egpr,-enqcmd,-ermsb,-evex512,-f16c,-false-deps-getmant,-false-deps-lzcnt-tzcnt,-false-deps-mulc,-false-deps-mullq,-false-deps-perm,-false-deps-popcnt,-false-deps-range,-fast-11bytenop,-fast-15bytenop,-fast-7bytenop,-fast-bextr,-fast-dpwssd,-fast-gather,-fast-hops,-fast-imm16,-fast-lzcnt,-fast-movbe,-fast-scalar-fsqrt,-fast-scalar-shift-masks,-fast-shld-rotate,-fast-variable-crosslane-shuffle,-fast-variable-perlane-shuffle,-fast-vector-fsqrt,-fast-vector-shift-masks,-faster-shift-than-shuffle,-fma,-fma4,-fsgsbase,-fsrm,-gfni,-harden-sls-ijmp,-harden-sls-ret,-hreset,-idivl-to-divb,-inline-asm-use-gpr32,-invpcid,-kl,-lea-sp,-lea-uses-ag,-lvi-cfi,-lvi-load-hardening,-lwp,-lzcnt,-movbe,-movdir64b,-movdiri,-movrs,-mwaitx,-ndd,-nf,-no-bypass-delay,-no-bypass-delay-blend,-no-bypass-delay-mov,-no-bypass-delay-shuffle,-pad-short-functions,-pclmul,-pconfig,-pku,-popcnt,-ppx,-prefer-128-bit,-prefer-256-bit,-prefer-mask-registers,-prefer-movmsk-over-vtest,-prefer-no-gather,-prefer-no-scatter,-prefetchi,-prfchw,-ptwrite,-push2pop2,-raoint,-rdpid,-rdpru,-rdrnd,-rdseed,-retpoline,-retpoline-external-thunk,-retpoline-indirect-branches,-retpoline-indirect-calls,-rtm,-sahf,-sbb-dep-breaking,-serialize,-seses,-sgx,-sha,-sha512,-shstk,-slow-lea,-slow-pmaddwd,-slow-pmulld,-slow-shld,-slow-two-mem-ops,-slow-unaligned-mem-16,-slow-unaligned-mem-32,-sm3,-sm4,-soft-float,-sse,-sse2,-sse3,-sse4.1,-sse4.2,-sse4a,-sse-unaligned-mem,-ssse3,-tagged-globals,-tbm,-tsxldtrk,-tuning-fast-imm-vector-shift,-uintr,-use-glm-div-sqrt-costs,-use-slm-arith-costs,-usermsr,-vaes,-vpclmulqdq,-waitpkg,-wbnoinvd,-widekl,-xop,-xsave,-xsavec,-xsaveopt,-xsaves,-zu" }
attributes #17 = { minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(argmem: readwrite, inaccessiblemem: write) uwtable "frame-pointer"="all" "target-cpu"="x86-64" "target-features"="+64bit,+cmov,+cx8,+fxsr,+idivq-to-divl,+macrofusion,+mmx,+nopl,+slow-3ops-lea,+slow-incdec,+vzeroupper,+x87,-16bit-mode,-32bit-mode,-adx,-aes,-allow-light-256-bit,-amx-avx512,-amx-bf16,-amx-complex,-amx-fp16,-amx-fp8,-amx-int8,-amx-movrs,-amx-tf32,-amx-tile,-amx-transpose,-avx,-avx10.1-256,-avx10.1-512,-avx10.2-256,-avx10.2-512,-avx2,-avx512bf16,-avx512bitalg,-avx512bw,-avx512cd,-avx512dq,-avx512f,-avx512fp16,-avx512ifma,-avx512vbmi,-avx512vbmi2,-avx512vl,-avx512vnni,-avx512vp2intersect,-avx512vpopcntdq,-avxifma,-avxneconvert,-avxvnni,-avxvnniint16,-avxvnniint8,-bmi,-bmi2,-branch-hint,-branchfusion,-ccmp,-cf,-cldemote,-clflushopt,-clwb,-clzero,-cmpccxadd,-crc32,-cx16,-egpr,-enqcmd,-ermsb,-evex512,-f16c,-false-deps-getmant,-false-deps-lzcnt-tzcnt,-false-deps-mulc,-false-deps-mullq,-false-deps-perm,-false-deps-popcnt,-false-deps-range,-fast-11bytenop,-fast-15bytenop,-fast-7bytenop,-fast-bextr,-fast-dpwssd,-fast-gather,-fast-hops,-fast-imm16,-fast-lzcnt,-fast-movbe,-fast-scalar-fsqrt,-fast-scalar-shift-masks,-fast-shld-rotate,-fast-variable-crosslane-shuffle,-fast-variable-perlane-shuffle,-fast-vector-fsqrt,-fast-vector-shift-masks,-faster-shift-than-shuffle,-fma,-fma4,-fsgsbase,-fsrm,-gfni,-harden-sls-ijmp,-harden-sls-ret,-hreset,-idivl-to-divb,-inline-asm-use-gpr32,-invpcid,-kl,-lea-sp,-lea-uses-ag,-lvi-cfi,-lvi-load-hardening,-lwp,-lzcnt,-movbe,-movdir64b,-movdiri,-movrs,-mwaitx,-ndd,-nf,-no-bypass-delay,-no-bypass-delay-blend,-no-bypass-delay-mov,-no-bypass-delay-shuffle,-pad-short-functions,-pclmul,-pconfig,-pku,-popcnt,-ppx,-prefer-128-bit,-prefer-256-bit,-prefer-mask-registers,-prefer-movmsk-over-vtest,-prefer-no-gather,-prefer-no-scatter,-prefetchi,-prfchw,-ptwrite,-push2pop2,-raoint,-rdpid,-rdpru,-rdrnd,-rdseed,-retpoline,-retpoline-external-thunk,-retpoline-indirect-branches,-retpoline-indirect-calls,-rtm,-sahf,-sbb-dep-breaking,-serialize,-seses,-sgx,-sha,-sha512,-shstk,-slow-lea,-slow-pmaddwd,-slow-pmulld,-slow-shld,-slow-two-mem-ops,-slow-unaligned-mem-16,-slow-unaligned-mem-32,-sm3,-sm4,-soft-float,-sse,-sse2,-sse3,-sse4.1,-sse4.2,-sse4a,-sse-unaligned-mem,-ssse3,-tagged-globals,-tbm,-tsxldtrk,-tuning-fast-imm-vector-shift,-uintr,-use-glm-div-sqrt-costs,-use-slm-arith-costs,-usermsr,-vaes,-vpclmulqdq,-waitpkg,-wbnoinvd,-widekl,-xop,-xsave,-xsavec,-xsaveopt,-xsaves,-zu" }
attributes #18 = { minsize mustprogress nofree noinline norecurse nosync nounwind optsize willreturn memory(argmem: read) uwtable "frame-pointer"="all" "target-cpu"="x86-64" "target-features"="+64bit,+cmov,+cx8,+fxsr,+idivq-to-divl,+macrofusion,+mmx,+nopl,+slow-3ops-lea,+slow-incdec,+vzeroupper,+x87,-16bit-mode,-32bit-mode,-adx,-aes,-allow-light-256-bit,-amx-avx512,-amx-bf16,-amx-complex,-amx-fp16,-amx-fp8,-amx-int8,-amx-movrs,-amx-tf32,-amx-tile,-amx-transpose,-avx,-avx10.1-256,-avx10.1-512,-avx10.2-256,-avx10.2-512,-avx2,-avx512bf16,-avx512bitalg,-avx512bw,-avx512cd,-avx512dq,-avx512f,-avx512fp16,-avx512ifma,-avx512vbmi,-avx512vbmi2,-avx512vl,-avx512vnni,-avx512vp2intersect,-avx512vpopcntdq,-avxifma,-avxneconvert,-avxvnni,-avxvnniint16,-avxvnniint8,-bmi,-bmi2,-branch-hint,-branchfusion,-ccmp,-cf,-cldemote,-clflushopt,-clwb,-clzero,-cmpccxadd,-crc32,-cx16,-egpr,-enqcmd,-ermsb,-evex512,-f16c,-false-deps-getmant,-false-deps-lzcnt-tzcnt,-false-deps-mulc,-false-deps-mullq,-false-deps-perm,-false-deps-popcnt,-false-deps-range,-fast-11bytenop,-fast-15bytenop,-fast-7bytenop,-fast-bextr,-fast-dpwssd,-fast-gather,-fast-hops,-fast-imm16,-fast-lzcnt,-fast-movbe,-fast-scalar-fsqrt,-fast-scalar-shift-masks,-fast-shld-rotate,-fast-variable-crosslane-shuffle,-fast-variable-perlane-shuffle,-fast-vector-fsqrt,-fast-vector-shift-masks,-faster-shift-than-shuffle,-fma,-fma4,-fsgsbase,-fsrm,-gfni,-harden-sls-ijmp,-harden-sls-ret,-hreset,-idivl-to-divb,-inline-asm-use-gpr32,-invpcid,-kl,-lea-sp,-lea-uses-ag,-lvi-cfi,-lvi-load-hardening,-lwp,-lzcnt,-movbe,-movdir64b,-movdiri,-movrs,-mwaitx,-ndd,-nf,-no-bypass-delay,-no-bypass-delay-blend,-no-bypass-delay-mov,-no-bypass-delay-shuffle,-pad-short-functions,-pclmul,-pconfig,-pku,-popcnt,-ppx,-prefer-128-bit,-prefer-256-bit,-prefer-mask-registers,-prefer-movmsk-over-vtest,-prefer-no-gather,-prefer-no-scatter,-prefetchi,-prfchw,-ptwrite,-push2pop2,-raoint,-rdpid,-rdpru,-rdrnd,-rdseed,-retpoline,-retpoline-external-thunk,-retpoline-indirect-branches,-retpoline-indirect-calls,-rtm,-sahf,-sbb-dep-breaking,-serialize,-seses,-sgx,-sha,-sha512,-shstk,-slow-lea,-slow-pmaddwd,-slow-pmulld,-slow-shld,-slow-two-mem-ops,-slow-unaligned-mem-16,-slow-unaligned-mem-32,-sm3,-sm4,-soft-float,-sse,-sse2,-sse3,-sse4.1,-sse4.2,-sse4a,-sse-unaligned-mem,-ssse3,-tagged-globals,-tbm,-tsxldtrk,-tuning-fast-imm-vector-shift,-uintr,-use-glm-div-sqrt-costs,-use-slm-arith-costs,-usermsr,-vaes,-vpclmulqdq,-waitpkg,-wbnoinvd,-widekl,-xop,-xsave,-xsavec,-xsaveopt,-xsaves,-zu" }
attributes #19 = { nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: readwrite) }
attributes #20 = { nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #21 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }

!llvm.module.flags = !{}

!0 = !{!"branch_weights", i32 2000, i32 1}
!1 = !{!2}
!2 = distinct !{!2, !3, !"ScalarDouble.fromBytes64: argument 0"}
!3 = distinct !{!3, !"ScalarDouble.fromBytes64"}
!4 = !{!5}
!5 = distinct !{!5, !6, !"ScalarDouble.toBytes: argument 0"}
!6 = distinct !{!6, !"ScalarDouble.toBytes"}
!7 = !{!8}
!8 = distinct !{!8, !9, !"Fe.fromBytes: argument 0"}
!9 = distinct !{!9, !"Fe.fromBytes"}
!10 = !{!11}
!11 = distinct !{!11, !12, !"Fe.pow2523: argument 0"}
!12 = distinct !{!12, !"Fe.pow2523"}
!13 = !{!14}
!14 = distinct !{!14, !15, !"Fe.add: argument 0"}
!15 = distinct !{!15, !"Fe.add"}
!16 = !{!17}
!17 = distinct !{!17, !18, !"Fe.toBytes: argument 0"}
!18 = distinct !{!18, !"Fe.toBytes"}
!19 = !{!20}
!20 = distinct !{!20, !21, !"ScalarDouble.fromBytes32: argument 0"}
!21 = distinct !{!21, !"ScalarDouble.fromBytes32"}
!22 = !{!23}
!23 = distinct !{!23, !24, !"Fe.add: argument 0"}
!24 = distinct !{!24, !"Fe.add"}
!25 = !{!26}
!26 = distinct !{!26, !27, !"Fe.sq2: argument 0"}
!27 = distinct !{!27, !"Fe.sq2"}
!28 = !{!29, !26}
!29 = distinct !{!29, !30, !"Fe._sq__anon_17953: argument 0"}
!30 = distinct !{!30, !"Fe._sq__anon_17953"}
!31 = !{!32}
!32 = distinct !{!32, !33, !"reduce: argument 0"}
!33 = distinct !{!33, !"reduce"}
!34 = !{!35}
!35 = distinct !{!35, !36, !"Fe.add: argument 0"}
!36 = distinct !{!36, !"Fe.add"}
!37 = !{!38}
!38 = distinct !{!38, !39, !"Fe.add: argument 0"}
!39 = distinct !{!39, !"Fe.add"}
!40 = !{!41}
!41 = distinct !{!41, !42, !"Fe.add: argument 0"}
!42 = distinct !{!42, !"Fe.add"}
!43 = !{!44}
!44 = distinct !{!44, !45, !"Fe._sq__anon_17901: argument 0"}
!45 = distinct !{!45, !"Fe._sq__anon_17901"}
