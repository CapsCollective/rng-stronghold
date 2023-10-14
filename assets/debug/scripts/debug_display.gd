extends Control

@onready var next_turn_button: Button = $Panels/NextTurn
@onready var reset_game_button: Button = $Panels/ResetGame
@onready var version_label: Label = $VersionLabel
@onready var building_container: TabContainer = $Panels/BuildingsDebugPanel
@onready var building_debug = preload("res://assets/debug/scenes/debug_building.tscn")
@onready var combat_debug = preload("res://assets/debug/scenes/debug_combat.tscn")
@export var buildings: Array[Building]
@export var barriers: Array[Barrier]

signal refresh

func _ready():
	for child in get_children():
		if child is DebugSection:
			refresh.connect(child.on_refresh)
	for building in buildings:
		var b: DebugBuilding = building_debug.instantiate()
		b.building = building
		b.name = building.title
		building_container.add_child(b)
	for barrier in barriers:
		var b: DebugCombat = combat_debug.instantiate()
		b.barrier = barrier
		b.name = barrier.title
		building_container.add_child(b)
	
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
