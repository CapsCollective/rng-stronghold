class_name Utils

const VERSION_CONFIG_SETTING: String = "application/config/version"

static func push_info(arg1 = "", arg2 = "", arg3 = "", arg4 = "", arg5 = "", arg6 = "", arg7 = "", arg8 = ""):
	print(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8)

static func log_info(category_name: String, arg1 = "", arg2 = "", arg3 = "", arg4 = "", arg5 = "", arg6 = "", arg7 = ""):
	push_info("LOG_INFO_" + category_name + ": ", arg1, arg2, arg3, arg4, arg5, arg6, arg7)
	
static func log_warn(category_name: String, arg1 = "", arg2 = "", arg3 = "", arg4 = "", arg5 = "", arg6 = "", arg7 = ""):
	push_info("LOG_WARN_" + category_name + ": ", arg1, arg2, arg3, arg4, arg5, arg6, arg7)
	
static func log_error(category_name: String, arg1 = "", arg2 = "", arg3 = "", arg4 = "", arg5 = "", arg6 = "", arg7 = ""):
	push_info("LOG_ERROR_" + category_name + ": ", arg1, arg2, arg3, arg4, arg5, arg6, arg7)

static func get_version() -> String:
	return ProjectSettings.get_setting(VERSION_CONFIG_SETTING)

static func roll_dice(dice: Dictionary) -> Array:
	var rolls = []
	for tier in dice:
		for i in dice[tier]:
			rolls.append({
				"roll": randi_range(1, tier),
				"tier": tier
			})
	rolls.sort_custom(func(a, b):
		if (a.roll == b.roll):
			return a.tier < b.tier
		return a.roll > b.roll
	)
	return rolls

static func queue_free_children(node: Node):
	if not node: return
	for n in node.get_children():
		n.queue_free()
