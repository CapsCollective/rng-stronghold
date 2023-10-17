class_name BreadAction extends DiceAction

const INPUT_RESOURCE = "flour"
const INPUT_AMOUNT = 1
const OUTPUT_RESOURCE = "food"
const OUTPUT_AMOUNT = 4
const REQUIRED_POINTS = 2

func setup_details():
	title = "Bake Bread"
	description = [
		"Requires %s %s" % [INPUT_AMOUNT, INPUT_RESOURCE],
		"Generates %s %s" % [OUTPUT_AMOUNT, OUTPUT_RESOURCE]
	]
	required_points = 2

func is_valid_roll(_roll: int):
	return GameManager.has_resource(INPUT_RESOURCE, INPUT_AMOUNT)

func complete():
	GameManager.change_resource(INPUT_RESOURCE, -INPUT_AMOUNT)
	GameManager.change_resource(OUTPUT_RESOURCE, OUTPUT_AMOUNT)
	remaining_points = required_points
