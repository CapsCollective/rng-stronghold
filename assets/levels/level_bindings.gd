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

func _unhandled_input(event):
	if event.is_action_released("rmb_down"):
		Utils.log_info("Selection", "deselected building")
		game_cam.reset_position()
		get_viewport().set_input_as_handled()
	elif event.is_action_released("ui_accept"):
		dice_spawner.spawn_die()
		get_viewport().set_input_as_handled()

func on_building_selected(building, pos):
	Utils.log_info("Selection", "selected ", building.name)
	game_cam.move_to_position(pos)

func on_roll_completed(value: int):
	Utils.log_info("Dice", "rolled ", value)
	
	Savegame.example.time = Time.get_ticks_msec()
	Savegame.example.value = value
	Savegame.save_file()
