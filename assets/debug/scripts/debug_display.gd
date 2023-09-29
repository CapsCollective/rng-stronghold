extends Control

@onready var next_turn_button: Button = $Panels/NextTurn
@onready var reset_game_button: Button = $Panels/ResetGame

signal refresh

func _ready():
	for child in get_children():
		if child is DebugSection:
			refresh.connect(child.on_refresh)
	$VersionLabel.text = "v" + Utils.get_version()
	set_open(false)
	next_turn_button.pressed.connect(GameManager.next_turn)
	reset_game_button.pressed.connect(GameManager.reset_game)

func _input(event):
	if event.is_action_pressed("toggle_debug"):
		set_open(not is_open())

func is_open() -> bool:
	return visible

func set_open(open: bool):
	visible = open
	if visible:
		refresh.emit()
