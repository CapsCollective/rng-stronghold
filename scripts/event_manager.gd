extends Node2D

# Turn timer
var turn = 0

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
var enemies = 0

# Manpower
var dice = 20

func _ready():
	commit_enemies()
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
	var committed = 5 + (turn / 3)
	enemies += committed

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
	$EnemiesLabel.text = "Enemies: " + str(enemies)
	$DiceLabel.text = "Manpower: " + str(dice)

func _input(event):
	if event.is_action_pressed("ui_accept"):
		process_turn()
