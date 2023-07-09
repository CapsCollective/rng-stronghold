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

func get_row_by_index(idx: int) -> DatatableRow:
	var key = get_key(idx)
	return data[key] if key != null else null

func get_row_pair_by_index(idx: int) -> Dictionary:
	var key = get_key(idx)
	if key != null:
		return create_row_pair(key, data[key])
	return {}

func get_row(key: Variant) -> DatatableRow:
	return data.get(key)

func get_row_pair(key: Variant) -> Dictionary:
	var value = data.find_key(key)
	if value != null:
		return create_row_pair(key, value)
	return {}

func move_row(old_key, new_key):
	var row_value = data.get(old_key)
	data.erase(old_key)
	data[new_key] = row_value

func _iter_init(arg):
	iterator_idx = 0
	return iter_can_continue()

func _iter_next(arg):
	iterator_idx += 1
	return iter_can_continue()

func _iter_get(arg) -> Dictionary:
	return get_row_pair_by_index(iterator_idx)

func iter_can_continue():
	return iterator_idx < size()

func create_row_pair(key: Variant, row: DatatableRow):
	return {"key": key, "value": data[key]}
