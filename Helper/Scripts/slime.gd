extends "res://Helper/Ancestor/enemy.gd"


@export var SPEED = 50.0
const JUMP_VELOCITY = -400.0
@export_enum("roam","charge","fire","reload","chase") var state: int
const ROAM = 0 #Wander Around
const CHARGE = 1 #Wind up Before attacking set up target location
const FIRE = 2 #Fling toward target location dashing past it.
const RELOAD = 3 #Recovery time after launching
const CHASE = 4 #Slime will move closer, once in range switch to charge
var direction: Vector2
func _init() -> void:
	print(state)
func _physics_process(delta: float) -> void:
	if state == ROAM:
		if !$RestTimer.is_stopped():
			velocity.x = move_toward(velocity.x, direction.x * SPEED, SPEED)
			velocity.y = move_toward(velocity.y, direction.y * SPEED, SPEED)
		else:
			velocity = Vector2.ZERO

	move_and_slide()


func _on_roam_timer_timeout() -> void:
	direction = Vector2(randi_range(-100,100),randi_range(-100,100)).normalized()
	$RestTimer.start()


func _on_rest_timer_timeout() -> void:
	$RoamTimer.start()
