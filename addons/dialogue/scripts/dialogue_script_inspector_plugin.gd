extends EditorInspectorPlugin

signal dialogue_script_inspected(dialogue_script: DialogueScript)

func _can_handle(object):
	return object is DialogueScript

func _parse_begin(object):
	dialogue_script_inspected.emit(object)
