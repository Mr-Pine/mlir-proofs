"llvm.func"() <{CConv = #llvm.cconv<fastcc>, arg_attrs = [{llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}, {llvm.noalias, llvm.nocapture, llvm.nofree, llvm.nonnull, llvm.noundef, llvm.readonly}], dso_local, function_type = !llvm.func<i8 (ptr, ptr)>, inline_hint, linkage = #llvm.linkage<internal>, memory_effects = #llvm.memory_effects<other = none, argMem = read, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_unwind, passthrough = ["mustprogress", "nofree", "norecurse", "nonlazybind", ["probe-stack", "inline-asm"], ["target-cpu", "x86-64-v2"]], personality = @rust_eh_personality, res_attrs = [{llvm.noundef}], sym_name = "_RNvXs8_Cs3X6wZJE6GDg_6subtleShNtB5_14ConstantTimeEq5ct_eqCs2JGgYtL0Fal_14solana_ed25519", target_cpu = "x86-64-v2", unnamed_addr = 2 : i64, uwtable_kind = #llvm.uwtableKind<async>, visibility_ = 0 : i64, will_return}> ({
^bb0(%arg34: !llvm.ptr, %arg35: !llvm.ptr):
  %689 = "llvm.mlir.constant"() <{value = 1 : i8}> : () -> i8
  %690 = "llvm.load"(%arg34) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %691 = "llvm.load"(%arg35) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %692 = "llvm.icmp"(%690, %691) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %693 = "llvm.zext"(%692) : (i1) -> i8
  %694 = "llvm.call"(%693) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECs2JGgYtL0Fal_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %695 = "llvm.and"(%694, %689) : (i8, i8) -> i8
  %696 = "llvm.getelementptr"(%arg34) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1>}> : (!llvm.ptr) -> !llvm.ptr
  %697 = "llvm.getelementptr"(%arg35) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 1>}> : (!llvm.ptr) -> !llvm.ptr
  %698 = "llvm.load"(%696) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %699 = "llvm.load"(%697) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %700 = "llvm.icmp"(%698, %699) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %701 = "llvm.zext"(%700) : (i1) -> i8
  %702 = "llvm.call"(%701) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECs2JGgYtL0Fal_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %703 = "llvm.and"(%702, %695) : (i8, i8) -> i8
  %704 = "llvm.getelementptr"(%arg34) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 2>}> : (!llvm.ptr) -> !llvm.ptr
  %705 = "llvm.getelementptr"(%arg35) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 2>}> : (!llvm.ptr) -> !llvm.ptr
  %706 = "llvm.load"(%704) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %707 = "llvm.load"(%705) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %708 = "llvm.icmp"(%706, %707) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %709 = "llvm.zext"(%708) : (i1) -> i8
  %710 = "llvm.call"(%709) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECs2JGgYtL0Fal_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %711 = "llvm.and"(%710, %703) : (i8, i8) -> i8
  %712 = "llvm.getelementptr"(%arg34) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 3>}> : (!llvm.ptr) -> !llvm.ptr
  %713 = "llvm.getelementptr"(%arg35) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 3>}> : (!llvm.ptr) -> !llvm.ptr
  %714 = "llvm.load"(%712) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %715 = "llvm.load"(%713) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %716 = "llvm.icmp"(%714, %715) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %717 = "llvm.zext"(%716) : (i1) -> i8
  %718 = "llvm.call"(%717) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECs2JGgYtL0Fal_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %719 = "llvm.and"(%718, %711) : (i8, i8) -> i8
  %720 = "llvm.getelementptr"(%arg34) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 4>}> : (!llvm.ptr) -> !llvm.ptr
  %721 = "llvm.getelementptr"(%arg35) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 4>}> : (!llvm.ptr) -> !llvm.ptr
  %722 = "llvm.load"(%720) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %723 = "llvm.load"(%721) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %724 = "llvm.icmp"(%722, %723) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %725 = "llvm.zext"(%724) : (i1) -> i8
  %726 = "llvm.call"(%725) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECs2JGgYtL0Fal_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %727 = "llvm.and"(%726, %719) : (i8, i8) -> i8
  %728 = "llvm.getelementptr"(%arg34) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 5>}> : (!llvm.ptr) -> !llvm.ptr
  %729 = "llvm.getelementptr"(%arg35) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 5>}> : (!llvm.ptr) -> !llvm.ptr
  %730 = "llvm.load"(%728) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %731 = "llvm.load"(%729) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %732 = "llvm.icmp"(%730, %731) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %733 = "llvm.zext"(%732) : (i1) -> i8
  %734 = "llvm.call"(%733) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECs2JGgYtL0Fal_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %735 = "llvm.and"(%734, %727) : (i8, i8) -> i8
  %736 = "llvm.getelementptr"(%arg34) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 6>}> : (!llvm.ptr) -> !llvm.ptr
  %737 = "llvm.getelementptr"(%arg35) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 6>}> : (!llvm.ptr) -> !llvm.ptr
  %738 = "llvm.load"(%736) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %739 = "llvm.load"(%737) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %740 = "llvm.icmp"(%738, %739) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %741 = "llvm.zext"(%740) : (i1) -> i8
  %742 = "llvm.call"(%741) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECs2JGgYtL0Fal_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %743 = "llvm.and"(%742, %735) : (i8, i8) -> i8
  %744 = "llvm.getelementptr"(%arg34) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 7>}> : (!llvm.ptr) -> !llvm.ptr
  %745 = "llvm.getelementptr"(%arg35) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 7>}> : (!llvm.ptr) -> !llvm.ptr
  %746 = "llvm.load"(%744) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %747 = "llvm.load"(%745) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %748 = "llvm.icmp"(%746, %747) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %749 = "llvm.zext"(%748) : (i1) -> i8
  %750 = "llvm.call"(%749) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECs2JGgYtL0Fal_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %751 = "llvm.and"(%750, %743) : (i8, i8) -> i8
  %752 = "llvm.getelementptr"(%arg34) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %753 = "llvm.getelementptr"(%arg35) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 8>}> : (!llvm.ptr) -> !llvm.ptr
  %754 = "llvm.load"(%752) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %755 = "llvm.load"(%753) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %756 = "llvm.icmp"(%754, %755) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %757 = "llvm.zext"(%756) : (i1) -> i8
  %758 = "llvm.call"(%757) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECs2JGgYtL0Fal_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %759 = "llvm.and"(%758, %751) : (i8, i8) -> i8
  %760 = "llvm.getelementptr"(%arg34) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 9>}> : (!llvm.ptr) -> !llvm.ptr
  %761 = "llvm.getelementptr"(%arg35) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 9>}> : (!llvm.ptr) -> !llvm.ptr
  %762 = "llvm.load"(%760) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %763 = "llvm.load"(%761) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %764 = "llvm.icmp"(%762, %763) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %765 = "llvm.zext"(%764) : (i1) -> i8
  %766 = "llvm.call"(%765) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECs2JGgYtL0Fal_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %767 = "llvm.and"(%766, %759) : (i8, i8) -> i8
  %768 = "llvm.getelementptr"(%arg34) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 10>}> : (!llvm.ptr) -> !llvm.ptr
  %769 = "llvm.getelementptr"(%arg35) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 10>}> : (!llvm.ptr) -> !llvm.ptr
  %770 = "llvm.load"(%768) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %771 = "llvm.load"(%769) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %772 = "llvm.icmp"(%770, %771) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %773 = "llvm.zext"(%772) : (i1) -> i8
  %774 = "llvm.call"(%773) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECs2JGgYtL0Fal_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %775 = "llvm.and"(%774, %767) : (i8, i8) -> i8
  %776 = "llvm.getelementptr"(%arg34) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 11>}> : (!llvm.ptr) -> !llvm.ptr
  %777 = "llvm.getelementptr"(%arg35) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 11>}> : (!llvm.ptr) -> !llvm.ptr
  %778 = "llvm.load"(%776) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %779 = "llvm.load"(%777) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %780 = "llvm.icmp"(%778, %779) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %781 = "llvm.zext"(%780) : (i1) -> i8
  %782 = "llvm.call"(%781) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECs2JGgYtL0Fal_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %783 = "llvm.and"(%782, %775) : (i8, i8) -> i8
  %784 = "llvm.getelementptr"(%arg34) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 12>}> : (!llvm.ptr) -> !llvm.ptr
  %785 = "llvm.getelementptr"(%arg35) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 12>}> : (!llvm.ptr) -> !llvm.ptr
  %786 = "llvm.load"(%784) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %787 = "llvm.load"(%785) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %788 = "llvm.icmp"(%786, %787) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %789 = "llvm.zext"(%788) : (i1) -> i8
  %790 = "llvm.call"(%789) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECs2JGgYtL0Fal_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %791 = "llvm.and"(%790, %783) : (i8, i8) -> i8
  %792 = "llvm.getelementptr"(%arg34) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 13>}> : (!llvm.ptr) -> !llvm.ptr
  %793 = "llvm.getelementptr"(%arg35) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 13>}> : (!llvm.ptr) -> !llvm.ptr
  %794 = "llvm.load"(%792) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %795 = "llvm.load"(%793) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %796 = "llvm.icmp"(%794, %795) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %797 = "llvm.zext"(%796) : (i1) -> i8
  %798 = "llvm.call"(%797) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECs2JGgYtL0Fal_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %799 = "llvm.and"(%798, %791) : (i8, i8) -> i8
  %800 = "llvm.getelementptr"(%arg34) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 14>}> : (!llvm.ptr) -> !llvm.ptr
  %801 = "llvm.getelementptr"(%arg35) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 14>}> : (!llvm.ptr) -> !llvm.ptr
  %802 = "llvm.load"(%800) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %803 = "llvm.load"(%801) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %804 = "llvm.icmp"(%802, %803) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %805 = "llvm.zext"(%804) : (i1) -> i8
  %806 = "llvm.call"(%805) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECs2JGgYtL0Fal_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %807 = "llvm.and"(%806, %799) : (i8, i8) -> i8
  %808 = "llvm.getelementptr"(%arg34) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 15>}> : (!llvm.ptr) -> !llvm.ptr
  %809 = "llvm.getelementptr"(%arg35) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 15>}> : (!llvm.ptr) -> !llvm.ptr
  %810 = "llvm.load"(%808) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %811 = "llvm.load"(%809) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %812 = "llvm.icmp"(%810, %811) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %813 = "llvm.zext"(%812) : (i1) -> i8
  %814 = "llvm.call"(%813) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECs2JGgYtL0Fal_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %815 = "llvm.and"(%814, %807) : (i8, i8) -> i8
  %816 = "llvm.getelementptr"(%arg34) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %817 = "llvm.getelementptr"(%arg35) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 16>}> : (!llvm.ptr) -> !llvm.ptr
  %818 = "llvm.load"(%816) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %819 = "llvm.load"(%817) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %820 = "llvm.icmp"(%818, %819) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %821 = "llvm.zext"(%820) : (i1) -> i8
  %822 = "llvm.call"(%821) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECs2JGgYtL0Fal_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %823 = "llvm.and"(%822, %815) : (i8, i8) -> i8
  %824 = "llvm.getelementptr"(%arg34) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 17>}> : (!llvm.ptr) -> !llvm.ptr
  %825 = "llvm.getelementptr"(%arg35) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 17>}> : (!llvm.ptr) -> !llvm.ptr
  %826 = "llvm.load"(%824) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %827 = "llvm.load"(%825) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %828 = "llvm.icmp"(%826, %827) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %829 = "llvm.zext"(%828) : (i1) -> i8
  %830 = "llvm.call"(%829) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECs2JGgYtL0Fal_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %831 = "llvm.and"(%830, %823) : (i8, i8) -> i8
  %832 = "llvm.getelementptr"(%arg34) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 18>}> : (!llvm.ptr) -> !llvm.ptr
  %833 = "llvm.getelementptr"(%arg35) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 18>}> : (!llvm.ptr) -> !llvm.ptr
  %834 = "llvm.load"(%832) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %835 = "llvm.load"(%833) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %836 = "llvm.icmp"(%834, %835) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %837 = "llvm.zext"(%836) : (i1) -> i8
  %838 = "llvm.call"(%837) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECs2JGgYtL0Fal_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %839 = "llvm.and"(%838, %831) : (i8, i8) -> i8
  %840 = "llvm.getelementptr"(%arg34) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 19>}> : (!llvm.ptr) -> !llvm.ptr
  %841 = "llvm.getelementptr"(%arg35) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 19>}> : (!llvm.ptr) -> !llvm.ptr
  %842 = "llvm.load"(%840) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %843 = "llvm.load"(%841) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %844 = "llvm.icmp"(%842, %843) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %845 = "llvm.zext"(%844) : (i1) -> i8
  %846 = "llvm.call"(%845) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECs2JGgYtL0Fal_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %847 = "llvm.and"(%846, %839) : (i8, i8) -> i8
  %848 = "llvm.getelementptr"(%arg34) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 20>}> : (!llvm.ptr) -> !llvm.ptr
  %849 = "llvm.getelementptr"(%arg35) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 20>}> : (!llvm.ptr) -> !llvm.ptr
  %850 = "llvm.load"(%848) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %851 = "llvm.load"(%849) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %852 = "llvm.icmp"(%850, %851) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %853 = "llvm.zext"(%852) : (i1) -> i8
  %854 = "llvm.call"(%853) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECs2JGgYtL0Fal_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %855 = "llvm.and"(%854, %847) : (i8, i8) -> i8
  %856 = "llvm.getelementptr"(%arg34) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 21>}> : (!llvm.ptr) -> !llvm.ptr
  %857 = "llvm.getelementptr"(%arg35) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 21>}> : (!llvm.ptr) -> !llvm.ptr
  %858 = "llvm.load"(%856) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %859 = "llvm.load"(%857) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %860 = "llvm.icmp"(%858, %859) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %861 = "llvm.zext"(%860) : (i1) -> i8
  %862 = "llvm.call"(%861) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECs2JGgYtL0Fal_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %863 = "llvm.and"(%862, %855) : (i8, i8) -> i8
  %864 = "llvm.getelementptr"(%arg34) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 22>}> : (!llvm.ptr) -> !llvm.ptr
  %865 = "llvm.getelementptr"(%arg35) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 22>}> : (!llvm.ptr) -> !llvm.ptr
  %866 = "llvm.load"(%864) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %867 = "llvm.load"(%865) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %868 = "llvm.icmp"(%866, %867) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %869 = "llvm.zext"(%868) : (i1) -> i8
  %870 = "llvm.call"(%869) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECs2JGgYtL0Fal_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %871 = "llvm.and"(%870, %863) : (i8, i8) -> i8
  %872 = "llvm.getelementptr"(%arg34) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 23>}> : (!llvm.ptr) -> !llvm.ptr
  %873 = "llvm.getelementptr"(%arg35) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 23>}> : (!llvm.ptr) -> !llvm.ptr
  %874 = "llvm.load"(%872) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %875 = "llvm.load"(%873) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %876 = "llvm.icmp"(%874, %875) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %877 = "llvm.zext"(%876) : (i1) -> i8
  %878 = "llvm.call"(%877) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECs2JGgYtL0Fal_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %879 = "llvm.and"(%878, %871) : (i8, i8) -> i8
  %880 = "llvm.getelementptr"(%arg34) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %881 = "llvm.getelementptr"(%arg35) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 24>}> : (!llvm.ptr) -> !llvm.ptr
  %882 = "llvm.load"(%880) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %883 = "llvm.load"(%881) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %884 = "llvm.icmp"(%882, %883) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %885 = "llvm.zext"(%884) : (i1) -> i8
  %886 = "llvm.call"(%885) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECs2JGgYtL0Fal_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %887 = "llvm.and"(%886, %879) : (i8, i8) -> i8
  %888 = "llvm.getelementptr"(%arg34) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 25>}> : (!llvm.ptr) -> !llvm.ptr
  %889 = "llvm.getelementptr"(%arg35) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 25>}> : (!llvm.ptr) -> !llvm.ptr
  %890 = "llvm.load"(%888) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %891 = "llvm.load"(%889) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %892 = "llvm.icmp"(%890, %891) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %893 = "llvm.zext"(%892) : (i1) -> i8
  %894 = "llvm.call"(%893) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECs2JGgYtL0Fal_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %895 = "llvm.and"(%894, %887) : (i8, i8) -> i8
  %896 = "llvm.getelementptr"(%arg34) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 26>}> : (!llvm.ptr) -> !llvm.ptr
  %897 = "llvm.getelementptr"(%arg35) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 26>}> : (!llvm.ptr) -> !llvm.ptr
  %898 = "llvm.load"(%896) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %899 = "llvm.load"(%897) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %900 = "llvm.icmp"(%898, %899) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %901 = "llvm.zext"(%900) : (i1) -> i8
  %902 = "llvm.call"(%901) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECs2JGgYtL0Fal_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %903 = "llvm.and"(%902, %895) : (i8, i8) -> i8
  %904 = "llvm.getelementptr"(%arg34) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 27>}> : (!llvm.ptr) -> !llvm.ptr
  %905 = "llvm.getelementptr"(%arg35) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 27>}> : (!llvm.ptr) -> !llvm.ptr
  %906 = "llvm.load"(%904) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %907 = "llvm.load"(%905) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %908 = "llvm.icmp"(%906, %907) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %909 = "llvm.zext"(%908) : (i1) -> i8
  %910 = "llvm.call"(%909) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECs2JGgYtL0Fal_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %911 = "llvm.and"(%910, %903) : (i8, i8) -> i8
  %912 = "llvm.getelementptr"(%arg34) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 28>}> : (!llvm.ptr) -> !llvm.ptr
  %913 = "llvm.getelementptr"(%arg35) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 28>}> : (!llvm.ptr) -> !llvm.ptr
  %914 = "llvm.load"(%912) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %915 = "llvm.load"(%913) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %916 = "llvm.icmp"(%914, %915) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %917 = "llvm.zext"(%916) : (i1) -> i8
  %918 = "llvm.call"(%917) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECs2JGgYtL0Fal_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %919 = "llvm.and"(%918, %911) : (i8, i8) -> i8
  %920 = "llvm.getelementptr"(%arg34) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 29>}> : (!llvm.ptr) -> !llvm.ptr
  %921 = "llvm.getelementptr"(%arg35) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 29>}> : (!llvm.ptr) -> !llvm.ptr
  %922 = "llvm.load"(%920) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %923 = "llvm.load"(%921) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %924 = "llvm.icmp"(%922, %923) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %925 = "llvm.zext"(%924) : (i1) -> i8
  %926 = "llvm.call"(%925) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECs2JGgYtL0Fal_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %927 = "llvm.and"(%926, %919) : (i8, i8) -> i8
  %928 = "llvm.getelementptr"(%arg34) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 30>}> : (!llvm.ptr) -> !llvm.ptr
  %929 = "llvm.getelementptr"(%arg35) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 30>}> : (!llvm.ptr) -> !llvm.ptr
  %930 = "llvm.load"(%928) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %931 = "llvm.load"(%929) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %932 = "llvm.icmp"(%930, %931) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %933 = "llvm.zext"(%932) : (i1) -> i8
  %934 = "llvm.call"(%933) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECs2JGgYtL0Fal_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %935 = "llvm.and"(%934, %927) : (i8, i8) -> i8
  %936 = "llvm.getelementptr"(%arg34) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 31>}> : (!llvm.ptr) -> !llvm.ptr
  %937 = "llvm.getelementptr"(%arg35) <{elem_type = i8, noWrapFlags = 7 : i32, rawConstantIndices = array<i32: 31>}> : (!llvm.ptr) -> !llvm.ptr
  %938 = "llvm.load"(%936) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %939 = "llvm.load"(%937) <{alignment = 1 : i64, ordering = 0 : i64}> : (!llvm.ptr) -> i8
  %940 = "llvm.icmp"(%938, %939) <{predicate = 0 : i64}> : (i8, i8) -> i1
  %941 = "llvm.zext"(%940) : (i1) -> i8
  %942 = "llvm.call"(%941) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECs2JGgYtL0Fal_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  %943 = "llvm.and"(%942, %935) : (i8, i8) -> i8
  %944 = "llvm.call"(%943) <{CConv = #llvm.cconv<fastcc>, TailCallKind = #llvm.tailcallkind<tail>, arg_attrs = [{llvm.noundef}], callee = @_RINvCs3X6wZJE6GDg_6subtle9black_boxhECs2JGgYtL0Fal_14solana_ed25519, fastmathFlags = #llvm.fastmath<none>, memory_effects = #llvm.memory_effects<other = none, argMem = none, inaccessibleMem = readwrite, errnoMem = none, targetMem0 = none, targetMem1 = none>, no_inline, op_bundle_sizes = array<i32>, operandSegmentSizes = array<i32: 1, 0>, res_attrs = [{llvm.noundef}]}> : (i8) -> i8
  "llvm.return"(%944) : (i8) -> ()
}) : () -> ()
