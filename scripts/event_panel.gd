extends Control

func display_event(event):
	$TitleLabel.text = event["title"]
	$BodyLabel.text = event["flavour"]
	$SeverityLabel.text = "Severity: " + str(event["amount"])
	var name = $"../../".resource_names[event["resource"]]
	$ResourceLabel.text = "Resource: " + name
	show()
