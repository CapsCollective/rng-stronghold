extends Node2D

onready var camera = $"../Camera2D"

var zoomed = false

func building_clicked(building):
	if not zoomed:
		$"../HUDCanvas/BuildingInterface".visible = true
		$"../HUDCanvas/BuildingInterface".populate(building.res_id)
		camera.zoom = Vector2(0.5, 0.5)
		camera.position = building.global_position
		zoomed = true

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.is_action_pressed("rmb"):
			close_building()
	elif event.is_action_pressed("ui_cancel"):
		close_building()

func close_building():
	camera.zoom = Vector2(1, 1)
	camera.position = Vector2(get_viewport().size.x/2, get_viewport().size.y/2)
	zoomed = false
	$"../HUDCanvas/BuildingInterface".visible = false
