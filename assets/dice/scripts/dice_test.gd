extends Node3D

const d4 = preload("res://assets/dice/scenes/physics_die_d4.tscn")
const d6 = preload("res://assets/dice/scenes/physics_die_d6.tscn")
const dice_types = [d4, d6]

func _ready():
	pass

func _input(event):
	if event.is_action_released("ui_accept"):
		var dice = dice_types[randi_range(0, dice_types.size() - 1)].instantiate()
		dice.roll_completed.connect(on_roll_completed)
		add_child(dice)
		dice.position = Vector3(0, 10, 0)
		dice.rotation_degrees.x = 20
		dice.rotation_degrees.y = 20
		dice.rotation_degrees.z = 20

func on_roll_completed(die: PhysicsDie, value: int):
	die.roll_completed.disconnect(on_roll_completed)
	print(value)
