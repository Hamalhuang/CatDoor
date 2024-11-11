extends CharacterBody2D
const SPEED = 130.0
const JUMP_VELOCITY = -500
const ACCELERATION := SPEED/0.5
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite = $AnimatedSprite2D
@onready var timer : Timer = $"../Timer"
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	# Get the input direction: -1, 0, 1
	var direction = Input.get_axis("move_left", "move_right")
	# Flip the Sprite
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
	
	# Play animations
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("Idle")
		else:
			if timer.time_left>0:
				animated_sprite.play("run")
			else:
				animated_sprite.play("walk")
	else:
		animated_sprite.play("jump")
	# Apply movement
	var changeSpeed := 1
	if Input.is_action_pressed("switch_speed"):
		$Camera2D.position_smoothing_speed = 10
		changeSpeed = 2.5
		timer.start()
	elif Input.is_action_just_released("switch_speed"):
		$Camera2D.position_smoothing_speed = 3
		changeSpeed = 1
		timer.stop()
	if direction:
		velocity.x = changeSpeed * direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, ACCELERATION*delta)
	
	
	move_and_slide()
