extends Area2D

var val
var is_enemy_dice
var final_position
var lifted = false
var finished_rotating = false
var finished_moving = false
var finished_resizing = false
var forgiveness = 1

func _ready():
	if is_enemy_dice:
		modulate = Color(0.780392, 0.203922, 0.203922)
	final_position = get_parent().get_parent().position
	$Sprite.texture = load("res://res/dice/dice_" + str(val) + ".png")
	scale = Vector2(0.5, 0.5)

func _process(delta):
	if finished_rotating:
		var new_position = position.linear_interpolate(final_position, delta*5)
		var distance = abs(final_position.length() - new_position.length())
		if distance < forgiveness and distance > -forgiveness:
			if not finished_moving:
				position = final_position
				get_parent().get_parent().finished_rolling(self)
				finished_moving = true
		else:
			position = new_position
	else:
		rotation = 0 + rotation / 1.5
		if rotation < 0.01:
			rotation = 0
			finished_rotating = true
	
	if not finished_resizing:
		scale = scale.linear_interpolate(Vector2.ONE, delta*5)
		if scale == Vector2.ONE:
			finished_resizing = true
