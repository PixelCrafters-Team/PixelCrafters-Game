extends Control

var character_select_scene = preload("res://screens/scenes/character_selection_screen.tscn")
var settings_scene = preload("res://screens/scenes/settings_screen.tscn")
var room_scene = preload("res://multiplayer/MenuLAN.tscn")
var error_server = 0
@onready var video_player = $VideoStreamPlayer

func _ready():
	$AnimationDog/AnimationRoute.play("animationDog")
	$AnimationDog/AnimationRoute/AnimationWalk.play("walkDog")
	$AnimationCat/AnimationRoute.play("animationCat")
	$AnimationCat/AnimationRoute/AnimationWalk.play("walk")
	$AnimationBone.play("bone_animation")
	
func _physics_process(delta):
	if Input.is_action_just_pressed("ui_cancel"): 
		get_parent().click_sound.play()
		get_parent().add_child(settings_scene.instantiate())
		get_parent().get_node("Menu_screen").queue_free()
	if Input.is_action_just_pressed("ui_accept"):
		get_parent().click_sound.play()
		get_parent().add_child(character_select_scene.instantiate())
		get_parent().get_node("Menu_screen").queue_free()
	
	if error_server == 1:
		error_server = 0
		$Panel/ErroPanel/Label.text = "Erro o servidor se desconectou da sala"
		$Panel.visible = true
	
	if error_server == 2:
		error_server = 0
		$Panel/ErroPanel/Label.text = "Erro não foi possível criar a sala"
		$Panel.visible = true
	
	if error_server == 3:
		error_server = 0
		$Panel/ErroPanel/Label.text = "Erro a sala está cheia!"
		$Panel.visible = true

		
func _on_quit_buton_pressed():
	get_parent().click_sound.play()
	get_tree().quit()
	

func _on_start_button_pressed():
	get_parent().click_sound.play()
	get_parent().add_child(room_scene.instantiate())
	get_parent().get_node("Menu_screen").queue_free()
	
	
	
func _on_music_menu_finished():
	get_parent().music_menu.play()


func _on_exit_button_pressed():
	get_parent().click_sound.play()
	get_tree().quit()


func _on_setting_button_pressed():
	get_parent().click_sound.play()
	get_parent().add_child(settings_scene.instantiate())
	get_parent().get_node("Menu_screen").queue_free()


func _on_create_room_pressed():
	get_parent().click_sound.play()
	get_parent().add_child(room_scene.instantiate())
	get_parent().get_node("LAN/NameEdit").visible = true
	get_parent().get_node("LAN/CreateRoom/Create").visible = true
	get_parent().get_node("LAN/CreateRoom/ChoiceMap").visible = true
	get_parent().get_node("LAN/CreateRoom/NumPlayers").visible = true
	get_parent().get_node("LAN/CreateRoom/MatchDuration").visible = true
	get_parent().get_node("LAN/EnterRoom/IpEdit").visible = false
	get_parent().get_node("LAN/EnterRoom/Connect").visible = false
	get_parent().get_node("LAN/CreateRoom/InfoIP").visible = false
	get_parent().get_node("LAN/LabelTitle").text = "CRIAR EM UMA SALA"
	get_parent().get_node("Menu_screen").queue_free()


func _on_button_pressed():
	get_parent().click_sound.play()
	$Panel.visible = false


func _on_how_to_play_button_pressed():
	$VideoStreamPlayer/CloseButton.visible = true
	video_player.visible = true
	if not video_player.is_playing():
		get_parent().music_menu.stop()
		video_player.play()


func _on_close_button_pressed():
	video_player.visible = false
	video_player.stop()
	get_parent().music_menu.play()
