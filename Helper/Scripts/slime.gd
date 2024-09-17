extends "res://Helper/Ancestor/enemy.gd"


const SPEED = 300.0
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
		direction = Vector2(randi_range(0,100),randi_range(0,100))

	move_and_slide()
