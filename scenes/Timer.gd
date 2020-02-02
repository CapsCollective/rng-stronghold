extends Timer

func _ready():
	connect("timeout", self, "finish")

func finish():
	$"../Dice".set_mode(RigidBody2D.MODE_STATIC)
	#$"../Dice".gravity_scale = 0
	#$"../Dice/CollisionPolygon2D".disabled = true
	$"../Dice/AnimationPlayer".play("rest")
