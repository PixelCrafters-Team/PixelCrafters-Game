extends Node2D

var Map = preload("res://wold/scenes/map.tscn").instantiate() 
var Character = preload("res://characters/scenes/cats/character_ronronante.tscn").instantiate()

func _ready():
	Character.global_position = Vector2(98, -24)
	add_child(Map)
	add_child(Character)
	$HUD.build_uhd()
