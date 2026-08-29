function HasWeaponForGoal()
	return Tracker:ProviderCountForCode("weapon") >= Tracker:ProviderCountForCode(WeaponClearsNeeded)
end
function HasKeepsakeForGoal()
	return Tracker:ProviderCountForCode("keepsake") >= Tracker:ProviderCountForCode(KeepsakesNeeded)
end
function HasFateForGoal()
	if Tracker:ProviderCountForCode("fatesanity_off") == 1 then
		return true
	end
	local count = 0
	for _, loc in ipairs(FateLocs) do
		local section = Tracker:FindObjectForCode("@"..loc) --[[@as LocationSection]]
		if (section.AvailableChestCount ~= 1) then
			count = count + 1
		end
	end
	local fateSetting = Tracker:FindObjectForCode(FatesNeeded) --[[@as JsonItem]]
	local fatesNeeded = fateSetting.AcquiredCount
	local sub = 0
	-- if minimal heat is active and routine inspection is greater than 0, Darker Reflections is impossible to obtain
	if Has(MinimalHeat) and Tracker:ProviderCountForCode(RoutineInspectionSetting) > 0 then
		sub = sub + 1
	end
	fatesNeeded = math.min(fatesNeeded, fateSetting.MaxCount - sub)
	return count >= fatesNeeded
end

---@param score integer|string
function CanSeeScore(score)
	return Has("location_score") and tonumber(score) <= Tracker:ProviderCountForCode(ScoreRewardsAmount)
end

---@param score number|string?
---@return accessibilityLevel
function CanReachScore(score)
	score = tonumber(score)
	local maxLocations = Tracker:ProviderCountForCode(ScoreRewardsAmount)
	local fractionLocations = maxLocations // 8
	local tartarus = maxLocations - 7 * fractionLocations
	local asphodel = tartarus + 2 * fractionLocations
	local elysium = tartarus + 4 * fractionLocations
	local styx = tartarus + 6 * fractionLocations

	return Any(
		CanBeatDad() >= AccessibilityLevel.Normal,
		score <= styx and CanBeatBros() >= AccessibilityLevel.Normal,
		score <= elysium and CanBeatLernie() >= AccessibilityLevel.Normal,
		score <= asphodel and CanBeatMeg() >= AccessibilityLevel.Normal,
		score <= tartarus,
		AccessibilityLevel.SequenceBreak
	)
end

function TotalPactAmount()
	return Tracker:ProviderCountForCode("pactsetting")
end

---@param amount number
---@return boolean
function HasPactHeat(amount)
	if not Has("reverse_heat") then
		return true
	end
	local count = 0
	for k, v in pairs(PactMapping) do
		local setting = Tracker:ProviderCountForCode(k)
		if (setting > 0) then
			local pact = Tracker:ProviderCountForCode(v)
			if (pact > setting) then
				pact = setting
			end
			count = count + (setting - pact)
		end
	end
	return count >= amount
end

---@param amount number
---@return boolean
function HasRoutineInspection(amount)
	if not Has("reverse_heat") then
		return true
	end
	local riSetting = Tracker:ProviderCountForCode(RoutineInspectionSetting)
	return riSetting - math.min(riSetting, Tracker:ProviderCountForCode(RoutineInspectionItem)) >= amount
end

function HasAllApprovalProcess()
	return Any(
		Tracker:ProviderCountForCode(ApprovalProcessItem) == 0,
		AccessibilityLevel.SequenceBreak
	)
end

function CanFishStore()
	return All(
		Has(FishSanityOn),
		Has(StoreSanityOn),
		Has(RodOfFishing)
	)
end
function CanFishVanilla()
	return All(
		Has(FishSanityOn),
		Has(StoreSanityOff)
	)
end

function HasUnlockedTroves()
	return Any(
		Has(StoreSanityOff),
		Has("trove1")
	)
end

function CanBeatMeg()
	return Any(
		All(
			HasPactHeat(math.min(TotalPactAmount() // 4, 10)),
			HasRoutineInspection(Tracker:ProviderCountForCode(RoutineInspectionSetting) - 2),
			Has("weapon", 2),
			Any(
				Has(AbilitySanityOff),
				Has(AbilityDash)
			),
			HasAbilityPairs(1),
			HasEnoughMirrorLevels(1)
		),
		AccessibilityLevel.SequenceBreak
	)
end
function CanBeatLernie()
	return Any(
		All(
			HasPactHeat(math.min(TotalPactAmount() // 2, 20)),
			HasRoutineInspection(Tracker:ProviderCountForCode(RoutineInspectionSetting) - 1),
			Has("weapon", 3),
			Any(
				Has(AbilitySanityOff),
				Has(AbilityDash)
			),
			HasAbilityProgression(2),
			HasAbilityPairs(2),
			HasEnoughMirrorLevels(2)
		),
		AccessibilityLevel.SequenceBreak
	)
end
function CanBeatBros()
	return Any(
		All(
			HasPactHeat(math.min(TotalPactAmount() * 3 // 4, 30)),
			HasRoutineInspection(Tracker:ProviderCountForCode(RoutineInspectionSetting)),
			Has("weapon", 5),
			Any(
				Has(AbilitySanityOff),
				Has(AbilityDash)
			),
			HasAbilityProgression(3),
			HasAbilityPairs(3),
			HasEnoughMirrorLevels(3)
		),
		AccessibilityLevel.SequenceBreak
	)
end
function CanBeatDad()
	return Any(
		All(
			HasPactHeat(math.min(TotalPactAmount(), 35)),
			Has("weapon", 6),
			Any(
				Has(AbilitySanityOff),
				Has(AbilityDash)
			),
			HasAbilityProgression(4),
			HasAbilityPairs(4),
			HasEnoughMirrorLevels(4)
		),
		AccessibilityLevel.SequenceBreak
	)
end

---@param tier integer
function HasEnoughMirrorLevels(tier)
	if Has(MirrorSanityOff) then return true end
	-- return Tracker:ProviderCountForCode("mirror") >= amount
	for _, data in ipairs(MirrorData) do
		if IsMirrorUpgradeEnabled(data.routineReq) and data.routineReq <= tier then
			local item = Tracker:FindObjectForCode(data.code) --[[@as JsonItem]]
			if item.AcquiredCount < item.MaxCount then
				return false
			end
		end
	end
	return true
end
function HasAllMirrorTalents()
	return Any(
		Has(MirrorSanityOff),
		All(
			Has(MirrorSanityOn),
			Tracker:ProviderCountForCode("mirror") >= TotalMirrorItems
		)
	)
end
---@param mirrorIdx string
---@return accessibilityLevel
function CanMirror(mirrorIdx)
	local mirrorData = MirrorData[tonumber(mirrorIdx)]
	local requiredRI = mirrorData.routineReq
	if not requiredRI then return AccessibilityLevel.None end

	return All(
		-- use RI as mirror "tier" for boss gating
		Any(
			requiredRI == 1,
			All(
				requiredRI == 2,
				CanBeatMeg()
			),
			All(
				requiredRI == 3,
				CanBeatLernie()
			),
			All(
				requiredRI == 4,
				CanBeatBros()
			)
		),
		-- actual RI requirement
		HasRoutineInspection(requiredRI - (4 - Tracker:ProviderCountForCode(RoutineInspectionSetting)))
	)
end
---@param neededRI string|number
function IsMirrorUpgradeEnabled(neededRI)
	if Tracker:ProviderCountForCode(MinimalHeat) == 0 then return true end

	local routineSetting = Tracker:ProviderCountForCode(RoutineInspectionSetting)
	return 4 - routineSetting >= tonumber(neededRI)
end

---@param ability string
function HasAbility(ability)
	if Has(AbilitySanityOff) then
		return true
	end

	if ability == "dash" or ability == "cast" or ability == "call" then
		return Has("ability_"..ability)
	end
	if ability:find("any_") then
		local move = ability:sub(4)
		if Has(AbilitySanityOn) then
			return Has("ability_"..move)
		end
		for _, weapon in ipairs(Weapons) do
			if Has(weapon .. "_" .. move) and (Has("weaponsanity_off") or Has(weapon)) then
				return true
			end
		end
		return false
	end
	if ability:sub(-6) == "attack" then
		if Has(AbilitySanityOn) then
			return Has(AbilityAttack)
		end
		return Has(ability)
	end
	if ability:sub(-7) == "special" then
		if Has(AbilitySanityOn) then
			return Has(AbilitySpecial)
		end
		return Has(ability)
	end
	return false
end
---@param amount integer
function HasAbilityProgression(amount)
	local count = Tracker:ProviderCountForCode(AbilityDash) + Tracker:ProviderCountForCode(AbilityCast) + Tracker:ProviderCountForCode(AbilityCall)
	if Tracker:ProviderCountForCode(AbilitySanityOn) == 1 then
		count = count + Tracker:ProviderCountForCode(AbilityAttack) + Tracker:ProviderCountForCode(AbilitySpecial)
	else
		for _, weapon in ipairs(Weapons) do
			if HasAbility(weapon .. "_attack") then
				count = count + 1
			end
			if HasAbility(weapon .. "_special") then
				count = count + 1
			end
		end
	end

	return count >= amount
end
---@param amount integer
function HasAbilityPairs(amount)
	if Has(AbilitySanityOff) then return true end
	local count = 0
	for _, weapon in ipairs(Weapons) do
		if Has(weapon .. "_attack") and Has(weapon .. "_special") then
			count = count + 1
		end
	end

	return count >= amount
end
function HasBasicMoves()
	return HasAbility("Any Attack") and HasAbility("Any Special") and HasAbility("Dash") and HasAbility("Cast")
end
function CanAccessAllBoons()
	if Has(AbilitySanityOff) then
		return true
	end
	return HasBasicMoves() and HasAbility("Call")
end

function OnChangeScoreMult()
	local scoreMult = Tracker:FindObjectForCode("scoremult")
	local inc = 1
	if (scoreMult ~= nil) then
		if (scoreMult.CurrentStage == 1) then
			inc = 10
		elseif (scoreMult.CurrentStage == 2) then
			inc = 100
		end
	end
	local scoreRequirement = Tracker:FindObjectForCode(ScoreRewardsAmount) --[[@as JsonItem]]
	scoreRequirement.Increment = inc
	scoreRequirement.Decrement = inc
end

function OnChangeDefeatsRequired()
	local defeatsNeeded = Tracker:FindObjectForCode(HadesDefeatsNeeded) --[[@as JsonItem]]
	if defeatsNeeded.AcquiredCount >= 10 then
		defeatsNeeded.Icon = ImageReference:FromPackRelativePath("images/labels/DefeatHades_Alt.png")
	else
		defeatsNeeded.Icon = ImageReference:FromPackRelativePath("images/labels/DefeatHades.png")
	end
end

function OnChangeAbilitysanity()
	local mode = Tracker:FindObjectForCode(AbilitySanity) --[[@as JsonItem]]
	if mode.CurrentStage == 0 then
		Tracker:AddLayouts("layouts/ability_grids/ability_grid_weapon.jsonc")
	elseif mode.CurrentStage == 1 then
		Tracker:AddLayouts("layouts/ability_grids/ability_grid_on.jsonc")
	else
		Tracker:AddLayouts("layouts/ability_grids/ability_grid_off.jsonc")
	end
end

function OnChangeMirrorsanity()
	local mode = Tracker:FindObjectForCode(MirrorSanity) --[[@as JsonItem]]
	if mode.CurrentStage == 0 then
		Tracker:AddLayouts("layouts/mirror_grids/mirror_grid_off.jsonc")
	else
		Tracker:AddLayouts("layouts/mirror_grids/mirror_grid_on.jsonc")
	end
end

---@param section LocationSection
function OnSectionChanged(section)
	if TableContains(FateLocs, section.FullID) then
		Tracker:FindObjectForCode("hidden_setting").Active = not Tracker:FindObjectForCode("hidden_setting").Active
	end
end

ScriptHost:AddWatchForCode("score mult handler", "scoremult", OnChangeScoreMult)
ScriptHost:AddWatchForCode("defeats required handler", HadesDefeatsNeeded, OnChangeDefeatsRequired)
ScriptHost:AddWatchForCode("abilitysanity layout handler", AbilitySanity, OnChangeAbilitysanity)
ScriptHost:AddWatchForCode("mirrorsanity layout handler", MirrorSanity, OnChangeMirrorsanity)
ScriptHost:AddOnLocationSectionChangedHandler("section changed handler", OnSectionChanged)