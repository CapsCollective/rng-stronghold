@tool
extends BuildingAction

const WATER_OUTPUT = 5

func complete():
	GameManager.change_resource("water", WATER_OUTPUT)
	remaining_points = required_points
