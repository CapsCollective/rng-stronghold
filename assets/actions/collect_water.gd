extends BuildingAction

func complete():
	GameManager.change_resource("water", 5)
	remaining_points = required_points
