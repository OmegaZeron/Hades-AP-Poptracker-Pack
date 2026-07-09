Menu:connect_one_way_entrance(Tartarus)
Tartarus:connect_one_way(TartarusFish, CanFishStore)
Tartarus:connect_one_way(VoidFish, CanFishStore)
Tartarus:connect_one_way(TartarusTroves, HasUnlockedTroves)
Tartarus:connect_one_way_entrance(Megaera, CanBeatMeg)

Megaera:connect_one_way_entrance(Asphodel)
Asphodel:connect_one_way(AsphodelFish, CanFishStore)
Asphodel:connect_one_way(AsphodelTroves, HasUnlockedTroves)
Asphodel:connect_one_way_entrance(Lernie, CanBeatLernie)

Lernie:connect_one_way_entrance(Elysium)
Elysium:connect_one_way(ElysiumFish, CanFishStore)
Elysium:connect_one_way(ElysiumTroves, HasUnlockedTroves)
Elysium:connect_one_way_entrance(Besties, CanBeatBros)

Besties:connect_one_way_entrance(Styx)
Styx:connect_one_way(StyxFish, CanFishStore)
-- if not storesanity, fishing rod is unlocked after reaching Styx
Styx:connect_one_way(TartarusFish, CanFishVanilla)
Styx:connect_one_way(VoidFish, CanFishVanilla)
Styx:connect_one_way(AsphodelFish, CanFishVanilla)
Styx:connect_one_way(ElysiumFish, CanFishVanilla)
Styx:connect_one_way(StyxTroves, HasUnlockedTroves)

Styx:connect_one_way_entrance(StyxLate)
Styx:connect_one_way_entrance(HadesBoss, CanBeatDad)

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
HadesBoss:connect_one_way(SurfaceFish, function()
	return Any(
		CanFishStore(),
		CanFishVanilla()
	)
end)
HadesBoss:connect_one_way(Goal, function()
	return All(
		HasWeaponForGoal(),
		HasKeepsakeForGoal(),
		HasFateForGoal()
	)
end)