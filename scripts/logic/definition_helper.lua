-- Items
EternalRose = "keepsake_aphrodite"
BloodFilledVial = "keepsake_ares"
AdamantArrowhead = "keepsake_artemis"
OwlPendant = "keepsake_athena"
CosmicEgg = "keepsake_chaos"
FrostbittenHorn = "keepsake_demeter"
OverflowingCup = "keepsake_dionysus"
LambentPlume = "keepsake_hermes"
ConchShell = "keepsake_poseidon"
ThunderSignet = "keepsake_zeus"

-- Settings
HadesGoal = "goal_hades"
ScoreGoal = "goal_score"
WeaponGoal = "goal_weapon"
KeepsakeGoal = "goal_keepsake"
FateGoal = "goal_fate"

InitialWeaponDict = {
	[0] = "weapon_stygius",
	[1] = "weapon_coronacht",
	[2] = "weapon_varatha",
	[3] = "weapon_aegis",
	[4] = "weapon_malphon",
	[5] = "weapon_exagryph"
}

FateLocs = {
	"Fated List/Fated List of Minor Prophecies/Is There No Escape?",
	"Fated List/Fated List of Minor Prophecies/Distant Relatives",
	"Fated List/Fated List of Minor Prophecies/Chthonic Colleagues",
	"Fated List/Fated List of Minor Prophecies/The Reluctant Musician",
	"Fated List/Fated List of Minor Prophecies/Goddess Of Wisdom",
	"Fated List/Fated List of Minor Prophecies/God Of The Heavens",
	"Fated List/Fated List of Minor Prophecies/God Of The Sea",
	"Fated List/Fated List of Minor Prophecies/Goddess Of Love",
	"Fated List/Fated List of Minor Prophecies/God Of War",
	"Fated List/Fated List of Minor Prophecies/Goddess Of The Hunt",
	"Fated List/Fated List of Minor Prophecies/God Of Wine",
	"Fated List/Fated List of Minor Prophecies/God Of Swiftness",
	"Fated List/Fated List of Minor Prophecies/Goddess Of Seasons",
	"Fated List/Fated List of Minor Prophecies/Power Without Equal",
	"Fated List/Fated List of Minor Prophecies/Divine Pairings",
	"Fated List/Fated List of Minor Prophecies/Primordial Boons",
	"Fated List/Fated List of Minor Prophecies/Primordial Banes",
	"Fated List/Fated List of Minor Prophecies/Infernal Arms",
	"Fated List/Fated List of Minor Prophecies/The Stygian Blade",
	"Fated List/Fated List of Minor Prophecies/The Heart Seeking Bow",
	"Fated List/Fated List of Minor Prophecies/The Shield Of Chaos",
	"Fated List/Fated List of Minor Prophecies/The Eternal Spear",
	"Fated List/Fated List of Minor Prophecies/The Twin Fists",
	"Fated List/Fated List of Minor Prophecies/The Adamant Rail",
	"Fated List/Fated List of Minor Prophecies/Master Of Arms",
	"Fated List/Fated List of Minor Prophecies/A Violent Past",
	"Fated List/Fated List of Minor Prophecies/Harsh Conditions",
	"Fated List/Fated List of Minor Prophecies/Slashed Benefits",
	"Fated List/Fated List of Minor Prophecies/Wanton Ransacking",
	"Fated List/Fated List of Minor Prophecies/A Simple Job",
	"Fated List/Fated List of Minor Prophecies/Chthonic Knowledge",
	"Fated List/Fated List of Minor Prophecies/Customer Loyalty",
	"Fated List/Fated List of Minor Prophecies/Dark Reflections",
	"Fated List/Fated List of Minor Prophecies/Close At Heart",
	"Fated List/Fated List of Minor Prophecies/Denizens Of The Deep",
	"Fated List/Fated List of Minor Prophecies/The Useless Trinket"
}

-- SlotData
SlotDataTable = {
	-- checks
	-- "initial_weapon",
	{"location_system", "progressive"},
	{"score_rewards_amount", "consumable"},
	-- sanities
	{"keepsakesanity", "toggle"},
	{"weaponsanity", "toggle"},
	{"hidden_aspectsanity", "toggle"},
	{"storesanity", "toggle"},
	{"fatesanity", "toggle"},
	{"hades_defeats_needed", "consumable"},
	{"weapons_clears_needed", "consumable"},
	{"keepsakes_needed", "consumable"},
	{"fates_needed", "consumable"},
	{"heat_system", "progressive"},
	-- pact items
	{"hard_labor_pact_amount", "consumable"},
	{"lasting_consequences_pact_amount", "consumable"},
	{"convenience_fee_pact_amount", "consumable"},
	{"jury_summons_pact_amount", "consumable"},
	{"extreme_measures_pact_amount", "consumable"},
	{"calisthenics_program_pact_amount", "consumable"},
	{"benefits_package_pact_amount", "consumable"},
	{"middle_management_pact_amount", "consumable"},
	{"underworld_customs_pact_amount", "consumable"},
	{"forced_overtime_pact_amount", "consumable"},
	{"heightened_security_pact_amount", "consumable"},
	{"routine_inspection_pact_amount", "consumable"},
	{"damage_control_pact_amount", "consumable"},
	{"approval_process_pact_amount", "consumable"},
	{"tight_deadline_pact_amount", "consumable"},
	{"personal_liability_pact_amount", "consumable"},
	-- filler item amounts
	-- "darkness_pack_value",
	-- "gemstones_pack_value",
	-- "keys_pack_value",
	-- "diamonds_pack_value",
	-- "titan_blood_pack_value",
	-- "nectar_pack_value",
	-- "ambrosia_pack_value",
	-- helpers
	-- "filler_helper_percentage",
	-- "max_health_helper_percentage",
	-- "initial_money_helper_percentage",
	-- "filler_trap_percentage",
	{"reverse_order_em", "progressive"},

	-- "ignore_greece_deaths",
	-- "store_give_hints",
	-- "automatic_rooms_finish_on_hades_defeat",
	-- "death_link",

	-- "version_check",
	-- "seed"
}