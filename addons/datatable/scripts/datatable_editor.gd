extends Control

var datatable_name_lbl: Label
var row_count_lbl: Label
var add_row_btn: Button
var grid_container: GridContainer
var empty_lbl: Label
var new_dt_btn: Button

var current_dt: Dictionary
var editor_plugin: EditorPlugin

func _init(plugin: EditorPlugin):
	editor_plugin = plugin

func _ready():
	build_layout()
	refresh_table()
	on_datatable_selected({ "hi": "hello", "bye": "goodbye" })

func on_datatable_selected(datatable):
	current_dt = datatable
	refresh_table()

func build_layout():
	custom_minimum_size.y = 500
	anchors_preset = PRESET_BOTTOM_WIDE
	size_flags_vertical = Control.SIZE_SHRINK_BEGIN | Control.SIZE_EXPAND
	
	var main_vbox = VBoxContainer.new()
	main_vbox.layout_mode = 1
	main_vbox.anchors_preset = Control.PRESET_FULL_RECT
	add_child(main_vbox)
	
	var top_hbox = HBoxContainer.new()
	main_vbox.add_child(top_hbox)
	
	datatable_name_lbl = Label.new()
	datatable_name_lbl.text = "Datatable"
	top_hbox.add_child(datatable_name_lbl)
	
	row_count_lbl = Label.new()
	row_count_lbl.text = "(0 rows)"
	top_hbox.add_child(row_count_lbl)
	
	new_dt_btn = Button.new()
	new_dt_btn.flat = true
	new_dt_btn.expand_icon = true
	new_dt_btn.custom_minimum_size.x = 52
	new_dt_btn.custom_minimum_size.y = 52
	new_dt_btn.theme = theme
	new_dt_btn.icon = get_theme_icon("New", "EditorIcons")
	new_dt_btn.tooltip_text = "Create a new datatable."
	new_dt_btn.pressed.connect(on_new_dt_btn_pressed)
	top_hbox.add_child(new_dt_btn)
	
	top_hbox.add_spacer(false)
	
	add_row_btn = Button.new()
	add_row_btn.text = "Add Row"
	add_row_btn.pressed.connect(on_add_btn_pressed)
	top_hbox.add_child(add_row_btn)
	
	var table_panel = Panel.new()
	table_panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	main_vbox.add_child(table_panel)
	
	empty_lbl = Label.new()
	empty_lbl.text = "Select a datatable resource to edit it here."
	empty_lbl.layout_mode = 1
	empty_lbl.anchors_preset = Control.PRESET_CENTER
	table_panel.add_child(empty_lbl)
	
	var table_scroll = ScrollContainer.new()
	table_scroll.layout_mode = 1
	table_scroll.anchors_preset = Control.PRESET_FULL_RECT
	table_panel.add_child(table_scroll)
	
	grid_container = GridContainer.new()
	grid_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	grid_container.size_flags_vertical = Control.SIZE_EXPAND_FILL
	table_scroll.add_child(grid_container)

func refresh_table():
	reset_table()
	populate_table()

func reset_table():
	for child in grid_container.get_children():
		grid_container.remove_child(child)
		child.queue_free()
	datatable_name_lbl.text = "No Datatable Selected"
	row_count_lbl.text = "(0 rows)"

func populate_table():
	var has_table = not current_dt.is_empty()
	empty_lbl.visible = not has_table
	add_row_btn.disabled = not has_table
	grid_container.visible = has_table
	grid_container.columns = 5
	
	if has_table:
		datatable_name_lbl.text = "my_datatable.res"
		row_count_lbl.text = "(%d rows)" % current_dt.size()
	
	var header_idx_lbl = Label.new()
	header_idx_lbl.text = "Row"
	grid_container.add_child(header_idx_lbl)
	for i in range(0, 3):
		var header_lbl = Label.new()
		header_lbl.text = "Header"
		grid_container.add_child(header_lbl)
	grid_container.add_child(Control.new())

	for key in current_dt:
		populate_row(key)

func populate_row(key):
	var idx_lbl = Label.new()
	idx_lbl.text = "1"
	idx_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	grid_container.add_child(idx_lbl)
	for i in range(0, 3):
		populate_cell(i)
	var menu_btn = MenuButton.new()
	menu_btn.get_popup().add_item("Delete", 0)
	menu_btn.icon = get_theme_icon("GuiTabMenuHl", "EditorIcons")
	menu_btn.get_popup().id_pressed.connect(func(id): if id == 0: on_delete_btn_pressed(key))
	grid_container.add_child(menu_btn)

func populate_cell(i):
	var types = ["example", true, 7.2]
	var value = types[i]
	var field_control
	match(typeof(value)):
		TYPE_BOOL:
			field_control = CheckBox.new()
			field_control.button_pressed = value
		TYPE_STRING:
			field_control = LineEdit.new()
			field_control.text = value
		TYPE_INT:
			field_control = SpinBox.new()
			field_control.allow_lesser = true
			field_control.allow_greater = true
			field_control.value = value
		TYPE_FLOAT:
			field_control = SpinBox.new()
			field_control.step = 0.001
			field_control.allow_lesser = true
			field_control.allow_greater = true
			field_control.value = value
		TYPE_OBJECT:
			field_control = EditorResourcePicker.new()
			field_control.edited_resource = value
			field_control.base_type = "Node"
		_:
			field_control = Label.new()
			field_control.add_theme_color_override("font_color", Color(1, 0, 0))
			field_control.text = "unknown type"
	grid_container.add_child(field_control)

func on_add_btn_pressed():
	print("adding new row...")
	on_datatable_selected({ "hi": "hello", "bye": "goodbye", "why": "goodbye"})

func on_delete_btn_pressed(row):
	print("deleting row ", row, "...")
	on_datatable_selected({ "hi": "hello", "bye": "goodbye" })

func on_new_dt_btn_pressed():
	var editor = editor_plugin.get_editor_interface().get_editor_main_screen()
	
	var popup = PopupPanel.new()
	editor.add_child(popup)
	
	var popup_vbox = VBoxContainer.new()
	popup.add_child(popup_vbox)
	
	var resource_picker = EditorResourcePicker.new()
	resource_picker.base_type = "DatatableRow"
	popup_vbox.add_child(resource_picker)
	
	var type_btn = Button.new()
	type_btn.text = "Select Base Row Type"
	var on_type_btn_pressed_callback = func():
		create_new_dt_resource(resource_picker.edited_resource)
		popup.hide()
	type_btn.pressed.connect(on_type_btn_pressed_callback)
	popup_vbox.add_child(type_btn)
	
	popup.popup(new_dt_btn.get_global_rect())

func create_new_dt_resource(resource_type: Resource):
	if resource_type == null:
		return
	
	var editor = editor_plugin.get_editor_interface().get_editor_main_screen()
	
	var new_dt = Datatable.new()
	new_dt.default_row = resource_type
	
	var file_dialog = EditorFileDialog.new()
	file_dialog.mode = EditorFileDialog.FILE_MODE_OPEN_FILE
	file_dialog.access = EditorFileDialog.ACCESS_RESOURCES
	file_dialog.title = "Save New Datatable"
	file_dialog.add_filter("*.tres", "Datatable Resource")
	file_dialog.file_selected.connect(func(p): ResourceSaver.save(new_dt, p))
	editor.add_child(file_dialog)
	
	# Can only be called after the node has entered the tree
	file_dialog.current_file = "new_dt.tres"
	file_dialog.popup_centered()
