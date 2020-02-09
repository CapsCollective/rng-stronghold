extends Node2D

var physics_dice_scene = preload("res://scenes/physics_dice.tscn")
var dice_to_roll = 0
var potential_dice
var current_event

func _ready():
	$DiceButtons/RollDiceButton.connect("button_up", self, "roll_dice")
	$DiceButtons/AddDiceButton.connect("button_up", self, "add_dice")
	$DiceButtons/RemoveDiceButton.connect("button_up", self, "remove_dice")
	update_display()

func populate(res_id):
	current_event = $"../../".get_event(res_id)
	dice_to_roll = 0
	for child in $DiceRoller/DiceSpawner.get_children():
		child.queue_free()
	update_display()

func _process(delta):
	if $Target.visible:
		for area in $Target/Area2D.get_overlapping_areas():
			if not area.lifted:
				current_event['amount'] -= area.val
				area.queue_free()
				update_display()
				if current_event['amount'] <= 0:
					$"../../".clear_event(current_event['resource'])
					current_event = null

func add_dice():
	if dice_to_roll < $"../../".dice:
		dice_to_roll += 1
		update_display()

func remove_dice():
	if dice_to_roll > 0:
		dice_to_roll -= 1
		update_display()

func update_display():
	if current_event:
		$Target/Label.text = str(current_event['amount'])
	$Target.visible = current_event and current_event['amount'] > 0
	$DiceButtons/DiceNumberLabel.text = str(dice_to_roll)

func roll_dice():
	$"../../".dice -= dice_to_roll
	for i in dice_to_roll:
		var new_dice = physics_dice_scene.instance()
		new_dice.val = randi()%6+1
		$DiceRoller/DiceSpawner.add_child(new_dice)
	dice_to_roll = 0
	$"../../".update_ui()
	update_display()
