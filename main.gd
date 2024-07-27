extends Node2D

var menu_screen = preload("res://screens/scenes/menu_screen.tscn")
var game_scene = preload("res://game/scenes/Game.tscn").instantiate()
var player_name = "Player-" + str(randi() % 100 + 1)
@onready var click_sound = $ClickSound
@onready var music_menu = $MusicMenu


func _ready():
	pass
	
func _on_music_menu_finished():
	music_menu.play()

func create_scene():
	game_scene = preload("res://game/scenes/Game.tscn").instantiate()


func _on_video_stream_player_finished():
	add_child(menu_screen.instantiate())
	music_menu.play()
