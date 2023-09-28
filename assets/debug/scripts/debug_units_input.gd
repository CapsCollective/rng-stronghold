extends Control

@onready var inputs = {
	4: $D4s,
	6: $D6s,
	8: $D8s
}
var prev_input_vals = {
	4: 0,
	6: 0,
	8: 0
}

func _ready():
	GameManager.units_changed.connect(on_units_changed)
	for tier in inputs.keys():
		inputs[tier].value_changed.connect(func(value: int): on_changed(tier, value))
	
func on_units_changed(tier: int):
	inputs[tier].max_value = inputs[tier].get_value() + GameManager.get_available_units(tier)
		
func on_changed(tier: int, value: int):
	GameManager.change_assigned_units(tier, value - prev_input_vals[tier])
	prev_input_vals[tier] = value

func get_units() -> Dictionary:
	var units = {}
	for tier in inputs.keys():
		units[tier] = inputs[tier].get_value()
	return units

func reset_units():
	for input in inputs: 
		input.set_value_no_signal(0)
