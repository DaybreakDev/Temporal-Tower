extends CharacterBody2D

@export var hp = 3
@export var hasPower: bool = false
@export var powername: int = 0
@export var droprate = 20
const SPEED = 300.0
const JUMP_VELOCITY = -400.0

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
func hit(damage):
	hp = hp - damage
	
	if hp <= 0:
		die()

func die():
	if hasPower:
		givepower()
		
func givepower():
	if randi_range(0,droprate) == droprate:
		Global.powers |= powername
		
	
