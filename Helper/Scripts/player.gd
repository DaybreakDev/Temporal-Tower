extends CharacterBody2D
#This is the player script for Temporal Tower. 

@export var SPEED = 300.0
@export var ACCELERATION = 10
@export var hp: int  = 100
@export_flags("Dash","Silkgun","AtomicHammer","Haunt","Vector","Ignite")var powers = 0


func _init() -> void:
	powers = Global.powers
	hp = Global.hp
	print(powers)

func _physics_process(delta: float) -> void:
	# Handle basic movement
	var horizontal = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	var vertical = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	var inputDirection = Vector2(horizontal, vertical).normalized()
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if inputDirection:
		if((inputDirection.x * velocity.x) < 0 ):
			velocity.x = move_toward(velocity.x, inputDirection.x * SPEED, 3*ACCELERATION)
		if((inputDirection.y * velocity.y) < 0 ):
			velocity.y = move_toward(velocity.y, inputDirection.y * SPEED, 3*ACCELERATION)
		#velocity.x = inputDirection.x * SPEED
		#velocity.y = inputDirection.y * SPEED
		velocity.x = move_toward(velocity.x, inputDirection.x * SPEED, ACCELERATION)
		velocity.y = move_toward(velocity.y, inputDirection.y * SPEED, ACCELERATION)
	else:
		velocity.x = move_toward(inputDirection.x, 0, SPEED)
		velocity.y = move_toward(inputDirection.y, 0, SPEED)
	anim_handler(inputDirection)
	move_and_slide()
	

func anim_handler(direction):
	if direction != Vector2.ZERO:
		$AnimationTree.set("parameters/Idle/blend_position",direction)
		$AnimationTree.set("parameters/Walk/blend_position",direction)
