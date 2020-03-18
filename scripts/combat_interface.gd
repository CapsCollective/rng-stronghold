extends Node2D

onready var game_manager = $"../../"
var physics_dice_scene = preload("res://scenes/physics_dice.tscn")
var rolled = 0

func start_resolve_combat():
	visible = true
	get_tree().get_root().set_disable_input(true)
	roll_dice($DiceSpawner1)
	roll_dice($DiceSpawner2)
	
	for enemy in range(game_manager.enemies):
		if game_manager.committed_dice > 0:
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
		elif game_manager.walls > 0:
			game_manager.walls -= game_manager.get_dice_roll()
	if game_manager.walls == 0:
		print('GAME OVER')
	
	game_manager.update_ui()

func roll_dice(spawner):
	var new_dice = physics_dice_scene.instance()
	new_dice.val = randi()%6+1
	new_dice.comabt_dice = true
	spawner.add_child(new_dice)

func finished_rolling(dice):
	rolled += 1
	if rolled % 2 == 0:
		get_tree().get_root().set_disable_input(false)
		visible = true
		get_parent().get_parent().on_combat_resolved()
		$DiceSpawner1.get_children()[0].queue_free()
		$DiceSpawner2.get_children()[0].queue_free()
