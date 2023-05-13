extends Node3D


var orig_scale: Vector3

@onready var mesh = $StaticBody3D

func _ready():
	mesh.mouse_entered.connect(grow)
	mesh.mouse_exited.connect(shrink)
	orig_scale = scale

func grow():
	scale *= 1.1

func shrink():
	scale = orig_scale
