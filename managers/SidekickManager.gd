extends Node

var active_sidekicks = {}

func sidekick_upgrade(upgrade):
	if upgrade["level"] > 1:
		var sidekick = active_sidekicks[upgrade["name"]]
		sidekick["node"].level = upgrade["level"]
		sidekick["node"].set_stats()
		
		
	else:
		new_sidekick(upgrade)
		

func new_sidekick(upgrade):
	
	var packed_scene = load(upgrade["path"])
	
	if packed_scene and packed_scene is PackedScene:
		var new_sidekick = packed_scene.instantiate()
		
		
		active_sidekicks[upgrade["name"]] = {
			"name": upgrade["name"],
			"node": new_sidekick
		}

		var world = get_tree().get_first_node_in_group("world")
		
		world.add_child(new_sidekick)
		new_sidekick.global_position = get_initial_position()
	else:
		push_error("Could not load or instantiate sidekick from: " + upgrade["path"])
		return null

		
func get_initial_position() -> Vector2:
	var player = get_tree().get_first_node_in_group("player")
	if player:
		var angle = randf() * TAU  # Random angle in radians
		var offset = Vector2(cos(angle), sin(angle)) * 100
		return player.global_position + offset
	return Vector2.ZERO

		
