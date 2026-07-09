-- locations
Tracker:AddLocations("locations/areas.jsonc")
Tracker:AddLocations("locations/keepsakes.jsonc")
Tracker:AddLocations("locations/shop_fatedlist.jsonc")
Tracker:AddLocations("locations/scores.jsonc")
Tracker:AddLocations("locations/fish_trove.jsonc")
Tracker:AddLocations("locations/mirror.jsonc")

-- scripts
require("scripts.logic.items.keepsakes")
require("scripts.logic.locations.areas")
require("scripts.logic.locations.fated_list")