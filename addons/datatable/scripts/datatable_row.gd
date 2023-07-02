class_name DatatableRow extends Resource

func get_name() -> String:
	return DatatableUtils.get_row_name(self)

func get_properties() -> Array:
	return DatatableUtils.get_row_properties(self)

func _to_string() -> String:
	var props = get_properties()
	var display_str = "{"
	for prop in props:
		display_str += "%s: %s," % [prop.name, get(prop.name)]
	return display_str.trim_suffix(",") + "}"
