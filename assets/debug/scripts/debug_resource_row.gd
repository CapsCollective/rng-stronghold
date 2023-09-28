extends Control

@onready var resource_label: Label = $Resource
@onready var count_input: Range = $Count
@onready var value_label: Label = $Value
var _resource

func setup(resource: String):
	_resource = resource
	count_input.value_changed.connect(on_input_changed)
	GameManager.resource_changed.connect(on_resource_changed)
	resource_label.text = _resource.capitalize()
	
func on_resource_changed(res: String, value: int):
	if res != _resource:
		return
	count_input.set_value_no_signal(value)
	value_label.text = str(value)

func on_input_changed(value: int):
	GameManager.set_resource(_resource, value)
