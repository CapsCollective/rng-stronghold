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
