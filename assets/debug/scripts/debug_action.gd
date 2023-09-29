class_name DebugAction extends Control

@export var action: BuildingAction
@onready var name_label: Label = $Container/Name
@onready var description_label: Label = $Container/Description
@onready var assign_button: Button = $Container/Assign

var button_group: ButtonGroup:
	set(group):
		if button_group:
			button_group.changed.disconnect(on_roll_changed)
		group.changed.connect(on_roll_changed)
		button_group = group

func _ready():
	name_label.text = action.title
	description_label.text = action.description
	assign_button.text = str(action.remaining_points)
	assign_button.pressed.connect(assign_roll)

func on_roll_changed(selected_roll: Button):
	print (selected_roll)
	assign_button.disabled = not action.valid_roll(int(selected_roll.text))

func assign_roll():
	var selected_roll = button_group.get_pressed_button()
	if not selected_roll:
		return
	action.assign_roll(int(selected_roll.text))
	selected_roll.queue_free()
	assign_button.text = str(action.remaining_points)
