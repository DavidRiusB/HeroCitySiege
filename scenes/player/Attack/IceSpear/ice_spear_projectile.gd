extends Node2D

var level: int
var hp: int
var speed: int
var damage: int
var knockback_amount: int
var attack_size: float

var target = Vector2.ZERO
var angle = Vector2.ZERO

var player

signal remove_from_arr(object)

func _ready():
	angle = global_position.direction_to(target)
	rotation = angle.angle() + deg_to_rad(135)

	var tween = create_tween()
	tween.tween_property(self,"scale", Vector2(1,1) * attack_size, 1).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.play()
	
	
func _physics_process(delta: float) -> void:
	position += angle * speed * delta
	
func _enemy_hit(charge = 1):
	hp -= charge
	if hp <= 0:
		emit_signal("remove_from_arr", self)
		queue_free()

func _on_timer_timeout() -> void:
	emit_signal("remove_from_arr", self)
	queue_free()
