extends CharacterBody2D

@export_category("Variables")
@export var move_speed: float = 64;
@export var friction: float = 0.2
@export var acceleration: float = 0.2

@export_category("Objects")
@export var animation_tree: AnimationTree = null

var state_machine
var is_walking: bool = false
var is_glace: bool = false
var is_skill_active = false
var is_skill_estrela = false

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
	$namePlayer.text = get_parent().get_parent().player_name


func _physics_process(delta):
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
		move_speed = 64;
	
	if is_skill_estrela:
		move_speed += 50
		
	if Input.is_key_pressed(KEY_X) and is_in_group("cats"):
		glace_cat()
	if Input.is_key_pressed(KEY_C) and is_in_group("cats"):
		unfreeze_cat()
		
	if Input.is_key_pressed(KEY_Z) and is_in_group("dogs") and get_name() == "Character_estrela":
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
		return
		
	velocity.x = lerp(velocity.x, direction.normalized().x * move_speed, friction)
	velocity.y = lerp(velocity.y, direction.normalized().y * move_speed, friction)
		
	
func animate() -> void:
	if velocity.length() > 2:
		state_machine.travel("Walk")
		return	
	state_machine.travel("Idle")
	

func _on_timer_timeout():
	is_walking = false
	
	
func glace_cat():
	$TextureGlace.visible = true
	$Texture.visible = false
	is_glace = true
	$EffectGlace.play()


func unfreeze_cat():
	$TextureGlace.visible = false
	$Texture.visible = true
	is_glace = false
	$EffectGlace.play()


func _on_area_teleport_area_entered(area):
	get_parent().teleportSound.play()
	if area.is_in_group("teleport") and get_parent().num_map == 0:
		global_position = list_positions_teleport[randi_range(0, 3)]
	elif area.is_in_group("teleport") and get_parent().num_map == 1:
		global_position = list_positions_teleport[randi_range(4, 7)]
		
		
func activate_skill():
	if get_parent().get_node("HUD").charge_skill == 0 and is_skill_active == false:
		is_skill_active = true
		$EffectActiveSkill.play()
		$Skill/SkillDuration.start(5)
		$Skill.visible = true
		if get_name() == "Character_estrela":
			is_skill_estrela = true
			get_parent().get_node("HUD").message_game("Jogador " + $namePlayer.text + " - Ativou habilidade: Patas Saltitantes")
		

func _on_skill_duration_timeout():
	$Skill.visible = false
	is_skill_active = false
	if get_name() == "Character_estrela":
		is_skill_estrela = false
		get_parent().get_node("HUD").start_timer()
	$Skill/SkillDuration.stop()
