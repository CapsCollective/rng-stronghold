extends Panel

func _ready():
	get_parent().refresh.connect(on_refresh)
	$VBoxContainer/Run.button_up.connect(on_button_up)

func on_refresh():
	print("Refresh!")

func on_button_up():
	print("Combat Start!")
	var results := ""
	var your_dice := {
		4: $VBoxContainer/YourUnits/D4s.get_value(),
		6: $VBoxContainer/YourUnits/D6s.get_value(),
		8: $VBoxContainer/YourUnits/D8s.get_value()
	}
	var enemy_dice := {
		4: $VBoxContainer/EnemyUnits/D4s.get_value(),
		6: $VBoxContainer/EnemyUnits/D6s.get_value(),
		8: $VBoxContainer/EnemyUnits/D8s.get_value()
	}
	var your_rolls := roll(your_dice)
	var enemy_rolls := roll(enemy_dice)
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
	
	$VBoxContainer/Results.text = results

func roll(dice: Dictionary) -> Array:
	var rolls = []
	for tier in dice:
		var count = dice[tier]
		for i in dice[tier]:
			rolls.append({
				'roll': randi_range(1, tier),
				'tier': tier
			})
	rolls.sort_custom(sort_rolls)
	return rolls

func sort_rolls(a, b):
	if (a.roll == b.roll):
		return a.tier < b.tier
	return a.roll > b.roll
