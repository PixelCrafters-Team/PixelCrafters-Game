extends Node

const IPSTANDARD = "127.0.0.1"
const PORT = 6007
const MAXPLAYERS = 6

var ip = IPSTANDARD
var id = 0
var name_player = ""
var pair = null
var players = []

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
	resetar_conexao()
	pass

func server_crash():
	if not get_tree().current_scene.name == "LAN":
		get_tree().change_scene_to_file("res://MenuLAN.tscn")
	resetar_conexao()
	pass

func resetar_conexao():
	pair = null
	multiplayer.set_multiplayer_peer(null)
	players.clear()
	emit_signal("connection_reset")
	pass

@rpc("any_peer")
func register_player(id, name):
	if multiplayer.is_server():
		for i in range(players.size()):
			rpc_id(id, "register_player", players[i][0], players[i][1])
		rpc("register_player", id, name)
	players.append([id, name])
	emit_signal("list_changed")
	pass

@rpc("any_peer", "call_local")
func remove_player(id):
	print(players)
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
	else:
		resetar_conexao()
	pass

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
