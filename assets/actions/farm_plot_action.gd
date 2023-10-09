class_name FarmPlotAction extends BuildingAction

const INPUT_RESOURCE = "water"
const INPUT_AMOUNT = 3
const OUTPUT_RESOURCE = "wheat"
const OUTPUT_AMOUNT = 5
const PLOT_PHASES = 3

var plot_index: int

var plot_phase: int:
	get:
		return Savegame.player.farm_plot_phases[plot_index]
	set(val):
		var phases = Savegame.player.farm_plot_phases
		# This is a safety catch, but we should be properly initialising this elsewhere
		while plot_index >= len(phases):
			phases.append(0)
		
		phases[plot_index] = val
		update_details()

func _init(_plot_index: int):
	plot_index = _plot_index
	GameManager.new_game.connect(on_new_game)
	update_details()
	super._init()

func on_new_turn():
	super.on_new_turn()
	if is_complete:
		plot_phase = (plot_phase + 1) % PLOT_PHASES
	is_complete = false

func on_new_game(): 
	# Needs some design for how we want to setup the farm
	# This logic should probably be controlled by the farm not the plots
	plot_phase = randi_range(0,2)

func update_details():
	title = get_title()
	description = get_description()
	required_points = get_required_points()

func get_title() -> String:
	return [
		"Plant Seeds",
		"Water Crop",
		"Harvest Wheat"
	][plot_phase]

func get_description() -> Array:
	return [
		["Max 3"],
		["Consumes %s %s" % [INPUT_AMOUNT, INPUT_RESOURCE]],
		["Min 3", "Generates %s %s" % [OUTPUT_AMOUNT, OUTPUT_RESOURCE]]
	][plot_phase]

func get_required_points() -> int:
	return [3, 4, 5][plot_phase]

func valid_roll(roll: int):
	if is_complete:
		return false
	match plot_phase:
		0: return roll <= 3
		1: return GameManager.has_resource(INPUT_RESOURCE, INPUT_AMOUNT)
		2: return roll >= 3

func complete():
	match plot_phase:
		1: GameManager.change_resource(INPUT_RESOURCE, -INPUT_AMOUNT)
		2: GameManager.change_resource(OUTPUT_RESOURCE, OUTPUT_AMOUNT)
	is_complete = true
