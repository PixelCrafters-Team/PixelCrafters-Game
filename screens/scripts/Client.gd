extends Node

const SERVER_ADDRESS: String = "127.0.0.1"
const SERVER_PORT: int = 5466

var user: Dictionary = {
	name = "Gabriela",
	character_index = 0,
	instance = null,
}

var player_info: Dictionary = {}

var is_creator: bool = false

var room: int

@rpc("any_peer")
func create_room() -> void:
	is_creator = true
	connect_to_server()
	
func stop() -> void: 
	multiplayer.multiplayer_peer = null
	remove_all_players()

func connect_to_server(room_id: int = 0) -> void:
	room = room_id
	
	var peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()
	
	var error = peer.create_client(SERVER_ADDRESS, SERVER_PORT)
	
	multiplayer.multiplayer_peer = peer
	
	multiplayer.peer_connected.connect(_on_player_connected)
	multiplayer.peer_disconnected.connect(_on_player_disconnected)
	multiplayer.connected_to_server.connect(_on_connected_ok)
	multiplayer.connection_failed.connect(_on_connected_fail)
	multiplayer.server_disconnected.connect(_on_server_disconnected)
	
func _on_player_connected(id):
	print("_on_player_connected", id)
	
func _on_player_disconnected(id):
	print("_on_player_disconnected", id)

func _on_connected_ok():
	var peer_id = multiplayer.get_unique_id()
	if (is_creator):
		rpc_id(1, "create_room", user)
	else: 
		rpc_id(1, "join_room", room, user)
	print("_on_connected_ok", peer_id)

@rpc("any_peer")
func register_player(id, info):
	player_info[id] = info
	var menu = get_tree().current_scene.get_node('Menu_screen')
	menu.add_player_to_ui(info.name)
	
@rpc("any_peer")
func remove_player(id):
	var menu = get_tree().current_scene.get_node('Menu_screen')
	menu.remove_player(player_info.keys().find(id))
	
	if not player_info.erase(id):
		printerr("error removing player")
	
func remove_all_players():
	var menu = get_tree().current_scene.get_node('Menu_screen')
	menu.remove_all_players()
	player_info = {}
	
func _on_connected_fail():
	print("_on_connected_fail")
	multiplayer.multiplayer_peer = null

func _on_server_disconnected():
	print("_on_server_disconnected")
	multiplayer.multiplayer_peer = null
	
@rpc("any_peer")
func update_room(room_id):
	var menu = get_tree().current_scene.get_node('Menu_screen')
	if menu.name == 'Menu_screen':
		menu.update_room(room_id)
		
@rpc("any_peer")
func join_room():
	pass

