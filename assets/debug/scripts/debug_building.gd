@tool
class_name DebugBuilding extends Control

@onready var building_title: Label = $BuildingTitle
@onready var assigned_units: DebugUnitsInput = $Units
@onready var roll_button: Button = $RollButton
@onready var dice_container = $DiceContainer
@onready var action_container = $ActionsContainer
@onready var dice_button = preload("res://assets/debug/scenes/debug_dice_button.tscn")
@onready var debug_action = preload("res://assets/debug/scenes/debug_action.tscn")
var button_group: ButtonGroup = ButtonGroup.new()

@export var actions: Array[BuildingAction]
@export var title: String:
	set(val):
		title = val
		if building_title: building_title.text = title

func _ready():
	title = title
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
	for action in actions:
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
