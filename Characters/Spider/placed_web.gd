class_name PlacedWeb

extends Area2D

const my_scene: PackedScene = preload("res://Characters/Spider/placed_web.tscn")

signal setOwner(newOwner:Node2D, ownerWeb: Node2D)

var PlayerBody: Node2D
var PlayerSlowed : bool = false
var PlayerSpeed : float
var TileBodies = []
var FiredOwner

# AB- Due to rounding errors with multiplying and dividing 
var SlowRate : float = 40

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
	if PlayerSlowed:
		PlayerSlowed = false
		PlayerBody.set_speed(PlayerBody.get_speed()+SlowRate)
		for x in get_overlapping_areas():
			if x.is_in_group("PlacedWebsGroup"):
				for y in x.get_overlapping_bodies():
					if y.is_in_group("Player"):
						queue_free()
						return
		PlayerBody.set_touchingWeb(false)
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		PlayerBody = body
		PlayerSlowed = true
		body.set_touchingWeb(true)
		body.set_speed(body.get_speed()-SlowRate)
		#If I can't figure tile map layers out I'll just make collision layer 8 call fall on the player
		#and some enemies and a boolean will check if they can or can't fall - AB
	#if body is TileMapLayer:
	#	body.set_collision_enabled(false)
	#	var TouchedTile = body.local_to_map(body.get_global_position())
		
	#	print(body, body.is_collision_enabled())
	#	TileBodies.append(body)

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player") && PlayerSlowed:
		PlayerSlowed = false
		body.set_speed(body.get_speed()+SlowRate)
		for x in get_overlapping_areas():
			if x.is_in_group("PlacedWebsGroup"):
				for y in x.get_overlapping_bodies():
					if y.is_in_group("Player"):
						return
		body.set_touchingWeb(false)

func _on_set_owner(newOwner: Node2D, ownerWeb: Node2D) -> void:
	newOwner.add_child.call_deferred(self)
	FiredOwner = ownerWeb
	#set_owner(newOwner)
	#reparent(newOwner)

#PlaceNewWebDetection is a smaller radius than the normal one to make sure new placed webs
#overlap for the sake of being able to use the webs to bridge gaps.
func _on_place_new_web_detection_area_exited(area):
	if area == FiredOwner:
		area.emit_signal("PlaceWebNow")
