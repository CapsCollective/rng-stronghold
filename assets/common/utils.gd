class_name Utils

const VERSION_CONFIG_SETTING: String = "application/config/version"

const LogFlags = [
	"Resources",
	"Units",
	"Actions",
	"Combat"
]

static func push_info(flag: String, arg2 = "", arg3 = "", arg4 = "", arg5 = "", arg6 = "", arg7 = "", arg8 = ""):
	#if LogFlags.has(flag):
	print(flag, ": ", arg2, arg3, arg4, arg5, arg6, arg7, arg8)

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

static func delete_children(node: Node):
	if not node: return
	for n in node.get_children():
		n.queue_free()
