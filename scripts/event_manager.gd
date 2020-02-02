extends Node2D

# Turn timer
onready var turn = 0

# Buildings
var buildings = Array()

# Resources
export (int) var grain
export (int) var water
export (int) var arms
export (int) var walls
export (int) var influence

# Enemy Strength
var enemies

# Manpower
var dice

func _ready():
	pass