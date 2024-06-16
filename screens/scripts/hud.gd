extends CanvasLayer

@export var equipe: String = "-"
@onready var camera = $MiniMap/SubViewport/Camera2D
@onready var timer = $Timer
@onready var pause_menu = $Team/MarginContainer/PauseMenu
var paused = false
var charge_skill

func _ready():
	charge_skill = 0
	
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


func _on_timer_charge_timeout():
	if charge_skill == 0:
		$SkillCharge/Animation.play("charge_0")
		$SkillCharge/TimerCharge.start(10)
		charge_skill = 1
	elif charge_skill == 1:
		$SkillCharge/Animation.play("charge_1")
		$SkillCharge/TimerCharge.start(10)
		charge_skill = 2
	elif charge_skill == 2:
		$SkillCharge/Animation.play("charge_2")
		$SkillCharge/TimerCharge.start(10)
		charge_skill = 3
	elif charge_skill == 3:
		$SkillCharge/Animation.play("charge_3")
		$SkillCharge/TimerCharge.start(10)
		charge_skill = 4
	elif charge_skill == 4:
		$SkillCharge/Animation.play("charge_complete")
		charge_skill = 0
