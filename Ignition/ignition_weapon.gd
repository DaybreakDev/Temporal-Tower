extends Node2D

@export var ignition_bomb_scene: PackedScene
@export var bomb_distance := 128.0
@export var bomb_detonation_time := 1.5

@onready var attack_rate_timer: Timer = $AttackRateTimer
@onready var ignition_bomb_spawn_point: Node2D = $IgnitionBombSpawnPoint

var can_launch: bool = true


func _ready() -> void:
	attack_rate_timer.timeout.connect(on_attack_rate_timer_timeout)


func _process(delta: float) -> void:
	look_at(get_global_mouse_position())


#Function to launch a bomb
func launch_bomb() -> void:
	#Instantiate the bomb
	var bomb_layer = get_tree().get_first_node_in_group("bomb_layer") as Node2D
	var ignition_bomb_instance = ignition_bomb_scene.instantiate() as Node2D
	bomb_layer.add_child(ignition_bomb_instance)
	
	#Set the bombs position based on spawn point
	ignition_bomb_instance.global_position = ignition_bomb_spawn_point.global_position
	
	#Call launch method
	ignition_bomb_instance.launch(bomb_distance, bomb_detonation_time)
	
	#Begin attack rate timer
	attack_rate_timer.start()


func on_attack_rate_timer_timeout() -> void:
	launch_bomb()
