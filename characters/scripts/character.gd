extends CharacterBody2D

var state_machine
var is_walking: bool = false
var is_glace: bool = false

@export_category("Variables")
@export var move_speed: float = 64;
@export var friction: float = 0.2
@export var acceleration: float = 0.2

@export_category("Objects")
@export var animation_tree: AnimationTree = null

@onready var cam = $Camera2D

func _ready():
	state_machine = animation_tree["parameters/playback"]
	cam.enabled = is_multiplayer_authority()
	
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
		
	if Input.is_key_pressed(KEY_Z) and is_in_group("cats"):
		glace_cat()
	if Input.is_key_pressed(KEY_X) and is_in_group("cats"):
		unfreeze_cat()
	
	
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
	
func _enter_tree():
	set_multiplayer_authority(name.to_int())
