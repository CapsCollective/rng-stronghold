extends Node

func _ready():
	print(Savegame.player.turn, "turn")
	if Savegame.player.turn == 0:
		reset_game()

# Turn
signal new_turn
signal new_game

func next_turn():
	Savegame.player.turn += 1
	reset_assigned_units()
	new_turn.emit()
	Savegame.save_file()

func reset_game():
	Savegame.player.turn = 1
	print("reset")
	reset_units()
	reset_resources()
	new_game.emit()

# Resources
const Resources: Array = [
	"water",
	"food",
	"gold",
]

signal resource_changed(resource: String, value: int)
signal units_changed(tier: int)

func valid_resource(resource: String) -> bool:
	return Resources.has(resource)

func set_resource(resource: String, value: int): 
	if not valid_resource(resource):
		push_warning("Resource: ", resource, " is not a valid resource type")
		return
	if value < 0: 
		push_warning("Resource: Cannot have fewer than 0 of any ", resource)
		return
		
	Utils.push_info("Resource", "Setting ", resource, " to ", value)
	Savegame.player.resources[resource] = value
	resource_changed.emit(resource, value)
	
func change_resource(resource: String, change: int):
	if !has_resource(resource, change):
		print("Resource: ", resource, " has less than ", change)

	set_resource(resource, Savegame.player.resources[resource] + change)

func has_resource(resource: String, required: int) -> bool:
	return Savegame.player.resources[resource] >= required

func reset_resources():
	for resource in Resources:
		set_resource(resource, 0)

# Units
const DiceTiers: Array = [4,6,8]

func valid_dice_tier(tier: int) -> bool:
		return DiceTiers.has(tier)

func get_available_units(tier: int) -> int:
	return Savegame.player.units[tier].total - Savegame.player.units[tier].assigned

func set_total_units(tier: int, value: int):
	Savegame.player.units[tier].total = value
	units_changed.emit(tier)

func change_assigned_units(tier: int, change: int):
	if get_available_units(tier) < change:
		push_warning("Units: Not enough d", tier, " to assign")
		return
	
	Utils.push_info("Units", "Assigning ",change, " d", tier, ", ", get_available_units(tier), " available")
	Savegame.player.units[tier].assigned += change
	units_changed.emit(tier)
	
func reset_assigned_units():
	for tier in DiceTiers:
		Savegame.player.units[tier].assigned = 0
		units_changed.emit(tier)

func reset_units():
	GameManager.set_total_units(4, 4)
	GameManager.set_total_units(6, 2)
	GameManager.set_total_units(8, 1)
	reset_assigned_units()
