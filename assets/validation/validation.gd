class_name ValidationManager

const validations = []

func run_all_validations() -> bool:
	print("Running all validations...")
	var result = true
	for validation in validations:
		var v = validation.new()
		print("- Running validation for %s..." % v._name())
		if not v._run_validations():
			print("    VALIDATION FAILED")
			result = false
	if result:
		print("All validations passed!")
	else:
		print("Some validations failed - see above for more info.")
	return result

class Validation:
	
	func _name() -> String:
		return "Validation"
	
	func _run_validations() -> bool:
		return true
