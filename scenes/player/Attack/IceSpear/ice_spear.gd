extends Node2D

@export var level = 2
var fire_rate = 0.075
var ice_spear_attack_speed = 1.5
var ice_spear_base_ammo = 1
var ice_spear_ammo = 0

@onready var projectile_scene = preload("res://scenes/player/Attack/IceSpear/ice_spear_projectile.tscn")
@onready var player 
@onready var ability_timer = get_node("%AbilityTimer")
@onready var attack_timer = get_node("%AttackTimer")

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	print("Ice spear Got player")

func update(delta):
	if level > 0:
		ability_timer.wait_time = ice_spear_attack_speed
		attack_timer.wait_time = fire_rate
		if ability_timer.is_stopped():
			ability_timer.start()

func _on_ability_timer_timeout() -> void:
	ice_spear_ammo += ice_spear_base_ammo
	if attack_timer.is_stopped():
		attack_timer.start()

# Inside your Ice Spear ability scene
func _on_attack_timer_timeout():
	if ice_spear_ammo > 0:
		var enemy_target = get_random_target()
		if enemy_target:
			var projectile = projectile_scene.instantiate()

			# Set values based on level
			var stats = get_projectile_stats_for_level(level)

			projectile.hp = stats.hp
			projectile.speed = stats.speed
			projectile.damage = stats.damage
			projectile.knockback_amount = stats.knockback
			projectile.attack_size = stats.size
			projectile.position = player.global_position
			projectile.target = enemy_target.global_position

			player.add_child(projectile)
			ice_spear_ammo -= 1
		else:
			attack_timer.stop()

func get_projectile_stats_for_level(lvl: int) -> Dictionary:
	match lvl:
		1:
			return {
				"hp": 1,
				"speed": 100,
				"damage": 5,
				"knockback": 100,
				"size": 1.0
			}
		2:
			return {
				"hp": 2,
				"speed": 120,
				"damage": 10,
				"knockback": 150,
				"size": 1.2
			}
		# more levels...
		_:
			return {
				"hp": 1,
				"speed": 100,
				"damage": 5,
				"knockback": 100,
				"size": 1.0
			}

			

func get_random_target():
	var enemies = player.enemies_in_range
	if enemies.size() > 0:
		return enemies[randi() % enemies.size()]
	return null 
