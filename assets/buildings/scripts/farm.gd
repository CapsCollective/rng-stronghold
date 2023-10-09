extends Building

func _ready():
	actions = [
		FarmPlotAction.new(0),
		FarmPlotAction.new(1),
		FarmPlotAction.new(2),
		FarmPlotAction.new(3),
	]
	super._ready()
