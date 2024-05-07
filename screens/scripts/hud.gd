extends CanvasLayer

@export var equipe: String = "-"
@onready var camera = $MiniMap/SubViewport/Camera2D
@onready var timer = $Timer
@onready var pause_menu = $PauseMenu
var paused = false

func _process(delta):
	$Timer/LabelTimer.text = str(int(timer.time_left / 60)) + ":" + str(int(timer.time_left) % 60)
	if Input.is_action_just_pressed("pause"):
		pauseMenu()
		
func _physics_process(delta):
	if get_parent().Character:
		camera.position = get_parent().Character.position

func build_uhd():
	if get_parent().Character.is_in_group("cats"):
		equipe = "Gatos Hackers"
	elif get_parent().Character.is_in_group("dogs"):
		equipe = "Cachorros Vigilantes"	
	$Team/MarginContainer/VBoxContainer/HBoxContainer/NameTeam.text = equipe
	

func _on_button_pressed():
	#get_tree().quit()
	pauseMenu()


func _on_timer_timeout():
	timer.stop()
	
func pauseMenu():
	if paused:
		pause_menu.hide()
	else:
		pause_menu.show()
	paused = !paused
