extends Control

var manu_screen = preload("res://screens/scenes/menu_screen.tscn")
var create_room_screen = preload("res://screens/scenes/create_room_screen.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_return_button_pressed():
	get_parent().click_sound.play()
	get_parent().add_child(manu_screen.instantiate())
	get_parent().get_node("SearchRoomScreen").queue_free()


func _on_join_room_button_pressed():
	get_parent().click_sound.play()
	get_parent().add_child(create_room_screen.instantiate())
	get_parent().get_node("SearchRoomScreen").queue_free()



func _on_controls_button_down():
		# TODO: get id to find room
	print("selected")


func _on_exit_button_pressed():
	get_parent().click_sound.play()
	get_tree().quit()
