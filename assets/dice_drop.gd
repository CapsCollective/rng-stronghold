extends ColorRect

var mouse_over: bool = false

func _ready():
	mouse_entered.connect(on_mouse_entered)
	mouse_exited.connect(on_mouse_exited)
	await get_tree().create_timer(0.2).timeout
	GameManager.current_scenario.building_selected.connect(on_building_selected)
	GameManager.current_scenario.building_deselected.connect(on_building_deselected)

func on_mouse_entered():
	mouse_over = true
	if Input.is_action_pressed("lmb_down"):
		color = Color.RED

func on_mouse_exited():
	mouse_over = false
	color = Color.WHITE

func on_building_selected(building: Building):
	building.die_deselected.connect(on_die_deselected)

func on_building_deselected(building: Building):
	building.die_deselected.disconnect(on_die_deselected)

func on_die_deselected(die: ResultDie):
	if mouse_over:
		print("dropped die: ", die.value)
		die.queue_free()
		color = Color.GREEN
