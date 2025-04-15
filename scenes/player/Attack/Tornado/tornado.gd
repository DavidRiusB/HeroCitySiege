extends Node2D

var tornado_hp = 9999
var tornado_ammo = 0
var tornado_base_ammo = 5
@export var tornado_attack_speed = 3
@export var fire_rate = 0.075
@export var level = 1

@onready var projectile_scene = preload("res://scenes/player/Attack/Tornado/tornado_projectile.tscn")
@onready var player 
@onready var ability_timer = get_node("%AbilityTimer")
@onready var attack_timer = get_node("%AttackTimer")

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	print("Tornado Got player")
	
func update(delta):
	if level > 0:
		ability_timer.wait_time = tornado_attack_speed
		attack_timer.wait_time = fire_rate
		if ability_timer.is_stopped():
			ability_timer.start()



func _on_ability_timer_timeout() -> void:
	tornado_ammo += tornado_base_ammo
	attack_timer.start()


func _on_attack_timer_timeout() -> void:
	if tornado_ammo > 0:
		var projectile = projectile_scene.instantiate()
		# Set values based on level
		var stats = get_projectile_stats_for_level(level)
		projectile.last_movement = player.last_direction
		projectile.hp = tornado_hp
		projectile.speed = stats.speed
		projectile.attack_size = stats.size
		projectile.position = player.global_position
		player.add_child(projectile)
		tornado_ammo -= 1
	else:
		attack_timer.stop()
		
	
func get_projectile_stats_for_level(lvl: int) -> Dictionary:
	match lvl:
		1:
			return {
				"speed": 100,
				"damage": 10,
				"knockback": 100,
				"size": 1.0
			}
		2:
			return {
				"hp": 2,
				"speed": 200,
				"damage": 10,
				"knockback": 150,
				"size": 1.2
			}
		# more levels...
		_:
			return {
				"speed": 100,
				"damage": 5,
				"knockback": 100,
				"size": 1.0
			}
	
