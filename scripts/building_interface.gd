extends Node2D

signal on_up_pressed
signal on_down_pressed
signal on_confirm_pressed

enum Mode {RESOURCE, DICE, COMBAT}

var physics_dice_scene = preload("res://scenes/physics_dice.tscn")
var dice_to_roll = 0
var dice_to_purchase = 0
var dice_to_commit = 0
var potential_dice
var current_event
var res_id
var ability_risk_returns
var current_mode = Mode.RESOURCE

var resource_alts = ['Harvest Grain', 'Draw Water', 'Repair Wall', 'Forge Weapons', 'Recruit Soldiers', 'Commit Soldiers']

var rolled_buildings = [false, false, false, false, false, false]

onready var game_manager = $"../../"

func _ready():
	$DiceSelector.setup(self, ["on_up_pressed", "on_down_pressed", "on_confirm_pressed"])
	connect("on_up_pressed", self, "add")
	connect("on_down_pressed", self, "subtract")
	connect("on_confirm_pressed", self, "confirm")
	update_display()

func populate(rid):
	res_id = rid
	current_event = game_manager.get_event(res_id)
	dice_to_roll = 0
	dice_to_purchase = 0
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

func add():
	match current_mode:
		Mode.RESOURCE:
			if dice_to_roll < game_manager.turn_dice:
				dice_to_roll += 1
		Mode.DICE:
			if dice_to_purchase < game_manager.influence/10:
				dice_to_purchase += 1
		Mode.COMBAT:
			if dice_to_commit < game_manager.turn_dice and dice_to_commit < game_manager.arms:
				dice_to_commit += 1
	update_display()

func subtract():
	match current_mode:
		Mode.RESOURCE:
			if dice_to_roll > 0:
				dice_to_roll -= 1
		Mode.DICE:
			if dice_to_purchase > 0:
				dice_to_purchase -= 1
		Mode.COMBAT:
			if dice_to_commit > 0:
				dice_to_commit -= 1
	update_display()

func confirm():
	match current_mode:
		Mode.RESOURCE:
			if dice_to_roll > 0:
				game_manager.turn_dice -= dice_to_roll
				for i in dice_to_roll:
					var new_dice = physics_dice_scene.instance()
					new_dice.val = randi()%6+1
					$DiceRoller/DiceSpawner.add_child(new_dice)
				dice_to_roll = 0
				rolled_buildings[res_id] = true
		Mode.DICE:
			if dice_to_purchase > 0:
				var remainder = game_manager.influence - (10 * dice_to_purchase)
				if remainder >= 0:
					game_manager.influence = remainder
					game_manager.dice += dice_to_purchase
					game_manager.turn_dice += dice_to_purchase
					dice_to_purchase = 0
		Mode.COMBAT:
			if dice_to_commit > 0:
				game_manager.turn_dice -= dice_to_commit
				game_manager.committed_dice = dice_to_commit
				dice_to_commit = 0
				rolled_buildings[res_id] = true
	update_display()
	game_manager.update_ui()

func update_display():
	if current_event:
		current_mode = Mode.RESOURCE
	elif res_id == game_manager.Resources.INFLUENCE:
		current_mode = Mode.DICE
	elif res_id == game_manager.Resources.MANPOWER:
		current_mode = Mode.COMBAT
	else:
		current_mode = Mode.RESOURCE
	
	if res_id != null:
		match current_mode:
			Mode.RESOURCE:
				$DiceSelector.set_title("Dice to Roll")
				$DiceSelector.set_confirm("Roll")
				$DiceSelector.set_number(dice_to_roll)
				$DiceSelector.set_disabled(rolled_buildings[res_id])
			Mode.DICE:
				$DiceSelector.set_title("Dice to Purchase")
				$DiceSelector.set_confirm("Purchase")
				$DiceSelector.set_number(dice_to_purchase)
				$DiceSelector.set_disabled(game_manager.influence/10 <= 0)
			Mode.COMBAT:
				$DiceSelector.set_title("Dice to Commit")
				$DiceSelector.set_confirm("Commit")
				$DiceSelector.set_number(dice_to_commit)
				$DiceSelector.set_disabled(rolled_buildings[res_id])
		
		if current_event:
			$InfoPanel.visible = true
			$Target/Label.text = str(current_event['amount'])
			$InfoPanel/Title.text = current_event['title']
			$InfoPanel/FlavorText.text = current_event['flavour']
			$Target.visible = current_event['amount'] > 0
			$Box.visible = false
		else:
			$InfoPanel.visible = false
			$Target.visible = false
			$Box.visible = true
		
		$Box/Label2.text = str(resource_alts[res_id])
		$Box/Label3.text = "+" + str(ability_risk_returns[res_id][1])
	
	if ability_risk_returns:
		$Box/dice_spot/Label3.text = str(ability_risk_returns[res_id][0])

func on_turn_update():
	ability_risk_returns = game_manager.ability_risk_returns.duplicate(true)
	rolled_buildings = [false, false, false, false, false, false]
