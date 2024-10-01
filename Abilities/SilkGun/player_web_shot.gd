extends WebShot

class_name PlayerWebShot

const newPWeb: PackedScene = preload("res://Abilities/SilkGun/PlayerWebShot.tscn")

static func newp_shot(newspeed := 175, newfiredVector := Vector2.ZERO, newPosition := Vector2.ZERO) -> PlayerWebShot:
	var newWebShot: PlayerWebShot = newPWeb.instantiate()
	newWebShot.speed = newspeed
	newWebShot.firedVector = newfiredVector
	newWebShot.position = newPosition
	return newWebShot

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		body.Webbed()
		queue_free()
	elif body.is_in_group("Player"):
		pass
	else:
		queue_free()
