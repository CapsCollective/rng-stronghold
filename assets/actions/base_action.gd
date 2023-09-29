class_name BuildingAction extends Node

@export var title: String
@export var description: String
@export var required_points: int
var remaining_points: int = 0

signal completed
signal assigned(roll: int)

func _ready():
	remaining_points = required_points
	GameManager.new_turn.connect(on_new_turn)

func assign_roll(roll: int):
	if !valid_roll(roll): 
		push_warning("Actions: Roll ", roll, "is not valid for ", title)
		return
		
	remaining_points -= roll
	if remaining_points <= 0:
		complete()
		completed.emit()
	assigned.emit(roll)

# Overrides

func on_new_turn():
	remaining_points = required_points

func valid_roll(roll: int):
	return true

func complete():
	pass
