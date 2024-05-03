extends Control

var sound_source = ""
var character_select_scene = preload("res://screens/scenes/character_selection_screen.tscn")

func _ready():
	$AnimationDog/AnimationRoute.play("animationDog")
	$AnimationDog/AnimationRoute/AnimationWalk.play("walkDog")
	$AnimationCat/AnimationRoute.play("animationCat")
	$AnimationCat/AnimationRoute/AnimationWalk.play("walk")
	
	
func _on_quit_buton_pressed():
	sound_source = "quit"
	%ClickSound.play()


func _on_start_button_pressed():
	sound_source = "start"
	%ClickSound.play()


func _on_click_sound_finished():
	if sound_source == "start": 
		get_parent().add_child(character_select_scene.instantiate())
		get_parent().get_node("Menu_screen").queue_free()
		
	elif sound_source == "quit":
		get_tree().quit()
		
	sound_source = ""
