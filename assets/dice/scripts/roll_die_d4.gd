extends RollDie

func check_result():
	var result = -1
	if is_up(basis.y):
		result = 1
	elif is_up($Dir2.get_global_transform().basis.z):
		result = 2
	elif is_up($Dir3.get_global_transform().basis.z):
		result = 3
	elif is_up($Dir4.get_global_transform().basis.z):
		result = 4
	roll_completed.emit(self, result)
