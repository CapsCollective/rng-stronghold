extends Node2D

# Turn timer
onready var turn = 0

# Resources enum for referencing buildings 
enum Resources {FOOD, WATER, WALL, ARMS, INFLUENCE}

# Events
var events = {
	'Food Rots!': {
		
	},
	'Water Poisoned!': {},
	'Riots Break Out!': {},
	'Walls Start to Crumble!': {},
	'Weapons Rust': {},
}

# Resources
export (int) var grain
export (int) var water
export (int) var arms
export (int) var walls
export (int) var influence

# Enemy Strength
onready var enemies

# Manpower
onready var dice = 20

func _ready():
	$TurnLabel.text = "Turn: " + str(turn)
	$DiceLabel.text = "Manpower: " + str(dice)
	update_ui()

func process_turn():
	
	# 1. TODO: Resolve Combat
	resolve_combat()
	# 2. TODO: Enemy Turn
	commit_enemies()
	degrade_resources()
	# 3. TODO: Roll for Events 
	generate_events()
	turn += 1
	update_ui()

func resolve_combat():
	pass

func commit_enemies():
	pass

func degrade_resources():
	grain -= dice
	water -= dice
	walls -= 5

func generate_events():
	pass

func update_ui():
	$GrainLabel.text = "Grain: " + str(grain)
	$WaterLabel.text = "Water: " + str(water)
	$InfluenceLabel.text = "Inf: " + str(influence)
	$WeaponsLabel.text = "Arms: " + str(arms)
	$WallsLabel.text = "Walls: " + str(walls)
	$TurnLabel.text = "Turn: " + str(turn)

func _input(event):
	if event.is_action_pressed("ui_accept"):
		process_turn()