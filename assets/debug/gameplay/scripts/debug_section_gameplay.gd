extends DebugSection

const debug_action_group_scene = preload("res://assets/debug/gameplay/scenes/debug_action_group.tscn")
const debug_combat_scene = preload("res://assets/debug/gameplay/scenes/debug_combat.tscn")

@onready var next_turn_button: Button = %NextTurnButton
@onready var reset_game_button: Button = %ResetGameButton
@onready var building_container: TabContainer = %BuildingsDebugPanel

func _ready():
	next_turn_button.pressed.connect(GameManager.next_turn)
	reset_game_button.pressed.connect(GameManager.reset_game)

func on_opened():
	var action_groups = Utils.get_all_nodes_with_script(get_tree().root, ActionGroup)
	for action_group in action_groups:
		if not action_group.get_actions().is_empty():
			var debug_action_group: DebugActionGroup = debug_action_group_scene.instantiate()
			debug_action_group.action_group = action_group
			building_container.add_child(debug_action_group)
		if action_group.max_health > 0:
			var debug_combat: DebugCombat = debug_combat_scene.instantiate()
			debug_combat.action_group = action_group
			building_container.add_child(debug_combat)

func on_closed():
	Utils.queue_free_children(building_container)
