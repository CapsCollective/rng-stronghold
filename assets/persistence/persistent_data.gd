extends Node

const FILE_NAME = "user://savegame.save"

enum DeserialisationResult {
	OK = 0,
	RECOVERED = 1,
	FAILED = 2,
}

const PD_METADATA = "metadata"
const PD_METADATA_SAVE_VERSION = "save_version"
const PD_METADATA_SAVE_TIME = "save_time"

const SAVE_VERSION: int = 0

var save_metadata: Dictionary = {}
var save_sections: Dictionary = {}

func register_section(section: PersistentDataSection):
	var tag = section.get_tag()
	if save_sections.has(tag):
		push_warning("Registration Warning: Section tag \"", tag, "\" already registered, skipping registration.")
		return
	save_sections[tag] = section

func serialise_metadata() -> Dictionary:
	return {
		PD_METADATA_SAVE_VERSION: SAVE_VERSION,
		PD_METADATA_SAVE_TIME: Time.get_datetime_string_from_system(true, true)
	}

func serialise_all_sections() -> Dictionary:
	var save_data: Dictionary = {}
	save_data[PD_METADATA] = serialise_metadata()
	for section in save_sections.values():
		save_data[section.get_tag()] = section.serialise()
	return save_data

func deserialise_metadata(data: Dictionary) -> DeserialisationResult:
	if not data.has(PD_METADATA):
		return DeserialisationResult.FAILED
	save_metadata = data[PD_METADATA]
	return DeserialisationResult.OK

func deserialise_all_sections(data: Dictionary) -> DeserialisationResult:
	var result: DeserialisationResult = deserialise_metadata(data)
	for section in save_sections.values():
		var tag = section.get_tag()
		if not data.has(tag):
			continue
		var section_result = section.deserialise(data[tag])
		if section_result == DeserialisationResult.FAILED:
			push_error("Deserialisation Error: Failed to deserialise section \"", tag, "\".")
		elif section_result == DeserialisationResult.RECOVERED:
			push_warning("Deserialisation Warning: Deserialisation of section \"", tag, "\" required recovery.")
		result = (section_result if section_result > result else result)
	return result

func save_file():
	var file = FileAccess.open(FILE_NAME, FileAccess.WRITE)
	var json_string = JSON.stringify(serialise_all_sections())
	file.store_line(json_string)

func load_file():
	if not FileAccess.file_exists(FILE_NAME):
		return
	var save_game = FileAccess.open(FILE_NAME, FileAccess.READ)
	while save_game.get_position() < save_game.get_length():
		var json = JSON.new()
		var json_string = save_game.get_line()
		if json.parse(json_string) != OK:
			push_error("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line(), ".")
			continue
		var save_data = json.get_data()
		if deserialise_all_sections(save_data) == DeserialisationResult.FAILED:
			push_error("Deserialisation Error: Some sections failed to deserialise.")
		Utils.push_info("Deserialised Data: ", save_data)
