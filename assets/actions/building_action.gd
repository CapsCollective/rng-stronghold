class_name BuildingAction

signal completed
signal assigned(roll: int)
signal action_updated

var title: String:
	set(val):
		title = val
		action_updated.emit()

var description: Array:
	set(val):
		description = val
		action_updated.emit()

var required_points: int:
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

func _init():
	setup_details()
	remaining_points = required_points
	if GameManager.is_node_ready():
		GameManager.new_turn.connect(on_new_turn)

func setup_details():
	pass

func assign_roll(roll: int):
	Utils.log_info("Actions", "Assigning ", roll, " to ", title)
	if not is_valid_roll(roll): 
		Utils.push_warn("Actions", "Roll ", roll, "is not valid for ", title)
		return
	remaining_points -= roll
	if remaining_points <= 0:
		complete()
		completed.emit()
	assigned.emit(roll)

func on_new_turn():
	remaining_points = required_points

func is_valid_roll(_roll: int) -> bool:
	return true

func complete():
	pass
