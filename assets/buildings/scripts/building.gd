class_name Building extends Node3D

signal selected(building: Building)
signal deselected(building: Building)

@export var cam_zoom: Node3D
@export var drag_plane_area: DragPlaneArea
@export var dice_spawner: DiceSpawner

var orig_scale: Vector3
var mouse_over: bool = false
var building_hovered: bool = false
var building_selected: bool = false

@onready var mesh = $StaticBody3D

func _ready():
	mesh.mouse_entered.connect(on_mouse_entered)
	mesh.mouse_exited.connect(on_mouse_exited)
	orig_scale = scale

func _unhandled_input(event):
	if event.is_action_released("lmb_down") and building_hovered:
		on_selected()
		get_viewport().set_input_as_handled()
	elif event.is_action_released("rmb_down") and building_selected:
		on_deselected()
		get_viewport().set_input_as_handled()
	elif event is InputEventMouseMotion and mouse_over and not building_hovered and not is_any_building_selected():
		grow()
		get_viewport().set_input_as_handled()
	elif event.is_action_released("ui_accept") and building_selected :
		if dice_spawner:
			dice_spawner.spawn_die()
		else:
			Utils.log_warn("Building", "No dice spawner defined for building ", name)
		get_viewport().set_input_as_handled()

func on_selected():
	building_selected = true
	set_plane_disabled(false)
	shrink()
	selected.emit(self)

func on_deselected():
	building_selected = false
	set_plane_disabled(true)
	deselected.emit(self)

func on_mouse_entered():
	mouse_over = true

func on_mouse_exited():
	mouse_over = false
	shrink()

func grow():
	scale *= 1.1
	building_hovered = true

func shrink():
	scale = orig_scale
	building_hovered = false

func set_plane_disabled(disabled: bool):
	if drag_plane_area:
		drag_plane_area.set_plane_disabled(disabled)
	else:
		Utils.log_warn("Building", "No drag plane defined for building ", name)

func is_any_building_selected() -> bool:
	return GameManager.current_scenario.selected_building != null
