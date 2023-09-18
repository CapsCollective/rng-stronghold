class_name Utils

const VERSION_CONFIG_SETTING: String = "application/config/version"

static func push_info(arg1 = "", arg2 = "", arg3 = "", arg4 = "", arg5 = "", arg6 = "", arg7 = "", arg8 = ""):
	print(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8)

static func get_version() -> String:
	return ProjectSettings.get_setting(VERSION_CONFIG_SETTING)
