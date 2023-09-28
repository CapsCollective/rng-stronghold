extends DebugSection

@onready var reset_button = $VBoxContainer/Reset
@onready var water_input = $VBoxContainer/GridContainer/WaterValue

func _ready():
	reset_button.button_up.connect(on_reset)
	GameManager.resource_changed.connect(on_resource_changed)
	water_input.value_changed.connect(on_water_input_changed)

func on_water_input_changed(value: float):
	GameManager.set_resource("water", value)
	print(Savegame.player.resources)

func on_resource_changed(resource: String):
	match(resource):
		"water": 
			water_input.set_value_no_signal(Savegame.player.resources.water)

func on_reset():
	for resource in GameManager.Resources:
		GameManager.set_resource(resource, 0)
	print(Savegame.player.resources)
