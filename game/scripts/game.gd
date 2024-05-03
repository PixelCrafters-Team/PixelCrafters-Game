extends Node2D

var Map = preload("res://wold/scenes/map.tscn").instantiate()
var Hud = preload("res://screens/scenes/hud.tscn").instantiate()
var Character
var character_position 
var num_character


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
	
	
func select_map(scene, num_map): # MAPA: 0 (centro de pesquisa) e 1 (praca central)
	if num_map == 0:
		scene.add_child(Map)
		Map.get_node("CentroDePesquisa").visible = true
		Map.get_node("PracaCentral").visible = false
		character_position = Vector2(113, -25)
	else:
		scene.add_child(Map)
		Map.get_node("CentroDePesquisa").visible = false
		Map.get_node("PracaCentral").visible = true
		character_position = Vector2(1046, -939)
		
		
func sort_team() -> String:
	var rng = RandomNumberGenerator.new()
	var random = rng.randi_range(0, 1)
	if random == 0:
		return "cats"
	else:
		return "dogs"
	

func set_character(team, num):
	num_character = num
	if team == "cats":
		Character = list_characters_cats[num_character].instantiate()
	else:
		Character = list_characters_dogs[num_character].instantiate()
		
		
func create_game(scene):
	select_map(scene, 0)
	scene.add_child(Character)
	Character.global_position = character_position
	add_child(Hud)
	$HUD.build_uhd()
	

func _on_music_game_finished():
	$MusicGame.play()
