Besties:connect_one_way(TheHolyLiege, function()
	return All(
		Any(
			Has("weaponsanity_off"),
			Has(Stygius)
		),
		Any(
			Has("hidden_aspectsanity_off"),
			Has(StygiusHidden)
		)
	)
end)
Besties:connect_one_way(ThePreserversAvatar, function()
	return All(
		Any(
			Has("weaponsanity_off"),
			Has(Coronacht)
		),
		Any(
			Has("hidden_aspectsanity_off"),
			Has(CoronachtHidden)
		)
	)
end)
Besties:connect_one_way(TheFatedSaintOfWar, function()
	return All(
		Any(
			Has("weaponsanity_off"),
			Has(Varatha)
		),
		Any(
			Has("hidden_aspectsanity_off"),
			Has(VarathaHidden)
		)
	)
end)
Besties:connect_one_way(TheDragonsRival, function()
	return All(
		Any(
			Has("weaponsanity_off"),
			Has(Aegis)
		),
		Any(
			Has("hidden_aspectsanity_off"),
			Has(AegisHidden)
		)
	)
end)
Besties:connect_one_way(TheGodlikeKing, function()
	return All(
		Any(
			Has("weaponsanity_off"),
			Has(Malphon)
		),
		Any(
			Has("hidden_aspectsanity_off"),
			Has(MalphonHidden)
		)
	)
end)
Besties:connect_one_way(TheDawnBringer, function()
	return All(
		Any(
			Has("weaponsanity_off"),
			Has(Exagryph)
		),
		Any(
			Has("hidden_aspectsanity_off"),
			Has(ExagryphHidden)
		)
	)
end)
