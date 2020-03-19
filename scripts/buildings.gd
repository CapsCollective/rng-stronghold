extends Node2D

onready var camera = MainCam

func building_clicked(building):
	if not camera.zoomed:
		$"../HUDCanvas/BuildingInterface".visible = true
		$"../HUDCanvas/BuildingInterface".populate(building.res_id)
		camera.zoom_to(building.global_position, 0.5)

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.is_action_pressed("rmb"):
			close_building()
	elif event.is_action_pressed("ui_cancel"):
		close_building()

func close_building():
	camera.reset()
	$"../HUDCanvas/BuildingInterface".visible = false

func display_battlefield():
	var display_num_enemies = $"../".enemies
	for child in $Battlefield.get_children():
		if child.is_in_group("enemy_sprite"):
			child.visible = display_num_enemies > 0
			display_num_enemies -= 1
	$Battlefield/ColorRect.visible = display_num_enemies > 0
	$Battlefield/ColorRect/Label.text = "+" + str(display_num_enemies)
	
	var display_num_soldiers = $"../".committed_dice
	for child in $Wall.get_children():
		if child.is_in_group("soldier_sprite"):
			child.visible = display_num_soldiers > 0
			display_num_soldiers -= 1
	$Wall/ColorRect.visible = display_num_soldiers > 0
	$Wall/ColorRect/Label.text = "+" + str(display_num_soldiers)
