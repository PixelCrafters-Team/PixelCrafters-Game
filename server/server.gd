extends Node2D

const SERVER_PORT: int = 5466

var rooms: Dictionary = {}
var players_room: Dictionary = {}

var next_room_id: int = 0
var empty_rooms: Array = []

enum { WAITING, STARTED }

func _ready():
	var peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()
	var error = peer.create_server(SERVER_PORT, 12)
	multiplayer.multiplayer_peer = peer
	
	multiplayer.peer_connected.connect(_on_player_connected)
	multiplayer.peer_disconnected.connect(_on_player_disconnected)
	multiplayer.connected_to_server.connect(_on_connected_ok)
	multiplayer.connection_failed.connect(_on_connected_fail)
	multiplayer.server_disconnected.connect(_on_server_disconnected)
	
func _on_player_connected(id):
	print("_on_player_connected", id)
	
func _on_player_disconnected(id):
	if not players_room.keys().has(id):
		print("not found player")
		return
	print("_on_player_disconnected", id)
	var room_id = players_room[id]
	if not rooms[room_id].players.erase(id) or not players_room.erase(id):
		printerr("key does not exist")

	if rooms[room_id].players.size() == 0:
		print('closing room' + str(room_id))
		
		if not rooms.erase(room_id):
			printerr("error removing room")
		empty_rooms.push_back(room_id)
	else:
		print('notifying other players in the room')
		
	if rooms.size() >= room_id:
		for player_id in rooms[room_id].players:
			rpc_id(player_id, "remove_player", id)

func _on_connected_ok():
	var peer_id = multiplayer.get_unique_id()
	print("_on_connected_ok", peer_id)

func _on_connected_fail():
	print("_on_connected_fail")
	multiplayer.multiplayer_peer = null

func _on_server_disconnected():
	print("_on_server_disconnected")
	multiplayer.multiplayer_peer = null

@rpc("any_peer")
func create_room(user: Dictionary):
	var sender_id: int = multiplayer.get_remote_sender_id()
	var room_id: int 
	
	if empty_rooms.is_empty():
		room_id = next_room_id
		next_room_id+=1 
	else:
		room_id = empty_rooms.pop_back()
		
	rooms[room_id] = {
		creator = sender_id,
		players = {},
		players_done = 0,
		state = WAITING,
	}
	
	_add_player_to_room(room_id, sender_id, user)

func _add_player_to_room(room_id, sender_id, user):
	rooms[room_id].players[sender_id] = user
	players_room[sender_id] = room_id
	rpc_id(sender_id, "update_room", room_id)
	
	for player_id in rooms[room_id].players:
		rpc_id(player_id, "register_player", sender_id, user)
	for other_player_id in rooms[room_id].players:
		if other_player_id != sender_id:
			rpc_id(sender_id, "register_player", other_player_id, rooms[room_id].players[other_player_id])

@rpc("any_peer")
func update_room(room_id):
	pass
	
@rpc("any_peer")
func join_room(room_id, user):
	var sender_id = multiplayer.get_remote_sender_id()
	
	_add_player_to_room(room_id, sender_id, user)

@rpc("any_peer")
func register_player():
	pass

@rpc("any_peer")
func remove_player():
	pass
