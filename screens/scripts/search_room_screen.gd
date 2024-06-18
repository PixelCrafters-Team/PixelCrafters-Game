extends Control

var manu_screen = preload("res://screens/scenes/menu_screen.tscn")
var create_room_screen = preload("res://screens/scenes/create_room_screen.tscn")
var rooms = ["Sala 1", "Sala 2", "Sala 3", "Sala 4", "Sala 5", "Sala 6"]
var selected_room = ""
# Called when the node enters the scene tree for the first time.
func _ready():
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
	get_parent().click_sound.play()
	var scene = create_room_screen.instantiate()
	scene.set_room(selected_room)
	get_parent().add_child(scene)
	get_parent().get_node("SearchRoomScreen").queue_free()



func _on_controls_button_down(room):
	selected_room = room


func _on_exit_button_pressed():
	get_parent().click_sound.play()
	get_tree().quit()
