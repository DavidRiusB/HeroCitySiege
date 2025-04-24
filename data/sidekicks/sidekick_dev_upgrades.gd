extends Node

const ICON = "res://assets/items/Weapons/javelin_3_new_attack.png"

const SIDEKICK_UPGRADES = {
	"sidekick_dev1": {
		"name": "sidekick_dev",
		"path":"res://scenes/sidekick/sidekick_dev.tscn",
		"icon": ICON,
		"display_name": "Sidekick Strike I",
		"details": "The samurai dashes and slices through enemies.",
		"level": 1,
		"prerequisite": [],
		"type": "sidekick"
	},
	"sidekick_dev2": {
		"name": "sidekick_dev",
		"icon": ICON,
		"display_name": "Sidekick Strike II",
		"details": "The samurai dashes and slices enemies twice in quick succession.",
		"level": 2,
		"prerequisite": ["sidekick_dev1"],
		"type": "sidekick"
	}
}
