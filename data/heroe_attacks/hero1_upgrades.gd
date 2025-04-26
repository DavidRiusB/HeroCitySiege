const ICON = "res://assets/items/Weapons/ice_spear.png"

const ATTACK_UPGRADES = {
	"ice_lance_1": {
		"icon": ICON,
		"display_name": "Ice Lance I",
		"details": "Shoots an additional ice lance at a random enemy.",
		"level": 2,
		"prerequisite": [],
		"type": "hero"
	},
	"ice_lance_2": {
		"icon": ICON,
		"display_name": "Ice Lance II",
		"details": "Shoots an additional ice lance at a random enemy.",
		"level": 3,
		"prerequisite": ["ice_lance_1"],
		"type": "hero"
	}
}
