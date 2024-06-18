extends Control

var settings_scene = preload("res://screens/scenes/settings_screen.tscn")
var scene_stack = []


func _on_resume_pressed():
	self.hide()
	get_parent().get_node('Team/ColorFade').visible = false


func _on_quit_pressed():
	get_tree().quit()


func _on_controls_pressed():
	print(get_parent())
	get_parent().add_child(settings_scene.instantiate())
	get_parent().get_node("SettingsScreen").set_is_game()
	
