extends PersistentDataSection

const PD_SECTION_PLAYER = "player"
const PD_SECTION_PLAYER_TURN = "turn"
const PD_SECTION_PLAYER_RESOURCES = "resources"
const PD_SECTION_PLAYER_UNITS = "units"
const PD_SECTION_PLAYER_FARMS = "farmPlotPhases"
const PD_SECTION_PLAYER_BARRIER_HEALTH = "barrierHealth"

var turn: int
var resources: Dictionary
var units: Dictionary
var farm_plot_phases: Array
var barrier_health: Dictionary

func get_tag() -> String:
	return PD_SECTION_PLAYER

func serialise() -> Dictionary:
	return {
		PD_SECTION_PLAYER_TURN: turn,
		PD_SECTION_PLAYER_RESOURCES: resources,
		PD_SECTION_PLAYER_UNITS: units,
		PD_SECTION_PLAYER_FARMS: farm_plot_phases,
		PD_SECTION_PLAYER_BARRIER_HEALTH: barrier_health
	}

func deserialise(data: Dictionary) -> DeserialisationResult:
	turn = data.get(PD_SECTION_PLAYER_TURN, 0)
	resources = data.get(PD_SECTION_PLAYER_RESOURCES, {})
	
	# Need to convert generic Array to Array[int]
	farm_plot_phases = data.get(PD_SECTION_PLAYER_FARMS, [0,0,0,0])
	barrier_health = data.get(PD_SECTION_PLAYER_BARRIER_HEALTH, {})
	# Convert the string key to int i.e. "4" -> 4
	var loaded = data.get(PD_SECTION_PLAYER_UNITS, {})
	for tier in GameManager.DiceTiers:
		units[tier] = loaded[str(tier)] if loaded.has(str(tier)) else {
			"total": 0,
			"assigned": 0,
			"incapacitated": 0
		}
	return DeserialisationResult.OK
