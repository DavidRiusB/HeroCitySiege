const ICON_PATH = "res://assets/items/Upgrades/"

const GENERAL_UPGRADES = {
	"exo_armor": {
		"icon": ICON_PATH + "helmet_1.png",
		"display_name": "Exo-Armor",
		"details": "Reduces incoming damage by 1 point.",
		"level": 1,
		"prerequisite": [],
		"type": "upgrade"
	},
	"exo_armor_2": {
		"icon": ICON_PATH + "helmet_1.png",
		"display_name": "Exo-Armor Mk II",
		"details": "Further reduces damage by 1 point.",
		"level": 2,
		"prerequisite": ["exo_armor_1"],
		"type": "upgrade"
	},
	"exo_armor_3": {
		"icon": ICON_PATH + "helmet_1.png",
		"display_name": "Exo-Armor Mk III",
		"details": "Reduces damage by another 1 point.",
		"level": 3,
		"prerequisite": ["exo_armor_2"],
		"type": "upgrade"
	},

	"quantum_boots_1": {
		"icon": ICON_PATH + "boots_4_green.png",
		"display_name": "Quantum Boots",
		"details": "Boosts movement speed by 50%.",
		"level": 1,
		"prerequisite": [],
		"type": "upgrade"
	},
	"quantum_boots_2": {
		"icon": ICON_PATH + "boots_4_green.png",
		"display_name": "Quantum Boots Mk II",
		"details": "Further boosts movement speed by 50%.",
		"level": 2,
		"prerequisite": ["quantum_boots_1"],
		"type": "upgrade"
	},

	"psi_tome_1": {
		"icon": ICON_PATH + "thick_new.png",
		"display_name": "Psi-Tome",
		"details": "Increases spell size by 10%.",
		"level": 1,
		"prerequisite": [],
		"type": "upgrade"
	},
	"psi_tome_2": {
		"icon": ICON_PATH + "thick_new.png",
		"display_name": "Psi-Tome Mk II",
		"details": "Further increases spell size by 10%.",
		"level": 2,
		"prerequisite": ["psi_tome_1"],
		"type": "upgrade"
	},

	"accelerator_1": {
		"icon": ICON_PATH + "scroll_old.png",
		"display_name": "Time Scroll",
		"details": "Reduces spell cooldowns by 5%.",
		"level": 1,
		"prerequisite": [],
		"type": "upgrade"
	},
	"accelerator_2": {
		"icon": ICON_PATH + "scroll_old.png",
		"display_name": "Time Scroll Mk II",
		"details": "Further reduces cooldowns by 5%.",
		"level": 2,
		"prerequisite": ["time_scroll_1"],
		"type": "upgrade"
	},

	"replicator_ring_1": {
		"icon": ICON_PATH + "urand_mage.png",
		"display_name": "Replicator Ring",
		"details": "Your spells spawn 1 additional attack.",
		"level": 1,
		"prerequisite": [],
		"type": "upgrade"
	},
	"replicator_ring_2": {
		"icon": ICON_PATH + "urand_mage.png",
		"display_name": "Replicator Ring Mk II",
		"details": "Spells spawn yet another attack.",
		"level": 2,
		"prerequisite": ["replicator_ring_1"],
		"type": "upgrade"
	}
}
