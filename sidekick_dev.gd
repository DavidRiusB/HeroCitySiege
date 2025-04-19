extends Area2D

# ==== Node References ====
@onready var animator = $Javelin_animator
@onready var collision = $Hitbox/CollisionShape2D
@onready var ability_timer = $%AbilityTimer
@onready var change_direction = $ChangeDirectionTimer
@onready var snd_attack = $snd_attack

# ==== Signals ====
signal remove_from_arr(object)

# ==== Configurable Stats ====
@export var follow_distance_threshold = 300.0
@export var follow_margin = 50.0
@export var movement_speed = 50.0
@export var level = 1

# ==== Base Combat Stats ====
var fire_rate = 4.0
var damage = 10
var knockback_amount = 100
var paths = 3 # Number of simultaneous targets to attack
var attack_size = 1.0
var attack_speed = 200.0

# ==== State Variables ====
var target_array = [] # Current target points (Vector2)
var player
var is_following_player = false
var target = Vector2.ZERO
var angle = Vector2.ZERO
var reset_position = Vector2.ZERO

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	if not player:
		print("Error: No player found for sidekick!")
	animator.play("Idle")
	ability_timer.wait_time = fire_rate
	ability_timer.start()
	
	
func _process(delta: float) -> void:
	if not player:
		return

	# Check distance to player to decide whether to follow
	var distance_to_player = global_position.distance_to(player.global_position)

	if not is_following_player and distance_to_player > follow_distance_threshold + follow_margin:
		is_following_player = true
	

	if is_following_player and distance_to_player < follow_distance_threshold - follow_margin:
		is_following_player = false


	# Behavior depending on mode
	if is_following_player:
		follow_player(delta)
	else:
		position += angle * attack_speed * delta # Move independently
		animator.play("Idle")
		
		

func follow_player(delta: float) -> void:
	var direction = global_position.direction_to(player.global_position)
	animator.flip_h = direction.x < 0
	global_position += direction * movement_speed * delta
	animator.play("Run")

		
func enable_attack(active: bool = true):
	if active:
		
		collision.call_deferred("set", "disable", false)
		animator.play("Attack")
	else:
		
		collision.call_deferred("set", "disable", true)
		animator.play("Idle")
		
	

func process_path():
	if target:
		snd_attack.play()
		animator.play("Attack")
		angle = global_position.direction_to(target.global_position)
		change_direction.start()
	else:
		enable_attack(false)		
		
		
func add_path():
	target_array.clear()
	print("Target_ array clear:", target_array)
	if player.enemies_in_range.is_empty():
		print("no enemys from player")
		return
	var counter = 0
	while counter < paths:
		var new_path = get_random_target()
		if new_path != null:
			target_array.append(new_path)
			counter += 1
			print("new path", new_path)
		else:
			return # No more valid targets, stop early
	if not target_array.is_empty():
		target = target_array[0]
		print("calling process path")
		enable_attack(true)
		process_path()
		

func get_random_target():
	var targets = player.enemies_in_range
	if not targets.is_empty():
		var target = targets.pick_random()
		if target:
			return target
	return null

	

func _on_change_direction_timer_timeout() -> void:
	if not target_array.is_empty():
		print("targets:", target_array.size())
		target_array.remove_at(0)
		if not target_array.is_empty():
			target = target_array[0]
			process_path()
			snd_attack.play()
		else:
			enable_attack(false)
			
	else:
		change_direction.stop()
		ability_timer.start()
		enable_attack(false)
		target_array.clear()
		is_following_player = true


func _on_ability_timer_timeout() -> void:
	add_path()
	print("Add path triggered")
