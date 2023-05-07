class_name PersistentDataSection extends Node

const DeserialisationResult = PersistentData.DeserialisationResult

func _init():
	reset()
	PersistentData.register_section(self)

func get_tag() -> String:
	return "none"

func serialise() -> Dictionary:
	return {}

func deserialise(_data: Dictionary) -> DeserialisationResult:
	return DeserialisationResult.OK

func reset():
	deserialise({})
