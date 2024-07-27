extends Control

var team = null
var num_character = 1
var SceneCharacterSlection = preload("res://screens/scenes/character_selection_screen.tscn")
var is_create_room = false
var empty_room = false
@export var max_dogs_players: int
@export var max_cats_players: int
var frame_texture_cats = [70, 67, 64]
var frame_texture_dogs = [13, 19, 22]


func _ready():
	var main = get_tree().root.get_node("Main")
	var name_player = main.player_name
	$NameEdit.text = name_player

	$CreateRoom/Start.disabled = true
	Networking.list_changed.connect(self.list_changed)
	Networking.connection_reset.connect(self.connection_reset)
	
	pass


func _on_create_pressed():
	get_parent().click_sound.play()
	is_create_room = true
	Networking.update_name($NameEdit.text)
	if Networking.create_server():
		$ChoiceCharacter.visible = true
		$ListPlayers.visible = true
		$CreateRoom/Start.visible = true
		$CreateRoom/Create.visible = false
		$EnterRoom/Connect.disabled = true
		var ip = Networking.return_ip()
		$CreateRoom/InfoIP.visible = true
		$CreateRoom/InfoIP/IP.text = "" + ip
		$EnterRoom/IpEdit.visible = false
		$NameEdit.visible = false
		$CreateRoom/ChoiceMap.visible = false
		$CreateRoom/NumPlayers.visible = false
		$CreateRoom/MatchDuration.visible = false
		$CreateRoom/Label.visible = true
		set_multiplayer_authority(Networking.id_room_creator)
		max_cats_players = $CreateRoom/NumPlayers/NumCats.value
		max_dogs_players = $CreateRoom/NumPlayers/NumDogs.value
	else:
		reset_conection(2)
	pass


func _on_connect_pressed():
	get_parent().click_sound.play()
	$ChoiceCharacter.visible = true
	$ListPlayers.visible = true
	Networking.update_ip($EnterRoom/IpEdit.text)
	Networking.update_name($NameEdit.text)
	Networking.join_server()
	$CreateRoom/Create.disabled = true
	$EnterRoom/Connect.disabled = true
	$EnterRoom/IpEdit.visible = false
	$NameEdit.visible = false
	$EnterRoom/Connect.visible = false
	$EnterRoom/Label.visible = true
	$Wait.start(0.5)

@rpc("any_peer")
func get_num_max_players(new_max_cats_players, new_max_dogs_players):
	max_cats_players = new_max_cats_players
	max_dogs_players = new_max_dogs_players

func _on_start_pressed():
	get_parent().click_sound.play()
	var all_characters_chosen = true
	var list_players = Networking.return_list()
	for i in range(list_players.size()):		
		if list_players[i][2] == null:
			all_characters_chosen = false
			
	if multiplayer.is_server() and all_characters_chosen == true:
		var map = $CreateRoom/ChoiceMap.get_selected_id()
		var time_match = $CreateRoom/MatchDuration.value
		rpc("start_game", map, time_match*60)
	else:
		$Panel/ErroPanel/Label.text = "Todos os jogadores devem escolher seus personagens antes!"
		$Panel.visible = true
	pass


@rpc("authority", "call_local")
func start_game(map, time_match):
	get_parent().click_sound.play()
	var scene = get_parent().game_scene
	scene.create_game(scene, map, time_match)
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
	Networking.reset_connection()
	pass


func _on_erropanel_button_pressed():
	get_parent().click_sound.play()
	$Panel.hide()
	if empty_room:
		reset_conection()
		empty_room = false
	pass


func _on_choice_character_pressed():
	get_parent().click_sound.play()
	get_parent().add_child(SceneCharacterSlection.instantiate())


func _on_name_edit_text_changed(new_text):
	var main = get_tree().root.get_node("Main")
	main.player_name = new_text


@rpc("any_peer")
func reset_conection(error_server = 0):
	get_parent().click_sound.play()
	var menu_scene = preload("res://screens/scenes/menu_screen.tscn")
	get_parent().add_child(menu_scene.instantiate())
	connection_reset()
	get_parent().get_node("LAN").queue_free()
	if(error_server == 1):
		get_parent().get_node("Menu_screen").error_server = 1
	if(error_server == 2):
		get_parent().get_node("Menu_screen").error_server = 2


func _on_return_button_pressed():
	get_parent().click_sound.play()
	if $CreateRoom/Start.visible == true and is_create_room:
		rpc("reset_conection", 1)
		get_parent().click_sound.play()
		Networking.update_id_room_creator(null, true)
		$Timer.start(0.5)
	else:
		reset_conection()
	

func _on_timer_timeout():
	var menu_scene = preload("res://screens/scenes/menu_screen.tscn")	
	get_parent().add_child(menu_scene.instantiate())
	connection_reset()
	get_parent().get_node("LAN").queue_free()


func _on_choice_map_pressed():
	get_parent().click_sound.play()


func _on_choice_map_toggled(toggled_on):
	get_parent().click_sound.play()


func _on_wait_timeout():
	if Networking.get_id_room_creator() == null:
		$Panel/ErroPanel/Label.text = "Código da sala incorreto, não existe nenhum moderador nesta sala"
		$Panel.visible = true
		empty_room = true
	
	if Networking.get_id_room_creator() != null:
		var id = Networking.get_id_room_creator()
		rpc_id(id, "get_num_max_players", max_cats_players, max_dogs_players)
		var list = Networking.return_list()
		if list.size() >= (max_dogs_players + max_cats_players):
			rpc("enable_start_button")
	pass
	$Wait.stop()
	
	
@rpc("any_peer")
func enable_start_button():
	$CreateRoom/Start.disabled = false


func get_max_team_dogs_cats():
	var cont_cats = 0
	var cont_dogs = 0
	
	var players = Networking.return_list()
	for i in range(players.size()):
		if players[i][2] != null:
			if "cats" in players[i][2]:
				cont_cats += 1
			elif "dogs" in players[i][2]:
				cont_dogs += 1
	
	var is_max_team = [false,false]

	if cont_dogs >= max_dogs_players:
		is_max_team[0] = true
	if cont_cats >= max_cats_players:
		is_max_team[1] = true
	return is_max_team

func update_texture_choice_character(team, num):
	print(team)
	print(num)
	if team == "cats":
		$ContainerChoiceCharacter/TextureChoiceCharacter.frame = frame_texture_cats[num]
	elif team == "dogs":
		$ContainerChoiceCharacter/TextureChoiceCharacter.frame = frame_texture_dogs[num]
	$ContainerChoiceCharacter/TextureChoiceCharacter.visible = true
