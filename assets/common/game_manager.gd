extends Node

signal load_completed

signal new_turn
signal new_game

signal resource_changed(resource: String, value: int)
signal units_changed(tier: int)

var current_level: Level

func _ready():
	Savegame.load_file()
	Utils.log_info("Deserialisation", Savegame.get_dump())
	if Savegame.player.turn == 0:
		reset_game()
	load_completed.emit()

# Level
func register_level(level: Level):
	current_level = level

func deregister_level(level: Level):
	if level == current_level:
		current_level = null

# Turn
func get_turn():
	return Savegame.player.turn

func next_turn():
	Savegame.player.turn += 1
	reset_assigned_units()
	
	var total_units = get_total_units()
	if has_resource("water", total_units): 
		change_resource("water", -total_units)
	if has_resource("food", total_units): 
		change_resource("food", -total_units)
	
	new_turn.emit()
	Savegame.save_file()

func reset_game():
	Savegame.player.turn = 1
	reset_units()
	reset_resources()
	set_resource("water", 20)
	set_resource("food", 40)
	set_resource("gold", 10)
	new_game.emit()

# Resources
const Resources: Array = [
	"water",
	"food",
	"gold",
	"wheat",
	"flour",
	"ale"
]

func valid_resource(resource: String) -> bool:
	return Resources.has(resource)

func get_resource(resource: String):
	if not valid_resource(resource):
		Utils.log_warn("Resource", resource, " is not a valid resource type")
		return
	if not Savegame.player.resources.has(resource):
		Savegame.player.resources[resource] = 0
		return 0
	return Savegame.player.resources[resource]

func set_resource(resource: String, value: int): 
	if not valid_resource(resource):
		Utils.log_warn("Resource", resource, " is not a valid resource type")
		return
	if value < 0: 
		Utils.log_warn("Resource", "Cannot have fewer than 0 of any ", resource)
		return
		
	Utils.log_info("Resource", "Setting ", resource, " to ", value)
	Savegame.player.resources[resource] = value
	resource_changed.emit(resource, value)

func change_resource(resource: String, change: int):
	if not has_resource(resource, -change):
		Utils.log_warn("Resource", resource, " has less than ", change)
		return
	set_resource(resource, get_resource(resource) + change)

func has_resource(resource: String, required: int) -> bool:
	return get_resource(resource) >= required

func reset_resources():
	for resource in Resources:
		set_resource(resource, 0)

# Units
const DiceTiers: Array = [4,6,8]

func valid_dice_tier(tier: int) -> bool:
		return DiceTiers.has(tier)

func get_total_units():
	var total = 0
	for units in Savegame.player.units.values():
		total += units.total
	return total

func get_available_units(tier: int) -> int:
	return Savegame.player.units[tier].total - Savegame.player.units[tier].assigned

func set_total_units(tier: int, value: int):
	Savegame.player.units[tier].total = value
	units_changed.emit(tier)

func change_assigned_units(tier: int, change: int):
	if get_available_units(tier) < change:
		Utils.log_warn("Units", "Not enough d", tier, " to assign")
		return
	
	Utils.log_info("Units", "Assigning ",change, " d", tier, ", ", get_available_units(tier), " available")
	Savegame.player.units[tier].assigned += change
	units_changed.emit(tier)
	
func reset_assigned_units():
	for tier in DiceTiers:
		Savegame.player.units[tier].assigned = 0
		units_changed.emit(tier)

func reset_units():
	GameManager.set_total_units(4, 4)
	GameManager.set_total_units(6, 2)
	GameManager.set_total_units(8, 0)
	reset_assigned_units()
