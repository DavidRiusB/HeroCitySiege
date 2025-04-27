extends Node2D

@export var countdown_timer = 60
@export var extraction_timer = 20

@onready var rescue_area = $Area2D/CollisionShape2D
@onready var lifespan_timer = get_node("%ExpirationTimer")
@onready var rescue_timer = get_node("%ExtractionTimer")

signal civilian_done

var player_nearby = false

func _ready():
	var initial_position = get_initial_position()
	self.global_position = initial_position
	lifespan_timer.wait_time = countdown_timer
	rescue_timer.wait_time = extraction_timer
	lifespan_timer.start()
	
func get_initial_position() -> Vector2:
	var player = get_tree().get_first_node_in_group("player")
	if player:
		var angle = randf() * TAU # Random angle in radians
		var offset = Vector2(cos(angle), sin(angle)) * 200
		return player.global_position + offset
	return Vector2.ZERO


func _process(delta):
	if player_nearby and rescue_timer.is_stopped():
		rescue_timer.start()
	elif not player_nearby and not rescue_timer.is_stopped():
		rescue_timer.stop()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_nearby = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_nearby = false


func _on_expiration_timer_timeout() -> void:
	print("Civilians have died")
	emit_signal("civilian_done")
	queue_free()  # Civilian dies / disappears

func _on_extraction_timer_timeout() -> void:
	print("Civilains rescued")
	emit_signal("civilian_done")
	queue_free()  # Civilian dies / disappears
	

	
