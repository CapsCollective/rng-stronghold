extends Area2D

func _ready():
	connect("mouse_entered", self, "highlight")
	connect("mouse_exited", self, "highlight")

func highlight():
	if $Sprite.material:
		var intensity = $Sprite.material.get_shader_param("intensity")
		if intensity and intensity > 0:
			$Sprite.material.set_shader_param("intensity", 0)
		else:
			$Sprite.material.set_shader_param("intensity", 200)

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			if Input.is_action_pressed("lmb"):
				get_parent().building_clicked(self)
