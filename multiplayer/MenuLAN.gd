extends Control

var team = "dogs"
var num_character = 1
var SceneCharacterSlection = preload("res://screens/scenes/character_selection_screen.tscn")

func _ready():
	var main = get_tree().root.get_node("Main")
	var name_player = main.player_name
	$NameEdit.text = name_player

	$Start.disabled = true
	Networking.list_changed.connect(self.list_changed)
	Networking.connection_reset.connect(self.connection_reset)
	pass


func _on_create_pressed():
	Networking.update_name($NameEdit.text)
	Networking.create_server()
	$ChoiceCharacter.visible = true
	$ListPlayers.visible = true
	$Start.visible = true
	$Create.disabled = true
	$Connect.disabled = true
	var ip = Networking.return_ip()
	$InfoIP2.visible = true
	$InfoIP.text = "" + ip
	pass


func _on_connect_pressed():
	$ChoiceCharacter.visible = true
	$ListPlayers.visible = true
	Networking.update_ip($IpEdit.text)
	Networking.update_name($NameEdit.text)
	Networking.join_server()
	$Create.disabled = true
	$Connect.disabled = true
	pass


func _on_start_pressed():
	var all_characters_chosen = true
	var list_players = Networking.return_list()
	for i in range(list_players.size()):
		if list_players[i][2] == null:
			all_characters_chosen = false
			
	if multiplayer.is_server() and all_characters_chosen == true:
		rpc("start_game")
	else:
		$Panel/ErroPanel/Label.text = "Todos os jogadores devem escolher seus personagens antes!"
		$Panel.visible = true
	pass


@rpc("authority", "call_local")
func start_game():
	get_parent().click_sound.play()
	var scene = get_parent().game_scene
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
	$Panel.show()
	pass


func _on_erropanel_button_pressed():
	$Panel.hide()
	pass


func _on_choice_character_pressed():
	$Start.disabled = false
	get_parent().add_child(SceneCharacterSlection.instantiate())


func _on_name_edit_text_changed(new_text):
	var main = get_tree().root.get_node("Main")
	main.player_name = new_text
