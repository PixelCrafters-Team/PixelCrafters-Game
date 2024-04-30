extends Node2D

var peer = ENetMultiplayerPeer.new()
@export var player_scene : PackedScene
var Character


var list_characters_cats = [ 
		preload("res://characters/scenes/cats/character_bola_de_pelos.tscn"), 
		preload("res://characters/scenes/cats/character_ronronante.tscn"), 
		preload("res://characters/scenes/cats/character_sombra.tscn")
]
var list_characters_dogs = [
		preload("res://characters/scenes/dogs/character_brutus.tscn"),
		preload("res://characters/scenes/dogs/character_estrela.tscn"),
		preload("res://characters/scenes/dogs/character_sargento_canis.tscn")
]

func _ready():
	select_character(sort_team(), 1)

func _on_host_pressed():
	peer.create_server(1027)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(add_player)
	add_player()
	Character.get_node("Camera2D").visible = false

func _on_join_pressed():
	peer.create_client("127.0.0.1", 1027)
	multiplayer.multiplayer_peer = peer
	Character.get_node("Camera2D").visible = false
	
func add_player(id = 1): 
	var player = player_scene.instantiate()
	player.name = str(id)
	call_deferred("add_child", player)

func del_player(id):
	rpc("_del_player",	id)
	
@rpc("any_peer", "call_local")
func _del_player(id):
	get_node(str(id)).queue_free()
	
func exit_game(id):
	multiplayer.peer_disconnected.connect(del_player)
	del_player(id)	
	
		
func sort_team() -> String:
	var rng = RandomNumberGenerator.new()
	var random = rng.randi_range(0, 1)
	if random == 0:
		return "cats"
	else:
		return "dogs"
	
func select_character(team, num_character):
	if team == "cats":
		Character = list_characters_cats[num_character].instantiate()
	else:
		Character = list_characters_dogs[num_character].instantiate()

