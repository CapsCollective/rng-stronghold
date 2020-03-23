extends Node2D

signal finished_rolling
signal finished_showing

onready var game_manager = $"../../"
var physics_dice_scene = preload("res://scenes/physics_dice.tscn")

var rolled = 0
var expected_rolls = 0

var shown = 0
var expected_shown = 0



var player_dice_rolled =[]
var enemy_dice_rolled = []

func start_resolve_combat():
	visible = true
	get_tree().get_root().set_disable_input(true)
	MainCam.zoom_to($CombatZone.global_position, 0.75)
	
	expected_rolls = game_manager.committed_dice + game_manager.enemies
	
	for i in range(game_manager.committed_dice):
		var player_roll = game_manager.get_dice_roll()
		player_dice_rolled.append(player_roll)
		roll_dice($DiceSpawner1, player_roll, false)
		yield(get_tree().create_timer(0.1), "timeout")
	player_dice_rolled.clear()
	
	for i in range(game_manager.enemies):
		var enemy_roll = game_manager.get_dice_roll()
		enemy_dice_rolled.append(enemy_roll)
		roll_dice($DiceSpawner2, enemy_roll, true)
		yield(get_tree().create_timer(0.1), "timeout")
	enemy_dice_rolled.clear()
	
	yield(self, "finished_rolling")
	
	for i in range(enemy_dice_rolled.size()):
		var player_dice = player_dice_rolled.pop_front()
		var enemy_dice = enemy_dice_rolled.pop_front()
		expected_shown = 1
		if player_dice:
			player_dice.begin_show()
			expected_shown += 1
		enemy_dice.begin_show()
		yield(self, "finished_showing")
		yield(get_tree().create_timer(0.5), "timeout")
		display_results(player_dice, enemy_dice)
		game_manager.update_ui()
		if player_dice:
			player_dice.queue_free()
		enemy_dice.queue_free()
	
	yield(get_tree().create_timer(2), "timeout")
	reset_values()
	MainCam.reset()
	yield(get_tree().create_timer(2), "timeout")
	
	get_tree().get_root().set_disable_input(false)
	visible = true
	get_parent().get_parent().on_combat_resolved()

func reset_values():
	for dice in (player_dice_rolled + enemy_dice_rolled):
		dice.queue_free()
	
	player_dice_rolled.clear()
	enemy_dice_rolled.clear()
	
	expected_rolls = 0
	rolled = 0
	expected_shown = 0
	shown = 0

func display_results(player_dice, enemy_dice):
	var enemy_roll = enemy_dice.val
	var player_roll = null
	if player_dice:
		player_roll = player_dice.val
	
	if player_roll:
		if player_roll > enemy_roll:
			game_manager.enemies -= 1
			game_manager.influence += 1
		elif enemy_roll > player_roll:
			game_manager.committed_dice -=1
			game_manager.dice -= 1
			game_manager.influence -= 1
		else:
			game_manager.enemies -= 1
			game_manager.committed_dice -=1
	elif game_manager.walls > 0:
		game_manager.walls -= enemy_roll
	else:
		print('GAME OVER')

func roll_dice(spawner, value, enemy_dice):
	var new_dice = physics_dice_scene.instance()
	new_dice.comabt_dice = true
	new_dice.val = value
	new_dice.is_enemy_dice = enemy_dice
	spawner.add_child(new_dice)

func finished_rolling(dice):
	if dice.is_enemy_dice:
		enemy_dice_rolled.append(dice)
	else:
		player_dice_rolled.append(dice)
	rolled += 1
	if rolled >= expected_rolls:
		emit_signal("finished_rolling")

func finished_showing(dice):
	shown += 1
	if shown % expected_shown == 0:
		emit_signal("finished_showing")
