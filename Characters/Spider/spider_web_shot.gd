class_name WebShot

extends Area2D

const newWeb: PackedScene = preload("res://Characters/Spider/SpiderWebShot.tscn")

signal setOwner(newOwner:Node2D)
signal PlaceWebNow()

var speed :int
var firedVector : Vector2
var velocity : Vector2
var PassableOwner : Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

static func new_shot(newspeed := 175, newfiredVector := Vector2.ZERO, newPosition := Vector2.ZERO) -> WebShot:
	var newWebShot: WebShot = newWeb.instantiate()
	newWebShot.speed = newspeed
	newWebShot.firedVector = newfiredVector
	newWebShot.position = newPosition
	return newWebShot

func _physics_process(delta):
	velocity = (firedVector * speed).limit_length(speed)
	position += velocity * delta

func PlaceWeb():
	var newPlacedWeb := PlacedWeb.new_placedWeb(global_position)
	newPlacedWeb.emit_signal("setOwner", PassableOwner, self)
	#get_owner().add_child(newPlacedWeb)
	#add_child.call_deferred(newPlacedWeb)
	#print("NewPW Owner:",newPlacedWeb.get_owner())
	#print("ShotWebOwnder",owner)
	#Anthony Berlanga - I think these lines of code means that when the spider dies the webs will disappear,
	#Fix if so

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.set_status("Webbed")
		queue_free()
	if body.is_in_group("Enemy"):
		pass
	else:
		queue_free()

func _on_life_timer_timeout() -> void:
	queue_free()



func _on_set_owner(newOwner: Node2D) -> void:
	self.set_owner(newOwner)
	self.reparent(newOwner)
	PassableOwner = newOwner

func _on_place_web_now():
	PlaceWeb()
