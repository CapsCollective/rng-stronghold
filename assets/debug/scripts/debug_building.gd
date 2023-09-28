extends Control

@onready var assigned_units = $Units

var rolls: Array

func roll_assigned():
	Utils.roll_dice(assigned_units.get_units())
