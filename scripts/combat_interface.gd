extends Node2D

var physics_dice_scene = preload("res://scenes/physics_dice.tscn")

func _ready():
	#get_tree().get_root().set_disable_input(true)
	roll_dice($DiceSpawner1)
	roll_dice($DiceSpawner2)

func roll_dice(spawner):
	var new_dice = physics_dice_scene.instance()
	new_dice.val = randi()%6+1
	spawner.add_child(new_dice)

func _process(delta):
	pass

func finished_rolling(dice):
	dice.original_position = position
