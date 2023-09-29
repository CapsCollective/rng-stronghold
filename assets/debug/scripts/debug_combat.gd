class_name DebugCombat extends Control

@onready var health_label: Label = $Health
@onready var your_units: DebugUnitsInput = $YourUnits
@onready var enemy_units: DebugUnitsInput = $EnemyUnits
@onready var your_rolls_container: Container = $YourRolls
@onready var enemy_rolls_container: Container = $EnemyRolls
@onready var roll_button: Button = $RollButton
@onready var results: Container = $ScrollContainer/Results
@onready var dice_button = preload("res://assets/debug/scenes/debug_dice_button.tscn")
@onready var results_row = preload("res://assets/debug/scenes/debug_results_row.tscn")
var button_group: ButtonGroup = ButtonGroup.new()

var health = 20:
	set(val):
		health = val
		health_label.text = "Health: %s/%s" % [health, max_health]
var max_health = 20

func _ready():
	roll_button.pressed.connect(roll_dice)
	GameManager.new_turn.connect(on_new_turn)
	GameManager.new_game.connect(reset)

func roll_dice():
	var your_rolls := Utils.roll_dice(your_units.get_units())
	var enemy_rolls := Utils.roll_dice(enemy_units.get_units())
	your_units.editable = false
	enemy_units.editable = false
	roll_button.visible = false
	for roll in your_rolls:
		var button: DebugDiceButton = dice_button.instantiate()
		your_rolls_container.add_child(button)
		button.button_group = button_group
		button.roll = roll.roll
		button.tier = roll.tier
	for roll in enemy_rolls:
		var button: DebugDiceButton = dice_button.instantiate()
		enemy_rolls_container.add_child(button)
		button.roll = roll.roll
		button.tier = roll.tier
		button.hostile = true
		button.toggle_mode = false
		button.pressed.connect(func(): target_enemy_die(button))

func target_enemy_die(enemy_die: DebugDiceButton):
	var your_die = button_group.get_pressed_button()
	if not your_die:
		return
	if (enemy_die.roll <= your_die.roll):
		add_result("Enemy d%s was defeated %s vs %s" % [enemy_die.tier, enemy_die.roll, your_die.roll])
		enemy_units.change_units(enemy_die.tier, -1)
		enemy_die.queue_free()
	else:
		add_result("Your d%s was defeated, enemy %s has %s health remaining" % [your_die.tier, enemy_die.tier, your_die.roll])
		enemy_die.roll -= your_die.roll
		enemy_die.hostile = false
	your_die.queue_free()

func on_new_turn():
	for remaining_roll in enemy_rolls_container.get_children():
		if remaining_roll.hostile:
			health -= min(int(remaining_roll.text), health)
	reset()

func reset():
	your_units.reset_units()
	your_units.editable = true
	enemy_units.editable = true
	roll_button.visible = true
	Utils.delete_children(your_rolls_container)
	Utils.delete_children(enemy_rolls_container)
	Utils.delete_children(results)

func add_result(result: String):
	var label: Label = results_row.instantiate()
	label.text = "• " + result
	results.add_child(label)
	results.move_child(label, 0)
	
func clear_results():
	Utils.delete_children(results)
