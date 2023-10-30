class_name ActionGroup extends Node

signal health_updated

@export var title: String

@export var max_health: int:
	set(val):
		max_health = val
		if health > max_health:
			health = max_health
		health_updated.emit()

var health: int:
	get:
		if not Savegame.player: return 0
		return Savegame.player.barrier_health.get(title, max_health)
	set(val):
		health = val
		Savegame.player.barrier_health[title] = val
		health_updated.emit()

func _ready():
	GameManager.new_game.connect(func(): health = max_health)

func get_actions() -> Array[DiceAction]:
	var actions: Array[DiceAction] = []
	for child in get_children():
		if child is DiceAction:
			actions.append(child)
	return actions
