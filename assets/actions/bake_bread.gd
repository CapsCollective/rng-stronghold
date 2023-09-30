@tool
extends BuildingAction

const FLOUR_INPUT = 1
const FOOD_OUTPUT = 4

func valid_roll(roll: int):
	return GameManager.has_resource("flour", FLOUR_INPUT)

func complete():
	GameManager.change_resource("flour", -FLOUR_INPUT)
	GameManager.change_resource("food", FOOD_OUTPUT)
	remaining_points = required_points
