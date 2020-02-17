extends Node2D

var physics_dice_scene = preload("res://scenes/physics_dice.tscn")
var dice_to_roll = 0
var potential_dice
var current_event
var ability_val
var res_id

var resource_alts = ['Harvest Grain', 'Draw Water', 'Repair Wall', 'Forge Weapons', 'Recruit Soldiers', 'Commit Soldiers']

var rolled_buildings = [false, false, false, false, false, false]

func _ready():
	$DiceButtons/RollDiceButton.connect("button_up", self, "roll_dice")
	$DiceButtons/AddDiceButton.connect("button_up", self, "add_dice")
	$DiceButtons/RemoveDiceButton.connect("button_up", self, "remove_dice")
	update_display()

func populate(rid):
	res_id = rid
	current_event = $"../../".get_event(res_id)
	dice_to_roll = 0
	ability_val = 8
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
	for area in $Box/dice_spot/Area2D.get_overlapping_areas():
		if area.name.find('Dice') != -1 and not area.lifted:
				ability_val -= area.val
				area.queue_free()
				if ability_val <= 0:
					ability_val = 8
					$"../../".add_resources(res_id, 5)
				update_display()

func add_dice():
	if dice_to_roll < $"../../".turn_dice:
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
	if res_id != null:
		$Box/Label2.text = str(resource_alts[res_id])
		$DiceButtons/Shade.visible = rolled_buildings[res_id]
	$Box/dice_spot/Label3.text = str(ability_val)

func roll_dice():
	if dice_to_roll > 0:
		$"../../".turn_dice -= dice_to_roll
		for i in dice_to_roll:
			var new_dice = physics_dice_scene.instance()
			new_dice.val = randi()%6+1
			$DiceRoller/DiceSpawner.add_child(new_dice)
		dice_to_roll = 0
		$"../../".update_ui()
		rolled_buildings[res_id] = true
		update_display()

func on_turn_update():
	rolled_buildings = [false, false, false, false, false, false]
