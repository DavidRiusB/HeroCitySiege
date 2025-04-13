extends Area2D

@export_enum("cool_down", "hit_once", "disable_hit_box")
var hurt_box_type = 0

@export var damage_interval = 1.0  # Time in seconds between damage applications

@onready var collision = $CollisionShape2D
@onready var disable_timer = $DisableTimer

signal hurt(damage, angle, knockback)

var hit_once_arr = []

var damage_timer = 0.0

func _ready():
	print("HurtBox ready")

func _on_area_entered(area: Area2D):
	print("Area entered: ", area.name)
	if area.is_in_group("attack") and area.damage != null:
		print("Area is in group 'attack' and has damage: ", area.damage)
		match hurt_box_type:
			1:  # Hit once
				print("HurtBox type: Hit once")
				if hit_once_arr.has(area) == false:
					hit_once_arr.append(area)
					if area.has_signal("remove_from_arr"):
						if not area.is_connected("remove_from_arr", Callable(self, "remove_from_list")):
							area.connect("remove_from_arr", Callable(self, "remove_from_list"))
					_apply_knockback(area)
				else:
					return
			2:  # Disable hit box
				print("HurtBox type: Disable hit box")
				if area.has_method("temp_disable"):
					area.temp_disable()
					print("Ouch! (Disable hit box)")
				else:
					print("Area does not have method 'temp_disable'")

func _on_disable_timer_timeout():
	collision.call_deferred("set", "disabled", false)
	print("Disable timer time out!")

func _physics_process(delta):
	damage_timer -= delta
	if damage_timer <= 0.0:
		for area in get_overlapping_areas():
			if area.is_in_group("attack") and area.damage != null:
				match hurt_box_type:
					0:  # Cooldown
						print("HurtBox type: Cooldown")
						_apply_knockback(area)
						damage_timer = damage_interval

func _emit_damage_signal(area, angle, knockback):
	emit_signal("hurt", area.get("damage"), angle, knockback)
	if area.has_method("_enemy_hit"):
		area._enemy_hit(1)

func _apply_knockback(area):
	var angle = Vector2.ZERO
	var knockback = 1

	if not area.get("angle") == null:
		angle = area.angle
	
	if not area.get("knockback_amount") == null:
		knockback = area.knockback_amount

	_emit_damage_signal(area, angle, knockback)
	
func remove_from_list(object):
	if hit_once_arr.has(object):
		hit_once_arr.erase(object)
	
