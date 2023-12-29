extends Control

enum ExampleDialogueDisplayMode {
	HIDDEN,
	LINE,
	OPTIONS
}

class ExampleContext:
	var player = ExamplePlayer.new()
	var state = ExampleState.new()

class ExamplePlayer:
	var hp = 1

class ExampleState:
	var line = false

const DialogueOption = preload("res://addons/dialogue/example/dialogue_example_option.tscn")

var ds: DialogueScript
var context = ExampleContext.new()

@onready var dialogue_box: Control = %DialogueBox
@onready var dialogue_box_line: Control = %DialogueLine
@onready var dialogue_box_speaker_label: Control = %SpeakerLabel
@onready var dialogue_box_line_label: RichTextLabel = %DialogueLineLabel
@onready var dialogue_box_line_continue_button: Button = %ContinueButton
@onready var dialogue_box_options: Control = %DialogueOptions

func _ready():
	set_display_mode(ExampleDialogueDisplayMode.HIDDEN)
	
	ds = DialogueScript.new("res://addons/dialogue/example/example_dialogue.json")
	ds.context_object = context
	ds.ended.connect(func():
		set_display_mode(ExampleDialogueDisplayMode.HIDDEN)
	)
	ds.line_executed.connect(func(line):
		dialogue_box_line_continue_button.pressed.connect(on_continue_button_pressed)
		dialogue_box_line_label.text = line.raw_text
		dialogue_box_speaker_label.text = "%s: "%[line.speaker_id]
		set_display_mode(ExampleDialogueDisplayMode.LINE)
	)
	ds.options_executed.connect(func(options):
		for key in options.keys():
			var option = options[key]
			var dialogue_option = DialogueOption.instantiate()
			dialogue_option.set_text(option.raw_text)
			dialogue_option.set_value(key)
			dialogue_option.selected.connect(on_dialogue_option_selected)
			dialogue_box_options.add_child(dialogue_option)
		set_display_mode(ExampleDialogueDisplayMode.OPTIONS)
	)
	ds.advanced_with_option.connect(func(option_id):
		for option in dialogue_box_options.get_children():
			option.queue_free()
	)
	ds.start()

func on_dialogue_option_selected(idx: int):
	ds.advance_with_option(idx)

func on_continue_button_pressed():
	dialogue_box_line_continue_button.pressed.disconnect(on_continue_button_pressed)
	ds.advance()

func set_display_mode(mode: ExampleDialogueDisplayMode):
	dialogue_box.visible = mode != ExampleDialogueDisplayMode.HIDDEN
	dialogue_box_line.visible =  mode == ExampleDialogueDisplayMode.LINE
	dialogue_box_options.visible = mode == ExampleDialogueDisplayMode.OPTIONS
