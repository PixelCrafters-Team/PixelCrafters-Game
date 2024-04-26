extends Control

var clickSoundPlayer
var soundSource = ""

func _ready():
	clickSoundPlayer = %clickSound
	
func _on_quit_buton_pressed():
	soundSource = "quit"
	clickSoundPlayer.play()

func _on_start_button_pressed():
	soundSource = "start"
	clickSoundPlayer.play()

func _on_click_sound_finished():
	if soundSource == "start": 
		get_tree().change_scene_to_file("res://teste.tscn") 
	elif soundSource == "quit":
		get_tree().quit()
	soundSource = ""
