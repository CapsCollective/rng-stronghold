@tool
extends EditorPlugin

const DatatableEditor = preload("res://addons/datatable/scripts/datatable_editor.gd")

var dt_editor: DatatableEditor

func _enter_tree():
	dt_editor = DatatableEditor.new(self)
	add_control_to_bottom_panel(dt_editor, "Datatable Editor")

func _exit_tree():
	remove_control_from_bottom_panel(dt_editor)
	dt_editor.queue_free()
