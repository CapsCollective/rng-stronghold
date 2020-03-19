extends RigidBody2D

var val = null
var comabt_dice = false
var is_enemy_dice = false

func _ready():
	set_bounce(0.7)
	add_torque(-50000)
	$Timer.connect("timeout", self, "finish")
	if is_enemy_dice:
		modulate = Color(0.780392, 0.203922, 0.203922)

func finish():
	var new_dice
	if comabt_dice:
		new_dice = preload("res://scenes/combat_dice.tscn").instance()
		new_dice.is_enemy_dice = is_enemy_dice
	else:
		new_dice = preload("res://scenes/ui_dice.tscn").instance()
	new_dice.val = val
	new_dice.position = position
	new_dice.rotation = rotation
	get_parent().add_child(new_dice)
	queue_free()
