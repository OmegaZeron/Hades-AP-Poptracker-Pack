require("scripts/logic/definition_helper")
require("scripts/logic/logic")
require("scripts/logic/location_definitions")
require("scripts/logic/logic_helper")
require("scripts/utils")
require("scripts/autotracking")
require("scripts/locations")

Tracker:AddItems("items/items.jsonc")
Tracker:AddItems("items/hints.jsonc")

Tracker:AddItems("items/pack_settings.jsonc")
Tracker:AddItems("items/labels.jsonc")
Tracker:AddMaps("maps/maps.jsonc")

Tracker:AddLayouts("layouts/item_grids.jsonc")
Tracker:AddLayouts("layouts/tracker_layouts.jsonc")
Tracker:AddLayouts("layouts/broadcast.jsonc")

StateChange()