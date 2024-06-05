extends CharacterBody2D


const SPEED = 300.0
const DASH_SPEED = 500.0
const JUMP_VELOCITY = -380.0

var dash_direction = Vector2(1,0)
var can_move = true

var powers = []

var is_dashing = false
var can_dash = false

var is_double_jumping = false
var can_double_jump = false
var jump_count = 0


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func start():
	$AnimatedSprite2D.animation = "idle"
	
func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	if can_move:
		# Handle dash
		dash()
		if not is_dashing:
			# Add the gravity.
			if not is_on_floor():
				velocity.y += gravity * delta
				$AnimatedSprite2D.flip_h = velocity.x < 0
					
			if is_on_floor():
				if powers.find("jump") != -1:
					jump_count = 1
				else: 
					jump_count = 0
			else:
				$AnimatedSprite2D.animation = "jump"
				$AnimatedSprite2D.play()
				
			# Handle jump.
			if Input.is_action_just_pressed("space") and jump_count >= 0:
				jump_count -= 1
				velocity.y = JUMP_VELOCITY
				
			if direction:
				velocity.x = direction * SPEED
			else:
				velocity.x = move_toward(velocity.x, 0, SPEED)
				
			if velocity.length() > 0 and is_on_floor():
				$AnimatedSprite2D.animation = "walk"
				$AnimatedSprite2D.play()
				$AnimatedSprite2D.flip_h = velocity.x < 0
			else:
				$AnimatedSprite2D.animation = "idle"
				$AnimatedSprite2D.play()
				
			
		move_and_slide()
		
func dash():
	if powers.find("dash") != -1:
		if is_on_floor():
			can_dash = true
			
		if Input.is_action_pressed("left"):
			dash_direction = Vector2(-1,0)
		if Input.is_action_pressed("right"):
			dash_direction = Vector2(1,0)
			
		if Input.is_action_just_pressed("dash") and can_dash:
			velocity = dash_direction.normalized() * DASH_SPEED
			can_dash = false
			is_dashing = true
			await get_tree().create_timer(0.1).timeout
			is_dashing = false
			

func _on_canvas_layer_commands_changed(text):
	powers = text.split(",")
