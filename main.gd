extends Node2D

var menu_screen = preload("res://screens/scenes/menu_screen.tscn")
var game_scene = preload("res://game/scenes/game.tscn").instantiate()
@onready var click_sound = $ClickSound
@onready var music_menu = $MusicMenu


func _ready():
	add_child(menu_screen.instantiate())
	
	
func _on_music_menu_finished():
	music_menu.play()
