extends RigidBody3D
class_name PhysicsDie

signal roll_completed(die: PhysicsDie, value: int)

@export var initial_material: Material
@export var finished_material: Material
@onready var mesh: MeshInstance3D = $MeshInstance3D

func _ready():
	initiate_roll()

func initiate_roll():
	sleeping_state_changed.connect(end_roll)
	mesh.set_surface_override_material(0, initial_material)

func end_roll():
	mesh.set_surface_override_material(0, finished_material)
	check_result()

func check_result():
	pass

func is_up(vector: Vector3):
	return (vector - Vector3.UP).length() < 0.1
