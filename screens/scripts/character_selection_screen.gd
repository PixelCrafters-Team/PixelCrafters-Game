extends Control

var game_scene = preload("res://game/scenes/game.tscn")
var team

func _ready():
	team = sort_team()
	if  team == "cats": 
		load_screen_cats()
	elif team == "dogs":
		load_screen_dogs()

	
func _on_exit_button_2_pressed():
	get_parent().click_sound.play()
	get_tree().quit()


func _on_select_button_0_pressed():
	get_parent().click_sound.play()
	var scene = get_parent().game_scene
	scene.set_character(team, 0)
	scene.create_game(scene)
	get_parent().add_child(scene)
	get_parent().get_node("CharacterSelectionScreen").queue_free()
	get_parent().get_node("MusicMenu").stream_paused = true
	

func _on_select_button_1_pressed():
	get_parent().click_sound.play()
	var scene = get_parent().game_scene
	scene.set_character(team, 1)
	scene.create_game(scene)
	get_parent().add_child(scene)
	get_parent().get_node("CharacterSelectionScreen").queue_free()
	get_parent().get_node("MusicMenu").stream_paused = true


func _on_select_button_2_pressed():
	get_parent().click_sound.play()
	var scene = get_parent().game_scene
	scene.set_character(team, 2)
	scene.create_game(scene)
	get_parent().add_child(scene)
	get_parent().get_node("CharacterSelectionScreen").queue_free()
	get_parent().get_node("MusicMenu").stream_paused = true
	
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
	$VBoxContainer/HBoxContainer/PanelCharacter1/VBoxContainer/BoxContainer/TextureCharacterCat.visible = false
	$VBoxContainer/HBoxContainer/PanelCharacter1/VBoxContainer/BoxContainer/TextureCharacterDog.visible = true
	$VBoxContainer/HBoxContainer/PanelCharacter2/VBoxContainer/BoxContainer/TextureCharacterCat.visible = false
	$VBoxContainer/HBoxContainer/PanelCharacter2/VBoxContainer/BoxContainer/TextureCharacterDog.visible = true
	$VBoxContainer/HBoxContainer/PanelCharacter3/VBoxContainer/BoxContainer/TextureCharacterCat.visible = false
	$VBoxContainer/HBoxContainer/PanelCharacter3/VBoxContainer/BoxContainer/TextureCharacterDog.visible = true
	$VBoxContainer/HBoxContainer/PanelCharacter1/VBoxContainer/LabelSkill.text = "Resistência Canina"
	$VBoxContainer/HBoxContainer/PanelCharacter2/VBoxContainer/LabelSkill.text = "Patas Saltitantes"
	$VBoxContainer/HBoxContainer/PanelCharacter3/VBoxContainer/LabelSkill.text = "Latido Sônico"

func load_screen_cats():
	$VBoxContainer/LabelTeam.text = "Equipe Gatos Hackers"
	$VBoxContainer/HBoxContainer/PanelCharacter1/VBoxContainer/Title.text = "Ronronante"
	$VBoxContainer/HBoxContainer/PanelCharacter2/VBoxContainer/Title.text = "Bola de Pelos"
	$VBoxContainer/HBoxContainer/PanelCharacter3/VBoxContainer/Title.text = "Sombra"
	$VBoxContainer/HBoxContainer/PanelCharacter1/VBoxContainer/BoxContainer/TextureCharacterCat.visible = true
	$VBoxContainer/HBoxContainer/PanelCharacter1/VBoxContainer/BoxContainer/TextureCharacterDog.visible = false
	$VBoxContainer/HBoxContainer/PanelCharacter2/VBoxContainer/BoxContainer/TextureCharacterCat.visible = true
	$VBoxContainer/HBoxContainer/PanelCharacter2/VBoxContainer/BoxContainer/TextureCharacterDog.visible = false
	$VBoxContainer/HBoxContainer/PanelCharacter3/VBoxContainer/BoxContainer/TextureCharacterCat.visible = true
	$VBoxContainer/HBoxContainer/PanelCharacter3/VBoxContainer/BoxContainer/TextureCharacterDog.visible = false
	$VBoxContainer/HBoxContainer/PanelCharacter1/VBoxContainer/LabelSkill.text = "Ronronar Calmante"
	$VBoxContainer/HBoxContainer/PanelCharacter2/VBoxContainer/LabelSkill.text = "Esconderijo Felino"
	$VBoxContainer/HBoxContainer/PanelCharacter3/VBoxContainer/LabelSkill.text = "Ataque de Pelos"
	

