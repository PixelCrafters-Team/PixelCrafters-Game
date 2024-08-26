extends CanvasLayer

@export var equipe: String = "-"
@onready var camera = $MiniMap/SubViewportContainer/SubViewport/Map/Camera2D
@onready var timer = $Timer
@onready var pause_menu = $PauseMenu
var paused = false
var charge_skill
var endGameScreen
var first_charge

@onready var map1 = $MiniMap/SubViewportContainer/SubViewport
@onready var map2 = $MiniMap/SubViewportContainer/SubViewport

var game_world_size = Vector2(3744, 3303) # Example size, replace with your actual game world size
var minimap_size = Vector2(200, 200)

func _ready():
	$SkillCharge/Animation.play("charge_0")
	$SkillCharge/TimerCharge.start(5)
	charge_skill = 1
	first_charge = true
	$Team/MarginContainer/VBoxContainer/GamMessages.text = " "
	$InfoGame/TimerInfoGame.start()
	
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
	add_player_pins()
	
func add_player_pins():
	var player_list = Networking.return_list()
	clear_existing_pins()
	
	if not get_parent().get_node(get_name_player()):
		return
	var current_player = get_parent().get_node(get_name_player())
	var is_current_player_cat = current_player.is_in_group("cats")

	for player in player_list:
		var player_pin = preload("res://characters/scenes/player_pin.tscn").instantiate()
		player_pin.name = "PlayerPin_" + player[1]
		
		
		player_pin.position = get_parent().get_node(get_name_player()).get_position_player_pin(player[1])

		var player_node = get_parent().get_node(player[1])
		if player_node == null:
			print("No player node found for ID: ", player[1])
			continue
		if is_current_player_cat:
			if player_node.is_in_group("dogs"):
				set_pin_color2(player_pin, Color.ORANGE)
			else:
				set_pin_color(player_pin, Color.BLUE)  
		else:

			if player_node.is_in_group("cats"):
				set_pin_color2(player_pin, Color.ORANGE) 
			else:
				set_pin_color(player_pin, Color.BLUE) 

		if get_parent().num_map == 0:
			map1.add_child(player_pin)
		else: 
			map2.add_child(player_pin)

func set_pin_color(pin: Node2D, color: Color):
	var panel = pin.get_node("Panel")
	if panel:
		panel.modulate = color
		
func set_pin_color2(pin: Node2D, color: Color):
	var panel = pin.get_node("Panel")
	if panel:
		var stylebox = panel.get_theme_stylebox("panel")
		if stylebox and stylebox is StyleBoxFlat:
			stylebox.bg_color = color
			panel.add_theme_stylebox_override("panel", stylebox)

func clear_existing_pins():
	for pin in map1.get_children():
		if pin.name.begins_with("PlayerPin_"):
			pin.queue_free()
			map1.remove_child(pin)
	for pin in map2.get_children():
		if pin.name.begins_with("PlayerPin_"):
			pin.queue_free()
			map1.remove_child(pin)
	

func _physics_process(delta):
	var main_node = get_tree().root.get_node("Main")
	if main_node.has_node("Game/" + get_name_player()):
		var character = get_parent().get_node(get_name_player())
		
		if is_instance_valid(character):
			camera.position = character.get_position_player()


func build_uhd(num_total_cats):
	$NumGlaceCats/TotalGlaceCats.text = str(num_total_cats)
	if get_parent().get_node(get_name_player()).is_in_group("cats"):
		equipe = "Gatos Hackers"
	elif get_parent().get_node(get_name_player()).is_in_group("dogs"):
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
		endGameScreen.get_node("VBoxContainer/LabelTeam").text = "Derrota dos Cachorros Vigilantes!"
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
		endGameScreen.get_node("VictoryDefeat").frame = 0
		endGameScreen.audio_victory_defeat = 0
		
	if get_parent().get_node(get_name_player()).is_in_group("cats"):
		endGameScreen.get_node("VBoxContainer/LabelTeam").text = "Vitoria dos Gatos Hackers!"
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
		endGameScreen.get_node("VictoryDefeat").frame = 1
		endGameScreen.audio_victory_defeat = 1
		
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
	if not id or not list_players:
		return "erro"
	for i in range(list_players.size()):
		if id == list_players[i][0]:
			name_player = list_players[i][1]
	return name_player


func _on_continue_pressed():
	$InfoGame.visible = false
	pass 


func _on_timer_info_game_timeout():
	$InfoGame/TimerInfoGame.stop()
	$InfoGame.visible = true
	pass 
