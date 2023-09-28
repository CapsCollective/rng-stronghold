extends Control

@onready var your_units: DebugUnitsInput = $YourUnits
@onready var enemy_units: DebugUnitsInput = $EnemyUnits
@onready var run_button = $RunButton
@onready var results_text = $Results

func _ready():
	run_button.button_up.connect(on_button_up)
	results_text.text = ""

func on_button_up():
	print("Combat Start!")
	var results := ""
	var your_rolls := Utils.roll_dice(your_units.get_units())
	var enemy_rolls := Utils.roll_dice(enemy_units.get_units())
	your_units.reset_units()
	results += "Your Rolls"
	for roll in your_rolls:
		results += ", %s (d%s)" % [roll.roll, roll.tier]
	results += "\nEnemy Rolls"
	for roll in enemy_rolls:
		results += ", %s (d%s)" % [roll.roll, roll.tier]
	var rounds_lost = {
		4: 0,
		6: 0,
		8: 0
	}
	var rounds_won = {
		4: 0,
		6: 0,
		8: 0
	}
	var damage_dealt = 0
	
	# Compare results and tally outcomes
	for i in len(enemy_rolls):
		if(i >= len(your_rolls)):
			print("damage dealt")
			damage_dealt += enemy_rolls[i].roll
		elif (your_rolls[i].roll > enemy_rolls[i].roll):
			print("round won")
			rounds_won[enemy_rolls[i].tier] += 1
		elif (your_rolls[i].roll < enemy_rolls[i].roll):
			print("round lost")
			rounds_lost[your_rolls[i].tier] += 1
	
	if(rounds_won[4] > 0 || rounds_won[6] > 0 || rounds_won[8] > 0):
		results += "\nYou defeated "
		if (rounds_won[8] > 0):
			results += "%sd8 " % rounds_won[8]
		if (rounds_won[6] > 0):
			results += "%sd6 " % rounds_won[6]
		if (rounds_won[4] > 0):
			results += "%sd4 " % rounds_won[4]
		results += "enemy dice"
	
	if(rounds_lost[4] > 0 || rounds_lost[6] > 0 || rounds_lost[8] > 0):
		results += "\nYou lost "
		if (rounds_lost[8] > 0):
			results += "%sd8 " % rounds_lost[8]
		if (rounds_lost[6] > 0):
			results += "%sd6 " % rounds_lost[6]
		if (rounds_lost[4] > 0):
			results += "%sd4 " % rounds_lost[4]
		results += "dice"
	
	if damage_dealt > 0:
		results += "\nEnemy deals %s damage" % damage_dealt
	
	results_text.text = results
