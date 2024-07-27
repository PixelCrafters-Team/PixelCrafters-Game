extends CanvasLayer

@export var equipe: String = "-"
@onready var camera = $MiniMap/SubViewport/Camera2D
@onready var timer = $Timer
@onready var pause_menu = $PauseMenu
var paused = false
var charge_skill
var endGameScreen
var first_charge

func _ready():
	$SkillCharge/Animation.play("charge_0")
	$SkillCharge/TimerCharge.start(5)
	charge_skill = 1
	first_charge = true
	$Team/MarginContainer/VBoxContainer/GamMessages.text = " "
	
	if get_parent().get_node(get_parent().get_parent().player_name).is_in_group("estrela"):
		$SkillCharge/SkillEstrela.visible = true
		$SkillCharge/SkillSargentoCanis.visible = false
		$SkillCharge/SkillBrutus.visible = false
		$SkillCharge/SkillSombra.visible = false
		$SkillCharge/SkillBolaDePelos.visible = false
		$SkillCharge/SkillRonronante.visible = false
	if get_parent().get_node(get_parent().get_parent().player_name).is_in_group("sargentocanis"):
		$SkillCharge/SkillSargentoCanis.visible = true
		$SkillCharge/SkillEstrela.visible = false
		$SkillCharge/SkillBrutus.visible = false
		$SkillCharge/SkillSombra.visible = false
		$SkillCharge/SkillBolaDePelos.visible = false
		$SkillCharge/SkillRonronante.visible = false
	if get_parent().get_node(get_parent().get_parent().player_name).is_in_group("brutus"):
		$SkillCharge/SkillBrutus.visible = true
		$SkillCharge/SkillSargentoCanis.visible = false
		$SkillCharge/SkillEstrela.visible = false
		$SkillCharge/SkillSombra.visible = false
		$SkillCharge/SkillBolaDePelos.visible = false
		$SkillCharge/SkillRonronante.visible = false
	if get_parent().get_node(get_parent().get_parent().player_name).is_in_group("sombra"):
		$SkillCharge/SkillSombra.visible = true
		$SkillCharge/SkillSargentoCanis.visible = false
		$SkillCharge/SkillEstrela.visible = false
		$SkillCharge/SkillBrutus.visible = false
		$SkillCharge/SkillBolaDePelos.visible = false
		$SkillCharge/SkillRonronante.visible = false
	if get_parent().get_node(get_parent().get_parent().player_name).is_in_group("boladepelos"):
		$SkillCharge/SkillBolaDePelos.visible = true
		$SkillCharge/SkillSargentoCanis.visible = false
		$SkillCharge/SkillEstrela.visible = false
		$SkillCharge/SkillBrutus.visible = false
		$SkillCharge/SkillSombra.visible = false
		$SkillCharge/SkillRonronante.visible = false
	if get_parent().get_node(get_parent().get_parent().player_name).is_in_group("ronronante"):
		$SkillCharge/SkillRonronante.visible = true
		$SkillCharge/SkillSargentoCanis.visible = false
		$SkillCharge/SkillEstrela.visible = false
		$SkillCharge/SkillBrutus.visible = false
		$SkillCharge/SkillSombra.visible = false
		$SkillCharge/SkillBolaDePelos.visible = false
		
func _process(delta):
	$Timer/LabelTimer.text = str(int(timer.time_left / 60)) + ":" + str(int(timer.time_left) % 60)
	$NumGlaceCats/GlaceCats.text = str(get_parent().num_glace_cats)
	if Input.is_action_just_pressed("pause"):
		pauseMenu()
	
		
func _physics_process(delta):
	if get_parent().Character:
		camera.position = get_parent().Character.position


func build_uhd(num_total_cats):
	$NumGlaceCats/TotalGlaceCats.text = str(num_total_cats)
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
	if multiplayer.is_server():
		rpc('end_game')
	
@rpc("authority", "call_local")
func end_game():
	var endGameScreen = preload("res://screens/scenes/end_game_screen.tscn").instantiate()
	if get_parent().get_node(get_name_player()).is_in_group("dogs") :
		endGameScreen.get_node("VBoxContainer/LabelTeam").text = "Vitoria dos Gatos Hackers!"
		endGameScreen.get_node("TotalPlayers/Cats").text = str(get_parent().num_total_cats) + " Gatos"
		endGameScreen.get_node("TotalPlayers/Dogs").text = str(get_parent().num_total_dogs) + " Cachorros"
		
		var time_in_minutes = get_parent().time_match / 60.0
		var formatted_time = "%0.2f" % time_in_minutes
		endGameScreen.get_node("MatchTime/Time").text = formatted_time + " Minutos"

		endGameScreen.get_node("IWasGlace").visible = false
		endGameScreen.get_node("GlaceCats").visible = true
		endGameScreen.get_node("SaveCats").visible = false
		endGameScreen.get_node("GlaceCats/LabelMyGlaceCats").text = str(get_parent().get_node(get_name_player()).num_my_glace_cats)
		endGameScreen.get_node("GlaceCats/LabelTotalGlaceCats").text = str(get_parent().num_total_glace_cats)
	if get_parent().get_node(get_name_player()).is_in_group("cats"):
		endGameScreen.get_node("VBoxContainer/LabelTeam").text = "Vitoria dos Cachorros Hackers!"
		endGameScreen.get_node("TotalPlayers/Cats").text = str(get_parent().num_total_cats) + " Gatos"
		endGameScreen.get_node("TotalPlayers/Dogs").text = str(get_parent().num_total_dogs) + " Cachorros"
		
		var time_in_minutes = get_parent().time_match / 60.0
		var formatted_time = "%0.2f" % time_in_minutes
		endGameScreen.get_node("MatchTime/Time").text = formatted_time + " Minutos"

		endGameScreen.get_node("IWasGlace").visible = true
		endGameScreen.get_node("GlaceCats").visible = false
		endGameScreen.get_node("SaveCats").visible = true
		endGameScreen.get_node("SaveCats/LabelMySaveCats").text = str(get_parent().get_node(get_name_player()).num_my_save_cats)	
		endGameScreen.get_node("SaveCats/LabelTotalGlaceCats").text = str(get_parent().num_total_glace_cats)
		endGameScreen.get_node("IWasGlace/Label").text = str(get_parent().get_node(get_name_player()).num_my_was_glace)	
		
	get_parent().get_parent().add_child(endGameScreen)
	get_parent().get_parent().get_node("Game").queue_free()
	pass
		
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
		if first_charge == true:
			first_charge = false
			get_parent().get_node(get_name_player()).activate_info_tecla_x()	
		else: 
			message_game("Habilidade recarregada", false)	
			
		
func start_timer():
	$SkillCharge/Animation.play("charge_0")
	$SkillCharge/TimerCharge.start(5)
	charge_skill = 1
	$SkillCharge/TimerCharge/EffectCharge.play()
	
	
func message_game(text, som=true):
	if som == true:
		$Team/MarginContainer/VBoxContainer/GamMessages/EffectNotificationMessage.play()
	$Team/MarginContainer/VBoxContainer/GamMessages.text = text
	$Team/MarginContainer/VBoxContainer/GamMessages/TimerMessage.start(2)
	

func _on_timer_message_timeout():
	$Team/MarginContainer/VBoxContainer/GamMessages.text = " "
	

func get_name_player() -> String:
	var id = Networking.get_player_id()
	var list_players = Networking.return_list()
	var name_player = null
	for i in range(list_players.size()):
		if id == list_players[i][0]:
			name_player = list_players[i][1]
	return name_player
