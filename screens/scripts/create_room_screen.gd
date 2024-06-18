extends Control

var menu_screen = preload("res://screens/scenes/menu_screen.tscn")
var character_selection_screen  = preload("res://screens/scenes/character_selection_screen.tscn")
var character
static var team = ""
var num_character
func _ready():
	if character:
		$VBoxContainer/Label/StartButton.visible = true
		
	if character == "estrela":
		num_character = 1
		$VBoxContainer/HBoxContainer/PanelCharacterDog/VBoxContainer/HBoxContainer/BoxContainer/EstrelaCharacterDog.visible = true
	elif character == "brutus":
		num_character = 0
		$VBoxContainer/HBoxContainer/PanelCharacterDog/VBoxContainer/HBoxContainer/BoxContainer/BrutusCharacterDog.visible = true
	elif character == "sargento_canis":
		num_character = 2
		$VBoxContainer/HBoxContainer/PanelCharacterDog/VBoxContainer/HBoxContainer/BoxContainer/SargentoCanisCharacterDog.visible = true
	elif character == "sombra":
		num_character = 2
		$VBoxContainer/HBoxContainer/PanelCharacterCat/VBoxContainer/HBoxContainer/SombraCharacterCat.visible = true
	elif character == "ronronante":
		num_character = 0
		$VBoxContainer/HBoxContainer/PanelCharacterCat/VBoxContainer/HBoxContainer/RonronanteCharacterCat.visible = true
	elif character == "bola_de_pelos":
		num_character = 1
		$VBoxContainer/HBoxContainer/PanelCharacterCat/VBoxContainer/HBoxContainer/BolaDePelosCharacterCat.visible = true
	
		
func _process(delta):
	pass
	
func set_room(room):
	$VBoxContainer/LabelTeam.text = room
	
func set_character(character_set):
	character = character_set

func _on_return_button_pressed():
	get_parent().click_sound.play()
	get_parent().add_child(menu_screen.instantiate())
	get_parent().get_node("CreateRoomScreen").queue_free()


func _on_select_dogs_button_pressed():
	team = "dogs"
	get_parent().click_sound.play()
	var screen = character_selection_screen.instantiate();
	screen.set_team_name(team)
	get_parent().add_child(screen)
	get_parent().get_node("CreateRoomScreen").queue_free()

func _on_select_cats_button_pressed():
	team = "cats"
	get_parent().click_sound.play()
	var screen = character_selection_screen.instantiate();
	screen.set_team_name(team)
	get_parent().add_child(screen)
	get_parent().get_node("CreateRoomScreen").queue_free()



func _on_exit_button_pressed():
	get_parent().click_sound.play()
	get_tree().quit()


func _on_start_button_pressed():
	get_parent().click_sound.play()
	var scene = get_parent().game_scene
	scene.set_character(team, num_character)
	scene.create_game(scene)
	get_parent().add_child(scene)
	get_parent().get_node("CreateRoomScreen").queue_free()
	get_parent().get_node("MusicMenu").stream_paused = true
