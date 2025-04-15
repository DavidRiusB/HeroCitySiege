extends Area2D

var level = 1
var hp = 9999
var speed = 200.0
var damage = 10
var knockback_amount = 100
var path = 1
var attack_size = 1.0
var attack_speed = 4.0
var target = Vector2.ZERO
var target_array = []
var angle = Vector2.ZERO
var reset_position = Vector2.ZERO

var spr_javelin_regular = preload("res://assets/items/Weapons/javelin_3_new.png")
var spr_javelin_attack = preload("res://assets/items/Weapons/javelin_3_new_attack.png")

@onready var player = get_tree().get_first_node_in_group("player")
@onready var sprite = $Sprite2D
@onready var collision = $CollisionShape2D
@onready var attack_timer = get_node("%AttackTimer")
@onready var change_direction_timer = get_node("%ChangeDirection")
@onready var reset_position_timer = get_node("%ResetPosTimer")
@onready var snd_attack = $snd_attack

signal remove_from_arr(object)

func _ready() -> void:
	pass
