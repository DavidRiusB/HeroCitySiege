extends Area2D

@export_enum("cool_down", "hit_once", "disable_hit_box")
var hurt_box_type = 0
@export var damage_interval = 1.0  # Time in seconds between damage applications

@onready var collision = $CollisionShape2D
@onready var disable_timer = $DisableTimer

signal hurt(damage)

var damage_timer = 0.0

func _ready():
	print("HurtBox ready")

func _on_area_entered(area: Area2D):
	print("Area entered: ", area.name)
	if area.is_in_group("attack") and area.get("damage") != null:
		print("Area is in group 'attack' and has damage: ", area.get("damage"))
		match hurt_box_type:
			1: # Hit once
				print("HurtBox type: Hit once")
				emit_signal("hurt", area.get("damage"))
				print("Ouch! (Hit once)")
				disable_timer.start()
			2: # Disable hit Box
				print("HurtBox type: Disable hit box")
				if area.has_method("temp_disable"):
					area.temp_disable()
					print("Ouch! (Disable hit box)")
				else:
					print("Area does not have method 'temp_disable'")

func _on_disable_timer_timeout():
	collision.call_deferred("set", "disable", false)
	print("Disable timer time out!")

func _physics_process(delta):
	damage_timer -= delta
	if damage_timer <= 0.0:
		for area in get_overlapping_areas():
			if area.is_in_group("attack") and area.get("damage") != null:
				match hurt_box_type:
					0: # Cooldown
						print("HurtBox type: Cooldown")
						emit_signal("hurt", area.get("damage"))
						damage_timer = damage_interval
						print("Ouch! (Cooldown)")
						if area.has_method("_enemy_hit"):
							area._enemy_hit(1)
