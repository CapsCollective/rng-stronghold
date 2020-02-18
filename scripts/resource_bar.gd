extends Control

onready var game_manager = $"../../"

func update_labels():
	$GrainLabel.text = "Grain: " + str(game_manager.grain)
	$WaterLabel.text = "Water: " + str(game_manager.water)
	$InfluenceLabel.text = "Inf: " + str(game_manager.influence)
	$WeaponsLabel.text = "Arms: " + str(game_manager.arms)
	$WallsLabel.text = "Walls: " +   "\n" + str(game_manager.walls)
	$TurnLabel.text = "Turn: " + str(game_manager.turn)
	$EnemiesLabel.text = "Enemies: " + str(game_manager.enemies)
	$DiceLabel.text = "Dice: " + str(game_manager.turn_dice) + "/" + str(game_manager.dice)
