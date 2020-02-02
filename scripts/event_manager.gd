extends Node2D

# Turn timer
var turn = 0

# Resources enum for referencing buildings 
enum Resources {FOOD, WATER, WALL, ARMS, INFLUENCE}

# Events
var events = {
	'Food Rots!': {
		'resource': Resources.FOOD,
		'amount': 15,
		'flavour': "This is some flavour text",
	},
	'Water Poisoned!': {
		'resource': Resources.WATER,
		'amount': 15,
		'flavour': "This is some flavour text",
	},
	'Riots Break Out!': {
		'resource': Resources.INFLUENCE,
		'amount': 15,
		'flavour': "This is some flavour text",
	},
	'Walls Start to Crumble!': {
		'resource': Resources.WALL,
		'amount': 15,
		'flavour': "This is some flavour text",
	},
	'Weapons Rust': {
		'resource': Resources.ARMS,
		'amount': 15,
		'flavour': "This is some flavour text",
	},
}

# Resources
export (int) var grain
export (int) var water
export (int) var arms
export (int) var walls
export (int) var influence

# Enemy Strength
var enemies = 5

# Manpower
var dice = 20

func _ready():
	$TurnLabel.text = "Turn: " + str(turn)
	$DiceLabel.text = "Manpower: " + str(dice)
	update_ui()

func process_turn():
	resolve_combat()
	# 2. TODO: Enemy Turn
	commit_enemies()
	degrade_resources()
	# 3. TODO: Roll for Events 
	generate_events()
	turn += 1
	update_ui()

func get_dice_roll():
	randi()%7+1

func resolve_combat():
	for dice in range(enemies):
		if dice > 0:
			var player_roll = get_dice_roll()
			var enemy_roll = get_dice_roll()
			if player_roll > enemy_roll:
				enemies -= 1
				influence += 1
			elif enemy_roll > player_roll:
				dice -=1
				influence -= 1
			else:
				enemies -= 1
				dice -=1
		elif walls > 0:
			walls - get_dice_roll()
		else:
			# TODO make something cool happen
			print("game over")

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
