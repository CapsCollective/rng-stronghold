extends Control

@onready var assigned_units: DebugUnitsInput = $Units
@onready var roll_button: Button = $RollButton
@onready var dice_container = $DiceContainer
@onready var action_container = $ActionsContainer
@onready var dice_button = preload("res://assets/debug/scenes/debug_dice_button.tscn")
var button_group: ButtonGroup = ButtonGroup.new()

func _ready():
	roll_button.pressed.connect(roll_assigned)
	button_group.allow_unpress = true
	for action in action_container.get_children():
		action.button_group = button_group

func roll_assigned():
	var rolls = Utils.roll_dice(assigned_units.get_units())
	assigned_units.reset_units()
	for roll in rolls:
		var button: Button = dice_button.instantiate()
		dice_container.add_child(button)
		button.text = str(roll.roll)
		button.button_group = button_group
