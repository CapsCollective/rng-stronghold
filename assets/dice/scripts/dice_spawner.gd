class_name DiceSpawner extends Node3D

signal roll_completed(value: int)

const dice_dt: Datatable = preload("res://assets/content/dice_dt.tres")

func spawn_die(tier: int):
	var die_row: DieRow = dice_dt.get_row(tier)
	if not die_row:
		Utils.log_warn("Dice", "No die row found for tier ", tier)
		return
	var roll_die = load(die_row.roll_die_path).instantiate()
	roll_die.roll_completed.connect(on_roll_completed)
	roll_die.rotation_degrees.x = randi_range(0, 360)
	roll_die.rotation_degrees.y = randi_range(0, 360)
	roll_die.rotation_degrees.z = randi_range(0, 360)
	add_child(roll_die)

func on_roll_completed(die: RollDie, value: int):
	die.roll_completed.disconnect(on_roll_completed)
	var die_row: DieRow = dice_dt.get_row(die.max_value)
	if not die_row:
		Utils.log_warn("Dice", "No die row found for tier ", die.max_value)
		return
	var result_die = load(die_row.result_die_path).instantiate()
	add_child(result_die)
	result_die.initialise(die.position, die.rotation, value)
	die.queue_free()
	roll_completed.emit(value)

func _ready():
	var on_completed = func(value: int):
		Utils.log_info("Dice", "Rolled value ", value)
		Savegame.example.time = Time.get_ticks_msec()
		Savegame.example.value = value
		Savegame.save_file()
	roll_completed.connect(on_completed)
