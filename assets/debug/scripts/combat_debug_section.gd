extends Panel

func _ready():
	get_parent().refresh.connect(on_refresh)
	$VBoxContainer/Run.button_up.connect(on_button_up)

func on_refresh():
	print("Refresh!")

func on_button_up():
	print("Combat Start!")
	var results = ""
	var your_rolls = roll($VBoxContainer/YourUnits/D4s.get_value(), 4)
	var enemy_rolls = roll($VBoxContainer/EnemyUnits/D4s.get_value(), 4)
	results += "Your Rolls: "
	results += ", ".join(your_rolls)
	results += "\nEnemy Rolls: "
	results += ", ".join(enemy_rolls)
	var rounds_lost = 0
	var rounds_won = 0
	var damage_dealt = 0
	for i in len(enemy_rolls):
		if(i >= len(your_rolls)):
			print("damage dealt")
			damage_dealt += enemy_rolls[i]
		elif (your_rolls[i] > enemy_rolls[i]):
			print("round won")
			rounds_won += 1
		elif (your_rolls[i] < enemy_rolls[i]):
			print("round lost")
			rounds_lost += 1
	if rounds_won > 0:
		results += "\nYou defeated %s enemy dice" % rounds_won
	if rounds_lost > 0:
		results += "\nYou lost %s dice" % rounds_lost
	if damage_dealt > 0:
		results += "\nEnemy deals %s damage" % damage_dealt
	$VBoxContainer/Results.text = results

func roll(count: int, tier: int):
	var rolls = []
	for i in count:
		rolls.append(randi_range(1, tier))
	rolls.sort()
	rolls.reverse()
	return rolls
