class_name DebugBuilding extends Control

@onready var building_title: Label = $Container/BuildingTitle
@onready var assigned_units: DebugUnitsInput = $Container/Units
@onready var roll_button: Button = $Container/RollButton
@onready var dice_container = $Container/DiceContainer
@onready var action_container = $Container/ActionsContainer
@onready var dice_button = preload("res://assets/debug/scenes/debug_dice_button.tscn")
@onready var debug_action = preload("res://assets/debug/scenes/debug_action.tscn")
var button_group: ButtonGroup = ButtonGroup.new()
var building: Building

func _ready():
	# This needs to happen after building setup
	await building.ready
	building_title.text = building.title
	setup_actions()

	roll_button.pressed.connect(roll_assigned)
	button_group.allow_unpress = true
	for action in action_container.get_children():
		action.button_group = button_group
	if not GameManager.is_node_ready(): return
	GameManager.new_turn.connect(on_new_turn)

func setup_actions():
	if not is_node_ready(): return
	Utils.delete_children(action_container)
	for action in building.actions:
		var instance = debug_action.instantiate()
		action_container.add_child(instance)
		instance.action = action

func roll_assigned():
	roll_button.visible = false
	assigned_units.editable = false
	var rolls = Utils.roll_dice(assigned_units.get_units())
	for roll in rolls:
		var button: Button = dice_button.instantiate()
		button.button_group = button_group
		dice_container.add_child(button)
		button.roll = roll.roll
		button.tier = roll.tier

func on_new_turn():
	roll_button.visible = true
	assigned_units.editable = true
	assigned_units.reset_units()
	Utils.delete_children(dice_container)
