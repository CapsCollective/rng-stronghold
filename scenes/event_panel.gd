extends Node2D

var resource_names = ["Food", "Water", "Wall", "Arms", "Influence"]

func _ready():
	hide()

func display_event(event):
	$TitleLabel.text = event["title"]
	$BodyLabel.text = event["flavour"]
	$SeverityLabel.text = "Severity: " + str(event["amount"])
	var name = resource_names[event["resource"]]
	$ResourceLabel.text = "Resource: " + name
