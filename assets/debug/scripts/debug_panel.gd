extends Control

signal refresh

func _ready():
	set_open(false)

func _input(event):
	if event.is_action_pressed("toggle_debug"):
		set_open(not is_open())

func is_open() -> bool:
	return visible

func set_open(open: bool):
	visible = open
	if visible:
		refresh.emit()