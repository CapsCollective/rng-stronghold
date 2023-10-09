extends Building

func _ready():
	actions = [
		WaterAction.new(),
	]
	super._ready()
