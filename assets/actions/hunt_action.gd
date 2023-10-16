class_name HuntAction extends BuildingAction

enum AnimalType {
	RABBIT = 0,
	FOX = 1,
	DEER = 2
}
var animal: AnimalType

const OUTPUT_RESOURCE = "food"

func get_title() -> String:
	return [
		"Hunt Rabbit",
		"Hunt Fox",
		"Hunt Deer"
	][animal]
	
func get_requires_points() -> int:
	return [3,5,8][animal]

func get_output_amount() -> int:
	return [3,6,10][animal]

func _init(_animal: AnimalType):
	animal = _animal
	super._init()

func setup_details():
	title = get_title()
	description = [
		"Must hit exact target",
		"Generates %s %s" % [get_output_amount(), OUTPUT_RESOURCE]
	]
	required_points = get_requires_points()

func is_valid_roll(roll: int):
	# Must hit exact target, so cannot assign dice that go over
	return roll <= remaining_points 

func complete():
	GameManager.change_resource(OUTPUT_RESOURCE, get_output_amount())
	remaining_points = required_points
