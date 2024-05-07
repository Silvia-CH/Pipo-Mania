extends CharacterBody2D


const SPEED = 300.0
const DASH_SPEED = 650.0
const JUMP_VELOCITY = -400.0

var dash_direction = Vector2(1,0)
var can_move = true
var is_dashing = false
var can_dash = false


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func start():
	$AnimatedSprite2D.animation = "idle"

func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if can_move:
		dash()
		if not is_dashing:
			# Add the gravity.
			if not is_on_floor():
				velocity.y += gravity * delta
				$AnimatedSprite2D.flip_h = velocity.x < 0
			# Handle jump.
			if Input.is_action_just_pressed("ui_accept") and is_on_floor():
				velocity.y = JUMP_VELOCITY

			if direction:
				velocity.x = direction * SPEED
			else:
				velocity.x = move_toward(velocity.x, 0, SPEED)
				
			if velocity.length() > 0:
				$AnimatedSprite2D.animation = "walk"
				$AnimatedSprite2D.play()
				$AnimatedSprite2D.flip_h = velocity.x < 0
			else:
				$AnimatedSprite2D.animation = "idle"
				$AnimatedSprite2D.play()
				
			
		move_and_slide()
		
func dash():
	if is_on_floor():
		can_dash = true
		
	if Input.is_action_pressed("ui_left"):
		dash_direction = Vector2(-1,0)
	if Input.is_action_pressed("ui_right"):
		dash_direction = Vector2(1,0)
		
	if Input.is_action_just_pressed("dash") and can_dash:
		velocity = dash_direction.normalized() * DASH_SPEED
		can_dash = false
		is_dashing = true
		await get_tree().create_timer(0.1).timeout
		is_dashing = false
	 
