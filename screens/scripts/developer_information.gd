extends Control

var settings_screen = preload("res://screens/scenes/settings_screen.tscn")

func _on_back_button_pressed():
	get_parent().get_node("DeveloperInformation").queue_free()
