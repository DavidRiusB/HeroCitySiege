extends Area2D
@export_enum("cool_down", "hit_once", "disable_hit_box" ) var hurt_box_type = 0
@export var damage_interval = 1.0  # Time in seconds between damage applications

@onready var collision = $CollisionShape2D
@onready var diable_timer = $DisableTimer

signal hurt(damage)

func _on_area_entered(area: Area2D):
	if area.is_in_group("attack"):
		if not area.get("damage") == null:
			match hurt_box_type:
				0: #Cooldown
				
					diable_timer.start()
				1: #Hit once
					pass
				2: #Disable hit Box
					if area.has_method("temp_disable"):
						area.temp_disable()
			

func _on_disable_timer_timeout():
	collision.call_deferred("set", "disable", false)
	print("disable timer time out!")

var damage_timer = 0.0

func _physics_process(delta):
	damage_timer -= delta
	if damage_timer <= 0.0:
		for area in get_overlapping_areas():
			if area.is_in_group("attack") and area.get("damage") != null:
				emit_signal("hurt", area.damage)
				damage_timer = damage_interval
				print("Ouch!")
				break  # Apply damage once per interval
	
	
