class_name ActionDisplay extends Control

var action: DiceAction
var mouse_over: bool = false

func _ready():
	$ColorRect.mouse_entered.connect(on_mouse_entered)
	$ColorRect.mouse_exited.connect(on_mouse_exited)

func initialise(dice_action: DiceAction):
	action = dice_action
	$ColorRect/Title.text = action.name

func on_mouse_entered():
	mouse_over = true
	if Input.is_action_pressed("lmb_down"):
		$ColorRect.color = Color.RED

func on_mouse_exited():
	mouse_over = false
	$ColorRect.color = Color.WHITE

func on_die_deselected(die: ResultDie):
	if mouse_over:
		Utils.log_info("Dice", "Dropped die value of ", die.value, " on action ", action.name)
		die.queue_free()
		$ColorRect.color = Color.GREEN
