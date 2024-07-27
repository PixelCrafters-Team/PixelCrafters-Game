extends Node2D

@onready var teleportSound = $TeleportSound

var Map = preload("res://world/scenes/map.tscn").instantiate()
var Hud = preload("res://screens/scenes/hud.tscn").instantiate()
var Character
var character_position_cats
var character_position_dogs
var num_character
var num_map
var num_total_cats = 0
var num_glace_cats = 0
var num_total_glace_cats = 0


var list_characters_cats = [ 
		"res://characters/scenes/cats/character_ronronante.tscn", 
		"res://characters/scenes/cats/character_bola_de_pelos.tscn", 
		"res://characters/scenes/cats/character_sombra.tscn"
]
var list_characters_dogs = [
		"res://characters/scenes/dogs/character_brutus.tscn",
		"res://characters/scenes/dogs/character_estrela.tscn",
		"res://characters/scenes/dogs/character_sargento_canis.tscn"
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
		character_position_cats = Vector2(480, 688)
		character_position_dogs = Vector2(-579, 121)
	else:
		scene.add_child(Map)
		Map.get_node("CentroDePesquisa").visible = false
		Map.get_node("PracaCentral").visible = true
		Hud.get_node("MiniMap/SubViewport/CentroDePesquisa").visible = false
		Hud.get_node("MiniMap/SubViewport/PracaCentral").visible = true
		character_position_cats = Vector2(-720, -568)
		character_position_dogs = Vector2(271, -1053)
	

func set_character(team, num):
	num_character = num
	var id = Networking.get_player_id()
	var list_players = Networking.return_list()
	for i in range(list_players.size()):
		if id == list_players[i][0]:
			if team == "cats":
				list_players[i][2] = list_characters_cats[num_character]
			else:
				list_players[i][2] = list_characters_dogs[num_character]
			Networking.rpc("update_list_character", i, list_players[i][2])
		
		
func create_game(scene, map, time_match):
	#select_map(scene, [0,1].pick_random())
	select_map(scene, map)
	var list_players = Networking.return_list()
	for i in range(list_players.size()):
		Character = load(list_players[i][2]).instantiate();
		scene.add_child(Character)
		if Character.is_in_group("cats") == true:
			Character.global_position = character_position_cats
			num_total_cats += 1
		else: 
			Character.global_position = character_position_dogs
			
		Character.name = str(list_players[i][1])
		Character.set_multiplayer_authority(list_players[i][0])
		Character.set_nickname(list_players[i][1])
		
	add_child(Hud)
	$HUD.build_uhd(num_total_cats)
	$HUD/Timer.set_wait_time(float(time_match))

func _on_music_game_finished():
	$MusicGame.play()
