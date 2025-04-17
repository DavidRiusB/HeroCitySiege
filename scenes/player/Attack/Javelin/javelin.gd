extends Node2D

# ==== Base Stats ====
@export var level = 1
var fire_rate = 4.0
var javelin_attack_speed = 1.5
var damage = 10
var knockback_amount = 100
var paths = 3
var attack_size = 1.0
var movement_speed = 40.0
var attack_speed = 200.0
var target = Vector2.ZERO
var target_array = []
var angle = Vector2.ZERO
var reset_position = Vector2.ZERO
const FOLLOW_DISTANCE_THRESHOLD = 500.0

# ==== Nodes ====
@onready var player: Node2D = null	 
@onready var ability_timer = get_node("%AbilityTimer")
@onready var change_direction_timer = get_node("%ChangeDirection")
@onready var reset_position_timer = get_node("%ResetPosTimer")
@onready var collision = $Area2D/CollisionShape2D
@onready var snd_attack = $snd_attack

# ==== Signals ====
signal remove_from_arr(object)

# ==== Animator ====
@onready var animator = $JavelinAnimator

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	animator.play("Idle")
	print("Javelin got player")
	if level > 0:
		ability_timer.wait_time = fire_rate
		ability_timer.start()

func update(_delta):
	pass
	
func _physics_process(delta: float) -> void:
	if target_array.size() > 0:
		# If attacking, follow the current angle
		position += angle * attack_speed * delta
	else:
		# Only follow player if not attacking
		if player:
			var dist = global_position.distance_to(player.global_position)
			if dist > FOLLOW_DISTANCE_THRESHOLD:
				var follow_angle = global_position.direction_to(player.global_position)
				position += follow_angle * movement_speed
				animator.play("Run")
		else:
			print("WTF happened to the player!!!")
		
		
func _on_ability_timer_timeout() -> void:
	add_paths()

func add_paths():
	snd_attack.play()
	emit_signal("remove_from_arr", self)
	target_array.clear()
	var counter = 0
	while counter < paths:
		var new_path = get_random_target()
		if new_path != null:
			target_array.append(new_path)
			counter += 1
	if target_array.size() > 0:
		target = target_array[0]
		enable_attack(true)
		process_path()
				

	
func process_path():
	if target != null and target is Node2D:
		angle = global_position.direction_to(target.global_position)
		change_direction_timer.start()
	else:
		print("Invalid target in process_path")
		enable_attack(false)
		
	

func enable_attack(active: bool = true):
	if active:
		collision.call_deferred("set", "disable", false)
		animator.play("Attack")
	else:
		collision.call_deferred("set", "disable", true)
		animator.play("Idle")
		
		
		

func _on_change_direction_timeout() -> void:
	if target_array.size() > 0:
		target_array.remove_at(0)
		if target_array.size() > 0:
			target = target_array[0]
			process_path()
			snd_attack.play()
			emit_signal("remove_from_arr", self)
		else:
			enable_attack(false)
	else:
		change_direction_timer.stop()
		ability_timer.start()
		enable_attack(false)
		
func get_random_target():
	if not player:
		print("ERROR: Player not ready!")
		return null
	var enemies = player.enemies_in_range
	if enemies.size() > 0:
		return enemies[randi() % enemies.size()]

	if not "enemies_in_range" in player:
		print("ERROR: Player missing 'enemies_in_range'!")
		return null
	return null 
