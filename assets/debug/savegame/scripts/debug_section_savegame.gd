extends DebugSection

@onready var savegame_text: RichTextLabel = $SavegameText

var regex: RegEx = RegEx.new()

func _ready():
	regex.compile("(\"[A-z0-9]*\":)")

func on_opened():
	var json_string = JSON.stringify(Savegame.get_dump(), "\t")
	json_string = regex.sub(json_string, "[b]$1[/b]", true)
	savegame_text.text = json_string
