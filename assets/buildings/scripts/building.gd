extends StaticBody3D

var orig_scale

func _ready():
	mouse_entered.connect(grow)
	mouse_exited.connect(shrink)
	orig_scale = scale

func grow():
	scale *= 1.1

func shrink():
	scale = orig_scale
