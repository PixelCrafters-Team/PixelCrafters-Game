extends CharacterBody2D

const SPEED_WALK = 64.0

@export_category("Variables")
@export var move_speed: float = SPEED_WALK
@export var friction: float = 0.2
@export var acceleration: float = 0.2

@export_category("Objects")
@export var animation_tree: AnimationTree = null

@export var player_pin_scene: PackedScene = preload("res://characters/scenes/player_pin.tscn")

var nickname = ""
var state_machine 
var is_walking: bool = false
var is_glace: bool = false
var is_skill_active = false
var is_skill_estrela = false
var is_skill_ronronante = false
var is_skill_sombra = false
var is_skill_boladepelos = false
var is_skill_sargento_canis = false
var is_skill_brutus = false
var num_my_glace_cats = 0 # Se sou cachorro
var num_my_save_cats = 0  # Se sou gato
var num_my_was_glace = 0  # Se sou gato

var list_positions_teleport = [
	Vector2(480, 676), 
	Vector2(-182, -475), 
	Vector2(-1098, 118), 
	Vector2(947, 78), 
	Vector2(531, -1047), 
	Vector2(-532, -587), 
	Vector2(-487, -1252), 
	Vector2(-371, -1876) 
]

func _ready():
	state_machine = animation_tree["parameters/playback"]
	#$namePlayer.text = get_parent().get_parent().player_name
	
	if is_multiplayer_authority():
		$Camera2D.enabled = true
	else:
		$Camera2D.enabled = false
	
	if is_in_group("cats"):
		$InfoTeclaZ.visible = false
		
	

func _physics_process(delta):
	if is_multiplayer_authority():
		if is_glace == false:
			move_and_slide()
			move()
			animate()
		
		if (Input.is_action_pressed("move_left") or 
				Input.is_action_pressed("move_right") or 
				Input.is_action_pressed("move_down") or
				Input.is_action_pressed("move_up")) and is_glace == false:
			if not is_walking:
				is_walking = true
				$TimerWalk.start(0.3)
				$EffectWalk.play()
		else:
			is_walking = false
		
		if !(is_skill_ronronante and is_in_group("dogs")):
			if Input.is_key_pressed(KEY_SPACE):
				move_speed = SPEED_WALK + 36
			else:
				move_speed = SPEED_WALK
		elif is_skill_ronronante and is_in_group("dogs"):
			var name_player = get_name_player()
			if (get_parent().get_node(name_player).is_in_group("brutus") and is_skill_brutus):
				var brutus_speed = SPEED_WALK
				if (Input.is_key_pressed(KEY_SPACE)):
					brutus_speed = SPEED_WALK + 36
				get_parent().get_node(name_player).move_speed = brutus_speed
			else:
				move_speed = SPEED_WALK - (SPEED_WALK * 0.5)
		
		if is_skill_estrela and is_in_group("estrela"):
			move_speed += 50
			
		"""	
		if Input.is_key_pressed(KEY_Z) and is_in_group("cats"):
			glace_cat(nickname)
			rpc('glace_cat', nickname)
			
		if Input.is_key_pressed(KEY_C) and is_in_group("cats"):
			unfreeze_cat(nickname)
			rpc('unfreeze_cat', nickname)
		"""	
		if Input.is_key_pressed(KEY_Z):
			if is_in_group("cats"):
				check_and_unfreeze_nearby_cats()
				
		if Input.is_key_pressed(KEY_X):
			if $InfoTeclaX.visible == true:
				$InfoTeclaX.visible = false
			activate_skill()
			
		if multiplayer.is_server():
			if get_parent().num_glace_cats == get_parent().num_total_cats:
				rpc("end_game")	
		
	
			
func move() -> void:
	var direction: Vector2 = Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down"),
	)
		
	if direction != Vector2.ZERO:
		animation_tree["parameters/Idle/blend_position"] = direction
		animation_tree["parameters/Walk/blend_position"] = direction
		velocity.x = lerp(velocity.x, direction.normalized().x * move_speed, acceleration)
		velocity.y = lerp(velocity.y, direction.normalized().y * move_speed, acceleration)
		rpc("update_animation_state", direction, "Walk")
		return
	
	velocity.x = lerp(velocity.x, direction.normalized().x * move_speed, friction)
	velocity.y = lerp(velocity.y, direction.normalized().y * move_speed, friction)
	rpc("update_animation_state", direction, "Idle")
	
func set_nickname(nickname):
	self.nickname = nickname
	$namePlayer.text = nickname
	pass

func animate() -> void:
	if velocity.length() > 2:
		state_machine.travel("Walk")
		rpc("update_animation_state", velocity, "Walk")
		return	
	state_machine.travel("Idle")
	rpc("update_animation_state", velocity, "Idle")

func _on_timer_timeout():
	is_walking = false

@rpc
func glace_cat(player_glace=self.nickname, play_effect=true):
	var list_players = Networking.return_list()
	for i in range(list_players.size()):
		if player_glace == list_players[i][1]:
			if get_parent().get_node(player_glace+'/TextureGlace').visible == false:
				get_parent().num_glace_cats += 1
				get_parent().num_total_glace_cats += 1
				get_parent().get_node(player_glace).num_my_was_glace += 1 
				get_parent().get_node(player_glace+'/TextureGlace').visible = true
				get_parent().get_node(player_glace+'/Texture').visible = false
				get_parent().get_node(player_glace).is_glace = true
			
			if player_glace == get_name_player() or play_effect == true:
				get_parent().get_node(player_glace+'/EffectGlace').play()


@rpc
func unfreeze_cat(player_glace=self.nickname, play_effect=true):
	var list_players = Networking.return_list()
	for i in range(list_players.size()):
		if player_glace == list_players[i][1]:
			if 	get_parent().get_node(player_glace+'/TextureGlace').visible == true:
				get_parent().num_glace_cats -= 1
				get_parent().get_node(player_glace+'/TextureGlace').visible = false
				get_parent().get_node(player_glace+'/Texture').visible = true
				get_parent().get_node(player_glace).is_glace = false
				get_parent().get_node(player_glace+'/IconHeart').visible = true
				get_parent().get_node(player_glace+'/IconHeart/TimerIconHeart').start(2)
			if player_glace == get_name_player() or play_effect == true:
				get_parent().get_node(player_glace+'/EffectGlace').play()


func check_and_unfreeze_nearby_cats():
	var area = get_node("AreaCollision")
	var overlapping_bodies = area.get_overlapping_areas()
	for body in overlapping_bodies:			
		var player_glace = body.get_parent().nickname
		if body.get_parent().is_in_group("cats") and body.get_parent().get_node('TextureGlace').visible:
			$InfoTeclaZ.visible = false
			unfreeze_cat(player_glace)
			rpc('unfreeze_cat', player_glace, false)
			num_my_save_cats += 1 
			set_message_game_hud( "Jogador " + $namePlayer.text + " descongelou jogador " +  player_glace, false)
			rpc("set_message_game_hud", "Jogador " +  $namePlayer.text + " descongelou jogador " +  player_glace)


func activate_skill():
	if get_parent().get_node("HUD").charge_skill == 0 and is_skill_active == false:
		if ((not is_skill_sargento_canis and is_in_group("cats")) or is_in_group("dogs")):
			is_skill_active = true
			if  is_in_group("dogs"): 
				$EffectActiveSkillDog.play()
			elif is_in_group("cats"):
				$EffectActiveSkillCat.play()
			$Skill.visible = true
		elif (is_skill_sargento_canis and is_in_group("cats")):
			var hud_message = "Não é possível ativar habilidades enquanto Latido sônico estiver ativado."
			set_message_game_hud(hud_message, false)
		if is_in_group("estrela") and is_in_group("dogs"):
			$Skill/SkillDuration.start(3)
			is_skill_estrela = true
			set_message_game_hud( "Jogador " + $namePlayer.text + " - Ativou habilidade: Patas Saltitantes", false)
			rpc("set_message_game_hud", "Jogador " + $namePlayer.text + " - Ativou habilidade: Patas Saltitantes")
		if is_in_group("ronronante") and not is_skill_sargento_canis:
			$Skill/SkillDuration.start(5)
			is_skill_ronronante = true
			rpc("update_ronronante_skill", true)
			var message_ronronante = "Jogador " + $namePlayer.text + " - Ativou habilidade: Ronronar calmante"
			set_message_game_hud(message_ronronante, false)
			rpc("set_message_game_hud", message_ronronante)
		if is_in_group("boladepelos")  and not is_skill_sargento_canis:
			$Skill/SkillDuration.start(5)
			is_skill_boladepelos = true
			rpc("update_boladepelos_skill", true)
			var message_boladepelos = "Jogador " + $namePlayer.text + " - Ativou habilidade: Ataque de pelos"
			set_message_game_hud(message_boladepelos, false)
		if is_in_group("sombra") and not is_skill_sargento_canis:
			$Skill/SkillDuration.start(5)
			is_skill_sombra = true
			rpc("update_sombra_skill", true)
			var message_sombra = "Jogador " + $namePlayer.text + " - Ativou habilidade: Esconderijo felino"
			set_message_game_hud(message_sombra, false)
		if is_in_group("sargentocanis"):
			$Skill/SkillDuration.start(5)
			is_skill_sargento_canis = true
			rpc("update_sargento_canis_skill", true)
			var message_sagento_canis = "Jogador " + $namePlayer.text + " - Ativou habilidade: Latido sônico"
			set_message_game_hud(message_sagento_canis, false)
		if is_in_group("brutus"):
			$Skill/SkillDuration.start(5)
			is_skill_brutus = true
			rpc("update_brutus_skill", true)
			var message_brutus = "Jogador " + $namePlayer.text + " - Ativou habilidade: Resistência canina"
			set_message_game_hud(message_brutus, false)
			
@rpc
func set_message_game_hud(text, play_effect=true):
	get_parent().get_node("HUD").message_game(text, play_effect)
		
	
func _on_skill_duration_timeout():
	$Skill.visible = false
	is_skill_active = false
	if is_in_group("estrela"):
		is_skill_estrela = false
		get_parent().get_node("HUD").start_timer()
	$Skill/SkillDuration.stop()


@rpc
func update_animation_state(direction: Vector2, state: String) -> void:
	if direction != Vector2.ZERO:
		animation_tree["parameters/Idle/blend_position"] = direction
		animation_tree["parameters/Walk/blend_position"] = direction
	state_machine.travel(state)

@rpc
func update_sargento_canis_skill(is_active: bool):
	var name_player = get_name_player()	
	get_parent().get_node(name_player).is_skill_sargento_canis = is_active
	
@rpc
func update_brutus_skill(is_active: bool):
	var name_player = get_name_player()	
	get_parent().get_node(name_player).is_skill_brutus = is_active
	
@rpc
func update_ronronante_skill(is_active: bool):
	var name_player = get_name_player()
	get_parent().get_node(name_player).is_skill_ronronante = is_active
	
@rpc
func update_sombra_skill(is_active: bool):
	var name_player = get_name_player()
	if (get_parent().get_node(name_player).is_in_group("dogs") and is_active):
		if (get_parent().get_node(name_player).is_in_group("brutus")):
			get_parent().get_node(self.nickname).visible = true
		else:
			get_parent().get_node(self.nickname).visible = false
	else:
		get_parent().get_node(self.nickname).visible = true
	is_skill_sombra = is_active
	
	
@rpc
func update_boladepelos_skill(is_active: bool):
	var name_player = get_name_player()	
	if (get_parent().get_node(name_player).is_in_group("dogs") and is_active):
		if (get_parent().get_node(name_player).is_in_group("brutus")):
			get_parent().get_node("Map").visible = true
		else:
			get_parent().get_node("Map").visible = false
	else:
		get_parent().get_node("Map").visible = true
	is_skill_boladepelos = is_active


func get_name_player() -> String:
	var id = Networking.get_player_id()
	var list_players = Networking.return_list()
	var name_player = null
	for i in range(list_players.size()):
		if id == list_players[i][0]:
			name_player = list_players[i][1]
	if name_player == null:
		return ""
	return name_player
	
func get_position_player() -> Vector2:
	var player_node = get_parent().get_node(self.get_name_player())
	if player_node:
		return player_node.global_position
	return Vector2.ZERO 
	
func get_position_player_pin(player_name: String) -> Vector2:
	var player_node = get_parent().get_node(player_name)
	if player_node:
		return player_node.global_position
	return Vector2.ZERO 
	
	
func _on_area_collision_area_entered(area):
	if area.name == 'AreaCollision':	# colisão com um personagem
		var player_glace = area.get_parent().nickname
		if area.get_parent().is_in_group("cats") and self.is_in_group("dogs") and get_parent().get_node(player_glace+'/TextureGlace').visible == false:
			num_my_glace_cats += 1
			glace_cat(player_glace)
			rpc('glace_cat', player_glace, false)
			set_message_game_hud("Jogador " + $namePlayer.text + " congelou jogador " + player_glace, false)
			rpc("set_message_game_hud", "Jogador " + $namePlayer.text + " congelou jogador " + player_glace)
			
		if area.get_parent().is_in_group("cats") and self.is_in_group("cats") and get_parent().get_node(player_glace+'/TextureGlace').visible == true and get_name_player() == nickname:
			$InfoTeclaZ.visible = true
		
			
	if area.is_in_group("teleport") and get_parent().num_map == 0 and is_multiplayer_authority(): # colisão com um portal de teletransporte
		global_position = list_positions_teleport[randi_range(0, 3)]
		get_parent().teleportSound.play()
	elif area.is_in_group("teleport") and get_parent().num_map == 1 and is_multiplayer_authority():
		global_position = list_positions_teleport[randi_range(4, 7)]
		get_parent().teleportSound.play()


func _on_skill_duration_timeout_ronronante():
	$Skill.visible = false
	is_skill_active = false
	is_skill_ronronante = false
	rpc("update_ronronante_skill", false)
	get_parent().get_node("HUD").start_timer()
	$Skill/SkillDuration.stop()


func _on_skill_duration_timeout_sombra():
	$Skill.visible = false
	is_skill_active = false
	is_skill_sombra = false
	rpc("update_sombra_skill", false)
	get_parent().get_node("HUD").start_timer()
	$Skill/SkillDuration.stop()


func _on_skill_duration_timeout_boladepelos():
	$Skill.visible = false
	is_skill_active = false
	is_skill_boladepelos = false
	rpc("update_boladepelos_skill", false)
	get_parent().get_node("HUD").start_timer()
	$Skill/SkillDuration.stop()


func _on_skill_duration_timeout_sargento_canis():
	$Skill.visible = false
	is_skill_active = false
	is_skill_sargento_canis = false
	rpc("update_sargento_canis_skill", false)
	get_parent().get_node("HUD").start_timer()
	$Skill/SkillDuration.stop()


func _on_skill_duration_timeout_brutus():
	$Skill.visible = false
	is_skill_active = false
	is_skill_brutus = false
	rpc("update_brutus_skill", false)
	get_parent().get_node("HUD").start_timer()
	$Skill/SkillDuration.stop()


func _on_area_collision_area_exited(area):
	if is_in_group("cats"):
		$InfoTeclaZ.visible = false
		
		
@rpc("authority", "call_local")
func end_game():
	var endGameScreen = preload("res://screens/scenes/end_game_screen.tscn").instantiate()
	if get_parent().get_node(get_name_player()).is_in_group("dogs") :
		endGameScreen.get_node("VBoxContainer/LabelTeam").text = "Vitoria dos Cachorros Vigilantes!"
		endGameScreen.get_node("TotalPlayers/Cats").text = str(get_parent().num_total_cats) + " Gatos"
		endGameScreen.get_node("TotalPlayers/Dogs").text = str(get_parent().num_total_dogs) + " Cachorros"

		var time_in_minutes = (get_parent().time_match  - get_parent().get_node("HUD/Timer").time_left) / 60.0
		var formatted_time = "%0.2f" % time_in_minutes
		endGameScreen.get_node("MatchTime/Time").text = formatted_time + " Minutos"

		endGameScreen.get_node("IWasGlace").visible = false
		endGameScreen.get_node("GlaceCats").visible = true
		endGameScreen.get_node("SaveCats").visible = false
		endGameScreen.get_node("GlaceCats/LabelMyGlaceCats").text = str(get_parent().get_node(get_name_player()).num_my_glace_cats)
		endGameScreen.get_node("GlaceCats/LabelTotalGlaceCats").text = str(get_parent().num_total_glace_cats)
		endGameScreen.get_node("VictoryDefeat").frame = 1
		endGameScreen.audio_victory_defeat = 1
	if get_parent().get_node(get_name_player()).is_in_group("cats"):
		endGameScreen.get_node("VBoxContainer/LabelTeam").text = "Derrota dos Gatos Hackers!"
		endGameScreen.get_node("TotalPlayers/Cats").text = str(get_parent().num_total_cats) + " Gatos"
		endGameScreen.get_node("TotalPlayers/Dogs").text = str(get_parent().num_total_dogs) + " Cachorros"
		
		var time_in_minutes = (get_parent().time_match  - get_parent().get_node("HUD/Timer").time_left) / 60.0
		var formatted_time = "%0.2f" % time_in_minutes
		endGameScreen.get_node("MatchTime/Time").text = formatted_time + " Minutos"

		endGameScreen.get_node("IWasGlace").visible = true
		endGameScreen.get_node("GlaceCats").visible = false
		endGameScreen.get_node("SaveCats").visible = true
		endGameScreen.get_node("SaveCats/LabelMySaveCats").text = str(get_parent().get_node(get_name_player()).num_my_save_cats)	
		endGameScreen.get_node("SaveCats/LabelTotalGlaceCats").text = str(get_parent().num_total_glace_cats)
		endGameScreen.get_node("IWasGlace/Label").text = str(get_parent().get_node(get_name_player()).num_my_was_glace)	
		endGameScreen.get_node("VictoryDefeat").frame = 0
		endGameScreen.audio_victory_defeat = 0
	
	get_parent().get_parent().add_child(endGameScreen)
	get_parent().get_parent().get_node("Game").queue_free()
	pass
	
func activate_info_tecla_x():
	$InfoTeclaX.visible = true
	$InfoTeclaX/TimerInfoTeclaX.start(3)


func _on_timer_info_tecla_x_timeout():
	$InfoTeclaX/TimerInfoTeclaX.stop()
	$InfoTeclaX.visible = false


func _on_timer_icon_heart_timeout():
	$IconHeart/TimerIconHeart.stop()
	$IconHeart.visible = false
	rpc("update_icon_heart", get_name_player())
	
@rpc()
func update_icon_heart(player):
	get_parent().get_node(player+'/IconHeart').visible = false
	

