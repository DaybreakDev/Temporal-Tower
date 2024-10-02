extends Node2D

@export var explosion_scene: PackedScene
@export var travel_distance := 64.0
@export var travel_time := 3.0
@export var min_arc_height := 50.0
@export var max_arc_height := 70.0
@export var time_curve: Curve
@export var y_curve: Curve
@export var scale_curve: Curve

@onready var bomb_timer: Timer = $BombTimer
@onready var visuals: Node2D = $Visuals
@onready var bomb_sprite: Sprite2D = $Visuals/BombSprite

var time_passed := 0.0
var starting_position: Vector2
var destination_position: Vector2
var arc_height := 0.0


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	if time_passed > travel_time:
		#Blow up here then get rid of it
		var explosion_instance = explosion_scene.instantiate() as Node2D
		var bomb_layer = get_tree().get_first_node_in_group("bomb_layer") as Node2D
		bomb_layer.add_child(explosion_instance)
		explosion_instance.global_position = self.global_position
		queue_free()
		return
	
	var elapsed_time = time_passed / travel_time #Elapsed time from 0 -> 1
	time_passed += delta #Increase time
	
	#Lerp the position based on starting and destination positions
	global_position = lerp(starting_position, destination_position, time_curve.sample_baked(elapsed_time))
	
	#Arc the bomb sprite and scale it for effect
	bomb_sprite.global_position = lerp(starting_position, destination_position, time_curve.sample_baked(elapsed_time))
	bomb_sprite.global_position.y -= y_curve.sample_baked(elapsed_time) * arc_height
	bomb_sprite.global_scale = Vector2.ONE * scale_curve.sample_baked(elapsed_time)


#Call method when creating bomb
func launch(launch_distance: float, detonation_time: float) -> void:
	#Set starting position
	starting_position = global_position
	
	#Find destination position based on launch distance
	destination_position = starting_position + Vector2(launch_distance * \
		ceil(global_position.direction_to(get_global_mouse_position()).x),\
		launch_distance * ceil(global_position.direction_to(get_global_mouse_position()).y))
	
	#set travel distance and travel time
	travel_distance = launch_distance
	travel_time = detonation_time
	
	#set arc height based on min and max height
	arc_height = randf_range(min_arc_height, max_arc_height)
