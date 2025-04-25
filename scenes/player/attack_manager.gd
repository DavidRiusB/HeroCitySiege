extends Node2D

var active_attacks = []

func  _ready() -> void:
	var attack_data = GameManager.selected_hero.HERO
	var attack_scene = load(attack_data.attack_scene_path)
	var hero_attack = attack_scene.instantiate()
	add_child(hero_attack)
	active_attacks.append(hero_attack)
	print("Active attacks:", active_attacks)
	
		
func _process(delta: float) -> void: #if im understanding this logic this updates evry frame the attacks ?
	for attack in active_attacks:
		attack.update(delta)
