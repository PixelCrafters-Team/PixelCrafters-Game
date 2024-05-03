extends Control

var game_scene = preload("res://game/scenes/game.tscn")


func _on_exit_button_2_pressed():
	get_tree().quit()


func _on_select_button_0_pressed():
	var scene = get_parent().game_scene
	scene.set_character("cats", 0)
	scene.create_game(scene)
	get_parent().add_child(scene)
	get_parent().get_node("CharacterSelectionScreen").queue_free()
	get_parent().get_node("MusicMenu").stream_paused = true
	

func _on_select_button_1_pressed():
	var scene = game_scene.instantiate()  
	scene.set_character("cats", 1)
	scene.create_game(scene)
	get_parent().add_child(scene)
	get_parent().get_node("CharacterSelectionScreen").queue_free()


func _on_select_button_2_pressed():
	var scene = game_scene.instantiate()  
	scene.set_character("cats", 2)
	scene.create_game(scene)
	get_parent().add_child(scene)
	get_parent().get_node("CharacterSelectionScreen").queue_free()
