#!/usr/bin/env -S godot -s
extends SceneTree

const validation_manager = preload("res://assets/validation/validation.gd")

func _init():
	var manager = validation_manager.new()
	var result = manager.run_all_validations()
	quit(0 if result else 1)
