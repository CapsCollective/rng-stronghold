@tool
extends BuildingAction

const WHEAT_INPUT = 2
const FLOUR_OUTPUT = 3

func valid_roll(roll: int):
	return GameManager.has_resource("wheat", WHEAT_INPUT)

func complete():
	GameManager.change_resource("wheat", -WHEAT_INPUT)
	GameManager.change_resource("flour", FLOUR_OUTPUT)
	remaining_points = required_points
