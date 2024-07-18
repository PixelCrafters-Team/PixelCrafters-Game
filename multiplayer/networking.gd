extends Node

const IPSTANDARD = "127.0.0.1"
const PORT = 6007
const MAXPLAYERS = 6

var ip = IPSTANDARD
var id = 0
var name_player = ""
var pair = null
var players = []
var id_room_creator = null

signal list_changed
signal connection_reset



func _ready():
	multiplayer.connected_to_server.connect(self.connected_server)
	multiplayer.connection_failed.connect(self.connection_fail)
	multiplayer.server_disconnected.connect(self.server_crash)
	pass


func connected_server():
	id = multiplayer.multiplayer_peer.get_unique_id()
	rpc("register_player", id, name_player)
	pass


func pair_disconnected(id):
	rpc("remove_player", id)
	pass


func connection_fail():
	reset_connection()
	pass


func server_crash():
	if not get_tree().current_scene.name == "LAN":
		var main = get_tree().root.get_node("Main")
		main.get_node("Game").queue_free()
		var menu_scene = preload("res://screens/scenes/menu_screen.tscn")
		main.add_child(menu_scene.instantiate())
		main.get_node("Menu_screen").error_server = 1
		main.create_scene()
	id_room_creator = null
	update_id_room_creator(id_room_creator)
	reset_connection()
	pass


func reset_connection():
	pair = null
	multiplayer.set_multiplayer_peer(null)
	players.clear()
	#emit_signal("connection_reset")
	pass


@rpc("any_peer")
func register_player(id, name, character=null, room_creator=id_room_creator):
	if multiplayer.is_server():
		for i in range(players.size()):
			rpc_id(id, "register_player", players[i][0], players[i][1],  players[i][2], id_room_creator)
		rpc("register_player", id, name, character)
	players.append([id, name, character])
	emit_signal("list_changed")
	update_id_room_creator(room_creator)
	pass


@rpc("any_peer", "call_local")
func remove_player(id):
	for i in range(players.size()):
		if players[i][0] == id:
			players.remove_at(i)
			emit_signal("list_changed")
			return
	pass


func create_server():
	pair = ENetMultiplayerPeer.new()
	pair.create_server(PORT, MAXPLAYERS)
	var ip = return_ip()
	if ip.begins_with("192"):
		multiplayer.set_multiplayer_peer(pair)
		pair.peer_disconnected.connect(self.pair_disconnected)
		id = multiplayer.multiplayer_peer.get_unique_id()
		register_player(id, name_player)
		id_room_creator = get_player_id()
	else:
		print("erro ao criar o servidor")
		return false
	return true


func join_server():
	pair = ENetMultiplayerPeer.new()
	pair.create_client(ip, PORT)
	multiplayer.set_multiplayer_peer(pair)
	pass


func update_ip(new_ip):
	ip = new_ip
	pass


func update_name(new_name):
	name_player = new_name
	pass


func return_list():
	return players
	pass


func return_ip():
	var list_ip = IP.get_local_addresses()
	for i in range(list_ip.size()):
		if list_ip[i].begins_with("192"):
			return list_ip[i]
	return IPSTANDARD
	pass
	
	
@rpc("any_peer")
func update_list_character(i, character):
	players[i][2] = character; 
	emit_signal("list_changed")
	pass


func get_player_id():
	return id
	pass
	
	
func get_id_room_creator():
	return id_room_creator
	pass
	
	
@rpc()
func update_id_room_creator(new_room_creator, update_players=false):
	id_room_creator = new_room_creator	
	if update_players == true:
		rpc('update_id_room_creator', new_room_creator)

