extends CharacterBody2D
#This is the player script for Temporal Tower. 
@onready var state_machine = $AnimationTree.get("parameters/playback")
var prevDirection : Vector2
@export var SPEED = 300.0
@export var ACCELERATION = 10
@export var hp: int  = 100
@export_flags("Dash","Silkgun","AtomicHammer","Haunt","Vector","Ignite")var powers = 0
@export_enum("Idle","Walk","Attack")var state :int

const values = {
	"idle": 0,
	"walk": 1,
	"attack": 2,
}


func _init() -> void:
	powers = Global.powers
	hp = Global.hp
	print(values.walk)

func _physics_process(delta: float) -> void:
	# Handle basic movement
	var horizontal = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	var vertical = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	var inputDirection = Vector2(horizontal, vertical).normalized()
	
	#handles the attack script
	if Input.is_action_just_pressed("attack"):
		if state != values.attack:
			if inputDirection != Vector2.ZERO:
				$AnimationTree.set("parameters/Attack/blend_position",inputDirection)
			else:
				$AnimationTree.set("parameters/Attack/blend_position",prevDirection)
			state = values.attack
			state_machine.travel("Attack")
			$Hitbox/AttackTimer.start()
		
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if inputDirection and canmove():
		
		if state == values.idle:
			state = values.walk
		if((inputDirection.x * velocity.x) < 0 ):
			velocity.x = move_toward(velocity.x, inputDirection.x * SPEED, 3*ACCELERATION)
		if((inputDirection.y * velocity.y) < 0 ):
			velocity.y = move_toward(velocity.y, inputDirection.y * SPEED, 3*ACCELERATION)
		#velocity.x = inputDirection.x * SPEED
		#velocity.y = inputDirection.y * SPEED
		velocity.x = move_toward(velocity.x, inputDirection.x * SPEED, ACCELERATION)
		velocity.y = move_toward(velocity.y, inputDirection.y * SPEED, ACCELERATION)
	else:
		if state == values.walk:
			state = values.idle
		velocity.x = move_toward(inputDirection.x, 0, SPEED)
		velocity.y = move_toward(inputDirection.y, 0, SPEED)
	
	if inputDirection != Vector2.ZERO:
		prevDirection = inputDirection
	
	anim_handler(inputDirection)
	
	move_and_slide()
	


func canmove() -> bool:
	if state == values.attack:
		return false
	else:
		return true

func attack(direction):
	if Input.is_action_just_pressed("attack"):
		$AnimationTree.set("parameters/Attack/blend_position",direction)
		state_machine.travel("Attack")

func anim_handler(direction):
	if direction != Vector2.ZERO:
		$AnimationTree.set("parameters/Idle/blend_position",direction)
		$AnimationTree.set("parameters/Walk/blend_position",direction)
	if state == values.idle:
		state_machine.travel("Idle")
	if state == values.walk:
		state_machine.travel("Walk")


func _on_animated_sprite_2d_animation_finished() -> void:
	print("anim finished")
	if state == values.attack:
		state = values.idle
		


func _on_attack_timer_timeout() -> void:
	state = values.idle


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		body.hit(2)
