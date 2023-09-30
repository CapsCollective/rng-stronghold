extends Control

@onready var total_inputs = {
	4: $Container/GridContainer/D4Total,
	6: $Container/GridContainer/D6Total,
	8: $Container/GridContainer/D8Total
}

@onready var available_labels = {
	4: $Container/GridContainer/D4Available,
	6: $Container/GridContainer/D6Available,
	8: $Container/GridContainer/D8Available
}

# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.units_changed.connect(on_units_changed)
	for tier in total_inputs.keys():
		on_units_changed(tier)
		total_inputs[tier].value_changed.connect(func(value): on_total_changed(tier, value))
	
func on_total_changed(tier: int, value: int):
	GameManager.set_total_units(tier, value)

func on_units_changed(tier: int):
	var units = Savegame.player.units[tier]
	total_inputs[tier].set_value_no_signal(units.total)
	available_labels[tier].text = str(units.total - units.assigned)
