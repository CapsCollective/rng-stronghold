class_name DatatableRow extends Resource

func get_row_properties() -> Array:
	var row_props: Array = []
	var prop_list = get_script().get_script_property_list()
	for prop in prop_list:
		if prop.type != TYPE_NIL:
			row_props.append({"name": prop.name, "type": prop.type, "value":get(prop.name)})
	return row_props
