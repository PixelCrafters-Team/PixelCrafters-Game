extends Control

var click_sound_player
var sound_source = ""


func _ready():
	click_sound_player = %ClickSound
	$AnimationDog/AnimationRoute.play("animationDog")
	$AnimationDog/AnimationRoute/AnimationWalk.play("walkDog")
	$AnimationCat/AnimationRoute.play("animationCat")
	$AnimationCat/AnimationRoute/AnimationWalk.play("walk")
	
func _on_quit_buton_pressed():
	sound_source = "quit"
	click_sound_player.play()


func _on_start_button_pressed():
	sound_source = "start"
	click_sound_player.play()


func _on_click_sound_finished():
	if sound_source == "start": 
		get_tree().change_scene_to_file("res://game/scenes/game.tscn") 
	elif sound_source == "quit":
		get_tree().quit()
	sound_source = ""
