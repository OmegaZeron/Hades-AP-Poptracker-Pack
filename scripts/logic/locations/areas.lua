Menu:connect_one_way_entrance(Tartarus)
Tartarus:connect_one_way_entrance(Megaera, function()
	return Any(
		All(
			HasPactHeat(math.min(TotalPactAmount() / 4, 10)),
			HasRoutineInspection(Tracker:ProviderCountForCode(RoutineInspectionSetting) - 2),
			Has("weapon", 2)
		),
		AccessibilityLevel.SequenceBreak
	)
end)
Megaera:connect_one_way_entrance(Asphodel)
Asphodel:connect_one_way_entrance(Lernie, function()
	return Any(
		All(
			HasPactHeat(math.min(TotalPactAmount() / 2, 20)),
			HasRoutineInspection(Tracker:ProviderCountForCode(RoutineInspectionSetting) - 1),
			Has("weapon", 3)
		),
		AccessibilityLevel.SequenceBreak
	)
end)
HadesBoss:connect_one_way(DivinePairings, function()
	return All(
		HasAllApprovalProcess(),
		Any(
			Has("keepsakesanity_off"),
			All(
				Has(EternalRose),
				Has(BloodFilledVial),
				Has(AdamantArrowhead),
				Has(OwlPendant),
				Has(FrostbittenHorn),
				Has(OverflowingCup),
				Has(ConchShell),
				Has(ThunderSignet)
			)
		)
	)
end)
Lernie:connect_one_way_entrance(Elysium)
Elysium:connect_one_way_entrance(Besties, function()
	return Any(
		All(
			HasPactHeat(math.min(TotalPactAmount() * 3 / 4, 30)),
			HasRoutineInspection(Tracker:ProviderCountForCode(RoutineInspectionSetting)),
			Has("weapon", 5)
		),
		AccessibilityLevel.SequenceBreak
	)
end)
Besties:connect_one_way_entrance(Styx)
Styx:connect_one_way_entrance(StyxLate)
Styx:connect_one_way_entrance(HadesBoss, function()
	return Any(
		All(
			HasPactHeat(math.min(TotalPactAmount(), 35)),
			Has("weapon", 6)
		),
		AccessibilityLevel.SequenceBreak
	)
end)
HadesBoss:connect_one_way(Goal, function()
	return All(
		HasWeaponForGoal(),
		HasKeepsakeForGoal(),
		HasFateForGoal()
	)
end)