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

#Labels
onready var turn_label = $TurnLabel

func _ready():
	turn_label.text = "Turn: " + str(turn)

func process_turn():
	
	# 1. Resolve Combat
	resolve_combat()
	# 2. Enemy Turn
	commit_enemies()
	# 3. Degrade resources <--- walls degrade, food used, water used
	degrade_resources()
	# 4. Roll for Events 
	generate_events()
	# 5. Increment turn timer
	increment_turn()

func resolve_combat():
	pass

func commit_enemies():
	pass

func degrade_resources():
	pass

func generate_events():
	pass

func increment_turn():
	turn += 1
	turn_label.text = "Turn: " + str(turn)

func _process(delta):
	if Input.is_action_just_pressed('ui_accept'):
		process_turn()