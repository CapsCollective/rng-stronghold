extends Camera3D

@export var move_time: float = 0.5
@export var buildings: Array[NodePath] = []

var orig_pos: Vector3

func _input(event):
	if event.is_action_released("rmb_down"):
		print("Deselected")
		move_to_position(orig_pos)

func _ready():
	orig_pos = position
	for building in buildings:
		get_node(building).selected.connect(on_building_selected)

func on_building_selected(building_name, pos):
	print("Selected: ", building_name)
	move_to_position(pos)

func move_to_position(new_pos: Vector3):
	create_tween().tween_property(self, "position", new_pos, move_time)
