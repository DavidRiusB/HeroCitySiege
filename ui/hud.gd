extends Control

# ==== GUI ====
@onready var exp_bar = get_node("%ExperienceBar")
@onready var lbl_level = get_node("%lbl_level")
@onready var level_up_panel = get_node("%LevelUp")
@onready var upgrade_options = get_node ("%UpgradeOptions")
@onready var snd_level_up = get_node("%sndLvUp")
@onready var item_option = preload("res://Utility/item_option.tscn")

var stats:Node2D = null

func _ready() -> void:
	var player = get_tree().get_first_node_in_group("player")
	stats = player.get_node("%StatsManager")
	print(stats)
	stats.connect("level_up", Callable(self, "level_up"))
	stats.connect("set_xp_bar", Callable(self, "set_xp_bar"))
	
func set_xp_bar(set_value = 1, set_max_value = 100):
	exp_bar.value = set_value
	exp_bar.max_value = set_max_value
	
func level_up():
	snd_level_up.play()
	lbl_level.text = str("Level:", stats.character_level)
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
	
func upgrade_character(upgrade):
	var options_children = upgrade_options.get_children()
	for i in options_children:
		i.queue_free()
		level_up_panel.visible = false
		level_up_panel.position = Vector2(800, 50)
		get_tree().paused = false
		stats.calculate_experience(0)
