extends Area2D

export (int) var res_id

func _ready():
	connect("mouse_entered", self, "highlight")
	connect("mouse_exited", self, "unhighlight")

func highlight():
	if not $"../".zoomed:
		scale = Vector2(1.03, 1.03)

func unhighlight():
	scale = Vector2(1, 1)

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			if Input.is_action_pressed("lmb"):
				get_parent().building_clicked(self)
