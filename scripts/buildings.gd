extends Node2D

onready var camera = $"../Camera2D"

func building_clicked(building):
	camera.zoom = Vector2(0.5, 0.5)
	camera.position = building.global_position

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		if Input.is_action_just_pressed("rmb"):
			camera.zoom = Vector2(1, 1)
			camera.global_position = Vector2(get_viewport().size.x/2, get_viewport().size.y/2)
			print(camera.global_position)
