extends Node2D

onready var camera = $"../Camera2D"

func building_clicked(building):
	print(building.name)
	camera.zoom = Vector2(0.5, 0.5)
	camera.position = building.global_position

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		if Input.is_action_pressed("rmb"):
			camera.zoom = Vector2(1, 1)
			camera.position = Vector2(get_viewport().size.x/2, get_viewport().size.y/2)
