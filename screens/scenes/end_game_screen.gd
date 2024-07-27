extends Node2D

var MenuScreen = preload("res://screens/scenes/menu_screen.tscn").instantiate()
var audio_victory_defeat

func _ready():
	if audio_victory_defeat == 1:
		$AudioVictory.play()
	else:
		$AudioDefeat.play()
		
		
func _on_select_button_continue_pressed():
	get_parent().add_child(MenuScreen)
	get_parent().get_node("EndGameScreen").queue_free()
