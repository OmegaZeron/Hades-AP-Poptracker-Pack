Menu:connect_one_way_entrance(Tartarus)
Tartarus:connect_one_way_entrance(Megaera)
Megaera:connect_one_way_entrance(Asphodel, function()
	return Any(
		All(
			HasPactHeat(math.min(TotalPactAmount() / 4, 10)),
			HasRoutineInspection(Tracker:ProviderCountForCode("routine_inspection_pact_amount") - 2),
			Has("weapon", 2)
		),
		AccessibilityLevel.SequenceBreak
	)
end)
Asphodel:connect_one_way_entrance(Lernie)
Lernie:connect_one_way(DivinePairings, function()
	return Any(
		Has("keepsakesanity_off"),
		All(
			Has("Keepsake_aphrodite"),
			Has("Keepsake_ares"),
			Has("Keepsake_artemis"),
			Has("Keepsake_athena"),
			Has("Keepsake_demeter"),
			Has("Keepsake_dionysus"),
			Has("Keepsake_hermes"),
			Has("Keepsake_poseidon"),
			Has("Keepsake_zeus")
		)
	)
end)
Lernie:connect_one_way_entrance(Elysium, function()
	return Any(
		All(
			HasPactHeat(math.min(TotalPactAmount() / 2, 20)),
			HasRoutineInspection(Tracker:ProviderCountForCode("routine_inspection_pact_amount") - 1),
			Has("weapon", 3)
		),
		AccessibilityLevel.SequenceBreak
	)
end)
Elysium:connect_one_way_entrance(Besties)
Besties:connect_one_way_entrance(Styx, function()
	return Any(
		All(
			HasPactHeat(math.min(TotalPactAmount() * 3 / 4, 30)),
			HasRoutineInspection(Tracker:ProviderCountForCode("routine_inspection_pact_amount")),
			Has("weapon", 5)
		),
		AccessibilityLevel.SequenceBreak
	)
end)
Styx:connect_one_way_entrance(StyxLate) -- rules?
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
-- for i = 1, 1000, 1 do
-- 	local padded = ""..i
-- 	while padded:len() < 4 do
-- 		padded = "0"..padded
-- 	end
-- 	Menu:connect_one_way("ClearScore"..padded)
-- end