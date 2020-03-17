extends Node2D

var physics_dice_scene = preload("res://scenes/physics_dice.tscn")
var rolled = 0

func resolve_combat():
	get_tree().get_root().set_disable_input(true)
	roll_dice($DiceSpawner1)
	roll_dice($DiceSpawner2)

func roll_dice(spawner):
	var new_dice = physics_dice_scene.instance()
	new_dice.val = randi()%6+1
	new_dice.comabt_dice = true
	spawner.add_child(new_dice)

func finished_rolling(dice):
	rolled += 1
	if rolled % 2 == 0:
		get_tree().get_root().set_disable_input(false)
		get_parent().get_parent().on_combat_resolved()
