class_name ActionDisplay extends Control

var action: DiceAction
var mouse_over: bool = false

func _ready():
	$ColorRect.mouse_entered.connect(on_mouse_entered)
	$ColorRect.mouse_exited.connect(on_mouse_exited)

func initialise(dice_action: DiceAction):
	action = dice_action
	action.action_updated.connect(update_display)
	update_display()

func on_mouse_entered():
	mouse_over = true
	if Input.is_action_pressed("lmb_down"):
		var die = GameManager.get_selected_building().selected_die
		if die and action.is_valid_roll(die.value):
			$ColorRect.color = Color.GREEN
		else:
			$ColorRect.color = Color.RED

func on_mouse_exited():
	mouse_over = false
	$ColorRect.color = Color.WHITE

func on_die_deselected(die: ResultDie):
	if mouse_over:
		if action.assign_roll(die.value):
			Utils.log_info("Dice", "Dropped die value of ", die.value, " on action ", action.name)
			die.queue_free()
			$ColorRect.color = Color.GREEN
		

func update_display():
	%Title.text = action.name
	%Value.text = str(action.remaining_points) if not action.is_complete else "Complete"
	%Description.text = "\n".join(action.description)
