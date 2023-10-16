extends Control

signal refresh

const debug_building_scene = preload("res://assets/debug/scenes/debug_building.tscn")
const debug_combat_scene = preload("res://assets/debug/scenes/debug_combat.tscn")

@export var buildings: Array[Building]
@export var barriers: Array[Barrier]

@onready var next_turn_button: Button = $Panels/NextTurn
@onready var reset_game_button: Button = $Panels/ResetGame
@onready var version_label: Label = $VersionLabel
@onready var building_container: TabContainer = $Panels/BuildingsDebugPanel

func _ready():
	for child in get_children():
		if child is DebugSection:
			refresh.connect(child.on_refresh)
	for building in buildings:
		var debug_building: DebugBuilding = debug_building_scene.instantiate()
		debug_building.building = building
		debug_building.name = building.title
		building_container.add_child(debug_building)
	for barrier in barriers:
		var debug_combat: DebugCombat = debug_combat_scene.instantiate()
		debug_combat.barrier = barrier
		debug_combat.name = barrier.title
		building_container.add_child(debug_combat)
	
	version_label.text = "v" + Utils.get_version()
	set_open(false)
	next_turn_button.pressed.connect(GameManager.next_turn)
	reset_game_button.pressed.connect(GameManager.reset_game)

func _shortcut_input(event):
	if event.is_action_pressed("toggle_debug"):
		set_open(not is_open())
		get_viewport().set_input_as_handled()

func is_open() -> bool:
	return visible

func set_open(open: bool):
	visible = open
	if visible:
		refresh.emit()
