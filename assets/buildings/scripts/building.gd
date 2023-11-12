class_name Building extends Node3D

signal selected(building: Building)
signal deselected(building: Building)

signal die_selected(die: ResultDie)
signal die_deselected(die: ResultDie)

const action_group_display_scene = preload("res://assets/actions/scenes/action_group_display.tscn")

@export var cam_zoom: Node3D
@export var drag_plane_area: DragPlaneArea
@export var dice_spawner: DiceSpawner

var orig_scale: Vector3
var mouse_over: bool = false
var building_hovered: bool = false
var building_selected: bool = false

var action_group_display: Control

var selected_die: ResultDie:
	set(die):
		if die:
			selected_die = die
			die_selected.emit(die)
			Utils.log_info("Dice", "Selected die value: ", die.value)
		else:
			var deselected_die = selected_die
			selected_die = die
			Utils.log_info("Dice", "Deselected die value: ", deselected_die.value)
			die_deselected.emit(deselected_die)

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

func on_selected():
	building_selected = true
	set_plane_disabled(false)
	shrink()
	spawn_action_group_display()
	selected.emit(self)

func on_deselected():
	building_selected = false
	set_plane_disabled(true)
	deselected.emit(self)
	despawn_action_group_display()

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

func get_action_group() -> ActionGroup:
	var group = Utils.get_all_nodes_with_script(self, ActionGroup)
	if group.size() < 1:
		Utils.log_warn("Building", "Found no action groups for building ", name)
	if group.size() > 1:
		Utils.log_warn("Building", "Found more than one action group for building ", name)
	return group[0] if group.size() > 0 else null

func spawn_action_group_display():
	action_group_display = action_group_display_scene.instantiate()
	add_child(action_group_display)
	action_group_display.initialise(self)

func despawn_action_group_display():
	if action_group_display:
		action_group_display.deinitialise(self)
		action_group_display.queue_free()
