extends DebugSection

@onready var d4_total = $VBoxContainer/GridContainer/D4Total
@onready var d4_available = $VBoxContainer/GridContainer/D4Available
@onready var d6_total = $VBoxContainer/GridContainer/D6Total
@onready var d6_available = $VBoxContainer/GridContainer/D6Available
@onready var d8_total = $VBoxContainer/GridContainer/D8Total
@onready var d8_available = $VBoxContainer/GridContainer/D8Available


# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.units_changed.connect(on_units_changed)
	d4_total.value_changed.connect(on_d4_total_changed)
	d6_total.value_changed.connect(on_d6_total_changed)
	d8_total.value_changed.connect(on_d8_total_changed)

func on_d4_total_changed(value: int):
	GameManager.set_total_units(4, value)
	
func on_d6_total_changed(value: int):
	GameManager.set_total_units(6, value)

func on_d8_total_changed(value: int):
	GameManager.set_total_units(8, value)

func on_units_changed(tier: int):
	var units = Savegame.player.units[tier]
	match tier:
		4:
			d4_total.set_value_no_signal(units.total)
			d4_available.text = str(units.total - units.assigned)
		6:
			d6_total.set_value_no_signal(units.total)
			d6_available.text = str(units.total - units.assigned)
		8:
			d8_total.set_value_no_signal(units.total)
			d8_available.text = str(units.total - units.assigned)
