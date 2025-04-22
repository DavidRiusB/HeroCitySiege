extends ColorRect

var mouse_over = false

var item = {
	"icon": preload("res://assets/items/Upgrades/chunk.png"),
	"display_name": "Small Food",
	"details": "Restores 20 health.",
	"level": 1,  # changed to integer, better for number logic
	"prerequisite": [],
	"type": "item"
} # Testing only

@onready var hub = get_tree().get_first_node_in_group("hub")
@onready var icon = $ColorRect/Icon
@onready var lbl_name = $Label_Name
@onready var lbl_description = $Label_Description
@onready var lbl_level = $Label_Level

signal selected_upgrade(upgrade)

func _ready() -> void:
	connect("selected_upgrade", Callable(hub, "upgrade_character"))
	update_card_info(item)  

func _input(event):
	if event.is_action_pressed("click"):  
		if mouse_over:
			emit_signal("selected_upgrade", item)
			
func _on_mouse_entered() -> void:
	mouse_over = true

func _on_mouse_exited() -> void:
	mouse_over = false

func update_card_info(upgrade_data: Dictionary) -> void:
	item = upgrade_data
	icon.texture = upgrade_data["icon"]
	lbl_name.text = upgrade_data["display_name"]
	lbl_description.text = upgrade_data["details"]
	lbl_level.text = "Level %d" % upgrade_data["level"]
