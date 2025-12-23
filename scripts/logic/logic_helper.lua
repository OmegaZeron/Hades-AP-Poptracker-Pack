function HasWeaponForGoal()
	return Tracker:ProviderCountForCode("weapon") >= Tracker:ProviderCountForCode("weapons_clears_needed")
end
function HasKeepsakeForGoal()
	return Tracker:ProviderCountForCode("keepsake") >= Tracker:ProviderCountForCode("keepsakes_needed")
end
function HasFateForGoal()
	local count = 0
	for _, loc in ipairs(FateLocs) do
		local section = Tracker:FindObjectForCode("@"..loc)
		---@cast section LocationSection
		if (section.AvailableChestCount ~= 1) then
			count = count + 1
		end
	end
	return count >= Tracker:ProviderCountForCode("fates_needed")
end

function CanSeeScore(score)
	return Has("location_score") and tonumber(score) <= Tracker:ProviderCountForCode("score_rewards_amount")
end
function CanReachScore(score)
	score = tonumber(score)
	local maxLocations = Tracker:ProviderCountForCode("score_rewards_amount")
	local fractionLocations = math.floor(maxLocations / 8)
	local tartarus = maxLocations - 7 * fractionLocations
	local asphodel = tartarus + 2 * fractionLocations
	local elysium = tartarus + 4 * fractionLocations
	local styx = tartarus + 6 * fractionLocations

	return Any(
		CanReach(StyxLate),
		score <= styx and CanReach(Styx),
		score <= elysium and CanReach(Elysium),
		score <= asphodel and CanReach(Asphodel),
		score <= tartarus,
		AccessibilityLevel.SequenceBreak
	)
end

function TotalPactAmount()
	return Tracker:ProviderCountForCode("pactsetting")
end
function HasPactHeat(amount)
	if (not Has("reverse_heat")) then
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

function HasRoutineInspection(amount)
	if (not Has("reverse_heat")) then
		return true
	end
	return Tracker:ProviderCountForCode(RoutineInspectionSetting) - Tracker:ProviderCountForCode(RoutineInspectionItem) >= amount
end

function HasAllApprovalProcess()
	return Any(
		Tracker:ProviderCountForCode(ApprovalProcessItem) == 0,
		AccessibilityLevel.SequenceBreak
	)
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
	local scoreRequirement = Tracker:FindObjectForCode("score_rewards_amount")
	---@cast scoreRequirement JsonItem
	scoreRequirement.Increment = inc
	scoreRequirement.Decrement = inc
end

function OnChangeDefeatsRequired()
	local defeatsNeeded = Tracker:FindObjectForCode("hades_defeats_needed")
	---@cast defeatsNeeded JsonItem
	if (defeatsNeeded.AcquiredCount >= 10) then
		defeatsNeeded.Icon = ImageReference:FromPackRelativePath("images/labels/DefeatHades_Alt.png")
	else
		defeatsNeeded.Icon = ImageReference:FromPackRelativePath("images/labels/DefeatHades.png")
	end
end

function OnSectionChanged(section)
	---@cast section LocationSection
	if (TableContains(FateLocs, section.FullID)) then
		Tracker:FindObjectForCode("hidden_setting").Active = not Tracker:FindObjectForCode("hidden_setting").Active
	end
end

ScriptHost:AddWatchForCode("score mult handler", "scoremult", OnChangeScoreMult)
ScriptHost:AddWatchForCode("defeats requried handler", "hades_defeats_needed", OnChangeDefeatsRequired)
ScriptHost:AddOnLocationSectionChangedHandler("secton changed handler", OnSectionChanged)