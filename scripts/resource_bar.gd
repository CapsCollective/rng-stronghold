extends Control

onready var game_manager = $"../../"
var negation_label_scene = preload("res://scenes/negation_label.tscn")

func update_labels():
	$GrainLabel.text = "Grain: " + str(game_manager.grain)
	$WaterLabel.text = "Water: " + str(game_manager.water)
	$InfluenceLabel.text = "Inf: " + str(game_manager.influence)
	$WeaponsLabel.text = "Arms: " + str(game_manager.arms)
	$WallsLabel.text = "Walls: " +   "\n" + str(game_manager.walls)
	$TurnLabel.text = "Turn: " + str(game_manager.turn)
	$EnemiesLabel.text = "Enemies: " + str(game_manager.enemies)
	$DiceLabel.text = "Dice: " + str(game_manager.turn_dice) + "/" + str(game_manager.dice)
	
	display_label($GrainLabel, -5)
	display_label($WaterLabel, -5)
	display_label($InfluenceLabel, -5)
	display_label($WeaponsLabel, -5)
	display_label($WallsLabel, -5)
	display_label($DiceLabel, -5)

func display_label(resource_label, amount):
	var negation_label = negation_label_scene.instance()
	negation_label.set_text(str(amount))
	negation_label.position = resource_label.get_global_transform().get_origin() + resource_label.get_size()/2
	$"../".add_child(negation_label)
