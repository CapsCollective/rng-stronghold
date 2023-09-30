extends Node3D

@export var buildings: Array[NodePath] = []
@export var dice_spawner: Node3D
@export var game_cam: Camera3D

func _ready():
	for building in buildings:
		get_node(building).selected.connect(on_building_selected)
	dice_spawner.roll_completed.connect(on_roll_completed)
	
	var example_dt = load("res://addons/datatable/example/example1_dt.tres")
	for row in example_dt:
		print(row)
	
	var player_row: ExampleRow1 = example_dt.get_row("player")
	print(player_row.move_speed)
	var s = ClassDB.instantiate(player_row.debug_shape)
	print(s)
	s.queue_free()

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
	
	Savegame.example.time = Time.get_ticks_msec()
	Savegame.example.value = value
	Savegame.save_file()
