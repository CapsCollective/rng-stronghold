class_name BuildingAction extends Resource

@export var title: String:
	set(val):
		title = val
		action_updated.emit()
@export var description: String:
	set(val):
		description = val
		action_updated.emit()
@export var required_points: int:
	set(val):
		required_points = val
		remaining_points = required_points
		action_updated.emit()

var remaining_points: int = 0:
	set(val):
		remaining_points = val
		action_updated.emit()

var is_complete: bool:
	set(val):
		is_complete = val
		action_updated.emit()

signal completed
signal assigned(roll: int)
signal action_updated

func register():
	remaining_points = required_points
	if GameManager.is_node_ready():
		GameManager.new_turn.connect(on_new_turn)

func assign_roll(roll: int):
	Utils.push_info("Actions", "Assigning ", roll, " to ", title)
	if not valid_roll(roll): 
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
