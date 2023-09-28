extends Control

@onready var assigned_units = $Units

var rolls: Array

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func roll_assigned():
	Utils.roll_dice(assigned_units.get_units())
