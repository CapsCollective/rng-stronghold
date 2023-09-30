@tool
class_name DebugAction extends Control

@onready var name_label: Label = $Container/Name
@onready var description_label: Label = $Container/Description
@onready var assign_button: Button = $Container/Assign

@export var action: BuildingAction:
	set(val):
		if action: action.action_updated.disconnect(refresh)
		action = val
		if action: 
			action.register()
			action.action_updated.connect(refresh)
		refresh()

var button_group: ButtonGroup:
	set(group):
		if button_group:
			button_group.pressed.disconnect(on_roll_changed)
		button_group = group
		button_group.pressed.connect(on_roll_changed)

func _ready():
	assign_button.pressed.connect(assign_roll)

func refresh():
	if not action or not is_node_ready(): return
	name_label.text = action.title
	description_label.text = action.description
	assign_button.text = str(action.remaining_points)

func on_roll_changed(pressed: Button):
	print("Roll Changed", button_group.get_pressed_button())
	var selected_roll = button_group.get_pressed_button()
	assign_button.disabled = (
		not selected_roll or 
		selected_roll.used or
		not action.valid_roll(selected_roll.roll))

func assign_roll():
	var selected_roll: DebugDiceButton = button_group.get_pressed_button()
	if not selected_roll:
		return
	action.assign_roll(selected_roll.roll)
	selected_roll.used = true
	selected_roll.queue_free()
	print("Button Deleted")
	button_group.pressed.emit(selected_roll) # Trigger validation refresh
	assign_button.text = str(action.remaining_points)
