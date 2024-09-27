extends CharacterBody2D
#This is the player script for Temporal Tower. 
@onready var state_machine = $AnimationTree.get("parameters/playback")
var prevDirection : Vector2
@export var SPEED = 120.0
@export var ACCELERATION = 20
@export var hp: int  = 100
@export_flags("Dash","Silkgun","AtomicHammer","Haunt","Vector","Ignite")var powers = 0
@export_enum("Idle","Walk","Attack","Vector")var state :int

#Status markers
var status : String = "Free"
var WebHealth : int = 2

const values = {
	"idle": 0,
	"walk": 1,
	"attack": 2,
	"vector": 3,
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
		#Anthony Berlanga : Just calling the attack function here so that I can test the "Webbed" Status
		attack(inputDirection)
	
	#handles item1 action scrpit
	if Input.is_action_just_pressed("item1"):
		var temp_name = "Vector"
		print("item1 is pressed")
		skillselector(temp_name)
		
	
	
	
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
	elif state == values.vector:
		return false
	else:
		return true

func attack(direction):
	if Input.is_action_just_pressed("attack"):
		$AnimationTree.set("parameters/Attack/blend_position",direction)
		state_machine.travel("Attack")
		if status == "Webbed":
			WebHealth -= 1
			if WebHealth == 0:
				set_status("Free")
				WebHealth = 2

func anim_handler(direction):
	if direction != Vector2.ZERO:
		$AnimationTree.set("parameters/Idle/blend_position",direction)
		$AnimationTree.set("parameters/Walk/blend_position",direction)
	if state == values.idle:
		state_machine.travel("Idle")
	if state == values.walk:
		state_machine.travel("Walk")

#code for using skill vector  
func skill_vector() -> void:
	state = values.vector
	
	for i in 100:
		if state != values.vector:
			break
		await get_tree().create_timer(0.1).timeout
		print("time: ",i)
	
	if state == values.vector:
		state = values.idle

#code for vector shooting in direction
func skill_vector_shoot() -> void:
	return

#code for skillslot to launch selected skill
func skillselector(string) -> void:
	match string:
		"Vector":
			skill_vector()
			print("Vector gun on!")
		_:
			print("nothing selected")

#Anthony Berlanga - Means by which we can affect the player's movespeed or apply DoT etc.
func set_status(newStatus:String) -> void:
	status = newStatus
	match status:
		"Webbed":
			SPEED = 0
		"Free":
			SPEED = 120

func set_speed(newspeed : int) -> void:
	SPEED = newspeed

func get_speed() -> int:
	return SPEED

func _on_animated_sprite_2d_animation_finished() -> void:
	print("anim finished")
	if state == values.attack:
		state = values.idle
		


func _on_attack_timer_timeout() -> void:
	state = values.idle


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		body.hit(2)
		

func _on_i_frame_timer_timeout() -> void:
	pass
	#canBeHit = true
