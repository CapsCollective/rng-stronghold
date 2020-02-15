extends Node2D

onready var camera = $"../Camera2D"
onready var resting_pos = camera.global_position

var camera_speed = 5
var zoomed = false
onready var target_zoom = Vector2(1, 1)
onready var target_position = resting_pos

func building_clicked(building):
	if not zoomed:
		$"../HUDCanvas/BuildingInterface".visible = true
		$"../HUDCanvas/BuildingInterface".populate(building.res_id)
		target_zoom = Vector2(0.5, 0.5)
		target_position = building.global_position
		zoomed = true

func _process(delta):
	if camera.zoom != target_zoom:
		camera.zoom = camera.zoom.linear_interpolate(target_zoom, delta*camera_speed)
	if camera.position != target_position:
		camera.position = camera.position.linear_interpolate(target_position, delta*camera_speed)

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.is_action_pressed("rmb"):
			close_building()
	elif event.is_action_pressed("ui_cancel"):
		close_building()

func close_building():
	target_zoom = Vector2(1, 1)
	target_position = resting_pos
	zoomed = false
	$"../HUDCanvas/BuildingInterface".visible = false

func display_battlefield():
	var display_num = $"../".enemies
	for child in $Battlefield.get_children():
		child.visible = child is Sprite and display_num > 0
		display_num -= 1
