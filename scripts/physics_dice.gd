extends RigidBody2D

var val = null

func _ready():
	set_bounce(0.7)
	add_torque(-50000)
	$Timer.connect("timeout", self, "finish")

func finish():
	var new_dice = preload("res://scenes/ui_dice.tscn").instance()
	new_dice.val = val
	new_dice.position = position
	new_dice.rotation = rotation
	get_parent().add_child(new_dice)
	queue_free()
