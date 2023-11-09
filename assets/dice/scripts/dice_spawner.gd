class_name DiceSpawner extends Node3D

signal roll_completed(value: int)

const roll_d4_scene = preload("res://assets/dice/scenes/roll_die_d4.tscn")
const result_d4_scene = preload("res://assets/dice/scenes/result_die_d4.tscn")
const roll_d6_scene = preload("res://assets/dice/scenes/roll_die_d6.tscn")
const result_d6_scene = preload("res://assets/dice/scenes/result_die_d6.tscn")

const dice_types = [4, 6]
const roll_dice_types = {4: roll_d4_scene, 6: roll_d6_scene}
const result_dice_types = {4: result_d4_scene, 6: result_d6_scene}

func spawn_die():
	var die_type = dice_types[randi_range(0, dice_types.size() - 1)]
	var die = roll_dice_types[die_type].instantiate()
	die.roll_completed.connect(on_roll_completed)
	die.rotation_degrees.x = randi_range(0, 360)
	die.rotation_degrees.y = randi_range(0, 360)
	die.rotation_degrees.z = randi_range(0, 360)
	add_child(die)

func on_roll_completed(die: RollDie, value: int):
	die.roll_completed.disconnect(on_roll_completed)
	var result_die = result_dice_types[die.max_value].instantiate()
	add_child(result_die)
	result_die.position = die.position
	result_die.rotation = die.rotation
	result_die.set_resting_position()
	die.queue_free()
	roll_completed.emit(value)

func _ready():
	var on_completed = func(value: int):
		Utils.log_info("Dice", "Rolled value ", value)
		Savegame.example.time = Time.get_ticks_msec()
		Savegame.example.value = value
		Savegame.save_file()
	roll_completed.connect(on_completed)
