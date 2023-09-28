extends Node

const LogFlags = [
	"debug_stats"
]


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
	if !valid_resource(resource):
		print("Resource: ", resource, " is not a valid resource type")
		return
	if value < 0: 
		print("Resource: Cannot have fewer than 0 of any ", resource)
		return
	if LogFlags.has("debug_stats"):
		print("Resource: Setting ", resource, " to ", value)
	Savegame.player.resources[resource] = value
	resource_changed.emit(resource, value)
	
func change_resource(resource: String, change: int):
	if !has_resource(resource, change):
		print("Resource: ", resource, " has less than ", change)

	set_resource(resource, Savegame.player.resources[resource] + change)

func has_resource(resource: String, required: int) -> bool:
	return Savegame.player.resources[resource] >= required


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
		print("Units: Not enough d", tier, " to assign")
		return
	
	if LogFlags.has("debug_stats"):
		print("Units: Assigning ",change, " d", tier, ", ", get_available_units(tier), " available")
	
	Savegame.player.units[tier].assigned += change
	units_changed.emit(tier)
	
func reset_assigned_units():
	for tier in DiceTiers:
		Savegame.player.units[tier].assigned = 0
		units_changed.emit(tier)
