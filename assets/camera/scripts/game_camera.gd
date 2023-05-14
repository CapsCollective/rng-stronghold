extends Camera3D

@export var move_time: float = 0.5

@onready var orig_pos: Vector3 = position

func reset_position(animate: bool = true):
	move_to_position(orig_pos, animate)

func move_to_position(new_pos: Vector3, animate: bool = true):
	if animate:
		create_tween().tween_property(self, "position", new_pos, move_time)
	else:
		position = new_pos
