extends Area2D

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		if Input.is_action_pressed("lmb"):
			get_parent().building_clicked(self)
