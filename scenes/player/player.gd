extends CharacterBody2D

# ==== Stats ====
@export var movement_speed = 40.0
@export var health = 80
var experience = 0
var character_level = 1
var collected_experience = 0

# ==== Scenes ====
@onready var animator_scene = preload("res://scenes/animations/AnimatorTest.tscn")

# ==== Enemy Tracking ====
var enemies_in_range = []

# ==== Animation ====
var animator: AnimatedSprite2D = null
var last_direction = Vector2.DOWN  # optional: init with DOWN so idle anim is set

# ==== GUI ====
@onready var exp_bar = get_node("%ExperienceBar")
@onready var lbl_level = get_node("%lbl_level")
@onready var level_up_panel = get_node("%LevelUp")
@onready var upgrade_options = get_node ("%UpgradeOptions")
@onready var snd_level_up = get_node("%sndLvUp")
@onready var item_option = preload("res://Utility/item_option.tscn")


var animation_states = {
	Vector2.RIGHT: {"walk": "Sideways", "idle": "idle_sideways", "flip_h": false},
	Vector2.LEFT: {"walk": "Sideways", "idle": "idle_sideways", "flip_h": true},
	Vector2.UP: {"walk": "Up", "idle": "idle_back", "flip_h": false},
	Vector2.DOWN: {"walk": "Down", "idle": "idle_front", "flip_h": false}
}

func _ready():
	animator = animator_scene.instantiate()
	add_child(animator)
	set_xp_bar(experience, calculate_experience_cap())


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
	health -= damage
	print(health)
	
func _on_enemy_detection_area_body_entered(body: Node2D) -> void:
	if not enemies_in_range.has(body):
		enemies_in_range.append(body)


func _on_enemy_detection_area_body_exited(body: Node2D) -> void:
	if enemies_in_range.has(body):
		enemies_in_range.erase(body)


func _on_grab_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("loot"):
		area.target = self


func _on_collect_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("loot"):
		var gem_experience = area.collect()
		calculate_experience(gem_experience)
		
func calculate_experience(gem_experience):
	var experience_required = calculate_experience_cap()
	collected_experience += gem_experience
	if experience + collected_experience >= experience_required: #Lv up
		collected_experience -= experience_required - experience
		character_level += 1
		
		experience = 0
		experience_required = calculate_experience_cap()
		level_up()
		
	else:
		experience += collected_experience
		collected_experience = 0
		
	set_xp_bar(experience, experience_required)
		
	
func calculate_experience_cap():
	var exp_cap = character_level
	
	if character_level < 20:
		exp_cap = character_level * 5
	elif  character_level < 40:
		exp_cap = character_level* (character_level - 19) * 8
	else:
		exp_cap = 255 + (character_level - 39) * 12
		
	return exp_cap

	
func set_xp_bar(set_value = 1, set_max_value = 100):
	exp_bar.value = set_value
	exp_bar.max_value = set_max_value
	
func level_up():
	snd_level_up.play()
	lbl_level.text = str("Level:", character_level)
	var tween = level_up_panel.create_tween()
	tween.tween_property(level_up_panel, "position", Vector2(220, 50), 0.2).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN)
	tween.play()
	level_up_panel.visible = true	
	var options = 0
	var options_max = 3
	while options < options_max:
		var option_choice = item_option.instantiate()
		upgrade_options.add_child(option_choice)
		options += 1
		
	get_tree().paused = true
	
func upgrade_charatcer(upgrade):
	var options_children = upgrade_options.get_children()
	for i in options_children:
		i.queue_free()
		level_up_panel.visible = false
		level_up_panel.position = Vector2(800, 50)
		get_tree().paused = false
		calculate_experience(0)
		
	
