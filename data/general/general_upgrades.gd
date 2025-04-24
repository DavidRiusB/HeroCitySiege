const ICON_PATH = "res://assets/items/Upgrades/"

const GENERAL_UPGRADES = {
	"exo_armor": {
		"icon": ICON_PATH + "helmet_1.png",
		"display_name": "Exo-Armor",
		"details": "Reduces incoming damage by 1 point.",
		"level": 1,
		"target": "armor",
		"amount": 1,
		"prerequisite": [],
		"type": "upgrade"
	},
	"exo_armor_2": {
		"icon": ICON_PATH + "helmet_1.png",
		"display_name": "Exo-Armor Mk II",
		"details": "Further reduces damage by 1 point.",
		"level": 2,
		"target": "armor",
		"amount": 1,
		"prerequisite": ["exo_armor"],
		"type": "upgrade"
	},
	"exo_armor_3": {
		"icon": ICON_PATH + "helmet_1.png",
		"display_name": "Exo-Armor Mk III",
		"details": "Reduces damage by another 1 point.",
		"level": 3,
		"target": "armor",
		"amount": 1,
		"prerequisite": ["exo_armor_2"],
		"type": "upgrade"
	},

	"quantum_boots_1": {
		"icon": ICON_PATH + "boots_4_green.png",
		"display_name": "Quantum Boots",
		"details": "Boosts movement speed by 50%.",
		"level": 1,
		"target": "movement_speed",
		"amount": 10,
		"prerequisite": [],
		"type": "upgrade"
	},
	"quantum_boots_2": {
		"icon": ICON_PATH + "boots_4_green.png",
		"display_name": "Quantum Boots Mk II",
		"details": "Further boosts movement speed by 50%.",
		"level": 2,
		"target": "movement_speed",
		"amount":10,
		"prerequisite": ["quantum_boots_1"],
		"type": "upgrade"
	},

	"psi_tome_1": {
		"icon": ICON_PATH + "thick_new.png",
		"display_name": "Psi-Tome Mk I",
		"details": "Increases spell size by 10%.",
		"level": 1,
		"target": "projectile_size",
		"amount": 0.2,
		"prerequisite": [],
		"type": "upgrade"
	},
	"psi_tome_2": {
		"icon": ICON_PATH + "thick_new.png",
		"display_name": "Psi-Tome Mk II",
		"details": "Further increases spell size by 10%.",
		"level": 2,
		"target": "projectile_size",
		"amount": 0.2,
		"prerequisite": ["psi_tome_1"],
		"type": "upgrade"
	},

	"accelerator_1": {
		"icon": ICON_PATH + "scroll_old.png",
		"display_name": "Time Scroll",
		"details": "Reduces spell cooldowns by 5%.",
		"level": 1,
		"target": "fire_rate",
		"amount": 0.05,
		"prerequisite": [],
		"type": "upgrade"
	},
	"accelerator_2": {
		"icon": ICON_PATH + "scroll_old.png",
		"display_name": "Time Scroll Mk II",
		"details": "Further reduces cooldowns by 5%.",
		"level": 2,
		"target": "fire_rate",
		"amount": 0.05,
		"prerequisite": ["accelerator_1"],
		"type": "upgrade"
	},

	"replicator_ring_1": {
		"icon": ICON_PATH + "urand_mage.png",
		"display_name": "Replicator Ring",
		"details": "Your spells spawn 1 additional attack.",
		"level": 1,
		"target": "additional_attacks",
		"amount": 1,
		"prerequisite": [],
		"type": "upgrade"
	},
	"replicator_ring_2": {
		"icon": ICON_PATH + "urand_mage.png",
		"display_name": "Replicator Ring Mk II",
		"details": "Spells spawn yet another attack.",
		"level": 2,
		"target": "additional_attacks",
		"amount": 1,
		"prerequisite": ["replicator_ring_1"],
		"type": "upgrade"
	},

	"med_pad": {
		"icon": ICON_PATH + "chunk.png",
		"display_name": "MedPAd",
		"details": "Restores 20 health.",
		"level": 1,
		"target": "health",
		"amount": 20,
		"prerequisite": [],
		"type": "item"
	}
}
