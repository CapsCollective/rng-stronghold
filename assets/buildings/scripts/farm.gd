extends Building

func get_building_actions() -> Array[BuildingAction]:
	return [
		FarmPlotAction.new(0),
		FarmPlotAction.new(1),
		FarmPlotAction.new(2),
		FarmPlotAction.new(3),
	]
