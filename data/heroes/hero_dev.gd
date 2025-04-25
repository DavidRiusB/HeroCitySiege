extends Node

const HERO = {
	stats = {
		movement_speed = 40.0,
		health = 100,
		max_health = 100,
		armor = 0,
		fire_rate = 0,
		projectile_size = 0,
		additional_attacks = 0,
	},
	animator_path = "res://scenes/animations/AnimatorTest.tscn",
	attack_scene_path = "res://scenes/player/Attack/IceSpear/ice_spear.tscn",
	attack_upgrades_path = "res://data/hero_attacks/hero1_upgrades.gd",	
}
