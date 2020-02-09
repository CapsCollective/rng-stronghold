extends ToolButton

func _ready():
	connect("button_up", self, "click")

func click():
	var timer = $Timer
	if not timer:
		timer = Timer.new()
		timer.set_one_shot(true)
		add_child(timer)
	timer.connect("timeout", self, "change_back")
	timer.wait_time = 0.1
	$Sprite.frame = 1
	timer.start()

func change_back():
	$Sprite.frame = 0
