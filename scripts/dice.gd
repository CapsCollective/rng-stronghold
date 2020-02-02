extends RigidBody2D

export var val = 3

func _ready():
	set_bounce(0.7)
	add_torque(-100000)
	$Timer.connect("timeout", self, "finish")


func finish():
	set_mode(RigidBody2D.MODE_STATIC)
	$AnimationPlayer.play("rest")
	$Sprite.texture = load("res://res/dice_" + str(val) + ".png")
