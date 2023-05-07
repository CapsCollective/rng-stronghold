class_name ValidationManager

const validations = []

func run_all_validations() -> bool:
	print("Running all validations...")
	var result = true
	for validation in validations:
		var v = validation.new()
		print("- Running validation for %s..." % v.get_name())
		if not v.run_validations():
			print("    VALIDATION FAILED")
			result = false
	if result:
		print("All validations passed!")
	else:
		print("Some validations failed - see above for more info.")
	return result

class Validation:
	
	func get_name() -> String:
		return "Validation"
	
	func run_validations() -> bool:
		return true
