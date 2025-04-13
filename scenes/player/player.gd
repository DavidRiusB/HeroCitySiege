extends CharacterBody2D

@export var movement_speed = 40.0
@export var healt = 80

@onready var animation_test = preload("res://scenes/animations/AnimatorTest.tscn")

# Attacks
var ice_spear = preload("res://scenes/player/Attack/ice_spear.tscn")

# Attack Nodes 
@onready var ability_timer = get_node("%AbilityTimer")
@onready var attack_timer = get_node("%AttackTimer")

# Ice Spear Attributes
var ice_spear_ammo = 0
var ice_spear_base_ammo = 1
var ice_spear_attack_speed = 1.5
var ice_spear_level = 1

#Enemy Related
var enemy_close = []



var animator: AnimatedSprite2D = null

# Mapping of movement directions to animations and idle states
var animation_states = {
	Vector2.RIGHT: {"walk": "Sideways", "idle": "idle_sideways", "flip_h": false},
	Vector2.LEFT: {"walk": "Sideways", "idle": "idle_sideways", "flip_h": true},
	Vector2.UP: {"walk": "Up", "idle": "idle_back", "flip_h": false},
	Vector2.DOWN: {"walk": "Down", "idle": "idle_front", "flip_h": false}
}

var last_direction = Vector2.DOWN  # Default to facing down

func _ready():
	animator = animation_test.instantiate()
	add_child(animator)
	attack()

func _physics_process(delta: float) -> void:
	movement()

func movement():
	var input_vector = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	).normalized()

	if input_vector != Vector2.ZERO:
		velocity = input_vector * movement_speed
		update_animation(input_vector)
		last_direction = input_vector
	else:
		velocity = Vector2.ZERO
		play_idle_animation()

	move_and_slide()

func update_animation(direction: Vector2):
	for dir in animation_states.keys():
		if direction.dot(dir) > 0.5:
			var state = animation_states[dir]
			animator.flip_h = state["flip_h"]
			animator.play(state["walk"])
			break

func play_idle_animation():
	for dir in animation_states.keys():
		if last_direction.dot(dir) > 0.5:
			var state = animation_states[dir]
			animator.flip_h = state["flip_h"]
			animator.play(state["idle"])
			break


func _on_hurt_box_hurt(damage: Variant, _angle, _knockback):
	healt -= damage
	print(healt)
	
func attack():
	if ice_spear_level > 0:
		ability_timer.wait_time = ice_spear_attack_speed
		if ability_timer.is_stopped():
			ability_timer.start()


func _on_ability_timer_timeout() -> void:
	ice_spear_ammo += ice_spear_base_ammo
	attack_timer.start()


func _on_attack_timer_timeout() -> void:
	if ice_spear_ammo > 0:
		var ice_spear_attack = ice_spear.instantiate()
		ice_spear_attack.position = position
		ice_spear_attack.target = get_random_target()
		ice_spear_attack.level = ice_spear_level
		add_child(ice_spear_attack)
		ice_spear_ammo -= 1
		if ice_spear_ammo > 0:
			attack_timer.start()
		else:
			attack_timer.stop()
		
		
func get_random_target():
	if enemy_close.size() > 0:
		return enemy_close.pick_random().global_position
	else:
		return Vector2.UP


func _on_enemy_detection_area_body_entered(body: Node2D) -> void:
	if not enemy_close.has(body):
		enemy_close.append(body)


func _on_enemy_detection_area_body_exited(body: Node2D) -> void:
	if enemy_close.has(body):
		enemy_close.erase(body)
