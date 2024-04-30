extends Control

var sound_source = ""
var game_scene = preload("res://game/scenes/game.tscn")

func _ready():
	$AnimationDog/AnimationRoute.play("animationDog")
	$AnimationDog/AnimationRoute/AnimationWalk.play("walkDog")
	$AnimationCat/AnimationRoute.play("animationCat")
	$AnimationCat/AnimationRoute/AnimationWalk.play("walk")
	
	
func _on_quit_buton_pressed():
	sound_source = "quit"
	%ClickSound.play()
	$MusicMenu.stream_paused = true


func _on_start_button_pressed():
	sound_source = "start"
	%ClickSound.play()
	$MusicMenu.stream_paused = true


func _on_click_sound_finished():
	if sound_source == "start": 
		get_tree().change_scene_to_packed(game_scene)
	elif sound_source == "quit":
		get_tree().quit()
	sound_source = ""


func _on_music_menu_finished():
	$MusicMenu.play()
