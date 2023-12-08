class_name ResultDie extends CharacterBody3D

var value: int

var initial_position: Vector3
var drag_offset: Vector3

var drag_time: int = 0
var mouse_over: bool = false
var mouse_dragging: bool = false

func initialise(pos: Vector3, rot: Vector3, result: int):
	position = pos
	rotation = rot
	value = result
	initial_position = global_position

func _input(event):
	if event.is_action_pressed("lmb_down") and mouse_over:
		var collision_point = get_perspective_collision_ray_point(false, 4)
		drag_offset = global_position - collision_point
		drag_time = Time.get_ticks_msec()
		mouse_dragging = true
		GameManager.get_selected_building().selected_die = self
		get_viewport().set_input_as_handled()
	elif event.is_action_released("lmb_down") and mouse_dragging:
		drag_time = Time.get_ticks_msec()
		mouse_dragging = false
		mouse_over = false
		GameManager.get_selected_building().selected_die = null
		get_viewport().set_input_as_handled()

func _process(_delta):
	var time_since_drag = float(Time.get_ticks_msec() - drag_time)
	var interp = clamp(time_since_drag / 1000, 0.0, 1.0)
	var target_position = global_position
	if mouse_dragging:
		var collision_point = get_perspective_collision_ray_point(true, 2)
		target_position = collision_point + drag_offset
	else:
		target_position = initial_position
	
	if not global_position.is_equal_approx(target_position):
		global_position = lerp(global_position, target_position, interp)

func _mouse_enter():
	mouse_over = true

func _mouse_exit():
	mouse_over = false

func get_perspective_collision_ray_point(collide_with_areas: bool, mask: int) -> Vector3:
	var viewport: Viewport = get_viewport()
	var mouse_position: Vector2 = viewport.get_mouse_position()
	var camera: Camera3D = viewport.get_camera_3d()
	var origin: Vector3 = camera.project_ray_origin(mouse_position)
	var direction: Vector3 = camera.project_ray_normal(mouse_position)
	var end: Vector3 = origin + direction * camera.far
	var query = PhysicsRayQueryParameters3D.create(origin, end)
	query.collide_with_areas = collide_with_areas
	query.collision_mask = mask
	var result := get_world_3d().direct_space_state.intersect_ray(query)
	return result.get("position", end)
