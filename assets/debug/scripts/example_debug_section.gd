extends DebugSection

func _ready():
	$VBoxContainer/Button.button_up.connect(on_button_up)

func on_refresh():
	print("Refresh!")

func on_button_up():
	print("Button Up!")
