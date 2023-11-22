extends RollDie

func check_result():
	var result = -1
	if is_up(basis.x):
		result = 6
	elif is_up(basis.z):
		result = 5
	elif is_up(basis.y):
		result = 4
	elif is_up(-basis.y):
		result = 3
	elif is_up(-basis.z):
		result = 2
	elif is_up(-basis.x):
		result = 1
	roll_completed.emit(self, result)
