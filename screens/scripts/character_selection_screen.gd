extends Control

var game_scene = preload("res://game/scenes/game.tscn")
var team

func _ready():
	$VBoxContainer/HBoxContainer/PanelCharacter1/PanelMoreInformation0.visible = false
	$VBoxContainer/HBoxContainer/PanelCharacter2/PanelMoreInformation1.visible = false
	$VBoxContainer/HBoxContainer/PanelCharacter3/PanelMoreInformation2.visible = false
	
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

