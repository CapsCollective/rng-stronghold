extends PersistentDataSection

const PD_SECTION_PLAYER = "player"
const PD_SECTION_PLAYER_RESOURCES = "resources"
const PD_SECTION_PLAYER_UNITS = "units"

var resources: Dictionary
var units: Dictionary

func get_tag() -> String:
	return PD_SECTION_PLAYER

func serialise() -> Dictionary:
	return {
		PD_SECTION_PLAYER_RESOURCES: resources,
		PD_SECTION_PLAYER_UNITS: units,
	}

func deserialise(data: Dictionary) -> DeserialisationResult:
	resources = data.get(PD_SECTION_PLAYER_RESOURCES, {})
	# This causes the keys to be type string i.e. "4" instead of number 4
	#units = data.get(PD_SECTION_PLAYER_UNITS, {
	units = {
		4: {
			"total": 0,
			"assigned": 0
		},
		6: {
			"total": 0,
			"assigned": 0
		},
		8: {
			"total": 0,
			"assigned": 0
		},
	#})
	}
	return DeserialisationResult.OK
