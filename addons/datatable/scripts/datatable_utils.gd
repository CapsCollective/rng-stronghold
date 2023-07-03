class_name DatatableUtils

static func get_row_name(row: DatatableRow) -> String:
	var source = row.get_script().source_code
	var regex = RegEx.create_from_string("class_name ([A-z0-9]*)")
	var result = regex.search(source)
	return result.get_string(1) if result else "Unknown"

static func get_row_properties(row: DatatableRow) -> Array:
	var row_props: Array = []
	var prop_list = row.get_script().get_script_property_list()
	for prop in prop_list:
		if prop.type != TYPE_NIL:
			row_props.append(prop)
	return row_props

static func move_row_stable(datatable: Datatable, old_key, new_key):
	var new_data = Dictionary()
	var all_keys = datatable.data.keys()
	var all_values = datatable.data.values()
	var key_idx = all_keys.find(old_key)
	
	for i in range(0, all_keys.size()):
		if i != key_idx:
			new_data[all_keys[i]] = all_values[i]
		else:
			new_data[new_key] = all_values[i]
	datatable.data = new_data

static func validate_datatable_keys(datatable: Datatable) -> bool:
	var default_props = get_row_properties(datatable.default_row)
	for key in datatable.data.keys():
		if typeof(key) != datatable.key_type:
			push_error("Found bad key ", key, "type should be ", datatable.key_type, " got ", typeof(key))
			return false
	return true
