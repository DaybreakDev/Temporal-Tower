extends CharacterBody2D



@export var speed = 140
@export var steer_force = 100
@export var Health = 3

var moveTarget : Node2D = null
var aimTarget : Node2D = null
var acceleration = Vector2.ZERO
var storeSpeed = 0
var SpiderOwner = owner
#Either do it with these or with signals from timers of different lengths that trigger shot cooldown then fire shot then back
var ShotCooldown : Timer
var ShotFiring : Timer
var AnimationPlayuh : AnimationPlayer
var firingDistance : bool = false
var canMove : bool = true

func _ready():
	#velocity = transform.x * speed
	velocity = Vector2.ZERO
	ShotCooldown = $ShotCooldown
	ShotFiring = $ShotFiring
	AnimationPlayuh = $AnimationPlayer
	SpiderOwner = owner
	

func _physics_process(delta):
	
	if moveTarget && canMove:
		if position.distance_to(moveTarget.position) > 100:
			firingDistance = true
			acceleration = seek(moveTarget) * 10
			velocity += acceleration * delta
			velocity = velocity.limit_length(speed)
			move_and_slide()
		elif position.distance_to(moveTarget.position) < 75:
			firingDistance = false
			acceleration = seek(moveTarget) * Vector2(-1,-1) * 10
			velocity += acceleration * delta
			velocity = velocity.limit_length(speed)
			move_and_slide()
		else:
			firingDistance = true
			acceleration = orbit() * 10
			velocity += acceleration * delta
			velocity = velocity.limit_length(speed)
			move_and_slide()
	else:
		pass

func seek(Target : Node2D):
	var steer = Vector2.ZERO
	if Target :
		var desired = (Target.position - position).normalized()
		if speed != 0:
			desired = desired * speed
		steer = (desired - velocity).normalized() * steer_force
	return steer

func orbit():
	var steer = Vector2.ZERO
	if moveTarget :
		var desired = (moveTarget.position - position).normalized()
		desired = Vector2(desired.x*-1, desired.y)
		desired = Vector2(desired.y, desired.x)
		if speed != 0:
			desired = desired * speed
		steer = (desired - velocity).normalized() * steer_force
	return steer

func fireWebShot():
	var shotVector = null
	if moveTarget != null:
		shotVector = seek(moveTarget)
	elif moveTarget == null:
		shotVector = seek(aimTarget)
		aimTarget = null
		
	if shotVector != null:
		var currentShot := WebShot.new_shot(175, shotVector, position)
		add_child(currentShot)
		currentShot.emit_signal("setOwner", owner)
		currentShot.emit_signal("PlaceWebNow")
		#currentShot.reparent(owner)
	else:
		pass

func hit() -> void:
	Health -= 1
	AnimationPlayuh.play("hurt")
	

#All enemies should have Webbed() to allow player webs to stop them from moving
func Webbed():
	if canMove:
		canMove = false
		await get_tree().create_timer(4).timeout
		canMove = true
	else:
		pass

func set_speed(newSpeed : int)->void:
	speed = newSpeed

func get_speed() ->int :
	return speed


#If the player is in the detect box the spider will chase them
func _on_detect_box_body_entered(body):
	if body.is_in_group("Player"):
		moveTarget = body
		aimTarget = body

func _on_detect_box_body_exited(body):
	if body.is_in_group("Player"):
		moveTarget = null


#These will fire a webshot every 3 seconds, IF the player is within range, otherwise it will check again in another
#3 seconds
func _on_shot_cooldown_timeout() -> void:
	if moveTarget && firingDistance:
		storeSpeed = speed
		speed = 0
		ShotFiring.start()
	else:
		ShotCooldown.start()

func _on_shot_firing_timeout() -> void:
	await fireWebShot()
	speed = storeSpeed
	ShotCooldown.start()
