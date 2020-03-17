extends Node2D

class_name GameManager

# Turn timer
var turn = -1
var turn_delta = 0

# Resources enum for referencing buildings 
enum Resources {FOOD, WATER, WALL, ARMS, INFLUENCE, MANPOWER}
var resource_names = ["Food", "Water", "Wall", "Arms", "Influence"]
var ability_risk_returns = [[8, 10], [4, 5], [12, 10], [6, 5], [12, 1], [0, 0]]

# Events
var events = [
	{
		'title': 'Food Rots!',
		'resource': Resources.FOOD,
		'amount': 15,
		'flavour': "This is some flavour text",
		'turn_counter': 0,
	},
	{
		'title': 'Water Poisoned!',
		'resource': Resources.WATER,
		'amount': 15,
		'flavour': "This is some flavour text",
		'turn_counter': 0,
	},
	{
		'title': 'Riots Break Out!',
		'resource': Resources.INFLUENCE,
		'amount': 15,
		'flavour': "This is some flavour text",
		'turn_counter': 0,
	},
	{
		'title': 'Walls Start to Crumble!',
		'resource': Resources.WALL,
		'amount': 15,
		'flavour': "This is some flavour text",
		'turn_counter': 0,
	},
	{
		'title': 'Weapons Rust',
		'resource': Resources.ARMS,
		'amount': 15,
		'flavour': "This is some flavour text",
		'turn_counter': 0,
	},
]

var active_events = {
	Resources.FOOD: null,
	Resources.WATER: null,
	Resources.WALL: null,
	Resources.ARMS: null,
	Resources.INFLUENCE: null,
	Resources.MANPOWER: null,
}

# Resources
export (int) var grain
export (int) var water
export (int) var arms
export (int) var walls
export (int) var influence

var attritionRate = 0

# Enemy Strength
var enemies = 0

# Manpower
var dice = 20
var turn_dice = 0
var committed_dice = 0

func _ready():
	increment_turn()
	turn_dice = dice
	commit_enemies()
	update_ui()

func process_turn():
	commit_enemies()
	degrade_resources()
	increment_turn()
	turn_dice = dice
	generate_event()
	update_ui()

func increment_turn():
	turn += 1
	committed_dice = 0
	$HUDCanvas/BuildingInterface.on_turn_update()

func get_dice_roll():
	return randi()%6+1

func resolve_combat():
	# 1 Zoom in on battlefield
	# 2 Roll two dice (one blue, one red)
	# 3 Move them to the centre of the screen
	# 4 Remove the one that fails (or both)
	# 5 If enemies have unrolled dice damage the walls
	# 6 Zoom out on the battlefield
	
	for enemy in range(enemies):
		if committed_dice > 0:
			var player_roll = get_dice_roll()
			var enemy_roll = get_dice_roll()
			if player_roll > enemy_roll:
				enemies -= 1
				influence += 1
			elif enemy_roll > player_roll:
				committed_dice -=1
				influence -= 1
			else:
				enemies -= 1
				committed_dice -=1
		elif walls > 0:
			walls -= get_dice_roll()
	if walls == 0:
		print('GAME OVER')
	
	update_ui()
	
	
	$HUDCanvas/CombatInterface.resolve_combat()

func on_combat_resolved():
	process_turn()

func commit_enemies():
	var committed = 1 + (turn / 20)
	enemies += committed

func degrade_resources():
	decrement_resource(Resources.FOOD, dice)
	decrement_resource(Resources.WATER, dice)
	decrement_resource(Resources.WALL, 1)
	if grain > 0 and water > 0:
		influence += 5
	elif (grain > 0 and water == 0) or (grain == 0 and water > 0):
		influence += 2
		attritionRate = 2
	else:
		decrement_resource(Resources.INFLUENCE, 5)
		attritionRate = 1
	check_attrition()

func generate_event():
	trigger_events()
	var new_event = events[randi()%events.size()]
	if not active_events[new_event['resource']]:
		active_events[new_event['resource']] = new_event
		$"HUDCanvas/EventPanel".display_event(new_event)

func trigger_events():
	var events_to_delete = []
	if not active_events.empty():
		for event in active_events.values():
			if event:
				event['turn_counter'] += 1
				if event['turn_counter'] == 2:
					print('EVENT TRIGGERED: ')
					print('EVENT: ' + event['title'])
					print('AMOUNT: ' + str(event['amount']))
					decrement_resource(event['resource'], event['amount'])
					event['amount'] = 15
					events_to_delete.push_back(event['resource'])
	for res in events_to_delete:
		clear_event(res)

func get_event(res_id):
	return active_events[res_id]

func clear_event(resource):
	active_events[resource] = null

func update_ui():
	$HUDCanvas/ResourceBar.update_labels()
	$Buildings.display_battlefield()

func _input(event):
	if event.is_action_pressed("ui_accept"):
		resolve_combat()
	if event.is_action_pressed("ui_cancel"):
		$"HUDCanvas/EventPanel".hide()

func check_attrition():
	if attritionRate > 0:
		turn_delta += 1
		if turn_delta == attritionRate:
			print("Attrition!")
			decrement_resource(Resources.MANPOWER, 1)
			turn_delta = 0

func add_resources(res_id, amount):
	match res_id:
		0:
			grain += amount
		1:
			water += amount
		2:
			walls += amount
		3:
			arms += amount
		4:
			influence += amount
	update_ui()

func decrement_resource(res, amount):
	match res:
		Resources.FOOD:
			grain = decrement(grain, amount)
		Resources.WATER:
			water = decrement(water, amount)
		Resources.WALL:
			walls = decrement(walls, amount)
		Resources.ARMS:
			arms = decrement(arms, amount)
		Resources.INFLUENCE:
			influence = decrement(influence, amount)
		Resources.MANPOWER:
			dice = decrement(dice, amount)

func decrement(obj, amount):
	if (obj - amount) > 0:
		obj -= amount
	else:
		obj = 0
	return obj
