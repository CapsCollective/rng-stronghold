extends Control

@onready var reset_button = $VBoxContainer/ResetButton
@onready var container = $VBoxContainer/ResourcesContainer
@onready var row = preload("res://assets/debug/scenes/debug_resource_row.tscn")

func _ready():
	reset_button.pressed.connect(GameManager.reset_resources)
	for resource in GameManager.Resources:
		var instance = row.instantiate()
		container.add_child(instance)
		instance.resource = resource
