class_name Barrier extends Building

signal health_updated
signal max_health_updated

var health: int:
	get:
		if not Savegame.player: return 0
		print(Savegame.player.barrier_health.get(title, max_health))
		return Savegame.player.barrier_health.get(title, max_health)
	set(val):
		health = val
		Savegame.player.barrier_health[title] = val
		health_updated.emit()

@export var max_health: int:
	set(val):
		max_health = val
		max_health_updated.emit()
		if health > max_health:
			health = max_health

func _ready():
	super._ready()
	GameManager.new_game.connect(reset)

func reset():
	health = max_health
