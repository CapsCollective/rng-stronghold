extends Control

const debug_resource_row_scene = preload("res://assets/debug/gameplay/scenes/debug_resource_row.tscn")

@onready var reset_button = $Container/ResetButton
@onready var container = $Container/ResourcesContainer

func _ready():
	reset_button.pressed.connect(GameManager.reset_resources)
	for resource in GameManager.Resources:
		var instance = debug_resource_row_scene.instantiate()
		container.add_child(instance)
		instance.resource = resource
