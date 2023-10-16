extends Building

func get_building_actions() -> Array[BuildingAction]:
	return [
		WaterAction.new(),
	]
