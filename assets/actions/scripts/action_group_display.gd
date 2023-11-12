class_name ActionGroupDisplay extends Control

const action_display_scene = preload("res://assets/actions/scenes/action_display.tscn")

var action_displays: Array[ActionDisplay]

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

func on_die_deselected(die: ResultDie):
	for action_display in action_displays:
		action_display.on_die_deselected(die)