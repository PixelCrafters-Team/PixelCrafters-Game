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

func create_room() -> void:
	is_creator = true
	connect_to_server()

func connect_to_server(room_id: int = 1) -> void:
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
	print("_on_connected_ok", peer_id)

func _on_connected_fail():
	print("_on_connected_fail")
	multiplayer.multiplayer_peer = null

func _on_server_disconnected():
	print("_on_server_disconnected")
	multiplayer.multiplayer_peer = null
	
@rpc("any_peer")
func update_room(room_id):
	if get_tree().current_scene.name == 'Menu_screen':
		get_tree().current_scene.update_room(room_id)

