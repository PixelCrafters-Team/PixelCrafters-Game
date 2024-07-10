extends Control

var character_select_scene = preload("res://screens/scenes/character_selection_screen.tscn")
var settings_scene = preload("res://screens/scenes/settings_screen.tscn")
var room_scene = preload("res://multiplayer/MenuLAN.tscn")

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
	get_parent().get_node("LAN/EnterRoom/IpEdit").visible = false
	get_parent().get_node("LAN/EnterRoom/Connect").visible = false
	get_parent().get_node("LAN/CreateRoom/Create").visible = true
	get_parent().get_node("LAN/CreateRoom/InfoIP").visible = false
	get_parent().get_node("LAN/LabelTitle").text = "CRIAR EM UMA SALA"
	get_parent().get_node("Menu_screen").queue_free()
