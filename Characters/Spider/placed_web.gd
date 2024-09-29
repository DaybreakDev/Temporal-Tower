class_name PlacedWeb
extends Area2D

const my_scene: PackedScene = preload("res://Characters/Spider/placed_web.tscn")

signal setOwner(newOwner:Node2D)

var PlayerBody: Node2D
var PlayerSlowed : bool = false

var SlowRate : float = .75

static func new_placedWeb(newPosition := Vector2.ZERO) -> PlacedWeb:
	var newPlacedWeb: PlacedWeb = my_scene.instantiate()
	newPlacedWeb.position = newPosition
	return newPlacedWeb
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#Anthony Berlanga - PlayerSlowed is just here for safety and if we decide to include something that will somehow
#play around with this we can adjust it with that variable
func _on_timer_timeout() -> void:
	if PlayerBody && PlayerSlowed:
		PlayerBody.set_speed(PlayerBody.get_speed()/SlowRate)
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		PlayerBody = body
		body.set_speed(body.get_speed()*SlowRate)
		PlayerSlowed = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player") && PlayerSlowed:
		PlayerBody = null
		body.set_speed(body.get_speed()/SlowRate)
		PlayerSlowed = false

func _on_set_owner(newOwner: Node2D) -> void:
	self.set_owner(newOwner)
	self.reparent(newOwner)
	


func _on_area_exited(area: Area2D) -> void:
	area.emit_signal("PlaceWebNow")
