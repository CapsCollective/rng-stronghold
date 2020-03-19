extends Node2D

signal finished_rolling

onready var game_manager = $"../../"
var physics_dice_scene = preload("res://scenes/physics_dice.tscn")
var rolled = 0

var expected_rolls = 2
var dice_rolled = []

func start_resolve_combat():
	visible = true
	get_tree().get_root().set_disable_input(true)
	
	while game_manager.enemies > 0:
		rolled = 0
		if game_manager.committed_dice > 0:
			perform_dual_roll()
			yield(self, "finished_rolling")
		else:
			break
		game_manager.update_ui()
	
	for enemy in range(game_manager.enemies):
		perform_wall_roll()
		yield(self, "finished_rolling")
		if game_manager.walls <= 0:
			print('GAME OVER')
		game_manager.update_ui()
	
	yield(get_tree().create_timer(2), "timeout")
	
	get_tree().get_root().set_disable_input(false)
	visible = true
	get_parent().get_parent().on_combat_resolved()

func perform_dual_roll():
	var player_roll = game_manager.get_dice_roll()
	var enemy_roll = game_manager.get_dice_roll()
	if player_roll > enemy_roll:
		game_manager.enemies -= 1
		game_manager.influence += 1
	elif enemy_roll > player_roll:
		game_manager.committed_dice -=1
		game_manager.influence -= 1
	else:
		game_manager.enemies -= 1
		game_manager.committed_dice -=1
	
	expected_rolls = 2
	roll_dice($DiceSpawner1, player_roll, false)
	roll_dice($DiceSpawner2, enemy_roll, true)

func perform_wall_roll():
	var enemy_roll = game_manager.get_dice_roll()
	game_manager.walls -= enemy_roll
	expected_rolls = 1
	roll_dice($DiceSpawner2, enemy_roll, true)

func roll_dice(spawner, value, enemy_dice):
	var new_dice = physics_dice_scene.instance()
	new_dice.comabt_dice = true
	new_dice.val = value
	new_dice.is_enemy_dice = enemy_dice
	spawner.add_child(new_dice)

func finished_rolling(dice):
	dice_rolled.append(dice)
	rolled += 1
	if rolled % expected_rolls == 0:
		for rolled_dice in dice_rolled:
			rolled_dice.queue_free()
		dice_rolled.clear()
		emit_signal("finished_rolling")
