extends CharacterBody2D

# ==== Stats ====
var movement_speed: float

# ==== Enemy Tracking ====
var enemies_in_range = []

# ==== Animation ====
var animator: AnimatedSprite2D = null
var last_direction = Vector2.DOWN  # optional: init with DOWN so idle anim is set

var hero_attacks = null




var animation_states = {
	Vector2.RIGHT: {"walk": "Sideways", "idle": "idle_sideways", "flip_h": false},
	Vector2.LEFT: {"walk": "Sideways", "idle": "idle_sideways", "flip_h": true},
	Vector2.UP: {"walk": "Up", "idle": "idle_back", "flip_h": false},
	Vector2.DOWN: {"walk": "Down", "idle": "idle_front", "flip_h": false}
}

func _ready():
	var stats = self.get_node("%StatsManager")
	movement_speed = stats.movement_speed
	
	var hero_data = GameManager.selected_hero.HERO  # Access the HERO constant
	var animator_scene = load(hero_data.animator_path)  # Load scene from string path
	animator = animator_scene.instantiate()	
	add_child(animator)
	print("Animator path:", hero_data.animator_path)
	print("Loaded animator scene:", animator_scene)	


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
	if animator == null:
		print("NO ANIMATOR ON UPDATE ANIMATOR")
		return  # or print a warning

	for dir in animation_states.keys():
		if direction.dot(dir) > 0.5:
			var state = animation_states[dir]
			animator.flip_h = state["flip_h"]
			animator.play(state["walk"])
			break

func play_idle_animation():
	if animator == null:
		print("NO ANIMATOR ON play idle animation")
		return  # or print a warning
		
	for dir in animation_states.keys():
		if last_direction.dot(dir) > 0.5:
			var state = animation_states[dir]
			animator.flip_h = state["flip_h"]
			animator.play(state["idle"])
			break



func _on_enemy_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy") and not enemies_in_range.has(body):
		enemies_in_range.append(body)	


func _on_enemy_detection_area_body_exited(body: Node2D) -> void:
	if enemies_in_range.has(body):
		enemies_in_range.erase(body)
		
