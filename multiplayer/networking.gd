extends Node

const IPPADRAO = "127.0.0.1"
const PORTA = 6007
const MAXJOGADORES = 5

var ip = IPPADRAO
var id = 0
var nome_jogador = ""
var par = null
var jogadores = []

signal lista_alterada
signal conexao_resetada

func _ready():
	multiplayer.connected_to_server.connect(self.conectado_ao_servidor)
	multiplayer.connection_failed.connect(self.falha_na_conexao)
	multiplayer.server_disconnected.connect(self.queda_do_servidor)
	pass

func conectado_ao_servidor():
	id = multiplayer.multiplayer_peer.get_unique_id()
	rpc("registrar_jogador", id, nome_jogador)
	pass

func par_desconectado(id):
	rpc("remover_jogador", id)
	pass

func falha_na_conexao():
	resetar_conexao()
	pass

func queda_do_servidor():
	if not get_tree().current_scene.name == "LAN":
		get_tree().change_scene_to_file("res://MenuLAN.tscn")
	resetar_conexao()
	pass

func resetar_conexao():
	par = null
	multiplayer.set_multiplayer_peer(null)
	jogadores.clear()
	emit_signal("conexao_resetada")
	pass

@rpc("any_peer")
func registrar_jogador(id, nome):
	if multiplayer.is_server():
		for i in range(jogadores.size()):
			rpc_id(id, "registrar_jogador", jogadores[i][0], jogadores[i][1])
		rpc("registrar_jogador", id, nome)
	jogadores.append([id, nome])
	emit_signal("lista_alterada")
	pass

@rpc("any_peer", "call_local")
func remover_jogador(id):
	print(jogadores)
	for i in range(jogadores.size()):
		if jogadores[i][0] == id:
			jogadores.remove_at(i)
			emit_signal("lista_alterada")
			return
	pass

func criar_servidor():
	par = ENetMultiplayerPeer.new()
	par.create_server(PORTA, MAXJOGADORES)
	var ip = retornar_ip()
	if ip.begins_with("192"):
		multiplayer.set_multiplayer_peer(par)
		par.peer_disconnected.connect(self.par_desconectado)
		id = multiplayer.multiplayer_peer.get_unique_id()
		registrar_jogador(id, nome_jogador)
	else:
		resetar_conexao()
	pass

func entrar_servidor():
	par = ENetMultiplayerPeer.new()
	par.create_client(ip, PORTA)
	multiplayer.set_multiplayer_peer(par)
	pass

func atualizar_ip(novo_ip):
	ip = novo_ip
	pass

func atualizar_nome(novo_nome):
	nome_jogador = novo_nome
	pass

func retornar_lista():
	return jogadores
	pass

func retornar_ip():
	var lista_ip = IP.get_local_addresses()
	for i in range(lista_ip.size()):
		if lista_ip[i].begins_with("192"):
			return lista_ip[i]
	return IPPADRAO
	pass
