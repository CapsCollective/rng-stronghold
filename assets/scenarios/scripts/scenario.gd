class_name Scenario extends Node3D

var game_cam: GameCamera
var buildings: Array[Building]
var selected_building: Building

func _ready():
	game_cam = Utils.get_first_node_with_script(self, GameCamera)
	var found_buildings = Utils.get_all_nodes_with_script(self, Building)
	for building in found_buildings:
		buildings.append(building)
		building.selected.connect(on_building_selected)
		building.deselected.connect(on_building_deselected)
	GameManager.register_scenario(self)

func _exit_tree():
	GameManager.deregister_scenario(self)

func on_building_selected(building: Building):
	Utils.log_info("Selection", "selected ", building.name)
	selected_building = building
	if not building.cam_zoom:
		Utils.log_warn("Camera", "No camera zoom position set for building ", name)
		return
	game_cam.move_to_position(building.cam_zoom.global_position)

func on_building_deselected(building: Building):
	selected_building = null
	game_cam.reset_position()
	Utils.log_info("Selection", "deselected ", building.name)
