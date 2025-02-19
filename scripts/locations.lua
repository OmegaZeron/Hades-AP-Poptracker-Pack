-- locations
Tracker:AddLocations("locations/areas.json")
Tracker:AddLocations("locations/keepsakes.json")
Tracker:AddLocations("locations/shop_fatedlist.json")
-- Tracker:AddLocations("locations/scores.json")

-- scripts
require("scripts/logic/items/keepsakes")
require("scripts/logic/locations/areas")