extends Control

var dl_name_lbl: Label
var refresh_btn: Button
var new_dl_btn: Button
var graph_edit: GraphEdit

var current_ds: DialogueScript

func _ready():
	build_layout()
	refresh_graph()

func set_current_dialogue_script(dialogue_script: DialogueScript):
	current_ds = dialogue_script
	refresh_graph()

func build_layout():
	custom_minimum_size.y = 200 * EditorInterface.get_editor_scale()
	anchors_preset = PRESET_BOTTOM_WIDE
	size_flags_vertical = Control.SIZE_SHRINK_BEGIN | Control.SIZE_EXPAND
	
	var main_vbox = VBoxContainer.new()
	main_vbox.layout_mode = 1
	main_vbox.anchors_preset = Control.PRESET_FULL_RECT
	add_child(main_vbox)
	
	var top_hbox = HBoxContainer.new()
	main_vbox.add_child(top_hbox)
	
	dl_name_lbl = Label.new()
	dl_name_lbl.text = "Dialogue"
	top_hbox.add_child(dl_name_lbl)
	
	new_dl_btn = Button.new()
	new_dl_btn.flat = true
	new_dl_btn.theme = theme
	new_dl_btn.icon = get_theme_icon("New", "EditorIcons")
	new_dl_btn.tooltip_text = "Create a new dialogue script."
	new_dl_btn.pressed.connect(on_new_dl_btn_pressed)
	top_hbox.add_child(new_dl_btn)
	
	top_hbox.add_spacer(false)
	
	refresh_btn = Button.new()
	refresh_btn.text = "Refresh"
	refresh_btn.pressed.connect(on_refresh_btn_pressed)
	top_hbox.add_child(refresh_btn)
	
	graph_edit = GraphEdit.new()
	graph_edit.anchors_preset = Control.PRESET_FULL_RECT
	graph_edit.size_flags_vertical = Control.SIZE_EXPAND_FILL
	main_vbox.add_child(graph_edit)

func refresh_graph():
	reset_graph()
	populate_graph()

func reset_graph():
	new_dl_btn.text = "No Script Selected"

func populate_graph():
	print(graph_edit.get_connection_list())
	for c in graph_edit.get_children():
		print(c.name)
	Utils.queue_free_children(graph_edit)
	graph_edit.add_valid_connection_type(0, 0)
	var create_node = func():
		var node: GraphNode = GraphNode.new()
		node.title = "Execute Dialogue Line"
		node.set_slot(0, true, 0, Color.WHITE, true, 0, Color.WHITE)
		graph_edit.add_child(node)
		var label = Label.new()
		label.text = "0"
		node.add_child(label)
		return node
	
	var node1 = create_node.call()
	var node2 = create_node.call()
	var node3 = create_node.call()
	var node4 = create_node.call()
	
	graph_edit.right_disconnects = true
	graph_edit.connection_request.connect(on_connection_request)
	graph_edit.disconnection_request.connect(on_disconnection_request)

func on_disconnection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int):
	graph_edit.disconnect_node(from_node, from_port, to_node, to_port)

func on_connection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int):
	if from_node == to_node:
		return
	graph_edit.connect_node(from_node, from_port, to_node, to_port)

func on_refresh_btn_pressed():
	refresh_graph()

func on_add_btn_pressed():
	pass

func on_delete_btn_pressed(row):
	pass

func on_new_dl_btn_pressed():
	pass
