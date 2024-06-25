extends Control

var character_select_scene = preload("res://screens/scenes/character_selection_screen.tscn")
var settings_scene = preload("res://screens/scenes/settings_screen.tscn")

@onready var create_dialog: AcceptDialog = get_node('CreateDialog') 
@onready var create_dialog_label: Label = create_dialog.get_node('ScrollContainer/VBoxContainer/Label')
@onready var create_dialog_player_list: VBoxContainer =  create_dialog.get_node('ScrollContainer/VBoxContainer/PlayerList')

@onready var join_dialog: Window = get_node('JoinWindow') 
@onready var join_dialog_label: Label = join_dialog.get_node('WaitScrollContainer/VBoxContainer/Label')
@onready var join_dialog_player_list: VBoxContainer =  join_dialog.get_node('WaitScrollContainer/VBoxContainer/PlayerList')


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

		
func _on_quit_buton_pressed():
	get_parent().click_sound.play()
	get_tree().quit()
	

func _on_start_button_pressed():
	get_parent().click_sound.play()
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


func _on_create_button_pressed():
	get_parent().click_sound.play()
	get_parent().get_node("Menu_screen").queue_free()


func _on_create_room_button_pressed():
	print("Create room button pressed")
	Client.create_room()
	create_dialog.popup_centered()

func update_room(room_id):
	print("room_id", room_id)
	if Client.is_creator:
		create_dialog_label.text = "Sala " + str(room_id)
	else:
		join_dialog_label.text = "Sala " + str(room_id)
		join_dialog.connected_ok()


func _on_create_dialog_canceled():
	if multiplayer.multiplayer_peer != null:
		Client.stop()


func _on_start_button_2_pressed():
	join_dialog.popup_centered()

func add_player_to_ui(name):
	if Client.is_creator:
		create_dialog_player_list.add_player(name)
	else:
		join_dialog_player_list.add_player(name)
		
func remove_player(index):
	if Client.is_creator:
		create_dialog_player_list.remove_player(index)
	else:
		join_dialog_player_list.remove_player(index)

func remove_all_players():
	if Client.is_creator:
		create_dialog_player_list.remove_all()
		create_dialog.hide()
	else:
		join_dialog_player_list.remove_all()
		join_dialog.hide()
