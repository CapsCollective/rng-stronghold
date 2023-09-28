class_name DebugAction extends Control

@onready var name_label: Label = $Name
@onready var remaining_label: Label = $Remaining
@onready var assign_button: Button = $Assign
var button_group: ButtonGroup
var action_name: String = "Collect Water"
var required_points: int = 4
var remaining_points: int = 0

func _ready():
	remaining_points = required_points
	name_label.text = action_name
	remaining_label.text = str(remaining_points)
	assign_button.pressed.connect(assign_roll)

func assign_roll():
	var selected_roll = button_group.get_pressed_button()
	if !selected_roll:
		return
		
	remaining_points -= int(selected_roll.text)
	selected_roll.queue_free()
	if remaining_points <= 0:
		complete()
	remaining_label.text = str(remaining_points)

func complete():
	GameManager.change_resource("water", 5)
	remaining_points = required_points
