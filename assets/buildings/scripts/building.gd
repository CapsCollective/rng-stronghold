extends Node3D

signal selected(building_name: String, pos: Vector3)

@export var cam_zoom_pos: Node

var orig_scale: Vector3
var is_hovered: bool = false
var mouse_over: bool = false

@onready var mesh = $StaticBody3D

func _unhandled_input(event):
	if event.is_action_released("lmb_down") and is_hovered:
		if not cam_zoom_pos:
			push_warning("No camera zoom position set for building ", name)
			return
		selected.emit(name, cam_zoom_pos.global_position)
		get_viewport().set_input_as_handled()
	if event is InputEventMouseMotion and mouse_over and not is_hovered:
		grow()
		get_viewport().set_input_as_handled()

func _ready():
	mesh.mouse_entered.connect(on_mouse_entered)
	mesh.mouse_exited.connect(on_mouse_exited)
	orig_scale = scale

func on_mouse_entered():
	mouse_over = true

func on_mouse_exited():
	mouse_over = false
	shrink()

func grow():
	scale *= 1.1
	is_hovered = true

func shrink():
	scale = orig_scale
	is_hovered = false
