extends Node2D

onready var camera = $"../Camera2D"

var zoomed = false

func building_clicked(building):
	if not zoomed:
		camera.zoom = Vector2(0.5, 0.5)
		camera.position = building.global_position
		zoomed = true

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		if Input.is_action_pressed("rmb"):
			camera.zoom = Vector2(1, 1)
			camera.position = Vector2(get_viewport().size.x/2, get_viewport().size.y/2)
			zoomed = false
