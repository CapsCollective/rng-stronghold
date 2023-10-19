class_name DebugCombat extends Control

const debug_dice_button_scene = preload("res://assets/debug/gameplay/scenes/debug_dice_button.tscn")
const debug_results_row_scene = preload("res://assets/debug/gameplay/scenes/debug_results_row.tscn")

var action_group: ActionGroup

@onready var title_label: Label = $Container/Title
@onready var health_label: Label = $Container/Health
@onready var your_units: DebugUnitsInput = $Container/YourUnits
@onready var enemy_units: DebugUnitsInput = $Container/EnemyUnits
@onready var your_rolls_container: Container = $Container/YourRolls
@onready var enemy_rolls_container: Container = $Container/EnemyRolls
@onready var roll_button: Button = $Container/RollButton
@onready var results: Container = $Container/ScrollContainer/Results
@onready var button_group: ButtonGroup = ButtonGroup.new()

func _ready():
	name = action_group.title
	title_label.text = action_group.title
	action_group.health_updated.connect(refresh_health)
	refresh_health()
	roll_button.pressed.connect(roll_dice)
	if not GameManager.is_node_ready(): return
	GameManager.new_turn.connect(on_new_turn)
	GameManager.new_game.connect(reset)

func refresh_health():
	if health_label: health_label.text = "Health: %s/%s" % [action_group.health, action_group.max_health]

func roll_dice():
	var your_rolls := Utils.roll_dice(your_units.get_units())
	var enemy_rolls := Utils.roll_dice(enemy_units.get_units())
	your_units.editable = false
	enemy_units.editable = false
	roll_button.visible = false
	for roll in your_rolls:
		var button: DebugDiceButton = debug_dice_button_scene.instantiate()
		your_rolls_container.add_child(button)
		button.button_group = button_group
		button.roll = roll.roll
		button.tier = roll.tier
	for roll in enemy_rolls:
		var button: DebugDiceButton = debug_dice_button_scene.instantiate()
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
			action_group.health -= min(int(remaining_roll.text), action_group.health)
	reset()

func reset():
	your_units.reset_units()
	your_units.editable = true
	enemy_units.editable = true
	roll_button.visible = true
	Utils.queue_free_children(your_rolls_container)
	Utils.queue_free_children(enemy_rolls_container)
	Utils.queue_free_children(results)

func add_result(result: String):
	var label: Label = debug_results_row_scene.instantiate()
	label.text = "• " + result
	results.add_child(label)
	results.move_child(label, 0)
	
func clear_results():
	Utils.queue_free_children(results)
