class_name DragPlaneArea extends Area3D

func _input(event):
	if event.is_action_released("ui_copy"):
		if is_plane_disabled():
			set_plane_disabled(false)
		else:
			set_plane_disabled(true)

func is_plane_disabled() -> bool:
	return $VerticalSeparationPlane.disabled

func set_plane_disabled(disabled: bool):
	$VerticalSeparationPlane.disabled = disabled
	$HorzontalSeparationPlane.disabled = disabled
