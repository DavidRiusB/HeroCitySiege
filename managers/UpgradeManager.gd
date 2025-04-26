extends Node

var sidekick = {}
var items = preload("res://data/items/items_upgrades.gd")
var attack_upgrades = {}
var upgrades = preload("res://data/general/general_upgrades.gd")

var collected_upgrades = {}  # Dictionary to store collected upgrades
var all_upgrades = {}  # Unified dictionary
var upgrades_pool = []  # Just the keys, for random selection

func _ready() -> void:
	load_sidekicks()
	load_hero_attack_upgrades()
	merge_all_upgrades()
	

func load_hero_attack_upgrades():
	var hero_data = GameManager.selected_hero.HERO
	var attack_upgrades_script = load(hero_data.attack_upgrades_path)
	if "ATTACK_UPGRADES" in attack_upgrades:
		attack_upgrades = attack_upgrades_script.ATTACK_UPGRADES
	else:
		print("Missing ATTACK_UPGRADES in ", attack_upgrades_script)
	

func load_sidekicks():
	var dir = DirAccess.open("res://data/sidekicks/")
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with(".gd"):
				var path = "res://data/sidekicks/" + file_name
				var script = load(path)
				if "SIDEKICK_UPGRADES" in script:
					sidekick.merge(script.SIDEKICK_UPGRADES)
				else:
					print("Missing SIDEKICK_UPGRADES in ", file_name)
			file_name = dir.get_next()

func merge_all_upgrades():
	all_upgrades = {}
	all_upgrades.merge(attack_upgrades)
	all_upgrades.merge(items.ITEM_UPGRADES)
	all_upgrades.merge(upgrades.GENERAL_UPGRADES)
	all_upgrades.merge(sidekick)
	upgrades_pool = all_upgrades.keys()

func get_random_upgrades(count: int = 3) -> Array:
	var valid_keys = []

	for key in upgrades_pool:
		# Skip if already collected
		if key in collected_upgrades:
			continue

		var upgrade = all_upgrades.get(key, null)
		if upgrade == null:
			continue

		# Check for prerequisites
		if "prerequisite" in upgrade and upgrade["prerequisite"].size() > 0:
			var all_met = true
			for prereq in upgrade["prerequisite"]:
				if prereq not in collected_upgrades:
					all_met = false
					break
			if !all_met:
				continue

		# Passed all checks, add to valid keys
		valid_keys.append(key)

	valid_keys.shuffle()

	var selected_upgrades = []
	for i in range(min(count, valid_keys.size())):
		var key = valid_keys[i]
		var upgrade = all_upgrades[key]
		selected_upgrades.append({
			"key": key,
			"upgrade": upgrade
		})

	print("Selected upgrade keys and upgrades:", selected_upgrades)
	return selected_upgrades

func apply_upgrade(upgrade_key: String) -> void:
	var upgrade = all_upgrades.get(upgrade_key, null)
	if upgrade == null:
		print("Invalid upgrade key:", upgrade_key)
		return

	if upgrade_key not in collected_upgrades:
		collected_upgrades[upgrade_key] = upgrade

	if upgrade.type == "upgrade":
		var target = upgrade.get("target", null)
		var amount = upgrade.get("amount", 0)

		if target != null:
			# Make sure the stat exists and safely update it
			StatsManager.update(target, amount)
	elif upgrade.type == "sidekick":
		SidekickManager.sidekick_upgrade(upgrade)

	print("Collected upgrades:", collected_upgrades)
