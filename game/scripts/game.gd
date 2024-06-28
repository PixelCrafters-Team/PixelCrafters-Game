extends Node2D

@onready var teleportSound = $TeleportSound

var Map = preload("res://world/scenes/map.tscn").instantiate()
var Hud = preload("res://screens/scenes/hud.tscn").instantiate()
var SceneCharacter
var Character
var character_position
var num_character
var num_map


var list_characters_cats = [ 
		preload("res://characters/scenes/cats/character_ronronante.tscn"), 
		preload("res://characters/scenes/cats/character_bola_de_pelos.tscn"), 
		preload("res://characters/scenes/cats/character_sombra.tscn")
]
var list_characters_dogs = [
		preload("res://characters/scenes/dogs/character_brutus.tscn"),
		preload("res://characters/scenes/dogs/character_estrela.tscn"),
		preload("res://characters/scenes/dogs/character_sargento_canis.tscn")
]


func _ready():
	pass
	
	
func select_map(scene, map): # MAPA: 0 (centro de pesquisa) e 1 (praca central)
	num_map = map
	if num_map == 0:
		scene.add_child(Map)
		Map.get_node("CentroDePesquisa").visible = true
		Map.get_node("PracaCentral").visible = false
		Hud.get_node("MiniMap/SubViewport/CentroDePesquisa").visible = true
		Hud.get_node("MiniMap/SubViewport/PracaCentral").visible = false
		character_position = Vector2(480, 688)
	else:
		scene.add_child(Map)
		Map.get_node("CentroDePesquisa").visible = false
		Map.get_node("PracaCentral").visible = true
		Hud.get_node("MiniMap/SubViewport/CentroDePesquisa").visible = false
		Hud.get_node("MiniMap/SubViewport/PracaCentral").visible = true
		character_position = Vector2(-720, -568)
	

func set_character(team, num):
	num_character = num
	if team == "cats":
		SceneCharacter = list_characters_cats[num_character]
	else:
		SceneCharacter = list_characters_dogs[num_character]
		
		
func create_game(scene):
	#select_map(scene, [0,1].pick_random())
	select_map(scene, 0)
	
	var lista_jogadores = Networking.retornar_lista()
	for i in range(lista_jogadores.size()):
		Character = SceneCharacter.instantiate()
		scene.add_child(Character)
		Character.global_position = character_position
		Character.name = str(lista_jogadores[i][0])
		Character.set_multiplayer_authority(lista_jogadores[i][0])
		Character.set_nickname(lista_jogadores[i][1])
		add_child(Hud)
		$HUD.build_uhd()
	

func _on_music_game_finished():
	$MusicGame.play()
