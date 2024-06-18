extends Node2D

var MenuScreen = preload("res://screens/scenes/menu_screen.tscn").instantiate()


func _on_select_button_continue_pressed():
	get_parent().add_child(MenuScreen)
	get_parent().get_node("EndGameScreen").queue_free()
