class_name RollDie extends RigidBody3D

signal roll_completed(die: RollDie, value: int)

@export var max_value: int

@onready var mesh: MeshInstance3D = $MeshInstance3D

func _ready():
	initiate_roll()

func initiate_roll():
	sleeping_state_changed.connect(end_roll)

func end_roll():
	check_result()

func check_result():
	pass

func is_up(vector: Vector3):
	return (vector - Vector3.UP).length() < 0.1
