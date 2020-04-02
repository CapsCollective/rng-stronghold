extends Sprite

func setup(observer, signals):
	$UpButton.connect("button_up", observer, "emit_signal", [signals[0]])
	$DownButton.connect("button_up", observer, "emit_signal", [signals[1]])
	$ConfirmButton.connect("button_up", observer, "emit_signal", [signals[2]])

func set_title(text):
	$TitleLabel.text = text

func set_confirm(text):
	$ConfirmButton/Label.text = text

func set_number(val):
	$NumberLabel.text = str(val)

func set_disabled(disabled):
	$Shade.visible = disabled
