extends Camera2D

var camera_speed = 5
var zoomed = false
onready var resting_pos = global_position
onready var target_zoom = Vector2(1, 1)
onready var target_position = resting_pos

func _process(delta):
	if zoom != target_zoom:
		zoom = zoom.linear_interpolate(target_zoom, delta*camera_speed)
	if position != target_position:
		position = position.linear_interpolate(target_position, delta*camera_speed)

func zoom_to(zoom_position, zoom_amount):
	target_zoom = Vector2(zoom_amount, zoom_amount)
	target_position = zoom_position
	zoomed = true

func reset():
	target_zoom = Vector2(1, 1)
	target_position = resting_pos
	zoomed = false
