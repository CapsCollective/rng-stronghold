class_name FlourAction extends BuildingAction

const INPUT_RESOURCE = "wheat"
const INPUT_AMOUNT = 2
const OUTPUT_RESOURCE = "flour"
const OUTPUT_AMOUNT = 6
const REQUIRED_POINTS = 4

func setup_details():
	title = "Mill Flour"
	description = [
		"Requires %s %s" % [INPUT_AMOUNT, INPUT_RESOURCE],
		"Generates %s %s" % [OUTPUT_AMOUNT, OUTPUT_RESOURCE],
	]
	required_points = REQUIRED_POINTS

func is_valid_roll(_roll: int):
	return GameManager.has_resource(INPUT_RESOURCE, INPUT_AMOUNT)

func complete():
	GameManager.change_resource(INPUT_RESOURCE, -INPUT_AMOUNT)
	GameManager.change_resource(OUTPUT_RESOURCE, OUTPUT_AMOUNT)
	remaining_points = required_points # Repeatable Action
