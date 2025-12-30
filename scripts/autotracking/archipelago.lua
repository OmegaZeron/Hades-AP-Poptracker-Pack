require("scripts.autotracking.item_mapping")
require("scripts.autotracking.location_mapping")

CUR_INDEX = -1
SLOT_DATA = nil
ALL_LOCATIONS = {}
IS_MANUAL_CLICK = true
DEFAULT_SEED = "default"
ROOM_SEED = DEFAULT_SEED

function PreOnClear()
	PLAYER_ID = Archipelago.PlayerNumber or -1
	TEAM_NUMBER = Archipelago.TeamNumber or 0

	if Archipelago.PlayerNumber > -1 then
		if #ALL_LOCATIONS > 0 then
			ALL_LOCATIONS = {}
		end
		for _, value in pairs(Archipelago.MissingLocations) do
			table.insert(ALL_LOCATIONS, #ALL_LOCATIONS + 1, value)
		end

		for _, value in pairs(Archipelago.CheckedLocations) do
			table.insert(ALL_LOCATIONS, #ALL_LOCATIONS + 1, value)
		end
	end

	local manualStorageItem = Tracker:FindObjectForCode(ManualStorageCode)
	if manualStorageItem then
		manualStorageItem = manualStorageItem.ItemState
	end
	local seedBase = (Archipelago.Seed or #ALL_LOCATIONS).."_"..Archipelago.TeamNumber.."_"..Archipelago.PlayerNumber
	if manualStorageItem and (ROOM_SEED == DEFAULT_SEED or ROOM_SEED ~= seedBase) then
		ROOM_SEED = seedBase
		if #manualStorageItem.ManualLocations > 10 then
			manualStorageItem.ManualLocations[manualStorageItem.ManualLocationsOrder[1]] = nil
			table.remove(manualStorageItem.ManualLocationsOrder, 1)
		end
		if manualStorageItem.ManualLocations[ROOM_SEED] == nil then
			manualStorageItem.ManualLocations[ROOM_SEED] = {}
			table.insert(manualStorageItem.ManualLocationsOrder, ROOM_SEED)
		end
	end
end

function OnClear(slot_data)
	if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
		print(string.format("called onClear, slot_data:\n%s", dump(slot_data)))
	end

	IS_MANUAL_CLICK = false
	local manualStorageItem = Tracker:FindObjectForCode(ManualStorageCode)
	if manualStorageItem == nil then
		CreateLuaManualLocationStorage(ManualStorageCode)
	end
	manualStorageItem = Tracker:FindObjectForCode(ManualStorageCode).ItemState

	PreOnClear()

	SLOT_DATA = slot_data
	CUR_INDEX = -1
	-- reset locations
	for _, location_array in pairs(LOCATION_MAPPING) do
		for _, location in pairs(location_array) do
			if location then
				local obj = Tracker:FindObjectForCode(location)
				if obj then
				if location:sub(1, 1) == "@" then
					---@cast obj LocationSection
					if manualStorageItem and manualStorageItem.ManualLocations[ROOM_SEED] and manualStorageItem.ManualLocations[ROOM_SEED][obj.FullID] then
						obj.AvailableChestCount = manualStorageItem.ManualLocations[ROOM_SEED][obj.FullID]
					else
						obj.AvailableChestCount = obj.ChestCount
					end
				else
					---@cast obj JsonItem
					obj.Active = false
				end
			end
			end
		end
	end
	-- reset items
	for _, itemData in pairs(ITEM_MAPPING) do
		if itemData[1] and itemData[2] then
			if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
				print(string.format("onClear: clearing item %s of type %s", itemData[1], itemData[2]))
			end
			local obj = Tracker:FindObjectForCode(itemData[1])
			if obj then
				if itemData[2] == "toggle" then
					obj.Active = false
				elseif itemData[2] == "progressive" then
					obj.CurrentStage = 0
					obj.Active = false
				elseif itemData[2] == "consumable" or itemData[2] == "pact" then
					obj.AcquiredCount = 0
				elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
					print(string.format("onClear: unknown item type %s for code %s", itemData[2], itemData[1]))
				end
			elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
				print(string.format("onClear: could not find object for code %s", itemData[1]))
			end
		end
	end

	PLAYER_ID = Archipelago.PlayerNumber or -1
	TEAM_NUMBER = Archipelago.TeamNumber or 0

	if Archipelago.PlayerNumber > -1 then
		HINTS_ID = "_read_hints_"..TEAM_NUMBER.."_"..PLAYER_ID
		if Highlight then
			Archipelago:SetNotify({HINTS_ID})
			Archipelago:Get({HINTS_ID})
		end
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
	-- location system and heat system are for some reason offset by 1
	Tracker:FindObjectForCode("location_system").CurrentStage = slot_data["location_system"] - 1
	Tracker:FindObjectForCode("heat_system").CurrentStage = slot_data["heat_system"] - 1
	-- on reading Pact settings, set Pact items to the same
	for k, v in pairs(PactMapping) do
		Tracker:FindObjectForCode(v).AcquiredCount = slot_data[k]
	end

	-- get initial weapon, and mark off the contractor location
	Tracker:FindObjectForCode(InitialWeaponDict[slot_data["initial_weapon"]][1]).Active = true
	Tracker:FindObjectForCode(InitialWeaponDict[slot_data["initial_weapon"]][2]).AvailableChestCount = 0

	IS_MANUAL_CLICK = true
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
	CUR_INDEX = index;
	local itemData = ITEM_MAPPING[item_id]
	if not itemData then
		if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
			print(string.format("onItem: could not find item mapping for id %s", item_id))
		end
		return
	end
	if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
		print(string.format("onItem: code: %s, type %s", itemData[1], itemData[2]))
	end
	if not itemData[1] then
		return
	end
	local item = Tracker:FindObjectForCode(itemData[1])
	if item then
		if itemData[2] == "toggle" then
			item.Active = true
		elseif itemData[2] == "progressive" then
			if item.Active then
				item.CurrentStage = item.CurrentStage + 1
			else
				item.Active = true
			end
		elseif itemData[2] == "consumable" then
			local mult = 1
			if (itemData[3]) then
				mult = itemData[3]
			end
			item.AcquiredCount = item.AcquiredCount + (item.Increment * mult)
			if (item.AcquiredCount > item.MaxCount) then
				item.AcquiredCount = item.MaxCount
			end
			if (item.AcquiredCount < item.MinCount) then
				item.AcquiredCount = item.MinCount
			end
		elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
			print(string.format("onItem: unknown item type %s for code %s", itemData[2], itemData[1]))
		end
	elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
		print(string.format("onItem: could not find object for code %s", itemData[1]))
	end
end

-- called when a location gets cleared
function OnLocation(location_id, location_name)
	if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
		print("called onLocation:", location_name)
	end

	IS_MANUAL_CLICK = false

	SetAsStale()
	local locationTable = LOCATION_MAPPING[location_id]
	if not locationTable or not locationTable[1] then
		print(string.format("onLocation: could not find location mapping for id %s", location_id))
		return
	end

	for _, code in pairs(locationTable) do
		local obj = Tracker:FindObjectForCode(code)
		-- print(location, obj)
		if obj then
			if code:sub(1, 1) == "@" then
				---@cast obj LocationSection
				obj.AvailableChestCount = obj.AvailableChestCount - 1
			else
				-- hosted item
				---@cast obj JsonItem|LuaItem
				obj.Active = true
			end
			UpdateHints(location_id, Highlight.None)
		else
			print(string.format("onLocation: could not find object for code %s", code))
		end
	end

	IS_MANUAL_CLICK = true
end

---@param location LocationSection
function ManualLocationHandler(location)
	if IS_MANUAL_CLICK then
		local manualStorageItem = Tracker:FindObjectForCode(ManualStorageCode)
		if not manualStorageItem then
			return
		end
		manualStorageItem = manualStorageItem.ItemState
		if not manualStorageItem then
			return
		end
		if Archipelago.PlayerNumber == -1 and ROOM_SEED ~= DEFAULT_SEED then
			-- seed is from previous connection
			ROOM_SEED = DEFAULT_SEED
			manualStorageItem.ManualLocations[ROOM_SEED] = {}
		end
		local fullID = location.FullID
		if not manualStorageItem.ManualLocations[ROOM_SEED] then
			manualStorageItem.ManualLocations[ROOM_SEED] = {}
		end
		if location.AvailableChestCount < location.ChestCount then
			-- add to list
			manualStorageItem.ManualLocations[ROOM_SEED][fullID] = location.AvailableChestCount
			if Highlight then
				location.Highlight = Highlight.None
			end
		else
			-- remove from list of set back to max chestcount
			manualStorageItem.ManualLocations[ROOM_SEED][fullID] = nil
			if Highlight then
				-- run hints again just in case
				Archipelago:Get({HINTS_ID})
			end
		end
	end
end

function OnNotify(key, value, old_value)
	-- print(string.format("called onNotify: %s, %s, %s", key, dump(value), old_value))
	if value ~= old_value and key == HINTS_ID then
		for _, hint in ipairs(value) do
			if not hint.found and hint.finding_player == Archipelago.PlayerNumber then
				UpdateHints(hint.location, PriorityToHighlight[hint.status])
			else
				UpdateHints(hint.location, Highlight.None)
			end
		end
	end
end

function OnNotifyLaunch(key, value)
	-- print(string.format("Hint: %s", dump(value)))
	OnNotify(key, value)
end

-- called when a location is hinted or the status of a hint is changed
---@param locationID number
---@param status highlight
function UpdateHints(locationID, status)
	if not Highlight then
		return
	end
	local locationTable = LOCATION_MAPPING[locationID]
	if not locationTable then
		return
	end
	-- print("Hint", dump(locations), status)
	for _, location in ipairs(locationTable) do
		local section = Tracker:FindObjectForCode(location)
		---@cast section LocationSection
		if section then
			section.Highlight = status
		else
			print(string.format("No object found for code: %s", location))
		end
	end
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
Archipelago:AddSetReplyHandler("notify handler", OnNotify)
Archipelago:AddRetrievedHandler("notify launch handler", OnNotifyLaunch)