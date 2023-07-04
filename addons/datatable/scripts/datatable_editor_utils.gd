class_name DatatableEditorUtils

class VectorEdit extends HBoxContainer:
	
	signal value_changed(value)
	
	const component_names = ["x", "y", "z", "w"]
	
	var vector: Variant
	
	func _ready():
		build_layout()
	
	func build_layout():
		for child in get_children():
			child.queue_free()
		for i in range(0, get_component_count()):
			add_child(build_component_label(i))
			add_child(build_component_spinbox(i))
	
	func build_component_label(idx):
		var panel_container = PanelContainer.new()
		var stylebox = get_theme_stylebox("label_bg", "EditorSpinSlider")
		panel_container.add_theme_stylebox_override("panel", stylebox)
		
		var comp_label = Label.new()
		var component_name = component_names[idx]
		comp_label.text = component_name
		var color = get_theme_color("property_color_" + component_name, "Editor")
		comp_label.add_theme_color_override("font_color", color)
		panel_container.add_child(comp_label)
		return panel_container
	
	func build_component_spinbox(idx):
		var internal_setter_callback = func(v):
			set_component_value(idx, v)
			build_layout()
			value_changed.emit(vector)
		var spinbox = SpinBox.new()
		spinbox.step = 0.001
		spinbox.allow_lesser = true
		spinbox.allow_greater = true
		spinbox.value = get_component_value(idx)
		spinbox.value_changed.connect(internal_setter_callback)
		return spinbox
	
	func get_component_count() -> int:
		match(typeof(vector)):
			TYPE_VECTOR2, TYPE_VECTOR2I:
				return 2
			TYPE_VECTOR3, TYPE_VECTOR3I:
				return 3
			TYPE_VECTOR4, TYPE_VECTOR4I:
				return 4
		return 0
	
	func get_component_value(idx):
		match(idx):
			0:
				return vector.x
			1:
				return vector.y
			2:
				return vector.z
			3:
				return vector.w
	
	func set_component_value(idx, v):
		match(idx):
			0:
				vector.x = v
			1:
				vector.y = v
			2:
				vector.z = v
			3:
				vector.w = v
