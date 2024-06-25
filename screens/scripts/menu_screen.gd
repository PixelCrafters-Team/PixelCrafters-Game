extends Control

var character_select_scene = preload("res://screens/scenes/character_selection_screen.tscn")
var settings_scene = preload("res://screens/scenes/settings_screen.tscn")

@onready var create_dialog: AcceptDialog = get_node('CreateDialog') 
@onready var create_dialog_label: Label = create_dialog.get_node('ScrollContainer/Label')
@onready var create_dialog_player_list: VBoxContainer =  create_dialog.get_node('ScrollContainer/PlayerList')


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
	create_dialog_label.text = "Sala " + str(room_id)
