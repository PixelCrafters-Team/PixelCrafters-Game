extends Control

var team = "dogs"
var num_character = 1

func _ready():
	Networking.lista_alterada.connect(self.lista_alterada)
	Networking.conexao_resetada.connect(self.conexao_resetada)
	pass

func _on_criar_pressed():
	Networking.atualizar_nome($NomeEdit.text)
	Networking.criar_servidor()
	$Criar.disabled = true
	$Conectar.disabled = true
	var ip = Networking.retornar_ip()
	$InfoIP.text = "Use este ip para se conectar ao servidor:\n" + ip
	pass

func _on_conectar_pressed():
	Networking.atualizar_ip($IpEdit.text)
	Networking.atualizar_nome($NomeEdit.text)
	Networking.entrar_servidor()
	$Criar.disabled = true
	$Conectar.disabled = true
	pass

func _on_comecar_pressed():
	if multiplayer.is_server():
		rpc("comecar_jogo")
	pass

@rpc("any_peer", "call_local")
func comecar_jogo():
	get_parent().click_sound.play()
	var scene = get_parent().game_scene
	scene.set_character(team, num_character)
	scene.create_game(scene)
	get_parent().get_node("MusicMenu").stream_paused = true
	get_parent().add_child(scene)
	get_parent().get_node("LAN").queue_free()
	pass

func lista_alterada():
	var lista = Networking.retornar_lista()
	$ListaJogadores.clear()
	for i in range(lista.size()):
		if lista[i][0] == Networking.id:
			$ListaJogadores.add_item(lista[i][1] + str(" (você)"))
		else:
			$ListaJogadores.add_item(lista[i][1])
	pass
pass

func conexao_resetada():
	$ErroPanel.show()
	pass

func _on_erropanel_button_pressed():
	$Criar.disabled = false
	$Conectar.disabled = false
	$ErroPanel.hide()
	pass
