extends Control

var team = "dogs"
var num_character = 1
var SceneCharacterSlection = preload("res://screens/scenes/character_selection_screen.tscn")

func _ready():
	Networking.list_changed.connect(self.list_changed)
	Networking.connection_reset.connect(self.connection_reset)
	pass


func _on_create_pressed():
	$ChoiceCharacter.visible = true
	Networking.update_name($NameEdit.text)
	Networking.create_server()
	$Create.disabled = true
	$Connect.disabled = true
	var ip = Networking.return_ip()
	$InfoIP.text = "Use este ip para se conectar ao servidor:\n" + ip
	pass


func _on_connect_pressed():
	$ChoiceCharacter.visible = true
	Networking.update_ip($IpEdit.text)
	Networking.update_name($NameEdit.text)
	Networking.join_server()
	$Create.disabled = true
	$Connect.disabled = true
	pass


func _on_start_pressed():
	if multiplayer.is_server():
		rpc("start_game")
	pass


@rpc("any_peer", "call_local")
func start_game():
	get_parent().click_sound.play()
	
	var scene = get_parent().game_scene
	#scene.set_character(team, num_character)
	scene.create_game(scene)
	get_parent().get_node("MusicMenu").stream_paused = true
	get_parent().add_child(scene)
	get_parent().get_node("LAN").queue_free()
	pass


func list_changed():
	var list = Networking.return_list()
	$ListPlayers.clear()
	for i in range(list.size()):
		if list[i][0] == Networking.id:
			$ListPlayers.add_item(list[i][1] + str(" (você)"))
		else:
			$ListPlayers.add_item(list[i][1])
	pass
pass


func connection_reset():
	$ErroPanel.show()
	pass


func _on_erropanel_button_pressed():
	$Criar.disabled = false
	$Conectar.disabled = false
	$ErroPanel.hide()
	pass


func _on_choice_character_pressed():
	get_parent().add_child(SceneCharacterSlection.instantiate())
