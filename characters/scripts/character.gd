extends CharacterBody2D

var state_machine

@export_category("Variables")
@export var move_speed: float = 64;

@export var friction: float = 0.2
@export var acceleration: float = 0.2

@export_category("Objects")
@export var animation_tree: AnimationTree = null

func _ready():
	state_machine = animation_tree["parameters/playback"]

func _physics_process(delta):
	move()
	animate()
	move_and_slide()
	

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
