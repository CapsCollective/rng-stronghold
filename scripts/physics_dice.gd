extends RigidBody2D

var val = null

func _ready():
	set_bounce(0.7)
	add_torque(-100000)
	$Timer.connect("timeout", self, "finish")

func finish():
	input_pickable = true
	set_mode(RigidBody2D.MODE_STATIC)
	$AnimationPlayer.play("rest")
	var new_dice = preload("res://scenes/ui_dice.tscn").instance()
	new_dice.val = val
	new_dice.position = position
	get_parent().add_child(new_dice)
	queue_free()
