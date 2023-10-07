extends Control

@onready var next_turn_button: Button = $Panels/NextTurn
@onready var reset_game_button: Button = $Panels/ResetGame
@onready var version_label: Label = $VersionLabel

signal refresh

func _ready():
	for child in get_children():
		if child is DebugSection:
			refresh.connect(child.on_refresh)
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
