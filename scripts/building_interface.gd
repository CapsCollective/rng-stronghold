extends Node2D

var physics_dice_scene = preload("res://scenes/physics_dice.tscn")
var dice_to_roll = 0
var dice_to_commit = 0
var potential_dice
var current_event
var res_id
var ability_risk_returns

var resource_alts = ['Harvest Grain', 'Draw Water', 'Repair Wall', 'Forge Weapons', 'Recruit Soldiers', 'Commit Soldiers']

var rolled_buildings = [false, false, false, false, false, false]

onready var game_manager = $"../../"

func _ready():
	$DiceButtons/RollDiceButton.connect("button_up", self, "roll_dice")
	$DiceButtons/AddDiceButton.connect("button_up", self, "add_dice")
	$DiceButtons/RemoveDiceButton.connect("button_up", self, "remove_dice")
	$CommitButtons/CommitButton.connect("button_up", self, "commit_dice")
	$CommitButtons/AddButton.connect("button_up", self, "add_commit_dice")
	$CommitButtons/RemoveButton.connect("button_up", self, "remove_commit_dice")
	update_display()

func populate(rid):
	res_id = rid
	current_event = game_manager.get_event(res_id)
	dice_to_roll = 0
	dice_to_commit = 0
	for child in $DiceRoller/DiceSpawner.get_children():
		child.queue_free()
	update_display()

func _process(delta):
	if $Target.visible:
		for area in $Target/Area2D.get_overlapping_areas():
			if not area.lifted:
				current_event['amount'] -= area.val
				area.queue_free()
				if current_event['amount'] <= 0:
					game_manager.clear_event(current_event['resource'])
					current_event['amount'] = 15
					current_event = null
				update_display()
	for area in $Box/dice_spot/Area2D.get_overlapping_areas():
		if area.is_in_group("ui_dice") and not area.lifted:
				ability_risk_returns[res_id][0] -= area.val
				area.queue_free()
				if ability_risk_returns[res_id][0] <= 0:
					ability_risk_returns[res_id][0] = game_manager.ability_risk_returns[res_id][0]
					game_manager.add_resources(res_id, ability_risk_returns[res_id][1])
				update_display()

func add_dice():
	if (res_id == game_manager.Resources.INFLUENCE && !current_event and dice_to_roll < game_manager.influence/10) or (res_id != game_manager.Resources.INFLUENCE || current_event and dice_to_roll < game_manager.turn_dice):
		dice_to_roll += 1
		update_display()

func remove_dice():
	if dice_to_roll > 0:
		dice_to_roll -= 1
		update_display()

func add_commit_dice():
	if dice_to_commit < game_manager.turn_dice:
		dice_to_commit += 1
		update_display()

func remove_commit_dice():
	if dice_to_commit > 0:
		dice_to_commit -= 1
		update_display()

func update_display():
	var is_battlefield = res_id == game_manager.Resources.MANPOWER
	var is_keep = res_id == game_manager.Resources.INFLUENCE
	$DiceButtons.visible = !is_battlefield
	$DiceButtons/Label.text = "Dice to Roll"
	$DiceButtons/RollDiceButton/Label.text = "Roll"
	$CommitButtons.visible = is_battlefield
	$InfoPanel.visible = current_event != null
	if current_event:
		$Target/Label.text = str(current_event['amount'])
		$InfoPanel/Title.text = current_event['title']
		$InfoPanel/FlavorText.text = current_event['flavour']
	$Target.visible = (current_event and current_event['amount'] > 0)
	$Box.visible = !is_battlefield && !is_keep && !current_event
	$DiceButtons/DiceNumberLabel.text = str(dice_to_roll)
	$CommitButtons/DiceNumberLabel.text = str(dice_to_commit)
	if res_id != null:
		$Box/Label2.text = str(resource_alts[res_id])
		$Box/Label3.text = "+" + str(ability_risk_returns[res_id][1])
		$DiceButtons/Shade.visible = rolled_buildings[res_id]
		if is_battlefield:
			$CommitButtons/Shade.visible = rolled_buildings[res_id]
		if is_keep && not current_event:
			$DiceButtons/Label.text = "Buy Troops"
			$DiceButtons/RollDiceButton/Label.text = "Buy"
			$DiceButtons/Shade.visible = game_manager.influence/10 < 1
	if ability_risk_returns:
		$Box/dice_spot/Label3.text = str(ability_risk_returns[res_id][0])

func roll_dice():
	if dice_to_roll > 0:
		if res_id == game_manager.Resources.INFLUENCE && !current_event:
			var remainder = game_manager.influence - (10 * dice_to_roll)
			if remainder >= 0:
				game_manager.influence = remainder
				game_manager.dice += dice_to_roll
				game_manager.turn_dice += dice_to_roll
				dice_to_roll = 0
				update_display()
				game_manager.update_ui()
			return
		game_manager.turn_dice -= dice_to_roll
		for i in dice_to_roll:
			var new_dice = physics_dice_scene.instance()
			new_dice.val = randi()%6+1
			$DiceRoller/DiceSpawner.add_child(new_dice)
		dice_to_roll = 0
		game_manager.update_ui()
		rolled_buildings[res_id] = true
		update_display()

func commit_dice():
	if dice_to_commit > 0:
		game_manager.turn_dice -= dice_to_commit
		game_manager.committed_dice = dice_to_commit
		dice_to_commit = 0
		rolled_buildings[res_id] = true
		update_display()
		game_manager.update_ui()

func on_turn_update():
	ability_risk_returns = game_manager.ability_risk_returns.duplicate(true)
	rolled_buildings = [false, false, false, false, false, false]
