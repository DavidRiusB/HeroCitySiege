extends Area2D

# ==== Node References ====
@onready var animator = $Javelin_animator
@onready var collision = $CollisionShape2D
@onready var ability_timer = $%AbilityTimer
@onready var change_direction = $ChangeDirectionTimer
@onready var snd_attack = $snd_attack

# ==== Signals ====
signal remove_from_arr(object)

# ==== Configurable Stats ====
@export var follow_distance_threshold = 100.0
@export var follow_margin = 10.0
@export var movement_speed = 20.0
@export var level = 1

# ==== Base Combat Stats ====
var fire_rate = 4.0
var damage = 0
var knockback_amount = 100
var paths = 0 # Number of simultaneous targets to attack
var attack_size = 1.0
var attack_speed = 200.0

# ==== State Variables ====
var target_array = [] # Current target points (Vector2)
var player
var is_following_player = false
var target = Vector2.ZERO
var angle = Vector2.ZERO
var reset_position = Vector2.ZERO

func  _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	ability_timer.wait_time = fire_rate
	animator.play("Idle")
	set_stats()
	
		
func update_javelin():
	damage

func _process(delta: float) -> void:
	if not player:
		return
	
	# Check distance to player to decide whether to follow
	var distance_to_player = global_position.distance_to(player.global_position)
		
	if target_array.is_empty():

		if not is_following_player and distance_to_player > follow_distance_threshold + follow_margin:
			is_following_player = true

		if is_following_player and distance_to_player < follow_distance_threshold - follow_margin:
			is_following_player = false

		# Behavior depending on mode
		if is_following_player:
			follow_player(delta)
		else:
			animator.play("Idle")

			
	else:
		position += angle * attack_speed * delta # Move independently		
		

func follow_player(delta: float) -> void:
	var direction = global_position.direction_to(player.global_position)
	animator.flip_h = direction.x < 0
	global_position += direction * movement_speed * delta
	animator.play("Run")

		
		


func  add_paths():
	snd_attack.play()
	emit_signal("remove_from_arr", self)
	target_array.clear()
	var counter = 0
	while  counter < paths:
		var new_path = get_random_target()
		if new_path:
			target_array.append(new_path.global_position)
			counter += 1
			enable_attack(true)	
	target = target_array[0]	
	process_path()
	
func process_path():	
	angle = global_position.direction_to(target)
	change_direction.start()


func _on_ability_timer_timeout() -> void:
	add_paths()
	
func _on_change_direction_timer_timeout() -> void:
	if not target_array.is_empty():
		target_array.remove_at(0)
		if not target_array.is_empty():
			target = target_array[0]	
			process_path()
			snd_attack.play()
			emit_signal("remove_from_arr", self)
		else:
			enable_attack(false)
	else:
		change_direction.stop()
		ability_timer.start()
		enable_attack(false)
			
			
func get_random_target():
	var targets = player.enemies_in_range
	if not targets.is_empty():
		target = targets.pick_random()
		if target:
			return target
	return null
	
func enable_attack(active: bool = true):
	if active:		
		collision.call_deferred("set", "disabled", false)
		animator.play("Attack")
	else:		
		collision.call_deferred("set", "disabled", true)
		animator.play("Run")
		
func set_stats() -> void:
	match level:
		1:
			damage = 5
			paths = 1
		2:
			damage = 10
			paths = 2
		3:
			damage = 15
			paths = 3
		_:
			damage = 5
			paths = 1

			
			
		
