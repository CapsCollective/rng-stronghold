class_name DragPlaneArea extends Area3D

@export var cursor: Node3D

func _input(event):
	if event.is_action_released("ui_copy"):
		if is_plane_disabled():
			set_plane_disabled(false)
		else:
			set_plane_disabled(true)

func is_plane_disabled() -> bool:
	return $SeparationPlane.disabled

func set_plane_disabled(disabled: bool):
	$SeparationPlane.disabled = disabled

func _process(_delta):
	var viewport := get_viewport()
	var mouse_position := viewport.get_mouse_position()
	var camera := viewport.get_camera_3d()
	var origin := camera.project_ray_origin(mouse_position)
	var direction := camera.project_ray_normal(mouse_position)
	var end := origin + direction * camera.far
	var query := PhysicsRayQueryParameters3D.create(origin, end)
	query.collide_with_areas = true
	query.collision_mask = 2
	var result := get_world_3d().direct_space_state.intersect_ray(query)
	var world_position: Vector3 = result.get("position", end)
	cursor.global_position = world_position
