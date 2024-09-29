extends CharacterBody2D



@export var speed = 100
@export var steer_force = 100
@export var Health = 3

var target = null
var acceleration = Vector2.ZERO
var storeSpeed = 0
var SpiderOwner = owner
#Either do it with these or with signals from timers of different lengths that trigger shot cooldown then fire shot then back
var ShotCooldown : Timer
var ShotFiring : Timer

func _ready():
	#velocity = transform.x * speed
	velocity = Vector2.ZERO
	ShotCooldown = $ShotCooldown
	ShotFiring = $ShotFiring
	SpiderOwner = owner
	

func _physics_process(delta):
	if target:
		if position.distance_to(target.position) > 110:
			acceleration += seek()
			velocity += acceleration * delta
			velocity = velocity.limit_length(speed)
			move_and_slide()
		elif position.distance_to(target.position) < 80:
			acceleration += seek() * Vector2(-1,-1)
			velocity += acceleration * delta
			velocity = velocity.limit_length(speed)
			move_and_slide()
		else:
			acceleration += orbit()
			velocity += acceleration * delta
			velocity = velocity.limit_length(speed)
			move_and_slide()
	else:
		pass

func seek():
	var steer = Vector2.ZERO
	if target :
		var desired = (target.position - position).normalized()
		if speed != 0:
			desired = desired * speed
		steer = (desired - velocity).normalized() * steer_force
	return steer

func orbit():
	var steer = Vector2.ZERO
	if target :
		var desired = (target.position - position).normalized()
		desired = Vector2(desired.x*-1, desired.y)
		desired = Vector2(desired.y, desired.x)
		if speed != 0:
			desired = desired * speed
		steer = (desired - velocity).normalized() * steer_force
	return steer

func fireWebShot():
	var shotVector = seek()
	var currentShot := WebShot.new_shot(175, shotVector, position)
	add_child(currentShot)
	currentShot.emit_signal("setOwner", owner)
	currentShot.emit_signal("PlaceWebNow")
	#currentShot.reparent(owner)
	#print(owner)

func hit() -> void:
	Health -= 1
	

#If the player is in the detect box the spider will chase them
func _on_detect_box_body_entered(body):
	if body.is_in_group("Player"):
		target = body

func _on_detect_box_body_exited(body):
	if body.is_in_group("Player"):
		target = null


#These will fire a webshot every 3 seconds, IF the player is within range, otherwise it will check again in another
#3 seconds
func _on_shot_cooldown_timeout() -> void:
	if target:
		storeSpeed = speed
		speed = 0
		ShotFiring.start()
	else:
		ShotCooldown.start()

func _on_shot_firing_timeout() -> void:
	await fireWebShot()
	speed = storeSpeed
	ShotCooldown.start()
