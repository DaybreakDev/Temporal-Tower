extends Ability

class_name SilkGun

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func fire(aimVector : Vector2, newPosition : Vector2, ownerNode : Node2D):
	var currentShot := PlayerWebShot.newp_shot(175, aimVector, newPosition)
	ownerNode.add_child(currentShot)
	currentShot.emit_signal("setOwner", ownerNode.get_owner())
	currentShot.emit_signal("PlaceWebNow")
