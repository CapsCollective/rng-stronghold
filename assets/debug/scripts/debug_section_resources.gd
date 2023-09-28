extends DebugSection

@onready var reset_button = $VBoxContainer/ResetButton
@onready var container = $VBoxContainer/ResourcesContainer
@onready var row = preload("res://assets/debug/scenes/debug_resource_row.tscn")

func _ready():
	reset_button.button_up.connect(on_reset)
	for resource in GameManager.Resources:
		var instance = row.instantiate()
		container.add_child(instance)
		instance.setup(resource)

func on_reset():
	for resource in GameManager.Resources:
		GameManager.set_resource(resource, 0)
