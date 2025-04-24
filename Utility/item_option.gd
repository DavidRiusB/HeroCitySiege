extends ColorRect

var mouse_over = false

# Default fallback item if nothing is passed
const DEFAULT_UPGRADE = {
	"icon": preload("res://assets/items/Upgrades/chunk.png"),
	"display_name": "Small Food",
	"details": "Restores 20 health.",
	"level": 1,
	"prerequisite": [],
	"type": "item"
}

var upgrade: Dictionary = {}  # Always treat it as a Dictionary

@onready var hub = get_tree().get_first_node_in_group("hub")
@onready var icon = $ColorRect/Icon
@onready var lbl_name = $Label_Name
@onready var lbl_description = $Label_Description
@onready var lbl_level = $Label_Level

signal selected_upgrade(upgrade)

func _ready() -> void:
	connect("selected_upgrade", Callable(hub, "upgrade_character"))
	print(upgrade, "On card")
	update_card_info(upgrade)

func _input(event):
	if event.is_action_pressed("click") and mouse_over:
		emit_signal("selected_upgrade", upgrade)

func _on_mouse_entered() -> void:
	mouse_over = true

func _on_mouse_exited() -> void:
	mouse_over = false

func update_card_info(upgrade_data: Dictionary) -> void:
	upgrade = DEFAULT_UPGRADE if upgrade_data.is_empty() else upgrade_data


	# Update visuals
	icon.texture = load(upgrade["icon"]) if typeof(upgrade["icon"]) == TYPE_STRING else upgrade["icon"]
	lbl_name.text = upgrade["display_name"]
	lbl_description.text = upgrade["details"]
	lbl_level.text = "Level %d" % upgrade["level"]
