extends Node2D
var audio_victory_defeat

func _ready():
	if audio_victory_defeat == 1:
		$AudioVictory.play()
	else:
		$AudioDefeat.play()
		
		
func _on_select_button_continue_pressed():
	var menu_scene = preload("res://screens/scenes/menu_screen.tscn")
	get_parent().add_child(menu_scene.instantiate())
	get_parent().create_scene()
	get_parent().get_node("MusicMenu").play()
	get_parent().get_node("EndGameScreen").queue_free()
	Networking.reset_connection()
	
