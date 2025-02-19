Menu:connect_one_way(AphroditeKeepsake, function()
	return Any(
		Has(EternalRose),
		AccessibilityLevel.SequenceBreak
	)
end)
Menu:connect_one_way(AresKeepsake, function()
	return Any(
		Has(BloodFilledVial),
		AccessibilityLevel.SequenceBreak
	)
end)
Menu:connect_one_way(ArtemisKeepsake, function()
	return Any(
		Has(AdamantArrowhead),
		AccessibilityLevel.SequenceBreak
	)
end)
Menu:connect_one_way(AthenaKeepsake, function()
	return Any(
		Has(OwlPendant),
		AccessibilityLevel.SequenceBreak
	)
end)
Menu:connect_one_way(ChaosKeepsake, function()
	return Any(
		Has(CosmicEgg),
		AccessibilityLevel.SequenceBreak
	)
end)
Menu:connect_one_way(DemeterKeepsake, function()
	return Any(
		Has(FrostbittenHorn),
		AccessibilityLevel.SequenceBreak
	)
end)
Menu:connect_one_way(DionysusKeepsake, function()
	return Any(
		Has(OverflowingCup),
		AccessibilityLevel.SequenceBreak
	)
end)
Lernie:connect_one_way(EurydiceKeepsake)
Menu:connect_one_way(HermesKeepsake, function()
	return Any(
		Has(LambentPlume),
		AccessibilityLevel.SequenceBreak
	)
end)
Besties:connect_one_way(PatroclusKeepsake)
Menu:connect_one_way(PoseidonKeepsake, function()
	return Any(
		Has(ConchShell),
		AccessibilityLevel.SequenceBreak
	)
end)
HadesBoss:connect_one_way(ThanatosKeepsake)
Menu:connect_one_way(ZeusKeepsake, function()
	return Any(
		Has(ThunderSignet),
		AccessibilityLevel.SequenceBreak
	)
end)