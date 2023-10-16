class_name DebugBuilding extends Control

const debug_dice_button_scene = preload("res://assets/debug/scenes/debug_dice_button.tscn")
const debug_action_scene = preload("res://assets/debug/scenes/debug_action.tscn")

var building: Building

@onready var building_title: Label = $Container/BuildingTitle
@onready var assigned_units: DebugUnitsInput = $Container/Units
@onready var roll_button: Button = $Container/RollButton
@onready var dice_container = $Container/DiceContainer
@onready var action_container = $Container/ActionsContainer
@onready var button_group: ButtonGroup = ButtonGroup.new()

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
	Utils.queue_free_children(action_container)
	for action in building.actions:
		var instance = debug_action_scene.instantiate()
		action_container.add_child(instance)
		instance.action = action

func roll_assigned():
	roll_button.visible = false
	assigned_units.editable = false
	var rolls = Utils.roll_dice(assigned_units.get_units())
	for roll in rolls:
		var button: Button = debug_dice_button_scene.instantiate()
		button.button_group = button_group
		dice_container.add_child(button)
		button.roll = roll.roll
		button.tier = roll.tier

func on_new_turn():
	roll_button.visible = true
	assigned_units.editable = true
	assigned_units.reset_units()
	Utils.queue_free_children(dice_container)
