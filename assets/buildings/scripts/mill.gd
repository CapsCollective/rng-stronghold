extends Building

func _ready():
	actions = [
		FlourAction.new(),
		BreadAction.new()
	]
	super._ready()
