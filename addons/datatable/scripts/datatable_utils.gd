class_name DatatableUtils

static func get_row_name(row: DatatableRow) -> String:
	var source = row.get_script().source_code
	var regex = RegEx.create_from_string("class_name ([A-z]*)")
	var result = regex.search(source)
	return result.get_string(1) if result else "Unknown"

static func get_row_properties(row: DatatableRow) -> Array:
	var row_props: Array = []
	var prop_list = row.get_script().get_script_property_list()
	for prop in prop_list:
		if prop.type != TYPE_NIL:
			row_props.append({"name": prop.name, "type": prop.type, "value":row.get(prop.name)})
	return row_props
