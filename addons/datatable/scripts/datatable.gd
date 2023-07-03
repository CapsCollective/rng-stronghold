class_name Datatable extends Resource

@export var key_type: Variant.Type = TYPE_NIL
@export var default_row: DatatableRow
@export var data: Dictionary

var iterator_idx: int = 0

func is_empty() -> bool:
	return data.is_empty()

func size() -> int:
	return data.size()

func has(key: Variant) -> bool:
	return data.has(key)

func get_key(idx: int) -> Variant:
	var keys = data.keys()
	if idx >= 0 and idx < keys.size():
		return keys[idx]
	return null

func get_row(idx: int) -> DatatableRow:
	var key = get_key(idx)
	return data[key] if key != null else null

func get_row_pair(idx: int) -> DatatableRowPair:
	var key = get_key(idx)
	if key != null:
		return DatatableRowPair.new(key, data[key])
	return null

func find_row(key: Variant) -> DatatableRow:
	return data.find_key(key)

func find_row_pair(key: Variant) -> DatatableRowPair:
	var value = data.find_key(key)
	if value != null:
		return DatatableRowPair.new(key, value)
	return null

func should_continue():
	return (iterator_idx < size())

func _iter_init(arg):
	iterator_idx = 0
	return should_continue()

func _iter_next(arg):
	iterator_idx += 1
	return should_continue()

func _iter_get(arg) -> DatatableRowPair:
	return get_row_pair(iterator_idx)

func move_row(old_key, new_key):
	var row_value = data.get(old_key)
	data.erase(old_key)
	data[new_key] = row_value

class DatatableRowPair:
	var key: Variant
	var row: DatatableRow
	
	func _init(key, row: DatatableRow):
		self.key = key
		self.row = row
	
	func _to_string() -> String:
		return "(%s, %s)" % [key, row.to_string()]
