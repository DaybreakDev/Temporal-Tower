extends CharacterBody2D

@export var hp = 3
@export var hasPower: bool = false
@export var powername: int = 0
@export var droprate = 20

func _physics_process(delta: float) -> void:
	
	
	move_and_slide()
func hit(damage):
	hp = hp - damage
	
	if hp <= 0:
		die()

func die():
	if hasPower:
		givepower()
		
func givepower():
	if randi_range(0,droprate) == droprate:
		Global.powers |= powername
		
	
