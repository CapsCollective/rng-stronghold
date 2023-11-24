class_name ActionGroupDisplay extends Control

const action_display_scene = preload("res://assets/actions/scenes/action_display.tscn")
const dice_dt: Datatable = preload("res://assets/content/dice_dt.tres")

var action_displays: Array[ActionDisplay]

func _ready():
	GameManager.units_changed.connect(func(_tier): update_display())
	update_display()

func initialise(building: Building):
	building.die_deselected.connect(on_die_deselected)
	var action_group: ActionGroup = building.get_action_group()
	if not action_group:
		Utils.log_warn("Building", "Found no action groups for building ", building.name)
		return
	for action in action_group.get_actions():
		var action_display = action_display_scene.instantiate()
		%ActionsContainer.add_child(action_display)
		action_display.initialise(action)
		action_displays.append(action_display)

func deinitialise(building: Building):
	building.die_deselected.disconnect(on_die_deselected)

func roll_die(tier: int):
	var dice_spawner = GameManager.get_selected_building().dice_spawner
	if dice_spawner:
		var available_units = GameManager.get_available_units(tier)
		if available_units > 0:
			GameManager.change_assigned_units(tier, 1)
			dice_spawner.spawn_die(tier)
	else:
		Utils.log_warn("Building", "No dice spawner set for building ", name)

func on_die_deselected(die: ResultDie):
	for action_display in action_displays:
		action_display.on_die_deselected(die)

func update_display():
	Utils.queue_free_children($HBoxContainer)
	for die_entry in dice_dt:
		var roll_button = Button.new()
		var available_units = GameManager.get_available_units(die_entry.key)
		roll_button.text = "Roll %s (%s)" % [die_entry.value.display_name, available_units]
		roll_button.button_up.connect(func(): roll_die(die_entry.key))
		$HBoxContainer.add_child(roll_button)
