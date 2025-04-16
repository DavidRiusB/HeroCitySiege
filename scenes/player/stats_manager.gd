extends Node2D

@export var movement_speed = 40.0
@export var health = 100
var experience = 0
var character_level = 1
var collected_experience = 0

@onready var hub = preload("res://ui/hud.tscn")

signal level_up(level)
signal set_xp_bar(experience, experience_required)

func _ready() -> void:
	calculate_experience(0)

func _on_hurt_box_hurt(damage: Variant, _angle, _knockback):
	health -= damage
	print(health)


func _on_grab_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("loot"):
		area.target = self


func _on_collect_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("loot"):
		var gem_experience = area.collect()
		calculate_experience(gem_experience)
		
func calculate_experience(gem_experience):
	var experience_required = calculate_experience_cap()
	collected_experience += gem_experience
	if experience + collected_experience >= experience_required: #Lv up
		collected_experience -= experience_required - experience
		character_level += 1
		
		experience = 0
		experience_required = calculate_experience_cap()
		emit_signal("level_up")
		
	else:
		experience += collected_experience
		collected_experience = 0
		
	emit_signal("set_xp_bar",experience, experience_required)
		
	
func calculate_experience_cap():
	var exp_cap = character_level
	
	if character_level < 20:
		exp_cap = character_level * 5
	elif  character_level < 40:
		exp_cap = character_level* (character_level - 19) * 8
	else:
		exp_cap = 255 + (character_level - 39) * 12
		
	return exp_cap
