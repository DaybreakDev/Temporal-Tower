extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func start():
	monitoring = true
	monitorable = true
	$Timer.start()
	

func _on_timer_timeout() -> void:
	hitscan()
func hitscan():
	print(monitoring)
	if has_overlapping_bodies():
		print("Something Found")
	for i in get_overlapping_bodies():
		print(i)
		if i.is_in_group("Enemy"):
			print("FlashHit")
	monitoring = false
	monitorable = false
