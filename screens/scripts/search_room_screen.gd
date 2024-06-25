extends Control

var peer = ENetMultiplayerPeer.new()
var manu_screen = preload("res://screens/scenes/menu_screen.tscn")
var create_room_screen = preload("res://screens/scenes/create_room_screen.tscn")
var select_character_screen = preload("res://screens/scenes/character_selection_screen.tscn")
var rooms = ["Sala 1", "Sala 2", "Sala 3", "Sala 4", "Sala 5", "Sala 6"]
var selected_room = ""
var teams = ["cats", "dogs"]
var player_id 

# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/Label/JoinRoomButton.disabled = true
	var vbox_inner = $VBoxContainer/HBoxContainer/ScrollContainer/VBoxContainer
	for room in rooms:
		var hbox = HBoxContainer.new()
		hbox.layout_mode = 2
		var button = Button.new()
		button.text = room
		button.custom_minimum_size = Vector2(800, 50)
		button.pressed.connect(func(): self._on_controls_button_down(room))
		button.add_theme_font_size_override("font_size", 28)
		hbox.add_child(button)
		vbox_inner.add_child(hbox)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_return_button_pressed():
	get_parent().click_sound.play()
	get_parent().add_child(manu_screen.instantiate())
	get_parent().get_node("SearchRoomScreen").queue_free()


func _on_join_room_button_pressed():
	peer.create_client("127.0.0.1", 1027)
	multiplayer.multiplayer_peer = peer
	get_parent().click_sound.play()
	var scene = select_character_screen.instantiate()
	scene.set_team_name(teams.pick_random())
	print('a')
	scene.set_player(player_id)
	get_parent().add_child(scene)

func _on_controls_button_down(room):
	$VBoxContainer/Label/JoinRoomButton.disabled = false
	selected_room = room


func _on_exit_button_pressed():
	get_parent().click_sound.play()
	get_tree().quit()


func _on_create_room_pressed():
	peer.create_server(1027)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(add_player)
	add_player()
	get_parent().click_sound.play()
	var scene = select_character_screen.instantiate()
	scene.set_team_name(teams.pick_random())
	scene.set_player(player_id)
	get_parent().add_child(scene)

func add_player(id = 1): 
	print(id)
	player_id = id
	
