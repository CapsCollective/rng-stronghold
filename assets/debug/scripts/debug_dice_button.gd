@tool
class_name DebugDiceButton extends Button

var textures: Dictionary = {
	4: preload("res://assets/icons/d4.svg"),
	6: preload("res://assets/icons/d6.svg"),
	8: preload("res://assets/icons/d8.svg")
}

@export var tier: int:
	set(val):
		tier = val
		icon = textures[tier]

@export var roll: int:
	set(val):
		roll = val
		text = str(val)
		
@export var hostile: bool:
	set(val):
		hostile = val
		if hostile:
			add_theme_color_override("icon_normal_color", Color.RED)
		else:
			remove_theme_color_override("icon_normal_color")
