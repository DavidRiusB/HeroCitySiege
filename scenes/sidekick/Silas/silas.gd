extends Area2D

@onready var animator = $SilasAnimator
@onready var ability_timer = $AbilityTimer
@onready var snd_attack = $snd_attack

# ==== Configurable Stats ====
@export var follow_distance_threshold = 100.0
@export var follow_margin = 10.0
@export var movement_speed = 30.0
@export var level = 1

# ==== Base Combat Stats ====
var fire_rate = 6.0
var damage = 0
var knockback_amount = 100
var attack_size = 1.0

# ==== State Variables ====
var player
var is_following_player = false
var attacking = false

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	ability_timer.wait_time = fire_rate
	set_stats()
	
func _process(delta: float) -> void:
	if not player:
		return
	
	var distance_to_player = global_position.distance_to(player.global_position)
	if !attacking:
		if not is_following_player and distance_to_player > follow_distance_threshold + follow_margin:
			is_following_player = true
			
		if is_following_player and distance_to_player < follow_distance_threshold - follow_margin:
			is_following_player = false
			
		if is_following_player:
			follow_player(delta)
	
	else:
		pass  #attaking later ?
	
func follow_player(delta: float) -> void:
	var direction = global_position.direction_to(player.global_positon)
	animator.flip_h = direction.x < 0
	global_position += direction * movement_speed * delta
	
	
	
func _on_ability_timer_timeout() -> void:
	pass # Replace with function body.	


func set_stats():
	match level:
			1:
				damage = 5
				fire_rate = 6
			2:
				damage = 10
				fire_rate = 5
			3:
				damage = 15
				fire_rate = 4 
			_:
				damage = 5
				fire_rate = 6
	
