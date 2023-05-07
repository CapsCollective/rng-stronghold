class_name ValidationManager

const utils = preload("res://assets/common/utils.gd") 
const validations = []

func run_all_validations() -> bool:
	utils.push_log("Running all validations...")
	var result = true
	for validation in validations:
		var v = validation.new()
		utils.push_log("- Running validation for ", v.get_name(), "...")
		if not v.run_validations():
			push_error("    VALIDATION FAILED")
			result = false
	if result:
		utils.push_log("All validations passed!")
	else:
		push_error("Some validations failed - see above for more info.")
	return result

class Validation:
	
	func get_name() -> String:
		return "Validation"
	
	func run_validations() -> bool:
		return true
