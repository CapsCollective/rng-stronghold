extends Node3D

@export var buildings: Array[NodePath] = []

@onready var game_cam = $GameCamera

func _ready():
	for building in buildings:
		get_node(building).selected.connect(on_building_selected)

func _input(event):
	if event.is_action_released("rmb_down"):
		print("Deselected")
		game_cam.reset_position()

func on_building_selected(building_name, pos):
	print("Selected: ", building_name)
	game_cam.move_to_position(pos)
