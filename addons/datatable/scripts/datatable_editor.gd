extends Control

var datatable_name_lbl: Label
var row_type_lbl: Label
var row_count_lbl: Label
var add_row_btn: Button
var grid_container: GridContainer
var none_lbl: Label
var empty_lbl: Label
var new_dt_btn: Button

var current_dt: Datatable
var editor_plugin: EditorPlugin

func _init(plugin: EditorPlugin):
	editor_plugin = plugin

func _ready():
	build_layout()
	refresh_table()

func set_current_datatable(datatable: Datatable):
	current_dt = datatable
	refresh_table()

func build_layout():
	custom_minimum_size.y = 200 * editor_plugin.get_editor_interface().get_editor_scale()
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
	
	row_type_lbl = Label.new()
	row_type_lbl.text = "[]"
	top_hbox.add_child(row_type_lbl)
	
	row_count_lbl = Label.new()
	row_count_lbl.text = "(0 rows)"
	top_hbox.add_child(row_count_lbl)
	
	new_dt_btn = Button.new()
	new_dt_btn.flat = true
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
	
	none_lbl = Label.new()
	none_lbl.text = "Select a datatable resource to edit it here."
	none_lbl.layout_mode = 1
	none_lbl.anchors_preset = Control.PRESET_CENTER
	table_panel.add_child(none_lbl)
	
	empty_lbl = Label.new()
	empty_lbl.text = "No rows in datatable."
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
		child.queue_free()
	datatable_name_lbl.text = "No Datatable Selected"
	row_count_lbl.text = "(0 rows)"

func populate_table():
	if not current_dt:
		none_lbl.visible = true
		empty_lbl.visible = false
		row_count_lbl.visible = false
		row_type_lbl.visible = false
		add_row_btn.disabled = true
		grid_container.visible = false
		return
	
	var row_properties = DatatableUtils.get_row_properties(current_dt.default_row)
	var row_name = DatatableUtils.get_row_name(current_dt.default_row)
	var row_count = current_dt.data.size()
	
	none_lbl.visible = false
	empty_lbl.visible = current_dt.data.is_empty()
	row_count_lbl.visible = true
	row_type_lbl.visible = true
	add_row_btn.disabled = false
	grid_container.visible = true
	grid_container.columns = row_properties.size() + 3
	datatable_name_lbl.text = current_dt.resource_path
	row_count_lbl.text = "(%d row%s)" % [row_count, "s" if row_count != 1 else ""]
	row_type_lbl.text = "[%s]" % row_name
	
	if row_count <= 0:
		return
	
	grid_container.add_child(Control.new())
	var key_lbl = Label.new()
	key_lbl.text = "key"
	grid_container.add_child(key_lbl)
	for property in row_properties:
		var header_lbl = Label.new()
		header_lbl.text = property.name
		grid_container.add_child(header_lbl)
	grid_container.add_child(Control.new())
	
	var row_index = 0
	for key in current_dt.data:
		row_index += 1
		populate_row(row_index, key)

func populate_row(index: int, key):
	var idx_lbl = Label.new()
	idx_lbl.text = " %s " % index
	idx_lbl.add_theme_color_override("font_color", Color(1, 1, 1, 0.5))
	idx_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	grid_container.add_child(idx_lbl)
	
	var row = current_dt.data[key]
	var row_properties = DatatableUtils.get_row_properties(row)
	
	var field_control = build_field_control_for_key(key, current_dt.key_type)
	grid_container.add_child(field_control)
	
	for property in row_properties:
		var setter_callback = func(v):
			row.set(property.name, v)
			ResourceSaver.save(current_dt)
		field_control = build_field_control(row.get(property.name), property, setter_callback)
		grid_container.add_child(field_control)
	
	var menu_btn = MenuButton.new()
	menu_btn.get_popup().add_item("Delete", 0)
	menu_btn.icon = get_theme_icon("GuiTabMenuHl", "EditorIcons")
	var on_pressed = func(id): if id == 0: on_delete_btn_pressed(key)
	menu_btn.get_popup().id_pressed.connect(on_pressed)
	grid_container.add_child(menu_btn)

func build_field_control_for_key(value: Variant, type: Variant.Type):
	var setter_callback = func(k):
		if not current_dt.data.has(k):
			DatatableUtils.move_row_stable(current_dt, value, k)
			ResourceSaver.save(current_dt)
		refresh_table()
	var field_control
	match(type):
		TYPE_STRING_NAME:
			field_control = LineEdit.new()
			field_control.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			field_control.text = value
			field_control.text_submitted.connect(setter_callback)
		TYPE_INT:
			field_control = SpinBox.new()
			field_control.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			field_control.allow_lesser = true
			field_control.allow_greater = true
			field_control.value = value
			field_control.value_changed.connect(setter_callback)
		_:
			field_control = Label.new()
			field_control.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			field_control.add_theme_color_override("font_color", Color.RED)
			field_control.text = "undefined"
	return field_control

func build_field_control(value: Variant, property: Dictionary, setter_callback: Callable):
	var field_control
	match(property.type):
		TYPE_BOOL:
			field_control = CheckBox.new()
			field_control.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			field_control.button_pressed = value
			field_control.toggled.connect(setter_callback)
		TYPE_STRING, TYPE_STRING_NAME:
			field_control = LineEdit.new()
			field_control.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			field_control.text = value
			field_control.text_changed.connect(setter_callback)
		TYPE_INT, TYPE_FLOAT:
			if property.hint == PROPERTY_HINT_ENUM:
				field_control = OptionButton.new()
				field_control.size_flags_horizontal = Control.SIZE_EXPAND_FILL
				var options = property.hint_string.split(",")
				for option in options:
					var components = option.split(":")
					field_control.add_item(components[0], int(components[1]))
				field_control.select(value)
				field_control.item_selected.connect(setter_callback)
			else:
				field_control = SpinBox.new()
				field_control.size_flags_horizontal = Control.SIZE_EXPAND_FILL
				if (property.type == TYPE_FLOAT): field_control.step = 0.001
				field_control.allow_lesser = true
				field_control.allow_greater = true
				field_control.value = value
				field_control.value_changed.connect(setter_callback)
		TYPE_COLOR:
			field_control = ColorPickerButton.new()
			field_control.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			field_control.color = value
			field_control.color_changed.connect(setter_callback)
		TYPE_OBJECT:
			field_control = EditorResourcePicker.new()
			field_control.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			field_control.edited_resource = value
			field_control.base_type = property.hint_string
			field_control.resource_changed.connect(setter_callback)
		_:
			field_control = Label.new()
			field_control.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			field_control.add_theme_color_override("font_color", Color.RED)
			field_control.text = "undefined"
	return field_control

func get_default_key(type: Variant.Type):
	match(type):
		TYPE_STRING_NAME:
			return StringName()
		TYPE_INT:
			return 0

func move_row_stable(old_key, new_key):
	var new_data = Dictionary()
	var all_keys = current_dt.data.keys()
	var all_values = current_dt.data.values()
	var key_idx = all_keys.find(old_key)
	
	for i in range(0, all_keys.size()):
		if i != key_idx:
			new_data[all_keys[i]] = all_values[i]
		else:
			new_data[new_key] = all_values[i]
	current_dt.data = new_data

func on_add_btn_pressed():
	var new_key = get_default_key(current_dt.key_type)
	if not current_dt.data.has(new_key):
		current_dt.data[new_key] = current_dt.default_row.duplicate()
		refresh_table()

func on_delete_btn_pressed(row):
	current_dt.data.erase(row)
	ResourceSaver.save(current_dt)
	refresh_table()

func on_new_dt_btn_pressed():
	var editor = editor_plugin.get_editor_interface().get_editor_main_screen()
	
	var popup = PopupPanel.new()
	editor.add_child(popup)
	
	var popup_vbox = VBoxContainer.new()
	popup.add_child(popup_vbox)
	
	var popup_grid = GridContainer.new()
	popup_grid.columns = 2
	popup_vbox.add_child(popup_grid)
	
	var key_lbl = Label.new()
	key_lbl.text = "Key Type:"
	popup_grid.add_child(key_lbl)
	
	var key_type_options = OptionButton.new()
	var dt_key_types = {"StringName": TYPE_STRING_NAME, "Int": TYPE_INT}
	for type in dt_key_types:
		key_type_options.add_item(type)
	popup_grid.add_child(key_type_options)
	
	var row_lbl = Label.new()
	row_lbl.text = "Base Row Type:"
	popup_grid.add_child(row_lbl)
	
	var resource_picker = EditorResourcePicker.new()
	resource_picker.base_type = "DatatableRow"
	popup_grid.add_child(resource_picker)
	
	var type_btn = Button.new()
	type_btn.text = "Create New Datatable"
	var on_type_btn_pressed_callback = func():
		var key_type = dt_key_types[key_type_options.get_item_text(key_type_options.selected)]
		create_new_dt_resource(key_type, resource_picker.edited_resource)
		popup.hide()
		popup.queue_free()
	type_btn.pressed.connect(on_type_btn_pressed_callback)
	popup_vbox.add_child(type_btn)
	
	popup.popup(new_dt_btn.get_global_rect())

func create_new_dt_resource(key_type: Variant.Type, resource_type: Resource):
	if resource_type == null:
		return
	
	var editor = editor_plugin.get_editor_interface().get_editor_main_screen()
	
	var new_dt = Datatable.new()
	new_dt.key_type = key_type
	new_dt.default_row = resource_type
	
	var file_dialog = EditorFileDialog.new()
	file_dialog.mode = EditorFileDialog.FILE_MODE_OPEN_FILE
	file_dialog.access = EditorFileDialog.ACCESS_RESOURCES
	file_dialog.title = "Save New Datatable"
	file_dialog.min_size = Vector2(1500, 1000)
	file_dialog.add_filter("*.tres", "Datatable Resource")
	var on_file_dialog_file_selected = func(file):
		ResourceSaver.save(new_dt, file)
		file_dialog.queue_free()
	file_dialog.file_selected.connect(on_file_dialog_file_selected)
	editor.add_child(file_dialog)
	
	# Can only be called after the node has entered the tree
	file_dialog.current_file = "new_dt.tres"
	file_dialog.popup_centered()
