extends CharacterBody2D


@export var speed = 140
@export var steer_force = 100
@export var Health = 3


var moveTarget : Node2D = null
var acceleration = Vector2.ZERO
var storeSpeed = 0
#Either do it with these or with signals from timers of different lengths that trigger shot cooldown then fire shot then back
var AttackCooldown : Timer
var AttackWarmup : Timer
var AttackActive : Timer
var AnimationPlayuh : AnimationPlayer
var firingDistance : bool = false
var canMove : bool = true
var damageOnContact : bool = false

func _ready():
	#velocity = transform.x * speed
	velocity = Vector2.ZERO
	AttackCooldown = $AttackCooldown
	AttackWarmup = $AttackWarmup
	AttackActive = $AttackActive
	AnimationPlayuh = $AnimationPlayer
	

func _physics_process(delta):
	if damageOnContact:
		firingDistance = false
		acceleration = seek(moveTarget) * 10
		velocity += acceleration * delta
		velocity = velocity.limit_length(300)
		move_and_slide()
	elif moveTarget && canMove:
		if position.distance_to(moveTarget.position) > 60:
			firingDistance = false
			acceleration = seek(moveTarget) * 10
			velocity += acceleration * delta
			velocity = velocity.limit_length(speed)
			move_and_slide()
		elif position.distance_to(moveTarget.position) < 40:
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
		desired = Vector2(desired.x, desired.y*-1)
		desired = Vector2(desired.y, desired.x)
		if speed != 0:
			desired = desired * speed
		steer = (desired - velocity).normalized() * steer_force
	return steer

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

func _on_detect_box_body_exited(body):
	if body.is_in_group("Player"):
		moveTarget = null

#These will take a second to swing out, then be active for a half second, then recover in 1.5 seconds
func _on_attack_cooldown_timeout():
	AttackWarmup.start()
	print("CooldownTimeout")

func _on_attack_warmup_timeout():
	if firingDistance:
		damageOnContact = true
		AttackActive.start()
	else:
		AttackWarmup.start()
	print("WarmupTimeout")

func _on_attack_active_timeout():
	damageOnContact = false
	AttackCooldown.start()
	print("ActiveTimeout")
