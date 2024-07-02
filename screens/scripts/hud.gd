extends CanvasLayer

var endGameScreen = preload("res://screens/scenes/end_game_screen.tscn").instantiate()
@export var equipe: String = "-"
@onready var camera = $MiniMap/SubViewport/Camera2D
@onready var timer = $Timer
@onready var pause_menu = $PauseMenu
var paused = false
var charge_skill

func _ready():
	charge_skill = 0
	$SkillCharge/Animation.play("charge_complete")
	$Team/MarginContainer/VBoxContainer/GamMessages.text = " "
	
	if get_parent().has_node("Character_estrela"):
		$SkillCharge/SkillEstrela.visible = true
		$SkillCharge/SkillSargentoCanis.visible = false
		$SkillCharge/SkillBrutus.visible = false
		$SkillCharge/SkillSombra.visible = false
		$SkillCharge/SkillBolaDePelos.visible = false
		$SkillCharge/SkillRonronante.visible = false
	if get_parent().has_node("Character_sargentocanis"):
		$SkillCharge/SkillSargentoCanis.visible = true
		$SkillCharge/SkillEstrela.visible = false
		$SkillCharge/SkillBrutus.visible = false
		$SkillCharge/SkillSombra.visible = false
		$SkillCharge/SkillBolaDePelos.visible = false
		$SkillCharge/SkillRonronante.visible = false
	if get_parent().has_node("Character_brutus"):
		$SkillCharge/SkillBrutus.visible = true
		$SkillCharge/SkillSargentoCanis.visible = false
		$SkillCharge/SkillEstrela.visible = false
		$SkillCharge/SkillSombra.visible = false
		$SkillCharge/SkillBolaDePelos.visible = false
		$SkillCharge/SkillRonronante.visible = false
	if get_parent().has_node("Character_sombra"):
		$SkillCharge/SkillSombra.visible = true
		$SkillCharge/SkillSargentoCanis.visible = false
		$SkillCharge/SkillEstrela.visible = false
		$SkillCharge/SkillBrutus.visible = false
		$SkillCharge/SkillBolaDePelos.visible = false
		$SkillCharge/SkillRonronante.visible = false
	if get_parent().has_node("Character_boladepelos"):
		$SkillCharge/SkillBolaDePelos.visible = true
		$SkillCharge/SkillSargentoCanis.visible = false
		$SkillCharge/SkillEstrela.visible = false
		$SkillCharge/SkillBrutus.visible = false
		$SkillCharge/SkillSombra.visible = false
		$SkillCharge/SkillRonronante.visible = false
	if get_parent().has_node("Character_ronronante"):
		$SkillCharge/SkillRonronante.visible = true
		$SkillCharge/SkillSargentoCanis.visible = false
		$SkillCharge/SkillEstrela.visible = false
		$SkillCharge/SkillBrutus.visible = false
		$SkillCharge/SkillSombra.visible = false
		$SkillCharge/SkillBolaDePelos.visible = false
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
	print(get_name())
	get_parent().get_parent().add_child(endGameScreen)
	get_parent().get_parent().get_node("Game").queue_free()
	
	
func pauseMenu():
	if paused:
		pause_menu.hide()
		$Team/ColorFade.visible = false
	else:
		pause_menu.show()
		$Team/ColorFade.visible = true
	paused = !paused


func _on_timer_charge_timeout():
	if charge_skill == 1:
		$SkillCharge/Animation.play("charge_1")
		$SkillCharge/TimerCharge.stop()
		$SkillCharge/TimerCharge.start(5)
		charge_skill = 2
	elif charge_skill == 2:
		$SkillCharge/Animation.play("charge_2")
		$SkillCharge/TimerCharge.stop()
		$SkillCharge/TimerCharge.start(5)
		charge_skill = 3
	elif charge_skill == 3:
		$SkillCharge/Animation.play("charge_3")
		$SkillCharge/TimerCharge.stop()
		$SkillCharge/TimerCharge.start(5)
		charge_skill = 4
	elif charge_skill == 4:
		$SkillCharge/Animation.play("charge_complete")
		$SkillCharge/TimerCharge.stop()
		charge_skill = 0
		$SkillCharge/TimerCharge/EffectCharge.play()
	
		
func start_timer():
	$SkillCharge/Animation.play("charge_0")
	$SkillCharge/TimerCharge.start(5)
	charge_skill = 1
	$SkillCharge/TimerCharge/EffectCharge.play()
	
	
func message_game(text):
	if !get_parent().get_node('Character_estrela'):
		$Team/MarginContainer/VBoxContainer/GamMessages/EffectNotificationMessage.play()
	$Team/MarginContainer/VBoxContainer/GamMessages.text = text
	$Team/MarginContainer/VBoxContainer/GamMessages/TimerMessage.start(2)
	

func _on_timer_message_timeout():
	$Team/MarginContainer/VBoxContainer/GamMessages.text = " "
