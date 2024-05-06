extends Control

var menu_scene = preload("res://screens/scenes/menu_screen.tscn")

func _ready():
	var sound_player = get_parent().get_node("MusicMenu")
	var value = sound_player.get_volume_db()
	$MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/HSliderMusic.value = value
	
	sound_player = get_parent().get_node("ClickSound")
	value = sound_player.get_volume_db()
	$MarginContainer/VBoxContainer/HBoxContainer2/VBoxContainer2/HSliderSound.value = value
	

func _on_exit_button_pressed():
	get_tree().quit()


func _on_return_button_pressed():
	get_parent().add_child(menu_scene.instantiate())
	get_parent().get_node("SettingsScreen").queue_free()


func _on_h_slider_music_value_changed(value):
	var music_player = get_parent().get_node("MusicMenu")
	if music_player:
		music_player.set_volume_db(float(value))
	else:
		print("Nó AudioStreamPlayer não encontrado!")


func _on_h_slider_sound_value_changed(value):
	var sound_player = get_parent().get_node("ClickSound")
	if sound_player:
		sound_player.set_volume_db(float(value))
	else:
		print("Nó AudioStreamPlayer não encontrado!")

