@tool
extends EditorPlugin

const DialogueScriptEditor = preload("res://addons/dialogue/scripts/dialogue_script_editor.gd")
const DialogueScriptInspectorPlugin = preload("res://addons/dialogue/scripts/dialogue_script_inspector_plugin.gd")

var ds_editor: DialogueScriptEditor
var ds_inspector_plugin: DialogueScriptInspectorPlugin

func _enter_tree():
	ds_editor = DialogueScriptEditor.new()
	add_control_to_bottom_panel(ds_editor, "Dialogue Editor")
	ds_inspector_plugin = DialogueScriptInspectorPlugin.new()
	ds_inspector_plugin.dialogue_script_inspected.connect(on_dialogue_script_inspected)
	add_inspector_plugin(ds_inspector_plugin)

func _exit_tree():
	remove_inspector_plugin(ds_inspector_plugin)
	remove_control_from_bottom_panel(ds_editor)
	ds_editor.queue_free()

func on_dialogue_script_inspected(dialogue_script: DialogueScript):
	ds_editor.set_current_dialogue_script(dialogue_script)
	make_bottom_panel_item_visible(ds_editor)
