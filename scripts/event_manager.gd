extends Node2D

enum Resources {FOOD, WATER, WALL, ARMS, INFLUENCE}

var events = {
	'Food Rots!': {
		
	},
	'Water Poisoned!': {},
	'Riots Break Out!': {},
	'Walls Start to Crumble!': {},
	'Weapons Rust': {},
}

func _ready():
	print(Resources.INFLUENCE)
