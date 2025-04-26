extends Node2D

@export var countdown_timer = 60
@export var extraction_timer = 20

@onready var rescue_area = $Area2D/CollisionShape2D
@onready var lifespan_timer = get_node("%ExpirationTimer")
@onready var rescue_timer = get_node("%ExtractionTimer")

var player_nearby = false

func _ready():
	lifespan_timer.wait_time = countdown_timer
	rescue_timer.wait_time = extraction_timer
	lifespan_timer.start()


func _process(delta):
	if player_nearby:
		if rescue_timer.is_stopped():
			rescue_timer.start()
	else:
		if rescue_timer.is_stopped() == false:
			rescue_timer.stop()  # or reduce progress if you want harder mechanic


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_nearby = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_nearby = false


func _on_expiration_timer_timeout() -> void:
	queue_free()  # Civilian dies / disappears
	
	


func _on_extraction_timer_timeout() -> void:
	pass # Replace with function body.
