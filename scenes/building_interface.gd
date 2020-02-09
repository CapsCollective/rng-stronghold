extends Node2D

var physics_dice_scene = preload("res://scenes/physics_dice.tscn")
var dice_to_roll = 0

func _ready():
	$DiceButtons/RollDiceButton.connect("button_up", self, "roll_dice")
	$DiceButtons/AddDiceButton.connect("button_up", self, "add_dice")
	$DiceButtons/RemoveDiceButton.connect("button_up", self, "remove_dice")

func add_dice():
	dice_to_roll += 1
	update_display()

func remove_dice():
	dice_to_roll -= 1
	update_display()

func update_display():
	$DiceButtons/DiceNumberLabel.text = "Dice Committed: " + str(dice_to_roll)

func roll_dice():
	for i in dice_to_roll:
		var new_dice = physics_dice_scene.instance()
		new_dice.val = randi()%6+1
		$DiceRoller/DiceSpawner.add_child(new_dice)
