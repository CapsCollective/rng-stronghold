extends PersistentDataSection

const PD_SECTION_PLAYER = "player"
const PD_SECTION_PLAYER_TURN = "turn"
const PD_SECTION_PLAYER_RESOURCES = "resources"
const PD_SECTION_PLAYER_UNITS = "units"

var turn: int
var resources: Dictionary
var units: Dictionary

func get_tag() -> String:
	return PD_SECTION_PLAYER

func serialise() -> Dictionary:
	return {
		PD_SECTION_PLAYER_TURN: turn,
		PD_SECTION_PLAYER_RESOURCES: resources,
		PD_SECTION_PLAYER_UNITS: units,
	}

func deserialise(data: Dictionary) -> DeserialisationResult:
	turn = data.get(PD_SECTION_PLAYER_TURN, 0)
	resources = data.get(PD_SECTION_PLAYER_RESOURCES, {})
	# Convert the string key to int i.e. "4" -> 4
	var loaded = data.get(PD_SECTION_PLAYER_UNITS, {})
	for tier in GameManager.DiceTiers:
		units[tier] = loaded[str(tier)] if loaded.has(str(tier)) else {
			"total": 0,
			"assigned": 0,
			"incapacitated": 0
		}
	return DeserialisationResult.OK
