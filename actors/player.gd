extends CharacterBody2D


const DASH_SPEED = 600.0
const JUMP_VELOCITY = -390.0

var speed = 300.0
var dash_direction = Vector2(1,0)
var can_move = true

var powers = []
var characterSprite = "Beige"

var is_dashing = false
var can_dash = false

var is_double_jumping = false
var can_double_jump = false
var jump_count = 0


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	$AnimatedSprite2D.animation = "idle"
	var config = ConfigFile.new()
	var data = config.load("res://actors/player.cfg")
	print("a")

	if data != OK:
		print("err")
		return

	for player in config.get_sections():
		characterSprite = config.get_value(player, "player_skin")
	
func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	if can_move:
		# Handle dash
		dash()
		double_velocity()
		if not is_dashing:
			# Add the gravity.
			if not is_on_floor():
				velocity.y += gravity * delta
				$AnimatedSprite2D.flip_h = velocity.x < 0
					
			if is_on_floor():
				if powers.find("pujm") != -1:
					jump_count = 1
				else: 
					jump_count = 0
					
				if velocity.length() > 0:
					$AnimatedSprite2D.animation = "walk" + characterSprite
					$AnimatedSprite2D.play()
					$AnimatedSprite2D.flip_h = velocity.x < 0
				else:
					$AnimatedSprite2D.animation = "idle" + characterSprite
					$AnimatedSprite2D.play()
			else:
				$AnimatedSprite2D.animation = "jump" + characterSprite
				$AnimatedSprite2D.play()
				
			# Handle jump.
			if Input.is_action_just_pressed("space") and jump_count >= 0:
				jump_count -= 1
				velocity.y = JUMP_VELOCITY
				
			if direction:
				velocity.x = direction * speed
			else:
				velocity.x = move_toward(velocity.x, 0, speed)
				
				
			
		move_and_slide()
		
func dash():
	if powers.find("sadh") != -1:
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
			
func double_velocity():
	if powers.find("clove") != -1:
		speed = 600.0
	else:
		speed = 300.0
func _on_canvas_layer_commands_changed(text):
	#dash -> sadh
	#jump -> pujm
	#veloc -> clove
	powers = text.split(" ")
