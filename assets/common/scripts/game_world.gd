extends Node

@export_file("*.scn", "*.tscn") var default_transition_scene: String
@export_file("*.scn", "*.tscn") var entrypoint_scene: String

func _ready():
	load_scene(entrypoint_scene)

func load_scene(scene_path: String, _transition_scene: String = default_transition_scene):
	var new_scene = ResourceLoader.load(scene_path).instantiate()
	for child in $CurrentScene.get_children():
		child.queue_free()
	$CurrentScene.add_child(new_scene)
