extends Panel

func _ready():
	get_parent().refresh.connect(on_refresh)
	$VBoxContainer/Button.button_up.connect(on_button_up)

func on_refresh():
	print("Refresh!")

func on_button_up():
	print("Button Up!")
