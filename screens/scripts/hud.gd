extends CanvasLayer

@export var equipe: String = "-"
@onready var camera = $MiniMap/SubViewport/Camera2D
@onready var timer = $Timer

func _process(delta):
	$Timer/LabelTimer.text = str(int(timer.time_left / 60)) + ":" + str(int(timer.time_left) % 60)

func _physics_process(delta):
	camera.position = get_parent().Character.position

func build_uhd():
	if get_parent().Character.is_in_group("cats"):
		equipe = "Gatos Hackers"
	elif get_parent().Character.is_in_group("dogs"):
		equipe = "Cachorros Vigilantes"	
	$Team/MarginContainer/VBoxContainer/HBoxContainer/NameTeam.text = equipe
	timer.start()
	

func _on_button_pressed():
	get_tree().quit()


func _on_timer_timeout():
	timer.stop()
