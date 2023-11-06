extends Node3D

signal roll_completed(value: int)

const d4 = preload("res://assets/dice/scenes/physics_die_d4.tscn")
const d6 = preload("res://assets/dice/scenes/physics_die_d6.tscn")
const dice_types = [d4, d6]

func spawn_die():
	var dice = dice_types[randi_range(0, dice_types.size() - 1)].instantiate()
	dice.roll_completed.connect(on_roll_completed)
	dice.rotation_degrees.x = randi_range(0, 360)
	dice.rotation_degrees.y = randi_range(0, 360)
	dice.rotation_degrees.z = randi_range(0, 360)
	add_child(dice)

func on_roll_completed(die: PhysicsDie, value: int):
	die.roll_completed.disconnect(on_roll_completed)
	roll_completed.emit(value)

func _ready():
	var on_completed = func(value: int):
		Utils.log_info("Dice", "rolled ", value)
		Savegame.example.time = Time.get_ticks_msec()
		Savegame.example.value = value
		Savegame.save_file()
	roll_completed.connect(on_completed)

func _unhandled_input(event):
	if event.is_action_released("ui_accept"):
		spawn_die()
		get_viewport().set_input_as_handled()
