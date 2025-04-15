extends Area2D

@export var experience = 1  

var sprite_green = preload("res://assets/items/Gems/Gem_green.png")
var sprite_blue = preload("res://assets/items/Gems/Gem_blue.png")
var sprite_red = preload("res://assets/items/Gems/Gem_red.png")

var target = null
var speed = -1

@onready var sprite = $Sprite2D
@onready var collision_shape = $CollisionShape2D  # renamed for clarity
@onready var snd_collected = $snd_collected     # renamed for consistency


func free() -> void:
	if experience < 5:
		return
	elif experience < 25:
		sprite.texture = sprite_blue
	else:
		sprite.texture = sprite_red
		
func _physics_process(delta: float) -> void:
	if target != null:
		global_position = global_position.move_toward(target.global_position, speed)
		speed += 2 * delta
		
func collect():
	snd_collected.play()
	collision_shape.call_deferred("set", "disable", true)
	sprite.visible = false
	return experience
	
	

func _on_snd_collected_finished() -> void:
	queue_free()
