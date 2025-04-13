extends Area2D

@export var damage = 1
@onready var collision = $CollisionShape2D
@onready var disable_timer = $DiableHitBoxTimer

func temp_disable():
	collision.call_deferred("set", "disable", true)
	disable_timer.start()


func _on_diable_hit_box_timer_timeout():
	collision.call_deferred("set", "disable", false)
