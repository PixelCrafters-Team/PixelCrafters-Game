extends Control

@onready var hud = $"res://screens/scripts/hud.gd"

func _on_resume_pressed():
	self.hide()


func _on_quit_pressed():
	get_tree().quit()


func _on_controls_pressed():
	pass # Replace with function body.
