class_name PersistentDataSection extends Object

const DeserialisationResult = PersistentDataSystem.DeserialisationResult

func _init():
	reset()
	PersistentDataSystem.register_section(self)

func get_tag() -> String:
	return "none"

func serialise() -> Dictionary:
	return {}

func deserialise(_data: Dictionary) -> DeserialisationResult:
	return DeserialisationResult.OK

func reset():
	deserialise({})
