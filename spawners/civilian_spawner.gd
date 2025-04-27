extends Node2D

@export var initial_delay = 20
@export var cooldown = 40

@onready var timer = $Timer
@onready var civilian_scene = preload("res://scenes/civilians/civilians.tscn")

func _ready() -> void:
	timer.wait_time = initial_delay
	timer.start()  

func _on_timer_timeout() -> void:
	var civilian = civilian_scene.instantiate()
	civilian.connect("civilian_done", Callable(self, "_on_civilian_done"))
	add_child(civilian)

func _on_civilian_done():
	timer.wait_time = cooldown
	timer.start()
