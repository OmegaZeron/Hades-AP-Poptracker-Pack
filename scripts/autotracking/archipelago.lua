require("scripts/autotracking/item_mapping")
require("scripts/autotracking/location_mapping")

CUR_INDEX = -1
SLOT_DATA = nil
LOCAL_ITEMS = {}
GLOBAL_ITEMS = {}
COLLECTED_HINTS = {}

function OnClear(slot_data)
	if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
		print(string.format("called onClear, slot_data:\n%s", dump(slot_data)))
	end
	SLOT_DATA = slot_data
	CUR_INDEX = -1
	-- reset locations
	for _, location_array in pairs(LOCATION_MAPPING) do
		for _, location in pairs(location_array) do
			if location then
				local obj = Tracker:FindObjectForCode(location)
				if obj then
					if location:sub(1, 1) == "@" then
						obj.AvailableChestCount = obj.ChestCount
					else
						obj.Active = false
					end
				end
			end
		end
	end
	-- reset items
	for _, v in pairs(ITEM_MAPPING) do
		if v[1] and v[2] then
			if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
				print(string.format("onClear: clearing item %s of type %s", v[1], v[2]))
			end
			local obj = Tracker:FindObjectForCode(v[1])
			if obj then
				if v[2] == "toggle" then
					obj.Active = false
				elseif v[2] == "progressive" then
					obj.CurrentStage = 0
					obj.Active = false
				elseif v[2] == "consumable" or v[2] == "pact" then
					obj.AcquiredCount = 0
				elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
					print(string.format("onClear: unknown item type %s for code %s", v[2], v[1]))
				end
			elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
				print(string.format("onClear: could not find object for code %s", v[1]))
			end
		end
	end

	PLAYER_ID = Archipelago.PlayerNumber or -1
	TEAM_NUMBER = Archipelago.TeamNumber or 0

	if Archipelago.PlayerNumber > -1 then
		HINTS_ID = "_read_hints_"..TEAM_NUMBER.."_"..PLAYER_ID
		Archipelago:SetNotify({HINTS_ID})
		Archipelago:Get({HINTS_ID})
	end

	for _, v in ipairs(SlotDataTable) do
		if (v[2] == "toggle") then
			Tracker:FindObjectForCode(v[1]).Active = slot_data[v[1]]
		elseif (v[2] == "progressive") then
			Tracker:FindObjectForCode(v[1]).CurrentStage = slot_data[v[1]]
		elseif (v[2] == "consumable") then
			Tracker:FindObjectForCode(v[1]).AcquiredCount = slot_data[v[1]]
		end
	end
	-- location system is for some reason offset by 1
	Tracker:FindObjectForCode("location_system").CurrentStage = slot_data["location_system"] - 1
	-- on reading Pact settings, set Pact items to the same
	for k, v in pairs(PactMapping) do
		Tracker:FindObjectForCode(v).AcquiredCount = slot_data[k]
		print("Pact", v, slot_data[k])
	end

	Tracker:FindObjectForCode(InitialWeaponDict[slot_data["initial_weapon"]]).Active = true
end

-- called when an item gets collected
function OnItem(index, item_id, item_name, player_number)
	if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
		print(string.format("called onItem: %s, %s, %s, %s, %s", index, item_id, item_name, player_number, CUR_INDEX))
	end
	if not AUTOTRACKER_ENABLE_ITEM_TRACKING then
		return
	end
	if index <= CUR_INDEX then
		return
	end
	SetAsStale()
	local is_local = player_number == Archipelago.PlayerNumber
	CUR_INDEX = index;
	local v = ITEM_MAPPING[item_id]
	if not v then
		if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
			print(string.format("onItem: could not find item mapping for id %s", item_id))
		end
		return
	end
	if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
		print(string.format("onItem: code: %s, type %s", v[1], v[2]))
	end
	if not v[1] then
		return
	end
	local obj = Tracker:FindObjectForCode(v[1])
	if obj then
		if v[2] == "toggle" then
			obj.Active = true
		elseif v[2] == "progressive" then
			if obj.Active then
				obj.CurrentStage = obj.CurrentStage + 1
			else
				obj.Active = true
			end
		elseif v[2] == "consumable" then
			local mult = 1
			if (v[3]) then
				mult = v[3]
			end
			obj.AcquiredCount = obj.AcquiredCount + (obj.Increment * mult)
			if (obj.AcquiredCount > obj.MaxCount) then
				obj.AcquiredCount = obj.MaxCount
			end
			if (obj.AcquiredCount < obj.MinCount) then
				obj.AcquiredCount = obj.MinCount
			end
		elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
			print(string.format("onItem: unknown item type %s for code %s", v[2], v[1]))
		end
	elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
		print(string.format("onItem: could not find object for code %s", v[1]))
	end
end

-- called when a location gets cleared
function OnLocation(location_id, location_name)
	if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
		print("called onLocation:", location_name)
	end
	SetAsStale()
	local location_array = LOCATION_MAPPING[location_id]
	if not location_array or not location_array[1] then
		print(string.format("onLocation: could not find location mapping for id %s", location_id))
		return
	end

	for _, location in pairs(location_array) do
		local obj = Tracker:FindObjectForCode(location)
		-- print(location, obj)
		if obj then
			if location:sub(1, 1) == "@" then
				obj.AvailableChestCount = obj.AvailableChestCount - 1
			else
				obj.Active = true
			end
			-- ClearHints(location_id)
		else
			print(string.format("onLocation: could not find object for code %s", location))
		end
	end
end

-- called when a locations is scouted
function OnScout(location_id, location_name, item_id, item_name, item_player)
	if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
		print(string.format("called onScout: %s, %s, %s, %s, %s", location_id, location_name, item_id, item_name,
			item_player))
	end
end

function OnNotify(key, value, old_value)
	-- print(string.format("called onNotify: %s, %s, %s", key, dump(value), old_value))
	if value ~= old_value and key == HINTS_ID then
		COLLECTED_HINTS = {}
		for _, hint in ipairs(value) do
			-- if not hint.found and hint.finding_player == Archipelago.PlayerNumber then
			-- 	UpdateHints(hint.location, hint.item_flags)
			-- end
		end
	end
end

function OnNotifyLaunch(key, value)
	-- print(string.format("Hint: %s", dump(value)))
	if key == HINTS_ID then
		COLLECTED_HINTS = {}
		for _, hint in ipairs(value) do
			-- if not hint.found and hint.finding_player == Archipelago.PlayerNumber then
			-- 	UpdateHints(hint.location, hint.item_flags)
			-- elseif hint.found then
			-- 	ClearHints(hint.location)
			-- end
		end
	end
end

-- called when a location is hinted
function UpdateHints(locationID, quality)
	local item_codes = HINT_MAPPING[locationID]
	-- print("Hint", dump(item_codes), quality)
	for _, item_code in ipairs(item_codes) do
		-- if (QualityToAccess[quality]) then
		-- 	COLLECTED_HINTS[item_code] = QualityToAccess[quality]
		-- end
		local obj = Tracker:FindObjectForCode(item_code)
		if obj then
			obj.Active = true
		else
			print(string.format("No object found for code: %s", item_code))
		end
	end
end

function ClearHints(locationID)
	local item_codes = HINT_MAPPING[locationID]
	if (not item_codes) then
		return
	end
	for _, item_code in ipairs(item_codes) do
		local obj = Tracker:FindObjectForCode(item_code)
		if obj then
			obj.Active = false
		else
			print(string.format("No object found for code: %s", item_code))
		end
	end
end

function HasHint(code)
	if (COLLECTED_HINTS[code]) then
		return COLLECTED_HINTS[code]
	end
	local hintLoc = Tracker:FindObjectForCode(code)
	if (hintLoc and hintLoc.Active) then
		hintLoc.Active = false
	end
	return AccessibilityLevel.None
end

-- called when a bounce message is received 
function OnBounce(json)
	if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
		print(string.format("called onBounce: %s", dump(json)))
	end
end

Archipelago:AddClearHandler("clear handler", OnClear)
if AUTOTRACKER_ENABLE_ITEM_TRACKING then
	Archipelago:AddItemHandler("item handler", OnItem)
end
if AUTOTRACKER_ENABLE_LOCATION_TRACKING then
	Archipelago:AddLocationHandler("location handler", OnLocation)
end
-- Archipelago:AddSetReplyHandler("notify handler", OnNotify)
-- Archipelago:AddRetrievedHandler("notify launch handler", OnNotifyLaunch)