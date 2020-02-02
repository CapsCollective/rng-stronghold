extends Node2D

export (int) var amount

func display_event(event):
	$TitleLabel.text = event["title"]