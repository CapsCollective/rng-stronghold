extends Node3D

@export var buildings: Array[NodePath] = []
@export var dice_spawner: Node3D
@export var game_cam: Camera3D

func _ready():
	PersistentDataSystem.load_file()
	for building in buildings:
		get_node(building).selected.connect(on_building_selected)
	dice_spawner.roll_completed.connect(on_roll_completed)

func _input(event):
	if event.is_action_released("rmb_down"):
		print("Deselected")
		game_cam.reset_position()
	elif event.is_action_released("ui_accept"):
		dice_spawner.spawn_die()

func on_building_selected(building_name, pos):
	print("Selected: ", building_name)
	game_cam.move_to_position(pos)

func on_roll_completed(value: int):
	print("Rolled: ", value)
	
	PersistentData.example.time = Time.get_ticks_msec()
	PersistentData.example.value = value
	PersistentDataSystem.save_file()
