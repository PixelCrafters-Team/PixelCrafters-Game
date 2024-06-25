extends Control

var team
var game_scene = preload("res://game/scenes/Game.tscn")
var create_room_scene = preload("res://screens/scenes/create_room_screen.tscn")
var player_id
var selected_panel = -1
var texture_resource_panel = [
		load("res://screens/themes/style_background_choose_character_1.tres"),
		load("res://screens/themes/style_background_choose_character_2.tres"),
		load("res://screens/themes/style_background_choose_character_3.tres")
]
var texture_img_panel = [
		load("res://screens/assets/background_choose_character.png"),
		load("res://screens/assets/background_choose_selected_character.png")
]


func _ready():
	$VBoxContainer/HBoxContainer/PanelCharacter1/PanelMoreInformation0.visible = false
	$VBoxContainer/HBoxContainer/PanelCharacter2/PanelMoreInformation1.visible = false
	$VBoxContainer/HBoxContainer/PanelCharacter3/PanelMoreInformation2.visible = false
	
	if  team == "cats": 
		load_screen_cats()
	elif team == "dogs":
		load_screen_dogs()
		
func set_team_name(team_value):
	team = team_value

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_right"):
		if selected_panel == -1:
			selected_panel = 3
		if selected_panel == 1:
			texture_resource_panel[0].texture = texture_img_panel[0]
			texture_resource_panel[1].texture = texture_img_panel[1]
			texture_resource_panel[2].texture = texture_img_panel[0]
			selected_panel += 1
		elif selected_panel == 2:
			texture_resource_panel[0].texture = texture_img_panel[0]
			texture_resource_panel[1].texture = texture_img_panel[0]
			texture_resource_panel[2].texture = texture_img_panel[1]
			selected_panel += 1
		else:
			texture_resource_panel[0].texture = texture_img_panel[1]
			texture_resource_panel[1].texture = texture_img_panel[0]
			texture_resource_panel[2].texture = texture_img_panel[0]
			selected_panel = 1
			
	if Input.is_action_just_pressed("ui_left"):
		if selected_panel == -1:
			selected_panel = 2
		if selected_panel == 1:
			texture_resource_panel[0].texture = texture_img_panel[0]
			texture_resource_panel[1].texture = texture_img_panel[0]
			texture_resource_panel[2].texture = texture_img_panel[1]
			selected_panel = 3
		elif selected_panel == 2:
			texture_resource_panel[0].texture = texture_img_panel[1]
			texture_resource_panel[1].texture = texture_img_panel[0]
			texture_resource_panel[2].texture = texture_img_panel[0]
			selected_panel -= 1
		else:
			texture_resource_panel[0].texture = texture_img_panel[0]
			texture_resource_panel[1].texture = texture_img_panel[1]
			texture_resource_panel[2].texture = texture_img_panel[0]
			selected_panel -= 1
			
	if Input.is_action_just_pressed("ui_accept"):
		get_parent().click_sound.play()
		var scene = get_parent().game_scene
		if selected_panel == 1:
			scene.set_character(team, 0)
		elif selected_panel == 2:
			scene.set_character(team, 1)
		else:
			scene.set_character(team, 2)
		#scene.create_game(scene)
		#get_parent().add_child(scene)
		get_parent().get_node("CharacterSelectionScreen").queue_free()
		get_parent().get_node("MusicMenu").stream_paused = true
		

func _on_exit_button_2_pressed():
	get_parent().click_sound.play()
	get_tree().quit()

func set_player(player):
	player_id = player
	
func _on_select_button_0_pressed():
	get_parent().click_sound.play()
	var scene = create_room_scene.instantiate()
	var character = "ronronante" if team == "cats" else "brutus"
	scene.set_character(character, team, player_id)
	get_parent().add_child(scene)
	#get_parent().click_sound.play()
	#var scene = get_parent().game_scene
	#scene.set_character(team, 0)
	#scene.create_game(scene)
	#get_parent().add_child(scene)
	get_parent().get_node("CharacterSelectionScreen").queue_free()
	#get_parent().get_node("MusicMenu").stream_paused = true
	

func _on_select_button_1_pressed():
	get_parent().click_sound.play()
	var scene = create_room_scene.instantiate()
	var character = "bola_de_pelos" if team == "cats" else "estrela"
	scene.set_character(character, team, player_id)
	get_parent().add_child(scene)
	#get_parent().click_sound.play()
	#var scene = get_parent().game_scene
	#scene.set_character(team, 1)
	#scene.create_game(scene)
	#get_parent().add_child(scene)
	get_parent().get_node("CharacterSelectionScreen").queue_free()
	#get_parent().get_node("MusicMenu").stream_paused = true


func _on_select_button_2_pressed():
	get_parent().click_sound.play()
	var scene = create_room_scene.instantiate()
	var character = "sombra" if team == "cats" else "sargento_canis"
	scene.set_character(character, team, player_id)
	get_parent().add_child(scene)
	#get_parent().click_sound.play()
	#var scene = get_parent().game_scene
	#scene.set_character(team, 2)
	#scene.create_game(scene)
	#get_parent().add_child(scene)
	get_parent().get_node("CharacterSelectionScreen").queue_free()
	#get_parent().get_node("MusicMenu").stream_paused = true
	
	
func sort_team() -> String:
	var rng = RandomNumberGenerator.new()
	var random = rng.randi_range(0, 1)
	if random == 0:
		return "cats"
	else:
		return "dogs"


func load_screen_dogs():
	$VBoxContainer/LabelTeam.text = "Equipe Cachorros Vigilantes"
	$VBoxContainer/HBoxContainer/PanelCharacter1/VBoxContainer/Title.text = "Brutus"
	$VBoxContainer/HBoxContainer/PanelCharacter2/VBoxContainer/Title.text = "Estrela"
	$VBoxContainer/HBoxContainer/PanelCharacter3/VBoxContainer/Title.text = "Sargento Canis"
	$VBoxContainer/HBoxContainer/PanelCharacter1/VBoxContainer/HBoxContainer/BoxContainer/TextureCharacterCat.visible = false
	$VBoxContainer/HBoxContainer/PanelCharacter1/VBoxContainer/HBoxContainer/BoxContainer/TextureCharacterDog.visible = true
	$VBoxContainer/HBoxContainer/PanelCharacter2/VBoxContainer/HBoxContainer/BoxContainer/TextureCharacterCat.visible = false
	$VBoxContainer/HBoxContainer/PanelCharacter2/VBoxContainer/HBoxContainer/BoxContainer/TextureCharacterDog.visible = true
	$VBoxContainer/HBoxContainer/PanelCharacter3/VBoxContainer/HBoxContainer/BoxContainer/TextureCharacterCat.visible = false
	$VBoxContainer/HBoxContainer/PanelCharacter3/VBoxContainer/HBoxContainer/BoxContainer/TextureCharacterDog.visible = true
	$VBoxContainer/HBoxContainer/PanelCharacter1/VBoxContainer/LabelSkill.text = "Resistência Canina"
	$VBoxContainer/HBoxContainer/PanelCharacter2/VBoxContainer/LabelSkill.text = "Patas Saltitantes"
	$VBoxContainer/HBoxContainer/PanelCharacter3/VBoxContainer/LabelSkill.text = "Latido Sônico"
	$VBoxContainer/HBoxContainer/PanelCharacter1/PanelMoreInformation0/VBoxContainer/LabelMoreInformation0.text = "RESISTENTE A DISTRAÇÕES, SENDO MENOS AFETADO PELAS HABILIDADES DE DISTRAÇÃO DOS GATINHOS"
	$VBoxContainer/HBoxContainer/PanelCharacter2/PanelMoreInformation1/VBoxContainer/LabelMoreInformation1.text = "PODE CORRER EM ALTA VELOCIDADE, ENCURTANDO A DISTÂNCIA ENTRE ELA E OS GATINHOS RAPIDAMENTE"
	$VBoxContainer/HBoxContainer/PanelCharacter3/PanelMoreInformation2/VBoxContainer/LabelMoreInformation2.text = "SEU LATIDO PODEROSO PODE DESORIENTAR TEMPORARIAMENTE OS GATINHOS, TIRANDO A CAPACIDADE DE USAR HABILIDADES"


func load_screen_cats():
	$VBoxContainer/LabelTeam.text = "Equipe Gatos Hackers"
	$VBoxContainer/HBoxContainer/PanelCharacter1/VBoxContainer/Title.text = "Ronronante"
	$VBoxContainer/HBoxContainer/PanelCharacter2/VBoxContainer/Title.text = "Bola de Pelos"
	$VBoxContainer/HBoxContainer/PanelCharacter3/VBoxContainer/Title.text = "Sombra"
	$VBoxContainer/HBoxContainer/PanelCharacter1/VBoxContainer/HBoxContainer/BoxContainer/TextureCharacterCat.visible = true
	$VBoxContainer/HBoxContainer/PanelCharacter1/VBoxContainer/HBoxContainer/BoxContainer/TextureCharacterDog.visible = false
	$VBoxContainer/HBoxContainer/PanelCharacter2/VBoxContainer/HBoxContainer/BoxContainer/TextureCharacterCat.visible = true
	$VBoxContainer/HBoxContainer/PanelCharacter2/VBoxContainer/HBoxContainer/BoxContainer/TextureCharacterDog.visible = false
	$VBoxContainer/HBoxContainer/PanelCharacter3/VBoxContainer/HBoxContainer/BoxContainer/TextureCharacterCat.visible = true
	$VBoxContainer/HBoxContainer/PanelCharacter3/VBoxContainer/HBoxContainer/BoxContainer/TextureCharacterDog.visible = false
	$VBoxContainer/HBoxContainer/PanelCharacter1/VBoxContainer/LabelSkill.text = "Ronronar Calmante"
	$VBoxContainer/HBoxContainer/PanelCharacter2/VBoxContainer/LabelSkill.text = "Esconderijo Felino"
	$VBoxContainer/HBoxContainer/PanelCharacter3/VBoxContainer/LabelSkill.text = "Ataque de Pelos"
	$VBoxContainer/HBoxContainer/PanelCharacter1/PanelMoreInformation0/VBoxContainer/LabelMoreInformation0.text = "EMITE UM RONRONAR CALMANTE QUE REDUZ TEMPORARIAMENTE A VELOCIDADE DOS CACHORROS AO SEU REDOR"
	$VBoxContainer/HBoxContainer/PanelCharacter2/PanelMoreInformation1/VBoxContainer/LabelMoreInformation1.text = "LIBERA UMA NUVEM DE PÊLOS FOFOS, OBSTRUINDO A VISÃO DOS CACHORROS"
	$VBoxContainer/HBoxContainer/PanelCharacter3/PanelMoreInformation2/VBoxContainer/LabelMoreInformation2.text = "PODE SE ESCONDER EM LOCAIS ESTRATÉGICOS, TORNANDO-SE TEMPORARIAMENTE INVISÍVEL PARA OS CACHORROS"


func _on_button_more_information_0_pressed():
	$VBoxContainer/HBoxContainer/PanelCharacter1/PanelMoreInformation0.visible = true


func _on_back_button_0_pressed():
	$VBoxContainer/HBoxContainer/PanelCharacter1/PanelMoreInformation0.visible = false


func _on_button_more_information_1_pressed():
	$VBoxContainer/HBoxContainer/PanelCharacter2/PanelMoreInformation1.visible = true


func _on_back_button_1_pressed():
	$VBoxContainer/HBoxContainer/PanelCharacter2/PanelMoreInformation1.visible = false


func _on_button_more_information_2_pressed():
	$VBoxContainer/HBoxContainer/PanelCharacter3/PanelMoreInformation2.visible = true


func _on_back_button_2_pressed():
	$VBoxContainer/HBoxContainer/PanelCharacter3/PanelMoreInformation2.visible = false


func _on_panel_character_1_mouse_entered():
	texture_resource_panel[0].texture = texture_img_panel[1]
	texture_resource_panel[1].texture = texture_img_panel[0]
	texture_resource_panel[2].texture = texture_img_panel[0]
	selected_panel = 1


func _on_panel_character_2_mouse_entered():
	texture_resource_panel[0].texture = texture_img_panel[0]
	texture_resource_panel[1].texture = texture_img_panel[1]
	texture_resource_panel[2].texture = texture_img_panel[0]
	selected_panel = 2


func _on_panel_character_3_mouse_entered():
	texture_resource_panel[0].texture = texture_img_panel[0]
	texture_resource_panel[1].texture = texture_img_panel[0]
	texture_resource_panel[2].texture = texture_img_panel[1]
	selected_panel = 3


func _on_return_button_pressed():
	get_parent().click_sound.play()
	get_parent().add_child(create_room_scene.instantiate())
	get_parent().get_node("CharacterSelectionScreen").queue_free()
