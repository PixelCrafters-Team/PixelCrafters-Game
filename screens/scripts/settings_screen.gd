extends Control

var menu_scene = preload("res://screens/scenes/menu_screen.tscn")
var developer_scene = preload("res://screens/scenes/developer_information.tscn")
var is_scene_game = false

func set_is_game():
	is_scene_game = true

func _ready():
	var main = get_tree().root.get_node("Main")
	var sound_player = main.get_node("MusicMenu")
	var value = sound_player.get_volume_db()
	$MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/HSliderMusic.value = value
	
	sound_player = main.get_node("ClickSound")
	value = sound_player.get_volume_db()
	$MarginContainer/VBoxContainer/HBoxContainer2/VBoxContainer2/HSliderSound.value = value
	
	var name_player = main.player_name
	$MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/TextPlayer.text = name_player


func _physics_process(delta):
	if Input.is_action_just_pressed("ui_cancel"): 
		if is_scene_game:
			get_parent().get_node("SettingsScreen").queue_free()
		else:
			get_parent().click_sound.play()
			get_parent().add_child(menu_scene.instantiate())
			get_parent().get_node("SettingsScreen").queue_free()
	

func _on_exit_button_pressed():
	var main = get_tree().root.get_node("Main")
	main.click_sound.play()
	get_tree().quit()


func _on_return_button_pressed():
	var main = get_tree().root.get_node("Main")
	if is_scene_game:
		get_parent().get_node("SettingsScreen").queue_free()
	else:
		get_parent().add_child(menu_scene.instantiate())
		get_parent().get_node("SettingsScreen").queue_free()


func _on_h_slider_music_value_changed(value):
	var main = get_tree().root.get_node("Main")
	var music_player = main.get_node("MusicMenu")
	if music_player:
		music_player.set_volume_db(float(value))
		if music_player.get_volume_db() > -80.0:
			var texture_resource = load("res://screens/themes/style_button_music.tres")
			texture_resource.texture = load("res://screens/assets/icons/Icon_SoundOn.png")
		else:
			var texture_resource = load("res://screens/themes/style_button_music.tres")
			texture_resource.texture = load("res://screens/assets/icons/Icon_SoundOff.png")
	else:
		print("Nó AudioStreamPlayer não encontrado!")


func _on_h_slider_sound_value_changed(value):
	var main = get_tree().root.get_node("Main")
	main.click_sound.play()
	var sound_player = main.get_node("ClickSound")
	if sound_player:
		sound_player.set_volume_db(float(value))
		if sound_player.get_volume_db() > -80.0:
			var texture_resource = load("res://screens/themes/style_button_sound.tres")
			texture_resource.texture = load("res://screens/assets/icons/Icon_SoundOn.png")
		else:
			var texture_resource = load("res://screens/themes/style_button_sound.tres")
			texture_resource.texture = load("res://screens/assets/icons/Icon_SoundOff.png")
	else:
		print("Nó AudioStreamPlayer não encontrado!")


func _on_button_music_pressed():
	var main = get_tree().root.get_node("Main")
	main.click_sound.play()
	var music_player = main.get_node("MusicMenu")
	if music_player:
		if music_player.get_volume_db() > -80.0:
			music_player.set_volume_db(-80.0)
			var texture_resource = load("res://screens/themes/style_button_music.tres")
			texture_resource.texture = load("res://screens/assets/icons/Icon_SoundOff.png")
			$MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/HSliderMusic.value = -80.0
		else:
			music_player.set_volume_db(0.0)
			var texture_resource = load("res://screens/themes/style_button_music.tres")
			texture_resource.texture = load("res://screens/assets/icons/Icon_SoundOn.png")
			$MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/HSliderMusic.value = 0.0
	else:
		print("Nó AudioStreamPlayer não encontrado!")


func _on_button_sound_pressed():
	var main = get_tree().root.get_node("Main")
	main.click_sound.play()
	var sound_player = main.get_node("ClickSound")
	if sound_player:
		if sound_player.get_volume_db() > -80.0:
			sound_player.set_volume_db(-80.0)
			var texture_resource = load("res://screens/themes/style_button_sound.tres")
			texture_resource.texture = load("res://screens/assets/icons/Icon_SoundOff.png")
			$MarginContainer/VBoxContainer/HBoxContainer2/VBoxContainer2/HSliderSound.value = -80.0
		else:
			sound_player.set_volume_db(0.0)
			var texture_resource = load("res://screens/themes/style_button_sound.tres")
			texture_resource.texture = load("res://screens/assets/icons/Icon_SoundOn.png")
			$MarginContainer/VBoxContainer/HBoxContainer2/VBoxContainer2/HSliderSound.value = 0.0
	else:
		print("Nó AudioStreamPlayer não encontrado!")


func _on_text_player_text_changed():
	var main = get_tree().root.get_node("Main")
	main.player_name = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/TextPlayer.text


func _on_info_button_pressed():
	var main = get_tree().root.get_node("Main")
	main.click_sound.play()
	get_parent().add_child(developer_scene.instantiate())
