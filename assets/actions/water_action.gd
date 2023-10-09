class_name WaterAction extends BuildingAction

const OUTPUT_RESOURCE = "water"
const OUTPUT_AMOUNT = 8
const REQUIRED_POINTS = 4

func _init():
	title = "Colect Water"
	description = [
		"Generates %s %s" % [OUTPUT_AMOUNT, OUTPUT_RESOURCE],
	]
	required_points = REQUIRED_POINTS
	super._init()

func complete():
	GameManager.change_resource(OUTPUT_RESOURCE, OUTPUT_AMOUNT)
	remaining_points = required_points
