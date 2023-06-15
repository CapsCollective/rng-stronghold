class_name DatatableRow extends Resource

func get_row_name() -> String:
	return DatatableUtils.get_row_name(self)

func get_row_properties() -> Array:
	return DatatableUtils.get_row_properties(self)
