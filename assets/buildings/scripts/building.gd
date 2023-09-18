extends Node3D

signal selected(building_name: String, pos: Vector3)

@export var cam_zoom_pos: Node

var orig_scale: Vector3
var is_hovered: bool = false

@onready var mesh = $StaticBody3D

func _input(event):
	if event.is_action_released("lmb_down") and is_hovered:
		if not cam_zoom_pos:
			push_warning("No camera zoom position set for building ", name)
			return
		selected.emit(name, cam_zoom_pos.global_position)

func _ready():
	mesh.mouse_entered.connect(grow)
	mesh.mouse_exited.connect(shrink)
	orig_scale = scale

func grow():
	scale *= 1.1
	is_hovered = true

func shrink():
	scale = orig_scale
	is_hovered = false
