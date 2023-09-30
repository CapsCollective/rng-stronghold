extends Control

@onready var resource_label: Label = $Resource
@onready var count_input: Range = $Count
@onready var value_label: Label = $Value
var resource: String:
	set(res):
		resource = res
		count_input.value_changed.connect(on_input_changed)
		GameManager.resource_changed.connect(on_resource_changed)
		resource_label.text = resource.capitalize()
		count_input.set_value_no_signal(GameManager.get_resource(resource))
		value_label.text = str(GameManager.get_resource(resource))

func on_resource_changed(res: String, value: int):
	if res != resource:
		return
	count_input.set_value_no_signal(value)
	value_label.text = str(value)

func on_input_changed(value: int):
	GameManager.set_resource(resource, value)
