extends CharacterBody2D

@export_category("Variables")
@export var move_speed: float = 64
@export var friction: float = 0.2
@export var acceleration: float = 0.2

@export_category("Objects")
@export var animation_tree: AnimationTree = null

var nickname = ""
var state_machine
var is_walking: bool = false
var is_glace: bool = false
var is_skill_active = false
var is_skill_estrela = false
var is_skill_ronronante = false

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
		
		if Input.is_key_pressed(KEY_SPACE):
			move_speed = 100
		else:
			move_speed = 64
		
		if is_skill_estrela and is_in_group("estrela"):
			move_speed += 50
	
		if is_skill_ronronante and is_in_group("dogs"):
			print("skill ronronante")
			move_speed = move_speed - (move_speed * 0.4)
			
		if Input.is_key_pressed(KEY_Z) and is_in_group("cats"):
			glace_cat(nickname)
			rpc('glace_cat', nickname)
			
		if Input.is_key_pressed(KEY_C) and is_in_group("cats"):
			unfreeze_cat(nickname)
			rpc('unfreeze_cat', nickname)
			
		if Input.is_key_pressed(KEY_X):
			activate_skill()
	

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
func glace_cat(player_glace=self.nickname):
	var list_players = Networking.return_list()
	for i in range(list_players.size()):
		if player_glace == list_players[i][1]:
			get_parent().get_node(player_glace+'/TextureGlace').visible = true
			get_parent().get_node(player_glace+'/Texture').visible = false
			get_parent().get_node(player_glace).is_glace = true
			get_parent().get_node(player_glace+'/EffectGlace').play()

@rpc
func unfreeze_cat(player_glace=self.nickname):
	var list_players = Networking.return_list()
	for i in range(list_players.size()):
		if player_glace == list_players[i][1]:
			get_parent().get_node(player_glace+'/TextureGlace').visible = false
			get_parent().get_node(player_glace+'/Texture').visible = true
			get_parent().get_node(player_glace).is_glace = false
			get_parent().get_node(player_glace+'/EffectGlace').play()


func activate_skill():
	if get_parent().get_node("HUD").charge_skill == 0 and is_skill_active == false:
		is_skill_active = true
		$EffectActiveSkill.play()
		$Skill/SkillDuration.start(5)
		$Skill.visible = true
		if is_in_group("estrela") and is_in_group("dogs"):
			is_skill_estrela = true
			set_message_game_hud( "Jogador " + $namePlayer.text + " - Ativou habilidade: Patas Saltitantes", false)
			rpc("set_message_game_hud", "Jogador " + $namePlayer.text + " - Ativou habilidade: Patas Saltitantes")
		if is_in_group("ronronante") and is_in_group("cats"):
			is_skill_ronronante = true
			rpc("update_ronronante_skill", true)
			var message_ronronante = "Jogador " + $namePlayer.text + " - Ativou habilidade: Ronronar calmante"
			set_message_game_hud(message_ronronante, false)
			rpc("set_message_game_hud", message_ronronante)

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
func update_ronronante_skill(is_active: bool):
	is_skill_ronronante = is_active

func _on_area_collision_area_entered(area):
	if area.name == 'AreaCollision':	# colisão com um personagem
		var player_glace = area.get_parent().nickname
		if area.get_parent().is_in_group("cats") and self.is_in_group("dogs") and get_parent().get_node(player_glace+'/TextureGlace').visible == false:
			glace_cat(player_glace)
			rpc('glace_cat', player_glace)
			set_message_game_hud("Jogador " + $namePlayer.text + " congelou jogador " + player_glace, false)
			rpc("set_message_game_hud", "Jogador " + $namePlayer.text + " congelou jogador " + player_glace)
			
		if area.get_parent().is_in_group("cats") and self.is_in_group("cats") and get_node('TextureGlace').visible == true:
			unfreeze_cat(nickname)
			rpc('unfreeze_cat', nickname)
			set_message_game_hud( "Jogador " + player_glace + " descongelou jogador " + $namePlayer.text, false)
			rpc("set_message_game_hud", "Jogador " + player_glace + " descongelou jogador " + $namePlayer.text)
	
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
