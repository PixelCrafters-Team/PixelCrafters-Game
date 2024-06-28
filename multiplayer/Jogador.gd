extends CharacterBody2D

const SPEED = 300.0
var velocidade = 70
var nickname = ""

func _process(delta):
	if is_multiplayer_authority():
		var direction = Input.get_axis("ui_left", "ui_right")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
		
	pass

func set_nickname(nickname):
	self.nickname = nickname
	$NicknameLabel.text = nickname
	pass

		
	
