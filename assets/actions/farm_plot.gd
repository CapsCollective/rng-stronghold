@tool 
extends BuildingAction

const WATER_INPUT = 3
const WHEAT_OUTPUT = 5

@export var plot_index: int
var is_completed: bool

var plot_phase: int:
	set(val):
		print("Setting phase", val)
		var phases = Savegame.player.farm_plot_phases
		plot_phase = val
		while plot_index >= len(phases):
			phases.append(0)
		Savegame.player.farm_plot_phases[plot_index] = val
		update_details()

func register():
	plot_phase = Savegame.player.farm_plot_phases[plot_index]
	GameManager.new_game.connect(on_new_game)
	update_details()
	super.register()

func on_new_turn():
	super.on_new_turn()
	is_completed = false

func on_new_game():
	plot_phase = 0

func update_details():
	title = get_plot_title()
	description = get_plot_description()
	required_points = get_plot_points()

func get_plot_title() -> String:
	return [
		"Plant Seeds",
		"Water Crop",
		"Harvest Wheat"
	][plot_phase]

func get_plot_description() -> String:
	return [
		"Max 3",
		"Consumes 2 water",
		"Min 3\nGenerates 8 Wheat"
	][plot_phase]
	
func get_plot_points() -> int:
	return [3, 4, 5][plot_phase]

func valid_roll(roll: int):
	if is_completed:
		return false
	match plot_phase:
		0: return roll <= 3
		1: return GameManager.get_resource("water") >= 2
		2: return roll >= 3

func complete():
	match plot_phase:
		1: GameManager.change_resource("water", -WATER_INPUT)
		2: GameManager.change_resource("wheat", WHEAT_OUTPUT)
	plot_phase = (plot_phase + 1) % 3
	is_completed = true
