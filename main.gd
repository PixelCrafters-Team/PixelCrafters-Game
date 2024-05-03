extends Node2D

var menu_screen = preload("res://screens/scenes/menu_screen.tscn")
var game_scene = preload("res://game/scenes/game.tscn").instantiate()


func _ready():
	add_child(menu_screen.instantiate())
	
	
func _on_music_menu_finished():
	$MusicMenu.play()
