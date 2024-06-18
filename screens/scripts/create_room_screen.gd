extends Control

var menu_screen = preload("res://screens/scenes/menu_screen.tscn")
var character_selection_screen  = preload("res://screens/scenes/character_selection_screen.tscn")
var character
static var team = ""
static var room_name = ""
var num_character
var hbox
var parent_vbox

func create_player_character(name: String, position: Vector2, frame: int, hframes: int = 12, vframes: int = 8):
	var main = get_tree().root.get_node("Main")
	# Create HBoxContainer

	# Create Sprite2D for the character
	var character_sprite = Sprite2D.new()
	character_sprite.name = name
	character_sprite.visible = true
	character_sprite.position = position
	character_sprite.scale = Vector2(0.5, 0.5)
	var texture_path = "res://characters/assets/cats_dogs.png"
	var texture = load(texture_path)
	if texture:
		character_sprite.texture = texture
	else:
		print("Failed to load texture at path: ", texture_path)
	character_sprite.hframes = hframes
	character_sprite.vframes = vframes
	character_sprite.frame = frame

	# Create Label for the character name
	var label = Label.new()
	label.text = main.player_name
	label.custom_minimum_size = Vector2(0, 50)
	label.offset_left = -72.0
	label.offset_top = -128.0
	label.offset_right = 70.0
	label.offset_bottom = -68.0
	label.add_theme_font_size_override("font_size", 40)

	character_sprite.add_child(label)

	# Add the character sprite to the HBoxContainer
	hbox.add_child(character_sprite)

	# Get the parent VBoxContainer and add the HBoxContainer to it

	if parent_vbox:
		parent_vbox.add_child(hbox)
	else:
		print("Failed to find the parent VBoxContainer")

	
func _ready():
	hbox = $VBoxContainer/HBoxContainer/PanelCharacterCat/VBoxContainer/HBoxContainer if team == 'cats' else $VBoxContainer/HBoxContainer/PanelCharacterDog/VBoxContainer/HBoxContainer
	parent_vbox = $VBoxContainer/HBoxContainer/PanelCharacterCat/VBoxContainer if team == 'cats' else $VBoxContainer/HBoxContainer/PanelCharacterDog/VBoxContainer
	$VBoxContainer/LabelTeam.text = room_name
	
	if character:
		$VBoxContainer/Label/StartButton.visible = true
		
	if character == "estrela":
		num_character = 1
		create_player_character(
			"EstrelaDog",
		 	Vector2(220, 55),
			31
		)
	elif character == "brutus":
		num_character = 0
		create_player_character(
			"BrutusDog",
			Vector2(62, 50),
			25
		)
	elif character == "sargento_canis":
		num_character = 2
		create_player_character(
			"SargentoCanisDog",
			Vector2(-153, 45),
			34
		)
	elif character == "sombra":
		num_character = 2
		create_player_character(
			"SombraCat",
			Vector2(1, 45),
			76
		)
	elif character == "ronronante":
		num_character = 0
		create_player_character(
			"RonronanteCat",
			Vector2(-153, 45),
			82
		)
	elif character == "bola_de_pelos":
		num_character = 1
		create_player_character(
			"BolaDePelotasCat",
			Vector2(153, 45),
			79
		)
		
func _process(delta):
	pass
	
func set_room(room):
	room_name = room
	
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
