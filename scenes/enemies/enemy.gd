extends CharacterBody2D

@export var  movement_speed = 20.0
@export var hp = 10
@export var knockback_recovery = 3.5
@export var experience = 1


var knockback = Vector2.ZERO

@onready var player = get_tree().get_first_node_in_group("player")
@onready var loot_base = get_tree().get_first_node_in_group("loot")
@onready var snd_hit = $snd_hit
@onready var sprite = $Sprite2D

var death_anim = preload("res://scenes/enemies/explosion.tscn")
var exp_gem = preload("res://objects/experiance_gem.tscn")

signal remove_from_arr(object)

func _physics_process(_delta):
	knockback = knockback.move_toward(Vector2.ZERO, knockback_recovery)
	var direction = global_position.direction_to(player.global_position)
	velocity = direction*movement_speed
	velocity += knockback
	move_and_slide()

func death():
	emit_signal("remove_from_arr", self)
	var enemy_death = death_anim.instantiate()
	enemy_death.scale = sprite.scale
	enemy_death.global_position = global_position
	get_parent().call_deferred("add_child", enemy_death)
	var new_gem = exp_gem.instantiate()
	new_gem.global_position = global_position
	new_gem.experience = experience
	loot_base.call_deferred("add_child", new_gem)
	queue_free()
	
func _on_hurt_box_hurt(damage: int, angle, knockback_amount):
	hp -=damage
	knockback = angle * knockback_amount
	if hp <= 0:
		death()		
	else:
		snd_hit.play()
		print("Enemy hit: ", hp)
