extends Node2D

var developmen_attacks = [	
	preload("res://scenes/player/Attack/IceSpear/ice_spear.tscn"),
	preload("res://scenes/player/Attack/Tornado/tornado.tscn")
	]

var hero_attacks  #hardcoded for now planing to pass is as argumumetns later 
var active_attacks = []


func  _ready() -> void:
	hero_attacks = developmen_attacks
	
	for attack_scene in hero_attacks:
		var attack_instance = attack_scene.instantiate()
		active_attacks.append( attack_instance)		
		add_child(attack_instance)
		
		print("Attacks:", active_attacks)
		
func _process(delta: float) -> void: #if im understanding this logic this updates evry frame the attacks ?
	for attack in active_attacks:
		attack.update(delta)
