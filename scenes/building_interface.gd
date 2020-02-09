extends Node2D

var physics_dice_scene = preload("res://scenes/physics_dice.tscn")
var dice_to_roll = 0
var target = 14
var potential_dice

func _ready():
	$DiceButtons/RollDiceButton.connect("button_up", self, "roll_dice")
	$DiceButtons/AddDiceButton.connect("button_up", self, "add_dice")
	$DiceButtons/RemoveDiceButton.connect("button_up", self, "remove_dice")
	update_display()

func _process(delta):
	for area in $Target/Area2D.get_overlapping_areas():
		if not area.lifted:
			target -= area.val
			area.queue_free()
			update_display()

func add_dice():
	dice_to_roll += 1
	update_display()

func remove_dice():
	dice_to_roll -= 1
	update_display()

func update_display():
	$DiceButtons/DiceNumberLabel.text = "Dice Committed: " + str(dice_to_roll)
	$Target/Label.text = "Target: " + str(target)

func roll_dice():
	for i in dice_to_roll:
		var new_dice = physics_dice_scene.instance()
		new_dice.val = randi()%6+1
		$DiceRoller/DiceSpawner.add_child(new_dice)
